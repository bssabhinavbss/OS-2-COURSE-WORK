
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	9b250513          	addi	a0,a0,-1614 # 9c0 <malloc+0x100>
  16:	39c000ef          	jal	3b2 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	3ca000ef          	jal	3ea <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	3c4000ef          	jal	3ea <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	99e90913          	addi	s2,s2,-1634 # 9c8 <malloc+0x108>
  32:	854a                	mv	a0,s2
  34:	7d4000ef          	jal	808 <printf>
    pid = fork();
  38:	332000ef          	jal	36a <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054363          	bltz	a0,84 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c931                	beqz	a0,96 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	334000ef          	jal	37a <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	9c650513          	addi	a0,a0,-1594 # a18 <malloc+0x158>
  5a:	7ae000ef          	jal	808 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	312000ef          	jal	372 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	95850513          	addi	a0,a0,-1704 # 9c0 <malloc+0x100>
  70:	34a000ef          	jal	3ba <mknod>
    open("console", O_RDWR);
  74:	4589                	li	a1,2
  76:	00001517          	auipc	a0,0x1
  7a:	94a50513          	addi	a0,a0,-1718 # 9c0 <malloc+0x100>
  7e:	334000ef          	jal	3b2 <open>
  82:	bf71                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  84:	00001517          	auipc	a0,0x1
  88:	95c50513          	addi	a0,a0,-1700 # 9e0 <malloc+0x120>
  8c:	77c000ef          	jal	808 <printf>
      exit(1);
  90:	4505                	li	a0,1
  92:	2e0000ef          	jal	372 <exit>
      exec("sh", argv);
  96:	00001597          	auipc	a1,0x1
  9a:	f6a58593          	addi	a1,a1,-150 # 1000 <argv>
  9e:	00001517          	auipc	a0,0x1
  a2:	95a50513          	addi	a0,a0,-1702 # 9f8 <malloc+0x138>
  a6:	304000ef          	jal	3aa <exec>
      printf("init: exec sh failed\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	95650513          	addi	a0,a0,-1706 # a00 <malloc+0x140>
  b2:	756000ef          	jal	808 <printf>
      exit(1);
  b6:	4505                	li	a0,1
  b8:	2ba000ef          	jal	372 <exit>

00000000000000bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  c4:	f3dff0ef          	jal	0 <main>
  exit(r);
  c8:	2aa000ef          	jal	372 <exit>

00000000000000cc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  d4:	87aa                	mv	a5,a0
  d6:	0585                	addi	a1,a1,1
  d8:	0785                	addi	a5,a5,1
  da:	fff5c703          	lbu	a4,-1(a1)
  de:	fee78fa3          	sb	a4,-1(a5)
  e2:	fb75                	bnez	a4,d6 <strcpy+0xa>
    ;
  return os;
}
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cb91                	beqz	a5,10c <strcmp+0x20>
  fa:	0005c703          	lbu	a4,0(a1)
  fe:	00f71763          	bne	a4,a5,10c <strcmp+0x20>
    p++, q++;
 102:	0505                	addi	a0,a0,1
 104:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbe5                	bnez	a5,fa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 10c:	0005c503          	lbu	a0,0(a1)
}
 110:	40a7853b          	subw	a0,a5,a0
 114:	60a2                	ld	ra,8(sp)
 116:	6402                	ld	s0,0(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strlen>:

uint
strlen(const char *s)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf91                	beqz	a5,144 <strlen+0x28>
 12a:	00150793          	addi	a5,a0,1
 12e:	86be                	mv	a3,a5
 130:	0785                	addi	a5,a5,1
 132:	fff7c703          	lbu	a4,-1(a5)
 136:	ff65                	bnez	a4,12e <strlen+0x12>
 138:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 13c:	60a2                	ld	ra,8(sp)
 13e:	6402                	ld	s0,0(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret
  for(n = 0; s[n]; n++)
 144:	4501                	li	a0,0
 146:	bfdd                	j	13c <strlen+0x20>

0000000000000148 <memset>:

void*
memset(void *dst, int c, uint n)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 150:	ca19                	beqz	a2,166 <memset+0x1e>
 152:	87aa                	mv	a5,a0
 154:	1602                	slli	a2,a2,0x20
 156:	9201                	srli	a2,a2,0x20
 158:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 160:	0785                	addi	a5,a5,1
 162:	fee79de3          	bne	a5,a4,15c <memset+0x14>
  }
  return dst;
}
 166:	60a2                	ld	ra,8(sp)
 168:	6402                	ld	s0,0(sp)
 16a:	0141                	addi	sp,sp,16
 16c:	8082                	ret

000000000000016e <strchr>:

char*
strchr(const char *s, char c)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e406                	sd	ra,8(sp)
 172:	e022                	sd	s0,0(sp)
 174:	0800                	addi	s0,sp,16
  for(; *s; s++)
 176:	00054783          	lbu	a5,0(a0)
 17a:	cf81                	beqz	a5,192 <strchr+0x24>
    if(*s == c)
 17c:	00f58763          	beq	a1,a5,18a <strchr+0x1c>
  for(; *s; s++)
 180:	0505                	addi	a0,a0,1
 182:	00054783          	lbu	a5,0(a0)
 186:	fbfd                	bnez	a5,17c <strchr+0xe>
      return (char*)s;
  return 0;
 188:	4501                	li	a0,0
}
 18a:	60a2                	ld	ra,8(sp)
 18c:	6402                	ld	s0,0(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret
  return 0;
 192:	4501                	li	a0,0
 194:	bfdd                	j	18a <strchr+0x1c>

0000000000000196 <gets>:

char*
gets(char *buf, int max)
{
 196:	711d                	addi	sp,sp,-96
 198:	ec86                	sd	ra,88(sp)
 19a:	e8a2                	sd	s0,80(sp)
 19c:	e4a6                	sd	s1,72(sp)
 19e:	e0ca                	sd	s2,64(sp)
 1a0:	fc4e                	sd	s3,56(sp)
 1a2:	f852                	sd	s4,48(sp)
 1a4:	f456                	sd	s5,40(sp)
 1a6:	f05a                	sd	s6,32(sp)
 1a8:	ec5e                	sd	s7,24(sp)
 1aa:	e862                	sd	s8,16(sp)
 1ac:	1080                	addi	s0,sp,96
 1ae:	8baa                	mv	s7,a0
 1b0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b2:	892a                	mv	s2,a0
 1b4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1b6:	faf40b13          	addi	s6,s0,-81
 1ba:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1bc:	8c26                	mv	s8,s1
 1be:	0014899b          	addiw	s3,s1,1
 1c2:	84ce                	mv	s1,s3
 1c4:	0349d463          	bge	s3,s4,1ec <gets+0x56>
    cc = read(0, &c, 1);
 1c8:	8656                	mv	a2,s5
 1ca:	85da                	mv	a1,s6
 1cc:	4501                	li	a0,0
 1ce:	1bc000ef          	jal	38a <read>
    if(cc < 1)
 1d2:	00a05d63          	blez	a0,1ec <gets+0x56>
      break;
    buf[i++] = c;
 1d6:	faf44783          	lbu	a5,-81(s0)
 1da:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1de:	0905                	addi	s2,s2,1
 1e0:	ff678713          	addi	a4,a5,-10
 1e4:	c319                	beqz	a4,1ea <gets+0x54>
 1e6:	17cd                	addi	a5,a5,-13
 1e8:	fbf1                	bnez	a5,1bc <gets+0x26>
    buf[i++] = c;
 1ea:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1ec:	9c5e                	add	s8,s8,s7
 1ee:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1f2:	855e                	mv	a0,s7
 1f4:	60e6                	ld	ra,88(sp)
 1f6:	6446                	ld	s0,80(sp)
 1f8:	64a6                	ld	s1,72(sp)
 1fa:	6906                	ld	s2,64(sp)
 1fc:	79e2                	ld	s3,56(sp)
 1fe:	7a42                	ld	s4,48(sp)
 200:	7aa2                	ld	s5,40(sp)
 202:	7b02                	ld	s6,32(sp)
 204:	6be2                	ld	s7,24(sp)
 206:	6c42                	ld	s8,16(sp)
 208:	6125                	addi	sp,sp,96
 20a:	8082                	ret

000000000000020c <stat>:

int
stat(const char *n, struct stat *st)
{
 20c:	1101                	addi	sp,sp,-32
 20e:	ec06                	sd	ra,24(sp)
 210:	e822                	sd	s0,16(sp)
 212:	e04a                	sd	s2,0(sp)
 214:	1000                	addi	s0,sp,32
 216:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 218:	4581                	li	a1,0
 21a:	198000ef          	jal	3b2 <open>
  if(fd < 0)
 21e:	02054263          	bltz	a0,242 <stat+0x36>
 222:	e426                	sd	s1,8(sp)
 224:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 226:	85ca                	mv	a1,s2
 228:	1a2000ef          	jal	3ca <fstat>
 22c:	892a                	mv	s2,a0
  close(fd);
 22e:	8526                	mv	a0,s1
 230:	16a000ef          	jal	39a <close>
  return r;
 234:	64a2                	ld	s1,8(sp)
}
 236:	854a                	mv	a0,s2
 238:	60e2                	ld	ra,24(sp)
 23a:	6442                	ld	s0,16(sp)
 23c:	6902                	ld	s2,0(sp)
 23e:	6105                	addi	sp,sp,32
 240:	8082                	ret
    return -1;
 242:	57fd                	li	a5,-1
 244:	893e                	mv	s2,a5
 246:	bfc5                	j	236 <stat+0x2a>

0000000000000248 <atoi>:

int
atoi(const char *s)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e406                	sd	ra,8(sp)
 24c:	e022                	sd	s0,0(sp)
 24e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 250:	00054683          	lbu	a3,0(a0)
 254:	fd06879b          	addiw	a5,a3,-48
 258:	0ff7f793          	zext.b	a5,a5
 25c:	4625                	li	a2,9
 25e:	02f66963          	bltu	a2,a5,290 <atoi+0x48>
 262:	872a                	mv	a4,a0
  n = 0;
 264:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 266:	0705                	addi	a4,a4,1
 268:	0025179b          	slliw	a5,a0,0x2
 26c:	9fa9                	addw	a5,a5,a0
 26e:	0017979b          	slliw	a5,a5,0x1
 272:	9fb5                	addw	a5,a5,a3
 274:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 278:	00074683          	lbu	a3,0(a4)
 27c:	fd06879b          	addiw	a5,a3,-48
 280:	0ff7f793          	zext.b	a5,a5
 284:	fef671e3          	bgeu	a2,a5,266 <atoi+0x1e>
  return n;
}
 288:	60a2                	ld	ra,8(sp)
 28a:	6402                	ld	s0,0(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
  n = 0;
 290:	4501                	li	a0,0
 292:	bfdd                	j	288 <atoi+0x40>

0000000000000294 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 29c:	02b57563          	bgeu	a0,a1,2c6 <memmove+0x32>
    while(n-- > 0)
 2a0:	00c05f63          	blez	a2,2be <memmove+0x2a>
 2a4:	1602                	slli	a2,a2,0x20
 2a6:	9201                	srli	a2,a2,0x20
 2a8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ac:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ae:	0585                	addi	a1,a1,1
 2b0:	0705                	addi	a4,a4,1
 2b2:	fff5c683          	lbu	a3,-1(a1)
 2b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ba:	fee79ae3          	bne	a5,a4,2ae <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2be:	60a2                	ld	ra,8(sp)
 2c0:	6402                	ld	s0,0(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
    while(n-- > 0)
 2c6:	fec05ce3          	blez	a2,2be <memmove+0x2a>
    dst += n;
 2ca:	00c50733          	add	a4,a0,a2
    src += n;
 2ce:	95b2                	add	a1,a1,a2
 2d0:	fff6079b          	addiw	a5,a2,-1
 2d4:	1782                	slli	a5,a5,0x20
 2d6:	9381                	srli	a5,a5,0x20
 2d8:	fff7c793          	not	a5,a5
 2dc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2de:	15fd                	addi	a1,a1,-1
 2e0:	177d                	addi	a4,a4,-1
 2e2:	0005c683          	lbu	a3,0(a1)
 2e6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ea:	fef71ae3          	bne	a4,a5,2de <memmove+0x4a>
 2ee:	bfc1                	j	2be <memmove+0x2a>

00000000000002f0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e406                	sd	ra,8(sp)
 2f4:	e022                	sd	s0,0(sp)
 2f6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f8:	c61d                	beqz	a2,326 <memcmp+0x36>
 2fa:	1602                	slli	a2,a2,0x20
 2fc:	9201                	srli	a2,a2,0x20
 2fe:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 302:	00054783          	lbu	a5,0(a0)
 306:	0005c703          	lbu	a4,0(a1)
 30a:	00e79863          	bne	a5,a4,31a <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 30e:	0505                	addi	a0,a0,1
    p2++;
 310:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 312:	fed518e3          	bne	a0,a3,302 <memcmp+0x12>
  }
  return 0;
 316:	4501                	li	a0,0
 318:	a019                	j	31e <memcmp+0x2e>
      return *p1 - *p2;
 31a:	40e7853b          	subw	a0,a5,a4
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
  return 0;
 326:	4501                	li	a0,0
 328:	bfdd                	j	31e <memcmp+0x2e>

000000000000032a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32a:	1141                	addi	sp,sp,-16
 32c:	e406                	sd	ra,8(sp)
 32e:	e022                	sd	s0,0(sp)
 330:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 332:	f63ff0ef          	jal	294 <memmove>
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret

000000000000033e <sbrk>:

char *
sbrk(int n) {
 33e:	1141                	addi	sp,sp,-16
 340:	e406                	sd	ra,8(sp)
 342:	e022                	sd	s0,0(sp)
 344:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 346:	4585                	li	a1,1
 348:	0b2000ef          	jal	3fa <sys_sbrk>
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <sbrklazy>:

char *
sbrklazy(int n) {
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 35c:	4589                	li	a1,2
 35e:	09c000ef          	jal	3fa <sys_sbrk>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 36a:	4885                	li	a7,1
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <exit>:
.global exit
exit:
 li a7, SYS_exit
 372:	4889                	li	a7,2
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <wait>:
.global wait
wait:
 li a7, SYS_wait
 37a:	488d                	li	a7,3
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 382:	4891                	li	a7,4
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <read>:
.global read
read:
 li a7, SYS_read
 38a:	4895                	li	a7,5
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <write>:
.global write
write:
 li a7, SYS_write
 392:	48c1                	li	a7,16
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <close>:
.global close
close:
 li a7, SYS_close
 39a:	48d5                	li	a7,21
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a2:	4899                	li	a7,6
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exec>:
.global exec
exec:
 li a7, SYS_exec
 3aa:	489d                	li	a7,7
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <open>:
.global open
open:
 li a7, SYS_open
 3b2:	48bd                	li	a7,15
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ba:	48c5                	li	a7,17
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c2:	48c9                	li	a7,18
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ca:	48a1                	li	a7,8
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <link>:
.global link
link:
 li a7, SYS_link
 3d2:	48cd                	li	a7,19
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3da:	48d1                	li	a7,20
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e2:	48a5                	li	a7,9
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ea:	48a9                	li	a7,10
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f2:	48ad                	li	a7,11
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3fa:	48b1                	li	a7,12
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <pause>:
.global pause
pause:
 li a7, SYS_pause
 402:	48b5                	li	a7,13
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 40a:	48b9                	li	a7,14
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <hello>:
.global hello
hello:
 li a7, SYS_hello
 412:	48d9                	li	a7,22
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 41a:	48dd                	li	a7,23
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 422:	48e1                	li	a7,24
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 42a:	48e5                	li	a7,25
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 432:	48e9                	li	a7,26
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 43a:	48ed                	li	a7,27
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 442:	48f1                	li	a7,28
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 44a:	48f5                	li	a7,29
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 452:	48f9                	li	a7,30
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 45a:	48fd                	li	a7,31
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 462:	1101                	addi	sp,sp,-32
 464:	ec06                	sd	ra,24(sp)
 466:	e822                	sd	s0,16(sp)
 468:	1000                	addi	s0,sp,32
 46a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46e:	4605                	li	a2,1
 470:	fef40593          	addi	a1,s0,-17
 474:	f1fff0ef          	jal	392 <write>
}
 478:	60e2                	ld	ra,24(sp)
 47a:	6442                	ld	s0,16(sp)
 47c:	6105                	addi	sp,sp,32
 47e:	8082                	ret

0000000000000480 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 480:	715d                	addi	sp,sp,-80
 482:	e486                	sd	ra,72(sp)
 484:	e0a2                	sd	s0,64(sp)
 486:	f84a                	sd	s2,48(sp)
 488:	f44e                	sd	s3,40(sp)
 48a:	0880                	addi	s0,sp,80
 48c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 48e:	c6d1                	beqz	a3,51a <printint+0x9a>
 490:	0805d563          	bgez	a1,51a <printint+0x9a>
    neg = 1;
    x = -xx;
 494:	40b005b3          	neg	a1,a1
    neg = 1;
 498:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 49a:	fb840993          	addi	s3,s0,-72
  neg = 0;
 49e:	86ce                	mv	a3,s3
  i = 0;
 4a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a2:	00000817          	auipc	a6,0x0
 4a6:	59e80813          	addi	a6,a6,1438 # a40 <digits>
 4aa:	88ba                	mv	a7,a4
 4ac:	0017051b          	addiw	a0,a4,1
 4b0:	872a                	mv	a4,a0
 4b2:	02c5f7b3          	remu	a5,a1,a2
 4b6:	97c2                	add	a5,a5,a6
 4b8:	0007c783          	lbu	a5,0(a5)
 4bc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c0:	87ae                	mv	a5,a1
 4c2:	02c5d5b3          	divu	a1,a1,a2
 4c6:	0685                	addi	a3,a3,1
 4c8:	fec7f1e3          	bgeu	a5,a2,4aa <printint+0x2a>
  if(neg)
 4cc:	00030c63          	beqz	t1,4e4 <printint+0x64>
    buf[i++] = '-';
 4d0:	fd050793          	addi	a5,a0,-48
 4d4:	00878533          	add	a0,a5,s0
 4d8:	02d00793          	li	a5,45
 4dc:	fef50423          	sb	a5,-24(a0)
 4e0:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4e4:	02e05563          	blez	a4,50e <printint+0x8e>
 4e8:	fc26                	sd	s1,56(sp)
 4ea:	377d                	addiw	a4,a4,-1
 4ec:	00e984b3          	add	s1,s3,a4
 4f0:	19fd                	addi	s3,s3,-1
 4f2:	99ba                	add	s3,s3,a4
 4f4:	1702                	slli	a4,a4,0x20
 4f6:	9301                	srli	a4,a4,0x20
 4f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fc:	0004c583          	lbu	a1,0(s1)
 500:	854a                	mv	a0,s2
 502:	f61ff0ef          	jal	462 <putc>
  while(--i >= 0)
 506:	14fd                	addi	s1,s1,-1
 508:	ff349ae3          	bne	s1,s3,4fc <printint+0x7c>
 50c:	74e2                	ld	s1,56(sp)
}
 50e:	60a6                	ld	ra,72(sp)
 510:	6406                	ld	s0,64(sp)
 512:	7942                	ld	s2,48(sp)
 514:	79a2                	ld	s3,40(sp)
 516:	6161                	addi	sp,sp,80
 518:	8082                	ret
  neg = 0;
 51a:	4301                	li	t1,0
 51c:	bfbd                	j	49a <printint+0x1a>

000000000000051e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51e:	711d                	addi	sp,sp,-96
 520:	ec86                	sd	ra,88(sp)
 522:	e8a2                	sd	s0,80(sp)
 524:	e4a6                	sd	s1,72(sp)
 526:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 528:	0005c483          	lbu	s1,0(a1)
 52c:	22048363          	beqz	s1,752 <vprintf+0x234>
 530:	e0ca                	sd	s2,64(sp)
 532:	fc4e                	sd	s3,56(sp)
 534:	f852                	sd	s4,48(sp)
 536:	f456                	sd	s5,40(sp)
 538:	f05a                	sd	s6,32(sp)
 53a:	ec5e                	sd	s7,24(sp)
 53c:	e862                	sd	s8,16(sp)
 53e:	8b2a                	mv	s6,a0
 540:	8a2e                	mv	s4,a1
 542:	8bb2                	mv	s7,a2
  state = 0;
 544:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 546:	4901                	li	s2,0
 548:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 54a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 54e:	06400c13          	li	s8,100
 552:	a00d                	j	574 <vprintf+0x56>
        putc(fd, c0);
 554:	85a6                	mv	a1,s1
 556:	855a                	mv	a0,s6
 558:	f0bff0ef          	jal	462 <putc>
 55c:	a019                	j	562 <vprintf+0x44>
    } else if(state == '%'){
 55e:	03598363          	beq	s3,s5,584 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 562:	0019079b          	addiw	a5,s2,1
 566:	893e                	mv	s2,a5
 568:	873e                	mv	a4,a5
 56a:	97d2                	add	a5,a5,s4
 56c:	0007c483          	lbu	s1,0(a5)
 570:	1c048a63          	beqz	s1,744 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 574:	0004879b          	sext.w	a5,s1
    if(state == 0){
 578:	fe0993e3          	bnez	s3,55e <vprintf+0x40>
      if(c0 == '%'){
 57c:	fd579ce3          	bne	a5,s5,554 <vprintf+0x36>
        state = '%';
 580:	89be                	mv	s3,a5
 582:	b7c5                	j	562 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 584:	00ea06b3          	add	a3,s4,a4
 588:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 58c:	1c060863          	beqz	a2,75c <vprintf+0x23e>
      if(c0 == 'd'){
 590:	03878763          	beq	a5,s8,5be <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 594:	f9478693          	addi	a3,a5,-108
 598:	0016b693          	seqz	a3,a3
 59c:	f9c60593          	addi	a1,a2,-100
 5a0:	e99d                	bnez	a1,5d6 <vprintf+0xb8>
 5a2:	ca95                	beqz	a3,5d6 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4685                	li	a3,1
 5aa:	4629                	li	a2,10
 5ac:	000bb583          	ld	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	ecfff0ef          	jal	480 <printint>
        i += 1;
 5b6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b8:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	b75d                	j	562 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5be:	008b8493          	addi	s1,s7,8
 5c2:	4685                	li	a3,1
 5c4:	4629                	li	a2,10
 5c6:	000ba583          	lw	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	eb5ff0ef          	jal	480 <printint>
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b779                	j	562 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5d6:	9752                	add	a4,a4,s4
 5d8:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5dc:	f9460713          	addi	a4,a2,-108
 5e0:	00173713          	seqz	a4,a4
 5e4:	8f75                	and	a4,a4,a3
 5e6:	f9c58513          	addi	a0,a1,-100
 5ea:	18051363          	bnez	a0,770 <vprintf+0x252>
 5ee:	18070163          	beqz	a4,770 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	008b8493          	addi	s1,s7,8
 5f6:	4685                	li	a3,1
 5f8:	4629                	li	a2,10
 5fa:	000bb583          	ld	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	e81ff0ef          	jal	480 <printint>
        i += 2;
 604:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 606:	8ba6                	mv	s7,s1
      state = 0;
 608:	4981                	li	s3,0
        i += 2;
 60a:	bfa1                	j	562 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 60c:	008b8493          	addi	s1,s7,8
 610:	4681                	li	a3,0
 612:	4629                	li	a2,10
 614:	000be583          	lwu	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	e67ff0ef          	jal	480 <printint>
 61e:	8ba6                	mv	s7,s1
      state = 0;
 620:	4981                	li	s3,0
 622:	b781                	j	562 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	008b8493          	addi	s1,s7,8
 628:	4681                	li	a3,0
 62a:	4629                	li	a2,10
 62c:	000bb583          	ld	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	e4fff0ef          	jal	480 <printint>
        i += 1;
 636:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 638:	8ba6                	mv	s7,s1
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b71d                	j	562 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	008b8493          	addi	s1,s7,8
 642:	4681                	li	a3,0
 644:	4629                	li	a2,10
 646:	000bb583          	ld	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	e35ff0ef          	jal	480 <printint>
        i += 2;
 650:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 652:	8ba6                	mv	s7,s1
      state = 0;
 654:	4981                	li	s3,0
        i += 2;
 656:	b731                	j	562 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 658:	008b8493          	addi	s1,s7,8
 65c:	4681                	li	a3,0
 65e:	4641                	li	a2,16
 660:	000be583          	lwu	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	e1bff0ef          	jal	480 <printint>
 66a:	8ba6                	mv	s7,s1
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bdd5                	j	562 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	008b8493          	addi	s1,s7,8
 674:	4681                	li	a3,0
 676:	4641                	li	a2,16
 678:	000bb583          	ld	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	e03ff0ef          	jal	480 <printint>
        i += 1;
 682:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 684:	8ba6                	mv	s7,s1
      state = 0;
 686:	4981                	li	s3,0
 688:	bde9                	j	562 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68a:	008b8493          	addi	s1,s7,8
 68e:	4681                	li	a3,0
 690:	4641                	li	a2,16
 692:	000bb583          	ld	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	de9ff0ef          	jal	480 <printint>
        i += 2;
 69c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 69e:	8ba6                	mv	s7,s1
      state = 0;
 6a0:	4981                	li	s3,0
        i += 2;
 6a2:	b5c1                	j	562 <vprintf+0x44>
 6a4:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6a6:	008b8793          	addi	a5,s7,8
 6aa:	8cbe                	mv	s9,a5
 6ac:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b0:	03000593          	li	a1,48
 6b4:	855a                	mv	a0,s6
 6b6:	dadff0ef          	jal	462 <putc>
  putc(fd, 'x');
 6ba:	07800593          	li	a1,120
 6be:	855a                	mv	a0,s6
 6c0:	da3ff0ef          	jal	462 <putc>
 6c4:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c6:	00000b97          	auipc	s7,0x0
 6ca:	37ab8b93          	addi	s7,s7,890 # a40 <digits>
 6ce:	03c9d793          	srli	a5,s3,0x3c
 6d2:	97de                	add	a5,a5,s7
 6d4:	0007c583          	lbu	a1,0(a5)
 6d8:	855a                	mv	a0,s6
 6da:	d89ff0ef          	jal	462 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6de:	0992                	slli	s3,s3,0x4
 6e0:	34fd                	addiw	s1,s1,-1
 6e2:	f4f5                	bnez	s1,6ce <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6e4:	8be6                	mv	s7,s9
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	6ca2                	ld	s9,8(sp)
 6ea:	bda5                	j	562 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6ec:	008b8493          	addi	s1,s7,8
 6f0:	000bc583          	lbu	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	d6dff0ef          	jal	462 <putc>
 6fa:	8ba6                	mv	s7,s1
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b595                	j	562 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 700:	008b8993          	addi	s3,s7,8
 704:	000bb483          	ld	s1,0(s7)
 708:	cc91                	beqz	s1,724 <vprintf+0x206>
        for(; *s; s++)
 70a:	0004c583          	lbu	a1,0(s1)
 70e:	c985                	beqz	a1,73e <vprintf+0x220>
          putc(fd, *s);
 710:	855a                	mv	a0,s6
 712:	d51ff0ef          	jal	462 <putc>
        for(; *s; s++)
 716:	0485                	addi	s1,s1,1
 718:	0004c583          	lbu	a1,0(s1)
 71c:	f9f5                	bnez	a1,710 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 71e:	8bce                	mv	s7,s3
      state = 0;
 720:	4981                	li	s3,0
 722:	b581                	j	562 <vprintf+0x44>
          s = "(null)";
 724:	00000497          	auipc	s1,0x0
 728:	31448493          	addi	s1,s1,788 # a38 <malloc+0x178>
        for(; *s; s++)
 72c:	02800593          	li	a1,40
 730:	b7c5                	j	710 <vprintf+0x1f2>
        putc(fd, '%');
 732:	85be                	mv	a1,a5
 734:	855a                	mv	a0,s6
 736:	d2dff0ef          	jal	462 <putc>
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b51d                	j	562 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 73e:	8bce                	mv	s7,s3
      state = 0;
 740:	4981                	li	s3,0
 742:	b505                	j	562 <vprintf+0x44>
 744:	6906                	ld	s2,64(sp)
 746:	79e2                	ld	s3,56(sp)
 748:	7a42                	ld	s4,48(sp)
 74a:	7aa2                	ld	s5,40(sp)
 74c:	7b02                	ld	s6,32(sp)
 74e:	6be2                	ld	s7,24(sp)
 750:	6c42                	ld	s8,16(sp)
    }
  }
}
 752:	60e6                	ld	ra,88(sp)
 754:	6446                	ld	s0,80(sp)
 756:	64a6                	ld	s1,72(sp)
 758:	6125                	addi	sp,sp,96
 75a:	8082                	ret
      if(c0 == 'd'){
 75c:	06400713          	li	a4,100
 760:	e4e78fe3          	beq	a5,a4,5be <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 764:	f9478693          	addi	a3,a5,-108
 768:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 76c:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 76e:	4701                	li	a4,0
      } else if(c0 == 'u'){
 770:	07500513          	li	a0,117
 774:	e8a78ce3          	beq	a5,a0,60c <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 778:	f8b60513          	addi	a0,a2,-117
 77c:	e119                	bnez	a0,782 <vprintf+0x264>
 77e:	ea0693e3          	bnez	a3,624 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 782:	f8b58513          	addi	a0,a1,-117
 786:	e119                	bnez	a0,78c <vprintf+0x26e>
 788:	ea071be3          	bnez	a4,63e <vprintf+0x120>
      } else if(c0 == 'x'){
 78c:	07800513          	li	a0,120
 790:	eca784e3          	beq	a5,a0,658 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 794:	f8860613          	addi	a2,a2,-120
 798:	e219                	bnez	a2,79e <vprintf+0x280>
 79a:	ec069be3          	bnez	a3,670 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 79e:	f8858593          	addi	a1,a1,-120
 7a2:	e199                	bnez	a1,7a8 <vprintf+0x28a>
 7a4:	ee0713e3          	bnez	a4,68a <vprintf+0x16c>
      } else if(c0 == 'p'){
 7a8:	07000713          	li	a4,112
 7ac:	eee78ce3          	beq	a5,a4,6a4 <vprintf+0x186>
      } else if(c0 == 'c'){
 7b0:	06300713          	li	a4,99
 7b4:	f2e78ce3          	beq	a5,a4,6ec <vprintf+0x1ce>
      } else if(c0 == 's'){
 7b8:	07300713          	li	a4,115
 7bc:	f4e782e3          	beq	a5,a4,700 <vprintf+0x1e2>
      } else if(c0 == '%'){
 7c0:	02500713          	li	a4,37
 7c4:	f6e787e3          	beq	a5,a4,732 <vprintf+0x214>
        putc(fd, '%');
 7c8:	02500593          	li	a1,37
 7cc:	855a                	mv	a0,s6
 7ce:	c95ff0ef          	jal	462 <putc>
        putc(fd, c0);
 7d2:	85a6                	mv	a1,s1
 7d4:	855a                	mv	a0,s6
 7d6:	c8dff0ef          	jal	462 <putc>
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	b359                	j	562 <vprintf+0x44>

00000000000007de <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7de:	715d                	addi	sp,sp,-80
 7e0:	ec06                	sd	ra,24(sp)
 7e2:	e822                	sd	s0,16(sp)
 7e4:	1000                	addi	s0,sp,32
 7e6:	e010                	sd	a2,0(s0)
 7e8:	e414                	sd	a3,8(s0)
 7ea:	e818                	sd	a4,16(s0)
 7ec:	ec1c                	sd	a5,24(s0)
 7ee:	03043023          	sd	a6,32(s0)
 7f2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f6:	8622                	mv	a2,s0
 7f8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7fc:	d23ff0ef          	jal	51e <vprintf>
}
 800:	60e2                	ld	ra,24(sp)
 802:	6442                	ld	s0,16(sp)
 804:	6161                	addi	sp,sp,80
 806:	8082                	ret

0000000000000808 <printf>:

void
printf(const char *fmt, ...)
{
 808:	711d                	addi	sp,sp,-96
 80a:	ec06                	sd	ra,24(sp)
 80c:	e822                	sd	s0,16(sp)
 80e:	1000                	addi	s0,sp,32
 810:	e40c                	sd	a1,8(s0)
 812:	e810                	sd	a2,16(s0)
 814:	ec14                	sd	a3,24(s0)
 816:	f018                	sd	a4,32(s0)
 818:	f41c                	sd	a5,40(s0)
 81a:	03043823          	sd	a6,48(s0)
 81e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 822:	00840613          	addi	a2,s0,8
 826:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 82a:	85aa                	mv	a1,a0
 82c:	4505                	li	a0,1
 82e:	cf1ff0ef          	jal	51e <vprintf>
}
 832:	60e2                	ld	ra,24(sp)
 834:	6442                	ld	s0,16(sp)
 836:	6125                	addi	sp,sp,96
 838:	8082                	ret

000000000000083a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83a:	1141                	addi	sp,sp,-16
 83c:	e406                	sd	ra,8(sp)
 83e:	e022                	sd	s0,0(sp)
 840:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 842:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 846:	00000797          	auipc	a5,0x0
 84a:	7ca7b783          	ld	a5,1994(a5) # 1010 <freep>
 84e:	a039                	j	85c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 850:	6398                	ld	a4,0(a5)
 852:	00e7e463          	bltu	a5,a4,85a <free+0x20>
 856:	00e6ea63          	bltu	a3,a4,86a <free+0x30>
{
 85a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85c:	fed7fae3          	bgeu	a5,a3,850 <free+0x16>
 860:	6398                	ld	a4,0(a5)
 862:	00e6e463          	bltu	a3,a4,86a <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 866:	fee7eae3          	bltu	a5,a4,85a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 86a:	ff852583          	lw	a1,-8(a0)
 86e:	6390                	ld	a2,0(a5)
 870:	02059813          	slli	a6,a1,0x20
 874:	01c85713          	srli	a4,a6,0x1c
 878:	9736                	add	a4,a4,a3
 87a:	02e60563          	beq	a2,a4,8a4 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 87e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 882:	4790                	lw	a2,8(a5)
 884:	02061593          	slli	a1,a2,0x20
 888:	01c5d713          	srli	a4,a1,0x1c
 88c:	973e                	add	a4,a4,a5
 88e:	02e68263          	beq	a3,a4,8b2 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 892:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 894:	00000717          	auipc	a4,0x0
 898:	76f73e23          	sd	a5,1916(a4) # 1010 <freep>
}
 89c:	60a2                	ld	ra,8(sp)
 89e:	6402                	ld	s0,0(sp)
 8a0:	0141                	addi	sp,sp,16
 8a2:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8a4:	4618                	lw	a4,8(a2)
 8a6:	9f2d                	addw	a4,a4,a1
 8a8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ac:	6398                	ld	a4,0(a5)
 8ae:	6310                	ld	a2,0(a4)
 8b0:	b7f9                	j	87e <free+0x44>
    p->s.size += bp->s.size;
 8b2:	ff852703          	lw	a4,-8(a0)
 8b6:	9f31                	addw	a4,a4,a2
 8b8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ba:	ff053683          	ld	a3,-16(a0)
 8be:	bfd1                	j	892 <free+0x58>

00000000000008c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c0:	7139                	addi	sp,sp,-64
 8c2:	fc06                	sd	ra,56(sp)
 8c4:	f822                	sd	s0,48(sp)
 8c6:	f04a                	sd	s2,32(sp)
 8c8:	ec4e                	sd	s3,24(sp)
 8ca:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8cc:	02051993          	slli	s3,a0,0x20
 8d0:	0209d993          	srli	s3,s3,0x20
 8d4:	09bd                	addi	s3,s3,15
 8d6:	0049d993          	srli	s3,s3,0x4
 8da:	2985                	addiw	s3,s3,1
 8dc:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8de:	00000517          	auipc	a0,0x0
 8e2:	73253503          	ld	a0,1842(a0) # 1010 <freep>
 8e6:	c905                	beqz	a0,916 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ea:	4798                	lw	a4,8(a5)
 8ec:	09377663          	bgeu	a4,s3,978 <malloc+0xb8>
 8f0:	f426                	sd	s1,40(sp)
 8f2:	e852                	sd	s4,16(sp)
 8f4:	e456                	sd	s5,8(sp)
 8f6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8f8:	8a4e                	mv	s4,s3
 8fa:	6705                	lui	a4,0x1
 8fc:	00e9f363          	bgeu	s3,a4,902 <malloc+0x42>
 900:	6a05                	lui	s4,0x1
 902:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 906:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 90a:	00000497          	auipc	s1,0x0
 90e:	70648493          	addi	s1,s1,1798 # 1010 <freep>
  if(p == SBRK_ERROR)
 912:	5afd                	li	s5,-1
 914:	a83d                	j	952 <malloc+0x92>
 916:	f426                	sd	s1,40(sp)
 918:	e852                	sd	s4,16(sp)
 91a:	e456                	sd	s5,8(sp)
 91c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 91e:	00000797          	auipc	a5,0x0
 922:	70278793          	addi	a5,a5,1794 # 1020 <base>
 926:	00000717          	auipc	a4,0x0
 92a:	6ef73523          	sd	a5,1770(a4) # 1010 <freep>
 92e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 930:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 934:	b7d1                	j	8f8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 936:	6398                	ld	a4,0(a5)
 938:	e118                	sd	a4,0(a0)
 93a:	a899                	j	990 <malloc+0xd0>
  hp->s.size = nu;
 93c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 940:	0541                	addi	a0,a0,16
 942:	ef9ff0ef          	jal	83a <free>
  return freep;
 946:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 948:	c125                	beqz	a0,9a8 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94c:	4798                	lw	a4,8(a5)
 94e:	03277163          	bgeu	a4,s2,970 <malloc+0xb0>
    if(p == freep)
 952:	6098                	ld	a4,0(s1)
 954:	853e                	mv	a0,a5
 956:	fef71ae3          	bne	a4,a5,94a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 95a:	8552                	mv	a0,s4
 95c:	9e3ff0ef          	jal	33e <sbrk>
  if(p == SBRK_ERROR)
 960:	fd551ee3          	bne	a0,s5,93c <malloc+0x7c>
        return 0;
 964:	4501                	li	a0,0
 966:	74a2                	ld	s1,40(sp)
 968:	6a42                	ld	s4,16(sp)
 96a:	6aa2                	ld	s5,8(sp)
 96c:	6b02                	ld	s6,0(sp)
 96e:	a03d                	j	99c <malloc+0xdc>
 970:	74a2                	ld	s1,40(sp)
 972:	6a42                	ld	s4,16(sp)
 974:	6aa2                	ld	s5,8(sp)
 976:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 978:	fae90fe3          	beq	s2,a4,936 <malloc+0x76>
        p->s.size -= nunits;
 97c:	4137073b          	subw	a4,a4,s3
 980:	c798                	sw	a4,8(a5)
        p += p->s.size;
 982:	02071693          	slli	a3,a4,0x20
 986:	01c6d713          	srli	a4,a3,0x1c
 98a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 98c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 990:	00000717          	auipc	a4,0x0
 994:	68a73023          	sd	a0,1664(a4) # 1010 <freep>
      return (void*)(p + 1);
 998:	01078513          	addi	a0,a5,16
  }
}
 99c:	70e2                	ld	ra,56(sp)
 99e:	7442                	ld	s0,48(sp)
 9a0:	7902                	ld	s2,32(sp)
 9a2:	69e2                	ld	s3,24(sp)
 9a4:	6121                	addi	sp,sp,64
 9a6:	8082                	ret
 9a8:	74a2                	ld	s1,40(sp)
 9aa:	6a42                	ld	s4,16(sp)
 9ac:	6aa2                	ld	s5,8(sp)
 9ae:	6b02                	ld	s6,0(sp)
 9b0:	b7f5                	j	99c <malloc+0xdc>
