
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 28 af 11 c0       	mov    $0xc011af28,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 a0 11 c0 	movl   $0xc011a000,(%esp)
c010005d:	e8 bf 53 00 00       	call   c0105421 <memset>

    cons_init();                // init the console
c0100062:	e8 b9 14 00 00       	call   c0101520 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 20 5c 10 c0 	movl   $0xc0105c20,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 3c 5c 10 c0 	movl   $0xc0105c3c,(%esp)
c010007c:	e8 0c 02 00 00       	call   c010028d <cprintf>

    print_kerninfo();
c0100081:	e8 ad 08 00 00       	call   c0100933 <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
c0100086:	e8 66 2f 00 00       	call   c0102ff1 <pmm_init>

    pic_init();                 // init interrupt controller
c010008b:	e8 f4 15 00 00       	call   c0101684 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100090:	e8 4d 17 00 00       	call   c01017e2 <idt_init>

    clock_init();               // init clock interrupt
c0100095:	e8 39 0c 00 00       	call   c0100cd3 <clock_init>
    intr_enable();              // enable irq interrupt
c010009a:	e8 18 17 00 00       	call   c01017b7 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c010009f:	eb fe                	jmp    c010009f <kern_init+0x69>

c01000a1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a1:	55                   	push   %ebp
c01000a2:	89 e5                	mov    %esp,%ebp
c01000a4:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000ae:	00 
c01000af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b6:	00 
c01000b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000be:	e8 fe 0b 00 00       	call   c0100cc1 <mon_backtrace>
}
c01000c3:	90                   	nop
c01000c4:	c9                   	leave  
c01000c5:	c3                   	ret    

c01000c6 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c6:	55                   	push   %ebp
c01000c7:	89 e5                	mov    %esp,%ebp
c01000c9:	53                   	push   %ebx
c01000ca:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000cd:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d3:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000dd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000e1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000e5:	89 04 24             	mov    %eax,(%esp)
c01000e8:	e8 b4 ff ff ff       	call   c01000a1 <grade_backtrace2>
}
c01000ed:	90                   	nop
c01000ee:	83 c4 14             	add    $0x14,%esp
c01000f1:	5b                   	pop    %ebx
c01000f2:	5d                   	pop    %ebp
c01000f3:	c3                   	ret    

c01000f4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f4:	55                   	push   %ebp
c01000f5:	89 e5                	mov    %esp,%ebp
c01000f7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100101:	8b 45 08             	mov    0x8(%ebp),%eax
c0100104:	89 04 24             	mov    %eax,(%esp)
c0100107:	e8 ba ff ff ff       	call   c01000c6 <grade_backtrace1>
}
c010010c:	90                   	nop
c010010d:	c9                   	leave  
c010010e:	c3                   	ret    

c010010f <grade_backtrace>:

void
grade_backtrace(void) {
c010010f:	55                   	push   %ebp
c0100110:	89 e5                	mov    %esp,%ebp
c0100112:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100115:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010011a:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100121:	ff 
c0100122:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100126:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010012d:	e8 c2 ff ff ff       	call   c01000f4 <grade_backtrace0>
}
c0100132:	90                   	nop
c0100133:	c9                   	leave  
c0100134:	c3                   	ret    

c0100135 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100135:	55                   	push   %ebp
c0100136:	89 e5                	mov    %esp,%ebp
c0100138:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010013e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100141:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100144:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100147:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014b:	83 e0 03             	and    $0x3,%eax
c010014e:	89 c2                	mov    %eax,%edx
c0100150:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100155:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100159:	89 44 24 04          	mov    %eax,0x4(%esp)
c010015d:	c7 04 24 41 5c 10 c0 	movl   $0xc0105c41,(%esp)
c0100164:	e8 24 01 00 00       	call   c010028d <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100169:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010016d:	89 c2                	mov    %eax,%edx
c010016f:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100174:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100178:	89 44 24 04          	mov    %eax,0x4(%esp)
c010017c:	c7 04 24 4f 5c 10 c0 	movl   $0xc0105c4f,(%esp)
c0100183:	e8 05 01 00 00       	call   c010028d <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100188:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010018c:	89 c2                	mov    %eax,%edx
c010018e:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100193:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100197:	89 44 24 04          	mov    %eax,0x4(%esp)
c010019b:	c7 04 24 5d 5c 10 c0 	movl   $0xc0105c5d,(%esp)
c01001a2:	e8 e6 00 00 00       	call   c010028d <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001ab:	89 c2                	mov    %eax,%edx
c01001ad:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ba:	c7 04 24 6b 5c 10 c0 	movl   $0xc0105c6b,(%esp)
c01001c1:	e8 c7 00 00 00       	call   c010028d <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c6:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001ca:	89 c2                	mov    %eax,%edx
c01001cc:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001d1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d9:	c7 04 24 79 5c 10 c0 	movl   $0xc0105c79,(%esp)
c01001e0:	e8 a8 00 00 00       	call   c010028d <cprintf>
    round ++;
c01001e5:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001ea:	40                   	inc    %eax
c01001eb:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
}
c01001f0:	90                   	nop
c01001f1:	c9                   	leave  
c01001f2:	c3                   	ret    

c01001f3 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f3:	55                   	push   %ebp
c01001f4:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f6:	90                   	nop
c01001f7:	5d                   	pop    %ebp
c01001f8:	c3                   	ret    

c01001f9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f9:	55                   	push   %ebp
c01001fa:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001fc:	90                   	nop
c01001fd:	5d                   	pop    %ebp
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
c0100202:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100205:	e8 2b ff ff ff       	call   c0100135 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010020a:	c7 04 24 88 5c 10 c0 	movl   $0xc0105c88,(%esp)
c0100211:	e8 77 00 00 00       	call   c010028d <cprintf>
    lab1_switch_to_user();
c0100216:	e8 d8 ff ff ff       	call   c01001f3 <lab1_switch_to_user>
    lab1_print_cur_status();
c010021b:	e8 15 ff ff ff       	call   c0100135 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100220:	c7 04 24 a8 5c 10 c0 	movl   $0xc0105ca8,(%esp)
c0100227:	e8 61 00 00 00       	call   c010028d <cprintf>
    lab1_switch_to_kernel();
c010022c:	e8 c8 ff ff ff       	call   c01001f9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100231:	e8 ff fe ff ff       	call   c0100135 <lab1_print_cur_status>
}
c0100236:	90                   	nop
c0100237:	c9                   	leave  
c0100238:	c3                   	ret    

c0100239 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100239:	55                   	push   %ebp
c010023a:	89 e5                	mov    %esp,%ebp
c010023c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 04 24             	mov    %eax,(%esp)
c0100245:	e8 03 13 00 00       	call   c010154d <cons_putc>
    (*cnt) ++;
c010024a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010024d:	8b 00                	mov    (%eax),%eax
c010024f:	8d 50 01             	lea    0x1(%eax),%edx
c0100252:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100255:	89 10                	mov    %edx,(%eax)
}
c0100257:	90                   	nop
c0100258:	c9                   	leave  
c0100259:	c3                   	ret    

c010025a <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010025a:	55                   	push   %ebp
c010025b:	89 e5                	mov    %esp,%ebp
c010025d:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100260:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100267:	8b 45 0c             	mov    0xc(%ebp),%eax
c010026a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010026e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100271:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100275:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100278:	89 44 24 04          	mov    %eax,0x4(%esp)
c010027c:	c7 04 24 39 02 10 c0 	movl   $0xc0100239,(%esp)
c0100283:	e8 ec 54 00 00       	call   c0105774 <vprintfmt>
    return cnt;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010028b:	c9                   	leave  
c010028c:	c3                   	ret    

c010028d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010028d:	55                   	push   %ebp
c010028e:	89 e5                	mov    %esp,%ebp
c0100290:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100293:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100296:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100299:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010029c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01002a3:	89 04 24             	mov    %eax,(%esp)
c01002a6:	e8 af ff ff ff       	call   c010025a <vcprintf>
c01002ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002b1:	c9                   	leave  
c01002b2:	c3                   	ret    

c01002b3 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002b3:	55                   	push   %ebp
c01002b4:	89 e5                	mov    %esp,%ebp
c01002b6:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01002bc:	89 04 24             	mov    %eax,(%esp)
c01002bf:	e8 89 12 00 00       	call   c010154d <cons_putc>
}
c01002c4:	90                   	nop
c01002c5:	c9                   	leave  
c01002c6:	c3                   	ret    

c01002c7 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002c7:	55                   	push   %ebp
c01002c8:	89 e5                	mov    %esp,%ebp
c01002ca:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002d4:	eb 13                	jmp    c01002e9 <cputs+0x22>
        cputch(c, &cnt);
c01002d6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002da:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002dd:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002e1:	89 04 24             	mov    %eax,(%esp)
c01002e4:	e8 50 ff ff ff       	call   c0100239 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01002e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01002ec:	8d 50 01             	lea    0x1(%eax),%edx
c01002ef:	89 55 08             	mov    %edx,0x8(%ebp)
c01002f2:	0f b6 00             	movzbl (%eax),%eax
c01002f5:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002f8:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01002fc:	75 d8                	jne    c01002d6 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01002fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100301:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100305:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c010030c:	e8 28 ff ff ff       	call   c0100239 <cputch>
    return cnt;
c0100311:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100314:	c9                   	leave  
c0100315:	c3                   	ret    

c0100316 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100316:	55                   	push   %ebp
c0100317:	89 e5                	mov    %esp,%ebp
c0100319:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010031c:	e8 69 12 00 00       	call   c010158a <cons_getc>
c0100321:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100328:	74 f2                	je     c010031c <getchar+0x6>
        /* do nothing */;
    return c;
c010032a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010032d:	c9                   	leave  
c010032e:	c3                   	ret    

c010032f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010032f:	55                   	push   %ebp
c0100330:	89 e5                	mov    %esp,%ebp
c0100332:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100335:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100339:	74 13                	je     c010034e <readline+0x1f>
        cprintf("%s", prompt);
c010033b:	8b 45 08             	mov    0x8(%ebp),%eax
c010033e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100342:	c7 04 24 c7 5c 10 c0 	movl   $0xc0105cc7,(%esp)
c0100349:	e8 3f ff ff ff       	call   c010028d <cprintf>
    }
    int i = 0, c;
c010034e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100355:	e8 bc ff ff ff       	call   c0100316 <getchar>
c010035a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010035d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100361:	79 07                	jns    c010036a <readline+0x3b>
            return NULL;
c0100363:	b8 00 00 00 00       	mov    $0x0,%eax
c0100368:	eb 78                	jmp    c01003e2 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010036a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010036e:	7e 28                	jle    c0100398 <readline+0x69>
c0100370:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100377:	7f 1f                	jg     c0100398 <readline+0x69>
            cputchar(c);
c0100379:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010037c:	89 04 24             	mov    %eax,(%esp)
c010037f:	e8 2f ff ff ff       	call   c01002b3 <cputchar>
            buf[i ++] = c;
c0100384:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100387:	8d 50 01             	lea    0x1(%eax),%edx
c010038a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010038d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100390:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
c0100396:	eb 45                	jmp    c01003dd <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c0100398:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c010039c:	75 16                	jne    c01003b4 <readline+0x85>
c010039e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003a2:	7e 10                	jle    c01003b4 <readline+0x85>
            cputchar(c);
c01003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003a7:	89 04 24             	mov    %eax,(%esp)
c01003aa:	e8 04 ff ff ff       	call   c01002b3 <cputchar>
            i --;
c01003af:	ff 4d f4             	decl   -0xc(%ebp)
c01003b2:	eb 29                	jmp    c01003dd <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01003b4:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003b8:	74 06                	je     c01003c0 <readline+0x91>
c01003ba:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003be:	75 95                	jne    c0100355 <readline+0x26>
            cputchar(c);
c01003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c3:	89 04 24             	mov    %eax,(%esp)
c01003c6:	e8 e8 fe ff ff       	call   c01002b3 <cputchar>
            buf[i] = '\0';
c01003cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003ce:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01003d3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003d6:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
c01003db:	eb 05                	jmp    c01003e2 <readline+0xb3>
        }
    }
c01003dd:	e9 73 ff ff ff       	jmp    c0100355 <readline+0x26>
}
c01003e2:	c9                   	leave  
c01003e3:	c3                   	ret    

c01003e4 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003e4:	55                   	push   %ebp
c01003e5:	89 e5                	mov    %esp,%ebp
c01003e7:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003ea:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c01003ef:	85 c0                	test   %eax,%eax
c01003f1:	75 5b                	jne    c010044e <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c01003f3:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
c01003fa:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c01003fd:	8d 45 14             	lea    0x14(%ebp),%eax
c0100400:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100403:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100406:	89 44 24 08          	mov    %eax,0x8(%esp)
c010040a:	8b 45 08             	mov    0x8(%ebp),%eax
c010040d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100411:	c7 04 24 ca 5c 10 c0 	movl   $0xc0105cca,(%esp)
c0100418:	e8 70 fe ff ff       	call   c010028d <cprintf>
    vcprintf(fmt, ap);
c010041d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100420:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100424:	8b 45 10             	mov    0x10(%ebp),%eax
c0100427:	89 04 24             	mov    %eax,(%esp)
c010042a:	e8 2b fe ff ff       	call   c010025a <vcprintf>
    cprintf("\n");
c010042f:	c7 04 24 e6 5c 10 c0 	movl   $0xc0105ce6,(%esp)
c0100436:	e8 52 fe ff ff       	call   c010028d <cprintf>
    
    cprintf("stack trackback:\n");
c010043b:	c7 04 24 e8 5c 10 c0 	movl   $0xc0105ce8,(%esp)
c0100442:	e8 46 fe ff ff       	call   c010028d <cprintf>
    print_stackframe();
c0100447:	e8 32 06 00 00       	call   c0100a7e <print_stackframe>
c010044c:	eb 01                	jmp    c010044f <__panic+0x6b>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c010044e:	90                   	nop
    print_stackframe();
    
    va_end(ap);

panic_dead:
    intr_disable();
c010044f:	e8 6a 13 00 00       	call   c01017be <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100454:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010045b:	e8 94 07 00 00       	call   c0100bf4 <kmonitor>
    }
c0100460:	eb f2                	jmp    c0100454 <__panic+0x70>

c0100462 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100462:	55                   	push   %ebp
c0100463:	89 e5                	mov    %esp,%ebp
c0100465:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100468:	8d 45 14             	lea    0x14(%ebp),%eax
c010046b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010046e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100471:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100475:	8b 45 08             	mov    0x8(%ebp),%eax
c0100478:	89 44 24 04          	mov    %eax,0x4(%esp)
c010047c:	c7 04 24 fa 5c 10 c0 	movl   $0xc0105cfa,(%esp)
c0100483:	e8 05 fe ff ff       	call   c010028d <cprintf>
    vcprintf(fmt, ap);
c0100488:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010048b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010048f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100492:	89 04 24             	mov    %eax,(%esp)
c0100495:	e8 c0 fd ff ff       	call   c010025a <vcprintf>
    cprintf("\n");
c010049a:	c7 04 24 e6 5c 10 c0 	movl   $0xc0105ce6,(%esp)
c01004a1:	e8 e7 fd ff ff       	call   c010028d <cprintf>
    va_end(ap);
}
c01004a6:	90                   	nop
c01004a7:	c9                   	leave  
c01004a8:	c3                   	ret    

c01004a9 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004a9:	55                   	push   %ebp
c01004aa:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004ac:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
}
c01004b1:	5d                   	pop    %ebp
c01004b2:	c3                   	ret    

c01004b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004b3:	55                   	push   %ebp
c01004b4:	89 e5                	mov    %esp,%ebp
c01004b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004bc:	8b 00                	mov    (%eax),%eax
c01004be:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c4:	8b 00                	mov    (%eax),%eax
c01004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004d0:	e9 ca 00 00 00       	jmp    c010059f <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c01004d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004db:	01 d0                	add    %edx,%eax
c01004dd:	89 c2                	mov    %eax,%edx
c01004df:	c1 ea 1f             	shr    $0x1f,%edx
c01004e2:	01 d0                	add    %edx,%eax
c01004e4:	d1 f8                	sar    %eax
c01004e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004ef:	eb 03                	jmp    c01004f4 <stab_binsearch+0x41>
            m --;
c01004f1:	ff 4d f0             	decl   -0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004f7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004fa:	7c 1f                	jl     c010051b <stab_binsearch+0x68>
c01004fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004ff:	89 d0                	mov    %edx,%eax
c0100501:	01 c0                	add    %eax,%eax
c0100503:	01 d0                	add    %edx,%eax
c0100505:	c1 e0 02             	shl    $0x2,%eax
c0100508:	89 c2                	mov    %eax,%edx
c010050a:	8b 45 08             	mov    0x8(%ebp),%eax
c010050d:	01 d0                	add    %edx,%eax
c010050f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100513:	0f b6 c0             	movzbl %al,%eax
c0100516:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100519:	75 d6                	jne    c01004f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c010051b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010051e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100521:	7d 09                	jge    c010052c <stab_binsearch+0x79>
            l = true_m + 1;
c0100523:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100526:	40                   	inc    %eax
c0100527:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010052a:	eb 73                	jmp    c010059f <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c010052c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100533:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100536:	89 d0                	mov    %edx,%eax
c0100538:	01 c0                	add    %eax,%eax
c010053a:	01 d0                	add    %edx,%eax
c010053c:	c1 e0 02             	shl    $0x2,%eax
c010053f:	89 c2                	mov    %eax,%edx
c0100541:	8b 45 08             	mov    0x8(%ebp),%eax
c0100544:	01 d0                	add    %edx,%eax
c0100546:	8b 40 08             	mov    0x8(%eax),%eax
c0100549:	3b 45 18             	cmp    0x18(%ebp),%eax
c010054c:	73 11                	jae    c010055f <stab_binsearch+0xac>
            *region_left = m;
c010054e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100551:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100554:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100556:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100559:	40                   	inc    %eax
c010055a:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010055d:	eb 40                	jmp    c010059f <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c010055f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100562:	89 d0                	mov    %edx,%eax
c0100564:	01 c0                	add    %eax,%eax
c0100566:	01 d0                	add    %edx,%eax
c0100568:	c1 e0 02             	shl    $0x2,%eax
c010056b:	89 c2                	mov    %eax,%edx
c010056d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100570:	01 d0                	add    %edx,%eax
c0100572:	8b 40 08             	mov    0x8(%eax),%eax
c0100575:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100578:	76 14                	jbe    c010058e <stab_binsearch+0xdb>
            *region_right = m - 1;
c010057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010057d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100580:	8b 45 10             	mov    0x10(%ebp),%eax
c0100583:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100585:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100588:	48                   	dec    %eax
c0100589:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010058c:	eb 11                	jmp    c010059f <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c010058e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100591:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100594:	89 10                	mov    %edx,(%eax)
            l = m;
c0100596:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100599:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c010059c:	ff 45 18             	incl   0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c010059f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005a5:	0f 8e 2a ff ff ff    	jle    c01004d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01005ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005af:	75 0f                	jne    c01005c0 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01005b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b4:	8b 00                	mov    (%eax),%eax
c01005b6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01005bc:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005be:	eb 3e                	jmp    c01005fe <stab_binsearch+0x14b>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005c0:	8b 45 10             	mov    0x10(%ebp),%eax
c01005c3:	8b 00                	mov    (%eax),%eax
c01005c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005c8:	eb 03                	jmp    c01005cd <stab_binsearch+0x11a>
c01005ca:	ff 4d fc             	decl   -0x4(%ebp)
c01005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005d0:	8b 00                	mov    (%eax),%eax
c01005d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005d5:	7d 1f                	jge    c01005f6 <stab_binsearch+0x143>
c01005d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005da:	89 d0                	mov    %edx,%eax
c01005dc:	01 c0                	add    %eax,%eax
c01005de:	01 d0                	add    %edx,%eax
c01005e0:	c1 e0 02             	shl    $0x2,%eax
c01005e3:	89 c2                	mov    %eax,%edx
c01005e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e8:	01 d0                	add    %edx,%eax
c01005ea:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005ee:	0f b6 c0             	movzbl %al,%eax
c01005f1:	3b 45 14             	cmp    0x14(%ebp),%eax
c01005f4:	75 d4                	jne    c01005ca <stab_binsearch+0x117>
            /* do nothing */;
        *region_left = l;
c01005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005fc:	89 10                	mov    %edx,(%eax)
    }
}
c01005fe:	90                   	nop
c01005ff:	c9                   	leave  
c0100600:	c3                   	ret    

c0100601 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100601:	55                   	push   %ebp
c0100602:	89 e5                	mov    %esp,%ebp
c0100604:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100607:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060a:	c7 00 18 5d 10 c0    	movl   $0xc0105d18,(%eax)
    info->eip_line = 0;
c0100610:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100613:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010061a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010061d:	c7 40 08 18 5d 10 c0 	movl   $0xc0105d18,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100624:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100627:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010062e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100631:	8b 55 08             	mov    0x8(%ebp),%edx
c0100634:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100637:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100641:	c7 45 f4 38 6f 10 c0 	movl   $0xc0106f38,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100648:	c7 45 f0 00 19 11 c0 	movl   $0xc0111900,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010064f:	c7 45 ec 01 19 11 c0 	movl   $0xc0111901,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100656:	c7 45 e8 3f 43 11 c0 	movl   $0xc011433f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010065d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100660:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100663:	76 0b                	jbe    c0100670 <debuginfo_eip+0x6f>
c0100665:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100668:	48                   	dec    %eax
c0100669:	0f b6 00             	movzbl (%eax),%eax
c010066c:	84 c0                	test   %al,%al
c010066e:	74 0a                	je     c010067a <debuginfo_eip+0x79>
        return -1;
c0100670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100675:	e9 b7 02 00 00       	jmp    c0100931 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010067a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100681:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100684:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100687:	29 c2                	sub    %eax,%edx
c0100689:	89 d0                	mov    %edx,%eax
c010068b:	c1 f8 02             	sar    $0x2,%eax
c010068e:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100694:	48                   	dec    %eax
c0100695:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c0100698:	8b 45 08             	mov    0x8(%ebp),%eax
c010069b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010069f:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006a6:	00 
c01006a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006aa:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006ae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b8:	89 04 24             	mov    %eax,(%esp)
c01006bb:	e8 f3 fd ff ff       	call   c01004b3 <stab_binsearch>
    if (lfile == 0)
c01006c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006c3:	85 c0                	test   %eax,%eax
c01006c5:	75 0a                	jne    c01006d1 <debuginfo_eip+0xd0>
        return -1;
c01006c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006cc:	e9 60 02 00 00       	jmp    c0100931 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01006e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006e4:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c01006eb:	00 
c01006ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006f3:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006fd:	89 04 24             	mov    %eax,(%esp)
c0100700:	e8 ae fd ff ff       	call   c01004b3 <stab_binsearch>

    if (lfun <= rfun) {
c0100705:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100708:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010070b:	39 c2                	cmp    %eax,%edx
c010070d:	7f 7c                	jg     c010078b <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010070f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100712:	89 c2                	mov    %eax,%edx
c0100714:	89 d0                	mov    %edx,%eax
c0100716:	01 c0                	add    %eax,%eax
c0100718:	01 d0                	add    %edx,%eax
c010071a:	c1 e0 02             	shl    $0x2,%eax
c010071d:	89 c2                	mov    %eax,%edx
c010071f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100722:	01 d0                	add    %edx,%eax
c0100724:	8b 00                	mov    (%eax),%eax
c0100726:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100729:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010072c:	29 d1                	sub    %edx,%ecx
c010072e:	89 ca                	mov    %ecx,%edx
c0100730:	39 d0                	cmp    %edx,%eax
c0100732:	73 22                	jae    c0100756 <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100734:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100737:	89 c2                	mov    %eax,%edx
c0100739:	89 d0                	mov    %edx,%eax
c010073b:	01 c0                	add    %eax,%eax
c010073d:	01 d0                	add    %edx,%eax
c010073f:	c1 e0 02             	shl    $0x2,%eax
c0100742:	89 c2                	mov    %eax,%edx
c0100744:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100747:	01 d0                	add    %edx,%eax
c0100749:	8b 10                	mov    (%eax),%edx
c010074b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010074e:	01 c2                	add    %eax,%edx
c0100750:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100753:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100756:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100759:	89 c2                	mov    %eax,%edx
c010075b:	89 d0                	mov    %edx,%eax
c010075d:	01 c0                	add    %eax,%eax
c010075f:	01 d0                	add    %edx,%eax
c0100761:	c1 e0 02             	shl    $0x2,%eax
c0100764:	89 c2                	mov    %eax,%edx
c0100766:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100769:	01 d0                	add    %edx,%eax
c010076b:	8b 50 08             	mov    0x8(%eax),%edx
c010076e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100771:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100774:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100777:	8b 40 10             	mov    0x10(%eax),%eax
c010077a:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c010077d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100780:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100783:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100786:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100789:	eb 15                	jmp    c01007a0 <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c010078b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078e:	8b 55 08             	mov    0x8(%ebp),%edx
c0100791:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c0100794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100797:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c010079a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010079d:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a3:	8b 40 08             	mov    0x8(%eax),%eax
c01007a6:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007ad:	00 
c01007ae:	89 04 24             	mov    %eax,(%esp)
c01007b1:	e8 e7 4a 00 00       	call   c010529d <strfind>
c01007b6:	89 c2                	mov    %eax,%edx
c01007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bb:	8b 40 08             	mov    0x8(%eax),%eax
c01007be:	29 c2                	sub    %eax,%edx
c01007c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c3:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01007c9:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007cd:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007d4:	00 
c01007d5:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007d8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007dc:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e6:	89 04 24             	mov    %eax,(%esp)
c01007e9:	e8 c5 fc ff ff       	call   c01004b3 <stab_binsearch>
    if (lline <= rline) {
c01007ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007f4:	39 c2                	cmp    %eax,%edx
c01007f6:	7f 23                	jg     c010081b <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
c01007f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007fb:	89 c2                	mov    %eax,%edx
c01007fd:	89 d0                	mov    %edx,%eax
c01007ff:	01 c0                	add    %eax,%eax
c0100801:	01 d0                	add    %edx,%eax
c0100803:	c1 e0 02             	shl    $0x2,%eax
c0100806:	89 c2                	mov    %eax,%edx
c0100808:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010080b:	01 d0                	add    %edx,%eax
c010080d:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100811:	89 c2                	mov    %eax,%edx
c0100813:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100816:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100819:	eb 11                	jmp    c010082c <debuginfo_eip+0x22b>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010081b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100820:	e9 0c 01 00 00       	jmp    c0100931 <debuginfo_eip+0x330>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100825:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100828:	48                   	dec    %eax
c0100829:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010082c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010082f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100832:	39 c2                	cmp    %eax,%edx
c0100834:	7c 56                	jl     c010088c <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
c0100836:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100839:	89 c2                	mov    %eax,%edx
c010083b:	89 d0                	mov    %edx,%eax
c010083d:	01 c0                	add    %eax,%eax
c010083f:	01 d0                	add    %edx,%eax
c0100841:	c1 e0 02             	shl    $0x2,%eax
c0100844:	89 c2                	mov    %eax,%edx
c0100846:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100849:	01 d0                	add    %edx,%eax
c010084b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010084f:	3c 84                	cmp    $0x84,%al
c0100851:	74 39                	je     c010088c <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100856:	89 c2                	mov    %eax,%edx
c0100858:	89 d0                	mov    %edx,%eax
c010085a:	01 c0                	add    %eax,%eax
c010085c:	01 d0                	add    %edx,%eax
c010085e:	c1 e0 02             	shl    $0x2,%eax
c0100861:	89 c2                	mov    %eax,%edx
c0100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100866:	01 d0                	add    %edx,%eax
c0100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086c:	3c 64                	cmp    $0x64,%al
c010086e:	75 b5                	jne    c0100825 <debuginfo_eip+0x224>
c0100870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100873:	89 c2                	mov    %eax,%edx
c0100875:	89 d0                	mov    %edx,%eax
c0100877:	01 c0                	add    %eax,%eax
c0100879:	01 d0                	add    %edx,%eax
c010087b:	c1 e0 02             	shl    $0x2,%eax
c010087e:	89 c2                	mov    %eax,%edx
c0100880:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100883:	01 d0                	add    %edx,%eax
c0100885:	8b 40 08             	mov    0x8(%eax),%eax
c0100888:	85 c0                	test   %eax,%eax
c010088a:	74 99                	je     c0100825 <debuginfo_eip+0x224>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c010088c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010088f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100892:	39 c2                	cmp    %eax,%edx
c0100894:	7c 46                	jl     c01008dc <debuginfo_eip+0x2db>
c0100896:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100899:	89 c2                	mov    %eax,%edx
c010089b:	89 d0                	mov    %edx,%eax
c010089d:	01 c0                	add    %eax,%eax
c010089f:	01 d0                	add    %edx,%eax
c01008a1:	c1 e0 02             	shl    $0x2,%eax
c01008a4:	89 c2                	mov    %eax,%edx
c01008a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a9:	01 d0                	add    %edx,%eax
c01008ab:	8b 00                	mov    (%eax),%eax
c01008ad:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01008b3:	29 d1                	sub    %edx,%ecx
c01008b5:	89 ca                	mov    %ecx,%edx
c01008b7:	39 d0                	cmp    %edx,%eax
c01008b9:	73 21                	jae    c01008dc <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008be:	89 c2                	mov    %eax,%edx
c01008c0:	89 d0                	mov    %edx,%eax
c01008c2:	01 c0                	add    %eax,%eax
c01008c4:	01 d0                	add    %edx,%eax
c01008c6:	c1 e0 02             	shl    $0x2,%eax
c01008c9:	89 c2                	mov    %eax,%edx
c01008cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ce:	01 d0                	add    %edx,%eax
c01008d0:	8b 10                	mov    (%eax),%edx
c01008d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008d5:	01 c2                	add    %eax,%edx
c01008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008da:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008df:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008e2:	39 c2                	cmp    %eax,%edx
c01008e4:	7d 46                	jge    c010092c <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
c01008e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008e9:	40                   	inc    %eax
c01008ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008ed:	eb 16                	jmp    c0100905 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f2:	8b 40 14             	mov    0x14(%eax),%eax
c01008f5:	8d 50 01             	lea    0x1(%eax),%edx
c01008f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008fb:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c01008fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100901:	40                   	inc    %eax
c0100902:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100905:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100908:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010090b:	39 c2                	cmp    %eax,%edx
c010090d:	7d 1d                	jge    c010092c <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010090f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100912:	89 c2                	mov    %eax,%edx
c0100914:	89 d0                	mov    %edx,%eax
c0100916:	01 c0                	add    %eax,%eax
c0100918:	01 d0                	add    %edx,%eax
c010091a:	c1 e0 02             	shl    $0x2,%eax
c010091d:	89 c2                	mov    %eax,%edx
c010091f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100922:	01 d0                	add    %edx,%eax
c0100924:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100928:	3c a0                	cmp    $0xa0,%al
c010092a:	74 c3                	je     c01008ef <debuginfo_eip+0x2ee>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c010092c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100931:	c9                   	leave  
c0100932:	c3                   	ret    

c0100933 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100933:	55                   	push   %ebp
c0100934:	89 e5                	mov    %esp,%ebp
c0100936:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100939:	c7 04 24 22 5d 10 c0 	movl   $0xc0105d22,(%esp)
c0100940:	e8 48 f9 ff ff       	call   c010028d <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100945:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c010094c:	c0 
c010094d:	c7 04 24 3b 5d 10 c0 	movl   $0xc0105d3b,(%esp)
c0100954:	e8 34 f9 ff ff       	call   c010028d <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100959:	c7 44 24 04 1b 5c 10 	movl   $0xc0105c1b,0x4(%esp)
c0100960:	c0 
c0100961:	c7 04 24 53 5d 10 c0 	movl   $0xc0105d53,(%esp)
c0100968:	e8 20 f9 ff ff       	call   c010028d <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c010096d:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c0100974:	c0 
c0100975:	c7 04 24 6b 5d 10 c0 	movl   $0xc0105d6b,(%esp)
c010097c:	e8 0c f9 ff ff       	call   c010028d <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c0100981:	c7 44 24 04 28 af 11 	movl   $0xc011af28,0x4(%esp)
c0100988:	c0 
c0100989:	c7 04 24 83 5d 10 c0 	movl   $0xc0105d83,(%esp)
c0100990:	e8 f8 f8 ff ff       	call   c010028d <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100995:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c010099a:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009a0:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009a5:	29 c2                	sub    %eax,%edx
c01009a7:	89 d0                	mov    %edx,%eax
c01009a9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009af:	85 c0                	test   %eax,%eax
c01009b1:	0f 48 c2             	cmovs  %edx,%eax
c01009b4:	c1 f8 0a             	sar    $0xa,%eax
c01009b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009bb:	c7 04 24 9c 5d 10 c0 	movl   $0xc0105d9c,(%esp)
c01009c2:	e8 c6 f8 ff ff       	call   c010028d <cprintf>
}
c01009c7:	90                   	nop
c01009c8:	c9                   	leave  
c01009c9:	c3                   	ret    

c01009ca <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009ca:	55                   	push   %ebp
c01009cb:	89 e5                	mov    %esp,%ebp
c01009cd:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009d3:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009da:	8b 45 08             	mov    0x8(%ebp),%eax
c01009dd:	89 04 24             	mov    %eax,(%esp)
c01009e0:	e8 1c fc ff ff       	call   c0100601 <debuginfo_eip>
c01009e5:	85 c0                	test   %eax,%eax
c01009e7:	74 15                	je     c01009fe <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01009ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f0:	c7 04 24 c6 5d 10 c0 	movl   $0xc0105dc6,(%esp)
c01009f7:	e8 91 f8 ff ff       	call   c010028d <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01009fc:	eb 6c                	jmp    c0100a6a <print_debuginfo+0xa0>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01009fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a05:	eb 1b                	jmp    c0100a22 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100a07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0d:	01 d0                	add    %edx,%eax
c0100a0f:	0f b6 00             	movzbl (%eax),%eax
c0100a12:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a18:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a1b:	01 ca                	add    %ecx,%edx
c0100a1d:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a1f:	ff 45 f4             	incl   -0xc(%ebp)
c0100a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a25:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a28:	7f dd                	jg     c0100a07 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a2a:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a33:	01 d0                	add    %edx,%eax
c0100a35:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a3b:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a3e:	89 d1                	mov    %edx,%ecx
c0100a40:	29 c1                	sub    %eax,%ecx
c0100a42:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a45:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a48:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a4c:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a52:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a56:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a5e:	c7 04 24 e2 5d 10 c0 	movl   $0xc0105de2,(%esp)
c0100a65:	e8 23 f8 ff ff       	call   c010028d <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a6a:	90                   	nop
c0100a6b:	c9                   	leave  
c0100a6c:	c3                   	ret    

c0100a6d <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a6d:	55                   	push   %ebp
c0100a6e:	89 e5                	mov    %esp,%ebp
c0100a70:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a73:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a76:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a79:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a7c:	c9                   	leave  
c0100a7d:	c3                   	ret    

c0100a7e <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a7e:	55                   	push   %ebp
c0100a7f:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c0100a81:	90                   	nop
c0100a82:	5d                   	pop    %ebp
c0100a83:	c3                   	ret    

c0100a84 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a84:	55                   	push   %ebp
c0100a85:	89 e5                	mov    %esp,%ebp
c0100a87:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a91:	eb 0c                	jmp    c0100a9f <parse+0x1b>
            *buf ++ = '\0';
c0100a93:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a96:	8d 50 01             	lea    0x1(%eax),%edx
c0100a99:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a9c:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa2:	0f b6 00             	movzbl (%eax),%eax
c0100aa5:	84 c0                	test   %al,%al
c0100aa7:	74 1d                	je     c0100ac6 <parse+0x42>
c0100aa9:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aac:	0f b6 00             	movzbl (%eax),%eax
c0100aaf:	0f be c0             	movsbl %al,%eax
c0100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab6:	c7 04 24 74 5e 10 c0 	movl   $0xc0105e74,(%esp)
c0100abd:	e8 a9 47 00 00       	call   c010526b <strchr>
c0100ac2:	85 c0                	test   %eax,%eax
c0100ac4:	75 cd                	jne    c0100a93 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac9:	0f b6 00             	movzbl (%eax),%eax
c0100acc:	84 c0                	test   %al,%al
c0100ace:	74 69                	je     c0100b39 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad0:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad4:	75 14                	jne    c0100aea <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad6:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100add:	00 
c0100ade:	c7 04 24 79 5e 10 c0 	movl   $0xc0105e79,(%esp)
c0100ae5:	e8 a3 f7 ff ff       	call   c010028d <cprintf>
        }
        argv[argc ++] = buf;
c0100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aed:	8d 50 01             	lea    0x1(%eax),%edx
c0100af0:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100afa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afd:	01 c2                	add    %eax,%edx
c0100aff:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b02:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b04:	eb 03                	jmp    c0100b09 <parse+0x85>
            buf ++;
c0100b06:	ff 45 08             	incl   0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0c:	0f b6 00             	movzbl (%eax),%eax
c0100b0f:	84 c0                	test   %al,%al
c0100b11:	0f 84 7a ff ff ff    	je     c0100a91 <parse+0xd>
c0100b17:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1a:	0f b6 00             	movzbl (%eax),%eax
c0100b1d:	0f be c0             	movsbl %al,%eax
c0100b20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b24:	c7 04 24 74 5e 10 c0 	movl   $0xc0105e74,(%esp)
c0100b2b:	e8 3b 47 00 00       	call   c010526b <strchr>
c0100b30:	85 c0                	test   %eax,%eax
c0100b32:	74 d2                	je     c0100b06 <parse+0x82>
            buf ++;
        }
    }
c0100b34:	e9 58 ff ff ff       	jmp    c0100a91 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100b39:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b3d:	c9                   	leave  
c0100b3e:	c3                   	ret    

c0100b3f <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3f:	55                   	push   %ebp
c0100b40:	89 e5                	mov    %esp,%ebp
c0100b42:	53                   	push   %ebx
c0100b43:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b46:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b50:	89 04 24             	mov    %eax,(%esp)
c0100b53:	e8 2c ff ff ff       	call   c0100a84 <parse>
c0100b58:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b5f:	75 0a                	jne    c0100b6b <runcmd+0x2c>
        return 0;
c0100b61:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b66:	e9 83 00 00 00       	jmp    c0100bee <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b72:	eb 5a                	jmp    c0100bce <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b74:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b7a:	89 d0                	mov    %edx,%eax
c0100b7c:	01 c0                	add    %eax,%eax
c0100b7e:	01 d0                	add    %edx,%eax
c0100b80:	c1 e0 02             	shl    $0x2,%eax
c0100b83:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100b88:	8b 00                	mov    (%eax),%eax
c0100b8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b8e:	89 04 24             	mov    %eax,(%esp)
c0100b91:	e8 38 46 00 00       	call   c01051ce <strcmp>
c0100b96:	85 c0                	test   %eax,%eax
c0100b98:	75 31                	jne    c0100bcb <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9d:	89 d0                	mov    %edx,%eax
c0100b9f:	01 c0                	add    %eax,%eax
c0100ba1:	01 d0                	add    %edx,%eax
c0100ba3:	c1 e0 02             	shl    $0x2,%eax
c0100ba6:	05 08 70 11 c0       	add    $0xc0117008,%eax
c0100bab:	8b 10                	mov    (%eax),%edx
c0100bad:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bb0:	83 c0 04             	add    $0x4,%eax
c0100bb3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100bb6:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100bb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100bbc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bc4:	89 1c 24             	mov    %ebx,(%esp)
c0100bc7:	ff d2                	call   *%edx
c0100bc9:	eb 23                	jmp    c0100bee <runcmd+0xaf>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bcb:	ff 45 f4             	incl   -0xc(%ebp)
c0100bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd1:	83 f8 02             	cmp    $0x2,%eax
c0100bd4:	76 9e                	jbe    c0100b74 <runcmd+0x35>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bdd:	c7 04 24 97 5e 10 c0 	movl   $0xc0105e97,(%esp)
c0100be4:	e8 a4 f6 ff ff       	call   c010028d <cprintf>
    return 0;
c0100be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bee:	83 c4 64             	add    $0x64,%esp
c0100bf1:	5b                   	pop    %ebx
c0100bf2:	5d                   	pop    %ebp
c0100bf3:	c3                   	ret    

c0100bf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf4:	55                   	push   %ebp
c0100bf5:	89 e5                	mov    %esp,%ebp
c0100bf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bfa:	c7 04 24 b0 5e 10 c0 	movl   $0xc0105eb0,(%esp)
c0100c01:	e8 87 f6 ff ff       	call   c010028d <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c06:	c7 04 24 d8 5e 10 c0 	movl   $0xc0105ed8,(%esp)
c0100c0d:	e8 7b f6 ff ff       	call   c010028d <cprintf>

    if (tf != NULL) {
c0100c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c16:	74 0b                	je     c0100c23 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1b:	89 04 24             	mov    %eax,(%esp)
c0100c1e:	e8 f9 0c 00 00       	call   c010191c <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c23:	c7 04 24 fd 5e 10 c0 	movl   $0xc0105efd,(%esp)
c0100c2a:	e8 00 f7 ff ff       	call   c010032f <readline>
c0100c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c36:	74 eb                	je     c0100c23 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c42:	89 04 24             	mov    %eax,(%esp)
c0100c45:	e8 f5 fe ff ff       	call   c0100b3f <runcmd>
c0100c4a:	85 c0                	test   %eax,%eax
c0100c4c:	78 02                	js     c0100c50 <kmonitor+0x5c>
                break;
            }
        }
    }
c0100c4e:	eb d3                	jmp    c0100c23 <kmonitor+0x2f>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
c0100c50:	90                   	nop
            }
        }
    }
}
c0100c51:	90                   	nop
c0100c52:	c9                   	leave  
c0100c53:	c3                   	ret    

c0100c54 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c54:	55                   	push   %ebp
c0100c55:	89 e5                	mov    %esp,%ebp
c0100c57:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c61:	eb 3d                	jmp    c0100ca0 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c66:	89 d0                	mov    %edx,%eax
c0100c68:	01 c0                	add    %eax,%eax
c0100c6a:	01 d0                	add    %edx,%eax
c0100c6c:	c1 e0 02             	shl    $0x2,%eax
c0100c6f:	05 04 70 11 c0       	add    $0xc0117004,%eax
c0100c74:	8b 08                	mov    (%eax),%ecx
c0100c76:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c79:	89 d0                	mov    %edx,%eax
c0100c7b:	01 c0                	add    %eax,%eax
c0100c7d:	01 d0                	add    %edx,%eax
c0100c7f:	c1 e0 02             	shl    $0x2,%eax
c0100c82:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c87:	8b 00                	mov    (%eax),%eax
c0100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c91:	c7 04 24 01 5f 10 c0 	movl   $0xc0105f01,(%esp)
c0100c98:	e8 f0 f5 ff ff       	call   c010028d <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9d:	ff 45 f4             	incl   -0xc(%ebp)
c0100ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca3:	83 f8 02             	cmp    $0x2,%eax
c0100ca6:	76 bb                	jbe    c0100c63 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cad:	c9                   	leave  
c0100cae:	c3                   	ret    

c0100caf <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100caf:	55                   	push   %ebp
c0100cb0:	89 e5                	mov    %esp,%ebp
c0100cb2:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb5:	e8 79 fc ff ff       	call   c0100933 <print_kerninfo>
    return 0;
c0100cba:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbf:	c9                   	leave  
c0100cc0:	c3                   	ret    

c0100cc1 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cc1:	55                   	push   %ebp
c0100cc2:	89 e5                	mov    %esp,%ebp
c0100cc4:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc7:	e8 b2 fd ff ff       	call   c0100a7e <print_stackframe>
    return 0;
c0100ccc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd1:	c9                   	leave  
c0100cd2:	c3                   	ret    

c0100cd3 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100cd3:	55                   	push   %ebp
c0100cd4:	89 e5                	mov    %esp,%ebp
c0100cd6:	83 ec 28             	sub    $0x28,%esp
c0100cd9:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100cdf:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ce3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0100ce7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ceb:	ee                   	out    %al,(%dx)
c0100cec:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
c0100cf2:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
c0100cf6:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0100cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100cfd:	ee                   	out    %al,(%dx)
c0100cfe:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d04:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
c0100d08:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d0c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d10:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d11:	c7 05 0c af 11 c0 00 	movl   $0x0,0xc011af0c
c0100d18:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100d1b:	c7 04 24 0a 5f 10 c0 	movl   $0xc0105f0a,(%esp)
c0100d22:	e8 66 f5 ff ff       	call   c010028d <cprintf>
    pic_enable(IRQ_TIMER);
c0100d27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d2e:	e8 1e 09 00 00       	call   c0101651 <pic_enable>
}
c0100d33:	90                   	nop
c0100d34:	c9                   	leave  
c0100d35:	c3                   	ret    

c0100d36 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100d36:	55                   	push   %ebp
c0100d37:	89 e5                	mov    %esp,%ebp
c0100d39:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100d3c:	9c                   	pushf  
c0100d3d:	58                   	pop    %eax
c0100d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100d44:	25 00 02 00 00       	and    $0x200,%eax
c0100d49:	85 c0                	test   %eax,%eax
c0100d4b:	74 0c                	je     c0100d59 <__intr_save+0x23>
        intr_disable();
c0100d4d:	e8 6c 0a 00 00       	call   c01017be <intr_disable>
        return 1;
c0100d52:	b8 01 00 00 00       	mov    $0x1,%eax
c0100d57:	eb 05                	jmp    c0100d5e <__intr_save+0x28>
    }
    return 0;
c0100d59:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d5e:	c9                   	leave  
c0100d5f:	c3                   	ret    

c0100d60 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100d60:	55                   	push   %ebp
c0100d61:	89 e5                	mov    %esp,%ebp
c0100d63:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100d66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d6a:	74 05                	je     c0100d71 <__intr_restore+0x11>
        intr_enable();
c0100d6c:	e8 46 0a 00 00       	call   c01017b7 <intr_enable>
    }
}
c0100d71:	90                   	nop
c0100d72:	c9                   	leave  
c0100d73:	c3                   	ret    

c0100d74 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100d74:	55                   	push   %ebp
c0100d75:	89 e5                	mov    %esp,%ebp
c0100d77:	83 ec 10             	sub    $0x10,%esp
c0100d7a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100d80:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100d84:	89 c2                	mov    %eax,%edx
c0100d86:	ec                   	in     (%dx),%al
c0100d87:	88 45 f4             	mov    %al,-0xc(%ebp)
c0100d8a:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
c0100d90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100d93:	89 c2                	mov    %eax,%edx
c0100d95:	ec                   	in     (%dx),%al
c0100d96:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100d99:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100d9f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100da3:	89 c2                	mov    %eax,%edx
c0100da5:	ec                   	in     (%dx),%al
c0100da6:	88 45 f6             	mov    %al,-0xa(%ebp)
c0100da9:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
c0100daf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100db2:	89 c2                	mov    %eax,%edx
c0100db4:	ec                   	in     (%dx),%al
c0100db5:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100db8:	90                   	nop
c0100db9:	c9                   	leave  
c0100dba:	c3                   	ret    

c0100dbb <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100dbb:	55                   	push   %ebp
c0100dbc:	89 e5                	mov    %esp,%ebp
c0100dbe:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100dc1:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dcb:	0f b7 00             	movzwl (%eax),%eax
c0100dce:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100dd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dd5:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ddd:	0f b7 00             	movzwl (%eax),%eax
c0100de0:	0f b7 c0             	movzwl %ax,%eax
c0100de3:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100de8:	74 12                	je     c0100dfc <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100dea:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100df1:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100df8:	b4 03 
c0100dfa:	eb 13                	jmp    c0100e0f <cga_init+0x54>
    } else {
        *cp = was;
c0100dfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dff:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e03:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e06:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100e0d:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e0f:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100e16:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
c0100e1a:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e1e:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c0100e22:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0100e25:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100e26:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100e2d:	40                   	inc    %eax
c0100e2e:	0f b7 c0             	movzwl %ax,%eax
c0100e31:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e35:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e39:	89 c2                	mov    %eax,%edx
c0100e3b:	ec                   	in     (%dx),%al
c0100e3c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0100e3f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0100e43:	0f b6 c0             	movzbl %al,%eax
c0100e46:	c1 e0 08             	shl    $0x8,%eax
c0100e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100e4c:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100e53:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
c0100e57:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e5b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
c0100e5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100e62:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100e63:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100e6a:	40                   	inc    %eax
c0100e6b:	0f b7 c0             	movzwl %ax,%eax
c0100e6e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e72:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100e76:	89 c2                	mov    %eax,%edx
c0100e78:	ec                   	in     (%dx),%al
c0100e79:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100e7c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e80:	0f b6 c0             	movzbl %al,%eax
c0100e83:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e89:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e91:	0f b7 c0             	movzwl %ax,%eax
c0100e94:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
}
c0100e9a:	90                   	nop
c0100e9b:	c9                   	leave  
c0100e9c:	c3                   	ret    

c0100e9d <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100e9d:	55                   	push   %ebp
c0100e9e:	89 e5                	mov    %esp,%ebp
c0100ea0:	83 ec 38             	sub    $0x38,%esp
c0100ea3:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100ea9:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ead:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c0100eb1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100eb5:	ee                   	out    %al,(%dx)
c0100eb6:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
c0100ebc:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
c0100ec0:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c0100ec4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ec7:	ee                   	out    %al,(%dx)
c0100ec8:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0100ece:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
c0100ed2:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0100ed6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eda:	ee                   	out    %al,(%dx)
c0100edb:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
c0100ee1:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100ee5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100ee9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100eec:	ee                   	out    %al,(%dx)
c0100eed:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
c0100ef3:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
c0100ef7:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0100efb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100eff:	ee                   	out    %al,(%dx)
c0100f00:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
c0100f06:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
c0100f0a:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0100f0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100f11:	ee                   	out    %al,(%dx)
c0100f12:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f18:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
c0100f1c:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c0100f20:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f24:	ee                   	out    %al,(%dx)
c0100f25:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100f2e:	89 c2                	mov    %eax,%edx
c0100f30:	ec                   	in     (%dx),%al
c0100f31:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
c0100f34:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100f38:	3c ff                	cmp    $0xff,%al
c0100f3a:	0f 95 c0             	setne  %al
c0100f3d:	0f b6 c0             	movzbl %al,%eax
c0100f40:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
c0100f45:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f4b:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f4f:	89 c2                	mov    %eax,%edx
c0100f51:	ec                   	in     (%dx),%al
c0100f52:	88 45 e2             	mov    %al,-0x1e(%ebp)
c0100f55:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
c0100f5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100f5e:	89 c2                	mov    %eax,%edx
c0100f60:	ec                   	in     (%dx),%al
c0100f61:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100f64:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0100f69:	85 c0                	test   %eax,%eax
c0100f6b:	74 0c                	je     c0100f79 <serial_init+0xdc>
        pic_enable(IRQ_COM1);
c0100f6d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0100f74:	e8 d8 06 00 00       	call   c0101651 <pic_enable>
    }
}
c0100f79:	90                   	nop
c0100f7a:	c9                   	leave  
c0100f7b:	c3                   	ret    

c0100f7c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0100f7c:	55                   	push   %ebp
c0100f7d:	89 e5                	mov    %esp,%ebp
c0100f7f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0100f89:	eb 08                	jmp    c0100f93 <lpt_putc_sub+0x17>
        delay();
c0100f8b:	e8 e4 fd ff ff       	call   c0100d74 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f90:	ff 45 fc             	incl   -0x4(%ebp)
c0100f93:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
c0100f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f9c:	89 c2                	mov    %eax,%edx
c0100f9e:	ec                   	in     (%dx),%al
c0100f9f:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
c0100fa2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0100fa6:	84 c0                	test   %al,%al
c0100fa8:	78 09                	js     c0100fb3 <lpt_putc_sub+0x37>
c0100faa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0100fb1:	7e d8                	jle    c0100f8b <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0100fb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fb6:	0f b6 c0             	movzbl %al,%eax
c0100fb9:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
c0100fbf:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc2:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
c0100fc6:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0100fc9:	ee                   	out    %al,(%dx)
c0100fca:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0100fd0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0100fd4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fd8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fdc:	ee                   	out    %al,(%dx)
c0100fdd:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
c0100fe3:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
c0100fe7:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
c0100feb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100fef:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0100ff0:	90                   	nop
c0100ff1:	c9                   	leave  
c0100ff2:	c3                   	ret    

c0100ff3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0100ff3:	55                   	push   %ebp
c0100ff4:	89 e5                	mov    %esp,%ebp
c0100ff6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0100ff9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0100ffd:	74 0d                	je     c010100c <lpt_putc+0x19>
        lpt_putc_sub(c);
c0100fff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101002:	89 04 24             	mov    %eax,(%esp)
c0101005:	e8 72 ff ff ff       	call   c0100f7c <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c010100a:	eb 24                	jmp    c0101030 <lpt_putc+0x3d>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
c010100c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101013:	e8 64 ff ff ff       	call   c0100f7c <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101018:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010101f:	e8 58 ff ff ff       	call   c0100f7c <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101024:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010102b:	e8 4c ff ff ff       	call   c0100f7c <lpt_putc_sub>
    }
}
c0101030:	90                   	nop
c0101031:	c9                   	leave  
c0101032:	c3                   	ret    

c0101033 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101033:	55                   	push   %ebp
c0101034:	89 e5                	mov    %esp,%ebp
c0101036:	53                   	push   %ebx
c0101037:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010103a:	8b 45 08             	mov    0x8(%ebp),%eax
c010103d:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101042:	85 c0                	test   %eax,%eax
c0101044:	75 07                	jne    c010104d <cga_putc+0x1a>
        c |= 0x0700;
c0101046:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010104d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101050:	0f b6 c0             	movzbl %al,%eax
c0101053:	83 f8 0a             	cmp    $0xa,%eax
c0101056:	74 54                	je     c01010ac <cga_putc+0x79>
c0101058:	83 f8 0d             	cmp    $0xd,%eax
c010105b:	74 62                	je     c01010bf <cga_putc+0x8c>
c010105d:	83 f8 08             	cmp    $0x8,%eax
c0101060:	0f 85 93 00 00 00    	jne    c01010f9 <cga_putc+0xc6>
    case '\b':
        if (crt_pos > 0) {
c0101066:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010106d:	85 c0                	test   %eax,%eax
c010106f:	0f 84 ae 00 00 00    	je     c0101123 <cga_putc+0xf0>
            crt_pos --;
c0101075:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010107c:	48                   	dec    %eax
c010107d:	0f b7 c0             	movzwl %ax,%eax
c0101080:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101086:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c010108b:	0f b7 15 44 a4 11 c0 	movzwl 0xc011a444,%edx
c0101092:	01 d2                	add    %edx,%edx
c0101094:	01 c2                	add    %eax,%edx
c0101096:	8b 45 08             	mov    0x8(%ebp),%eax
c0101099:	98                   	cwtl   
c010109a:	25 00 ff ff ff       	and    $0xffffff00,%eax
c010109f:	98                   	cwtl   
c01010a0:	83 c8 20             	or     $0x20,%eax
c01010a3:	98                   	cwtl   
c01010a4:	0f b7 c0             	movzwl %ax,%eax
c01010a7:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01010aa:	eb 77                	jmp    c0101123 <cga_putc+0xf0>
    case '\n':
        crt_pos += CRT_COLS;
c01010ac:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01010b3:	83 c0 50             	add    $0x50,%eax
c01010b6:	0f b7 c0             	movzwl %ax,%eax
c01010b9:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01010bf:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c01010c6:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c01010cd:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c01010d2:	89 c8                	mov    %ecx,%eax
c01010d4:	f7 e2                	mul    %edx
c01010d6:	c1 ea 06             	shr    $0x6,%edx
c01010d9:	89 d0                	mov    %edx,%eax
c01010db:	c1 e0 02             	shl    $0x2,%eax
c01010de:	01 d0                	add    %edx,%eax
c01010e0:	c1 e0 04             	shl    $0x4,%eax
c01010e3:	29 c1                	sub    %eax,%ecx
c01010e5:	89 c8                	mov    %ecx,%eax
c01010e7:	0f b7 c0             	movzwl %ax,%eax
c01010ea:	29 c3                	sub    %eax,%ebx
c01010ec:	89 d8                	mov    %ebx,%eax
c01010ee:	0f b7 c0             	movzwl %ax,%eax
c01010f1:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c01010f7:	eb 2b                	jmp    c0101124 <cga_putc+0xf1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01010f9:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01010ff:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101106:	8d 50 01             	lea    0x1(%eax),%edx
c0101109:	0f b7 d2             	movzwl %dx,%edx
c010110c:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
c0101113:	01 c0                	add    %eax,%eax
c0101115:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101118:	8b 45 08             	mov    0x8(%ebp),%eax
c010111b:	0f b7 c0             	movzwl %ax,%eax
c010111e:	66 89 02             	mov    %ax,(%edx)
        break;
c0101121:	eb 01                	jmp    c0101124 <cga_putc+0xf1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c0101123:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101124:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010112b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101130:	76 5d                	jbe    c010118f <cga_putc+0x15c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101132:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101137:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010113d:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101142:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101149:	00 
c010114a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010114e:	89 04 24             	mov    %eax,(%esp)
c0101151:	e8 0b 43 00 00       	call   c0105461 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101156:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010115d:	eb 14                	jmp    c0101173 <cga_putc+0x140>
            crt_buf[i] = 0x0700 | ' ';
c010115f:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101164:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101167:	01 d2                	add    %edx,%edx
c0101169:	01 d0                	add    %edx,%eax
c010116b:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101170:	ff 45 f4             	incl   -0xc(%ebp)
c0101173:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010117a:	7e e3                	jle    c010115f <cga_putc+0x12c>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010117c:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101183:	83 e8 50             	sub    $0x50,%eax
c0101186:	0f b7 c0             	movzwl %ax,%eax
c0101189:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010118f:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0101196:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010119a:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
c010119e:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
c01011a2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01011a6:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c01011a7:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011ae:	c1 e8 08             	shr    $0x8,%eax
c01011b1:	0f b7 c0             	movzwl %ax,%eax
c01011b4:	0f b6 c0             	movzbl %al,%eax
c01011b7:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c01011be:	42                   	inc    %edx
c01011bf:	0f b7 d2             	movzwl %dx,%edx
c01011c2:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
c01011c6:	88 45 e9             	mov    %al,-0x17(%ebp)
c01011c9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01011cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01011d0:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01011d1:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c01011d8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c01011dc:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
c01011e0:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
c01011e4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011e8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01011e9:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011f0:	0f b6 c0             	movzbl %al,%eax
c01011f3:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c01011fa:	42                   	inc    %edx
c01011fb:	0f b7 d2             	movzwl %dx,%edx
c01011fe:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
c0101202:	88 45 eb             	mov    %al,-0x15(%ebp)
c0101205:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
c0101209:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010120c:	ee                   	out    %al,(%dx)
}
c010120d:	90                   	nop
c010120e:	83 c4 24             	add    $0x24,%esp
c0101211:	5b                   	pop    %ebx
c0101212:	5d                   	pop    %ebp
c0101213:	c3                   	ret    

c0101214 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101214:	55                   	push   %ebp
c0101215:	89 e5                	mov    %esp,%ebp
c0101217:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010121a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101221:	eb 08                	jmp    c010122b <serial_putc_sub+0x17>
        delay();
c0101223:	e8 4c fb ff ff       	call   c0100d74 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101228:	ff 45 fc             	incl   -0x4(%ebp)
c010122b:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101231:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101234:	89 c2                	mov    %eax,%edx
c0101236:	ec                   	in     (%dx),%al
c0101237:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c010123a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c010123e:	0f b6 c0             	movzbl %al,%eax
c0101241:	83 e0 20             	and    $0x20,%eax
c0101244:	85 c0                	test   %eax,%eax
c0101246:	75 09                	jne    c0101251 <serial_putc_sub+0x3d>
c0101248:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010124f:	7e d2                	jle    c0101223 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101251:	8b 45 08             	mov    0x8(%ebp),%eax
c0101254:	0f b6 c0             	movzbl %al,%eax
c0101257:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
c010125d:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101260:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
c0101264:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101268:	ee                   	out    %al,(%dx)
}
c0101269:	90                   	nop
c010126a:	c9                   	leave  
c010126b:	c3                   	ret    

c010126c <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010126c:	55                   	push   %ebp
c010126d:	89 e5                	mov    %esp,%ebp
c010126f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101272:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101276:	74 0d                	je     c0101285 <serial_putc+0x19>
        serial_putc_sub(c);
c0101278:	8b 45 08             	mov    0x8(%ebp),%eax
c010127b:	89 04 24             	mov    %eax,(%esp)
c010127e:	e8 91 ff ff ff       	call   c0101214 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101283:	eb 24                	jmp    c01012a9 <serial_putc+0x3d>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
c0101285:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010128c:	e8 83 ff ff ff       	call   c0101214 <serial_putc_sub>
        serial_putc_sub(' ');
c0101291:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101298:	e8 77 ff ff ff       	call   c0101214 <serial_putc_sub>
        serial_putc_sub('\b');
c010129d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01012a4:	e8 6b ff ff ff       	call   c0101214 <serial_putc_sub>
    }
}
c01012a9:	90                   	nop
c01012aa:	c9                   	leave  
c01012ab:	c3                   	ret    

c01012ac <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01012ac:	55                   	push   %ebp
c01012ad:	89 e5                	mov    %esp,%ebp
c01012af:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01012b2:	eb 33                	jmp    c01012e7 <cons_intr+0x3b>
        if (c != 0) {
c01012b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01012b8:	74 2d                	je     c01012e7 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01012ba:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c01012bf:	8d 50 01             	lea    0x1(%eax),%edx
c01012c2:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c01012c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012cb:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01012d1:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c01012d6:	3d 00 02 00 00       	cmp    $0x200,%eax
c01012db:	75 0a                	jne    c01012e7 <cons_intr+0x3b>
                cons.wpos = 0;
c01012dd:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
c01012e4:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01012e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01012ea:	ff d0                	call   *%eax
c01012ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01012ef:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01012f3:	75 bf                	jne    c01012b4 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01012f5:	90                   	nop
c01012f6:	c9                   	leave  
c01012f7:	c3                   	ret    

c01012f8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01012f8:	55                   	push   %ebp
c01012f9:	89 e5                	mov    %esp,%ebp
c01012fb:	83 ec 10             	sub    $0x10,%esp
c01012fe:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101304:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101307:	89 c2                	mov    %eax,%edx
c0101309:	ec                   	in     (%dx),%al
c010130a:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
c010130d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101311:	0f b6 c0             	movzbl %al,%eax
c0101314:	83 e0 01             	and    $0x1,%eax
c0101317:	85 c0                	test   %eax,%eax
c0101319:	75 07                	jne    c0101322 <serial_proc_data+0x2a>
        return -1;
c010131b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101320:	eb 2a                	jmp    c010134c <serial_proc_data+0x54>
c0101322:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101328:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010132c:	89 c2                	mov    %eax,%edx
c010132e:	ec                   	in     (%dx),%al
c010132f:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
c0101332:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101336:	0f b6 c0             	movzbl %al,%eax
c0101339:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c010133c:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101340:	75 07                	jne    c0101349 <serial_proc_data+0x51>
        c = '\b';
c0101342:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101349:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010134c:	c9                   	leave  
c010134d:	c3                   	ret    

c010134e <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010134e:	55                   	push   %ebp
c010134f:	89 e5                	mov    %esp,%ebp
c0101351:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101354:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101359:	85 c0                	test   %eax,%eax
c010135b:	74 0c                	je     c0101369 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010135d:	c7 04 24 f8 12 10 c0 	movl   $0xc01012f8,(%esp)
c0101364:	e8 43 ff ff ff       	call   c01012ac <cons_intr>
    }
}
c0101369:	90                   	nop
c010136a:	c9                   	leave  
c010136b:	c3                   	ret    

c010136c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010136c:	55                   	push   %ebp
c010136d:	89 e5                	mov    %esp,%ebp
c010136f:	83 ec 28             	sub    $0x28,%esp
c0101372:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101378:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010137b:	89 c2                	mov    %eax,%edx
c010137d:	ec                   	in     (%dx),%al
c010137e:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101381:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101385:	0f b6 c0             	movzbl %al,%eax
c0101388:	83 e0 01             	and    $0x1,%eax
c010138b:	85 c0                	test   %eax,%eax
c010138d:	75 0a                	jne    c0101399 <kbd_proc_data+0x2d>
        return -1;
c010138f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101394:	e9 56 01 00 00       	jmp    c01014ef <kbd_proc_data+0x183>
c0101399:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010139f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01013a2:	89 c2                	mov    %eax,%edx
c01013a4:	ec                   	in     (%dx),%al
c01013a5:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
c01013a8:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
c01013ac:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01013af:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01013b3:	75 17                	jne    c01013cc <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c01013b5:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01013ba:	83 c8 40             	or     $0x40,%eax
c01013bd:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01013c2:	b8 00 00 00 00       	mov    $0x0,%eax
c01013c7:	e9 23 01 00 00       	jmp    c01014ef <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c01013cc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013d0:	84 c0                	test   %al,%al
c01013d2:	79 45                	jns    c0101419 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01013d4:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01013d9:	83 e0 40             	and    $0x40,%eax
c01013dc:	85 c0                	test   %eax,%eax
c01013de:	75 08                	jne    c01013e8 <kbd_proc_data+0x7c>
c01013e0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013e4:	24 7f                	and    $0x7f,%al
c01013e6:	eb 04                	jmp    c01013ec <kbd_proc_data+0x80>
c01013e8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013ec:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01013ef:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013f3:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01013fa:	0c 40                	or     $0x40,%al
c01013fc:	0f b6 c0             	movzbl %al,%eax
c01013ff:	f7 d0                	not    %eax
c0101401:	89 c2                	mov    %eax,%edx
c0101403:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101408:	21 d0                	and    %edx,%eax
c010140a:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c010140f:	b8 00 00 00 00       	mov    $0x0,%eax
c0101414:	e9 d6 00 00 00       	jmp    c01014ef <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c0101419:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010141e:	83 e0 40             	and    $0x40,%eax
c0101421:	85 c0                	test   %eax,%eax
c0101423:	74 11                	je     c0101436 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101425:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101429:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010142e:	83 e0 bf             	and    $0xffffffbf,%eax
c0101431:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c0101436:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010143a:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c0101441:	0f b6 d0             	movzbl %al,%edx
c0101444:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101449:	09 d0                	or     %edx,%eax
c010144b:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c0101450:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101454:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c010145b:	0f b6 d0             	movzbl %al,%edx
c010145e:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101463:	31 d0                	xor    %edx,%eax
c0101465:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c010146a:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010146f:	83 e0 03             	and    $0x3,%eax
c0101472:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c0101479:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147d:	01 d0                	add    %edx,%eax
c010147f:	0f b6 00             	movzbl (%eax),%eax
c0101482:	0f b6 c0             	movzbl %al,%eax
c0101485:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101488:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010148d:	83 e0 08             	and    $0x8,%eax
c0101490:	85 c0                	test   %eax,%eax
c0101492:	74 22                	je     c01014b6 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c0101494:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101498:	7e 0c                	jle    c01014a6 <kbd_proc_data+0x13a>
c010149a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010149e:	7f 06                	jg     c01014a6 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c01014a0:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01014a4:	eb 10                	jmp    c01014b6 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c01014a6:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01014aa:	7e 0a                	jle    c01014b6 <kbd_proc_data+0x14a>
c01014ac:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01014b0:	7f 04                	jg     c01014b6 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c01014b2:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01014b6:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014bb:	f7 d0                	not    %eax
c01014bd:	83 e0 06             	and    $0x6,%eax
c01014c0:	85 c0                	test   %eax,%eax
c01014c2:	75 28                	jne    c01014ec <kbd_proc_data+0x180>
c01014c4:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01014cb:	75 1f                	jne    c01014ec <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c01014cd:	c7 04 24 25 5f 10 c0 	movl   $0xc0105f25,(%esp)
c01014d4:	e8 b4 ed ff ff       	call   c010028d <cprintf>
c01014d9:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
c01014df:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01014e3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01014e7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01014eb:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01014ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01014ef:	c9                   	leave  
c01014f0:	c3                   	ret    

c01014f1 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01014f1:	55                   	push   %ebp
c01014f2:	89 e5                	mov    %esp,%ebp
c01014f4:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01014f7:	c7 04 24 6c 13 10 c0 	movl   $0xc010136c,(%esp)
c01014fe:	e8 a9 fd ff ff       	call   c01012ac <cons_intr>
}
c0101503:	90                   	nop
c0101504:	c9                   	leave  
c0101505:	c3                   	ret    

c0101506 <kbd_init>:

static void
kbd_init(void) {
c0101506:	55                   	push   %ebp
c0101507:	89 e5                	mov    %esp,%ebp
c0101509:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c010150c:	e8 e0 ff ff ff       	call   c01014f1 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101511:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101518:	e8 34 01 00 00       	call   c0101651 <pic_enable>
}
c010151d:	90                   	nop
c010151e:	c9                   	leave  
c010151f:	c3                   	ret    

c0101520 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101520:	55                   	push   %ebp
c0101521:	89 e5                	mov    %esp,%ebp
c0101523:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101526:	e8 90 f8 ff ff       	call   c0100dbb <cga_init>
    serial_init();
c010152b:	e8 6d f9 ff ff       	call   c0100e9d <serial_init>
    kbd_init();
c0101530:	e8 d1 ff ff ff       	call   c0101506 <kbd_init>
    if (!serial_exists) {
c0101535:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010153a:	85 c0                	test   %eax,%eax
c010153c:	75 0c                	jne    c010154a <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010153e:	c7 04 24 31 5f 10 c0 	movl   $0xc0105f31,(%esp)
c0101545:	e8 43 ed ff ff       	call   c010028d <cprintf>
    }
}
c010154a:	90                   	nop
c010154b:	c9                   	leave  
c010154c:	c3                   	ret    

c010154d <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010154d:	55                   	push   %ebp
c010154e:	89 e5                	mov    %esp,%ebp
c0101550:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101553:	e8 de f7 ff ff       	call   c0100d36 <__intr_save>
c0101558:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010155b:	8b 45 08             	mov    0x8(%ebp),%eax
c010155e:	89 04 24             	mov    %eax,(%esp)
c0101561:	e8 8d fa ff ff       	call   c0100ff3 <lpt_putc>
        cga_putc(c);
c0101566:	8b 45 08             	mov    0x8(%ebp),%eax
c0101569:	89 04 24             	mov    %eax,(%esp)
c010156c:	e8 c2 fa ff ff       	call   c0101033 <cga_putc>
        serial_putc(c);
c0101571:	8b 45 08             	mov    0x8(%ebp),%eax
c0101574:	89 04 24             	mov    %eax,(%esp)
c0101577:	e8 f0 fc ff ff       	call   c010126c <serial_putc>
    }
    local_intr_restore(intr_flag);
c010157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010157f:	89 04 24             	mov    %eax,(%esp)
c0101582:	e8 d9 f7 ff ff       	call   c0100d60 <__intr_restore>
}
c0101587:	90                   	nop
c0101588:	c9                   	leave  
c0101589:	c3                   	ret    

c010158a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010158a:	55                   	push   %ebp
c010158b:	89 e5                	mov    %esp,%ebp
c010158d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101590:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101597:	e8 9a f7 ff ff       	call   c0100d36 <__intr_save>
c010159c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010159f:	e8 aa fd ff ff       	call   c010134e <serial_intr>
        kbd_intr();
c01015a4:	e8 48 ff ff ff       	call   c01014f1 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01015a9:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c01015af:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c01015b4:	39 c2                	cmp    %eax,%edx
c01015b6:	74 31                	je     c01015e9 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01015b8:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c01015bd:	8d 50 01             	lea    0x1(%eax),%edx
c01015c0:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c01015c6:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c01015cd:	0f b6 c0             	movzbl %al,%eax
c01015d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01015d3:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c01015d8:	3d 00 02 00 00       	cmp    $0x200,%eax
c01015dd:	75 0a                	jne    c01015e9 <cons_getc+0x5f>
                cons.rpos = 0;
c01015df:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
c01015e6:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01015ec:	89 04 24             	mov    %eax,(%esp)
c01015ef:	e8 6c f7 ff ff       	call   c0100d60 <__intr_restore>
    return c;
c01015f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015f7:	c9                   	leave  
c01015f8:	c3                   	ret    

c01015f9 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01015f9:	55                   	push   %ebp
c01015fa:	89 e5                	mov    %esp,%ebp
c01015fc:	83 ec 14             	sub    $0x14,%esp
c01015ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101602:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101606:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101609:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c010160f:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
c0101614:	85 c0                	test   %eax,%eax
c0101616:	74 36                	je     c010164e <pic_setmask+0x55>
        outb(IO_PIC1 + 1, mask);
c0101618:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010161b:	0f b6 c0             	movzbl %al,%eax
c010161e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101624:	88 45 fa             	mov    %al,-0x6(%ebp)
c0101627:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
c010162b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010162f:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101630:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101634:	c1 e8 08             	shr    $0x8,%eax
c0101637:	0f b7 c0             	movzwl %ax,%eax
c010163a:	0f b6 c0             	movzbl %al,%eax
c010163d:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c0101643:	88 45 fb             	mov    %al,-0x5(%ebp)
c0101646:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
c010164a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010164d:	ee                   	out    %al,(%dx)
    }
}
c010164e:	90                   	nop
c010164f:	c9                   	leave  
c0101650:	c3                   	ret    

c0101651 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101651:	55                   	push   %ebp
c0101652:	89 e5                	mov    %esp,%ebp
c0101654:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101657:	8b 45 08             	mov    0x8(%ebp),%eax
c010165a:	ba 01 00 00 00       	mov    $0x1,%edx
c010165f:	88 c1                	mov    %al,%cl
c0101661:	d3 e2                	shl    %cl,%edx
c0101663:	89 d0                	mov    %edx,%eax
c0101665:	98                   	cwtl   
c0101666:	f7 d0                	not    %eax
c0101668:	0f bf d0             	movswl %ax,%edx
c010166b:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101672:	98                   	cwtl   
c0101673:	21 d0                	and    %edx,%eax
c0101675:	98                   	cwtl   
c0101676:	0f b7 c0             	movzwl %ax,%eax
c0101679:	89 04 24             	mov    %eax,(%esp)
c010167c:	e8 78 ff ff ff       	call   c01015f9 <pic_setmask>
}
c0101681:	90                   	nop
c0101682:	c9                   	leave  
c0101683:	c3                   	ret    

c0101684 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101684:	55                   	push   %ebp
c0101685:	89 e5                	mov    %esp,%ebp
c0101687:	83 ec 34             	sub    $0x34,%esp
    did_init = 1;
c010168a:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
c0101691:	00 00 00 
c0101694:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010169a:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
c010169e:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
c01016a2:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016a6:	ee                   	out    %al,(%dx)
c01016a7:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
c01016ad:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
c01016b1:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
c01016b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01016b8:	ee                   	out    %al,(%dx)
c01016b9:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
c01016bf:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
c01016c3:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
c01016c7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016cb:	ee                   	out    %al,(%dx)
c01016cc:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
c01016d2:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
c01016d6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01016da:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01016dd:	ee                   	out    %al,(%dx)
c01016de:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
c01016e4:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
c01016e8:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
c01016ec:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01016f0:	ee                   	out    %al,(%dx)
c01016f1:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
c01016f7:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
c01016fb:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
c01016ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101702:	ee                   	out    %al,(%dx)
c0101703:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
c0101709:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
c010170d:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
c0101711:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101715:	ee                   	out    %al,(%dx)
c0101716:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
c010171c:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
c0101720:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101724:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0101727:	ee                   	out    %al,(%dx)
c0101728:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c010172e:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
c0101732:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
c0101736:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010173a:	ee                   	out    %al,(%dx)
c010173b:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
c0101741:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
c0101745:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
c0101749:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010174c:	ee                   	out    %al,(%dx)
c010174d:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
c0101753:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
c0101757:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
c010175b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010175f:	ee                   	out    %al,(%dx)
c0101760:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
c0101766:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
c010176a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010176e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101771:	ee                   	out    %al,(%dx)
c0101772:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0101778:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
c010177c:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
c0101780:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101784:	ee                   	out    %al,(%dx)
c0101785:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
c010178b:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
c010178f:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
c0101793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0101796:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101797:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c010179e:	3d ff ff 00 00       	cmp    $0xffff,%eax
c01017a3:	74 0f                	je     c01017b4 <pic_init+0x130>
        pic_setmask(irq_mask);
c01017a5:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c01017ac:	89 04 24             	mov    %eax,(%esp)
c01017af:	e8 45 fe ff ff       	call   c01015f9 <pic_setmask>
    }
}
c01017b4:	90                   	nop
c01017b5:	c9                   	leave  
c01017b6:	c3                   	ret    

c01017b7 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01017b7:	55                   	push   %ebp
c01017b8:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01017ba:	fb                   	sti    
    sti();
}
c01017bb:	90                   	nop
c01017bc:	5d                   	pop    %ebp
c01017bd:	c3                   	ret    

c01017be <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01017be:	55                   	push   %ebp
c01017bf:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01017c1:	fa                   	cli    
    cli();
}
c01017c2:	90                   	nop
c01017c3:	5d                   	pop    %ebp
c01017c4:	c3                   	ret    

c01017c5 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01017c5:	55                   	push   %ebp
c01017c6:	89 e5                	mov    %esp,%ebp
c01017c8:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01017cb:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01017d2:	00 
c01017d3:	c7 04 24 60 5f 10 c0 	movl   $0xc0105f60,(%esp)
c01017da:	e8 ae ea ff ff       	call   c010028d <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01017df:	90                   	nop
c01017e0:	c9                   	leave  
c01017e1:	c3                   	ret    

c01017e2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01017e2:	55                   	push   %ebp
c01017e3:	89 e5                	mov    %esp,%ebp
c01017e5:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
         extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01017e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01017ef:	e9 c4 00 00 00       	jmp    c01018b8 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01017f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01017f7:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01017fe:	0f b7 d0             	movzwl %ax,%edx
c0101801:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101804:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c010180b:	c0 
c010180c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010180f:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c0101816:	c0 08 00 
c0101819:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010181c:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101823:	c0 
c0101824:	80 e2 e0             	and    $0xe0,%dl
c0101827:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c010182e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101831:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101838:	c0 
c0101839:	80 e2 1f             	and    $0x1f,%dl
c010183c:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101843:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101846:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010184d:	c0 
c010184e:	80 e2 f0             	and    $0xf0,%dl
c0101851:	80 ca 0e             	or     $0xe,%dl
c0101854:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010185b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010185e:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101865:	c0 
c0101866:	80 e2 ef             	and    $0xef,%dl
c0101869:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101870:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101873:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010187a:	c0 
c010187b:	80 e2 9f             	and    $0x9f,%dl
c010187e:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101885:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101888:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010188f:	c0 
c0101890:	80 ca 80             	or     $0x80,%dl
c0101893:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010189a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010189d:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01018a4:	c1 e8 10             	shr    $0x10,%eax
c01018a7:	0f b7 d0             	movzwl %ax,%edx
c01018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ad:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c01018b4:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
         extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018b5:	ff 45 fc             	incl   -0x4(%ebp)
c01018b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018bb:	3d ff 00 00 00       	cmp    $0xff,%eax
c01018c0:	0f 86 2e ff ff ff    	jbe    c01017f4 <idt_init+0x12>
c01018c6:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01018cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01018d0:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
c01018d3:	90                   	nop
c01018d4:	c9                   	leave  
c01018d5:	c3                   	ret    

c01018d6 <trapname>:

static const char *
trapname(int trapno) {
c01018d6:	55                   	push   %ebp
c01018d7:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01018d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01018dc:	83 f8 13             	cmp    $0x13,%eax
c01018df:	77 0c                	ja     c01018ed <trapname+0x17>
        return excnames[trapno];
c01018e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01018e4:	8b 04 85 c0 62 10 c0 	mov    -0x3fef9d40(,%eax,4),%eax
c01018eb:	eb 18                	jmp    c0101905 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01018ed:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01018f1:	7e 0d                	jle    c0101900 <trapname+0x2a>
c01018f3:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01018f7:	7f 07                	jg     c0101900 <trapname+0x2a>
        return "Hardware Interrupt";
c01018f9:	b8 6a 5f 10 c0       	mov    $0xc0105f6a,%eax
c01018fe:	eb 05                	jmp    c0101905 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101900:	b8 7d 5f 10 c0       	mov    $0xc0105f7d,%eax
}
c0101905:	5d                   	pop    %ebp
c0101906:	c3                   	ret    

c0101907 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101907:	55                   	push   %ebp
c0101908:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c010190a:	8b 45 08             	mov    0x8(%ebp),%eax
c010190d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101911:	83 f8 08             	cmp    $0x8,%eax
c0101914:	0f 94 c0             	sete   %al
c0101917:	0f b6 c0             	movzbl %al,%eax
}
c010191a:	5d                   	pop    %ebp
c010191b:	c3                   	ret    

c010191c <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c010191c:	55                   	push   %ebp
c010191d:	89 e5                	mov    %esp,%ebp
c010191f:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101922:	8b 45 08             	mov    0x8(%ebp),%eax
c0101925:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101929:	c7 04 24 be 5f 10 c0 	movl   $0xc0105fbe,(%esp)
c0101930:	e8 58 e9 ff ff       	call   c010028d <cprintf>
    print_regs(&tf->tf_regs);
c0101935:	8b 45 08             	mov    0x8(%ebp),%eax
c0101938:	89 04 24             	mov    %eax,(%esp)
c010193b:	e8 91 01 00 00       	call   c0101ad1 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101940:	8b 45 08             	mov    0x8(%ebp),%eax
c0101943:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101947:	89 44 24 04          	mov    %eax,0x4(%esp)
c010194b:	c7 04 24 cf 5f 10 c0 	movl   $0xc0105fcf,(%esp)
c0101952:	e8 36 e9 ff ff       	call   c010028d <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101957:	8b 45 08             	mov    0x8(%ebp),%eax
c010195a:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c010195e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101962:	c7 04 24 e2 5f 10 c0 	movl   $0xc0105fe2,(%esp)
c0101969:	e8 1f e9 ff ff       	call   c010028d <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c010196e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101971:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101975:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101979:	c7 04 24 f5 5f 10 c0 	movl   $0xc0105ff5,(%esp)
c0101980:	e8 08 e9 ff ff       	call   c010028d <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101985:	8b 45 08             	mov    0x8(%ebp),%eax
c0101988:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010198c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101990:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
c0101997:	e8 f1 e8 ff ff       	call   c010028d <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010199c:	8b 45 08             	mov    0x8(%ebp),%eax
c010199f:	8b 40 30             	mov    0x30(%eax),%eax
c01019a2:	89 04 24             	mov    %eax,(%esp)
c01019a5:	e8 2c ff ff ff       	call   c01018d6 <trapname>
c01019aa:	89 c2                	mov    %eax,%edx
c01019ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01019af:	8b 40 30             	mov    0x30(%eax),%eax
c01019b2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019ba:	c7 04 24 1b 60 10 c0 	movl   $0xc010601b,(%esp)
c01019c1:	e8 c7 e8 ff ff       	call   c010028d <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01019c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01019c9:	8b 40 34             	mov    0x34(%eax),%eax
c01019cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019d0:	c7 04 24 2d 60 10 c0 	movl   $0xc010602d,(%esp)
c01019d7:	e8 b1 e8 ff ff       	call   c010028d <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01019dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01019df:	8b 40 38             	mov    0x38(%eax),%eax
c01019e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e6:	c7 04 24 3c 60 10 c0 	movl   $0xc010603c,(%esp)
c01019ed:	e8 9b e8 ff ff       	call   c010028d <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01019f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019fd:	c7 04 24 4b 60 10 c0 	movl   $0xc010604b,(%esp)
c0101a04:	e8 84 e8 ff ff       	call   c010028d <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101a09:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a0c:	8b 40 40             	mov    0x40(%eax),%eax
c0101a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a13:	c7 04 24 5e 60 10 c0 	movl   $0xc010605e,(%esp)
c0101a1a:	e8 6e e8 ff ff       	call   c010028d <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101a1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101a26:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101a2d:	eb 3d                	jmp    c0101a6c <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101a2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a32:	8b 50 40             	mov    0x40(%eax),%edx
c0101a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101a38:	21 d0                	and    %edx,%eax
c0101a3a:	85 c0                	test   %eax,%eax
c0101a3c:	74 28                	je     c0101a66 <print_trapframe+0x14a>
c0101a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a41:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101a48:	85 c0                	test   %eax,%eax
c0101a4a:	74 1a                	je     c0101a66 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c0101a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a4f:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101a56:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a5a:	c7 04 24 6d 60 10 c0 	movl   $0xc010606d,(%esp)
c0101a61:	e8 27 e8 ff ff       	call   c010028d <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101a66:	ff 45 f4             	incl   -0xc(%ebp)
c0101a69:	d1 65 f0             	shll   -0x10(%ebp)
c0101a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a6f:	83 f8 17             	cmp    $0x17,%eax
c0101a72:	76 bb                	jbe    c0101a2f <print_trapframe+0x113>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101a74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a77:	8b 40 40             	mov    0x40(%eax),%eax
c0101a7a:	25 00 30 00 00       	and    $0x3000,%eax
c0101a7f:	c1 e8 0c             	shr    $0xc,%eax
c0101a82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a86:	c7 04 24 71 60 10 c0 	movl   $0xc0106071,(%esp)
c0101a8d:	e8 fb e7 ff ff       	call   c010028d <cprintf>

    if (!trap_in_kernel(tf)) {
c0101a92:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a95:	89 04 24             	mov    %eax,(%esp)
c0101a98:	e8 6a fe ff ff       	call   c0101907 <trap_in_kernel>
c0101a9d:	85 c0                	test   %eax,%eax
c0101a9f:	75 2d                	jne    c0101ace <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101aa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa4:	8b 40 44             	mov    0x44(%eax),%eax
c0101aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aab:	c7 04 24 7a 60 10 c0 	movl   $0xc010607a,(%esp)
c0101ab2:	e8 d6 e7 ff ff       	call   c010028d <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aba:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101abe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac2:	c7 04 24 89 60 10 c0 	movl   $0xc0106089,(%esp)
c0101ac9:	e8 bf e7 ff ff       	call   c010028d <cprintf>
    }
}
c0101ace:	90                   	nop
c0101acf:	c9                   	leave  
c0101ad0:	c3                   	ret    

c0101ad1 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101ad1:	55                   	push   %ebp
c0101ad2:	89 e5                	mov    %esp,%ebp
c0101ad4:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ada:	8b 00                	mov    (%eax),%eax
c0101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae0:	c7 04 24 9c 60 10 c0 	movl   $0xc010609c,(%esp)
c0101ae7:	e8 a1 e7 ff ff       	call   c010028d <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101aec:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aef:	8b 40 04             	mov    0x4(%eax),%eax
c0101af2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af6:	c7 04 24 ab 60 10 c0 	movl   $0xc01060ab,(%esp)
c0101afd:	e8 8b e7 ff ff       	call   c010028d <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b05:	8b 40 08             	mov    0x8(%eax),%eax
c0101b08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b0c:	c7 04 24 ba 60 10 c0 	movl   $0xc01060ba,(%esp)
c0101b13:	e8 75 e7 ff ff       	call   c010028d <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101b18:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1b:	8b 40 0c             	mov    0xc(%eax),%eax
c0101b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b22:	c7 04 24 c9 60 10 c0 	movl   $0xc01060c9,(%esp)
c0101b29:	e8 5f e7 ff ff       	call   c010028d <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b31:	8b 40 10             	mov    0x10(%eax),%eax
c0101b34:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b38:	c7 04 24 d8 60 10 c0 	movl   $0xc01060d8,(%esp)
c0101b3f:	e8 49 e7 ff ff       	call   c010028d <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101b44:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b47:	8b 40 14             	mov    0x14(%eax),%eax
c0101b4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b4e:	c7 04 24 e7 60 10 c0 	movl   $0xc01060e7,(%esp)
c0101b55:	e8 33 e7 ff ff       	call   c010028d <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101b5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5d:	8b 40 18             	mov    0x18(%eax),%eax
c0101b60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b64:	c7 04 24 f6 60 10 c0 	movl   $0xc01060f6,(%esp)
c0101b6b:	e8 1d e7 ff ff       	call   c010028d <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101b70:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b73:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101b76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b7a:	c7 04 24 05 61 10 c0 	movl   $0xc0106105,(%esp)
c0101b81:	e8 07 e7 ff ff       	call   c010028d <cprintf>
}
c0101b86:	90                   	nop
c0101b87:	c9                   	leave  
c0101b88:	c3                   	ret    

c0101b89 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101b89:	55                   	push   %ebp
c0101b8a:	89 e5                	mov    %esp,%ebp
c0101b8c:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101b8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b92:	8b 40 30             	mov    0x30(%eax),%eax
c0101b95:	83 f8 2f             	cmp    $0x2f,%eax
c0101b98:	77 1e                	ja     c0101bb8 <trap_dispatch+0x2f>
c0101b9a:	83 f8 2e             	cmp    $0x2e,%eax
c0101b9d:	0f 83 bc 00 00 00    	jae    c0101c5f <trap_dispatch+0xd6>
c0101ba3:	83 f8 21             	cmp    $0x21,%eax
c0101ba6:	74 40                	je     c0101be8 <trap_dispatch+0x5f>
c0101ba8:	83 f8 24             	cmp    $0x24,%eax
c0101bab:	74 15                	je     c0101bc2 <trap_dispatch+0x39>
c0101bad:	83 f8 20             	cmp    $0x20,%eax
c0101bb0:	0f 84 ac 00 00 00    	je     c0101c62 <trap_dispatch+0xd9>
c0101bb6:	eb 72                	jmp    c0101c2a <trap_dispatch+0xa1>
c0101bb8:	83 e8 78             	sub    $0x78,%eax
c0101bbb:	83 f8 01             	cmp    $0x1,%eax
c0101bbe:	77 6a                	ja     c0101c2a <trap_dispatch+0xa1>
c0101bc0:	eb 4c                	jmp    c0101c0e <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101bc2:	e8 c3 f9 ff ff       	call   c010158a <cons_getc>
c0101bc7:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101bca:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101bce:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101bd2:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bda:	c7 04 24 14 61 10 c0 	movl   $0xc0106114,(%esp)
c0101be1:	e8 a7 e6 ff ff       	call   c010028d <cprintf>
        break;
c0101be6:	eb 7b                	jmp    c0101c63 <trap_dispatch+0xda>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101be8:	e8 9d f9 ff ff       	call   c010158a <cons_getc>
c0101bed:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101bf0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101bf4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101bf8:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c00:	c7 04 24 26 61 10 c0 	movl   $0xc0106126,(%esp)
c0101c07:	e8 81 e6 ff ff       	call   c010028d <cprintf>
        break;
c0101c0c:	eb 55                	jmp    c0101c63 <trap_dispatch+0xda>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101c0e:	c7 44 24 08 35 61 10 	movl   $0xc0106135,0x8(%esp)
c0101c15:	c0 
c0101c16:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
c0101c1d:	00 
c0101c1e:	c7 04 24 45 61 10 c0 	movl   $0xc0106145,(%esp)
c0101c25:	e8 ba e7 ff ff       	call   c01003e4 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101c31:	83 e0 03             	and    $0x3,%eax
c0101c34:	85 c0                	test   %eax,%eax
c0101c36:	75 2b                	jne    c0101c63 <trap_dispatch+0xda>
            print_trapframe(tf);
c0101c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3b:	89 04 24             	mov    %eax,(%esp)
c0101c3e:	e8 d9 fc ff ff       	call   c010191c <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101c43:	c7 44 24 08 56 61 10 	movl   $0xc0106156,0x8(%esp)
c0101c4a:	c0 
c0101c4b:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0101c52:	00 
c0101c53:	c7 04 24 45 61 10 c0 	movl   $0xc0106145,(%esp)
c0101c5a:	e8 85 e7 ff ff       	call   c01003e4 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101c5f:	90                   	nop
c0101c60:	eb 01                	jmp    c0101c63 <trap_dispatch+0xda>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c0101c62:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101c63:	90                   	nop
c0101c64:	c9                   	leave  
c0101c65:	c3                   	ret    

c0101c66 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101c66:	55                   	push   %ebp
c0101c67:	89 e5                	mov    %esp,%ebp
c0101c69:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6f:	89 04 24             	mov    %eax,(%esp)
c0101c72:	e8 12 ff ff ff       	call   c0101b89 <trap_dispatch>
}
c0101c77:	90                   	nop
c0101c78:	c9                   	leave  
c0101c79:	c3                   	ret    

c0101c7a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101c7a:	6a 00                	push   $0x0
  pushl $0
c0101c7c:	6a 00                	push   $0x0
  jmp __alltraps
c0101c7e:	e9 69 0a 00 00       	jmp    c01026ec <__alltraps>

c0101c83 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101c83:	6a 00                	push   $0x0
  pushl $1
c0101c85:	6a 01                	push   $0x1
  jmp __alltraps
c0101c87:	e9 60 0a 00 00       	jmp    c01026ec <__alltraps>

c0101c8c <vector2>:
.globl vector2
vector2:
  pushl $0
c0101c8c:	6a 00                	push   $0x0
  pushl $2
c0101c8e:	6a 02                	push   $0x2
  jmp __alltraps
c0101c90:	e9 57 0a 00 00       	jmp    c01026ec <__alltraps>

c0101c95 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101c95:	6a 00                	push   $0x0
  pushl $3
c0101c97:	6a 03                	push   $0x3
  jmp __alltraps
c0101c99:	e9 4e 0a 00 00       	jmp    c01026ec <__alltraps>

c0101c9e <vector4>:
.globl vector4
vector4:
  pushl $0
c0101c9e:	6a 00                	push   $0x0
  pushl $4
c0101ca0:	6a 04                	push   $0x4
  jmp __alltraps
c0101ca2:	e9 45 0a 00 00       	jmp    c01026ec <__alltraps>

c0101ca7 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101ca7:	6a 00                	push   $0x0
  pushl $5
c0101ca9:	6a 05                	push   $0x5
  jmp __alltraps
c0101cab:	e9 3c 0a 00 00       	jmp    c01026ec <__alltraps>

c0101cb0 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101cb0:	6a 00                	push   $0x0
  pushl $6
c0101cb2:	6a 06                	push   $0x6
  jmp __alltraps
c0101cb4:	e9 33 0a 00 00       	jmp    c01026ec <__alltraps>

c0101cb9 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101cb9:	6a 00                	push   $0x0
  pushl $7
c0101cbb:	6a 07                	push   $0x7
  jmp __alltraps
c0101cbd:	e9 2a 0a 00 00       	jmp    c01026ec <__alltraps>

c0101cc2 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101cc2:	6a 08                	push   $0x8
  jmp __alltraps
c0101cc4:	e9 23 0a 00 00       	jmp    c01026ec <__alltraps>

c0101cc9 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101cc9:	6a 00                	push   $0x0
  pushl $9
c0101ccb:	6a 09                	push   $0x9
  jmp __alltraps
c0101ccd:	e9 1a 0a 00 00       	jmp    c01026ec <__alltraps>

c0101cd2 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101cd2:	6a 0a                	push   $0xa
  jmp __alltraps
c0101cd4:	e9 13 0a 00 00       	jmp    c01026ec <__alltraps>

c0101cd9 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101cd9:	6a 0b                	push   $0xb
  jmp __alltraps
c0101cdb:	e9 0c 0a 00 00       	jmp    c01026ec <__alltraps>

c0101ce0 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ce0:	6a 0c                	push   $0xc
  jmp __alltraps
c0101ce2:	e9 05 0a 00 00       	jmp    c01026ec <__alltraps>

c0101ce7 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101ce7:	6a 0d                	push   $0xd
  jmp __alltraps
c0101ce9:	e9 fe 09 00 00       	jmp    c01026ec <__alltraps>

c0101cee <vector14>:
.globl vector14
vector14:
  pushl $14
c0101cee:	6a 0e                	push   $0xe
  jmp __alltraps
c0101cf0:	e9 f7 09 00 00       	jmp    c01026ec <__alltraps>

c0101cf5 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101cf5:	6a 00                	push   $0x0
  pushl $15
c0101cf7:	6a 0f                	push   $0xf
  jmp __alltraps
c0101cf9:	e9 ee 09 00 00       	jmp    c01026ec <__alltraps>

c0101cfe <vector16>:
.globl vector16
vector16:
  pushl $0
c0101cfe:	6a 00                	push   $0x0
  pushl $16
c0101d00:	6a 10                	push   $0x10
  jmp __alltraps
c0101d02:	e9 e5 09 00 00       	jmp    c01026ec <__alltraps>

c0101d07 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101d07:	6a 11                	push   $0x11
  jmp __alltraps
c0101d09:	e9 de 09 00 00       	jmp    c01026ec <__alltraps>

c0101d0e <vector18>:
.globl vector18
vector18:
  pushl $0
c0101d0e:	6a 00                	push   $0x0
  pushl $18
c0101d10:	6a 12                	push   $0x12
  jmp __alltraps
c0101d12:	e9 d5 09 00 00       	jmp    c01026ec <__alltraps>

c0101d17 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101d17:	6a 00                	push   $0x0
  pushl $19
c0101d19:	6a 13                	push   $0x13
  jmp __alltraps
c0101d1b:	e9 cc 09 00 00       	jmp    c01026ec <__alltraps>

c0101d20 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101d20:	6a 00                	push   $0x0
  pushl $20
c0101d22:	6a 14                	push   $0x14
  jmp __alltraps
c0101d24:	e9 c3 09 00 00       	jmp    c01026ec <__alltraps>

c0101d29 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101d29:	6a 00                	push   $0x0
  pushl $21
c0101d2b:	6a 15                	push   $0x15
  jmp __alltraps
c0101d2d:	e9 ba 09 00 00       	jmp    c01026ec <__alltraps>

c0101d32 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101d32:	6a 00                	push   $0x0
  pushl $22
c0101d34:	6a 16                	push   $0x16
  jmp __alltraps
c0101d36:	e9 b1 09 00 00       	jmp    c01026ec <__alltraps>

c0101d3b <vector23>:
.globl vector23
vector23:
  pushl $0
c0101d3b:	6a 00                	push   $0x0
  pushl $23
c0101d3d:	6a 17                	push   $0x17
  jmp __alltraps
c0101d3f:	e9 a8 09 00 00       	jmp    c01026ec <__alltraps>

c0101d44 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101d44:	6a 00                	push   $0x0
  pushl $24
c0101d46:	6a 18                	push   $0x18
  jmp __alltraps
c0101d48:	e9 9f 09 00 00       	jmp    c01026ec <__alltraps>

c0101d4d <vector25>:
.globl vector25
vector25:
  pushl $0
c0101d4d:	6a 00                	push   $0x0
  pushl $25
c0101d4f:	6a 19                	push   $0x19
  jmp __alltraps
c0101d51:	e9 96 09 00 00       	jmp    c01026ec <__alltraps>

c0101d56 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101d56:	6a 00                	push   $0x0
  pushl $26
c0101d58:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101d5a:	e9 8d 09 00 00       	jmp    c01026ec <__alltraps>

c0101d5f <vector27>:
.globl vector27
vector27:
  pushl $0
c0101d5f:	6a 00                	push   $0x0
  pushl $27
c0101d61:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101d63:	e9 84 09 00 00       	jmp    c01026ec <__alltraps>

c0101d68 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101d68:	6a 00                	push   $0x0
  pushl $28
c0101d6a:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101d6c:	e9 7b 09 00 00       	jmp    c01026ec <__alltraps>

c0101d71 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101d71:	6a 00                	push   $0x0
  pushl $29
c0101d73:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101d75:	e9 72 09 00 00       	jmp    c01026ec <__alltraps>

c0101d7a <vector30>:
.globl vector30
vector30:
  pushl $0
c0101d7a:	6a 00                	push   $0x0
  pushl $30
c0101d7c:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101d7e:	e9 69 09 00 00       	jmp    c01026ec <__alltraps>

c0101d83 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101d83:	6a 00                	push   $0x0
  pushl $31
c0101d85:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101d87:	e9 60 09 00 00       	jmp    c01026ec <__alltraps>

c0101d8c <vector32>:
.globl vector32
vector32:
  pushl $0
c0101d8c:	6a 00                	push   $0x0
  pushl $32
c0101d8e:	6a 20                	push   $0x20
  jmp __alltraps
c0101d90:	e9 57 09 00 00       	jmp    c01026ec <__alltraps>

c0101d95 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101d95:	6a 00                	push   $0x0
  pushl $33
c0101d97:	6a 21                	push   $0x21
  jmp __alltraps
c0101d99:	e9 4e 09 00 00       	jmp    c01026ec <__alltraps>

c0101d9e <vector34>:
.globl vector34
vector34:
  pushl $0
c0101d9e:	6a 00                	push   $0x0
  pushl $34
c0101da0:	6a 22                	push   $0x22
  jmp __alltraps
c0101da2:	e9 45 09 00 00       	jmp    c01026ec <__alltraps>

c0101da7 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101da7:	6a 00                	push   $0x0
  pushl $35
c0101da9:	6a 23                	push   $0x23
  jmp __alltraps
c0101dab:	e9 3c 09 00 00       	jmp    c01026ec <__alltraps>

c0101db0 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101db0:	6a 00                	push   $0x0
  pushl $36
c0101db2:	6a 24                	push   $0x24
  jmp __alltraps
c0101db4:	e9 33 09 00 00       	jmp    c01026ec <__alltraps>

c0101db9 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101db9:	6a 00                	push   $0x0
  pushl $37
c0101dbb:	6a 25                	push   $0x25
  jmp __alltraps
c0101dbd:	e9 2a 09 00 00       	jmp    c01026ec <__alltraps>

c0101dc2 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101dc2:	6a 00                	push   $0x0
  pushl $38
c0101dc4:	6a 26                	push   $0x26
  jmp __alltraps
c0101dc6:	e9 21 09 00 00       	jmp    c01026ec <__alltraps>

c0101dcb <vector39>:
.globl vector39
vector39:
  pushl $0
c0101dcb:	6a 00                	push   $0x0
  pushl $39
c0101dcd:	6a 27                	push   $0x27
  jmp __alltraps
c0101dcf:	e9 18 09 00 00       	jmp    c01026ec <__alltraps>

c0101dd4 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101dd4:	6a 00                	push   $0x0
  pushl $40
c0101dd6:	6a 28                	push   $0x28
  jmp __alltraps
c0101dd8:	e9 0f 09 00 00       	jmp    c01026ec <__alltraps>

c0101ddd <vector41>:
.globl vector41
vector41:
  pushl $0
c0101ddd:	6a 00                	push   $0x0
  pushl $41
c0101ddf:	6a 29                	push   $0x29
  jmp __alltraps
c0101de1:	e9 06 09 00 00       	jmp    c01026ec <__alltraps>

c0101de6 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101de6:	6a 00                	push   $0x0
  pushl $42
c0101de8:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101dea:	e9 fd 08 00 00       	jmp    c01026ec <__alltraps>

c0101def <vector43>:
.globl vector43
vector43:
  pushl $0
c0101def:	6a 00                	push   $0x0
  pushl $43
c0101df1:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101df3:	e9 f4 08 00 00       	jmp    c01026ec <__alltraps>

c0101df8 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101df8:	6a 00                	push   $0x0
  pushl $44
c0101dfa:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101dfc:	e9 eb 08 00 00       	jmp    c01026ec <__alltraps>

c0101e01 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101e01:	6a 00                	push   $0x0
  pushl $45
c0101e03:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101e05:	e9 e2 08 00 00       	jmp    c01026ec <__alltraps>

c0101e0a <vector46>:
.globl vector46
vector46:
  pushl $0
c0101e0a:	6a 00                	push   $0x0
  pushl $46
c0101e0c:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101e0e:	e9 d9 08 00 00       	jmp    c01026ec <__alltraps>

c0101e13 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101e13:	6a 00                	push   $0x0
  pushl $47
c0101e15:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101e17:	e9 d0 08 00 00       	jmp    c01026ec <__alltraps>

c0101e1c <vector48>:
.globl vector48
vector48:
  pushl $0
c0101e1c:	6a 00                	push   $0x0
  pushl $48
c0101e1e:	6a 30                	push   $0x30
  jmp __alltraps
c0101e20:	e9 c7 08 00 00       	jmp    c01026ec <__alltraps>

c0101e25 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101e25:	6a 00                	push   $0x0
  pushl $49
c0101e27:	6a 31                	push   $0x31
  jmp __alltraps
c0101e29:	e9 be 08 00 00       	jmp    c01026ec <__alltraps>

c0101e2e <vector50>:
.globl vector50
vector50:
  pushl $0
c0101e2e:	6a 00                	push   $0x0
  pushl $50
c0101e30:	6a 32                	push   $0x32
  jmp __alltraps
c0101e32:	e9 b5 08 00 00       	jmp    c01026ec <__alltraps>

c0101e37 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101e37:	6a 00                	push   $0x0
  pushl $51
c0101e39:	6a 33                	push   $0x33
  jmp __alltraps
c0101e3b:	e9 ac 08 00 00       	jmp    c01026ec <__alltraps>

c0101e40 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101e40:	6a 00                	push   $0x0
  pushl $52
c0101e42:	6a 34                	push   $0x34
  jmp __alltraps
c0101e44:	e9 a3 08 00 00       	jmp    c01026ec <__alltraps>

c0101e49 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101e49:	6a 00                	push   $0x0
  pushl $53
c0101e4b:	6a 35                	push   $0x35
  jmp __alltraps
c0101e4d:	e9 9a 08 00 00       	jmp    c01026ec <__alltraps>

c0101e52 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101e52:	6a 00                	push   $0x0
  pushl $54
c0101e54:	6a 36                	push   $0x36
  jmp __alltraps
c0101e56:	e9 91 08 00 00       	jmp    c01026ec <__alltraps>

c0101e5b <vector55>:
.globl vector55
vector55:
  pushl $0
c0101e5b:	6a 00                	push   $0x0
  pushl $55
c0101e5d:	6a 37                	push   $0x37
  jmp __alltraps
c0101e5f:	e9 88 08 00 00       	jmp    c01026ec <__alltraps>

c0101e64 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101e64:	6a 00                	push   $0x0
  pushl $56
c0101e66:	6a 38                	push   $0x38
  jmp __alltraps
c0101e68:	e9 7f 08 00 00       	jmp    c01026ec <__alltraps>

c0101e6d <vector57>:
.globl vector57
vector57:
  pushl $0
c0101e6d:	6a 00                	push   $0x0
  pushl $57
c0101e6f:	6a 39                	push   $0x39
  jmp __alltraps
c0101e71:	e9 76 08 00 00       	jmp    c01026ec <__alltraps>

c0101e76 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101e76:	6a 00                	push   $0x0
  pushl $58
c0101e78:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101e7a:	e9 6d 08 00 00       	jmp    c01026ec <__alltraps>

c0101e7f <vector59>:
.globl vector59
vector59:
  pushl $0
c0101e7f:	6a 00                	push   $0x0
  pushl $59
c0101e81:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101e83:	e9 64 08 00 00       	jmp    c01026ec <__alltraps>

c0101e88 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101e88:	6a 00                	push   $0x0
  pushl $60
c0101e8a:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101e8c:	e9 5b 08 00 00       	jmp    c01026ec <__alltraps>

c0101e91 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101e91:	6a 00                	push   $0x0
  pushl $61
c0101e93:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101e95:	e9 52 08 00 00       	jmp    c01026ec <__alltraps>

c0101e9a <vector62>:
.globl vector62
vector62:
  pushl $0
c0101e9a:	6a 00                	push   $0x0
  pushl $62
c0101e9c:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101e9e:	e9 49 08 00 00       	jmp    c01026ec <__alltraps>

c0101ea3 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101ea3:	6a 00                	push   $0x0
  pushl $63
c0101ea5:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101ea7:	e9 40 08 00 00       	jmp    c01026ec <__alltraps>

c0101eac <vector64>:
.globl vector64
vector64:
  pushl $0
c0101eac:	6a 00                	push   $0x0
  pushl $64
c0101eae:	6a 40                	push   $0x40
  jmp __alltraps
c0101eb0:	e9 37 08 00 00       	jmp    c01026ec <__alltraps>

c0101eb5 <vector65>:
.globl vector65
vector65:
  pushl $0
c0101eb5:	6a 00                	push   $0x0
  pushl $65
c0101eb7:	6a 41                	push   $0x41
  jmp __alltraps
c0101eb9:	e9 2e 08 00 00       	jmp    c01026ec <__alltraps>

c0101ebe <vector66>:
.globl vector66
vector66:
  pushl $0
c0101ebe:	6a 00                	push   $0x0
  pushl $66
c0101ec0:	6a 42                	push   $0x42
  jmp __alltraps
c0101ec2:	e9 25 08 00 00       	jmp    c01026ec <__alltraps>

c0101ec7 <vector67>:
.globl vector67
vector67:
  pushl $0
c0101ec7:	6a 00                	push   $0x0
  pushl $67
c0101ec9:	6a 43                	push   $0x43
  jmp __alltraps
c0101ecb:	e9 1c 08 00 00       	jmp    c01026ec <__alltraps>

c0101ed0 <vector68>:
.globl vector68
vector68:
  pushl $0
c0101ed0:	6a 00                	push   $0x0
  pushl $68
c0101ed2:	6a 44                	push   $0x44
  jmp __alltraps
c0101ed4:	e9 13 08 00 00       	jmp    c01026ec <__alltraps>

c0101ed9 <vector69>:
.globl vector69
vector69:
  pushl $0
c0101ed9:	6a 00                	push   $0x0
  pushl $69
c0101edb:	6a 45                	push   $0x45
  jmp __alltraps
c0101edd:	e9 0a 08 00 00       	jmp    c01026ec <__alltraps>

c0101ee2 <vector70>:
.globl vector70
vector70:
  pushl $0
c0101ee2:	6a 00                	push   $0x0
  pushl $70
c0101ee4:	6a 46                	push   $0x46
  jmp __alltraps
c0101ee6:	e9 01 08 00 00       	jmp    c01026ec <__alltraps>

c0101eeb <vector71>:
.globl vector71
vector71:
  pushl $0
c0101eeb:	6a 00                	push   $0x0
  pushl $71
c0101eed:	6a 47                	push   $0x47
  jmp __alltraps
c0101eef:	e9 f8 07 00 00       	jmp    c01026ec <__alltraps>

c0101ef4 <vector72>:
.globl vector72
vector72:
  pushl $0
c0101ef4:	6a 00                	push   $0x0
  pushl $72
c0101ef6:	6a 48                	push   $0x48
  jmp __alltraps
c0101ef8:	e9 ef 07 00 00       	jmp    c01026ec <__alltraps>

c0101efd <vector73>:
.globl vector73
vector73:
  pushl $0
c0101efd:	6a 00                	push   $0x0
  pushl $73
c0101eff:	6a 49                	push   $0x49
  jmp __alltraps
c0101f01:	e9 e6 07 00 00       	jmp    c01026ec <__alltraps>

c0101f06 <vector74>:
.globl vector74
vector74:
  pushl $0
c0101f06:	6a 00                	push   $0x0
  pushl $74
c0101f08:	6a 4a                	push   $0x4a
  jmp __alltraps
c0101f0a:	e9 dd 07 00 00       	jmp    c01026ec <__alltraps>

c0101f0f <vector75>:
.globl vector75
vector75:
  pushl $0
c0101f0f:	6a 00                	push   $0x0
  pushl $75
c0101f11:	6a 4b                	push   $0x4b
  jmp __alltraps
c0101f13:	e9 d4 07 00 00       	jmp    c01026ec <__alltraps>

c0101f18 <vector76>:
.globl vector76
vector76:
  pushl $0
c0101f18:	6a 00                	push   $0x0
  pushl $76
c0101f1a:	6a 4c                	push   $0x4c
  jmp __alltraps
c0101f1c:	e9 cb 07 00 00       	jmp    c01026ec <__alltraps>

c0101f21 <vector77>:
.globl vector77
vector77:
  pushl $0
c0101f21:	6a 00                	push   $0x0
  pushl $77
c0101f23:	6a 4d                	push   $0x4d
  jmp __alltraps
c0101f25:	e9 c2 07 00 00       	jmp    c01026ec <__alltraps>

c0101f2a <vector78>:
.globl vector78
vector78:
  pushl $0
c0101f2a:	6a 00                	push   $0x0
  pushl $78
c0101f2c:	6a 4e                	push   $0x4e
  jmp __alltraps
c0101f2e:	e9 b9 07 00 00       	jmp    c01026ec <__alltraps>

c0101f33 <vector79>:
.globl vector79
vector79:
  pushl $0
c0101f33:	6a 00                	push   $0x0
  pushl $79
c0101f35:	6a 4f                	push   $0x4f
  jmp __alltraps
c0101f37:	e9 b0 07 00 00       	jmp    c01026ec <__alltraps>

c0101f3c <vector80>:
.globl vector80
vector80:
  pushl $0
c0101f3c:	6a 00                	push   $0x0
  pushl $80
c0101f3e:	6a 50                	push   $0x50
  jmp __alltraps
c0101f40:	e9 a7 07 00 00       	jmp    c01026ec <__alltraps>

c0101f45 <vector81>:
.globl vector81
vector81:
  pushl $0
c0101f45:	6a 00                	push   $0x0
  pushl $81
c0101f47:	6a 51                	push   $0x51
  jmp __alltraps
c0101f49:	e9 9e 07 00 00       	jmp    c01026ec <__alltraps>

c0101f4e <vector82>:
.globl vector82
vector82:
  pushl $0
c0101f4e:	6a 00                	push   $0x0
  pushl $82
c0101f50:	6a 52                	push   $0x52
  jmp __alltraps
c0101f52:	e9 95 07 00 00       	jmp    c01026ec <__alltraps>

c0101f57 <vector83>:
.globl vector83
vector83:
  pushl $0
c0101f57:	6a 00                	push   $0x0
  pushl $83
c0101f59:	6a 53                	push   $0x53
  jmp __alltraps
c0101f5b:	e9 8c 07 00 00       	jmp    c01026ec <__alltraps>

c0101f60 <vector84>:
.globl vector84
vector84:
  pushl $0
c0101f60:	6a 00                	push   $0x0
  pushl $84
c0101f62:	6a 54                	push   $0x54
  jmp __alltraps
c0101f64:	e9 83 07 00 00       	jmp    c01026ec <__alltraps>

c0101f69 <vector85>:
.globl vector85
vector85:
  pushl $0
c0101f69:	6a 00                	push   $0x0
  pushl $85
c0101f6b:	6a 55                	push   $0x55
  jmp __alltraps
c0101f6d:	e9 7a 07 00 00       	jmp    c01026ec <__alltraps>

c0101f72 <vector86>:
.globl vector86
vector86:
  pushl $0
c0101f72:	6a 00                	push   $0x0
  pushl $86
c0101f74:	6a 56                	push   $0x56
  jmp __alltraps
c0101f76:	e9 71 07 00 00       	jmp    c01026ec <__alltraps>

c0101f7b <vector87>:
.globl vector87
vector87:
  pushl $0
c0101f7b:	6a 00                	push   $0x0
  pushl $87
c0101f7d:	6a 57                	push   $0x57
  jmp __alltraps
c0101f7f:	e9 68 07 00 00       	jmp    c01026ec <__alltraps>

c0101f84 <vector88>:
.globl vector88
vector88:
  pushl $0
c0101f84:	6a 00                	push   $0x0
  pushl $88
c0101f86:	6a 58                	push   $0x58
  jmp __alltraps
c0101f88:	e9 5f 07 00 00       	jmp    c01026ec <__alltraps>

c0101f8d <vector89>:
.globl vector89
vector89:
  pushl $0
c0101f8d:	6a 00                	push   $0x0
  pushl $89
c0101f8f:	6a 59                	push   $0x59
  jmp __alltraps
c0101f91:	e9 56 07 00 00       	jmp    c01026ec <__alltraps>

c0101f96 <vector90>:
.globl vector90
vector90:
  pushl $0
c0101f96:	6a 00                	push   $0x0
  pushl $90
c0101f98:	6a 5a                	push   $0x5a
  jmp __alltraps
c0101f9a:	e9 4d 07 00 00       	jmp    c01026ec <__alltraps>

c0101f9f <vector91>:
.globl vector91
vector91:
  pushl $0
c0101f9f:	6a 00                	push   $0x0
  pushl $91
c0101fa1:	6a 5b                	push   $0x5b
  jmp __alltraps
c0101fa3:	e9 44 07 00 00       	jmp    c01026ec <__alltraps>

c0101fa8 <vector92>:
.globl vector92
vector92:
  pushl $0
c0101fa8:	6a 00                	push   $0x0
  pushl $92
c0101faa:	6a 5c                	push   $0x5c
  jmp __alltraps
c0101fac:	e9 3b 07 00 00       	jmp    c01026ec <__alltraps>

c0101fb1 <vector93>:
.globl vector93
vector93:
  pushl $0
c0101fb1:	6a 00                	push   $0x0
  pushl $93
c0101fb3:	6a 5d                	push   $0x5d
  jmp __alltraps
c0101fb5:	e9 32 07 00 00       	jmp    c01026ec <__alltraps>

c0101fba <vector94>:
.globl vector94
vector94:
  pushl $0
c0101fba:	6a 00                	push   $0x0
  pushl $94
c0101fbc:	6a 5e                	push   $0x5e
  jmp __alltraps
c0101fbe:	e9 29 07 00 00       	jmp    c01026ec <__alltraps>

c0101fc3 <vector95>:
.globl vector95
vector95:
  pushl $0
c0101fc3:	6a 00                	push   $0x0
  pushl $95
c0101fc5:	6a 5f                	push   $0x5f
  jmp __alltraps
c0101fc7:	e9 20 07 00 00       	jmp    c01026ec <__alltraps>

c0101fcc <vector96>:
.globl vector96
vector96:
  pushl $0
c0101fcc:	6a 00                	push   $0x0
  pushl $96
c0101fce:	6a 60                	push   $0x60
  jmp __alltraps
c0101fd0:	e9 17 07 00 00       	jmp    c01026ec <__alltraps>

c0101fd5 <vector97>:
.globl vector97
vector97:
  pushl $0
c0101fd5:	6a 00                	push   $0x0
  pushl $97
c0101fd7:	6a 61                	push   $0x61
  jmp __alltraps
c0101fd9:	e9 0e 07 00 00       	jmp    c01026ec <__alltraps>

c0101fde <vector98>:
.globl vector98
vector98:
  pushl $0
c0101fde:	6a 00                	push   $0x0
  pushl $98
c0101fe0:	6a 62                	push   $0x62
  jmp __alltraps
c0101fe2:	e9 05 07 00 00       	jmp    c01026ec <__alltraps>

c0101fe7 <vector99>:
.globl vector99
vector99:
  pushl $0
c0101fe7:	6a 00                	push   $0x0
  pushl $99
c0101fe9:	6a 63                	push   $0x63
  jmp __alltraps
c0101feb:	e9 fc 06 00 00       	jmp    c01026ec <__alltraps>

c0101ff0 <vector100>:
.globl vector100
vector100:
  pushl $0
c0101ff0:	6a 00                	push   $0x0
  pushl $100
c0101ff2:	6a 64                	push   $0x64
  jmp __alltraps
c0101ff4:	e9 f3 06 00 00       	jmp    c01026ec <__alltraps>

c0101ff9 <vector101>:
.globl vector101
vector101:
  pushl $0
c0101ff9:	6a 00                	push   $0x0
  pushl $101
c0101ffb:	6a 65                	push   $0x65
  jmp __alltraps
c0101ffd:	e9 ea 06 00 00       	jmp    c01026ec <__alltraps>

c0102002 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102002:	6a 00                	push   $0x0
  pushl $102
c0102004:	6a 66                	push   $0x66
  jmp __alltraps
c0102006:	e9 e1 06 00 00       	jmp    c01026ec <__alltraps>

c010200b <vector103>:
.globl vector103
vector103:
  pushl $0
c010200b:	6a 00                	push   $0x0
  pushl $103
c010200d:	6a 67                	push   $0x67
  jmp __alltraps
c010200f:	e9 d8 06 00 00       	jmp    c01026ec <__alltraps>

c0102014 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102014:	6a 00                	push   $0x0
  pushl $104
c0102016:	6a 68                	push   $0x68
  jmp __alltraps
c0102018:	e9 cf 06 00 00       	jmp    c01026ec <__alltraps>

c010201d <vector105>:
.globl vector105
vector105:
  pushl $0
c010201d:	6a 00                	push   $0x0
  pushl $105
c010201f:	6a 69                	push   $0x69
  jmp __alltraps
c0102021:	e9 c6 06 00 00       	jmp    c01026ec <__alltraps>

c0102026 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102026:	6a 00                	push   $0x0
  pushl $106
c0102028:	6a 6a                	push   $0x6a
  jmp __alltraps
c010202a:	e9 bd 06 00 00       	jmp    c01026ec <__alltraps>

c010202f <vector107>:
.globl vector107
vector107:
  pushl $0
c010202f:	6a 00                	push   $0x0
  pushl $107
c0102031:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102033:	e9 b4 06 00 00       	jmp    c01026ec <__alltraps>

c0102038 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102038:	6a 00                	push   $0x0
  pushl $108
c010203a:	6a 6c                	push   $0x6c
  jmp __alltraps
c010203c:	e9 ab 06 00 00       	jmp    c01026ec <__alltraps>

c0102041 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102041:	6a 00                	push   $0x0
  pushl $109
c0102043:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102045:	e9 a2 06 00 00       	jmp    c01026ec <__alltraps>

c010204a <vector110>:
.globl vector110
vector110:
  pushl $0
c010204a:	6a 00                	push   $0x0
  pushl $110
c010204c:	6a 6e                	push   $0x6e
  jmp __alltraps
c010204e:	e9 99 06 00 00       	jmp    c01026ec <__alltraps>

c0102053 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102053:	6a 00                	push   $0x0
  pushl $111
c0102055:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102057:	e9 90 06 00 00       	jmp    c01026ec <__alltraps>

c010205c <vector112>:
.globl vector112
vector112:
  pushl $0
c010205c:	6a 00                	push   $0x0
  pushl $112
c010205e:	6a 70                	push   $0x70
  jmp __alltraps
c0102060:	e9 87 06 00 00       	jmp    c01026ec <__alltraps>

c0102065 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102065:	6a 00                	push   $0x0
  pushl $113
c0102067:	6a 71                	push   $0x71
  jmp __alltraps
c0102069:	e9 7e 06 00 00       	jmp    c01026ec <__alltraps>

c010206e <vector114>:
.globl vector114
vector114:
  pushl $0
c010206e:	6a 00                	push   $0x0
  pushl $114
c0102070:	6a 72                	push   $0x72
  jmp __alltraps
c0102072:	e9 75 06 00 00       	jmp    c01026ec <__alltraps>

c0102077 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102077:	6a 00                	push   $0x0
  pushl $115
c0102079:	6a 73                	push   $0x73
  jmp __alltraps
c010207b:	e9 6c 06 00 00       	jmp    c01026ec <__alltraps>

c0102080 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102080:	6a 00                	push   $0x0
  pushl $116
c0102082:	6a 74                	push   $0x74
  jmp __alltraps
c0102084:	e9 63 06 00 00       	jmp    c01026ec <__alltraps>

c0102089 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102089:	6a 00                	push   $0x0
  pushl $117
c010208b:	6a 75                	push   $0x75
  jmp __alltraps
c010208d:	e9 5a 06 00 00       	jmp    c01026ec <__alltraps>

c0102092 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102092:	6a 00                	push   $0x0
  pushl $118
c0102094:	6a 76                	push   $0x76
  jmp __alltraps
c0102096:	e9 51 06 00 00       	jmp    c01026ec <__alltraps>

c010209b <vector119>:
.globl vector119
vector119:
  pushl $0
c010209b:	6a 00                	push   $0x0
  pushl $119
c010209d:	6a 77                	push   $0x77
  jmp __alltraps
c010209f:	e9 48 06 00 00       	jmp    c01026ec <__alltraps>

c01020a4 <vector120>:
.globl vector120
vector120:
  pushl $0
c01020a4:	6a 00                	push   $0x0
  pushl $120
c01020a6:	6a 78                	push   $0x78
  jmp __alltraps
c01020a8:	e9 3f 06 00 00       	jmp    c01026ec <__alltraps>

c01020ad <vector121>:
.globl vector121
vector121:
  pushl $0
c01020ad:	6a 00                	push   $0x0
  pushl $121
c01020af:	6a 79                	push   $0x79
  jmp __alltraps
c01020b1:	e9 36 06 00 00       	jmp    c01026ec <__alltraps>

c01020b6 <vector122>:
.globl vector122
vector122:
  pushl $0
c01020b6:	6a 00                	push   $0x0
  pushl $122
c01020b8:	6a 7a                	push   $0x7a
  jmp __alltraps
c01020ba:	e9 2d 06 00 00       	jmp    c01026ec <__alltraps>

c01020bf <vector123>:
.globl vector123
vector123:
  pushl $0
c01020bf:	6a 00                	push   $0x0
  pushl $123
c01020c1:	6a 7b                	push   $0x7b
  jmp __alltraps
c01020c3:	e9 24 06 00 00       	jmp    c01026ec <__alltraps>

c01020c8 <vector124>:
.globl vector124
vector124:
  pushl $0
c01020c8:	6a 00                	push   $0x0
  pushl $124
c01020ca:	6a 7c                	push   $0x7c
  jmp __alltraps
c01020cc:	e9 1b 06 00 00       	jmp    c01026ec <__alltraps>

c01020d1 <vector125>:
.globl vector125
vector125:
  pushl $0
c01020d1:	6a 00                	push   $0x0
  pushl $125
c01020d3:	6a 7d                	push   $0x7d
  jmp __alltraps
c01020d5:	e9 12 06 00 00       	jmp    c01026ec <__alltraps>

c01020da <vector126>:
.globl vector126
vector126:
  pushl $0
c01020da:	6a 00                	push   $0x0
  pushl $126
c01020dc:	6a 7e                	push   $0x7e
  jmp __alltraps
c01020de:	e9 09 06 00 00       	jmp    c01026ec <__alltraps>

c01020e3 <vector127>:
.globl vector127
vector127:
  pushl $0
c01020e3:	6a 00                	push   $0x0
  pushl $127
c01020e5:	6a 7f                	push   $0x7f
  jmp __alltraps
c01020e7:	e9 00 06 00 00       	jmp    c01026ec <__alltraps>

c01020ec <vector128>:
.globl vector128
vector128:
  pushl $0
c01020ec:	6a 00                	push   $0x0
  pushl $128
c01020ee:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01020f3:	e9 f4 05 00 00       	jmp    c01026ec <__alltraps>

c01020f8 <vector129>:
.globl vector129
vector129:
  pushl $0
c01020f8:	6a 00                	push   $0x0
  pushl $129
c01020fa:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01020ff:	e9 e8 05 00 00       	jmp    c01026ec <__alltraps>

c0102104 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102104:	6a 00                	push   $0x0
  pushl $130
c0102106:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010210b:	e9 dc 05 00 00       	jmp    c01026ec <__alltraps>

c0102110 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102110:	6a 00                	push   $0x0
  pushl $131
c0102112:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102117:	e9 d0 05 00 00       	jmp    c01026ec <__alltraps>

c010211c <vector132>:
.globl vector132
vector132:
  pushl $0
c010211c:	6a 00                	push   $0x0
  pushl $132
c010211e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102123:	e9 c4 05 00 00       	jmp    c01026ec <__alltraps>

c0102128 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102128:	6a 00                	push   $0x0
  pushl $133
c010212a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c010212f:	e9 b8 05 00 00       	jmp    c01026ec <__alltraps>

c0102134 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102134:	6a 00                	push   $0x0
  pushl $134
c0102136:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010213b:	e9 ac 05 00 00       	jmp    c01026ec <__alltraps>

c0102140 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102140:	6a 00                	push   $0x0
  pushl $135
c0102142:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102147:	e9 a0 05 00 00       	jmp    c01026ec <__alltraps>

c010214c <vector136>:
.globl vector136
vector136:
  pushl $0
c010214c:	6a 00                	push   $0x0
  pushl $136
c010214e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102153:	e9 94 05 00 00       	jmp    c01026ec <__alltraps>

c0102158 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102158:	6a 00                	push   $0x0
  pushl $137
c010215a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010215f:	e9 88 05 00 00       	jmp    c01026ec <__alltraps>

c0102164 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102164:	6a 00                	push   $0x0
  pushl $138
c0102166:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010216b:	e9 7c 05 00 00       	jmp    c01026ec <__alltraps>

c0102170 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102170:	6a 00                	push   $0x0
  pushl $139
c0102172:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102177:	e9 70 05 00 00       	jmp    c01026ec <__alltraps>

c010217c <vector140>:
.globl vector140
vector140:
  pushl $0
c010217c:	6a 00                	push   $0x0
  pushl $140
c010217e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102183:	e9 64 05 00 00       	jmp    c01026ec <__alltraps>

c0102188 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102188:	6a 00                	push   $0x0
  pushl $141
c010218a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010218f:	e9 58 05 00 00       	jmp    c01026ec <__alltraps>

c0102194 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102194:	6a 00                	push   $0x0
  pushl $142
c0102196:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010219b:	e9 4c 05 00 00       	jmp    c01026ec <__alltraps>

c01021a0 <vector143>:
.globl vector143
vector143:
  pushl $0
c01021a0:	6a 00                	push   $0x0
  pushl $143
c01021a2:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01021a7:	e9 40 05 00 00       	jmp    c01026ec <__alltraps>

c01021ac <vector144>:
.globl vector144
vector144:
  pushl $0
c01021ac:	6a 00                	push   $0x0
  pushl $144
c01021ae:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01021b3:	e9 34 05 00 00       	jmp    c01026ec <__alltraps>

c01021b8 <vector145>:
.globl vector145
vector145:
  pushl $0
c01021b8:	6a 00                	push   $0x0
  pushl $145
c01021ba:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01021bf:	e9 28 05 00 00       	jmp    c01026ec <__alltraps>

c01021c4 <vector146>:
.globl vector146
vector146:
  pushl $0
c01021c4:	6a 00                	push   $0x0
  pushl $146
c01021c6:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01021cb:	e9 1c 05 00 00       	jmp    c01026ec <__alltraps>

c01021d0 <vector147>:
.globl vector147
vector147:
  pushl $0
c01021d0:	6a 00                	push   $0x0
  pushl $147
c01021d2:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01021d7:	e9 10 05 00 00       	jmp    c01026ec <__alltraps>

c01021dc <vector148>:
.globl vector148
vector148:
  pushl $0
c01021dc:	6a 00                	push   $0x0
  pushl $148
c01021de:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01021e3:	e9 04 05 00 00       	jmp    c01026ec <__alltraps>

c01021e8 <vector149>:
.globl vector149
vector149:
  pushl $0
c01021e8:	6a 00                	push   $0x0
  pushl $149
c01021ea:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01021ef:	e9 f8 04 00 00       	jmp    c01026ec <__alltraps>

c01021f4 <vector150>:
.globl vector150
vector150:
  pushl $0
c01021f4:	6a 00                	push   $0x0
  pushl $150
c01021f6:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01021fb:	e9 ec 04 00 00       	jmp    c01026ec <__alltraps>

c0102200 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102200:	6a 00                	push   $0x0
  pushl $151
c0102202:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102207:	e9 e0 04 00 00       	jmp    c01026ec <__alltraps>

c010220c <vector152>:
.globl vector152
vector152:
  pushl $0
c010220c:	6a 00                	push   $0x0
  pushl $152
c010220e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102213:	e9 d4 04 00 00       	jmp    c01026ec <__alltraps>

c0102218 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102218:	6a 00                	push   $0x0
  pushl $153
c010221a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c010221f:	e9 c8 04 00 00       	jmp    c01026ec <__alltraps>

c0102224 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102224:	6a 00                	push   $0x0
  pushl $154
c0102226:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010222b:	e9 bc 04 00 00       	jmp    c01026ec <__alltraps>

c0102230 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102230:	6a 00                	push   $0x0
  pushl $155
c0102232:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102237:	e9 b0 04 00 00       	jmp    c01026ec <__alltraps>

c010223c <vector156>:
.globl vector156
vector156:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $156
c010223e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102243:	e9 a4 04 00 00       	jmp    c01026ec <__alltraps>

c0102248 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102248:	6a 00                	push   $0x0
  pushl $157
c010224a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010224f:	e9 98 04 00 00       	jmp    c01026ec <__alltraps>

c0102254 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102254:	6a 00                	push   $0x0
  pushl $158
c0102256:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010225b:	e9 8c 04 00 00       	jmp    c01026ec <__alltraps>

c0102260 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $159
c0102262:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102267:	e9 80 04 00 00       	jmp    c01026ec <__alltraps>

c010226c <vector160>:
.globl vector160
vector160:
  pushl $0
c010226c:	6a 00                	push   $0x0
  pushl $160
c010226e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102273:	e9 74 04 00 00       	jmp    c01026ec <__alltraps>

c0102278 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102278:	6a 00                	push   $0x0
  pushl $161
c010227a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010227f:	e9 68 04 00 00       	jmp    c01026ec <__alltraps>

c0102284 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102284:	6a 00                	push   $0x0
  pushl $162
c0102286:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010228b:	e9 5c 04 00 00       	jmp    c01026ec <__alltraps>

c0102290 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102290:	6a 00                	push   $0x0
  pushl $163
c0102292:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102297:	e9 50 04 00 00       	jmp    c01026ec <__alltraps>

c010229c <vector164>:
.globl vector164
vector164:
  pushl $0
c010229c:	6a 00                	push   $0x0
  pushl $164
c010229e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01022a3:	e9 44 04 00 00       	jmp    c01026ec <__alltraps>

c01022a8 <vector165>:
.globl vector165
vector165:
  pushl $0
c01022a8:	6a 00                	push   $0x0
  pushl $165
c01022aa:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01022af:	e9 38 04 00 00       	jmp    c01026ec <__alltraps>

c01022b4 <vector166>:
.globl vector166
vector166:
  pushl $0
c01022b4:	6a 00                	push   $0x0
  pushl $166
c01022b6:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01022bb:	e9 2c 04 00 00       	jmp    c01026ec <__alltraps>

c01022c0 <vector167>:
.globl vector167
vector167:
  pushl $0
c01022c0:	6a 00                	push   $0x0
  pushl $167
c01022c2:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01022c7:	e9 20 04 00 00       	jmp    c01026ec <__alltraps>

c01022cc <vector168>:
.globl vector168
vector168:
  pushl $0
c01022cc:	6a 00                	push   $0x0
  pushl $168
c01022ce:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01022d3:	e9 14 04 00 00       	jmp    c01026ec <__alltraps>

c01022d8 <vector169>:
.globl vector169
vector169:
  pushl $0
c01022d8:	6a 00                	push   $0x0
  pushl $169
c01022da:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01022df:	e9 08 04 00 00       	jmp    c01026ec <__alltraps>

c01022e4 <vector170>:
.globl vector170
vector170:
  pushl $0
c01022e4:	6a 00                	push   $0x0
  pushl $170
c01022e6:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01022eb:	e9 fc 03 00 00       	jmp    c01026ec <__alltraps>

c01022f0 <vector171>:
.globl vector171
vector171:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $171
c01022f2:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01022f7:	e9 f0 03 00 00       	jmp    c01026ec <__alltraps>

c01022fc <vector172>:
.globl vector172
vector172:
  pushl $0
c01022fc:	6a 00                	push   $0x0
  pushl $172
c01022fe:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102303:	e9 e4 03 00 00       	jmp    c01026ec <__alltraps>

c0102308 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102308:	6a 00                	push   $0x0
  pushl $173
c010230a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c010230f:	e9 d8 03 00 00       	jmp    c01026ec <__alltraps>

c0102314 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $174
c0102316:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010231b:	e9 cc 03 00 00       	jmp    c01026ec <__alltraps>

c0102320 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102320:	6a 00                	push   $0x0
  pushl $175
c0102322:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102327:	e9 c0 03 00 00       	jmp    c01026ec <__alltraps>

c010232c <vector176>:
.globl vector176
vector176:
  pushl $0
c010232c:	6a 00                	push   $0x0
  pushl $176
c010232e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102333:	e9 b4 03 00 00       	jmp    c01026ec <__alltraps>

c0102338 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102338:	6a 00                	push   $0x0
  pushl $177
c010233a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010233f:	e9 a8 03 00 00       	jmp    c01026ec <__alltraps>

c0102344 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102344:	6a 00                	push   $0x0
  pushl $178
c0102346:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010234b:	e9 9c 03 00 00       	jmp    c01026ec <__alltraps>

c0102350 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102350:	6a 00                	push   $0x0
  pushl $179
c0102352:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102357:	e9 90 03 00 00       	jmp    c01026ec <__alltraps>

c010235c <vector180>:
.globl vector180
vector180:
  pushl $0
c010235c:	6a 00                	push   $0x0
  pushl $180
c010235e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102363:	e9 84 03 00 00       	jmp    c01026ec <__alltraps>

c0102368 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102368:	6a 00                	push   $0x0
  pushl $181
c010236a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010236f:	e9 78 03 00 00       	jmp    c01026ec <__alltraps>

c0102374 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102374:	6a 00                	push   $0x0
  pushl $182
c0102376:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010237b:	e9 6c 03 00 00       	jmp    c01026ec <__alltraps>

c0102380 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102380:	6a 00                	push   $0x0
  pushl $183
c0102382:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102387:	e9 60 03 00 00       	jmp    c01026ec <__alltraps>

c010238c <vector184>:
.globl vector184
vector184:
  pushl $0
c010238c:	6a 00                	push   $0x0
  pushl $184
c010238e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102393:	e9 54 03 00 00       	jmp    c01026ec <__alltraps>

c0102398 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102398:	6a 00                	push   $0x0
  pushl $185
c010239a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010239f:	e9 48 03 00 00       	jmp    c01026ec <__alltraps>

c01023a4 <vector186>:
.globl vector186
vector186:
  pushl $0
c01023a4:	6a 00                	push   $0x0
  pushl $186
c01023a6:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01023ab:	e9 3c 03 00 00       	jmp    c01026ec <__alltraps>

c01023b0 <vector187>:
.globl vector187
vector187:
  pushl $0
c01023b0:	6a 00                	push   $0x0
  pushl $187
c01023b2:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01023b7:	e9 30 03 00 00       	jmp    c01026ec <__alltraps>

c01023bc <vector188>:
.globl vector188
vector188:
  pushl $0
c01023bc:	6a 00                	push   $0x0
  pushl $188
c01023be:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01023c3:	e9 24 03 00 00       	jmp    c01026ec <__alltraps>

c01023c8 <vector189>:
.globl vector189
vector189:
  pushl $0
c01023c8:	6a 00                	push   $0x0
  pushl $189
c01023ca:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01023cf:	e9 18 03 00 00       	jmp    c01026ec <__alltraps>

c01023d4 <vector190>:
.globl vector190
vector190:
  pushl $0
c01023d4:	6a 00                	push   $0x0
  pushl $190
c01023d6:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01023db:	e9 0c 03 00 00       	jmp    c01026ec <__alltraps>

c01023e0 <vector191>:
.globl vector191
vector191:
  pushl $0
c01023e0:	6a 00                	push   $0x0
  pushl $191
c01023e2:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01023e7:	e9 00 03 00 00       	jmp    c01026ec <__alltraps>

c01023ec <vector192>:
.globl vector192
vector192:
  pushl $0
c01023ec:	6a 00                	push   $0x0
  pushl $192
c01023ee:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01023f3:	e9 f4 02 00 00       	jmp    c01026ec <__alltraps>

c01023f8 <vector193>:
.globl vector193
vector193:
  pushl $0
c01023f8:	6a 00                	push   $0x0
  pushl $193
c01023fa:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01023ff:	e9 e8 02 00 00       	jmp    c01026ec <__alltraps>

c0102404 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102404:	6a 00                	push   $0x0
  pushl $194
c0102406:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010240b:	e9 dc 02 00 00       	jmp    c01026ec <__alltraps>

c0102410 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102410:	6a 00                	push   $0x0
  pushl $195
c0102412:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102417:	e9 d0 02 00 00       	jmp    c01026ec <__alltraps>

c010241c <vector196>:
.globl vector196
vector196:
  pushl $0
c010241c:	6a 00                	push   $0x0
  pushl $196
c010241e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102423:	e9 c4 02 00 00       	jmp    c01026ec <__alltraps>

c0102428 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $197
c010242a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c010242f:	e9 b8 02 00 00       	jmp    c01026ec <__alltraps>

c0102434 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102434:	6a 00                	push   $0x0
  pushl $198
c0102436:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010243b:	e9 ac 02 00 00       	jmp    c01026ec <__alltraps>

c0102440 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102440:	6a 00                	push   $0x0
  pushl $199
c0102442:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102447:	e9 a0 02 00 00       	jmp    c01026ec <__alltraps>

c010244c <vector200>:
.globl vector200
vector200:
  pushl $0
c010244c:	6a 00                	push   $0x0
  pushl $200
c010244e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102453:	e9 94 02 00 00       	jmp    c01026ec <__alltraps>

c0102458 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102458:	6a 00                	push   $0x0
  pushl $201
c010245a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010245f:	e9 88 02 00 00       	jmp    c01026ec <__alltraps>

c0102464 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102464:	6a 00                	push   $0x0
  pushl $202
c0102466:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010246b:	e9 7c 02 00 00       	jmp    c01026ec <__alltraps>

c0102470 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102470:	6a 00                	push   $0x0
  pushl $203
c0102472:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102477:	e9 70 02 00 00       	jmp    c01026ec <__alltraps>

c010247c <vector204>:
.globl vector204
vector204:
  pushl $0
c010247c:	6a 00                	push   $0x0
  pushl $204
c010247e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102483:	e9 64 02 00 00       	jmp    c01026ec <__alltraps>

c0102488 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102488:	6a 00                	push   $0x0
  pushl $205
c010248a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010248f:	e9 58 02 00 00       	jmp    c01026ec <__alltraps>

c0102494 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102494:	6a 00                	push   $0x0
  pushl $206
c0102496:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010249b:	e9 4c 02 00 00       	jmp    c01026ec <__alltraps>

c01024a0 <vector207>:
.globl vector207
vector207:
  pushl $0
c01024a0:	6a 00                	push   $0x0
  pushl $207
c01024a2:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01024a7:	e9 40 02 00 00       	jmp    c01026ec <__alltraps>

c01024ac <vector208>:
.globl vector208
vector208:
  pushl $0
c01024ac:	6a 00                	push   $0x0
  pushl $208
c01024ae:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01024b3:	e9 34 02 00 00       	jmp    c01026ec <__alltraps>

c01024b8 <vector209>:
.globl vector209
vector209:
  pushl $0
c01024b8:	6a 00                	push   $0x0
  pushl $209
c01024ba:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01024bf:	e9 28 02 00 00       	jmp    c01026ec <__alltraps>

c01024c4 <vector210>:
.globl vector210
vector210:
  pushl $0
c01024c4:	6a 00                	push   $0x0
  pushl $210
c01024c6:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01024cb:	e9 1c 02 00 00       	jmp    c01026ec <__alltraps>

c01024d0 <vector211>:
.globl vector211
vector211:
  pushl $0
c01024d0:	6a 00                	push   $0x0
  pushl $211
c01024d2:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01024d7:	e9 10 02 00 00       	jmp    c01026ec <__alltraps>

c01024dc <vector212>:
.globl vector212
vector212:
  pushl $0
c01024dc:	6a 00                	push   $0x0
  pushl $212
c01024de:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01024e3:	e9 04 02 00 00       	jmp    c01026ec <__alltraps>

c01024e8 <vector213>:
.globl vector213
vector213:
  pushl $0
c01024e8:	6a 00                	push   $0x0
  pushl $213
c01024ea:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01024ef:	e9 f8 01 00 00       	jmp    c01026ec <__alltraps>

c01024f4 <vector214>:
.globl vector214
vector214:
  pushl $0
c01024f4:	6a 00                	push   $0x0
  pushl $214
c01024f6:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01024fb:	e9 ec 01 00 00       	jmp    c01026ec <__alltraps>

c0102500 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102500:	6a 00                	push   $0x0
  pushl $215
c0102502:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102507:	e9 e0 01 00 00       	jmp    c01026ec <__alltraps>

c010250c <vector216>:
.globl vector216
vector216:
  pushl $0
c010250c:	6a 00                	push   $0x0
  pushl $216
c010250e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102513:	e9 d4 01 00 00       	jmp    c01026ec <__alltraps>

c0102518 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102518:	6a 00                	push   $0x0
  pushl $217
c010251a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c010251f:	e9 c8 01 00 00       	jmp    c01026ec <__alltraps>

c0102524 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102524:	6a 00                	push   $0x0
  pushl $218
c0102526:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010252b:	e9 bc 01 00 00       	jmp    c01026ec <__alltraps>

c0102530 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102530:	6a 00                	push   $0x0
  pushl $219
c0102532:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102537:	e9 b0 01 00 00       	jmp    c01026ec <__alltraps>

c010253c <vector220>:
.globl vector220
vector220:
  pushl $0
c010253c:	6a 00                	push   $0x0
  pushl $220
c010253e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102543:	e9 a4 01 00 00       	jmp    c01026ec <__alltraps>

c0102548 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102548:	6a 00                	push   $0x0
  pushl $221
c010254a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010254f:	e9 98 01 00 00       	jmp    c01026ec <__alltraps>

c0102554 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102554:	6a 00                	push   $0x0
  pushl $222
c0102556:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010255b:	e9 8c 01 00 00       	jmp    c01026ec <__alltraps>

c0102560 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102560:	6a 00                	push   $0x0
  pushl $223
c0102562:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102567:	e9 80 01 00 00       	jmp    c01026ec <__alltraps>

c010256c <vector224>:
.globl vector224
vector224:
  pushl $0
c010256c:	6a 00                	push   $0x0
  pushl $224
c010256e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102573:	e9 74 01 00 00       	jmp    c01026ec <__alltraps>

c0102578 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102578:	6a 00                	push   $0x0
  pushl $225
c010257a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010257f:	e9 68 01 00 00       	jmp    c01026ec <__alltraps>

c0102584 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102584:	6a 00                	push   $0x0
  pushl $226
c0102586:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010258b:	e9 5c 01 00 00       	jmp    c01026ec <__alltraps>

c0102590 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102590:	6a 00                	push   $0x0
  pushl $227
c0102592:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102597:	e9 50 01 00 00       	jmp    c01026ec <__alltraps>

c010259c <vector228>:
.globl vector228
vector228:
  pushl $0
c010259c:	6a 00                	push   $0x0
  pushl $228
c010259e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01025a3:	e9 44 01 00 00       	jmp    c01026ec <__alltraps>

c01025a8 <vector229>:
.globl vector229
vector229:
  pushl $0
c01025a8:	6a 00                	push   $0x0
  pushl $229
c01025aa:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01025af:	e9 38 01 00 00       	jmp    c01026ec <__alltraps>

c01025b4 <vector230>:
.globl vector230
vector230:
  pushl $0
c01025b4:	6a 00                	push   $0x0
  pushl $230
c01025b6:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01025bb:	e9 2c 01 00 00       	jmp    c01026ec <__alltraps>

c01025c0 <vector231>:
.globl vector231
vector231:
  pushl $0
c01025c0:	6a 00                	push   $0x0
  pushl $231
c01025c2:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01025c7:	e9 20 01 00 00       	jmp    c01026ec <__alltraps>

c01025cc <vector232>:
.globl vector232
vector232:
  pushl $0
c01025cc:	6a 00                	push   $0x0
  pushl $232
c01025ce:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01025d3:	e9 14 01 00 00       	jmp    c01026ec <__alltraps>

c01025d8 <vector233>:
.globl vector233
vector233:
  pushl $0
c01025d8:	6a 00                	push   $0x0
  pushl $233
c01025da:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01025df:	e9 08 01 00 00       	jmp    c01026ec <__alltraps>

c01025e4 <vector234>:
.globl vector234
vector234:
  pushl $0
c01025e4:	6a 00                	push   $0x0
  pushl $234
c01025e6:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01025eb:	e9 fc 00 00 00       	jmp    c01026ec <__alltraps>

c01025f0 <vector235>:
.globl vector235
vector235:
  pushl $0
c01025f0:	6a 00                	push   $0x0
  pushl $235
c01025f2:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01025f7:	e9 f0 00 00 00       	jmp    c01026ec <__alltraps>

c01025fc <vector236>:
.globl vector236
vector236:
  pushl $0
c01025fc:	6a 00                	push   $0x0
  pushl $236
c01025fe:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102603:	e9 e4 00 00 00       	jmp    c01026ec <__alltraps>

c0102608 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102608:	6a 00                	push   $0x0
  pushl $237
c010260a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c010260f:	e9 d8 00 00 00       	jmp    c01026ec <__alltraps>

c0102614 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102614:	6a 00                	push   $0x0
  pushl $238
c0102616:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010261b:	e9 cc 00 00 00       	jmp    c01026ec <__alltraps>

c0102620 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102620:	6a 00                	push   $0x0
  pushl $239
c0102622:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102627:	e9 c0 00 00 00       	jmp    c01026ec <__alltraps>

c010262c <vector240>:
.globl vector240
vector240:
  pushl $0
c010262c:	6a 00                	push   $0x0
  pushl $240
c010262e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102633:	e9 b4 00 00 00       	jmp    c01026ec <__alltraps>

c0102638 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102638:	6a 00                	push   $0x0
  pushl $241
c010263a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010263f:	e9 a8 00 00 00       	jmp    c01026ec <__alltraps>

c0102644 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102644:	6a 00                	push   $0x0
  pushl $242
c0102646:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010264b:	e9 9c 00 00 00       	jmp    c01026ec <__alltraps>

c0102650 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102650:	6a 00                	push   $0x0
  pushl $243
c0102652:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102657:	e9 90 00 00 00       	jmp    c01026ec <__alltraps>

c010265c <vector244>:
.globl vector244
vector244:
  pushl $0
c010265c:	6a 00                	push   $0x0
  pushl $244
c010265e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102663:	e9 84 00 00 00       	jmp    c01026ec <__alltraps>

c0102668 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102668:	6a 00                	push   $0x0
  pushl $245
c010266a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010266f:	e9 78 00 00 00       	jmp    c01026ec <__alltraps>

c0102674 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102674:	6a 00                	push   $0x0
  pushl $246
c0102676:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010267b:	e9 6c 00 00 00       	jmp    c01026ec <__alltraps>

c0102680 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102680:	6a 00                	push   $0x0
  pushl $247
c0102682:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102687:	e9 60 00 00 00       	jmp    c01026ec <__alltraps>

c010268c <vector248>:
.globl vector248
vector248:
  pushl $0
c010268c:	6a 00                	push   $0x0
  pushl $248
c010268e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102693:	e9 54 00 00 00       	jmp    c01026ec <__alltraps>

c0102698 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102698:	6a 00                	push   $0x0
  pushl $249
c010269a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010269f:	e9 48 00 00 00       	jmp    c01026ec <__alltraps>

c01026a4 <vector250>:
.globl vector250
vector250:
  pushl $0
c01026a4:	6a 00                	push   $0x0
  pushl $250
c01026a6:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01026ab:	e9 3c 00 00 00       	jmp    c01026ec <__alltraps>

c01026b0 <vector251>:
.globl vector251
vector251:
  pushl $0
c01026b0:	6a 00                	push   $0x0
  pushl $251
c01026b2:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01026b7:	e9 30 00 00 00       	jmp    c01026ec <__alltraps>

c01026bc <vector252>:
.globl vector252
vector252:
  pushl $0
c01026bc:	6a 00                	push   $0x0
  pushl $252
c01026be:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01026c3:	e9 24 00 00 00       	jmp    c01026ec <__alltraps>

c01026c8 <vector253>:
.globl vector253
vector253:
  pushl $0
c01026c8:	6a 00                	push   $0x0
  pushl $253
c01026ca:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01026cf:	e9 18 00 00 00       	jmp    c01026ec <__alltraps>

c01026d4 <vector254>:
.globl vector254
vector254:
  pushl $0
c01026d4:	6a 00                	push   $0x0
  pushl $254
c01026d6:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01026db:	e9 0c 00 00 00       	jmp    c01026ec <__alltraps>

c01026e0 <vector255>:
.globl vector255
vector255:
  pushl $0
c01026e0:	6a 00                	push   $0x0
  pushl $255
c01026e2:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01026e7:	e9 00 00 00 00       	jmp    c01026ec <__alltraps>

c01026ec <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01026ec:	1e                   	push   %ds
    pushl %es
c01026ed:	06                   	push   %es
    pushl %fs
c01026ee:	0f a0                	push   %fs
    pushl %gs
c01026f0:	0f a8                	push   %gs
    pushal
c01026f2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01026f3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01026f8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01026fa:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01026fc:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01026fd:	e8 64 f5 ff ff       	call   c0101c66 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102702:	5c                   	pop    %esp

c0102703 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102703:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102704:	0f a9                	pop    %gs
    popl %fs
c0102706:	0f a1                	pop    %fs
    popl %es
c0102708:	07                   	pop    %es
    popl %ds
c0102709:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010270a:	83 c4 08             	add    $0x8,%esp
    iret
c010270d:	cf                   	iret   

c010270e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010270e:	55                   	push   %ebp
c010270f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102711:	8b 45 08             	mov    0x8(%ebp),%eax
c0102714:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c010271a:	29 d0                	sub    %edx,%eax
c010271c:	c1 f8 02             	sar    $0x2,%eax
c010271f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102725:	5d                   	pop    %ebp
c0102726:	c3                   	ret    

c0102727 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102727:	55                   	push   %ebp
c0102728:	89 e5                	mov    %esp,%ebp
c010272a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010272d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102730:	89 04 24             	mov    %eax,(%esp)
c0102733:	e8 d6 ff ff ff       	call   c010270e <page2ppn>
c0102738:	c1 e0 0c             	shl    $0xc,%eax
}
c010273b:	c9                   	leave  
c010273c:	c3                   	ret    

c010273d <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010273d:	55                   	push   %ebp
c010273e:	89 e5                	mov    %esp,%ebp
c0102740:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0102743:	8b 45 08             	mov    0x8(%ebp),%eax
c0102746:	c1 e8 0c             	shr    $0xc,%eax
c0102749:	89 c2                	mov    %eax,%edx
c010274b:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0102750:	39 c2                	cmp    %eax,%edx
c0102752:	72 1c                	jb     c0102770 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102754:	c7 44 24 08 10 63 10 	movl   $0xc0106310,0x8(%esp)
c010275b:	c0 
c010275c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102763:	00 
c0102764:	c7 04 24 2f 63 10 c0 	movl   $0xc010632f,(%esp)
c010276b:	e8 74 dc ff ff       	call   c01003e4 <__panic>
    }
    return &pages[PPN(pa)];
c0102770:	8b 0d 18 af 11 c0    	mov    0xc011af18,%ecx
c0102776:	8b 45 08             	mov    0x8(%ebp),%eax
c0102779:	c1 e8 0c             	shr    $0xc,%eax
c010277c:	89 c2                	mov    %eax,%edx
c010277e:	89 d0                	mov    %edx,%eax
c0102780:	c1 e0 02             	shl    $0x2,%eax
c0102783:	01 d0                	add    %edx,%eax
c0102785:	c1 e0 02             	shl    $0x2,%eax
c0102788:	01 c8                	add    %ecx,%eax
}
c010278a:	c9                   	leave  
c010278b:	c3                   	ret    

c010278c <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010278c:	55                   	push   %ebp
c010278d:	89 e5                	mov    %esp,%ebp
c010278f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102792:	8b 45 08             	mov    0x8(%ebp),%eax
c0102795:	89 04 24             	mov    %eax,(%esp)
c0102798:	e8 8a ff ff ff       	call   c0102727 <page2pa>
c010279d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027a3:	c1 e8 0c             	shr    $0xc,%eax
c01027a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01027a9:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01027ae:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01027b1:	72 23                	jb     c01027d6 <page2kva+0x4a>
c01027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01027ba:	c7 44 24 08 40 63 10 	movl   $0xc0106340,0x8(%esp)
c01027c1:	c0 
c01027c2:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c01027c9:	00 
c01027ca:	c7 04 24 2f 63 10 c0 	movl   $0xc010632f,(%esp)
c01027d1:	e8 0e dc ff ff       	call   c01003e4 <__panic>
c01027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027d9:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01027de:	c9                   	leave  
c01027df:	c3                   	ret    

c01027e0 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01027e0:	55                   	push   %ebp
c01027e1:	89 e5                	mov    %esp,%ebp
c01027e3:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01027e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01027e9:	83 e0 01             	and    $0x1,%eax
c01027ec:	85 c0                	test   %eax,%eax
c01027ee:	75 1c                	jne    c010280c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01027f0:	c7 44 24 08 64 63 10 	movl   $0xc0106364,0x8(%esp)
c01027f7:	c0 
c01027f8:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c01027ff:	00 
c0102800:	c7 04 24 2f 63 10 c0 	movl   $0xc010632f,(%esp)
c0102807:	e8 d8 db ff ff       	call   c01003e4 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c010280c:	8b 45 08             	mov    0x8(%ebp),%eax
c010280f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102814:	89 04 24             	mov    %eax,(%esp)
c0102817:	e8 21 ff ff ff       	call   c010273d <pa2page>
}
c010281c:	c9                   	leave  
c010281d:	c3                   	ret    

c010281e <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c010281e:	55                   	push   %ebp
c010281f:	89 e5                	mov    %esp,%ebp
c0102821:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102824:	8b 45 08             	mov    0x8(%ebp),%eax
c0102827:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010282c:	89 04 24             	mov    %eax,(%esp)
c010282f:	e8 09 ff ff ff       	call   c010273d <pa2page>
}
c0102834:	c9                   	leave  
c0102835:	c3                   	ret    

c0102836 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102836:	55                   	push   %ebp
c0102837:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102839:	8b 45 08             	mov    0x8(%ebp),%eax
c010283c:	8b 00                	mov    (%eax),%eax
}
c010283e:	5d                   	pop    %ebp
c010283f:	c3                   	ret    

c0102840 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0102840:	55                   	push   %ebp
c0102841:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102843:	8b 45 08             	mov    0x8(%ebp),%eax
c0102846:	8b 00                	mov    (%eax),%eax
c0102848:	8d 50 01             	lea    0x1(%eax),%edx
c010284b:	8b 45 08             	mov    0x8(%ebp),%eax
c010284e:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102850:	8b 45 08             	mov    0x8(%ebp),%eax
c0102853:	8b 00                	mov    (%eax),%eax
}
c0102855:	5d                   	pop    %ebp
c0102856:	c3                   	ret    

c0102857 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102857:	55                   	push   %ebp
c0102858:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c010285a:	8b 45 08             	mov    0x8(%ebp),%eax
c010285d:	8b 00                	mov    (%eax),%eax
c010285f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102862:	8b 45 08             	mov    0x8(%ebp),%eax
c0102865:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102867:	8b 45 08             	mov    0x8(%ebp),%eax
c010286a:	8b 00                	mov    (%eax),%eax
}
c010286c:	5d                   	pop    %ebp
c010286d:	c3                   	ret    

c010286e <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010286e:	55                   	push   %ebp
c010286f:	89 e5                	mov    %esp,%ebp
c0102871:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102874:	9c                   	pushf  
c0102875:	58                   	pop    %eax
c0102876:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102879:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010287c:	25 00 02 00 00       	and    $0x200,%eax
c0102881:	85 c0                	test   %eax,%eax
c0102883:	74 0c                	je     c0102891 <__intr_save+0x23>
        intr_disable();
c0102885:	e8 34 ef ff ff       	call   c01017be <intr_disable>
        return 1;
c010288a:	b8 01 00 00 00       	mov    $0x1,%eax
c010288f:	eb 05                	jmp    c0102896 <__intr_save+0x28>
    }
    return 0;
c0102891:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102896:	c9                   	leave  
c0102897:	c3                   	ret    

c0102898 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0102898:	55                   	push   %ebp
c0102899:	89 e5                	mov    %esp,%ebp
c010289b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010289e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01028a2:	74 05                	je     c01028a9 <__intr_restore+0x11>
        intr_enable();
c01028a4:	e8 0e ef ff ff       	call   c01017b7 <intr_enable>
    }
}
c01028a9:	90                   	nop
c01028aa:	c9                   	leave  
c01028ab:	c3                   	ret    

c01028ac <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01028ac:	55                   	push   %ebp
c01028ad:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01028af:	8b 45 08             	mov    0x8(%ebp),%eax
c01028b2:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01028b5:	b8 23 00 00 00       	mov    $0x23,%eax
c01028ba:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01028bc:	b8 23 00 00 00       	mov    $0x23,%eax
c01028c1:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01028c3:	b8 10 00 00 00       	mov    $0x10,%eax
c01028c8:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01028ca:	b8 10 00 00 00       	mov    $0x10,%eax
c01028cf:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c01028d1:	b8 10 00 00 00       	mov    $0x10,%eax
c01028d6:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c01028d8:	ea df 28 10 c0 08 00 	ljmp   $0x8,$0xc01028df
}
c01028df:	90                   	nop
c01028e0:	5d                   	pop    %ebp
c01028e1:	c3                   	ret    

c01028e2 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c01028e2:	55                   	push   %ebp
c01028e3:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c01028e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01028e8:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c01028ed:	90                   	nop
c01028ee:	5d                   	pop    %ebp
c01028ef:	c3                   	ret    

c01028f0 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c01028f0:	55                   	push   %ebp
c01028f1:	89 e5                	mov    %esp,%ebp
c01028f3:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c01028f6:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c01028fb:	89 04 24             	mov    %eax,(%esp)
c01028fe:	e8 df ff ff ff       	call   c01028e2 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102903:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c010290a:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c010290c:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102913:	68 00 
c0102915:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c010291a:	0f b7 c0             	movzwl %ax,%eax
c010291d:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102923:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102928:	c1 e8 10             	shr    $0x10,%eax
c010292b:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102930:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102937:	24 f0                	and    $0xf0,%al
c0102939:	0c 09                	or     $0x9,%al
c010293b:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102940:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102947:	24 ef                	and    $0xef,%al
c0102949:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c010294e:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102955:	24 9f                	and    $0x9f,%al
c0102957:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c010295c:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102963:	0c 80                	or     $0x80,%al
c0102965:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c010296a:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102971:	24 f0                	and    $0xf0,%al
c0102973:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102978:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c010297f:	24 ef                	and    $0xef,%al
c0102981:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102986:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c010298d:	24 df                	and    $0xdf,%al
c010298f:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102994:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c010299b:	0c 40                	or     $0x40,%al
c010299d:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c01029a2:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c01029a9:	24 7f                	and    $0x7f,%al
c01029ab:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c01029b0:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c01029b5:	c1 e8 18             	shr    $0x18,%eax
c01029b8:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c01029bd:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c01029c4:	e8 e3 fe ff ff       	call   c01028ac <lgdt>
c01029c9:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01029cf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01029d3:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01029d6:	90                   	nop
c01029d7:	c9                   	leave  
c01029d8:	c3                   	ret    

c01029d9 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01029d9:	55                   	push   %ebp
c01029da:	89 e5                	mov    %esp,%ebp
c01029dc:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c01029df:	c7 05 10 af 11 c0 20 	movl   $0xc0106d20,0xc011af10
c01029e6:	6d 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01029e9:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c01029ee:	8b 00                	mov    (%eax),%eax
c01029f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01029f4:	c7 04 24 90 63 10 c0 	movl   $0xc0106390,(%esp)
c01029fb:	e8 8d d8 ff ff       	call   c010028d <cprintf>
    pmm_manager->init();
c0102a00:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0102a05:	8b 40 04             	mov    0x4(%eax),%eax
c0102a08:	ff d0                	call   *%eax
}
c0102a0a:	90                   	nop
c0102a0b:	c9                   	leave  
c0102a0c:	c3                   	ret    

c0102a0d <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102a0d:	55                   	push   %ebp
c0102a0e:	89 e5                	mov    %esp,%ebp
c0102a10:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102a13:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0102a18:	8b 40 08             	mov    0x8(%eax),%eax
c0102a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a1e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102a22:	8b 55 08             	mov    0x8(%ebp),%edx
c0102a25:	89 14 24             	mov    %edx,(%esp)
c0102a28:	ff d0                	call   *%eax
}
c0102a2a:	90                   	nop
c0102a2b:	c9                   	leave  
c0102a2c:	c3                   	ret    

c0102a2d <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102a2d:	55                   	push   %ebp
c0102a2e:	89 e5                	mov    %esp,%ebp
c0102a30:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102a33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102a3a:	e8 2f fe ff ff       	call   c010286e <__intr_save>
c0102a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102a42:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0102a47:	8b 40 0c             	mov    0xc(%eax),%eax
c0102a4a:	8b 55 08             	mov    0x8(%ebp),%edx
c0102a4d:	89 14 24             	mov    %edx,(%esp)
c0102a50:	ff d0                	call   *%eax
c0102a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a58:	89 04 24             	mov    %eax,(%esp)
c0102a5b:	e8 38 fe ff ff       	call   c0102898 <__intr_restore>
    return page;
c0102a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102a63:	c9                   	leave  
c0102a64:	c3                   	ret    

c0102a65 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102a65:	55                   	push   %ebp
c0102a66:	89 e5                	mov    %esp,%ebp
c0102a68:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102a6b:	e8 fe fd ff ff       	call   c010286e <__intr_save>
c0102a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102a73:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0102a78:	8b 40 10             	mov    0x10(%eax),%eax
c0102a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a7e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102a82:	8b 55 08             	mov    0x8(%ebp),%edx
c0102a85:	89 14 24             	mov    %edx,(%esp)
c0102a88:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a8d:	89 04 24             	mov    %eax,(%esp)
c0102a90:	e8 03 fe ff ff       	call   c0102898 <__intr_restore>
}
c0102a95:	90                   	nop
c0102a96:	c9                   	leave  
c0102a97:	c3                   	ret    

c0102a98 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102a98:	55                   	push   %ebp
c0102a99:	89 e5                	mov    %esp,%ebp
c0102a9b:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102a9e:	e8 cb fd ff ff       	call   c010286e <__intr_save>
c0102aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102aa6:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0102aab:	8b 40 14             	mov    0x14(%eax),%eax
c0102aae:	ff d0                	call   *%eax
c0102ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ab6:	89 04 24             	mov    %eax,(%esp)
c0102ab9:	e8 da fd ff ff       	call   c0102898 <__intr_restore>
    return ret;
c0102abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102ac1:	c9                   	leave  
c0102ac2:	c3                   	ret    

c0102ac3 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102ac3:	55                   	push   %ebp
c0102ac4:	89 e5                	mov    %esp,%ebp
c0102ac6:	57                   	push   %edi
c0102ac7:	56                   	push   %esi
c0102ac8:	53                   	push   %ebx
c0102ac9:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102acf:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102ad6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102add:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102ae4:	c7 04 24 a7 63 10 c0 	movl   $0xc01063a7,(%esp)
c0102aeb:	e8 9d d7 ff ff       	call   c010028d <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102af0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102af7:	e9 22 01 00 00       	jmp    c0102c1e <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102afc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102aff:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b02:	89 d0                	mov    %edx,%eax
c0102b04:	c1 e0 02             	shl    $0x2,%eax
c0102b07:	01 d0                	add    %edx,%eax
c0102b09:	c1 e0 02             	shl    $0x2,%eax
c0102b0c:	01 c8                	add    %ecx,%eax
c0102b0e:	8b 50 08             	mov    0x8(%eax),%edx
c0102b11:	8b 40 04             	mov    0x4(%eax),%eax
c0102b14:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102b17:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102b1a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102b1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b20:	89 d0                	mov    %edx,%eax
c0102b22:	c1 e0 02             	shl    $0x2,%eax
c0102b25:	01 d0                	add    %edx,%eax
c0102b27:	c1 e0 02             	shl    $0x2,%eax
c0102b2a:	01 c8                	add    %ecx,%eax
c0102b2c:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102b2f:	8b 58 10             	mov    0x10(%eax),%ebx
c0102b32:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b35:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b38:	01 c8                	add    %ecx,%eax
c0102b3a:	11 da                	adc    %ebx,%edx
c0102b3c:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102b3f:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102b42:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102b45:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b48:	89 d0                	mov    %edx,%eax
c0102b4a:	c1 e0 02             	shl    $0x2,%eax
c0102b4d:	01 d0                	add    %edx,%eax
c0102b4f:	c1 e0 02             	shl    $0x2,%eax
c0102b52:	01 c8                	add    %ecx,%eax
c0102b54:	83 c0 14             	add    $0x14,%eax
c0102b57:	8b 00                	mov    (%eax),%eax
c0102b59:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102b5c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102b5f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102b62:	83 c0 ff             	add    $0xffffffff,%eax
c0102b65:	83 d2 ff             	adc    $0xffffffff,%edx
c0102b68:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0102b6e:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0102b74:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102b77:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b7a:	89 d0                	mov    %edx,%eax
c0102b7c:	c1 e0 02             	shl    $0x2,%eax
c0102b7f:	01 d0                	add    %edx,%eax
c0102b81:	c1 e0 02             	shl    $0x2,%eax
c0102b84:	01 c8                	add    %ecx,%eax
c0102b86:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102b89:	8b 58 10             	mov    0x10(%eax),%ebx
c0102b8c:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102b8f:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0102b93:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102b99:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102b9f:	89 44 24 14          	mov    %eax,0x14(%esp)
c0102ba3:	89 54 24 18          	mov    %edx,0x18(%esp)
c0102ba7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102baa:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102bad:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102bb1:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102bb5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102bb9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102bbd:	c7 04 24 b4 63 10 c0 	movl   $0xc01063b4,(%esp)
c0102bc4:	e8 c4 d6 ff ff       	call   c010028d <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102bc9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102bcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102bcf:	89 d0                	mov    %edx,%eax
c0102bd1:	c1 e0 02             	shl    $0x2,%eax
c0102bd4:	01 d0                	add    %edx,%eax
c0102bd6:	c1 e0 02             	shl    $0x2,%eax
c0102bd9:	01 c8                	add    %ecx,%eax
c0102bdb:	83 c0 14             	add    $0x14,%eax
c0102bde:	8b 00                	mov    (%eax),%eax
c0102be0:	83 f8 01             	cmp    $0x1,%eax
c0102be3:	75 36                	jne    c0102c1b <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
c0102be5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102be8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102beb:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102bee:	77 2b                	ja     c0102c1b <page_init+0x158>
c0102bf0:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102bf3:	72 05                	jb     c0102bfa <page_init+0x137>
c0102bf5:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102bf8:	73 21                	jae    c0102c1b <page_init+0x158>
c0102bfa:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102bfe:	77 1b                	ja     c0102c1b <page_init+0x158>
c0102c00:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102c04:	72 09                	jb     c0102c0f <page_init+0x14c>
c0102c06:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102c0d:	77 0c                	ja     c0102c1b <page_init+0x158>
                maxpa = end;
c0102c0f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102c12:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102c15:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102c18:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102c1b:	ff 45 dc             	incl   -0x24(%ebp)
c0102c1e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c21:	8b 00                	mov    (%eax),%eax
c0102c23:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102c26:	0f 8f d0 fe ff ff    	jg     c0102afc <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102c2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c30:	72 1d                	jb     c0102c4f <page_init+0x18c>
c0102c32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c36:	77 09                	ja     c0102c41 <page_init+0x17e>
c0102c38:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102c3f:	76 0e                	jbe    c0102c4f <page_init+0x18c>
        maxpa = KMEMSIZE;
c0102c41:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102c48:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102c4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102c52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102c55:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102c59:	c1 ea 0c             	shr    $0xc,%edx
c0102c5c:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102c61:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102c68:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c0102c6d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102c70:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102c73:	01 d0                	add    %edx,%eax
c0102c75:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102c78:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102c7b:	ba 00 00 00 00       	mov    $0x0,%edx
c0102c80:	f7 75 ac             	divl   -0x54(%ebp)
c0102c83:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102c86:	29 d0                	sub    %edx,%eax
c0102c88:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    for (i = 0; i < npage; i ++) {
c0102c8d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102c94:	eb 2e                	jmp    c0102cc4 <page_init+0x201>
        SetPageReserved(pages + i);
c0102c96:	8b 0d 18 af 11 c0    	mov    0xc011af18,%ecx
c0102c9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c9f:	89 d0                	mov    %edx,%eax
c0102ca1:	c1 e0 02             	shl    $0x2,%eax
c0102ca4:	01 d0                	add    %edx,%eax
c0102ca6:	c1 e0 02             	shl    $0x2,%eax
c0102ca9:	01 c8                	add    %ecx,%eax
c0102cab:	83 c0 04             	add    $0x4,%eax
c0102cae:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102cb5:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cb8:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102cbb:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102cbe:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0102cc1:	ff 45 dc             	incl   -0x24(%ebp)
c0102cc4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102cc7:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0102ccc:	39 c2                	cmp    %eax,%edx
c0102cce:	72 c6                	jb     c0102c96 <page_init+0x1d3>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102cd0:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0102cd6:	89 d0                	mov    %edx,%eax
c0102cd8:	c1 e0 02             	shl    $0x2,%eax
c0102cdb:	01 d0                	add    %edx,%eax
c0102cdd:	c1 e0 02             	shl    $0x2,%eax
c0102ce0:	89 c2                	mov    %eax,%edx
c0102ce2:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102ce7:	01 d0                	add    %edx,%eax
c0102ce9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102cec:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102cf3:	77 23                	ja     c0102d18 <page_init+0x255>
c0102cf5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102cf8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102cfc:	c7 44 24 08 e4 63 10 	movl   $0xc01063e4,0x8(%esp)
c0102d03:	c0 
c0102d04:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0102d0b:	00 
c0102d0c:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0102d13:	e8 cc d6 ff ff       	call   c01003e4 <__panic>
c0102d18:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102d1b:	05 00 00 00 40       	add    $0x40000000,%eax
c0102d20:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102d23:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102d2a:	e9 61 01 00 00       	jmp    c0102e90 <page_init+0x3cd>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102d2f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d32:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d35:	89 d0                	mov    %edx,%eax
c0102d37:	c1 e0 02             	shl    $0x2,%eax
c0102d3a:	01 d0                	add    %edx,%eax
c0102d3c:	c1 e0 02             	shl    $0x2,%eax
c0102d3f:	01 c8                	add    %ecx,%eax
c0102d41:	8b 50 08             	mov    0x8(%eax),%edx
c0102d44:	8b 40 04             	mov    0x4(%eax),%eax
c0102d47:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102d4a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102d4d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d50:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d53:	89 d0                	mov    %edx,%eax
c0102d55:	c1 e0 02             	shl    $0x2,%eax
c0102d58:	01 d0                	add    %edx,%eax
c0102d5a:	c1 e0 02             	shl    $0x2,%eax
c0102d5d:	01 c8                	add    %ecx,%eax
c0102d5f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102d62:	8b 58 10             	mov    0x10(%eax),%ebx
c0102d65:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d68:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102d6b:	01 c8                	add    %ecx,%eax
c0102d6d:	11 da                	adc    %ebx,%edx
c0102d6f:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102d72:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102d75:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102d78:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d7b:	89 d0                	mov    %edx,%eax
c0102d7d:	c1 e0 02             	shl    $0x2,%eax
c0102d80:	01 d0                	add    %edx,%eax
c0102d82:	c1 e0 02             	shl    $0x2,%eax
c0102d85:	01 c8                	add    %ecx,%eax
c0102d87:	83 c0 14             	add    $0x14,%eax
c0102d8a:	8b 00                	mov    (%eax),%eax
c0102d8c:	83 f8 01             	cmp    $0x1,%eax
c0102d8f:	0f 85 f8 00 00 00    	jne    c0102e8d <page_init+0x3ca>
            if (begin < freemem) {
c0102d95:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102d98:	ba 00 00 00 00       	mov    $0x0,%edx
c0102d9d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102da0:	72 17                	jb     c0102db9 <page_init+0x2f6>
c0102da2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0102da5:	77 05                	ja     c0102dac <page_init+0x2e9>
c0102da7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0102daa:	76 0d                	jbe    c0102db9 <page_init+0x2f6>
                begin = freemem;
c0102dac:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102daf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102db2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102db9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102dbd:	72 1d                	jb     c0102ddc <page_init+0x319>
c0102dbf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102dc3:	77 09                	ja     c0102dce <page_init+0x30b>
c0102dc5:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102dcc:	76 0e                	jbe    c0102ddc <page_init+0x319>
                end = KMEMSIZE;
c0102dce:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102dd5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102ddc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102ddf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102de2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102de5:	0f 87 a2 00 00 00    	ja     c0102e8d <page_init+0x3ca>
c0102deb:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102dee:	72 09                	jb     c0102df9 <page_init+0x336>
c0102df0:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102df3:	0f 83 94 00 00 00    	jae    c0102e8d <page_init+0x3ca>
                begin = ROUNDUP(begin, PGSIZE);
c0102df9:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0102e00:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102e03:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102e06:	01 d0                	add    %edx,%eax
c0102e08:	48                   	dec    %eax
c0102e09:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102e0c:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e0f:	ba 00 00 00 00       	mov    $0x0,%edx
c0102e14:	f7 75 9c             	divl   -0x64(%ebp)
c0102e17:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e1a:	29 d0                	sub    %edx,%eax
c0102e1c:	ba 00 00 00 00       	mov    $0x0,%edx
c0102e21:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102e24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0102e27:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102e2a:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102e2d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e30:	ba 00 00 00 00       	mov    $0x0,%edx
c0102e35:	89 c3                	mov    %eax,%ebx
c0102e37:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0102e3d:	89 de                	mov    %ebx,%esi
c0102e3f:	89 d0                	mov    %edx,%eax
c0102e41:	83 e0 00             	and    $0x0,%eax
c0102e44:	89 c7                	mov    %eax,%edi
c0102e46:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0102e49:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0102e4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102e4f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102e52:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102e55:	77 36                	ja     c0102e8d <page_init+0x3ca>
c0102e57:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102e5a:	72 05                	jb     c0102e61 <page_init+0x39e>
c0102e5c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102e5f:	73 2c                	jae    c0102e8d <page_init+0x3ca>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0102e61:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102e64:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102e67:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0102e6a:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0102e6d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102e71:	c1 ea 0c             	shr    $0xc,%edx
c0102e74:	89 c3                	mov    %eax,%ebx
c0102e76:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102e79:	89 04 24             	mov    %eax,(%esp)
c0102e7c:	e8 bc f8 ff ff       	call   c010273d <pa2page>
c0102e81:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102e85:	89 04 24             	mov    %eax,(%esp)
c0102e88:	e8 80 fb ff ff       	call   c0102a0d <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0102e8d:	ff 45 dc             	incl   -0x24(%ebp)
c0102e90:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e93:	8b 00                	mov    (%eax),%eax
c0102e95:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102e98:	0f 8f 91 fe ff ff    	jg     c0102d2f <page_init+0x26c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0102e9e:	90                   	nop
c0102e9f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0102ea5:	5b                   	pop    %ebx
c0102ea6:	5e                   	pop    %esi
c0102ea7:	5f                   	pop    %edi
c0102ea8:	5d                   	pop    %ebp
c0102ea9:	c3                   	ret    

c0102eaa <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0102eaa:	55                   	push   %ebp
c0102eab:	89 e5                	mov    %esp,%ebp
c0102ead:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0102eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102eb3:	33 45 14             	xor    0x14(%ebp),%eax
c0102eb6:	25 ff 0f 00 00       	and    $0xfff,%eax
c0102ebb:	85 c0                	test   %eax,%eax
c0102ebd:	74 24                	je     c0102ee3 <boot_map_segment+0x39>
c0102ebf:	c7 44 24 0c 16 64 10 	movl   $0xc0106416,0xc(%esp)
c0102ec6:	c0 
c0102ec7:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0102ece:	c0 
c0102ecf:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0102ed6:	00 
c0102ed7:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0102ede:	e8 01 d5 ff ff       	call   c01003e4 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0102ee3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0102eea:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102eed:	25 ff 0f 00 00       	and    $0xfff,%eax
c0102ef2:	89 c2                	mov    %eax,%edx
c0102ef4:	8b 45 10             	mov    0x10(%ebp),%eax
c0102ef7:	01 c2                	add    %eax,%edx
c0102ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102efc:	01 d0                	add    %edx,%eax
c0102efe:	48                   	dec    %eax
c0102eff:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f05:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f0a:	f7 75 f0             	divl   -0x10(%ebp)
c0102f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f10:	29 d0                	sub    %edx,%eax
c0102f12:	c1 e8 0c             	shr    $0xc,%eax
c0102f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0102f18:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102f21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102f26:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0102f29:	8b 45 14             	mov    0x14(%ebp),%eax
c0102f2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0102f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102f32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102f37:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0102f3a:	eb 68                	jmp    c0102fa4 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0102f3c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0102f43:	00 
c0102f44:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102f47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102f4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f4e:	89 04 24             	mov    %eax,(%esp)
c0102f51:	e8 81 01 00 00       	call   c01030d7 <get_pte>
c0102f56:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0102f59:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0102f5d:	75 24                	jne    c0102f83 <boot_map_segment+0xd9>
c0102f5f:	c7 44 24 0c 42 64 10 	movl   $0xc0106442,0xc(%esp)
c0102f66:	c0 
c0102f67:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0102f6e:	c0 
c0102f6f:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0102f76:	00 
c0102f77:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0102f7e:	e8 61 d4 ff ff       	call   c01003e4 <__panic>
        *ptep = pa | PTE_P | perm;
c0102f83:	8b 45 14             	mov    0x14(%ebp),%eax
c0102f86:	0b 45 18             	or     0x18(%ebp),%eax
c0102f89:	83 c8 01             	or     $0x1,%eax
c0102f8c:	89 c2                	mov    %eax,%edx
c0102f8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f91:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0102f93:	ff 4d f4             	decl   -0xc(%ebp)
c0102f96:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0102f9d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0102fa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102fa8:	75 92                	jne    c0102f3c <boot_map_segment+0x92>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0102faa:	90                   	nop
c0102fab:	c9                   	leave  
c0102fac:	c3                   	ret    

c0102fad <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0102fad:	55                   	push   %ebp
c0102fae:	89 e5                	mov    %esp,%ebp
c0102fb0:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0102fb3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102fba:	e8 6e fa ff ff       	call   c0102a2d <alloc_pages>
c0102fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0102fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102fc6:	75 1c                	jne    c0102fe4 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0102fc8:	c7 44 24 08 4f 64 10 	movl   $0xc010644f,0x8(%esp)
c0102fcf:	c0 
c0102fd0:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0102fd7:	00 
c0102fd8:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0102fdf:	e8 00 d4 ff ff       	call   c01003e4 <__panic>
    }
    return page2kva(p);
c0102fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fe7:	89 04 24             	mov    %eax,(%esp)
c0102fea:	e8 9d f7 ff ff       	call   c010278c <page2kva>
}
c0102fef:	c9                   	leave  
c0102ff0:	c3                   	ret    

c0102ff1 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0102ff1:	55                   	push   %ebp
c0102ff2:	89 e5                	mov    %esp,%ebp
c0102ff4:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0102ff7:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0102ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102fff:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103006:	77 23                	ja     c010302b <pmm_init+0x3a>
c0103008:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010300b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010300f:	c7 44 24 08 e4 63 10 	movl   $0xc01063e4,0x8(%esp)
c0103016:	c0 
c0103017:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010301e:	00 
c010301f:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103026:	e8 b9 d3 ff ff       	call   c01003e4 <__panic>
c010302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010302e:	05 00 00 00 40       	add    $0x40000000,%eax
c0103033:	a3 14 af 11 c0       	mov    %eax,0xc011af14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103038:	e8 9c f9 ff ff       	call   c01029d9 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010303d:	e8 81 fa ff ff       	call   c0102ac3 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103042:	e8 4f 02 00 00       	call   c0103296 <check_alloc_page>

    check_pgdir();
c0103047:	e8 69 02 00 00       	call   c01032b5 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010304c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103051:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0103057:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010305c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010305f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103066:	77 23                	ja     c010308b <pmm_init+0x9a>
c0103068:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010306b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010306f:	c7 44 24 08 e4 63 10 	movl   $0xc01063e4,0x8(%esp)
c0103076:	c0 
c0103077:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c010307e:	00 
c010307f:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103086:	e8 59 d3 ff ff       	call   c01003e4 <__panic>
c010308b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010308e:	05 00 00 00 40       	add    $0x40000000,%eax
c0103093:	83 c8 03             	or     $0x3,%eax
c0103096:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103098:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010309d:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01030a4:	00 
c01030a5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01030ac:	00 
c01030ad:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01030b4:	38 
c01030b5:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01030bc:	c0 
c01030bd:	89 04 24             	mov    %eax,(%esp)
c01030c0:	e8 e5 fd ff ff       	call   c0102eaa <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01030c5:	e8 26 f8 ff ff       	call   c01028f0 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01030ca:	e8 82 08 00 00       	call   c0103951 <check_boot_pgdir>

    print_pgdir();
c01030cf:	e8 fb 0c 00 00       	call   c0103dcf <print_pgdir>

}
c01030d4:	90                   	nop
c01030d5:	c9                   	leave  
c01030d6:	c3                   	ret    

c01030d7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01030d7:	55                   	push   %ebp
c01030d8:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01030da:	90                   	nop
c01030db:	5d                   	pop    %ebp
c01030dc:	c3                   	ret    

c01030dd <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01030dd:	55                   	push   %ebp
c01030de:	89 e5                	mov    %esp,%ebp
c01030e0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01030e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01030ea:	00 
c01030eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01030f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01030f5:	89 04 24             	mov    %eax,(%esp)
c01030f8:	e8 da ff ff ff       	call   c01030d7 <get_pte>
c01030fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103100:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103104:	74 08                	je     c010310e <get_page+0x31>
        *ptep_store = ptep;
c0103106:	8b 45 10             	mov    0x10(%ebp),%eax
c0103109:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010310c:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010310e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103112:	74 1b                	je     c010312f <get_page+0x52>
c0103114:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103117:	8b 00                	mov    (%eax),%eax
c0103119:	83 e0 01             	and    $0x1,%eax
c010311c:	85 c0                	test   %eax,%eax
c010311e:	74 0f                	je     c010312f <get_page+0x52>
        return pte2page(*ptep);
c0103120:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103123:	8b 00                	mov    (%eax),%eax
c0103125:	89 04 24             	mov    %eax,(%esp)
c0103128:	e8 b3 f6 ff ff       	call   c01027e0 <pte2page>
c010312d:	eb 05                	jmp    c0103134 <get_page+0x57>
    }
    return NULL;
c010312f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103134:	c9                   	leave  
c0103135:	c3                   	ret    

c0103136 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103136:	55                   	push   %ebp
c0103137:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0103139:	90                   	nop
c010313a:	5d                   	pop    %ebp
c010313b:	c3                   	ret    

c010313c <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010313c:	55                   	push   %ebp
c010313d:	89 e5                	mov    %esp,%ebp
c010313f:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103142:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103149:	00 
c010314a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010314d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103151:	8b 45 08             	mov    0x8(%ebp),%eax
c0103154:	89 04 24             	mov    %eax,(%esp)
c0103157:	e8 7b ff ff ff       	call   c01030d7 <get_pte>
c010315c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c010315f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0103163:	74 19                	je     c010317e <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0103165:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103168:	89 44 24 08          	mov    %eax,0x8(%esp)
c010316c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010316f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103173:	8b 45 08             	mov    0x8(%ebp),%eax
c0103176:	89 04 24             	mov    %eax,(%esp)
c0103179:	e8 b8 ff ff ff       	call   c0103136 <page_remove_pte>
    }
}
c010317e:	90                   	nop
c010317f:	c9                   	leave  
c0103180:	c3                   	ret    

c0103181 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0103181:	55                   	push   %ebp
c0103182:	89 e5                	mov    %esp,%ebp
c0103184:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103187:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010318e:	00 
c010318f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103192:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103196:	8b 45 08             	mov    0x8(%ebp),%eax
c0103199:	89 04 24             	mov    %eax,(%esp)
c010319c:	e8 36 ff ff ff       	call   c01030d7 <get_pte>
c01031a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01031a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031a8:	75 0a                	jne    c01031b4 <page_insert+0x33>
        return -E_NO_MEM;
c01031aa:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01031af:	e9 84 00 00 00       	jmp    c0103238 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01031b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031b7:	89 04 24             	mov    %eax,(%esp)
c01031ba:	e8 81 f6 ff ff       	call   c0102840 <page_ref_inc>
    if (*ptep & PTE_P) {
c01031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031c2:	8b 00                	mov    (%eax),%eax
c01031c4:	83 e0 01             	and    $0x1,%eax
c01031c7:	85 c0                	test   %eax,%eax
c01031c9:	74 3e                	je     c0103209 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01031cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031ce:	8b 00                	mov    (%eax),%eax
c01031d0:	89 04 24             	mov    %eax,(%esp)
c01031d3:	e8 08 f6 ff ff       	call   c01027e0 <pte2page>
c01031d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01031db:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031de:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01031e1:	75 0d                	jne    c01031f0 <page_insert+0x6f>
            page_ref_dec(page);
c01031e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031e6:	89 04 24             	mov    %eax,(%esp)
c01031e9:	e8 69 f6 ff ff       	call   c0102857 <page_ref_dec>
c01031ee:	eb 19                	jmp    c0103209 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031f3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01031f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01031fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01031fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0103201:	89 04 24             	mov    %eax,(%esp)
c0103204:	e8 2d ff ff ff       	call   c0103136 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103209:	8b 45 0c             	mov    0xc(%ebp),%eax
c010320c:	89 04 24             	mov    %eax,(%esp)
c010320f:	e8 13 f5 ff ff       	call   c0102727 <page2pa>
c0103214:	0b 45 14             	or     0x14(%ebp),%eax
c0103217:	83 c8 01             	or     $0x1,%eax
c010321a:	89 c2                	mov    %eax,%edx
c010321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010321f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0103221:	8b 45 10             	mov    0x10(%ebp),%eax
c0103224:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103228:	8b 45 08             	mov    0x8(%ebp),%eax
c010322b:	89 04 24             	mov    %eax,(%esp)
c010322e:	e8 07 00 00 00       	call   c010323a <tlb_invalidate>
    return 0;
c0103233:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103238:	c9                   	leave  
c0103239:	c3                   	ret    

c010323a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010323a:	55                   	push   %ebp
c010323b:	89 e5                	mov    %esp,%ebp
c010323d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0103240:	0f 20 d8             	mov    %cr3,%eax
c0103243:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
c0103246:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0103249:	8b 45 08             	mov    0x8(%ebp),%eax
c010324c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010324f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103256:	77 23                	ja     c010327b <tlb_invalidate+0x41>
c0103258:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010325b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010325f:	c7 44 24 08 e4 63 10 	movl   $0xc01063e4,0x8(%esp)
c0103266:	c0 
c0103267:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
c010326e:	00 
c010326f:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103276:	e8 69 d1 ff ff       	call   c01003e4 <__panic>
c010327b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010327e:	05 00 00 00 40       	add    $0x40000000,%eax
c0103283:	39 c2                	cmp    %eax,%edx
c0103285:	75 0c                	jne    c0103293 <tlb_invalidate+0x59>
        invlpg((void *)la);
c0103287:	8b 45 0c             	mov    0xc(%ebp),%eax
c010328a:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103290:	0f 01 38             	invlpg (%eax)
    }
}
c0103293:	90                   	nop
c0103294:	c9                   	leave  
c0103295:	c3                   	ret    

c0103296 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103296:	55                   	push   %ebp
c0103297:	89 e5                	mov    %esp,%ebp
c0103299:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010329c:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c01032a1:	8b 40 18             	mov    0x18(%eax),%eax
c01032a4:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01032a6:	c7 04 24 68 64 10 c0 	movl   $0xc0106468,(%esp)
c01032ad:	e8 db cf ff ff       	call   c010028d <cprintf>
}
c01032b2:	90                   	nop
c01032b3:	c9                   	leave  
c01032b4:	c3                   	ret    

c01032b5 <check_pgdir>:

static void
check_pgdir(void) {
c01032b5:	55                   	push   %ebp
c01032b6:	89 e5                	mov    %esp,%ebp
c01032b8:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01032bb:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01032c0:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01032c5:	76 24                	jbe    c01032eb <check_pgdir+0x36>
c01032c7:	c7 44 24 0c 87 64 10 	movl   $0xc0106487,0xc(%esp)
c01032ce:	c0 
c01032cf:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c01032d6:	c0 
c01032d7:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
c01032de:	00 
c01032df:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01032e6:	e8 f9 d0 ff ff       	call   c01003e4 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01032eb:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01032f0:	85 c0                	test   %eax,%eax
c01032f2:	74 0e                	je     c0103302 <check_pgdir+0x4d>
c01032f4:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01032f9:	25 ff 0f 00 00       	and    $0xfff,%eax
c01032fe:	85 c0                	test   %eax,%eax
c0103300:	74 24                	je     c0103326 <check_pgdir+0x71>
c0103302:	c7 44 24 0c a4 64 10 	movl   $0xc01064a4,0xc(%esp)
c0103309:	c0 
c010330a:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103311:	c0 
c0103312:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
c0103319:	00 
c010331a:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103321:	e8 be d0 ff ff       	call   c01003e4 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103326:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010332b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103332:	00 
c0103333:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010333a:	00 
c010333b:	89 04 24             	mov    %eax,(%esp)
c010333e:	e8 9a fd ff ff       	call   c01030dd <get_page>
c0103343:	85 c0                	test   %eax,%eax
c0103345:	74 24                	je     c010336b <check_pgdir+0xb6>
c0103347:	c7 44 24 0c dc 64 10 	movl   $0xc01064dc,0xc(%esp)
c010334e:	c0 
c010334f:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103356:	c0 
c0103357:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c010335e:	00 
c010335f:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103366:	e8 79 d0 ff ff       	call   c01003e4 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010336b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103372:	e8 b6 f6 ff ff       	call   c0102a2d <alloc_pages>
c0103377:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010337a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010337f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103386:	00 
c0103387:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010338e:	00 
c010338f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103392:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103396:	89 04 24             	mov    %eax,(%esp)
c0103399:	e8 e3 fd ff ff       	call   c0103181 <page_insert>
c010339e:	85 c0                	test   %eax,%eax
c01033a0:	74 24                	je     c01033c6 <check_pgdir+0x111>
c01033a2:	c7 44 24 0c 04 65 10 	movl   $0xc0106504,0xc(%esp)
c01033a9:	c0 
c01033aa:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c01033b1:	c0 
c01033b2:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c01033b9:	00 
c01033ba:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01033c1:	e8 1e d0 ff ff       	call   c01003e4 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01033c6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01033cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01033d2:	00 
c01033d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01033da:	00 
c01033db:	89 04 24             	mov    %eax,(%esp)
c01033de:	e8 f4 fc ff ff       	call   c01030d7 <get_pte>
c01033e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01033ea:	75 24                	jne    c0103410 <check_pgdir+0x15b>
c01033ec:	c7 44 24 0c 30 65 10 	movl   $0xc0106530,0xc(%esp)
c01033f3:	c0 
c01033f4:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c01033fb:	c0 
c01033fc:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c0103403:	00 
c0103404:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c010340b:	e8 d4 cf ff ff       	call   c01003e4 <__panic>
    assert(pte2page(*ptep) == p1);
c0103410:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103413:	8b 00                	mov    (%eax),%eax
c0103415:	89 04 24             	mov    %eax,(%esp)
c0103418:	e8 c3 f3 ff ff       	call   c01027e0 <pte2page>
c010341d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103420:	74 24                	je     c0103446 <check_pgdir+0x191>
c0103422:	c7 44 24 0c 5d 65 10 	movl   $0xc010655d,0xc(%esp)
c0103429:	c0 
c010342a:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103431:	c0 
c0103432:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c0103439:	00 
c010343a:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103441:	e8 9e cf ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p1) == 1);
c0103446:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103449:	89 04 24             	mov    %eax,(%esp)
c010344c:	e8 e5 f3 ff ff       	call   c0102836 <page_ref>
c0103451:	83 f8 01             	cmp    $0x1,%eax
c0103454:	74 24                	je     c010347a <check_pgdir+0x1c5>
c0103456:	c7 44 24 0c 73 65 10 	movl   $0xc0106573,0xc(%esp)
c010345d:	c0 
c010345e:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103465:	c0 
c0103466:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c010346d:	00 
c010346e:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103475:	e8 6a cf ff ff       	call   c01003e4 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010347a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010347f:	8b 00                	mov    (%eax),%eax
c0103481:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103486:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103489:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010348c:	c1 e8 0c             	shr    $0xc,%eax
c010348f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103492:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103497:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010349a:	72 23                	jb     c01034bf <check_pgdir+0x20a>
c010349c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010349f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01034a3:	c7 44 24 08 40 63 10 	movl   $0xc0106340,0x8(%esp)
c01034aa:	c0 
c01034ab:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c01034b2:	00 
c01034b3:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01034ba:	e8 25 cf ff ff       	call   c01003e4 <__panic>
c01034bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034c2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01034c7:	83 c0 04             	add    $0x4,%eax
c01034ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01034cd:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01034d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01034d9:	00 
c01034da:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01034e1:	00 
c01034e2:	89 04 24             	mov    %eax,(%esp)
c01034e5:	e8 ed fb ff ff       	call   c01030d7 <get_pte>
c01034ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01034ed:	74 24                	je     c0103513 <check_pgdir+0x25e>
c01034ef:	c7 44 24 0c 88 65 10 	movl   $0xc0106588,0xc(%esp)
c01034f6:	c0 
c01034f7:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c01034fe:	c0 
c01034ff:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c0103506:	00 
c0103507:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c010350e:	e8 d1 ce ff ff       	call   c01003e4 <__panic>

    p2 = alloc_page();
c0103513:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010351a:	e8 0e f5 ff ff       	call   c0102a2d <alloc_pages>
c010351f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103522:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103527:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010352e:	00 
c010352f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103536:	00 
c0103537:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010353a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010353e:	89 04 24             	mov    %eax,(%esp)
c0103541:	e8 3b fc ff ff       	call   c0103181 <page_insert>
c0103546:	85 c0                	test   %eax,%eax
c0103548:	74 24                	je     c010356e <check_pgdir+0x2b9>
c010354a:	c7 44 24 0c b0 65 10 	movl   $0xc01065b0,0xc(%esp)
c0103551:	c0 
c0103552:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103559:	c0 
c010355a:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c0103561:	00 
c0103562:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103569:	e8 76 ce ff ff       	call   c01003e4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010356e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103573:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010357a:	00 
c010357b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103582:	00 
c0103583:	89 04 24             	mov    %eax,(%esp)
c0103586:	e8 4c fb ff ff       	call   c01030d7 <get_pte>
c010358b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010358e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103592:	75 24                	jne    c01035b8 <check_pgdir+0x303>
c0103594:	c7 44 24 0c e8 65 10 	movl   $0xc01065e8,0xc(%esp)
c010359b:	c0 
c010359c:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c01035a3:	c0 
c01035a4:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c01035ab:	00 
c01035ac:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01035b3:	e8 2c ce ff ff       	call   c01003e4 <__panic>
    assert(*ptep & PTE_U);
c01035b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035bb:	8b 00                	mov    (%eax),%eax
c01035bd:	83 e0 04             	and    $0x4,%eax
c01035c0:	85 c0                	test   %eax,%eax
c01035c2:	75 24                	jne    c01035e8 <check_pgdir+0x333>
c01035c4:	c7 44 24 0c 18 66 10 	movl   $0xc0106618,0xc(%esp)
c01035cb:	c0 
c01035cc:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c01035d3:	c0 
c01035d4:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c01035db:	00 
c01035dc:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01035e3:	e8 fc cd ff ff       	call   c01003e4 <__panic>
    assert(*ptep & PTE_W);
c01035e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035eb:	8b 00                	mov    (%eax),%eax
c01035ed:	83 e0 02             	and    $0x2,%eax
c01035f0:	85 c0                	test   %eax,%eax
c01035f2:	75 24                	jne    c0103618 <check_pgdir+0x363>
c01035f4:	c7 44 24 0c 26 66 10 	movl   $0xc0106626,0xc(%esp)
c01035fb:	c0 
c01035fc:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103603:	c0 
c0103604:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c010360b:	00 
c010360c:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103613:	e8 cc cd ff ff       	call   c01003e4 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103618:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010361d:	8b 00                	mov    (%eax),%eax
c010361f:	83 e0 04             	and    $0x4,%eax
c0103622:	85 c0                	test   %eax,%eax
c0103624:	75 24                	jne    c010364a <check_pgdir+0x395>
c0103626:	c7 44 24 0c 34 66 10 	movl   $0xc0106634,0xc(%esp)
c010362d:	c0 
c010362e:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103635:	c0 
c0103636:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c010363d:	00 
c010363e:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103645:	e8 9a cd ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p2) == 1);
c010364a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010364d:	89 04 24             	mov    %eax,(%esp)
c0103650:	e8 e1 f1 ff ff       	call   c0102836 <page_ref>
c0103655:	83 f8 01             	cmp    $0x1,%eax
c0103658:	74 24                	je     c010367e <check_pgdir+0x3c9>
c010365a:	c7 44 24 0c 4a 66 10 	movl   $0xc010664a,0xc(%esp)
c0103661:	c0 
c0103662:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103669:	c0 
c010366a:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0103671:	00 
c0103672:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103679:	e8 66 cd ff ff       	call   c01003e4 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010367e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103683:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010368a:	00 
c010368b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103692:	00 
c0103693:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103696:	89 54 24 04          	mov    %edx,0x4(%esp)
c010369a:	89 04 24             	mov    %eax,(%esp)
c010369d:	e8 df fa ff ff       	call   c0103181 <page_insert>
c01036a2:	85 c0                	test   %eax,%eax
c01036a4:	74 24                	je     c01036ca <check_pgdir+0x415>
c01036a6:	c7 44 24 0c 5c 66 10 	movl   $0xc010665c,0xc(%esp)
c01036ad:	c0 
c01036ae:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c01036b5:	c0 
c01036b6:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c01036bd:	00 
c01036be:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01036c5:	e8 1a cd ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p1) == 2);
c01036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036cd:	89 04 24             	mov    %eax,(%esp)
c01036d0:	e8 61 f1 ff ff       	call   c0102836 <page_ref>
c01036d5:	83 f8 02             	cmp    $0x2,%eax
c01036d8:	74 24                	je     c01036fe <check_pgdir+0x449>
c01036da:	c7 44 24 0c 88 66 10 	movl   $0xc0106688,0xc(%esp)
c01036e1:	c0 
c01036e2:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c01036e9:	c0 
c01036ea:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c01036f1:	00 
c01036f2:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01036f9:	e8 e6 cc ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p2) == 0);
c01036fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103701:	89 04 24             	mov    %eax,(%esp)
c0103704:	e8 2d f1 ff ff       	call   c0102836 <page_ref>
c0103709:	85 c0                	test   %eax,%eax
c010370b:	74 24                	je     c0103731 <check_pgdir+0x47c>
c010370d:	c7 44 24 0c 9a 66 10 	movl   $0xc010669a,0xc(%esp)
c0103714:	c0 
c0103715:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c010371c:	c0 
c010371d:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0103724:	00 
c0103725:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c010372c:	e8 b3 cc ff ff       	call   c01003e4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103731:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103736:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010373d:	00 
c010373e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103745:	00 
c0103746:	89 04 24             	mov    %eax,(%esp)
c0103749:	e8 89 f9 ff ff       	call   c01030d7 <get_pte>
c010374e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103751:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103755:	75 24                	jne    c010377b <check_pgdir+0x4c6>
c0103757:	c7 44 24 0c e8 65 10 	movl   $0xc01065e8,0xc(%esp)
c010375e:	c0 
c010375f:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103766:	c0 
c0103767:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c010376e:	00 
c010376f:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103776:	e8 69 cc ff ff       	call   c01003e4 <__panic>
    assert(pte2page(*ptep) == p1);
c010377b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010377e:	8b 00                	mov    (%eax),%eax
c0103780:	89 04 24             	mov    %eax,(%esp)
c0103783:	e8 58 f0 ff ff       	call   c01027e0 <pte2page>
c0103788:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010378b:	74 24                	je     c01037b1 <check_pgdir+0x4fc>
c010378d:	c7 44 24 0c 5d 65 10 	movl   $0xc010655d,0xc(%esp)
c0103794:	c0 
c0103795:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c010379c:	c0 
c010379d:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c01037a4:	00 
c01037a5:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01037ac:	e8 33 cc ff ff       	call   c01003e4 <__panic>
    assert((*ptep & PTE_U) == 0);
c01037b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037b4:	8b 00                	mov    (%eax),%eax
c01037b6:	83 e0 04             	and    $0x4,%eax
c01037b9:	85 c0                	test   %eax,%eax
c01037bb:	74 24                	je     c01037e1 <check_pgdir+0x52c>
c01037bd:	c7 44 24 0c ac 66 10 	movl   $0xc01066ac,0xc(%esp)
c01037c4:	c0 
c01037c5:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c01037cc:	c0 
c01037cd:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c01037d4:	00 
c01037d5:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01037dc:	e8 03 cc ff ff       	call   c01003e4 <__panic>

    page_remove(boot_pgdir, 0x0);
c01037e1:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01037e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01037ed:	00 
c01037ee:	89 04 24             	mov    %eax,(%esp)
c01037f1:	e8 46 f9 ff ff       	call   c010313c <page_remove>
    assert(page_ref(p1) == 1);
c01037f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037f9:	89 04 24             	mov    %eax,(%esp)
c01037fc:	e8 35 f0 ff ff       	call   c0102836 <page_ref>
c0103801:	83 f8 01             	cmp    $0x1,%eax
c0103804:	74 24                	je     c010382a <check_pgdir+0x575>
c0103806:	c7 44 24 0c 73 65 10 	movl   $0xc0106573,0xc(%esp)
c010380d:	c0 
c010380e:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103815:	c0 
c0103816:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c010381d:	00 
c010381e:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103825:	e8 ba cb ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p2) == 0);
c010382a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010382d:	89 04 24             	mov    %eax,(%esp)
c0103830:	e8 01 f0 ff ff       	call   c0102836 <page_ref>
c0103835:	85 c0                	test   %eax,%eax
c0103837:	74 24                	je     c010385d <check_pgdir+0x5a8>
c0103839:	c7 44 24 0c 9a 66 10 	movl   $0xc010669a,0xc(%esp)
c0103840:	c0 
c0103841:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103848:	c0 
c0103849:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0103850:	00 
c0103851:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103858:	e8 87 cb ff ff       	call   c01003e4 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c010385d:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103862:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103869:	00 
c010386a:	89 04 24             	mov    %eax,(%esp)
c010386d:	e8 ca f8 ff ff       	call   c010313c <page_remove>
    assert(page_ref(p1) == 0);
c0103872:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103875:	89 04 24             	mov    %eax,(%esp)
c0103878:	e8 b9 ef ff ff       	call   c0102836 <page_ref>
c010387d:	85 c0                	test   %eax,%eax
c010387f:	74 24                	je     c01038a5 <check_pgdir+0x5f0>
c0103881:	c7 44 24 0c c1 66 10 	movl   $0xc01066c1,0xc(%esp)
c0103888:	c0 
c0103889:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103890:	c0 
c0103891:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0103898:	00 
c0103899:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01038a0:	e8 3f cb ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p2) == 0);
c01038a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038a8:	89 04 24             	mov    %eax,(%esp)
c01038ab:	e8 86 ef ff ff       	call   c0102836 <page_ref>
c01038b0:	85 c0                	test   %eax,%eax
c01038b2:	74 24                	je     c01038d8 <check_pgdir+0x623>
c01038b4:	c7 44 24 0c 9a 66 10 	movl   $0xc010669a,0xc(%esp)
c01038bb:	c0 
c01038bc:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c01038c3:	c0 
c01038c4:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c01038cb:	00 
c01038cc:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01038d3:	e8 0c cb ff ff       	call   c01003e4 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c01038d8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01038dd:	8b 00                	mov    (%eax),%eax
c01038df:	89 04 24             	mov    %eax,(%esp)
c01038e2:	e8 37 ef ff ff       	call   c010281e <pde2page>
c01038e7:	89 04 24             	mov    %eax,(%esp)
c01038ea:	e8 47 ef ff ff       	call   c0102836 <page_ref>
c01038ef:	83 f8 01             	cmp    $0x1,%eax
c01038f2:	74 24                	je     c0103918 <check_pgdir+0x663>
c01038f4:	c7 44 24 0c d4 66 10 	movl   $0xc01066d4,0xc(%esp)
c01038fb:	c0 
c01038fc:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103903:	c0 
c0103904:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c010390b:	00 
c010390c:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103913:	e8 cc ca ff ff       	call   c01003e4 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103918:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010391d:	8b 00                	mov    (%eax),%eax
c010391f:	89 04 24             	mov    %eax,(%esp)
c0103922:	e8 f7 ee ff ff       	call   c010281e <pde2page>
c0103927:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010392e:	00 
c010392f:	89 04 24             	mov    %eax,(%esp)
c0103932:	e8 2e f1 ff ff       	call   c0102a65 <free_pages>
    boot_pgdir[0] = 0;
c0103937:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010393c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103942:	c7 04 24 fb 66 10 c0 	movl   $0xc01066fb,(%esp)
c0103949:	e8 3f c9 ff ff       	call   c010028d <cprintf>
}
c010394e:	90                   	nop
c010394f:	c9                   	leave  
c0103950:	c3                   	ret    

c0103951 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103951:	55                   	push   %ebp
c0103952:	89 e5                	mov    %esp,%ebp
c0103954:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103957:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010395e:	e9 ca 00 00 00       	jmp    c0103a2d <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103963:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103966:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103969:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010396c:	c1 e8 0c             	shr    $0xc,%eax
c010396f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103972:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103977:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c010397a:	72 23                	jb     c010399f <check_boot_pgdir+0x4e>
c010397c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010397f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103983:	c7 44 24 08 40 63 10 	movl   $0xc0106340,0x8(%esp)
c010398a:	c0 
c010398b:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0103992:	00 
c0103993:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c010399a:	e8 45 ca ff ff       	call   c01003e4 <__panic>
c010399f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039a2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01039a7:	89 c2                	mov    %eax,%edx
c01039a9:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01039ae:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01039b5:	00 
c01039b6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01039ba:	89 04 24             	mov    %eax,(%esp)
c01039bd:	e8 15 f7 ff ff       	call   c01030d7 <get_pte>
c01039c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01039c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01039c9:	75 24                	jne    c01039ef <check_boot_pgdir+0x9e>
c01039cb:	c7 44 24 0c 18 67 10 	movl   $0xc0106718,0xc(%esp)
c01039d2:	c0 
c01039d3:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c01039da:	c0 
c01039db:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c01039e2:	00 
c01039e3:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01039ea:	e8 f5 c9 ff ff       	call   c01003e4 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01039ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01039f2:	8b 00                	mov    (%eax),%eax
c01039f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01039f9:	89 c2                	mov    %eax,%edx
c01039fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039fe:	39 c2                	cmp    %eax,%edx
c0103a00:	74 24                	je     c0103a26 <check_boot_pgdir+0xd5>
c0103a02:	c7 44 24 0c 55 67 10 	movl   $0xc0106755,0xc(%esp)
c0103a09:	c0 
c0103a0a:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103a11:	c0 
c0103a12:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0103a19:	00 
c0103a1a:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103a21:	e8 be c9 ff ff       	call   c01003e4 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103a26:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103a30:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103a35:	39 c2                	cmp    %eax,%edx
c0103a37:	0f 82 26 ff ff ff    	jb     c0103963 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103a3d:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103a42:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103a47:	8b 00                	mov    (%eax),%eax
c0103a49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a4e:	89 c2                	mov    %eax,%edx
c0103a50:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103a55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a58:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103a5f:	77 23                	ja     c0103a84 <check_boot_pgdir+0x133>
c0103a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a64:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103a68:	c7 44 24 08 e4 63 10 	movl   $0xc01063e4,0x8(%esp)
c0103a6f:	c0 
c0103a70:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103a77:	00 
c0103a78:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103a7f:	e8 60 c9 ff ff       	call   c01003e4 <__panic>
c0103a84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a87:	05 00 00 00 40       	add    $0x40000000,%eax
c0103a8c:	39 c2                	cmp    %eax,%edx
c0103a8e:	74 24                	je     c0103ab4 <check_boot_pgdir+0x163>
c0103a90:	c7 44 24 0c 6c 67 10 	movl   $0xc010676c,0xc(%esp)
c0103a97:	c0 
c0103a98:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103a9f:	c0 
c0103aa0:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103aa7:	00 
c0103aa8:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103aaf:	e8 30 c9 ff ff       	call   c01003e4 <__panic>

    assert(boot_pgdir[0] == 0);
c0103ab4:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103ab9:	8b 00                	mov    (%eax),%eax
c0103abb:	85 c0                	test   %eax,%eax
c0103abd:	74 24                	je     c0103ae3 <check_boot_pgdir+0x192>
c0103abf:	c7 44 24 0c a0 67 10 	movl   $0xc01067a0,0xc(%esp)
c0103ac6:	c0 
c0103ac7:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103ace:	c0 
c0103acf:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0103ad6:	00 
c0103ad7:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103ade:	e8 01 c9 ff ff       	call   c01003e4 <__panic>

    struct Page *p;
    p = alloc_page();
c0103ae3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103aea:	e8 3e ef ff ff       	call   c0102a2d <alloc_pages>
c0103aef:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103af2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103af7:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103afe:	00 
c0103aff:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0103b06:	00 
c0103b07:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103b0a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103b0e:	89 04 24             	mov    %eax,(%esp)
c0103b11:	e8 6b f6 ff ff       	call   c0103181 <page_insert>
c0103b16:	85 c0                	test   %eax,%eax
c0103b18:	74 24                	je     c0103b3e <check_boot_pgdir+0x1ed>
c0103b1a:	c7 44 24 0c b4 67 10 	movl   $0xc01067b4,0xc(%esp)
c0103b21:	c0 
c0103b22:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103b29:	c0 
c0103b2a:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0103b31:	00 
c0103b32:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103b39:	e8 a6 c8 ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p) == 1);
c0103b3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103b41:	89 04 24             	mov    %eax,(%esp)
c0103b44:	e8 ed ec ff ff       	call   c0102836 <page_ref>
c0103b49:	83 f8 01             	cmp    $0x1,%eax
c0103b4c:	74 24                	je     c0103b72 <check_boot_pgdir+0x221>
c0103b4e:	c7 44 24 0c e2 67 10 	movl   $0xc01067e2,0xc(%esp)
c0103b55:	c0 
c0103b56:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103b5d:	c0 
c0103b5e:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0103b65:	00 
c0103b66:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103b6d:	e8 72 c8 ff ff       	call   c01003e4 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103b72:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103b77:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103b7e:	00 
c0103b7f:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0103b86:	00 
c0103b87:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103b8a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103b8e:	89 04 24             	mov    %eax,(%esp)
c0103b91:	e8 eb f5 ff ff       	call   c0103181 <page_insert>
c0103b96:	85 c0                	test   %eax,%eax
c0103b98:	74 24                	je     c0103bbe <check_boot_pgdir+0x26d>
c0103b9a:	c7 44 24 0c f4 67 10 	movl   $0xc01067f4,0xc(%esp)
c0103ba1:	c0 
c0103ba2:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103ba9:	c0 
c0103baa:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0103bb1:	00 
c0103bb2:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103bb9:	e8 26 c8 ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p) == 2);
c0103bbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103bc1:	89 04 24             	mov    %eax,(%esp)
c0103bc4:	e8 6d ec ff ff       	call   c0102836 <page_ref>
c0103bc9:	83 f8 02             	cmp    $0x2,%eax
c0103bcc:	74 24                	je     c0103bf2 <check_boot_pgdir+0x2a1>
c0103bce:	c7 44 24 0c 2b 68 10 	movl   $0xc010682b,0xc(%esp)
c0103bd5:	c0 
c0103bd6:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103bdd:	c0 
c0103bde:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0103be5:	00 
c0103be6:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103bed:	e8 f2 c7 ff ff       	call   c01003e4 <__panic>

    const char *str = "ucore: Hello world!!";
c0103bf2:	c7 45 dc 3c 68 10 c0 	movl   $0xc010683c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0103bf9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c00:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103c07:	e8 4b 15 00 00       	call   c0105157 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103c0c:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0103c13:	00 
c0103c14:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103c1b:	e8 ae 15 00 00       	call   c01051ce <strcmp>
c0103c20:	85 c0                	test   %eax,%eax
c0103c22:	74 24                	je     c0103c48 <check_boot_pgdir+0x2f7>
c0103c24:	c7 44 24 0c 54 68 10 	movl   $0xc0106854,0xc(%esp)
c0103c2b:	c0 
c0103c2c:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103c33:	c0 
c0103c34:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0103c3b:	00 
c0103c3c:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103c43:	e8 9c c7 ff ff       	call   c01003e4 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103c48:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c4b:	89 04 24             	mov    %eax,(%esp)
c0103c4e:	e8 39 eb ff ff       	call   c010278c <page2kva>
c0103c53:	05 00 01 00 00       	add    $0x100,%eax
c0103c58:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103c5b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103c62:	e8 9a 14 00 00       	call   c0105101 <strlen>
c0103c67:	85 c0                	test   %eax,%eax
c0103c69:	74 24                	je     c0103c8f <check_boot_pgdir+0x33e>
c0103c6b:	c7 44 24 0c 8c 68 10 	movl   $0xc010688c,0xc(%esp)
c0103c72:	c0 
c0103c73:	c7 44 24 08 2d 64 10 	movl   $0xc010642d,0x8(%esp)
c0103c7a:	c0 
c0103c7b:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0103c82:	00 
c0103c83:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c0103c8a:	e8 55 c7 ff ff       	call   c01003e4 <__panic>

    free_page(p);
c0103c8f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c96:	00 
c0103c97:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c9a:	89 04 24             	mov    %eax,(%esp)
c0103c9d:	e8 c3 ed ff ff       	call   c0102a65 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0103ca2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103ca7:	8b 00                	mov    (%eax),%eax
c0103ca9:	89 04 24             	mov    %eax,(%esp)
c0103cac:	e8 6d eb ff ff       	call   c010281e <pde2page>
c0103cb1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103cb8:	00 
c0103cb9:	89 04 24             	mov    %eax,(%esp)
c0103cbc:	e8 a4 ed ff ff       	call   c0102a65 <free_pages>
    boot_pgdir[0] = 0;
c0103cc1:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103cc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103ccc:	c7 04 24 b0 68 10 c0 	movl   $0xc01068b0,(%esp)
c0103cd3:	e8 b5 c5 ff ff       	call   c010028d <cprintf>
}
c0103cd8:	90                   	nop
c0103cd9:	c9                   	leave  
c0103cda:	c3                   	ret    

c0103cdb <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103cdb:	55                   	push   %ebp
c0103cdc:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103cde:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ce1:	83 e0 04             	and    $0x4,%eax
c0103ce4:	85 c0                	test   %eax,%eax
c0103ce6:	74 04                	je     c0103cec <perm2str+0x11>
c0103ce8:	b0 75                	mov    $0x75,%al
c0103cea:	eb 02                	jmp    c0103cee <perm2str+0x13>
c0103cec:	b0 2d                	mov    $0x2d,%al
c0103cee:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c0103cf3:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103cfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cfd:	83 e0 02             	and    $0x2,%eax
c0103d00:	85 c0                	test   %eax,%eax
c0103d02:	74 04                	je     c0103d08 <perm2str+0x2d>
c0103d04:	b0 77                	mov    $0x77,%al
c0103d06:	eb 02                	jmp    c0103d0a <perm2str+0x2f>
c0103d08:	b0 2d                	mov    $0x2d,%al
c0103d0a:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c0103d0f:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c0103d16:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c0103d1b:	5d                   	pop    %ebp
c0103d1c:	c3                   	ret    

c0103d1d <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0103d1d:	55                   	push   %ebp
c0103d1e:	89 e5                	mov    %esp,%ebp
c0103d20:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0103d23:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d26:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103d29:	72 0d                	jb     c0103d38 <get_pgtable_items+0x1b>
        return 0;
c0103d2b:	b8 00 00 00 00       	mov    $0x0,%eax
c0103d30:	e9 98 00 00 00       	jmp    c0103dcd <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0103d35:	ff 45 10             	incl   0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0103d38:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d3b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103d3e:	73 18                	jae    c0103d58 <get_pgtable_items+0x3b>
c0103d40:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103d4a:	8b 45 14             	mov    0x14(%ebp),%eax
c0103d4d:	01 d0                	add    %edx,%eax
c0103d4f:	8b 00                	mov    (%eax),%eax
c0103d51:	83 e0 01             	and    $0x1,%eax
c0103d54:	85 c0                	test   %eax,%eax
c0103d56:	74 dd                	je     c0103d35 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0103d58:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d5b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103d5e:	73 68                	jae    c0103dc8 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0103d60:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0103d64:	74 08                	je     c0103d6e <get_pgtable_items+0x51>
            *left_store = start;
c0103d66:	8b 45 18             	mov    0x18(%ebp),%eax
c0103d69:	8b 55 10             	mov    0x10(%ebp),%edx
c0103d6c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0103d6e:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d71:	8d 50 01             	lea    0x1(%eax),%edx
c0103d74:	89 55 10             	mov    %edx,0x10(%ebp)
c0103d77:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103d7e:	8b 45 14             	mov    0x14(%ebp),%eax
c0103d81:	01 d0                	add    %edx,%eax
c0103d83:	8b 00                	mov    (%eax),%eax
c0103d85:	83 e0 07             	and    $0x7,%eax
c0103d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103d8b:	eb 03                	jmp    c0103d90 <get_pgtable_items+0x73>
            start ++;
c0103d8d:	ff 45 10             	incl   0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0103d90:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d93:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0103d96:	73 1d                	jae    c0103db5 <get_pgtable_items+0x98>
c0103d98:	8b 45 10             	mov    0x10(%ebp),%eax
c0103d9b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103da2:	8b 45 14             	mov    0x14(%ebp),%eax
c0103da5:	01 d0                	add    %edx,%eax
c0103da7:	8b 00                	mov    (%eax),%eax
c0103da9:	83 e0 07             	and    $0x7,%eax
c0103dac:	89 c2                	mov    %eax,%edx
c0103dae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103db1:	39 c2                	cmp    %eax,%edx
c0103db3:	74 d8                	je     c0103d8d <get_pgtable_items+0x70>
            start ++;
        }
        if (right_store != NULL) {
c0103db5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0103db9:	74 08                	je     c0103dc3 <get_pgtable_items+0xa6>
            *right_store = start;
c0103dbb:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0103dbe:	8b 55 10             	mov    0x10(%ebp),%edx
c0103dc1:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0103dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103dc6:	eb 05                	jmp    c0103dcd <get_pgtable_items+0xb0>
    }
    return 0;
c0103dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103dcd:	c9                   	leave  
c0103dce:	c3                   	ret    

c0103dcf <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0103dcf:	55                   	push   %ebp
c0103dd0:	89 e5                	mov    %esp,%ebp
c0103dd2:	57                   	push   %edi
c0103dd3:	56                   	push   %esi
c0103dd4:	53                   	push   %ebx
c0103dd5:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0103dd8:	c7 04 24 d0 68 10 c0 	movl   $0xc01068d0,(%esp)
c0103ddf:	e8 a9 c4 ff ff       	call   c010028d <cprintf>
    size_t left, right = 0, perm;
c0103de4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103deb:	e9 fa 00 00 00       	jmp    c0103eea <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103df0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103df3:	89 04 24             	mov    %eax,(%esp)
c0103df6:	e8 e0 fe ff ff       	call   c0103cdb <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0103dfb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0103dfe:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103e01:	29 d1                	sub    %edx,%ecx
c0103e03:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0103e05:	89 d6                	mov    %edx,%esi
c0103e07:	c1 e6 16             	shl    $0x16,%esi
c0103e0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e0d:	89 d3                	mov    %edx,%ebx
c0103e0f:	c1 e3 16             	shl    $0x16,%ebx
c0103e12:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103e15:	89 d1                	mov    %edx,%ecx
c0103e17:	c1 e1 16             	shl    $0x16,%ecx
c0103e1a:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0103e1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103e20:	29 d7                	sub    %edx,%edi
c0103e22:	89 fa                	mov    %edi,%edx
c0103e24:	89 44 24 14          	mov    %eax,0x14(%esp)
c0103e28:	89 74 24 10          	mov    %esi,0x10(%esp)
c0103e2c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0103e30:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0103e34:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e38:	c7 04 24 01 69 10 c0 	movl   $0xc0106901,(%esp)
c0103e3f:	e8 49 c4 ff ff       	call   c010028d <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0103e44:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e47:	c1 e0 0a             	shl    $0xa,%eax
c0103e4a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103e4d:	eb 54                	jmp    c0103ea3 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e52:	89 04 24             	mov    %eax,(%esp)
c0103e55:	e8 81 fe ff ff       	call   c0103cdb <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0103e5a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103e5d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103e60:	29 d1                	sub    %edx,%ecx
c0103e62:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0103e64:	89 d6                	mov    %edx,%esi
c0103e66:	c1 e6 0c             	shl    $0xc,%esi
c0103e69:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103e6c:	89 d3                	mov    %edx,%ebx
c0103e6e:	c1 e3 0c             	shl    $0xc,%ebx
c0103e71:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103e74:	89 d1                	mov    %edx,%ecx
c0103e76:	c1 e1 0c             	shl    $0xc,%ecx
c0103e79:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0103e7c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103e7f:	29 d7                	sub    %edx,%edi
c0103e81:	89 fa                	mov    %edi,%edx
c0103e83:	89 44 24 14          	mov    %eax,0x14(%esp)
c0103e87:	89 74 24 10          	mov    %esi,0x10(%esp)
c0103e8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0103e8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0103e93:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e97:	c7 04 24 20 69 10 c0 	movl   $0xc0106920,(%esp)
c0103e9e:	e8 ea c3 ff ff       	call   c010028d <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0103ea3:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0103ea8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103eab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103eae:	89 d3                	mov    %edx,%ebx
c0103eb0:	c1 e3 0a             	shl    $0xa,%ebx
c0103eb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103eb6:	89 d1                	mov    %edx,%ecx
c0103eb8:	c1 e1 0a             	shl    $0xa,%ecx
c0103ebb:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0103ebe:	89 54 24 14          	mov    %edx,0x14(%esp)
c0103ec2:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0103ec5:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103ec9:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0103ecd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103ed1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0103ed5:	89 0c 24             	mov    %ecx,(%esp)
c0103ed8:	e8 40 fe ff ff       	call   c0103d1d <get_pgtable_items>
c0103edd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ee0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ee4:	0f 85 65 ff ff ff    	jne    c0103e4f <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0103eea:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0103eef:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ef2:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0103ef5:	89 54 24 14          	mov    %edx,0x14(%esp)
c0103ef9:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0103efc:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103f00:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0103f04:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103f08:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0103f0f:	00 
c0103f10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0103f17:	e8 01 fe ff ff       	call   c0103d1d <get_pgtable_items>
c0103f1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103f1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f23:	0f 85 c7 fe ff ff    	jne    c0103df0 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0103f29:	c7 04 24 44 69 10 c0 	movl   $0xc0106944,(%esp)
c0103f30:	e8 58 c3 ff ff       	call   c010028d <cprintf>
}
c0103f35:	90                   	nop
c0103f36:	83 c4 4c             	add    $0x4c,%esp
c0103f39:	5b                   	pop    %ebx
c0103f3a:	5e                   	pop    %esi
c0103f3b:	5f                   	pop    %edi
c0103f3c:	5d                   	pop    %ebp
c0103f3d:	c3                   	ret    

c0103f3e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103f3e:	55                   	push   %ebp
c0103f3f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103f41:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f44:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0103f4a:	29 d0                	sub    %edx,%eax
c0103f4c:	c1 f8 02             	sar    $0x2,%eax
c0103f4f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103f55:	5d                   	pop    %ebp
c0103f56:	c3                   	ret    

c0103f57 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103f57:	55                   	push   %ebp
c0103f58:	89 e5                	mov    %esp,%ebp
c0103f5a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103f5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f60:	89 04 24             	mov    %eax,(%esp)
c0103f63:	e8 d6 ff ff ff       	call   c0103f3e <page2ppn>
c0103f68:	c1 e0 0c             	shl    $0xc,%eax
}
c0103f6b:	c9                   	leave  
c0103f6c:	c3                   	ret    

c0103f6d <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103f6d:	55                   	push   %ebp
c0103f6e:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103f70:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f73:	8b 00                	mov    (%eax),%eax
}
c0103f75:	5d                   	pop    %ebp
c0103f76:	c3                   	ret    

c0103f77 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103f77:	55                   	push   %ebp
c0103f78:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103f7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f7d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f80:	89 10                	mov    %edx,(%eax)
}
c0103f82:	90                   	nop
c0103f83:	5d                   	pop    %ebp
c0103f84:	c3                   	ret    

c0103f85 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103f85:	55                   	push   %ebp
c0103f86:	89 e5                	mov    %esp,%ebp
c0103f88:	83 ec 10             	sub    $0x10,%esp
c0103f8b:	c7 45 fc 1c af 11 c0 	movl   $0xc011af1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103f92:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f95:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103f98:	89 50 04             	mov    %edx,0x4(%eax)
c0103f9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f9e:	8b 50 04             	mov    0x4(%eax),%edx
c0103fa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103fa4:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103fa6:	c7 05 24 af 11 c0 00 	movl   $0x0,0xc011af24
c0103fad:	00 00 00 
}
c0103fb0:	90                   	nop
c0103fb1:	c9                   	leave  
c0103fb2:	c3                   	ret    

c0103fb3 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0103fb3:	55                   	push   %ebp
c0103fb4:	89 e5                	mov    %esp,%ebp
c0103fb6:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0103fb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103fbd:	75 24                	jne    c0103fe3 <default_init_memmap+0x30>
c0103fbf:	c7 44 24 0c 78 69 10 	movl   $0xc0106978,0xc(%esp)
c0103fc6:	c0 
c0103fc7:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0103fce:	c0 
c0103fcf:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0103fd6:	00 
c0103fd7:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0103fde:	e8 01 c4 ff ff       	call   c01003e4 <__panic>
    struct Page *p = base;
c0103fe3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103fe9:	eb 7d                	jmp    c0104068 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0103feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fee:	83 c0 04             	add    $0x4,%eax
c0103ff1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0103ff8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ffb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ffe:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104001:	0f a3 10             	bt     %edx,(%eax)
c0104004:	19 c0                	sbb    %eax,%eax
c0104006:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
c0104009:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010400d:	0f 95 c0             	setne  %al
c0104010:	0f b6 c0             	movzbl %al,%eax
c0104013:	85 c0                	test   %eax,%eax
c0104015:	75 24                	jne    c010403b <default_init_memmap+0x88>
c0104017:	c7 44 24 0c a9 69 10 	movl   $0xc01069a9,0xc(%esp)
c010401e:	c0 
c010401f:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104026:	c0 
c0104027:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010402e:	00 
c010402f:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104036:	e8 a9 c3 ff ff       	call   c01003e4 <__panic>
        p->flags = p->property = 0;
c010403b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010403e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104045:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104048:	8b 50 08             	mov    0x8(%eax),%edx
c010404b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010404e:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0104051:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104058:	00 
c0104059:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010405c:	89 04 24             	mov    %eax,(%esp)
c010405f:	e8 13 ff ff ff       	call   c0103f77 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0104064:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104068:	8b 55 0c             	mov    0xc(%ebp),%edx
c010406b:	89 d0                	mov    %edx,%eax
c010406d:	c1 e0 02             	shl    $0x2,%eax
c0104070:	01 d0                	add    %edx,%eax
c0104072:	c1 e0 02             	shl    $0x2,%eax
c0104075:	89 c2                	mov    %eax,%edx
c0104077:	8b 45 08             	mov    0x8(%ebp),%eax
c010407a:	01 d0                	add    %edx,%eax
c010407c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010407f:	0f 85 66 ff ff ff    	jne    c0103feb <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0104085:	8b 45 08             	mov    0x8(%ebp),%eax
c0104088:	8b 55 0c             	mov    0xc(%ebp),%edx
c010408b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010408e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104091:	83 c0 04             	add    $0x4,%eax
c0104094:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c010409b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010409e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01040a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01040a4:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c01040a7:	8b 15 24 af 11 c0    	mov    0xc011af24,%edx
c01040ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01040b0:	01 d0                	add    %edx,%eax
c01040b2:	a3 24 af 11 c0       	mov    %eax,0xc011af24
    list_add(&free_list, &(base->page_link));
c01040b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01040ba:	83 c0 0c             	add    $0xc,%eax
c01040bd:	c7 45 f0 1c af 11 c0 	movl   $0xc011af1c,-0x10(%ebp)
c01040c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01040c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01040cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01040d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040d6:	8b 40 04             	mov    0x4(%eax),%eax
c01040d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040dc:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01040df:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01040e2:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01040e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01040e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01040ee:	89 10                	mov    %edx,(%eax)
c01040f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040f3:	8b 10                	mov    (%eax),%edx
c01040f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01040f8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01040fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040fe:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104101:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104104:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104107:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010410a:	89 10                	mov    %edx,(%eax)
}
c010410c:	90                   	nop
c010410d:	c9                   	leave  
c010410e:	c3                   	ret    

c010410f <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c010410f:	55                   	push   %ebp
c0104110:	89 e5                	mov    %esp,%ebp
c0104112:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0104115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104119:	75 24                	jne    c010413f <default_alloc_pages+0x30>
c010411b:	c7 44 24 0c 78 69 10 	movl   $0xc0106978,0xc(%esp)
c0104122:	c0 
c0104123:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c010412a:	c0 
c010412b:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0104132:	00 
c0104133:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c010413a:	e8 a5 c2 ff ff       	call   c01003e4 <__panic>
    if (n > nr_free) {
c010413f:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104144:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104147:	73 0a                	jae    c0104153 <default_alloc_pages+0x44>
        return NULL;
c0104149:	b8 00 00 00 00       	mov    $0x0,%eax
c010414e:	e9 2a 01 00 00       	jmp    c010427d <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
c0104153:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c010415a:	c7 45 f0 1c af 11 c0 	movl   $0xc011af1c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104161:	eb 1c                	jmp    c010417f <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0104163:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104166:	83 e8 0c             	sub    $0xc,%eax
c0104169:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
c010416c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010416f:	8b 40 08             	mov    0x8(%eax),%eax
c0104172:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104175:	72 08                	jb     c010417f <default_alloc_pages+0x70>
            page = p;
c0104177:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010417a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010417d:	eb 18                	jmp    c0104197 <default_alloc_pages+0x88>
c010417f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104182:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104185:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104188:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010418b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010418e:	81 7d f0 1c af 11 c0 	cmpl   $0xc011af1c,-0x10(%ebp)
c0104195:	75 cc                	jne    c0104163 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0104197:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010419b:	0f 84 d9 00 00 00    	je     c010427a <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
c01041a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041a4:	83 c0 0c             	add    $0xc,%eax
c01041a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01041aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041ad:	8b 40 04             	mov    0x4(%eax),%eax
c01041b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01041b3:	8b 12                	mov    (%edx),%edx
c01041b5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01041b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01041bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01041be:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01041c1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01041c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01041ca:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c01041cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041cf:	8b 40 08             	mov    0x8(%eax),%eax
c01041d2:	3b 45 08             	cmp    0x8(%ebp),%eax
c01041d5:	76 7d                	jbe    c0104254 <default_alloc_pages+0x145>
            struct Page *p = page + n;
c01041d7:	8b 55 08             	mov    0x8(%ebp),%edx
c01041da:	89 d0                	mov    %edx,%eax
c01041dc:	c1 e0 02             	shl    $0x2,%eax
c01041df:	01 d0                	add    %edx,%eax
c01041e1:	c1 e0 02             	shl    $0x2,%eax
c01041e4:	89 c2                	mov    %eax,%edx
c01041e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041e9:	01 d0                	add    %edx,%eax
c01041eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
            p->property = page->property - n;
c01041ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041f1:	8b 40 08             	mov    0x8(%eax),%eax
c01041f4:	2b 45 08             	sub    0x8(%ebp),%eax
c01041f7:	89 c2                	mov    %eax,%edx
c01041f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041fc:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c01041ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104202:	83 c0 0c             	add    $0xc,%eax
c0104205:	c7 45 e4 1c af 11 c0 	movl   $0xc011af1c,-0x1c(%ebp)
c010420c:	89 45 cc             	mov    %eax,-0x34(%ebp)
c010420f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104212:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104215:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104218:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010421b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010421e:	8b 40 04             	mov    0x4(%eax),%eax
c0104221:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104224:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104227:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010422a:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010422d:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104230:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104233:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104236:	89 10                	mov    %edx,(%eax)
c0104238:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010423b:	8b 10                	mov    (%eax),%edx
c010423d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104240:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104243:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104246:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104249:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010424c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010424f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104252:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c0104254:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104259:	2b 45 08             	sub    0x8(%ebp),%eax
c010425c:	a3 24 af 11 c0       	mov    %eax,0xc011af24
        ClearPageProperty(page);
c0104261:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104264:	83 c0 04             	add    $0x4,%eax
c0104267:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c010426e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104271:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104274:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104277:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c010427a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010427d:	c9                   	leave  
c010427e:	c3                   	ret    

c010427f <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c010427f:	55                   	push   %ebp
c0104280:	89 e5                	mov    %esp,%ebp
c0104282:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0104288:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010428c:	75 24                	jne    c01042b2 <default_free_pages+0x33>
c010428e:	c7 44 24 0c 78 69 10 	movl   $0xc0106978,0xc(%esp)
c0104295:	c0 
c0104296:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c010429d:	c0 
c010429e:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c01042a5:	00 
c01042a6:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c01042ad:	e8 32 c1 ff ff       	call   c01003e4 <__panic>
    struct Page *p = base;
c01042b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01042b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01042b8:	e9 9d 00 00 00       	jmp    c010435a <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c01042bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042c0:	83 c0 04             	add    $0x4,%eax
c01042c3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
c01042ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01042cd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01042d0:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01042d3:	0f a3 10             	bt     %edx,(%eax)
c01042d6:	19 c0                	sbb    %eax,%eax
c01042d8:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return oldbit != 0;
c01042db:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c01042df:	0f 95 c0             	setne  %al
c01042e2:	0f b6 c0             	movzbl %al,%eax
c01042e5:	85 c0                	test   %eax,%eax
c01042e7:	75 2c                	jne    c0104315 <default_free_pages+0x96>
c01042e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042ec:	83 c0 04             	add    $0x4,%eax
c01042ef:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
c01042f6:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01042f9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01042fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01042ff:	0f a3 10             	bt     %edx,(%eax)
c0104302:	19 c0                	sbb    %eax,%eax
c0104304:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104307:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010430b:	0f 95 c0             	setne  %al
c010430e:	0f b6 c0             	movzbl %al,%eax
c0104311:	85 c0                	test   %eax,%eax
c0104313:	74 24                	je     c0104339 <default_free_pages+0xba>
c0104315:	c7 44 24 0c bc 69 10 	movl   $0xc01069bc,0xc(%esp)
c010431c:	c0 
c010431d:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104324:	c0 
c0104325:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c010432c:	00 
c010432d:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104334:	e8 ab c0 ff ff       	call   c01003e4 <__panic>
        p->flags = 0;
c0104339:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010433c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0104343:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010434a:	00 
c010434b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434e:	89 04 24             	mov    %eax,(%esp)
c0104351:	e8 21 fc ff ff       	call   c0103f77 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0104356:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c010435a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010435d:	89 d0                	mov    %edx,%eax
c010435f:	c1 e0 02             	shl    $0x2,%eax
c0104362:	01 d0                	add    %edx,%eax
c0104364:	c1 e0 02             	shl    $0x2,%eax
c0104367:	89 c2                	mov    %eax,%edx
c0104369:	8b 45 08             	mov    0x8(%ebp),%eax
c010436c:	01 d0                	add    %edx,%eax
c010436e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104371:	0f 85 46 ff ff ff    	jne    c01042bd <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0104377:	8b 45 08             	mov    0x8(%ebp),%eax
c010437a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010437d:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104380:	8b 45 08             	mov    0x8(%ebp),%eax
c0104383:	83 c0 04             	add    $0x4,%eax
c0104386:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010438d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104390:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104393:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104396:	0f ab 10             	bts    %edx,(%eax)
c0104399:	c7 45 e8 1c af 11 c0 	movl   $0xc011af1c,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01043a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043a3:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c01043a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c01043a9:	e9 08 01 00 00       	jmp    c01044b6 <default_free_pages+0x237>
        p = le2page(le, page_link);
c01043ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043b1:	83 e8 0c             	sub    $0xc,%eax
c01043b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043c0:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01043c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c01043c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01043c9:	8b 50 08             	mov    0x8(%eax),%edx
c01043cc:	89 d0                	mov    %edx,%eax
c01043ce:	c1 e0 02             	shl    $0x2,%eax
c01043d1:	01 d0                	add    %edx,%eax
c01043d3:	c1 e0 02             	shl    $0x2,%eax
c01043d6:	89 c2                	mov    %eax,%edx
c01043d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01043db:	01 d0                	add    %edx,%eax
c01043dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01043e0:	75 5a                	jne    c010443c <default_free_pages+0x1bd>
            base->property += p->property;
c01043e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01043e5:	8b 50 08             	mov    0x8(%eax),%edx
c01043e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043eb:	8b 40 08             	mov    0x8(%eax),%eax
c01043ee:	01 c2                	add    %eax,%edx
c01043f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01043f3:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c01043f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043f9:	83 c0 04             	add    $0x4,%eax
c01043fc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104403:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104406:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104409:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010440c:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c010440f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104412:	83 c0 0c             	add    $0xc,%eax
c0104415:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104418:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010441b:	8b 40 04             	mov    0x4(%eax),%eax
c010441e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104421:	8b 12                	mov    (%edx),%edx
c0104423:	89 55 b0             	mov    %edx,-0x50(%ebp)
c0104426:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0104429:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010442c:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010442f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104432:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104435:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104438:	89 10                	mov    %edx,(%eax)
c010443a:	eb 7a                	jmp    c01044b6 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c010443c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010443f:	8b 50 08             	mov    0x8(%eax),%edx
c0104442:	89 d0                	mov    %edx,%eax
c0104444:	c1 e0 02             	shl    $0x2,%eax
c0104447:	01 d0                	add    %edx,%eax
c0104449:	c1 e0 02             	shl    $0x2,%eax
c010444c:	89 c2                	mov    %eax,%edx
c010444e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104451:	01 d0                	add    %edx,%eax
c0104453:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104456:	75 5e                	jne    c01044b6 <default_free_pages+0x237>
            p->property += base->property;
c0104458:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010445b:	8b 50 08             	mov    0x8(%eax),%edx
c010445e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104461:	8b 40 08             	mov    0x8(%eax),%eax
c0104464:	01 c2                	add    %eax,%edx
c0104466:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104469:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c010446c:	8b 45 08             	mov    0x8(%ebp),%eax
c010446f:	83 c0 04             	add    $0x4,%eax
c0104472:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0104479:	89 45 9c             	mov    %eax,-0x64(%ebp)
c010447c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010447f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104482:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0104485:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104488:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c010448b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010448e:	83 c0 0c             	add    $0xc,%eax
c0104491:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0104494:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104497:	8b 40 04             	mov    0x4(%eax),%eax
c010449a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010449d:	8b 12                	mov    (%edx),%edx
c010449f:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c01044a2:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01044a5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01044a8:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01044ab:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01044ae:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01044b1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01044b4:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c01044b6:	81 7d f0 1c af 11 c0 	cmpl   $0xc011af1c,-0x10(%ebp)
c01044bd:	0f 85 eb fe ff ff    	jne    c01043ae <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c01044c3:	8b 15 24 af 11 c0    	mov    0xc011af24,%edx
c01044c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044cc:	01 d0                	add    %edx,%eax
c01044ce:	a3 24 af 11 c0       	mov    %eax,0xc011af24
    list_add(&free_list, &(base->page_link));
c01044d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d6:	83 c0 0c             	add    $0xc,%eax
c01044d9:	c7 45 d0 1c af 11 c0 	movl   $0xc011af1c,-0x30(%ebp)
c01044e0:	89 45 98             	mov    %eax,-0x68(%ebp)
c01044e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01044e6:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01044e9:	8b 45 98             	mov    -0x68(%ebp),%eax
c01044ec:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01044ef:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01044f2:	8b 40 04             	mov    0x4(%eax),%eax
c01044f5:	8b 55 90             	mov    -0x70(%ebp),%edx
c01044f8:	89 55 8c             	mov    %edx,-0x74(%ebp)
c01044fb:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01044fe:	89 55 88             	mov    %edx,-0x78(%ebp)
c0104501:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0104504:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0104507:	8b 55 8c             	mov    -0x74(%ebp),%edx
c010450a:	89 10                	mov    %edx,(%eax)
c010450c:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010450f:	8b 10                	mov    (%eax),%edx
c0104511:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104514:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104517:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010451a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010451d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104520:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104523:	8b 55 88             	mov    -0x78(%ebp),%edx
c0104526:	89 10                	mov    %edx,(%eax)
}
c0104528:	90                   	nop
c0104529:	c9                   	leave  
c010452a:	c3                   	ret    

c010452b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010452b:	55                   	push   %ebp
c010452c:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010452e:	a1 24 af 11 c0       	mov    0xc011af24,%eax
}
c0104533:	5d                   	pop    %ebp
c0104534:	c3                   	ret    

c0104535 <basic_check>:

static void
basic_check(void) {
c0104535:	55                   	push   %ebp
c0104536:	89 e5                	mov    %esp,%ebp
c0104538:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010453b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104542:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104545:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104548:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010454b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010454e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104555:	e8 d3 e4 ff ff       	call   c0102a2d <alloc_pages>
c010455a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010455d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104561:	75 24                	jne    c0104587 <basic_check+0x52>
c0104563:	c7 44 24 0c e1 69 10 	movl   $0xc01069e1,0xc(%esp)
c010456a:	c0 
c010456b:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104572:	c0 
c0104573:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c010457a:	00 
c010457b:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104582:	e8 5d be ff ff       	call   c01003e4 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104587:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010458e:	e8 9a e4 ff ff       	call   c0102a2d <alloc_pages>
c0104593:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104596:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010459a:	75 24                	jne    c01045c0 <basic_check+0x8b>
c010459c:	c7 44 24 0c fd 69 10 	movl   $0xc01069fd,0xc(%esp)
c01045a3:	c0 
c01045a4:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c01045ab:	c0 
c01045ac:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c01045b3:	00 
c01045b4:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c01045bb:	e8 24 be ff ff       	call   c01003e4 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01045c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01045c7:	e8 61 e4 ff ff       	call   c0102a2d <alloc_pages>
c01045cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045d3:	75 24                	jne    c01045f9 <basic_check+0xc4>
c01045d5:	c7 44 24 0c 19 6a 10 	movl   $0xc0106a19,0xc(%esp)
c01045dc:	c0 
c01045dd:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c01045e4:	c0 
c01045e5:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01045ec:	00 
c01045ed:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c01045f4:	e8 eb bd ff ff       	call   c01003e4 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01045f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01045ff:	74 10                	je     c0104611 <basic_check+0xdc>
c0104601:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104604:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104607:	74 08                	je     c0104611 <basic_check+0xdc>
c0104609:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010460c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010460f:	75 24                	jne    c0104635 <basic_check+0x100>
c0104611:	c7 44 24 0c 38 6a 10 	movl   $0xc0106a38,0xc(%esp)
c0104618:	c0 
c0104619:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104620:	c0 
c0104621:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0104628:	00 
c0104629:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104630:	e8 af bd ff ff       	call   c01003e4 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104635:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104638:	89 04 24             	mov    %eax,(%esp)
c010463b:	e8 2d f9 ff ff       	call   c0103f6d <page_ref>
c0104640:	85 c0                	test   %eax,%eax
c0104642:	75 1e                	jne    c0104662 <basic_check+0x12d>
c0104644:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104647:	89 04 24             	mov    %eax,(%esp)
c010464a:	e8 1e f9 ff ff       	call   c0103f6d <page_ref>
c010464f:	85 c0                	test   %eax,%eax
c0104651:	75 0f                	jne    c0104662 <basic_check+0x12d>
c0104653:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104656:	89 04 24             	mov    %eax,(%esp)
c0104659:	e8 0f f9 ff ff       	call   c0103f6d <page_ref>
c010465e:	85 c0                	test   %eax,%eax
c0104660:	74 24                	je     c0104686 <basic_check+0x151>
c0104662:	c7 44 24 0c 5c 6a 10 	movl   $0xc0106a5c,0xc(%esp)
c0104669:	c0 
c010466a:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104671:	c0 
c0104672:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0104679:	00 
c010467a:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104681:	e8 5e bd ff ff       	call   c01003e4 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104686:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104689:	89 04 24             	mov    %eax,(%esp)
c010468c:	e8 c6 f8 ff ff       	call   c0103f57 <page2pa>
c0104691:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0104697:	c1 e2 0c             	shl    $0xc,%edx
c010469a:	39 d0                	cmp    %edx,%eax
c010469c:	72 24                	jb     c01046c2 <basic_check+0x18d>
c010469e:	c7 44 24 0c 98 6a 10 	movl   $0xc0106a98,0xc(%esp)
c01046a5:	c0 
c01046a6:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c01046ad:	c0 
c01046ae:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c01046b5:	00 
c01046b6:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c01046bd:	e8 22 bd ff ff       	call   c01003e4 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01046c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046c5:	89 04 24             	mov    %eax,(%esp)
c01046c8:	e8 8a f8 ff ff       	call   c0103f57 <page2pa>
c01046cd:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c01046d3:	c1 e2 0c             	shl    $0xc,%edx
c01046d6:	39 d0                	cmp    %edx,%eax
c01046d8:	72 24                	jb     c01046fe <basic_check+0x1c9>
c01046da:	c7 44 24 0c b5 6a 10 	movl   $0xc0106ab5,0xc(%esp)
c01046e1:	c0 
c01046e2:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c01046e9:	c0 
c01046ea:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c01046f1:	00 
c01046f2:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c01046f9:	e8 e6 bc ff ff       	call   c01003e4 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01046fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104701:	89 04 24             	mov    %eax,(%esp)
c0104704:	e8 4e f8 ff ff       	call   c0103f57 <page2pa>
c0104709:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c010470f:	c1 e2 0c             	shl    $0xc,%edx
c0104712:	39 d0                	cmp    %edx,%eax
c0104714:	72 24                	jb     c010473a <basic_check+0x205>
c0104716:	c7 44 24 0c d2 6a 10 	movl   $0xc0106ad2,0xc(%esp)
c010471d:	c0 
c010471e:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104725:	c0 
c0104726:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c010472d:	00 
c010472e:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104735:	e8 aa bc ff ff       	call   c01003e4 <__panic>

    list_entry_t free_list_store = free_list;
c010473a:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c010473f:	8b 15 20 af 11 c0    	mov    0xc011af20,%edx
c0104745:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104748:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010474b:	c7 45 e4 1c af 11 c0 	movl   $0xc011af1c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104752:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104758:	89 50 04             	mov    %edx,0x4(%eax)
c010475b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010475e:	8b 50 04             	mov    0x4(%eax),%edx
c0104761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104764:	89 10                	mov    %edx,(%eax)
c0104766:	c7 45 d8 1c af 11 c0 	movl   $0xc011af1c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010476d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104770:	8b 40 04             	mov    0x4(%eax),%eax
c0104773:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104776:	0f 94 c0             	sete   %al
c0104779:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010477c:	85 c0                	test   %eax,%eax
c010477e:	75 24                	jne    c01047a4 <basic_check+0x26f>
c0104780:	c7 44 24 0c ef 6a 10 	movl   $0xc0106aef,0xc(%esp)
c0104787:	c0 
c0104788:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c010478f:	c0 
c0104790:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0104797:	00 
c0104798:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c010479f:	e8 40 bc ff ff       	call   c01003e4 <__panic>

    unsigned int nr_free_store = nr_free;
c01047a4:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c01047a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01047ac:	c7 05 24 af 11 c0 00 	movl   $0x0,0xc011af24
c01047b3:	00 00 00 

    assert(alloc_page() == NULL);
c01047b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01047bd:	e8 6b e2 ff ff       	call   c0102a2d <alloc_pages>
c01047c2:	85 c0                	test   %eax,%eax
c01047c4:	74 24                	je     c01047ea <basic_check+0x2b5>
c01047c6:	c7 44 24 0c 06 6b 10 	movl   $0xc0106b06,0xc(%esp)
c01047cd:	c0 
c01047ce:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c01047d5:	c0 
c01047d6:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c01047dd:	00 
c01047de:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c01047e5:	e8 fa bb ff ff       	call   c01003e4 <__panic>

    free_page(p0);
c01047ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01047f1:	00 
c01047f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047f5:	89 04 24             	mov    %eax,(%esp)
c01047f8:	e8 68 e2 ff ff       	call   c0102a65 <free_pages>
    free_page(p1);
c01047fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104804:	00 
c0104805:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104808:	89 04 24             	mov    %eax,(%esp)
c010480b:	e8 55 e2 ff ff       	call   c0102a65 <free_pages>
    free_page(p2);
c0104810:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104817:	00 
c0104818:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010481b:	89 04 24             	mov    %eax,(%esp)
c010481e:	e8 42 e2 ff ff       	call   c0102a65 <free_pages>
    assert(nr_free == 3);
c0104823:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104828:	83 f8 03             	cmp    $0x3,%eax
c010482b:	74 24                	je     c0104851 <basic_check+0x31c>
c010482d:	c7 44 24 0c 1b 6b 10 	movl   $0xc0106b1b,0xc(%esp)
c0104834:	c0 
c0104835:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c010483c:	c0 
c010483d:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0104844:	00 
c0104845:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c010484c:	e8 93 bb ff ff       	call   c01003e4 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104851:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104858:	e8 d0 e1 ff ff       	call   c0102a2d <alloc_pages>
c010485d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104860:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104864:	75 24                	jne    c010488a <basic_check+0x355>
c0104866:	c7 44 24 0c e1 69 10 	movl   $0xc01069e1,0xc(%esp)
c010486d:	c0 
c010486e:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104875:	c0 
c0104876:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c010487d:	00 
c010487e:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104885:	e8 5a bb ff ff       	call   c01003e4 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010488a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104891:	e8 97 e1 ff ff       	call   c0102a2d <alloc_pages>
c0104896:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104899:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010489d:	75 24                	jne    c01048c3 <basic_check+0x38e>
c010489f:	c7 44 24 0c fd 69 10 	movl   $0xc01069fd,0xc(%esp)
c01048a6:	c0 
c01048a7:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c01048ae:	c0 
c01048af:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c01048b6:	00 
c01048b7:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c01048be:	e8 21 bb ff ff       	call   c01003e4 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01048c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048ca:	e8 5e e1 ff ff       	call   c0102a2d <alloc_pages>
c01048cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048d6:	75 24                	jne    c01048fc <basic_check+0x3c7>
c01048d8:	c7 44 24 0c 19 6a 10 	movl   $0xc0106a19,0xc(%esp)
c01048df:	c0 
c01048e0:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c01048e7:	c0 
c01048e8:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01048ef:	00 
c01048f0:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c01048f7:	e8 e8 ba ff ff       	call   c01003e4 <__panic>

    assert(alloc_page() == NULL);
c01048fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104903:	e8 25 e1 ff ff       	call   c0102a2d <alloc_pages>
c0104908:	85 c0                	test   %eax,%eax
c010490a:	74 24                	je     c0104930 <basic_check+0x3fb>
c010490c:	c7 44 24 0c 06 6b 10 	movl   $0xc0106b06,0xc(%esp)
c0104913:	c0 
c0104914:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c010491b:	c0 
c010491c:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104923:	00 
c0104924:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c010492b:	e8 b4 ba ff ff       	call   c01003e4 <__panic>

    free_page(p0);
c0104930:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104937:	00 
c0104938:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010493b:	89 04 24             	mov    %eax,(%esp)
c010493e:	e8 22 e1 ff ff       	call   c0102a65 <free_pages>
c0104943:	c7 45 e8 1c af 11 c0 	movl   $0xc011af1c,-0x18(%ebp)
c010494a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010494d:	8b 40 04             	mov    0x4(%eax),%eax
c0104950:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104953:	0f 94 c0             	sete   %al
c0104956:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104959:	85 c0                	test   %eax,%eax
c010495b:	74 24                	je     c0104981 <basic_check+0x44c>
c010495d:	c7 44 24 0c 28 6b 10 	movl   $0xc0106b28,0xc(%esp)
c0104964:	c0 
c0104965:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c010496c:	c0 
c010496d:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0104974:	00 
c0104975:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c010497c:	e8 63 ba ff ff       	call   c01003e4 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104981:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104988:	e8 a0 e0 ff ff       	call   c0102a2d <alloc_pages>
c010498d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104990:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104993:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104996:	74 24                	je     c01049bc <basic_check+0x487>
c0104998:	c7 44 24 0c 40 6b 10 	movl   $0xc0106b40,0xc(%esp)
c010499f:	c0 
c01049a0:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c01049a7:	c0 
c01049a8:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c01049af:	00 
c01049b0:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c01049b7:	e8 28 ba ff ff       	call   c01003e4 <__panic>
    assert(alloc_page() == NULL);
c01049bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01049c3:	e8 65 e0 ff ff       	call   c0102a2d <alloc_pages>
c01049c8:	85 c0                	test   %eax,%eax
c01049ca:	74 24                	je     c01049f0 <basic_check+0x4bb>
c01049cc:	c7 44 24 0c 06 6b 10 	movl   $0xc0106b06,0xc(%esp)
c01049d3:	c0 
c01049d4:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c01049db:	c0 
c01049dc:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01049e3:	00 
c01049e4:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c01049eb:	e8 f4 b9 ff ff       	call   c01003e4 <__panic>

    assert(nr_free == 0);
c01049f0:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c01049f5:	85 c0                	test   %eax,%eax
c01049f7:	74 24                	je     c0104a1d <basic_check+0x4e8>
c01049f9:	c7 44 24 0c 59 6b 10 	movl   $0xc0106b59,0xc(%esp)
c0104a00:	c0 
c0104a01:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104a08:	c0 
c0104a09:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0104a10:	00 
c0104a11:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104a18:	e8 c7 b9 ff ff       	call   c01003e4 <__panic>
    free_list = free_list_store;
c0104a1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a20:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a23:	a3 1c af 11 c0       	mov    %eax,0xc011af1c
c0104a28:	89 15 20 af 11 c0    	mov    %edx,0xc011af20
    nr_free = nr_free_store;
c0104a2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a31:	a3 24 af 11 c0       	mov    %eax,0xc011af24

    free_page(p);
c0104a36:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104a3d:	00 
c0104a3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a41:	89 04 24             	mov    %eax,(%esp)
c0104a44:	e8 1c e0 ff ff       	call   c0102a65 <free_pages>
    free_page(p1);
c0104a49:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104a50:	00 
c0104a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a54:	89 04 24             	mov    %eax,(%esp)
c0104a57:	e8 09 e0 ff ff       	call   c0102a65 <free_pages>
    free_page(p2);
c0104a5c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104a63:	00 
c0104a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a67:	89 04 24             	mov    %eax,(%esp)
c0104a6a:	e8 f6 df ff ff       	call   c0102a65 <free_pages>
}
c0104a6f:	90                   	nop
c0104a70:	c9                   	leave  
c0104a71:	c3                   	ret    

c0104a72 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104a72:	55                   	push   %ebp
c0104a73:	89 e5                	mov    %esp,%ebp
c0104a75:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0104a7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a82:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104a89:	c7 45 ec 1c af 11 c0 	movl   $0xc011af1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104a90:	eb 6a                	jmp    c0104afc <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c0104a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a95:	83 e8 0c             	sub    $0xc,%eax
c0104a98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0104a9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a9e:	83 c0 04             	add    $0x4,%eax
c0104aa1:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0104aa8:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104aab:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104aae:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104ab1:	0f a3 10             	bt     %edx,(%eax)
c0104ab4:	19 c0                	sbb    %eax,%eax
c0104ab6:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
c0104ab9:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
c0104abd:	0f 95 c0             	setne  %al
c0104ac0:	0f b6 c0             	movzbl %al,%eax
c0104ac3:	85 c0                	test   %eax,%eax
c0104ac5:	75 24                	jne    c0104aeb <default_check+0x79>
c0104ac7:	c7 44 24 0c 66 6b 10 	movl   $0xc0106b66,0xc(%esp)
c0104ace:	c0 
c0104acf:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104ad6:	c0 
c0104ad7:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0104ade:	00 
c0104adf:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104ae6:	e8 f9 b8 ff ff       	call   c01003e4 <__panic>
        count ++, total += p->property;
c0104aeb:	ff 45 f4             	incl   -0xc(%ebp)
c0104aee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104af1:	8b 50 08             	mov    0x8(%eax),%edx
c0104af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104af7:	01 d0                	add    %edx,%eax
c0104af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104aff:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0104b02:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104b05:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104b08:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b0b:	81 7d ec 1c af 11 c0 	cmpl   $0xc011af1c,-0x14(%ebp)
c0104b12:	0f 85 7a ff ff ff    	jne    c0104a92 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0104b18:	e8 7b df ff ff       	call   c0102a98 <nr_free_pages>
c0104b1d:	89 c2                	mov    %eax,%edx
c0104b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b22:	39 c2                	cmp    %eax,%edx
c0104b24:	74 24                	je     c0104b4a <default_check+0xd8>
c0104b26:	c7 44 24 0c 76 6b 10 	movl   $0xc0106b76,0xc(%esp)
c0104b2d:	c0 
c0104b2e:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104b35:	c0 
c0104b36:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0104b3d:	00 
c0104b3e:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104b45:	e8 9a b8 ff ff       	call   c01003e4 <__panic>

    basic_check();
c0104b4a:	e8 e6 f9 ff ff       	call   c0104535 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104b4f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104b56:	e8 d2 de ff ff       	call   c0102a2d <alloc_pages>
c0104b5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
c0104b5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104b62:	75 24                	jne    c0104b88 <default_check+0x116>
c0104b64:	c7 44 24 0c 8f 6b 10 	movl   $0xc0106b8f,0xc(%esp)
c0104b6b:	c0 
c0104b6c:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104b73:	c0 
c0104b74:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0104b7b:	00 
c0104b7c:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104b83:	e8 5c b8 ff ff       	call   c01003e4 <__panic>
    assert(!PageProperty(p0));
c0104b88:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b8b:	83 c0 04             	add    $0x4,%eax
c0104b8e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
c0104b95:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104b98:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104b9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104b9e:	0f a3 10             	bt     %edx,(%eax)
c0104ba1:	19 c0                	sbb    %eax,%eax
c0104ba3:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
c0104ba6:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
c0104baa:	0f 95 c0             	setne  %al
c0104bad:	0f b6 c0             	movzbl %al,%eax
c0104bb0:	85 c0                	test   %eax,%eax
c0104bb2:	74 24                	je     c0104bd8 <default_check+0x166>
c0104bb4:	c7 44 24 0c 9a 6b 10 	movl   $0xc0106b9a,0xc(%esp)
c0104bbb:	c0 
c0104bbc:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104bc3:	c0 
c0104bc4:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0104bcb:	00 
c0104bcc:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104bd3:	e8 0c b8 ff ff       	call   c01003e4 <__panic>

    list_entry_t free_list_store = free_list;
c0104bd8:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0104bdd:	8b 15 20 af 11 c0    	mov    0xc011af20,%edx
c0104be3:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104be6:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104be9:	c7 45 d0 1c af 11 c0 	movl   $0xc011af1c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104bf0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104bf3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104bf6:	89 50 04             	mov    %edx,0x4(%eax)
c0104bf9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104bfc:	8b 50 04             	mov    0x4(%eax),%edx
c0104bff:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104c02:	89 10                	mov    %edx,(%eax)
c0104c04:	c7 45 d8 1c af 11 c0 	movl   $0xc011af1c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0104c0b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104c0e:	8b 40 04             	mov    0x4(%eax),%eax
c0104c11:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104c14:	0f 94 c0             	sete   %al
c0104c17:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104c1a:	85 c0                	test   %eax,%eax
c0104c1c:	75 24                	jne    c0104c42 <default_check+0x1d0>
c0104c1e:	c7 44 24 0c ef 6a 10 	movl   $0xc0106aef,0xc(%esp)
c0104c25:	c0 
c0104c26:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104c2d:	c0 
c0104c2e:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0104c35:	00 
c0104c36:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104c3d:	e8 a2 b7 ff ff       	call   c01003e4 <__panic>
    assert(alloc_page() == NULL);
c0104c42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c49:	e8 df dd ff ff       	call   c0102a2d <alloc_pages>
c0104c4e:	85 c0                	test   %eax,%eax
c0104c50:	74 24                	je     c0104c76 <default_check+0x204>
c0104c52:	c7 44 24 0c 06 6b 10 	movl   $0xc0106b06,0xc(%esp)
c0104c59:	c0 
c0104c5a:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104c61:	c0 
c0104c62:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0104c69:	00 
c0104c6a:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104c71:	e8 6e b7 ff ff       	call   c01003e4 <__panic>

    unsigned int nr_free_store = nr_free;
c0104c76:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104c7b:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
c0104c7e:	c7 05 24 af 11 c0 00 	movl   $0x0,0xc011af24
c0104c85:	00 00 00 

    free_pages(p0 + 2, 3);
c0104c88:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c8b:	83 c0 28             	add    $0x28,%eax
c0104c8e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104c95:	00 
c0104c96:	89 04 24             	mov    %eax,(%esp)
c0104c99:	e8 c7 dd ff ff       	call   c0102a65 <free_pages>
    assert(alloc_pages(4) == NULL);
c0104c9e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104ca5:	e8 83 dd ff ff       	call   c0102a2d <alloc_pages>
c0104caa:	85 c0                	test   %eax,%eax
c0104cac:	74 24                	je     c0104cd2 <default_check+0x260>
c0104cae:	c7 44 24 0c ac 6b 10 	movl   $0xc0106bac,0xc(%esp)
c0104cb5:	c0 
c0104cb6:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104cbd:	c0 
c0104cbe:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0104cc5:	00 
c0104cc6:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104ccd:	e8 12 b7 ff ff       	call   c01003e4 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104cd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104cd5:	83 c0 28             	add    $0x28,%eax
c0104cd8:	83 c0 04             	add    $0x4,%eax
c0104cdb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104ce2:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104ce5:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104ce8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104ceb:	0f a3 10             	bt     %edx,(%eax)
c0104cee:	19 c0                	sbb    %eax,%eax
c0104cf0:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0104cf3:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104cf7:	0f 95 c0             	setne  %al
c0104cfa:	0f b6 c0             	movzbl %al,%eax
c0104cfd:	85 c0                	test   %eax,%eax
c0104cff:	74 0e                	je     c0104d0f <default_check+0x29d>
c0104d01:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d04:	83 c0 28             	add    $0x28,%eax
c0104d07:	8b 40 08             	mov    0x8(%eax),%eax
c0104d0a:	83 f8 03             	cmp    $0x3,%eax
c0104d0d:	74 24                	je     c0104d33 <default_check+0x2c1>
c0104d0f:	c7 44 24 0c c4 6b 10 	movl   $0xc0106bc4,0xc(%esp)
c0104d16:	c0 
c0104d17:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104d1e:	c0 
c0104d1f:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104d26:	00 
c0104d27:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104d2e:	e8 b1 b6 ff ff       	call   c01003e4 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104d33:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0104d3a:	e8 ee dc ff ff       	call   c0102a2d <alloc_pages>
c0104d3f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0104d42:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0104d46:	75 24                	jne    c0104d6c <default_check+0x2fa>
c0104d48:	c7 44 24 0c f0 6b 10 	movl   $0xc0106bf0,0xc(%esp)
c0104d4f:	c0 
c0104d50:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104d57:	c0 
c0104d58:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0104d5f:	00 
c0104d60:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104d67:	e8 78 b6 ff ff       	call   c01003e4 <__panic>
    assert(alloc_page() == NULL);
c0104d6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d73:	e8 b5 dc ff ff       	call   c0102a2d <alloc_pages>
c0104d78:	85 c0                	test   %eax,%eax
c0104d7a:	74 24                	je     c0104da0 <default_check+0x32e>
c0104d7c:	c7 44 24 0c 06 6b 10 	movl   $0xc0106b06,0xc(%esp)
c0104d83:	c0 
c0104d84:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104d8b:	c0 
c0104d8c:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104d93:	00 
c0104d94:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104d9b:	e8 44 b6 ff ff       	call   c01003e4 <__panic>
    assert(p0 + 2 == p1);
c0104da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104da3:	83 c0 28             	add    $0x28,%eax
c0104da6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0104da9:	74 24                	je     c0104dcf <default_check+0x35d>
c0104dab:	c7 44 24 0c 0e 6c 10 	movl   $0xc0106c0e,0xc(%esp)
c0104db2:	c0 
c0104db3:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104dba:	c0 
c0104dbb:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0104dc2:	00 
c0104dc3:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104dca:	e8 15 b6 ff ff       	call   c01003e4 <__panic>

    p2 = p0 + 1;
c0104dcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104dd2:	83 c0 14             	add    $0x14,%eax
c0104dd5:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
c0104dd8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ddf:	00 
c0104de0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104de3:	89 04 24             	mov    %eax,(%esp)
c0104de6:	e8 7a dc ff ff       	call   c0102a65 <free_pages>
    free_pages(p1, 3);
c0104deb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104df2:	00 
c0104df3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104df6:	89 04 24             	mov    %eax,(%esp)
c0104df9:	e8 67 dc ff ff       	call   c0102a65 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104dfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e01:	83 c0 04             	add    $0x4,%eax
c0104e04:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0104e0b:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e0e:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104e11:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104e14:	0f a3 10             	bt     %edx,(%eax)
c0104e17:	19 c0                	sbb    %eax,%eax
c0104e19:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
c0104e1c:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
c0104e20:	0f 95 c0             	setne  %al
c0104e23:	0f b6 c0             	movzbl %al,%eax
c0104e26:	85 c0                	test   %eax,%eax
c0104e28:	74 0b                	je     c0104e35 <default_check+0x3c3>
c0104e2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104e2d:	8b 40 08             	mov    0x8(%eax),%eax
c0104e30:	83 f8 01             	cmp    $0x1,%eax
c0104e33:	74 24                	je     c0104e59 <default_check+0x3e7>
c0104e35:	c7 44 24 0c 1c 6c 10 	movl   $0xc0106c1c,0xc(%esp)
c0104e3c:	c0 
c0104e3d:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104e44:	c0 
c0104e45:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0104e4c:	00 
c0104e4d:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104e54:	e8 8b b5 ff ff       	call   c01003e4 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104e59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104e5c:	83 c0 04             	add    $0x4,%eax
c0104e5f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0104e66:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e69:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104e6c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104e6f:	0f a3 10             	bt     %edx,(%eax)
c0104e72:	19 c0                	sbb    %eax,%eax
c0104e74:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
c0104e77:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
c0104e7b:	0f 95 c0             	setne  %al
c0104e7e:	0f b6 c0             	movzbl %al,%eax
c0104e81:	85 c0                	test   %eax,%eax
c0104e83:	74 0b                	je     c0104e90 <default_check+0x41e>
c0104e85:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104e88:	8b 40 08             	mov    0x8(%eax),%eax
c0104e8b:	83 f8 03             	cmp    $0x3,%eax
c0104e8e:	74 24                	je     c0104eb4 <default_check+0x442>
c0104e90:	c7 44 24 0c 44 6c 10 	movl   $0xc0106c44,0xc(%esp)
c0104e97:	c0 
c0104e98:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104e9f:	c0 
c0104ea0:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0104ea7:	00 
c0104ea8:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104eaf:	e8 30 b5 ff ff       	call   c01003e4 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104eb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ebb:	e8 6d db ff ff       	call   c0102a2d <alloc_pages>
c0104ec0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104ec3:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104ec6:	83 e8 14             	sub    $0x14,%eax
c0104ec9:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104ecc:	74 24                	je     c0104ef2 <default_check+0x480>
c0104ece:	c7 44 24 0c 6a 6c 10 	movl   $0xc0106c6a,0xc(%esp)
c0104ed5:	c0 
c0104ed6:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104edd:	c0 
c0104ede:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0104ee5:	00 
c0104ee6:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104eed:	e8 f2 b4 ff ff       	call   c01003e4 <__panic>
    free_page(p0);
c0104ef2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ef9:	00 
c0104efa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104efd:	89 04 24             	mov    %eax,(%esp)
c0104f00:	e8 60 db ff ff       	call   c0102a65 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104f05:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104f0c:	e8 1c db ff ff       	call   c0102a2d <alloc_pages>
c0104f11:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104f14:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104f17:	83 c0 14             	add    $0x14,%eax
c0104f1a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104f1d:	74 24                	je     c0104f43 <default_check+0x4d1>
c0104f1f:	c7 44 24 0c 88 6c 10 	movl   $0xc0106c88,0xc(%esp)
c0104f26:	c0 
c0104f27:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104f2e:	c0 
c0104f2f:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0104f36:	00 
c0104f37:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104f3e:	e8 a1 b4 ff ff       	call   c01003e4 <__panic>

    free_pages(p0, 2);
c0104f43:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104f4a:	00 
c0104f4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f4e:	89 04 24             	mov    %eax,(%esp)
c0104f51:	e8 0f db ff ff       	call   c0102a65 <free_pages>
    free_page(p2);
c0104f56:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f5d:	00 
c0104f5e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104f61:	89 04 24             	mov    %eax,(%esp)
c0104f64:	e8 fc da ff ff       	call   c0102a65 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104f69:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104f70:	e8 b8 da ff ff       	call   c0102a2d <alloc_pages>
c0104f75:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104f78:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104f7c:	75 24                	jne    c0104fa2 <default_check+0x530>
c0104f7e:	c7 44 24 0c a8 6c 10 	movl   $0xc0106ca8,0xc(%esp)
c0104f85:	c0 
c0104f86:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104f8d:	c0 
c0104f8e:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0104f95:	00 
c0104f96:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104f9d:	e8 42 b4 ff ff       	call   c01003e4 <__panic>
    assert(alloc_page() == NULL);
c0104fa2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104fa9:	e8 7f da ff ff       	call   c0102a2d <alloc_pages>
c0104fae:	85 c0                	test   %eax,%eax
c0104fb0:	74 24                	je     c0104fd6 <default_check+0x564>
c0104fb2:	c7 44 24 0c 06 6b 10 	movl   $0xc0106b06,0xc(%esp)
c0104fb9:	c0 
c0104fba:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104fc1:	c0 
c0104fc2:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0104fc9:	00 
c0104fca:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104fd1:	e8 0e b4 ff ff       	call   c01003e4 <__panic>

    assert(nr_free == 0);
c0104fd6:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104fdb:	85 c0                	test   %eax,%eax
c0104fdd:	74 24                	je     c0105003 <default_check+0x591>
c0104fdf:	c7 44 24 0c 59 6b 10 	movl   $0xc0106b59,0xc(%esp)
c0104fe6:	c0 
c0104fe7:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0104fee:	c0 
c0104fef:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0104ff6:	00 
c0104ff7:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0104ffe:	e8 e1 b3 ff ff       	call   c01003e4 <__panic>
    nr_free = nr_free_store;
c0105003:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0105006:	a3 24 af 11 c0       	mov    %eax,0xc011af24

    free_list = free_list_store;
c010500b:	8b 45 80             	mov    -0x80(%ebp),%eax
c010500e:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0105011:	a3 1c af 11 c0       	mov    %eax,0xc011af1c
c0105016:	89 15 20 af 11 c0    	mov    %edx,0xc011af20
    free_pages(p0, 5);
c010501c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0105023:	00 
c0105024:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105027:	89 04 24             	mov    %eax,(%esp)
c010502a:	e8 36 da ff ff       	call   c0102a65 <free_pages>

    le = &free_list;
c010502f:	c7 45 ec 1c af 11 c0 	movl   $0xc011af1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105036:	eb 5a                	jmp    c0105092 <default_check+0x620>
        assert(le->next->prev == le && le->prev->next == le);
c0105038:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010503b:	8b 40 04             	mov    0x4(%eax),%eax
c010503e:	8b 00                	mov    (%eax),%eax
c0105040:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105043:	75 0d                	jne    c0105052 <default_check+0x5e0>
c0105045:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105048:	8b 00                	mov    (%eax),%eax
c010504a:	8b 40 04             	mov    0x4(%eax),%eax
c010504d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105050:	74 24                	je     c0105076 <default_check+0x604>
c0105052:	c7 44 24 0c c8 6c 10 	movl   $0xc0106cc8,0xc(%esp)
c0105059:	c0 
c010505a:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c0105061:	c0 
c0105062:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c0105069:	00 
c010506a:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c0105071:	e8 6e b3 ff ff       	call   c01003e4 <__panic>
        struct Page *p = le2page(le, page_link);
c0105076:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105079:	83 e8 0c             	sub    $0xc,%eax
c010507c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
c010507f:	ff 4d f4             	decl   -0xc(%ebp)
c0105082:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105085:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0105088:	8b 40 08             	mov    0x8(%eax),%eax
c010508b:	29 c2                	sub    %eax,%edx
c010508d:	89 d0                	mov    %edx,%eax
c010508f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105092:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105095:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0105098:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010509b:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010509e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01050a1:	81 7d ec 1c af 11 c0 	cmpl   $0xc011af1c,-0x14(%ebp)
c01050a8:	75 8e                	jne    c0105038 <default_check+0x5c6>
        assert(le->next->prev == le && le->prev->next == le);
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01050aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050ae:	74 24                	je     c01050d4 <default_check+0x662>
c01050b0:	c7 44 24 0c f5 6c 10 	movl   $0xc0106cf5,0xc(%esp)
c01050b7:	c0 
c01050b8:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c01050bf:	c0 
c01050c0:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c01050c7:	00 
c01050c8:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c01050cf:	e8 10 b3 ff ff       	call   c01003e4 <__panic>
    assert(total == 0);
c01050d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01050d8:	74 24                	je     c01050fe <default_check+0x68c>
c01050da:	c7 44 24 0c 00 6d 10 	movl   $0xc0106d00,0xc(%esp)
c01050e1:	c0 
c01050e2:	c7 44 24 08 7e 69 10 	movl   $0xc010697e,0x8(%esp)
c01050e9:	c0 
c01050ea:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01050f1:	00 
c01050f2:	c7 04 24 93 69 10 c0 	movl   $0xc0106993,(%esp)
c01050f9:	e8 e6 b2 ff ff       	call   c01003e4 <__panic>
}
c01050fe:	90                   	nop
c01050ff:	c9                   	leave  
c0105100:	c3                   	ret    

c0105101 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105101:	55                   	push   %ebp
c0105102:	89 e5                	mov    %esp,%ebp
c0105104:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105107:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010510e:	eb 03                	jmp    c0105113 <strlen+0x12>
        cnt ++;
c0105110:	ff 45 fc             	incl   -0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105113:	8b 45 08             	mov    0x8(%ebp),%eax
c0105116:	8d 50 01             	lea    0x1(%eax),%edx
c0105119:	89 55 08             	mov    %edx,0x8(%ebp)
c010511c:	0f b6 00             	movzbl (%eax),%eax
c010511f:	84 c0                	test   %al,%al
c0105121:	75 ed                	jne    c0105110 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105123:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105126:	c9                   	leave  
c0105127:	c3                   	ret    

c0105128 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105128:	55                   	push   %ebp
c0105129:	89 e5                	mov    %esp,%ebp
c010512b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010512e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105135:	eb 03                	jmp    c010513a <strnlen+0x12>
        cnt ++;
c0105137:	ff 45 fc             	incl   -0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010513a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010513d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105140:	73 10                	jae    c0105152 <strnlen+0x2a>
c0105142:	8b 45 08             	mov    0x8(%ebp),%eax
c0105145:	8d 50 01             	lea    0x1(%eax),%edx
c0105148:	89 55 08             	mov    %edx,0x8(%ebp)
c010514b:	0f b6 00             	movzbl (%eax),%eax
c010514e:	84 c0                	test   %al,%al
c0105150:	75 e5                	jne    c0105137 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105155:	c9                   	leave  
c0105156:	c3                   	ret    

c0105157 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105157:	55                   	push   %ebp
c0105158:	89 e5                	mov    %esp,%ebp
c010515a:	57                   	push   %edi
c010515b:	56                   	push   %esi
c010515c:	83 ec 20             	sub    $0x20,%esp
c010515f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105162:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105165:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105168:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010516b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010516e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105171:	89 d1                	mov    %edx,%ecx
c0105173:	89 c2                	mov    %eax,%edx
c0105175:	89 ce                	mov    %ecx,%esi
c0105177:	89 d7                	mov    %edx,%edi
c0105179:	ac                   	lods   %ds:(%esi),%al
c010517a:	aa                   	stos   %al,%es:(%edi)
c010517b:	84 c0                	test   %al,%al
c010517d:	75 fa                	jne    c0105179 <strcpy+0x22>
c010517f:	89 fa                	mov    %edi,%edx
c0105181:	89 f1                	mov    %esi,%ecx
c0105183:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105186:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010518c:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c010518f:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105190:	83 c4 20             	add    $0x20,%esp
c0105193:	5e                   	pop    %esi
c0105194:	5f                   	pop    %edi
c0105195:	5d                   	pop    %ebp
c0105196:	c3                   	ret    

c0105197 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105197:	55                   	push   %ebp
c0105198:	89 e5                	mov    %esp,%ebp
c010519a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010519d:	8b 45 08             	mov    0x8(%ebp),%eax
c01051a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01051a3:	eb 1e                	jmp    c01051c3 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c01051a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051a8:	0f b6 10             	movzbl (%eax),%edx
c01051ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051ae:	88 10                	mov    %dl,(%eax)
c01051b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051b3:	0f b6 00             	movzbl (%eax),%eax
c01051b6:	84 c0                	test   %al,%al
c01051b8:	74 03                	je     c01051bd <strncpy+0x26>
            src ++;
c01051ba:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c01051bd:	ff 45 fc             	incl   -0x4(%ebp)
c01051c0:	ff 4d 10             	decl   0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01051c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01051c7:	75 dc                	jne    c01051a5 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01051c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01051cc:	c9                   	leave  
c01051cd:	c3                   	ret    

c01051ce <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01051ce:	55                   	push   %ebp
c01051cf:	89 e5                	mov    %esp,%ebp
c01051d1:	57                   	push   %edi
c01051d2:	56                   	push   %esi
c01051d3:	83 ec 20             	sub    $0x20,%esp
c01051d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01051d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01051dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051df:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01051e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01051e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051e8:	89 d1                	mov    %edx,%ecx
c01051ea:	89 c2                	mov    %eax,%edx
c01051ec:	89 ce                	mov    %ecx,%esi
c01051ee:	89 d7                	mov    %edx,%edi
c01051f0:	ac                   	lods   %ds:(%esi),%al
c01051f1:	ae                   	scas   %es:(%edi),%al
c01051f2:	75 08                	jne    c01051fc <strcmp+0x2e>
c01051f4:	84 c0                	test   %al,%al
c01051f6:	75 f8                	jne    c01051f0 <strcmp+0x22>
c01051f8:	31 c0                	xor    %eax,%eax
c01051fa:	eb 04                	jmp    c0105200 <strcmp+0x32>
c01051fc:	19 c0                	sbb    %eax,%eax
c01051fe:	0c 01                	or     $0x1,%al
c0105200:	89 fa                	mov    %edi,%edx
c0105202:	89 f1                	mov    %esi,%ecx
c0105204:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105207:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010520a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c010520d:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c0105210:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105211:	83 c4 20             	add    $0x20,%esp
c0105214:	5e                   	pop    %esi
c0105215:	5f                   	pop    %edi
c0105216:	5d                   	pop    %ebp
c0105217:	c3                   	ret    

c0105218 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105218:	55                   	push   %ebp
c0105219:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010521b:	eb 09                	jmp    c0105226 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c010521d:	ff 4d 10             	decl   0x10(%ebp)
c0105220:	ff 45 08             	incl   0x8(%ebp)
c0105223:	ff 45 0c             	incl   0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105226:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010522a:	74 1a                	je     c0105246 <strncmp+0x2e>
c010522c:	8b 45 08             	mov    0x8(%ebp),%eax
c010522f:	0f b6 00             	movzbl (%eax),%eax
c0105232:	84 c0                	test   %al,%al
c0105234:	74 10                	je     c0105246 <strncmp+0x2e>
c0105236:	8b 45 08             	mov    0x8(%ebp),%eax
c0105239:	0f b6 10             	movzbl (%eax),%edx
c010523c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010523f:	0f b6 00             	movzbl (%eax),%eax
c0105242:	38 c2                	cmp    %al,%dl
c0105244:	74 d7                	je     c010521d <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105246:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010524a:	74 18                	je     c0105264 <strncmp+0x4c>
c010524c:	8b 45 08             	mov    0x8(%ebp),%eax
c010524f:	0f b6 00             	movzbl (%eax),%eax
c0105252:	0f b6 d0             	movzbl %al,%edx
c0105255:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105258:	0f b6 00             	movzbl (%eax),%eax
c010525b:	0f b6 c0             	movzbl %al,%eax
c010525e:	29 c2                	sub    %eax,%edx
c0105260:	89 d0                	mov    %edx,%eax
c0105262:	eb 05                	jmp    c0105269 <strncmp+0x51>
c0105264:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105269:	5d                   	pop    %ebp
c010526a:	c3                   	ret    

c010526b <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010526b:	55                   	push   %ebp
c010526c:	89 e5                	mov    %esp,%ebp
c010526e:	83 ec 04             	sub    $0x4,%esp
c0105271:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105274:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105277:	eb 13                	jmp    c010528c <strchr+0x21>
        if (*s == c) {
c0105279:	8b 45 08             	mov    0x8(%ebp),%eax
c010527c:	0f b6 00             	movzbl (%eax),%eax
c010527f:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105282:	75 05                	jne    c0105289 <strchr+0x1e>
            return (char *)s;
c0105284:	8b 45 08             	mov    0x8(%ebp),%eax
c0105287:	eb 12                	jmp    c010529b <strchr+0x30>
        }
        s ++;
c0105289:	ff 45 08             	incl   0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010528c:	8b 45 08             	mov    0x8(%ebp),%eax
c010528f:	0f b6 00             	movzbl (%eax),%eax
c0105292:	84 c0                	test   %al,%al
c0105294:	75 e3                	jne    c0105279 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105296:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010529b:	c9                   	leave  
c010529c:	c3                   	ret    

c010529d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010529d:	55                   	push   %ebp
c010529e:	89 e5                	mov    %esp,%ebp
c01052a0:	83 ec 04             	sub    $0x4,%esp
c01052a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052a6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01052a9:	eb 0e                	jmp    c01052b9 <strfind+0x1c>
        if (*s == c) {
c01052ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01052ae:	0f b6 00             	movzbl (%eax),%eax
c01052b1:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01052b4:	74 0f                	je     c01052c5 <strfind+0x28>
            break;
        }
        s ++;
c01052b6:	ff 45 08             	incl   0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01052b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01052bc:	0f b6 00             	movzbl (%eax),%eax
c01052bf:	84 c0                	test   %al,%al
c01052c1:	75 e8                	jne    c01052ab <strfind+0xe>
c01052c3:	eb 01                	jmp    c01052c6 <strfind+0x29>
        if (*s == c) {
            break;
c01052c5:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c01052c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01052c9:	c9                   	leave  
c01052ca:	c3                   	ret    

c01052cb <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01052cb:	55                   	push   %ebp
c01052cc:	89 e5                	mov    %esp,%ebp
c01052ce:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01052d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01052d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01052df:	eb 03                	jmp    c01052e4 <strtol+0x19>
        s ++;
c01052e1:	ff 45 08             	incl   0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01052e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01052e7:	0f b6 00             	movzbl (%eax),%eax
c01052ea:	3c 20                	cmp    $0x20,%al
c01052ec:	74 f3                	je     c01052e1 <strtol+0x16>
c01052ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01052f1:	0f b6 00             	movzbl (%eax),%eax
c01052f4:	3c 09                	cmp    $0x9,%al
c01052f6:	74 e9                	je     c01052e1 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01052f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01052fb:	0f b6 00             	movzbl (%eax),%eax
c01052fe:	3c 2b                	cmp    $0x2b,%al
c0105300:	75 05                	jne    c0105307 <strtol+0x3c>
        s ++;
c0105302:	ff 45 08             	incl   0x8(%ebp)
c0105305:	eb 14                	jmp    c010531b <strtol+0x50>
    }
    else if (*s == '-') {
c0105307:	8b 45 08             	mov    0x8(%ebp),%eax
c010530a:	0f b6 00             	movzbl (%eax),%eax
c010530d:	3c 2d                	cmp    $0x2d,%al
c010530f:	75 0a                	jne    c010531b <strtol+0x50>
        s ++, neg = 1;
c0105311:	ff 45 08             	incl   0x8(%ebp)
c0105314:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010531b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010531f:	74 06                	je     c0105327 <strtol+0x5c>
c0105321:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105325:	75 22                	jne    c0105349 <strtol+0x7e>
c0105327:	8b 45 08             	mov    0x8(%ebp),%eax
c010532a:	0f b6 00             	movzbl (%eax),%eax
c010532d:	3c 30                	cmp    $0x30,%al
c010532f:	75 18                	jne    c0105349 <strtol+0x7e>
c0105331:	8b 45 08             	mov    0x8(%ebp),%eax
c0105334:	40                   	inc    %eax
c0105335:	0f b6 00             	movzbl (%eax),%eax
c0105338:	3c 78                	cmp    $0x78,%al
c010533a:	75 0d                	jne    c0105349 <strtol+0x7e>
        s += 2, base = 16;
c010533c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105340:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105347:	eb 29                	jmp    c0105372 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c0105349:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010534d:	75 16                	jne    c0105365 <strtol+0x9a>
c010534f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105352:	0f b6 00             	movzbl (%eax),%eax
c0105355:	3c 30                	cmp    $0x30,%al
c0105357:	75 0c                	jne    c0105365 <strtol+0x9a>
        s ++, base = 8;
c0105359:	ff 45 08             	incl   0x8(%ebp)
c010535c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105363:	eb 0d                	jmp    c0105372 <strtol+0xa7>
    }
    else if (base == 0) {
c0105365:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105369:	75 07                	jne    c0105372 <strtol+0xa7>
        base = 10;
c010536b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105372:	8b 45 08             	mov    0x8(%ebp),%eax
c0105375:	0f b6 00             	movzbl (%eax),%eax
c0105378:	3c 2f                	cmp    $0x2f,%al
c010537a:	7e 1b                	jle    c0105397 <strtol+0xcc>
c010537c:	8b 45 08             	mov    0x8(%ebp),%eax
c010537f:	0f b6 00             	movzbl (%eax),%eax
c0105382:	3c 39                	cmp    $0x39,%al
c0105384:	7f 11                	jg     c0105397 <strtol+0xcc>
            dig = *s - '0';
c0105386:	8b 45 08             	mov    0x8(%ebp),%eax
c0105389:	0f b6 00             	movzbl (%eax),%eax
c010538c:	0f be c0             	movsbl %al,%eax
c010538f:	83 e8 30             	sub    $0x30,%eax
c0105392:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105395:	eb 48                	jmp    c01053df <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105397:	8b 45 08             	mov    0x8(%ebp),%eax
c010539a:	0f b6 00             	movzbl (%eax),%eax
c010539d:	3c 60                	cmp    $0x60,%al
c010539f:	7e 1b                	jle    c01053bc <strtol+0xf1>
c01053a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01053a4:	0f b6 00             	movzbl (%eax),%eax
c01053a7:	3c 7a                	cmp    $0x7a,%al
c01053a9:	7f 11                	jg     c01053bc <strtol+0xf1>
            dig = *s - 'a' + 10;
c01053ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01053ae:	0f b6 00             	movzbl (%eax),%eax
c01053b1:	0f be c0             	movsbl %al,%eax
c01053b4:	83 e8 57             	sub    $0x57,%eax
c01053b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053ba:	eb 23                	jmp    c01053df <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01053bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01053bf:	0f b6 00             	movzbl (%eax),%eax
c01053c2:	3c 40                	cmp    $0x40,%al
c01053c4:	7e 3b                	jle    c0105401 <strtol+0x136>
c01053c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01053c9:	0f b6 00             	movzbl (%eax),%eax
c01053cc:	3c 5a                	cmp    $0x5a,%al
c01053ce:	7f 31                	jg     c0105401 <strtol+0x136>
            dig = *s - 'A' + 10;
c01053d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01053d3:	0f b6 00             	movzbl (%eax),%eax
c01053d6:	0f be c0             	movsbl %al,%eax
c01053d9:	83 e8 37             	sub    $0x37,%eax
c01053dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01053df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053e2:	3b 45 10             	cmp    0x10(%ebp),%eax
c01053e5:	7d 19                	jge    c0105400 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c01053e7:	ff 45 08             	incl   0x8(%ebp)
c01053ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01053ed:	0f af 45 10          	imul   0x10(%ebp),%eax
c01053f1:	89 c2                	mov    %eax,%edx
c01053f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053f6:	01 d0                	add    %edx,%eax
c01053f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01053fb:	e9 72 ff ff ff       	jmp    c0105372 <strtol+0xa7>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0105400:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105401:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105405:	74 08                	je     c010540f <strtol+0x144>
        *endptr = (char *) s;
c0105407:	8b 45 0c             	mov    0xc(%ebp),%eax
c010540a:	8b 55 08             	mov    0x8(%ebp),%edx
c010540d:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010540f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105413:	74 07                	je     c010541c <strtol+0x151>
c0105415:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105418:	f7 d8                	neg    %eax
c010541a:	eb 03                	jmp    c010541f <strtol+0x154>
c010541c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010541f:	c9                   	leave  
c0105420:	c3                   	ret    

c0105421 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105421:	55                   	push   %ebp
c0105422:	89 e5                	mov    %esp,%ebp
c0105424:	57                   	push   %edi
c0105425:	83 ec 24             	sub    $0x24,%esp
c0105428:	8b 45 0c             	mov    0xc(%ebp),%eax
c010542b:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010542e:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105432:	8b 55 08             	mov    0x8(%ebp),%edx
c0105435:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105438:	88 45 f7             	mov    %al,-0x9(%ebp)
c010543b:	8b 45 10             	mov    0x10(%ebp),%eax
c010543e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105441:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105444:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105448:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010544b:	89 d7                	mov    %edx,%edi
c010544d:	f3 aa                	rep stos %al,%es:(%edi)
c010544f:	89 fa                	mov    %edi,%edx
c0105451:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105454:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105457:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010545a:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010545b:	83 c4 24             	add    $0x24,%esp
c010545e:	5f                   	pop    %edi
c010545f:	5d                   	pop    %ebp
c0105460:	c3                   	ret    

c0105461 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105461:	55                   	push   %ebp
c0105462:	89 e5                	mov    %esp,%ebp
c0105464:	57                   	push   %edi
c0105465:	56                   	push   %esi
c0105466:	53                   	push   %ebx
c0105467:	83 ec 30             	sub    $0x30,%esp
c010546a:	8b 45 08             	mov    0x8(%ebp),%eax
c010546d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105470:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105473:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105476:	8b 45 10             	mov    0x10(%ebp),%eax
c0105479:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010547c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010547f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105482:	73 42                	jae    c01054c6 <memmove+0x65>
c0105484:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010548a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010548d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105490:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105493:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105496:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105499:	c1 e8 02             	shr    $0x2,%eax
c010549c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010549e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054a4:	89 d7                	mov    %edx,%edi
c01054a6:	89 c6                	mov    %eax,%esi
c01054a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01054aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01054ad:	83 e1 03             	and    $0x3,%ecx
c01054b0:	74 02                	je     c01054b4 <memmove+0x53>
c01054b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01054b4:	89 f0                	mov    %esi,%eax
c01054b6:	89 fa                	mov    %edi,%edx
c01054b8:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01054bb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01054be:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01054c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01054c4:	eb 36                	jmp    c01054fc <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01054c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054c9:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054cf:	01 c2                	add    %eax,%edx
c01054d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054d4:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01054d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054da:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c01054dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054e0:	89 c1                	mov    %eax,%ecx
c01054e2:	89 d8                	mov    %ebx,%eax
c01054e4:	89 d6                	mov    %edx,%esi
c01054e6:	89 c7                	mov    %eax,%edi
c01054e8:	fd                   	std    
c01054e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01054eb:	fc                   	cld    
c01054ec:	89 f8                	mov    %edi,%eax
c01054ee:	89 f2                	mov    %esi,%edx
c01054f0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01054f3:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01054f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01054f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01054fc:	83 c4 30             	add    $0x30,%esp
c01054ff:	5b                   	pop    %ebx
c0105500:	5e                   	pop    %esi
c0105501:	5f                   	pop    %edi
c0105502:	5d                   	pop    %ebp
c0105503:	c3                   	ret    

c0105504 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105504:	55                   	push   %ebp
c0105505:	89 e5                	mov    %esp,%ebp
c0105507:	57                   	push   %edi
c0105508:	56                   	push   %esi
c0105509:	83 ec 20             	sub    $0x20,%esp
c010550c:	8b 45 08             	mov    0x8(%ebp),%eax
c010550f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105512:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105515:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105518:	8b 45 10             	mov    0x10(%ebp),%eax
c010551b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010551e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105521:	c1 e8 02             	shr    $0x2,%eax
c0105524:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105526:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105529:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010552c:	89 d7                	mov    %edx,%edi
c010552e:	89 c6                	mov    %eax,%esi
c0105530:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105532:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105535:	83 e1 03             	and    $0x3,%ecx
c0105538:	74 02                	je     c010553c <memcpy+0x38>
c010553a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010553c:	89 f0                	mov    %esi,%eax
c010553e:	89 fa                	mov    %edi,%edx
c0105540:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105543:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105546:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105549:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c010554c:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010554d:	83 c4 20             	add    $0x20,%esp
c0105550:	5e                   	pop    %esi
c0105551:	5f                   	pop    %edi
c0105552:	5d                   	pop    %ebp
c0105553:	c3                   	ret    

c0105554 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105554:	55                   	push   %ebp
c0105555:	89 e5                	mov    %esp,%ebp
c0105557:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010555a:	8b 45 08             	mov    0x8(%ebp),%eax
c010555d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105563:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105566:	eb 2e                	jmp    c0105596 <memcmp+0x42>
        if (*s1 != *s2) {
c0105568:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010556b:	0f b6 10             	movzbl (%eax),%edx
c010556e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105571:	0f b6 00             	movzbl (%eax),%eax
c0105574:	38 c2                	cmp    %al,%dl
c0105576:	74 18                	je     c0105590 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105578:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010557b:	0f b6 00             	movzbl (%eax),%eax
c010557e:	0f b6 d0             	movzbl %al,%edx
c0105581:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105584:	0f b6 00             	movzbl (%eax),%eax
c0105587:	0f b6 c0             	movzbl %al,%eax
c010558a:	29 c2                	sub    %eax,%edx
c010558c:	89 d0                	mov    %edx,%eax
c010558e:	eb 18                	jmp    c01055a8 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0105590:	ff 45 fc             	incl   -0x4(%ebp)
c0105593:	ff 45 f8             	incl   -0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105596:	8b 45 10             	mov    0x10(%ebp),%eax
c0105599:	8d 50 ff             	lea    -0x1(%eax),%edx
c010559c:	89 55 10             	mov    %edx,0x10(%ebp)
c010559f:	85 c0                	test   %eax,%eax
c01055a1:	75 c5                	jne    c0105568 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c01055a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01055a8:	c9                   	leave  
c01055a9:	c3                   	ret    

c01055aa <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01055aa:	55                   	push   %ebp
c01055ab:	89 e5                	mov    %esp,%ebp
c01055ad:	83 ec 58             	sub    $0x58,%esp
c01055b0:	8b 45 10             	mov    0x10(%ebp),%eax
c01055b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01055b6:	8b 45 14             	mov    0x14(%ebp),%eax
c01055b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01055bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01055bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01055c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055c5:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01055c8:	8b 45 18             	mov    0x18(%ebp),%eax
c01055cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01055d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01055d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01055d7:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01055da:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01055e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01055e4:	74 1c                	je     c0105602 <printnum+0x58>
c01055e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055e9:	ba 00 00 00 00       	mov    $0x0,%edx
c01055ee:	f7 75 e4             	divl   -0x1c(%ebp)
c01055f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01055f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055f7:	ba 00 00 00 00       	mov    $0x0,%edx
c01055fc:	f7 75 e4             	divl   -0x1c(%ebp)
c01055ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105602:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105605:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105608:	f7 75 e4             	divl   -0x1c(%ebp)
c010560b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010560e:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105611:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105614:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105617:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010561a:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010561d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105620:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105623:	8b 45 18             	mov    0x18(%ebp),%eax
c0105626:	ba 00 00 00 00       	mov    $0x0,%edx
c010562b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010562e:	77 56                	ja     c0105686 <printnum+0xdc>
c0105630:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105633:	72 05                	jb     c010563a <printnum+0x90>
c0105635:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105638:	77 4c                	ja     c0105686 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010563a:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010563d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105640:	8b 45 20             	mov    0x20(%ebp),%eax
c0105643:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105647:	89 54 24 14          	mov    %edx,0x14(%esp)
c010564b:	8b 45 18             	mov    0x18(%ebp),%eax
c010564e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105652:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105655:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105658:	89 44 24 08          	mov    %eax,0x8(%esp)
c010565c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105660:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105663:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105667:	8b 45 08             	mov    0x8(%ebp),%eax
c010566a:	89 04 24             	mov    %eax,(%esp)
c010566d:	e8 38 ff ff ff       	call   c01055aa <printnum>
c0105672:	eb 1b                	jmp    c010568f <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105674:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105677:	89 44 24 04          	mov    %eax,0x4(%esp)
c010567b:	8b 45 20             	mov    0x20(%ebp),%eax
c010567e:	89 04 24             	mov    %eax,(%esp)
c0105681:	8b 45 08             	mov    0x8(%ebp),%eax
c0105684:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105686:	ff 4d 1c             	decl   0x1c(%ebp)
c0105689:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010568d:	7f e5                	jg     c0105674 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010568f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105692:	05 bc 6d 10 c0       	add    $0xc0106dbc,%eax
c0105697:	0f b6 00             	movzbl (%eax),%eax
c010569a:	0f be c0             	movsbl %al,%eax
c010569d:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056a0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056a4:	89 04 24             	mov    %eax,(%esp)
c01056a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056aa:	ff d0                	call   *%eax
}
c01056ac:	90                   	nop
c01056ad:	c9                   	leave  
c01056ae:	c3                   	ret    

c01056af <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01056af:	55                   	push   %ebp
c01056b0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01056b2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01056b6:	7e 14                	jle    c01056cc <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01056b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01056bb:	8b 00                	mov    (%eax),%eax
c01056bd:	8d 48 08             	lea    0x8(%eax),%ecx
c01056c0:	8b 55 08             	mov    0x8(%ebp),%edx
c01056c3:	89 0a                	mov    %ecx,(%edx)
c01056c5:	8b 50 04             	mov    0x4(%eax),%edx
c01056c8:	8b 00                	mov    (%eax),%eax
c01056ca:	eb 30                	jmp    c01056fc <getuint+0x4d>
    }
    else if (lflag) {
c01056cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01056d0:	74 16                	je     c01056e8 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01056d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d5:	8b 00                	mov    (%eax),%eax
c01056d7:	8d 48 04             	lea    0x4(%eax),%ecx
c01056da:	8b 55 08             	mov    0x8(%ebp),%edx
c01056dd:	89 0a                	mov    %ecx,(%edx)
c01056df:	8b 00                	mov    (%eax),%eax
c01056e1:	ba 00 00 00 00       	mov    $0x0,%edx
c01056e6:	eb 14                	jmp    c01056fc <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01056e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01056eb:	8b 00                	mov    (%eax),%eax
c01056ed:	8d 48 04             	lea    0x4(%eax),%ecx
c01056f0:	8b 55 08             	mov    0x8(%ebp),%edx
c01056f3:	89 0a                	mov    %ecx,(%edx)
c01056f5:	8b 00                	mov    (%eax),%eax
c01056f7:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01056fc:	5d                   	pop    %ebp
c01056fd:	c3                   	ret    

c01056fe <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01056fe:	55                   	push   %ebp
c01056ff:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105701:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105705:	7e 14                	jle    c010571b <getint+0x1d>
        return va_arg(*ap, long long);
c0105707:	8b 45 08             	mov    0x8(%ebp),%eax
c010570a:	8b 00                	mov    (%eax),%eax
c010570c:	8d 48 08             	lea    0x8(%eax),%ecx
c010570f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105712:	89 0a                	mov    %ecx,(%edx)
c0105714:	8b 50 04             	mov    0x4(%eax),%edx
c0105717:	8b 00                	mov    (%eax),%eax
c0105719:	eb 28                	jmp    c0105743 <getint+0x45>
    }
    else if (lflag) {
c010571b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010571f:	74 12                	je     c0105733 <getint+0x35>
        return va_arg(*ap, long);
c0105721:	8b 45 08             	mov    0x8(%ebp),%eax
c0105724:	8b 00                	mov    (%eax),%eax
c0105726:	8d 48 04             	lea    0x4(%eax),%ecx
c0105729:	8b 55 08             	mov    0x8(%ebp),%edx
c010572c:	89 0a                	mov    %ecx,(%edx)
c010572e:	8b 00                	mov    (%eax),%eax
c0105730:	99                   	cltd   
c0105731:	eb 10                	jmp    c0105743 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105733:	8b 45 08             	mov    0x8(%ebp),%eax
c0105736:	8b 00                	mov    (%eax),%eax
c0105738:	8d 48 04             	lea    0x4(%eax),%ecx
c010573b:	8b 55 08             	mov    0x8(%ebp),%edx
c010573e:	89 0a                	mov    %ecx,(%edx)
c0105740:	8b 00                	mov    (%eax),%eax
c0105742:	99                   	cltd   
    }
}
c0105743:	5d                   	pop    %ebp
c0105744:	c3                   	ret    

c0105745 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105745:	55                   	push   %ebp
c0105746:	89 e5                	mov    %esp,%ebp
c0105748:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010574b:	8d 45 14             	lea    0x14(%ebp),%eax
c010574e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105751:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105754:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105758:	8b 45 10             	mov    0x10(%ebp),%eax
c010575b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010575f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105762:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105766:	8b 45 08             	mov    0x8(%ebp),%eax
c0105769:	89 04 24             	mov    %eax,(%esp)
c010576c:	e8 03 00 00 00       	call   c0105774 <vprintfmt>
    va_end(ap);
}
c0105771:	90                   	nop
c0105772:	c9                   	leave  
c0105773:	c3                   	ret    

c0105774 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105774:	55                   	push   %ebp
c0105775:	89 e5                	mov    %esp,%ebp
c0105777:	56                   	push   %esi
c0105778:	53                   	push   %ebx
c0105779:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010577c:	eb 17                	jmp    c0105795 <vprintfmt+0x21>
            if (ch == '\0') {
c010577e:	85 db                	test   %ebx,%ebx
c0105780:	0f 84 bf 03 00 00    	je     c0105b45 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0105786:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105789:	89 44 24 04          	mov    %eax,0x4(%esp)
c010578d:	89 1c 24             	mov    %ebx,(%esp)
c0105790:	8b 45 08             	mov    0x8(%ebp),%eax
c0105793:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105795:	8b 45 10             	mov    0x10(%ebp),%eax
c0105798:	8d 50 01             	lea    0x1(%eax),%edx
c010579b:	89 55 10             	mov    %edx,0x10(%ebp)
c010579e:	0f b6 00             	movzbl (%eax),%eax
c01057a1:	0f b6 d8             	movzbl %al,%ebx
c01057a4:	83 fb 25             	cmp    $0x25,%ebx
c01057a7:	75 d5                	jne    c010577e <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01057a9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01057ad:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01057b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01057ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01057c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057c4:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01057c7:	8b 45 10             	mov    0x10(%ebp),%eax
c01057ca:	8d 50 01             	lea    0x1(%eax),%edx
c01057cd:	89 55 10             	mov    %edx,0x10(%ebp)
c01057d0:	0f b6 00             	movzbl (%eax),%eax
c01057d3:	0f b6 d8             	movzbl %al,%ebx
c01057d6:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01057d9:	83 f8 55             	cmp    $0x55,%eax
c01057dc:	0f 87 37 03 00 00    	ja     c0105b19 <vprintfmt+0x3a5>
c01057e2:	8b 04 85 e0 6d 10 c0 	mov    -0x3fef9220(,%eax,4),%eax
c01057e9:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01057eb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01057ef:	eb d6                	jmp    c01057c7 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01057f1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01057f5:	eb d0                	jmp    c01057c7 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01057f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01057fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105801:	89 d0                	mov    %edx,%eax
c0105803:	c1 e0 02             	shl    $0x2,%eax
c0105806:	01 d0                	add    %edx,%eax
c0105808:	01 c0                	add    %eax,%eax
c010580a:	01 d8                	add    %ebx,%eax
c010580c:	83 e8 30             	sub    $0x30,%eax
c010580f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105812:	8b 45 10             	mov    0x10(%ebp),%eax
c0105815:	0f b6 00             	movzbl (%eax),%eax
c0105818:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010581b:	83 fb 2f             	cmp    $0x2f,%ebx
c010581e:	7e 38                	jle    c0105858 <vprintfmt+0xe4>
c0105820:	83 fb 39             	cmp    $0x39,%ebx
c0105823:	7f 33                	jg     c0105858 <vprintfmt+0xe4>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105825:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105828:	eb d4                	jmp    c01057fe <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010582a:	8b 45 14             	mov    0x14(%ebp),%eax
c010582d:	8d 50 04             	lea    0x4(%eax),%edx
c0105830:	89 55 14             	mov    %edx,0x14(%ebp)
c0105833:	8b 00                	mov    (%eax),%eax
c0105835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105838:	eb 1f                	jmp    c0105859 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c010583a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010583e:	79 87                	jns    c01057c7 <vprintfmt+0x53>
                width = 0;
c0105840:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105847:	e9 7b ff ff ff       	jmp    c01057c7 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c010584c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105853:	e9 6f ff ff ff       	jmp    c01057c7 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c0105858:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c0105859:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010585d:	0f 89 64 ff ff ff    	jns    c01057c7 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105866:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105869:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105870:	e9 52 ff ff ff       	jmp    c01057c7 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105875:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105878:	e9 4a ff ff ff       	jmp    c01057c7 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010587d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105880:	8d 50 04             	lea    0x4(%eax),%edx
c0105883:	89 55 14             	mov    %edx,0x14(%ebp)
c0105886:	8b 00                	mov    (%eax),%eax
c0105888:	8b 55 0c             	mov    0xc(%ebp),%edx
c010588b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010588f:	89 04 24             	mov    %eax,(%esp)
c0105892:	8b 45 08             	mov    0x8(%ebp),%eax
c0105895:	ff d0                	call   *%eax
            break;
c0105897:	e9 a4 02 00 00       	jmp    c0105b40 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010589c:	8b 45 14             	mov    0x14(%ebp),%eax
c010589f:	8d 50 04             	lea    0x4(%eax),%edx
c01058a2:	89 55 14             	mov    %edx,0x14(%ebp)
c01058a5:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01058a7:	85 db                	test   %ebx,%ebx
c01058a9:	79 02                	jns    c01058ad <vprintfmt+0x139>
                err = -err;
c01058ab:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01058ad:	83 fb 06             	cmp    $0x6,%ebx
c01058b0:	7f 0b                	jg     c01058bd <vprintfmt+0x149>
c01058b2:	8b 34 9d a0 6d 10 c0 	mov    -0x3fef9260(,%ebx,4),%esi
c01058b9:	85 f6                	test   %esi,%esi
c01058bb:	75 23                	jne    c01058e0 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c01058bd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01058c1:	c7 44 24 08 cd 6d 10 	movl   $0xc0106dcd,0x8(%esp)
c01058c8:	c0 
c01058c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01058d3:	89 04 24             	mov    %eax,(%esp)
c01058d6:	e8 6a fe ff ff       	call   c0105745 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01058db:	e9 60 02 00 00       	jmp    c0105b40 <vprintfmt+0x3cc>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01058e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01058e4:	c7 44 24 08 d6 6d 10 	movl   $0xc0106dd6,0x8(%esp)
c01058eb:	c0 
c01058ec:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f6:	89 04 24             	mov    %eax,(%esp)
c01058f9:	e8 47 fe ff ff       	call   c0105745 <printfmt>
            }
            break;
c01058fe:	e9 3d 02 00 00       	jmp    c0105b40 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105903:	8b 45 14             	mov    0x14(%ebp),%eax
c0105906:	8d 50 04             	lea    0x4(%eax),%edx
c0105909:	89 55 14             	mov    %edx,0x14(%ebp)
c010590c:	8b 30                	mov    (%eax),%esi
c010590e:	85 f6                	test   %esi,%esi
c0105910:	75 05                	jne    c0105917 <vprintfmt+0x1a3>
                p = "(null)";
c0105912:	be d9 6d 10 c0       	mov    $0xc0106dd9,%esi
            }
            if (width > 0 && padc != '-') {
c0105917:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010591b:	7e 76                	jle    c0105993 <vprintfmt+0x21f>
c010591d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105921:	74 70                	je     c0105993 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105926:	89 44 24 04          	mov    %eax,0x4(%esp)
c010592a:	89 34 24             	mov    %esi,(%esp)
c010592d:	e8 f6 f7 ff ff       	call   c0105128 <strnlen>
c0105932:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105935:	29 c2                	sub    %eax,%edx
c0105937:	89 d0                	mov    %edx,%eax
c0105939:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010593c:	eb 16                	jmp    c0105954 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c010593e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105942:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105945:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105949:	89 04 24             	mov    %eax,(%esp)
c010594c:	8b 45 08             	mov    0x8(%ebp),%eax
c010594f:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105951:	ff 4d e8             	decl   -0x18(%ebp)
c0105954:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105958:	7f e4                	jg     c010593e <vprintfmt+0x1ca>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010595a:	eb 37                	jmp    c0105993 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c010595c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105960:	74 1f                	je     c0105981 <vprintfmt+0x20d>
c0105962:	83 fb 1f             	cmp    $0x1f,%ebx
c0105965:	7e 05                	jle    c010596c <vprintfmt+0x1f8>
c0105967:	83 fb 7e             	cmp    $0x7e,%ebx
c010596a:	7e 15                	jle    c0105981 <vprintfmt+0x20d>
                    putch('?', putdat);
c010596c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010596f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105973:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010597a:	8b 45 08             	mov    0x8(%ebp),%eax
c010597d:	ff d0                	call   *%eax
c010597f:	eb 0f                	jmp    c0105990 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0105981:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105984:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105988:	89 1c 24             	mov    %ebx,(%esp)
c010598b:	8b 45 08             	mov    0x8(%ebp),%eax
c010598e:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105990:	ff 4d e8             	decl   -0x18(%ebp)
c0105993:	89 f0                	mov    %esi,%eax
c0105995:	8d 70 01             	lea    0x1(%eax),%esi
c0105998:	0f b6 00             	movzbl (%eax),%eax
c010599b:	0f be d8             	movsbl %al,%ebx
c010599e:	85 db                	test   %ebx,%ebx
c01059a0:	74 27                	je     c01059c9 <vprintfmt+0x255>
c01059a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059a6:	78 b4                	js     c010595c <vprintfmt+0x1e8>
c01059a8:	ff 4d e4             	decl   -0x1c(%ebp)
c01059ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059af:	79 ab                	jns    c010595c <vprintfmt+0x1e8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01059b1:	eb 16                	jmp    c01059c9 <vprintfmt+0x255>
                putch(' ', putdat);
c01059b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ba:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01059c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c4:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01059c6:	ff 4d e8             	decl   -0x18(%ebp)
c01059c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059cd:	7f e4                	jg     c01059b3 <vprintfmt+0x23f>
                putch(' ', putdat);
            }
            break;
c01059cf:	e9 6c 01 00 00       	jmp    c0105b40 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01059d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059db:	8d 45 14             	lea    0x14(%ebp),%eax
c01059de:	89 04 24             	mov    %eax,(%esp)
c01059e1:	e8 18 fd ff ff       	call   c01056fe <getint>
c01059e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01059ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059f2:	85 d2                	test   %edx,%edx
c01059f4:	79 26                	jns    c0105a1c <vprintfmt+0x2a8>
                putch('-', putdat);
c01059f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059fd:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105a04:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a07:	ff d0                	call   *%eax
                num = -(long long)num;
c0105a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a0f:	f7 d8                	neg    %eax
c0105a11:	83 d2 00             	adc    $0x0,%edx
c0105a14:	f7 da                	neg    %edx
c0105a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a19:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105a1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a23:	e9 a8 00 00 00       	jmp    c0105ad0 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105a28:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a2f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a32:	89 04 24             	mov    %eax,(%esp)
c0105a35:	e8 75 fc ff ff       	call   c01056af <getuint>
c0105a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105a40:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a47:	e9 84 00 00 00       	jmp    c0105ad0 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a53:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a56:	89 04 24             	mov    %eax,(%esp)
c0105a59:	e8 51 fc ff ff       	call   c01056af <getuint>
c0105a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a61:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105a64:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105a6b:	eb 63                	jmp    c0105ad0 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0105a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a70:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a74:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105a7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a7e:	ff d0                	call   *%eax
            putch('x', putdat);
c0105a80:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a87:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a91:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105a93:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a96:	8d 50 04             	lea    0x4(%eax),%edx
c0105a99:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a9c:	8b 00                	mov    (%eax),%eax
c0105a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aa1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105aa8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105aaf:	eb 1f                	jmp    c0105ad0 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ab8:	8d 45 14             	lea    0x14(%ebp),%eax
c0105abb:	89 04 24             	mov    %eax,(%esp)
c0105abe:	e8 ec fb ff ff       	call   c01056af <getuint>
c0105ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ac6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105ac9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105ad0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105ad4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ad7:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105adb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105ade:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105ae2:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105aec:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105af0:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105af4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105af7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105afe:	89 04 24             	mov    %eax,(%esp)
c0105b01:	e8 a4 fa ff ff       	call   c01055aa <printnum>
            break;
c0105b06:	eb 38                	jmp    c0105b40 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105b08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b0f:	89 1c 24             	mov    %ebx,(%esp)
c0105b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b15:	ff d0                	call   *%eax
            break;
c0105b17:	eb 27                	jmp    c0105b40 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105b19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b20:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105b27:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b2a:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105b2c:	ff 4d 10             	decl   0x10(%ebp)
c0105b2f:	eb 03                	jmp    c0105b34 <vprintfmt+0x3c0>
c0105b31:	ff 4d 10             	decl   0x10(%ebp)
c0105b34:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b37:	48                   	dec    %eax
c0105b38:	0f b6 00             	movzbl (%eax),%eax
c0105b3b:	3c 25                	cmp    $0x25,%al
c0105b3d:	75 f2                	jne    c0105b31 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105b3f:	90                   	nop
        }
    }
c0105b40:	e9 37 fc ff ff       	jmp    c010577c <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
c0105b45:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105b46:	83 c4 40             	add    $0x40,%esp
c0105b49:	5b                   	pop    %ebx
c0105b4a:	5e                   	pop    %esi
c0105b4b:	5d                   	pop    %ebp
c0105b4c:	c3                   	ret    

c0105b4d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105b4d:	55                   	push   %ebp
c0105b4e:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105b50:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b53:	8b 40 08             	mov    0x8(%eax),%eax
c0105b56:	8d 50 01             	lea    0x1(%eax),%edx
c0105b59:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b5c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b62:	8b 10                	mov    (%eax),%edx
c0105b64:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b67:	8b 40 04             	mov    0x4(%eax),%eax
c0105b6a:	39 c2                	cmp    %eax,%edx
c0105b6c:	73 12                	jae    c0105b80 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b71:	8b 00                	mov    (%eax),%eax
c0105b73:	8d 48 01             	lea    0x1(%eax),%ecx
c0105b76:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105b79:	89 0a                	mov    %ecx,(%edx)
c0105b7b:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b7e:	88 10                	mov    %dl,(%eax)
    }
}
c0105b80:	90                   	nop
c0105b81:	5d                   	pop    %ebp
c0105b82:	c3                   	ret    

c0105b83 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105b83:	55                   	push   %ebp
c0105b84:	89 e5                	mov    %esp,%ebp
c0105b86:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105b89:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b92:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b96:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b99:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba7:	89 04 24             	mov    %eax,(%esp)
c0105baa:	e8 08 00 00 00       	call   c0105bb7 <vsnprintf>
c0105baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105bb5:	c9                   	leave  
c0105bb6:	c3                   	ret    

c0105bb7 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105bb7:	55                   	push   %ebp
c0105bb8:	89 e5                	mov    %esp,%ebp
c0105bba:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105bbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc6:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105bc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bcc:	01 d0                	add    %edx,%eax
c0105bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105bd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105bdc:	74 0a                	je     c0105be8 <vsnprintf+0x31>
c0105bde:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105be4:	39 c2                	cmp    %eax,%edx
c0105be6:	76 07                	jbe    c0105bef <vsnprintf+0x38>
        return -E_INVAL;
c0105be8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105bed:	eb 2a                	jmp    c0105c19 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105bef:	8b 45 14             	mov    0x14(%ebp),%eax
c0105bf2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105bf6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bf9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105bfd:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105c00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c04:	c7 04 24 4d 5b 10 c0 	movl   $0xc0105b4d,(%esp)
c0105c0b:	e8 64 fb ff ff       	call   c0105774 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c13:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c19:	c9                   	leave  
c0105c1a:	c3                   	ret    
