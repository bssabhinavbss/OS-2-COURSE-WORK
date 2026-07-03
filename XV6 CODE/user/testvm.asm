
user/_testvm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_stats>:
#include "user/user.h"

#define PGSIZE 4096
#define MAX_FRAMES 32

void print_stats(char *msg) {
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	0880                	addi	s0,sp,80
   a:	84aa                	mv	s1,a0
  struct vmstats s;
  if(getvmstats(getpid(), &s) < 0){
   c:	01d000ef          	jal	828 <getpid>
  10:	fb040593          	addi	a1,s0,-80
  14:	075000ef          	jal	888 <getvmstats>
  18:	02054e63          	bltz	a0,54 <print_stats+0x54>
    printf("getvmstats failed\n");
    return;
  }
  printf("%s\n", msg);
  1c:	85a6                	mv	a1,s1
  1e:	00001517          	auipc	a0,0x1
  22:	f5250513          	addi	a0,a0,-174 # f70 <malloc+0x27a>
  26:	419000ef          	jal	c3e <printf>
  printf("faults=%d evicted=%d in=%d out=%d resident=%d\n",
  2a:	fc042783          	lw	a5,-64(s0)
  2e:	fbc42703          	lw	a4,-68(s0)
  32:	fb842683          	lw	a3,-72(s0)
  36:	fb442603          	lw	a2,-76(s0)
  3a:	fb042583          	lw	a1,-80(s0)
  3e:	00001517          	auipc	a0,0x1
  42:	dca50513          	addi	a0,a0,-566 # e08 <malloc+0x112>
  46:	3f9000ef          	jal	c3e <printf>
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
  58:	d9c50513          	addi	a0,a0,-612 # df0 <malloc+0xfa>
  5c:	3e3000ef          	jal	c3e <printf>
    return;
  60:	b7ed                	j	4a <print_stats+0x4a>

0000000000000062 <vmbasic>:

//////////////////////////////////////////////////////
// TEST 1: BASIC (fault + eviction + swap)
//////////////////////////////////////////////////////
void vmbasic() {
  62:	7171                	addi	sp,sp,-176
  64:	f506                	sd	ra,168(sp)
  66:	f122                	sd	s0,160(sp)
  68:	ed26                	sd	s1,152(sp)
  6a:	1900                	addi	s0,sp,176
  printf("\n=== Test 1: Basic VM ===\n");
  6c:	00001517          	auipc	a0,0x1
  70:	dcc50513          	addi	a0,a0,-564 # e38 <malloc+0x142>
  74:	3cb000ef          	jal	c3e <printf>

  int npages = 50;
  char *base = sbrklazy(npages * PGSIZE);
  78:	00032537          	lui	a0,0x32
  7c:	70e000ef          	jal	78a <sbrklazy>
  80:	84aa                	mv	s1,a0

  struct vmstats st1, st2, st3;

  getvmstats(getpid(), &st1);
  82:	7a6000ef          	jal	828 <getpid>
  86:	fb040593          	addi	a1,s0,-80
  8a:	7fe000ef          	jal	888 <getvmstats>

  for(int i = 0; i < npages; i++)
  8e:	8526                	mv	a0,s1
  90:	4781                	li	a5,0
  92:	6685                	lui	a3,0x1
  94:	03200713          	li	a4,50
    base[i * PGSIZE] = i;
  98:	00f50023          	sb	a5,0(a0) # 32000 <base+0x2fff0>
  for(int i = 0; i < npages; i++)
  9c:	2785                	addiw	a5,a5,1
  9e:	9536                	add	a0,a0,a3
  a0:	fee79ce3          	bne	a5,a4,98 <vmbasic+0x36>

  getvmstats(getpid(), &st2);
  a4:	784000ef          	jal	828 <getpid>
  a8:	f8040593          	addi	a1,s0,-128
  ac:	7dc000ef          	jal	888 <getvmstats>

  if(st2.page_faults <= st1.page_faults)
  b0:	f8042703          	lw	a4,-128(s0)
  b4:	fb042783          	lw	a5,-80(s0)
  b8:	04e7d863          	bge	a5,a4,108 <vmbasic+0xa6>
    printf("FAIL: faults not increasing\n");

  if(st2.pages_evicted == 0)
  bc:	f8442783          	lw	a5,-124(s0)
  c0:	cbb9                	beqz	a5,116 <vmbasic+0xb4>
    printf("FAIL: no eviction\n");

  if(st2.pages_swapped_out == 0)
  c2:	f8c42783          	lw	a5,-116(s0)
  c6:	cfb9                	beqz	a5,124 <vmbasic+0xc2>
    printf("FAIL: no swap-out\n");

  for(int i = 0; i < npages; i++){
  c8:	4581                	li	a1,0
  ca:	6685                	lui	a3,0x1
  cc:	03200713          	li	a4,50
    if(base[i * PGSIZE] != i){
  d0:	0004c783          	lbu	a5,0(s1)
  d4:	04b79f63          	bne	a5,a1,132 <vmbasic+0xd0>
  for(int i = 0; i < npages; i++){
  d8:	2585                	addiw	a1,a1,1
  da:	94b6                	add	s1,s1,a3
  dc:	fee59ae3          	bne	a1,a4,d0 <vmbasic+0x6e>
      printf("FAIL: data mismatch at %d\n", i);
      exit(1);
    }
  }

  getvmstats(getpid(), &st3);
  e0:	748000ef          	jal	828 <getpid>
  e4:	f5040593          	addi	a1,s0,-176
  e8:	7a0000ef          	jal	888 <getvmstats>

  if(st3.pages_swapped_in == 0)
  ec:	f5842783          	lw	a5,-168(s0)
  f0:	cbb1                	beqz	a5,144 <vmbasic+0xe2>
    printf("FAIL: no swap-in\n");

  printf("PASS\n");
  f2:	00001517          	auipc	a0,0x1
  f6:	dee50513          	addi	a0,a0,-530 # ee0 <malloc+0x1ea>
  fa:	345000ef          	jal	c3e <printf>
}
  fe:	70aa                	ld	ra,168(sp)
 100:	740a                	ld	s0,160(sp)
 102:	64ea                	ld	s1,152(sp)
 104:	614d                	addi	sp,sp,176
 106:	8082                	ret
    printf("FAIL: faults not increasing\n");
 108:	00001517          	auipc	a0,0x1
 10c:	d5050513          	addi	a0,a0,-688 # e58 <malloc+0x162>
 110:	32f000ef          	jal	c3e <printf>
 114:	b765                	j	bc <vmbasic+0x5a>
    printf("FAIL: no eviction\n");
 116:	00001517          	auipc	a0,0x1
 11a:	d6250513          	addi	a0,a0,-670 # e78 <malloc+0x182>
 11e:	321000ef          	jal	c3e <printf>
 122:	b745                	j	c2 <vmbasic+0x60>
    printf("FAIL: no swap-out\n");
 124:	00001517          	auipc	a0,0x1
 128:	d6c50513          	addi	a0,a0,-660 # e90 <malloc+0x19a>
 12c:	313000ef          	jal	c3e <printf>
 130:	bf61                	j	c8 <vmbasic+0x66>
      printf("FAIL: data mismatch at %d\n", i);
 132:	00001517          	auipc	a0,0x1
 136:	d7650513          	addi	a0,a0,-650 # ea8 <malloc+0x1b2>
 13a:	305000ef          	jal	c3e <printf>
      exit(1);
 13e:	4505                	li	a0,1
 140:	668000ef          	jal	7a8 <exit>
    printf("FAIL: no swap-in\n");
 144:	00001517          	auipc	a0,0x1
 148:	d8450513          	addi	a0,a0,-636 # ec8 <malloc+0x1d2>
 14c:	2f3000ef          	jal	c3e <printf>
 150:	b74d                	j	f2 <vmbasic+0x90>

0000000000000152 <vmfork>:

//////////////////////////////////////////////////////
// TEST 2: FORK + VM
//////////////////////////////////////////////////////
void vmfork() {
 152:	1101                	addi	sp,sp,-32
 154:	ec06                	sd	ra,24(sp)
 156:	e822                	sd	s0,16(sp)
 158:	e426                	sd	s1,8(sp)
 15a:	1000                	addi	s0,sp,32
  printf("\n=== Test 2: Fork ===\n");
 15c:	00001517          	auipc	a0,0x1
 160:	d8c50513          	addi	a0,a0,-628 # ee8 <malloc+0x1f2>
 164:	2db000ef          	jal	c3e <printf>

  int npages = 40;
  char *base = sbrklazy(npages * PGSIZE);
 168:	00028537          	lui	a0,0x28
 16c:	61e000ef          	jal	78a <sbrklazy>
 170:	84aa                	mv	s1,a0
 172:	872a                	mv	a4,a0
 174:	47a9                	li	a5,10

  for(int i = 0; i < npages; i++)
 176:	6605                	lui	a2,0x1
 178:	03200693          	li	a3,50
    base[i * PGSIZE] = i + 10;
 17c:	00f70023          	sb	a5,0(a4)
  for(int i = 0; i < npages; i++)
 180:	2785                	addiw	a5,a5,1
 182:	0ff7f793          	zext.b	a5,a5
 186:	9732                	add	a4,a4,a2
 188:	fed79ae3          	bne	a5,a3,17c <vmfork+0x2a>

  int pid = fork();
 18c:	614000ef          	jal	7a0 <fork>

  if(pid == 0){
 190:	ed1d                	bnez	a0,1ce <vmfork+0x7c>
 192:	47a9                	li	a5,10
    for(int i = 0; i < npages; i++){
 194:	6605                	lui	a2,0x1
 196:	03200693          	li	a3,50
      if(base[i * PGSIZE] != i + 10){
 19a:	0004c703          	lbu	a4,0(s1)
 19e:	00f71f63          	bne	a4,a5,1bc <vmfork+0x6a>
    for(int i = 0; i < npages; i++){
 1a2:	94b2                	add	s1,s1,a2
 1a4:	2785                	addiw	a5,a5,1
 1a6:	fed79ae3          	bne	a5,a3,19a <vmfork+0x48>
        printf("Child mismatch\n");
        exit(1);
      }
    }
    printf("Child OK\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	d6650513          	addi	a0,a0,-666 # f10 <malloc+0x21a>
 1b2:	28d000ef          	jal	c3e <printf>
    exit(0);
 1b6:	4501                	li	a0,0
 1b8:	5f0000ef          	jal	7a8 <exit>
        printf("Child mismatch\n");
 1bc:	00001517          	auipc	a0,0x1
 1c0:	d4450513          	addi	a0,a0,-700 # f00 <malloc+0x20a>
 1c4:	27b000ef          	jal	c3e <printf>
        exit(1);
 1c8:	4505                	li	a0,1
 1ca:	5de000ef          	jal	7a8 <exit>
  }

  wait(0);
 1ce:	4501                	li	a0,0
 1d0:	5e0000ef          	jal	7b0 <wait>
  printf("Parent OK\n");
 1d4:	00001517          	auipc	a0,0x1
 1d8:	d4c50513          	addi	a0,a0,-692 # f20 <malloc+0x22a>
 1dc:	263000ef          	jal	c3e <printf>
}
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	64a2                	ld	s1,8(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret

00000000000001ea <test_swapin>:

//////////////////////////////////////////////////////
// TEST 3: SWAP-IN
//////////////////////////////////////////////////////
void test_swapin() {
 1ea:	1141                	addi	sp,sp,-16
 1ec:	e406                	sd	ra,8(sp)
 1ee:	e022                	sd	s0,0(sp)
 1f0:	0800                	addi	s0,sp,16
  printf("\n=== Test 3: Swap-in ===\n");
 1f2:	00001517          	auipc	a0,0x1
 1f6:	d4e50513          	addi	a0,a0,-690 # f40 <malloc+0x24a>
 1fa:	245000ef          	jal	c3e <printf>

  char *p = sbrklazy(50 * PGSIZE);
 1fe:	00032537          	lui	a0,0x32
 202:	588000ef          	jal	78a <sbrklazy>
 206:	872a                	mv	a4,a0

  for(int i = 0; i < 50; i++)
 208:	4781                	li	a5,0
 20a:	6605                	lui	a2,0x1
 20c:	03200693          	li	a3,50
    p[i * PGSIZE] = i;
 210:	00f70023          	sb	a5,0(a4)
  for(int i = 0; i < 50; i++)
 214:	2785                	addiw	a5,a5,1
 216:	9732                	add	a4,a4,a2
 218:	fed79ce3          	bne	a5,a3,210 <test_swapin+0x26>

  int ok = 1;
  for(int i = 0; i < 50; i++){
 21c:	4781                	li	a5,0
 21e:	6605                	lui	a2,0x1
 220:	03200693          	li	a3,50
    if(p[i * PGSIZE] != i){
 224:	00054703          	lbu	a4,0(a0) # 32000 <base+0x2fff0>
 228:	00f71b63          	bne	a4,a5,23e <test_swapin+0x54>
  for(int i = 0; i < 50; i++){
 22c:	2785                	addiw	a5,a5,1
 22e:	9532                	add	a0,a0,a2
 230:	fed79ae3          	bne	a5,a3,224 <test_swapin+0x3a>
      ok = 0;
      break;
    }
  }

  printf("Data integrity: %s\n", ok ? "PASS" : "FAIL");
 234:	00001597          	auipc	a1,0x1
 238:	d0458593          	addi	a1,a1,-764 # f38 <malloc+0x242>
 23c:	a029                	j	246 <test_swapin+0x5c>
 23e:	00001597          	auipc	a1,0x1
 242:	cf258593          	addi	a1,a1,-782 # f30 <malloc+0x23a>
 246:	00001517          	auipc	a0,0x1
 24a:	d1a50513          	addi	a0,a0,-742 # f60 <malloc+0x26a>
 24e:	1f1000ef          	jal	c3e <printf>

  print_stats("After swap-in");
 252:	00001517          	auipc	a0,0x1
 256:	d2650513          	addi	a0,a0,-730 # f78 <malloc+0x282>
 25a:	da7ff0ef          	jal	0 <print_stats>
}
 25e:	60a2                	ld	ra,8(sp)
 260:	6402                	ld	s0,0(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret

0000000000000266 <test_shrink>:

//////////////////////////////////////////////////////
// TEST 4: SHRINK + REUSE
//////////////////////////////////////////////////////
void test_shrink() {
 266:	7159                	addi	sp,sp,-112
 268:	f486                	sd	ra,104(sp)
 26a:	f0a2                	sd	s0,96(sp)
 26c:	1880                	addi	s0,sp,112
  printf("\n=== Test 4: Shrink ===\n");
 26e:	00001517          	auipc	a0,0x1
 272:	d1a50513          	addi	a0,a0,-742 # f88 <malloc+0x292>
 276:	1c9000ef          	jal	c3e <printf>

  struct vmstats st1, st2;

  getvmstats(getpid(), &st1);
 27a:	5ae000ef          	jal	828 <getpid>
 27e:	fc040593          	addi	a1,s0,-64
 282:	606000ef          	jal	888 <getvmstats>

  char *p = sbrklazy(20 * PGSIZE);
 286:	6551                	lui	a0,0x14
 288:	502000ef          	jal	78a <sbrklazy>

  for(int i = 0; i < 20; i++)
 28c:	4781                	li	a5,0
 28e:	6685                	lui	a3,0x1
 290:	4751                	li	a4,20
    p[i * PGSIZE] = i;
 292:	00f50023          	sb	a5,0(a0) # 14000 <base+0x11ff0>
  for(int i = 0; i < 20; i++)
 296:	2785                	addiw	a5,a5,1
 298:	9536                	add	a0,a0,a3
 29a:	fee79ce3          	bne	a5,a4,292 <test_shrink+0x2c>

  sbrklazy(-20 * PGSIZE);
 29e:	7531                	lui	a0,0xfffec
 2a0:	4ea000ef          	jal	78a <sbrklazy>

  getvmstats(getpid(), &st2);
 2a4:	584000ef          	jal	828 <getpid>
 2a8:	f9040593          	addi	a1,s0,-112
 2ac:	5dc000ef          	jal	888 <getvmstats>

  if(st2.resident_pages != st1.resident_pages)
 2b0:	fa042703          	lw	a4,-96(s0)
 2b4:	fd042783          	lw	a5,-48(s0)
 2b8:	02f70e63          	beq	a4,a5,2f4 <test_shrink+0x8e>
    printf("FAIL: memory leak\n");
 2bc:	00001517          	auipc	a0,0x1
 2c0:	cec50513          	addi	a0,a0,-788 # fa8 <malloc+0x2b2>
 2c4:	17b000ef          	jal	c3e <printf>
  else
    printf("PASS: freed correctly\n");

  char *p2 = sbrklazy(20 * PGSIZE);
 2c8:	6551                	lui	a0,0x14
 2ca:	4c0000ef          	jal	78a <sbrklazy>
  for(int i = 0; i < 20; i++)
 2ce:	4781                	li	a5,0
 2d0:	6685                	lui	a3,0x1
 2d2:	4751                	li	a4,20
    p2[i * PGSIZE] = i;
 2d4:	00f50023          	sb	a5,0(a0) # 14000 <base+0x11ff0>
  for(int i = 0; i < 20; i++)
 2d8:	2785                	addiw	a5,a5,1
 2da:	9536                	add	a0,a0,a3
 2dc:	fee79ce3          	bne	a5,a4,2d4 <test_shrink+0x6e>

  printf("Reuse successful\n");
 2e0:	00001517          	auipc	a0,0x1
 2e4:	cf850513          	addi	a0,a0,-776 # fd8 <malloc+0x2e2>
 2e8:	157000ef          	jal	c3e <printf>
}
 2ec:	70a6                	ld	ra,104(sp)
 2ee:	7406                	ld	s0,96(sp)
 2f0:	6165                	addi	sp,sp,112
 2f2:	8082                	ret
    printf("PASS: freed correctly\n");
 2f4:	00001517          	auipc	a0,0x1
 2f8:	ccc50513          	addi	a0,a0,-820 # fc0 <malloc+0x2ca>
 2fc:	143000ef          	jal	c3e <printf>
 300:	b7e1                	j	2c8 <test_shrink+0x62>

0000000000000302 <test_thrashing>:

//////////////////////////////////////////////////////
// TEST 5: THRASHING
//////////////////////////////////////////////////////
void test_thrashing() {
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  printf("\n=== Test 5: Thrashing ===\n");
 30a:	00001517          	auipc	a0,0x1
 30e:	ce650513          	addi	a0,a0,-794 # ff0 <malloc+0x2fa>
 312:	12d000ef          	jal	c3e <printf>

  int pages = 33;
  char *p = sbrklazy(pages * PGSIZE);
 316:	00021537          	lui	a0,0x21
 31a:	470000ef          	jal	78a <sbrklazy>

  for(int i = 0; i < pages; i++)
 31e:	000216b7          	lui	a3,0x21
 322:	96aa                	add	a3,a3,a0
  char *p = sbrklazy(pages * PGSIZE);
 324:	87aa                	mv	a5,a0
    p[i * PGSIZE] = 1;
 326:	4605                	li	a2,1
  for(int i = 0; i < pages; i++)
 328:	6705                	lui	a4,0x1
    p[i * PGSIZE] = 1;
 32a:	00c78023          	sb	a2,0(a5)
  for(int i = 0; i < pages; i++)
 32e:	97ba                	add	a5,a5,a4
 330:	fed79de3          	bne	a5,a3,32a <test_thrashing+0x28>
 334:	4595                	li	a1,5

  for(int k = 0; k < 5; k++){
    for(int i = 0; i < pages; i++)
 336:	6605                	lui	a2,0x1
  char *p = sbrklazy(pages * PGSIZE);
 338:	87aa                	mv	a5,a0
      p[i * PGSIZE]++;
 33a:	0007c703          	lbu	a4,0(a5)
 33e:	2705                	addiw	a4,a4,1 # 1001 <malloc+0x30b>
 340:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < pages; i++)
 344:	97b2                	add	a5,a5,a2
 346:	fed79ae3          	bne	a5,a3,33a <test_thrashing+0x38>
  for(int k = 0; k < 5; k++){
 34a:	35fd                	addiw	a1,a1,-1
 34c:	f5f5                	bnez	a1,338 <test_thrashing+0x36>
  }

  print_stats("After thrashing");
 34e:	00001517          	auipc	a0,0x1
 352:	cc250513          	addi	a0,a0,-830 # 1010 <malloc+0x31a>
 356:	cabff0ef          	jal	0 <print_stats>
}
 35a:	60a2                	ld	ra,8(sp)
 35c:	6402                	ld	s0,0(sp)
 35e:	0141                	addi	sp,sp,16
 360:	8082                	ret

0000000000000362 <test_exec_cleanup>:

//////////////////////////////////////////////////////
// TEST 6: EXEC CLEANUP
//////////////////////////////////////////////////////
void test_exec_cleanup() {
 362:	7179                	addi	sp,sp,-48
 364:	f406                	sd	ra,40(sp)
 366:	f022                	sd	s0,32(sp)
 368:	1800                	addi	s0,sp,48
  printf("\n=== Test 6: Exec cleanup ===\n");
 36a:	00001517          	auipc	a0,0x1
 36e:	cb650513          	addi	a0,a0,-842 # 1020 <malloc+0x32a>
 372:	0cd000ef          	jal	c3e <printf>

  int pid = fork();
 376:	42a000ef          	jal	7a0 <fork>

  if(pid == 0){
 37a:	cd11                	beqz	a0,396 <test_exec_cleanup+0x34>
    char *args[] = {"echo", "Exec test", 0};
    exec("echo", args);
    exit(1);
  }

  wait(0);
 37c:	4501                	li	a0,0
 37e:	432000ef          	jal	7b0 <wait>
  printf("Exec cleanup OK\n");
 382:	00001517          	auipc	a0,0x1
 386:	cd650513          	addi	a0,a0,-810 # 1058 <malloc+0x362>
 38a:	0b5000ef          	jal	c3e <printf>
}
 38e:	70a2                	ld	ra,40(sp)
 390:	7402                	ld	s0,32(sp)
 392:	6145                	addi	sp,sp,48
 394:	8082                	ret
    char *p = sbrklazy(42 * PGSIZE);
 396:	0002a537          	lui	a0,0x2a
 39a:	3f0000ef          	jal	78a <sbrklazy>
 39e:	87aa                	mv	a5,a0
    for(int i = 0; i < 42; i++)
 3a0:	0002a737          	lui	a4,0x2a
 3a4:	972a                	add	a4,a4,a0
      p[i * PGSIZE] = 'z';
 3a6:	07a00613          	li	a2,122
    for(int i = 0; i < 42; i++)
 3aa:	6685                	lui	a3,0x1
      p[i * PGSIZE] = 'z';
 3ac:	00c78023          	sb	a2,0(a5)
    for(int i = 0; i < 42; i++)
 3b0:	97b6                	add	a5,a5,a3
 3b2:	fee79de3          	bne	a5,a4,3ac <test_exec_cleanup+0x4a>
    char *args[] = {"echo", "Exec test", 0};
 3b6:	00001797          	auipc	a5,0x1
 3ba:	c8a78793          	addi	a5,a5,-886 # 1040 <malloc+0x34a>
 3be:	fcf43c23          	sd	a5,-40(s0)
 3c2:	00001797          	auipc	a5,0x1
 3c6:	c8678793          	addi	a5,a5,-890 # 1048 <malloc+0x352>
 3ca:	fef43023          	sd	a5,-32(s0)
 3ce:	fe043423          	sd	zero,-24(s0)
    exec("echo", args);
 3d2:	fd840593          	addi	a1,s0,-40
 3d6:	00001517          	auipc	a0,0x1
 3da:	c6a50513          	addi	a0,a0,-918 # 1040 <malloc+0x34a>
 3de:	402000ef          	jal	7e0 <exec>
    exit(1);
 3e2:	4505                	li	a0,1
 3e4:	3c4000ef          	jal	7a8 <exit>

00000000000003e8 <edge_recursive_swap>:

//////////////////////////////////////////////////////
// TEST 7: EDGE SWAP-IN TRIGGER
//////////////////////////////////////////////////////
void edge_recursive_swap() {
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e406                	sd	ra,8(sp)
 3ec:	e022                	sd	s0,0(sp)
 3ee:	0800                	addi	s0,sp,16
  printf("\n=== Test 7: Recursive swap ===\n");
 3f0:	00001517          	auipc	a0,0x1
 3f4:	c8050513          	addi	a0,a0,-896 # 1070 <malloc+0x37a>
 3f8:	047000ef          	jal	c3e <printf>

  char *p = sbrklazy(40 * PGSIZE);
 3fc:	00028537          	lui	a0,0x28
 400:	38a000ef          	jal	78a <sbrklazy>

  for(int i = 0; i < 40; i++)
 404:	872a                	mv	a4,a0
 406:	4781                	li	a5,0
 408:	6605                	lui	a2,0x1
 40a:	02800693          	li	a3,40
    p[i * PGSIZE] = i;
 40e:	00f70023          	sb	a5,0(a4) # 2a000 <base+0x27ff0>
  for(int i = 0; i < 40; i++)
 412:	2785                	addiw	a5,a5,1
 414:	9732                	add	a4,a4,a2
 416:	fed79ce3          	bne	a5,a3,40e <edge_recursive_swap+0x26>

  char val = p[0];

  printf("Value=%d (should be 0)\n", val);
 41a:	00054583          	lbu	a1,0(a0) # 28000 <base+0x25ff0>
 41e:	00001517          	auipc	a0,0x1
 422:	c7a50513          	addi	a0,a0,-902 # 1098 <malloc+0x3a2>
 426:	019000ef          	jal	c3e <printf>
}
 42a:	60a2                	ld	ra,8(sp)
 42c:	6402                	ld	s0,0(sp)
 42e:	0141                	addi	sp,sp,16
 430:	8082                	ret

0000000000000432 <main>:

//////////////////////////////////////////////////////
// MAIN
//////////////////////////////////////////////////////
int main() {
 432:	1141                	addi	sp,sp,-16
 434:	e406                	sd	ra,8(sp)
 436:	e022                	sd	s0,0(sp)
 438:	0800                	addi	s0,sp,16
  printf("\n===== VM TEST SUITE =====\n");
 43a:	00001517          	auipc	a0,0x1
 43e:	c7650513          	addi	a0,a0,-906 # 10b0 <malloc+0x3ba>
 442:	7fc000ef          	jal	c3e <printf>

  if(fork() == 0){ vmbasic(); exit(0); } wait(0);
 446:	35a000ef          	jal	7a0 <fork>
 44a:	e511                	bnez	a0,456 <main+0x24>
 44c:	c17ff0ef          	jal	62 <vmbasic>
 450:	4501                	li	a0,0
 452:	356000ef          	jal	7a8 <exit>
 456:	4501                	li	a0,0
 458:	358000ef          	jal	7b0 <wait>
  if(fork() == 0){ vmfork(); exit(0); } wait(0);
 45c:	344000ef          	jal	7a0 <fork>
 460:	e511                	bnez	a0,46c <main+0x3a>
 462:	cf1ff0ef          	jal	152 <vmfork>
 466:	4501                	li	a0,0
 468:	340000ef          	jal	7a8 <exit>
 46c:	4501                	li	a0,0
 46e:	342000ef          	jal	7b0 <wait>
  if(fork() == 0){ test_swapin(); exit(0); } wait(0);
 472:	32e000ef          	jal	7a0 <fork>
 476:	e511                	bnez	a0,482 <main+0x50>
 478:	d73ff0ef          	jal	1ea <test_swapin>
 47c:	4501                	li	a0,0
 47e:	32a000ef          	jal	7a8 <exit>
 482:	4501                	li	a0,0
 484:	32c000ef          	jal	7b0 <wait>
  if(fork() == 0){ test_shrink(); exit(0); } wait(0);
 488:	318000ef          	jal	7a0 <fork>
 48c:	e511                	bnez	a0,498 <main+0x66>
 48e:	dd9ff0ef          	jal	266 <test_shrink>
 492:	4501                	li	a0,0
 494:	314000ef          	jal	7a8 <exit>
 498:	4501                	li	a0,0
 49a:	316000ef          	jal	7b0 <wait>
  if(fork() == 0){ test_thrashing(); exit(0); } wait(0);
 49e:	302000ef          	jal	7a0 <fork>
 4a2:	e511                	bnez	a0,4ae <main+0x7c>
 4a4:	e5fff0ef          	jal	302 <test_thrashing>
 4a8:	4501                	li	a0,0
 4aa:	2fe000ef          	jal	7a8 <exit>
 4ae:	4501                	li	a0,0
 4b0:	300000ef          	jal	7b0 <wait>
  if(fork() == 0){ test_exec_cleanup(); exit(0); } wait(0);
 4b4:	2ec000ef          	jal	7a0 <fork>
 4b8:	e511                	bnez	a0,4c4 <main+0x92>
 4ba:	ea9ff0ef          	jal	362 <test_exec_cleanup>
 4be:	4501                	li	a0,0
 4c0:	2e8000ef          	jal	7a8 <exit>
 4c4:	4501                	li	a0,0
 4c6:	2ea000ef          	jal	7b0 <wait>
  if(fork() == 0){ edge_recursive_swap(); exit(0); } wait(0);
 4ca:	2d6000ef          	jal	7a0 <fork>
 4ce:	e511                	bnez	a0,4da <main+0xa8>
 4d0:	f19ff0ef          	jal	3e8 <edge_recursive_swap>
 4d4:	4501                	li	a0,0
 4d6:	2d2000ef          	jal	7a8 <exit>
 4da:	4501                	li	a0,0
 4dc:	2d4000ef          	jal	7b0 <wait>

  printf("\n===== ALL TESTS DONE =====\n");
 4e0:	00001517          	auipc	a0,0x1
 4e4:	bf050513          	addi	a0,a0,-1040 # 10d0 <malloc+0x3da>
 4e8:	756000ef          	jal	c3e <printf>
  exit(0);
 4ec:	4501                	li	a0,0
 4ee:	2ba000ef          	jal	7a8 <exit>

00000000000004f2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 4f2:	1141                	addi	sp,sp,-16
 4f4:	e406                	sd	ra,8(sp)
 4f6:	e022                	sd	s0,0(sp)
 4f8:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 4fa:	f39ff0ef          	jal	432 <main>
  exit(r);
 4fe:	2aa000ef          	jal	7a8 <exit>

0000000000000502 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 502:	1141                	addi	sp,sp,-16
 504:	e406                	sd	ra,8(sp)
 506:	e022                	sd	s0,0(sp)
 508:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 50a:	87aa                	mv	a5,a0
 50c:	0585                	addi	a1,a1,1
 50e:	0785                	addi	a5,a5,1
 510:	fff5c703          	lbu	a4,-1(a1)
 514:	fee78fa3          	sb	a4,-1(a5)
 518:	fb75                	bnez	a4,50c <strcpy+0xa>
    ;
  return os;
}
 51a:	60a2                	ld	ra,8(sp)
 51c:	6402                	ld	s0,0(sp)
 51e:	0141                	addi	sp,sp,16
 520:	8082                	ret

0000000000000522 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 522:	1141                	addi	sp,sp,-16
 524:	e406                	sd	ra,8(sp)
 526:	e022                	sd	s0,0(sp)
 528:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 52a:	00054783          	lbu	a5,0(a0)
 52e:	cb91                	beqz	a5,542 <strcmp+0x20>
 530:	0005c703          	lbu	a4,0(a1)
 534:	00f71763          	bne	a4,a5,542 <strcmp+0x20>
    p++, q++;
 538:	0505                	addi	a0,a0,1
 53a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 53c:	00054783          	lbu	a5,0(a0)
 540:	fbe5                	bnez	a5,530 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 542:	0005c503          	lbu	a0,0(a1)
}
 546:	40a7853b          	subw	a0,a5,a0
 54a:	60a2                	ld	ra,8(sp)
 54c:	6402                	ld	s0,0(sp)
 54e:	0141                	addi	sp,sp,16
 550:	8082                	ret

0000000000000552 <strlen>:

uint
strlen(const char *s)
{
 552:	1141                	addi	sp,sp,-16
 554:	e406                	sd	ra,8(sp)
 556:	e022                	sd	s0,0(sp)
 558:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 55a:	00054783          	lbu	a5,0(a0)
 55e:	cf91                	beqz	a5,57a <strlen+0x28>
 560:	00150793          	addi	a5,a0,1
 564:	86be                	mv	a3,a5
 566:	0785                	addi	a5,a5,1
 568:	fff7c703          	lbu	a4,-1(a5)
 56c:	ff65                	bnez	a4,564 <strlen+0x12>
 56e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 572:	60a2                	ld	ra,8(sp)
 574:	6402                	ld	s0,0(sp)
 576:	0141                	addi	sp,sp,16
 578:	8082                	ret
  for(n = 0; s[n]; n++)
 57a:	4501                	li	a0,0
 57c:	bfdd                	j	572 <strlen+0x20>

000000000000057e <memset>:

void*
memset(void *dst, int c, uint n)
{
 57e:	1141                	addi	sp,sp,-16
 580:	e406                	sd	ra,8(sp)
 582:	e022                	sd	s0,0(sp)
 584:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 586:	ca19                	beqz	a2,59c <memset+0x1e>
 588:	87aa                	mv	a5,a0
 58a:	1602                	slli	a2,a2,0x20
 58c:	9201                	srli	a2,a2,0x20
 58e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 592:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 596:	0785                	addi	a5,a5,1
 598:	fee79de3          	bne	a5,a4,592 <memset+0x14>
  }
  return dst;
}
 59c:	60a2                	ld	ra,8(sp)
 59e:	6402                	ld	s0,0(sp)
 5a0:	0141                	addi	sp,sp,16
 5a2:	8082                	ret

00000000000005a4 <strchr>:

char*
strchr(const char *s, char c)
{
 5a4:	1141                	addi	sp,sp,-16
 5a6:	e406                	sd	ra,8(sp)
 5a8:	e022                	sd	s0,0(sp)
 5aa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 5ac:	00054783          	lbu	a5,0(a0)
 5b0:	cf81                	beqz	a5,5c8 <strchr+0x24>
    if(*s == c)
 5b2:	00f58763          	beq	a1,a5,5c0 <strchr+0x1c>
  for(; *s; s++)
 5b6:	0505                	addi	a0,a0,1
 5b8:	00054783          	lbu	a5,0(a0)
 5bc:	fbfd                	bnez	a5,5b2 <strchr+0xe>
      return (char*)s;
  return 0;
 5be:	4501                	li	a0,0
}
 5c0:	60a2                	ld	ra,8(sp)
 5c2:	6402                	ld	s0,0(sp)
 5c4:	0141                	addi	sp,sp,16
 5c6:	8082                	ret
  return 0;
 5c8:	4501                	li	a0,0
 5ca:	bfdd                	j	5c0 <strchr+0x1c>

00000000000005cc <gets>:

char*
gets(char *buf, int max)
{
 5cc:	711d                	addi	sp,sp,-96
 5ce:	ec86                	sd	ra,88(sp)
 5d0:	e8a2                	sd	s0,80(sp)
 5d2:	e4a6                	sd	s1,72(sp)
 5d4:	e0ca                	sd	s2,64(sp)
 5d6:	fc4e                	sd	s3,56(sp)
 5d8:	f852                	sd	s4,48(sp)
 5da:	f456                	sd	s5,40(sp)
 5dc:	f05a                	sd	s6,32(sp)
 5de:	ec5e                	sd	s7,24(sp)
 5e0:	e862                	sd	s8,16(sp)
 5e2:	1080                	addi	s0,sp,96
 5e4:	8baa                	mv	s7,a0
 5e6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5e8:	892a                	mv	s2,a0
 5ea:	4481                	li	s1,0
    cc = read(0, &c, 1);
 5ec:	faf40b13          	addi	s6,s0,-81
 5f0:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 5f2:	8c26                	mv	s8,s1
 5f4:	0014899b          	addiw	s3,s1,1
 5f8:	84ce                	mv	s1,s3
 5fa:	0349d463          	bge	s3,s4,622 <gets+0x56>
    cc = read(0, &c, 1);
 5fe:	8656                	mv	a2,s5
 600:	85da                	mv	a1,s6
 602:	4501                	li	a0,0
 604:	1bc000ef          	jal	7c0 <read>
    if(cc < 1)
 608:	00a05d63          	blez	a0,622 <gets+0x56>
      break;
    buf[i++] = c;
 60c:	faf44783          	lbu	a5,-81(s0)
 610:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 614:	0905                	addi	s2,s2,1
 616:	ff678713          	addi	a4,a5,-10
 61a:	c319                	beqz	a4,620 <gets+0x54>
 61c:	17cd                	addi	a5,a5,-13
 61e:	fbf1                	bnez	a5,5f2 <gets+0x26>
    buf[i++] = c;
 620:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 622:	9c5e                	add	s8,s8,s7
 624:	000c0023          	sb	zero,0(s8)
  return buf;
}
 628:	855e                	mv	a0,s7
 62a:	60e6                	ld	ra,88(sp)
 62c:	6446                	ld	s0,80(sp)
 62e:	64a6                	ld	s1,72(sp)
 630:	6906                	ld	s2,64(sp)
 632:	79e2                	ld	s3,56(sp)
 634:	7a42                	ld	s4,48(sp)
 636:	7aa2                	ld	s5,40(sp)
 638:	7b02                	ld	s6,32(sp)
 63a:	6be2                	ld	s7,24(sp)
 63c:	6c42                	ld	s8,16(sp)
 63e:	6125                	addi	sp,sp,96
 640:	8082                	ret

0000000000000642 <stat>:

int
stat(const char *n, struct stat *st)
{
 642:	1101                	addi	sp,sp,-32
 644:	ec06                	sd	ra,24(sp)
 646:	e822                	sd	s0,16(sp)
 648:	e04a                	sd	s2,0(sp)
 64a:	1000                	addi	s0,sp,32
 64c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 64e:	4581                	li	a1,0
 650:	198000ef          	jal	7e8 <open>
  if(fd < 0)
 654:	02054263          	bltz	a0,678 <stat+0x36>
 658:	e426                	sd	s1,8(sp)
 65a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 65c:	85ca                	mv	a1,s2
 65e:	1a2000ef          	jal	800 <fstat>
 662:	892a                	mv	s2,a0
  close(fd);
 664:	8526                	mv	a0,s1
 666:	16a000ef          	jal	7d0 <close>
  return r;
 66a:	64a2                	ld	s1,8(sp)
}
 66c:	854a                	mv	a0,s2
 66e:	60e2                	ld	ra,24(sp)
 670:	6442                	ld	s0,16(sp)
 672:	6902                	ld	s2,0(sp)
 674:	6105                	addi	sp,sp,32
 676:	8082                	ret
    return -1;
 678:	57fd                	li	a5,-1
 67a:	893e                	mv	s2,a5
 67c:	bfc5                	j	66c <stat+0x2a>

000000000000067e <atoi>:

int
atoi(const char *s)
{
 67e:	1141                	addi	sp,sp,-16
 680:	e406                	sd	ra,8(sp)
 682:	e022                	sd	s0,0(sp)
 684:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 686:	00054683          	lbu	a3,0(a0)
 68a:	fd06879b          	addiw	a5,a3,-48 # fd0 <malloc+0x2da>
 68e:	0ff7f793          	zext.b	a5,a5
 692:	4625                	li	a2,9
 694:	02f66963          	bltu	a2,a5,6c6 <atoi+0x48>
 698:	872a                	mv	a4,a0
  n = 0;
 69a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 69c:	0705                	addi	a4,a4,1
 69e:	0025179b          	slliw	a5,a0,0x2
 6a2:	9fa9                	addw	a5,a5,a0
 6a4:	0017979b          	slliw	a5,a5,0x1
 6a8:	9fb5                	addw	a5,a5,a3
 6aa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6ae:	00074683          	lbu	a3,0(a4)
 6b2:	fd06879b          	addiw	a5,a3,-48
 6b6:	0ff7f793          	zext.b	a5,a5
 6ba:	fef671e3          	bgeu	a2,a5,69c <atoi+0x1e>
  return n;
}
 6be:	60a2                	ld	ra,8(sp)
 6c0:	6402                	ld	s0,0(sp)
 6c2:	0141                	addi	sp,sp,16
 6c4:	8082                	ret
  n = 0;
 6c6:	4501                	li	a0,0
 6c8:	bfdd                	j	6be <atoi+0x40>

00000000000006ca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6ca:	1141                	addi	sp,sp,-16
 6cc:	e406                	sd	ra,8(sp)
 6ce:	e022                	sd	s0,0(sp)
 6d0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6d2:	02b57563          	bgeu	a0,a1,6fc <memmove+0x32>
    while(n-- > 0)
 6d6:	00c05f63          	blez	a2,6f4 <memmove+0x2a>
 6da:	1602                	slli	a2,a2,0x20
 6dc:	9201                	srli	a2,a2,0x20
 6de:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6e2:	872a                	mv	a4,a0
      *dst++ = *src++;
 6e4:	0585                	addi	a1,a1,1
 6e6:	0705                	addi	a4,a4,1
 6e8:	fff5c683          	lbu	a3,-1(a1)
 6ec:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6f0:	fee79ae3          	bne	a5,a4,6e4 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6f4:	60a2                	ld	ra,8(sp)
 6f6:	6402                	ld	s0,0(sp)
 6f8:	0141                	addi	sp,sp,16
 6fa:	8082                	ret
    while(n-- > 0)
 6fc:	fec05ce3          	blez	a2,6f4 <memmove+0x2a>
    dst += n;
 700:	00c50733          	add	a4,a0,a2
    src += n;
 704:	95b2                	add	a1,a1,a2
 706:	fff6079b          	addiw	a5,a2,-1 # fff <malloc+0x309>
 70a:	1782                	slli	a5,a5,0x20
 70c:	9381                	srli	a5,a5,0x20
 70e:	fff7c793          	not	a5,a5
 712:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 714:	15fd                	addi	a1,a1,-1
 716:	177d                	addi	a4,a4,-1
 718:	0005c683          	lbu	a3,0(a1)
 71c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 720:	fef71ae3          	bne	a4,a5,714 <memmove+0x4a>
 724:	bfc1                	j	6f4 <memmove+0x2a>

0000000000000726 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 726:	1141                	addi	sp,sp,-16
 728:	e406                	sd	ra,8(sp)
 72a:	e022                	sd	s0,0(sp)
 72c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 72e:	c61d                	beqz	a2,75c <memcmp+0x36>
 730:	1602                	slli	a2,a2,0x20
 732:	9201                	srli	a2,a2,0x20
 734:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 738:	00054783          	lbu	a5,0(a0)
 73c:	0005c703          	lbu	a4,0(a1)
 740:	00e79863          	bne	a5,a4,750 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 744:	0505                	addi	a0,a0,1
    p2++;
 746:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 748:	fed518e3          	bne	a0,a3,738 <memcmp+0x12>
  }
  return 0;
 74c:	4501                	li	a0,0
 74e:	a019                	j	754 <memcmp+0x2e>
      return *p1 - *p2;
 750:	40e7853b          	subw	a0,a5,a4
}
 754:	60a2                	ld	ra,8(sp)
 756:	6402                	ld	s0,0(sp)
 758:	0141                	addi	sp,sp,16
 75a:	8082                	ret
  return 0;
 75c:	4501                	li	a0,0
 75e:	bfdd                	j	754 <memcmp+0x2e>

0000000000000760 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 760:	1141                	addi	sp,sp,-16
 762:	e406                	sd	ra,8(sp)
 764:	e022                	sd	s0,0(sp)
 766:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 768:	f63ff0ef          	jal	6ca <memmove>
}
 76c:	60a2                	ld	ra,8(sp)
 76e:	6402                	ld	s0,0(sp)
 770:	0141                	addi	sp,sp,16
 772:	8082                	ret

0000000000000774 <sbrk>:

char *
sbrk(int n) {
 774:	1141                	addi	sp,sp,-16
 776:	e406                	sd	ra,8(sp)
 778:	e022                	sd	s0,0(sp)
 77a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 77c:	4585                	li	a1,1
 77e:	0b2000ef          	jal	830 <sys_sbrk>
}
 782:	60a2                	ld	ra,8(sp)
 784:	6402                	ld	s0,0(sp)
 786:	0141                	addi	sp,sp,16
 788:	8082                	ret

000000000000078a <sbrklazy>:

char *
sbrklazy(int n) {
 78a:	1141                	addi	sp,sp,-16
 78c:	e406                	sd	ra,8(sp)
 78e:	e022                	sd	s0,0(sp)
 790:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 792:	4589                	li	a1,2
 794:	09c000ef          	jal	830 <sys_sbrk>
}
 798:	60a2                	ld	ra,8(sp)
 79a:	6402                	ld	s0,0(sp)
 79c:	0141                	addi	sp,sp,16
 79e:	8082                	ret

00000000000007a0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7a0:	4885                	li	a7,1
 ecall
 7a2:	00000073          	ecall
 ret
 7a6:	8082                	ret

00000000000007a8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 7a8:	4889                	li	a7,2
 ecall
 7aa:	00000073          	ecall
 ret
 7ae:	8082                	ret

00000000000007b0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 7b0:	488d                	li	a7,3
 ecall
 7b2:	00000073          	ecall
 ret
 7b6:	8082                	ret

00000000000007b8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7b8:	4891                	li	a7,4
 ecall
 7ba:	00000073          	ecall
 ret
 7be:	8082                	ret

00000000000007c0 <read>:
.global read
read:
 li a7, SYS_read
 7c0:	4895                	li	a7,5
 ecall
 7c2:	00000073          	ecall
 ret
 7c6:	8082                	ret

00000000000007c8 <write>:
.global write
write:
 li a7, SYS_write
 7c8:	48c1                	li	a7,16
 ecall
 7ca:	00000073          	ecall
 ret
 7ce:	8082                	ret

00000000000007d0 <close>:
.global close
close:
 li a7, SYS_close
 7d0:	48d5                	li	a7,21
 ecall
 7d2:	00000073          	ecall
 ret
 7d6:	8082                	ret

00000000000007d8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 7d8:	4899                	li	a7,6
 ecall
 7da:	00000073          	ecall
 ret
 7de:	8082                	ret

00000000000007e0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7e0:	489d                	li	a7,7
 ecall
 7e2:	00000073          	ecall
 ret
 7e6:	8082                	ret

00000000000007e8 <open>:
.global open
open:
 li a7, SYS_open
 7e8:	48bd                	li	a7,15
 ecall
 7ea:	00000073          	ecall
 ret
 7ee:	8082                	ret

00000000000007f0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7f0:	48c5                	li	a7,17
 ecall
 7f2:	00000073          	ecall
 ret
 7f6:	8082                	ret

00000000000007f8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7f8:	48c9                	li	a7,18
 ecall
 7fa:	00000073          	ecall
 ret
 7fe:	8082                	ret

0000000000000800 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 800:	48a1                	li	a7,8
 ecall
 802:	00000073          	ecall
 ret
 806:	8082                	ret

0000000000000808 <link>:
.global link
link:
 li a7, SYS_link
 808:	48cd                	li	a7,19
 ecall
 80a:	00000073          	ecall
 ret
 80e:	8082                	ret

0000000000000810 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 810:	48d1                	li	a7,20
 ecall
 812:	00000073          	ecall
 ret
 816:	8082                	ret

0000000000000818 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 818:	48a5                	li	a7,9
 ecall
 81a:	00000073          	ecall
 ret
 81e:	8082                	ret

0000000000000820 <dup>:
.global dup
dup:
 li a7, SYS_dup
 820:	48a9                	li	a7,10
 ecall
 822:	00000073          	ecall
 ret
 826:	8082                	ret

0000000000000828 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 828:	48ad                	li	a7,11
 ecall
 82a:	00000073          	ecall
 ret
 82e:	8082                	ret

0000000000000830 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 830:	48b1                	li	a7,12
 ecall
 832:	00000073          	ecall
 ret
 836:	8082                	ret

0000000000000838 <pause>:
.global pause
pause:
 li a7, SYS_pause
 838:	48b5                	li	a7,13
 ecall
 83a:	00000073          	ecall
 ret
 83e:	8082                	ret

0000000000000840 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 840:	48b9                	li	a7,14
 ecall
 842:	00000073          	ecall
 ret
 846:	8082                	ret

0000000000000848 <hello>:
.global hello
hello:
 li a7, SYS_hello
 848:	48d9                	li	a7,22
 ecall
 84a:	00000073          	ecall
 ret
 84e:	8082                	ret

0000000000000850 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 850:	48dd                	li	a7,23
 ecall
 852:	00000073          	ecall
 ret
 856:	8082                	ret

0000000000000858 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 858:	48e1                	li	a7,24
 ecall
 85a:	00000073          	ecall
 ret
 85e:	8082                	ret

0000000000000860 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 860:	48e5                	li	a7,25
 ecall
 862:	00000073          	ecall
 ret
 866:	8082                	ret

0000000000000868 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 868:	48e9                	li	a7,26
 ecall
 86a:	00000073          	ecall
 ret
 86e:	8082                	ret

0000000000000870 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 870:	48ed                	li	a7,27
 ecall
 872:	00000073          	ecall
 ret
 876:	8082                	ret

0000000000000878 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 878:	48f1                	li	a7,28
 ecall
 87a:	00000073          	ecall
 ret
 87e:	8082                	ret

0000000000000880 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 880:	48f5                	li	a7,29
 ecall
 882:	00000073          	ecall
 ret
 886:	8082                	ret

0000000000000888 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 888:	48f9                	li	a7,30
 ecall
 88a:	00000073          	ecall
 ret
 88e:	8082                	ret

0000000000000890 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 890:	48fd                	li	a7,31
 ecall
 892:	00000073          	ecall
 ret
 896:	8082                	ret

0000000000000898 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 898:	1101                	addi	sp,sp,-32
 89a:	ec06                	sd	ra,24(sp)
 89c:	e822                	sd	s0,16(sp)
 89e:	1000                	addi	s0,sp,32
 8a0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 8a4:	4605                	li	a2,1
 8a6:	fef40593          	addi	a1,s0,-17
 8aa:	f1fff0ef          	jal	7c8 <write>
}
 8ae:	60e2                	ld	ra,24(sp)
 8b0:	6442                	ld	s0,16(sp)
 8b2:	6105                	addi	sp,sp,32
 8b4:	8082                	ret

00000000000008b6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 8b6:	715d                	addi	sp,sp,-80
 8b8:	e486                	sd	ra,72(sp)
 8ba:	e0a2                	sd	s0,64(sp)
 8bc:	f84a                	sd	s2,48(sp)
 8be:	f44e                	sd	s3,40(sp)
 8c0:	0880                	addi	s0,sp,80
 8c2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 8c4:	c6d1                	beqz	a3,950 <printint+0x9a>
 8c6:	0805d563          	bgez	a1,950 <printint+0x9a>
    neg = 1;
    x = -xx;
 8ca:	40b005b3          	neg	a1,a1
    neg = 1;
 8ce:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 8d0:	fb840993          	addi	s3,s0,-72
  neg = 0;
 8d4:	86ce                	mv	a3,s3
  i = 0;
 8d6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8d8:	00001817          	auipc	a6,0x1
 8dc:	82080813          	addi	a6,a6,-2016 # 10f8 <digits>
 8e0:	88ba                	mv	a7,a4
 8e2:	0017051b          	addiw	a0,a4,1
 8e6:	872a                	mv	a4,a0
 8e8:	02c5f7b3          	remu	a5,a1,a2
 8ec:	97c2                	add	a5,a5,a6
 8ee:	0007c783          	lbu	a5,0(a5)
 8f2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 8f6:	87ae                	mv	a5,a1
 8f8:	02c5d5b3          	divu	a1,a1,a2
 8fc:	0685                	addi	a3,a3,1
 8fe:	fec7f1e3          	bgeu	a5,a2,8e0 <printint+0x2a>
  if(neg)
 902:	00030c63          	beqz	t1,91a <printint+0x64>
    buf[i++] = '-';
 906:	fd050793          	addi	a5,a0,-48
 90a:	00878533          	add	a0,a5,s0
 90e:	02d00793          	li	a5,45
 912:	fef50423          	sb	a5,-24(a0)
 916:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 91a:	02e05563          	blez	a4,944 <printint+0x8e>
 91e:	fc26                	sd	s1,56(sp)
 920:	377d                	addiw	a4,a4,-1
 922:	00e984b3          	add	s1,s3,a4
 926:	19fd                	addi	s3,s3,-1
 928:	99ba                	add	s3,s3,a4
 92a:	1702                	slli	a4,a4,0x20
 92c:	9301                	srli	a4,a4,0x20
 92e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 932:	0004c583          	lbu	a1,0(s1)
 936:	854a                	mv	a0,s2
 938:	f61ff0ef          	jal	898 <putc>
  while(--i >= 0)
 93c:	14fd                	addi	s1,s1,-1
 93e:	ff349ae3          	bne	s1,s3,932 <printint+0x7c>
 942:	74e2                	ld	s1,56(sp)
}
 944:	60a6                	ld	ra,72(sp)
 946:	6406                	ld	s0,64(sp)
 948:	7942                	ld	s2,48(sp)
 94a:	79a2                	ld	s3,40(sp)
 94c:	6161                	addi	sp,sp,80
 94e:	8082                	ret
  neg = 0;
 950:	4301                	li	t1,0
 952:	bfbd                	j	8d0 <printint+0x1a>

0000000000000954 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 954:	711d                	addi	sp,sp,-96
 956:	ec86                	sd	ra,88(sp)
 958:	e8a2                	sd	s0,80(sp)
 95a:	e4a6                	sd	s1,72(sp)
 95c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 95e:	0005c483          	lbu	s1,0(a1)
 962:	22048363          	beqz	s1,b88 <vprintf+0x234>
 966:	e0ca                	sd	s2,64(sp)
 968:	fc4e                	sd	s3,56(sp)
 96a:	f852                	sd	s4,48(sp)
 96c:	f456                	sd	s5,40(sp)
 96e:	f05a                	sd	s6,32(sp)
 970:	ec5e                	sd	s7,24(sp)
 972:	e862                	sd	s8,16(sp)
 974:	8b2a                	mv	s6,a0
 976:	8a2e                	mv	s4,a1
 978:	8bb2                	mv	s7,a2
  state = 0;
 97a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 97c:	4901                	li	s2,0
 97e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 980:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 984:	06400c13          	li	s8,100
 988:	a00d                	j	9aa <vprintf+0x56>
        putc(fd, c0);
 98a:	85a6                	mv	a1,s1
 98c:	855a                	mv	a0,s6
 98e:	f0bff0ef          	jal	898 <putc>
 992:	a019                	j	998 <vprintf+0x44>
    } else if(state == '%'){
 994:	03598363          	beq	s3,s5,9ba <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 998:	0019079b          	addiw	a5,s2,1
 99c:	893e                	mv	s2,a5
 99e:	873e                	mv	a4,a5
 9a0:	97d2                	add	a5,a5,s4
 9a2:	0007c483          	lbu	s1,0(a5)
 9a6:	1c048a63          	beqz	s1,b7a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 9aa:	0004879b          	sext.w	a5,s1
    if(state == 0){
 9ae:	fe0993e3          	bnez	s3,994 <vprintf+0x40>
      if(c0 == '%'){
 9b2:	fd579ce3          	bne	a5,s5,98a <vprintf+0x36>
        state = '%';
 9b6:	89be                	mv	s3,a5
 9b8:	b7c5                	j	998 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 9ba:	00ea06b3          	add	a3,s4,a4
 9be:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 9c2:	1c060863          	beqz	a2,b92 <vprintf+0x23e>
      if(c0 == 'd'){
 9c6:	03878763          	beq	a5,s8,9f4 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 9ca:	f9478693          	addi	a3,a5,-108
 9ce:	0016b693          	seqz	a3,a3
 9d2:	f9c60593          	addi	a1,a2,-100
 9d6:	e99d                	bnez	a1,a0c <vprintf+0xb8>
 9d8:	ca95                	beqz	a3,a0c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9da:	008b8493          	addi	s1,s7,8
 9de:	4685                	li	a3,1
 9e0:	4629                	li	a2,10
 9e2:	000bb583          	ld	a1,0(s7)
 9e6:	855a                	mv	a0,s6
 9e8:	ecfff0ef          	jal	8b6 <printint>
        i += 1;
 9ec:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 9ee:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 9f0:	4981                	li	s3,0
 9f2:	b75d                	j	998 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 9f4:	008b8493          	addi	s1,s7,8
 9f8:	4685                	li	a3,1
 9fa:	4629                	li	a2,10
 9fc:	000ba583          	lw	a1,0(s7)
 a00:	855a                	mv	a0,s6
 a02:	eb5ff0ef          	jal	8b6 <printint>
 a06:	8ba6                	mv	s7,s1
      state = 0;
 a08:	4981                	li	s3,0
 a0a:	b779                	j	998 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 a0c:	9752                	add	a4,a4,s4
 a0e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a12:	f9460713          	addi	a4,a2,-108
 a16:	00173713          	seqz	a4,a4
 a1a:	8f75                	and	a4,a4,a3
 a1c:	f9c58513          	addi	a0,a1,-100
 a20:	18051363          	bnez	a0,ba6 <vprintf+0x252>
 a24:	18070163          	beqz	a4,ba6 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a28:	008b8493          	addi	s1,s7,8
 a2c:	4685                	li	a3,1
 a2e:	4629                	li	a2,10
 a30:	000bb583          	ld	a1,0(s7)
 a34:	855a                	mv	a0,s6
 a36:	e81ff0ef          	jal	8b6 <printint>
        i += 2;
 a3a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a3c:	8ba6                	mv	s7,s1
      state = 0;
 a3e:	4981                	li	s3,0
        i += 2;
 a40:	bfa1                	j	998 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 a42:	008b8493          	addi	s1,s7,8
 a46:	4681                	li	a3,0
 a48:	4629                	li	a2,10
 a4a:	000be583          	lwu	a1,0(s7)
 a4e:	855a                	mv	a0,s6
 a50:	e67ff0ef          	jal	8b6 <printint>
 a54:	8ba6                	mv	s7,s1
      state = 0;
 a56:	4981                	li	s3,0
 a58:	b781                	j	998 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a5a:	008b8493          	addi	s1,s7,8
 a5e:	4681                	li	a3,0
 a60:	4629                	li	a2,10
 a62:	000bb583          	ld	a1,0(s7)
 a66:	855a                	mv	a0,s6
 a68:	e4fff0ef          	jal	8b6 <printint>
        i += 1;
 a6c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a6e:	8ba6                	mv	s7,s1
      state = 0;
 a70:	4981                	li	s3,0
 a72:	b71d                	j	998 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a74:	008b8493          	addi	s1,s7,8
 a78:	4681                	li	a3,0
 a7a:	4629                	li	a2,10
 a7c:	000bb583          	ld	a1,0(s7)
 a80:	855a                	mv	a0,s6
 a82:	e35ff0ef          	jal	8b6 <printint>
        i += 2;
 a86:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a88:	8ba6                	mv	s7,s1
      state = 0;
 a8a:	4981                	li	s3,0
        i += 2;
 a8c:	b731                	j	998 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 a8e:	008b8493          	addi	s1,s7,8
 a92:	4681                	li	a3,0
 a94:	4641                	li	a2,16
 a96:	000be583          	lwu	a1,0(s7)
 a9a:	855a                	mv	a0,s6
 a9c:	e1bff0ef          	jal	8b6 <printint>
 aa0:	8ba6                	mv	s7,s1
      state = 0;
 aa2:	4981                	li	s3,0
 aa4:	bdd5                	j	998 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 aa6:	008b8493          	addi	s1,s7,8
 aaa:	4681                	li	a3,0
 aac:	4641                	li	a2,16
 aae:	000bb583          	ld	a1,0(s7)
 ab2:	855a                	mv	a0,s6
 ab4:	e03ff0ef          	jal	8b6 <printint>
        i += 1;
 ab8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 aba:	8ba6                	mv	s7,s1
      state = 0;
 abc:	4981                	li	s3,0
 abe:	bde9                	j	998 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 ac0:	008b8493          	addi	s1,s7,8
 ac4:	4681                	li	a3,0
 ac6:	4641                	li	a2,16
 ac8:	000bb583          	ld	a1,0(s7)
 acc:	855a                	mv	a0,s6
 ace:	de9ff0ef          	jal	8b6 <printint>
        i += 2;
 ad2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 ad4:	8ba6                	mv	s7,s1
      state = 0;
 ad6:	4981                	li	s3,0
        i += 2;
 ad8:	b5c1                	j	998 <vprintf+0x44>
 ada:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 adc:	008b8793          	addi	a5,s7,8
 ae0:	8cbe                	mv	s9,a5
 ae2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 ae6:	03000593          	li	a1,48
 aea:	855a                	mv	a0,s6
 aec:	dadff0ef          	jal	898 <putc>
  putc(fd, 'x');
 af0:	07800593          	li	a1,120
 af4:	855a                	mv	a0,s6
 af6:	da3ff0ef          	jal	898 <putc>
 afa:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 afc:	00000b97          	auipc	s7,0x0
 b00:	5fcb8b93          	addi	s7,s7,1532 # 10f8 <digits>
 b04:	03c9d793          	srli	a5,s3,0x3c
 b08:	97de                	add	a5,a5,s7
 b0a:	0007c583          	lbu	a1,0(a5)
 b0e:	855a                	mv	a0,s6
 b10:	d89ff0ef          	jal	898 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b14:	0992                	slli	s3,s3,0x4
 b16:	34fd                	addiw	s1,s1,-1
 b18:	f4f5                	bnez	s1,b04 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 b1a:	8be6                	mv	s7,s9
      state = 0;
 b1c:	4981                	li	s3,0
 b1e:	6ca2                	ld	s9,8(sp)
 b20:	bda5                	j	998 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 b22:	008b8493          	addi	s1,s7,8
 b26:	000bc583          	lbu	a1,0(s7)
 b2a:	855a                	mv	a0,s6
 b2c:	d6dff0ef          	jal	898 <putc>
 b30:	8ba6                	mv	s7,s1
      state = 0;
 b32:	4981                	li	s3,0
 b34:	b595                	j	998 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 b36:	008b8993          	addi	s3,s7,8
 b3a:	000bb483          	ld	s1,0(s7)
 b3e:	cc91                	beqz	s1,b5a <vprintf+0x206>
        for(; *s; s++)
 b40:	0004c583          	lbu	a1,0(s1)
 b44:	c985                	beqz	a1,b74 <vprintf+0x220>
          putc(fd, *s);
 b46:	855a                	mv	a0,s6
 b48:	d51ff0ef          	jal	898 <putc>
        for(; *s; s++)
 b4c:	0485                	addi	s1,s1,1
 b4e:	0004c583          	lbu	a1,0(s1)
 b52:	f9f5                	bnez	a1,b46 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 b54:	8bce                	mv	s7,s3
      state = 0;
 b56:	4981                	li	s3,0
 b58:	b581                	j	998 <vprintf+0x44>
          s = "(null)";
 b5a:	00000497          	auipc	s1,0x0
 b5e:	59648493          	addi	s1,s1,1430 # 10f0 <malloc+0x3fa>
        for(; *s; s++)
 b62:	02800593          	li	a1,40
 b66:	b7c5                	j	b46 <vprintf+0x1f2>
        putc(fd, '%');
 b68:	85be                	mv	a1,a5
 b6a:	855a                	mv	a0,s6
 b6c:	d2dff0ef          	jal	898 <putc>
      state = 0;
 b70:	4981                	li	s3,0
 b72:	b51d                	j	998 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 b74:	8bce                	mv	s7,s3
      state = 0;
 b76:	4981                	li	s3,0
 b78:	b505                	j	998 <vprintf+0x44>
 b7a:	6906                	ld	s2,64(sp)
 b7c:	79e2                	ld	s3,56(sp)
 b7e:	7a42                	ld	s4,48(sp)
 b80:	7aa2                	ld	s5,40(sp)
 b82:	7b02                	ld	s6,32(sp)
 b84:	6be2                	ld	s7,24(sp)
 b86:	6c42                	ld	s8,16(sp)
    }
  }
}
 b88:	60e6                	ld	ra,88(sp)
 b8a:	6446                	ld	s0,80(sp)
 b8c:	64a6                	ld	s1,72(sp)
 b8e:	6125                	addi	sp,sp,96
 b90:	8082                	ret
      if(c0 == 'd'){
 b92:	06400713          	li	a4,100
 b96:	e4e78fe3          	beq	a5,a4,9f4 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 b9a:	f9478693          	addi	a3,a5,-108
 b9e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 ba2:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 ba4:	4701                	li	a4,0
      } else if(c0 == 'u'){
 ba6:	07500513          	li	a0,117
 baa:	e8a78ce3          	beq	a5,a0,a42 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 bae:	f8b60513          	addi	a0,a2,-117
 bb2:	e119                	bnez	a0,bb8 <vprintf+0x264>
 bb4:	ea0693e3          	bnez	a3,a5a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 bb8:	f8b58513          	addi	a0,a1,-117
 bbc:	e119                	bnez	a0,bc2 <vprintf+0x26e>
 bbe:	ea071be3          	bnez	a4,a74 <vprintf+0x120>
      } else if(c0 == 'x'){
 bc2:	07800513          	li	a0,120
 bc6:	eca784e3          	beq	a5,a0,a8e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 bca:	f8860613          	addi	a2,a2,-120
 bce:	e219                	bnez	a2,bd4 <vprintf+0x280>
 bd0:	ec069be3          	bnez	a3,aa6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 bd4:	f8858593          	addi	a1,a1,-120
 bd8:	e199                	bnez	a1,bde <vprintf+0x28a>
 bda:	ee0713e3          	bnez	a4,ac0 <vprintf+0x16c>
      } else if(c0 == 'p'){
 bde:	07000713          	li	a4,112
 be2:	eee78ce3          	beq	a5,a4,ada <vprintf+0x186>
      } else if(c0 == 'c'){
 be6:	06300713          	li	a4,99
 bea:	f2e78ce3          	beq	a5,a4,b22 <vprintf+0x1ce>
      } else if(c0 == 's'){
 bee:	07300713          	li	a4,115
 bf2:	f4e782e3          	beq	a5,a4,b36 <vprintf+0x1e2>
      } else if(c0 == '%'){
 bf6:	02500713          	li	a4,37
 bfa:	f6e787e3          	beq	a5,a4,b68 <vprintf+0x214>
        putc(fd, '%');
 bfe:	02500593          	li	a1,37
 c02:	855a                	mv	a0,s6
 c04:	c95ff0ef          	jal	898 <putc>
        putc(fd, c0);
 c08:	85a6                	mv	a1,s1
 c0a:	855a                	mv	a0,s6
 c0c:	c8dff0ef          	jal	898 <putc>
      state = 0;
 c10:	4981                	li	s3,0
 c12:	b359                	j	998 <vprintf+0x44>

0000000000000c14 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c14:	715d                	addi	sp,sp,-80
 c16:	ec06                	sd	ra,24(sp)
 c18:	e822                	sd	s0,16(sp)
 c1a:	1000                	addi	s0,sp,32
 c1c:	e010                	sd	a2,0(s0)
 c1e:	e414                	sd	a3,8(s0)
 c20:	e818                	sd	a4,16(s0)
 c22:	ec1c                	sd	a5,24(s0)
 c24:	03043023          	sd	a6,32(s0)
 c28:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c2c:	8622                	mv	a2,s0
 c2e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c32:	d23ff0ef          	jal	954 <vprintf>
}
 c36:	60e2                	ld	ra,24(sp)
 c38:	6442                	ld	s0,16(sp)
 c3a:	6161                	addi	sp,sp,80
 c3c:	8082                	ret

0000000000000c3e <printf>:

void
printf(const char *fmt, ...)
{
 c3e:	711d                	addi	sp,sp,-96
 c40:	ec06                	sd	ra,24(sp)
 c42:	e822                	sd	s0,16(sp)
 c44:	1000                	addi	s0,sp,32
 c46:	e40c                	sd	a1,8(s0)
 c48:	e810                	sd	a2,16(s0)
 c4a:	ec14                	sd	a3,24(s0)
 c4c:	f018                	sd	a4,32(s0)
 c4e:	f41c                	sd	a5,40(s0)
 c50:	03043823          	sd	a6,48(s0)
 c54:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c58:	00840613          	addi	a2,s0,8
 c5c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c60:	85aa                	mv	a1,a0
 c62:	4505                	li	a0,1
 c64:	cf1ff0ef          	jal	954 <vprintf>
}
 c68:	60e2                	ld	ra,24(sp)
 c6a:	6442                	ld	s0,16(sp)
 c6c:	6125                	addi	sp,sp,96
 c6e:	8082                	ret

0000000000000c70 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c70:	1141                	addi	sp,sp,-16
 c72:	e406                	sd	ra,8(sp)
 c74:	e022                	sd	s0,0(sp)
 c76:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c78:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c7c:	00001797          	auipc	a5,0x1
 c80:	3847b783          	ld	a5,900(a5) # 2000 <freep>
 c84:	a039                	j	c92 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c86:	6398                	ld	a4,0(a5)
 c88:	00e7e463          	bltu	a5,a4,c90 <free+0x20>
 c8c:	00e6ea63          	bltu	a3,a4,ca0 <free+0x30>
{
 c90:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c92:	fed7fae3          	bgeu	a5,a3,c86 <free+0x16>
 c96:	6398                	ld	a4,0(a5)
 c98:	00e6e463          	bltu	a3,a4,ca0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c9c:	fee7eae3          	bltu	a5,a4,c90 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ca0:	ff852583          	lw	a1,-8(a0)
 ca4:	6390                	ld	a2,0(a5)
 ca6:	02059813          	slli	a6,a1,0x20
 caa:	01c85713          	srli	a4,a6,0x1c
 cae:	9736                	add	a4,a4,a3
 cb0:	02e60563          	beq	a2,a4,cda <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 cb4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 cb8:	4790                	lw	a2,8(a5)
 cba:	02061593          	slli	a1,a2,0x20
 cbe:	01c5d713          	srli	a4,a1,0x1c
 cc2:	973e                	add	a4,a4,a5
 cc4:	02e68263          	beq	a3,a4,ce8 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 cc8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 cca:	00001717          	auipc	a4,0x1
 cce:	32f73b23          	sd	a5,822(a4) # 2000 <freep>
}
 cd2:	60a2                	ld	ra,8(sp)
 cd4:	6402                	ld	s0,0(sp)
 cd6:	0141                	addi	sp,sp,16
 cd8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 cda:	4618                	lw	a4,8(a2)
 cdc:	9f2d                	addw	a4,a4,a1
 cde:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ce2:	6398                	ld	a4,0(a5)
 ce4:	6310                	ld	a2,0(a4)
 ce6:	b7f9                	j	cb4 <free+0x44>
    p->s.size += bp->s.size;
 ce8:	ff852703          	lw	a4,-8(a0)
 cec:	9f31                	addw	a4,a4,a2
 cee:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cf0:	ff053683          	ld	a3,-16(a0)
 cf4:	bfd1                	j	cc8 <free+0x58>

0000000000000cf6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 cf6:	7139                	addi	sp,sp,-64
 cf8:	fc06                	sd	ra,56(sp)
 cfa:	f822                	sd	s0,48(sp)
 cfc:	f04a                	sd	s2,32(sp)
 cfe:	ec4e                	sd	s3,24(sp)
 d00:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d02:	02051993          	slli	s3,a0,0x20
 d06:	0209d993          	srli	s3,s3,0x20
 d0a:	09bd                	addi	s3,s3,15
 d0c:	0049d993          	srli	s3,s3,0x4
 d10:	2985                	addiw	s3,s3,1
 d12:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 d14:	00001517          	auipc	a0,0x1
 d18:	2ec53503          	ld	a0,748(a0) # 2000 <freep>
 d1c:	c905                	beqz	a0,d4c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d1e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d20:	4798                	lw	a4,8(a5)
 d22:	09377663          	bgeu	a4,s3,dae <malloc+0xb8>
 d26:	f426                	sd	s1,40(sp)
 d28:	e852                	sd	s4,16(sp)
 d2a:	e456                	sd	s5,8(sp)
 d2c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 d2e:	8a4e                	mv	s4,s3
 d30:	6705                	lui	a4,0x1
 d32:	00e9f363          	bgeu	s3,a4,d38 <malloc+0x42>
 d36:	6a05                	lui	s4,0x1
 d38:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d3c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d40:	00001497          	auipc	s1,0x1
 d44:	2c048493          	addi	s1,s1,704 # 2000 <freep>
  if(p == SBRK_ERROR)
 d48:	5afd                	li	s5,-1
 d4a:	a83d                	j	d88 <malloc+0x92>
 d4c:	f426                	sd	s1,40(sp)
 d4e:	e852                	sd	s4,16(sp)
 d50:	e456                	sd	s5,8(sp)
 d52:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 d54:	00001797          	auipc	a5,0x1
 d58:	2bc78793          	addi	a5,a5,700 # 2010 <base>
 d5c:	00001717          	auipc	a4,0x1
 d60:	2af73223          	sd	a5,676(a4) # 2000 <freep>
 d64:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 d66:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d6a:	b7d1                	j	d2e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 d6c:	6398                	ld	a4,0(a5)
 d6e:	e118                	sd	a4,0(a0)
 d70:	a899                	j	dc6 <malloc+0xd0>
  hp->s.size = nu;
 d72:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d76:	0541                	addi	a0,a0,16
 d78:	ef9ff0ef          	jal	c70 <free>
  return freep;
 d7c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 d7e:	c125                	beqz	a0,dde <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d80:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d82:	4798                	lw	a4,8(a5)
 d84:	03277163          	bgeu	a4,s2,da6 <malloc+0xb0>
    if(p == freep)
 d88:	6098                	ld	a4,0(s1)
 d8a:	853e                	mv	a0,a5
 d8c:	fef71ae3          	bne	a4,a5,d80 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 d90:	8552                	mv	a0,s4
 d92:	9e3ff0ef          	jal	774 <sbrk>
  if(p == SBRK_ERROR)
 d96:	fd551ee3          	bne	a0,s5,d72 <malloc+0x7c>
        return 0;
 d9a:	4501                	li	a0,0
 d9c:	74a2                	ld	s1,40(sp)
 d9e:	6a42                	ld	s4,16(sp)
 da0:	6aa2                	ld	s5,8(sp)
 da2:	6b02                	ld	s6,0(sp)
 da4:	a03d                	j	dd2 <malloc+0xdc>
 da6:	74a2                	ld	s1,40(sp)
 da8:	6a42                	ld	s4,16(sp)
 daa:	6aa2                	ld	s5,8(sp)
 dac:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 dae:	fae90fe3          	beq	s2,a4,d6c <malloc+0x76>
        p->s.size -= nunits;
 db2:	4137073b          	subw	a4,a4,s3
 db6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 db8:	02071693          	slli	a3,a4,0x20
 dbc:	01c6d713          	srli	a4,a3,0x1c
 dc0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 dc2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 dc6:	00001717          	auipc	a4,0x1
 dca:	22a73d23          	sd	a0,570(a4) # 2000 <freep>
      return (void*)(p + 1);
 dce:	01078513          	addi	a0,a5,16
  }
}
 dd2:	70e2                	ld	ra,56(sp)
 dd4:	7442                	ld	s0,48(sp)
 dd6:	7902                	ld	s2,32(sp)
 dd8:	69e2                	ld	s3,24(sp)
 dda:	6121                	addi	sp,sp,64
 ddc:	8082                	ret
 dde:	74a2                	ld	s1,40(sp)
 de0:	6a42                	ld	s4,16(sp)
 de2:	6aa2                	ld	s5,8(sp)
 de4:	6b02                	ld	s6,0(sp)
 de6:	b7f5                	j	dd2 <malloc+0xdc>
