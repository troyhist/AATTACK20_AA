REM --------------------------------------------------------------------------
REM Alien Attack Setup ver. 1.0
REM --------------------------------------------------------------------------
REM $INCLUDE: 'QBX.BI'
REM $INCLUDE: 'AATTACK.BI'
REM --------------------------------------------------------------------------
DECLARE FUNCTION RETHARD$ (DATAS%, NUM%)
DECLARE FUNCTION CHITEM% (FROM%, ABSL%, LOCX%, LOCY%)
DECLARE FUNCTION NOTSTR$ (ASCSTR$)
REM --------------------------------------------------------------------------
DECLARE SUB CLEARSCR (Par%)
DECLARE SUB CREATSCR (CFG AS ANY, Par%)
DECLARE SUB SAVECFG (CFG AS ANY)
DECLARE SUB SCRLOAD ()
DECLARE SUB SHOWSCR (ASCCOD%, COL%)
DECLARE SUB SCRSAVE ()
DECLARE SUB PAUSE ()
REM --------------------------------------------------------------------------
DEFINT A-Z: ON ERROR GOTO ERHAND
REM --------------------------------------------------------------------------
DATAS:
REM --------------------------------------------------------------------------
DIM CFG AS CFGheader
REM --------------------------------------------------------------------------
IF DIR$(CFGFL$) <> CFGFL$ THEN
	CFG.initCFG = "CFG96a"
	CFG.PATH = NOTSTR$(CURDIR$) + STRING$(64, 223)
	CFG.USER = NOTSTR$(TCTM$) + STRING$(256, 223)
	CFG.serNUM = &HFFFF
	CFG.videoCARD = 5
	CFG.sound = 3
	CFG.music = 0
	CFG.speed = 5
REM --------------------------------------------------------------------------
ELSE
FF = FREEFILE: OPEN "B", FF, CFGFL$
SEEK #FF, 0 + SK: GET #1, , CFG.initCFG
SEEK #FF, 6 + SK: GET #1, , CFG.PATH
SEEK #FF, 70 + SK: GET #1, , CFG.USER
SEEK #FF, 326 + SK: GET #1, , CFG.serNUM
SEEK #FF, 328 + SK: GET #1, , CFG.videoCARD
SEEK #FF, 330 + SK: GET #1, , CFG.sound
SEEK #FF, 332 + SK: GET #1, , CFG.music
SEEK #FF, 334 + SK: GET #1, , CFG.speed
CLOSE FF
END IF
REM --------------------------------------------------------------------------
RESTART:
REM --------------------------------------------------------------------------
CREATSCR CFG, 0: LOCATE 19, 6: PRINT "Choose any item - "; : ITEM% = CHITEM%(1, 4, 24, 19)
REM --------------------------------------------------------------------------
IF ITEM% = 0 THEN ITEM% = 4
IF ITEM% = 1 THEN
	WHILE ITEM% <> 0
	CREATSCR CFG, 1
	ITEM% = CHITEM%(1, 5, 24, 11)
	IF ITEM% = 1 THEN
		CREATSCR CFG, 2
		INPUT "", P$: P$ = LTRIM$(UCASE$(P$))
		IF P$ <> "" THEN
			IF LEN(P$) > 64 THEN P$ = LEFT$(P$, 64)
			IF RIGHT$(P$, 1) = "\" THEN P$ = LEFT$(P$, LEN(P$) - 1)
			CFG.PATH = NOTSTR$(P$ + STRING$(64, CHR$(32)))
		END IF
	END IF
	IF ITEM% = 2 THEN CREATSCR CFG, 3: CFG.videoCARD = CHITEM%(1, 5, 24, 11)
	IF ITEM% = 3 THEN CREATSCR CFG, 4: CFG.sound = CHITEM%(1, 5, 24, 11) - 1
	IF ITEM% = 4 THEN CREATSCR CFG, 5: CFG.music = CHITEM%(1, 5, 24, 11) - 1
	IF ITEM% = 5 THEN CREATSCR CFG, 6: CFG.speed = CHITEM%(1, 9, 24, 15)
	WEND: SCRLOAD
	GOTO RESTART
ELSEIF ITEM% = 2 OR ITEM% = 3 THEN
	SAVECFG CFG
	IF ITEM% = 2 THEN
		LOCATE 21, 6: PRINT "Configuration save succefull ... Press any key to restart"
		CALL PAUSE: SCRLOAD
		RUN
	ELSEIF ITEM% = 3 THEN
		LOCATE 21, 6: PRINT "Configuration save succefull ... Press any key to exit"
		PAUSE
	END IF
REM --------------------------------------------------------------------------
ELSEIF ITEM% = 4 THEN
	LOCATE 21, 6: PRINT "Configuration not saved ... Press any key to exit"
	PAUSE
REM --------------------------------------------------------------------------
END IF
REM --------------------------------------------------------------------------
CALL SCRLOAD: COLOR 7, 0, 0: END
REM --------------------------------------------------------------------------
ERHAND:
REM --------------------------------------------------------------------------
CALL SCRLOAD: COLOR 7, 0, 0: PRINT "ERROR: Number"; ERR; "in line"; ERL: END
REM --------------------------------------------------------------------------

FUNCTION CHITEM% (FROM%, ABSL%, LOCX%, LOCY%)
LOCATE LOCY%, LOCX%: COLOR 24: PRINT "_"
WHILE I% < FROM% OR I% > ABSL%
I$ = INKEY$
I% = VAL(I$)
IF MID$(I$, 2, 1) = CHR$(45) THEN
	SCRLOAD
	COLOR 7, 0, 0
	END
END IF
IF I$ = CHR$(27) THEN
	LOCATE LOCY%, LOCX%:
	COLOR 15, 7: PRINT "0":
	EXIT FUNCTION
END IF
WEND
LOCATE LOCY%, LOCX%: COLOR 15, 7: PRINT LTRIM$(STR$(I%))
CHITEM% = I%
END FUNCTION

SUB CLEARSCR (Par%)
REM --------------------------------------------------------------------------
IF Par% < 0 OR Par% > 1 THEN Par% = 0
REM --------------------------------------------------------------------------
IF Par% = 0 THEN
REM --------------------------------------------------------------------------
CALL SCRSAVE: SHOWSCR &HB0, &H71: COLOR 7, 8
LOCATE 1, 1: PRINT STRING$(80, 219)
LOCATE 25, 1: PRINT STRING$(80, 219); : COLOR 8, 2
LOCATE 1, 25: PRINT " Alien Attack Setup ver. 1.0 ": COLOR 4, 7
LOCATE 1, 3: PRINT "F": LOCATE 1, 9: PRINT "O"
LOCATE 25, 2: PRINT "Alt-X "; : COLOR 0, 7
LOCATE 1, 4: PRINT "ile": LOCATE 1, 10: PRINT "ptions"
LOCATE 25, 8: PRINT "Exit"; : COLOR 15, 7
REM --------------------------------------------------------------------------
ELSEIF Par% = 1 THEN
REM --------------------------------------------------------------------------
SHOWSCR &HB0, &H71: COLOR 7, 8
LOCATE 1, 1: PRINT STRING$(80, 219)
LOCATE 25, 1: PRINT STRING$(80, 219); : COLOR 8, 2
LOCATE 1, 25: PRINT " Alien Attack Setup ver. 1.0 ": COLOR 4, 7
LOCATE 25, 2: PRINT "Alt-X "; : COLOR 0, 7
LOCATE 25, 8: PRINT "Exit"; : COLOR 15, 7
REM --------------------------------------------------------------------------
END IF
REM --------------------------------------------------------------------------
END SUB

SUB CREATSCR (CFG AS CFGheader, Par%)
REM --------------------------------------------------------------------------
IF Par% < 0 OR Par% > 6 THEN Par% = 0
REM --------------------------------------------------------------------------
IF Par% = 0 THEN
REM --------------------------------------------------------------------------
CLEARSCR 0
LOCATE 3, 3: PRINT "Setup Informations:"
REM --------------------------------------------------------------------------
LOCATE 5, 3: PRINT "initCFG   : "; CFG.initCFG
LOCATE 6, 3: PRINT "PATH      : "; RTRIM$(NOTSTR$(CFG.PATH))
LOCATE 7, 3: PRINT "USER      : "; RTRIM$(LEFT$(NOTSTR$(CFG.USER), 64))
LOCATE 8, 3: PRINT "serNUM    :"; CFG.serNUM
LOCATE 9, 3: PRINT "videoCARD : "; RETHARD$(CFG.videoCARD, 4)
LOCATE 10, 3: PRINT "sound     : "; RETHARD$(CFG.sound, 5)
LOCATE 11, 3: PRINT "music     : "; RETHARD$(CFG.music, 6)
LOCATE 12, 3: PRINT "speed     : "; RETHARD$(CFG.speed, 7)
REM --------------------------------------------------------------------------
LOCATE 14, 3: PRINT "1. Edit current configuration"
LOCATE 15, 3: PRINT "2. Save current configuration"
LOCATE 16, 3: PRINT "3. Save&Exit"
LOCATE 17, 3: PRINT "4. Exit without saving"
REM --------------------------------------------------------------------------
ELSEIF Par% = 1 THEN
REM --------------------------------------------------------------------------
CLEARSCR 1
REM --------------------------------------------------------------------------
LOCATE 3, 3: PRINT "Parametrs to edit:"
LOCATE 5, 3: PRINT "1. PATH      : "; RTRIM$(NOTSTR$(CFG.PATH))
LOCATE 6, 3: PRINT "2. videoCARD : "; RETHARD$(CFG.videoCARD, 4)
LOCATE 7, 3: PRINT "3. sound     : "; RETHARD$(CFG.sound, 5)
LOCATE 8, 3: PRINT "4. music     : "; RETHARD$(CFG.music, 6)
LOCATE 9, 3: PRINT "5. speed     : "; RETHARD$(CFG.speed, 7)
LOCATE 11, 6: PRINT "Choose any item - "
REM --------------------------------------------------------------------------
ELSEIF Par% = 2 THEN
REM --------------------------------------------------------------------------
CLEARSCR 1
REM --------------------------------------------------------------------------
LOCATE 3, 3: PRINT "Old PATH is    : "; RTRIM$(NOTSTR$(CFG.PATH))
LOCATE 5, 3: PRINT "Enter new PATH : ";
REM --------------------------------------------------------------------------
ELSEIF Par% = 3 THEN
REM --------------------------------------------------------------------------
CLEARSCR 1
REM --------------------------------------------------------------------------
LOCATE 3, 3: PRINT "Video Cards:"
LOCATE 5, 3: PRINT "1. "; RETHARD$(1, 4)
LOCATE 6, 3: PRINT "2. "; RETHARD$(2, 4)
LOCATE 7, 3: PRINT "3. "; RETHARD$(3, 4)
LOCATE 8, 3: PRINT "4. "; RETHARD$(4, 4)
LOCATE 9, 3: PRINT "5. "; RETHARD$(5, 4)
LOCATE 11, 6: PRINT "Choose any item - "
REM --------------------------------------------------------------------------
ELSEIF Par% = 4 THEN
REM --------------------------------------------------------------------------
CLEARSCR 1
REM --------------------------------------------------------------------------
LOCATE 3, 3: PRINT "Sound Cards:"
LOCATE 5, 3: PRINT "1. "; RETHARD$(0, 5)
LOCATE 6, 3: PRINT "2. "; RETHARD$(1, 5)
LOCATE 7, 3: PRINT "3. "; RETHARD$(2, 5)
LOCATE 8, 3: PRINT "4. "; RETHARD$(3, 5)
LOCATE 9, 3: PRINT "5. "; RETHARD$(4, 5)
LOCATE 11, 6: PRINT "Choose any item - "
REM --------------------------------------------------------------------------
ELSEIF Par% = 5 THEN
REM --------------------------------------------------------------------------
CLEARSCR 1
REM --------------------------------------------------------------------------
LOCATE 3, 3: PRINT "Music Cards:"
LOCATE 5, 3: PRINT "1. "; RETHARD$(0, 6)
LOCATE 6, 3: PRINT "2. "; RETHARD$(1, 6)
LOCATE 7, 3: PRINT "3. "; RETHARD$(2, 6)
LOCATE 8, 3: PRINT "4. "; RETHARD$(3, 6)
LOCATE 9, 3: PRINT "5. "; RETHARD$(4, 6)
LOCATE 11, 6: PRINT "Choose any item - "
REM --------------------------------------------------------------------------
ELSEIF Par% = 6 THEN
REM --------------------------------------------------------------------------
CLEARSCR 1
REM --------------------------------------------------------------------------
LOCATE 3, 3: PRINT "Computer Type:"
LOCATE 5, 3: PRINT "1. "; RETHARD$(1, 7)
LOCATE 6, 3: PRINT "2. "; RETHARD$(2, 7)
LOCATE 7, 3: PRINT "3. "; RETHARD$(3, 7)
LOCATE 8, 3: PRINT "4. "; RETHARD$(4, 7)
LOCATE 9, 3: PRINT "5. "; RETHARD$(5, 7)
LOCATE 10, 3: PRINT "6. "; RETHARD$(6, 7)
LOCATE 11, 3: PRINT "7. "; RETHARD$(7, 7)
LOCATE 12, 3: PRINT "8. "; RETHARD$(8, 7)
LOCATE 13, 3: PRINT "9. "; RETHARD$(9, 7)
LOCATE 15, 6: PRINT "Choose any item - "
REM --------------------------------------------------------------------------
END IF
REM --------------------------------------------------------------------------
END SUB

FUNCTION NOTSTR$ (ASCSTR$)
FOR A = 1 TO LEN(ASCSTR$)
B$ = MID$(ASCSTR$, A, 1)
C = 255 - ASC(B$)
C$ = CHR$(C)
NEWSTR$ = NEWSTR$ + C$
NEXT A
NOTSTR$ = NEWSTR$
END FUNCTION

SUB PAUSE
WHILE A$ = ""
A$ = INKEY$
WEND
END SUB

FUNCTION RETHARD$ (DATAS%, NUM%)
REM --------------------------------------------------------------------------
IF NUM% < 4 OR NUM% > 7 THEN NUM% = 4
IF DATAS% < 0 THEN DATAS% = 0
REM --------------------------------------------------------------------------
IF NUM% = 4 THEN
	IF DATAS% = 0 THEN TMPHARD$ = "CGA-mono"
	IF DATAS% = 1 THEN TMPHARD$ = "CGA-mono"
	IF DATAS% = 2 THEN TMPHARD$ = "CGA-colour"
	IF DATAS% = 3 THEN TMPHARD$ = "EGA-standart"
	IF DATAS% = 4 THEN TMPHARD$ = "VGA-mono"
	IF DATAS% = 5 THEN TMPHARD$ = "VGA-standart"
	IF DATAS% > 5 THEN TMPHARD$ = "Reserved"
REM --------------------------------------------------------------------------
ELSEIF NUM% = 5 OR NUM% = 6 THEN
	IF DATAS% = 0 AND NUM% = 5 THEN TMPHARD$ = "No sound"
	IF DATAS% = 0 AND NUM% = 6 THEN TMPHARD$ = "No music"
	IF DATAS% = 1 THEN TMPHARD$ = "PC-speaker"
	IF DATAS% = 2 THEN TMPHARD$ = "AdLib"
	IF DATAS% = 3 THEN TMPHARD$ = "Sound Blaster 8 Bit"
	IF DATAS% = 4 THEN TMPHARD$ = "Sound Blaster Pro 8 Bit"
	IF DATAS% > 4 THEN TMPHARD$ = "Reserved"
REM --------------------------------------------------------------------------
ELSEIF NUM% = 7 THEN
	IF DATAS% = 0 THEN TMPHARD$ = "PC XT"
	IF DATAS% = 1 THEN TMPHARD$ = "PC XT Turbo"
	IF DATAS% = 2 THEN TMPHARD$ = "PC AT 286"
	IF DATAS% = 3 THEN TMPHARD$ = "AT 386 SX"
	IF DATAS% = 4 THEN TMPHARD$ = "AT 386 DX"
	IF DATAS% = 5 THEN TMPHARD$ = "AT 486 SX"
	IF DATAS% = 6 THEN TMPHARD$ = "AT 486 DX"
	IF DATAS% = 7 THEN TMPHARD$ = "AT 486 DX2"
	IF DATAS% = 8 THEN TMPHARD$ = "AT 486 DX4"
	IF DATAS% = 9 THEN TMPHARD$ = "Pentium - 120"
	IF DATAS% = &HA THEN TMPHARD$ = "Pentium - 133"
REM --------------------------------------------------------------------------
END IF
REM --------------------------------------------------------------------------
RETHARD$ = TMPHARD$
END FUNCTION

SUB SAVECFG (CFG AS CFGheader)
REM --------------------------------------------------------------------------
	FF = FREEFILE: OPEN "B", FF, CFGFL$
	SEEK #FF, 0 + SK: PUT #1, , CFG.initCFG
	SEEK #FF, 6 + SK: PUT #1, , CFG.PATH
	SEEK #FF, 70 + SK: PUT #1, , CFG.USER
	SEEK #FF, 326 + SK: PUT #1, , CFG.serNUM
	SEEK #FF, 328 + SK: PUT #1, , CFG.videoCARD
	SEEK #FF, 330 + SK: PUT #1, , CFG.sound
	SEEK #FF, 332 + SK: PUT #1, , CFG.music
	SEEK #FF, 334 + SK: PUT #1, , CFG.speed
	CLOSE FF
REM --------------------------------------------------------------------------
END SUB

SUB SCRLOAD
DEF SEG = &HB800: BLOAD "$$%SCR%$.CLT", 0: DEF SEG : KILL "$$%SCR%$.CLT"
END SUB

SUB SCRSAVE
DEF SEG = &HB800: BSAVE "$$%SCR%$.CLT", 0, 4000: DEF SEG
END SUB

SUB SHOWSCR (ASCCOD%, COL%)
DEF SEG = &HB800
FOR A = 0 TO 4000 STEP 2
POKE A + 0, ASCCOD%
POKE A + 1, COL%
NEXT A
DEF SEG
END SUB

