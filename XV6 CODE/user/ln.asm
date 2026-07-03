
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	94058593          	addi	a1,a1,-1728 # 950 <malloc+0xfe>
  18:	4509                	li	a0,2
  1a:	756000ef          	jal	770 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2e4000ef          	jal	304 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	338000ef          	jal	364 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2ce000ef          	jal	304 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	92a58593          	addi	a1,a1,-1750 # 968 <malloc+0x116>
  46:	4509                	li	a0,2
  48:	728000ef          	jal	770 <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  56:	fabff0ef          	jal	0 <main>
  exit(r);
  5a:	2aa000ef          	jal	304 <exit>

000000000000005e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0xa>
    ;
  return os;
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x20>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x20>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf91                	beqz	a5,d6 <strlen+0x28>
  bc:	00150793          	addi	a5,a0,1
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x12>
  ca:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ce:	60a2                	ld	ra,8(sp)
  d0:	6402                	ld	s0,0(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret
  for(n = 0; s[n]; n++)
  d6:	4501                	li	a0,0
  d8:	bfdd                	j	ce <strlen+0x20>

00000000000000da <memset>:

void*
memset(void *dst, int c, uint n)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e2:	ca19                	beqz	a2,f8 <memset+0x1e>
  e4:	87aa                	mv	a5,a0
  e6:	1602                	slli	a2,a2,0x20
  e8:	9201                	srli	a2,a2,0x20
  ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f2:	0785                	addi	a5,a5,1
  f4:	fee79de3          	bne	a5,a4,ee <memset+0x14>
  }
  return dst;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  for(; *s; s++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	cf81                	beqz	a5,124 <strchr+0x24>
    if(*s == c)
 10e:	00f58763          	beq	a1,a5,11c <strchr+0x1c>
  for(; *s; s++)
 112:	0505                	addi	a0,a0,1
 114:	00054783          	lbu	a5,0(a0)
 118:	fbfd                	bnez	a5,10e <strchr+0xe>
      return (char*)s;
  return 0;
 11a:	4501                	li	a0,0
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  return 0;
 124:	4501                	li	a0,0
 126:	bfdd                	j	11c <strchr+0x1c>

0000000000000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	711d                	addi	sp,sp,-96
 12a:	ec86                	sd	ra,88(sp)
 12c:	e8a2                	sd	s0,80(sp)
 12e:	e4a6                	sd	s1,72(sp)
 130:	e0ca                	sd	s2,64(sp)
 132:	fc4e                	sd	s3,56(sp)
 134:	f852                	sd	s4,48(sp)
 136:	f456                	sd	s5,40(sp)
 138:	f05a                	sd	s6,32(sp)
 13a:	ec5e                	sd	s7,24(sp)
 13c:	e862                	sd	s8,16(sp)
 13e:	1080                	addi	s0,sp,96
 140:	8baa                	mv	s7,a0
 142:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 144:	892a                	mv	s2,a0
 146:	4481                	li	s1,0
    cc = read(0, &c, 1);
 148:	faf40b13          	addi	s6,s0,-81
 14c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 14e:	8c26                	mv	s8,s1
 150:	0014899b          	addiw	s3,s1,1
 154:	84ce                	mv	s1,s3
 156:	0349d463          	bge	s3,s4,17e <gets+0x56>
    cc = read(0, &c, 1);
 15a:	8656                	mv	a2,s5
 15c:	85da                	mv	a1,s6
 15e:	4501                	li	a0,0
 160:	1bc000ef          	jal	31c <read>
    if(cc < 1)
 164:	00a05d63          	blez	a0,17e <gets+0x56>
      break;
    buf[i++] = c;
 168:	faf44783          	lbu	a5,-81(s0)
 16c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 170:	0905                	addi	s2,s2,1
 172:	ff678713          	addi	a4,a5,-10
 176:	c319                	beqz	a4,17c <gets+0x54>
 178:	17cd                	addi	a5,a5,-13
 17a:	fbf1                	bnez	a5,14e <gets+0x26>
    buf[i++] = c;
 17c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 17e:	9c5e                	add	s8,s8,s7
 180:	000c0023          	sb	zero,0(s8)
  return buf;
}
 184:	855e                	mv	a0,s7
 186:	60e6                	ld	ra,88(sp)
 188:	6446                	ld	s0,80(sp)
 18a:	64a6                	ld	s1,72(sp)
 18c:	6906                	ld	s2,64(sp)
 18e:	79e2                	ld	s3,56(sp)
 190:	7a42                	ld	s4,48(sp)
 192:	7aa2                	ld	s5,40(sp)
 194:	7b02                	ld	s6,32(sp)
 196:	6be2                	ld	s7,24(sp)
 198:	6c42                	ld	s8,16(sp)
 19a:	6125                	addi	sp,sp,96
 19c:	8082                	ret

000000000000019e <stat>:

int
stat(const char *n, struct stat *st)
{
 19e:	1101                	addi	sp,sp,-32
 1a0:	ec06                	sd	ra,24(sp)
 1a2:	e822                	sd	s0,16(sp)
 1a4:	e04a                	sd	s2,0(sp)
 1a6:	1000                	addi	s0,sp,32
 1a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	4581                	li	a1,0
 1ac:	198000ef          	jal	344 <open>
  if(fd < 0)
 1b0:	02054263          	bltz	a0,1d4 <stat+0x36>
 1b4:	e426                	sd	s1,8(sp)
 1b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b8:	85ca                	mv	a1,s2
 1ba:	1a2000ef          	jal	35c <fstat>
 1be:	892a                	mv	s2,a0
  close(fd);
 1c0:	8526                	mv	a0,s1
 1c2:	16a000ef          	jal	32c <close>
  return r;
 1c6:	64a2                	ld	s1,8(sp)
}
 1c8:	854a                	mv	a0,s2
 1ca:	60e2                	ld	ra,24(sp)
 1cc:	6442                	ld	s0,16(sp)
 1ce:	6902                	ld	s2,0(sp)
 1d0:	6105                	addi	sp,sp,32
 1d2:	8082                	ret
    return -1;
 1d4:	57fd                	li	a5,-1
 1d6:	893e                	mv	s2,a5
 1d8:	bfc5                	j	1c8 <stat+0x2a>

00000000000001da <atoi>:

int
atoi(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e406                	sd	ra,8(sp)
 1de:	e022                	sd	s0,0(sp)
 1e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e2:	00054683          	lbu	a3,0(a0)
 1e6:	fd06879b          	addiw	a5,a3,-48
 1ea:	0ff7f793          	zext.b	a5,a5
 1ee:	4625                	li	a2,9
 1f0:	02f66963          	bltu	a2,a5,222 <atoi+0x48>
 1f4:	872a                	mv	a4,a0
  n = 0;
 1f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f8:	0705                	addi	a4,a4,1
 1fa:	0025179b          	slliw	a5,a0,0x2
 1fe:	9fa9                	addw	a5,a5,a0
 200:	0017979b          	slliw	a5,a5,0x1
 204:	9fb5                	addw	a5,a5,a3
 206:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20a:	00074683          	lbu	a3,0(a4)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	fef671e3          	bgeu	a2,a5,1f8 <atoi+0x1e>
  return n;
}
 21a:	60a2                	ld	ra,8(sp)
 21c:	6402                	ld	s0,0(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  n = 0;
 222:	4501                	li	a0,0
 224:	bfdd                	j	21a <atoi+0x40>

0000000000000226 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 22e:	02b57563          	bgeu	a0,a1,258 <memmove+0x32>
    while(n-- > 0)
 232:	00c05f63          	blez	a2,250 <memmove+0x2a>
 236:	1602                	slli	a2,a2,0x20
 238:	9201                	srli	a2,a2,0x20
 23a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 23e:	872a                	mv	a4,a0
      *dst++ = *src++;
 240:	0585                	addi	a1,a1,1
 242:	0705                	addi	a4,a4,1
 244:	fff5c683          	lbu	a3,-1(a1)
 248:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 24c:	fee79ae3          	bne	a5,a4,240 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 250:	60a2                	ld	ra,8(sp)
 252:	6402                	ld	s0,0(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
    while(n-- > 0)
 258:	fec05ce3          	blez	a2,250 <memmove+0x2a>
    dst += n;
 25c:	00c50733          	add	a4,a0,a2
    src += n;
 260:	95b2                	add	a1,a1,a2
 262:	fff6079b          	addiw	a5,a2,-1
 266:	1782                	slli	a5,a5,0x20
 268:	9381                	srli	a5,a5,0x20
 26a:	fff7c793          	not	a5,a5
 26e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 270:	15fd                	addi	a1,a1,-1
 272:	177d                	addi	a4,a4,-1
 274:	0005c683          	lbu	a3,0(a1)
 278:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 27c:	fef71ae3          	bne	a4,a5,270 <memmove+0x4a>
 280:	bfc1                	j	250 <memmove+0x2a>

0000000000000282 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28a:	c61d                	beqz	a2,2b8 <memcmp+0x36>
 28c:	1602                	slli	a2,a2,0x20
 28e:	9201                	srli	a2,a2,0x20
 290:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 294:	00054783          	lbu	a5,0(a0)
 298:	0005c703          	lbu	a4,0(a1)
 29c:	00e79863          	bne	a5,a4,2ac <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2a0:	0505                	addi	a0,a0,1
    p2++;
 2a2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a4:	fed518e3          	bne	a0,a3,294 <memcmp+0x12>
  }
  return 0;
 2a8:	4501                	li	a0,0
 2aa:	a019                	j	2b0 <memcmp+0x2e>
      return *p1 - *p2;
 2ac:	40e7853b          	subw	a0,a5,a4
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	bfdd                	j	2b0 <memcmp+0x2e>

00000000000002bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c4:	f63ff0ef          	jal	226 <memmove>
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <sbrk>:

char *
sbrk(int n) {
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2d8:	4585                	li	a1,1
 2da:	0b2000ef          	jal	38c <sys_sbrk>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <sbrklazy>:

char *
sbrklazy(int n) {
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ee:	4589                	li	a1,2
 2f0:	09c000ef          	jal	38c <sys_sbrk>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pause>:
.global pause
pause:
 li a7, SYS_pause
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <hello>:
.global hello
hello:
 li a7, SYS_hello
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 3ac:	48dd                	li	a7,23
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3b4:	48e1                	li	a7,24
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 3bc:	48e5                	li	a7,25
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 3c4:	48e9                	li	a7,26
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 3cc:	48ed                	li	a7,27
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 3d4:	48f1                	li	a7,28
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 3dc:	48f5                	li	a7,29
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 3e4:	48f9                	li	a7,30
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 3ec:	48fd                	li	a7,31
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3f4:	1101                	addi	sp,sp,-32
 3f6:	ec06                	sd	ra,24(sp)
 3f8:	e822                	sd	s0,16(sp)
 3fa:	1000                	addi	s0,sp,32
 3fc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 400:	4605                	li	a2,1
 402:	fef40593          	addi	a1,s0,-17
 406:	f1fff0ef          	jal	324 <write>
}
 40a:	60e2                	ld	ra,24(sp)
 40c:	6442                	ld	s0,16(sp)
 40e:	6105                	addi	sp,sp,32
 410:	8082                	ret

0000000000000412 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 412:	715d                	addi	sp,sp,-80
 414:	e486                	sd	ra,72(sp)
 416:	e0a2                	sd	s0,64(sp)
 418:	f84a                	sd	s2,48(sp)
 41a:	f44e                	sd	s3,40(sp)
 41c:	0880                	addi	s0,sp,80
 41e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 420:	c6d1                	beqz	a3,4ac <printint+0x9a>
 422:	0805d563          	bgez	a1,4ac <printint+0x9a>
    neg = 1;
    x = -xx;
 426:	40b005b3          	neg	a1,a1
    neg = 1;
 42a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 42c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 430:	86ce                	mv	a3,s3
  i = 0;
 432:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 434:	00000817          	auipc	a6,0x0
 438:	55480813          	addi	a6,a6,1364 # 988 <digits>
 43c:	88ba                	mv	a7,a4
 43e:	0017051b          	addiw	a0,a4,1
 442:	872a                	mv	a4,a0
 444:	02c5f7b3          	remu	a5,a1,a2
 448:	97c2                	add	a5,a5,a6
 44a:	0007c783          	lbu	a5,0(a5)
 44e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 452:	87ae                	mv	a5,a1
 454:	02c5d5b3          	divu	a1,a1,a2
 458:	0685                	addi	a3,a3,1
 45a:	fec7f1e3          	bgeu	a5,a2,43c <printint+0x2a>
  if(neg)
 45e:	00030c63          	beqz	t1,476 <printint+0x64>
    buf[i++] = '-';
 462:	fd050793          	addi	a5,a0,-48
 466:	00878533          	add	a0,a5,s0
 46a:	02d00793          	li	a5,45
 46e:	fef50423          	sb	a5,-24(a0)
 472:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 476:	02e05563          	blez	a4,4a0 <printint+0x8e>
 47a:	fc26                	sd	s1,56(sp)
 47c:	377d                	addiw	a4,a4,-1
 47e:	00e984b3          	add	s1,s3,a4
 482:	19fd                	addi	s3,s3,-1
 484:	99ba                	add	s3,s3,a4
 486:	1702                	slli	a4,a4,0x20
 488:	9301                	srli	a4,a4,0x20
 48a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48e:	0004c583          	lbu	a1,0(s1)
 492:	854a                	mv	a0,s2
 494:	f61ff0ef          	jal	3f4 <putc>
  while(--i >= 0)
 498:	14fd                	addi	s1,s1,-1
 49a:	ff349ae3          	bne	s1,s3,48e <printint+0x7c>
 49e:	74e2                	ld	s1,56(sp)
}
 4a0:	60a6                	ld	ra,72(sp)
 4a2:	6406                	ld	s0,64(sp)
 4a4:	7942                	ld	s2,48(sp)
 4a6:	79a2                	ld	s3,40(sp)
 4a8:	6161                	addi	sp,sp,80
 4aa:	8082                	ret
  neg = 0;
 4ac:	4301                	li	t1,0
 4ae:	bfbd                	j	42c <printint+0x1a>

00000000000004b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b0:	711d                	addi	sp,sp,-96
 4b2:	ec86                	sd	ra,88(sp)
 4b4:	e8a2                	sd	s0,80(sp)
 4b6:	e4a6                	sd	s1,72(sp)
 4b8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ba:	0005c483          	lbu	s1,0(a1)
 4be:	22048363          	beqz	s1,6e4 <vprintf+0x234>
 4c2:	e0ca                	sd	s2,64(sp)
 4c4:	fc4e                	sd	s3,56(sp)
 4c6:	f852                	sd	s4,48(sp)
 4c8:	f456                	sd	s5,40(sp)
 4ca:	f05a                	sd	s6,32(sp)
 4cc:	ec5e                	sd	s7,24(sp)
 4ce:	e862                	sd	s8,16(sp)
 4d0:	8b2a                	mv	s6,a0
 4d2:	8a2e                	mv	s4,a1
 4d4:	8bb2                	mv	s7,a2
  state = 0;
 4d6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4d8:	4901                	li	s2,0
 4da:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4dc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e0:	06400c13          	li	s8,100
 4e4:	a00d                	j	506 <vprintf+0x56>
        putc(fd, c0);
 4e6:	85a6                	mv	a1,s1
 4e8:	855a                	mv	a0,s6
 4ea:	f0bff0ef          	jal	3f4 <putc>
 4ee:	a019                	j	4f4 <vprintf+0x44>
    } else if(state == '%'){
 4f0:	03598363          	beq	s3,s5,516 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4f4:	0019079b          	addiw	a5,s2,1
 4f8:	893e                	mv	s2,a5
 4fa:	873e                	mv	a4,a5
 4fc:	97d2                	add	a5,a5,s4
 4fe:	0007c483          	lbu	s1,0(a5)
 502:	1c048a63          	beqz	s1,6d6 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 506:	0004879b          	sext.w	a5,s1
    if(state == 0){
 50a:	fe0993e3          	bnez	s3,4f0 <vprintf+0x40>
      if(c0 == '%'){
 50e:	fd579ce3          	bne	a5,s5,4e6 <vprintf+0x36>
        state = '%';
 512:	89be                	mv	s3,a5
 514:	b7c5                	j	4f4 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 516:	00ea06b3          	add	a3,s4,a4
 51a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 51e:	1c060863          	beqz	a2,6ee <vprintf+0x23e>
      if(c0 == 'd'){
 522:	03878763          	beq	a5,s8,550 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 526:	f9478693          	addi	a3,a5,-108
 52a:	0016b693          	seqz	a3,a3
 52e:	f9c60593          	addi	a1,a2,-100
 532:	e99d                	bnez	a1,568 <vprintf+0xb8>
 534:	ca95                	beqz	a3,568 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 536:	008b8493          	addi	s1,s7,8
 53a:	4685                	li	a3,1
 53c:	4629                	li	a2,10
 53e:	000bb583          	ld	a1,0(s7)
 542:	855a                	mv	a0,s6
 544:	ecfff0ef          	jal	412 <printint>
        i += 1;
 548:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 54a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 54c:	4981                	li	s3,0
 54e:	b75d                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 550:	008b8493          	addi	s1,s7,8
 554:	4685                	li	a3,1
 556:	4629                	li	a2,10
 558:	000ba583          	lw	a1,0(s7)
 55c:	855a                	mv	a0,s6
 55e:	eb5ff0ef          	jal	412 <printint>
 562:	8ba6                	mv	s7,s1
      state = 0;
 564:	4981                	li	s3,0
 566:	b779                	j	4f4 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 568:	9752                	add	a4,a4,s4
 56a:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 56e:	f9460713          	addi	a4,a2,-108
 572:	00173713          	seqz	a4,a4
 576:	8f75                	and	a4,a4,a3
 578:	f9c58513          	addi	a0,a1,-100
 57c:	18051363          	bnez	a0,702 <vprintf+0x252>
 580:	18070163          	beqz	a4,702 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 584:	008b8493          	addi	s1,s7,8
 588:	4685                	li	a3,1
 58a:	4629                	li	a2,10
 58c:	000bb583          	ld	a1,0(s7)
 590:	855a                	mv	a0,s6
 592:	e81ff0ef          	jal	412 <printint>
        i += 2;
 596:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 598:	8ba6                	mv	s7,s1
      state = 0;
 59a:	4981                	li	s3,0
        i += 2;
 59c:	bfa1                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 59e:	008b8493          	addi	s1,s7,8
 5a2:	4681                	li	a3,0
 5a4:	4629                	li	a2,10
 5a6:	000be583          	lwu	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	e67ff0ef          	jal	412 <printint>
 5b0:	8ba6                	mv	s7,s1
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	b781                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b6:	008b8493          	addi	s1,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4629                	li	a2,10
 5be:	000bb583          	ld	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	e4fff0ef          	jal	412 <printint>
        i += 1;
 5c8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	8ba6                	mv	s7,s1
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b71d                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	008b8493          	addi	s1,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4629                	li	a2,10
 5d8:	000bb583          	ld	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	e35ff0ef          	jal	412 <printint>
        i += 2;
 5e2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e4:	8ba6                	mv	s7,s1
      state = 0;
 5e6:	4981                	li	s3,0
        i += 2;
 5e8:	b731                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5ea:	008b8493          	addi	s1,s7,8
 5ee:	4681                	li	a3,0
 5f0:	4641                	li	a2,16
 5f2:	000be583          	lwu	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	e1bff0ef          	jal	412 <printint>
 5fc:	8ba6                	mv	s7,s1
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bdd5                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 602:	008b8493          	addi	s1,s7,8
 606:	4681                	li	a3,0
 608:	4641                	li	a2,16
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	e03ff0ef          	jal	412 <printint>
        i += 1;
 614:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	8ba6                	mv	s7,s1
      state = 0;
 618:	4981                	li	s3,0
 61a:	bde9                	j	4f4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	008b8493          	addi	s1,s7,8
 620:	4681                	li	a3,0
 622:	4641                	li	a2,16
 624:	000bb583          	ld	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	de9ff0ef          	jal	412 <printint>
        i += 2;
 62e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 630:	8ba6                	mv	s7,s1
      state = 0;
 632:	4981                	li	s3,0
        i += 2;
 634:	b5c1                	j	4f4 <vprintf+0x44>
 636:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 638:	008b8793          	addi	a5,s7,8
 63c:	8cbe                	mv	s9,a5
 63e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 642:	03000593          	li	a1,48
 646:	855a                	mv	a0,s6
 648:	dadff0ef          	jal	3f4 <putc>
  putc(fd, 'x');
 64c:	07800593          	li	a1,120
 650:	855a                	mv	a0,s6
 652:	da3ff0ef          	jal	3f4 <putc>
 656:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 658:	00000b97          	auipc	s7,0x0
 65c:	330b8b93          	addi	s7,s7,816 # 988 <digits>
 660:	03c9d793          	srli	a5,s3,0x3c
 664:	97de                	add	a5,a5,s7
 666:	0007c583          	lbu	a1,0(a5)
 66a:	855a                	mv	a0,s6
 66c:	d89ff0ef          	jal	3f4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 670:	0992                	slli	s3,s3,0x4
 672:	34fd                	addiw	s1,s1,-1
 674:	f4f5                	bnez	s1,660 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 676:	8be6                	mv	s7,s9
      state = 0;
 678:	4981                	li	s3,0
 67a:	6ca2                	ld	s9,8(sp)
 67c:	bda5                	j	4f4 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 67e:	008b8493          	addi	s1,s7,8
 682:	000bc583          	lbu	a1,0(s7)
 686:	855a                	mv	a0,s6
 688:	d6dff0ef          	jal	3f4 <putc>
 68c:	8ba6                	mv	s7,s1
      state = 0;
 68e:	4981                	li	s3,0
 690:	b595                	j	4f4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 692:	008b8993          	addi	s3,s7,8
 696:	000bb483          	ld	s1,0(s7)
 69a:	cc91                	beqz	s1,6b6 <vprintf+0x206>
        for(; *s; s++)
 69c:	0004c583          	lbu	a1,0(s1)
 6a0:	c985                	beqz	a1,6d0 <vprintf+0x220>
          putc(fd, *s);
 6a2:	855a                	mv	a0,s6
 6a4:	d51ff0ef          	jal	3f4 <putc>
        for(; *s; s++)
 6a8:	0485                	addi	s1,s1,1
 6aa:	0004c583          	lbu	a1,0(s1)
 6ae:	f9f5                	bnez	a1,6a2 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6b0:	8bce                	mv	s7,s3
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	b581                	j	4f4 <vprintf+0x44>
          s = "(null)";
 6b6:	00000497          	auipc	s1,0x0
 6ba:	2ca48493          	addi	s1,s1,714 # 980 <malloc+0x12e>
        for(; *s; s++)
 6be:	02800593          	li	a1,40
 6c2:	b7c5                	j	6a2 <vprintf+0x1f2>
        putc(fd, '%');
 6c4:	85be                	mv	a1,a5
 6c6:	855a                	mv	a0,s6
 6c8:	d2dff0ef          	jal	3f4 <putc>
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b51d                	j	4f4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6d0:	8bce                	mv	s7,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b505                	j	4f4 <vprintf+0x44>
 6d6:	6906                	ld	s2,64(sp)
 6d8:	79e2                	ld	s3,56(sp)
 6da:	7a42                	ld	s4,48(sp)
 6dc:	7aa2                	ld	s5,40(sp)
 6de:	7b02                	ld	s6,32(sp)
 6e0:	6be2                	ld	s7,24(sp)
 6e2:	6c42                	ld	s8,16(sp)
    }
  }
}
 6e4:	60e6                	ld	ra,88(sp)
 6e6:	6446                	ld	s0,80(sp)
 6e8:	64a6                	ld	s1,72(sp)
 6ea:	6125                	addi	sp,sp,96
 6ec:	8082                	ret
      if(c0 == 'd'){
 6ee:	06400713          	li	a4,100
 6f2:	e4e78fe3          	beq	a5,a4,550 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6f6:	f9478693          	addi	a3,a5,-108
 6fa:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6fe:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 700:	4701                	li	a4,0
      } else if(c0 == 'u'){
 702:	07500513          	li	a0,117
 706:	e8a78ce3          	beq	a5,a0,59e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 70a:	f8b60513          	addi	a0,a2,-117
 70e:	e119                	bnez	a0,714 <vprintf+0x264>
 710:	ea0693e3          	bnez	a3,5b6 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 714:	f8b58513          	addi	a0,a1,-117
 718:	e119                	bnez	a0,71e <vprintf+0x26e>
 71a:	ea071be3          	bnez	a4,5d0 <vprintf+0x120>
      } else if(c0 == 'x'){
 71e:	07800513          	li	a0,120
 722:	eca784e3          	beq	a5,a0,5ea <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 726:	f8860613          	addi	a2,a2,-120
 72a:	e219                	bnez	a2,730 <vprintf+0x280>
 72c:	ec069be3          	bnez	a3,602 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 730:	f8858593          	addi	a1,a1,-120
 734:	e199                	bnez	a1,73a <vprintf+0x28a>
 736:	ee0713e3          	bnez	a4,61c <vprintf+0x16c>
      } else if(c0 == 'p'){
 73a:	07000713          	li	a4,112
 73e:	eee78ce3          	beq	a5,a4,636 <vprintf+0x186>
      } else if(c0 == 'c'){
 742:	06300713          	li	a4,99
 746:	f2e78ce3          	beq	a5,a4,67e <vprintf+0x1ce>
      } else if(c0 == 's'){
 74a:	07300713          	li	a4,115
 74e:	f4e782e3          	beq	a5,a4,692 <vprintf+0x1e2>
      } else if(c0 == '%'){
 752:	02500713          	li	a4,37
 756:	f6e787e3          	beq	a5,a4,6c4 <vprintf+0x214>
        putc(fd, '%');
 75a:	02500593          	li	a1,37
 75e:	855a                	mv	a0,s6
 760:	c95ff0ef          	jal	3f4 <putc>
        putc(fd, c0);
 764:	85a6                	mv	a1,s1
 766:	855a                	mv	a0,s6
 768:	c8dff0ef          	jal	3f4 <putc>
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b359                	j	4f4 <vprintf+0x44>

0000000000000770 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 770:	715d                	addi	sp,sp,-80
 772:	ec06                	sd	ra,24(sp)
 774:	e822                	sd	s0,16(sp)
 776:	1000                	addi	s0,sp,32
 778:	e010                	sd	a2,0(s0)
 77a:	e414                	sd	a3,8(s0)
 77c:	e818                	sd	a4,16(s0)
 77e:	ec1c                	sd	a5,24(s0)
 780:	03043023          	sd	a6,32(s0)
 784:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 788:	8622                	mv	a2,s0
 78a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 78e:	d23ff0ef          	jal	4b0 <vprintf>
}
 792:	60e2                	ld	ra,24(sp)
 794:	6442                	ld	s0,16(sp)
 796:	6161                	addi	sp,sp,80
 798:	8082                	ret

000000000000079a <printf>:

void
printf(const char *fmt, ...)
{
 79a:	711d                	addi	sp,sp,-96
 79c:	ec06                	sd	ra,24(sp)
 79e:	e822                	sd	s0,16(sp)
 7a0:	1000                	addi	s0,sp,32
 7a2:	e40c                	sd	a1,8(s0)
 7a4:	e810                	sd	a2,16(s0)
 7a6:	ec14                	sd	a3,24(s0)
 7a8:	f018                	sd	a4,32(s0)
 7aa:	f41c                	sd	a5,40(s0)
 7ac:	03043823          	sd	a6,48(s0)
 7b0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b4:	00840613          	addi	a2,s0,8
 7b8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7bc:	85aa                	mv	a1,a0
 7be:	4505                	li	a0,1
 7c0:	cf1ff0ef          	jal	4b0 <vprintf>
}
 7c4:	60e2                	ld	ra,24(sp)
 7c6:	6442                	ld	s0,16(sp)
 7c8:	6125                	addi	sp,sp,96
 7ca:	8082                	ret

00000000000007cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7cc:	1141                	addi	sp,sp,-16
 7ce:	e406                	sd	ra,8(sp)
 7d0:	e022                	sd	s0,0(sp)
 7d2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	00001797          	auipc	a5,0x1
 7dc:	8287b783          	ld	a5,-2008(a5) # 1000 <freep>
 7e0:	a039                	j	7ee <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	6398                	ld	a4,0(a5)
 7e4:	00e7e463          	bltu	a5,a4,7ec <free+0x20>
 7e8:	00e6ea63          	bltu	a3,a4,7fc <free+0x30>
{
 7ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	fed7fae3          	bgeu	a5,a3,7e2 <free+0x16>
 7f2:	6398                	ld	a4,0(a5)
 7f4:	00e6e463          	bltu	a3,a4,7fc <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	fee7eae3          	bltu	a5,a4,7ec <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7fc:	ff852583          	lw	a1,-8(a0)
 800:	6390                	ld	a2,0(a5)
 802:	02059813          	slli	a6,a1,0x20
 806:	01c85713          	srli	a4,a6,0x1c
 80a:	9736                	add	a4,a4,a3
 80c:	02e60563          	beq	a2,a4,836 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 810:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 814:	4790                	lw	a2,8(a5)
 816:	02061593          	slli	a1,a2,0x20
 81a:	01c5d713          	srli	a4,a1,0x1c
 81e:	973e                	add	a4,a4,a5
 820:	02e68263          	beq	a3,a4,844 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 824:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 826:	00000717          	auipc	a4,0x0
 82a:	7cf73d23          	sd	a5,2010(a4) # 1000 <freep>
}
 82e:	60a2                	ld	ra,8(sp)
 830:	6402                	ld	s0,0(sp)
 832:	0141                	addi	sp,sp,16
 834:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 836:	4618                	lw	a4,8(a2)
 838:	9f2d                	addw	a4,a4,a1
 83a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83e:	6398                	ld	a4,0(a5)
 840:	6310                	ld	a2,0(a4)
 842:	b7f9                	j	810 <free+0x44>
    p->s.size += bp->s.size;
 844:	ff852703          	lw	a4,-8(a0)
 848:	9f31                	addw	a4,a4,a2
 84a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 84c:	ff053683          	ld	a3,-16(a0)
 850:	bfd1                	j	824 <free+0x58>

0000000000000852 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 852:	7139                	addi	sp,sp,-64
 854:	fc06                	sd	ra,56(sp)
 856:	f822                	sd	s0,48(sp)
 858:	f04a                	sd	s2,32(sp)
 85a:	ec4e                	sd	s3,24(sp)
 85c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85e:	02051993          	slli	s3,a0,0x20
 862:	0209d993          	srli	s3,s3,0x20
 866:	09bd                	addi	s3,s3,15
 868:	0049d993          	srli	s3,s3,0x4
 86c:	2985                	addiw	s3,s3,1
 86e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 870:	00000517          	auipc	a0,0x0
 874:	79053503          	ld	a0,1936(a0) # 1000 <freep>
 878:	c905                	beqz	a0,8a8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87c:	4798                	lw	a4,8(a5)
 87e:	09377663          	bgeu	a4,s3,90a <malloc+0xb8>
 882:	f426                	sd	s1,40(sp)
 884:	e852                	sd	s4,16(sp)
 886:	e456                	sd	s5,8(sp)
 888:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 88a:	8a4e                	mv	s4,s3
 88c:	6705                	lui	a4,0x1
 88e:	00e9f363          	bgeu	s3,a4,894 <malloc+0x42>
 892:	6a05                	lui	s4,0x1
 894:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 898:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 89c:	00000497          	auipc	s1,0x0
 8a0:	76448493          	addi	s1,s1,1892 # 1000 <freep>
  if(p == SBRK_ERROR)
 8a4:	5afd                	li	s5,-1
 8a6:	a83d                	j	8e4 <malloc+0x92>
 8a8:	f426                	sd	s1,40(sp)
 8aa:	e852                	sd	s4,16(sp)
 8ac:	e456                	sd	s5,8(sp)
 8ae:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b0:	00000797          	auipc	a5,0x0
 8b4:	76078793          	addi	a5,a5,1888 # 1010 <base>
 8b8:	00000717          	auipc	a4,0x0
 8bc:	74f73423          	sd	a5,1864(a4) # 1000 <freep>
 8c0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8c6:	b7d1                	j	88a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8c8:	6398                	ld	a4,0(a5)
 8ca:	e118                	sd	a4,0(a0)
 8cc:	a899                	j	922 <malloc+0xd0>
  hp->s.size = nu;
 8ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d2:	0541                	addi	a0,a0,16
 8d4:	ef9ff0ef          	jal	7cc <free>
  return freep;
 8d8:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8da:	c125                	beqz	a0,93a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8de:	4798                	lw	a4,8(a5)
 8e0:	03277163          	bgeu	a4,s2,902 <malloc+0xb0>
    if(p == freep)
 8e4:	6098                	ld	a4,0(s1)
 8e6:	853e                	mv	a0,a5
 8e8:	fef71ae3          	bne	a4,a5,8dc <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8ec:	8552                	mv	a0,s4
 8ee:	9e3ff0ef          	jal	2d0 <sbrk>
  if(p == SBRK_ERROR)
 8f2:	fd551ee3          	bne	a0,s5,8ce <malloc+0x7c>
        return 0;
 8f6:	4501                	li	a0,0
 8f8:	74a2                	ld	s1,40(sp)
 8fa:	6a42                	ld	s4,16(sp)
 8fc:	6aa2                	ld	s5,8(sp)
 8fe:	6b02                	ld	s6,0(sp)
 900:	a03d                	j	92e <malloc+0xdc>
 902:	74a2                	ld	s1,40(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 90a:	fae90fe3          	beq	s2,a4,8c8 <malloc+0x76>
        p->s.size -= nunits;
 90e:	4137073b          	subw	a4,a4,s3
 912:	c798                	sw	a4,8(a5)
        p += p->s.size;
 914:	02071693          	slli	a3,a4,0x20
 918:	01c6d713          	srli	a4,a3,0x1c
 91c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 91e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 922:	00000717          	auipc	a4,0x0
 926:	6ca73f23          	sd	a0,1758(a4) # 1000 <freep>
      return (void*)(p + 1);
 92a:	01078513          	addi	a0,a5,16
  }
}
 92e:	70e2                	ld	ra,56(sp)
 930:	7442                	ld	s0,48(sp)
 932:	7902                	ld	s2,32(sp)
 934:	69e2                	ld	s3,24(sp)
 936:	6121                	addi	sp,sp,64
 938:	8082                	ret
 93a:	74a2                	ld	s1,40(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
 942:	b7f5                	j	92e <malloc+0xdc>
