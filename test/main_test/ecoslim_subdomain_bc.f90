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
    use variable_list, only: loadf, restartf, exitedf, logf, ranknum
    use variable_list, only: fh1, fh2
    use variable_list, only: ix1, iy1, nnx1, nny1, ix2, iy2, nnx2, nny2
    use variable_list, only: DEM, DEMname, fname, Pnts
    use variable_list, only: np, nind, np_active, pid
    use variable_list, only: P, grid, Zone_de, Zonet_new

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

            write(loadf,'(a,i5.5,a)') 'Load_info.', rank, '.txt'
            write(restartf,'(a,i5.5,a)') 'Particle_restart.',rank,'.bin'
            write(exitedf,'(a,i5.5,a)') 'Exited_particles.',rank,'.bin'
            write(logf,'(a,i5.5,a)') 'Log_particles.',rank,'.txt'

            call MPI_FILE_OPEN(MPI_COMM_SELF,loadf,MPI_MODE_WRONLY+MPI_MODE_CREATE, &
            MPI_INFO_NULL,fh1,ierr)

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

            ! read topology
            open(17,file='topology_restart.'//trim(adjustl(ranknum)),FORM='unformatted',access='stream')
                read(17) ix1, iy1, nnx1, nny1, ix2, iy2, nnx2, nny2
            close(17)  ! Topology
        else
            open(19,file='manager_grid_zonet_new', FORM='unformatted',access='stream')
                read(19) grid
                read(19) Zonet_new
            close(19)  ! manager
        end if
    end subroutine read_restarts

    subroutine read_Zone_de()
        implicit none

        if (rank /= ppx*qqy) then
            write(ranknum,'(i5.5)') rank
            open(18,file='Zone_de_restart.'//trim(adjustl(ranknum)),FORM='unformatted',access='stream')
                read(18) Zone_de
            close(18)  ! Zone_de
        endif

    end subroutine read_Zone_de

end module subdomain_bound