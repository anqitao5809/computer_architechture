.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp) # matrix size
    sw s5, 24(sp) # matrix pointer
    
    mv s0 a0 
    mv s1 a1 #pointer to row address
    mv s2 a2 #pointer to column address
    
    mv a0 s0
    li a1 0
    jal ra fopen
    li t0 -1
    beq a0 t0 error27
    # a0 should now contain file's descriptor
    mv s3 a0 #s3 now contains the file's descriptor
    
    mv a0 s3
    mv a1 s1
    li a2 4
    jal ra fread
    li t0 4
    bne a0 t0 error29
    # now a2 is 4, a0 is 4, a1 points to the row num
    
    mv a0 s3
    mv a1 s2
    li a2 4
    jal ra fread
    li t0 4
    bne a0 t0 error29
    
    # now s2 points to the col, s1 points to the row
    
    lw t0 0(s1)
    lw t1 0(s2)
    mul s4 t0 t1
    slli s4 s4 2
    mv a0 s4
    jal ra malloc
    beq a0 x0 error26
    
    mv s5 a0
    
    mv a0 s3
    mv a1 s5
    mv a2 s4
    jal ra fread
    bne a0 s4 error29

    mv a0, s3
    jal ra, fclose
    li t0, -1
    beq a0, t0, error28

    mv a0, s5

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    
    
    # Epilogue

    jr ra
    
error26:
    li a0 26
    j exit
error27:
    li a0 27
    j exit
error28:
    li a0 28
    j exit
error29:
    li a0 29
    j exit