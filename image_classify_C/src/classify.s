.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0 5
    bne t0 a0 error31
    
    addi sp sp -64
    sw ra 0(sp)
    sw s0 4(sp) #array of file path
    sw s1 8(sp) #contains print/don't print 1 or 0
    sw s2 12(sp) #num of arg, argc
    sw s3 16(sp) 
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7 32(sp)
    sw s8 36(sp)
    sw s9 40(sp)
    sw s10 44(sp)
    sw s11 48(sp)
    
    mv s0 a1  #s0 now contains array of file path           
    mv s1 a2 #print or not. 0, print, other, don't print
    mv s2 a0 # s2 contains num of argument  argc
    
    # Read pretrained m0
    lw a0 4(s0) # a0 contains m0's filename string pointer
    addi a1 sp 52
    addi a2 sp 56

    jal read_matrix #this handles errors for malloc and everything
    #now a0 holds pointer to m0 in memory
    mv s3 a0
    lw s4 52(sp)
    lw s5 56(sp)

    # Read pretrained m1
    lw a0 8(s0) # a0 contains m1's filename string pointer
    addi a1 sp 52
    addi a2 sp 56

    jal read_matrix #this handles errors for malloc and everything
    #now a0 holds pointer to m1 in memory
    mv s6 a0
    lw s7 52(sp)
    lw s8 56(sp)

    # Read input matrix
    lw a0 12(s0) # a0 contains input's filename string pointer
    addi a1 sp 52
    addi a2 sp 56

    jal read_matrix #this handles errors for malloc and everything
    #now a0 holds pointer to m1 in memory
    mv s9 a0
    lw s10 52(sp)
    lw s11 56(sp)

    # Compute h = matmul(m0, input)
    mul t0 s11 s4
    slli t0 t0 2
    mv a0 t0
    jal malloc
    beq a0 x0 error26
    
    #now a0 contains the allocated memory
    
    mv a6 a0
    mv s2 a6
    mv a0 s3
    mv a1 s4
    mv a2 s5
    mv a3 s9
    mv a4 s10
    mv a5 s11
    jal matmul
    #now a6 contains the pointer to the matrix, this will be h
    
    # Compute h = relu(h)
    mv a0 s2
    mul a1 s11 s4
    jal relu
    #now a0 should have the pointer to matrix, this is h
    sw a0 52(sp) #sp 52 now contains the h value
    # h matrix = row m0 times col input
    
    # Compute o = matmul(m1, h)
    #o matrix is m1 row times col input
    mul t0 s11 s7
    slli t0 t0 2
    mv a0 t0
    jal malloc
    beq a0 x0 error26

    # Write output matrix o
    #now a0 contains the allocated memory
    
    mv a6 a0
    mv s2 a6
    mv a0 s6
    mv a1 s7
    mv a2 s8
    lw a3 52(sp)
    mv a4 s4
    mv a5 s11
    jal matmul
    #a6 now has the pointer to the stored matrix matmul
    
    lw a0 16(s0)
    mv a1 s2
    mv a2 s7
    mv a3 s11
    sw s2 56(sp)
    jal write_matrix
    
    # matrix O is now written into the output file
    # sp 56 now has the pointer to matrix o
    
    # Compute and return argmax(o)
    lw a0 56(sp)
    mul a1 s11 s7
    jal argmax
    #now a0 contains index of largest index
    sw a0 60(sp) #final return value is stored at sp 60

    # If enabled, print argmax(o) and newline
    bne s1 x0 end

    jal print_int
    li a0 '\n'
    jal print_char
    
    j end
    
end:
    mv a0 s3
    jal free
    
    mv a0 s6
    jal free
    
    mv a0 s9
    jal free
    
    lw a0 52(sp)
    jal free
    
    lw a0 56(sp)
    jal free
    
    lw a0 60(sp)
    
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp) 
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7 32(sp)
    lw s8 36(sp)
    lw s9 40(sp)
    lw s10 44(sp)
    lw s11 48(sp)
    addi sp sp 64
    
    jr ra
    
error31:
    li a0 31
    j exit
error26:
    li a0 26
    j exit