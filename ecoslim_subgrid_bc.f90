module subgrid_bound
    real*8 Xmin, Xmax, Ymin, Ymax, Zmin, Zmax
        ! Domain boundaries in local / grid coordinates. min values set to zero,
        ! DEM is read in later to output to Terrain Following Grid used by ParFlow.
    contains
    subroutine subgrid_max_xyz(nnx1,nny1,nz,dx,dy,dz,buff,fhandle1)
        use mpi
        implicit none
        integer:: nnx1, nny1, nz, buff, fhandle1
        real(8):: dx, dy, dz(:)
        character(len=MPI_MAX_PROCESSOR_NAME):: message
        integer:: k, ierr

        !set up domain boundaries
        Xmin = -dble(buff)*dx
        Ymin = -dble(buff)*dy
        Zmin = 0.0d0
        Xmax = dble(nnx1)*dx + dble(buff)*dx
        Ymax = dble(nny1)*dy + dble(buff)*dy
        Zmax = 0.0d0
        do k = 1, nz
            Zmax = Zmax + dz(k)
        end do

        write(message,'(A)') NEW_LINE(' ')
        call MPI_FILE_WRITE(fhandle1, trim(message), len(trim(message)), &
        MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

        write(message,'(A,A)') '## Domain Info', NEW_LINE(' ')
        call MPI_FILE_WRITE(fhandle1, trim(message), len(trim(message)), &
        MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

        write(message,'("Xmin:",e12.5," Xmax:",e12.5,A)') Xmin, Xmax, NEW_LINE(' ')
        call MPI_FILE_WRITE(fhandle1, trim(message), len(trim(message)), &
        MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

        write(message,'("Ymin:",e12.5," Ymax:",e12.5,A)') Ymin, Ymax, NEW_LINE(' ')
        call MPI_FILE_WRITE(fhandle1, trim(message), len(trim(message)), &
        MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

        write(message,'("Zmin:",e12.5," Zmax:",e12.5,A)') Zmin, Zmax, NEW_LINE(' ')
        call MPI_FILE_WRITE(fhandle1, trim(message), len(trim(message)), &
        MPI_CHARACTER, MPI_STATUS_IGNORE, ierr)

    end subroutine subgrid_max_xyz
end module subgrid_bound