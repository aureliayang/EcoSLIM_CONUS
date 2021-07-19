program test_mod
    implicit none
    integer:: i, j, nnx1, nny1, buff=1, ii, dd(4), rank=0
    integer,allocatable:: zone(:,:)

    nnx1=4
    nny1=4
    allocate(zone(-buff+1:nnx1+buff,-buff+1:nny1+buff))
    zone(0,:) =[-1,-1,-1,-1,-1,-1]
    zone(1,:) =[-1,0,0,0,0,2]
    zone(2,:) =[-1,0,0,0,0,2]
    zone(3,:) =[-1,0,0,0,0,2]
    zone(4,:) =[-1,0,0,0,0,2]
    zone(5,:) =[-1,1,1,1,1,3]

    do ii = 1,(nnx1+2*buff)*(nny1+2*buff)
        if(mod(ii, nnx1 + 2*buff) == 0) then
            j = ii/(nnx1 + 2*buff) - buff
            i = nnx1 + buff
        else
            j = ii/(nnx1 + 2*buff) - buff + 1
            i = mod(ii,nnx1 + 2*buff) - buff
        end if

        if(zone(i,j) >= 0 .and. zone(i,j) /= rank) then
            dd(zone(i,j)+1) =1
        end if

    end do

    print *,dd


end program test_mod