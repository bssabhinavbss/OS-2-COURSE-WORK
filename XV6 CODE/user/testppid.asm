
user/_testppid:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(void){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  printf("my pid = %d\n", getpid());
   8:	360000ef          	jal	368 <getpid>
   c:	85aa                	mv	a1,a0
   e:	00001517          	auipc	a0,0x1
  12:	92250513          	addi	a0,a0,-1758 # 930 <malloc+0xfa>
  16:	768000ef          	jal	77e <printf>
  printf("parent pid = %d\n", getppid());
  1a:	37e000ef          	jal	398 <getppid>
  1e:	85aa                	mv	a1,a0
  20:	00001517          	auipc	a0,0x1
  24:	92050513          	addi	a0,a0,-1760 # 940 <malloc+0x10a>
  28:	756000ef          	jal	77e <printf>
  exit(0);
  2c:	4501                	li	a0,0
  2e:	2ba000ef          	jal	2e8 <exit>

0000000000000032 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  32:	1141                	addi	sp,sp,-16
  34:	e406                	sd	ra,8(sp)
  36:	e022                	sd	s0,0(sp)
  38:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  3a:	fc7ff0ef          	jal	0 <main>
  exit(r);
  3e:	2aa000ef          	jal	2e8 <exit>

0000000000000042 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  42:	1141                	addi	sp,sp,-16
  44:	e406                	sd	ra,8(sp)
  46:	e022                	sd	s0,0(sp)
  48:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4a:	87aa                	mv	a5,a0
  4c:	0585                	addi	a1,a1,1
  4e:	0785                	addi	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0xa>
    ;
  return os;
}
  5a:	60a2                	ld	ra,8(sp)
  5c:	6402                	ld	s0,0(sp)
  5e:	0141                	addi	sp,sp,16
  60:	8082                	ret

0000000000000062 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	cb91                	beqz	a5,82 <strcmp+0x20>
  70:	0005c703          	lbu	a4,0(a1)
  74:	00f71763          	bne	a4,a5,82 <strcmp+0x20>
    p++, q++;
  78:	0505                	addi	a0,a0,1
  7a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  7c:	00054783          	lbu	a5,0(a0)
  80:	fbe5                	bnez	a5,70 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  82:	0005c503          	lbu	a0,0(a1)
}
  86:	40a7853b          	subw	a0,a5,a0
  8a:	60a2                	ld	ra,8(sp)
  8c:	6402                	ld	s0,0(sp)
  8e:	0141                	addi	sp,sp,16
  90:	8082                	ret

0000000000000092 <strlen>:

uint
strlen(const char *s)
{
  92:	1141                	addi	sp,sp,-16
  94:	e406                	sd	ra,8(sp)
  96:	e022                	sd	s0,0(sp)
  98:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cf91                	beqz	a5,ba <strlen+0x28>
  a0:	00150793          	addi	a5,a0,1
  a4:	86be                	mv	a3,a5
  a6:	0785                	addi	a5,a5,1
  a8:	fff7c703          	lbu	a4,-1(a5)
  ac:	ff65                	bnez	a4,a4 <strlen+0x12>
  ae:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  b2:	60a2                	ld	ra,8(sp)
  b4:	6402                	ld	s0,0(sp)
  b6:	0141                	addi	sp,sp,16
  b8:	8082                	ret
  for(n = 0; s[n]; n++)
  ba:	4501                	li	a0,0
  bc:	bfdd                	j	b2 <strlen+0x20>

00000000000000be <memset>:

void*
memset(void *dst, int c, uint n)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e406                	sd	ra,8(sp)
  c2:	e022                	sd	s0,0(sp)
  c4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  c6:	ca19                	beqz	a2,dc <memset+0x1e>
  c8:	87aa                	mv	a5,a0
  ca:	1602                	slli	a2,a2,0x20
  cc:	9201                	srli	a2,a2,0x20
  ce:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  d2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  d6:	0785                	addi	a5,a5,1
  d8:	fee79de3          	bne	a5,a4,d2 <memset+0x14>
  }
  return dst;
}
  dc:	60a2                	ld	ra,8(sp)
  de:	6402                	ld	s0,0(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <strchr>:

char*
strchr(const char *s, char c)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ec:	00054783          	lbu	a5,0(a0)
  f0:	cf81                	beqz	a5,108 <strchr+0x24>
    if(*s == c)
  f2:	00f58763          	beq	a1,a5,100 <strchr+0x1c>
  for(; *s; s++)
  f6:	0505                	addi	a0,a0,1
  f8:	00054783          	lbu	a5,0(a0)
  fc:	fbfd                	bnez	a5,f2 <strchr+0xe>
      return (char*)s;
  return 0;
  fe:	4501                	li	a0,0
}
 100:	60a2                	ld	ra,8(sp)
 102:	6402                	ld	s0,0(sp)
 104:	0141                	addi	sp,sp,16
 106:	8082                	ret
  return 0;
 108:	4501                	li	a0,0
 10a:	bfdd                	j	100 <strchr+0x1c>

000000000000010c <gets>:

char*
gets(char *buf, int max)
{
 10c:	711d                	addi	sp,sp,-96
 10e:	ec86                	sd	ra,88(sp)
 110:	e8a2                	sd	s0,80(sp)
 112:	e4a6                	sd	s1,72(sp)
 114:	e0ca                	sd	s2,64(sp)
 116:	fc4e                	sd	s3,56(sp)
 118:	f852                	sd	s4,48(sp)
 11a:	f456                	sd	s5,40(sp)
 11c:	f05a                	sd	s6,32(sp)
 11e:	ec5e                	sd	s7,24(sp)
 120:	e862                	sd	s8,16(sp)
 122:	1080                	addi	s0,sp,96
 124:	8baa                	mv	s7,a0
 126:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 128:	892a                	mv	s2,a0
 12a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 12c:	faf40b13          	addi	s6,s0,-81
 130:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 132:	8c26                	mv	s8,s1
 134:	0014899b          	addiw	s3,s1,1
 138:	84ce                	mv	s1,s3
 13a:	0349d463          	bge	s3,s4,162 <gets+0x56>
    cc = read(0, &c, 1);
 13e:	8656                	mv	a2,s5
 140:	85da                	mv	a1,s6
 142:	4501                	li	a0,0
 144:	1bc000ef          	jal	300 <read>
    if(cc < 1)
 148:	00a05d63          	blez	a0,162 <gets+0x56>
      break;
    buf[i++] = c;
 14c:	faf44783          	lbu	a5,-81(s0)
 150:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 154:	0905                	addi	s2,s2,1
 156:	ff678713          	addi	a4,a5,-10
 15a:	c319                	beqz	a4,160 <gets+0x54>
 15c:	17cd                	addi	a5,a5,-13
 15e:	fbf1                	bnez	a5,132 <gets+0x26>
    buf[i++] = c;
 160:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 162:	9c5e                	add	s8,s8,s7
 164:	000c0023          	sb	zero,0(s8)
  return buf;
}
 168:	855e                	mv	a0,s7
 16a:	60e6                	ld	ra,88(sp)
 16c:	6446                	ld	s0,80(sp)
 16e:	64a6                	ld	s1,72(sp)
 170:	6906                	ld	s2,64(sp)
 172:	79e2                	ld	s3,56(sp)
 174:	7a42                	ld	s4,48(sp)
 176:	7aa2                	ld	s5,40(sp)
 178:	7b02                	ld	s6,32(sp)
 17a:	6be2                	ld	s7,24(sp)
 17c:	6c42                	ld	s8,16(sp)
 17e:	6125                	addi	sp,sp,96
 180:	8082                	ret

0000000000000182 <stat>:

int
stat(const char *n, struct stat *st)
{
 182:	1101                	addi	sp,sp,-32
 184:	ec06                	sd	ra,24(sp)
 186:	e822                	sd	s0,16(sp)
 188:	e04a                	sd	s2,0(sp)
 18a:	1000                	addi	s0,sp,32
 18c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18e:	4581                	li	a1,0
 190:	198000ef          	jal	328 <open>
  if(fd < 0)
 194:	02054263          	bltz	a0,1b8 <stat+0x36>
 198:	e426                	sd	s1,8(sp)
 19a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 19c:	85ca                	mv	a1,s2
 19e:	1a2000ef          	jal	340 <fstat>
 1a2:	892a                	mv	s2,a0
  close(fd);
 1a4:	8526                	mv	a0,s1
 1a6:	16a000ef          	jal	310 <close>
  return r;
 1aa:	64a2                	ld	s1,8(sp)
}
 1ac:	854a                	mv	a0,s2
 1ae:	60e2                	ld	ra,24(sp)
 1b0:	6442                	ld	s0,16(sp)
 1b2:	6902                	ld	s2,0(sp)
 1b4:	6105                	addi	sp,sp,32
 1b6:	8082                	ret
    return -1;
 1b8:	57fd                	li	a5,-1
 1ba:	893e                	mv	s2,a5
 1bc:	bfc5                	j	1ac <stat+0x2a>

00000000000001be <atoi>:

int
atoi(const char *s)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e406                	sd	ra,8(sp)
 1c2:	e022                	sd	s0,0(sp)
 1c4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c6:	00054683          	lbu	a3,0(a0)
 1ca:	fd06879b          	addiw	a5,a3,-48
 1ce:	0ff7f793          	zext.b	a5,a5
 1d2:	4625                	li	a2,9
 1d4:	02f66963          	bltu	a2,a5,206 <atoi+0x48>
 1d8:	872a                	mv	a4,a0
  n = 0;
 1da:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1dc:	0705                	addi	a4,a4,1
 1de:	0025179b          	slliw	a5,a0,0x2
 1e2:	9fa9                	addw	a5,a5,a0
 1e4:	0017979b          	slliw	a5,a5,0x1
 1e8:	9fb5                	addw	a5,a5,a3
 1ea:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ee:	00074683          	lbu	a3,0(a4)
 1f2:	fd06879b          	addiw	a5,a3,-48
 1f6:	0ff7f793          	zext.b	a5,a5
 1fa:	fef671e3          	bgeu	a2,a5,1dc <atoi+0x1e>
  return n;
}
 1fe:	60a2                	ld	ra,8(sp)
 200:	6402                	ld	s0,0(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret
  n = 0;
 206:	4501                	li	a0,0
 208:	bfdd                	j	1fe <atoi+0x40>

000000000000020a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e406                	sd	ra,8(sp)
 20e:	e022                	sd	s0,0(sp)
 210:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 212:	02b57563          	bgeu	a0,a1,23c <memmove+0x32>
    while(n-- > 0)
 216:	00c05f63          	blez	a2,234 <memmove+0x2a>
 21a:	1602                	slli	a2,a2,0x20
 21c:	9201                	srli	a2,a2,0x20
 21e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 222:	872a                	mv	a4,a0
      *dst++ = *src++;
 224:	0585                	addi	a1,a1,1
 226:	0705                	addi	a4,a4,1
 228:	fff5c683          	lbu	a3,-1(a1)
 22c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 230:	fee79ae3          	bne	a5,a4,224 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 234:	60a2                	ld	ra,8(sp)
 236:	6402                	ld	s0,0(sp)
 238:	0141                	addi	sp,sp,16
 23a:	8082                	ret
    while(n-- > 0)
 23c:	fec05ce3          	blez	a2,234 <memmove+0x2a>
    dst += n;
 240:	00c50733          	add	a4,a0,a2
    src += n;
 244:	95b2                	add	a1,a1,a2
 246:	fff6079b          	addiw	a5,a2,-1
 24a:	1782                	slli	a5,a5,0x20
 24c:	9381                	srli	a5,a5,0x20
 24e:	fff7c793          	not	a5,a5
 252:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 254:	15fd                	addi	a1,a1,-1
 256:	177d                	addi	a4,a4,-1
 258:	0005c683          	lbu	a3,0(a1)
 25c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 260:	fef71ae3          	bne	a4,a5,254 <memmove+0x4a>
 264:	bfc1                	j	234 <memmove+0x2a>

0000000000000266 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 266:	1141                	addi	sp,sp,-16
 268:	e406                	sd	ra,8(sp)
 26a:	e022                	sd	s0,0(sp)
 26c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26e:	c61d                	beqz	a2,29c <memcmp+0x36>
 270:	1602                	slli	a2,a2,0x20
 272:	9201                	srli	a2,a2,0x20
 274:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 278:	00054783          	lbu	a5,0(a0)
 27c:	0005c703          	lbu	a4,0(a1)
 280:	00e79863          	bne	a5,a4,290 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 284:	0505                	addi	a0,a0,1
    p2++;
 286:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 288:	fed518e3          	bne	a0,a3,278 <memcmp+0x12>
  }
  return 0;
 28c:	4501                	li	a0,0
 28e:	a019                	j	294 <memcmp+0x2e>
      return *p1 - *p2;
 290:	40e7853b          	subw	a0,a5,a4
}
 294:	60a2                	ld	ra,8(sp)
 296:	6402                	ld	s0,0(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
  return 0;
 29c:	4501                	li	a0,0
 29e:	bfdd                	j	294 <memcmp+0x2e>

00000000000002a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a8:	f63ff0ef          	jal	20a <memmove>
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <sbrk>:

char *
sbrk(int n) {
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2bc:	4585                	li	a1,1
 2be:	0b2000ef          	jal	370 <sys_sbrk>
}
 2c2:	60a2                	ld	ra,8(sp)
 2c4:	6402                	ld	s0,0(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret

00000000000002ca <sbrklazy>:

char *
sbrklazy(int n) {
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e406                	sd	ra,8(sp)
 2ce:	e022                	sd	s0,0(sp)
 2d0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2d2:	4589                	li	a1,2
 2d4:	09c000ef          	jal	370 <sys_sbrk>
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e0:	4885                	li	a7,1
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e8:	4889                	li	a7,2
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f0:	488d                	li	a7,3
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f8:	4891                	li	a7,4
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <read>:
.global read
read:
 li a7, SYS_read
 300:	4895                	li	a7,5
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <write>:
.global write
write:
 li a7, SYS_write
 308:	48c1                	li	a7,16
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <close>:
.global close
close:
 li a7, SYS_close
 310:	48d5                	li	a7,21
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <kill>:
.global kill
kill:
 li a7, SYS_kill
 318:	4899                	li	a7,6
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <exec>:
.global exec
exec:
 li a7, SYS_exec
 320:	489d                	li	a7,7
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <open>:
.global open
open:
 li a7, SYS_open
 328:	48bd                	li	a7,15
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 330:	48c5                	li	a7,17
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 338:	48c9                	li	a7,18
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 340:	48a1                	li	a7,8
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <link>:
.global link
link:
 li a7, SYS_link
 348:	48cd                	li	a7,19
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 350:	48d1                	li	a7,20
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 358:	48a5                	li	a7,9
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <dup>:
.global dup
dup:
 li a7, SYS_dup
 360:	48a9                	li	a7,10
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 368:	48ad                	li	a7,11
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 370:	48b1                	li	a7,12
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <pause>:
.global pause
pause:
 li a7, SYS_pause
 378:	48b5                	li	a7,13
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 380:	48b9                	li	a7,14
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <hello>:
.global hello
hello:
 li a7, SYS_hello
 388:	48d9                	li	a7,22
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 390:	48dd                	li	a7,23
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 398:	48e1                	li	a7,24
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 3a0:	48e5                	li	a7,25
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 3a8:	48e9                	li	a7,26
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 3b0:	48ed                	li	a7,27
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 3b8:	48f1                	li	a7,28
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 3c0:	48f5                	li	a7,29
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 3c8:	48f9                	li	a7,30
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 3d0:	48fd                	li	a7,31
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d8:	1101                	addi	sp,sp,-32
 3da:	ec06                	sd	ra,24(sp)
 3dc:	e822                	sd	s0,16(sp)
 3de:	1000                	addi	s0,sp,32
 3e0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e4:	4605                	li	a2,1
 3e6:	fef40593          	addi	a1,s0,-17
 3ea:	f1fff0ef          	jal	308 <write>
}
 3ee:	60e2                	ld	ra,24(sp)
 3f0:	6442                	ld	s0,16(sp)
 3f2:	6105                	addi	sp,sp,32
 3f4:	8082                	ret

00000000000003f6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3f6:	715d                	addi	sp,sp,-80
 3f8:	e486                	sd	ra,72(sp)
 3fa:	e0a2                	sd	s0,64(sp)
 3fc:	f84a                	sd	s2,48(sp)
 3fe:	f44e                	sd	s3,40(sp)
 400:	0880                	addi	s0,sp,80
 402:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 404:	c6d1                	beqz	a3,490 <printint+0x9a>
 406:	0805d563          	bgez	a1,490 <printint+0x9a>
    neg = 1;
    x = -xx;
 40a:	40b005b3          	neg	a1,a1
    neg = 1;
 40e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 410:	fb840993          	addi	s3,s0,-72
  neg = 0;
 414:	86ce                	mv	a3,s3
  i = 0;
 416:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 418:	00000817          	auipc	a6,0x0
 41c:	54880813          	addi	a6,a6,1352 # 960 <digits>
 420:	88ba                	mv	a7,a4
 422:	0017051b          	addiw	a0,a4,1
 426:	872a                	mv	a4,a0
 428:	02c5f7b3          	remu	a5,a1,a2
 42c:	97c2                	add	a5,a5,a6
 42e:	0007c783          	lbu	a5,0(a5)
 432:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 436:	87ae                	mv	a5,a1
 438:	02c5d5b3          	divu	a1,a1,a2
 43c:	0685                	addi	a3,a3,1
 43e:	fec7f1e3          	bgeu	a5,a2,420 <printint+0x2a>
  if(neg)
 442:	00030c63          	beqz	t1,45a <printint+0x64>
    buf[i++] = '-';
 446:	fd050793          	addi	a5,a0,-48
 44a:	00878533          	add	a0,a5,s0
 44e:	02d00793          	li	a5,45
 452:	fef50423          	sb	a5,-24(a0)
 456:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 45a:	02e05563          	blez	a4,484 <printint+0x8e>
 45e:	fc26                	sd	s1,56(sp)
 460:	377d                	addiw	a4,a4,-1
 462:	00e984b3          	add	s1,s3,a4
 466:	19fd                	addi	s3,s3,-1
 468:	99ba                	add	s3,s3,a4
 46a:	1702                	slli	a4,a4,0x20
 46c:	9301                	srli	a4,a4,0x20
 46e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 472:	0004c583          	lbu	a1,0(s1)
 476:	854a                	mv	a0,s2
 478:	f61ff0ef          	jal	3d8 <putc>
  while(--i >= 0)
 47c:	14fd                	addi	s1,s1,-1
 47e:	ff349ae3          	bne	s1,s3,472 <printint+0x7c>
 482:	74e2                	ld	s1,56(sp)
}
 484:	60a6                	ld	ra,72(sp)
 486:	6406                	ld	s0,64(sp)
 488:	7942                	ld	s2,48(sp)
 48a:	79a2                	ld	s3,40(sp)
 48c:	6161                	addi	sp,sp,80
 48e:	8082                	ret
  neg = 0;
 490:	4301                	li	t1,0
 492:	bfbd                	j	410 <printint+0x1a>

0000000000000494 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 494:	711d                	addi	sp,sp,-96
 496:	ec86                	sd	ra,88(sp)
 498:	e8a2                	sd	s0,80(sp)
 49a:	e4a6                	sd	s1,72(sp)
 49c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 49e:	0005c483          	lbu	s1,0(a1)
 4a2:	22048363          	beqz	s1,6c8 <vprintf+0x234>
 4a6:	e0ca                	sd	s2,64(sp)
 4a8:	fc4e                	sd	s3,56(sp)
 4aa:	f852                	sd	s4,48(sp)
 4ac:	f456                	sd	s5,40(sp)
 4ae:	f05a                	sd	s6,32(sp)
 4b0:	ec5e                	sd	s7,24(sp)
 4b2:	e862                	sd	s8,16(sp)
 4b4:	8b2a                	mv	s6,a0
 4b6:	8a2e                	mv	s4,a1
 4b8:	8bb2                	mv	s7,a2
  state = 0;
 4ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4bc:	4901                	li	s2,0
 4be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c4:	06400c13          	li	s8,100
 4c8:	a00d                	j	4ea <vprintf+0x56>
        putc(fd, c0);
 4ca:	85a6                	mv	a1,s1
 4cc:	855a                	mv	a0,s6
 4ce:	f0bff0ef          	jal	3d8 <putc>
 4d2:	a019                	j	4d8 <vprintf+0x44>
    } else if(state == '%'){
 4d4:	03598363          	beq	s3,s5,4fa <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4d8:	0019079b          	addiw	a5,s2,1
 4dc:	893e                	mv	s2,a5
 4de:	873e                	mv	a4,a5
 4e0:	97d2                	add	a5,a5,s4
 4e2:	0007c483          	lbu	s1,0(a5)
 4e6:	1c048a63          	beqz	s1,6ba <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4ea:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4ee:	fe0993e3          	bnez	s3,4d4 <vprintf+0x40>
      if(c0 == '%'){
 4f2:	fd579ce3          	bne	a5,s5,4ca <vprintf+0x36>
        state = '%';
 4f6:	89be                	mv	s3,a5
 4f8:	b7c5                	j	4d8 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4fa:	00ea06b3          	add	a3,s4,a4
 4fe:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 502:	1c060863          	beqz	a2,6d2 <vprintf+0x23e>
      if(c0 == 'd'){
 506:	03878763          	beq	a5,s8,534 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 50a:	f9478693          	addi	a3,a5,-108
 50e:	0016b693          	seqz	a3,a3
 512:	f9c60593          	addi	a1,a2,-100
 516:	e99d                	bnez	a1,54c <vprintf+0xb8>
 518:	ca95                	beqz	a3,54c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 51a:	008b8493          	addi	s1,s7,8
 51e:	4685                	li	a3,1
 520:	4629                	li	a2,10
 522:	000bb583          	ld	a1,0(s7)
 526:	855a                	mv	a0,s6
 528:	ecfff0ef          	jal	3f6 <printint>
        i += 1;
 52c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 52e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 530:	4981                	li	s3,0
 532:	b75d                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 534:	008b8493          	addi	s1,s7,8
 538:	4685                	li	a3,1
 53a:	4629                	li	a2,10
 53c:	000ba583          	lw	a1,0(s7)
 540:	855a                	mv	a0,s6
 542:	eb5ff0ef          	jal	3f6 <printint>
 546:	8ba6                	mv	s7,s1
      state = 0;
 548:	4981                	li	s3,0
 54a:	b779                	j	4d8 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 54c:	9752                	add	a4,a4,s4
 54e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 552:	f9460713          	addi	a4,a2,-108
 556:	00173713          	seqz	a4,a4
 55a:	8f75                	and	a4,a4,a3
 55c:	f9c58513          	addi	a0,a1,-100
 560:	18051363          	bnez	a0,6e6 <vprintf+0x252>
 564:	18070163          	beqz	a4,6e6 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 568:	008b8493          	addi	s1,s7,8
 56c:	4685                	li	a3,1
 56e:	4629                	li	a2,10
 570:	000bb583          	ld	a1,0(s7)
 574:	855a                	mv	a0,s6
 576:	e81ff0ef          	jal	3f6 <printint>
        i += 2;
 57a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 57c:	8ba6                	mv	s7,s1
      state = 0;
 57e:	4981                	li	s3,0
        i += 2;
 580:	bfa1                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 582:	008b8493          	addi	s1,s7,8
 586:	4681                	li	a3,0
 588:	4629                	li	a2,10
 58a:	000be583          	lwu	a1,0(s7)
 58e:	855a                	mv	a0,s6
 590:	e67ff0ef          	jal	3f6 <printint>
 594:	8ba6                	mv	s7,s1
      state = 0;
 596:	4981                	li	s3,0
 598:	b781                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59a:	008b8493          	addi	s1,s7,8
 59e:	4681                	li	a3,0
 5a0:	4629                	li	a2,10
 5a2:	000bb583          	ld	a1,0(s7)
 5a6:	855a                	mv	a0,s6
 5a8:	e4fff0ef          	jal	3f6 <printint>
        i += 1;
 5ac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ae:	8ba6                	mv	s7,s1
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b71d                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b4:	008b8493          	addi	s1,s7,8
 5b8:	4681                	li	a3,0
 5ba:	4629                	li	a2,10
 5bc:	000bb583          	ld	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	e35ff0ef          	jal	3f6 <printint>
        i += 2;
 5c6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	8ba6                	mv	s7,s1
      state = 0;
 5ca:	4981                	li	s3,0
        i += 2;
 5cc:	b731                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5ce:	008b8493          	addi	s1,s7,8
 5d2:	4681                	li	a3,0
 5d4:	4641                	li	a2,16
 5d6:	000be583          	lwu	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	e1bff0ef          	jal	3f6 <printint>
 5e0:	8ba6                	mv	s7,s1
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	bdd5                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e6:	008b8493          	addi	s1,s7,8
 5ea:	4681                	li	a3,0
 5ec:	4641                	li	a2,16
 5ee:	000bb583          	ld	a1,0(s7)
 5f2:	855a                	mv	a0,s6
 5f4:	e03ff0ef          	jal	3f6 <printint>
        i += 1;
 5f8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fa:	8ba6                	mv	s7,s1
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	bde9                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 600:	008b8493          	addi	s1,s7,8
 604:	4681                	li	a3,0
 606:	4641                	li	a2,16
 608:	000bb583          	ld	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	de9ff0ef          	jal	3f6 <printint>
        i += 2;
 612:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 614:	8ba6                	mv	s7,s1
      state = 0;
 616:	4981                	li	s3,0
        i += 2;
 618:	b5c1                	j	4d8 <vprintf+0x44>
 61a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 61c:	008b8793          	addi	a5,s7,8
 620:	8cbe                	mv	s9,a5
 622:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 626:	03000593          	li	a1,48
 62a:	855a                	mv	a0,s6
 62c:	dadff0ef          	jal	3d8 <putc>
  putc(fd, 'x');
 630:	07800593          	li	a1,120
 634:	855a                	mv	a0,s6
 636:	da3ff0ef          	jal	3d8 <putc>
 63a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63c:	00000b97          	auipc	s7,0x0
 640:	324b8b93          	addi	s7,s7,804 # 960 <digits>
 644:	03c9d793          	srli	a5,s3,0x3c
 648:	97de                	add	a5,a5,s7
 64a:	0007c583          	lbu	a1,0(a5)
 64e:	855a                	mv	a0,s6
 650:	d89ff0ef          	jal	3d8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 654:	0992                	slli	s3,s3,0x4
 656:	34fd                	addiw	s1,s1,-1
 658:	f4f5                	bnez	s1,644 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 65a:	8be6                	mv	s7,s9
      state = 0;
 65c:	4981                	li	s3,0
 65e:	6ca2                	ld	s9,8(sp)
 660:	bda5                	j	4d8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 662:	008b8493          	addi	s1,s7,8
 666:	000bc583          	lbu	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	d6dff0ef          	jal	3d8 <putc>
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
 674:	b595                	j	4d8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 676:	008b8993          	addi	s3,s7,8
 67a:	000bb483          	ld	s1,0(s7)
 67e:	cc91                	beqz	s1,69a <vprintf+0x206>
        for(; *s; s++)
 680:	0004c583          	lbu	a1,0(s1)
 684:	c985                	beqz	a1,6b4 <vprintf+0x220>
          putc(fd, *s);
 686:	855a                	mv	a0,s6
 688:	d51ff0ef          	jal	3d8 <putc>
        for(; *s; s++)
 68c:	0485                	addi	s1,s1,1
 68e:	0004c583          	lbu	a1,0(s1)
 692:	f9f5                	bnez	a1,686 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 694:	8bce                	mv	s7,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	b581                	j	4d8 <vprintf+0x44>
          s = "(null)";
 69a:	00000497          	auipc	s1,0x0
 69e:	2be48493          	addi	s1,s1,702 # 958 <malloc+0x122>
        for(; *s; s++)
 6a2:	02800593          	li	a1,40
 6a6:	b7c5                	j	686 <vprintf+0x1f2>
        putc(fd, '%');
 6a8:	85be                	mv	a1,a5
 6aa:	855a                	mv	a0,s6
 6ac:	d2dff0ef          	jal	3d8 <putc>
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b51d                	j	4d8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6b4:	8bce                	mv	s7,s3
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b505                	j	4d8 <vprintf+0x44>
 6ba:	6906                	ld	s2,64(sp)
 6bc:	79e2                	ld	s3,56(sp)
 6be:	7a42                	ld	s4,48(sp)
 6c0:	7aa2                	ld	s5,40(sp)
 6c2:	7b02                	ld	s6,32(sp)
 6c4:	6be2                	ld	s7,24(sp)
 6c6:	6c42                	ld	s8,16(sp)
    }
  }
}
 6c8:	60e6                	ld	ra,88(sp)
 6ca:	6446                	ld	s0,80(sp)
 6cc:	64a6                	ld	s1,72(sp)
 6ce:	6125                	addi	sp,sp,96
 6d0:	8082                	ret
      if(c0 == 'd'){
 6d2:	06400713          	li	a4,100
 6d6:	e4e78fe3          	beq	a5,a4,534 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6da:	f9478693          	addi	a3,a5,-108
 6de:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6e2:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e4:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6e6:	07500513          	li	a0,117
 6ea:	e8a78ce3          	beq	a5,a0,582 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6ee:	f8b60513          	addi	a0,a2,-117
 6f2:	e119                	bnez	a0,6f8 <vprintf+0x264>
 6f4:	ea0693e3          	bnez	a3,59a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6f8:	f8b58513          	addi	a0,a1,-117
 6fc:	e119                	bnez	a0,702 <vprintf+0x26e>
 6fe:	ea071be3          	bnez	a4,5b4 <vprintf+0x120>
      } else if(c0 == 'x'){
 702:	07800513          	li	a0,120
 706:	eca784e3          	beq	a5,a0,5ce <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 70a:	f8860613          	addi	a2,a2,-120
 70e:	e219                	bnez	a2,714 <vprintf+0x280>
 710:	ec069be3          	bnez	a3,5e6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 714:	f8858593          	addi	a1,a1,-120
 718:	e199                	bnez	a1,71e <vprintf+0x28a>
 71a:	ee0713e3          	bnez	a4,600 <vprintf+0x16c>
      } else if(c0 == 'p'){
 71e:	07000713          	li	a4,112
 722:	eee78ce3          	beq	a5,a4,61a <vprintf+0x186>
      } else if(c0 == 'c'){
 726:	06300713          	li	a4,99
 72a:	f2e78ce3          	beq	a5,a4,662 <vprintf+0x1ce>
      } else if(c0 == 's'){
 72e:	07300713          	li	a4,115
 732:	f4e782e3          	beq	a5,a4,676 <vprintf+0x1e2>
      } else if(c0 == '%'){
 736:	02500713          	li	a4,37
 73a:	f6e787e3          	beq	a5,a4,6a8 <vprintf+0x214>
        putc(fd, '%');
 73e:	02500593          	li	a1,37
 742:	855a                	mv	a0,s6
 744:	c95ff0ef          	jal	3d8 <putc>
        putc(fd, c0);
 748:	85a6                	mv	a1,s1
 74a:	855a                	mv	a0,s6
 74c:	c8dff0ef          	jal	3d8 <putc>
      state = 0;
 750:	4981                	li	s3,0
 752:	b359                	j	4d8 <vprintf+0x44>

0000000000000754 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 754:	715d                	addi	sp,sp,-80
 756:	ec06                	sd	ra,24(sp)
 758:	e822                	sd	s0,16(sp)
 75a:	1000                	addi	s0,sp,32
 75c:	e010                	sd	a2,0(s0)
 75e:	e414                	sd	a3,8(s0)
 760:	e818                	sd	a4,16(s0)
 762:	ec1c                	sd	a5,24(s0)
 764:	03043023          	sd	a6,32(s0)
 768:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76c:	8622                	mv	a2,s0
 76e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 772:	d23ff0ef          	jal	494 <vprintf>
}
 776:	60e2                	ld	ra,24(sp)
 778:	6442                	ld	s0,16(sp)
 77a:	6161                	addi	sp,sp,80
 77c:	8082                	ret

000000000000077e <printf>:

void
printf(const char *fmt, ...)
{
 77e:	711d                	addi	sp,sp,-96
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e40c                	sd	a1,8(s0)
 788:	e810                	sd	a2,16(s0)
 78a:	ec14                	sd	a3,24(s0)
 78c:	f018                	sd	a4,32(s0)
 78e:	f41c                	sd	a5,40(s0)
 790:	03043823          	sd	a6,48(s0)
 794:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	00840613          	addi	a2,s0,8
 79c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a0:	85aa                	mv	a1,a0
 7a2:	4505                	li	a0,1
 7a4:	cf1ff0ef          	jal	494 <vprintf>
}
 7a8:	60e2                	ld	ra,24(sp)
 7aa:	6442                	ld	s0,16(sp)
 7ac:	6125                	addi	sp,sp,96
 7ae:	8082                	ret

00000000000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	1141                	addi	sp,sp,-16
 7b2:	e406                	sd	ra,8(sp)
 7b4:	e022                	sd	s0,0(sp)
 7b6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bc:	00001797          	auipc	a5,0x1
 7c0:	8447b783          	ld	a5,-1980(a5) # 1000 <freep>
 7c4:	a039                	j	7d2 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c6:	6398                	ld	a4,0(a5)
 7c8:	00e7e463          	bltu	a5,a4,7d0 <free+0x20>
 7cc:	00e6ea63          	bltu	a3,a4,7e0 <free+0x30>
{
 7d0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d2:	fed7fae3          	bgeu	a5,a3,7c6 <free+0x16>
 7d6:	6398                	ld	a4,0(a5)
 7d8:	00e6e463          	bltu	a3,a4,7e0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7dc:	fee7eae3          	bltu	a5,a4,7d0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e0:	ff852583          	lw	a1,-8(a0)
 7e4:	6390                	ld	a2,0(a5)
 7e6:	02059813          	slli	a6,a1,0x20
 7ea:	01c85713          	srli	a4,a6,0x1c
 7ee:	9736                	add	a4,a4,a3
 7f0:	02e60563          	beq	a2,a4,81a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7f4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7f8:	4790                	lw	a2,8(a5)
 7fa:	02061593          	slli	a1,a2,0x20
 7fe:	01c5d713          	srli	a4,a1,0x1c
 802:	973e                	add	a4,a4,a5
 804:	02e68263          	beq	a3,a4,828 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 808:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 80a:	00000717          	auipc	a4,0x0
 80e:	7ef73b23          	sd	a5,2038(a4) # 1000 <freep>
}
 812:	60a2                	ld	ra,8(sp)
 814:	6402                	ld	s0,0(sp)
 816:	0141                	addi	sp,sp,16
 818:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 81a:	4618                	lw	a4,8(a2)
 81c:	9f2d                	addw	a4,a4,a1
 81e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 822:	6398                	ld	a4,0(a5)
 824:	6310                	ld	a2,0(a4)
 826:	b7f9                	j	7f4 <free+0x44>
    p->s.size += bp->s.size;
 828:	ff852703          	lw	a4,-8(a0)
 82c:	9f31                	addw	a4,a4,a2
 82e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 830:	ff053683          	ld	a3,-16(a0)
 834:	bfd1                	j	808 <free+0x58>

0000000000000836 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 836:	7139                	addi	sp,sp,-64
 838:	fc06                	sd	ra,56(sp)
 83a:	f822                	sd	s0,48(sp)
 83c:	f04a                	sd	s2,32(sp)
 83e:	ec4e                	sd	s3,24(sp)
 840:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 842:	02051993          	slli	s3,a0,0x20
 846:	0209d993          	srli	s3,s3,0x20
 84a:	09bd                	addi	s3,s3,15
 84c:	0049d993          	srli	s3,s3,0x4
 850:	2985                	addiw	s3,s3,1
 852:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 854:	00000517          	auipc	a0,0x0
 858:	7ac53503          	ld	a0,1964(a0) # 1000 <freep>
 85c:	c905                	beqz	a0,88c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 860:	4798                	lw	a4,8(a5)
 862:	09377663          	bgeu	a4,s3,8ee <malloc+0xb8>
 866:	f426                	sd	s1,40(sp)
 868:	e852                	sd	s4,16(sp)
 86a:	e456                	sd	s5,8(sp)
 86c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 86e:	8a4e                	mv	s4,s3
 870:	6705                	lui	a4,0x1
 872:	00e9f363          	bgeu	s3,a4,878 <malloc+0x42>
 876:	6a05                	lui	s4,0x1
 878:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 880:	00000497          	auipc	s1,0x0
 884:	78048493          	addi	s1,s1,1920 # 1000 <freep>
  if(p == SBRK_ERROR)
 888:	5afd                	li	s5,-1
 88a:	a83d                	j	8c8 <malloc+0x92>
 88c:	f426                	sd	s1,40(sp)
 88e:	e852                	sd	s4,16(sp)
 890:	e456                	sd	s5,8(sp)
 892:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 894:	00000797          	auipc	a5,0x0
 898:	77c78793          	addi	a5,a5,1916 # 1010 <base>
 89c:	00000717          	auipc	a4,0x0
 8a0:	76f73223          	sd	a5,1892(a4) # 1000 <freep>
 8a4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8aa:	b7d1                	j	86e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ac:	6398                	ld	a4,0(a5)
 8ae:	e118                	sd	a4,0(a0)
 8b0:	a899                	j	906 <malloc+0xd0>
  hp->s.size = nu;
 8b2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b6:	0541                	addi	a0,a0,16
 8b8:	ef9ff0ef          	jal	7b0 <free>
  return freep;
 8bc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8be:	c125                	beqz	a0,91e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c2:	4798                	lw	a4,8(a5)
 8c4:	03277163          	bgeu	a4,s2,8e6 <malloc+0xb0>
    if(p == freep)
 8c8:	6098                	ld	a4,0(s1)
 8ca:	853e                	mv	a0,a5
 8cc:	fef71ae3          	bne	a4,a5,8c0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8d0:	8552                	mv	a0,s4
 8d2:	9e3ff0ef          	jal	2b4 <sbrk>
  if(p == SBRK_ERROR)
 8d6:	fd551ee3          	bne	a0,s5,8b2 <malloc+0x7c>
        return 0;
 8da:	4501                	li	a0,0
 8dc:	74a2                	ld	s1,40(sp)
 8de:	6a42                	ld	s4,16(sp)
 8e0:	6aa2                	ld	s5,8(sp)
 8e2:	6b02                	ld	s6,0(sp)
 8e4:	a03d                	j	912 <malloc+0xdc>
 8e6:	74a2                	ld	s1,40(sp)
 8e8:	6a42                	ld	s4,16(sp)
 8ea:	6aa2                	ld	s5,8(sp)
 8ec:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ee:	fae90fe3          	beq	s2,a4,8ac <malloc+0x76>
        p->s.size -= nunits;
 8f2:	4137073b          	subw	a4,a4,s3
 8f6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f8:	02071693          	slli	a3,a4,0x20
 8fc:	01c6d713          	srli	a4,a3,0x1c
 900:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 902:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 906:	00000717          	auipc	a4,0x0
 90a:	6ea73d23          	sd	a0,1786(a4) # 1000 <freep>
      return (void*)(p + 1);
 90e:	01078513          	addi	a0,a5,16
  }
}
 912:	70e2                	ld	ra,56(sp)
 914:	7442                	ld	s0,48(sp)
 916:	7902                	ld	s2,32(sp)
 918:	69e2                	ld	s3,24(sp)
 91a:	6121                	addi	sp,sp,64
 91c:	8082                	ret
 91e:	74a2                	ld	s1,40(sp)
 920:	6a42                	ld	s4,16(sp)
 922:	6aa2                	ld	s5,8(sp)
 924:	6b02                	ld	s6,0(sp)
 926:	b7f5                	j	912 <malloc+0xdc>
