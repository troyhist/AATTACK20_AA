REM -------------------------------------------------------------------------
REM PCVS.BI include file ver. 2.0
REM For system PC Video System ver. 2.0
REM -------------------------------------------------------------------------
TYPE PALheader
        initPAL  AS STRING * 6
        name     AS STRING * 11
        caption  AS STRING * 256
        exCOL    AS INTEGER
        stCOL    AS INTEGER
        ptype    AS INTEGER
END TYPE
REM -------------------------------------------------------------------------

