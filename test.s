	.data
msg:	.asciiz "Fin du programme !"
	.text
	 #Programme : addition + boucle conditionnelle
main:
	 #Initialisation : t0 = 0, t1 = 10
	li	$t0, 0
	li	$t1, 10
	 #Boucle : while (t0 < t1)
loop:
	 #Afficher t0
	move	$a0, $t0
	li	$v0, 1
	syscall
	 #Incrémenter t0
	add	$t0,$t0,1
	 #Condition : si t0 < t1, saut vers loop
	slt	$t2,$t0,$t1
	beq	$t2,$zero,end
	j	loop
end:
	 #Afficher le message final
	la	$a0, msg
	li	$v0, 4
	syscall
	 #Fin du programme
	li	$v0, 10
	syscall
