	.data
op:	.asciiz "\n1. SOMA  2. SUBTRACAO  3.MULTIPLICACAO  4.DIVISAO\n5. POTENCIACAO  6. RADICIACAO 7. TABUADA  8. IMC\n9. FATORIAL 10. FIBONACCI 0. SAIR\n"
x:	.asciiz " x "
eq:	.asciiz " = "
bl:	.asciiz "\n"

	.text
main:	li $v0, 4     		#comando para impressão de string
	la $a0, op    		#imprime a string com as opcoes da calculdadora
	syscall       		#chamada do sistema
	
switch:	li $v0, 5    		#comando para input de inteiro como parametro para o switch		
	syscall	     		#chamada do sistema
	beq $v0, 1, sum		#comparação feita com o parametro: case 1 - adição
	beq $v0, 2, sub		#case 2 - subtração
	beq $v0, 3, mul		#case 3 - multiplicacao
	beq $v0, 4, div		#case 4 - divisão
	beq $v0, 5, pow		#case 5 - potencicao
	beq $v0, 6, sqr		#case 6 - radiciacao
	beq $v0, 7, tab		#case 7 - tabuada
	beq $v0, 8, imc		#case 8 - imc
	beq $v0, 9, fat		#case 9 - fatorial
	beq $v0, 10, fib	#case 10 - fibonnaci
	j sair

		
###############################################################################
sum:	li $v0, 6		#comando para leitura de float
	syscall       		#chamada do sistema
	mov.s $f1, $f0		#move input de f0 para f1
	
	syscall       		#chamada do sistema
	mov.s $f2, $f0		#move input de f0 para f2
	
	add.s $f1, $f1, $f2 	#realiza a operação f1 = f1 +f2
	mov.s $f12, $f1		#move resultado de f1 para f12
	
	li $v0, 2   		#comando para imprimir float
	syscall			#chamada do sistema
	j main			#jump para o labem main


###############################################################################
sub:	li $v0, 6		#comando para leitura de float
	syscall       		#chamada do sistema
	mov.s $f1, $f0		#move input de f0 para f1
	
	syscall       		#chamada do sistema
	mov.s $f2, $f0		#move input de f0 para f2
	
	sub.s $f1, $f1, $f2 	#realiza a operação f1 = f1 - f2
	mov.s $f12, $f1		#move resultado de f1 para f12
	
	li $v0, 2   		#comando para imprimir float
	syscall			#chamada do sistema
	j main			#jump para o labem main
	
###############################################################################
mul:	li $v0, 6		#comando para leitura de float
	syscall       		#chamada do sistema
	mov.s $f1, $f0		#move input de f0 para f1
	
	syscall       		#chamada do sistema
	mov.s $f2, $f0		#move input de f0 para f2
	
	mul.s $f1, $f1, $f2 	#realiza a operação f1 = f1 - f2
	mov.s $f12, $f1		#move resultado de f1 para f12
	
	li $v0, 2   		#comando para imprimir float
	syscall			#chamada do sistema
	j main			#jump para o labem main
	

###############################################################################
div:	li $v0, 6		#comando para leitura de float
	syscall       		#chamada do sistema
	mov.s $f1, $f0		#move input de f0 para f1
	
	syscall       		#chamada do sistema
	mov.s $f2, $f0		#move input de f0 para f2
	
	div.s $f1, $f1, $f2 	#realiza a operação f1 = f1 - f2
	mov.s $f12, $f1		#move resultado de f1 para f12
	
	li $v0, 2   		#comando para imprimir float
	syscall			#chamada do sistema
	j main			#jump para o labem main
	

###############################################################################
# t0=numero atual, t1=base, t2= expoente

pow:	li $v0, 5		#leitura de inteiro
	syscall			#chamada do sistema
	move $t1, $v0		#move o input de v0 para t1
	
	li $v0, 5		#leitura de inteiro
	syscall			#chamada do sistema
	move $t2, $v0		#copia v0 em t2
	move $t0, $t1		#copia t1 no t0
	
pop:	beq $t2, 1, pend	# se t2 for maior que 1, ele realiza a multiplicacao, senão, ele pula para o fim da rotina
	mul $t0, $t0, $t1	#mulltiplica t2 vezes t1/ t0= t0 * t1
	sub $t2, $t2, 1 	#t2 diminui
	j pop 			#pula para o inicio da operaçaao
	
pend:	move $a0, $t0		#copia t0 (resultado) em a0
	li $v0, 1		#comando para impressao de um inteiro
	syscall			#chamada do sistema
	j main			#pula de volta para a main


###############################################################################

#metodo de newton para a obtencao de raizes quadradas sqrt(a)= (a+x^2)/2x
#t0 = a, t7=x^2, t9=x

sqr:	li $v0, 5		#leitura de inteiro
	syscall			#chamada do sistema
	move $t0, $v0		#move o input de v0 para t0
	li $t7, 0		#auxiliar para a função get x
	li $t8, 1		#auxiliar para a função get x
	li $t9, 0		#contador para a função get x

#get x: encontra a raiz perfeita mais proxima de a atraves da soma dos a primeiros impares

getx:	add $t7, $t7, $t8	#adiciona o impar na soma total em t7
	add $t9, $t9, 1		#incrementa o contador
	add $t8, $t8, 2		#leva t8 para o proximo impar, adicionando 2
	bgt $t0, $t7, getx	#caso t0 seja maior que t7, a funcao recomeça
	
	add $t7, $t7, $t0	#t7 = t7 + t0 = x^2 + a
	mul $t9, $t9, 2		#t9 = t9*2 = 2x
	
	mtc1 $t7, $f12		#move t0 para f12 (integer to float)
	cvt.s.w $f12, $f12	# converte de inteiro para float
	
	mtc1 $t9, $f13 		#move t7 para f13
	cvt.s.w $f13, $f13	#converte int para float
	
	div.s $f12, $f12, $f13	#f12 = f12/f13 = sqrt(a)
	
	li $v0, 2   		#comando para imprimir float
	syscall			#chamada do sistema
	j main			#jump para o label main
	
##############################################################################

tab: 	li $v0, 5		#leitura de inteiro
	syscall			#chamada do sistema
	move $t0, $v0		#move o input de v0 para t0
	li $t1, 0		#carrega o valor zero no t1
	
tfor:	move $a0, $t0		#move o t1 para o a0
	li $v0, 1		#comando para impressao de inteiro
	syscall			#chamada do sistema
	
	la $a0, x		#carrega o endereço de x em a0
	li $v0, 4		#comando para impressao de string
	syscall
	
	move $a0, $t1		#move o t1 para o a0
	li $v0, 1		#comando para impressao de inteiro
	syscall			#chamada do sistema
	
	la $a0, eq		#carrega o endereço de x em a0
	li $v0, 4		#comando para impressao de string
	syscall			#chamada do sistema
	
	mul $a0, $t0, $t1	#a0 = t0 * t1
	li $v0, 1		#impressao de inteiros
	syscall			#chamada do sistema
	
	la $a0, bl		#carrega o endereço de x em a0
	li $v0, 4		#comando para impressao de string
	syscall			#chamada do sistema
	
	add $t1, $t1, 1		#adiciona 1 no iterador
	blt $t1, 10, tfor
	
	j main
	

###############################################################################

imc: 	li $v0, 6		#comando para leitura de float
	syscall       		#chamada do sistema
	mov.s $f1, $f0		#move input de f0 para f1
	
	li $v0, 6		#comando para leitura de float
	syscall       		#chamada do sistema
	mul.s $f0, $f0, $f0	#altura ao quadrado
	
	div.s $f12, $f1, $f0 	#peso/altura^2
	
	li $v0, 2   		#comando para imprimir float
	syscall			#chamada do sistema
	j main			#jump para o labem main
	
	
##############################################################################	
	
fat:	li $v0, 5		#leitura de inteiro
	syscall			#chamada do sistema
	move $a0, $v0		#copia o valor d $v0 em $a0		
	jal fatorial		#jump para fatorial com linkagem
	
	move $a0, $v0		#move $v0 para $a0
	li $v0, 1		#comando para output de inteiro
	syscall			#chama o sistma
	
	j main			#retorna a main
	
##############################################################################

fib:	li $v0, 5		#leitura de inteiro
	syscall			#chamada do sistema
	move $a0, $v0		#copia $v0 para $a0
	li $a1, 1		#inicia o a1 com valor 1
	li $a2, 1		#inicia o a2 com valor 1
	
	jal fibonacci		#jump para o label fibonnaci com linkagem
	
	move $a0, $v0		#copia $v0 em $a0
	li $v0, 1		#comando para output
	syscall			#chama o sistema
	
	j main			#volta pra main
	
	
###############################################################################	
sair:	li $v0,10     		#comando para a saida do programa
	syscall
	
	
	
	
	
	
	
.text
fatorial:
	sub $sp, $sp, 8		#aloca espaço em $sp para os parametros
	sw $a0, ($sp)		#salva o valor em a0
	sw $ra, 4($sp)		#salva o endereço de retorno
	
	bge $a0, 1, auxfat	#if a0>= 1, go to aufat
	
	add $v0, $zero, 1	#v0 = 0 + 1
	add $sp, $sp, 8		#desaloca o espaço na pilha
	jr $ra			#retorna ao endereço onde foi feito o jal

auxfat:	sub $a0, $a0,1		#a0 = a0 - 1
	jal fatorial		#pula para o fatorial com link
	
	lw $a0, ($sp)		#carrega, a partir da pilha, o endereço do valor de $a0 que foi salvo
	lw $ra, 4($sp)		#carrega, a partir da pilha, o endereço de retorno que foi salvo
	add $sp, $sp, 8		#desaloca o espaço da pilha
	
	mul $v0, $a0, $v0	#v0 =a0 * v0
	
	jr $ra			#retorna ao endereço onde jal foi chamado

fibonacci:
	sub $sp, $sp, 4		#aloca espaço na pilha
	sw $ra, ($sp)		#salva o endereço de retorno na pilha
	
	move $t0, $a2		#copia a2 em t0
	add $a2, $a1, $a2	#a2 = a1 + a2
	move $a1, $t0		#copia t0 em a1
	
	sub $a0, $a0, 1		#a0= a0 - 1
	
	blt $a0, 3, return	#se a0<3, vai para return
	jal fibonacci		#jump com link para fibonacci
	
return: move $v0, $a2		#copia a2 em v0
	lw $ra, ($sp)		#carrega o endereço de retorno salvo na pilha em $ra
	add $sp, $sp, 4		#desaloca o espaço na pilha
	jr $ra			#volta para onde jal foi chamado
	
		
	
	
	
	
