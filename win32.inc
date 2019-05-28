CHARTYPE UNION
    UnicodeChar    WORD ?
    AsciiChar      DB ?
CHARTYPE ENDS

CHAR_INFO STRUCT
    Char          CHARTYPE <>
    Attributes    WORD ?
CHAR_INFO ENDS

WriteConsoleOutput EQU <WriteConsoleOutputA>

WriteConsoleOutput PROTO,
    hConsoleOutput:HANDLE,
    lpBuffer:PTR CHAR_INFO,
    dwBufferSize:COORD,
    dwBufferCoord:COORD,
    lpWriteRegion:PTR SMALL_RECT