
user/_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(void){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  hello();
   8:	360000ef          	jal	368 <hello>
  exit(0);
   c:	4501                	li	a0,0
   e:	2ba000ef          	jal	2c8 <exit>

0000000000000012 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  12:	1141                	addi	sp,sp,-16
  14:	e406                	sd	ra,8(sp)
  16:	e022                	sd	s0,0(sp)
  18:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  1a:	fe7ff0ef          	jal	0 <main>
  exit(r);
  1e:	2aa000ef          	jal	2c8 <exit>

0000000000000022 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  22:	1141                	addi	sp,sp,-16
  24:	e406                	sd	ra,8(sp)
  26:	e022                	sd	s0,0(sp)
  28:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2a:	87aa                	mv	a5,a0
  2c:	0585                	addi	a1,a1,1
  2e:	0785                	addi	a5,a5,1
  30:	fff5c703          	lbu	a4,-1(a1)
  34:	fee78fa3          	sb	a4,-1(a5)
  38:	fb75                	bnez	a4,2c <strcpy+0xa>
    ;
  return os;
}
  3a:	60a2                	ld	ra,8(sp)
  3c:	6402                	ld	s0,0(sp)
  3e:	0141                	addi	sp,sp,16
  40:	8082                	ret

0000000000000042 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  42:	1141                	addi	sp,sp,-16
  44:	e406                	sd	ra,8(sp)
  46:	e022                	sd	s0,0(sp)
  48:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4a:	00054783          	lbu	a5,0(a0)
  4e:	cb91                	beqz	a5,62 <strcmp+0x20>
  50:	0005c703          	lbu	a4,0(a1)
  54:	00f71763          	bne	a4,a5,62 <strcmp+0x20>
    p++, q++;
  58:	0505                	addi	a0,a0,1
  5a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	fbe5                	bnez	a5,50 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  62:	0005c503          	lbu	a0,0(a1)
}
  66:	40a7853b          	subw	a0,a5,a0
  6a:	60a2                	ld	ra,8(sp)
  6c:	6402                	ld	s0,0(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e406                	sd	ra,8(sp)
  76:	e022                	sd	s0,0(sp)
  78:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7a:	00054783          	lbu	a5,0(a0)
  7e:	cf91                	beqz	a5,9a <strlen+0x28>
  80:	00150793          	addi	a5,a0,1
  84:	86be                	mv	a3,a5
  86:	0785                	addi	a5,a5,1
  88:	fff7c703          	lbu	a4,-1(a5)
  8c:	ff65                	bnez	a4,84 <strlen+0x12>
  8e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  92:	60a2                	ld	ra,8(sp)
  94:	6402                	ld	s0,0(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret
  for(n = 0; s[n]; n++)
  9a:	4501                	li	a0,0
  9c:	bfdd                	j	92 <strlen+0x20>

000000000000009e <memset>:

void*
memset(void *dst, int c, uint n)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e406                	sd	ra,8(sp)
  a2:	e022                	sd	s0,0(sp)
  a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a6:	ca19                	beqz	a2,bc <memset+0x1e>
  a8:	87aa                	mv	a5,a0
  aa:	1602                	slli	a2,a2,0x20
  ac:	9201                	srli	a2,a2,0x20
  ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b6:	0785                	addi	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x14>
  }
  return dst;
}
  bc:	60a2                	ld	ra,8(sp)
  be:	6402                	ld	s0,0(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  for(; *s; s++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	cf81                	beqz	a5,e8 <strchr+0x24>
    if(*s == c)
  d2:	00f58763          	beq	a1,a5,e0 <strchr+0x1c>
  for(; *s; s++)
  d6:	0505                	addi	a0,a0,1
  d8:	00054783          	lbu	a5,0(a0)
  dc:	fbfd                	bnez	a5,d2 <strchr+0xe>
      return (char*)s;
  return 0;
  de:	4501                	li	a0,0
}
  e0:	60a2                	ld	ra,8(sp)
  e2:	6402                	ld	s0,0(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret
  return 0;
  e8:	4501                	li	a0,0
  ea:	bfdd                	j	e0 <strchr+0x1c>

00000000000000ec <gets>:

char*
gets(char *buf, int max)
{
  ec:	711d                	addi	sp,sp,-96
  ee:	ec86                	sd	ra,88(sp)
  f0:	e8a2                	sd	s0,80(sp)
  f2:	e4a6                	sd	s1,72(sp)
  f4:	e0ca                	sd	s2,64(sp)
  f6:	fc4e                	sd	s3,56(sp)
  f8:	f852                	sd	s4,48(sp)
  fa:	f456                	sd	s5,40(sp)
  fc:	f05a                	sd	s6,32(sp)
  fe:	ec5e                	sd	s7,24(sp)
 100:	e862                	sd	s8,16(sp)
 102:	1080                	addi	s0,sp,96
 104:	8baa                	mv	s7,a0
 106:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 108:	892a                	mv	s2,a0
 10a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 10c:	faf40b13          	addi	s6,s0,-81
 110:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 112:	8c26                	mv	s8,s1
 114:	0014899b          	addiw	s3,s1,1
 118:	84ce                	mv	s1,s3
 11a:	0349d463          	bge	s3,s4,142 <gets+0x56>
    cc = read(0, &c, 1);
 11e:	8656                	mv	a2,s5
 120:	85da                	mv	a1,s6
 122:	4501                	li	a0,0
 124:	1bc000ef          	jal	2e0 <read>
    if(cc < 1)
 128:	00a05d63          	blez	a0,142 <gets+0x56>
      break;
    buf[i++] = c;
 12c:	faf44783          	lbu	a5,-81(s0)
 130:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 134:	0905                	addi	s2,s2,1
 136:	ff678713          	addi	a4,a5,-10
 13a:	c319                	beqz	a4,140 <gets+0x54>
 13c:	17cd                	addi	a5,a5,-13
 13e:	fbf1                	bnez	a5,112 <gets+0x26>
    buf[i++] = c;
 140:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 142:	9c5e                	add	s8,s8,s7
 144:	000c0023          	sb	zero,0(s8)
  return buf;
}
 148:	855e                	mv	a0,s7
 14a:	60e6                	ld	ra,88(sp)
 14c:	6446                	ld	s0,80(sp)
 14e:	64a6                	ld	s1,72(sp)
 150:	6906                	ld	s2,64(sp)
 152:	79e2                	ld	s3,56(sp)
 154:	7a42                	ld	s4,48(sp)
 156:	7aa2                	ld	s5,40(sp)
 158:	7b02                	ld	s6,32(sp)
 15a:	6be2                	ld	s7,24(sp)
 15c:	6c42                	ld	s8,16(sp)
 15e:	6125                	addi	sp,sp,96
 160:	8082                	ret

0000000000000162 <stat>:

int
stat(const char *n, struct stat *st)
{
 162:	1101                	addi	sp,sp,-32
 164:	ec06                	sd	ra,24(sp)
 166:	e822                	sd	s0,16(sp)
 168:	e04a                	sd	s2,0(sp)
 16a:	1000                	addi	s0,sp,32
 16c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16e:	4581                	li	a1,0
 170:	198000ef          	jal	308 <open>
  if(fd < 0)
 174:	02054263          	bltz	a0,198 <stat+0x36>
 178:	e426                	sd	s1,8(sp)
 17a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 17c:	85ca                	mv	a1,s2
 17e:	1a2000ef          	jal	320 <fstat>
 182:	892a                	mv	s2,a0
  close(fd);
 184:	8526                	mv	a0,s1
 186:	16a000ef          	jal	2f0 <close>
  return r;
 18a:	64a2                	ld	s1,8(sp)
}
 18c:	854a                	mv	a0,s2
 18e:	60e2                	ld	ra,24(sp)
 190:	6442                	ld	s0,16(sp)
 192:	6902                	ld	s2,0(sp)
 194:	6105                	addi	sp,sp,32
 196:	8082                	ret
    return -1;
 198:	57fd                	li	a5,-1
 19a:	893e                	mv	s2,a5
 19c:	bfc5                	j	18c <stat+0x2a>

000000000000019e <atoi>:

int
atoi(const char *s)
{
 19e:	1141                	addi	sp,sp,-16
 1a0:	e406                	sd	ra,8(sp)
 1a2:	e022                	sd	s0,0(sp)
 1a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a6:	00054683          	lbu	a3,0(a0)
 1aa:	fd06879b          	addiw	a5,a3,-48
 1ae:	0ff7f793          	zext.b	a5,a5
 1b2:	4625                	li	a2,9
 1b4:	02f66963          	bltu	a2,a5,1e6 <atoi+0x48>
 1b8:	872a                	mv	a4,a0
  n = 0;
 1ba:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1bc:	0705                	addi	a4,a4,1
 1be:	0025179b          	slliw	a5,a0,0x2
 1c2:	9fa9                	addw	a5,a5,a0
 1c4:	0017979b          	slliw	a5,a5,0x1
 1c8:	9fb5                	addw	a5,a5,a3
 1ca:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ce:	00074683          	lbu	a3,0(a4)
 1d2:	fd06879b          	addiw	a5,a3,-48
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	fef671e3          	bgeu	a2,a5,1bc <atoi+0x1e>
  return n;
}
 1de:	60a2                	ld	ra,8(sp)
 1e0:	6402                	ld	s0,0(sp)
 1e2:	0141                	addi	sp,sp,16
 1e4:	8082                	ret
  n = 0;
 1e6:	4501                	li	a0,0
 1e8:	bfdd                	j	1de <atoi+0x40>

00000000000001ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f2:	02b57563          	bgeu	a0,a1,21c <memmove+0x32>
    while(n-- > 0)
 1f6:	00c05f63          	blez	a2,214 <memmove+0x2a>
 1fa:	1602                	slli	a2,a2,0x20
 1fc:	9201                	srli	a2,a2,0x20
 1fe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 202:	872a                	mv	a4,a0
      *dst++ = *src++;
 204:	0585                	addi	a1,a1,1
 206:	0705                	addi	a4,a4,1
 208:	fff5c683          	lbu	a3,-1(a1)
 20c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 210:	fee79ae3          	bne	a5,a4,204 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 214:	60a2                	ld	ra,8(sp)
 216:	6402                	ld	s0,0(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret
    while(n-- > 0)
 21c:	fec05ce3          	blez	a2,214 <memmove+0x2a>
    dst += n;
 220:	00c50733          	add	a4,a0,a2
    src += n;
 224:	95b2                	add	a1,a1,a2
 226:	fff6079b          	addiw	a5,a2,-1
 22a:	1782                	slli	a5,a5,0x20
 22c:	9381                	srli	a5,a5,0x20
 22e:	fff7c793          	not	a5,a5
 232:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 234:	15fd                	addi	a1,a1,-1
 236:	177d                	addi	a4,a4,-1
 238:	0005c683          	lbu	a3,0(a1)
 23c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 240:	fef71ae3          	bne	a4,a5,234 <memmove+0x4a>
 244:	bfc1                	j	214 <memmove+0x2a>

0000000000000246 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e406                	sd	ra,8(sp)
 24a:	e022                	sd	s0,0(sp)
 24c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 24e:	c61d                	beqz	a2,27c <memcmp+0x36>
 250:	1602                	slli	a2,a2,0x20
 252:	9201                	srli	a2,a2,0x20
 254:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 258:	00054783          	lbu	a5,0(a0)
 25c:	0005c703          	lbu	a4,0(a1)
 260:	00e79863          	bne	a5,a4,270 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 264:	0505                	addi	a0,a0,1
    p2++;
 266:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 268:	fed518e3          	bne	a0,a3,258 <memcmp+0x12>
  }
  return 0;
 26c:	4501                	li	a0,0
 26e:	a019                	j	274 <memcmp+0x2e>
      return *p1 - *p2;
 270:	40e7853b          	subw	a0,a5,a4
}
 274:	60a2                	ld	ra,8(sp)
 276:	6402                	ld	s0,0(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
  return 0;
 27c:	4501                	li	a0,0
 27e:	bfdd                	j	274 <memcmp+0x2e>

0000000000000280 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 288:	f63ff0ef          	jal	1ea <memmove>
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <sbrk>:

char *
sbrk(int n) {
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 29c:	4585                	li	a1,1
 29e:	0b2000ef          	jal	350 <sys_sbrk>
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret

00000000000002aa <sbrklazy>:

char *
sbrklazy(int n) {
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2b2:	4589                	li	a1,2
 2b4:	09c000ef          	jal	350 <sys_sbrk>
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c0:	4885                	li	a7,1
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c8:	4889                	li	a7,2
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d0:	488d                	li	a7,3
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d8:	4891                	li	a7,4
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <read>:
.global read
read:
 li a7, SYS_read
 2e0:	4895                	li	a7,5
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <write>:
.global write
write:
 li a7, SYS_write
 2e8:	48c1                	li	a7,16
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <close>:
.global close
close:
 li a7, SYS_close
 2f0:	48d5                	li	a7,21
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f8:	4899                	li	a7,6
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exec>:
.global exec
exec:
 li a7, SYS_exec
 300:	489d                	li	a7,7
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <open>:
.global open
open:
 li a7, SYS_open
 308:	48bd                	li	a7,15
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 310:	48c5                	li	a7,17
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 318:	48c9                	li	a7,18
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 320:	48a1                	li	a7,8
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <link>:
.global link
link:
 li a7, SYS_link
 328:	48cd                	li	a7,19
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 330:	48d1                	li	a7,20
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 338:	48a5                	li	a7,9
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <dup>:
.global dup
dup:
 li a7, SYS_dup
 340:	48a9                	li	a7,10
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 348:	48ad                	li	a7,11
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 350:	48b1                	li	a7,12
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <pause>:
.global pause
pause:
 li a7, SYS_pause
 358:	48b5                	li	a7,13
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 360:	48b9                	li	a7,14
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <hello>:
.global hello
hello:
 li a7, SYS_hello
 368:	48d9                	li	a7,22
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 370:	48dd                	li	a7,23
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 378:	48e1                	li	a7,24
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 380:	48e5                	li	a7,25
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 388:	48e9                	li	a7,26
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 390:	48ed                	li	a7,27
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 398:	48f1                	li	a7,28
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 3a0:	48f5                	li	a7,29
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 3a8:	48f9                	li	a7,30
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 3b0:	48fd                	li	a7,31
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b8:	1101                	addi	sp,sp,-32
 3ba:	ec06                	sd	ra,24(sp)
 3bc:	e822                	sd	s0,16(sp)
 3be:	1000                	addi	s0,sp,32
 3c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c4:	4605                	li	a2,1
 3c6:	fef40593          	addi	a1,s0,-17
 3ca:	f1fff0ef          	jal	2e8 <write>
}
 3ce:	60e2                	ld	ra,24(sp)
 3d0:	6442                	ld	s0,16(sp)
 3d2:	6105                	addi	sp,sp,32
 3d4:	8082                	ret

00000000000003d6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3d6:	715d                	addi	sp,sp,-80
 3d8:	e486                	sd	ra,72(sp)
 3da:	e0a2                	sd	s0,64(sp)
 3dc:	f84a                	sd	s2,48(sp)
 3de:	f44e                	sd	s3,40(sp)
 3e0:	0880                	addi	s0,sp,80
 3e2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3e4:	c6d1                	beqz	a3,470 <printint+0x9a>
 3e6:	0805d563          	bgez	a1,470 <printint+0x9a>
    neg = 1;
    x = -xx;
 3ea:	40b005b3          	neg	a1,a1
    neg = 1;
 3ee:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3f0:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3f4:	86ce                	mv	a3,s3
  i = 0;
 3f6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f8:	00000817          	auipc	a6,0x0
 3fc:	52080813          	addi	a6,a6,1312 # 918 <digits>
 400:	88ba                	mv	a7,a4
 402:	0017051b          	addiw	a0,a4,1
 406:	872a                	mv	a4,a0
 408:	02c5f7b3          	remu	a5,a1,a2
 40c:	97c2                	add	a5,a5,a6
 40e:	0007c783          	lbu	a5,0(a5)
 412:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 416:	87ae                	mv	a5,a1
 418:	02c5d5b3          	divu	a1,a1,a2
 41c:	0685                	addi	a3,a3,1
 41e:	fec7f1e3          	bgeu	a5,a2,400 <printint+0x2a>
  if(neg)
 422:	00030c63          	beqz	t1,43a <printint+0x64>
    buf[i++] = '-';
 426:	fd050793          	addi	a5,a0,-48
 42a:	00878533          	add	a0,a5,s0
 42e:	02d00793          	li	a5,45
 432:	fef50423          	sb	a5,-24(a0)
 436:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 43a:	02e05563          	blez	a4,464 <printint+0x8e>
 43e:	fc26                	sd	s1,56(sp)
 440:	377d                	addiw	a4,a4,-1
 442:	00e984b3          	add	s1,s3,a4
 446:	19fd                	addi	s3,s3,-1
 448:	99ba                	add	s3,s3,a4
 44a:	1702                	slli	a4,a4,0x20
 44c:	9301                	srli	a4,a4,0x20
 44e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 452:	0004c583          	lbu	a1,0(s1)
 456:	854a                	mv	a0,s2
 458:	f61ff0ef          	jal	3b8 <putc>
  while(--i >= 0)
 45c:	14fd                	addi	s1,s1,-1
 45e:	ff349ae3          	bne	s1,s3,452 <printint+0x7c>
 462:	74e2                	ld	s1,56(sp)
}
 464:	60a6                	ld	ra,72(sp)
 466:	6406                	ld	s0,64(sp)
 468:	7942                	ld	s2,48(sp)
 46a:	79a2                	ld	s3,40(sp)
 46c:	6161                	addi	sp,sp,80
 46e:	8082                	ret
  neg = 0;
 470:	4301                	li	t1,0
 472:	bfbd                	j	3f0 <printint+0x1a>

0000000000000474 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 474:	711d                	addi	sp,sp,-96
 476:	ec86                	sd	ra,88(sp)
 478:	e8a2                	sd	s0,80(sp)
 47a:	e4a6                	sd	s1,72(sp)
 47c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 47e:	0005c483          	lbu	s1,0(a1)
 482:	22048363          	beqz	s1,6a8 <vprintf+0x234>
 486:	e0ca                	sd	s2,64(sp)
 488:	fc4e                	sd	s3,56(sp)
 48a:	f852                	sd	s4,48(sp)
 48c:	f456                	sd	s5,40(sp)
 48e:	f05a                	sd	s6,32(sp)
 490:	ec5e                	sd	s7,24(sp)
 492:	e862                	sd	s8,16(sp)
 494:	8b2a                	mv	s6,a0
 496:	8a2e                	mv	s4,a1
 498:	8bb2                	mv	s7,a2
  state = 0;
 49a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 49c:	4901                	li	s2,0
 49e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4a0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4a4:	06400c13          	li	s8,100
 4a8:	a00d                	j	4ca <vprintf+0x56>
        putc(fd, c0);
 4aa:	85a6                	mv	a1,s1
 4ac:	855a                	mv	a0,s6
 4ae:	f0bff0ef          	jal	3b8 <putc>
 4b2:	a019                	j	4b8 <vprintf+0x44>
    } else if(state == '%'){
 4b4:	03598363          	beq	s3,s5,4da <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4b8:	0019079b          	addiw	a5,s2,1
 4bc:	893e                	mv	s2,a5
 4be:	873e                	mv	a4,a5
 4c0:	97d2                	add	a5,a5,s4
 4c2:	0007c483          	lbu	s1,0(a5)
 4c6:	1c048a63          	beqz	s1,69a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4ca:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4ce:	fe0993e3          	bnez	s3,4b4 <vprintf+0x40>
      if(c0 == '%'){
 4d2:	fd579ce3          	bne	a5,s5,4aa <vprintf+0x36>
        state = '%';
 4d6:	89be                	mv	s3,a5
 4d8:	b7c5                	j	4b8 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4da:	00ea06b3          	add	a3,s4,a4
 4de:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4e2:	1c060863          	beqz	a2,6b2 <vprintf+0x23e>
      if(c0 == 'd'){
 4e6:	03878763          	beq	a5,s8,514 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ea:	f9478693          	addi	a3,a5,-108
 4ee:	0016b693          	seqz	a3,a3
 4f2:	f9c60593          	addi	a1,a2,-100
 4f6:	e99d                	bnez	a1,52c <vprintf+0xb8>
 4f8:	ca95                	beqz	a3,52c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4fa:	008b8493          	addi	s1,s7,8
 4fe:	4685                	li	a3,1
 500:	4629                	li	a2,10
 502:	000bb583          	ld	a1,0(s7)
 506:	855a                	mv	a0,s6
 508:	ecfff0ef          	jal	3d6 <printint>
        i += 1;
 50c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 50e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 510:	4981                	li	s3,0
 512:	b75d                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 514:	008b8493          	addi	s1,s7,8
 518:	4685                	li	a3,1
 51a:	4629                	li	a2,10
 51c:	000ba583          	lw	a1,0(s7)
 520:	855a                	mv	a0,s6
 522:	eb5ff0ef          	jal	3d6 <printint>
 526:	8ba6                	mv	s7,s1
      state = 0;
 528:	4981                	li	s3,0
 52a:	b779                	j	4b8 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 52c:	9752                	add	a4,a4,s4
 52e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 532:	f9460713          	addi	a4,a2,-108
 536:	00173713          	seqz	a4,a4
 53a:	8f75                	and	a4,a4,a3
 53c:	f9c58513          	addi	a0,a1,-100
 540:	18051363          	bnez	a0,6c6 <vprintf+0x252>
 544:	18070163          	beqz	a4,6c6 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 548:	008b8493          	addi	s1,s7,8
 54c:	4685                	li	a3,1
 54e:	4629                	li	a2,10
 550:	000bb583          	ld	a1,0(s7)
 554:	855a                	mv	a0,s6
 556:	e81ff0ef          	jal	3d6 <printint>
        i += 2;
 55a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 55c:	8ba6                	mv	s7,s1
      state = 0;
 55e:	4981                	li	s3,0
        i += 2;
 560:	bfa1                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 562:	008b8493          	addi	s1,s7,8
 566:	4681                	li	a3,0
 568:	4629                	li	a2,10
 56a:	000be583          	lwu	a1,0(s7)
 56e:	855a                	mv	a0,s6
 570:	e67ff0ef          	jal	3d6 <printint>
 574:	8ba6                	mv	s7,s1
      state = 0;
 576:	4981                	li	s3,0
 578:	b781                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57a:	008b8493          	addi	s1,s7,8
 57e:	4681                	li	a3,0
 580:	4629                	li	a2,10
 582:	000bb583          	ld	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	e4fff0ef          	jal	3d6 <printint>
        i += 1;
 58c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 58e:	8ba6                	mv	s7,s1
      state = 0;
 590:	4981                	li	s3,0
 592:	b71d                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 594:	008b8493          	addi	s1,s7,8
 598:	4681                	li	a3,0
 59a:	4629                	li	a2,10
 59c:	000bb583          	ld	a1,0(s7)
 5a0:	855a                	mv	a0,s6
 5a2:	e35ff0ef          	jal	3d6 <printint>
        i += 2;
 5a6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a8:	8ba6                	mv	s7,s1
      state = 0;
 5aa:	4981                	li	s3,0
        i += 2;
 5ac:	b731                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5ae:	008b8493          	addi	s1,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4641                	li	a2,16
 5b6:	000be583          	lwu	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	e1bff0ef          	jal	3d6 <printint>
 5c0:	8ba6                	mv	s7,s1
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	bdd5                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c6:	008b8493          	addi	s1,s7,8
 5ca:	4681                	li	a3,0
 5cc:	4641                	li	a2,16
 5ce:	000bb583          	ld	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	e03ff0ef          	jal	3d6 <printint>
        i += 1;
 5d8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	bde9                	j	4b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4641                	li	a2,16
 5e8:	000bb583          	ld	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	de9ff0ef          	jal	3d6 <printint>
        i += 2;
 5f2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f4:	8ba6                	mv	s7,s1
      state = 0;
 5f6:	4981                	li	s3,0
        i += 2;
 5f8:	b5c1                	j	4b8 <vprintf+0x44>
 5fa:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5fc:	008b8793          	addi	a5,s7,8
 600:	8cbe                	mv	s9,a5
 602:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 606:	03000593          	li	a1,48
 60a:	855a                	mv	a0,s6
 60c:	dadff0ef          	jal	3b8 <putc>
  putc(fd, 'x');
 610:	07800593          	li	a1,120
 614:	855a                	mv	a0,s6
 616:	da3ff0ef          	jal	3b8 <putc>
 61a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 61c:	00000b97          	auipc	s7,0x0
 620:	2fcb8b93          	addi	s7,s7,764 # 918 <digits>
 624:	03c9d793          	srli	a5,s3,0x3c
 628:	97de                	add	a5,a5,s7
 62a:	0007c583          	lbu	a1,0(a5)
 62e:	855a                	mv	a0,s6
 630:	d89ff0ef          	jal	3b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 634:	0992                	slli	s3,s3,0x4
 636:	34fd                	addiw	s1,s1,-1
 638:	f4f5                	bnez	s1,624 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 63a:	8be6                	mv	s7,s9
      state = 0;
 63c:	4981                	li	s3,0
 63e:	6ca2                	ld	s9,8(sp)
 640:	bda5                	j	4b8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 642:	008b8493          	addi	s1,s7,8
 646:	000bc583          	lbu	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	d6dff0ef          	jal	3b8 <putc>
 650:	8ba6                	mv	s7,s1
      state = 0;
 652:	4981                	li	s3,0
 654:	b595                	j	4b8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 656:	008b8993          	addi	s3,s7,8
 65a:	000bb483          	ld	s1,0(s7)
 65e:	cc91                	beqz	s1,67a <vprintf+0x206>
        for(; *s; s++)
 660:	0004c583          	lbu	a1,0(s1)
 664:	c985                	beqz	a1,694 <vprintf+0x220>
          putc(fd, *s);
 666:	855a                	mv	a0,s6
 668:	d51ff0ef          	jal	3b8 <putc>
        for(; *s; s++)
 66c:	0485                	addi	s1,s1,1
 66e:	0004c583          	lbu	a1,0(s1)
 672:	f9f5                	bnez	a1,666 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 674:	8bce                	mv	s7,s3
      state = 0;
 676:	4981                	li	s3,0
 678:	b581                	j	4b8 <vprintf+0x44>
          s = "(null)";
 67a:	00000497          	auipc	s1,0x0
 67e:	29648493          	addi	s1,s1,662 # 910 <malloc+0xfa>
        for(; *s; s++)
 682:	02800593          	li	a1,40
 686:	b7c5                	j	666 <vprintf+0x1f2>
        putc(fd, '%');
 688:	85be                	mv	a1,a5
 68a:	855a                	mv	a0,s6
 68c:	d2dff0ef          	jal	3b8 <putc>
      state = 0;
 690:	4981                	li	s3,0
 692:	b51d                	j	4b8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 694:	8bce                	mv	s7,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	b505                	j	4b8 <vprintf+0x44>
 69a:	6906                	ld	s2,64(sp)
 69c:	79e2                	ld	s3,56(sp)
 69e:	7a42                	ld	s4,48(sp)
 6a0:	7aa2                	ld	s5,40(sp)
 6a2:	7b02                	ld	s6,32(sp)
 6a4:	6be2                	ld	s7,24(sp)
 6a6:	6c42                	ld	s8,16(sp)
    }
  }
}
 6a8:	60e6                	ld	ra,88(sp)
 6aa:	6446                	ld	s0,80(sp)
 6ac:	64a6                	ld	s1,72(sp)
 6ae:	6125                	addi	sp,sp,96
 6b0:	8082                	ret
      if(c0 == 'd'){
 6b2:	06400713          	li	a4,100
 6b6:	e4e78fe3          	beq	a5,a4,514 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6ba:	f9478693          	addi	a3,a5,-108
 6be:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6c2:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6c4:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6c6:	07500513          	li	a0,117
 6ca:	e8a78ce3          	beq	a5,a0,562 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6ce:	f8b60513          	addi	a0,a2,-117
 6d2:	e119                	bnez	a0,6d8 <vprintf+0x264>
 6d4:	ea0693e3          	bnez	a3,57a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6d8:	f8b58513          	addi	a0,a1,-117
 6dc:	e119                	bnez	a0,6e2 <vprintf+0x26e>
 6de:	ea071be3          	bnez	a4,594 <vprintf+0x120>
      } else if(c0 == 'x'){
 6e2:	07800513          	li	a0,120
 6e6:	eca784e3          	beq	a5,a0,5ae <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6ea:	f8860613          	addi	a2,a2,-120
 6ee:	e219                	bnez	a2,6f4 <vprintf+0x280>
 6f0:	ec069be3          	bnez	a3,5c6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6f4:	f8858593          	addi	a1,a1,-120
 6f8:	e199                	bnez	a1,6fe <vprintf+0x28a>
 6fa:	ee0713e3          	bnez	a4,5e0 <vprintf+0x16c>
      } else if(c0 == 'p'){
 6fe:	07000713          	li	a4,112
 702:	eee78ce3          	beq	a5,a4,5fa <vprintf+0x186>
      } else if(c0 == 'c'){
 706:	06300713          	li	a4,99
 70a:	f2e78ce3          	beq	a5,a4,642 <vprintf+0x1ce>
      } else if(c0 == 's'){
 70e:	07300713          	li	a4,115
 712:	f4e782e3          	beq	a5,a4,656 <vprintf+0x1e2>
      } else if(c0 == '%'){
 716:	02500713          	li	a4,37
 71a:	f6e787e3          	beq	a5,a4,688 <vprintf+0x214>
        putc(fd, '%');
 71e:	02500593          	li	a1,37
 722:	855a                	mv	a0,s6
 724:	c95ff0ef          	jal	3b8 <putc>
        putc(fd, c0);
 728:	85a6                	mv	a1,s1
 72a:	855a                	mv	a0,s6
 72c:	c8dff0ef          	jal	3b8 <putc>
      state = 0;
 730:	4981                	li	s3,0
 732:	b359                	j	4b8 <vprintf+0x44>

0000000000000734 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 734:	715d                	addi	sp,sp,-80
 736:	ec06                	sd	ra,24(sp)
 738:	e822                	sd	s0,16(sp)
 73a:	1000                	addi	s0,sp,32
 73c:	e010                	sd	a2,0(s0)
 73e:	e414                	sd	a3,8(s0)
 740:	e818                	sd	a4,16(s0)
 742:	ec1c                	sd	a5,24(s0)
 744:	03043023          	sd	a6,32(s0)
 748:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74c:	8622                	mv	a2,s0
 74e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 752:	d23ff0ef          	jal	474 <vprintf>
}
 756:	60e2                	ld	ra,24(sp)
 758:	6442                	ld	s0,16(sp)
 75a:	6161                	addi	sp,sp,80
 75c:	8082                	ret

000000000000075e <printf>:

void
printf(const char *fmt, ...)
{
 75e:	711d                	addi	sp,sp,-96
 760:	ec06                	sd	ra,24(sp)
 762:	e822                	sd	s0,16(sp)
 764:	1000                	addi	s0,sp,32
 766:	e40c                	sd	a1,8(s0)
 768:	e810                	sd	a2,16(s0)
 76a:	ec14                	sd	a3,24(s0)
 76c:	f018                	sd	a4,32(s0)
 76e:	f41c                	sd	a5,40(s0)
 770:	03043823          	sd	a6,48(s0)
 774:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 778:	00840613          	addi	a2,s0,8
 77c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 780:	85aa                	mv	a1,a0
 782:	4505                	li	a0,1
 784:	cf1ff0ef          	jal	474 <vprintf>
}
 788:	60e2                	ld	ra,24(sp)
 78a:	6442                	ld	s0,16(sp)
 78c:	6125                	addi	sp,sp,96
 78e:	8082                	ret

0000000000000790 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 790:	1141                	addi	sp,sp,-16
 792:	e406                	sd	ra,8(sp)
 794:	e022                	sd	s0,0(sp)
 796:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 798:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79c:	00001797          	auipc	a5,0x1
 7a0:	8647b783          	ld	a5,-1948(a5) # 1000 <freep>
 7a4:	a039                	j	7b2 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a6:	6398                	ld	a4,0(a5)
 7a8:	00e7e463          	bltu	a5,a4,7b0 <free+0x20>
 7ac:	00e6ea63          	bltu	a3,a4,7c0 <free+0x30>
{
 7b0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b2:	fed7fae3          	bgeu	a5,a3,7a6 <free+0x16>
 7b6:	6398                	ld	a4,0(a5)
 7b8:	00e6e463          	bltu	a3,a4,7c0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7bc:	fee7eae3          	bltu	a5,a4,7b0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c0:	ff852583          	lw	a1,-8(a0)
 7c4:	6390                	ld	a2,0(a5)
 7c6:	02059813          	slli	a6,a1,0x20
 7ca:	01c85713          	srli	a4,a6,0x1c
 7ce:	9736                	add	a4,a4,a3
 7d0:	02e60563          	beq	a2,a4,7fa <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7d4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7d8:	4790                	lw	a2,8(a5)
 7da:	02061593          	slli	a1,a2,0x20
 7de:	01c5d713          	srli	a4,a1,0x1c
 7e2:	973e                	add	a4,a4,a5
 7e4:	02e68263          	beq	a3,a4,808 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7e8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ea:	00001717          	auipc	a4,0x1
 7ee:	80f73b23          	sd	a5,-2026(a4) # 1000 <freep>
}
 7f2:	60a2                	ld	ra,8(sp)
 7f4:	6402                	ld	s0,0(sp)
 7f6:	0141                	addi	sp,sp,16
 7f8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7fa:	4618                	lw	a4,8(a2)
 7fc:	9f2d                	addw	a4,a4,a1
 7fe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 802:	6398                	ld	a4,0(a5)
 804:	6310                	ld	a2,0(a4)
 806:	b7f9                	j	7d4 <free+0x44>
    p->s.size += bp->s.size;
 808:	ff852703          	lw	a4,-8(a0)
 80c:	9f31                	addw	a4,a4,a2
 80e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 810:	ff053683          	ld	a3,-16(a0)
 814:	bfd1                	j	7e8 <free+0x58>

0000000000000816 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 816:	7139                	addi	sp,sp,-64
 818:	fc06                	sd	ra,56(sp)
 81a:	f822                	sd	s0,48(sp)
 81c:	f04a                	sd	s2,32(sp)
 81e:	ec4e                	sd	s3,24(sp)
 820:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 822:	02051993          	slli	s3,a0,0x20
 826:	0209d993          	srli	s3,s3,0x20
 82a:	09bd                	addi	s3,s3,15
 82c:	0049d993          	srli	s3,s3,0x4
 830:	2985                	addiw	s3,s3,1
 832:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 834:	00000517          	auipc	a0,0x0
 838:	7cc53503          	ld	a0,1996(a0) # 1000 <freep>
 83c:	c905                	beqz	a0,86c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 840:	4798                	lw	a4,8(a5)
 842:	09377663          	bgeu	a4,s3,8ce <malloc+0xb8>
 846:	f426                	sd	s1,40(sp)
 848:	e852                	sd	s4,16(sp)
 84a:	e456                	sd	s5,8(sp)
 84c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 84e:	8a4e                	mv	s4,s3
 850:	6705                	lui	a4,0x1
 852:	00e9f363          	bgeu	s3,a4,858 <malloc+0x42>
 856:	6a05                	lui	s4,0x1
 858:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 85c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 860:	00000497          	auipc	s1,0x0
 864:	7a048493          	addi	s1,s1,1952 # 1000 <freep>
  if(p == SBRK_ERROR)
 868:	5afd                	li	s5,-1
 86a:	a83d                	j	8a8 <malloc+0x92>
 86c:	f426                	sd	s1,40(sp)
 86e:	e852                	sd	s4,16(sp)
 870:	e456                	sd	s5,8(sp)
 872:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 874:	00000797          	auipc	a5,0x0
 878:	79c78793          	addi	a5,a5,1948 # 1010 <base>
 87c:	00000717          	auipc	a4,0x0
 880:	78f73223          	sd	a5,1924(a4) # 1000 <freep>
 884:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 886:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88a:	b7d1                	j	84e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 88c:	6398                	ld	a4,0(a5)
 88e:	e118                	sd	a4,0(a0)
 890:	a899                	j	8e6 <malloc+0xd0>
  hp->s.size = nu;
 892:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 896:	0541                	addi	a0,a0,16
 898:	ef9ff0ef          	jal	790 <free>
  return freep;
 89c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 89e:	c125                	beqz	a0,8fe <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a2:	4798                	lw	a4,8(a5)
 8a4:	03277163          	bgeu	a4,s2,8c6 <malloc+0xb0>
    if(p == freep)
 8a8:	6098                	ld	a4,0(s1)
 8aa:	853e                	mv	a0,a5
 8ac:	fef71ae3          	bne	a4,a5,8a0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8b0:	8552                	mv	a0,s4
 8b2:	9e3ff0ef          	jal	294 <sbrk>
  if(p == SBRK_ERROR)
 8b6:	fd551ee3          	bne	a0,s5,892 <malloc+0x7c>
        return 0;
 8ba:	4501                	li	a0,0
 8bc:	74a2                	ld	s1,40(sp)
 8be:	6a42                	ld	s4,16(sp)
 8c0:	6aa2                	ld	s5,8(sp)
 8c2:	6b02                	ld	s6,0(sp)
 8c4:	a03d                	j	8f2 <malloc+0xdc>
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	6a42                	ld	s4,16(sp)
 8ca:	6aa2                	ld	s5,8(sp)
 8cc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ce:	fae90fe3          	beq	s2,a4,88c <malloc+0x76>
        p->s.size -= nunits;
 8d2:	4137073b          	subw	a4,a4,s3
 8d6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d8:	02071693          	slli	a3,a4,0x20
 8dc:	01c6d713          	srli	a4,a3,0x1c
 8e0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e6:	00000717          	auipc	a4,0x0
 8ea:	70a73d23          	sd	a0,1818(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ee:	01078513          	addi	a0,a5,16
  }
}
 8f2:	70e2                	ld	ra,56(sp)
 8f4:	7442                	ld	s0,48(sp)
 8f6:	7902                	ld	s2,32(sp)
 8f8:	69e2                	ld	s3,24(sp)
 8fa:	6121                	addi	sp,sp,64
 8fc:	8082                	ret
 8fe:	74a2                	ld	s1,40(sp)
 900:	6a42                	ld	s4,16(sp)
 902:	6aa2                	ld	s5,8(sp)
 904:	6b02                	ld	s6,0(sp)
 906:	b7f5                	j	8f2 <malloc+0xdc>
