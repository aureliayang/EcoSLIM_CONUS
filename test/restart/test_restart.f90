module restart
    integer,parameter:: ppx = 2, qqy = 1, buff = 1
    integer,parameter:: nx_c = 41, ny_c = 41
    integer:: max_rank, map_sub,nind_c=1
    integer,allocatable:: t_GPUs(:),l_GPUs(:,:),c_GPU(:)
    integer:: np_active, pid
    character(20):: ranknum
    integer:: np = 20000000
    real(8),allocatable:: P(:,:)
contains
    subroutine read_grid_Zone()
        implicit none

        integer:: Zonet_new_c(-buff+1:nx_c+buff,-buff+1:ny_c+buff)
        integer:: grid_c(ppx*qqy,4),i,j

        open(18,file='EcoSLIM_restart.'//trim(adjustl(ranknum)),FORM='unformatted',access='stream')
            read(18) grid_c
            read(18) Zonet_new_c
            read(18) max_rank
            read(18) map_sub
            read(18) t_GPUs
            read(18) l_GPUs
            read(18) c_GPU
        close(18)

        ! grid = grid_c
        ! Zonet_new = Zonet_new_c
        write(*,'(2(4(i5,1x),/))') ((grid_c(i,j),j=1,4),i=1,ppx*qqy)
        write(*,'(43(43(i5,1x),/))') ((Zonet_new_c(i,j),i=0,nx_c+1),j=0,ny_c+1)

    end subroutine read_grid_Zone

    subroutine read_restarts ()

        implicit none

        write(11,*) 'Reading particle restart File: Particle_restart.'//trim(adjustl(ranknum))//'.bin'

        open(116,file='Particle_restart.'//trim(adjustl(ranknum))//'.bin',form='unformatted',access='stream')

        read(116) np_active
        read(116) pid

        if (np_active < np) then   ! check if we have particles left

            read(116) P(1:np_active,1:nind_c*2+17)
            close(116)

            write(11,*) 'RESTART np_active:', np_active
            write(11,*) 'RESTART pid:', pid

        else
            close(116)
            write(11,*) ' **Warning restart IC input but no paricles left'
            write(11,*) ' **Exiting code *not* (over)writing restart'
            stop
        end if

        ! P_de(1:np_active,:) = P(1:np_active,:)

    end subroutine read_restarts
end module restart

program test_restart
    use restart
    implicit none
    integer:: rank = 0

    write(ranknum,'(i5.5)') rank

    allocate(t_GPUs(ppx*qqy),l_GPUs(ppx*qqy,4),c_GPU(ppx*qqy))
    allocate(P(np,nind_c*2+17))

    call read_grid_Zone()

    print *, max_rank
    print *, map_sub
    print *, t_GPUs
    print *, l_GPUs
    print *, c_GPU

    call read_restarts()
    print *, np_active
    print *, pid

end program test_restart

