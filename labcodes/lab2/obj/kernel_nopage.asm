
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 80 11 40       	mov    $0x40118000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 80 11 00       	mov    %eax,0x118000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	ba 28 af 11 00       	mov    $0x11af28,%edx
  100041:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  10005d:	e8 bf 53 00 00       	call   105421 <memset>

    cons_init();                // init the console
  100062:	e8 b9 14 00 00       	call   101520 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 20 5c 10 00 	movl   $0x105c20,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 3c 5c 10 00 	movl   $0x105c3c,(%esp)
  10007c:	e8 0c 02 00 00       	call   10028d <cprintf>

    print_kerninfo();
  100081:	e8 ad 08 00 00       	call   100933 <print_kerninfo>

    // grade_backtrace();

    pmm_init();                 // init physical memory management
  100086:	e8 66 2f 00 00       	call   102ff1 <pmm_init>

    pic_init();                 // init interrupt controller
  10008b:	e8 f4 15 00 00       	call   101684 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100090:	e8 4d 17 00 00       	call   1017e2 <idt_init>

    clock_init();               // init clock interrupt
  100095:	e8 39 0c 00 00       	call   100cd3 <clock_init>
    intr_enable();              // enable irq interrupt
  10009a:	e8 18 17 00 00       	call   1017b7 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10009f:	eb fe                	jmp    10009f <kern_init+0x69>

001000a1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a1:	55                   	push   %ebp
  1000a2:	89 e5                	mov    %esp,%ebp
  1000a4:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000ae:	00 
  1000af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b6:	00 
  1000b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000be:	e8 fe 0b 00 00       	call   100cc1 <mon_backtrace>
}
  1000c3:	90                   	nop
  1000c4:	c9                   	leave  
  1000c5:	c3                   	ret    

001000c6 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c6:	55                   	push   %ebp
  1000c7:	89 e5                	mov    %esp,%ebp
  1000c9:	53                   	push   %ebx
  1000ca:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000cd:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000d3:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000dd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000e1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000e5:	89 04 24             	mov    %eax,(%esp)
  1000e8:	e8 b4 ff ff ff       	call   1000a1 <grade_backtrace2>
}
  1000ed:	90                   	nop
  1000ee:	83 c4 14             	add    $0x14,%esp
  1000f1:	5b                   	pop    %ebx
  1000f2:	5d                   	pop    %ebp
  1000f3:	c3                   	ret    

001000f4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000f4:	55                   	push   %ebp
  1000f5:	89 e5                	mov    %esp,%ebp
  1000f7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000fa:	8b 45 10             	mov    0x10(%ebp),%eax
  1000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100101:	8b 45 08             	mov    0x8(%ebp),%eax
  100104:	89 04 24             	mov    %eax,(%esp)
  100107:	e8 ba ff ff ff       	call   1000c6 <grade_backtrace1>
}
  10010c:	90                   	nop
  10010d:	c9                   	leave  
  10010e:	c3                   	ret    

0010010f <grade_backtrace>:

void
grade_backtrace(void) {
  10010f:	55                   	push   %ebp
  100110:	89 e5                	mov    %esp,%ebp
  100112:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100115:	b8 36 00 10 00       	mov    $0x100036,%eax
  10011a:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100121:	ff 
  100122:	89 44 24 04          	mov    %eax,0x4(%esp)
  100126:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10012d:	e8 c2 ff ff ff       	call   1000f4 <grade_backtrace0>
}
  100132:	90                   	nop
  100133:	c9                   	leave  
  100134:	c3                   	ret    

00100135 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100135:	55                   	push   %ebp
  100136:	89 e5                	mov    %esp,%ebp
  100138:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10013b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10013e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100141:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100144:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100147:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10014b:	83 e0 03             	and    $0x3,%eax
  10014e:	89 c2                	mov    %eax,%edx
  100150:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100155:	89 54 24 08          	mov    %edx,0x8(%esp)
  100159:	89 44 24 04          	mov    %eax,0x4(%esp)
  10015d:	c7 04 24 41 5c 10 00 	movl   $0x105c41,(%esp)
  100164:	e8 24 01 00 00       	call   10028d <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100169:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10016d:	89 c2                	mov    %eax,%edx
  10016f:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100174:	89 54 24 08          	mov    %edx,0x8(%esp)
  100178:	89 44 24 04          	mov    %eax,0x4(%esp)
  10017c:	c7 04 24 4f 5c 10 00 	movl   $0x105c4f,(%esp)
  100183:	e8 05 01 00 00       	call   10028d <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100188:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10018c:	89 c2                	mov    %eax,%edx
  10018e:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100193:	89 54 24 08          	mov    %edx,0x8(%esp)
  100197:	89 44 24 04          	mov    %eax,0x4(%esp)
  10019b:	c7 04 24 5d 5c 10 00 	movl   $0x105c5d,(%esp)
  1001a2:	e8 e6 00 00 00       	call   10028d <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001ab:	89 c2                	mov    %eax,%edx
  1001ad:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001b2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ba:	c7 04 24 6b 5c 10 00 	movl   $0x105c6b,(%esp)
  1001c1:	e8 c7 00 00 00       	call   10028d <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c6:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001ca:	89 c2                	mov    %eax,%edx
  1001cc:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d9:	c7 04 24 79 5c 10 00 	movl   $0x105c79,(%esp)
  1001e0:	e8 a8 00 00 00       	call   10028d <cprintf>
    round ++;
  1001e5:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001ea:	40                   	inc    %eax
  1001eb:	a3 00 a0 11 00       	mov    %eax,0x11a000
}
  1001f0:	90                   	nop
  1001f1:	c9                   	leave  
  1001f2:	c3                   	ret    

001001f3 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f3:	55                   	push   %ebp
  1001f4:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f6:	90                   	nop
  1001f7:	5d                   	pop    %ebp
  1001f8:	c3                   	ret    

001001f9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f9:	55                   	push   %ebp
  1001fa:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001fc:	90                   	nop
  1001fd:	5d                   	pop    %ebp
  1001fe:	c3                   	ret    

001001ff <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ff:	55                   	push   %ebp
  100200:	89 e5                	mov    %esp,%ebp
  100202:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100205:	e8 2b ff ff ff       	call   100135 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10020a:	c7 04 24 88 5c 10 00 	movl   $0x105c88,(%esp)
  100211:	e8 77 00 00 00       	call   10028d <cprintf>
    lab1_switch_to_user();
  100216:	e8 d8 ff ff ff       	call   1001f3 <lab1_switch_to_user>
    lab1_print_cur_status();
  10021b:	e8 15 ff ff ff       	call   100135 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100220:	c7 04 24 a8 5c 10 00 	movl   $0x105ca8,(%esp)
  100227:	e8 61 00 00 00       	call   10028d <cprintf>
    lab1_switch_to_kernel();
  10022c:	e8 c8 ff ff ff       	call   1001f9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100231:	e8 ff fe ff ff       	call   100135 <lab1_print_cur_status>
}
  100236:	90                   	nop
  100237:	c9                   	leave  
  100238:	c3                   	ret    

00100239 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100239:	55                   	push   %ebp
  10023a:	89 e5                	mov    %esp,%ebp
  10023c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 04 24             	mov    %eax,(%esp)
  100245:	e8 03 13 00 00       	call   10154d <cons_putc>
    (*cnt) ++;
  10024a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10024d:	8b 00                	mov    (%eax),%eax
  10024f:	8d 50 01             	lea    0x1(%eax),%edx
  100252:	8b 45 0c             	mov    0xc(%ebp),%eax
  100255:	89 10                	mov    %edx,(%eax)
}
  100257:	90                   	nop
  100258:	c9                   	leave  
  100259:	c3                   	ret    

0010025a <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10025a:	55                   	push   %ebp
  10025b:	89 e5                	mov    %esp,%ebp
  10025d:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100260:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100267:	8b 45 0c             	mov    0xc(%ebp),%eax
  10026a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10026e:	8b 45 08             	mov    0x8(%ebp),%eax
  100271:	89 44 24 08          	mov    %eax,0x8(%esp)
  100275:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100278:	89 44 24 04          	mov    %eax,0x4(%esp)
  10027c:	c7 04 24 39 02 10 00 	movl   $0x100239,(%esp)
  100283:	e8 ec 54 00 00       	call   105774 <vprintfmt>
    return cnt;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10028b:	c9                   	leave  
  10028c:	c3                   	ret    

0010028d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10028d:	55                   	push   %ebp
  10028e:	89 e5                	mov    %esp,%ebp
  100290:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100293:	8d 45 0c             	lea    0xc(%ebp),%eax
  100296:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100299:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a3:	89 04 24             	mov    %eax,(%esp)
  1002a6:	e8 af ff ff ff       	call   10025a <vcprintf>
  1002ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002b1:	c9                   	leave  
  1002b2:	c3                   	ret    

001002b3 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002b3:	55                   	push   %ebp
  1002b4:	89 e5                	mov    %esp,%ebp
  1002b6:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1002bc:	89 04 24             	mov    %eax,(%esp)
  1002bf:	e8 89 12 00 00       	call   10154d <cons_putc>
}
  1002c4:	90                   	nop
  1002c5:	c9                   	leave  
  1002c6:	c3                   	ret    

001002c7 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002c7:	55                   	push   %ebp
  1002c8:	89 e5                	mov    %esp,%ebp
  1002ca:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002d4:	eb 13                	jmp    1002e9 <cputs+0x22>
        cputch(c, &cnt);
  1002d6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002da:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002dd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002e1:	89 04 24             	mov    %eax,(%esp)
  1002e4:	e8 50 ff ff ff       	call   100239 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ec:	8d 50 01             	lea    0x1(%eax),%edx
  1002ef:	89 55 08             	mov    %edx,0x8(%ebp)
  1002f2:	0f b6 00             	movzbl (%eax),%eax
  1002f5:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002f8:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002fc:	75 d8                	jne    1002d6 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002fe:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100301:	89 44 24 04          	mov    %eax,0x4(%esp)
  100305:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10030c:	e8 28 ff ff ff       	call   100239 <cputch>
    return cnt;
  100311:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100314:	c9                   	leave  
  100315:	c3                   	ret    

00100316 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100316:	55                   	push   %ebp
  100317:	89 e5                	mov    %esp,%ebp
  100319:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  10031c:	e8 69 12 00 00       	call   10158a <cons_getc>
  100321:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100328:	74 f2                	je     10031c <getchar+0x6>
        /* do nothing */;
    return c;
  10032a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10032d:	c9                   	leave  
  10032e:	c3                   	ret    

0010032f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10032f:	55                   	push   %ebp
  100330:	89 e5                	mov    %esp,%ebp
  100332:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100335:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100339:	74 13                	je     10034e <readline+0x1f>
        cprintf("%s", prompt);
  10033b:	8b 45 08             	mov    0x8(%ebp),%eax
  10033e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100342:	c7 04 24 c7 5c 10 00 	movl   $0x105cc7,(%esp)
  100349:	e8 3f ff ff ff       	call   10028d <cprintf>
    }
    int i = 0, c;
  10034e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100355:	e8 bc ff ff ff       	call   100316 <getchar>
  10035a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10035d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100361:	79 07                	jns    10036a <readline+0x3b>
            return NULL;
  100363:	b8 00 00 00 00       	mov    $0x0,%eax
  100368:	eb 78                	jmp    1003e2 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10036a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10036e:	7e 28                	jle    100398 <readline+0x69>
  100370:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100377:	7f 1f                	jg     100398 <readline+0x69>
            cputchar(c);
  100379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10037c:	89 04 24             	mov    %eax,(%esp)
  10037f:	e8 2f ff ff ff       	call   1002b3 <cputchar>
            buf[i ++] = c;
  100384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100387:	8d 50 01             	lea    0x1(%eax),%edx
  10038a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10038d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100390:	88 90 20 a0 11 00    	mov    %dl,0x11a020(%eax)
  100396:	eb 45                	jmp    1003dd <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  100398:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10039c:	75 16                	jne    1003b4 <readline+0x85>
  10039e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003a2:	7e 10                	jle    1003b4 <readline+0x85>
            cputchar(c);
  1003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003a7:	89 04 24             	mov    %eax,(%esp)
  1003aa:	e8 04 ff ff ff       	call   1002b3 <cputchar>
            i --;
  1003af:	ff 4d f4             	decl   -0xc(%ebp)
  1003b2:	eb 29                	jmp    1003dd <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1003b4:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003b8:	74 06                	je     1003c0 <readline+0x91>
  1003ba:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003be:	75 95                	jne    100355 <readline+0x26>
            cputchar(c);
  1003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c3:	89 04 24             	mov    %eax,(%esp)
  1003c6:	e8 e8 fe ff ff       	call   1002b3 <cputchar>
            buf[i] = '\0';
  1003cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ce:	05 20 a0 11 00       	add    $0x11a020,%eax
  1003d3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003d6:	b8 20 a0 11 00       	mov    $0x11a020,%eax
  1003db:	eb 05                	jmp    1003e2 <readline+0xb3>
        }
    }
  1003dd:	e9 73 ff ff ff       	jmp    100355 <readline+0x26>
}
  1003e2:	c9                   	leave  
  1003e3:	c3                   	ret    

001003e4 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003e4:	55                   	push   %ebp
  1003e5:	89 e5                	mov    %esp,%ebp
  1003e7:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003ea:	a1 20 a4 11 00       	mov    0x11a420,%eax
  1003ef:	85 c0                	test   %eax,%eax
  1003f1:	75 5b                	jne    10044e <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003f3:	c7 05 20 a4 11 00 01 	movl   $0x1,0x11a420
  1003fa:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003fd:	8d 45 14             	lea    0x14(%ebp),%eax
  100400:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100403:	8b 45 0c             	mov    0xc(%ebp),%eax
  100406:	89 44 24 08          	mov    %eax,0x8(%esp)
  10040a:	8b 45 08             	mov    0x8(%ebp),%eax
  10040d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100411:	c7 04 24 ca 5c 10 00 	movl   $0x105cca,(%esp)
  100418:	e8 70 fe ff ff       	call   10028d <cprintf>
    vcprintf(fmt, ap);
  10041d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100420:	89 44 24 04          	mov    %eax,0x4(%esp)
  100424:	8b 45 10             	mov    0x10(%ebp),%eax
  100427:	89 04 24             	mov    %eax,(%esp)
  10042a:	e8 2b fe ff ff       	call   10025a <vcprintf>
    cprintf("\n");
  10042f:	c7 04 24 e6 5c 10 00 	movl   $0x105ce6,(%esp)
  100436:	e8 52 fe ff ff       	call   10028d <cprintf>
    
    cprintf("stack trackback:\n");
  10043b:	c7 04 24 e8 5c 10 00 	movl   $0x105ce8,(%esp)
  100442:	e8 46 fe ff ff       	call   10028d <cprintf>
    print_stackframe();
  100447:	e8 32 06 00 00       	call   100a7e <print_stackframe>
  10044c:	eb 01                	jmp    10044f <__panic+0x6b>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  10044e:	90                   	nop
    print_stackframe();
    
    va_end(ap);

panic_dead:
    intr_disable();
  10044f:	e8 6a 13 00 00       	call   1017be <intr_disable>
    while (1) {
        kmonitor(NULL);
  100454:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10045b:	e8 94 07 00 00       	call   100bf4 <kmonitor>
    }
  100460:	eb f2                	jmp    100454 <__panic+0x70>

00100462 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100462:	55                   	push   %ebp
  100463:	89 e5                	mov    %esp,%ebp
  100465:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100468:	8d 45 14             	lea    0x14(%ebp),%eax
  10046b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10046e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100471:	89 44 24 08          	mov    %eax,0x8(%esp)
  100475:	8b 45 08             	mov    0x8(%ebp),%eax
  100478:	89 44 24 04          	mov    %eax,0x4(%esp)
  10047c:	c7 04 24 fa 5c 10 00 	movl   $0x105cfa,(%esp)
  100483:	e8 05 fe ff ff       	call   10028d <cprintf>
    vcprintf(fmt, ap);
  100488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10048b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10048f:	8b 45 10             	mov    0x10(%ebp),%eax
  100492:	89 04 24             	mov    %eax,(%esp)
  100495:	e8 c0 fd ff ff       	call   10025a <vcprintf>
    cprintf("\n");
  10049a:	c7 04 24 e6 5c 10 00 	movl   $0x105ce6,(%esp)
  1004a1:	e8 e7 fd ff ff       	call   10028d <cprintf>
    va_end(ap);
}
  1004a6:	90                   	nop
  1004a7:	c9                   	leave  
  1004a8:	c3                   	ret    

001004a9 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004a9:	55                   	push   %ebp
  1004aa:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004ac:	a1 20 a4 11 00       	mov    0x11a420,%eax
}
  1004b1:	5d                   	pop    %ebp
  1004b2:	c3                   	ret    

001004b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004b3:	55                   	push   %ebp
  1004b4:	89 e5                	mov    %esp,%ebp
  1004b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	8b 00                	mov    (%eax),%eax
  1004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004d0:	e9 ca 00 00 00       	jmp    10059f <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004db:	01 d0                	add    %edx,%eax
  1004dd:	89 c2                	mov    %eax,%edx
  1004df:	c1 ea 1f             	shr    $0x1f,%edx
  1004e2:	01 d0                	add    %edx,%eax
  1004e4:	d1 f8                	sar    %eax
  1004e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ef:	eb 03                	jmp    1004f4 <stab_binsearch+0x41>
            m --;
  1004f1:	ff 4d f0             	decl   -0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004f7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004fa:	7c 1f                	jl     10051b <stab_binsearch+0x68>
  1004fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ff:	89 d0                	mov    %edx,%eax
  100501:	01 c0                	add    %eax,%eax
  100503:	01 d0                	add    %edx,%eax
  100505:	c1 e0 02             	shl    $0x2,%eax
  100508:	89 c2                	mov    %eax,%edx
  10050a:	8b 45 08             	mov    0x8(%ebp),%eax
  10050d:	01 d0                	add    %edx,%eax
  10050f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100513:	0f b6 c0             	movzbl %al,%eax
  100516:	3b 45 14             	cmp    0x14(%ebp),%eax
  100519:	75 d6                	jne    1004f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10051b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10051e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100521:	7d 09                	jge    10052c <stab_binsearch+0x79>
            l = true_m + 1;
  100523:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100526:	40                   	inc    %eax
  100527:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10052a:	eb 73                	jmp    10059f <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  10052c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100533:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100536:	89 d0                	mov    %edx,%eax
  100538:	01 c0                	add    %eax,%eax
  10053a:	01 d0                	add    %edx,%eax
  10053c:	c1 e0 02             	shl    $0x2,%eax
  10053f:	89 c2                	mov    %eax,%edx
  100541:	8b 45 08             	mov    0x8(%ebp),%eax
  100544:	01 d0                	add    %edx,%eax
  100546:	8b 40 08             	mov    0x8(%eax),%eax
  100549:	3b 45 18             	cmp    0x18(%ebp),%eax
  10054c:	73 11                	jae    10055f <stab_binsearch+0xac>
            *region_left = m;
  10054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100551:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100554:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100556:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100559:	40                   	inc    %eax
  10055a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10055d:	eb 40                	jmp    10059f <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  10055f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100562:	89 d0                	mov    %edx,%eax
  100564:	01 c0                	add    %eax,%eax
  100566:	01 d0                	add    %edx,%eax
  100568:	c1 e0 02             	shl    $0x2,%eax
  10056b:	89 c2                	mov    %eax,%edx
  10056d:	8b 45 08             	mov    0x8(%ebp),%eax
  100570:	01 d0                	add    %edx,%eax
  100572:	8b 40 08             	mov    0x8(%eax),%eax
  100575:	3b 45 18             	cmp    0x18(%ebp),%eax
  100578:	76 14                	jbe    10058e <stab_binsearch+0xdb>
            *region_right = m - 1;
  10057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057d:	8d 50 ff             	lea    -0x1(%eax),%edx
  100580:	8b 45 10             	mov    0x10(%ebp),%eax
  100583:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100588:	48                   	dec    %eax
  100589:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10058c:	eb 11                	jmp    10059f <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10058e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100591:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100594:	89 10                	mov    %edx,(%eax)
            l = m;
  100596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100599:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10059c:	ff 45 18             	incl   0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  10059f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005a5:	0f 8e 2a ff ff ff    	jle    1004d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1005ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005af:	75 0f                	jne    1005c0 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1005b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b4:	8b 00                	mov    (%eax),%eax
  1005b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005b9:	8b 45 10             	mov    0x10(%ebp),%eax
  1005bc:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005be:	eb 3e                	jmp    1005fe <stab_binsearch+0x14b>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005c0:	8b 45 10             	mov    0x10(%ebp),%eax
  1005c3:	8b 00                	mov    (%eax),%eax
  1005c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005c8:	eb 03                	jmp    1005cd <stab_binsearch+0x11a>
  1005ca:	ff 4d fc             	decl   -0x4(%ebp)
  1005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d0:	8b 00                	mov    (%eax),%eax
  1005d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005d5:	7d 1f                	jge    1005f6 <stab_binsearch+0x143>
  1005d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005da:	89 d0                	mov    %edx,%eax
  1005dc:	01 c0                	add    %eax,%eax
  1005de:	01 d0                	add    %edx,%eax
  1005e0:	c1 e0 02             	shl    $0x2,%eax
  1005e3:	89 c2                	mov    %eax,%edx
  1005e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e8:	01 d0                	add    %edx,%eax
  1005ea:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005ee:	0f b6 c0             	movzbl %al,%eax
  1005f1:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005f4:	75 d4                	jne    1005ca <stab_binsearch+0x117>
            /* do nothing */;
        *region_left = l;
  1005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005fc:	89 10                	mov    %edx,(%eax)
    }
}
  1005fe:	90                   	nop
  1005ff:	c9                   	leave  
  100600:	c3                   	ret    

00100601 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100601:	55                   	push   %ebp
  100602:	89 e5                	mov    %esp,%ebp
  100604:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100607:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060a:	c7 00 18 5d 10 00    	movl   $0x105d18,(%eax)
    info->eip_line = 0;
  100610:	8b 45 0c             	mov    0xc(%ebp),%eax
  100613:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10061a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061d:	c7 40 08 18 5d 10 00 	movl   $0x105d18,0x8(%eax)
    info->eip_fn_namelen = 9;
  100624:	8b 45 0c             	mov    0xc(%ebp),%eax
  100627:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10062e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100631:	8b 55 08             	mov    0x8(%ebp),%edx
  100634:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100637:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100641:	c7 45 f4 38 6f 10 00 	movl   $0x106f38,-0xc(%ebp)
    stab_end = __STAB_END__;
  100648:	c7 45 f0 00 19 11 00 	movl   $0x111900,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10064f:	c7 45 ec 01 19 11 00 	movl   $0x111901,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100656:	c7 45 e8 3f 43 11 00 	movl   $0x11433f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10065d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100660:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100663:	76 0b                	jbe    100670 <debuginfo_eip+0x6f>
  100665:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100668:	48                   	dec    %eax
  100669:	0f b6 00             	movzbl (%eax),%eax
  10066c:	84 c0                	test   %al,%al
  10066e:	74 0a                	je     10067a <debuginfo_eip+0x79>
        return -1;
  100670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100675:	e9 b7 02 00 00       	jmp    100931 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10067a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100681:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100687:	29 c2                	sub    %eax,%edx
  100689:	89 d0                	mov    %edx,%eax
  10068b:	c1 f8 02             	sar    $0x2,%eax
  10068e:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100694:	48                   	dec    %eax
  100695:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100698:	8b 45 08             	mov    0x8(%ebp),%eax
  10069b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10069f:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006a6:	00 
  1006a7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ae:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006b8:	89 04 24             	mov    %eax,(%esp)
  1006bb:	e8 f3 fd ff ff       	call   1004b3 <stab_binsearch>
    if (lfile == 0)
  1006c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006c3:	85 c0                	test   %eax,%eax
  1006c5:	75 0a                	jne    1006d1 <debuginfo_eip+0xd0>
        return -1;
  1006c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006cc:	e9 60 02 00 00       	jmp    100931 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1006e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006e4:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006eb:	00 
  1006ec:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006f3:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006fd:	89 04 24             	mov    %eax,(%esp)
  100700:	e8 ae fd ff ff       	call   1004b3 <stab_binsearch>

    if (lfun <= rfun) {
  100705:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100708:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10070b:	39 c2                	cmp    %eax,%edx
  10070d:	7f 7c                	jg     10078b <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10070f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	89 d0                	mov    %edx,%eax
  100716:	01 c0                	add    %eax,%eax
  100718:	01 d0                	add    %edx,%eax
  10071a:	c1 e0 02             	shl    $0x2,%eax
  10071d:	89 c2                	mov    %eax,%edx
  10071f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100722:	01 d0                	add    %edx,%eax
  100724:	8b 00                	mov    (%eax),%eax
  100726:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100729:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10072c:	29 d1                	sub    %edx,%ecx
  10072e:	89 ca                	mov    %ecx,%edx
  100730:	39 d0                	cmp    %edx,%eax
  100732:	73 22                	jae    100756 <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100734:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100737:	89 c2                	mov    %eax,%edx
  100739:	89 d0                	mov    %edx,%eax
  10073b:	01 c0                	add    %eax,%eax
  10073d:	01 d0                	add    %edx,%eax
  10073f:	c1 e0 02             	shl    $0x2,%eax
  100742:	89 c2                	mov    %eax,%edx
  100744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100747:	01 d0                	add    %edx,%eax
  100749:	8b 10                	mov    (%eax),%edx
  10074b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10074e:	01 c2                	add    %eax,%edx
  100750:	8b 45 0c             	mov    0xc(%ebp),%eax
  100753:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100756:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100759:	89 c2                	mov    %eax,%edx
  10075b:	89 d0                	mov    %edx,%eax
  10075d:	01 c0                	add    %eax,%eax
  10075f:	01 d0                	add    %edx,%eax
  100761:	c1 e0 02             	shl    $0x2,%eax
  100764:	89 c2                	mov    %eax,%edx
  100766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100769:	01 d0                	add    %edx,%eax
  10076b:	8b 50 08             	mov    0x8(%eax),%edx
  10076e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100771:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100774:	8b 45 0c             	mov    0xc(%ebp),%eax
  100777:	8b 40 10             	mov    0x10(%eax),%eax
  10077a:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10077d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100780:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100783:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100786:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100789:	eb 15                	jmp    1007a0 <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10078b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078e:	8b 55 08             	mov    0x8(%ebp),%edx
  100791:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100794:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100797:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  10079a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10079d:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a3:	8b 40 08             	mov    0x8(%eax),%eax
  1007a6:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007ad:	00 
  1007ae:	89 04 24             	mov    %eax,(%esp)
  1007b1:	e8 e7 4a 00 00       	call   10529d <strfind>
  1007b6:	89 c2                	mov    %eax,%edx
  1007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007bb:	8b 40 08             	mov    0x8(%eax),%eax
  1007be:	29 c2                	sub    %eax,%edx
  1007c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c3:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1007c9:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007cd:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007d4:	00 
  1007d5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007dc:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e6:	89 04 24             	mov    %eax,(%esp)
  1007e9:	e8 c5 fc ff ff       	call   1004b3 <stab_binsearch>
    if (lline <= rline) {
  1007ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007f4:	39 c2                	cmp    %eax,%edx
  1007f6:	7f 23                	jg     10081b <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
  1007f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007fb:	89 c2                	mov    %eax,%edx
  1007fd:	89 d0                	mov    %edx,%eax
  1007ff:	01 c0                	add    %eax,%eax
  100801:	01 d0                	add    %edx,%eax
  100803:	c1 e0 02             	shl    $0x2,%eax
  100806:	89 c2                	mov    %eax,%edx
  100808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10080b:	01 d0                	add    %edx,%eax
  10080d:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100811:	89 c2                	mov    %eax,%edx
  100813:	8b 45 0c             	mov    0xc(%ebp),%eax
  100816:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100819:	eb 11                	jmp    10082c <debuginfo_eip+0x22b>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10081b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100820:	e9 0c 01 00 00       	jmp    100931 <debuginfo_eip+0x330>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100825:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100828:	48                   	dec    %eax
  100829:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10082c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100832:	39 c2                	cmp    %eax,%edx
  100834:	7c 56                	jl     10088c <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
  100836:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	89 d0                	mov    %edx,%eax
  10083d:	01 c0                	add    %eax,%eax
  10083f:	01 d0                	add    %edx,%eax
  100841:	c1 e0 02             	shl    $0x2,%eax
  100844:	89 c2                	mov    %eax,%edx
  100846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100849:	01 d0                	add    %edx,%eax
  10084b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084f:	3c 84                	cmp    $0x84,%al
  100851:	74 39                	je     10088c <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100856:	89 c2                	mov    %eax,%edx
  100858:	89 d0                	mov    %edx,%eax
  10085a:	01 c0                	add    %eax,%eax
  10085c:	01 d0                	add    %edx,%eax
  10085e:	c1 e0 02             	shl    $0x2,%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100866:	01 d0                	add    %edx,%eax
  100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10086c:	3c 64                	cmp    $0x64,%al
  10086e:	75 b5                	jne    100825 <debuginfo_eip+0x224>
  100870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100873:	89 c2                	mov    %eax,%edx
  100875:	89 d0                	mov    %edx,%eax
  100877:	01 c0                	add    %eax,%eax
  100879:	01 d0                	add    %edx,%eax
  10087b:	c1 e0 02             	shl    $0x2,%eax
  10087e:	89 c2                	mov    %eax,%edx
  100880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100883:	01 d0                	add    %edx,%eax
  100885:	8b 40 08             	mov    0x8(%eax),%eax
  100888:	85 c0                	test   %eax,%eax
  10088a:	74 99                	je     100825 <debuginfo_eip+0x224>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10088c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10088f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100892:	39 c2                	cmp    %eax,%edx
  100894:	7c 46                	jl     1008dc <debuginfo_eip+0x2db>
  100896:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100899:	89 c2                	mov    %eax,%edx
  10089b:	89 d0                	mov    %edx,%eax
  10089d:	01 c0                	add    %eax,%eax
  10089f:	01 d0                	add    %edx,%eax
  1008a1:	c1 e0 02             	shl    $0x2,%eax
  1008a4:	89 c2                	mov    %eax,%edx
  1008a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a9:	01 d0                	add    %edx,%eax
  1008ab:	8b 00                	mov    (%eax),%eax
  1008ad:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1008b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1008b3:	29 d1                	sub    %edx,%ecx
  1008b5:	89 ca                	mov    %ecx,%edx
  1008b7:	39 d0                	cmp    %edx,%eax
  1008b9:	73 21                	jae    1008dc <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008be:	89 c2                	mov    %eax,%edx
  1008c0:	89 d0                	mov    %edx,%eax
  1008c2:	01 c0                	add    %eax,%eax
  1008c4:	01 d0                	add    %edx,%eax
  1008c6:	c1 e0 02             	shl    $0x2,%eax
  1008c9:	89 c2                	mov    %eax,%edx
  1008cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ce:	01 d0                	add    %edx,%eax
  1008d0:	8b 10                	mov    (%eax),%edx
  1008d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008d5:	01 c2                	add    %eax,%edx
  1008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008da:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008e2:	39 c2                	cmp    %eax,%edx
  1008e4:	7d 46                	jge    10092c <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
  1008e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008e9:	40                   	inc    %eax
  1008ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008ed:	eb 16                	jmp    100905 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f2:	8b 40 14             	mov    0x14(%eax),%eax
  1008f5:	8d 50 01             	lea    0x1(%eax),%edx
  1008f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008fb:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100901:	40                   	inc    %eax
  100902:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100905:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100908:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10090b:	39 c2                	cmp    %eax,%edx
  10090d:	7d 1d                	jge    10092c <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10090f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100912:	89 c2                	mov    %eax,%edx
  100914:	89 d0                	mov    %edx,%eax
  100916:	01 c0                	add    %eax,%eax
  100918:	01 d0                	add    %edx,%eax
  10091a:	c1 e0 02             	shl    $0x2,%eax
  10091d:	89 c2                	mov    %eax,%edx
  10091f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100922:	01 d0                	add    %edx,%eax
  100924:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100928:	3c a0                	cmp    $0xa0,%al
  10092a:	74 c3                	je     1008ef <debuginfo_eip+0x2ee>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10092c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100931:	c9                   	leave  
  100932:	c3                   	ret    

00100933 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100933:	55                   	push   %ebp
  100934:	89 e5                	mov    %esp,%ebp
  100936:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100939:	c7 04 24 22 5d 10 00 	movl   $0x105d22,(%esp)
  100940:	e8 48 f9 ff ff       	call   10028d <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100945:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  10094c:	00 
  10094d:	c7 04 24 3b 5d 10 00 	movl   $0x105d3b,(%esp)
  100954:	e8 34 f9 ff ff       	call   10028d <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100959:	c7 44 24 04 1b 5c 10 	movl   $0x105c1b,0x4(%esp)
  100960:	00 
  100961:	c7 04 24 53 5d 10 00 	movl   $0x105d53,(%esp)
  100968:	e8 20 f9 ff ff       	call   10028d <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10096d:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  100974:	00 
  100975:	c7 04 24 6b 5d 10 00 	movl   $0x105d6b,(%esp)
  10097c:	e8 0c f9 ff ff       	call   10028d <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100981:	c7 44 24 04 28 af 11 	movl   $0x11af28,0x4(%esp)
  100988:	00 
  100989:	c7 04 24 83 5d 10 00 	movl   $0x105d83,(%esp)
  100990:	e8 f8 f8 ff ff       	call   10028d <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100995:	b8 28 af 11 00       	mov    $0x11af28,%eax
  10099a:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009a0:	b8 36 00 10 00       	mov    $0x100036,%eax
  1009a5:	29 c2                	sub    %eax,%edx
  1009a7:	89 d0                	mov    %edx,%eax
  1009a9:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009af:	85 c0                	test   %eax,%eax
  1009b1:	0f 48 c2             	cmovs  %edx,%eax
  1009b4:	c1 f8 0a             	sar    $0xa,%eax
  1009b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009bb:	c7 04 24 9c 5d 10 00 	movl   $0x105d9c,(%esp)
  1009c2:	e8 c6 f8 ff ff       	call   10028d <cprintf>
}
  1009c7:	90                   	nop
  1009c8:	c9                   	leave  
  1009c9:	c3                   	ret    

001009ca <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009ca:	55                   	push   %ebp
  1009cb:	89 e5                	mov    %esp,%ebp
  1009cd:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009d3:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009da:	8b 45 08             	mov    0x8(%ebp),%eax
  1009dd:	89 04 24             	mov    %eax,(%esp)
  1009e0:	e8 1c fc ff ff       	call   100601 <debuginfo_eip>
  1009e5:	85 c0                	test   %eax,%eax
  1009e7:	74 15                	je     1009fe <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f0:	c7 04 24 c6 5d 10 00 	movl   $0x105dc6,(%esp)
  1009f7:	e8 91 f8 ff ff       	call   10028d <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009fc:	eb 6c                	jmp    100a6a <print_debuginfo+0xa0>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a05:	eb 1b                	jmp    100a22 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100a07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a0d:	01 d0                	add    %edx,%eax
  100a0f:	0f b6 00             	movzbl (%eax),%eax
  100a12:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a1b:	01 ca                	add    %ecx,%edx
  100a1d:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a1f:	ff 45 f4             	incl   -0xc(%ebp)
  100a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a25:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100a28:	7f dd                	jg     100a07 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100a2a:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a33:	01 d0                	add    %edx,%eax
  100a35:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a38:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a3b:	8b 55 08             	mov    0x8(%ebp),%edx
  100a3e:	89 d1                	mov    %edx,%ecx
  100a40:	29 c1                	sub    %eax,%ecx
  100a42:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a48:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a4c:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a52:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a56:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a5e:	c7 04 24 e2 5d 10 00 	movl   $0x105de2,(%esp)
  100a65:	e8 23 f8 ff ff       	call   10028d <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  100a6a:	90                   	nop
  100a6b:	c9                   	leave  
  100a6c:	c3                   	ret    

00100a6d <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a6d:	55                   	push   %ebp
  100a6e:	89 e5                	mov    %esp,%ebp
  100a70:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a73:	8b 45 04             	mov    0x4(%ebp),%eax
  100a76:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a79:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a7c:	c9                   	leave  
  100a7d:	c3                   	ret    

00100a7e <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a7e:	55                   	push   %ebp
  100a7f:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100a81:	90                   	nop
  100a82:	5d                   	pop    %ebp
  100a83:	c3                   	ret    

00100a84 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a84:	55                   	push   %ebp
  100a85:	89 e5                	mov    %esp,%ebp
  100a87:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a91:	eb 0c                	jmp    100a9f <parse+0x1b>
            *buf ++ = '\0';
  100a93:	8b 45 08             	mov    0x8(%ebp),%eax
  100a96:	8d 50 01             	lea    0x1(%eax),%edx
  100a99:	89 55 08             	mov    %edx,0x8(%ebp)
  100a9c:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa2:	0f b6 00             	movzbl (%eax),%eax
  100aa5:	84 c0                	test   %al,%al
  100aa7:	74 1d                	je     100ac6 <parse+0x42>
  100aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  100aac:	0f b6 00             	movzbl (%eax),%eax
  100aaf:	0f be c0             	movsbl %al,%eax
  100ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab6:	c7 04 24 74 5e 10 00 	movl   $0x105e74,(%esp)
  100abd:	e8 a9 47 00 00       	call   10526b <strchr>
  100ac2:	85 c0                	test   %eax,%eax
  100ac4:	75 cd                	jne    100a93 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac9:	0f b6 00             	movzbl (%eax),%eax
  100acc:	84 c0                	test   %al,%al
  100ace:	74 69                	je     100b39 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ad0:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad4:	75 14                	jne    100aea <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad6:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100add:	00 
  100ade:	c7 04 24 79 5e 10 00 	movl   $0x105e79,(%esp)
  100ae5:	e8 a3 f7 ff ff       	call   10028d <cprintf>
        }
        argv[argc ++] = buf;
  100aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aed:	8d 50 01             	lea    0x1(%eax),%edx
  100af0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  100afd:	01 c2                	add    %eax,%edx
  100aff:	8b 45 08             	mov    0x8(%ebp),%eax
  100b02:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b04:	eb 03                	jmp    100b09 <parse+0x85>
            buf ++;
  100b06:	ff 45 08             	incl   0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b09:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0c:	0f b6 00             	movzbl (%eax),%eax
  100b0f:	84 c0                	test   %al,%al
  100b11:	0f 84 7a ff ff ff    	je     100a91 <parse+0xd>
  100b17:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1a:	0f b6 00             	movzbl (%eax),%eax
  100b1d:	0f be c0             	movsbl %al,%eax
  100b20:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b24:	c7 04 24 74 5e 10 00 	movl   $0x105e74,(%esp)
  100b2b:	e8 3b 47 00 00       	call   10526b <strchr>
  100b30:	85 c0                	test   %eax,%eax
  100b32:	74 d2                	je     100b06 <parse+0x82>
            buf ++;
        }
    }
  100b34:	e9 58 ff ff ff       	jmp    100a91 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100b39:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b3d:	c9                   	leave  
  100b3e:	c3                   	ret    

00100b3f <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3f:	55                   	push   %ebp
  100b40:	89 e5                	mov    %esp,%ebp
  100b42:	53                   	push   %ebx
  100b43:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b46:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b49:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b50:	89 04 24             	mov    %eax,(%esp)
  100b53:	e8 2c ff ff ff       	call   100a84 <parse>
  100b58:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b5f:	75 0a                	jne    100b6b <runcmd+0x2c>
        return 0;
  100b61:	b8 00 00 00 00       	mov    $0x0,%eax
  100b66:	e9 83 00 00 00       	jmp    100bee <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b72:	eb 5a                	jmp    100bce <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b74:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b7a:	89 d0                	mov    %edx,%eax
  100b7c:	01 c0                	add    %eax,%eax
  100b7e:	01 d0                	add    %edx,%eax
  100b80:	c1 e0 02             	shl    $0x2,%eax
  100b83:	05 00 70 11 00       	add    $0x117000,%eax
  100b88:	8b 00                	mov    (%eax),%eax
  100b8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b8e:	89 04 24             	mov    %eax,(%esp)
  100b91:	e8 38 46 00 00       	call   1051ce <strcmp>
  100b96:	85 c0                	test   %eax,%eax
  100b98:	75 31                	jne    100bcb <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b9d:	89 d0                	mov    %edx,%eax
  100b9f:	01 c0                	add    %eax,%eax
  100ba1:	01 d0                	add    %edx,%eax
  100ba3:	c1 e0 02             	shl    $0x2,%eax
  100ba6:	05 08 70 11 00       	add    $0x117008,%eax
  100bab:	8b 10                	mov    (%eax),%edx
  100bad:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bb0:	83 c0 04             	add    $0x4,%eax
  100bb3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100bb6:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100bb9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100bbc:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc4:	89 1c 24             	mov    %ebx,(%esp)
  100bc7:	ff d2                	call   *%edx
  100bc9:	eb 23                	jmp    100bee <runcmd+0xaf>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bcb:	ff 45 f4             	incl   -0xc(%ebp)
  100bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bd1:	83 f8 02             	cmp    $0x2,%eax
  100bd4:	76 9e                	jbe    100b74 <runcmd+0x35>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdd:	c7 04 24 97 5e 10 00 	movl   $0x105e97,(%esp)
  100be4:	e8 a4 f6 ff ff       	call   10028d <cprintf>
    return 0;
  100be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bee:	83 c4 64             	add    $0x64,%esp
  100bf1:	5b                   	pop    %ebx
  100bf2:	5d                   	pop    %ebp
  100bf3:	c3                   	ret    

00100bf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bf4:	55                   	push   %ebp
  100bf5:	89 e5                	mov    %esp,%ebp
  100bf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bfa:	c7 04 24 b0 5e 10 00 	movl   $0x105eb0,(%esp)
  100c01:	e8 87 f6 ff ff       	call   10028d <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c06:	c7 04 24 d8 5e 10 00 	movl   $0x105ed8,(%esp)
  100c0d:	e8 7b f6 ff ff       	call   10028d <cprintf>

    if (tf != NULL) {
  100c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c16:	74 0b                	je     100c23 <kmonitor+0x2f>
        print_trapframe(tf);
  100c18:	8b 45 08             	mov    0x8(%ebp),%eax
  100c1b:	89 04 24             	mov    %eax,(%esp)
  100c1e:	e8 f9 0c 00 00       	call   10191c <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c23:	c7 04 24 fd 5e 10 00 	movl   $0x105efd,(%esp)
  100c2a:	e8 00 f7 ff ff       	call   10032f <readline>
  100c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c36:	74 eb                	je     100c23 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c38:	8b 45 08             	mov    0x8(%ebp),%eax
  100c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c42:	89 04 24             	mov    %eax,(%esp)
  100c45:	e8 f5 fe ff ff       	call   100b3f <runcmd>
  100c4a:	85 c0                	test   %eax,%eax
  100c4c:	78 02                	js     100c50 <kmonitor+0x5c>
                break;
            }
        }
    }
  100c4e:	eb d3                	jmp    100c23 <kmonitor+0x2f>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100c50:	90                   	nop
            }
        }
    }
}
  100c51:	90                   	nop
  100c52:	c9                   	leave  
  100c53:	c3                   	ret    

00100c54 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c54:	55                   	push   %ebp
  100c55:	89 e5                	mov    %esp,%ebp
  100c57:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c61:	eb 3d                	jmp    100ca0 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c66:	89 d0                	mov    %edx,%eax
  100c68:	01 c0                	add    %eax,%eax
  100c6a:	01 d0                	add    %edx,%eax
  100c6c:	c1 e0 02             	shl    $0x2,%eax
  100c6f:	05 04 70 11 00       	add    $0x117004,%eax
  100c74:	8b 08                	mov    (%eax),%ecx
  100c76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c79:	89 d0                	mov    %edx,%eax
  100c7b:	01 c0                	add    %eax,%eax
  100c7d:	01 d0                	add    %edx,%eax
  100c7f:	c1 e0 02             	shl    $0x2,%eax
  100c82:	05 00 70 11 00       	add    $0x117000,%eax
  100c87:	8b 00                	mov    (%eax),%eax
  100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c91:	c7 04 24 01 5f 10 00 	movl   $0x105f01,(%esp)
  100c98:	e8 f0 f5 ff ff       	call   10028d <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c9d:	ff 45 f4             	incl   -0xc(%ebp)
  100ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca3:	83 f8 02             	cmp    $0x2,%eax
  100ca6:	76 bb                	jbe    100c63 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cad:	c9                   	leave  
  100cae:	c3                   	ret    

00100caf <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100caf:	55                   	push   %ebp
  100cb0:	89 e5                	mov    %esp,%ebp
  100cb2:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cb5:	e8 79 fc ff ff       	call   100933 <print_kerninfo>
    return 0;
  100cba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbf:	c9                   	leave  
  100cc0:	c3                   	ret    

00100cc1 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cc1:	55                   	push   %ebp
  100cc2:	89 e5                	mov    %esp,%ebp
  100cc4:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc7:	e8 b2 fd ff ff       	call   100a7e <print_stackframe>
    return 0;
  100ccc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cd1:	c9                   	leave  
  100cd2:	c3                   	ret    

00100cd3 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100cd3:	55                   	push   %ebp
  100cd4:	89 e5                	mov    %esp,%ebp
  100cd6:	83 ec 28             	sub    $0x28,%esp
  100cd9:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100cdf:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ce3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100ce7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ceb:	ee                   	out    %al,(%dx)
  100cec:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100cf2:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100cf6:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cfd:	ee                   	out    %al,(%dx)
  100cfe:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d04:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100d08:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d0c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d10:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d11:	c7 05 0c af 11 00 00 	movl   $0x0,0x11af0c
  100d18:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d1b:	c7 04 24 0a 5f 10 00 	movl   $0x105f0a,(%esp)
  100d22:	e8 66 f5 ff ff       	call   10028d <cprintf>
    pic_enable(IRQ_TIMER);
  100d27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d2e:	e8 1e 09 00 00       	call   101651 <pic_enable>
}
  100d33:	90                   	nop
  100d34:	c9                   	leave  
  100d35:	c3                   	ret    

00100d36 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100d36:	55                   	push   %ebp
  100d37:	89 e5                	mov    %esp,%ebp
  100d39:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100d3c:	9c                   	pushf  
  100d3d:	58                   	pop    %eax
  100d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100d44:	25 00 02 00 00       	and    $0x200,%eax
  100d49:	85 c0                	test   %eax,%eax
  100d4b:	74 0c                	je     100d59 <__intr_save+0x23>
        intr_disable();
  100d4d:	e8 6c 0a 00 00       	call   1017be <intr_disable>
        return 1;
  100d52:	b8 01 00 00 00       	mov    $0x1,%eax
  100d57:	eb 05                	jmp    100d5e <__intr_save+0x28>
    }
    return 0;
  100d59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d5e:	c9                   	leave  
  100d5f:	c3                   	ret    

00100d60 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100d60:	55                   	push   %ebp
  100d61:	89 e5                	mov    %esp,%ebp
  100d63:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100d66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d6a:	74 05                	je     100d71 <__intr_restore+0x11>
        intr_enable();
  100d6c:	e8 46 0a 00 00       	call   1017b7 <intr_enable>
    }
}
  100d71:	90                   	nop
  100d72:	c9                   	leave  
  100d73:	c3                   	ret    

00100d74 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d74:	55                   	push   %ebp
  100d75:	89 e5                	mov    %esp,%ebp
  100d77:	83 ec 10             	sub    $0x10,%esp
  100d7a:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100d80:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100d84:	89 c2                	mov    %eax,%edx
  100d86:	ec                   	in     (%dx),%al
  100d87:	88 45 f4             	mov    %al,-0xc(%ebp)
  100d8a:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100d90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100d93:	89 c2                	mov    %eax,%edx
  100d95:	ec                   	in     (%dx),%al
  100d96:	88 45 f5             	mov    %al,-0xb(%ebp)
  100d99:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100d9f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100da3:	89 c2                	mov    %eax,%edx
  100da5:	ec                   	in     (%dx),%al
  100da6:	88 45 f6             	mov    %al,-0xa(%ebp)
  100da9:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100daf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100db2:	89 c2                	mov    %eax,%edx
  100db4:	ec                   	in     (%dx),%al
  100db5:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100db8:	90                   	nop
  100db9:	c9                   	leave  
  100dba:	c3                   	ret    

00100dbb <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100dbb:	55                   	push   %ebp
  100dbc:	89 e5                	mov    %esp,%ebp
  100dbe:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100dc1:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dcb:	0f b7 00             	movzwl (%eax),%eax
  100dce:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100dd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dd5:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ddd:	0f b7 00             	movzwl (%eax),%eax
  100de0:	0f b7 c0             	movzwl %ax,%eax
  100de3:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100de8:	74 12                	je     100dfc <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100dea:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100df1:	66 c7 05 46 a4 11 00 	movw   $0x3b4,0x11a446
  100df8:	b4 03 
  100dfa:	eb 13                	jmp    100e0f <cga_init+0x54>
    } else {
        *cp = was;
  100dfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dff:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e03:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e06:	66 c7 05 46 a4 11 00 	movw   $0x3d4,0x11a446
  100e0d:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e0f:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100e16:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100e1a:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e1e:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100e22:	8b 55 f8             	mov    -0x8(%ebp),%edx
  100e25:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e26:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100e2d:	40                   	inc    %eax
  100e2e:	0f b7 c0             	movzwl %ax,%eax
  100e31:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e35:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e39:	89 c2                	mov    %eax,%edx
  100e3b:	ec                   	in     (%dx),%al
  100e3c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100e3f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100e43:	0f b6 c0             	movzbl %al,%eax
  100e46:	c1 e0 08             	shl    $0x8,%eax
  100e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e4c:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100e53:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100e57:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e5b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100e5f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100e62:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100e63:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100e6a:	40                   	inc    %eax
  100e6b:	0f b7 c0             	movzwl %ax,%eax
  100e6e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e72:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e76:	89 c2                	mov    %eax,%edx
  100e78:	ec                   	in     (%dx),%al
  100e79:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e7c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e80:	0f b6 c0             	movzbl %al,%eax
  100e83:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e89:	a3 40 a4 11 00       	mov    %eax,0x11a440
    crt_pos = pos;
  100e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e91:	0f b7 c0             	movzwl %ax,%eax
  100e94:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
}
  100e9a:	90                   	nop
  100e9b:	c9                   	leave  
  100e9c:	c3                   	ret    

00100e9d <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100e9d:	55                   	push   %ebp
  100e9e:	89 e5                	mov    %esp,%ebp
  100ea0:	83 ec 38             	sub    $0x38,%esp
  100ea3:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ea9:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ead:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100eb1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100eb5:	ee                   	out    %al,(%dx)
  100eb6:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100ebc:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100ec0:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100ec4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ec7:	ee                   	out    %al,(%dx)
  100ec8:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100ece:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100ed2:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100ed6:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100eda:	ee                   	out    %al,(%dx)
  100edb:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100ee1:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100ee5:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100ee9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100eec:	ee                   	out    %al,(%dx)
  100eed:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100ef3:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100ef7:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100efb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100eff:	ee                   	out    %al,(%dx)
  100f00:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100f06:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100f0a:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100f0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100f11:	ee                   	out    %al,(%dx)
  100f12:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f18:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100f1c:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100f20:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f24:	ee                   	out    %al,(%dx)
  100f25:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100f2e:	89 c2                	mov    %eax,%edx
  100f30:	ec                   	in     (%dx),%al
  100f31:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100f34:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f38:	3c ff                	cmp    $0xff,%al
  100f3a:	0f 95 c0             	setne  %al
  100f3d:	0f b6 c0             	movzbl %al,%eax
  100f40:	a3 48 a4 11 00       	mov    %eax,0x11a448
  100f45:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f4b:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f4f:	89 c2                	mov    %eax,%edx
  100f51:	ec                   	in     (%dx),%al
  100f52:	88 45 e2             	mov    %al,-0x1e(%ebp)
  100f55:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  100f5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100f5e:	89 c2                	mov    %eax,%edx
  100f60:	ec                   	in     (%dx),%al
  100f61:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f64:	a1 48 a4 11 00       	mov    0x11a448,%eax
  100f69:	85 c0                	test   %eax,%eax
  100f6b:	74 0c                	je     100f79 <serial_init+0xdc>
        pic_enable(IRQ_COM1);
  100f6d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100f74:	e8 d8 06 00 00       	call   101651 <pic_enable>
    }
}
  100f79:	90                   	nop
  100f7a:	c9                   	leave  
  100f7b:	c3                   	ret    

00100f7c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100f7c:	55                   	push   %ebp
  100f7d:	89 e5                	mov    %esp,%ebp
  100f7f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f82:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100f89:	eb 08                	jmp    100f93 <lpt_putc_sub+0x17>
        delay();
  100f8b:	e8 e4 fd ff ff       	call   100d74 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f90:	ff 45 fc             	incl   -0x4(%ebp)
  100f93:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  100f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f9c:	89 c2                	mov    %eax,%edx
  100f9e:	ec                   	in     (%dx),%al
  100f9f:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  100fa2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  100fa6:	84 c0                	test   %al,%al
  100fa8:	78 09                	js     100fb3 <lpt_putc_sub+0x37>
  100faa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fb1:	7e d8                	jle    100f8b <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  100fb6:	0f b6 c0             	movzbl %al,%eax
  100fb9:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  100fbf:	88 45 f0             	mov    %al,-0x10(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fc2:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100fc6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  100fc9:	ee                   	out    %al,(%dx)
  100fca:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  100fd0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100fd4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fd8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100fdc:	ee                   	out    %al,(%dx)
  100fdd:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  100fe3:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  100fe7:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  100feb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100fef:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  100ff0:	90                   	nop
  100ff1:	c9                   	leave  
  100ff2:	c3                   	ret    

00100ff3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100ff3:	55                   	push   %ebp
  100ff4:	89 e5                	mov    %esp,%ebp
  100ff6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  100ff9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  100ffd:	74 0d                	je     10100c <lpt_putc+0x19>
        lpt_putc_sub(c);
  100fff:	8b 45 08             	mov    0x8(%ebp),%eax
  101002:	89 04 24             	mov    %eax,(%esp)
  101005:	e8 72 ff ff ff       	call   100f7c <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10100a:	eb 24                	jmp    101030 <lpt_putc+0x3d>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  10100c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101013:	e8 64 ff ff ff       	call   100f7c <lpt_putc_sub>
        lpt_putc_sub(' ');
  101018:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10101f:	e8 58 ff ff ff       	call   100f7c <lpt_putc_sub>
        lpt_putc_sub('\b');
  101024:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10102b:	e8 4c ff ff ff       	call   100f7c <lpt_putc_sub>
    }
}
  101030:	90                   	nop
  101031:	c9                   	leave  
  101032:	c3                   	ret    

00101033 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101033:	55                   	push   %ebp
  101034:	89 e5                	mov    %esp,%ebp
  101036:	53                   	push   %ebx
  101037:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10103a:	8b 45 08             	mov    0x8(%ebp),%eax
  10103d:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101042:	85 c0                	test   %eax,%eax
  101044:	75 07                	jne    10104d <cga_putc+0x1a>
        c |= 0x0700;
  101046:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10104d:	8b 45 08             	mov    0x8(%ebp),%eax
  101050:	0f b6 c0             	movzbl %al,%eax
  101053:	83 f8 0a             	cmp    $0xa,%eax
  101056:	74 54                	je     1010ac <cga_putc+0x79>
  101058:	83 f8 0d             	cmp    $0xd,%eax
  10105b:	74 62                	je     1010bf <cga_putc+0x8c>
  10105d:	83 f8 08             	cmp    $0x8,%eax
  101060:	0f 85 93 00 00 00    	jne    1010f9 <cga_putc+0xc6>
    case '\b':
        if (crt_pos > 0) {
  101066:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10106d:	85 c0                	test   %eax,%eax
  10106f:	0f 84 ae 00 00 00    	je     101123 <cga_putc+0xf0>
            crt_pos --;
  101075:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10107c:	48                   	dec    %eax
  10107d:	0f b7 c0             	movzwl %ax,%eax
  101080:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101086:	a1 40 a4 11 00       	mov    0x11a440,%eax
  10108b:	0f b7 15 44 a4 11 00 	movzwl 0x11a444,%edx
  101092:	01 d2                	add    %edx,%edx
  101094:	01 c2                	add    %eax,%edx
  101096:	8b 45 08             	mov    0x8(%ebp),%eax
  101099:	98                   	cwtl   
  10109a:	25 00 ff ff ff       	and    $0xffffff00,%eax
  10109f:	98                   	cwtl   
  1010a0:	83 c8 20             	or     $0x20,%eax
  1010a3:	98                   	cwtl   
  1010a4:	0f b7 c0             	movzwl %ax,%eax
  1010a7:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010aa:	eb 77                	jmp    101123 <cga_putc+0xf0>
    case '\n':
        crt_pos += CRT_COLS;
  1010ac:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1010b3:	83 c0 50             	add    $0x50,%eax
  1010b6:	0f b7 c0             	movzwl %ax,%eax
  1010b9:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010bf:	0f b7 1d 44 a4 11 00 	movzwl 0x11a444,%ebx
  1010c6:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  1010cd:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1010d2:	89 c8                	mov    %ecx,%eax
  1010d4:	f7 e2                	mul    %edx
  1010d6:	c1 ea 06             	shr    $0x6,%edx
  1010d9:	89 d0                	mov    %edx,%eax
  1010db:	c1 e0 02             	shl    $0x2,%eax
  1010de:	01 d0                	add    %edx,%eax
  1010e0:	c1 e0 04             	shl    $0x4,%eax
  1010e3:	29 c1                	sub    %eax,%ecx
  1010e5:	89 c8                	mov    %ecx,%eax
  1010e7:	0f b7 c0             	movzwl %ax,%eax
  1010ea:	29 c3                	sub    %eax,%ebx
  1010ec:	89 d8                	mov    %ebx,%eax
  1010ee:	0f b7 c0             	movzwl %ax,%eax
  1010f1:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
        break;
  1010f7:	eb 2b                	jmp    101124 <cga_putc+0xf1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1010f9:	8b 0d 40 a4 11 00    	mov    0x11a440,%ecx
  1010ff:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101106:	8d 50 01             	lea    0x1(%eax),%edx
  101109:	0f b7 d2             	movzwl %dx,%edx
  10110c:	66 89 15 44 a4 11 00 	mov    %dx,0x11a444
  101113:	01 c0                	add    %eax,%eax
  101115:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101118:	8b 45 08             	mov    0x8(%ebp),%eax
  10111b:	0f b7 c0             	movzwl %ax,%eax
  10111e:	66 89 02             	mov    %ax,(%edx)
        break;
  101121:	eb 01                	jmp    101124 <cga_putc+0xf1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  101123:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101124:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10112b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101130:	76 5d                	jbe    10118f <cga_putc+0x15c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101132:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101137:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10113d:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101142:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101149:	00 
  10114a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10114e:	89 04 24             	mov    %eax,(%esp)
  101151:	e8 0b 43 00 00       	call   105461 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101156:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10115d:	eb 14                	jmp    101173 <cga_putc+0x140>
            crt_buf[i] = 0x0700 | ' ';
  10115f:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101164:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101167:	01 d2                	add    %edx,%edx
  101169:	01 d0                	add    %edx,%eax
  10116b:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101170:	ff 45 f4             	incl   -0xc(%ebp)
  101173:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10117a:	7e e3                	jle    10115f <cga_putc+0x12c>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10117c:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101183:	83 e8 50             	sub    $0x50,%eax
  101186:	0f b7 c0             	movzwl %ax,%eax
  101189:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10118f:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  101196:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10119a:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  10119e:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  1011a2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011a6:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011a7:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011ae:	c1 e8 08             	shr    $0x8,%eax
  1011b1:	0f b7 c0             	movzwl %ax,%eax
  1011b4:	0f b6 c0             	movzbl %al,%eax
  1011b7:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  1011be:	42                   	inc    %edx
  1011bf:	0f b7 d2             	movzwl %dx,%edx
  1011c2:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  1011c6:	88 45 e9             	mov    %al,-0x17(%ebp)
  1011c9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1011d0:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011d1:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  1011d8:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1011dc:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  1011e0:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  1011e4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1011e8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1011e9:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011f0:	0f b6 c0             	movzbl %al,%eax
  1011f3:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  1011fa:	42                   	inc    %edx
  1011fb:	0f b7 d2             	movzwl %dx,%edx
  1011fe:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  101202:	88 45 eb             	mov    %al,-0x15(%ebp)
  101205:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  101209:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10120c:	ee                   	out    %al,(%dx)
}
  10120d:	90                   	nop
  10120e:	83 c4 24             	add    $0x24,%esp
  101211:	5b                   	pop    %ebx
  101212:	5d                   	pop    %ebp
  101213:	c3                   	ret    

00101214 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101214:	55                   	push   %ebp
  101215:	89 e5                	mov    %esp,%ebp
  101217:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10121a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101221:	eb 08                	jmp    10122b <serial_putc_sub+0x17>
        delay();
  101223:	e8 4c fb ff ff       	call   100d74 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101228:	ff 45 fc             	incl   -0x4(%ebp)
  10122b:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101231:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101234:	89 c2                	mov    %eax,%edx
  101236:	ec                   	in     (%dx),%al
  101237:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10123a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10123e:	0f b6 c0             	movzbl %al,%eax
  101241:	83 e0 20             	and    $0x20,%eax
  101244:	85 c0                	test   %eax,%eax
  101246:	75 09                	jne    101251 <serial_putc_sub+0x3d>
  101248:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10124f:	7e d2                	jle    101223 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101251:	8b 45 08             	mov    0x8(%ebp),%eax
  101254:	0f b6 c0             	movzbl %al,%eax
  101257:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  10125d:	88 45 f6             	mov    %al,-0xa(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101260:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  101264:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101268:	ee                   	out    %al,(%dx)
}
  101269:	90                   	nop
  10126a:	c9                   	leave  
  10126b:	c3                   	ret    

0010126c <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10126c:	55                   	push   %ebp
  10126d:	89 e5                	mov    %esp,%ebp
  10126f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101272:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101276:	74 0d                	je     101285 <serial_putc+0x19>
        serial_putc_sub(c);
  101278:	8b 45 08             	mov    0x8(%ebp),%eax
  10127b:	89 04 24             	mov    %eax,(%esp)
  10127e:	e8 91 ff ff ff       	call   101214 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101283:	eb 24                	jmp    1012a9 <serial_putc+0x3d>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  101285:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10128c:	e8 83 ff ff ff       	call   101214 <serial_putc_sub>
        serial_putc_sub(' ');
  101291:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101298:	e8 77 ff ff ff       	call   101214 <serial_putc_sub>
        serial_putc_sub('\b');
  10129d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012a4:	e8 6b ff ff ff       	call   101214 <serial_putc_sub>
    }
}
  1012a9:	90                   	nop
  1012aa:	c9                   	leave  
  1012ab:	c3                   	ret    

001012ac <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012ac:	55                   	push   %ebp
  1012ad:	89 e5                	mov    %esp,%ebp
  1012af:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012b2:	eb 33                	jmp    1012e7 <cons_intr+0x3b>
        if (c != 0) {
  1012b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012b8:	74 2d                	je     1012e7 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012ba:	a1 64 a6 11 00       	mov    0x11a664,%eax
  1012bf:	8d 50 01             	lea    0x1(%eax),%edx
  1012c2:	89 15 64 a6 11 00    	mov    %edx,0x11a664
  1012c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012cb:	88 90 60 a4 11 00    	mov    %dl,0x11a460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012d1:	a1 64 a6 11 00       	mov    0x11a664,%eax
  1012d6:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012db:	75 0a                	jne    1012e7 <cons_intr+0x3b>
                cons.wpos = 0;
  1012dd:	c7 05 64 a6 11 00 00 	movl   $0x0,0x11a664
  1012e4:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ea:	ff d0                	call   *%eax
  1012ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1012ef:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1012f3:	75 bf                	jne    1012b4 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1012f5:	90                   	nop
  1012f6:	c9                   	leave  
  1012f7:	c3                   	ret    

001012f8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1012f8:	55                   	push   %ebp
  1012f9:	89 e5                	mov    %esp,%ebp
  1012fb:	83 ec 10             	sub    $0x10,%esp
  1012fe:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101304:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101307:	89 c2                	mov    %eax,%edx
  101309:	ec                   	in     (%dx),%al
  10130a:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  10130d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101311:	0f b6 c0             	movzbl %al,%eax
  101314:	83 e0 01             	and    $0x1,%eax
  101317:	85 c0                	test   %eax,%eax
  101319:	75 07                	jne    101322 <serial_proc_data+0x2a>
        return -1;
  10131b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101320:	eb 2a                	jmp    10134c <serial_proc_data+0x54>
  101322:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101328:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10132c:	89 c2                	mov    %eax,%edx
  10132e:	ec                   	in     (%dx),%al
  10132f:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  101332:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101336:	0f b6 c0             	movzbl %al,%eax
  101339:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10133c:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101340:	75 07                	jne    101349 <serial_proc_data+0x51>
        c = '\b';
  101342:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101349:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10134c:	c9                   	leave  
  10134d:	c3                   	ret    

0010134e <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10134e:	55                   	push   %ebp
  10134f:	89 e5                	mov    %esp,%ebp
  101351:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101354:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101359:	85 c0                	test   %eax,%eax
  10135b:	74 0c                	je     101369 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10135d:	c7 04 24 f8 12 10 00 	movl   $0x1012f8,(%esp)
  101364:	e8 43 ff ff ff       	call   1012ac <cons_intr>
    }
}
  101369:	90                   	nop
  10136a:	c9                   	leave  
  10136b:	c3                   	ret    

0010136c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10136c:	55                   	push   %ebp
  10136d:	89 e5                	mov    %esp,%ebp
  10136f:	83 ec 28             	sub    $0x28,%esp
  101372:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10137b:	89 c2                	mov    %eax,%edx
  10137d:	ec                   	in     (%dx),%al
  10137e:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101381:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101385:	0f b6 c0             	movzbl %al,%eax
  101388:	83 e0 01             	and    $0x1,%eax
  10138b:	85 c0                	test   %eax,%eax
  10138d:	75 0a                	jne    101399 <kbd_proc_data+0x2d>
        return -1;
  10138f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101394:	e9 56 01 00 00       	jmp    1014ef <kbd_proc_data+0x183>
  101399:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10139f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1013a2:	89 c2                	mov    %eax,%edx
  1013a4:	ec                   	in     (%dx),%al
  1013a5:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  1013a8:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013ac:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013af:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013b3:	75 17                	jne    1013cc <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  1013b5:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1013ba:	83 c8 40             	or     $0x40,%eax
  1013bd:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1013c2:	b8 00 00 00 00       	mov    $0x0,%eax
  1013c7:	e9 23 01 00 00       	jmp    1014ef <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  1013cc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013d0:	84 c0                	test   %al,%al
  1013d2:	79 45                	jns    101419 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013d4:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1013d9:	83 e0 40             	and    $0x40,%eax
  1013dc:	85 c0                	test   %eax,%eax
  1013de:	75 08                	jne    1013e8 <kbd_proc_data+0x7c>
  1013e0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013e4:	24 7f                	and    $0x7f,%al
  1013e6:	eb 04                	jmp    1013ec <kbd_proc_data+0x80>
  1013e8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013ec:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1013ef:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013f3:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  1013fa:	0c 40                	or     $0x40,%al
  1013fc:	0f b6 c0             	movzbl %al,%eax
  1013ff:	f7 d0                	not    %eax
  101401:	89 c2                	mov    %eax,%edx
  101403:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101408:	21 d0                	and    %edx,%eax
  10140a:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  10140f:	b8 00 00 00 00       	mov    $0x0,%eax
  101414:	e9 d6 00 00 00       	jmp    1014ef <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  101419:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10141e:	83 e0 40             	and    $0x40,%eax
  101421:	85 c0                	test   %eax,%eax
  101423:	74 11                	je     101436 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101425:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101429:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10142e:	83 e0 bf             	and    $0xffffffbf,%eax
  101431:	a3 68 a6 11 00       	mov    %eax,0x11a668
    }

    shift |= shiftcode[data];
  101436:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143a:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  101441:	0f b6 d0             	movzbl %al,%edx
  101444:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101449:	09 d0                	or     %edx,%eax
  10144b:	a3 68 a6 11 00       	mov    %eax,0x11a668
    shift ^= togglecode[data];
  101450:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101454:	0f b6 80 40 71 11 00 	movzbl 0x117140(%eax),%eax
  10145b:	0f b6 d0             	movzbl %al,%edx
  10145e:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101463:	31 d0                	xor    %edx,%eax
  101465:	a3 68 a6 11 00       	mov    %eax,0x11a668

    c = charcode[shift & (CTL | SHIFT)][data];
  10146a:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10146f:	83 e0 03             	and    $0x3,%eax
  101472:	8b 14 85 40 75 11 00 	mov    0x117540(,%eax,4),%edx
  101479:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147d:	01 d0                	add    %edx,%eax
  10147f:	0f b6 00             	movzbl (%eax),%eax
  101482:	0f b6 c0             	movzbl %al,%eax
  101485:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101488:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10148d:	83 e0 08             	and    $0x8,%eax
  101490:	85 c0                	test   %eax,%eax
  101492:	74 22                	je     1014b6 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101494:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101498:	7e 0c                	jle    1014a6 <kbd_proc_data+0x13a>
  10149a:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10149e:	7f 06                	jg     1014a6 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  1014a0:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014a4:	eb 10                	jmp    1014b6 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  1014a6:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014aa:	7e 0a                	jle    1014b6 <kbd_proc_data+0x14a>
  1014ac:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014b0:	7f 04                	jg     1014b6 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  1014b2:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014b6:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014bb:	f7 d0                	not    %eax
  1014bd:	83 e0 06             	and    $0x6,%eax
  1014c0:	85 c0                	test   %eax,%eax
  1014c2:	75 28                	jne    1014ec <kbd_proc_data+0x180>
  1014c4:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014cb:	75 1f                	jne    1014ec <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  1014cd:	c7 04 24 25 5f 10 00 	movl   $0x105f25,(%esp)
  1014d4:	e8 b4 ed ff ff       	call   10028d <cprintf>
  1014d9:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  1014df:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1014e3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1014e7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1014eb:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1014ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1014ef:	c9                   	leave  
  1014f0:	c3                   	ret    

001014f1 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1014f1:	55                   	push   %ebp
  1014f2:	89 e5                	mov    %esp,%ebp
  1014f4:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1014f7:	c7 04 24 6c 13 10 00 	movl   $0x10136c,(%esp)
  1014fe:	e8 a9 fd ff ff       	call   1012ac <cons_intr>
}
  101503:	90                   	nop
  101504:	c9                   	leave  
  101505:	c3                   	ret    

00101506 <kbd_init>:

static void
kbd_init(void) {
  101506:	55                   	push   %ebp
  101507:	89 e5                	mov    %esp,%ebp
  101509:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10150c:	e8 e0 ff ff ff       	call   1014f1 <kbd_intr>
    pic_enable(IRQ_KBD);
  101511:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101518:	e8 34 01 00 00       	call   101651 <pic_enable>
}
  10151d:	90                   	nop
  10151e:	c9                   	leave  
  10151f:	c3                   	ret    

00101520 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101520:	55                   	push   %ebp
  101521:	89 e5                	mov    %esp,%ebp
  101523:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101526:	e8 90 f8 ff ff       	call   100dbb <cga_init>
    serial_init();
  10152b:	e8 6d f9 ff ff       	call   100e9d <serial_init>
    kbd_init();
  101530:	e8 d1 ff ff ff       	call   101506 <kbd_init>
    if (!serial_exists) {
  101535:	a1 48 a4 11 00       	mov    0x11a448,%eax
  10153a:	85 c0                	test   %eax,%eax
  10153c:	75 0c                	jne    10154a <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10153e:	c7 04 24 31 5f 10 00 	movl   $0x105f31,(%esp)
  101545:	e8 43 ed ff ff       	call   10028d <cprintf>
    }
}
  10154a:	90                   	nop
  10154b:	c9                   	leave  
  10154c:	c3                   	ret    

0010154d <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10154d:	55                   	push   %ebp
  10154e:	89 e5                	mov    %esp,%ebp
  101550:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101553:	e8 de f7 ff ff       	call   100d36 <__intr_save>
  101558:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10155b:	8b 45 08             	mov    0x8(%ebp),%eax
  10155e:	89 04 24             	mov    %eax,(%esp)
  101561:	e8 8d fa ff ff       	call   100ff3 <lpt_putc>
        cga_putc(c);
  101566:	8b 45 08             	mov    0x8(%ebp),%eax
  101569:	89 04 24             	mov    %eax,(%esp)
  10156c:	e8 c2 fa ff ff       	call   101033 <cga_putc>
        serial_putc(c);
  101571:	8b 45 08             	mov    0x8(%ebp),%eax
  101574:	89 04 24             	mov    %eax,(%esp)
  101577:	e8 f0 fc ff ff       	call   10126c <serial_putc>
    }
    local_intr_restore(intr_flag);
  10157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10157f:	89 04 24             	mov    %eax,(%esp)
  101582:	e8 d9 f7 ff ff       	call   100d60 <__intr_restore>
}
  101587:	90                   	nop
  101588:	c9                   	leave  
  101589:	c3                   	ret    

0010158a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10158a:	55                   	push   %ebp
  10158b:	89 e5                	mov    %esp,%ebp
  10158d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101590:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101597:	e8 9a f7 ff ff       	call   100d36 <__intr_save>
  10159c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10159f:	e8 aa fd ff ff       	call   10134e <serial_intr>
        kbd_intr();
  1015a4:	e8 48 ff ff ff       	call   1014f1 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  1015a9:	8b 15 60 a6 11 00    	mov    0x11a660,%edx
  1015af:	a1 64 a6 11 00       	mov    0x11a664,%eax
  1015b4:	39 c2                	cmp    %eax,%edx
  1015b6:	74 31                	je     1015e9 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  1015b8:	a1 60 a6 11 00       	mov    0x11a660,%eax
  1015bd:	8d 50 01             	lea    0x1(%eax),%edx
  1015c0:	89 15 60 a6 11 00    	mov    %edx,0x11a660
  1015c6:	0f b6 80 60 a4 11 00 	movzbl 0x11a460(%eax),%eax
  1015cd:	0f b6 c0             	movzbl %al,%eax
  1015d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1015d3:	a1 60 a6 11 00       	mov    0x11a660,%eax
  1015d8:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015dd:	75 0a                	jne    1015e9 <cons_getc+0x5f>
                cons.rpos = 0;
  1015df:	c7 05 60 a6 11 00 00 	movl   $0x0,0x11a660
  1015e6:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1015ec:	89 04 24             	mov    %eax,(%esp)
  1015ef:	e8 6c f7 ff ff       	call   100d60 <__intr_restore>
    return c;
  1015f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015f7:	c9                   	leave  
  1015f8:	c3                   	ret    

001015f9 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1015f9:	55                   	push   %ebp
  1015fa:	89 e5                	mov    %esp,%ebp
  1015fc:	83 ec 14             	sub    $0x14,%esp
  1015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  101602:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101606:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101609:	66 a3 50 75 11 00    	mov    %ax,0x117550
    if (did_init) {
  10160f:	a1 6c a6 11 00       	mov    0x11a66c,%eax
  101614:	85 c0                	test   %eax,%eax
  101616:	74 36                	je     10164e <pic_setmask+0x55>
        outb(IO_PIC1 + 1, mask);
  101618:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10161b:	0f b6 c0             	movzbl %al,%eax
  10161e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101624:	88 45 fa             	mov    %al,-0x6(%ebp)
  101627:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  10162b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10162f:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101630:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101634:	c1 e8 08             	shr    $0x8,%eax
  101637:	0f b7 c0             	movzwl %ax,%eax
  10163a:	0f b6 c0             	movzbl %al,%eax
  10163d:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101643:	88 45 fb             	mov    %al,-0x5(%ebp)
  101646:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  10164a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10164d:	ee                   	out    %al,(%dx)
    }
}
  10164e:	90                   	nop
  10164f:	c9                   	leave  
  101650:	c3                   	ret    

00101651 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101651:	55                   	push   %ebp
  101652:	89 e5                	mov    %esp,%ebp
  101654:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101657:	8b 45 08             	mov    0x8(%ebp),%eax
  10165a:	ba 01 00 00 00       	mov    $0x1,%edx
  10165f:	88 c1                	mov    %al,%cl
  101661:	d3 e2                	shl    %cl,%edx
  101663:	89 d0                	mov    %edx,%eax
  101665:	98                   	cwtl   
  101666:	f7 d0                	not    %eax
  101668:	0f bf d0             	movswl %ax,%edx
  10166b:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101672:	98                   	cwtl   
  101673:	21 d0                	and    %edx,%eax
  101675:	98                   	cwtl   
  101676:	0f b7 c0             	movzwl %ax,%eax
  101679:	89 04 24             	mov    %eax,(%esp)
  10167c:	e8 78 ff ff ff       	call   1015f9 <pic_setmask>
}
  101681:	90                   	nop
  101682:	c9                   	leave  
  101683:	c3                   	ret    

00101684 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101684:	55                   	push   %ebp
  101685:	89 e5                	mov    %esp,%ebp
  101687:	83 ec 34             	sub    $0x34,%esp
    did_init = 1;
  10168a:	c7 05 6c a6 11 00 01 	movl   $0x1,0x11a66c
  101691:	00 00 00 
  101694:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10169a:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  10169e:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  1016a2:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016a6:	ee                   	out    %al,(%dx)
  1016a7:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016ad:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  1016b1:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  1016b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1016b8:	ee                   	out    %al,(%dx)
  1016b9:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  1016bf:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  1016c3:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  1016c7:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016cb:	ee                   	out    %al,(%dx)
  1016cc:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  1016d2:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  1016d6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1016da:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1016dd:	ee                   	out    %al,(%dx)
  1016de:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  1016e4:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  1016e8:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  1016ec:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016f0:	ee                   	out    %al,(%dx)
  1016f1:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  1016f7:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  1016fb:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  1016ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101702:	ee                   	out    %al,(%dx)
  101703:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  101709:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  10170d:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  101711:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101715:	ee                   	out    %al,(%dx)
  101716:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  10171c:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  101720:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101724:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101727:	ee                   	out    %al,(%dx)
  101728:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  10172e:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  101732:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  101736:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10173a:	ee                   	out    %al,(%dx)
  10173b:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  101741:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  101745:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  101749:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10174c:	ee                   	out    %al,(%dx)
  10174d:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  101753:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  101757:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  10175b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10175f:	ee                   	out    %al,(%dx)
  101760:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  101766:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  10176a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10176e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101771:	ee                   	out    %al,(%dx)
  101772:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101778:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  10177c:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  101780:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101784:	ee                   	out    %al,(%dx)
  101785:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  10178b:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  10178f:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  101793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101796:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101797:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  10179e:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1017a3:	74 0f                	je     1017b4 <pic_init+0x130>
        pic_setmask(irq_mask);
  1017a5:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  1017ac:	89 04 24             	mov    %eax,(%esp)
  1017af:	e8 45 fe ff ff       	call   1015f9 <pic_setmask>
    }
}
  1017b4:	90                   	nop
  1017b5:	c9                   	leave  
  1017b6:	c3                   	ret    

001017b7 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017b7:	55                   	push   %ebp
  1017b8:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017ba:	fb                   	sti    
    sti();
}
  1017bb:	90                   	nop
  1017bc:	5d                   	pop    %ebp
  1017bd:	c3                   	ret    

001017be <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017be:	55                   	push   %ebp
  1017bf:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1017c1:	fa                   	cli    
    cli();
}
  1017c2:	90                   	nop
  1017c3:	5d                   	pop    %ebp
  1017c4:	c3                   	ret    

001017c5 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017c5:	55                   	push   %ebp
  1017c6:	89 e5                	mov    %esp,%ebp
  1017c8:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017cb:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017d2:	00 
  1017d3:	c7 04 24 60 5f 10 00 	movl   $0x105f60,(%esp)
  1017da:	e8 ae ea ff ff       	call   10028d <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017df:	90                   	nop
  1017e0:	c9                   	leave  
  1017e1:	c3                   	ret    

001017e2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017e2:	55                   	push   %ebp
  1017e3:	89 e5                	mov    %esp,%ebp
  1017e5:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
         extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1017e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1017ef:	e9 c4 00 00 00       	jmp    1018b8 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1017f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1017f7:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1017fe:	0f b7 d0             	movzwl %ax,%edx
  101801:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101804:	66 89 14 c5 80 a6 11 	mov    %dx,0x11a680(,%eax,8)
  10180b:	00 
  10180c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10180f:	66 c7 04 c5 82 a6 11 	movw   $0x8,0x11a682(,%eax,8)
  101816:	00 08 00 
  101819:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10181c:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101823:	00 
  101824:	80 e2 e0             	and    $0xe0,%dl
  101827:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  10182e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101831:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101838:	00 
  101839:	80 e2 1f             	and    $0x1f,%dl
  10183c:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101843:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101846:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10184d:	00 
  10184e:	80 e2 f0             	and    $0xf0,%dl
  101851:	80 ca 0e             	or     $0xe,%dl
  101854:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10185b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185e:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101865:	00 
  101866:	80 e2 ef             	and    $0xef,%dl
  101869:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101870:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101873:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10187a:	00 
  10187b:	80 e2 9f             	and    $0x9f,%dl
  10187e:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101885:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101888:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10188f:	00 
  101890:	80 ca 80             	or     $0x80,%dl
  101893:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10189a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189d:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1018a4:	c1 e8 10             	shr    $0x10,%eax
  1018a7:	0f b7 d0             	movzwl %ax,%edx
  1018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ad:	66 89 14 c5 86 a6 11 	mov    %dx,0x11a686(,%eax,8)
  1018b4:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
         extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018b5:	ff 45 fc             	incl   -0x4(%ebp)
  1018b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bb:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018c0:	0f 86 2e ff ff ff    	jbe    1017f4 <idt_init+0x12>
  1018c6:	c7 45 f8 60 75 11 00 	movl   $0x117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1018cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1018d0:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
  1018d3:	90                   	nop
  1018d4:	c9                   	leave  
  1018d5:	c3                   	ret    

001018d6 <trapname>:

static const char *
trapname(int trapno) {
  1018d6:	55                   	push   %ebp
  1018d7:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1018dc:	83 f8 13             	cmp    $0x13,%eax
  1018df:	77 0c                	ja     1018ed <trapname+0x17>
        return excnames[trapno];
  1018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1018e4:	8b 04 85 c0 62 10 00 	mov    0x1062c0(,%eax,4),%eax
  1018eb:	eb 18                	jmp    101905 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1018ed:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1018f1:	7e 0d                	jle    101900 <trapname+0x2a>
  1018f3:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1018f7:	7f 07                	jg     101900 <trapname+0x2a>
        return "Hardware Interrupt";
  1018f9:	b8 6a 5f 10 00       	mov    $0x105f6a,%eax
  1018fe:	eb 05                	jmp    101905 <trapname+0x2f>
    }
    return "(unknown trap)";
  101900:	b8 7d 5f 10 00       	mov    $0x105f7d,%eax
}
  101905:	5d                   	pop    %ebp
  101906:	c3                   	ret    

00101907 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101907:	55                   	push   %ebp
  101908:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  10190a:	8b 45 08             	mov    0x8(%ebp),%eax
  10190d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101911:	83 f8 08             	cmp    $0x8,%eax
  101914:	0f 94 c0             	sete   %al
  101917:	0f b6 c0             	movzbl %al,%eax
}
  10191a:	5d                   	pop    %ebp
  10191b:	c3                   	ret    

0010191c <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  10191c:	55                   	push   %ebp
  10191d:	89 e5                	mov    %esp,%ebp
  10191f:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101922:	8b 45 08             	mov    0x8(%ebp),%eax
  101925:	89 44 24 04          	mov    %eax,0x4(%esp)
  101929:	c7 04 24 be 5f 10 00 	movl   $0x105fbe,(%esp)
  101930:	e8 58 e9 ff ff       	call   10028d <cprintf>
    print_regs(&tf->tf_regs);
  101935:	8b 45 08             	mov    0x8(%ebp),%eax
  101938:	89 04 24             	mov    %eax,(%esp)
  10193b:	e8 91 01 00 00       	call   101ad1 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101940:	8b 45 08             	mov    0x8(%ebp),%eax
  101943:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101947:	89 44 24 04          	mov    %eax,0x4(%esp)
  10194b:	c7 04 24 cf 5f 10 00 	movl   $0x105fcf,(%esp)
  101952:	e8 36 e9 ff ff       	call   10028d <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101957:	8b 45 08             	mov    0x8(%ebp),%eax
  10195a:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  10195e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101962:	c7 04 24 e2 5f 10 00 	movl   $0x105fe2,(%esp)
  101969:	e8 1f e9 ff ff       	call   10028d <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  10196e:	8b 45 08             	mov    0x8(%ebp),%eax
  101971:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101975:	89 44 24 04          	mov    %eax,0x4(%esp)
  101979:	c7 04 24 f5 5f 10 00 	movl   $0x105ff5,(%esp)
  101980:	e8 08 e9 ff ff       	call   10028d <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101985:	8b 45 08             	mov    0x8(%ebp),%eax
  101988:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  10198c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101990:	c7 04 24 08 60 10 00 	movl   $0x106008,(%esp)
  101997:	e8 f1 e8 ff ff       	call   10028d <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  10199c:	8b 45 08             	mov    0x8(%ebp),%eax
  10199f:	8b 40 30             	mov    0x30(%eax),%eax
  1019a2:	89 04 24             	mov    %eax,(%esp)
  1019a5:	e8 2c ff ff ff       	call   1018d6 <trapname>
  1019aa:	89 c2                	mov    %eax,%edx
  1019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1019af:	8b 40 30             	mov    0x30(%eax),%eax
  1019b2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1019b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019ba:	c7 04 24 1b 60 10 00 	movl   $0x10601b,(%esp)
  1019c1:	e8 c7 e8 ff ff       	call   10028d <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  1019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c9:	8b 40 34             	mov    0x34(%eax),%eax
  1019cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019d0:	c7 04 24 2d 60 10 00 	movl   $0x10602d,(%esp)
  1019d7:	e8 b1 e8 ff ff       	call   10028d <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  1019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019df:	8b 40 38             	mov    0x38(%eax),%eax
  1019e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019e6:	c7 04 24 3c 60 10 00 	movl   $0x10603c,(%esp)
  1019ed:	e8 9b e8 ff ff       	call   10028d <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  1019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019fd:	c7 04 24 4b 60 10 00 	movl   $0x10604b,(%esp)
  101a04:	e8 84 e8 ff ff       	call   10028d <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101a09:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0c:	8b 40 40             	mov    0x40(%eax),%eax
  101a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a13:	c7 04 24 5e 60 10 00 	movl   $0x10605e,(%esp)
  101a1a:	e8 6e e8 ff ff       	call   10028d <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101a26:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101a2d:	eb 3d                	jmp    101a6c <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a32:	8b 50 40             	mov    0x40(%eax),%edx
  101a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101a38:	21 d0                	and    %edx,%eax
  101a3a:	85 c0                	test   %eax,%eax
  101a3c:	74 28                	je     101a66 <print_trapframe+0x14a>
  101a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a41:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101a48:	85 c0                	test   %eax,%eax
  101a4a:	74 1a                	je     101a66 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a4f:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101a56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5a:	c7 04 24 6d 60 10 00 	movl   $0x10606d,(%esp)
  101a61:	e8 27 e8 ff ff       	call   10028d <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a66:	ff 45 f4             	incl   -0xc(%ebp)
  101a69:	d1 65 f0             	shll   -0x10(%ebp)
  101a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a6f:	83 f8 17             	cmp    $0x17,%eax
  101a72:	76 bb                	jbe    101a2f <print_trapframe+0x113>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101a74:	8b 45 08             	mov    0x8(%ebp),%eax
  101a77:	8b 40 40             	mov    0x40(%eax),%eax
  101a7a:	25 00 30 00 00       	and    $0x3000,%eax
  101a7f:	c1 e8 0c             	shr    $0xc,%eax
  101a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a86:	c7 04 24 71 60 10 00 	movl   $0x106071,(%esp)
  101a8d:	e8 fb e7 ff ff       	call   10028d <cprintf>

    if (!trap_in_kernel(tf)) {
  101a92:	8b 45 08             	mov    0x8(%ebp),%eax
  101a95:	89 04 24             	mov    %eax,(%esp)
  101a98:	e8 6a fe ff ff       	call   101907 <trap_in_kernel>
  101a9d:	85 c0                	test   %eax,%eax
  101a9f:	75 2d                	jne    101ace <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa4:	8b 40 44             	mov    0x44(%eax),%eax
  101aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aab:	c7 04 24 7a 60 10 00 	movl   $0x10607a,(%esp)
  101ab2:	e8 d6 e7 ff ff       	call   10028d <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aba:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac2:	c7 04 24 89 60 10 00 	movl   $0x106089,(%esp)
  101ac9:	e8 bf e7 ff ff       	call   10028d <cprintf>
    }
}
  101ace:	90                   	nop
  101acf:	c9                   	leave  
  101ad0:	c3                   	ret    

00101ad1 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101ad1:	55                   	push   %ebp
  101ad2:	89 e5                	mov    %esp,%ebp
  101ad4:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  101ada:	8b 00                	mov    (%eax),%eax
  101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae0:	c7 04 24 9c 60 10 00 	movl   $0x10609c,(%esp)
  101ae7:	e8 a1 e7 ff ff       	call   10028d <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101aec:	8b 45 08             	mov    0x8(%ebp),%eax
  101aef:	8b 40 04             	mov    0x4(%eax),%eax
  101af2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af6:	c7 04 24 ab 60 10 00 	movl   $0x1060ab,(%esp)
  101afd:	e8 8b e7 ff ff       	call   10028d <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101b02:	8b 45 08             	mov    0x8(%ebp),%eax
  101b05:	8b 40 08             	mov    0x8(%eax),%eax
  101b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0c:	c7 04 24 ba 60 10 00 	movl   $0x1060ba,(%esp)
  101b13:	e8 75 e7 ff ff       	call   10028d <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101b18:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1b:	8b 40 0c             	mov    0xc(%eax),%eax
  101b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b22:	c7 04 24 c9 60 10 00 	movl   $0x1060c9,(%esp)
  101b29:	e8 5f e7 ff ff       	call   10028d <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b31:	8b 40 10             	mov    0x10(%eax),%eax
  101b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b38:	c7 04 24 d8 60 10 00 	movl   $0x1060d8,(%esp)
  101b3f:	e8 49 e7 ff ff       	call   10028d <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101b44:	8b 45 08             	mov    0x8(%ebp),%eax
  101b47:	8b 40 14             	mov    0x14(%eax),%eax
  101b4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4e:	c7 04 24 e7 60 10 00 	movl   $0x1060e7,(%esp)
  101b55:	e8 33 e7 ff ff       	call   10028d <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5d:	8b 40 18             	mov    0x18(%eax),%eax
  101b60:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b64:	c7 04 24 f6 60 10 00 	movl   $0x1060f6,(%esp)
  101b6b:	e8 1d e7 ff ff       	call   10028d <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101b70:	8b 45 08             	mov    0x8(%ebp),%eax
  101b73:	8b 40 1c             	mov    0x1c(%eax),%eax
  101b76:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7a:	c7 04 24 05 61 10 00 	movl   $0x106105,(%esp)
  101b81:	e8 07 e7 ff ff       	call   10028d <cprintf>
}
  101b86:	90                   	nop
  101b87:	c9                   	leave  
  101b88:	c3                   	ret    

00101b89 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101b89:	55                   	push   %ebp
  101b8a:	89 e5                	mov    %esp,%ebp
  101b8c:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b92:	8b 40 30             	mov    0x30(%eax),%eax
  101b95:	83 f8 2f             	cmp    $0x2f,%eax
  101b98:	77 1e                	ja     101bb8 <trap_dispatch+0x2f>
  101b9a:	83 f8 2e             	cmp    $0x2e,%eax
  101b9d:	0f 83 bc 00 00 00    	jae    101c5f <trap_dispatch+0xd6>
  101ba3:	83 f8 21             	cmp    $0x21,%eax
  101ba6:	74 40                	je     101be8 <trap_dispatch+0x5f>
  101ba8:	83 f8 24             	cmp    $0x24,%eax
  101bab:	74 15                	je     101bc2 <trap_dispatch+0x39>
  101bad:	83 f8 20             	cmp    $0x20,%eax
  101bb0:	0f 84 ac 00 00 00    	je     101c62 <trap_dispatch+0xd9>
  101bb6:	eb 72                	jmp    101c2a <trap_dispatch+0xa1>
  101bb8:	83 e8 78             	sub    $0x78,%eax
  101bbb:	83 f8 01             	cmp    $0x1,%eax
  101bbe:	77 6a                	ja     101c2a <trap_dispatch+0xa1>
  101bc0:	eb 4c                	jmp    101c0e <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101bc2:	e8 c3 f9 ff ff       	call   10158a <cons_getc>
  101bc7:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101bca:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101bce:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101bd2:	89 54 24 08          	mov    %edx,0x8(%esp)
  101bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bda:	c7 04 24 14 61 10 00 	movl   $0x106114,(%esp)
  101be1:	e8 a7 e6 ff ff       	call   10028d <cprintf>
        break;
  101be6:	eb 7b                	jmp    101c63 <trap_dispatch+0xda>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101be8:	e8 9d f9 ff ff       	call   10158a <cons_getc>
  101bed:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101bf0:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101bf4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101bf8:	89 54 24 08          	mov    %edx,0x8(%esp)
  101bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c00:	c7 04 24 26 61 10 00 	movl   $0x106126,(%esp)
  101c07:	e8 81 e6 ff ff       	call   10028d <cprintf>
        break;
  101c0c:	eb 55                	jmp    101c63 <trap_dispatch+0xda>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101c0e:	c7 44 24 08 35 61 10 	movl   $0x106135,0x8(%esp)
  101c15:	00 
  101c16:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  101c1d:	00 
  101c1e:	c7 04 24 45 61 10 00 	movl   $0x106145,(%esp)
  101c25:	e8 ba e7 ff ff       	call   1003e4 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c31:	83 e0 03             	and    $0x3,%eax
  101c34:	85 c0                	test   %eax,%eax
  101c36:	75 2b                	jne    101c63 <trap_dispatch+0xda>
            print_trapframe(tf);
  101c38:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3b:	89 04 24             	mov    %eax,(%esp)
  101c3e:	e8 d9 fc ff ff       	call   10191c <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101c43:	c7 44 24 08 56 61 10 	movl   $0x106156,0x8(%esp)
  101c4a:	00 
  101c4b:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  101c52:	00 
  101c53:	c7 04 24 45 61 10 00 	movl   $0x106145,(%esp)
  101c5a:	e8 85 e7 ff ff       	call   1003e4 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101c5f:	90                   	nop
  101c60:	eb 01                	jmp    101c63 <trap_dispatch+0xda>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
  101c62:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101c63:	90                   	nop
  101c64:	c9                   	leave  
  101c65:	c3                   	ret    

00101c66 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101c66:	55                   	push   %ebp
  101c67:	89 e5                	mov    %esp,%ebp
  101c69:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6f:	89 04 24             	mov    %eax,(%esp)
  101c72:	e8 12 ff ff ff       	call   101b89 <trap_dispatch>
}
  101c77:	90                   	nop
  101c78:	c9                   	leave  
  101c79:	c3                   	ret    

00101c7a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101c7a:	6a 00                	push   $0x0
  pushl $0
  101c7c:	6a 00                	push   $0x0
  jmp __alltraps
  101c7e:	e9 69 0a 00 00       	jmp    1026ec <__alltraps>

00101c83 <vector1>:
.globl vector1
vector1:
  pushl $0
  101c83:	6a 00                	push   $0x0
  pushl $1
  101c85:	6a 01                	push   $0x1
  jmp __alltraps
  101c87:	e9 60 0a 00 00       	jmp    1026ec <__alltraps>

00101c8c <vector2>:
.globl vector2
vector2:
  pushl $0
  101c8c:	6a 00                	push   $0x0
  pushl $2
  101c8e:	6a 02                	push   $0x2
  jmp __alltraps
  101c90:	e9 57 0a 00 00       	jmp    1026ec <__alltraps>

00101c95 <vector3>:
.globl vector3
vector3:
  pushl $0
  101c95:	6a 00                	push   $0x0
  pushl $3
  101c97:	6a 03                	push   $0x3
  jmp __alltraps
  101c99:	e9 4e 0a 00 00       	jmp    1026ec <__alltraps>

00101c9e <vector4>:
.globl vector4
vector4:
  pushl $0
  101c9e:	6a 00                	push   $0x0
  pushl $4
  101ca0:	6a 04                	push   $0x4
  jmp __alltraps
  101ca2:	e9 45 0a 00 00       	jmp    1026ec <__alltraps>

00101ca7 <vector5>:
.globl vector5
vector5:
  pushl $0
  101ca7:	6a 00                	push   $0x0
  pushl $5
  101ca9:	6a 05                	push   $0x5
  jmp __alltraps
  101cab:	e9 3c 0a 00 00       	jmp    1026ec <__alltraps>

00101cb0 <vector6>:
.globl vector6
vector6:
  pushl $0
  101cb0:	6a 00                	push   $0x0
  pushl $6
  101cb2:	6a 06                	push   $0x6
  jmp __alltraps
  101cb4:	e9 33 0a 00 00       	jmp    1026ec <__alltraps>

00101cb9 <vector7>:
.globl vector7
vector7:
  pushl $0
  101cb9:	6a 00                	push   $0x0
  pushl $7
  101cbb:	6a 07                	push   $0x7
  jmp __alltraps
  101cbd:	e9 2a 0a 00 00       	jmp    1026ec <__alltraps>

00101cc2 <vector8>:
.globl vector8
vector8:
  pushl $8
  101cc2:	6a 08                	push   $0x8
  jmp __alltraps
  101cc4:	e9 23 0a 00 00       	jmp    1026ec <__alltraps>

00101cc9 <vector9>:
.globl vector9
vector9:
  pushl $0
  101cc9:	6a 00                	push   $0x0
  pushl $9
  101ccb:	6a 09                	push   $0x9
  jmp __alltraps
  101ccd:	e9 1a 0a 00 00       	jmp    1026ec <__alltraps>

00101cd2 <vector10>:
.globl vector10
vector10:
  pushl $10
  101cd2:	6a 0a                	push   $0xa
  jmp __alltraps
  101cd4:	e9 13 0a 00 00       	jmp    1026ec <__alltraps>

00101cd9 <vector11>:
.globl vector11
vector11:
  pushl $11
  101cd9:	6a 0b                	push   $0xb
  jmp __alltraps
  101cdb:	e9 0c 0a 00 00       	jmp    1026ec <__alltraps>

00101ce0 <vector12>:
.globl vector12
vector12:
  pushl $12
  101ce0:	6a 0c                	push   $0xc
  jmp __alltraps
  101ce2:	e9 05 0a 00 00       	jmp    1026ec <__alltraps>

00101ce7 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ce7:	6a 0d                	push   $0xd
  jmp __alltraps
  101ce9:	e9 fe 09 00 00       	jmp    1026ec <__alltraps>

00101cee <vector14>:
.globl vector14
vector14:
  pushl $14
  101cee:	6a 0e                	push   $0xe
  jmp __alltraps
  101cf0:	e9 f7 09 00 00       	jmp    1026ec <__alltraps>

00101cf5 <vector15>:
.globl vector15
vector15:
  pushl $0
  101cf5:	6a 00                	push   $0x0
  pushl $15
  101cf7:	6a 0f                	push   $0xf
  jmp __alltraps
  101cf9:	e9 ee 09 00 00       	jmp    1026ec <__alltraps>

00101cfe <vector16>:
.globl vector16
vector16:
  pushl $0
  101cfe:	6a 00                	push   $0x0
  pushl $16
  101d00:	6a 10                	push   $0x10
  jmp __alltraps
  101d02:	e9 e5 09 00 00       	jmp    1026ec <__alltraps>

00101d07 <vector17>:
.globl vector17
vector17:
  pushl $17
  101d07:	6a 11                	push   $0x11
  jmp __alltraps
  101d09:	e9 de 09 00 00       	jmp    1026ec <__alltraps>

00101d0e <vector18>:
.globl vector18
vector18:
  pushl $0
  101d0e:	6a 00                	push   $0x0
  pushl $18
  101d10:	6a 12                	push   $0x12
  jmp __alltraps
  101d12:	e9 d5 09 00 00       	jmp    1026ec <__alltraps>

00101d17 <vector19>:
.globl vector19
vector19:
  pushl $0
  101d17:	6a 00                	push   $0x0
  pushl $19
  101d19:	6a 13                	push   $0x13
  jmp __alltraps
  101d1b:	e9 cc 09 00 00       	jmp    1026ec <__alltraps>

00101d20 <vector20>:
.globl vector20
vector20:
  pushl $0
  101d20:	6a 00                	push   $0x0
  pushl $20
  101d22:	6a 14                	push   $0x14
  jmp __alltraps
  101d24:	e9 c3 09 00 00       	jmp    1026ec <__alltraps>

00101d29 <vector21>:
.globl vector21
vector21:
  pushl $0
  101d29:	6a 00                	push   $0x0
  pushl $21
  101d2b:	6a 15                	push   $0x15
  jmp __alltraps
  101d2d:	e9 ba 09 00 00       	jmp    1026ec <__alltraps>

00101d32 <vector22>:
.globl vector22
vector22:
  pushl $0
  101d32:	6a 00                	push   $0x0
  pushl $22
  101d34:	6a 16                	push   $0x16
  jmp __alltraps
  101d36:	e9 b1 09 00 00       	jmp    1026ec <__alltraps>

00101d3b <vector23>:
.globl vector23
vector23:
  pushl $0
  101d3b:	6a 00                	push   $0x0
  pushl $23
  101d3d:	6a 17                	push   $0x17
  jmp __alltraps
  101d3f:	e9 a8 09 00 00       	jmp    1026ec <__alltraps>

00101d44 <vector24>:
.globl vector24
vector24:
  pushl $0
  101d44:	6a 00                	push   $0x0
  pushl $24
  101d46:	6a 18                	push   $0x18
  jmp __alltraps
  101d48:	e9 9f 09 00 00       	jmp    1026ec <__alltraps>

00101d4d <vector25>:
.globl vector25
vector25:
  pushl $0
  101d4d:	6a 00                	push   $0x0
  pushl $25
  101d4f:	6a 19                	push   $0x19
  jmp __alltraps
  101d51:	e9 96 09 00 00       	jmp    1026ec <__alltraps>

00101d56 <vector26>:
.globl vector26
vector26:
  pushl $0
  101d56:	6a 00                	push   $0x0
  pushl $26
  101d58:	6a 1a                	push   $0x1a
  jmp __alltraps
  101d5a:	e9 8d 09 00 00       	jmp    1026ec <__alltraps>

00101d5f <vector27>:
.globl vector27
vector27:
  pushl $0
  101d5f:	6a 00                	push   $0x0
  pushl $27
  101d61:	6a 1b                	push   $0x1b
  jmp __alltraps
  101d63:	e9 84 09 00 00       	jmp    1026ec <__alltraps>

00101d68 <vector28>:
.globl vector28
vector28:
  pushl $0
  101d68:	6a 00                	push   $0x0
  pushl $28
  101d6a:	6a 1c                	push   $0x1c
  jmp __alltraps
  101d6c:	e9 7b 09 00 00       	jmp    1026ec <__alltraps>

00101d71 <vector29>:
.globl vector29
vector29:
  pushl $0
  101d71:	6a 00                	push   $0x0
  pushl $29
  101d73:	6a 1d                	push   $0x1d
  jmp __alltraps
  101d75:	e9 72 09 00 00       	jmp    1026ec <__alltraps>

00101d7a <vector30>:
.globl vector30
vector30:
  pushl $0
  101d7a:	6a 00                	push   $0x0
  pushl $30
  101d7c:	6a 1e                	push   $0x1e
  jmp __alltraps
  101d7e:	e9 69 09 00 00       	jmp    1026ec <__alltraps>

00101d83 <vector31>:
.globl vector31
vector31:
  pushl $0
  101d83:	6a 00                	push   $0x0
  pushl $31
  101d85:	6a 1f                	push   $0x1f
  jmp __alltraps
  101d87:	e9 60 09 00 00       	jmp    1026ec <__alltraps>

00101d8c <vector32>:
.globl vector32
vector32:
  pushl $0
  101d8c:	6a 00                	push   $0x0
  pushl $32
  101d8e:	6a 20                	push   $0x20
  jmp __alltraps
  101d90:	e9 57 09 00 00       	jmp    1026ec <__alltraps>

00101d95 <vector33>:
.globl vector33
vector33:
  pushl $0
  101d95:	6a 00                	push   $0x0
  pushl $33
  101d97:	6a 21                	push   $0x21
  jmp __alltraps
  101d99:	e9 4e 09 00 00       	jmp    1026ec <__alltraps>

00101d9e <vector34>:
.globl vector34
vector34:
  pushl $0
  101d9e:	6a 00                	push   $0x0
  pushl $34
  101da0:	6a 22                	push   $0x22
  jmp __alltraps
  101da2:	e9 45 09 00 00       	jmp    1026ec <__alltraps>

00101da7 <vector35>:
.globl vector35
vector35:
  pushl $0
  101da7:	6a 00                	push   $0x0
  pushl $35
  101da9:	6a 23                	push   $0x23
  jmp __alltraps
  101dab:	e9 3c 09 00 00       	jmp    1026ec <__alltraps>

00101db0 <vector36>:
.globl vector36
vector36:
  pushl $0
  101db0:	6a 00                	push   $0x0
  pushl $36
  101db2:	6a 24                	push   $0x24
  jmp __alltraps
  101db4:	e9 33 09 00 00       	jmp    1026ec <__alltraps>

00101db9 <vector37>:
.globl vector37
vector37:
  pushl $0
  101db9:	6a 00                	push   $0x0
  pushl $37
  101dbb:	6a 25                	push   $0x25
  jmp __alltraps
  101dbd:	e9 2a 09 00 00       	jmp    1026ec <__alltraps>

00101dc2 <vector38>:
.globl vector38
vector38:
  pushl $0
  101dc2:	6a 00                	push   $0x0
  pushl $38
  101dc4:	6a 26                	push   $0x26
  jmp __alltraps
  101dc6:	e9 21 09 00 00       	jmp    1026ec <__alltraps>

00101dcb <vector39>:
.globl vector39
vector39:
  pushl $0
  101dcb:	6a 00                	push   $0x0
  pushl $39
  101dcd:	6a 27                	push   $0x27
  jmp __alltraps
  101dcf:	e9 18 09 00 00       	jmp    1026ec <__alltraps>

00101dd4 <vector40>:
.globl vector40
vector40:
  pushl $0
  101dd4:	6a 00                	push   $0x0
  pushl $40
  101dd6:	6a 28                	push   $0x28
  jmp __alltraps
  101dd8:	e9 0f 09 00 00       	jmp    1026ec <__alltraps>

00101ddd <vector41>:
.globl vector41
vector41:
  pushl $0
  101ddd:	6a 00                	push   $0x0
  pushl $41
  101ddf:	6a 29                	push   $0x29
  jmp __alltraps
  101de1:	e9 06 09 00 00       	jmp    1026ec <__alltraps>

00101de6 <vector42>:
.globl vector42
vector42:
  pushl $0
  101de6:	6a 00                	push   $0x0
  pushl $42
  101de8:	6a 2a                	push   $0x2a
  jmp __alltraps
  101dea:	e9 fd 08 00 00       	jmp    1026ec <__alltraps>

00101def <vector43>:
.globl vector43
vector43:
  pushl $0
  101def:	6a 00                	push   $0x0
  pushl $43
  101df1:	6a 2b                	push   $0x2b
  jmp __alltraps
  101df3:	e9 f4 08 00 00       	jmp    1026ec <__alltraps>

00101df8 <vector44>:
.globl vector44
vector44:
  pushl $0
  101df8:	6a 00                	push   $0x0
  pushl $44
  101dfa:	6a 2c                	push   $0x2c
  jmp __alltraps
  101dfc:	e9 eb 08 00 00       	jmp    1026ec <__alltraps>

00101e01 <vector45>:
.globl vector45
vector45:
  pushl $0
  101e01:	6a 00                	push   $0x0
  pushl $45
  101e03:	6a 2d                	push   $0x2d
  jmp __alltraps
  101e05:	e9 e2 08 00 00       	jmp    1026ec <__alltraps>

00101e0a <vector46>:
.globl vector46
vector46:
  pushl $0
  101e0a:	6a 00                	push   $0x0
  pushl $46
  101e0c:	6a 2e                	push   $0x2e
  jmp __alltraps
  101e0e:	e9 d9 08 00 00       	jmp    1026ec <__alltraps>

00101e13 <vector47>:
.globl vector47
vector47:
  pushl $0
  101e13:	6a 00                	push   $0x0
  pushl $47
  101e15:	6a 2f                	push   $0x2f
  jmp __alltraps
  101e17:	e9 d0 08 00 00       	jmp    1026ec <__alltraps>

00101e1c <vector48>:
.globl vector48
vector48:
  pushl $0
  101e1c:	6a 00                	push   $0x0
  pushl $48
  101e1e:	6a 30                	push   $0x30
  jmp __alltraps
  101e20:	e9 c7 08 00 00       	jmp    1026ec <__alltraps>

00101e25 <vector49>:
.globl vector49
vector49:
  pushl $0
  101e25:	6a 00                	push   $0x0
  pushl $49
  101e27:	6a 31                	push   $0x31
  jmp __alltraps
  101e29:	e9 be 08 00 00       	jmp    1026ec <__alltraps>

00101e2e <vector50>:
.globl vector50
vector50:
  pushl $0
  101e2e:	6a 00                	push   $0x0
  pushl $50
  101e30:	6a 32                	push   $0x32
  jmp __alltraps
  101e32:	e9 b5 08 00 00       	jmp    1026ec <__alltraps>

00101e37 <vector51>:
.globl vector51
vector51:
  pushl $0
  101e37:	6a 00                	push   $0x0
  pushl $51
  101e39:	6a 33                	push   $0x33
  jmp __alltraps
  101e3b:	e9 ac 08 00 00       	jmp    1026ec <__alltraps>

00101e40 <vector52>:
.globl vector52
vector52:
  pushl $0
  101e40:	6a 00                	push   $0x0
  pushl $52
  101e42:	6a 34                	push   $0x34
  jmp __alltraps
  101e44:	e9 a3 08 00 00       	jmp    1026ec <__alltraps>

00101e49 <vector53>:
.globl vector53
vector53:
  pushl $0
  101e49:	6a 00                	push   $0x0
  pushl $53
  101e4b:	6a 35                	push   $0x35
  jmp __alltraps
  101e4d:	e9 9a 08 00 00       	jmp    1026ec <__alltraps>

00101e52 <vector54>:
.globl vector54
vector54:
  pushl $0
  101e52:	6a 00                	push   $0x0
  pushl $54
  101e54:	6a 36                	push   $0x36
  jmp __alltraps
  101e56:	e9 91 08 00 00       	jmp    1026ec <__alltraps>

00101e5b <vector55>:
.globl vector55
vector55:
  pushl $0
  101e5b:	6a 00                	push   $0x0
  pushl $55
  101e5d:	6a 37                	push   $0x37
  jmp __alltraps
  101e5f:	e9 88 08 00 00       	jmp    1026ec <__alltraps>

00101e64 <vector56>:
.globl vector56
vector56:
  pushl $0
  101e64:	6a 00                	push   $0x0
  pushl $56
  101e66:	6a 38                	push   $0x38
  jmp __alltraps
  101e68:	e9 7f 08 00 00       	jmp    1026ec <__alltraps>

00101e6d <vector57>:
.globl vector57
vector57:
  pushl $0
  101e6d:	6a 00                	push   $0x0
  pushl $57
  101e6f:	6a 39                	push   $0x39
  jmp __alltraps
  101e71:	e9 76 08 00 00       	jmp    1026ec <__alltraps>

00101e76 <vector58>:
.globl vector58
vector58:
  pushl $0
  101e76:	6a 00                	push   $0x0
  pushl $58
  101e78:	6a 3a                	push   $0x3a
  jmp __alltraps
  101e7a:	e9 6d 08 00 00       	jmp    1026ec <__alltraps>

00101e7f <vector59>:
.globl vector59
vector59:
  pushl $0
  101e7f:	6a 00                	push   $0x0
  pushl $59
  101e81:	6a 3b                	push   $0x3b
  jmp __alltraps
  101e83:	e9 64 08 00 00       	jmp    1026ec <__alltraps>

00101e88 <vector60>:
.globl vector60
vector60:
  pushl $0
  101e88:	6a 00                	push   $0x0
  pushl $60
  101e8a:	6a 3c                	push   $0x3c
  jmp __alltraps
  101e8c:	e9 5b 08 00 00       	jmp    1026ec <__alltraps>

00101e91 <vector61>:
.globl vector61
vector61:
  pushl $0
  101e91:	6a 00                	push   $0x0
  pushl $61
  101e93:	6a 3d                	push   $0x3d
  jmp __alltraps
  101e95:	e9 52 08 00 00       	jmp    1026ec <__alltraps>

00101e9a <vector62>:
.globl vector62
vector62:
  pushl $0
  101e9a:	6a 00                	push   $0x0
  pushl $62
  101e9c:	6a 3e                	push   $0x3e
  jmp __alltraps
  101e9e:	e9 49 08 00 00       	jmp    1026ec <__alltraps>

00101ea3 <vector63>:
.globl vector63
vector63:
  pushl $0
  101ea3:	6a 00                	push   $0x0
  pushl $63
  101ea5:	6a 3f                	push   $0x3f
  jmp __alltraps
  101ea7:	e9 40 08 00 00       	jmp    1026ec <__alltraps>

00101eac <vector64>:
.globl vector64
vector64:
  pushl $0
  101eac:	6a 00                	push   $0x0
  pushl $64
  101eae:	6a 40                	push   $0x40
  jmp __alltraps
  101eb0:	e9 37 08 00 00       	jmp    1026ec <__alltraps>

00101eb5 <vector65>:
.globl vector65
vector65:
  pushl $0
  101eb5:	6a 00                	push   $0x0
  pushl $65
  101eb7:	6a 41                	push   $0x41
  jmp __alltraps
  101eb9:	e9 2e 08 00 00       	jmp    1026ec <__alltraps>

00101ebe <vector66>:
.globl vector66
vector66:
  pushl $0
  101ebe:	6a 00                	push   $0x0
  pushl $66
  101ec0:	6a 42                	push   $0x42
  jmp __alltraps
  101ec2:	e9 25 08 00 00       	jmp    1026ec <__alltraps>

00101ec7 <vector67>:
.globl vector67
vector67:
  pushl $0
  101ec7:	6a 00                	push   $0x0
  pushl $67
  101ec9:	6a 43                	push   $0x43
  jmp __alltraps
  101ecb:	e9 1c 08 00 00       	jmp    1026ec <__alltraps>

00101ed0 <vector68>:
.globl vector68
vector68:
  pushl $0
  101ed0:	6a 00                	push   $0x0
  pushl $68
  101ed2:	6a 44                	push   $0x44
  jmp __alltraps
  101ed4:	e9 13 08 00 00       	jmp    1026ec <__alltraps>

00101ed9 <vector69>:
.globl vector69
vector69:
  pushl $0
  101ed9:	6a 00                	push   $0x0
  pushl $69
  101edb:	6a 45                	push   $0x45
  jmp __alltraps
  101edd:	e9 0a 08 00 00       	jmp    1026ec <__alltraps>

00101ee2 <vector70>:
.globl vector70
vector70:
  pushl $0
  101ee2:	6a 00                	push   $0x0
  pushl $70
  101ee4:	6a 46                	push   $0x46
  jmp __alltraps
  101ee6:	e9 01 08 00 00       	jmp    1026ec <__alltraps>

00101eeb <vector71>:
.globl vector71
vector71:
  pushl $0
  101eeb:	6a 00                	push   $0x0
  pushl $71
  101eed:	6a 47                	push   $0x47
  jmp __alltraps
  101eef:	e9 f8 07 00 00       	jmp    1026ec <__alltraps>

00101ef4 <vector72>:
.globl vector72
vector72:
  pushl $0
  101ef4:	6a 00                	push   $0x0
  pushl $72
  101ef6:	6a 48                	push   $0x48
  jmp __alltraps
  101ef8:	e9 ef 07 00 00       	jmp    1026ec <__alltraps>

00101efd <vector73>:
.globl vector73
vector73:
  pushl $0
  101efd:	6a 00                	push   $0x0
  pushl $73
  101eff:	6a 49                	push   $0x49
  jmp __alltraps
  101f01:	e9 e6 07 00 00       	jmp    1026ec <__alltraps>

00101f06 <vector74>:
.globl vector74
vector74:
  pushl $0
  101f06:	6a 00                	push   $0x0
  pushl $74
  101f08:	6a 4a                	push   $0x4a
  jmp __alltraps
  101f0a:	e9 dd 07 00 00       	jmp    1026ec <__alltraps>

00101f0f <vector75>:
.globl vector75
vector75:
  pushl $0
  101f0f:	6a 00                	push   $0x0
  pushl $75
  101f11:	6a 4b                	push   $0x4b
  jmp __alltraps
  101f13:	e9 d4 07 00 00       	jmp    1026ec <__alltraps>

00101f18 <vector76>:
.globl vector76
vector76:
  pushl $0
  101f18:	6a 00                	push   $0x0
  pushl $76
  101f1a:	6a 4c                	push   $0x4c
  jmp __alltraps
  101f1c:	e9 cb 07 00 00       	jmp    1026ec <__alltraps>

00101f21 <vector77>:
.globl vector77
vector77:
  pushl $0
  101f21:	6a 00                	push   $0x0
  pushl $77
  101f23:	6a 4d                	push   $0x4d
  jmp __alltraps
  101f25:	e9 c2 07 00 00       	jmp    1026ec <__alltraps>

00101f2a <vector78>:
.globl vector78
vector78:
  pushl $0
  101f2a:	6a 00                	push   $0x0
  pushl $78
  101f2c:	6a 4e                	push   $0x4e
  jmp __alltraps
  101f2e:	e9 b9 07 00 00       	jmp    1026ec <__alltraps>

00101f33 <vector79>:
.globl vector79
vector79:
  pushl $0
  101f33:	6a 00                	push   $0x0
  pushl $79
  101f35:	6a 4f                	push   $0x4f
  jmp __alltraps
  101f37:	e9 b0 07 00 00       	jmp    1026ec <__alltraps>

00101f3c <vector80>:
.globl vector80
vector80:
  pushl $0
  101f3c:	6a 00                	push   $0x0
  pushl $80
  101f3e:	6a 50                	push   $0x50
  jmp __alltraps
  101f40:	e9 a7 07 00 00       	jmp    1026ec <__alltraps>

00101f45 <vector81>:
.globl vector81
vector81:
  pushl $0
  101f45:	6a 00                	push   $0x0
  pushl $81
  101f47:	6a 51                	push   $0x51
  jmp __alltraps
  101f49:	e9 9e 07 00 00       	jmp    1026ec <__alltraps>

00101f4e <vector82>:
.globl vector82
vector82:
  pushl $0
  101f4e:	6a 00                	push   $0x0
  pushl $82
  101f50:	6a 52                	push   $0x52
  jmp __alltraps
  101f52:	e9 95 07 00 00       	jmp    1026ec <__alltraps>

00101f57 <vector83>:
.globl vector83
vector83:
  pushl $0
  101f57:	6a 00                	push   $0x0
  pushl $83
  101f59:	6a 53                	push   $0x53
  jmp __alltraps
  101f5b:	e9 8c 07 00 00       	jmp    1026ec <__alltraps>

00101f60 <vector84>:
.globl vector84
vector84:
  pushl $0
  101f60:	6a 00                	push   $0x0
  pushl $84
  101f62:	6a 54                	push   $0x54
  jmp __alltraps
  101f64:	e9 83 07 00 00       	jmp    1026ec <__alltraps>

00101f69 <vector85>:
.globl vector85
vector85:
  pushl $0
  101f69:	6a 00                	push   $0x0
  pushl $85
  101f6b:	6a 55                	push   $0x55
  jmp __alltraps
  101f6d:	e9 7a 07 00 00       	jmp    1026ec <__alltraps>

00101f72 <vector86>:
.globl vector86
vector86:
  pushl $0
  101f72:	6a 00                	push   $0x0
  pushl $86
  101f74:	6a 56                	push   $0x56
  jmp __alltraps
  101f76:	e9 71 07 00 00       	jmp    1026ec <__alltraps>

00101f7b <vector87>:
.globl vector87
vector87:
  pushl $0
  101f7b:	6a 00                	push   $0x0
  pushl $87
  101f7d:	6a 57                	push   $0x57
  jmp __alltraps
  101f7f:	e9 68 07 00 00       	jmp    1026ec <__alltraps>

00101f84 <vector88>:
.globl vector88
vector88:
  pushl $0
  101f84:	6a 00                	push   $0x0
  pushl $88
  101f86:	6a 58                	push   $0x58
  jmp __alltraps
  101f88:	e9 5f 07 00 00       	jmp    1026ec <__alltraps>

00101f8d <vector89>:
.globl vector89
vector89:
  pushl $0
  101f8d:	6a 00                	push   $0x0
  pushl $89
  101f8f:	6a 59                	push   $0x59
  jmp __alltraps
  101f91:	e9 56 07 00 00       	jmp    1026ec <__alltraps>

00101f96 <vector90>:
.globl vector90
vector90:
  pushl $0
  101f96:	6a 00                	push   $0x0
  pushl $90
  101f98:	6a 5a                	push   $0x5a
  jmp __alltraps
  101f9a:	e9 4d 07 00 00       	jmp    1026ec <__alltraps>

00101f9f <vector91>:
.globl vector91
vector91:
  pushl $0
  101f9f:	6a 00                	push   $0x0
  pushl $91
  101fa1:	6a 5b                	push   $0x5b
  jmp __alltraps
  101fa3:	e9 44 07 00 00       	jmp    1026ec <__alltraps>

00101fa8 <vector92>:
.globl vector92
vector92:
  pushl $0
  101fa8:	6a 00                	push   $0x0
  pushl $92
  101faa:	6a 5c                	push   $0x5c
  jmp __alltraps
  101fac:	e9 3b 07 00 00       	jmp    1026ec <__alltraps>

00101fb1 <vector93>:
.globl vector93
vector93:
  pushl $0
  101fb1:	6a 00                	push   $0x0
  pushl $93
  101fb3:	6a 5d                	push   $0x5d
  jmp __alltraps
  101fb5:	e9 32 07 00 00       	jmp    1026ec <__alltraps>

00101fba <vector94>:
.globl vector94
vector94:
  pushl $0
  101fba:	6a 00                	push   $0x0
  pushl $94
  101fbc:	6a 5e                	push   $0x5e
  jmp __alltraps
  101fbe:	e9 29 07 00 00       	jmp    1026ec <__alltraps>

00101fc3 <vector95>:
.globl vector95
vector95:
  pushl $0
  101fc3:	6a 00                	push   $0x0
  pushl $95
  101fc5:	6a 5f                	push   $0x5f
  jmp __alltraps
  101fc7:	e9 20 07 00 00       	jmp    1026ec <__alltraps>

00101fcc <vector96>:
.globl vector96
vector96:
  pushl $0
  101fcc:	6a 00                	push   $0x0
  pushl $96
  101fce:	6a 60                	push   $0x60
  jmp __alltraps
  101fd0:	e9 17 07 00 00       	jmp    1026ec <__alltraps>

00101fd5 <vector97>:
.globl vector97
vector97:
  pushl $0
  101fd5:	6a 00                	push   $0x0
  pushl $97
  101fd7:	6a 61                	push   $0x61
  jmp __alltraps
  101fd9:	e9 0e 07 00 00       	jmp    1026ec <__alltraps>

00101fde <vector98>:
.globl vector98
vector98:
  pushl $0
  101fde:	6a 00                	push   $0x0
  pushl $98
  101fe0:	6a 62                	push   $0x62
  jmp __alltraps
  101fe2:	e9 05 07 00 00       	jmp    1026ec <__alltraps>

00101fe7 <vector99>:
.globl vector99
vector99:
  pushl $0
  101fe7:	6a 00                	push   $0x0
  pushl $99
  101fe9:	6a 63                	push   $0x63
  jmp __alltraps
  101feb:	e9 fc 06 00 00       	jmp    1026ec <__alltraps>

00101ff0 <vector100>:
.globl vector100
vector100:
  pushl $0
  101ff0:	6a 00                	push   $0x0
  pushl $100
  101ff2:	6a 64                	push   $0x64
  jmp __alltraps
  101ff4:	e9 f3 06 00 00       	jmp    1026ec <__alltraps>

00101ff9 <vector101>:
.globl vector101
vector101:
  pushl $0
  101ff9:	6a 00                	push   $0x0
  pushl $101
  101ffb:	6a 65                	push   $0x65
  jmp __alltraps
  101ffd:	e9 ea 06 00 00       	jmp    1026ec <__alltraps>

00102002 <vector102>:
.globl vector102
vector102:
  pushl $0
  102002:	6a 00                	push   $0x0
  pushl $102
  102004:	6a 66                	push   $0x66
  jmp __alltraps
  102006:	e9 e1 06 00 00       	jmp    1026ec <__alltraps>

0010200b <vector103>:
.globl vector103
vector103:
  pushl $0
  10200b:	6a 00                	push   $0x0
  pushl $103
  10200d:	6a 67                	push   $0x67
  jmp __alltraps
  10200f:	e9 d8 06 00 00       	jmp    1026ec <__alltraps>

00102014 <vector104>:
.globl vector104
vector104:
  pushl $0
  102014:	6a 00                	push   $0x0
  pushl $104
  102016:	6a 68                	push   $0x68
  jmp __alltraps
  102018:	e9 cf 06 00 00       	jmp    1026ec <__alltraps>

0010201d <vector105>:
.globl vector105
vector105:
  pushl $0
  10201d:	6a 00                	push   $0x0
  pushl $105
  10201f:	6a 69                	push   $0x69
  jmp __alltraps
  102021:	e9 c6 06 00 00       	jmp    1026ec <__alltraps>

00102026 <vector106>:
.globl vector106
vector106:
  pushl $0
  102026:	6a 00                	push   $0x0
  pushl $106
  102028:	6a 6a                	push   $0x6a
  jmp __alltraps
  10202a:	e9 bd 06 00 00       	jmp    1026ec <__alltraps>

0010202f <vector107>:
.globl vector107
vector107:
  pushl $0
  10202f:	6a 00                	push   $0x0
  pushl $107
  102031:	6a 6b                	push   $0x6b
  jmp __alltraps
  102033:	e9 b4 06 00 00       	jmp    1026ec <__alltraps>

00102038 <vector108>:
.globl vector108
vector108:
  pushl $0
  102038:	6a 00                	push   $0x0
  pushl $108
  10203a:	6a 6c                	push   $0x6c
  jmp __alltraps
  10203c:	e9 ab 06 00 00       	jmp    1026ec <__alltraps>

00102041 <vector109>:
.globl vector109
vector109:
  pushl $0
  102041:	6a 00                	push   $0x0
  pushl $109
  102043:	6a 6d                	push   $0x6d
  jmp __alltraps
  102045:	e9 a2 06 00 00       	jmp    1026ec <__alltraps>

0010204a <vector110>:
.globl vector110
vector110:
  pushl $0
  10204a:	6a 00                	push   $0x0
  pushl $110
  10204c:	6a 6e                	push   $0x6e
  jmp __alltraps
  10204e:	e9 99 06 00 00       	jmp    1026ec <__alltraps>

00102053 <vector111>:
.globl vector111
vector111:
  pushl $0
  102053:	6a 00                	push   $0x0
  pushl $111
  102055:	6a 6f                	push   $0x6f
  jmp __alltraps
  102057:	e9 90 06 00 00       	jmp    1026ec <__alltraps>

0010205c <vector112>:
.globl vector112
vector112:
  pushl $0
  10205c:	6a 00                	push   $0x0
  pushl $112
  10205e:	6a 70                	push   $0x70
  jmp __alltraps
  102060:	e9 87 06 00 00       	jmp    1026ec <__alltraps>

00102065 <vector113>:
.globl vector113
vector113:
  pushl $0
  102065:	6a 00                	push   $0x0
  pushl $113
  102067:	6a 71                	push   $0x71
  jmp __alltraps
  102069:	e9 7e 06 00 00       	jmp    1026ec <__alltraps>

0010206e <vector114>:
.globl vector114
vector114:
  pushl $0
  10206e:	6a 00                	push   $0x0
  pushl $114
  102070:	6a 72                	push   $0x72
  jmp __alltraps
  102072:	e9 75 06 00 00       	jmp    1026ec <__alltraps>

00102077 <vector115>:
.globl vector115
vector115:
  pushl $0
  102077:	6a 00                	push   $0x0
  pushl $115
  102079:	6a 73                	push   $0x73
  jmp __alltraps
  10207b:	e9 6c 06 00 00       	jmp    1026ec <__alltraps>

00102080 <vector116>:
.globl vector116
vector116:
  pushl $0
  102080:	6a 00                	push   $0x0
  pushl $116
  102082:	6a 74                	push   $0x74
  jmp __alltraps
  102084:	e9 63 06 00 00       	jmp    1026ec <__alltraps>

00102089 <vector117>:
.globl vector117
vector117:
  pushl $0
  102089:	6a 00                	push   $0x0
  pushl $117
  10208b:	6a 75                	push   $0x75
  jmp __alltraps
  10208d:	e9 5a 06 00 00       	jmp    1026ec <__alltraps>

00102092 <vector118>:
.globl vector118
vector118:
  pushl $0
  102092:	6a 00                	push   $0x0
  pushl $118
  102094:	6a 76                	push   $0x76
  jmp __alltraps
  102096:	e9 51 06 00 00       	jmp    1026ec <__alltraps>

0010209b <vector119>:
.globl vector119
vector119:
  pushl $0
  10209b:	6a 00                	push   $0x0
  pushl $119
  10209d:	6a 77                	push   $0x77
  jmp __alltraps
  10209f:	e9 48 06 00 00       	jmp    1026ec <__alltraps>

001020a4 <vector120>:
.globl vector120
vector120:
  pushl $0
  1020a4:	6a 00                	push   $0x0
  pushl $120
  1020a6:	6a 78                	push   $0x78
  jmp __alltraps
  1020a8:	e9 3f 06 00 00       	jmp    1026ec <__alltraps>

001020ad <vector121>:
.globl vector121
vector121:
  pushl $0
  1020ad:	6a 00                	push   $0x0
  pushl $121
  1020af:	6a 79                	push   $0x79
  jmp __alltraps
  1020b1:	e9 36 06 00 00       	jmp    1026ec <__alltraps>

001020b6 <vector122>:
.globl vector122
vector122:
  pushl $0
  1020b6:	6a 00                	push   $0x0
  pushl $122
  1020b8:	6a 7a                	push   $0x7a
  jmp __alltraps
  1020ba:	e9 2d 06 00 00       	jmp    1026ec <__alltraps>

001020bf <vector123>:
.globl vector123
vector123:
  pushl $0
  1020bf:	6a 00                	push   $0x0
  pushl $123
  1020c1:	6a 7b                	push   $0x7b
  jmp __alltraps
  1020c3:	e9 24 06 00 00       	jmp    1026ec <__alltraps>

001020c8 <vector124>:
.globl vector124
vector124:
  pushl $0
  1020c8:	6a 00                	push   $0x0
  pushl $124
  1020ca:	6a 7c                	push   $0x7c
  jmp __alltraps
  1020cc:	e9 1b 06 00 00       	jmp    1026ec <__alltraps>

001020d1 <vector125>:
.globl vector125
vector125:
  pushl $0
  1020d1:	6a 00                	push   $0x0
  pushl $125
  1020d3:	6a 7d                	push   $0x7d
  jmp __alltraps
  1020d5:	e9 12 06 00 00       	jmp    1026ec <__alltraps>

001020da <vector126>:
.globl vector126
vector126:
  pushl $0
  1020da:	6a 00                	push   $0x0
  pushl $126
  1020dc:	6a 7e                	push   $0x7e
  jmp __alltraps
  1020de:	e9 09 06 00 00       	jmp    1026ec <__alltraps>

001020e3 <vector127>:
.globl vector127
vector127:
  pushl $0
  1020e3:	6a 00                	push   $0x0
  pushl $127
  1020e5:	6a 7f                	push   $0x7f
  jmp __alltraps
  1020e7:	e9 00 06 00 00       	jmp    1026ec <__alltraps>

001020ec <vector128>:
.globl vector128
vector128:
  pushl $0
  1020ec:	6a 00                	push   $0x0
  pushl $128
  1020ee:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1020f3:	e9 f4 05 00 00       	jmp    1026ec <__alltraps>

001020f8 <vector129>:
.globl vector129
vector129:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $129
  1020fa:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1020ff:	e9 e8 05 00 00       	jmp    1026ec <__alltraps>

00102104 <vector130>:
.globl vector130
vector130:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $130
  102106:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10210b:	e9 dc 05 00 00       	jmp    1026ec <__alltraps>

00102110 <vector131>:
.globl vector131
vector131:
  pushl $0
  102110:	6a 00                	push   $0x0
  pushl $131
  102112:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102117:	e9 d0 05 00 00       	jmp    1026ec <__alltraps>

0010211c <vector132>:
.globl vector132
vector132:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $132
  10211e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102123:	e9 c4 05 00 00       	jmp    1026ec <__alltraps>

00102128 <vector133>:
.globl vector133
vector133:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $133
  10212a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10212f:	e9 b8 05 00 00       	jmp    1026ec <__alltraps>

00102134 <vector134>:
.globl vector134
vector134:
  pushl $0
  102134:	6a 00                	push   $0x0
  pushl $134
  102136:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10213b:	e9 ac 05 00 00       	jmp    1026ec <__alltraps>

00102140 <vector135>:
.globl vector135
vector135:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $135
  102142:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102147:	e9 a0 05 00 00       	jmp    1026ec <__alltraps>

0010214c <vector136>:
.globl vector136
vector136:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $136
  10214e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102153:	e9 94 05 00 00       	jmp    1026ec <__alltraps>

00102158 <vector137>:
.globl vector137
vector137:
  pushl $0
  102158:	6a 00                	push   $0x0
  pushl $137
  10215a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10215f:	e9 88 05 00 00       	jmp    1026ec <__alltraps>

00102164 <vector138>:
.globl vector138
vector138:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $138
  102166:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10216b:	e9 7c 05 00 00       	jmp    1026ec <__alltraps>

00102170 <vector139>:
.globl vector139
vector139:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $139
  102172:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102177:	e9 70 05 00 00       	jmp    1026ec <__alltraps>

0010217c <vector140>:
.globl vector140
vector140:
  pushl $0
  10217c:	6a 00                	push   $0x0
  pushl $140
  10217e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102183:	e9 64 05 00 00       	jmp    1026ec <__alltraps>

00102188 <vector141>:
.globl vector141
vector141:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $141
  10218a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10218f:	e9 58 05 00 00       	jmp    1026ec <__alltraps>

00102194 <vector142>:
.globl vector142
vector142:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $142
  102196:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10219b:	e9 4c 05 00 00       	jmp    1026ec <__alltraps>

001021a0 <vector143>:
.globl vector143
vector143:
  pushl $0
  1021a0:	6a 00                	push   $0x0
  pushl $143
  1021a2:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1021a7:	e9 40 05 00 00       	jmp    1026ec <__alltraps>

001021ac <vector144>:
.globl vector144
vector144:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $144
  1021ae:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1021b3:	e9 34 05 00 00       	jmp    1026ec <__alltraps>

001021b8 <vector145>:
.globl vector145
vector145:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $145
  1021ba:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1021bf:	e9 28 05 00 00       	jmp    1026ec <__alltraps>

001021c4 <vector146>:
.globl vector146
vector146:
  pushl $0
  1021c4:	6a 00                	push   $0x0
  pushl $146
  1021c6:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1021cb:	e9 1c 05 00 00       	jmp    1026ec <__alltraps>

001021d0 <vector147>:
.globl vector147
vector147:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $147
  1021d2:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1021d7:	e9 10 05 00 00       	jmp    1026ec <__alltraps>

001021dc <vector148>:
.globl vector148
vector148:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $148
  1021de:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1021e3:	e9 04 05 00 00       	jmp    1026ec <__alltraps>

001021e8 <vector149>:
.globl vector149
vector149:
  pushl $0
  1021e8:	6a 00                	push   $0x0
  pushl $149
  1021ea:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1021ef:	e9 f8 04 00 00       	jmp    1026ec <__alltraps>

001021f4 <vector150>:
.globl vector150
vector150:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $150
  1021f6:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1021fb:	e9 ec 04 00 00       	jmp    1026ec <__alltraps>

00102200 <vector151>:
.globl vector151
vector151:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $151
  102202:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102207:	e9 e0 04 00 00       	jmp    1026ec <__alltraps>

0010220c <vector152>:
.globl vector152
vector152:
  pushl $0
  10220c:	6a 00                	push   $0x0
  pushl $152
  10220e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102213:	e9 d4 04 00 00       	jmp    1026ec <__alltraps>

00102218 <vector153>:
.globl vector153
vector153:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $153
  10221a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10221f:	e9 c8 04 00 00       	jmp    1026ec <__alltraps>

00102224 <vector154>:
.globl vector154
vector154:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $154
  102226:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10222b:	e9 bc 04 00 00       	jmp    1026ec <__alltraps>

00102230 <vector155>:
.globl vector155
vector155:
  pushl $0
  102230:	6a 00                	push   $0x0
  pushl $155
  102232:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102237:	e9 b0 04 00 00       	jmp    1026ec <__alltraps>

0010223c <vector156>:
.globl vector156
vector156:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $156
  10223e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102243:	e9 a4 04 00 00       	jmp    1026ec <__alltraps>

00102248 <vector157>:
.globl vector157
vector157:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $157
  10224a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10224f:	e9 98 04 00 00       	jmp    1026ec <__alltraps>

00102254 <vector158>:
.globl vector158
vector158:
  pushl $0
  102254:	6a 00                	push   $0x0
  pushl $158
  102256:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10225b:	e9 8c 04 00 00       	jmp    1026ec <__alltraps>

00102260 <vector159>:
.globl vector159
vector159:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $159
  102262:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102267:	e9 80 04 00 00       	jmp    1026ec <__alltraps>

0010226c <vector160>:
.globl vector160
vector160:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $160
  10226e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102273:	e9 74 04 00 00       	jmp    1026ec <__alltraps>

00102278 <vector161>:
.globl vector161
vector161:
  pushl $0
  102278:	6a 00                	push   $0x0
  pushl $161
  10227a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10227f:	e9 68 04 00 00       	jmp    1026ec <__alltraps>

00102284 <vector162>:
.globl vector162
vector162:
  pushl $0
  102284:	6a 00                	push   $0x0
  pushl $162
  102286:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10228b:	e9 5c 04 00 00       	jmp    1026ec <__alltraps>

00102290 <vector163>:
.globl vector163
vector163:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $163
  102292:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102297:	e9 50 04 00 00       	jmp    1026ec <__alltraps>

0010229c <vector164>:
.globl vector164
vector164:
  pushl $0
  10229c:	6a 00                	push   $0x0
  pushl $164
  10229e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1022a3:	e9 44 04 00 00       	jmp    1026ec <__alltraps>

001022a8 <vector165>:
.globl vector165
vector165:
  pushl $0
  1022a8:	6a 00                	push   $0x0
  pushl $165
  1022aa:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1022af:	e9 38 04 00 00       	jmp    1026ec <__alltraps>

001022b4 <vector166>:
.globl vector166
vector166:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $166
  1022b6:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1022bb:	e9 2c 04 00 00       	jmp    1026ec <__alltraps>

001022c0 <vector167>:
.globl vector167
vector167:
  pushl $0
  1022c0:	6a 00                	push   $0x0
  pushl $167
  1022c2:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1022c7:	e9 20 04 00 00       	jmp    1026ec <__alltraps>

001022cc <vector168>:
.globl vector168
vector168:
  pushl $0
  1022cc:	6a 00                	push   $0x0
  pushl $168
  1022ce:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1022d3:	e9 14 04 00 00       	jmp    1026ec <__alltraps>

001022d8 <vector169>:
.globl vector169
vector169:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $169
  1022da:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1022df:	e9 08 04 00 00       	jmp    1026ec <__alltraps>

001022e4 <vector170>:
.globl vector170
vector170:
  pushl $0
  1022e4:	6a 00                	push   $0x0
  pushl $170
  1022e6:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1022eb:	e9 fc 03 00 00       	jmp    1026ec <__alltraps>

001022f0 <vector171>:
.globl vector171
vector171:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $171
  1022f2:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1022f7:	e9 f0 03 00 00       	jmp    1026ec <__alltraps>

001022fc <vector172>:
.globl vector172
vector172:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $172
  1022fe:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102303:	e9 e4 03 00 00       	jmp    1026ec <__alltraps>

00102308 <vector173>:
.globl vector173
vector173:
  pushl $0
  102308:	6a 00                	push   $0x0
  pushl $173
  10230a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10230f:	e9 d8 03 00 00       	jmp    1026ec <__alltraps>

00102314 <vector174>:
.globl vector174
vector174:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $174
  102316:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10231b:	e9 cc 03 00 00       	jmp    1026ec <__alltraps>

00102320 <vector175>:
.globl vector175
vector175:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $175
  102322:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102327:	e9 c0 03 00 00       	jmp    1026ec <__alltraps>

0010232c <vector176>:
.globl vector176
vector176:
  pushl $0
  10232c:	6a 00                	push   $0x0
  pushl $176
  10232e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102333:	e9 b4 03 00 00       	jmp    1026ec <__alltraps>

00102338 <vector177>:
.globl vector177
vector177:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $177
  10233a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10233f:	e9 a8 03 00 00       	jmp    1026ec <__alltraps>

00102344 <vector178>:
.globl vector178
vector178:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $178
  102346:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10234b:	e9 9c 03 00 00       	jmp    1026ec <__alltraps>

00102350 <vector179>:
.globl vector179
vector179:
  pushl $0
  102350:	6a 00                	push   $0x0
  pushl $179
  102352:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102357:	e9 90 03 00 00       	jmp    1026ec <__alltraps>

0010235c <vector180>:
.globl vector180
vector180:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $180
  10235e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102363:	e9 84 03 00 00       	jmp    1026ec <__alltraps>

00102368 <vector181>:
.globl vector181
vector181:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $181
  10236a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10236f:	e9 78 03 00 00       	jmp    1026ec <__alltraps>

00102374 <vector182>:
.globl vector182
vector182:
  pushl $0
  102374:	6a 00                	push   $0x0
  pushl $182
  102376:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10237b:	e9 6c 03 00 00       	jmp    1026ec <__alltraps>

00102380 <vector183>:
.globl vector183
vector183:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $183
  102382:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102387:	e9 60 03 00 00       	jmp    1026ec <__alltraps>

0010238c <vector184>:
.globl vector184
vector184:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $184
  10238e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102393:	e9 54 03 00 00       	jmp    1026ec <__alltraps>

00102398 <vector185>:
.globl vector185
vector185:
  pushl $0
  102398:	6a 00                	push   $0x0
  pushl $185
  10239a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10239f:	e9 48 03 00 00       	jmp    1026ec <__alltraps>

001023a4 <vector186>:
.globl vector186
vector186:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $186
  1023a6:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1023ab:	e9 3c 03 00 00       	jmp    1026ec <__alltraps>

001023b0 <vector187>:
.globl vector187
vector187:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $187
  1023b2:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1023b7:	e9 30 03 00 00       	jmp    1026ec <__alltraps>

001023bc <vector188>:
.globl vector188
vector188:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $188
  1023be:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1023c3:	e9 24 03 00 00       	jmp    1026ec <__alltraps>

001023c8 <vector189>:
.globl vector189
vector189:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $189
  1023ca:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1023cf:	e9 18 03 00 00       	jmp    1026ec <__alltraps>

001023d4 <vector190>:
.globl vector190
vector190:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $190
  1023d6:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1023db:	e9 0c 03 00 00       	jmp    1026ec <__alltraps>

001023e0 <vector191>:
.globl vector191
vector191:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $191
  1023e2:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1023e7:	e9 00 03 00 00       	jmp    1026ec <__alltraps>

001023ec <vector192>:
.globl vector192
vector192:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $192
  1023ee:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1023f3:	e9 f4 02 00 00       	jmp    1026ec <__alltraps>

001023f8 <vector193>:
.globl vector193
vector193:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $193
  1023fa:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1023ff:	e9 e8 02 00 00       	jmp    1026ec <__alltraps>

00102404 <vector194>:
.globl vector194
vector194:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $194
  102406:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10240b:	e9 dc 02 00 00       	jmp    1026ec <__alltraps>

00102410 <vector195>:
.globl vector195
vector195:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $195
  102412:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102417:	e9 d0 02 00 00       	jmp    1026ec <__alltraps>

0010241c <vector196>:
.globl vector196
vector196:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $196
  10241e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102423:	e9 c4 02 00 00       	jmp    1026ec <__alltraps>

00102428 <vector197>:
.globl vector197
vector197:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $197
  10242a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10242f:	e9 b8 02 00 00       	jmp    1026ec <__alltraps>

00102434 <vector198>:
.globl vector198
vector198:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $198
  102436:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10243b:	e9 ac 02 00 00       	jmp    1026ec <__alltraps>

00102440 <vector199>:
.globl vector199
vector199:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $199
  102442:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102447:	e9 a0 02 00 00       	jmp    1026ec <__alltraps>

0010244c <vector200>:
.globl vector200
vector200:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $200
  10244e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102453:	e9 94 02 00 00       	jmp    1026ec <__alltraps>

00102458 <vector201>:
.globl vector201
vector201:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $201
  10245a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10245f:	e9 88 02 00 00       	jmp    1026ec <__alltraps>

00102464 <vector202>:
.globl vector202
vector202:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $202
  102466:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10246b:	e9 7c 02 00 00       	jmp    1026ec <__alltraps>

00102470 <vector203>:
.globl vector203
vector203:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $203
  102472:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102477:	e9 70 02 00 00       	jmp    1026ec <__alltraps>

0010247c <vector204>:
.globl vector204
vector204:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $204
  10247e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102483:	e9 64 02 00 00       	jmp    1026ec <__alltraps>

00102488 <vector205>:
.globl vector205
vector205:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $205
  10248a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10248f:	e9 58 02 00 00       	jmp    1026ec <__alltraps>

00102494 <vector206>:
.globl vector206
vector206:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $206
  102496:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10249b:	e9 4c 02 00 00       	jmp    1026ec <__alltraps>

001024a0 <vector207>:
.globl vector207
vector207:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $207
  1024a2:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1024a7:	e9 40 02 00 00       	jmp    1026ec <__alltraps>

001024ac <vector208>:
.globl vector208
vector208:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $208
  1024ae:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1024b3:	e9 34 02 00 00       	jmp    1026ec <__alltraps>

001024b8 <vector209>:
.globl vector209
vector209:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $209
  1024ba:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1024bf:	e9 28 02 00 00       	jmp    1026ec <__alltraps>

001024c4 <vector210>:
.globl vector210
vector210:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $210
  1024c6:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1024cb:	e9 1c 02 00 00       	jmp    1026ec <__alltraps>

001024d0 <vector211>:
.globl vector211
vector211:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $211
  1024d2:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1024d7:	e9 10 02 00 00       	jmp    1026ec <__alltraps>

001024dc <vector212>:
.globl vector212
vector212:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $212
  1024de:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1024e3:	e9 04 02 00 00       	jmp    1026ec <__alltraps>

001024e8 <vector213>:
.globl vector213
vector213:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $213
  1024ea:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1024ef:	e9 f8 01 00 00       	jmp    1026ec <__alltraps>

001024f4 <vector214>:
.globl vector214
vector214:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $214
  1024f6:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1024fb:	e9 ec 01 00 00       	jmp    1026ec <__alltraps>

00102500 <vector215>:
.globl vector215
vector215:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $215
  102502:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102507:	e9 e0 01 00 00       	jmp    1026ec <__alltraps>

0010250c <vector216>:
.globl vector216
vector216:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $216
  10250e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102513:	e9 d4 01 00 00       	jmp    1026ec <__alltraps>

00102518 <vector217>:
.globl vector217
vector217:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $217
  10251a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10251f:	e9 c8 01 00 00       	jmp    1026ec <__alltraps>

00102524 <vector218>:
.globl vector218
vector218:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $218
  102526:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10252b:	e9 bc 01 00 00       	jmp    1026ec <__alltraps>

00102530 <vector219>:
.globl vector219
vector219:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $219
  102532:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102537:	e9 b0 01 00 00       	jmp    1026ec <__alltraps>

0010253c <vector220>:
.globl vector220
vector220:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $220
  10253e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102543:	e9 a4 01 00 00       	jmp    1026ec <__alltraps>

00102548 <vector221>:
.globl vector221
vector221:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $221
  10254a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10254f:	e9 98 01 00 00       	jmp    1026ec <__alltraps>

00102554 <vector222>:
.globl vector222
vector222:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $222
  102556:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10255b:	e9 8c 01 00 00       	jmp    1026ec <__alltraps>

00102560 <vector223>:
.globl vector223
vector223:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $223
  102562:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102567:	e9 80 01 00 00       	jmp    1026ec <__alltraps>

0010256c <vector224>:
.globl vector224
vector224:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $224
  10256e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102573:	e9 74 01 00 00       	jmp    1026ec <__alltraps>

00102578 <vector225>:
.globl vector225
vector225:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $225
  10257a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10257f:	e9 68 01 00 00       	jmp    1026ec <__alltraps>

00102584 <vector226>:
.globl vector226
vector226:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $226
  102586:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10258b:	e9 5c 01 00 00       	jmp    1026ec <__alltraps>

00102590 <vector227>:
.globl vector227
vector227:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $227
  102592:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102597:	e9 50 01 00 00       	jmp    1026ec <__alltraps>

0010259c <vector228>:
.globl vector228
vector228:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $228
  10259e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1025a3:	e9 44 01 00 00       	jmp    1026ec <__alltraps>

001025a8 <vector229>:
.globl vector229
vector229:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $229
  1025aa:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1025af:	e9 38 01 00 00       	jmp    1026ec <__alltraps>

001025b4 <vector230>:
.globl vector230
vector230:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $230
  1025b6:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1025bb:	e9 2c 01 00 00       	jmp    1026ec <__alltraps>

001025c0 <vector231>:
.globl vector231
vector231:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $231
  1025c2:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1025c7:	e9 20 01 00 00       	jmp    1026ec <__alltraps>

001025cc <vector232>:
.globl vector232
vector232:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $232
  1025ce:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1025d3:	e9 14 01 00 00       	jmp    1026ec <__alltraps>

001025d8 <vector233>:
.globl vector233
vector233:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $233
  1025da:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1025df:	e9 08 01 00 00       	jmp    1026ec <__alltraps>

001025e4 <vector234>:
.globl vector234
vector234:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $234
  1025e6:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1025eb:	e9 fc 00 00 00       	jmp    1026ec <__alltraps>

001025f0 <vector235>:
.globl vector235
vector235:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $235
  1025f2:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1025f7:	e9 f0 00 00 00       	jmp    1026ec <__alltraps>

001025fc <vector236>:
.globl vector236
vector236:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $236
  1025fe:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102603:	e9 e4 00 00 00       	jmp    1026ec <__alltraps>

00102608 <vector237>:
.globl vector237
vector237:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $237
  10260a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10260f:	e9 d8 00 00 00       	jmp    1026ec <__alltraps>

00102614 <vector238>:
.globl vector238
vector238:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $238
  102616:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10261b:	e9 cc 00 00 00       	jmp    1026ec <__alltraps>

00102620 <vector239>:
.globl vector239
vector239:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $239
  102622:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102627:	e9 c0 00 00 00       	jmp    1026ec <__alltraps>

0010262c <vector240>:
.globl vector240
vector240:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $240
  10262e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102633:	e9 b4 00 00 00       	jmp    1026ec <__alltraps>

00102638 <vector241>:
.globl vector241
vector241:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $241
  10263a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10263f:	e9 a8 00 00 00       	jmp    1026ec <__alltraps>

00102644 <vector242>:
.globl vector242
vector242:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $242
  102646:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10264b:	e9 9c 00 00 00       	jmp    1026ec <__alltraps>

00102650 <vector243>:
.globl vector243
vector243:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $243
  102652:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102657:	e9 90 00 00 00       	jmp    1026ec <__alltraps>

0010265c <vector244>:
.globl vector244
vector244:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $244
  10265e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102663:	e9 84 00 00 00       	jmp    1026ec <__alltraps>

00102668 <vector245>:
.globl vector245
vector245:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $245
  10266a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10266f:	e9 78 00 00 00       	jmp    1026ec <__alltraps>

00102674 <vector246>:
.globl vector246
vector246:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $246
  102676:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10267b:	e9 6c 00 00 00       	jmp    1026ec <__alltraps>

00102680 <vector247>:
.globl vector247
vector247:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $247
  102682:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102687:	e9 60 00 00 00       	jmp    1026ec <__alltraps>

0010268c <vector248>:
.globl vector248
vector248:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $248
  10268e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102693:	e9 54 00 00 00       	jmp    1026ec <__alltraps>

00102698 <vector249>:
.globl vector249
vector249:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $249
  10269a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10269f:	e9 48 00 00 00       	jmp    1026ec <__alltraps>

001026a4 <vector250>:
.globl vector250
vector250:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $250
  1026a6:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1026ab:	e9 3c 00 00 00       	jmp    1026ec <__alltraps>

001026b0 <vector251>:
.globl vector251
vector251:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $251
  1026b2:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1026b7:	e9 30 00 00 00       	jmp    1026ec <__alltraps>

001026bc <vector252>:
.globl vector252
vector252:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $252
  1026be:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1026c3:	e9 24 00 00 00       	jmp    1026ec <__alltraps>

001026c8 <vector253>:
.globl vector253
vector253:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $253
  1026ca:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1026cf:	e9 18 00 00 00       	jmp    1026ec <__alltraps>

001026d4 <vector254>:
.globl vector254
vector254:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $254
  1026d6:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1026db:	e9 0c 00 00 00       	jmp    1026ec <__alltraps>

001026e0 <vector255>:
.globl vector255
vector255:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $255
  1026e2:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1026e7:	e9 00 00 00 00       	jmp    1026ec <__alltraps>

001026ec <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1026ec:	1e                   	push   %ds
    pushl %es
  1026ed:	06                   	push   %es
    pushl %fs
  1026ee:	0f a0                	push   %fs
    pushl %gs
  1026f0:	0f a8                	push   %gs
    pushal
  1026f2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1026f3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1026f8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1026fa:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1026fc:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1026fd:	e8 64 f5 ff ff       	call   101c66 <trap>

    # pop the pushed stack pointer
    popl %esp
  102702:	5c                   	pop    %esp

00102703 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102703:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102704:	0f a9                	pop    %gs
    popl %fs
  102706:	0f a1                	pop    %fs
    popl %es
  102708:	07                   	pop    %es
    popl %ds
  102709:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10270a:	83 c4 08             	add    $0x8,%esp
    iret
  10270d:	cf                   	iret   

0010270e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10270e:	55                   	push   %ebp
  10270f:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102711:	8b 45 08             	mov    0x8(%ebp),%eax
  102714:	8b 15 18 af 11 00    	mov    0x11af18,%edx
  10271a:	29 d0                	sub    %edx,%eax
  10271c:	c1 f8 02             	sar    $0x2,%eax
  10271f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102725:	5d                   	pop    %ebp
  102726:	c3                   	ret    

00102727 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102727:	55                   	push   %ebp
  102728:	89 e5                	mov    %esp,%ebp
  10272a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10272d:	8b 45 08             	mov    0x8(%ebp),%eax
  102730:	89 04 24             	mov    %eax,(%esp)
  102733:	e8 d6 ff ff ff       	call   10270e <page2ppn>
  102738:	c1 e0 0c             	shl    $0xc,%eax
}
  10273b:	c9                   	leave  
  10273c:	c3                   	ret    

0010273d <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  10273d:	55                   	push   %ebp
  10273e:	89 e5                	mov    %esp,%ebp
  102740:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  102743:	8b 45 08             	mov    0x8(%ebp),%eax
  102746:	c1 e8 0c             	shr    $0xc,%eax
  102749:	89 c2                	mov    %eax,%edx
  10274b:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  102750:	39 c2                	cmp    %eax,%edx
  102752:	72 1c                	jb     102770 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102754:	c7 44 24 08 10 63 10 	movl   $0x106310,0x8(%esp)
  10275b:	00 
  10275c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102763:	00 
  102764:	c7 04 24 2f 63 10 00 	movl   $0x10632f,(%esp)
  10276b:	e8 74 dc ff ff       	call   1003e4 <__panic>
    }
    return &pages[PPN(pa)];
  102770:	8b 0d 18 af 11 00    	mov    0x11af18,%ecx
  102776:	8b 45 08             	mov    0x8(%ebp),%eax
  102779:	c1 e8 0c             	shr    $0xc,%eax
  10277c:	89 c2                	mov    %eax,%edx
  10277e:	89 d0                	mov    %edx,%eax
  102780:	c1 e0 02             	shl    $0x2,%eax
  102783:	01 d0                	add    %edx,%eax
  102785:	c1 e0 02             	shl    $0x2,%eax
  102788:	01 c8                	add    %ecx,%eax
}
  10278a:	c9                   	leave  
  10278b:	c3                   	ret    

0010278c <page2kva>:

static inline void *
page2kva(struct Page *page) {
  10278c:	55                   	push   %ebp
  10278d:	89 e5                	mov    %esp,%ebp
  10278f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102792:	8b 45 08             	mov    0x8(%ebp),%eax
  102795:	89 04 24             	mov    %eax,(%esp)
  102798:	e8 8a ff ff ff       	call   102727 <page2pa>
  10279d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1027a3:	c1 e8 0c             	shr    $0xc,%eax
  1027a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1027a9:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1027ae:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1027b1:	72 23                	jb     1027d6 <page2kva+0x4a>
  1027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1027b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1027ba:	c7 44 24 08 40 63 10 	movl   $0x106340,0x8(%esp)
  1027c1:	00 
  1027c2:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  1027c9:	00 
  1027ca:	c7 04 24 2f 63 10 00 	movl   $0x10632f,(%esp)
  1027d1:	e8 0e dc ff ff       	call   1003e4 <__panic>
  1027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1027d9:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  1027de:	c9                   	leave  
  1027df:	c3                   	ret    

001027e0 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  1027e0:	55                   	push   %ebp
  1027e1:	89 e5                	mov    %esp,%ebp
  1027e3:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  1027e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1027e9:	83 e0 01             	and    $0x1,%eax
  1027ec:	85 c0                	test   %eax,%eax
  1027ee:	75 1c                	jne    10280c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  1027f0:	c7 44 24 08 64 63 10 	movl   $0x106364,0x8(%esp)
  1027f7:	00 
  1027f8:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  1027ff:	00 
  102800:	c7 04 24 2f 63 10 00 	movl   $0x10632f,(%esp)
  102807:	e8 d8 db ff ff       	call   1003e4 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  10280c:	8b 45 08             	mov    0x8(%ebp),%eax
  10280f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102814:	89 04 24             	mov    %eax,(%esp)
  102817:	e8 21 ff ff ff       	call   10273d <pa2page>
}
  10281c:	c9                   	leave  
  10281d:	c3                   	ret    

0010281e <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  10281e:	55                   	push   %ebp
  10281f:	89 e5                	mov    %esp,%ebp
  102821:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102824:	8b 45 08             	mov    0x8(%ebp),%eax
  102827:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10282c:	89 04 24             	mov    %eax,(%esp)
  10282f:	e8 09 ff ff ff       	call   10273d <pa2page>
}
  102834:	c9                   	leave  
  102835:	c3                   	ret    

00102836 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102836:	55                   	push   %ebp
  102837:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102839:	8b 45 08             	mov    0x8(%ebp),%eax
  10283c:	8b 00                	mov    (%eax),%eax
}
  10283e:	5d                   	pop    %ebp
  10283f:	c3                   	ret    

00102840 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  102840:	55                   	push   %ebp
  102841:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102843:	8b 45 08             	mov    0x8(%ebp),%eax
  102846:	8b 00                	mov    (%eax),%eax
  102848:	8d 50 01             	lea    0x1(%eax),%edx
  10284b:	8b 45 08             	mov    0x8(%ebp),%eax
  10284e:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102850:	8b 45 08             	mov    0x8(%ebp),%eax
  102853:	8b 00                	mov    (%eax),%eax
}
  102855:	5d                   	pop    %ebp
  102856:	c3                   	ret    

00102857 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102857:	55                   	push   %ebp
  102858:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  10285a:	8b 45 08             	mov    0x8(%ebp),%eax
  10285d:	8b 00                	mov    (%eax),%eax
  10285f:	8d 50 ff             	lea    -0x1(%eax),%edx
  102862:	8b 45 08             	mov    0x8(%ebp),%eax
  102865:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102867:	8b 45 08             	mov    0x8(%ebp),%eax
  10286a:	8b 00                	mov    (%eax),%eax
}
  10286c:	5d                   	pop    %ebp
  10286d:	c3                   	ret    

0010286e <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  10286e:	55                   	push   %ebp
  10286f:	89 e5                	mov    %esp,%ebp
  102871:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102874:	9c                   	pushf  
  102875:	58                   	pop    %eax
  102876:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102879:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  10287c:	25 00 02 00 00       	and    $0x200,%eax
  102881:	85 c0                	test   %eax,%eax
  102883:	74 0c                	je     102891 <__intr_save+0x23>
        intr_disable();
  102885:	e8 34 ef ff ff       	call   1017be <intr_disable>
        return 1;
  10288a:	b8 01 00 00 00       	mov    $0x1,%eax
  10288f:	eb 05                	jmp    102896 <__intr_save+0x28>
    }
    return 0;
  102891:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102896:	c9                   	leave  
  102897:	c3                   	ret    

00102898 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  102898:	55                   	push   %ebp
  102899:	89 e5                	mov    %esp,%ebp
  10289b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  10289e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1028a2:	74 05                	je     1028a9 <__intr_restore+0x11>
        intr_enable();
  1028a4:	e8 0e ef ff ff       	call   1017b7 <intr_enable>
    }
}
  1028a9:	90                   	nop
  1028aa:	c9                   	leave  
  1028ab:	c3                   	ret    

001028ac <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1028ac:	55                   	push   %ebp
  1028ad:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1028af:	8b 45 08             	mov    0x8(%ebp),%eax
  1028b2:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1028b5:	b8 23 00 00 00       	mov    $0x23,%eax
  1028ba:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1028bc:	b8 23 00 00 00       	mov    $0x23,%eax
  1028c1:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1028c3:	b8 10 00 00 00       	mov    $0x10,%eax
  1028c8:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1028ca:	b8 10 00 00 00       	mov    $0x10,%eax
  1028cf:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1028d1:	b8 10 00 00 00       	mov    $0x10,%eax
  1028d6:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1028d8:	ea df 28 10 00 08 00 	ljmp   $0x8,$0x1028df
}
  1028df:	90                   	nop
  1028e0:	5d                   	pop    %ebp
  1028e1:	c3                   	ret    

001028e2 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  1028e2:	55                   	push   %ebp
  1028e3:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  1028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1028e8:	a3 a4 ae 11 00       	mov    %eax,0x11aea4
}
  1028ed:	90                   	nop
  1028ee:	5d                   	pop    %ebp
  1028ef:	c3                   	ret    

001028f0 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1028f0:	55                   	push   %ebp
  1028f1:	89 e5                	mov    %esp,%ebp
  1028f3:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  1028f6:	b8 00 70 11 00       	mov    $0x117000,%eax
  1028fb:	89 04 24             	mov    %eax,(%esp)
  1028fe:	e8 df ff ff ff       	call   1028e2 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102903:	66 c7 05 a8 ae 11 00 	movw   $0x10,0x11aea8
  10290a:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  10290c:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102913:	68 00 
  102915:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  10291a:	0f b7 c0             	movzwl %ax,%eax
  10291d:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102923:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  102928:	c1 e8 10             	shr    $0x10,%eax
  10292b:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102930:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102937:	24 f0                	and    $0xf0,%al
  102939:	0c 09                	or     $0x9,%al
  10293b:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102940:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102947:	24 ef                	and    $0xef,%al
  102949:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  10294e:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102955:	24 9f                	and    $0x9f,%al
  102957:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  10295c:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102963:	0c 80                	or     $0x80,%al
  102965:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  10296a:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102971:	24 f0                	and    $0xf0,%al
  102973:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102978:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  10297f:	24 ef                	and    $0xef,%al
  102981:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102986:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  10298d:	24 df                	and    $0xdf,%al
  10298f:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102994:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  10299b:	0c 40                	or     $0x40,%al
  10299d:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  1029a2:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  1029a9:	24 7f                	and    $0x7f,%al
  1029ab:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  1029b0:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  1029b5:	c1 e8 18             	shr    $0x18,%eax
  1029b8:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  1029bd:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  1029c4:	e8 e3 fe ff ff       	call   1028ac <lgdt>
  1029c9:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  1029cf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1029d3:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1029d6:	90                   	nop
  1029d7:	c9                   	leave  
  1029d8:	c3                   	ret    

001029d9 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  1029d9:	55                   	push   %ebp
  1029da:	89 e5                	mov    %esp,%ebp
  1029dc:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  1029df:	c7 05 10 af 11 00 20 	movl   $0x106d20,0x11af10
  1029e6:	6d 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  1029e9:	a1 10 af 11 00       	mov    0x11af10,%eax
  1029ee:	8b 00                	mov    (%eax),%eax
  1029f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1029f4:	c7 04 24 90 63 10 00 	movl   $0x106390,(%esp)
  1029fb:	e8 8d d8 ff ff       	call   10028d <cprintf>
    pmm_manager->init();
  102a00:	a1 10 af 11 00       	mov    0x11af10,%eax
  102a05:	8b 40 04             	mov    0x4(%eax),%eax
  102a08:	ff d0                	call   *%eax
}
  102a0a:	90                   	nop
  102a0b:	c9                   	leave  
  102a0c:	c3                   	ret    

00102a0d <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102a0d:	55                   	push   %ebp
  102a0e:	89 e5                	mov    %esp,%ebp
  102a10:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102a13:	a1 10 af 11 00       	mov    0x11af10,%eax
  102a18:	8b 40 08             	mov    0x8(%eax),%eax
  102a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a1e:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a22:	8b 55 08             	mov    0x8(%ebp),%edx
  102a25:	89 14 24             	mov    %edx,(%esp)
  102a28:	ff d0                	call   *%eax
}
  102a2a:	90                   	nop
  102a2b:	c9                   	leave  
  102a2c:	c3                   	ret    

00102a2d <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102a2d:	55                   	push   %ebp
  102a2e:	89 e5                	mov    %esp,%ebp
  102a30:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102a33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102a3a:	e8 2f fe ff ff       	call   10286e <__intr_save>
  102a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102a42:	a1 10 af 11 00       	mov    0x11af10,%eax
  102a47:	8b 40 0c             	mov    0xc(%eax),%eax
  102a4a:	8b 55 08             	mov    0x8(%ebp),%edx
  102a4d:	89 14 24             	mov    %edx,(%esp)
  102a50:	ff d0                	call   *%eax
  102a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102a55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a58:	89 04 24             	mov    %eax,(%esp)
  102a5b:	e8 38 fe ff ff       	call   102898 <__intr_restore>
    return page;
  102a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102a63:	c9                   	leave  
  102a64:	c3                   	ret    

00102a65 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102a65:	55                   	push   %ebp
  102a66:	89 e5                	mov    %esp,%ebp
  102a68:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102a6b:	e8 fe fd ff ff       	call   10286e <__intr_save>
  102a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102a73:	a1 10 af 11 00       	mov    0x11af10,%eax
  102a78:	8b 40 10             	mov    0x10(%eax),%eax
  102a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a7e:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a82:	8b 55 08             	mov    0x8(%ebp),%edx
  102a85:	89 14 24             	mov    %edx,(%esp)
  102a88:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a8d:	89 04 24             	mov    %eax,(%esp)
  102a90:	e8 03 fe ff ff       	call   102898 <__intr_restore>
}
  102a95:	90                   	nop
  102a96:	c9                   	leave  
  102a97:	c3                   	ret    

00102a98 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102a98:	55                   	push   %ebp
  102a99:	89 e5                	mov    %esp,%ebp
  102a9b:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102a9e:	e8 cb fd ff ff       	call   10286e <__intr_save>
  102aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102aa6:	a1 10 af 11 00       	mov    0x11af10,%eax
  102aab:	8b 40 14             	mov    0x14(%eax),%eax
  102aae:	ff d0                	call   *%eax
  102ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ab6:	89 04 24             	mov    %eax,(%esp)
  102ab9:	e8 da fd ff ff       	call   102898 <__intr_restore>
    return ret;
  102abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102ac1:	c9                   	leave  
  102ac2:	c3                   	ret    

00102ac3 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102ac3:	55                   	push   %ebp
  102ac4:	89 e5                	mov    %esp,%ebp
  102ac6:	57                   	push   %edi
  102ac7:	56                   	push   %esi
  102ac8:	53                   	push   %ebx
  102ac9:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102acf:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102ad6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102add:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102ae4:	c7 04 24 a7 63 10 00 	movl   $0x1063a7,(%esp)
  102aeb:	e8 9d d7 ff ff       	call   10028d <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102af0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102af7:	e9 22 01 00 00       	jmp    102c1e <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102afc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102aff:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b02:	89 d0                	mov    %edx,%eax
  102b04:	c1 e0 02             	shl    $0x2,%eax
  102b07:	01 d0                	add    %edx,%eax
  102b09:	c1 e0 02             	shl    $0x2,%eax
  102b0c:	01 c8                	add    %ecx,%eax
  102b0e:	8b 50 08             	mov    0x8(%eax),%edx
  102b11:	8b 40 04             	mov    0x4(%eax),%eax
  102b14:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102b17:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102b1a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102b1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b20:	89 d0                	mov    %edx,%eax
  102b22:	c1 e0 02             	shl    $0x2,%eax
  102b25:	01 d0                	add    %edx,%eax
  102b27:	c1 e0 02             	shl    $0x2,%eax
  102b2a:	01 c8                	add    %ecx,%eax
  102b2c:	8b 48 0c             	mov    0xc(%eax),%ecx
  102b2f:	8b 58 10             	mov    0x10(%eax),%ebx
  102b32:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102b35:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102b38:	01 c8                	add    %ecx,%eax
  102b3a:	11 da                	adc    %ebx,%edx
  102b3c:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102b3f:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102b42:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102b45:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b48:	89 d0                	mov    %edx,%eax
  102b4a:	c1 e0 02             	shl    $0x2,%eax
  102b4d:	01 d0                	add    %edx,%eax
  102b4f:	c1 e0 02             	shl    $0x2,%eax
  102b52:	01 c8                	add    %ecx,%eax
  102b54:	83 c0 14             	add    $0x14,%eax
  102b57:	8b 00                	mov    (%eax),%eax
  102b59:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102b5c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102b5f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102b62:	83 c0 ff             	add    $0xffffffff,%eax
  102b65:	83 d2 ff             	adc    $0xffffffff,%edx
  102b68:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  102b6e:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102b74:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102b77:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b7a:	89 d0                	mov    %edx,%eax
  102b7c:	c1 e0 02             	shl    $0x2,%eax
  102b7f:	01 d0                	add    %edx,%eax
  102b81:	c1 e0 02             	shl    $0x2,%eax
  102b84:	01 c8                	add    %ecx,%eax
  102b86:	8b 48 0c             	mov    0xc(%eax),%ecx
  102b89:	8b 58 10             	mov    0x10(%eax),%ebx
  102b8c:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102b8f:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  102b93:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102b99:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102b9f:	89 44 24 14          	mov    %eax,0x14(%esp)
  102ba3:	89 54 24 18          	mov    %edx,0x18(%esp)
  102ba7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102baa:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102bad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102bb1:	89 54 24 10          	mov    %edx,0x10(%esp)
  102bb5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102bb9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102bbd:	c7 04 24 b4 63 10 00 	movl   $0x1063b4,(%esp)
  102bc4:	e8 c4 d6 ff ff       	call   10028d <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102bc9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102bcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102bcf:	89 d0                	mov    %edx,%eax
  102bd1:	c1 e0 02             	shl    $0x2,%eax
  102bd4:	01 d0                	add    %edx,%eax
  102bd6:	c1 e0 02             	shl    $0x2,%eax
  102bd9:	01 c8                	add    %ecx,%eax
  102bdb:	83 c0 14             	add    $0x14,%eax
  102bde:	8b 00                	mov    (%eax),%eax
  102be0:	83 f8 01             	cmp    $0x1,%eax
  102be3:	75 36                	jne    102c1b <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
  102be5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102be8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102beb:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102bee:	77 2b                	ja     102c1b <page_init+0x158>
  102bf0:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102bf3:	72 05                	jb     102bfa <page_init+0x137>
  102bf5:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102bf8:	73 21                	jae    102c1b <page_init+0x158>
  102bfa:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102bfe:	77 1b                	ja     102c1b <page_init+0x158>
  102c00:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102c04:	72 09                	jb     102c0f <page_init+0x14c>
  102c06:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102c0d:	77 0c                	ja     102c1b <page_init+0x158>
                maxpa = end;
  102c0f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102c12:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102c15:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c18:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102c1b:	ff 45 dc             	incl   -0x24(%ebp)
  102c1e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c21:	8b 00                	mov    (%eax),%eax
  102c23:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102c26:	0f 8f d0 fe ff ff    	jg     102afc <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102c2c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c30:	72 1d                	jb     102c4f <page_init+0x18c>
  102c32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c36:	77 09                	ja     102c41 <page_init+0x17e>
  102c38:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102c3f:	76 0e                	jbe    102c4f <page_init+0x18c>
        maxpa = KMEMSIZE;
  102c41:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102c48:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102c4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102c55:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102c59:	c1 ea 0c             	shr    $0xc,%edx
  102c5c:	a3 80 ae 11 00       	mov    %eax,0x11ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102c61:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102c68:	b8 28 af 11 00       	mov    $0x11af28,%eax
  102c6d:	8d 50 ff             	lea    -0x1(%eax),%edx
  102c70:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102c73:	01 d0                	add    %edx,%eax
  102c75:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102c78:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102c7b:	ba 00 00 00 00       	mov    $0x0,%edx
  102c80:	f7 75 ac             	divl   -0x54(%ebp)
  102c83:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102c86:	29 d0                	sub    %edx,%eax
  102c88:	a3 18 af 11 00       	mov    %eax,0x11af18

    for (i = 0; i < npage; i ++) {
  102c8d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102c94:	eb 2e                	jmp    102cc4 <page_init+0x201>
        SetPageReserved(pages + i);
  102c96:	8b 0d 18 af 11 00    	mov    0x11af18,%ecx
  102c9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c9f:	89 d0                	mov    %edx,%eax
  102ca1:	c1 e0 02             	shl    $0x2,%eax
  102ca4:	01 d0                	add    %edx,%eax
  102ca6:	c1 e0 02             	shl    $0x2,%eax
  102ca9:	01 c8                	add    %ecx,%eax
  102cab:	83 c0 04             	add    $0x4,%eax
  102cae:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102cb5:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cb8:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102cbb:	8b 55 90             	mov    -0x70(%ebp),%edx
  102cbe:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  102cc1:	ff 45 dc             	incl   -0x24(%ebp)
  102cc4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102cc7:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  102ccc:	39 c2                	cmp    %eax,%edx
  102cce:	72 c6                	jb     102c96 <page_init+0x1d3>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102cd0:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  102cd6:	89 d0                	mov    %edx,%eax
  102cd8:	c1 e0 02             	shl    $0x2,%eax
  102cdb:	01 d0                	add    %edx,%eax
  102cdd:	c1 e0 02             	shl    $0x2,%eax
  102ce0:	89 c2                	mov    %eax,%edx
  102ce2:	a1 18 af 11 00       	mov    0x11af18,%eax
  102ce7:	01 d0                	add    %edx,%eax
  102ce9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102cec:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  102cf3:	77 23                	ja     102d18 <page_init+0x255>
  102cf5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102cf8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102cfc:	c7 44 24 08 e4 63 10 	movl   $0x1063e4,0x8(%esp)
  102d03:	00 
  102d04:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  102d0b:	00 
  102d0c:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  102d13:	e8 cc d6 ff ff       	call   1003e4 <__panic>
  102d18:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102d1b:	05 00 00 00 40       	add    $0x40000000,%eax
  102d20:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102d23:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d2a:	e9 61 01 00 00       	jmp    102e90 <page_init+0x3cd>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102d2f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d32:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d35:	89 d0                	mov    %edx,%eax
  102d37:	c1 e0 02             	shl    $0x2,%eax
  102d3a:	01 d0                	add    %edx,%eax
  102d3c:	c1 e0 02             	shl    $0x2,%eax
  102d3f:	01 c8                	add    %ecx,%eax
  102d41:	8b 50 08             	mov    0x8(%eax),%edx
  102d44:	8b 40 04             	mov    0x4(%eax),%eax
  102d47:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102d4a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102d4d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d50:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d53:	89 d0                	mov    %edx,%eax
  102d55:	c1 e0 02             	shl    $0x2,%eax
  102d58:	01 d0                	add    %edx,%eax
  102d5a:	c1 e0 02             	shl    $0x2,%eax
  102d5d:	01 c8                	add    %ecx,%eax
  102d5f:	8b 48 0c             	mov    0xc(%eax),%ecx
  102d62:	8b 58 10             	mov    0x10(%eax),%ebx
  102d65:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d68:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102d6b:	01 c8                	add    %ecx,%eax
  102d6d:	11 da                	adc    %ebx,%edx
  102d6f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102d72:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102d75:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d78:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d7b:	89 d0                	mov    %edx,%eax
  102d7d:	c1 e0 02             	shl    $0x2,%eax
  102d80:	01 d0                	add    %edx,%eax
  102d82:	c1 e0 02             	shl    $0x2,%eax
  102d85:	01 c8                	add    %ecx,%eax
  102d87:	83 c0 14             	add    $0x14,%eax
  102d8a:	8b 00                	mov    (%eax),%eax
  102d8c:	83 f8 01             	cmp    $0x1,%eax
  102d8f:	0f 85 f8 00 00 00    	jne    102e8d <page_init+0x3ca>
            if (begin < freemem) {
  102d95:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102d98:	ba 00 00 00 00       	mov    $0x0,%edx
  102d9d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102da0:	72 17                	jb     102db9 <page_init+0x2f6>
  102da2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102da5:	77 05                	ja     102dac <page_init+0x2e9>
  102da7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102daa:	76 0d                	jbe    102db9 <page_init+0x2f6>
                begin = freemem;
  102dac:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102daf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102db2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  102db9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102dbd:	72 1d                	jb     102ddc <page_init+0x319>
  102dbf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102dc3:	77 09                	ja     102dce <page_init+0x30b>
  102dc5:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  102dcc:	76 0e                	jbe    102ddc <page_init+0x319>
                end = KMEMSIZE;
  102dce:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  102dd5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  102ddc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ddf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102de2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102de5:	0f 87 a2 00 00 00    	ja     102e8d <page_init+0x3ca>
  102deb:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102dee:	72 09                	jb     102df9 <page_init+0x336>
  102df0:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102df3:	0f 83 94 00 00 00    	jae    102e8d <page_init+0x3ca>
                begin = ROUNDUP(begin, PGSIZE);
  102df9:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  102e00:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102e03:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102e06:	01 d0                	add    %edx,%eax
  102e08:	48                   	dec    %eax
  102e09:	89 45 98             	mov    %eax,-0x68(%ebp)
  102e0c:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e0f:	ba 00 00 00 00       	mov    $0x0,%edx
  102e14:	f7 75 9c             	divl   -0x64(%ebp)
  102e17:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e1a:	29 d0                	sub    %edx,%eax
  102e1c:	ba 00 00 00 00       	mov    $0x0,%edx
  102e21:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102e24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  102e27:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102e2a:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102e2d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102e30:	ba 00 00 00 00       	mov    $0x0,%edx
  102e35:	89 c3                	mov    %eax,%ebx
  102e37:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  102e3d:	89 de                	mov    %ebx,%esi
  102e3f:	89 d0                	mov    %edx,%eax
  102e41:	83 e0 00             	and    $0x0,%eax
  102e44:	89 c7                	mov    %eax,%edi
  102e46:	89 75 c8             	mov    %esi,-0x38(%ebp)
  102e49:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  102e4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102e4f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102e52:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102e55:	77 36                	ja     102e8d <page_init+0x3ca>
  102e57:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102e5a:	72 05                	jb     102e61 <page_init+0x39e>
  102e5c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102e5f:	73 2c                	jae    102e8d <page_init+0x3ca>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  102e61:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102e64:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102e67:	2b 45 d0             	sub    -0x30(%ebp),%eax
  102e6a:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  102e6d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102e71:	c1 ea 0c             	shr    $0xc,%edx
  102e74:	89 c3                	mov    %eax,%ebx
  102e76:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102e79:	89 04 24             	mov    %eax,(%esp)
  102e7c:	e8 bc f8 ff ff       	call   10273d <pa2page>
  102e81:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102e85:	89 04 24             	mov    %eax,(%esp)
  102e88:	e8 80 fb ff ff       	call   102a0d <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  102e8d:	ff 45 dc             	incl   -0x24(%ebp)
  102e90:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102e93:	8b 00                	mov    (%eax),%eax
  102e95:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102e98:	0f 8f 91 fe ff ff    	jg     102d2f <page_init+0x26c>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  102e9e:	90                   	nop
  102e9f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  102ea5:	5b                   	pop    %ebx
  102ea6:	5e                   	pop    %esi
  102ea7:	5f                   	pop    %edi
  102ea8:	5d                   	pop    %ebp
  102ea9:	c3                   	ret    

00102eaa <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  102eaa:	55                   	push   %ebp
  102eab:	89 e5                	mov    %esp,%ebp
  102ead:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  102eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eb3:	33 45 14             	xor    0x14(%ebp),%eax
  102eb6:	25 ff 0f 00 00       	and    $0xfff,%eax
  102ebb:	85 c0                	test   %eax,%eax
  102ebd:	74 24                	je     102ee3 <boot_map_segment+0x39>
  102ebf:	c7 44 24 0c 16 64 10 	movl   $0x106416,0xc(%esp)
  102ec6:	00 
  102ec7:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  102ece:	00 
  102ecf:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  102ed6:	00 
  102ed7:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  102ede:	e8 01 d5 ff ff       	call   1003e4 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  102ee3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  102eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eed:	25 ff 0f 00 00       	and    $0xfff,%eax
  102ef2:	89 c2                	mov    %eax,%edx
  102ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  102ef7:	01 c2                	add    %eax,%edx
  102ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102efc:	01 d0                	add    %edx,%eax
  102efe:	48                   	dec    %eax
  102eff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f05:	ba 00 00 00 00       	mov    $0x0,%edx
  102f0a:	f7 75 f0             	divl   -0x10(%ebp)
  102f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f10:	29 d0                	sub    %edx,%eax
  102f12:	c1 e8 0c             	shr    $0xc,%eax
  102f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  102f18:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102f26:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  102f29:	8b 45 14             	mov    0x14(%ebp),%eax
  102f2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102f32:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102f37:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  102f3a:	eb 68                	jmp    102fa4 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  102f3c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  102f43:	00 
  102f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f47:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4e:	89 04 24             	mov    %eax,(%esp)
  102f51:	e8 81 01 00 00       	call   1030d7 <get_pte>
  102f56:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  102f59:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  102f5d:	75 24                	jne    102f83 <boot_map_segment+0xd9>
  102f5f:	c7 44 24 0c 42 64 10 	movl   $0x106442,0xc(%esp)
  102f66:	00 
  102f67:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  102f6e:	00 
  102f6f:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  102f76:	00 
  102f77:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  102f7e:	e8 61 d4 ff ff       	call   1003e4 <__panic>
        *ptep = pa | PTE_P | perm;
  102f83:	8b 45 14             	mov    0x14(%ebp),%eax
  102f86:	0b 45 18             	or     0x18(%ebp),%eax
  102f89:	83 c8 01             	or     $0x1,%eax
  102f8c:	89 c2                	mov    %eax,%edx
  102f8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f91:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  102f93:	ff 4d f4             	decl   -0xc(%ebp)
  102f96:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  102f9d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  102fa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102fa8:	75 92                	jne    102f3c <boot_map_segment+0x92>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  102faa:	90                   	nop
  102fab:	c9                   	leave  
  102fac:	c3                   	ret    

00102fad <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  102fad:	55                   	push   %ebp
  102fae:	89 e5                	mov    %esp,%ebp
  102fb0:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  102fb3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102fba:	e8 6e fa ff ff       	call   102a2d <alloc_pages>
  102fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  102fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102fc6:	75 1c                	jne    102fe4 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  102fc8:	c7 44 24 08 4f 64 10 	movl   $0x10644f,0x8(%esp)
  102fcf:	00 
  102fd0:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  102fd7:	00 
  102fd8:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  102fdf:	e8 00 d4 ff ff       	call   1003e4 <__panic>
    }
    return page2kva(p);
  102fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fe7:	89 04 24             	mov    %eax,(%esp)
  102fea:	e8 9d f7 ff ff       	call   10278c <page2kva>
}
  102fef:	c9                   	leave  
  102ff0:	c3                   	ret    

00102ff1 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  102ff1:	55                   	push   %ebp
  102ff2:	89 e5                	mov    %esp,%ebp
  102ff4:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  102ff7:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  102ffc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102fff:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103006:	77 23                	ja     10302b <pmm_init+0x3a>
  103008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10300b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10300f:	c7 44 24 08 e4 63 10 	movl   $0x1063e4,0x8(%esp)
  103016:	00 
  103017:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10301e:	00 
  10301f:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103026:	e8 b9 d3 ff ff       	call   1003e4 <__panic>
  10302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10302e:	05 00 00 00 40       	add    $0x40000000,%eax
  103033:	a3 14 af 11 00       	mov    %eax,0x11af14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103038:	e8 9c f9 ff ff       	call   1029d9 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10303d:	e8 81 fa ff ff       	call   102ac3 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103042:	e8 4f 02 00 00       	call   103296 <check_alloc_page>

    check_pgdir();
  103047:	e8 69 02 00 00       	call   1032b5 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10304c:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103051:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  103057:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10305c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10305f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103066:	77 23                	ja     10308b <pmm_init+0x9a>
  103068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10306b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10306f:	c7 44 24 08 e4 63 10 	movl   $0x1063e4,0x8(%esp)
  103076:	00 
  103077:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  10307e:	00 
  10307f:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103086:	e8 59 d3 ff ff       	call   1003e4 <__panic>
  10308b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10308e:	05 00 00 00 40       	add    $0x40000000,%eax
  103093:	83 c8 03             	or     $0x3,%eax
  103096:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103098:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10309d:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1030a4:	00 
  1030a5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1030ac:	00 
  1030ad:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1030b4:	38 
  1030b5:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1030bc:	c0 
  1030bd:	89 04 24             	mov    %eax,(%esp)
  1030c0:	e8 e5 fd ff ff       	call   102eaa <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1030c5:	e8 26 f8 ff ff       	call   1028f0 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1030ca:	e8 82 08 00 00       	call   103951 <check_boot_pgdir>

    print_pgdir();
  1030cf:	e8 fb 0c 00 00       	call   103dcf <print_pgdir>

}
  1030d4:	90                   	nop
  1030d5:	c9                   	leave  
  1030d6:	c3                   	ret    

001030d7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1030d7:	55                   	push   %ebp
  1030d8:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1030da:	90                   	nop
  1030db:	5d                   	pop    %ebp
  1030dc:	c3                   	ret    

001030dd <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1030dd:	55                   	push   %ebp
  1030de:	89 e5                	mov    %esp,%ebp
  1030e0:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1030e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1030ea:	00 
  1030eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f5:	89 04 24             	mov    %eax,(%esp)
  1030f8:	e8 da ff ff ff       	call   1030d7 <get_pte>
  1030fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103100:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103104:	74 08                	je     10310e <get_page+0x31>
        *ptep_store = ptep;
  103106:	8b 45 10             	mov    0x10(%ebp),%eax
  103109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10310c:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10310e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103112:	74 1b                	je     10312f <get_page+0x52>
  103114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103117:	8b 00                	mov    (%eax),%eax
  103119:	83 e0 01             	and    $0x1,%eax
  10311c:	85 c0                	test   %eax,%eax
  10311e:	74 0f                	je     10312f <get_page+0x52>
        return pte2page(*ptep);
  103120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103123:	8b 00                	mov    (%eax),%eax
  103125:	89 04 24             	mov    %eax,(%esp)
  103128:	e8 b3 f6 ff ff       	call   1027e0 <pte2page>
  10312d:	eb 05                	jmp    103134 <get_page+0x57>
    }
    return NULL;
  10312f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103134:	c9                   	leave  
  103135:	c3                   	ret    

00103136 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  103136:	55                   	push   %ebp
  103137:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  103139:	90                   	nop
  10313a:	5d                   	pop    %ebp
  10313b:	c3                   	ret    

0010313c <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10313c:	55                   	push   %ebp
  10313d:	89 e5                	mov    %esp,%ebp
  10313f:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103142:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103149:	00 
  10314a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10314d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103151:	8b 45 08             	mov    0x8(%ebp),%eax
  103154:	89 04 24             	mov    %eax,(%esp)
  103157:	e8 7b ff ff ff       	call   1030d7 <get_pte>
  10315c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  10315f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103163:	74 19                	je     10317e <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  103165:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103168:	89 44 24 08          	mov    %eax,0x8(%esp)
  10316c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10316f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103173:	8b 45 08             	mov    0x8(%ebp),%eax
  103176:	89 04 24             	mov    %eax,(%esp)
  103179:	e8 b8 ff ff ff       	call   103136 <page_remove_pte>
    }
}
  10317e:	90                   	nop
  10317f:	c9                   	leave  
  103180:	c3                   	ret    

00103181 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103181:	55                   	push   %ebp
  103182:	89 e5                	mov    %esp,%ebp
  103184:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103187:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10318e:	00 
  10318f:	8b 45 10             	mov    0x10(%ebp),%eax
  103192:	89 44 24 04          	mov    %eax,0x4(%esp)
  103196:	8b 45 08             	mov    0x8(%ebp),%eax
  103199:	89 04 24             	mov    %eax,(%esp)
  10319c:	e8 36 ff ff ff       	call   1030d7 <get_pte>
  1031a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1031a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031a8:	75 0a                	jne    1031b4 <page_insert+0x33>
        return -E_NO_MEM;
  1031aa:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1031af:	e9 84 00 00 00       	jmp    103238 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1031b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031b7:	89 04 24             	mov    %eax,(%esp)
  1031ba:	e8 81 f6 ff ff       	call   102840 <page_ref_inc>
    if (*ptep & PTE_P) {
  1031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031c2:	8b 00                	mov    (%eax),%eax
  1031c4:	83 e0 01             	and    $0x1,%eax
  1031c7:	85 c0                	test   %eax,%eax
  1031c9:	74 3e                	je     103209 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1031cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031ce:	8b 00                	mov    (%eax),%eax
  1031d0:	89 04 24             	mov    %eax,(%esp)
  1031d3:	e8 08 f6 ff ff       	call   1027e0 <pte2page>
  1031d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1031db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1031e1:	75 0d                	jne    1031f0 <page_insert+0x6f>
            page_ref_dec(page);
  1031e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031e6:	89 04 24             	mov    %eax,(%esp)
  1031e9:	e8 69 f6 ff ff       	call   102857 <page_ref_dec>
  1031ee:	eb 19                	jmp    103209 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1031f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1031fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103201:	89 04 24             	mov    %eax,(%esp)
  103204:	e8 2d ff ff ff       	call   103136 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103209:	8b 45 0c             	mov    0xc(%ebp),%eax
  10320c:	89 04 24             	mov    %eax,(%esp)
  10320f:	e8 13 f5 ff ff       	call   102727 <page2pa>
  103214:	0b 45 14             	or     0x14(%ebp),%eax
  103217:	83 c8 01             	or     $0x1,%eax
  10321a:	89 c2                	mov    %eax,%edx
  10321c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10321f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103221:	8b 45 10             	mov    0x10(%ebp),%eax
  103224:	89 44 24 04          	mov    %eax,0x4(%esp)
  103228:	8b 45 08             	mov    0x8(%ebp),%eax
  10322b:	89 04 24             	mov    %eax,(%esp)
  10322e:	e8 07 00 00 00       	call   10323a <tlb_invalidate>
    return 0;
  103233:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103238:	c9                   	leave  
  103239:	c3                   	ret    

0010323a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10323a:	55                   	push   %ebp
  10323b:	89 e5                	mov    %esp,%ebp
  10323d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  103240:	0f 20 d8             	mov    %cr3,%eax
  103243:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return cr3;
  103246:	8b 55 ec             	mov    -0x14(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103249:	8b 45 08             	mov    0x8(%ebp),%eax
  10324c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10324f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103256:	77 23                	ja     10327b <tlb_invalidate+0x41>
  103258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10325b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10325f:	c7 44 24 08 e4 63 10 	movl   $0x1063e4,0x8(%esp)
  103266:	00 
  103267:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
  10326e:	00 
  10326f:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103276:	e8 69 d1 ff ff       	call   1003e4 <__panic>
  10327b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10327e:	05 00 00 00 40       	add    $0x40000000,%eax
  103283:	39 c2                	cmp    %eax,%edx
  103285:	75 0c                	jne    103293 <tlb_invalidate+0x59>
        invlpg((void *)la);
  103287:	8b 45 0c             	mov    0xc(%ebp),%eax
  10328a:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103290:	0f 01 38             	invlpg (%eax)
    }
}
  103293:	90                   	nop
  103294:	c9                   	leave  
  103295:	c3                   	ret    

00103296 <check_alloc_page>:

static void
check_alloc_page(void) {
  103296:	55                   	push   %ebp
  103297:	89 e5                	mov    %esp,%ebp
  103299:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10329c:	a1 10 af 11 00       	mov    0x11af10,%eax
  1032a1:	8b 40 18             	mov    0x18(%eax),%eax
  1032a4:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1032a6:	c7 04 24 68 64 10 00 	movl   $0x106468,(%esp)
  1032ad:	e8 db cf ff ff       	call   10028d <cprintf>
}
  1032b2:	90                   	nop
  1032b3:	c9                   	leave  
  1032b4:	c3                   	ret    

001032b5 <check_pgdir>:

static void
check_pgdir(void) {
  1032b5:	55                   	push   %ebp
  1032b6:	89 e5                	mov    %esp,%ebp
  1032b8:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1032bb:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1032c0:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1032c5:	76 24                	jbe    1032eb <check_pgdir+0x36>
  1032c7:	c7 44 24 0c 87 64 10 	movl   $0x106487,0xc(%esp)
  1032ce:	00 
  1032cf:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  1032d6:	00 
  1032d7:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
  1032de:	00 
  1032df:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1032e6:	e8 f9 d0 ff ff       	call   1003e4 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1032eb:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1032f0:	85 c0                	test   %eax,%eax
  1032f2:	74 0e                	je     103302 <check_pgdir+0x4d>
  1032f4:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1032f9:	25 ff 0f 00 00       	and    $0xfff,%eax
  1032fe:	85 c0                	test   %eax,%eax
  103300:	74 24                	je     103326 <check_pgdir+0x71>
  103302:	c7 44 24 0c a4 64 10 	movl   $0x1064a4,0xc(%esp)
  103309:	00 
  10330a:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103311:	00 
  103312:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
  103319:	00 
  10331a:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103321:	e8 be d0 ff ff       	call   1003e4 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103326:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10332b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103332:	00 
  103333:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10333a:	00 
  10333b:	89 04 24             	mov    %eax,(%esp)
  10333e:	e8 9a fd ff ff       	call   1030dd <get_page>
  103343:	85 c0                	test   %eax,%eax
  103345:	74 24                	je     10336b <check_pgdir+0xb6>
  103347:	c7 44 24 0c dc 64 10 	movl   $0x1064dc,0xc(%esp)
  10334e:	00 
  10334f:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103356:	00 
  103357:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  10335e:	00 
  10335f:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103366:	e8 79 d0 ff ff       	call   1003e4 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10336b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103372:	e8 b6 f6 ff ff       	call   102a2d <alloc_pages>
  103377:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10337a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10337f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103386:	00 
  103387:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10338e:	00 
  10338f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103392:	89 54 24 04          	mov    %edx,0x4(%esp)
  103396:	89 04 24             	mov    %eax,(%esp)
  103399:	e8 e3 fd ff ff       	call   103181 <page_insert>
  10339e:	85 c0                	test   %eax,%eax
  1033a0:	74 24                	je     1033c6 <check_pgdir+0x111>
  1033a2:	c7 44 24 0c 04 65 10 	movl   $0x106504,0xc(%esp)
  1033a9:	00 
  1033aa:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  1033b1:	00 
  1033b2:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  1033b9:	00 
  1033ba:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1033c1:	e8 1e d0 ff ff       	call   1003e4 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1033c6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1033cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1033d2:	00 
  1033d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1033da:	00 
  1033db:	89 04 24             	mov    %eax,(%esp)
  1033de:	e8 f4 fc ff ff       	call   1030d7 <get_pte>
  1033e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1033ea:	75 24                	jne    103410 <check_pgdir+0x15b>
  1033ec:	c7 44 24 0c 30 65 10 	movl   $0x106530,0xc(%esp)
  1033f3:	00 
  1033f4:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  1033fb:	00 
  1033fc:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  103403:	00 
  103404:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  10340b:	e8 d4 cf ff ff       	call   1003e4 <__panic>
    assert(pte2page(*ptep) == p1);
  103410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103413:	8b 00                	mov    (%eax),%eax
  103415:	89 04 24             	mov    %eax,(%esp)
  103418:	e8 c3 f3 ff ff       	call   1027e0 <pte2page>
  10341d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103420:	74 24                	je     103446 <check_pgdir+0x191>
  103422:	c7 44 24 0c 5d 65 10 	movl   $0x10655d,0xc(%esp)
  103429:	00 
  10342a:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103431:	00 
  103432:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
  103439:	00 
  10343a:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103441:	e8 9e cf ff ff       	call   1003e4 <__panic>
    assert(page_ref(p1) == 1);
  103446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103449:	89 04 24             	mov    %eax,(%esp)
  10344c:	e8 e5 f3 ff ff       	call   102836 <page_ref>
  103451:	83 f8 01             	cmp    $0x1,%eax
  103454:	74 24                	je     10347a <check_pgdir+0x1c5>
  103456:	c7 44 24 0c 73 65 10 	movl   $0x106573,0xc(%esp)
  10345d:	00 
  10345e:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103465:	00 
  103466:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  10346d:	00 
  10346e:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103475:	e8 6a cf ff ff       	call   1003e4 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10347a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10347f:	8b 00                	mov    (%eax),%eax
  103481:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103486:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10348c:	c1 e8 0c             	shr    $0xc,%eax
  10348f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103492:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103497:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10349a:	72 23                	jb     1034bf <check_pgdir+0x20a>
  10349c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10349f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034a3:	c7 44 24 08 40 63 10 	movl   $0x106340,0x8(%esp)
  1034aa:	00 
  1034ab:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  1034b2:	00 
  1034b3:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1034ba:	e8 25 cf ff ff       	call   1003e4 <__panic>
  1034bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034c2:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1034c7:	83 c0 04             	add    $0x4,%eax
  1034ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1034cd:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1034d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1034d9:	00 
  1034da:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1034e1:	00 
  1034e2:	89 04 24             	mov    %eax,(%esp)
  1034e5:	e8 ed fb ff ff       	call   1030d7 <get_pte>
  1034ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1034ed:	74 24                	je     103513 <check_pgdir+0x25e>
  1034ef:	c7 44 24 0c 88 65 10 	movl   $0x106588,0xc(%esp)
  1034f6:	00 
  1034f7:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  1034fe:	00 
  1034ff:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  103506:	00 
  103507:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  10350e:	e8 d1 ce ff ff       	call   1003e4 <__panic>

    p2 = alloc_page();
  103513:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10351a:	e8 0e f5 ff ff       	call   102a2d <alloc_pages>
  10351f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103522:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103527:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  10352e:	00 
  10352f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103536:	00 
  103537:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10353a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10353e:	89 04 24             	mov    %eax,(%esp)
  103541:	e8 3b fc ff ff       	call   103181 <page_insert>
  103546:	85 c0                	test   %eax,%eax
  103548:	74 24                	je     10356e <check_pgdir+0x2b9>
  10354a:	c7 44 24 0c b0 65 10 	movl   $0x1065b0,0xc(%esp)
  103551:	00 
  103552:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103559:	00 
  10355a:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  103561:	00 
  103562:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103569:	e8 76 ce ff ff       	call   1003e4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  10356e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103573:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10357a:	00 
  10357b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103582:	00 
  103583:	89 04 24             	mov    %eax,(%esp)
  103586:	e8 4c fb ff ff       	call   1030d7 <get_pte>
  10358b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10358e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103592:	75 24                	jne    1035b8 <check_pgdir+0x303>
  103594:	c7 44 24 0c e8 65 10 	movl   $0x1065e8,0xc(%esp)
  10359b:	00 
  10359c:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  1035a3:	00 
  1035a4:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  1035ab:	00 
  1035ac:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1035b3:	e8 2c ce ff ff       	call   1003e4 <__panic>
    assert(*ptep & PTE_U);
  1035b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035bb:	8b 00                	mov    (%eax),%eax
  1035bd:	83 e0 04             	and    $0x4,%eax
  1035c0:	85 c0                	test   %eax,%eax
  1035c2:	75 24                	jne    1035e8 <check_pgdir+0x333>
  1035c4:	c7 44 24 0c 18 66 10 	movl   $0x106618,0xc(%esp)
  1035cb:	00 
  1035cc:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  1035d3:	00 
  1035d4:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  1035db:	00 
  1035dc:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1035e3:	e8 fc cd ff ff       	call   1003e4 <__panic>
    assert(*ptep & PTE_W);
  1035e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035eb:	8b 00                	mov    (%eax),%eax
  1035ed:	83 e0 02             	and    $0x2,%eax
  1035f0:	85 c0                	test   %eax,%eax
  1035f2:	75 24                	jne    103618 <check_pgdir+0x363>
  1035f4:	c7 44 24 0c 26 66 10 	movl   $0x106626,0xc(%esp)
  1035fb:	00 
  1035fc:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103603:	00 
  103604:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  10360b:	00 
  10360c:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103613:	e8 cc cd ff ff       	call   1003e4 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103618:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10361d:	8b 00                	mov    (%eax),%eax
  10361f:	83 e0 04             	and    $0x4,%eax
  103622:	85 c0                	test   %eax,%eax
  103624:	75 24                	jne    10364a <check_pgdir+0x395>
  103626:	c7 44 24 0c 34 66 10 	movl   $0x106634,0xc(%esp)
  10362d:	00 
  10362e:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103635:	00 
  103636:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  10363d:	00 
  10363e:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103645:	e8 9a cd ff ff       	call   1003e4 <__panic>
    assert(page_ref(p2) == 1);
  10364a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10364d:	89 04 24             	mov    %eax,(%esp)
  103650:	e8 e1 f1 ff ff       	call   102836 <page_ref>
  103655:	83 f8 01             	cmp    $0x1,%eax
  103658:	74 24                	je     10367e <check_pgdir+0x3c9>
  10365a:	c7 44 24 0c 4a 66 10 	movl   $0x10664a,0xc(%esp)
  103661:	00 
  103662:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103669:	00 
  10366a:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  103671:	00 
  103672:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103679:	e8 66 cd ff ff       	call   1003e4 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  10367e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103683:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10368a:	00 
  10368b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103692:	00 
  103693:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103696:	89 54 24 04          	mov    %edx,0x4(%esp)
  10369a:	89 04 24             	mov    %eax,(%esp)
  10369d:	e8 df fa ff ff       	call   103181 <page_insert>
  1036a2:	85 c0                	test   %eax,%eax
  1036a4:	74 24                	je     1036ca <check_pgdir+0x415>
  1036a6:	c7 44 24 0c 5c 66 10 	movl   $0x10665c,0xc(%esp)
  1036ad:	00 
  1036ae:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  1036b5:	00 
  1036b6:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  1036bd:	00 
  1036be:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1036c5:	e8 1a cd ff ff       	call   1003e4 <__panic>
    assert(page_ref(p1) == 2);
  1036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036cd:	89 04 24             	mov    %eax,(%esp)
  1036d0:	e8 61 f1 ff ff       	call   102836 <page_ref>
  1036d5:	83 f8 02             	cmp    $0x2,%eax
  1036d8:	74 24                	je     1036fe <check_pgdir+0x449>
  1036da:	c7 44 24 0c 88 66 10 	movl   $0x106688,0xc(%esp)
  1036e1:	00 
  1036e2:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  1036e9:	00 
  1036ea:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  1036f1:	00 
  1036f2:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1036f9:	e8 e6 cc ff ff       	call   1003e4 <__panic>
    assert(page_ref(p2) == 0);
  1036fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103701:	89 04 24             	mov    %eax,(%esp)
  103704:	e8 2d f1 ff ff       	call   102836 <page_ref>
  103709:	85 c0                	test   %eax,%eax
  10370b:	74 24                	je     103731 <check_pgdir+0x47c>
  10370d:	c7 44 24 0c 9a 66 10 	movl   $0x10669a,0xc(%esp)
  103714:	00 
  103715:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  10371c:	00 
  10371d:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  103724:	00 
  103725:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  10372c:	e8 b3 cc ff ff       	call   1003e4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103731:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103736:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10373d:	00 
  10373e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103745:	00 
  103746:	89 04 24             	mov    %eax,(%esp)
  103749:	e8 89 f9 ff ff       	call   1030d7 <get_pte>
  10374e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103751:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103755:	75 24                	jne    10377b <check_pgdir+0x4c6>
  103757:	c7 44 24 0c e8 65 10 	movl   $0x1065e8,0xc(%esp)
  10375e:	00 
  10375f:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103766:	00 
  103767:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  10376e:	00 
  10376f:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103776:	e8 69 cc ff ff       	call   1003e4 <__panic>
    assert(pte2page(*ptep) == p1);
  10377b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10377e:	8b 00                	mov    (%eax),%eax
  103780:	89 04 24             	mov    %eax,(%esp)
  103783:	e8 58 f0 ff ff       	call   1027e0 <pte2page>
  103788:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10378b:	74 24                	je     1037b1 <check_pgdir+0x4fc>
  10378d:	c7 44 24 0c 5d 65 10 	movl   $0x10655d,0xc(%esp)
  103794:	00 
  103795:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  10379c:	00 
  10379d:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  1037a4:	00 
  1037a5:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1037ac:	e8 33 cc ff ff       	call   1003e4 <__panic>
    assert((*ptep & PTE_U) == 0);
  1037b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1037b4:	8b 00                	mov    (%eax),%eax
  1037b6:	83 e0 04             	and    $0x4,%eax
  1037b9:	85 c0                	test   %eax,%eax
  1037bb:	74 24                	je     1037e1 <check_pgdir+0x52c>
  1037bd:	c7 44 24 0c ac 66 10 	movl   $0x1066ac,0xc(%esp)
  1037c4:	00 
  1037c5:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  1037cc:	00 
  1037cd:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  1037d4:	00 
  1037d5:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1037dc:	e8 03 cc ff ff       	call   1003e4 <__panic>

    page_remove(boot_pgdir, 0x0);
  1037e1:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1037e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1037ed:	00 
  1037ee:	89 04 24             	mov    %eax,(%esp)
  1037f1:	e8 46 f9 ff ff       	call   10313c <page_remove>
    assert(page_ref(p1) == 1);
  1037f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1037f9:	89 04 24             	mov    %eax,(%esp)
  1037fc:	e8 35 f0 ff ff       	call   102836 <page_ref>
  103801:	83 f8 01             	cmp    $0x1,%eax
  103804:	74 24                	je     10382a <check_pgdir+0x575>
  103806:	c7 44 24 0c 73 65 10 	movl   $0x106573,0xc(%esp)
  10380d:	00 
  10380e:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103815:	00 
  103816:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  10381d:	00 
  10381e:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103825:	e8 ba cb ff ff       	call   1003e4 <__panic>
    assert(page_ref(p2) == 0);
  10382a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10382d:	89 04 24             	mov    %eax,(%esp)
  103830:	e8 01 f0 ff ff       	call   102836 <page_ref>
  103835:	85 c0                	test   %eax,%eax
  103837:	74 24                	je     10385d <check_pgdir+0x5a8>
  103839:	c7 44 24 0c 9a 66 10 	movl   $0x10669a,0xc(%esp)
  103840:	00 
  103841:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103848:	00 
  103849:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  103850:	00 
  103851:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103858:	e8 87 cb ff ff       	call   1003e4 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  10385d:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103862:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103869:	00 
  10386a:	89 04 24             	mov    %eax,(%esp)
  10386d:	e8 ca f8 ff ff       	call   10313c <page_remove>
    assert(page_ref(p1) == 0);
  103872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103875:	89 04 24             	mov    %eax,(%esp)
  103878:	e8 b9 ef ff ff       	call   102836 <page_ref>
  10387d:	85 c0                	test   %eax,%eax
  10387f:	74 24                	je     1038a5 <check_pgdir+0x5f0>
  103881:	c7 44 24 0c c1 66 10 	movl   $0x1066c1,0xc(%esp)
  103888:	00 
  103889:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103890:	00 
  103891:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  103898:	00 
  103899:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1038a0:	e8 3f cb ff ff       	call   1003e4 <__panic>
    assert(page_ref(p2) == 0);
  1038a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038a8:	89 04 24             	mov    %eax,(%esp)
  1038ab:	e8 86 ef ff ff       	call   102836 <page_ref>
  1038b0:	85 c0                	test   %eax,%eax
  1038b2:	74 24                	je     1038d8 <check_pgdir+0x623>
  1038b4:	c7 44 24 0c 9a 66 10 	movl   $0x10669a,0xc(%esp)
  1038bb:	00 
  1038bc:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  1038c3:	00 
  1038c4:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  1038cb:	00 
  1038cc:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1038d3:	e8 0c cb ff ff       	call   1003e4 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  1038d8:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1038dd:	8b 00                	mov    (%eax),%eax
  1038df:	89 04 24             	mov    %eax,(%esp)
  1038e2:	e8 37 ef ff ff       	call   10281e <pde2page>
  1038e7:	89 04 24             	mov    %eax,(%esp)
  1038ea:	e8 47 ef ff ff       	call   102836 <page_ref>
  1038ef:	83 f8 01             	cmp    $0x1,%eax
  1038f2:	74 24                	je     103918 <check_pgdir+0x663>
  1038f4:	c7 44 24 0c d4 66 10 	movl   $0x1066d4,0xc(%esp)
  1038fb:	00 
  1038fc:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103903:	00 
  103904:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  10390b:	00 
  10390c:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103913:	e8 cc ca ff ff       	call   1003e4 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103918:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10391d:	8b 00                	mov    (%eax),%eax
  10391f:	89 04 24             	mov    %eax,(%esp)
  103922:	e8 f7 ee ff ff       	call   10281e <pde2page>
  103927:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10392e:	00 
  10392f:	89 04 24             	mov    %eax,(%esp)
  103932:	e8 2e f1 ff ff       	call   102a65 <free_pages>
    boot_pgdir[0] = 0;
  103937:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10393c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103942:	c7 04 24 fb 66 10 00 	movl   $0x1066fb,(%esp)
  103949:	e8 3f c9 ff ff       	call   10028d <cprintf>
}
  10394e:	90                   	nop
  10394f:	c9                   	leave  
  103950:	c3                   	ret    

00103951 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103951:	55                   	push   %ebp
  103952:	89 e5                	mov    %esp,%ebp
  103954:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103957:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10395e:	e9 ca 00 00 00       	jmp    103a2d <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10396c:	c1 e8 0c             	shr    $0xc,%eax
  10396f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103972:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103977:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  10397a:	72 23                	jb     10399f <check_boot_pgdir+0x4e>
  10397c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10397f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103983:	c7 44 24 08 40 63 10 	movl   $0x106340,0x8(%esp)
  10398a:	00 
  10398b:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  103992:	00 
  103993:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  10399a:	e8 45 ca ff ff       	call   1003e4 <__panic>
  10399f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039a2:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1039a7:	89 c2                	mov    %eax,%edx
  1039a9:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1039ae:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039b5:	00 
  1039b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1039ba:	89 04 24             	mov    %eax,(%esp)
  1039bd:	e8 15 f7 ff ff       	call   1030d7 <get_pte>
  1039c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1039c5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1039c9:	75 24                	jne    1039ef <check_boot_pgdir+0x9e>
  1039cb:	c7 44 24 0c 18 67 10 	movl   $0x106718,0xc(%esp)
  1039d2:	00 
  1039d3:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  1039da:	00 
  1039db:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  1039e2:	00 
  1039e3:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1039ea:	e8 f5 c9 ff ff       	call   1003e4 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  1039ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1039f2:	8b 00                	mov    (%eax),%eax
  1039f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1039f9:	89 c2                	mov    %eax,%edx
  1039fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039fe:	39 c2                	cmp    %eax,%edx
  103a00:	74 24                	je     103a26 <check_boot_pgdir+0xd5>
  103a02:	c7 44 24 0c 55 67 10 	movl   $0x106755,0xc(%esp)
  103a09:	00 
  103a0a:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103a11:	00 
  103a12:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  103a19:	00 
  103a1a:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103a21:	e8 be c9 ff ff       	call   1003e4 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103a26:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103a30:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103a35:	39 c2                	cmp    %eax,%edx
  103a37:	0f 82 26 ff ff ff    	jb     103963 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103a3d:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103a42:	05 ac 0f 00 00       	add    $0xfac,%eax
  103a47:	8b 00                	mov    (%eax),%eax
  103a49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103a4e:	89 c2                	mov    %eax,%edx
  103a50:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103a55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a58:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  103a5f:	77 23                	ja     103a84 <check_boot_pgdir+0x133>
  103a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a64:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103a68:	c7 44 24 08 e4 63 10 	movl   $0x1063e4,0x8(%esp)
  103a6f:	00 
  103a70:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103a77:	00 
  103a78:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103a7f:	e8 60 c9 ff ff       	call   1003e4 <__panic>
  103a84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a87:	05 00 00 00 40       	add    $0x40000000,%eax
  103a8c:	39 c2                	cmp    %eax,%edx
  103a8e:	74 24                	je     103ab4 <check_boot_pgdir+0x163>
  103a90:	c7 44 24 0c 6c 67 10 	movl   $0x10676c,0xc(%esp)
  103a97:	00 
  103a98:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103a9f:	00 
  103aa0:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103aa7:	00 
  103aa8:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103aaf:	e8 30 c9 ff ff       	call   1003e4 <__panic>

    assert(boot_pgdir[0] == 0);
  103ab4:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103ab9:	8b 00                	mov    (%eax),%eax
  103abb:	85 c0                	test   %eax,%eax
  103abd:	74 24                	je     103ae3 <check_boot_pgdir+0x192>
  103abf:	c7 44 24 0c a0 67 10 	movl   $0x1067a0,0xc(%esp)
  103ac6:	00 
  103ac7:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103ace:	00 
  103acf:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103ad6:	00 
  103ad7:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103ade:	e8 01 c9 ff ff       	call   1003e4 <__panic>

    struct Page *p;
    p = alloc_page();
  103ae3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103aea:	e8 3e ef ff ff       	call   102a2d <alloc_pages>
  103aef:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103af2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103af7:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103afe:	00 
  103aff:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103b06:	00 
  103b07:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103b0a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b0e:	89 04 24             	mov    %eax,(%esp)
  103b11:	e8 6b f6 ff ff       	call   103181 <page_insert>
  103b16:	85 c0                	test   %eax,%eax
  103b18:	74 24                	je     103b3e <check_boot_pgdir+0x1ed>
  103b1a:	c7 44 24 0c b4 67 10 	movl   $0x1067b4,0xc(%esp)
  103b21:	00 
  103b22:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103b29:	00 
  103b2a:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  103b31:	00 
  103b32:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103b39:	e8 a6 c8 ff ff       	call   1003e4 <__panic>
    assert(page_ref(p) == 1);
  103b3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103b41:	89 04 24             	mov    %eax,(%esp)
  103b44:	e8 ed ec ff ff       	call   102836 <page_ref>
  103b49:	83 f8 01             	cmp    $0x1,%eax
  103b4c:	74 24                	je     103b72 <check_boot_pgdir+0x221>
  103b4e:	c7 44 24 0c e2 67 10 	movl   $0x1067e2,0xc(%esp)
  103b55:	00 
  103b56:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103b5d:	00 
  103b5e:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  103b65:	00 
  103b66:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103b6d:	e8 72 c8 ff ff       	call   1003e4 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103b72:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103b77:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103b7e:	00 
  103b7f:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  103b86:	00 
  103b87:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103b8a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b8e:	89 04 24             	mov    %eax,(%esp)
  103b91:	e8 eb f5 ff ff       	call   103181 <page_insert>
  103b96:	85 c0                	test   %eax,%eax
  103b98:	74 24                	je     103bbe <check_boot_pgdir+0x26d>
  103b9a:	c7 44 24 0c f4 67 10 	movl   $0x1067f4,0xc(%esp)
  103ba1:	00 
  103ba2:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103ba9:	00 
  103baa:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  103bb1:	00 
  103bb2:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103bb9:	e8 26 c8 ff ff       	call   1003e4 <__panic>
    assert(page_ref(p) == 2);
  103bbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103bc1:	89 04 24             	mov    %eax,(%esp)
  103bc4:	e8 6d ec ff ff       	call   102836 <page_ref>
  103bc9:	83 f8 02             	cmp    $0x2,%eax
  103bcc:	74 24                	je     103bf2 <check_boot_pgdir+0x2a1>
  103bce:	c7 44 24 0c 2b 68 10 	movl   $0x10682b,0xc(%esp)
  103bd5:	00 
  103bd6:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103bdd:	00 
  103bde:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  103be5:	00 
  103be6:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103bed:	e8 f2 c7 ff ff       	call   1003e4 <__panic>

    const char *str = "ucore: Hello world!!";
  103bf2:	c7 45 dc 3c 68 10 00 	movl   $0x10683c,-0x24(%ebp)
    strcpy((void *)0x100, str);
  103bf9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  103c00:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103c07:	e8 4b 15 00 00       	call   105157 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103c0c:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  103c13:	00 
  103c14:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103c1b:	e8 ae 15 00 00       	call   1051ce <strcmp>
  103c20:	85 c0                	test   %eax,%eax
  103c22:	74 24                	je     103c48 <check_boot_pgdir+0x2f7>
  103c24:	c7 44 24 0c 54 68 10 	movl   $0x106854,0xc(%esp)
  103c2b:	00 
  103c2c:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103c33:	00 
  103c34:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  103c3b:	00 
  103c3c:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103c43:	e8 9c c7 ff ff       	call   1003e4 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103c48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103c4b:	89 04 24             	mov    %eax,(%esp)
  103c4e:	e8 39 eb ff ff       	call   10278c <page2kva>
  103c53:	05 00 01 00 00       	add    $0x100,%eax
  103c58:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103c5b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103c62:	e8 9a 14 00 00       	call   105101 <strlen>
  103c67:	85 c0                	test   %eax,%eax
  103c69:	74 24                	je     103c8f <check_boot_pgdir+0x33e>
  103c6b:	c7 44 24 0c 8c 68 10 	movl   $0x10688c,0xc(%esp)
  103c72:	00 
  103c73:	c7 44 24 08 2d 64 10 	movl   $0x10642d,0x8(%esp)
  103c7a:	00 
  103c7b:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103c82:	00 
  103c83:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  103c8a:	e8 55 c7 ff ff       	call   1003e4 <__panic>

    free_page(p);
  103c8f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103c96:	00 
  103c97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103c9a:	89 04 24             	mov    %eax,(%esp)
  103c9d:	e8 c3 ed ff ff       	call   102a65 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  103ca2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103ca7:	8b 00                	mov    (%eax),%eax
  103ca9:	89 04 24             	mov    %eax,(%esp)
  103cac:	e8 6d eb ff ff       	call   10281e <pde2page>
  103cb1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103cb8:	00 
  103cb9:	89 04 24             	mov    %eax,(%esp)
  103cbc:	e8 a4 ed ff ff       	call   102a65 <free_pages>
    boot_pgdir[0] = 0;
  103cc1:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103cc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103ccc:	c7 04 24 b0 68 10 00 	movl   $0x1068b0,(%esp)
  103cd3:	e8 b5 c5 ff ff       	call   10028d <cprintf>
}
  103cd8:	90                   	nop
  103cd9:	c9                   	leave  
  103cda:	c3                   	ret    

00103cdb <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103cdb:	55                   	push   %ebp
  103cdc:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103cde:	8b 45 08             	mov    0x8(%ebp),%eax
  103ce1:	83 e0 04             	and    $0x4,%eax
  103ce4:	85 c0                	test   %eax,%eax
  103ce6:	74 04                	je     103cec <perm2str+0x11>
  103ce8:	b0 75                	mov    $0x75,%al
  103cea:	eb 02                	jmp    103cee <perm2str+0x13>
  103cec:	b0 2d                	mov    $0x2d,%al
  103cee:	a2 08 af 11 00       	mov    %al,0x11af08
    str[1] = 'r';
  103cf3:	c6 05 09 af 11 00 72 	movb   $0x72,0x11af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  103cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  103cfd:	83 e0 02             	and    $0x2,%eax
  103d00:	85 c0                	test   %eax,%eax
  103d02:	74 04                	je     103d08 <perm2str+0x2d>
  103d04:	b0 77                	mov    $0x77,%al
  103d06:	eb 02                	jmp    103d0a <perm2str+0x2f>
  103d08:	b0 2d                	mov    $0x2d,%al
  103d0a:	a2 0a af 11 00       	mov    %al,0x11af0a
    str[3] = '\0';
  103d0f:	c6 05 0b af 11 00 00 	movb   $0x0,0x11af0b
    return str;
  103d16:	b8 08 af 11 00       	mov    $0x11af08,%eax
}
  103d1b:	5d                   	pop    %ebp
  103d1c:	c3                   	ret    

00103d1d <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  103d1d:	55                   	push   %ebp
  103d1e:	89 e5                	mov    %esp,%ebp
  103d20:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  103d23:	8b 45 10             	mov    0x10(%ebp),%eax
  103d26:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103d29:	72 0d                	jb     103d38 <get_pgtable_items+0x1b>
        return 0;
  103d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  103d30:	e9 98 00 00 00       	jmp    103dcd <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  103d35:	ff 45 10             	incl   0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  103d38:	8b 45 10             	mov    0x10(%ebp),%eax
  103d3b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103d3e:	73 18                	jae    103d58 <get_pgtable_items+0x3b>
  103d40:	8b 45 10             	mov    0x10(%ebp),%eax
  103d43:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  103d4d:	01 d0                	add    %edx,%eax
  103d4f:	8b 00                	mov    (%eax),%eax
  103d51:	83 e0 01             	and    $0x1,%eax
  103d54:	85 c0                	test   %eax,%eax
  103d56:	74 dd                	je     103d35 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
  103d58:	8b 45 10             	mov    0x10(%ebp),%eax
  103d5b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103d5e:	73 68                	jae    103dc8 <get_pgtable_items+0xab>
        if (left_store != NULL) {
  103d60:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  103d64:	74 08                	je     103d6e <get_pgtable_items+0x51>
            *left_store = start;
  103d66:	8b 45 18             	mov    0x18(%ebp),%eax
  103d69:	8b 55 10             	mov    0x10(%ebp),%edx
  103d6c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  103d6e:	8b 45 10             	mov    0x10(%ebp),%eax
  103d71:	8d 50 01             	lea    0x1(%eax),%edx
  103d74:	89 55 10             	mov    %edx,0x10(%ebp)
  103d77:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103d7e:	8b 45 14             	mov    0x14(%ebp),%eax
  103d81:	01 d0                	add    %edx,%eax
  103d83:	8b 00                	mov    (%eax),%eax
  103d85:	83 e0 07             	and    $0x7,%eax
  103d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  103d8b:	eb 03                	jmp    103d90 <get_pgtable_items+0x73>
            start ++;
  103d8d:	ff 45 10             	incl   0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  103d90:	8b 45 10             	mov    0x10(%ebp),%eax
  103d93:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103d96:	73 1d                	jae    103db5 <get_pgtable_items+0x98>
  103d98:	8b 45 10             	mov    0x10(%ebp),%eax
  103d9b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103da2:	8b 45 14             	mov    0x14(%ebp),%eax
  103da5:	01 d0                	add    %edx,%eax
  103da7:	8b 00                	mov    (%eax),%eax
  103da9:	83 e0 07             	and    $0x7,%eax
  103dac:	89 c2                	mov    %eax,%edx
  103dae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103db1:	39 c2                	cmp    %eax,%edx
  103db3:	74 d8                	je     103d8d <get_pgtable_items+0x70>
            start ++;
        }
        if (right_store != NULL) {
  103db5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103db9:	74 08                	je     103dc3 <get_pgtable_items+0xa6>
            *right_store = start;
  103dbb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103dbe:	8b 55 10             	mov    0x10(%ebp),%edx
  103dc1:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  103dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103dc6:	eb 05                	jmp    103dcd <get_pgtable_items+0xb0>
    }
    return 0;
  103dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103dcd:	c9                   	leave  
  103dce:	c3                   	ret    

00103dcf <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  103dcf:	55                   	push   %ebp
  103dd0:	89 e5                	mov    %esp,%ebp
  103dd2:	57                   	push   %edi
  103dd3:	56                   	push   %esi
  103dd4:	53                   	push   %ebx
  103dd5:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  103dd8:	c7 04 24 d0 68 10 00 	movl   $0x1068d0,(%esp)
  103ddf:	e8 a9 c4 ff ff       	call   10028d <cprintf>
    size_t left, right = 0, perm;
  103de4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  103deb:	e9 fa 00 00 00       	jmp    103eea <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  103df0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103df3:	89 04 24             	mov    %eax,(%esp)
  103df6:	e8 e0 fe ff ff       	call   103cdb <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  103dfb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103dfe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103e01:	29 d1                	sub    %edx,%ecx
  103e03:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  103e05:	89 d6                	mov    %edx,%esi
  103e07:	c1 e6 16             	shl    $0x16,%esi
  103e0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e0d:	89 d3                	mov    %edx,%ebx
  103e0f:	c1 e3 16             	shl    $0x16,%ebx
  103e12:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103e15:	89 d1                	mov    %edx,%ecx
  103e17:	c1 e1 16             	shl    $0x16,%ecx
  103e1a:	8b 7d dc             	mov    -0x24(%ebp),%edi
  103e1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103e20:	29 d7                	sub    %edx,%edi
  103e22:	89 fa                	mov    %edi,%edx
  103e24:	89 44 24 14          	mov    %eax,0x14(%esp)
  103e28:	89 74 24 10          	mov    %esi,0x10(%esp)
  103e2c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103e30:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  103e34:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e38:	c7 04 24 01 69 10 00 	movl   $0x106901,(%esp)
  103e3f:	e8 49 c4 ff ff       	call   10028d <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  103e44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e47:	c1 e0 0a             	shl    $0xa,%eax
  103e4a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  103e4d:	eb 54                	jmp    103ea3 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  103e4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103e52:	89 04 24             	mov    %eax,(%esp)
  103e55:	e8 81 fe ff ff       	call   103cdb <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  103e5a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103e5d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103e60:	29 d1                	sub    %edx,%ecx
  103e62:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  103e64:	89 d6                	mov    %edx,%esi
  103e66:	c1 e6 0c             	shl    $0xc,%esi
  103e69:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103e6c:	89 d3                	mov    %edx,%ebx
  103e6e:	c1 e3 0c             	shl    $0xc,%ebx
  103e71:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103e74:	89 d1                	mov    %edx,%ecx
  103e76:	c1 e1 0c             	shl    $0xc,%ecx
  103e79:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  103e7c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  103e7f:	29 d7                	sub    %edx,%edi
  103e81:	89 fa                	mov    %edi,%edx
  103e83:	89 44 24 14          	mov    %eax,0x14(%esp)
  103e87:	89 74 24 10          	mov    %esi,0x10(%esp)
  103e8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103e8f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  103e93:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e97:	c7 04 24 20 69 10 00 	movl   $0x106920,(%esp)
  103e9e:	e8 ea c3 ff ff       	call   10028d <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  103ea3:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  103ea8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103eab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103eae:	89 d3                	mov    %edx,%ebx
  103eb0:	c1 e3 0a             	shl    $0xa,%ebx
  103eb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103eb6:	89 d1                	mov    %edx,%ecx
  103eb8:	c1 e1 0a             	shl    $0xa,%ecx
  103ebb:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  103ebe:	89 54 24 14          	mov    %edx,0x14(%esp)
  103ec2:	8d 55 d8             	lea    -0x28(%ebp),%edx
  103ec5:	89 54 24 10          	mov    %edx,0x10(%esp)
  103ec9:	89 74 24 0c          	mov    %esi,0xc(%esp)
  103ecd:	89 44 24 08          	mov    %eax,0x8(%esp)
  103ed1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103ed5:	89 0c 24             	mov    %ecx,(%esp)
  103ed8:	e8 40 fe ff ff       	call   103d1d <get_pgtable_items>
  103edd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ee0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103ee4:	0f 85 65 ff ff ff    	jne    103e4f <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  103eea:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  103eef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ef2:	8d 55 dc             	lea    -0x24(%ebp),%edx
  103ef5:	89 54 24 14          	mov    %edx,0x14(%esp)
  103ef9:	8d 55 e0             	lea    -0x20(%ebp),%edx
  103efc:	89 54 24 10          	mov    %edx,0x10(%esp)
  103f00:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  103f04:	89 44 24 08          	mov    %eax,0x8(%esp)
  103f08:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  103f0f:	00 
  103f10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  103f17:	e8 01 fe ff ff       	call   103d1d <get_pgtable_items>
  103f1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103f1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f23:	0f 85 c7 fe ff ff    	jne    103df0 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  103f29:	c7 04 24 44 69 10 00 	movl   $0x106944,(%esp)
  103f30:	e8 58 c3 ff ff       	call   10028d <cprintf>
}
  103f35:	90                   	nop
  103f36:	83 c4 4c             	add    $0x4c,%esp
  103f39:	5b                   	pop    %ebx
  103f3a:	5e                   	pop    %esi
  103f3b:	5f                   	pop    %edi
  103f3c:	5d                   	pop    %ebp
  103f3d:	c3                   	ret    

00103f3e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103f3e:	55                   	push   %ebp
  103f3f:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103f41:	8b 45 08             	mov    0x8(%ebp),%eax
  103f44:	8b 15 18 af 11 00    	mov    0x11af18,%edx
  103f4a:	29 d0                	sub    %edx,%eax
  103f4c:	c1 f8 02             	sar    $0x2,%eax
  103f4f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103f55:	5d                   	pop    %ebp
  103f56:	c3                   	ret    

00103f57 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103f57:	55                   	push   %ebp
  103f58:	89 e5                	mov    %esp,%ebp
  103f5a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  103f60:	89 04 24             	mov    %eax,(%esp)
  103f63:	e8 d6 ff ff ff       	call   103f3e <page2ppn>
  103f68:	c1 e0 0c             	shl    $0xc,%eax
}
  103f6b:	c9                   	leave  
  103f6c:	c3                   	ret    

00103f6d <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103f6d:	55                   	push   %ebp
  103f6e:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103f70:	8b 45 08             	mov    0x8(%ebp),%eax
  103f73:	8b 00                	mov    (%eax),%eax
}
  103f75:	5d                   	pop    %ebp
  103f76:	c3                   	ret    

00103f77 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103f77:	55                   	push   %ebp
  103f78:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  103f7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f80:	89 10                	mov    %edx,(%eax)
}
  103f82:	90                   	nop
  103f83:	5d                   	pop    %ebp
  103f84:	c3                   	ret    

00103f85 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  103f85:	55                   	push   %ebp
  103f86:	89 e5                	mov    %esp,%ebp
  103f88:	83 ec 10             	sub    $0x10,%esp
  103f8b:	c7 45 fc 1c af 11 00 	movl   $0x11af1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103f92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  103f98:	89 50 04             	mov    %edx,0x4(%eax)
  103f9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f9e:	8b 50 04             	mov    0x4(%eax),%edx
  103fa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103fa4:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  103fa6:	c7 05 24 af 11 00 00 	movl   $0x0,0x11af24
  103fad:	00 00 00 
}
  103fb0:	90                   	nop
  103fb1:	c9                   	leave  
  103fb2:	c3                   	ret    

00103fb3 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  103fb3:	55                   	push   %ebp
  103fb4:	89 e5                	mov    %esp,%ebp
  103fb6:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  103fb9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103fbd:	75 24                	jne    103fe3 <default_init_memmap+0x30>
  103fbf:	c7 44 24 0c 78 69 10 	movl   $0x106978,0xc(%esp)
  103fc6:	00 
  103fc7:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  103fce:	00 
  103fcf:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  103fd6:	00 
  103fd7:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  103fde:	e8 01 c4 ff ff       	call   1003e4 <__panic>
    struct Page *p = base;
  103fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  103fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  103fe9:	eb 7d                	jmp    104068 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  103feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fee:	83 c0 04             	add    $0x4,%eax
  103ff1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  103ff8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103ffb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ffe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104001:	0f a3 10             	bt     %edx,(%eax)
  104004:	19 c0                	sbb    %eax,%eax
  104006:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return oldbit != 0;
  104009:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10400d:	0f 95 c0             	setne  %al
  104010:	0f b6 c0             	movzbl %al,%eax
  104013:	85 c0                	test   %eax,%eax
  104015:	75 24                	jne    10403b <default_init_memmap+0x88>
  104017:	c7 44 24 0c a9 69 10 	movl   $0x1069a9,0xc(%esp)
  10401e:	00 
  10401f:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104026:	00 
  104027:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  10402e:	00 
  10402f:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104036:	e8 a9 c3 ff ff       	call   1003e4 <__panic>
        p->flags = p->property = 0;
  10403b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10403e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104048:	8b 50 08             	mov    0x8(%eax),%edx
  10404b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10404e:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  104051:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104058:	00 
  104059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10405c:	89 04 24             	mov    %eax,(%esp)
  10405f:	e8 13 ff ff ff       	call   103f77 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  104064:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104068:	8b 55 0c             	mov    0xc(%ebp),%edx
  10406b:	89 d0                	mov    %edx,%eax
  10406d:	c1 e0 02             	shl    $0x2,%eax
  104070:	01 d0                	add    %edx,%eax
  104072:	c1 e0 02             	shl    $0x2,%eax
  104075:	89 c2                	mov    %eax,%edx
  104077:	8b 45 08             	mov    0x8(%ebp),%eax
  10407a:	01 d0                	add    %edx,%eax
  10407c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10407f:	0f 85 66 ff ff ff    	jne    103feb <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  104085:	8b 45 08             	mov    0x8(%ebp),%eax
  104088:	8b 55 0c             	mov    0xc(%ebp),%edx
  10408b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  10408e:	8b 45 08             	mov    0x8(%ebp),%eax
  104091:	83 c0 04             	add    $0x4,%eax
  104094:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  10409b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10409e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1040a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1040a4:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  1040a7:	8b 15 24 af 11 00    	mov    0x11af24,%edx
  1040ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1040b0:	01 d0                	add    %edx,%eax
  1040b2:	a3 24 af 11 00       	mov    %eax,0x11af24
    list_add(&free_list, &(base->page_link));
  1040b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1040ba:	83 c0 0c             	add    $0xc,%eax
  1040bd:	c7 45 f0 1c af 11 00 	movl   $0x11af1c,-0x10(%ebp)
  1040c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1040c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1040ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1040cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1040d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1040d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1040d6:	8b 40 04             	mov    0x4(%eax),%eax
  1040d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040dc:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1040df:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1040e2:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1040e5:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1040e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1040ee:	89 10                	mov    %edx,(%eax)
  1040f0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040f3:	8b 10                	mov    (%eax),%edx
  1040f5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1040f8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1040fb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040fe:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104101:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104104:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104107:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10410a:	89 10                	mov    %edx,(%eax)
}
  10410c:	90                   	nop
  10410d:	c9                   	leave  
  10410e:	c3                   	ret    

0010410f <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  10410f:	55                   	push   %ebp
  104110:	89 e5                	mov    %esp,%ebp
  104112:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  104115:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104119:	75 24                	jne    10413f <default_alloc_pages+0x30>
  10411b:	c7 44 24 0c 78 69 10 	movl   $0x106978,0xc(%esp)
  104122:	00 
  104123:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  10412a:	00 
  10412b:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  104132:	00 
  104133:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  10413a:	e8 a5 c2 ff ff       	call   1003e4 <__panic>
    if (n > nr_free) {
  10413f:	a1 24 af 11 00       	mov    0x11af24,%eax
  104144:	3b 45 08             	cmp    0x8(%ebp),%eax
  104147:	73 0a                	jae    104153 <default_alloc_pages+0x44>
        return NULL;
  104149:	b8 00 00 00 00       	mov    $0x0,%eax
  10414e:	e9 2a 01 00 00       	jmp    10427d <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
  104153:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  10415a:	c7 45 f0 1c af 11 00 	movl   $0x11af1c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104161:	eb 1c                	jmp    10417f <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  104163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104166:	83 e8 0c             	sub    $0xc,%eax
  104169:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (p->property >= n) {
  10416c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10416f:	8b 40 08             	mov    0x8(%eax),%eax
  104172:	3b 45 08             	cmp    0x8(%ebp),%eax
  104175:	72 08                	jb     10417f <default_alloc_pages+0x70>
            page = p;
  104177:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10417a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  10417d:	eb 18                	jmp    104197 <default_alloc_pages+0x88>
  10417f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104182:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104185:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104188:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10418b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10418e:	81 7d f0 1c af 11 00 	cmpl   $0x11af1c,-0x10(%ebp)
  104195:	75 cc                	jne    104163 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  104197:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10419b:	0f 84 d9 00 00 00    	je     10427a <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
  1041a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041a4:	83 c0 0c             	add    $0xc,%eax
  1041a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  1041aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041ad:	8b 40 04             	mov    0x4(%eax),%eax
  1041b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1041b3:	8b 12                	mov    (%edx),%edx
  1041b5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1041b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1041bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1041be:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1041c1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1041c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1041ca:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  1041cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041cf:	8b 40 08             	mov    0x8(%eax),%eax
  1041d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  1041d5:	76 7d                	jbe    104254 <default_alloc_pages+0x145>
            struct Page *p = page + n;
  1041d7:	8b 55 08             	mov    0x8(%ebp),%edx
  1041da:	89 d0                	mov    %edx,%eax
  1041dc:	c1 e0 02             	shl    $0x2,%eax
  1041df:	01 d0                	add    %edx,%eax
  1041e1:	c1 e0 02             	shl    $0x2,%eax
  1041e4:	89 c2                	mov    %eax,%edx
  1041e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041e9:	01 d0                	add    %edx,%eax
  1041eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
            p->property = page->property - n;
  1041ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041f1:	8b 40 08             	mov    0x8(%eax),%eax
  1041f4:	2b 45 08             	sub    0x8(%ebp),%eax
  1041f7:	89 c2                	mov    %eax,%edx
  1041f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1041fc:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
  1041ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104202:	83 c0 0c             	add    $0xc,%eax
  104205:	c7 45 e4 1c af 11 00 	movl   $0x11af1c,-0x1c(%ebp)
  10420c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  10420f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104212:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104215:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104218:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  10421b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10421e:	8b 40 04             	mov    0x4(%eax),%eax
  104221:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104224:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104227:	8b 55 c8             	mov    -0x38(%ebp),%edx
  10422a:	89 55 bc             	mov    %edx,-0x44(%ebp)
  10422d:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104230:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104233:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104236:	89 10                	mov    %edx,(%eax)
  104238:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10423b:	8b 10                	mov    (%eax),%edx
  10423d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104240:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104243:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104246:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104249:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10424c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10424f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104252:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
  104254:	a1 24 af 11 00       	mov    0x11af24,%eax
  104259:	2b 45 08             	sub    0x8(%ebp),%eax
  10425c:	a3 24 af 11 00       	mov    %eax,0x11af24
        ClearPageProperty(page);
  104261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104264:	83 c0 04             	add    $0x4,%eax
  104267:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  10426e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104271:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104274:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104277:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  10427a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10427d:	c9                   	leave  
  10427e:	c3                   	ret    

0010427f <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  10427f:	55                   	push   %ebp
  104280:	89 e5                	mov    %esp,%ebp
  104282:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  104288:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10428c:	75 24                	jne    1042b2 <default_free_pages+0x33>
  10428e:	c7 44 24 0c 78 69 10 	movl   $0x106978,0xc(%esp)
  104295:	00 
  104296:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  10429d:	00 
  10429e:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
  1042a5:	00 
  1042a6:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1042ad:	e8 32 c1 ff ff       	call   1003e4 <__panic>
    struct Page *p = base;
  1042b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1042b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1042b8:	e9 9d 00 00 00       	jmp    10435a <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  1042bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042c0:	83 c0 04             	add    $0x4,%eax
  1042c3:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  1042ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1042cd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1042d0:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1042d3:	0f a3 10             	bt     %edx,(%eax)
  1042d6:	19 c0                	sbb    %eax,%eax
  1042d8:	89 45 c0             	mov    %eax,-0x40(%ebp)
    return oldbit != 0;
  1042db:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  1042df:	0f 95 c0             	setne  %al
  1042e2:	0f b6 c0             	movzbl %al,%eax
  1042e5:	85 c0                	test   %eax,%eax
  1042e7:	75 2c                	jne    104315 <default_free_pages+0x96>
  1042e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042ec:	83 c0 04             	add    $0x4,%eax
  1042ef:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  1042f6:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1042f9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1042fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1042ff:	0f a3 10             	bt     %edx,(%eax)
  104302:	19 c0                	sbb    %eax,%eax
  104304:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104307:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  10430b:	0f 95 c0             	setne  %al
  10430e:	0f b6 c0             	movzbl %al,%eax
  104311:	85 c0                	test   %eax,%eax
  104313:	74 24                	je     104339 <default_free_pages+0xba>
  104315:	c7 44 24 0c bc 69 10 	movl   $0x1069bc,0xc(%esp)
  10431c:	00 
  10431d:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104324:	00 
  104325:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  10432c:	00 
  10432d:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104334:	e8 ab c0 ff ff       	call   1003e4 <__panic>
        p->flags = 0;
  104339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10433c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  104343:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10434a:	00 
  10434b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10434e:	89 04 24             	mov    %eax,(%esp)
  104351:	e8 21 fc ff ff       	call   103f77 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  104356:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10435a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10435d:	89 d0                	mov    %edx,%eax
  10435f:	c1 e0 02             	shl    $0x2,%eax
  104362:	01 d0                	add    %edx,%eax
  104364:	c1 e0 02             	shl    $0x2,%eax
  104367:	89 c2                	mov    %eax,%edx
  104369:	8b 45 08             	mov    0x8(%ebp),%eax
  10436c:	01 d0                	add    %edx,%eax
  10436e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104371:	0f 85 46 ff ff ff    	jne    1042bd <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  104377:	8b 45 08             	mov    0x8(%ebp),%eax
  10437a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10437d:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104380:	8b 45 08             	mov    0x8(%ebp),%eax
  104383:	83 c0 04             	add    $0x4,%eax
  104386:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10438d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104390:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104393:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104396:	0f ab 10             	bts    %edx,(%eax)
  104399:	c7 45 e8 1c af 11 00 	movl   $0x11af1c,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1043a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043a3:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  1043a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1043a9:	e9 08 01 00 00       	jmp    1044b6 <default_free_pages+0x237>
        p = le2page(le, page_link);
  1043ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043b1:	83 e8 0c             	sub    $0xc,%eax
  1043b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1043b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1043c0:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1043c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  1043c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1043c9:	8b 50 08             	mov    0x8(%eax),%edx
  1043cc:	89 d0                	mov    %edx,%eax
  1043ce:	c1 e0 02             	shl    $0x2,%eax
  1043d1:	01 d0                	add    %edx,%eax
  1043d3:	c1 e0 02             	shl    $0x2,%eax
  1043d6:	89 c2                	mov    %eax,%edx
  1043d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1043db:	01 d0                	add    %edx,%eax
  1043dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1043e0:	75 5a                	jne    10443c <default_free_pages+0x1bd>
            base->property += p->property;
  1043e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1043e5:	8b 50 08             	mov    0x8(%eax),%edx
  1043e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043eb:	8b 40 08             	mov    0x8(%eax),%eax
  1043ee:	01 c2                	add    %eax,%edx
  1043f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1043f3:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  1043f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043f9:	83 c0 04             	add    $0x4,%eax
  1043fc:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104403:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104406:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104409:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10440c:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  10440f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104412:	83 c0 0c             	add    $0xc,%eax
  104415:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  104418:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10441b:	8b 40 04             	mov    0x4(%eax),%eax
  10441e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104421:	8b 12                	mov    (%edx),%edx
  104423:	89 55 b0             	mov    %edx,-0x50(%ebp)
  104426:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104429:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10442c:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10442f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104432:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104435:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104438:	89 10                	mov    %edx,(%eax)
  10443a:	eb 7a                	jmp    1044b6 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  10443c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10443f:	8b 50 08             	mov    0x8(%eax),%edx
  104442:	89 d0                	mov    %edx,%eax
  104444:	c1 e0 02             	shl    $0x2,%eax
  104447:	01 d0                	add    %edx,%eax
  104449:	c1 e0 02             	shl    $0x2,%eax
  10444c:	89 c2                	mov    %eax,%edx
  10444e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104451:	01 d0                	add    %edx,%eax
  104453:	3b 45 08             	cmp    0x8(%ebp),%eax
  104456:	75 5e                	jne    1044b6 <default_free_pages+0x237>
            p->property += base->property;
  104458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10445b:	8b 50 08             	mov    0x8(%eax),%edx
  10445e:	8b 45 08             	mov    0x8(%ebp),%eax
  104461:	8b 40 08             	mov    0x8(%eax),%eax
  104464:	01 c2                	add    %eax,%edx
  104466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104469:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  10446c:	8b 45 08             	mov    0x8(%ebp),%eax
  10446f:	83 c0 04             	add    $0x4,%eax
  104472:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  104479:	89 45 9c             	mov    %eax,-0x64(%ebp)
  10447c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10447f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104482:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  104485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104488:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  10448b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10448e:	83 c0 0c             	add    $0xc,%eax
  104491:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  104494:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104497:	8b 40 04             	mov    0x4(%eax),%eax
  10449a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10449d:	8b 12                	mov    (%edx),%edx
  10449f:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  1044a2:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1044a5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1044a8:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1044ab:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1044ae:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1044b1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1044b4:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  1044b6:	81 7d f0 1c af 11 00 	cmpl   $0x11af1c,-0x10(%ebp)
  1044bd:	0f 85 eb fe ff ff    	jne    1043ae <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
  1044c3:	8b 15 24 af 11 00    	mov    0x11af24,%edx
  1044c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044cc:	01 d0                	add    %edx,%eax
  1044ce:	a3 24 af 11 00       	mov    %eax,0x11af24
    list_add(&free_list, &(base->page_link));
  1044d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d6:	83 c0 0c             	add    $0xc,%eax
  1044d9:	c7 45 d0 1c af 11 00 	movl   $0x11af1c,-0x30(%ebp)
  1044e0:	89 45 98             	mov    %eax,-0x68(%ebp)
  1044e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1044e6:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1044e9:	8b 45 98             	mov    -0x68(%ebp),%eax
  1044ec:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1044ef:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1044f2:	8b 40 04             	mov    0x4(%eax),%eax
  1044f5:	8b 55 90             	mov    -0x70(%ebp),%edx
  1044f8:	89 55 8c             	mov    %edx,-0x74(%ebp)
  1044fb:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1044fe:	89 55 88             	mov    %edx,-0x78(%ebp)
  104501:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  104504:	8b 45 84             	mov    -0x7c(%ebp),%eax
  104507:	8b 55 8c             	mov    -0x74(%ebp),%edx
  10450a:	89 10                	mov    %edx,(%eax)
  10450c:	8b 45 84             	mov    -0x7c(%ebp),%eax
  10450f:	8b 10                	mov    (%eax),%edx
  104511:	8b 45 88             	mov    -0x78(%ebp),%eax
  104514:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104517:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10451a:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10451d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104520:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104523:	8b 55 88             	mov    -0x78(%ebp),%edx
  104526:	89 10                	mov    %edx,(%eax)
}
  104528:	90                   	nop
  104529:	c9                   	leave  
  10452a:	c3                   	ret    

0010452b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10452b:	55                   	push   %ebp
  10452c:	89 e5                	mov    %esp,%ebp
    return nr_free;
  10452e:	a1 24 af 11 00       	mov    0x11af24,%eax
}
  104533:	5d                   	pop    %ebp
  104534:	c3                   	ret    

00104535 <basic_check>:

static void
basic_check(void) {
  104535:	55                   	push   %ebp
  104536:	89 e5                	mov    %esp,%ebp
  104538:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10453b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104545:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10454b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  10454e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104555:	e8 d3 e4 ff ff       	call   102a2d <alloc_pages>
  10455a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10455d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104561:	75 24                	jne    104587 <basic_check+0x52>
  104563:	c7 44 24 0c e1 69 10 	movl   $0x1069e1,0xc(%esp)
  10456a:	00 
  10456b:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104572:	00 
  104573:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  10457a:	00 
  10457b:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104582:	e8 5d be ff ff       	call   1003e4 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104587:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10458e:	e8 9a e4 ff ff       	call   102a2d <alloc_pages>
  104593:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104596:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10459a:	75 24                	jne    1045c0 <basic_check+0x8b>
  10459c:	c7 44 24 0c fd 69 10 	movl   $0x1069fd,0xc(%esp)
  1045a3:	00 
  1045a4:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  1045ab:	00 
  1045ac:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  1045b3:	00 
  1045b4:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1045bb:	e8 24 be ff ff       	call   1003e4 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1045c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1045c7:	e8 61 e4 ff ff       	call   102a2d <alloc_pages>
  1045cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1045cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1045d3:	75 24                	jne    1045f9 <basic_check+0xc4>
  1045d5:	c7 44 24 0c 19 6a 10 	movl   $0x106a19,0xc(%esp)
  1045dc:	00 
  1045dd:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  1045e4:	00 
  1045e5:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  1045ec:	00 
  1045ed:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1045f4:	e8 eb bd ff ff       	call   1003e4 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1045f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1045ff:	74 10                	je     104611 <basic_check+0xdc>
  104601:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104604:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104607:	74 08                	je     104611 <basic_check+0xdc>
  104609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10460c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10460f:	75 24                	jne    104635 <basic_check+0x100>
  104611:	c7 44 24 0c 38 6a 10 	movl   $0x106a38,0xc(%esp)
  104618:	00 
  104619:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104620:	00 
  104621:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  104628:	00 
  104629:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104630:	e8 af bd ff ff       	call   1003e4 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104638:	89 04 24             	mov    %eax,(%esp)
  10463b:	e8 2d f9 ff ff       	call   103f6d <page_ref>
  104640:	85 c0                	test   %eax,%eax
  104642:	75 1e                	jne    104662 <basic_check+0x12d>
  104644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104647:	89 04 24             	mov    %eax,(%esp)
  10464a:	e8 1e f9 ff ff       	call   103f6d <page_ref>
  10464f:	85 c0                	test   %eax,%eax
  104651:	75 0f                	jne    104662 <basic_check+0x12d>
  104653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104656:	89 04 24             	mov    %eax,(%esp)
  104659:	e8 0f f9 ff ff       	call   103f6d <page_ref>
  10465e:	85 c0                	test   %eax,%eax
  104660:	74 24                	je     104686 <basic_check+0x151>
  104662:	c7 44 24 0c 5c 6a 10 	movl   $0x106a5c,0xc(%esp)
  104669:	00 
  10466a:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104671:	00 
  104672:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  104679:	00 
  10467a:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104681:	e8 5e bd ff ff       	call   1003e4 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104686:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104689:	89 04 24             	mov    %eax,(%esp)
  10468c:	e8 c6 f8 ff ff       	call   103f57 <page2pa>
  104691:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  104697:	c1 e2 0c             	shl    $0xc,%edx
  10469a:	39 d0                	cmp    %edx,%eax
  10469c:	72 24                	jb     1046c2 <basic_check+0x18d>
  10469e:	c7 44 24 0c 98 6a 10 	movl   $0x106a98,0xc(%esp)
  1046a5:	00 
  1046a6:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  1046ad:	00 
  1046ae:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  1046b5:	00 
  1046b6:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1046bd:	e8 22 bd ff ff       	call   1003e4 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1046c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046c5:	89 04 24             	mov    %eax,(%esp)
  1046c8:	e8 8a f8 ff ff       	call   103f57 <page2pa>
  1046cd:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  1046d3:	c1 e2 0c             	shl    $0xc,%edx
  1046d6:	39 d0                	cmp    %edx,%eax
  1046d8:	72 24                	jb     1046fe <basic_check+0x1c9>
  1046da:	c7 44 24 0c b5 6a 10 	movl   $0x106ab5,0xc(%esp)
  1046e1:	00 
  1046e2:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  1046e9:	00 
  1046ea:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  1046f1:	00 
  1046f2:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1046f9:	e8 e6 bc ff ff       	call   1003e4 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1046fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104701:	89 04 24             	mov    %eax,(%esp)
  104704:	e8 4e f8 ff ff       	call   103f57 <page2pa>
  104709:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  10470f:	c1 e2 0c             	shl    $0xc,%edx
  104712:	39 d0                	cmp    %edx,%eax
  104714:	72 24                	jb     10473a <basic_check+0x205>
  104716:	c7 44 24 0c d2 6a 10 	movl   $0x106ad2,0xc(%esp)
  10471d:	00 
  10471e:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104725:	00 
  104726:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  10472d:	00 
  10472e:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104735:	e8 aa bc ff ff       	call   1003e4 <__panic>

    list_entry_t free_list_store = free_list;
  10473a:	a1 1c af 11 00       	mov    0x11af1c,%eax
  10473f:	8b 15 20 af 11 00    	mov    0x11af20,%edx
  104745:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104748:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10474b:	c7 45 e4 1c af 11 00 	movl   $0x11af1c,-0x1c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104752:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104758:	89 50 04             	mov    %edx,0x4(%eax)
  10475b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10475e:	8b 50 04             	mov    0x4(%eax),%edx
  104761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104764:	89 10                	mov    %edx,(%eax)
  104766:	c7 45 d8 1c af 11 00 	movl   $0x11af1c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10476d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104770:	8b 40 04             	mov    0x4(%eax),%eax
  104773:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104776:	0f 94 c0             	sete   %al
  104779:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10477c:	85 c0                	test   %eax,%eax
  10477e:	75 24                	jne    1047a4 <basic_check+0x26f>
  104780:	c7 44 24 0c ef 6a 10 	movl   $0x106aef,0xc(%esp)
  104787:	00 
  104788:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  10478f:	00 
  104790:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  104797:	00 
  104798:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  10479f:	e8 40 bc ff ff       	call   1003e4 <__panic>

    unsigned int nr_free_store = nr_free;
  1047a4:	a1 24 af 11 00       	mov    0x11af24,%eax
  1047a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1047ac:	c7 05 24 af 11 00 00 	movl   $0x0,0x11af24
  1047b3:	00 00 00 

    assert(alloc_page() == NULL);
  1047b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1047bd:	e8 6b e2 ff ff       	call   102a2d <alloc_pages>
  1047c2:	85 c0                	test   %eax,%eax
  1047c4:	74 24                	je     1047ea <basic_check+0x2b5>
  1047c6:	c7 44 24 0c 06 6b 10 	movl   $0x106b06,0xc(%esp)
  1047cd:	00 
  1047ce:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  1047d5:	00 
  1047d6:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  1047dd:	00 
  1047de:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1047e5:	e8 fa bb ff ff       	call   1003e4 <__panic>

    free_page(p0);
  1047ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1047f1:	00 
  1047f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047f5:	89 04 24             	mov    %eax,(%esp)
  1047f8:	e8 68 e2 ff ff       	call   102a65 <free_pages>
    free_page(p1);
  1047fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104804:	00 
  104805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104808:	89 04 24             	mov    %eax,(%esp)
  10480b:	e8 55 e2 ff ff       	call   102a65 <free_pages>
    free_page(p2);
  104810:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104817:	00 
  104818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10481b:	89 04 24             	mov    %eax,(%esp)
  10481e:	e8 42 e2 ff ff       	call   102a65 <free_pages>
    assert(nr_free == 3);
  104823:	a1 24 af 11 00       	mov    0x11af24,%eax
  104828:	83 f8 03             	cmp    $0x3,%eax
  10482b:	74 24                	je     104851 <basic_check+0x31c>
  10482d:	c7 44 24 0c 1b 6b 10 	movl   $0x106b1b,0xc(%esp)
  104834:	00 
  104835:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  10483c:	00 
  10483d:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  104844:	00 
  104845:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  10484c:	e8 93 bb ff ff       	call   1003e4 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104851:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104858:	e8 d0 e1 ff ff       	call   102a2d <alloc_pages>
  10485d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104860:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104864:	75 24                	jne    10488a <basic_check+0x355>
  104866:	c7 44 24 0c e1 69 10 	movl   $0x1069e1,0xc(%esp)
  10486d:	00 
  10486e:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104875:	00 
  104876:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  10487d:	00 
  10487e:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104885:	e8 5a bb ff ff       	call   1003e4 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10488a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104891:	e8 97 e1 ff ff       	call   102a2d <alloc_pages>
  104896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104899:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10489d:	75 24                	jne    1048c3 <basic_check+0x38e>
  10489f:	c7 44 24 0c fd 69 10 	movl   $0x1069fd,0xc(%esp)
  1048a6:	00 
  1048a7:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  1048ae:	00 
  1048af:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  1048b6:	00 
  1048b7:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1048be:	e8 21 bb ff ff       	call   1003e4 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1048c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048ca:	e8 5e e1 ff ff       	call   102a2d <alloc_pages>
  1048cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1048d6:	75 24                	jne    1048fc <basic_check+0x3c7>
  1048d8:	c7 44 24 0c 19 6a 10 	movl   $0x106a19,0xc(%esp)
  1048df:	00 
  1048e0:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  1048e7:	00 
  1048e8:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  1048ef:	00 
  1048f0:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1048f7:	e8 e8 ba ff ff       	call   1003e4 <__panic>

    assert(alloc_page() == NULL);
  1048fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104903:	e8 25 e1 ff ff       	call   102a2d <alloc_pages>
  104908:	85 c0                	test   %eax,%eax
  10490a:	74 24                	je     104930 <basic_check+0x3fb>
  10490c:	c7 44 24 0c 06 6b 10 	movl   $0x106b06,0xc(%esp)
  104913:	00 
  104914:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  10491b:	00 
  10491c:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104923:	00 
  104924:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  10492b:	e8 b4 ba ff ff       	call   1003e4 <__panic>

    free_page(p0);
  104930:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104937:	00 
  104938:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10493b:	89 04 24             	mov    %eax,(%esp)
  10493e:	e8 22 e1 ff ff       	call   102a65 <free_pages>
  104943:	c7 45 e8 1c af 11 00 	movl   $0x11af1c,-0x18(%ebp)
  10494a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10494d:	8b 40 04             	mov    0x4(%eax),%eax
  104950:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104953:	0f 94 c0             	sete   %al
  104956:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104959:	85 c0                	test   %eax,%eax
  10495b:	74 24                	je     104981 <basic_check+0x44c>
  10495d:	c7 44 24 0c 28 6b 10 	movl   $0x106b28,0xc(%esp)
  104964:	00 
  104965:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  10496c:	00 
  10496d:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  104974:	00 
  104975:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  10497c:	e8 63 ba ff ff       	call   1003e4 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104981:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104988:	e8 a0 e0 ff ff       	call   102a2d <alloc_pages>
  10498d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104990:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104993:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104996:	74 24                	je     1049bc <basic_check+0x487>
  104998:	c7 44 24 0c 40 6b 10 	movl   $0x106b40,0xc(%esp)
  10499f:	00 
  1049a0:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  1049a7:	00 
  1049a8:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  1049af:	00 
  1049b0:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1049b7:	e8 28 ba ff ff       	call   1003e4 <__panic>
    assert(alloc_page() == NULL);
  1049bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1049c3:	e8 65 e0 ff ff       	call   102a2d <alloc_pages>
  1049c8:	85 c0                	test   %eax,%eax
  1049ca:	74 24                	je     1049f0 <basic_check+0x4bb>
  1049cc:	c7 44 24 0c 06 6b 10 	movl   $0x106b06,0xc(%esp)
  1049d3:	00 
  1049d4:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  1049db:	00 
  1049dc:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  1049e3:	00 
  1049e4:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1049eb:	e8 f4 b9 ff ff       	call   1003e4 <__panic>

    assert(nr_free == 0);
  1049f0:	a1 24 af 11 00       	mov    0x11af24,%eax
  1049f5:	85 c0                	test   %eax,%eax
  1049f7:	74 24                	je     104a1d <basic_check+0x4e8>
  1049f9:	c7 44 24 0c 59 6b 10 	movl   $0x106b59,0xc(%esp)
  104a00:	00 
  104a01:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104a08:	00 
  104a09:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  104a10:	00 
  104a11:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104a18:	e8 c7 b9 ff ff       	call   1003e4 <__panic>
    free_list = free_list_store;
  104a1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104a20:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104a23:	a3 1c af 11 00       	mov    %eax,0x11af1c
  104a28:	89 15 20 af 11 00    	mov    %edx,0x11af20
    nr_free = nr_free_store;
  104a2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104a31:	a3 24 af 11 00       	mov    %eax,0x11af24

    free_page(p);
  104a36:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104a3d:	00 
  104a3e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a41:	89 04 24             	mov    %eax,(%esp)
  104a44:	e8 1c e0 ff ff       	call   102a65 <free_pages>
    free_page(p1);
  104a49:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104a50:	00 
  104a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a54:	89 04 24             	mov    %eax,(%esp)
  104a57:	e8 09 e0 ff ff       	call   102a65 <free_pages>
    free_page(p2);
  104a5c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104a63:	00 
  104a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a67:	89 04 24             	mov    %eax,(%esp)
  104a6a:	e8 f6 df ff ff       	call   102a65 <free_pages>
}
  104a6f:	90                   	nop
  104a70:	c9                   	leave  
  104a71:	c3                   	ret    

00104a72 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104a72:	55                   	push   %ebp
  104a73:	89 e5                	mov    %esp,%ebp
  104a75:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  104a7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104a82:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104a89:	c7 45 ec 1c af 11 00 	movl   $0x11af1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104a90:	eb 6a                	jmp    104afc <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  104a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a95:	83 e8 0c             	sub    $0xc,%eax
  104a98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
  104a9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a9e:	83 c0 04             	add    $0x4,%eax
  104aa1:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  104aa8:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104aab:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104aae:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104ab1:	0f a3 10             	bt     %edx,(%eax)
  104ab4:	19 c0                	sbb    %eax,%eax
  104ab6:	89 45 a8             	mov    %eax,-0x58(%ebp)
    return oldbit != 0;
  104ab9:	83 7d a8 00          	cmpl   $0x0,-0x58(%ebp)
  104abd:	0f 95 c0             	setne  %al
  104ac0:	0f b6 c0             	movzbl %al,%eax
  104ac3:	85 c0                	test   %eax,%eax
  104ac5:	75 24                	jne    104aeb <default_check+0x79>
  104ac7:	c7 44 24 0c 66 6b 10 	movl   $0x106b66,0xc(%esp)
  104ace:	00 
  104acf:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104ad6:	00 
  104ad7:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  104ade:	00 
  104adf:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104ae6:	e8 f9 b8 ff ff       	call   1003e4 <__panic>
        count ++, total += p->property;
  104aeb:	ff 45 f4             	incl   -0xc(%ebp)
  104aee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104af1:	8b 50 08             	mov    0x8(%eax),%edx
  104af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104af7:	01 d0                	add    %edx,%eax
  104af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104aff:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  104b02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104b05:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  104b08:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b0b:	81 7d ec 1c af 11 00 	cmpl   $0x11af1c,-0x14(%ebp)
  104b12:	0f 85 7a ff ff ff    	jne    104a92 <default_check+0x20>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  104b18:	e8 7b df ff ff       	call   102a98 <nr_free_pages>
  104b1d:	89 c2                	mov    %eax,%edx
  104b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b22:	39 c2                	cmp    %eax,%edx
  104b24:	74 24                	je     104b4a <default_check+0xd8>
  104b26:	c7 44 24 0c 76 6b 10 	movl   $0x106b76,0xc(%esp)
  104b2d:	00 
  104b2e:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104b35:	00 
  104b36:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  104b3d:	00 
  104b3e:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104b45:	e8 9a b8 ff ff       	call   1003e4 <__panic>

    basic_check();
  104b4a:	e8 e6 f9 ff ff       	call   104535 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104b4f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104b56:	e8 d2 de ff ff       	call   102a2d <alloc_pages>
  104b5b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    assert(p0 != NULL);
  104b5e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104b62:	75 24                	jne    104b88 <default_check+0x116>
  104b64:	c7 44 24 0c 8f 6b 10 	movl   $0x106b8f,0xc(%esp)
  104b6b:	00 
  104b6c:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104b73:	00 
  104b74:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  104b7b:	00 
  104b7c:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104b83:	e8 5c b8 ff ff       	call   1003e4 <__panic>
    assert(!PageProperty(p0));
  104b88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104b8b:	83 c0 04             	add    $0x4,%eax
  104b8e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
  104b95:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104b98:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104b9b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  104b9e:	0f a3 10             	bt     %edx,(%eax)
  104ba1:	19 c0                	sbb    %eax,%eax
  104ba3:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return oldbit != 0;
  104ba6:	83 7d a0 00          	cmpl   $0x0,-0x60(%ebp)
  104baa:	0f 95 c0             	setne  %al
  104bad:	0f b6 c0             	movzbl %al,%eax
  104bb0:	85 c0                	test   %eax,%eax
  104bb2:	74 24                	je     104bd8 <default_check+0x166>
  104bb4:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  104bbb:	00 
  104bbc:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104bc3:	00 
  104bc4:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  104bcb:	00 
  104bcc:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104bd3:	e8 0c b8 ff ff       	call   1003e4 <__panic>

    list_entry_t free_list_store = free_list;
  104bd8:	a1 1c af 11 00       	mov    0x11af1c,%eax
  104bdd:	8b 15 20 af 11 00    	mov    0x11af20,%edx
  104be3:	89 45 80             	mov    %eax,-0x80(%ebp)
  104be6:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104be9:	c7 45 d0 1c af 11 00 	movl   $0x11af1c,-0x30(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104bf0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104bf3:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104bf6:	89 50 04             	mov    %edx,0x4(%eax)
  104bf9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104bfc:	8b 50 04             	mov    0x4(%eax),%edx
  104bff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104c02:	89 10                	mov    %edx,(%eax)
  104c04:	c7 45 d8 1c af 11 00 	movl   $0x11af1c,-0x28(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  104c0b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104c0e:	8b 40 04             	mov    0x4(%eax),%eax
  104c11:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104c14:	0f 94 c0             	sete   %al
  104c17:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104c1a:	85 c0                	test   %eax,%eax
  104c1c:	75 24                	jne    104c42 <default_check+0x1d0>
  104c1e:	c7 44 24 0c ef 6a 10 	movl   $0x106aef,0xc(%esp)
  104c25:	00 
  104c26:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104c2d:	00 
  104c2e:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  104c35:	00 
  104c36:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104c3d:	e8 a2 b7 ff ff       	call   1003e4 <__panic>
    assert(alloc_page() == NULL);
  104c42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c49:	e8 df dd ff ff       	call   102a2d <alloc_pages>
  104c4e:	85 c0                	test   %eax,%eax
  104c50:	74 24                	je     104c76 <default_check+0x204>
  104c52:	c7 44 24 0c 06 6b 10 	movl   $0x106b06,0xc(%esp)
  104c59:	00 
  104c5a:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104c61:	00 
  104c62:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  104c69:	00 
  104c6a:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104c71:	e8 6e b7 ff ff       	call   1003e4 <__panic>

    unsigned int nr_free_store = nr_free;
  104c76:	a1 24 af 11 00       	mov    0x11af24,%eax
  104c7b:	89 45 cc             	mov    %eax,-0x34(%ebp)
    nr_free = 0;
  104c7e:	c7 05 24 af 11 00 00 	movl   $0x0,0x11af24
  104c85:	00 00 00 

    free_pages(p0 + 2, 3);
  104c88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c8b:	83 c0 28             	add    $0x28,%eax
  104c8e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  104c95:	00 
  104c96:	89 04 24             	mov    %eax,(%esp)
  104c99:	e8 c7 dd ff ff       	call   102a65 <free_pages>
    assert(alloc_pages(4) == NULL);
  104c9e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  104ca5:	e8 83 dd ff ff       	call   102a2d <alloc_pages>
  104caa:	85 c0                	test   %eax,%eax
  104cac:	74 24                	je     104cd2 <default_check+0x260>
  104cae:	c7 44 24 0c ac 6b 10 	movl   $0x106bac,0xc(%esp)
  104cb5:	00 
  104cb6:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104cbd:	00 
  104cbe:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  104cc5:	00 
  104cc6:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104ccd:	e8 12 b7 ff ff       	call   1003e4 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104cd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104cd5:	83 c0 28             	add    $0x28,%eax
  104cd8:	83 c0 04             	add    $0x4,%eax
  104cdb:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104ce2:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104ce5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104ce8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104ceb:	0f a3 10             	bt     %edx,(%eax)
  104cee:	19 c0                	sbb    %eax,%eax
  104cf0:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  104cf3:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  104cf7:	0f 95 c0             	setne  %al
  104cfa:	0f b6 c0             	movzbl %al,%eax
  104cfd:	85 c0                	test   %eax,%eax
  104cff:	74 0e                	je     104d0f <default_check+0x29d>
  104d01:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d04:	83 c0 28             	add    $0x28,%eax
  104d07:	8b 40 08             	mov    0x8(%eax),%eax
  104d0a:	83 f8 03             	cmp    $0x3,%eax
  104d0d:	74 24                	je     104d33 <default_check+0x2c1>
  104d0f:	c7 44 24 0c c4 6b 10 	movl   $0x106bc4,0xc(%esp)
  104d16:	00 
  104d17:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104d1e:	00 
  104d1f:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104d26:	00 
  104d27:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104d2e:	e8 b1 b6 ff ff       	call   1003e4 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  104d33:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  104d3a:	e8 ee dc ff ff       	call   102a2d <alloc_pages>
  104d3f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  104d42:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  104d46:	75 24                	jne    104d6c <default_check+0x2fa>
  104d48:	c7 44 24 0c f0 6b 10 	movl   $0x106bf0,0xc(%esp)
  104d4f:	00 
  104d50:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104d57:	00 
  104d58:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  104d5f:	00 
  104d60:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104d67:	e8 78 b6 ff ff       	call   1003e4 <__panic>
    assert(alloc_page() == NULL);
  104d6c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d73:	e8 b5 dc ff ff       	call   102a2d <alloc_pages>
  104d78:	85 c0                	test   %eax,%eax
  104d7a:	74 24                	je     104da0 <default_check+0x32e>
  104d7c:	c7 44 24 0c 06 6b 10 	movl   $0x106b06,0xc(%esp)
  104d83:	00 
  104d84:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104d8b:	00 
  104d8c:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  104d93:	00 
  104d94:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104d9b:	e8 44 b6 ff ff       	call   1003e4 <__panic>
    assert(p0 + 2 == p1);
  104da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104da3:	83 c0 28             	add    $0x28,%eax
  104da6:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  104da9:	74 24                	je     104dcf <default_check+0x35d>
  104dab:	c7 44 24 0c 0e 6c 10 	movl   $0x106c0e,0xc(%esp)
  104db2:	00 
  104db3:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104dba:	00 
  104dbb:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  104dc2:	00 
  104dc3:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104dca:	e8 15 b6 ff ff       	call   1003e4 <__panic>

    p2 = p0 + 1;
  104dcf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104dd2:	83 c0 14             	add    $0x14,%eax
  104dd5:	89 45 c0             	mov    %eax,-0x40(%ebp)
    free_page(p0);
  104dd8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ddf:	00 
  104de0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104de3:	89 04 24             	mov    %eax,(%esp)
  104de6:	e8 7a dc ff ff       	call   102a65 <free_pages>
    free_pages(p1, 3);
  104deb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  104df2:	00 
  104df3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104df6:	89 04 24             	mov    %eax,(%esp)
  104df9:	e8 67 dc ff ff       	call   102a65 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  104dfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104e01:	83 c0 04             	add    $0x4,%eax
  104e04:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  104e0b:	89 45 94             	mov    %eax,-0x6c(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104e0e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104e11:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104e14:	0f a3 10             	bt     %edx,(%eax)
  104e17:	19 c0                	sbb    %eax,%eax
  104e19:	89 45 90             	mov    %eax,-0x70(%ebp)
    return oldbit != 0;
  104e1c:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
  104e20:	0f 95 c0             	setne  %al
  104e23:	0f b6 c0             	movzbl %al,%eax
  104e26:	85 c0                	test   %eax,%eax
  104e28:	74 0b                	je     104e35 <default_check+0x3c3>
  104e2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104e2d:	8b 40 08             	mov    0x8(%eax),%eax
  104e30:	83 f8 01             	cmp    $0x1,%eax
  104e33:	74 24                	je     104e59 <default_check+0x3e7>
  104e35:	c7 44 24 0c 1c 6c 10 	movl   $0x106c1c,0xc(%esp)
  104e3c:	00 
  104e3d:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104e44:	00 
  104e45:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  104e4c:	00 
  104e4d:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104e54:	e8 8b b5 ff ff       	call   1003e4 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  104e59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104e5c:	83 c0 04             	add    $0x4,%eax
  104e5f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  104e66:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104e69:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104e6c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104e6f:	0f a3 10             	bt     %edx,(%eax)
  104e72:	19 c0                	sbb    %eax,%eax
  104e74:	89 45 88             	mov    %eax,-0x78(%ebp)
    return oldbit != 0;
  104e77:	83 7d 88 00          	cmpl   $0x0,-0x78(%ebp)
  104e7b:	0f 95 c0             	setne  %al
  104e7e:	0f b6 c0             	movzbl %al,%eax
  104e81:	85 c0                	test   %eax,%eax
  104e83:	74 0b                	je     104e90 <default_check+0x41e>
  104e85:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104e88:	8b 40 08             	mov    0x8(%eax),%eax
  104e8b:	83 f8 03             	cmp    $0x3,%eax
  104e8e:	74 24                	je     104eb4 <default_check+0x442>
  104e90:	c7 44 24 0c 44 6c 10 	movl   $0x106c44,0xc(%esp)
  104e97:	00 
  104e98:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104e9f:	00 
  104ea0:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  104ea7:	00 
  104ea8:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104eaf:	e8 30 b5 ff ff       	call   1003e4 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  104eb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ebb:	e8 6d db ff ff       	call   102a2d <alloc_pages>
  104ec0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104ec3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104ec6:	83 e8 14             	sub    $0x14,%eax
  104ec9:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104ecc:	74 24                	je     104ef2 <default_check+0x480>
  104ece:	c7 44 24 0c 6a 6c 10 	movl   $0x106c6a,0xc(%esp)
  104ed5:	00 
  104ed6:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104edd:	00 
  104ede:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  104ee5:	00 
  104ee6:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104eed:	e8 f2 b4 ff ff       	call   1003e4 <__panic>
    free_page(p0);
  104ef2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ef9:	00 
  104efa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104efd:	89 04 24             	mov    %eax,(%esp)
  104f00:	e8 60 db ff ff       	call   102a65 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  104f05:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  104f0c:	e8 1c db ff ff       	call   102a2d <alloc_pages>
  104f11:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104f14:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104f17:	83 c0 14             	add    $0x14,%eax
  104f1a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104f1d:	74 24                	je     104f43 <default_check+0x4d1>
  104f1f:	c7 44 24 0c 88 6c 10 	movl   $0x106c88,0xc(%esp)
  104f26:	00 
  104f27:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104f2e:	00 
  104f2f:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  104f36:	00 
  104f37:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104f3e:	e8 a1 b4 ff ff       	call   1003e4 <__panic>

    free_pages(p0, 2);
  104f43:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  104f4a:	00 
  104f4b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f4e:	89 04 24             	mov    %eax,(%esp)
  104f51:	e8 0f db ff ff       	call   102a65 <free_pages>
    free_page(p2);
  104f56:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f5d:	00 
  104f5e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104f61:	89 04 24             	mov    %eax,(%esp)
  104f64:	e8 fc da ff ff       	call   102a65 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  104f69:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104f70:	e8 b8 da ff ff       	call   102a2d <alloc_pages>
  104f75:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104f78:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104f7c:	75 24                	jne    104fa2 <default_check+0x530>
  104f7e:	c7 44 24 0c a8 6c 10 	movl   $0x106ca8,0xc(%esp)
  104f85:	00 
  104f86:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104f8d:	00 
  104f8e:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  104f95:	00 
  104f96:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104f9d:	e8 42 b4 ff ff       	call   1003e4 <__panic>
    assert(alloc_page() == NULL);
  104fa2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fa9:	e8 7f da ff ff       	call   102a2d <alloc_pages>
  104fae:	85 c0                	test   %eax,%eax
  104fb0:	74 24                	je     104fd6 <default_check+0x564>
  104fb2:	c7 44 24 0c 06 6b 10 	movl   $0x106b06,0xc(%esp)
  104fb9:	00 
  104fba:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104fc1:	00 
  104fc2:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  104fc9:	00 
  104fca:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104fd1:	e8 0e b4 ff ff       	call   1003e4 <__panic>

    assert(nr_free == 0);
  104fd6:	a1 24 af 11 00       	mov    0x11af24,%eax
  104fdb:	85 c0                	test   %eax,%eax
  104fdd:	74 24                	je     105003 <default_check+0x591>
  104fdf:	c7 44 24 0c 59 6b 10 	movl   $0x106b59,0xc(%esp)
  104fe6:	00 
  104fe7:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  104fee:	00 
  104fef:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  104ff6:	00 
  104ff7:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  104ffe:	e8 e1 b3 ff ff       	call   1003e4 <__panic>
    nr_free = nr_free_store;
  105003:	8b 45 cc             	mov    -0x34(%ebp),%eax
  105006:	a3 24 af 11 00       	mov    %eax,0x11af24

    free_list = free_list_store;
  10500b:	8b 45 80             	mov    -0x80(%ebp),%eax
  10500e:	8b 55 84             	mov    -0x7c(%ebp),%edx
  105011:	a3 1c af 11 00       	mov    %eax,0x11af1c
  105016:	89 15 20 af 11 00    	mov    %edx,0x11af20
    free_pages(p0, 5);
  10501c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  105023:	00 
  105024:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105027:	89 04 24             	mov    %eax,(%esp)
  10502a:	e8 36 da ff ff       	call   102a65 <free_pages>

    le = &free_list;
  10502f:	c7 45 ec 1c af 11 00 	movl   $0x11af1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105036:	eb 5a                	jmp    105092 <default_check+0x620>
        assert(le->next->prev == le && le->prev->next == le);
  105038:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10503b:	8b 40 04             	mov    0x4(%eax),%eax
  10503e:	8b 00                	mov    (%eax),%eax
  105040:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105043:	75 0d                	jne    105052 <default_check+0x5e0>
  105045:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105048:	8b 00                	mov    (%eax),%eax
  10504a:	8b 40 04             	mov    0x4(%eax),%eax
  10504d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105050:	74 24                	je     105076 <default_check+0x604>
  105052:	c7 44 24 0c c8 6c 10 	movl   $0x106cc8,0xc(%esp)
  105059:	00 
  10505a:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  105061:	00 
  105062:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  105069:	00 
  10506a:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  105071:	e8 6e b3 ff ff       	call   1003e4 <__panic>
        struct Page *p = le2page(le, page_link);
  105076:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105079:	83 e8 0c             	sub    $0xc,%eax
  10507c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        count --, total -= p->property;
  10507f:	ff 4d f4             	decl   -0xc(%ebp)
  105082:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105085:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  105088:	8b 40 08             	mov    0x8(%eax),%eax
  10508b:	29 c2                	sub    %eax,%edx
  10508d:	89 d0                	mov    %edx,%eax
  10508f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105095:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  105098:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10509b:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10509e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1050a1:	81 7d ec 1c af 11 00 	cmpl   $0x11af1c,-0x14(%ebp)
  1050a8:	75 8e                	jne    105038 <default_check+0x5c6>
        assert(le->next->prev == le && le->prev->next == le);
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  1050aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1050ae:	74 24                	je     1050d4 <default_check+0x662>
  1050b0:	c7 44 24 0c f5 6c 10 	movl   $0x106cf5,0xc(%esp)
  1050b7:	00 
  1050b8:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  1050bf:	00 
  1050c0:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  1050c7:	00 
  1050c8:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1050cf:	e8 10 b3 ff ff       	call   1003e4 <__panic>
    assert(total == 0);
  1050d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1050d8:	74 24                	je     1050fe <default_check+0x68c>
  1050da:	c7 44 24 0c 00 6d 10 	movl   $0x106d00,0xc(%esp)
  1050e1:	00 
  1050e2:	c7 44 24 08 7e 69 10 	movl   $0x10697e,0x8(%esp)
  1050e9:	00 
  1050ea:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1050f1:	00 
  1050f2:	c7 04 24 93 69 10 00 	movl   $0x106993,(%esp)
  1050f9:	e8 e6 b2 ff ff       	call   1003e4 <__panic>
}
  1050fe:	90                   	nop
  1050ff:	c9                   	leave  
  105100:	c3                   	ret    

00105101 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105101:	55                   	push   %ebp
  105102:	89 e5                	mov    %esp,%ebp
  105104:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105107:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10510e:	eb 03                	jmp    105113 <strlen+0x12>
        cnt ++;
  105110:	ff 45 fc             	incl   -0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105113:	8b 45 08             	mov    0x8(%ebp),%eax
  105116:	8d 50 01             	lea    0x1(%eax),%edx
  105119:	89 55 08             	mov    %edx,0x8(%ebp)
  10511c:	0f b6 00             	movzbl (%eax),%eax
  10511f:	84 c0                	test   %al,%al
  105121:	75 ed                	jne    105110 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105123:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105126:	c9                   	leave  
  105127:	c3                   	ret    

00105128 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105128:	55                   	push   %ebp
  105129:	89 e5                	mov    %esp,%ebp
  10512b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10512e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105135:	eb 03                	jmp    10513a <strnlen+0x12>
        cnt ++;
  105137:	ff 45 fc             	incl   -0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10513a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10513d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105140:	73 10                	jae    105152 <strnlen+0x2a>
  105142:	8b 45 08             	mov    0x8(%ebp),%eax
  105145:	8d 50 01             	lea    0x1(%eax),%edx
  105148:	89 55 08             	mov    %edx,0x8(%ebp)
  10514b:	0f b6 00             	movzbl (%eax),%eax
  10514e:	84 c0                	test   %al,%al
  105150:	75 e5                	jne    105137 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105155:	c9                   	leave  
  105156:	c3                   	ret    

00105157 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105157:	55                   	push   %ebp
  105158:	89 e5                	mov    %esp,%ebp
  10515a:	57                   	push   %edi
  10515b:	56                   	push   %esi
  10515c:	83 ec 20             	sub    $0x20,%esp
  10515f:	8b 45 08             	mov    0x8(%ebp),%eax
  105162:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105165:	8b 45 0c             	mov    0xc(%ebp),%eax
  105168:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10516b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10516e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105171:	89 d1                	mov    %edx,%ecx
  105173:	89 c2                	mov    %eax,%edx
  105175:	89 ce                	mov    %ecx,%esi
  105177:	89 d7                	mov    %edx,%edi
  105179:	ac                   	lods   %ds:(%esi),%al
  10517a:	aa                   	stos   %al,%es:(%edi)
  10517b:	84 c0                	test   %al,%al
  10517d:	75 fa                	jne    105179 <strcpy+0x22>
  10517f:	89 fa                	mov    %edi,%edx
  105181:	89 f1                	mov    %esi,%ecx
  105183:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105186:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  10518c:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  10518f:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105190:	83 c4 20             	add    $0x20,%esp
  105193:	5e                   	pop    %esi
  105194:	5f                   	pop    %edi
  105195:	5d                   	pop    %ebp
  105196:	c3                   	ret    

00105197 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105197:	55                   	push   %ebp
  105198:	89 e5                	mov    %esp,%ebp
  10519a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10519d:	8b 45 08             	mov    0x8(%ebp),%eax
  1051a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1051a3:	eb 1e                	jmp    1051c3 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  1051a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051a8:	0f b6 10             	movzbl (%eax),%edx
  1051ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051ae:	88 10                	mov    %dl,(%eax)
  1051b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051b3:	0f b6 00             	movzbl (%eax),%eax
  1051b6:	84 c0                	test   %al,%al
  1051b8:	74 03                	je     1051bd <strncpy+0x26>
            src ++;
  1051ba:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1051bd:	ff 45 fc             	incl   -0x4(%ebp)
  1051c0:	ff 4d 10             	decl   0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1051c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1051c7:	75 dc                	jne    1051a5 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1051c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1051cc:	c9                   	leave  
  1051cd:	c3                   	ret    

001051ce <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1051ce:	55                   	push   %ebp
  1051cf:	89 e5                	mov    %esp,%ebp
  1051d1:	57                   	push   %edi
  1051d2:	56                   	push   %esi
  1051d3:	83 ec 20             	sub    $0x20,%esp
  1051d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1051d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1051dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051df:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1051e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1051e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1051e8:	89 d1                	mov    %edx,%ecx
  1051ea:	89 c2                	mov    %eax,%edx
  1051ec:	89 ce                	mov    %ecx,%esi
  1051ee:	89 d7                	mov    %edx,%edi
  1051f0:	ac                   	lods   %ds:(%esi),%al
  1051f1:	ae                   	scas   %es:(%edi),%al
  1051f2:	75 08                	jne    1051fc <strcmp+0x2e>
  1051f4:	84 c0                	test   %al,%al
  1051f6:	75 f8                	jne    1051f0 <strcmp+0x22>
  1051f8:	31 c0                	xor    %eax,%eax
  1051fa:	eb 04                	jmp    105200 <strcmp+0x32>
  1051fc:	19 c0                	sbb    %eax,%eax
  1051fe:	0c 01                	or     $0x1,%al
  105200:	89 fa                	mov    %edi,%edx
  105202:	89 f1                	mov    %esi,%ecx
  105204:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105207:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10520a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  10520d:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  105210:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105211:	83 c4 20             	add    $0x20,%esp
  105214:	5e                   	pop    %esi
  105215:	5f                   	pop    %edi
  105216:	5d                   	pop    %ebp
  105217:	c3                   	ret    

00105218 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105218:	55                   	push   %ebp
  105219:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10521b:	eb 09                	jmp    105226 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  10521d:	ff 4d 10             	decl   0x10(%ebp)
  105220:	ff 45 08             	incl   0x8(%ebp)
  105223:	ff 45 0c             	incl   0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105226:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10522a:	74 1a                	je     105246 <strncmp+0x2e>
  10522c:	8b 45 08             	mov    0x8(%ebp),%eax
  10522f:	0f b6 00             	movzbl (%eax),%eax
  105232:	84 c0                	test   %al,%al
  105234:	74 10                	je     105246 <strncmp+0x2e>
  105236:	8b 45 08             	mov    0x8(%ebp),%eax
  105239:	0f b6 10             	movzbl (%eax),%edx
  10523c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10523f:	0f b6 00             	movzbl (%eax),%eax
  105242:	38 c2                	cmp    %al,%dl
  105244:	74 d7                	je     10521d <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105246:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10524a:	74 18                	je     105264 <strncmp+0x4c>
  10524c:	8b 45 08             	mov    0x8(%ebp),%eax
  10524f:	0f b6 00             	movzbl (%eax),%eax
  105252:	0f b6 d0             	movzbl %al,%edx
  105255:	8b 45 0c             	mov    0xc(%ebp),%eax
  105258:	0f b6 00             	movzbl (%eax),%eax
  10525b:	0f b6 c0             	movzbl %al,%eax
  10525e:	29 c2                	sub    %eax,%edx
  105260:	89 d0                	mov    %edx,%eax
  105262:	eb 05                	jmp    105269 <strncmp+0x51>
  105264:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105269:	5d                   	pop    %ebp
  10526a:	c3                   	ret    

0010526b <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10526b:	55                   	push   %ebp
  10526c:	89 e5                	mov    %esp,%ebp
  10526e:	83 ec 04             	sub    $0x4,%esp
  105271:	8b 45 0c             	mov    0xc(%ebp),%eax
  105274:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105277:	eb 13                	jmp    10528c <strchr+0x21>
        if (*s == c) {
  105279:	8b 45 08             	mov    0x8(%ebp),%eax
  10527c:	0f b6 00             	movzbl (%eax),%eax
  10527f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105282:	75 05                	jne    105289 <strchr+0x1e>
            return (char *)s;
  105284:	8b 45 08             	mov    0x8(%ebp),%eax
  105287:	eb 12                	jmp    10529b <strchr+0x30>
        }
        s ++;
  105289:	ff 45 08             	incl   0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  10528c:	8b 45 08             	mov    0x8(%ebp),%eax
  10528f:	0f b6 00             	movzbl (%eax),%eax
  105292:	84 c0                	test   %al,%al
  105294:	75 e3                	jne    105279 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105296:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10529b:	c9                   	leave  
  10529c:	c3                   	ret    

0010529d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10529d:	55                   	push   %ebp
  10529e:	89 e5                	mov    %esp,%ebp
  1052a0:	83 ec 04             	sub    $0x4,%esp
  1052a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052a6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1052a9:	eb 0e                	jmp    1052b9 <strfind+0x1c>
        if (*s == c) {
  1052ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1052ae:	0f b6 00             	movzbl (%eax),%eax
  1052b1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1052b4:	74 0f                	je     1052c5 <strfind+0x28>
            break;
        }
        s ++;
  1052b6:	ff 45 08             	incl   0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1052b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1052bc:	0f b6 00             	movzbl (%eax),%eax
  1052bf:	84 c0                	test   %al,%al
  1052c1:	75 e8                	jne    1052ab <strfind+0xe>
  1052c3:	eb 01                	jmp    1052c6 <strfind+0x29>
        if (*s == c) {
            break;
  1052c5:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  1052c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1052c9:	c9                   	leave  
  1052ca:	c3                   	ret    

001052cb <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1052cb:	55                   	push   %ebp
  1052cc:	89 e5                	mov    %esp,%ebp
  1052ce:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1052d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1052d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1052df:	eb 03                	jmp    1052e4 <strtol+0x19>
        s ++;
  1052e1:	ff 45 08             	incl   0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1052e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1052e7:	0f b6 00             	movzbl (%eax),%eax
  1052ea:	3c 20                	cmp    $0x20,%al
  1052ec:	74 f3                	je     1052e1 <strtol+0x16>
  1052ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1052f1:	0f b6 00             	movzbl (%eax),%eax
  1052f4:	3c 09                	cmp    $0x9,%al
  1052f6:	74 e9                	je     1052e1 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1052f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1052fb:	0f b6 00             	movzbl (%eax),%eax
  1052fe:	3c 2b                	cmp    $0x2b,%al
  105300:	75 05                	jne    105307 <strtol+0x3c>
        s ++;
  105302:	ff 45 08             	incl   0x8(%ebp)
  105305:	eb 14                	jmp    10531b <strtol+0x50>
    }
    else if (*s == '-') {
  105307:	8b 45 08             	mov    0x8(%ebp),%eax
  10530a:	0f b6 00             	movzbl (%eax),%eax
  10530d:	3c 2d                	cmp    $0x2d,%al
  10530f:	75 0a                	jne    10531b <strtol+0x50>
        s ++, neg = 1;
  105311:	ff 45 08             	incl   0x8(%ebp)
  105314:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10531b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10531f:	74 06                	je     105327 <strtol+0x5c>
  105321:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105325:	75 22                	jne    105349 <strtol+0x7e>
  105327:	8b 45 08             	mov    0x8(%ebp),%eax
  10532a:	0f b6 00             	movzbl (%eax),%eax
  10532d:	3c 30                	cmp    $0x30,%al
  10532f:	75 18                	jne    105349 <strtol+0x7e>
  105331:	8b 45 08             	mov    0x8(%ebp),%eax
  105334:	40                   	inc    %eax
  105335:	0f b6 00             	movzbl (%eax),%eax
  105338:	3c 78                	cmp    $0x78,%al
  10533a:	75 0d                	jne    105349 <strtol+0x7e>
        s += 2, base = 16;
  10533c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105340:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105347:	eb 29                	jmp    105372 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  105349:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10534d:	75 16                	jne    105365 <strtol+0x9a>
  10534f:	8b 45 08             	mov    0x8(%ebp),%eax
  105352:	0f b6 00             	movzbl (%eax),%eax
  105355:	3c 30                	cmp    $0x30,%al
  105357:	75 0c                	jne    105365 <strtol+0x9a>
        s ++, base = 8;
  105359:	ff 45 08             	incl   0x8(%ebp)
  10535c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105363:	eb 0d                	jmp    105372 <strtol+0xa7>
    }
    else if (base == 0) {
  105365:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105369:	75 07                	jne    105372 <strtol+0xa7>
        base = 10;
  10536b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105372:	8b 45 08             	mov    0x8(%ebp),%eax
  105375:	0f b6 00             	movzbl (%eax),%eax
  105378:	3c 2f                	cmp    $0x2f,%al
  10537a:	7e 1b                	jle    105397 <strtol+0xcc>
  10537c:	8b 45 08             	mov    0x8(%ebp),%eax
  10537f:	0f b6 00             	movzbl (%eax),%eax
  105382:	3c 39                	cmp    $0x39,%al
  105384:	7f 11                	jg     105397 <strtol+0xcc>
            dig = *s - '0';
  105386:	8b 45 08             	mov    0x8(%ebp),%eax
  105389:	0f b6 00             	movzbl (%eax),%eax
  10538c:	0f be c0             	movsbl %al,%eax
  10538f:	83 e8 30             	sub    $0x30,%eax
  105392:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105395:	eb 48                	jmp    1053df <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105397:	8b 45 08             	mov    0x8(%ebp),%eax
  10539a:	0f b6 00             	movzbl (%eax),%eax
  10539d:	3c 60                	cmp    $0x60,%al
  10539f:	7e 1b                	jle    1053bc <strtol+0xf1>
  1053a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1053a4:	0f b6 00             	movzbl (%eax),%eax
  1053a7:	3c 7a                	cmp    $0x7a,%al
  1053a9:	7f 11                	jg     1053bc <strtol+0xf1>
            dig = *s - 'a' + 10;
  1053ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1053ae:	0f b6 00             	movzbl (%eax),%eax
  1053b1:	0f be c0             	movsbl %al,%eax
  1053b4:	83 e8 57             	sub    $0x57,%eax
  1053b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1053ba:	eb 23                	jmp    1053df <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1053bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1053bf:	0f b6 00             	movzbl (%eax),%eax
  1053c2:	3c 40                	cmp    $0x40,%al
  1053c4:	7e 3b                	jle    105401 <strtol+0x136>
  1053c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1053c9:	0f b6 00             	movzbl (%eax),%eax
  1053cc:	3c 5a                	cmp    $0x5a,%al
  1053ce:	7f 31                	jg     105401 <strtol+0x136>
            dig = *s - 'A' + 10;
  1053d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1053d3:	0f b6 00             	movzbl (%eax),%eax
  1053d6:	0f be c0             	movsbl %al,%eax
  1053d9:	83 e8 37             	sub    $0x37,%eax
  1053dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1053df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053e2:	3b 45 10             	cmp    0x10(%ebp),%eax
  1053e5:	7d 19                	jge    105400 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  1053e7:	ff 45 08             	incl   0x8(%ebp)
  1053ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1053ed:	0f af 45 10          	imul   0x10(%ebp),%eax
  1053f1:	89 c2                	mov    %eax,%edx
  1053f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1053f6:	01 d0                	add    %edx,%eax
  1053f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1053fb:	e9 72 ff ff ff       	jmp    105372 <strtol+0xa7>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  105400:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  105401:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105405:	74 08                	je     10540f <strtol+0x144>
        *endptr = (char *) s;
  105407:	8b 45 0c             	mov    0xc(%ebp),%eax
  10540a:	8b 55 08             	mov    0x8(%ebp),%edx
  10540d:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10540f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105413:	74 07                	je     10541c <strtol+0x151>
  105415:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105418:	f7 d8                	neg    %eax
  10541a:	eb 03                	jmp    10541f <strtol+0x154>
  10541c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10541f:	c9                   	leave  
  105420:	c3                   	ret    

00105421 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105421:	55                   	push   %ebp
  105422:	89 e5                	mov    %esp,%ebp
  105424:	57                   	push   %edi
  105425:	83 ec 24             	sub    $0x24,%esp
  105428:	8b 45 0c             	mov    0xc(%ebp),%eax
  10542b:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10542e:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105432:	8b 55 08             	mov    0x8(%ebp),%edx
  105435:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105438:	88 45 f7             	mov    %al,-0x9(%ebp)
  10543b:	8b 45 10             	mov    0x10(%ebp),%eax
  10543e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105441:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105444:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105448:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10544b:	89 d7                	mov    %edx,%edi
  10544d:	f3 aa                	rep stos %al,%es:(%edi)
  10544f:	89 fa                	mov    %edi,%edx
  105451:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105454:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105457:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10545a:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10545b:	83 c4 24             	add    $0x24,%esp
  10545e:	5f                   	pop    %edi
  10545f:	5d                   	pop    %ebp
  105460:	c3                   	ret    

00105461 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105461:	55                   	push   %ebp
  105462:	89 e5                	mov    %esp,%ebp
  105464:	57                   	push   %edi
  105465:	56                   	push   %esi
  105466:	53                   	push   %ebx
  105467:	83 ec 30             	sub    $0x30,%esp
  10546a:	8b 45 08             	mov    0x8(%ebp),%eax
  10546d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105470:	8b 45 0c             	mov    0xc(%ebp),%eax
  105473:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105476:	8b 45 10             	mov    0x10(%ebp),%eax
  105479:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10547c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10547f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105482:	73 42                	jae    1054c6 <memmove+0x65>
  105484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105487:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10548a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10548d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105493:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105496:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105499:	c1 e8 02             	shr    $0x2,%eax
  10549c:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10549e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1054a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054a4:	89 d7                	mov    %edx,%edi
  1054a6:	89 c6                	mov    %eax,%esi
  1054a8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1054aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1054ad:	83 e1 03             	and    $0x3,%ecx
  1054b0:	74 02                	je     1054b4 <memmove+0x53>
  1054b2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1054b4:	89 f0                	mov    %esi,%eax
  1054b6:	89 fa                	mov    %edi,%edx
  1054b8:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1054bb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1054be:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1054c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  1054c4:	eb 36                	jmp    1054fc <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1054c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054c9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1054cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1054cf:	01 c2                	add    %eax,%edx
  1054d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054d4:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1054d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054da:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1054dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054e0:	89 c1                	mov    %eax,%ecx
  1054e2:	89 d8                	mov    %ebx,%eax
  1054e4:	89 d6                	mov    %edx,%esi
  1054e6:	89 c7                	mov    %eax,%edi
  1054e8:	fd                   	std    
  1054e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1054eb:	fc                   	cld    
  1054ec:	89 f8                	mov    %edi,%eax
  1054ee:	89 f2                	mov    %esi,%edx
  1054f0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1054f3:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1054f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  1054f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1054fc:	83 c4 30             	add    $0x30,%esp
  1054ff:	5b                   	pop    %ebx
  105500:	5e                   	pop    %esi
  105501:	5f                   	pop    %edi
  105502:	5d                   	pop    %ebp
  105503:	c3                   	ret    

00105504 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105504:	55                   	push   %ebp
  105505:	89 e5                	mov    %esp,%ebp
  105507:	57                   	push   %edi
  105508:	56                   	push   %esi
  105509:	83 ec 20             	sub    $0x20,%esp
  10550c:	8b 45 08             	mov    0x8(%ebp),%eax
  10550f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105512:	8b 45 0c             	mov    0xc(%ebp),%eax
  105515:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105518:	8b 45 10             	mov    0x10(%ebp),%eax
  10551b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10551e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105521:	c1 e8 02             	shr    $0x2,%eax
  105524:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105526:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10552c:	89 d7                	mov    %edx,%edi
  10552e:	89 c6                	mov    %eax,%esi
  105530:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105532:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105535:	83 e1 03             	and    $0x3,%ecx
  105538:	74 02                	je     10553c <memcpy+0x38>
  10553a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10553c:	89 f0                	mov    %esi,%eax
  10553e:	89 fa                	mov    %edi,%edx
  105540:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105543:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105546:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105549:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  10554c:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10554d:	83 c4 20             	add    $0x20,%esp
  105550:	5e                   	pop    %esi
  105551:	5f                   	pop    %edi
  105552:	5d                   	pop    %ebp
  105553:	c3                   	ret    

00105554 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105554:	55                   	push   %ebp
  105555:	89 e5                	mov    %esp,%ebp
  105557:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10555a:	8b 45 08             	mov    0x8(%ebp),%eax
  10555d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105560:	8b 45 0c             	mov    0xc(%ebp),%eax
  105563:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105566:	eb 2e                	jmp    105596 <memcmp+0x42>
        if (*s1 != *s2) {
  105568:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10556b:	0f b6 10             	movzbl (%eax),%edx
  10556e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105571:	0f b6 00             	movzbl (%eax),%eax
  105574:	38 c2                	cmp    %al,%dl
  105576:	74 18                	je     105590 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105578:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10557b:	0f b6 00             	movzbl (%eax),%eax
  10557e:	0f b6 d0             	movzbl %al,%edx
  105581:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105584:	0f b6 00             	movzbl (%eax),%eax
  105587:	0f b6 c0             	movzbl %al,%eax
  10558a:	29 c2                	sub    %eax,%edx
  10558c:	89 d0                	mov    %edx,%eax
  10558e:	eb 18                	jmp    1055a8 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  105590:	ff 45 fc             	incl   -0x4(%ebp)
  105593:	ff 45 f8             	incl   -0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105596:	8b 45 10             	mov    0x10(%ebp),%eax
  105599:	8d 50 ff             	lea    -0x1(%eax),%edx
  10559c:	89 55 10             	mov    %edx,0x10(%ebp)
  10559f:	85 c0                	test   %eax,%eax
  1055a1:	75 c5                	jne    105568 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1055a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1055a8:	c9                   	leave  
  1055a9:	c3                   	ret    

001055aa <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1055aa:	55                   	push   %ebp
  1055ab:	89 e5                	mov    %esp,%ebp
  1055ad:	83 ec 58             	sub    $0x58,%esp
  1055b0:	8b 45 10             	mov    0x10(%ebp),%eax
  1055b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1055b6:	8b 45 14             	mov    0x14(%ebp),%eax
  1055b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1055bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1055bf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1055c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1055c5:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1055c8:	8b 45 18             	mov    0x18(%ebp),%eax
  1055cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1055d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1055d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1055d7:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1055da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1055e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1055e4:	74 1c                	je     105602 <printnum+0x58>
  1055e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055e9:	ba 00 00 00 00       	mov    $0x0,%edx
  1055ee:	f7 75 e4             	divl   -0x1c(%ebp)
  1055f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1055f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055f7:	ba 00 00 00 00       	mov    $0x0,%edx
  1055fc:	f7 75 e4             	divl   -0x1c(%ebp)
  1055ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105602:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105605:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105608:	f7 75 e4             	divl   -0x1c(%ebp)
  10560b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10560e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105611:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105614:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105617:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10561a:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10561d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105620:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105623:	8b 45 18             	mov    0x18(%ebp),%eax
  105626:	ba 00 00 00 00       	mov    $0x0,%edx
  10562b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10562e:	77 56                	ja     105686 <printnum+0xdc>
  105630:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105633:	72 05                	jb     10563a <printnum+0x90>
  105635:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105638:	77 4c                	ja     105686 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10563a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10563d:	8d 50 ff             	lea    -0x1(%eax),%edx
  105640:	8b 45 20             	mov    0x20(%ebp),%eax
  105643:	89 44 24 18          	mov    %eax,0x18(%esp)
  105647:	89 54 24 14          	mov    %edx,0x14(%esp)
  10564b:	8b 45 18             	mov    0x18(%ebp),%eax
  10564e:	89 44 24 10          	mov    %eax,0x10(%esp)
  105652:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105655:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105658:	89 44 24 08          	mov    %eax,0x8(%esp)
  10565c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105660:	8b 45 0c             	mov    0xc(%ebp),%eax
  105663:	89 44 24 04          	mov    %eax,0x4(%esp)
  105667:	8b 45 08             	mov    0x8(%ebp),%eax
  10566a:	89 04 24             	mov    %eax,(%esp)
  10566d:	e8 38 ff ff ff       	call   1055aa <printnum>
  105672:	eb 1b                	jmp    10568f <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105674:	8b 45 0c             	mov    0xc(%ebp),%eax
  105677:	89 44 24 04          	mov    %eax,0x4(%esp)
  10567b:	8b 45 20             	mov    0x20(%ebp),%eax
  10567e:	89 04 24             	mov    %eax,(%esp)
  105681:	8b 45 08             	mov    0x8(%ebp),%eax
  105684:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105686:	ff 4d 1c             	decl   0x1c(%ebp)
  105689:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10568d:	7f e5                	jg     105674 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10568f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105692:	05 bc 6d 10 00       	add    $0x106dbc,%eax
  105697:	0f b6 00             	movzbl (%eax),%eax
  10569a:	0f be c0             	movsbl %al,%eax
  10569d:	8b 55 0c             	mov    0xc(%ebp),%edx
  1056a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1056a4:	89 04 24             	mov    %eax,(%esp)
  1056a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1056aa:	ff d0                	call   *%eax
}
  1056ac:	90                   	nop
  1056ad:	c9                   	leave  
  1056ae:	c3                   	ret    

001056af <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1056af:	55                   	push   %ebp
  1056b0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1056b2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1056b6:	7e 14                	jle    1056cc <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1056b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1056bb:	8b 00                	mov    (%eax),%eax
  1056bd:	8d 48 08             	lea    0x8(%eax),%ecx
  1056c0:	8b 55 08             	mov    0x8(%ebp),%edx
  1056c3:	89 0a                	mov    %ecx,(%edx)
  1056c5:	8b 50 04             	mov    0x4(%eax),%edx
  1056c8:	8b 00                	mov    (%eax),%eax
  1056ca:	eb 30                	jmp    1056fc <getuint+0x4d>
    }
    else if (lflag) {
  1056cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1056d0:	74 16                	je     1056e8 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1056d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1056d5:	8b 00                	mov    (%eax),%eax
  1056d7:	8d 48 04             	lea    0x4(%eax),%ecx
  1056da:	8b 55 08             	mov    0x8(%ebp),%edx
  1056dd:	89 0a                	mov    %ecx,(%edx)
  1056df:	8b 00                	mov    (%eax),%eax
  1056e1:	ba 00 00 00 00       	mov    $0x0,%edx
  1056e6:	eb 14                	jmp    1056fc <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1056e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1056eb:	8b 00                	mov    (%eax),%eax
  1056ed:	8d 48 04             	lea    0x4(%eax),%ecx
  1056f0:	8b 55 08             	mov    0x8(%ebp),%edx
  1056f3:	89 0a                	mov    %ecx,(%edx)
  1056f5:	8b 00                	mov    (%eax),%eax
  1056f7:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1056fc:	5d                   	pop    %ebp
  1056fd:	c3                   	ret    

001056fe <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1056fe:	55                   	push   %ebp
  1056ff:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105701:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105705:	7e 14                	jle    10571b <getint+0x1d>
        return va_arg(*ap, long long);
  105707:	8b 45 08             	mov    0x8(%ebp),%eax
  10570a:	8b 00                	mov    (%eax),%eax
  10570c:	8d 48 08             	lea    0x8(%eax),%ecx
  10570f:	8b 55 08             	mov    0x8(%ebp),%edx
  105712:	89 0a                	mov    %ecx,(%edx)
  105714:	8b 50 04             	mov    0x4(%eax),%edx
  105717:	8b 00                	mov    (%eax),%eax
  105719:	eb 28                	jmp    105743 <getint+0x45>
    }
    else if (lflag) {
  10571b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10571f:	74 12                	je     105733 <getint+0x35>
        return va_arg(*ap, long);
  105721:	8b 45 08             	mov    0x8(%ebp),%eax
  105724:	8b 00                	mov    (%eax),%eax
  105726:	8d 48 04             	lea    0x4(%eax),%ecx
  105729:	8b 55 08             	mov    0x8(%ebp),%edx
  10572c:	89 0a                	mov    %ecx,(%edx)
  10572e:	8b 00                	mov    (%eax),%eax
  105730:	99                   	cltd   
  105731:	eb 10                	jmp    105743 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105733:	8b 45 08             	mov    0x8(%ebp),%eax
  105736:	8b 00                	mov    (%eax),%eax
  105738:	8d 48 04             	lea    0x4(%eax),%ecx
  10573b:	8b 55 08             	mov    0x8(%ebp),%edx
  10573e:	89 0a                	mov    %ecx,(%edx)
  105740:	8b 00                	mov    (%eax),%eax
  105742:	99                   	cltd   
    }
}
  105743:	5d                   	pop    %ebp
  105744:	c3                   	ret    

00105745 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105745:	55                   	push   %ebp
  105746:	89 e5                	mov    %esp,%ebp
  105748:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10574b:	8d 45 14             	lea    0x14(%ebp),%eax
  10574e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105754:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105758:	8b 45 10             	mov    0x10(%ebp),%eax
  10575b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10575f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105762:	89 44 24 04          	mov    %eax,0x4(%esp)
  105766:	8b 45 08             	mov    0x8(%ebp),%eax
  105769:	89 04 24             	mov    %eax,(%esp)
  10576c:	e8 03 00 00 00       	call   105774 <vprintfmt>
    va_end(ap);
}
  105771:	90                   	nop
  105772:	c9                   	leave  
  105773:	c3                   	ret    

00105774 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105774:	55                   	push   %ebp
  105775:	89 e5                	mov    %esp,%ebp
  105777:	56                   	push   %esi
  105778:	53                   	push   %ebx
  105779:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10577c:	eb 17                	jmp    105795 <vprintfmt+0x21>
            if (ch == '\0') {
  10577e:	85 db                	test   %ebx,%ebx
  105780:	0f 84 bf 03 00 00    	je     105b45 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  105786:	8b 45 0c             	mov    0xc(%ebp),%eax
  105789:	89 44 24 04          	mov    %eax,0x4(%esp)
  10578d:	89 1c 24             	mov    %ebx,(%esp)
  105790:	8b 45 08             	mov    0x8(%ebp),%eax
  105793:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105795:	8b 45 10             	mov    0x10(%ebp),%eax
  105798:	8d 50 01             	lea    0x1(%eax),%edx
  10579b:	89 55 10             	mov    %edx,0x10(%ebp)
  10579e:	0f b6 00             	movzbl (%eax),%eax
  1057a1:	0f b6 d8             	movzbl %al,%ebx
  1057a4:	83 fb 25             	cmp    $0x25,%ebx
  1057a7:	75 d5                	jne    10577e <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1057a9:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1057ad:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1057b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1057ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1057c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1057c4:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1057c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1057ca:	8d 50 01             	lea    0x1(%eax),%edx
  1057cd:	89 55 10             	mov    %edx,0x10(%ebp)
  1057d0:	0f b6 00             	movzbl (%eax),%eax
  1057d3:	0f b6 d8             	movzbl %al,%ebx
  1057d6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1057d9:	83 f8 55             	cmp    $0x55,%eax
  1057dc:	0f 87 37 03 00 00    	ja     105b19 <vprintfmt+0x3a5>
  1057e2:	8b 04 85 e0 6d 10 00 	mov    0x106de0(,%eax,4),%eax
  1057e9:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1057eb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1057ef:	eb d6                	jmp    1057c7 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1057f1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1057f5:	eb d0                	jmp    1057c7 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1057f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1057fe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105801:	89 d0                	mov    %edx,%eax
  105803:	c1 e0 02             	shl    $0x2,%eax
  105806:	01 d0                	add    %edx,%eax
  105808:	01 c0                	add    %eax,%eax
  10580a:	01 d8                	add    %ebx,%eax
  10580c:	83 e8 30             	sub    $0x30,%eax
  10580f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105812:	8b 45 10             	mov    0x10(%ebp),%eax
  105815:	0f b6 00             	movzbl (%eax),%eax
  105818:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10581b:	83 fb 2f             	cmp    $0x2f,%ebx
  10581e:	7e 38                	jle    105858 <vprintfmt+0xe4>
  105820:	83 fb 39             	cmp    $0x39,%ebx
  105823:	7f 33                	jg     105858 <vprintfmt+0xe4>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105825:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105828:	eb d4                	jmp    1057fe <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10582a:	8b 45 14             	mov    0x14(%ebp),%eax
  10582d:	8d 50 04             	lea    0x4(%eax),%edx
  105830:	89 55 14             	mov    %edx,0x14(%ebp)
  105833:	8b 00                	mov    (%eax),%eax
  105835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105838:	eb 1f                	jmp    105859 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  10583a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10583e:	79 87                	jns    1057c7 <vprintfmt+0x53>
                width = 0;
  105840:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105847:	e9 7b ff ff ff       	jmp    1057c7 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  10584c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105853:	e9 6f ff ff ff       	jmp    1057c7 <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  105858:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  105859:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10585d:	0f 89 64 ff ff ff    	jns    1057c7 <vprintfmt+0x53>
                width = precision, precision = -1;
  105863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105866:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105869:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105870:	e9 52 ff ff ff       	jmp    1057c7 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105875:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105878:	e9 4a ff ff ff       	jmp    1057c7 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10587d:	8b 45 14             	mov    0x14(%ebp),%eax
  105880:	8d 50 04             	lea    0x4(%eax),%edx
  105883:	89 55 14             	mov    %edx,0x14(%ebp)
  105886:	8b 00                	mov    (%eax),%eax
  105888:	8b 55 0c             	mov    0xc(%ebp),%edx
  10588b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10588f:	89 04 24             	mov    %eax,(%esp)
  105892:	8b 45 08             	mov    0x8(%ebp),%eax
  105895:	ff d0                	call   *%eax
            break;
  105897:	e9 a4 02 00 00       	jmp    105b40 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10589c:	8b 45 14             	mov    0x14(%ebp),%eax
  10589f:	8d 50 04             	lea    0x4(%eax),%edx
  1058a2:	89 55 14             	mov    %edx,0x14(%ebp)
  1058a5:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1058a7:	85 db                	test   %ebx,%ebx
  1058a9:	79 02                	jns    1058ad <vprintfmt+0x139>
                err = -err;
  1058ab:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1058ad:	83 fb 06             	cmp    $0x6,%ebx
  1058b0:	7f 0b                	jg     1058bd <vprintfmt+0x149>
  1058b2:	8b 34 9d a0 6d 10 00 	mov    0x106da0(,%ebx,4),%esi
  1058b9:	85 f6                	test   %esi,%esi
  1058bb:	75 23                	jne    1058e0 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  1058bd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1058c1:	c7 44 24 08 cd 6d 10 	movl   $0x106dcd,0x8(%esp)
  1058c8:	00 
  1058c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1058d3:	89 04 24             	mov    %eax,(%esp)
  1058d6:	e8 6a fe ff ff       	call   105745 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1058db:	e9 60 02 00 00       	jmp    105b40 <vprintfmt+0x3cc>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1058e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1058e4:	c7 44 24 08 d6 6d 10 	movl   $0x106dd6,0x8(%esp)
  1058eb:	00 
  1058ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f6:	89 04 24             	mov    %eax,(%esp)
  1058f9:	e8 47 fe ff ff       	call   105745 <printfmt>
            }
            break;
  1058fe:	e9 3d 02 00 00       	jmp    105b40 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105903:	8b 45 14             	mov    0x14(%ebp),%eax
  105906:	8d 50 04             	lea    0x4(%eax),%edx
  105909:	89 55 14             	mov    %edx,0x14(%ebp)
  10590c:	8b 30                	mov    (%eax),%esi
  10590e:	85 f6                	test   %esi,%esi
  105910:	75 05                	jne    105917 <vprintfmt+0x1a3>
                p = "(null)";
  105912:	be d9 6d 10 00       	mov    $0x106dd9,%esi
            }
            if (width > 0 && padc != '-') {
  105917:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10591b:	7e 76                	jle    105993 <vprintfmt+0x21f>
  10591d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105921:	74 70                	je     105993 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105926:	89 44 24 04          	mov    %eax,0x4(%esp)
  10592a:	89 34 24             	mov    %esi,(%esp)
  10592d:	e8 f6 f7 ff ff       	call   105128 <strnlen>
  105932:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105935:	29 c2                	sub    %eax,%edx
  105937:	89 d0                	mov    %edx,%eax
  105939:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10593c:	eb 16                	jmp    105954 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  10593e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105942:	8b 55 0c             	mov    0xc(%ebp),%edx
  105945:	89 54 24 04          	mov    %edx,0x4(%esp)
  105949:	89 04 24             	mov    %eax,(%esp)
  10594c:	8b 45 08             	mov    0x8(%ebp),%eax
  10594f:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105951:	ff 4d e8             	decl   -0x18(%ebp)
  105954:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105958:	7f e4                	jg     10593e <vprintfmt+0x1ca>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10595a:	eb 37                	jmp    105993 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  10595c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105960:	74 1f                	je     105981 <vprintfmt+0x20d>
  105962:	83 fb 1f             	cmp    $0x1f,%ebx
  105965:	7e 05                	jle    10596c <vprintfmt+0x1f8>
  105967:	83 fb 7e             	cmp    $0x7e,%ebx
  10596a:	7e 15                	jle    105981 <vprintfmt+0x20d>
                    putch('?', putdat);
  10596c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10596f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105973:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10597a:	8b 45 08             	mov    0x8(%ebp),%eax
  10597d:	ff d0                	call   *%eax
  10597f:	eb 0f                	jmp    105990 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  105981:	8b 45 0c             	mov    0xc(%ebp),%eax
  105984:	89 44 24 04          	mov    %eax,0x4(%esp)
  105988:	89 1c 24             	mov    %ebx,(%esp)
  10598b:	8b 45 08             	mov    0x8(%ebp),%eax
  10598e:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105990:	ff 4d e8             	decl   -0x18(%ebp)
  105993:	89 f0                	mov    %esi,%eax
  105995:	8d 70 01             	lea    0x1(%eax),%esi
  105998:	0f b6 00             	movzbl (%eax),%eax
  10599b:	0f be d8             	movsbl %al,%ebx
  10599e:	85 db                	test   %ebx,%ebx
  1059a0:	74 27                	je     1059c9 <vprintfmt+0x255>
  1059a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059a6:	78 b4                	js     10595c <vprintfmt+0x1e8>
  1059a8:	ff 4d e4             	decl   -0x1c(%ebp)
  1059ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059af:	79 ab                	jns    10595c <vprintfmt+0x1e8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1059b1:	eb 16                	jmp    1059c9 <vprintfmt+0x255>
                putch(' ', putdat);
  1059b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ba:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1059c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c4:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1059c6:	ff 4d e8             	decl   -0x18(%ebp)
  1059c9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059cd:	7f e4                	jg     1059b3 <vprintfmt+0x23f>
                putch(' ', putdat);
            }
            break;
  1059cf:	e9 6c 01 00 00       	jmp    105b40 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1059d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1059d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059db:	8d 45 14             	lea    0x14(%ebp),%eax
  1059de:	89 04 24             	mov    %eax,(%esp)
  1059e1:	e8 18 fd ff ff       	call   1056fe <getint>
  1059e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1059ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059f2:	85 d2                	test   %edx,%edx
  1059f4:	79 26                	jns    105a1c <vprintfmt+0x2a8>
                putch('-', putdat);
  1059f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059fd:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105a04:	8b 45 08             	mov    0x8(%ebp),%eax
  105a07:	ff d0                	call   *%eax
                num = -(long long)num;
  105a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a0f:	f7 d8                	neg    %eax
  105a11:	83 d2 00             	adc    $0x0,%edx
  105a14:	f7 da                	neg    %edx
  105a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a19:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105a1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a23:	e9 a8 00 00 00       	jmp    105ad0 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105a28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a2f:	8d 45 14             	lea    0x14(%ebp),%eax
  105a32:	89 04 24             	mov    %eax,(%esp)
  105a35:	e8 75 fc ff ff       	call   1056af <getuint>
  105a3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105a40:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a47:	e9 84 00 00 00       	jmp    105ad0 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a53:	8d 45 14             	lea    0x14(%ebp),%eax
  105a56:	89 04 24             	mov    %eax,(%esp)
  105a59:	e8 51 fc ff ff       	call   1056af <getuint>
  105a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a61:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105a64:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105a6b:	eb 63                	jmp    105ad0 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  105a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a70:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a74:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  105a7e:	ff d0                	call   *%eax
            putch('x', putdat);
  105a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a83:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a87:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  105a91:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105a93:	8b 45 14             	mov    0x14(%ebp),%eax
  105a96:	8d 50 04             	lea    0x4(%eax),%edx
  105a99:	89 55 14             	mov    %edx,0x14(%ebp)
  105a9c:	8b 00                	mov    (%eax),%eax
  105a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105aa1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105aa8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105aaf:	eb 1f                	jmp    105ad0 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ab8:	8d 45 14             	lea    0x14(%ebp),%eax
  105abb:	89 04 24             	mov    %eax,(%esp)
  105abe:	e8 ec fb ff ff       	call   1056af <getuint>
  105ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ac6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105ac9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105ad0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105ad4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ad7:	89 54 24 18          	mov    %edx,0x18(%esp)
  105adb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105ade:	89 54 24 14          	mov    %edx,0x14(%esp)
  105ae2:	89 44 24 10          	mov    %eax,0x10(%esp)
  105ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105aec:	89 44 24 08          	mov    %eax,0x8(%esp)
  105af0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  105afb:	8b 45 08             	mov    0x8(%ebp),%eax
  105afe:	89 04 24             	mov    %eax,(%esp)
  105b01:	e8 a4 fa ff ff       	call   1055aa <printnum>
            break;
  105b06:	eb 38                	jmp    105b40 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b0f:	89 1c 24             	mov    %ebx,(%esp)
  105b12:	8b 45 08             	mov    0x8(%ebp),%eax
  105b15:	ff d0                	call   *%eax
            break;
  105b17:	eb 27                	jmp    105b40 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b20:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105b27:	8b 45 08             	mov    0x8(%ebp),%eax
  105b2a:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105b2c:	ff 4d 10             	decl   0x10(%ebp)
  105b2f:	eb 03                	jmp    105b34 <vprintfmt+0x3c0>
  105b31:	ff 4d 10             	decl   0x10(%ebp)
  105b34:	8b 45 10             	mov    0x10(%ebp),%eax
  105b37:	48                   	dec    %eax
  105b38:	0f b6 00             	movzbl (%eax),%eax
  105b3b:	3c 25                	cmp    $0x25,%al
  105b3d:	75 f2                	jne    105b31 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  105b3f:	90                   	nop
        }
    }
  105b40:	e9 37 fc ff ff       	jmp    10577c <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  105b45:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105b46:	83 c4 40             	add    $0x40,%esp
  105b49:	5b                   	pop    %ebx
  105b4a:	5e                   	pop    %esi
  105b4b:	5d                   	pop    %ebp
  105b4c:	c3                   	ret    

00105b4d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105b4d:	55                   	push   %ebp
  105b4e:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b53:	8b 40 08             	mov    0x8(%eax),%eax
  105b56:	8d 50 01             	lea    0x1(%eax),%edx
  105b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b5c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b62:	8b 10                	mov    (%eax),%edx
  105b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b67:	8b 40 04             	mov    0x4(%eax),%eax
  105b6a:	39 c2                	cmp    %eax,%edx
  105b6c:	73 12                	jae    105b80 <sprintputch+0x33>
        *b->buf ++ = ch;
  105b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b71:	8b 00                	mov    (%eax),%eax
  105b73:	8d 48 01             	lea    0x1(%eax),%ecx
  105b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  105b79:	89 0a                	mov    %ecx,(%edx)
  105b7b:	8b 55 08             	mov    0x8(%ebp),%edx
  105b7e:	88 10                	mov    %dl,(%eax)
    }
}
  105b80:	90                   	nop
  105b81:	5d                   	pop    %ebp
  105b82:	c3                   	ret    

00105b83 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105b83:	55                   	push   %ebp
  105b84:	89 e5                	mov    %esp,%ebp
  105b86:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105b89:	8d 45 14             	lea    0x14(%ebp),%eax
  105b8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b92:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105b96:	8b 45 10             	mov    0x10(%ebp),%eax
  105b99:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba7:	89 04 24             	mov    %eax,(%esp)
  105baa:	e8 08 00 00 00       	call   105bb7 <vsnprintf>
  105baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105bb5:	c9                   	leave  
  105bb6:	c3                   	ret    

00105bb7 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105bb7:	55                   	push   %ebp
  105bb8:	89 e5                	mov    %esp,%ebp
  105bba:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc6:	8d 50 ff             	lea    -0x1(%eax),%edx
  105bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  105bcc:	01 d0                	add    %edx,%eax
  105bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105bd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105bdc:	74 0a                	je     105be8 <vsnprintf+0x31>
  105bde:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105be4:	39 c2                	cmp    %eax,%edx
  105be6:	76 07                	jbe    105bef <vsnprintf+0x38>
        return -E_INVAL;
  105be8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105bed:	eb 2a                	jmp    105c19 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105bef:	8b 45 14             	mov    0x14(%ebp),%eax
  105bf2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  105bf9:	89 44 24 08          	mov    %eax,0x8(%esp)
  105bfd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c04:	c7 04 24 4d 5b 10 00 	movl   $0x105b4d,(%esp)
  105c0b:	e8 64 fb ff ff       	call   105774 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c13:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105c19:	c9                   	leave  
  105c1a:	c3                   	ret    
