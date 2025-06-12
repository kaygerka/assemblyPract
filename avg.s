.section .data
    prompt_n:    .string "n? "
    format_in:   .string "%ld"
    format_sum:  .string "SUM=%ld\n"
    format_avg:  .string "AVG=%ld\n"

.section .text
.globl main

main:
    pushq %rbp                  # stack frame
    movq %rsp, %rbp             #

                                # Print prompt for n
    movq $prompt_n, %rdi        # move the prompt_n address into register destination
    xorq %rax, %rax             # zeros out rax with XOR
    call printf                 # uses the prompt_n string (stored in rdi)
                                # no additional arguments in rax

                                # Read n
    subq $16, %rsp              # subracts quadword,two 8 bytes from the stack pointer
                                  # stack grows down, allocates two 8 byte values
    leaq -8(%rbp), %rsi         # load effective address (quadword), located 8 bytes below base ptr
                                  # calculates the addy where scanf will store the user input in rsi (2nd arg)
    movq $format_in, %rdi       # moves format_in string address into rdi ("ld")
    xorq %rax, %rax             #zeros out rax
    call scanf                  # calls scan f, it prints the format_in from rdi
                                # stores the user input into rsi
                                # knows no more arguments bc rax = 0

    movq -8(%rbp), %r12         # moves the value of n (bp-8) and stores it in r12 = n
    xorq %r13, %r13             # zeros out r13 gonna use it as SUM // r13 = sum (initialized to 0)
    xorq %r14, %r14             # zeros out r14, gonna use it as LOOP COUNTER // r14 = loop counter

read_loop:                      # label that marks the beginning of the loop, positions that jumps
    cmpq %r12, %r14             # subtracts r12-r14 and sets flag based on result
                                  # if r14>=r12// r14 (loop counter) is bigger than n// jumps back read_loop
                                  # if r14<r12 //r12 (n) is bigger than loop counter // countinues
    jge end_read_loop           # decides whether to continue or jump back to read_loop based on compare flag

                                # Read next number
    leaq -16(%rbp), %rsi        # calculate the addy by the stack growing down 16 bytes to store scanf input
    movq $format_in, %rdi       # move the address of format_in into rdi
    xorq %rax, %rax             # zero out rax
    call scanf                  # the first argument is rdi prints our format_in 
                                # the sec. arg is rsi which stores the address of the input from scanf

                                # Add to sum
    movq -16(%rbp), %rax        # copies user input into rax
    addq %rax, %r13             # SUM + user input = SUM

    incq %r14                   # incrememnt counter
    jmp read_loop               # end of loop // jump back to read_loop

end_read_loop:
                                # Print sum
    movq $format_sum, %rdi      # copies addy of format_sum into rdi (1st arg)
    movq %r13, %rsi             # copies addy of r13 SUM into rsi (2nd arg)
    xorq %rax, %rax             # zeros rax
    call printf                 # prints format_sum (rdi) and then prints SUM (rsi)

                                # Compute average
    movq %r13, %rax             # moves SUM value in to rax
    cqto                        # Sign-extend RAX into RDX:RAX
    idivq %r12                  # Divide RDX:RAX by loop counter (stored in r12)

                                # Print average
    movq $format_avg, %rdi      # copies format_av addy into rdi (first arg)
    movq %rax, %rsi             # moves rax into rsi (2nd arg)
    xorq %rax, %rax             # zeros out rax
    call printf                 # first prints format_avg (rdi) and then the AVG (rsi)

                                # Exit
    movq $0, %rax               # sets rax to 0 because rax is normally the return register
    leave                       # undoes the stack frame set up
    ret                         # returns from function
