     PROGRAM H5_SUBSET

     USE HDF5 ! This module contains all necessary modules

     IMPLICIT NONE

     CHARACTER(200) :: filename
     CHARACTER(200) :: pname, pfbname, filenum, varn ! File name
     CHARACTER(LEN=9), PARAMETER :: dsetname = 'hdf5_data'  ! Dataset name

     INTEGER(HID_T) :: file_id       ! File identifier
     INTEGER(HID_T) :: dset_id       ! Dataset identifier
     INTEGER(HID_T) :: dataspace     ! Dataspace identifier
     INTEGER(HID_T) :: memspace      ! memspace identifier

     INTEGER(HSIZE_T), DIMENSION(3) :: dimsf
     INTEGER(HSIZE_T), DIMENSION(3) :: data_dims

     real(8), allocatable :: data(:,:,:)    ! Data to write
     INTEGER :: rank = 3      ! Dataset rank ( in file )
     INTEGER :: i, j
     INTEGER :: nx, ny, nz, pfkk
     INTEGER :: error         ! Error flag

     INTEGER(HSIZE_T), DIMENSION(3) :: count = (/4,3,1/)  ! Size of hyperslab
     INTEGER(HSIZE_T), DIMENSION(3) :: offset = (/0,0,49/) ! Hyperslab offset
     INTEGER(HSIZE_T), DIMENSION(3) :: stride = (/1,1,1/) ! Hyperslab stride
     INTEGER(HSIZE_T), DIMENSION(3) :: block = (/1,1,1/)  ! Hyperslab block size
     real(8):: sdata(4,3,1)

     nx = 41
     ny = 41
     nz = 50
     pname = './Outputs/LW'
     varn = 'satur.'

     allocate(data(nx,ny,nz))

     do pfkk = 0, 10

        write(filenum,'(i5.5)') pfkk
        pfbname=trim(adjustl(pname))//'.out.'//trim(adjustl(varn))//trim(adjustl(filenum))//'.pfb'
        call pfb_read(data,pfbname,nx,ny,nz)
        filename='./h5_files/LW.out.'//trim(adjustl(varn))//trim(adjustl(filenum))//'.h5'

        print *, 'pfkk', pfkk
        print *, data(1:4,1:3,50)

        CALL h5open_f(error)
        CALL h5fcreate_f(filename, H5F_ACC_TRUNC_F, file_id, error)
        dimsf(1) = nx
        dimsf(2) = ny
        dimsf(3) = nz
        CALL h5screate_simple_f(rank, dimsf, dataspace, error)
        CALL h5dcreate_f(file_id, dsetname, H5T_NATIVE_DOUBLE, dataspace, &
                        dset_id, error)

        data_dims = dimsf
        CALL h5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, data, data_dims, error)

        CALL h5sclose_f(dataspace, error)
        CALL h5dclose_f(dset_id, error)
        CALL h5fclose_f(file_id, error)

        CALL h5fopen_f(filename, H5F_ACC_RDWR_F, file_id, error)
        CALL h5dopen_f(file_id, dsetname, dset_id, error)
        CALL h5dget_space_f(dset_id, dataspace, error)
        CALL h5sselect_hyperslab_f(dataspace, H5S_SELECT_SET_F, &
                                    offset, count, error, stride, block)
        data_dims(1) = 4
        data_dims(2) = 3
        data_dims(3) = 1
        CALL h5screate_simple_f(rank, data_dims, memspace, error)

        CALL h5dread_f(dset_id, H5T_NATIVE_DOUBLE, sdata, data_dims, error, &
                        memspace, dataspace)

        print *, sdata

        CALL h5sclose_f(dataspace, error)
        CALL h5sclose_f(memspace, error)
        CALL h5dclose_f(dset_id, error)
        CALL h5fclose_f(file_id, error)

     end do

     CALL h5close_f(error)

     END PROGRAM H5_SUBSET
