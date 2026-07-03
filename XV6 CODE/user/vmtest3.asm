
user/_vmtest3:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main() {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	addi	s0,sp,64
  printf("TEST3: Swap-in\n");
   8:	00001517          	auipc	a0,0x1
   c:	97850513          	addi	a0,a0,-1672 # 980 <malloc+0xfe>
  10:	7ba000ef          	jal	7ca <printf>

  char *p = sbrklazy(40 * 4096);
  14:	00028537          	lui	a0,0x28
  18:	2fe000ef          	jal	316 <sbrklazy>
  1c:	872a                	mv	a4,a0

  for(int i = 0; i < 40; i++)
  1e:	4781                	li	a5,0
  20:	6605                	lui	a2,0x1
  22:	02800693          	li	a3,40
    p[i*4096] = i;
  26:	00f70023          	sb	a5,0(a4)
  for(int i = 0; i < 40; i++)
  2a:	2785                	addiw	a5,a5,1
  2c:	9732                	add	a4,a4,a2
  2e:	fed79ce3          	bne	a5,a3,26 <main+0x26>

  // second pass
  for(int i = 0; i < 40; i++){
  32:	4581                	li	a1,0
  34:	6685                	lui	a3,0x1
  36:	02800713          	li	a4,40
    if(p[i*4096] != i){
  3a:	00054783          	lbu	a5,0(a0) # 28000 <base+0x26ff0>
  3e:	02b79763          	bne	a5,a1,6c <main+0x6c>
  for(int i = 0; i < 40; i++){
  42:	2585                	addiw	a1,a1,1
  44:	9536                	add	a0,a0,a3
  46:	fee59ae3          	bne	a1,a4,3a <main+0x3a>
      exit(1);
    }
  }

  struct vmstats s;
  getvmstats(getpid(), &s);
  4a:	36a000ef          	jal	3b4 <getpid>
  4e:	fc040593          	addi	a1,s0,-64
  52:	3c2000ef          	jal	414 <getvmstats>

  printf("swapped_in=%d\n", s.pages_swapped_in);
  56:	fc842583          	lw	a1,-56(s0)
  5a:	00001517          	auipc	a0,0x1
  5e:	94650513          	addi	a0,a0,-1722 # 9a0 <malloc+0x11e>
  62:	768000ef          	jal	7ca <printf>

  exit(0);
  66:	4501                	li	a0,0
  68:	2cc000ef          	jal	334 <exit>
      printf("ERROR at %d\n", i);
  6c:	00001517          	auipc	a0,0x1
  70:	92450513          	addi	a0,a0,-1756 # 990 <malloc+0x10e>
  74:	756000ef          	jal	7ca <printf>
      exit(1);
  78:	4505                	li	a0,1
  7a:	2ba000ef          	jal	334 <exit>

000000000000007e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  86:	f7bff0ef          	jal	0 <main>
  exit(r);
  8a:	2aa000ef          	jal	334 <exit>

000000000000008e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  96:	87aa                	mv	a5,a0
  98:	0585                	addi	a1,a1,1
  9a:	0785                	addi	a5,a5,1
  9c:	fff5c703          	lbu	a4,-1(a1)
  a0:	fee78fa3          	sb	a4,-1(a5)
  a4:	fb75                	bnez	a4,98 <strcpy+0xa>
    ;
  return os;
}
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cb91                	beqz	a5,ce <strcmp+0x20>
  bc:	0005c703          	lbu	a4,0(a1)
  c0:	00f71763          	bne	a4,a5,ce <strcmp+0x20>
    p++, q++;
  c4:	0505                	addi	a0,a0,1
  c6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c8:	00054783          	lbu	a5,0(a0)
  cc:	fbe5                	bnez	a5,bc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ce:	0005c503          	lbu	a0,0(a1)
}
  d2:	40a7853b          	subw	a0,a5,a0
  d6:	60a2                	ld	ra,8(sp)
  d8:	6402                	ld	s0,0(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret

00000000000000de <strlen>:

uint
strlen(const char *s)
{
  de:	1141                	addi	sp,sp,-16
  e0:	e406                	sd	ra,8(sp)
  e2:	e022                	sd	s0,0(sp)
  e4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  e6:	00054783          	lbu	a5,0(a0)
  ea:	cf91                	beqz	a5,106 <strlen+0x28>
  ec:	00150793          	addi	a5,a0,1
  f0:	86be                	mv	a3,a5
  f2:	0785                	addi	a5,a5,1
  f4:	fff7c703          	lbu	a4,-1(a5)
  f8:	ff65                	bnez	a4,f0 <strlen+0x12>
  fa:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  fe:	60a2                	ld	ra,8(sp)
 100:	6402                	ld	s0,0(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret
  for(n = 0; s[n]; n++)
 106:	4501                	li	a0,0
 108:	bfdd                	j	fe <strlen+0x20>

000000000000010a <memset>:

void*
memset(void *dst, int c, uint n)
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e406                	sd	ra,8(sp)
 10e:	e022                	sd	s0,0(sp)
 110:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 112:	ca19                	beqz	a2,128 <memset+0x1e>
 114:	87aa                	mv	a5,a0
 116:	1602                	slli	a2,a2,0x20
 118:	9201                	srli	a2,a2,0x20
 11a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 122:	0785                	addi	a5,a5,1
 124:	fee79de3          	bne	a5,a4,11e <memset+0x14>
  }
  return dst;
}
 128:	60a2                	ld	ra,8(sp)
 12a:	6402                	ld	s0,0(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	1141                	addi	sp,sp,-16
 132:	e406                	sd	ra,8(sp)
 134:	e022                	sd	s0,0(sp)
 136:	0800                	addi	s0,sp,16
  for(; *s; s++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf81                	beqz	a5,154 <strchr+0x24>
    if(*s == c)
 13e:	00f58763          	beq	a1,a5,14c <strchr+0x1c>
  for(; *s; s++)
 142:	0505                	addi	a0,a0,1
 144:	00054783          	lbu	a5,0(a0)
 148:	fbfd                	bnez	a5,13e <strchr+0xe>
      return (char*)s;
  return 0;
 14a:	4501                	li	a0,0
}
 14c:	60a2                	ld	ra,8(sp)
 14e:	6402                	ld	s0,0(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret
  return 0;
 154:	4501                	li	a0,0
 156:	bfdd                	j	14c <strchr+0x1c>

0000000000000158 <gets>:

char*
gets(char *buf, int max)
{
 158:	711d                	addi	sp,sp,-96
 15a:	ec86                	sd	ra,88(sp)
 15c:	e8a2                	sd	s0,80(sp)
 15e:	e4a6                	sd	s1,72(sp)
 160:	e0ca                	sd	s2,64(sp)
 162:	fc4e                	sd	s3,56(sp)
 164:	f852                	sd	s4,48(sp)
 166:	f456                	sd	s5,40(sp)
 168:	f05a                	sd	s6,32(sp)
 16a:	ec5e                	sd	s7,24(sp)
 16c:	e862                	sd	s8,16(sp)
 16e:	1080                	addi	s0,sp,96
 170:	8baa                	mv	s7,a0
 172:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	892a                	mv	s2,a0
 176:	4481                	li	s1,0
    cc = read(0, &c, 1);
 178:	faf40b13          	addi	s6,s0,-81
 17c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 17e:	8c26                	mv	s8,s1
 180:	0014899b          	addiw	s3,s1,1
 184:	84ce                	mv	s1,s3
 186:	0349d463          	bge	s3,s4,1ae <gets+0x56>
    cc = read(0, &c, 1);
 18a:	8656                	mv	a2,s5
 18c:	85da                	mv	a1,s6
 18e:	4501                	li	a0,0
 190:	1bc000ef          	jal	34c <read>
    if(cc < 1)
 194:	00a05d63          	blez	a0,1ae <gets+0x56>
      break;
    buf[i++] = c;
 198:	faf44783          	lbu	a5,-81(s0)
 19c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a0:	0905                	addi	s2,s2,1
 1a2:	ff678713          	addi	a4,a5,-10
 1a6:	c319                	beqz	a4,1ac <gets+0x54>
 1a8:	17cd                	addi	a5,a5,-13
 1aa:	fbf1                	bnez	a5,17e <gets+0x26>
    buf[i++] = c;
 1ac:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1ae:	9c5e                	add	s8,s8,s7
 1b0:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1b4:	855e                	mv	a0,s7
 1b6:	60e6                	ld	ra,88(sp)
 1b8:	6446                	ld	s0,80(sp)
 1ba:	64a6                	ld	s1,72(sp)
 1bc:	6906                	ld	s2,64(sp)
 1be:	79e2                	ld	s3,56(sp)
 1c0:	7a42                	ld	s4,48(sp)
 1c2:	7aa2                	ld	s5,40(sp)
 1c4:	7b02                	ld	s6,32(sp)
 1c6:	6be2                	ld	s7,24(sp)
 1c8:	6c42                	ld	s8,16(sp)
 1ca:	6125                	addi	sp,sp,96
 1cc:	8082                	ret

00000000000001ce <stat>:

int
stat(const char *n, struct stat *st)
{
 1ce:	1101                	addi	sp,sp,-32
 1d0:	ec06                	sd	ra,24(sp)
 1d2:	e822                	sd	s0,16(sp)
 1d4:	e04a                	sd	s2,0(sp)
 1d6:	1000                	addi	s0,sp,32
 1d8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1da:	4581                	li	a1,0
 1dc:	198000ef          	jal	374 <open>
  if(fd < 0)
 1e0:	02054263          	bltz	a0,204 <stat+0x36>
 1e4:	e426                	sd	s1,8(sp)
 1e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1e8:	85ca                	mv	a1,s2
 1ea:	1a2000ef          	jal	38c <fstat>
 1ee:	892a                	mv	s2,a0
  close(fd);
 1f0:	8526                	mv	a0,s1
 1f2:	16a000ef          	jal	35c <close>
  return r;
 1f6:	64a2                	ld	s1,8(sp)
}
 1f8:	854a                	mv	a0,s2
 1fa:	60e2                	ld	ra,24(sp)
 1fc:	6442                	ld	s0,16(sp)
 1fe:	6902                	ld	s2,0(sp)
 200:	6105                	addi	sp,sp,32
 202:	8082                	ret
    return -1;
 204:	57fd                	li	a5,-1
 206:	893e                	mv	s2,a5
 208:	bfc5                	j	1f8 <stat+0x2a>

000000000000020a <atoi>:

int
atoi(const char *s)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e406                	sd	ra,8(sp)
 20e:	e022                	sd	s0,0(sp)
 210:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 212:	00054683          	lbu	a3,0(a0)
 216:	fd06879b          	addiw	a5,a3,-48 # fd0 <digits+0x618>
 21a:	0ff7f793          	zext.b	a5,a5
 21e:	4625                	li	a2,9
 220:	02f66963          	bltu	a2,a5,252 <atoi+0x48>
 224:	872a                	mv	a4,a0
  n = 0;
 226:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 228:	0705                	addi	a4,a4,1
 22a:	0025179b          	slliw	a5,a0,0x2
 22e:	9fa9                	addw	a5,a5,a0
 230:	0017979b          	slliw	a5,a5,0x1
 234:	9fb5                	addw	a5,a5,a3
 236:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 23a:	00074683          	lbu	a3,0(a4)
 23e:	fd06879b          	addiw	a5,a3,-48
 242:	0ff7f793          	zext.b	a5,a5
 246:	fef671e3          	bgeu	a2,a5,228 <atoi+0x1e>
  return n;
}
 24a:	60a2                	ld	ra,8(sp)
 24c:	6402                	ld	s0,0(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret
  n = 0;
 252:	4501                	li	a0,0
 254:	bfdd                	j	24a <atoi+0x40>

0000000000000256 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 256:	1141                	addi	sp,sp,-16
 258:	e406                	sd	ra,8(sp)
 25a:	e022                	sd	s0,0(sp)
 25c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25e:	02b57563          	bgeu	a0,a1,288 <memmove+0x32>
    while(n-- > 0)
 262:	00c05f63          	blez	a2,280 <memmove+0x2a>
 266:	1602                	slli	a2,a2,0x20
 268:	9201                	srli	a2,a2,0x20
 26a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 26e:	872a                	mv	a4,a0
      *dst++ = *src++;
 270:	0585                	addi	a1,a1,1
 272:	0705                	addi	a4,a4,1
 274:	fff5c683          	lbu	a3,-1(a1)
 278:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 27c:	fee79ae3          	bne	a5,a4,270 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret
    while(n-- > 0)
 288:	fec05ce3          	blez	a2,280 <memmove+0x2a>
    dst += n;
 28c:	00c50733          	add	a4,a0,a2
    src += n;
 290:	95b2                	add	a1,a1,a2
 292:	fff6079b          	addiw	a5,a2,-1 # fff <digits+0x647>
 296:	1782                	slli	a5,a5,0x20
 298:	9381                	srli	a5,a5,0x20
 29a:	fff7c793          	not	a5,a5
 29e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a0:	15fd                	addi	a1,a1,-1
 2a2:	177d                	addi	a4,a4,-1
 2a4:	0005c683          	lbu	a3,0(a1)
 2a8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ac:	fef71ae3          	bne	a4,a5,2a0 <memmove+0x4a>
 2b0:	bfc1                	j	280 <memmove+0x2a>

00000000000002b2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b2:	1141                	addi	sp,sp,-16
 2b4:	e406                	sd	ra,8(sp)
 2b6:	e022                	sd	s0,0(sp)
 2b8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ba:	c61d                	beqz	a2,2e8 <memcmp+0x36>
 2bc:	1602                	slli	a2,a2,0x20
 2be:	9201                	srli	a2,a2,0x20
 2c0:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	0005c703          	lbu	a4,0(a1)
 2cc:	00e79863          	bne	a5,a4,2dc <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2d0:	0505                	addi	a0,a0,1
    p2++;
 2d2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d4:	fed518e3          	bne	a0,a3,2c4 <memcmp+0x12>
  }
  return 0;
 2d8:	4501                	li	a0,0
 2da:	a019                	j	2e0 <memcmp+0x2e>
      return *p1 - *p2;
 2dc:	40e7853b          	subw	a0,a5,a4
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
  return 0;
 2e8:	4501                	li	a0,0
 2ea:	bfdd                	j	2e0 <memcmp+0x2e>

00000000000002ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f4:	f63ff0ef          	jal	256 <memmove>
}
 2f8:	60a2                	ld	ra,8(sp)
 2fa:	6402                	ld	s0,0(sp)
 2fc:	0141                	addi	sp,sp,16
 2fe:	8082                	ret

0000000000000300 <sbrk>:

char *
sbrk(int n) {
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 308:	4585                	li	a1,1
 30a:	0b2000ef          	jal	3bc <sys_sbrk>
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret

0000000000000316 <sbrklazy>:

char *
sbrklazy(int n) {
 316:	1141                	addi	sp,sp,-16
 318:	e406                	sd	ra,8(sp)
 31a:	e022                	sd	s0,0(sp)
 31c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 31e:	4589                	li	a1,2
 320:	09c000ef          	jal	3bc <sys_sbrk>
}
 324:	60a2                	ld	ra,8(sp)
 326:	6402                	ld	s0,0(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret

000000000000032c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32c:	4885                	li	a7,1
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <exit>:
.global exit
exit:
 li a7, SYS_exit
 334:	4889                	li	a7,2
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <wait>:
.global wait
wait:
 li a7, SYS_wait
 33c:	488d                	li	a7,3
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 344:	4891                	li	a7,4
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <read>:
.global read
read:
 li a7, SYS_read
 34c:	4895                	li	a7,5
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <write>:
.global write
write:
 li a7, SYS_write
 354:	48c1                	li	a7,16
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <close>:
.global close
close:
 li a7, SYS_close
 35c:	48d5                	li	a7,21
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <kill>:
.global kill
kill:
 li a7, SYS_kill
 364:	4899                	li	a7,6
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <exec>:
.global exec
exec:
 li a7, SYS_exec
 36c:	489d                	li	a7,7
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <open>:
.global open
open:
 li a7, SYS_open
 374:	48bd                	li	a7,15
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37c:	48c5                	li	a7,17
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 384:	48c9                	li	a7,18
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38c:	48a1                	li	a7,8
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <link>:
.global link
link:
 li a7, SYS_link
 394:	48cd                	li	a7,19
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39c:	48d1                	li	a7,20
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a4:	48a5                	li	a7,9
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ac:	48a9                	li	a7,10
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b4:	48ad                	li	a7,11
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3bc:	48b1                	li	a7,12
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3c4:	48b5                	li	a7,13
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3cc:	48b9                	li	a7,14
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <hello>:
.global hello
hello:
 li a7, SYS_hello
 3d4:	48d9                	li	a7,22
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 3dc:	48dd                	li	a7,23
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3e4:	48e1                	li	a7,24
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 3ec:	48e5                	li	a7,25
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 3f4:	48e9                	li	a7,26
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 3fc:	48ed                	li	a7,27
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 404:	48f1                	li	a7,28
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 40c:	48f5                	li	a7,29
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 414:	48f9                	li	a7,30
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 41c:	48fd                	li	a7,31
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 424:	1101                	addi	sp,sp,-32
 426:	ec06                	sd	ra,24(sp)
 428:	e822                	sd	s0,16(sp)
 42a:	1000                	addi	s0,sp,32
 42c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 430:	4605                	li	a2,1
 432:	fef40593          	addi	a1,s0,-17
 436:	f1fff0ef          	jal	354 <write>
}
 43a:	60e2                	ld	ra,24(sp)
 43c:	6442                	ld	s0,16(sp)
 43e:	6105                	addi	sp,sp,32
 440:	8082                	ret

0000000000000442 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 442:	715d                	addi	sp,sp,-80
 444:	e486                	sd	ra,72(sp)
 446:	e0a2                	sd	s0,64(sp)
 448:	f84a                	sd	s2,48(sp)
 44a:	f44e                	sd	s3,40(sp)
 44c:	0880                	addi	s0,sp,80
 44e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 450:	c6d1                	beqz	a3,4dc <printint+0x9a>
 452:	0805d563          	bgez	a1,4dc <printint+0x9a>
    neg = 1;
    x = -xx;
 456:	40b005b3          	neg	a1,a1
    neg = 1;
 45a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 45c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 460:	86ce                	mv	a3,s3
  i = 0;
 462:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 464:	00000817          	auipc	a6,0x0
 468:	55480813          	addi	a6,a6,1364 # 9b8 <digits>
 46c:	88ba                	mv	a7,a4
 46e:	0017051b          	addiw	a0,a4,1
 472:	872a                	mv	a4,a0
 474:	02c5f7b3          	remu	a5,a1,a2
 478:	97c2                	add	a5,a5,a6
 47a:	0007c783          	lbu	a5,0(a5)
 47e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 482:	87ae                	mv	a5,a1
 484:	02c5d5b3          	divu	a1,a1,a2
 488:	0685                	addi	a3,a3,1
 48a:	fec7f1e3          	bgeu	a5,a2,46c <printint+0x2a>
  if(neg)
 48e:	00030c63          	beqz	t1,4a6 <printint+0x64>
    buf[i++] = '-';
 492:	fd050793          	addi	a5,a0,-48
 496:	00878533          	add	a0,a5,s0
 49a:	02d00793          	li	a5,45
 49e:	fef50423          	sb	a5,-24(a0)
 4a2:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4a6:	02e05563          	blez	a4,4d0 <printint+0x8e>
 4aa:	fc26                	sd	s1,56(sp)
 4ac:	377d                	addiw	a4,a4,-1
 4ae:	00e984b3          	add	s1,s3,a4
 4b2:	19fd                	addi	s3,s3,-1
 4b4:	99ba                	add	s3,s3,a4
 4b6:	1702                	slli	a4,a4,0x20
 4b8:	9301                	srli	a4,a4,0x20
 4ba:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4be:	0004c583          	lbu	a1,0(s1)
 4c2:	854a                	mv	a0,s2
 4c4:	f61ff0ef          	jal	424 <putc>
  while(--i >= 0)
 4c8:	14fd                	addi	s1,s1,-1
 4ca:	ff349ae3          	bne	s1,s3,4be <printint+0x7c>
 4ce:	74e2                	ld	s1,56(sp)
}
 4d0:	60a6                	ld	ra,72(sp)
 4d2:	6406                	ld	s0,64(sp)
 4d4:	7942                	ld	s2,48(sp)
 4d6:	79a2                	ld	s3,40(sp)
 4d8:	6161                	addi	sp,sp,80
 4da:	8082                	ret
  neg = 0;
 4dc:	4301                	li	t1,0
 4de:	bfbd                	j	45c <printint+0x1a>

00000000000004e0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e0:	711d                	addi	sp,sp,-96
 4e2:	ec86                	sd	ra,88(sp)
 4e4:	e8a2                	sd	s0,80(sp)
 4e6:	e4a6                	sd	s1,72(sp)
 4e8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ea:	0005c483          	lbu	s1,0(a1)
 4ee:	22048363          	beqz	s1,714 <vprintf+0x234>
 4f2:	e0ca                	sd	s2,64(sp)
 4f4:	fc4e                	sd	s3,56(sp)
 4f6:	f852                	sd	s4,48(sp)
 4f8:	f456                	sd	s5,40(sp)
 4fa:	f05a                	sd	s6,32(sp)
 4fc:	ec5e                	sd	s7,24(sp)
 4fe:	e862                	sd	s8,16(sp)
 500:	8b2a                	mv	s6,a0
 502:	8a2e                	mv	s4,a1
 504:	8bb2                	mv	s7,a2
  state = 0;
 506:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 508:	4901                	li	s2,0
 50a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 50c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 510:	06400c13          	li	s8,100
 514:	a00d                	j	536 <vprintf+0x56>
        putc(fd, c0);
 516:	85a6                	mv	a1,s1
 518:	855a                	mv	a0,s6
 51a:	f0bff0ef          	jal	424 <putc>
 51e:	a019                	j	524 <vprintf+0x44>
    } else if(state == '%'){
 520:	03598363          	beq	s3,s5,546 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 524:	0019079b          	addiw	a5,s2,1
 528:	893e                	mv	s2,a5
 52a:	873e                	mv	a4,a5
 52c:	97d2                	add	a5,a5,s4
 52e:	0007c483          	lbu	s1,0(a5)
 532:	1c048a63          	beqz	s1,706 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 536:	0004879b          	sext.w	a5,s1
    if(state == 0){
 53a:	fe0993e3          	bnez	s3,520 <vprintf+0x40>
      if(c0 == '%'){
 53e:	fd579ce3          	bne	a5,s5,516 <vprintf+0x36>
        state = '%';
 542:	89be                	mv	s3,a5
 544:	b7c5                	j	524 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 546:	00ea06b3          	add	a3,s4,a4
 54a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 54e:	1c060863          	beqz	a2,71e <vprintf+0x23e>
      if(c0 == 'd'){
 552:	03878763          	beq	a5,s8,580 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 556:	f9478693          	addi	a3,a5,-108
 55a:	0016b693          	seqz	a3,a3
 55e:	f9c60593          	addi	a1,a2,-100
 562:	e99d                	bnez	a1,598 <vprintf+0xb8>
 564:	ca95                	beqz	a3,598 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 566:	008b8493          	addi	s1,s7,8
 56a:	4685                	li	a3,1
 56c:	4629                	li	a2,10
 56e:	000bb583          	ld	a1,0(s7)
 572:	855a                	mv	a0,s6
 574:	ecfff0ef          	jal	442 <printint>
        i += 1;
 578:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 57a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 57c:	4981                	li	s3,0
 57e:	b75d                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 580:	008b8493          	addi	s1,s7,8
 584:	4685                	li	a3,1
 586:	4629                	li	a2,10
 588:	000ba583          	lw	a1,0(s7)
 58c:	855a                	mv	a0,s6
 58e:	eb5ff0ef          	jal	442 <printint>
 592:	8ba6                	mv	s7,s1
      state = 0;
 594:	4981                	li	s3,0
 596:	b779                	j	524 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 598:	9752                	add	a4,a4,s4
 59a:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 59e:	f9460713          	addi	a4,a2,-108
 5a2:	00173713          	seqz	a4,a4
 5a6:	8f75                	and	a4,a4,a3
 5a8:	f9c58513          	addi	a0,a1,-100
 5ac:	18051363          	bnez	a0,732 <vprintf+0x252>
 5b0:	18070163          	beqz	a4,732 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b4:	008b8493          	addi	s1,s7,8
 5b8:	4685                	li	a3,1
 5ba:	4629                	li	a2,10
 5bc:	000bb583          	ld	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	e81ff0ef          	jal	442 <printint>
        i += 2;
 5c6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c8:	8ba6                	mv	s7,s1
      state = 0;
 5ca:	4981                	li	s3,0
        i += 2;
 5cc:	bfa1                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5ce:	008b8493          	addi	s1,s7,8
 5d2:	4681                	li	a3,0
 5d4:	4629                	li	a2,10
 5d6:	000be583          	lwu	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	e67ff0ef          	jal	442 <printint>
 5e0:	8ba6                	mv	s7,s1
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b781                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e6:	008b8493          	addi	s1,s7,8
 5ea:	4681                	li	a3,0
 5ec:	4629                	li	a2,10
 5ee:	000bb583          	ld	a1,0(s7)
 5f2:	855a                	mv	a0,s6
 5f4:	e4fff0ef          	jal	442 <printint>
        i += 1;
 5f8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fa:	8ba6                	mv	s7,s1
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b71d                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	008b8493          	addi	s1,s7,8
 604:	4681                	li	a3,0
 606:	4629                	li	a2,10
 608:	000bb583          	ld	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	e35ff0ef          	jal	442 <printint>
        i += 2;
 612:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	8ba6                	mv	s7,s1
      state = 0;
 616:	4981                	li	s3,0
        i += 2;
 618:	b731                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 61a:	008b8493          	addi	s1,s7,8
 61e:	4681                	li	a3,0
 620:	4641                	li	a2,16
 622:	000be583          	lwu	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	e1bff0ef          	jal	442 <printint>
 62c:	8ba6                	mv	s7,s1
      state = 0;
 62e:	4981                	li	s3,0
 630:	bdd5                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 632:	008b8493          	addi	s1,s7,8
 636:	4681                	li	a3,0
 638:	4641                	li	a2,16
 63a:	000bb583          	ld	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	e03ff0ef          	jal	442 <printint>
        i += 1;
 644:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 646:	8ba6                	mv	s7,s1
      state = 0;
 648:	4981                	li	s3,0
 64a:	bde9                	j	524 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64c:	008b8493          	addi	s1,s7,8
 650:	4681                	li	a3,0
 652:	4641                	li	a2,16
 654:	000bb583          	ld	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	de9ff0ef          	jal	442 <printint>
        i += 2;
 65e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 660:	8ba6                	mv	s7,s1
      state = 0;
 662:	4981                	li	s3,0
        i += 2;
 664:	b5c1                	j	524 <vprintf+0x44>
 666:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 668:	008b8793          	addi	a5,s7,8
 66c:	8cbe                	mv	s9,a5
 66e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 672:	03000593          	li	a1,48
 676:	855a                	mv	a0,s6
 678:	dadff0ef          	jal	424 <putc>
  putc(fd, 'x');
 67c:	07800593          	li	a1,120
 680:	855a                	mv	a0,s6
 682:	da3ff0ef          	jal	424 <putc>
 686:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 688:	00000b97          	auipc	s7,0x0
 68c:	330b8b93          	addi	s7,s7,816 # 9b8 <digits>
 690:	03c9d793          	srli	a5,s3,0x3c
 694:	97de                	add	a5,a5,s7
 696:	0007c583          	lbu	a1,0(a5)
 69a:	855a                	mv	a0,s6
 69c:	d89ff0ef          	jal	424 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a0:	0992                	slli	s3,s3,0x4
 6a2:	34fd                	addiw	s1,s1,-1
 6a4:	f4f5                	bnez	s1,690 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6a6:	8be6                	mv	s7,s9
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	6ca2                	ld	s9,8(sp)
 6ac:	bda5                	j	524 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6ae:	008b8493          	addi	s1,s7,8
 6b2:	000bc583          	lbu	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	d6dff0ef          	jal	424 <putc>
 6bc:	8ba6                	mv	s7,s1
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	b595                	j	524 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6c2:	008b8993          	addi	s3,s7,8
 6c6:	000bb483          	ld	s1,0(s7)
 6ca:	cc91                	beqz	s1,6e6 <vprintf+0x206>
        for(; *s; s++)
 6cc:	0004c583          	lbu	a1,0(s1)
 6d0:	c985                	beqz	a1,700 <vprintf+0x220>
          putc(fd, *s);
 6d2:	855a                	mv	a0,s6
 6d4:	d51ff0ef          	jal	424 <putc>
        for(; *s; s++)
 6d8:	0485                	addi	s1,s1,1
 6da:	0004c583          	lbu	a1,0(s1)
 6de:	f9f5                	bnez	a1,6d2 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6e0:	8bce                	mv	s7,s3
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	b581                	j	524 <vprintf+0x44>
          s = "(null)";
 6e6:	00000497          	auipc	s1,0x0
 6ea:	2ca48493          	addi	s1,s1,714 # 9b0 <malloc+0x12e>
        for(; *s; s++)
 6ee:	02800593          	li	a1,40
 6f2:	b7c5                	j	6d2 <vprintf+0x1f2>
        putc(fd, '%');
 6f4:	85be                	mv	a1,a5
 6f6:	855a                	mv	a0,s6
 6f8:	d2dff0ef          	jal	424 <putc>
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b51d                	j	524 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 700:	8bce                	mv	s7,s3
      state = 0;
 702:	4981                	li	s3,0
 704:	b505                	j	524 <vprintf+0x44>
 706:	6906                	ld	s2,64(sp)
 708:	79e2                	ld	s3,56(sp)
 70a:	7a42                	ld	s4,48(sp)
 70c:	7aa2                	ld	s5,40(sp)
 70e:	7b02                	ld	s6,32(sp)
 710:	6be2                	ld	s7,24(sp)
 712:	6c42                	ld	s8,16(sp)
    }
  }
}
 714:	60e6                	ld	ra,88(sp)
 716:	6446                	ld	s0,80(sp)
 718:	64a6                	ld	s1,72(sp)
 71a:	6125                	addi	sp,sp,96
 71c:	8082                	ret
      if(c0 == 'd'){
 71e:	06400713          	li	a4,100
 722:	e4e78fe3          	beq	a5,a4,580 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 726:	f9478693          	addi	a3,a5,-108
 72a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 72e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 730:	4701                	li	a4,0
      } else if(c0 == 'u'){
 732:	07500513          	li	a0,117
 736:	e8a78ce3          	beq	a5,a0,5ce <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 73a:	f8b60513          	addi	a0,a2,-117
 73e:	e119                	bnez	a0,744 <vprintf+0x264>
 740:	ea0693e3          	bnez	a3,5e6 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 744:	f8b58513          	addi	a0,a1,-117
 748:	e119                	bnez	a0,74e <vprintf+0x26e>
 74a:	ea071be3          	bnez	a4,600 <vprintf+0x120>
      } else if(c0 == 'x'){
 74e:	07800513          	li	a0,120
 752:	eca784e3          	beq	a5,a0,61a <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 756:	f8860613          	addi	a2,a2,-120
 75a:	e219                	bnez	a2,760 <vprintf+0x280>
 75c:	ec069be3          	bnez	a3,632 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 760:	f8858593          	addi	a1,a1,-120
 764:	e199                	bnez	a1,76a <vprintf+0x28a>
 766:	ee0713e3          	bnez	a4,64c <vprintf+0x16c>
      } else if(c0 == 'p'){
 76a:	07000713          	li	a4,112
 76e:	eee78ce3          	beq	a5,a4,666 <vprintf+0x186>
      } else if(c0 == 'c'){
 772:	06300713          	li	a4,99
 776:	f2e78ce3          	beq	a5,a4,6ae <vprintf+0x1ce>
      } else if(c0 == 's'){
 77a:	07300713          	li	a4,115
 77e:	f4e782e3          	beq	a5,a4,6c2 <vprintf+0x1e2>
      } else if(c0 == '%'){
 782:	02500713          	li	a4,37
 786:	f6e787e3          	beq	a5,a4,6f4 <vprintf+0x214>
        putc(fd, '%');
 78a:	02500593          	li	a1,37
 78e:	855a                	mv	a0,s6
 790:	c95ff0ef          	jal	424 <putc>
        putc(fd, c0);
 794:	85a6                	mv	a1,s1
 796:	855a                	mv	a0,s6
 798:	c8dff0ef          	jal	424 <putc>
      state = 0;
 79c:	4981                	li	s3,0
 79e:	b359                	j	524 <vprintf+0x44>

00000000000007a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a0:	715d                	addi	sp,sp,-80
 7a2:	ec06                	sd	ra,24(sp)
 7a4:	e822                	sd	s0,16(sp)
 7a6:	1000                	addi	s0,sp,32
 7a8:	e010                	sd	a2,0(s0)
 7aa:	e414                	sd	a3,8(s0)
 7ac:	e818                	sd	a4,16(s0)
 7ae:	ec1c                	sd	a5,24(s0)
 7b0:	03043023          	sd	a6,32(s0)
 7b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b8:	8622                	mv	a2,s0
 7ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7be:	d23ff0ef          	jal	4e0 <vprintf>
}
 7c2:	60e2                	ld	ra,24(sp)
 7c4:	6442                	ld	s0,16(sp)
 7c6:	6161                	addi	sp,sp,80
 7c8:	8082                	ret

00000000000007ca <printf>:

void
printf(const char *fmt, ...)
{
 7ca:	711d                	addi	sp,sp,-96
 7cc:	ec06                	sd	ra,24(sp)
 7ce:	e822                	sd	s0,16(sp)
 7d0:	1000                	addi	s0,sp,32
 7d2:	e40c                	sd	a1,8(s0)
 7d4:	e810                	sd	a2,16(s0)
 7d6:	ec14                	sd	a3,24(s0)
 7d8:	f018                	sd	a4,32(s0)
 7da:	f41c                	sd	a5,40(s0)
 7dc:	03043823          	sd	a6,48(s0)
 7e0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e4:	00840613          	addi	a2,s0,8
 7e8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ec:	85aa                	mv	a1,a0
 7ee:	4505                	li	a0,1
 7f0:	cf1ff0ef          	jal	4e0 <vprintf>
}
 7f4:	60e2                	ld	ra,24(sp)
 7f6:	6442                	ld	s0,16(sp)
 7f8:	6125                	addi	sp,sp,96
 7fa:	8082                	ret

00000000000007fc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7fc:	1141                	addi	sp,sp,-16
 7fe:	e406                	sd	ra,8(sp)
 800:	e022                	sd	s0,0(sp)
 802:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 804:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 808:	00000797          	auipc	a5,0x0
 80c:	7f87b783          	ld	a5,2040(a5) # 1000 <freep>
 810:	a039                	j	81e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 812:	6398                	ld	a4,0(a5)
 814:	00e7e463          	bltu	a5,a4,81c <free+0x20>
 818:	00e6ea63          	bltu	a3,a4,82c <free+0x30>
{
 81c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	fed7fae3          	bgeu	a5,a3,812 <free+0x16>
 822:	6398                	ld	a4,0(a5)
 824:	00e6e463          	bltu	a3,a4,82c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 828:	fee7eae3          	bltu	a5,a4,81c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 82c:	ff852583          	lw	a1,-8(a0)
 830:	6390                	ld	a2,0(a5)
 832:	02059813          	slli	a6,a1,0x20
 836:	01c85713          	srli	a4,a6,0x1c
 83a:	9736                	add	a4,a4,a3
 83c:	02e60563          	beq	a2,a4,866 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 840:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 844:	4790                	lw	a2,8(a5)
 846:	02061593          	slli	a1,a2,0x20
 84a:	01c5d713          	srli	a4,a1,0x1c
 84e:	973e                	add	a4,a4,a5
 850:	02e68263          	beq	a3,a4,874 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 854:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 856:	00000717          	auipc	a4,0x0
 85a:	7af73523          	sd	a5,1962(a4) # 1000 <freep>
}
 85e:	60a2                	ld	ra,8(sp)
 860:	6402                	ld	s0,0(sp)
 862:	0141                	addi	sp,sp,16
 864:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 866:	4618                	lw	a4,8(a2)
 868:	9f2d                	addw	a4,a4,a1
 86a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	6398                	ld	a4,0(a5)
 870:	6310                	ld	a2,0(a4)
 872:	b7f9                	j	840 <free+0x44>
    p->s.size += bp->s.size;
 874:	ff852703          	lw	a4,-8(a0)
 878:	9f31                	addw	a4,a4,a2
 87a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 87c:	ff053683          	ld	a3,-16(a0)
 880:	bfd1                	j	854 <free+0x58>

0000000000000882 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 882:	7139                	addi	sp,sp,-64
 884:	fc06                	sd	ra,56(sp)
 886:	f822                	sd	s0,48(sp)
 888:	f04a                	sd	s2,32(sp)
 88a:	ec4e                	sd	s3,24(sp)
 88c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88e:	02051993          	slli	s3,a0,0x20
 892:	0209d993          	srli	s3,s3,0x20
 896:	09bd                	addi	s3,s3,15
 898:	0049d993          	srli	s3,s3,0x4
 89c:	2985                	addiw	s3,s3,1
 89e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8a0:	00000517          	auipc	a0,0x0
 8a4:	76053503          	ld	a0,1888(a0) # 1000 <freep>
 8a8:	c905                	beqz	a0,8d8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8aa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ac:	4798                	lw	a4,8(a5)
 8ae:	09377663          	bgeu	a4,s3,93a <malloc+0xb8>
 8b2:	f426                	sd	s1,40(sp)
 8b4:	e852                	sd	s4,16(sp)
 8b6:	e456                	sd	s5,8(sp)
 8b8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8ba:	8a4e                	mv	s4,s3
 8bc:	6705                	lui	a4,0x1
 8be:	00e9f363          	bgeu	s3,a4,8c4 <malloc+0x42>
 8c2:	6a05                	lui	s4,0x1
 8c4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8c8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8cc:	00000497          	auipc	s1,0x0
 8d0:	73448493          	addi	s1,s1,1844 # 1000 <freep>
  if(p == SBRK_ERROR)
 8d4:	5afd                	li	s5,-1
 8d6:	a83d                	j	914 <malloc+0x92>
 8d8:	f426                	sd	s1,40(sp)
 8da:	e852                	sd	s4,16(sp)
 8dc:	e456                	sd	s5,8(sp)
 8de:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e0:	00000797          	auipc	a5,0x0
 8e4:	73078793          	addi	a5,a5,1840 # 1010 <base>
 8e8:	00000717          	auipc	a4,0x0
 8ec:	70f73c23          	sd	a5,1816(a4) # 1000 <freep>
 8f0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8f6:	b7d1                	j	8ba <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8f8:	6398                	ld	a4,0(a5)
 8fa:	e118                	sd	a4,0(a0)
 8fc:	a899                	j	952 <malloc+0xd0>
  hp->s.size = nu;
 8fe:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 902:	0541                	addi	a0,a0,16
 904:	ef9ff0ef          	jal	7fc <free>
  return freep;
 908:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 90a:	c125                	beqz	a0,96a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90e:	4798                	lw	a4,8(a5)
 910:	03277163          	bgeu	a4,s2,932 <malloc+0xb0>
    if(p == freep)
 914:	6098                	ld	a4,0(s1)
 916:	853e                	mv	a0,a5
 918:	fef71ae3          	bne	a4,a5,90c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 91c:	8552                	mv	a0,s4
 91e:	9e3ff0ef          	jal	300 <sbrk>
  if(p == SBRK_ERROR)
 922:	fd551ee3          	bne	a0,s5,8fe <malloc+0x7c>
        return 0;
 926:	4501                	li	a0,0
 928:	74a2                	ld	s1,40(sp)
 92a:	6a42                	ld	s4,16(sp)
 92c:	6aa2                	ld	s5,8(sp)
 92e:	6b02                	ld	s6,0(sp)
 930:	a03d                	j	95e <malloc+0xdc>
 932:	74a2                	ld	s1,40(sp)
 934:	6a42                	ld	s4,16(sp)
 936:	6aa2                	ld	s5,8(sp)
 938:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 93a:	fae90fe3          	beq	s2,a4,8f8 <malloc+0x76>
        p->s.size -= nunits;
 93e:	4137073b          	subw	a4,a4,s3
 942:	c798                	sw	a4,8(a5)
        p += p->s.size;
 944:	02071693          	slli	a3,a4,0x20
 948:	01c6d713          	srli	a4,a3,0x1c
 94c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 94e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 952:	00000717          	auipc	a4,0x0
 956:	6aa73723          	sd	a0,1710(a4) # 1000 <freep>
      return (void*)(p + 1);
 95a:	01078513          	addi	a0,a5,16
  }
}
 95e:	70e2                	ld	ra,56(sp)
 960:	7442                	ld	s0,48(sp)
 962:	7902                	ld	s2,32(sp)
 964:	69e2                	ld	s3,24(sp)
 966:	6121                	addi	sp,sp,64
 968:	8082                	ret
 96a:	74a2                	ld	s1,40(sp)
 96c:	6a42                	ld	s4,16(sp)
 96e:	6aa2                	ld	s5,8(sp)
 970:	6b02                	ld	s6,0(sp)
 972:	b7f5                	j	95e <malloc+0xdc>
