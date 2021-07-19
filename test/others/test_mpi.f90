program test_mpi
    use mpi
    implicit none
    integer:: rank, t_rank, ierr, status(MPI_STATUS_SIZE) ! used for MPI
    integer:: world_group, work_group, manage_group, manage_ranks(1)
    integer:: work_comm, manage_comm
    integer:: ppx, qqy

    call MPI_INIT(ierr)
    call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierr)
    call MPI_COMM_SIZE(MPI_COMM_WORLD, t_rank, ierr)

    call MPI_COMM_GROUP(MPI_COMM_WORLD, world_group, ierr)
    manage_ranks(1) = ppx*qqy ! only one rank used to manage
    call MPI_GROUP_EXCL(world_group, 1, manage_ranks, work_group, ierr)
    call MPI_GROUP_INCL(world_group, 1, manage_ranks, manage_group, ierr)
    call MPI_COMM_CREATE(MPI_COMM_WORLD, work_group, work_comm, ierr)
    call MPI_COMM_CREATE(MPI_COMM_WORLD, manage_group, manage_comm, ierr)

    call MPI_FINALIZE(ierr)
end program