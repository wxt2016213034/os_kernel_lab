
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fd 10 00       	mov    $0x10fd80,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 ec 2c 00 00       	call   102d18 <memset>

    cons_init();                // init the console
  10002c:	e8 a0 15 00 00       	call   1015d1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 20 35 10 00 	movl   $0x103520,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 3c 35 10 00 	movl   $0x10353c,(%esp)
  100046:	e8 21 02 00 00       	call   10026c <cprintf>

    print_kerninfo();
  10004b:	e8 c2 08 00 00       	call   100912 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8e 00 00 00       	call   1000e3 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 93 29 00 00       	call   1029ed <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 b0 16 00 00       	call   10170f <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 09 18 00 00       	call   10186d <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 59 0d 00 00       	call   100dc2 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 d4 17 00 00       	call   101842 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 6b 01 00 00       	call   1001de <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 19 0d 00 00       	call   100db0 <mon_backtrace>
}
  100097:	90                   	nop
  100098:	c9                   	leave  
  100099:	c3                   	ret    

0010009a <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	53                   	push   %ebx
  10009e:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a7:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ad:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b9:	89 04 24             	mov    %eax,(%esp)
  1000bc:	e8 b4 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c1:	90                   	nop
  1000c2:	83 c4 14             	add    $0x14,%esp
  1000c5:	5b                   	pop    %ebx
  1000c6:	5d                   	pop    %ebp
  1000c7:	c3                   	ret    

001000c8 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c8:	55                   	push   %ebp
  1000c9:	89 e5                	mov    %esp,%ebp
  1000cb:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d8:	89 04 24             	mov    %eax,(%esp)
  1000db:	e8 ba ff ff ff       	call   10009a <grade_backtrace1>
}
  1000e0:	90                   	nop
  1000e1:	c9                   	leave  
  1000e2:	c3                   	ret    

001000e3 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e3:	55                   	push   %ebp
  1000e4:	89 e5                	mov    %esp,%ebp
  1000e6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000ee:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f5:	ff 
  1000f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100101:	e8 c2 ff ff ff       	call   1000c8 <grade_backtrace0>
}
  100106:	90                   	nop
  100107:	c9                   	leave  
  100108:	c3                   	ret    

00100109 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100112:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100115:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100118:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	83 e0 03             	and    $0x3,%eax
  100122:	89 c2                	mov    %eax,%edx
  100124:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100129:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100131:	c7 04 24 41 35 10 00 	movl   $0x103541,(%esp)
  100138:	e8 2f 01 00 00       	call   10026c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100141:	89 c2                	mov    %eax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 4f 35 10 00 	movl   $0x10354f,(%esp)
  100157:	e8 10 01 00 00       	call   10026c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	89 c2                	mov    %eax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016f:	c7 04 24 5d 35 10 00 	movl   $0x10355d,(%esp)
  100176:	e8 f1 00 00 00       	call   10026c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017f:	89 c2                	mov    %eax,%edx
  100181:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100186:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018e:	c7 04 24 6b 35 10 00 	movl   $0x10356b,(%esp)
  100195:	e8 d2 00 00 00       	call   10026c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019e:	89 c2                	mov    %eax,%edx
  1001a0:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ad:	c7 04 24 79 35 10 00 	movl   $0x103579,(%esp)
  1001b4:	e8 b3 00 00 00       	call   10026c <cprintf>
    round ++;
  1001b9:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001be:	40                   	inc    %eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	90                   	nop
  1001c5:	c9                   	leave  
  1001c6:	c3                   	ret    

001001c7 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c7:	55                   	push   %ebp
  1001c8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001ca:	83 ec 08             	sub    $0x8,%esp
  1001cd:	cd 78                	int    $0x78
  1001cf:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001d1:	90                   	nop
  1001d2:	5d                   	pop    %ebp
  1001d3:	c3                   	ret    

001001d4 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d4:	55                   	push   %ebp
  1001d5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001d7:	cd 79                	int    $0x79
  1001d9:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001db:	90                   	nop
  1001dc:	5d                   	pop    %ebp
  1001dd:	c3                   	ret    

001001de <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001de:	55                   	push   %ebp
  1001df:	89 e5                	mov    %esp,%ebp
  1001e1:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e4:	e8 20 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e9:	c7 04 24 88 35 10 00 	movl   $0x103588,(%esp)
  1001f0:	e8 77 00 00 00       	call   10026c <cprintf>
    lab1_switch_to_user();
  1001f5:	e8 cd ff ff ff       	call   1001c7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fa:	e8 0a ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001ff:	c7 04 24 a8 35 10 00 	movl   $0x1035a8,(%esp)
  100206:	e8 61 00 00 00       	call   10026c <cprintf>
    lab1_switch_to_kernel();
  10020b:	e8 c4 ff ff ff       	call   1001d4 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100210:	e8 f4 fe ff ff       	call   100109 <lab1_print_cur_status>
}
  100215:	90                   	nop
  100216:	c9                   	leave  
  100217:	c3                   	ret    

00100218 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100218:	55                   	push   %ebp
  100219:	89 e5                	mov    %esp,%ebp
  10021b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10021e:	8b 45 08             	mov    0x8(%ebp),%eax
  100221:	89 04 24             	mov    %eax,(%esp)
  100224:	e8 d5 13 00 00       	call   1015fe <cons_putc>
    (*cnt) ++;
  100229:	8b 45 0c             	mov    0xc(%ebp),%eax
  10022c:	8b 00                	mov    (%eax),%eax
  10022e:	8d 50 01             	lea    0x1(%eax),%edx
  100231:	8b 45 0c             	mov    0xc(%ebp),%eax
  100234:	89 10                	mov    %edx,(%eax)
}
  100236:	90                   	nop
  100237:	c9                   	leave  
  100238:	c3                   	ret    

00100239 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100239:	55                   	push   %ebp
  10023a:	89 e5                	mov    %esp,%ebp
  10023c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10023f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100246:	8b 45 0c             	mov    0xc(%ebp),%eax
  100249:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10024d:	8b 45 08             	mov    0x8(%ebp),%eax
  100250:	89 44 24 08          	mov    %eax,0x8(%esp)
  100254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100257:	89 44 24 04          	mov    %eax,0x4(%esp)
  10025b:	c7 04 24 18 02 10 00 	movl   $0x100218,(%esp)
  100262:	e8 04 2e 00 00       	call   10306b <vprintfmt>
    return cnt;
  100267:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10026a:	c9                   	leave  
  10026b:	c3                   	ret    

0010026c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10026c:	55                   	push   %ebp
  10026d:	89 e5                	mov    %esp,%ebp
  10026f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100272:	8d 45 0c             	lea    0xc(%ebp),%eax
  100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10027f:	8b 45 08             	mov    0x8(%ebp),%eax
  100282:	89 04 24             	mov    %eax,(%esp)
  100285:	e8 af ff ff ff       	call   100239 <vcprintf>
  10028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100290:	c9                   	leave  
  100291:	c3                   	ret    

00100292 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100292:	55                   	push   %ebp
  100293:	89 e5                	mov    %esp,%ebp
  100295:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100298:	8b 45 08             	mov    0x8(%ebp),%eax
  10029b:	89 04 24             	mov    %eax,(%esp)
  10029e:	e8 5b 13 00 00       	call   1015fe <cons_putc>
}
  1002a3:	90                   	nop
  1002a4:	c9                   	leave  
  1002a5:	c3                   	ret    

001002a6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a6:	55                   	push   %ebp
  1002a7:	89 e5                	mov    %esp,%ebp
  1002a9:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b3:	eb 13                	jmp    1002c8 <cputs+0x22>
        cputch(c, &cnt);
  1002b5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002b9:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002c0:	89 04 24             	mov    %eax,(%esp)
  1002c3:	e8 50 ff ff ff       	call   100218 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cb:	8d 50 01             	lea    0x1(%eax),%edx
  1002ce:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d1:	0f b6 00             	movzbl (%eax),%eax
  1002d4:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002d7:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002db:	75 d8                	jne    1002b5 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1002dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002e4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002eb:	e8 28 ff ff ff       	call   100218 <cputch>
    return cnt;
  1002f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f3:	c9                   	leave  
  1002f4:	c3                   	ret    

001002f5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f5:	55                   	push   %ebp
  1002f6:	89 e5                	mov    %esp,%ebp
  1002f8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002fb:	e8 28 13 00 00       	call   101628 <cons_getc>
  100300:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100303:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100307:	74 f2                	je     1002fb <getchar+0x6>
        /* do nothing */;
    return c;
  100309:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10030c:	c9                   	leave  
  10030d:	c3                   	ret    

0010030e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10030e:	55                   	push   %ebp
  10030f:	89 e5                	mov    %esp,%ebp
  100311:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100314:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100318:	74 13                	je     10032d <readline+0x1f>
        cprintf("%s", prompt);
  10031a:	8b 45 08             	mov    0x8(%ebp),%eax
  10031d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100321:	c7 04 24 c7 35 10 00 	movl   $0x1035c7,(%esp)
  100328:	e8 3f ff ff ff       	call   10026c <cprintf>
    }
    int i = 0, c;
  10032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100334:	e8 bc ff ff ff       	call   1002f5 <getchar>
  100339:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10033c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100340:	79 07                	jns    100349 <readline+0x3b>
            return NULL;
  100342:	b8 00 00 00 00       	mov    $0x0,%eax
  100347:	eb 78                	jmp    1003c1 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10034d:	7e 28                	jle    100377 <readline+0x69>
  10034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100356:	7f 1f                	jg     100377 <readline+0x69>
            cputchar(c);
  100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10035b:	89 04 24             	mov    %eax,(%esp)
  10035e:	e8 2f ff ff ff       	call   100292 <cputchar>
            buf[i ++] = c;
  100363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100366:	8d 50 01             	lea    0x1(%eax),%edx
  100369:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10036c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10036f:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100375:	eb 45                	jmp    1003bc <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  100377:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10037b:	75 16                	jne    100393 <readline+0x85>
  10037d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100381:	7e 10                	jle    100393 <readline+0x85>
            cputchar(c);
  100383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100386:	89 04 24             	mov    %eax,(%esp)
  100389:	e8 04 ff ff ff       	call   100292 <cputchar>
            i --;
  10038e:	ff 4d f4             	decl   -0xc(%ebp)
  100391:	eb 29                	jmp    1003bc <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  100393:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100397:	74 06                	je     10039f <readline+0x91>
  100399:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10039d:	75 95                	jne    100334 <readline+0x26>
            cputchar(c);
  10039f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003a2:	89 04 24             	mov    %eax,(%esp)
  1003a5:	e8 e8 fe ff ff       	call   100292 <cputchar>
            buf[i] = '\0';
  1003aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ad:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003b2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003b5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003ba:	eb 05                	jmp    1003c1 <readline+0xb3>
        }
    }
  1003bc:	e9 73 ff ff ff       	jmp    100334 <readline+0x26>
}
  1003c1:	c9                   	leave  
  1003c2:	c3                   	ret    

001003c3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003c3:	55                   	push   %ebp
  1003c4:	89 e5                	mov    %esp,%ebp
  1003c6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003c9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003ce:	85 c0                	test   %eax,%eax
  1003d0:	75 5b                	jne    10042d <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003d2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003d9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003dc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1003ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003f0:	c7 04 24 ca 35 10 00 	movl   $0x1035ca,(%esp)
  1003f7:	e8 70 fe ff ff       	call   10026c <cprintf>
    vcprintf(fmt, ap);
  1003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  100403:	8b 45 10             	mov    0x10(%ebp),%eax
  100406:	89 04 24             	mov    %eax,(%esp)
  100409:	e8 2b fe ff ff       	call   100239 <vcprintf>
    cprintf("\n");
  10040e:	c7 04 24 e6 35 10 00 	movl   $0x1035e6,(%esp)
  100415:	e8 52 fe ff ff       	call   10026c <cprintf>
    
    cprintf("stack trackback:\n");
  10041a:	c7 04 24 e8 35 10 00 	movl   $0x1035e8,(%esp)
  100421:	e8 46 fe ff ff       	call   10026c <cprintf>
    print_stackframe();
  100426:	e8 32 06 00 00       	call   100a5d <print_stackframe>
  10042b:	eb 01                	jmp    10042e <__panic+0x6b>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  10042d:	90                   	nop
    print_stackframe();
    
    va_end(ap);

panic_dead:
    intr_disable();
  10042e:	e8 16 14 00 00       	call   101849 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100433:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10043a:	e8 a4 08 00 00       	call   100ce3 <kmonitor>
    }
  10043f:	eb f2                	jmp    100433 <__panic+0x70>

00100441 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100441:	55                   	push   %ebp
  100442:	89 e5                	mov    %esp,%ebp
  100444:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100447:	8d 45 14             	lea    0x14(%ebp),%eax
  10044a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10044d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100450:	89 44 24 08          	mov    %eax,0x8(%esp)
  100454:	8b 45 08             	mov    0x8(%ebp),%eax
  100457:	89 44 24 04          	mov    %eax,0x4(%esp)
  10045b:	c7 04 24 fa 35 10 00 	movl   $0x1035fa,(%esp)
  100462:	e8 05 fe ff ff       	call   10026c <cprintf>
    vcprintf(fmt, ap);
  100467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10046a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046e:	8b 45 10             	mov    0x10(%ebp),%eax
  100471:	89 04 24             	mov    %eax,(%esp)
  100474:	e8 c0 fd ff ff       	call   100239 <vcprintf>
    cprintf("\n");
  100479:	c7 04 24 e6 35 10 00 	movl   $0x1035e6,(%esp)
  100480:	e8 e7 fd ff ff       	call   10026c <cprintf>
    va_end(ap);
}
  100485:	90                   	nop
  100486:	c9                   	leave  
  100487:	c3                   	ret    

00100488 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100488:	55                   	push   %ebp
  100489:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10048b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100490:	5d                   	pop    %ebp
  100491:	c3                   	ret    

00100492 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100492:	55                   	push   %ebp
  100493:	89 e5                	mov    %esp,%ebp
  100495:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100498:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049b:	8b 00                	mov    (%eax),%eax
  10049d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a3:	8b 00                	mov    (%eax),%eax
  1004a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004af:	e9 ca 00 00 00       	jmp    10057e <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004ba:	01 d0                	add    %edx,%eax
  1004bc:	89 c2                	mov    %eax,%edx
  1004be:	c1 ea 1f             	shr    $0x1f,%edx
  1004c1:	01 d0                	add    %edx,%eax
  1004c3:	d1 f8                	sar    %eax
  1004c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004cb:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ce:	eb 03                	jmp    1004d3 <stab_binsearch+0x41>
            m --;
  1004d0:	ff 4d f0             	decl   -0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d9:	7c 1f                	jl     1004fa <stab_binsearch+0x68>
  1004db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004de:	89 d0                	mov    %edx,%eax
  1004e0:	01 c0                	add    %eax,%eax
  1004e2:	01 d0                	add    %edx,%eax
  1004e4:	c1 e0 02             	shl    $0x2,%eax
  1004e7:	89 c2                	mov    %eax,%edx
  1004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f2:	0f b6 c0             	movzbl %al,%eax
  1004f5:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004f8:	75 d6                	jne    1004d0 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100500:	7d 09                	jge    10050b <stab_binsearch+0x79>
            l = true_m + 1;
  100502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100505:	40                   	inc    %eax
  100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100509:	eb 73                	jmp    10057e <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  10050b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100512:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100515:	89 d0                	mov    %edx,%eax
  100517:	01 c0                	add    %eax,%eax
  100519:	01 d0                	add    %edx,%eax
  10051b:	c1 e0 02             	shl    $0x2,%eax
  10051e:	89 c2                	mov    %eax,%edx
  100520:	8b 45 08             	mov    0x8(%ebp),%eax
  100523:	01 d0                	add    %edx,%eax
  100525:	8b 40 08             	mov    0x8(%eax),%eax
  100528:	3b 45 18             	cmp    0x18(%ebp),%eax
  10052b:	73 11                	jae    10053e <stab_binsearch+0xac>
            *region_left = m;
  10052d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100530:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100533:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100538:	40                   	inc    %eax
  100539:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10053c:	eb 40                	jmp    10057e <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  10053e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100541:	89 d0                	mov    %edx,%eax
  100543:	01 c0                	add    %eax,%eax
  100545:	01 d0                	add    %edx,%eax
  100547:	c1 e0 02             	shl    $0x2,%eax
  10054a:	89 c2                	mov    %eax,%edx
  10054c:	8b 45 08             	mov    0x8(%ebp),%eax
  10054f:	01 d0                	add    %edx,%eax
  100551:	8b 40 08             	mov    0x8(%eax),%eax
  100554:	3b 45 18             	cmp    0x18(%ebp),%eax
  100557:	76 14                	jbe    10056d <stab_binsearch+0xdb>
            *region_right = m - 1;
  100559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10055f:	8b 45 10             	mov    0x10(%ebp),%eax
  100562:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100567:	48                   	dec    %eax
  100568:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10056b:	eb 11                	jmp    10057e <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100570:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100573:	89 10                	mov    %edx,(%eax)
            l = m;
  100575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100578:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10057b:	ff 45 18             	incl   0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  10057e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100581:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100584:	0f 8e 2a ff ff ff    	jle    1004b4 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  10058a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10058e:	75 0f                	jne    10059f <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  100590:	8b 45 0c             	mov    0xc(%ebp),%eax
  100593:	8b 00                	mov    (%eax),%eax
  100595:	8d 50 ff             	lea    -0x1(%eax),%edx
  100598:	8b 45 10             	mov    0x10(%ebp),%eax
  10059b:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10059d:	eb 3e                	jmp    1005dd <stab_binsearch+0x14b>
    if (!any_matches) {
        *region_right = *region_left - 1;
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  10059f:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a2:	8b 00                	mov    (%eax),%eax
  1005a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005a7:	eb 03                	jmp    1005ac <stab_binsearch+0x11a>
  1005a9:	ff 4d fc             	decl   -0x4(%ebp)
  1005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005af:	8b 00                	mov    (%eax),%eax
  1005b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005b4:	7d 1f                	jge    1005d5 <stab_binsearch+0x143>
  1005b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b9:	89 d0                	mov    %edx,%eax
  1005bb:	01 c0                	add    %eax,%eax
  1005bd:	01 d0                	add    %edx,%eax
  1005bf:	c1 e0 02             	shl    $0x2,%eax
  1005c2:	89 c2                	mov    %eax,%edx
  1005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c7:	01 d0                	add    %edx,%eax
  1005c9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005cd:	0f b6 c0             	movzbl %al,%eax
  1005d0:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005d3:	75 d4                	jne    1005a9 <stab_binsearch+0x117>
            /* do nothing */;
        *region_left = l;
  1005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005db:	89 10                	mov    %edx,(%eax)
    }
}
  1005dd:	90                   	nop
  1005de:	c9                   	leave  
  1005df:	c3                   	ret    

001005e0 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005e0:	55                   	push   %ebp
  1005e1:	89 e5                	mov    %esp,%ebp
  1005e3:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e9:	c7 00 18 36 10 00    	movl   $0x103618,(%eax)
    info->eip_line = 0;
  1005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	c7 40 08 18 36 10 00 	movl   $0x103618,0x8(%eax)
    info->eip_fn_namelen = 9;
  100603:	8b 45 0c             	mov    0xc(%ebp),%eax
  100606:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10060d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100610:	8b 55 08             	mov    0x8(%ebp),%edx
  100613:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100616:	8b 45 0c             	mov    0xc(%ebp),%eax
  100619:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100620:	c7 45 f4 6c 3e 10 00 	movl   $0x103e6c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100627:	c7 45 f0 dc b8 10 00 	movl   $0x10b8dc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10062e:	c7 45 ec dd b8 10 00 	movl   $0x10b8dd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100635:	c7 45 e8 4d d9 10 00 	movl   $0x10d94d,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10063c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100642:	76 0b                	jbe    10064f <debuginfo_eip+0x6f>
  100644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100647:	48                   	dec    %eax
  100648:	0f b6 00             	movzbl (%eax),%eax
  10064b:	84 c0                	test   %al,%al
  10064d:	74 0a                	je     100659 <debuginfo_eip+0x79>
        return -1;
  10064f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100654:	e9 b7 02 00 00       	jmp    100910 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100659:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100660:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100666:	29 c2                	sub    %eax,%edx
  100668:	89 d0                	mov    %edx,%eax
  10066a:	c1 f8 02             	sar    $0x2,%eax
  10066d:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100673:	48                   	dec    %eax
  100674:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100677:	8b 45 08             	mov    0x8(%ebp),%eax
  10067a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10067e:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100685:	00 
  100686:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100689:	89 44 24 08          	mov    %eax,0x8(%esp)
  10068d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100690:	89 44 24 04          	mov    %eax,0x4(%esp)
  100694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100697:	89 04 24             	mov    %eax,(%esp)
  10069a:	e8 f3 fd ff ff       	call   100492 <stab_binsearch>
    if (lfile == 0)
  10069f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a2:	85 c0                	test   %eax,%eax
  1006a4:	75 0a                	jne    1006b0 <debuginfo_eip+0xd0>
        return -1;
  1006a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006ab:	e9 60 02 00 00       	jmp    100910 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006bf:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006c3:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006ca:	00 
  1006cb:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006d2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006dc:	89 04 24             	mov    %eax,(%esp)
  1006df:	e8 ae fd ff ff       	call   100492 <stab_binsearch>

    if (lfun <= rfun) {
  1006e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006ea:	39 c2                	cmp    %eax,%edx
  1006ec:	7f 7c                	jg     10076a <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006f1:	89 c2                	mov    %eax,%edx
  1006f3:	89 d0                	mov    %edx,%eax
  1006f5:	01 c0                	add    %eax,%eax
  1006f7:	01 d0                	add    %edx,%eax
  1006f9:	c1 e0 02             	shl    $0x2,%eax
  1006fc:	89 c2                	mov    %eax,%edx
  1006fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100701:	01 d0                	add    %edx,%eax
  100703:	8b 00                	mov    (%eax),%eax
  100705:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100708:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10070b:	29 d1                	sub    %edx,%ecx
  10070d:	89 ca                	mov    %ecx,%edx
  10070f:	39 d0                	cmp    %edx,%eax
  100711:	73 22                	jae    100735 <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100713:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100716:	89 c2                	mov    %eax,%edx
  100718:	89 d0                	mov    %edx,%eax
  10071a:	01 c0                	add    %eax,%eax
  10071c:	01 d0                	add    %edx,%eax
  10071e:	c1 e0 02             	shl    $0x2,%eax
  100721:	89 c2                	mov    %eax,%edx
  100723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100726:	01 d0                	add    %edx,%eax
  100728:	8b 10                	mov    (%eax),%edx
  10072a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10072d:	01 c2                	add    %eax,%edx
  10072f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100732:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100735:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100738:	89 c2                	mov    %eax,%edx
  10073a:	89 d0                	mov    %edx,%eax
  10073c:	01 c0                	add    %eax,%eax
  10073e:	01 d0                	add    %edx,%eax
  100740:	c1 e0 02             	shl    $0x2,%eax
  100743:	89 c2                	mov    %eax,%edx
  100745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100748:	01 d0                	add    %edx,%eax
  10074a:	8b 50 08             	mov    0x8(%eax),%edx
  10074d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100750:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100753:	8b 45 0c             	mov    0xc(%ebp),%eax
  100756:	8b 40 10             	mov    0x10(%eax),%eax
  100759:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100762:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100765:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100768:	eb 15                	jmp    10077f <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	8b 55 08             	mov    0x8(%ebp),%edx
  100770:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100776:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100779:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10077c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10077f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100782:	8b 40 08             	mov    0x8(%eax),%eax
  100785:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  10078c:	00 
  10078d:	89 04 24             	mov    %eax,(%esp)
  100790:	e8 ff 23 00 00       	call   102b94 <strfind>
  100795:	89 c2                	mov    %eax,%edx
  100797:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079a:	8b 40 08             	mov    0x8(%eax),%eax
  10079d:	29 c2                	sub    %eax,%edx
  10079f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a2:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1007a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007ac:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007b3:	00 
  1007b4:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007bb:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c5:	89 04 24             	mov    %eax,(%esp)
  1007c8:	e8 c5 fc ff ff       	call   100492 <stab_binsearch>
    if (lline <= rline) {
  1007cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007d3:	39 c2                	cmp    %eax,%edx
  1007d5:	7f 23                	jg     1007fa <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
  1007d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007da:	89 c2                	mov    %eax,%edx
  1007dc:	89 d0                	mov    %edx,%eax
  1007de:	01 c0                	add    %eax,%eax
  1007e0:	01 d0                	add    %edx,%eax
  1007e2:	c1 e0 02             	shl    $0x2,%eax
  1007e5:	89 c2                	mov    %eax,%edx
  1007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ea:	01 d0                	add    %edx,%eax
  1007ec:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007f0:	89 c2                	mov    %eax,%edx
  1007f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f5:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007f8:	eb 11                	jmp    10080b <debuginfo_eip+0x22b>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ff:	e9 0c 01 00 00       	jmp    100910 <debuginfo_eip+0x330>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100807:	48                   	dec    %eax
  100808:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10080b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10080e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100811:	39 c2                	cmp    %eax,%edx
  100813:	7c 56                	jl     10086b <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
  100815:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100818:	89 c2                	mov    %eax,%edx
  10081a:	89 d0                	mov    %edx,%eax
  10081c:	01 c0                	add    %eax,%eax
  10081e:	01 d0                	add    %edx,%eax
  100820:	c1 e0 02             	shl    $0x2,%eax
  100823:	89 c2                	mov    %eax,%edx
  100825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100828:	01 d0                	add    %edx,%eax
  10082a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10082e:	3c 84                	cmp    $0x84,%al
  100830:	74 39                	je     10086b <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	89 d0                	mov    %edx,%eax
  100839:	01 c0                	add    %eax,%eax
  10083b:	01 d0                	add    %edx,%eax
  10083d:	c1 e0 02             	shl    $0x2,%eax
  100840:	89 c2                	mov    %eax,%edx
  100842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100845:	01 d0                	add    %edx,%eax
  100847:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084b:	3c 64                	cmp    $0x64,%al
  10084d:	75 b5                	jne    100804 <debuginfo_eip+0x224>
  10084f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100852:	89 c2                	mov    %eax,%edx
  100854:	89 d0                	mov    %edx,%eax
  100856:	01 c0                	add    %eax,%eax
  100858:	01 d0                	add    %edx,%eax
  10085a:	c1 e0 02             	shl    $0x2,%eax
  10085d:	89 c2                	mov    %eax,%edx
  10085f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100862:	01 d0                	add    %edx,%eax
  100864:	8b 40 08             	mov    0x8(%eax),%eax
  100867:	85 c0                	test   %eax,%eax
  100869:	74 99                	je     100804 <debuginfo_eip+0x224>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10086b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10086e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100871:	39 c2                	cmp    %eax,%edx
  100873:	7c 46                	jl     1008bb <debuginfo_eip+0x2db>
  100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	89 d0                	mov    %edx,%eax
  10087c:	01 c0                	add    %eax,%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	c1 e0 02             	shl    $0x2,%eax
  100883:	89 c2                	mov    %eax,%edx
  100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100888:	01 d0                	add    %edx,%eax
  10088a:	8b 00                	mov    (%eax),%eax
  10088c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10088f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100892:	29 d1                	sub    %edx,%ecx
  100894:	89 ca                	mov    %ecx,%edx
  100896:	39 d0                	cmp    %edx,%eax
  100898:	73 21                	jae    1008bb <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10089a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089d:	89 c2                	mov    %eax,%edx
  10089f:	89 d0                	mov    %edx,%eax
  1008a1:	01 c0                	add    %eax,%eax
  1008a3:	01 d0                	add    %edx,%eax
  1008a5:	c1 e0 02             	shl    $0x2,%eax
  1008a8:	89 c2                	mov    %eax,%edx
  1008aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ad:	01 d0                	add    %edx,%eax
  1008af:	8b 10                	mov    (%eax),%edx
  1008b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008b4:	01 c2                	add    %eax,%edx
  1008b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008c1:	39 c2                	cmp    %eax,%edx
  1008c3:	7d 46                	jge    10090b <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
  1008c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008c8:	40                   	inc    %eax
  1008c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008cc:	eb 16                	jmp    1008e4 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d1:	8b 40 14             	mov    0x14(%eax),%eax
  1008d4:	8d 50 01             	lea    0x1(%eax),%edx
  1008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008da:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e0:	40                   	inc    %eax
  1008e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008ea:	39 c2                	cmp    %eax,%edx
  1008ec:	7d 1d                	jge    10090b <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f1:	89 c2                	mov    %eax,%edx
  1008f3:	89 d0                	mov    %edx,%eax
  1008f5:	01 c0                	add    %eax,%eax
  1008f7:	01 d0                	add    %edx,%eax
  1008f9:	c1 e0 02             	shl    $0x2,%eax
  1008fc:	89 c2                	mov    %eax,%edx
  1008fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100901:	01 d0                	add    %edx,%eax
  100903:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100907:	3c a0                	cmp    $0xa0,%al
  100909:	74 c3                	je     1008ce <debuginfo_eip+0x2ee>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10090b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100910:	c9                   	leave  
  100911:	c3                   	ret    

00100912 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100912:	55                   	push   %ebp
  100913:	89 e5                	mov    %esp,%ebp
  100915:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100918:	c7 04 24 22 36 10 00 	movl   $0x103622,(%esp)
  10091f:	e8 48 f9 ff ff       	call   10026c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100924:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10092b:	00 
  10092c:	c7 04 24 3b 36 10 00 	movl   $0x10363b,(%esp)
  100933:	e8 34 f9 ff ff       	call   10026c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100938:	c7 44 24 04 12 35 10 	movl   $0x103512,0x4(%esp)
  10093f:	00 
  100940:	c7 04 24 53 36 10 00 	movl   $0x103653,(%esp)
  100947:	e8 20 f9 ff ff       	call   10026c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10094c:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100953:	00 
  100954:	c7 04 24 6b 36 10 00 	movl   $0x10366b,(%esp)
  10095b:	e8 0c f9 ff ff       	call   10026c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100960:	c7 44 24 04 80 fd 10 	movl   $0x10fd80,0x4(%esp)
  100967:	00 
  100968:	c7 04 24 83 36 10 00 	movl   $0x103683,(%esp)
  10096f:	e8 f8 f8 ff ff       	call   10026c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100974:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  100979:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10097f:	b8 00 00 10 00       	mov    $0x100000,%eax
  100984:	29 c2                	sub    %eax,%edx
  100986:	89 d0                	mov    %edx,%eax
  100988:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10098e:	85 c0                	test   %eax,%eax
  100990:	0f 48 c2             	cmovs  %edx,%eax
  100993:	c1 f8 0a             	sar    $0xa,%eax
  100996:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099a:	c7 04 24 9c 36 10 00 	movl   $0x10369c,(%esp)
  1009a1:	e8 c6 f8 ff ff       	call   10026c <cprintf>
}
  1009a6:	90                   	nop
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009b2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bc:	89 04 24             	mov    %eax,(%esp)
  1009bf:	e8 1c fc ff ff       	call   1005e0 <debuginfo_eip>
  1009c4:	85 c0                	test   %eax,%eax
  1009c6:	74 15                	je     1009dd <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1009cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009cf:	c7 04 24 c6 36 10 00 	movl   $0x1036c6,(%esp)
  1009d6:	e8 91 f8 ff ff       	call   10026c <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009db:	eb 6c                	jmp    100a49 <print_debuginfo+0xa0>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009e4:	eb 1b                	jmp    100a01 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  1009e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ec:	01 d0                	add    %edx,%eax
  1009ee:	0f b6 00             	movzbl (%eax),%eax
  1009f1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009fa:	01 ca                	add    %ecx,%edx
  1009fc:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009fe:	ff 45 f4             	incl   -0xc(%ebp)
  100a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a04:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100a07:	7f dd                	jg     1009e6 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100a09:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a12:	01 d0                	add    %edx,%eax
  100a14:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a1a:	8b 55 08             	mov    0x8(%ebp),%edx
  100a1d:	89 d1                	mov    %edx,%ecx
  100a1f:	29 c1                	sub    %eax,%ecx
  100a21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a27:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a2b:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a31:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a35:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3d:	c7 04 24 e2 36 10 00 	movl   $0x1036e2,(%esp)
  100a44:	e8 23 f8 ff ff       	call   10026c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  100a49:	90                   	nop
  100a4a:	c9                   	leave  
  100a4b:	c3                   	ret    

00100a4c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a4c:	55                   	push   %ebp
  100a4d:	89 e5                	mov    %esp,%ebp
  100a4f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a52:	8b 45 04             	mov    0x4(%ebp),%eax
  100a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a5b:	c9                   	leave  
  100a5c:	c3                   	ret    

00100a5d <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a5d:	55                   	push   %ebp
  100a5e:	89 e5                	mov    %esp,%ebp
  100a60:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a63:	89 e8                	mov    %ebp,%eax
  100a65:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return ebp;
  100a68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    // cprintf("ebp : %08x ",ebp);
    // cprintf("eip : %08x ",eip);
    // cprintf("esp : %08x ",esp);
    // cprintf("ss : %08x \n",ss);
    // print_debuginfo(eip);
    uint32_t ebp = read_ebp(), eip = read_eip();
  100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a6e:	e8 d9 ff ff ff       	call   100a4c <read_eip>
  100a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
    uint32_t *temp = (uint32_t *)ebp;
  100a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    temp = 0x00000524;
  100a7c:	c7 45 e4 24 05 00 00 	movl   $0x524,-0x1c(%ebp)
    cprintf("%08x",temp);
  100a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a86:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a8a:	c7 04 24 f4 36 10 00 	movl   $0x1036f4,(%esp)
  100a91:	e8 d6 f7 ff ff       	call   10026c <cprintf>
    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a96:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a9d:	e9 be 00 00 00       	jmp    100b60 <print_stackframe+0x103>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
  100aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab0:	c7 04 24 f9 36 10 00 	movl   $0x1036f9,(%esp)
  100ab7:	e8 b0 f7 ff ff       	call   10026c <cprintf>
        uint32_t *value = (uint32_t *)ebp;
  100abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100abf:	89 45 e0             	mov    %eax,-0x20(%ebp)
        cprintf("value at ebp0x%08x || ", *value);
  100ac2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100ac5:	8b 00                	mov    (%eax),%eax
  100ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100acb:	c7 04 24 15 37 10 00 	movl   $0x103715,(%esp)
  100ad2:	e8 95 f7 ff ff       	call   10026c <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ada:	83 c0 08             	add    $0x8,%eax
  100add:	89 45 dc             	mov    %eax,-0x24(%ebp)
        for (j = 0; j < 4; j ++) {
  100ae0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100ae7:	eb 43                	jmp    100b2c <print_stackframe+0xcf>
            cprintf("0x%08x ", args[j]);
  100ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100aec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100af6:	01 d0                	add    %edx,%eax
  100af8:	8b 00                	mov    (%eax),%eax
  100afa:	89 44 24 04          	mov    %eax,0x4(%esp)
  100afe:	c7 04 24 2c 37 10 00 	movl   $0x10372c,(%esp)
  100b05:	e8 62 f7 ff ff       	call   10026c <cprintf>
            cprintf("add:0x%08x ", &args[j]);
  100b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100b17:	01 d0                	add    %edx,%eax
  100b19:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1d:	c7 04 24 34 37 10 00 	movl   $0x103734,(%esp)
  100b24:	e8 43 f7 ff ff       	call   10026c <cprintf>
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *value = (uint32_t *)ebp;
        cprintf("value at ebp0x%08x || ", *value);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
  100b29:	ff 45 e8             	incl   -0x18(%ebp)
  100b2c:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b30:	7e b7                	jle    100ae9 <print_stackframe+0x8c>
            cprintf("0x%08x ", args[j]);
            cprintf("add:0x%08x ", &args[j]);
        }
        cprintf("\n");
  100b32:	c7 04 24 40 37 10 00 	movl   $0x103740,(%esp)
  100b39:	e8 2e f7 ff ff       	call   10026c <cprintf>
        print_debuginfo(eip - 1);
  100b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b41:	48                   	dec    %eax
  100b42:	89 04 24             	mov    %eax,(%esp)
  100b45:	e8 5f fe ff ff       	call   1009a9 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b4d:	83 c0 04             	add    $0x4,%eax
  100b50:	8b 00                	mov    (%eax),%eax
  100b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b58:	8b 00                	mov    (%eax),%eax
  100b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t ebp = read_ebp(), eip = read_eip();
    uint32_t *temp = (uint32_t *)ebp;
    temp = 0x00000524;
    cprintf("%08x",temp);
    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100b5d:	ff 45 ec             	incl   -0x14(%ebp)
  100b60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b64:	74 0a                	je     100b70 <print_stackframe+0x113>
  100b66:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b6a:	0f 8e 32 ff ff ff    	jle    100aa2 <print_stackframe+0x45>
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  100b70:	90                   	nop
  100b71:	c9                   	leave  
  100b72:	c3                   	ret    

00100b73 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b73:	55                   	push   %ebp
  100b74:	89 e5                	mov    %esp,%ebp
  100b76:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b80:	eb 0c                	jmp    100b8e <parse+0x1b>
            *buf ++ = '\0';
  100b82:	8b 45 08             	mov    0x8(%ebp),%eax
  100b85:	8d 50 01             	lea    0x1(%eax),%edx
  100b88:	89 55 08             	mov    %edx,0x8(%ebp)
  100b8b:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b91:	0f b6 00             	movzbl (%eax),%eax
  100b94:	84 c0                	test   %al,%al
  100b96:	74 1d                	je     100bb5 <parse+0x42>
  100b98:	8b 45 08             	mov    0x8(%ebp),%eax
  100b9b:	0f b6 00             	movzbl (%eax),%eax
  100b9e:	0f be c0             	movsbl %al,%eax
  100ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba5:	c7 04 24 c4 37 10 00 	movl   $0x1037c4,(%esp)
  100bac:	e8 b1 1f 00 00       	call   102b62 <strchr>
  100bb1:	85 c0                	test   %eax,%eax
  100bb3:	75 cd                	jne    100b82 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb8:	0f b6 00             	movzbl (%eax),%eax
  100bbb:	84 c0                	test   %al,%al
  100bbd:	74 69                	je     100c28 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bbf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bc3:	75 14                	jne    100bd9 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bc5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bcc:	00 
  100bcd:	c7 04 24 c9 37 10 00 	movl   $0x1037c9,(%esp)
  100bd4:	e8 93 f6 ff ff       	call   10026c <cprintf>
        }
        argv[argc ++] = buf;
  100bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bdc:	8d 50 01             	lea    0x1(%eax),%edx
  100bdf:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100be2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bec:	01 c2                	add    %eax,%edx
  100bee:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf1:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bf3:	eb 03                	jmp    100bf8 <parse+0x85>
            buf ++;
  100bf5:	ff 45 08             	incl   0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  100bfb:	0f b6 00             	movzbl (%eax),%eax
  100bfe:	84 c0                	test   %al,%al
  100c00:	0f 84 7a ff ff ff    	je     100b80 <parse+0xd>
  100c06:	8b 45 08             	mov    0x8(%ebp),%eax
  100c09:	0f b6 00             	movzbl (%eax),%eax
  100c0c:	0f be c0             	movsbl %al,%eax
  100c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c13:	c7 04 24 c4 37 10 00 	movl   $0x1037c4,(%esp)
  100c1a:	e8 43 1f 00 00       	call   102b62 <strchr>
  100c1f:	85 c0                	test   %eax,%eax
  100c21:	74 d2                	je     100bf5 <parse+0x82>
            buf ++;
        }
    }
  100c23:	e9 58 ff ff ff       	jmp    100b80 <parse+0xd>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100c28:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c2c:	c9                   	leave  
  100c2d:	c3                   	ret    

00100c2e <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c2e:	55                   	push   %ebp
  100c2f:	89 e5                	mov    %esp,%ebp
  100c31:	53                   	push   %ebx
  100c32:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c35:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  100c3f:	89 04 24             	mov    %eax,(%esp)
  100c42:	e8 2c ff ff ff       	call   100b73 <parse>
  100c47:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c4e:	75 0a                	jne    100c5a <runcmd+0x2c>
        return 0;
  100c50:	b8 00 00 00 00       	mov    $0x0,%eax
  100c55:	e9 83 00 00 00       	jmp    100cdd <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c61:	eb 5a                	jmp    100cbd <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c63:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c69:	89 d0                	mov    %edx,%eax
  100c6b:	01 c0                	add    %eax,%eax
  100c6d:	01 d0                	add    %edx,%eax
  100c6f:	c1 e0 02             	shl    $0x2,%eax
  100c72:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c77:	8b 00                	mov    (%eax),%eax
  100c79:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c7d:	89 04 24             	mov    %eax,(%esp)
  100c80:	e8 40 1e 00 00       	call   102ac5 <strcmp>
  100c85:	85 c0                	test   %eax,%eax
  100c87:	75 31                	jne    100cba <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c8c:	89 d0                	mov    %edx,%eax
  100c8e:	01 c0                	add    %eax,%eax
  100c90:	01 d0                	add    %edx,%eax
  100c92:	c1 e0 02             	shl    $0x2,%eax
  100c95:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c9a:	8b 10                	mov    (%eax),%edx
  100c9c:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c9f:	83 c0 04             	add    $0x4,%eax
  100ca2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100ca5:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100ca8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100cab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100caf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb3:	89 1c 24             	mov    %ebx,(%esp)
  100cb6:	ff d2                	call   *%edx
  100cb8:	eb 23                	jmp    100cdd <runcmd+0xaf>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cba:	ff 45 f4             	incl   -0xc(%ebp)
  100cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cc0:	83 f8 02             	cmp    $0x2,%eax
  100cc3:	76 9e                	jbe    100c63 <runcmd+0x35>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100cc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ccc:	c7 04 24 e7 37 10 00 	movl   $0x1037e7,(%esp)
  100cd3:	e8 94 f5 ff ff       	call   10026c <cprintf>
    return 0;
  100cd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cdd:	83 c4 64             	add    $0x64,%esp
  100ce0:	5b                   	pop    %ebx
  100ce1:	5d                   	pop    %ebp
  100ce2:	c3                   	ret    

00100ce3 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100ce3:	55                   	push   %ebp
  100ce4:	89 e5                	mov    %esp,%ebp
  100ce6:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ce9:	c7 04 24 00 38 10 00 	movl   $0x103800,(%esp)
  100cf0:	e8 77 f5 ff ff       	call   10026c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cf5:	c7 04 24 28 38 10 00 	movl   $0x103828,(%esp)
  100cfc:	e8 6b f5 ff ff       	call   10026c <cprintf>

    if (tf != NULL) {
  100d01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d05:	74 0b                	je     100d12 <kmonitor+0x2f>
        print_trapframe(tf);
  100d07:	8b 45 08             	mov    0x8(%ebp),%eax
  100d0a:	89 04 24             	mov    %eax,(%esp)
  100d0d:	e8 26 0d 00 00       	call   101a38 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d12:	c7 04 24 4d 38 10 00 	movl   $0x10384d,(%esp)
  100d19:	e8 f0 f5 ff ff       	call   10030e <readline>
  100d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d25:	74 eb                	je     100d12 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100d27:	8b 45 08             	mov    0x8(%ebp),%eax
  100d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d31:	89 04 24             	mov    %eax,(%esp)
  100d34:	e8 f5 fe ff ff       	call   100c2e <runcmd>
  100d39:	85 c0                	test   %eax,%eax
  100d3b:	78 02                	js     100d3f <kmonitor+0x5c>
                break;
            }
        }
    }
  100d3d:	eb d3                	jmp    100d12 <kmonitor+0x2f>

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
  100d3f:	90                   	nop
            }
        }
    }
}
  100d40:	90                   	nop
  100d41:	c9                   	leave  
  100d42:	c3                   	ret    

00100d43 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d43:	55                   	push   %ebp
  100d44:	89 e5                	mov    %esp,%ebp
  100d46:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d49:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d50:	eb 3d                	jmp    100d8f <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d55:	89 d0                	mov    %edx,%eax
  100d57:	01 c0                	add    %eax,%eax
  100d59:	01 d0                	add    %edx,%eax
  100d5b:	c1 e0 02             	shl    $0x2,%eax
  100d5e:	05 04 e0 10 00       	add    $0x10e004,%eax
  100d63:	8b 08                	mov    (%eax),%ecx
  100d65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d68:	89 d0                	mov    %edx,%eax
  100d6a:	01 c0                	add    %eax,%eax
  100d6c:	01 d0                	add    %edx,%eax
  100d6e:	c1 e0 02             	shl    $0x2,%eax
  100d71:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d76:	8b 00                	mov    (%eax),%eax
  100d78:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d80:	c7 04 24 51 38 10 00 	movl   $0x103851,(%esp)
  100d87:	e8 e0 f4 ff ff       	call   10026c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d8c:	ff 45 f4             	incl   -0xc(%ebp)
  100d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d92:	83 f8 02             	cmp    $0x2,%eax
  100d95:	76 bb                	jbe    100d52 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d9c:	c9                   	leave  
  100d9d:	c3                   	ret    

00100d9e <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d9e:	55                   	push   %ebp
  100d9f:	89 e5                	mov    %esp,%ebp
  100da1:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100da4:	e8 69 fb ff ff       	call   100912 <print_kerninfo>
    return 0;
  100da9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dae:	c9                   	leave  
  100daf:	c3                   	ret    

00100db0 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100db0:	55                   	push   %ebp
  100db1:	89 e5                	mov    %esp,%ebp
  100db3:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100db6:	e8 a2 fc ff ff       	call   100a5d <print_stackframe>
    return 0;
  100dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dc0:	c9                   	leave  
  100dc1:	c3                   	ret    

00100dc2 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dc2:	55                   	push   %ebp
  100dc3:	89 e5                	mov    %esp,%ebp
  100dc5:	83 ec 28             	sub    $0x28,%esp
  100dc8:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100dce:	c6 45 ef 34          	movb   $0x34,-0x11(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dd2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  100dd6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dda:	ee                   	out    %al,(%dx)
  100ddb:	66 c7 45 f4 40 00    	movw   $0x40,-0xc(%ebp)
  100de1:	c6 45 f0 9c          	movb   $0x9c,-0x10(%ebp)
  100de5:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  100de9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100dec:	ee                   	out    %al,(%dx)
  100ded:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100df3:	c6 45 f1 2e          	movb   $0x2e,-0xf(%ebp)
  100df7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dfb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dff:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e00:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100e07:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e0a:	c7 04 24 5a 38 10 00 	movl   $0x10385a,(%esp)
  100e11:	e8 56 f4 ff ff       	call   10026c <cprintf>
    pic_enable(IRQ_TIMER);
  100e16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e1d:	e8 ba 08 00 00       	call   1016dc <pic_enable>
}
  100e22:	90                   	nop
  100e23:	c9                   	leave  
  100e24:	c3                   	ret    

00100e25 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e25:	55                   	push   %ebp
  100e26:	89 e5                	mov    %esp,%ebp
  100e28:	83 ec 10             	sub    $0x10,%esp
  100e2b:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e31:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e35:	89 c2                	mov    %eax,%edx
  100e37:	ec                   	in     (%dx),%al
  100e38:	88 45 f4             	mov    %al,-0xc(%ebp)
  100e3b:	66 c7 45 fc 84 00    	movw   $0x84,-0x4(%ebp)
  100e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e44:	89 c2                	mov    %eax,%edx
  100e46:	ec                   	in     (%dx),%al
  100e47:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e4a:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e50:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e54:	89 c2                	mov    %eax,%edx
  100e56:	ec                   	in     (%dx),%al
  100e57:	88 45 f6             	mov    %al,-0xa(%ebp)
  100e5a:	66 c7 45 f8 84 00    	movw   $0x84,-0x8(%ebp)
  100e60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e63:	89 c2                	mov    %eax,%edx
  100e65:	ec                   	in     (%dx),%al
  100e66:	88 45 f7             	mov    %al,-0x9(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e69:	90                   	nop
  100e6a:	c9                   	leave  
  100e6b:	c3                   	ret    

00100e6c <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e6c:	55                   	push   %ebp
  100e6d:	89 e5                	mov    %esp,%ebp
  100e6f:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e72:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7c:	0f b7 00             	movzwl (%eax),%eax
  100e7f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e86:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8e:	0f b7 00             	movzwl (%eax),%eax
  100e91:	0f b7 c0             	movzwl %ax,%eax
  100e94:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e99:	74 12                	je     100ead <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e9b:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100ea2:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100ea9:	b4 03 
  100eab:	eb 13                	jmp    100ec0 <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100eb7:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100ebe:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100ec0:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ec7:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  100ecb:	c6 45 ea 0e          	movb   $0xe,-0x16(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ecf:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  100ed3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  100ed6:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ed7:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ede:	40                   	inc    %eax
  100edf:	0f b7 c0             	movzwl %ax,%eax
  100ee2:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ee6:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eea:	89 c2                	mov    %eax,%edx
  100eec:	ec                   	in     (%dx),%al
  100eed:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  100ef0:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  100ef4:	0f b6 c0             	movzbl %al,%eax
  100ef7:	c1 e0 08             	shl    $0x8,%eax
  100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100efd:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100f04:	66 89 45 f0          	mov    %ax,-0x10(%ebp)
  100f08:	c6 45 ec 0f          	movb   $0xf,-0x14(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f0c:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
  100f10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100f13:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100f14:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100f1b:	40                   	inc    %eax
  100f1c:	0f b7 c0             	movzwl %ax,%eax
  100f1f:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f23:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f27:	89 c2                	mov    %eax,%edx
  100f29:	ec                   	in     (%dx),%al
  100f2a:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f2d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f31:	0f b6 c0             	movzbl %al,%eax
  100f34:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f3a:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f42:	0f b7 c0             	movzwl %ax,%eax
  100f45:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100f4b:	90                   	nop
  100f4c:	c9                   	leave  
  100f4d:	c3                   	ret    

00100f4e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f4e:	55                   	push   %ebp
  100f4f:	89 e5                	mov    %esp,%ebp
  100f51:	83 ec 38             	sub    $0x38,%esp
  100f54:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f5a:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f5e:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  100f62:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f66:	ee                   	out    %al,(%dx)
  100f67:	66 c7 45 f4 fb 03    	movw   $0x3fb,-0xc(%ebp)
  100f6d:	c6 45 db 80          	movb   $0x80,-0x25(%ebp)
  100f71:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  100f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100f78:	ee                   	out    %al,(%dx)
  100f79:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  100f7f:	c6 45 dc 0c          	movb   $0xc,-0x24(%ebp)
  100f83:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  100f87:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f8b:	ee                   	out    %al,(%dx)
  100f8c:	66 c7 45 f0 f9 03    	movw   $0x3f9,-0x10(%ebp)
  100f92:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f96:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100f9d:	ee                   	out    %al,(%dx)
  100f9e:	66 c7 45 ee fb 03    	movw   $0x3fb,-0x12(%ebp)
  100fa4:	c6 45 de 03          	movb   $0x3,-0x22(%ebp)
  100fa8:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  100fac:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fb0:	ee                   	out    %al,(%dx)
  100fb1:	66 c7 45 ec fc 03    	movw   $0x3fc,-0x14(%ebp)
  100fb7:	c6 45 df 00          	movb   $0x0,-0x21(%ebp)
  100fbb:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  100fbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100fc2:	ee                   	out    %al,(%dx)
  100fc3:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fc9:	c6 45 e0 01          	movb   $0x1,-0x20(%ebp)
  100fcd:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  100fd1:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fd5:	ee                   	out    %al,(%dx)
  100fd6:	66 c7 45 e8 fd 03    	movw   $0x3fd,-0x18(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100fdf:	89 c2                	mov    %eax,%edx
  100fe1:	ec                   	in     (%dx),%al
  100fe2:	88 45 e1             	mov    %al,-0x1f(%ebp)
    return data;
  100fe5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fe9:	3c ff                	cmp    $0xff,%al
  100feb:	0f 95 c0             	setne  %al
  100fee:	0f b6 c0             	movzbl %al,%eax
  100ff1:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100ff6:	66 c7 45 e6 fa 03    	movw   $0x3fa,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ffc:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  101000:	89 c2                	mov    %eax,%edx
  101002:	ec                   	in     (%dx),%al
  101003:	88 45 e2             	mov    %al,-0x1e(%ebp)
  101006:	66 c7 45 e4 f8 03    	movw   $0x3f8,-0x1c(%ebp)
  10100c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10100f:	89 c2                	mov    %eax,%edx
  101011:	ec                   	in     (%dx),%al
  101012:	88 45 e3             	mov    %al,-0x1d(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101015:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10101a:	85 c0                	test   %eax,%eax
  10101c:	74 0c                	je     10102a <serial_init+0xdc>
        pic_enable(IRQ_COM1);
  10101e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101025:	e8 b2 06 00 00       	call   1016dc <pic_enable>
    }
}
  10102a:	90                   	nop
  10102b:	c9                   	leave  
  10102c:	c3                   	ret    

0010102d <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10102d:	55                   	push   %ebp
  10102e:	89 e5                	mov    %esp,%ebp
  101030:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101033:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10103a:	eb 08                	jmp    101044 <lpt_putc_sub+0x17>
        delay();
  10103c:	e8 e4 fd ff ff       	call   100e25 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101041:	ff 45 fc             	incl   -0x4(%ebp)
  101044:	66 c7 45 f4 79 03    	movw   $0x379,-0xc(%ebp)
  10104a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10104d:	89 c2                	mov    %eax,%edx
  10104f:	ec                   	in     (%dx),%al
  101050:	88 45 f3             	mov    %al,-0xd(%ebp)
    return data;
  101053:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101057:	84 c0                	test   %al,%al
  101059:	78 09                	js     101064 <lpt_putc_sub+0x37>
  10105b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101062:	7e d8                	jle    10103c <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101064:	8b 45 08             	mov    0x8(%ebp),%eax
  101067:	0f b6 c0             	movzbl %al,%eax
  10106a:	66 c7 45 f8 78 03    	movw   $0x378,-0x8(%ebp)
  101070:	88 45 f0             	mov    %al,-0x10(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101073:	0f b6 45 f0          	movzbl -0x10(%ebp),%eax
  101077:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10107a:	ee                   	out    %al,(%dx)
  10107b:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101081:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101085:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101089:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10108d:	ee                   	out    %al,(%dx)
  10108e:	66 c7 45 fa 7a 03    	movw   $0x37a,-0x6(%ebp)
  101094:	c6 45 f2 08          	movb   $0x8,-0xe(%ebp)
  101098:	0f b6 45 f2          	movzbl -0xe(%ebp),%eax
  10109c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1010a0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010a1:	90                   	nop
  1010a2:	c9                   	leave  
  1010a3:	c3                   	ret    

001010a4 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010a4:	55                   	push   %ebp
  1010a5:	89 e5                	mov    %esp,%ebp
  1010a7:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010aa:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010ae:	74 0d                	je     1010bd <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b3:	89 04 24             	mov    %eax,(%esp)
  1010b6:	e8 72 ff ff ff       	call   10102d <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010bb:	eb 24                	jmp    1010e1 <lpt_putc+0x3d>
lpt_putc(int c) {
    if (c != '\b') {
        lpt_putc_sub(c);
    }
    else {
        lpt_putc_sub('\b');
  1010bd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010c4:	e8 64 ff ff ff       	call   10102d <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010c9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010d0:	e8 58 ff ff ff       	call   10102d <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010d5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010dc:	e8 4c ff ff ff       	call   10102d <lpt_putc_sub>
    }
}
  1010e1:	90                   	nop
  1010e2:	c9                   	leave  
  1010e3:	c3                   	ret    

001010e4 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010e4:	55                   	push   %ebp
  1010e5:	89 e5                	mov    %esp,%ebp
  1010e7:	53                   	push   %ebx
  1010e8:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ee:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010f3:	85 c0                	test   %eax,%eax
  1010f5:	75 07                	jne    1010fe <cga_putc+0x1a>
        c |= 0x0700;
  1010f7:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101101:	0f b6 c0             	movzbl %al,%eax
  101104:	83 f8 0a             	cmp    $0xa,%eax
  101107:	74 54                	je     10115d <cga_putc+0x79>
  101109:	83 f8 0d             	cmp    $0xd,%eax
  10110c:	74 62                	je     101170 <cga_putc+0x8c>
  10110e:	83 f8 08             	cmp    $0x8,%eax
  101111:	0f 85 93 00 00 00    	jne    1011aa <cga_putc+0xc6>
    case '\b':
        if (crt_pos > 0) {
  101117:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10111e:	85 c0                	test   %eax,%eax
  101120:	0f 84 ae 00 00 00    	je     1011d4 <cga_putc+0xf0>
            crt_pos --;
  101126:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10112d:	48                   	dec    %eax
  10112e:	0f b7 c0             	movzwl %ax,%eax
  101131:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101137:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10113c:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  101143:	01 d2                	add    %edx,%edx
  101145:	01 c2                	add    %eax,%edx
  101147:	8b 45 08             	mov    0x8(%ebp),%eax
  10114a:	98                   	cwtl   
  10114b:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101150:	98                   	cwtl   
  101151:	83 c8 20             	or     $0x20,%eax
  101154:	98                   	cwtl   
  101155:	0f b7 c0             	movzwl %ax,%eax
  101158:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10115b:	eb 77                	jmp    1011d4 <cga_putc+0xf0>
    case '\n':
        crt_pos += CRT_COLS;
  10115d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101164:	83 c0 50             	add    $0x50,%eax
  101167:	0f b7 c0             	movzwl %ax,%eax
  10116a:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101170:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101177:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10117e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101183:	89 c8                	mov    %ecx,%eax
  101185:	f7 e2                	mul    %edx
  101187:	c1 ea 06             	shr    $0x6,%edx
  10118a:	89 d0                	mov    %edx,%eax
  10118c:	c1 e0 02             	shl    $0x2,%eax
  10118f:	01 d0                	add    %edx,%eax
  101191:	c1 e0 04             	shl    $0x4,%eax
  101194:	29 c1                	sub    %eax,%ecx
  101196:	89 c8                	mov    %ecx,%eax
  101198:	0f b7 c0             	movzwl %ax,%eax
  10119b:	29 c3                	sub    %eax,%ebx
  10119d:	89 d8                	mov    %ebx,%eax
  10119f:	0f b7 c0             	movzwl %ax,%eax
  1011a2:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  1011a8:	eb 2b                	jmp    1011d5 <cga_putc+0xf1>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011aa:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  1011b0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011b7:	8d 50 01             	lea    0x1(%eax),%edx
  1011ba:	0f b7 d2             	movzwl %dx,%edx
  1011bd:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  1011c4:	01 c0                	add    %eax,%eax
  1011c6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1011cc:	0f b7 c0             	movzwl %ax,%eax
  1011cf:	66 89 02             	mov    %ax,(%edx)
        break;
  1011d2:	eb 01                	jmp    1011d5 <cga_putc+0xf1>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  1011d4:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011d5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011dc:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011e1:	76 5d                	jbe    101240 <cga_putc+0x15c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011e3:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011e8:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011ee:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011f3:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011fa:	00 
  1011fb:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011ff:	89 04 24             	mov    %eax,(%esp)
  101202:	e8 51 1b 00 00       	call   102d58 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101207:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10120e:	eb 14                	jmp    101224 <cga_putc+0x140>
            crt_buf[i] = 0x0700 | ' ';
  101210:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101218:	01 d2                	add    %edx,%edx
  10121a:	01 d0                	add    %edx,%eax
  10121c:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101221:	ff 45 f4             	incl   -0xc(%ebp)
  101224:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10122b:	7e e3                	jle    101210 <cga_putc+0x12c>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10122d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101234:	83 e8 50             	sub    $0x50,%eax
  101237:	0f b7 c0             	movzwl %ax,%eax
  10123a:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101240:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101247:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10124b:	c6 45 e8 0e          	movb   $0xe,-0x18(%ebp)
  10124f:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
  101253:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101257:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101258:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10125f:	c1 e8 08             	shr    $0x8,%eax
  101262:	0f b7 c0             	movzwl %ax,%eax
  101265:	0f b6 c0             	movzbl %al,%eax
  101268:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10126f:	42                   	inc    %edx
  101270:	0f b7 d2             	movzwl %dx,%edx
  101273:	66 89 55 f0          	mov    %dx,-0x10(%ebp)
  101277:	88 45 e9             	mov    %al,-0x17(%ebp)
  10127a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10127e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  101281:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101282:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101289:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10128d:	c6 45 ea 0f          	movb   $0xf,-0x16(%ebp)
  101291:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
  101295:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101299:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10129a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1012a1:	0f b6 c0             	movzbl %al,%eax
  1012a4:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1012ab:	42                   	inc    %edx
  1012ac:	0f b7 d2             	movzwl %dx,%edx
  1012af:	66 89 55 ec          	mov    %dx,-0x14(%ebp)
  1012b3:	88 45 eb             	mov    %al,-0x15(%ebp)
  1012b6:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
  1012ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1012bd:	ee                   	out    %al,(%dx)
}
  1012be:	90                   	nop
  1012bf:	83 c4 24             	add    $0x24,%esp
  1012c2:	5b                   	pop    %ebx
  1012c3:	5d                   	pop    %ebp
  1012c4:	c3                   	ret    

001012c5 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c5:	55                   	push   %ebp
  1012c6:	89 e5                	mov    %esp,%ebp
  1012c8:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d2:	eb 08                	jmp    1012dc <serial_putc_sub+0x17>
        delay();
  1012d4:	e8 4c fb ff ff       	call   100e25 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d9:	ff 45 fc             	incl   -0x4(%ebp)
  1012dc:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1012e5:	89 c2                	mov    %eax,%edx
  1012e7:	ec                   	in     (%dx),%al
  1012e8:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1012eb:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1012ef:	0f b6 c0             	movzbl %al,%eax
  1012f2:	83 e0 20             	and    $0x20,%eax
  1012f5:	85 c0                	test   %eax,%eax
  1012f7:	75 09                	jne    101302 <serial_putc_sub+0x3d>
  1012f9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101300:	7e d2                	jle    1012d4 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101302:	8b 45 08             	mov    0x8(%ebp),%eax
  101305:	0f b6 c0             	movzbl %al,%eax
  101308:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
  10130e:	88 45 f6             	mov    %al,-0xa(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101311:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
  101315:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101319:	ee                   	out    %al,(%dx)
}
  10131a:	90                   	nop
  10131b:	c9                   	leave  
  10131c:	c3                   	ret    

0010131d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10131d:	55                   	push   %ebp
  10131e:	89 e5                	mov    %esp,%ebp
  101320:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101323:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101327:	74 0d                	je     101336 <serial_putc+0x19>
        serial_putc_sub(c);
  101329:	8b 45 08             	mov    0x8(%ebp),%eax
  10132c:	89 04 24             	mov    %eax,(%esp)
  10132f:	e8 91 ff ff ff       	call   1012c5 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101334:	eb 24                	jmp    10135a <serial_putc+0x3d>
serial_putc(int c) {
    if (c != '\b') {
        serial_putc_sub(c);
    }
    else {
        serial_putc_sub('\b');
  101336:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133d:	e8 83 ff ff ff       	call   1012c5 <serial_putc_sub>
        serial_putc_sub(' ');
  101342:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101349:	e8 77 ff ff ff       	call   1012c5 <serial_putc_sub>
        serial_putc_sub('\b');
  10134e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101355:	e8 6b ff ff ff       	call   1012c5 <serial_putc_sub>
    }
}
  10135a:	90                   	nop
  10135b:	c9                   	leave  
  10135c:	c3                   	ret    

0010135d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10135d:	55                   	push   %ebp
  10135e:	89 e5                	mov    %esp,%ebp
  101360:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101363:	eb 33                	jmp    101398 <cons_intr+0x3b>
        if (c != 0) {
  101365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101369:	74 2d                	je     101398 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10136b:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101370:	8d 50 01             	lea    0x1(%eax),%edx
  101373:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10137c:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101382:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101387:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138c:	75 0a                	jne    101398 <cons_intr+0x3b>
                cons.wpos = 0;
  10138e:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101395:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101398:	8b 45 08             	mov    0x8(%ebp),%eax
  10139b:	ff d0                	call   *%eax
  10139d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a4:	75 bf                	jne    101365 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a6:	90                   	nop
  1013a7:	c9                   	leave  
  1013a8:	c3                   	ret    

001013a9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a9:	55                   	push   %ebp
  1013aa:	89 e5                	mov    %esp,%ebp
  1013ac:	83 ec 10             	sub    $0x10,%esp
  1013af:	66 c7 45 f8 fd 03    	movw   $0x3fd,-0x8(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1013b8:	89 c2                	mov    %eax,%edx
  1013ba:	ec                   	in     (%dx),%al
  1013bb:	88 45 f7             	mov    %al,-0x9(%ebp)
    return data;
  1013be:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c2:	0f b6 c0             	movzbl %al,%eax
  1013c5:	83 e0 01             	and    $0x1,%eax
  1013c8:	85 c0                	test   %eax,%eax
  1013ca:	75 07                	jne    1013d3 <serial_proc_data+0x2a>
        return -1;
  1013cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d1:	eb 2a                	jmp    1013fd <serial_proc_data+0x54>
  1013d3:	66 c7 45 fa f8 03    	movw   $0x3f8,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013dd:	89 c2                	mov    %eax,%edx
  1013df:	ec                   	in     (%dx),%al
  1013e0:	88 45 f6             	mov    %al,-0xa(%ebp)
    return data;
  1013e3:	0f b6 45 f6          	movzbl -0xa(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e7:	0f b6 c0             	movzbl %al,%eax
  1013ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013ed:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f1:	75 07                	jne    1013fa <serial_proc_data+0x51>
        c = '\b';
  1013f3:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013fd:	c9                   	leave  
  1013fe:	c3                   	ret    

001013ff <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013ff:	55                   	push   %ebp
  101400:	89 e5                	mov    %esp,%ebp
  101402:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101405:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10140a:	85 c0                	test   %eax,%eax
  10140c:	74 0c                	je     10141a <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10140e:	c7 04 24 a9 13 10 00 	movl   $0x1013a9,(%esp)
  101415:	e8 43 ff ff ff       	call   10135d <cons_intr>
    }
}
  10141a:	90                   	nop
  10141b:	c9                   	leave  
  10141c:	c3                   	ret    

0010141d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10141d:	55                   	push   %ebp
  10141e:	89 e5                	mov    %esp,%ebp
  101420:	83 ec 28             	sub    $0x28,%esp
  101423:	66 c7 45 ec 64 00    	movw   $0x64,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101429:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10142c:	89 c2                	mov    %eax,%edx
  10142e:	ec                   	in     (%dx),%al
  10142f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101432:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101436:	0f b6 c0             	movzbl %al,%eax
  101439:	83 e0 01             	and    $0x1,%eax
  10143c:	85 c0                	test   %eax,%eax
  10143e:	75 0a                	jne    10144a <kbd_proc_data+0x2d>
        return -1;
  101440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101445:	e9 56 01 00 00       	jmp    1015a0 <kbd_proc_data+0x183>
  10144a:	66 c7 45 f0 60 00    	movw   $0x60,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101453:	89 c2                	mov    %eax,%edx
  101455:	ec                   	in     (%dx),%al
  101456:	88 45 ea             	mov    %al,-0x16(%ebp)
    return data;
  101459:	0f b6 45 ea          	movzbl -0x16(%ebp),%eax
    }

    data = inb(KBDATAP);
  10145d:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101460:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101464:	75 17                	jne    10147d <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101466:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10146b:	83 c8 40             	or     $0x40,%eax
  10146e:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101473:	b8 00 00 00 00       	mov    $0x0,%eax
  101478:	e9 23 01 00 00       	jmp    1015a0 <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  10147d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101481:	84 c0                	test   %al,%al
  101483:	79 45                	jns    1014ca <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101485:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148a:	83 e0 40             	and    $0x40,%eax
  10148d:	85 c0                	test   %eax,%eax
  10148f:	75 08                	jne    101499 <kbd_proc_data+0x7c>
  101491:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101495:	24 7f                	and    $0x7f,%al
  101497:	eb 04                	jmp    10149d <kbd_proc_data+0x80>
  101499:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a4:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014ab:	0c 40                	or     $0x40,%al
  1014ad:	0f b6 c0             	movzbl %al,%eax
  1014b0:	f7 d0                	not    %eax
  1014b2:	89 c2                	mov    %eax,%edx
  1014b4:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b9:	21 d0                	and    %edx,%eax
  1014bb:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1014c0:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c5:	e9 d6 00 00 00       	jmp    1015a0 <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  1014ca:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014cf:	83 e0 40             	and    $0x40,%eax
  1014d2:	85 c0                	test   %eax,%eax
  1014d4:	74 11                	je     1014e7 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d6:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014da:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014df:	83 e0 bf             	and    $0xffffffbf,%eax
  1014e2:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  1014e7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014eb:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014f2:	0f b6 d0             	movzbl %al,%edx
  1014f5:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014fa:	09 d0                	or     %edx,%eax
  1014fc:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101501:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101505:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  10150c:	0f b6 d0             	movzbl %al,%edx
  10150f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101514:	31 d0                	xor    %edx,%eax
  101516:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  10151b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101520:	83 e0 03             	and    $0x3,%eax
  101523:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  10152a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152e:	01 d0                	add    %edx,%eax
  101530:	0f b6 00             	movzbl (%eax),%eax
  101533:	0f b6 c0             	movzbl %al,%eax
  101536:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101539:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10153e:	83 e0 08             	and    $0x8,%eax
  101541:	85 c0                	test   %eax,%eax
  101543:	74 22                	je     101567 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101545:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101549:	7e 0c                	jle    101557 <kbd_proc_data+0x13a>
  10154b:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154f:	7f 06                	jg     101557 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  101551:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101555:	eb 10                	jmp    101567 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101557:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10155b:	7e 0a                	jle    101567 <kbd_proc_data+0x14a>
  10155d:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101561:	7f 04                	jg     101567 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101563:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101567:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10156c:	f7 d0                	not    %eax
  10156e:	83 e0 06             	and    $0x6,%eax
  101571:	85 c0                	test   %eax,%eax
  101573:	75 28                	jne    10159d <kbd_proc_data+0x180>
  101575:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10157c:	75 1f                	jne    10159d <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  10157e:	c7 04 24 75 38 10 00 	movl   $0x103875,(%esp)
  101585:	e8 e2 ec ff ff       	call   10026c <cprintf>
  10158a:	66 c7 45 ee 92 00    	movw   $0x92,-0x12(%ebp)
  101590:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101594:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101598:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10159c:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10159d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a0:	c9                   	leave  
  1015a1:	c3                   	ret    

001015a2 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015a2:	55                   	push   %ebp
  1015a3:	89 e5                	mov    %esp,%ebp
  1015a5:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a8:	c7 04 24 1d 14 10 00 	movl   $0x10141d,(%esp)
  1015af:	e8 a9 fd ff ff       	call   10135d <cons_intr>
}
  1015b4:	90                   	nop
  1015b5:	c9                   	leave  
  1015b6:	c3                   	ret    

001015b7 <kbd_init>:

static void
kbd_init(void) {
  1015b7:	55                   	push   %ebp
  1015b8:	89 e5                	mov    %esp,%ebp
  1015ba:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015bd:	e8 e0 ff ff ff       	call   1015a2 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015c9:	e8 0e 01 00 00       	call   1016dc <pic_enable>
}
  1015ce:	90                   	nop
  1015cf:	c9                   	leave  
  1015d0:	c3                   	ret    

001015d1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d1:	55                   	push   %ebp
  1015d2:	89 e5                	mov    %esp,%ebp
  1015d4:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d7:	e8 90 f8 ff ff       	call   100e6c <cga_init>
    serial_init();
  1015dc:	e8 6d f9 ff ff       	call   100f4e <serial_init>
    kbd_init();
  1015e1:	e8 d1 ff ff ff       	call   1015b7 <kbd_init>
    if (!serial_exists) {
  1015e6:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1015eb:	85 c0                	test   %eax,%eax
  1015ed:	75 0c                	jne    1015fb <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ef:	c7 04 24 81 38 10 00 	movl   $0x103881,(%esp)
  1015f6:	e8 71 ec ff ff       	call   10026c <cprintf>
    }
}
  1015fb:	90                   	nop
  1015fc:	c9                   	leave  
  1015fd:	c3                   	ret    

001015fe <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015fe:	55                   	push   %ebp
  1015ff:	89 e5                	mov    %esp,%ebp
  101601:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101604:	8b 45 08             	mov    0x8(%ebp),%eax
  101607:	89 04 24             	mov    %eax,(%esp)
  10160a:	e8 95 fa ff ff       	call   1010a4 <lpt_putc>
    cga_putc(c);
  10160f:	8b 45 08             	mov    0x8(%ebp),%eax
  101612:	89 04 24             	mov    %eax,(%esp)
  101615:	e8 ca fa ff ff       	call   1010e4 <cga_putc>
    serial_putc(c);
  10161a:	8b 45 08             	mov    0x8(%ebp),%eax
  10161d:	89 04 24             	mov    %eax,(%esp)
  101620:	e8 f8 fc ff ff       	call   10131d <serial_putc>
}
  101625:	90                   	nop
  101626:	c9                   	leave  
  101627:	c3                   	ret    

00101628 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101628:	55                   	push   %ebp
  101629:	89 e5                	mov    %esp,%ebp
  10162b:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  10162e:	e8 cc fd ff ff       	call   1013ff <serial_intr>
    kbd_intr();
  101633:	e8 6a ff ff ff       	call   1015a2 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  101638:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  10163e:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101643:	39 c2                	cmp    %eax,%edx
  101645:	74 36                	je     10167d <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  101647:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10164c:	8d 50 01             	lea    0x1(%eax),%edx
  10164f:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101655:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  10165c:	0f b6 c0             	movzbl %al,%eax
  10165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101662:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101667:	3d 00 02 00 00       	cmp    $0x200,%eax
  10166c:	75 0a                	jne    101678 <cons_getc+0x50>
            cons.rpos = 0;
  10166e:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101675:	00 00 00 
        }
        return c;
  101678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10167b:	eb 05                	jmp    101682 <cons_getc+0x5a>
    }
    return 0;
  10167d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101682:	c9                   	leave  
  101683:	c3                   	ret    

00101684 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101684:	55                   	push   %ebp
  101685:	89 e5                	mov    %esp,%ebp
  101687:	83 ec 14             	sub    $0x14,%esp
  10168a:	8b 45 08             	mov    0x8(%ebp),%eax
  10168d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101694:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10169a:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  10169f:	85 c0                	test   %eax,%eax
  1016a1:	74 36                	je     1016d9 <pic_setmask+0x55>
        outb(IO_PIC1 + 1, mask);
  1016a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016a6:	0f b6 c0             	movzbl %al,%eax
  1016a9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016af:	88 45 fa             	mov    %al,-0x6(%ebp)
  1016b2:	0f b6 45 fa          	movzbl -0x6(%ebp),%eax
  1016b6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ba:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016bb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016bf:	c1 e8 08             	shr    $0x8,%eax
  1016c2:	0f b7 c0             	movzwl %ax,%eax
  1016c5:	0f b6 c0             	movzbl %al,%eax
  1016c8:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  1016ce:	88 45 fb             	mov    %al,-0x5(%ebp)
  1016d1:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
  1016d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1016d8:	ee                   	out    %al,(%dx)
    }
}
  1016d9:	90                   	nop
  1016da:	c9                   	leave  
  1016db:	c3                   	ret    

001016dc <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016dc:	55                   	push   %ebp
  1016dd:	89 e5                	mov    %esp,%ebp
  1016df:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1016e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016e5:	ba 01 00 00 00       	mov    $0x1,%edx
  1016ea:	88 c1                	mov    %al,%cl
  1016ec:	d3 e2                	shl    %cl,%edx
  1016ee:	89 d0                	mov    %edx,%eax
  1016f0:	98                   	cwtl   
  1016f1:	f7 d0                	not    %eax
  1016f3:	0f bf d0             	movswl %ax,%edx
  1016f6:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016fd:	98                   	cwtl   
  1016fe:	21 d0                	and    %edx,%eax
  101700:	98                   	cwtl   
  101701:	0f b7 c0             	movzwl %ax,%eax
  101704:	89 04 24             	mov    %eax,(%esp)
  101707:	e8 78 ff ff ff       	call   101684 <pic_setmask>
}
  10170c:	90                   	nop
  10170d:	c9                   	leave  
  10170e:	c3                   	ret    

0010170f <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10170f:	55                   	push   %ebp
  101710:	89 e5                	mov    %esp,%ebp
  101712:	83 ec 34             	sub    $0x34,%esp
    did_init = 1;
  101715:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  10171c:	00 00 00 
  10171f:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101725:	c6 45 d6 ff          	movb   $0xff,-0x2a(%ebp)
  101729:	0f b6 45 d6          	movzbl -0x2a(%ebp),%eax
  10172d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101731:	ee                   	out    %al,(%dx)
  101732:	66 c7 45 fc a1 00    	movw   $0xa1,-0x4(%ebp)
  101738:	c6 45 d7 ff          	movb   $0xff,-0x29(%ebp)
  10173c:	0f b6 45 d7          	movzbl -0x29(%ebp),%eax
  101740:	8b 55 fc             	mov    -0x4(%ebp),%edx
  101743:	ee                   	out    %al,(%dx)
  101744:	66 c7 45 fa 20 00    	movw   $0x20,-0x6(%ebp)
  10174a:	c6 45 d8 11          	movb   $0x11,-0x28(%ebp)
  10174e:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
  101752:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101756:	ee                   	out    %al,(%dx)
  101757:	66 c7 45 f8 21 00    	movw   $0x21,-0x8(%ebp)
  10175d:	c6 45 d9 20          	movb   $0x20,-0x27(%ebp)
  101761:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101765:	8b 55 f8             	mov    -0x8(%ebp),%edx
  101768:	ee                   	out    %al,(%dx)
  101769:	66 c7 45 f6 21 00    	movw   $0x21,-0xa(%ebp)
  10176f:	c6 45 da 04          	movb   $0x4,-0x26(%ebp)
  101773:	0f b6 45 da          	movzbl -0x26(%ebp),%eax
  101777:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10177b:	ee                   	out    %al,(%dx)
  10177c:	66 c7 45 f4 21 00    	movw   $0x21,-0xc(%ebp)
  101782:	c6 45 db 03          	movb   $0x3,-0x25(%ebp)
  101786:	0f b6 45 db          	movzbl -0x25(%ebp),%eax
  10178a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10178d:	ee                   	out    %al,(%dx)
  10178e:	66 c7 45 f2 a0 00    	movw   $0xa0,-0xe(%ebp)
  101794:	c6 45 dc 11          	movb   $0x11,-0x24(%ebp)
  101798:	0f b6 45 dc          	movzbl -0x24(%ebp),%eax
  10179c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017a0:	ee                   	out    %al,(%dx)
  1017a1:	66 c7 45 f0 a1 00    	movw   $0xa1,-0x10(%ebp)
  1017a7:	c6 45 dd 28          	movb   $0x28,-0x23(%ebp)
  1017ab:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1017b2:	ee                   	out    %al,(%dx)
  1017b3:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017b9:	c6 45 de 02          	movb   $0x2,-0x22(%ebp)
  1017bd:	0f b6 45 de          	movzbl -0x22(%ebp),%eax
  1017c1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017c5:	ee                   	out    %al,(%dx)
  1017c6:	66 c7 45 ec a1 00    	movw   $0xa1,-0x14(%ebp)
  1017cc:	c6 45 df 03          	movb   $0x3,-0x21(%ebp)
  1017d0:	0f b6 45 df          	movzbl -0x21(%ebp),%eax
  1017d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1017d7:	ee                   	out    %al,(%dx)
  1017d8:	66 c7 45 ea 20 00    	movw   $0x20,-0x16(%ebp)
  1017de:	c6 45 e0 68          	movb   $0x68,-0x20(%ebp)
  1017e2:	0f b6 45 e0          	movzbl -0x20(%ebp),%eax
  1017e6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017ea:	ee                   	out    %al,(%dx)
  1017eb:	66 c7 45 e8 20 00    	movw   $0x20,-0x18(%ebp)
  1017f1:	c6 45 e1 0a          	movb   $0xa,-0x1f(%ebp)
  1017f5:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1017fc:	ee                   	out    %al,(%dx)
  1017fd:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101803:	c6 45 e2 68          	movb   $0x68,-0x1e(%ebp)
  101807:	0f b6 45 e2          	movzbl -0x1e(%ebp),%eax
  10180b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10180f:	ee                   	out    %al,(%dx)
  101810:	66 c7 45 e4 a0 00    	movw   $0xa0,-0x1c(%ebp)
  101816:	c6 45 e3 0a          	movb   $0xa,-0x1d(%ebp)
  10181a:	0f b6 45 e3          	movzbl -0x1d(%ebp),%eax
  10181e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  101821:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101822:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101829:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10182e:	74 0f                	je     10183f <pic_init+0x130>
        pic_setmask(irq_mask);
  101830:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101837:	89 04 24             	mov    %eax,(%esp)
  10183a:	e8 45 fe ff ff       	call   101684 <pic_setmask>
    }
}
  10183f:	90                   	nop
  101840:	c9                   	leave  
  101841:	c3                   	ret    

00101842 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101842:	55                   	push   %ebp
  101843:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101845:	fb                   	sti    
    sti();
}
  101846:	90                   	nop
  101847:	5d                   	pop    %ebp
  101848:	c3                   	ret    

00101849 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101849:	55                   	push   %ebp
  10184a:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  10184c:	fa                   	cli    
    cli();
}
  10184d:	90                   	nop
  10184e:	5d                   	pop    %ebp
  10184f:	c3                   	ret    

00101850 <print_ticks>:

#define TICK_NUM 100

struct trapframe switchk2u, *switchu2k;

static void print_ticks() {
  101850:	55                   	push   %ebp
  101851:	89 e5                	mov    %esp,%ebp
  101853:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101856:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10185d:	00 
  10185e:	c7 04 24 a0 38 10 00 	movl   $0x1038a0,(%esp)
  101865:	e8 02 ea ff ff       	call   10026c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10186a:	90                   	nop
  10186b:	c9                   	leave  
  10186c:	c3                   	ret    

0010186d <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10186d:	55                   	push   %ebp
  10186e:	89 e5                	mov    %esp,%ebp
  101870:	83 ec 10             	sub    $0x10,%esp
    extern uintptr_t __vectors[];
    for(int i = 0; i < sizeof(idt)/sizeof(struct gatedesc);i++){
  101873:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10187a:	e9 c4 00 00 00       	jmp    101943 <idt_init+0xd6>
        SETGATE(idt[i],0,GD_KTEXT, __vectors[i],DPL_KERNEL);
  10187f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101882:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101889:	0f b7 d0             	movzwl %ax,%edx
  10188c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188f:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101896:	00 
  101897:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189a:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  1018a1:	00 08 00 
  1018a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a7:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  1018ae:	00 
  1018af:	80 e2 e0             	and    $0xe0,%dl
  1018b2:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1018b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bc:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  1018c3:	00 
  1018c4:	80 e2 1f             	and    $0x1f,%dl
  1018c7:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d1:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d8:	00 
  1018d9:	80 e2 f0             	and    $0xf0,%dl
  1018dc:	80 ca 0e             	or     $0xe,%dl
  1018df:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e9:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018f0:	00 
  1018f1:	80 e2 ef             	and    $0xef,%dl
  1018f4:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fe:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101905:	00 
  101906:	80 e2 9f             	and    $0x9f,%dl
  101909:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101913:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10191a:	00 
  10191b:	80 ca 80             	or     $0x80,%dl
  10191e:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101925:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101928:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10192f:	c1 e8 10             	shr    $0x10,%eax
  101932:	0f b7 d0             	movzwl %ax,%edx
  101935:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101938:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  10193f:	00 

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
    extern uintptr_t __vectors[];
    for(int i = 0; i < sizeof(idt)/sizeof(struct gatedesc);i++){
  101940:	ff 45 fc             	incl   -0x4(%ebp)
  101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101946:	3d ff 00 00 00       	cmp    $0xff,%eax
  10194b:	0f 86 2e ff ff ff    	jbe    10187f <idt_init+0x12>
        SETGATE(idt[i],0,GD_KTEXT, __vectors[i],DPL_KERNEL);
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101951:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101956:	0f b7 c0             	movzwl %ax,%eax
  101959:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  10195f:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101966:	08 00 
  101968:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10196f:	24 e0                	and    $0xe0,%al
  101971:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101976:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10197d:	24 1f                	and    $0x1f,%al
  10197f:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101984:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10198b:	24 f0                	and    $0xf0,%al
  10198d:	0c 0e                	or     $0xe,%al
  10198f:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101994:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10199b:	24 ef                	and    $0xef,%al
  10199d:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019a2:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019a9:	0c 60                	or     $0x60,%al
  1019ab:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019b0:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019b7:	0c 80                	or     $0x80,%al
  1019b9:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019be:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1019c3:	c1 e8 10             	shr    $0x10,%eax
  1019c6:	0f b7 c0             	movzwl %ax,%eax
  1019c9:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  1019cf:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019d9:	0f 01 18             	lidtl  (%eax)
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  1019dc:	90                   	nop
  1019dd:	c9                   	leave  
  1019de:	c3                   	ret    

001019df <trapname>:

static const char *
trapname(int trapno) {
  1019df:	55                   	push   %ebp
  1019e0:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e5:	83 f8 13             	cmp    $0x13,%eax
  1019e8:	77 0c                	ja     1019f6 <trapname+0x17>
        return excnames[trapno];
  1019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ed:	8b 04 85 20 3c 10 00 	mov    0x103c20(,%eax,4),%eax
  1019f4:	eb 2b                	jmp    101a21 <trapname+0x42>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019f6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019fa:	7e 0d                	jle    101a09 <trapname+0x2a>
  1019fc:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a00:	7f 07                	jg     101a09 <trapname+0x2a>
        return "Hardware Interrupt";
  101a02:	b8 aa 38 10 00       	mov    $0x1038aa,%eax
  101a07:	eb 18                	jmp    101a21 <trapname+0x42>
    }
    if (trapno == 121 || trapno == 120){
  101a09:	83 7d 08 79          	cmpl   $0x79,0x8(%ebp)
  101a0d:	74 06                	je     101a15 <trapname+0x36>
  101a0f:	83 7d 08 78          	cmpl   $0x78,0x8(%ebp)
  101a13:	75 07                	jne    101a1c <trapname+0x3d>
        return "Switch Interrupt";
  101a15:	b8 bd 38 10 00       	mov    $0x1038bd,%eax
  101a1a:	eb 05                	jmp    101a21 <trapname+0x42>
    }
    return "(unknown trap)";
  101a1c:	b8 ce 38 10 00       	mov    $0x1038ce,%eax
}
  101a21:	5d                   	pop    %ebp
  101a22:	c3                   	ret    

00101a23 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a23:	55                   	push   %ebp
  101a24:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a26:	8b 45 08             	mov    0x8(%ebp),%eax
  101a29:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a2d:	83 f8 08             	cmp    $0x8,%eax
  101a30:	0f 94 c0             	sete   %al
  101a33:	0f b6 c0             	movzbl %al,%eax
}
  101a36:	5d                   	pop    %ebp
  101a37:	c3                   	ret    

00101a38 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a38:	55                   	push   %ebp
  101a39:	89 e5                	mov    %esp,%ebp
  101a3b:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a45:	c7 04 24 0f 39 10 00 	movl   $0x10390f,(%esp)
  101a4c:	e8 1b e8 ff ff       	call   10026c <cprintf>
    print_regs(&tf->tf_regs);
  101a51:	8b 45 08             	mov    0x8(%ebp),%eax
  101a54:	89 04 24             	mov    %eax,(%esp)
  101a57:	e8 91 01 00 00       	call   101bed <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5f:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a63:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a67:	c7 04 24 20 39 10 00 	movl   $0x103920,(%esp)
  101a6e:	e8 f9 e7 ff ff       	call   10026c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a73:	8b 45 08             	mov    0x8(%ebp),%eax
  101a76:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7e:	c7 04 24 33 39 10 00 	movl   $0x103933,(%esp)
  101a85:	e8 e2 e7 ff ff       	call   10026c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8d:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a91:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a95:	c7 04 24 46 39 10 00 	movl   $0x103946,(%esp)
  101a9c:	e8 cb e7 ff ff       	call   10026c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa4:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aac:	c7 04 24 59 39 10 00 	movl   $0x103959,(%esp)
  101ab3:	e8 b4 e7 ff ff       	call   10026c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  101abb:	8b 40 30             	mov    0x30(%eax),%eax
  101abe:	89 04 24             	mov    %eax,(%esp)
  101ac1:	e8 19 ff ff ff       	call   1019df <trapname>
  101ac6:	89 c2                	mov    %eax,%edx
  101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  101acb:	8b 40 30             	mov    0x30(%eax),%eax
  101ace:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad6:	c7 04 24 6c 39 10 00 	movl   $0x10396c,(%esp)
  101add:	e8 8a e7 ff ff       	call   10026c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae5:	8b 40 34             	mov    0x34(%eax),%eax
  101ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aec:	c7 04 24 7e 39 10 00 	movl   $0x10397e,(%esp)
  101af3:	e8 74 e7 ff ff       	call   10026c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101af8:	8b 45 08             	mov    0x8(%ebp),%eax
  101afb:	8b 40 38             	mov    0x38(%eax),%eax
  101afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b02:	c7 04 24 8d 39 10 00 	movl   $0x10398d,(%esp)
  101b09:	e8 5e e7 ff ff       	call   10026c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b11:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b19:	c7 04 24 9c 39 10 00 	movl   $0x10399c,(%esp)
  101b20:	e8 47 e7 ff ff       	call   10026c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b25:	8b 45 08             	mov    0x8(%ebp),%eax
  101b28:	8b 40 40             	mov    0x40(%eax),%eax
  101b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2f:	c7 04 24 af 39 10 00 	movl   $0x1039af,(%esp)
  101b36:	e8 31 e7 ff ff       	call   10026c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b42:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b49:	eb 3d                	jmp    101b88 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4e:	8b 50 40             	mov    0x40(%eax),%edx
  101b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b54:	21 d0                	and    %edx,%eax
  101b56:	85 c0                	test   %eax,%eax
  101b58:	74 28                	je     101b82 <print_trapframe+0x14a>
  101b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b5d:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b64:	85 c0                	test   %eax,%eax
  101b66:	74 1a                	je     101b82 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b6b:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b76:	c7 04 24 be 39 10 00 	movl   $0x1039be,(%esp)
  101b7d:	e8 ea e6 ff ff       	call   10026c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b82:	ff 45 f4             	incl   -0xc(%ebp)
  101b85:	d1 65 f0             	shll   -0x10(%ebp)
  101b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b8b:	83 f8 17             	cmp    $0x17,%eax
  101b8e:	76 bb                	jbe    101b4b <print_trapframe+0x113>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b90:	8b 45 08             	mov    0x8(%ebp),%eax
  101b93:	8b 40 40             	mov    0x40(%eax),%eax
  101b96:	25 00 30 00 00       	and    $0x3000,%eax
  101b9b:	c1 e8 0c             	shr    $0xc,%eax
  101b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba2:	c7 04 24 c2 39 10 00 	movl   $0x1039c2,(%esp)
  101ba9:	e8 be e6 ff ff       	call   10026c <cprintf>

    if (!trap_in_kernel(tf)) {
  101bae:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb1:	89 04 24             	mov    %eax,(%esp)
  101bb4:	e8 6a fe ff ff       	call   101a23 <trap_in_kernel>
  101bb9:	85 c0                	test   %eax,%eax
  101bbb:	75 2d                	jne    101bea <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc0:	8b 40 44             	mov    0x44(%eax),%eax
  101bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc7:	c7 04 24 cb 39 10 00 	movl   $0x1039cb,(%esp)
  101bce:	e8 99 e6 ff ff       	call   10026c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd6:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bda:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bde:	c7 04 24 da 39 10 00 	movl   $0x1039da,(%esp)
  101be5:	e8 82 e6 ff ff       	call   10026c <cprintf>
    }
}
  101bea:	90                   	nop
  101beb:	c9                   	leave  
  101bec:	c3                   	ret    

00101bed <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bed:	55                   	push   %ebp
  101bee:	89 e5                	mov    %esp,%ebp
  101bf0:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf6:	8b 00                	mov    (%eax),%eax
  101bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfc:	c7 04 24 ed 39 10 00 	movl   $0x1039ed,(%esp)
  101c03:	e8 64 e6 ff ff       	call   10026c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c08:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0b:	8b 40 04             	mov    0x4(%eax),%eax
  101c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c12:	c7 04 24 fc 39 10 00 	movl   $0x1039fc,(%esp)
  101c19:	e8 4e e6 ff ff       	call   10026c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c21:	8b 40 08             	mov    0x8(%eax),%eax
  101c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c28:	c7 04 24 0b 3a 10 00 	movl   $0x103a0b,(%esp)
  101c2f:	e8 38 e6 ff ff       	call   10026c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c34:	8b 45 08             	mov    0x8(%ebp),%eax
  101c37:	8b 40 0c             	mov    0xc(%eax),%eax
  101c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3e:	c7 04 24 1a 3a 10 00 	movl   $0x103a1a,(%esp)
  101c45:	e8 22 e6 ff ff       	call   10026c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4d:	8b 40 10             	mov    0x10(%eax),%eax
  101c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c54:	c7 04 24 29 3a 10 00 	movl   $0x103a29,(%esp)
  101c5b:	e8 0c e6 ff ff       	call   10026c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c60:	8b 45 08             	mov    0x8(%ebp),%eax
  101c63:	8b 40 14             	mov    0x14(%eax),%eax
  101c66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6a:	c7 04 24 38 3a 10 00 	movl   $0x103a38,(%esp)
  101c71:	e8 f6 e5 ff ff       	call   10026c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c76:	8b 45 08             	mov    0x8(%ebp),%eax
  101c79:	8b 40 18             	mov    0x18(%eax),%eax
  101c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c80:	c7 04 24 47 3a 10 00 	movl   $0x103a47,(%esp)
  101c87:	e8 e0 e5 ff ff       	call   10026c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8f:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c92:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c96:	c7 04 24 56 3a 10 00 	movl   $0x103a56,(%esp)
  101c9d:	e8 ca e5 ff ff       	call   10026c <cprintf>
}
  101ca2:	90                   	nop
  101ca3:	c9                   	leave  
  101ca4:	c3                   	ret    

00101ca5 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ca5:	55                   	push   %ebp
  101ca6:	89 e5                	mov    %esp,%ebp
  101ca8:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101cab:	8b 45 08             	mov    0x8(%ebp),%eax
  101cae:	8b 40 30             	mov    0x30(%eax),%eax
  101cb1:	83 f8 2f             	cmp    $0x2f,%eax
  101cb4:	77 21                	ja     101cd7 <trap_dispatch+0x32>
  101cb6:	83 f8 2e             	cmp    $0x2e,%eax
  101cb9:	0f 83 4d 01 00 00    	jae    101e0c <trap_dispatch+0x167>
  101cbf:	83 f8 21             	cmp    $0x21,%eax
  101cc2:	74 4a                	je     101d0e <trap_dispatch+0x69>
  101cc4:	83 f8 24             	cmp    $0x24,%eax
  101cc7:	74 1c                	je     101ce5 <trap_dispatch+0x40>
  101cc9:	83 f8 20             	cmp    $0x20,%eax
  101ccc:	0f 84 3d 01 00 00    	je     101e0f <trap_dispatch+0x16a>
  101cd2:	e9 00 01 00 00       	jmp    101dd7 <trap_dispatch+0x132>
  101cd7:	83 e8 78             	sub    $0x78,%eax
  101cda:	83 f8 01             	cmp    $0x1,%eax
  101cdd:	0f 87 f4 00 00 00    	ja     101dd7 <trap_dispatch+0x132>
  101ce3:	eb 52                	jmp    101d37 <trap_dispatch+0x92>
         * (3) Too Simple? Yes, I think so!
         */
        // cprintf("hello");
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ce5:	e8 3e f9 ff ff       	call   101628 <cons_getc>
  101cea:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ced:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cf5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfd:	c7 04 24 65 3a 10 00 	movl   $0x103a65,(%esp)
  101d04:	e8 63 e5 ff ff       	call   10026c <cprintf>
        break;
  101d09:	e9 05 01 00 00       	jmp    101e13 <trap_dispatch+0x16e>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d0e:	e8 15 f9 ff ff       	call   101628 <cons_getc>
  101d13:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d16:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d1a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d1e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d26:	c7 04 24 77 3a 10 00 	movl   $0x103a77,(%esp)
  101d2d:	e8 3a e5 ff ff       	call   10026c <cprintf>
        break;
  101d32:	e9 dc 00 00 00       	jmp    101e13 <trap_dispatch+0x16e>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        cprintf("T_SWITCH_** ??\n");
  101d37:	c7 04 24 86 3a 10 00 	movl   $0x103a86,(%esp)
  101d3e:	e8 29 e5 ff ff       	call   10026c <cprintf>
        print_trapframe(tf);
  101d43:	8b 45 08             	mov    0x8(%ebp),%eax
  101d46:	89 04 24             	mov    %eax,(%esp)
  101d49:	e8 ea fc ff ff       	call   101a38 <print_trapframe>
        cprintf("T_SWITCH_** ??\n");
  101d4e:	c7 04 24 86 3a 10 00 	movl   $0x103a86,(%esp)
  101d55:	e8 12 e5 ff ff       	call   10026c <cprintf>
        if (tf->tf_cs != KERNEL_CS) {
  101d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d61:	83 f8 08             	cmp    $0x8,%eax
  101d64:	0f 84 a8 00 00 00    	je     101e12 <trap_dispatch+0x16d>
            tf->tf_cs = KERNEL_CS;
  101d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6d:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101d73:	8b 45 08             	mov    0x8(%ebp),%eax
  101d76:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7f:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101d83:	8b 45 08             	mov    0x8(%ebp),%eax
  101d86:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8d:	8b 40 40             	mov    0x40(%eax),%eax
  101d90:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101d95:	89 c2                	mov    %eax,%edx
  101d97:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9a:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101da0:	8b 40 44             	mov    0x44(%eax),%eax
  101da3:	83 e8 44             	sub    $0x44,%eax
  101da6:	a3 6c f9 10 00       	mov    %eax,0x10f96c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101dab:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101db0:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101db7:	00 
  101db8:	8b 55 08             	mov    0x8(%ebp),%edx
  101dbb:	89 54 24 04          	mov    %edx,0x4(%esp)
  101dbf:	89 04 24             	mov    %eax,(%esp)
  101dc2:	e8 91 0f 00 00       	call   102d58 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dca:	83 e8 04             	sub    $0x4,%eax
  101dcd:	8b 15 6c f9 10 00    	mov    0x10f96c,%edx
  101dd3:	89 10                	mov    %edx,(%eax)
        }
        break;
  101dd5:	eb 3b                	jmp    101e12 <trap_dispatch+0x16d>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dda:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dde:	83 e0 03             	and    $0x3,%eax
  101de1:	85 c0                	test   %eax,%eax
  101de3:	75 2e                	jne    101e13 <trap_dispatch+0x16e>
            print_trapframe(tf);
  101de5:	8b 45 08             	mov    0x8(%ebp),%eax
  101de8:	89 04 24             	mov    %eax,(%esp)
  101deb:	e8 48 fc ff ff       	call   101a38 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101df0:	c7 44 24 08 96 3a 10 	movl   $0x103a96,0x8(%esp)
  101df7:	00 
  101df8:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  101dff:	00 
  101e00:	c7 04 24 b2 3a 10 00 	movl   $0x103ab2,(%esp)
  101e07:	e8 b7 e5 ff ff       	call   1003c3 <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e0c:	90                   	nop
  101e0d:	eb 04                	jmp    101e13 <trap_dispatch+0x16e>
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        // cprintf("hello");
        break;
  101e0f:	90                   	nop
  101e10:	eb 01                	jmp    101e13 <trap_dispatch+0x16e>
            tf->tf_eflags &= ~FL_IOPL_MASK;
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
        }
        break;
  101e12:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e13:	90                   	nop
  101e14:	c9                   	leave  
  101e15:	c3                   	ret    

00101e16 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e16:	55                   	push   %ebp
  101e17:	89 e5                	mov    %esp,%ebp
  101e19:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1f:	89 04 24             	mov    %eax,(%esp)
  101e22:	e8 7e fe ff ff       	call   101ca5 <trap_dispatch>
}
  101e27:	90                   	nop
  101e28:	c9                   	leave  
  101e29:	c3                   	ret    

00101e2a <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e2a:	6a 00                	push   $0x0
  pushl $0
  101e2c:	6a 00                	push   $0x0
  jmp __alltraps
  101e2e:	e9 69 0a 00 00       	jmp    10289c <__alltraps>

00101e33 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e33:	6a 00                	push   $0x0
  pushl $1
  101e35:	6a 01                	push   $0x1
  jmp __alltraps
  101e37:	e9 60 0a 00 00       	jmp    10289c <__alltraps>

00101e3c <vector2>:
.globl vector2
vector2:
  pushl $0
  101e3c:	6a 00                	push   $0x0
  pushl $2
  101e3e:	6a 02                	push   $0x2
  jmp __alltraps
  101e40:	e9 57 0a 00 00       	jmp    10289c <__alltraps>

00101e45 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e45:	6a 00                	push   $0x0
  pushl $3
  101e47:	6a 03                	push   $0x3
  jmp __alltraps
  101e49:	e9 4e 0a 00 00       	jmp    10289c <__alltraps>

00101e4e <vector4>:
.globl vector4
vector4:
  pushl $0
  101e4e:	6a 00                	push   $0x0
  pushl $4
  101e50:	6a 04                	push   $0x4
  jmp __alltraps
  101e52:	e9 45 0a 00 00       	jmp    10289c <__alltraps>

00101e57 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e57:	6a 00                	push   $0x0
  pushl $5
  101e59:	6a 05                	push   $0x5
  jmp __alltraps
  101e5b:	e9 3c 0a 00 00       	jmp    10289c <__alltraps>

00101e60 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e60:	6a 00                	push   $0x0
  pushl $6
  101e62:	6a 06                	push   $0x6
  jmp __alltraps
  101e64:	e9 33 0a 00 00       	jmp    10289c <__alltraps>

00101e69 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e69:	6a 00                	push   $0x0
  pushl $7
  101e6b:	6a 07                	push   $0x7
  jmp __alltraps
  101e6d:	e9 2a 0a 00 00       	jmp    10289c <__alltraps>

00101e72 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e72:	6a 08                	push   $0x8
  jmp __alltraps
  101e74:	e9 23 0a 00 00       	jmp    10289c <__alltraps>

00101e79 <vector9>:
.globl vector9
vector9:
  pushl $0
  101e79:	6a 00                	push   $0x0
  pushl $9
  101e7b:	6a 09                	push   $0x9
  jmp __alltraps
  101e7d:	e9 1a 0a 00 00       	jmp    10289c <__alltraps>

00101e82 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e82:	6a 0a                	push   $0xa
  jmp __alltraps
  101e84:	e9 13 0a 00 00       	jmp    10289c <__alltraps>

00101e89 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e89:	6a 0b                	push   $0xb
  jmp __alltraps
  101e8b:	e9 0c 0a 00 00       	jmp    10289c <__alltraps>

00101e90 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e90:	6a 0c                	push   $0xc
  jmp __alltraps
  101e92:	e9 05 0a 00 00       	jmp    10289c <__alltraps>

00101e97 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e97:	6a 0d                	push   $0xd
  jmp __alltraps
  101e99:	e9 fe 09 00 00       	jmp    10289c <__alltraps>

00101e9e <vector14>:
.globl vector14
vector14:
  pushl $14
  101e9e:	6a 0e                	push   $0xe
  jmp __alltraps
  101ea0:	e9 f7 09 00 00       	jmp    10289c <__alltraps>

00101ea5 <vector15>:
.globl vector15
vector15:
  pushl $0
  101ea5:	6a 00                	push   $0x0
  pushl $15
  101ea7:	6a 0f                	push   $0xf
  jmp __alltraps
  101ea9:	e9 ee 09 00 00       	jmp    10289c <__alltraps>

00101eae <vector16>:
.globl vector16
vector16:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $16
  101eb0:	6a 10                	push   $0x10
  jmp __alltraps
  101eb2:	e9 e5 09 00 00       	jmp    10289c <__alltraps>

00101eb7 <vector17>:
.globl vector17
vector17:
  pushl $17
  101eb7:	6a 11                	push   $0x11
  jmp __alltraps
  101eb9:	e9 de 09 00 00       	jmp    10289c <__alltraps>

00101ebe <vector18>:
.globl vector18
vector18:
  pushl $0
  101ebe:	6a 00                	push   $0x0
  pushl $18
  101ec0:	6a 12                	push   $0x12
  jmp __alltraps
  101ec2:	e9 d5 09 00 00       	jmp    10289c <__alltraps>

00101ec7 <vector19>:
.globl vector19
vector19:
  pushl $0
  101ec7:	6a 00                	push   $0x0
  pushl $19
  101ec9:	6a 13                	push   $0x13
  jmp __alltraps
  101ecb:	e9 cc 09 00 00       	jmp    10289c <__alltraps>

00101ed0 <vector20>:
.globl vector20
vector20:
  pushl $0
  101ed0:	6a 00                	push   $0x0
  pushl $20
  101ed2:	6a 14                	push   $0x14
  jmp __alltraps
  101ed4:	e9 c3 09 00 00       	jmp    10289c <__alltraps>

00101ed9 <vector21>:
.globl vector21
vector21:
  pushl $0
  101ed9:	6a 00                	push   $0x0
  pushl $21
  101edb:	6a 15                	push   $0x15
  jmp __alltraps
  101edd:	e9 ba 09 00 00       	jmp    10289c <__alltraps>

00101ee2 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ee2:	6a 00                	push   $0x0
  pushl $22
  101ee4:	6a 16                	push   $0x16
  jmp __alltraps
  101ee6:	e9 b1 09 00 00       	jmp    10289c <__alltraps>

00101eeb <vector23>:
.globl vector23
vector23:
  pushl $0
  101eeb:	6a 00                	push   $0x0
  pushl $23
  101eed:	6a 17                	push   $0x17
  jmp __alltraps
  101eef:	e9 a8 09 00 00       	jmp    10289c <__alltraps>

00101ef4 <vector24>:
.globl vector24
vector24:
  pushl $0
  101ef4:	6a 00                	push   $0x0
  pushl $24
  101ef6:	6a 18                	push   $0x18
  jmp __alltraps
  101ef8:	e9 9f 09 00 00       	jmp    10289c <__alltraps>

00101efd <vector25>:
.globl vector25
vector25:
  pushl $0
  101efd:	6a 00                	push   $0x0
  pushl $25
  101eff:	6a 19                	push   $0x19
  jmp __alltraps
  101f01:	e9 96 09 00 00       	jmp    10289c <__alltraps>

00101f06 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f06:	6a 00                	push   $0x0
  pushl $26
  101f08:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f0a:	e9 8d 09 00 00       	jmp    10289c <__alltraps>

00101f0f <vector27>:
.globl vector27
vector27:
  pushl $0
  101f0f:	6a 00                	push   $0x0
  pushl $27
  101f11:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f13:	e9 84 09 00 00       	jmp    10289c <__alltraps>

00101f18 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f18:	6a 00                	push   $0x0
  pushl $28
  101f1a:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f1c:	e9 7b 09 00 00       	jmp    10289c <__alltraps>

00101f21 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f21:	6a 00                	push   $0x0
  pushl $29
  101f23:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f25:	e9 72 09 00 00       	jmp    10289c <__alltraps>

00101f2a <vector30>:
.globl vector30
vector30:
  pushl $0
  101f2a:	6a 00                	push   $0x0
  pushl $30
  101f2c:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f2e:	e9 69 09 00 00       	jmp    10289c <__alltraps>

00101f33 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f33:	6a 00                	push   $0x0
  pushl $31
  101f35:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f37:	e9 60 09 00 00       	jmp    10289c <__alltraps>

00101f3c <vector32>:
.globl vector32
vector32:
  pushl $0
  101f3c:	6a 00                	push   $0x0
  pushl $32
  101f3e:	6a 20                	push   $0x20
  jmp __alltraps
  101f40:	e9 57 09 00 00       	jmp    10289c <__alltraps>

00101f45 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f45:	6a 00                	push   $0x0
  pushl $33
  101f47:	6a 21                	push   $0x21
  jmp __alltraps
  101f49:	e9 4e 09 00 00       	jmp    10289c <__alltraps>

00101f4e <vector34>:
.globl vector34
vector34:
  pushl $0
  101f4e:	6a 00                	push   $0x0
  pushl $34
  101f50:	6a 22                	push   $0x22
  jmp __alltraps
  101f52:	e9 45 09 00 00       	jmp    10289c <__alltraps>

00101f57 <vector35>:
.globl vector35
vector35:
  pushl $0
  101f57:	6a 00                	push   $0x0
  pushl $35
  101f59:	6a 23                	push   $0x23
  jmp __alltraps
  101f5b:	e9 3c 09 00 00       	jmp    10289c <__alltraps>

00101f60 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f60:	6a 00                	push   $0x0
  pushl $36
  101f62:	6a 24                	push   $0x24
  jmp __alltraps
  101f64:	e9 33 09 00 00       	jmp    10289c <__alltraps>

00101f69 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f69:	6a 00                	push   $0x0
  pushl $37
  101f6b:	6a 25                	push   $0x25
  jmp __alltraps
  101f6d:	e9 2a 09 00 00       	jmp    10289c <__alltraps>

00101f72 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f72:	6a 00                	push   $0x0
  pushl $38
  101f74:	6a 26                	push   $0x26
  jmp __alltraps
  101f76:	e9 21 09 00 00       	jmp    10289c <__alltraps>

00101f7b <vector39>:
.globl vector39
vector39:
  pushl $0
  101f7b:	6a 00                	push   $0x0
  pushl $39
  101f7d:	6a 27                	push   $0x27
  jmp __alltraps
  101f7f:	e9 18 09 00 00       	jmp    10289c <__alltraps>

00101f84 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f84:	6a 00                	push   $0x0
  pushl $40
  101f86:	6a 28                	push   $0x28
  jmp __alltraps
  101f88:	e9 0f 09 00 00       	jmp    10289c <__alltraps>

00101f8d <vector41>:
.globl vector41
vector41:
  pushl $0
  101f8d:	6a 00                	push   $0x0
  pushl $41
  101f8f:	6a 29                	push   $0x29
  jmp __alltraps
  101f91:	e9 06 09 00 00       	jmp    10289c <__alltraps>

00101f96 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f96:	6a 00                	push   $0x0
  pushl $42
  101f98:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f9a:	e9 fd 08 00 00       	jmp    10289c <__alltraps>

00101f9f <vector43>:
.globl vector43
vector43:
  pushl $0
  101f9f:	6a 00                	push   $0x0
  pushl $43
  101fa1:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fa3:	e9 f4 08 00 00       	jmp    10289c <__alltraps>

00101fa8 <vector44>:
.globl vector44
vector44:
  pushl $0
  101fa8:	6a 00                	push   $0x0
  pushl $44
  101faa:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fac:	e9 eb 08 00 00       	jmp    10289c <__alltraps>

00101fb1 <vector45>:
.globl vector45
vector45:
  pushl $0
  101fb1:	6a 00                	push   $0x0
  pushl $45
  101fb3:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fb5:	e9 e2 08 00 00       	jmp    10289c <__alltraps>

00101fba <vector46>:
.globl vector46
vector46:
  pushl $0
  101fba:	6a 00                	push   $0x0
  pushl $46
  101fbc:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fbe:	e9 d9 08 00 00       	jmp    10289c <__alltraps>

00101fc3 <vector47>:
.globl vector47
vector47:
  pushl $0
  101fc3:	6a 00                	push   $0x0
  pushl $47
  101fc5:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fc7:	e9 d0 08 00 00       	jmp    10289c <__alltraps>

00101fcc <vector48>:
.globl vector48
vector48:
  pushl $0
  101fcc:	6a 00                	push   $0x0
  pushl $48
  101fce:	6a 30                	push   $0x30
  jmp __alltraps
  101fd0:	e9 c7 08 00 00       	jmp    10289c <__alltraps>

00101fd5 <vector49>:
.globl vector49
vector49:
  pushl $0
  101fd5:	6a 00                	push   $0x0
  pushl $49
  101fd7:	6a 31                	push   $0x31
  jmp __alltraps
  101fd9:	e9 be 08 00 00       	jmp    10289c <__alltraps>

00101fde <vector50>:
.globl vector50
vector50:
  pushl $0
  101fde:	6a 00                	push   $0x0
  pushl $50
  101fe0:	6a 32                	push   $0x32
  jmp __alltraps
  101fe2:	e9 b5 08 00 00       	jmp    10289c <__alltraps>

00101fe7 <vector51>:
.globl vector51
vector51:
  pushl $0
  101fe7:	6a 00                	push   $0x0
  pushl $51
  101fe9:	6a 33                	push   $0x33
  jmp __alltraps
  101feb:	e9 ac 08 00 00       	jmp    10289c <__alltraps>

00101ff0 <vector52>:
.globl vector52
vector52:
  pushl $0
  101ff0:	6a 00                	push   $0x0
  pushl $52
  101ff2:	6a 34                	push   $0x34
  jmp __alltraps
  101ff4:	e9 a3 08 00 00       	jmp    10289c <__alltraps>

00101ff9 <vector53>:
.globl vector53
vector53:
  pushl $0
  101ff9:	6a 00                	push   $0x0
  pushl $53
  101ffb:	6a 35                	push   $0x35
  jmp __alltraps
  101ffd:	e9 9a 08 00 00       	jmp    10289c <__alltraps>

00102002 <vector54>:
.globl vector54
vector54:
  pushl $0
  102002:	6a 00                	push   $0x0
  pushl $54
  102004:	6a 36                	push   $0x36
  jmp __alltraps
  102006:	e9 91 08 00 00       	jmp    10289c <__alltraps>

0010200b <vector55>:
.globl vector55
vector55:
  pushl $0
  10200b:	6a 00                	push   $0x0
  pushl $55
  10200d:	6a 37                	push   $0x37
  jmp __alltraps
  10200f:	e9 88 08 00 00       	jmp    10289c <__alltraps>

00102014 <vector56>:
.globl vector56
vector56:
  pushl $0
  102014:	6a 00                	push   $0x0
  pushl $56
  102016:	6a 38                	push   $0x38
  jmp __alltraps
  102018:	e9 7f 08 00 00       	jmp    10289c <__alltraps>

0010201d <vector57>:
.globl vector57
vector57:
  pushl $0
  10201d:	6a 00                	push   $0x0
  pushl $57
  10201f:	6a 39                	push   $0x39
  jmp __alltraps
  102021:	e9 76 08 00 00       	jmp    10289c <__alltraps>

00102026 <vector58>:
.globl vector58
vector58:
  pushl $0
  102026:	6a 00                	push   $0x0
  pushl $58
  102028:	6a 3a                	push   $0x3a
  jmp __alltraps
  10202a:	e9 6d 08 00 00       	jmp    10289c <__alltraps>

0010202f <vector59>:
.globl vector59
vector59:
  pushl $0
  10202f:	6a 00                	push   $0x0
  pushl $59
  102031:	6a 3b                	push   $0x3b
  jmp __alltraps
  102033:	e9 64 08 00 00       	jmp    10289c <__alltraps>

00102038 <vector60>:
.globl vector60
vector60:
  pushl $0
  102038:	6a 00                	push   $0x0
  pushl $60
  10203a:	6a 3c                	push   $0x3c
  jmp __alltraps
  10203c:	e9 5b 08 00 00       	jmp    10289c <__alltraps>

00102041 <vector61>:
.globl vector61
vector61:
  pushl $0
  102041:	6a 00                	push   $0x0
  pushl $61
  102043:	6a 3d                	push   $0x3d
  jmp __alltraps
  102045:	e9 52 08 00 00       	jmp    10289c <__alltraps>

0010204a <vector62>:
.globl vector62
vector62:
  pushl $0
  10204a:	6a 00                	push   $0x0
  pushl $62
  10204c:	6a 3e                	push   $0x3e
  jmp __alltraps
  10204e:	e9 49 08 00 00       	jmp    10289c <__alltraps>

00102053 <vector63>:
.globl vector63
vector63:
  pushl $0
  102053:	6a 00                	push   $0x0
  pushl $63
  102055:	6a 3f                	push   $0x3f
  jmp __alltraps
  102057:	e9 40 08 00 00       	jmp    10289c <__alltraps>

0010205c <vector64>:
.globl vector64
vector64:
  pushl $0
  10205c:	6a 00                	push   $0x0
  pushl $64
  10205e:	6a 40                	push   $0x40
  jmp __alltraps
  102060:	e9 37 08 00 00       	jmp    10289c <__alltraps>

00102065 <vector65>:
.globl vector65
vector65:
  pushl $0
  102065:	6a 00                	push   $0x0
  pushl $65
  102067:	6a 41                	push   $0x41
  jmp __alltraps
  102069:	e9 2e 08 00 00       	jmp    10289c <__alltraps>

0010206e <vector66>:
.globl vector66
vector66:
  pushl $0
  10206e:	6a 00                	push   $0x0
  pushl $66
  102070:	6a 42                	push   $0x42
  jmp __alltraps
  102072:	e9 25 08 00 00       	jmp    10289c <__alltraps>

00102077 <vector67>:
.globl vector67
vector67:
  pushl $0
  102077:	6a 00                	push   $0x0
  pushl $67
  102079:	6a 43                	push   $0x43
  jmp __alltraps
  10207b:	e9 1c 08 00 00       	jmp    10289c <__alltraps>

00102080 <vector68>:
.globl vector68
vector68:
  pushl $0
  102080:	6a 00                	push   $0x0
  pushl $68
  102082:	6a 44                	push   $0x44
  jmp __alltraps
  102084:	e9 13 08 00 00       	jmp    10289c <__alltraps>

00102089 <vector69>:
.globl vector69
vector69:
  pushl $0
  102089:	6a 00                	push   $0x0
  pushl $69
  10208b:	6a 45                	push   $0x45
  jmp __alltraps
  10208d:	e9 0a 08 00 00       	jmp    10289c <__alltraps>

00102092 <vector70>:
.globl vector70
vector70:
  pushl $0
  102092:	6a 00                	push   $0x0
  pushl $70
  102094:	6a 46                	push   $0x46
  jmp __alltraps
  102096:	e9 01 08 00 00       	jmp    10289c <__alltraps>

0010209b <vector71>:
.globl vector71
vector71:
  pushl $0
  10209b:	6a 00                	push   $0x0
  pushl $71
  10209d:	6a 47                	push   $0x47
  jmp __alltraps
  10209f:	e9 f8 07 00 00       	jmp    10289c <__alltraps>

001020a4 <vector72>:
.globl vector72
vector72:
  pushl $0
  1020a4:	6a 00                	push   $0x0
  pushl $72
  1020a6:	6a 48                	push   $0x48
  jmp __alltraps
  1020a8:	e9 ef 07 00 00       	jmp    10289c <__alltraps>

001020ad <vector73>:
.globl vector73
vector73:
  pushl $0
  1020ad:	6a 00                	push   $0x0
  pushl $73
  1020af:	6a 49                	push   $0x49
  jmp __alltraps
  1020b1:	e9 e6 07 00 00       	jmp    10289c <__alltraps>

001020b6 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020b6:	6a 00                	push   $0x0
  pushl $74
  1020b8:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020ba:	e9 dd 07 00 00       	jmp    10289c <__alltraps>

001020bf <vector75>:
.globl vector75
vector75:
  pushl $0
  1020bf:	6a 00                	push   $0x0
  pushl $75
  1020c1:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020c3:	e9 d4 07 00 00       	jmp    10289c <__alltraps>

001020c8 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020c8:	6a 00                	push   $0x0
  pushl $76
  1020ca:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020cc:	e9 cb 07 00 00       	jmp    10289c <__alltraps>

001020d1 <vector77>:
.globl vector77
vector77:
  pushl $0
  1020d1:	6a 00                	push   $0x0
  pushl $77
  1020d3:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020d5:	e9 c2 07 00 00       	jmp    10289c <__alltraps>

001020da <vector78>:
.globl vector78
vector78:
  pushl $0
  1020da:	6a 00                	push   $0x0
  pushl $78
  1020dc:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020de:	e9 b9 07 00 00       	jmp    10289c <__alltraps>

001020e3 <vector79>:
.globl vector79
vector79:
  pushl $0
  1020e3:	6a 00                	push   $0x0
  pushl $79
  1020e5:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020e7:	e9 b0 07 00 00       	jmp    10289c <__alltraps>

001020ec <vector80>:
.globl vector80
vector80:
  pushl $0
  1020ec:	6a 00                	push   $0x0
  pushl $80
  1020ee:	6a 50                	push   $0x50
  jmp __alltraps
  1020f0:	e9 a7 07 00 00       	jmp    10289c <__alltraps>

001020f5 <vector81>:
.globl vector81
vector81:
  pushl $0
  1020f5:	6a 00                	push   $0x0
  pushl $81
  1020f7:	6a 51                	push   $0x51
  jmp __alltraps
  1020f9:	e9 9e 07 00 00       	jmp    10289c <__alltraps>

001020fe <vector82>:
.globl vector82
vector82:
  pushl $0
  1020fe:	6a 00                	push   $0x0
  pushl $82
  102100:	6a 52                	push   $0x52
  jmp __alltraps
  102102:	e9 95 07 00 00       	jmp    10289c <__alltraps>

00102107 <vector83>:
.globl vector83
vector83:
  pushl $0
  102107:	6a 00                	push   $0x0
  pushl $83
  102109:	6a 53                	push   $0x53
  jmp __alltraps
  10210b:	e9 8c 07 00 00       	jmp    10289c <__alltraps>

00102110 <vector84>:
.globl vector84
vector84:
  pushl $0
  102110:	6a 00                	push   $0x0
  pushl $84
  102112:	6a 54                	push   $0x54
  jmp __alltraps
  102114:	e9 83 07 00 00       	jmp    10289c <__alltraps>

00102119 <vector85>:
.globl vector85
vector85:
  pushl $0
  102119:	6a 00                	push   $0x0
  pushl $85
  10211b:	6a 55                	push   $0x55
  jmp __alltraps
  10211d:	e9 7a 07 00 00       	jmp    10289c <__alltraps>

00102122 <vector86>:
.globl vector86
vector86:
  pushl $0
  102122:	6a 00                	push   $0x0
  pushl $86
  102124:	6a 56                	push   $0x56
  jmp __alltraps
  102126:	e9 71 07 00 00       	jmp    10289c <__alltraps>

0010212b <vector87>:
.globl vector87
vector87:
  pushl $0
  10212b:	6a 00                	push   $0x0
  pushl $87
  10212d:	6a 57                	push   $0x57
  jmp __alltraps
  10212f:	e9 68 07 00 00       	jmp    10289c <__alltraps>

00102134 <vector88>:
.globl vector88
vector88:
  pushl $0
  102134:	6a 00                	push   $0x0
  pushl $88
  102136:	6a 58                	push   $0x58
  jmp __alltraps
  102138:	e9 5f 07 00 00       	jmp    10289c <__alltraps>

0010213d <vector89>:
.globl vector89
vector89:
  pushl $0
  10213d:	6a 00                	push   $0x0
  pushl $89
  10213f:	6a 59                	push   $0x59
  jmp __alltraps
  102141:	e9 56 07 00 00       	jmp    10289c <__alltraps>

00102146 <vector90>:
.globl vector90
vector90:
  pushl $0
  102146:	6a 00                	push   $0x0
  pushl $90
  102148:	6a 5a                	push   $0x5a
  jmp __alltraps
  10214a:	e9 4d 07 00 00       	jmp    10289c <__alltraps>

0010214f <vector91>:
.globl vector91
vector91:
  pushl $0
  10214f:	6a 00                	push   $0x0
  pushl $91
  102151:	6a 5b                	push   $0x5b
  jmp __alltraps
  102153:	e9 44 07 00 00       	jmp    10289c <__alltraps>

00102158 <vector92>:
.globl vector92
vector92:
  pushl $0
  102158:	6a 00                	push   $0x0
  pushl $92
  10215a:	6a 5c                	push   $0x5c
  jmp __alltraps
  10215c:	e9 3b 07 00 00       	jmp    10289c <__alltraps>

00102161 <vector93>:
.globl vector93
vector93:
  pushl $0
  102161:	6a 00                	push   $0x0
  pushl $93
  102163:	6a 5d                	push   $0x5d
  jmp __alltraps
  102165:	e9 32 07 00 00       	jmp    10289c <__alltraps>

0010216a <vector94>:
.globl vector94
vector94:
  pushl $0
  10216a:	6a 00                	push   $0x0
  pushl $94
  10216c:	6a 5e                	push   $0x5e
  jmp __alltraps
  10216e:	e9 29 07 00 00       	jmp    10289c <__alltraps>

00102173 <vector95>:
.globl vector95
vector95:
  pushl $0
  102173:	6a 00                	push   $0x0
  pushl $95
  102175:	6a 5f                	push   $0x5f
  jmp __alltraps
  102177:	e9 20 07 00 00       	jmp    10289c <__alltraps>

0010217c <vector96>:
.globl vector96
vector96:
  pushl $0
  10217c:	6a 00                	push   $0x0
  pushl $96
  10217e:	6a 60                	push   $0x60
  jmp __alltraps
  102180:	e9 17 07 00 00       	jmp    10289c <__alltraps>

00102185 <vector97>:
.globl vector97
vector97:
  pushl $0
  102185:	6a 00                	push   $0x0
  pushl $97
  102187:	6a 61                	push   $0x61
  jmp __alltraps
  102189:	e9 0e 07 00 00       	jmp    10289c <__alltraps>

0010218e <vector98>:
.globl vector98
vector98:
  pushl $0
  10218e:	6a 00                	push   $0x0
  pushl $98
  102190:	6a 62                	push   $0x62
  jmp __alltraps
  102192:	e9 05 07 00 00       	jmp    10289c <__alltraps>

00102197 <vector99>:
.globl vector99
vector99:
  pushl $0
  102197:	6a 00                	push   $0x0
  pushl $99
  102199:	6a 63                	push   $0x63
  jmp __alltraps
  10219b:	e9 fc 06 00 00       	jmp    10289c <__alltraps>

001021a0 <vector100>:
.globl vector100
vector100:
  pushl $0
  1021a0:	6a 00                	push   $0x0
  pushl $100
  1021a2:	6a 64                	push   $0x64
  jmp __alltraps
  1021a4:	e9 f3 06 00 00       	jmp    10289c <__alltraps>

001021a9 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021a9:	6a 00                	push   $0x0
  pushl $101
  1021ab:	6a 65                	push   $0x65
  jmp __alltraps
  1021ad:	e9 ea 06 00 00       	jmp    10289c <__alltraps>

001021b2 <vector102>:
.globl vector102
vector102:
  pushl $0
  1021b2:	6a 00                	push   $0x0
  pushl $102
  1021b4:	6a 66                	push   $0x66
  jmp __alltraps
  1021b6:	e9 e1 06 00 00       	jmp    10289c <__alltraps>

001021bb <vector103>:
.globl vector103
vector103:
  pushl $0
  1021bb:	6a 00                	push   $0x0
  pushl $103
  1021bd:	6a 67                	push   $0x67
  jmp __alltraps
  1021bf:	e9 d8 06 00 00       	jmp    10289c <__alltraps>

001021c4 <vector104>:
.globl vector104
vector104:
  pushl $0
  1021c4:	6a 00                	push   $0x0
  pushl $104
  1021c6:	6a 68                	push   $0x68
  jmp __alltraps
  1021c8:	e9 cf 06 00 00       	jmp    10289c <__alltraps>

001021cd <vector105>:
.globl vector105
vector105:
  pushl $0
  1021cd:	6a 00                	push   $0x0
  pushl $105
  1021cf:	6a 69                	push   $0x69
  jmp __alltraps
  1021d1:	e9 c6 06 00 00       	jmp    10289c <__alltraps>

001021d6 <vector106>:
.globl vector106
vector106:
  pushl $0
  1021d6:	6a 00                	push   $0x0
  pushl $106
  1021d8:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021da:	e9 bd 06 00 00       	jmp    10289c <__alltraps>

001021df <vector107>:
.globl vector107
vector107:
  pushl $0
  1021df:	6a 00                	push   $0x0
  pushl $107
  1021e1:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021e3:	e9 b4 06 00 00       	jmp    10289c <__alltraps>

001021e8 <vector108>:
.globl vector108
vector108:
  pushl $0
  1021e8:	6a 00                	push   $0x0
  pushl $108
  1021ea:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021ec:	e9 ab 06 00 00       	jmp    10289c <__alltraps>

001021f1 <vector109>:
.globl vector109
vector109:
  pushl $0
  1021f1:	6a 00                	push   $0x0
  pushl $109
  1021f3:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021f5:	e9 a2 06 00 00       	jmp    10289c <__alltraps>

001021fa <vector110>:
.globl vector110
vector110:
  pushl $0
  1021fa:	6a 00                	push   $0x0
  pushl $110
  1021fc:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021fe:	e9 99 06 00 00       	jmp    10289c <__alltraps>

00102203 <vector111>:
.globl vector111
vector111:
  pushl $0
  102203:	6a 00                	push   $0x0
  pushl $111
  102205:	6a 6f                	push   $0x6f
  jmp __alltraps
  102207:	e9 90 06 00 00       	jmp    10289c <__alltraps>

0010220c <vector112>:
.globl vector112
vector112:
  pushl $0
  10220c:	6a 00                	push   $0x0
  pushl $112
  10220e:	6a 70                	push   $0x70
  jmp __alltraps
  102210:	e9 87 06 00 00       	jmp    10289c <__alltraps>

00102215 <vector113>:
.globl vector113
vector113:
  pushl $0
  102215:	6a 00                	push   $0x0
  pushl $113
  102217:	6a 71                	push   $0x71
  jmp __alltraps
  102219:	e9 7e 06 00 00       	jmp    10289c <__alltraps>

0010221e <vector114>:
.globl vector114
vector114:
  pushl $0
  10221e:	6a 00                	push   $0x0
  pushl $114
  102220:	6a 72                	push   $0x72
  jmp __alltraps
  102222:	e9 75 06 00 00       	jmp    10289c <__alltraps>

00102227 <vector115>:
.globl vector115
vector115:
  pushl $0
  102227:	6a 00                	push   $0x0
  pushl $115
  102229:	6a 73                	push   $0x73
  jmp __alltraps
  10222b:	e9 6c 06 00 00       	jmp    10289c <__alltraps>

00102230 <vector116>:
.globl vector116
vector116:
  pushl $0
  102230:	6a 00                	push   $0x0
  pushl $116
  102232:	6a 74                	push   $0x74
  jmp __alltraps
  102234:	e9 63 06 00 00       	jmp    10289c <__alltraps>

00102239 <vector117>:
.globl vector117
vector117:
  pushl $0
  102239:	6a 00                	push   $0x0
  pushl $117
  10223b:	6a 75                	push   $0x75
  jmp __alltraps
  10223d:	e9 5a 06 00 00       	jmp    10289c <__alltraps>

00102242 <vector118>:
.globl vector118
vector118:
  pushl $0
  102242:	6a 00                	push   $0x0
  pushl $118
  102244:	6a 76                	push   $0x76
  jmp __alltraps
  102246:	e9 51 06 00 00       	jmp    10289c <__alltraps>

0010224b <vector119>:
.globl vector119
vector119:
  pushl $0
  10224b:	6a 00                	push   $0x0
  pushl $119
  10224d:	6a 77                	push   $0x77
  jmp __alltraps
  10224f:	e9 48 06 00 00       	jmp    10289c <__alltraps>

00102254 <vector120>:
.globl vector120
vector120:
  pushl $0
  102254:	6a 00                	push   $0x0
  pushl $120
  102256:	6a 78                	push   $0x78
  jmp __alltraps
  102258:	e9 3f 06 00 00       	jmp    10289c <__alltraps>

0010225d <vector121>:
.globl vector121
vector121:
  pushl $0
  10225d:	6a 00                	push   $0x0
  pushl $121
  10225f:	6a 79                	push   $0x79
  jmp __alltraps
  102261:	e9 36 06 00 00       	jmp    10289c <__alltraps>

00102266 <vector122>:
.globl vector122
vector122:
  pushl $0
  102266:	6a 00                	push   $0x0
  pushl $122
  102268:	6a 7a                	push   $0x7a
  jmp __alltraps
  10226a:	e9 2d 06 00 00       	jmp    10289c <__alltraps>

0010226f <vector123>:
.globl vector123
vector123:
  pushl $0
  10226f:	6a 00                	push   $0x0
  pushl $123
  102271:	6a 7b                	push   $0x7b
  jmp __alltraps
  102273:	e9 24 06 00 00       	jmp    10289c <__alltraps>

00102278 <vector124>:
.globl vector124
vector124:
  pushl $0
  102278:	6a 00                	push   $0x0
  pushl $124
  10227a:	6a 7c                	push   $0x7c
  jmp __alltraps
  10227c:	e9 1b 06 00 00       	jmp    10289c <__alltraps>

00102281 <vector125>:
.globl vector125
vector125:
  pushl $0
  102281:	6a 00                	push   $0x0
  pushl $125
  102283:	6a 7d                	push   $0x7d
  jmp __alltraps
  102285:	e9 12 06 00 00       	jmp    10289c <__alltraps>

0010228a <vector126>:
.globl vector126
vector126:
  pushl $0
  10228a:	6a 00                	push   $0x0
  pushl $126
  10228c:	6a 7e                	push   $0x7e
  jmp __alltraps
  10228e:	e9 09 06 00 00       	jmp    10289c <__alltraps>

00102293 <vector127>:
.globl vector127
vector127:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $127
  102295:	6a 7f                	push   $0x7f
  jmp __alltraps
  102297:	e9 00 06 00 00       	jmp    10289c <__alltraps>

0010229c <vector128>:
.globl vector128
vector128:
  pushl $0
  10229c:	6a 00                	push   $0x0
  pushl $128
  10229e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022a3:	e9 f4 05 00 00       	jmp    10289c <__alltraps>

001022a8 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022a8:	6a 00                	push   $0x0
  pushl $129
  1022aa:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022af:	e9 e8 05 00 00       	jmp    10289c <__alltraps>

001022b4 <vector130>:
.globl vector130
vector130:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $130
  1022b6:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022bb:	e9 dc 05 00 00       	jmp    10289c <__alltraps>

001022c0 <vector131>:
.globl vector131
vector131:
  pushl $0
  1022c0:	6a 00                	push   $0x0
  pushl $131
  1022c2:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022c7:	e9 d0 05 00 00       	jmp    10289c <__alltraps>

001022cc <vector132>:
.globl vector132
vector132:
  pushl $0
  1022cc:	6a 00                	push   $0x0
  pushl $132
  1022ce:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022d3:	e9 c4 05 00 00       	jmp    10289c <__alltraps>

001022d8 <vector133>:
.globl vector133
vector133:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $133
  1022da:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022df:	e9 b8 05 00 00       	jmp    10289c <__alltraps>

001022e4 <vector134>:
.globl vector134
vector134:
  pushl $0
  1022e4:	6a 00                	push   $0x0
  pushl $134
  1022e6:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022eb:	e9 ac 05 00 00       	jmp    10289c <__alltraps>

001022f0 <vector135>:
.globl vector135
vector135:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $135
  1022f2:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022f7:	e9 a0 05 00 00       	jmp    10289c <__alltraps>

001022fc <vector136>:
.globl vector136
vector136:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $136
  1022fe:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102303:	e9 94 05 00 00       	jmp    10289c <__alltraps>

00102308 <vector137>:
.globl vector137
vector137:
  pushl $0
  102308:	6a 00                	push   $0x0
  pushl $137
  10230a:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10230f:	e9 88 05 00 00       	jmp    10289c <__alltraps>

00102314 <vector138>:
.globl vector138
vector138:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $138
  102316:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10231b:	e9 7c 05 00 00       	jmp    10289c <__alltraps>

00102320 <vector139>:
.globl vector139
vector139:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $139
  102322:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102327:	e9 70 05 00 00       	jmp    10289c <__alltraps>

0010232c <vector140>:
.globl vector140
vector140:
  pushl $0
  10232c:	6a 00                	push   $0x0
  pushl $140
  10232e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102333:	e9 64 05 00 00       	jmp    10289c <__alltraps>

00102338 <vector141>:
.globl vector141
vector141:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $141
  10233a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  10233f:	e9 58 05 00 00       	jmp    10289c <__alltraps>

00102344 <vector142>:
.globl vector142
vector142:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $142
  102346:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10234b:	e9 4c 05 00 00       	jmp    10289c <__alltraps>

00102350 <vector143>:
.globl vector143
vector143:
  pushl $0
  102350:	6a 00                	push   $0x0
  pushl $143
  102352:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102357:	e9 40 05 00 00       	jmp    10289c <__alltraps>

0010235c <vector144>:
.globl vector144
vector144:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $144
  10235e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102363:	e9 34 05 00 00       	jmp    10289c <__alltraps>

00102368 <vector145>:
.globl vector145
vector145:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $145
  10236a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10236f:	e9 28 05 00 00       	jmp    10289c <__alltraps>

00102374 <vector146>:
.globl vector146
vector146:
  pushl $0
  102374:	6a 00                	push   $0x0
  pushl $146
  102376:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10237b:	e9 1c 05 00 00       	jmp    10289c <__alltraps>

00102380 <vector147>:
.globl vector147
vector147:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $147
  102382:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102387:	e9 10 05 00 00       	jmp    10289c <__alltraps>

0010238c <vector148>:
.globl vector148
vector148:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $148
  10238e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102393:	e9 04 05 00 00       	jmp    10289c <__alltraps>

00102398 <vector149>:
.globl vector149
vector149:
  pushl $0
  102398:	6a 00                	push   $0x0
  pushl $149
  10239a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10239f:	e9 f8 04 00 00       	jmp    10289c <__alltraps>

001023a4 <vector150>:
.globl vector150
vector150:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $150
  1023a6:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023ab:	e9 ec 04 00 00       	jmp    10289c <__alltraps>

001023b0 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $151
  1023b2:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023b7:	e9 e0 04 00 00       	jmp    10289c <__alltraps>

001023bc <vector152>:
.globl vector152
vector152:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $152
  1023be:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023c3:	e9 d4 04 00 00       	jmp    10289c <__alltraps>

001023c8 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $153
  1023ca:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023cf:	e9 c8 04 00 00       	jmp    10289c <__alltraps>

001023d4 <vector154>:
.globl vector154
vector154:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $154
  1023d6:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023db:	e9 bc 04 00 00       	jmp    10289c <__alltraps>

001023e0 <vector155>:
.globl vector155
vector155:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $155
  1023e2:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023e7:	e9 b0 04 00 00       	jmp    10289c <__alltraps>

001023ec <vector156>:
.globl vector156
vector156:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $156
  1023ee:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023f3:	e9 a4 04 00 00       	jmp    10289c <__alltraps>

001023f8 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $157
  1023fa:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023ff:	e9 98 04 00 00       	jmp    10289c <__alltraps>

00102404 <vector158>:
.globl vector158
vector158:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $158
  102406:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10240b:	e9 8c 04 00 00       	jmp    10289c <__alltraps>

00102410 <vector159>:
.globl vector159
vector159:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $159
  102412:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102417:	e9 80 04 00 00       	jmp    10289c <__alltraps>

0010241c <vector160>:
.globl vector160
vector160:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $160
  10241e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102423:	e9 74 04 00 00       	jmp    10289c <__alltraps>

00102428 <vector161>:
.globl vector161
vector161:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $161
  10242a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10242f:	e9 68 04 00 00       	jmp    10289c <__alltraps>

00102434 <vector162>:
.globl vector162
vector162:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $162
  102436:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10243b:	e9 5c 04 00 00       	jmp    10289c <__alltraps>

00102440 <vector163>:
.globl vector163
vector163:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $163
  102442:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102447:	e9 50 04 00 00       	jmp    10289c <__alltraps>

0010244c <vector164>:
.globl vector164
vector164:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $164
  10244e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102453:	e9 44 04 00 00       	jmp    10289c <__alltraps>

00102458 <vector165>:
.globl vector165
vector165:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $165
  10245a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10245f:	e9 38 04 00 00       	jmp    10289c <__alltraps>

00102464 <vector166>:
.globl vector166
vector166:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $166
  102466:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10246b:	e9 2c 04 00 00       	jmp    10289c <__alltraps>

00102470 <vector167>:
.globl vector167
vector167:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $167
  102472:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102477:	e9 20 04 00 00       	jmp    10289c <__alltraps>

0010247c <vector168>:
.globl vector168
vector168:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $168
  10247e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102483:	e9 14 04 00 00       	jmp    10289c <__alltraps>

00102488 <vector169>:
.globl vector169
vector169:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $169
  10248a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10248f:	e9 08 04 00 00       	jmp    10289c <__alltraps>

00102494 <vector170>:
.globl vector170
vector170:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $170
  102496:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10249b:	e9 fc 03 00 00       	jmp    10289c <__alltraps>

001024a0 <vector171>:
.globl vector171
vector171:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $171
  1024a2:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024a7:	e9 f0 03 00 00       	jmp    10289c <__alltraps>

001024ac <vector172>:
.globl vector172
vector172:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $172
  1024ae:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024b3:	e9 e4 03 00 00       	jmp    10289c <__alltraps>

001024b8 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $173
  1024ba:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024bf:	e9 d8 03 00 00       	jmp    10289c <__alltraps>

001024c4 <vector174>:
.globl vector174
vector174:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $174
  1024c6:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024cb:	e9 cc 03 00 00       	jmp    10289c <__alltraps>

001024d0 <vector175>:
.globl vector175
vector175:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $175
  1024d2:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024d7:	e9 c0 03 00 00       	jmp    10289c <__alltraps>

001024dc <vector176>:
.globl vector176
vector176:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $176
  1024de:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024e3:	e9 b4 03 00 00       	jmp    10289c <__alltraps>

001024e8 <vector177>:
.globl vector177
vector177:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $177
  1024ea:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024ef:	e9 a8 03 00 00       	jmp    10289c <__alltraps>

001024f4 <vector178>:
.globl vector178
vector178:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $178
  1024f6:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024fb:	e9 9c 03 00 00       	jmp    10289c <__alltraps>

00102500 <vector179>:
.globl vector179
vector179:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $179
  102502:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102507:	e9 90 03 00 00       	jmp    10289c <__alltraps>

0010250c <vector180>:
.globl vector180
vector180:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $180
  10250e:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102513:	e9 84 03 00 00       	jmp    10289c <__alltraps>

00102518 <vector181>:
.globl vector181
vector181:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $181
  10251a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10251f:	e9 78 03 00 00       	jmp    10289c <__alltraps>

00102524 <vector182>:
.globl vector182
vector182:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $182
  102526:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10252b:	e9 6c 03 00 00       	jmp    10289c <__alltraps>

00102530 <vector183>:
.globl vector183
vector183:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $183
  102532:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102537:	e9 60 03 00 00       	jmp    10289c <__alltraps>

0010253c <vector184>:
.globl vector184
vector184:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $184
  10253e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102543:	e9 54 03 00 00       	jmp    10289c <__alltraps>

00102548 <vector185>:
.globl vector185
vector185:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $185
  10254a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10254f:	e9 48 03 00 00       	jmp    10289c <__alltraps>

00102554 <vector186>:
.globl vector186
vector186:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $186
  102556:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10255b:	e9 3c 03 00 00       	jmp    10289c <__alltraps>

00102560 <vector187>:
.globl vector187
vector187:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $187
  102562:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102567:	e9 30 03 00 00       	jmp    10289c <__alltraps>

0010256c <vector188>:
.globl vector188
vector188:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $188
  10256e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102573:	e9 24 03 00 00       	jmp    10289c <__alltraps>

00102578 <vector189>:
.globl vector189
vector189:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $189
  10257a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10257f:	e9 18 03 00 00       	jmp    10289c <__alltraps>

00102584 <vector190>:
.globl vector190
vector190:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $190
  102586:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10258b:	e9 0c 03 00 00       	jmp    10289c <__alltraps>

00102590 <vector191>:
.globl vector191
vector191:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $191
  102592:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102597:	e9 00 03 00 00       	jmp    10289c <__alltraps>

0010259c <vector192>:
.globl vector192
vector192:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $192
  10259e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025a3:	e9 f4 02 00 00       	jmp    10289c <__alltraps>

001025a8 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $193
  1025aa:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025af:	e9 e8 02 00 00       	jmp    10289c <__alltraps>

001025b4 <vector194>:
.globl vector194
vector194:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $194
  1025b6:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025bb:	e9 dc 02 00 00       	jmp    10289c <__alltraps>

001025c0 <vector195>:
.globl vector195
vector195:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $195
  1025c2:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025c7:	e9 d0 02 00 00       	jmp    10289c <__alltraps>

001025cc <vector196>:
.globl vector196
vector196:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $196
  1025ce:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025d3:	e9 c4 02 00 00       	jmp    10289c <__alltraps>

001025d8 <vector197>:
.globl vector197
vector197:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $197
  1025da:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025df:	e9 b8 02 00 00       	jmp    10289c <__alltraps>

001025e4 <vector198>:
.globl vector198
vector198:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $198
  1025e6:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025eb:	e9 ac 02 00 00       	jmp    10289c <__alltraps>

001025f0 <vector199>:
.globl vector199
vector199:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $199
  1025f2:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025f7:	e9 a0 02 00 00       	jmp    10289c <__alltraps>

001025fc <vector200>:
.globl vector200
vector200:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $200
  1025fe:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102603:	e9 94 02 00 00       	jmp    10289c <__alltraps>

00102608 <vector201>:
.globl vector201
vector201:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $201
  10260a:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10260f:	e9 88 02 00 00       	jmp    10289c <__alltraps>

00102614 <vector202>:
.globl vector202
vector202:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $202
  102616:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10261b:	e9 7c 02 00 00       	jmp    10289c <__alltraps>

00102620 <vector203>:
.globl vector203
vector203:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $203
  102622:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102627:	e9 70 02 00 00       	jmp    10289c <__alltraps>

0010262c <vector204>:
.globl vector204
vector204:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $204
  10262e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102633:	e9 64 02 00 00       	jmp    10289c <__alltraps>

00102638 <vector205>:
.globl vector205
vector205:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $205
  10263a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  10263f:	e9 58 02 00 00       	jmp    10289c <__alltraps>

00102644 <vector206>:
.globl vector206
vector206:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $206
  102646:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10264b:	e9 4c 02 00 00       	jmp    10289c <__alltraps>

00102650 <vector207>:
.globl vector207
vector207:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $207
  102652:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102657:	e9 40 02 00 00       	jmp    10289c <__alltraps>

0010265c <vector208>:
.globl vector208
vector208:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $208
  10265e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102663:	e9 34 02 00 00       	jmp    10289c <__alltraps>

00102668 <vector209>:
.globl vector209
vector209:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $209
  10266a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10266f:	e9 28 02 00 00       	jmp    10289c <__alltraps>

00102674 <vector210>:
.globl vector210
vector210:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $210
  102676:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10267b:	e9 1c 02 00 00       	jmp    10289c <__alltraps>

00102680 <vector211>:
.globl vector211
vector211:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $211
  102682:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102687:	e9 10 02 00 00       	jmp    10289c <__alltraps>

0010268c <vector212>:
.globl vector212
vector212:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $212
  10268e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102693:	e9 04 02 00 00       	jmp    10289c <__alltraps>

00102698 <vector213>:
.globl vector213
vector213:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $213
  10269a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10269f:	e9 f8 01 00 00       	jmp    10289c <__alltraps>

001026a4 <vector214>:
.globl vector214
vector214:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $214
  1026a6:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026ab:	e9 ec 01 00 00       	jmp    10289c <__alltraps>

001026b0 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $215
  1026b2:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026b7:	e9 e0 01 00 00       	jmp    10289c <__alltraps>

001026bc <vector216>:
.globl vector216
vector216:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $216
  1026be:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026c3:	e9 d4 01 00 00       	jmp    10289c <__alltraps>

001026c8 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $217
  1026ca:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026cf:	e9 c8 01 00 00       	jmp    10289c <__alltraps>

001026d4 <vector218>:
.globl vector218
vector218:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $218
  1026d6:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026db:	e9 bc 01 00 00       	jmp    10289c <__alltraps>

001026e0 <vector219>:
.globl vector219
vector219:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $219
  1026e2:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026e7:	e9 b0 01 00 00       	jmp    10289c <__alltraps>

001026ec <vector220>:
.globl vector220
vector220:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $220
  1026ee:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026f3:	e9 a4 01 00 00       	jmp    10289c <__alltraps>

001026f8 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026f8:	6a 00                	push   $0x0
  pushl $221
  1026fa:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026ff:	e9 98 01 00 00       	jmp    10289c <__alltraps>

00102704 <vector222>:
.globl vector222
vector222:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $222
  102706:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10270b:	e9 8c 01 00 00       	jmp    10289c <__alltraps>

00102710 <vector223>:
.globl vector223
vector223:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $223
  102712:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102717:	e9 80 01 00 00       	jmp    10289c <__alltraps>

0010271c <vector224>:
.globl vector224
vector224:
  pushl $0
  10271c:	6a 00                	push   $0x0
  pushl $224
  10271e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102723:	e9 74 01 00 00       	jmp    10289c <__alltraps>

00102728 <vector225>:
.globl vector225
vector225:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $225
  10272a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10272f:	e9 68 01 00 00       	jmp    10289c <__alltraps>

00102734 <vector226>:
.globl vector226
vector226:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $226
  102736:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10273b:	e9 5c 01 00 00       	jmp    10289c <__alltraps>

00102740 <vector227>:
.globl vector227
vector227:
  pushl $0
  102740:	6a 00                	push   $0x0
  pushl $227
  102742:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102747:	e9 50 01 00 00       	jmp    10289c <__alltraps>

0010274c <vector228>:
.globl vector228
vector228:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $228
  10274e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102753:	e9 44 01 00 00       	jmp    10289c <__alltraps>

00102758 <vector229>:
.globl vector229
vector229:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $229
  10275a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  10275f:	e9 38 01 00 00       	jmp    10289c <__alltraps>

00102764 <vector230>:
.globl vector230
vector230:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $230
  102766:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10276b:	e9 2c 01 00 00       	jmp    10289c <__alltraps>

00102770 <vector231>:
.globl vector231
vector231:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $231
  102772:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102777:	e9 20 01 00 00       	jmp    10289c <__alltraps>

0010277c <vector232>:
.globl vector232
vector232:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $232
  10277e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102783:	e9 14 01 00 00       	jmp    10289c <__alltraps>

00102788 <vector233>:
.globl vector233
vector233:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $233
  10278a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10278f:	e9 08 01 00 00       	jmp    10289c <__alltraps>

00102794 <vector234>:
.globl vector234
vector234:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $234
  102796:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10279b:	e9 fc 00 00 00       	jmp    10289c <__alltraps>

001027a0 <vector235>:
.globl vector235
vector235:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $235
  1027a2:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027a7:	e9 f0 00 00 00       	jmp    10289c <__alltraps>

001027ac <vector236>:
.globl vector236
vector236:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $236
  1027ae:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027b3:	e9 e4 00 00 00       	jmp    10289c <__alltraps>

001027b8 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $237
  1027ba:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027bf:	e9 d8 00 00 00       	jmp    10289c <__alltraps>

001027c4 <vector238>:
.globl vector238
vector238:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $238
  1027c6:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027cb:	e9 cc 00 00 00       	jmp    10289c <__alltraps>

001027d0 <vector239>:
.globl vector239
vector239:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $239
  1027d2:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027d7:	e9 c0 00 00 00       	jmp    10289c <__alltraps>

001027dc <vector240>:
.globl vector240
vector240:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $240
  1027de:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027e3:	e9 b4 00 00 00       	jmp    10289c <__alltraps>

001027e8 <vector241>:
.globl vector241
vector241:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $241
  1027ea:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027ef:	e9 a8 00 00 00       	jmp    10289c <__alltraps>

001027f4 <vector242>:
.globl vector242
vector242:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $242
  1027f6:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027fb:	e9 9c 00 00 00       	jmp    10289c <__alltraps>

00102800 <vector243>:
.globl vector243
vector243:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $243
  102802:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102807:	e9 90 00 00 00       	jmp    10289c <__alltraps>

0010280c <vector244>:
.globl vector244
vector244:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $244
  10280e:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102813:	e9 84 00 00 00       	jmp    10289c <__alltraps>

00102818 <vector245>:
.globl vector245
vector245:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $245
  10281a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10281f:	e9 78 00 00 00       	jmp    10289c <__alltraps>

00102824 <vector246>:
.globl vector246
vector246:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $246
  102826:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10282b:	e9 6c 00 00 00       	jmp    10289c <__alltraps>

00102830 <vector247>:
.globl vector247
vector247:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $247
  102832:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102837:	e9 60 00 00 00       	jmp    10289c <__alltraps>

0010283c <vector248>:
.globl vector248
vector248:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $248
  10283e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102843:	e9 54 00 00 00       	jmp    10289c <__alltraps>

00102848 <vector249>:
.globl vector249
vector249:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $249
  10284a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  10284f:	e9 48 00 00 00       	jmp    10289c <__alltraps>

00102854 <vector250>:
.globl vector250
vector250:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $250
  102856:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10285b:	e9 3c 00 00 00       	jmp    10289c <__alltraps>

00102860 <vector251>:
.globl vector251
vector251:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $251
  102862:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102867:	e9 30 00 00 00       	jmp    10289c <__alltraps>

0010286c <vector252>:
.globl vector252
vector252:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $252
  10286e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102873:	e9 24 00 00 00       	jmp    10289c <__alltraps>

00102878 <vector253>:
.globl vector253
vector253:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $253
  10287a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10287f:	e9 18 00 00 00       	jmp    10289c <__alltraps>

00102884 <vector254>:
.globl vector254
vector254:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $254
  102886:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10288b:	e9 0c 00 00 00       	jmp    10289c <__alltraps>

00102890 <vector255>:
.globl vector255
vector255:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $255
  102892:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102897:	e9 00 00 00 00       	jmp    10289c <__alltraps>

0010289c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10289c:	1e                   	push   %ds
    pushl %es
  10289d:	06                   	push   %es
    pushl %fs
  10289e:	0f a0                	push   %fs
    pushl %gs
  1028a0:	0f a8                	push   %gs
    pushal
  1028a2:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1028a3:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1028a8:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1028aa:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1028ac:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1028ad:	e8 64 f5 ff ff       	call   101e16 <trap>

    # pop the pushed stack pointer
    popl %esp
  1028b2:	5c                   	pop    %esp

001028b3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1028b3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1028b4:	0f a9                	pop    %gs
    popl %fs
  1028b6:	0f a1                	pop    %fs
    popl %es
  1028b8:	07                   	pop    %es
    popl %ds
  1028b9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1028ba:	83 c4 08             	add    $0x8,%esp
    iret
  1028bd:	cf                   	iret   

001028be <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1028be:	55                   	push   %ebp
  1028bf:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1028c4:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1028c7:	b8 23 00 00 00       	mov    $0x23,%eax
  1028cc:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1028ce:	b8 23 00 00 00       	mov    $0x23,%eax
  1028d3:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1028d5:	b8 10 00 00 00       	mov    $0x10,%eax
  1028da:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1028dc:	b8 10 00 00 00       	mov    $0x10,%eax
  1028e1:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1028e3:	b8 10 00 00 00       	mov    $0x10,%eax
  1028e8:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1028ea:	ea f1 28 10 00 08 00 	ljmp   $0x8,$0x1028f1
}
  1028f1:	90                   	nop
  1028f2:	5d                   	pop    %ebp
  1028f3:	c3                   	ret    

001028f4 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1028f4:	55                   	push   %ebp
  1028f5:	89 e5                	mov    %esp,%ebp
  1028f7:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1028fa:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  1028ff:	05 00 04 00 00       	add    $0x400,%eax
  102904:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102909:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102910:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102912:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102919:	68 00 
  10291b:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102920:	0f b7 c0             	movzwl %ax,%eax
  102923:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102929:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10292e:	c1 e8 10             	shr    $0x10,%eax
  102931:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102936:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10293d:	24 f0                	and    $0xf0,%al
  10293f:	0c 09                	or     $0x9,%al
  102941:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102946:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10294d:	0c 10                	or     $0x10,%al
  10294f:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102954:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10295b:	24 9f                	and    $0x9f,%al
  10295d:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102962:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102969:	0c 80                	or     $0x80,%al
  10296b:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102970:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102977:	24 f0                	and    $0xf0,%al
  102979:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10297e:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102985:	24 ef                	and    $0xef,%al
  102987:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10298c:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102993:	24 df                	and    $0xdf,%al
  102995:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10299a:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029a1:	0c 40                	or     $0x40,%al
  1029a3:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029a8:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029af:	24 7f                	and    $0x7f,%al
  1029b1:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029b6:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029bb:	c1 e8 18             	shr    $0x18,%eax
  1029be:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  1029c3:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ca:	24 ef                	and    $0xef,%al
  1029cc:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  1029d1:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  1029d8:	e8 e1 fe ff ff       	call   1028be <lgdt>
  1029dd:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  1029e3:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  1029e7:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  1029ea:	90                   	nop
  1029eb:	c9                   	leave  
  1029ec:	c3                   	ret    

001029ed <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  1029ed:	55                   	push   %ebp
  1029ee:	89 e5                	mov    %esp,%ebp
    gdt_init();
  1029f0:	e8 ff fe ff ff       	call   1028f4 <gdt_init>
}
  1029f5:	90                   	nop
  1029f6:	5d                   	pop    %ebp
  1029f7:	c3                   	ret    

001029f8 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1029f8:	55                   	push   %ebp
  1029f9:	89 e5                	mov    %esp,%ebp
  1029fb:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1029fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102a05:	eb 03                	jmp    102a0a <strlen+0x12>
        cnt ++;
  102a07:	ff 45 fc             	incl   -0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a0d:	8d 50 01             	lea    0x1(%eax),%edx
  102a10:	89 55 08             	mov    %edx,0x8(%ebp)
  102a13:	0f b6 00             	movzbl (%eax),%eax
  102a16:	84 c0                	test   %al,%al
  102a18:	75 ed                	jne    102a07 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102a1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102a1d:	c9                   	leave  
  102a1e:	c3                   	ret    

00102a1f <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102a1f:	55                   	push   %ebp
  102a20:	89 e5                	mov    %esp,%ebp
  102a22:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102a25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102a2c:	eb 03                	jmp    102a31 <strnlen+0x12>
        cnt ++;
  102a2e:	ff 45 fc             	incl   -0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  102a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102a34:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102a37:	73 10                	jae    102a49 <strnlen+0x2a>
  102a39:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3c:	8d 50 01             	lea    0x1(%eax),%edx
  102a3f:	89 55 08             	mov    %edx,0x8(%ebp)
  102a42:	0f b6 00             	movzbl (%eax),%eax
  102a45:	84 c0                	test   %al,%al
  102a47:	75 e5                	jne    102a2e <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  102a49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102a4c:	c9                   	leave  
  102a4d:	c3                   	ret    

00102a4e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102a4e:	55                   	push   %ebp
  102a4f:	89 e5                	mov    %esp,%ebp
  102a51:	57                   	push   %edi
  102a52:	56                   	push   %esi
  102a53:	83 ec 20             	sub    $0x20,%esp
  102a56:	8b 45 08             	mov    0x8(%ebp),%eax
  102a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102a62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a68:	89 d1                	mov    %edx,%ecx
  102a6a:	89 c2                	mov    %eax,%edx
  102a6c:	89 ce                	mov    %ecx,%esi
  102a6e:	89 d7                	mov    %edx,%edi
  102a70:	ac                   	lods   %ds:(%esi),%al
  102a71:	aa                   	stos   %al,%es:(%edi)
  102a72:	84 c0                	test   %al,%al
  102a74:	75 fa                	jne    102a70 <strcpy+0x22>
  102a76:	89 fa                	mov    %edi,%edx
  102a78:	89 f1                	mov    %esi,%ecx
  102a7a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102a7d:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102a80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102a86:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102a87:	83 c4 20             	add    $0x20,%esp
  102a8a:	5e                   	pop    %esi
  102a8b:	5f                   	pop    %edi
  102a8c:	5d                   	pop    %ebp
  102a8d:	c3                   	ret    

00102a8e <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102a8e:	55                   	push   %ebp
  102a8f:	89 e5                	mov    %esp,%ebp
  102a91:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102a94:	8b 45 08             	mov    0x8(%ebp),%eax
  102a97:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102a9a:	eb 1e                	jmp    102aba <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  102a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a9f:	0f b6 10             	movzbl (%eax),%edx
  102aa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102aa5:	88 10                	mov    %dl,(%eax)
  102aa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102aaa:	0f b6 00             	movzbl (%eax),%eax
  102aad:	84 c0                	test   %al,%al
  102aaf:	74 03                	je     102ab4 <strncpy+0x26>
            src ++;
  102ab1:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102ab4:	ff 45 fc             	incl   -0x4(%ebp)
  102ab7:	ff 4d 10             	decl   0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  102aba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102abe:	75 dc                	jne    102a9c <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  102ac0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102ac3:	c9                   	leave  
  102ac4:	c3                   	ret    

00102ac5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102ac5:	55                   	push   %ebp
  102ac6:	89 e5                	mov    %esp,%ebp
  102ac8:	57                   	push   %edi
  102ac9:	56                   	push   %esi
  102aca:	83 ec 20             	sub    $0x20,%esp
  102acd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  102ad9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102adc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102adf:	89 d1                	mov    %edx,%ecx
  102ae1:	89 c2                	mov    %eax,%edx
  102ae3:	89 ce                	mov    %ecx,%esi
  102ae5:	89 d7                	mov    %edx,%edi
  102ae7:	ac                   	lods   %ds:(%esi),%al
  102ae8:	ae                   	scas   %es:(%edi),%al
  102ae9:	75 08                	jne    102af3 <strcmp+0x2e>
  102aeb:	84 c0                	test   %al,%al
  102aed:	75 f8                	jne    102ae7 <strcmp+0x22>
  102aef:	31 c0                	xor    %eax,%eax
  102af1:	eb 04                	jmp    102af7 <strcmp+0x32>
  102af3:	19 c0                	sbb    %eax,%eax
  102af5:	0c 01                	or     $0x1,%al
  102af7:	89 fa                	mov    %edi,%edx
  102af9:	89 f1                	mov    %esi,%ecx
  102afb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102afe:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102b01:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  102b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102b07:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102b08:	83 c4 20             	add    $0x20,%esp
  102b0b:	5e                   	pop    %esi
  102b0c:	5f                   	pop    %edi
  102b0d:	5d                   	pop    %ebp
  102b0e:	c3                   	ret    

00102b0f <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102b0f:	55                   	push   %ebp
  102b10:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102b12:	eb 09                	jmp    102b1d <strncmp+0xe>
        n --, s1 ++, s2 ++;
  102b14:	ff 4d 10             	decl   0x10(%ebp)
  102b17:	ff 45 08             	incl   0x8(%ebp)
  102b1a:	ff 45 0c             	incl   0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102b1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b21:	74 1a                	je     102b3d <strncmp+0x2e>
  102b23:	8b 45 08             	mov    0x8(%ebp),%eax
  102b26:	0f b6 00             	movzbl (%eax),%eax
  102b29:	84 c0                	test   %al,%al
  102b2b:	74 10                	je     102b3d <strncmp+0x2e>
  102b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b30:	0f b6 10             	movzbl (%eax),%edx
  102b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b36:	0f b6 00             	movzbl (%eax),%eax
  102b39:	38 c2                	cmp    %al,%dl
  102b3b:	74 d7                	je     102b14 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102b3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b41:	74 18                	je     102b5b <strncmp+0x4c>
  102b43:	8b 45 08             	mov    0x8(%ebp),%eax
  102b46:	0f b6 00             	movzbl (%eax),%eax
  102b49:	0f b6 d0             	movzbl %al,%edx
  102b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b4f:	0f b6 00             	movzbl (%eax),%eax
  102b52:	0f b6 c0             	movzbl %al,%eax
  102b55:	29 c2                	sub    %eax,%edx
  102b57:	89 d0                	mov    %edx,%eax
  102b59:	eb 05                	jmp    102b60 <strncmp+0x51>
  102b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b60:	5d                   	pop    %ebp
  102b61:	c3                   	ret    

00102b62 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102b62:	55                   	push   %ebp
  102b63:	89 e5                	mov    %esp,%ebp
  102b65:	83 ec 04             	sub    $0x4,%esp
  102b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b6b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102b6e:	eb 13                	jmp    102b83 <strchr+0x21>
        if (*s == c) {
  102b70:	8b 45 08             	mov    0x8(%ebp),%eax
  102b73:	0f b6 00             	movzbl (%eax),%eax
  102b76:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102b79:	75 05                	jne    102b80 <strchr+0x1e>
            return (char *)s;
  102b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7e:	eb 12                	jmp    102b92 <strchr+0x30>
        }
        s ++;
  102b80:	ff 45 08             	incl   0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  102b83:	8b 45 08             	mov    0x8(%ebp),%eax
  102b86:	0f b6 00             	movzbl (%eax),%eax
  102b89:	84 c0                	test   %al,%al
  102b8b:	75 e3                	jne    102b70 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  102b8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b92:	c9                   	leave  
  102b93:	c3                   	ret    

00102b94 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102b94:	55                   	push   %ebp
  102b95:	89 e5                	mov    %esp,%ebp
  102b97:	83 ec 04             	sub    $0x4,%esp
  102b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b9d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102ba0:	eb 0e                	jmp    102bb0 <strfind+0x1c>
        if (*s == c) {
  102ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba5:	0f b6 00             	movzbl (%eax),%eax
  102ba8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102bab:	74 0f                	je     102bbc <strfind+0x28>
            break;
        }
        s ++;
  102bad:	ff 45 08             	incl   0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  102bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb3:	0f b6 00             	movzbl (%eax),%eax
  102bb6:	84 c0                	test   %al,%al
  102bb8:	75 e8                	jne    102ba2 <strfind+0xe>
  102bba:	eb 01                	jmp    102bbd <strfind+0x29>
        if (*s == c) {
            break;
  102bbc:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  102bbd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102bc0:	c9                   	leave  
  102bc1:	c3                   	ret    

00102bc2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102bc2:	55                   	push   %ebp
  102bc3:	89 e5                	mov    %esp,%ebp
  102bc5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102bc8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102bcf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102bd6:	eb 03                	jmp    102bdb <strtol+0x19>
        s ++;
  102bd8:	ff 45 08             	incl   0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  102bde:	0f b6 00             	movzbl (%eax),%eax
  102be1:	3c 20                	cmp    $0x20,%al
  102be3:	74 f3                	je     102bd8 <strtol+0x16>
  102be5:	8b 45 08             	mov    0x8(%ebp),%eax
  102be8:	0f b6 00             	movzbl (%eax),%eax
  102beb:	3c 09                	cmp    $0x9,%al
  102bed:	74 e9                	je     102bd8 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  102bef:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf2:	0f b6 00             	movzbl (%eax),%eax
  102bf5:	3c 2b                	cmp    $0x2b,%al
  102bf7:	75 05                	jne    102bfe <strtol+0x3c>
        s ++;
  102bf9:	ff 45 08             	incl   0x8(%ebp)
  102bfc:	eb 14                	jmp    102c12 <strtol+0x50>
    }
    else if (*s == '-') {
  102bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  102c01:	0f b6 00             	movzbl (%eax),%eax
  102c04:	3c 2d                	cmp    $0x2d,%al
  102c06:	75 0a                	jne    102c12 <strtol+0x50>
        s ++, neg = 1;
  102c08:	ff 45 08             	incl   0x8(%ebp)
  102c0b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102c12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c16:	74 06                	je     102c1e <strtol+0x5c>
  102c18:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102c1c:	75 22                	jne    102c40 <strtol+0x7e>
  102c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c21:	0f b6 00             	movzbl (%eax),%eax
  102c24:	3c 30                	cmp    $0x30,%al
  102c26:	75 18                	jne    102c40 <strtol+0x7e>
  102c28:	8b 45 08             	mov    0x8(%ebp),%eax
  102c2b:	40                   	inc    %eax
  102c2c:	0f b6 00             	movzbl (%eax),%eax
  102c2f:	3c 78                	cmp    $0x78,%al
  102c31:	75 0d                	jne    102c40 <strtol+0x7e>
        s += 2, base = 16;
  102c33:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102c37:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102c3e:	eb 29                	jmp    102c69 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  102c40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c44:	75 16                	jne    102c5c <strtol+0x9a>
  102c46:	8b 45 08             	mov    0x8(%ebp),%eax
  102c49:	0f b6 00             	movzbl (%eax),%eax
  102c4c:	3c 30                	cmp    $0x30,%al
  102c4e:	75 0c                	jne    102c5c <strtol+0x9a>
        s ++, base = 8;
  102c50:	ff 45 08             	incl   0x8(%ebp)
  102c53:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102c5a:	eb 0d                	jmp    102c69 <strtol+0xa7>
    }
    else if (base == 0) {
  102c5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c60:	75 07                	jne    102c69 <strtol+0xa7>
        base = 10;
  102c62:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102c69:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6c:	0f b6 00             	movzbl (%eax),%eax
  102c6f:	3c 2f                	cmp    $0x2f,%al
  102c71:	7e 1b                	jle    102c8e <strtol+0xcc>
  102c73:	8b 45 08             	mov    0x8(%ebp),%eax
  102c76:	0f b6 00             	movzbl (%eax),%eax
  102c79:	3c 39                	cmp    $0x39,%al
  102c7b:	7f 11                	jg     102c8e <strtol+0xcc>
            dig = *s - '0';
  102c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c80:	0f b6 00             	movzbl (%eax),%eax
  102c83:	0f be c0             	movsbl %al,%eax
  102c86:	83 e8 30             	sub    $0x30,%eax
  102c89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c8c:	eb 48                	jmp    102cd6 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c91:	0f b6 00             	movzbl (%eax),%eax
  102c94:	3c 60                	cmp    $0x60,%al
  102c96:	7e 1b                	jle    102cb3 <strtol+0xf1>
  102c98:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9b:	0f b6 00             	movzbl (%eax),%eax
  102c9e:	3c 7a                	cmp    $0x7a,%al
  102ca0:	7f 11                	jg     102cb3 <strtol+0xf1>
            dig = *s - 'a' + 10;
  102ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca5:	0f b6 00             	movzbl (%eax),%eax
  102ca8:	0f be c0             	movsbl %al,%eax
  102cab:	83 e8 57             	sub    $0x57,%eax
  102cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cb1:	eb 23                	jmp    102cd6 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb6:	0f b6 00             	movzbl (%eax),%eax
  102cb9:	3c 40                	cmp    $0x40,%al
  102cbb:	7e 3b                	jle    102cf8 <strtol+0x136>
  102cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc0:	0f b6 00             	movzbl (%eax),%eax
  102cc3:	3c 5a                	cmp    $0x5a,%al
  102cc5:	7f 31                	jg     102cf8 <strtol+0x136>
            dig = *s - 'A' + 10;
  102cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  102cca:	0f b6 00             	movzbl (%eax),%eax
  102ccd:	0f be c0             	movsbl %al,%eax
  102cd0:	83 e8 37             	sub    $0x37,%eax
  102cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cd9:	3b 45 10             	cmp    0x10(%ebp),%eax
  102cdc:	7d 19                	jge    102cf7 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  102cde:	ff 45 08             	incl   0x8(%ebp)
  102ce1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ce4:	0f af 45 10          	imul   0x10(%ebp),%eax
  102ce8:	89 c2                	mov    %eax,%edx
  102cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ced:	01 d0                	add    %edx,%eax
  102cef:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102cf2:	e9 72 ff ff ff       	jmp    102c69 <strtol+0xa7>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  102cf7:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  102cf8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102cfc:	74 08                	je     102d06 <strtol+0x144>
        *endptr = (char *) s;
  102cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d01:	8b 55 08             	mov    0x8(%ebp),%edx
  102d04:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102d06:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102d0a:	74 07                	je     102d13 <strtol+0x151>
  102d0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d0f:	f7 d8                	neg    %eax
  102d11:	eb 03                	jmp    102d16 <strtol+0x154>
  102d13:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102d16:	c9                   	leave  
  102d17:	c3                   	ret    

00102d18 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102d18:	55                   	push   %ebp
  102d19:	89 e5                	mov    %esp,%ebp
  102d1b:	57                   	push   %edi
  102d1c:	83 ec 24             	sub    $0x24,%esp
  102d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d22:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102d25:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102d29:	8b 55 08             	mov    0x8(%ebp),%edx
  102d2c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102d2f:	88 45 f7             	mov    %al,-0x9(%ebp)
  102d32:	8b 45 10             	mov    0x10(%ebp),%eax
  102d35:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102d38:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102d3b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102d3f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102d42:	89 d7                	mov    %edx,%edi
  102d44:	f3 aa                	rep stos %al,%es:(%edi)
  102d46:	89 fa                	mov    %edi,%edx
  102d48:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102d4b:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102d4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d51:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102d52:	83 c4 24             	add    $0x24,%esp
  102d55:	5f                   	pop    %edi
  102d56:	5d                   	pop    %ebp
  102d57:	c3                   	ret    

00102d58 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102d58:	55                   	push   %ebp
  102d59:	89 e5                	mov    %esp,%ebp
  102d5b:	57                   	push   %edi
  102d5c:	56                   	push   %esi
  102d5d:	53                   	push   %ebx
  102d5e:	83 ec 30             	sub    $0x30,%esp
  102d61:	8b 45 08             	mov    0x8(%ebp),%eax
  102d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d6d:	8b 45 10             	mov    0x10(%ebp),%eax
  102d70:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d76:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102d79:	73 42                	jae    102dbd <memmove+0x65>
  102d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d8a:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102d8d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d90:	c1 e8 02             	shr    $0x2,%eax
  102d93:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102d95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d98:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d9b:	89 d7                	mov    %edx,%edi
  102d9d:	89 c6                	mov    %eax,%esi
  102d9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102da1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102da4:	83 e1 03             	and    $0x3,%ecx
  102da7:	74 02                	je     102dab <memmove+0x53>
  102da9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102dab:	89 f0                	mov    %esi,%eax
  102dad:	89 fa                	mov    %edi,%edx
  102daf:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102db2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102db5:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102dbb:	eb 36                	jmp    102df3 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dc0:	8d 50 ff             	lea    -0x1(%eax),%edx
  102dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102dc6:	01 c2                	add    %eax,%edx
  102dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dcb:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dd1:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  102dd4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dd7:	89 c1                	mov    %eax,%ecx
  102dd9:	89 d8                	mov    %ebx,%eax
  102ddb:	89 d6                	mov    %edx,%esi
  102ddd:	89 c7                	mov    %eax,%edi
  102ddf:	fd                   	std    
  102de0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102de2:	fc                   	cld    
  102de3:	89 f8                	mov    %edi,%eax
  102de5:	89 f2                	mov    %esi,%edx
  102de7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102dea:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102ded:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  102df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102df3:	83 c4 30             	add    $0x30,%esp
  102df6:	5b                   	pop    %ebx
  102df7:	5e                   	pop    %esi
  102df8:	5f                   	pop    %edi
  102df9:	5d                   	pop    %ebp
  102dfa:	c3                   	ret    

00102dfb <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102dfb:	55                   	push   %ebp
  102dfc:	89 e5                	mov    %esp,%ebp
  102dfe:	57                   	push   %edi
  102dff:	56                   	push   %esi
  102e00:	83 ec 20             	sub    $0x20,%esp
  102e03:	8b 45 08             	mov    0x8(%ebp),%eax
  102e06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  102e12:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e18:	c1 e8 02             	shr    $0x2,%eax
  102e1b:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  102e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e23:	89 d7                	mov    %edx,%edi
  102e25:	89 c6                	mov    %eax,%esi
  102e27:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e29:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102e2c:	83 e1 03             	and    $0x3,%ecx
  102e2f:	74 02                	je     102e33 <memcpy+0x38>
  102e31:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e33:	89 f0                	mov    %esi,%eax
  102e35:	89 fa                	mov    %edi,%edx
  102e37:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102e3a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102e3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  102e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102e43:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102e44:	83 c4 20             	add    $0x20,%esp
  102e47:	5e                   	pop    %esi
  102e48:	5f                   	pop    %edi
  102e49:	5d                   	pop    %ebp
  102e4a:	c3                   	ret    

00102e4b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102e4b:	55                   	push   %ebp
  102e4c:	89 e5                	mov    %esp,%ebp
  102e4e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102e51:	8b 45 08             	mov    0x8(%ebp),%eax
  102e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102e5d:	eb 2e                	jmp    102e8d <memcmp+0x42>
        if (*s1 != *s2) {
  102e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e62:	0f b6 10             	movzbl (%eax),%edx
  102e65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e68:	0f b6 00             	movzbl (%eax),%eax
  102e6b:	38 c2                	cmp    %al,%dl
  102e6d:	74 18                	je     102e87 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102e6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102e72:	0f b6 00             	movzbl (%eax),%eax
  102e75:	0f b6 d0             	movzbl %al,%edx
  102e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e7b:	0f b6 00             	movzbl (%eax),%eax
  102e7e:	0f b6 c0             	movzbl %al,%eax
  102e81:	29 c2                	sub    %eax,%edx
  102e83:	89 d0                	mov    %edx,%eax
  102e85:	eb 18                	jmp    102e9f <memcmp+0x54>
        }
        s1 ++, s2 ++;
  102e87:	ff 45 fc             	incl   -0x4(%ebp)
  102e8a:	ff 45 f8             	incl   -0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  102e8d:	8b 45 10             	mov    0x10(%ebp),%eax
  102e90:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e93:	89 55 10             	mov    %edx,0x10(%ebp)
  102e96:	85 c0                	test   %eax,%eax
  102e98:	75 c5                	jne    102e5f <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  102e9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102e9f:	c9                   	leave  
  102ea0:	c3                   	ret    

00102ea1 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102ea1:	55                   	push   %ebp
  102ea2:	89 e5                	mov    %esp,%ebp
  102ea4:	83 ec 58             	sub    $0x58,%esp
  102ea7:	8b 45 10             	mov    0x10(%ebp),%eax
  102eaa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ead:	8b 45 14             	mov    0x14(%ebp),%eax
  102eb0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102eb3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102eb6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102eb9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ebc:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102ebf:	8b 45 18             	mov    0x18(%ebp),%eax
  102ec2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ec5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ec8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ecb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ece:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102ed1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ed7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102edb:	74 1c                	je     102ef9 <printnum+0x58>
  102edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee0:	ba 00 00 00 00       	mov    $0x0,%edx
  102ee5:	f7 75 e4             	divl   -0x1c(%ebp)
  102ee8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eee:	ba 00 00 00 00       	mov    $0x0,%edx
  102ef3:	f7 75 e4             	divl   -0x1c(%ebp)
  102ef6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ef9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102efc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102eff:	f7 75 e4             	divl   -0x1c(%ebp)
  102f02:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f05:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102f08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f0b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f11:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102f14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f17:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102f1a:	8b 45 18             	mov    0x18(%ebp),%eax
  102f1d:	ba 00 00 00 00       	mov    $0x0,%edx
  102f22:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f25:	77 56                	ja     102f7d <printnum+0xdc>
  102f27:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102f2a:	72 05                	jb     102f31 <printnum+0x90>
  102f2c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102f2f:	77 4c                	ja     102f7d <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102f31:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102f34:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f37:	8b 45 20             	mov    0x20(%ebp),%eax
  102f3a:	89 44 24 18          	mov    %eax,0x18(%esp)
  102f3e:	89 54 24 14          	mov    %edx,0x14(%esp)
  102f42:	8b 45 18             	mov    0x18(%ebp),%eax
  102f45:	89 44 24 10          	mov    %eax,0x10(%esp)
  102f49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f4c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f4f:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f53:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f61:	89 04 24             	mov    %eax,(%esp)
  102f64:	e8 38 ff ff ff       	call   102ea1 <printnum>
  102f69:	eb 1b                	jmp    102f86 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f72:	8b 45 20             	mov    0x20(%ebp),%eax
  102f75:	89 04 24             	mov    %eax,(%esp)
  102f78:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7b:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102f7d:	ff 4d 1c             	decl   0x1c(%ebp)
  102f80:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102f84:	7f e5                	jg     102f6b <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102f86:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102f89:	05 f0 3c 10 00       	add    $0x103cf0,%eax
  102f8e:	0f b6 00             	movzbl (%eax),%eax
  102f91:	0f be c0             	movsbl %al,%eax
  102f94:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f97:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f9b:	89 04 24             	mov    %eax,(%esp)
  102f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102fa1:	ff d0                	call   *%eax
}
  102fa3:	90                   	nop
  102fa4:	c9                   	leave  
  102fa5:	c3                   	ret    

00102fa6 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102fa6:	55                   	push   %ebp
  102fa7:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102fa9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102fad:	7e 14                	jle    102fc3 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102faf:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb2:	8b 00                	mov    (%eax),%eax
  102fb4:	8d 48 08             	lea    0x8(%eax),%ecx
  102fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  102fba:	89 0a                	mov    %ecx,(%edx)
  102fbc:	8b 50 04             	mov    0x4(%eax),%edx
  102fbf:	8b 00                	mov    (%eax),%eax
  102fc1:	eb 30                	jmp    102ff3 <getuint+0x4d>
    }
    else if (lflag) {
  102fc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102fc7:	74 16                	je     102fdf <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  102fcc:	8b 00                	mov    (%eax),%eax
  102fce:	8d 48 04             	lea    0x4(%eax),%ecx
  102fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  102fd4:	89 0a                	mov    %ecx,(%edx)
  102fd6:	8b 00                	mov    (%eax),%eax
  102fd8:	ba 00 00 00 00       	mov    $0x0,%edx
  102fdd:	eb 14                	jmp    102ff3 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe2:	8b 00                	mov    (%eax),%eax
  102fe4:	8d 48 04             	lea    0x4(%eax),%ecx
  102fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  102fea:	89 0a                	mov    %ecx,(%edx)
  102fec:	8b 00                	mov    (%eax),%eax
  102fee:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102ff3:	5d                   	pop    %ebp
  102ff4:	c3                   	ret    

00102ff5 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102ff5:	55                   	push   %ebp
  102ff6:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102ff8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102ffc:	7e 14                	jle    103012 <getint+0x1d>
        return va_arg(*ap, long long);
  102ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  103001:	8b 00                	mov    (%eax),%eax
  103003:	8d 48 08             	lea    0x8(%eax),%ecx
  103006:	8b 55 08             	mov    0x8(%ebp),%edx
  103009:	89 0a                	mov    %ecx,(%edx)
  10300b:	8b 50 04             	mov    0x4(%eax),%edx
  10300e:	8b 00                	mov    (%eax),%eax
  103010:	eb 28                	jmp    10303a <getint+0x45>
    }
    else if (lflag) {
  103012:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103016:	74 12                	je     10302a <getint+0x35>
        return va_arg(*ap, long);
  103018:	8b 45 08             	mov    0x8(%ebp),%eax
  10301b:	8b 00                	mov    (%eax),%eax
  10301d:	8d 48 04             	lea    0x4(%eax),%ecx
  103020:	8b 55 08             	mov    0x8(%ebp),%edx
  103023:	89 0a                	mov    %ecx,(%edx)
  103025:	8b 00                	mov    (%eax),%eax
  103027:	99                   	cltd   
  103028:	eb 10                	jmp    10303a <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10302a:	8b 45 08             	mov    0x8(%ebp),%eax
  10302d:	8b 00                	mov    (%eax),%eax
  10302f:	8d 48 04             	lea    0x4(%eax),%ecx
  103032:	8b 55 08             	mov    0x8(%ebp),%edx
  103035:	89 0a                	mov    %ecx,(%edx)
  103037:	8b 00                	mov    (%eax),%eax
  103039:	99                   	cltd   
    }
}
  10303a:	5d                   	pop    %ebp
  10303b:	c3                   	ret    

0010303c <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10303c:	55                   	push   %ebp
  10303d:	89 e5                	mov    %esp,%ebp
  10303f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  103042:	8d 45 14             	lea    0x14(%ebp),%eax
  103045:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10304b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10304f:	8b 45 10             	mov    0x10(%ebp),%eax
  103052:	89 44 24 08          	mov    %eax,0x8(%esp)
  103056:	8b 45 0c             	mov    0xc(%ebp),%eax
  103059:	89 44 24 04          	mov    %eax,0x4(%esp)
  10305d:	8b 45 08             	mov    0x8(%ebp),%eax
  103060:	89 04 24             	mov    %eax,(%esp)
  103063:	e8 03 00 00 00       	call   10306b <vprintfmt>
    va_end(ap);
}
  103068:	90                   	nop
  103069:	c9                   	leave  
  10306a:	c3                   	ret    

0010306b <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10306b:	55                   	push   %ebp
  10306c:	89 e5                	mov    %esp,%ebp
  10306e:	56                   	push   %esi
  10306f:	53                   	push   %ebx
  103070:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103073:	eb 17                	jmp    10308c <vprintfmt+0x21>
            if (ch == '\0') {
  103075:	85 db                	test   %ebx,%ebx
  103077:	0f 84 bf 03 00 00    	je     10343c <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  10307d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103080:	89 44 24 04          	mov    %eax,0x4(%esp)
  103084:	89 1c 24             	mov    %ebx,(%esp)
  103087:	8b 45 08             	mov    0x8(%ebp),%eax
  10308a:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10308c:	8b 45 10             	mov    0x10(%ebp),%eax
  10308f:	8d 50 01             	lea    0x1(%eax),%edx
  103092:	89 55 10             	mov    %edx,0x10(%ebp)
  103095:	0f b6 00             	movzbl (%eax),%eax
  103098:	0f b6 d8             	movzbl %al,%ebx
  10309b:	83 fb 25             	cmp    $0x25,%ebx
  10309e:	75 d5                	jne    103075 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1030a0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1030a4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1030ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1030ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1030b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1030b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1030bb:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1030be:	8b 45 10             	mov    0x10(%ebp),%eax
  1030c1:	8d 50 01             	lea    0x1(%eax),%edx
  1030c4:	89 55 10             	mov    %edx,0x10(%ebp)
  1030c7:	0f b6 00             	movzbl (%eax),%eax
  1030ca:	0f b6 d8             	movzbl %al,%ebx
  1030cd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1030d0:	83 f8 55             	cmp    $0x55,%eax
  1030d3:	0f 87 37 03 00 00    	ja     103410 <vprintfmt+0x3a5>
  1030d9:	8b 04 85 14 3d 10 00 	mov    0x103d14(,%eax,4),%eax
  1030e0:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1030e2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1030e6:	eb d6                	jmp    1030be <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1030e8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1030ec:	eb d0                	jmp    1030be <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1030ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1030f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1030f8:	89 d0                	mov    %edx,%eax
  1030fa:	c1 e0 02             	shl    $0x2,%eax
  1030fd:	01 d0                	add    %edx,%eax
  1030ff:	01 c0                	add    %eax,%eax
  103101:	01 d8                	add    %ebx,%eax
  103103:	83 e8 30             	sub    $0x30,%eax
  103106:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103109:	8b 45 10             	mov    0x10(%ebp),%eax
  10310c:	0f b6 00             	movzbl (%eax),%eax
  10310f:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103112:	83 fb 2f             	cmp    $0x2f,%ebx
  103115:	7e 38                	jle    10314f <vprintfmt+0xe4>
  103117:	83 fb 39             	cmp    $0x39,%ebx
  10311a:	7f 33                	jg     10314f <vprintfmt+0xe4>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10311c:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  10311f:	eb d4                	jmp    1030f5 <vprintfmt+0x8a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103121:	8b 45 14             	mov    0x14(%ebp),%eax
  103124:	8d 50 04             	lea    0x4(%eax),%edx
  103127:	89 55 14             	mov    %edx,0x14(%ebp)
  10312a:	8b 00                	mov    (%eax),%eax
  10312c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10312f:	eb 1f                	jmp    103150 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  103131:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103135:	79 87                	jns    1030be <vprintfmt+0x53>
                width = 0;
  103137:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10313e:	e9 7b ff ff ff       	jmp    1030be <vprintfmt+0x53>

        case '#':
            altflag = 1;
  103143:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10314a:	e9 6f ff ff ff       	jmp    1030be <vprintfmt+0x53>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  10314f:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  103150:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103154:	0f 89 64 ff ff ff    	jns    1030be <vprintfmt+0x53>
                width = precision, precision = -1;
  10315a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10315d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103160:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103167:	e9 52 ff ff ff       	jmp    1030be <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10316c:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  10316f:	e9 4a ff ff ff       	jmp    1030be <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103174:	8b 45 14             	mov    0x14(%ebp),%eax
  103177:	8d 50 04             	lea    0x4(%eax),%edx
  10317a:	89 55 14             	mov    %edx,0x14(%ebp)
  10317d:	8b 00                	mov    (%eax),%eax
  10317f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103182:	89 54 24 04          	mov    %edx,0x4(%esp)
  103186:	89 04 24             	mov    %eax,(%esp)
  103189:	8b 45 08             	mov    0x8(%ebp),%eax
  10318c:	ff d0                	call   *%eax
            break;
  10318e:	e9 a4 02 00 00       	jmp    103437 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103193:	8b 45 14             	mov    0x14(%ebp),%eax
  103196:	8d 50 04             	lea    0x4(%eax),%edx
  103199:	89 55 14             	mov    %edx,0x14(%ebp)
  10319c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10319e:	85 db                	test   %ebx,%ebx
  1031a0:	79 02                	jns    1031a4 <vprintfmt+0x139>
                err = -err;
  1031a2:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1031a4:	83 fb 06             	cmp    $0x6,%ebx
  1031a7:	7f 0b                	jg     1031b4 <vprintfmt+0x149>
  1031a9:	8b 34 9d d4 3c 10 00 	mov    0x103cd4(,%ebx,4),%esi
  1031b0:	85 f6                	test   %esi,%esi
  1031b2:	75 23                	jne    1031d7 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  1031b4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1031b8:	c7 44 24 08 01 3d 10 	movl   $0x103d01,0x8(%esp)
  1031bf:	00 
  1031c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ca:	89 04 24             	mov    %eax,(%esp)
  1031cd:	e8 6a fe ff ff       	call   10303c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1031d2:	e9 60 02 00 00       	jmp    103437 <vprintfmt+0x3cc>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1031d7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1031db:	c7 44 24 08 0a 3d 10 	movl   $0x103d0a,0x8(%esp)
  1031e2:	00 
  1031e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ed:	89 04 24             	mov    %eax,(%esp)
  1031f0:	e8 47 fe ff ff       	call   10303c <printfmt>
            }
            break;
  1031f5:	e9 3d 02 00 00       	jmp    103437 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1031fa:	8b 45 14             	mov    0x14(%ebp),%eax
  1031fd:	8d 50 04             	lea    0x4(%eax),%edx
  103200:	89 55 14             	mov    %edx,0x14(%ebp)
  103203:	8b 30                	mov    (%eax),%esi
  103205:	85 f6                	test   %esi,%esi
  103207:	75 05                	jne    10320e <vprintfmt+0x1a3>
                p = "(null)";
  103209:	be 0d 3d 10 00       	mov    $0x103d0d,%esi
            }
            if (width > 0 && padc != '-') {
  10320e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103212:	7e 76                	jle    10328a <vprintfmt+0x21f>
  103214:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103218:	74 70                	je     10328a <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10321a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10321d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103221:	89 34 24             	mov    %esi,(%esp)
  103224:	e8 f6 f7 ff ff       	call   102a1f <strnlen>
  103229:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10322c:	29 c2                	sub    %eax,%edx
  10322e:	89 d0                	mov    %edx,%eax
  103230:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103233:	eb 16                	jmp    10324b <vprintfmt+0x1e0>
                    putch(padc, putdat);
  103235:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103239:	8b 55 0c             	mov    0xc(%ebp),%edx
  10323c:	89 54 24 04          	mov    %edx,0x4(%esp)
  103240:	89 04 24             	mov    %eax,(%esp)
  103243:	8b 45 08             	mov    0x8(%ebp),%eax
  103246:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  103248:	ff 4d e8             	decl   -0x18(%ebp)
  10324b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10324f:	7f e4                	jg     103235 <vprintfmt+0x1ca>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103251:	eb 37                	jmp    10328a <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  103253:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103257:	74 1f                	je     103278 <vprintfmt+0x20d>
  103259:	83 fb 1f             	cmp    $0x1f,%ebx
  10325c:	7e 05                	jle    103263 <vprintfmt+0x1f8>
  10325e:	83 fb 7e             	cmp    $0x7e,%ebx
  103261:	7e 15                	jle    103278 <vprintfmt+0x20d>
                    putch('?', putdat);
  103263:	8b 45 0c             	mov    0xc(%ebp),%eax
  103266:	89 44 24 04          	mov    %eax,0x4(%esp)
  10326a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103271:	8b 45 08             	mov    0x8(%ebp),%eax
  103274:	ff d0                	call   *%eax
  103276:	eb 0f                	jmp    103287 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  103278:	8b 45 0c             	mov    0xc(%ebp),%eax
  10327b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10327f:	89 1c 24             	mov    %ebx,(%esp)
  103282:	8b 45 08             	mov    0x8(%ebp),%eax
  103285:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103287:	ff 4d e8             	decl   -0x18(%ebp)
  10328a:	89 f0                	mov    %esi,%eax
  10328c:	8d 70 01             	lea    0x1(%eax),%esi
  10328f:	0f b6 00             	movzbl (%eax),%eax
  103292:	0f be d8             	movsbl %al,%ebx
  103295:	85 db                	test   %ebx,%ebx
  103297:	74 27                	je     1032c0 <vprintfmt+0x255>
  103299:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10329d:	78 b4                	js     103253 <vprintfmt+0x1e8>
  10329f:	ff 4d e4             	decl   -0x1c(%ebp)
  1032a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1032a6:	79 ab                	jns    103253 <vprintfmt+0x1e8>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1032a8:	eb 16                	jmp    1032c0 <vprintfmt+0x255>
                putch(' ', putdat);
  1032aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032b1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1032bb:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1032bd:	ff 4d e8             	decl   -0x18(%ebp)
  1032c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032c4:	7f e4                	jg     1032aa <vprintfmt+0x23f>
                putch(' ', putdat);
            }
            break;
  1032c6:	e9 6c 01 00 00       	jmp    103437 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1032cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032d2:	8d 45 14             	lea    0x14(%ebp),%eax
  1032d5:	89 04 24             	mov    %eax,(%esp)
  1032d8:	e8 18 fd ff ff       	call   102ff5 <getint>
  1032dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1032e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1032e9:	85 d2                	test   %edx,%edx
  1032eb:	79 26                	jns    103313 <vprintfmt+0x2a8>
                putch('-', putdat);
  1032ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032f4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1032fe:	ff d0                	call   *%eax
                num = -(long long)num;
  103300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103303:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103306:	f7 d8                	neg    %eax
  103308:	83 d2 00             	adc    $0x0,%edx
  10330b:	f7 da                	neg    %edx
  10330d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103310:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  103313:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10331a:	e9 a8 00 00 00       	jmp    1033c7 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10331f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103322:	89 44 24 04          	mov    %eax,0x4(%esp)
  103326:	8d 45 14             	lea    0x14(%ebp),%eax
  103329:	89 04 24             	mov    %eax,(%esp)
  10332c:	e8 75 fc ff ff       	call   102fa6 <getuint>
  103331:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103334:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103337:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10333e:	e9 84 00 00 00       	jmp    1033c7 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103343:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103346:	89 44 24 04          	mov    %eax,0x4(%esp)
  10334a:	8d 45 14             	lea    0x14(%ebp),%eax
  10334d:	89 04 24             	mov    %eax,(%esp)
  103350:	e8 51 fc ff ff       	call   102fa6 <getuint>
  103355:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103358:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10335b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103362:	eb 63                	jmp    1033c7 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  103364:	8b 45 0c             	mov    0xc(%ebp),%eax
  103367:	89 44 24 04          	mov    %eax,0x4(%esp)
  10336b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103372:	8b 45 08             	mov    0x8(%ebp),%eax
  103375:	ff d0                	call   *%eax
            putch('x', putdat);
  103377:	8b 45 0c             	mov    0xc(%ebp),%eax
  10337a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10337e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103385:	8b 45 08             	mov    0x8(%ebp),%eax
  103388:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10338a:	8b 45 14             	mov    0x14(%ebp),%eax
  10338d:	8d 50 04             	lea    0x4(%eax),%edx
  103390:	89 55 14             	mov    %edx,0x14(%ebp)
  103393:	8b 00                	mov    (%eax),%eax
  103395:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103398:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10339f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1033a6:	eb 1f                	jmp    1033c7 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1033a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033af:	8d 45 14             	lea    0x14(%ebp),%eax
  1033b2:	89 04 24             	mov    %eax,(%esp)
  1033b5:	e8 ec fb ff ff       	call   102fa6 <getuint>
  1033ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1033c0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1033c7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1033cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ce:	89 54 24 18          	mov    %edx,0x18(%esp)
  1033d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1033d5:	89 54 24 14          	mov    %edx,0x14(%esp)
  1033d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  1033dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1033e7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1033eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f5:	89 04 24             	mov    %eax,(%esp)
  1033f8:	e8 a4 fa ff ff       	call   102ea1 <printnum>
            break;
  1033fd:	eb 38                	jmp    103437 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1033ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  103402:	89 44 24 04          	mov    %eax,0x4(%esp)
  103406:	89 1c 24             	mov    %ebx,(%esp)
  103409:	8b 45 08             	mov    0x8(%ebp),%eax
  10340c:	ff d0                	call   *%eax
            break;
  10340e:	eb 27                	jmp    103437 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103410:	8b 45 0c             	mov    0xc(%ebp),%eax
  103413:	89 44 24 04          	mov    %eax,0x4(%esp)
  103417:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10341e:	8b 45 08             	mov    0x8(%ebp),%eax
  103421:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103423:	ff 4d 10             	decl   0x10(%ebp)
  103426:	eb 03                	jmp    10342b <vprintfmt+0x3c0>
  103428:	ff 4d 10             	decl   0x10(%ebp)
  10342b:	8b 45 10             	mov    0x10(%ebp),%eax
  10342e:	48                   	dec    %eax
  10342f:	0f b6 00             	movzbl (%eax),%eax
  103432:	3c 25                	cmp    $0x25,%al
  103434:	75 f2                	jne    103428 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  103436:	90                   	nop
        }
    }
  103437:	e9 37 fc ff ff       	jmp    103073 <vprintfmt+0x8>
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
            if (ch == '\0') {
                return;
  10343c:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10343d:	83 c4 40             	add    $0x40,%esp
  103440:	5b                   	pop    %ebx
  103441:	5e                   	pop    %esi
  103442:	5d                   	pop    %ebp
  103443:	c3                   	ret    

00103444 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103444:	55                   	push   %ebp
  103445:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103447:	8b 45 0c             	mov    0xc(%ebp),%eax
  10344a:	8b 40 08             	mov    0x8(%eax),%eax
  10344d:	8d 50 01             	lea    0x1(%eax),%edx
  103450:	8b 45 0c             	mov    0xc(%ebp),%eax
  103453:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103456:	8b 45 0c             	mov    0xc(%ebp),%eax
  103459:	8b 10                	mov    (%eax),%edx
  10345b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10345e:	8b 40 04             	mov    0x4(%eax),%eax
  103461:	39 c2                	cmp    %eax,%edx
  103463:	73 12                	jae    103477 <sprintputch+0x33>
        *b->buf ++ = ch;
  103465:	8b 45 0c             	mov    0xc(%ebp),%eax
  103468:	8b 00                	mov    (%eax),%eax
  10346a:	8d 48 01             	lea    0x1(%eax),%ecx
  10346d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103470:	89 0a                	mov    %ecx,(%edx)
  103472:	8b 55 08             	mov    0x8(%ebp),%edx
  103475:	88 10                	mov    %dl,(%eax)
    }
}
  103477:	90                   	nop
  103478:	5d                   	pop    %ebp
  103479:	c3                   	ret    

0010347a <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10347a:	55                   	push   %ebp
  10347b:	89 e5                	mov    %esp,%ebp
  10347d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103480:	8d 45 14             	lea    0x14(%ebp),%eax
  103483:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103489:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10348d:	8b 45 10             	mov    0x10(%ebp),%eax
  103490:	89 44 24 08          	mov    %eax,0x8(%esp)
  103494:	8b 45 0c             	mov    0xc(%ebp),%eax
  103497:	89 44 24 04          	mov    %eax,0x4(%esp)
  10349b:	8b 45 08             	mov    0x8(%ebp),%eax
  10349e:	89 04 24             	mov    %eax,(%esp)
  1034a1:	e8 08 00 00 00       	call   1034ae <vsnprintf>
  1034a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1034a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1034ac:	c9                   	leave  
  1034ad:	c3                   	ret    

001034ae <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1034ae:	55                   	push   %ebp
  1034af:	89 e5                	mov    %esp,%ebp
  1034b1:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1034c3:	01 d0                	add    %edx,%eax
  1034c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1034cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1034d3:	74 0a                	je     1034df <vsnprintf+0x31>
  1034d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1034d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034db:	39 c2                	cmp    %eax,%edx
  1034dd:	76 07                	jbe    1034e6 <vsnprintf+0x38>
        return -E_INVAL;
  1034df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1034e4:	eb 2a                	jmp    103510 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1034e6:	8b 45 14             	mov    0x14(%ebp),%eax
  1034e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1034f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1034f4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1034f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034fb:	c7 04 24 44 34 10 00 	movl   $0x103444,(%esp)
  103502:	e8 64 fb ff ff       	call   10306b <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103507:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10350a:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10350d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103510:	c9                   	leave  
  103511:	c3                   	ret    
