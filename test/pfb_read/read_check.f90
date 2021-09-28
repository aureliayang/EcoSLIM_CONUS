program random_read
    implicit none
    character*200 fname
    integer:: nx,ny,nz
    real(8):: value(41,41,24)

    nx=41
    ny=41
    nz=24

    fname='../NLDAS.APCP.000001_to_000024.pfb'
    call pfb_read(value,fname,nx,ny,nz)

end