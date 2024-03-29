! **s/r statfldx - calcule la moyenne, la variance, le rminimum et 
!                 le maximum d'un champs et imprime le resultat.
! 
      subroutine statfldx(nomvar,typvar,ip1,ip2,ip3,date,etiket,f,ni,nj,nk) 
      implicit none
      character*4 nomvar
      character*2 typvar
      integer ip1,ip2,ip3,date
      character*12 etiket
!  
      integer ni,nj,nk
      real f(ni,nj,nk) 
! 
! OBJECT
!      calcule et imprime: la moyenne    (moy)
!                          la variance   (var)
!                          le minimum et le maximum
!      du champ f   
!  
!      arguments:
!          - f       - champ sur lequel on veut faire des statistiques
!          - n       - dimensions du champ f
!          - champ   - identification du champ
!          - no      - compteur 
!          - from    - identification du module d'ou on fait l'appel 
! 
! METHOD
! 
! EXTERNALS
! 
! AUTHOR   Michel Desgagne                   Nov   1992
! 
! Revision
!  001     M. Lepine, Mars  2003  -  appel a convip pour afficher les niveaux
!  002     Y. Chartier, Aout 2014 -  coordonnees i,j a 4 chiffres, detection de Nan
!  003     M. Lepine, Oct 2014    -  version adaptee (real*8), a partir de statfld4, pour utilisation avec fstcomp
! 
! HISTORY
! 
! *
      integer i,j,k
      real*8 sum,moy,var,rmin,rmax
      integer imin,jmin,kmin,imax,jmax,kmax,kind,dat2,dat3
      CHARACTER*15 Level
      REAL      rlevel
!      logical isnan
! --------------------------------------------------------------------
! 
!  ** On calcule la moyenne.
! 
      sum = 0.0
      do 1 k=1,nk
         do 1 j=1,nj
            do 1 i=1,ni
         sum = sum + f(i,j,k)
 1    continue
      moy = sum / float(ni*nj*nk)
! 
!  ** On calcule la variance
! 
      sum = 0.0
      do 2 k=1,nk
         do 2 j=1,nj
            do 2 i=1,ni
               sum = sum + ((f(i,j,k) - moy)*(f(i,j,k) - moy))
 2    continue
      var = sqrt (sum / float(ni*nj*nk))
! 
!  ** On identifie le minimum et le maximum.
! 
      imin = 1
      jmin = 1
      kmin = 1
      imax = 1
      jmax = 1
      kmax = 1
      rmax = f(1,1,1)
      rmin = f(1,1,1)
! 
      do 3 k=1,nk
         do 3 j=1,nj
            do 3 i=1,ni
               if (f(i,j,k) .gt. rmax) then
                  rmax  = f(i,j,k)
                  imax = i
                  jmax = j
                  kmax = k
               endif
               if (f(i,j,k) .lt. rmin) then
                  rmin  = f(i,j,k)
                  imin = i
                  jmin = j
                  kmin = k
               endif
 3    continue
! 
      CALL convip_plus(ip1,rlevel,kind,-1,level,.true.)
!       call newdate(date,dat2,dat3,-3);
!       print *,'Debug date=',date,dat2,dat3/100
!        
!  ** On imprime
!  
!      write(6,10) nomvar,typvar,level,ip2,ip3,date,etiket,
      write(6,10) nomvar,etiket,level,ip2,ip3, &
           moy,var,imin,jmin+(kmin-1)*nj,rmin, &
           imax,jmax+(kmax-1)*nj,rmax
!  10   format (' ',a4,1x,a2,1x,a15,' (',i9,') ',i9,1x,i9,1x,i9,1x,a12,1x,
 10   format ('  <',a4,'>',1x,a12,a15,1x,i8,1x,i8,1x, &
          ' Mean:',e15.8,' Stdev:',e15.8, &
          '  Min:[(',i4,',',i4,'):', &
          e11.4,']',' Max:[(',i4,',',i4,'):', &
          e11.4,']')
          
! On essaie de detecter la presence de Nan
#ifdef AIX 
      if (moy /= moy) then
         print *, '**** NaN detected'
#endif
#ifdef AMD64
      if (isnan(moy)) then
         print *, '**** NaN detected'
      endif
#endif
         do k=1,nk
            do j=1,nj
               do i=1,ni
#ifdef AIX
		  if (f(i,j,k) /= f(i,j,k)) then
		     write (6,20) i,j,k
		  endif
#endif
#ifdef AMD64
		  if (isnan(f(i,j,k))) then
		     write (6,20) i,j,k
		  endif
#endif
               enddo
            enddo
         enddo

 20 format(' ','**** NaN at grid point(', i4.4,',',i4.4,',',i3.3,')')
! 
! ----------------------------------------------------------------
      return
      end 
