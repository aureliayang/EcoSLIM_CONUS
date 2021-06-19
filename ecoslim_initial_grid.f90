module create_subdomain
    use cudafor
    integer,parameter:: buff = 1
    !Buffer can be specified by user, for GW 1km or 2km is enough
    !1 km spatial resolution
    integer:: nnx1,nny1,nnx2,nny2,ix1,iy1,ix2,iy2
    integer,allocatable,pinned:: Zone(:,:)
contains
    subroutine gridinfo(nx,ny,ppx,qqy,rank)
        implicit none
        integer::nx,ny,ppx,qqy,rank !,buff
        integer::indexx,indexy
        !integer::nnx1,nny1,nnx2,nny2,ix1,iy1,ix2,iy2
        !integer,allocatable::zone(:,:)

        !nx, ny are the global dimension
        !ppx and qqy are the decoposition topology, P and Q in x and y direction
        !rank is the MPI rank
        !indexx and indexy only used in this subroutine. They help to calculate the
        !index of subdomain which match the MPI rank (please refer to slides).
        !--------------------------------------
        !ppx>1, qqy>1, nx/ppx>2*buff ny/qqy>2*buff
        !nx>10, ny>10, buff=1 .or. 2

        !--------------------------------------
        !!!local dimension and global index for subdomain without buffer
        !--------------------------------------
        indexx=mod(rank,ppx)+1
        indexy=rank/ppx+1

        nnx1=(nx + ppx - mod(nx,ppx)) / ppx
        nny1=(ny + qqy - mod(ny,qqy)) / qqy
        ix1=(indexx-1)*nnx1
        iy1=(indexy-1)*nny1
        if(indexx == ppx) nnx1 = nx - ix1
        if(indexy == qqy) nny1 = ny - iy1
        !nnx1 and nny1 are block size or subdomain dimension
        !For example, if it is 14 using P = 3, then it should be 5,5,4
        !ix1 and iy1 are the global index for each block

        !--------------------------------------
        !!!Eastablish the neighbor list
        !--------------------------------------
        allocate(zone(-buff+1:nnx1+buff,-buff+1:nny1+buff))
        zone = -1
        !If doing dynamic decompostition, one should deallocate zone first

        if(ix1>0 .and. iy1>0) &
        zone(-buff+1:0,-buff+1:0)=rank-ppx-1
        !the lower left corner
        !So nnx1 >> buff, as describe above, nx/ppx>2*buff.
        !If ppx = 2 and buff = 2, nx is no less than 10.
        !So if ix1>0, it expects ix1-buff > 0. Otherwise, there will
        !be unexpected problem. The same for y direction.

        if(iy1>0) &
        zone(1:nnx1,-buff+1:0)=rank-ppx
        !the bottom line
        if(ix1+nnx1<nx .and. iy1>0) &
        zone(nnx1+1:nnx1+buff,-buff+1:0)=rank-ppx+1
        !the lower right corner

        if(ix1>0) &
        zone(-buff+1:0,1:nny1)=rank-1
        zone(1:nnx1,1:nny1)=rank
        !the left line and the center

        if(ix1+nnx1<nx) &
        zone(nnx1+1:nnx1+buff,1:nny1)=rank+1
        !the right line

        if(iy1+nny1<ny .and. ix1>0) &
        zone(-buff+1:0,nny1+1:nny1+buff)=rank+ppx-1
        !the upper left corner

        if(iy1+nny1<ny) &
        zone(1:nnx1,nny1+1:nny1+buff)=rank+ppx
        !the top line

        if(ix1+nnx1<nx .and. iy1+nny1<ny) &
        zone(nnx1+1:nnx1+buff,nny1+1:nny1+buff)=rank+ppx+1
        !the upper right corner

        !--------------------------------------
        !!!local and global for subdomain with buffer
        !--------------------------------------
        if(ix1>0) then
            ix2=ix1-buff
            nnx2=nnx1+buff
        else
            ix2=ix1
            nnx2=nnx1
        endif
        if(ix1+nnx1<nx) nnx2=nnx2+buff

        if(iy1>0) then
            iy2=iy1-buff
            nny2=nny1+buff
        else
            iy2=iy1
            nny2=nny1
        endif
        if(iy1+nny1<ny) nny2=nny2+buff

    end subroutine gridinfo
end module create_subdomain
