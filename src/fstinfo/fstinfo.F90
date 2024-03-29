      program fstinfo
      use app

! Revision 006 - M. Lepine, augmenter la longueur pour les noms de fichiers a 4k
! Revision 007 - M. Lepine, reload avec librmn_014
! Revision 008 - M. Lepine, reload avec librmn_015.1
! Revision 009 - M. Lepine, reload avec librmn_015.2
      implicit none
#include "fst-tools_build_info.h"

      integer pnier,pnfstsrc,pnnis,pnnjs,pnnks
      integer fnom,fstouv,fstfrm,fstinf,pnkey,fstsui

      integer pndateo,pndatprinto,pndatev,pndatprintv,pntimeo
      integer pntimev,pndeet,pnnpas,pnnbits
      integer pndatyp, pnip1,pnip2,pnip3
      integer pnig1,pnig2,pnig3,pnig4,pnswa,pnlng,pndltf,pnubc,pnextra1
      integer pnextra2,pnextra3

      integer fstprm,pnseqout,ilen
      integer wkoffit,ikind
      external qqexit,ccard,wkoffit

      real*8 prtmp8

      character*1 ptgrtyp,ptdel
      character*2 pttypvar
      character*4 ptnomvar
      character*12 ptetiket

      character(len=8) :: cltimev
      character*8 ptcle(12)
      character*4096 ptvar(12), ptdefvar(12)

      data ptcle /'izfst.','datev.','vdatev.','etiket.','ip1.','ip2.','ip3.','typvar.','nomvar.','otxt.','del.','champs.'/
      data ptvar /'bidon','-1','-1',' ','-1','-1','-1',' ',' ','fstlist',':','0'/
      data ptdefvar /'bidon','-1','-1',' ','-1','-1','-1',' ',' ','fstlist',':','1'/
      data pnfstsrc /11/

      call ccard(ptcle,ptdefvar,ptvar,12,-1)

!     ------ Liste de champs -----
      if (ptvar(12).eq.'1') then

         write(*,'(27(/,1x,a))')     &
              '1 nomvar',            &
              '2 typvar',            &   
              '3 ip1',               &
              '4 ip2',               &
              '5 ip3',               &
              '6  ni',               &
              '7  nj',               &
              '8  nk',               &
              '9 etiket',            &
              '10  date d origine',  & 
              '11 date de validite', &
              '12 deet',             &
              '13  npas',            &
              '14 grtyp',            &
              '15 ig1',              &
              '16 ig2',              &
              '17 ig3',              &
              '18 ig4',              &
              '19  datyp',           &
              '20  nbits',           &
              '21 swa',              &
              '22 lng',              &
              '23 dltf',             &
              '24 ubc',              &
              '25 extra1',           &
              '26 extra2',           &
              '27 extra3'
         stop
      endif

      app_ptr=app_init(0,'fstinfo',VERSION,'',BUILD_TIMESTAMP)
      call app_start()

      ikind = wkoffit(ptvar(1))
!      write(*,*) 'IKIND ====== ',ikind
      if(ikind .ne. 39 .and. ikind .ne. 33 .and. ikind .ne. 34 .and. ikind .ne. 1) then
         call app_log(APP_ERROR,'File is not RPN')                  
         app_status=app_end(-1)
         call qqexit(app_status)
      endif
!     ------ Initialisation des clefs de recherche -----

      if (ptvar(2) .ne. '-1') then
        read(ptvar(2),*) pndatev
      elseif(ptvar(3) .ne. '-1') then
        read(ptvar(3)(1:8),*) pndatprintv
        read(ptvar(3)(9:),'(a8)') cltimev
        ilen = len_trim(cltimev)
        cltimev = '00000000'
        read(ptvar(3)(9:9+ilen),'(a)') cltimev(1:ilen)
        read(cltimev,*) pntimev
        call newdate(pndatev,pndatprintv,pntimev,3)
      else
        pndatev = -1
      endif
      read(ptvar(5),*) pnip1
      read(ptvar(6),*) pnip2
      read(ptvar(7),*) pnip3

      ptetiket=ptvar(4)
      pttypvar=ptvar(8)
      ptnomvar=ptvar(9)
      ptdel=ptvar(11)

!     ------ Ouverture des fichiers ------

      pnseqout = 21
      open(pnseqout,FILE=ptvar(10),ACCESS='SEQUENTIAL')

      pnier =  fnom  (pnfstsrc,ptvar(1),'RND+STD+R/O',0)
      pnier =  fstouv(pnfstsrc,'RND')

      pnkey=fstinf(pnfstsrc,pnnis,pnnjs,pnnks,pndatev,  &
          ptetiket, pnip1, pnip2, pnip3, pttypvar, ptnomvar)

 100  if (pnkey.ge.0) then
         pnier=fstprm(pnkey,pndateo,pndeet,pnnpas,pnnis,pnnjs,pnnks,pnnbits,           &
             pndatyp,pnip1,pnip2,pnip3,pttypvar,ptnomvar,ptetiket,ptgrtyp,pnig1,pnig2, &
             pnig3,pnig4,pnswa,pnlng,pndltf,pnubc,pnextra1,pnextra2,pnextra3)

         prtmp8=pndeet
         prtmp8=prtmp8*pnnpas/3600.

         call incdatr(pndatev,pndateo,prtmp8)

         call newdate(pndateo,pndatprinto,pntimeo,-3)
         call newdate(pndatev,pndatprintv,pntimev,-3)

         write (pnseqout,1000) ptnomvar,ptdel,pttypvar,ptdel,pnip1,ptdel  &
              ,pnip2,ptdel,pnip3,ptdel,pnnis,ptdel,pnnjs,ptdel,pnnks      &
              ,ptdel,ptetiket,ptdel,pndatprinto,pntimeo,ptdel             &
              ,pndatprintv,pntimev,ptdel,pndeet,ptdel,pnnpas,ptdel        &
              ,ptgrtyp,ptdel,pnig1,ptdel,pnig2,ptdel,pnig3,ptdel,pnig4    &
              ,ptdel,pndatyp,ptdel,pnnbits,ptdel,pnswa,ptdel,pnlng,ptdel  &
              ,pndltf,ptdel,pnubc,ptdel,pnextra1,ptdel,pnextra2,ptdel     &
              ,pnextra3

         pnkey=fstsui(pnfstsrc,pnnis,pnnjs,pnnks)
         goto 100
       endif

      pnier =  fstfrm(pnfstsrc)
      close(pnseqout)

 1000 format(2(a,a),6(i10,a),1(a,a),2(i8.8,i8.8,a),2(i10,a),1(a,a),12(i10,a),i10)

      app_status=app_end(-1);
      call qqexit(app_status)
      stop
      end
