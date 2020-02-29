REM ---------------------------------------------------------------------------
REM Graphics Convertor (GIF -> VGA + PAL) ver. 1.0
REM ---------------------------------------------------------------------------
REM ---------------------------------------------------------------------------
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
IF GIFN$ = "" THEN PRINT "Invalid Filename - Exit": END
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

