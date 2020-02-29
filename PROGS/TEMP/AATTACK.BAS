REM --------------------------------------------------------------------------
REM Alien Attack ver. 2.0
REM --------------------------------------------------------------------------
REM $INCLUDE: 'QBX.BI'
REM --------------------------------------------------------------------------
DEFINT A-Z: ON ERROR GOTO ERHAND
REM --------------------------------------------------------------------------
TYPE CFGheader
	initCFG   AS STRING * 6
	PATH      AS STRING * 64
	USER      AS STRING * 256
	serNUM    AS INTEGER
	videoCARD AS INTEGER
	sound     AS INTEGER
	music     AS INTEGER
	speed     AS INTEGER
END TYPE
REM --------------------------------------------------------------------------
TYPE SAFheader
	initSAF   AS STRING * 6
	introPICS AS STRING * 9
	introWAVS AS STRING * 9
	levelPICS AS STRING * 9
	levelWAVS AS STRING * 9
	gameSPRS  AS STRING * 8
	gameBGRS  AS STRING * 8
	Levels    AS INTEGER
	Sprites   AS INTEGER
	Backs     AS INTEGER
END TYPE
REM --------------------------------------------------------------------------
DATAS:
REM --------------------------------------------------------------------------
SK = 1: DIM CFG(1) AS CFGheader, SAF(1) AS SAFheader
REM --------------------------------------------------------------------------
PRINT
PRINT "Alien Attack ver. 2.0 (Support VGA graphics)"
PRINT "Troy computing, Inc."
PRINT "Kolevatow Sergey (c) 1996": PRINT : SLEEP
REM --------------------------------------------------------------------------
OPENCFG:   
REM --------------------------------------------------------------------------
FF = FREEFILE
OPEN "B", FF, "AATTACK.CFG"
SEEK #FF, 0 + SK: GET #FF, , CFG(1).initCFG
SEEK #FF, 6 + SK: GET #FF, , CFG(1).PATH
SEEK #FF, 70 + SK: GET #FF, , CFG(1).USER
SEEK #FF, 326 + SK: GET #FF, , CFG(1).serNUM
SEEK #FF, 328 + SK: GET #FF, , CFG(1).videoCARD
SEEK #FF, 330 + SK: GET #FF, , CFG(1).sound
SEEK #FF, 332 + SK: GET #FF, , CFG(1).music
SEEK #FF, 334 + SK: GET #FF, , CFG(1).speed
CLOSE FF
REM --------------------------------------------------------------------------
CHKCFG:
REM --------------------------------------------------------------------------
PRINT "Checking AATTACK.CFG data ...": PRINT
PRINT "initCFG    : "; CFG(1).initCFG
PRINT "PATH       : "; CFG(1).PATH
PRINT "USER       : "; LEFT$(CFG(1).USER, 50)
PRINT "serNUM     :"; CFG(1).serNUM
PRINT "videoCARD  :"; CFG(1).videoCARD
PRINT "sound      :"; CFG(1).sound
PRINT "music      :"; CFG(1).music
PRINT "speed      :"; CFG(1).speed
PRINT
REM --------------------------------------------------------------------------
OPENSAF:
REM --------------------------------------------------------------------------
FF = FREEFILE
OPEN "B", FF, "AATTACK.SAF"
SEEK #FF, 0 + SK: GET #FF, , SAF(1).initSAF
SEEK #FF, 6 + SK: GET #FF, , SAF(1).introPICS
SEEK #FF, 15 + SK: GET #FF, , SAF(1).introWAVS
SEEK #FF, 24 + SK: GET #FF, , SAF(1).levelPICS
SEEK #FF, 33 + SK: GET #FF, , SAF(1).levelWAVS
SEEK #FF, 42 + SK: GET #FF, , SAF(1).gameSPRS
SEEK #FF, 50 + SK: GET #FF, , SAF(1).gameBGRS
SEEK #FF, 58 + SK: GET #FF, , SAF(1).Levels
SEEK #FF, 60 + SK: GET #FF, , SAF(1).Sprites
SEEK #FF, 62 + SK: GET #FF, , SAF(1).Backs
CLOSE FF
REM --------------------------------------------------------------------------
CHKSAF:
REM --------------------------------------------------------------------------
PRINT "Checking AATTACK.SAF data ...": PRINT
PRINT "initSAF    : "; SAF(1).initSAF
PRINT "introPICS  : "; SAF(1).introPICS
PRINT "introWAVS  : "; SAF(1).introWAVS
PRINT "levelPICS  : "; SAF(1).levelPICS
PRINT "levelWAVS  : "; SAF(1).levelWAVS
PRINT "gameSPRS   : "; SAF(1).gameSPRS
PRINT "gameBGRS   : "; SAF(1).gameBGRS
PRINT "Levels     :"; SAF(1).Levels
PRINT "Sprites    :"; SAF(1).Sprites
PRINT "Backs      :"; SAF(1).Backs
END
REM --------------------------------------------------------------------------
ERHAND:
REM --------------------------------------------------------------------------
BEEP: PRINT "ERROR: Number"; ERR; "in line"; ERL
END
REM --------------------------------------------------------------------------

SUB PRINTSAF (TMPSAF() AS SAFheader)

END SUB

