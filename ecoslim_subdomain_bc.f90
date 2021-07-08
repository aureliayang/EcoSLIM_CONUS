module subdomain_bound
    ! subroutine global_xyz
    ! subroutine local_xyz
    ! subroutine DEM_for_visual
    ! subroutine read_restarts

    use variable_list, only: ppx, qqy, rank, buff
    use variable_list, only: nx, ny, nz
    use variable_list, only: dx, dy, dz
    use variable_list, only: Xgmin, Xgmax, Ygmin, Ygmax, Zgmin, Zgmax
    use variable_list, only: Xmin, Xmax, Ymin, Ymax, Zmin, Zmax
    use variable_list, only: loadf, restartf, exitedf, logf
    use variable_list, only: fh1, fh2
    use variable_list, only: ix1, iy1, nnx1, nny1
    use variable_list, only: DEM, DEMname, fname, Pnts
    use variable_list, only: np, nind, np_active, pid
    use variable_list, only: P

contains
    subroutine global_xyz()
        ! get the boundary of the whole domain.
        ! set the name of log files
        ! open loadf (fh1) and output the domain boundary to loadf

        ! loadf (fh1) looks like the log file, recodring all the warning info
        ! restartf (fh2) is used to read and write restart files
        ! exitedf (fh3) is to write files of exited particles, it includes particles for all timesteps.
        ! logf (fh4) is also log file to record the summary of particles of every timestep

        use mpi
        implicit none
        character(200):: message
        integer:: k, ierr

        if (rank /= ppx*qqy) then
            ! set up domain boundaries
            Xgmin = 0.0d0
            Ygmin = 0.0d0
            Zgmin = 0.0d0
            Xgmax = dble(nx)*dx
            Ygmax = dble(ny)*dy
            Zgmax = 0.0d0
            do k = 1, nz
                Zgmax = Zgmax + dz(k)
            end do

            write(loadf,'(a,i3.3,a)') 'Load_info.', rank, '.txt'
            write(restartf,'(a,i3.3,a)') 'Particle_restart.',rank,'.bin'
            write(exitedf,'(a,i3.3,a)') 'Exited_particles.',rank,'.bin'
            write(logf,'(a,i3.3,a)') 'Log_particles.',rank,'.txt'

            call MPI_FILE_OPEN(MPI_COMM_SELF,loadf,MPI_MODE_WRONLY+MPI_MODE_CREATE, &
            MPI_INFO_NULL,fh1,ierr)

            write(message,'(A)') NEW_LINE(' ')
            call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
            MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

            write(message,'(A,A)') '## Domain Info', NEW_LINE(' ')
            call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
            MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

            write(message,'("Xmin:",e12.5," Xmax:",e12.5,A)') Xgmin, Xgmax, NEW_LINE(' ')
            call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
            MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

            write(message,'("Ymin:",e12.5," Ymax:",e12.5,A)') Ygmin, Ygmax, NEW_LINE(' ')
            call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
            MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

            write(message,'("Zmin:",e12.5," Zmax:",e12.5,A)') Zgmin, Zgmax, NEW_LINE(' ')
            call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
            MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

        endif

    end subroutine global_xyz

    subroutine local_xyz()
        implicit none
        integer:: k

        if (rank /= ppx*qqy) then
            ! set up subdomain boundaries
            Xmin = -dble(buff)*dx
            Ymin = -dble(buff)*dy
            Zmin = 0.0d0
            Xmax = dble(nnx1)*dx + dble(buff)*dx
            Ymax = dble(nny1)*dy + dble(buff)*dy
            Zmax = 0.0d0
            do k = 1, nz
                Zmax = Zmax + dz(k)
            end do
            ! need output to log file
            ! return the global and local info of the subdomain
            ! add grid info to log file
            ! write(message,'(a,a,i5,a,4(i10,1x),a)') new_line(' '),'rank:',rank, &
            ! ', Gridinfo (ix1,iy1,nnx1,nny1):',grid(rank+1,1:4),new_line(' ')
            ! call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
            ! MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)
        end if
    end subroutine local_xyz

    subroutine DEM_visual()

        use hdf5_file_read
        implicit none

        integer:: nnx, nny, nnz, npnts
        real(8):: Z, maxZ
        real(8),allocatable:: Zt(:)
        integer:: m, i, j, k, ik, ii, jj

        !----------------------------
        DEM = 0.0d0
        fname = trim(adjustl(DEMname))
        if (DEMname /= '') call read_h5_file(DEM,4)

        !----------------------------
        ! grid +1 variables, for DEM part
        nnx = nnx1 + 1
        nny = nny1 + 1
        nnz = nz + 1

        ! Set up grid locations for file output
        npnts = nnx*nny*nnz

        allocate(Pnts(npnts,3),Zt(0:nz))
        Pnts = 0.d0
        m = 1

        ! Need the maximum height of the model and elevation locations
        Z = 0.0d0
        Zt(0) = 0.0d0
        do ik = 1, nz
            Z = Z + dz(ik)
            Zt(ik) = Z
            ! print*, Z, dz(ik), Zt(ik), ik
        end do
        maxZ = Z

        ! candidate loops for OpenMP
        do k = 1, nnz
            do j = 1, nny
                do i = 1, nnx
                    Pnts(m,1) = DBLE(i-1)*dx
                    Pnts(m,2) = DBLE(j-1)*dy
                    ! This is a simple way of handling the maximum edges
                    if (i <= nnx1) then
                        ii = i
                    else
                        ii = nnx1
                    endif
                    if (j <= nny1) then
                        jj = j
                    else
                        jj = nny1
                    endif
                    ! This step translates the DEM
                    ! The specified initial heights in the pfb (z1) are ignored and the
                    ! offset is computed based on the model thickness
                    Pnts(m,3) = (DEM(ii,jj,1) - maxZ) + Zt(k-1)
                    m = m + 1
                end do
            end do
        end do

        deallocate(Zt)

    end subroutine DEM_visual

    subroutine read_restarts ()
        use mpi
        implicit none

        integer:: ierr
        character(200):: message

        if (rank /= ppx*qqy) then

            write(message,'(a,a,i3.3,a,a)') 'Reading particle restart File:', &
            'Particle_restart.',rank,'.bin',new_line(' ')
            call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
                                MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

            call MPI_FILE_OPEN(MPI_COMM_SELF,restartf,MPI_MODE_RDONLY, &
                                MPI_INFO_NULL,fh2,ierr)

            call MPI_FILE_READ(fh2,np_active,1,MPI_INTEGER,MPI_STATUS_IGNORE,ierr)
            call MPI_FILE_READ(fh2,pid,1,MPI_INTEGER,MPI_STATUS_IGNORE,ierr)

            if (np_active < np) then   ! check if we have particles left
                call MPI_FILE_READ(fh2,P(1:np_active,1:nind*2+17),np_active*(nind*2+17), &
                                    MPI_DOUBLE_PRECISION,MPI_STATUS_IGNORE,ierr)
                call MPI_FILE_CLOSE(fh2, ierr)

                write(message,'(a,i10.10,a)') 'RESTART np_active:',np_active,new_line(' ')
                call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
                                    MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)
                write(message,'(a,i10.10,a)') 'RESTART pid:',pid,new_line(' ')
                call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
                                    MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)
            else
                call MPI_FILE_CLOSE(fh2, ierr)
                write(message,'(A,A)') ' **Warning restart IC input but no paricles left',new_line(' ')
                call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
                                    MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)
                write(message,'(A,A)') ' **Exiting code *not* (over)writing restart',new_line(' ')
                call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
                                    MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)
                stop
            end if

        end if
    end subroutine read_restarts
end module subdomain_bound