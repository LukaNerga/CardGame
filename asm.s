.section .data
seed:
    .long 0

.section .text
.global asm_seed
asm_seed:
    pushl %ebp
    movl  %esp, %ebp
    movl  8(%ebp), %eax    # load seed arg
    movl  %eax, seed       # store to global
    popl  %ebp
    ret

.global asm_rand
asm_rand:
    pushl %ebp
    movl  %esp, %ebp
    movl  seed, %eax       # load current seed
    imull $1103515245, %eax
    addl  $12345, %eax     # LCG step
    movl  %eax, seed       # update global seed
    popl  %ebp
    ret                   # return new seed in %eax

.global asm_move_logo
asm_move_logo:
    pushl %ebp
    movl  %esp, %ebp
    movl  8(%ebp), %ecx    # suit index
    movl  12(%ebp), %edx   # ptr to positions array
    movl  (%edx,%ecx,4), %eax  # load positions[suit]
    subl  $1, %eax            # move up one row
    movl  %eax, (%edx,%ecx,4) # store back
    popl  %ebp
    ret

.global asm_check_win
asm_check_win:
    pushl %ebp
    movl  %esp, %ebp
    movl  8(%ebp), %edx    # ptr to positions array
    movl  $0, %ecx         # index = 0

check_loop:
    movl  (%edx,%ecx,4), %eax  # load positions[index]
    cmpl  $0, %eax             # compare to top row
    je    win_found
    incl  %ecx                 # index++
    cmpl  $4, %ecx             # have we checked 0..3?
    jbe   check_loop

    movl  $-1, %eax            # no winner
    jmp   end_check

win_found:
    movl  %ecx, %eax           # return winner index

end_check:
    popl  %ebp
    ret
