program test_comm
    use mpi
    implicit none

    integer:: rank, t_rank, ierr, status(MPI_STATUS_SIZE) ! used for MPI
    integer:: world_group, work_group, manage_group, manage_ranks(1)
    integer:: work_comm, manage_comm
    real(8):: PET_balance(2)

    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, t_rank, ierr)

    call MPI_COMM_GROUP(MPI_COMM_WORLD, world_group, ierr)
    manage_ranks = 5 ! only one rank used to manage
    call MPI_GROUP_EXCL(world_group, 1, manage_ranks, work_group, ierr)
    call MPI_GROUP_INCL(world_group, 1, manage_ranks, manage_group, ierr)
    call MPI_COMM_CREATE(MPI_COMM_WORLD, work_group, work_comm, ierr)
    call MPI_COMM_CREATE(MPI_COMM_WORLD, manage_group, manage_comm, ierr)

    PET_balance = 1.
    ! call MPI_ALLReduce(MPI_IN_PLACE, PET_balance, 2,MPI_DOUBLE_PRECISION,MPI_SUM,MPI_COMM_WORLD,ierr)
    if(rank /= 5 ) call MPI_ALLReduce(MPI_IN_PLACE, PET_balance, 2,MPI_DOUBLE_PRECISION,MPI_SUM,work_comm,ierr)

    print *, 'rank', rank, PET_balance

    call MPI_FINALIZE(ierr)
end program test_comm