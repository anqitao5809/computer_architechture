.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    addi t1, x0, 1
    blt a1 t1 End
    
    # Prologue
    addi sp, sp, -12
    sw ra 0(sp)                                                                                         
    sw a1 4(sp)
    sw a0 8(sp)

loop_start:
    beq a1 x0 loop_end
    lw t0 0(a0)
    blt t0 x0 negative
    j loop_continue
negative:
    sw x0 0(a0)
    j loop_continue

loop_continue:
    addi a0, a0, 4
    addi a1, a1, -1
    j loop_start

loop_end:

    # Epilogue
    lw a0 8(sp)
    lw a1 4(sp)
    lw ra 0(sp)
    addi sp, sp, 12

    jr ra
End:
    li a0 36
    j exit
