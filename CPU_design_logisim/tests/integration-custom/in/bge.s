addi t0, x0, 5
addi t1, x0, 10
addi t2, x0, -1
addi t3, x0, 1
bge t1, t0, label1
addi x0, x0, 0
label1:
bge t0, t1, label2
addi x0, x0, 0
label2:
bgeu t1, t0, label3
addi x0, x0, 0
label3:
bgeu t3, t2, label4
addi x0, x0, 0
label4:
addi a0, x0, 1
ecall