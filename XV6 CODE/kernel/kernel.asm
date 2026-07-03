
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	b2010113          	addi	sp,sp,-1248 # 80009b20 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	04e000ef          	jal	80000064 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000024:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000028:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002c:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80000030:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000034:	577d                	li	a4,-1
    80000036:	177e                	slli	a4,a4,0x3f
    80000038:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000003a:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003e:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000042:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000046:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    8000004a:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004e:	000f4737          	lui	a4,0xf4
    80000052:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000056:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000058:	14d79073          	csrw	stimecmp,a5
}
    8000005c:	60a2                	ld	ra,8(sp)
    8000005e:	6402                	ld	s0,0(sp)
    80000060:	0141                	addi	sp,sp,16
    80000062:	8082                	ret

0000000080000064 <start>:
{
    80000064:	1141                	addi	sp,sp,-16
    80000066:	e406                	sd	ra,8(sp)
    80000068:	e022                	sd	s0,0(sp)
    8000006a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000070:	7779                	lui	a4,0xffffe
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdd7467>
    80000076:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000078:	6705                	lui	a4,0x1
    8000007a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000084:	00001797          	auipc	a5,0x1
    80000088:	30478793          	addi	a5,a5,772 # 80001388 <main>
    8000008c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80000090:	4781                	li	a5,0
    80000092:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000096:	67c1                	lui	a5,0x10
    80000098:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000009a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000a2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a6:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000aa:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000ae:	57fd                	li	a5,-1
    800000b0:	83a9                	srli	a5,a5,0xa
    800000b2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b6:	47bd                	li	a5,15
    800000b8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000bc:	f61ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000c0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c8:	30200073          	mret
}
    800000cc:	60a2                	ld	ra,8(sp)
    800000ce:	6402                	ld	s0,0(sp)
    800000d0:	0141                	addi	sp,sp,16
    800000d2:	8082                	ret

00000000800000d4 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d4:	7119                	addi	sp,sp,-128
    800000d6:	fc86                	sd	ra,120(sp)
    800000d8:	f8a2                	sd	s0,112(sp)
    800000da:	f4a6                	sd	s1,104(sp)
    800000dc:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while(i < n){
    800000de:	06c05b63          	blez	a2,80000154 <consolewrite+0x80>
    800000e2:	f0ca                	sd	s2,96(sp)
    800000e4:	ecce                	sd	s3,88(sp)
    800000e6:	e8d2                	sd	s4,80(sp)
    800000e8:	e4d6                	sd	s5,72(sp)
    800000ea:	e0da                	sd	s6,64(sp)
    800000ec:	fc5e                	sd	s7,56(sp)
    800000ee:	f862                	sd	s8,48(sp)
    800000f0:	f466                	sd	s9,40(sp)
    800000f2:	f06a                	sd	s10,32(sp)
    800000f4:	8b2a                	mv	s6,a0
    800000f6:	8bae                	mv	s7,a1
    800000f8:	8a32                	mv	s4,a2
  int i = 0;
    800000fa:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800000fc:	02000c93          	li	s9,32
    80000100:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000104:	f8040a93          	addi	s5,s0,-128
    80000108:	5c7d                	li	s8,-1
    8000010a:	a025                	j	80000132 <consolewrite+0x5e>
    if(nn > n - i)
    8000010c:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000110:	86ce                	mv	a3,s3
    80000112:	01748633          	add	a2,s1,s7
    80000116:	85da                	mv	a1,s6
    80000118:	8556                	mv	a0,s5
    8000011a:	313020ef          	jal	80002c2c <either_copyin>
    8000011e:	03850d63          	beq	a0,s8,80000158 <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000122:	85ce                	mv	a1,s3
    80000124:	8556                	mv	a0,s5
    80000126:	7b4000ef          	jal	800008da <uartwrite>
    i += nn;
    8000012a:	009904bb          	addw	s1,s2,s1
  while(i < n){
    8000012e:	0144d963          	bge	s1,s4,80000140 <consolewrite+0x6c>
    if(nn > n - i)
    80000132:	409a07bb          	subw	a5,s4,s1
    80000136:	893e                	mv	s2,a5
    80000138:	fcfcdae3          	bge	s9,a5,8000010c <consolewrite+0x38>
    8000013c:	896a                	mv	s2,s10
    8000013e:	b7f9                	j	8000010c <consolewrite+0x38>
    80000140:	7906                	ld	s2,96(sp)
    80000142:	69e6                	ld	s3,88(sp)
    80000144:	6a46                	ld	s4,80(sp)
    80000146:	6aa6                	ld	s5,72(sp)
    80000148:	6b06                	ld	s6,64(sp)
    8000014a:	7be2                	ld	s7,56(sp)
    8000014c:	7c42                	ld	s8,48(sp)
    8000014e:	7ca2                	ld	s9,40(sp)
    80000150:	7d02                	ld	s10,32(sp)
    80000152:	a821                	j	8000016a <consolewrite+0x96>
  int i = 0;
    80000154:	4481                	li	s1,0
    80000156:	a811                	j	8000016a <consolewrite+0x96>
    80000158:	7906                	ld	s2,96(sp)
    8000015a:	69e6                	ld	s3,88(sp)
    8000015c:	6a46                	ld	s4,80(sp)
    8000015e:	6aa6                	ld	s5,72(sp)
    80000160:	6b06                	ld	s6,64(sp)
    80000162:	7be2                	ld	s7,56(sp)
    80000164:	7c42                	ld	s8,48(sp)
    80000166:	7ca2                	ld	s9,40(sp)
    80000168:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016a:	8526                	mv	a0,s1
    8000016c:	70e6                	ld	ra,120(sp)
    8000016e:	7446                	ld	s0,112(sp)
    80000170:	74a6                	ld	s1,104(sp)
    80000172:	6109                	addi	sp,sp,128
    80000174:	8082                	ret

0000000080000176 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000176:	711d                	addi	sp,sp,-96
    80000178:	ec86                	sd	ra,88(sp)
    8000017a:	e8a2                	sd	s0,80(sp)
    8000017c:	e4a6                	sd	s1,72(sp)
    8000017e:	e0ca                	sd	s2,64(sp)
    80000180:	fc4e                	sd	s3,56(sp)
    80000182:	f852                	sd	s4,48(sp)
    80000184:	f05a                	sd	s6,32(sp)
    80000186:	ec5e                	sd	s7,24(sp)
    80000188:	1080                	addi	s0,sp,96
    8000018a:	8b2a                	mv	s6,a0
    8000018c:	8a2e                	mv	s4,a1
    8000018e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000190:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000192:	00012517          	auipc	a0,0x12
    80000196:	98e50513          	addi	a0,a0,-1650 # 80011b20 <cons>
    8000019a:	769000ef          	jal	80001102 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	00012497          	auipc	s1,0x12
    800001a2:	98248493          	addi	s1,s1,-1662 # 80011b20 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	00012917          	auipc	s2,0x12
    800001aa:	a1290913          	addi	s2,s2,-1518 # 80011bb8 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	6ad010ef          	jal	8000206a <myproc>
    800001c2:	103020ef          	jal	80002ac4 <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	6bc020ef          	jal	80002888 <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00012717          	auipc	a4,0x12
    800001e2:	94270713          	addi	a4,a4,-1726 # 80011b20 <cons>
    800001e6:	0017869b          	addiw	a3,a5,1
    800001ea:	08d72c23          	sw	a3,152(a4)
    800001ee:	07f7f693          	andi	a3,a5,127
    800001f2:	9736                	add	a4,a4,a3
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    800001fc:	4691                	li	a3,4
    800001fe:	04da8663          	beq	s5,a3,8000024a <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000202:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000206:	4685                	li	a3,1
    80000208:	faf40613          	addi	a2,s0,-81
    8000020c:	85d2                	mv	a1,s4
    8000020e:	855a                	mv	a0,s6
    80000210:	1d3020ef          	jal	80002be2 <either_copyout>
    80000214:	57fd                	li	a5,-1
    80000216:	04f50663          	beq	a0,a5,80000262 <consoleread+0xec>
      break;

    dst++;
    8000021a:	0a05                	addi	s4,s4,1
    --n;
    8000021c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000021e:	47a9                	li	a5,10
    80000220:	04fa8b63          	beq	s5,a5,80000276 <consoleread+0x100>
    80000224:	7aa2                	ld	s5,40(sp)
    80000226:	b761                	j	800001ae <consoleread+0x38>
        release(&cons.lock);
    80000228:	00012517          	auipc	a0,0x12
    8000022c:	8f850513          	addi	a0,a0,-1800 # 80011b20 <cons>
    80000230:	767000ef          	jal	80001196 <release>
        return -1;
    80000234:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000236:	60e6                	ld	ra,88(sp)
    80000238:	6446                	ld	s0,80(sp)
    8000023a:	64a6                	ld	s1,72(sp)
    8000023c:	6906                	ld	s2,64(sp)
    8000023e:	79e2                	ld	s3,56(sp)
    80000240:	7a42                	ld	s4,48(sp)
    80000242:	7b02                	ld	s6,32(sp)
    80000244:	6be2                	ld	s7,24(sp)
    80000246:	6125                	addi	sp,sp,96
    80000248:	8082                	ret
      if(n < target){
    8000024a:	0179fa63          	bgeu	s3,s7,8000025e <consoleread+0xe8>
        cons.r--;
    8000024e:	00012717          	auipc	a4,0x12
    80000252:	96f72523          	sw	a5,-1686(a4) # 80011bb8 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	00012517          	auipc	a0,0x12
    80000268:	8bc50513          	addi	a0,a0,-1860 # 80011b20 <cons>
    8000026c:	72b000ef          	jal	80001196 <release>
  return target - n;
    80000270:	413b853b          	subw	a0,s7,s3
    80000274:	b7c9                	j	80000236 <consoleread+0xc0>
    80000276:	7aa2                	ld	s5,40(sp)
    80000278:	b7f5                	j	80000264 <consoleread+0xee>

000000008000027a <consputc>:
{
    8000027a:	1141                	addi	sp,sp,-16
    8000027c:	e406                	sd	ra,8(sp)
    8000027e:	e022                	sd	s0,0(sp)
    80000280:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000282:	10000793          	li	a5,256
    80000286:	00f50863          	beq	a0,a5,80000296 <consputc+0x1c>
    uartputc_sync(c);
    8000028a:	6e4000ef          	jal	8000096e <uartputc_sync>
}
    8000028e:	60a2                	ld	ra,8(sp)
    80000290:	6402                	ld	s0,0(sp)
    80000292:	0141                	addi	sp,sp,16
    80000294:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000296:	4521                	li	a0,8
    80000298:	6d6000ef          	jal	8000096e <uartputc_sync>
    8000029c:	02000513          	li	a0,32
    800002a0:	6ce000ef          	jal	8000096e <uartputc_sync>
    800002a4:	4521                	li	a0,8
    800002a6:	6c8000ef          	jal	8000096e <uartputc_sync>
    800002aa:	b7d5                	j	8000028e <consputc+0x14>

00000000800002ac <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ac:	1101                	addi	sp,sp,-32
    800002ae:	ec06                	sd	ra,24(sp)
    800002b0:	e822                	sd	s0,16(sp)
    800002b2:	e426                	sd	s1,8(sp)
    800002b4:	1000                	addi	s0,sp,32
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	00012517          	auipc	a0,0x12
    800002bc:	86850513          	addi	a0,a0,-1944 # 80011b20 <cons>
    800002c0:	643000ef          	jal	80001102 <acquire>

  switch(c){
    800002c4:	47d5                	li	a5,21
    800002c6:	08f48d63          	beq	s1,a5,80000360 <consoleintr+0xb4>
    800002ca:	0297c563          	blt	a5,s1,800002f4 <consoleintr+0x48>
    800002ce:	47a1                	li	a5,8
    800002d0:	0ef48263          	beq	s1,a5,800003b4 <consoleintr+0x108>
    800002d4:	47c1                	li	a5,16
    800002d6:	10f49363          	bne	s1,a5,800003dc <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    800002da:	19d020ef          	jal	80002c76 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002de:	00012517          	auipc	a0,0x12
    800002e2:	84250513          	addi	a0,a0,-1982 # 80011b20 <cons>
    800002e6:	6b1000ef          	jal	80001196 <release>
}
    800002ea:	60e2                	ld	ra,24(sp)
    800002ec:	6442                	ld	s0,16(sp)
    800002ee:	64a2                	ld	s1,8(sp)
    800002f0:	6105                	addi	sp,sp,32
    800002f2:	8082                	ret
  switch(c){
    800002f4:	07f00793          	li	a5,127
    800002f8:	0af48e63          	beq	s1,a5,800003b4 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002fc:	00012717          	auipc	a4,0x12
    80000300:	82470713          	addi	a4,a4,-2012 # 80011b20 <cons>
    80000304:	0a072783          	lw	a5,160(a4)
    80000308:	09872703          	lw	a4,152(a4)
    8000030c:	9f99                	subw	a5,a5,a4
    8000030e:	07f00713          	li	a4,127
    80000312:	fcf766e3          	bltu	a4,a5,800002de <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000316:	47b5                	li	a5,13
    80000318:	0cf48563          	beq	s1,a5,800003e2 <consoleintr+0x136>
      consputc(c);
    8000031c:	8526                	mv	a0,s1
    8000031e:	f5dff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000322:	00011717          	auipc	a4,0x11
    80000326:	7fe70713          	addi	a4,a4,2046 # 80011b20 <cons>
    8000032a:	0a072683          	lw	a3,160(a4)
    8000032e:	0016879b          	addiw	a5,a3,1
    80000332:	863e                	mv	a2,a5
    80000334:	0af72023          	sw	a5,160(a4)
    80000338:	07f6f693          	andi	a3,a3,127
    8000033c:	9736                	add	a4,a4,a3
    8000033e:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000342:	ff648713          	addi	a4,s1,-10
    80000346:	c371                	beqz	a4,8000040a <consoleintr+0x15e>
    80000348:	14f1                	addi	s1,s1,-4
    8000034a:	c0e1                	beqz	s1,8000040a <consoleintr+0x15e>
    8000034c:	00012717          	auipc	a4,0x12
    80000350:	86c72703          	lw	a4,-1940(a4) # 80011bb8 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	00011717          	auipc	a4,0x11
    80000366:	7be70713          	addi	a4,a4,1982 # 80011b20 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	00011497          	auipc	s1,0x11
    80000376:	7ae48493          	addi	s1,s1,1966 # 80011b20 <cons>
    while(cons.e != cons.w &&
    8000037a:	4929                	li	s2,10
    8000037c:	02f70863          	beq	a4,a5,800003ac <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000380:	37fd                	addiw	a5,a5,-1
    80000382:	07f7f713          	andi	a4,a5,127
    80000386:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000388:	01874703          	lbu	a4,24(a4)
    8000038c:	03270263          	beq	a4,s2,800003b0 <consoleintr+0x104>
      cons.e--;
    80000390:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000394:	10000513          	li	a0,256
    80000398:	ee3ff0ef          	jal	8000027a <consputc>
    while(cons.e != cons.w &&
    8000039c:	0a04a783          	lw	a5,160(s1)
    800003a0:	09c4a703          	lw	a4,156(s1)
    800003a4:	fcf71ee3          	bne	a4,a5,80000380 <consoleintr+0xd4>
    800003a8:	6902                	ld	s2,0(sp)
    800003aa:	bf15                	j	800002de <consoleintr+0x32>
    800003ac:	6902                	ld	s2,0(sp)
    800003ae:	bf05                	j	800002de <consoleintr+0x32>
    800003b0:	6902                	ld	s2,0(sp)
    800003b2:	b735                	j	800002de <consoleintr+0x32>
    if(cons.e != cons.w){
    800003b4:	00011717          	auipc	a4,0x11
    800003b8:	76c70713          	addi	a4,a4,1900 # 80011b20 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	00011717          	auipc	a4,0x11
    800003ce:	7ef72b23          	sw	a5,2038(a4) # 80011bc0 <cons+0xa0>
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	ea5ff0ef          	jal	8000027a <consputc>
    800003da:	b711                	j	800002de <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003dc:	f00481e3          	beqz	s1,800002de <consoleintr+0x32>
    800003e0:	bf31                	j	800002fc <consoleintr+0x50>
      consputc(c);
    800003e2:	4529                	li	a0,10
    800003e4:	e97ff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003e8:	00011797          	auipc	a5,0x11
    800003ec:	73878793          	addi	a5,a5,1848 # 80011b20 <cons>
    800003f0:	0a07a703          	lw	a4,160(a5)
    800003f4:	0017069b          	addiw	a3,a4,1
    800003f8:	8636                	mv	a2,a3
    800003fa:	0ad7a023          	sw	a3,160(a5)
    800003fe:	07f77713          	andi	a4,a4,127
    80000402:	97ba                	add	a5,a5,a4
    80000404:	4729                	li	a4,10
    80000406:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000040a:	00011797          	auipc	a5,0x11
    8000040e:	7ac7a923          	sw	a2,1970(a5) # 80011bbc <cons+0x9c>
        wakeup(&cons.r);
    80000412:	00011517          	auipc	a0,0x11
    80000416:	7a650513          	addi	a0,a0,1958 # 80011bb8 <cons+0x98>
    8000041a:	4ba020ef          	jal	800028d4 <wakeup>
    8000041e:	b5c1                	j	800002de <consoleintr+0x32>

0000000080000420 <consoleinit>:

void
consoleinit(void)
{
    80000420:	1141                	addi	sp,sp,-16
    80000422:	e406                	sd	ra,8(sp)
    80000424:	e022                	sd	s0,0(sp)
    80000426:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000428:	00009597          	auipc	a1,0x9
    8000042c:	bd858593          	addi	a1,a1,-1064 # 80009000 <etext>
    80000430:	00011517          	auipc	a0,0x11
    80000434:	6f050513          	addi	a0,a0,1776 # 80011b20 <cons>
    80000438:	441000ef          	jal	80001078 <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	00024797          	auipc	a5,0x24
    80000444:	58078793          	addi	a5,a5,1408 # 800249c0 <devsw>
    80000448:	00000717          	auipc	a4,0x0
    8000044c:	d2e70713          	addi	a4,a4,-722 # 80000176 <consoleread>
    80000450:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000452:	00000717          	auipc	a4,0x0
    80000456:	c8270713          	addi	a4,a4,-894 # 800000d4 <consolewrite>
    8000045a:	ef98                	sd	a4,24(a5)
}
    8000045c:	60a2                	ld	ra,8(sp)
    8000045e:	6402                	ld	s0,0(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f04a                	sd	s2,32(sp)
    8000046c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000046e:	c219                	beqz	a2,80000474 <printint+0x10>
    80000470:	08054163          	bltz	a0,800004f2 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80000474:	4301                	li	t1,0

  i = 0;
    80000476:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000047a:	86ca                	mv	a3,s2
  i = 0;
    8000047c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000047e:	00009817          	auipc	a6,0x9
    80000482:	4c280813          	addi	a6,a6,1218 # 80009940 <digits>
    80000486:	88ba                	mv	a7,a4
    80000488:	0017061b          	addiw	a2,a4,1
    8000048c:	8732                	mv	a4,a2
    8000048e:	02b577b3          	remu	a5,a0,a1
    80000492:	97c2                	add	a5,a5,a6
    80000494:	0007c783          	lbu	a5,0(a5)
    80000498:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000049c:	87aa                	mv	a5,a0
    8000049e:	02b55533          	divu	a0,a0,a1
    800004a2:	0685                	addi	a3,a3,1
    800004a4:	feb7f1e3          	bgeu	a5,a1,80000486 <printint+0x22>

  if(sign)
    800004a8:	00030c63          	beqz	t1,800004c0 <printint+0x5c>
    buf[i++] = '-';
    800004ac:	fe060793          	addi	a5,a2,-32
    800004b0:	00878633          	add	a2,a5,s0
    800004b4:	02d00793          	li	a5,45
    800004b8:	fef60423          	sb	a5,-24(a2)
    800004bc:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    800004c0:	02e05463          	blez	a4,800004e8 <printint+0x84>
    800004c4:	f426                	sd	s1,40(sp)
    800004c6:	377d                	addiw	a4,a4,-1
    800004c8:	00e904b3          	add	s1,s2,a4
    800004cc:	197d                	addi	s2,s2,-1
    800004ce:	993a                	add	s2,s2,a4
    800004d0:	1702                	slli	a4,a4,0x20
    800004d2:	9301                	srli	a4,a4,0x20
    800004d4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004d8:	0004c503          	lbu	a0,0(s1)
    800004dc:	d9fff0ef          	jal	8000027a <consputc>
  while(--i >= 0)
    800004e0:	14fd                	addi	s1,s1,-1
    800004e2:	ff249be3          	bne	s1,s2,800004d8 <printint+0x74>
    800004e6:	74a2                	ld	s1,40(sp)
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	7902                	ld	s2,32(sp)
    800004ee:	6121                	addi	sp,sp,64
    800004f0:	8082                	ret
    x = -xx;
    800004f2:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004f6:	4305                	li	t1,1
    x = -xx;
    800004f8:	bfbd                	j	80000476 <printint+0x12>

00000000800004fa <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004fa:	7131                	addi	sp,sp,-192
    800004fc:	fc86                	sd	ra,120(sp)
    800004fe:	f8a2                	sd	s0,112(sp)
    80000500:	f0ca                	sd	s2,96(sp)
    80000502:	0100                	addi	s0,sp,128
    80000504:	892a                	mv	s2,a0
    80000506:	e40c                	sd	a1,8(s0)
    80000508:	e810                	sd	a2,16(s0)
    8000050a:	ec14                	sd	a3,24(s0)
    8000050c:	f018                	sd	a4,32(s0)
    8000050e:	f41c                	sd	a5,40(s0)
    80000510:	03043823          	sd	a6,48(s0)
    80000514:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80000518:	00009797          	auipc	a5,0x9
    8000051c:	5ac7a783          	lw	a5,1452(a5) # 80009ac4 <panicking>
    80000520:	cf9d                	beqz	a5,8000055e <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	00094503          	lbu	a0,0(s2)
    8000052e:	22050663          	beqz	a0,8000075a <printf+0x260>
    80000532:	f4a6                	sd	s1,104(sp)
    80000534:	ecce                	sd	s3,88(sp)
    80000536:	e8d2                	sd	s4,80(sp)
    80000538:	e4d6                	sd	s5,72(sp)
    8000053a:	e0da                	sd	s6,64(sp)
    8000053c:	fc5e                	sd	s7,56(sp)
    8000053e:	f862                	sd	s8,48(sp)
    80000540:	f06a                	sd	s10,32(sp)
    80000542:	ec6e                	sd	s11,24(sp)
    80000544:	4a01                	li	s4,0
    if(cx != '%'){
    80000546:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000054a:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000054e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000552:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80000556:	4b29                	li	s6,10
    if(c0 == 'd'){
    80000558:	06400b93          	li	s7,100
    8000055c:	a015                	j	80000580 <printf+0x86>
    acquire(&pr.lock);
    8000055e:	00011517          	auipc	a0,0x11
    80000562:	66a50513          	addi	a0,a0,1642 # 80011bc8 <pr>
    80000566:	39d000ef          	jal	80001102 <acquire>
    8000056a:	bf65                	j	80000522 <printf+0x28>
      consputc(cx);
    8000056c:	d0fff0ef          	jal	8000027a <consputc>
      continue;
    80000570:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000572:	2485                	addiw	s1,s1,1
    80000574:	8a26                	mv	s4,s1
    80000576:	94ca                	add	s1,s1,s2
    80000578:	0004c503          	lbu	a0,0(s1)
    8000057c:	1c050663          	beqz	a0,80000748 <printf+0x24e>
    if(cx != '%'){
    80000580:	ff3516e3          	bne	a0,s3,8000056c <printf+0x72>
    i++;
    80000584:	001a079b          	addiw	a5,s4,1
    80000588:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000058a:	00f90733          	add	a4,s2,a5
    8000058e:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000592:	200a8963          	beqz	s5,800007a4 <printf+0x2aa>
    80000596:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    8000059a:	1e068c63          	beqz	a3,80000792 <printf+0x298>
    if(c0 == 'd'){
    8000059e:	037a8863          	beq	s5,s7,800005ce <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800005a2:	f94a8713          	addi	a4,s5,-108
    800005a6:	00173713          	seqz	a4,a4
    800005aa:	f9c68613          	addi	a2,a3,-100
    800005ae:	ee05                	bnez	a2,800005e6 <printf+0xec>
    800005b0:	cb1d                	beqz	a4,800005e6 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800005b2:	f8843783          	ld	a5,-120(s0)
    800005b6:	00878713          	addi	a4,a5,8
    800005ba:	f8e43423          	sd	a4,-120(s0)
    800005be:	4605                	li	a2,1
    800005c0:	85da                	mv	a1,s6
    800005c2:	6388                	ld	a0,0(a5)
    800005c4:	ea1ff0ef          	jal	80000464 <printint>
      i += 1;
    800005c8:	002a049b          	addiw	s1,s4,2
    800005cc:	b75d                	j	80000572 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    800005ce:	f8843783          	ld	a5,-120(s0)
    800005d2:	00878713          	addi	a4,a5,8
    800005d6:	f8e43423          	sd	a4,-120(s0)
    800005da:	4605                	li	a2,1
    800005dc:	85da                	mv	a1,s6
    800005de:	4388                	lw	a0,0(a5)
    800005e0:	e85ff0ef          	jal	80000464 <printint>
    800005e4:	b779                	j	80000572 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    800005e6:	97ca                	add	a5,a5,s2
    800005e8:	8636                	mv	a2,a3
    800005ea:	0027c683          	lbu	a3,2(a5)
    800005ee:	a2c9                	j	800007b0 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    800005f0:	f8843783          	ld	a5,-120(s0)
    800005f4:	00878713          	addi	a4,a5,8
    800005f8:	f8e43423          	sd	a4,-120(s0)
    800005fc:	4605                	li	a2,1
    800005fe:	45a9                	li	a1,10
    80000600:	6388                	ld	a0,0(a5)
    80000602:	e63ff0ef          	jal	80000464 <printint>
      i += 2;
    80000606:	003a049b          	addiw	s1,s4,3
    8000060a:	b7a5                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000060c:	f8843783          	ld	a5,-120(s0)
    80000610:	00878713          	addi	a4,a5,8
    80000614:	f8e43423          	sd	a4,-120(s0)
    80000618:	4601                	li	a2,0
    8000061a:	85da                	mv	a1,s6
    8000061c:	0007e503          	lwu	a0,0(a5)
    80000620:	e45ff0ef          	jal	80000464 <printint>
    80000624:	b7b9                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000626:	f8843783          	ld	a5,-120(s0)
    8000062a:	00878713          	addi	a4,a5,8
    8000062e:	f8e43423          	sd	a4,-120(s0)
    80000632:	4601                	li	a2,0
    80000634:	85da                	mv	a1,s6
    80000636:	6388                	ld	a0,0(a5)
    80000638:	e2dff0ef          	jal	80000464 <printint>
      i += 1;
    8000063c:	002a049b          	addiw	s1,s4,2
    80000640:	bf0d                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000642:	f8843783          	ld	a5,-120(s0)
    80000646:	00878713          	addi	a4,a5,8
    8000064a:	f8e43423          	sd	a4,-120(s0)
    8000064e:	4601                	li	a2,0
    80000650:	45a9                	li	a1,10
    80000652:	6388                	ld	a0,0(a5)
    80000654:	e11ff0ef          	jal	80000464 <printint>
      i += 2;
    80000658:	003a049b          	addiw	s1,s4,3
    8000065c:	bf19                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    8000065e:	f8843783          	ld	a5,-120(s0)
    80000662:	00878713          	addi	a4,a5,8
    80000666:	f8e43423          	sd	a4,-120(s0)
    8000066a:	4601                	li	a2,0
    8000066c:	45c1                	li	a1,16
    8000066e:	0007e503          	lwu	a0,0(a5)
    80000672:	df3ff0ef          	jal	80000464 <printint>
    80000676:	bdf5                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	45c1                	li	a1,16
    80000686:	6388                	ld	a0,0(a5)
    80000688:	dddff0ef          	jal	80000464 <printint>
      i += 1;
    8000068c:	002a049b          	addiw	s1,s4,2
    80000690:	b5cd                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000692:	f8843783          	ld	a5,-120(s0)
    80000696:	00878713          	addi	a4,a5,8
    8000069a:	f8e43423          	sd	a4,-120(s0)
    8000069e:	4601                	li	a2,0
    800006a0:	45c1                	li	a1,16
    800006a2:	6388                	ld	a0,0(a5)
    800006a4:	dc1ff0ef          	jal	80000464 <printint>
      i += 2;
    800006a8:	003a049b          	addiw	s1,s4,3
    800006ac:	b5d9                	j	80000572 <printf+0x78>
    800006ae:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006c0:	03000513          	li	a0,48
    800006c4:	bb7ff0ef          	jal	8000027a <consputc>
  consputc('x');
    800006c8:	07800513          	li	a0,120
    800006cc:	bafff0ef          	jal	8000027a <consputc>
    800006d0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d2:	00009c97          	auipc	s9,0x9
    800006d6:	26ec8c93          	addi	s9,s9,622 # 80009940 <digits>
    800006da:	03cad793          	srli	a5,s5,0x3c
    800006de:	97e6                	add	a5,a5,s9
    800006e0:	0007c503          	lbu	a0,0(a5)
    800006e4:	b97ff0ef          	jal	8000027a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006e8:	0a92                	slli	s5,s5,0x4
    800006ea:	3a7d                	addiw	s4,s4,-1
    800006ec:	fe0a17e3          	bnez	s4,800006da <printf+0x1e0>
    800006f0:	7ca2                	ld	s9,40(sp)
    800006f2:	b541                	j	80000572 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    800006f4:	f8843783          	ld	a5,-120(s0)
    800006f8:	00878713          	addi	a4,a5,8
    800006fc:	f8e43423          	sd	a4,-120(s0)
    80000700:	4388                	lw	a0,0(a5)
    80000702:	b79ff0ef          	jal	8000027a <consputc>
    80000706:	b5b5                	j	80000572 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    80000708:	f8843783          	ld	a5,-120(s0)
    8000070c:	00878713          	addi	a4,a5,8
    80000710:	f8e43423          	sd	a4,-120(s0)
    80000714:	0007ba03          	ld	s4,0(a5)
    80000718:	000a0d63          	beqz	s4,80000732 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    8000071c:	000a4503          	lbu	a0,0(s4)
    80000720:	e40509e3          	beqz	a0,80000572 <printf+0x78>
        consputc(*s);
    80000724:	b57ff0ef          	jal	8000027a <consputc>
      for(; *s; s++)
    80000728:	0a05                	addi	s4,s4,1
    8000072a:	000a4503          	lbu	a0,0(s4)
    8000072e:	f97d                	bnez	a0,80000724 <printf+0x22a>
    80000730:	b589                	j	80000572 <printf+0x78>
        s = "(null)";
    80000732:	00009a17          	auipc	s4,0x9
    80000736:	8d6a0a13          	addi	s4,s4,-1834 # 80009008 <etext+0x8>
      for(; *s; s++)
    8000073a:	02800513          	li	a0,40
    8000073e:	b7dd                	j	80000724 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80000740:	8556                	mv	a0,s5
    80000742:	b39ff0ef          	jal	8000027a <consputc>
    80000746:	b535                	j	80000572 <printf+0x78>
    80000748:	74a6                	ld	s1,104(sp)
    8000074a:	69e6                	ld	s3,88(sp)
    8000074c:	6a46                	ld	s4,80(sp)
    8000074e:	6aa6                	ld	s5,72(sp)
    80000750:	6b06                	ld	s6,64(sp)
    80000752:	7be2                	ld	s7,56(sp)
    80000754:	7c42                	ld	s8,48(sp)
    80000756:	7d02                	ld	s10,32(sp)
    80000758:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000075a:	00009797          	auipc	a5,0x9
    8000075e:	36a7a783          	lw	a5,874(a5) # 80009ac4 <panicking>
    80000762:	c38d                	beqz	a5,80000784 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80000764:	4501                	li	a0,0
    80000766:	70e6                	ld	ra,120(sp)
    80000768:	7446                	ld	s0,112(sp)
    8000076a:	7906                	ld	s2,96(sp)
    8000076c:	6129                	addi	sp,sp,192
    8000076e:	8082                	ret
    80000770:	74a6                	ld	s1,104(sp)
    80000772:	69e6                	ld	s3,88(sp)
    80000774:	6a46                	ld	s4,80(sp)
    80000776:	6aa6                	ld	s5,72(sp)
    80000778:	6b06                	ld	s6,64(sp)
    8000077a:	7be2                	ld	s7,56(sp)
    8000077c:	7c42                	ld	s8,48(sp)
    8000077e:	7d02                	ld	s10,32(sp)
    80000780:	6de2                	ld	s11,24(sp)
    80000782:	bfe1                	j	8000075a <printf+0x260>
    release(&pr.lock);
    80000784:	00011517          	auipc	a0,0x11
    80000788:	44450513          	addi	a0,a0,1092 # 80011bc8 <pr>
    8000078c:	20b000ef          	jal	80001196 <release>
  return 0;
    80000790:	bfd1                	j	80000764 <printf+0x26a>
    if(c0 == 'd'){
    80000792:	e37a8ee3          	beq	s5,s7,800005ce <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80000796:	f94a8713          	addi	a4,s5,-108
    8000079a:	00173713          	seqz	a4,a4
    8000079e:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007a0:	4781                	li	a5,0
    800007a2:	a00d                	j	800007c4 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    800007a4:	f94a8713          	addi	a4,s5,-108
    800007a8:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800007ac:	8656                	mv	a2,s5
    800007ae:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007b0:	f9460793          	addi	a5,a2,-108
    800007b4:	0017b793          	seqz	a5,a5
    800007b8:	8ff9                	and	a5,a5,a4
    800007ba:	f9c68593          	addi	a1,a3,-100
    800007be:	e199                	bnez	a1,800007c4 <printf+0x2ca>
    800007c0:	e20798e3          	bnez	a5,800005f0 <printf+0xf6>
    } else if(c0 == 'u'){
    800007c4:	e58a84e3          	beq	s5,s8,8000060c <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    800007c8:	f8b60593          	addi	a1,a2,-117
    800007cc:	e199                	bnez	a1,800007d2 <printf+0x2d8>
    800007ce:	e4071ce3          	bnez	a4,80000626 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800007d2:	f8b68593          	addi	a1,a3,-117
    800007d6:	e199                	bnez	a1,800007dc <printf+0x2e2>
    800007d8:	e60795e3          	bnez	a5,80000642 <printf+0x148>
    } else if(c0 == 'x'){
    800007dc:	e9aa81e3          	beq	s5,s10,8000065e <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    800007e0:	f8860613          	addi	a2,a2,-120
    800007e4:	e219                	bnez	a2,800007ea <printf+0x2f0>
    800007e6:	e80719e3          	bnez	a4,80000678 <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800007ea:	f8868693          	addi	a3,a3,-120
    800007ee:	e299                	bnez	a3,800007f4 <printf+0x2fa>
    800007f0:	ea0791e3          	bnez	a5,80000692 <printf+0x198>
    } else if(c0 == 'p'){
    800007f4:	ebba8de3          	beq	s5,s11,800006ae <printf+0x1b4>
    } else if(c0 == 'c'){
    800007f8:	06300793          	li	a5,99
    800007fc:	eefa8ce3          	beq	s5,a5,800006f4 <printf+0x1fa>
    } else if(c0 == 's'){
    80000800:	07300793          	li	a5,115
    80000804:	f0fa82e3          	beq	s5,a5,80000708 <printf+0x20e>
    } else if(c0 == '%'){
    80000808:	02500793          	li	a5,37
    8000080c:	f2fa8ae3          	beq	s5,a5,80000740 <printf+0x246>
    } else if(c0 == 0){
    80000810:	f60a80e3          	beqz	s5,80000770 <printf+0x276>
      consputc('%');
    80000814:	02500513          	li	a0,37
    80000818:	a63ff0ef          	jal	8000027a <consputc>
      consputc(c0);
    8000081c:	8556                	mv	a0,s5
    8000081e:	a5dff0ef          	jal	8000027a <consputc>
    80000822:	bb81                	j	80000572 <printf+0x78>

0000000080000824 <panic>:

void
panic(char *s)
{
    80000824:	1101                	addi	sp,sp,-32
    80000826:	ec06                	sd	ra,24(sp)
    80000828:	e822                	sd	s0,16(sp)
    8000082a:	e426                	sd	s1,8(sp)
    8000082c:	e04a                	sd	s2,0(sp)
    8000082e:	1000                	addi	s0,sp,32
    80000830:	892a                	mv	s2,a0
  panicking = 1;
    80000832:	4485                	li	s1,1
    80000834:	00009797          	auipc	a5,0x9
    80000838:	2897a823          	sw	s1,656(a5) # 80009ac4 <panicking>
  printf("panic: ");
    8000083c:	00008517          	auipc	a0,0x8
    80000840:	7dc50513          	addi	a0,a0,2012 # 80009018 <etext+0x18>
    80000844:	cb7ff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000848:	85ca                	mv	a1,s2
    8000084a:	00008517          	auipc	a0,0x8
    8000084e:	7d650513          	addi	a0,a0,2006 # 80009020 <etext+0x20>
    80000852:	ca9ff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000856:	00009797          	auipc	a5,0x9
    8000085a:	2697a523          	sw	s1,618(a5) # 80009ac0 <panicked>
  for(;;)
    8000085e:	a001                	j	8000085e <panic+0x3a>

0000000080000860 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000860:	1141                	addi	sp,sp,-16
    80000862:	e406                	sd	ra,8(sp)
    80000864:	e022                	sd	s0,0(sp)
    80000866:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000868:	00008597          	auipc	a1,0x8
    8000086c:	7c058593          	addi	a1,a1,1984 # 80009028 <etext+0x28>
    80000870:	00011517          	auipc	a0,0x11
    80000874:	35850513          	addi	a0,a0,856 # 80011bc8 <pr>
    80000878:	001000ef          	jal	80001078 <initlock>
}
    8000087c:	60a2                	ld	ra,8(sp)
    8000087e:	6402                	ld	s0,0(sp)
    80000880:	0141                	addi	sp,sp,16
    80000882:	8082                	ret

0000000080000884 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80000884:	1141                	addi	sp,sp,-16
    80000886:	e406                	sd	ra,8(sp)
    80000888:	e022                	sd	s0,0(sp)
    8000088a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000088c:	100007b7          	lui	a5,0x10000
    80000890:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000894:	10000737          	lui	a4,0x10000
    80000898:	f8000693          	li	a3,-128
    8000089c:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008a0:	468d                	li	a3,3
    800008a2:	10000637          	lui	a2,0x10000
    800008a6:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008aa:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008ae:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008b2:	8732                	mv	a4,a2
    800008b4:	461d                	li	a2,7
    800008b6:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008ba:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800008be:	00008597          	auipc	a1,0x8
    800008c2:	77258593          	addi	a1,a1,1906 # 80009030 <etext+0x30>
    800008c6:	00011517          	auipc	a0,0x11
    800008ca:	31a50513          	addi	a0,a0,794 # 80011be0 <tx_lock>
    800008ce:	7aa000ef          	jal	80001078 <initlock>
}
    800008d2:	60a2                	ld	ra,8(sp)
    800008d4:	6402                	ld	s0,0(sp)
    800008d6:	0141                	addi	sp,sp,16
    800008d8:	8082                	ret

00000000800008da <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008da:	715d                	addi	sp,sp,-80
    800008dc:	e486                	sd	ra,72(sp)
    800008de:	e0a2                	sd	s0,64(sp)
    800008e0:	fc26                	sd	s1,56(sp)
    800008e2:	ec56                	sd	s5,24(sp)
    800008e4:	0880                	addi	s0,sp,80
    800008e6:	8aaa                	mv	s5,a0
    800008e8:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800008ea:	00011517          	auipc	a0,0x11
    800008ee:	2f650513          	addi	a0,a0,758 # 80011be0 <tx_lock>
    800008f2:	011000ef          	jal	80001102 <acquire>

  int i = 0;
  while(i < n){ 
    800008f6:	06905063          	blez	s1,80000956 <uartwrite+0x7c>
    800008fa:	f84a                	sd	s2,48(sp)
    800008fc:	f44e                	sd	s3,40(sp)
    800008fe:	f052                	sd	s4,32(sp)
    80000900:	e85a                	sd	s6,16(sp)
    80000902:	e45e                	sd	s7,8(sp)
    80000904:	8a56                	mv	s4,s5
    80000906:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80000908:	00009497          	auipc	s1,0x9
    8000090c:	1c448493          	addi	s1,s1,452 # 80009acc <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	00011997          	auipc	s3,0x11
    80000914:	2d098993          	addi	s3,s3,720 # 80011be0 <tx_lock>
    80000918:	00009917          	auipc	s2,0x9
    8000091c:	1b090913          	addi	s2,s2,432 # 80009ac8 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80000920:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80000924:	4b05                	li	s6,1
    80000926:	a005                	j	80000946 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80000928:	85ce                	mv	a1,s3
    8000092a:	854a                	mv	a0,s2
    8000092c:	75d010ef          	jal	80002888 <sleep>
    while(tx_busy != 0){
    80000930:	409c                	lw	a5,0(s1)
    80000932:	fbfd                	bnez	a5,80000928 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80000934:	000a4783          	lbu	a5,0(s4)
    80000938:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    8000093c:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80000940:	0a05                	addi	s4,s4,1
    80000942:	015a0563          	beq	s4,s5,8000094c <uartwrite+0x72>
    while(tx_busy != 0){
    80000946:	409c                	lw	a5,0(s1)
    80000948:	f3e5                	bnez	a5,80000928 <uartwrite+0x4e>
    8000094a:	b7ed                	j	80000934 <uartwrite+0x5a>
    8000094c:	7942                	ld	s2,48(sp)
    8000094e:	79a2                	ld	s3,40(sp)
    80000950:	7a02                	ld	s4,32(sp)
    80000952:	6b42                	ld	s6,16(sp)
    80000954:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80000956:	00011517          	auipc	a0,0x11
    8000095a:	28a50513          	addi	a0,a0,650 # 80011be0 <tx_lock>
    8000095e:	039000ef          	jal	80001196 <release>
}
    80000962:	60a6                	ld	ra,72(sp)
    80000964:	6406                	ld	s0,64(sp)
    80000966:	74e2                	ld	s1,56(sp)
    80000968:	6ae2                	ld	s5,24(sp)
    8000096a:	6161                	addi	sp,sp,80
    8000096c:	8082                	ret

000000008000096e <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000096e:	1101                	addi	sp,sp,-32
    80000970:	ec06                	sd	ra,24(sp)
    80000972:	e822                	sd	s0,16(sp)
    80000974:	e426                	sd	s1,8(sp)
    80000976:	1000                	addi	s0,sp,32
    80000978:	84aa                	mv	s1,a0
  if(panicking == 0)
    8000097a:	00009797          	auipc	a5,0x9
    8000097e:	14a7a783          	lw	a5,330(a5) # 80009ac4 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	00009797          	auipc	a5,0x9
    80000988:	13c7a783          	lw	a5,316(a5) # 80009ac0 <panicked>
    8000098c:	ef85                	bnez	a5,800009c4 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000098e:	10000737          	lui	a4,0x10000
    80000992:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000994:	00074783          	lbu	a5,0(a4)
    80000998:	0207f793          	andi	a5,a5,32
    8000099c:	dfe5                	beqz	a5,80000994 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000099e:	0ff4f513          	zext.b	a0,s1
    800009a2:	100007b7          	lui	a5,0x10000
    800009a6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800009aa:	00009797          	auipc	a5,0x9
    800009ae:	11a7a783          	lw	a5,282(a5) # 80009ac4 <panicking>
    800009b2:	cb91                	beqz	a5,800009c6 <uartputc_sync+0x58>
    pop_off();
}
    800009b4:	60e2                	ld	ra,24(sp)
    800009b6:	6442                	ld	s0,16(sp)
    800009b8:	64a2                	ld	s1,8(sp)
    800009ba:	6105                	addi	sp,sp,32
    800009bc:	8082                	ret
    push_off();
    800009be:	700000ef          	jal	800010be <push_off>
    800009c2:	b7c9                	j	80000984 <uartputc_sync+0x16>
    for(;;)
    800009c4:	a001                	j	800009c4 <uartputc_sync+0x56>
    pop_off();
    800009c6:	780000ef          	jal	80001146 <pop_off>
}
    800009ca:	b7ed                	j	800009b4 <uartputc_sync+0x46>

00000000800009cc <uartgetc>:

// try to read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009cc:	1141                	addi	sp,sp,-16
    800009ce:	e406                	sd	ra,8(sp)
    800009d0:	e022                	sd	s0,0(sp)
    800009d2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800009d4:	100007b7          	lui	a5,0x10000
    800009d8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009dc:	8b85                	andi	a5,a5,1
    800009de:	cb89                	beqz	a5,800009f0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e0:	100007b7          	lui	a5,0x10000
    800009e4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009e8:	60a2                	ld	ra,8(sp)
    800009ea:	6402                	ld	s0,0(sp)
    800009ec:	0141                	addi	sp,sp,16
    800009ee:	8082                	ret
    return -1;
    800009f0:	557d                	li	a0,-1
    800009f2:	bfdd                	j	800009e8 <uartgetc+0x1c>

00000000800009f4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009f4:	1101                	addi	sp,sp,-32
    800009f6:	ec06                	sd	ra,24(sp)
    800009f8:	e822                	sd	s0,16(sp)
    800009fa:	e426                	sd	s1,8(sp)
    800009fc:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009fe:	100007b7          	lui	a5,0x10000
    80000a02:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80000a06:	00011517          	auipc	a0,0x11
    80000a0a:	1da50513          	addi	a0,a0,474 # 80011be0 <tx_lock>
    80000a0e:	6f4000ef          	jal	80001102 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80000a12:	100007b7          	lui	a5,0x10000
    80000a16:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a1a:	0207f793          	andi	a5,a5,32
    80000a1e:	ef99                	bnez	a5,80000a3c <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80000a20:	00011517          	auipc	a0,0x11
    80000a24:	1c050513          	addi	a0,a0,448 # 80011be0 <tx_lock>
    80000a28:	76e000ef          	jal	80001196 <release>

  // read and process incoming characters, if any.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a2c:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a2e:	f9fff0ef          	jal	800009cc <uartgetc>
    if(c == -1)
    80000a32:	02950063          	beq	a0,s1,80000a52 <uartintr+0x5e>
      break;
    consoleintr(c);
    80000a36:	877ff0ef          	jal	800002ac <consoleintr>
  while(1){
    80000a3a:	bfd5                	j	80000a2e <uartintr+0x3a>
    tx_busy = 0;
    80000a3c:	00009797          	auipc	a5,0x9
    80000a40:	0807a823          	sw	zero,144(a5) # 80009acc <tx_busy>
    wakeup(&tx_chan);
    80000a44:	00009517          	auipc	a0,0x9
    80000a48:	08450513          	addi	a0,a0,132 # 80009ac8 <tx_chan>
    80000a4c:	689010ef          	jal	800028d4 <wakeup>
    80000a50:	bfc1                	j	80000a20 <uartintr+0x2c>
  }
}
    80000a52:	60e2                	ld	ra,24(sp)
    80000a54:	6442                	ld	s0,16(sp)
    80000a56:	64a2                	ld	s1,8(sp)
    80000a58:	6105                	addi	sp,sp,32
    80000a5a:	8082                	ret

0000000080000a5c <kfree>:
    kfree(p);
}

void
kfree(void *pa)
{
    80000a5c:	1101                	addi	sp,sp,-32
    80000a5e:	ec06                	sd	ra,24(sp)
    80000a60:	e822                	sd	s0,16(sp)
    80000a62:	e426                	sd	s1,8(sp)
    80000a64:	e04a                	sd	s2,0(sp)
    80000a66:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a68:	00227797          	auipc	a5,0x227
    80000a6c:	93078793          	addi	a5,a5,-1744 # 80227398 <end>
    80000a70:	00f53733          	sltu	a4,a0,a5
    80000a74:	47c5                	li	a5,17
    80000a76:	07ee                	slli	a5,a5,0x1b
    80000a78:	17fd                	addi	a5,a5,-1
    80000a7a:	00a7b7b3          	sltu	a5,a5,a0
    80000a7e:	8fd9                	or	a5,a5,a4
    80000a80:	ef95                	bnez	a5,80000abc <kfree+0x60>
    80000a82:	84aa                	mv	s1,a0
    80000a84:	03451793          	slli	a5,a0,0x34
    80000a88:	eb95                	bnez	a5,80000abc <kfree+0x60>
    panic("kfree");

  memset(pa, 1, PGSIZE);
    80000a8a:	6605                	lui	a2,0x1
    80000a8c:	4585                	li	a1,1
    80000a8e:	744000ef          	jal	800011d2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a92:	00011917          	auipc	s2,0x11
    80000a96:	16690913          	addi	s2,s2,358 # 80011bf8 <kmem>
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	666000ef          	jal	80001102 <acquire>
  r->next = kmem.freelist;
    80000aa0:	01893783          	ld	a5,24(s2)
    80000aa4:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aa6:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	6ea000ef          	jal	80001196 <release>
}
    80000ab0:	60e2                	ld	ra,24(sp)
    80000ab2:	6442                	ld	s0,16(sp)
    80000ab4:	64a2                	ld	s1,8(sp)
    80000ab6:	6902                	ld	s2,0(sp)
    80000ab8:	6105                	addi	sp,sp,32
    80000aba:	8082                	ret
    panic("kfree");
    80000abc:	00008517          	auipc	a0,0x8
    80000ac0:	57c50513          	addi	a0,a0,1404 # 80009038 <etext+0x38>
    80000ac4:	d61ff0ef          	jal	80000824 <panic>

0000000080000ac8 <freerange>:
{
    80000ac8:	7179                	addi	sp,sp,-48
    80000aca:	f406                	sd	ra,40(sp)
    80000acc:	f022                	sd	s0,32(sp)
    80000ace:	ec26                	sd	s1,24(sp)
    80000ad0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ad2:	6785                	lui	a5,0x1
    80000ad4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad8:	00e504b3          	add	s1,a0,a4
    80000adc:	777d                	lui	a4,0xfffff
    80000ade:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae0:	94be                	add	s1,s1,a5
    80000ae2:	0295e263          	bltu	a1,s1,80000b06 <freerange+0x3e>
    80000ae6:	e84a                	sd	s2,16(sp)
    80000ae8:	e44e                	sd	s3,8(sp)
    80000aea:	e052                	sd	s4,0(sp)
    80000aec:	892e                	mv	s2,a1
    kfree(p);
    80000aee:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af0:	89be                	mv	s3,a5
    kfree(p);
    80000af2:	01448533          	add	a0,s1,s4
    80000af6:	f67ff0ef          	jal	80000a5c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000afa:	94ce                	add	s1,s1,s3
    80000afc:	fe997be3          	bgeu	s2,s1,80000af2 <freerange+0x2a>
    80000b00:	6942                	ld	s2,16(sp)
    80000b02:	69a2                	ld	s3,8(sp)
    80000b04:	6a02                	ld	s4,0(sp)
}
    80000b06:	70a2                	ld	ra,40(sp)
    80000b08:	7402                	ld	s0,32(sp)
    80000b0a:	64e2                	ld	s1,24(sp)
    80000b0c:	6145                	addi	sp,sp,48
    80000b0e:	8082                	ret

0000000080000b10 <kinit>:
{
    80000b10:	1141                	addi	sp,sp,-16
    80000b12:	e406                	sd	ra,8(sp)
    80000b14:	e022                	sd	s0,0(sp)
    80000b16:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b18:	00008597          	auipc	a1,0x8
    80000b1c:	52858593          	addi	a1,a1,1320 # 80009040 <etext+0x40>
    80000b20:	00011517          	auipc	a0,0x11
    80000b24:	0d850513          	addi	a0,a0,216 # 80011bf8 <kmem>
    80000b28:	550000ef          	jal	80001078 <initlock>
  initlock(&frame_lock, "frame");
    80000b2c:	00008597          	auipc	a1,0x8
    80000b30:	53c58593          	addi	a1,a1,1340 # 80009068 <etext+0x68>
    80000b34:	00011517          	auipc	a0,0x11
    80000b38:	0e450513          	addi	a0,a0,228 # 80011c18 <frame_lock>
    80000b3c:	53c000ef          	jal	80001078 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b40:	45c5                	li	a1,17
    80000b42:	05ee                	slli	a1,a1,0x1b
    80000b44:	00227517          	auipc	a0,0x227
    80000b48:	85450513          	addi	a0,a0,-1964 # 80227398 <end>
    80000b4c:	f7dff0ef          	jal	80000ac8 <freerange>
  for(int i = 0; i < MAX_FRAMES; i++){
    80000b50:	00011797          	auipc	a5,0x11
    80000b54:	0e078793          	addi	a5,a5,224 # 80011c30 <frame_table>
    80000b58:	00011717          	auipc	a4,0x11
    80000b5c:	5d870713          	addi	a4,a4,1496 # 80012130 <pid_lock>
    frame_table[i].used    = 0;
    80000b60:	0007a023          	sw	zero,0(a5)
    frame_table[i].proc    = 0;
    80000b64:	0007b423          	sd	zero,8(a5)
    frame_table[i].va      = 0;
    80000b68:	0007b823          	sd	zero,16(a5)
    frame_table[i].pa      = 0;
    80000b6c:	0007bc23          	sd	zero,24(a5)
    frame_table[i].ref_bit = 0;
    80000b70:	0207a023          	sw	zero,32(a5)
    frame_table[i].grace   = 0;
    80000b74:	0207a223          	sw	zero,36(a5)
  for(int i = 0; i < MAX_FRAMES; i++){
    80000b78:	02878793          	addi	a5,a5,40
    80000b7c:	fee792e3          	bne	a5,a4,80000b60 <kinit+0x50>
}
    80000b80:	60a2                	ld	ra,8(sp)
    80000b82:	6402                	ld	s0,0(sp)
    80000b84:	0141                	addi	sp,sp,16
    80000b86:	8082                	ret

0000000080000b88 <kalloc>:

void *
kalloc(void)
{
    80000b88:	1101                	addi	sp,sp,-32
    80000b8a:	ec06                	sd	ra,24(sp)
    80000b8c:	e822                	sd	s0,16(sp)
    80000b8e:	e426                	sd	s1,8(sp)
    80000b90:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b92:	00011517          	auipc	a0,0x11
    80000b96:	06650513          	addi	a0,a0,102 # 80011bf8 <kmem>
    80000b9a:	568000ef          	jal	80001102 <acquire>
  r = kmem.freelist;
    80000b9e:	00011497          	auipc	s1,0x11
    80000ba2:	0724b483          	ld	s1,114(s1) # 80011c10 <kmem+0x18>
  if(r)
    80000ba6:	c49d                	beqz	s1,80000bd4 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000ba8:	609c                	ld	a5,0(s1)
    80000baa:	00011717          	auipc	a4,0x11
    80000bae:	06f73323          	sd	a5,102(a4) # 80011c10 <kmem+0x18>
  release(&kmem.lock);
    80000bb2:	00011517          	auipc	a0,0x11
    80000bb6:	04650513          	addi	a0,a0,70 # 80011bf8 <kmem>
    80000bba:	5dc000ef          	jal	80001196 <release>

  if(r)
    memset((char*)r, 5, PGSIZE);
    80000bbe:	6605                	lui	a2,0x1
    80000bc0:	4595                	li	a1,5
    80000bc2:	8526                	mv	a0,s1
    80000bc4:	60e000ef          	jal	800011d2 <memset>
  return (void*)r;
}
    80000bc8:	8526                	mv	a0,s1
    80000bca:	60e2                	ld	ra,24(sp)
    80000bcc:	6442                	ld	s0,16(sp)
    80000bce:	64a2                	ld	s1,8(sp)
    80000bd0:	6105                	addi	sp,sp,32
    80000bd2:	8082                	ret
  release(&kmem.lock);
    80000bd4:	00011517          	auipc	a0,0x11
    80000bd8:	02450513          	addi	a0,a0,36 # 80011bf8 <kmem>
    80000bdc:	5ba000ef          	jal	80001196 <release>
  if(r)
    80000be0:	b7e5                	j	80000bc8 <kalloc+0x40>

0000000080000be2 <kalloc_user>:

  panic("clock_pick_victim: no evictable frame");
}
char *
kalloc_user(struct proc *p, uint64 va)
{
    80000be2:	7139                	addi	sp,sp,-64
    80000be4:	fc06                	sd	ra,56(sp)
    80000be6:	f822                	sd	s0,48(sp)
    80000be8:	f426                	sd	s1,40(sp)
    80000bea:	f04a                	sd	s2,32(sp)
    80000bec:	e852                	sd	s4,16(sp)
    80000bee:	0080                	addi	s0,sp,64
    80000bf0:	892a                	mv	s2,a0
    80000bf2:	8a2e                	mv	s4,a1
  acquire(&frame_lock);
    80000bf4:	00011517          	auipc	a0,0x11
    80000bf8:	02450513          	addi	a0,a0,36 # 80011c18 <frame_lock>
    80000bfc:	506000ef          	jal	80001102 <acquire>

  // Fast path: find a free frame slot
  for(int i = 0; i < MAX_FRAMES; i++){
    80000c00:	00011517          	auipc	a0,0x11
    80000c04:	03050513          	addi	a0,a0,48 # 80011c30 <frame_table>
  acquire(&frame_lock);
    80000c08:	87aa                	mv	a5,a0
  for(int i = 0; i < MAX_FRAMES; i++){
    80000c0a:	4481                	li	s1,0
    80000c0c:	02000713          	li	a4,32
    if(!frame_table[i].used){
    80000c10:	4394                	lw	a3,0(a5)
    80000c12:	c685                	beqz	a3,80000c3a <kalloc_user+0x58>
  for(int i = 0; i < MAX_FRAMES; i++){
    80000c14:	2485                	addiw	s1,s1,1
    80000c16:	02878793          	addi	a5,a5,40
    80000c1a:	fee49be3          	bne	s1,a4,80000c10 <kalloc_user+0x2e>
    80000c1e:	ec4e                	sd	s3,24(sp)
    80000c20:	e456                	sd	s5,8(sp)
    80000c22:	e05a                	sd	s6,0(sp)
    80000c24:	00009617          	auipc	a2,0x9
    80000c28:	eac62603          	lw	a2,-340(a2) # 80009ad0 <clock_hand>
    80000c2c:	04000593          	li	a1,64
    if(!f->used || f->proc != curr)
    80000c30:	00011817          	auipc	a6,0x11
    80000c34:	fc880813          	addi	a6,a6,-56 # 80011bf8 <kmem>
    80000c38:	a0f9                	j	80000d06 <kalloc_user+0x124>
      frame_table[i].used    = 1;
    80000c3a:	00249713          	slli	a4,s1,0x2
    80000c3e:	9726                	add	a4,a4,s1
    80000c40:	070e                	slli	a4,a4,0x3
    80000c42:	00011797          	auipc	a5,0x11
    80000c46:	fb678793          	addi	a5,a5,-74 # 80011bf8 <kmem>
    80000c4a:	97ba                	add	a5,a5,a4
    80000c4c:	4705                	li	a4,1
    80000c4e:	df98                	sw	a4,56(a5)
      frame_table[i].proc    = p;
    80000c50:	0527b023          	sd	s2,64(a5)
      frame_table[i].va      = va;
    80000c54:	0547b423          	sd	s4,72(a5)
      frame_table[i].ref_bit = 1;
    80000c58:	cfb8                	sw	a4,88(a5)
      frame_table[i].grace   = 0;
    80000c5a:	0407ae23          	sw	zero,92(a5)
      release(&frame_lock);
    80000c5e:	00011517          	auipc	a0,0x11
    80000c62:	fba50513          	addi	a0,a0,-70 # 80011c18 <frame_lock>
    80000c66:	530000ef          	jal	80001196 <release>

      char *mem = kalloc();
    80000c6a:	f1fff0ef          	jal	80000b88 <kalloc>
    80000c6e:	892a                	mv	s2,a0
      if(mem == 0){
    80000c70:	c121                	beqz	a0,80000cb0 <kalloc_user+0xce>
        frame_table[i].proc = 0;
        release(&frame_lock);
        return 0;
      }

      acquire(&frame_lock);
    80000c72:	00011517          	auipc	a0,0x11
    80000c76:	fa650513          	addi	a0,a0,-90 # 80011c18 <frame_lock>
    80000c7a:	488000ef          	jal	80001102 <acquire>
      frame_table[i].pa = (uint64)mem;
    80000c7e:	00249793          	slli	a5,s1,0x2
    80000c82:	97a6                	add	a5,a5,s1
    80000c84:	078e                	slli	a5,a5,0x3
    80000c86:	00011717          	auipc	a4,0x11
    80000c8a:	f7270713          	addi	a4,a4,-142 # 80011bf8 <kmem>
    80000c8e:	97ba                	add	a5,a5,a4
    80000c90:	0527b823          	sd	s2,80(a5)
      release(&frame_lock);
    80000c94:	00011517          	auipc	a0,0x11
    80000c98:	f8450513          	addi	a0,a0,-124 # 80011c18 <frame_lock>
    80000c9c:	4fa000ef          	jal	80001196 <release>
  acquire(&frame_lock);
  frame_table[victim].pa = (uint64)mem;
  release(&frame_lock);

  return mem;
}
    80000ca0:	854a                	mv	a0,s2
    80000ca2:	70e2                	ld	ra,56(sp)
    80000ca4:	7442                	ld	s0,48(sp)
    80000ca6:	74a2                	ld	s1,40(sp)
    80000ca8:	7902                	ld	s2,32(sp)
    80000caa:	6a42                	ld	s4,16(sp)
    80000cac:	6121                	addi	sp,sp,64
    80000cae:	8082                	ret
    80000cb0:	ec4e                	sd	s3,24(sp)
        acquire(&frame_lock);
    80000cb2:	00011997          	auipc	s3,0x11
    80000cb6:	f4698993          	addi	s3,s3,-186 # 80011bf8 <kmem>
    80000cba:	00011517          	auipc	a0,0x11
    80000cbe:	f5e50513          	addi	a0,a0,-162 # 80011c18 <frame_lock>
    80000cc2:	440000ef          	jal	80001102 <acquire>
        frame_table[i].used = 0;
    80000cc6:	00249793          	slli	a5,s1,0x2
    80000cca:	00978733          	add	a4,a5,s1
    80000cce:	070e                	slli	a4,a4,0x3
    80000cd0:	974e                	add	a4,a4,s3
    80000cd2:	02072c23          	sw	zero,56(a4)
        frame_table[i].proc = 0;
    80000cd6:	04073023          	sd	zero,64(a4)
        release(&frame_lock);
    80000cda:	00011517          	auipc	a0,0x11
    80000cde:	f3e50513          	addi	a0,a0,-194 # 80011c18 <frame_lock>
    80000ce2:	4b4000ef          	jal	80001196 <release>
        return 0;
    80000ce6:	69e2                	ld	s3,24(sp)
    80000ce8:	bf65                	j	80000ca0 <kalloc_user+0xbe>
      f->ref_bit = 0;
    80000cea:	00249793          	slli	a5,s1,0x2
    80000cee:	97a6                	add	a5,a5,s1
    80000cf0:	078e                	slli	a5,a5,0x3
    80000cf2:	00011717          	auipc	a4,0x11
    80000cf6:	f0670713          	addi	a4,a4,-250 # 80011bf8 <kmem>
    80000cfa:	97ba                	add	a5,a5,a4
    80000cfc:	0407ac23          	sw	zero,88(a5)
  for(int sweep = 0; sweep < 2 * MAX_FRAMES; sweep++){
    80000d00:	35fd                	addiw	a1,a1,-1
    80000d02:	12058263          	beqz	a1,80000e26 <kalloc_user+0x244>
    clock_hand = (clock_hand + 1) % MAX_FRAMES;
    80000d06:	84b2                	mv	s1,a2
    80000d08:	0016079b          	addiw	a5,a2,1
    80000d0c:	41f7d71b          	sraiw	a4,a5,0x1f
    80000d10:	01b7571b          	srliw	a4,a4,0x1b
    80000d14:	9fb9                	addw	a5,a5,a4
    80000d16:	8bfd                	andi	a5,a5,31
    80000d18:	9f99                	subw	a5,a5,a4
    80000d1a:	863e                	mv	a2,a5
    if(!f->used || f->proc != curr)
    80000d1c:	00249693          	slli	a3,s1,0x2
    80000d20:	96a6                	add	a3,a3,s1
    80000d22:	068e                	slli	a3,a3,0x3
    80000d24:	96c2                	add	a3,a3,a6
    80000d26:	5e98                	lw	a4,56(a3)
    80000d28:	df61                	beqz	a4,80000d00 <kalloc_user+0x11e>
    80000d2a:	62b8                	ld	a4,64(a3)
    80000d2c:	fce91ae3          	bne	s2,a4,80000d00 <kalloc_user+0x11e>
    if(f->ref_bit){
    80000d30:	4eb8                	lw	a4,88(a3)
    80000d32:	ff45                	bnez	a4,80000cea <kalloc_user+0x108>
    80000d34:	00009717          	auipc	a4,0x9
    80000d38:	d8f72e23          	sw	a5,-612(a4) # 80009ad0 <clock_hand>
  struct proc  *vp  = frame_table[victim].proc;
    80000d3c:	00249713          	slli	a4,s1,0x2
    80000d40:	9726                	add	a4,a4,s1
    80000d42:	070e                	slli	a4,a4,0x3
    80000d44:	00011797          	auipc	a5,0x11
    80000d48:	eb478793          	addi	a5,a5,-332 # 80011bf8 <kmem>
    80000d4c:	97ba                	add	a5,a5,a4
    80000d4e:	0407b983          	ld	s3,64(a5)
  uint64        vva = frame_table[victim].va;
    80000d52:	67b8                	ld	a4,72(a5)
    80000d54:	8b3a                	mv	s6,a4
  uint64        vpa = frame_table[victim].pa;
    80000d56:	6bb8                	ld	a4,80(a5)
    80000d58:	8aba                	mv	s5,a4
  frame_table[victim].used    = 1;
    80000d5a:	4705                	li	a4,1
    80000d5c:	df98                	sw	a4,56(a5)
  frame_table[victim].proc    = p;
    80000d5e:	0527b023          	sd	s2,64(a5)
  frame_table[victim].va      = va;
    80000d62:	0547b423          	sd	s4,72(a5)
  frame_table[victim].pa      = 0;   // updated after kalloc below
    80000d66:	0407b823          	sd	zero,80(a5)
  frame_table[victim].ref_bit = 1;
    80000d6a:	cfb8                	sw	a4,88(a5)
  frame_table[victim].grace   = 0;
    80000d6c:	0407ae23          	sw	zero,92(a5)
  release(&frame_lock);
    80000d70:	00011517          	auipc	a0,0x11
    80000d74:	ea850513          	addi	a0,a0,-344 # 80011c18 <frame_lock>
    80000d78:	41e000ef          	jal	80001196 <release>
  int slot = swap_alloc();
    80000d7c:	708020ef          	jal	80003484 <swap_alloc>
  if(slot < 0){
    80000d80:	14054663          	bltz	a0,80000ecc <kalloc_user+0x2ea>
  swap_write(slot, (char *)vpa, vp, vva, p);
    80000d84:	874a                	mv	a4,s2
    80000d86:	86da                	mv	a3,s6
    80000d88:	864e                	mv	a2,s3
    80000d8a:	85d6                	mv	a1,s5
    80000d8c:	8a2a                	mv	s4,a0
    80000d8e:	7aa020ef          	jal	80003538 <swap_write>
  if(vp != 0 && vp->pagetable != 0){
    80000d92:	04098763          	beqz	s3,80000de0 <kalloc_user+0x1fe>
    80000d96:	0509b503          	ld	a0,80(s3)
    80000d9a:	c505                	beqz	a0,80000dc2 <kalloc_user+0x1e0>
    pte_t *pte = walk(vp->pagetable, vva, 0);
    80000d9c:	4601                	li	a2,0
    80000d9e:	85da                	mv	a1,s6
    80000da0:	6ca000ef          	jal	8000146a <walk>
    if(pte && (*pte & PTE_V)){
    80000da4:	cd19                	beqz	a0,80000dc2 <kalloc_user+0x1e0>
    80000da6:	6118                	ld	a4,0(a0)
    80000da8:	00177793          	andi	a5,a4,1
    80000dac:	cb99                	beqz	a5,80000dc2 <kalloc_user+0x1e0>
      *pte = ((pte_t)slot << PTE_SWAP_SHIFT) | PTE_SWAPPED | perms;
    80000dae:	00aa1793          	slli	a5,s4,0xa
    80000db2:	3fe77713          	andi	a4,a4,1022
      *pte &= ~PTE_V;
    80000db6:	8fd9                	or	a5,a5,a4
    80000db8:	1007e793          	ori	a5,a5,256
    80000dbc:	e11c                	sd	a5,0(a0)
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000dbe:	12000073          	sfence.vma
    vp->pages_evicted++;
    80000dc2:	1949a783          	lw	a5,404(s3)
    80000dc6:	2785                	addiw	a5,a5,1
    80000dc8:	18f9aa23          	sw	a5,404(s3)
    vp->pages_swapped_out++;
    80000dcc:	19c9a783          	lw	a5,412(s3)
    80000dd0:	2785                	addiw	a5,a5,1
    80000dd2:	18f9ae23          	sw	a5,412(s3)
    vp->resident_pages--;
    80000dd6:	1a09a783          	lw	a5,416(s3)
    80000dda:	37fd                	addiw	a5,a5,-1
    80000ddc:	1af9a023          	sw	a5,416(s3)
  kfree((void *)vpa);
    80000de0:	8556                	mv	a0,s5
    80000de2:	c7bff0ef          	jal	80000a5c <kfree>
  char *mem = kalloc();
    80000de6:	da3ff0ef          	jal	80000b88 <kalloc>
    80000dea:	892a                	mv	s2,a0
  if(mem == 0){
    80000dec:	10050f63          	beqz	a0,80000f0a <kalloc_user+0x328>
  acquire(&frame_lock);
    80000df0:	00011517          	auipc	a0,0x11
    80000df4:	e2850513          	addi	a0,a0,-472 # 80011c18 <frame_lock>
    80000df8:	30a000ef          	jal	80001102 <acquire>
  frame_table[victim].pa = (uint64)mem;
    80000dfc:	00249793          	slli	a5,s1,0x2
    80000e00:	97a6                	add	a5,a5,s1
    80000e02:	078e                	slli	a5,a5,0x3
    80000e04:	00011717          	auipc	a4,0x11
    80000e08:	df470713          	addi	a4,a4,-524 # 80011bf8 <kmem>
    80000e0c:	97ba                	add	a5,a5,a4
    80000e0e:	0527b823          	sd	s2,80(a5)
  release(&frame_lock);
    80000e12:	00011517          	auipc	a0,0x11
    80000e16:	e0650513          	addi	a0,a0,-506 # 80011c18 <frame_lock>
    80000e1a:	37c000ef          	jal	80001196 <release>
    80000e1e:	69e2                	ld	s3,24(sp)
    80000e20:	6aa2                	ld	s5,8(sp)
    80000e22:	6b02                	ld	s6,0(sp)
  return mem;
    80000e24:	bdb5                	j	80000ca0 <kalloc_user+0xbe>
    80000e26:	04000813          	li	a6,64
    if(!f->used || f->proc == 0)
    80000e2a:	00011597          	auipc	a1,0x11
    80000e2e:	dce58593          	addi	a1,a1,-562 # 80011bf8 <kmem>
    80000e32:	a839                	j	80000e50 <kalloc_user+0x26e>
      f->ref_bit = 0;
    80000e34:	00249793          	slli	a5,s1,0x2
    80000e38:	97a6                	add	a5,a5,s1
    80000e3a:	078e                	slli	a5,a5,0x3
    80000e3c:	00011697          	auipc	a3,0x11
    80000e40:	dbc68693          	addi	a3,a3,-580 # 80011bf8 <kmem>
    80000e44:	97b6                	add	a5,a5,a3
    80000e46:	0407ac23          	sw	zero,88(a5)
  for(int sweep = 0; sweep < 2 * MAX_FRAMES; sweep++){
    80000e4a:	387d                	addiw	a6,a6,-1
    80000e4c:	04080863          	beqz	a6,80000e9c <kalloc_user+0x2ba>
    clock_hand = (clock_hand + 1) % MAX_FRAMES;
    80000e50:	84b2                	mv	s1,a2
    80000e52:	0016079b          	addiw	a5,a2,1
    80000e56:	41f7d69b          	sraiw	a3,a5,0x1f
    80000e5a:	01b6d69b          	srliw	a3,a3,0x1b
    80000e5e:	00f6873b          	addw	a4,a3,a5
    80000e62:	8b7d                	andi	a4,a4,31
    80000e64:	9f15                	subw	a4,a4,a3
    80000e66:	863a                	mv	a2,a4
    if(!f->used || f->proc == 0)
    80000e68:	00249793          	slli	a5,s1,0x2
    80000e6c:	97a6                	add	a5,a5,s1
    80000e6e:	078e                	slli	a5,a5,0x3
    80000e70:	97ae                	add	a5,a5,a1
    80000e72:	5f9c                	lw	a5,56(a5)
    80000e74:	dbf9                	beqz	a5,80000e4a <kalloc_user+0x268>
    80000e76:	00249793          	slli	a5,s1,0x2
    80000e7a:	97a6                	add	a5,a5,s1
    80000e7c:	078e                	slli	a5,a5,0x3
    80000e7e:	97ae                	add	a5,a5,a1
    80000e80:	63bc                	ld	a5,64(a5)
    80000e82:	d7e1                	beqz	a5,80000e4a <kalloc_user+0x268>
    if(f->ref_bit){
    80000e84:	00249793          	slli	a5,s1,0x2
    80000e88:	97a6                	add	a5,a5,s1
    80000e8a:	078e                	slli	a5,a5,0x3
    80000e8c:	97ae                	add	a5,a5,a1
    80000e8e:	4fbc                	lw	a5,88(a5)
    80000e90:	f3d5                	bnez	a5,80000e34 <kalloc_user+0x252>
    80000e92:	00009797          	auipc	a5,0x9
    80000e96:	c2e7af23          	sw	a4,-962(a5) # 80009ad0 <clock_hand>
    80000e9a:	b54d                	j	80000d3c <kalloc_user+0x15a>
    80000e9c:	00009797          	auipc	a5,0x9
    80000ea0:	c2e7aa23          	sw	a4,-972(a5) # 80009ad0 <clock_hand>
  for(int i = 0; i < MAX_FRAMES; i++){
    80000ea4:	4481                	li	s1,0
    80000ea6:	02000793          	li	a5,32
    80000eaa:	a031                	j	80000eb6 <kalloc_user+0x2d4>
    80000eac:	2485                	addiw	s1,s1,1
    80000eae:	02850513          	addi	a0,a0,40
    80000eb2:	00f48763          	beq	s1,a5,80000ec0 <kalloc_user+0x2de>
    if(frame_table[i].used && frame_table[i].proc != 0)
    80000eb6:	4118                	lw	a4,0(a0)
    80000eb8:	db75                	beqz	a4,80000eac <kalloc_user+0x2ca>
    80000eba:	6518                	ld	a4,8(a0)
    80000ebc:	db65                	beqz	a4,80000eac <kalloc_user+0x2ca>
    80000ebe:	bdbd                	j	80000d3c <kalloc_user+0x15a>
  panic("clock_pick_victim: no evictable frame");
    80000ec0:	00008517          	auipc	a0,0x8
    80000ec4:	18850513          	addi	a0,a0,392 # 80009048 <etext+0x48>
    80000ec8:	95dff0ef          	jal	80000824 <panic>
    acquire(&frame_lock);
    80000ecc:	00011917          	auipc	s2,0x11
    80000ed0:	d2c90913          	addi	s2,s2,-724 # 80011bf8 <kmem>
    80000ed4:	00011517          	auipc	a0,0x11
    80000ed8:	d4450513          	addi	a0,a0,-700 # 80011c18 <frame_lock>
    80000edc:	226000ef          	jal	80001102 <acquire>
    frame_table[victim].used = 0;
    80000ee0:	00249793          	slli	a5,s1,0x2
    80000ee4:	00978733          	add	a4,a5,s1
    80000ee8:	070e                	slli	a4,a4,0x3
    80000eea:	974a                	add	a4,a4,s2
    80000eec:	02072c23          	sw	zero,56(a4)
    frame_table[victim].proc = 0;
    80000ef0:	04073023          	sd	zero,64(a4)
    release(&frame_lock);
    80000ef4:	00011517          	auipc	a0,0x11
    80000ef8:	d2450513          	addi	a0,a0,-732 # 80011c18 <frame_lock>
    80000efc:	29a000ef          	jal	80001196 <release>
    return 0;
    80000f00:	4901                	li	s2,0
    80000f02:	69e2                	ld	s3,24(sp)
    80000f04:	6aa2                	ld	s5,8(sp)
    80000f06:	6b02                	ld	s6,0(sp)
    80000f08:	bb61                	j	80000ca0 <kalloc_user+0xbe>
    acquire(&frame_lock);
    80000f0a:	00011997          	auipc	s3,0x11
    80000f0e:	cee98993          	addi	s3,s3,-786 # 80011bf8 <kmem>
    80000f12:	00011517          	auipc	a0,0x11
    80000f16:	d0650513          	addi	a0,a0,-762 # 80011c18 <frame_lock>
    80000f1a:	1e8000ef          	jal	80001102 <acquire>
    frame_table[victim].used = 0;
    80000f1e:	00249793          	slli	a5,s1,0x2
    80000f22:	00978733          	add	a4,a5,s1
    80000f26:	070e                	slli	a4,a4,0x3
    80000f28:	974e                	add	a4,a4,s3
    80000f2a:	02072c23          	sw	zero,56(a4)
    frame_table[victim].proc = 0;
    80000f2e:	04073023          	sd	zero,64(a4)
    release(&frame_lock);
    80000f32:	00011517          	auipc	a0,0x11
    80000f36:	ce650513          	addi	a0,a0,-794 # 80011c18 <frame_lock>
    80000f3a:	25c000ef          	jal	80001196 <release>
    return 0;
    80000f3e:	69e2                	ld	s3,24(sp)
    80000f40:	6aa2                	ld	s5,8(sp)
    80000f42:	6b02                	ld	s6,0(sp)
    80000f44:	bbb1                	j	80000ca0 <kalloc_user+0xbe>

0000000080000f46 <evict_page>:

void
evict_page(int idx)
{
    80000f46:	7179                	addi	sp,sp,-48
    80000f48:	f406                	sd	ra,40(sp)
    80000f4a:	f022                	sd	s0,32(sp)
    80000f4c:	ec26                	sd	s1,24(sp)
    80000f4e:	e84a                	sd	s2,16(sp)
    80000f50:	1800                	addi	s0,sp,48
    80000f52:	84aa                	mv	s1,a0
  acquire(&frame_lock);
    80000f54:	00011517          	auipc	a0,0x11
    80000f58:	cc450513          	addi	a0,a0,-828 # 80011c18 <frame_lock>
    80000f5c:	1a6000ef          	jal	80001102 <acquire>

  struct frame_entry *f = &frame_table[idx];
  struct proc *p  = f->proc;
    80000f60:	00249793          	slli	a5,s1,0x2
    80000f64:	97a6                	add	a5,a5,s1
    80000f66:	078e                	slli	a5,a5,0x3
    80000f68:	00011717          	auipc	a4,0x11
    80000f6c:	c9070713          	addi	a4,a4,-880 # 80011bf8 <kmem>
    80000f70:	97ba                	add	a5,a5,a4
    80000f72:	0407b903          	ld	s2,64(a5)
  uint64      va  = f->va;

  if(p == 0 || p->state == UNUSED){
    80000f76:	00090563          	beqz	s2,80000f80 <evict_page+0x3a>
    80000f7a:	01892783          	lw	a5,24(s2)
    80000f7e:	eb9d                	bnez	a5,80000fb4 <evict_page+0x6e>
    f->used = 0;
    80000f80:	00011697          	auipc	a3,0x11
    80000f84:	c7868693          	addi	a3,a3,-904 # 80011bf8 <kmem>
    80000f88:	00249793          	slli	a5,s1,0x2
    80000f8c:	00978733          	add	a4,a5,s1
    80000f90:	070e                	slli	a4,a4,0x3
    80000f92:	9736                	add	a4,a4,a3
    80000f94:	02072c23          	sw	zero,56(a4)
    f->proc = 0;
    80000f98:	04073023          	sd	zero,64(a4)
    release(&frame_lock);
    80000f9c:	00011517          	auipc	a0,0x11
    80000fa0:	c7c50513          	addi	a0,a0,-900 # 80011c18 <frame_lock>
    80000fa4:	1f2000ef          	jal	80001196 <release>
  p->pages_swapped_out++;
  p->resident_pages--;

  release(&p->lock);
  sfence_vma();
    80000fa8:	70a2                	ld	ra,40(sp)
    80000faa:	7402                	ld	s0,32(sp)
    80000fac:	64e2                	ld	s1,24(sp)
    80000fae:	6942                	ld	s2,16(sp)
    80000fb0:	6145                	addi	sp,sp,48
    80000fb2:	8082                	ret
    80000fb4:	e44e                	sd	s3,8(sp)
    80000fb6:	e052                	sd	s4,0(sp)
  uint64      va  = f->va;
    80000fb8:	00011697          	auipc	a3,0x11
    80000fbc:	c4068693          	addi	a3,a3,-960 # 80011bf8 <kmem>
    80000fc0:	00249793          	slli	a5,s1,0x2
    80000fc4:	00978733          	add	a4,a5,s1
    80000fc8:	070e                	slli	a4,a4,0x3
    80000fca:	9736                	add	a4,a4,a3
    80000fcc:	04873983          	ld	s3,72(a4)
    80000fd0:	8a4e                	mv	s4,s3
  f->used = 0;
    80000fd2:	02072c23          	sw	zero,56(a4)
  f->proc = 0;
    80000fd6:	04073023          	sd	zero,64(a4)
  release(&frame_lock);
    80000fda:	00011517          	auipc	a0,0x11
    80000fde:	c3e50513          	addi	a0,a0,-962 # 80011c18 <frame_lock>
    80000fe2:	1b4000ef          	jal	80001196 <release>
  acquire(&p->lock);
    80000fe6:	854a                	mv	a0,s2
    80000fe8:	11a000ef          	jal	80001102 <acquire>
  pte_t *pte = walk(p->pagetable, va, 0);
    80000fec:	4601                	li	a2,0
    80000fee:	85ce                	mv	a1,s3
    80000ff0:	05093503          	ld	a0,80(s2)
    80000ff4:	476000ef          	jal	8000146a <walk>
    80000ff8:	84aa                	mv	s1,a0
  if(pte == 0 || (*pte & PTE_V) == 0){
    80000ffa:	c509                	beqz	a0,80001004 <evict_page+0xbe>
    80000ffc:	611c                	ld	a5,0(a0)
    80000ffe:	89be                	mv	s3,a5
    80001000:	8b85                	andi	a5,a5,1
    80001002:	e799                	bnez	a5,80001010 <evict_page+0xca>
    release(&p->lock);
    80001004:	854a                	mv	a0,s2
    80001006:	190000ef          	jal	80001196 <release>
    return;
    8000100a:	69a2                	ld	s3,8(sp)
    8000100c:	6a02                	ld	s4,0(sp)
    8000100e:	bf69                	j	80000fa8 <evict_page+0x62>
  int swap_idx = swap_alloc();
    80001010:	474020ef          	jal	80003484 <swap_alloc>
  if(swap_idx < 0){
    80001014:	04054c63          	bltz	a0,8000106c <evict_page+0x126>
  uint64 pa = PTE2PA(*pte);
    80001018:	00a9d793          	srli	a5,s3,0xa
    8000101c:	00c79993          	slli	s3,a5,0xc
  swap_write(swap_idx, (char*)pa, p, va, p);
    80001020:	874a                	mv	a4,s2
    80001022:	86d2                	mv	a3,s4
    80001024:	864a                	mv	a2,s2
    80001026:	85ce                	mv	a1,s3
    80001028:	8a2a                	mv	s4,a0
    8000102a:	50e020ef          	jal	80003538 <swap_write>
  *pte = ((pte_t)swap_idx << PTE_SWAP_SHIFT) | PTE_SWAPPED;
    8000102e:	00aa1513          	slli	a0,s4,0xa
    80001032:	10056513          	ori	a0,a0,256
    80001036:	e088                	sd	a0,0(s1)
  kfree((void*)pa);
    80001038:	854e                	mv	a0,s3
    8000103a:	a23ff0ef          	jal	80000a5c <kfree>
  p->pages_evicted++;
    8000103e:	19492783          	lw	a5,404(s2)
    80001042:	2785                	addiw	a5,a5,1
    80001044:	18f92a23          	sw	a5,404(s2)
  p->pages_swapped_out++;
    80001048:	19c92783          	lw	a5,412(s2)
    8000104c:	2785                	addiw	a5,a5,1
    8000104e:	18f92e23          	sw	a5,412(s2)
  p->resident_pages--;
    80001052:	1a092783          	lw	a5,416(s2)
    80001056:	37fd                	addiw	a5,a5,-1
    80001058:	1af92023          	sw	a5,416(s2)
  release(&p->lock);
    8000105c:	854a                	mv	a0,s2
    8000105e:	138000ef          	jal	80001196 <release>
    80001062:	12000073          	sfence.vma
    80001066:	69a2                	ld	s3,8(sp)
    80001068:	6a02                	ld	s4,0(sp)
}
    8000106a:	bf3d                	j	80000fa8 <evict_page+0x62>
    release(&p->lock);
    8000106c:	854a                	mv	a0,s2
    8000106e:	128000ef          	jal	80001196 <release>
    return;
    80001072:	69a2                	ld	s3,8(sp)
    80001074:	6a02                	ld	s4,0(sp)
    80001076:	bf0d                	j	80000fa8 <evict_page+0x62>

0000000080001078 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80001078:	1141                	addi	sp,sp,-16
    8000107a:	e406                	sd	ra,8(sp)
    8000107c:	e022                	sd	s0,0(sp)
    8000107e:	0800                	addi	s0,sp,16
  lk->name = name;
    80001080:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80001082:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80001086:	00053823          	sd	zero,16(a0)
}
    8000108a:	60a2                	ld	ra,8(sp)
    8000108c:	6402                	ld	s0,0(sp)
    8000108e:	0141                	addi	sp,sp,16
    80001090:	8082                	ret

0000000080001092 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80001092:	411c                	lw	a5,0(a0)
    80001094:	e399                	bnez	a5,8000109a <holding+0x8>
    80001096:	4501                	li	a0,0
  return r;
}
    80001098:	8082                	ret
{
    8000109a:	1101                	addi	sp,sp,-32
    8000109c:	ec06                	sd	ra,24(sp)
    8000109e:	e822                	sd	s0,16(sp)
    800010a0:	e426                	sd	s1,8(sp)
    800010a2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800010a4:	691c                	ld	a5,16(a0)
    800010a6:	84be                	mv	s1,a5
    800010a8:	7a3000ef          	jal	8000204a <mycpu>
    800010ac:	40a48533          	sub	a0,s1,a0
    800010b0:	00153513          	seqz	a0,a0
}
    800010b4:	60e2                	ld	ra,24(sp)
    800010b6:	6442                	ld	s0,16(sp)
    800010b8:	64a2                	ld	s1,8(sp)
    800010ba:	6105                	addi	sp,sp,32
    800010bc:	8082                	ret

00000000800010be <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800010be:	1101                	addi	sp,sp,-32
    800010c0:	ec06                	sd	ra,24(sp)
    800010c2:	e822                	sd	s0,16(sp)
    800010c4:	e426                	sd	s1,8(sp)
    800010c6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800010c8:	100027f3          	csrr	a5,sstatus
    800010cc:	84be                	mv	s1,a5
    800010ce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800010d2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800010d4:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    800010d8:	773000ef          	jal	8000204a <mycpu>
    800010dc:	5d3c                	lw	a5,120(a0)
    800010de:	cb99                	beqz	a5,800010f4 <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800010e0:	76b000ef          	jal	8000204a <mycpu>
    800010e4:	5d3c                	lw	a5,120(a0)
    800010e6:	2785                	addiw	a5,a5,1
    800010e8:	dd3c                	sw	a5,120(a0)
}
    800010ea:	60e2                	ld	ra,24(sp)
    800010ec:	6442                	ld	s0,16(sp)
    800010ee:	64a2                	ld	s1,8(sp)
    800010f0:	6105                	addi	sp,sp,32
    800010f2:	8082                	ret
    mycpu()->intena = old;
    800010f4:	757000ef          	jal	8000204a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800010f8:	0014d793          	srli	a5,s1,0x1
    800010fc:	8b85                	andi	a5,a5,1
    800010fe:	dd7c                	sw	a5,124(a0)
    80001100:	b7c5                	j	800010e0 <push_off+0x22>

0000000080001102 <acquire>:
{
    80001102:	1101                	addi	sp,sp,-32
    80001104:	ec06                	sd	ra,24(sp)
    80001106:	e822                	sd	s0,16(sp)
    80001108:	e426                	sd	s1,8(sp)
    8000110a:	1000                	addi	s0,sp,32
    8000110c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000110e:	fb1ff0ef          	jal	800010be <push_off>
  if(holding(lk))
    80001112:	8526                	mv	a0,s1
    80001114:	f7fff0ef          	jal	80001092 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80001118:	4705                	li	a4,1
  if(holding(lk))
    8000111a:	e105                	bnez	a0,8000113a <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000111c:	87ba                	mv	a5,a4
    8000111e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80001122:	2781                	sext.w	a5,a5
    80001124:	ffe5                	bnez	a5,8000111c <acquire+0x1a>
  __sync_synchronize();
    80001126:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    8000112a:	721000ef          	jal	8000204a <mycpu>
    8000112e:	e888                	sd	a0,16(s1)
}
    80001130:	60e2                	ld	ra,24(sp)
    80001132:	6442                	ld	s0,16(sp)
    80001134:	64a2                	ld	s1,8(sp)
    80001136:	6105                	addi	sp,sp,32
    80001138:	8082                	ret
    panic("acquire");
    8000113a:	00008517          	auipc	a0,0x8
    8000113e:	f3650513          	addi	a0,a0,-202 # 80009070 <etext+0x70>
    80001142:	ee2ff0ef          	jal	80000824 <panic>

0000000080001146 <pop_off>:

void
pop_off(void)
{
    80001146:	1141                	addi	sp,sp,-16
    80001148:	e406                	sd	ra,8(sp)
    8000114a:	e022                	sd	s0,0(sp)
    8000114c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000114e:	6fd000ef          	jal	8000204a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001152:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001156:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001158:	e39d                	bnez	a5,8000117e <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000115a:	5d3c                	lw	a5,120(a0)
    8000115c:	02f05763          	blez	a5,8000118a <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80001160:	37fd                	addiw	a5,a5,-1
    80001162:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80001164:	eb89                	bnez	a5,80001176 <pop_off+0x30>
    80001166:	5d7c                	lw	a5,124(a0)
    80001168:	c799                	beqz	a5,80001176 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000116a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000116e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001172:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80001176:	60a2                	ld	ra,8(sp)
    80001178:	6402                	ld	s0,0(sp)
    8000117a:	0141                	addi	sp,sp,16
    8000117c:	8082                	ret
    panic("pop_off - interruptible");
    8000117e:	00008517          	auipc	a0,0x8
    80001182:	efa50513          	addi	a0,a0,-262 # 80009078 <etext+0x78>
    80001186:	e9eff0ef          	jal	80000824 <panic>
    panic("pop_off");
    8000118a:	00008517          	auipc	a0,0x8
    8000118e:	f0650513          	addi	a0,a0,-250 # 80009090 <etext+0x90>
    80001192:	e92ff0ef          	jal	80000824 <panic>

0000000080001196 <release>:
{
    80001196:	1101                	addi	sp,sp,-32
    80001198:	ec06                	sd	ra,24(sp)
    8000119a:	e822                	sd	s0,16(sp)
    8000119c:	e426                	sd	s1,8(sp)
    8000119e:	1000                	addi	s0,sp,32
    800011a0:	84aa                	mv	s1,a0
  if(!holding(lk))
    800011a2:	ef1ff0ef          	jal	80001092 <holding>
    800011a6:	c105                	beqz	a0,800011c6 <release+0x30>
  lk->cpu = 0;
    800011a8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800011ac:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800011b0:	0310000f          	fence	rw,w
    800011b4:	0004a023          	sw	zero,0(s1)
  pop_off();
    800011b8:	f8fff0ef          	jal	80001146 <pop_off>
}
    800011bc:	60e2                	ld	ra,24(sp)
    800011be:	6442                	ld	s0,16(sp)
    800011c0:	64a2                	ld	s1,8(sp)
    800011c2:	6105                	addi	sp,sp,32
    800011c4:	8082                	ret
    panic("release");
    800011c6:	00008517          	auipc	a0,0x8
    800011ca:	ed250513          	addi	a0,a0,-302 # 80009098 <etext+0x98>
    800011ce:	e56ff0ef          	jal	80000824 <panic>

00000000800011d2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800011d2:	1141                	addi	sp,sp,-16
    800011d4:	e406                	sd	ra,8(sp)
    800011d6:	e022                	sd	s0,0(sp)
    800011d8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800011da:	ca19                	beqz	a2,800011f0 <memset+0x1e>
    800011dc:	87aa                	mv	a5,a0
    800011de:	1602                	slli	a2,a2,0x20
    800011e0:	9201                	srli	a2,a2,0x20
    800011e2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800011e6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800011ea:	0785                	addi	a5,a5,1
    800011ec:	fee79de3          	bne	a5,a4,800011e6 <memset+0x14>
  }
  return dst;
}
    800011f0:	60a2                	ld	ra,8(sp)
    800011f2:	6402                	ld	s0,0(sp)
    800011f4:	0141                	addi	sp,sp,16
    800011f6:	8082                	ret

00000000800011f8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800011f8:	1141                	addi	sp,sp,-16
    800011fa:	e406                	sd	ra,8(sp)
    800011fc:	e022                	sd	s0,0(sp)
    800011fe:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80001200:	c61d                	beqz	a2,8000122e <memcmp+0x36>
    80001202:	1602                	slli	a2,a2,0x20
    80001204:	9201                	srli	a2,a2,0x20
    80001206:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    8000120a:	00054783          	lbu	a5,0(a0)
    8000120e:	0005c703          	lbu	a4,0(a1)
    80001212:	00e79863          	bne	a5,a4,80001222 <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80001216:	0505                	addi	a0,a0,1
    80001218:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000121a:	fed518e3          	bne	a0,a3,8000120a <memcmp+0x12>
  }

  return 0;
    8000121e:	4501                	li	a0,0
    80001220:	a019                	j	80001226 <memcmp+0x2e>
      return *s1 - *s2;
    80001222:	40e7853b          	subw	a0,a5,a4
}
    80001226:	60a2                	ld	ra,8(sp)
    80001228:	6402                	ld	s0,0(sp)
    8000122a:	0141                	addi	sp,sp,16
    8000122c:	8082                	ret
  return 0;
    8000122e:	4501                	li	a0,0
    80001230:	bfdd                	j	80001226 <memcmp+0x2e>

0000000080001232 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80001232:	1141                	addi	sp,sp,-16
    80001234:	e406                	sd	ra,8(sp)
    80001236:	e022                	sd	s0,0(sp)
    80001238:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    8000123a:	c205                	beqz	a2,8000125a <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000123c:	02a5e363          	bltu	a1,a0,80001262 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80001240:	1602                	slli	a2,a2,0x20
    80001242:	9201                	srli	a2,a2,0x20
    80001244:	00c587b3          	add	a5,a1,a2
{
    80001248:	872a                	mv	a4,a0
      *d++ = *s++;
    8000124a:	0585                	addi	a1,a1,1
    8000124c:	0705                	addi	a4,a4,1
    8000124e:	fff5c683          	lbu	a3,-1(a1)
    80001252:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80001256:	feb79ae3          	bne	a5,a1,8000124a <memmove+0x18>

  return dst;
}
    8000125a:	60a2                	ld	ra,8(sp)
    8000125c:	6402                	ld	s0,0(sp)
    8000125e:	0141                	addi	sp,sp,16
    80001260:	8082                	ret
  if(s < d && s + n > d){
    80001262:	02061693          	slli	a3,a2,0x20
    80001266:	9281                	srli	a3,a3,0x20
    80001268:	00d58733          	add	a4,a1,a3
    8000126c:	fce57ae3          	bgeu	a0,a4,80001240 <memmove+0xe>
    d += n;
    80001270:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80001272:	fff6079b          	addiw	a5,a2,-1
    80001276:	1782                	slli	a5,a5,0x20
    80001278:	9381                	srli	a5,a5,0x20
    8000127a:	fff7c793          	not	a5,a5
    8000127e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80001280:	177d                	addi	a4,a4,-1
    80001282:	16fd                	addi	a3,a3,-1
    80001284:	00074603          	lbu	a2,0(a4)
    80001288:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000128c:	fee79ae3          	bne	a5,a4,80001280 <memmove+0x4e>
    80001290:	b7e9                	j	8000125a <memmove+0x28>

0000000080001292 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80001292:	1141                	addi	sp,sp,-16
    80001294:	e406                	sd	ra,8(sp)
    80001296:	e022                	sd	s0,0(sp)
    80001298:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000129a:	f99ff0ef          	jal	80001232 <memmove>
}
    8000129e:	60a2                	ld	ra,8(sp)
    800012a0:	6402                	ld	s0,0(sp)
    800012a2:	0141                	addi	sp,sp,16
    800012a4:	8082                	ret

00000000800012a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800012a6:	1141                	addi	sp,sp,-16
    800012a8:	e406                	sd	ra,8(sp)
    800012aa:	e022                	sd	s0,0(sp)
    800012ac:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800012ae:	ce11                	beqz	a2,800012ca <strncmp+0x24>
    800012b0:	00054783          	lbu	a5,0(a0)
    800012b4:	cf89                	beqz	a5,800012ce <strncmp+0x28>
    800012b6:	0005c703          	lbu	a4,0(a1)
    800012ba:	00f71a63          	bne	a4,a5,800012ce <strncmp+0x28>
    n--, p++, q++;
    800012be:	367d                	addiw	a2,a2,-1
    800012c0:	0505                	addi	a0,a0,1
    800012c2:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800012c4:	f675                	bnez	a2,800012b0 <strncmp+0xa>
  if(n == 0)
    return 0;
    800012c6:	4501                	li	a0,0
    800012c8:	a801                	j	800012d8 <strncmp+0x32>
    800012ca:	4501                	li	a0,0
    800012cc:	a031                	j	800012d8 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    800012ce:	00054503          	lbu	a0,0(a0)
    800012d2:	0005c783          	lbu	a5,0(a1)
    800012d6:	9d1d                	subw	a0,a0,a5
}
    800012d8:	60a2                	ld	ra,8(sp)
    800012da:	6402                	ld	s0,0(sp)
    800012dc:	0141                	addi	sp,sp,16
    800012de:	8082                	ret

00000000800012e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800012e0:	1141                	addi	sp,sp,-16
    800012e2:	e406                	sd	ra,8(sp)
    800012e4:	e022                	sd	s0,0(sp)
    800012e6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800012e8:	87aa                	mv	a5,a0
    800012ea:	a011                	j	800012ee <strncpy+0xe>
    800012ec:	8636                	mv	a2,a3
    800012ee:	02c05863          	blez	a2,8000131e <strncpy+0x3e>
    800012f2:	fff6069b          	addiw	a3,a2,-1
    800012f6:	8836                	mv	a6,a3
    800012f8:	0785                	addi	a5,a5,1
    800012fa:	0005c703          	lbu	a4,0(a1)
    800012fe:	fee78fa3          	sb	a4,-1(a5)
    80001302:	0585                	addi	a1,a1,1
    80001304:	f765                	bnez	a4,800012ec <strncpy+0xc>
    ;
  while(n-- > 0)
    80001306:	873e                	mv	a4,a5
    80001308:	01005b63          	blez	a6,8000131e <strncpy+0x3e>
    8000130c:	9fb1                	addw	a5,a5,a2
    8000130e:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80001310:	0705                	addi	a4,a4,1
    80001312:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80001316:	40e786bb          	subw	a3,a5,a4
    8000131a:	fed04be3          	bgtz	a3,80001310 <strncpy+0x30>
  return os;
}
    8000131e:	60a2                	ld	ra,8(sp)
    80001320:	6402                	ld	s0,0(sp)
    80001322:	0141                	addi	sp,sp,16
    80001324:	8082                	ret

0000000080001326 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80001326:	1141                	addi	sp,sp,-16
    80001328:	e406                	sd	ra,8(sp)
    8000132a:	e022                	sd	s0,0(sp)
    8000132c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000132e:	02c05363          	blez	a2,80001354 <safestrcpy+0x2e>
    80001332:	fff6069b          	addiw	a3,a2,-1
    80001336:	1682                	slli	a3,a3,0x20
    80001338:	9281                	srli	a3,a3,0x20
    8000133a:	96ae                	add	a3,a3,a1
    8000133c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000133e:	00d58963          	beq	a1,a3,80001350 <safestrcpy+0x2a>
    80001342:	0585                	addi	a1,a1,1
    80001344:	0785                	addi	a5,a5,1
    80001346:	fff5c703          	lbu	a4,-1(a1)
    8000134a:	fee78fa3          	sb	a4,-1(a5)
    8000134e:	fb65                	bnez	a4,8000133e <safestrcpy+0x18>
    ;
  *s = 0;
    80001350:	00078023          	sb	zero,0(a5)
  return os;
}
    80001354:	60a2                	ld	ra,8(sp)
    80001356:	6402                	ld	s0,0(sp)
    80001358:	0141                	addi	sp,sp,16
    8000135a:	8082                	ret

000000008000135c <strlen>:

int
strlen(const char *s)
{
    8000135c:	1141                	addi	sp,sp,-16
    8000135e:	e406                	sd	ra,8(sp)
    80001360:	e022                	sd	s0,0(sp)
    80001362:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80001364:	00054783          	lbu	a5,0(a0)
    80001368:	cf91                	beqz	a5,80001384 <strlen+0x28>
    8000136a:	00150793          	addi	a5,a0,1
    8000136e:	86be                	mv	a3,a5
    80001370:	0785                	addi	a5,a5,1
    80001372:	fff7c703          	lbu	a4,-1(a5)
    80001376:	ff65                	bnez	a4,8000136e <strlen+0x12>
    80001378:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    8000137c:	60a2                	ld	ra,8(sp)
    8000137e:	6402                	ld	s0,0(sp)
    80001380:	0141                	addi	sp,sp,16
    80001382:	8082                	ret
  for(n = 0; s[n]; n++)
    80001384:	4501                	li	a0,0
    80001386:	bfdd                	j	8000137c <strlen+0x20>

0000000080001388 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80001388:	1141                	addi	sp,sp,-16
    8000138a:	e406                	sd	ra,8(sp)
    8000138c:	e022                	sd	s0,0(sp)
    8000138e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001390:	4a7000ef          	jal	80002036 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80001394:	00008717          	auipc	a4,0x8
    80001398:	74070713          	addi	a4,a4,1856 # 80009ad4 <started>
  if(cpuid() == 0){
    8000139c:	c51d                	beqz	a0,800013ca <main+0x42>
    while(started == 0)
    8000139e:	431c                	lw	a5,0(a4)
    800013a0:	2781                	sext.w	a5,a5
    800013a2:	dff5                	beqz	a5,8000139e <main+0x16>
      ;
    __sync_synchronize();
    800013a4:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800013a8:	48f000ef          	jal	80002036 <cpuid>
    800013ac:	85aa                	mv	a1,a0
    800013ae:	00008517          	auipc	a0,0x8
    800013b2:	d1250513          	addi	a0,a0,-750 # 800090c0 <etext+0xc0>
    800013b6:	944ff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    800013ba:	084000ef          	jal	8000143e <kvminithart>
    trapinithart();   // install kernel trap vector
    800013be:	299010ef          	jal	80002e56 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800013c2:	0f6050ef          	jal	800064b8 <plicinithart>
  }

  scheduler();        
    800013c6:	1e8010ef          	jal	800025ae <scheduler>
    consoleinit();
    800013ca:	856ff0ef          	jal	80000420 <consoleinit>
    printfinit();
    800013ce:	c92ff0ef          	jal	80000860 <printfinit>
    printf("\n");
    800013d2:	00008517          	auipc	a0,0x8
    800013d6:	cce50513          	addi	a0,a0,-818 # 800090a0 <etext+0xa0>
    800013da:	920ff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    800013de:	00008517          	auipc	a0,0x8
    800013e2:	cca50513          	addi	a0,a0,-822 # 800090a8 <etext+0xa8>
    800013e6:	914ff0ef          	jal	800004fa <printf>
    printf("\n");
    800013ea:	00008517          	auipc	a0,0x8
    800013ee:	cb650513          	addi	a0,a0,-842 # 800090a0 <etext+0xa0>
    800013f2:	908ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    800013f6:	f1aff0ef          	jal	80000b10 <kinit>
    swap_init();     //PA3 related implementation
    800013fa:	03a020ef          	jal	80003434 <swap_init>
    kvminit();       // create kernel page table
    800013fe:	2cc000ef          	jal	800016ca <kvminit>
    kvminithart();   // turn on paging
    80001402:	03c000ef          	jal	8000143e <kvminithart>
    procinit();      // process table
    80001406:	37b000ef          	jal	80001f80 <procinit>
    trapinit();      // trap vectors
    8000140a:	229010ef          	jal	80002e32 <trapinit>
    trapinithart();  // install kernel trap vector
    8000140e:	249010ef          	jal	80002e56 <trapinithart>
    plicinit();      // set up interrupt controller
    80001412:	08c050ef          	jal	8000649e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001416:	0a2050ef          	jal	800064b8 <plicinithart>
    binit();         // buffer cache
    8000141a:	70e020ef          	jal	80003b28 <binit>
    iinit();         // inode table
    8000141e:	465020ef          	jal	80004082 <iinit>
    fileinit();      // file table
    80001422:	391030ef          	jal	80004fb2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001426:	182050ef          	jal	800065a8 <virtio_disk_init>
    userinit();      // first user process
    8000142a:	7d7000ef          	jal	80002400 <userinit>
    __sync_synchronize();
    8000142e:	0330000f          	fence	rw,rw
    started = 1;
    80001432:	4785                	li	a5,1
    80001434:	00008717          	auipc	a4,0x8
    80001438:	6af72023          	sw	a5,1696(a4) # 80009ad4 <started>
    8000143c:	b769                	j	800013c6 <main+0x3e>

000000008000143e <kvminithart>:
  kernel_pagetable = kvmmake();
}

void
kvminithart()
{
    8000143e:	1141                	addi	sp,sp,-16
    80001440:	e406                	sd	ra,8(sp)
    80001442:	e022                	sd	s0,0(sp)
    80001444:	0800                	addi	s0,sp,16
  asm volatile("sfence.vma zero, zero");
    80001446:	12000073          	sfence.vma
  sfence_vma();
  w_satp(MAKE_SATP(kernel_pagetable));
    8000144a:	00008797          	auipc	a5,0x8
    8000144e:	68e7b783          	ld	a5,1678(a5) # 80009ad8 <kernel_pagetable>
    80001452:	83b1                	srli	a5,a5,0xc
    80001454:	577d                	li	a4,-1
    80001456:	177e                	slli	a4,a4,0x3f
    80001458:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000145a:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000145e:	12000073          	sfence.vma
  sfence_vma();
}
    80001462:	60a2                	ld	ra,8(sp)
    80001464:	6402                	ld	s0,0(sp)
    80001466:	0141                	addi	sp,sp,16
    80001468:	8082                	ret

000000008000146a <walk>:

pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000146a:	7139                	addi	sp,sp,-64
    8000146c:	fc06                	sd	ra,56(sp)
    8000146e:	f822                	sd	s0,48(sp)
    80001470:	f426                	sd	s1,40(sp)
    80001472:	f04a                	sd	s2,32(sp)
    80001474:	ec4e                	sd	s3,24(sp)
    80001476:	e852                	sd	s4,16(sp)
    80001478:	e456                	sd	s5,8(sp)
    8000147a:	e05a                	sd	s6,0(sp)
    8000147c:	0080                	addi	s0,sp,64
    8000147e:	84aa                	mv	s1,a0
    80001480:	89ae                	mv	s3,a1
    80001482:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80001484:	57fd                	li	a5,-1
    80001486:	83e9                	srli	a5,a5,0x1a
    80001488:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000148a:	4ab1                	li	s5,12
  if(va >= MAXVA)
    8000148c:	04b7e263          	bltu	a5,a1,800014d0 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80001490:	0149d933          	srl	s2,s3,s4
    80001494:	1ff97913          	andi	s2,s2,511
    80001498:	090e                	slli	s2,s2,0x3
    8000149a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000149c:	00093483          	ld	s1,0(s2)
    800014a0:	0014f793          	andi	a5,s1,1
    800014a4:	cf85                	beqz	a5,800014dc <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800014a6:	80a9                	srli	s1,s1,0xa
    800014a8:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    800014aa:	3a5d                	addiw	s4,s4,-9
    800014ac:	ff5a12e3          	bne	s4,s5,80001490 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    800014b0:	00c9d513          	srli	a0,s3,0xc
    800014b4:	1ff57513          	andi	a0,a0,511
    800014b8:	050e                	slli	a0,a0,0x3
    800014ba:	9526                	add	a0,a0,s1
}
    800014bc:	70e2                	ld	ra,56(sp)
    800014be:	7442                	ld	s0,48(sp)
    800014c0:	74a2                	ld	s1,40(sp)
    800014c2:	7902                	ld	s2,32(sp)
    800014c4:	69e2                	ld	s3,24(sp)
    800014c6:	6a42                	ld	s4,16(sp)
    800014c8:	6aa2                	ld	s5,8(sp)
    800014ca:	6b02                	ld	s6,0(sp)
    800014cc:	6121                	addi	sp,sp,64
    800014ce:	8082                	ret
    panic("walk");
    800014d0:	00008517          	auipc	a0,0x8
    800014d4:	c0850513          	addi	a0,a0,-1016 # 800090d8 <etext+0xd8>
    800014d8:	b4cff0ef          	jal	80000824 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800014dc:	020b0263          	beqz	s6,80001500 <walk+0x96>
    800014e0:	ea8ff0ef          	jal	80000b88 <kalloc>
    800014e4:	84aa                	mv	s1,a0
    800014e6:	d979                	beqz	a0,800014bc <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800014e8:	6605                	lui	a2,0x1
    800014ea:	4581                	li	a1,0
    800014ec:	ce7ff0ef          	jal	800011d2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800014f0:	00c4d793          	srli	a5,s1,0xc
    800014f4:	07aa                	slli	a5,a5,0xa
    800014f6:	0017e793          	ori	a5,a5,1
    800014fa:	00f93023          	sd	a5,0(s2)
    800014fe:	b775                	j	800014aa <walk+0x40>
        return 0;
    80001500:	4501                	li	a0,0
    80001502:	bf6d                	j	800014bc <walk+0x52>

0000000080001504 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001504:	57fd                	li	a5,-1
    80001506:	83e9                	srli	a5,a5,0x1a
    80001508:	00b7f463          	bgeu	a5,a1,80001510 <walkaddr+0xc>
    return 0;
    8000150c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000150e:	8082                	ret
{
    80001510:	1141                	addi	sp,sp,-16
    80001512:	e406                	sd	ra,8(sp)
    80001514:	e022                	sd	s0,0(sp)
    80001516:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001518:	4601                	li	a2,0
    8000151a:	f51ff0ef          	jal	8000146a <walk>
  if(pte == 0)
    8000151e:	c901                	beqz	a0,8000152e <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    80001520:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001522:	0117f693          	andi	a3,a5,17
    80001526:	4745                	li	a4,17
    return 0;
    80001528:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000152a:	00e68663          	beq	a3,a4,80001536 <walkaddr+0x32>
}
    8000152e:	60a2                	ld	ra,8(sp)
    80001530:	6402                	ld	s0,0(sp)
    80001532:	0141                	addi	sp,sp,16
    80001534:	8082                	ret
  pa = PTE2PA(*pte);
    80001536:	83a9                	srli	a5,a5,0xa
    80001538:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000153c:	bfcd                	j	8000152e <walkaddr+0x2a>

000000008000153e <mappages>:

int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000153e:	715d                	addi	sp,sp,-80
    80001540:	e486                	sd	ra,72(sp)
    80001542:	e0a2                	sd	s0,64(sp)
    80001544:	fc26                	sd	s1,56(sp)
    80001546:	f84a                	sd	s2,48(sp)
    80001548:	f44e                	sd	s3,40(sp)
    8000154a:	f052                	sd	s4,32(sp)
    8000154c:	ec56                	sd	s5,24(sp)
    8000154e:	e85a                	sd	s6,16(sp)
    80001550:	e45e                	sd	s7,8(sp)
    80001552:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001554:	03459793          	slli	a5,a1,0x34
    80001558:	eba1                	bnez	a5,800015a8 <mappages+0x6a>
    8000155a:	8a2a                	mv	s4,a0
    8000155c:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");
  if((size % PGSIZE) != 0)
    8000155e:	03461793          	slli	a5,a2,0x34
    80001562:	eba9                	bnez	a5,800015b4 <mappages+0x76>
    panic("mappages: size not aligned");
  if(size == 0)
    80001564:	ce31                	beqz	a2,800015c0 <mappages+0x82>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    80001566:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    8000156a:	80060613          	addi	a2,a2,-2048
    8000156e:	00b60933          	add	s2,a2,a1
  a = va;
    80001572:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001574:	4b05                	li	s6,1
    80001576:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000157a:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    8000157c:	865a                	mv	a2,s6
    8000157e:	85a6                	mv	a1,s1
    80001580:	8552                	mv	a0,s4
    80001582:	ee9ff0ef          	jal	8000146a <walk>
    80001586:	c929                	beqz	a0,800015d8 <mappages+0x9a>
    if(*pte & PTE_V)
    80001588:	611c                	ld	a5,0(a0)
    8000158a:	8b85                	andi	a5,a5,1
    8000158c:	e3a1                	bnez	a5,800015cc <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000158e:	013487b3          	add	a5,s1,s3
    80001592:	83b1                	srli	a5,a5,0xc
    80001594:	07aa                	slli	a5,a5,0xa
    80001596:	0157e7b3          	or	a5,a5,s5
    8000159a:	0017e793          	ori	a5,a5,1
    8000159e:	e11c                	sd	a5,0(a0)
    if(a == last)
    800015a0:	05248863          	beq	s1,s2,800015f0 <mappages+0xb2>
    a += PGSIZE;
    800015a4:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800015a6:	bfd9                	j	8000157c <mappages+0x3e>
    panic("mappages: va not aligned");
    800015a8:	00008517          	auipc	a0,0x8
    800015ac:	b3850513          	addi	a0,a0,-1224 # 800090e0 <etext+0xe0>
    800015b0:	a74ff0ef          	jal	80000824 <panic>
    panic("mappages: size not aligned");
    800015b4:	00008517          	auipc	a0,0x8
    800015b8:	b4c50513          	addi	a0,a0,-1204 # 80009100 <etext+0x100>
    800015bc:	a68ff0ef          	jal	80000824 <panic>
    panic("mappages: size");
    800015c0:	00008517          	auipc	a0,0x8
    800015c4:	b6050513          	addi	a0,a0,-1184 # 80009120 <etext+0x120>
    800015c8:	a5cff0ef          	jal	80000824 <panic>
      panic("mappages: remap");
    800015cc:	00008517          	auipc	a0,0x8
    800015d0:	b6450513          	addi	a0,a0,-1180 # 80009130 <etext+0x130>
    800015d4:	a50ff0ef          	jal	80000824 <panic>
      return -1;
    800015d8:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800015da:	60a6                	ld	ra,72(sp)
    800015dc:	6406                	ld	s0,64(sp)
    800015de:	74e2                	ld	s1,56(sp)
    800015e0:	7942                	ld	s2,48(sp)
    800015e2:	79a2                	ld	s3,40(sp)
    800015e4:	7a02                	ld	s4,32(sp)
    800015e6:	6ae2                	ld	s5,24(sp)
    800015e8:	6b42                	ld	s6,16(sp)
    800015ea:	6ba2                	ld	s7,8(sp)
    800015ec:	6161                	addi	sp,sp,80
    800015ee:	8082                	ret
  return 0;
    800015f0:	4501                	li	a0,0
    800015f2:	b7e5                	j	800015da <mappages+0x9c>

00000000800015f4 <kvmmap>:
{
    800015f4:	1141                	addi	sp,sp,-16
    800015f6:	e406                	sd	ra,8(sp)
    800015f8:	e022                	sd	s0,0(sp)
    800015fa:	0800                	addi	s0,sp,16
    800015fc:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800015fe:	86b2                	mv	a3,a2
    80001600:	863e                	mv	a2,a5
    80001602:	f3dff0ef          	jal	8000153e <mappages>
    80001606:	e509                	bnez	a0,80001610 <kvmmap+0x1c>
}
    80001608:	60a2                	ld	ra,8(sp)
    8000160a:	6402                	ld	s0,0(sp)
    8000160c:	0141                	addi	sp,sp,16
    8000160e:	8082                	ret
    panic("kvmmap");
    80001610:	00008517          	auipc	a0,0x8
    80001614:	b3050513          	addi	a0,a0,-1232 # 80009140 <etext+0x140>
    80001618:	a0cff0ef          	jal	80000824 <panic>

000000008000161c <kvmmake>:
{
    8000161c:	1101                	addi	sp,sp,-32
    8000161e:	ec06                	sd	ra,24(sp)
    80001620:	e822                	sd	s0,16(sp)
    80001622:	e426                	sd	s1,8(sp)
    80001624:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001626:	d62ff0ef          	jal	80000b88 <kalloc>
    8000162a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000162c:	6605                	lui	a2,0x1
    8000162e:	4581                	li	a1,0
    80001630:	ba3ff0ef          	jal	800011d2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001634:	4719                	li	a4,6
    80001636:	6685                	lui	a3,0x1
    80001638:	10000637          	lui	a2,0x10000
    8000163c:	85b2                	mv	a1,a2
    8000163e:	8526                	mv	a0,s1
    80001640:	fb5ff0ef          	jal	800015f4 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001644:	4719                	li	a4,6
    80001646:	6685                	lui	a3,0x1
    80001648:	10001637          	lui	a2,0x10001
    8000164c:	85b2                	mv	a1,a2
    8000164e:	8526                	mv	a0,s1
    80001650:	fa5ff0ef          	jal	800015f4 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001654:	4719                	li	a4,6
    80001656:	040006b7          	lui	a3,0x4000
    8000165a:	0c000637          	lui	a2,0xc000
    8000165e:	85b2                	mv	a1,a2
    80001660:	8526                	mv	a0,s1
    80001662:	f93ff0ef          	jal	800015f4 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001666:	4729                	li	a4,10
    80001668:	80008697          	auipc	a3,0x80008
    8000166c:	99868693          	addi	a3,a3,-1640 # 9000 <_entry-0x7fff7000>
    80001670:	4605                	li	a2,1
    80001672:	067e                	slli	a2,a2,0x1f
    80001674:	85b2                	mv	a1,a2
    80001676:	8526                	mv	a0,s1
    80001678:	f7dff0ef          	jal	800015f4 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000167c:	4719                	li	a4,6
    8000167e:	00008697          	auipc	a3,0x8
    80001682:	98268693          	addi	a3,a3,-1662 # 80009000 <etext>
    80001686:	47c5                	li	a5,17
    80001688:	07ee                	slli	a5,a5,0x1b
    8000168a:	40d786b3          	sub	a3,a5,a3
    8000168e:	00008617          	auipc	a2,0x8
    80001692:	97260613          	addi	a2,a2,-1678 # 80009000 <etext>
    80001696:	85b2                	mv	a1,a2
    80001698:	8526                	mv	a0,s1
    8000169a:	f5bff0ef          	jal	800015f4 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000169e:	4729                	li	a4,10
    800016a0:	6685                	lui	a3,0x1
    800016a2:	00007617          	auipc	a2,0x7
    800016a6:	95e60613          	addi	a2,a2,-1698 # 80008000 <_trampoline>
    800016aa:	040005b7          	lui	a1,0x4000
    800016ae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800016b0:	05b2                	slli	a1,a1,0xc
    800016b2:	8526                	mv	a0,s1
    800016b4:	f41ff0ef          	jal	800015f4 <kvmmap>
  proc_mapstacks(kpgtbl);
    800016b8:	8526                	mv	a0,s1
    800016ba:	023000ef          	jal	80001edc <proc_mapstacks>
}
    800016be:	8526                	mv	a0,s1
    800016c0:	60e2                	ld	ra,24(sp)
    800016c2:	6442                	ld	s0,16(sp)
    800016c4:	64a2                	ld	s1,8(sp)
    800016c6:	6105                	addi	sp,sp,32
    800016c8:	8082                	ret

00000000800016ca <kvminit>:
{
    800016ca:	1141                	addi	sp,sp,-16
    800016cc:	e406                	sd	ra,8(sp)
    800016ce:	e022                	sd	s0,0(sp)
    800016d0:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800016d2:	f4bff0ef          	jal	8000161c <kvmmake>
    800016d6:	00008797          	auipc	a5,0x8
    800016da:	40a7b123          	sd	a0,1026(a5) # 80009ad8 <kernel_pagetable>
}
    800016de:	60a2                	ld	ra,8(sp)
    800016e0:	6402                	ld	s0,0(sp)
    800016e2:	0141                	addi	sp,sp,16
    800016e4:	8082                	ret

00000000800016e6 <uvmcreate>:

pagetable_t
uvmcreate()
{
    800016e6:	1101                	addi	sp,sp,-32
    800016e8:	ec06                	sd	ra,24(sp)
    800016ea:	e822                	sd	s0,16(sp)
    800016ec:	e426                	sd	s1,8(sp)
    800016ee:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800016f0:	c98ff0ef          	jal	80000b88 <kalloc>
    800016f4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800016f6:	c509                	beqz	a0,80001700 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800016f8:	6605                	lui	a2,0x1
    800016fa:	4581                	li	a1,0
    800016fc:	ad7ff0ef          	jal	800011d2 <memset>
  return pagetable;
}
    80001700:	8526                	mv	a0,s1
    80001702:	60e2                	ld	ra,24(sp)
    80001704:	6442                	ld	s0,16(sp)
    80001706:	64a2                	ld	s1,8(sp)
    80001708:	6105                	addi	sp,sp,32
    8000170a:	8082                	ret

000000008000170c <uvmunmap>:
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000170c:	715d                	addi	sp,sp,-80
    8000170e:	e486                	sd	ra,72(sp)
    80001710:	e0a2                	sd	s0,64(sp)
    80001712:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001714:	03459793          	slli	a5,a1,0x34
    80001718:	e38d                	bnez	a5,8000173a <uvmunmap+0x2e>
    8000171a:	f84a                	sd	s2,48(sp)
    8000171c:	f052                	sd	s4,32(sp)
    8000171e:	ec56                	sd	s5,24(sp)
    80001720:	e85a                	sd	s6,16(sp)
    80001722:	e45e                	sd	s7,8(sp)
    80001724:	8aaa                	mv	s5,a0
    80001726:	892e                	mv	s2,a1
    80001728:	8bb6                	mv	s7,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000172a:	0632                	slli	a2,a2,0xc
    8000172c:	00b60a33          	add	s4,a2,a1
    80001730:	6b05                	lui	s6,0x1
    80001732:	0d45f763          	bgeu	a1,s4,80001800 <uvmunmap+0xf4>
    80001736:	fc26                	sd	s1,56(sp)
    80001738:	a049                	j	800017ba <uvmunmap+0xae>
    8000173a:	fc26                	sd	s1,56(sp)
    8000173c:	f84a                	sd	s2,48(sp)
    8000173e:	f44e                	sd	s3,40(sp)
    80001740:	f052                	sd	s4,32(sp)
    80001742:	ec56                	sd	s5,24(sp)
    80001744:	e85a                	sd	s6,16(sp)
    80001746:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001748:	00008517          	auipc	a0,0x8
    8000174c:	a0050513          	addi	a0,a0,-1536 # 80009148 <etext+0x148>
    80001750:	8d4ff0ef          	jal	80000824 <panic>
    if((pte = walk(pagetable, a, 0)) == 0)
      continue;

    if(*pte & PTE_SWAPPED){
      int swap_idx = (*pte >> PTE_SWAP_SHIFT) & 0xFF;
    80001754:	83a9                	srli	a5,a5,0xa
      swap_free(swap_idx);
    80001756:	0ff7f513          	zext.b	a0,a5
    8000175a:	597010ef          	jal	800034f0 <swap_free>
      *pte = 0;
    8000175e:	0004b023          	sd	zero,0(s1)
      continue;
    80001762:	a889                	j	800017b4 <uvmunmap+0xa8>
    if(do_free){
      uint64 pa = PTE2PA(*pte);

      // ── Remove from frame table ──────────────────────
      acquire(&frame_lock);
      for(int i = 0; i < MAX_FRAMES; i++){
    80001764:	2705                	addiw	a4,a4,1
    80001766:	02878793          	addi	a5,a5,40
    8000176a:	02c70963          	beq	a4,a2,8000179c <uvmunmap+0x90>
        if(frame_table[i].used && frame_table[i].pa == pa){
    8000176e:	4394                	lw	a3,0(a5)
    80001770:	daf5                	beqz	a3,80001764 <uvmunmap+0x58>
    80001772:	6f94                	ld	a3,24(a5)
    80001774:	ff3698e3          	bne	a3,s3,80001764 <uvmunmap+0x58>
          frame_table[i].used = 0;
    80001778:	00010617          	auipc	a2,0x10
    8000177c:	4b860613          	addi	a2,a2,1208 # 80011c30 <frame_table>
    80001780:	00271693          	slli	a3,a4,0x2
    80001784:	00e687b3          	add	a5,a3,a4
    80001788:	078e                	slli	a5,a5,0x3
    8000178a:	97b2                	add	a5,a5,a2
    8000178c:	0007a023          	sw	zero,0(a5)
          frame_table[i].proc = 0;
    80001790:	0007b423          	sd	zero,8(a5)
          frame_table[i].pa   = 0;
    80001794:	0007bc23          	sd	zero,24(a5)
          frame_table[i].va   = 0;
    80001798:	0007b823          	sd	zero,16(a5)
          break;
        }
      }
      release(&frame_lock);
    8000179c:	00010517          	auipc	a0,0x10
    800017a0:	47c50513          	addi	a0,a0,1148 # 80011c18 <frame_lock>
    800017a4:	9f3ff0ef          	jal	80001196 <release>
      // ─────────────────────────────────────────────────

      kfree((void*)pa);
    800017a8:	854e                	mv	a0,s3
    800017aa:	ab2ff0ef          	jal	80000a5c <kfree>
    800017ae:	79a2                	ld	s3,40(sp)
    }
    *pte = 0;
    800017b0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800017b4:	995a                	add	s2,s2,s6
    800017b6:	05497463          	bgeu	s2,s4,800017fe <uvmunmap+0xf2>
    if((pte = walk(pagetable, a, 0)) == 0)
    800017ba:	4601                	li	a2,0
    800017bc:	85ca                	mv	a1,s2
    800017be:	8556                	mv	a0,s5
    800017c0:	cabff0ef          	jal	8000146a <walk>
    800017c4:	84aa                	mv	s1,a0
    800017c6:	d57d                	beqz	a0,800017b4 <uvmunmap+0xa8>
    if(*pte & PTE_SWAPPED){
    800017c8:	611c                	ld	a5,0(a0)
    800017ca:	1007f713          	andi	a4,a5,256
    800017ce:	f359                	bnez	a4,80001754 <uvmunmap+0x48>
    if((*pte & PTE_V) == 0)
    800017d0:	0017f713          	andi	a4,a5,1
    800017d4:	d365                	beqz	a4,800017b4 <uvmunmap+0xa8>
    if(do_free){
    800017d6:	fc0b8de3          	beqz	s7,800017b0 <uvmunmap+0xa4>
    800017da:	f44e                	sd	s3,40(sp)
      uint64 pa = PTE2PA(*pte);
    800017dc:	83a9                	srli	a5,a5,0xa
    800017de:	00c79993          	slli	s3,a5,0xc
      acquire(&frame_lock);
    800017e2:	00010517          	auipc	a0,0x10
    800017e6:	43650513          	addi	a0,a0,1078 # 80011c18 <frame_lock>
    800017ea:	919ff0ef          	jal	80001102 <acquire>
      for(int i = 0; i < MAX_FRAMES; i++){
    800017ee:	00010797          	auipc	a5,0x10
    800017f2:	44278793          	addi	a5,a5,1090 # 80011c30 <frame_table>
    800017f6:	4701                	li	a4,0
    800017f8:	02000613          	li	a2,32
    800017fc:	bf8d                	j	8000176e <uvmunmap+0x62>
    800017fe:	74e2                	ld	s1,56(sp)
    80001800:	7942                	ld	s2,48(sp)
    80001802:	7a02                	ld	s4,32(sp)
    80001804:	6ae2                	ld	s5,24(sp)
    80001806:	6b42                	ld	s6,16(sp)
    80001808:	6ba2                	ld	s7,8(sp)
  }
}
    8000180a:	60a6                	ld	ra,72(sp)
    8000180c:	6406                	ld	s0,64(sp)
    8000180e:	6161                	addi	sp,sp,80
    80001810:	8082                	ret

0000000080001812 <uvmdealloc>:
  return newsz;
}

uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001812:	715d                	addi	sp,sp,-80
    80001814:	e486                	sd	ra,72(sp)
    80001816:	e0a2                	sd	s0,64(sp)
    80001818:	fc26                	sd	s1,56(sp)
    8000181a:	f84a                	sd	s2,48(sp)
    8000181c:	e45e                	sd	s7,8(sp)
    8000181e:	0880                	addi	s0,sp,80
    80001820:	8baa                	mv	s7,a0
    80001822:	84ae                	mv	s1,a1
    80001824:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80001826:	045000ef          	jal	8000206a <myproc>

  if(newsz >= oldsz)
    8000182a:	06997e63          	bgeu	s2,s1,800018a6 <uvmdealloc+0x94>
    8000182e:	f44e                	sd	s3,40(sp)
    80001830:	f052                	sd	s4,32(sp)
    80001832:	ec56                	sd	s5,24(sp)
    80001834:	8a2a                	mv	s4,a0
    return oldsz;

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001836:	6785                	lui	a5,0x1
    80001838:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000183a:	00f90ab3          	add	s5,s2,a5
    8000183e:	79fd                	lui	s3,0xfffff
    80001840:	013afab3          	and	s5,s5,s3
    80001844:	94be                	add	s1,s1,a5
    80001846:	0134f9b3          	and	s3,s1,s3
    }

    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
    8000184a:	854a                	mv	a0,s2
  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000184c:	073af563          	bgeu	s5,s3,800018b6 <uvmdealloc+0xa4>
    80001850:	e062                	sd	s8,0(sp)
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001852:	415987b3          	sub	a5,s3,s5
    80001856:	83b1                	srli	a5,a5,0xc
    80001858:	2781                	sext.w	a5,a5
    8000185a:	8c3e                	mv	s8,a5
    if(p){
    8000185c:	020a0963          	beqz	s4,8000188e <uvmdealloc+0x7c>
    80001860:	e85a                	sd	s6,16(sp)
      for(a = PGROUNDUP(newsz); a < PGROUNDUP(oldsz); a += PGSIZE){
    80001862:	84d6                	mv	s1,s5
    80001864:	6b05                	lui	s6,0x1
    80001866:	a021                	j	8000186e <uvmdealloc+0x5c>
    80001868:	94da                	add	s1,s1,s6
    8000186a:	0334f163          	bgeu	s1,s3,8000188c <uvmdealloc+0x7a>
        if((pte = walk(pagetable, a, 0)) != 0){
    8000186e:	4601                	li	a2,0
    80001870:	85a6                	mv	a1,s1
    80001872:	855e                	mv	a0,s7
    80001874:	bf7ff0ef          	jal	8000146a <walk>
    80001878:	d965                	beqz	a0,80001868 <uvmdealloc+0x56>
          if(*pte & PTE_V)
    8000187a:	611c                	ld	a5,0(a0)
    8000187c:	8b85                	andi	a5,a5,1
    8000187e:	d7ed                	beqz	a5,80001868 <uvmdealloc+0x56>
            p->resident_pages--;
    80001880:	1a0a2783          	lw	a5,416(s4)
    80001884:	37fd                	addiw	a5,a5,-1
    80001886:	1afa2023          	sw	a5,416(s4)
    8000188a:	bff9                	j	80001868 <uvmdealloc+0x56>
    8000188c:	6b42                	ld	s6,16(sp)
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000188e:	4685                	li	a3,1
    80001890:	8662                	mv	a2,s8
    80001892:	85d6                	mv	a1,s5
    80001894:	855e                	mv	a0,s7
    80001896:	e77ff0ef          	jal	8000170c <uvmunmap>
  return newsz;
    8000189a:	854a                	mv	a0,s2
    8000189c:	79a2                	ld	s3,40(sp)
    8000189e:	7a02                	ld	s4,32(sp)
    800018a0:	6ae2                	ld	s5,24(sp)
    800018a2:	6c02                	ld	s8,0(sp)
    800018a4:	a011                	j	800018a8 <uvmdealloc+0x96>
    return oldsz;
    800018a6:	8526                	mv	a0,s1
}
    800018a8:	60a6                	ld	ra,72(sp)
    800018aa:	6406                	ld	s0,64(sp)
    800018ac:	74e2                	ld	s1,56(sp)
    800018ae:	7942                	ld	s2,48(sp)
    800018b0:	6ba2                	ld	s7,8(sp)
    800018b2:	6161                	addi	sp,sp,80
    800018b4:	8082                	ret
    800018b6:	79a2                	ld	s3,40(sp)
    800018b8:	7a02                	ld	s4,32(sp)
    800018ba:	6ae2                	ld	s5,24(sp)
    800018bc:	b7f5                	j	800018a8 <uvmdealloc+0x96>

00000000800018be <uvmalloc>:
  if(newsz < oldsz)
    800018be:	0ab66463          	bltu	a2,a1,80001966 <uvmalloc+0xa8>
{
    800018c2:	715d                	addi	sp,sp,-80
    800018c4:	e486                	sd	ra,72(sp)
    800018c6:	e0a2                	sd	s0,64(sp)
    800018c8:	f84a                	sd	s2,48(sp)
    800018ca:	f052                	sd	s4,32(sp)
    800018cc:	ec56                	sd	s5,24(sp)
    800018ce:	e45e                	sd	s7,8(sp)
    800018d0:	0880                	addi	s0,sp,80
    800018d2:	8aaa                	mv	s5,a0
    800018d4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800018d6:	6785                	lui	a5,0x1
    800018d8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800018da:	95be                	add	a1,a1,a5
    800018dc:	77fd                	lui	a5,0xfffff
    800018de:	00f5f933          	and	s2,a1,a5
    800018e2:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    800018e4:	08c97363          	bgeu	s2,a2,8000196a <uvmalloc+0xac>
    800018e8:	fc26                	sd	s1,56(sp)
    800018ea:	f44e                	sd	s3,40(sp)
    800018ec:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    800018ee:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800018f0:	0126eb13          	ori	s6,a3,18
    struct proc *p = myproc();
    800018f4:	776000ef          	jal	8000206a <myproc>
    mem = kalloc_user(p, a);
    800018f8:	85ca                	mv	a1,s2
    800018fa:	ae8ff0ef          	jal	80000be2 <kalloc_user>
    800018fe:	84aa                	mv	s1,a0
    if(mem == 0){
    80001900:	c50d                	beqz	a0,8000192a <uvmalloc+0x6c>
    memset(mem, 0, PGSIZE);
    80001902:	864e                	mv	a2,s3
    80001904:	4581                	li	a1,0
    80001906:	8cdff0ef          	jal	800011d2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000190a:	875a                	mv	a4,s6
    8000190c:	86a6                	mv	a3,s1
    8000190e:	864e                	mv	a2,s3
    80001910:	85ca                	mv	a1,s2
    80001912:	8556                	mv	a0,s5
    80001914:	c2bff0ef          	jal	8000153e <mappages>
    80001918:	e915                	bnez	a0,8000194c <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000191a:	994e                	add	s2,s2,s3
    8000191c:	fd496ce3          	bltu	s2,s4,800018f4 <uvmalloc+0x36>
  return newsz;
    80001920:	8552                	mv	a0,s4
    80001922:	74e2                	ld	s1,56(sp)
    80001924:	79a2                	ld	s3,40(sp)
    80001926:	6b42                	ld	s6,16(sp)
    80001928:	a811                	j	8000193c <uvmalloc+0x7e>
      uvmdealloc(pagetable, a, oldsz);
    8000192a:	865e                	mv	a2,s7
    8000192c:	85ca                	mv	a1,s2
    8000192e:	8556                	mv	a0,s5
    80001930:	ee3ff0ef          	jal	80001812 <uvmdealloc>
      return 0;
    80001934:	4501                	li	a0,0
    80001936:	74e2                	ld	s1,56(sp)
    80001938:	79a2                	ld	s3,40(sp)
    8000193a:	6b42                	ld	s6,16(sp)
}
    8000193c:	60a6                	ld	ra,72(sp)
    8000193e:	6406                	ld	s0,64(sp)
    80001940:	7942                	ld	s2,48(sp)
    80001942:	7a02                	ld	s4,32(sp)
    80001944:	6ae2                	ld	s5,24(sp)
    80001946:	6ba2                	ld	s7,8(sp)
    80001948:	6161                	addi	sp,sp,80
    8000194a:	8082                	ret
      kfree(mem);
    8000194c:	8526                	mv	a0,s1
    8000194e:	90eff0ef          	jal	80000a5c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001952:	865e                	mv	a2,s7
    80001954:	85ca                	mv	a1,s2
    80001956:	8556                	mv	a0,s5
    80001958:	ebbff0ef          	jal	80001812 <uvmdealloc>
      return 0;
    8000195c:	4501                	li	a0,0
    8000195e:	74e2                	ld	s1,56(sp)
    80001960:	79a2                	ld	s3,40(sp)
    80001962:	6b42                	ld	s6,16(sp)
    80001964:	bfe1                	j	8000193c <uvmalloc+0x7e>
    return oldsz;
    80001966:	852e                	mv	a0,a1
}
    80001968:	8082                	ret
  return newsz;
    8000196a:	8532                	mv	a0,a2
    8000196c:	bfc1                	j	8000193c <uvmalloc+0x7e>

000000008000196e <freewalk>:

void
freewalk(pagetable_t pagetable)
{
    8000196e:	7179                	addi	sp,sp,-48
    80001970:	f406                	sd	ra,40(sp)
    80001972:	f022                	sd	s0,32(sp)
    80001974:	ec26                	sd	s1,24(sp)
    80001976:	e84a                	sd	s2,16(sp)
    80001978:	e44e                	sd	s3,8(sp)
    8000197a:	1800                	addi	s0,sp,48
    8000197c:	89aa                	mv	s3,a0
  for(int i = 0; i < 512; i++){
    8000197e:	84aa                	mv	s1,a0
    80001980:	6905                	lui	s2,0x1
    80001982:	992a                	add	s2,s2,a0
    80001984:	a811                	j	80001998 <freewalk+0x2a>
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    80001986:	00007517          	auipc	a0,0x7
    8000198a:	7da50513          	addi	a0,a0,2010 # 80009160 <etext+0x160>
    8000198e:	e97fe0ef          	jal	80000824 <panic>
  for(int i = 0; i < 512; i++){
    80001992:	04a1                	addi	s1,s1,8
    80001994:	03248163          	beq	s1,s2,800019b6 <freewalk+0x48>
    pte_t pte = pagetable[i];
    80001998:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000199a:	0017f713          	andi	a4,a5,1
    8000199e:	db75                	beqz	a4,80001992 <freewalk+0x24>
    800019a0:	00e7f713          	andi	a4,a5,14
    800019a4:	f36d                	bnez	a4,80001986 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800019a6:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800019a8:	00c79513          	slli	a0,a5,0xc
    800019ac:	fc3ff0ef          	jal	8000196e <freewalk>
      pagetable[i] = 0;
    800019b0:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800019b4:	bff9                	j	80001992 <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    800019b6:	854e                	mv	a0,s3
    800019b8:	8a4ff0ef          	jal	80000a5c <kfree>
}
    800019bc:	70a2                	ld	ra,40(sp)
    800019be:	7402                	ld	s0,32(sp)
    800019c0:	64e2                	ld	s1,24(sp)
    800019c2:	6942                	ld	s2,16(sp)
    800019c4:	69a2                	ld	s3,8(sp)
    800019c6:	6145                	addi	sp,sp,48
    800019c8:	8082                	ret

00000000800019ca <uvmfree>:

void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800019ca:	1101                	addi	sp,sp,-32
    800019cc:	ec06                	sd	ra,24(sp)
    800019ce:	e822                	sd	s0,16(sp)
    800019d0:	e426                	sd	s1,8(sp)
    800019d2:	1000                	addi	s0,sp,32
    800019d4:	84aa                	mv	s1,a0
  if(sz > 0)
    800019d6:	e989                	bnez	a1,800019e8 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800019d8:	8526                	mv	a0,s1
    800019da:	f95ff0ef          	jal	8000196e <freewalk>
}
    800019de:	60e2                	ld	ra,24(sp)
    800019e0:	6442                	ld	s0,16(sp)
    800019e2:	64a2                	ld	s1,8(sp)
    800019e4:	6105                	addi	sp,sp,32
    800019e6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800019e8:	6785                	lui	a5,0x1
    800019ea:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800019ec:	95be                	add	a1,a1,a5
    800019ee:	4685                	li	a3,1
    800019f0:	00c5d613          	srli	a2,a1,0xc
    800019f4:	4581                	li	a1,0
    800019f6:	d17ff0ef          	jal	8000170c <uvmunmap>
    800019fa:	bff9                	j	800019d8 <uvmfree+0xe>

00000000800019fc <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800019fc:	10060863          	beqz	a2,80001b0c <uvmcopy+0x110>
{
    80001a00:	7159                	addi	sp,sp,-112
    80001a02:	f486                	sd	ra,104(sp)
    80001a04:	f0a2                	sd	s0,96(sp)
    80001a06:	eca6                	sd	s1,88(sp)
    80001a08:	e8ca                	sd	s2,80(sp)
    80001a0a:	e4ce                	sd	s3,72(sp)
    80001a0c:	e0d2                	sd	s4,64(sp)
    80001a0e:	fc56                	sd	s5,56(sp)
    80001a10:	f85a                	sd	s6,48(sp)
    80001a12:	f45e                	sd	s7,40(sp)
    80001a14:	f062                	sd	s8,32(sp)
    80001a16:	ec66                	sd	s9,24(sp)
    80001a18:	e86a                	sd	s10,16(sp)
    80001a1a:	e46e                	sd	s11,8(sp)
    80001a1c:	1880                	addi	s0,sp,112
    80001a1e:	8baa                	mv	s7,a0
    80001a20:	8c2e                	mv	s8,a1
    80001a22:	8b32                	mv	s6,a2
    80001a24:	8db6                	mv	s11,a3
  for(i = 0; i < sz; i += PGSIZE){
    80001a26:	4981                	li	s3,0
    flags = PTE_FLAGS(*pte);

    if((mem = kalloc_user(newp, i)) == 0)
      goto err;

    memmove(mem, (char*)pa, PGSIZE);
    80001a28:	6a85                	lui	s5,0x1
      swap_space[newslot].disk_block = newblk;
    80001a2a:	00018d17          	auipc	s10,0x18
    80001a2e:	d66d0d13          	addi	s10,s10,-666 # 80019790 <swap_space>
      swap_space[newslot].used = 1;
    80001a32:	4c85                	li	s9,1
    80001a34:	a8a9                	j	80001a8e <uvmcopy+0x92>
      int newslot = swap_alloc();
    80001a36:	24f010ef          	jal	80003484 <swap_alloc>
    80001a3a:	8a2a                	mv	s4,a0
      if(newslot < 0)
    80001a3c:	08054f63          	bltz	a0,80001ada <uvmcopy+0xde>
      uint32 newblk = SWAP_START_BLOCK + newslot * BLOCKS_PER_PAGE;
    80001a40:	0025159b          	slliw	a1,a0,0x2
      swap_space[newslot].disk_block = newblk;
    80001a44:	00551793          	slli	a5,a0,0x5
    80001a48:	97ea                	add	a5,a5,s10
    80001a4a:	cf8c                	sw	a1,24(a5)
      swap_space[newslot].used = 1;
    80001a4c:	0197a023          	sw	s9,0(a5)
      swap_space[newslot].proc = 0;
    80001a50:	0007b423          	sd	zero,8(a5)
      swap_space[newslot].va = i;
    80001a54:	0137b823          	sd	s3,16(a5)
      int slot = (*pte >> PTE_SWAP_SHIFT) & 0xFF;
    80001a58:	80a9                	srli	s1,s1,0xa
      raid_copy(swap_space[slot].disk_block, newblk);
    80001a5a:	0ff4f493          	zext.b	s1,s1
    80001a5e:	0496                	slli	s1,s1,0x5
    80001a60:	94ea                	add	s1,s1,s10
    80001a62:	4c88                	lw	a0,24(s1)
    80001a64:	600050ef          	jal	80007064 <raid_copy>
      pte_t *newpte = walk(new, i, 1);
    80001a68:	8666                	mv	a2,s9
    80001a6a:	85ce                	mv	a1,s3
    80001a6c:	8562                	mv	a0,s8
    80001a6e:	9fdff0ef          	jal	8000146a <walk>
      if(newpte == 0)
    80001a72:	c525                	beqz	a0,80001ada <uvmcopy+0xde>
      uint16 perms = PTE_FLAGS(*pte) & 0x3FF;
    80001a74:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
      *newpte = ((pte_t)newslot << PTE_SWAP_SHIFT) | PTE_SWAPPED | perms;
    80001a78:	3ff7f793          	andi	a5,a5,1023
    80001a7c:	0a2a                	slli	s4,s4,0xa
    80001a7e:	0147e7b3          	or	a5,a5,s4
    80001a82:	1007e793          	ori	a5,a5,256
    80001a86:	e11c                	sd	a5,0(a0)
  for(i = 0; i < sz; i += PGSIZE){
    80001a88:	99d6                	add	s3,s3,s5
    80001a8a:	0769f163          	bgeu	s3,s6,80001aec <uvmcopy+0xf0>
    if((pte = walk(old, i, 0)) == 0)
    80001a8e:	4601                	li	a2,0
    80001a90:	85ce                	mv	a1,s3
    80001a92:	855e                	mv	a0,s7
    80001a94:	9d7ff0ef          	jal	8000146a <walk>
    80001a98:	892a                	mv	s2,a0
    80001a9a:	d57d                	beqz	a0,80001a88 <uvmcopy+0x8c>
    if(*pte & PTE_SWAPPED){
    80001a9c:	6104                	ld	s1,0(a0)
    80001a9e:	1004f793          	andi	a5,s1,256
    80001aa2:	fbd1                	bnez	a5,80001a36 <uvmcopy+0x3a>
    if((*pte & PTE_V) == 0)
    80001aa4:	0014f793          	andi	a5,s1,1
    80001aa8:	d3e5                	beqz	a5,80001a88 <uvmcopy+0x8c>
    if((mem = kalloc_user(newp, i)) == 0)
    80001aaa:	85ce                	mv	a1,s3
    80001aac:	856e                	mv	a0,s11
    80001aae:	934ff0ef          	jal	80000be2 <kalloc_user>
    80001ab2:	892a                	mv	s2,a0
    80001ab4:	c11d                	beqz	a0,80001ada <uvmcopy+0xde>
    pa = PTE2PA(*pte);
    80001ab6:	00a4d593          	srli	a1,s1,0xa
    memmove(mem, (char*)pa, PGSIZE);
    80001aba:	8656                	mv	a2,s5
    80001abc:	05b2                	slli	a1,a1,0xc
    80001abe:	f74ff0ef          	jal	80001232 <memmove>

    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001ac2:	3ff4f713          	andi	a4,s1,1023
    80001ac6:	86ca                	mv	a3,s2
    80001ac8:	8656                	mv	a2,s5
    80001aca:	85ce                	mv	a1,s3
    80001acc:	8562                	mv	a0,s8
    80001ace:	a71ff0ef          	jal	8000153e <mappages>
    80001ad2:	d95d                	beqz	a0,80001a88 <uvmcopy+0x8c>
      kfree(mem);
    80001ad4:	854a                	mv	a0,s2
    80001ad6:	f87fe0ef          	jal	80000a5c <kfree>
  }

  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001ada:	4685                	li	a3,1
    80001adc:	00c9d613          	srli	a2,s3,0xc
    80001ae0:	4581                	li	a1,0
    80001ae2:	8562                	mv	a0,s8
    80001ae4:	c29ff0ef          	jal	8000170c <uvmunmap>
  return -1;
    80001ae8:	557d                	li	a0,-1
    80001aea:	a011                	j	80001aee <uvmcopy+0xf2>
  return 0;
    80001aec:	4501                	li	a0,0
}
    80001aee:	70a6                	ld	ra,104(sp)
    80001af0:	7406                	ld	s0,96(sp)
    80001af2:	64e6                	ld	s1,88(sp)
    80001af4:	6946                	ld	s2,80(sp)
    80001af6:	69a6                	ld	s3,72(sp)
    80001af8:	6a06                	ld	s4,64(sp)
    80001afa:	7ae2                	ld	s5,56(sp)
    80001afc:	7b42                	ld	s6,48(sp)
    80001afe:	7ba2                	ld	s7,40(sp)
    80001b00:	7c02                	ld	s8,32(sp)
    80001b02:	6ce2                	ld	s9,24(sp)
    80001b04:	6d42                	ld	s10,16(sp)
    80001b06:	6da2                	ld	s11,8(sp)
    80001b08:	6165                	addi	sp,sp,112
    80001b0a:	8082                	ret
  return 0;
    80001b0c:	4501                	li	a0,0
}
    80001b0e:	8082                	ret

0000000080001b10 <uvmclear>:

void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001b10:	1141                	addi	sp,sp,-16
    80001b12:	e406                	sd	ra,8(sp)
    80001b14:	e022                	sd	s0,0(sp)
    80001b16:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001b18:	4601                	li	a2,0
    80001b1a:	951ff0ef          	jal	8000146a <walk>
  if(pte == 0)
    80001b1e:	c901                	beqz	a0,80001b2e <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001b20:	611c                	ld	a5,0(a0)
    80001b22:	9bbd                	andi	a5,a5,-17
    80001b24:	e11c                	sd	a5,0(a0)
}
    80001b26:	60a2                	ld	ra,8(sp)
    80001b28:	6402                	ld	s0,0(sp)
    80001b2a:	0141                	addi	sp,sp,16
    80001b2c:	8082                	ret
    panic("uvmclear");
    80001b2e:	00007517          	auipc	a0,0x7
    80001b32:	64250513          	addi	a0,a0,1602 # 80009170 <etext+0x170>
    80001b36:	ceffe0ef          	jal	80000824 <panic>

0000000080001b3a <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001b3a:	cac5                	beqz	a3,80001bea <copyinstr+0xb0>
{
    80001b3c:	715d                	addi	sp,sp,-80
    80001b3e:	e486                	sd	ra,72(sp)
    80001b40:	e0a2                	sd	s0,64(sp)
    80001b42:	fc26                	sd	s1,56(sp)
    80001b44:	f84a                	sd	s2,48(sp)
    80001b46:	f44e                	sd	s3,40(sp)
    80001b48:	f052                	sd	s4,32(sp)
    80001b4a:	ec56                	sd	s5,24(sp)
    80001b4c:	e85a                	sd	s6,16(sp)
    80001b4e:	e45e                	sd	s7,8(sp)
    80001b50:	0880                	addi	s0,sp,80
    80001b52:	8aaa                	mv	s5,a0
    80001b54:	84ae                	mv	s1,a1
    80001b56:	8bb2                	mv	s7,a2
    80001b58:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001b5a:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001b5c:	6a05                	lui	s4,0x1
    80001b5e:	a82d                	j	80001b98 <copyinstr+0x5e>
      n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001b60:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80001b64:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null)
    80001b66:	0017c793          	xori	a5,a5,1
    80001b6a:	40f0053b          	negw	a0,a5
    return 0;
  else
    return -1;
}
    80001b6e:	60a6                	ld	ra,72(sp)
    80001b70:	6406                	ld	s0,64(sp)
    80001b72:	74e2                	ld	s1,56(sp)
    80001b74:	7942                	ld	s2,48(sp)
    80001b76:	79a2                	ld	s3,40(sp)
    80001b78:	7a02                	ld	s4,32(sp)
    80001b7a:	6ae2                	ld	s5,24(sp)
    80001b7c:	6b42                	ld	s6,16(sp)
    80001b7e:	6ba2                	ld	s7,8(sp)
    80001b80:	6161                	addi	sp,sp,80
    80001b82:	8082                	ret
    80001b84:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001b88:	9726                	add	a4,a4,s1
      --max;
    80001b8a:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80001b8e:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001b92:	04e58463          	beq	a1,a4,80001bda <copyinstr+0xa0>
{
    80001b96:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80001b98:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001b9c:	85ca                	mv	a1,s2
    80001b9e:	8556                	mv	a0,s5
    80001ba0:	965ff0ef          	jal	80001504 <walkaddr>
    if(pa0 == 0)
    80001ba4:	cd0d                	beqz	a0,80001bde <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001ba6:	417906b3          	sub	a3,s2,s7
    80001baa:	96d2                	add	a3,a3,s4
    if(n > max)
    80001bac:	00d9f363          	bgeu	s3,a3,80001bb2 <copyinstr+0x78>
    80001bb0:	86ce                	mv	a3,s3
    while(n > 0){
    80001bb2:	ca85                	beqz	a3,80001be2 <copyinstr+0xa8>
    char *p = (char *)(pa0 + (srcva - va0));
    80001bb4:	01750633          	add	a2,a0,s7
    80001bb8:	41260633          	sub	a2,a2,s2
    80001bbc:	87a6                	mv	a5,s1
      if(*p == '\0'){
    80001bbe:	8e05                	sub	a2,a2,s1
    while(n > 0){
    80001bc0:	96a6                	add	a3,a3,s1
    80001bc2:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001bc4:	00f60733          	add	a4,a2,a5
    80001bc8:	00074703          	lbu	a4,0(a4)
    80001bcc:	db51                	beqz	a4,80001b60 <copyinstr+0x26>
        *dst = *p;
    80001bce:	00e78023          	sb	a4,0(a5)
      dst++;
    80001bd2:	0785                	addi	a5,a5,1
    while(n > 0){
    80001bd4:	fed797e3          	bne	a5,a3,80001bc2 <copyinstr+0x88>
    80001bd8:	b775                	j	80001b84 <copyinstr+0x4a>
    80001bda:	4781                	li	a5,0
    80001bdc:	b769                	j	80001b66 <copyinstr+0x2c>
      return -1;
    80001bde:	557d                	li	a0,-1
    80001be0:	b779                	j	80001b6e <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80001be2:	6b85                	lui	s7,0x1
    80001be4:	9bca                	add	s7,s7,s2
    80001be6:	87a6                	mv	a5,s1
    80001be8:	b77d                	j	80001b96 <copyinstr+0x5c>
  int got_null = 0;
    80001bea:	4781                	li	a5,0
  if(got_null)
    80001bec:	0017c793          	xori	a5,a5,1
    80001bf0:	40f0053b          	negw	a0,a5
}
    80001bf4:	8082                	ret

0000000080001bf6 <vmfault>:

uint64
vmfault(pagetable_t pagetable, uint64 va, int write)
{
    80001bf6:	7139                	addi	sp,sp,-64
    80001bf8:	fc06                	sd	ra,56(sp)
    80001bfa:	f822                	sd	s0,48(sp)
    80001bfc:	f426                	sd	s1,40(sp)
    80001bfe:	ec4e                	sd	s3,24(sp)
    80001c00:	0080                	addi	s0,sp,64
    80001c02:	89aa                	mv	s3,a0
    80001c04:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80001c06:	464000ef          	jal	8000206a <myproc>
  va = PGROUNDDOWN(va);
    80001c0a:	77fd                	lui	a5,0xfffff
    80001c0c:	8cfd                	and	s1,s1,a5

  if(va >= p->sz)
    80001c0e:	653c                	ld	a5,72(a0)
    80001c10:	00f4ea63          	bltu	s1,a5,80001c24 <vmfault+0x2e>
    return 0;
    80001c14:	4981                	li	s3,0
    }
  }
  release(&frame_lock);

  return PTE2PA(*pte);
}
    80001c16:	854e                	mv	a0,s3
    80001c18:	70e2                	ld	ra,56(sp)
    80001c1a:	7442                	ld	s0,48(sp)
    80001c1c:	74a2                	ld	s1,40(sp)
    80001c1e:	69e2                	ld	s3,24(sp)
    80001c20:	6121                	addi	sp,sp,64
    80001c22:	8082                	ret
    80001c24:	f04a                	sd	s2,32(sp)
    80001c26:	e852                	sd	s4,16(sp)
    80001c28:	892a                	mv	s2,a0
  pte_t *pte = walk(pagetable, va, 1);
    80001c2a:	4605                	li	a2,1
    80001c2c:	85a6                	mv	a1,s1
    80001c2e:	854e                	mv	a0,s3
    80001c30:	83bff0ef          	jal	8000146a <walk>
    80001c34:	8a2a                	mv	s4,a0
  if(pte == 0)
    80001c36:	12050363          	beqz	a0,80001d5c <vmfault+0x166>
    80001c3a:	e456                	sd	s5,8(sp)
  if(*pte & PTE_SWAPPED){
    80001c3c:	611c                	ld	a5,0(a0)
    80001c3e:	8abe                	mv	s5,a5
    80001c40:	1007f793          	andi	a5,a5,256
    80001c44:	e7b1                	bnez	a5,80001c90 <vmfault+0x9a>
  if((*pte & PTE_V) == 0){
    80001c46:	001af793          	andi	a5,s5,1
    80001c4a:	89be                	mv	s3,a5
    80001c4c:	e3dd                	bnez	a5,80001cf2 <vmfault+0xfc>
    char *mem = kalloc_user(p, va);
    80001c4e:	85a6                	mv	a1,s1
    80001c50:	854a                	mv	a0,s2
    80001c52:	f91fe0ef          	jal	80000be2 <kalloc_user>
    80001c56:	84aa                	mv	s1,a0
    if(mem == 0)
    80001c58:	10050a63          	beqz	a0,80001d6c <vmfault+0x176>
    memset(mem, 0, PGSIZE);
    80001c5c:	6605                	lui	a2,0x1
    80001c5e:	4581                	li	a1,0
    80001c60:	d72ff0ef          	jal	800011d2 <memset>
    *pte = PA2PTE(mem) | PTE_V | PTE_R | PTE_W | PTE_U;
    80001c64:	89a6                	mv	s3,s1
    80001c66:	00c4d793          	srli	a5,s1,0xc
    80001c6a:	07aa                	slli	a5,a5,0xa
    80001c6c:	0177e793          	ori	a5,a5,23
    80001c70:	00fa3023          	sd	a5,0(s4) # 1000 <_entry-0x7ffff000>
    p->page_faults++;
    80001c74:	19092783          	lw	a5,400(s2)
    80001c78:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7fdd7c69>
    80001c7a:	18f92823          	sw	a5,400(s2)
    p->resident_pages++;
    80001c7e:	1a092783          	lw	a5,416(s2)
    80001c82:	2785                	addiw	a5,a5,1
    80001c84:	1af92023          	sw	a5,416(s2)
    return (uint64)mem;
    80001c88:	7902                	ld	s2,32(sp)
    80001c8a:	6a42                	ld	s4,16(sp)
    80001c8c:	6aa2                	ld	s5,8(sp)
    80001c8e:	b761                	j	80001c16 <vmfault+0x20>
    char *mem = kalloc_user(p, va);
    80001c90:	85a6                	mv	a1,s1
    80001c92:	854a                	mv	a0,s2
    80001c94:	f4ffe0ef          	jal	80000be2 <kalloc_user>
    80001c98:	84aa                	mv	s1,a0
      return 0;
    80001c9a:	4981                	li	s3,0
    if(mem == 0)
    80001c9c:	c561                	beqz	a0,80001d64 <vmfault+0x16e>
   int swap_idx = (*pte >> PTE_SWAP_SHIFT) & 0xFF;
    80001c9e:	00aad793          	srli	a5,s5,0xa
    80001ca2:	0ff7f793          	zext.b	a5,a5
    80001ca6:	89be                	mv	s3,a5
    swap_read(swap_idx, mem, p);
    80001ca8:	864a                	mv	a2,s2
    80001caa:	85aa                	mv	a1,a0
    80001cac:	853e                	mv	a0,a5
    80001cae:	13f010ef          	jal	800035ec <swap_read>
    swap_free(swap_idx);
    80001cb2:	854e                	mv	a0,s3
    80001cb4:	03d010ef          	jal	800034f0 <swap_free>
    *pte = PA2PTE(mem) | PTE_V | perms;
    80001cb8:	89a6                	mv	s3,s1
    80001cba:	00c4d793          	srli	a5,s1,0xc
    80001cbe:	07aa                	slli	a5,a5,0xa
    uint16 perms = PTE_FLAGS(*pte) & 0x3FF;
    80001cc0:	000a3703          	ld	a4,0(s4)
    *pte = PA2PTE(mem) | PTE_V | perms;
    80001cc4:	2ff77713          	andi	a4,a4,767
    *pte &= ~PTE_SWAPPED;
    80001cc8:	8fd9                	or	a5,a5,a4
    80001cca:	0017e793          	ori	a5,a5,1
    80001cce:	00fa3023          	sd	a5,0(s4)
    80001cd2:	12000073          	sfence.vma
    p->pages_swapped_in++;
    80001cd6:	19892783          	lw	a5,408(s2)
    80001cda:	2785                	addiw	a5,a5,1
    80001cdc:	18f92c23          	sw	a5,408(s2)
    p->resident_pages++;
    80001ce0:	1a092783          	lw	a5,416(s2)
    80001ce4:	2785                	addiw	a5,a5,1
    80001ce6:	1af92023          	sw	a5,416(s2)
    return (uint64)mem;
    80001cea:	7902                	ld	s2,32(sp)
    80001cec:	6a42                	ld	s4,16(sp)
    80001cee:	6aa2                	ld	s5,8(sp)
    80001cf0:	b71d                	j	80001c16 <vmfault+0x20>
  acquire(&frame_lock);
    80001cf2:	00010517          	auipc	a0,0x10
    80001cf6:	f2650513          	addi	a0,a0,-218 # 80011c18 <frame_lock>
    80001cfa:	c08ff0ef          	jal	80001102 <acquire>
  for(int i = 0; i < MAX_FRAMES; i++){
    80001cfe:	00010797          	auipc	a5,0x10
    80001d02:	f3278793          	addi	a5,a5,-206 # 80011c30 <frame_table>
    80001d06:	4701                	li	a4,0
    80001d08:	02000613          	li	a2,32
    80001d0c:	a031                	j	80001d18 <vmfault+0x122>
    80001d0e:	2705                	addiw	a4,a4,1
    80001d10:	02878793          	addi	a5,a5,40
    80001d14:	02c70563          	beq	a4,a2,80001d3e <vmfault+0x148>
    if(frame_table[i].used &&
    80001d18:	4394                	lw	a3,0(a5)
    80001d1a:	daf5                	beqz	a3,80001d0e <vmfault+0x118>
    80001d1c:	6794                	ld	a3,8(a5)
    80001d1e:	ff2698e3          	bne	a3,s2,80001d0e <vmfault+0x118>
       frame_table[i].proc == p &&
    80001d22:	6b94                	ld	a3,16(a5)
    80001d24:	fe9695e3          	bne	a3,s1,80001d0e <vmfault+0x118>
      frame_table[i].ref_bit = 1;
    80001d28:	00271793          	slli	a5,a4,0x2
    80001d2c:	97ba                	add	a5,a5,a4
    80001d2e:	078e                	slli	a5,a5,0x3
    80001d30:	00010717          	auipc	a4,0x10
    80001d34:	f0070713          	addi	a4,a4,-256 # 80011c30 <frame_table>
    80001d38:	97ba                	add	a5,a5,a4
    80001d3a:	4705                	li	a4,1
    80001d3c:	d398                	sw	a4,32(a5)
  release(&frame_lock);
    80001d3e:	00010517          	auipc	a0,0x10
    80001d42:	eda50513          	addi	a0,a0,-294 # 80011c18 <frame_lock>
    80001d46:	c50ff0ef          	jal	80001196 <release>
  return PTE2PA(*pte);
    80001d4a:	000a3783          	ld	a5,0(s4)
    80001d4e:	83a9                	srli	a5,a5,0xa
    80001d50:	07b2                	slli	a5,a5,0xc
    80001d52:	89be                	mv	s3,a5
    80001d54:	7902                	ld	s2,32(sp)
    80001d56:	6a42                	ld	s4,16(sp)
    80001d58:	6aa2                	ld	s5,8(sp)
    80001d5a:	bd75                	j	80001c16 <vmfault+0x20>
    return 0;
    80001d5c:	4981                	li	s3,0
    80001d5e:	7902                	ld	s2,32(sp)
    80001d60:	6a42                	ld	s4,16(sp)
    80001d62:	bd55                	j	80001c16 <vmfault+0x20>
    80001d64:	7902                	ld	s2,32(sp)
    80001d66:	6a42                	ld	s4,16(sp)
    80001d68:	6aa2                	ld	s5,8(sp)
    80001d6a:	b575                	j	80001c16 <vmfault+0x20>
    80001d6c:	7902                	ld	s2,32(sp)
    80001d6e:	6a42                	ld	s4,16(sp)
    80001d70:	6aa2                	ld	s5,8(sp)
    80001d72:	b555                	j	80001c16 <vmfault+0x20>

0000000080001d74 <copyout>:
  while(len > 0){
    80001d74:	cad1                	beqz	a3,80001e08 <copyout+0x94>
{
    80001d76:	711d                	addi	sp,sp,-96
    80001d78:	ec86                	sd	ra,88(sp)
    80001d7a:	e8a2                	sd	s0,80(sp)
    80001d7c:	e4a6                	sd	s1,72(sp)
    80001d7e:	e0ca                	sd	s2,64(sp)
    80001d80:	fc4e                	sd	s3,56(sp)
    80001d82:	f852                	sd	s4,48(sp)
    80001d84:	f456                	sd	s5,40(sp)
    80001d86:	f05a                	sd	s6,32(sp)
    80001d88:	ec5e                	sd	s7,24(sp)
    80001d8a:	e862                	sd	s8,16(sp)
    80001d8c:	e466                	sd	s9,8(sp)
    80001d8e:	e06a                	sd	s10,0(sp)
    80001d90:	1080                	addi	s0,sp,96
    80001d92:	8baa                	mv	s7,a0
    80001d94:	8a2e                	mv	s4,a1
    80001d96:	8b32                	mv	s6,a2
    80001d98:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80001d9a:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    80001d9c:	5cfd                	li	s9,-1
    80001d9e:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80001da2:	6c05                	lui	s8,0x1
    80001da4:	a005                	j	80001dc4 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001da6:	409a0533          	sub	a0,s4,s1
    80001daa:	0009061b          	sext.w	a2,s2
    80001dae:	85da                	mv	a1,s6
    80001db0:	954e                	add	a0,a0,s3
    80001db2:	c80ff0ef          	jal	80001232 <memmove>
    len -= n;
    80001db6:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80001dba:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80001dbc:	01848a33          	add	s4,s1,s8
  while(len > 0){
    80001dc0:	040a8263          	beqz	s5,80001e04 <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    80001dc4:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    80001dc8:	049ce263          	bltu	s9,s1,80001e0c <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    80001dcc:	85a6                	mv	a1,s1
    80001dce:	855e                	mv	a0,s7
    80001dd0:	f34ff0ef          	jal	80001504 <walkaddr>
    80001dd4:	89aa                	mv	s3,a0
    if(pa0 == 0){
    80001dd6:	e901                	bnez	a0,80001de6 <copyout+0x72>
      pa0 = vmfault(pagetable, va0, 0);
    80001dd8:	4601                	li	a2,0
    80001dda:	85a6                	mv	a1,s1
    80001ddc:	855e                	mv	a0,s7
    80001dde:	e19ff0ef          	jal	80001bf6 <vmfault>
    80001de2:	89aa                	mv	s3,a0
      if(pa0 == 0)
    80001de4:	c139                	beqz	a0,80001e2a <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    80001de6:	4601                	li	a2,0
    80001de8:	85a6                	mv	a1,s1
    80001dea:	855e                	mv	a0,s7
    80001dec:	e7eff0ef          	jal	8000146a <walk>
    if((*pte & PTE_W) == 0)
    80001df0:	611c                	ld	a5,0(a0)
    80001df2:	8b91                	andi	a5,a5,4
    80001df4:	cf8d                	beqz	a5,80001e2e <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    80001df6:	41448933          	sub	s2,s1,s4
    80001dfa:	9962                	add	s2,s2,s8
    if(n > len)
    80001dfc:	fb2af5e3          	bgeu	s5,s2,80001da6 <copyout+0x32>
    80001e00:	8956                	mv	s2,s5
    80001e02:	b755                	j	80001da6 <copyout+0x32>
  return 0;
    80001e04:	4501                	li	a0,0
    80001e06:	a021                	j	80001e0e <copyout+0x9a>
    80001e08:	4501                	li	a0,0
}
    80001e0a:	8082                	ret
      return -1;
    80001e0c:	557d                	li	a0,-1
}
    80001e0e:	60e6                	ld	ra,88(sp)
    80001e10:	6446                	ld	s0,80(sp)
    80001e12:	64a6                	ld	s1,72(sp)
    80001e14:	6906                	ld	s2,64(sp)
    80001e16:	79e2                	ld	s3,56(sp)
    80001e18:	7a42                	ld	s4,48(sp)
    80001e1a:	7aa2                	ld	s5,40(sp)
    80001e1c:	7b02                	ld	s6,32(sp)
    80001e1e:	6be2                	ld	s7,24(sp)
    80001e20:	6c42                	ld	s8,16(sp)
    80001e22:	6ca2                	ld	s9,8(sp)
    80001e24:	6d02                	ld	s10,0(sp)
    80001e26:	6125                	addi	sp,sp,96
    80001e28:	8082                	ret
        return -1;
    80001e2a:	557d                	li	a0,-1
    80001e2c:	b7cd                	j	80001e0e <copyout+0x9a>
      return -1;
    80001e2e:	557d                	li	a0,-1
    80001e30:	bff9                	j	80001e0e <copyout+0x9a>

0000000080001e32 <copyin>:
  while(len > 0){
    80001e32:	c6c9                	beqz	a3,80001ebc <copyin+0x8a>
{
    80001e34:	715d                	addi	sp,sp,-80
    80001e36:	e486                	sd	ra,72(sp)
    80001e38:	e0a2                	sd	s0,64(sp)
    80001e3a:	fc26                	sd	s1,56(sp)
    80001e3c:	f84a                	sd	s2,48(sp)
    80001e3e:	f44e                	sd	s3,40(sp)
    80001e40:	f052                	sd	s4,32(sp)
    80001e42:	ec56                	sd	s5,24(sp)
    80001e44:	e85a                	sd	s6,16(sp)
    80001e46:	e45e                	sd	s7,8(sp)
    80001e48:	e062                	sd	s8,0(sp)
    80001e4a:	0880                	addi	s0,sp,80
    80001e4c:	8baa                	mv	s7,a0
    80001e4e:	8aae                	mv	s5,a1
    80001e50:	8932                	mv	s2,a2
    80001e52:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80001e54:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80001e56:	6b05                	lui	s6,0x1
    80001e58:	a035                	j	80001e84 <copyin+0x52>
    80001e5a:	412984b3          	sub	s1,s3,s2
    80001e5e:	94da                	add	s1,s1,s6
    if(n > len)
    80001e60:	009a7363          	bgeu	s4,s1,80001e66 <copyin+0x34>
    80001e64:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001e66:	413905b3          	sub	a1,s2,s3
    80001e6a:	0004861b          	sext.w	a2,s1
    80001e6e:	95aa                	add	a1,a1,a0
    80001e70:	8556                	mv	a0,s5
    80001e72:	bc0ff0ef          	jal	80001232 <memmove>
    len -= n;
    80001e76:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80001e7a:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80001e7c:	01698933          	add	s2,s3,s6
  while(len > 0){
    80001e80:	020a0163          	beqz	s4,80001ea2 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001e84:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80001e88:	85ce                	mv	a1,s3
    80001e8a:	855e                	mv	a0,s7
    80001e8c:	e78ff0ef          	jal	80001504 <walkaddr>
    if(pa0 == 0){
    80001e90:	f569                	bnez	a0,80001e5a <copyin+0x28>
      pa0 = vmfault(pagetable, va0, 0);
    80001e92:	4601                	li	a2,0
    80001e94:	85ce                	mv	a1,s3
    80001e96:	855e                	mv	a0,s7
    80001e98:	d5fff0ef          	jal	80001bf6 <vmfault>
      if(pa0 == 0)
    80001e9c:	fd5d                	bnez	a0,80001e5a <copyin+0x28>
        return -1;
    80001e9e:	557d                	li	a0,-1
    80001ea0:	a011                	j	80001ea4 <copyin+0x72>
  return 0;
    80001ea2:	4501                	li	a0,0
}
    80001ea4:	60a6                	ld	ra,72(sp)
    80001ea6:	6406                	ld	s0,64(sp)
    80001ea8:	74e2                	ld	s1,56(sp)
    80001eaa:	7942                	ld	s2,48(sp)
    80001eac:	79a2                	ld	s3,40(sp)
    80001eae:	7a02                	ld	s4,32(sp)
    80001eb0:	6ae2                	ld	s5,24(sp)
    80001eb2:	6b42                	ld	s6,16(sp)
    80001eb4:	6ba2                	ld	s7,8(sp)
    80001eb6:	6c02                	ld	s8,0(sp)
    80001eb8:	6161                	addi	sp,sp,80
    80001eba:	8082                	ret
  return 0;
    80001ebc:	4501                	li	a0,0
}
    80001ebe:	8082                	ret

0000000080001ec0 <ismapped>:

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001ec0:	1141                	addi	sp,sp,-16
    80001ec2:	e406                	sd	ra,8(sp)
    80001ec4:	e022                	sd	s0,0(sp)
    80001ec6:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80001ec8:	4601                	li	a2,0
    80001eca:	da0ff0ef          	jal	8000146a <walk>
  if(pte == 0)
    80001ece:	c119                	beqz	a0,80001ed4 <ismapped+0x14>
    return 0;
  if(*pte & PTE_V)
    80001ed0:	6108                	ld	a0,0(a0)
    80001ed2:	8905                	andi	a0,a0,1
    return 1;
  return 0;
    80001ed4:	60a2                	ld	ra,8(sp)
    80001ed6:	6402                	ld	s0,0(sp)
    80001ed8:	0141                	addi	sp,sp,16
    80001eda:	8082                	ret

0000000080001edc <proc_mapstacks>:
extern char trampoline[]; // trampoline.S
struct spinlock wait_lock;
int quantum_times[4] = {2, 4, 8, 16};
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001edc:	715d                	addi	sp,sp,-80
    80001ede:	e486                	sd	ra,72(sp)
    80001ee0:	e0a2                	sd	s0,64(sp)
    80001ee2:	fc26                	sd	s1,56(sp)
    80001ee4:	f84a                	sd	s2,48(sp)
    80001ee6:	f44e                	sd	s3,40(sp)
    80001ee8:	f052                	sd	s4,32(sp)
    80001eea:	ec56                	sd	s5,24(sp)
    80001eec:	e85a                	sd	s6,16(sp)
    80001eee:	e45e                	sd	s7,8(sp)
    80001ef0:	e062                	sd	s8,0(sp)
    80001ef2:	0880                	addi	s0,sp,80
    80001ef4:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ef6:	00010497          	auipc	s1,0x10
    80001efa:	66a48493          	addi	s1,s1,1642 # 80012560 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001efe:	8c26                	mv	s8,s1
    80001f00:	ff048937          	lui	s2,0xff048
    80001f04:	dc190913          	addi	s2,s2,-575 # ffffffffff047dc1 <end+0xffffffff7ee20a29>
    80001f08:	0932                	slli	s2,s2,0xc
    80001f0a:	1f790913          	addi	s2,s2,503
    80001f0e:	093e                	slli	s2,s2,0xf
    80001f10:	23f90913          	addi	s2,s2,575
    80001f14:	0932                	slli	s2,s2,0xc
    80001f16:	e0990913          	addi	s2,s2,-503
    80001f1a:	040009b7          	lui	s3,0x4000
    80001f1e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001f20:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001f22:	4b99                	li	s7,6
    80001f24:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f26:	00018a97          	auipc	s5,0x18
    80001f2a:	83aa8a93          	addi	s5,s5,-1990 # 80019760 <tickslock>
    char *pa = kalloc();
    80001f2e:	c5bfe0ef          	jal	80000b88 <kalloc>
    80001f32:	862a                	mv	a2,a0
    if(pa == 0)
    80001f34:	c121                	beqz	a0,80001f74 <proc_mapstacks+0x98>
    uint64 va = KSTACK((int) (p - proc));
    80001f36:	418485b3          	sub	a1,s1,s8
    80001f3a:	858d                	srai	a1,a1,0x3
    80001f3c:	032585b3          	mul	a1,a1,s2
    80001f40:	05b6                	slli	a1,a1,0xd
    80001f42:	6789                	lui	a5,0x2
    80001f44:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001f46:	875e                	mv	a4,s7
    80001f48:	86da                	mv	a3,s6
    80001f4a:	40b985b3          	sub	a1,s3,a1
    80001f4e:	8552                	mv	a0,s4
    80001f50:	ea4ff0ef          	jal	800015f4 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f54:	1c848493          	addi	s1,s1,456
    80001f58:	fd549be3          	bne	s1,s5,80001f2e <proc_mapstacks+0x52>
  }
}
    80001f5c:	60a6                	ld	ra,72(sp)
    80001f5e:	6406                	ld	s0,64(sp)
    80001f60:	74e2                	ld	s1,56(sp)
    80001f62:	7942                	ld	s2,48(sp)
    80001f64:	79a2                	ld	s3,40(sp)
    80001f66:	7a02                	ld	s4,32(sp)
    80001f68:	6ae2                	ld	s5,24(sp)
    80001f6a:	6b42                	ld	s6,16(sp)
    80001f6c:	6ba2                	ld	s7,8(sp)
    80001f6e:	6c02                	ld	s8,0(sp)
    80001f70:	6161                	addi	sp,sp,80
    80001f72:	8082                	ret
      panic("kalloc");
    80001f74:	00007517          	auipc	a0,0x7
    80001f78:	20c50513          	addi	a0,a0,524 # 80009180 <etext+0x180>
    80001f7c:	8a9fe0ef          	jal	80000824 <panic>

0000000080001f80 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001f80:	7139                	addi	sp,sp,-64
    80001f82:	fc06                	sd	ra,56(sp)
    80001f84:	f822                	sd	s0,48(sp)
    80001f86:	f426                	sd	s1,40(sp)
    80001f88:	f04a                	sd	s2,32(sp)
    80001f8a:	ec4e                	sd	s3,24(sp)
    80001f8c:	e852                	sd	s4,16(sp)
    80001f8e:	e456                	sd	s5,8(sp)
    80001f90:	e05a                	sd	s6,0(sp)
    80001f92:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001f94:	00007597          	auipc	a1,0x7
    80001f98:	1f458593          	addi	a1,a1,500 # 80009188 <etext+0x188>
    80001f9c:	00010517          	auipc	a0,0x10
    80001fa0:	19450513          	addi	a0,a0,404 # 80012130 <pid_lock>
    80001fa4:	8d4ff0ef          	jal	80001078 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001fa8:	00007597          	auipc	a1,0x7
    80001fac:	1e858593          	addi	a1,a1,488 # 80009190 <etext+0x190>
    80001fb0:	00010517          	auipc	a0,0x10
    80001fb4:	19850513          	addi	a0,a0,408 # 80012148 <wait_lock>
    80001fb8:	8c0ff0ef          	jal	80001078 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001fbc:	00010497          	auipc	s1,0x10
    80001fc0:	5a448493          	addi	s1,s1,1444 # 80012560 <proc>
      initlock(&p->lock, "proc");
    80001fc4:	00007b17          	auipc	s6,0x7
    80001fc8:	1dcb0b13          	addi	s6,s6,476 # 800091a0 <etext+0x1a0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001fcc:	8aa6                	mv	s5,s1
    80001fce:	ff048937          	lui	s2,0xff048
    80001fd2:	dc190913          	addi	s2,s2,-575 # ffffffffff047dc1 <end+0xffffffff7ee20a29>
    80001fd6:	0932                	slli	s2,s2,0xc
    80001fd8:	1f790913          	addi	s2,s2,503
    80001fdc:	093e                	slli	s2,s2,0xf
    80001fde:	23f90913          	addi	s2,s2,575
    80001fe2:	0932                	slli	s2,s2,0xc
    80001fe4:	e0990913          	addi	s2,s2,-503
    80001fe8:	040009b7          	lui	s3,0x4000
    80001fec:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001fee:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ff0:	00017a17          	auipc	s4,0x17
    80001ff4:	770a0a13          	addi	s4,s4,1904 # 80019760 <tickslock>
      initlock(&p->lock, "proc");
    80001ff8:	85da                	mv	a1,s6
    80001ffa:	8526                	mv	a0,s1
    80001ffc:	87cff0ef          	jal	80001078 <initlock>
      p->state = UNUSED;
    80002000:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80002004:	415487b3          	sub	a5,s1,s5
    80002008:	878d                	srai	a5,a5,0x3
    8000200a:	032787b3          	mul	a5,a5,s2
    8000200e:	07b6                	slli	a5,a5,0xd
    80002010:	6709                	lui	a4,0x2
    80002012:	9fb9                	addw	a5,a5,a4
    80002014:	40f987b3          	sub	a5,s3,a5
    80002018:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000201a:	1c848493          	addi	s1,s1,456
    8000201e:	fd449de3          	bne	s1,s4,80001ff8 <procinit+0x78>
  }
}
    80002022:	70e2                	ld	ra,56(sp)
    80002024:	7442                	ld	s0,48(sp)
    80002026:	74a2                	ld	s1,40(sp)
    80002028:	7902                	ld	s2,32(sp)
    8000202a:	69e2                	ld	s3,24(sp)
    8000202c:	6a42                	ld	s4,16(sp)
    8000202e:	6aa2                	ld	s5,8(sp)
    80002030:	6b02                	ld	s6,0(sp)
    80002032:	6121                	addi	sp,sp,64
    80002034:	8082                	ret

0000000080002036 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80002036:	1141                	addi	sp,sp,-16
    80002038:	e406                	sd	ra,8(sp)
    8000203a:	e022                	sd	s0,0(sp)
    8000203c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000203e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80002040:	2501                	sext.w	a0,a0
    80002042:	60a2                	ld	ra,8(sp)
    80002044:	6402                	ld	s0,0(sp)
    80002046:	0141                	addi	sp,sp,16
    80002048:	8082                	ret

000000008000204a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000204a:	1141                	addi	sp,sp,-16
    8000204c:	e406                	sd	ra,8(sp)
    8000204e:	e022                	sd	s0,0(sp)
    80002050:	0800                	addi	s0,sp,16
    80002052:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80002054:	2781                	sext.w	a5,a5
    80002056:	079e                	slli	a5,a5,0x7
  return c;
}
    80002058:	00010517          	auipc	a0,0x10
    8000205c:	10850513          	addi	a0,a0,264 # 80012160 <cpus>
    80002060:	953e                	add	a0,a0,a5
    80002062:	60a2                	ld	ra,8(sp)
    80002064:	6402                	ld	s0,0(sp)
    80002066:	0141                	addi	sp,sp,16
    80002068:	8082                	ret

000000008000206a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000206a:	1101                	addi	sp,sp,-32
    8000206c:	ec06                	sd	ra,24(sp)
    8000206e:	e822                	sd	s0,16(sp)
    80002070:	e426                	sd	s1,8(sp)
    80002072:	1000                	addi	s0,sp,32
  push_off();
    80002074:	84aff0ef          	jal	800010be <push_off>
    80002078:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000207a:	2781                	sext.w	a5,a5
    8000207c:	079e                	slli	a5,a5,0x7
    8000207e:	00010717          	auipc	a4,0x10
    80002082:	0b270713          	addi	a4,a4,178 # 80012130 <pid_lock>
    80002086:	97ba                	add	a5,a5,a4
    80002088:	7b9c                	ld	a5,48(a5)
    8000208a:	84be                	mv	s1,a5
  pop_off();
    8000208c:	8baff0ef          	jal	80001146 <pop_off>
  return p;
}
    80002090:	8526                	mv	a0,s1
    80002092:	60e2                	ld	ra,24(sp)
    80002094:	6442                	ld	s0,16(sp)
    80002096:	64a2                	ld	s1,8(sp)
    80002098:	6105                	addi	sp,sp,32
    8000209a:	8082                	ret

000000008000209c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000209c:	7179                	addi	sp,sp,-48
    8000209e:	f406                	sd	ra,40(sp)
    800020a0:	f022                	sd	s0,32(sp)
    800020a2:	ec26                	sd	s1,24(sp)
    800020a4:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    800020a6:	fc5ff0ef          	jal	8000206a <myproc>
    800020aa:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    800020ac:	8eaff0ef          	jal	80001196 <release>

  if (first) {
    800020b0:	00008797          	auipc	a5,0x8
    800020b4:	9f07a783          	lw	a5,-1552(a5) # 80009aa0 <first.1>
    800020b8:	cf95                	beqz	a5,800020f4 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    800020ba:	4505                	li	a0,1
    800020bc:	482020ef          	jal	8000453e <fsinit>

    first = 0;
    800020c0:	00008797          	auipc	a5,0x8
    800020c4:	9e07a023          	sw	zero,-1568(a5) # 80009aa0 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    800020c8:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    800020cc:	00007797          	auipc	a5,0x7
    800020d0:	0dc78793          	addi	a5,a5,220 # 800091a8 <etext+0x1a8>
    800020d4:	fcf43823          	sd	a5,-48(s0)
    800020d8:	fc043c23          	sd	zero,-40(s0)
    800020dc:	fd040593          	addi	a1,s0,-48
    800020e0:	853e                	mv	a0,a5
    800020e2:	5e4030ef          	jal	800056c6 <kexec>
    800020e6:	6cbc                	ld	a5,88(s1)
    800020e8:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    800020ea:	6cbc                	ld	a5,88(s1)
    800020ec:	7bb8                	ld	a4,112(a5)
    800020ee:	57fd                	li	a5,-1
    800020f0:	02f70d63          	beq	a4,a5,8000212a <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800020f4:	57f000ef          	jal	80002e72 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800020f8:	68a8                	ld	a0,80(s1)
    800020fa:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800020fc:	04000737          	lui	a4,0x4000
    80002100:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002102:	0732                	slli	a4,a4,0xc
    80002104:	00006797          	auipc	a5,0x6
    80002108:	f9878793          	addi	a5,a5,-104 # 8000809c <userret>
    8000210c:	00006697          	auipc	a3,0x6
    80002110:	ef468693          	addi	a3,a3,-268 # 80008000 <_trampoline>
    80002114:	8f95                	sub	a5,a5,a3
    80002116:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002118:	577d                	li	a4,-1
    8000211a:	177e                	slli	a4,a4,0x3f
    8000211c:	8d59                	or	a0,a0,a4
    8000211e:	9782                	jalr	a5
}
    80002120:	70a2                	ld	ra,40(sp)
    80002122:	7402                	ld	s0,32(sp)
    80002124:	64e2                	ld	s1,24(sp)
    80002126:	6145                	addi	sp,sp,48
    80002128:	8082                	ret
      panic("exec");
    8000212a:	00007517          	auipc	a0,0x7
    8000212e:	08650513          	addi	a0,a0,134 # 800091b0 <etext+0x1b0>
    80002132:	ef2fe0ef          	jal	80000824 <panic>

0000000080002136 <allocpid>:
{
    80002136:	1101                	addi	sp,sp,-32
    80002138:	ec06                	sd	ra,24(sp)
    8000213a:	e822                	sd	s0,16(sp)
    8000213c:	e426                	sd	s1,8(sp)
    8000213e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80002140:	00010517          	auipc	a0,0x10
    80002144:	ff050513          	addi	a0,a0,-16 # 80012130 <pid_lock>
    80002148:	fbbfe0ef          	jal	80001102 <acquire>
  pid = nextpid;
    8000214c:	00008797          	auipc	a5,0x8
    80002150:	95878793          	addi	a5,a5,-1704 # 80009aa4 <nextpid>
    80002154:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80002156:	0014871b          	addiw	a4,s1,1
    8000215a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    8000215c:	00010517          	auipc	a0,0x10
    80002160:	fd450513          	addi	a0,a0,-44 # 80012130 <pid_lock>
    80002164:	832ff0ef          	jal	80001196 <release>
}
    80002168:	8526                	mv	a0,s1
    8000216a:	60e2                	ld	ra,24(sp)
    8000216c:	6442                	ld	s0,16(sp)
    8000216e:	64a2                	ld	s1,8(sp)
    80002170:	6105                	addi	sp,sp,32
    80002172:	8082                	ret

0000000080002174 <proc_pagetable>:
{
    80002174:	1101                	addi	sp,sp,-32
    80002176:	ec06                	sd	ra,24(sp)
    80002178:	e822                	sd	s0,16(sp)
    8000217a:	e426                	sd	s1,8(sp)
    8000217c:	e04a                	sd	s2,0(sp)
    8000217e:	1000                	addi	s0,sp,32
    80002180:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80002182:	d64ff0ef          	jal	800016e6 <uvmcreate>
    80002186:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80002188:	cd05                	beqz	a0,800021c0 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000218a:	4729                	li	a4,10
    8000218c:	00006697          	auipc	a3,0x6
    80002190:	e7468693          	addi	a3,a3,-396 # 80008000 <_trampoline>
    80002194:	6605                	lui	a2,0x1
    80002196:	040005b7          	lui	a1,0x4000
    8000219a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000219c:	05b2                	slli	a1,a1,0xc
    8000219e:	ba0ff0ef          	jal	8000153e <mappages>
    800021a2:	02054663          	bltz	a0,800021ce <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800021a6:	4719                	li	a4,6
    800021a8:	05893683          	ld	a3,88(s2)
    800021ac:	6605                	lui	a2,0x1
    800021ae:	020005b7          	lui	a1,0x2000
    800021b2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800021b4:	05b6                	slli	a1,a1,0xd
    800021b6:	8526                	mv	a0,s1
    800021b8:	b86ff0ef          	jal	8000153e <mappages>
    800021bc:	00054f63          	bltz	a0,800021da <proc_pagetable+0x66>
}
    800021c0:	8526                	mv	a0,s1
    800021c2:	60e2                	ld	ra,24(sp)
    800021c4:	6442                	ld	s0,16(sp)
    800021c6:	64a2                	ld	s1,8(sp)
    800021c8:	6902                	ld	s2,0(sp)
    800021ca:	6105                	addi	sp,sp,32
    800021cc:	8082                	ret
    uvmfree(pagetable, 0);
    800021ce:	4581                	li	a1,0
    800021d0:	8526                	mv	a0,s1
    800021d2:	ff8ff0ef          	jal	800019ca <uvmfree>
    return 0;
    800021d6:	4481                	li	s1,0
    800021d8:	b7e5                	j	800021c0 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800021da:	4681                	li	a3,0
    800021dc:	4605                	li	a2,1
    800021de:	040005b7          	lui	a1,0x4000
    800021e2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800021e4:	05b2                	slli	a1,a1,0xc
    800021e6:	8526                	mv	a0,s1
    800021e8:	d24ff0ef          	jal	8000170c <uvmunmap>
    uvmfree(pagetable, 0);
    800021ec:	4581                	li	a1,0
    800021ee:	8526                	mv	a0,s1
    800021f0:	fdaff0ef          	jal	800019ca <uvmfree>
    return 0;
    800021f4:	4481                	li	s1,0
    800021f6:	b7e9                	j	800021c0 <proc_pagetable+0x4c>

00000000800021f8 <proc_freepagetable>:
{
    800021f8:	1101                	addi	sp,sp,-32
    800021fa:	ec06                	sd	ra,24(sp)
    800021fc:	e822                	sd	s0,16(sp)
    800021fe:	e426                	sd	s1,8(sp)
    80002200:	e04a                	sd	s2,0(sp)
    80002202:	1000                	addi	s0,sp,32
    80002204:	84aa                	mv	s1,a0
    80002206:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002208:	4681                	li	a3,0
    8000220a:	4605                	li	a2,1
    8000220c:	040005b7          	lui	a1,0x4000
    80002210:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002212:	05b2                	slli	a1,a1,0xc
    80002214:	cf8ff0ef          	jal	8000170c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002218:	4681                	li	a3,0
    8000221a:	4605                	li	a2,1
    8000221c:	020005b7          	lui	a1,0x2000
    80002220:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002222:	05b6                	slli	a1,a1,0xd
    80002224:	8526                	mv	a0,s1
    80002226:	ce6ff0ef          	jal	8000170c <uvmunmap>
  uvmfree(pagetable, sz);
    8000222a:	85ca                	mv	a1,s2
    8000222c:	8526                	mv	a0,s1
    8000222e:	f9cff0ef          	jal	800019ca <uvmfree>
}
    80002232:	60e2                	ld	ra,24(sp)
    80002234:	6442                	ld	s0,16(sp)
    80002236:	64a2                	ld	s1,8(sp)
    80002238:	6902                	ld	s2,0(sp)
    8000223a:	6105                	addi	sp,sp,32
    8000223c:	8082                	ret

000000008000223e <freeproc>:
{
    8000223e:	1101                	addi	sp,sp,-32
    80002240:	ec06                	sd	ra,24(sp)
    80002242:	e822                	sd	s0,16(sp)
    80002244:	e426                	sd	s1,8(sp)
    80002246:	1000                	addi	s0,sp,32
    80002248:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000224a:	6d28                	ld	a0,88(a0)
    8000224c:	c119                	beqz	a0,80002252 <freeproc+0x14>
    kfree((void*)p->trapframe);
    8000224e:	80ffe0ef          	jal	80000a5c <kfree>
  p->trapframe = 0;
    80002252:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80002256:	68a8                	ld	a0,80(s1)
    80002258:	c501                	beqz	a0,80002260 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    8000225a:	64ac                	ld	a1,72(s1)
    8000225c:	f9dff0ef          	jal	800021f8 <proc_freepagetable>
  p->pagetable = 0;
    80002260:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80002264:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80002268:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000226c:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80002270:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80002274:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80002278:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000227c:	0204a623          	sw	zero,44(s1)
  acquire(&frame_lock);
    80002280:	00010517          	auipc	a0,0x10
    80002284:	99850513          	addi	a0,a0,-1640 # 80011c18 <frame_lock>
    80002288:	e7bfe0ef          	jal	80001102 <acquire>
  for(int i = 0; i < MAX_FRAMES; i++){
    8000228c:	00010797          	auipc	a5,0x10
    80002290:	9ac78793          	addi	a5,a5,-1620 # 80011c38 <frame_table+0x8>
    80002294:	00010697          	auipc	a3,0x10
    80002298:	ea468693          	addi	a3,a3,-348 # 80012138 <pid_lock+0x8>
    8000229c:	a029                	j	800022a6 <freeproc+0x68>
    8000229e:	02878793          	addi	a5,a5,40
    800022a2:	00d78a63          	beq	a5,a3,800022b6 <freeproc+0x78>
    if(frame_table[i].proc == p){
    800022a6:	6398                	ld	a4,0(a5)
    800022a8:	fe971be3          	bne	a4,s1,8000229e <freeproc+0x60>
      frame_table[i].used = 0;
    800022ac:	fe07ac23          	sw	zero,-8(a5)
      frame_table[i].proc = 0;
    800022b0:	0007b023          	sd	zero,0(a5)
    800022b4:	b7ed                	j	8000229e <freeproc+0x60>
  release(&frame_lock);
    800022b6:	00010517          	auipc	a0,0x10
    800022ba:	96250513          	addi	a0,a0,-1694 # 80011c18 <frame_lock>
    800022be:	ed9fe0ef          	jal	80001196 <release>
  acquire(&swap_lock);
    800022c2:	00017517          	auipc	a0,0x17
    800022c6:	4b650513          	addi	a0,a0,1206 # 80019778 <swap_lock>
    800022ca:	e39fe0ef          	jal	80001102 <acquire>
  for(int i = 0; i < MAX_SWAP; i++){
    800022ce:	00017797          	auipc	a5,0x17
    800022d2:	4ca78793          	addi	a5,a5,1226 # 80019798 <swap_space+0x8>
    800022d6:	00018697          	auipc	a3,0x18
    800022da:	4c268693          	addi	a3,a3,1218 # 8001a798 <bcache+0x8>
    800022de:	a029                	j	800022e8 <freeproc+0xaa>
    800022e0:	02078793          	addi	a5,a5,32
    800022e4:	00d78a63          	beq	a5,a3,800022f8 <freeproc+0xba>
    if(swap_space[i].proc == p){
    800022e8:	6398                	ld	a4,0(a5)
    800022ea:	fe971be3          	bne	a4,s1,800022e0 <freeproc+0xa2>
      swap_space[i].used = 0;
    800022ee:	fe07ac23          	sw	zero,-8(a5)
      swap_space[i].proc = 0;
    800022f2:	0007b023          	sd	zero,0(a5)
    800022f6:	b7ed                	j	800022e0 <freeproc+0xa2>
  release(&swap_lock);
    800022f8:	00017517          	auipc	a0,0x17
    800022fc:	48050513          	addi	a0,a0,1152 # 80019778 <swap_lock>
    80002300:	e97fe0ef          	jal	80001196 <release>
  p->state = UNUSED;
    80002304:	0004ac23          	sw	zero,24(s1)
}
    80002308:	60e2                	ld	ra,24(sp)
    8000230a:	6442                	ld	s0,16(sp)
    8000230c:	64a2                	ld	s1,8(sp)
    8000230e:	6105                	addi	sp,sp,32
    80002310:	8082                	ret

0000000080002312 <allocproc>:
{
    80002312:	1101                	addi	sp,sp,-32
    80002314:	ec06                	sd	ra,24(sp)
    80002316:	e822                	sd	s0,16(sp)
    80002318:	e426                	sd	s1,8(sp)
    8000231a:	e04a                	sd	s2,0(sp)
    8000231c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000231e:	00010497          	auipc	s1,0x10
    80002322:	24248493          	addi	s1,s1,578 # 80012560 <proc>
    80002326:	00017917          	auipc	s2,0x17
    8000232a:	43a90913          	addi	s2,s2,1082 # 80019760 <tickslock>
    acquire(&p->lock);
    8000232e:	8526                	mv	a0,s1
    80002330:	dd3fe0ef          	jal	80001102 <acquire>
    if(p->state == UNUSED) {
    80002334:	4c9c                	lw	a5,24(s1)
    80002336:	cb91                	beqz	a5,8000234a <allocproc+0x38>
      release(&p->lock);
    80002338:	8526                	mv	a0,s1
    8000233a:	e5dfe0ef          	jal	80001196 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000233e:	1c848493          	addi	s1,s1,456
    80002342:	ff2496e3          	bne	s1,s2,8000232e <allocproc+0x1c>
  return 0;
    80002346:	4481                	li	s1,0
    80002348:	a069                	j	800023d2 <allocproc+0xc0>
  p->level=0; //Initialise level to zero
    8000234a:	1604a823          	sw	zero,368(s1)
  p->used_ticks=0;
    8000234e:	1604aa23          	sw	zero,372(s1)
  p->times_scheduled=0;
    80002352:	1804a423          	sw	zero,392(s1)
  p->slice_start_syscount=0;
    80002356:	1804a623          	sw	zero,396(s1)
    p->total_ticks[i] = 0;
    8000235a:	1604ac23          	sw	zero,376(s1)
    8000235e:	1604ae23          	sw	zero,380(s1)
    80002362:	1804a023          	sw	zero,384(s1)
    80002366:	1804a223          	sw	zero,388(s1)
  p->page_faults = 0;
    8000236a:	1804a823          	sw	zero,400(s1)
  p->pages_evicted = 0;
    8000236e:	1804aa23          	sw	zero,404(s1)
  p->pages_swapped_in = 0;
    80002372:	1804ac23          	sw	zero,408(s1)
  p->pages_swapped_out = 0;
    80002376:	1804ae23          	sw	zero,412(s1)
  p->resident_pages = 0;
    8000237a:	1a04a023          	sw	zero,416(s1)
p->disk_reads = 0;
    8000237e:	1a04b423          	sd	zero,424(s1)
p->disk_writes = 0;
    80002382:	1a04b823          	sd	zero,432(s1)
p->total_disk_latency = 0;
    80002386:	1a04bc23          	sd	zero,440(s1)
p->disk_ops = 0;
    8000238a:	1c04a023          	sw	zero,448(s1)
  p->pid = allocpid();
    8000238e:	da9ff0ef          	jal	80002136 <allocpid>
    80002392:	d888                	sw	a0,48(s1)
  p->state = USED;
    80002394:	4785                	li	a5,1
    80002396:	cc9c                	sw	a5,24(s1)
  p->syscount = 0;
    80002398:	1604b423          	sd	zero,360(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000239c:	fecfe0ef          	jal	80000b88 <kalloc>
    800023a0:	892a                	mv	s2,a0
    800023a2:	eca8                	sd	a0,88(s1)
    800023a4:	cd15                	beqz	a0,800023e0 <allocproc+0xce>
  p->pagetable = proc_pagetable(p);
    800023a6:	8526                	mv	a0,s1
    800023a8:	dcdff0ef          	jal	80002174 <proc_pagetable>
    800023ac:	892a                	mv	s2,a0
    800023ae:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800023b0:	c121                	beqz	a0,800023f0 <allocproc+0xde>
  memset(&p->context, 0, sizeof(p->context));
    800023b2:	07000613          	li	a2,112
    800023b6:	4581                	li	a1,0
    800023b8:	06048513          	addi	a0,s1,96
    800023bc:	e17fe0ef          	jal	800011d2 <memset>
  p->context.ra = (uint64)forkret;
    800023c0:	00000797          	auipc	a5,0x0
    800023c4:	cdc78793          	addi	a5,a5,-804 # 8000209c <forkret>
    800023c8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800023ca:	60bc                	ld	a5,64(s1)
    800023cc:	6705                	lui	a4,0x1
    800023ce:	97ba                	add	a5,a5,a4
    800023d0:	f4bc                	sd	a5,104(s1)
}
    800023d2:	8526                	mv	a0,s1
    800023d4:	60e2                	ld	ra,24(sp)
    800023d6:	6442                	ld	s0,16(sp)
    800023d8:	64a2                	ld	s1,8(sp)
    800023da:	6902                	ld	s2,0(sp)
    800023dc:	6105                	addi	sp,sp,32
    800023de:	8082                	ret
    freeproc(p);
    800023e0:	8526                	mv	a0,s1
    800023e2:	e5dff0ef          	jal	8000223e <freeproc>
    release(&p->lock);
    800023e6:	8526                	mv	a0,s1
    800023e8:	daffe0ef          	jal	80001196 <release>
    return 0;
    800023ec:	84ca                	mv	s1,s2
    800023ee:	b7d5                	j	800023d2 <allocproc+0xc0>
    freeproc(p);
    800023f0:	8526                	mv	a0,s1
    800023f2:	e4dff0ef          	jal	8000223e <freeproc>
    release(&p->lock);
    800023f6:	8526                	mv	a0,s1
    800023f8:	d9ffe0ef          	jal	80001196 <release>
    return 0;
    800023fc:	84ca                	mv	s1,s2
    800023fe:	bfd1                	j	800023d2 <allocproc+0xc0>

0000000080002400 <userinit>:
{
    80002400:	1101                	addi	sp,sp,-32
    80002402:	ec06                	sd	ra,24(sp)
    80002404:	e822                	sd	s0,16(sp)
    80002406:	e426                	sd	s1,8(sp)
    80002408:	1000                	addi	s0,sp,32
  p = allocproc();
    8000240a:	f09ff0ef          	jal	80002312 <allocproc>
    8000240e:	84aa                	mv	s1,a0
  initproc = p;
    80002410:	00007797          	auipc	a5,0x7
    80002414:	6ca7bc23          	sd	a0,1752(a5) # 80009ae8 <initproc>
  p->cwd = namei("/");
    80002418:	00007517          	auipc	a0,0x7
    8000241c:	da050513          	addi	a0,a0,-608 # 800091b8 <etext+0x1b8>
    80002420:	658020ef          	jal	80004a78 <namei>
    80002424:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80002428:	478d                	li	a5,3
    8000242a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000242c:	8526                	mv	a0,s1
    8000242e:	d69fe0ef          	jal	80001196 <release>
}
    80002432:	60e2                	ld	ra,24(sp)
    80002434:	6442                	ld	s0,16(sp)
    80002436:	64a2                	ld	s1,8(sp)
    80002438:	6105                	addi	sp,sp,32
    8000243a:	8082                	ret

000000008000243c <growproc>:
{
    8000243c:	1101                	addi	sp,sp,-32
    8000243e:	ec06                	sd	ra,24(sp)
    80002440:	e822                	sd	s0,16(sp)
    80002442:	e426                	sd	s1,8(sp)
    80002444:	e04a                	sd	s2,0(sp)
    80002446:	1000                	addi	s0,sp,32
    80002448:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000244a:	c21ff0ef          	jal	8000206a <myproc>
    8000244e:	892a                	mv	s2,a0
  sz = p->sz;
    80002450:	652c                	ld	a1,72(a0)
  if(n > 0){
    80002452:	02905963          	blez	s1,80002484 <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80002456:	00b48633          	add	a2,s1,a1
    8000245a:	020007b7          	lui	a5,0x2000
    8000245e:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002460:	07b6                	slli	a5,a5,0xd
    80002462:	02c7ea63          	bltu	a5,a2,80002496 <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80002466:	4691                	li	a3,4
    80002468:	6928                	ld	a0,80(a0)
    8000246a:	c54ff0ef          	jal	800018be <uvmalloc>
    8000246e:	85aa                	mv	a1,a0
    80002470:	c50d                	beqz	a0,8000249a <growproc+0x5e>
  p->sz = sz;
    80002472:	04b93423          	sd	a1,72(s2)
  return 0;
    80002476:	4501                	li	a0,0
}
    80002478:	60e2                	ld	ra,24(sp)
    8000247a:	6442                	ld	s0,16(sp)
    8000247c:	64a2                	ld	s1,8(sp)
    8000247e:	6902                	ld	s2,0(sp)
    80002480:	6105                	addi	sp,sp,32
    80002482:	8082                	ret
  } else if(n < 0){
    80002484:	fe04d7e3          	bgez	s1,80002472 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002488:	00b48633          	add	a2,s1,a1
    8000248c:	6928                	ld	a0,80(a0)
    8000248e:	b84ff0ef          	jal	80001812 <uvmdealloc>
    80002492:	85aa                	mv	a1,a0
    80002494:	bff9                	j	80002472 <growproc+0x36>
      return -1;
    80002496:	557d                	li	a0,-1
    80002498:	b7c5                	j	80002478 <growproc+0x3c>
      return -1;
    8000249a:	557d                	li	a0,-1
    8000249c:	bff1                	j	80002478 <growproc+0x3c>

000000008000249e <kfork>:
{
    8000249e:	7139                	addi	sp,sp,-64
    800024a0:	fc06                	sd	ra,56(sp)
    800024a2:	f822                	sd	s0,48(sp)
    800024a4:	f426                	sd	s1,40(sp)
    800024a6:	e456                	sd	s5,8(sp)
    800024a8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800024aa:	bc1ff0ef          	jal	8000206a <myproc>
    800024ae:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800024b0:	e63ff0ef          	jal	80002312 <allocproc>
    800024b4:	0e050b63          	beqz	a0,800025aa <kfork+0x10c>
    800024b8:	ec4e                	sd	s3,24(sp)
    800024ba:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz, np) < 0){
    800024bc:	86aa                	mv	a3,a0
    800024be:	048ab603          	ld	a2,72(s5)
    800024c2:	692c                	ld	a1,80(a0)
    800024c4:	050ab503          	ld	a0,80(s5)
    800024c8:	d34ff0ef          	jal	800019fc <uvmcopy>
    800024cc:	04054863          	bltz	a0,8000251c <kfork+0x7e>
    800024d0:	f04a                	sd	s2,32(sp)
    800024d2:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800024d4:	048ab783          	ld	a5,72(s5)
    800024d8:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800024dc:	058ab683          	ld	a3,88(s5)
    800024e0:	87b6                	mv	a5,a3
    800024e2:	0589b703          	ld	a4,88(s3)
    800024e6:	12068693          	addi	a3,a3,288
    800024ea:	6388                	ld	a0,0(a5)
    800024ec:	678c                	ld	a1,8(a5)
    800024ee:	6b90                	ld	a2,16(a5)
    800024f0:	e308                	sd	a0,0(a4)
    800024f2:	e70c                	sd	a1,8(a4)
    800024f4:	eb10                	sd	a2,16(a4)
    800024f6:	6f90                	ld	a2,24(a5)
    800024f8:	ef10                	sd	a2,24(a4)
    800024fa:	02078793          	addi	a5,a5,32
    800024fe:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80002502:	fed794e3          	bne	a5,a3,800024ea <kfork+0x4c>
  np->trapframe->a0 = 0;
    80002506:	0589b783          	ld	a5,88(s3)
    8000250a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000250e:	0d0a8493          	addi	s1,s5,208
    80002512:	0d098913          	addi	s2,s3,208
    80002516:	150a8a13          	addi	s4,s5,336
    8000251a:	a831                	j	80002536 <kfork+0x98>
    freeproc(np);
    8000251c:	854e                	mv	a0,s3
    8000251e:	d21ff0ef          	jal	8000223e <freeproc>
    release(&np->lock);
    80002522:	854e                	mv	a0,s3
    80002524:	c73fe0ef          	jal	80001196 <release>
    return -1;
    80002528:	54fd                	li	s1,-1
    8000252a:	69e2                	ld	s3,24(sp)
    8000252c:	a885                	j	8000259c <kfork+0xfe>
  for(i = 0; i < NOFILE; i++)
    8000252e:	04a1                	addi	s1,s1,8
    80002530:	0921                	addi	s2,s2,8
    80002532:	01448963          	beq	s1,s4,80002544 <kfork+0xa6>
    if(p->ofile[i])
    80002536:	6088                	ld	a0,0(s1)
    80002538:	d97d                	beqz	a0,8000252e <kfork+0x90>
      np->ofile[i] = filedup(p->ofile[i]);
    8000253a:	2fb020ef          	jal	80005034 <filedup>
    8000253e:	00a93023          	sd	a0,0(s2)
    80002542:	b7f5                	j	8000252e <kfork+0x90>
  np->cwd = idup(p->cwd);
    80002544:	150ab503          	ld	a0,336(s5)
    80002548:	4cd010ef          	jal	80004214 <idup>
    8000254c:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002550:	4641                	li	a2,16
    80002552:	158a8593          	addi	a1,s5,344
    80002556:	15898513          	addi	a0,s3,344
    8000255a:	dcdfe0ef          	jal	80001326 <safestrcpy>
  pid = np->pid;
    8000255e:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80002562:	854e                	mv	a0,s3
    80002564:	c33fe0ef          	jal	80001196 <release>
  acquire(&wait_lock);
    80002568:	00010517          	auipc	a0,0x10
    8000256c:	be050513          	addi	a0,a0,-1056 # 80012148 <wait_lock>
    80002570:	b93fe0ef          	jal	80001102 <acquire>
  np->parent = p;
    80002574:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80002578:	00010517          	auipc	a0,0x10
    8000257c:	bd050513          	addi	a0,a0,-1072 # 80012148 <wait_lock>
    80002580:	c17fe0ef          	jal	80001196 <release>
  acquire(&np->lock);
    80002584:	854e                	mv	a0,s3
    80002586:	b7dfe0ef          	jal	80001102 <acquire>
  np->state = RUNNABLE;
    8000258a:	478d                	li	a5,3
    8000258c:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002590:	854e                	mv	a0,s3
    80002592:	c05fe0ef          	jal	80001196 <release>
  return pid;
    80002596:	7902                	ld	s2,32(sp)
    80002598:	69e2                	ld	s3,24(sp)
    8000259a:	6a42                	ld	s4,16(sp)
}
    8000259c:	8526                	mv	a0,s1
    8000259e:	70e2                	ld	ra,56(sp)
    800025a0:	7442                	ld	s0,48(sp)
    800025a2:	74a2                	ld	s1,40(sp)
    800025a4:	6aa2                	ld	s5,8(sp)
    800025a6:	6121                	addi	sp,sp,64
    800025a8:	8082                	ret
    return -1;
    800025aa:	54fd                	li	s1,-1
    800025ac:	bfc5                	j	8000259c <kfork+0xfe>

00000000800025ae <scheduler>:
{
    800025ae:	7119                	addi	sp,sp,-128
    800025b0:	fc86                	sd	ra,120(sp)
    800025b2:	f8a2                	sd	s0,112(sp)
    800025b4:	f4a6                	sd	s1,104(sp)
    800025b6:	f0ca                	sd	s2,96(sp)
    800025b8:	ecce                	sd	s3,88(sp)
    800025ba:	e8d2                	sd	s4,80(sp)
    800025bc:	e4d6                	sd	s5,72(sp)
    800025be:	e0da                	sd	s6,64(sp)
    800025c0:	fc5e                	sd	s7,56(sp)
    800025c2:	f862                	sd	s8,48(sp)
    800025c4:	f466                	sd	s9,40(sp)
    800025c6:	f06a                	sd	s10,32(sp)
    800025c8:	ec6e                	sd	s11,24(sp)
    800025ca:	0100                	addi	s0,sp,128
    800025cc:	8d92                	mv	s11,tp
  int id = r_tp();
    800025ce:	2d81                	sext.w	s11,s11
  c->proc = 0;
    800025d0:	007d9713          	slli	a4,s11,0x7
    800025d4:	00010797          	auipc	a5,0x10
    800025d8:	b5c78793          	addi	a5,a5,-1188 # 80012130 <pid_lock>
    800025dc:	97ba                	add	a5,a5,a4
    800025de:	0207b823          	sd	zero,48(a5)
          swtch(&c->context, &p->context);
    800025e2:	00010797          	auipc	a5,0x10
    800025e6:	b8678793          	addi	a5,a5,-1146 # 80012168 <cpus+0x8>
    800025ea:	97ba                	add	a5,a5,a4
    800025ec:	f8f43423          	sd	a5,-120(s0)
    800025f0:	1c800b13          	li	s6,456
        p = &proc[index];
    800025f4:	00010a97          	auipc	s5,0x10
    800025f8:	f6ca8a93          	addi	s5,s5,-148 # 80012560 <proc>
      for(int offset = 0; offset < NPROC; offset++){
    800025fc:	04000c93          	li	s9,64
    80002600:	a2a9                	j	8000274a <scheduler+0x19c>
      prev_b = ticks;
    80002602:	00007797          	auipc	a5,0x7
    80002606:	4ee7a123          	sw	a4,1250(a5) # 80009ae4 <prev_b.3>
      for(p = proc; p < &proc[NPROC]; p++){
    8000260a:	00010497          	auipc	s1,0x10
    8000260e:	f5648493          	addi	s1,s1,-170 # 80012560 <proc>
        if(p->state == RUNNABLE || p->state == RUNNING){
    80002612:	4985                	li	s3,1
      for(p = proc; p < &proc[NPROC]; p++){
    80002614:	00017917          	auipc	s2,0x17
    80002618:	14c90913          	addi	s2,s2,332 # 80019760 <tickslock>
    8000261c:	a801                	j	8000262c <scheduler+0x7e>
        release(&p->lock);
    8000261e:	8526                	mv	a0,s1
    80002620:	b77fe0ef          	jal	80001196 <release>
      for(p = proc; p < &proc[NPROC]; p++){
    80002624:	1c848493          	addi	s1,s1,456
    80002628:	17248063          	beq	s1,s2,80002788 <scheduler+0x1da>
        acquire(&p->lock);
    8000262c:	8526                	mv	a0,s1
    8000262e:	ad5fe0ef          	jal	80001102 <acquire>
        if(p->state == RUNNABLE || p->state == RUNNING){
    80002632:	4c9c                	lw	a5,24(s1)
    80002634:	37f5                	addiw	a5,a5,-3
    80002636:	fef9e4e3          	bltu	s3,a5,8000261e <scheduler+0x70>
          p->level = 0;
    8000263a:	1604a823          	sw	zero,368(s1)
          p->used_ticks = 0;
    8000263e:	1604aa23          	sw	zero,372(s1)
    80002642:	bff1                	j	8000261e <scheduler+0x70>
                p->level++;
    80002644:	2705                	addiw	a4,a4,1
    80002646:	16e92823          	sw	a4,368(s2)
    8000264a:	a8f9                	j	80002728 <scheduler+0x17a>
    for(int level = 0; level < 4; level++){
    8000264c:	2d05                	addiw	s10,s10,1 # fffffffffffff001 <end+0xffffffff7fdd7c69>
    8000264e:	4791                	li	a5,4
    80002650:	00fd0563          	beq	s10,a5,8000265a <scheduler+0xac>
      for(int offset = 0; offset < NPROC; offset++){
    80002654:	4981                	li	s3,0
        if(p->state == RUNNABLE && p->level == level){
    80002656:	4b8d                	li	s7,3
    80002658:	a811                	j	8000266c <scheduler+0xbe>
      asm volatile("wfi");
    8000265a:	10500073          	wfi
    8000265e:	a0f5                	j	8000274a <scheduler+0x19c>
        release(&p->lock);
    80002660:	854a                	mv	a0,s2
    80002662:	b35fe0ef          	jal	80001196 <release>
      for(int offset = 0; offset < NPROC; offset++){
    80002666:	2985                	addiw	s3,s3,1
    80002668:	ff9982e3          	beq	s3,s9,8000264c <scheduler+0x9e>
        int index = (prev_i + offset) % NPROC;
    8000266c:	000c2483          	lw	s1,0(s8) # fffffffffffff000 <end+0xffffffff7fdd7c68>
    80002670:	013484bb          	addw	s1,s1,s3
    80002674:	41f4d79b          	sraiw	a5,s1,0x1f
    80002678:	01a7d79b          	srliw	a5,a5,0x1a
    8000267c:	9cbd                	addw	s1,s1,a5
    8000267e:	03f4f493          	andi	s1,s1,63
    80002682:	9c9d                	subw	s1,s1,a5
        p = &proc[index];
    80002684:	03648a33          	mul	s4,s1,s6
    80002688:	015a0933          	add	s2,s4,s5
        acquire(&p->lock);
    8000268c:	854a                	mv	a0,s2
    8000268e:	a75fe0ef          	jal	80001102 <acquire>
        if(p->state == RUNNABLE && p->level == level){
    80002692:	01892783          	lw	a5,24(s2)
    80002696:	fd7795e3          	bne	a5,s7,80002660 <scheduler+0xb2>
    8000269a:	17092783          	lw	a5,368(s2)
    8000269e:	fda791e3          	bne	a5,s10,80002660 <scheduler+0xb2>
          p->times_scheduled += 1;
    800026a2:	18892783          	lw	a5,392(s2)
    800026a6:	2785                	addiw	a5,a5,1
    800026a8:	18f92423          	sw	a5,392(s2)
          p->slice_start_syscount = p->syscount;
    800026ac:	16893783          	ld	a5,360(s2)
    800026b0:	18f92623          	sw	a5,396(s2)
          p->state = RUNNING;
    800026b4:	4791                	li	a5,4
    800026b6:	00f92c23          	sw	a5,24(s2)
          c->proc = p;
    800026ba:	007d9713          	slli	a4,s11,0x7
    800026be:	00010797          	auipc	a5,0x10
    800026c2:	a7278793          	addi	a5,a5,-1422 # 80012130 <pid_lock>
    800026c6:	97ba                	add	a5,a5,a4
    800026c8:	0327b823          	sd	s2,48(a5)
          prev_i = (index + 1) % NPROC;
    800026cc:	0014879b          	addiw	a5,s1,1
    800026d0:	41f7d71b          	sraiw	a4,a5,0x1f
    800026d4:	01a7571b          	srliw	a4,a4,0x1a
    800026d8:	9fb9                	addw	a5,a5,a4
    800026da:	03f7f793          	andi	a5,a5,63
    800026de:	9f99                	subw	a5,a5,a4
    800026e0:	00007717          	auipc	a4,0x7
    800026e4:	40f72023          	sw	a5,1024(a4) # 80009ae0 <prev_i.2>
          swtch(&c->context, &p->context);
    800026e8:	060a0593          	addi	a1,s4,96
    800026ec:	95d6                	add	a1,a1,s5
    800026ee:	f8843503          	ld	a0,-120(s0)
    800026f2:	6d6000ef          	jal	80002dc8 <swtch>
          int delT = p->used_ticks;
    800026f6:	17492683          	lw	a3,372(s2)
          if(p->used_ticks >= quantum_times[p->level]){
    800026fa:	17092703          	lw	a4,368(s2)
    800026fe:	00271613          	slli	a2,a4,0x2
    80002702:	00007797          	auipc	a5,0x7
    80002706:	3ae78793          	addi	a5,a5,942 # 80009ab0 <quantum_times>
    8000270a:	97b2                	add	a5,a5,a2
    8000270c:	439c                	lw	a5,0(a5)
    8000270e:	02f6c263          	blt	a3,a5,80002732 <scheduler+0x184>
          int delS = p->syscount - p->slice_start_syscount;
    80002712:	16893603          	ld	a2,360(s2)
    80002716:	18c92783          	lw	a5,396(s2)
    8000271a:	40f607bb          	subw	a5,a2,a5
              if(p->level < 3){
    8000271e:	00d7d563          	bge	a5,a3,80002728 <scheduler+0x17a>
    80002722:	00372793          	slti	a5,a4,3
    80002726:	ff99                	bnez	a5,80002644 <scheduler+0x96>
            p->used_ticks = 0;
    80002728:	036484b3          	mul	s1,s1,s6
    8000272c:	94d6                	add	s1,s1,s5
    8000272e:	1604aa23          	sw	zero,372(s1)
          c->proc = 0;
    80002732:	007d9713          	slli	a4,s11,0x7
    80002736:	00010797          	auipc	a5,0x10
    8000273a:	9fa78793          	addi	a5,a5,-1542 # 80012130 <pid_lock>
    8000273e:	97ba                	add	a5,a5,a4
    80002740:	0207b823          	sd	zero,48(a5)
        release(&p->lock);
    80002744:	854a                	mv	a0,s2
    80002746:	a51fe0ef          	jal	80001196 <release>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000274a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000274e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002752:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002756:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000275a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000275c:	10079073          	csrw	sstatus,a5
    acquire(&tickslock);
    80002760:	00017517          	auipc	a0,0x17
    80002764:	00050513          	mv	a0,a0
    80002768:	99bfe0ef          	jal	80001102 <acquire>
    if(ticks - prev_b >= 128){     
    8000276c:	00007717          	auipc	a4,0x7
    80002770:	38472703          	lw	a4,900(a4) # 80009af0 <ticks>
    80002774:	00007797          	auipc	a5,0x7
    80002778:	3707a783          	lw	a5,880(a5) # 80009ae4 <prev_b.3>
    8000277c:	40f707bb          	subw	a5,a4,a5
    80002780:	07f00693          	li	a3,127
    80002784:	e6f6efe3          	bltu	a3,a5,80002602 <scheduler+0x54>
    release(&tickslock);
    80002788:	00017517          	auipc	a0,0x17
    8000278c:	fd850513          	addi	a0,a0,-40 # 80019760 <tickslock>
    80002790:	a07fe0ef          	jal	80001196 <release>
    for(int level = 0; level < 4; level++){
    80002794:	4d01                	li	s10,0
        int index = (prev_i + offset) % NPROC;
    80002796:	00007c17          	auipc	s8,0x7
    8000279a:	34ac0c13          	addi	s8,s8,842 # 80009ae0 <prev_i.2>
    8000279e:	bd5d                	j	80002654 <scheduler+0xa6>

00000000800027a0 <sched>:
{
    800027a0:	7179                	addi	sp,sp,-48
    800027a2:	f406                	sd	ra,40(sp)
    800027a4:	f022                	sd	s0,32(sp)
    800027a6:	ec26                	sd	s1,24(sp)
    800027a8:	e84a                	sd	s2,16(sp)
    800027aa:	e44e                	sd	s3,8(sp)
    800027ac:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800027ae:	8bdff0ef          	jal	8000206a <myproc>
    800027b2:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800027b4:	8dffe0ef          	jal	80001092 <holding>
    800027b8:	c935                	beqz	a0,8000282c <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    800027ba:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800027bc:	2781                	sext.w	a5,a5
    800027be:	079e                	slli	a5,a5,0x7
    800027c0:	00010717          	auipc	a4,0x10
    800027c4:	97070713          	addi	a4,a4,-1680 # 80012130 <pid_lock>
    800027c8:	97ba                	add	a5,a5,a4
    800027ca:	0a87a703          	lw	a4,168(a5)
    800027ce:	4785                	li	a5,1
    800027d0:	06f71463          	bne	a4,a5,80002838 <sched+0x98>
  if(p->state == RUNNING)
    800027d4:	4c98                	lw	a4,24(s1)
    800027d6:	4791                	li	a5,4
    800027d8:	06f70663          	beq	a4,a5,80002844 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027dc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800027e0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800027e2:	e7bd                	bnez	a5,80002850 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    800027e4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800027e6:	00010917          	auipc	s2,0x10
    800027ea:	94a90913          	addi	s2,s2,-1718 # 80012130 <pid_lock>
    800027ee:	2781                	sext.w	a5,a5
    800027f0:	079e                	slli	a5,a5,0x7
    800027f2:	97ca                	add	a5,a5,s2
    800027f4:	0ac7a983          	lw	s3,172(a5)
    800027f8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800027fa:	2781                	sext.w	a5,a5
    800027fc:	079e                	slli	a5,a5,0x7
    800027fe:	07a1                	addi	a5,a5,8
    80002800:	00010597          	auipc	a1,0x10
    80002804:	96058593          	addi	a1,a1,-1696 # 80012160 <cpus>
    80002808:	95be                	add	a1,a1,a5
    8000280a:	06048513          	addi	a0,s1,96
    8000280e:	5ba000ef          	jal	80002dc8 <swtch>
    80002812:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002814:	2781                	sext.w	a5,a5
    80002816:	079e                	slli	a5,a5,0x7
    80002818:	993e                	add	s2,s2,a5
    8000281a:	0b392623          	sw	s3,172(s2)
}
    8000281e:	70a2                	ld	ra,40(sp)
    80002820:	7402                	ld	s0,32(sp)
    80002822:	64e2                	ld	s1,24(sp)
    80002824:	6942                	ld	s2,16(sp)
    80002826:	69a2                	ld	s3,8(sp)
    80002828:	6145                	addi	sp,sp,48
    8000282a:	8082                	ret
    panic("sched p->lock");
    8000282c:	00007517          	auipc	a0,0x7
    80002830:	99450513          	addi	a0,a0,-1644 # 800091c0 <etext+0x1c0>
    80002834:	ff1fd0ef          	jal	80000824 <panic>
    panic("sched locks");
    80002838:	00007517          	auipc	a0,0x7
    8000283c:	99850513          	addi	a0,a0,-1640 # 800091d0 <etext+0x1d0>
    80002840:	fe5fd0ef          	jal	80000824 <panic>
    panic("sched RUNNING");
    80002844:	00007517          	auipc	a0,0x7
    80002848:	99c50513          	addi	a0,a0,-1636 # 800091e0 <etext+0x1e0>
    8000284c:	fd9fd0ef          	jal	80000824 <panic>
    panic("sched interruptible");
    80002850:	00007517          	auipc	a0,0x7
    80002854:	9a050513          	addi	a0,a0,-1632 # 800091f0 <etext+0x1f0>
    80002858:	fcdfd0ef          	jal	80000824 <panic>

000000008000285c <yield>:
{
    8000285c:	1101                	addi	sp,sp,-32
    8000285e:	ec06                	sd	ra,24(sp)
    80002860:	e822                	sd	s0,16(sp)
    80002862:	e426                	sd	s1,8(sp)
    80002864:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002866:	805ff0ef          	jal	8000206a <myproc>
    8000286a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000286c:	897fe0ef          	jal	80001102 <acquire>
  p->state = RUNNABLE;
    80002870:	478d                	li	a5,3
    80002872:	cc9c                	sw	a5,24(s1)
  sched();
    80002874:	f2dff0ef          	jal	800027a0 <sched>
  release(&p->lock);
    80002878:	8526                	mv	a0,s1
    8000287a:	91dfe0ef          	jal	80001196 <release>
}
    8000287e:	60e2                	ld	ra,24(sp)
    80002880:	6442                	ld	s0,16(sp)
    80002882:	64a2                	ld	s1,8(sp)
    80002884:	6105                	addi	sp,sp,32
    80002886:	8082                	ret

0000000080002888 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002888:	7179                	addi	sp,sp,-48
    8000288a:	f406                	sd	ra,40(sp)
    8000288c:	f022                	sd	s0,32(sp)
    8000288e:	ec26                	sd	s1,24(sp)
    80002890:	e84a                	sd	s2,16(sp)
    80002892:	e44e                	sd	s3,8(sp)
    80002894:	1800                	addi	s0,sp,48
    80002896:	89aa                	mv	s3,a0
    80002898:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000289a:	fd0ff0ef          	jal	8000206a <myproc>
    8000289e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800028a0:	863fe0ef          	jal	80001102 <acquire>
  release(lk);
    800028a4:	854a                	mv	a0,s2
    800028a6:	8f1fe0ef          	jal	80001196 <release>

  // Go to sleep.
  p->chan = chan;
    800028aa:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800028ae:	4789                	li	a5,2
    800028b0:	cc9c                	sw	a5,24(s1)

  sched();
    800028b2:	eefff0ef          	jal	800027a0 <sched>

  // Tidy up.
  p->chan = 0;
    800028b6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800028ba:	8526                	mv	a0,s1
    800028bc:	8dbfe0ef          	jal	80001196 <release>
  acquire(lk);
    800028c0:	854a                	mv	a0,s2
    800028c2:	841fe0ef          	jal	80001102 <acquire>
}
    800028c6:	70a2                	ld	ra,40(sp)
    800028c8:	7402                	ld	s0,32(sp)
    800028ca:	64e2                	ld	s1,24(sp)
    800028cc:	6942                	ld	s2,16(sp)
    800028ce:	69a2                	ld	s3,8(sp)
    800028d0:	6145                	addi	sp,sp,48
    800028d2:	8082                	ret

00000000800028d4 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    800028d4:	7139                	addi	sp,sp,-64
    800028d6:	fc06                	sd	ra,56(sp)
    800028d8:	f822                	sd	s0,48(sp)
    800028da:	f426                	sd	s1,40(sp)
    800028dc:	f04a                	sd	s2,32(sp)
    800028de:	ec4e                	sd	s3,24(sp)
    800028e0:	e852                	sd	s4,16(sp)
    800028e2:	e456                	sd	s5,8(sp)
    800028e4:	0080                	addi	s0,sp,64
    800028e6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800028e8:	00010497          	auipc	s1,0x10
    800028ec:	c7848493          	addi	s1,s1,-904 # 80012560 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800028f0:	4989                	li	s3,2
        p->state = RUNNABLE;
    800028f2:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800028f4:	00017917          	auipc	s2,0x17
    800028f8:	e6c90913          	addi	s2,s2,-404 # 80019760 <tickslock>
    800028fc:	a801                	j	8000290c <wakeup+0x38>
      }
      release(&p->lock);
    800028fe:	8526                	mv	a0,s1
    80002900:	897fe0ef          	jal	80001196 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002904:	1c848493          	addi	s1,s1,456
    80002908:	03248263          	beq	s1,s2,8000292c <wakeup+0x58>
    if(p != myproc()){
    8000290c:	f5eff0ef          	jal	8000206a <myproc>
    80002910:	fe950ae3          	beq	a0,s1,80002904 <wakeup+0x30>
      acquire(&p->lock);
    80002914:	8526                	mv	a0,s1
    80002916:	fecfe0ef          	jal	80001102 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000291a:	4c9c                	lw	a5,24(s1)
    8000291c:	ff3791e3          	bne	a5,s3,800028fe <wakeup+0x2a>
    80002920:	709c                	ld	a5,32(s1)
    80002922:	fd479ee3          	bne	a5,s4,800028fe <wakeup+0x2a>
        p->state = RUNNABLE;
    80002926:	0154ac23          	sw	s5,24(s1)
    8000292a:	bfd1                	j	800028fe <wakeup+0x2a>
    }
  }
}
    8000292c:	70e2                	ld	ra,56(sp)
    8000292e:	7442                	ld	s0,48(sp)
    80002930:	74a2                	ld	s1,40(sp)
    80002932:	7902                	ld	s2,32(sp)
    80002934:	69e2                	ld	s3,24(sp)
    80002936:	6a42                	ld	s4,16(sp)
    80002938:	6aa2                	ld	s5,8(sp)
    8000293a:	6121                	addi	sp,sp,64
    8000293c:	8082                	ret

000000008000293e <reparent>:
{
    8000293e:	7179                	addi	sp,sp,-48
    80002940:	f406                	sd	ra,40(sp)
    80002942:	f022                	sd	s0,32(sp)
    80002944:	ec26                	sd	s1,24(sp)
    80002946:	e84a                	sd	s2,16(sp)
    80002948:	e44e                	sd	s3,8(sp)
    8000294a:	e052                	sd	s4,0(sp)
    8000294c:	1800                	addi	s0,sp,48
    8000294e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002950:	00010497          	auipc	s1,0x10
    80002954:	c1048493          	addi	s1,s1,-1008 # 80012560 <proc>
      pp->parent = initproc;
    80002958:	00007a17          	auipc	s4,0x7
    8000295c:	190a0a13          	addi	s4,s4,400 # 80009ae8 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002960:	00017997          	auipc	s3,0x17
    80002964:	e0098993          	addi	s3,s3,-512 # 80019760 <tickslock>
    80002968:	a029                	j	80002972 <reparent+0x34>
    8000296a:	1c848493          	addi	s1,s1,456
    8000296e:	01348b63          	beq	s1,s3,80002984 <reparent+0x46>
    if(pp->parent == p){
    80002972:	7c9c                	ld	a5,56(s1)
    80002974:	ff279be3          	bne	a5,s2,8000296a <reparent+0x2c>
      pp->parent = initproc;
    80002978:	000a3503          	ld	a0,0(s4)
    8000297c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000297e:	f57ff0ef          	jal	800028d4 <wakeup>
    80002982:	b7e5                	j	8000296a <reparent+0x2c>
}
    80002984:	70a2                	ld	ra,40(sp)
    80002986:	7402                	ld	s0,32(sp)
    80002988:	64e2                	ld	s1,24(sp)
    8000298a:	6942                	ld	s2,16(sp)
    8000298c:	69a2                	ld	s3,8(sp)
    8000298e:	6a02                	ld	s4,0(sp)
    80002990:	6145                	addi	sp,sp,48
    80002992:	8082                	ret

0000000080002994 <kexit>:
{
    80002994:	7179                	addi	sp,sp,-48
    80002996:	f406                	sd	ra,40(sp)
    80002998:	f022                	sd	s0,32(sp)
    8000299a:	ec26                	sd	s1,24(sp)
    8000299c:	e84a                	sd	s2,16(sp)
    8000299e:	e44e                	sd	s3,8(sp)
    800029a0:	e052                	sd	s4,0(sp)
    800029a2:	1800                	addi	s0,sp,48
    800029a4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800029a6:	ec4ff0ef          	jal	8000206a <myproc>
    800029aa:	89aa                	mv	s3,a0
  if(p == initproc)
    800029ac:	00007797          	auipc	a5,0x7
    800029b0:	13c7b783          	ld	a5,316(a5) # 80009ae8 <initproc>
    800029b4:	0d050493          	addi	s1,a0,208
    800029b8:	15050913          	addi	s2,a0,336
    800029bc:	00a79b63          	bne	a5,a0,800029d2 <kexit+0x3e>
    panic("init exiting");
    800029c0:	00007517          	auipc	a0,0x7
    800029c4:	84850513          	addi	a0,a0,-1976 # 80009208 <etext+0x208>
    800029c8:	e5dfd0ef          	jal	80000824 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800029cc:	04a1                	addi	s1,s1,8
    800029ce:	01248963          	beq	s1,s2,800029e0 <kexit+0x4c>
    if(p->ofile[fd]){
    800029d2:	6088                	ld	a0,0(s1)
    800029d4:	dd65                	beqz	a0,800029cc <kexit+0x38>
      fileclose(f);
    800029d6:	6a4020ef          	jal	8000507a <fileclose>
      p->ofile[fd] = 0;
    800029da:	0004b023          	sd	zero,0(s1)
    800029de:	b7fd                	j	800029cc <kexit+0x38>
  begin_op();
    800029e0:	276020ef          	jal	80004c56 <begin_op>
  iput(p->cwd);
    800029e4:	1509b503          	ld	a0,336(s3)
    800029e8:	1e5010ef          	jal	800043cc <iput>
  end_op();
    800029ec:	2da020ef          	jal	80004cc6 <end_op>
  p->cwd = 0;
    800029f0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800029f4:	0000f517          	auipc	a0,0xf
    800029f8:	75450513          	addi	a0,a0,1876 # 80012148 <wait_lock>
    800029fc:	f06fe0ef          	jal	80001102 <acquire>
  reparent(p);
    80002a00:	854e                	mv	a0,s3
    80002a02:	f3dff0ef          	jal	8000293e <reparent>
  wakeup(p->parent);
    80002a06:	0389b503          	ld	a0,56(s3)
    80002a0a:	ecbff0ef          	jal	800028d4 <wakeup>
  acquire(&p->lock);
    80002a0e:	854e                	mv	a0,s3
    80002a10:	ef2fe0ef          	jal	80001102 <acquire>
  p->xstate = status;
    80002a14:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002a18:	4795                	li	a5,5
    80002a1a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002a1e:	0000f517          	auipc	a0,0xf
    80002a22:	72a50513          	addi	a0,a0,1834 # 80012148 <wait_lock>
    80002a26:	f70fe0ef          	jal	80001196 <release>
  sched();
    80002a2a:	d77ff0ef          	jal	800027a0 <sched>
  panic("zombie exit");
    80002a2e:	00006517          	auipc	a0,0x6
    80002a32:	7ea50513          	addi	a0,a0,2026 # 80009218 <etext+0x218>
    80002a36:	deffd0ef          	jal	80000824 <panic>

0000000080002a3a <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80002a3a:	7179                	addi	sp,sp,-48
    80002a3c:	f406                	sd	ra,40(sp)
    80002a3e:	f022                	sd	s0,32(sp)
    80002a40:	ec26                	sd	s1,24(sp)
    80002a42:	e84a                	sd	s2,16(sp)
    80002a44:	e44e                	sd	s3,8(sp)
    80002a46:	1800                	addi	s0,sp,48
    80002a48:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002a4a:	00010497          	auipc	s1,0x10
    80002a4e:	b1648493          	addi	s1,s1,-1258 # 80012560 <proc>
    80002a52:	00017997          	auipc	s3,0x17
    80002a56:	d0e98993          	addi	s3,s3,-754 # 80019760 <tickslock>
    acquire(&p->lock);
    80002a5a:	8526                	mv	a0,s1
    80002a5c:	ea6fe0ef          	jal	80001102 <acquire>
    if(p->pid == pid){
    80002a60:	589c                	lw	a5,48(s1)
    80002a62:	01278b63          	beq	a5,s2,80002a78 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002a66:	8526                	mv	a0,s1
    80002a68:	f2efe0ef          	jal	80001196 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002a6c:	1c848493          	addi	s1,s1,456
    80002a70:	ff3495e3          	bne	s1,s3,80002a5a <kkill+0x20>
  }
  return -1;
    80002a74:	557d                	li	a0,-1
    80002a76:	a819                	j	80002a8c <kkill+0x52>
      p->killed = 1;
    80002a78:	4785                	li	a5,1
    80002a7a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002a7c:	4c98                	lw	a4,24(s1)
    80002a7e:	4789                	li	a5,2
    80002a80:	00f70d63          	beq	a4,a5,80002a9a <kkill+0x60>
      release(&p->lock);
    80002a84:	8526                	mv	a0,s1
    80002a86:	f10fe0ef          	jal	80001196 <release>
      return 0;
    80002a8a:	4501                	li	a0,0
}
    80002a8c:	70a2                	ld	ra,40(sp)
    80002a8e:	7402                	ld	s0,32(sp)
    80002a90:	64e2                	ld	s1,24(sp)
    80002a92:	6942                	ld	s2,16(sp)
    80002a94:	69a2                	ld	s3,8(sp)
    80002a96:	6145                	addi	sp,sp,48
    80002a98:	8082                	ret
        p->state = RUNNABLE;
    80002a9a:	478d                	li	a5,3
    80002a9c:	cc9c                	sw	a5,24(s1)
    80002a9e:	b7dd                	j	80002a84 <kkill+0x4a>

0000000080002aa0 <setkilled>:

void
setkilled(struct proc *p)
{
    80002aa0:	1101                	addi	sp,sp,-32
    80002aa2:	ec06                	sd	ra,24(sp)
    80002aa4:	e822                	sd	s0,16(sp)
    80002aa6:	e426                	sd	s1,8(sp)
    80002aa8:	1000                	addi	s0,sp,32
    80002aaa:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002aac:	e56fe0ef          	jal	80001102 <acquire>
  p->killed = 1;
    80002ab0:	4785                	li	a5,1
    80002ab2:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002ab4:	8526                	mv	a0,s1
    80002ab6:	ee0fe0ef          	jal	80001196 <release>
}
    80002aba:	60e2                	ld	ra,24(sp)
    80002abc:	6442                	ld	s0,16(sp)
    80002abe:	64a2                	ld	s1,8(sp)
    80002ac0:	6105                	addi	sp,sp,32
    80002ac2:	8082                	ret

0000000080002ac4 <killed>:

int
killed(struct proc *p)
{
    80002ac4:	1101                	addi	sp,sp,-32
    80002ac6:	ec06                	sd	ra,24(sp)
    80002ac8:	e822                	sd	s0,16(sp)
    80002aca:	e426                	sd	s1,8(sp)
    80002acc:	e04a                	sd	s2,0(sp)
    80002ace:	1000                	addi	s0,sp,32
    80002ad0:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002ad2:	e30fe0ef          	jal	80001102 <acquire>
  k = p->killed;
    80002ad6:	549c                	lw	a5,40(s1)
    80002ad8:	893e                	mv	s2,a5
  release(&p->lock);
    80002ada:	8526                	mv	a0,s1
    80002adc:	ebafe0ef          	jal	80001196 <release>
  return k;
}
    80002ae0:	854a                	mv	a0,s2
    80002ae2:	60e2                	ld	ra,24(sp)
    80002ae4:	6442                	ld	s0,16(sp)
    80002ae6:	64a2                	ld	s1,8(sp)
    80002ae8:	6902                	ld	s2,0(sp)
    80002aea:	6105                	addi	sp,sp,32
    80002aec:	8082                	ret

0000000080002aee <kwait>:
{
    80002aee:	715d                	addi	sp,sp,-80
    80002af0:	e486                	sd	ra,72(sp)
    80002af2:	e0a2                	sd	s0,64(sp)
    80002af4:	fc26                	sd	s1,56(sp)
    80002af6:	f84a                	sd	s2,48(sp)
    80002af8:	f44e                	sd	s3,40(sp)
    80002afa:	f052                	sd	s4,32(sp)
    80002afc:	ec56                	sd	s5,24(sp)
    80002afe:	e85a                	sd	s6,16(sp)
    80002b00:	e45e                	sd	s7,8(sp)
    80002b02:	0880                	addi	s0,sp,80
    80002b04:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002b06:	d64ff0ef          	jal	8000206a <myproc>
    80002b0a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002b0c:	0000f517          	auipc	a0,0xf
    80002b10:	63c50513          	addi	a0,a0,1596 # 80012148 <wait_lock>
    80002b14:	deefe0ef          	jal	80001102 <acquire>
        if(pp->state == ZOMBIE){
    80002b18:	4a15                	li	s4,5
        havekids = 1;
    80002b1a:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002b1c:	00017997          	auipc	s3,0x17
    80002b20:	c4498993          	addi	s3,s3,-956 # 80019760 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002b24:	0000fb17          	auipc	s6,0xf
    80002b28:	624b0b13          	addi	s6,s6,1572 # 80012148 <wait_lock>
    80002b2c:	a869                	j	80002bc6 <kwait+0xd8>
          pid = pp->pid;
    80002b2e:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002b32:	000b8c63          	beqz	s7,80002b4a <kwait+0x5c>
    80002b36:	4691                	li	a3,4
    80002b38:	02c48613          	addi	a2,s1,44
    80002b3c:	85de                	mv	a1,s7
    80002b3e:	05093503          	ld	a0,80(s2)
    80002b42:	a32ff0ef          	jal	80001d74 <copyout>
    80002b46:	02054a63          	bltz	a0,80002b7a <kwait+0x8c>
          freeproc(pp);
    80002b4a:	8526                	mv	a0,s1
    80002b4c:	ef2ff0ef          	jal	8000223e <freeproc>
          release(&pp->lock);
    80002b50:	8526                	mv	a0,s1
    80002b52:	e44fe0ef          	jal	80001196 <release>
          release(&wait_lock);
    80002b56:	0000f517          	auipc	a0,0xf
    80002b5a:	5f250513          	addi	a0,a0,1522 # 80012148 <wait_lock>
    80002b5e:	e38fe0ef          	jal	80001196 <release>
}
    80002b62:	854e                	mv	a0,s3
    80002b64:	60a6                	ld	ra,72(sp)
    80002b66:	6406                	ld	s0,64(sp)
    80002b68:	74e2                	ld	s1,56(sp)
    80002b6a:	7942                	ld	s2,48(sp)
    80002b6c:	79a2                	ld	s3,40(sp)
    80002b6e:	7a02                	ld	s4,32(sp)
    80002b70:	6ae2                	ld	s5,24(sp)
    80002b72:	6b42                	ld	s6,16(sp)
    80002b74:	6ba2                	ld	s7,8(sp)
    80002b76:	6161                	addi	sp,sp,80
    80002b78:	8082                	ret
            release(&pp->lock);
    80002b7a:	8526                	mv	a0,s1
    80002b7c:	e1afe0ef          	jal	80001196 <release>
            release(&wait_lock);
    80002b80:	0000f517          	auipc	a0,0xf
    80002b84:	5c850513          	addi	a0,a0,1480 # 80012148 <wait_lock>
    80002b88:	e0efe0ef          	jal	80001196 <release>
            return -1;
    80002b8c:	59fd                	li	s3,-1
    80002b8e:	bfd1                	j	80002b62 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002b90:	1c848493          	addi	s1,s1,456
    80002b94:	03348063          	beq	s1,s3,80002bb4 <kwait+0xc6>
      if(pp->parent == p){
    80002b98:	7c9c                	ld	a5,56(s1)
    80002b9a:	ff279be3          	bne	a5,s2,80002b90 <kwait+0xa2>
        acquire(&pp->lock);
    80002b9e:	8526                	mv	a0,s1
    80002ba0:	d62fe0ef          	jal	80001102 <acquire>
        if(pp->state == ZOMBIE){
    80002ba4:	4c9c                	lw	a5,24(s1)
    80002ba6:	f94784e3          	beq	a5,s4,80002b2e <kwait+0x40>
        release(&pp->lock);
    80002baa:	8526                	mv	a0,s1
    80002bac:	deafe0ef          	jal	80001196 <release>
        havekids = 1;
    80002bb0:	8756                	mv	a4,s5
    80002bb2:	bff9                	j	80002b90 <kwait+0xa2>
    if(!havekids || killed(p)){
    80002bb4:	cf19                	beqz	a4,80002bd2 <kwait+0xe4>
    80002bb6:	854a                	mv	a0,s2
    80002bb8:	f0dff0ef          	jal	80002ac4 <killed>
    80002bbc:	e919                	bnez	a0,80002bd2 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002bbe:	85da                	mv	a1,s6
    80002bc0:	854a                	mv	a0,s2
    80002bc2:	cc7ff0ef          	jal	80002888 <sleep>
    havekids = 0;
    80002bc6:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002bc8:	00010497          	auipc	s1,0x10
    80002bcc:	99848493          	addi	s1,s1,-1640 # 80012560 <proc>
    80002bd0:	b7e1                	j	80002b98 <kwait+0xaa>
      release(&wait_lock);
    80002bd2:	0000f517          	auipc	a0,0xf
    80002bd6:	57650513          	addi	a0,a0,1398 # 80012148 <wait_lock>
    80002bda:	dbcfe0ef          	jal	80001196 <release>
      return -1;
    80002bde:	59fd                	li	s3,-1
    80002be0:	b749                	j	80002b62 <kwait+0x74>

0000000080002be2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002be2:	7179                	addi	sp,sp,-48
    80002be4:	f406                	sd	ra,40(sp)
    80002be6:	f022                	sd	s0,32(sp)
    80002be8:	ec26                	sd	s1,24(sp)
    80002bea:	e84a                	sd	s2,16(sp)
    80002bec:	e44e                	sd	s3,8(sp)
    80002bee:	e052                	sd	s4,0(sp)
    80002bf0:	1800                	addi	s0,sp,48
    80002bf2:	84aa                	mv	s1,a0
    80002bf4:	8a2e                	mv	s4,a1
    80002bf6:	89b2                	mv	s3,a2
    80002bf8:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002bfa:	c70ff0ef          	jal	8000206a <myproc>
  if(user_dst){
    80002bfe:	cc99                	beqz	s1,80002c1c <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002c00:	86ca                	mv	a3,s2
    80002c02:	864e                	mv	a2,s3
    80002c04:	85d2                	mv	a1,s4
    80002c06:	6928                	ld	a0,80(a0)
    80002c08:	96cff0ef          	jal	80001d74 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002c0c:	70a2                	ld	ra,40(sp)
    80002c0e:	7402                	ld	s0,32(sp)
    80002c10:	64e2                	ld	s1,24(sp)
    80002c12:	6942                	ld	s2,16(sp)
    80002c14:	69a2                	ld	s3,8(sp)
    80002c16:	6a02                	ld	s4,0(sp)
    80002c18:	6145                	addi	sp,sp,48
    80002c1a:	8082                	ret
    memmove((char *)dst, src, len);
    80002c1c:	0009061b          	sext.w	a2,s2
    80002c20:	85ce                	mv	a1,s3
    80002c22:	8552                	mv	a0,s4
    80002c24:	e0efe0ef          	jal	80001232 <memmove>
    return 0;
    80002c28:	8526                	mv	a0,s1
    80002c2a:	b7cd                	j	80002c0c <either_copyout+0x2a>

0000000080002c2c <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002c2c:	7179                	addi	sp,sp,-48
    80002c2e:	f406                	sd	ra,40(sp)
    80002c30:	f022                	sd	s0,32(sp)
    80002c32:	ec26                	sd	s1,24(sp)
    80002c34:	e84a                	sd	s2,16(sp)
    80002c36:	e44e                	sd	s3,8(sp)
    80002c38:	e052                	sd	s4,0(sp)
    80002c3a:	1800                	addi	s0,sp,48
    80002c3c:	8a2a                	mv	s4,a0
    80002c3e:	84ae                	mv	s1,a1
    80002c40:	89b2                	mv	s3,a2
    80002c42:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002c44:	c26ff0ef          	jal	8000206a <myproc>
  if(user_src){
    80002c48:	cc99                	beqz	s1,80002c66 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002c4a:	86ca                	mv	a3,s2
    80002c4c:	864e                	mv	a2,s3
    80002c4e:	85d2                	mv	a1,s4
    80002c50:	6928                	ld	a0,80(a0)
    80002c52:	9e0ff0ef          	jal	80001e32 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002c56:	70a2                	ld	ra,40(sp)
    80002c58:	7402                	ld	s0,32(sp)
    80002c5a:	64e2                	ld	s1,24(sp)
    80002c5c:	6942                	ld	s2,16(sp)
    80002c5e:	69a2                	ld	s3,8(sp)
    80002c60:	6a02                	ld	s4,0(sp)
    80002c62:	6145                	addi	sp,sp,48
    80002c64:	8082                	ret
    memmove(dst, (char*)src, len);
    80002c66:	0009061b          	sext.w	a2,s2
    80002c6a:	85ce                	mv	a1,s3
    80002c6c:	8552                	mv	a0,s4
    80002c6e:	dc4fe0ef          	jal	80001232 <memmove>
    return 0;
    80002c72:	8526                	mv	a0,s1
    80002c74:	b7cd                	j	80002c56 <either_copyin+0x2a>

0000000080002c76 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002c76:	715d                	addi	sp,sp,-80
    80002c78:	e486                	sd	ra,72(sp)
    80002c7a:	e0a2                	sd	s0,64(sp)
    80002c7c:	fc26                	sd	s1,56(sp)
    80002c7e:	f84a                	sd	s2,48(sp)
    80002c80:	f44e                	sd	s3,40(sp)
    80002c82:	f052                	sd	s4,32(sp)
    80002c84:	ec56                	sd	s5,24(sp)
    80002c86:	e85a                	sd	s6,16(sp)
    80002c88:	e45e                	sd	s7,8(sp)
    80002c8a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002c8c:	00006517          	auipc	a0,0x6
    80002c90:	41450513          	addi	a0,a0,1044 # 800090a0 <etext+0xa0>
    80002c94:	867fd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002c98:	00010497          	auipc	s1,0x10
    80002c9c:	a2048493          	addi	s1,s1,-1504 # 800126b8 <proc+0x158>
    80002ca0:	00017917          	auipc	s2,0x17
    80002ca4:	c1890913          	addi	s2,s2,-1000 # 800198b8 <swap_space+0x128>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002ca8:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002caa:	00006997          	auipc	s3,0x6
    80002cae:	57e98993          	addi	s3,s3,1406 # 80009228 <etext+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80002cb2:	00006a97          	auipc	s5,0x6
    80002cb6:	57ea8a93          	addi	s5,s5,1406 # 80009230 <etext+0x230>
    printf("\n");
    80002cba:	00006a17          	auipc	s4,0x6
    80002cbe:	3e6a0a13          	addi	s4,s4,998 # 800090a0 <etext+0xa0>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002cc2:	00007b97          	auipc	s7,0x7
    80002cc6:	c96b8b93          	addi	s7,s7,-874 # 80009958 <states.0>
    80002cca:	a829                	j	80002ce4 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002ccc:	ed86a583          	lw	a1,-296(a3)
    80002cd0:	8556                	mv	a0,s5
    80002cd2:	829fd0ef          	jal	800004fa <printf>
    printf("\n");
    80002cd6:	8552                	mv	a0,s4
    80002cd8:	823fd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002cdc:	1c848493          	addi	s1,s1,456
    80002ce0:	03248263          	beq	s1,s2,80002d04 <procdump+0x8e>
    if(p->state == UNUSED)
    80002ce4:	86a6                	mv	a3,s1
    80002ce6:	ec04a783          	lw	a5,-320(s1)
    80002cea:	dbed                	beqz	a5,80002cdc <procdump+0x66>
      state = "???";
    80002cec:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002cee:	fcfb6fe3          	bltu	s6,a5,80002ccc <procdump+0x56>
    80002cf2:	02079713          	slli	a4,a5,0x20
    80002cf6:	01d75793          	srli	a5,a4,0x1d
    80002cfa:	97de                	add	a5,a5,s7
    80002cfc:	6390                	ld	a2,0(a5)
    80002cfe:	f679                	bnez	a2,80002ccc <procdump+0x56>
      state = "???";
    80002d00:	864e                	mv	a2,s3
    80002d02:	b7e9                	j	80002ccc <procdump+0x56>
  }

}
    80002d04:	60a6                	ld	ra,72(sp)
    80002d06:	6406                	ld	s0,64(sp)
    80002d08:	74e2                	ld	s1,56(sp)
    80002d0a:	7942                	ld	s2,48(sp)
    80002d0c:	79a2                	ld	s3,40(sp)
    80002d0e:	7a02                	ld	s4,32(sp)
    80002d10:	6ae2                	ld	s5,24(sp)
    80002d12:	6b42                	ld	s6,16(sp)
    80002d14:	6ba2                	ld	s7,8(sp)
    80002d16:	6161                	addi	sp,sp,80
    80002d18:	8082                	ret

0000000080002d1a <getvmstats>:

int
getvmstats(int pid, struct vmstats *s)
{
    80002d1a:	7179                	addi	sp,sp,-48
    80002d1c:	f406                	sd	ra,40(sp)
    80002d1e:	f022                	sd	s0,32(sp)
    80002d20:	ec26                	sd	s1,24(sp)
    80002d22:	e84a                	sd	s2,16(sp)
    80002d24:	e44e                	sd	s3,8(sp)
    80002d26:	e052                	sd	s4,0(sp)
    80002d28:	1800                	addi	s0,sp,48
    80002d2a:	892a                	mv	s2,a0
    80002d2c:	8a2e                	mv	s4,a1
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002d2e:	00010497          	auipc	s1,0x10
    80002d32:	83248493          	addi	s1,s1,-1998 # 80012560 <proc>
    80002d36:	00017997          	auipc	s3,0x17
    80002d3a:	a2a98993          	addi	s3,s3,-1494 # 80019760 <tickslock>
    80002d3e:	a801                	j	80002d4e <getvmstats+0x34>

      release(&p->lock);
      return 0;
    }

    release(&p->lock);
    80002d40:	8526                	mv	a0,s1
    80002d42:	c54fe0ef          	jal	80001196 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002d46:	1c848493          	addi	s1,s1,456
    80002d4a:	07348d63          	beq	s1,s3,80002dc4 <getvmstats+0xaa>
    acquire(&p->lock);
    80002d4e:	8526                	mv	a0,s1
    80002d50:	bb2fe0ef          	jal	80001102 <acquire>
    if(p->pid == pid && p->state != UNUSED){
    80002d54:	589c                	lw	a5,48(s1)
    80002d56:	ff2795e3          	bne	a5,s2,80002d40 <getvmstats+0x26>
    80002d5a:	4c9c                	lw	a5,24(s1)
    80002d5c:	d3f5                	beqz	a5,80002d40 <getvmstats+0x26>
      s->page_faults       = p->page_faults;
    80002d5e:	1904a783          	lw	a5,400(s1)
    80002d62:	00fa2023          	sw	a5,0(s4)
      s->pages_evicted     = p->pages_evicted;
    80002d66:	1944a783          	lw	a5,404(s1)
    80002d6a:	00fa2223          	sw	a5,4(s4)
      s->pages_swapped_in  = p->pages_swapped_in;
    80002d6e:	1984a783          	lw	a5,408(s1)
    80002d72:	00fa2423          	sw	a5,8(s4)
      s->pages_swapped_out = p->pages_swapped_out;
    80002d76:	19c4a783          	lw	a5,412(s1)
    80002d7a:	00fa2623          	sw	a5,12(s4)
      s->resident_pages    = p->resident_pages;
    80002d7e:	1a04a783          	lw	a5,416(s1)
    80002d82:	00fa2823          	sw	a5,16(s4)
      s->disk_reads  = p->disk_reads;
    80002d86:	1a84b783          	ld	a5,424(s1)
    80002d8a:	00fa3c23          	sd	a5,24(s4)
      s->disk_writes = p->disk_writes;
    80002d8e:	1b04b783          	ld	a5,432(s1)
    80002d92:	02fa3023          	sd	a5,32(s4)
      if(p->disk_ops > 0)
    80002d96:	1c04a703          	lw	a4,448(s1)
        s->avg_disk_latency = 0;
    80002d9a:	4781                	li	a5,0
      if(p->disk_ops > 0)
    80002d9c:	00e05663          	blez	a4,80002da8 <getvmstats+0x8e>
        s->avg_disk_latency = p->total_disk_latency / p->disk_ops;
    80002da0:	1b84b783          	ld	a5,440(s1)
    80002da4:	02e7d7b3          	divu	a5,a5,a4
    80002da8:	02fa3423          	sd	a5,40(s4)
      release(&p->lock);
    80002dac:	8526                	mv	a0,s1
    80002dae:	be8fe0ef          	jal	80001196 <release>
      return 0;
    80002db2:	4501                	li	a0,0
  }

  return -1;
    80002db4:	70a2                	ld	ra,40(sp)
    80002db6:	7402                	ld	s0,32(sp)
    80002db8:	64e2                	ld	s1,24(sp)
    80002dba:	6942                	ld	s2,16(sp)
    80002dbc:	69a2                	ld	s3,8(sp)
    80002dbe:	6a02                	ld	s4,0(sp)
    80002dc0:	6145                	addi	sp,sp,48
    80002dc2:	8082                	ret
  return -1;
    80002dc4:	557d                	li	a0,-1
    80002dc6:	b7fd                	j	80002db4 <getvmstats+0x9a>

0000000080002dc8 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80002dc8:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80002dcc:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80002dd0:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80002dd2:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80002dd4:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80002dd8:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80002ddc:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002de0:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002de4:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80002de8:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002dec:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002df0:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002df4:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002df8:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002dfc:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002e00:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002e04:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002e06:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002e08:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002e0c:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002e10:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002e14:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002e18:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002e1c:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002e20:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002e24:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002e28:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002e2c:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002e30:	8082                	ret

0000000080002e32 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002e32:	1141                	addi	sp,sp,-16
    80002e34:	e406                	sd	ra,8(sp)
    80002e36:	e022                	sd	s0,0(sp)
    80002e38:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002e3a:	00006597          	auipc	a1,0x6
    80002e3e:	43658593          	addi	a1,a1,1078 # 80009270 <etext+0x270>
    80002e42:	00017517          	auipc	a0,0x17
    80002e46:	91e50513          	addi	a0,a0,-1762 # 80019760 <tickslock>
    80002e4a:	a2efe0ef          	jal	80001078 <initlock>
}
    80002e4e:	60a2                	ld	ra,8(sp)
    80002e50:	6402                	ld	s0,0(sp)
    80002e52:	0141                	addi	sp,sp,16
    80002e54:	8082                	ret

0000000080002e56 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002e56:	1141                	addi	sp,sp,-16
    80002e58:	e406                	sd	ra,8(sp)
    80002e5a:	e022                	sd	s0,0(sp)
    80002e5c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e5e:	00003797          	auipc	a5,0x3
    80002e62:	5e278793          	addi	a5,a5,1506 # 80006440 <kernelvec>
    80002e66:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002e6a:	60a2                	ld	ra,8(sp)
    80002e6c:	6402                	ld	s0,0(sp)
    80002e6e:	0141                	addi	sp,sp,16
    80002e70:	8082                	ret

0000000080002e72 <prepare_return>:
//
// prepare to return to user
//
void
prepare_return(void)
{
    80002e72:	1141                	addi	sp,sp,-16
    80002e74:	e406                	sd	ra,8(sp)
    80002e76:	e022                	sd	s0,0(sp)
    80002e78:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002e7a:	9f0ff0ef          	jal	8000206a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e7e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002e82:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e84:	10079073          	csrw	sstatus,a5

  intr_off();

  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002e88:	04000737          	lui	a4,0x4000
    80002e8c:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002e8e:	0732                	slli	a4,a4,0xc
    80002e90:	00005797          	auipc	a5,0x5
    80002e94:	17078793          	addi	a5,a5,368 # 80008000 <_trampoline>
    80002e98:	00005697          	auipc	a3,0x5
    80002e9c:	16868693          	addi	a3,a3,360 # 80008000 <_trampoline>
    80002ea0:	8f95                	sub	a5,a5,a3
    80002ea2:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ea4:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  p->trapframe->kernel_satp = r_satp();
    80002ea8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002eaa:	18002773          	csrr	a4,satp
    80002eae:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE;
    80002eb0:	6d38                	ld	a4,88(a0)
    80002eb2:	613c                	ld	a5,64(a0)
    80002eb4:	6685                	lui	a3,0x1
    80002eb6:	97b6                	add	a5,a5,a3
    80002eb8:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002eba:	6d3c                	ld	a5,88(a0)
    80002ebc:	00000717          	auipc	a4,0x0
    80002ec0:	0fc70713          	addi	a4,a4,252 # 80002fb8 <usertrap>
    80002ec4:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();
    80002ec6:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002ec8:	8712                	mv	a4,tp
    80002eca:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ecc:	100027f3          	csrr	a5,sstatus

  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP;
    80002ed0:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE;
    80002ed4:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ed8:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  w_sepc(p->trapframe->epc);
    80002edc:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002ede:	6f9c                	ld	a5,24(a5)
    80002ee0:	14179073          	csrw	sepc,a5
}
    80002ee4:	60a2                	ld	ra,8(sp)
    80002ee6:	6402                	ld	s0,0(sp)
    80002ee8:	0141                	addi	sp,sp,16
    80002eea:	8082                	ret

0000000080002eec <clockintr>:
//
// clock interrupt
//
void
clockintr()
{
    80002eec:	1141                	addi	sp,sp,-16
    80002eee:	e406                	sd	ra,8(sp)
    80002ef0:	e022                	sd	s0,0(sp)
    80002ef2:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80002ef4:	942ff0ef          	jal	80002036 <cpuid>
    80002ef8:	cd11                	beqz	a0,80002f14 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002efa:	c01027f3          	rdtime	a5
    ticks++;
    wakeup(&ticks);
    release(&tickslock);
  }

  w_stimecmp(r_time() + 1000000);
    80002efe:	000f4737          	lui	a4,0xf4
    80002f02:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002f06:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002f08:	14d79073          	csrw	stimecmp,a5
}
    80002f0c:	60a2                	ld	ra,8(sp)
    80002f0e:	6402                	ld	s0,0(sp)
    80002f10:	0141                	addi	sp,sp,16
    80002f12:	8082                	ret
    acquire(&tickslock);
    80002f14:	00017517          	auipc	a0,0x17
    80002f18:	84c50513          	addi	a0,a0,-1972 # 80019760 <tickslock>
    80002f1c:	9e6fe0ef          	jal	80001102 <acquire>
    ticks++;
    80002f20:	00007717          	auipc	a4,0x7
    80002f24:	bd070713          	addi	a4,a4,-1072 # 80009af0 <ticks>
    80002f28:	431c                	lw	a5,0(a4)
    80002f2a:	2785                	addiw	a5,a5,1
    80002f2c:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80002f2e:	853a                	mv	a0,a4
    80002f30:	9a5ff0ef          	jal	800028d4 <wakeup>
    release(&tickslock);
    80002f34:	00017517          	auipc	a0,0x17
    80002f38:	82c50513          	addi	a0,a0,-2004 # 80019760 <tickslock>
    80002f3c:	a5afe0ef          	jal	80001196 <release>
    80002f40:	bf6d                	j	80002efa <clockintr+0xe>

0000000080002f42 <devintr>:
//
// device interrupt handler
//
int
devintr()
{
    80002f42:	1101                	addi	sp,sp,-32
    80002f44:	ec06                	sd	ra,24(sp)
    80002f46:	e822                	sd	s0,16(sp)
    80002f48:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f4a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002f4e:	57fd                	li	a5,-1
    80002f50:	17fe                	slli	a5,a5,0x3f
    80002f52:	07a5                	addi	a5,a5,9
    80002f54:	00f70c63          	beq	a4,a5,80002f6c <devintr+0x2a>
    if(irq)
      plic_complete(irq);

    return 1;

  } else if(scause == 0x8000000000000005L){
    80002f58:	57fd                	li	a5,-1
    80002f5a:	17fe                	slli	a5,a5,0x3f
    80002f5c:	0795                	addi	a5,a5,5
    clockintr();
    return 2;

  } else {
    return 0;
    80002f5e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002f60:	04f70863          	beq	a4,a5,80002fb0 <devintr+0x6e>
  }
    80002f64:	60e2                	ld	ra,24(sp)
    80002f66:	6442                	ld	s0,16(sp)
    80002f68:	6105                	addi	sp,sp,32
    80002f6a:	8082                	ret
    80002f6c:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002f6e:	57e030ef          	jal	800064ec <plic_claim>
    80002f72:	872a                	mv	a4,a0
    80002f74:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002f76:	47a9                	li	a5,10
    80002f78:	00f50963          	beq	a0,a5,80002f8a <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80002f7c:	4785                	li	a5,1
    80002f7e:	00f50963          	beq	a0,a5,80002f90 <devintr+0x4e>
    return 1;
    80002f82:	4505                	li	a0,1
    } else if(irq){
    80002f84:	eb09                	bnez	a4,80002f96 <devintr+0x54>
    80002f86:	64a2                	ld	s1,8(sp)
    80002f88:	bff1                	j	80002f64 <devintr+0x22>
      uartintr();
    80002f8a:	a6bfd0ef          	jal	800009f4 <uartintr>
    if(irq)
    80002f8e:	a819                	j	80002fa4 <devintr+0x62>
      virtio_disk_intr();
    80002f90:	1f3030ef          	jal	80006982 <virtio_disk_intr>
    if(irq)
    80002f94:	a801                	j	80002fa4 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80002f96:	85ba                	mv	a1,a4
    80002f98:	00006517          	auipc	a0,0x6
    80002f9c:	2e050513          	addi	a0,a0,736 # 80009278 <etext+0x278>
    80002fa0:	d5afd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    80002fa4:	8526                	mv	a0,s1
    80002fa6:	566030ef          	jal	8000650c <plic_complete>
    return 1;
    80002faa:	4505                	li	a0,1
    80002fac:	64a2                	ld	s1,8(sp)
    80002fae:	bf5d                	j	80002f64 <devintr+0x22>
    clockintr();
    80002fb0:	f3dff0ef          	jal	80002eec <clockintr>
    return 2;
    80002fb4:	4509                	li	a0,2
    80002fb6:	b77d                	j	80002f64 <devintr+0x22>

0000000080002fb8 <usertrap>:
{
    80002fb8:	7179                	addi	sp,sp,-48
    80002fba:	f406                	sd	ra,40(sp)
    80002fbc:	f022                	sd	s0,32(sp)
    80002fbe:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002fc0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002fc4:	1007f793          	andi	a5,a5,256
    80002fc8:	eba5                	bnez	a5,80003038 <usertrap+0x80>
    80002fca:	ec26                	sd	s1,24(sp)
    80002fcc:	e052                	sd	s4,0(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002fce:	00003797          	auipc	a5,0x3
    80002fd2:	47278793          	addi	a5,a5,1138 # 80006440 <kernelvec>
    80002fd6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002fda:	890ff0ef          	jal	8000206a <myproc>
    80002fde:	8a2a                	mv	s4,a0
  p->trapframe->epc = r_sepc();
    80002fe0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002fe2:	14102773          	csrr	a4,sepc
    80002fe6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002fe8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002fec:	47a1                	li	a5,8
    80002fee:	04f70f63          	beq	a4,a5,8000304c <usertrap+0x94>
  } else if((which_dev = devintr()) != 0){
    80002ff2:	f51ff0ef          	jal	80002f42 <devintr>
    80002ff6:	84aa                	mv	s1,a0
    80002ff8:	e961                	bnez	a0,800030c8 <usertrap+0x110>
    80002ffa:	14202773          	csrr	a4,scause
  } else if(r_scause() == 12 || r_scause() == 13 || r_scause() == 15){
    80002ffe:	47b1                	li	a5,12
    80003000:	00f70c63          	beq	a4,a5,80003018 <usertrap+0x60>
    80003004:	14202773          	csrr	a4,scause
    80003008:	47b5                	li	a5,13
    8000300a:	00f70763          	beq	a4,a5,80003018 <usertrap+0x60>
    8000300e:	14202773          	csrr	a4,scause
    80003012:	47bd                	li	a5,15
    80003014:	08f71263          	bne	a4,a5,80003098 <usertrap+0xe0>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003018:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000301c:	14202673          	csrr	a2,scause
    if(vmfault(p->pagetable, va, (r_scause()==15)) == 0){
    80003020:	1645                	addi	a2,a2,-15 # ff1 <_entry-0x7ffff00f>
    80003022:	00163613          	seqz	a2,a2
    80003026:	050a3503          	ld	a0,80(s4)
    8000302a:	bcdfe0ef          	jal	80001bf6 <vmfault>
    8000302e:	ed1d                	bnez	a0,8000306c <usertrap+0xb4>
      p->killed = 1;
    80003030:	4785                	li	a5,1
    80003032:	02fa2423          	sw	a5,40(s4)
    80003036:	a81d                	j	8000306c <usertrap+0xb4>
    80003038:	ec26                	sd	s1,24(sp)
    8000303a:	e84a                	sd	s2,16(sp)
    8000303c:	e44e                	sd	s3,8(sp)
    8000303e:	e052                	sd	s4,0(sp)
    panic("usertrap: not from user mode");
    80003040:	00006517          	auipc	a0,0x6
    80003044:	25850513          	addi	a0,a0,600 # 80009298 <etext+0x298>
    80003048:	fdcfd0ef          	jal	80000824 <panic>
    if(killed(p))
    8000304c:	a79ff0ef          	jal	80002ac4 <killed>
    80003050:	e121                	bnez	a0,80003090 <usertrap+0xd8>
    p->trapframe->epc += 4;
    80003052:	058a3703          	ld	a4,88(s4)
    80003056:	6f1c                	ld	a5,24(a4)
    80003058:	0791                	addi	a5,a5,4
    8000305a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000305c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003060:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003064:	10079073          	csrw	sstatus,a5
    syscall();
    80003068:	35e000ef          	jal	800033c6 <syscall>
  if(killed(p))
    8000306c:	8552                	mv	a0,s4
    8000306e:	a57ff0ef          	jal	80002ac4 <killed>
    80003072:	e125                	bnez	a0,800030d2 <usertrap+0x11a>
  prepare_return();
    80003074:	dffff0ef          	jal	80002e72 <prepare_return>
  return MAKE_SATP(p->pagetable);
    80003078:	050a3503          	ld	a0,80(s4)
    8000307c:	8131                	srli	a0,a0,0xc
    8000307e:	57fd                	li	a5,-1
    80003080:	17fe                	slli	a5,a5,0x3f
    80003082:	8d5d                	or	a0,a0,a5
}
    80003084:	64e2                	ld	s1,24(sp)
    80003086:	6a02                	ld	s4,0(sp)
    80003088:	70a2                	ld	ra,40(sp)
    8000308a:	7402                	ld	s0,32(sp)
    8000308c:	6145                	addi	sp,sp,48
    8000308e:	8082                	ret
      kexit(-1);
    80003090:	557d                	li	a0,-1
    80003092:	903ff0ef          	jal	80002994 <kexit>
    80003096:	bf75                	j	80003052 <usertrap+0x9a>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003098:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000309c:	030a2603          	lw	a2,48(s4)
    800030a0:	00006517          	auipc	a0,0x6
    800030a4:	21850513          	addi	a0,a0,536 # 800092b8 <etext+0x2b8>
    800030a8:	c52fd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800030ac:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800030b0:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800030b4:	00006517          	auipc	a0,0x6
    800030b8:	23450513          	addi	a0,a0,564 # 800092e8 <etext+0x2e8>
    800030bc:	c3efd0ef          	jal	800004fa <printf>
    setkilled(p);
    800030c0:	8552                	mv	a0,s4
    800030c2:	9dfff0ef          	jal	80002aa0 <setkilled>
    800030c6:	b75d                	j	8000306c <usertrap+0xb4>
  if(killed(p))
    800030c8:	8552                	mv	a0,s4
    800030ca:	9fbff0ef          	jal	80002ac4 <killed>
    800030ce:	c511                	beqz	a0,800030da <usertrap+0x122>
    800030d0:	a011                	j	800030d4 <usertrap+0x11c>
    800030d2:	4481                	li	s1,0
    kexit(-1);
    800030d4:	557d                	li	a0,-1
    800030d6:	8bfff0ef          	jal	80002994 <kexit>
  if(which_dev == 2){
    800030da:	4789                	li	a5,2
    800030dc:	f8f49ce3          	bne	s1,a5,80003074 <usertrap+0xbc>
    mlfq_global_ticks++;
    800030e0:	00007717          	auipc	a4,0x7
    800030e4:	a1470713          	addi	a4,a4,-1516 # 80009af4 <mlfq_global_ticks>
    800030e8:	431c                	lw	a5,0(a4)
    800030ea:	2785                	addiw	a5,a5,1
    800030ec:	c31c                	sw	a5,0(a4)
    if(p && p->state == RUNNING){
    800030ee:	018a2703          	lw	a4,24(s4)
    800030f2:	4791                	li	a5,4
    800030f4:	02f70563          	beq	a4,a5,8000311e <usertrap+0x166>
    if(mlfq_global_ticks % 128 == 0){
    800030f8:	00007797          	auipc	a5,0x7
    800030fc:	9fc7a783          	lw	a5,-1540(a5) # 80009af4 <mlfq_global_ticks>
    80003100:	07f7f793          	andi	a5,a5,127
    80003104:	fba5                	bnez	a5,80003074 <usertrap+0xbc>
    80003106:	e84a                	sd	s2,16(sp)
    80003108:	e44e                	sd	s3,8(sp)
      for(traverse = proc; traverse < &proc[NPROC]; traverse++){
    8000310a:	0000f497          	auipc	s1,0xf
    8000310e:	45648493          	addi	s1,s1,1110 # 80012560 <proc>
        if(traverse->state == RUNNABLE){
    80003112:	498d                	li	s3,3
      for(traverse = proc; traverse < &proc[NPROC]; traverse++){
    80003114:	00016917          	auipc	s2,0x16
    80003118:	64c90913          	addi	s2,s2,1612 # 80019760 <tickslock>
    8000311c:	a80d                	j	8000314e <usertrap+0x196>
       p->used_ticks++;
    8000311e:	174a2783          	lw	a5,372(s4)
    80003122:	2785                	addiw	a5,a5,1
    80003124:	16fa2a23          	sw	a5,372(s4)
       p->total_ticks[p->level]++;
    80003128:	170a2783          	lw	a5,368(s4)
    8000312c:	078a                	slli	a5,a5,0x2
    8000312e:	97d2                	add	a5,a5,s4
    80003130:	1787a703          	lw	a4,376(a5)
    80003134:	2705                	addiw	a4,a4,1
    80003136:	16e7ac23          	sw	a4,376(a5)
       yield();
    8000313a:	f22ff0ef          	jal	8000285c <yield>
    8000313e:	bf6d                	j	800030f8 <usertrap+0x140>
        release(&traverse->lock);
    80003140:	8526                	mv	a0,s1
    80003142:	854fe0ef          	jal	80001196 <release>
      for(traverse = proc; traverse < &proc[NPROC]; traverse++){
    80003146:	1c848493          	addi	s1,s1,456
    8000314a:	01248b63          	beq	s1,s2,80003160 <usertrap+0x1a8>
        acquire(&traverse->lock);
    8000314e:	8526                	mv	a0,s1
    80003150:	fb3fd0ef          	jal	80001102 <acquire>
        if(traverse->state == RUNNABLE){
    80003154:	4c9c                	lw	a5,24(s1)
    80003156:	ff3795e3          	bne	a5,s3,80003140 <usertrap+0x188>
          traverse->level = 0;
    8000315a:	1604a823          	sw	zero,368(s1)
    8000315e:	b7cd                	j	80003140 <usertrap+0x188>
    80003160:	6942                	ld	s2,16(sp)
    80003162:	69a2                	ld	s3,8(sp)
    80003164:	bf01                	j	80003074 <usertrap+0xbc>

0000000080003166 <kerneltrap>:
{
    80003166:	7139                	addi	sp,sp,-64
    80003168:	fc06                	sd	ra,56(sp)
    8000316a:	f822                	sd	s0,48(sp)
    8000316c:	f04a                	sd	s2,32(sp)
    8000316e:	e852                	sd	s4,16(sp)
    80003170:	e456                	sd	s5,8(sp)
    80003172:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003174:	14102af3          	csrr	s5,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003178:	10002a73          	csrr	s4,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000317c:	14202973          	csrr	s2,scause
  struct proc *p = myproc();
    80003180:	eebfe0ef          	jal	8000206a <myproc>
  if((sstatus & SSTATUS_SPP) == 0)
    80003184:	100a7793          	andi	a5,s4,256
    80003188:	cbb9                	beqz	a5,800031de <kerneltrap+0x78>
    8000318a:	f426                	sd	s1,40(sp)
    8000318c:	84aa                	mv	s1,a0
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000318e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80003192:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80003194:	efa9                	bnez	a5,800031ee <kerneltrap+0x88>
  if((which_dev = devintr()) == 0){
    80003196:	dadff0ef          	jal	80002f42 <devintr>
    8000319a:	c12d                	beqz	a0,800031fc <kerneltrap+0x96>
  if(which_dev == 2 && p != 0){
    8000319c:	ffe50793          	addi	a5,a0,-2
    800031a0:	e3f1                	bnez	a5,80003264 <kerneltrap+0xfe>
    800031a2:	c0e9                	beqz	s1,80003264 <kerneltrap+0xfe>
    mlfq_global_ticks++;
    800031a4:	00007717          	auipc	a4,0x7
    800031a8:	95070713          	addi	a4,a4,-1712 # 80009af4 <mlfq_global_ticks>
    800031ac:	431c                	lw	a5,0(a4)
    800031ae:	2785                	addiw	a5,a5,1
    800031b0:	c31c                	sw	a5,0(a4)
    if(p->state == RUNNING){
    800031b2:	4c98                	lw	a4,24(s1)
    800031b4:	4791                	li	a5,4
    800031b6:	06f70563          	beq	a4,a5,80003220 <kerneltrap+0xba>
    if(mlfq_global_ticks % 128 == 0){
    800031ba:	00007797          	auipc	a5,0x7
    800031be:	93a7a783          	lw	a5,-1734(a5) # 80009af4 <mlfq_global_ticks>
    800031c2:	07f7f793          	andi	a5,a5,127
    800031c6:	efd9                	bnez	a5,80003264 <kerneltrap+0xfe>
    800031c8:	ec4e                	sd	s3,24(sp)
      for(traverse = proc; traverse < &proc[NPROC]; traverse++){
    800031ca:	0000f497          	auipc	s1,0xf
    800031ce:	39648493          	addi	s1,s1,918 # 80012560 <proc>
        if(traverse->state == RUNNABLE){
    800031d2:	498d                	li	s3,3
      for(traverse = proc; traverse < &proc[NPROC]; traverse++){
    800031d4:	00016917          	auipc	s2,0x16
    800031d8:	58c90913          	addi	s2,s2,1420 # 80019760 <tickslock>
    800031dc:	a895                	j	80003250 <kerneltrap+0xea>
    800031de:	f426                	sd	s1,40(sp)
    800031e0:	ec4e                	sd	s3,24(sp)
    panic("kerneltrap: not from supervisor mode");
    800031e2:	00006517          	auipc	a0,0x6
    800031e6:	12e50513          	addi	a0,a0,302 # 80009310 <etext+0x310>
    800031ea:	e3afd0ef          	jal	80000824 <panic>
    800031ee:	ec4e                	sd	s3,24(sp)
    panic("kerneltrap: interrupts enabled");
    800031f0:	00006517          	auipc	a0,0x6
    800031f4:	14850513          	addi	a0,a0,328 # 80009338 <etext+0x338>
    800031f8:	e2cfd0ef          	jal	80000824 <panic>
    800031fc:	ec4e                	sd	s3,24(sp)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800031fe:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003202:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n",
    80003206:	85ca                	mv	a1,s2
    80003208:	00006517          	auipc	a0,0x6
    8000320c:	15050513          	addi	a0,a0,336 # 80009358 <etext+0x358>
    80003210:	aeafd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    80003214:	00006517          	auipc	a0,0x6
    80003218:	16c50513          	addi	a0,a0,364 # 80009380 <etext+0x380>
    8000321c:	e08fd0ef          	jal	80000824 <panic>
      p->used_ticks++;
    80003220:	1744a783          	lw	a5,372(s1)
    80003224:	2785                	addiw	a5,a5,1
    80003226:	16f4aa23          	sw	a5,372(s1)
      p->total_ticks[p->level]++;
    8000322a:	1704a783          	lw	a5,368(s1)
    8000322e:	078a                	slli	a5,a5,0x2
    80003230:	94be                	add	s1,s1,a5
    80003232:	1784a783          	lw	a5,376(s1)
    80003236:	2785                	addiw	a5,a5,1
    80003238:	16f4ac23          	sw	a5,376(s1)
      yield();
    8000323c:	e20ff0ef          	jal	8000285c <yield>
    80003240:	bfad                	j	800031ba <kerneltrap+0x54>
        release(&traverse->lock);
    80003242:	8526                	mv	a0,s1
    80003244:	f53fd0ef          	jal	80001196 <release>
      for(traverse = proc; traverse < &proc[NPROC]; traverse++){
    80003248:	1c848493          	addi	s1,s1,456
    8000324c:	01248b63          	beq	s1,s2,80003262 <kerneltrap+0xfc>
        acquire(&traverse->lock);
    80003250:	8526                	mv	a0,s1
    80003252:	eb1fd0ef          	jal	80001102 <acquire>
        if(traverse->state == RUNNABLE){
    80003256:	4c9c                	lw	a5,24(s1)
    80003258:	ff3795e3          	bne	a5,s3,80003242 <kerneltrap+0xdc>
          traverse->level = 0;
    8000325c:	1604a823          	sw	zero,368(s1)
    80003260:	b7cd                	j	80003242 <kerneltrap+0xdc>
    80003262:	69e2                	ld	s3,24(sp)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003264:	141a9073          	csrw	sepc,s5
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003268:	100a1073          	csrw	sstatus,s4
    8000326c:	74a2                	ld	s1,40(sp)
}
    8000326e:	70e2                	ld	ra,56(sp)
    80003270:	7442                	ld	s0,48(sp)
    80003272:	7902                	ld	s2,32(sp)
    80003274:	6a42                	ld	s4,16(sp)
    80003276:	6aa2                	ld	s5,8(sp)
    80003278:	6121                	addi	sp,sp,64
    8000327a:	8082                	ret

000000008000327c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000327c:	1101                	addi	sp,sp,-32
    8000327e:	ec06                	sd	ra,24(sp)
    80003280:	e822                	sd	s0,16(sp)
    80003282:	e426                	sd	s1,8(sp)
    80003284:	1000                	addi	s0,sp,32
    80003286:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003288:	de3fe0ef          	jal	8000206a <myproc>
  switch (n) {
    8000328c:	4795                	li	a5,5
    8000328e:	0497e163          	bltu	a5,s1,800032d0 <argraw+0x54>
    80003292:	048a                	slli	s1,s1,0x2
    80003294:	00006717          	auipc	a4,0x6
    80003298:	6f470713          	addi	a4,a4,1780 # 80009988 <states.0+0x30>
    8000329c:	94ba                	add	s1,s1,a4
    8000329e:	409c                	lw	a5,0(s1)
    800032a0:	97ba                	add	a5,a5,a4
    800032a2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800032a4:	6d3c                	ld	a5,88(a0)
    800032a6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800032a8:	60e2                	ld	ra,24(sp)
    800032aa:	6442                	ld	s0,16(sp)
    800032ac:	64a2                	ld	s1,8(sp)
    800032ae:	6105                	addi	sp,sp,32
    800032b0:	8082                	ret
    return p->trapframe->a1;
    800032b2:	6d3c                	ld	a5,88(a0)
    800032b4:	7fa8                	ld	a0,120(a5)
    800032b6:	bfcd                	j	800032a8 <argraw+0x2c>
    return p->trapframe->a2;
    800032b8:	6d3c                	ld	a5,88(a0)
    800032ba:	63c8                	ld	a0,128(a5)
    800032bc:	b7f5                	j	800032a8 <argraw+0x2c>
    return p->trapframe->a3;
    800032be:	6d3c                	ld	a5,88(a0)
    800032c0:	67c8                	ld	a0,136(a5)
    800032c2:	b7dd                	j	800032a8 <argraw+0x2c>
    return p->trapframe->a4;
    800032c4:	6d3c                	ld	a5,88(a0)
    800032c6:	6bc8                	ld	a0,144(a5)
    800032c8:	b7c5                	j	800032a8 <argraw+0x2c>
    return p->trapframe->a5;
    800032ca:	6d3c                	ld	a5,88(a0)
    800032cc:	6fc8                	ld	a0,152(a5)
    800032ce:	bfe9                	j	800032a8 <argraw+0x2c>
  panic("argraw");
    800032d0:	00006517          	auipc	a0,0x6
    800032d4:	0c050513          	addi	a0,a0,192 # 80009390 <etext+0x390>
    800032d8:	d4cfd0ef          	jal	80000824 <panic>

00000000800032dc <fetchaddr>:
{
    800032dc:	1101                	addi	sp,sp,-32
    800032de:	ec06                	sd	ra,24(sp)
    800032e0:	e822                	sd	s0,16(sp)
    800032e2:	e426                	sd	s1,8(sp)
    800032e4:	e04a                	sd	s2,0(sp)
    800032e6:	1000                	addi	s0,sp,32
    800032e8:	84aa                	mv	s1,a0
    800032ea:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800032ec:	d7ffe0ef          	jal	8000206a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800032f0:	653c                	ld	a5,72(a0)
    800032f2:	02f4f663          	bgeu	s1,a5,8000331e <fetchaddr+0x42>
    800032f6:	00848713          	addi	a4,s1,8
    800032fa:	02e7e463          	bltu	a5,a4,80003322 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800032fe:	46a1                	li	a3,8
    80003300:	8626                	mv	a2,s1
    80003302:	85ca                	mv	a1,s2
    80003304:	6928                	ld	a0,80(a0)
    80003306:	b2dfe0ef          	jal	80001e32 <copyin>
    8000330a:	00a03533          	snez	a0,a0
    8000330e:	40a0053b          	negw	a0,a0
}
    80003312:	60e2                	ld	ra,24(sp)
    80003314:	6442                	ld	s0,16(sp)
    80003316:	64a2                	ld	s1,8(sp)
    80003318:	6902                	ld	s2,0(sp)
    8000331a:	6105                	addi	sp,sp,32
    8000331c:	8082                	ret
    return -1;
    8000331e:	557d                	li	a0,-1
    80003320:	bfcd                	j	80003312 <fetchaddr+0x36>
    80003322:	557d                	li	a0,-1
    80003324:	b7fd                	j	80003312 <fetchaddr+0x36>

0000000080003326 <fetchstr>:
{
    80003326:	7179                	addi	sp,sp,-48
    80003328:	f406                	sd	ra,40(sp)
    8000332a:	f022                	sd	s0,32(sp)
    8000332c:	ec26                	sd	s1,24(sp)
    8000332e:	e84a                	sd	s2,16(sp)
    80003330:	e44e                	sd	s3,8(sp)
    80003332:	1800                	addi	s0,sp,48
    80003334:	89aa                	mv	s3,a0
    80003336:	84ae                	mv	s1,a1
    80003338:	8932                	mv	s2,a2
  struct proc *p = myproc();
    8000333a:	d31fe0ef          	jal	8000206a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000333e:	86ca                	mv	a3,s2
    80003340:	864e                	mv	a2,s3
    80003342:	85a6                	mv	a1,s1
    80003344:	6928                	ld	a0,80(a0)
    80003346:	ff4fe0ef          	jal	80001b3a <copyinstr>
    8000334a:	00054c63          	bltz	a0,80003362 <fetchstr+0x3c>
  return strlen(buf);
    8000334e:	8526                	mv	a0,s1
    80003350:	80cfe0ef          	jal	8000135c <strlen>
}
    80003354:	70a2                	ld	ra,40(sp)
    80003356:	7402                	ld	s0,32(sp)
    80003358:	64e2                	ld	s1,24(sp)
    8000335a:	6942                	ld	s2,16(sp)
    8000335c:	69a2                	ld	s3,8(sp)
    8000335e:	6145                	addi	sp,sp,48
    80003360:	8082                	ret
    return -1;
    80003362:	557d                	li	a0,-1
    80003364:	bfc5                	j	80003354 <fetchstr+0x2e>

0000000080003366 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80003366:	1101                	addi	sp,sp,-32
    80003368:	ec06                	sd	ra,24(sp)
    8000336a:	e822                	sd	s0,16(sp)
    8000336c:	e426                	sd	s1,8(sp)
    8000336e:	1000                	addi	s0,sp,32
    80003370:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003372:	f0bff0ef          	jal	8000327c <argraw>
    80003376:	c088                	sw	a0,0(s1)
}
    80003378:	60e2                	ld	ra,24(sp)
    8000337a:	6442                	ld	s0,16(sp)
    8000337c:	64a2                	ld	s1,8(sp)
    8000337e:	6105                	addi	sp,sp,32
    80003380:	8082                	ret

0000000080003382 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80003382:	1101                	addi	sp,sp,-32
    80003384:	ec06                	sd	ra,24(sp)
    80003386:	e822                	sd	s0,16(sp)
    80003388:	e426                	sd	s1,8(sp)
    8000338a:	1000                	addi	s0,sp,32
    8000338c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000338e:	eefff0ef          	jal	8000327c <argraw>
    80003392:	e088                	sd	a0,0(s1)
}
    80003394:	60e2                	ld	ra,24(sp)
    80003396:	6442                	ld	s0,16(sp)
    80003398:	64a2                	ld	s1,8(sp)
    8000339a:	6105                	addi	sp,sp,32
    8000339c:	8082                	ret

000000008000339e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000339e:	1101                	addi	sp,sp,-32
    800033a0:	ec06                	sd	ra,24(sp)
    800033a2:	e822                	sd	s0,16(sp)
    800033a4:	e426                	sd	s1,8(sp)
    800033a6:	e04a                	sd	s2,0(sp)
    800033a8:	1000                	addi	s0,sp,32
    800033aa:	892e                	mv	s2,a1
    800033ac:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800033ae:	ecfff0ef          	jal	8000327c <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800033b2:	8626                	mv	a2,s1
    800033b4:	85ca                	mv	a1,s2
    800033b6:	f71ff0ef          	jal	80003326 <fetchstr>
}
    800033ba:	60e2                	ld	ra,24(sp)
    800033bc:	6442                	ld	s0,16(sp)
    800033be:	64a2                	ld	s1,8(sp)
    800033c0:	6902                	ld	s2,0(sp)
    800033c2:	6105                	addi	sp,sp,32
    800033c4:	8082                	ret

00000000800033c6 <syscall>:

};

void
syscall(void)
{
    800033c6:	1101                	addi	sp,sp,-32
    800033c8:	ec06                	sd	ra,24(sp)
    800033ca:	e822                	sd	s0,16(sp)
    800033cc:	e426                	sd	s1,8(sp)
    800033ce:	e04a                	sd	s2,0(sp)
    800033d0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800033d2:	c99fe0ef          	jal	8000206a <myproc>
    800033d6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800033d8:	05853903          	ld	s2,88(a0)
    800033dc:	0a893783          	ld	a5,168(s2)
    800033e0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800033e4:	37fd                	addiw	a5,a5,-1
    800033e6:	4779                	li	a4,30
    800033e8:	02f76463          	bltu	a4,a5,80003410 <syscall+0x4a>
    800033ec:	00369713          	slli	a4,a3,0x3
    800033f0:	00006797          	auipc	a5,0x6
    800033f4:	5b078793          	addi	a5,a5,1456 # 800099a0 <syscalls>
    800033f8:	97ba                	add	a5,a5,a4
    800033fa:	6398                	ld	a4,0(a5)
    800033fc:	cb11                	beqz	a4,80003410 <syscall+0x4a>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->syscount++;//added here
    800033fe:	16853783          	ld	a5,360(a0)
    80003402:	0785                	addi	a5,a5,1
    80003404:	16f53423          	sd	a5,360(a0)
    p->trapframe->a0 = syscalls[num]();
    80003408:	9702                	jalr	a4
    8000340a:	06a93823          	sd	a0,112(s2)
    8000340e:	a829                	j	80003428 <syscall+0x62>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003410:	15848613          	addi	a2,s1,344
    80003414:	588c                	lw	a1,48(s1)
    80003416:	00006517          	auipc	a0,0x6
    8000341a:	f8250513          	addi	a0,a0,-126 # 80009398 <etext+0x398>
    8000341e:	8dcfd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003422:	6cbc                	ld	a5,88(s1)
    80003424:	577d                	li	a4,-1
    80003426:	fbb8                	sd	a4,112(a5)
  }
}
    80003428:	60e2                	ld	ra,24(sp)
    8000342a:	6442                	ld	s0,16(sp)
    8000342c:	64a2                	ld	s1,8(sp)
    8000342e:	6902                	ld	s2,0(sp)
    80003430:	6105                	addi	sp,sp,32
    80003432:	8082                	ret

0000000080003434 <swap_init>:
// Protected by swap_lock.
static uint32 swap_head = 0;

void
swap_init(void)
{
    80003434:	1141                	addi	sp,sp,-16
    80003436:	e406                	sd	ra,8(sp)
    80003438:	e022                	sd	s0,0(sp)
    8000343a:	0800                	addi	s0,sp,16
  initlock(&swap_lock, "swap");
    8000343c:	00006597          	auipc	a1,0x6
    80003440:	f7c58593          	addi	a1,a1,-132 # 800093b8 <etext+0x3b8>
    80003444:	00016517          	auipc	a0,0x16
    80003448:	33450513          	addi	a0,a0,820 # 80019778 <swap_lock>
    8000344c:	c2dfd0ef          	jal	80001078 <initlock>
  raid_init();
    80003450:	177030ef          	jal	80006dc6 <raid_init>

  for(int i = 0; i < MAX_SWAP; i++){
    80003454:	00016797          	auipc	a5,0x16
    80003458:	33c78793          	addi	a5,a5,828 # 80019790 <swap_space>
    8000345c:	00017717          	auipc	a4,0x17
    80003460:	33470713          	addi	a4,a4,820 # 8001a790 <bcache>
    swap_space[i].used       = 0;
    80003464:	0007a023          	sw	zero,0(a5)
    swap_space[i].proc       = 0;
    80003468:	0007b423          	sd	zero,8(a5)
    swap_space[i].va         = 0;
    8000346c:	0007b823          	sd	zero,16(a5)
    swap_space[i].disk_block = 0;
    80003470:	0007ac23          	sw	zero,24(a5)
  for(int i = 0; i < MAX_SWAP; i++){
    80003474:	02078793          	addi	a5,a5,32
    80003478:	fee796e3          	bne	a5,a4,80003464 <swap_init+0x30>
  }
}
    8000347c:	60a2                	ld	ra,8(sp)
    8000347e:	6402                	ld	s0,0(sp)
    80003480:	0141                	addi	sp,sp,16
    80003482:	8082                	ret

0000000080003484 <swap_alloc>:

int
swap_alloc(void)
{
    80003484:	1101                	addi	sp,sp,-32
    80003486:	ec06                	sd	ra,24(sp)
    80003488:	e822                	sd	s0,16(sp)
    8000348a:	e426                	sd	s1,8(sp)
    8000348c:	1000                	addi	s0,sp,32
  acquire(&swap_lock);
    8000348e:	00016517          	auipc	a0,0x16
    80003492:	2ea50513          	addi	a0,a0,746 # 80019778 <swap_lock>
    80003496:	c6dfd0ef          	jal	80001102 <acquire>
  for(int i = 0; i < MAX_SWAP; i++){
    8000349a:	00016797          	auipc	a5,0x16
    8000349e:	2f678793          	addi	a5,a5,758 # 80019790 <swap_space>
    800034a2:	4481                	li	s1,0
    800034a4:	08000693          	li	a3,128
    if(!swap_space[i].used){
    800034a8:	4398                	lw	a4,0(a5)
    800034aa:	cf11                	beqz	a4,800034c6 <swap_alloc+0x42>
  for(int i = 0; i < MAX_SWAP; i++){
    800034ac:	2485                	addiw	s1,s1,1
    800034ae:	02078793          	addi	a5,a5,32
    800034b2:	fed49be3          	bne	s1,a3,800034a8 <swap_alloc+0x24>
      swap_space[i].used = 1;
      release(&swap_lock);
      return i;
    }
  }
  release(&swap_lock);
    800034b6:	00016517          	auipc	a0,0x16
    800034ba:	2c250513          	addi	a0,a0,706 # 80019778 <swap_lock>
    800034be:	cd9fd0ef          	jal	80001196 <release>
  return -1;
    800034c2:	54fd                	li	s1,-1
    800034c4:	a005                	j	800034e4 <swap_alloc+0x60>
      swap_space[i].used = 1;
    800034c6:	00549713          	slli	a4,s1,0x5
    800034ca:	00016797          	auipc	a5,0x16
    800034ce:	2c678793          	addi	a5,a5,710 # 80019790 <swap_space>
    800034d2:	97ba                	add	a5,a5,a4
    800034d4:	4705                	li	a4,1
    800034d6:	c398                	sw	a4,0(a5)
      release(&swap_lock);
    800034d8:	00016517          	auipc	a0,0x16
    800034dc:	2a050513          	addi	a0,a0,672 # 80019778 <swap_lock>
    800034e0:	cb7fd0ef          	jal	80001196 <release>
}
    800034e4:	8526                	mv	a0,s1
    800034e6:	60e2                	ld	ra,24(sp)
    800034e8:	6442                	ld	s0,16(sp)
    800034ea:	64a2                	ld	s1,8(sp)
    800034ec:	6105                	addi	sp,sp,32
    800034ee:	8082                	ret

00000000800034f0 <swap_free>:

void
swap_free(int slot)
{
    800034f0:	1101                	addi	sp,sp,-32
    800034f2:	ec06                	sd	ra,24(sp)
    800034f4:	e822                	sd	s0,16(sp)
    800034f6:	e426                	sd	s1,8(sp)
    800034f8:	1000                	addi	s0,sp,32
    800034fa:	84aa                	mv	s1,a0
  acquire(&swap_lock);
    800034fc:	00016517          	auipc	a0,0x16
    80003500:	27c50513          	addi	a0,a0,636 # 80019778 <swap_lock>
    80003504:	bfffd0ef          	jal	80001102 <acquire>
  swap_space[slot].used = 0;
    80003508:	00549513          	slli	a0,s1,0x5
    8000350c:	00016797          	auipc	a5,0x16
    80003510:	28478793          	addi	a5,a5,644 # 80019790 <swap_space>
    80003514:	97aa                	add	a5,a5,a0
    80003516:	0007a023          	sw	zero,0(a5)
  swap_space[slot].proc = 0;
    8000351a:	0007b423          	sd	zero,8(a5)
  swap_space[slot].va   = 0;
    8000351e:	0007b823          	sd	zero,16(a5)
  release(&swap_lock);
    80003522:	00016517          	auipc	a0,0x16
    80003526:	25650513          	addi	a0,a0,598 # 80019778 <swap_lock>
    8000352a:	c6dfd0ef          	jal	80001196 <release>
}
    8000352e:	60e2                	ld	ra,24(sp)
    80003530:	6442                	ld	s0,16(sp)
    80003532:	64a2                	ld	s1,8(sp)
    80003534:	6105                	addi	sp,sp,32
    80003536:	8082                	ret

0000000080003538 <swap_write>:
void
swap_write(int slot, char *pa, struct proc *victim, uint64 va, struct proc *creditor)
{
    80003538:	7139                	addi	sp,sp,-64
    8000353a:	fc06                	sd	ra,56(sp)
    8000353c:	f822                	sd	s0,48(sp)
    8000353e:	f426                	sd	s1,40(sp)
    80003540:	f04a                	sd	s2,32(sp)
    80003542:	ec4e                	sd	s3,24(sp)
    80003544:	e852                	sd	s4,16(sp)
    80003546:	e456                	sd	s5,8(sp)
    80003548:	e05a                	sd	s6,0(sp)
    8000354a:	0080                	addi	s0,sp,64
    8000354c:	892a                	mv	s2,a0
    8000354e:	8b2e                	mv	s6,a1
    80003550:	8a32                	mv	s4,a2
    80003552:	8ab6                	mv	s5,a3
    80003554:	84ba                	mv	s1,a4
  acquire(&swap_lock);
    80003556:	00016517          	auipc	a0,0x16
    8000355a:	22250513          	addi	a0,a0,546 # 80019778 <swap_lock>
    8000355e:	ba5fd0ef          	jal	80001102 <acquire>
  uint32 blk = SWAP_START_BLOCK + (uint32)slot * BLOCKS_PER_PAGE;
    80003562:	0029199b          	slliw	s3,s2,0x2
  swap_space[slot].disk_block = blk;
    80003566:	0916                	slli	s2,s2,0x5
    80003568:	00016797          	auipc	a5,0x16
    8000356c:	22878793          	addi	a5,a5,552 # 80019790 <swap_space>
    80003570:	97ca                	add	a5,a5,s2
    80003572:	0137ac23          	sw	s3,24(a5)
  swap_space[slot].proc       = victim;
    80003576:	0147b423          	sd	s4,8(a5)
  swap_space[slot].va         = va;
    8000357a:	0157b823          	sd	s5,16(a5)

  // Compute latency: |current_head - requested_block| + C
  uint32 seek = (blk > swap_head) ? (blk - swap_head) : (swap_head - blk);
    8000357e:	00006797          	auipc	a5,0x6
    80003582:	57a7a783          	lw	a5,1402(a5) # 80009af8 <swap_head>
    80003586:	0737f063          	bgeu	a5,s3,800035e6 <swap_write+0xae>
    8000358a:	40f9893b          	subw	s2,s3,a5
  uint32 latency = seek + ROTATIONAL_CONST;
  swap_head = blk;   // move head to served block
    8000358e:	00006797          	auipc	a5,0x6
    80003592:	5737a523          	sw	s3,1386(a5) # 80009af8 <swap_head>
  release(&swap_lock);
    80003596:	00016517          	auipc	a0,0x16
    8000359a:	1e250513          	addi	a0,a0,482 # 80019778 <swap_lock>
    8000359e:	bf9fd0ef          	jal	80001196 <release>

  raid_write(blk, pa);
    800035a2:	85da                	mv	a1,s6
    800035a4:	854e                	mv	a0,s3
    800035a6:	181030ef          	jal	80006f26 <raid_write>

  // Credit the process that triggered the eviction.
  if(creditor != 0){
    800035aa:	c485                	beqz	s1,800035d2 <swap_write+0x9a>
    creditor->disk_writes++;
    800035ac:	1b04b783          	ld	a5,432(s1)
    800035b0:	0785                	addi	a5,a5,1
    800035b2:	1af4b823          	sd	a5,432(s1)
  uint32 latency = seek + ROTATIONAL_CONST;
    800035b6:	0059079b          	addiw	a5,s2,5
    creditor->total_disk_latency += latency;
    800035ba:	1782                	slli	a5,a5,0x20
    800035bc:	9381                	srli	a5,a5,0x20
    800035be:	1b84b703          	ld	a4,440(s1)
    800035c2:	97ba                	add	a5,a5,a4
    800035c4:	1af4bc23          	sd	a5,440(s1)
    creditor->disk_ops++;
    800035c8:	1c04a783          	lw	a5,448(s1)
    800035cc:	2785                	addiw	a5,a5,1
    800035ce:	1cf4a023          	sw	a5,448(s1)
  }
}
    800035d2:	70e2                	ld	ra,56(sp)
    800035d4:	7442                	ld	s0,48(sp)
    800035d6:	74a2                	ld	s1,40(sp)
    800035d8:	7902                	ld	s2,32(sp)
    800035da:	69e2                	ld	s3,24(sp)
    800035dc:	6a42                	ld	s4,16(sp)
    800035de:	6aa2                	ld	s5,8(sp)
    800035e0:	6b02                	ld	s6,0(sp)
    800035e2:	6121                	addi	sp,sp,64
    800035e4:	8082                	ret
  uint32 seek = (blk > swap_head) ? (blk - swap_head) : (swap_head - blk);
    800035e6:	4137893b          	subw	s2,a5,s3
    800035ea:	b755                	j	8000358e <swap_write+0x56>

00000000800035ec <swap_read>:
void
swap_read(int slot, char *pa, struct proc *creditor)
{
    800035ec:	7179                	addi	sp,sp,-48
    800035ee:	f406                	sd	ra,40(sp)
    800035f0:	f022                	sd	s0,32(sp)
    800035f2:	ec26                	sd	s1,24(sp)
    800035f4:	e84a                	sd	s2,16(sp)
    800035f6:	e44e                	sd	s3,8(sp)
    800035f8:	e052                	sd	s4,0(sp)
    800035fa:	1800                	addi	s0,sp,48
    800035fc:	892a                	mv	s2,a0
    800035fe:	89ae                	mv	s3,a1
    80003600:	84b2                	mv	s1,a2
  acquire(&swap_lock);
    80003602:	00016517          	auipc	a0,0x16
    80003606:	17650513          	addi	a0,a0,374 # 80019778 <swap_lock>
    8000360a:	af9fd0ef          	jal	80001102 <acquire>
  uint32 blk = swap_space[slot].disk_block;
    8000360e:	00591513          	slli	a0,s2,0x5
    80003612:	00016797          	auipc	a5,0x16
    80003616:	17e78793          	addi	a5,a5,382 # 80019790 <swap_space>
    8000361a:	97aa                	add	a5,a5,a0
    8000361c:	0187a903          	lw	s2,24(a5)

  // Compute latency: |current_head - requested_block| + C
  uint32 seek = (blk > swap_head) ? (blk - swap_head) : (swap_head - blk);
    80003620:	00006797          	auipc	a5,0x6
    80003624:	4d87a783          	lw	a5,1240(a5) # 80009af8 <swap_head>
    80003628:	0527ff63          	bgeu	a5,s2,80003686 <swap_read+0x9a>
    8000362c:	40f907bb          	subw	a5,s2,a5
    80003630:	8a3e                	mv	s4,a5
  uint32 latency = seek + ROTATIONAL_CONST;
  swap_head = blk;   // move head to served block
    80003632:	00006797          	auipc	a5,0x6
    80003636:	4d27a323          	sw	s2,1222(a5) # 80009af8 <swap_head>
  release(&swap_lock);
    8000363a:	00016517          	auipc	a0,0x16
    8000363e:	13e50513          	addi	a0,a0,318 # 80019778 <swap_lock>
    80003642:	b55fd0ef          	jal	80001196 <release>

  raid_read(blk, pa);
    80003646:	85ce                	mv	a1,s3
    80003648:	854a                	mv	a0,s2
    8000364a:	187030ef          	jal	80006fd0 <raid_read>

  // Credit the process passed explicitly from the fault handler.
  if(creditor != 0){
    8000364e:	c485                	beqz	s1,80003676 <swap_read+0x8a>
    creditor->disk_reads++;
    80003650:	1a84b783          	ld	a5,424(s1)
    80003654:	0785                	addi	a5,a5,1
    80003656:	1af4b423          	sd	a5,424(s1)
  uint32 latency = seek + ROTATIONAL_CONST;
    8000365a:	005a079b          	addiw	a5,s4,5
    creditor->total_disk_latency += latency;
    8000365e:	1782                	slli	a5,a5,0x20
    80003660:	9381                	srli	a5,a5,0x20
    80003662:	1b84b703          	ld	a4,440(s1)
    80003666:	97ba                	add	a5,a5,a4
    80003668:	1af4bc23          	sd	a5,440(s1)
    creditor->disk_ops++;
    8000366c:	1c04a783          	lw	a5,448(s1)
    80003670:	2785                	addiw	a5,a5,1
    80003672:	1cf4a023          	sw	a5,448(s1)
  }
}
    80003676:	70a2                	ld	ra,40(sp)
    80003678:	7402                	ld	s0,32(sp)
    8000367a:	64e2                	ld	s1,24(sp)
    8000367c:	6942                	ld	s2,16(sp)
    8000367e:	69a2                	ld	s3,8(sp)
    80003680:	6a02                	ld	s4,0(sp)
    80003682:	6145                	addi	sp,sp,48
    80003684:	8082                	ret
  uint32 seek = (blk > swap_head) ? (blk - swap_head) : (swap_head - blk);
    80003686:	412787bb          	subw	a5,a5,s2
    8000368a:	8a3e                	mv	s4,a5
    8000368c:	b75d                	j	80003632 <swap_read+0x46>

000000008000368e <sys_exit>:

extern struct proc proc[NPROC];
extern struct spinlock wait_lock;
uint64
sys_exit(void)
{
    8000368e:	1101                	addi	sp,sp,-32
    80003690:	ec06                	sd	ra,24(sp)
    80003692:	e822                	sd	s0,16(sp)
    80003694:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003696:	fec40593          	addi	a1,s0,-20
    8000369a:	4501                	li	a0,0
    8000369c:	ccbff0ef          	jal	80003366 <argint>
  kexit(n);
    800036a0:	fec42503          	lw	a0,-20(s0)
    800036a4:	af0ff0ef          	jal	80002994 <kexit>
  return 0;  // not reached
}
    800036a8:	4501                	li	a0,0
    800036aa:	60e2                	ld	ra,24(sp)
    800036ac:	6442                	ld	s0,16(sp)
    800036ae:	6105                	addi	sp,sp,32
    800036b0:	8082                	ret

00000000800036b2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800036b2:	1141                	addi	sp,sp,-16
    800036b4:	e406                	sd	ra,8(sp)
    800036b6:	e022                	sd	s0,0(sp)
    800036b8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800036ba:	9b1fe0ef          	jal	8000206a <myproc>
}
    800036be:	5908                	lw	a0,48(a0)
    800036c0:	60a2                	ld	ra,8(sp)
    800036c2:	6402                	ld	s0,0(sp)
    800036c4:	0141                	addi	sp,sp,16
    800036c6:	8082                	ret

00000000800036c8 <sys_fork>:

uint64
sys_fork(void)
{
    800036c8:	1141                	addi	sp,sp,-16
    800036ca:	e406                	sd	ra,8(sp)
    800036cc:	e022                	sd	s0,0(sp)
    800036ce:	0800                	addi	s0,sp,16
  return kfork();
    800036d0:	dcffe0ef          	jal	8000249e <kfork>
}
    800036d4:	60a2                	ld	ra,8(sp)
    800036d6:	6402                	ld	s0,0(sp)
    800036d8:	0141                	addi	sp,sp,16
    800036da:	8082                	ret

00000000800036dc <sys_wait>:

uint64
sys_wait(void)
{
    800036dc:	1101                	addi	sp,sp,-32
    800036de:	ec06                	sd	ra,24(sp)
    800036e0:	e822                	sd	s0,16(sp)
    800036e2:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800036e4:	fe840593          	addi	a1,s0,-24
    800036e8:	4501                	li	a0,0
    800036ea:	c99ff0ef          	jal	80003382 <argaddr>
  return kwait(p);
    800036ee:	fe843503          	ld	a0,-24(s0)
    800036f2:	bfcff0ef          	jal	80002aee <kwait>
}
    800036f6:	60e2                	ld	ra,24(sp)
    800036f8:	6442                	ld	s0,16(sp)
    800036fa:	6105                	addi	sp,sp,32
    800036fc:	8082                	ret

00000000800036fe <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800036fe:	7179                	addi	sp,sp,-48
    80003700:	f406                	sd	ra,40(sp)
    80003702:	f022                	sd	s0,32(sp)
    80003704:	ec26                	sd	s1,24(sp)
    80003706:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80003708:	fd840593          	addi	a1,s0,-40
    8000370c:	4501                	li	a0,0
    8000370e:	c59ff0ef          	jal	80003366 <argint>
  argint(1, &t);
    80003712:	fdc40593          	addi	a1,s0,-36
    80003716:	4505                	li	a0,1
    80003718:	c4fff0ef          	jal	80003366 <argint>
  addr = myproc()->sz;
    8000371c:	94ffe0ef          	jal	8000206a <myproc>
    80003720:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80003722:	fdc42703          	lw	a4,-36(s0)
    80003726:	4785                	li	a5,1
    80003728:	02f70763          	beq	a4,a5,80003756 <sys_sbrk+0x58>
    8000372c:	fd842783          	lw	a5,-40(s0)
    80003730:	0207c363          	bltz	a5,80003756 <sys_sbrk+0x58>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80003734:	97a6                	add	a5,a5,s1
      return -1;
    if(addr + n > TRAPFRAME)
    80003736:	02000737          	lui	a4,0x2000
    8000373a:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    8000373c:	0736                	slli	a4,a4,0xd
    8000373e:	02f76a63          	bltu	a4,a5,80003772 <sys_sbrk+0x74>
    80003742:	0297e863          	bltu	a5,s1,80003772 <sys_sbrk+0x74>
      return -1;
    myproc()->sz += n;
    80003746:	925fe0ef          	jal	8000206a <myproc>
    8000374a:	fd842703          	lw	a4,-40(s0)
    8000374e:	653c                	ld	a5,72(a0)
    80003750:	97ba                	add	a5,a5,a4
    80003752:	e53c                	sd	a5,72(a0)
    80003754:	a039                	j	80003762 <sys_sbrk+0x64>
    if(growproc(n) < 0) {
    80003756:	fd842503          	lw	a0,-40(s0)
    8000375a:	ce3fe0ef          	jal	8000243c <growproc>
    8000375e:	00054863          	bltz	a0,8000376e <sys_sbrk+0x70>
  }
  return addr;
}
    80003762:	8526                	mv	a0,s1
    80003764:	70a2                	ld	ra,40(sp)
    80003766:	7402                	ld	s0,32(sp)
    80003768:	64e2                	ld	s1,24(sp)
    8000376a:	6145                	addi	sp,sp,48
    8000376c:	8082                	ret
      return -1;
    8000376e:	54fd                	li	s1,-1
    80003770:	bfcd                	j	80003762 <sys_sbrk+0x64>
      return -1;
    80003772:	54fd                	li	s1,-1
    80003774:	b7fd                	j	80003762 <sys_sbrk+0x64>

0000000080003776 <sys_pause>:

uint64
sys_pause(void)
{
    80003776:	7139                	addi	sp,sp,-64
    80003778:	fc06                	sd	ra,56(sp)
    8000377a:	f822                	sd	s0,48(sp)
    8000377c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000377e:	fcc40593          	addi	a1,s0,-52
    80003782:	4501                	li	a0,0
    80003784:	be3ff0ef          	jal	80003366 <argint>
  if(n < 0)
    80003788:	fcc42783          	lw	a5,-52(s0)
    8000378c:	0607c863          	bltz	a5,800037fc <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80003790:	00016517          	auipc	a0,0x16
    80003794:	fd050513          	addi	a0,a0,-48 # 80019760 <tickslock>
    80003798:	96bfd0ef          	jal	80001102 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    8000379c:	fcc42783          	lw	a5,-52(s0)
    800037a0:	c3b9                	beqz	a5,800037e6 <sys_pause+0x70>
    800037a2:	f426                	sd	s1,40(sp)
    800037a4:	f04a                	sd	s2,32(sp)
    800037a6:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    800037a8:	00006997          	auipc	s3,0x6
    800037ac:	3489a983          	lw	s3,840(s3) # 80009af0 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800037b0:	00016917          	auipc	s2,0x16
    800037b4:	fb090913          	addi	s2,s2,-80 # 80019760 <tickslock>
    800037b8:	00006497          	auipc	s1,0x6
    800037bc:	33848493          	addi	s1,s1,824 # 80009af0 <ticks>
    if(killed(myproc())){
    800037c0:	8abfe0ef          	jal	8000206a <myproc>
    800037c4:	b00ff0ef          	jal	80002ac4 <killed>
    800037c8:	ed0d                	bnez	a0,80003802 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    800037ca:	85ca                	mv	a1,s2
    800037cc:	8526                	mv	a0,s1
    800037ce:	8baff0ef          	jal	80002888 <sleep>
  while(ticks - ticks0 < n){
    800037d2:	409c                	lw	a5,0(s1)
    800037d4:	413787bb          	subw	a5,a5,s3
    800037d8:	fcc42703          	lw	a4,-52(s0)
    800037dc:	fee7e2e3          	bltu	a5,a4,800037c0 <sys_pause+0x4a>
    800037e0:	74a2                	ld	s1,40(sp)
    800037e2:	7902                	ld	s2,32(sp)
    800037e4:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800037e6:	00016517          	auipc	a0,0x16
    800037ea:	f7a50513          	addi	a0,a0,-134 # 80019760 <tickslock>
    800037ee:	9a9fd0ef          	jal	80001196 <release>
  return 0;
    800037f2:	4501                	li	a0,0
}
    800037f4:	70e2                	ld	ra,56(sp)
    800037f6:	7442                	ld	s0,48(sp)
    800037f8:	6121                	addi	sp,sp,64
    800037fa:	8082                	ret
    n = 0;
    800037fc:	fc042623          	sw	zero,-52(s0)
    80003800:	bf41                	j	80003790 <sys_pause+0x1a>
      release(&tickslock);
    80003802:	00016517          	auipc	a0,0x16
    80003806:	f5e50513          	addi	a0,a0,-162 # 80019760 <tickslock>
    8000380a:	98dfd0ef          	jal	80001196 <release>
      return -1;
    8000380e:	557d                	li	a0,-1
    80003810:	74a2                	ld	s1,40(sp)
    80003812:	7902                	ld	s2,32(sp)
    80003814:	69e2                	ld	s3,24(sp)
    80003816:	bff9                	j	800037f4 <sys_pause+0x7e>

0000000080003818 <sys_kill>:

uint64
sys_kill(void)
{
    80003818:	1101                	addi	sp,sp,-32
    8000381a:	ec06                	sd	ra,24(sp)
    8000381c:	e822                	sd	s0,16(sp)
    8000381e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003820:	fec40593          	addi	a1,s0,-20
    80003824:	4501                	li	a0,0
    80003826:	b41ff0ef          	jal	80003366 <argint>
  return kkill(pid);
    8000382a:	fec42503          	lw	a0,-20(s0)
    8000382e:	a0cff0ef          	jal	80002a3a <kkill>
}
    80003832:	60e2                	ld	ra,24(sp)
    80003834:	6442                	ld	s0,16(sp)
    80003836:	6105                	addi	sp,sp,32
    80003838:	8082                	ret

000000008000383a <sys_hello>:

uint64
sys_hello(void) // hello 
{
    8000383a:	1141                	addi	sp,sp,-16
    8000383c:	e406                	sd	ra,8(sp)
    8000383e:	e022                	sd	s0,0(sp)
    80003840:	0800                	addi	s0,sp,16
  printf("Hello from the kernel!\n");
    80003842:	00006517          	auipc	a0,0x6
    80003846:	b7e50513          	addi	a0,a0,-1154 # 800093c0 <etext+0x3c0>
    8000384a:	cb1fc0ef          	jal	800004fa <printf>
  return 0;
}
    8000384e:	4501                	li	a0,0
    80003850:	60a2                	ld	ra,8(sp)
    80003852:	6402                	ld	s0,0(sp)
    80003854:	0141                	addi	sp,sp,16
    80003856:	8082                	ret

0000000080003858 <sys_getpid2>:

uint64
sys_getpid2(void){
    80003858:	1141                	addi	sp,sp,-16
    8000385a:	e406                	sd	ra,8(sp)
    8000385c:	e022                	sd	s0,0(sp)
    8000385e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80003860:	80bfe0ef          	jal	8000206a <myproc>
  return p->pid;
}
    80003864:	5908                	lw	a0,48(a0)
    80003866:	60a2                	ld	ra,8(sp)
    80003868:	6402                	ld	s0,0(sp)
    8000386a:	0141                	addi	sp,sp,16
    8000386c:	8082                	ret

000000008000386e <sys_getppid>:

uint64
sys_getppid(void){
    8000386e:	1101                	addi	sp,sp,-32
    80003870:	ec06                	sd	ra,24(sp)
    80003872:	e822                	sd	s0,16(sp)
    80003874:	e426                	sd	s1,8(sp)
    80003876:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80003878:	ff2fe0ef          	jal	8000206a <myproc>
    8000387c:	84aa                	mv	s1,a0
  int ppid = -1;
  acquire(&wait_lock);
    8000387e:	0000f517          	auipc	a0,0xf
    80003882:	8ca50513          	addi	a0,a0,-1846 # 80012148 <wait_lock>
    80003886:	87dfd0ef          	jal	80001102 <acquire>
  if (p->parent != 0){
    8000388a:	7c9c                	ld	a5,56(s1)
  int ppid = -1;
    8000388c:	54fd                	li	s1,-1
  if (p->parent != 0){
    8000388e:	c391                	beqz	a5,80003892 <sys_getppid+0x24>
    ppid = p->parent->pid;
    80003890:	5b84                	lw	s1,48(a5)
  }
  release(&wait_lock);
    80003892:	0000f517          	auipc	a0,0xf
    80003896:	8b650513          	addi	a0,a0,-1866 # 80012148 <wait_lock>
    8000389a:	8fdfd0ef          	jal	80001196 <release>

  return ppid;
}
    8000389e:	8526                	mv	a0,s1
    800038a0:	60e2                	ld	ra,24(sp)
    800038a2:	6442                	ld	s0,16(sp)
    800038a4:	64a2                	ld	s1,8(sp)
    800038a6:	6105                	addi	sp,sp,32
    800038a8:	8082                	ret

00000000800038aa <sys_getnumchild>:

uint64
sys_getnumchild(void){
    800038aa:	1101                	addi	sp,sp,-32
    800038ac:	ec06                	sd	ra,24(sp)
    800038ae:	e822                	sd	s0,16(sp)
    800038b0:	e426                	sd	s1,8(sp)
    800038b2:	e04a                	sd	s2,0(sp)
    800038b4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800038b6:	fb4fe0ef          	jal	8000206a <myproc>
    800038ba:	84aa                	mv	s1,a0
  struct proc *traverse = proc;
  int count = 0;
  acquire(&wait_lock);
    800038bc:	0000f517          	auipc	a0,0xf
    800038c0:	88c50513          	addi	a0,a0,-1908 # 80012148 <wait_lock>
    800038c4:	83ffd0ef          	jal	80001102 <acquire>
  int count = 0;
    800038c8:	4901                	li	s2,0
  struct proc *traverse = proc;
    800038ca:	0000f797          	auipc	a5,0xf
    800038ce:	c9678793          	addi	a5,a5,-874 # 80012560 <proc>
  while(traverse < &proc[NPROC]){
    if(traverse->parent==p && traverse->state!=ZOMBIE){
    800038d2:	4615                	li	a2,5
  while(traverse < &proc[NPROC]){
    800038d4:	00016697          	auipc	a3,0x16
    800038d8:	e8c68693          	addi	a3,a3,-372 # 80019760 <tickslock>
    800038dc:	a031                	j	800038e8 <sys_getnumchild+0x3e>
      count++;
    800038de:	2905                	addiw	s2,s2,1
    }
    traverse++;
    800038e0:	1c878793          	addi	a5,a5,456
  while(traverse < &proc[NPROC]){
    800038e4:	00d78963          	beq	a5,a3,800038f6 <sys_getnumchild+0x4c>
    if(traverse->parent==p && traverse->state!=ZOMBIE){
    800038e8:	7f98                	ld	a4,56(a5)
    800038ea:	fe971be3          	bne	a4,s1,800038e0 <sys_getnumchild+0x36>
    800038ee:	4f98                	lw	a4,24(a5)
    800038f0:	fec717e3          	bne	a4,a2,800038de <sys_getnumchild+0x34>
    800038f4:	b7f5                	j	800038e0 <sys_getnumchild+0x36>
  }
  release(&wait_lock);
    800038f6:	0000f517          	auipc	a0,0xf
    800038fa:	85250513          	addi	a0,a0,-1966 # 80012148 <wait_lock>
    800038fe:	899fd0ef          	jal	80001196 <release>
  return count;
}
    80003902:	854a                	mv	a0,s2
    80003904:	60e2                	ld	ra,24(sp)
    80003906:	6442                	ld	s0,16(sp)
    80003908:	64a2                	ld	s1,8(sp)
    8000390a:	6902                	ld	s2,0(sp)
    8000390c:	6105                	addi	sp,sp,32
    8000390e:	8082                	ret

0000000080003910 <sys_getsyscount>:

uint64
sys_getsyscount(void)
{
    80003910:	1141                	addi	sp,sp,-16
    80003912:	e406                	sd	ra,8(sp)
    80003914:	e022                	sd	s0,0(sp)
    80003916:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80003918:	f52fe0ef          	jal	8000206a <myproc>
  return p->syscount;
}
    8000391c:	16853503          	ld	a0,360(a0)
    80003920:	60a2                	ld	ra,8(sp)
    80003922:	6402                	ld	s0,0(sp)
    80003924:	0141                	addi	sp,sp,16
    80003926:	8082                	ret

0000000080003928 <sys_getchildsyscount>:

uint64
sys_getchildsyscount(void){
    80003928:	7179                	addi	sp,sp,-48
    8000392a:	f406                	sd	ra,40(sp)
    8000392c:	f022                	sd	s0,32(sp)
    8000392e:	ec26                	sd	s1,24(sp)
    80003930:	1800                	addi	s0,sp,48
  int pid;
  struct proc *p = myproc();
    80003932:	f38fe0ef          	jal	8000206a <myproc>
    80003936:	84aa                	mv	s1,a0
  struct proc *traversal=proc;
  
  argint(0, &pid);
    80003938:	fdc40593          	addi	a1,s0,-36
    8000393c:	4501                	li	a0,0
    8000393e:	a29ff0ef          	jal	80003366 <argint>
  acquire(&wait_lock);
    80003942:	0000f517          	auipc	a0,0xf
    80003946:	80650513          	addi	a0,a0,-2042 # 80012148 <wait_lock>
    8000394a:	fb8fd0ef          	jal	80001102 <acquire>
  while(traversal<&proc[NPROC]){
    if(traversal->pid== pid && traversal->parent==p){
    8000394e:	fdc42683          	lw	a3,-36(s0)
  struct proc *traversal=proc;
    80003952:	0000f797          	auipc	a5,0xf
    80003956:	c0e78793          	addi	a5,a5,-1010 # 80012560 <proc>
  while(traversal<&proc[NPROC]){
    8000395a:	00016617          	auipc	a2,0x16
    8000395e:	e0660613          	addi	a2,a2,-506 # 80019760 <tickslock>
    80003962:	a029                	j	8000396c <sys_getchildsyscount+0x44>
      uint64 count = traversal->syscount;
      release(&wait_lock);
      return count;
    }
    traversal++;
    80003964:	1c878793          	addi	a5,a5,456
  while(traversal<&proc[NPROC]){
    80003968:	02c78663          	beq	a5,a2,80003994 <sys_getchildsyscount+0x6c>
    if(traversal->pid== pid && traversal->parent==p){
    8000396c:	5b98                	lw	a4,48(a5)
    8000396e:	fed71be3          	bne	a4,a3,80003964 <sys_getchildsyscount+0x3c>
    80003972:	7f98                	ld	a4,56(a5)
    80003974:	fe9718e3          	bne	a4,s1,80003964 <sys_getchildsyscount+0x3c>
      uint64 count = traversal->syscount;
    80003978:	1687b483          	ld	s1,360(a5)
      release(&wait_lock);
    8000397c:	0000e517          	auipc	a0,0xe
    80003980:	7cc50513          	addi	a0,a0,1996 # 80012148 <wait_lock>
    80003984:	813fd0ef          	jal	80001196 <release>
  release(&wait_lock);

  return -1;


}
    80003988:	8526                	mv	a0,s1
    8000398a:	70a2                	ld	ra,40(sp)
    8000398c:	7402                	ld	s0,32(sp)
    8000398e:	64e2                	ld	s1,24(sp)
    80003990:	6145                	addi	sp,sp,48
    80003992:	8082                	ret
  release(&wait_lock);
    80003994:	0000e517          	auipc	a0,0xe
    80003998:	7b450513          	addi	a0,a0,1972 # 80012148 <wait_lock>
    8000399c:	ffafd0ef          	jal	80001196 <release>
  return -1;
    800039a0:	54fd                	li	s1,-1
    800039a2:	b7dd                	j	80003988 <sys_getchildsyscount+0x60>

00000000800039a4 <sys_getlevel>:

uint64
sys_getlevel(void)
{
    800039a4:	1141                	addi	sp,sp,-16
    800039a6:	e406                	sd	ra,8(sp)
    800039a8:	e022                	sd	s0,0(sp)
    800039aa:	0800                	addi	s0,sp,16
    return myproc()->level;
    800039ac:	ebefe0ef          	jal	8000206a <myproc>
}
    800039b0:	17052503          	lw	a0,368(a0)
    800039b4:	60a2                	ld	ra,8(sp)
    800039b6:	6402                	ld	s0,0(sp)
    800039b8:	0141                	addi	sp,sp,16
    800039ba:	8082                	ret

00000000800039bc <sys_uptime>:
// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800039bc:	1101                	addi	sp,sp,-32
    800039be:	ec06                	sd	ra,24(sp)
    800039c0:	e822                	sd	s0,16(sp)
    800039c2:	e426                	sd	s1,8(sp)
    800039c4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800039c6:	00016517          	auipc	a0,0x16
    800039ca:	d9a50513          	addi	a0,a0,-614 # 80019760 <tickslock>
    800039ce:	f34fd0ef          	jal	80001102 <acquire>
  xticks = ticks;
    800039d2:	00006797          	auipc	a5,0x6
    800039d6:	11e7a783          	lw	a5,286(a5) # 80009af0 <ticks>
    800039da:	84be                	mv	s1,a5
  release(&tickslock);
    800039dc:	00016517          	auipc	a0,0x16
    800039e0:	d8450513          	addi	a0,a0,-636 # 80019760 <tickslock>
    800039e4:	fb2fd0ef          	jal	80001196 <release>
  return xticks;
}
    800039e8:	02049513          	slli	a0,s1,0x20
    800039ec:	9101                	srli	a0,a0,0x20
    800039ee:	60e2                	ld	ra,24(sp)
    800039f0:	6442                	ld	s0,16(sp)
    800039f2:	64a2                	ld	s1,8(sp)
    800039f4:	6105                	addi	sp,sp,32
    800039f6:	8082                	ret

00000000800039f8 <sys_getmlfqinfo>:

uint64
sys_getmlfqinfo(void)
{
    800039f8:	715d                	addi	sp,sp,-80
    800039fa:	e486                	sd	ra,72(sp)
    800039fc:	e0a2                	sd	s0,64(sp)
    800039fe:	fc26                	sd	s1,56(sp)
    80003a00:	f84a                	sd	s2,48(sp)
    80003a02:	0880                	addi	s0,sp,80
    int pid;
    uint64 addr;
    struct proc *p;

    argint(0, &pid);
    80003a04:	fdc40593          	addi	a1,s0,-36
    80003a08:	4501                	li	a0,0
    80003a0a:	95dff0ef          	jal	80003366 <argint>
    argaddr(1, &addr);
    80003a0e:	fd040593          	addi	a1,s0,-48
    80003a12:	4505                	li	a0,1
    80003a14:	96fff0ef          	jal	80003382 <argaddr>

    for(p = proc; p < &proc[NPROC]; p++){
    80003a18:	0000f497          	auipc	s1,0xf
    80003a1c:	b4848493          	addi	s1,s1,-1208 # 80012560 <proc>
    80003a20:	00016917          	auipc	s2,0x16
    80003a24:	d4090913          	addi	s2,s2,-704 # 80019760 <tickslock>
        acquire(&p->lock);
    80003a28:	8526                	mv	a0,s1
    80003a2a:	ed8fd0ef          	jal	80001102 <acquire>
        if(p->pid == pid){
    80003a2e:	5898                	lw	a4,48(s1)
    80003a30:	fdc42783          	lw	a5,-36(s0)
    80003a34:	00f70b63          	beq	a4,a5,80003a4a <sys_getmlfqinfo+0x52>
            if(copyout(myproc()->pagetable, addr,(char *)&info,sizeof(info)) < 0){
                return -1;
            }
            return 0;
        }
        release(&p->lock);
    80003a38:	8526                	mv	a0,s1
    80003a3a:	f5cfd0ef          	jal	80001196 <release>
    for(p = proc; p < &proc[NPROC]; p++){
    80003a3e:	1c848493          	addi	s1,s1,456
    80003a42:	ff2493e3          	bne	s1,s2,80003a28 <sys_getmlfqinfo+0x30>
    }

    return -1;
    80003a46:	557d                	li	a0,-1
    80003a48:	a899                	j	80003a9e <sys_getmlfqinfo+0xa6>
            info.level = p->level;
    80003a4a:	1704a783          	lw	a5,368(s1)
    80003a4e:	faf42823          	sw	a5,-80(s0)
            info.times_scheduled = p->times_scheduled;
    80003a52:	1884a783          	lw	a5,392(s1)
    80003a56:	fcf42223          	sw	a5,-60(s0)
            info.total_syscalls = p->syscount;
    80003a5a:	1684b783          	ld	a5,360(s1)
    80003a5e:	fcf42423          	sw	a5,-56(s0)
                info.ticks[i] = p->total_ticks[i];
    80003a62:	1784a783          	lw	a5,376(s1)
    80003a66:	faf42a23          	sw	a5,-76(s0)
    80003a6a:	17c4a783          	lw	a5,380(s1)
    80003a6e:	faf42c23          	sw	a5,-72(s0)
    80003a72:	1804a783          	lw	a5,384(s1)
    80003a76:	faf42e23          	sw	a5,-68(s0)
    80003a7a:	1844a783          	lw	a5,388(s1)
    80003a7e:	fcf42023          	sw	a5,-64(s0)
            release(&p->lock);
    80003a82:	8526                	mv	a0,s1
    80003a84:	f12fd0ef          	jal	80001196 <release>
            if(copyout(myproc()->pagetable, addr,(char *)&info,sizeof(info)) < 0){
    80003a88:	de2fe0ef          	jal	8000206a <myproc>
    80003a8c:	46f1                	li	a3,28
    80003a8e:	fb040613          	addi	a2,s0,-80
    80003a92:	fd043583          	ld	a1,-48(s0)
    80003a96:	6928                	ld	a0,80(a0)
    80003a98:	adcfe0ef          	jal	80001d74 <copyout>
    80003a9c:	957d                	srai	a0,a0,0x3f
}
    80003a9e:	60a6                	ld	ra,72(sp)
    80003aa0:	6406                	ld	s0,64(sp)
    80003aa2:	74e2                	ld	s1,56(sp)
    80003aa4:	7942                	ld	s2,48(sp)
    80003aa6:	6161                	addi	sp,sp,80
    80003aa8:	8082                	ret

0000000080003aaa <sys_getvmstats>:

uint64
sys_getvmstats(void)
{
    80003aaa:	715d                	addi	sp,sp,-80
    80003aac:	e486                	sd	ra,72(sp)
    80003aae:	e0a2                	sd	s0,64(sp)
    80003ab0:	0880                	addi	s0,sp,80
  int pid;
  uint64 addr;

  argint(0, &pid);
    80003ab2:	fec40593          	addi	a1,s0,-20
    80003ab6:	4501                	li	a0,0
    80003ab8:	8afff0ef          	jal	80003366 <argint>
  argaddr(1, &addr);
    80003abc:	fe040593          	addi	a1,s0,-32
    80003ac0:	4505                	li	a0,1
    80003ac2:	8c1ff0ef          	jal	80003382 <argaddr>

  struct vmstats s;

  if(getvmstats(pid, &s) < 0)
    80003ac6:	fb040593          	addi	a1,s0,-80
    80003aca:	fec42503          	lw	a0,-20(s0)
    80003ace:	a4cff0ef          	jal	80002d1a <getvmstats>
    80003ad2:	87aa                	mv	a5,a0
    return -1;
    80003ad4:	557d                	li	a0,-1
  if(getvmstats(pid, &s) < 0)
    80003ad6:	0007ce63          	bltz	a5,80003af2 <sys_getvmstats+0x48>

  if(copyout(myproc()->pagetable, addr, (char *)&s, sizeof(s)) < 0)
    80003ada:	d90fe0ef          	jal	8000206a <myproc>
    80003ade:	03000693          	li	a3,48
    80003ae2:	fb040613          	addi	a2,s0,-80
    80003ae6:	fe043583          	ld	a1,-32(s0)
    80003aea:	6928                	ld	a0,80(a0)
    80003aec:	a88fe0ef          	jal	80001d74 <copyout>
    80003af0:	957d                	srai	a0,a0,0x3f
    return -1;

  return 0;
}
    80003af2:	60a6                	ld	ra,72(sp)
    80003af4:	6406                	ld	s0,64(sp)
    80003af6:	6161                	addi	sp,sp,80
    80003af8:	8082                	ret

0000000080003afa <sys_setdisksched>:
uint64
sys_setdisksched(void)
{
    80003afa:	1101                	addi	sp,sp,-32
    80003afc:	ec06                	sd	ra,24(sp)
    80003afe:	e822                	sd	s0,16(sp)
    80003b00:	1000                	addi	s0,sp,32
  int policy;
  argint(0, &policy);
    80003b02:	fec40593          	addi	a1,s0,-20
    80003b06:	4501                	li	a0,0
    80003b08:	85fff0ef          	jal	80003366 <argint>
  if(policy != DISK_SCHED_FCFS && policy != DISK_SCHED_SSTF)
    80003b0c:	fec42783          	lw	a5,-20(s0)
    80003b10:	4705                	li	a4,1
    return -1;
    80003b12:	557d                	li	a0,-1
  if(policy != DISK_SCHED_FCFS && policy != DISK_SCHED_SSTF)
    80003b14:	00f76663          	bltu	a4,a5,80003b20 <sys_setdisksched+0x26>
  disksched_set_policy(policy);
    80003b18:	853e                	mv	a0,a5
    80003b1a:	7b6030ef          	jal	800072d0 <disksched_set_policy>
  return 0;
    80003b1e:	4501                	li	a0,0
    80003b20:	60e2                	ld	ra,24(sp)
    80003b22:	6442                	ld	s0,16(sp)
    80003b24:	6105                	addi	sp,sp,32
    80003b26:	8082                	ret

0000000080003b28 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003b28:	7179                	addi	sp,sp,-48
    80003b2a:	f406                	sd	ra,40(sp)
    80003b2c:	f022                	sd	s0,32(sp)
    80003b2e:	ec26                	sd	s1,24(sp)
    80003b30:	e84a                	sd	s2,16(sp)
    80003b32:	e44e                	sd	s3,8(sp)
    80003b34:	e052                	sd	s4,0(sp)
    80003b36:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003b38:	00006597          	auipc	a1,0x6
    80003b3c:	8a058593          	addi	a1,a1,-1888 # 800093d8 <etext+0x3d8>
    80003b40:	00017517          	auipc	a0,0x17
    80003b44:	c5050513          	addi	a0,a0,-944 # 8001a790 <bcache>
    80003b48:	d30fd0ef          	jal	80001078 <initlock>
  disksched_init();
    80003b4c:	714030ef          	jal	80007260 <disksched_init>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003b50:	0001f797          	auipc	a5,0x1f
    80003b54:	c4078793          	addi	a5,a5,-960 # 80022790 <bcache+0x8000>
    80003b58:	0001f717          	auipc	a4,0x1f
    80003b5c:	ea070713          	addi	a4,a4,-352 # 800229f8 <bcache+0x8268>
    80003b60:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003b64:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003b68:	00017497          	auipc	s1,0x17
    80003b6c:	c4048493          	addi	s1,s1,-960 # 8001a7a8 <bcache+0x18>
    b->next = bcache.head.next;
    80003b70:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003b72:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003b74:	00006a17          	auipc	s4,0x6
    80003b78:	86ca0a13          	addi	s4,s4,-1940 # 800093e0 <etext+0x3e0>
    b->next = bcache.head.next;
    80003b7c:	2b893783          	ld	a5,696(s2)
    80003b80:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003b82:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003b86:	85d2                	mv	a1,s4
    80003b88:	01048513          	addi	a0,s1,16
    80003b8c:	328010ef          	jal	80004eb4 <initsleeplock>
    bcache.head.next->prev = b;
    80003b90:	2b893783          	ld	a5,696(s2)
    80003b94:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003b96:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003b9a:	45848493          	addi	s1,s1,1112
    80003b9e:	fd349fe3          	bne	s1,s3,80003b7c <binit+0x54>
  }
}
    80003ba2:	70a2                	ld	ra,40(sp)
    80003ba4:	7402                	ld	s0,32(sp)
    80003ba6:	64e2                	ld	s1,24(sp)
    80003ba8:	6942                	ld	s2,16(sp)
    80003baa:	69a2                	ld	s3,8(sp)
    80003bac:	6a02                	ld	s4,0(sp)
    80003bae:	6145                	addi	sp,sp,48
    80003bb0:	8082                	ret

0000000080003bb2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003bb2:	7179                	addi	sp,sp,-48
    80003bb4:	f406                	sd	ra,40(sp)
    80003bb6:	f022                	sd	s0,32(sp)
    80003bb8:	ec26                	sd	s1,24(sp)
    80003bba:	e84a                	sd	s2,16(sp)
    80003bbc:	e44e                	sd	s3,8(sp)
    80003bbe:	1800                	addi	s0,sp,48
    80003bc0:	892a                	mv	s2,a0
    80003bc2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003bc4:	00017517          	auipc	a0,0x17
    80003bc8:	bcc50513          	addi	a0,a0,-1076 # 8001a790 <bcache>
    80003bcc:	d36fd0ef          	jal	80001102 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003bd0:	0001f497          	auipc	s1,0x1f
    80003bd4:	e784b483          	ld	s1,-392(s1) # 80022a48 <bcache+0x82b8>
    80003bd8:	0001f797          	auipc	a5,0x1f
    80003bdc:	e2078793          	addi	a5,a5,-480 # 800229f8 <bcache+0x8268>
    80003be0:	02f48b63          	beq	s1,a5,80003c16 <bread+0x64>
    80003be4:	873e                	mv	a4,a5
    80003be6:	a021                	j	80003bee <bread+0x3c>
    80003be8:	68a4                	ld	s1,80(s1)
    80003bea:	02e48663          	beq	s1,a4,80003c16 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80003bee:	449c                	lw	a5,8(s1)
    80003bf0:	ff279ce3          	bne	a5,s2,80003be8 <bread+0x36>
    80003bf4:	44dc                	lw	a5,12(s1)
    80003bf6:	ff3799e3          	bne	a5,s3,80003be8 <bread+0x36>
      b->refcnt++;
    80003bfa:	40bc                	lw	a5,64(s1)
    80003bfc:	2785                	addiw	a5,a5,1
    80003bfe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003c00:	00017517          	auipc	a0,0x17
    80003c04:	b9050513          	addi	a0,a0,-1136 # 8001a790 <bcache>
    80003c08:	d8efd0ef          	jal	80001196 <release>
      acquiresleep(&b->lock);
    80003c0c:	01048513          	addi	a0,s1,16
    80003c10:	2da010ef          	jal	80004eea <acquiresleep>
      return b;
    80003c14:	a889                	j	80003c66 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003c16:	0001f497          	auipc	s1,0x1f
    80003c1a:	e2a4b483          	ld	s1,-470(s1) # 80022a40 <bcache+0x82b0>
    80003c1e:	0001f797          	auipc	a5,0x1f
    80003c22:	dda78793          	addi	a5,a5,-550 # 800229f8 <bcache+0x8268>
    80003c26:	00f48863          	beq	s1,a5,80003c36 <bread+0x84>
    80003c2a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003c2c:	40bc                	lw	a5,64(s1)
    80003c2e:	cb91                	beqz	a5,80003c42 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003c30:	64a4                	ld	s1,72(s1)
    80003c32:	fee49de3          	bne	s1,a4,80003c2c <bread+0x7a>
  panic("bget: no buffers");
    80003c36:	00005517          	auipc	a0,0x5
    80003c3a:	7b250513          	addi	a0,a0,1970 # 800093e8 <etext+0x3e8>
    80003c3e:	be7fc0ef          	jal	80000824 <panic>
      b->dev = dev;
    80003c42:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003c46:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003c4a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003c4e:	4785                	li	a5,1
    80003c50:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003c52:	00017517          	auipc	a0,0x17
    80003c56:	b3e50513          	addi	a0,a0,-1218 # 8001a790 <bcache>
    80003c5a:	d3cfd0ef          	jal	80001196 <release>
      acquiresleep(&b->lock);
    80003c5e:	01048513          	addi	a0,s1,16
    80003c62:	288010ef          	jal	80004eea <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid){
    80003c66:	409c                	lw	a5,0(s1)
    80003c68:	cb89                	beqz	a5,80003c7a <bread+0xc8>
    disksched_submit(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003c6a:	8526                	mv	a0,s1
    80003c6c:	70a2                	ld	ra,40(sp)
    80003c6e:	7402                	ld	s0,32(sp)
    80003c70:	64e2                	ld	s1,24(sp)
    80003c72:	6942                	ld	s2,16(sp)
    80003c74:	69a2                	ld	s3,8(sp)
    80003c76:	6145                	addi	sp,sp,48
    80003c78:	8082                	ret
    disksched_submit(b, 0);
    80003c7a:	4581                	li	a1,0
    80003c7c:	8526                	mv	a0,s1
    80003c7e:	702030ef          	jal	80007380 <disksched_submit>
    b->valid = 1;
    80003c82:	4785                	li	a5,1
    80003c84:	c09c                	sw	a5,0(s1)
  return b;
    80003c86:	b7d5                	j	80003c6a <bread+0xb8>

0000000080003c88 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003c88:	1101                	addi	sp,sp,-32
    80003c8a:	ec06                	sd	ra,24(sp)
    80003c8c:	e822                	sd	s0,16(sp)
    80003c8e:	e426                	sd	s1,8(sp)
    80003c90:	1000                	addi	s0,sp,32
    80003c92:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003c94:	0541                	addi	a0,a0,16
    80003c96:	2d2010ef          	jal	80004f68 <holdingsleep>
    80003c9a:	c911                	beqz	a0,80003cae <bwrite+0x26>
    panic("bwrite");
  disksched_submit(b, 1);
    80003c9c:	4585                	li	a1,1
    80003c9e:	8526                	mv	a0,s1
    80003ca0:	6e0030ef          	jal	80007380 <disksched_submit>
}
    80003ca4:	60e2                	ld	ra,24(sp)
    80003ca6:	6442                	ld	s0,16(sp)
    80003ca8:	64a2                	ld	s1,8(sp)
    80003caa:	6105                	addi	sp,sp,32
    80003cac:	8082                	ret
    panic("bwrite");
    80003cae:	00005517          	auipc	a0,0x5
    80003cb2:	75250513          	addi	a0,a0,1874 # 80009400 <etext+0x400>
    80003cb6:	b6ffc0ef          	jal	80000824 <panic>

0000000080003cba <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003cba:	1101                	addi	sp,sp,-32
    80003cbc:	ec06                	sd	ra,24(sp)
    80003cbe:	e822                	sd	s0,16(sp)
    80003cc0:	e426                	sd	s1,8(sp)
    80003cc2:	e04a                	sd	s2,0(sp)
    80003cc4:	1000                	addi	s0,sp,32
    80003cc6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003cc8:	01050913          	addi	s2,a0,16
    80003ccc:	854a                	mv	a0,s2
    80003cce:	29a010ef          	jal	80004f68 <holdingsleep>
    80003cd2:	c125                	beqz	a0,80003d32 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80003cd4:	854a                	mv	a0,s2
    80003cd6:	25a010ef          	jal	80004f30 <releasesleep>

  acquire(&bcache.lock);
    80003cda:	00017517          	auipc	a0,0x17
    80003cde:	ab650513          	addi	a0,a0,-1354 # 8001a790 <bcache>
    80003ce2:	c20fd0ef          	jal	80001102 <acquire>
  b->refcnt--;
    80003ce6:	40bc                	lw	a5,64(s1)
    80003ce8:	37fd                	addiw	a5,a5,-1
    80003cea:	c0bc                	sw	a5,64(s1)
  if(b->refcnt == 0){
    80003cec:	e79d                	bnez	a5,80003d1a <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003cee:	68b8                	ld	a4,80(s1)
    80003cf0:	64bc                	ld	a5,72(s1)
    80003cf2:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003cf4:	68b8                	ld	a4,80(s1)
    80003cf6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003cf8:	0001f797          	auipc	a5,0x1f
    80003cfc:	a9878793          	addi	a5,a5,-1384 # 80022790 <bcache+0x8000>
    80003d00:	2b87b703          	ld	a4,696(a5)
    80003d04:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003d06:	0001f717          	auipc	a4,0x1f
    80003d0a:	cf270713          	addi	a4,a4,-782 # 800229f8 <bcache+0x8268>
    80003d0e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003d10:	2b87b703          	ld	a4,696(a5)
    80003d14:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003d16:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80003d1a:	00017517          	auipc	a0,0x17
    80003d1e:	a7650513          	addi	a0,a0,-1418 # 8001a790 <bcache>
    80003d22:	c74fd0ef          	jal	80001196 <release>
}
    80003d26:	60e2                	ld	ra,24(sp)
    80003d28:	6442                	ld	s0,16(sp)
    80003d2a:	64a2                	ld	s1,8(sp)
    80003d2c:	6902                	ld	s2,0(sp)
    80003d2e:	6105                	addi	sp,sp,32
    80003d30:	8082                	ret
    panic("brelse");
    80003d32:	00005517          	auipc	a0,0x5
    80003d36:	6d650513          	addi	a0,a0,1750 # 80009408 <etext+0x408>
    80003d3a:	aebfc0ef          	jal	80000824 <panic>

0000000080003d3e <bpin>:

void
bpin(struct buf *b)
{
    80003d3e:	1101                	addi	sp,sp,-32
    80003d40:	ec06                	sd	ra,24(sp)
    80003d42:	e822                	sd	s0,16(sp)
    80003d44:	e426                	sd	s1,8(sp)
    80003d46:	1000                	addi	s0,sp,32
    80003d48:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003d4a:	00017517          	auipc	a0,0x17
    80003d4e:	a4650513          	addi	a0,a0,-1466 # 8001a790 <bcache>
    80003d52:	bb0fd0ef          	jal	80001102 <acquire>
  b->refcnt++;
    80003d56:	40bc                	lw	a5,64(s1)
    80003d58:	2785                	addiw	a5,a5,1
    80003d5a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003d5c:	00017517          	auipc	a0,0x17
    80003d60:	a3450513          	addi	a0,a0,-1484 # 8001a790 <bcache>
    80003d64:	c32fd0ef          	jal	80001196 <release>
}
    80003d68:	60e2                	ld	ra,24(sp)
    80003d6a:	6442                	ld	s0,16(sp)
    80003d6c:	64a2                	ld	s1,8(sp)
    80003d6e:	6105                	addi	sp,sp,32
    80003d70:	8082                	ret

0000000080003d72 <bunpin>:

void
bunpin(struct buf *b)
{
    80003d72:	1101                	addi	sp,sp,-32
    80003d74:	ec06                	sd	ra,24(sp)
    80003d76:	e822                	sd	s0,16(sp)
    80003d78:	e426                	sd	s1,8(sp)
    80003d7a:	1000                	addi	s0,sp,32
    80003d7c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003d7e:	00017517          	auipc	a0,0x17
    80003d82:	a1250513          	addi	a0,a0,-1518 # 8001a790 <bcache>
    80003d86:	b7cfd0ef          	jal	80001102 <acquire>
  b->refcnt--;
    80003d8a:	40bc                	lw	a5,64(s1)
    80003d8c:	37fd                	addiw	a5,a5,-1
    80003d8e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003d90:	00017517          	auipc	a0,0x17
    80003d94:	a0050513          	addi	a0,a0,-1536 # 8001a790 <bcache>
    80003d98:	bfefd0ef          	jal	80001196 <release>
    80003d9c:	60e2                	ld	ra,24(sp)
    80003d9e:	6442                	ld	s0,16(sp)
    80003da0:	64a2                	ld	s1,8(sp)
    80003da2:	6105                	addi	sp,sp,32
    80003da4:	8082                	ret

0000000080003da6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003da6:	1101                	addi	sp,sp,-32
    80003da8:	ec06                	sd	ra,24(sp)
    80003daa:	e822                	sd	s0,16(sp)
    80003dac:	e426                	sd	s1,8(sp)
    80003dae:	e04a                	sd	s2,0(sp)
    80003db0:	1000                	addi	s0,sp,32
    80003db2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003db4:	00d5d79b          	srliw	a5,a1,0xd
    80003db8:	0001f597          	auipc	a1,0x1f
    80003dbc:	0b45a583          	lw	a1,180(a1) # 80022e6c <sb+0x1c>
    80003dc0:	9dbd                	addw	a1,a1,a5
    80003dc2:	df1ff0ef          	jal	80003bb2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003dc6:	0074f713          	andi	a4,s1,7
    80003dca:	4785                	li	a5,1
    80003dcc:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003dd0:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003dd2:	90d9                	srli	s1,s1,0x36
    80003dd4:	00950733          	add	a4,a0,s1
    80003dd8:	05874703          	lbu	a4,88(a4)
    80003ddc:	00e7f6b3          	and	a3,a5,a4
    80003de0:	c29d                	beqz	a3,80003e06 <bfree+0x60>
    80003de2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003de4:	94aa                	add	s1,s1,a0
    80003de6:	fff7c793          	not	a5,a5
    80003dea:	8f7d                	and	a4,a4,a5
    80003dec:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003df0:	000010ef          	jal	80004df0 <log_write>
  brelse(bp);
    80003df4:	854a                	mv	a0,s2
    80003df6:	ec5ff0ef          	jal	80003cba <brelse>
}
    80003dfa:	60e2                	ld	ra,24(sp)
    80003dfc:	6442                	ld	s0,16(sp)
    80003dfe:	64a2                	ld	s1,8(sp)
    80003e00:	6902                	ld	s2,0(sp)
    80003e02:	6105                	addi	sp,sp,32
    80003e04:	8082                	ret
    panic("freeing free block");
    80003e06:	00005517          	auipc	a0,0x5
    80003e0a:	60a50513          	addi	a0,a0,1546 # 80009410 <etext+0x410>
    80003e0e:	a17fc0ef          	jal	80000824 <panic>

0000000080003e12 <balloc>:
{
    80003e12:	715d                	addi	sp,sp,-80
    80003e14:	e486                	sd	ra,72(sp)
    80003e16:	e0a2                	sd	s0,64(sp)
    80003e18:	fc26                	sd	s1,56(sp)
    80003e1a:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003e1c:	0001f797          	auipc	a5,0x1f
    80003e20:	0387a783          	lw	a5,56(a5) # 80022e54 <sb+0x4>
    80003e24:	0e078263          	beqz	a5,80003f08 <balloc+0xf6>
    80003e28:	f84a                	sd	s2,48(sp)
    80003e2a:	f44e                	sd	s3,40(sp)
    80003e2c:	f052                	sd	s4,32(sp)
    80003e2e:	ec56                	sd	s5,24(sp)
    80003e30:	e85a                	sd	s6,16(sp)
    80003e32:	e45e                	sd	s7,8(sp)
    80003e34:	e062                	sd	s8,0(sp)
    80003e36:	8baa                	mv	s7,a0
    80003e38:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003e3a:	0001fb17          	auipc	s6,0x1f
    80003e3e:	016b0b13          	addi	s6,s6,22 # 80022e50 <sb>
      m = 1 << (bi % 8);
    80003e42:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003e44:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003e46:	6c09                	lui	s8,0x2
    80003e48:	a09d                	j	80003eae <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003e4a:	97ca                	add	a5,a5,s2
    80003e4c:	8e55                	or	a2,a2,a3
    80003e4e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003e52:	854a                	mv	a0,s2
    80003e54:	79d000ef          	jal	80004df0 <log_write>
        brelse(bp);
    80003e58:	854a                	mv	a0,s2
    80003e5a:	e61ff0ef          	jal	80003cba <brelse>
  bp = bread(dev, bno);
    80003e5e:	85a6                	mv	a1,s1
    80003e60:	855e                	mv	a0,s7
    80003e62:	d51ff0ef          	jal	80003bb2 <bread>
    80003e66:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003e68:	40000613          	li	a2,1024
    80003e6c:	4581                	li	a1,0
    80003e6e:	05850513          	addi	a0,a0,88
    80003e72:	b60fd0ef          	jal	800011d2 <memset>
  log_write(bp);
    80003e76:	854a                	mv	a0,s2
    80003e78:	779000ef          	jal	80004df0 <log_write>
  brelse(bp);
    80003e7c:	854a                	mv	a0,s2
    80003e7e:	e3dff0ef          	jal	80003cba <brelse>
}
    80003e82:	7942                	ld	s2,48(sp)
    80003e84:	79a2                	ld	s3,40(sp)
    80003e86:	7a02                	ld	s4,32(sp)
    80003e88:	6ae2                	ld	s5,24(sp)
    80003e8a:	6b42                	ld	s6,16(sp)
    80003e8c:	6ba2                	ld	s7,8(sp)
    80003e8e:	6c02                	ld	s8,0(sp)
}
    80003e90:	8526                	mv	a0,s1
    80003e92:	60a6                	ld	ra,72(sp)
    80003e94:	6406                	ld	s0,64(sp)
    80003e96:	74e2                	ld	s1,56(sp)
    80003e98:	6161                	addi	sp,sp,80
    80003e9a:	8082                	ret
    brelse(bp);
    80003e9c:	854a                	mv	a0,s2
    80003e9e:	e1dff0ef          	jal	80003cba <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003ea2:	015c0abb          	addw	s5,s8,s5
    80003ea6:	004b2783          	lw	a5,4(s6)
    80003eaa:	04faf863          	bgeu	s5,a5,80003efa <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80003eae:	40dad59b          	sraiw	a1,s5,0xd
    80003eb2:	01cb2783          	lw	a5,28(s6)
    80003eb6:	9dbd                	addw	a1,a1,a5
    80003eb8:	855e                	mv	a0,s7
    80003eba:	cf9ff0ef          	jal	80003bb2 <bread>
    80003ebe:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003ec0:	004b2503          	lw	a0,4(s6)
    80003ec4:	84d6                	mv	s1,s5
    80003ec6:	4701                	li	a4,0
    80003ec8:	fca4fae3          	bgeu	s1,a0,80003e9c <balloc+0x8a>
      m = 1 << (bi % 8);
    80003ecc:	00777693          	andi	a3,a4,7
    80003ed0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003ed4:	41f7579b          	sraiw	a5,a4,0x1f
    80003ed8:	01d7d79b          	srliw	a5,a5,0x1d
    80003edc:	9fb9                	addw	a5,a5,a4
    80003ede:	4037d79b          	sraiw	a5,a5,0x3
    80003ee2:	00f90633          	add	a2,s2,a5
    80003ee6:	05864603          	lbu	a2,88(a2)
    80003eea:	00c6f5b3          	and	a1,a3,a2
    80003eee:	ddb1                	beqz	a1,80003e4a <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003ef0:	2705                	addiw	a4,a4,1
    80003ef2:	2485                	addiw	s1,s1,1
    80003ef4:	fd471ae3          	bne	a4,s4,80003ec8 <balloc+0xb6>
    80003ef8:	b755                	j	80003e9c <balloc+0x8a>
    80003efa:	7942                	ld	s2,48(sp)
    80003efc:	79a2                	ld	s3,40(sp)
    80003efe:	7a02                	ld	s4,32(sp)
    80003f00:	6ae2                	ld	s5,24(sp)
    80003f02:	6b42                	ld	s6,16(sp)
    80003f04:	6ba2                	ld	s7,8(sp)
    80003f06:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003f08:	00005517          	auipc	a0,0x5
    80003f0c:	52050513          	addi	a0,a0,1312 # 80009428 <etext+0x428>
    80003f10:	deafc0ef          	jal	800004fa <printf>
  return 0;
    80003f14:	4481                	li	s1,0
    80003f16:	bfad                	j	80003e90 <balloc+0x7e>

0000000080003f18 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003f18:	7179                	addi	sp,sp,-48
    80003f1a:	f406                	sd	ra,40(sp)
    80003f1c:	f022                	sd	s0,32(sp)
    80003f1e:	ec26                	sd	s1,24(sp)
    80003f20:	e84a                	sd	s2,16(sp)
    80003f22:	e44e                	sd	s3,8(sp)
    80003f24:	1800                	addi	s0,sp,48
    80003f26:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003f28:	47ad                	li	a5,11
    80003f2a:	02b7e363          	bltu	a5,a1,80003f50 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80003f2e:	02059793          	slli	a5,a1,0x20
    80003f32:	01e7d593          	srli	a1,a5,0x1e
    80003f36:	00b509b3          	add	s3,a0,a1
    80003f3a:	0509a483          	lw	s1,80(s3)
    80003f3e:	e0b5                	bnez	s1,80003fa2 <bmap+0x8a>
      addr = balloc(ip->dev);
    80003f40:	4108                	lw	a0,0(a0)
    80003f42:	ed1ff0ef          	jal	80003e12 <balloc>
    80003f46:	84aa                	mv	s1,a0
      if(addr == 0)
    80003f48:	cd29                	beqz	a0,80003fa2 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80003f4a:	04a9a823          	sw	a0,80(s3)
    80003f4e:	a891                	j	80003fa2 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003f50:	ff45879b          	addiw	a5,a1,-12
    80003f54:	873e                	mv	a4,a5
    80003f56:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80003f58:	0ff00793          	li	a5,255
    80003f5c:	06e7e763          	bltu	a5,a4,80003fca <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003f60:	08052483          	lw	s1,128(a0)
    80003f64:	e891                	bnez	s1,80003f78 <bmap+0x60>
      addr = balloc(ip->dev);
    80003f66:	4108                	lw	a0,0(a0)
    80003f68:	eabff0ef          	jal	80003e12 <balloc>
    80003f6c:	84aa                	mv	s1,a0
      if(addr == 0)
    80003f6e:	c915                	beqz	a0,80003fa2 <bmap+0x8a>
    80003f70:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003f72:	08a92023          	sw	a0,128(s2)
    80003f76:	a011                	j	80003f7a <bmap+0x62>
    80003f78:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003f7a:	85a6                	mv	a1,s1
    80003f7c:	00092503          	lw	a0,0(s2)
    80003f80:	c33ff0ef          	jal	80003bb2 <bread>
    80003f84:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003f86:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003f8a:	02099713          	slli	a4,s3,0x20
    80003f8e:	01e75593          	srli	a1,a4,0x1e
    80003f92:	97ae                	add	a5,a5,a1
    80003f94:	89be                	mv	s3,a5
    80003f96:	4384                	lw	s1,0(a5)
    80003f98:	cc89                	beqz	s1,80003fb2 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003f9a:	8552                	mv	a0,s4
    80003f9c:	d1fff0ef          	jal	80003cba <brelse>
    return addr;
    80003fa0:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003fa2:	8526                	mv	a0,s1
    80003fa4:	70a2                	ld	ra,40(sp)
    80003fa6:	7402                	ld	s0,32(sp)
    80003fa8:	64e2                	ld	s1,24(sp)
    80003faa:	6942                	ld	s2,16(sp)
    80003fac:	69a2                	ld	s3,8(sp)
    80003fae:	6145                	addi	sp,sp,48
    80003fb0:	8082                	ret
      addr = balloc(ip->dev);
    80003fb2:	00092503          	lw	a0,0(s2)
    80003fb6:	e5dff0ef          	jal	80003e12 <balloc>
    80003fba:	84aa                	mv	s1,a0
      if(addr){
    80003fbc:	dd79                	beqz	a0,80003f9a <bmap+0x82>
        a[bn] = addr;
    80003fbe:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003fc2:	8552                	mv	a0,s4
    80003fc4:	62d000ef          	jal	80004df0 <log_write>
    80003fc8:	bfc9                	j	80003f9a <bmap+0x82>
    80003fca:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003fcc:	00005517          	auipc	a0,0x5
    80003fd0:	47450513          	addi	a0,a0,1140 # 80009440 <etext+0x440>
    80003fd4:	851fc0ef          	jal	80000824 <panic>

0000000080003fd8 <iget>:
{
    80003fd8:	7179                	addi	sp,sp,-48
    80003fda:	f406                	sd	ra,40(sp)
    80003fdc:	f022                	sd	s0,32(sp)
    80003fde:	ec26                	sd	s1,24(sp)
    80003fe0:	e84a                	sd	s2,16(sp)
    80003fe2:	e44e                	sd	s3,8(sp)
    80003fe4:	e052                	sd	s4,0(sp)
    80003fe6:	1800                	addi	s0,sp,48
    80003fe8:	892a                	mv	s2,a0
    80003fea:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003fec:	0001f517          	auipc	a0,0x1f
    80003ff0:	e8450513          	addi	a0,a0,-380 # 80022e70 <itable>
    80003ff4:	90efd0ef          	jal	80001102 <acquire>
  empty = 0;
    80003ff8:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003ffa:	0001f497          	auipc	s1,0x1f
    80003ffe:	e8e48493          	addi	s1,s1,-370 # 80022e88 <itable+0x18>
    80004002:	00021697          	auipc	a3,0x21
    80004006:	91668693          	addi	a3,a3,-1770 # 80024918 <log>
    8000400a:	a809                	j	8000401c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000400c:	e781                	bnez	a5,80004014 <iget+0x3c>
    8000400e:	00099363          	bnez	s3,80004014 <iget+0x3c>
      empty = ip;
    80004012:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004014:	08848493          	addi	s1,s1,136
    80004018:	02d48563          	beq	s1,a3,80004042 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000401c:	449c                	lw	a5,8(s1)
    8000401e:	fef057e3          	blez	a5,8000400c <iget+0x34>
    80004022:	4098                	lw	a4,0(s1)
    80004024:	ff2718e3          	bne	a4,s2,80004014 <iget+0x3c>
    80004028:	40d8                	lw	a4,4(s1)
    8000402a:	ff4715e3          	bne	a4,s4,80004014 <iget+0x3c>
      ip->ref++;
    8000402e:	2785                	addiw	a5,a5,1
    80004030:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80004032:	0001f517          	auipc	a0,0x1f
    80004036:	e3e50513          	addi	a0,a0,-450 # 80022e70 <itable>
    8000403a:	95cfd0ef          	jal	80001196 <release>
      return ip;
    8000403e:	89a6                	mv	s3,s1
    80004040:	a015                	j	80004064 <iget+0x8c>
  if(empty == 0)
    80004042:	02098a63          	beqz	s3,80004076 <iget+0x9e>
  ip->dev = dev;
    80004046:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    8000404a:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    8000404e:	4785                	li	a5,1
    80004050:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80004054:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80004058:	0001f517          	auipc	a0,0x1f
    8000405c:	e1850513          	addi	a0,a0,-488 # 80022e70 <itable>
    80004060:	936fd0ef          	jal	80001196 <release>
}
    80004064:	854e                	mv	a0,s3
    80004066:	70a2                	ld	ra,40(sp)
    80004068:	7402                	ld	s0,32(sp)
    8000406a:	64e2                	ld	s1,24(sp)
    8000406c:	6942                	ld	s2,16(sp)
    8000406e:	69a2                	ld	s3,8(sp)
    80004070:	6a02                	ld	s4,0(sp)
    80004072:	6145                	addi	sp,sp,48
    80004074:	8082                	ret
    panic("iget: no inodes");
    80004076:	00005517          	auipc	a0,0x5
    8000407a:	3e250513          	addi	a0,a0,994 # 80009458 <etext+0x458>
    8000407e:	fa6fc0ef          	jal	80000824 <panic>

0000000080004082 <iinit>:
{
    80004082:	7179                	addi	sp,sp,-48
    80004084:	f406                	sd	ra,40(sp)
    80004086:	f022                	sd	s0,32(sp)
    80004088:	ec26                	sd	s1,24(sp)
    8000408a:	e84a                	sd	s2,16(sp)
    8000408c:	e44e                	sd	s3,8(sp)
    8000408e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80004090:	00005597          	auipc	a1,0x5
    80004094:	3d858593          	addi	a1,a1,984 # 80009468 <etext+0x468>
    80004098:	0001f517          	auipc	a0,0x1f
    8000409c:	dd850513          	addi	a0,a0,-552 # 80022e70 <itable>
    800040a0:	fd9fc0ef          	jal	80001078 <initlock>
  for(i = 0; i < NINODE; i++) {
    800040a4:	0001f497          	auipc	s1,0x1f
    800040a8:	df448493          	addi	s1,s1,-524 # 80022e98 <itable+0x28>
    800040ac:	00021997          	auipc	s3,0x21
    800040b0:	87c98993          	addi	s3,s3,-1924 # 80024928 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800040b4:	00005917          	auipc	s2,0x5
    800040b8:	3bc90913          	addi	s2,s2,956 # 80009470 <etext+0x470>
    800040bc:	85ca                	mv	a1,s2
    800040be:	8526                	mv	a0,s1
    800040c0:	5f5000ef          	jal	80004eb4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800040c4:	08848493          	addi	s1,s1,136
    800040c8:	ff349ae3          	bne	s1,s3,800040bc <iinit+0x3a>
}
    800040cc:	70a2                	ld	ra,40(sp)
    800040ce:	7402                	ld	s0,32(sp)
    800040d0:	64e2                	ld	s1,24(sp)
    800040d2:	6942                	ld	s2,16(sp)
    800040d4:	69a2                	ld	s3,8(sp)
    800040d6:	6145                	addi	sp,sp,48
    800040d8:	8082                	ret

00000000800040da <ialloc>:
{
    800040da:	7139                	addi	sp,sp,-64
    800040dc:	fc06                	sd	ra,56(sp)
    800040de:	f822                	sd	s0,48(sp)
    800040e0:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800040e2:	0001f717          	auipc	a4,0x1f
    800040e6:	d7a72703          	lw	a4,-646(a4) # 80022e5c <sb+0xc>
    800040ea:	4785                	li	a5,1
    800040ec:	06e7f063          	bgeu	a5,a4,8000414c <ialloc+0x72>
    800040f0:	f426                	sd	s1,40(sp)
    800040f2:	f04a                	sd	s2,32(sp)
    800040f4:	ec4e                	sd	s3,24(sp)
    800040f6:	e852                	sd	s4,16(sp)
    800040f8:	e456                	sd	s5,8(sp)
    800040fa:	e05a                	sd	s6,0(sp)
    800040fc:	8aaa                	mv	s5,a0
    800040fe:	8b2e                	mv	s6,a1
    80004100:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80004102:	0001fa17          	auipc	s4,0x1f
    80004106:	d4ea0a13          	addi	s4,s4,-690 # 80022e50 <sb>
    8000410a:	00495593          	srli	a1,s2,0x4
    8000410e:	018a2783          	lw	a5,24(s4)
    80004112:	9dbd                	addw	a1,a1,a5
    80004114:	8556                	mv	a0,s5
    80004116:	a9dff0ef          	jal	80003bb2 <bread>
    8000411a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000411c:	05850993          	addi	s3,a0,88
    80004120:	00f97793          	andi	a5,s2,15
    80004124:	079a                	slli	a5,a5,0x6
    80004126:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80004128:	00099783          	lh	a5,0(s3)
    8000412c:	cb9d                	beqz	a5,80004162 <ialloc+0x88>
    brelse(bp);
    8000412e:	b8dff0ef          	jal	80003cba <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004132:	0905                	addi	s2,s2,1
    80004134:	00ca2703          	lw	a4,12(s4)
    80004138:	0009079b          	sext.w	a5,s2
    8000413c:	fce7e7e3          	bltu	a5,a4,8000410a <ialloc+0x30>
    80004140:	74a2                	ld	s1,40(sp)
    80004142:	7902                	ld	s2,32(sp)
    80004144:	69e2                	ld	s3,24(sp)
    80004146:	6a42                	ld	s4,16(sp)
    80004148:	6aa2                	ld	s5,8(sp)
    8000414a:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000414c:	00005517          	auipc	a0,0x5
    80004150:	32c50513          	addi	a0,a0,812 # 80009478 <etext+0x478>
    80004154:	ba6fc0ef          	jal	800004fa <printf>
  return 0;
    80004158:	4501                	li	a0,0
}
    8000415a:	70e2                	ld	ra,56(sp)
    8000415c:	7442                	ld	s0,48(sp)
    8000415e:	6121                	addi	sp,sp,64
    80004160:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80004162:	04000613          	li	a2,64
    80004166:	4581                	li	a1,0
    80004168:	854e                	mv	a0,s3
    8000416a:	868fd0ef          	jal	800011d2 <memset>
      dip->type = type;
    8000416e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80004172:	8526                	mv	a0,s1
    80004174:	47d000ef          	jal	80004df0 <log_write>
      brelse(bp);
    80004178:	8526                	mv	a0,s1
    8000417a:	b41ff0ef          	jal	80003cba <brelse>
      return iget(dev, inum);
    8000417e:	0009059b          	sext.w	a1,s2
    80004182:	8556                	mv	a0,s5
    80004184:	e55ff0ef          	jal	80003fd8 <iget>
    80004188:	74a2                	ld	s1,40(sp)
    8000418a:	7902                	ld	s2,32(sp)
    8000418c:	69e2                	ld	s3,24(sp)
    8000418e:	6a42                	ld	s4,16(sp)
    80004190:	6aa2                	ld	s5,8(sp)
    80004192:	6b02                	ld	s6,0(sp)
    80004194:	b7d9                	j	8000415a <ialloc+0x80>

0000000080004196 <iupdate>:
{
    80004196:	1101                	addi	sp,sp,-32
    80004198:	ec06                	sd	ra,24(sp)
    8000419a:	e822                	sd	s0,16(sp)
    8000419c:	e426                	sd	s1,8(sp)
    8000419e:	e04a                	sd	s2,0(sp)
    800041a0:	1000                	addi	s0,sp,32
    800041a2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800041a4:	415c                	lw	a5,4(a0)
    800041a6:	0047d79b          	srliw	a5,a5,0x4
    800041aa:	0001f597          	auipc	a1,0x1f
    800041ae:	cbe5a583          	lw	a1,-834(a1) # 80022e68 <sb+0x18>
    800041b2:	9dbd                	addw	a1,a1,a5
    800041b4:	4108                	lw	a0,0(a0)
    800041b6:	9fdff0ef          	jal	80003bb2 <bread>
    800041ba:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800041bc:	05850793          	addi	a5,a0,88
    800041c0:	40d8                	lw	a4,4(s1)
    800041c2:	8b3d                	andi	a4,a4,15
    800041c4:	071a                	slli	a4,a4,0x6
    800041c6:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800041c8:	04449703          	lh	a4,68(s1)
    800041cc:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800041d0:	04649703          	lh	a4,70(s1)
    800041d4:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800041d8:	04849703          	lh	a4,72(s1)
    800041dc:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800041e0:	04a49703          	lh	a4,74(s1)
    800041e4:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800041e8:	44f8                	lw	a4,76(s1)
    800041ea:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800041ec:	03400613          	li	a2,52
    800041f0:	05048593          	addi	a1,s1,80
    800041f4:	00c78513          	addi	a0,a5,12
    800041f8:	83afd0ef          	jal	80001232 <memmove>
  log_write(bp);
    800041fc:	854a                	mv	a0,s2
    800041fe:	3f3000ef          	jal	80004df0 <log_write>
  brelse(bp);
    80004202:	854a                	mv	a0,s2
    80004204:	ab7ff0ef          	jal	80003cba <brelse>
}
    80004208:	60e2                	ld	ra,24(sp)
    8000420a:	6442                	ld	s0,16(sp)
    8000420c:	64a2                	ld	s1,8(sp)
    8000420e:	6902                	ld	s2,0(sp)
    80004210:	6105                	addi	sp,sp,32
    80004212:	8082                	ret

0000000080004214 <idup>:
{
    80004214:	1101                	addi	sp,sp,-32
    80004216:	ec06                	sd	ra,24(sp)
    80004218:	e822                	sd	s0,16(sp)
    8000421a:	e426                	sd	s1,8(sp)
    8000421c:	1000                	addi	s0,sp,32
    8000421e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004220:	0001f517          	auipc	a0,0x1f
    80004224:	c5050513          	addi	a0,a0,-944 # 80022e70 <itable>
    80004228:	edbfc0ef          	jal	80001102 <acquire>
  ip->ref++;
    8000422c:	449c                	lw	a5,8(s1)
    8000422e:	2785                	addiw	a5,a5,1
    80004230:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004232:	0001f517          	auipc	a0,0x1f
    80004236:	c3e50513          	addi	a0,a0,-962 # 80022e70 <itable>
    8000423a:	f5dfc0ef          	jal	80001196 <release>
}
    8000423e:	8526                	mv	a0,s1
    80004240:	60e2                	ld	ra,24(sp)
    80004242:	6442                	ld	s0,16(sp)
    80004244:	64a2                	ld	s1,8(sp)
    80004246:	6105                	addi	sp,sp,32
    80004248:	8082                	ret

000000008000424a <ilock>:
{
    8000424a:	1101                	addi	sp,sp,-32
    8000424c:	ec06                	sd	ra,24(sp)
    8000424e:	e822                	sd	s0,16(sp)
    80004250:	e426                	sd	s1,8(sp)
    80004252:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80004254:	cd19                	beqz	a0,80004272 <ilock+0x28>
    80004256:	84aa                	mv	s1,a0
    80004258:	451c                	lw	a5,8(a0)
    8000425a:	00f05c63          	blez	a5,80004272 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000425e:	0541                	addi	a0,a0,16
    80004260:	48b000ef          	jal	80004eea <acquiresleep>
  if(ip->valid == 0){
    80004264:	40bc                	lw	a5,64(s1)
    80004266:	cf89                	beqz	a5,80004280 <ilock+0x36>
}
    80004268:	60e2                	ld	ra,24(sp)
    8000426a:	6442                	ld	s0,16(sp)
    8000426c:	64a2                	ld	s1,8(sp)
    8000426e:	6105                	addi	sp,sp,32
    80004270:	8082                	ret
    80004272:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80004274:	00005517          	auipc	a0,0x5
    80004278:	21c50513          	addi	a0,a0,540 # 80009490 <etext+0x490>
    8000427c:	da8fc0ef          	jal	80000824 <panic>
    80004280:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004282:	40dc                	lw	a5,4(s1)
    80004284:	0047d79b          	srliw	a5,a5,0x4
    80004288:	0001f597          	auipc	a1,0x1f
    8000428c:	be05a583          	lw	a1,-1056(a1) # 80022e68 <sb+0x18>
    80004290:	9dbd                	addw	a1,a1,a5
    80004292:	4088                	lw	a0,0(s1)
    80004294:	91fff0ef          	jal	80003bb2 <bread>
    80004298:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000429a:	05850593          	addi	a1,a0,88
    8000429e:	40dc                	lw	a5,4(s1)
    800042a0:	8bbd                	andi	a5,a5,15
    800042a2:	079a                	slli	a5,a5,0x6
    800042a4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800042a6:	00059783          	lh	a5,0(a1)
    800042aa:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800042ae:	00259783          	lh	a5,2(a1)
    800042b2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800042b6:	00459783          	lh	a5,4(a1)
    800042ba:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800042be:	00659783          	lh	a5,6(a1)
    800042c2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800042c6:	459c                	lw	a5,8(a1)
    800042c8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800042ca:	03400613          	li	a2,52
    800042ce:	05b1                	addi	a1,a1,12
    800042d0:	05048513          	addi	a0,s1,80
    800042d4:	f5ffc0ef          	jal	80001232 <memmove>
    brelse(bp);
    800042d8:	854a                	mv	a0,s2
    800042da:	9e1ff0ef          	jal	80003cba <brelse>
    ip->valid = 1;
    800042de:	4785                	li	a5,1
    800042e0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800042e2:	04449783          	lh	a5,68(s1)
    800042e6:	c399                	beqz	a5,800042ec <ilock+0xa2>
    800042e8:	6902                	ld	s2,0(sp)
    800042ea:	bfbd                	j	80004268 <ilock+0x1e>
      panic("ilock: no type");
    800042ec:	00005517          	auipc	a0,0x5
    800042f0:	1ac50513          	addi	a0,a0,428 # 80009498 <etext+0x498>
    800042f4:	d30fc0ef          	jal	80000824 <panic>

00000000800042f8 <iunlock>:
{
    800042f8:	1101                	addi	sp,sp,-32
    800042fa:	ec06                	sd	ra,24(sp)
    800042fc:	e822                	sd	s0,16(sp)
    800042fe:	e426                	sd	s1,8(sp)
    80004300:	e04a                	sd	s2,0(sp)
    80004302:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004304:	c505                	beqz	a0,8000432c <iunlock+0x34>
    80004306:	84aa                	mv	s1,a0
    80004308:	01050913          	addi	s2,a0,16
    8000430c:	854a                	mv	a0,s2
    8000430e:	45b000ef          	jal	80004f68 <holdingsleep>
    80004312:	cd09                	beqz	a0,8000432c <iunlock+0x34>
    80004314:	449c                	lw	a5,8(s1)
    80004316:	00f05b63          	blez	a5,8000432c <iunlock+0x34>
  releasesleep(&ip->lock);
    8000431a:	854a                	mv	a0,s2
    8000431c:	415000ef          	jal	80004f30 <releasesleep>
}
    80004320:	60e2                	ld	ra,24(sp)
    80004322:	6442                	ld	s0,16(sp)
    80004324:	64a2                	ld	s1,8(sp)
    80004326:	6902                	ld	s2,0(sp)
    80004328:	6105                	addi	sp,sp,32
    8000432a:	8082                	ret
    panic("iunlock");
    8000432c:	00005517          	auipc	a0,0x5
    80004330:	17c50513          	addi	a0,a0,380 # 800094a8 <etext+0x4a8>
    80004334:	cf0fc0ef          	jal	80000824 <panic>

0000000080004338 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004338:	7179                	addi	sp,sp,-48
    8000433a:	f406                	sd	ra,40(sp)
    8000433c:	f022                	sd	s0,32(sp)
    8000433e:	ec26                	sd	s1,24(sp)
    80004340:	e84a                	sd	s2,16(sp)
    80004342:	e44e                	sd	s3,8(sp)
    80004344:	1800                	addi	s0,sp,48
    80004346:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004348:	05050493          	addi	s1,a0,80
    8000434c:	08050913          	addi	s2,a0,128
    80004350:	a021                	j	80004358 <itrunc+0x20>
    80004352:	0491                	addi	s1,s1,4
    80004354:	01248b63          	beq	s1,s2,8000436a <itrunc+0x32>
    if(ip->addrs[i]){
    80004358:	408c                	lw	a1,0(s1)
    8000435a:	dde5                	beqz	a1,80004352 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000435c:	0009a503          	lw	a0,0(s3)
    80004360:	a47ff0ef          	jal	80003da6 <bfree>
      ip->addrs[i] = 0;
    80004364:	0004a023          	sw	zero,0(s1)
    80004368:	b7ed                	j	80004352 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000436a:	0809a583          	lw	a1,128(s3)
    8000436e:	ed89                	bnez	a1,80004388 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004370:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004374:	854e                	mv	a0,s3
    80004376:	e21ff0ef          	jal	80004196 <iupdate>
}
    8000437a:	70a2                	ld	ra,40(sp)
    8000437c:	7402                	ld	s0,32(sp)
    8000437e:	64e2                	ld	s1,24(sp)
    80004380:	6942                	ld	s2,16(sp)
    80004382:	69a2                	ld	s3,8(sp)
    80004384:	6145                	addi	sp,sp,48
    80004386:	8082                	ret
    80004388:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000438a:	0009a503          	lw	a0,0(s3)
    8000438e:	825ff0ef          	jal	80003bb2 <bread>
    80004392:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004394:	05850493          	addi	s1,a0,88
    80004398:	45850913          	addi	s2,a0,1112
    8000439c:	a021                	j	800043a4 <itrunc+0x6c>
    8000439e:	0491                	addi	s1,s1,4
    800043a0:	01248963          	beq	s1,s2,800043b2 <itrunc+0x7a>
      if(a[j])
    800043a4:	408c                	lw	a1,0(s1)
    800043a6:	dde5                	beqz	a1,8000439e <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800043a8:	0009a503          	lw	a0,0(s3)
    800043ac:	9fbff0ef          	jal	80003da6 <bfree>
    800043b0:	b7fd                	j	8000439e <itrunc+0x66>
    brelse(bp);
    800043b2:	8552                	mv	a0,s4
    800043b4:	907ff0ef          	jal	80003cba <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800043b8:	0809a583          	lw	a1,128(s3)
    800043bc:	0009a503          	lw	a0,0(s3)
    800043c0:	9e7ff0ef          	jal	80003da6 <bfree>
    ip->addrs[NDIRECT] = 0;
    800043c4:	0809a023          	sw	zero,128(s3)
    800043c8:	6a02                	ld	s4,0(sp)
    800043ca:	b75d                	j	80004370 <itrunc+0x38>

00000000800043cc <iput>:
{
    800043cc:	1101                	addi	sp,sp,-32
    800043ce:	ec06                	sd	ra,24(sp)
    800043d0:	e822                	sd	s0,16(sp)
    800043d2:	e426                	sd	s1,8(sp)
    800043d4:	1000                	addi	s0,sp,32
    800043d6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800043d8:	0001f517          	auipc	a0,0x1f
    800043dc:	a9850513          	addi	a0,a0,-1384 # 80022e70 <itable>
    800043e0:	d23fc0ef          	jal	80001102 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800043e4:	4498                	lw	a4,8(s1)
    800043e6:	4785                	li	a5,1
    800043e8:	02f70063          	beq	a4,a5,80004408 <iput+0x3c>
  ip->ref--;
    800043ec:	449c                	lw	a5,8(s1)
    800043ee:	37fd                	addiw	a5,a5,-1
    800043f0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800043f2:	0001f517          	auipc	a0,0x1f
    800043f6:	a7e50513          	addi	a0,a0,-1410 # 80022e70 <itable>
    800043fa:	d9dfc0ef          	jal	80001196 <release>
}
    800043fe:	60e2                	ld	ra,24(sp)
    80004400:	6442                	ld	s0,16(sp)
    80004402:	64a2                	ld	s1,8(sp)
    80004404:	6105                	addi	sp,sp,32
    80004406:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004408:	40bc                	lw	a5,64(s1)
    8000440a:	d3ed                	beqz	a5,800043ec <iput+0x20>
    8000440c:	04a49783          	lh	a5,74(s1)
    80004410:	fff1                	bnez	a5,800043ec <iput+0x20>
    80004412:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80004414:	01048793          	addi	a5,s1,16
    80004418:	893e                	mv	s2,a5
    8000441a:	853e                	mv	a0,a5
    8000441c:	2cf000ef          	jal	80004eea <acquiresleep>
    release(&itable.lock);
    80004420:	0001f517          	auipc	a0,0x1f
    80004424:	a5050513          	addi	a0,a0,-1456 # 80022e70 <itable>
    80004428:	d6ffc0ef          	jal	80001196 <release>
    itrunc(ip);
    8000442c:	8526                	mv	a0,s1
    8000442e:	f0bff0ef          	jal	80004338 <itrunc>
    ip->type = 0;
    80004432:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004436:	8526                	mv	a0,s1
    80004438:	d5fff0ef          	jal	80004196 <iupdate>
    ip->valid = 0;
    8000443c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004440:	854a                	mv	a0,s2
    80004442:	2ef000ef          	jal	80004f30 <releasesleep>
    acquire(&itable.lock);
    80004446:	0001f517          	auipc	a0,0x1f
    8000444a:	a2a50513          	addi	a0,a0,-1494 # 80022e70 <itable>
    8000444e:	cb5fc0ef          	jal	80001102 <acquire>
    80004452:	6902                	ld	s2,0(sp)
    80004454:	bf61                	j	800043ec <iput+0x20>

0000000080004456 <iunlockput>:
{
    80004456:	1101                	addi	sp,sp,-32
    80004458:	ec06                	sd	ra,24(sp)
    8000445a:	e822                	sd	s0,16(sp)
    8000445c:	e426                	sd	s1,8(sp)
    8000445e:	1000                	addi	s0,sp,32
    80004460:	84aa                	mv	s1,a0
  iunlock(ip);
    80004462:	e97ff0ef          	jal	800042f8 <iunlock>
  iput(ip);
    80004466:	8526                	mv	a0,s1
    80004468:	f65ff0ef          	jal	800043cc <iput>
}
    8000446c:	60e2                	ld	ra,24(sp)
    8000446e:	6442                	ld	s0,16(sp)
    80004470:	64a2                	ld	s1,8(sp)
    80004472:	6105                	addi	sp,sp,32
    80004474:	8082                	ret

0000000080004476 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80004476:	0001f717          	auipc	a4,0x1f
    8000447a:	9e672703          	lw	a4,-1562(a4) # 80022e5c <sb+0xc>
    8000447e:	4785                	li	a5,1
    80004480:	0ae7fe63          	bgeu	a5,a4,8000453c <ireclaim+0xc6>
{
    80004484:	7139                	addi	sp,sp,-64
    80004486:	fc06                	sd	ra,56(sp)
    80004488:	f822                	sd	s0,48(sp)
    8000448a:	f426                	sd	s1,40(sp)
    8000448c:	f04a                	sd	s2,32(sp)
    8000448e:	ec4e                	sd	s3,24(sp)
    80004490:	e852                	sd	s4,16(sp)
    80004492:	e456                	sd	s5,8(sp)
    80004494:	e05a                	sd	s6,0(sp)
    80004496:	0080                	addi	s0,sp,64
    80004498:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000449a:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000449c:	0001fa17          	auipc	s4,0x1f
    800044a0:	9b4a0a13          	addi	s4,s4,-1612 # 80022e50 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800044a4:	00005b17          	auipc	s6,0x5
    800044a8:	00cb0b13          	addi	s6,s6,12 # 800094b0 <etext+0x4b0>
    800044ac:	a099                	j	800044f2 <ireclaim+0x7c>
    800044ae:	85ce                	mv	a1,s3
    800044b0:	855a                	mv	a0,s6
    800044b2:	848fc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    800044b6:	85ce                	mv	a1,s3
    800044b8:	8556                	mv	a0,s5
    800044ba:	b1fff0ef          	jal	80003fd8 <iget>
    800044be:	89aa                	mv	s3,a0
    brelse(bp);
    800044c0:	854a                	mv	a0,s2
    800044c2:	ff8ff0ef          	jal	80003cba <brelse>
    if (ip) {
    800044c6:	00098f63          	beqz	s3,800044e4 <ireclaim+0x6e>
      begin_op();
    800044ca:	78c000ef          	jal	80004c56 <begin_op>
      ilock(ip);
    800044ce:	854e                	mv	a0,s3
    800044d0:	d7bff0ef          	jal	8000424a <ilock>
      iunlock(ip);
    800044d4:	854e                	mv	a0,s3
    800044d6:	e23ff0ef          	jal	800042f8 <iunlock>
      iput(ip);
    800044da:	854e                	mv	a0,s3
    800044dc:	ef1ff0ef          	jal	800043cc <iput>
      end_op();
    800044e0:	7e6000ef          	jal	80004cc6 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800044e4:	0485                	addi	s1,s1,1
    800044e6:	00ca2703          	lw	a4,12(s4)
    800044ea:	0004879b          	sext.w	a5,s1
    800044ee:	02e7fd63          	bgeu	a5,a4,80004528 <ireclaim+0xb2>
    800044f2:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800044f6:	0044d593          	srli	a1,s1,0x4
    800044fa:	018a2783          	lw	a5,24(s4)
    800044fe:	9dbd                	addw	a1,a1,a5
    80004500:	8556                	mv	a0,s5
    80004502:	eb0ff0ef          	jal	80003bb2 <bread>
    80004506:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80004508:	05850793          	addi	a5,a0,88
    8000450c:	00f9f713          	andi	a4,s3,15
    80004510:	071a                	slli	a4,a4,0x6
    80004512:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80004514:	00079703          	lh	a4,0(a5)
    80004518:	c701                	beqz	a4,80004520 <ireclaim+0xaa>
    8000451a:	00679783          	lh	a5,6(a5)
    8000451e:	dbc1                	beqz	a5,800044ae <ireclaim+0x38>
    brelse(bp);
    80004520:	854a                	mv	a0,s2
    80004522:	f98ff0ef          	jal	80003cba <brelse>
    if (ip) {
    80004526:	bf7d                	j	800044e4 <ireclaim+0x6e>
}
    80004528:	70e2                	ld	ra,56(sp)
    8000452a:	7442                	ld	s0,48(sp)
    8000452c:	74a2                	ld	s1,40(sp)
    8000452e:	7902                	ld	s2,32(sp)
    80004530:	69e2                	ld	s3,24(sp)
    80004532:	6a42                	ld	s4,16(sp)
    80004534:	6aa2                	ld	s5,8(sp)
    80004536:	6b02                	ld	s6,0(sp)
    80004538:	6121                	addi	sp,sp,64
    8000453a:	8082                	ret
    8000453c:	8082                	ret

000000008000453e <fsinit>:
fsinit(int dev) {
    8000453e:	1101                	addi	sp,sp,-32
    80004540:	ec06                	sd	ra,24(sp)
    80004542:	e822                	sd	s0,16(sp)
    80004544:	e426                	sd	s1,8(sp)
    80004546:	e04a                	sd	s2,0(sp)
    80004548:	1000                	addi	s0,sp,32
    8000454a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000454c:	4585                	li	a1,1
    8000454e:	e64ff0ef          	jal	80003bb2 <bread>
    80004552:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80004554:	02000613          	li	a2,32
    80004558:	05850593          	addi	a1,a0,88
    8000455c:	0001f517          	auipc	a0,0x1f
    80004560:	8f450513          	addi	a0,a0,-1804 # 80022e50 <sb>
    80004564:	ccffc0ef          	jal	80001232 <memmove>
  brelse(bp);
    80004568:	8526                	mv	a0,s1
    8000456a:	f50ff0ef          	jal	80003cba <brelse>
  if(sb.magic != FSMAGIC)
    8000456e:	0001f717          	auipc	a4,0x1f
    80004572:	8e272703          	lw	a4,-1822(a4) # 80022e50 <sb>
    80004576:	102037b7          	lui	a5,0x10203
    8000457a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000457e:	02f71263          	bne	a4,a5,800045a2 <fsinit+0x64>
  initlog(dev, &sb);
    80004582:	0001f597          	auipc	a1,0x1f
    80004586:	8ce58593          	addi	a1,a1,-1842 # 80022e50 <sb>
    8000458a:	854a                	mv	a0,s2
    8000458c:	648000ef          	jal	80004bd4 <initlog>
  ireclaim(dev);
    80004590:	854a                	mv	a0,s2
    80004592:	ee5ff0ef          	jal	80004476 <ireclaim>
}
    80004596:	60e2                	ld	ra,24(sp)
    80004598:	6442                	ld	s0,16(sp)
    8000459a:	64a2                	ld	s1,8(sp)
    8000459c:	6902                	ld	s2,0(sp)
    8000459e:	6105                	addi	sp,sp,32
    800045a0:	8082                	ret
    panic("invalid file system");
    800045a2:	00005517          	auipc	a0,0x5
    800045a6:	f2e50513          	addi	a0,a0,-210 # 800094d0 <etext+0x4d0>
    800045aa:	a7afc0ef          	jal	80000824 <panic>

00000000800045ae <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800045ae:	1141                	addi	sp,sp,-16
    800045b0:	e406                	sd	ra,8(sp)
    800045b2:	e022                	sd	s0,0(sp)
    800045b4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800045b6:	411c                	lw	a5,0(a0)
    800045b8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800045ba:	415c                	lw	a5,4(a0)
    800045bc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800045be:	04451783          	lh	a5,68(a0)
    800045c2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800045c6:	04a51783          	lh	a5,74(a0)
    800045ca:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800045ce:	04c56783          	lwu	a5,76(a0)
    800045d2:	e99c                	sd	a5,16(a1)
}
    800045d4:	60a2                	ld	ra,8(sp)
    800045d6:	6402                	ld	s0,0(sp)
    800045d8:	0141                	addi	sp,sp,16
    800045da:	8082                	ret

00000000800045dc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800045dc:	457c                	lw	a5,76(a0)
    800045de:	0ed7e663          	bltu	a5,a3,800046ca <readi+0xee>
{
    800045e2:	7159                	addi	sp,sp,-112
    800045e4:	f486                	sd	ra,104(sp)
    800045e6:	f0a2                	sd	s0,96(sp)
    800045e8:	eca6                	sd	s1,88(sp)
    800045ea:	e0d2                	sd	s4,64(sp)
    800045ec:	fc56                	sd	s5,56(sp)
    800045ee:	f85a                	sd	s6,48(sp)
    800045f0:	f45e                	sd	s7,40(sp)
    800045f2:	1880                	addi	s0,sp,112
    800045f4:	8b2a                	mv	s6,a0
    800045f6:	8bae                	mv	s7,a1
    800045f8:	8a32                	mv	s4,a2
    800045fa:	84b6                	mv	s1,a3
    800045fc:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800045fe:	9f35                	addw	a4,a4,a3
    return 0;
    80004600:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004602:	0ad76b63          	bltu	a4,a3,800046b8 <readi+0xdc>
    80004606:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80004608:	00e7f463          	bgeu	a5,a4,80004610 <readi+0x34>
    n = ip->size - off;
    8000460c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004610:	080a8b63          	beqz	s5,800046a6 <readi+0xca>
    80004614:	e8ca                	sd	s2,80(sp)
    80004616:	f062                	sd	s8,32(sp)
    80004618:	ec66                	sd	s9,24(sp)
    8000461a:	e86a                	sd	s10,16(sp)
    8000461c:	e46e                	sd	s11,8(sp)
    8000461e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004620:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004624:	5c7d                	li	s8,-1
    80004626:	a80d                	j	80004658 <readi+0x7c>
    80004628:	020d1d93          	slli	s11,s10,0x20
    8000462c:	020ddd93          	srli	s11,s11,0x20
    80004630:	05890613          	addi	a2,s2,88
    80004634:	86ee                	mv	a3,s11
    80004636:	963e                	add	a2,a2,a5
    80004638:	85d2                	mv	a1,s4
    8000463a:	855e                	mv	a0,s7
    8000463c:	da6fe0ef          	jal	80002be2 <either_copyout>
    80004640:	05850363          	beq	a0,s8,80004686 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004644:	854a                	mv	a0,s2
    80004646:	e74ff0ef          	jal	80003cba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000464a:	013d09bb          	addw	s3,s10,s3
    8000464e:	009d04bb          	addw	s1,s10,s1
    80004652:	9a6e                	add	s4,s4,s11
    80004654:	0559f363          	bgeu	s3,s5,8000469a <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80004658:	00a4d59b          	srliw	a1,s1,0xa
    8000465c:	855a                	mv	a0,s6
    8000465e:	8bbff0ef          	jal	80003f18 <bmap>
    80004662:	85aa                	mv	a1,a0
    if(addr == 0)
    80004664:	c139                	beqz	a0,800046aa <readi+0xce>
    bp = bread(ip->dev, addr);
    80004666:	000b2503          	lw	a0,0(s6)
    8000466a:	d48ff0ef          	jal	80003bb2 <bread>
    8000466e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004670:	3ff4f793          	andi	a5,s1,1023
    80004674:	40fc873b          	subw	a4,s9,a5
    80004678:	413a86bb          	subw	a3,s5,s3
    8000467c:	8d3a                	mv	s10,a4
    8000467e:	fae6f5e3          	bgeu	a3,a4,80004628 <readi+0x4c>
    80004682:	8d36                	mv	s10,a3
    80004684:	b755                	j	80004628 <readi+0x4c>
      brelse(bp);
    80004686:	854a                	mv	a0,s2
    80004688:	e32ff0ef          	jal	80003cba <brelse>
      tot = -1;
    8000468c:	59fd                	li	s3,-1
      break;
    8000468e:	6946                	ld	s2,80(sp)
    80004690:	7c02                	ld	s8,32(sp)
    80004692:	6ce2                	ld	s9,24(sp)
    80004694:	6d42                	ld	s10,16(sp)
    80004696:	6da2                	ld	s11,8(sp)
    80004698:	a831                	j	800046b4 <readi+0xd8>
    8000469a:	6946                	ld	s2,80(sp)
    8000469c:	7c02                	ld	s8,32(sp)
    8000469e:	6ce2                	ld	s9,24(sp)
    800046a0:	6d42                	ld	s10,16(sp)
    800046a2:	6da2                	ld	s11,8(sp)
    800046a4:	a801                	j	800046b4 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800046a6:	89d6                	mv	s3,s5
    800046a8:	a031                	j	800046b4 <readi+0xd8>
    800046aa:	6946                	ld	s2,80(sp)
    800046ac:	7c02                	ld	s8,32(sp)
    800046ae:	6ce2                	ld	s9,24(sp)
    800046b0:	6d42                	ld	s10,16(sp)
    800046b2:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800046b4:	854e                	mv	a0,s3
    800046b6:	69a6                	ld	s3,72(sp)
}
    800046b8:	70a6                	ld	ra,104(sp)
    800046ba:	7406                	ld	s0,96(sp)
    800046bc:	64e6                	ld	s1,88(sp)
    800046be:	6a06                	ld	s4,64(sp)
    800046c0:	7ae2                	ld	s5,56(sp)
    800046c2:	7b42                	ld	s6,48(sp)
    800046c4:	7ba2                	ld	s7,40(sp)
    800046c6:	6165                	addi	sp,sp,112
    800046c8:	8082                	ret
    return 0;
    800046ca:	4501                	li	a0,0
}
    800046cc:	8082                	ret

00000000800046ce <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800046ce:	457c                	lw	a5,76(a0)
    800046d0:	0ed7eb63          	bltu	a5,a3,800047c6 <writei+0xf8>
{
    800046d4:	7159                	addi	sp,sp,-112
    800046d6:	f486                	sd	ra,104(sp)
    800046d8:	f0a2                	sd	s0,96(sp)
    800046da:	e8ca                	sd	s2,80(sp)
    800046dc:	e0d2                	sd	s4,64(sp)
    800046de:	fc56                	sd	s5,56(sp)
    800046e0:	f85a                	sd	s6,48(sp)
    800046e2:	f45e                	sd	s7,40(sp)
    800046e4:	1880                	addi	s0,sp,112
    800046e6:	8aaa                	mv	s5,a0
    800046e8:	8bae                	mv	s7,a1
    800046ea:	8a32                	mv	s4,a2
    800046ec:	8936                	mv	s2,a3
    800046ee:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800046f0:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800046f4:	00043737          	lui	a4,0x43
    800046f8:	0cf76963          	bltu	a4,a5,800047ca <writei+0xfc>
    800046fc:	0cd7e763          	bltu	a5,a3,800047ca <writei+0xfc>
    80004700:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004702:	0a0b0a63          	beqz	s6,800047b6 <writei+0xe8>
    80004706:	eca6                	sd	s1,88(sp)
    80004708:	f062                	sd	s8,32(sp)
    8000470a:	ec66                	sd	s9,24(sp)
    8000470c:	e86a                	sd	s10,16(sp)
    8000470e:	e46e                	sd	s11,8(sp)
    80004710:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004712:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004716:	5c7d                	li	s8,-1
    80004718:	a825                	j	80004750 <writei+0x82>
    8000471a:	020d1d93          	slli	s11,s10,0x20
    8000471e:	020ddd93          	srli	s11,s11,0x20
    80004722:	05848513          	addi	a0,s1,88
    80004726:	86ee                	mv	a3,s11
    80004728:	8652                	mv	a2,s4
    8000472a:	85de                	mv	a1,s7
    8000472c:	953e                	add	a0,a0,a5
    8000472e:	cfefe0ef          	jal	80002c2c <either_copyin>
    80004732:	05850663          	beq	a0,s8,8000477e <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004736:	8526                	mv	a0,s1
    80004738:	6b8000ef          	jal	80004df0 <log_write>
    brelse(bp);
    8000473c:	8526                	mv	a0,s1
    8000473e:	d7cff0ef          	jal	80003cba <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004742:	013d09bb          	addw	s3,s10,s3
    80004746:	012d093b          	addw	s2,s10,s2
    8000474a:	9a6e                	add	s4,s4,s11
    8000474c:	0369fc63          	bgeu	s3,s6,80004784 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80004750:	00a9559b          	srliw	a1,s2,0xa
    80004754:	8556                	mv	a0,s5
    80004756:	fc2ff0ef          	jal	80003f18 <bmap>
    8000475a:	85aa                	mv	a1,a0
    if(addr == 0)
    8000475c:	c505                	beqz	a0,80004784 <writei+0xb6>
    bp = bread(ip->dev, addr);
    8000475e:	000aa503          	lw	a0,0(s5)
    80004762:	c50ff0ef          	jal	80003bb2 <bread>
    80004766:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004768:	3ff97793          	andi	a5,s2,1023
    8000476c:	40fc873b          	subw	a4,s9,a5
    80004770:	413b06bb          	subw	a3,s6,s3
    80004774:	8d3a                	mv	s10,a4
    80004776:	fae6f2e3          	bgeu	a3,a4,8000471a <writei+0x4c>
    8000477a:	8d36                	mv	s10,a3
    8000477c:	bf79                	j	8000471a <writei+0x4c>
      brelse(bp);
    8000477e:	8526                	mv	a0,s1
    80004780:	d3aff0ef          	jal	80003cba <brelse>
  }

  if(off > ip->size)
    80004784:	04caa783          	lw	a5,76(s5)
    80004788:	0327f963          	bgeu	a5,s2,800047ba <writei+0xec>
    ip->size = off;
    8000478c:	052aa623          	sw	s2,76(s5)
    80004790:	64e6                	ld	s1,88(sp)
    80004792:	7c02                	ld	s8,32(sp)
    80004794:	6ce2                	ld	s9,24(sp)
    80004796:	6d42                	ld	s10,16(sp)
    80004798:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000479a:	8556                	mv	a0,s5
    8000479c:	9fbff0ef          	jal	80004196 <iupdate>

  return tot;
    800047a0:	854e                	mv	a0,s3
    800047a2:	69a6                	ld	s3,72(sp)
}
    800047a4:	70a6                	ld	ra,104(sp)
    800047a6:	7406                	ld	s0,96(sp)
    800047a8:	6946                	ld	s2,80(sp)
    800047aa:	6a06                	ld	s4,64(sp)
    800047ac:	7ae2                	ld	s5,56(sp)
    800047ae:	7b42                	ld	s6,48(sp)
    800047b0:	7ba2                	ld	s7,40(sp)
    800047b2:	6165                	addi	sp,sp,112
    800047b4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800047b6:	89da                	mv	s3,s6
    800047b8:	b7cd                	j	8000479a <writei+0xcc>
    800047ba:	64e6                	ld	s1,88(sp)
    800047bc:	7c02                	ld	s8,32(sp)
    800047be:	6ce2                	ld	s9,24(sp)
    800047c0:	6d42                	ld	s10,16(sp)
    800047c2:	6da2                	ld	s11,8(sp)
    800047c4:	bfd9                	j	8000479a <writei+0xcc>
    return -1;
    800047c6:	557d                	li	a0,-1
}
    800047c8:	8082                	ret
    return -1;
    800047ca:	557d                	li	a0,-1
    800047cc:	bfe1                	j	800047a4 <writei+0xd6>

00000000800047ce <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800047ce:	1141                	addi	sp,sp,-16
    800047d0:	e406                	sd	ra,8(sp)
    800047d2:	e022                	sd	s0,0(sp)
    800047d4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800047d6:	4639                	li	a2,14
    800047d8:	acffc0ef          	jal	800012a6 <strncmp>
}
    800047dc:	60a2                	ld	ra,8(sp)
    800047de:	6402                	ld	s0,0(sp)
    800047e0:	0141                	addi	sp,sp,16
    800047e2:	8082                	ret

00000000800047e4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800047e4:	711d                	addi	sp,sp,-96
    800047e6:	ec86                	sd	ra,88(sp)
    800047e8:	e8a2                	sd	s0,80(sp)
    800047ea:	e4a6                	sd	s1,72(sp)
    800047ec:	e0ca                	sd	s2,64(sp)
    800047ee:	fc4e                	sd	s3,56(sp)
    800047f0:	f852                	sd	s4,48(sp)
    800047f2:	f456                	sd	s5,40(sp)
    800047f4:	f05a                	sd	s6,32(sp)
    800047f6:	ec5e                	sd	s7,24(sp)
    800047f8:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800047fa:	04451703          	lh	a4,68(a0)
    800047fe:	4785                	li	a5,1
    80004800:	00f71f63          	bne	a4,a5,8000481e <dirlookup+0x3a>
    80004804:	892a                	mv	s2,a0
    80004806:	8aae                	mv	s5,a1
    80004808:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000480a:	457c                	lw	a5,76(a0)
    8000480c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000480e:	fa040a13          	addi	s4,s0,-96
    80004812:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80004814:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004818:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000481a:	e39d                	bnez	a5,80004840 <dirlookup+0x5c>
    8000481c:	a8b9                	j	8000487a <dirlookup+0x96>
    panic("dirlookup not DIR");
    8000481e:	00005517          	auipc	a0,0x5
    80004822:	cca50513          	addi	a0,a0,-822 # 800094e8 <etext+0x4e8>
    80004826:	ffffb0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    8000482a:	00005517          	auipc	a0,0x5
    8000482e:	cd650513          	addi	a0,a0,-810 # 80009500 <etext+0x500>
    80004832:	ff3fb0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004836:	24c1                	addiw	s1,s1,16
    80004838:	04c92783          	lw	a5,76(s2)
    8000483c:	02f4fe63          	bgeu	s1,a5,80004878 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004840:	874e                	mv	a4,s3
    80004842:	86a6                	mv	a3,s1
    80004844:	8652                	mv	a2,s4
    80004846:	4581                	li	a1,0
    80004848:	854a                	mv	a0,s2
    8000484a:	d93ff0ef          	jal	800045dc <readi>
    8000484e:	fd351ee3          	bne	a0,s3,8000482a <dirlookup+0x46>
    if(de.inum == 0)
    80004852:	fa045783          	lhu	a5,-96(s0)
    80004856:	d3e5                	beqz	a5,80004836 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80004858:	85da                	mv	a1,s6
    8000485a:	8556                	mv	a0,s5
    8000485c:	f73ff0ef          	jal	800047ce <namecmp>
    80004860:	f979                	bnez	a0,80004836 <dirlookup+0x52>
      if(poff)
    80004862:	000b8463          	beqz	s7,8000486a <dirlookup+0x86>
        *poff = off;
    80004866:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    8000486a:	fa045583          	lhu	a1,-96(s0)
    8000486e:	00092503          	lw	a0,0(s2)
    80004872:	f66ff0ef          	jal	80003fd8 <iget>
    80004876:	a011                	j	8000487a <dirlookup+0x96>
  return 0;
    80004878:	4501                	li	a0,0
}
    8000487a:	60e6                	ld	ra,88(sp)
    8000487c:	6446                	ld	s0,80(sp)
    8000487e:	64a6                	ld	s1,72(sp)
    80004880:	6906                	ld	s2,64(sp)
    80004882:	79e2                	ld	s3,56(sp)
    80004884:	7a42                	ld	s4,48(sp)
    80004886:	7aa2                	ld	s5,40(sp)
    80004888:	7b02                	ld	s6,32(sp)
    8000488a:	6be2                	ld	s7,24(sp)
    8000488c:	6125                	addi	sp,sp,96
    8000488e:	8082                	ret

0000000080004890 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004890:	711d                	addi	sp,sp,-96
    80004892:	ec86                	sd	ra,88(sp)
    80004894:	e8a2                	sd	s0,80(sp)
    80004896:	e4a6                	sd	s1,72(sp)
    80004898:	e0ca                	sd	s2,64(sp)
    8000489a:	fc4e                	sd	s3,56(sp)
    8000489c:	f852                	sd	s4,48(sp)
    8000489e:	f456                	sd	s5,40(sp)
    800048a0:	f05a                	sd	s6,32(sp)
    800048a2:	ec5e                	sd	s7,24(sp)
    800048a4:	e862                	sd	s8,16(sp)
    800048a6:	e466                	sd	s9,8(sp)
    800048a8:	e06a                	sd	s10,0(sp)
    800048aa:	1080                	addi	s0,sp,96
    800048ac:	84aa                	mv	s1,a0
    800048ae:	8b2e                	mv	s6,a1
    800048b0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800048b2:	00054703          	lbu	a4,0(a0)
    800048b6:	02f00793          	li	a5,47
    800048ba:	00f70f63          	beq	a4,a5,800048d8 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800048be:	facfd0ef          	jal	8000206a <myproc>
    800048c2:	15053503          	ld	a0,336(a0)
    800048c6:	94fff0ef          	jal	80004214 <idup>
    800048ca:	8a2a                	mv	s4,a0
  while(*path == '/')
    800048cc:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    800048d0:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800048d2:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800048d4:	4b85                	li	s7,1
    800048d6:	a879                	j	80004974 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    800048d8:	4585                	li	a1,1
    800048da:	852e                	mv	a0,a1
    800048dc:	efcff0ef          	jal	80003fd8 <iget>
    800048e0:	8a2a                	mv	s4,a0
    800048e2:	b7ed                	j	800048cc <namex+0x3c>
      iunlockput(ip);
    800048e4:	8552                	mv	a0,s4
    800048e6:	b71ff0ef          	jal	80004456 <iunlockput>
      return 0;
    800048ea:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800048ec:	8552                	mv	a0,s4
    800048ee:	60e6                	ld	ra,88(sp)
    800048f0:	6446                	ld	s0,80(sp)
    800048f2:	64a6                	ld	s1,72(sp)
    800048f4:	6906                	ld	s2,64(sp)
    800048f6:	79e2                	ld	s3,56(sp)
    800048f8:	7a42                	ld	s4,48(sp)
    800048fa:	7aa2                	ld	s5,40(sp)
    800048fc:	7b02                	ld	s6,32(sp)
    800048fe:	6be2                	ld	s7,24(sp)
    80004900:	6c42                	ld	s8,16(sp)
    80004902:	6ca2                	ld	s9,8(sp)
    80004904:	6d02                	ld	s10,0(sp)
    80004906:	6125                	addi	sp,sp,96
    80004908:	8082                	ret
      iunlock(ip);
    8000490a:	8552                	mv	a0,s4
    8000490c:	9edff0ef          	jal	800042f8 <iunlock>
      return ip;
    80004910:	bff1                	j	800048ec <namex+0x5c>
      iunlockput(ip);
    80004912:	8552                	mv	a0,s4
    80004914:	b43ff0ef          	jal	80004456 <iunlockput>
      return 0;
    80004918:	8a4a                	mv	s4,s2
    8000491a:	bfc9                	j	800048ec <namex+0x5c>
  len = path - s;
    8000491c:	40990633          	sub	a2,s2,s1
    80004920:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004924:	09ac5463          	bge	s8,s10,800049ac <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80004928:	8666                	mv	a2,s9
    8000492a:	85a6                	mv	a1,s1
    8000492c:	8556                	mv	a0,s5
    8000492e:	905fc0ef          	jal	80001232 <memmove>
    80004932:	84ca                	mv	s1,s2
  while(*path == '/')
    80004934:	0004c783          	lbu	a5,0(s1)
    80004938:	01379763          	bne	a5,s3,80004946 <namex+0xb6>
    path++;
    8000493c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000493e:	0004c783          	lbu	a5,0(s1)
    80004942:	ff378de3          	beq	a5,s3,8000493c <namex+0xac>
    ilock(ip);
    80004946:	8552                	mv	a0,s4
    80004948:	903ff0ef          	jal	8000424a <ilock>
    if(ip->type != T_DIR){
    8000494c:	044a1783          	lh	a5,68(s4)
    80004950:	f9779ae3          	bne	a5,s7,800048e4 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80004954:	000b0563          	beqz	s6,8000495e <namex+0xce>
    80004958:	0004c783          	lbu	a5,0(s1)
    8000495c:	d7dd                	beqz	a5,8000490a <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000495e:	4601                	li	a2,0
    80004960:	85d6                	mv	a1,s5
    80004962:	8552                	mv	a0,s4
    80004964:	e81ff0ef          	jal	800047e4 <dirlookup>
    80004968:	892a                	mv	s2,a0
    8000496a:	d545                	beqz	a0,80004912 <namex+0x82>
    iunlockput(ip);
    8000496c:	8552                	mv	a0,s4
    8000496e:	ae9ff0ef          	jal	80004456 <iunlockput>
    ip = next;
    80004972:	8a4a                	mv	s4,s2
  while(*path == '/')
    80004974:	0004c783          	lbu	a5,0(s1)
    80004978:	01379763          	bne	a5,s3,80004986 <namex+0xf6>
    path++;
    8000497c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000497e:	0004c783          	lbu	a5,0(s1)
    80004982:	ff378de3          	beq	a5,s3,8000497c <namex+0xec>
  if(*path == 0)
    80004986:	cf8d                	beqz	a5,800049c0 <namex+0x130>
  while(*path != '/' && *path != 0)
    80004988:	0004c783          	lbu	a5,0(s1)
    8000498c:	fd178713          	addi	a4,a5,-47
    80004990:	cb19                	beqz	a4,800049a6 <namex+0x116>
    80004992:	cb91                	beqz	a5,800049a6 <namex+0x116>
    80004994:	8926                	mv	s2,s1
    path++;
    80004996:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80004998:	00094783          	lbu	a5,0(s2)
    8000499c:	fd178713          	addi	a4,a5,-47
    800049a0:	df35                	beqz	a4,8000491c <namex+0x8c>
    800049a2:	fbf5                	bnez	a5,80004996 <namex+0x106>
    800049a4:	bfa5                	j	8000491c <namex+0x8c>
    800049a6:	8926                	mv	s2,s1
  len = path - s;
    800049a8:	4d01                	li	s10,0
    800049aa:	4601                	li	a2,0
    memmove(name, s, len);
    800049ac:	2601                	sext.w	a2,a2
    800049ae:	85a6                	mv	a1,s1
    800049b0:	8556                	mv	a0,s5
    800049b2:	881fc0ef          	jal	80001232 <memmove>
    name[len] = 0;
    800049b6:	9d56                	add	s10,s10,s5
    800049b8:	000d0023          	sb	zero,0(s10)
    800049bc:	84ca                	mv	s1,s2
    800049be:	bf9d                	j	80004934 <namex+0xa4>
  if(nameiparent){
    800049c0:	f20b06e3          	beqz	s6,800048ec <namex+0x5c>
    iput(ip);
    800049c4:	8552                	mv	a0,s4
    800049c6:	a07ff0ef          	jal	800043cc <iput>
    return 0;
    800049ca:	4a01                	li	s4,0
    800049cc:	b705                	j	800048ec <namex+0x5c>

00000000800049ce <dirlink>:
{
    800049ce:	715d                	addi	sp,sp,-80
    800049d0:	e486                	sd	ra,72(sp)
    800049d2:	e0a2                	sd	s0,64(sp)
    800049d4:	f84a                	sd	s2,48(sp)
    800049d6:	ec56                	sd	s5,24(sp)
    800049d8:	e85a                	sd	s6,16(sp)
    800049da:	0880                	addi	s0,sp,80
    800049dc:	892a                	mv	s2,a0
    800049de:	8aae                	mv	s5,a1
    800049e0:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800049e2:	4601                	li	a2,0
    800049e4:	e01ff0ef          	jal	800047e4 <dirlookup>
    800049e8:	ed1d                	bnez	a0,80004a26 <dirlink+0x58>
    800049ea:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800049ec:	04c92483          	lw	s1,76(s2)
    800049f0:	c4b9                	beqz	s1,80004a3e <dirlink+0x70>
    800049f2:	f44e                	sd	s3,40(sp)
    800049f4:	f052                	sd	s4,32(sp)
    800049f6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049f8:	fb040a13          	addi	s4,s0,-80
    800049fc:	49c1                	li	s3,16
    800049fe:	874e                	mv	a4,s3
    80004a00:	86a6                	mv	a3,s1
    80004a02:	8652                	mv	a2,s4
    80004a04:	4581                	li	a1,0
    80004a06:	854a                	mv	a0,s2
    80004a08:	bd5ff0ef          	jal	800045dc <readi>
    80004a0c:	03351163          	bne	a0,s3,80004a2e <dirlink+0x60>
    if(de.inum == 0)
    80004a10:	fb045783          	lhu	a5,-80(s0)
    80004a14:	c39d                	beqz	a5,80004a3a <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004a16:	24c1                	addiw	s1,s1,16
    80004a18:	04c92783          	lw	a5,76(s2)
    80004a1c:	fef4e1e3          	bltu	s1,a5,800049fe <dirlink+0x30>
    80004a20:	79a2                	ld	s3,40(sp)
    80004a22:	7a02                	ld	s4,32(sp)
    80004a24:	a829                	j	80004a3e <dirlink+0x70>
    iput(ip);
    80004a26:	9a7ff0ef          	jal	800043cc <iput>
    return -1;
    80004a2a:	557d                	li	a0,-1
    80004a2c:	a83d                	j	80004a6a <dirlink+0x9c>
      panic("dirlink read");
    80004a2e:	00005517          	auipc	a0,0x5
    80004a32:	ae250513          	addi	a0,a0,-1310 # 80009510 <etext+0x510>
    80004a36:	deffb0ef          	jal	80000824 <panic>
    80004a3a:	79a2                	ld	s3,40(sp)
    80004a3c:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004a3e:	4639                	li	a2,14
    80004a40:	85d6                	mv	a1,s5
    80004a42:	fb240513          	addi	a0,s0,-78
    80004a46:	89bfc0ef          	jal	800012e0 <strncpy>
  de.inum = inum;
    80004a4a:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a4e:	4741                	li	a4,16
    80004a50:	86a6                	mv	a3,s1
    80004a52:	fb040613          	addi	a2,s0,-80
    80004a56:	4581                	li	a1,0
    80004a58:	854a                	mv	a0,s2
    80004a5a:	c75ff0ef          	jal	800046ce <writei>
    80004a5e:	1541                	addi	a0,a0,-16
    80004a60:	00a03533          	snez	a0,a0
    80004a64:	40a0053b          	negw	a0,a0
    80004a68:	74e2                	ld	s1,56(sp)
}
    80004a6a:	60a6                	ld	ra,72(sp)
    80004a6c:	6406                	ld	s0,64(sp)
    80004a6e:	7942                	ld	s2,48(sp)
    80004a70:	6ae2                	ld	s5,24(sp)
    80004a72:	6b42                	ld	s6,16(sp)
    80004a74:	6161                	addi	sp,sp,80
    80004a76:	8082                	ret

0000000080004a78 <namei>:

struct inode*
namei(char *path)
{
    80004a78:	1101                	addi	sp,sp,-32
    80004a7a:	ec06                	sd	ra,24(sp)
    80004a7c:	e822                	sd	s0,16(sp)
    80004a7e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004a80:	fe040613          	addi	a2,s0,-32
    80004a84:	4581                	li	a1,0
    80004a86:	e0bff0ef          	jal	80004890 <namex>
}
    80004a8a:	60e2                	ld	ra,24(sp)
    80004a8c:	6442                	ld	s0,16(sp)
    80004a8e:	6105                	addi	sp,sp,32
    80004a90:	8082                	ret

0000000080004a92 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004a92:	1141                	addi	sp,sp,-16
    80004a94:	e406                	sd	ra,8(sp)
    80004a96:	e022                	sd	s0,0(sp)
    80004a98:	0800                	addi	s0,sp,16
    80004a9a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004a9c:	4585                	li	a1,1
    80004a9e:	df3ff0ef          	jal	80004890 <namex>
}
    80004aa2:	60a2                	ld	ra,8(sp)
    80004aa4:	6402                	ld	s0,0(sp)
    80004aa6:	0141                	addi	sp,sp,16
    80004aa8:	8082                	ret

0000000080004aaa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004aaa:	1101                	addi	sp,sp,-32
    80004aac:	ec06                	sd	ra,24(sp)
    80004aae:	e822                	sd	s0,16(sp)
    80004ab0:	e426                	sd	s1,8(sp)
    80004ab2:	e04a                	sd	s2,0(sp)
    80004ab4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004ab6:	00020917          	auipc	s2,0x20
    80004aba:	e6290913          	addi	s2,s2,-414 # 80024918 <log>
    80004abe:	01892583          	lw	a1,24(s2)
    80004ac2:	02492503          	lw	a0,36(s2)
    80004ac6:	8ecff0ef          	jal	80003bb2 <bread>
    80004aca:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004acc:	02892603          	lw	a2,40(s2)
    80004ad0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004ad2:	00c05f63          	blez	a2,80004af0 <write_head+0x46>
    80004ad6:	00020717          	auipc	a4,0x20
    80004ada:	e6e70713          	addi	a4,a4,-402 # 80024944 <log+0x2c>
    80004ade:	87aa                	mv	a5,a0
    80004ae0:	060a                	slli	a2,a2,0x2
    80004ae2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004ae4:	4314                	lw	a3,0(a4)
    80004ae6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004ae8:	0711                	addi	a4,a4,4
    80004aea:	0791                	addi	a5,a5,4
    80004aec:	fec79ce3          	bne	a5,a2,80004ae4 <write_head+0x3a>
  }
  bwrite(buf);
    80004af0:	8526                	mv	a0,s1
    80004af2:	996ff0ef          	jal	80003c88 <bwrite>
  brelse(buf);
    80004af6:	8526                	mv	a0,s1
    80004af8:	9c2ff0ef          	jal	80003cba <brelse>
}
    80004afc:	60e2                	ld	ra,24(sp)
    80004afe:	6442                	ld	s0,16(sp)
    80004b00:	64a2                	ld	s1,8(sp)
    80004b02:	6902                	ld	s2,0(sp)
    80004b04:	6105                	addi	sp,sp,32
    80004b06:	8082                	ret

0000000080004b08 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b08:	00020797          	auipc	a5,0x20
    80004b0c:	e387a783          	lw	a5,-456(a5) # 80024940 <log+0x28>
    80004b10:	0cf05163          	blez	a5,80004bd2 <install_trans+0xca>
{
    80004b14:	715d                	addi	sp,sp,-80
    80004b16:	e486                	sd	ra,72(sp)
    80004b18:	e0a2                	sd	s0,64(sp)
    80004b1a:	fc26                	sd	s1,56(sp)
    80004b1c:	f84a                	sd	s2,48(sp)
    80004b1e:	f44e                	sd	s3,40(sp)
    80004b20:	f052                	sd	s4,32(sp)
    80004b22:	ec56                	sd	s5,24(sp)
    80004b24:	e85a                	sd	s6,16(sp)
    80004b26:	e45e                	sd	s7,8(sp)
    80004b28:	e062                	sd	s8,0(sp)
    80004b2a:	0880                	addi	s0,sp,80
    80004b2c:	8b2a                	mv	s6,a0
    80004b2e:	00020a97          	auipc	s5,0x20
    80004b32:	e16a8a93          	addi	s5,s5,-490 # 80024944 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b36:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80004b38:	00005c17          	auipc	s8,0x5
    80004b3c:	9e8c0c13          	addi	s8,s8,-1560 # 80009520 <etext+0x520>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004b40:	00020a17          	auipc	s4,0x20
    80004b44:	dd8a0a13          	addi	s4,s4,-552 # 80024918 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004b48:	40000b93          	li	s7,1024
    80004b4c:	a025                	j	80004b74 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80004b4e:	000aa603          	lw	a2,0(s5)
    80004b52:	85ce                	mv	a1,s3
    80004b54:	8562                	mv	a0,s8
    80004b56:	9a5fb0ef          	jal	800004fa <printf>
    80004b5a:	a839                	j	80004b78 <install_trans+0x70>
    brelse(lbuf);
    80004b5c:	854a                	mv	a0,s2
    80004b5e:	95cff0ef          	jal	80003cba <brelse>
    brelse(dbuf);
    80004b62:	8526                	mv	a0,s1
    80004b64:	956ff0ef          	jal	80003cba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004b68:	2985                	addiw	s3,s3,1
    80004b6a:	0a91                	addi	s5,s5,4
    80004b6c:	028a2783          	lw	a5,40(s4)
    80004b70:	04f9d563          	bge	s3,a5,80004bba <install_trans+0xb2>
    if(recovering) {
    80004b74:	fc0b1de3          	bnez	s6,80004b4e <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004b78:	018a2583          	lw	a1,24(s4)
    80004b7c:	013585bb          	addw	a1,a1,s3
    80004b80:	2585                	addiw	a1,a1,1
    80004b82:	024a2503          	lw	a0,36(s4)
    80004b86:	82cff0ef          	jal	80003bb2 <bread>
    80004b8a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004b8c:	000aa583          	lw	a1,0(s5)
    80004b90:	024a2503          	lw	a0,36(s4)
    80004b94:	81eff0ef          	jal	80003bb2 <bread>
    80004b98:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004b9a:	865e                	mv	a2,s7
    80004b9c:	05890593          	addi	a1,s2,88
    80004ba0:	05850513          	addi	a0,a0,88
    80004ba4:	e8efc0ef          	jal	80001232 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004ba8:	8526                	mv	a0,s1
    80004baa:	8deff0ef          	jal	80003c88 <bwrite>
    if(recovering == 0)
    80004bae:	fa0b17e3          	bnez	s6,80004b5c <install_trans+0x54>
      bunpin(dbuf);
    80004bb2:	8526                	mv	a0,s1
    80004bb4:	9beff0ef          	jal	80003d72 <bunpin>
    80004bb8:	b755                	j	80004b5c <install_trans+0x54>
}
    80004bba:	60a6                	ld	ra,72(sp)
    80004bbc:	6406                	ld	s0,64(sp)
    80004bbe:	74e2                	ld	s1,56(sp)
    80004bc0:	7942                	ld	s2,48(sp)
    80004bc2:	79a2                	ld	s3,40(sp)
    80004bc4:	7a02                	ld	s4,32(sp)
    80004bc6:	6ae2                	ld	s5,24(sp)
    80004bc8:	6b42                	ld	s6,16(sp)
    80004bca:	6ba2                	ld	s7,8(sp)
    80004bcc:	6c02                	ld	s8,0(sp)
    80004bce:	6161                	addi	sp,sp,80
    80004bd0:	8082                	ret
    80004bd2:	8082                	ret

0000000080004bd4 <initlog>:
{
    80004bd4:	7179                	addi	sp,sp,-48
    80004bd6:	f406                	sd	ra,40(sp)
    80004bd8:	f022                	sd	s0,32(sp)
    80004bda:	ec26                	sd	s1,24(sp)
    80004bdc:	e84a                	sd	s2,16(sp)
    80004bde:	e44e                	sd	s3,8(sp)
    80004be0:	1800                	addi	s0,sp,48
    80004be2:	84aa                	mv	s1,a0
    80004be4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004be6:	00020917          	auipc	s2,0x20
    80004bea:	d3290913          	addi	s2,s2,-718 # 80024918 <log>
    80004bee:	00005597          	auipc	a1,0x5
    80004bf2:	95258593          	addi	a1,a1,-1710 # 80009540 <etext+0x540>
    80004bf6:	854a                	mv	a0,s2
    80004bf8:	c80fc0ef          	jal	80001078 <initlock>
  log.start = sb->logstart;
    80004bfc:	0149a583          	lw	a1,20(s3)
    80004c00:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80004c04:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80004c08:	8526                	mv	a0,s1
    80004c0a:	fa9fe0ef          	jal	80003bb2 <bread>
  log.lh.n = lh->n;
    80004c0e:	4d30                	lw	a2,88(a0)
    80004c10:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80004c14:	00c05f63          	blez	a2,80004c32 <initlog+0x5e>
    80004c18:	87aa                	mv	a5,a0
    80004c1a:	00020717          	auipc	a4,0x20
    80004c1e:	d2a70713          	addi	a4,a4,-726 # 80024944 <log+0x2c>
    80004c22:	060a                	slli	a2,a2,0x2
    80004c24:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004c26:	4ff4                	lw	a3,92(a5)
    80004c28:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004c2a:	0791                	addi	a5,a5,4
    80004c2c:	0711                	addi	a4,a4,4
    80004c2e:	fec79ce3          	bne	a5,a2,80004c26 <initlog+0x52>
  brelse(buf);
    80004c32:	888ff0ef          	jal	80003cba <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004c36:	4505                	li	a0,1
    80004c38:	ed1ff0ef          	jal	80004b08 <install_trans>
  log.lh.n = 0;
    80004c3c:	00020797          	auipc	a5,0x20
    80004c40:	d007a223          	sw	zero,-764(a5) # 80024940 <log+0x28>
  write_head(); // clear the log
    80004c44:	e67ff0ef          	jal	80004aaa <write_head>
}
    80004c48:	70a2                	ld	ra,40(sp)
    80004c4a:	7402                	ld	s0,32(sp)
    80004c4c:	64e2                	ld	s1,24(sp)
    80004c4e:	6942                	ld	s2,16(sp)
    80004c50:	69a2                	ld	s3,8(sp)
    80004c52:	6145                	addi	sp,sp,48
    80004c54:	8082                	ret

0000000080004c56 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004c56:	1101                	addi	sp,sp,-32
    80004c58:	ec06                	sd	ra,24(sp)
    80004c5a:	e822                	sd	s0,16(sp)
    80004c5c:	e426                	sd	s1,8(sp)
    80004c5e:	e04a                	sd	s2,0(sp)
    80004c60:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004c62:	00020517          	auipc	a0,0x20
    80004c66:	cb650513          	addi	a0,a0,-842 # 80024918 <log>
    80004c6a:	c98fc0ef          	jal	80001102 <acquire>
  while(1){
    if(log.committing){
    80004c6e:	00020497          	auipc	s1,0x20
    80004c72:	caa48493          	addi	s1,s1,-854 # 80024918 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80004c76:	4979                	li	s2,30
    80004c78:	a029                	j	80004c82 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80004c7a:	85a6                	mv	a1,s1
    80004c7c:	8526                	mv	a0,s1
    80004c7e:	c0bfd0ef          	jal	80002888 <sleep>
    if(log.committing){
    80004c82:	509c                	lw	a5,32(s1)
    80004c84:	fbfd                	bnez	a5,80004c7a <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80004c86:	4cd8                	lw	a4,28(s1)
    80004c88:	2705                	addiw	a4,a4,1
    80004c8a:	0027179b          	slliw	a5,a4,0x2
    80004c8e:	9fb9                	addw	a5,a5,a4
    80004c90:	0017979b          	slliw	a5,a5,0x1
    80004c94:	5494                	lw	a3,40(s1)
    80004c96:	9fb5                	addw	a5,a5,a3
    80004c98:	00f95763          	bge	s2,a5,80004ca6 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004c9c:	85a6                	mv	a1,s1
    80004c9e:	8526                	mv	a0,s1
    80004ca0:	be9fd0ef          	jal	80002888 <sleep>
    80004ca4:	bff9                	j	80004c82 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80004ca6:	00020797          	auipc	a5,0x20
    80004caa:	c8e7a723          	sw	a4,-882(a5) # 80024934 <log+0x1c>
      release(&log.lock);
    80004cae:	00020517          	auipc	a0,0x20
    80004cb2:	c6a50513          	addi	a0,a0,-918 # 80024918 <log>
    80004cb6:	ce0fc0ef          	jal	80001196 <release>
      break;
    }
  }
}
    80004cba:	60e2                	ld	ra,24(sp)
    80004cbc:	6442                	ld	s0,16(sp)
    80004cbe:	64a2                	ld	s1,8(sp)
    80004cc0:	6902                	ld	s2,0(sp)
    80004cc2:	6105                	addi	sp,sp,32
    80004cc4:	8082                	ret

0000000080004cc6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004cc6:	7139                	addi	sp,sp,-64
    80004cc8:	fc06                	sd	ra,56(sp)
    80004cca:	f822                	sd	s0,48(sp)
    80004ccc:	f426                	sd	s1,40(sp)
    80004cce:	f04a                	sd	s2,32(sp)
    80004cd0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004cd2:	00020497          	auipc	s1,0x20
    80004cd6:	c4648493          	addi	s1,s1,-954 # 80024918 <log>
    80004cda:	8526                	mv	a0,s1
    80004cdc:	c26fc0ef          	jal	80001102 <acquire>
  log.outstanding -= 1;
    80004ce0:	4cdc                	lw	a5,28(s1)
    80004ce2:	37fd                	addiw	a5,a5,-1
    80004ce4:	893e                	mv	s2,a5
    80004ce6:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80004ce8:	509c                	lw	a5,32(s1)
    80004cea:	e7b1                	bnez	a5,80004d36 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80004cec:	04091e63          	bnez	s2,80004d48 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80004cf0:	00020497          	auipc	s1,0x20
    80004cf4:	c2848493          	addi	s1,s1,-984 # 80024918 <log>
    80004cf8:	4785                	li	a5,1
    80004cfa:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004cfc:	8526                	mv	a0,s1
    80004cfe:	c98fc0ef          	jal	80001196 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004d02:	549c                	lw	a5,40(s1)
    80004d04:	06f04463          	bgtz	a5,80004d6c <end_op+0xa6>
    acquire(&log.lock);
    80004d08:	00020517          	auipc	a0,0x20
    80004d0c:	c1050513          	addi	a0,a0,-1008 # 80024918 <log>
    80004d10:	bf2fc0ef          	jal	80001102 <acquire>
    log.committing = 0;
    80004d14:	00020797          	auipc	a5,0x20
    80004d18:	c207a223          	sw	zero,-988(a5) # 80024938 <log+0x20>
    wakeup(&log);
    80004d1c:	00020517          	auipc	a0,0x20
    80004d20:	bfc50513          	addi	a0,a0,-1028 # 80024918 <log>
    80004d24:	bb1fd0ef          	jal	800028d4 <wakeup>
    release(&log.lock);
    80004d28:	00020517          	auipc	a0,0x20
    80004d2c:	bf050513          	addi	a0,a0,-1040 # 80024918 <log>
    80004d30:	c66fc0ef          	jal	80001196 <release>
}
    80004d34:	a035                	j	80004d60 <end_op+0x9a>
    80004d36:	ec4e                	sd	s3,24(sp)
    80004d38:	e852                	sd	s4,16(sp)
    80004d3a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004d3c:	00005517          	auipc	a0,0x5
    80004d40:	80c50513          	addi	a0,a0,-2036 # 80009548 <etext+0x548>
    80004d44:	ae1fb0ef          	jal	80000824 <panic>
    wakeup(&log);
    80004d48:	00020517          	auipc	a0,0x20
    80004d4c:	bd050513          	addi	a0,a0,-1072 # 80024918 <log>
    80004d50:	b85fd0ef          	jal	800028d4 <wakeup>
  release(&log.lock);
    80004d54:	00020517          	auipc	a0,0x20
    80004d58:	bc450513          	addi	a0,a0,-1084 # 80024918 <log>
    80004d5c:	c3afc0ef          	jal	80001196 <release>
}
    80004d60:	70e2                	ld	ra,56(sp)
    80004d62:	7442                	ld	s0,48(sp)
    80004d64:	74a2                	ld	s1,40(sp)
    80004d66:	7902                	ld	s2,32(sp)
    80004d68:	6121                	addi	sp,sp,64
    80004d6a:	8082                	ret
    80004d6c:	ec4e                	sd	s3,24(sp)
    80004d6e:	e852                	sd	s4,16(sp)
    80004d70:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004d72:	00020a97          	auipc	s5,0x20
    80004d76:	bd2a8a93          	addi	s5,s5,-1070 # 80024944 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004d7a:	00020a17          	auipc	s4,0x20
    80004d7e:	b9ea0a13          	addi	s4,s4,-1122 # 80024918 <log>
    80004d82:	018a2583          	lw	a1,24(s4)
    80004d86:	012585bb          	addw	a1,a1,s2
    80004d8a:	2585                	addiw	a1,a1,1
    80004d8c:	024a2503          	lw	a0,36(s4)
    80004d90:	e23fe0ef          	jal	80003bb2 <bread>
    80004d94:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004d96:	000aa583          	lw	a1,0(s5)
    80004d9a:	024a2503          	lw	a0,36(s4)
    80004d9e:	e15fe0ef          	jal	80003bb2 <bread>
    80004da2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004da4:	40000613          	li	a2,1024
    80004da8:	05850593          	addi	a1,a0,88
    80004dac:	05848513          	addi	a0,s1,88
    80004db0:	c82fc0ef          	jal	80001232 <memmove>
    bwrite(to);  // write the log
    80004db4:	8526                	mv	a0,s1
    80004db6:	ed3fe0ef          	jal	80003c88 <bwrite>
    brelse(from);
    80004dba:	854e                	mv	a0,s3
    80004dbc:	efffe0ef          	jal	80003cba <brelse>
    brelse(to);
    80004dc0:	8526                	mv	a0,s1
    80004dc2:	ef9fe0ef          	jal	80003cba <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004dc6:	2905                	addiw	s2,s2,1
    80004dc8:	0a91                	addi	s5,s5,4
    80004dca:	028a2783          	lw	a5,40(s4)
    80004dce:	faf94ae3          	blt	s2,a5,80004d82 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004dd2:	cd9ff0ef          	jal	80004aaa <write_head>
    install_trans(0); // Now install writes to home locations
    80004dd6:	4501                	li	a0,0
    80004dd8:	d31ff0ef          	jal	80004b08 <install_trans>
    log.lh.n = 0;
    80004ddc:	00020797          	auipc	a5,0x20
    80004de0:	b607a223          	sw	zero,-1180(a5) # 80024940 <log+0x28>
    write_head();    // Erase the transaction from the log
    80004de4:	cc7ff0ef          	jal	80004aaa <write_head>
    80004de8:	69e2                	ld	s3,24(sp)
    80004dea:	6a42                	ld	s4,16(sp)
    80004dec:	6aa2                	ld	s5,8(sp)
    80004dee:	bf29                	j	80004d08 <end_op+0x42>

0000000080004df0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004df0:	1101                	addi	sp,sp,-32
    80004df2:	ec06                	sd	ra,24(sp)
    80004df4:	e822                	sd	s0,16(sp)
    80004df6:	e426                	sd	s1,8(sp)
    80004df8:	1000                	addi	s0,sp,32
    80004dfa:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004dfc:	00020517          	auipc	a0,0x20
    80004e00:	b1c50513          	addi	a0,a0,-1252 # 80024918 <log>
    80004e04:	afefc0ef          	jal	80001102 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80004e08:	00020617          	auipc	a2,0x20
    80004e0c:	b3862603          	lw	a2,-1224(a2) # 80024940 <log+0x28>
    80004e10:	47f5                	li	a5,29
    80004e12:	04c7cd63          	blt	a5,a2,80004e6c <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004e16:	00020797          	auipc	a5,0x20
    80004e1a:	b1e7a783          	lw	a5,-1250(a5) # 80024934 <log+0x1c>
    80004e1e:	04f05d63          	blez	a5,80004e78 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004e22:	4781                	li	a5,0
    80004e24:	06c05063          	blez	a2,80004e84 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004e28:	44cc                	lw	a1,12(s1)
    80004e2a:	00020717          	auipc	a4,0x20
    80004e2e:	b1a70713          	addi	a4,a4,-1254 # 80024944 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80004e32:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004e34:	4314                	lw	a3,0(a4)
    80004e36:	04b68763          	beq	a3,a1,80004e84 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80004e3a:	2785                	addiw	a5,a5,1
    80004e3c:	0711                	addi	a4,a4,4
    80004e3e:	fef61be3          	bne	a2,a5,80004e34 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004e42:	060a                	slli	a2,a2,0x2
    80004e44:	02060613          	addi	a2,a2,32
    80004e48:	00020797          	auipc	a5,0x20
    80004e4c:	ad078793          	addi	a5,a5,-1328 # 80024918 <log>
    80004e50:	97b2                	add	a5,a5,a2
    80004e52:	44d8                	lw	a4,12(s1)
    80004e54:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004e56:	8526                	mv	a0,s1
    80004e58:	ee7fe0ef          	jal	80003d3e <bpin>
    log.lh.n++;
    80004e5c:	00020717          	auipc	a4,0x20
    80004e60:	abc70713          	addi	a4,a4,-1348 # 80024918 <log>
    80004e64:	571c                	lw	a5,40(a4)
    80004e66:	2785                	addiw	a5,a5,1
    80004e68:	d71c                	sw	a5,40(a4)
    80004e6a:	a815                	j	80004e9e <log_write+0xae>
    panic("too big a transaction");
    80004e6c:	00004517          	auipc	a0,0x4
    80004e70:	6ec50513          	addi	a0,a0,1772 # 80009558 <etext+0x558>
    80004e74:	9b1fb0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    80004e78:	00004517          	auipc	a0,0x4
    80004e7c:	6f850513          	addi	a0,a0,1784 # 80009570 <etext+0x570>
    80004e80:	9a5fb0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    80004e84:	00279693          	slli	a3,a5,0x2
    80004e88:	02068693          	addi	a3,a3,32
    80004e8c:	00020717          	auipc	a4,0x20
    80004e90:	a8c70713          	addi	a4,a4,-1396 # 80024918 <log>
    80004e94:	9736                	add	a4,a4,a3
    80004e96:	44d4                	lw	a3,12(s1)
    80004e98:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004e9a:	faf60ee3          	beq	a2,a5,80004e56 <log_write+0x66>
  }
  release(&log.lock);
    80004e9e:	00020517          	auipc	a0,0x20
    80004ea2:	a7a50513          	addi	a0,a0,-1414 # 80024918 <log>
    80004ea6:	af0fc0ef          	jal	80001196 <release>
}
    80004eaa:	60e2                	ld	ra,24(sp)
    80004eac:	6442                	ld	s0,16(sp)
    80004eae:	64a2                	ld	s1,8(sp)
    80004eb0:	6105                	addi	sp,sp,32
    80004eb2:	8082                	ret

0000000080004eb4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004eb4:	1101                	addi	sp,sp,-32
    80004eb6:	ec06                	sd	ra,24(sp)
    80004eb8:	e822                	sd	s0,16(sp)
    80004eba:	e426                	sd	s1,8(sp)
    80004ebc:	e04a                	sd	s2,0(sp)
    80004ebe:	1000                	addi	s0,sp,32
    80004ec0:	84aa                	mv	s1,a0
    80004ec2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004ec4:	00004597          	auipc	a1,0x4
    80004ec8:	6cc58593          	addi	a1,a1,1740 # 80009590 <etext+0x590>
    80004ecc:	0521                	addi	a0,a0,8
    80004ece:	9aafc0ef          	jal	80001078 <initlock>
  lk->name = name;
    80004ed2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004ed6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004eda:	0204a423          	sw	zero,40(s1)
}
    80004ede:	60e2                	ld	ra,24(sp)
    80004ee0:	6442                	ld	s0,16(sp)
    80004ee2:	64a2                	ld	s1,8(sp)
    80004ee4:	6902                	ld	s2,0(sp)
    80004ee6:	6105                	addi	sp,sp,32
    80004ee8:	8082                	ret

0000000080004eea <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004eea:	1101                	addi	sp,sp,-32
    80004eec:	ec06                	sd	ra,24(sp)
    80004eee:	e822                	sd	s0,16(sp)
    80004ef0:	e426                	sd	s1,8(sp)
    80004ef2:	e04a                	sd	s2,0(sp)
    80004ef4:	1000                	addi	s0,sp,32
    80004ef6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004ef8:	00850913          	addi	s2,a0,8
    80004efc:	854a                	mv	a0,s2
    80004efe:	a04fc0ef          	jal	80001102 <acquire>
  while (lk->locked) {
    80004f02:	409c                	lw	a5,0(s1)
    80004f04:	c799                	beqz	a5,80004f12 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004f06:	85ca                	mv	a1,s2
    80004f08:	8526                	mv	a0,s1
    80004f0a:	97ffd0ef          	jal	80002888 <sleep>
  while (lk->locked) {
    80004f0e:	409c                	lw	a5,0(s1)
    80004f10:	fbfd                	bnez	a5,80004f06 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004f12:	4785                	li	a5,1
    80004f14:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004f16:	954fd0ef          	jal	8000206a <myproc>
    80004f1a:	591c                	lw	a5,48(a0)
    80004f1c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004f1e:	854a                	mv	a0,s2
    80004f20:	a76fc0ef          	jal	80001196 <release>
}
    80004f24:	60e2                	ld	ra,24(sp)
    80004f26:	6442                	ld	s0,16(sp)
    80004f28:	64a2                	ld	s1,8(sp)
    80004f2a:	6902                	ld	s2,0(sp)
    80004f2c:	6105                	addi	sp,sp,32
    80004f2e:	8082                	ret

0000000080004f30 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004f30:	1101                	addi	sp,sp,-32
    80004f32:	ec06                	sd	ra,24(sp)
    80004f34:	e822                	sd	s0,16(sp)
    80004f36:	e426                	sd	s1,8(sp)
    80004f38:	e04a                	sd	s2,0(sp)
    80004f3a:	1000                	addi	s0,sp,32
    80004f3c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004f3e:	00850913          	addi	s2,a0,8
    80004f42:	854a                	mv	a0,s2
    80004f44:	9befc0ef          	jal	80001102 <acquire>
  lk->locked = 0;
    80004f48:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004f4c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004f50:	8526                	mv	a0,s1
    80004f52:	983fd0ef          	jal	800028d4 <wakeup>
  release(&lk->lk);
    80004f56:	854a                	mv	a0,s2
    80004f58:	a3efc0ef          	jal	80001196 <release>
}
    80004f5c:	60e2                	ld	ra,24(sp)
    80004f5e:	6442                	ld	s0,16(sp)
    80004f60:	64a2                	ld	s1,8(sp)
    80004f62:	6902                	ld	s2,0(sp)
    80004f64:	6105                	addi	sp,sp,32
    80004f66:	8082                	ret

0000000080004f68 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004f68:	7179                	addi	sp,sp,-48
    80004f6a:	f406                	sd	ra,40(sp)
    80004f6c:	f022                	sd	s0,32(sp)
    80004f6e:	ec26                	sd	s1,24(sp)
    80004f70:	e84a                	sd	s2,16(sp)
    80004f72:	1800                	addi	s0,sp,48
    80004f74:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004f76:	00850913          	addi	s2,a0,8
    80004f7a:	854a                	mv	a0,s2
    80004f7c:	986fc0ef          	jal	80001102 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004f80:	409c                	lw	a5,0(s1)
    80004f82:	ef81                	bnez	a5,80004f9a <holdingsleep+0x32>
    80004f84:	4481                	li	s1,0
  release(&lk->lk);
    80004f86:	854a                	mv	a0,s2
    80004f88:	a0efc0ef          	jal	80001196 <release>
  return r;
}
    80004f8c:	8526                	mv	a0,s1
    80004f8e:	70a2                	ld	ra,40(sp)
    80004f90:	7402                	ld	s0,32(sp)
    80004f92:	64e2                	ld	s1,24(sp)
    80004f94:	6942                	ld	s2,16(sp)
    80004f96:	6145                	addi	sp,sp,48
    80004f98:	8082                	ret
    80004f9a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004f9c:	0284a983          	lw	s3,40(s1)
    80004fa0:	8cafd0ef          	jal	8000206a <myproc>
    80004fa4:	5904                	lw	s1,48(a0)
    80004fa6:	413484b3          	sub	s1,s1,s3
    80004faa:	0014b493          	seqz	s1,s1
    80004fae:	69a2                	ld	s3,8(sp)
    80004fb0:	bfd9                	j	80004f86 <holdingsleep+0x1e>

0000000080004fb2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004fb2:	1141                	addi	sp,sp,-16
    80004fb4:	e406                	sd	ra,8(sp)
    80004fb6:	e022                	sd	s0,0(sp)
    80004fb8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004fba:	00004597          	auipc	a1,0x4
    80004fbe:	5e658593          	addi	a1,a1,1510 # 800095a0 <etext+0x5a0>
    80004fc2:	00020517          	auipc	a0,0x20
    80004fc6:	a9e50513          	addi	a0,a0,-1378 # 80024a60 <ftable>
    80004fca:	8aefc0ef          	jal	80001078 <initlock>
}
    80004fce:	60a2                	ld	ra,8(sp)
    80004fd0:	6402                	ld	s0,0(sp)
    80004fd2:	0141                	addi	sp,sp,16
    80004fd4:	8082                	ret

0000000080004fd6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004fd6:	1101                	addi	sp,sp,-32
    80004fd8:	ec06                	sd	ra,24(sp)
    80004fda:	e822                	sd	s0,16(sp)
    80004fdc:	e426                	sd	s1,8(sp)
    80004fde:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004fe0:	00020517          	auipc	a0,0x20
    80004fe4:	a8050513          	addi	a0,a0,-1408 # 80024a60 <ftable>
    80004fe8:	91afc0ef          	jal	80001102 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004fec:	00020497          	auipc	s1,0x20
    80004ff0:	a8c48493          	addi	s1,s1,-1396 # 80024a78 <ftable+0x18>
    80004ff4:	00021717          	auipc	a4,0x21
    80004ff8:	a2470713          	addi	a4,a4,-1500 # 80025a18 <disk>
    if(f->ref == 0){
    80004ffc:	40dc                	lw	a5,4(s1)
    80004ffe:	cf89                	beqz	a5,80005018 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005000:	02848493          	addi	s1,s1,40
    80005004:	fee49ce3          	bne	s1,a4,80004ffc <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80005008:	00020517          	auipc	a0,0x20
    8000500c:	a5850513          	addi	a0,a0,-1448 # 80024a60 <ftable>
    80005010:	986fc0ef          	jal	80001196 <release>
  return 0;
    80005014:	4481                	li	s1,0
    80005016:	a809                	j	80005028 <filealloc+0x52>
      f->ref = 1;
    80005018:	4785                	li	a5,1
    8000501a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000501c:	00020517          	auipc	a0,0x20
    80005020:	a4450513          	addi	a0,a0,-1468 # 80024a60 <ftable>
    80005024:	972fc0ef          	jal	80001196 <release>
}
    80005028:	8526                	mv	a0,s1
    8000502a:	60e2                	ld	ra,24(sp)
    8000502c:	6442                	ld	s0,16(sp)
    8000502e:	64a2                	ld	s1,8(sp)
    80005030:	6105                	addi	sp,sp,32
    80005032:	8082                	ret

0000000080005034 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80005034:	1101                	addi	sp,sp,-32
    80005036:	ec06                	sd	ra,24(sp)
    80005038:	e822                	sd	s0,16(sp)
    8000503a:	e426                	sd	s1,8(sp)
    8000503c:	1000                	addi	s0,sp,32
    8000503e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80005040:	00020517          	auipc	a0,0x20
    80005044:	a2050513          	addi	a0,a0,-1504 # 80024a60 <ftable>
    80005048:	8bafc0ef          	jal	80001102 <acquire>
  if(f->ref < 1)
    8000504c:	40dc                	lw	a5,4(s1)
    8000504e:	02f05063          	blez	a5,8000506e <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80005052:	2785                	addiw	a5,a5,1
    80005054:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80005056:	00020517          	auipc	a0,0x20
    8000505a:	a0a50513          	addi	a0,a0,-1526 # 80024a60 <ftable>
    8000505e:	938fc0ef          	jal	80001196 <release>
  return f;
}
    80005062:	8526                	mv	a0,s1
    80005064:	60e2                	ld	ra,24(sp)
    80005066:	6442                	ld	s0,16(sp)
    80005068:	64a2                	ld	s1,8(sp)
    8000506a:	6105                	addi	sp,sp,32
    8000506c:	8082                	ret
    panic("filedup");
    8000506e:	00004517          	auipc	a0,0x4
    80005072:	53a50513          	addi	a0,a0,1338 # 800095a8 <etext+0x5a8>
    80005076:	faefb0ef          	jal	80000824 <panic>

000000008000507a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000507a:	7139                	addi	sp,sp,-64
    8000507c:	fc06                	sd	ra,56(sp)
    8000507e:	f822                	sd	s0,48(sp)
    80005080:	f426                	sd	s1,40(sp)
    80005082:	0080                	addi	s0,sp,64
    80005084:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005086:	00020517          	auipc	a0,0x20
    8000508a:	9da50513          	addi	a0,a0,-1574 # 80024a60 <ftable>
    8000508e:	874fc0ef          	jal	80001102 <acquire>
  if(f->ref < 1)
    80005092:	40dc                	lw	a5,4(s1)
    80005094:	04f05a63          	blez	a5,800050e8 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80005098:	37fd                	addiw	a5,a5,-1
    8000509a:	c0dc                	sw	a5,4(s1)
    8000509c:	06f04063          	bgtz	a5,800050fc <fileclose+0x82>
    800050a0:	f04a                	sd	s2,32(sp)
    800050a2:	ec4e                	sd	s3,24(sp)
    800050a4:	e852                	sd	s4,16(sp)
    800050a6:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800050a8:	0004a903          	lw	s2,0(s1)
    800050ac:	0094c783          	lbu	a5,9(s1)
    800050b0:	89be                	mv	s3,a5
    800050b2:	689c                	ld	a5,16(s1)
    800050b4:	8a3e                	mv	s4,a5
    800050b6:	6c9c                	ld	a5,24(s1)
    800050b8:	8abe                	mv	s5,a5
  f->ref = 0;
    800050ba:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800050be:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800050c2:	00020517          	auipc	a0,0x20
    800050c6:	99e50513          	addi	a0,a0,-1634 # 80024a60 <ftable>
    800050ca:	8ccfc0ef          	jal	80001196 <release>

  if(ff.type == FD_PIPE){
    800050ce:	4785                	li	a5,1
    800050d0:	04f90163          	beq	s2,a5,80005112 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800050d4:	ffe9079b          	addiw	a5,s2,-2
    800050d8:	4705                	li	a4,1
    800050da:	04f77563          	bgeu	a4,a5,80005124 <fileclose+0xaa>
    800050de:	7902                	ld	s2,32(sp)
    800050e0:	69e2                	ld	s3,24(sp)
    800050e2:	6a42                	ld	s4,16(sp)
    800050e4:	6aa2                	ld	s5,8(sp)
    800050e6:	a00d                	j	80005108 <fileclose+0x8e>
    800050e8:	f04a                	sd	s2,32(sp)
    800050ea:	ec4e                	sd	s3,24(sp)
    800050ec:	e852                	sd	s4,16(sp)
    800050ee:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800050f0:	00004517          	auipc	a0,0x4
    800050f4:	4c050513          	addi	a0,a0,1216 # 800095b0 <etext+0x5b0>
    800050f8:	f2cfb0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    800050fc:	00020517          	auipc	a0,0x20
    80005100:	96450513          	addi	a0,a0,-1692 # 80024a60 <ftable>
    80005104:	892fc0ef          	jal	80001196 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80005108:	70e2                	ld	ra,56(sp)
    8000510a:	7442                	ld	s0,48(sp)
    8000510c:	74a2                	ld	s1,40(sp)
    8000510e:	6121                	addi	sp,sp,64
    80005110:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80005112:	85ce                	mv	a1,s3
    80005114:	8552                	mv	a0,s4
    80005116:	348000ef          	jal	8000545e <pipeclose>
    8000511a:	7902                	ld	s2,32(sp)
    8000511c:	69e2                	ld	s3,24(sp)
    8000511e:	6a42                	ld	s4,16(sp)
    80005120:	6aa2                	ld	s5,8(sp)
    80005122:	b7dd                	j	80005108 <fileclose+0x8e>
    begin_op();
    80005124:	b33ff0ef          	jal	80004c56 <begin_op>
    iput(ff.ip);
    80005128:	8556                	mv	a0,s5
    8000512a:	aa2ff0ef          	jal	800043cc <iput>
    end_op();
    8000512e:	b99ff0ef          	jal	80004cc6 <end_op>
    80005132:	7902                	ld	s2,32(sp)
    80005134:	69e2                	ld	s3,24(sp)
    80005136:	6a42                	ld	s4,16(sp)
    80005138:	6aa2                	ld	s5,8(sp)
    8000513a:	b7f9                	j	80005108 <fileclose+0x8e>

000000008000513c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000513c:	715d                	addi	sp,sp,-80
    8000513e:	e486                	sd	ra,72(sp)
    80005140:	e0a2                	sd	s0,64(sp)
    80005142:	fc26                	sd	s1,56(sp)
    80005144:	f052                	sd	s4,32(sp)
    80005146:	0880                	addi	s0,sp,80
    80005148:	84aa                	mv	s1,a0
    8000514a:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    8000514c:	f1ffc0ef          	jal	8000206a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80005150:	409c                	lw	a5,0(s1)
    80005152:	37f9                	addiw	a5,a5,-2
    80005154:	4705                	li	a4,1
    80005156:	04f76263          	bltu	a4,a5,8000519a <filestat+0x5e>
    8000515a:	f84a                	sd	s2,48(sp)
    8000515c:	f44e                	sd	s3,40(sp)
    8000515e:	89aa                	mv	s3,a0
    ilock(f->ip);
    80005160:	6c88                	ld	a0,24(s1)
    80005162:	8e8ff0ef          	jal	8000424a <ilock>
    stati(f->ip, &st);
    80005166:	fb840913          	addi	s2,s0,-72
    8000516a:	85ca                	mv	a1,s2
    8000516c:	6c88                	ld	a0,24(s1)
    8000516e:	c40ff0ef          	jal	800045ae <stati>
    iunlock(f->ip);
    80005172:	6c88                	ld	a0,24(s1)
    80005174:	984ff0ef          	jal	800042f8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80005178:	46e1                	li	a3,24
    8000517a:	864a                	mv	a2,s2
    8000517c:	85d2                	mv	a1,s4
    8000517e:	0509b503          	ld	a0,80(s3)
    80005182:	bf3fc0ef          	jal	80001d74 <copyout>
    80005186:	41f5551b          	sraiw	a0,a0,0x1f
    8000518a:	7942                	ld	s2,48(sp)
    8000518c:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000518e:	60a6                	ld	ra,72(sp)
    80005190:	6406                	ld	s0,64(sp)
    80005192:	74e2                	ld	s1,56(sp)
    80005194:	7a02                	ld	s4,32(sp)
    80005196:	6161                	addi	sp,sp,80
    80005198:	8082                	ret
  return -1;
    8000519a:	557d                	li	a0,-1
    8000519c:	bfcd                	j	8000518e <filestat+0x52>

000000008000519e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000519e:	7179                	addi	sp,sp,-48
    800051a0:	f406                	sd	ra,40(sp)
    800051a2:	f022                	sd	s0,32(sp)
    800051a4:	e84a                	sd	s2,16(sp)
    800051a6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800051a8:	00854783          	lbu	a5,8(a0)
    800051ac:	cfd1                	beqz	a5,80005248 <fileread+0xaa>
    800051ae:	ec26                	sd	s1,24(sp)
    800051b0:	e44e                	sd	s3,8(sp)
    800051b2:	84aa                	mv	s1,a0
    800051b4:	892e                	mv	s2,a1
    800051b6:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    800051b8:	411c                	lw	a5,0(a0)
    800051ba:	4705                	li	a4,1
    800051bc:	04e78363          	beq	a5,a4,80005202 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800051c0:	470d                	li	a4,3
    800051c2:	04e78763          	beq	a5,a4,80005210 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800051c6:	4709                	li	a4,2
    800051c8:	06e79a63          	bne	a5,a4,8000523c <fileread+0x9e>
    ilock(f->ip);
    800051cc:	6d08                	ld	a0,24(a0)
    800051ce:	87cff0ef          	jal	8000424a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800051d2:	874e                	mv	a4,s3
    800051d4:	5094                	lw	a3,32(s1)
    800051d6:	864a                	mv	a2,s2
    800051d8:	4585                	li	a1,1
    800051da:	6c88                	ld	a0,24(s1)
    800051dc:	c00ff0ef          	jal	800045dc <readi>
    800051e0:	892a                	mv	s2,a0
    800051e2:	00a05563          	blez	a0,800051ec <fileread+0x4e>
      f->off += r;
    800051e6:	509c                	lw	a5,32(s1)
    800051e8:	9fa9                	addw	a5,a5,a0
    800051ea:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800051ec:	6c88                	ld	a0,24(s1)
    800051ee:	90aff0ef          	jal	800042f8 <iunlock>
    800051f2:	64e2                	ld	s1,24(sp)
    800051f4:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800051f6:	854a                	mv	a0,s2
    800051f8:	70a2                	ld	ra,40(sp)
    800051fa:	7402                	ld	s0,32(sp)
    800051fc:	6942                	ld	s2,16(sp)
    800051fe:	6145                	addi	sp,sp,48
    80005200:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80005202:	6908                	ld	a0,16(a0)
    80005204:	3b0000ef          	jal	800055b4 <piperead>
    80005208:	892a                	mv	s2,a0
    8000520a:	64e2                	ld	s1,24(sp)
    8000520c:	69a2                	ld	s3,8(sp)
    8000520e:	b7e5                	j	800051f6 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80005210:	02451783          	lh	a5,36(a0)
    80005214:	03079693          	slli	a3,a5,0x30
    80005218:	92c1                	srli	a3,a3,0x30
    8000521a:	4725                	li	a4,9
    8000521c:	02d76963          	bltu	a4,a3,8000524e <fileread+0xb0>
    80005220:	0792                	slli	a5,a5,0x4
    80005222:	0001f717          	auipc	a4,0x1f
    80005226:	79e70713          	addi	a4,a4,1950 # 800249c0 <devsw>
    8000522a:	97ba                	add	a5,a5,a4
    8000522c:	639c                	ld	a5,0(a5)
    8000522e:	c78d                	beqz	a5,80005258 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80005230:	4505                	li	a0,1
    80005232:	9782                	jalr	a5
    80005234:	892a                	mv	s2,a0
    80005236:	64e2                	ld	s1,24(sp)
    80005238:	69a2                	ld	s3,8(sp)
    8000523a:	bf75                	j	800051f6 <fileread+0x58>
    panic("fileread");
    8000523c:	00004517          	auipc	a0,0x4
    80005240:	38450513          	addi	a0,a0,900 # 800095c0 <etext+0x5c0>
    80005244:	de0fb0ef          	jal	80000824 <panic>
    return -1;
    80005248:	57fd                	li	a5,-1
    8000524a:	893e                	mv	s2,a5
    8000524c:	b76d                	j	800051f6 <fileread+0x58>
      return -1;
    8000524e:	57fd                	li	a5,-1
    80005250:	893e                	mv	s2,a5
    80005252:	64e2                	ld	s1,24(sp)
    80005254:	69a2                	ld	s3,8(sp)
    80005256:	b745                	j	800051f6 <fileread+0x58>
    80005258:	57fd                	li	a5,-1
    8000525a:	893e                	mv	s2,a5
    8000525c:	64e2                	ld	s1,24(sp)
    8000525e:	69a2                	ld	s3,8(sp)
    80005260:	bf59                	j	800051f6 <fileread+0x58>

0000000080005262 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80005262:	00954783          	lbu	a5,9(a0)
    80005266:	10078f63          	beqz	a5,80005384 <filewrite+0x122>
{
    8000526a:	711d                	addi	sp,sp,-96
    8000526c:	ec86                	sd	ra,88(sp)
    8000526e:	e8a2                	sd	s0,80(sp)
    80005270:	e0ca                	sd	s2,64(sp)
    80005272:	f456                	sd	s5,40(sp)
    80005274:	f05a                	sd	s6,32(sp)
    80005276:	1080                	addi	s0,sp,96
    80005278:	892a                	mv	s2,a0
    8000527a:	8b2e                	mv	s6,a1
    8000527c:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000527e:	411c                	lw	a5,0(a0)
    80005280:	4705                	li	a4,1
    80005282:	02e78a63          	beq	a5,a4,800052b6 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005286:	470d                	li	a4,3
    80005288:	02e78b63          	beq	a5,a4,800052be <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000528c:	4709                	li	a4,2
    8000528e:	0ce79f63          	bne	a5,a4,8000536c <filewrite+0x10a>
    80005292:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005294:	0ac05a63          	blez	a2,80005348 <filewrite+0xe6>
    80005298:	e4a6                	sd	s1,72(sp)
    8000529a:	fc4e                	sd	s3,56(sp)
    8000529c:	ec5e                	sd	s7,24(sp)
    8000529e:	e862                	sd	s8,16(sp)
    800052a0:	e466                	sd	s9,8(sp)
    int i = 0;
    800052a2:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800052a4:	6b85                	lui	s7,0x1
    800052a6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800052aa:	6785                	lui	a5,0x1
    800052ac:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800052b0:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800052b2:	4c05                	li	s8,1
    800052b4:	a8ad                	j	8000532e <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800052b6:	6908                	ld	a0,16(a0)
    800052b8:	204000ef          	jal	800054bc <pipewrite>
    800052bc:	a04d                	j	8000535e <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800052be:	02451783          	lh	a5,36(a0)
    800052c2:	03079693          	slli	a3,a5,0x30
    800052c6:	92c1                	srli	a3,a3,0x30
    800052c8:	4725                	li	a4,9
    800052ca:	0ad76f63          	bltu	a4,a3,80005388 <filewrite+0x126>
    800052ce:	0792                	slli	a5,a5,0x4
    800052d0:	0001f717          	auipc	a4,0x1f
    800052d4:	6f070713          	addi	a4,a4,1776 # 800249c0 <devsw>
    800052d8:	97ba                	add	a5,a5,a4
    800052da:	679c                	ld	a5,8(a5)
    800052dc:	cbc5                	beqz	a5,8000538c <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    800052de:	4505                	li	a0,1
    800052e0:	9782                	jalr	a5
    800052e2:	a8b5                	j	8000535e <filewrite+0xfc>
      if(n1 > max)
    800052e4:	2981                	sext.w	s3,s3
      begin_op();
    800052e6:	971ff0ef          	jal	80004c56 <begin_op>
      ilock(f->ip);
    800052ea:	01893503          	ld	a0,24(s2)
    800052ee:	f5dfe0ef          	jal	8000424a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800052f2:	874e                	mv	a4,s3
    800052f4:	02092683          	lw	a3,32(s2)
    800052f8:	016a0633          	add	a2,s4,s6
    800052fc:	85e2                	mv	a1,s8
    800052fe:	01893503          	ld	a0,24(s2)
    80005302:	bccff0ef          	jal	800046ce <writei>
    80005306:	84aa                	mv	s1,a0
    80005308:	00a05763          	blez	a0,80005316 <filewrite+0xb4>
        f->off += r;
    8000530c:	02092783          	lw	a5,32(s2)
    80005310:	9fa9                	addw	a5,a5,a0
    80005312:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005316:	01893503          	ld	a0,24(s2)
    8000531a:	fdffe0ef          	jal	800042f8 <iunlock>
      end_op();
    8000531e:	9a9ff0ef          	jal	80004cc6 <end_op>

      if(r != n1){
    80005322:	02999563          	bne	s3,s1,8000534c <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80005326:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    8000532a:	015a5963          	bge	s4,s5,8000533c <filewrite+0xda>
      int n1 = n - i;
    8000532e:	414a87bb          	subw	a5,s5,s4
    80005332:	89be                	mv	s3,a5
      if(n1 > max)
    80005334:	fafbd8e3          	bge	s7,a5,800052e4 <filewrite+0x82>
    80005338:	89e6                	mv	s3,s9
    8000533a:	b76d                	j	800052e4 <filewrite+0x82>
    8000533c:	64a6                	ld	s1,72(sp)
    8000533e:	79e2                	ld	s3,56(sp)
    80005340:	6be2                	ld	s7,24(sp)
    80005342:	6c42                	ld	s8,16(sp)
    80005344:	6ca2                	ld	s9,8(sp)
    80005346:	a801                	j	80005356 <filewrite+0xf4>
    int i = 0;
    80005348:	4a01                	li	s4,0
    8000534a:	a031                	j	80005356 <filewrite+0xf4>
    8000534c:	64a6                	ld	s1,72(sp)
    8000534e:	79e2                	ld	s3,56(sp)
    80005350:	6be2                	ld	s7,24(sp)
    80005352:	6c42                	ld	s8,16(sp)
    80005354:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80005356:	034a9d63          	bne	s5,s4,80005390 <filewrite+0x12e>
    8000535a:	8556                	mv	a0,s5
    8000535c:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000535e:	60e6                	ld	ra,88(sp)
    80005360:	6446                	ld	s0,80(sp)
    80005362:	6906                	ld	s2,64(sp)
    80005364:	7aa2                	ld	s5,40(sp)
    80005366:	7b02                	ld	s6,32(sp)
    80005368:	6125                	addi	sp,sp,96
    8000536a:	8082                	ret
    8000536c:	e4a6                	sd	s1,72(sp)
    8000536e:	fc4e                	sd	s3,56(sp)
    80005370:	f852                	sd	s4,48(sp)
    80005372:	ec5e                	sd	s7,24(sp)
    80005374:	e862                	sd	s8,16(sp)
    80005376:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80005378:	00004517          	auipc	a0,0x4
    8000537c:	25850513          	addi	a0,a0,600 # 800095d0 <etext+0x5d0>
    80005380:	ca4fb0ef          	jal	80000824 <panic>
    return -1;
    80005384:	557d                	li	a0,-1
}
    80005386:	8082                	ret
      return -1;
    80005388:	557d                	li	a0,-1
    8000538a:	bfd1                	j	8000535e <filewrite+0xfc>
    8000538c:	557d                	li	a0,-1
    8000538e:	bfc1                	j	8000535e <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80005390:	557d                	li	a0,-1
    80005392:	7a42                	ld	s4,48(sp)
    80005394:	b7e9                	j	8000535e <filewrite+0xfc>

0000000080005396 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005396:	7179                	addi	sp,sp,-48
    80005398:	f406                	sd	ra,40(sp)
    8000539a:	f022                	sd	s0,32(sp)
    8000539c:	ec26                	sd	s1,24(sp)
    8000539e:	e052                	sd	s4,0(sp)
    800053a0:	1800                	addi	s0,sp,48
    800053a2:	84aa                	mv	s1,a0
    800053a4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800053a6:	0005b023          	sd	zero,0(a1)
    800053aa:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800053ae:	c29ff0ef          	jal	80004fd6 <filealloc>
    800053b2:	e088                	sd	a0,0(s1)
    800053b4:	c549                	beqz	a0,8000543e <pipealloc+0xa8>
    800053b6:	c21ff0ef          	jal	80004fd6 <filealloc>
    800053ba:	00aa3023          	sd	a0,0(s4)
    800053be:	cd25                	beqz	a0,80005436 <pipealloc+0xa0>
    800053c0:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800053c2:	fc6fb0ef          	jal	80000b88 <kalloc>
    800053c6:	892a                	mv	s2,a0
    800053c8:	c12d                	beqz	a0,8000542a <pipealloc+0x94>
    800053ca:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800053cc:	4985                	li	s3,1
    800053ce:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800053d2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800053d6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800053da:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800053de:	00004597          	auipc	a1,0x4
    800053e2:	20258593          	addi	a1,a1,514 # 800095e0 <etext+0x5e0>
    800053e6:	c93fb0ef          	jal	80001078 <initlock>
  (*f0)->type = FD_PIPE;
    800053ea:	609c                	ld	a5,0(s1)
    800053ec:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800053f0:	609c                	ld	a5,0(s1)
    800053f2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800053f6:	609c                	ld	a5,0(s1)
    800053f8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800053fc:	609c                	ld	a5,0(s1)
    800053fe:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80005402:	000a3783          	ld	a5,0(s4)
    80005406:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000540a:	000a3783          	ld	a5,0(s4)
    8000540e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80005412:	000a3783          	ld	a5,0(s4)
    80005416:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000541a:	000a3783          	ld	a5,0(s4)
    8000541e:	0127b823          	sd	s2,16(a5)
  return 0;
    80005422:	4501                	li	a0,0
    80005424:	6942                	ld	s2,16(sp)
    80005426:	69a2                	ld	s3,8(sp)
    80005428:	a01d                	j	8000544e <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000542a:	6088                	ld	a0,0(s1)
    8000542c:	c119                	beqz	a0,80005432 <pipealloc+0x9c>
    8000542e:	6942                	ld	s2,16(sp)
    80005430:	a029                	j	8000543a <pipealloc+0xa4>
    80005432:	6942                	ld	s2,16(sp)
    80005434:	a029                	j	8000543e <pipealloc+0xa8>
    80005436:	6088                	ld	a0,0(s1)
    80005438:	c10d                	beqz	a0,8000545a <pipealloc+0xc4>
    fileclose(*f0);
    8000543a:	c41ff0ef          	jal	8000507a <fileclose>
  if(*f1)
    8000543e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80005442:	557d                	li	a0,-1
  if(*f1)
    80005444:	c789                	beqz	a5,8000544e <pipealloc+0xb8>
    fileclose(*f1);
    80005446:	853e                	mv	a0,a5
    80005448:	c33ff0ef          	jal	8000507a <fileclose>
  return -1;
    8000544c:	557d                	li	a0,-1
}
    8000544e:	70a2                	ld	ra,40(sp)
    80005450:	7402                	ld	s0,32(sp)
    80005452:	64e2                	ld	s1,24(sp)
    80005454:	6a02                	ld	s4,0(sp)
    80005456:	6145                	addi	sp,sp,48
    80005458:	8082                	ret
  return -1;
    8000545a:	557d                	li	a0,-1
    8000545c:	bfcd                	j	8000544e <pipealloc+0xb8>

000000008000545e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000545e:	1101                	addi	sp,sp,-32
    80005460:	ec06                	sd	ra,24(sp)
    80005462:	e822                	sd	s0,16(sp)
    80005464:	e426                	sd	s1,8(sp)
    80005466:	e04a                	sd	s2,0(sp)
    80005468:	1000                	addi	s0,sp,32
    8000546a:	84aa                	mv	s1,a0
    8000546c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000546e:	c95fb0ef          	jal	80001102 <acquire>
  if(writable){
    80005472:	02090763          	beqz	s2,800054a0 <pipeclose+0x42>
    pi->writeopen = 0;
    80005476:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000547a:	21848513          	addi	a0,s1,536
    8000547e:	c56fd0ef          	jal	800028d4 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005482:	2204a783          	lw	a5,544(s1)
    80005486:	e781                	bnez	a5,8000548e <pipeclose+0x30>
    80005488:	2244a783          	lw	a5,548(s1)
    8000548c:	c38d                	beqz	a5,800054ae <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    8000548e:	8526                	mv	a0,s1
    80005490:	d07fb0ef          	jal	80001196 <release>
}
    80005494:	60e2                	ld	ra,24(sp)
    80005496:	6442                	ld	s0,16(sp)
    80005498:	64a2                	ld	s1,8(sp)
    8000549a:	6902                	ld	s2,0(sp)
    8000549c:	6105                	addi	sp,sp,32
    8000549e:	8082                	ret
    pi->readopen = 0;
    800054a0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800054a4:	21c48513          	addi	a0,s1,540
    800054a8:	c2cfd0ef          	jal	800028d4 <wakeup>
    800054ac:	bfd9                	j	80005482 <pipeclose+0x24>
    release(&pi->lock);
    800054ae:	8526                	mv	a0,s1
    800054b0:	ce7fb0ef          	jal	80001196 <release>
    kfree((char*)pi);
    800054b4:	8526                	mv	a0,s1
    800054b6:	da6fb0ef          	jal	80000a5c <kfree>
    800054ba:	bfe9                	j	80005494 <pipeclose+0x36>

00000000800054bc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800054bc:	7159                	addi	sp,sp,-112
    800054be:	f486                	sd	ra,104(sp)
    800054c0:	f0a2                	sd	s0,96(sp)
    800054c2:	eca6                	sd	s1,88(sp)
    800054c4:	e8ca                	sd	s2,80(sp)
    800054c6:	e4ce                	sd	s3,72(sp)
    800054c8:	e0d2                	sd	s4,64(sp)
    800054ca:	fc56                	sd	s5,56(sp)
    800054cc:	1880                	addi	s0,sp,112
    800054ce:	84aa                	mv	s1,a0
    800054d0:	8aae                	mv	s5,a1
    800054d2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800054d4:	b97fc0ef          	jal	8000206a <myproc>
    800054d8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800054da:	8526                	mv	a0,s1
    800054dc:	c27fb0ef          	jal	80001102 <acquire>
  while(i < n){
    800054e0:	0d405263          	blez	s4,800055a4 <pipewrite+0xe8>
    800054e4:	f85a                	sd	s6,48(sp)
    800054e6:	f45e                	sd	s7,40(sp)
    800054e8:	f062                	sd	s8,32(sp)
    800054ea:	ec66                	sd	s9,24(sp)
    800054ec:	e86a                	sd	s10,16(sp)
  int i = 0;
    800054ee:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800054f0:	f9f40c13          	addi	s8,s0,-97
    800054f4:	4b85                	li	s7,1
    800054f6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800054f8:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800054fc:	21c48c93          	addi	s9,s1,540
    80005500:	a82d                	j	8000553a <pipewrite+0x7e>
      release(&pi->lock);
    80005502:	8526                	mv	a0,s1
    80005504:	c93fb0ef          	jal	80001196 <release>
      return -1;
    80005508:	597d                	li	s2,-1
    8000550a:	7b42                	ld	s6,48(sp)
    8000550c:	7ba2                	ld	s7,40(sp)
    8000550e:	7c02                	ld	s8,32(sp)
    80005510:	6ce2                	ld	s9,24(sp)
    80005512:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005514:	854a                	mv	a0,s2
    80005516:	70a6                	ld	ra,104(sp)
    80005518:	7406                	ld	s0,96(sp)
    8000551a:	64e6                	ld	s1,88(sp)
    8000551c:	6946                	ld	s2,80(sp)
    8000551e:	69a6                	ld	s3,72(sp)
    80005520:	6a06                	ld	s4,64(sp)
    80005522:	7ae2                	ld	s5,56(sp)
    80005524:	6165                	addi	sp,sp,112
    80005526:	8082                	ret
      wakeup(&pi->nread);
    80005528:	856a                	mv	a0,s10
    8000552a:	baafd0ef          	jal	800028d4 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000552e:	85a6                	mv	a1,s1
    80005530:	8566                	mv	a0,s9
    80005532:	b56fd0ef          	jal	80002888 <sleep>
  while(i < n){
    80005536:	05495a63          	bge	s2,s4,8000558a <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    8000553a:	2204a783          	lw	a5,544(s1)
    8000553e:	d3f1                	beqz	a5,80005502 <pipewrite+0x46>
    80005540:	854e                	mv	a0,s3
    80005542:	d82fd0ef          	jal	80002ac4 <killed>
    80005546:	fd55                	bnez	a0,80005502 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005548:	2184a783          	lw	a5,536(s1)
    8000554c:	21c4a703          	lw	a4,540(s1)
    80005550:	2007879b          	addiw	a5,a5,512
    80005554:	fcf70ae3          	beq	a4,a5,80005528 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005558:	86de                	mv	a3,s7
    8000555a:	01590633          	add	a2,s2,s5
    8000555e:	85e2                	mv	a1,s8
    80005560:	0509b503          	ld	a0,80(s3)
    80005564:	8cffc0ef          	jal	80001e32 <copyin>
    80005568:	05650063          	beq	a0,s6,800055a8 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000556c:	21c4a783          	lw	a5,540(s1)
    80005570:	0017871b          	addiw	a4,a5,1
    80005574:	20e4ae23          	sw	a4,540(s1)
    80005578:	1ff7f793          	andi	a5,a5,511
    8000557c:	97a6                	add	a5,a5,s1
    8000557e:	f9f44703          	lbu	a4,-97(s0)
    80005582:	00e78c23          	sb	a4,24(a5)
      i++;
    80005586:	2905                	addiw	s2,s2,1
    80005588:	b77d                	j	80005536 <pipewrite+0x7a>
    8000558a:	7b42                	ld	s6,48(sp)
    8000558c:	7ba2                	ld	s7,40(sp)
    8000558e:	7c02                	ld	s8,32(sp)
    80005590:	6ce2                	ld	s9,24(sp)
    80005592:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80005594:	21848513          	addi	a0,s1,536
    80005598:	b3cfd0ef          	jal	800028d4 <wakeup>
  release(&pi->lock);
    8000559c:	8526                	mv	a0,s1
    8000559e:	bf9fb0ef          	jal	80001196 <release>
  return i;
    800055a2:	bf8d                	j	80005514 <pipewrite+0x58>
  int i = 0;
    800055a4:	4901                	li	s2,0
    800055a6:	b7fd                	j	80005594 <pipewrite+0xd8>
    800055a8:	7b42                	ld	s6,48(sp)
    800055aa:	7ba2                	ld	s7,40(sp)
    800055ac:	7c02                	ld	s8,32(sp)
    800055ae:	6ce2                	ld	s9,24(sp)
    800055b0:	6d42                	ld	s10,16(sp)
    800055b2:	b7cd                	j	80005594 <pipewrite+0xd8>

00000000800055b4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800055b4:	711d                	addi	sp,sp,-96
    800055b6:	ec86                	sd	ra,88(sp)
    800055b8:	e8a2                	sd	s0,80(sp)
    800055ba:	e4a6                	sd	s1,72(sp)
    800055bc:	e0ca                	sd	s2,64(sp)
    800055be:	fc4e                	sd	s3,56(sp)
    800055c0:	f852                	sd	s4,48(sp)
    800055c2:	f456                	sd	s5,40(sp)
    800055c4:	1080                	addi	s0,sp,96
    800055c6:	84aa                	mv	s1,a0
    800055c8:	892e                	mv	s2,a1
    800055ca:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800055cc:	a9ffc0ef          	jal	8000206a <myproc>
    800055d0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800055d2:	8526                	mv	a0,s1
    800055d4:	b2ffb0ef          	jal	80001102 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800055d8:	2184a703          	lw	a4,536(s1)
    800055dc:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800055e0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800055e4:	02f71763          	bne	a4,a5,80005612 <piperead+0x5e>
    800055e8:	2244a783          	lw	a5,548(s1)
    800055ec:	cf85                	beqz	a5,80005624 <piperead+0x70>
    if(killed(pr)){
    800055ee:	8552                	mv	a0,s4
    800055f0:	cd4fd0ef          	jal	80002ac4 <killed>
    800055f4:	e11d                	bnez	a0,8000561a <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800055f6:	85a6                	mv	a1,s1
    800055f8:	854e                	mv	a0,s3
    800055fa:	a8efd0ef          	jal	80002888 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800055fe:	2184a703          	lw	a4,536(s1)
    80005602:	21c4a783          	lw	a5,540(s1)
    80005606:	fef701e3          	beq	a4,a5,800055e8 <piperead+0x34>
    8000560a:	f05a                	sd	s6,32(sp)
    8000560c:	ec5e                	sd	s7,24(sp)
    8000560e:	e862                	sd	s8,16(sp)
    80005610:	a829                	j	8000562a <piperead+0x76>
    80005612:	f05a                	sd	s6,32(sp)
    80005614:	ec5e                	sd	s7,24(sp)
    80005616:	e862                	sd	s8,16(sp)
    80005618:	a809                	j	8000562a <piperead+0x76>
      release(&pi->lock);
    8000561a:	8526                	mv	a0,s1
    8000561c:	b7bfb0ef          	jal	80001196 <release>
      return -1;
    80005620:	59fd                	li	s3,-1
    80005622:	a0a5                	j	8000568a <piperead+0xd6>
    80005624:	f05a                	sd	s6,32(sp)
    80005626:	ec5e                	sd	s7,24(sp)
    80005628:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000562a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    8000562c:	faf40c13          	addi	s8,s0,-81
    80005630:	4b85                	li	s7,1
    80005632:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005634:	05505163          	blez	s5,80005676 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80005638:	2184a783          	lw	a5,536(s1)
    8000563c:	21c4a703          	lw	a4,540(s1)
    80005640:	02f70b63          	beq	a4,a5,80005676 <piperead+0xc2>
    ch = pi->data[pi->nread % PIPESIZE];
    80005644:	1ff7f793          	andi	a5,a5,511
    80005648:	97a6                	add	a5,a5,s1
    8000564a:	0187c783          	lbu	a5,24(a5)
    8000564e:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80005652:	86de                	mv	a3,s7
    80005654:	8662                	mv	a2,s8
    80005656:	85ca                	mv	a1,s2
    80005658:	050a3503          	ld	a0,80(s4)
    8000565c:	f18fc0ef          	jal	80001d74 <copyout>
    80005660:	03650f63          	beq	a0,s6,8000569e <piperead+0xea>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80005664:	2184a783          	lw	a5,536(s1)
    80005668:	2785                	addiw	a5,a5,1
    8000566a:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000566e:	2985                	addiw	s3,s3,1
    80005670:	0905                	addi	s2,s2,1
    80005672:	fd3a93e3          	bne	s5,s3,80005638 <piperead+0x84>
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005676:	21c48513          	addi	a0,s1,540
    8000567a:	a5afd0ef          	jal	800028d4 <wakeup>
  release(&pi->lock);
    8000567e:	8526                	mv	a0,s1
    80005680:	b17fb0ef          	jal	80001196 <release>
    80005684:	7b02                	ld	s6,32(sp)
    80005686:	6be2                	ld	s7,24(sp)
    80005688:	6c42                	ld	s8,16(sp)
  return i;
}
    8000568a:	854e                	mv	a0,s3
    8000568c:	60e6                	ld	ra,88(sp)
    8000568e:	6446                	ld	s0,80(sp)
    80005690:	64a6                	ld	s1,72(sp)
    80005692:	6906                	ld	s2,64(sp)
    80005694:	79e2                	ld	s3,56(sp)
    80005696:	7a42                	ld	s4,48(sp)
    80005698:	7aa2                	ld	s5,40(sp)
    8000569a:	6125                	addi	sp,sp,96
    8000569c:	8082                	ret
      if(i == 0)
    8000569e:	fc099ce3          	bnez	s3,80005676 <piperead+0xc2>
        i = -1;
    800056a2:	89aa                	mv	s3,a0
    800056a4:	bfc9                	j	80005676 <piperead+0xc2>

00000000800056a6 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    800056a6:	1141                	addi	sp,sp,-16
    800056a8:	e406                	sd	ra,8(sp)
    800056aa:	e022                	sd	s0,0(sp)
    800056ac:	0800                	addi	s0,sp,16
    800056ae:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800056b0:	0035151b          	slliw	a0,a0,0x3
    800056b4:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800056b6:	8b89                	andi	a5,a5,2
    800056b8:	c399                	beqz	a5,800056be <flags2perm+0x18>
      perm |= PTE_W;
    800056ba:	00456513          	ori	a0,a0,4
    return perm;
}
    800056be:	60a2                	ld	ra,8(sp)
    800056c0:	6402                	ld	s0,0(sp)
    800056c2:	0141                	addi	sp,sp,16
    800056c4:	8082                	ret

00000000800056c6 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800056c6:	de010113          	addi	sp,sp,-544
    800056ca:	20113c23          	sd	ra,536(sp)
    800056ce:	20813823          	sd	s0,528(sp)
    800056d2:	20913423          	sd	s1,520(sp)
    800056d6:	21213023          	sd	s2,512(sp)
    800056da:	1400                	addi	s0,sp,544
    800056dc:	892a                	mv	s2,a0
    800056de:	dea43823          	sd	a0,-528(s0)
    800056e2:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800056e6:	985fc0ef          	jal	8000206a <myproc>
    800056ea:	84aa                	mv	s1,a0

  begin_op();
    800056ec:	d6aff0ef          	jal	80004c56 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    800056f0:	854a                	mv	a0,s2
    800056f2:	b86ff0ef          	jal	80004a78 <namei>
    800056f6:	cd21                	beqz	a0,8000574e <kexec+0x88>
    800056f8:	fbd2                	sd	s4,496(sp)
    800056fa:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800056fc:	b4ffe0ef          	jal	8000424a <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005700:	04000713          	li	a4,64
    80005704:	4681                	li	a3,0
    80005706:	e5040613          	addi	a2,s0,-432
    8000570a:	4581                	li	a1,0
    8000570c:	8552                	mv	a0,s4
    8000570e:	ecffe0ef          	jal	800045dc <readi>
    80005712:	04000793          	li	a5,64
    80005716:	00f51a63          	bne	a0,a5,8000572a <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    8000571a:	e5042703          	lw	a4,-432(s0)
    8000571e:	464c47b7          	lui	a5,0x464c4
    80005722:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005726:	02f70863          	beq	a4,a5,80005756 <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000572a:	8552                	mv	a0,s4
    8000572c:	d2bfe0ef          	jal	80004456 <iunlockput>
    end_op();
    80005730:	d96ff0ef          	jal	80004cc6 <end_op>
  }
  return -1;
    80005734:	557d                	li	a0,-1
    80005736:	7a5e                	ld	s4,496(sp)
}
    80005738:	21813083          	ld	ra,536(sp)
    8000573c:	21013403          	ld	s0,528(sp)
    80005740:	20813483          	ld	s1,520(sp)
    80005744:	20013903          	ld	s2,512(sp)
    80005748:	22010113          	addi	sp,sp,544
    8000574c:	8082                	ret
    end_op();
    8000574e:	d78ff0ef          	jal	80004cc6 <end_op>
    return -1;
    80005752:	557d                	li	a0,-1
    80005754:	b7d5                	j	80005738 <kexec+0x72>
    80005756:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005758:	8526                	mv	a0,s1
    8000575a:	a1bfc0ef          	jal	80002174 <proc_pagetable>
    8000575e:	8b2a                	mv	s6,a0
    80005760:	26050f63          	beqz	a0,800059de <kexec+0x318>
    80005764:	ffce                	sd	s3,504(sp)
    80005766:	f7d6                	sd	s5,488(sp)
    80005768:	efde                	sd	s7,472(sp)
    8000576a:	ebe2                	sd	s8,464(sp)
    8000576c:	e7e6                	sd	s9,456(sp)
    8000576e:	e3ea                	sd	s10,448(sp)
    80005770:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005772:	e8845783          	lhu	a5,-376(s0)
    80005776:	0e078963          	beqz	a5,80005868 <kexec+0x1a2>
    8000577a:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000577e:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005780:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005782:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80005786:	6c85                	lui	s9,0x1
    80005788:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000578c:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005790:	6a85                	lui	s5,0x1
    80005792:	a085                	j	800057f2 <kexec+0x12c>
      panic("loadseg: address should exist");
    80005794:	00004517          	auipc	a0,0x4
    80005798:	e5450513          	addi	a0,a0,-428 # 800095e8 <etext+0x5e8>
    8000579c:	888fb0ef          	jal	80000824 <panic>
    if(sz - i < PGSIZE)
    800057a0:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800057a2:	874a                	mv	a4,s2
    800057a4:	009b86bb          	addw	a3,s7,s1
    800057a8:	4581                	li	a1,0
    800057aa:	8552                	mv	a0,s4
    800057ac:	e31fe0ef          	jal	800045dc <readi>
    800057b0:	22a91b63          	bne	s2,a0,800059e6 <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    800057b4:	009a84bb          	addw	s1,s5,s1
    800057b8:	0334f263          	bgeu	s1,s3,800057dc <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    800057bc:	02049593          	slli	a1,s1,0x20
    800057c0:	9181                	srli	a1,a1,0x20
    800057c2:	95e2                	add	a1,a1,s8
    800057c4:	855a                	mv	a0,s6
    800057c6:	d3ffb0ef          	jal	80001504 <walkaddr>
    800057ca:	862a                	mv	a2,a0
    if(pa == 0)
    800057cc:	d561                	beqz	a0,80005794 <kexec+0xce>
    if(sz - i < PGSIZE)
    800057ce:	409987bb          	subw	a5,s3,s1
    800057d2:	893e                	mv	s2,a5
    800057d4:	fcfcf6e3          	bgeu	s9,a5,800057a0 <kexec+0xda>
    800057d8:	8956                	mv	s2,s5
    800057da:	b7d9                	j	800057a0 <kexec+0xda>
    sz = sz1;
    800057dc:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800057e0:	2d05                	addiw	s10,s10,1
    800057e2:	e0843783          	ld	a5,-504(s0)
    800057e6:	0387869b          	addiw	a3,a5,56
    800057ea:	e8845783          	lhu	a5,-376(s0)
    800057ee:	06fd5e63          	bge	s10,a5,8000586a <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800057f2:	e0d43423          	sd	a3,-504(s0)
    800057f6:	876e                	mv	a4,s11
    800057f8:	e1840613          	addi	a2,s0,-488
    800057fc:	4581                	li	a1,0
    800057fe:	8552                	mv	a0,s4
    80005800:	dddfe0ef          	jal	800045dc <readi>
    80005804:	1db51f63          	bne	a0,s11,800059e2 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    80005808:	e1842783          	lw	a5,-488(s0)
    8000580c:	4705                	li	a4,1
    8000580e:	fce799e3          	bne	a5,a4,800057e0 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80005812:	e4043483          	ld	s1,-448(s0)
    80005816:	e3843783          	ld	a5,-456(s0)
    8000581a:	1ef4e463          	bltu	s1,a5,80005a02 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000581e:	e2843783          	ld	a5,-472(s0)
    80005822:	94be                	add	s1,s1,a5
    80005824:	1ef4e263          	bltu	s1,a5,80005a08 <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    80005828:	de843703          	ld	a4,-536(s0)
    8000582c:	8ff9                	and	a5,a5,a4
    8000582e:	1e079063          	bnez	a5,80005a0e <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005832:	e1c42503          	lw	a0,-484(s0)
    80005836:	e71ff0ef          	jal	800056a6 <flags2perm>
    8000583a:	86aa                	mv	a3,a0
    8000583c:	8626                	mv	a2,s1
    8000583e:	85ca                	mv	a1,s2
    80005840:	855a                	mv	a0,s6
    80005842:	87cfc0ef          	jal	800018be <uvmalloc>
    80005846:	dea43c23          	sd	a0,-520(s0)
    8000584a:	1c050563          	beqz	a0,80005a14 <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000584e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005852:	00098863          	beqz	s3,80005862 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005856:	e2843c03          	ld	s8,-472(s0)
    8000585a:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000585e:	4481                	li	s1,0
    80005860:	bfb1                	j	800057bc <kexec+0xf6>
    sz = sz1;
    80005862:	df843903          	ld	s2,-520(s0)
    80005866:	bfad                	j	800057e0 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005868:	4901                	li	s2,0
  iunlockput(ip);
    8000586a:	8552                	mv	a0,s4
    8000586c:	bebfe0ef          	jal	80004456 <iunlockput>
  end_op();
    80005870:	c56ff0ef          	jal	80004cc6 <end_op>
  p = myproc();
    80005874:	ff6fc0ef          	jal	8000206a <myproc>
    80005878:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000587a:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000587e:	6985                	lui	s3,0x1
    80005880:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005882:	99ca                	add	s3,s3,s2
    80005884:	77fd                	lui	a5,0xfffff
    80005886:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    8000588a:	4691                	li	a3,4
    8000588c:	6609                	lui	a2,0x2
    8000588e:	964e                	add	a2,a2,s3
    80005890:	85ce                	mv	a1,s3
    80005892:	855a                	mv	a0,s6
    80005894:	82afc0ef          	jal	800018be <uvmalloc>
    80005898:	8a2a                	mv	s4,a0
    8000589a:	e105                	bnez	a0,800058ba <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    8000589c:	85ce                	mv	a1,s3
    8000589e:	855a                	mv	a0,s6
    800058a0:	959fc0ef          	jal	800021f8 <proc_freepagetable>
  return -1;
    800058a4:	557d                	li	a0,-1
    800058a6:	79fe                	ld	s3,504(sp)
    800058a8:	7a5e                	ld	s4,496(sp)
    800058aa:	7abe                	ld	s5,488(sp)
    800058ac:	7b1e                	ld	s6,480(sp)
    800058ae:	6bfe                	ld	s7,472(sp)
    800058b0:	6c5e                	ld	s8,464(sp)
    800058b2:	6cbe                	ld	s9,456(sp)
    800058b4:	6d1e                	ld	s10,448(sp)
    800058b6:	7dfa                	ld	s11,440(sp)
    800058b8:	b541                	j	80005738 <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800058ba:	75f9                	lui	a1,0xffffe
    800058bc:	95aa                	add	a1,a1,a0
    800058be:	855a                	mv	a0,s6
    800058c0:	a50fc0ef          	jal	80001b10 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800058c4:	800a0b93          	addi	s7,s4,-2048
    800058c8:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    800058cc:	e0043783          	ld	a5,-512(s0)
    800058d0:	6388                	ld	a0,0(a5)
  sp = sz;
    800058d2:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800058d4:	4481                	li	s1,0
    ustack[argc] = sp;
    800058d6:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800058da:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800058de:	cd21                	beqz	a0,80005936 <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    800058e0:	a7dfb0ef          	jal	8000135c <strlen>
    800058e4:	0015079b          	addiw	a5,a0,1
    800058e8:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800058ec:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800058f0:	13796563          	bltu	s2,s7,80005a1a <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800058f4:	e0043d83          	ld	s11,-512(s0)
    800058f8:	000db983          	ld	s3,0(s11)
    800058fc:	854e                	mv	a0,s3
    800058fe:	a5ffb0ef          	jal	8000135c <strlen>
    80005902:	0015069b          	addiw	a3,a0,1
    80005906:	864e                	mv	a2,s3
    80005908:	85ca                	mv	a1,s2
    8000590a:	855a                	mv	a0,s6
    8000590c:	c68fc0ef          	jal	80001d74 <copyout>
    80005910:	10054763          	bltz	a0,80005a1e <kexec+0x358>
    ustack[argc] = sp;
    80005914:	00349793          	slli	a5,s1,0x3
    80005918:	97e6                	add	a5,a5,s9
    8000591a:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7fdd7c68>
  for(argc = 0; argv[argc]; argc++) {
    8000591e:	0485                	addi	s1,s1,1
    80005920:	008d8793          	addi	a5,s11,8
    80005924:	e0f43023          	sd	a5,-512(s0)
    80005928:	008db503          	ld	a0,8(s11)
    8000592c:	c509                	beqz	a0,80005936 <kexec+0x270>
    if(argc >= MAXARG)
    8000592e:	fb8499e3          	bne	s1,s8,800058e0 <kexec+0x21a>
  sz = sz1;
    80005932:	89d2                	mv	s3,s4
    80005934:	b7a5                	j	8000589c <kexec+0x1d6>
  ustack[argc] = 0;
    80005936:	00349793          	slli	a5,s1,0x3
    8000593a:	f9078793          	addi	a5,a5,-112
    8000593e:	97a2                	add	a5,a5,s0
    80005940:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005944:	00349693          	slli	a3,s1,0x3
    80005948:	06a1                	addi	a3,a3,8
    8000594a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000594e:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005952:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80005954:	f57964e3          	bltu	s2,s7,8000589c <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005958:	e9040613          	addi	a2,s0,-368
    8000595c:	85ca                	mv	a1,s2
    8000595e:	855a                	mv	a0,s6
    80005960:	c14fc0ef          	jal	80001d74 <copyout>
    80005964:	f2054ce3          	bltz	a0,8000589c <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80005968:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000596c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005970:	df043783          	ld	a5,-528(s0)
    80005974:	0007c703          	lbu	a4,0(a5)
    80005978:	cf11                	beqz	a4,80005994 <kexec+0x2ce>
    8000597a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000597c:	02f00693          	li	a3,47
    80005980:	a029                	j	8000598a <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80005982:	0785                	addi	a5,a5,1
    80005984:	fff7c703          	lbu	a4,-1(a5)
    80005988:	c711                	beqz	a4,80005994 <kexec+0x2ce>
    if(*s == '/')
    8000598a:	fed71ce3          	bne	a4,a3,80005982 <kexec+0x2bc>
      last = s+1;
    8000598e:	def43823          	sd	a5,-528(s0)
    80005992:	bfc5                	j	80005982 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80005994:	4641                	li	a2,16
    80005996:	df043583          	ld	a1,-528(s0)
    8000599a:	158a8513          	addi	a0,s5,344
    8000599e:	989fb0ef          	jal	80001326 <safestrcpy>
  oldpagetable = p->pagetable;
    800059a2:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800059a6:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800059aa:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    800059ae:	058ab783          	ld	a5,88(s5)
    800059b2:	e6843703          	ld	a4,-408(s0)
    800059b6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800059b8:	058ab783          	ld	a5,88(s5)
    800059bc:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800059c0:	85ea                	mv	a1,s10
    800059c2:	837fc0ef          	jal	800021f8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800059c6:	0004851b          	sext.w	a0,s1
    800059ca:	79fe                	ld	s3,504(sp)
    800059cc:	7a5e                	ld	s4,496(sp)
    800059ce:	7abe                	ld	s5,488(sp)
    800059d0:	7b1e                	ld	s6,480(sp)
    800059d2:	6bfe                	ld	s7,472(sp)
    800059d4:	6c5e                	ld	s8,464(sp)
    800059d6:	6cbe                	ld	s9,456(sp)
    800059d8:	6d1e                	ld	s10,448(sp)
    800059da:	7dfa                	ld	s11,440(sp)
    800059dc:	bbb1                	j	80005738 <kexec+0x72>
    800059de:	7b1e                	ld	s6,480(sp)
    800059e0:	b3a9                	j	8000572a <kexec+0x64>
    800059e2:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800059e6:	df843583          	ld	a1,-520(s0)
    800059ea:	855a                	mv	a0,s6
    800059ec:	80dfc0ef          	jal	800021f8 <proc_freepagetable>
  if(ip){
    800059f0:	79fe                	ld	s3,504(sp)
    800059f2:	7abe                	ld	s5,488(sp)
    800059f4:	7b1e                	ld	s6,480(sp)
    800059f6:	6bfe                	ld	s7,472(sp)
    800059f8:	6c5e                	ld	s8,464(sp)
    800059fa:	6cbe                	ld	s9,456(sp)
    800059fc:	6d1e                	ld	s10,448(sp)
    800059fe:	7dfa                	ld	s11,440(sp)
    80005a00:	b32d                	j	8000572a <kexec+0x64>
    80005a02:	df243c23          	sd	s2,-520(s0)
    80005a06:	b7c5                	j	800059e6 <kexec+0x320>
    80005a08:	df243c23          	sd	s2,-520(s0)
    80005a0c:	bfe9                	j	800059e6 <kexec+0x320>
    80005a0e:	df243c23          	sd	s2,-520(s0)
    80005a12:	bfd1                	j	800059e6 <kexec+0x320>
    80005a14:	df243c23          	sd	s2,-520(s0)
    80005a18:	b7f9                	j	800059e6 <kexec+0x320>
  sz = sz1;
    80005a1a:	89d2                	mv	s3,s4
    80005a1c:	b541                	j	8000589c <kexec+0x1d6>
    80005a1e:	89d2                	mv	s3,s4
    80005a20:	bdb5                	j	8000589c <kexec+0x1d6>

0000000080005a22 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005a22:	7179                	addi	sp,sp,-48
    80005a24:	f406                	sd	ra,40(sp)
    80005a26:	f022                	sd	s0,32(sp)
    80005a28:	ec26                	sd	s1,24(sp)
    80005a2a:	e84a                	sd	s2,16(sp)
    80005a2c:	1800                	addi	s0,sp,48
    80005a2e:	892e                	mv	s2,a1
    80005a30:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005a32:	fdc40593          	addi	a1,s0,-36
    80005a36:	931fd0ef          	jal	80003366 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005a3a:	fdc42703          	lw	a4,-36(s0)
    80005a3e:	47bd                	li	a5,15
    80005a40:	02e7ea63          	bltu	a5,a4,80005a74 <argfd+0x52>
    80005a44:	e26fc0ef          	jal	8000206a <myproc>
    80005a48:	fdc42703          	lw	a4,-36(s0)
    80005a4c:	00371793          	slli	a5,a4,0x3
    80005a50:	0d078793          	addi	a5,a5,208
    80005a54:	953e                	add	a0,a0,a5
    80005a56:	611c                	ld	a5,0(a0)
    80005a58:	c385                	beqz	a5,80005a78 <argfd+0x56>
    return -1;
  if(pfd)
    80005a5a:	00090463          	beqz	s2,80005a62 <argfd+0x40>
    *pfd = fd;
    80005a5e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005a62:	4501                	li	a0,0
  if(pf)
    80005a64:	c091                	beqz	s1,80005a68 <argfd+0x46>
    *pf = f;
    80005a66:	e09c                	sd	a5,0(s1)
}
    80005a68:	70a2                	ld	ra,40(sp)
    80005a6a:	7402                	ld	s0,32(sp)
    80005a6c:	64e2                	ld	s1,24(sp)
    80005a6e:	6942                	ld	s2,16(sp)
    80005a70:	6145                	addi	sp,sp,48
    80005a72:	8082                	ret
    return -1;
    80005a74:	557d                	li	a0,-1
    80005a76:	bfcd                	j	80005a68 <argfd+0x46>
    80005a78:	557d                	li	a0,-1
    80005a7a:	b7fd                	j	80005a68 <argfd+0x46>

0000000080005a7c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005a7c:	1101                	addi	sp,sp,-32
    80005a7e:	ec06                	sd	ra,24(sp)
    80005a80:	e822                	sd	s0,16(sp)
    80005a82:	e426                	sd	s1,8(sp)
    80005a84:	1000                	addi	s0,sp,32
    80005a86:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005a88:	de2fc0ef          	jal	8000206a <myproc>
    80005a8c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005a8e:	0d050793          	addi	a5,a0,208
    80005a92:	4501                	li	a0,0
    80005a94:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005a96:	6398                	ld	a4,0(a5)
    80005a98:	cb19                	beqz	a4,80005aae <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80005a9a:	2505                	addiw	a0,a0,1
    80005a9c:	07a1                	addi	a5,a5,8
    80005a9e:	fed51ce3          	bne	a0,a3,80005a96 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005aa2:	557d                	li	a0,-1
}
    80005aa4:	60e2                	ld	ra,24(sp)
    80005aa6:	6442                	ld	s0,16(sp)
    80005aa8:	64a2                	ld	s1,8(sp)
    80005aaa:	6105                	addi	sp,sp,32
    80005aac:	8082                	ret
      p->ofile[fd] = f;
    80005aae:	00351793          	slli	a5,a0,0x3
    80005ab2:	0d078793          	addi	a5,a5,208
    80005ab6:	963e                	add	a2,a2,a5
    80005ab8:	e204                	sd	s1,0(a2)
      return fd;
    80005aba:	b7ed                	j	80005aa4 <fdalloc+0x28>

0000000080005abc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005abc:	715d                	addi	sp,sp,-80
    80005abe:	e486                	sd	ra,72(sp)
    80005ac0:	e0a2                	sd	s0,64(sp)
    80005ac2:	fc26                	sd	s1,56(sp)
    80005ac4:	f84a                	sd	s2,48(sp)
    80005ac6:	f44e                	sd	s3,40(sp)
    80005ac8:	f052                	sd	s4,32(sp)
    80005aca:	ec56                	sd	s5,24(sp)
    80005acc:	e85a                	sd	s6,16(sp)
    80005ace:	0880                	addi	s0,sp,80
    80005ad0:	892e                	mv	s2,a1
    80005ad2:	8a2e                	mv	s4,a1
    80005ad4:	8ab2                	mv	s5,a2
    80005ad6:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005ad8:	fb040593          	addi	a1,s0,-80
    80005adc:	fb7fe0ef          	jal	80004a92 <nameiparent>
    80005ae0:	84aa                	mv	s1,a0
    80005ae2:	10050763          	beqz	a0,80005bf0 <create+0x134>
    return 0;

  ilock(dp);
    80005ae6:	f64fe0ef          	jal	8000424a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005aea:	4601                	li	a2,0
    80005aec:	fb040593          	addi	a1,s0,-80
    80005af0:	8526                	mv	a0,s1
    80005af2:	cf3fe0ef          	jal	800047e4 <dirlookup>
    80005af6:	89aa                	mv	s3,a0
    80005af8:	c131                	beqz	a0,80005b3c <create+0x80>
    iunlockput(dp);
    80005afa:	8526                	mv	a0,s1
    80005afc:	95bfe0ef          	jal	80004456 <iunlockput>
    ilock(ip);
    80005b00:	854e                	mv	a0,s3
    80005b02:	f48fe0ef          	jal	8000424a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005b06:	4789                	li	a5,2
    80005b08:	02f91563          	bne	s2,a5,80005b32 <create+0x76>
    80005b0c:	0449d783          	lhu	a5,68(s3)
    80005b10:	37f9                	addiw	a5,a5,-2
    80005b12:	17c2                	slli	a5,a5,0x30
    80005b14:	93c1                	srli	a5,a5,0x30
    80005b16:	4705                	li	a4,1
    80005b18:	00f76d63          	bltu	a4,a5,80005b32 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005b1c:	854e                	mv	a0,s3
    80005b1e:	60a6                	ld	ra,72(sp)
    80005b20:	6406                	ld	s0,64(sp)
    80005b22:	74e2                	ld	s1,56(sp)
    80005b24:	7942                	ld	s2,48(sp)
    80005b26:	79a2                	ld	s3,40(sp)
    80005b28:	7a02                	ld	s4,32(sp)
    80005b2a:	6ae2                	ld	s5,24(sp)
    80005b2c:	6b42                	ld	s6,16(sp)
    80005b2e:	6161                	addi	sp,sp,80
    80005b30:	8082                	ret
    iunlockput(ip);
    80005b32:	854e                	mv	a0,s3
    80005b34:	923fe0ef          	jal	80004456 <iunlockput>
    return 0;
    80005b38:	4981                	li	s3,0
    80005b3a:	b7cd                	j	80005b1c <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005b3c:	85ca                	mv	a1,s2
    80005b3e:	4088                	lw	a0,0(s1)
    80005b40:	d9afe0ef          	jal	800040da <ialloc>
    80005b44:	892a                	mv	s2,a0
    80005b46:	cd15                	beqz	a0,80005b82 <create+0xc6>
  ilock(ip);
    80005b48:	f02fe0ef          	jal	8000424a <ilock>
  ip->major = major;
    80005b4c:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80005b50:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80005b54:	4785                	li	a5,1
    80005b56:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005b5a:	854a                	mv	a0,s2
    80005b5c:	e3afe0ef          	jal	80004196 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005b60:	4705                	li	a4,1
    80005b62:	02ea0463          	beq	s4,a4,80005b8a <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80005b66:	00492603          	lw	a2,4(s2)
    80005b6a:	fb040593          	addi	a1,s0,-80
    80005b6e:	8526                	mv	a0,s1
    80005b70:	e5ffe0ef          	jal	800049ce <dirlink>
    80005b74:	06054263          	bltz	a0,80005bd8 <create+0x11c>
  iunlockput(dp);
    80005b78:	8526                	mv	a0,s1
    80005b7a:	8ddfe0ef          	jal	80004456 <iunlockput>
  return ip;
    80005b7e:	89ca                	mv	s3,s2
    80005b80:	bf71                	j	80005b1c <create+0x60>
    iunlockput(dp);
    80005b82:	8526                	mv	a0,s1
    80005b84:	8d3fe0ef          	jal	80004456 <iunlockput>
    return 0;
    80005b88:	bf51                	j	80005b1c <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005b8a:	00492603          	lw	a2,4(s2)
    80005b8e:	00004597          	auipc	a1,0x4
    80005b92:	a7a58593          	addi	a1,a1,-1414 # 80009608 <etext+0x608>
    80005b96:	854a                	mv	a0,s2
    80005b98:	e37fe0ef          	jal	800049ce <dirlink>
    80005b9c:	02054e63          	bltz	a0,80005bd8 <create+0x11c>
    80005ba0:	40d0                	lw	a2,4(s1)
    80005ba2:	00004597          	auipc	a1,0x4
    80005ba6:	a6e58593          	addi	a1,a1,-1426 # 80009610 <etext+0x610>
    80005baa:	854a                	mv	a0,s2
    80005bac:	e23fe0ef          	jal	800049ce <dirlink>
    80005bb0:	02054463          	bltz	a0,80005bd8 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005bb4:	00492603          	lw	a2,4(s2)
    80005bb8:	fb040593          	addi	a1,s0,-80
    80005bbc:	8526                	mv	a0,s1
    80005bbe:	e11fe0ef          	jal	800049ce <dirlink>
    80005bc2:	00054b63          	bltz	a0,80005bd8 <create+0x11c>
    dp->nlink++;  // for ".."
    80005bc6:	04a4d783          	lhu	a5,74(s1)
    80005bca:	2785                	addiw	a5,a5,1
    80005bcc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005bd0:	8526                	mv	a0,s1
    80005bd2:	dc4fe0ef          	jal	80004196 <iupdate>
    80005bd6:	b74d                	j	80005b78 <create+0xbc>
  ip->nlink = 0;
    80005bd8:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80005bdc:	854a                	mv	a0,s2
    80005bde:	db8fe0ef          	jal	80004196 <iupdate>
  iunlockput(ip);
    80005be2:	854a                	mv	a0,s2
    80005be4:	873fe0ef          	jal	80004456 <iunlockput>
  iunlockput(dp);
    80005be8:	8526                	mv	a0,s1
    80005bea:	86dfe0ef          	jal	80004456 <iunlockput>
  return 0;
    80005bee:	b73d                	j	80005b1c <create+0x60>
    return 0;
    80005bf0:	89aa                	mv	s3,a0
    80005bf2:	b72d                	j	80005b1c <create+0x60>

0000000080005bf4 <sys_dup>:
{
    80005bf4:	7179                	addi	sp,sp,-48
    80005bf6:	f406                	sd	ra,40(sp)
    80005bf8:	f022                	sd	s0,32(sp)
    80005bfa:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005bfc:	fd840613          	addi	a2,s0,-40
    80005c00:	4581                	li	a1,0
    80005c02:	4501                	li	a0,0
    80005c04:	e1fff0ef          	jal	80005a22 <argfd>
    return -1;
    80005c08:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005c0a:	02054363          	bltz	a0,80005c30 <sys_dup+0x3c>
    80005c0e:	ec26                	sd	s1,24(sp)
    80005c10:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005c12:	fd843483          	ld	s1,-40(s0)
    80005c16:	8526                	mv	a0,s1
    80005c18:	e65ff0ef          	jal	80005a7c <fdalloc>
    80005c1c:	892a                	mv	s2,a0
    return -1;
    80005c1e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005c20:	00054d63          	bltz	a0,80005c3a <sys_dup+0x46>
  filedup(f);
    80005c24:	8526                	mv	a0,s1
    80005c26:	c0eff0ef          	jal	80005034 <filedup>
  return fd;
    80005c2a:	87ca                	mv	a5,s2
    80005c2c:	64e2                	ld	s1,24(sp)
    80005c2e:	6942                	ld	s2,16(sp)
}
    80005c30:	853e                	mv	a0,a5
    80005c32:	70a2                	ld	ra,40(sp)
    80005c34:	7402                	ld	s0,32(sp)
    80005c36:	6145                	addi	sp,sp,48
    80005c38:	8082                	ret
    80005c3a:	64e2                	ld	s1,24(sp)
    80005c3c:	6942                	ld	s2,16(sp)
    80005c3e:	bfcd                	j	80005c30 <sys_dup+0x3c>

0000000080005c40 <sys_read>:
{
    80005c40:	7179                	addi	sp,sp,-48
    80005c42:	f406                	sd	ra,40(sp)
    80005c44:	f022                	sd	s0,32(sp)
    80005c46:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005c48:	fd840593          	addi	a1,s0,-40
    80005c4c:	4505                	li	a0,1
    80005c4e:	f34fd0ef          	jal	80003382 <argaddr>
  argint(2, &n);
    80005c52:	fe440593          	addi	a1,s0,-28
    80005c56:	4509                	li	a0,2
    80005c58:	f0efd0ef          	jal	80003366 <argint>
  if(argfd(0, 0, &f) < 0)
    80005c5c:	fe840613          	addi	a2,s0,-24
    80005c60:	4581                	li	a1,0
    80005c62:	4501                	li	a0,0
    80005c64:	dbfff0ef          	jal	80005a22 <argfd>
    80005c68:	87aa                	mv	a5,a0
    return -1;
    80005c6a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005c6c:	0007ca63          	bltz	a5,80005c80 <sys_read+0x40>
  return fileread(f, p, n);
    80005c70:	fe442603          	lw	a2,-28(s0)
    80005c74:	fd843583          	ld	a1,-40(s0)
    80005c78:	fe843503          	ld	a0,-24(s0)
    80005c7c:	d22ff0ef          	jal	8000519e <fileread>
}
    80005c80:	70a2                	ld	ra,40(sp)
    80005c82:	7402                	ld	s0,32(sp)
    80005c84:	6145                	addi	sp,sp,48
    80005c86:	8082                	ret

0000000080005c88 <sys_write>:
{
    80005c88:	7179                	addi	sp,sp,-48
    80005c8a:	f406                	sd	ra,40(sp)
    80005c8c:	f022                	sd	s0,32(sp)
    80005c8e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005c90:	fd840593          	addi	a1,s0,-40
    80005c94:	4505                	li	a0,1
    80005c96:	eecfd0ef          	jal	80003382 <argaddr>
  argint(2, &n);
    80005c9a:	fe440593          	addi	a1,s0,-28
    80005c9e:	4509                	li	a0,2
    80005ca0:	ec6fd0ef          	jal	80003366 <argint>
  if(argfd(0, 0, &f) < 0)
    80005ca4:	fe840613          	addi	a2,s0,-24
    80005ca8:	4581                	li	a1,0
    80005caa:	4501                	li	a0,0
    80005cac:	d77ff0ef          	jal	80005a22 <argfd>
    80005cb0:	87aa                	mv	a5,a0
    return -1;
    80005cb2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005cb4:	0007ca63          	bltz	a5,80005cc8 <sys_write+0x40>
  return filewrite(f, p, n);
    80005cb8:	fe442603          	lw	a2,-28(s0)
    80005cbc:	fd843583          	ld	a1,-40(s0)
    80005cc0:	fe843503          	ld	a0,-24(s0)
    80005cc4:	d9eff0ef          	jal	80005262 <filewrite>
}
    80005cc8:	70a2                	ld	ra,40(sp)
    80005cca:	7402                	ld	s0,32(sp)
    80005ccc:	6145                	addi	sp,sp,48
    80005cce:	8082                	ret

0000000080005cd0 <sys_close>:
{
    80005cd0:	1101                	addi	sp,sp,-32
    80005cd2:	ec06                	sd	ra,24(sp)
    80005cd4:	e822                	sd	s0,16(sp)
    80005cd6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005cd8:	fe040613          	addi	a2,s0,-32
    80005cdc:	fec40593          	addi	a1,s0,-20
    80005ce0:	4501                	li	a0,0
    80005ce2:	d41ff0ef          	jal	80005a22 <argfd>
    return -1;
    80005ce6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005ce8:	02054163          	bltz	a0,80005d0a <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80005cec:	b7efc0ef          	jal	8000206a <myproc>
    80005cf0:	fec42783          	lw	a5,-20(s0)
    80005cf4:	078e                	slli	a5,a5,0x3
    80005cf6:	0d078793          	addi	a5,a5,208
    80005cfa:	953e                	add	a0,a0,a5
    80005cfc:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005d00:	fe043503          	ld	a0,-32(s0)
    80005d04:	b76ff0ef          	jal	8000507a <fileclose>
  return 0;
    80005d08:	4781                	li	a5,0
}
    80005d0a:	853e                	mv	a0,a5
    80005d0c:	60e2                	ld	ra,24(sp)
    80005d0e:	6442                	ld	s0,16(sp)
    80005d10:	6105                	addi	sp,sp,32
    80005d12:	8082                	ret

0000000080005d14 <sys_fstat>:
{
    80005d14:	1101                	addi	sp,sp,-32
    80005d16:	ec06                	sd	ra,24(sp)
    80005d18:	e822                	sd	s0,16(sp)
    80005d1a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005d1c:	fe040593          	addi	a1,s0,-32
    80005d20:	4505                	li	a0,1
    80005d22:	e60fd0ef          	jal	80003382 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005d26:	fe840613          	addi	a2,s0,-24
    80005d2a:	4581                	li	a1,0
    80005d2c:	4501                	li	a0,0
    80005d2e:	cf5ff0ef          	jal	80005a22 <argfd>
    80005d32:	87aa                	mv	a5,a0
    return -1;
    80005d34:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005d36:	0007c863          	bltz	a5,80005d46 <sys_fstat+0x32>
  return filestat(f, st);
    80005d3a:	fe043583          	ld	a1,-32(s0)
    80005d3e:	fe843503          	ld	a0,-24(s0)
    80005d42:	bfaff0ef          	jal	8000513c <filestat>
}
    80005d46:	60e2                	ld	ra,24(sp)
    80005d48:	6442                	ld	s0,16(sp)
    80005d4a:	6105                	addi	sp,sp,32
    80005d4c:	8082                	ret

0000000080005d4e <sys_link>:
{
    80005d4e:	7169                	addi	sp,sp,-304
    80005d50:	f606                	sd	ra,296(sp)
    80005d52:	f222                	sd	s0,288(sp)
    80005d54:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005d56:	08000613          	li	a2,128
    80005d5a:	ed040593          	addi	a1,s0,-304
    80005d5e:	4501                	li	a0,0
    80005d60:	e3efd0ef          	jal	8000339e <argstr>
    return -1;
    80005d64:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005d66:	0c054e63          	bltz	a0,80005e42 <sys_link+0xf4>
    80005d6a:	08000613          	li	a2,128
    80005d6e:	f5040593          	addi	a1,s0,-176
    80005d72:	4505                	li	a0,1
    80005d74:	e2afd0ef          	jal	8000339e <argstr>
    return -1;
    80005d78:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005d7a:	0c054463          	bltz	a0,80005e42 <sys_link+0xf4>
    80005d7e:	ee26                	sd	s1,280(sp)
  begin_op();
    80005d80:	ed7fe0ef          	jal	80004c56 <begin_op>
  if((ip = namei(old)) == 0){
    80005d84:	ed040513          	addi	a0,s0,-304
    80005d88:	cf1fe0ef          	jal	80004a78 <namei>
    80005d8c:	84aa                	mv	s1,a0
    80005d8e:	c53d                	beqz	a0,80005dfc <sys_link+0xae>
  ilock(ip);
    80005d90:	cbafe0ef          	jal	8000424a <ilock>
  if(ip->type == T_DIR){
    80005d94:	04449703          	lh	a4,68(s1)
    80005d98:	4785                	li	a5,1
    80005d9a:	06f70663          	beq	a4,a5,80005e06 <sys_link+0xb8>
    80005d9e:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005da0:	04a4d783          	lhu	a5,74(s1)
    80005da4:	2785                	addiw	a5,a5,1
    80005da6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005daa:	8526                	mv	a0,s1
    80005dac:	beafe0ef          	jal	80004196 <iupdate>
  iunlock(ip);
    80005db0:	8526                	mv	a0,s1
    80005db2:	d46fe0ef          	jal	800042f8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005db6:	fd040593          	addi	a1,s0,-48
    80005dba:	f5040513          	addi	a0,s0,-176
    80005dbe:	cd5fe0ef          	jal	80004a92 <nameiparent>
    80005dc2:	892a                	mv	s2,a0
    80005dc4:	cd21                	beqz	a0,80005e1c <sys_link+0xce>
  ilock(dp);
    80005dc6:	c84fe0ef          	jal	8000424a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005dca:	854a                	mv	a0,s2
    80005dcc:	00092703          	lw	a4,0(s2)
    80005dd0:	409c                	lw	a5,0(s1)
    80005dd2:	04f71263          	bne	a4,a5,80005e16 <sys_link+0xc8>
    80005dd6:	40d0                	lw	a2,4(s1)
    80005dd8:	fd040593          	addi	a1,s0,-48
    80005ddc:	bf3fe0ef          	jal	800049ce <dirlink>
    80005de0:	02054b63          	bltz	a0,80005e16 <sys_link+0xc8>
  iunlockput(dp);
    80005de4:	854a                	mv	a0,s2
    80005de6:	e70fe0ef          	jal	80004456 <iunlockput>
  iput(ip);
    80005dea:	8526                	mv	a0,s1
    80005dec:	de0fe0ef          	jal	800043cc <iput>
  end_op();
    80005df0:	ed7fe0ef          	jal	80004cc6 <end_op>
  return 0;
    80005df4:	4781                	li	a5,0
    80005df6:	64f2                	ld	s1,280(sp)
    80005df8:	6952                	ld	s2,272(sp)
    80005dfa:	a0a1                	j	80005e42 <sys_link+0xf4>
    end_op();
    80005dfc:	ecbfe0ef          	jal	80004cc6 <end_op>
    return -1;
    80005e00:	57fd                	li	a5,-1
    80005e02:	64f2                	ld	s1,280(sp)
    80005e04:	a83d                	j	80005e42 <sys_link+0xf4>
    iunlockput(ip);
    80005e06:	8526                	mv	a0,s1
    80005e08:	e4efe0ef          	jal	80004456 <iunlockput>
    end_op();
    80005e0c:	ebbfe0ef          	jal	80004cc6 <end_op>
    return -1;
    80005e10:	57fd                	li	a5,-1
    80005e12:	64f2                	ld	s1,280(sp)
    80005e14:	a03d                	j	80005e42 <sys_link+0xf4>
    iunlockput(dp);
    80005e16:	854a                	mv	a0,s2
    80005e18:	e3efe0ef          	jal	80004456 <iunlockput>
  ilock(ip);
    80005e1c:	8526                	mv	a0,s1
    80005e1e:	c2cfe0ef          	jal	8000424a <ilock>
  ip->nlink--;
    80005e22:	04a4d783          	lhu	a5,74(s1)
    80005e26:	37fd                	addiw	a5,a5,-1
    80005e28:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005e2c:	8526                	mv	a0,s1
    80005e2e:	b68fe0ef          	jal	80004196 <iupdate>
  iunlockput(ip);
    80005e32:	8526                	mv	a0,s1
    80005e34:	e22fe0ef          	jal	80004456 <iunlockput>
  end_op();
    80005e38:	e8ffe0ef          	jal	80004cc6 <end_op>
  return -1;
    80005e3c:	57fd                	li	a5,-1
    80005e3e:	64f2                	ld	s1,280(sp)
    80005e40:	6952                	ld	s2,272(sp)
}
    80005e42:	853e                	mv	a0,a5
    80005e44:	70b2                	ld	ra,296(sp)
    80005e46:	7412                	ld	s0,288(sp)
    80005e48:	6155                	addi	sp,sp,304
    80005e4a:	8082                	ret

0000000080005e4c <sys_unlink>:
{
    80005e4c:	7151                	addi	sp,sp,-240
    80005e4e:	f586                	sd	ra,232(sp)
    80005e50:	f1a2                	sd	s0,224(sp)
    80005e52:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005e54:	08000613          	li	a2,128
    80005e58:	f3040593          	addi	a1,s0,-208
    80005e5c:	4501                	li	a0,0
    80005e5e:	d40fd0ef          	jal	8000339e <argstr>
    80005e62:	14054d63          	bltz	a0,80005fbc <sys_unlink+0x170>
    80005e66:	eda6                	sd	s1,216(sp)
  begin_op();
    80005e68:	deffe0ef          	jal	80004c56 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005e6c:	fb040593          	addi	a1,s0,-80
    80005e70:	f3040513          	addi	a0,s0,-208
    80005e74:	c1ffe0ef          	jal	80004a92 <nameiparent>
    80005e78:	84aa                	mv	s1,a0
    80005e7a:	c955                	beqz	a0,80005f2e <sys_unlink+0xe2>
  ilock(dp);
    80005e7c:	bcefe0ef          	jal	8000424a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005e80:	00003597          	auipc	a1,0x3
    80005e84:	78858593          	addi	a1,a1,1928 # 80009608 <etext+0x608>
    80005e88:	fb040513          	addi	a0,s0,-80
    80005e8c:	943fe0ef          	jal	800047ce <namecmp>
    80005e90:	10050b63          	beqz	a0,80005fa6 <sys_unlink+0x15a>
    80005e94:	00003597          	auipc	a1,0x3
    80005e98:	77c58593          	addi	a1,a1,1916 # 80009610 <etext+0x610>
    80005e9c:	fb040513          	addi	a0,s0,-80
    80005ea0:	92ffe0ef          	jal	800047ce <namecmp>
    80005ea4:	10050163          	beqz	a0,80005fa6 <sys_unlink+0x15a>
    80005ea8:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005eaa:	f2c40613          	addi	a2,s0,-212
    80005eae:	fb040593          	addi	a1,s0,-80
    80005eb2:	8526                	mv	a0,s1
    80005eb4:	931fe0ef          	jal	800047e4 <dirlookup>
    80005eb8:	892a                	mv	s2,a0
    80005eba:	0e050563          	beqz	a0,80005fa4 <sys_unlink+0x158>
    80005ebe:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80005ec0:	b8afe0ef          	jal	8000424a <ilock>
  if(ip->nlink < 1)
    80005ec4:	04a91783          	lh	a5,74(s2)
    80005ec8:	06f05863          	blez	a5,80005f38 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005ecc:	04491703          	lh	a4,68(s2)
    80005ed0:	4785                	li	a5,1
    80005ed2:	06f70963          	beq	a4,a5,80005f44 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    80005ed6:	fc040993          	addi	s3,s0,-64
    80005eda:	4641                	li	a2,16
    80005edc:	4581                	li	a1,0
    80005ede:	854e                	mv	a0,s3
    80005ee0:	af2fb0ef          	jal	800011d2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ee4:	4741                	li	a4,16
    80005ee6:	f2c42683          	lw	a3,-212(s0)
    80005eea:	864e                	mv	a2,s3
    80005eec:	4581                	li	a1,0
    80005eee:	8526                	mv	a0,s1
    80005ef0:	fdefe0ef          	jal	800046ce <writei>
    80005ef4:	47c1                	li	a5,16
    80005ef6:	08f51863          	bne	a0,a5,80005f86 <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    80005efa:	04491703          	lh	a4,68(s2)
    80005efe:	4785                	li	a5,1
    80005f00:	08f70963          	beq	a4,a5,80005f92 <sys_unlink+0x146>
  iunlockput(dp);
    80005f04:	8526                	mv	a0,s1
    80005f06:	d50fe0ef          	jal	80004456 <iunlockput>
  ip->nlink--;
    80005f0a:	04a95783          	lhu	a5,74(s2)
    80005f0e:	37fd                	addiw	a5,a5,-1
    80005f10:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005f14:	854a                	mv	a0,s2
    80005f16:	a80fe0ef          	jal	80004196 <iupdate>
  iunlockput(ip);
    80005f1a:	854a                	mv	a0,s2
    80005f1c:	d3afe0ef          	jal	80004456 <iunlockput>
  end_op();
    80005f20:	da7fe0ef          	jal	80004cc6 <end_op>
  return 0;
    80005f24:	4501                	li	a0,0
    80005f26:	64ee                	ld	s1,216(sp)
    80005f28:	694e                	ld	s2,208(sp)
    80005f2a:	69ae                	ld	s3,200(sp)
    80005f2c:	a061                	j	80005fb4 <sys_unlink+0x168>
    end_op();
    80005f2e:	d99fe0ef          	jal	80004cc6 <end_op>
    return -1;
    80005f32:	557d                	li	a0,-1
    80005f34:	64ee                	ld	s1,216(sp)
    80005f36:	a8bd                	j	80005fb4 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80005f38:	00003517          	auipc	a0,0x3
    80005f3c:	6e050513          	addi	a0,a0,1760 # 80009618 <etext+0x618>
    80005f40:	8e5fa0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005f44:	04c92703          	lw	a4,76(s2)
    80005f48:	02000793          	li	a5,32
    80005f4c:	f8e7f5e3          	bgeu	a5,a4,80005ed6 <sys_unlink+0x8a>
    80005f50:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005f52:	4741                	li	a4,16
    80005f54:	86ce                	mv	a3,s3
    80005f56:	f1840613          	addi	a2,s0,-232
    80005f5a:	4581                	li	a1,0
    80005f5c:	854a                	mv	a0,s2
    80005f5e:	e7efe0ef          	jal	800045dc <readi>
    80005f62:	47c1                	li	a5,16
    80005f64:	00f51b63          	bne	a0,a5,80005f7a <sys_unlink+0x12e>
    if(de.inum != 0)
    80005f68:	f1845783          	lhu	a5,-232(s0)
    80005f6c:	ebb1                	bnez	a5,80005fc0 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005f6e:	29c1                	addiw	s3,s3,16
    80005f70:	04c92783          	lw	a5,76(s2)
    80005f74:	fcf9efe3          	bltu	s3,a5,80005f52 <sys_unlink+0x106>
    80005f78:	bfb9                	j	80005ed6 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005f7a:	00003517          	auipc	a0,0x3
    80005f7e:	6b650513          	addi	a0,a0,1718 # 80009630 <etext+0x630>
    80005f82:	8a3fa0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    80005f86:	00003517          	auipc	a0,0x3
    80005f8a:	6c250513          	addi	a0,a0,1730 # 80009648 <etext+0x648>
    80005f8e:	897fa0ef          	jal	80000824 <panic>
    dp->nlink--;
    80005f92:	04a4d783          	lhu	a5,74(s1)
    80005f96:	37fd                	addiw	a5,a5,-1
    80005f98:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005f9c:	8526                	mv	a0,s1
    80005f9e:	9f8fe0ef          	jal	80004196 <iupdate>
    80005fa2:	b78d                	j	80005f04 <sys_unlink+0xb8>
    80005fa4:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005fa6:	8526                	mv	a0,s1
    80005fa8:	caefe0ef          	jal	80004456 <iunlockput>
  end_op();
    80005fac:	d1bfe0ef          	jal	80004cc6 <end_op>
  return -1;
    80005fb0:	557d                	li	a0,-1
    80005fb2:	64ee                	ld	s1,216(sp)
}
    80005fb4:	70ae                	ld	ra,232(sp)
    80005fb6:	740e                	ld	s0,224(sp)
    80005fb8:	616d                	addi	sp,sp,240
    80005fba:	8082                	ret
    return -1;
    80005fbc:	557d                	li	a0,-1
    80005fbe:	bfdd                	j	80005fb4 <sys_unlink+0x168>
    iunlockput(ip);
    80005fc0:	854a                	mv	a0,s2
    80005fc2:	c94fe0ef          	jal	80004456 <iunlockput>
    goto bad;
    80005fc6:	694e                	ld	s2,208(sp)
    80005fc8:	69ae                	ld	s3,200(sp)
    80005fca:	bff1                	j	80005fa6 <sys_unlink+0x15a>

0000000080005fcc <sys_open>:

uint64
sys_open(void)
{
    80005fcc:	7131                	addi	sp,sp,-192
    80005fce:	fd06                	sd	ra,184(sp)
    80005fd0:	f922                	sd	s0,176(sp)
    80005fd2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005fd4:	f4c40593          	addi	a1,s0,-180
    80005fd8:	4505                	li	a0,1
    80005fda:	b8cfd0ef          	jal	80003366 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005fde:	08000613          	li	a2,128
    80005fe2:	f5040593          	addi	a1,s0,-176
    80005fe6:	4501                	li	a0,0
    80005fe8:	bb6fd0ef          	jal	8000339e <argstr>
    80005fec:	87aa                	mv	a5,a0
    return -1;
    80005fee:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005ff0:	0a07c363          	bltz	a5,80006096 <sys_open+0xca>
    80005ff4:	f526                	sd	s1,168(sp)

  begin_op();
    80005ff6:	c61fe0ef          	jal	80004c56 <begin_op>

  if(omode & O_CREATE){
    80005ffa:	f4c42783          	lw	a5,-180(s0)
    80005ffe:	2007f793          	andi	a5,a5,512
    80006002:	c3dd                	beqz	a5,800060a8 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80006004:	4681                	li	a3,0
    80006006:	4601                	li	a2,0
    80006008:	4589                	li	a1,2
    8000600a:	f5040513          	addi	a0,s0,-176
    8000600e:	aafff0ef          	jal	80005abc <create>
    80006012:	84aa                	mv	s1,a0
    if(ip == 0){
    80006014:	c549                	beqz	a0,8000609e <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80006016:	04449703          	lh	a4,68(s1)
    8000601a:	478d                	li	a5,3
    8000601c:	00f71763          	bne	a4,a5,8000602a <sys_open+0x5e>
    80006020:	0464d703          	lhu	a4,70(s1)
    80006024:	47a5                	li	a5,9
    80006026:	0ae7ee63          	bltu	a5,a4,800060e2 <sys_open+0x116>
    8000602a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000602c:	fabfe0ef          	jal	80004fd6 <filealloc>
    80006030:	892a                	mv	s2,a0
    80006032:	c561                	beqz	a0,800060fa <sys_open+0x12e>
    80006034:	ed4e                	sd	s3,152(sp)
    80006036:	a47ff0ef          	jal	80005a7c <fdalloc>
    8000603a:	89aa                	mv	s3,a0
    8000603c:	0a054b63          	bltz	a0,800060f2 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80006040:	04449703          	lh	a4,68(s1)
    80006044:	478d                	li	a5,3
    80006046:	0cf70363          	beq	a4,a5,8000610c <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000604a:	4789                	li	a5,2
    8000604c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80006050:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80006054:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80006058:	f4c42783          	lw	a5,-180(s0)
    8000605c:	0017f713          	andi	a4,a5,1
    80006060:	00174713          	xori	a4,a4,1
    80006064:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006068:	0037f713          	andi	a4,a5,3
    8000606c:	00e03733          	snez	a4,a4
    80006070:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80006074:	4007f793          	andi	a5,a5,1024
    80006078:	c791                	beqz	a5,80006084 <sys_open+0xb8>
    8000607a:	04449703          	lh	a4,68(s1)
    8000607e:	4789                	li	a5,2
    80006080:	08f70d63          	beq	a4,a5,8000611a <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80006084:	8526                	mv	a0,s1
    80006086:	a72fe0ef          	jal	800042f8 <iunlock>
  end_op();
    8000608a:	c3dfe0ef          	jal	80004cc6 <end_op>

  return fd;
    8000608e:	854e                	mv	a0,s3
    80006090:	74aa                	ld	s1,168(sp)
    80006092:	790a                	ld	s2,160(sp)
    80006094:	69ea                	ld	s3,152(sp)
}
    80006096:	70ea                	ld	ra,184(sp)
    80006098:	744a                	ld	s0,176(sp)
    8000609a:	6129                	addi	sp,sp,192
    8000609c:	8082                	ret
      end_op();
    8000609e:	c29fe0ef          	jal	80004cc6 <end_op>
      return -1;
    800060a2:	557d                	li	a0,-1
    800060a4:	74aa                	ld	s1,168(sp)
    800060a6:	bfc5                	j	80006096 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800060a8:	f5040513          	addi	a0,s0,-176
    800060ac:	9cdfe0ef          	jal	80004a78 <namei>
    800060b0:	84aa                	mv	s1,a0
    800060b2:	c11d                	beqz	a0,800060d8 <sys_open+0x10c>
    ilock(ip);
    800060b4:	996fe0ef          	jal	8000424a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800060b8:	04449703          	lh	a4,68(s1)
    800060bc:	4785                	li	a5,1
    800060be:	f4f71ce3          	bne	a4,a5,80006016 <sys_open+0x4a>
    800060c2:	f4c42783          	lw	a5,-180(s0)
    800060c6:	d3b5                	beqz	a5,8000602a <sys_open+0x5e>
      iunlockput(ip);
    800060c8:	8526                	mv	a0,s1
    800060ca:	b8cfe0ef          	jal	80004456 <iunlockput>
      end_op();
    800060ce:	bf9fe0ef          	jal	80004cc6 <end_op>
      return -1;
    800060d2:	557d                	li	a0,-1
    800060d4:	74aa                	ld	s1,168(sp)
    800060d6:	b7c1                	j	80006096 <sys_open+0xca>
      end_op();
    800060d8:	beffe0ef          	jal	80004cc6 <end_op>
      return -1;
    800060dc:	557d                	li	a0,-1
    800060de:	74aa                	ld	s1,168(sp)
    800060e0:	bf5d                	j	80006096 <sys_open+0xca>
    iunlockput(ip);
    800060e2:	8526                	mv	a0,s1
    800060e4:	b72fe0ef          	jal	80004456 <iunlockput>
    end_op();
    800060e8:	bdffe0ef          	jal	80004cc6 <end_op>
    return -1;
    800060ec:	557d                	li	a0,-1
    800060ee:	74aa                	ld	s1,168(sp)
    800060f0:	b75d                	j	80006096 <sys_open+0xca>
      fileclose(f);
    800060f2:	854a                	mv	a0,s2
    800060f4:	f87fe0ef          	jal	8000507a <fileclose>
    800060f8:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800060fa:	8526                	mv	a0,s1
    800060fc:	b5afe0ef          	jal	80004456 <iunlockput>
    end_op();
    80006100:	bc7fe0ef          	jal	80004cc6 <end_op>
    return -1;
    80006104:	557d                	li	a0,-1
    80006106:	74aa                	ld	s1,168(sp)
    80006108:	790a                	ld	s2,160(sp)
    8000610a:	b771                	j	80006096 <sys_open+0xca>
    f->type = FD_DEVICE;
    8000610c:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80006110:	04649783          	lh	a5,70(s1)
    80006114:	02f91223          	sh	a5,36(s2)
    80006118:	bf35                	j	80006054 <sys_open+0x88>
    itrunc(ip);
    8000611a:	8526                	mv	a0,s1
    8000611c:	a1cfe0ef          	jal	80004338 <itrunc>
    80006120:	b795                	j	80006084 <sys_open+0xb8>

0000000080006122 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006122:	7175                	addi	sp,sp,-144
    80006124:	e506                	sd	ra,136(sp)
    80006126:	e122                	sd	s0,128(sp)
    80006128:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000612a:	b2dfe0ef          	jal	80004c56 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000612e:	08000613          	li	a2,128
    80006132:	f7040593          	addi	a1,s0,-144
    80006136:	4501                	li	a0,0
    80006138:	a66fd0ef          	jal	8000339e <argstr>
    8000613c:	02054363          	bltz	a0,80006162 <sys_mkdir+0x40>
    80006140:	4681                	li	a3,0
    80006142:	4601                	li	a2,0
    80006144:	4585                	li	a1,1
    80006146:	f7040513          	addi	a0,s0,-144
    8000614a:	973ff0ef          	jal	80005abc <create>
    8000614e:	c911                	beqz	a0,80006162 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80006150:	b06fe0ef          	jal	80004456 <iunlockput>
  end_op();
    80006154:	b73fe0ef          	jal	80004cc6 <end_op>
  return 0;
    80006158:	4501                	li	a0,0
}
    8000615a:	60aa                	ld	ra,136(sp)
    8000615c:	640a                	ld	s0,128(sp)
    8000615e:	6149                	addi	sp,sp,144
    80006160:	8082                	ret
    end_op();
    80006162:	b65fe0ef          	jal	80004cc6 <end_op>
    return -1;
    80006166:	557d                	li	a0,-1
    80006168:	bfcd                	j	8000615a <sys_mkdir+0x38>

000000008000616a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000616a:	7135                	addi	sp,sp,-160
    8000616c:	ed06                	sd	ra,152(sp)
    8000616e:	e922                	sd	s0,144(sp)
    80006170:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80006172:	ae5fe0ef          	jal	80004c56 <begin_op>
  argint(1, &major);
    80006176:	f6c40593          	addi	a1,s0,-148
    8000617a:	4505                	li	a0,1
    8000617c:	9eafd0ef          	jal	80003366 <argint>
  argint(2, &minor);
    80006180:	f6840593          	addi	a1,s0,-152
    80006184:	4509                	li	a0,2
    80006186:	9e0fd0ef          	jal	80003366 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000618a:	08000613          	li	a2,128
    8000618e:	f7040593          	addi	a1,s0,-144
    80006192:	4501                	li	a0,0
    80006194:	a0afd0ef          	jal	8000339e <argstr>
    80006198:	02054563          	bltz	a0,800061c2 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000619c:	f6841683          	lh	a3,-152(s0)
    800061a0:	f6c41603          	lh	a2,-148(s0)
    800061a4:	458d                	li	a1,3
    800061a6:	f7040513          	addi	a0,s0,-144
    800061aa:	913ff0ef          	jal	80005abc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800061ae:	c911                	beqz	a0,800061c2 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800061b0:	aa6fe0ef          	jal	80004456 <iunlockput>
  end_op();
    800061b4:	b13fe0ef          	jal	80004cc6 <end_op>
  return 0;
    800061b8:	4501                	li	a0,0
}
    800061ba:	60ea                	ld	ra,152(sp)
    800061bc:	644a                	ld	s0,144(sp)
    800061be:	610d                	addi	sp,sp,160
    800061c0:	8082                	ret
    end_op();
    800061c2:	b05fe0ef          	jal	80004cc6 <end_op>
    return -1;
    800061c6:	557d                	li	a0,-1
    800061c8:	bfcd                	j	800061ba <sys_mknod+0x50>

00000000800061ca <sys_chdir>:

uint64
sys_chdir(void)
{
    800061ca:	7135                	addi	sp,sp,-160
    800061cc:	ed06                	sd	ra,152(sp)
    800061ce:	e922                	sd	s0,144(sp)
    800061d0:	e14a                	sd	s2,128(sp)
    800061d2:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800061d4:	e97fb0ef          	jal	8000206a <myproc>
    800061d8:	892a                	mv	s2,a0
  
  begin_op();
    800061da:	a7dfe0ef          	jal	80004c56 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800061de:	08000613          	li	a2,128
    800061e2:	f6040593          	addi	a1,s0,-160
    800061e6:	4501                	li	a0,0
    800061e8:	9b6fd0ef          	jal	8000339e <argstr>
    800061ec:	04054363          	bltz	a0,80006232 <sys_chdir+0x68>
    800061f0:	e526                	sd	s1,136(sp)
    800061f2:	f6040513          	addi	a0,s0,-160
    800061f6:	883fe0ef          	jal	80004a78 <namei>
    800061fa:	84aa                	mv	s1,a0
    800061fc:	c915                	beqz	a0,80006230 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800061fe:	84cfe0ef          	jal	8000424a <ilock>
  if(ip->type != T_DIR){
    80006202:	04449703          	lh	a4,68(s1)
    80006206:	4785                	li	a5,1
    80006208:	02f71963          	bne	a4,a5,8000623a <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000620c:	8526                	mv	a0,s1
    8000620e:	8eafe0ef          	jal	800042f8 <iunlock>
  iput(p->cwd);
    80006212:	15093503          	ld	a0,336(s2)
    80006216:	9b6fe0ef          	jal	800043cc <iput>
  end_op();
    8000621a:	aadfe0ef          	jal	80004cc6 <end_op>
  p->cwd = ip;
    8000621e:	14993823          	sd	s1,336(s2)
  return 0;
    80006222:	4501                	li	a0,0
    80006224:	64aa                	ld	s1,136(sp)
}
    80006226:	60ea                	ld	ra,152(sp)
    80006228:	644a                	ld	s0,144(sp)
    8000622a:	690a                	ld	s2,128(sp)
    8000622c:	610d                	addi	sp,sp,160
    8000622e:	8082                	ret
    80006230:	64aa                	ld	s1,136(sp)
    end_op();
    80006232:	a95fe0ef          	jal	80004cc6 <end_op>
    return -1;
    80006236:	557d                	li	a0,-1
    80006238:	b7fd                	j	80006226 <sys_chdir+0x5c>
    iunlockput(ip);
    8000623a:	8526                	mv	a0,s1
    8000623c:	a1afe0ef          	jal	80004456 <iunlockput>
    end_op();
    80006240:	a87fe0ef          	jal	80004cc6 <end_op>
    return -1;
    80006244:	557d                	li	a0,-1
    80006246:	64aa                	ld	s1,136(sp)
    80006248:	bff9                	j	80006226 <sys_chdir+0x5c>

000000008000624a <sys_exec>:

uint64
sys_exec(void)
{
    8000624a:	7105                	addi	sp,sp,-480
    8000624c:	ef86                	sd	ra,472(sp)
    8000624e:	eba2                	sd	s0,464(sp)
    80006250:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006252:	e2840593          	addi	a1,s0,-472
    80006256:	4505                	li	a0,1
    80006258:	92afd0ef          	jal	80003382 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000625c:	08000613          	li	a2,128
    80006260:	f3040593          	addi	a1,s0,-208
    80006264:	4501                	li	a0,0
    80006266:	938fd0ef          	jal	8000339e <argstr>
    8000626a:	87aa                	mv	a5,a0
    return -1;
    8000626c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000626e:	0e07c063          	bltz	a5,8000634e <sys_exec+0x104>
    80006272:	e7a6                	sd	s1,456(sp)
    80006274:	e3ca                	sd	s2,448(sp)
    80006276:	ff4e                	sd	s3,440(sp)
    80006278:	fb52                	sd	s4,432(sp)
    8000627a:	f756                	sd	s5,424(sp)
    8000627c:	f35a                	sd	s6,416(sp)
    8000627e:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80006280:	e3040a13          	addi	s4,s0,-464
    80006284:	10000613          	li	a2,256
    80006288:	4581                	li	a1,0
    8000628a:	8552                	mv	a0,s4
    8000628c:	f47fa0ef          	jal	800011d2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80006290:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80006292:	89d2                	mv	s3,s4
    80006294:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006296:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000629a:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000629c:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800062a0:	00391513          	slli	a0,s2,0x3
    800062a4:	85d6                	mv	a1,s5
    800062a6:	e2843783          	ld	a5,-472(s0)
    800062aa:	953e                	add	a0,a0,a5
    800062ac:	830fd0ef          	jal	800032dc <fetchaddr>
    800062b0:	02054663          	bltz	a0,800062dc <sys_exec+0x92>
    if(uarg == 0){
    800062b4:	e2043783          	ld	a5,-480(s0)
    800062b8:	c7a1                	beqz	a5,80006300 <sys_exec+0xb6>
    argv[i] = kalloc();
    800062ba:	8cffa0ef          	jal	80000b88 <kalloc>
    800062be:	85aa                	mv	a1,a0
    800062c0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800062c4:	cd01                	beqz	a0,800062dc <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800062c6:	865a                	mv	a2,s6
    800062c8:	e2043503          	ld	a0,-480(s0)
    800062cc:	85afd0ef          	jal	80003326 <fetchstr>
    800062d0:	00054663          	bltz	a0,800062dc <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800062d4:	0905                	addi	s2,s2,1
    800062d6:	09a1                	addi	s3,s3,8
    800062d8:	fd7914e3          	bne	s2,s7,800062a0 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062dc:	100a0a13          	addi	s4,s4,256
    800062e0:	6088                	ld	a0,0(s1)
    800062e2:	cd31                	beqz	a0,8000633e <sys_exec+0xf4>
    kfree(argv[i]);
    800062e4:	f78fa0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062e8:	04a1                	addi	s1,s1,8
    800062ea:	ff449be3          	bne	s1,s4,800062e0 <sys_exec+0x96>
  return -1;
    800062ee:	557d                	li	a0,-1
    800062f0:	64be                	ld	s1,456(sp)
    800062f2:	691e                	ld	s2,448(sp)
    800062f4:	79fa                	ld	s3,440(sp)
    800062f6:	7a5a                	ld	s4,432(sp)
    800062f8:	7aba                	ld	s5,424(sp)
    800062fa:	7b1a                	ld	s6,416(sp)
    800062fc:	6bfa                	ld	s7,408(sp)
    800062fe:	a881                	j	8000634e <sys_exec+0x104>
      argv[i] = 0;
    80006300:	0009079b          	sext.w	a5,s2
    80006304:	e3040593          	addi	a1,s0,-464
    80006308:	078e                	slli	a5,a5,0x3
    8000630a:	97ae                	add	a5,a5,a1
    8000630c:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80006310:	f3040513          	addi	a0,s0,-208
    80006314:	bb2ff0ef          	jal	800056c6 <kexec>
    80006318:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000631a:	100a0a13          	addi	s4,s4,256
    8000631e:	6088                	ld	a0,0(s1)
    80006320:	c511                	beqz	a0,8000632c <sys_exec+0xe2>
    kfree(argv[i]);
    80006322:	f3afa0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006326:	04a1                	addi	s1,s1,8
    80006328:	ff449be3          	bne	s1,s4,8000631e <sys_exec+0xd4>
  return ret;
    8000632c:	854a                	mv	a0,s2
    8000632e:	64be                	ld	s1,456(sp)
    80006330:	691e                	ld	s2,448(sp)
    80006332:	79fa                	ld	s3,440(sp)
    80006334:	7a5a                	ld	s4,432(sp)
    80006336:	7aba                	ld	s5,424(sp)
    80006338:	7b1a                	ld	s6,416(sp)
    8000633a:	6bfa                	ld	s7,408(sp)
    8000633c:	a809                	j	8000634e <sys_exec+0x104>
  return -1;
    8000633e:	557d                	li	a0,-1
    80006340:	64be                	ld	s1,456(sp)
    80006342:	691e                	ld	s2,448(sp)
    80006344:	79fa                	ld	s3,440(sp)
    80006346:	7a5a                	ld	s4,432(sp)
    80006348:	7aba                	ld	s5,424(sp)
    8000634a:	7b1a                	ld	s6,416(sp)
    8000634c:	6bfa                	ld	s7,408(sp)
}
    8000634e:	60fe                	ld	ra,472(sp)
    80006350:	645e                	ld	s0,464(sp)
    80006352:	613d                	addi	sp,sp,480
    80006354:	8082                	ret

0000000080006356 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006356:	7139                	addi	sp,sp,-64
    80006358:	fc06                	sd	ra,56(sp)
    8000635a:	f822                	sd	s0,48(sp)
    8000635c:	f426                	sd	s1,40(sp)
    8000635e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006360:	d0bfb0ef          	jal	8000206a <myproc>
    80006364:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006366:	fd840593          	addi	a1,s0,-40
    8000636a:	4501                	li	a0,0
    8000636c:	816fd0ef          	jal	80003382 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80006370:	fc840593          	addi	a1,s0,-56
    80006374:	fd040513          	addi	a0,s0,-48
    80006378:	81eff0ef          	jal	80005396 <pipealloc>
    return -1;
    8000637c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000637e:	0a054763          	bltz	a0,8000642c <sys_pipe+0xd6>
  fd0 = -1;
    80006382:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006386:	fd043503          	ld	a0,-48(s0)
    8000638a:	ef2ff0ef          	jal	80005a7c <fdalloc>
    8000638e:	fca42223          	sw	a0,-60(s0)
    80006392:	08054463          	bltz	a0,8000641a <sys_pipe+0xc4>
    80006396:	fc843503          	ld	a0,-56(s0)
    8000639a:	ee2ff0ef          	jal	80005a7c <fdalloc>
    8000639e:	fca42023          	sw	a0,-64(s0)
    800063a2:	06054263          	bltz	a0,80006406 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800063a6:	4691                	li	a3,4
    800063a8:	fc440613          	addi	a2,s0,-60
    800063ac:	fd843583          	ld	a1,-40(s0)
    800063b0:	68a8                	ld	a0,80(s1)
    800063b2:	9c3fb0ef          	jal	80001d74 <copyout>
    800063b6:	00054e63          	bltz	a0,800063d2 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800063ba:	4691                	li	a3,4
    800063bc:	fc040613          	addi	a2,s0,-64
    800063c0:	fd843583          	ld	a1,-40(s0)
    800063c4:	95b6                	add	a1,a1,a3
    800063c6:	68a8                	ld	a0,80(s1)
    800063c8:	9adfb0ef          	jal	80001d74 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800063cc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800063ce:	04055f63          	bgez	a0,8000642c <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    800063d2:	fc442783          	lw	a5,-60(s0)
    800063d6:	078e                	slli	a5,a5,0x3
    800063d8:	0d078793          	addi	a5,a5,208
    800063dc:	97a6                	add	a5,a5,s1
    800063de:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800063e2:	fc042783          	lw	a5,-64(s0)
    800063e6:	078e                	slli	a5,a5,0x3
    800063e8:	0d078793          	addi	a5,a5,208
    800063ec:	97a6                	add	a5,a5,s1
    800063ee:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800063f2:	fd043503          	ld	a0,-48(s0)
    800063f6:	c85fe0ef          	jal	8000507a <fileclose>
    fileclose(wf);
    800063fa:	fc843503          	ld	a0,-56(s0)
    800063fe:	c7dfe0ef          	jal	8000507a <fileclose>
    return -1;
    80006402:	57fd                	li	a5,-1
    80006404:	a025                	j	8000642c <sys_pipe+0xd6>
    if(fd0 >= 0)
    80006406:	fc442783          	lw	a5,-60(s0)
    8000640a:	0007c863          	bltz	a5,8000641a <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    8000640e:	078e                	slli	a5,a5,0x3
    80006410:	0d078793          	addi	a5,a5,208
    80006414:	97a6                	add	a5,a5,s1
    80006416:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000641a:	fd043503          	ld	a0,-48(s0)
    8000641e:	c5dfe0ef          	jal	8000507a <fileclose>
    fileclose(wf);
    80006422:	fc843503          	ld	a0,-56(s0)
    80006426:	c55fe0ef          	jal	8000507a <fileclose>
    return -1;
    8000642a:	57fd                	li	a5,-1
}
    8000642c:	853e                	mv	a0,a5
    8000642e:	70e2                	ld	ra,56(sp)
    80006430:	7442                	ld	s0,48(sp)
    80006432:	74a2                	ld	s1,40(sp)
    80006434:	6121                	addi	sp,sp,64
    80006436:	8082                	ret
	...

0000000080006440 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80006440:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80006442:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80006444:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80006446:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80006448:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000644a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000644c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000644e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80006450:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80006452:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80006454:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80006456:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80006458:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000645a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000645c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000645e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80006460:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80006462:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80006464:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80006466:	d01fc0ef          	jal	80003166 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000646a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000646c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000646e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80006470:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80006472:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80006474:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80006476:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80006478:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000647a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000647c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000647e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80006480:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80006482:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80006484:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80006486:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80006488:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000648a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000648c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000648e:	10200073          	sret
    80006492:	00000013          	nop
    80006496:	00000013          	nop
    8000649a:	00000013          	nop

000000008000649e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000649e:	1141                	addi	sp,sp,-16
    800064a0:	e406                	sd	ra,8(sp)
    800064a2:	e022                	sd	s0,0(sp)
    800064a4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800064a6:	0c000737          	lui	a4,0xc000
    800064aa:	4785                	li	a5,1
    800064ac:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800064ae:	c35c                	sw	a5,4(a4)
}
    800064b0:	60a2                	ld	ra,8(sp)
    800064b2:	6402                	ld	s0,0(sp)
    800064b4:	0141                	addi	sp,sp,16
    800064b6:	8082                	ret

00000000800064b8 <plicinithart>:

void
plicinithart(void)
{
    800064b8:	1141                	addi	sp,sp,-16
    800064ba:	e406                	sd	ra,8(sp)
    800064bc:	e022                	sd	s0,0(sp)
    800064be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800064c0:	b77fb0ef          	jal	80002036 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800064c4:	0085171b          	slliw	a4,a0,0x8
    800064c8:	0c0027b7          	lui	a5,0xc002
    800064cc:	97ba                	add	a5,a5,a4
    800064ce:	40200713          	li	a4,1026
    800064d2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800064d6:	00d5151b          	slliw	a0,a0,0xd
    800064da:	0c2017b7          	lui	a5,0xc201
    800064de:	97aa                	add	a5,a5,a0
    800064e0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800064e4:	60a2                	ld	ra,8(sp)
    800064e6:	6402                	ld	s0,0(sp)
    800064e8:	0141                	addi	sp,sp,16
    800064ea:	8082                	ret

00000000800064ec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800064ec:	1141                	addi	sp,sp,-16
    800064ee:	e406                	sd	ra,8(sp)
    800064f0:	e022                	sd	s0,0(sp)
    800064f2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800064f4:	b43fb0ef          	jal	80002036 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800064f8:	00d5151b          	slliw	a0,a0,0xd
    800064fc:	0c2017b7          	lui	a5,0xc201
    80006500:	97aa                	add	a5,a5,a0
  return irq;
}
    80006502:	43c8                	lw	a0,4(a5)
    80006504:	60a2                	ld	ra,8(sp)
    80006506:	6402                	ld	s0,0(sp)
    80006508:	0141                	addi	sp,sp,16
    8000650a:	8082                	ret

000000008000650c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000650c:	1101                	addi	sp,sp,-32
    8000650e:	ec06                	sd	ra,24(sp)
    80006510:	e822                	sd	s0,16(sp)
    80006512:	e426                	sd	s1,8(sp)
    80006514:	1000                	addi	s0,sp,32
    80006516:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006518:	b1ffb0ef          	jal	80002036 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000651c:	00d5179b          	slliw	a5,a0,0xd
    80006520:	0c201737          	lui	a4,0xc201
    80006524:	97ba                	add	a5,a5,a4
    80006526:	c3c4                	sw	s1,4(a5)
}
    80006528:	60e2                	ld	ra,24(sp)
    8000652a:	6442                	ld	s0,16(sp)
    8000652c:	64a2                	ld	s1,8(sp)
    8000652e:	6105                	addi	sp,sp,32
    80006530:	8082                	ret

0000000080006532 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80006532:	1141                	addi	sp,sp,-16
    80006534:	e406                	sd	ra,8(sp)
    80006536:	e022                	sd	s0,0(sp)
    80006538:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000653a:	479d                	li	a5,7
    8000653c:	04a7ca63          	blt	a5,a0,80006590 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80006540:	0001f797          	auipc	a5,0x1f
    80006544:	4d878793          	addi	a5,a5,1240 # 80025a18 <disk>
    80006548:	97aa                	add	a5,a5,a0
    8000654a:	0187c783          	lbu	a5,24(a5)
    8000654e:	e7b9                	bnez	a5,8000659c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006550:	00451693          	slli	a3,a0,0x4
    80006554:	0001f797          	auipc	a5,0x1f
    80006558:	4c478793          	addi	a5,a5,1220 # 80025a18 <disk>
    8000655c:	6398                	ld	a4,0(a5)
    8000655e:	9736                	add	a4,a4,a3
    80006560:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80006564:	6398                	ld	a4,0(a5)
    80006566:	9736                	add	a4,a4,a3
    80006568:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000656c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006570:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006574:	97aa                	add	a5,a5,a0
    80006576:	4705                	li	a4,1
    80006578:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000657c:	0001f517          	auipc	a0,0x1f
    80006580:	4b450513          	addi	a0,a0,1204 # 80025a30 <disk+0x18>
    80006584:	b50fc0ef          	jal	800028d4 <wakeup>
}
    80006588:	60a2                	ld	ra,8(sp)
    8000658a:	6402                	ld	s0,0(sp)
    8000658c:	0141                	addi	sp,sp,16
    8000658e:	8082                	ret
    panic("free_desc 1");
    80006590:	00003517          	auipc	a0,0x3
    80006594:	0c850513          	addi	a0,a0,200 # 80009658 <etext+0x658>
    80006598:	a8cfa0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    8000659c:	00003517          	auipc	a0,0x3
    800065a0:	0cc50513          	addi	a0,a0,204 # 80009668 <etext+0x668>
    800065a4:	a80fa0ef          	jal	80000824 <panic>

00000000800065a8 <virtio_disk_init>:
{
    800065a8:	1101                	addi	sp,sp,-32
    800065aa:	ec06                	sd	ra,24(sp)
    800065ac:	e822                	sd	s0,16(sp)
    800065ae:	e426                	sd	s1,8(sp)
    800065b0:	e04a                	sd	s2,0(sp)
    800065b2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800065b4:	00003597          	auipc	a1,0x3
    800065b8:	0c458593          	addi	a1,a1,196 # 80009678 <etext+0x678>
    800065bc:	0001f517          	auipc	a0,0x1f
    800065c0:	58450513          	addi	a0,a0,1412 # 80025b40 <disk+0x128>
    800065c4:	ab5fa0ef          	jal	80001078 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800065c8:	100017b7          	lui	a5,0x10001
    800065cc:	4398                	lw	a4,0(a5)
    800065ce:	2701                	sext.w	a4,a4
    800065d0:	747277b7          	lui	a5,0x74727
    800065d4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800065d8:	14f71863          	bne	a4,a5,80006728 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800065dc:	100017b7          	lui	a5,0x10001
    800065e0:	43dc                	lw	a5,4(a5)
    800065e2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800065e4:	4709                	li	a4,2
    800065e6:	14e79163          	bne	a5,a4,80006728 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800065ea:	100017b7          	lui	a5,0x10001
    800065ee:	479c                	lw	a5,8(a5)
    800065f0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800065f2:	12e79b63          	bne	a5,a4,80006728 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800065f6:	100017b7          	lui	a5,0x10001
    800065fa:	47d8                	lw	a4,12(a5)
    800065fc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800065fe:	554d47b7          	lui	a5,0x554d4
    80006602:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006606:	12f71163          	bne	a4,a5,80006728 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000660a:	100017b7          	lui	a5,0x10001
    8000660e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006612:	4705                	li	a4,1
    80006614:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006616:	470d                	li	a4,3
    80006618:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000661a:	10001737          	lui	a4,0x10001
    8000661e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006620:	c7ffe6b7          	lui	a3,0xc7ffe
    80006624:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47dd73c7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006628:	8f75                	and	a4,a4,a3
    8000662a:	100016b7          	lui	a3,0x10001
    8000662e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006630:	472d                	li	a4,11
    80006632:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006634:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006638:	439c                	lw	a5,0(a5)
    8000663a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000663e:	8ba1                	andi	a5,a5,8
    80006640:	0e078a63          	beqz	a5,80006734 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006644:	100017b7          	lui	a5,0x10001
    80006648:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000664c:	43fc                	lw	a5,68(a5)
    8000664e:	2781                	sext.w	a5,a5
    80006650:	0e079863          	bnez	a5,80006740 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006654:	100017b7          	lui	a5,0x10001
    80006658:	5bdc                	lw	a5,52(a5)
    8000665a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000665c:	0e078863          	beqz	a5,8000674c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80006660:	471d                	li	a4,7
    80006662:	0ef77b63          	bgeu	a4,a5,80006758 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80006666:	d22fa0ef          	jal	80000b88 <kalloc>
    8000666a:	0001f497          	auipc	s1,0x1f
    8000666e:	3ae48493          	addi	s1,s1,942 # 80025a18 <disk>
    80006672:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006674:	d14fa0ef          	jal	80000b88 <kalloc>
    80006678:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000667a:	d0efa0ef          	jal	80000b88 <kalloc>
    8000667e:	87aa                	mv	a5,a0
    80006680:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006682:	6088                	ld	a0,0(s1)
    80006684:	0e050063          	beqz	a0,80006764 <virtio_disk_init+0x1bc>
    80006688:	0001f717          	auipc	a4,0x1f
    8000668c:	39873703          	ld	a4,920(a4) # 80025a20 <disk+0x8>
    80006690:	cb71                	beqz	a4,80006764 <virtio_disk_init+0x1bc>
    80006692:	cbe9                	beqz	a5,80006764 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80006694:	6605                	lui	a2,0x1
    80006696:	4581                	li	a1,0
    80006698:	b3bfa0ef          	jal	800011d2 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000669c:	0001f497          	auipc	s1,0x1f
    800066a0:	37c48493          	addi	s1,s1,892 # 80025a18 <disk>
    800066a4:	6605                	lui	a2,0x1
    800066a6:	4581                	li	a1,0
    800066a8:	6488                	ld	a0,8(s1)
    800066aa:	b29fa0ef          	jal	800011d2 <memset>
  memset(disk.used, 0, PGSIZE);
    800066ae:	6605                	lui	a2,0x1
    800066b0:	4581                	li	a1,0
    800066b2:	6888                	ld	a0,16(s1)
    800066b4:	b1ffa0ef          	jal	800011d2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800066b8:	100017b7          	lui	a5,0x10001
    800066bc:	4721                	li	a4,8
    800066be:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800066c0:	4098                	lw	a4,0(s1)
    800066c2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800066c6:	40d8                	lw	a4,4(s1)
    800066c8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800066cc:	649c                	ld	a5,8(s1)
    800066ce:	0007869b          	sext.w	a3,a5
    800066d2:	10001737          	lui	a4,0x10001
    800066d6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800066da:	9781                	srai	a5,a5,0x20
    800066dc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800066e0:	689c                	ld	a5,16(s1)
    800066e2:	0007869b          	sext.w	a3,a5
    800066e6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800066ea:	9781                	srai	a5,a5,0x20
    800066ec:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800066f0:	4785                	li	a5,1
    800066f2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800066f4:	00f48c23          	sb	a5,24(s1)
    800066f8:	00f48ca3          	sb	a5,25(s1)
    800066fc:	00f48d23          	sb	a5,26(s1)
    80006700:	00f48da3          	sb	a5,27(s1)
    80006704:	00f48e23          	sb	a5,28(s1)
    80006708:	00f48ea3          	sb	a5,29(s1)
    8000670c:	00f48f23          	sb	a5,30(s1)
    80006710:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006714:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006718:	07272823          	sw	s2,112(a4)
}
    8000671c:	60e2                	ld	ra,24(sp)
    8000671e:	6442                	ld	s0,16(sp)
    80006720:	64a2                	ld	s1,8(sp)
    80006722:	6902                	ld	s2,0(sp)
    80006724:	6105                	addi	sp,sp,32
    80006726:	8082                	ret
    panic("could not find virtio disk");
    80006728:	00003517          	auipc	a0,0x3
    8000672c:	f6050513          	addi	a0,a0,-160 # 80009688 <etext+0x688>
    80006730:	8f4fa0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006734:	00003517          	auipc	a0,0x3
    80006738:	f7450513          	addi	a0,a0,-140 # 800096a8 <etext+0x6a8>
    8000673c:	8e8fa0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    80006740:	00003517          	auipc	a0,0x3
    80006744:	f8850513          	addi	a0,a0,-120 # 800096c8 <etext+0x6c8>
    80006748:	8dcfa0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    8000674c:	00003517          	auipc	a0,0x3
    80006750:	f9c50513          	addi	a0,a0,-100 # 800096e8 <etext+0x6e8>
    80006754:	8d0fa0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    80006758:	00003517          	auipc	a0,0x3
    8000675c:	fb050513          	addi	a0,a0,-80 # 80009708 <etext+0x708>
    80006760:	8c4fa0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    80006764:	00003517          	auipc	a0,0x3
    80006768:	fc450513          	addi	a0,a0,-60 # 80009728 <etext+0x728>
    8000676c:	8b8fa0ef          	jal	80000824 <panic>

0000000080006770 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006770:	711d                	addi	sp,sp,-96
    80006772:	ec86                	sd	ra,88(sp)
    80006774:	e8a2                	sd	s0,80(sp)
    80006776:	e4a6                	sd	s1,72(sp)
    80006778:	e0ca                	sd	s2,64(sp)
    8000677a:	fc4e                	sd	s3,56(sp)
    8000677c:	f852                	sd	s4,48(sp)
    8000677e:	f456                	sd	s5,40(sp)
    80006780:	f05a                	sd	s6,32(sp)
    80006782:	ec5e                	sd	s7,24(sp)
    80006784:	e862                	sd	s8,16(sp)
    80006786:	1080                	addi	s0,sp,96
    80006788:	89aa                	mv	s3,a0
    8000678a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000678c:	00c52b83          	lw	s7,12(a0)
    80006790:	001b9b9b          	slliw	s7,s7,0x1
    80006794:	1b82                	slli	s7,s7,0x20
    80006796:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000679a:	0001f517          	auipc	a0,0x1f
    8000679e:	3a650513          	addi	a0,a0,934 # 80025b40 <disk+0x128>
    800067a2:	961fa0ef          	jal	80001102 <acquire>
  for(int i = 0; i < NUM; i++){
    800067a6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800067a8:	0001fa97          	auipc	s5,0x1f
    800067ac:	270a8a93          	addi	s5,s5,624 # 80025a18 <disk>
  for(int i = 0; i < 3; i++){
    800067b0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800067b2:	5c7d                	li	s8,-1
    800067b4:	a095                	j	80006818 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    800067b6:	00fa8733          	add	a4,s5,a5
    800067ba:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800067be:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800067c0:	0207c563          	bltz	a5,800067ea <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    800067c4:	2905                	addiw	s2,s2,1
    800067c6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800067c8:	05490c63          	beq	s2,s4,80006820 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    800067cc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800067ce:	0001f717          	auipc	a4,0x1f
    800067d2:	24a70713          	addi	a4,a4,586 # 80025a18 <disk>
    800067d6:	4781                	li	a5,0
    if(disk.free[i]){
    800067d8:	01874683          	lbu	a3,24(a4)
    800067dc:	fee9                	bnez	a3,800067b6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    800067de:	2785                	addiw	a5,a5,1
    800067e0:	0705                	addi	a4,a4,1
    800067e2:	fe979be3          	bne	a5,s1,800067d8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    800067e6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    800067ea:	01205d63          	blez	s2,80006804 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800067ee:	fa042503          	lw	a0,-96(s0)
    800067f2:	d41ff0ef          	jal	80006532 <free_desc>
      for(int j = 0; j < i; j++)
    800067f6:	4785                	li	a5,1
    800067f8:	0127d663          	bge	a5,s2,80006804 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800067fc:	fa442503          	lw	a0,-92(s0)
    80006800:	d33ff0ef          	jal	80006532 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006804:	0001f597          	auipc	a1,0x1f
    80006808:	33c58593          	addi	a1,a1,828 # 80025b40 <disk+0x128>
    8000680c:	0001f517          	auipc	a0,0x1f
    80006810:	22450513          	addi	a0,a0,548 # 80025a30 <disk+0x18>
    80006814:	874fc0ef          	jal	80002888 <sleep>
  for(int i = 0; i < 3; i++){
    80006818:	fa040613          	addi	a2,s0,-96
    8000681c:	4901                	li	s2,0
    8000681e:	b77d                	j	800067cc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006820:	fa042503          	lw	a0,-96(s0)
    80006824:	00451693          	slli	a3,a0,0x4

  if(write)
    80006828:	0001f797          	auipc	a5,0x1f
    8000682c:	1f078793          	addi	a5,a5,496 # 80025a18 <disk>
    80006830:	00451713          	slli	a4,a0,0x4
    80006834:	0a070713          	addi	a4,a4,160
    80006838:	973e                	add	a4,a4,a5
    8000683a:	01603633          	snez	a2,s6
    8000683e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006840:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006844:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006848:	6398                	ld	a4,0(a5)
    8000684a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000684c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006850:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006852:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006854:	6390                	ld	a2,0(a5)
    80006856:	00d60833          	add	a6,a2,a3
    8000685a:	4741                	li	a4,16
    8000685c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006860:	4585                	li	a1,1
    80006862:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80006866:	fa442703          	lw	a4,-92(s0)
    8000686a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000686e:	0712                	slli	a4,a4,0x4
    80006870:	963a                	add	a2,a2,a4
    80006872:	05898813          	addi	a6,s3,88
    80006876:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000687a:	0007b883          	ld	a7,0(a5)
    8000687e:	9746                	add	a4,a4,a7
    80006880:	40000613          	li	a2,1024
    80006884:	c710                	sw	a2,8(a4)
  if(write)
    80006886:	001b3613          	seqz	a2,s6
    8000688a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000688e:	8e4d                	or	a2,a2,a1
    80006890:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006894:	fa842603          	lw	a2,-88(s0)
    80006898:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000689c:	00451813          	slli	a6,a0,0x4
    800068a0:	02080813          	addi	a6,a6,32
    800068a4:	983e                	add	a6,a6,a5
    800068a6:	577d                	li	a4,-1
    800068a8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800068ac:	0612                	slli	a2,a2,0x4
    800068ae:	98b2                	add	a7,a7,a2
    800068b0:	03068713          	addi	a4,a3,48
    800068b4:	973e                	add	a4,a4,a5
    800068b6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800068ba:	6398                	ld	a4,0(a5)
    800068bc:	9732                	add	a4,a4,a2
    800068be:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800068c0:	4689                	li	a3,2
    800068c2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800068c6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800068ca:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    800068ce:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800068d2:	6794                	ld	a3,8(a5)
    800068d4:	0026d703          	lhu	a4,2(a3)
    800068d8:	8b1d                	andi	a4,a4,7
    800068da:	0706                	slli	a4,a4,0x1
    800068dc:	96ba                	add	a3,a3,a4
    800068de:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800068e2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800068e6:	6798                	ld	a4,8(a5)
    800068e8:	00275783          	lhu	a5,2(a4)
    800068ec:	2785                	addiw	a5,a5,1
    800068ee:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800068f2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800068f6:	100017b7          	lui	a5,0x10001
    800068fa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800068fe:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006902:	0001f917          	auipc	s2,0x1f
    80006906:	23e90913          	addi	s2,s2,574 # 80025b40 <disk+0x128>
  while(b->disk == 1) {
    8000690a:	84ae                	mv	s1,a1
    8000690c:	00b79a63          	bne	a5,a1,80006920 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80006910:	85ca                	mv	a1,s2
    80006912:	854e                	mv	a0,s3
    80006914:	f75fb0ef          	jal	80002888 <sleep>
  while(b->disk == 1) {
    80006918:	0049a783          	lw	a5,4(s3)
    8000691c:	fe978ae3          	beq	a5,s1,80006910 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80006920:	fa042903          	lw	s2,-96(s0)
    80006924:	00491713          	slli	a4,s2,0x4
    80006928:	02070713          	addi	a4,a4,32
    8000692c:	0001f797          	auipc	a5,0x1f
    80006930:	0ec78793          	addi	a5,a5,236 # 80025a18 <disk>
    80006934:	97ba                	add	a5,a5,a4
    80006936:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000693a:	0001f997          	auipc	s3,0x1f
    8000693e:	0de98993          	addi	s3,s3,222 # 80025a18 <disk>
    80006942:	00491713          	slli	a4,s2,0x4
    80006946:	0009b783          	ld	a5,0(s3)
    8000694a:	97ba                	add	a5,a5,a4
    8000694c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006950:	854a                	mv	a0,s2
    80006952:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006956:	bddff0ef          	jal	80006532 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000695a:	8885                	andi	s1,s1,1
    8000695c:	f0fd                	bnez	s1,80006942 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000695e:	0001f517          	auipc	a0,0x1f
    80006962:	1e250513          	addi	a0,a0,482 # 80025b40 <disk+0x128>
    80006966:	831fa0ef          	jal	80001196 <release>
}
    8000696a:	60e6                	ld	ra,88(sp)
    8000696c:	6446                	ld	s0,80(sp)
    8000696e:	64a6                	ld	s1,72(sp)
    80006970:	6906                	ld	s2,64(sp)
    80006972:	79e2                	ld	s3,56(sp)
    80006974:	7a42                	ld	s4,48(sp)
    80006976:	7aa2                	ld	s5,40(sp)
    80006978:	7b02                	ld	s6,32(sp)
    8000697a:	6be2                	ld	s7,24(sp)
    8000697c:	6c42                	ld	s8,16(sp)
    8000697e:	6125                	addi	sp,sp,96
    80006980:	8082                	ret

0000000080006982 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006982:	1101                	addi	sp,sp,-32
    80006984:	ec06                	sd	ra,24(sp)
    80006986:	e822                	sd	s0,16(sp)
    80006988:	e426                	sd	s1,8(sp)
    8000698a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000698c:	0001f497          	auipc	s1,0x1f
    80006990:	08c48493          	addi	s1,s1,140 # 80025a18 <disk>
    80006994:	0001f517          	auipc	a0,0x1f
    80006998:	1ac50513          	addi	a0,a0,428 # 80025b40 <disk+0x128>
    8000699c:	f66fa0ef          	jal	80001102 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800069a0:	100017b7          	lui	a5,0x10001
    800069a4:	53bc                	lw	a5,96(a5)
    800069a6:	8b8d                	andi	a5,a5,3
    800069a8:	10001737          	lui	a4,0x10001
    800069ac:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800069ae:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800069b2:	689c                	ld	a5,16(s1)
    800069b4:	0204d703          	lhu	a4,32(s1)
    800069b8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800069bc:	04f70863          	beq	a4,a5,80006a0c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800069c0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800069c4:	6898                	ld	a4,16(s1)
    800069c6:	0204d783          	lhu	a5,32(s1)
    800069ca:	8b9d                	andi	a5,a5,7
    800069cc:	078e                	slli	a5,a5,0x3
    800069ce:	97ba                	add	a5,a5,a4
    800069d0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800069d2:	00479713          	slli	a4,a5,0x4
    800069d6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    800069da:	9726                	add	a4,a4,s1
    800069dc:	01074703          	lbu	a4,16(a4)
    800069e0:	e329                	bnez	a4,80006a22 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800069e2:	0792                	slli	a5,a5,0x4
    800069e4:	02078793          	addi	a5,a5,32
    800069e8:	97a6                	add	a5,a5,s1
    800069ea:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800069ec:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800069f0:	ee5fb0ef          	jal	800028d4 <wakeup>

    disk.used_idx += 1;
    800069f4:	0204d783          	lhu	a5,32(s1)
    800069f8:	2785                	addiw	a5,a5,1
    800069fa:	17c2                	slli	a5,a5,0x30
    800069fc:	93c1                	srli	a5,a5,0x30
    800069fe:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006a02:	6898                	ld	a4,16(s1)
    80006a04:	00275703          	lhu	a4,2(a4)
    80006a08:	faf71ce3          	bne	a4,a5,800069c0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006a0c:	0001f517          	auipc	a0,0x1f
    80006a10:	13450513          	addi	a0,a0,308 # 80025b40 <disk+0x128>
    80006a14:	f82fa0ef          	jal	80001196 <release>
}
    80006a18:	60e2                	ld	ra,24(sp)
    80006a1a:	6442                	ld	s0,16(sp)
    80006a1c:	64a2                	ld	s1,8(sp)
    80006a1e:	6105                	addi	sp,sp,32
    80006a20:	8082                	ret
      panic("virtio_disk_intr status");
    80006a22:	00003517          	auipc	a0,0x3
    80006a26:	d1e50513          	addi	a0,a0,-738 # 80009740 <etext+0x740>
    80006a2a:	dfbf90ef          	jal	80000824 <panic>

0000000080006a2e <xor_block>:
  return 0;
}

static void
xor_block(char *dst, char *src)
{
    80006a2e:	1141                	addi	sp,sp,-16
    80006a30:	e406                	sd	ra,8(sp)
    80006a32:	e022                	sd	s0,0(sp)
    80006a34:	0800                	addi	s0,sp,16
  for(int i = 0; i < BSIZE; i++)
    80006a36:	87aa                	mv	a5,a0
    80006a38:	40050613          	addi	a2,a0,1024
    dst[i] ^= src[i];
    80006a3c:	0007c703          	lbu	a4,0(a5)
    80006a40:	0005c683          	lbu	a3,0(a1)
    80006a44:	8f35                	xor	a4,a4,a3
    80006a46:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < BSIZE; i++)
    80006a4a:	0785                	addi	a5,a5,1
    80006a4c:	0585                	addi	a1,a1,1
    80006a4e:	fec797e3          	bne	a5,a2,80006a3c <xor_block+0xe>
}
    80006a52:	60a2                	ld	ra,8(sp)
    80006a54:	6402                	ld	s0,0(sp)
    80006a56:	0141                	addi	sp,sp,16
    80006a58:	8082                	ret

0000000080006a5a <phys_write_block>:
{
    80006a5a:	1141                	addi	sp,sp,-16
    80006a5c:	e406                	sd	ra,8(sp)
    80006a5e:	e022                	sd	s0,0(sp)
    80006a60:	0800                	addi	s0,sp,16
  if(disk_id < 0 || disk_id >= NUM_DISKS)
    80006a62:	470d                	li	a4,3
    80006a64:	02a76563          	bltu	a4,a0,80006a8e <phys_write_block+0x34>
    80006a68:	87ae                	mv	a5,a1
    80006a6a:	85b2                	mv	a1,a2
  if(blk >= DISK_BLOCKS)
    80006a6c:	1ff00713          	li	a4,511
    80006a70:	02f76563          	bltu	a4,a5,80006a9a <phys_write_block+0x40>
  if(disk_failed[disk_id])
    80006a74:	00251693          	slli	a3,a0,0x2
    80006a78:	0001f717          	auipc	a4,0x1f
    80006a7c:	0e070713          	addi	a4,a4,224 # 80025b58 <disk_failed>
    80006a80:	9736                	add	a4,a4,a3
    80006a82:	4318                	lw	a4,0(a4)
    80006a84:	c30d                	beqz	a4,80006aa6 <phys_write_block+0x4c>
}
    80006a86:	60a2                	ld	ra,8(sp)
    80006a88:	6402                	ld	s0,0(sp)
    80006a8a:	0141                	addi	sp,sp,16
    80006a8c:	8082                	ret
    panic("raid: phys_write bad disk");
    80006a8e:	00003517          	auipc	a0,0x3
    80006a92:	cca50513          	addi	a0,a0,-822 # 80009758 <etext+0x758>
    80006a96:	d8ff90ef          	jal	80000824 <panic>
    panic("raid: phys_write block out of range");
    80006a9a:	00003517          	auipc	a0,0x3
    80006a9e:	cde50513          	addi	a0,a0,-802 # 80009778 <etext+0x778>
    80006aa2:	d83f90ef          	jal	80000824 <panic>
  memmove(sim_disk[disk_id][blk], src, BSIZE);
    80006aa6:	0526                	slli	a0,a0,0x9
    80006aa8:	1782                	slli	a5,a5,0x20
    80006aaa:	9381                	srli	a5,a5,0x20
    80006aac:	953e                	add	a0,a0,a5
    80006aae:	052a                	slli	a0,a0,0xa
    80006ab0:	40000613          	li	a2,1024
    80006ab4:	00020797          	auipc	a5,0x20
    80006ab8:	0cc78793          	addi	a5,a5,204 # 80026b80 <sim_disk>
    80006abc:	953e                	add	a0,a0,a5
    80006abe:	f74fa0ef          	jal	80001232 <memmove>
    80006ac2:	b7d1                	j	80006a86 <phys_write_block+0x2c>

0000000080006ac4 <phys_read_block>:
{
    80006ac4:	1101                	addi	sp,sp,-32
    80006ac6:	ec06                	sd	ra,24(sp)
    80006ac8:	e822                	sd	s0,16(sp)
    80006aca:	e426                	sd	s1,8(sp)
    80006acc:	1000                	addi	s0,sp,32
    80006ace:	87aa                	mv	a5,a0
  if(disk_id < 0 || disk_id >= NUM_DISKS)
    80006ad0:	470d                	li	a4,3
    80006ad2:	04a76463          	bltu	a4,a0,80006b1a <phys_read_block+0x56>
    80006ad6:	8532                	mv	a0,a2
  if(blk >= DISK_BLOCKS)
    80006ad8:	1ff00713          	li	a4,511
    80006adc:	04b76563          	bltu	a4,a1,80006b26 <phys_read_block+0x62>
  if(disk_failed[disk_id])
    80006ae0:	00279693          	slli	a3,a5,0x2
    80006ae4:	0001f717          	auipc	a4,0x1f
    80006ae8:	07470713          	addi	a4,a4,116 # 80025b58 <disk_failed>
    80006aec:	9736                	add	a4,a4,a3
    80006aee:	4304                	lw	s1,0(a4)
    80006af0:	e0a9                	bnez	s1,80006b32 <phys_read_block+0x6e>
  memmove(dst, sim_disk[disk_id][blk], BSIZE);
    80006af2:	07a6                	slli	a5,a5,0x9
    80006af4:	1582                	slli	a1,a1,0x20
    80006af6:	9181                	srli	a1,a1,0x20
    80006af8:	97ae                	add	a5,a5,a1
    80006afa:	07aa                	slli	a5,a5,0xa
    80006afc:	40000613          	li	a2,1024
    80006b00:	00020597          	auipc	a1,0x20
    80006b04:	08058593          	addi	a1,a1,128 # 80026b80 <sim_disk>
    80006b08:	95be                	add	a1,a1,a5
    80006b0a:	f28fa0ef          	jal	80001232 <memmove>
}
    80006b0e:	8526                	mv	a0,s1
    80006b10:	60e2                	ld	ra,24(sp)
    80006b12:	6442                	ld	s0,16(sp)
    80006b14:	64a2                	ld	s1,8(sp)
    80006b16:	6105                	addi	sp,sp,32
    80006b18:	8082                	ret
    panic("raid: phys_read bad disk");
    80006b1a:	00003517          	auipc	a0,0x3
    80006b1e:	c8650513          	addi	a0,a0,-890 # 800097a0 <etext+0x7a0>
    80006b22:	d03f90ef          	jal	80000824 <panic>
    panic("raid: phys_read block out of range");
    80006b26:	00003517          	auipc	a0,0x3
    80006b2a:	c9a50513          	addi	a0,a0,-870 # 800097c0 <etext+0x7c0>
    80006b2e:	cf7f90ef          	jal	80000824 <panic>
    return -1;
    80006b32:	54fd                	li	s1,-1
    80006b34:	bfe9                	j	80006b0e <phys_read_block+0x4a>

0000000080006b36 <raid0_read>:
  phys_write_block(lb % NUM_DISKS, lb / NUM_DISKS, src);
}

static void
raid0_read(uint32 lb, char *dst)
{
    80006b36:	1141                	addi	sp,sp,-16
    80006b38:	e406                	sd	ra,8(sp)
    80006b3a:	e022                	sd	s0,0(sp)
    80006b3c:	0800                	addi	s0,sp,16
    80006b3e:	862e                	mv	a2,a1
  if(phys_read_block(lb % NUM_DISKS, lb / NUM_DISKS, dst) < 0)
    80006b40:	0025559b          	srliw	a1,a0,0x2
    80006b44:	890d                	andi	a0,a0,3
    80006b46:	f7fff0ef          	jal	80006ac4 <phys_read_block>
    80006b4a:	00054663          	bltz	a0,80006b56 <raid0_read+0x20>
    panic("raid0: disk failed");
}
    80006b4e:	60a2                	ld	ra,8(sp)
    80006b50:	6402                	ld	s0,0(sp)
    80006b52:	0141                	addi	sp,sp,16
    80006b54:	8082                	ret
    panic("raid0: disk failed");
    80006b56:	00003517          	auipc	a0,0x3
    80006b5a:	c9250513          	addi	a0,a0,-878 # 800097e8 <etext+0x7e8>
    80006b5e:	cc7f90ef          	jal	80000824 <panic>

0000000080006b62 <raid1_read>:
  phys_write_block(1, lb, src);
}

static void
raid1_read(uint32 lb, char *dst)
{
    80006b62:	1101                	addi	sp,sp,-32
    80006b64:	ec06                	sd	ra,24(sp)
    80006b66:	e822                	sd	s0,16(sp)
    80006b68:	e426                	sd	s1,8(sp)
    80006b6a:	e04a                	sd	s2,0(sp)
    80006b6c:	1000                	addi	s0,sp,32
    80006b6e:	84aa                	mv	s1,a0
    80006b70:	892e                	mv	s2,a1
  if(phys_read_block(0, lb, dst) == 0) return;
    80006b72:	862e                	mv	a2,a1
    80006b74:	85aa                	mv	a1,a0
    80006b76:	4501                	li	a0,0
    80006b78:	f4dff0ef          	jal	80006ac4 <phys_read_block>
    80006b7c:	e519                	bnez	a0,80006b8a <raid1_read+0x28>
  if(phys_read_block(1, lb, dst) == 0) return;
  panic("raid1: both mirrors failed");
}
    80006b7e:	60e2                	ld	ra,24(sp)
    80006b80:	6442                	ld	s0,16(sp)
    80006b82:	64a2                	ld	s1,8(sp)
    80006b84:	6902                	ld	s2,0(sp)
    80006b86:	6105                	addi	sp,sp,32
    80006b88:	8082                	ret
  if(phys_read_block(1, lb, dst) == 0) return;
    80006b8a:	864a                	mv	a2,s2
    80006b8c:	85a6                	mv	a1,s1
    80006b8e:	4505                	li	a0,1
    80006b90:	f35ff0ef          	jal	80006ac4 <phys_read_block>
    80006b94:	d56d                	beqz	a0,80006b7e <raid1_read+0x1c>
  panic("raid1: both mirrors failed");
    80006b96:	00003517          	auipc	a0,0x3
    80006b9a:	c6a50513          	addi	a0,a0,-918 # 80009800 <etext+0x800>
    80006b9e:	c87f90ef          	jal	80000824 <panic>

0000000080006ba2 <raid5_read>:
  phys_write_block(par_d, stripe, parity);
}

static void
raid5_read(uint32 lb, char *dst)
{
    80006ba2:	81010113          	addi	sp,sp,-2032
    80006ba6:	7e113423          	sd	ra,2024(sp)
    80006baa:	7e813023          	sd	s0,2016(sp)
    80006bae:	7c913c23          	sd	s1,2008(sp)
    80006bb2:	7d213823          	sd	s2,2000(sp)
    80006bb6:	7d313423          	sd	s3,1992(sp)
    80006bba:	7d413023          	sd	s4,1984(sp)
    80006bbe:	7b513c23          	sd	s5,1976(sp)
    80006bc2:	7b613823          	sd	s6,1968(sp)
    80006bc6:	7b713423          	sd	s7,1960(sp)
    80006bca:	7b813023          	sd	s8,1952(sp)
    80006bce:	7f010413          	addi	s0,sp,2032
    80006bd2:	ba010113          	addi	sp,sp,-1120
    80006bd6:	862e                	mv	a2,a1
    80006bd8:	8c2e                	mv	s8,a1
  uint32 stripe   = lb / DATA_DISKS;
    80006bda:	02051493          	slli	s1,a0,0x20
    80006bde:	9081                	srli	s1,s1,0x20
    80006be0:	000ab7b7          	lui	a5,0xab
    80006be4:	aab78793          	addi	a5,a5,-1365 # aaaab <_entry-0x7ff55555>
    80006be8:	07b2                	slli	a5,a5,0xc
    80006bea:	aab78793          	addi	a5,a5,-1365
    80006bee:	02f484b3          	mul	s1,s1,a5
    80006bf2:	9085                	srli	s1,s1,0x21
static int raid5_parity_disk(uint32 stripe){ return stripe % NUM_DISKS; }
    80006bf4:	0034f913          	andi	s2,s1,3
  int    data_idx = lb % DATA_DISKS;
    80006bf8:	0014979b          	slliw	a5,s1,0x1
    80006bfc:	9fa5                	addw	a5,a5,s1
    80006bfe:	9d1d                	subw	a0,a0,a5
static int raid5_data_disk(uint32 stripe, int d){ return (raid5_parity_disk(stripe) + 1 + d) % NUM_DISKS; }
    80006c00:	0019079b          	addiw	a5,s2,1
    80006c04:	9fa9                	addw	a5,a5,a0
    80006c06:	41f7d71b          	sraiw	a4,a5,0x1f
    80006c0a:	01e7571b          	srliw	a4,a4,0x1e
    80006c0e:	00f7053b          	addw	a0,a4,a5
    80006c12:	890d                	andi	a0,a0,3
    80006c14:	9d19                	subw	a0,a0,a4
    80006c16:	8baa                	mv	s7,a0
  int    this_d   = raid5_data_disk(stripe, data_idx);
  int    par_d    = raid5_parity_disk(stripe);

  // Fast path: target disk healthy
  if(phys_read_block(this_d, stripe, dst) == 0)
    80006c18:	85a6                	mv	a1,s1
    80006c1a:	eabff0ef          	jal	80006ac4 <phys_read_block>
    80006c1e:	e915                	bnez	a0,80006c52 <raid5_read+0xb0>
  char ptmp[BSIZE];
  if(phys_read_block(par_d, stripe, ptmp) < 0)
    panic("raid5: parity disk also failed");
  xor_block(rec, ptmp);
  memmove(dst, rec, BSIZE);
}
    80006c20:	46010113          	addi	sp,sp,1120
    80006c24:	7e813083          	ld	ra,2024(sp)
    80006c28:	7e013403          	ld	s0,2016(sp)
    80006c2c:	7d813483          	ld	s1,2008(sp)
    80006c30:	7d013903          	ld	s2,2000(sp)
    80006c34:	7c813983          	ld	s3,1992(sp)
    80006c38:	7c013a03          	ld	s4,1984(sp)
    80006c3c:	7b813a83          	ld	s5,1976(sp)
    80006c40:	7b013b03          	ld	s6,1968(sp)
    80006c44:	7a813b83          	ld	s7,1960(sp)
    80006c48:	7a013c03          	ld	s8,1952(sp)
    80006c4c:	7f010113          	addi	sp,sp,2032
    80006c50:	8082                	ret
  memset(rec, 0, BSIZE);
    80006c52:	40000613          	li	a2,1024
    80006c56:	4581                	li	a1,0
    80006c58:	bb040513          	addi	a0,s0,-1104
    80006c5c:	d76fa0ef          	jal	800011d2 <memset>
  for(int d = 0; d < DATA_DISKS; d++){
    80006c60:	00190993          	addi	s3,s2,1
    80006c64:	00490a93          	addi	s5,s2,4
    if(phys_read_block(disk, stripe, tmp) < 0)
    80006c68:	80040a13          	addi	s4,s0,-2048
    80006c6c:	fb0a0a13          	addi	s4,s4,-80
    80006c70:	c00a0a13          	addi	s4,s4,-1024
    xor_block(rec, tmp);
    80006c74:	bb040b13          	addi	s6,s0,-1104
    80006c78:	a811                	j	80006c8c <raid5_read+0xea>
      panic("raid5: two disks failed");
    80006c7a:	00003517          	auipc	a0,0x3
    80006c7e:	ba650513          	addi	a0,a0,-1114 # 80009820 <etext+0x820>
    80006c82:	ba3f90ef          	jal	80000824 <panic>
  for(int d = 0; d < DATA_DISKS; d++){
    80006c86:	2985                	addiw	s3,s3,1
    80006c88:	03598763          	beq	s3,s5,80006cb6 <raid5_read+0x114>
static int raid5_data_disk(uint32 stripe, int d){ return (raid5_parity_disk(stripe) + 1 + d) % NUM_DISKS; }
    80006c8c:	41f9d79b          	sraiw	a5,s3,0x1f
    80006c90:	01e7d79b          	srliw	a5,a5,0x1e
    80006c94:	0137853b          	addw	a0,a5,s3
    80006c98:	890d                	andi	a0,a0,3
    80006c9a:	9d1d                	subw	a0,a0,a5
    if(disk == this_d) continue;
    80006c9c:	feab85e3          	beq	s7,a0,80006c86 <raid5_read+0xe4>
    if(phys_read_block(disk, stripe, tmp) < 0)
    80006ca0:	8652                	mv	a2,s4
    80006ca2:	85a6                	mv	a1,s1
    80006ca4:	e21ff0ef          	jal	80006ac4 <phys_read_block>
    80006ca8:	fc0549e3          	bltz	a0,80006c7a <raid5_read+0xd8>
    xor_block(rec, tmp);
    80006cac:	85d2                	mv	a1,s4
    80006cae:	855a                	mv	a0,s6
    80006cb0:	d7fff0ef          	jal	80006a2e <xor_block>
    80006cb4:	bfc9                	j	80006c86 <raid5_read+0xe4>
  if(phys_read_block(par_d, stripe, ptmp) < 0)
    80006cb6:	80040613          	addi	a2,s0,-2048
    80006cba:	fb060613          	addi	a2,a2,-80
    80006cbe:	85a6                	mv	a1,s1
    80006cc0:	854a                	mv	a0,s2
    80006cc2:	e03ff0ef          	jal	80006ac4 <phys_read_block>
    80006cc6:	02054263          	bltz	a0,80006cea <raid5_read+0x148>
  xor_block(rec, ptmp);
    80006cca:	bb040493          	addi	s1,s0,-1104
    80006cce:	80040593          	addi	a1,s0,-2048
    80006cd2:	fb058593          	addi	a1,a1,-80
    80006cd6:	8526                	mv	a0,s1
    80006cd8:	d57ff0ef          	jal	80006a2e <xor_block>
  memmove(dst, rec, BSIZE);
    80006cdc:	40000613          	li	a2,1024
    80006ce0:	85a6                	mv	a1,s1
    80006ce2:	8562                	mv	a0,s8
    80006ce4:	d4efa0ef          	jal	80001232 <memmove>
    80006ce8:	bf25                	j	80006c20 <raid5_read+0x7e>
    panic("raid5: parity disk also failed");
    80006cea:	00003517          	auipc	a0,0x3
    80006cee:	b4e50513          	addi	a0,a0,-1202 # 80009838 <etext+0x838>
    80006cf2:	b33f90ef          	jal	80000824 <panic>

0000000080006cf6 <raid5_write>:
{
    80006cf6:	715d                	addi	sp,sp,-80
    80006cf8:	e486                	sd	ra,72(sp)
    80006cfa:	e0a2                	sd	s0,64(sp)
    80006cfc:	fc26                	sd	s1,56(sp)
    80006cfe:	f84a                	sd	s2,48(sp)
    80006d00:	f44e                	sd	s3,40(sp)
    80006d02:	f052                	sd	s4,32(sp)
    80006d04:	ec56                	sd	s5,24(sp)
    80006d06:	0880                	addi	s0,sp,80
    80006d08:	81010113          	addi	sp,sp,-2032
    80006d0c:	862e                	mv	a2,a1
  uint32 stripe   = lb / DATA_DISKS;
    80006d0e:	02051913          	slli	s2,a0,0x20
    80006d12:	02095913          	srli	s2,s2,0x20
    80006d16:	000ab7b7          	lui	a5,0xab
    80006d1a:	aab78793          	addi	a5,a5,-1365 # aaaab <_entry-0x7ff55555>
    80006d1e:	07b2                	slli	a5,a5,0xc
    80006d20:	aab78793          	addi	a5,a5,-1365
    80006d24:	02f90933          	mul	s2,s2,a5
    80006d28:	02195913          	srli	s2,s2,0x21
static int raid5_parity_disk(uint32 stripe){ return stripe % NUM_DISKS; }
    80006d2c:	00397993          	andi	s3,s2,3
  int    data_idx = lb % DATA_DISKS;
    80006d30:	0019179b          	slliw	a5,s2,0x1
    80006d34:	012787bb          	addw	a5,a5,s2
    80006d38:	9d1d                	subw	a0,a0,a5
static int raid5_data_disk(uint32 stripe, int d){ return (raid5_parity_disk(stripe) + 1 + d) % NUM_DISKS; }
    80006d3a:	0019849b          	addiw	s1,s3,1
    80006d3e:	00a487bb          	addw	a5,s1,a0
    80006d42:	41f7d51b          	sraiw	a0,a5,0x1f
    80006d46:	01e5551b          	srliw	a0,a0,0x1e
    80006d4a:	9fa9                	addw	a5,a5,a0
    80006d4c:	8b8d                	andi	a5,a5,3
  phys_write_block(this_d, stripe, src);
    80006d4e:	85ca                	mv	a1,s2
    80006d50:	40a7853b          	subw	a0,a5,a0
    80006d54:	d07ff0ef          	jal	80006a5a <phys_write_block>
  memset(parity, 0, BSIZE);
    80006d58:	40000613          	li	a2,1024
    80006d5c:	4581                	li	a1,0
    80006d5e:	bc040513          	addi	a0,s0,-1088
    80006d62:	c70fa0ef          	jal	800011d2 <memset>
  for(int d = 0; d < DATA_DISKS; d++){
    80006d66:	00498a93          	addi	s5,s3,4
    if(phys_read_block(disk, stripe, tmp) == 0)
    80006d6a:	80040a13          	addi	s4,s0,-2048
    80006d6e:	fc0a0a13          	addi	s4,s4,-64
static int raid5_data_disk(uint32 stripe, int d){ return (raid5_parity_disk(stripe) + 1 + d) % NUM_DISKS; }
    80006d72:	41f4d79b          	sraiw	a5,s1,0x1f
    80006d76:	01e7d79b          	srliw	a5,a5,0x1e
    80006d7a:	0097853b          	addw	a0,a5,s1
    80006d7e:	890d                	andi	a0,a0,3
    if(phys_read_block(disk, stripe, tmp) == 0)
    80006d80:	8652                	mv	a2,s4
    80006d82:	85ca                	mv	a1,s2
    80006d84:	9d1d                	subw	a0,a0,a5
    80006d86:	d3fff0ef          	jal	80006ac4 <phys_read_block>
    80006d8a:	c50d                	beqz	a0,80006db4 <raid5_write+0xbe>
  for(int d = 0; d < DATA_DISKS; d++){
    80006d8c:	2485                	addiw	s1,s1,1
    80006d8e:	ff5492e3          	bne	s1,s5,80006d72 <raid5_write+0x7c>
  phys_write_block(par_d, stripe, parity);
    80006d92:	bc040613          	addi	a2,s0,-1088
    80006d96:	85ca                	mv	a1,s2
    80006d98:	854e                	mv	a0,s3
    80006d9a:	cc1ff0ef          	jal	80006a5a <phys_write_block>
}
    80006d9e:	7f010113          	addi	sp,sp,2032
    80006da2:	60a6                	ld	ra,72(sp)
    80006da4:	6406                	ld	s0,64(sp)
    80006da6:	74e2                	ld	s1,56(sp)
    80006da8:	7942                	ld	s2,48(sp)
    80006daa:	79a2                	ld	s3,40(sp)
    80006dac:	7a02                	ld	s4,32(sp)
    80006dae:	6ae2                	ld	s5,24(sp)
    80006db0:	6161                	addi	sp,sp,80
    80006db2:	8082                	ret
      xor_block(parity, tmp);
    80006db4:	80040593          	addi	a1,s0,-2048
    80006db8:	fc058593          	addi	a1,a1,-64
    80006dbc:	bc040513          	addi	a0,s0,-1088
    80006dc0:	c6fff0ef          	jal	80006a2e <xor_block>
    80006dc4:	b7e1                	j	80006d8c <raid5_write+0x96>

0000000080006dc6 <raid_init>:

void
raid_init(void)
{
    80006dc6:	1101                	addi	sp,sp,-32
    80006dc8:	ec06                	sd	ra,24(sp)
    80006dca:	e822                	sd	s0,16(sp)
    80006dcc:	e426                	sd	s1,8(sp)
    80006dce:	1000                	addi	s0,sp,32
  initlock(&raid_lock, "raid");
    80006dd0:	0001f497          	auipc	s1,0x1f
    80006dd4:	d8848493          	addi	s1,s1,-632 # 80025b58 <disk_failed>
    80006dd8:	00003597          	auipc	a1,0x3
    80006ddc:	a8058593          	addi	a1,a1,-1408 # 80009858 <etext+0x858>
    80006de0:	0001f517          	auipc	a0,0x1f
    80006de4:	d8850513          	addi	a0,a0,-632 # 80025b68 <raid_lock>
    80006de8:	a90fa0ef          	jal	80001078 <initlock>
  raid_mode = RAID_MODE_0;
    80006dec:	00003797          	auipc	a5,0x3
    80006df0:	d007a823          	sw	zero,-752(a5) # 80009afc <raid_mode>
  for(int d = 0; d < NUM_DISKS; d++)
    disk_failed[d] = 0;
    80006df4:	0004a023          	sw	zero,0(s1)
    80006df8:	0004a223          	sw	zero,4(s1)
    80006dfc:	0004a423          	sw	zero,8(s1)
    80006e00:	0004a623          	sw	zero,12(s1)
  memset(sim_disk, 0, sizeof(sim_disk));
    80006e04:	00200637          	lui	a2,0x200
    80006e08:	4581                	li	a1,0
    80006e0a:	00020517          	auipc	a0,0x20
    80006e0e:	d7650513          	addi	a0,a0,-650 # 80026b80 <sim_disk>
    80006e12:	bc0fa0ef          	jal	800011d2 <memset>
}
    80006e16:	60e2                	ld	ra,24(sp)
    80006e18:	6442                	ld	s0,16(sp)
    80006e1a:	64a2                	ld	s1,8(sp)
    80006e1c:	6105                	addi	sp,sp,32
    80006e1e:	8082                	ret

0000000080006e20 <raid_setmode>:

void
raid_setmode(int mode)
{
    80006e20:	1101                	addi	sp,sp,-32
    80006e22:	ec06                	sd	ra,24(sp)
    80006e24:	e822                	sd	s0,16(sp)
    80006e26:	e426                	sd	s1,8(sp)
    80006e28:	1000                	addi	s0,sp,32
    80006e2a:	84aa                	mv	s1,a0
  if(mode != RAID_MODE_0 && mode != RAID_MODE_1 && mode != RAID_MODE_5)
    80006e2c:	4785                	li	a5,1
    80006e2e:	00a7f563          	bgeu	a5,a0,80006e38 <raid_setmode+0x18>
    80006e32:	ffb50793          	addi	a5,a0,-5
    80006e36:	e795                	bnez	a5,80006e62 <raid_setmode+0x42>
    panic("raid_setmode: invalid mode");
  acquire(&raid_lock);
    80006e38:	0001f517          	auipc	a0,0x1f
    80006e3c:	d3050513          	addi	a0,a0,-720 # 80025b68 <raid_lock>
    80006e40:	ac2fa0ef          	jal	80001102 <acquire>
  raid_mode = mode;
    80006e44:	00003797          	auipc	a5,0x3
    80006e48:	ca97ac23          	sw	s1,-840(a5) # 80009afc <raid_mode>
  release(&raid_lock);
    80006e4c:	0001f517          	auipc	a0,0x1f
    80006e50:	d1c50513          	addi	a0,a0,-740 # 80025b68 <raid_lock>
    80006e54:	b42fa0ef          	jal	80001196 <release>
}
    80006e58:	60e2                	ld	ra,24(sp)
    80006e5a:	6442                	ld	s0,16(sp)
    80006e5c:	64a2                	ld	s1,8(sp)
    80006e5e:	6105                	addi	sp,sp,32
    80006e60:	8082                	ret
    panic("raid_setmode: invalid mode");
    80006e62:	00003517          	auipc	a0,0x3
    80006e66:	9fe50513          	addi	a0,a0,-1538 # 80009860 <etext+0x860>
    80006e6a:	9bbf90ef          	jal	80000824 <panic>

0000000080006e6e <raid_getmode>:

int
raid_getmode(void)
{
    80006e6e:	1141                	addi	sp,sp,-16
    80006e70:	e406                	sd	ra,8(sp)
    80006e72:	e022                	sd	s0,0(sp)
    80006e74:	0800                	addi	s0,sp,16
  return raid_mode;
}
    80006e76:	00003517          	auipc	a0,0x3
    80006e7a:	c8652503          	lw	a0,-890(a0) # 80009afc <raid_mode>
    80006e7e:	60a2                	ld	ra,8(sp)
    80006e80:	6402                	ld	s0,0(sp)
    80006e82:	0141                	addi	sp,sp,16
    80006e84:	8082                	ret

0000000080006e86 <raid_fail_disk>:

void
raid_fail_disk(int d)
{
    80006e86:	1101                	addi	sp,sp,-32
    80006e88:	ec06                	sd	ra,24(sp)
    80006e8a:	e822                	sd	s0,16(sp)
    80006e8c:	e426                	sd	s1,8(sp)
    80006e8e:	1000                	addi	s0,sp,32
  if(d < 0 || d >= NUM_DISKS) panic("raid_fail_disk");
    80006e90:	478d                	li	a5,3
    80006e92:	02a7ec63          	bltu	a5,a0,80006eca <raid_fail_disk+0x44>
    80006e96:	84aa                	mv	s1,a0
  acquire(&raid_lock);
    80006e98:	0001f517          	auipc	a0,0x1f
    80006e9c:	cd050513          	addi	a0,a0,-816 # 80025b68 <raid_lock>
    80006ea0:	a62fa0ef          	jal	80001102 <acquire>
  disk_failed[d] = 1;
    80006ea4:	048a                	slli	s1,s1,0x2
    80006ea6:	0001f797          	auipc	a5,0x1f
    80006eaa:	cb278793          	addi	a5,a5,-846 # 80025b58 <disk_failed>
    80006eae:	97a6                	add	a5,a5,s1
    80006eb0:	4705                	li	a4,1
    80006eb2:	c398                	sw	a4,0(a5)
  release(&raid_lock);
    80006eb4:	0001f517          	auipc	a0,0x1f
    80006eb8:	cb450513          	addi	a0,a0,-844 # 80025b68 <raid_lock>
    80006ebc:	adafa0ef          	jal	80001196 <release>
}
    80006ec0:	60e2                	ld	ra,24(sp)
    80006ec2:	6442                	ld	s0,16(sp)
    80006ec4:	64a2                	ld	s1,8(sp)
    80006ec6:	6105                	addi	sp,sp,32
    80006ec8:	8082                	ret
  if(d < 0 || d >= NUM_DISKS) panic("raid_fail_disk");
    80006eca:	00003517          	auipc	a0,0x3
    80006ece:	9b650513          	addi	a0,a0,-1610 # 80009880 <etext+0x880>
    80006ed2:	953f90ef          	jal	80000824 <panic>

0000000080006ed6 <raid_restore_disk>:

void
raid_restore_disk(int d)
{
    80006ed6:	1101                	addi	sp,sp,-32
    80006ed8:	ec06                	sd	ra,24(sp)
    80006eda:	e822                	sd	s0,16(sp)
    80006edc:	e426                	sd	s1,8(sp)
    80006ede:	1000                	addi	s0,sp,32
  if(d < 0 || d >= NUM_DISKS) panic("raid_restore_disk");
    80006ee0:	478d                	li	a5,3
    80006ee2:	02a7ec63          	bltu	a5,a0,80006f1a <raid_restore_disk+0x44>
    80006ee6:	84aa                	mv	s1,a0
  acquire(&raid_lock);
    80006ee8:	0001f517          	auipc	a0,0x1f
    80006eec:	c8050513          	addi	a0,a0,-896 # 80025b68 <raid_lock>
    80006ef0:	a12fa0ef          	jal	80001102 <acquire>
  disk_failed[d] = 0;
    80006ef4:	048a                	slli	s1,s1,0x2
    80006ef6:	0001f797          	auipc	a5,0x1f
    80006efa:	c6278793          	addi	a5,a5,-926 # 80025b58 <disk_failed>
    80006efe:	97a6                	add	a5,a5,s1
    80006f00:	0007a023          	sw	zero,0(a5)
  release(&raid_lock);
    80006f04:	0001f517          	auipc	a0,0x1f
    80006f08:	c6450513          	addi	a0,a0,-924 # 80025b68 <raid_lock>
    80006f0c:	a8afa0ef          	jal	80001196 <release>
}
    80006f10:	60e2                	ld	ra,24(sp)
    80006f12:	6442                	ld	s0,16(sp)
    80006f14:	64a2                	ld	s1,8(sp)
    80006f16:	6105                	addi	sp,sp,32
    80006f18:	8082                	ret
  if(d < 0 || d >= NUM_DISKS) panic("raid_restore_disk");
    80006f1a:	00003517          	auipc	a0,0x3
    80006f1e:	97650513          	addi	a0,a0,-1674 # 80009890 <etext+0x890>
    80006f22:	903f90ef          	jal	80000824 <panic>

0000000080006f26 <raid_write>:

void
raid_write(uint32 lblock, char *src)
{
    80006f26:	7139                	addi	sp,sp,-64
    80006f28:	fc06                	sd	ra,56(sp)
    80006f2a:	f822                	sd	s0,48(sp)
    80006f2c:	f426                	sd	s1,40(sp)
    80006f2e:	f04a                	sd	s2,32(sp)
    80006f30:	ec4e                	sd	s3,24(sp)
    80006f32:	e852                	sd	s4,16(sp)
    80006f34:	e456                	sd	s5,8(sp)
    80006f36:	e05a                	sd	s6,0(sp)
    80006f38:	0080                	addi	s0,sp,64
    80006f3a:	892a                	mv	s2,a0
    80006f3c:	89ae                	mv	s3,a1
  acquire(&raid_lock);
    80006f3e:	0001f517          	auipc	a0,0x1f
    80006f42:	c2a50513          	addi	a0,a0,-982 # 80025b68 <raid_lock>
    80006f46:	9bcfa0ef          	jal	80001102 <acquire>
  for(int i = 0; i < BLOCKS_PER_PAGE; i++){
    80006f4a:	84ce                	mv	s1,s3
    80006f4c:	6785                	lui	a5,0x1
    80006f4e:	99be                	add	s3,s3,a5
    uint32 lb = lblock + i;
    char  *s  = src + i * BSIZE;
    switch(raid_mode){
    80006f50:	00003a97          	auipc	s5,0x3
    80006f54:	baca8a93          	addi	s5,s5,-1108 # 80009afc <raid_mode>
    80006f58:	4a05                	li	s4,1
    80006f5a:	4b15                	li	s6,5
    80006f5c:	a005                	j	80006f7c <raid_write+0x56>
  phys_write_block(0, lb, src);
    80006f5e:	8626                	mv	a2,s1
    80006f60:	85ca                	mv	a1,s2
    80006f62:	4501                	li	a0,0
    80006f64:	af7ff0ef          	jal	80006a5a <phys_write_block>
  phys_write_block(1, lb, src);
    80006f68:	8626                	mv	a2,s1
    80006f6a:	85ca                	mv	a1,s2
    80006f6c:	8552                	mv	a0,s4
    80006f6e:	aedff0ef          	jal	80006a5a <phys_write_block>
  for(int i = 0; i < BLOCKS_PER_PAGE; i++){
    80006f72:	2905                	addiw	s2,s2,1
    80006f74:	40048493          	addi	s1,s1,1024
    80006f78:	03348c63          	beq	s1,s3,80006fb0 <raid_write+0x8a>
    char  *s  = src + i * BSIZE;
    80006f7c:	85a6                	mv	a1,s1
    switch(raid_mode){
    80006f7e:	000aa783          	lw	a5,0(s5)
    80006f82:	fd478ee3          	beq	a5,s4,80006f5e <raid_write+0x38>
    80006f86:	01678b63          	beq	a5,s6,80006f9c <raid_write+0x76>
    80006f8a:	ef89                	bnez	a5,80006fa4 <raid_write+0x7e>
  phys_write_block(lb % NUM_DISKS, lb / NUM_DISKS, src);
    80006f8c:	8626                	mv	a2,s1
    80006f8e:	0029559b          	srliw	a1,s2,0x2
    80006f92:	00397513          	andi	a0,s2,3
    80006f96:	ac5ff0ef          	jal	80006a5a <phys_write_block>
}
    80006f9a:	bfe1                	j	80006f72 <raid_write+0x4c>
      case RAID_MODE_0: raid0_write(lb, s); break;
      case RAID_MODE_1: raid1_write(lb, s); break;
      case RAID_MODE_5: raid5_write(lb, s); break;
    80006f9c:	854a                	mv	a0,s2
    80006f9e:	d59ff0ef          	jal	80006cf6 <raid5_write>
    80006fa2:	bfc1                	j	80006f72 <raid_write+0x4c>
      default: panic("raid_write: bad mode");
    80006fa4:	00003517          	auipc	a0,0x3
    80006fa8:	90450513          	addi	a0,a0,-1788 # 800098a8 <etext+0x8a8>
    80006fac:	879f90ef          	jal	80000824 <panic>
    }
  }
  release(&raid_lock);
    80006fb0:	0001f517          	auipc	a0,0x1f
    80006fb4:	bb850513          	addi	a0,a0,-1096 # 80025b68 <raid_lock>
    80006fb8:	9defa0ef          	jal	80001196 <release>
}
    80006fbc:	70e2                	ld	ra,56(sp)
    80006fbe:	7442                	ld	s0,48(sp)
    80006fc0:	74a2                	ld	s1,40(sp)
    80006fc2:	7902                	ld	s2,32(sp)
    80006fc4:	69e2                	ld	s3,24(sp)
    80006fc6:	6a42                	ld	s4,16(sp)
    80006fc8:	6aa2                	ld	s5,8(sp)
    80006fca:	6b02                	ld	s6,0(sp)
    80006fcc:	6121                	addi	sp,sp,64
    80006fce:	8082                	ret

0000000080006fd0 <raid_read>:

void
raid_read(uint32 lblock, char *dst)
{
    80006fd0:	7139                	addi	sp,sp,-64
    80006fd2:	fc06                	sd	ra,56(sp)
    80006fd4:	f822                	sd	s0,48(sp)
    80006fd6:	f426                	sd	s1,40(sp)
    80006fd8:	f04a                	sd	s2,32(sp)
    80006fda:	ec4e                	sd	s3,24(sp)
    80006fdc:	e852                	sd	s4,16(sp)
    80006fde:	e456                	sd	s5,8(sp)
    80006fe0:	e05a                	sd	s6,0(sp)
    80006fe2:	0080                	addi	s0,sp,64
    80006fe4:	892a                	mv	s2,a0
    80006fe6:	89ae                	mv	s3,a1
  acquire(&raid_lock);
    80006fe8:	0001f517          	auipc	a0,0x1f
    80006fec:	b8050513          	addi	a0,a0,-1152 # 80025b68 <raid_lock>
    80006ff0:	912fa0ef          	jal	80001102 <acquire>
  for(int i = 0; i < BLOCKS_PER_PAGE; i++){
    80006ff4:	84ce                	mv	s1,s3
    80006ff6:	6785                	lui	a5,0x1
    80006ff8:	99be                	add	s3,s3,a5
    uint32 lb = lblock + i;
    char  *d  = dst + i * BSIZE;
    switch(raid_mode){
    80006ffa:	00003a97          	auipc	s5,0x3
    80006ffe:	b02a8a93          	addi	s5,s5,-1278 # 80009afc <raid_mode>
    80007002:	4a05                	li	s4,1
    80007004:	4b15                	li	s6,5
    80007006:	a809                	j	80007018 <raid_read+0x48>
      case RAID_MODE_0: raid0_read(lb, d); break;
      case RAID_MODE_1: raid1_read(lb, d); break;
    80007008:	854a                	mv	a0,s2
    8000700a:	b59ff0ef          	jal	80006b62 <raid1_read>
  for(int i = 0; i < BLOCKS_PER_PAGE; i++){
    8000700e:	2905                	addiw	s2,s2,1
    80007010:	40048493          	addi	s1,s1,1024
    80007014:	03348863          	beq	s1,s3,80007044 <raid_read+0x74>
    char  *d  = dst + i * BSIZE;
    80007018:	85a6                	mv	a1,s1
    switch(raid_mode){
    8000701a:	000aa783          	lw	a5,0(s5)
    8000701e:	ff4785e3          	beq	a5,s4,80007008 <raid_read+0x38>
    80007022:	01678763          	beq	a5,s6,80007030 <raid_read+0x60>
    80007026:	eb89                	bnez	a5,80007038 <raid_read+0x68>
      case RAID_MODE_0: raid0_read(lb, d); break;
    80007028:	854a                	mv	a0,s2
    8000702a:	b0dff0ef          	jal	80006b36 <raid0_read>
    8000702e:	b7c5                	j	8000700e <raid_read+0x3e>
      case RAID_MODE_5: raid5_read(lb, d); break;
    80007030:	854a                	mv	a0,s2
    80007032:	b71ff0ef          	jal	80006ba2 <raid5_read>
    80007036:	bfe1                	j	8000700e <raid_read+0x3e>
      default: panic("raid_read: bad mode");
    80007038:	00003517          	auipc	a0,0x3
    8000703c:	88850513          	addi	a0,a0,-1912 # 800098c0 <etext+0x8c0>
    80007040:	fe4f90ef          	jal	80000824 <panic>
    }
  }
  release(&raid_lock);
    80007044:	0001f517          	auipc	a0,0x1f
    80007048:	b2450513          	addi	a0,a0,-1244 # 80025b68 <raid_lock>
    8000704c:	94afa0ef          	jal	80001196 <release>
}
    80007050:	70e2                	ld	ra,56(sp)
    80007052:	7442                	ld	s0,48(sp)
    80007054:	74a2                	ld	s1,40(sp)
    80007056:	7902                	ld	s2,32(sp)
    80007058:	69e2                	ld	s3,24(sp)
    8000705a:	6a42                	ld	s4,16(sp)
    8000705c:	6aa2                	ld	s5,8(sp)
    8000705e:	6b02                	ld	s6,0(sp)
    80007060:	6121                	addi	sp,sp,64
    80007062:	8082                	ret

0000000080007064 <raid_copy>:

void
raid_copy(uint32 src_lblock, uint32 dst_lblock)
{
    80007064:	715d                	addi	sp,sp,-80
    80007066:	e486                	sd	ra,72(sp)
    80007068:	e0a2                	sd	s0,64(sp)
    8000706a:	fc26                	sd	s1,56(sp)
    8000706c:	f84a                	sd	s2,48(sp)
    8000706e:	f44e                	sd	s3,40(sp)
    80007070:	f052                	sd	s4,32(sp)
    80007072:	ec56                	sd	s5,24(sp)
    80007074:	e85a                	sd	s6,16(sp)
    80007076:	e45e                	sd	s7,8(sp)
    80007078:	e062                	sd	s8,0(sp)
    8000707a:	0880                	addi	s0,sp,80
    8000707c:	8a2a                	mv	s4,a0
    8000707e:	89ae                	mv	s3,a1
  acquire(&raid_lock);
    80007080:	0001f517          	auipc	a0,0x1f
    80007084:	ae850513          	addi	a0,a0,-1304 # 80025b68 <raid_lock>
    80007088:	87afa0ef          	jal	80001102 <acquire>
  // Read src into scratch buffer (call internal helpers directly, lock already held)
  for(int i = 0; i < BLOCKS_PER_PAGE; i++){
    8000708c:	0001f497          	auipc	s1,0x1f
    80007090:	af448493          	addi	s1,s1,-1292 # 80025b80 <raid_copy_buf>
    80007094:	00020a97          	auipc	s5,0x20
    80007098:	aeca8a93          	addi	s5,s5,-1300 # 80026b80 <sim_disk>
  acquire(&raid_lock);
    8000709c:	8926                	mv	s2,s1
    uint32 lb = src_lblock + i;
    char  *d  = raid_copy_buf + i * BSIZE;
    switch(raid_mode){
    8000709e:	00003b97          	auipc	s7,0x3
    800070a2:	a5eb8b93          	addi	s7,s7,-1442 # 80009afc <raid_mode>
    800070a6:	4b05                	li	s6,1
    800070a8:	4c15                	li	s8,5
    800070aa:	a809                	j	800070bc <raid_copy+0x58>
      case RAID_MODE_0: raid0_read(lb, d); break;
      case RAID_MODE_1: raid1_read(lb, d); break;
    800070ac:	8552                	mv	a0,s4
    800070ae:	ab5ff0ef          	jal	80006b62 <raid1_read>
  for(int i = 0; i < BLOCKS_PER_PAGE; i++){
    800070b2:	2a05                	addiw	s4,s4,1
    800070b4:	40090913          	addi	s2,s2,1024
    800070b8:	03590863          	beq	s2,s5,800070e8 <raid_copy+0x84>
    char  *d  = raid_copy_buf + i * BSIZE;
    800070bc:	85ca                	mv	a1,s2
    switch(raid_mode){
    800070be:	000ba783          	lw	a5,0(s7)
    800070c2:	ff6785e3          	beq	a5,s6,800070ac <raid_copy+0x48>
    800070c6:	01878763          	beq	a5,s8,800070d4 <raid_copy+0x70>
    800070ca:	eb89                	bnez	a5,800070dc <raid_copy+0x78>
      case RAID_MODE_0: raid0_read(lb, d); break;
    800070cc:	8552                	mv	a0,s4
    800070ce:	a69ff0ef          	jal	80006b36 <raid0_read>
    800070d2:	b7c5                	j	800070b2 <raid_copy+0x4e>
      case RAID_MODE_5: raid5_read(lb, d); break;
    800070d4:	8552                	mv	a0,s4
    800070d6:	acdff0ef          	jal	80006ba2 <raid5_read>
    800070da:	bfe1                	j	800070b2 <raid_copy+0x4e>
      default: panic("raid_copy: bad mode");
    800070dc:	00002517          	auipc	a0,0x2
    800070e0:	7fc50513          	addi	a0,a0,2044 # 800098d8 <etext+0x8d8>
    800070e4:	f40f90ef          	jal	80000824 <panic>
  }
  // Write scratch buffer to dst
  for(int i = 0; i < BLOCKS_PER_PAGE; i++){
    uint32 lb = dst_lblock + i;
    char  *s  = raid_copy_buf + i * BSIZE;
    switch(raid_mode){
    800070e8:	00003a17          	auipc	s4,0x3
    800070ec:	a14a0a13          	addi	s4,s4,-1516 # 80009afc <raid_mode>
    800070f0:	4905                	li	s2,1
    800070f2:	4b15                	li	s6,5
    800070f4:	a005                	j	80007114 <raid_copy+0xb0>
  phys_write_block(0, lb, src);
    800070f6:	8626                	mv	a2,s1
    800070f8:	85ce                	mv	a1,s3
    800070fa:	4501                	li	a0,0
    800070fc:	95fff0ef          	jal	80006a5a <phys_write_block>
  phys_write_block(1, lb, src);
    80007100:	8626                	mv	a2,s1
    80007102:	85ce                	mv	a1,s3
    80007104:	854a                	mv	a0,s2
    80007106:	955ff0ef          	jal	80006a5a <phys_write_block>
  for(int i = 0; i < BLOCKS_PER_PAGE; i++){
    8000710a:	2985                	addiw	s3,s3,1
    8000710c:	40048493          	addi	s1,s1,1024
    80007110:	03548c63          	beq	s1,s5,80007148 <raid_copy+0xe4>
    char  *s  = raid_copy_buf + i * BSIZE;
    80007114:	85a6                	mv	a1,s1
    switch(raid_mode){
    80007116:	000a2783          	lw	a5,0(s4)
    8000711a:	fd278ee3          	beq	a5,s2,800070f6 <raid_copy+0x92>
    8000711e:	01678b63          	beq	a5,s6,80007134 <raid_copy+0xd0>
    80007122:	ef89                	bnez	a5,8000713c <raid_copy+0xd8>
  phys_write_block(lb % NUM_DISKS, lb / NUM_DISKS, src);
    80007124:	8626                	mv	a2,s1
    80007126:	0029d59b          	srliw	a1,s3,0x2
    8000712a:	0039f513          	andi	a0,s3,3
    8000712e:	92dff0ef          	jal	80006a5a <phys_write_block>
}
    80007132:	bfe1                	j	8000710a <raid_copy+0xa6>
      case RAID_MODE_0: raid0_write(lb, s); break;
      case RAID_MODE_1: raid1_write(lb, s); break;
      case RAID_MODE_5: raid5_write(lb, s); break;
    80007134:	854e                	mv	a0,s3
    80007136:	bc1ff0ef          	jal	80006cf6 <raid5_write>
    8000713a:	bfc1                	j	8000710a <raid_copy+0xa6>
      default: panic("raid_copy: bad mode");
    8000713c:	00002517          	auipc	a0,0x2
    80007140:	79c50513          	addi	a0,a0,1948 # 800098d8 <etext+0x8d8>
    80007144:	ee0f90ef          	jal	80000824 <panic>
    }
  }
  release(&raid_lock);
    80007148:	0001f517          	auipc	a0,0x1f
    8000714c:	a2050513          	addi	a0,a0,-1504 # 80025b68 <raid_lock>
    80007150:	846fa0ef          	jal	80001196 <release>
    80007154:	60a6                	ld	ra,72(sp)
    80007156:	6406                	ld	s0,64(sp)
    80007158:	74e2                	ld	s1,56(sp)
    8000715a:	7942                	ld	s2,48(sp)
    8000715c:	79a2                	ld	s3,40(sp)
    8000715e:	7a02                	ld	s4,32(sp)
    80007160:	6ae2                	ld	s5,24(sp)
    80007162:	6b42                	ld	s6,16(sp)
    80007164:	6ba2                	ld	s7,8(sp)
    80007166:	6c02                	ld	s8,0(sp)
    80007168:	6161                	addi	sp,sp,80
    8000716a:	8082                	ret

000000008000716c <pick_fcfs>:
  return -1;
}
//  Internal: FCFS selection
static int
pick_fcfs(void)
{
    8000716c:	1141                	addi	sp,sp,-16
    8000716e:	e406                	sd	ra,8(sp)
    80007170:	e022                	sd	s0,0(sp)
    80007172:	0800                	addi	s0,sp,16
  int  best     = -1;
  uint best_seq = 0xFFFFFFFF;

  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    80007174:	00220797          	auipc	a5,0x220
    80007178:	a3c78793          	addi	a5,a5,-1476 # 80226bb0 <dq+0x18>
    8000717c:	4701                	li	a4,0
  uint best_seq = 0xFFFFFFFF;
    8000717e:	567d                	li	a2,-1
  int  best     = -1;
    80007180:	8532                	mv	a0,a2
  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    80007182:	04000593          	li	a1,64
    80007186:	a031                	j	80007192 <pick_fcfs+0x26>
    80007188:	2705                	addiw	a4,a4,1
    8000718a:	02078793          	addi	a5,a5,32
    8000718e:	00b70a63          	beq	a4,a1,800071a2 <pick_fcfs+0x36>
    if(!dq[i].valid) continue;
    80007192:	4394                	lw	a3,0(a5)
    80007194:	daf5                	beqz	a3,80007188 <pick_fcfs+0x1c>
    if(dq[i].seq < best_seq){
    80007196:	43d4                	lw	a3,4(a5)
    80007198:	fec6f8e3          	bgeu	a3,a2,80007188 <pick_fcfs+0x1c>
      best_seq = dq[i].seq;
    8000719c:	8636                	mv	a2,a3
      best     = i;
    8000719e:	853a                	mv	a0,a4
    800071a0:	b7e5                	j	80007188 <pick_fcfs+0x1c>
    }
  }
  return best;
}
    800071a2:	60a2                	ld	ra,8(sp)
    800071a4:	6402                	ld	s0,0(sp)
    800071a6:	0141                	addi	sp,sp,16
    800071a8:	8082                	ret

00000000800071aa <pick_sstf>:

// Internal: SSTF selection

static int
pick_sstf(void)
{
    800071aa:	1141                	addi	sp,sp,-16
    800071ac:	e406                	sd	ra,8(sp)
    800071ae:	e022                	sd	s0,0(sp)
    800071b0:	0800                	addi	s0,sp,16

  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    if(!dq[i].valid) continue;

    uint dist;
    if(dq[i].blockno > current_head) {
    800071b2:	00003817          	auipc	a6,0x3
    800071b6:	96282803          	lw	a6,-1694(a6) # 80009b14 <current_head>
    800071ba:	00220797          	auipc	a5,0x220
    800071be:	9ea78793          	addi	a5,a5,-1558 # 80226ba4 <dq+0xc>
  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    800071c2:	4681                	li	a3,0
  int  best_prio = 0x7FFFFFFF;
    800071c4:	80000337          	lui	t1,0x80000
    800071c8:	fff34313          	not	t1,t1
  uint best_dist = 0xFFFFFFFF;
    800071cc:	55fd                	li	a1,-1
  int  best      = -1;
    800071ce:	852e                	mv	a0,a1
  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    800071d0:	04000893          	li	a7,64
    800071d4:	a829                	j	800071ee <pick_sstf+0x44>
      dist = (dq[i].blockno - current_head);
    } else {
      dist = (current_head - dq[i].blockno);
    800071d6:	40e8073b          	subw	a4,a6,a4
    800071da:	a015                	j	800071fe <pick_sstf+0x54>

    if((dist < best_dist) ||
       (dist == best_dist && dq[i].priority < best_prio)) {
      best      = i;
      best_dist = dist;
      best_prio = dq[i].priority;
    800071dc:	00462303          	lw	t1,4(a2) # 200004 <_entry-0x7fdffffc>
      best_dist = dist;
    800071e0:	85ba                	mv	a1,a4
      best      = i;
    800071e2:	8536                	mv	a0,a3
  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    800071e4:	2685                	addiw	a3,a3,1
    800071e6:	02078793          	addi	a5,a5,32
    800071ea:	03168363          	beq	a3,a7,80007210 <pick_sstf+0x66>
    if(!dq[i].valid) continue;
    800071ee:	863e                	mv	a2,a5
    800071f0:	47d8                	lw	a4,12(a5)
    800071f2:	db6d                	beqz	a4,800071e4 <pick_sstf+0x3a>
    if(dq[i].blockno > current_head) {
    800071f4:	4398                	lw	a4,0(a5)
    800071f6:	fee870e3          	bgeu	a6,a4,800071d6 <pick_sstf+0x2c>
      dist = (dq[i].blockno - current_head);
    800071fa:	4107073b          	subw	a4,a4,a6
    if((dist < best_dist) ||
    800071fe:	fcb76fe3          	bltu	a4,a1,800071dc <pick_sstf+0x32>
    80007202:	feb711e3          	bne	a4,a1,800071e4 <pick_sstf+0x3a>
       (dist == best_dist && dq[i].priority < best_prio)) {
    80007206:	00462e03          	lw	t3,4(a2)
    8000720a:	fc6e5de3          	bge	t3,t1,800071e4 <pick_sstf+0x3a>
    8000720e:	b7f9                	j	800071dc <pick_sstf+0x32>
    }
  }
  return best;
}
    80007210:	60a2                	ld	ra,8(sp)
    80007212:	6402                	ld	s0,0(sp)
    80007214:	0141                	addi	sp,sp,16
    80007216:	8082                	ret

0000000080007218 <compute_and_record_latency>:
//Internal: compute latency and update stats


static uint
compute_and_record_latency(uint blockno, int pid)
{
    80007218:	1141                	addi	sp,sp,-16
    8000721a:	e406                	sd	ra,8(sp)
    8000721c:	e022                	sd	s0,0(sp)
    8000721e:	0800                	addi	s0,sp,16
  (void)pid;  

  uint seek;
  if(blockno > current_head) {
    80007220:	00003797          	auipc	a5,0x3
    80007224:	8f47a783          	lw	a5,-1804(a5) # 80009b14 <current_head>
    80007228:	02a7f963          	bgeu	a5,a0,8000725a <compute_and_record_latency+0x42>
    seek = (blockno - current_head);
    8000722c:	9d1d                	subw	a0,a0,a5
  } else {
    seek = (current_head - blockno);
  }
  uint latency = seek + ROTATIONAL_CONST;
    8000722e:	2515                	addiw	a0,a0,5

  // update global stats only 
  total_latency += latency;
    80007230:	00003717          	auipc	a4,0x3
    80007234:	8d870713          	addi	a4,a4,-1832 # 80009b08 <total_latency>
    80007238:	02051693          	slli	a3,a0,0x20
    8000723c:	9281                	srli	a3,a3,0x20
    8000723e:	631c                	ld	a5,0(a4)
    80007240:	97b6                	add	a5,a5,a3
    80007242:	e31c                	sd	a5,0(a4)
  total_ops++;
    80007244:	00003717          	auipc	a4,0x3
    80007248:	8bc70713          	addi	a4,a4,-1860 # 80009b00 <total_ops>
    8000724c:	631c                	ld	a5,0(a4)
    8000724e:	0785                	addi	a5,a5,1
    80007250:	e31c                	sd	a5,0(a4)

  return latency;
}
    80007252:	60a2                	ld	ra,8(sp)
    80007254:	6402                	ld	s0,0(sp)
    80007256:	0141                	addi	sp,sp,16
    80007258:	8082                	ret
    seek = (current_head - blockno);
    8000725a:	40a7853b          	subw	a0,a5,a0
    8000725e:	bfc1                	j	8000722e <compute_and_record_latency+0x16>

0000000080007260 <disksched_init>:
{
    80007260:	1141                	addi	sp,sp,-16
    80007262:	e406                	sd	ra,8(sp)
    80007264:	e022                	sd	s0,0(sp)
    80007266:	0800                	addi	s0,sp,16
  initlock(&dq_lock, "disksched");
    80007268:	00002597          	auipc	a1,0x2
    8000726c:	68858593          	addi	a1,a1,1672 # 800098f0 <etext+0x8f0>
    80007270:	00220517          	auipc	a0,0x220
    80007274:	91050513          	addi	a0,a0,-1776 # 80226b80 <dq_lock>
    80007278:	e01f90ef          	jal	80001078 <initlock>
  dq_size      = 0;
    8000727c:	00003797          	auipc	a5,0x3
    80007280:	8a07a023          	sw	zero,-1888(a5) # 80009b1c <dq_size>
  current_head = 0;
    80007284:	00003797          	auipc	a5,0x3
    80007288:	8807a823          	sw	zero,-1904(a5) # 80009b14 <current_head>
  sched_policy = DISK_SCHED_FCFS;
    8000728c:	00003797          	auipc	a5,0x3
    80007290:	8807a223          	sw	zero,-1916(a5) # 80009b10 <sched_policy>
  total_latency = 0;
    80007294:	00003797          	auipc	a5,0x3
    80007298:	8607ba23          	sd	zero,-1932(a5) # 80009b08 <total_latency>
  total_ops     = 0;
    8000729c:	00003797          	auipc	a5,0x3
    800072a0:	8607b223          	sd	zero,-1948(a5) # 80009b00 <total_ops>
  dq_seq        = 0;
    800072a4:	00003797          	auipc	a5,0x3
    800072a8:	8607aa23          	sw	zero,-1932(a5) # 80009b18 <dq_seq>
  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    800072ac:	00220797          	auipc	a5,0x220
    800072b0:	90478793          	addi	a5,a5,-1788 # 80226bb0 <dq+0x18>
    800072b4:	00220717          	auipc	a4,0x220
    800072b8:	0fc70713          	addi	a4,a4,252 # 802273b0 <end+0x18>
  dq[i].valid = 0;
    800072bc:	0007a023          	sw	zero,0(a5)
  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    800072c0:	02078793          	addi	a5,a5,32
    800072c4:	fee79ce3          	bne	a5,a4,800072bc <disksched_init+0x5c>
}
    800072c8:	60a2                	ld	ra,8(sp)
    800072ca:	6402                	ld	s0,0(sp)
    800072cc:	0141                	addi	sp,sp,16
    800072ce:	8082                	ret

00000000800072d0 <disksched_set_policy>:
{
    800072d0:	1101                	addi	sp,sp,-32
    800072d2:	ec06                	sd	ra,24(sp)
    800072d4:	e822                	sd	s0,16(sp)
    800072d6:	e426                	sd	s1,8(sp)
    800072d8:	1000                	addi	s0,sp,32
    800072da:	84aa                	mv	s1,a0
  acquire(&dq_lock);
    800072dc:	00220517          	auipc	a0,0x220
    800072e0:	8a450513          	addi	a0,a0,-1884 # 80226b80 <dq_lock>
    800072e4:	e1ff90ef          	jal	80001102 <acquire>
  if(policy != DISK_SCHED_FCFS && policy != DISK_SCHED_SSTF){
    800072e8:	4785                	li	a5,1
    800072ea:	0297e163          	bltu	a5,s1,8000730c <disksched_set_policy+0x3c>
  sched_policy = policy;
    800072ee:	00003797          	auipc	a5,0x3
    800072f2:	8297a123          	sw	s1,-2014(a5) # 80009b10 <sched_policy>
  release(&dq_lock);
    800072f6:	00220517          	auipc	a0,0x220
    800072fa:	88a50513          	addi	a0,a0,-1910 # 80226b80 <dq_lock>
    800072fe:	e99f90ef          	jal	80001196 <release>
}
    80007302:	60e2                	ld	ra,24(sp)
    80007304:	6442                	ld	s0,16(sp)
    80007306:	64a2                	ld	s1,8(sp)
    80007308:	6105                	addi	sp,sp,32
    8000730a:	8082                	ret
    panic("disksched_set_policy: invalid policy");
    8000730c:	00002517          	auipc	a0,0x2
    80007310:	5f450513          	addi	a0,a0,1524 # 80009900 <etext+0x900>
    80007314:	d10f90ef          	jal	80000824 <panic>

0000000080007318 <disksched_get_policy>:
{
    80007318:	1141                	addi	sp,sp,-16
    8000731a:	e406                	sd	ra,8(sp)
    8000731c:	e022                	sd	s0,0(sp)
    8000731e:	0800                	addi	s0,sp,16
}
    80007320:	00002517          	auipc	a0,0x2
    80007324:	7f052503          	lw	a0,2032(a0) # 80009b10 <sched_policy>
    80007328:	60a2                	ld	ra,8(sp)
    8000732a:	6402                	ld	s0,0(sp)
    8000732c:	0141                	addi	sp,sp,16
    8000732e:	8082                	ret

0000000080007330 <disksched_get_stats>:
{
    80007330:	1101                	addi	sp,sp,-32
    80007332:	ec06                	sd	ra,24(sp)
    80007334:	e822                	sd	s0,16(sp)
    80007336:	e426                	sd	s1,8(sp)
    80007338:	e04a                	sd	s2,0(sp)
    8000733a:	1000                	addi	s0,sp,32
    8000733c:	84aa                	mv	s1,a0
    8000733e:	892e                	mv	s2,a1
  acquire(&dq_lock);
    80007340:	00220517          	auipc	a0,0x220
    80007344:	84050513          	addi	a0,a0,-1984 # 80226b80 <dq_lock>
    80007348:	dbbf90ef          	jal	80001102 <acquire>
  *out_total_ops = total_ops;
    8000734c:	00002797          	auipc	a5,0x2
    80007350:	7b47b783          	ld	a5,1972(a5) # 80009b00 <total_ops>
    80007354:	e09c                	sd	a5,0(s1)
  if(total_ops > 0) {
    80007356:	c799                	beqz	a5,80007364 <disksched_get_stats+0x34>
    *out_avg_latency = (total_latency / total_ops);
    80007358:	00002717          	auipc	a4,0x2
    8000735c:	7b073703          	ld	a4,1968(a4) # 80009b08 <total_latency>
    80007360:	02f757b3          	divu	a5,a4,a5
    80007364:	00f93023          	sd	a5,0(s2)
  release(&dq_lock);
    80007368:	00220517          	auipc	a0,0x220
    8000736c:	81850513          	addi	a0,a0,-2024 # 80226b80 <dq_lock>
    80007370:	e27f90ef          	jal	80001196 <release>
}
    80007374:	60e2                	ld	ra,24(sp)
    80007376:	6442                	ld	s0,16(sp)
    80007378:	64a2                	ld	s1,8(sp)
    8000737a:	6902                	ld	s2,0(sp)
    8000737c:	6105                	addi	sp,sp,32
    8000737e:	8082                	ret

0000000080007380 <disksched_submit>:

void
disksched_submit(struct buf *b, int write)
{
    80007380:	7179                	addi	sp,sp,-48
    80007382:	f406                	sd	ra,40(sp)
    80007384:	f022                	sd	s0,32(sp)
    80007386:	ec26                	sd	s1,24(sp)
    80007388:	e84a                	sd	s2,16(sp)
    8000738a:	e44e                	sd	s3,8(sp)
    8000738c:	1800                	addi	s0,sp,48
    8000738e:	892a                	mv	s2,a0
    80007390:	89ae                	mv	s3,a1
  acquire(&dq_lock);
    80007392:	0021f517          	auipc	a0,0x21f
    80007396:	7ee50513          	addi	a0,a0,2030 # 80226b80 <dq_lock>
    8000739a:	d69f90ef          	jal	80001102 <acquire>
  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    8000739e:	00220797          	auipc	a5,0x220
    800073a2:	81278793          	addi	a5,a5,-2030 # 80226bb0 <dq+0x18>
    800073a6:	4481                	li	s1,0
    800073a8:	04000693          	li	a3,64
    if(!dq[i].valid){
    800073ac:	4398                	lw	a4,0(a5)
    800073ae:	cf09                	beqz	a4,800073c8 <disksched_submit+0x48>
  for(int i = 0; i < MAX_DISK_QUEUE; i++){
    800073b0:	2485                	addiw	s1,s1,1
    800073b2:	02078793          	addi	a5,a5,32
    800073b6:	fed49be3          	bne	s1,a3,800073ac <disksched_submit+0x2c>
    800073ba:	e052                	sd	s4,0(sp)

  //  Enqueue the new request 
  int slot = dq_alloc_slot();
  if(slot < 0){
    panic("disksched: queue full");
    800073bc:	00002517          	auipc	a0,0x2
    800073c0:	56c50513          	addi	a0,a0,1388 # 80009928 <etext+0x928>
    800073c4:	c60f90ef          	jal	80000824 <panic>
  if(slot < 0){
    800073c8:	fe04c9e3          	bltz	s1,800073ba <disksched_submit+0x3a>
  }

  struct proc *p = myproc();
    800073cc:	c9ffa0ef          	jal	8000206a <myproc>
  dq[slot].buf      = b;
    800073d0:	00549713          	slli	a4,s1,0x5
    800073d4:	0021f797          	auipc	a5,0x21f
    800073d8:	7c478793          	addi	a5,a5,1988 # 80226b98 <dq>
    800073dc:	97ba                	add	a5,a5,a4
    800073de:	0127b023          	sd	s2,0(a5)
  dq[slot].write    = write;
    800073e2:	0137a423          	sw	s3,8(a5)
  dq[slot].blockno  = b->blockno;
    800073e6:	00c92703          	lw	a4,12(s2)
    800073ea:	c7d8                	sw	a4,12(a5)
  if(p != 0) {
    800073ec:	cd4d                	beqz	a0,800074a6 <disksched_submit+0x126>
    dq[slot].priority = p->level;
    800073ee:	17052703          	lw	a4,368(a0)
    800073f2:	00549693          	slli	a3,s1,0x5
    800073f6:	0021f797          	auipc	a5,0x21f
    800073fa:	7a278793          	addi	a5,a5,1954 # 80226b98 <dq>
    800073fe:	97b6                	add	a5,a5,a3
    80007400:	cb98                	sw	a4,16(a5)
  else {
    dq[slot].priority = 99;   // 99 = kernel/no process
  }

  if(p != 0) {
    dq[slot].pid = p->pid;
    80007402:	5918                	lw	a4,48(a0)
    80007404:	0496                	slli	s1,s1,0x5
    80007406:	0021f797          	auipc	a5,0x21f
    8000740a:	79278793          	addi	a5,a5,1938 # 80226b98 <dq>
    8000740e:	97a6                	add	a5,a5,s1
    80007410:	cbd8                	sw	a4,20(a5)
  } 
  else {
    dq[slot].pid = -1;
  }
  dq[slot].seq      = dq_seq++;
    80007412:	00002697          	auipc	a3,0x2
    80007416:	70668693          	addi	a3,a3,1798 # 80009b18 <dq_seq>
    8000741a:	4298                	lw	a4,0(a3)
    8000741c:	0017061b          	addiw	a2,a4,1
    80007420:	c290                	sw	a2,0(a3)
    80007422:	cfd8                	sw	a4,28(a5)
  dq[slot].valid    = 1;
    80007424:	4705                	li	a4,1
    80007426:	cf98                	sw	a4,24(a5)
  dq_size++;
    80007428:	00002797          	auipc	a5,0x2
    8000742c:	6f478793          	addi	a5,a5,1780 # 80009b1c <dq_size>
    80007430:	4384                	lw	s1,0(a5)
    80007432:	0014869b          	addiw	a3,s1,1
    80007436:	c394                	sw	a3,0(a5)

  // Pick next request according to policy 
  int chosen;
  if(sched_policy == DISK_SCHED_SSTF) {
    80007438:	00002797          	auipc	a5,0x2
    8000743c:	6d87a783          	lw	a5,1752(a5) # 80009b10 <sched_policy>
    80007440:	06e78f63          	beq	a5,a4,800074be <disksched_submit+0x13e>
    chosen = pick_sstf();
  } 
  else {
    chosen = pick_fcfs();
    80007444:	d29ff0ef          	jal	8000716c <pick_fcfs>
  }

  if(chosen < 0) {
    80007448:	06054e63          	bltz	a0,800074c4 <disksched_submit+0x144>
    8000744c:	e052                	sd	s4,0(sp)
    release(&dq_lock);
    return;   // nothing to do
  }

  //Extract chosen request from queue 
  struct buf *chosen_buf   = dq[chosen].buf;
    8000744e:	0516                	slli	a0,a0,0x5
    80007450:	0021f797          	auipc	a5,0x21f
    80007454:	74878793          	addi	a5,a5,1864 # 80226b98 <dq>
    80007458:	97aa                	add	a5,a5,a0
    8000745a:	0007b983          	ld	s3,0(a5)
  int         chosen_write = dq[chosen].write;
    8000745e:	0087aa03          	lw	s4,8(a5)
  uint        chosen_block = dq[chosen].blockno;
    80007462:	00c7a903          	lw	s2,12(a5)
  int         chosen_pid   = dq[chosen].pid;

  dq[chosen].valid = 0;
    80007466:	0007ac23          	sw	zero,24(a5)
  dq_size--;
    8000746a:	00002717          	auipc	a4,0x2
    8000746e:	6a972923          	sw	s1,1714(a4) # 80009b1c <dq_size>

  //Compute latency and move disk head
  compute_and_record_latency(chosen_block, chosen_pid);
    80007472:	4bcc                	lw	a1,20(a5)
    80007474:	854a                	mv	a0,s2
    80007476:	da3ff0ef          	jal	80007218 <compute_and_record_latency>
  current_head = chosen_block;
    8000747a:	00002797          	auipc	a5,0x2
    8000747e:	6927ad23          	sw	s2,1690(a5) # 80009b14 <current_head>

  release(&dq_lock);
    80007482:	0021f517          	auipc	a0,0x21f
    80007486:	6fe50513          	addi	a0,a0,1790 # 80226b80 <dq_lock>
    8000748a:	d0df90ef          	jal	80001196 <release>

  //Perform the actual I/O (outside the lock) 
  virtio_disk_rw(chosen_buf, chosen_write);
    8000748e:	85d2                	mv	a1,s4
    80007490:	854e                	mv	a0,s3
    80007492:	adeff0ef          	jal	80006770 <virtio_disk_rw>
    80007496:	6a02                	ld	s4,0(sp)
}
    80007498:	70a2                	ld	ra,40(sp)
    8000749a:	7402                	ld	s0,32(sp)
    8000749c:	64e2                	ld	s1,24(sp)
    8000749e:	6942                	ld	s2,16(sp)
    800074a0:	69a2                	ld	s3,8(sp)
    800074a2:	6145                	addi	sp,sp,48
    800074a4:	8082                	ret
    dq[slot].priority = 99;   // 99 = kernel/no process
    800074a6:	00549713          	slli	a4,s1,0x5
    800074aa:	0021f797          	auipc	a5,0x21f
    800074ae:	6ee78793          	addi	a5,a5,1774 # 80226b98 <dq>
    800074b2:	97ba                	add	a5,a5,a4
    800074b4:	06300713          	li	a4,99
    800074b8:	cb98                	sw	a4,16(a5)
    800074ba:	577d                	li	a4,-1
    800074bc:	b7a1                	j	80007404 <disksched_submit+0x84>
    chosen = pick_sstf();
    800074be:	cedff0ef          	jal	800071aa <pick_sstf>
    800074c2:	b759                	j	80007448 <disksched_submit+0xc8>
    release(&dq_lock);
    800074c4:	0021f517          	auipc	a0,0x21f
    800074c8:	6bc50513          	addi	a0,a0,1724 # 80226b80 <dq_lock>
    800074cc:	ccbf90ef          	jal	80001196 <release>
    return;   // nothing to do
    800074d0:	b7e1                	j	80007498 <disksched_submit+0x118>

00000000800074d2 <disksched_flush>:

void
disksched_flush(void)
{
    800074d2:	711d                	addi	sp,sp,-96
    800074d4:	ec86                	sd	ra,88(sp)
    800074d6:	e8a2                	sd	s0,80(sp)
    800074d8:	e4a6                	sd	s1,72(sp)
    800074da:	e0ca                	sd	s2,64(sp)
    800074dc:	fc4e                	sd	s3,56(sp)
    800074de:	f852                	sd	s4,48(sp)
    800074e0:	f456                	sd	s5,40(sp)
    800074e2:	f05a                	sd	s6,32(sp)
    800074e4:	ec5e                	sd	s7,24(sp)
    800074e6:	e862                	sd	s8,16(sp)
    800074e8:	e466                	sd	s9,8(sp)
    800074ea:	e06a                	sd	s10,0(sp)
    800074ec:	1080                	addi	s0,sp,96
  for(;;){
    acquire(&dq_lock);
    800074ee:	0021f997          	auipc	s3,0x21f
    800074f2:	69298993          	addi	s3,s3,1682 # 80226b80 <dq_lock>
    if(dq_size == 0){
    800074f6:	00002917          	auipc	s2,0x2
    800074fa:	62690913          	addi	s2,s2,1574 # 80009b1c <dq_size>
      release(&dq_lock);
      return;
    }

    int chosen;
    if(sched_policy == DISK_SCHED_SSTF) {
    800074fe:	00002a97          	auipc	s5,0x2
    80007502:	612a8a93          	addi	s5,s5,1554 # 80009b10 <sched_policy>
    80007506:	4a05                	li	s4,1
    if(chosen < 0) {
      release(&dq_lock);
      return;
    }

    struct buf *chosen_buf   = dq[chosen].buf;
    80007508:	0021fb97          	auipc	s7,0x21f
    8000750c:	690b8b93          	addi	s7,s7,1680 # 80226b98 <dq>

    dq[chosen].valid = 0;
    dq_size--;

    compute_and_record_latency(chosen_block, chosen_pid);
    current_head = chosen_block;
    80007510:	00002b17          	auipc	s6,0x2
    80007514:	604b0b13          	addi	s6,s6,1540 # 80009b14 <current_head>
    80007518:	a09d                	j	8000757e <disksched_flush+0xac>
      release(&dq_lock);
    8000751a:	0021f517          	auipc	a0,0x21f
    8000751e:	66650513          	addi	a0,a0,1638 # 80226b80 <dq_lock>
    80007522:	c75f90ef          	jal	80001196 <release>

    release(&dq_lock);

    virtio_disk_rw(chosen_buf, chosen_write);
  }
    80007526:	60e6                	ld	ra,88(sp)
    80007528:	6446                	ld	s0,80(sp)
    8000752a:	64a6                	ld	s1,72(sp)
    8000752c:	6906                	ld	s2,64(sp)
    8000752e:	79e2                	ld	s3,56(sp)
    80007530:	7a42                	ld	s4,48(sp)
    80007532:	7aa2                	ld	s5,40(sp)
    80007534:	7b02                	ld	s6,32(sp)
    80007536:	6be2                	ld	s7,24(sp)
    80007538:	6c42                	ld	s8,16(sp)
    8000753a:	6ca2                	ld	s9,8(sp)
    8000753c:	6d02                	ld	s10,0(sp)
    8000753e:	6125                	addi	sp,sp,96
    80007540:	8082                	ret
      chosen = pick_sstf();
    80007542:	c69ff0ef          	jal	800071aa <pick_sstf>
    if(chosen < 0) {
    80007546:	04054963          	bltz	a0,80007598 <disksched_flush+0xc6>
    struct buf *chosen_buf   = dq[chosen].buf;
    8000754a:	0516                	slli	a0,a0,0x5
    8000754c:	955e                	add	a0,a0,s7
    8000754e:	00053c83          	ld	s9,0(a0)
    int         chosen_write = dq[chosen].write;
    80007552:	00852d03          	lw	s10,8(a0)
    uint        chosen_block = dq[chosen].blockno;
    80007556:	00c52c03          	lw	s8,12(a0)
    dq[chosen].valid = 0;
    8000755a:	00052c23          	sw	zero,24(a0)
    dq_size--;
    8000755e:	34fd                	addiw	s1,s1,-1
    80007560:	00992023          	sw	s1,0(s2)
    compute_and_record_latency(chosen_block, chosen_pid);
    80007564:	494c                	lw	a1,20(a0)
    80007566:	8562                	mv	a0,s8
    80007568:	cb1ff0ef          	jal	80007218 <compute_and_record_latency>
    current_head = chosen_block;
    8000756c:	018b2023          	sw	s8,0(s6)
    release(&dq_lock);
    80007570:	854e                	mv	a0,s3
    80007572:	c25f90ef          	jal	80001196 <release>
    virtio_disk_rw(chosen_buf, chosen_write);
    80007576:	85ea                	mv	a1,s10
    80007578:	8566                	mv	a0,s9
    8000757a:	9f6ff0ef          	jal	80006770 <virtio_disk_rw>
    acquire(&dq_lock);
    8000757e:	854e                	mv	a0,s3
    80007580:	b83f90ef          	jal	80001102 <acquire>
    if(dq_size == 0){
    80007584:	00092483          	lw	s1,0(s2)
    80007588:	d8c9                	beqz	s1,8000751a <disksched_flush+0x48>
    if(sched_policy == DISK_SCHED_SSTF) {
    8000758a:	000aa783          	lw	a5,0(s5)
    8000758e:	fb478ae3          	beq	a5,s4,80007542 <disksched_flush+0x70>
      chosen = pick_fcfs();
    80007592:	bdbff0ef          	jal	8000716c <pick_fcfs>
    80007596:	bf45                	j	80007546 <disksched_flush+0x74>
      release(&dq_lock);
    80007598:	0021f517          	auipc	a0,0x21f
    8000759c:	5e850513          	addi	a0,a0,1512 # 80226b80 <dq_lock>
    800075a0:	bf7f90ef          	jal	80001196 <release>
      return;
    800075a4:	b749                	j	80007526 <disksched_flush+0x54>
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000800a:	0536                	slli	a0,a0,0xd
    8000800c:	02153423          	sd	ra,40(a0)
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	sd	s0,96(a0)
    8000802a:	f524                	sd	s1,104(a0)
    8000802c:	fd2c                	sd	a1,120(a0)
    8000802e:	e150                	sd	a2,128(a0)
    80008030:	e554                	sd	a3,136(a0)
    80008032:	e958                	sd	a4,144(a0)
    80008034:	ed5c                	sd	a5,152(a0)
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	9282                	jalr	t0

000000008000809c <userret>:
    8000809c:	12000073          	sfence.vma
    800080a0:	18051073          	csrw	satp,a0
    800080a4:	12000073          	sfence.vma
    800080a8:	02000537          	lui	a0,0x2000
    800080ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800080ae:	0536                	slli	a0,a0,0xd
    800080b0:	02853083          	ld	ra,40(a0)
    800080b4:	03053103          	ld	sp,48(a0)
    800080b8:	03853183          	ld	gp,56(a0)
    800080bc:	04053203          	ld	tp,64(a0)
    800080c0:	04853283          	ld	t0,72(a0)
    800080c4:	05053303          	ld	t1,80(a0)
    800080c8:	05853383          	ld	t2,88(a0)
    800080cc:	7120                	ld	s0,96(a0)
    800080ce:	7524                	ld	s1,104(a0)
    800080d0:	7d2c                	ld	a1,120(a0)
    800080d2:	6150                	ld	a2,128(a0)
    800080d4:	6554                	ld	a3,136(a0)
    800080d6:	6958                	ld	a4,144(a0)
    800080d8:	6d5c                	ld	a5,152(a0)
    800080da:	0a053803          	ld	a6,160(a0)
    800080de:	0a853883          	ld	a7,168(a0)
    800080e2:	0b053903          	ld	s2,176(a0)
    800080e6:	0b853983          	ld	s3,184(a0)
    800080ea:	0c053a03          	ld	s4,192(a0)
    800080ee:	0c853a83          	ld	s5,200(a0)
    800080f2:	0d053b03          	ld	s6,208(a0)
    800080f6:	0d853b83          	ld	s7,216(a0)
    800080fa:	0e053c03          	ld	s8,224(a0)
    800080fe:	0e853c83          	ld	s9,232(a0)
    80008102:	0f053d03          	ld	s10,240(a0)
    80008106:	0f853d83          	ld	s11,248(a0)
    8000810a:	10053e03          	ld	t3,256(a0)
    8000810e:	10853e83          	ld	t4,264(a0)
    80008112:	11053f03          	ld	t5,272(a0)
    80008116:	11853f83          	ld	t6,280(a0)
    8000811a:	7928                	ld	a0,112(a0)
    8000811c:	10200073          	sret
	...
