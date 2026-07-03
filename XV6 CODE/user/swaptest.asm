
user/_swaptest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fill>:
}

// fill page i with a deterministic pattern seeded by `round`
static void
fill(char *p, int page, int round)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  for(int j = 0; j < PAGE_SIZE; j++)
    p[j] = (char)((page * 13 + j * 7 + round * 31) & 0xFF);
       8:	0015979b          	slliw	a5,a1,0x1
       c:	9fad                	addw	a5,a5,a1
       e:	0027979b          	slliw	a5,a5,0x2
      12:	9fad                	addw	a5,a5,a1
      14:	0056171b          	slliw	a4,a2,0x5
      18:	9f11                	subw	a4,a4,a2
      1a:	9fb9                	addw	a5,a5,a4
      1c:	0ff7f793          	zext.b	a5,a5
      20:	872a                	mv	a4,a0
      22:	6685                	lui	a3,0x1
      24:	96aa                	add	a3,a3,a0
      26:	00f70023          	sb	a5,0(a4)
  for(int j = 0; j < PAGE_SIZE; j++)
      2a:	279d                	addiw	a5,a5,7
      2c:	0ff7f793          	zext.b	a5,a5
      30:	0705                	addi	a4,a4,1
      32:	fed71ae3          	bne	a4,a3,26 <fill+0x26>
}
      36:	60a2                	ld	ra,8(sp)
      38:	6402                	ld	s0,0(sp)
      3a:	0141                	addi	sp,sp,16
      3c:	8082                	ret

000000000000003e <check>:

static int
check(char *p, int page, int round)
{
      3e:	1141                	addi	sp,sp,-16
      40:	e406                	sd	ra,8(sp)
      42:	e022                	sd	s0,0(sp)
      44:	0800                	addi	s0,sp,16
  for(int j = 0; j < PAGE_SIZE; j++){
    char expected = (char)((page * 13 + j * 7 + round * 31) & 0xFF);
      46:	0015979b          	slliw	a5,a1,0x1
      4a:	9fad                	addw	a5,a5,a1
      4c:	0027979b          	slliw	a5,a5,0x2
      50:	9fad                	addw	a5,a5,a1
      52:	0056171b          	slliw	a4,a2,0x5
      56:	9f11                	subw	a4,a4,a2
      58:	9fb9                	addw	a5,a5,a4
      5a:	0ff7f793          	zext.b	a5,a5
      5e:	872a                	mv	a4,a0
      60:	6685                	lui	a3,0x1
      62:	9536                	add	a0,a0,a3
    if(p[j] != expected) return 0;
      64:	00074683          	lbu	a3,0(a4)
      68:	00f69a63          	bne	a3,a5,7c <check+0x3e>
  for(int j = 0; j < PAGE_SIZE; j++){
      6c:	0705                	addi	a4,a4,1
      6e:	279d                	addiw	a5,a5,7
      70:	0ff7f793          	zext.b	a5,a5
      74:	fea718e3          	bne	a4,a0,64 <check+0x26>
  }
  return 1;
      78:	4505                	li	a0,1
      7a:	a011                	j	7e <check+0x40>
    if(p[j] != expected) return 0;
      7c:	4501                	li	a0,0
}
      7e:	60a2                	ld	ra,8(sp)
      80:	6402                	ld	s0,0(sp)
      82:	0141                	addi	sp,sp,16
      84:	8082                	ret

0000000000000086 <result>:
{
      86:	1141                	addi	sp,sp,-16
      88:	e406                	sd	ra,8(sp)
      8a:	e022                	sd	s0,0(sp)
      8c:	0800                	addi	s0,sp,16
  if(ok){ printf("  PASS: %s\n", name); total_pass++; }
      8e:	c19d                	beqz	a1,b4 <result+0x2e>
      90:	85aa                	mv	a1,a0
      92:	00001517          	auipc	a0,0x1
      96:	0fe50513          	addi	a0,a0,254 # 1190 <malloc+0x100>
      9a:	73f000ef          	jal	fd8 <printf>
      9e:	00002717          	auipc	a4,0x2
      a2:	f6670713          	addi	a4,a4,-154 # 2004 <total_pass>
      a6:	431c                	lw	a5,0(a4)
      a8:	2785                	addiw	a5,a5,1
      aa:	c31c                	sw	a5,0(a4)
}
      ac:	60a2                	ld	ra,8(sp)
      ae:	6402                	ld	s0,0(sp)
      b0:	0141                	addi	sp,sp,16
      b2:	8082                	ret
  else  { printf("  FAIL: %s\n", name); total_fail++; }
      b4:	85aa                	mv	a1,a0
      b6:	00001517          	auipc	a0,0x1
      ba:	0ea50513          	addi	a0,a0,234 # 11a0 <malloc+0x110>
      be:	71b000ef          	jal	fd8 <printf>
      c2:	00002717          	auipc	a4,0x2
      c6:	f3e70713          	addi	a4,a4,-194 # 2000 <total_fail>
      ca:	431c                	lw	a5,0(a4)
      cc:	2785                	addiw	a5,a5,1
      ce:	c31c                	sw	a5,0(a4)
}
      d0:	bff1                	j	ac <result+0x26>

00000000000000d2 <main>:
}

// ── main ───────────────────────────────────────────────────────────────────
int
main(void)
{
      d2:	7151                	addi	sp,sp,-240
      d4:	f586                	sd	ra,232(sp)
      d6:	f1a2                	sd	s0,224(sp)
      d8:	eda6                	sd	s1,216(sp)
      da:	e9ca                	sd	s2,208(sp)
      dc:	e5ce                	sd	s3,200(sp)
      de:	e1d2                	sd	s4,192(sp)
      e0:	fd56                	sd	s5,184(sp)
      e2:	f95a                	sd	s6,176(sp)
      e4:	f55e                	sd	s7,168(sp)
      e6:	f162                	sd	s8,160(sp)
      e8:	ed66                	sd	s9,152(sp)
      ea:	1980                	addi	s0,sp,240
  printf("=== swaptest (rigorous) ===\n");
      ec:	00001517          	auipc	a0,0x1
      f0:	0c450513          	addi	a0,a0,196 # 11b0 <malloc+0x120>
      f4:	6e5000ef          	jal	fd8 <printf>
  printf("\n[T1] Basic eviction + swap-in correctness\n");
      f8:	00001517          	auipc	a0,0x1
      fc:	0d850513          	addi	a0,a0,216 # 11d0 <malloc+0x140>
     100:	6d9000ef          	jal	fd8 <printf>
  char *base = sbrk(VERIFY_PAGES * PAGE_SIZE);
     104:	00040537          	lui	a0,0x40
     108:	207000ef          	jal	b0e <sbrk>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     10c:	577d                	li	a4,-1
     10e:	8aaa                	mv	s5,a0
     110:	892a                	mv	s2,a0
  for(int i = 0; i < VERIFY_PAGES; i++)
     112:	4481                	li	s1,0
     114:	6a05                	lui	s4,0x1
     116:	04000993          	li	s3,64
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     11a:	14e50263          	beq	a0,a4,25e <main+0x18c>
    fill(base + i * PAGE_SIZE, i, 0);
     11e:	4601                	li	a2,0
     120:	85a6                	mv	a1,s1
     122:	854a                	mv	a0,s2
     124:	eddff0ef          	jal	0 <fill>
  for(int i = 0; i < VERIFY_PAGES; i++)
     128:	2485                	addiw	s1,s1,1
     12a:	9952                	add	s2,s2,s4
     12c:	ff3499e3          	bne	s1,s3,11e <main+0x4c>
  char *pressure = sbrk(PRESSURE * PAGE_SIZE);
     130:	00048537          	lui	a0,0x48
     134:	1db000ef          	jal	b0e <sbrk>
     138:	892a                	mv	s2,a0
  if(pressure != (char*)-1){
     13a:	57fd                	li	a5,-1
     13c:	00f50d63          	beq	a0,a5,156 <main+0x84>
     140:	872a                	mv	a4,a0
    for(int i = 0; i < PRESSURE; i++)
     142:	4781                	li	a5,0
     144:	6605                	lui	a2,0x1
     146:	04800693          	li	a3,72
      pressure[i * PAGE_SIZE] = (char)i;   // touch each page
     14a:	00f70023          	sb	a5,0(a4)
    for(int i = 0; i < PRESSURE; i++)
     14e:	2785                	addiw	a5,a5,1
     150:	9732                	add	a4,a4,a2
     152:	fed79ce3          	bne	a5,a3,14a <main+0x78>
     156:	4481                	li	s1,0
  for(int i = 0; i < VERIFY_PAGES; i++)
     158:	6a05                	lui	s4,0x1
     15a:	04000993          	li	s3,64
    if(!check(base + i * PAGE_SIZE, i, 0)){ ok = 0; break; }
     15e:	4601                	li	a2,0
     160:	85a6                	mv	a1,s1
     162:	8556                	mv	a0,s5
     164:	edbff0ef          	jal	3e <check>
     168:	85aa                	mv	a1,a0
     16a:	c511                	beqz	a0,176 <main+0xa4>
  for(int i = 0; i < VERIFY_PAGES; i++)
     16c:	2485                	addiw	s1,s1,1
     16e:	9ad2                	add	s5,s5,s4
     170:	ff3497e3          	bne	s1,s3,15e <main+0x8c>
  int ok = 1;
     174:	4585                	li	a1,1
  result("all pages correct after swap-in", ok);
     176:	00001517          	auipc	a0,0x1
     17a:	09a50513          	addi	a0,a0,154 # 1210 <malloc+0x180>
     17e:	f09ff0ef          	jal	86 <result>
  getvmstats(getpid(), &s);
     182:	241000ef          	jal	bc2 <getpid>
     186:	f7040593          	addi	a1,s0,-144
     18a:	299000ef          	jal	c22 <getvmstats>
  result("disk_writes > 0 (eviction happened)", s.disk_writes > 0);
     18e:	f9043583          	ld	a1,-112(s0)
     192:	00b035b3          	snez	a1,a1
     196:	00001517          	auipc	a0,0x1
     19a:	09a50513          	addi	a0,a0,154 # 1230 <malloc+0x1a0>
     19e:	ee9ff0ef          	jal	86 <result>
  result("disk_reads  > 0 (swap-in  happened)", s.disk_reads  > 0);
     1a2:	f8843583          	ld	a1,-120(s0)
     1a6:	00b035b3          	snez	a1,a1
     1aa:	00001517          	auipc	a0,0x1
     1ae:	0ae50513          	addi	a0,a0,174 # 1258 <malloc+0x1c8>
     1b2:	ed5ff0ef          	jal	86 <result>
  if(pressure != (char*)-1)
     1b6:	57fd                	li	a5,-1
     1b8:	00f90663          	beq	s2,a5,1c4 <main+0xf2>
    sbrk(-(PRESSURE * PAGE_SIZE));
     1bc:	fffb8537          	lui	a0,0xfffb8
     1c0:	14f000ef          	jal	b0e <sbrk>
  sbrk(-(VERIFY_PAGES * PAGE_SIZE));
     1c4:	fffc0537          	lui	a0,0xfffc0
     1c8:	147000ef          	jal	b0e <sbrk>
  printf("\n[T2] Byte-level pattern integrity\n");
     1cc:	00001517          	auipc	a0,0x1
     1d0:	0b450513          	addi	a0,a0,180 # 1280 <malloc+0x1f0>
     1d4:	605000ef          	jal	fd8 <printf>
  char *base = sbrk(VERIFY_PAGES * PAGE_SIZE);
     1d8:	00040537          	lui	a0,0x40
     1dc:	133000ef          	jal	b0e <sbrk>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     1e0:	57fd                	li	a5,-1
     1e2:	4581                	li	a1,0
     1e4:	0ab00693          	li	a3,171
    for(int j = 0; j < PAGE_SIZE; j++)
     1e8:	6805                	lui	a6,0x1
  for(int i = 0; i < VERIFY_PAGES; i++)
     1ea:	0eb00893          	li	a7,235
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     1ee:	08f50663          	beq	a0,a5,27a <main+0x1a8>
    for(int j = 0; j < PAGE_SIZE; j++)
     1f2:	84aa                	mv	s1,a0
     1f4:	00b50733          	add	a4,a0,a1
  int ok = 1;
     1f8:	87b6                	mv	a5,a3
    for(int j = 0; j < PAGE_SIZE; j++)
     1fa:	01050633          	add	a2,a0,a6
     1fe:	962e                	add	a2,a2,a1
      base[i * PAGE_SIZE + j] = (char)((i * 97 + j * 3 + 0xAB) & 0xFF);
     200:	00f70023          	sb	a5,0(a4)
    for(int j = 0; j < PAGE_SIZE; j++)
     204:	278d                	addiw	a5,a5,3
     206:	0ff7f793          	zext.b	a5,a5
     20a:	0705                	addi	a4,a4,1
     20c:	fec71ae3          	bne	a4,a2,200 <main+0x12e>
  for(int i = 0; i < VERIFY_PAGES; i++)
     210:	0616869b          	addiw	a3,a3,97 # 1061 <free+0x57>
     214:	0ff6f693          	zext.b	a3,a3
     218:	95c2                	add	a1,a1,a6
     21a:	fd169ce3          	bne	a3,a7,1f2 <main+0x120>
  char *p = sbrk(PRESSURE * PAGE_SIZE);
     21e:	00048537          	lui	a0,0x48
     222:	0ed000ef          	jal	b0e <sbrk>
  if(p != (char*)-1){
     226:	57fd                	li	a5,-1
     228:	02f50163          	beq	a0,a5,24a <main+0x178>
     22c:	87aa                	mv	a5,a0
     22e:	000486b7          	lui	a3,0x48
     232:	00d50733          	add	a4,a0,a3
    for(int i = 0; i < PRESSURE; i++) p[i * PAGE_SIZE] = 0;
     236:	6685                	lui	a3,0x1
     238:	00078023          	sb	zero,0(a5)
     23c:	97b6                	add	a5,a5,a3
     23e:	fee79de3          	bne	a5,a4,238 <main+0x166>
    sbrk(-(PRESSURE * PAGE_SIZE));
     242:	fffb8537          	lui	a0,0xfffb8
     246:	0c9000ef          	jal	b0e <sbrk>
        if(first_err_page < 0){ first_err_page = i; first_err_byte = j; }
     24a:	0ab00693          	li	a3,171
  int first_err_page = -1, first_err_byte = -1;
     24e:	567d                	li	a2,-1
     250:	85b2                	mv	a1,a2
  int errors = 0;
     252:	4901                	li	s2,0
  for(int i = 0; i < VERIFY_PAGES; i++){
     254:	4501                	li	a0,0
    for(int j = 0; j < PAGE_SIZE; j++){
     256:	6885                	lui	a7,0x1
  for(int i = 0; i < VERIFY_PAGES; i++){
     258:	04000313          	li	t1,64
     25c:	a885                	j	2cc <main+0x1fa>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     25e:	00001517          	auipc	a0,0x1
     262:	fa250513          	addi	a0,a0,-94 # 1200 <malloc+0x170>
     266:	573000ef          	jal	fd8 <printf>
     26a:	00002717          	auipc	a4,0x2
     26e:	d9670713          	addi	a4,a4,-618 # 2000 <total_fail>
     272:	431c                	lw	a5,0(a4)
     274:	2785                	addiw	a5,a5,1
     276:	c31c                	sw	a5,0(a4)
     278:	bf91                	j	1cc <main+0xfa>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     27a:	00001517          	auipc	a0,0x1
     27e:	f8650513          	addi	a0,a0,-122 # 1200 <malloc+0x170>
     282:	557000ef          	jal	fd8 <printf>
     286:	00002717          	auipc	a4,0x2
     28a:	d7a70713          	addi	a4,a4,-646 # 2000 <total_fail>
     28e:	431c                	lw	a5,0(a4)
     290:	2785                	addiw	a5,a5,1
     292:	c31c                	sw	a5,0(a4)
     294:	a8b1                	j	2f0 <main+0x21e>
        errors++;
     296:	2905                	addiw	s2,s2,1
    for(int j = 0; j < PAGE_SIZE; j++){
     298:	0705                	addi	a4,a4,1
     29a:	278d                	addiw	a5,a5,3
     29c:	0ff7f793          	zext.b	a5,a5
     2a0:	01170e63          	beq	a4,a7,2bc <main+0x1ea>
      if(base[i * PAGE_SIZE + j] != expected){
     2a4:	00e48833          	add	a6,s1,a4
     2a8:	00084803          	lbu	a6,0(a6) # 1000 <printf+0x28>
     2ac:	fef806e3          	beq	a6,a5,298 <main+0x1c6>
        if(first_err_page < 0){ first_err_page = i; first_err_byte = j; }
     2b0:	fe05d3e3          	bgez	a1,296 <main+0x1c4>
     2b4:	0007061b          	sext.w	a2,a4
     2b8:	85f2                	mv	a1,t3
     2ba:	bff1                	j	296 <main+0x1c4>
  for(int i = 0; i < VERIFY_PAGES; i++){
     2bc:	2505                	addiw	a0,a0,1
     2be:	0616869b          	addiw	a3,a3,97 # 1061 <free+0x57>
     2c2:	0ff6f693          	zext.b	a3,a3
     2c6:	94c6                	add	s1,s1,a7
     2c8:	00650663          	beq	a0,t1,2d4 <main+0x202>
    for(int j = 0; j < PAGE_SIZE; j++){
     2cc:	87b6                	mv	a5,a3
     2ce:	4701                	li	a4,0
        if(first_err_page < 0){ first_err_page = i; first_err_byte = j; }
     2d0:	8e2a                	mv	t3,a0
     2d2:	bfc9                	j	2a4 <main+0x1d2>
  if(errors > 0)
     2d4:	05204463          	bgtz	s2,31c <main+0x24a>
  result("zero byte-level errors across all pages", errors == 0);
     2d8:	00193593          	seqz	a1,s2
     2dc:	00001517          	auipc	a0,0x1
     2e0:	ff450513          	addi	a0,a0,-12 # 12d0 <malloc+0x240>
     2e4:	da3ff0ef          	jal	86 <result>
  sbrk(-(VERIFY_PAGES * PAGE_SIZE));
     2e8:	fffc0537          	lui	a0,0xfffc0
     2ec:	023000ef          	jal	b0e <sbrk>
  printf("\n[T3] Repeated write-evict-read cycles (3 rounds)\n");
     2f0:	00001517          	auipc	a0,0x1
     2f4:	00850513          	addi	a0,a0,8 # 12f8 <malloc+0x268>
     2f8:	4e1000ef          	jal	fd8 <printf>
  char *base = sbrk(CYCLE_PAGES * PAGE_SIZE);
     2fc:	00028537          	lui	a0,0x28
     300:	00f000ef          	jal	b0e <sbrk>
     304:	8caa                	mv	s9,a0
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     306:	57fd                	li	a5,-1
     308:	04800a13          	li	s4,72
  for(int r = 0; r < ROUNDS; r++){
     30c:	4901                	li	s2,0
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     30e:	00f50e63          	beq	a0,a5,32a <main+0x258>
    for(int i = 0; i < CYCLE_PAGES; i++)
     312:	6485                	lui	s1,0x1
     314:	02800993          	li	s3,40
    if(p != (char*)-1){
     318:	8b3e                	mv	s6,a5
     31a:	a0e9                	j	3e4 <main+0x312>
    printf("  first error at page=%d byte=%d\n", first_err_page, first_err_byte);
     31c:	00001517          	auipc	a0,0x1
     320:	f8c50513          	addi	a0,a0,-116 # 12a8 <malloc+0x218>
     324:	4b5000ef          	jal	fd8 <printf>
     328:	bf45                	j	2d8 <main+0x206>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     32a:	00001517          	auipc	a0,0x1
     32e:	ed650513          	addi	a0,a0,-298 # 1200 <malloc+0x170>
     332:	4a7000ef          	jal	fd8 <printf>
     336:	00002717          	auipc	a4,0x2
     33a:	cca70713          	addi	a4,a4,-822 # 2000 <total_fail>
     33e:	431c                	lw	a5,0(a4)
     340:	2785                	addiw	a5,a5,1
     342:	c31c                	sw	a5,0(a4)
     344:	a0e5                	j	42c <main+0x35a>
     346:	0ff97793          	zext.b	a5,s2
      for(int i = 0; i < PRESSURE; i++) p[i * PAGE_SIZE] = (char)(r + i);
     34a:	00f70023          	sb	a5,0(a4)
     34e:	2785                	addiw	a5,a5,1
     350:	0ff7f793          	zext.b	a5,a5
     354:	9726                	add	a4,a4,s1
     356:	ff479ae3          	bne	a5,s4,34a <main+0x278>
      sbrk(-(PRESSURE * PAGE_SIZE));
     35a:	fffb8537          	lui	a0,0xfffb8
     35e:	7b0000ef          	jal	b0e <sbrk>
     362:	a065                	j	40a <main+0x338>
    label[0] = 'r'; label[1] = 'o'; label[2] = 'u'; label[3] = 'n';
     364:	07200793          	li	a5,114
     368:	f6f40823          	sb	a5,-144(s0)
     36c:	06f00693          	li	a3,111
     370:	f6d408a3          	sb	a3,-143(s0)
     374:	07500713          	li	a4,117
     378:	f6e40923          	sb	a4,-142(s0)
     37c:	06e00713          	li	a4,110
     380:	f6e409a3          	sb	a4,-141(s0)
    label[4] = 'd'; label[5] = ' '; label[6] = (char)('0' + r);
     384:	06400713          	li	a4,100
     388:	f6e40a23          	sb	a4,-140(s0)
     38c:	02000713          	li	a4,32
     390:	f6e40aa3          	sb	a4,-139(s0)
     394:	0309061b          	addiw	a2,s2,48
     398:	f6c40b23          	sb	a2,-138(s0)
    label[7] = ' '; label[8] = 'c'; label[9] = 'o'; label[10] = 'r';
     39c:	f6e40ba3          	sb	a4,-137(s0)
     3a0:	06300713          	li	a4,99
     3a4:	f6e40c23          	sb	a4,-136(s0)
     3a8:	f6d40ca3          	sb	a3,-135(s0)
     3ac:	f6f40d23          	sb	a5,-134(s0)
    label[11] = 'r'; label[12] = 'e'; label[13] = 'c'; label[14] = 't';
     3b0:	f6f40da3          	sb	a5,-133(s0)
     3b4:	06500793          	li	a5,101
     3b8:	f6f40e23          	sb	a5,-132(s0)
     3bc:	f6e40ea3          	sb	a4,-131(s0)
     3c0:	07400793          	li	a5,116
     3c4:	f6f40f23          	sb	a5,-130(s0)
    label[15] = '\0';
     3c8:	f6040fa3          	sb	zero,-129(s0)
    result(label, ok);
     3cc:	85aa                	mv	a1,a0
     3ce:	f7040513          	addi	a0,s0,-144
     3d2:	cb5ff0ef          	jal	86 <result>
  for(int r = 0; r < ROUNDS; r++){
     3d6:	2905                	addiw	s2,s2,1
     3d8:	2a05                	addiw	s4,s4,1 # 1001 <printf+0x29>
     3da:	0ffa7a13          	zext.b	s4,s4
     3de:	478d                	li	a5,3
     3e0:	04f90263          	beq	s2,a5,424 <main+0x352>
    for(int i = 0; i < CYCLE_PAGES; i++)
     3e4:	8c66                	mv	s8,s9
     3e6:	8ae6                	mv	s5,s9
     3e8:	4b81                	li	s7,0
      fill(base + i * PAGE_SIZE, i, r);
     3ea:	864a                	mv	a2,s2
     3ec:	85de                	mv	a1,s7
     3ee:	8562                	mv	a0,s8
     3f0:	c11ff0ef          	jal	0 <fill>
    for(int i = 0; i < CYCLE_PAGES; i++)
     3f4:	2b85                	addiw	s7,s7,1
     3f6:	9c26                	add	s8,s8,s1
     3f8:	ff3b99e3          	bne	s7,s3,3ea <main+0x318>
    char *p = sbrk(PRESSURE * PAGE_SIZE);
     3fc:	00048537          	lui	a0,0x48
     400:	70e000ef          	jal	b0e <sbrk>
     404:	872a                	mv	a4,a0
    if(p != (char*)-1){
     406:	f56510e3          	bne	a0,s6,346 <main+0x274>
    for(int i = 0; i < CYCLE_PAGES; i++)
     40a:	4b81                	li	s7,0
      if(!check(base + i * PAGE_SIZE, i, r)){ ok = 0; break; }
     40c:	864a                	mv	a2,s2
     40e:	85de                	mv	a1,s7
     410:	8556                	mv	a0,s5
     412:	c2dff0ef          	jal	3e <check>
     416:	d539                	beqz	a0,364 <main+0x292>
    for(int i = 0; i < CYCLE_PAGES; i++)
     418:	2b85                	addiw	s7,s7,1
     41a:	9aa6                	add	s5,s5,s1
     41c:	ff3b98e3          	bne	s7,s3,40c <main+0x33a>
    int ok = 1;
     420:	4505                	li	a0,1
     422:	b789                	j	364 <main+0x292>
  sbrk(-(CYCLE_PAGES * PAGE_SIZE));
     424:	fffd8537          	lui	a0,0xfffd8
     428:	6e6000ef          	jal	b0e <sbrk>
  printf("\n[T4] Stats monotonically increase across workloads\n");
     42c:	00001517          	auipc	a0,0x1
     430:	f0450513          	addi	a0,a0,-252 # 1330 <malloc+0x2a0>
     434:	3a5000ef          	jal	fd8 <printf>
  getvmstats(getpid(), &s0);
     438:	78a000ef          	jal	bc2 <getpid>
     43c:	f1040593          	addi	a1,s0,-240
     440:	7e2000ef          	jal	c22 <getvmstats>
  char *b = sbrk(VERIFY_PAGES * PAGE_SIZE);
     444:	00040537          	lui	a0,0x40
     448:	6c6000ef          	jal	b0e <sbrk>
     44c:	892a                	mv	s2,a0
  if(b != (char*)-1){
     44e:	57fd                	li	a5,-1
     450:	06f50463          	beq	a0,a5,4b8 <main+0x3e6>
    for(int i = 0; i < VERIFY_PAGES; i++) fill(b + i*PAGE_SIZE, i, 10);
     454:	4481                	li	s1,0
     456:	4aa9                	li	s5,10
     458:	6a05                	lui	s4,0x1
     45a:	04000993          	li	s3,64
     45e:	8656                	mv	a2,s5
     460:	85a6                	mv	a1,s1
     462:	854a                	mv	a0,s2
     464:	b9dff0ef          	jal	0 <fill>
     468:	2485                	addiw	s1,s1,1 # 1001 <printf+0x29>
     46a:	9952                	add	s2,s2,s4
     46c:	ff3499e3          	bne	s1,s3,45e <main+0x38c>
    char *p = sbrk(PRESSURE * PAGE_SIZE);
     470:	00048537          	lui	a0,0x48
     474:	69a000ef          	jal	b0e <sbrk>
    if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     478:	57fd                	li	a5,-1
     47a:	02f50163          	beq	a0,a5,49c <main+0x3ca>
     47e:	87aa                	mv	a5,a0
     480:	000486b7          	lui	a3,0x48
     484:	00d50733          	add	a4,a0,a3
     488:	6685                	lui	a3,0x1
     48a:	00078023          	sb	zero,0(a5)
     48e:	97b6                	add	a5,a5,a3
     490:	fee79de3          	bne	a5,a4,48a <main+0x3b8>
     494:	fffb8537          	lui	a0,0xfffb8
     498:	676000ef          	jal	b0e <sbrk>
    for(int i = 0; i < VERIFY_PAGES; i++) fill(b + i*PAGE_SIZE, i, 10);
     49c:	04000793          	li	a5,64
    for(int i = 0; i < VERIFY_PAGES; i++) (void)b[i*PAGE_SIZE]; // force reads
     4a0:	37fd                	addiw	a5,a5,-1
     4a2:	fffd                	bnez	a5,4a0 <main+0x3ce>
    getvmstats(getpid(), &s1);
     4a4:	71e000ef          	jal	bc2 <getpid>
     4a8:	f4040593          	addi	a1,s0,-192
     4ac:	776000ef          	jal	c22 <getvmstats>
    sbrk(-(VERIFY_PAGES * PAGE_SIZE));
     4b0:	fffc0537          	lui	a0,0xfffc0
     4b4:	65a000ef          	jal	b0e <sbrk>
  b = sbrk(VERIFY_PAGES * PAGE_SIZE);
     4b8:	00040537          	lui	a0,0x40
     4bc:	652000ef          	jal	b0e <sbrk>
     4c0:	892a                	mv	s2,a0
  if(b != (char*)-1){
     4c2:	57fd                	li	a5,-1
     4c4:	06f50463          	beq	a0,a5,52c <main+0x45a>
    for(int i = 0; i < VERIFY_PAGES; i++) fill(b + i*PAGE_SIZE, i, 20);
     4c8:	4481                	li	s1,0
     4ca:	4ad1                	li	s5,20
     4cc:	6a05                	lui	s4,0x1
     4ce:	04000993          	li	s3,64
     4d2:	8656                	mv	a2,s5
     4d4:	85a6                	mv	a1,s1
     4d6:	854a                	mv	a0,s2
     4d8:	b29ff0ef          	jal	0 <fill>
     4dc:	2485                	addiw	s1,s1,1
     4de:	9952                	add	s2,s2,s4
     4e0:	ff3499e3          	bne	s1,s3,4d2 <main+0x400>
    char *p = sbrk(PRESSURE * PAGE_SIZE);
     4e4:	00048537          	lui	a0,0x48
     4e8:	626000ef          	jal	b0e <sbrk>
    if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     4ec:	57fd                	li	a5,-1
     4ee:	02f50163          	beq	a0,a5,510 <main+0x43e>
     4f2:	87aa                	mv	a5,a0
     4f4:	000486b7          	lui	a3,0x48
     4f8:	00d50733          	add	a4,a0,a3
     4fc:	6685                	lui	a3,0x1
     4fe:	00078023          	sb	zero,0(a5)
     502:	97b6                	add	a5,a5,a3
     504:	fef71de3          	bne	a4,a5,4fe <main+0x42c>
     508:	fffb8537          	lui	a0,0xfffb8
     50c:	602000ef          	jal	b0e <sbrk>
    for(int i = 0; i < VERIFY_PAGES; i++) fill(b + i*PAGE_SIZE, i, 20);
     510:	04000793          	li	a5,64
    for(int i = 0; i < VERIFY_PAGES; i++) (void)b[i*PAGE_SIZE];
     514:	37fd                	addiw	a5,a5,-1
     516:	fffd                	bnez	a5,514 <main+0x442>
    getvmstats(getpid(), &s2);
     518:	6aa000ef          	jal	bc2 <getpid>
     51c:	f7040593          	addi	a1,s0,-144
     520:	702000ef          	jal	c22 <getvmstats>
    sbrk(-(VERIFY_PAGES * PAGE_SIZE));
     524:	fffc0537          	lui	a0,0xfffc0
     528:	5e6000ef          	jal	b0e <sbrk>
  result("writes increase after 1st workload", s1.disk_writes > s0.disk_writes);
     52c:	f6043583          	ld	a1,-160(s0)
     530:	f3043783          	ld	a5,-208(s0)
     534:	00b7b5b3          	sltu	a1,a5,a1
     538:	00001517          	auipc	a0,0x1
     53c:	e3050513          	addi	a0,a0,-464 # 1368 <malloc+0x2d8>
     540:	b47ff0ef          	jal	86 <result>
  result("reads  increase after 1st workload", s1.disk_reads  > s0.disk_reads);
     544:	f5843583          	ld	a1,-168(s0)
     548:	f2843783          	ld	a5,-216(s0)
     54c:	00b7b5b3          	sltu	a1,a5,a1
     550:	00001517          	auipc	a0,0x1
     554:	e4050513          	addi	a0,a0,-448 # 1390 <malloc+0x300>
     558:	b2fff0ef          	jal	86 <result>
  result("writes increase after 2nd workload", s2.disk_writes > s1.disk_writes);
     55c:	f9043583          	ld	a1,-112(s0)
     560:	f6043783          	ld	a5,-160(s0)
     564:	00b7b5b3          	sltu	a1,a5,a1
     568:	00001517          	auipc	a0,0x1
     56c:	e5050513          	addi	a0,a0,-432 # 13b8 <malloc+0x328>
     570:	b17ff0ef          	jal	86 <result>
  result("reads  increase after 2nd workload", s2.disk_reads  > s1.disk_reads);
     574:	f8843583          	ld	a1,-120(s0)
     578:	f5843783          	ld	a5,-168(s0)
     57c:	00b7b5b3          	sltu	a1,a5,a1
     580:	00001517          	auipc	a0,0x1
     584:	e6050513          	addi	a0,a0,-416 # 13e0 <malloc+0x350>
     588:	affff0ef          	jal	86 <result>
  printf("\n[T5] Fork: parent and child survive swap independently\n");
     58c:	00001517          	auipc	a0,0x1
     590:	e7c50513          	addi	a0,a0,-388 # 1408 <malloc+0x378>
     594:	245000ef          	jal	fd8 <printf>
  char *base = sbrk(FORK_PAGES * PAGE_SIZE);
     598:	00030537          	lui	a0,0x30
     59c:	572000ef          	jal	b0e <sbrk>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     5a0:	577d                	li	a4,-1
     5a2:	8a2a                	mv	s4,a0
     5a4:	892a                	mv	s2,a0
  for(int i = 0; i < FORK_PAGES; i++)
     5a6:	4481                	li	s1,0
    fill(base + i * PAGE_SIZE, i, 99);
     5a8:	06300b13          	li	s6,99
  for(int i = 0; i < FORK_PAGES; i++)
     5ac:	6a85                	lui	s5,0x1
     5ae:	03000993          	li	s3,48
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     5b2:	0ce50063          	beq	a0,a4,672 <main+0x5a0>
    fill(base + i * PAGE_SIZE, i, 99);
     5b6:	865a                	mv	a2,s6
     5b8:	85a6                	mv	a1,s1
     5ba:	854a                	mv	a0,s2
     5bc:	a45ff0ef          	jal	0 <fill>
  for(int i = 0; i < FORK_PAGES; i++)
     5c0:	2485                	addiw	s1,s1,1
     5c2:	9956                	add	s2,s2,s5
     5c4:	ff3499e3          	bne	s1,s3,5b6 <main+0x4e4>
  char *p = sbrk(PRESSURE * PAGE_SIZE);
     5c8:	00048537          	lui	a0,0x48
     5cc:	542000ef          	jal	b0e <sbrk>
  if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     5d0:	57fd                	li	a5,-1
     5d2:	02f50163          	beq	a0,a5,5f4 <main+0x522>
     5d6:	87aa                	mv	a5,a0
     5d8:	000486b7          	lui	a3,0x48
     5dc:	00d50733          	add	a4,a0,a3
     5e0:	6685                	lui	a3,0x1
     5e2:	00078023          	sb	zero,0(a5)
     5e6:	97b6                	add	a5,a5,a3
     5e8:	fef71de3          	bne	a4,a5,5e2 <main+0x510>
     5ec:	fffb8537          	lui	a0,0xfffb8
     5f0:	51e000ef          	jal	b0e <sbrk>
  int pid = fork();
     5f4:	546000ef          	jal	b3a <fork>
  if(pid < 0){ printf("  FAIL: fork\n"); total_fail++; sbrk(-(FORK_PAGES*PAGE_SIZE)); return; }
     5f8:	08054b63          	bltz	a0,68e <main+0x5bc>
  if(pid == 0){
     5fc:	c95d                	beqz	a0,6b2 <main+0x5e0>
  int status = 0;
     5fe:	f6042823          	sw	zero,-144(s0)
  wait(&status);
     602:	f7040513          	addi	a0,s0,-144
     606:	544000ef          	jal	b4a <wait>
  result("child sees correct data after fork+swap", status == 0);
     60a:	f7042583          	lw	a1,-144(s0)
     60e:	0015b593          	seqz	a1,a1
     612:	00001517          	auipc	a0,0x1
     616:	e4650513          	addi	a0,a0,-442 # 1458 <malloc+0x3c8>
     61a:	a6dff0ef          	jal	86 <result>
  for(int i = 0; i < FORK_PAGES; i++)
     61e:	4481                	li	s1,0
    if(!check(base + i * PAGE_SIZE, i, 99)){ ok = 0; break; }
     620:	06300a93          	li	s5,99
  for(int i = 0; i < FORK_PAGES; i++)
     624:	6985                	lui	s3,0x1
     626:	03000913          	li	s2,48
    if(!check(base + i * PAGE_SIZE, i, 99)){ ok = 0; break; }
     62a:	8656                	mv	a2,s5
     62c:	85a6                	mv	a1,s1
     62e:	8552                	mv	a0,s4
     630:	a0fff0ef          	jal	3e <check>
     634:	85aa                	mv	a1,a0
     636:	c511                	beqz	a0,642 <main+0x570>
  for(int i = 0; i < FORK_PAGES; i++)
     638:	2485                	addiw	s1,s1,1
     63a:	9a4e                	add	s4,s4,s3
     63c:	ff2497e3          	bne	s1,s2,62a <main+0x558>
  int ok = 1;
     640:	4585                	li	a1,1
  result("parent data unaffected by child writes", ok);
     642:	00001517          	auipc	a0,0x1
     646:	e3e50513          	addi	a0,a0,-450 # 1480 <malloc+0x3f0>
     64a:	a3dff0ef          	jal	86 <result>
  sbrk(-(FORK_PAGES * PAGE_SIZE));
     64e:	fffd0537          	lui	a0,0xfffd0
     652:	4bc000ef          	jal	b0e <sbrk>
  printf("\n[T6] Swap-slot leak: many alloc/free cycles\n");
     656:	00001517          	auipc	a0,0x1
     65a:	e5250513          	addi	a0,a0,-430 # 14a8 <malloc+0x418>
     65e:	17b000ef          	jal	fd8 <printf>
  for(int r = 0; r < LEAK_ROUNDS; r++){
     662:	4481                	li	s1,0
    if(b == (char*)-1){ all_ok = 0; break; }
     664:	5c7d                	li	s8,-1
    for(int i = 0; i < LEAK_PAGES; i++)
     666:	6985                	lui	s3,0x1
     668:	03000b13          	li	s6,48
    char *p = sbrk(PRESSURE * PAGE_SIZE);
     66c:	00048bb7          	lui	s7,0x48
     670:	a875                	j	72c <main+0x65a>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     672:	00001517          	auipc	a0,0x1
     676:	b8e50513          	addi	a0,a0,-1138 # 1200 <malloc+0x170>
     67a:	15f000ef          	jal	fd8 <printf>
     67e:	00002717          	auipc	a4,0x2
     682:	98270713          	addi	a4,a4,-1662 # 2000 <total_fail>
     686:	431c                	lw	a5,0(a4)
     688:	2785                	addiw	a5,a5,1
     68a:	c31c                	sw	a5,0(a4)
     68c:	b7e9                	j	656 <main+0x584>
  if(pid < 0){ printf("  FAIL: fork\n"); total_fail++; sbrk(-(FORK_PAGES*PAGE_SIZE)); return; }
     68e:	00001517          	auipc	a0,0x1
     692:	dba50513          	addi	a0,a0,-582 # 1448 <malloc+0x3b8>
     696:	143000ef          	jal	fd8 <printf>
     69a:	00002717          	auipc	a4,0x2
     69e:	96670713          	addi	a4,a4,-1690 # 2000 <total_fail>
     6a2:	431c                	lw	a5,0(a4)
     6a4:	2785                	addiw	a5,a5,1
     6a6:	c31c                	sw	a5,0(a4)
     6a8:	fffd0537          	lui	a0,0xfffd0
     6ac:	462000ef          	jal	b0e <sbrk>
     6b0:	b75d                	j	656 <main+0x584>
     6b2:	4901                	li	s2,0
      if(!check(base + i * PAGE_SIZE, i, 99)){ ok = 0; break; }
     6b4:	06300a93          	li	s5,99
    for(int i = 0; i < FORK_PAGES; i++)
     6b8:	03000993          	li	s3,48
      if(!check(base + i * PAGE_SIZE, i, 99)){ ok = 0; break; }
     6bc:	00c91513          	slli	a0,s2,0xc
     6c0:	8656                	mv	a2,s5
     6c2:	0009059b          	sext.w	a1,s2
     6c6:	9552                	add	a0,a0,s4
     6c8:	977ff0ef          	jal	3e <check>
     6cc:	84aa                	mv	s1,a0
     6ce:	c509                	beqz	a0,6d8 <main+0x606>
    for(int i = 0; i < FORK_PAGES; i++)
     6d0:	0905                	addi	s2,s2,1
     6d2:	ff3915e3          	bne	s2,s3,6bc <main+0x5ea>
    int ok = 1;
     6d6:	4485                	li	s1,1
     6d8:	4901                	li	s2,0
      fill(base + i * PAGE_SIZE, i, 77);
     6da:	04d00a93          	li	s5,77
    for(int i = 0; i < FORK_PAGES; i++)
     6de:	03000993          	li	s3,48
      fill(base + i * PAGE_SIZE, i, 77);
     6e2:	00c91513          	slli	a0,s2,0xc
     6e6:	8656                	mv	a2,s5
     6e8:	0009059b          	sext.w	a1,s2
     6ec:	9552                	add	a0,a0,s4
     6ee:	913ff0ef          	jal	0 <fill>
    for(int i = 0; i < FORK_PAGES; i++)
     6f2:	0905                	addi	s2,s2,1
     6f4:	ff3917e3          	bne	s2,s3,6e2 <main+0x610>
    exit(ok ? 0 : 1);
     6f8:	0014c513          	xori	a0,s1,1
     6fc:	2501                	sext.w	a0,a0
     6fe:	444000ef          	jal	b42 <exit>
     702:	87aa                	mv	a5,a0
     704:	01750733          	add	a4,a0,s7
    if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=(char)r; sbrk(-(PRESSURE*PAGE_SIZE)); }
     708:	00978023          	sb	s1,0(a5)
     70c:	97ce                	add	a5,a5,s3
     70e:	fee79de3          	bne	a5,a4,708 <main+0x636>
     712:	fffb8537          	lui	a0,0xfffb8
     716:	3f8000ef          	jal	b0e <sbrk>
     71a:	a081                	j	75a <main+0x688>
    sbrk(-(LEAK_PAGES * PAGE_SIZE));
     71c:	fffd0537          	lui	a0,0xfffd0
     720:	3ee000ef          	jal	b0e <sbrk>
  for(int r = 0; r < LEAK_ROUNDS; r++){
     724:	2485                	addiw	s1,s1,1
     726:	4795                	li	a5,5
     728:	04f48763          	beq	s1,a5,776 <main+0x6a4>
    char *b = sbrk(LEAK_PAGES * PAGE_SIZE);
     72c:	00030537          	lui	a0,0x30
     730:	3de000ef          	jal	b0e <sbrk>
     734:	8a2a                	mv	s4,a0
    if(b == (char*)-1){ all_ok = 0; break; }
     736:	13850663          	beq	a0,s8,862 <main+0x790>
     73a:	8aaa                	mv	s5,a0
    for(int i = 0; i < LEAK_PAGES; i++)
     73c:	4901                	li	s2,0
      fill(b + i * PAGE_SIZE, i, r);
     73e:	8626                	mv	a2,s1
     740:	85ca                	mv	a1,s2
     742:	8552                	mv	a0,s4
     744:	8bdff0ef          	jal	0 <fill>
    for(int i = 0; i < LEAK_PAGES; i++)
     748:	2905                	addiw	s2,s2,1
     74a:	9a4e                	add	s4,s4,s3
     74c:	ff6919e3          	bne	s2,s6,73e <main+0x66c>
    char *p = sbrk(PRESSURE * PAGE_SIZE);
     750:	855e                	mv	a0,s7
     752:	3bc000ef          	jal	b0e <sbrk>
    if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=(char)r; sbrk(-(PRESSURE*PAGE_SIZE)); }
     756:	fb8516e3          	bne	a0,s8,702 <main+0x630>
    for(int i = 0; i < LEAK_PAGES; i++)
     75a:	4a01                	li	s4,0
      if(!check(b + i * PAGE_SIZE, i, r)){ all_ok = 0; break; }
     75c:	8626                	mv	a2,s1
     75e:	85d2                	mv	a1,s4
     760:	8556                	mv	a0,s5
     762:	8ddff0ef          	jal	3e <check>
     766:	892a                	mv	s2,a0
     768:	10050d63          	beqz	a0,882 <main+0x7b0>
    for(int i = 0; i < LEAK_PAGES; i++)
     76c:	2a05                	addiw	s4,s4,1 # 1001 <printf+0x29>
     76e:	9ace                	add	s5,s5,s3
     770:	ff6a16e3          	bne	s4,s6,75c <main+0x68a>
     774:	b765                	j	71c <main+0x64a>
     776:	4905                	li	s2,1
  result("no slot leak across 5 alloc/free cycles", all_ok);
     778:	85ca                	mv	a1,s2
     77a:	00001517          	auipc	a0,0x1
     77e:	d5e50513          	addi	a0,a0,-674 # 14d8 <malloc+0x448>
     782:	905ff0ef          	jal	86 <result>
  printf("\n[T7] Single-page precision (first byte, last byte, middle)\n");
     786:	00001517          	auipc	a0,0x1
     78a:	d7a50513          	addi	a0,a0,-646 # 1500 <malloc+0x470>
     78e:	04b000ef          	jal	fd8 <printf>
  char *b = sbrk(PAGE_SIZE);
     792:	6505                	lui	a0,0x1
     794:	37a000ef          	jal	b0e <sbrk>
     798:	84aa                	mv	s1,a0
  if(b == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     79a:	57fd                	li	a5,-1
     79c:	0cf50563          	beq	a0,a5,866 <main+0x794>
  b[0]            = 0xDE;
     7a0:	fde00793          	li	a5,-34
     7a4:	00f50023          	sb	a5,0(a0) # 1000 <printf+0x28>
  b[PAGE_SIZE/2]  = 0xAD;
     7a8:	6785                	lui	a5,0x1
     7aa:	97aa                	add	a5,a5,a0
     7ac:	fad00713          	li	a4,-83
     7b0:	80e78023          	sb	a4,-2048(a5) # 800 <main+0x72e>
  b[PAGE_SIZE-1]  = 0xBE;
     7b4:	fbe00713          	li	a4,-66
     7b8:	fee78fa3          	sb	a4,-1(a5)
  char *p = sbrk(PRESSURE * PAGE_SIZE);
     7bc:	00048537          	lui	a0,0x48
     7c0:	34e000ef          	jal	b0e <sbrk>
  if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     7c4:	57fd                	li	a5,-1
     7c6:	02f50163          	beq	a0,a5,7e8 <main+0x716>
     7ca:	87aa                	mv	a5,a0
     7cc:	000486b7          	lui	a3,0x48
     7d0:	00d50733          	add	a4,a0,a3
     7d4:	6685                	lui	a3,0x1
     7d6:	00078023          	sb	zero,0(a5)
     7da:	97b6                	add	a5,a5,a3
     7dc:	fef71de3          	bne	a4,a5,7d6 <main+0x704>
     7e0:	fffb8537          	lui	a0,0xfffb8
     7e4:	32a000ef          	jal	b0e <sbrk>
  result("first byte correct after swap-in",  (unsigned char)b[0]           == 0xDE);
     7e8:	0004c583          	lbu	a1,0(s1)
     7ec:	f2258593          	addi	a1,a1,-222
     7f0:	0015b593          	seqz	a1,a1
     7f4:	00001517          	auipc	a0,0x1
     7f8:	d4c50513          	addi	a0,a0,-692 # 1540 <malloc+0x4b0>
     7fc:	88bff0ef          	jal	86 <result>
  result("middle byte correct after swap-in", (unsigned char)b[PAGE_SIZE/2] == 0xAD);
     800:	6785                	lui	a5,0x1
     802:	94be                	add	s1,s1,a5
     804:	8004c583          	lbu	a1,-2048(s1)
     808:	f5358593          	addi	a1,a1,-173
     80c:	0015b593          	seqz	a1,a1
     810:	00001517          	auipc	a0,0x1
     814:	d5850513          	addi	a0,a0,-680 # 1568 <malloc+0x4d8>
     818:	86fff0ef          	jal	86 <result>
  result("last byte correct after swap-in",   (unsigned char)b[PAGE_SIZE-1] == 0xBE);
     81c:	fff4c583          	lbu	a1,-1(s1)
     820:	f4258593          	addi	a1,a1,-190
     824:	0015b593          	seqz	a1,a1
     828:	00001517          	auipc	a0,0x1
     82c:	d6850513          	addi	a0,a0,-664 # 1590 <malloc+0x500>
     830:	857ff0ef          	jal	86 <result>
  sbrk(-PAGE_SIZE);
     834:	757d                	lui	a0,0xfffff
     836:	2d8000ef          	jal	b0e <sbrk>
  t4_stats_monotonic();
  t5_fork();
  t6_slot_leak();
  t7_single_page();

  printf("\n=== RESULTS: %d passed, %d failed ===\n", total_pass, total_fail);
     83a:	00001497          	auipc	s1,0x1
     83e:	7c648493          	addi	s1,s1,1990 # 2000 <total_fail>
     842:	4090                	lw	a2,0(s1)
     844:	00001597          	auipc	a1,0x1
     848:	7c05a583          	lw	a1,1984(a1) # 2004 <total_pass>
     84c:	00001517          	auipc	a0,0x1
     850:	d6450513          	addi	a0,a0,-668 # 15b0 <malloc+0x520>
     854:	784000ef          	jal	fd8 <printf>
  exit(total_fail == 0 ? 0 : 1);
     858:	4088                	lw	a0,0(s1)
     85a:	00a03533          	snez	a0,a0
     85e:	2e4000ef          	jal	b42 <exit>
    if(b == (char*)-1){ all_ok = 0; break; }
     862:	4901                	li	s2,0
     864:	bf11                	j	778 <main+0x6a6>
  if(b == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     866:	00001517          	auipc	a0,0x1
     86a:	99a50513          	addi	a0,a0,-1638 # 1200 <malloc+0x170>
     86e:	76a000ef          	jal	fd8 <printf>
     872:	00001717          	auipc	a4,0x1
     876:	78e70713          	addi	a4,a4,1934 # 2000 <total_fail>
     87a:	431c                	lw	a5,0(a4)
     87c:	2785                	addiw	a5,a5,1 # 1001 <printf+0x29>
     87e:	c31c                	sw	a5,0(a4)
     880:	bf6d                	j	83a <main+0x768>
    sbrk(-(LEAK_PAGES * PAGE_SIZE));
     882:	fffd0537          	lui	a0,0xfffd0
     886:	288000ef          	jal	b0e <sbrk>
    if(!all_ok) break;
     88a:	b5fd                	j	778 <main+0x6a6>

000000000000088c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     88c:	1141                	addi	sp,sp,-16
     88e:	e406                	sd	ra,8(sp)
     890:	e022                	sd	s0,0(sp)
     892:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     894:	83fff0ef          	jal	d2 <main>
  exit(r);
     898:	2aa000ef          	jal	b42 <exit>

000000000000089c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     89c:	1141                	addi	sp,sp,-16
     89e:	e406                	sd	ra,8(sp)
     8a0:	e022                	sd	s0,0(sp)
     8a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8a4:	87aa                	mv	a5,a0
     8a6:	0585                	addi	a1,a1,1
     8a8:	0785                	addi	a5,a5,1
     8aa:	fff5c703          	lbu	a4,-1(a1)
     8ae:	fee78fa3          	sb	a4,-1(a5)
     8b2:	fb75                	bnez	a4,8a6 <strcpy+0xa>
    ;
  return os;
}
     8b4:	60a2                	ld	ra,8(sp)
     8b6:	6402                	ld	s0,0(sp)
     8b8:	0141                	addi	sp,sp,16
     8ba:	8082                	ret

00000000000008bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
     8bc:	1141                	addi	sp,sp,-16
     8be:	e406                	sd	ra,8(sp)
     8c0:	e022                	sd	s0,0(sp)
     8c2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     8c4:	00054783          	lbu	a5,0(a0) # fffffffffffd0000 <base+0xfffffffffffcdff0>
     8c8:	cb91                	beqz	a5,8dc <strcmp+0x20>
     8ca:	0005c703          	lbu	a4,0(a1)
     8ce:	00f71763          	bne	a4,a5,8dc <strcmp+0x20>
    p++, q++;
     8d2:	0505                	addi	a0,a0,1
     8d4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     8d6:	00054783          	lbu	a5,0(a0)
     8da:	fbe5                	bnez	a5,8ca <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     8dc:	0005c503          	lbu	a0,0(a1)
}
     8e0:	40a7853b          	subw	a0,a5,a0
     8e4:	60a2                	ld	ra,8(sp)
     8e6:	6402                	ld	s0,0(sp)
     8e8:	0141                	addi	sp,sp,16
     8ea:	8082                	ret

00000000000008ec <strlen>:

uint
strlen(const char *s)
{
     8ec:	1141                	addi	sp,sp,-16
     8ee:	e406                	sd	ra,8(sp)
     8f0:	e022                	sd	s0,0(sp)
     8f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     8f4:	00054783          	lbu	a5,0(a0)
     8f8:	cf91                	beqz	a5,914 <strlen+0x28>
     8fa:	00150793          	addi	a5,a0,1
     8fe:	86be                	mv	a3,a5
     900:	0785                	addi	a5,a5,1
     902:	fff7c703          	lbu	a4,-1(a5)
     906:	ff65                	bnez	a4,8fe <strlen+0x12>
     908:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     90c:	60a2                	ld	ra,8(sp)
     90e:	6402                	ld	s0,0(sp)
     910:	0141                	addi	sp,sp,16
     912:	8082                	ret
  for(n = 0; s[n]; n++)
     914:	4501                	li	a0,0
     916:	bfdd                	j	90c <strlen+0x20>

0000000000000918 <memset>:

void*
memset(void *dst, int c, uint n)
{
     918:	1141                	addi	sp,sp,-16
     91a:	e406                	sd	ra,8(sp)
     91c:	e022                	sd	s0,0(sp)
     91e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     920:	ca19                	beqz	a2,936 <memset+0x1e>
     922:	87aa                	mv	a5,a0
     924:	1602                	slli	a2,a2,0x20
     926:	9201                	srli	a2,a2,0x20
     928:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     92c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     930:	0785                	addi	a5,a5,1
     932:	fee79de3          	bne	a5,a4,92c <memset+0x14>
  }
  return dst;
}
     936:	60a2                	ld	ra,8(sp)
     938:	6402                	ld	s0,0(sp)
     93a:	0141                	addi	sp,sp,16
     93c:	8082                	ret

000000000000093e <strchr>:

char*
strchr(const char *s, char c)
{
     93e:	1141                	addi	sp,sp,-16
     940:	e406                	sd	ra,8(sp)
     942:	e022                	sd	s0,0(sp)
     944:	0800                	addi	s0,sp,16
  for(; *s; s++)
     946:	00054783          	lbu	a5,0(a0)
     94a:	cf81                	beqz	a5,962 <strchr+0x24>
    if(*s == c)
     94c:	00f58763          	beq	a1,a5,95a <strchr+0x1c>
  for(; *s; s++)
     950:	0505                	addi	a0,a0,1
     952:	00054783          	lbu	a5,0(a0)
     956:	fbfd                	bnez	a5,94c <strchr+0xe>
      return (char*)s;
  return 0;
     958:	4501                	li	a0,0
}
     95a:	60a2                	ld	ra,8(sp)
     95c:	6402                	ld	s0,0(sp)
     95e:	0141                	addi	sp,sp,16
     960:	8082                	ret
  return 0;
     962:	4501                	li	a0,0
     964:	bfdd                	j	95a <strchr+0x1c>

0000000000000966 <gets>:

char*
gets(char *buf, int max)
{
     966:	711d                	addi	sp,sp,-96
     968:	ec86                	sd	ra,88(sp)
     96a:	e8a2                	sd	s0,80(sp)
     96c:	e4a6                	sd	s1,72(sp)
     96e:	e0ca                	sd	s2,64(sp)
     970:	fc4e                	sd	s3,56(sp)
     972:	f852                	sd	s4,48(sp)
     974:	f456                	sd	s5,40(sp)
     976:	f05a                	sd	s6,32(sp)
     978:	ec5e                	sd	s7,24(sp)
     97a:	e862                	sd	s8,16(sp)
     97c:	1080                	addi	s0,sp,96
     97e:	8baa                	mv	s7,a0
     980:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     982:	892a                	mv	s2,a0
     984:	4481                	li	s1,0
    cc = read(0, &c, 1);
     986:	faf40b13          	addi	s6,s0,-81
     98a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     98c:	8c26                	mv	s8,s1
     98e:	0014899b          	addiw	s3,s1,1
     992:	84ce                	mv	s1,s3
     994:	0349d463          	bge	s3,s4,9bc <gets+0x56>
    cc = read(0, &c, 1);
     998:	8656                	mv	a2,s5
     99a:	85da                	mv	a1,s6
     99c:	4501                	li	a0,0
     99e:	1bc000ef          	jal	b5a <read>
    if(cc < 1)
     9a2:	00a05d63          	blez	a0,9bc <gets+0x56>
      break;
    buf[i++] = c;
     9a6:	faf44783          	lbu	a5,-81(s0)
     9aa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9ae:	0905                	addi	s2,s2,1
     9b0:	ff678713          	addi	a4,a5,-10
     9b4:	c319                	beqz	a4,9ba <gets+0x54>
     9b6:	17cd                	addi	a5,a5,-13
     9b8:	fbf1                	bnez	a5,98c <gets+0x26>
    buf[i++] = c;
     9ba:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     9bc:	9c5e                	add	s8,s8,s7
     9be:	000c0023          	sb	zero,0(s8)
  return buf;
}
     9c2:	855e                	mv	a0,s7
     9c4:	60e6                	ld	ra,88(sp)
     9c6:	6446                	ld	s0,80(sp)
     9c8:	64a6                	ld	s1,72(sp)
     9ca:	6906                	ld	s2,64(sp)
     9cc:	79e2                	ld	s3,56(sp)
     9ce:	7a42                	ld	s4,48(sp)
     9d0:	7aa2                	ld	s5,40(sp)
     9d2:	7b02                	ld	s6,32(sp)
     9d4:	6be2                	ld	s7,24(sp)
     9d6:	6c42                	ld	s8,16(sp)
     9d8:	6125                	addi	sp,sp,96
     9da:	8082                	ret

00000000000009dc <stat>:

int
stat(const char *n, struct stat *st)
{
     9dc:	1101                	addi	sp,sp,-32
     9de:	ec06                	sd	ra,24(sp)
     9e0:	e822                	sd	s0,16(sp)
     9e2:	e04a                	sd	s2,0(sp)
     9e4:	1000                	addi	s0,sp,32
     9e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     9e8:	4581                	li	a1,0
     9ea:	198000ef          	jal	b82 <open>
  if(fd < 0)
     9ee:	02054263          	bltz	a0,a12 <stat+0x36>
     9f2:	e426                	sd	s1,8(sp)
     9f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     9f6:	85ca                	mv	a1,s2
     9f8:	1a2000ef          	jal	b9a <fstat>
     9fc:	892a                	mv	s2,a0
  close(fd);
     9fe:	8526                	mv	a0,s1
     a00:	16a000ef          	jal	b6a <close>
  return r;
     a04:	64a2                	ld	s1,8(sp)
}
     a06:	854a                	mv	a0,s2
     a08:	60e2                	ld	ra,24(sp)
     a0a:	6442                	ld	s0,16(sp)
     a0c:	6902                	ld	s2,0(sp)
     a0e:	6105                	addi	sp,sp,32
     a10:	8082                	ret
    return -1;
     a12:	57fd                	li	a5,-1
     a14:	893e                	mv	s2,a5
     a16:	bfc5                	j	a06 <stat+0x2a>

0000000000000a18 <atoi>:

int
atoi(const char *s)
{
     a18:	1141                	addi	sp,sp,-16
     a1a:	e406                	sd	ra,8(sp)
     a1c:	e022                	sd	s0,0(sp)
     a1e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a20:	00054683          	lbu	a3,0(a0)
     a24:	fd06879b          	addiw	a5,a3,-48 # fd0 <fprintf+0x22>
     a28:	0ff7f793          	zext.b	a5,a5
     a2c:	4625                	li	a2,9
     a2e:	02f66963          	bltu	a2,a5,a60 <atoi+0x48>
     a32:	872a                	mv	a4,a0
  n = 0;
     a34:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a36:	0705                	addi	a4,a4,1
     a38:	0025179b          	slliw	a5,a0,0x2
     a3c:	9fa9                	addw	a5,a5,a0
     a3e:	0017979b          	slliw	a5,a5,0x1
     a42:	9fb5                	addw	a5,a5,a3
     a44:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a48:	00074683          	lbu	a3,0(a4)
     a4c:	fd06879b          	addiw	a5,a3,-48
     a50:	0ff7f793          	zext.b	a5,a5
     a54:	fef671e3          	bgeu	a2,a5,a36 <atoi+0x1e>
  return n;
}
     a58:	60a2                	ld	ra,8(sp)
     a5a:	6402                	ld	s0,0(sp)
     a5c:	0141                	addi	sp,sp,16
     a5e:	8082                	ret
  n = 0;
     a60:	4501                	li	a0,0
     a62:	bfdd                	j	a58 <atoi+0x40>

0000000000000a64 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a64:	1141                	addi	sp,sp,-16
     a66:	e406                	sd	ra,8(sp)
     a68:	e022                	sd	s0,0(sp)
     a6a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     a6c:	02b57563          	bgeu	a0,a1,a96 <memmove+0x32>
    while(n-- > 0)
     a70:	00c05f63          	blez	a2,a8e <memmove+0x2a>
     a74:	1602                	slli	a2,a2,0x20
     a76:	9201                	srli	a2,a2,0x20
     a78:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     a7c:	872a                	mv	a4,a0
      *dst++ = *src++;
     a7e:	0585                	addi	a1,a1,1
     a80:	0705                	addi	a4,a4,1
     a82:	fff5c683          	lbu	a3,-1(a1)
     a86:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     a8a:	fee79ae3          	bne	a5,a4,a7e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     a8e:	60a2                	ld	ra,8(sp)
     a90:	6402                	ld	s0,0(sp)
     a92:	0141                	addi	sp,sp,16
     a94:	8082                	ret
    while(n-- > 0)
     a96:	fec05ce3          	blez	a2,a8e <memmove+0x2a>
    dst += n;
     a9a:	00c50733          	add	a4,a0,a2
    src += n;
     a9e:	95b2                	add	a1,a1,a2
     aa0:	fff6079b          	addiw	a5,a2,-1 # fff <printf+0x27>
     aa4:	1782                	slli	a5,a5,0x20
     aa6:	9381                	srli	a5,a5,0x20
     aa8:	fff7c793          	not	a5,a5
     aac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     aae:	15fd                	addi	a1,a1,-1
     ab0:	177d                	addi	a4,a4,-1
     ab2:	0005c683          	lbu	a3,0(a1)
     ab6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     aba:	fef71ae3          	bne	a4,a5,aae <memmove+0x4a>
     abe:	bfc1                	j	a8e <memmove+0x2a>

0000000000000ac0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     ac0:	1141                	addi	sp,sp,-16
     ac2:	e406                	sd	ra,8(sp)
     ac4:	e022                	sd	s0,0(sp)
     ac6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     ac8:	c61d                	beqz	a2,af6 <memcmp+0x36>
     aca:	1602                	slli	a2,a2,0x20
     acc:	9201                	srli	a2,a2,0x20
     ace:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     ad2:	00054783          	lbu	a5,0(a0)
     ad6:	0005c703          	lbu	a4,0(a1)
     ada:	00e79863          	bne	a5,a4,aea <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     ade:	0505                	addi	a0,a0,1
    p2++;
     ae0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ae2:	fed518e3          	bne	a0,a3,ad2 <memcmp+0x12>
  }
  return 0;
     ae6:	4501                	li	a0,0
     ae8:	a019                	j	aee <memcmp+0x2e>
      return *p1 - *p2;
     aea:	40e7853b          	subw	a0,a5,a4
}
     aee:	60a2                	ld	ra,8(sp)
     af0:	6402                	ld	s0,0(sp)
     af2:	0141                	addi	sp,sp,16
     af4:	8082                	ret
  return 0;
     af6:	4501                	li	a0,0
     af8:	bfdd                	j	aee <memcmp+0x2e>

0000000000000afa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     afa:	1141                	addi	sp,sp,-16
     afc:	e406                	sd	ra,8(sp)
     afe:	e022                	sd	s0,0(sp)
     b00:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b02:	f63ff0ef          	jal	a64 <memmove>
}
     b06:	60a2                	ld	ra,8(sp)
     b08:	6402                	ld	s0,0(sp)
     b0a:	0141                	addi	sp,sp,16
     b0c:	8082                	ret

0000000000000b0e <sbrk>:

char *
sbrk(int n) {
     b0e:	1141                	addi	sp,sp,-16
     b10:	e406                	sd	ra,8(sp)
     b12:	e022                	sd	s0,0(sp)
     b14:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     b16:	4585                	li	a1,1
     b18:	0b2000ef          	jal	bca <sys_sbrk>
}
     b1c:	60a2                	ld	ra,8(sp)
     b1e:	6402                	ld	s0,0(sp)
     b20:	0141                	addi	sp,sp,16
     b22:	8082                	ret

0000000000000b24 <sbrklazy>:

char *
sbrklazy(int n) {
     b24:	1141                	addi	sp,sp,-16
     b26:	e406                	sd	ra,8(sp)
     b28:	e022                	sd	s0,0(sp)
     b2a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     b2c:	4589                	li	a1,2
     b2e:	09c000ef          	jal	bca <sys_sbrk>
}
     b32:	60a2                	ld	ra,8(sp)
     b34:	6402                	ld	s0,0(sp)
     b36:	0141                	addi	sp,sp,16
     b38:	8082                	ret

0000000000000b3a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b3a:	4885                	li	a7,1
 ecall
     b3c:	00000073          	ecall
 ret
     b40:	8082                	ret

0000000000000b42 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b42:	4889                	li	a7,2
 ecall
     b44:	00000073          	ecall
 ret
     b48:	8082                	ret

0000000000000b4a <wait>:
.global wait
wait:
 li a7, SYS_wait
     b4a:	488d                	li	a7,3
 ecall
     b4c:	00000073          	ecall
 ret
     b50:	8082                	ret

0000000000000b52 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b52:	4891                	li	a7,4
 ecall
     b54:	00000073          	ecall
 ret
     b58:	8082                	ret

0000000000000b5a <read>:
.global read
read:
 li a7, SYS_read
     b5a:	4895                	li	a7,5
 ecall
     b5c:	00000073          	ecall
 ret
     b60:	8082                	ret

0000000000000b62 <write>:
.global write
write:
 li a7, SYS_write
     b62:	48c1                	li	a7,16
 ecall
     b64:	00000073          	ecall
 ret
     b68:	8082                	ret

0000000000000b6a <close>:
.global close
close:
 li a7, SYS_close
     b6a:	48d5                	li	a7,21
 ecall
     b6c:	00000073          	ecall
 ret
     b70:	8082                	ret

0000000000000b72 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b72:	4899                	li	a7,6
 ecall
     b74:	00000073          	ecall
 ret
     b78:	8082                	ret

0000000000000b7a <exec>:
.global exec
exec:
 li a7, SYS_exec
     b7a:	489d                	li	a7,7
 ecall
     b7c:	00000073          	ecall
 ret
     b80:	8082                	ret

0000000000000b82 <open>:
.global open
open:
 li a7, SYS_open
     b82:	48bd                	li	a7,15
 ecall
     b84:	00000073          	ecall
 ret
     b88:	8082                	ret

0000000000000b8a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b8a:	48c5                	li	a7,17
 ecall
     b8c:	00000073          	ecall
 ret
     b90:	8082                	ret

0000000000000b92 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b92:	48c9                	li	a7,18
 ecall
     b94:	00000073          	ecall
 ret
     b98:	8082                	ret

0000000000000b9a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b9a:	48a1                	li	a7,8
 ecall
     b9c:	00000073          	ecall
 ret
     ba0:	8082                	ret

0000000000000ba2 <link>:
.global link
link:
 li a7, SYS_link
     ba2:	48cd                	li	a7,19
 ecall
     ba4:	00000073          	ecall
 ret
     ba8:	8082                	ret

0000000000000baa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     baa:	48d1                	li	a7,20
 ecall
     bac:	00000073          	ecall
 ret
     bb0:	8082                	ret

0000000000000bb2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     bb2:	48a5                	li	a7,9
 ecall
     bb4:	00000073          	ecall
 ret
     bb8:	8082                	ret

0000000000000bba <dup>:
.global dup
dup:
 li a7, SYS_dup
     bba:	48a9                	li	a7,10
 ecall
     bbc:	00000073          	ecall
 ret
     bc0:	8082                	ret

0000000000000bc2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bc2:	48ad                	li	a7,11
 ecall
     bc4:	00000073          	ecall
 ret
     bc8:	8082                	ret

0000000000000bca <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     bca:	48b1                	li	a7,12
 ecall
     bcc:	00000073          	ecall
 ret
     bd0:	8082                	ret

0000000000000bd2 <pause>:
.global pause
pause:
 li a7, SYS_pause
     bd2:	48b5                	li	a7,13
 ecall
     bd4:	00000073          	ecall
 ret
     bd8:	8082                	ret

0000000000000bda <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     bda:	48b9                	li	a7,14
 ecall
     bdc:	00000073          	ecall
 ret
     be0:	8082                	ret

0000000000000be2 <hello>:
.global hello
hello:
 li a7, SYS_hello
     be2:	48d9                	li	a7,22
 ecall
     be4:	00000073          	ecall
 ret
     be8:	8082                	ret

0000000000000bea <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
     bea:	48dd                	li	a7,23
 ecall
     bec:	00000073          	ecall
 ret
     bf0:	8082                	ret

0000000000000bf2 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
     bf2:	48e1                	li	a7,24
 ecall
     bf4:	00000073          	ecall
 ret
     bf8:	8082                	ret

0000000000000bfa <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
     bfa:	48e5                	li	a7,25
 ecall
     bfc:	00000073          	ecall
 ret
     c00:	8082                	ret

0000000000000c02 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
     c02:	48e9                	li	a7,26
 ecall
     c04:	00000073          	ecall
 ret
     c08:	8082                	ret

0000000000000c0a <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
     c0a:	48ed                	li	a7,27
 ecall
     c0c:	00000073          	ecall
 ret
     c10:	8082                	ret

0000000000000c12 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
     c12:	48f1                	li	a7,28
 ecall
     c14:	00000073          	ecall
 ret
     c18:	8082                	ret

0000000000000c1a <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
     c1a:	48f5                	li	a7,29
 ecall
     c1c:	00000073          	ecall
 ret
     c20:	8082                	ret

0000000000000c22 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
     c22:	48f9                	li	a7,30
 ecall
     c24:	00000073          	ecall
 ret
     c28:	8082                	ret

0000000000000c2a <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
     c2a:	48fd                	li	a7,31
 ecall
     c2c:	00000073          	ecall
 ret
     c30:	8082                	ret

0000000000000c32 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c32:	1101                	addi	sp,sp,-32
     c34:	ec06                	sd	ra,24(sp)
     c36:	e822                	sd	s0,16(sp)
     c38:	1000                	addi	s0,sp,32
     c3a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c3e:	4605                	li	a2,1
     c40:	fef40593          	addi	a1,s0,-17
     c44:	f1fff0ef          	jal	b62 <write>
}
     c48:	60e2                	ld	ra,24(sp)
     c4a:	6442                	ld	s0,16(sp)
     c4c:	6105                	addi	sp,sp,32
     c4e:	8082                	ret

0000000000000c50 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     c50:	715d                	addi	sp,sp,-80
     c52:	e486                	sd	ra,72(sp)
     c54:	e0a2                	sd	s0,64(sp)
     c56:	f84a                	sd	s2,48(sp)
     c58:	f44e                	sd	s3,40(sp)
     c5a:	0880                	addi	s0,sp,80
     c5c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     c5e:	c6d1                	beqz	a3,cea <printint+0x9a>
     c60:	0805d563          	bgez	a1,cea <printint+0x9a>
    neg = 1;
    x = -xx;
     c64:	40b005b3          	neg	a1,a1
    neg = 1;
     c68:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     c6a:	fb840993          	addi	s3,s0,-72
  neg = 0;
     c6e:	86ce                	mv	a3,s3
  i = 0;
     c70:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c72:	00001817          	auipc	a6,0x1
     c76:	96e80813          	addi	a6,a6,-1682 # 15e0 <digits>
     c7a:	88ba                	mv	a7,a4
     c7c:	0017051b          	addiw	a0,a4,1
     c80:	872a                	mv	a4,a0
     c82:	02c5f7b3          	remu	a5,a1,a2
     c86:	97c2                	add	a5,a5,a6
     c88:	0007c783          	lbu	a5,0(a5)
     c8c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c90:	87ae                	mv	a5,a1
     c92:	02c5d5b3          	divu	a1,a1,a2
     c96:	0685                	addi	a3,a3,1
     c98:	fec7f1e3          	bgeu	a5,a2,c7a <printint+0x2a>
  if(neg)
     c9c:	00030c63          	beqz	t1,cb4 <printint+0x64>
    buf[i++] = '-';
     ca0:	fd050793          	addi	a5,a0,-48
     ca4:	00878533          	add	a0,a5,s0
     ca8:	02d00793          	li	a5,45
     cac:	fef50423          	sb	a5,-24(a0)
     cb0:	0028871b          	addiw	a4,a7,2 # 1002 <printf+0x2a>

  while(--i >= 0)
     cb4:	02e05563          	blez	a4,cde <printint+0x8e>
     cb8:	fc26                	sd	s1,56(sp)
     cba:	377d                	addiw	a4,a4,-1
     cbc:	00e984b3          	add	s1,s3,a4
     cc0:	19fd                	addi	s3,s3,-1 # fff <printf+0x27>
     cc2:	99ba                	add	s3,s3,a4
     cc4:	1702                	slli	a4,a4,0x20
     cc6:	9301                	srli	a4,a4,0x20
     cc8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     ccc:	0004c583          	lbu	a1,0(s1)
     cd0:	854a                	mv	a0,s2
     cd2:	f61ff0ef          	jal	c32 <putc>
  while(--i >= 0)
     cd6:	14fd                	addi	s1,s1,-1
     cd8:	ff349ae3          	bne	s1,s3,ccc <printint+0x7c>
     cdc:	74e2                	ld	s1,56(sp)
}
     cde:	60a6                	ld	ra,72(sp)
     ce0:	6406                	ld	s0,64(sp)
     ce2:	7942                	ld	s2,48(sp)
     ce4:	79a2                	ld	s3,40(sp)
     ce6:	6161                	addi	sp,sp,80
     ce8:	8082                	ret
  neg = 0;
     cea:	4301                	li	t1,0
     cec:	bfbd                	j	c6a <printint+0x1a>

0000000000000cee <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cee:	711d                	addi	sp,sp,-96
     cf0:	ec86                	sd	ra,88(sp)
     cf2:	e8a2                	sd	s0,80(sp)
     cf4:	e4a6                	sd	s1,72(sp)
     cf6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cf8:	0005c483          	lbu	s1,0(a1)
     cfc:	22048363          	beqz	s1,f22 <vprintf+0x234>
     d00:	e0ca                	sd	s2,64(sp)
     d02:	fc4e                	sd	s3,56(sp)
     d04:	f852                	sd	s4,48(sp)
     d06:	f456                	sd	s5,40(sp)
     d08:	f05a                	sd	s6,32(sp)
     d0a:	ec5e                	sd	s7,24(sp)
     d0c:	e862                	sd	s8,16(sp)
     d0e:	8b2a                	mv	s6,a0
     d10:	8a2e                	mv	s4,a1
     d12:	8bb2                	mv	s7,a2
  state = 0;
     d14:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d16:	4901                	li	s2,0
     d18:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d1a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d1e:	06400c13          	li	s8,100
     d22:	a00d                	j	d44 <vprintf+0x56>
        putc(fd, c0);
     d24:	85a6                	mv	a1,s1
     d26:	855a                	mv	a0,s6
     d28:	f0bff0ef          	jal	c32 <putc>
     d2c:	a019                	j	d32 <vprintf+0x44>
    } else if(state == '%'){
     d2e:	03598363          	beq	s3,s5,d54 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     d32:	0019079b          	addiw	a5,s2,1
     d36:	893e                	mv	s2,a5
     d38:	873e                	mv	a4,a5
     d3a:	97d2                	add	a5,a5,s4
     d3c:	0007c483          	lbu	s1,0(a5)
     d40:	1c048a63          	beqz	s1,f14 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
     d44:	0004879b          	sext.w	a5,s1
    if(state == 0){
     d48:	fe0993e3          	bnez	s3,d2e <vprintf+0x40>
      if(c0 == '%'){
     d4c:	fd579ce3          	bne	a5,s5,d24 <vprintf+0x36>
        state = '%';
     d50:	89be                	mv	s3,a5
     d52:	b7c5                	j	d32 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     d54:	00ea06b3          	add	a3,s4,a4
     d58:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     d5c:	1c060863          	beqz	a2,f2c <vprintf+0x23e>
      if(c0 == 'd'){
     d60:	03878763          	beq	a5,s8,d8e <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d64:	f9478693          	addi	a3,a5,-108
     d68:	0016b693          	seqz	a3,a3
     d6c:	f9c60593          	addi	a1,a2,-100
     d70:	e99d                	bnez	a1,da6 <vprintf+0xb8>
     d72:	ca95                	beqz	a3,da6 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     d74:	008b8493          	addi	s1,s7,8 # 48008 <base+0x45ff8>
     d78:	4685                	li	a3,1
     d7a:	4629                	li	a2,10
     d7c:	000bb583          	ld	a1,0(s7)
     d80:	855a                	mv	a0,s6
     d82:	ecfff0ef          	jal	c50 <printint>
        i += 1;
     d86:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     d88:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     d8a:	4981                	li	s3,0
     d8c:	b75d                	j	d32 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     d8e:	008b8493          	addi	s1,s7,8
     d92:	4685                	li	a3,1
     d94:	4629                	li	a2,10
     d96:	000ba583          	lw	a1,0(s7)
     d9a:	855a                	mv	a0,s6
     d9c:	eb5ff0ef          	jal	c50 <printint>
     da0:	8ba6                	mv	s7,s1
      state = 0;
     da2:	4981                	li	s3,0
     da4:	b779                	j	d32 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     da6:	9752                	add	a4,a4,s4
     da8:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     dac:	f9460713          	addi	a4,a2,-108
     db0:	00173713          	seqz	a4,a4
     db4:	8f75                	and	a4,a4,a3
     db6:	f9c58513          	addi	a0,a1,-100
     dba:	18051363          	bnez	a0,f40 <vprintf+0x252>
     dbe:	18070163          	beqz	a4,f40 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
     dc2:	008b8493          	addi	s1,s7,8
     dc6:	4685                	li	a3,1
     dc8:	4629                	li	a2,10
     dca:	000bb583          	ld	a1,0(s7)
     dce:	855a                	mv	a0,s6
     dd0:	e81ff0ef          	jal	c50 <printint>
        i += 2;
     dd4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     dd6:	8ba6                	mv	s7,s1
      state = 0;
     dd8:	4981                	li	s3,0
        i += 2;
     dda:	bfa1                	j	d32 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     ddc:	008b8493          	addi	s1,s7,8
     de0:	4681                	li	a3,0
     de2:	4629                	li	a2,10
     de4:	000be583          	lwu	a1,0(s7)
     de8:	855a                	mv	a0,s6
     dea:	e67ff0ef          	jal	c50 <printint>
     dee:	8ba6                	mv	s7,s1
      state = 0;
     df0:	4981                	li	s3,0
     df2:	b781                	j	d32 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     df4:	008b8493          	addi	s1,s7,8
     df8:	4681                	li	a3,0
     dfa:	4629                	li	a2,10
     dfc:	000bb583          	ld	a1,0(s7)
     e00:	855a                	mv	a0,s6
     e02:	e4fff0ef          	jal	c50 <printint>
        i += 1;
     e06:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     e08:	8ba6                	mv	s7,s1
      state = 0;
     e0a:	4981                	li	s3,0
     e0c:	b71d                	j	d32 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e0e:	008b8493          	addi	s1,s7,8
     e12:	4681                	li	a3,0
     e14:	4629                	li	a2,10
     e16:	000bb583          	ld	a1,0(s7)
     e1a:	855a                	mv	a0,s6
     e1c:	e35ff0ef          	jal	c50 <printint>
        i += 2;
     e20:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     e22:	8ba6                	mv	s7,s1
      state = 0;
     e24:	4981                	li	s3,0
        i += 2;
     e26:	b731                	j	d32 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     e28:	008b8493          	addi	s1,s7,8
     e2c:	4681                	li	a3,0
     e2e:	4641                	li	a2,16
     e30:	000be583          	lwu	a1,0(s7)
     e34:	855a                	mv	a0,s6
     e36:	e1bff0ef          	jal	c50 <printint>
     e3a:	8ba6                	mv	s7,s1
      state = 0;
     e3c:	4981                	li	s3,0
     e3e:	bdd5                	j	d32 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e40:	008b8493          	addi	s1,s7,8
     e44:	4681                	li	a3,0
     e46:	4641                	li	a2,16
     e48:	000bb583          	ld	a1,0(s7)
     e4c:	855a                	mv	a0,s6
     e4e:	e03ff0ef          	jal	c50 <printint>
        i += 1;
     e52:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     e54:	8ba6                	mv	s7,s1
      state = 0;
     e56:	4981                	li	s3,0
     e58:	bde9                	j	d32 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e5a:	008b8493          	addi	s1,s7,8
     e5e:	4681                	li	a3,0
     e60:	4641                	li	a2,16
     e62:	000bb583          	ld	a1,0(s7)
     e66:	855a                	mv	a0,s6
     e68:	de9ff0ef          	jal	c50 <printint>
        i += 2;
     e6c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e6e:	8ba6                	mv	s7,s1
      state = 0;
     e70:	4981                	li	s3,0
        i += 2;
     e72:	b5c1                	j	d32 <vprintf+0x44>
     e74:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     e76:	008b8793          	addi	a5,s7,8
     e7a:	8cbe                	mv	s9,a5
     e7c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     e80:	03000593          	li	a1,48
     e84:	855a                	mv	a0,s6
     e86:	dadff0ef          	jal	c32 <putc>
  putc(fd, 'x');
     e8a:	07800593          	li	a1,120
     e8e:	855a                	mv	a0,s6
     e90:	da3ff0ef          	jal	c32 <putc>
     e94:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e96:	00000b97          	auipc	s7,0x0
     e9a:	74ab8b93          	addi	s7,s7,1866 # 15e0 <digits>
     e9e:	03c9d793          	srli	a5,s3,0x3c
     ea2:	97de                	add	a5,a5,s7
     ea4:	0007c583          	lbu	a1,0(a5)
     ea8:	855a                	mv	a0,s6
     eaa:	d89ff0ef          	jal	c32 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     eae:	0992                	slli	s3,s3,0x4
     eb0:	34fd                	addiw	s1,s1,-1
     eb2:	f4f5                	bnez	s1,e9e <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     eb4:	8be6                	mv	s7,s9
      state = 0;
     eb6:	4981                	li	s3,0
     eb8:	6ca2                	ld	s9,8(sp)
     eba:	bda5                	j	d32 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
     ebc:	008b8493          	addi	s1,s7,8
     ec0:	000bc583          	lbu	a1,0(s7)
     ec4:	855a                	mv	a0,s6
     ec6:	d6dff0ef          	jal	c32 <putc>
     eca:	8ba6                	mv	s7,s1
      state = 0;
     ecc:	4981                	li	s3,0
     ece:	b595                	j	d32 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     ed0:	008b8993          	addi	s3,s7,8
     ed4:	000bb483          	ld	s1,0(s7)
     ed8:	cc91                	beqz	s1,ef4 <vprintf+0x206>
        for(; *s; s++)
     eda:	0004c583          	lbu	a1,0(s1)
     ede:	c985                	beqz	a1,f0e <vprintf+0x220>
          putc(fd, *s);
     ee0:	855a                	mv	a0,s6
     ee2:	d51ff0ef          	jal	c32 <putc>
        for(; *s; s++)
     ee6:	0485                	addi	s1,s1,1
     ee8:	0004c583          	lbu	a1,0(s1)
     eec:	f9f5                	bnez	a1,ee0 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
     eee:	8bce                	mv	s7,s3
      state = 0;
     ef0:	4981                	li	s3,0
     ef2:	b581                	j	d32 <vprintf+0x44>
          s = "(null)";
     ef4:	00000497          	auipc	s1,0x0
     ef8:	6e448493          	addi	s1,s1,1764 # 15d8 <malloc+0x548>
        for(; *s; s++)
     efc:	02800593          	li	a1,40
     f00:	b7c5                	j	ee0 <vprintf+0x1f2>
        putc(fd, '%');
     f02:	85be                	mv	a1,a5
     f04:	855a                	mv	a0,s6
     f06:	d2dff0ef          	jal	c32 <putc>
      state = 0;
     f0a:	4981                	li	s3,0
     f0c:	b51d                	j	d32 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     f0e:	8bce                	mv	s7,s3
      state = 0;
     f10:	4981                	li	s3,0
     f12:	b505                	j	d32 <vprintf+0x44>
     f14:	6906                	ld	s2,64(sp)
     f16:	79e2                	ld	s3,56(sp)
     f18:	7a42                	ld	s4,48(sp)
     f1a:	7aa2                	ld	s5,40(sp)
     f1c:	7b02                	ld	s6,32(sp)
     f1e:	6be2                	ld	s7,24(sp)
     f20:	6c42                	ld	s8,16(sp)
    }
  }
}
     f22:	60e6                	ld	ra,88(sp)
     f24:	6446                	ld	s0,80(sp)
     f26:	64a6                	ld	s1,72(sp)
     f28:	6125                	addi	sp,sp,96
     f2a:	8082                	ret
      if(c0 == 'd'){
     f2c:	06400713          	li	a4,100
     f30:	e4e78fe3          	beq	a5,a4,d8e <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
     f34:	f9478693          	addi	a3,a5,-108
     f38:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
     f3c:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     f3e:	4701                	li	a4,0
      } else if(c0 == 'u'){
     f40:	07500513          	li	a0,117
     f44:	e8a78ce3          	beq	a5,a0,ddc <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
     f48:	f8b60513          	addi	a0,a2,-117
     f4c:	e119                	bnez	a0,f52 <vprintf+0x264>
     f4e:	ea0693e3          	bnez	a3,df4 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     f52:	f8b58513          	addi	a0,a1,-117
     f56:	e119                	bnez	a0,f5c <vprintf+0x26e>
     f58:	ea071be3          	bnez	a4,e0e <vprintf+0x120>
      } else if(c0 == 'x'){
     f5c:	07800513          	li	a0,120
     f60:	eca784e3          	beq	a5,a0,e28 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
     f64:	f8860613          	addi	a2,a2,-120
     f68:	e219                	bnez	a2,f6e <vprintf+0x280>
     f6a:	ec069be3          	bnez	a3,e40 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     f6e:	f8858593          	addi	a1,a1,-120
     f72:	e199                	bnez	a1,f78 <vprintf+0x28a>
     f74:	ee0713e3          	bnez	a4,e5a <vprintf+0x16c>
      } else if(c0 == 'p'){
     f78:	07000713          	li	a4,112
     f7c:	eee78ce3          	beq	a5,a4,e74 <vprintf+0x186>
      } else if(c0 == 'c'){
     f80:	06300713          	li	a4,99
     f84:	f2e78ce3          	beq	a5,a4,ebc <vprintf+0x1ce>
      } else if(c0 == 's'){
     f88:	07300713          	li	a4,115
     f8c:	f4e782e3          	beq	a5,a4,ed0 <vprintf+0x1e2>
      } else if(c0 == '%'){
     f90:	02500713          	li	a4,37
     f94:	f6e787e3          	beq	a5,a4,f02 <vprintf+0x214>
        putc(fd, '%');
     f98:	02500593          	li	a1,37
     f9c:	855a                	mv	a0,s6
     f9e:	c95ff0ef          	jal	c32 <putc>
        putc(fd, c0);
     fa2:	85a6                	mv	a1,s1
     fa4:	855a                	mv	a0,s6
     fa6:	c8dff0ef          	jal	c32 <putc>
      state = 0;
     faa:	4981                	li	s3,0
     fac:	b359                	j	d32 <vprintf+0x44>

0000000000000fae <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     fae:	715d                	addi	sp,sp,-80
     fb0:	ec06                	sd	ra,24(sp)
     fb2:	e822                	sd	s0,16(sp)
     fb4:	1000                	addi	s0,sp,32
     fb6:	e010                	sd	a2,0(s0)
     fb8:	e414                	sd	a3,8(s0)
     fba:	e818                	sd	a4,16(s0)
     fbc:	ec1c                	sd	a5,24(s0)
     fbe:	03043023          	sd	a6,32(s0)
     fc2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     fc6:	8622                	mv	a2,s0
     fc8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     fcc:	d23ff0ef          	jal	cee <vprintf>
}
     fd0:	60e2                	ld	ra,24(sp)
     fd2:	6442                	ld	s0,16(sp)
     fd4:	6161                	addi	sp,sp,80
     fd6:	8082                	ret

0000000000000fd8 <printf>:

void
printf(const char *fmt, ...)
{
     fd8:	711d                	addi	sp,sp,-96
     fda:	ec06                	sd	ra,24(sp)
     fdc:	e822                	sd	s0,16(sp)
     fde:	1000                	addi	s0,sp,32
     fe0:	e40c                	sd	a1,8(s0)
     fe2:	e810                	sd	a2,16(s0)
     fe4:	ec14                	sd	a3,24(s0)
     fe6:	f018                	sd	a4,32(s0)
     fe8:	f41c                	sd	a5,40(s0)
     fea:	03043823          	sd	a6,48(s0)
     fee:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     ff2:	00840613          	addi	a2,s0,8
     ff6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     ffa:	85aa                	mv	a1,a0
     ffc:	4505                	li	a0,1
     ffe:	cf1ff0ef          	jal	cee <vprintf>
}
    1002:	60e2                	ld	ra,24(sp)
    1004:	6442                	ld	s0,16(sp)
    1006:	6125                	addi	sp,sp,96
    1008:	8082                	ret

000000000000100a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    100a:	1141                	addi	sp,sp,-16
    100c:	e406                	sd	ra,8(sp)
    100e:	e022                	sd	s0,0(sp)
    1010:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1012:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1016:	00001797          	auipc	a5,0x1
    101a:	ff27b783          	ld	a5,-14(a5) # 2008 <freep>
    101e:	a039                	j	102c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1020:	6398                	ld	a4,0(a5)
    1022:	00e7e463          	bltu	a5,a4,102a <free+0x20>
    1026:	00e6ea63          	bltu	a3,a4,103a <free+0x30>
{
    102a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    102c:	fed7fae3          	bgeu	a5,a3,1020 <free+0x16>
    1030:	6398                	ld	a4,0(a5)
    1032:	00e6e463          	bltu	a3,a4,103a <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1036:	fee7eae3          	bltu	a5,a4,102a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    103a:	ff852583          	lw	a1,-8(a0)
    103e:	6390                	ld	a2,0(a5)
    1040:	02059813          	slli	a6,a1,0x20
    1044:	01c85713          	srli	a4,a6,0x1c
    1048:	9736                	add	a4,a4,a3
    104a:	02e60563          	beq	a2,a4,1074 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    104e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1052:	4790                	lw	a2,8(a5)
    1054:	02061593          	slli	a1,a2,0x20
    1058:	01c5d713          	srli	a4,a1,0x1c
    105c:	973e                	add	a4,a4,a5
    105e:	02e68263          	beq	a3,a4,1082 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1062:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1064:	00001717          	auipc	a4,0x1
    1068:	faf73223          	sd	a5,-92(a4) # 2008 <freep>
}
    106c:	60a2                	ld	ra,8(sp)
    106e:	6402                	ld	s0,0(sp)
    1070:	0141                	addi	sp,sp,16
    1072:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    1074:	4618                	lw	a4,8(a2)
    1076:	9f2d                	addw	a4,a4,a1
    1078:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    107c:	6398                	ld	a4,0(a5)
    107e:	6310                	ld	a2,0(a4)
    1080:	b7f9                	j	104e <free+0x44>
    p->s.size += bp->s.size;
    1082:	ff852703          	lw	a4,-8(a0)
    1086:	9f31                	addw	a4,a4,a2
    1088:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    108a:	ff053683          	ld	a3,-16(a0)
    108e:	bfd1                	j	1062 <free+0x58>

0000000000001090 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1090:	7139                	addi	sp,sp,-64
    1092:	fc06                	sd	ra,56(sp)
    1094:	f822                	sd	s0,48(sp)
    1096:	f04a                	sd	s2,32(sp)
    1098:	ec4e                	sd	s3,24(sp)
    109a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    109c:	02051993          	slli	s3,a0,0x20
    10a0:	0209d993          	srli	s3,s3,0x20
    10a4:	09bd                	addi	s3,s3,15
    10a6:	0049d993          	srli	s3,s3,0x4
    10aa:	2985                	addiw	s3,s3,1
    10ac:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    10ae:	00001517          	auipc	a0,0x1
    10b2:	f5a53503          	ld	a0,-166(a0) # 2008 <freep>
    10b6:	c905                	beqz	a0,10e6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10ba:	4798                	lw	a4,8(a5)
    10bc:	09377663          	bgeu	a4,s3,1148 <malloc+0xb8>
    10c0:	f426                	sd	s1,40(sp)
    10c2:	e852                	sd	s4,16(sp)
    10c4:	e456                	sd	s5,8(sp)
    10c6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    10c8:	8a4e                	mv	s4,s3
    10ca:	6705                	lui	a4,0x1
    10cc:	00e9f363          	bgeu	s3,a4,10d2 <malloc+0x42>
    10d0:	6a05                	lui	s4,0x1
    10d2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10d6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    10da:	00001497          	auipc	s1,0x1
    10de:	f2e48493          	addi	s1,s1,-210 # 2008 <freep>
  if(p == SBRK_ERROR)
    10e2:	5afd                	li	s5,-1
    10e4:	a83d                	j	1122 <malloc+0x92>
    10e6:	f426                	sd	s1,40(sp)
    10e8:	e852                	sd	s4,16(sp)
    10ea:	e456                	sd	s5,8(sp)
    10ec:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    10ee:	00001797          	auipc	a5,0x1
    10f2:	f2278793          	addi	a5,a5,-222 # 2010 <base>
    10f6:	00001717          	auipc	a4,0x1
    10fa:	f0f73923          	sd	a5,-238(a4) # 2008 <freep>
    10fe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1100:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1104:	b7d1                	j	10c8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1106:	6398                	ld	a4,0(a5)
    1108:	e118                	sd	a4,0(a0)
    110a:	a899                	j	1160 <malloc+0xd0>
  hp->s.size = nu;
    110c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1110:	0541                	addi	a0,a0,16
    1112:	ef9ff0ef          	jal	100a <free>
  return freep;
    1116:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1118:	c125                	beqz	a0,1178 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    111a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    111c:	4798                	lw	a4,8(a5)
    111e:	03277163          	bgeu	a4,s2,1140 <malloc+0xb0>
    if(p == freep)
    1122:	6098                	ld	a4,0(s1)
    1124:	853e                	mv	a0,a5
    1126:	fef71ae3          	bne	a4,a5,111a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    112a:	8552                	mv	a0,s4
    112c:	9e3ff0ef          	jal	b0e <sbrk>
  if(p == SBRK_ERROR)
    1130:	fd551ee3          	bne	a0,s5,110c <malloc+0x7c>
        return 0;
    1134:	4501                	li	a0,0
    1136:	74a2                	ld	s1,40(sp)
    1138:	6a42                	ld	s4,16(sp)
    113a:	6aa2                	ld	s5,8(sp)
    113c:	6b02                	ld	s6,0(sp)
    113e:	a03d                	j	116c <malloc+0xdc>
    1140:	74a2                	ld	s1,40(sp)
    1142:	6a42                	ld	s4,16(sp)
    1144:	6aa2                	ld	s5,8(sp)
    1146:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1148:	fae90fe3          	beq	s2,a4,1106 <malloc+0x76>
        p->s.size -= nunits;
    114c:	4137073b          	subw	a4,a4,s3
    1150:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1152:	02071693          	slli	a3,a4,0x20
    1156:	01c6d713          	srli	a4,a3,0x1c
    115a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    115c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1160:	00001717          	auipc	a4,0x1
    1164:	eaa73423          	sd	a0,-344(a4) # 2008 <freep>
      return (void*)(p + 1);
    1168:	01078513          	addi	a0,a5,16
  }
}
    116c:	70e2                	ld	ra,56(sp)
    116e:	7442                	ld	s0,48(sp)
    1170:	7902                	ld	s2,32(sp)
    1172:	69e2                	ld	s3,24(sp)
    1174:	6121                	addi	sp,sp,64
    1176:	8082                	ret
    1178:	74a2                	ld	s1,40(sp)
    117a:	6a42                	ld	s4,16(sp)
    117c:	6aa2                	ld	s5,8(sp)
    117e:	6b02                	ld	s6,0(sp)
    1180:	b7f5                	j	116c <malloc+0xdc>
