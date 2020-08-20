# By DAVID SAVEV

.data
code: .byte  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
even: .byte 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
odd: .byte 1, 0, 5, 7, 9, 13, 15, 17, 19, 21, 2, 4, 18, 20, 11, 3, 6, 8, 12, 14, 16, 10, 22, 25, 24, 23, 1, 0, 5, 7, 9, 13, 15, 17, 19, 21
letter: .byte 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90
mycode: .byte 0:16
.align 2 
question: .asciiz "\nInsert an italian fiscal code (IN CAPITAL LETTERS): \n"
repeat: .asciiz "Do you want to verify another fiscal code? (TYPE Y for YES, ANYTHING ELSE FOR NO) "
true: .asciiz "\nThe insert fiscal code IS VALID :)\n"
false: .asciiz "\nThe insert fiscal code IS NOT VALID!\n"
.text

ini:
#Question to insert characters of fiscal code
li $v0, 4
la $a0, question
syscall

#Scans the insert string and puts it in the memory location mycode
li $v0, 8
li $a1, 17
la $a0, mycode
syscall

#Compaires the decimal value of each introduced character with the decimal value of all the characters present in code:
compairechar:
beq $t4, 37, notvalid
lb $t1, mycode($t3)
lb $t2, code($t4)
beq  $t1, $t2, evalueteoddeven
addi $t4, $t4, 1
j compairechar

#Evaluates if the pointer of the memory location is add or even
evalueteoddeven:
beq $t3, 0, oddnr
beq $t3, 2, oddnr
beq $t3, 4, oddnr
beq $t3, 6, oddnr
beq $t3, 8, oddnr
beq $t3, 10, oddnr
beq $t3, 12, oddnr
beq $t3, 14, oddnr
j evennr

#It loads the corresponding value of the character from odd and makes the sum
oddnr:
beq $t3, 15, calc
lb $t5, odd($t4)
add $s0, $s0, $t5
li $t4, 0
addi $t3, $t3, 1
j compairechar

#It loads the corresponding value of the character from even and makes the sum
evennr:
beq $t3, 15, calc
lb $t5, even($t4)
add $s0, $s0, $t5
li $t4, 0
addi $t3, $t3, 1
j compairechar

#It divides the total result by 26, multiplies the integer result by 26, then subtract the inital result with the founded one
#Then te result of the before done operation will compaired with the last letter of the inserted fiscal code
calc:
divu $s3, $s0, 26
mulu  $s3, $s3, 26
sub $s3, $s0, $s3
lb $s2, letter($s3)
lb $s1, mycode($t3)
beq $s2, $s1, valid
j notvalid

#If the fiscal code is valid, print string true
valid:
li $v0, 4
la $a0, true
syscall
j repeating

#If the fiscal code is not valid, print string false:
notvalid:
li $v0, 4
la $a0, false
syscall
j repeating

repeating:
li $t0, 0
li $t1, 0
li $t2, 0
li $t3, 0
li $t4, 0
li $t5, 0 #Resetting registers
li $s0, 0
li $s1, 0
li $s2, 0
li $s3, 0
li $v0, 4
la $a0, repeat
syscall
li $v0, 12
syscall
beq $v0, 89, ini #Comparation with ASCII 89 = 'Y'

end:
li $v0, 10
syscall





