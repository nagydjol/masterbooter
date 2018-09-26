include defines.h

public helpline1,helpline2
public H_entername,H_enterpasswd,H_entermpass,H_FAT
public H_enterdelay
public blockmatrix

public H_enterdefault

public S_enterscan
public oldpos,delaypos,defaultpos,beeppos,masterpos,floppypos,hidemenupos

extrn actualpart:byte
extrn numosystems:byte
extrn numoselected:byte
extrn dummy:byte

public drawscreen1,drawscreen2,putwindow,gotoXY,showcursor,hidecursor
public highlight,moveblock,printattr,printhelpline,clearwindow
