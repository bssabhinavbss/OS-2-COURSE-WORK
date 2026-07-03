
user/_vmtest2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main() {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
  printf("TEST2: Eviction\n");
   8:	00001517          	auipc	a0,0x1
   c:	95850513          	addi	a0,a0,-1704 # 960 <malloc+0xfe>
  10:	79a000ef          	jal	7aa <printf>

  char *p = sbrklazy(40 * 4096);
  14:	00028537          	lui	a0,0x28
  18:	2de000ef          	jal	2f6 <sbrklazy>

  for(int i = 0; i < 40; i++)
  1c:	4781                	li	a5,0
  1e:	6685                	lui	a3,0x1
  20:	02800713          	li	a4,40
    p[i*4096] = i;
  24:	00f50023          	sb	a5,0(a0) # 28000 <base+0x26ff0>
  for(int i = 0; i < 40; i++)
  28:	2785                	addiw	a5,a5,1
  2a:	9536                	add	a0,a0,a3
  2c:	fee79ce3          	bne	a5,a4,24 <main+0x24>

  struct vmstats s;
  getvmstats(getpid(), &s);
  30:	364000ef          	jal	394 <getpid>
  34:	fc040593          	addi	a1,s0,-64
  38:	3bc000ef          	jal	3f4 <getvmstats>

  printf("faults=%d evicted=%d swapped_out=%d resident=%d\n",
  3c:	fd042703          	lw	a4,-48(s0)
  40:	fcc42683          	lw	a3,-52(s0)
  44:	fc442603          	lw	a2,-60(s0)
  48:	fc042583          	lw	a1,-64(s0)
  4c:	00001517          	auipc	a0,0x1
  50:	92c50513          	addi	a0,a0,-1748 # 978 <malloc+0x116>
  54:	756000ef          	jal	7aa <printf>
    s.page_faults, s.pages_evicted,
    s.pages_swapped_out, s.resident_pages);

  exit(0);
  58:	4501                	li	a0,0
  5a:	2ba000ef          	jal	314 <exit>

000000000000005e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  66:	f9bff0ef          	jal	0 <main>
  exit(r);
  6a:	2aa000ef          	jal	314 <exit>

000000000000006e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  6e:	1141                	addi	sp,sp,-16
  70:	e406                	sd	ra,8(sp)
  72:	e022                	sd	s0,0(sp)
  74:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  76:	87aa                	mv	a5,a0
  78:	0585                	addi	a1,a1,1
  7a:	0785                	addi	a5,a5,1
  7c:	fff5c703          	lbu	a4,-1(a1)
  80:	fee78fa3          	sb	a4,-1(a5)
  84:	fb75                	bnez	a4,78 <strcpy+0xa>
    ;
  return os;
}
  86:	60a2                	ld	ra,8(sp)
  88:	6402                	ld	s0,0(sp)
  8a:	0141                	addi	sp,sp,16
  8c:	8082                	ret

000000000000008e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	cb91                	beqz	a5,ae <strcmp+0x20>
  9c:	0005c703          	lbu	a4,0(a1)
  a0:	00f71763          	bne	a4,a5,ae <strcmp+0x20>
    p++, q++;
  a4:	0505                	addi	a0,a0,1
  a6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	fbe5                	bnez	a5,9c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ae:	0005c503          	lbu	a0,0(a1)
}
  b2:	40a7853b          	subw	a0,a5,a0
  b6:	60a2                	ld	ra,8(sp)
  b8:	6402                	ld	s0,0(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret

00000000000000be <strlen>:

uint
strlen(const char *s)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e406                	sd	ra,8(sp)
  c2:	e022                	sd	s0,0(sp)
  c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cf91                	beqz	a5,e6 <strlen+0x28>
  cc:	00150793          	addi	a5,a0,1
  d0:	86be                	mv	a3,a5
  d2:	0785                	addi	a5,a5,1
  d4:	fff7c703          	lbu	a4,-1(a5)
  d8:	ff65                	bnez	a4,d0 <strlen+0x12>
  da:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  de:	60a2                	ld	ra,8(sp)
  e0:	6402                	ld	s0,0(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  for(n = 0; s[n]; n++)
  e6:	4501                	li	a0,0
  e8:	bfdd                	j	de <strlen+0x20>

00000000000000ea <memset>:

void*
memset(void *dst, int c, uint n)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e406                	sd	ra,8(sp)
  ee:	e022                	sd	s0,0(sp)
  f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f2:	ca19                	beqz	a2,108 <memset+0x1e>
  f4:	87aa                	mv	a5,a0
  f6:	1602                	slli	a2,a2,0x20
  f8:	9201                	srli	a2,a2,0x20
  fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 102:	0785                	addi	a5,a5,1
 104:	fee79de3          	bne	a5,a4,fe <memset+0x14>
  }
  return dst;
}
 108:	60a2                	ld	ra,8(sp)
 10a:	6402                	ld	s0,0(sp)
 10c:	0141                	addi	sp,sp,16
 10e:	8082                	ret

0000000000000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	1141                	addi	sp,sp,-16
 112:	e406                	sd	ra,8(sp)
 114:	e022                	sd	s0,0(sp)
 116:	0800                	addi	s0,sp,16
  for(; *s; s++)
 118:	00054783          	lbu	a5,0(a0)
 11c:	cf81                	beqz	a5,134 <strchr+0x24>
    if(*s == c)
 11e:	00f58763          	beq	a1,a5,12c <strchr+0x1c>
  for(; *s; s++)
 122:	0505                	addi	a0,a0,1
 124:	00054783          	lbu	a5,0(a0)
 128:	fbfd                	bnez	a5,11e <strchr+0xe>
      return (char*)s;
  return 0;
 12a:	4501                	li	a0,0
}
 12c:	60a2                	ld	ra,8(sp)
 12e:	6402                	ld	s0,0(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret
  return 0;
 134:	4501                	li	a0,0
 136:	bfdd                	j	12c <strchr+0x1c>

0000000000000138 <gets>:

char*
gets(char *buf, int max)
{
 138:	711d                	addi	sp,sp,-96
 13a:	ec86                	sd	ra,88(sp)
 13c:	e8a2                	sd	s0,80(sp)
 13e:	e4a6                	sd	s1,72(sp)
 140:	e0ca                	sd	s2,64(sp)
 142:	fc4e                	sd	s3,56(sp)
 144:	f852                	sd	s4,48(sp)
 146:	f456                	sd	s5,40(sp)
 148:	f05a                	sd	s6,32(sp)
 14a:	ec5e                	sd	s7,24(sp)
 14c:	e862                	sd	s8,16(sp)
 14e:	1080                	addi	s0,sp,96
 150:	8baa                	mv	s7,a0
 152:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 154:	892a                	mv	s2,a0
 156:	4481                	li	s1,0
    cc = read(0, &c, 1);
 158:	faf40b13          	addi	s6,s0,-81
 15c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 15e:	8c26                	mv	s8,s1
 160:	0014899b          	addiw	s3,s1,1
 164:	84ce                	mv	s1,s3
 166:	0349d463          	bge	s3,s4,18e <gets+0x56>
    cc = read(0, &c, 1);
 16a:	8656                	mv	a2,s5
 16c:	85da                	mv	a1,s6
 16e:	4501                	li	a0,0
 170:	1bc000ef          	jal	32c <read>
    if(cc < 1)
 174:	00a05d63          	blez	a0,18e <gets+0x56>
      break;
    buf[i++] = c;
 178:	faf44783          	lbu	a5,-81(s0)
 17c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 180:	0905                	addi	s2,s2,1
 182:	ff678713          	addi	a4,a5,-10
 186:	c319                	beqz	a4,18c <gets+0x54>
 188:	17cd                	addi	a5,a5,-13
 18a:	fbf1                	bnez	a5,15e <gets+0x26>
    buf[i++] = c;
 18c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 18e:	9c5e                	add	s8,s8,s7
 190:	000c0023          	sb	zero,0(s8)
  return buf;
}
 194:	855e                	mv	a0,s7
 196:	60e6                	ld	ra,88(sp)
 198:	6446                	ld	s0,80(sp)
 19a:	64a6                	ld	s1,72(sp)
 19c:	6906                	ld	s2,64(sp)
 19e:	79e2                	ld	s3,56(sp)
 1a0:	7a42                	ld	s4,48(sp)
 1a2:	7aa2                	ld	s5,40(sp)
 1a4:	7b02                	ld	s6,32(sp)
 1a6:	6be2                	ld	s7,24(sp)
 1a8:	6c42                	ld	s8,16(sp)
 1aa:	6125                	addi	sp,sp,96
 1ac:	8082                	ret

00000000000001ae <stat>:

int
stat(const char *n, struct stat *st)
{
 1ae:	1101                	addi	sp,sp,-32
 1b0:	ec06                	sd	ra,24(sp)
 1b2:	e822                	sd	s0,16(sp)
 1b4:	e04a                	sd	s2,0(sp)
 1b6:	1000                	addi	s0,sp,32
 1b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ba:	4581                	li	a1,0
 1bc:	198000ef          	jal	354 <open>
  if(fd < 0)
 1c0:	02054263          	bltz	a0,1e4 <stat+0x36>
 1c4:	e426                	sd	s1,8(sp)
 1c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c8:	85ca                	mv	a1,s2
 1ca:	1a2000ef          	jal	36c <fstat>
 1ce:	892a                	mv	s2,a0
  close(fd);
 1d0:	8526                	mv	a0,s1
 1d2:	16a000ef          	jal	33c <close>
  return r;
 1d6:	64a2                	ld	s1,8(sp)
}
 1d8:	854a                	mv	a0,s2
 1da:	60e2                	ld	ra,24(sp)
 1dc:	6442                	ld	s0,16(sp)
 1de:	6902                	ld	s2,0(sp)
 1e0:	6105                	addi	sp,sp,32
 1e2:	8082                	ret
    return -1;
 1e4:	57fd                	li	a5,-1
 1e6:	893e                	mv	s2,a5
 1e8:	bfc5                	j	1d8 <stat+0x2a>

00000000000001ea <atoi>:

int
atoi(const char *s)
{
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f2:	00054683          	lbu	a3,0(a0)
 1f6:	fd06879b          	addiw	a5,a3,-48 # fd0 <digits+0x618>
 1fa:	0ff7f793          	zext.b	a5,a5
 1fe:	4625                	li	a2,9
 200:	02f66963          	bltu	a2,a5,232 <atoi+0x48>
 204:	872a                	mv	a4,a0
  n = 0;
 206:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 208:	0705                	addi	a4,a4,1
 20a:	0025179b          	slliw	a5,a0,0x2
 20e:	9fa9                	addw	a5,a5,a0
 210:	0017979b          	slliw	a5,a5,0x1
 214:	9fb5                	addw	a5,a5,a3
 216:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21a:	00074683          	lbu	a3,0(a4)
 21e:	fd06879b          	addiw	a5,a3,-48
 222:	0ff7f793          	zext.b	a5,a5
 226:	fef671e3          	bgeu	a2,a5,208 <atoi+0x1e>
  return n;
}
 22a:	60a2                	ld	ra,8(sp)
 22c:	6402                	ld	s0,0(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret
  n = 0;
 232:	4501                	li	a0,0
 234:	bfdd                	j	22a <atoi+0x40>

0000000000000236 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 236:	1141                	addi	sp,sp,-16
 238:	e406                	sd	ra,8(sp)
 23a:	e022                	sd	s0,0(sp)
 23c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23e:	02b57563          	bgeu	a0,a1,268 <memmove+0x32>
    while(n-- > 0)
 242:	00c05f63          	blez	a2,260 <memmove+0x2a>
 246:	1602                	slli	a2,a2,0x20
 248:	9201                	srli	a2,a2,0x20
 24a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24e:	872a                	mv	a4,a0
      *dst++ = *src++;
 250:	0585                	addi	a1,a1,1
 252:	0705                	addi	a4,a4,1
 254:	fff5c683          	lbu	a3,-1(a1)
 258:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 260:	60a2                	ld	ra,8(sp)
 262:	6402                	ld	s0,0(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
    while(n-- > 0)
 268:	fec05ce3          	blez	a2,260 <memmove+0x2a>
    dst += n;
 26c:	00c50733          	add	a4,a0,a2
    src += n;
 270:	95b2                	add	a1,a1,a2
 272:	fff6079b          	addiw	a5,a2,-1
 276:	1782                	slli	a5,a5,0x20
 278:	9381                	srli	a5,a5,0x20
 27a:	fff7c793          	not	a5,a5
 27e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 280:	15fd                	addi	a1,a1,-1
 282:	177d                	addi	a4,a4,-1
 284:	0005c683          	lbu	a3,0(a1)
 288:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 28c:	fef71ae3          	bne	a4,a5,280 <memmove+0x4a>
 290:	bfc1                	j	260 <memmove+0x2a>

0000000000000292 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29a:	c61d                	beqz	a2,2c8 <memcmp+0x36>
 29c:	1602                	slli	a2,a2,0x20
 29e:	9201                	srli	a2,a2,0x20
 2a0:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	0005c703          	lbu	a4,0(a1)
 2ac:	00e79863          	bne	a5,a4,2bc <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2b0:	0505                	addi	a0,a0,1
    p2++;
 2b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b4:	fed518e3          	bne	a0,a3,2a4 <memcmp+0x12>
  }
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	a019                	j	2c0 <memcmp+0x2e>
      return *p1 - *p2;
 2bc:	40e7853b          	subw	a0,a5,a4
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret
  return 0;
 2c8:	4501                	li	a0,0
 2ca:	bfdd                	j	2c0 <memcmp+0x2e>

00000000000002cc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2cc:	1141                	addi	sp,sp,-16
 2ce:	e406                	sd	ra,8(sp)
 2d0:	e022                	sd	s0,0(sp)
 2d2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d4:	f63ff0ef          	jal	236 <memmove>
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <sbrk>:

char *
sbrk(int n) {
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e406                	sd	ra,8(sp)
 2e4:	e022                	sd	s0,0(sp)
 2e6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2e8:	4585                	li	a1,1
 2ea:	0b2000ef          	jal	39c <sys_sbrk>
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <sbrklazy>:

char *
sbrklazy(int n) {
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e406                	sd	ra,8(sp)
 2fa:	e022                	sd	s0,0(sp)
 2fc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2fe:	4589                	li	a1,2
 300:	09c000ef          	jal	39c <sys_sbrk>
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 30c:	4885                	li	a7,1
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exit>:
.global exit
exit:
 li a7, SYS_exit
 314:	4889                	li	a7,2
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <wait>:
.global wait
wait:
 li a7, SYS_wait
 31c:	488d                	li	a7,3
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 324:	4891                	li	a7,4
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <read>:
.global read
read:
 li a7, SYS_read
 32c:	4895                	li	a7,5
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <write>:
.global write
write:
 li a7, SYS_write
 334:	48c1                	li	a7,16
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <close>:
.global close
close:
 li a7, SYS_close
 33c:	48d5                	li	a7,21
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <kill>:
.global kill
kill:
 li a7, SYS_kill
 344:	4899                	li	a7,6
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <exec>:
.global exec
exec:
 li a7, SYS_exec
 34c:	489d                	li	a7,7
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <open>:
.global open
open:
 li a7, SYS_open
 354:	48bd                	li	a7,15
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 35c:	48c5                	li	a7,17
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 364:	48c9                	li	a7,18
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 36c:	48a1                	li	a7,8
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <link>:
.global link
link:
 li a7, SYS_link
 374:	48cd                	li	a7,19
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 37c:	48d1                	li	a7,20
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 384:	48a5                	li	a7,9
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <dup>:
.global dup
dup:
 li a7, SYS_dup
 38c:	48a9                	li	a7,10
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 394:	48ad                	li	a7,11
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 39c:	48b1                	li	a7,12
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3a4:	48b5                	li	a7,13
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ac:	48b9                	li	a7,14
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <hello>:
.global hello
hello:
 li a7, SYS_hello
 3b4:	48d9                	li	a7,22
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 3bc:	48dd                	li	a7,23
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3c4:	48e1                	li	a7,24
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 3cc:	48e5                	li	a7,25
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 3d4:	48e9                	li	a7,26
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 3dc:	48ed                	li	a7,27
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 3e4:	48f1                	li	a7,28
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 3ec:	48f5                	li	a7,29
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 3f4:	48f9                	li	a7,30
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 3fc:	48fd                	li	a7,31
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 404:	1101                	addi	sp,sp,-32
 406:	ec06                	sd	ra,24(sp)
 408:	e822                	sd	s0,16(sp)
 40a:	1000                	addi	s0,sp,32
 40c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 410:	4605                	li	a2,1
 412:	fef40593          	addi	a1,s0,-17
 416:	f1fff0ef          	jal	334 <write>
}
 41a:	60e2                	ld	ra,24(sp)
 41c:	6442                	ld	s0,16(sp)
 41e:	6105                	addi	sp,sp,32
 420:	8082                	ret

0000000000000422 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 422:	715d                	addi	sp,sp,-80
 424:	e486                	sd	ra,72(sp)
 426:	e0a2                	sd	s0,64(sp)
 428:	f84a                	sd	s2,48(sp)
 42a:	f44e                	sd	s3,40(sp)
 42c:	0880                	addi	s0,sp,80
 42e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 430:	c6d1                	beqz	a3,4bc <printint+0x9a>
 432:	0805d563          	bgez	a1,4bc <printint+0x9a>
    neg = 1;
    x = -xx;
 436:	40b005b3          	neg	a1,a1
    neg = 1;
 43a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 43c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 440:	86ce                	mv	a3,s3
  i = 0;
 442:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 444:	00000817          	auipc	a6,0x0
 448:	57480813          	addi	a6,a6,1396 # 9b8 <digits>
 44c:	88ba                	mv	a7,a4
 44e:	0017051b          	addiw	a0,a4,1
 452:	872a                	mv	a4,a0
 454:	02c5f7b3          	remu	a5,a1,a2
 458:	97c2                	add	a5,a5,a6
 45a:	0007c783          	lbu	a5,0(a5)
 45e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 462:	87ae                	mv	a5,a1
 464:	02c5d5b3          	divu	a1,a1,a2
 468:	0685                	addi	a3,a3,1
 46a:	fec7f1e3          	bgeu	a5,a2,44c <printint+0x2a>
  if(neg)
 46e:	00030c63          	beqz	t1,486 <printint+0x64>
    buf[i++] = '-';
 472:	fd050793          	addi	a5,a0,-48
 476:	00878533          	add	a0,a5,s0
 47a:	02d00793          	li	a5,45
 47e:	fef50423          	sb	a5,-24(a0)
 482:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 486:	02e05563          	blez	a4,4b0 <printint+0x8e>
 48a:	fc26                	sd	s1,56(sp)
 48c:	377d                	addiw	a4,a4,-1
 48e:	00e984b3          	add	s1,s3,a4
 492:	19fd                	addi	s3,s3,-1
 494:	99ba                	add	s3,s3,a4
 496:	1702                	slli	a4,a4,0x20
 498:	9301                	srli	a4,a4,0x20
 49a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 49e:	0004c583          	lbu	a1,0(s1)
 4a2:	854a                	mv	a0,s2
 4a4:	f61ff0ef          	jal	404 <putc>
  while(--i >= 0)
 4a8:	14fd                	addi	s1,s1,-1
 4aa:	ff349ae3          	bne	s1,s3,49e <printint+0x7c>
 4ae:	74e2                	ld	s1,56(sp)
}
 4b0:	60a6                	ld	ra,72(sp)
 4b2:	6406                	ld	s0,64(sp)
 4b4:	7942                	ld	s2,48(sp)
 4b6:	79a2                	ld	s3,40(sp)
 4b8:	6161                	addi	sp,sp,80
 4ba:	8082                	ret
  neg = 0;
 4bc:	4301                	li	t1,0
 4be:	bfbd                	j	43c <printint+0x1a>

00000000000004c0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c0:	711d                	addi	sp,sp,-96
 4c2:	ec86                	sd	ra,88(sp)
 4c4:	e8a2                	sd	s0,80(sp)
 4c6:	e4a6                	sd	s1,72(sp)
 4c8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ca:	0005c483          	lbu	s1,0(a1)
 4ce:	22048363          	beqz	s1,6f4 <vprintf+0x234>
 4d2:	e0ca                	sd	s2,64(sp)
 4d4:	fc4e                	sd	s3,56(sp)
 4d6:	f852                	sd	s4,48(sp)
 4d8:	f456                	sd	s5,40(sp)
 4da:	f05a                	sd	s6,32(sp)
 4dc:	ec5e                	sd	s7,24(sp)
 4de:	e862                	sd	s8,16(sp)
 4e0:	8b2a                	mv	s6,a0
 4e2:	8a2e                	mv	s4,a1
 4e4:	8bb2                	mv	s7,a2
  state = 0;
 4e6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4e8:	4901                	li	s2,0
 4ea:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ec:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4f0:	06400c13          	li	s8,100
 4f4:	a00d                	j	516 <vprintf+0x56>
        putc(fd, c0);
 4f6:	85a6                	mv	a1,s1
 4f8:	855a                	mv	a0,s6
 4fa:	f0bff0ef          	jal	404 <putc>
 4fe:	a019                	j	504 <vprintf+0x44>
    } else if(state == '%'){
 500:	03598363          	beq	s3,s5,526 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 504:	0019079b          	addiw	a5,s2,1
 508:	893e                	mv	s2,a5
 50a:	873e                	mv	a4,a5
 50c:	97d2                	add	a5,a5,s4
 50e:	0007c483          	lbu	s1,0(a5)
 512:	1c048a63          	beqz	s1,6e6 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 516:	0004879b          	sext.w	a5,s1
    if(state == 0){
 51a:	fe0993e3          	bnez	s3,500 <vprintf+0x40>
      if(c0 == '%'){
 51e:	fd579ce3          	bne	a5,s5,4f6 <vprintf+0x36>
        state = '%';
 522:	89be                	mv	s3,a5
 524:	b7c5                	j	504 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 526:	00ea06b3          	add	a3,s4,a4
 52a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 52e:	1c060863          	beqz	a2,6fe <vprintf+0x23e>
      if(c0 == 'd'){
 532:	03878763          	beq	a5,s8,560 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 536:	f9478693          	addi	a3,a5,-108
 53a:	0016b693          	seqz	a3,a3
 53e:	f9c60593          	addi	a1,a2,-100
 542:	e99d                	bnez	a1,578 <vprintf+0xb8>
 544:	ca95                	beqz	a3,578 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 546:	008b8493          	addi	s1,s7,8
 54a:	4685                	li	a3,1
 54c:	4629                	li	a2,10
 54e:	000bb583          	ld	a1,0(s7)
 552:	855a                	mv	a0,s6
 554:	ecfff0ef          	jal	422 <printint>
        i += 1;
 558:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 55a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 55c:	4981                	li	s3,0
 55e:	b75d                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 560:	008b8493          	addi	s1,s7,8
 564:	4685                	li	a3,1
 566:	4629                	li	a2,10
 568:	000ba583          	lw	a1,0(s7)
 56c:	855a                	mv	a0,s6
 56e:	eb5ff0ef          	jal	422 <printint>
 572:	8ba6                	mv	s7,s1
      state = 0;
 574:	4981                	li	s3,0
 576:	b779                	j	504 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 578:	9752                	add	a4,a4,s4
 57a:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 57e:	f9460713          	addi	a4,a2,-108
 582:	00173713          	seqz	a4,a4
 586:	8f75                	and	a4,a4,a3
 588:	f9c58513          	addi	a0,a1,-100
 58c:	18051363          	bnez	a0,712 <vprintf+0x252>
 590:	18070163          	beqz	a4,712 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 594:	008b8493          	addi	s1,s7,8
 598:	4685                	li	a3,1
 59a:	4629                	li	a2,10
 59c:	000bb583          	ld	a1,0(s7)
 5a0:	855a                	mv	a0,s6
 5a2:	e81ff0ef          	jal	422 <printint>
        i += 2;
 5a6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a8:	8ba6                	mv	s7,s1
      state = 0;
 5aa:	4981                	li	s3,0
        i += 2;
 5ac:	bfa1                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5ae:	008b8493          	addi	s1,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4629                	li	a2,10
 5b6:	000be583          	lwu	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	e67ff0ef          	jal	422 <printint>
 5c0:	8ba6                	mv	s7,s1
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b781                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c6:	008b8493          	addi	s1,s7,8
 5ca:	4681                	li	a3,0
 5cc:	4629                	li	a2,10
 5ce:	000bb583          	ld	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	e4fff0ef          	jal	422 <printint>
        i += 1;
 5d8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b71d                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4629                	li	a2,10
 5e8:	000bb583          	ld	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	e35ff0ef          	jal	422 <printint>
        i += 2;
 5f2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f4:	8ba6                	mv	s7,s1
      state = 0;
 5f6:	4981                	li	s3,0
        i += 2;
 5f8:	b731                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5fa:	008b8493          	addi	s1,s7,8
 5fe:	4681                	li	a3,0
 600:	4641                	li	a2,16
 602:	000be583          	lwu	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	e1bff0ef          	jal	422 <printint>
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
 610:	bdd5                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 612:	008b8493          	addi	s1,s7,8
 616:	4681                	li	a3,0
 618:	4641                	li	a2,16
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	e03ff0ef          	jal	422 <printint>
        i += 1;
 624:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
 62a:	bde9                	j	504 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 62c:	008b8493          	addi	s1,s7,8
 630:	4681                	li	a3,0
 632:	4641                	li	a2,16
 634:	000bb583          	ld	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	de9ff0ef          	jal	422 <printint>
        i += 2;
 63e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 640:	8ba6                	mv	s7,s1
      state = 0;
 642:	4981                	li	s3,0
        i += 2;
 644:	b5c1                	j	504 <vprintf+0x44>
 646:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 648:	008b8793          	addi	a5,s7,8
 64c:	8cbe                	mv	s9,a5
 64e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 652:	03000593          	li	a1,48
 656:	855a                	mv	a0,s6
 658:	dadff0ef          	jal	404 <putc>
  putc(fd, 'x');
 65c:	07800593          	li	a1,120
 660:	855a                	mv	a0,s6
 662:	da3ff0ef          	jal	404 <putc>
 666:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 668:	00000b97          	auipc	s7,0x0
 66c:	350b8b93          	addi	s7,s7,848 # 9b8 <digits>
 670:	03c9d793          	srli	a5,s3,0x3c
 674:	97de                	add	a5,a5,s7
 676:	0007c583          	lbu	a1,0(a5)
 67a:	855a                	mv	a0,s6
 67c:	d89ff0ef          	jal	404 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 680:	0992                	slli	s3,s3,0x4
 682:	34fd                	addiw	s1,s1,-1
 684:	f4f5                	bnez	s1,670 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 686:	8be6                	mv	s7,s9
      state = 0;
 688:	4981                	li	s3,0
 68a:	6ca2                	ld	s9,8(sp)
 68c:	bda5                	j	504 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 68e:	008b8493          	addi	s1,s7,8
 692:	000bc583          	lbu	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	d6dff0ef          	jal	404 <putc>
 69c:	8ba6                	mv	s7,s1
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	b595                	j	504 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6a2:	008b8993          	addi	s3,s7,8
 6a6:	000bb483          	ld	s1,0(s7)
 6aa:	cc91                	beqz	s1,6c6 <vprintf+0x206>
        for(; *s; s++)
 6ac:	0004c583          	lbu	a1,0(s1)
 6b0:	c985                	beqz	a1,6e0 <vprintf+0x220>
          putc(fd, *s);
 6b2:	855a                	mv	a0,s6
 6b4:	d51ff0ef          	jal	404 <putc>
        for(; *s; s++)
 6b8:	0485                	addi	s1,s1,1
 6ba:	0004c583          	lbu	a1,0(s1)
 6be:	f9f5                	bnez	a1,6b2 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6c0:	8bce                	mv	s7,s3
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	b581                	j	504 <vprintf+0x44>
          s = "(null)";
 6c6:	00000497          	auipc	s1,0x0
 6ca:	2ea48493          	addi	s1,s1,746 # 9b0 <malloc+0x14e>
        for(; *s; s++)
 6ce:	02800593          	li	a1,40
 6d2:	b7c5                	j	6b2 <vprintf+0x1f2>
        putc(fd, '%');
 6d4:	85be                	mv	a1,a5
 6d6:	855a                	mv	a0,s6
 6d8:	d2dff0ef          	jal	404 <putc>
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	b51d                	j	504 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6e0:	8bce                	mv	s7,s3
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b505                	j	504 <vprintf+0x44>
 6e6:	6906                	ld	s2,64(sp)
 6e8:	79e2                	ld	s3,56(sp)
 6ea:	7a42                	ld	s4,48(sp)
 6ec:	7aa2                	ld	s5,40(sp)
 6ee:	7b02                	ld	s6,32(sp)
 6f0:	6be2                	ld	s7,24(sp)
 6f2:	6c42                	ld	s8,16(sp)
    }
  }
}
 6f4:	60e6                	ld	ra,88(sp)
 6f6:	6446                	ld	s0,80(sp)
 6f8:	64a6                	ld	s1,72(sp)
 6fa:	6125                	addi	sp,sp,96
 6fc:	8082                	ret
      if(c0 == 'd'){
 6fe:	06400713          	li	a4,100
 702:	e4e78fe3          	beq	a5,a4,560 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 706:	f9478693          	addi	a3,a5,-108
 70a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 70e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 710:	4701                	li	a4,0
      } else if(c0 == 'u'){
 712:	07500513          	li	a0,117
 716:	e8a78ce3          	beq	a5,a0,5ae <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 71a:	f8b60513          	addi	a0,a2,-117
 71e:	e119                	bnez	a0,724 <vprintf+0x264>
 720:	ea0693e3          	bnez	a3,5c6 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 724:	f8b58513          	addi	a0,a1,-117
 728:	e119                	bnez	a0,72e <vprintf+0x26e>
 72a:	ea071be3          	bnez	a4,5e0 <vprintf+0x120>
      } else if(c0 == 'x'){
 72e:	07800513          	li	a0,120
 732:	eca784e3          	beq	a5,a0,5fa <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 736:	f8860613          	addi	a2,a2,-120
 73a:	e219                	bnez	a2,740 <vprintf+0x280>
 73c:	ec069be3          	bnez	a3,612 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 740:	f8858593          	addi	a1,a1,-120
 744:	e199                	bnez	a1,74a <vprintf+0x28a>
 746:	ee0713e3          	bnez	a4,62c <vprintf+0x16c>
      } else if(c0 == 'p'){
 74a:	07000713          	li	a4,112
 74e:	eee78ce3          	beq	a5,a4,646 <vprintf+0x186>
      } else if(c0 == 'c'){
 752:	06300713          	li	a4,99
 756:	f2e78ce3          	beq	a5,a4,68e <vprintf+0x1ce>
      } else if(c0 == 's'){
 75a:	07300713          	li	a4,115
 75e:	f4e782e3          	beq	a5,a4,6a2 <vprintf+0x1e2>
      } else if(c0 == '%'){
 762:	02500713          	li	a4,37
 766:	f6e787e3          	beq	a5,a4,6d4 <vprintf+0x214>
        putc(fd, '%');
 76a:	02500593          	li	a1,37
 76e:	855a                	mv	a0,s6
 770:	c95ff0ef          	jal	404 <putc>
        putc(fd, c0);
 774:	85a6                	mv	a1,s1
 776:	855a                	mv	a0,s6
 778:	c8dff0ef          	jal	404 <putc>
      state = 0;
 77c:	4981                	li	s3,0
 77e:	b359                	j	504 <vprintf+0x44>

0000000000000780 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 780:	715d                	addi	sp,sp,-80
 782:	ec06                	sd	ra,24(sp)
 784:	e822                	sd	s0,16(sp)
 786:	1000                	addi	s0,sp,32
 788:	e010                	sd	a2,0(s0)
 78a:	e414                	sd	a3,8(s0)
 78c:	e818                	sd	a4,16(s0)
 78e:	ec1c                	sd	a5,24(s0)
 790:	03043023          	sd	a6,32(s0)
 794:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	8622                	mv	a2,s0
 79a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79e:	d23ff0ef          	jal	4c0 <vprintf>
}
 7a2:	60e2                	ld	ra,24(sp)
 7a4:	6442                	ld	s0,16(sp)
 7a6:	6161                	addi	sp,sp,80
 7a8:	8082                	ret

00000000000007aa <printf>:

void
printf(const char *fmt, ...)
{
 7aa:	711d                	addi	sp,sp,-96
 7ac:	ec06                	sd	ra,24(sp)
 7ae:	e822                	sd	s0,16(sp)
 7b0:	1000                	addi	s0,sp,32
 7b2:	e40c                	sd	a1,8(s0)
 7b4:	e810                	sd	a2,16(s0)
 7b6:	ec14                	sd	a3,24(s0)
 7b8:	f018                	sd	a4,32(s0)
 7ba:	f41c                	sd	a5,40(s0)
 7bc:	03043823          	sd	a6,48(s0)
 7c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c4:	00840613          	addi	a2,s0,8
 7c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7cc:	85aa                	mv	a1,a0
 7ce:	4505                	li	a0,1
 7d0:	cf1ff0ef          	jal	4c0 <vprintf>
}
 7d4:	60e2                	ld	ra,24(sp)
 7d6:	6442                	ld	s0,16(sp)
 7d8:	6125                	addi	sp,sp,96
 7da:	8082                	ret

00000000000007dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7dc:	1141                	addi	sp,sp,-16
 7de:	e406                	sd	ra,8(sp)
 7e0:	e022                	sd	s0,0(sp)
 7e2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e8:	00001797          	auipc	a5,0x1
 7ec:	8187b783          	ld	a5,-2024(a5) # 1000 <freep>
 7f0:	a039                	j	7fe <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f2:	6398                	ld	a4,0(a5)
 7f4:	00e7e463          	bltu	a5,a4,7fc <free+0x20>
 7f8:	00e6ea63          	bltu	a3,a4,80c <free+0x30>
{
 7fc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fe:	fed7fae3          	bgeu	a5,a3,7f2 <free+0x16>
 802:	6398                	ld	a4,0(a5)
 804:	00e6e463          	bltu	a3,a4,80c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 808:	fee7eae3          	bltu	a5,a4,7fc <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 80c:	ff852583          	lw	a1,-8(a0)
 810:	6390                	ld	a2,0(a5)
 812:	02059813          	slli	a6,a1,0x20
 816:	01c85713          	srli	a4,a6,0x1c
 81a:	9736                	add	a4,a4,a3
 81c:	02e60563          	beq	a2,a4,846 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 820:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 824:	4790                	lw	a2,8(a5)
 826:	02061593          	slli	a1,a2,0x20
 82a:	01c5d713          	srli	a4,a1,0x1c
 82e:	973e                	add	a4,a4,a5
 830:	02e68263          	beq	a3,a4,854 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 834:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 836:	00000717          	auipc	a4,0x0
 83a:	7cf73523          	sd	a5,1994(a4) # 1000 <freep>
}
 83e:	60a2                	ld	ra,8(sp)
 840:	6402                	ld	s0,0(sp)
 842:	0141                	addi	sp,sp,16
 844:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 846:	4618                	lw	a4,8(a2)
 848:	9f2d                	addw	a4,a4,a1
 84a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 84e:	6398                	ld	a4,0(a5)
 850:	6310                	ld	a2,0(a4)
 852:	b7f9                	j	820 <free+0x44>
    p->s.size += bp->s.size;
 854:	ff852703          	lw	a4,-8(a0)
 858:	9f31                	addw	a4,a4,a2
 85a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 85c:	ff053683          	ld	a3,-16(a0)
 860:	bfd1                	j	834 <free+0x58>

0000000000000862 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 862:	7139                	addi	sp,sp,-64
 864:	fc06                	sd	ra,56(sp)
 866:	f822                	sd	s0,48(sp)
 868:	f04a                	sd	s2,32(sp)
 86a:	ec4e                	sd	s3,24(sp)
 86c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86e:	02051993          	slli	s3,a0,0x20
 872:	0209d993          	srli	s3,s3,0x20
 876:	09bd                	addi	s3,s3,15
 878:	0049d993          	srli	s3,s3,0x4
 87c:	2985                	addiw	s3,s3,1
 87e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 880:	00000517          	auipc	a0,0x0
 884:	78053503          	ld	a0,1920(a0) # 1000 <freep>
 888:	c905                	beqz	a0,8b8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 88c:	4798                	lw	a4,8(a5)
 88e:	09377663          	bgeu	a4,s3,91a <malloc+0xb8>
 892:	f426                	sd	s1,40(sp)
 894:	e852                	sd	s4,16(sp)
 896:	e456                	sd	s5,8(sp)
 898:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 89a:	8a4e                	mv	s4,s3
 89c:	6705                	lui	a4,0x1
 89e:	00e9f363          	bgeu	s3,a4,8a4 <malloc+0x42>
 8a2:	6a05                	lui	s4,0x1
 8a4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ac:	00000497          	auipc	s1,0x0
 8b0:	75448493          	addi	s1,s1,1876 # 1000 <freep>
  if(p == SBRK_ERROR)
 8b4:	5afd                	li	s5,-1
 8b6:	a83d                	j	8f4 <malloc+0x92>
 8b8:	f426                	sd	s1,40(sp)
 8ba:	e852                	sd	s4,16(sp)
 8bc:	e456                	sd	s5,8(sp)
 8be:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c0:	00000797          	auipc	a5,0x0
 8c4:	75078793          	addi	a5,a5,1872 # 1010 <base>
 8c8:	00000717          	auipc	a4,0x0
 8cc:	72f73c23          	sd	a5,1848(a4) # 1000 <freep>
 8d0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d6:	b7d1                	j	89a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8d8:	6398                	ld	a4,0(a5)
 8da:	e118                	sd	a4,0(a0)
 8dc:	a899                	j	932 <malloc+0xd0>
  hp->s.size = nu;
 8de:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e2:	0541                	addi	a0,a0,16
 8e4:	ef9ff0ef          	jal	7dc <free>
  return freep;
 8e8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8ea:	c125                	beqz	a0,94a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ee:	4798                	lw	a4,8(a5)
 8f0:	03277163          	bgeu	a4,s2,912 <malloc+0xb0>
    if(p == freep)
 8f4:	6098                	ld	a4,0(s1)
 8f6:	853e                	mv	a0,a5
 8f8:	fef71ae3          	bne	a4,a5,8ec <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8fc:	8552                	mv	a0,s4
 8fe:	9e3ff0ef          	jal	2e0 <sbrk>
  if(p == SBRK_ERROR)
 902:	fd551ee3          	bne	a0,s5,8de <malloc+0x7c>
        return 0;
 906:	4501                	li	a0,0
 908:	74a2                	ld	s1,40(sp)
 90a:	6a42                	ld	s4,16(sp)
 90c:	6aa2                	ld	s5,8(sp)
 90e:	6b02                	ld	s6,0(sp)
 910:	a03d                	j	93e <malloc+0xdc>
 912:	74a2                	ld	s1,40(sp)
 914:	6a42                	ld	s4,16(sp)
 916:	6aa2                	ld	s5,8(sp)
 918:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 91a:	fae90fe3          	beq	s2,a4,8d8 <malloc+0x76>
        p->s.size -= nunits;
 91e:	4137073b          	subw	a4,a4,s3
 922:	c798                	sw	a4,8(a5)
        p += p->s.size;
 924:	02071693          	slli	a3,a4,0x20
 928:	01c6d713          	srli	a4,a3,0x1c
 92c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 92e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 932:	00000717          	auipc	a4,0x0
 936:	6ca73723          	sd	a0,1742(a4) # 1000 <freep>
      return (void*)(p + 1);
 93a:	01078513          	addi	a0,a5,16
  }
}
 93e:	70e2                	ld	ra,56(sp)
 940:	7442                	ld	s0,48(sp)
 942:	7902                	ld	s2,32(sp)
 944:	69e2                	ld	s3,24(sp)
 946:	6121                	addi	sp,sp,64
 948:	8082                	ret
 94a:	74a2                	ld	s1,40(sp)
 94c:	6a42                	ld	s4,16(sp)
 94e:	6aa2                	ld	s5,8(sp)
 950:	6b02                	ld	s6,0(sp)
 952:	b7f5                	j	93e <malloc+0xdc>
