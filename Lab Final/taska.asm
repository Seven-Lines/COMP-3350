# Important: do not put any other data before the frameBuffer
# Also: the Bitmap Display tool must be connected to MARS and set to
#   display width in pixels: 512
#   display height in pixels: 256
#   base address for display: 0x10010000 (static data) (this is the default starting address of the .data segment)
.data
imageBuffer:
.space 0x80000 # allocate space for 512 x 256 x 4 (each pixel is stored with a word)

.text
# Rectangle; left x-coordinate x1 is 200, width is 25
# top y-coordinate y1 is 100, height is 50. Coordinate system starts with
li $a0,200
li $a1,25
li $a2,100
li $a3,50
# invoke the procedure: rectangle 
jal rectangle

# TODO: Task c: draw another rectangle (parameters: x1=400, width is 30, y1=50, height=120)

# Exit after returning
li $v0,10
syscall

# procedure: rectangle
rectangle:
# $a0 is x1 (i.e., left edge; must be within the display)
# $a1 is width (must be nonnegative and within the display)
# $a2 is y1  (i.e., top edge, increasing down; must be within the display)
# $a3 is height (must be nonnegative and within the display)

beq $a1,$zero,rectangleReturn # zero width: draw nothing
beq $a3,$zero,rectangleReturn # zero height: draw nothing

# TODO: Task b: change the color to magenta
li $t0,0x00FFFFFF # color: white in 24-bit RGB
#li $t0,0xFF0000FF # color: blue

la $t1,imageBuffer
add $a1,$a1,$a0 # x2=width+x1
add $a3,$a3,$a2 # y2=height+y1
sll $a0,$a0,2 # scale x1 value to bytes (4 bytes per pixel)
sll $a1,$a1,2 # scale x2 value to bytes (4 bytes per pixel)
sll $a2,$a2,11 # scale y1 value to bytes (512*4 bytes per display row)
sll $a3,$a3,11 # scale y2 value to bytes (512*4 bytes per display row)

addu $t2,$a2,$t1 # row starting address(base + y1_scaled)
addu $a2,$t2,$a0 # first row pixel starting address(base + y1_scaled +X1_scaled)

addu $a3,$a3,$t1 # ending row address (base + y2_scaled)
addu $a3,$a3,$a0 # last row ending pixell addresss(base + y2_scaled +x2_scaled)

addu $t2,$t2,$a1 # and compute the ending address for first rectangle row (base + y1_scaled + x2_scaled)
li $t4,0x800 # offset per display row in bytes. 0x800 = 2048 = 512*4

rectangleYloop:
    move $t3,$a2           # $t3 points to the start pixel of the current row

rectangleXloop:
    sw $t0,($t3)           # paint this pixel
    addiu $t3,$t3,4        # move to the next pixel in the row
    bne $t3,$t2,rectangleXloop  # continue until we reach the right edge of the rectangle

    # Done with the current row, move down one row
    addu $a2,$a2,$t4       # advance the left-edge pointer ($a2) down one row
    addu $t2,$t2,$t4       # advance the right-edge pointer ($t2) down one row

    bne $a2,$a3,rectangleYloop  # continue until we reach the bottom of the rectangle

# continue Y loop for each row
# %TODO Task a: complete the following code
# advace one row (left-edge pointer)
# advace one row (right-edge pointer)
bne $a2,$a3,rectangleYloop # keep going if not exceeding the bottom of the rectangle

# return from the rectangle procedure
rectangleReturn:
jr $ra