.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    addi t1, x0, 1
    blt a1 t1 End
    
    addi sp, sp, -12
    sw ra 0(sp)                                                                                         
    sw a1 4(sp)
    sw a0 8(sp)
    
    add t0, x0, x0#t0 holds the current index
    add t3, x0, x0 #t3 holds the current max index
    lw t1 0(a0) #t1 holds the current max element

loop_start:
    beq a1 x0 loop_end
    lw t2 0(a0) #t2 holds the current element
    
    blt t1 t2 update_max
    j loop_continue
update_max:
    mv t1 t2
    mv t3 t0
    j loop_continue

loop_continue:
    addi t0, t0, 1
    addi a0, a0, 4
    addi a1, a1, -1
    j loop_start

loop_end:
    # Epilogue
    lw a0 8(sp)
    lw a1 4(sp)
    lw ra 0(sp)
    addi sp, sp, 12
    
    mv a0 t3

    jr ra
    
End:
    li a0 36
    j exit
