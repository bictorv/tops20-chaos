@TE NVT
! assemble TECO and build a new EMACS
@enable

! define logical names to point to where <EMACS> will live
! change these if it lives elsewhere
@define emacs: ps:<chaos.emacs>,ps:<emacs>
@define info: ps:<info>
! emacs: must be at the front of sys: in this file to hide any DEC TECO.EXE.
! if this is not run under batch, you should be sure that MIT TECO is invoked.
@define sys: emacs:,sys:

! when TECO starts up, it must run TECO.INIT from <EMACS>, so connect there.
@connect emacs:
@disable
!@vdirectory sys:midas.exe,teco.mid,teco.init
!@vdirectory info:emacs.init,teach-emacs.init,teach-emacs.txt

! Note: NMIDAS has been built with a larger symbol table, by 
! @midas nmidas_midas/t
! *SYMDSZ=11657.*2
! *^Z
! and the usual purification.
@nmidas
*temp_teco
! Now start up the new TECO, and dump out the environment the init file creates.
@iddt
*;ytemp
*purifyg
*mmrunpurifydumpnemacs.exe
*mmruneinit? document
!
! Make a stand-alone INFO
@teco
*er info:info.init@y m(hfx*)
@reset
!
! Make TEACH-EMACS.EXE
@teco
*er emacs:teach-emacs.init@y m(hfx*)

!@vdirectory teco.exe,tecpur.exe,nemacs.exe,emacs.doc,emacs.chart
!@vdirectory ninfo.exe,teach-emacs.tutorial,teach-emacs.exe


! After this, test everything and
! install NEMACS.EXE as SYS:EMACS.EXE
! install EINFO.EXE as SYS:INFO.EXE
