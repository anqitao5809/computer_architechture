# Setup: x1 = 1024
addi x1, x0, 1024

# --- TEST 1: The Clean Slate ---
# Verify sw works. Store 0xFFFFFFFF
addi x2, x0, -1      
sw x2, 0(x1)         
lw x10, 0(x1)        # x10 should be 0xFFFFFFFF (-1)

# --- TEST 2: SB Lane Alignment (Offset 1) ---
# Store 0x00 to byte 1. Result: 0xFFFF00FF
addi x3, x0, 0
sb x3, 1(x1)
lw x4, 0(x1)
srli x5, x4, 8
andi x11, x5, 255    # x11 should be 0. If 255, lane 1 store failed.

# --- TEST 3: SB Lane Alignment (Offset 3) ---
# Store 0xAA (170) to byte 3. Result: 0xAAFF00FF
addi x6, x0, 170
sb x6, 3(x1)
lw x7, 0(x1)
srli x8, x7, 24      
andi x12, x8, 255    # x12 should be 170

# --- TEST 4: SH Lane Alignment (Offset 2) ---
# Store 0x0102 (258) to bytes 2 and 3. 
# Result word: 0x010200FF
addi x9, x0, 258     
sh x9, 2(x1)
lw x13, 0(x1)        # x13 should be 16908543 (0x010200FF)

# --- TEST 5: Negative Byte Persistence ---
# Use x1 + 4 (1028) as a new base
addi x1, x1, 4
sw x0, 0(x1)         # Clear 1028
addi x14, x0, -1     
sb x14, 0(x1)        # Store 0xFF to 1028
lw x15, 0(x1)        # x15 should be 255 (0x000000FF)

# --- TEST 6: lb Sign Extension ---
lb x16, 0(x1)        # Load 0xFF from 1028
# x16 should be -1 (0xFFFFFFFF) because lb sign extends.