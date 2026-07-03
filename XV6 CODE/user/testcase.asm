
user/_testcase:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#define PAGE_SIZE 4096
#define NUM_PAGES 64   // > MAX_FRAMES (32) → guarantees eviction

int
main(void)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	0100                	addi	s0,sp,128
  printf("=== testcase: basic swap write check ===\n");
   8:	00001517          	auipc	a0,0x1
   c:	a0850513          	addi	a0,a0,-1528 # a10 <malloc+0xf2>
  10:	057000ef          	jal	866 <printf>

  struct vmstats before, after;
  getvmstats(getpid(), &before);
  14:	43c000ef          	jal	450 <getpid>
  18:	fb040593          	addi	a1,s0,-80
  1c:	494000ef          	jal	4b0 <getvmstats>

  // Allocate enough pages to force eviction
  char *base = sbrk(NUM_PAGES * PAGE_SIZE);
  20:	00040537          	lui	a0,0x40
  24:	378000ef          	jal	39c <sbrk>
  if(base == (char*)-1){
  28:	55fd                	li	a1,-1
  2a:	872a                	mv	a4,a0
    printf("FAIL: sbrk failed\n");
    exit(1);
  }

  // Write to each page (forces them to be populated)
  for(int i = 0; i < NUM_PAGES; i++){
  2c:	4781                	li	a5,0
  2e:	6605                	lui	a2,0x1
  30:	04000693          	li	a3,64
  if(base == (char*)-1){
  34:	0ab50a63          	beq	a0,a1,e8 <main+0xe8>
  38:	f4a6                	sd	s1,104(sp)
  3a:	f0ca                	sd	s2,96(sp)
    base[i * PAGE_SIZE] = (char)i;
  3c:	00f70023          	sb	a5,0(a4)
  for(int i = 0; i < NUM_PAGES; i++){
  40:	2785                	addiw	a5,a5,1
  42:	9732                	add	a4,a4,a2
  44:	fed79ce3          	bne	a5,a3,3c <main+0x3c>
  }

  // Extra pressure to force eviction
  char *p = sbrk(80 * PAGE_SIZE);
  48:	00050537          	lui	a0,0x50
  4c:	350000ef          	jal	39c <sbrk>
  if(p != (char*)-1){
  50:	57fd                	li	a5,-1
  52:	02f50063          	beq	a0,a5,72 <main+0x72>
    for(int i = 0; i < 80; i++){
  56:	4781                	li	a5,0
  58:	6685                	lui	a3,0x1
  5a:	05000713          	li	a4,80
      p[i * PAGE_SIZE] = (char)i;
  5e:	00f50023          	sb	a5,0(a0) # 50000 <base+0x4eff0>
    for(int i = 0; i < 80; i++){
  62:	2785                	addiw	a5,a5,1
  64:	9536                	add	a0,a0,a3
  66:	fee79ce3          	bne	a5,a4,5e <main+0x5e>
    }
    sbrk(-(80 * PAGE_SIZE));
  6a:	fffb0537          	lui	a0,0xfffb0
  6e:	32e000ef          	jal	39c <sbrk>
  }

  getvmstats(getpid(), &after);
  72:	3de000ef          	jal	450 <getpid>
  76:	f8040593          	addi	a1,s0,-128
  7a:	436000ef          	jal	4b0 <getvmstats>

  uint64 writes = after.disk_writes - before.disk_writes;
  7e:	fa043903          	ld	s2,-96(s0)
  82:	fd043783          	ld	a5,-48(s0)
  86:	40f90933          	sub	s2,s2,a5
  uint64 reads  = after.disk_reads  - before.disk_reads;
  8a:	f9843483          	ld	s1,-104(s0)
  8e:	fc843783          	ld	a5,-56(s0)
  92:	8c9d                	sub	s1,s1,a5

  printf("writes delta = %lu\n", writes);
  94:	85ca                	mv	a1,s2
  96:	00001517          	auipc	a0,0x1
  9a:	9c250513          	addi	a0,a0,-1598 # a58 <malloc+0x13a>
  9e:	7c8000ef          	jal	866 <printf>
  printf("reads  delta = %lu\n", reads);
  a2:	85a6                	mv	a1,s1
  a4:	00001517          	auipc	a0,0x1
  a8:	9cc50513          	addi	a0,a0,-1588 # a70 <malloc+0x152>
  ac:	7ba000ef          	jal	866 <printf>

  if(writes > 0)
  b0:	04090763          	beqz	s2,fe <main+0xfe>
    printf("PASS: eviction caused disk writes\n");
  b4:	00001517          	auipc	a0,0x1
  b8:	9d450513          	addi	a0,a0,-1580 # a88 <malloc+0x16a>
  bc:	7aa000ef          	jal	866 <printf>
  else
    printf("FAIL: NO disk writes (swap_write not triggered)\n");

  if(reads > 0)
  c0:	c4b1                	beqz	s1,10c <main+0x10c>
    printf("PASS: swap-in caused disk reads\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	a2650513          	addi	a0,a0,-1498 # ae8 <malloc+0x1ca>
  ca:	79c000ef          	jal	866 <printf>
  else
    printf("NOTE: reads may be zero if pages not re-accessed\n");

  sbrk(-(NUM_PAGES * PAGE_SIZE));
  ce:	fffc0537          	lui	a0,0xfffc0
  d2:	2ca000ef          	jal	39c <sbrk>

  printf("=== testcase done ===\n");
  d6:	00001517          	auipc	a0,0x1
  da:	a7250513          	addi	a0,a0,-1422 # b48 <malloc+0x22a>
  de:	788000ef          	jal	866 <printf>
  exit(0);
  e2:	4501                	li	a0,0
  e4:	2ec000ef          	jal	3d0 <exit>
  e8:	f4a6                	sd	s1,104(sp)
  ea:	f0ca                	sd	s2,96(sp)
    printf("FAIL: sbrk failed\n");
  ec:	00001517          	auipc	a0,0x1
  f0:	95450513          	addi	a0,a0,-1708 # a40 <malloc+0x122>
  f4:	772000ef          	jal	866 <printf>
    exit(1);
  f8:	4505                	li	a0,1
  fa:	2d6000ef          	jal	3d0 <exit>
    printf("FAIL: NO disk writes (swap_write not triggered)\n");
  fe:	00001517          	auipc	a0,0x1
 102:	9b250513          	addi	a0,a0,-1614 # ab0 <malloc+0x192>
 106:	760000ef          	jal	866 <printf>
 10a:	bf5d                	j	c0 <main+0xc0>
    printf("NOTE: reads may be zero if pages not re-accessed\n");
 10c:	00001517          	auipc	a0,0x1
 110:	a0450513          	addi	a0,a0,-1532 # b10 <malloc+0x1f2>
 114:	752000ef          	jal	866 <printf>
 118:	bf5d                	j	ce <main+0xce>

000000000000011a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e406                	sd	ra,8(sp)
 11e:	e022                	sd	s0,0(sp)
 120:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 122:	edfff0ef          	jal	0 <main>
  exit(r);
 126:	2aa000ef          	jal	3d0 <exit>

000000000000012a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e406                	sd	ra,8(sp)
 12e:	e022                	sd	s0,0(sp)
 130:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 132:	87aa                	mv	a5,a0
 134:	0585                	addi	a1,a1,1
 136:	0785                	addi	a5,a5,1
 138:	fff5c703          	lbu	a4,-1(a1)
 13c:	fee78fa3          	sb	a4,-1(a5)
 140:	fb75                	bnez	a4,134 <strcpy+0xa>
    ;
  return os;
}
 142:	60a2                	ld	ra,8(sp)
 144:	6402                	ld	s0,0(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret

000000000000014a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	cb91                	beqz	a5,16a <strcmp+0x20>
 158:	0005c703          	lbu	a4,0(a1)
 15c:	00f71763          	bne	a4,a5,16a <strcmp+0x20>
    p++, q++;
 160:	0505                	addi	a0,a0,1
 162:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 164:	00054783          	lbu	a5,0(a0)
 168:	fbe5                	bnez	a5,158 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 16a:	0005c503          	lbu	a0,0(a1)
}
 16e:	40a7853b          	subw	a0,a5,a0
 172:	60a2                	ld	ra,8(sp)
 174:	6402                	ld	s0,0(sp)
 176:	0141                	addi	sp,sp,16
 178:	8082                	ret

000000000000017a <strlen>:

uint
strlen(const char *s)
{
 17a:	1141                	addi	sp,sp,-16
 17c:	e406                	sd	ra,8(sp)
 17e:	e022                	sd	s0,0(sp)
 180:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 182:	00054783          	lbu	a5,0(a0)
 186:	cf91                	beqz	a5,1a2 <strlen+0x28>
 188:	00150793          	addi	a5,a0,1
 18c:	86be                	mv	a3,a5
 18e:	0785                	addi	a5,a5,1
 190:	fff7c703          	lbu	a4,-1(a5)
 194:	ff65                	bnez	a4,18c <strlen+0x12>
 196:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 19a:	60a2                	ld	ra,8(sp)
 19c:	6402                	ld	s0,0(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret
  for(n = 0; s[n]; n++)
 1a2:	4501                	li	a0,0
 1a4:	bfdd                	j	19a <strlen+0x20>

00000000000001a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a6:	1141                	addi	sp,sp,-16
 1a8:	e406                	sd	ra,8(sp)
 1aa:	e022                	sd	s0,0(sp)
 1ac:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1ae:	ca19                	beqz	a2,1c4 <memset+0x1e>
 1b0:	87aa                	mv	a5,a0
 1b2:	1602                	slli	a2,a2,0x20
 1b4:	9201                	srli	a2,a2,0x20
 1b6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1ba:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1be:	0785                	addi	a5,a5,1
 1c0:	fee79de3          	bne	a5,a4,1ba <memset+0x14>
  }
  return dst;
}
 1c4:	60a2                	ld	ra,8(sp)
 1c6:	6402                	ld	s0,0(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <strchr>:

char*
strchr(const char *s, char c)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e406                	sd	ra,8(sp)
 1d0:	e022                	sd	s0,0(sp)
 1d2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	cf81                	beqz	a5,1f0 <strchr+0x24>
    if(*s == c)
 1da:	00f58763          	beq	a1,a5,1e8 <strchr+0x1c>
  for(; *s; s++)
 1de:	0505                	addi	a0,a0,1
 1e0:	00054783          	lbu	a5,0(a0)
 1e4:	fbfd                	bnez	a5,1da <strchr+0xe>
      return (char*)s;
  return 0;
 1e6:	4501                	li	a0,0
}
 1e8:	60a2                	ld	ra,8(sp)
 1ea:	6402                	ld	s0,0(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret
  return 0;
 1f0:	4501                	li	a0,0
 1f2:	bfdd                	j	1e8 <strchr+0x1c>

00000000000001f4 <gets>:

char*
gets(char *buf, int max)
{
 1f4:	711d                	addi	sp,sp,-96
 1f6:	ec86                	sd	ra,88(sp)
 1f8:	e8a2                	sd	s0,80(sp)
 1fa:	e4a6                	sd	s1,72(sp)
 1fc:	e0ca                	sd	s2,64(sp)
 1fe:	fc4e                	sd	s3,56(sp)
 200:	f852                	sd	s4,48(sp)
 202:	f456                	sd	s5,40(sp)
 204:	f05a                	sd	s6,32(sp)
 206:	ec5e                	sd	s7,24(sp)
 208:	e862                	sd	s8,16(sp)
 20a:	1080                	addi	s0,sp,96
 20c:	8baa                	mv	s7,a0
 20e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	892a                	mv	s2,a0
 212:	4481                	li	s1,0
    cc = read(0, &c, 1);
 214:	faf40b13          	addi	s6,s0,-81
 218:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 21a:	8c26                	mv	s8,s1
 21c:	0014899b          	addiw	s3,s1,1
 220:	84ce                	mv	s1,s3
 222:	0349d463          	bge	s3,s4,24a <gets+0x56>
    cc = read(0, &c, 1);
 226:	8656                	mv	a2,s5
 228:	85da                	mv	a1,s6
 22a:	4501                	li	a0,0
 22c:	1bc000ef          	jal	3e8 <read>
    if(cc < 1)
 230:	00a05d63          	blez	a0,24a <gets+0x56>
      break;
    buf[i++] = c;
 234:	faf44783          	lbu	a5,-81(s0)
 238:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 23c:	0905                	addi	s2,s2,1
 23e:	ff678713          	addi	a4,a5,-10
 242:	c319                	beqz	a4,248 <gets+0x54>
 244:	17cd                	addi	a5,a5,-13
 246:	fbf1                	bnez	a5,21a <gets+0x26>
    buf[i++] = c;
 248:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 24a:	9c5e                	add	s8,s8,s7
 24c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 250:	855e                	mv	a0,s7
 252:	60e6                	ld	ra,88(sp)
 254:	6446                	ld	s0,80(sp)
 256:	64a6                	ld	s1,72(sp)
 258:	6906                	ld	s2,64(sp)
 25a:	79e2                	ld	s3,56(sp)
 25c:	7a42                	ld	s4,48(sp)
 25e:	7aa2                	ld	s5,40(sp)
 260:	7b02                	ld	s6,32(sp)
 262:	6be2                	ld	s7,24(sp)
 264:	6c42                	ld	s8,16(sp)
 266:	6125                	addi	sp,sp,96
 268:	8082                	ret

000000000000026a <stat>:

int
stat(const char *n, struct stat *st)
{
 26a:	1101                	addi	sp,sp,-32
 26c:	ec06                	sd	ra,24(sp)
 26e:	e822                	sd	s0,16(sp)
 270:	e04a                	sd	s2,0(sp)
 272:	1000                	addi	s0,sp,32
 274:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 276:	4581                	li	a1,0
 278:	198000ef          	jal	410 <open>
  if(fd < 0)
 27c:	02054263          	bltz	a0,2a0 <stat+0x36>
 280:	e426                	sd	s1,8(sp)
 282:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 284:	85ca                	mv	a1,s2
 286:	1a2000ef          	jal	428 <fstat>
 28a:	892a                	mv	s2,a0
  close(fd);
 28c:	8526                	mv	a0,s1
 28e:	16a000ef          	jal	3f8 <close>
  return r;
 292:	64a2                	ld	s1,8(sp)
}
 294:	854a                	mv	a0,s2
 296:	60e2                	ld	ra,24(sp)
 298:	6442                	ld	s0,16(sp)
 29a:	6902                	ld	s2,0(sp)
 29c:	6105                	addi	sp,sp,32
 29e:	8082                	ret
    return -1;
 2a0:	57fd                	li	a5,-1
 2a2:	893e                	mv	s2,a5
 2a4:	bfc5                	j	294 <stat+0x2a>

00000000000002a6 <atoi>:

int
atoi(const char *s)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e406                	sd	ra,8(sp)
 2aa:	e022                	sd	s0,0(sp)
 2ac:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2ae:	00054683          	lbu	a3,0(a0)
 2b2:	fd06879b          	addiw	a5,a3,-48 # fd0 <digits+0x468>
 2b6:	0ff7f793          	zext.b	a5,a5
 2ba:	4625                	li	a2,9
 2bc:	02f66963          	bltu	a2,a5,2ee <atoi+0x48>
 2c0:	872a                	mv	a4,a0
  n = 0;
 2c2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2c4:	0705                	addi	a4,a4,1
 2c6:	0025179b          	slliw	a5,a0,0x2
 2ca:	9fa9                	addw	a5,a5,a0
 2cc:	0017979b          	slliw	a5,a5,0x1
 2d0:	9fb5                	addw	a5,a5,a3
 2d2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d6:	00074683          	lbu	a3,0(a4)
 2da:	fd06879b          	addiw	a5,a3,-48
 2de:	0ff7f793          	zext.b	a5,a5
 2e2:	fef671e3          	bgeu	a2,a5,2c4 <atoi+0x1e>
  return n;
}
 2e6:	60a2                	ld	ra,8(sp)
 2e8:	6402                	ld	s0,0(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
  n = 0;
 2ee:	4501                	li	a0,0
 2f0:	bfdd                	j	2e6 <atoi+0x40>

00000000000002f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2fa:	02b57563          	bgeu	a0,a1,324 <memmove+0x32>
    while(n-- > 0)
 2fe:	00c05f63          	blez	a2,31c <memmove+0x2a>
 302:	1602                	slli	a2,a2,0x20
 304:	9201                	srli	a2,a2,0x20
 306:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 30a:	872a                	mv	a4,a0
      *dst++ = *src++;
 30c:	0585                	addi	a1,a1,1
 30e:	0705                	addi	a4,a4,1
 310:	fff5c683          	lbu	a3,-1(a1)
 314:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 318:	fee79ae3          	bne	a5,a4,30c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret
    while(n-- > 0)
 324:	fec05ce3          	blez	a2,31c <memmove+0x2a>
    dst += n;
 328:	00c50733          	add	a4,a0,a2
    src += n;
 32c:	95b2                	add	a1,a1,a2
 32e:	fff6079b          	addiw	a5,a2,-1 # fff <digits+0x497>
 332:	1782                	slli	a5,a5,0x20
 334:	9381                	srli	a5,a5,0x20
 336:	fff7c793          	not	a5,a5
 33a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 33c:	15fd                	addi	a1,a1,-1
 33e:	177d                	addi	a4,a4,-1
 340:	0005c683          	lbu	a3,0(a1)
 344:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 348:	fef71ae3          	bne	a4,a5,33c <memmove+0x4a>
 34c:	bfc1                	j	31c <memmove+0x2a>

000000000000034e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34e:	1141                	addi	sp,sp,-16
 350:	e406                	sd	ra,8(sp)
 352:	e022                	sd	s0,0(sp)
 354:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 356:	c61d                	beqz	a2,384 <memcmp+0x36>
 358:	1602                	slli	a2,a2,0x20
 35a:	9201                	srli	a2,a2,0x20
 35c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 360:	00054783          	lbu	a5,0(a0)
 364:	0005c703          	lbu	a4,0(a1)
 368:	00e79863          	bne	a5,a4,378 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 36c:	0505                	addi	a0,a0,1
    p2++;
 36e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 370:	fed518e3          	bne	a0,a3,360 <memcmp+0x12>
  }
  return 0;
 374:	4501                	li	a0,0
 376:	a019                	j	37c <memcmp+0x2e>
      return *p1 - *p2;
 378:	40e7853b          	subw	a0,a5,a4
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret
  return 0;
 384:	4501                	li	a0,0
 386:	bfdd                	j	37c <memcmp+0x2e>

0000000000000388 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e406                	sd	ra,8(sp)
 38c:	e022                	sd	s0,0(sp)
 38e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 390:	f63ff0ef          	jal	2f2 <memmove>
}
 394:	60a2                	ld	ra,8(sp)
 396:	6402                	ld	s0,0(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret

000000000000039c <sbrk>:

char *
sbrk(int n) {
 39c:	1141                	addi	sp,sp,-16
 39e:	e406                	sd	ra,8(sp)
 3a0:	e022                	sd	s0,0(sp)
 3a2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3a4:	4585                	li	a1,1
 3a6:	0b2000ef          	jal	458 <sys_sbrk>
}
 3aa:	60a2                	ld	ra,8(sp)
 3ac:	6402                	ld	s0,0(sp)
 3ae:	0141                	addi	sp,sp,16
 3b0:	8082                	ret

00000000000003b2 <sbrklazy>:

char *
sbrklazy(int n) {
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e406                	sd	ra,8(sp)
 3b6:	e022                	sd	s0,0(sp)
 3b8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3ba:	4589                	li	a1,2
 3bc:	09c000ef          	jal	458 <sys_sbrk>
}
 3c0:	60a2                	ld	ra,8(sp)
 3c2:	6402                	ld	s0,0(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret

00000000000003c8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c8:	4885                	li	a7,1
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3d0:	4889                	li	a7,2
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d8:	488d                	li	a7,3
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3e0:	4891                	li	a7,4
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <read>:
.global read
read:
 li a7, SYS_read
 3e8:	4895                	li	a7,5
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <write>:
.global write
write:
 li a7, SYS_write
 3f0:	48c1                	li	a7,16
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <close>:
.global close
close:
 li a7, SYS_close
 3f8:	48d5                	li	a7,21
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <kill>:
.global kill
kill:
 li a7, SYS_kill
 400:	4899                	li	a7,6
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <exec>:
.global exec
exec:
 li a7, SYS_exec
 408:	489d                	li	a7,7
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <open>:
.global open
open:
 li a7, SYS_open
 410:	48bd                	li	a7,15
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 418:	48c5                	li	a7,17
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 420:	48c9                	li	a7,18
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 428:	48a1                	li	a7,8
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <link>:
.global link
link:
 li a7, SYS_link
 430:	48cd                	li	a7,19
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 438:	48d1                	li	a7,20
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 440:	48a5                	li	a7,9
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <dup>:
.global dup
dup:
 li a7, SYS_dup
 448:	48a9                	li	a7,10
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 450:	48ad                	li	a7,11
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 458:	48b1                	li	a7,12
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <pause>:
.global pause
pause:
 li a7, SYS_pause
 460:	48b5                	li	a7,13
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 468:	48b9                	li	a7,14
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <hello>:
.global hello
hello:
 li a7, SYS_hello
 470:	48d9                	li	a7,22
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 478:	48dd                	li	a7,23
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 480:	48e1                	li	a7,24
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 488:	48e5                	li	a7,25
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 490:	48e9                	li	a7,26
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 498:	48ed                	li	a7,27
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 4a0:	48f1                	li	a7,28
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 4a8:	48f5                	li	a7,29
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 4b0:	48f9                	li	a7,30
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 4b8:	48fd                	li	a7,31
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4c0:	1101                	addi	sp,sp,-32
 4c2:	ec06                	sd	ra,24(sp)
 4c4:	e822                	sd	s0,16(sp)
 4c6:	1000                	addi	s0,sp,32
 4c8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4cc:	4605                	li	a2,1
 4ce:	fef40593          	addi	a1,s0,-17
 4d2:	f1fff0ef          	jal	3f0 <write>
}
 4d6:	60e2                	ld	ra,24(sp)
 4d8:	6442                	ld	s0,16(sp)
 4da:	6105                	addi	sp,sp,32
 4dc:	8082                	ret

00000000000004de <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4de:	715d                	addi	sp,sp,-80
 4e0:	e486                	sd	ra,72(sp)
 4e2:	e0a2                	sd	s0,64(sp)
 4e4:	f84a                	sd	s2,48(sp)
 4e6:	f44e                	sd	s3,40(sp)
 4e8:	0880                	addi	s0,sp,80
 4ea:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4ec:	c6d1                	beqz	a3,578 <printint+0x9a>
 4ee:	0805d563          	bgez	a1,578 <printint+0x9a>
    neg = 1;
    x = -xx;
 4f2:	40b005b3          	neg	a1,a1
    neg = 1;
 4f6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4f8:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4fc:	86ce                	mv	a3,s3
  i = 0;
 4fe:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 500:	00000817          	auipc	a6,0x0
 504:	66880813          	addi	a6,a6,1640 # b68 <digits>
 508:	88ba                	mv	a7,a4
 50a:	0017051b          	addiw	a0,a4,1
 50e:	872a                	mv	a4,a0
 510:	02c5f7b3          	remu	a5,a1,a2
 514:	97c2                	add	a5,a5,a6
 516:	0007c783          	lbu	a5,0(a5)
 51a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 51e:	87ae                	mv	a5,a1
 520:	02c5d5b3          	divu	a1,a1,a2
 524:	0685                	addi	a3,a3,1
 526:	fec7f1e3          	bgeu	a5,a2,508 <printint+0x2a>
  if(neg)
 52a:	00030c63          	beqz	t1,542 <printint+0x64>
    buf[i++] = '-';
 52e:	fd050793          	addi	a5,a0,-48
 532:	00878533          	add	a0,a5,s0
 536:	02d00793          	li	a5,45
 53a:	fef50423          	sb	a5,-24(a0)
 53e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 542:	02e05563          	blez	a4,56c <printint+0x8e>
 546:	fc26                	sd	s1,56(sp)
 548:	377d                	addiw	a4,a4,-1
 54a:	00e984b3          	add	s1,s3,a4
 54e:	19fd                	addi	s3,s3,-1
 550:	99ba                	add	s3,s3,a4
 552:	1702                	slli	a4,a4,0x20
 554:	9301                	srli	a4,a4,0x20
 556:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 55a:	0004c583          	lbu	a1,0(s1)
 55e:	854a                	mv	a0,s2
 560:	f61ff0ef          	jal	4c0 <putc>
  while(--i >= 0)
 564:	14fd                	addi	s1,s1,-1
 566:	ff349ae3          	bne	s1,s3,55a <printint+0x7c>
 56a:	74e2                	ld	s1,56(sp)
}
 56c:	60a6                	ld	ra,72(sp)
 56e:	6406                	ld	s0,64(sp)
 570:	7942                	ld	s2,48(sp)
 572:	79a2                	ld	s3,40(sp)
 574:	6161                	addi	sp,sp,80
 576:	8082                	ret
  neg = 0;
 578:	4301                	li	t1,0
 57a:	bfbd                	j	4f8 <printint+0x1a>

000000000000057c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 57c:	711d                	addi	sp,sp,-96
 57e:	ec86                	sd	ra,88(sp)
 580:	e8a2                	sd	s0,80(sp)
 582:	e4a6                	sd	s1,72(sp)
 584:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 586:	0005c483          	lbu	s1,0(a1)
 58a:	22048363          	beqz	s1,7b0 <vprintf+0x234>
 58e:	e0ca                	sd	s2,64(sp)
 590:	fc4e                	sd	s3,56(sp)
 592:	f852                	sd	s4,48(sp)
 594:	f456                	sd	s5,40(sp)
 596:	f05a                	sd	s6,32(sp)
 598:	ec5e                	sd	s7,24(sp)
 59a:	e862                	sd	s8,16(sp)
 59c:	8b2a                	mv	s6,a0
 59e:	8a2e                	mv	s4,a1
 5a0:	8bb2                	mv	s7,a2
  state = 0;
 5a2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5a4:	4901                	li	s2,0
 5a6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5a8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5ac:	06400c13          	li	s8,100
 5b0:	a00d                	j	5d2 <vprintf+0x56>
        putc(fd, c0);
 5b2:	85a6                	mv	a1,s1
 5b4:	855a                	mv	a0,s6
 5b6:	f0bff0ef          	jal	4c0 <putc>
 5ba:	a019                	j	5c0 <vprintf+0x44>
    } else if(state == '%'){
 5bc:	03598363          	beq	s3,s5,5e2 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5c0:	0019079b          	addiw	a5,s2,1
 5c4:	893e                	mv	s2,a5
 5c6:	873e                	mv	a4,a5
 5c8:	97d2                	add	a5,a5,s4
 5ca:	0007c483          	lbu	s1,0(a5)
 5ce:	1c048a63          	beqz	s1,7a2 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 5d2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5d6:	fe0993e3          	bnez	s3,5bc <vprintf+0x40>
      if(c0 == '%'){
 5da:	fd579ce3          	bne	a5,s5,5b2 <vprintf+0x36>
        state = '%';
 5de:	89be                	mv	s3,a5
 5e0:	b7c5                	j	5c0 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5e2:	00ea06b3          	add	a3,s4,a4
 5e6:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5ea:	1c060863          	beqz	a2,7ba <vprintf+0x23e>
      if(c0 == 'd'){
 5ee:	03878763          	beq	a5,s8,61c <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5f2:	f9478693          	addi	a3,a5,-108
 5f6:	0016b693          	seqz	a3,a3
 5fa:	f9c60593          	addi	a1,a2,-100
 5fe:	e99d                	bnez	a1,634 <vprintf+0xb8>
 600:	ca95                	beqz	a3,634 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 602:	008b8493          	addi	s1,s7,8
 606:	4685                	li	a3,1
 608:	4629                	li	a2,10
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	ecfff0ef          	jal	4de <printint>
        i += 1;
 614:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 616:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 618:	4981                	li	s3,0
 61a:	b75d                	j	5c0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 61c:	008b8493          	addi	s1,s7,8
 620:	4685                	li	a3,1
 622:	4629                	li	a2,10
 624:	000ba583          	lw	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	eb5ff0ef          	jal	4de <printint>
 62e:	8ba6                	mv	s7,s1
      state = 0;
 630:	4981                	li	s3,0
 632:	b779                	j	5c0 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 634:	9752                	add	a4,a4,s4
 636:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 63a:	f9460713          	addi	a4,a2,-108
 63e:	00173713          	seqz	a4,a4
 642:	8f75                	and	a4,a4,a3
 644:	f9c58513          	addi	a0,a1,-100
 648:	18051363          	bnez	a0,7ce <vprintf+0x252>
 64c:	18070163          	beqz	a4,7ce <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 650:	008b8493          	addi	s1,s7,8
 654:	4685                	li	a3,1
 656:	4629                	li	a2,10
 658:	000bb583          	ld	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	e81ff0ef          	jal	4de <printint>
        i += 2;
 662:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 664:	8ba6                	mv	s7,s1
      state = 0;
 666:	4981                	li	s3,0
        i += 2;
 668:	bfa1                	j	5c0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 66a:	008b8493          	addi	s1,s7,8
 66e:	4681                	li	a3,0
 670:	4629                	li	a2,10
 672:	000be583          	lwu	a1,0(s7)
 676:	855a                	mv	a0,s6
 678:	e67ff0ef          	jal	4de <printint>
 67c:	8ba6                	mv	s7,s1
      state = 0;
 67e:	4981                	li	s3,0
 680:	b781                	j	5c0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 682:	008b8493          	addi	s1,s7,8
 686:	4681                	li	a3,0
 688:	4629                	li	a2,10
 68a:	000bb583          	ld	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	e4fff0ef          	jal	4de <printint>
        i += 1;
 694:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 696:	8ba6                	mv	s7,s1
      state = 0;
 698:	4981                	li	s3,0
 69a:	b71d                	j	5c0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	008b8493          	addi	s1,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4629                	li	a2,10
 6a4:	000bb583          	ld	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	e35ff0ef          	jal	4de <printint>
        i += 2;
 6ae:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b0:	8ba6                	mv	s7,s1
      state = 0;
 6b2:	4981                	li	s3,0
        i += 2;
 6b4:	b731                	j	5c0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6b6:	008b8493          	addi	s1,s7,8
 6ba:	4681                	li	a3,0
 6bc:	4641                	li	a2,16
 6be:	000be583          	lwu	a1,0(s7)
 6c2:	855a                	mv	a0,s6
 6c4:	e1bff0ef          	jal	4de <printint>
 6c8:	8ba6                	mv	s7,s1
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	bdd5                	j	5c0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	008b8493          	addi	s1,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4641                	li	a2,16
 6d6:	000bb583          	ld	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	e03ff0ef          	jal	4de <printint>
        i += 1;
 6e0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e2:	8ba6                	mv	s7,s1
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bde9                	j	5c0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e8:	008b8493          	addi	s1,s7,8
 6ec:	4681                	li	a3,0
 6ee:	4641                	li	a2,16
 6f0:	000bb583          	ld	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	de9ff0ef          	jal	4de <printint>
        i += 2;
 6fa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fc:	8ba6                	mv	s7,s1
      state = 0;
 6fe:	4981                	li	s3,0
        i += 2;
 700:	b5c1                	j	5c0 <vprintf+0x44>
 702:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 704:	008b8793          	addi	a5,s7,8
 708:	8cbe                	mv	s9,a5
 70a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 70e:	03000593          	li	a1,48
 712:	855a                	mv	a0,s6
 714:	dadff0ef          	jal	4c0 <putc>
  putc(fd, 'x');
 718:	07800593          	li	a1,120
 71c:	855a                	mv	a0,s6
 71e:	da3ff0ef          	jal	4c0 <putc>
 722:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 724:	00000b97          	auipc	s7,0x0
 728:	444b8b93          	addi	s7,s7,1092 # b68 <digits>
 72c:	03c9d793          	srli	a5,s3,0x3c
 730:	97de                	add	a5,a5,s7
 732:	0007c583          	lbu	a1,0(a5)
 736:	855a                	mv	a0,s6
 738:	d89ff0ef          	jal	4c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 73c:	0992                	slli	s3,s3,0x4
 73e:	34fd                	addiw	s1,s1,-1
 740:	f4f5                	bnez	s1,72c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 742:	8be6                	mv	s7,s9
      state = 0;
 744:	4981                	li	s3,0
 746:	6ca2                	ld	s9,8(sp)
 748:	bda5                	j	5c0 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 74a:	008b8493          	addi	s1,s7,8
 74e:	000bc583          	lbu	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	d6dff0ef          	jal	4c0 <putc>
 758:	8ba6                	mv	s7,s1
      state = 0;
 75a:	4981                	li	s3,0
 75c:	b595                	j	5c0 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 75e:	008b8993          	addi	s3,s7,8
 762:	000bb483          	ld	s1,0(s7)
 766:	cc91                	beqz	s1,782 <vprintf+0x206>
        for(; *s; s++)
 768:	0004c583          	lbu	a1,0(s1)
 76c:	c985                	beqz	a1,79c <vprintf+0x220>
          putc(fd, *s);
 76e:	855a                	mv	a0,s6
 770:	d51ff0ef          	jal	4c0 <putc>
        for(; *s; s++)
 774:	0485                	addi	s1,s1,1
 776:	0004c583          	lbu	a1,0(s1)
 77a:	f9f5                	bnez	a1,76e <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 77c:	8bce                	mv	s7,s3
      state = 0;
 77e:	4981                	li	s3,0
 780:	b581                	j	5c0 <vprintf+0x44>
          s = "(null)";
 782:	00000497          	auipc	s1,0x0
 786:	3de48493          	addi	s1,s1,990 # b60 <malloc+0x242>
        for(; *s; s++)
 78a:	02800593          	li	a1,40
 78e:	b7c5                	j	76e <vprintf+0x1f2>
        putc(fd, '%');
 790:	85be                	mv	a1,a5
 792:	855a                	mv	a0,s6
 794:	d2dff0ef          	jal	4c0 <putc>
      state = 0;
 798:	4981                	li	s3,0
 79a:	b51d                	j	5c0 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 79c:	8bce                	mv	s7,s3
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	b505                	j	5c0 <vprintf+0x44>
 7a2:	6906                	ld	s2,64(sp)
 7a4:	79e2                	ld	s3,56(sp)
 7a6:	7a42                	ld	s4,48(sp)
 7a8:	7aa2                	ld	s5,40(sp)
 7aa:	7b02                	ld	s6,32(sp)
 7ac:	6be2                	ld	s7,24(sp)
 7ae:	6c42                	ld	s8,16(sp)
    }
  }
}
 7b0:	60e6                	ld	ra,88(sp)
 7b2:	6446                	ld	s0,80(sp)
 7b4:	64a6                	ld	s1,72(sp)
 7b6:	6125                	addi	sp,sp,96
 7b8:	8082                	ret
      if(c0 == 'd'){
 7ba:	06400713          	li	a4,100
 7be:	e4e78fe3          	beq	a5,a4,61c <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 7c2:	f9478693          	addi	a3,a5,-108
 7c6:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7ca:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7cc:	4701                	li	a4,0
      } else if(c0 == 'u'){
 7ce:	07500513          	li	a0,117
 7d2:	e8a78ce3          	beq	a5,a0,66a <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 7d6:	f8b60513          	addi	a0,a2,-117
 7da:	e119                	bnez	a0,7e0 <vprintf+0x264>
 7dc:	ea0693e3          	bnez	a3,682 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7e0:	f8b58513          	addi	a0,a1,-117
 7e4:	e119                	bnez	a0,7ea <vprintf+0x26e>
 7e6:	ea071be3          	bnez	a4,69c <vprintf+0x120>
      } else if(c0 == 'x'){
 7ea:	07800513          	li	a0,120
 7ee:	eca784e3          	beq	a5,a0,6b6 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7f2:	f8860613          	addi	a2,a2,-120
 7f6:	e219                	bnez	a2,7fc <vprintf+0x280>
 7f8:	ec069be3          	bnez	a3,6ce <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7fc:	f8858593          	addi	a1,a1,-120
 800:	e199                	bnez	a1,806 <vprintf+0x28a>
 802:	ee0713e3          	bnez	a4,6e8 <vprintf+0x16c>
      } else if(c0 == 'p'){
 806:	07000713          	li	a4,112
 80a:	eee78ce3          	beq	a5,a4,702 <vprintf+0x186>
      } else if(c0 == 'c'){
 80e:	06300713          	li	a4,99
 812:	f2e78ce3          	beq	a5,a4,74a <vprintf+0x1ce>
      } else if(c0 == 's'){
 816:	07300713          	li	a4,115
 81a:	f4e782e3          	beq	a5,a4,75e <vprintf+0x1e2>
      } else if(c0 == '%'){
 81e:	02500713          	li	a4,37
 822:	f6e787e3          	beq	a5,a4,790 <vprintf+0x214>
        putc(fd, '%');
 826:	02500593          	li	a1,37
 82a:	855a                	mv	a0,s6
 82c:	c95ff0ef          	jal	4c0 <putc>
        putc(fd, c0);
 830:	85a6                	mv	a1,s1
 832:	855a                	mv	a0,s6
 834:	c8dff0ef          	jal	4c0 <putc>
      state = 0;
 838:	4981                	li	s3,0
 83a:	b359                	j	5c0 <vprintf+0x44>

000000000000083c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 83c:	715d                	addi	sp,sp,-80
 83e:	ec06                	sd	ra,24(sp)
 840:	e822                	sd	s0,16(sp)
 842:	1000                	addi	s0,sp,32
 844:	e010                	sd	a2,0(s0)
 846:	e414                	sd	a3,8(s0)
 848:	e818                	sd	a4,16(s0)
 84a:	ec1c                	sd	a5,24(s0)
 84c:	03043023          	sd	a6,32(s0)
 850:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 854:	8622                	mv	a2,s0
 856:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 85a:	d23ff0ef          	jal	57c <vprintf>
}
 85e:	60e2                	ld	ra,24(sp)
 860:	6442                	ld	s0,16(sp)
 862:	6161                	addi	sp,sp,80
 864:	8082                	ret

0000000000000866 <printf>:

void
printf(const char *fmt, ...)
{
 866:	711d                	addi	sp,sp,-96
 868:	ec06                	sd	ra,24(sp)
 86a:	e822                	sd	s0,16(sp)
 86c:	1000                	addi	s0,sp,32
 86e:	e40c                	sd	a1,8(s0)
 870:	e810                	sd	a2,16(s0)
 872:	ec14                	sd	a3,24(s0)
 874:	f018                	sd	a4,32(s0)
 876:	f41c                	sd	a5,40(s0)
 878:	03043823          	sd	a6,48(s0)
 87c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 880:	00840613          	addi	a2,s0,8
 884:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 888:	85aa                	mv	a1,a0
 88a:	4505                	li	a0,1
 88c:	cf1ff0ef          	jal	57c <vprintf>
}
 890:	60e2                	ld	ra,24(sp)
 892:	6442                	ld	s0,16(sp)
 894:	6125                	addi	sp,sp,96
 896:	8082                	ret

0000000000000898 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 898:	1141                	addi	sp,sp,-16
 89a:	e406                	sd	ra,8(sp)
 89c:	e022                	sd	s0,0(sp)
 89e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a4:	00000797          	auipc	a5,0x0
 8a8:	75c7b783          	ld	a5,1884(a5) # 1000 <freep>
 8ac:	a039                	j	8ba <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ae:	6398                	ld	a4,0(a5)
 8b0:	00e7e463          	bltu	a5,a4,8b8 <free+0x20>
 8b4:	00e6ea63          	bltu	a3,a4,8c8 <free+0x30>
{
 8b8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ba:	fed7fae3          	bgeu	a5,a3,8ae <free+0x16>
 8be:	6398                	ld	a4,0(a5)
 8c0:	00e6e463          	bltu	a3,a4,8c8 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c4:	fee7eae3          	bltu	a5,a4,8b8 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8c8:	ff852583          	lw	a1,-8(a0)
 8cc:	6390                	ld	a2,0(a5)
 8ce:	02059813          	slli	a6,a1,0x20
 8d2:	01c85713          	srli	a4,a6,0x1c
 8d6:	9736                	add	a4,a4,a3
 8d8:	02e60563          	beq	a2,a4,902 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8dc:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8e0:	4790                	lw	a2,8(a5)
 8e2:	02061593          	slli	a1,a2,0x20
 8e6:	01c5d713          	srli	a4,a1,0x1c
 8ea:	973e                	add	a4,a4,a5
 8ec:	02e68263          	beq	a3,a4,910 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8f0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8f2:	00000717          	auipc	a4,0x0
 8f6:	70f73723          	sd	a5,1806(a4) # 1000 <freep>
}
 8fa:	60a2                	ld	ra,8(sp)
 8fc:	6402                	ld	s0,0(sp)
 8fe:	0141                	addi	sp,sp,16
 900:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 902:	4618                	lw	a4,8(a2)
 904:	9f2d                	addw	a4,a4,a1
 906:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 90a:	6398                	ld	a4,0(a5)
 90c:	6310                	ld	a2,0(a4)
 90e:	b7f9                	j	8dc <free+0x44>
    p->s.size += bp->s.size;
 910:	ff852703          	lw	a4,-8(a0)
 914:	9f31                	addw	a4,a4,a2
 916:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 918:	ff053683          	ld	a3,-16(a0)
 91c:	bfd1                	j	8f0 <free+0x58>

000000000000091e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 91e:	7139                	addi	sp,sp,-64
 920:	fc06                	sd	ra,56(sp)
 922:	f822                	sd	s0,48(sp)
 924:	f04a                	sd	s2,32(sp)
 926:	ec4e                	sd	s3,24(sp)
 928:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 92a:	02051993          	slli	s3,a0,0x20
 92e:	0209d993          	srli	s3,s3,0x20
 932:	09bd                	addi	s3,s3,15
 934:	0049d993          	srli	s3,s3,0x4
 938:	2985                	addiw	s3,s3,1
 93a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 93c:	00000517          	auipc	a0,0x0
 940:	6c453503          	ld	a0,1732(a0) # 1000 <freep>
 944:	c905                	beqz	a0,974 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 946:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 948:	4798                	lw	a4,8(a5)
 94a:	09377663          	bgeu	a4,s3,9d6 <malloc+0xb8>
 94e:	f426                	sd	s1,40(sp)
 950:	e852                	sd	s4,16(sp)
 952:	e456                	sd	s5,8(sp)
 954:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 956:	8a4e                	mv	s4,s3
 958:	6705                	lui	a4,0x1
 95a:	00e9f363          	bgeu	s3,a4,960 <malloc+0x42>
 95e:	6a05                	lui	s4,0x1
 960:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 964:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 968:	00000497          	auipc	s1,0x0
 96c:	69848493          	addi	s1,s1,1688 # 1000 <freep>
  if(p == SBRK_ERROR)
 970:	5afd                	li	s5,-1
 972:	a83d                	j	9b0 <malloc+0x92>
 974:	f426                	sd	s1,40(sp)
 976:	e852                	sd	s4,16(sp)
 978:	e456                	sd	s5,8(sp)
 97a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 97c:	00000797          	auipc	a5,0x0
 980:	69478793          	addi	a5,a5,1684 # 1010 <base>
 984:	00000717          	auipc	a4,0x0
 988:	66f73e23          	sd	a5,1660(a4) # 1000 <freep>
 98c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 98e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 992:	b7d1                	j	956 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 994:	6398                	ld	a4,0(a5)
 996:	e118                	sd	a4,0(a0)
 998:	a899                	j	9ee <malloc+0xd0>
  hp->s.size = nu;
 99a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 99e:	0541                	addi	a0,a0,16
 9a0:	ef9ff0ef          	jal	898 <free>
  return freep;
 9a4:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9a6:	c125                	beqz	a0,a06 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9aa:	4798                	lw	a4,8(a5)
 9ac:	03277163          	bgeu	a4,s2,9ce <malloc+0xb0>
    if(p == freep)
 9b0:	6098                	ld	a4,0(s1)
 9b2:	853e                	mv	a0,a5
 9b4:	fef71ae3          	bne	a4,a5,9a8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9b8:	8552                	mv	a0,s4
 9ba:	9e3ff0ef          	jal	39c <sbrk>
  if(p == SBRK_ERROR)
 9be:	fd551ee3          	bne	a0,s5,99a <malloc+0x7c>
        return 0;
 9c2:	4501                	li	a0,0
 9c4:	74a2                	ld	s1,40(sp)
 9c6:	6a42                	ld	s4,16(sp)
 9c8:	6aa2                	ld	s5,8(sp)
 9ca:	6b02                	ld	s6,0(sp)
 9cc:	a03d                	j	9fa <malloc+0xdc>
 9ce:	74a2                	ld	s1,40(sp)
 9d0:	6a42                	ld	s4,16(sp)
 9d2:	6aa2                	ld	s5,8(sp)
 9d4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9d6:	fae90fe3          	beq	s2,a4,994 <malloc+0x76>
        p->s.size -= nunits;
 9da:	4137073b          	subw	a4,a4,s3
 9de:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9e0:	02071693          	slli	a3,a4,0x20
 9e4:	01c6d713          	srli	a4,a3,0x1c
 9e8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ee:	00000717          	auipc	a4,0x0
 9f2:	60a73923          	sd	a0,1554(a4) # 1000 <freep>
      return (void*)(p + 1);
 9f6:	01078513          	addi	a0,a5,16
  }
}
 9fa:	70e2                	ld	ra,56(sp)
 9fc:	7442                	ld	s0,48(sp)
 9fe:	7902                	ld	s2,32(sp)
 a00:	69e2                	ld	s3,24(sp)
 a02:	6121                	addi	sp,sp,64
 a04:	8082                	ret
 a06:	74a2                	ld	s1,40(sp)
 a08:	6a42                	ld	s4,16(sp)
 a0a:	6aa2                	ld	s5,8(sp)
 a0c:	6b02                	ld	s6,0(sp)
 a0e:	b7f5                	j	9fa <malloc+0xdc>
