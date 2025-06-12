.text
.globl bubblesort

bubblesort:
    pushq %rbp                        # base pointer
    movq %rsp, %rbp
    
    pushq %rbx                        # pushing registers to use for future use
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15

    movq %rdi, %r12                   # copy %rdi addy into r12 (ascending)
    movq %rsi, %r13                   # copy rsi addy into r13 (n)
    movq %rdx, %r14                   # copy rdx addy into r14 (a)
    
                                      # for (int i = 0; i < n - 1; i++)
    xorq %r15, %r15                   # zero out r15 ( i = 0)

outer_loop:
    movq %r13, %rax                   # copies r13 (n) to rax bc we're gonna modify it
    subq $1, %rax                     # rax (n) - 1 = rax (n)
    cmpq %r15, %rax                   # compare r15 (i) and rax (n-1) 
    jle outer_loop_end                # if i >= n-1 JUMP to outer_loop_end

                                      # for (int j = 0; j < n - i - 1; j++)
    xorq %rbx, %rbx                   # zero out rbx (j = 0) 
inner_loop:
    movq %r13, %rax                   # copies r13 (n) into rax//rax = n
    subq %r15, %rax                   # rax = rax ( n ) - i
    subq $1, %rax                     # rax = rax (n-i) - 1
    cmpq %rbx, %rax                   # compare rbx (j) to rax (n-i-1)
    jle inner_loop_end                # loop ends when j >= n-i-1

                                      # long swap = 0
    xorq %rcx, %rcx                   # zero out rcx (swap = 0)

                                      # if (ascending)
    cmpq $0, %r12                     # compare r12 ( ascending) and 0
    je descending                     # jump if 0 == r12 (ascending) 

ascending:
                                      # if (array[j+1] < array[j])
    movq %rbx, %rax                   # copy rbx (j) to rax
    incq %rax                         # increase rax j++
    imulq $8, %rax                    # multiply rax (j) by 8 (size of long to get offset)
    addq %r14, %rax                   # add r14 (a) to rax(j+1)//add the base array add to get addy a[j+1]
    movq (%rax), %rdi                 # copy rax value a[j+1] to rdi
    
    movq %rbx, %rax                   # copy rbx addy (j) to rax (j)
    imulq $8, %rax                    # multiply rax (j*8) 
    addq %r14, %rax                   # add r14 ( a) + rax (J*8)
    movq (%rax), %rsi                 # copy a[j] to rsi
    
    cmpq %rsi, %rdi                   # copmare rsi (a[j]) to rdi (a[j+1])
    jge no_swap                       # if rdi >= rsi jump
    movq $1, %rcx                     # copy 1 into rcx (swap)
    jmp no_swap                       # unconditional jump to no_swap

descending:
                                      # if (array[j+1] > array[j])
    movq %rbx, %rax                   # copy rbx (j) to rax
    incq %rax                         # increase rax j++
    imulq $8, %rax                    # multiple rax (j*8)
    addq %r14, %rax                   # add a + j8
    movq (%rax), %rdi                 # copy array[j+1] to rdi
    
    movq %rbx, %rax                   # copy rbx addy (j) to rax
    imulq $8, %rax                    # multiply rax (j*8)
    addq %r14, %rax                   #add r14 (a) to rax (J*8)
    movq (%rax), %rsi                 # copy array[j] to rsi
    
    cmpq %rsi, %rdi                   # compare rsi a[j] to arr[j+1]
    jle no_swap                       # rdi <= rsi jump to no_swap
    movq $1, %rcx                     # copy 1 to rcx (swap = 1)

no_swap:
                                      # if (swap)
    cmpq $0, %rcx                     # compare 0 and rcx (swap)
    je no_swap_needed                 # if 0 = swap

                                      # Swap array[j] and array[j+1]
    movq %rbx, %rax                   # compare rbx (j) to rax (j*8)
    imulq $8, %rax                    # multiply rax (8j*8)
    addq %r14, %rax                   # add r14 ( a) with rax (8j*8)
    movq (%rax), %rdi                 # temp = array[j]
    
    movq %rbx, %rax                   # copy arr[j] to rax
    incq %rax                         #arr[j]++
    imulq $8, %rax                    #arr[j+1]
    addq %r14, %rax                   #
    movq (%rax), %rsi                 #array[j+1] 
    
    movq %rbx, %rax                   #REPEAT ABOVE
    imulq $8, %rax                    #
    addq %r14, %rax                   #
    movq %rsi, (%rax)                 # array[j] = array[j+1]
    
    movq %rbx, %rax                   #REPEAT ABOVE
    incq %rax                         #
    imulq $8, %rax                    #
    addq %r14, %rax                   #
    movq %rdi, (%rax)                 # array[j+1] = temp

no_swap_needed: 
    incq %rbx                         # j++
    jmp inner_loop                    # jump to inner_loop

inner_loop_end:
    incq %r15                         # i++
    jmp outer_loop                    # jump to outer_loop

outer_loop_end:
    popq %r15                        # restores the registers
    popq %r14                        #
    popq %r13                        #
    popq %r12                        #
    popq %rbx                        #
    leave                            # clean up stack frame
    ret                              # return the function
