
user/_vmtest_full:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_stats>:
#define PGSIZE 4096
#define MAX_FRAMES 32

void
print_stats(int pid)
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	0880                	addi	s0,sp,80
   a:	84aa                	mv	s1,a0
  struct vmstats s;
  if(getvmstats(pid, &s) < 0){
   c:	fb040593          	addi	a1,s0,-80
  10:	654000ef          	jal	664 <getvmstats>
  14:	02054763          	bltz	a0,42 <print_stats+0x42>
    printf("  getvmstats failed for pid=%d\n", pid);
    return;
  }
  printf("  faults=%d evicted=%d swapped_in=%d swapped_out=%d resident=%d\n",
  18:	fc042783          	lw	a5,-64(s0)
  1c:	fbc42703          	lw	a4,-68(s0)
  20:	fb842683          	lw	a3,-72(s0)
  24:	fb442603          	lw	a2,-76(s0)
  28:	fb042583          	lw	a1,-80(s0)
  2c:	00001517          	auipc	a0,0x1
  30:	bc450513          	addi	a0,a0,-1084 # bf0 <malloc+0x11e>
  34:	1e7000ef          	jal	a1a <printf>
    s.page_faults, s.pages_evicted,
    s.pages_swapped_in, s.pages_swapped_out,
    s.resident_pages);
}
  38:	60a6                	ld	ra,72(sp)
  3a:	6406                	ld	s0,64(sp)
  3c:	74e2                	ld	s1,56(sp)
  3e:	6161                	addi	sp,sp,80
  40:	8082                	ret
    printf("  getvmstats failed for pid=%d\n", pid);
  42:	85a6                	mv	a1,s1
  44:	00001517          	auipc	a0,0x1
  48:	b8c50513          	addi	a0,a0,-1140 # bd0 <malloc+0xfe>
  4c:	1cf000ef          	jal	a1a <printf>
    return;
  50:	b7e5                	j	38 <print_stats+0x38>

0000000000000052 <test_pagefaults>:

// Test 1: trigger page faults only — stays within MAX_FRAMES
void
test_pagefaults(void)
{
  52:	1101                	addi	sp,sp,-32
  54:	ec06                	sd	ra,24(sp)
  56:	e822                	sd	s0,16(sp)
  58:	e426                	sd	s1,8(sp)
  5a:	1000                	addi	s0,sp,32
  printf("Test 1: page faults (10 pages, no eviction expected)\n");
  5c:	00001517          	auipc	a0,0x1
  60:	bdc50513          	addi	a0,a0,-1060 # c38 <malloc+0x166>
  64:	1b7000ef          	jal	a1a <printf>
  int pid = getpid();
  68:	59c000ef          	jal	604 <getpid>
  6c:	84aa                	mv	s1,a0
  char *p = sbrklazy(10 * PGSIZE);
  6e:	6529                	lui	a0,0xa
  70:	4f6000ef          	jal	566 <sbrklazy>
  74:	04100793          	li	a5,65
  for(int i = 0; i < 10; i++)
  78:	6685                	lui	a3,0x1
  7a:	04b00713          	li	a4,75
    p[i * PGSIZE] = 'A' + i;
  7e:	00f50023          	sb	a5,0(a0) # a000 <base+0x8ff0>
  for(int i = 0; i < 10; i++)
  82:	2785                	addiw	a5,a5,1
  84:	0ff7f793          	zext.b	a5,a5
  88:	9536                	add	a0,a0,a3
  8a:	fee79ae3          	bne	a5,a4,7e <test_pagefaults+0x2c>
  print_stats(pid);
  8e:	8526                	mv	a0,s1
  90:	f71ff0ef          	jal	0 <print_stats>
}
  94:	60e2                	ld	ra,24(sp)
  96:	6442                	ld	s0,16(sp)
  98:	64a2                	ld	s1,8(sp)
  9a:	6105                	addi	sp,sp,32
  9c:	8082                	ret

000000000000009e <test_eviction>:

// Test 2: force eviction — allocate well beyond MAX_FRAMES
void
test_eviction(void)
{
  9e:	1101                	addi	sp,sp,-32
  a0:	ec06                	sd	ra,24(sp)
  a2:	e822                	sd	s0,16(sp)
  a4:	e426                	sd	s1,8(sp)
  a6:	1000                	addi	s0,sp,32
  printf("Test 2: eviction (50 pages > MAX_FRAMES=%d)\n", MAX_FRAMES);
  a8:	02000593          	li	a1,32
  ac:	00001517          	auipc	a0,0x1
  b0:	bc450513          	addi	a0,a0,-1084 # c70 <malloc+0x19e>
  b4:	167000ef          	jal	a1a <printf>
  int pid = getpid();
  b8:	54c000ef          	jal	604 <getpid>
  bc:	84aa                	mv	s1,a0
  char *p = sbrklazy(50 * PGSIZE);
  be:	00032537          	lui	a0,0x32
  c2:	4a4000ef          	jal	566 <sbrklazy>
  for(int i = 0; i < 50; i++)
  c6:	4781                	li	a5,0
  c8:	6685                	lui	a3,0x1
  ca:	03200713          	li	a4,50
    p[i * PGSIZE] = (char)i;
  ce:	00f50023          	sb	a5,0(a0) # 32000 <base+0x30ff0>
  for(int i = 0; i < 50; i++)
  d2:	2785                	addiw	a5,a5,1
  d4:	9536                	add	a0,a0,a3
  d6:	fee79ce3          	bne	a5,a4,ce <test_eviction+0x30>
  print_stats(pid);
  da:	8526                	mv	a0,s1
  dc:	f25ff0ef          	jal	0 <print_stats>
}
  e0:	60e2                	ld	ra,24(sp)
  e2:	6442                	ld	s0,16(sp)
  e4:	64a2                	ld	s1,8(sp)
  e6:	6105                	addi	sp,sp,32
  e8:	8082                	ret

00000000000000ea <test_swapin>:

// Test 3: verify swap-in — re-access previously evicted pages
void
test_swapin(void)
{
  ea:	1101                	addi	sp,sp,-32
  ec:	ec06                	sd	ra,24(sp)
  ee:	e822                	sd	s0,16(sp)
  f0:	e426                	sd	s1,8(sp)
  f2:	1000                	addi	s0,sp,32
  printf("Test 3: swap-in + data integrity\n");
  f4:	00001517          	auipc	a0,0x1
  f8:	bbc50513          	addi	a0,a0,-1092 # cb0 <malloc+0x1de>
  fc:	11f000ef          	jal	a1a <printf>
  int pid = getpid();
 100:	504000ef          	jal	604 <getpid>
 104:	84aa                	mv	s1,a0
  char *p = sbrklazy(50 * PGSIZE);
 106:	00032537          	lui	a0,0x32
 10a:	45c000ef          	jal	566 <sbrklazy>
 10e:	872a                	mv	a4,a0

  for(int i = 0; i < 50; i++)
 110:	4781                	li	a5,0
 112:	6605                	lui	a2,0x1
 114:	03200693          	li	a3,50
    p[i * PGSIZE] = (char)i;
 118:	00f70023          	sb	a5,0(a4)
  for(int i = 0; i < 50; i++)
 11c:	2785                	addiw	a5,a5,1
 11e:	9732                	add	a4,a4,a2
 120:	fed79ce3          	bne	a5,a3,118 <test_swapin+0x2e>

  int ok = 1;
  for(int i = 0; i < 50; i++){
 124:	4581                	li	a1,0
 126:	6685                	lui	a3,0x1
 128:	03200713          	li	a4,50
    if(p[i * PGSIZE] != (char)i){
 12c:	00054603          	lbu	a2,0(a0) # 32000 <base+0x30ff0>
 130:	0ff5f793          	zext.b	a5,a1
 134:	00f61b63          	bne	a2,a5,14a <test_swapin+0x60>
  for(int i = 0; i < 50; i++){
 138:	2585                	addiw	a1,a1,1
 13a:	9536                	add	a0,a0,a3
 13c:	fee598e3          	bne	a1,a4,12c <test_swapin+0x42>
             i, (int)p[i * PGSIZE], i);
      ok = 0;
      break;
    }
  }
  printf("  data integrity: %s\n", ok ? "PASS" : "FAIL");
 140:	00001597          	auipc	a1,0x1
 144:	b6058593          	addi	a1,a1,-1184 # ca0 <malloc+0x1ce>
 148:	a821                	j	160 <test_swapin+0x76>
      printf("  FAIL at page %d: got %d expected %d\n",
 14a:	86ae                	mv	a3,a1
 14c:	00001517          	auipc	a0,0x1
 150:	b8c50513          	addi	a0,a0,-1140 # cd8 <malloc+0x206>
 154:	0c7000ef          	jal	a1a <printf>
  printf("  data integrity: %s\n", ok ? "PASS" : "FAIL");
 158:	00001597          	auipc	a1,0x1
 15c:	b5058593          	addi	a1,a1,-1200 # ca8 <malloc+0x1d6>
 160:	00001517          	auipc	a0,0x1
 164:	ba050513          	addi	a0,a0,-1120 # d00 <malloc+0x22e>
 168:	0b3000ef          	jal	a1a <printf>
  print_stats(pid);
 16c:	8526                	mv	a0,s1
 16e:	e93ff0ef          	jal	0 <print_stats>
}
 172:	60e2                	ld	ra,24(sp)
 174:	6442                	ld	s0,16(sp)
 176:	64a2                	ld	s1,8(sp)
 178:	6105                	addi	sp,sp,32
 17a:	8082                	ret

000000000000017c <test_priority>:

// Test 4: priority effect
void
test_priority(void)
{
 17c:	1101                	addi	sp,sp,-32
 17e:	ec06                	sd	ra,24(sp)
 180:	e822                	sd	s0,16(sp)
 182:	1000                	addi	s0,sp,32
  printf("Test 4: priority effect\n");
 184:	00001517          	auipc	a0,0x1
 188:	b9450513          	addi	a0,a0,-1132 # d18 <malloc+0x246>
 18c:	08f000ef          	jal	a1a <printf>
  int pid = fork();
 190:	3ec000ef          	jal	57c <fork>
  if(pid == 0){
 194:	cd15                	beqz	a0,1d0 <test_priority+0x54>
      p[i * PGSIZE] = (char)i;
    printf("  child stats (more evictions expected):\n");
    print_stats(getpid());
    exit(0);
  } else {
    char *p = sbrklazy(15 * PGSIZE);
 196:	653d                	lui	a0,0xf
 198:	3ce000ef          	jal	566 <sbrklazy>
    for(int i = 0; i < 15; i++)
 19c:	4781                	li	a5,0
 19e:	6685                	lui	a3,0x1
 1a0:	473d                	li	a4,15
      p[i * PGSIZE] = (char)i;
 1a2:	00f50023          	sb	a5,0(a0) # f000 <base+0xdff0>
    for(int i = 0; i < 15; i++)
 1a6:	2785                	addiw	a5,a5,1
 1a8:	9536                	add	a0,a0,a3
 1aa:	fee79ce3          	bne	a5,a4,1a2 <test_priority+0x26>

    printf("  parent stats (fewer evictions expected):\n");
 1ae:	00001517          	auipc	a0,0x1
 1b2:	bba50513          	addi	a0,a0,-1094 # d68 <malloc+0x296>
 1b6:	065000ef          	jal	a1a <printf>
    print_stats(getpid());
 1ba:	44a000ef          	jal	604 <getpid>
 1be:	e43ff0ef          	jal	0 <print_stats>

    wait(0);
 1c2:	4501                	li	a0,0
 1c4:	3c8000ef          	jal	58c <wait>
  }
}
 1c8:	60e2                	ld	ra,24(sp)
 1ca:	6442                	ld	s0,16(sp)
 1cc:	6105                	addi	sp,sp,32
 1ce:	8082                	ret
 1d0:	e426                	sd	s1,8(sp)
 1d2:	e04a                	sd	s2,0(sp)
 1d4:	84aa                	mv	s1,a0
 1d6:	1f400793          	li	a5,500
 1da:	893e                	mv	s2,a5
    for(int i = 0; i < 500; i++) getpid();
 1dc:	428000ef          	jal	604 <getpid>
 1e0:	fff9079b          	addiw	a5,s2,-1
 1e4:	893e                	mv	s2,a5
 1e6:	fbfd                	bnez	a5,1dc <test_priority+0x60>
    char *p = sbrklazy(60 * PGSIZE);
 1e8:	0003c537          	lui	a0,0x3c
 1ec:	37a000ef          	jal	566 <sbrklazy>
 1f0:	87aa                	mv	a5,a0
    for(int i = 0; i < 60; i++)
 1f2:	6685                	lui	a3,0x1
 1f4:	03c00713          	li	a4,60
      p[i * PGSIZE] = (char)i;
 1f8:	00978023          	sb	s1,0(a5)
    for(int i = 0; i < 60; i++)
 1fc:	0014861b          	addiw	a2,s1,1
 200:	84b2                	mv	s1,a2
 202:	97b6                	add	a5,a5,a3
 204:	fee61ae3          	bne	a2,a4,1f8 <test_priority+0x7c>
    printf("  child stats (more evictions expected):\n");
 208:	00001517          	auipc	a0,0x1
 20c:	b3050513          	addi	a0,a0,-1232 # d38 <malloc+0x266>
 210:	00b000ef          	jal	a1a <printf>
    print_stats(getpid());
 214:	3f0000ef          	jal	604 <getpid>
 218:	de9ff0ef          	jal	0 <print_stats>
    exit(0);
 21c:	4501                	li	a0,0
 21e:	366000ef          	jal	584 <exit>

0000000000000222 <main>:

int
main(void)
{
 222:	1141                	addi	sp,sp,-16
 224:	e406                	sd	ra,8(sp)
 226:	e022                	sd	s0,0(sp)
 228:	0800                	addi	s0,sp,16
  printf("=== PA3 VM Tests ===\n");
 22a:	00001517          	auipc	a0,0x1
 22e:	b6e50513          	addi	a0,a0,-1170 # d98 <malloc+0x2c6>
 232:	7e8000ef          	jal	a1a <printf>
  printf("MAX_FRAMES = %d\n\n", MAX_FRAMES);
 236:	02000593          	li	a1,32
 23a:	00001517          	auipc	a0,0x1
 23e:	b7650513          	addi	a0,a0,-1162 # db0 <malloc+0x2de>
 242:	7d8000ef          	jal	a1a <printf>

  int pid;

  pid = fork();
 246:	336000ef          	jal	57c <fork>
  if(pid == 0){ test_pagefaults(); exit(0); }
 24a:	e511                	bnez	a0,256 <main+0x34>
 24c:	e07ff0ef          	jal	52 <test_pagefaults>
 250:	4501                	li	a0,0
 252:	332000ef          	jal	584 <exit>
  wait(0);
 256:	4501                	li	a0,0
 258:	334000ef          	jal	58c <wait>
  printf("\n");
 25c:	00001517          	auipc	a0,0x1
 260:	b6450513          	addi	a0,a0,-1180 # dc0 <malloc+0x2ee>
 264:	7b6000ef          	jal	a1a <printf>

  pid = fork();
 268:	314000ef          	jal	57c <fork>
  if(pid == 0){ test_eviction(); exit(0); }
 26c:	e511                	bnez	a0,278 <main+0x56>
 26e:	e31ff0ef          	jal	9e <test_eviction>
 272:	4501                	li	a0,0
 274:	310000ef          	jal	584 <exit>
  wait(0);
 278:	4501                	li	a0,0
 27a:	312000ef          	jal	58c <wait>
  printf("\n");
 27e:	00001517          	auipc	a0,0x1
 282:	b4250513          	addi	a0,a0,-1214 # dc0 <malloc+0x2ee>
 286:	794000ef          	jal	a1a <printf>

  pid = fork();
 28a:	2f2000ef          	jal	57c <fork>
  if(pid == 0){ test_swapin(); exit(0); }
 28e:	e511                	bnez	a0,29a <main+0x78>
 290:	e5bff0ef          	jal	ea <test_swapin>
 294:	4501                	li	a0,0
 296:	2ee000ef          	jal	584 <exit>
  wait(0);
 29a:	4501                	li	a0,0
 29c:	2f0000ef          	jal	58c <wait>
  printf("\n");
 2a0:	00001517          	auipc	a0,0x1
 2a4:	b2050513          	addi	a0,a0,-1248 # dc0 <malloc+0x2ee>
 2a8:	772000ef          	jal	a1a <printf>

  test_priority();
 2ac:	ed1ff0ef          	jal	17c <test_priority>
  printf("\n");
 2b0:	00001517          	auipc	a0,0x1
 2b4:	b1050513          	addi	a0,a0,-1264 # dc0 <malloc+0x2ee>
 2b8:	762000ef          	jal	a1a <printf>

  printf("=== Done ===\n");
 2bc:	00001517          	auipc	a0,0x1
 2c0:	b0c50513          	addi	a0,a0,-1268 # dc8 <malloc+0x2f6>
 2c4:	756000ef          	jal	a1a <printf>
  exit(0);
 2c8:	4501                	li	a0,0
 2ca:	2ba000ef          	jal	584 <exit>

00000000000002ce <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 2d6:	f4dff0ef          	jal	222 <main>
  exit(r);
 2da:	2aa000ef          	jal	584 <exit>

00000000000002de <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2e6:	87aa                	mv	a5,a0
 2e8:	0585                	addi	a1,a1,1
 2ea:	0785                	addi	a5,a5,1
 2ec:	fff5c703          	lbu	a4,-1(a1)
 2f0:	fee78fa3          	sb	a4,-1(a5)
 2f4:	fb75                	bnez	a4,2e8 <strcpy+0xa>
    ;
  return os;
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 306:	00054783          	lbu	a5,0(a0)
 30a:	cb91                	beqz	a5,31e <strcmp+0x20>
 30c:	0005c703          	lbu	a4,0(a1)
 310:	00f71763          	bne	a4,a5,31e <strcmp+0x20>
    p++, q++;
 314:	0505                	addi	a0,a0,1
 316:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 318:	00054783          	lbu	a5,0(a0)
 31c:	fbe5                	bnez	a5,30c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 31e:	0005c503          	lbu	a0,0(a1)
}
 322:	40a7853b          	subw	a0,a5,a0
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret

000000000000032e <strlen>:

uint
strlen(const char *s)
{
 32e:	1141                	addi	sp,sp,-16
 330:	e406                	sd	ra,8(sp)
 332:	e022                	sd	s0,0(sp)
 334:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 336:	00054783          	lbu	a5,0(a0)
 33a:	cf91                	beqz	a5,356 <strlen+0x28>
 33c:	00150793          	addi	a5,a0,1
 340:	86be                	mv	a3,a5
 342:	0785                	addi	a5,a5,1
 344:	fff7c703          	lbu	a4,-1(a5)
 348:	ff65                	bnez	a4,340 <strlen+0x12>
 34a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 34e:	60a2                	ld	ra,8(sp)
 350:	6402                	ld	s0,0(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  for(n = 0; s[n]; n++)
 356:	4501                	li	a0,0
 358:	bfdd                	j	34e <strlen+0x20>

000000000000035a <memset>:

void*
memset(void *dst, int c, uint n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 362:	ca19                	beqz	a2,378 <memset+0x1e>
 364:	87aa                	mv	a5,a0
 366:	1602                	slli	a2,a2,0x20
 368:	9201                	srli	a2,a2,0x20
 36a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 36e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 372:	0785                	addi	a5,a5,1
 374:	fee79de3          	bne	a5,a4,36e <memset+0x14>
  }
  return dst;
}
 378:	60a2                	ld	ra,8(sp)
 37a:	6402                	ld	s0,0(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret

0000000000000380 <strchr>:

char*
strchr(const char *s, char c)
{
 380:	1141                	addi	sp,sp,-16
 382:	e406                	sd	ra,8(sp)
 384:	e022                	sd	s0,0(sp)
 386:	0800                	addi	s0,sp,16
  for(; *s; s++)
 388:	00054783          	lbu	a5,0(a0)
 38c:	cf81                	beqz	a5,3a4 <strchr+0x24>
    if(*s == c)
 38e:	00f58763          	beq	a1,a5,39c <strchr+0x1c>
  for(; *s; s++)
 392:	0505                	addi	a0,a0,1
 394:	00054783          	lbu	a5,0(a0)
 398:	fbfd                	bnez	a5,38e <strchr+0xe>
      return (char*)s;
  return 0;
 39a:	4501                	li	a0,0
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret
  return 0;
 3a4:	4501                	li	a0,0
 3a6:	bfdd                	j	39c <strchr+0x1c>

00000000000003a8 <gets>:

char*
gets(char *buf, int max)
{
 3a8:	711d                	addi	sp,sp,-96
 3aa:	ec86                	sd	ra,88(sp)
 3ac:	e8a2                	sd	s0,80(sp)
 3ae:	e4a6                	sd	s1,72(sp)
 3b0:	e0ca                	sd	s2,64(sp)
 3b2:	fc4e                	sd	s3,56(sp)
 3b4:	f852                	sd	s4,48(sp)
 3b6:	f456                	sd	s5,40(sp)
 3b8:	f05a                	sd	s6,32(sp)
 3ba:	ec5e                	sd	s7,24(sp)
 3bc:	e862                	sd	s8,16(sp)
 3be:	1080                	addi	s0,sp,96
 3c0:	8baa                	mv	s7,a0
 3c2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c4:	892a                	mv	s2,a0
 3c6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 3c8:	faf40b13          	addi	s6,s0,-81
 3cc:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 3ce:	8c26                	mv	s8,s1
 3d0:	0014899b          	addiw	s3,s1,1
 3d4:	84ce                	mv	s1,s3
 3d6:	0349d463          	bge	s3,s4,3fe <gets+0x56>
    cc = read(0, &c, 1);
 3da:	8656                	mv	a2,s5
 3dc:	85da                	mv	a1,s6
 3de:	4501                	li	a0,0
 3e0:	1bc000ef          	jal	59c <read>
    if(cc < 1)
 3e4:	00a05d63          	blez	a0,3fe <gets+0x56>
      break;
    buf[i++] = c;
 3e8:	faf44783          	lbu	a5,-81(s0)
 3ec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3f0:	0905                	addi	s2,s2,1
 3f2:	ff678713          	addi	a4,a5,-10
 3f6:	c319                	beqz	a4,3fc <gets+0x54>
 3f8:	17cd                	addi	a5,a5,-13
 3fa:	fbf1                	bnez	a5,3ce <gets+0x26>
    buf[i++] = c;
 3fc:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 3fe:	9c5e                	add	s8,s8,s7
 400:	000c0023          	sb	zero,0(s8)
  return buf;
}
 404:	855e                	mv	a0,s7
 406:	60e6                	ld	ra,88(sp)
 408:	6446                	ld	s0,80(sp)
 40a:	64a6                	ld	s1,72(sp)
 40c:	6906                	ld	s2,64(sp)
 40e:	79e2                	ld	s3,56(sp)
 410:	7a42                	ld	s4,48(sp)
 412:	7aa2                	ld	s5,40(sp)
 414:	7b02                	ld	s6,32(sp)
 416:	6be2                	ld	s7,24(sp)
 418:	6c42                	ld	s8,16(sp)
 41a:	6125                	addi	sp,sp,96
 41c:	8082                	ret

000000000000041e <stat>:

int
stat(const char *n, struct stat *st)
{
 41e:	1101                	addi	sp,sp,-32
 420:	ec06                	sd	ra,24(sp)
 422:	e822                	sd	s0,16(sp)
 424:	e04a                	sd	s2,0(sp)
 426:	1000                	addi	s0,sp,32
 428:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 42a:	4581                	li	a1,0
 42c:	198000ef          	jal	5c4 <open>
  if(fd < 0)
 430:	02054263          	bltz	a0,454 <stat+0x36>
 434:	e426                	sd	s1,8(sp)
 436:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 438:	85ca                	mv	a1,s2
 43a:	1a2000ef          	jal	5dc <fstat>
 43e:	892a                	mv	s2,a0
  close(fd);
 440:	8526                	mv	a0,s1
 442:	16a000ef          	jal	5ac <close>
  return r;
 446:	64a2                	ld	s1,8(sp)
}
 448:	854a                	mv	a0,s2
 44a:	60e2                	ld	ra,24(sp)
 44c:	6442                	ld	s0,16(sp)
 44e:	6902                	ld	s2,0(sp)
 450:	6105                	addi	sp,sp,32
 452:	8082                	ret
    return -1;
 454:	57fd                	li	a5,-1
 456:	893e                	mv	s2,a5
 458:	bfc5                	j	448 <stat+0x2a>

000000000000045a <atoi>:

int
atoi(const char *s)
{
 45a:	1141                	addi	sp,sp,-16
 45c:	e406                	sd	ra,8(sp)
 45e:	e022                	sd	s0,0(sp)
 460:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 462:	00054683          	lbu	a3,0(a0)
 466:	fd06879b          	addiw	a5,a3,-48 # fd0 <digits+0x1f0>
 46a:	0ff7f793          	zext.b	a5,a5
 46e:	4625                	li	a2,9
 470:	02f66963          	bltu	a2,a5,4a2 <atoi+0x48>
 474:	872a                	mv	a4,a0
  n = 0;
 476:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 478:	0705                	addi	a4,a4,1
 47a:	0025179b          	slliw	a5,a0,0x2
 47e:	9fa9                	addw	a5,a5,a0
 480:	0017979b          	slliw	a5,a5,0x1
 484:	9fb5                	addw	a5,a5,a3
 486:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 48a:	00074683          	lbu	a3,0(a4)
 48e:	fd06879b          	addiw	a5,a3,-48
 492:	0ff7f793          	zext.b	a5,a5
 496:	fef671e3          	bgeu	a2,a5,478 <atoi+0x1e>
  return n;
}
 49a:	60a2                	ld	ra,8(sp)
 49c:	6402                	ld	s0,0(sp)
 49e:	0141                	addi	sp,sp,16
 4a0:	8082                	ret
  n = 0;
 4a2:	4501                	li	a0,0
 4a4:	bfdd                	j	49a <atoi+0x40>

00000000000004a6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4a6:	1141                	addi	sp,sp,-16
 4a8:	e406                	sd	ra,8(sp)
 4aa:	e022                	sd	s0,0(sp)
 4ac:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ae:	02b57563          	bgeu	a0,a1,4d8 <memmove+0x32>
    while(n-- > 0)
 4b2:	00c05f63          	blez	a2,4d0 <memmove+0x2a>
 4b6:	1602                	slli	a2,a2,0x20
 4b8:	9201                	srli	a2,a2,0x20
 4ba:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4be:	872a                	mv	a4,a0
      *dst++ = *src++;
 4c0:	0585                	addi	a1,a1,1
 4c2:	0705                	addi	a4,a4,1
 4c4:	fff5c683          	lbu	a3,-1(a1)
 4c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4cc:	fee79ae3          	bne	a5,a4,4c0 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4d0:	60a2                	ld	ra,8(sp)
 4d2:	6402                	ld	s0,0(sp)
 4d4:	0141                	addi	sp,sp,16
 4d6:	8082                	ret
    while(n-- > 0)
 4d8:	fec05ce3          	blez	a2,4d0 <memmove+0x2a>
    dst += n;
 4dc:	00c50733          	add	a4,a0,a2
    src += n;
 4e0:	95b2                	add	a1,a1,a2
 4e2:	fff6079b          	addiw	a5,a2,-1 # fff <digits+0x21f>
 4e6:	1782                	slli	a5,a5,0x20
 4e8:	9381                	srli	a5,a5,0x20
 4ea:	fff7c793          	not	a5,a5
 4ee:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4f0:	15fd                	addi	a1,a1,-1
 4f2:	177d                	addi	a4,a4,-1
 4f4:	0005c683          	lbu	a3,0(a1)
 4f8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4fc:	fef71ae3          	bne	a4,a5,4f0 <memmove+0x4a>
 500:	bfc1                	j	4d0 <memmove+0x2a>

0000000000000502 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 502:	1141                	addi	sp,sp,-16
 504:	e406                	sd	ra,8(sp)
 506:	e022                	sd	s0,0(sp)
 508:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 50a:	c61d                	beqz	a2,538 <memcmp+0x36>
 50c:	1602                	slli	a2,a2,0x20
 50e:	9201                	srli	a2,a2,0x20
 510:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 514:	00054783          	lbu	a5,0(a0)
 518:	0005c703          	lbu	a4,0(a1)
 51c:	00e79863          	bne	a5,a4,52c <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 520:	0505                	addi	a0,a0,1
    p2++;
 522:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 524:	fed518e3          	bne	a0,a3,514 <memcmp+0x12>
  }
  return 0;
 528:	4501                	li	a0,0
 52a:	a019                	j	530 <memcmp+0x2e>
      return *p1 - *p2;
 52c:	40e7853b          	subw	a0,a5,a4
}
 530:	60a2                	ld	ra,8(sp)
 532:	6402                	ld	s0,0(sp)
 534:	0141                	addi	sp,sp,16
 536:	8082                	ret
  return 0;
 538:	4501                	li	a0,0
 53a:	bfdd                	j	530 <memcmp+0x2e>

000000000000053c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 53c:	1141                	addi	sp,sp,-16
 53e:	e406                	sd	ra,8(sp)
 540:	e022                	sd	s0,0(sp)
 542:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 544:	f63ff0ef          	jal	4a6 <memmove>
}
 548:	60a2                	ld	ra,8(sp)
 54a:	6402                	ld	s0,0(sp)
 54c:	0141                	addi	sp,sp,16
 54e:	8082                	ret

0000000000000550 <sbrk>:

char *
sbrk(int n) {
 550:	1141                	addi	sp,sp,-16
 552:	e406                	sd	ra,8(sp)
 554:	e022                	sd	s0,0(sp)
 556:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 558:	4585                	li	a1,1
 55a:	0b2000ef          	jal	60c <sys_sbrk>
}
 55e:	60a2                	ld	ra,8(sp)
 560:	6402                	ld	s0,0(sp)
 562:	0141                	addi	sp,sp,16
 564:	8082                	ret

0000000000000566 <sbrklazy>:

char *
sbrklazy(int n) {
 566:	1141                	addi	sp,sp,-16
 568:	e406                	sd	ra,8(sp)
 56a:	e022                	sd	s0,0(sp)
 56c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 56e:	4589                	li	a1,2
 570:	09c000ef          	jal	60c <sys_sbrk>
}
 574:	60a2                	ld	ra,8(sp)
 576:	6402                	ld	s0,0(sp)
 578:	0141                	addi	sp,sp,16
 57a:	8082                	ret

000000000000057c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 57c:	4885                	li	a7,1
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <exit>:
.global exit
exit:
 li a7, SYS_exit
 584:	4889                	li	a7,2
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <wait>:
.global wait
wait:
 li a7, SYS_wait
 58c:	488d                	li	a7,3
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 594:	4891                	li	a7,4
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <read>:
.global read
read:
 li a7, SYS_read
 59c:	4895                	li	a7,5
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <write>:
.global write
write:
 li a7, SYS_write
 5a4:	48c1                	li	a7,16
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <close>:
.global close
close:
 li a7, SYS_close
 5ac:	48d5                	li	a7,21
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5b4:	4899                	li	a7,6
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <exec>:
.global exec
exec:
 li a7, SYS_exec
 5bc:	489d                	li	a7,7
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <open>:
.global open
open:
 li a7, SYS_open
 5c4:	48bd                	li	a7,15
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5cc:	48c5                	li	a7,17
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5d4:	48c9                	li	a7,18
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5dc:	48a1                	li	a7,8
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <link>:
.global link
link:
 li a7, SYS_link
 5e4:	48cd                	li	a7,19
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ec:	48d1                	li	a7,20
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5f4:	48a5                	li	a7,9
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <dup>:
.global dup
dup:
 li a7, SYS_dup
 5fc:	48a9                	li	a7,10
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 604:	48ad                	li	a7,11
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 60c:	48b1                	li	a7,12
 ecall
 60e:	00000073          	ecall
 ret
 612:	8082                	ret

0000000000000614 <pause>:
.global pause
pause:
 li a7, SYS_pause
 614:	48b5                	li	a7,13
 ecall
 616:	00000073          	ecall
 ret
 61a:	8082                	ret

000000000000061c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 61c:	48b9                	li	a7,14
 ecall
 61e:	00000073          	ecall
 ret
 622:	8082                	ret

0000000000000624 <hello>:
.global hello
hello:
 li a7, SYS_hello
 624:	48d9                	li	a7,22
 ecall
 626:	00000073          	ecall
 ret
 62a:	8082                	ret

000000000000062c <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 62c:	48dd                	li	a7,23
 ecall
 62e:	00000073          	ecall
 ret
 632:	8082                	ret

0000000000000634 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 634:	48e1                	li	a7,24
 ecall
 636:	00000073          	ecall
 ret
 63a:	8082                	ret

000000000000063c <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 63c:	48e5                	li	a7,25
 ecall
 63e:	00000073          	ecall
 ret
 642:	8082                	ret

0000000000000644 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 644:	48e9                	li	a7,26
 ecall
 646:	00000073          	ecall
 ret
 64a:	8082                	ret

000000000000064c <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 64c:	48ed                	li	a7,27
 ecall
 64e:	00000073          	ecall
 ret
 652:	8082                	ret

0000000000000654 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 654:	48f1                	li	a7,28
 ecall
 656:	00000073          	ecall
 ret
 65a:	8082                	ret

000000000000065c <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 65c:	48f5                	li	a7,29
 ecall
 65e:	00000073          	ecall
 ret
 662:	8082                	ret

0000000000000664 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 664:	48f9                	li	a7,30
 ecall
 666:	00000073          	ecall
 ret
 66a:	8082                	ret

000000000000066c <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 66c:	48fd                	li	a7,31
 ecall
 66e:	00000073          	ecall
 ret
 672:	8082                	ret

0000000000000674 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 674:	1101                	addi	sp,sp,-32
 676:	ec06                	sd	ra,24(sp)
 678:	e822                	sd	s0,16(sp)
 67a:	1000                	addi	s0,sp,32
 67c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 680:	4605                	li	a2,1
 682:	fef40593          	addi	a1,s0,-17
 686:	f1fff0ef          	jal	5a4 <write>
}
 68a:	60e2                	ld	ra,24(sp)
 68c:	6442                	ld	s0,16(sp)
 68e:	6105                	addi	sp,sp,32
 690:	8082                	ret

0000000000000692 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 692:	715d                	addi	sp,sp,-80
 694:	e486                	sd	ra,72(sp)
 696:	e0a2                	sd	s0,64(sp)
 698:	f84a                	sd	s2,48(sp)
 69a:	f44e                	sd	s3,40(sp)
 69c:	0880                	addi	s0,sp,80
 69e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 6a0:	c6d1                	beqz	a3,72c <printint+0x9a>
 6a2:	0805d563          	bgez	a1,72c <printint+0x9a>
    neg = 1;
    x = -xx;
 6a6:	40b005b3          	neg	a1,a1
    neg = 1;
 6aa:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 6ac:	fb840993          	addi	s3,s0,-72
  neg = 0;
 6b0:	86ce                	mv	a3,s3
  i = 0;
 6b2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6b4:	00000817          	auipc	a6,0x0
 6b8:	72c80813          	addi	a6,a6,1836 # de0 <digits>
 6bc:	88ba                	mv	a7,a4
 6be:	0017051b          	addiw	a0,a4,1
 6c2:	872a                	mv	a4,a0
 6c4:	02c5f7b3          	remu	a5,a1,a2
 6c8:	97c2                	add	a5,a5,a6
 6ca:	0007c783          	lbu	a5,0(a5)
 6ce:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6d2:	87ae                	mv	a5,a1
 6d4:	02c5d5b3          	divu	a1,a1,a2
 6d8:	0685                	addi	a3,a3,1
 6da:	fec7f1e3          	bgeu	a5,a2,6bc <printint+0x2a>
  if(neg)
 6de:	00030c63          	beqz	t1,6f6 <printint+0x64>
    buf[i++] = '-';
 6e2:	fd050793          	addi	a5,a0,-48
 6e6:	00878533          	add	a0,a5,s0
 6ea:	02d00793          	li	a5,45
 6ee:	fef50423          	sb	a5,-24(a0)
 6f2:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 6f6:	02e05563          	blez	a4,720 <printint+0x8e>
 6fa:	fc26                	sd	s1,56(sp)
 6fc:	377d                	addiw	a4,a4,-1
 6fe:	00e984b3          	add	s1,s3,a4
 702:	19fd                	addi	s3,s3,-1
 704:	99ba                	add	s3,s3,a4
 706:	1702                	slli	a4,a4,0x20
 708:	9301                	srli	a4,a4,0x20
 70a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 70e:	0004c583          	lbu	a1,0(s1)
 712:	854a                	mv	a0,s2
 714:	f61ff0ef          	jal	674 <putc>
  while(--i >= 0)
 718:	14fd                	addi	s1,s1,-1
 71a:	ff349ae3          	bne	s1,s3,70e <printint+0x7c>
 71e:	74e2                	ld	s1,56(sp)
}
 720:	60a6                	ld	ra,72(sp)
 722:	6406                	ld	s0,64(sp)
 724:	7942                	ld	s2,48(sp)
 726:	79a2                	ld	s3,40(sp)
 728:	6161                	addi	sp,sp,80
 72a:	8082                	ret
  neg = 0;
 72c:	4301                	li	t1,0
 72e:	bfbd                	j	6ac <printint+0x1a>

0000000000000730 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 730:	711d                	addi	sp,sp,-96
 732:	ec86                	sd	ra,88(sp)
 734:	e8a2                	sd	s0,80(sp)
 736:	e4a6                	sd	s1,72(sp)
 738:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 73a:	0005c483          	lbu	s1,0(a1)
 73e:	22048363          	beqz	s1,964 <vprintf+0x234>
 742:	e0ca                	sd	s2,64(sp)
 744:	fc4e                	sd	s3,56(sp)
 746:	f852                	sd	s4,48(sp)
 748:	f456                	sd	s5,40(sp)
 74a:	f05a                	sd	s6,32(sp)
 74c:	ec5e                	sd	s7,24(sp)
 74e:	e862                	sd	s8,16(sp)
 750:	8b2a                	mv	s6,a0
 752:	8a2e                	mv	s4,a1
 754:	8bb2                	mv	s7,a2
  state = 0;
 756:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 758:	4901                	li	s2,0
 75a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 75c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 760:	06400c13          	li	s8,100
 764:	a00d                	j	786 <vprintf+0x56>
        putc(fd, c0);
 766:	85a6                	mv	a1,s1
 768:	855a                	mv	a0,s6
 76a:	f0bff0ef          	jal	674 <putc>
 76e:	a019                	j	774 <vprintf+0x44>
    } else if(state == '%'){
 770:	03598363          	beq	s3,s5,796 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 774:	0019079b          	addiw	a5,s2,1
 778:	893e                	mv	s2,a5
 77a:	873e                	mv	a4,a5
 77c:	97d2                	add	a5,a5,s4
 77e:	0007c483          	lbu	s1,0(a5)
 782:	1c048a63          	beqz	s1,956 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 786:	0004879b          	sext.w	a5,s1
    if(state == 0){
 78a:	fe0993e3          	bnez	s3,770 <vprintf+0x40>
      if(c0 == '%'){
 78e:	fd579ce3          	bne	a5,s5,766 <vprintf+0x36>
        state = '%';
 792:	89be                	mv	s3,a5
 794:	b7c5                	j	774 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 796:	00ea06b3          	add	a3,s4,a4
 79a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 79e:	1c060863          	beqz	a2,96e <vprintf+0x23e>
      if(c0 == 'd'){
 7a2:	03878763          	beq	a5,s8,7d0 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 7a6:	f9478693          	addi	a3,a5,-108
 7aa:	0016b693          	seqz	a3,a3
 7ae:	f9c60593          	addi	a1,a2,-100
 7b2:	e99d                	bnez	a1,7e8 <vprintf+0xb8>
 7b4:	ca95                	beqz	a3,7e8 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b6:	008b8493          	addi	s1,s7,8
 7ba:	4685                	li	a3,1
 7bc:	4629                	li	a2,10
 7be:	000bb583          	ld	a1,0(s7)
 7c2:	855a                	mv	a0,s6
 7c4:	ecfff0ef          	jal	692 <printint>
        i += 1;
 7c8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7ca:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 7cc:	4981                	li	s3,0
 7ce:	b75d                	j	774 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 7d0:	008b8493          	addi	s1,s7,8
 7d4:	4685                	li	a3,1
 7d6:	4629                	li	a2,10
 7d8:	000ba583          	lw	a1,0(s7)
 7dc:	855a                	mv	a0,s6
 7de:	eb5ff0ef          	jal	692 <printint>
 7e2:	8ba6                	mv	s7,s1
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	b779                	j	774 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 7e8:	9752                	add	a4,a4,s4
 7ea:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7ee:	f9460713          	addi	a4,a2,-108
 7f2:	00173713          	seqz	a4,a4
 7f6:	8f75                	and	a4,a4,a3
 7f8:	f9c58513          	addi	a0,a1,-100
 7fc:	18051363          	bnez	a0,982 <vprintf+0x252>
 800:	18070163          	beqz	a4,982 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 804:	008b8493          	addi	s1,s7,8
 808:	4685                	li	a3,1
 80a:	4629                	li	a2,10
 80c:	000bb583          	ld	a1,0(s7)
 810:	855a                	mv	a0,s6
 812:	e81ff0ef          	jal	692 <printint>
        i += 2;
 816:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 818:	8ba6                	mv	s7,s1
      state = 0;
 81a:	4981                	li	s3,0
        i += 2;
 81c:	bfa1                	j	774 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 81e:	008b8493          	addi	s1,s7,8
 822:	4681                	li	a3,0
 824:	4629                	li	a2,10
 826:	000be583          	lwu	a1,0(s7)
 82a:	855a                	mv	a0,s6
 82c:	e67ff0ef          	jal	692 <printint>
 830:	8ba6                	mv	s7,s1
      state = 0;
 832:	4981                	li	s3,0
 834:	b781                	j	774 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 836:	008b8493          	addi	s1,s7,8
 83a:	4681                	li	a3,0
 83c:	4629                	li	a2,10
 83e:	000bb583          	ld	a1,0(s7)
 842:	855a                	mv	a0,s6
 844:	e4fff0ef          	jal	692 <printint>
        i += 1;
 848:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 84a:	8ba6                	mv	s7,s1
      state = 0;
 84c:	4981                	li	s3,0
 84e:	b71d                	j	774 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 850:	008b8493          	addi	s1,s7,8
 854:	4681                	li	a3,0
 856:	4629                	li	a2,10
 858:	000bb583          	ld	a1,0(s7)
 85c:	855a                	mv	a0,s6
 85e:	e35ff0ef          	jal	692 <printint>
        i += 2;
 862:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 864:	8ba6                	mv	s7,s1
      state = 0;
 866:	4981                	li	s3,0
        i += 2;
 868:	b731                	j	774 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 86a:	008b8493          	addi	s1,s7,8
 86e:	4681                	li	a3,0
 870:	4641                	li	a2,16
 872:	000be583          	lwu	a1,0(s7)
 876:	855a                	mv	a0,s6
 878:	e1bff0ef          	jal	692 <printint>
 87c:	8ba6                	mv	s7,s1
      state = 0;
 87e:	4981                	li	s3,0
 880:	bdd5                	j	774 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 882:	008b8493          	addi	s1,s7,8
 886:	4681                	li	a3,0
 888:	4641                	li	a2,16
 88a:	000bb583          	ld	a1,0(s7)
 88e:	855a                	mv	a0,s6
 890:	e03ff0ef          	jal	692 <printint>
        i += 1;
 894:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 896:	8ba6                	mv	s7,s1
      state = 0;
 898:	4981                	li	s3,0
 89a:	bde9                	j	774 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 89c:	008b8493          	addi	s1,s7,8
 8a0:	4681                	li	a3,0
 8a2:	4641                	li	a2,16
 8a4:	000bb583          	ld	a1,0(s7)
 8a8:	855a                	mv	a0,s6
 8aa:	de9ff0ef          	jal	692 <printint>
        i += 2;
 8ae:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 8b0:	8ba6                	mv	s7,s1
      state = 0;
 8b2:	4981                	li	s3,0
        i += 2;
 8b4:	b5c1                	j	774 <vprintf+0x44>
 8b6:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 8b8:	008b8793          	addi	a5,s7,8
 8bc:	8cbe                	mv	s9,a5
 8be:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8c2:	03000593          	li	a1,48
 8c6:	855a                	mv	a0,s6
 8c8:	dadff0ef          	jal	674 <putc>
  putc(fd, 'x');
 8cc:	07800593          	li	a1,120
 8d0:	855a                	mv	a0,s6
 8d2:	da3ff0ef          	jal	674 <putc>
 8d6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8d8:	00000b97          	auipc	s7,0x0
 8dc:	508b8b93          	addi	s7,s7,1288 # de0 <digits>
 8e0:	03c9d793          	srli	a5,s3,0x3c
 8e4:	97de                	add	a5,a5,s7
 8e6:	0007c583          	lbu	a1,0(a5)
 8ea:	855a                	mv	a0,s6
 8ec:	d89ff0ef          	jal	674 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8f0:	0992                	slli	s3,s3,0x4
 8f2:	34fd                	addiw	s1,s1,-1
 8f4:	f4f5                	bnez	s1,8e0 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 8f6:	8be6                	mv	s7,s9
      state = 0;
 8f8:	4981                	li	s3,0
 8fa:	6ca2                	ld	s9,8(sp)
 8fc:	bda5                	j	774 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 8fe:	008b8493          	addi	s1,s7,8
 902:	000bc583          	lbu	a1,0(s7)
 906:	855a                	mv	a0,s6
 908:	d6dff0ef          	jal	674 <putc>
 90c:	8ba6                	mv	s7,s1
      state = 0;
 90e:	4981                	li	s3,0
 910:	b595                	j	774 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 912:	008b8993          	addi	s3,s7,8
 916:	000bb483          	ld	s1,0(s7)
 91a:	cc91                	beqz	s1,936 <vprintf+0x206>
        for(; *s; s++)
 91c:	0004c583          	lbu	a1,0(s1)
 920:	c985                	beqz	a1,950 <vprintf+0x220>
          putc(fd, *s);
 922:	855a                	mv	a0,s6
 924:	d51ff0ef          	jal	674 <putc>
        for(; *s; s++)
 928:	0485                	addi	s1,s1,1
 92a:	0004c583          	lbu	a1,0(s1)
 92e:	f9f5                	bnez	a1,922 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 930:	8bce                	mv	s7,s3
      state = 0;
 932:	4981                	li	s3,0
 934:	b581                	j	774 <vprintf+0x44>
          s = "(null)";
 936:	00000497          	auipc	s1,0x0
 93a:	4a248493          	addi	s1,s1,1186 # dd8 <malloc+0x306>
        for(; *s; s++)
 93e:	02800593          	li	a1,40
 942:	b7c5                	j	922 <vprintf+0x1f2>
        putc(fd, '%');
 944:	85be                	mv	a1,a5
 946:	855a                	mv	a0,s6
 948:	d2dff0ef          	jal	674 <putc>
      state = 0;
 94c:	4981                	li	s3,0
 94e:	b51d                	j	774 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 950:	8bce                	mv	s7,s3
      state = 0;
 952:	4981                	li	s3,0
 954:	b505                	j	774 <vprintf+0x44>
 956:	6906                	ld	s2,64(sp)
 958:	79e2                	ld	s3,56(sp)
 95a:	7a42                	ld	s4,48(sp)
 95c:	7aa2                	ld	s5,40(sp)
 95e:	7b02                	ld	s6,32(sp)
 960:	6be2                	ld	s7,24(sp)
 962:	6c42                	ld	s8,16(sp)
    }
  }
}
 964:	60e6                	ld	ra,88(sp)
 966:	6446                	ld	s0,80(sp)
 968:	64a6                	ld	s1,72(sp)
 96a:	6125                	addi	sp,sp,96
 96c:	8082                	ret
      if(c0 == 'd'){
 96e:	06400713          	li	a4,100
 972:	e4e78fe3          	beq	a5,a4,7d0 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 976:	f9478693          	addi	a3,a5,-108
 97a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 97e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 980:	4701                	li	a4,0
      } else if(c0 == 'u'){
 982:	07500513          	li	a0,117
 986:	e8a78ce3          	beq	a5,a0,81e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 98a:	f8b60513          	addi	a0,a2,-117
 98e:	e119                	bnez	a0,994 <vprintf+0x264>
 990:	ea0693e3          	bnez	a3,836 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 994:	f8b58513          	addi	a0,a1,-117
 998:	e119                	bnez	a0,99e <vprintf+0x26e>
 99a:	ea071be3          	bnez	a4,850 <vprintf+0x120>
      } else if(c0 == 'x'){
 99e:	07800513          	li	a0,120
 9a2:	eca784e3          	beq	a5,a0,86a <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 9a6:	f8860613          	addi	a2,a2,-120
 9aa:	e219                	bnez	a2,9b0 <vprintf+0x280>
 9ac:	ec069be3          	bnez	a3,882 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 9b0:	f8858593          	addi	a1,a1,-120
 9b4:	e199                	bnez	a1,9ba <vprintf+0x28a>
 9b6:	ee0713e3          	bnez	a4,89c <vprintf+0x16c>
      } else if(c0 == 'p'){
 9ba:	07000713          	li	a4,112
 9be:	eee78ce3          	beq	a5,a4,8b6 <vprintf+0x186>
      } else if(c0 == 'c'){
 9c2:	06300713          	li	a4,99
 9c6:	f2e78ce3          	beq	a5,a4,8fe <vprintf+0x1ce>
      } else if(c0 == 's'){
 9ca:	07300713          	li	a4,115
 9ce:	f4e782e3          	beq	a5,a4,912 <vprintf+0x1e2>
      } else if(c0 == '%'){
 9d2:	02500713          	li	a4,37
 9d6:	f6e787e3          	beq	a5,a4,944 <vprintf+0x214>
        putc(fd, '%');
 9da:	02500593          	li	a1,37
 9de:	855a                	mv	a0,s6
 9e0:	c95ff0ef          	jal	674 <putc>
        putc(fd, c0);
 9e4:	85a6                	mv	a1,s1
 9e6:	855a                	mv	a0,s6
 9e8:	c8dff0ef          	jal	674 <putc>
      state = 0;
 9ec:	4981                	li	s3,0
 9ee:	b359                	j	774 <vprintf+0x44>

00000000000009f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9f0:	715d                	addi	sp,sp,-80
 9f2:	ec06                	sd	ra,24(sp)
 9f4:	e822                	sd	s0,16(sp)
 9f6:	1000                	addi	s0,sp,32
 9f8:	e010                	sd	a2,0(s0)
 9fa:	e414                	sd	a3,8(s0)
 9fc:	e818                	sd	a4,16(s0)
 9fe:	ec1c                	sd	a5,24(s0)
 a00:	03043023          	sd	a6,32(s0)
 a04:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a08:	8622                	mv	a2,s0
 a0a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a0e:	d23ff0ef          	jal	730 <vprintf>
}
 a12:	60e2                	ld	ra,24(sp)
 a14:	6442                	ld	s0,16(sp)
 a16:	6161                	addi	sp,sp,80
 a18:	8082                	ret

0000000000000a1a <printf>:

void
printf(const char *fmt, ...)
{
 a1a:	711d                	addi	sp,sp,-96
 a1c:	ec06                	sd	ra,24(sp)
 a1e:	e822                	sd	s0,16(sp)
 a20:	1000                	addi	s0,sp,32
 a22:	e40c                	sd	a1,8(s0)
 a24:	e810                	sd	a2,16(s0)
 a26:	ec14                	sd	a3,24(s0)
 a28:	f018                	sd	a4,32(s0)
 a2a:	f41c                	sd	a5,40(s0)
 a2c:	03043823          	sd	a6,48(s0)
 a30:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a34:	00840613          	addi	a2,s0,8
 a38:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a3c:	85aa                	mv	a1,a0
 a3e:	4505                	li	a0,1
 a40:	cf1ff0ef          	jal	730 <vprintf>
}
 a44:	60e2                	ld	ra,24(sp)
 a46:	6442                	ld	s0,16(sp)
 a48:	6125                	addi	sp,sp,96
 a4a:	8082                	ret

0000000000000a4c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a4c:	1141                	addi	sp,sp,-16
 a4e:	e406                	sd	ra,8(sp)
 a50:	e022                	sd	s0,0(sp)
 a52:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a54:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a58:	00000797          	auipc	a5,0x0
 a5c:	5a87b783          	ld	a5,1448(a5) # 1000 <freep>
 a60:	a039                	j	a6e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a62:	6398                	ld	a4,0(a5)
 a64:	00e7e463          	bltu	a5,a4,a6c <free+0x20>
 a68:	00e6ea63          	bltu	a3,a4,a7c <free+0x30>
{
 a6c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a6e:	fed7fae3          	bgeu	a5,a3,a62 <free+0x16>
 a72:	6398                	ld	a4,0(a5)
 a74:	00e6e463          	bltu	a3,a4,a7c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a78:	fee7eae3          	bltu	a5,a4,a6c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a7c:	ff852583          	lw	a1,-8(a0)
 a80:	6390                	ld	a2,0(a5)
 a82:	02059813          	slli	a6,a1,0x20
 a86:	01c85713          	srli	a4,a6,0x1c
 a8a:	9736                	add	a4,a4,a3
 a8c:	02e60563          	beq	a2,a4,ab6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 a90:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 a94:	4790                	lw	a2,8(a5)
 a96:	02061593          	slli	a1,a2,0x20
 a9a:	01c5d713          	srli	a4,a1,0x1c
 a9e:	973e                	add	a4,a4,a5
 aa0:	02e68263          	beq	a3,a4,ac4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 aa4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 aa6:	00000717          	auipc	a4,0x0
 aaa:	54f73d23          	sd	a5,1370(a4) # 1000 <freep>
}
 aae:	60a2                	ld	ra,8(sp)
 ab0:	6402                	ld	s0,0(sp)
 ab2:	0141                	addi	sp,sp,16
 ab4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 ab6:	4618                	lw	a4,8(a2)
 ab8:	9f2d                	addw	a4,a4,a1
 aba:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 abe:	6398                	ld	a4,0(a5)
 ac0:	6310                	ld	a2,0(a4)
 ac2:	b7f9                	j	a90 <free+0x44>
    p->s.size += bp->s.size;
 ac4:	ff852703          	lw	a4,-8(a0)
 ac8:	9f31                	addw	a4,a4,a2
 aca:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 acc:	ff053683          	ld	a3,-16(a0)
 ad0:	bfd1                	j	aa4 <free+0x58>

0000000000000ad2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ad2:	7139                	addi	sp,sp,-64
 ad4:	fc06                	sd	ra,56(sp)
 ad6:	f822                	sd	s0,48(sp)
 ad8:	f04a                	sd	s2,32(sp)
 ada:	ec4e                	sd	s3,24(sp)
 adc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ade:	02051993          	slli	s3,a0,0x20
 ae2:	0209d993          	srli	s3,s3,0x20
 ae6:	09bd                	addi	s3,s3,15
 ae8:	0049d993          	srli	s3,s3,0x4
 aec:	2985                	addiw	s3,s3,1
 aee:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 af0:	00000517          	auipc	a0,0x0
 af4:	51053503          	ld	a0,1296(a0) # 1000 <freep>
 af8:	c905                	beqz	a0,b28 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 afa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 afc:	4798                	lw	a4,8(a5)
 afe:	09377663          	bgeu	a4,s3,b8a <malloc+0xb8>
 b02:	f426                	sd	s1,40(sp)
 b04:	e852                	sd	s4,16(sp)
 b06:	e456                	sd	s5,8(sp)
 b08:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b0a:	8a4e                	mv	s4,s3
 b0c:	6705                	lui	a4,0x1
 b0e:	00e9f363          	bgeu	s3,a4,b14 <malloc+0x42>
 b12:	6a05                	lui	s4,0x1
 b14:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b18:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b1c:	00000497          	auipc	s1,0x0
 b20:	4e448493          	addi	s1,s1,1252 # 1000 <freep>
  if(p == SBRK_ERROR)
 b24:	5afd                	li	s5,-1
 b26:	a83d                	j	b64 <malloc+0x92>
 b28:	f426                	sd	s1,40(sp)
 b2a:	e852                	sd	s4,16(sp)
 b2c:	e456                	sd	s5,8(sp)
 b2e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b30:	00000797          	auipc	a5,0x0
 b34:	4e078793          	addi	a5,a5,1248 # 1010 <base>
 b38:	00000717          	auipc	a4,0x0
 b3c:	4cf73423          	sd	a5,1224(a4) # 1000 <freep>
 b40:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b42:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b46:	b7d1                	j	b0a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b48:	6398                	ld	a4,0(a5)
 b4a:	e118                	sd	a4,0(a0)
 b4c:	a899                	j	ba2 <malloc+0xd0>
  hp->s.size = nu;
 b4e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b52:	0541                	addi	a0,a0,16
 b54:	ef9ff0ef          	jal	a4c <free>
  return freep;
 b58:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b5a:	c125                	beqz	a0,bba <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b5c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b5e:	4798                	lw	a4,8(a5)
 b60:	03277163          	bgeu	a4,s2,b82 <malloc+0xb0>
    if(p == freep)
 b64:	6098                	ld	a4,0(s1)
 b66:	853e                	mv	a0,a5
 b68:	fef71ae3          	bne	a4,a5,b5c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b6c:	8552                	mv	a0,s4
 b6e:	9e3ff0ef          	jal	550 <sbrk>
  if(p == SBRK_ERROR)
 b72:	fd551ee3          	bne	a0,s5,b4e <malloc+0x7c>
        return 0;
 b76:	4501                	li	a0,0
 b78:	74a2                	ld	s1,40(sp)
 b7a:	6a42                	ld	s4,16(sp)
 b7c:	6aa2                	ld	s5,8(sp)
 b7e:	6b02                	ld	s6,0(sp)
 b80:	a03d                	j	bae <malloc+0xdc>
 b82:	74a2                	ld	s1,40(sp)
 b84:	6a42                	ld	s4,16(sp)
 b86:	6aa2                	ld	s5,8(sp)
 b88:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b8a:	fae90fe3          	beq	s2,a4,b48 <malloc+0x76>
        p->s.size -= nunits;
 b8e:	4137073b          	subw	a4,a4,s3
 b92:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b94:	02071693          	slli	a3,a4,0x20
 b98:	01c6d713          	srli	a4,a3,0x1c
 b9c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b9e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ba2:	00000717          	auipc	a4,0x0
 ba6:	44a73f23          	sd	a0,1118(a4) # 1000 <freep>
      return (void*)(p + 1);
 baa:	01078513          	addi	a0,a5,16
  }
}
 bae:	70e2                	ld	ra,56(sp)
 bb0:	7442                	ld	s0,48(sp)
 bb2:	7902                	ld	s2,32(sp)
 bb4:	69e2                	ld	s3,24(sp)
 bb6:	6121                	addi	sp,sp,64
 bb8:	8082                	ret
 bba:	74a2                	ld	s1,40(sp)
 bbc:	6a42                	ld	s4,16(sp)
 bbe:	6aa2                	ld	s5,8(sp)
 bc0:	6b02                	ld	s6,0(sp)
 bc2:	b7f5                	j	bae <malloc+0xdc>
