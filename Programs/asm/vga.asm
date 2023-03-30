#org 0x0000
                LDI 0xfe STA 0xffff                        ; initialize stack

                CLW _XPos
  reset:        LXI 32
  again:        INX BCS reset
                PHS JPS _PrintChar PLS
                LDA _YPos CPI 29 BCC weiter
                  CLB _YPos
  weiter:       JPS _ReadInput CPI 0 BEQ again
                
                LDI 0xff PHS JPS VGA_Fill PLS
                JPS _WaitInput

                JPS _Clear

loop1:          JPS _Random ANI 63 CPI 50 BCS loop1 STA _XPos
                JPS _Random ANI 31 CPI 29 BCS loop1 STA _YPos
                LDI <text PHS LDI >text PHS JPS _Print PLS PLS
                JPS _ReadInput CPI 0 BEQ loop1

                JPS _Clear

loop2:          JPS _Random CPI 200 BCS loop2
                  LSL STA rnd+0 LDI 0 ROL STA rnd+1
                  JPS _Random ANI 1 ORA rnd+0 PHS LDA rnd+1 PHS
  loop70:       JPS _Random CPI 240 BCS loop70 PHS
                JPS _SetPixel LDI 3 ADB 0xffff
                JPS _ReadInput CPI 0 BEQ loop2

                JPS _Clear

loop4:          JPS _Random PHS LDI 0 PHS JPS _Random LSR PHS   ; x: 0-255, y:0-127
                LDI 144 PHS LDI 0 PHS LDI 112 PHS
                JPS _ScanPS2
                JPS _Rect LDI 6 ADB 0xffff
                JPS _ReadInput CPI 0 BEQ loop4

                JPS _Clear

loop3:          JPS _Random PHS CPI 144 BCS nulllsb1
                  JPS _Random ANI 0x01 PHS JPA loop71
  nulllsb1:     LDI 0 PHS
  loop71:         JPS _Random CPI 240 BCS loop71 PHS
                JPS _Random PHS CPI 144 BCS nulllsb2
                  JPS _Random ANI 0x01 PHS JPA loop6
  nulllsb2:     LDI 0 PHS
  loop6:        JPS _Random CPI 240 BCS loop6 PHS
                JPS _ScanPS2
                JPS _Line LDI 6 ADB 0xffff
                JPS _ReadInput CPI 0 BEQ loop3

                CLB _XPos LDI 29 STA _YPos                    ; set cusor to bottom left
                JPA _Prompt

text:           'Hello, world!', 0
rnd:            0xffff

; *******************************************************************************
; Fills pixel area with <val>
; push: <val>
; pull: #
; *******************************************************************************
VGA_Fill:       LDS 3 STA vf_loopx+1
                LDI <0xc30c STA vf_loopx+3                ; set start index
                LDI >0xc30c STA vf_loopx+4
                LYI 240                                      ; number of lines
  vf_loopy:     LXI 50                                       ; number of cols
  vf_loopx:     LDI 0xff STA 0xffff
                INB vf_loopx+3
                DEX BGT vf_loopx                             ; self-modifying code
                  LDI 14 ADW vf_loopx+3                      ; add blank cols
                  DEY BGT vf_loopy
                    RTS

#mute                         ; MinOS label definitions generated by 'asm os.asm -s_'

#org 0xb000 _Start:
#org 0xb003 _Prompt:
#org 0xb006 _ReadLine:
#org 0xb009 _ReadSpace:
#org 0xb00c _ReadHex:
#org 0xb00f _SerialWait:
#org 0xb012 _SerialPrint:
#org 0xb015 _FindFile:
#org 0xb018 _LoadFile:
#org 0xb01b _SaveFile:
#org 0xb01e _MemMove:
#org 0xb021 _Random:
#org 0xb024 _ScanPS2:
#org 0xb027 _ReadInput:
#org 0xb02a _WaitInput:
#org 0xb02d _ClearVRAM:
#org 0xb030 _Clear:
#org 0xb033 _ClearRow:
#org 0xb036 _SetPixel:
#org 0xb039 _ClrPixel:
#org 0xb03c _GetPixel:
#org 0xb03f _Char:
#org 0xb042 _Line:
#org 0xb045 _Rect:
#org 0xb048 _Print:
#org 0xb04b _PrintChar:
#org 0xb04e _PrintHex:
#org 0xb051 _ScrollUp:
#org 0xb054 _ScrollDn:
#org 0xbf70 _ReadPtr:
#org 0xbf72 _ReadNum:
#org 0xbf84 _RandomState:
#org 0xbf8c _XPos:
#org 0xbf8d _YPos:
#org 0xbf8e _ReadBuffer:

