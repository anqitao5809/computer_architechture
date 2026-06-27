.import ../src/utils.s
.import ../src/../coverage-src/initialize_zero.s

.data
.align 4
m0: .word 1

.globl main_test
.text
# main_test function for testing
main_test:

    # load address to array m0 into a0
    la a0 m0

    # call initialize_zero function
    jal ra initialize_zero
    # we expect initialize_zero to exit early with code 26

    # exit normally
    li a0 0
    jal exit
