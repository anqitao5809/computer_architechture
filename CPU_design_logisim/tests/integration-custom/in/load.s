addi x1, x0, 1024
addi x2, x0, -1
sw x2, 0(x1)
lw x3, 0(x1)
addi x2, x2, 1
sw x2, 0(x1)
lw x4, 0(x1)
addi x5, x0, 15
sb x5, 0(x1)
lb x6, 0(x1)
addi x7, x0, 255
sb x7, 1(x1)
lb x8, 1(x1)
lh x10, 0(x1)