.data
char: .byte 'a'
numbersArr: .space 12
charArr: .space 8


.text

main:
li $s1, 0		#stores first didgit
li $s2, 0		#stores second digit
li $s3, 0		#stores result
li $s4, 0		#incrementation

lui $t0, 0xFFFF
li $t9, 1
sw $t9, 8($t0)			#initialize transmitter bit
			#receiver control address 
			#0xffff0000
			#receiver data address
			#0xffff0004
			#transmitter contgrol address
			#0xffff0008
			#transmitter data 
			#0xffff0012
			#sb $a0, 0xffff0012

#turn on transmitter control bit
Loop1:				#Polling for input
	beq $s4, 4, EXIT
	lw 	$t1, 0($t0)		#$t0 contains receiver control address
	andi 	$t2, $t1, 0x0001	#compare bits between rec. and data in hardware (true false)
	beq 	$t2, $zero, Loop1	#reloop if data in data is not present, "key pressed" "byte received" = 1
	lw 	$a0, 4($t0)		#Load byte data in $t0 into argument register
					#$a0 contains either ( 'number' or '+')	
				
					#increment counter to say that a value has been inserted into @$a0
	addi $s4, $s4, 1
	beq $s4, 1, ADDTORESULT
	beq $s4, 3, ADDTORESULT
					#if read counter is equal to 1 or 3, add those results to the result register and increment to se			#fifth character read
																
				#get

#addi $a0, $a0, -48		#convert acii value of argument into integer value
				#take input data and convert to int and store in register for final computation
	sb $a0, 0xFFFF000c		#loading the ascii value into the transmitter data register
	j Loop1	
			
#Terminate Program
ADDTORESULT:
	add $a0, $a0, -48			#ascii to int
	add $s3, $a0, $s3
	add, $a0, $a0, 48
	sb $a0, 0xFFFF000c		#loading the ascii value into the transmitter data register
	j Loop1

EXIT:
	addi $s3, $s3, 48
	move $a0, $s3
	sb $a0, 0xFFFF000c
	li $v0, 10
	syscall
