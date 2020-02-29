DECLARE SUB PALLOAD (PLOD$)
DECLARE SUB VGALOAD (VLOD$)
REM ---------------------------------------------------------------------------
REM Graphics Convertor (GIF -> VGA + PAL) ver. 1.0
REM ---------------------------------------------------------------------------
DECLARE FUNCTION CRFN$ (NAME$, EXT$)
DECLARE FUNCTION DECHR% (HEXDT0%, HEXDT1%)
DECLARE FUNCTION DEINT% (HEXDT0%, HEXDT1%)
DECLARE FUNCTION GETPIX% (X%, Y%)
DECLARE FUNCTION GETRGBCOL% (COL%, Par%)
DECLARE FUNCTION GETVMODE% (Par%)
DECLARE FUNCTION RECHR% (ASCCOD%, Par%)
DECLARE FUNCTION REINT% (INTCOD%, Par%)
REM ---------------------------------------------------------------------------
DECLARE SUB PUTPIX (X%, Y%, COL%)
DECLARE SUB SETRGBCOL (COL%, R%, G%, B%)
DECLARE SUB PALSAVE (PSAV$, Caption$)
DECLARE SUB VGASAVE (VSAV$)
REM ---------------------------------------------------------------------------
REM Sartup ...
REM ---------------------------------------------------------------------------
REM $INCLUDE: 'QBX.BI'
REM SUD$ = "D:\RESERV\TROY\AATTACK\AA20\GRAPHS\"
REM ---------------------------------------------------------------------------
DEFINT A-Z: CLS
REM ---------------------------------------------------------------------------
PRINT "Graphics Convertor (GIF -> VGA + PAL) ver. 1.0"
PRINT "Troy computing, Inc."
PRINT "Kolevatow Sergey (c) 1996"
REM ---------------------------------------------------------------------------
IF DIR$("VPIC.EXE") <> "VPIC.EXE" THEN
	COLOR 20, 15: BEEP
	PRINT SPACE$(80)
	PRINT "                            !!! Warning !!!                                     ": COLOR 4, 15
	PRINT "                      Could not find file VPIC.EXE                              "
	PRINT "                          Exiting program !!!                                   "
	PRINT SPACE$(80): COLOR 7, 0, 0
	PRINT
	END
END IF
REM ---------------------------------------------------------------------------
IF DIR$("*.GIF") = "" THEN
	PRINT "ERROR: GIF-files not found"
	END
END IF
REM ---------------------------------------------------------------------------
PRINT "GIF-file(s):": VIEW PRINT 5 TO 15: FILES "*.GIF": VIEW PRINT 15 TO 24
REM ---------------------------------------------------------------------------
INPUT "Enter filename (without EXT) - ", GIFN$
IF GIFN$ = "" THEN PRINT "Invalid Filename             - Acessing Exit": END
FLNM$ = UCASE$(GIFN$) + ".GIF"
PRINT "Testing to find file         - " + FLNM$
REM ---------------------------------------------------------------------------
IF DIR$(FLNM$) <> FLNM$ THEN
	PRINT DIR$(FLNM$)
	PRINT "ERROR: No exist GIF-file"
	END
END IF
REM ---------------------------------------------------------------------------
PRINT "File " + FLNM$ + " was found"
INPUT "Enter new filename (VGA) without EXT - ", FLNW$
REM ---------------------------------------------------------------------------
IF FLNW$ = "" THEN
	FLNC$ = UCASE$(GIFN$): FLNW$ = UCASE$(GIFN$) + ".VGA"
	PRINT "Invalid Filename - Continue with     - " + FLNW$
ELSE
	FLNC$ = UCASE$(FLNW$): FLNW$ = UCASE$(FLNW$) + ".VGA"
END IF
REM ---------------------------------------------------------------------------
PRINT "Testing to find file                 - " + FLNW$
REM ---------------------------------------------------------------------------
IF DIR$(FLNW$) = FLNW$ THEN
	PRINT "ERROR: Exist original VGA-file"
	END
END IF
REM ---------------------------------------------------------------------------
PRINT "Press any key to convert file " + FLNM$ + " to " + FLNW$ + " ..."
SLEEP
REM ---------------------------------------------------------------------------
SCREEN 13: CLS
SHELL "VPIC.EXE " + FLNM$ + " /r"
REM ---------------------------------------------------------------------------
VGASAVE FLNC$: PALSAVE FLNC$, FLNC$
PALETTE: CLS : PRINT "Press any key to load picture ...": SLEEP
VGALOAD FLNC$: PALLOAD FLNC$
PRINT "Press any key to restart ...": SLEEP
RUN

SUB CGAENABL (Par%)
DIM regs AS RegType
IF Par% < 0 OR Par% > 1 THEN Par% = 0
regs.ax = &H1200 + Par%
regs.bx = &H34
interrupt &H10, regs, regs
END SUB

FUNCTION CRFN$ (NAME$, EXT$)
IF LEN(NAME$) = 0 THEN
	TCRFN$ = "$$%%$$%▒" + EXT$
ELSEIF LEN(NAME$) > 8 THEN
	TCRFN$ = LEFT$(NAME$, 8) + EXT$
ELSEIF LEN(NAME$) <= 8 THEN
	TCRFN$ = NAME$ + SPACE$(8 - LEN(NAME$)) + EXT$
END IF
CRFN$ = UCASE$(TCRFN$)
END FUNCTION

FUNCTION DECHR% (HEXDT0%, HEXDT1%)
HEXDT0$ = HEX$(HEXDT0%)
HEXDT1$ = HEX$(HEXDT1%)
HEXDAT$ = HEXDT0$ + HEXDT1$
DECHR% = VAL("&H" + HEXDAT$)
END FUNCTION

FUNCTION DEINT% (HEXDT0%, HEXDT1%)
HEXDT0$ = HEX$(HEXDT0%)
HEXDT1$ = HEX$(HEXDT1%)
IF HEXDT0% < 16 THEN HEXDT0$ = "0" + HEXDT0$
IF HEXDT1% < 16 THEN HEXDT1$ = "0" + HEXDT1$
HEXDAT$ = HEXDT0$ + HEXDT1$
DEINT% = VAL("&H" + HEXDAT$)
END FUNCTION

FUNCTION GETPIX% (X%, Y%)
DIM regs AS RegType
regs.ax = &HD00
regs.cx = X%
regs.dx = Y%
interrupt &H10, regs, regs
GETPIX% = VAL("&H" + RIGHT$(HEX$(regs.ax), 2))
END FUNCTION

FUNCTION GETRGBCOL% (COL%, Par%)
DIM regs AS RegType
IF Par% < 0 OR Par% > 2 THEN Par% = 0
regs.ax = &H1015
regs.bx = COL%
interrupt &H10, regs, regs
IF Par% = 0 THEN GETRGBCOL% = REINT%(regs.dx, 0)
IF Par% = 1 THEN GETRGBCOL% = REINT%(regs.cx, 0)
IF Par% = 2 THEN GETRGBCOL% = REINT%(regs.cx, 1)
END FUNCTION

FUNCTION GETVMODE% (Par%)
DIM regs AS RegType
IF Par% < 0 OR Par% > 2 THEN Par% = 1
regs.ax = &HF00
interrupt &H10, regs, regs
IF Par% = 0 THEN GETVMODE% = VAL("&H" + LEFT$(HEX$(regs.ax), 2))
IF Par% = 1 THEN GETVMODE% = VAL("&H" + RIGHT$(HEX$(regs.ax), 2))
IF Par% = 2 THEN GETVMODE% = VAL("&H" + LEFT$(HEX$(regs.bx), 2))
END FUNCTION

SUB GREYPALS (Par%)
DIM regs AS RegType
IF Par% < 0 OR Par% > 1 THEN Par% = 0
regs.ax = &H101B
regs.bx = &H0
IF Par% = 0 THEN regs.cx = &H1
IF Par% = 1 THEN regs.cx = &H256
interrupt &H10, regs, regs
END SUB

SUB ICOLOAD (FLNM$, SETX%, SETY%, Par%)
REM --------------------------------------------------------------------------
SHARED ICOheader.Reserv AS INTEGER
SHARED ICOheader.RSType AS INTEGER
SHARED ICOheader.Images AS INTEGER
SHARED ICOheader.WidthI AS STRING * 1
SHARED ICOheader.HeighI AS STRING * 1
SHARED ICOheader.ColCnt AS STRING * 1
SHARED ICOheader.PixArr AS LONG
SHARED ICOheader.DatOFF AS LONG
SHARED ICOheader.XORMap AS STRING * 512
SHARED ICOheader.AMDMap AS STRING * 128
REM --------------------------------------------------------------------------
FLNM$ = UCASE$(FLNM$) + ".ICO": SK = 1: FF = FREEFILE: STRSK% = 1
REM --------------------------------------------------------------------------
IF FLNM$ <> DIR$(FLNM$) THEN EXIT SUB
REM --------------------------------------------------------------------------
OPEN "B", FF, FLNM$
REM --------------------------------------------------------------------------
SEEK FF, &H0 + SK: GET FF, , ICOheader.Reserv
SEEK FF, &H2 + SK: GET FF, , ICOheader.RSType
SEEK FF, &H4 + SK: GET FF, , ICOheader.Images
SEEK FF, &H6 + SK: GET FF, , ICOheader.WidthI: WidthI% = ASC(ICOheader.WidthI)
SEEK FF, &H7 + SK: GET FF, , ICOheader.HeighI: HeighI% = ASC(ICOheader.HeighI)
SEEK FF, &H8 + SK: GET FF, , ICOheader.ColCnt: COLCNT% = ASC(ICOheader.ColCnt)
SEEK FF, &HE + SK: GET FF, , ICOheader.PixArr
SEEK FF, &H12 + SK: GET FF, , ICOheader.DatOFF
SEEK FF, ICOheader.DatOFF + 104 + SK: GET FF, , ICOheader.XORMap
REM --------------------------------------------------------------------------
CLOSE FF
REM --------------------------------------------------------------------------
FOR Y% = HeighI% - 1 TO 0 STEP -1
FOR X% = 0 TO WidthI% - 1 STEP 2
CCOL% = ASC(MID$(ICOheader.XORMap, STRSK%, 1))
CCOL0% = RECHR%(CCOL%, 0)
CCOL1% = RECHR%(CCOL%, 1)
PUTPIX X% + 0 + SETX%, Y% + SETY%, CCOL0%
PUTPIX X% + 1 + SETX%, Y% + SETY%, CCOL1%
STRSK% = STRSK% + 1
NEXT X%
NEXT Y%
REM --------------------------------------------------------------------------
END SUB

SUB LMOLOAD (FLNM$, Left%, Top%, LMOColor%, Par%)
REM --------------------------------------------------------------------------
SHARED LMOHeader.initLMO  AS STRING * 6
SHARED LMOHeader.FileType AS INTEGER
SHARED LMOHeader.BitPx    AS INTEGER
SHARED LMOHeader.DataType AS INTEGER
SHARED LMOHeader.WidthI   AS INTEGER
SHARED LMOHeader.HeighI   AS INTEGER
SHARED LMOHeader.LMOColor AS INTEGER
SHARED LMOHeader.Begin    AS INTEGER
REM SHARED LMOHeader.Datas    AS STRING
REM --------------------------------------------------------------------------
FLNM$ = UCASE$(FLNM$) + ".LMO": SK = 1: FF = FREEFILE: STRSK% = 1
REM --------------------------------------------------------------------------
IF FLNM$ <> DIR$(FLNM$) THEN EXIT SUB
IF BitPx% <> 1 AND BitPx% <> 2 AND BitPx% <> 4 AND BitPx% <> 8 THEN BitPx% = 8
REM --------------------------------------------------------------------------
IF RECHR%(Par%, 0) = 0 THEN SETCol% = RECHR%(Par%, 1)
IF RECHR%(Par%, 0) = 1 THEN chkLMO% = RECHR%(Par%, 1)
REM --------------------------------------------------------------------------
OPEN "B", FF, FLNM$
SEEK FF, 0 + SK: GET FF, , LMOHeader.initLMO
SEEK FF, 6 + SK: GET FF, , LMOHeader.FileType
SEEK FF, 8 + SK: GET FF, , LMOHeader.BitPx
SEEK FF, 10 + SK: GET FF, , LMOHeader.DataType
SEEK FF, 12 + SK: GET FF, , LMOHeader.WidthI
SEEK FF, 14 + SK: GET FF, , LMOHeader.HeighI
SEEK FF, 16 + SK: GET FF, , LMOHeader.LMOColor
SEEK FF, 18 + SK: GET FF, , LMOHeader.Begin
REM --------------------------------------------------------------------------
DATSTR$ = SPACE$(INT(LMOHeader.WidthI * LMOHeader.HeighI * LMOHeader.BitPx / 8))
REM --------------------------------------------------------------------------
SEEK FF, 20 + SK: GET FF, , DATSTR$
CLOSE FF
REM --------------------------------------------------------------------------
IF LMOHeader.initLMO <> "LMO95k" THEN EXIT SUB
IF LMOHeader.FileType <> 1 THEN EXIT SUB
IF LMOHeader.DataType <> 0 THEN EXIT SUB
IF LMOHeader.Begin <> 18 THEN EXIT SUB
REM --------------------------------------------------------------------------
IF LMOHeader.BitPx = 8 THEN
REM --------------------------------------------------------------------------
	FOR TY% = Top% TO Top% + LMOHeader.HeighI - 1
	FOR TX% = Left% TO Left% + LMOHeader.WidthI - 1
	CCOL% = ASC(MID$(DATSTR$, STRSK%, 1))
	IF CCOL% <> LMOHeader.LMOColor OR chkLMO% = 0 THEN PUTPIX TX%, TY%, CCOL%
	STRSK% = STRSK% + 1
	NEXT TX%
	NEXT TY%
REM --------------------------------------------------------------------------
ELSEIF LMOHeader.BitPx = 4 THEN
REM --------------------------------------------------------------------------
	FOR TY% = Top% TO Top% + LMOHeader.HeighI - 1
	FOR TX% = Left% TO Left% + LMOHeader.WidthI - 1 STEP 2
	CCOL% = ASC(MID$(DATSTR$, STRSK%, 1))
	COL0% = RECHR%(CCOL%, 0)
	COL1% = RECHR%(CCOL%, 1)
	IF COL0% <> LMOHeader.LMOColor OR chkLMO% = 0 THEN PUTPIX TX% + 0, TY%, COL0%
	IF COL1% <> LMOHeader.LMOColor OR chkLMO% = 0 THEN PUTPIX TX% + 1, TY%, COL1%
	STRSK% = STRSK% + 1
	NEXT TX%
	NEXT TY%
REM --------------------------------------------------------------------------
END IF
REM --------------------------------------------------------------------------
END SUB

SUB LMOSAVE (FLNM$, Left%, Top%, WidthI%, HeighI%, BitPx%, LMOColor%, Par%)
REM --------------------------------------------------------------------------
SHARED LMOHeader.initLMO  AS STRING * 6
SHARED LMOHeader.FileType AS INTEGER
SHARED LMOHeader.BitPx    AS INTEGER
SHARED LMOHeader.DataType AS INTEGER
SHARED LMOHeader.WidthI   AS INTEGER
SHARED LMOHeader.HeighI   AS INTEGER
SHARED LMOHeader.LMOColor AS INTEGER
SHARED LMOHeader.Begin    AS INTEGER
SHARED LMOHeader.Datas    AS STRING
REM --------------------------------------------------------------------------
FLNM$ = UCASE$(FLNM$) + ".LMO": SK = 1: FF = FREEFILE
REM --------------------------------------------------------------------------
IF WidthI% * HeighI% > 16384 THEN EXIT SUB
IF FLNM$ = DIR$(FLNM$) THEN EXIT SUB
IF BitPx% <> 1 AND BitPx% <> 2 AND BitPx% <> 4 AND BitPx% <> 8 THEN BitPx% = 8
REM --------------------------------------------------------------------------
IF RECHR%(Par%, 0) = 0 THEN SETCol% = RECHR%(Par%, 1)
REM --------------------------------------------------------------------------
LMOHeader.initLMO = "LMO95k"
LMOHeader.FileType = 1
LMOHeader.BitPx = BitPx%
LMOHeader.DataType = 0
LMOHeader.WidthI = WidthI%
LMOHeader.HeighI = HeighI%
LMOHeader.LMOColor = LMOColor%
LMOHeader.Begin = 18
REM --------------------------------------------------------------------------
IF BitPx% = 8 THEN
REM --------------------------------------------------------------------------
	FOR TY% = Top% TO Top% + HeighI% - 1
	FOR TX% = Left% TO Left% + WidthI% - 1
	CCOL% = GETPIX%(TX%, TY%)
	LMOHeader.Datas = LMOHeader.Datas + CHR$(CCOL%)
	NEXT TX%
	NEXT TY%
REM --------------------------------------------------------------------------
ELSEIF BitPx% = 4 THEN
REM --------------------------------------------------------------------------
	FOR TY% = Top% TO Top% + HeighI% - 1
	FOR TX% = Left% TO Left% + WidthI% - 1 STEP 2
	COL0% = GETPIX%(TX% + 0, TY%) - SETCol%
	COL1% = GETPIX%(TX% + 1, TY%) - SETCol%
	CCOL% = DECHR%(COL0%, COL1%)
	LMOHeader.Datas = LMOHeader.Datas + CHR$(CCOL%)
	NEXT TX%
	NEXT TY%
REM --------------------------------------------------------------------------
END IF
REM --------------------------------------------------------------------------
OPEN "B", FF, FLNM$
SEEK FF, 0 + SK: PUT FF, , LMOHeader.initLMO
SEEK FF, 6 + SK: PUT FF, , LMOHeader.FileType
SEEK FF, 8 + SK: PUT FF, , LMOHeader.BitPx
SEEK FF, 10 + SK: PUT FF, , LMOHeader.DataType
SEEK FF, 12 + SK: PUT FF, , LMOHeader.WidthI
SEEK FF, 14 + SK: PUT FF, , LMOHeader.HeighI
SEEK FF, 16 + SK: PUT FF, , LMOHeader.LMOColor
SEEK FF, 18 + SK: PUT FF, , LMOHeader.Begin
SEEK FF, 20 + SK: PUT FF, , LMOHeader.Datas
CLOSE FF
REM --------------------------------------------------------------------------
END SUB

SUB PALLOAD (PLOD$)
REM --------------------------------------------------------------------------
SHARED PALheader.initPAL AS STRING * 6
SHARED PALheader.NAME    AS STRING * 11
SHARED PALheader.Caption AS STRING * 256
SHARED PALheader.usCOL   AS INTEGER
SHARED PALheader.fstCOL  AS INTEGER
SHARED PALheader.palTYPE AS INTEGER
SHARED PALheader.DATAS   AS STRING * 768
REM --------------------------------------------------------------------------
FLNM$ = PLOD$ + ".PAL": SK = 1: FF = FREEFILE: STRPOS = 1
REM --------------------------------------------------------------------------
IF FLNM$ <> DIR$(FLNM$) THEN EXIT SUB
REM --------------------------------------------------------------------------
OPEN "B", FF, FLNM$
SEEK #1, SK + 273: GET #1, , PALheader.usCOL
SEEK #1, SK + 275: GET #1, , PALheader.fstCOL
SEEK #1, SK + 279: GET #1, , PALheader.DATAS
CLOSE FF
REM --------------------------------------------------------------------------
FOR TMPCOL% = PALheader.fstCOL TO PALheader.usCOL - 1
R% = ASC(MID$(PALheader.DATAS, STRPOS + 0, 1))
G% = ASC(MID$(PALheader.DATAS, STRPOS + 1, 1))
B% = ASC(MID$(PALheader.DATAS, STRPOS + 2, 1))
STRPOS = STRPOS + 3
SETRGBCOL TMPCOL%, R%, G%, B%
NEXT TMPCOL%
REM --------------------------------------------------------------------------
END SUB

SUB PALSAVE (PSAV$, Caption$)
REM --------------------------------------------------------------------------
SHARED PALheader.initPAL AS STRING * 6
SHARED PALheader.NAME    AS STRING * 11
SHARED PALheader.Caption AS STRING * 256
SHARED PALheader.usCOL   AS INTEGER
SHARED PALheader.fstCOL  AS INTEGER
SHARED PALheader.palTYPE AS INTEGER
SHARED PALheader.DATAS   AS STRING * 768
REM --------------------------------------------------------------------------
NAME$ = CRFN$(PSAV$, "PAL")
FLNM$ = LCASE$(CRFN$(PSAV$, ".PAL")): SK = 1: FF = FREEFILE: STRPOS = 1
REM --------------------------------------------------------------------------
IF FLNM$ = DIR$(FLNM$) THEN EXIT SUB
REM --------------------------------------------------------------------------
PALheader.initPAL = "PAL95I"
PALheader.NAME = NAME$
PALheader.Caption = Caption$
PALheader.usCOL = 256
PALheader.fstCOL = 0
PALheader.palTYPE = 1
REM --------------------------------------------------------------------------
FOR TMPCOL = 0 TO 255 STEP 1
MID$(PALheader.DATAS, STRPOS, 3) = CHR$(GETRGBCOL(TMPCOL, 0)) + CHR$(GETRGBCOL(TMPCOL, 1)) + CHR$(GETRGBCOL(TMPCOL, 2))
STRPOS = STRPOS + 3
NEXT TMPCOL
REM --------------------------------------------------------------------------
OPEN "B", FF, FLNM$
SEEK #1, SK + 0: PUT #1, , PALheader.initPAL
SEEK #1, SK + 6: PUT #1, , PALheader.NAME
SEEK #1, SK + 17: PUT #1, , PALheader.Caption
SEEK #1, SK + 273: PUT #1, , PALheader.usCOL
SEEK #1, SK + 275: PUT #1, , PALheader.fstCOL
SEEK #1, SK + 277: PUT #1, , PALheader.palTYPE
SEEK #1, SK + 279: PUT #1, , PALheader.DATAS
CLOSE FF
REM --------------------------------------------------------------------------
END SUB

SUB PUTPIX (X%, Y%, COL%)
DIM regs AS RegType
regs.ax = &HC00 + COL%
regs.cx = X%
regs.dx = Y%
interrupt &H10, regs, regs
END SUB

FUNCTION RECHR% (ASCCOD%, Par%)
IF Par% < 0 OR Par% > 1 THEN Par% = 1
HEXTMP$ = HEX$(ASCCOD%)
IF ASCCOD% < 16 THEN HEXTMP$ = "0" + HEXTMP$
IF Par% = 0 THEN RECHR% = VAL("&H" + LEFT$(HEXTMP$, 1))
IF Par% = 1 THEN RECHR% = VAL("&H" + RIGHT$(HEXTMP$, 1))
END FUNCTION

FUNCTION REINT% (INTCOD%, Par%)
IF Par% < 0 OR Par% > 1 THEN Par% = 1
HEXTMP$ = LTRIM$(HEX$(INTCOD%))
IF LEN(HEXTMP$) < 4 THEN HEXTMP$ = STRING$(4 - LEN(HEXTMP$), 48) + HEXTMP$
IF Par% = 0 THEN REINT% = VAL("&H" + LEFT$(HEXTMP$, 2))
IF Par% = 1 THEN REINT% = VAL("&H" + RIGHT$(HEXTMP$, 2))
END FUNCTION

SUB SCROFF (Par%)
IF Par% < 0 OR Par% > 1 THEN Par% = 0
DIM regs AS RegType
IF Par% = 0 THEN regs.ax = &H1200 + &H0
IF Par% = 1 THEN regs.ax = &H1200 + &H1
regs.bx = &H36
interrupt &H10, regs, regs
END SUB

SUB SETRGBCOL (COL%, R%, G%, B%)
DIM regs AS RegType
regs.ax = &H1010
regs.bx = COL%
regs.cx = DEINT%(G%, B%)
regs.dx = DEINT%(R%, 0)
interrupt &H10, regs, regs
END SUB

SUB SETVMODE (MODE%)
DIM regs AS RegType
regs.ax = &H0 + MODE%
interrupt &H10, regs, regs
END SUB

SUB VGALOAD (VLOD$)
REM --------------------------------------------------------------------------
FLNM$ = UCASE$(VLOD$) + ".VGA"
REM --------------------------------------------------------------------------
IF FLNM$ <> DIR$(FLNM$) THEN EXIT SUB
REM --------------------------------------------------------------------------
DEF SEG = &HA000: BLOAD FLNM$, 0: DEF SEG
REM --------------------------------------------------------------------------
END SUB

SUB VGASAVE (VSAV$)
REM --------------------------------------------------------------------------
FLNM$ = UCASE$(VSAV$) + ".VGA"
REM --------------------------------------------------------------------------
IF FLNM$ = DIR$(FLNM$) THEN EXIT SUB
REM --------------------------------------------------------------------------
DEF SEG = &HA000: BSAVE FLNM$, 0, 64000: DEF SEG
REM --------------------------------------------------------------------------
END SUB

