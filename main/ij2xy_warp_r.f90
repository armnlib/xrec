  subroutine ij2xy_warp_r(x, y, eta_r, p0, ptop, pref, rcoef, coord, ni, nj, ideb, jdeb, ifin, jfin, xdeb, ydeb, xfin, yfin)
  implicit none
  integer, parameter :: lineaire = 1
  integer, parameter :: logar    = 2
  integer ni, nj, ideb, jdeb, ifin, jfin, coord
  real xdeb, ydeb, xfin, yfin, x(ideb:ifin,jdeb:jfin), y(ideb:ifin,jdeb:jfin), p0(ni), eta_r(nj), eta(nj)
  real rhox, rhoy,psurf,p_ij,ptop, pref, rcoef, pupper, plower, ptarget
  real ln_p_ij, ln_plower, ln_pupper, ln_psurf, ln_ptarget, term_b(nj)
  integer i,j,ix, iy_cur
  real :: p_hyb
  external p_hyb
  rhox = (1.0 * (ifin - ideb)) / (xfin - xdeb)
  if (coord == lineaire) then
    rhoy = (1.0 * (jfin - jdeb)) / (yfin - ydeb)
  else
    rhoy = (1.0 * (jfin - jdeb)) / (log(yfin) - log(ydeb))
  endif
  do j=1,nj
    eta(nj-j+1) = eta_r(j)
  enddo
  do j=1,nj
    term_b(j) = ((eta(j) - ptop/pref)/(1.0-ptop/pref))**rcoef
  enddo
  do i=ideb, ifin
    iy_cur = nj
    if (coord == lineaire) then
      do j=jfin, jdeb+1, -1
        x(i,j) = (1.0*(i-ideb) / rhox) + xdeb
        ix = int(x(i,j))
        psurf = p0(ix) + (p0(ix+1)-p0(ix))*(x(i,j)-real(ix))
        p_ij = yfin - (1.0*(jfin-j) / rhoy)
        if (p_ij >= psurf) then
          y(i,j) = 0.0
        else
          ptarget = pref*(eta(iy_cur)-term_b(iy_cur)) + term_b(iy_cur)*psurf
          do while ((ptarget > p_ij).and.(iy_cur > 1))
            iy_cur = iy_cur - 1
            ptarget = pref*(eta(iy_cur)-term_b(iy_cur)) + term_b(iy_cur)*psurf
          end do
          plower = pref*(eta(iy_cur)-term_b(iy_cur)) + term_b(iy_cur)*psurf
          pupper = pref*(eta(iy_cur-1)-term_b(iy_cur-1)) + term_b(iy_cur-1)*psurf
  
          y(i,j) = real(iy_cur-1) + (pupper - p_ij)/(pupper-plower)
        endif
      enddo
    else
      do j=jfin,jdeb+1,-1
        x(i,j) = (1.0*(i-ideb) / rhox) + xdeb
        ix = int(x(i,j))
        psurf = p0(ix) + (p0(ix+1)-p0(ix))*(x(i,j)-real(ix))
        ln_psurf = log(p0(ix) + (p0(ix+1)-p0(ix))*(x(i,j)-real(ix)))
        ln_p_ij = log(yfin) - (1.0*(jfin - j) / rhoy)
        if (ln_p_ij >= ln_psurf) then
          y(i,j) = 0.0
        else
          ln_ptarget = log(pref*(eta(iy_cur)-term_b(iy_cur)) + term_b(iy_cur)*psurf)
          do while ((ln_ptarget > ln_p_ij).and.(iy_cur > 1))
            iy_cur = iy_cur - 1
            ln_ptarget = log(pref*(eta(iy_cur)-term_b(iy_cur)) + term_b(iy_cur)*psurf)
          end do
          ln_plower = log(pref*(eta(iy_cur)-term_b(iy_cur)) + term_b(iy_cur)*psurf)
          ln_pupper = log(pref*(eta(iy_cur-1)-term_b(iy_cur-1)) + term_b(iy_cur-1)*psurf)
  
          y(i,j) = real(iy_cur-1) + (ln_pupper- ln_p_ij)/(ln_pupper-ln_plower)
        endif
      enddo
    endif
  enddo
  return
  end
!   real function p_hyb(psurf, hyb, ptop, pref, rcoef)
!   implicit none
!   real psurf, hyb, ptop, pref, rcoef
!   real term_a, term_b
!   term_b = ((hyb - ptop/pref)/(1.0-ptop/pref))**rcoef
!   term_a = 
!   p_hyb = 
!   
!   return
!   end
