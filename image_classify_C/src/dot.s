.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the number of elements to use is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    addi t0, x0, 1 # t0=1
    blt a2 t0 except_36
    blt a3 t0 except_37
    blt a4 t0 except_37
    
    addi t0, x0, 4
    
    mul a3, a3, t0
    mul a4, a4, t0
    

    # Prologue
    addi sp, sp, -4
    sw ra 0(sp)

    add t0, x0, x0 # t0 stores the sum so far, t0=0

loop_start:
    beq a2 x0 loop_end
    
    lw t1 0(a0) #t1 holds the first array's item
    lw t2 0(a1) #t2 holds the second array's item

    mul t3 t1 t2 #t3 holds the multiple
    add t0 t0 t3
    
    add a0 a0 a3
    add a1 a1 a4
    
    addi a2, a2, -1
    j loop_start
    
loop_end:
    
    mv a0 t0
    
    # Epilogue
    lw ra 0(sp)
    addi sp, sp, 4

    jr ra

except_36:
    li a0 36
    j exit
except_37:
    li a0 37
    j exit
