module subdomain_bound

    contains
    subroutine global_xyz(nx, ny, nz, dx, dy, dz, rank, &
        Xmin, Xmax, Ymin, Ymax, Zmin, Zmax, fh1, &
        loadf, restartf, exitedf, logf)

        use mpi
        implicit none

        integer:: nx, ny, nz, rank
        real(8):: dx, dy, dz(:)
        real(8):: Xmin, Xmax, Ymin, Ymax, Zmin, Zmax
        character(200):: loadf, restartf, exitedf, logf, message
        integer:: k, ierr, fh1

        ! set up domain boundaries
        Xmin = 0.0d0
        Ymin = 0.0d0
        Zmin = 0.0d0
        Xmax = dble(nx)*dx
        Ymax = dble(ny)*dy
        Zmax = 0.0d0
        do k = 1, nz
            Zmax = Zmax + dz(k)
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

        write(message,'("Xmin:",e12.5," Xmax:",e12.5,A)') Xmin, Xmax, NEW_LINE(' ')
        call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
        MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

        write(message,'("Ymin:",e12.5," Ymax:",e12.5,A)') Ymin, Ymax, NEW_LINE(' ')
        call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
        MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

        write(message,'("Zmin:",e12.5," Zmax:",e12.5,A)') Zmin, Zmax, NEW_LINE(' ')
        call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
        MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

    end subroutine global_xyz

    subroutine local_xyz(nnx1, nny1, nz, dx, dy, dz, buff, &
        Xmin, Xmax, Ymin, Ymax, Zmin, Zmax)
        use mpi
        implicit none

        integer:: nnx1, nny1, nz, k
        real(8):: dx, dy, dz(:), buff
        real(8):: Xmin, Xmax, Ymin, Ymax, Zmin, Zmax

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

    end subroutine local_xyz

    subroutine DEM_for_visual(DEM,DEMname,ix1,iy1,nnx1,nny1,nz)

        use hdf5_file_read

        implicit none

        real(8):: DEM(:,:)  !allocated in main
        character(200):: DEMname
        integer:: ix1, iy1, nnx1, nny1, nz
        integer:: nnx, nny, nnz, npnts
        real(8):: Z, maxZ, Zt(:), Pnts(:,:)
        integer:: ik, m, i, j, k, ii, jj

        !----------------------------
        DEM = 0.0d0
        ! read in DEM
        ! fname = trim(adjustl(DEMname))
        ! call pfb_read(DEM,fname,nx,ny,nztemp)
        if (DEMname /= '') &
        call read_files(DEM,ix1,iy1,nnx1,nny1,nz)

        !----------------------------
        ! grid +1 variables, for DEM part
        nnx = nnx1 + 1
        nny = nny1 + 1
        nnz = nz + 1

        ! Set up grid locations for file output
        npnts = nnx*nny*nnz

        allocate(Pnts(npnts,3),Zt(0:nz))
        Pnts = 0
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
        do k=1,nnz
            do j=1,nny
                do i=1,nnx
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
                    Pnts(m,3) = (DEM(ii,jj) - maxZ) + Zt(k-1)
                    m = m + 1
                end do
            end do
        end do
    end subroutine DEM_for_visual

    subroutine read_restarts (fh1,fh2,rank,restartf,np,nind,P)
        use mpi
        implicit none

        integer,intent(in):: fh1, rank, np, nind
        integer,intent(out):: fh2, np_active, pid
        integer:: ierr
        character(200):: restartf, message
        real(8),intent(out):: P(:,:)

        write(message,'(a,a,i3.3,a,a)') 'Reading particle restart File:', &
        'Particle_restart.',rank,'.bin',new_line(' ')
        call MPI_FILE_WRITE(fh1, trim(message), len(trim(message)), &
                            MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

        ! read in full particle array as binary restart file, should name change?,
        ! potential overwrite confusion
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
    end subroutine read_restarts
end module subdomain_bound