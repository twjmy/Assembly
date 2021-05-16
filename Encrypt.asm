; This program demonstrates simple symmetric
; encryption using the XOR instruction.

INCLUDE Irvine32.inc
BUFMAX = 128     	; maximum buffer size

.data
sPrompt  BYTE  "plain text: ",0
sKeypt   BYTE  "key: ",0
sEncrypt BYTE  "Cipher text: ",0
sDecrypt BYTE  "Decrypted: ",0
key      BYTE   BUFMAX+1 DUP(0)
buffer   BYTE   BUFMAX+1 DUP(0)
bufSize  DWORD  ?

.code
;-----------------------------------------------------
InputTheString PROC
;
; Prompts user for a plaintext string. Saves the string 
; and its length.
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
	pushad
	mov	edx,OFFSET sPrompt	; display a prompt
	call	WriteString
	mov	ecx,BUFMAX		; maximum character count
	mov	edx,OFFSET buffer   ; point to the buffer
	call	ReadString         	; input the string
	mov	bufSize,eax        	; save the length
	call	Crlf
	popad
	ret
InputTheString ENDP

;-----------------------------------------------------
InputTheKey PROC
;
; Prompts user for a key string. Saves the key to fit
; the plaintext size.
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
	pushad
	mov	edx, OFFSET sKeypt	; display the prompt
	call	WriteString
	mov	ecx, BUFMAX		; maximum character count
	mov	edx, OFFSET key   ; point to the buffer
	call	ReadString		; input the string

	cmp	eax, bufSize		; compare key size and plaintext size
	ja	L1		; if the key size is greater than plaintext, do nothing

	mov	ebx, bufSize		; ebx: caculate the number leave to fill
	sub	ebx, eax		; ebx = bufSize - keySize
	mov	ecx, ebx		; loop counter
	mov	esi, eax		; point to the end of the key

L2:
	sub	esi, eax
	mov	dl, key[esi]		; dl: get the correspond key to fill
	add	esi, eax
	mov	key[esi], dl		; fill the correspond key
	inc	esi		; point to next byte
	loop	L2		; fill the key till fit plaintext size

L1:
	call	Crlf
	popad
	ret
	InputTheKey ENDP

;-----------------------------------------------------
DisplayMessage PROC
;
; Displays the encrypted or decrypted message.
; Receives: EDX points to the message
; Returns:  nothing
;-----------------------------------------------------
	pushad
	call	WriteString
	mov	edx,OFFSET buffer	; display the buffer
	call	WriteString
	call	Crlf
	call	Crlf
	popad
	ret
DisplayMessage ENDP

;-----------------------------------------------------
TranslateBuffer PROC
;
; Translates the string by exclusive-ORing each
; byte with the encryption key byte.
; Receives: nothing
; Returns: nothing
;-----------------------------------------------------
	pushad
	mov	ecx,bufSize		; loop counter
	mov	esi,0			; index 0 in buffer
L1:
	mov	bl, key[esi]	; get the correspond key of the byte
	xor	buffer[esi],bl	; translate a byte
	inc	esi				; point to next byte
	loop	L1

	popad
	ret
TranslateBuffer ENDP

main PROC
	call	InputTheString		; input the plain text
	call	InputTheKey	; input the key
	call	TranslateBuffer	; encrypt the buffer
	mov	edx,OFFSET sEncrypt	; display encrypted message
	call	DisplayMessage
	call	TranslateBuffer  	; decrypt the buffer
	mov	edx,OFFSET sDecrypt	; display decrypted message
	call	DisplayMessage

	exit
main ENDP
END main
