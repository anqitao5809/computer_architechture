addi t0, x0, 10
addi t1, x0, 10
addi t2, x0, 5
addi t3, x0, -1
addi t4, x0, 1
beq t0, t1, L1
addi s0, x0, 1
L1:
beq t0, t2, L2
addi s1, x0, 1
L2:
bne t0, t2, L3
addi s2, x0, 1
L3:
bne t0, t1, L4
addi s3, x0, 1
L4:
blt t2, t0, L5
addi s4, x0, 1
L5:
blt t0, t2, L6
addi s5, x0, 1
L6:
bge t0, t2, L7
addi s6, x0, 1
L7:
bge t2, t0, L8
addi s7, x0, 1
L8:
bltu t2, t0, L9
addi s8, x0, 1
L9:
bltu t3, t2, L10
addi s9, x0, 1
L10:
bgeu t3, t2, L11
addi a0, x0, 1
L11:
bgeu t2, t3, L12
addi a1, x0, 1
L12:
addi a2, x0, 100