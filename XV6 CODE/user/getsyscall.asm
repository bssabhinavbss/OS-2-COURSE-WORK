
user/_getsyscall:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(void){
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int before, after;
  before = getsyscount();
   c:	3cc000ef          	jal	3d8 <getsyscount>
  10:	84aa                	mv	s1,a0
  getpid();
  12:	386000ef          	jal	398 <getpid>
  getpid();
  16:	382000ef          	jal	398 <getpid>
  write(1, "x\n", 2);
  1a:	4609                	li	a2,2
  1c:	00001597          	auipc	a1,0x1
  20:	94458593          	addi	a1,a1,-1724 # 960 <malloc+0xfa>
  24:	4505                	li	a0,1
  26:	312000ef          	jal	338 <write>
  after = getsyscount();
  2a:	3ae000ef          	jal	3d8 <getsyscount>
  2e:	892a                	mv	s2,a0
  printf("syscalls before = %d\n", before);
  30:	85a6                	mv	a1,s1
  32:	00001517          	auipc	a0,0x1
  36:	93650513          	addi	a0,a0,-1738 # 968 <malloc+0x102>
  3a:	774000ef          	jal	7ae <printf>
  printf("syscalls after  = %d\n", after);
  3e:	85ca                	mv	a1,s2
  40:	00001517          	auipc	a0,0x1
  44:	94050513          	addi	a0,a0,-1728 # 980 <malloc+0x11a>
  48:	766000ef          	jal	7ae <printf>
  int difference = after-before;
  printf("difference = %d\n", difference);
  4c:	409905bb          	subw	a1,s2,s1
  50:	00001517          	auipc	a0,0x1
  54:	94850513          	addi	a0,a0,-1720 # 998 <malloc+0x132>
  58:	756000ef          	jal	7ae <printf>

  exit(0);
  5c:	4501                	li	a0,0
  5e:	2ba000ef          	jal	318 <exit>

0000000000000062 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  6a:	f97ff0ef          	jal	0 <main>
  exit(r);
  6e:	2aa000ef          	jal	318 <exit>

0000000000000072 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  72:	1141                	addi	sp,sp,-16
  74:	e406                	sd	ra,8(sp)
  76:	e022                	sd	s0,0(sp)
  78:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7a:	87aa                	mv	a5,a0
  7c:	0585                	addi	a1,a1,1
  7e:	0785                	addi	a5,a5,1
  80:	fff5c703          	lbu	a4,-1(a1)
  84:	fee78fa3          	sb	a4,-1(a5)
  88:	fb75                	bnez	a4,7c <strcpy+0xa>
    ;
  return os;
}
  8a:	60a2                	ld	ra,8(sp)
  8c:	6402                	ld	s0,0(sp)
  8e:	0141                	addi	sp,sp,16
  90:	8082                	ret

0000000000000092 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  92:	1141                	addi	sp,sp,-16
  94:	e406                	sd	ra,8(sp)
  96:	e022                	sd	s0,0(sp)
  98:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cb91                	beqz	a5,b2 <strcmp+0x20>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71763          	bne	a4,a5,b2 <strcmp+0x20>
    p++, q++;
  a8:	0505                	addi	a0,a0,1
  aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	fbe5                	bnez	a5,a0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b2:	0005c503          	lbu	a0,0(a1)
}
  b6:	40a7853b          	subw	a0,a5,a0
  ba:	60a2                	ld	ra,8(sp)
  bc:	6402                	ld	s0,0(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strlen>:

uint
strlen(const char *s)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e406                	sd	ra,8(sp)
  c6:	e022                	sd	s0,0(sp)
  c8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cf91                	beqz	a5,ea <strlen+0x28>
  d0:	00150793          	addi	a5,a0,1
  d4:	86be                	mv	a3,a5
  d6:	0785                	addi	a5,a5,1
  d8:	fff7c703          	lbu	a4,-1(a5)
  dc:	ff65                	bnez	a4,d4 <strlen+0x12>
  de:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  e2:	60a2                	ld	ra,8(sp)
  e4:	6402                	ld	s0,0(sp)
  e6:	0141                	addi	sp,sp,16
  e8:	8082                	ret
  for(n = 0; s[n]; n++)
  ea:	4501                	li	a0,0
  ec:	bfdd                	j	e2 <strlen+0x20>

00000000000000ee <memset>:

void*
memset(void *dst, int c, uint n)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e406                	sd	ra,8(sp)
  f2:	e022                	sd	s0,0(sp)
  f4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f6:	ca19                	beqz	a2,10c <memset+0x1e>
  f8:	87aa                	mv	a5,a0
  fa:	1602                	slli	a2,a2,0x20
  fc:	9201                	srli	a2,a2,0x20
  fe:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 102:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 106:	0785                	addi	a5,a5,1
 108:	fee79de3          	bne	a5,a4,102 <memset+0x14>
  }
  return dst;
}
 10c:	60a2                	ld	ra,8(sp)
 10e:	6402                	ld	s0,0(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strchr>:

char*
strchr(const char *s, char c)
{
 114:	1141                	addi	sp,sp,-16
 116:	e406                	sd	ra,8(sp)
 118:	e022                	sd	s0,0(sp)
 11a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cf81                	beqz	a5,138 <strchr+0x24>
    if(*s == c)
 122:	00f58763          	beq	a1,a5,130 <strchr+0x1c>
  for(; *s; s++)
 126:	0505                	addi	a0,a0,1
 128:	00054783          	lbu	a5,0(a0)
 12c:	fbfd                	bnez	a5,122 <strchr+0xe>
      return (char*)s;
  return 0;
 12e:	4501                	li	a0,0
}
 130:	60a2                	ld	ra,8(sp)
 132:	6402                	ld	s0,0(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret
  return 0;
 138:	4501                	li	a0,0
 13a:	bfdd                	j	130 <strchr+0x1c>

000000000000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	711d                	addi	sp,sp,-96
 13e:	ec86                	sd	ra,88(sp)
 140:	e8a2                	sd	s0,80(sp)
 142:	e4a6                	sd	s1,72(sp)
 144:	e0ca                	sd	s2,64(sp)
 146:	fc4e                	sd	s3,56(sp)
 148:	f852                	sd	s4,48(sp)
 14a:	f456                	sd	s5,40(sp)
 14c:	f05a                	sd	s6,32(sp)
 14e:	ec5e                	sd	s7,24(sp)
 150:	e862                	sd	s8,16(sp)
 152:	1080                	addi	s0,sp,96
 154:	8baa                	mv	s7,a0
 156:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 158:	892a                	mv	s2,a0
 15a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 15c:	faf40b13          	addi	s6,s0,-81
 160:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 162:	8c26                	mv	s8,s1
 164:	0014899b          	addiw	s3,s1,1
 168:	84ce                	mv	s1,s3
 16a:	0349d463          	bge	s3,s4,192 <gets+0x56>
    cc = read(0, &c, 1);
 16e:	8656                	mv	a2,s5
 170:	85da                	mv	a1,s6
 172:	4501                	li	a0,0
 174:	1bc000ef          	jal	330 <read>
    if(cc < 1)
 178:	00a05d63          	blez	a0,192 <gets+0x56>
      break;
    buf[i++] = c;
 17c:	faf44783          	lbu	a5,-81(s0)
 180:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 184:	0905                	addi	s2,s2,1
 186:	ff678713          	addi	a4,a5,-10
 18a:	c319                	beqz	a4,190 <gets+0x54>
 18c:	17cd                	addi	a5,a5,-13
 18e:	fbf1                	bnez	a5,162 <gets+0x26>
    buf[i++] = c;
 190:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 192:	9c5e                	add	s8,s8,s7
 194:	000c0023          	sb	zero,0(s8)
  return buf;
}
 198:	855e                	mv	a0,s7
 19a:	60e6                	ld	ra,88(sp)
 19c:	6446                	ld	s0,80(sp)
 19e:	64a6                	ld	s1,72(sp)
 1a0:	6906                	ld	s2,64(sp)
 1a2:	79e2                	ld	s3,56(sp)
 1a4:	7a42                	ld	s4,48(sp)
 1a6:	7aa2                	ld	s5,40(sp)
 1a8:	7b02                	ld	s6,32(sp)
 1aa:	6be2                	ld	s7,24(sp)
 1ac:	6c42                	ld	s8,16(sp)
 1ae:	6125                	addi	sp,sp,96
 1b0:	8082                	ret

00000000000001b2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b2:	1101                	addi	sp,sp,-32
 1b4:	ec06                	sd	ra,24(sp)
 1b6:	e822                	sd	s0,16(sp)
 1b8:	e04a                	sd	s2,0(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1be:	4581                	li	a1,0
 1c0:	198000ef          	jal	358 <open>
  if(fd < 0)
 1c4:	02054263          	bltz	a0,1e8 <stat+0x36>
 1c8:	e426                	sd	s1,8(sp)
 1ca:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1cc:	85ca                	mv	a1,s2
 1ce:	1a2000ef          	jal	370 <fstat>
 1d2:	892a                	mv	s2,a0
  close(fd);
 1d4:	8526                	mv	a0,s1
 1d6:	16a000ef          	jal	340 <close>
  return r;
 1da:	64a2                	ld	s1,8(sp)
}
 1dc:	854a                	mv	a0,s2
 1de:	60e2                	ld	ra,24(sp)
 1e0:	6442                	ld	s0,16(sp)
 1e2:	6902                	ld	s2,0(sp)
 1e4:	6105                	addi	sp,sp,32
 1e6:	8082                	ret
    return -1;
 1e8:	57fd                	li	a5,-1
 1ea:	893e                	mv	s2,a5
 1ec:	bfc5                	j	1dc <stat+0x2a>

00000000000001ee <atoi>:

int
atoi(const char *s)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e406                	sd	ra,8(sp)
 1f2:	e022                	sd	s0,0(sp)
 1f4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f6:	00054683          	lbu	a3,0(a0)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	4625                	li	a2,9
 204:	02f66963          	bltu	a2,a5,236 <atoi+0x48>
 208:	872a                	mv	a4,a0
  n = 0;
 20a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20c:	0705                	addi	a4,a4,1
 20e:	0025179b          	slliw	a5,a0,0x2
 212:	9fa9                	addw	a5,a5,a0
 214:	0017979b          	slliw	a5,a5,0x1
 218:	9fb5                	addw	a5,a5,a3
 21a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21e:	00074683          	lbu	a3,0(a4)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	fef671e3          	bgeu	a2,a5,20c <atoi+0x1e>
  return n;
}
 22e:	60a2                	ld	ra,8(sp)
 230:	6402                	ld	s0,0(sp)
 232:	0141                	addi	sp,sp,16
 234:	8082                	ret
  n = 0;
 236:	4501                	li	a0,0
 238:	bfdd                	j	22e <atoi+0x40>

000000000000023a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 23a:	1141                	addi	sp,sp,-16
 23c:	e406                	sd	ra,8(sp)
 23e:	e022                	sd	s0,0(sp)
 240:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 242:	02b57563          	bgeu	a0,a1,26c <memmove+0x32>
    while(n-- > 0)
 246:	00c05f63          	blez	a2,264 <memmove+0x2a>
 24a:	1602                	slli	a2,a2,0x20
 24c:	9201                	srli	a2,a2,0x20
 24e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 252:	872a                	mv	a4,a0
      *dst++ = *src++;
 254:	0585                	addi	a1,a1,1
 256:	0705                	addi	a4,a4,1
 258:	fff5c683          	lbu	a3,-1(a1)
 25c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 260:	fee79ae3          	bne	a5,a4,254 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 264:	60a2                	ld	ra,8(sp)
 266:	6402                	ld	s0,0(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret
    while(n-- > 0)
 26c:	fec05ce3          	blez	a2,264 <memmove+0x2a>
    dst += n;
 270:	00c50733          	add	a4,a0,a2
    src += n;
 274:	95b2                	add	a1,a1,a2
 276:	fff6079b          	addiw	a5,a2,-1
 27a:	1782                	slli	a5,a5,0x20
 27c:	9381                	srli	a5,a5,0x20
 27e:	fff7c793          	not	a5,a5
 282:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 284:	15fd                	addi	a1,a1,-1
 286:	177d                	addi	a4,a4,-1
 288:	0005c683          	lbu	a3,0(a1)
 28c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 290:	fef71ae3          	bne	a4,a5,284 <memmove+0x4a>
 294:	bfc1                	j	264 <memmove+0x2a>

0000000000000296 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 296:	1141                	addi	sp,sp,-16
 298:	e406                	sd	ra,8(sp)
 29a:	e022                	sd	s0,0(sp)
 29c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 29e:	c61d                	beqz	a2,2cc <memcmp+0x36>
 2a0:	1602                	slli	a2,a2,0x20
 2a2:	9201                	srli	a2,a2,0x20
 2a4:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2a8:	00054783          	lbu	a5,0(a0)
 2ac:	0005c703          	lbu	a4,0(a1)
 2b0:	00e79863          	bne	a5,a4,2c0 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2b4:	0505                	addi	a0,a0,1
    p2++;
 2b6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b8:	fed518e3          	bne	a0,a3,2a8 <memcmp+0x12>
  }
  return 0;
 2bc:	4501                	li	a0,0
 2be:	a019                	j	2c4 <memcmp+0x2e>
      return *p1 - *p2;
 2c0:	40e7853b          	subw	a0,a5,a4
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
  return 0;
 2cc:	4501                	li	a0,0
 2ce:	bfdd                	j	2c4 <memcmp+0x2e>

00000000000002d0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d8:	f63ff0ef          	jal	23a <memmove>
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret

00000000000002e4 <sbrk>:

char *
sbrk(int n) {
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e406                	sd	ra,8(sp)
 2e8:	e022                	sd	s0,0(sp)
 2ea:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2ec:	4585                	li	a1,1
 2ee:	0b2000ef          	jal	3a0 <sys_sbrk>
}
 2f2:	60a2                	ld	ra,8(sp)
 2f4:	6402                	ld	s0,0(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret

00000000000002fa <sbrklazy>:

char *
sbrklazy(int n) {
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e406                	sd	ra,8(sp)
 2fe:	e022                	sd	s0,0(sp)
 300:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 302:	4589                	li	a1,2
 304:	09c000ef          	jal	3a0 <sys_sbrk>
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret

0000000000000310 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 310:	4885                	li	a7,1
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <exit>:
.global exit
exit:
 li a7, SYS_exit
 318:	4889                	li	a7,2
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <wait>:
.global wait
wait:
 li a7, SYS_wait
 320:	488d                	li	a7,3
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 328:	4891                	li	a7,4
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <read>:
.global read
read:
 li a7, SYS_read
 330:	4895                	li	a7,5
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <write>:
.global write
write:
 li a7, SYS_write
 338:	48c1                	li	a7,16
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <close>:
.global close
close:
 li a7, SYS_close
 340:	48d5                	li	a7,21
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <kill>:
.global kill
kill:
 li a7, SYS_kill
 348:	4899                	li	a7,6
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <exec>:
.global exec
exec:
 li a7, SYS_exec
 350:	489d                	li	a7,7
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <open>:
.global open
open:
 li a7, SYS_open
 358:	48bd                	li	a7,15
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 360:	48c5                	li	a7,17
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 368:	48c9                	li	a7,18
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 370:	48a1                	li	a7,8
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <link>:
.global link
link:
 li a7, SYS_link
 378:	48cd                	li	a7,19
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 380:	48d1                	li	a7,20
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 388:	48a5                	li	a7,9
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <dup>:
.global dup
dup:
 li a7, SYS_dup
 390:	48a9                	li	a7,10
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 398:	48ad                	li	a7,11
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a0:	48b1                	li	a7,12
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3a8:	48b5                	li	a7,13
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b0:	48b9                	li	a7,14
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <hello>:
.global hello
hello:
 li a7, SYS_hello
 3b8:	48d9                	li	a7,22
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 3c0:	48dd                	li	a7,23
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3c8:	48e1                	li	a7,24
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 3d0:	48e5                	li	a7,25
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 3d8:	48e9                	li	a7,26
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 3e0:	48ed                	li	a7,27
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 3e8:	48f1                	li	a7,28
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 3f0:	48f5                	li	a7,29
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 3f8:	48f9                	li	a7,30
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 400:	48fd                	li	a7,31
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 408:	1101                	addi	sp,sp,-32
 40a:	ec06                	sd	ra,24(sp)
 40c:	e822                	sd	s0,16(sp)
 40e:	1000                	addi	s0,sp,32
 410:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 414:	4605                	li	a2,1
 416:	fef40593          	addi	a1,s0,-17
 41a:	f1fff0ef          	jal	338 <write>
}
 41e:	60e2                	ld	ra,24(sp)
 420:	6442                	ld	s0,16(sp)
 422:	6105                	addi	sp,sp,32
 424:	8082                	ret

0000000000000426 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 426:	715d                	addi	sp,sp,-80
 428:	e486                	sd	ra,72(sp)
 42a:	e0a2                	sd	s0,64(sp)
 42c:	f84a                	sd	s2,48(sp)
 42e:	f44e                	sd	s3,40(sp)
 430:	0880                	addi	s0,sp,80
 432:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 434:	c6d1                	beqz	a3,4c0 <printint+0x9a>
 436:	0805d563          	bgez	a1,4c0 <printint+0x9a>
    neg = 1;
    x = -xx;
 43a:	40b005b3          	neg	a1,a1
    neg = 1;
 43e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 440:	fb840993          	addi	s3,s0,-72
  neg = 0;
 444:	86ce                	mv	a3,s3
  i = 0;
 446:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 448:	00000817          	auipc	a6,0x0
 44c:	57080813          	addi	a6,a6,1392 # 9b8 <digits>
 450:	88ba                	mv	a7,a4
 452:	0017051b          	addiw	a0,a4,1
 456:	872a                	mv	a4,a0
 458:	02c5f7b3          	remu	a5,a1,a2
 45c:	97c2                	add	a5,a5,a6
 45e:	0007c783          	lbu	a5,0(a5)
 462:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 466:	87ae                	mv	a5,a1
 468:	02c5d5b3          	divu	a1,a1,a2
 46c:	0685                	addi	a3,a3,1
 46e:	fec7f1e3          	bgeu	a5,a2,450 <printint+0x2a>
  if(neg)
 472:	00030c63          	beqz	t1,48a <printint+0x64>
    buf[i++] = '-';
 476:	fd050793          	addi	a5,a0,-48
 47a:	00878533          	add	a0,a5,s0
 47e:	02d00793          	li	a5,45
 482:	fef50423          	sb	a5,-24(a0)
 486:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 48a:	02e05563          	blez	a4,4b4 <printint+0x8e>
 48e:	fc26                	sd	s1,56(sp)
 490:	377d                	addiw	a4,a4,-1
 492:	00e984b3          	add	s1,s3,a4
 496:	19fd                	addi	s3,s3,-1
 498:	99ba                	add	s3,s3,a4
 49a:	1702                	slli	a4,a4,0x20
 49c:	9301                	srli	a4,a4,0x20
 49e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4a2:	0004c583          	lbu	a1,0(s1)
 4a6:	854a                	mv	a0,s2
 4a8:	f61ff0ef          	jal	408 <putc>
  while(--i >= 0)
 4ac:	14fd                	addi	s1,s1,-1
 4ae:	ff349ae3          	bne	s1,s3,4a2 <printint+0x7c>
 4b2:	74e2                	ld	s1,56(sp)
}
 4b4:	60a6                	ld	ra,72(sp)
 4b6:	6406                	ld	s0,64(sp)
 4b8:	7942                	ld	s2,48(sp)
 4ba:	79a2                	ld	s3,40(sp)
 4bc:	6161                	addi	sp,sp,80
 4be:	8082                	ret
  neg = 0;
 4c0:	4301                	li	t1,0
 4c2:	bfbd                	j	440 <printint+0x1a>

00000000000004c4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4c4:	711d                	addi	sp,sp,-96
 4c6:	ec86                	sd	ra,88(sp)
 4c8:	e8a2                	sd	s0,80(sp)
 4ca:	e4a6                	sd	s1,72(sp)
 4cc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ce:	0005c483          	lbu	s1,0(a1)
 4d2:	22048363          	beqz	s1,6f8 <vprintf+0x234>
 4d6:	e0ca                	sd	s2,64(sp)
 4d8:	fc4e                	sd	s3,56(sp)
 4da:	f852                	sd	s4,48(sp)
 4dc:	f456                	sd	s5,40(sp)
 4de:	f05a                	sd	s6,32(sp)
 4e0:	ec5e                	sd	s7,24(sp)
 4e2:	e862                	sd	s8,16(sp)
 4e4:	8b2a                	mv	s6,a0
 4e6:	8a2e                	mv	s4,a1
 4e8:	8bb2                	mv	s7,a2
  state = 0;
 4ea:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ec:	4901                	li	s2,0
 4ee:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4f0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4f4:	06400c13          	li	s8,100
 4f8:	a00d                	j	51a <vprintf+0x56>
        putc(fd, c0);
 4fa:	85a6                	mv	a1,s1
 4fc:	855a                	mv	a0,s6
 4fe:	f0bff0ef          	jal	408 <putc>
 502:	a019                	j	508 <vprintf+0x44>
    } else if(state == '%'){
 504:	03598363          	beq	s3,s5,52a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 508:	0019079b          	addiw	a5,s2,1
 50c:	893e                	mv	s2,a5
 50e:	873e                	mv	a4,a5
 510:	97d2                	add	a5,a5,s4
 512:	0007c483          	lbu	s1,0(a5)
 516:	1c048a63          	beqz	s1,6ea <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 51a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 51e:	fe0993e3          	bnez	s3,504 <vprintf+0x40>
      if(c0 == '%'){
 522:	fd579ce3          	bne	a5,s5,4fa <vprintf+0x36>
        state = '%';
 526:	89be                	mv	s3,a5
 528:	b7c5                	j	508 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 52a:	00ea06b3          	add	a3,s4,a4
 52e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 532:	1c060863          	beqz	a2,702 <vprintf+0x23e>
      if(c0 == 'd'){
 536:	03878763          	beq	a5,s8,564 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 53a:	f9478693          	addi	a3,a5,-108
 53e:	0016b693          	seqz	a3,a3
 542:	f9c60593          	addi	a1,a2,-100
 546:	e99d                	bnez	a1,57c <vprintf+0xb8>
 548:	ca95                	beqz	a3,57c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 54a:	008b8493          	addi	s1,s7,8
 54e:	4685                	li	a3,1
 550:	4629                	li	a2,10
 552:	000bb583          	ld	a1,0(s7)
 556:	855a                	mv	a0,s6
 558:	ecfff0ef          	jal	426 <printint>
        i += 1;
 55c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 55e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 560:	4981                	li	s3,0
 562:	b75d                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 564:	008b8493          	addi	s1,s7,8
 568:	4685                	li	a3,1
 56a:	4629                	li	a2,10
 56c:	000ba583          	lw	a1,0(s7)
 570:	855a                	mv	a0,s6
 572:	eb5ff0ef          	jal	426 <printint>
 576:	8ba6                	mv	s7,s1
      state = 0;
 578:	4981                	li	s3,0
 57a:	b779                	j	508 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 57c:	9752                	add	a4,a4,s4
 57e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 582:	f9460713          	addi	a4,a2,-108
 586:	00173713          	seqz	a4,a4
 58a:	8f75                	and	a4,a4,a3
 58c:	f9c58513          	addi	a0,a1,-100
 590:	18051363          	bnez	a0,716 <vprintf+0x252>
 594:	18070163          	beqz	a4,716 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 598:	008b8493          	addi	s1,s7,8
 59c:	4685                	li	a3,1
 59e:	4629                	li	a2,10
 5a0:	000bb583          	ld	a1,0(s7)
 5a4:	855a                	mv	a0,s6
 5a6:	e81ff0ef          	jal	426 <printint>
        i += 2;
 5aa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ac:	8ba6                	mv	s7,s1
      state = 0;
 5ae:	4981                	li	s3,0
        i += 2;
 5b0:	bfa1                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5b2:	008b8493          	addi	s1,s7,8
 5b6:	4681                	li	a3,0
 5b8:	4629                	li	a2,10
 5ba:	000be583          	lwu	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	e67ff0ef          	jal	426 <printint>
 5c4:	8ba6                	mv	s7,s1
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b781                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	008b8493          	addi	s1,s7,8
 5ce:	4681                	li	a3,0
 5d0:	4629                	li	a2,10
 5d2:	000bb583          	ld	a1,0(s7)
 5d6:	855a                	mv	a0,s6
 5d8:	e4fff0ef          	jal	426 <printint>
        i += 1;
 5dc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5de:	8ba6                	mv	s7,s1
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b71d                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e4:	008b8493          	addi	s1,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4629                	li	a2,10
 5ec:	000bb583          	ld	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	e35ff0ef          	jal	426 <printint>
        i += 2;
 5f6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f8:	8ba6                	mv	s7,s1
      state = 0;
 5fa:	4981                	li	s3,0
        i += 2;
 5fc:	b731                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5fe:	008b8493          	addi	s1,s7,8
 602:	4681                	li	a3,0
 604:	4641                	li	a2,16
 606:	000be583          	lwu	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	e1bff0ef          	jal	426 <printint>
 610:	8ba6                	mv	s7,s1
      state = 0;
 612:	4981                	li	s3,0
 614:	bdd5                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	008b8493          	addi	s1,s7,8
 61a:	4681                	li	a3,0
 61c:	4641                	li	a2,16
 61e:	000bb583          	ld	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e03ff0ef          	jal	426 <printint>
        i += 1;
 628:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 62a:	8ba6                	mv	s7,s1
      state = 0;
 62c:	4981                	li	s3,0
 62e:	bde9                	j	508 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 630:	008b8493          	addi	s1,s7,8
 634:	4681                	li	a3,0
 636:	4641                	li	a2,16
 638:	000bb583          	ld	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	de9ff0ef          	jal	426 <printint>
        i += 2;
 642:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 644:	8ba6                	mv	s7,s1
      state = 0;
 646:	4981                	li	s3,0
        i += 2;
 648:	b5c1                	j	508 <vprintf+0x44>
 64a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 64c:	008b8793          	addi	a5,s7,8
 650:	8cbe                	mv	s9,a5
 652:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 656:	03000593          	li	a1,48
 65a:	855a                	mv	a0,s6
 65c:	dadff0ef          	jal	408 <putc>
  putc(fd, 'x');
 660:	07800593          	li	a1,120
 664:	855a                	mv	a0,s6
 666:	da3ff0ef          	jal	408 <putc>
 66a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66c:	00000b97          	auipc	s7,0x0
 670:	34cb8b93          	addi	s7,s7,844 # 9b8 <digits>
 674:	03c9d793          	srli	a5,s3,0x3c
 678:	97de                	add	a5,a5,s7
 67a:	0007c583          	lbu	a1,0(a5)
 67e:	855a                	mv	a0,s6
 680:	d89ff0ef          	jal	408 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 684:	0992                	slli	s3,s3,0x4
 686:	34fd                	addiw	s1,s1,-1
 688:	f4f5                	bnez	s1,674 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 68a:	8be6                	mv	s7,s9
      state = 0;
 68c:	4981                	li	s3,0
 68e:	6ca2                	ld	s9,8(sp)
 690:	bda5                	j	508 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 692:	008b8493          	addi	s1,s7,8
 696:	000bc583          	lbu	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	d6dff0ef          	jal	408 <putc>
 6a0:	8ba6                	mv	s7,s1
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	b595                	j	508 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6a6:	008b8993          	addi	s3,s7,8
 6aa:	000bb483          	ld	s1,0(s7)
 6ae:	cc91                	beqz	s1,6ca <vprintf+0x206>
        for(; *s; s++)
 6b0:	0004c583          	lbu	a1,0(s1)
 6b4:	c985                	beqz	a1,6e4 <vprintf+0x220>
          putc(fd, *s);
 6b6:	855a                	mv	a0,s6
 6b8:	d51ff0ef          	jal	408 <putc>
        for(; *s; s++)
 6bc:	0485                	addi	s1,s1,1
 6be:	0004c583          	lbu	a1,0(s1)
 6c2:	f9f5                	bnez	a1,6b6 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6c4:	8bce                	mv	s7,s3
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b581                	j	508 <vprintf+0x44>
          s = "(null)";
 6ca:	00000497          	auipc	s1,0x0
 6ce:	2e648493          	addi	s1,s1,742 # 9b0 <malloc+0x14a>
        for(; *s; s++)
 6d2:	02800593          	li	a1,40
 6d6:	b7c5                	j	6b6 <vprintf+0x1f2>
        putc(fd, '%');
 6d8:	85be                	mv	a1,a5
 6da:	855a                	mv	a0,s6
 6dc:	d2dff0ef          	jal	408 <putc>
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b51d                	j	508 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6e4:	8bce                	mv	s7,s3
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b505                	j	508 <vprintf+0x44>
 6ea:	6906                	ld	s2,64(sp)
 6ec:	79e2                	ld	s3,56(sp)
 6ee:	7a42                	ld	s4,48(sp)
 6f0:	7aa2                	ld	s5,40(sp)
 6f2:	7b02                	ld	s6,32(sp)
 6f4:	6be2                	ld	s7,24(sp)
 6f6:	6c42                	ld	s8,16(sp)
    }
  }
}
 6f8:	60e6                	ld	ra,88(sp)
 6fa:	6446                	ld	s0,80(sp)
 6fc:	64a6                	ld	s1,72(sp)
 6fe:	6125                	addi	sp,sp,96
 700:	8082                	ret
      if(c0 == 'd'){
 702:	06400713          	li	a4,100
 706:	e4e78fe3          	beq	a5,a4,564 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 70a:	f9478693          	addi	a3,a5,-108
 70e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 712:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 714:	4701                	li	a4,0
      } else if(c0 == 'u'){
 716:	07500513          	li	a0,117
 71a:	e8a78ce3          	beq	a5,a0,5b2 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 71e:	f8b60513          	addi	a0,a2,-117
 722:	e119                	bnez	a0,728 <vprintf+0x264>
 724:	ea0693e3          	bnez	a3,5ca <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 728:	f8b58513          	addi	a0,a1,-117
 72c:	e119                	bnez	a0,732 <vprintf+0x26e>
 72e:	ea071be3          	bnez	a4,5e4 <vprintf+0x120>
      } else if(c0 == 'x'){
 732:	07800513          	li	a0,120
 736:	eca784e3          	beq	a5,a0,5fe <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 73a:	f8860613          	addi	a2,a2,-120
 73e:	e219                	bnez	a2,744 <vprintf+0x280>
 740:	ec069be3          	bnez	a3,616 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 744:	f8858593          	addi	a1,a1,-120
 748:	e199                	bnez	a1,74e <vprintf+0x28a>
 74a:	ee0713e3          	bnez	a4,630 <vprintf+0x16c>
      } else if(c0 == 'p'){
 74e:	07000713          	li	a4,112
 752:	eee78ce3          	beq	a5,a4,64a <vprintf+0x186>
      } else if(c0 == 'c'){
 756:	06300713          	li	a4,99
 75a:	f2e78ce3          	beq	a5,a4,692 <vprintf+0x1ce>
      } else if(c0 == 's'){
 75e:	07300713          	li	a4,115
 762:	f4e782e3          	beq	a5,a4,6a6 <vprintf+0x1e2>
      } else if(c0 == '%'){
 766:	02500713          	li	a4,37
 76a:	f6e787e3          	beq	a5,a4,6d8 <vprintf+0x214>
        putc(fd, '%');
 76e:	02500593          	li	a1,37
 772:	855a                	mv	a0,s6
 774:	c95ff0ef          	jal	408 <putc>
        putc(fd, c0);
 778:	85a6                	mv	a1,s1
 77a:	855a                	mv	a0,s6
 77c:	c8dff0ef          	jal	408 <putc>
      state = 0;
 780:	4981                	li	s3,0
 782:	b359                	j	508 <vprintf+0x44>

0000000000000784 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 784:	715d                	addi	sp,sp,-80
 786:	ec06                	sd	ra,24(sp)
 788:	e822                	sd	s0,16(sp)
 78a:	1000                	addi	s0,sp,32
 78c:	e010                	sd	a2,0(s0)
 78e:	e414                	sd	a3,8(s0)
 790:	e818                	sd	a4,16(s0)
 792:	ec1c                	sd	a5,24(s0)
 794:	03043023          	sd	a6,32(s0)
 798:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79c:	8622                	mv	a2,s0
 79e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a2:	d23ff0ef          	jal	4c4 <vprintf>
}
 7a6:	60e2                	ld	ra,24(sp)
 7a8:	6442                	ld	s0,16(sp)
 7aa:	6161                	addi	sp,sp,80
 7ac:	8082                	ret

00000000000007ae <printf>:

void
printf(const char *fmt, ...)
{
 7ae:	711d                	addi	sp,sp,-96
 7b0:	ec06                	sd	ra,24(sp)
 7b2:	e822                	sd	s0,16(sp)
 7b4:	1000                	addi	s0,sp,32
 7b6:	e40c                	sd	a1,8(s0)
 7b8:	e810                	sd	a2,16(s0)
 7ba:	ec14                	sd	a3,24(s0)
 7bc:	f018                	sd	a4,32(s0)
 7be:	f41c                	sd	a5,40(s0)
 7c0:	03043823          	sd	a6,48(s0)
 7c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c8:	00840613          	addi	a2,s0,8
 7cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d0:	85aa                	mv	a1,a0
 7d2:	4505                	li	a0,1
 7d4:	cf1ff0ef          	jal	4c4 <vprintf>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6125                	addi	sp,sp,96
 7de:	8082                	ret

00000000000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	1141                	addi	sp,sp,-16
 7e2:	e406                	sd	ra,8(sp)
 7e4:	e022                	sd	s0,0(sp)
 7e6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ec:	00001797          	auipc	a5,0x1
 7f0:	8147b783          	ld	a5,-2028(a5) # 1000 <freep>
 7f4:	a039                	j	802 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f6:	6398                	ld	a4,0(a5)
 7f8:	00e7e463          	bltu	a5,a4,800 <free+0x20>
 7fc:	00e6ea63          	bltu	a3,a4,810 <free+0x30>
{
 800:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 802:	fed7fae3          	bgeu	a5,a3,7f6 <free+0x16>
 806:	6398                	ld	a4,0(a5)
 808:	00e6e463          	bltu	a3,a4,810 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80c:	fee7eae3          	bltu	a5,a4,800 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 810:	ff852583          	lw	a1,-8(a0)
 814:	6390                	ld	a2,0(a5)
 816:	02059813          	slli	a6,a1,0x20
 81a:	01c85713          	srli	a4,a6,0x1c
 81e:	9736                	add	a4,a4,a3
 820:	02e60563          	beq	a2,a4,84a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 824:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 828:	4790                	lw	a2,8(a5)
 82a:	02061593          	slli	a1,a2,0x20
 82e:	01c5d713          	srli	a4,a1,0x1c
 832:	973e                	add	a4,a4,a5
 834:	02e68263          	beq	a3,a4,858 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 838:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 83a:	00000717          	auipc	a4,0x0
 83e:	7cf73323          	sd	a5,1990(a4) # 1000 <freep>
}
 842:	60a2                	ld	ra,8(sp)
 844:	6402                	ld	s0,0(sp)
 846:	0141                	addi	sp,sp,16
 848:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 84a:	4618                	lw	a4,8(a2)
 84c:	9f2d                	addw	a4,a4,a1
 84e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 852:	6398                	ld	a4,0(a5)
 854:	6310                	ld	a2,0(a4)
 856:	b7f9                	j	824 <free+0x44>
    p->s.size += bp->s.size;
 858:	ff852703          	lw	a4,-8(a0)
 85c:	9f31                	addw	a4,a4,a2
 85e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 860:	ff053683          	ld	a3,-16(a0)
 864:	bfd1                	j	838 <free+0x58>

0000000000000866 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 866:	7139                	addi	sp,sp,-64
 868:	fc06                	sd	ra,56(sp)
 86a:	f822                	sd	s0,48(sp)
 86c:	f04a                	sd	s2,32(sp)
 86e:	ec4e                	sd	s3,24(sp)
 870:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 872:	02051993          	slli	s3,a0,0x20
 876:	0209d993          	srli	s3,s3,0x20
 87a:	09bd                	addi	s3,s3,15
 87c:	0049d993          	srli	s3,s3,0x4
 880:	2985                	addiw	s3,s3,1
 882:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 884:	00000517          	auipc	a0,0x0
 888:	77c53503          	ld	a0,1916(a0) # 1000 <freep>
 88c:	c905                	beqz	a0,8bc <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 890:	4798                	lw	a4,8(a5)
 892:	09377663          	bgeu	a4,s3,91e <malloc+0xb8>
 896:	f426                	sd	s1,40(sp)
 898:	e852                	sd	s4,16(sp)
 89a:	e456                	sd	s5,8(sp)
 89c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 89e:	8a4e                	mv	s4,s3
 8a0:	6705                	lui	a4,0x1
 8a2:	00e9f363          	bgeu	s3,a4,8a8 <malloc+0x42>
 8a6:	6a05                	lui	s4,0x1
 8a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b0:	00000497          	auipc	s1,0x0
 8b4:	75048493          	addi	s1,s1,1872 # 1000 <freep>
  if(p == SBRK_ERROR)
 8b8:	5afd                	li	s5,-1
 8ba:	a83d                	j	8f8 <malloc+0x92>
 8bc:	f426                	sd	s1,40(sp)
 8be:	e852                	sd	s4,16(sp)
 8c0:	e456                	sd	s5,8(sp)
 8c2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c4:	00000797          	auipc	a5,0x0
 8c8:	74c78793          	addi	a5,a5,1868 # 1010 <base>
 8cc:	00000717          	auipc	a4,0x0
 8d0:	72f73a23          	sd	a5,1844(a4) # 1000 <freep>
 8d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8da:	b7d1                	j	89e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8dc:	6398                	ld	a4,0(a5)
 8de:	e118                	sd	a4,0(a0)
 8e0:	a899                	j	936 <malloc+0xd0>
  hp->s.size = nu;
 8e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e6:	0541                	addi	a0,a0,16
 8e8:	ef9ff0ef          	jal	7e0 <free>
  return freep;
 8ec:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8ee:	c125                	beqz	a0,94e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f2:	4798                	lw	a4,8(a5)
 8f4:	03277163          	bgeu	a4,s2,916 <malloc+0xb0>
    if(p == freep)
 8f8:	6098                	ld	a4,0(s1)
 8fa:	853e                	mv	a0,a5
 8fc:	fef71ae3          	bne	a4,a5,8f0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 900:	8552                	mv	a0,s4
 902:	9e3ff0ef          	jal	2e4 <sbrk>
  if(p == SBRK_ERROR)
 906:	fd551ee3          	bne	a0,s5,8e2 <malloc+0x7c>
        return 0;
 90a:	4501                	li	a0,0
 90c:	74a2                	ld	s1,40(sp)
 90e:	6a42                	ld	s4,16(sp)
 910:	6aa2                	ld	s5,8(sp)
 912:	6b02                	ld	s6,0(sp)
 914:	a03d                	j	942 <malloc+0xdc>
 916:	74a2                	ld	s1,40(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 91e:	fae90fe3          	beq	s2,a4,8dc <malloc+0x76>
        p->s.size -= nunits;
 922:	4137073b          	subw	a4,a4,s3
 926:	c798                	sw	a4,8(a5)
        p += p->s.size;
 928:	02071693          	slli	a3,a4,0x20
 92c:	01c6d713          	srli	a4,a3,0x1c
 930:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 932:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 936:	00000717          	auipc	a4,0x0
 93a:	6ca73523          	sd	a0,1738(a4) # 1000 <freep>
      return (void*)(p + 1);
 93e:	01078513          	addi	a0,a5,16
  }
}
 942:	70e2                	ld	ra,56(sp)
 944:	7442                	ld	s0,48(sp)
 946:	7902                	ld	s2,32(sp)
 948:	69e2                	ld	s3,24(sp)
 94a:	6121                	addi	sp,sp,64
 94c:	8082                	ret
 94e:	74a2                	ld	s1,40(sp)
 950:	6a42                	ld	s4,16(sp)
 952:	6aa2                	ld	s5,8(sp)
 954:	6b02                	ld	s6,0(sp)
 956:	b7f5                	j	942 <malloc+0xdc>
