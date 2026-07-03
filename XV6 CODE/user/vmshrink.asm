
user/_vmshrink:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#define PGSIZE 4096

int
main(void)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	0100                	addi	s0,sp,128
  char *s = "vmshrink";
  printf("\n[%s] Starting Heap Contraction & Swap Leak Edge Case...\n", s);
   8:	00001597          	auipc	a1,0x1
   c:	aa858593          	addi	a1,a1,-1368 # ab0 <malloc+0xfa>
  10:	00001517          	auipc	a0,0x1
  14:	ab050513          	addi	a0,a0,-1360 # ac0 <malloc+0x10a>
  18:	0e7000ef          	jal	8fe <printf>
  int npages = 128;
  char *base;
  struct vmstats st1, st2;

  printf("[%s] Allocating and writing to %d pages (forcing swaps)...\n", s, npages);
  1c:	08000613          	li	a2,128
  20:	00001597          	auipc	a1,0x1
  24:	a9058593          	addi	a1,a1,-1392 # ab0 <malloc+0xfa>
  28:	00001517          	auipc	a0,0x1
  2c:	ad850513          	addi	a0,a0,-1320 # b00 <malloc+0x14a>
  30:	0cf000ef          	jal	8fe <printf>
  base = sbrklazy(npages * PGSIZE);
  34:	00080537          	lui	a0,0x80
  38:	412000ef          	jal	44a <sbrklazy>
  if(base == (char*)-1) {
  3c:	57fd                	li	a5,-1
  3e:	06f50363          	beq	a0,a5,a4 <main+0xa4>
  42:	f4a6                	sd	s1,104(sp)
  44:	84aa                	mv	s1,a0
  46:	000807b7          	lui	a5,0x80
  4a:	97aa                	add	a5,a5,a0
    printf("[%s] ERROR: initial sbrklazy failed\n", s);
    exit(1);
  }

  for(int i = 0; i < npages; i++) {
    base[i * PGSIZE] = 'A';
  4c:	04100693          	li	a3,65
  for(int i = 0; i < npages; i++) {
  50:	6705                	lui	a4,0x1
    base[i * PGSIZE] = 'A';
  52:	00d50023          	sb	a3,0(a0) # 80000 <base+0x7eff0>
  for(int i = 0; i < npages; i++) {
  56:	953a                	add	a0,a0,a4
  58:	fef51de3          	bne	a0,a5,52 <main+0x52>
  }

  getvmstats(getpid(), &st1);
  5c:	48c000ef          	jal	4e8 <getpid>
  60:	fb040593          	addi	a1,s0,-80
  64:	4e4000ef          	jal	548 <getvmstats>
  printf("[%s] Phase 1 Stats -> Faults: %d, Swapped Out: %d\n", s, st1.page_faults, st1.pages_swapped_out);
  68:	fbc42683          	lw	a3,-68(s0)
  6c:	fb042603          	lw	a2,-80(s0)
  70:	00001597          	auipc	a1,0x1
  74:	a4058593          	addi	a1,a1,-1472 # ab0 <malloc+0xfa>
  78:	00001517          	auipc	a0,0x1
  7c:	af050513          	addi	a0,a0,-1296 # b68 <malloc+0x1b2>
  80:	07f000ef          	jal	8fe <printf>

  if(st1.pages_swapped_out == 0) {
  84:	fbc42783          	lw	a5,-68(s0)
  88:	ef85                	bnez	a5,c0 <main+0xc0>
    printf("[%s] ERROR: Expected pages to be swapped out!\n", s);
  8a:	00001597          	auipc	a1,0x1
  8e:	a2658593          	addi	a1,a1,-1498 # ab0 <malloc+0xfa>
  92:	00001517          	auipc	a0,0x1
  96:	b0e50513          	addi	a0,a0,-1266 # ba0 <malloc+0x1ea>
  9a:	065000ef          	jal	8fe <printf>
    exit(1);
  9e:	4505                	li	a0,1
  a0:	3c8000ef          	jal	468 <exit>
  a4:	f4a6                	sd	s1,104(sp)
    printf("[%s] ERROR: initial sbrklazy failed\n", s);
  a6:	00001597          	auipc	a1,0x1
  aa:	a0a58593          	addi	a1,a1,-1526 # ab0 <malloc+0xfa>
  ae:	00001517          	auipc	a0,0x1
  b2:	a9250513          	addi	a0,a0,-1390 # b40 <malloc+0x18a>
  b6:	049000ef          	jal	8fe <printf>
    exit(1);
  ba:	4505                	li	a0,1
  bc:	3ac000ef          	jal	468 <exit>
  }

  printf("[%s] Shrinking heap by 20 pages (triggering uvmunmap)...\n", s);
  c0:	00001597          	auipc	a1,0x1
  c4:	9f058593          	addi	a1,a1,-1552 # ab0 <malloc+0xfa>
  c8:	00001517          	auipc	a0,0x1
  cc:	b0850513          	addi	a0,a0,-1272 # bd0 <malloc+0x21a>
  d0:	02f000ef          	jal	8fe <printf>
  if(sbrklazy(-20 * PGSIZE) == (char*)-1) {
  d4:	7531                	lui	a0,0xfffec
  d6:	374000ef          	jal	44a <sbrklazy>
  da:	57fd                	li	a5,-1
  dc:	0af50163          	beq	a0,a5,17e <main+0x17e>
    printf("[%s] ERROR: heap shrink failed\n", s);
    exit(1);
  }

  printf("[%s] Re-growing heap and writing new data...\n", s);
  e0:	00001597          	auipc	a1,0x1
  e4:	9d058593          	addi	a1,a1,-1584 # ab0 <malloc+0xfa>
  e8:	00001517          	auipc	a0,0x1
  ec:	b4850513          	addi	a0,a0,-1208 # c30 <malloc+0x27a>
  f0:	00f000ef          	jal	8fe <printf>
  char *new_base = sbrklazy(20 * PGSIZE);
  f4:	6551                	lui	a0,0x14
  f6:	354000ef          	jal	44a <sbrklazy>
  for(int i = 0; i < 20; i++) {
  fa:	67d1                	lui	a5,0x14
  fc:	97aa                	add	a5,a5,a0
    new_base[i * PGSIZE] = 'B';
  fe:	04200693          	li	a3,66
  for(int i = 0; i < 20; i++) {
 102:	6705                	lui	a4,0x1
    new_base[i * PGSIZE] = 'B';
 104:	00d50023          	sb	a3,0(a0) # 14000 <base+0x12ff0>
  for(int i = 0; i < 20; i++) {
 108:	953a                	add	a0,a0,a4
 10a:	fef51de3          	bne	a0,a5,104 <main+0x104>
  }

  printf("[%s] Verifying integrity of original surviving pages...\n", s);
 10e:	00001597          	auipc	a1,0x1
 112:	9a258593          	addi	a1,a1,-1630 # ab0 <malloc+0xfa>
 116:	00001517          	auipc	a0,0x1
 11a:	b4a50513          	addi	a0,a0,-1206 # c60 <malloc+0x2aa>
 11e:	7e0000ef          	jal	8fe <printf>
  for(int i = 0; i < 20; i++) {
 122:	4601                	li	a2,0
    if(base[i * PGSIZE] != 'A') {
 124:	04100793          	li	a5,65
  for(int i = 0; i < 20; i++) {
 128:	6585                	lui	a1,0x1
 12a:	4751                	li	a4,20
    if(base[i * PGSIZE] != 'A') {
 12c:	0004c683          	lbu	a3,0(s1)
 130:	06f69463          	bne	a3,a5,198 <main+0x198>
  for(int i = 0; i < 20; i++) {
 134:	2605                	addiw	a2,a2,1
 136:	94ae                	add	s1,s1,a1
 138:	fee61ae3          	bne	a2,a4,12c <main+0x12c>
      printf("[%s] ERROR: Data corrupted at page index %d (got %c)\n", s, i, base[i * PGSIZE]);
      exit(1);
    }
  }

  getvmstats(getpid(), &st2);
 13c:	3ac000ef          	jal	4e8 <getpid>
 140:	f8040593          	addi	a1,s0,-128
 144:	404000ef          	jal	548 <getvmstats>
  printf("[%s] Final Stats -> Faults: %d, Swapped Out: %d\n", s, st2.page_faults, st2.pages_swapped_out);
 148:	f8c42683          	lw	a3,-116(s0)
 14c:	f8042603          	lw	a2,-128(s0)
 150:	00001597          	auipc	a1,0x1
 154:	96058593          	addi	a1,a1,-1696 # ab0 <malloc+0xfa>
 158:	00001517          	auipc	a0,0x1
 15c:	b8050513          	addi	a0,a0,-1152 # cd8 <malloc+0x322>
 160:	79e000ef          	jal	8fe <printf>

  printf("[%s] SUCCESS: No kernel panics, swap slots and frames correctly reclaimed on shrink.\n", s);
 164:	00001597          	auipc	a1,0x1
 168:	94c58593          	addi	a1,a1,-1716 # ab0 <malloc+0xfa>
 16c:	00001517          	auipc	a0,0x1
 170:	ba450513          	addi	a0,a0,-1116 # d10 <malloc+0x35a>
 174:	78a000ef          	jal	8fe <printf>
  exit(0);
 178:	4501                	li	a0,0
 17a:	2ee000ef          	jal	468 <exit>
    printf("[%s] ERROR: heap shrink failed\n", s);
 17e:	00001597          	auipc	a1,0x1
 182:	93258593          	addi	a1,a1,-1742 # ab0 <malloc+0xfa>
 186:	00001517          	auipc	a0,0x1
 18a:	a8a50513          	addi	a0,a0,-1398 # c10 <malloc+0x25a>
 18e:	770000ef          	jal	8fe <printf>
    exit(1);
 192:	4505                	li	a0,1
 194:	2d4000ef          	jal	468 <exit>
      printf("[%s] ERROR: Data corrupted at page index %d (got %c)\n", s, i, base[i * PGSIZE]);
 198:	00001597          	auipc	a1,0x1
 19c:	91858593          	addi	a1,a1,-1768 # ab0 <malloc+0xfa>
 1a0:	00001517          	auipc	a0,0x1
 1a4:	b0050513          	addi	a0,a0,-1280 # ca0 <malloc+0x2ea>
 1a8:	756000ef          	jal	8fe <printf>
      exit(1);
 1ac:	4505                	li	a0,1
 1ae:	2ba000ef          	jal	468 <exit>

00000000000001b2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e406                	sd	ra,8(sp)
 1b6:	e022                	sd	s0,0(sp)
 1b8:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 1ba:	e47ff0ef          	jal	0 <main>
  exit(r);
 1be:	2aa000ef          	jal	468 <exit>

00000000000001c2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e406                	sd	ra,8(sp)
 1c6:	e022                	sd	s0,0(sp)
 1c8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ca:	87aa                	mv	a5,a0
 1cc:	0585                	addi	a1,a1,1
 1ce:	0785                	addi	a5,a5,1 # 14001 <base+0x12ff1>
 1d0:	fff5c703          	lbu	a4,-1(a1)
 1d4:	fee78fa3          	sb	a4,-1(a5)
 1d8:	fb75                	bnez	a4,1cc <strcpy+0xa>
    ;
  return os;
}
 1da:	60a2                	ld	ra,8(sp)
 1dc:	6402                	ld	s0,0(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret

00000000000001e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e406                	sd	ra,8(sp)
 1e6:	e022                	sd	s0,0(sp)
 1e8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1ea:	00054783          	lbu	a5,0(a0)
 1ee:	cb91                	beqz	a5,202 <strcmp+0x20>
 1f0:	0005c703          	lbu	a4,0(a1)
 1f4:	00f71763          	bne	a4,a5,202 <strcmp+0x20>
    p++, q++;
 1f8:	0505                	addi	a0,a0,1
 1fa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1fc:	00054783          	lbu	a5,0(a0)
 200:	fbe5                	bnez	a5,1f0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 202:	0005c503          	lbu	a0,0(a1)
}
 206:	40a7853b          	subw	a0,a5,a0
 20a:	60a2                	ld	ra,8(sp)
 20c:	6402                	ld	s0,0(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret

0000000000000212 <strlen>:

uint
strlen(const char *s)
{
 212:	1141                	addi	sp,sp,-16
 214:	e406                	sd	ra,8(sp)
 216:	e022                	sd	s0,0(sp)
 218:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 21a:	00054783          	lbu	a5,0(a0)
 21e:	cf91                	beqz	a5,23a <strlen+0x28>
 220:	00150793          	addi	a5,a0,1
 224:	86be                	mv	a3,a5
 226:	0785                	addi	a5,a5,1
 228:	fff7c703          	lbu	a4,-1(a5)
 22c:	ff65                	bnez	a4,224 <strlen+0x12>
 22e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 232:	60a2                	ld	ra,8(sp)
 234:	6402                	ld	s0,0(sp)
 236:	0141                	addi	sp,sp,16
 238:	8082                	ret
  for(n = 0; s[n]; n++)
 23a:	4501                	li	a0,0
 23c:	bfdd                	j	232 <strlen+0x20>

000000000000023e <memset>:

void*
memset(void *dst, int c, uint n)
{
 23e:	1141                	addi	sp,sp,-16
 240:	e406                	sd	ra,8(sp)
 242:	e022                	sd	s0,0(sp)
 244:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 246:	ca19                	beqz	a2,25c <memset+0x1e>
 248:	87aa                	mv	a5,a0
 24a:	1602                	slli	a2,a2,0x20
 24c:	9201                	srli	a2,a2,0x20
 24e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 252:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 256:	0785                	addi	a5,a5,1
 258:	fee79de3          	bne	a5,a4,252 <memset+0x14>
  }
  return dst;
}
 25c:	60a2                	ld	ra,8(sp)
 25e:	6402                	ld	s0,0(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret

0000000000000264 <strchr>:

char*
strchr(const char *s, char c)
{
 264:	1141                	addi	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 26c:	00054783          	lbu	a5,0(a0)
 270:	cf81                	beqz	a5,288 <strchr+0x24>
    if(*s == c)
 272:	00f58763          	beq	a1,a5,280 <strchr+0x1c>
  for(; *s; s++)
 276:	0505                	addi	a0,a0,1
 278:	00054783          	lbu	a5,0(a0)
 27c:	fbfd                	bnez	a5,272 <strchr+0xe>
      return (char*)s;
  return 0;
 27e:	4501                	li	a0,0
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret
  return 0;
 288:	4501                	li	a0,0
 28a:	bfdd                	j	280 <strchr+0x1c>

000000000000028c <gets>:

char*
gets(char *buf, int max)
{
 28c:	711d                	addi	sp,sp,-96
 28e:	ec86                	sd	ra,88(sp)
 290:	e8a2                	sd	s0,80(sp)
 292:	e4a6                	sd	s1,72(sp)
 294:	e0ca                	sd	s2,64(sp)
 296:	fc4e                	sd	s3,56(sp)
 298:	f852                	sd	s4,48(sp)
 29a:	f456                	sd	s5,40(sp)
 29c:	f05a                	sd	s6,32(sp)
 29e:	ec5e                	sd	s7,24(sp)
 2a0:	e862                	sd	s8,16(sp)
 2a2:	1080                	addi	s0,sp,96
 2a4:	8baa                	mv	s7,a0
 2a6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a8:	892a                	mv	s2,a0
 2aa:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2ac:	faf40b13          	addi	s6,s0,-81
 2b0:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 2b2:	8c26                	mv	s8,s1
 2b4:	0014899b          	addiw	s3,s1,1
 2b8:	84ce                	mv	s1,s3
 2ba:	0349d463          	bge	s3,s4,2e2 <gets+0x56>
    cc = read(0, &c, 1);
 2be:	8656                	mv	a2,s5
 2c0:	85da                	mv	a1,s6
 2c2:	4501                	li	a0,0
 2c4:	1bc000ef          	jal	480 <read>
    if(cc < 1)
 2c8:	00a05d63          	blez	a0,2e2 <gets+0x56>
      break;
    buf[i++] = c;
 2cc:	faf44783          	lbu	a5,-81(s0)
 2d0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2d4:	0905                	addi	s2,s2,1
 2d6:	ff678713          	addi	a4,a5,-10
 2da:	c319                	beqz	a4,2e0 <gets+0x54>
 2dc:	17cd                	addi	a5,a5,-13
 2de:	fbf1                	bnez	a5,2b2 <gets+0x26>
    buf[i++] = c;
 2e0:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 2e2:	9c5e                	add	s8,s8,s7
 2e4:	000c0023          	sb	zero,0(s8)
  return buf;
}
 2e8:	855e                	mv	a0,s7
 2ea:	60e6                	ld	ra,88(sp)
 2ec:	6446                	ld	s0,80(sp)
 2ee:	64a6                	ld	s1,72(sp)
 2f0:	6906                	ld	s2,64(sp)
 2f2:	79e2                	ld	s3,56(sp)
 2f4:	7a42                	ld	s4,48(sp)
 2f6:	7aa2                	ld	s5,40(sp)
 2f8:	7b02                	ld	s6,32(sp)
 2fa:	6be2                	ld	s7,24(sp)
 2fc:	6c42                	ld	s8,16(sp)
 2fe:	6125                	addi	sp,sp,96
 300:	8082                	ret

0000000000000302 <stat>:

int
stat(const char *n, struct stat *st)
{
 302:	1101                	addi	sp,sp,-32
 304:	ec06                	sd	ra,24(sp)
 306:	e822                	sd	s0,16(sp)
 308:	e04a                	sd	s2,0(sp)
 30a:	1000                	addi	s0,sp,32
 30c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 30e:	4581                	li	a1,0
 310:	198000ef          	jal	4a8 <open>
  if(fd < 0)
 314:	02054263          	bltz	a0,338 <stat+0x36>
 318:	e426                	sd	s1,8(sp)
 31a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 31c:	85ca                	mv	a1,s2
 31e:	1a2000ef          	jal	4c0 <fstat>
 322:	892a                	mv	s2,a0
  close(fd);
 324:	8526                	mv	a0,s1
 326:	16a000ef          	jal	490 <close>
  return r;
 32a:	64a2                	ld	s1,8(sp)
}
 32c:	854a                	mv	a0,s2
 32e:	60e2                	ld	ra,24(sp)
 330:	6442                	ld	s0,16(sp)
 332:	6902                	ld	s2,0(sp)
 334:	6105                	addi	sp,sp,32
 336:	8082                	ret
    return -1;
 338:	57fd                	li	a5,-1
 33a:	893e                	mv	s2,a5
 33c:	bfc5                	j	32c <stat+0x2a>

000000000000033e <atoi>:

int
atoi(const char *s)
{
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 346:	00054683          	lbu	a3,0(a0)
 34a:	fd06879b          	addiw	a5,a3,-48
 34e:	0ff7f793          	zext.b	a5,a5
 352:	4625                	li	a2,9
 354:	02f66963          	bltu	a2,a5,386 <atoi+0x48>
 358:	872a                	mv	a4,a0
  n = 0;
 35a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 35c:	0705                	addi	a4,a4,1 # 1001 <freep+0x1>
 35e:	0025179b          	slliw	a5,a0,0x2
 362:	9fa9                	addw	a5,a5,a0
 364:	0017979b          	slliw	a5,a5,0x1
 368:	9fb5                	addw	a5,a5,a3
 36a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 36e:	00074683          	lbu	a3,0(a4)
 372:	fd06879b          	addiw	a5,a3,-48
 376:	0ff7f793          	zext.b	a5,a5
 37a:	fef671e3          	bgeu	a2,a5,35c <atoi+0x1e>
  return n;
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret
  n = 0;
 386:	4501                	li	a0,0
 388:	bfdd                	j	37e <atoi+0x40>

000000000000038a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 38a:	1141                	addi	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 392:	02b57563          	bgeu	a0,a1,3bc <memmove+0x32>
    while(n-- > 0)
 396:	00c05f63          	blez	a2,3b4 <memmove+0x2a>
 39a:	1602                	slli	a2,a2,0x20
 39c:	9201                	srli	a2,a2,0x20
 39e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3a2:	872a                	mv	a4,a0
      *dst++ = *src++;
 3a4:	0585                	addi	a1,a1,1
 3a6:	0705                	addi	a4,a4,1
 3a8:	fff5c683          	lbu	a3,-1(a1)
 3ac:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3b0:	fee79ae3          	bne	a5,a4,3a4 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3b4:	60a2                	ld	ra,8(sp)
 3b6:	6402                	ld	s0,0(sp)
 3b8:	0141                	addi	sp,sp,16
 3ba:	8082                	ret
    while(n-- > 0)
 3bc:	fec05ce3          	blez	a2,3b4 <memmove+0x2a>
    dst += n;
 3c0:	00c50733          	add	a4,a0,a2
    src += n;
 3c4:	95b2                	add	a1,a1,a2
 3c6:	fff6079b          	addiw	a5,a2,-1
 3ca:	1782                	slli	a5,a5,0x20
 3cc:	9381                	srli	a5,a5,0x20
 3ce:	fff7c793          	not	a5,a5
 3d2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3d4:	15fd                	addi	a1,a1,-1
 3d6:	177d                	addi	a4,a4,-1
 3d8:	0005c683          	lbu	a3,0(a1)
 3dc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3e0:	fef71ae3          	bne	a4,a5,3d4 <memmove+0x4a>
 3e4:	bfc1                	j	3b4 <memmove+0x2a>

00000000000003e6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3e6:	1141                	addi	sp,sp,-16
 3e8:	e406                	sd	ra,8(sp)
 3ea:	e022                	sd	s0,0(sp)
 3ec:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3ee:	c61d                	beqz	a2,41c <memcmp+0x36>
 3f0:	1602                	slli	a2,a2,0x20
 3f2:	9201                	srli	a2,a2,0x20
 3f4:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3f8:	00054783          	lbu	a5,0(a0)
 3fc:	0005c703          	lbu	a4,0(a1)
 400:	00e79863          	bne	a5,a4,410 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 404:	0505                	addi	a0,a0,1
    p2++;
 406:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 408:	fed518e3          	bne	a0,a3,3f8 <memcmp+0x12>
  }
  return 0;
 40c:	4501                	li	a0,0
 40e:	a019                	j	414 <memcmp+0x2e>
      return *p1 - *p2;
 410:	40e7853b          	subw	a0,a5,a4
}
 414:	60a2                	ld	ra,8(sp)
 416:	6402                	ld	s0,0(sp)
 418:	0141                	addi	sp,sp,16
 41a:	8082                	ret
  return 0;
 41c:	4501                	li	a0,0
 41e:	bfdd                	j	414 <memcmp+0x2e>

0000000000000420 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 420:	1141                	addi	sp,sp,-16
 422:	e406                	sd	ra,8(sp)
 424:	e022                	sd	s0,0(sp)
 426:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 428:	f63ff0ef          	jal	38a <memmove>
}
 42c:	60a2                	ld	ra,8(sp)
 42e:	6402                	ld	s0,0(sp)
 430:	0141                	addi	sp,sp,16
 432:	8082                	ret

0000000000000434 <sbrk>:

char *
sbrk(int n) {
 434:	1141                	addi	sp,sp,-16
 436:	e406                	sd	ra,8(sp)
 438:	e022                	sd	s0,0(sp)
 43a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 43c:	4585                	li	a1,1
 43e:	0b2000ef          	jal	4f0 <sys_sbrk>
}
 442:	60a2                	ld	ra,8(sp)
 444:	6402                	ld	s0,0(sp)
 446:	0141                	addi	sp,sp,16
 448:	8082                	ret

000000000000044a <sbrklazy>:

char *
sbrklazy(int n) {
 44a:	1141                	addi	sp,sp,-16
 44c:	e406                	sd	ra,8(sp)
 44e:	e022                	sd	s0,0(sp)
 450:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 452:	4589                	li	a1,2
 454:	09c000ef          	jal	4f0 <sys_sbrk>
}
 458:	60a2                	ld	ra,8(sp)
 45a:	6402                	ld	s0,0(sp)
 45c:	0141                	addi	sp,sp,16
 45e:	8082                	ret

0000000000000460 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 460:	4885                	li	a7,1
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <exit>:
.global exit
exit:
 li a7, SYS_exit
 468:	4889                	li	a7,2
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <wait>:
.global wait
wait:
 li a7, SYS_wait
 470:	488d                	li	a7,3
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 478:	4891                	li	a7,4
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <read>:
.global read
read:
 li a7, SYS_read
 480:	4895                	li	a7,5
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <write>:
.global write
write:
 li a7, SYS_write
 488:	48c1                	li	a7,16
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <close>:
.global close
close:
 li a7, SYS_close
 490:	48d5                	li	a7,21
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <kill>:
.global kill
kill:
 li a7, SYS_kill
 498:	4899                	li	a7,6
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a0:	489d                	li	a7,7
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <open>:
.global open
open:
 li a7, SYS_open
 4a8:	48bd                	li	a7,15
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b0:	48c5                	li	a7,17
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4b8:	48c9                	li	a7,18
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c0:	48a1                	li	a7,8
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <link>:
.global link
link:
 li a7, SYS_link
 4c8:	48cd                	li	a7,19
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d0:	48d1                	li	a7,20
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4d8:	48a5                	li	a7,9
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e0:	48a9                	li	a7,10
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4e8:	48ad                	li	a7,11
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4f0:	48b1                	li	a7,12
 ecall
 4f2:	00000073          	ecall
 ret
 4f6:	8082                	ret

00000000000004f8 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4f8:	48b5                	li	a7,13
 ecall
 4fa:	00000073          	ecall
 ret
 4fe:	8082                	ret

0000000000000500 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 500:	48b9                	li	a7,14
 ecall
 502:	00000073          	ecall
 ret
 506:	8082                	ret

0000000000000508 <hello>:
.global hello
hello:
 li a7, SYS_hello
 508:	48d9                	li	a7,22
 ecall
 50a:	00000073          	ecall
 ret
 50e:	8082                	ret

0000000000000510 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 510:	48dd                	li	a7,23
 ecall
 512:	00000073          	ecall
 ret
 516:	8082                	ret

0000000000000518 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 518:	48e1                	li	a7,24
 ecall
 51a:	00000073          	ecall
 ret
 51e:	8082                	ret

0000000000000520 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 520:	48e5                	li	a7,25
 ecall
 522:	00000073          	ecall
 ret
 526:	8082                	ret

0000000000000528 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 528:	48e9                	li	a7,26
 ecall
 52a:	00000073          	ecall
 ret
 52e:	8082                	ret

0000000000000530 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 530:	48ed                	li	a7,27
 ecall
 532:	00000073          	ecall
 ret
 536:	8082                	ret

0000000000000538 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 538:	48f1                	li	a7,28
 ecall
 53a:	00000073          	ecall
 ret
 53e:	8082                	ret

0000000000000540 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 540:	48f5                	li	a7,29
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 548:	48f9                	li	a7,30
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 550:	48fd                	li	a7,31
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 558:	1101                	addi	sp,sp,-32
 55a:	ec06                	sd	ra,24(sp)
 55c:	e822                	sd	s0,16(sp)
 55e:	1000                	addi	s0,sp,32
 560:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 564:	4605                	li	a2,1
 566:	fef40593          	addi	a1,s0,-17
 56a:	f1fff0ef          	jal	488 <write>
}
 56e:	60e2                	ld	ra,24(sp)
 570:	6442                	ld	s0,16(sp)
 572:	6105                	addi	sp,sp,32
 574:	8082                	ret

0000000000000576 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 576:	715d                	addi	sp,sp,-80
 578:	e486                	sd	ra,72(sp)
 57a:	e0a2                	sd	s0,64(sp)
 57c:	f84a                	sd	s2,48(sp)
 57e:	f44e                	sd	s3,40(sp)
 580:	0880                	addi	s0,sp,80
 582:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 584:	c6d1                	beqz	a3,610 <printint+0x9a>
 586:	0805d563          	bgez	a1,610 <printint+0x9a>
    neg = 1;
    x = -xx;
 58a:	40b005b3          	neg	a1,a1
    neg = 1;
 58e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 590:	fb840993          	addi	s3,s0,-72
  neg = 0;
 594:	86ce                	mv	a3,s3
  i = 0;
 596:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 598:	00000817          	auipc	a6,0x0
 59c:	7d880813          	addi	a6,a6,2008 # d70 <digits>
 5a0:	88ba                	mv	a7,a4
 5a2:	0017051b          	addiw	a0,a4,1
 5a6:	872a                	mv	a4,a0
 5a8:	02c5f7b3          	remu	a5,a1,a2
 5ac:	97c2                	add	a5,a5,a6
 5ae:	0007c783          	lbu	a5,0(a5)
 5b2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b6:	87ae                	mv	a5,a1
 5b8:	02c5d5b3          	divu	a1,a1,a2
 5bc:	0685                	addi	a3,a3,1
 5be:	fec7f1e3          	bgeu	a5,a2,5a0 <printint+0x2a>
  if(neg)
 5c2:	00030c63          	beqz	t1,5da <printint+0x64>
    buf[i++] = '-';
 5c6:	fd050793          	addi	a5,a0,-48
 5ca:	00878533          	add	a0,a5,s0
 5ce:	02d00793          	li	a5,45
 5d2:	fef50423          	sb	a5,-24(a0)
 5d6:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 5da:	02e05563          	blez	a4,604 <printint+0x8e>
 5de:	fc26                	sd	s1,56(sp)
 5e0:	377d                	addiw	a4,a4,-1
 5e2:	00e984b3          	add	s1,s3,a4
 5e6:	19fd                	addi	s3,s3,-1
 5e8:	99ba                	add	s3,s3,a4
 5ea:	1702                	slli	a4,a4,0x20
 5ec:	9301                	srli	a4,a4,0x20
 5ee:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5f2:	0004c583          	lbu	a1,0(s1)
 5f6:	854a                	mv	a0,s2
 5f8:	f61ff0ef          	jal	558 <putc>
  while(--i >= 0)
 5fc:	14fd                	addi	s1,s1,-1
 5fe:	ff349ae3          	bne	s1,s3,5f2 <printint+0x7c>
 602:	74e2                	ld	s1,56(sp)
}
 604:	60a6                	ld	ra,72(sp)
 606:	6406                	ld	s0,64(sp)
 608:	7942                	ld	s2,48(sp)
 60a:	79a2                	ld	s3,40(sp)
 60c:	6161                	addi	sp,sp,80
 60e:	8082                	ret
  neg = 0;
 610:	4301                	li	t1,0
 612:	bfbd                	j	590 <printint+0x1a>

0000000000000614 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 614:	711d                	addi	sp,sp,-96
 616:	ec86                	sd	ra,88(sp)
 618:	e8a2                	sd	s0,80(sp)
 61a:	e4a6                	sd	s1,72(sp)
 61c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 61e:	0005c483          	lbu	s1,0(a1)
 622:	22048363          	beqz	s1,848 <vprintf+0x234>
 626:	e0ca                	sd	s2,64(sp)
 628:	fc4e                	sd	s3,56(sp)
 62a:	f852                	sd	s4,48(sp)
 62c:	f456                	sd	s5,40(sp)
 62e:	f05a                	sd	s6,32(sp)
 630:	ec5e                	sd	s7,24(sp)
 632:	e862                	sd	s8,16(sp)
 634:	8b2a                	mv	s6,a0
 636:	8a2e                	mv	s4,a1
 638:	8bb2                	mv	s7,a2
  state = 0;
 63a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 63c:	4901                	li	s2,0
 63e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 640:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 644:	06400c13          	li	s8,100
 648:	a00d                	j	66a <vprintf+0x56>
        putc(fd, c0);
 64a:	85a6                	mv	a1,s1
 64c:	855a                	mv	a0,s6
 64e:	f0bff0ef          	jal	558 <putc>
 652:	a019                	j	658 <vprintf+0x44>
    } else if(state == '%'){
 654:	03598363          	beq	s3,s5,67a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 658:	0019079b          	addiw	a5,s2,1
 65c:	893e                	mv	s2,a5
 65e:	873e                	mv	a4,a5
 660:	97d2                	add	a5,a5,s4
 662:	0007c483          	lbu	s1,0(a5)
 666:	1c048a63          	beqz	s1,83a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 66a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 66e:	fe0993e3          	bnez	s3,654 <vprintf+0x40>
      if(c0 == '%'){
 672:	fd579ce3          	bne	a5,s5,64a <vprintf+0x36>
        state = '%';
 676:	89be                	mv	s3,a5
 678:	b7c5                	j	658 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 67a:	00ea06b3          	add	a3,s4,a4
 67e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 682:	1c060863          	beqz	a2,852 <vprintf+0x23e>
      if(c0 == 'd'){
 686:	03878763          	beq	a5,s8,6b4 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 68a:	f9478693          	addi	a3,a5,-108
 68e:	0016b693          	seqz	a3,a3
 692:	f9c60593          	addi	a1,a2,-100
 696:	e99d                	bnez	a1,6cc <vprintf+0xb8>
 698:	ca95                	beqz	a3,6cc <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 69a:	008b8493          	addi	s1,s7,8
 69e:	4685                	li	a3,1
 6a0:	4629                	li	a2,10
 6a2:	000bb583          	ld	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	ecfff0ef          	jal	576 <printint>
        i += 1;
 6ac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ae:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b75d                	j	658 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 6b4:	008b8493          	addi	s1,s7,8
 6b8:	4685                	li	a3,1
 6ba:	4629                	li	a2,10
 6bc:	000ba583          	lw	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	eb5ff0ef          	jal	576 <printint>
 6c6:	8ba6                	mv	s7,s1
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b779                	j	658 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 6cc:	9752                	add	a4,a4,s4
 6ce:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6d2:	f9460713          	addi	a4,a2,-108
 6d6:	00173713          	seqz	a4,a4
 6da:	8f75                	and	a4,a4,a3
 6dc:	f9c58513          	addi	a0,a1,-100
 6e0:	18051363          	bnez	a0,866 <vprintf+0x252>
 6e4:	18070163          	beqz	a4,866 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e8:	008b8493          	addi	s1,s7,8
 6ec:	4685                	li	a3,1
 6ee:	4629                	li	a2,10
 6f0:	000bb583          	ld	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	e81ff0ef          	jal	576 <printint>
        i += 2;
 6fa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fc:	8ba6                	mv	s7,s1
      state = 0;
 6fe:	4981                	li	s3,0
        i += 2;
 700:	bfa1                	j	658 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 702:	008b8493          	addi	s1,s7,8
 706:	4681                	li	a3,0
 708:	4629                	li	a2,10
 70a:	000be583          	lwu	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	e67ff0ef          	jal	576 <printint>
 714:	8ba6                	mv	s7,s1
      state = 0;
 716:	4981                	li	s3,0
 718:	b781                	j	658 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71a:	008b8493          	addi	s1,s7,8
 71e:	4681                	li	a3,0
 720:	4629                	li	a2,10
 722:	000bb583          	ld	a1,0(s7)
 726:	855a                	mv	a0,s6
 728:	e4fff0ef          	jal	576 <printint>
        i += 1;
 72c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 72e:	8ba6                	mv	s7,s1
      state = 0;
 730:	4981                	li	s3,0
 732:	b71d                	j	658 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	008b8493          	addi	s1,s7,8
 738:	4681                	li	a3,0
 73a:	4629                	li	a2,10
 73c:	000bb583          	ld	a1,0(s7)
 740:	855a                	mv	a0,s6
 742:	e35ff0ef          	jal	576 <printint>
        i += 2;
 746:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 748:	8ba6                	mv	s7,s1
      state = 0;
 74a:	4981                	li	s3,0
        i += 2;
 74c:	b731                	j	658 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 74e:	008b8493          	addi	s1,s7,8
 752:	4681                	li	a3,0
 754:	4641                	li	a2,16
 756:	000be583          	lwu	a1,0(s7)
 75a:	855a                	mv	a0,s6
 75c:	e1bff0ef          	jal	576 <printint>
 760:	8ba6                	mv	s7,s1
      state = 0;
 762:	4981                	li	s3,0
 764:	bdd5                	j	658 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 766:	008b8493          	addi	s1,s7,8
 76a:	4681                	li	a3,0
 76c:	4641                	li	a2,16
 76e:	000bb583          	ld	a1,0(s7)
 772:	855a                	mv	a0,s6
 774:	e03ff0ef          	jal	576 <printint>
        i += 1;
 778:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 77a:	8ba6                	mv	s7,s1
      state = 0;
 77c:	4981                	li	s3,0
 77e:	bde9                	j	658 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 780:	008b8493          	addi	s1,s7,8
 784:	4681                	li	a3,0
 786:	4641                	li	a2,16
 788:	000bb583          	ld	a1,0(s7)
 78c:	855a                	mv	a0,s6
 78e:	de9ff0ef          	jal	576 <printint>
        i += 2;
 792:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 794:	8ba6                	mv	s7,s1
      state = 0;
 796:	4981                	li	s3,0
        i += 2;
 798:	b5c1                	j	658 <vprintf+0x44>
 79a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 79c:	008b8793          	addi	a5,s7,8
 7a0:	8cbe                	mv	s9,a5
 7a2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7a6:	03000593          	li	a1,48
 7aa:	855a                	mv	a0,s6
 7ac:	dadff0ef          	jal	558 <putc>
  putc(fd, 'x');
 7b0:	07800593          	li	a1,120
 7b4:	855a                	mv	a0,s6
 7b6:	da3ff0ef          	jal	558 <putc>
 7ba:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7bc:	00000b97          	auipc	s7,0x0
 7c0:	5b4b8b93          	addi	s7,s7,1460 # d70 <digits>
 7c4:	03c9d793          	srli	a5,s3,0x3c
 7c8:	97de                	add	a5,a5,s7
 7ca:	0007c583          	lbu	a1,0(a5)
 7ce:	855a                	mv	a0,s6
 7d0:	d89ff0ef          	jal	558 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d4:	0992                	slli	s3,s3,0x4
 7d6:	34fd                	addiw	s1,s1,-1
 7d8:	f4f5                	bnez	s1,7c4 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 7da:	8be6                	mv	s7,s9
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	6ca2                	ld	s9,8(sp)
 7e0:	bda5                	j	658 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 7e2:	008b8493          	addi	s1,s7,8
 7e6:	000bc583          	lbu	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	d6dff0ef          	jal	558 <putc>
 7f0:	8ba6                	mv	s7,s1
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	b595                	j	658 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 7f6:	008b8993          	addi	s3,s7,8
 7fa:	000bb483          	ld	s1,0(s7)
 7fe:	cc91                	beqz	s1,81a <vprintf+0x206>
        for(; *s; s++)
 800:	0004c583          	lbu	a1,0(s1)
 804:	c985                	beqz	a1,834 <vprintf+0x220>
          putc(fd, *s);
 806:	855a                	mv	a0,s6
 808:	d51ff0ef          	jal	558 <putc>
        for(; *s; s++)
 80c:	0485                	addi	s1,s1,1
 80e:	0004c583          	lbu	a1,0(s1)
 812:	f9f5                	bnez	a1,806 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 814:	8bce                	mv	s7,s3
      state = 0;
 816:	4981                	li	s3,0
 818:	b581                	j	658 <vprintf+0x44>
          s = "(null)";
 81a:	00000497          	auipc	s1,0x0
 81e:	54e48493          	addi	s1,s1,1358 # d68 <malloc+0x3b2>
        for(; *s; s++)
 822:	02800593          	li	a1,40
 826:	b7c5                	j	806 <vprintf+0x1f2>
        putc(fd, '%');
 828:	85be                	mv	a1,a5
 82a:	855a                	mv	a0,s6
 82c:	d2dff0ef          	jal	558 <putc>
      state = 0;
 830:	4981                	li	s3,0
 832:	b51d                	j	658 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 834:	8bce                	mv	s7,s3
      state = 0;
 836:	4981                	li	s3,0
 838:	b505                	j	658 <vprintf+0x44>
 83a:	6906                	ld	s2,64(sp)
 83c:	79e2                	ld	s3,56(sp)
 83e:	7a42                	ld	s4,48(sp)
 840:	7aa2                	ld	s5,40(sp)
 842:	7b02                	ld	s6,32(sp)
 844:	6be2                	ld	s7,24(sp)
 846:	6c42                	ld	s8,16(sp)
    }
  }
}
 848:	60e6                	ld	ra,88(sp)
 84a:	6446                	ld	s0,80(sp)
 84c:	64a6                	ld	s1,72(sp)
 84e:	6125                	addi	sp,sp,96
 850:	8082                	ret
      if(c0 == 'd'){
 852:	06400713          	li	a4,100
 856:	e4e78fe3          	beq	a5,a4,6b4 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 85a:	f9478693          	addi	a3,a5,-108
 85e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 862:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 864:	4701                	li	a4,0
      } else if(c0 == 'u'){
 866:	07500513          	li	a0,117
 86a:	e8a78ce3          	beq	a5,a0,702 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 86e:	f8b60513          	addi	a0,a2,-117
 872:	e119                	bnez	a0,878 <vprintf+0x264>
 874:	ea0693e3          	bnez	a3,71a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 878:	f8b58513          	addi	a0,a1,-117
 87c:	e119                	bnez	a0,882 <vprintf+0x26e>
 87e:	ea071be3          	bnez	a4,734 <vprintf+0x120>
      } else if(c0 == 'x'){
 882:	07800513          	li	a0,120
 886:	eca784e3          	beq	a5,a0,74e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 88a:	f8860613          	addi	a2,a2,-120
 88e:	e219                	bnez	a2,894 <vprintf+0x280>
 890:	ec069be3          	bnez	a3,766 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 894:	f8858593          	addi	a1,a1,-120
 898:	e199                	bnez	a1,89e <vprintf+0x28a>
 89a:	ee0713e3          	bnez	a4,780 <vprintf+0x16c>
      } else if(c0 == 'p'){
 89e:	07000713          	li	a4,112
 8a2:	eee78ce3          	beq	a5,a4,79a <vprintf+0x186>
      } else if(c0 == 'c'){
 8a6:	06300713          	li	a4,99
 8aa:	f2e78ce3          	beq	a5,a4,7e2 <vprintf+0x1ce>
      } else if(c0 == 's'){
 8ae:	07300713          	li	a4,115
 8b2:	f4e782e3          	beq	a5,a4,7f6 <vprintf+0x1e2>
      } else if(c0 == '%'){
 8b6:	02500713          	li	a4,37
 8ba:	f6e787e3          	beq	a5,a4,828 <vprintf+0x214>
        putc(fd, '%');
 8be:	02500593          	li	a1,37
 8c2:	855a                	mv	a0,s6
 8c4:	c95ff0ef          	jal	558 <putc>
        putc(fd, c0);
 8c8:	85a6                	mv	a1,s1
 8ca:	855a                	mv	a0,s6
 8cc:	c8dff0ef          	jal	558 <putc>
      state = 0;
 8d0:	4981                	li	s3,0
 8d2:	b359                	j	658 <vprintf+0x44>

00000000000008d4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d4:	715d                	addi	sp,sp,-80
 8d6:	ec06                	sd	ra,24(sp)
 8d8:	e822                	sd	s0,16(sp)
 8da:	1000                	addi	s0,sp,32
 8dc:	e010                	sd	a2,0(s0)
 8de:	e414                	sd	a3,8(s0)
 8e0:	e818                	sd	a4,16(s0)
 8e2:	ec1c                	sd	a5,24(s0)
 8e4:	03043023          	sd	a6,32(s0)
 8e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ec:	8622                	mv	a2,s0
 8ee:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f2:	d23ff0ef          	jal	614 <vprintf>
}
 8f6:	60e2                	ld	ra,24(sp)
 8f8:	6442                	ld	s0,16(sp)
 8fa:	6161                	addi	sp,sp,80
 8fc:	8082                	ret

00000000000008fe <printf>:

void
printf(const char *fmt, ...)
{
 8fe:	711d                	addi	sp,sp,-96
 900:	ec06                	sd	ra,24(sp)
 902:	e822                	sd	s0,16(sp)
 904:	1000                	addi	s0,sp,32
 906:	e40c                	sd	a1,8(s0)
 908:	e810                	sd	a2,16(s0)
 90a:	ec14                	sd	a3,24(s0)
 90c:	f018                	sd	a4,32(s0)
 90e:	f41c                	sd	a5,40(s0)
 910:	03043823          	sd	a6,48(s0)
 914:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 918:	00840613          	addi	a2,s0,8
 91c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 920:	85aa                	mv	a1,a0
 922:	4505                	li	a0,1
 924:	cf1ff0ef          	jal	614 <vprintf>
}
 928:	60e2                	ld	ra,24(sp)
 92a:	6442                	ld	s0,16(sp)
 92c:	6125                	addi	sp,sp,96
 92e:	8082                	ret

0000000000000930 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 930:	1141                	addi	sp,sp,-16
 932:	e406                	sd	ra,8(sp)
 934:	e022                	sd	s0,0(sp)
 936:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 938:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93c:	00000797          	auipc	a5,0x0
 940:	6c47b783          	ld	a5,1732(a5) # 1000 <freep>
 944:	a039                	j	952 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 946:	6398                	ld	a4,0(a5)
 948:	00e7e463          	bltu	a5,a4,950 <free+0x20>
 94c:	00e6ea63          	bltu	a3,a4,960 <free+0x30>
{
 950:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 952:	fed7fae3          	bgeu	a5,a3,946 <free+0x16>
 956:	6398                	ld	a4,0(a5)
 958:	00e6e463          	bltu	a3,a4,960 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95c:	fee7eae3          	bltu	a5,a4,950 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 960:	ff852583          	lw	a1,-8(a0)
 964:	6390                	ld	a2,0(a5)
 966:	02059813          	slli	a6,a1,0x20
 96a:	01c85713          	srli	a4,a6,0x1c
 96e:	9736                	add	a4,a4,a3
 970:	02e60563          	beq	a2,a4,99a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 974:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 978:	4790                	lw	a2,8(a5)
 97a:	02061593          	slli	a1,a2,0x20
 97e:	01c5d713          	srli	a4,a1,0x1c
 982:	973e                	add	a4,a4,a5
 984:	02e68263          	beq	a3,a4,9a8 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 988:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 98a:	00000717          	auipc	a4,0x0
 98e:	66f73b23          	sd	a5,1654(a4) # 1000 <freep>
}
 992:	60a2                	ld	ra,8(sp)
 994:	6402                	ld	s0,0(sp)
 996:	0141                	addi	sp,sp,16
 998:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 99a:	4618                	lw	a4,8(a2)
 99c:	9f2d                	addw	a4,a4,a1
 99e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9a2:	6398                	ld	a4,0(a5)
 9a4:	6310                	ld	a2,0(a4)
 9a6:	b7f9                	j	974 <free+0x44>
    p->s.size += bp->s.size;
 9a8:	ff852703          	lw	a4,-8(a0)
 9ac:	9f31                	addw	a4,a4,a2
 9ae:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9b0:	ff053683          	ld	a3,-16(a0)
 9b4:	bfd1                	j	988 <free+0x58>

00000000000009b6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9b6:	7139                	addi	sp,sp,-64
 9b8:	fc06                	sd	ra,56(sp)
 9ba:	f822                	sd	s0,48(sp)
 9bc:	f04a                	sd	s2,32(sp)
 9be:	ec4e                	sd	s3,24(sp)
 9c0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c2:	02051993          	slli	s3,a0,0x20
 9c6:	0209d993          	srli	s3,s3,0x20
 9ca:	09bd                	addi	s3,s3,15
 9cc:	0049d993          	srli	s3,s3,0x4
 9d0:	2985                	addiw	s3,s3,1
 9d2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9d4:	00000517          	auipc	a0,0x0
 9d8:	62c53503          	ld	a0,1580(a0) # 1000 <freep>
 9dc:	c905                	beqz	a0,a0c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e0:	4798                	lw	a4,8(a5)
 9e2:	09377663          	bgeu	a4,s3,a6e <malloc+0xb8>
 9e6:	f426                	sd	s1,40(sp)
 9e8:	e852                	sd	s4,16(sp)
 9ea:	e456                	sd	s5,8(sp)
 9ec:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9ee:	8a4e                	mv	s4,s3
 9f0:	6705                	lui	a4,0x1
 9f2:	00e9f363          	bgeu	s3,a4,9f8 <malloc+0x42>
 9f6:	6a05                	lui	s4,0x1
 9f8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9fc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a00:	00000497          	auipc	s1,0x0
 a04:	60048493          	addi	s1,s1,1536 # 1000 <freep>
  if(p == SBRK_ERROR)
 a08:	5afd                	li	s5,-1
 a0a:	a83d                	j	a48 <malloc+0x92>
 a0c:	f426                	sd	s1,40(sp)
 a0e:	e852                	sd	s4,16(sp)
 a10:	e456                	sd	s5,8(sp)
 a12:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a14:	00000797          	auipc	a5,0x0
 a18:	5fc78793          	addi	a5,a5,1532 # 1010 <base>
 a1c:	00000717          	auipc	a4,0x0
 a20:	5ef73223          	sd	a5,1508(a4) # 1000 <freep>
 a24:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a26:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a2a:	b7d1                	j	9ee <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a2c:	6398                	ld	a4,0(a5)
 a2e:	e118                	sd	a4,0(a0)
 a30:	a899                	j	a86 <malloc+0xd0>
  hp->s.size = nu;
 a32:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a36:	0541                	addi	a0,a0,16
 a38:	ef9ff0ef          	jal	930 <free>
  return freep;
 a3c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a3e:	c125                	beqz	a0,a9e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a40:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a42:	4798                	lw	a4,8(a5)
 a44:	03277163          	bgeu	a4,s2,a66 <malloc+0xb0>
    if(p == freep)
 a48:	6098                	ld	a4,0(s1)
 a4a:	853e                	mv	a0,a5
 a4c:	fef71ae3          	bne	a4,a5,a40 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a50:	8552                	mv	a0,s4
 a52:	9e3ff0ef          	jal	434 <sbrk>
  if(p == SBRK_ERROR)
 a56:	fd551ee3          	bne	a0,s5,a32 <malloc+0x7c>
        return 0;
 a5a:	4501                	li	a0,0
 a5c:	74a2                	ld	s1,40(sp)
 a5e:	6a42                	ld	s4,16(sp)
 a60:	6aa2                	ld	s5,8(sp)
 a62:	6b02                	ld	s6,0(sp)
 a64:	a03d                	j	a92 <malloc+0xdc>
 a66:	74a2                	ld	s1,40(sp)
 a68:	6a42                	ld	s4,16(sp)
 a6a:	6aa2                	ld	s5,8(sp)
 a6c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a6e:	fae90fe3          	beq	s2,a4,a2c <malloc+0x76>
        p->s.size -= nunits;
 a72:	4137073b          	subw	a4,a4,s3
 a76:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a78:	02071693          	slli	a3,a4,0x20
 a7c:	01c6d713          	srli	a4,a3,0x1c
 a80:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a82:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a86:	00000717          	auipc	a4,0x0
 a8a:	56a73d23          	sd	a0,1402(a4) # 1000 <freep>
      return (void*)(p + 1);
 a8e:	01078513          	addi	a0,a5,16
  }
}
 a92:	70e2                	ld	ra,56(sp)
 a94:	7442                	ld	s0,48(sp)
 a96:	7902                	ld	s2,32(sp)
 a98:	69e2                	ld	s3,24(sp)
 a9a:	6121                	addi	sp,sp,64
 a9c:	8082                	ret
 a9e:	74a2                	ld	s1,40(sp)
 aa0:	6a42                	ld	s4,16(sp)
 aa2:	6aa2                	ld	s5,8(sp)
 aa4:	6b02                	ld	s6,0(sp)
 aa6:	b7f5                	j	a92 <malloc+0xdc>
