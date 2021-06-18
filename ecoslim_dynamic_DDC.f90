module create_subgrid
    integer::ix1,iy1,nnx1,nny1,ppx,qqy
    integer,allocatable::grid(:,:)
contains
    subroutine gridinfo(nx,ny)
        implicit none
        integer::nx,ny
        integer::i,j,ncount
        integer::nnx(ppx),nny(qqy)

        nnx(:) = nx/ppx
        do i = 1, ppx
            if(i <= mod(nx,ppx)) nnx(i) = nnx(i) + 1
        enddo

        nny(:) = ny/qqy
        do j = 1, qqy
            if(j <= mod(ny,qqy)) nny(j) = nny(j) + 1
        enddo

        ncount=0
        do j = 1, qqy
            do i = 1, ppx
                ncount = ncount + 1
                grid(ncount,1) = sum(nnx(1:i-1))
                grid(ncount,2) = sum(nny(1:j-1))
                grid(ncount,3) = nnx(i)
                grid(ncount,4) = nny(j)
            end do
        end do

    end subroutine gridinfo

    subroutine gridinfo2(nx,ny,rank)
        implicit none
        integer::nx,ny,rank
        integer::indexx,indexy

        indexx=mod(rank,ppx)+1
        indexy=rank/ppx+1

        nnx1=nx/ppx
        nny1=ny/qqy

        if(indexx<=mod(nx,ppx)) then
            nnx1=nnx1+1
            ix1=(indexx-1)*nnx1
        else
            ix1=mod(nx,ppx)*(nnx1+1)+(indexx-mod(nx,ppx)-1)*nnx1
        endif

        if(indexy<=mod(ny,qqy)) then
            nny1=nny1+1
            iy1=(indexy-1)*nny1
        else
            iy1=mod(ny,qqy)*(nny1+1)+(indexy-mod(ny,qqy)-1)*nny1
        endif

    end subroutine gridinfo2

    subroutine grid_PME(nx,ny,nz,pname,pft1,pft2,iflux_p_res,PME_tot)
        implicit none
        integer:: nx,ny,nz,PME_tot(:,:,:)
        real(8):: PME_sub(nx,ny,nz)
        integer:: pft1,pft2,pfkk,iflux_p_res
        character(200):: fname, filenum, pname

        PME_tot = 0   !new arrays in module should be allocated in main
        PME_sub = 0.d0
        !Here is OK. No matter the frequency, we should set them 0 when call.

        do pfkk = pft1, pft2
            write(filenum,'(i5.5)') pfkk
            fname=trim(adjustl(pname))//'.out.evaptrans.'//trim(adjustl(filenum))//'.pfb'
            call pfb_read(PME_sub,fname,nx,ny,nz)
            where (PME_sub(:,:,nz) > 0.d0) PME_tot(:,:,1) = PME_tot(:,:,1) + iflux_p_res
        enddo

    end subroutine grid_PME

    subroutine grid_adjust(nx,ny,nz,PME_tot)
        !Now it is x then y. If only x or y, please be careful.
        implicit none
        integer,intent(in)::nx,ny,nz,PME_tot(:,:,:)
        integer::nlev,dir,sub_tp,sub_lp
        integer::ix2,iy2,nnx2,nny2
        integer::i,j,k,n

        grid = 0
        grid(1,1) = 0;  grid(1,2) = 0
        grid(1,3) = nx; grid(1,4) = ny

        dir=1; if(qqy>ppx) dir=-1

        nlev=idnint(dlog(dble(ppx*qqy))/dlog(2.d0))

        do i=1,nlev

            do j=1,2**(i-1)

                ix2=grid(j,1);  iy2=grid(j,2)
                nnx2=grid(j,3); nny2=grid(j,4)
                n=2**(i-1)+j

                select case (dir)
                case(1)
                    sub_tp=sum(PME_tot(ix2+1:ix2+nnx2,iy2+1:iy2+nny2,1:nz))
                    k=1
                    sub_lp=sum(PME_tot(ix2+k,iy2+1:iy2+nny2,1:nz))
                    !if(sub_lp >= sub_tp/2) print *, 'domain too small/uneven to divide, &
                    !only one column in the left, program stopped'
                    !stop
                    do
                        if (sub_lp >= sub_tp/2) then
                            grid(j,1)=ix2;  grid(n,1)=ix2+k
                            grid(j,2)=iy2;  grid(n,2)=iy2
                            grid(j,3)=k;    grid(n,3)=nnx2-k
                            grid(j,4)=nny2; grid(n,4)=nny2
                            exit
                        else
                            k=k+1
                            !if(k==nnx2-1) print *, 'domain too small/uneven to divide, &
                            !only one column in the right, program stopped'
                            !stop
                            sub_lp=sub_lp+sum(PME_tot(ix2+k,iy2+1:iy2+nny2,1:nz))
                        endif
                    enddo
                case(-1)
                    sub_tp=sum(PME_tot(ix2+1:ix2+nnx2,iy2+1:iy2+nny2,1:nz))
                    k=1
                    sub_lp=sum(PME_tot(ix2+1:ix2+nnx2,iy2+k,1:nz))
                    !if(sub_lp >= sub_tp/2) print *, 'domain too small/uneven to divide, &
                    !only one row in the bottom, program stopped'
                    !stop
                    do
                        if (sub_lp >= sub_tp/2) then
                            grid(j,1)=ix2;  grid(n,1)=ix2
                            grid(j,2)=iy2;  grid(n,2)=iy2+k
                            grid(j,3)=nnx2; grid(n,3)=nnx2
                            grid(j,4)=k;    grid(n,4)=nny2-k
                            exit
                        else
                            k=k+1
                            !if(k==nny2-1) print *, 'domain too small/uneven to divide, &
                            !only one row in the top, program stopped'
                            !stop
                            sub_lp=sub_lp+sum(PME_tot(ix2+1:ix2+nnx2,iy2+k,1:nz))
                        endif
                    enddo
                end select
            enddo

            !dir=-dir
            if(min(ppx,qqy) > 1) dir = -dir

        enddo

    end subroutine grid_adjust

    subroutine grid_adjust2(nx,ny,nz,PME_tot)
        !dichotomizing search
        implicit none
        integer,intent(in)::nx,ny,nz,PME_tot(:,:,:)
        integer::nlev,dir,sub_tp,sub_lp,sub_lp1,sub_lp2
        integer::ix2,iy2,nnx2,nny2
        integer::i,j,n,lef,mid,rig,done

        grid = 0
        grid(1,1) = 0;  grid(1,2) = 0
        grid(1,3) = nx; grid(1,4) = ny

        dir=1; if(qqy>ppx) dir=-1

        nlev=idnint(dlog(dble(ppx*qqy))/dlog(2.d0))

        do i=1,nlev

            do j=1,2**(i-1)

                ix2=grid(j,1);  iy2=grid(j,2)
                nnx2=grid(j,3); nny2=grid(j,4)
                n=2**(i-1)+j
                done = 0

                select case (dir)
                case(1)
                    sub_tp=sum(PME_tot(ix2+1:ix2+nnx2,iy2+1:iy2+nny2,1:nz))
                    lef = 0; rig = nnx2; mid = (lef+rig)/2
                    sub_lp=sum(PME_tot(ix2+1:ix2+mid,iy2+1:iy2+nny2,1:nz))
                    sub_lp1=sum(PME_tot(ix2+1:ix2+mid-1,iy2+1:iy2+nny2,1:nz))
                    sub_lp2=sum(PME_tot(ix2+1:ix2+mid+1,iy2+1:iy2+nny2,1:nz))
                    do
                        if(sub_lp == sub_tp/2)then
                            done = 1
                        elseif (sub_lp > sub_tp/2) then
                            if(sub_lp1 < sub_tp/2) then
                                done = 1
                            elseif(sub_lp1 == sub_tp/2) then
                                done = 1; mid = mid - 1
                            else
                                rig = mid; mid = (rig+lef)/2
                            endif
                        elseif (sub_lp < sub_tp/2) then
                            if(sub_lp2 >= sub_tp/2) then
                                done = 1; mid = mid + 1
                            else
                                lef = mid; mid = (rig+lef)/2
                            endif
                        endif
                        if(done == 1) then
                            grid(j,1)=ix2;  grid(n,1)=ix2+mid
                            grid(j,2)=iy2;  grid(n,2)=iy2
                            grid(j,3)=mid;  grid(n,3)=nnx2-mid
                            grid(j,4)=nny2; grid(n,4)=nny2
                            exit
                        endif
                        sub_lp=sum(PME_tot(ix2+1:ix2+mid,iy2+1:iy2+nny2,1:nz))
                        sub_lp1=sum(PME_tot(ix2+1:ix2+mid-1,iy2+1:iy2+nny2,1:nz))
                        sub_lp2=sum(PME_tot(ix2+1:ix2+mid+1,iy2+1:iy2+nny2,1:nz))
                    enddo
                case(-1)
                    sub_tp=sum(PME_tot(ix2+1:ix2+nnx2,iy2+1:iy2+nny2,1:nz))
                    lef = 0; rig = nny2; mid = nny2/2
                    sub_lp=sum(PME_tot(ix2+1:ix2+nnx2,iy2+1:iy2+mid,1:nz))
                    sub_lp1=sum(PME_tot(ix2+1:ix2+nnx2,iy2+1:iy2+mid-1,1:nz))
                    sub_lp2=sum(PME_tot(ix2+1:ix2+nnx2,iy2+1:iy2+mid+1,1:nz))
                    do
                        if(sub_lp == sub_tp/2)then
                            done = 1
                        elseif (sub_lp > sub_tp/2) then
                            if(sub_lp1 < sub_tp/2) then
                                done = 1
                            elseif(sub_lp1 == sub_tp/2)then
                                done = 1; mid = mid - 1
                            else
                                rig = mid; mid = (lef+rig)/2
                            endif
                        elseif (sub_lp < sub_tp/2) then
                            if(sub_lp2 >= sub_tp/2) then
                                done = 1; mid = mid + 1
                            else
                                lef = mid; mid = (lef+rig)/2
                            endif
                        endif
                        if(done == 1) then
                            grid(j,1)=ix2;  grid(n,1)=ix2
                            grid(j,2)=iy2;  grid(n,2)=iy2+mid
                            grid(j,3)=nnx2; grid(n,3)=nnx2
                            grid(j,4)=mid;  grid(n,4)=nny2-mid
                            exit
                        endif
                        sub_lp=sum(PME_tot(ix2+1:ix2+nnx2,iy2+1:iy2+mid,1:nz))
                        sub_lp1=sum(PME_tot(ix2+1:ix2+nnx2,iy2+1:iy2+mid-1,1:nz))
                        sub_lp2=sum(PME_tot(ix2+1:ix2+nnx2,iy2+1:iy2+mid+1,1:nz))
                    enddo
                end select
            enddo

            !dir=-dir
            if(min(ppx,qqy) > 1) dir = -dir

        enddo

    end subroutine grid_adjust2
end module create_subgrid
