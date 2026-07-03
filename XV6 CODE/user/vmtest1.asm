
user/_vmtest1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_stats>:
#include "kernel/types.h"
#include "user/user.h"

void print_stats(char *msg) {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	0880                	addi	s0,sp,80
   a:	84aa                	mv	s1,a0
    struct vmstats s;
    if(getvmstats(getpid(), &s) < 0){
   c:	3e0000ef          	jal	3ec <getpid>
  10:	fb040593          	addi	a1,s0,-80
  14:	438000ef          	jal	44c <getvmstats>
  18:	02054e63          	bltz	a0,54 <print_stats+0x54>
        printf("getvmstats failed\n");
        return;
    }

    printf("%s\n", msg);
  1c:	85a6                	mv	a1,s1
  1e:	00001517          	auipc	a0,0x1
  22:	9aa50513          	addi	a0,a0,-1622 # 9c8 <malloc+0x10e>
  26:	7dc000ef          	jal	802 <printf>
    printf("faults=%d evicted=%d in=%d out=%d resident=%d\n",
  2a:	fc042783          	lw	a5,-64(s0)
  2e:	fbc42703          	lw	a4,-68(s0)
  32:	fb842683          	lw	a3,-72(s0)
  36:	fb442603          	lw	a2,-76(s0)
  3a:	fb042583          	lw	a1,-80(s0)
  3e:	00001517          	auipc	a0,0x1
  42:	99250513          	addi	a0,a0,-1646 # 9d0 <malloc+0x116>
  46:	7bc000ef          	jal	802 <printf>
        s.page_faults,
        s.pages_evicted,
        s.pages_swapped_in,
        s.pages_swapped_out,
        s.resident_pages);
}
  4a:	60a6                	ld	ra,72(sp)
  4c:	6406                	ld	s0,64(sp)
  4e:	74e2                	ld	s1,56(sp)
  50:	6161                	addi	sp,sp,80
  52:	8082                	ret
        printf("getvmstats failed\n");
  54:	00001517          	auipc	a0,0x1
  58:	95c50513          	addi	a0,a0,-1700 # 9b0 <malloc+0xf6>
  5c:	7a6000ef          	jal	802 <printf>
        return;
  60:	b7ed                	j	4a <print_stats+0x4a>

0000000000000062 <main>:

int main() {
  62:	1141                	addi	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	addi	s0,sp,16
    print_stats("Before access");
  6a:	00001517          	auipc	a0,0x1
  6e:	99650513          	addi	a0,a0,-1642 # a00 <malloc+0x146>
  72:	f8fff0ef          	jal	0 <print_stats>

    char *p = sbrklazy(5 * 4096);
  76:	6515                	lui	a0,0x5
  78:	2d6000ef          	jal	34e <sbrklazy>

    for(int i = 0; i < 5; i++){
        p[i * 4096] = 'A';
  7c:	04100793          	li	a5,65
  80:	00f50023          	sb	a5,0(a0) # 5000 <base+0x3ff0>
  84:	6705                	lui	a4,0x1
  86:	972a                	add	a4,a4,a0
  88:	00f70023          	sb	a5,0(a4) # 1000 <freep>
  8c:	6709                	lui	a4,0x2
  8e:	972a                	add	a4,a4,a0
  90:	00f70023          	sb	a5,0(a4) # 2000 <base+0xff0>
  94:	670d                	lui	a4,0x3
  96:	972a                	add	a4,a4,a0
  98:	00f70023          	sb	a5,0(a4) # 3000 <base+0x1ff0>
  9c:	6711                	lui	a4,0x4
  9e:	953a                	add	a0,a0,a4
  a0:	00f50023          	sb	a5,0(a0)
    }

    print_stats("After access");
  a4:	00001517          	auipc	a0,0x1
  a8:	96c50513          	addi	a0,a0,-1684 # a10 <malloc+0x156>
  ac:	f55ff0ef          	jal	0 <print_stats>

    exit(0);
  b0:	4501                	li	a0,0
  b2:	2ba000ef          	jal	36c <exit>

00000000000000b6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e406                	sd	ra,8(sp)
  ba:	e022                	sd	s0,0(sp)
  bc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  be:	fa5ff0ef          	jal	62 <main>
  exit(r);
  c2:	2aa000ef          	jal	36c <exit>

00000000000000c6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ce:	87aa                	mv	a5,a0
  d0:	0585                	addi	a1,a1,1
  d2:	0785                	addi	a5,a5,1
  d4:	fff5c703          	lbu	a4,-1(a1)
  d8:	fee78fa3          	sb	a4,-1(a5)
  dc:	fb75                	bnez	a4,d0 <strcpy+0xa>
    ;
  return os;
}
  de:	60a2                	ld	ra,8(sp)
  e0:	6402                	ld	s0,0(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret

00000000000000e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ee:	00054783          	lbu	a5,0(a0)
  f2:	cb91                	beqz	a5,106 <strcmp+0x20>
  f4:	0005c703          	lbu	a4,0(a1)
  f8:	00f71763          	bne	a4,a5,106 <strcmp+0x20>
    p++, q++;
  fc:	0505                	addi	a0,a0,1
  fe:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 100:	00054783          	lbu	a5,0(a0)
 104:	fbe5                	bnez	a5,f4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 106:	0005c503          	lbu	a0,0(a1)
}
 10a:	40a7853b          	subw	a0,a5,a0
 10e:	60a2                	ld	ra,8(sp)
 110:	6402                	ld	s0,0(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret

0000000000000116 <strlen>:

uint
strlen(const char *s)
{
 116:	1141                	addi	sp,sp,-16
 118:	e406                	sd	ra,8(sp)
 11a:	e022                	sd	s0,0(sp)
 11c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 11e:	00054783          	lbu	a5,0(a0)
 122:	cf91                	beqz	a5,13e <strlen+0x28>
 124:	00150793          	addi	a5,a0,1
 128:	86be                	mv	a3,a5
 12a:	0785                	addi	a5,a5,1
 12c:	fff7c703          	lbu	a4,-1(a5)
 130:	ff65                	bnez	a4,128 <strlen+0x12>
 132:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret
  for(n = 0; s[n]; n++)
 13e:	4501                	li	a0,0
 140:	bfdd                	j	136 <strlen+0x20>

0000000000000142 <memset>:

void*
memset(void *dst, int c, uint n)
{
 142:	1141                	addi	sp,sp,-16
 144:	e406                	sd	ra,8(sp)
 146:	e022                	sd	s0,0(sp)
 148:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 14a:	ca19                	beqz	a2,160 <memset+0x1e>
 14c:	87aa                	mv	a5,a0
 14e:	1602                	slli	a2,a2,0x20
 150:	9201                	srli	a2,a2,0x20
 152:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 156:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 15a:	0785                	addi	a5,a5,1
 15c:	fee79de3          	bne	a5,a4,156 <memset+0x14>
  }
  return dst;
}
 160:	60a2                	ld	ra,8(sp)
 162:	6402                	ld	s0,0(sp)
 164:	0141                	addi	sp,sp,16
 166:	8082                	ret

0000000000000168 <strchr>:

char*
strchr(const char *s, char c)
{
 168:	1141                	addi	sp,sp,-16
 16a:	e406                	sd	ra,8(sp)
 16c:	e022                	sd	s0,0(sp)
 16e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 170:	00054783          	lbu	a5,0(a0)
 174:	cf81                	beqz	a5,18c <strchr+0x24>
    if(*s == c)
 176:	00f58763          	beq	a1,a5,184 <strchr+0x1c>
  for(; *s; s++)
 17a:	0505                	addi	a0,a0,1
 17c:	00054783          	lbu	a5,0(a0)
 180:	fbfd                	bnez	a5,176 <strchr+0xe>
      return (char*)s;
  return 0;
 182:	4501                	li	a0,0
}
 184:	60a2                	ld	ra,8(sp)
 186:	6402                	ld	s0,0(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  return 0;
 18c:	4501                	li	a0,0
 18e:	bfdd                	j	184 <strchr+0x1c>

0000000000000190 <gets>:

char*
gets(char *buf, int max)
{
 190:	711d                	addi	sp,sp,-96
 192:	ec86                	sd	ra,88(sp)
 194:	e8a2                	sd	s0,80(sp)
 196:	e4a6                	sd	s1,72(sp)
 198:	e0ca                	sd	s2,64(sp)
 19a:	fc4e                	sd	s3,56(sp)
 19c:	f852                	sd	s4,48(sp)
 19e:	f456                	sd	s5,40(sp)
 1a0:	f05a                	sd	s6,32(sp)
 1a2:	ec5e                	sd	s7,24(sp)
 1a4:	e862                	sd	s8,16(sp)
 1a6:	1080                	addi	s0,sp,96
 1a8:	8baa                	mv	s7,a0
 1aa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ac:	892a                	mv	s2,a0
 1ae:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1b0:	faf40b13          	addi	s6,s0,-81
 1b4:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1b6:	8c26                	mv	s8,s1
 1b8:	0014899b          	addiw	s3,s1,1
 1bc:	84ce                	mv	s1,s3
 1be:	0349d463          	bge	s3,s4,1e6 <gets+0x56>
    cc = read(0, &c, 1);
 1c2:	8656                	mv	a2,s5
 1c4:	85da                	mv	a1,s6
 1c6:	4501                	li	a0,0
 1c8:	1bc000ef          	jal	384 <read>
    if(cc < 1)
 1cc:	00a05d63          	blez	a0,1e6 <gets+0x56>
      break;
    buf[i++] = c;
 1d0:	faf44783          	lbu	a5,-81(s0)
 1d4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1d8:	0905                	addi	s2,s2,1
 1da:	ff678713          	addi	a4,a5,-10
 1de:	c319                	beqz	a4,1e4 <gets+0x54>
 1e0:	17cd                	addi	a5,a5,-13
 1e2:	fbf1                	bnez	a5,1b6 <gets+0x26>
    buf[i++] = c;
 1e4:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1e6:	9c5e                	add	s8,s8,s7
 1e8:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1ec:	855e                	mv	a0,s7
 1ee:	60e6                	ld	ra,88(sp)
 1f0:	6446                	ld	s0,80(sp)
 1f2:	64a6                	ld	s1,72(sp)
 1f4:	6906                	ld	s2,64(sp)
 1f6:	79e2                	ld	s3,56(sp)
 1f8:	7a42                	ld	s4,48(sp)
 1fa:	7aa2                	ld	s5,40(sp)
 1fc:	7b02                	ld	s6,32(sp)
 1fe:	6be2                	ld	s7,24(sp)
 200:	6c42                	ld	s8,16(sp)
 202:	6125                	addi	sp,sp,96
 204:	8082                	ret

0000000000000206 <stat>:

int
stat(const char *n, struct stat *st)
{
 206:	1101                	addi	sp,sp,-32
 208:	ec06                	sd	ra,24(sp)
 20a:	e822                	sd	s0,16(sp)
 20c:	e04a                	sd	s2,0(sp)
 20e:	1000                	addi	s0,sp,32
 210:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 212:	4581                	li	a1,0
 214:	198000ef          	jal	3ac <open>
  if(fd < 0)
 218:	02054263          	bltz	a0,23c <stat+0x36>
 21c:	e426                	sd	s1,8(sp)
 21e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 220:	85ca                	mv	a1,s2
 222:	1a2000ef          	jal	3c4 <fstat>
 226:	892a                	mv	s2,a0
  close(fd);
 228:	8526                	mv	a0,s1
 22a:	16a000ef          	jal	394 <close>
  return r;
 22e:	64a2                	ld	s1,8(sp)
}
 230:	854a                	mv	a0,s2
 232:	60e2                	ld	ra,24(sp)
 234:	6442                	ld	s0,16(sp)
 236:	6902                	ld	s2,0(sp)
 238:	6105                	addi	sp,sp,32
 23a:	8082                	ret
    return -1;
 23c:	57fd                	li	a5,-1
 23e:	893e                	mv	s2,a5
 240:	bfc5                	j	230 <stat+0x2a>

0000000000000242 <atoi>:

int
atoi(const char *s)
{
 242:	1141                	addi	sp,sp,-16
 244:	e406                	sd	ra,8(sp)
 246:	e022                	sd	s0,0(sp)
 248:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24a:	00054683          	lbu	a3,0(a0)
 24e:	fd06879b          	addiw	a5,a3,-48
 252:	0ff7f793          	zext.b	a5,a5
 256:	4625                	li	a2,9
 258:	02f66963          	bltu	a2,a5,28a <atoi+0x48>
 25c:	872a                	mv	a4,a0
  n = 0;
 25e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 260:	0705                	addi	a4,a4,1 # 4001 <base+0x2ff1>
 262:	0025179b          	slliw	a5,a0,0x2
 266:	9fa9                	addw	a5,a5,a0
 268:	0017979b          	slliw	a5,a5,0x1
 26c:	9fb5                	addw	a5,a5,a3
 26e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 272:	00074683          	lbu	a3,0(a4)
 276:	fd06879b          	addiw	a5,a3,-48
 27a:	0ff7f793          	zext.b	a5,a5
 27e:	fef671e3          	bgeu	a2,a5,260 <atoi+0x1e>
  return n;
}
 282:	60a2                	ld	ra,8(sp)
 284:	6402                	ld	s0,0(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret
  n = 0;
 28a:	4501                	li	a0,0
 28c:	bfdd                	j	282 <atoi+0x40>

000000000000028e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 296:	02b57563          	bgeu	a0,a1,2c0 <memmove+0x32>
    while(n-- > 0)
 29a:	00c05f63          	blez	a2,2b8 <memmove+0x2a>
 29e:	1602                	slli	a2,a2,0x20
 2a0:	9201                	srli	a2,a2,0x20
 2a2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2a6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2a8:	0585                	addi	a1,a1,1
 2aa:	0705                	addi	a4,a4,1
 2ac:	fff5c683          	lbu	a3,-1(a1)
 2b0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b4:	fee79ae3          	bne	a5,a4,2a8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret
    while(n-- > 0)
 2c0:	fec05ce3          	blez	a2,2b8 <memmove+0x2a>
    dst += n;
 2c4:	00c50733          	add	a4,a0,a2
    src += n;
 2c8:	95b2                	add	a1,a1,a2
 2ca:	fff6079b          	addiw	a5,a2,-1
 2ce:	1782                	slli	a5,a5,0x20
 2d0:	9381                	srli	a5,a5,0x20
 2d2:	fff7c793          	not	a5,a5
 2d6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2d8:	15fd                	addi	a1,a1,-1
 2da:	177d                	addi	a4,a4,-1
 2dc:	0005c683          	lbu	a3,0(a1)
 2e0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e4:	fef71ae3          	bne	a4,a5,2d8 <memmove+0x4a>
 2e8:	bfc1                	j	2b8 <memmove+0x2a>

00000000000002ea <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f2:	c61d                	beqz	a2,320 <memcmp+0x36>
 2f4:	1602                	slli	a2,a2,0x20
 2f6:	9201                	srli	a2,a2,0x20
 2f8:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2fc:	00054783          	lbu	a5,0(a0)
 300:	0005c703          	lbu	a4,0(a1)
 304:	00e79863          	bne	a5,a4,314 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 308:	0505                	addi	a0,a0,1
    p2++;
 30a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 30c:	fed518e3          	bne	a0,a3,2fc <memcmp+0x12>
  }
  return 0;
 310:	4501                	li	a0,0
 312:	a019                	j	318 <memcmp+0x2e>
      return *p1 - *p2;
 314:	40e7853b          	subw	a0,a5,a4
}
 318:	60a2                	ld	ra,8(sp)
 31a:	6402                	ld	s0,0(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
  return 0;
 320:	4501                	li	a0,0
 322:	bfdd                	j	318 <memcmp+0x2e>

0000000000000324 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 324:	1141                	addi	sp,sp,-16
 326:	e406                	sd	ra,8(sp)
 328:	e022                	sd	s0,0(sp)
 32a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 32c:	f63ff0ef          	jal	28e <memmove>
}
 330:	60a2                	ld	ra,8(sp)
 332:	6402                	ld	s0,0(sp)
 334:	0141                	addi	sp,sp,16
 336:	8082                	ret

0000000000000338 <sbrk>:

char *
sbrk(int n) {
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 340:	4585                	li	a1,1
 342:	0b2000ef          	jal	3f4 <sys_sbrk>
}
 346:	60a2                	ld	ra,8(sp)
 348:	6402                	ld	s0,0(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret

000000000000034e <sbrklazy>:

char *
sbrklazy(int n) {
 34e:	1141                	addi	sp,sp,-16
 350:	e406                	sd	ra,8(sp)
 352:	e022                	sd	s0,0(sp)
 354:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 356:	4589                	li	a1,2
 358:	09c000ef          	jal	3f4 <sys_sbrk>
}
 35c:	60a2                	ld	ra,8(sp)
 35e:	6402                	ld	s0,0(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret

0000000000000364 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 364:	4885                	li	a7,1
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <exit>:
.global exit
exit:
 li a7, SYS_exit
 36c:	4889                	li	a7,2
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <wait>:
.global wait
wait:
 li a7, SYS_wait
 374:	488d                	li	a7,3
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 37c:	4891                	li	a7,4
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <read>:
.global read
read:
 li a7, SYS_read
 384:	4895                	li	a7,5
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <write>:
.global write
write:
 li a7, SYS_write
 38c:	48c1                	li	a7,16
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <close>:
.global close
close:
 li a7, SYS_close
 394:	48d5                	li	a7,21
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <kill>:
.global kill
kill:
 li a7, SYS_kill
 39c:	4899                	li	a7,6
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3a4:	489d                	li	a7,7
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <open>:
.global open
open:
 li a7, SYS_open
 3ac:	48bd                	li	a7,15
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3b4:	48c5                	li	a7,17
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3bc:	48c9                	li	a7,18
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3c4:	48a1                	li	a7,8
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <link>:
.global link
link:
 li a7, SYS_link
 3cc:	48cd                	li	a7,19
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3d4:	48d1                	li	a7,20
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3dc:	48a5                	li	a7,9
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3e4:	48a9                	li	a7,10
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ec:	48ad                	li	a7,11
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3f4:	48b1                	li	a7,12
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <pause>:
.global pause
pause:
 li a7, SYS_pause
 3fc:	48b5                	li	a7,13
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 404:	48b9                	li	a7,14
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <hello>:
.global hello
hello:
 li a7, SYS_hello
 40c:	48d9                	li	a7,22
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 414:	48dd                	li	a7,23
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 41c:	48e1                	li	a7,24
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 424:	48e5                	li	a7,25
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 42c:	48e9                	li	a7,26
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 434:	48ed                	li	a7,27
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 43c:	48f1                	li	a7,28
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 444:	48f5                	li	a7,29
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 44c:	48f9                	li	a7,30
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 454:	48fd                	li	a7,31
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45c:	1101                	addi	sp,sp,-32
 45e:	ec06                	sd	ra,24(sp)
 460:	e822                	sd	s0,16(sp)
 462:	1000                	addi	s0,sp,32
 464:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 468:	4605                	li	a2,1
 46a:	fef40593          	addi	a1,s0,-17
 46e:	f1fff0ef          	jal	38c <write>
}
 472:	60e2                	ld	ra,24(sp)
 474:	6442                	ld	s0,16(sp)
 476:	6105                	addi	sp,sp,32
 478:	8082                	ret

000000000000047a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 47a:	715d                	addi	sp,sp,-80
 47c:	e486                	sd	ra,72(sp)
 47e:	e0a2                	sd	s0,64(sp)
 480:	f84a                	sd	s2,48(sp)
 482:	f44e                	sd	s3,40(sp)
 484:	0880                	addi	s0,sp,80
 486:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 488:	c6d1                	beqz	a3,514 <printint+0x9a>
 48a:	0805d563          	bgez	a1,514 <printint+0x9a>
    neg = 1;
    x = -xx;
 48e:	40b005b3          	neg	a1,a1
    neg = 1;
 492:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 494:	fb840993          	addi	s3,s0,-72
  neg = 0;
 498:	86ce                	mv	a3,s3
  i = 0;
 49a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49c:	00000817          	auipc	a6,0x0
 4a0:	58c80813          	addi	a6,a6,1420 # a28 <digits>
 4a4:	88ba                	mv	a7,a4
 4a6:	0017051b          	addiw	a0,a4,1
 4aa:	872a                	mv	a4,a0
 4ac:	02c5f7b3          	remu	a5,a1,a2
 4b0:	97c2                	add	a5,a5,a6
 4b2:	0007c783          	lbu	a5,0(a5)
 4b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ba:	87ae                	mv	a5,a1
 4bc:	02c5d5b3          	divu	a1,a1,a2
 4c0:	0685                	addi	a3,a3,1
 4c2:	fec7f1e3          	bgeu	a5,a2,4a4 <printint+0x2a>
  if(neg)
 4c6:	00030c63          	beqz	t1,4de <printint+0x64>
    buf[i++] = '-';
 4ca:	fd050793          	addi	a5,a0,-48
 4ce:	00878533          	add	a0,a5,s0
 4d2:	02d00793          	li	a5,45
 4d6:	fef50423          	sb	a5,-24(a0)
 4da:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4de:	02e05563          	blez	a4,508 <printint+0x8e>
 4e2:	fc26                	sd	s1,56(sp)
 4e4:	377d                	addiw	a4,a4,-1
 4e6:	00e984b3          	add	s1,s3,a4
 4ea:	19fd                	addi	s3,s3,-1
 4ec:	99ba                	add	s3,s3,a4
 4ee:	1702                	slli	a4,a4,0x20
 4f0:	9301                	srli	a4,a4,0x20
 4f2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f6:	0004c583          	lbu	a1,0(s1)
 4fa:	854a                	mv	a0,s2
 4fc:	f61ff0ef          	jal	45c <putc>
  while(--i >= 0)
 500:	14fd                	addi	s1,s1,-1
 502:	ff349ae3          	bne	s1,s3,4f6 <printint+0x7c>
 506:	74e2                	ld	s1,56(sp)
}
 508:	60a6                	ld	ra,72(sp)
 50a:	6406                	ld	s0,64(sp)
 50c:	7942                	ld	s2,48(sp)
 50e:	79a2                	ld	s3,40(sp)
 510:	6161                	addi	sp,sp,80
 512:	8082                	ret
  neg = 0;
 514:	4301                	li	t1,0
 516:	bfbd                	j	494 <printint+0x1a>

0000000000000518 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 518:	711d                	addi	sp,sp,-96
 51a:	ec86                	sd	ra,88(sp)
 51c:	e8a2                	sd	s0,80(sp)
 51e:	e4a6                	sd	s1,72(sp)
 520:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 522:	0005c483          	lbu	s1,0(a1)
 526:	22048363          	beqz	s1,74c <vprintf+0x234>
 52a:	e0ca                	sd	s2,64(sp)
 52c:	fc4e                	sd	s3,56(sp)
 52e:	f852                	sd	s4,48(sp)
 530:	f456                	sd	s5,40(sp)
 532:	f05a                	sd	s6,32(sp)
 534:	ec5e                	sd	s7,24(sp)
 536:	e862                	sd	s8,16(sp)
 538:	8b2a                	mv	s6,a0
 53a:	8a2e                	mv	s4,a1
 53c:	8bb2                	mv	s7,a2
  state = 0;
 53e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 540:	4901                	li	s2,0
 542:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 544:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 548:	06400c13          	li	s8,100
 54c:	a00d                	j	56e <vprintf+0x56>
        putc(fd, c0);
 54e:	85a6                	mv	a1,s1
 550:	855a                	mv	a0,s6
 552:	f0bff0ef          	jal	45c <putc>
 556:	a019                	j	55c <vprintf+0x44>
    } else if(state == '%'){
 558:	03598363          	beq	s3,s5,57e <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 55c:	0019079b          	addiw	a5,s2,1
 560:	893e                	mv	s2,a5
 562:	873e                	mv	a4,a5
 564:	97d2                	add	a5,a5,s4
 566:	0007c483          	lbu	s1,0(a5)
 56a:	1c048a63          	beqz	s1,73e <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 56e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 572:	fe0993e3          	bnez	s3,558 <vprintf+0x40>
      if(c0 == '%'){
 576:	fd579ce3          	bne	a5,s5,54e <vprintf+0x36>
        state = '%';
 57a:	89be                	mv	s3,a5
 57c:	b7c5                	j	55c <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 57e:	00ea06b3          	add	a3,s4,a4
 582:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 586:	1c060863          	beqz	a2,756 <vprintf+0x23e>
      if(c0 == 'd'){
 58a:	03878763          	beq	a5,s8,5b8 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 58e:	f9478693          	addi	a3,a5,-108
 592:	0016b693          	seqz	a3,a3
 596:	f9c60593          	addi	a1,a2,-100
 59a:	e99d                	bnez	a1,5d0 <vprintf+0xb8>
 59c:	ca95                	beqz	a3,5d0 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	008b8493          	addi	s1,s7,8
 5a2:	4685                	li	a3,1
 5a4:	4629                	li	a2,10
 5a6:	000bb583          	ld	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	ecfff0ef          	jal	47a <printint>
        i += 1;
 5b0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b2:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	b75d                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5b8:	008b8493          	addi	s1,s7,8
 5bc:	4685                	li	a3,1
 5be:	4629                	li	a2,10
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	eb5ff0ef          	jal	47a <printint>
 5ca:	8ba6                	mv	s7,s1
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b779                	j	55c <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5d0:	9752                	add	a4,a4,s4
 5d2:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d6:	f9460713          	addi	a4,a2,-108
 5da:	00173713          	seqz	a4,a4
 5de:	8f75                	and	a4,a4,a3
 5e0:	f9c58513          	addi	a0,a1,-100
 5e4:	18051363          	bnez	a0,76a <vprintf+0x252>
 5e8:	18070163          	beqz	a4,76a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ec:	008b8493          	addi	s1,s7,8
 5f0:	4685                	li	a3,1
 5f2:	4629                	li	a2,10
 5f4:	000bb583          	ld	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	e81ff0ef          	jal	47a <printint>
        i += 2;
 5fe:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 600:	8ba6                	mv	s7,s1
      state = 0;
 602:	4981                	li	s3,0
        i += 2;
 604:	bfa1                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 606:	008b8493          	addi	s1,s7,8
 60a:	4681                	li	a3,0
 60c:	4629                	li	a2,10
 60e:	000be583          	lwu	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	e67ff0ef          	jal	47a <printint>
 618:	8ba6                	mv	s7,s1
      state = 0;
 61a:	4981                	li	s3,0
 61c:	b781                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61e:	008b8493          	addi	s1,s7,8
 622:	4681                	li	a3,0
 624:	4629                	li	a2,10
 626:	000bb583          	ld	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	e4fff0ef          	jal	47a <printint>
        i += 1;
 630:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
 636:	b71d                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 638:	008b8493          	addi	s1,s7,8
 63c:	4681                	li	a3,0
 63e:	4629                	li	a2,10
 640:	000bb583          	ld	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	e35ff0ef          	jal	47a <printint>
        i += 2;
 64a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 64c:	8ba6                	mv	s7,s1
      state = 0;
 64e:	4981                	li	s3,0
        i += 2;
 650:	b731                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 652:	008b8493          	addi	s1,s7,8
 656:	4681                	li	a3,0
 658:	4641                	li	a2,16
 65a:	000be583          	lwu	a1,0(s7)
 65e:	855a                	mv	a0,s6
 660:	e1bff0ef          	jal	47a <printint>
 664:	8ba6                	mv	s7,s1
      state = 0;
 666:	4981                	li	s3,0
 668:	bdd5                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66a:	008b8493          	addi	s1,s7,8
 66e:	4681                	li	a3,0
 670:	4641                	li	a2,16
 672:	000bb583          	ld	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	e03ff0ef          	jal	47a <printint>
        i += 1;
 67c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 67e:	8ba6                	mv	s7,s1
      state = 0;
 680:	4981                	li	s3,0
 682:	bde9                	j	55c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 684:	008b8493          	addi	s1,s7,8
 688:	4681                	li	a3,0
 68a:	4641                	li	a2,16
 68c:	000bb583          	ld	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	de9ff0ef          	jal	47a <printint>
        i += 2;
 696:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 698:	8ba6                	mv	s7,s1
      state = 0;
 69a:	4981                	li	s3,0
        i += 2;
 69c:	b5c1                	j	55c <vprintf+0x44>
 69e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6a0:	008b8793          	addi	a5,s7,8
 6a4:	8cbe                	mv	s9,a5
 6a6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6aa:	03000593          	li	a1,48
 6ae:	855a                	mv	a0,s6
 6b0:	dadff0ef          	jal	45c <putc>
  putc(fd, 'x');
 6b4:	07800593          	li	a1,120
 6b8:	855a                	mv	a0,s6
 6ba:	da3ff0ef          	jal	45c <putc>
 6be:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c0:	00000b97          	auipc	s7,0x0
 6c4:	368b8b93          	addi	s7,s7,872 # a28 <digits>
 6c8:	03c9d793          	srli	a5,s3,0x3c
 6cc:	97de                	add	a5,a5,s7
 6ce:	0007c583          	lbu	a1,0(a5)
 6d2:	855a                	mv	a0,s6
 6d4:	d89ff0ef          	jal	45c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d8:	0992                	slli	s3,s3,0x4
 6da:	34fd                	addiw	s1,s1,-1
 6dc:	f4f5                	bnez	s1,6c8 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6de:	8be6                	mv	s7,s9
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	6ca2                	ld	s9,8(sp)
 6e4:	bda5                	j	55c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6e6:	008b8493          	addi	s1,s7,8
 6ea:	000bc583          	lbu	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	d6dff0ef          	jal	45c <putc>
 6f4:	8ba6                	mv	s7,s1
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b595                	j	55c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6fa:	008b8993          	addi	s3,s7,8
 6fe:	000bb483          	ld	s1,0(s7)
 702:	cc91                	beqz	s1,71e <vprintf+0x206>
        for(; *s; s++)
 704:	0004c583          	lbu	a1,0(s1)
 708:	c985                	beqz	a1,738 <vprintf+0x220>
          putc(fd, *s);
 70a:	855a                	mv	a0,s6
 70c:	d51ff0ef          	jal	45c <putc>
        for(; *s; s++)
 710:	0485                	addi	s1,s1,1
 712:	0004c583          	lbu	a1,0(s1)
 716:	f9f5                	bnez	a1,70a <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 718:	8bce                	mv	s7,s3
      state = 0;
 71a:	4981                	li	s3,0
 71c:	b581                	j	55c <vprintf+0x44>
          s = "(null)";
 71e:	00000497          	auipc	s1,0x0
 722:	30248493          	addi	s1,s1,770 # a20 <malloc+0x166>
        for(; *s; s++)
 726:	02800593          	li	a1,40
 72a:	b7c5                	j	70a <vprintf+0x1f2>
        putc(fd, '%');
 72c:	85be                	mv	a1,a5
 72e:	855a                	mv	a0,s6
 730:	d2dff0ef          	jal	45c <putc>
      state = 0;
 734:	4981                	li	s3,0
 736:	b51d                	j	55c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 738:	8bce                	mv	s7,s3
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b505                	j	55c <vprintf+0x44>
 73e:	6906                	ld	s2,64(sp)
 740:	79e2                	ld	s3,56(sp)
 742:	7a42                	ld	s4,48(sp)
 744:	7aa2                	ld	s5,40(sp)
 746:	7b02                	ld	s6,32(sp)
 748:	6be2                	ld	s7,24(sp)
 74a:	6c42                	ld	s8,16(sp)
    }
  }
}
 74c:	60e6                	ld	ra,88(sp)
 74e:	6446                	ld	s0,80(sp)
 750:	64a6                	ld	s1,72(sp)
 752:	6125                	addi	sp,sp,96
 754:	8082                	ret
      if(c0 == 'd'){
 756:	06400713          	li	a4,100
 75a:	e4e78fe3          	beq	a5,a4,5b8 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 75e:	f9478693          	addi	a3,a5,-108
 762:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 766:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 768:	4701                	li	a4,0
      } else if(c0 == 'u'){
 76a:	07500513          	li	a0,117
 76e:	e8a78ce3          	beq	a5,a0,606 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 772:	f8b60513          	addi	a0,a2,-117
 776:	e119                	bnez	a0,77c <vprintf+0x264>
 778:	ea0693e3          	bnez	a3,61e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 77c:	f8b58513          	addi	a0,a1,-117
 780:	e119                	bnez	a0,786 <vprintf+0x26e>
 782:	ea071be3          	bnez	a4,638 <vprintf+0x120>
      } else if(c0 == 'x'){
 786:	07800513          	li	a0,120
 78a:	eca784e3          	beq	a5,a0,652 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 78e:	f8860613          	addi	a2,a2,-120
 792:	e219                	bnez	a2,798 <vprintf+0x280>
 794:	ec069be3          	bnez	a3,66a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 798:	f8858593          	addi	a1,a1,-120
 79c:	e199                	bnez	a1,7a2 <vprintf+0x28a>
 79e:	ee0713e3          	bnez	a4,684 <vprintf+0x16c>
      } else if(c0 == 'p'){
 7a2:	07000713          	li	a4,112
 7a6:	eee78ce3          	beq	a5,a4,69e <vprintf+0x186>
      } else if(c0 == 'c'){
 7aa:	06300713          	li	a4,99
 7ae:	f2e78ce3          	beq	a5,a4,6e6 <vprintf+0x1ce>
      } else if(c0 == 's'){
 7b2:	07300713          	li	a4,115
 7b6:	f4e782e3          	beq	a5,a4,6fa <vprintf+0x1e2>
      } else if(c0 == '%'){
 7ba:	02500713          	li	a4,37
 7be:	f6e787e3          	beq	a5,a4,72c <vprintf+0x214>
        putc(fd, '%');
 7c2:	02500593          	li	a1,37
 7c6:	855a                	mv	a0,s6
 7c8:	c95ff0ef          	jal	45c <putc>
        putc(fd, c0);
 7cc:	85a6                	mv	a1,s1
 7ce:	855a                	mv	a0,s6
 7d0:	c8dff0ef          	jal	45c <putc>
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	b359                	j	55c <vprintf+0x44>

00000000000007d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d8:	715d                	addi	sp,sp,-80
 7da:	ec06                	sd	ra,24(sp)
 7dc:	e822                	sd	s0,16(sp)
 7de:	1000                	addi	s0,sp,32
 7e0:	e010                	sd	a2,0(s0)
 7e2:	e414                	sd	a3,8(s0)
 7e4:	e818                	sd	a4,16(s0)
 7e6:	ec1c                	sd	a5,24(s0)
 7e8:	03043023          	sd	a6,32(s0)
 7ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f0:	8622                	mv	a2,s0
 7f2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f6:	d23ff0ef          	jal	518 <vprintf>
}
 7fa:	60e2                	ld	ra,24(sp)
 7fc:	6442                	ld	s0,16(sp)
 7fe:	6161                	addi	sp,sp,80
 800:	8082                	ret

0000000000000802 <printf>:

void
printf(const char *fmt, ...)
{
 802:	711d                	addi	sp,sp,-96
 804:	ec06                	sd	ra,24(sp)
 806:	e822                	sd	s0,16(sp)
 808:	1000                	addi	s0,sp,32
 80a:	e40c                	sd	a1,8(s0)
 80c:	e810                	sd	a2,16(s0)
 80e:	ec14                	sd	a3,24(s0)
 810:	f018                	sd	a4,32(s0)
 812:	f41c                	sd	a5,40(s0)
 814:	03043823          	sd	a6,48(s0)
 818:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 81c:	00840613          	addi	a2,s0,8
 820:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 824:	85aa                	mv	a1,a0
 826:	4505                	li	a0,1
 828:	cf1ff0ef          	jal	518 <vprintf>
}
 82c:	60e2                	ld	ra,24(sp)
 82e:	6442                	ld	s0,16(sp)
 830:	6125                	addi	sp,sp,96
 832:	8082                	ret

0000000000000834 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 834:	1141                	addi	sp,sp,-16
 836:	e406                	sd	ra,8(sp)
 838:	e022                	sd	s0,0(sp)
 83a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 83c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 840:	00000797          	auipc	a5,0x0
 844:	7c07b783          	ld	a5,1984(a5) # 1000 <freep>
 848:	a039                	j	856 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84a:	6398                	ld	a4,0(a5)
 84c:	00e7e463          	bltu	a5,a4,854 <free+0x20>
 850:	00e6ea63          	bltu	a3,a4,864 <free+0x30>
{
 854:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 856:	fed7fae3          	bgeu	a5,a3,84a <free+0x16>
 85a:	6398                	ld	a4,0(a5)
 85c:	00e6e463          	bltu	a3,a4,864 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 860:	fee7eae3          	bltu	a5,a4,854 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 864:	ff852583          	lw	a1,-8(a0)
 868:	6390                	ld	a2,0(a5)
 86a:	02059813          	slli	a6,a1,0x20
 86e:	01c85713          	srli	a4,a6,0x1c
 872:	9736                	add	a4,a4,a3
 874:	02e60563          	beq	a2,a4,89e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 878:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 87c:	4790                	lw	a2,8(a5)
 87e:	02061593          	slli	a1,a2,0x20
 882:	01c5d713          	srli	a4,a1,0x1c
 886:	973e                	add	a4,a4,a5
 888:	02e68263          	beq	a3,a4,8ac <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 88c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 88e:	00000717          	auipc	a4,0x0
 892:	76f73923          	sd	a5,1906(a4) # 1000 <freep>
}
 896:	60a2                	ld	ra,8(sp)
 898:	6402                	ld	s0,0(sp)
 89a:	0141                	addi	sp,sp,16
 89c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 89e:	4618                	lw	a4,8(a2)
 8a0:	9f2d                	addw	a4,a4,a1
 8a2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a6:	6398                	ld	a4,0(a5)
 8a8:	6310                	ld	a2,0(a4)
 8aa:	b7f9                	j	878 <free+0x44>
    p->s.size += bp->s.size;
 8ac:	ff852703          	lw	a4,-8(a0)
 8b0:	9f31                	addw	a4,a4,a2
 8b2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8b4:	ff053683          	ld	a3,-16(a0)
 8b8:	bfd1                	j	88c <free+0x58>

00000000000008ba <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ba:	7139                	addi	sp,sp,-64
 8bc:	fc06                	sd	ra,56(sp)
 8be:	f822                	sd	s0,48(sp)
 8c0:	f04a                	sd	s2,32(sp)
 8c2:	ec4e                	sd	s3,24(sp)
 8c4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c6:	02051993          	slli	s3,a0,0x20
 8ca:	0209d993          	srli	s3,s3,0x20
 8ce:	09bd                	addi	s3,s3,15
 8d0:	0049d993          	srli	s3,s3,0x4
 8d4:	2985                	addiw	s3,s3,1
 8d6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8d8:	00000517          	auipc	a0,0x0
 8dc:	72853503          	ld	a0,1832(a0) # 1000 <freep>
 8e0:	c905                	beqz	a0,910 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e4:	4798                	lw	a4,8(a5)
 8e6:	09377663          	bgeu	a4,s3,972 <malloc+0xb8>
 8ea:	f426                	sd	s1,40(sp)
 8ec:	e852                	sd	s4,16(sp)
 8ee:	e456                	sd	s5,8(sp)
 8f0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8f2:	8a4e                	mv	s4,s3
 8f4:	6705                	lui	a4,0x1
 8f6:	00e9f363          	bgeu	s3,a4,8fc <malloc+0x42>
 8fa:	6a05                	lui	s4,0x1
 8fc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 900:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 904:	00000497          	auipc	s1,0x0
 908:	6fc48493          	addi	s1,s1,1788 # 1000 <freep>
  if(p == SBRK_ERROR)
 90c:	5afd                	li	s5,-1
 90e:	a83d                	j	94c <malloc+0x92>
 910:	f426                	sd	s1,40(sp)
 912:	e852                	sd	s4,16(sp)
 914:	e456                	sd	s5,8(sp)
 916:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 918:	00000797          	auipc	a5,0x0
 91c:	6f878793          	addi	a5,a5,1784 # 1010 <base>
 920:	00000717          	auipc	a4,0x0
 924:	6ef73023          	sd	a5,1760(a4) # 1000 <freep>
 928:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 92e:	b7d1                	j	8f2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 930:	6398                	ld	a4,0(a5)
 932:	e118                	sd	a4,0(a0)
 934:	a899                	j	98a <malloc+0xd0>
  hp->s.size = nu;
 936:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 93a:	0541                	addi	a0,a0,16
 93c:	ef9ff0ef          	jal	834 <free>
  return freep;
 940:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 942:	c125                	beqz	a0,9a2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 944:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 946:	4798                	lw	a4,8(a5)
 948:	03277163          	bgeu	a4,s2,96a <malloc+0xb0>
    if(p == freep)
 94c:	6098                	ld	a4,0(s1)
 94e:	853e                	mv	a0,a5
 950:	fef71ae3          	bne	a4,a5,944 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 954:	8552                	mv	a0,s4
 956:	9e3ff0ef          	jal	338 <sbrk>
  if(p == SBRK_ERROR)
 95a:	fd551ee3          	bne	a0,s5,936 <malloc+0x7c>
        return 0;
 95e:	4501                	li	a0,0
 960:	74a2                	ld	s1,40(sp)
 962:	6a42                	ld	s4,16(sp)
 964:	6aa2                	ld	s5,8(sp)
 966:	6b02                	ld	s6,0(sp)
 968:	a03d                	j	996 <malloc+0xdc>
 96a:	74a2                	ld	s1,40(sp)
 96c:	6a42                	ld	s4,16(sp)
 96e:	6aa2                	ld	s5,8(sp)
 970:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 972:	fae90fe3          	beq	s2,a4,930 <malloc+0x76>
        p->s.size -= nunits;
 976:	4137073b          	subw	a4,a4,s3
 97a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 97c:	02071693          	slli	a3,a4,0x20
 980:	01c6d713          	srli	a4,a3,0x1c
 984:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 986:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 98a:	00000717          	auipc	a4,0x0
 98e:	66a73b23          	sd	a0,1654(a4) # 1000 <freep>
      return (void*)(p + 1);
 992:	01078513          	addi	a0,a5,16
  }
}
 996:	70e2                	ld	ra,56(sp)
 998:	7442                	ld	s0,48(sp)
 99a:	7902                	ld	s2,32(sp)
 99c:	69e2                	ld	s3,24(sp)
 99e:	6121                	addi	sp,sp,64
 9a0:	8082                	ret
 9a2:	74a2                	ld	s1,40(sp)
 9a4:	6a42                	ld	s4,16(sp)
 9a6:	6aa2                	ld	s5,8(sp)
 9a8:	6b02                	ld	s6,0(sp)
 9aa:	b7f5                	j	996 <malloc+0xdc>
