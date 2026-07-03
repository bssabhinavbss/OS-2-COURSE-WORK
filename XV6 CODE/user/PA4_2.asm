
user/_PA4_2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
    printf("=== Test 3 done (errors=%d) ===\n", errors);
}

int
main(void)
{
       0:	7115                	addi	sp,sp,-224
       2:	ed86                	sd	ra,216(sp)
       4:	e9a2                	sd	s0,208(sp)
       6:	e5a6                	sd	s1,200(sp)
       8:	e1ca                	sd	s2,192(sp)
       a:	fd4e                	sd	s3,184(sp)
       c:	f952                	sd	s4,176(sp)
       e:	f556                	sd	s5,168(sp)
      10:	f15a                	sd	s6,160(sp)
      12:	ed5e                	sd	s7,152(sp)
      14:	e962                	sd	s8,144(sp)
      16:	e566                	sd	s9,136(sp)
      18:	e16a                	sd	s10,128(sp)
      1a:	fcee                	sd	s11,120(sp)
      1c:	1180                	addi	s0,sp,224
  printf("==============================\n");
      1e:	00001517          	auipc	a0,0x1
      22:	12250513          	addi	a0,a0,290 # 1140 <malloc+0xf4>
      26:	76f000ef          	jal	f94 <printf>
  printf("PA4_B: Clock eviction & swap correctness\n");
      2a:	00001517          	auipc	a0,0x1
      2e:	13650513          	addi	a0,a0,310 # 1160 <malloc+0x114>
      32:	763000ef          	jal	f94 <printf>
  printf("==============================\n\n");
      36:	00001517          	auipc	a0,0x1
      3a:	15a50513          	addi	a0,a0,346 # 1190 <malloc+0x144>
      3e:	757000ef          	jal	f94 <printf>

  printf("--- PA4_3: clock reference bit ---\n");
      42:	00001517          	auipc	a0,0x1
      46:	17650513          	addi	a0,a0,374 # 11b8 <malloc+0x16c>
      4a:	74b000ef          	jal	f94 <printf>
    int pid = getpid();
      4e:	331000ef          	jal	b7e <getpid>
      52:	892a                	mv	s2,a0
    printf("=== test_clock: Clock Reference Bit Behavior ===\n");
      54:	00001517          	auipc	a0,0x1
      58:	18c50513          	addi	a0,a0,396 # 11e0 <malloc+0x194>
      5c:	739000ef          	jal	f94 <printf>
    char *hot  = sbrklazy((uint64)HOT_PAGES * PAGE_SIZE_3);
      60:	6529                	lui	a0,0xa
      62:	27f000ef          	jal	ae0 <sbrklazy>
      66:	89aa                	mv	s3,a0
    char *cold = sbrklazy((uint64)COLD_PAGES * PAGE_SIZE_3);
      68:	653d                	lui	a0,0xf
      6a:	277000ef          	jal	ae0 <sbrklazy>
    if (hot == (char *)-1 || cold == (char *)-1) {
      6e:	00198793          	addi	a5,s3,1
      72:	cfd9                	beqz	a5,110 <main+0x110>
      74:	872a                	mv	a4,a0
      76:	00150793          	addi	a5,a0,1 # f001 <base+0xcff1>
      7a:	cbd9                	beqz	a5,110 <main+0x110>
      7c:	84ce                	mv	s1,s3
      7e:	66a9                	lui	a3,0xa
      80:	96ce                	add	a3,a3,s3
      82:	87ce                	mv	a5,s3
        hot[i * PAGE_SIZE_3] = (char)(0xAA);
      84:	faa00593          	li	a1,-86
    for (int i = 0; i < HOT_PAGES; i++)
      88:	6605                	lui	a2,0x1
        hot[i * PAGE_SIZE_3] = (char)(0xAA);
      8a:	00b78023          	sb	a1,0(a5)
    for (int i = 0; i < HOT_PAGES; i++)
      8e:	97b2                	add	a5,a5,a2
      90:	fed79de3          	bne	a5,a3,8a <main+0x8a>
      94:	87ba                	mv	a5,a4
      96:	663d                	lui	a2,0xf
      98:	9732                	add	a4,a4,a2
        cold[i * PAGE_SIZE_3] = (char)(0xBB);
      9a:	fbb00593          	li	a1,-69
    for (int i = 0; i < COLD_PAGES; i++)
      9e:	6605                	lui	a2,0x1
        cold[i * PAGE_SIZE_3] = (char)(0xBB);
      a0:	00b78023          	sb	a1,0(a5)
    for (int i = 0; i < COLD_PAGES; i++)
      a4:	97b2                	add	a5,a5,a2
      a6:	fee79de3          	bne	a5,a4,a0 <main+0xa0>
      aa:	0aa00713          	li	a4,170
        for (int i = 0; i < HOT_PAGES; i++)
      ae:	6605                	lui	a2,0x1
    for (int round = 0; round < 5; round++) {
      b0:	0af00593          	li	a1,175
    if (hot == (char *)-1 || cold == (char *)-1) {
      b4:	87a6                	mv	a5,s1
            hot[i * PAGE_SIZE_3] = (char)(0xAA + round);
      b6:	00e78023          	sb	a4,0(a5)
        for (int i = 0; i < HOT_PAGES; i++)
      ba:	97b2                	add	a5,a5,a2
      bc:	fed79de3          	bne	a5,a3,b6 <main+0xb6>
    for (int round = 0; round < 5; round++) {
      c0:	2705                	addiw	a4,a4,1
      c2:	0ff77713          	zext.b	a4,a4
      c6:	feb717e3          	bne	a4,a1,b4 <main+0xb4>
    char *pressure = sbrklazy((uint64)PRESSURE_PAGES * PAGE_SIZE_3);
      ca:	00040537          	lui	a0,0x40
      ce:	213000ef          	jal	ae0 <sbrklazy>
    if (pressure == (char *)-1) {
      d2:	55fd                	li	a1,-1
      d4:	872a                	mv	a4,a0
    for (int i = 0; i < PRESSURE_PAGES; i++)
      d6:	4781                	li	a5,0
      d8:	6605                	lui	a2,0x1
      da:	04000693          	li	a3,64
    if (pressure == (char *)-1) {
      de:	04b50063          	beq	a0,a1,11e <main+0x11e>
        pressure[i * PAGE_SIZE_3] = (char)i;
      e2:	00f70023          	sb	a5,0(a4)
    for (int i = 0; i < PRESSURE_PAGES; i++)
      e6:	2785                	addiw	a5,a5,1
      e8:	9732                	add	a4,a4,a2
      ea:	fed79ce3          	bne	a5,a3,e2 <main+0xe2>
    printf("[Verifying HOT pages]\n");
      ee:	00001517          	auipc	a0,0x1
      f2:	15a50513          	addi	a0,a0,346 # 1248 <malloc+0x1fc>
      f6:	69f000ef          	jal	f94 <printf>
    int hot_errs = 0;
      fa:	4a81                	li	s5,0
    for (int i = 0; i < HOT_PAGES; i++) {
      fc:	4981                	li	s3,0
        if (hot[i * PAGE_SIZE_3] != expected_hot) {
      fe:	0ae00a13          	li	s4,174
            printf("  FAIL: hot page %d corrupted (got 0x%x expected 0x%x)\n",
     102:	00001c17          	auipc	s8,0x1
     106:	15ec0c13          	addi	s8,s8,350 # 1260 <malloc+0x214>
    for (int i = 0; i < HOT_PAGES; i++) {
     10a:	6b85                	lui	s7,0x1
     10c:	4b29                	li	s6,10
     10e:	a80d                	j	140 <main+0x140>
        printf("FAIL: sbrk\n");
     110:	00001517          	auipc	a0,0x1
     114:	10850513          	addi	a0,a0,264 # 1218 <malloc+0x1cc>
     118:	67d000ef          	jal	f94 <printf>
        return;
     11c:	a0d9                	j	1e2 <main+0x1e2>
        printf("FAIL: sbrk for pressure\n");
     11e:	00001517          	auipc	a0,0x1
     122:	10a50513          	addi	a0,a0,266 # 1228 <malloc+0x1dc>
     126:	66f000ef          	jal	f94 <printf>
        return;
     12a:	a865                	j	1e2 <main+0x1e2>
            printf("  FAIL: hot page %d corrupted (got 0x%x expected 0x%x)\n",
     12c:	86d2                	mv	a3,s4
     12e:	85ce                	mv	a1,s3
     130:	8562                	mv	a0,s8
     132:	663000ef          	jal	f94 <printf>
            hot_errs++;
     136:	2a85                	addiw	s5,s5,1
    for (int i = 0; i < HOT_PAGES; i++) {
     138:	2985                	addiw	s3,s3,1
     13a:	94de                	add	s1,s1,s7
     13c:	01698763          	beq	s3,s6,14a <main+0x14a>
        if (hot[i * PAGE_SIZE_3] != expected_hot) {
     140:	0004c603          	lbu	a2,0(s1)
     144:	ff460ae3          	beq	a2,s4,138 <main+0x138>
     148:	b7d5                	j	12c <main+0x12c>
    if (hot_errs == 0)
     14a:	1a0a9063          	bnez	s5,2ea <main+0x2ea>
        printf("  PASS: all %d hot pages intact\n", HOT_PAGES);
     14e:	45a9                	li	a1,10
     150:	00001517          	auipc	a0,0x1
     154:	14850513          	addi	a0,a0,328 # 1298 <malloc+0x24c>
     158:	63d000ef          	jal	f94 <printf>
    getvmstats(pid, &st);
     15c:	f6040593          	addi	a1,s0,-160
     160:	854a                	mv	a0,s2
     162:	27d000ef          	jal	bde <getvmstats>
    printf("\n--- VM Stats ---\n");
     166:	00001517          	auipc	a0,0x1
     16a:	1b250513          	addi	a0,a0,434 # 1318 <malloc+0x2cc>
     16e:	627000ef          	jal	f94 <printf>
    printf("  page_faults      : %d\n", st.page_faults);
     172:	f6042583          	lw	a1,-160(s0)
     176:	00001517          	auipc	a0,0x1
     17a:	1ba50513          	addi	a0,a0,442 # 1330 <malloc+0x2e4>
     17e:	617000ef          	jal	f94 <printf>
    printf("  pages_evicted    : %d\n", st.pages_evicted);
     182:	f6442583          	lw	a1,-156(s0)
     186:	00001517          	auipc	a0,0x1
     18a:	1ca50513          	addi	a0,a0,458 # 1350 <malloc+0x304>
     18e:	607000ef          	jal	f94 <printf>
    printf("  pages_swapped_out: %d\n", st.pages_swapped_out);
     192:	f6c42583          	lw	a1,-148(s0)
     196:	00001517          	auipc	a0,0x1
     19a:	1da50513          	addi	a0,a0,474 # 1370 <malloc+0x324>
     19e:	5f7000ef          	jal	f94 <printf>
    printf("  pages_swapped_in : %d\n", st.pages_swapped_in);
     1a2:	f6842583          	lw	a1,-152(s0)
     1a6:	00001517          	auipc	a0,0x1
     1aa:	1ea50513          	addi	a0,a0,490 # 1390 <malloc+0x344>
     1ae:	5e7000ef          	jal	f94 <printf>
    printf("  resident_pages   : %d\n", st.resident_pages);
     1b2:	f7042583          	lw	a1,-144(s0)
     1b6:	00001517          	auipc	a0,0x1
     1ba:	1fa50513          	addi	a0,a0,506 # 13b0 <malloc+0x364>
     1be:	5d7000ef          	jal	f94 <printf>
    if (st.pages_evicted > 0)
     1c2:	f6442783          	lw	a5,-156(s0)
     1c6:	12f05a63          	blez	a5,2fa <main+0x2fa>
        printf("PASS: evictions occurred — Clock algorithm is running\n");
     1ca:	00001517          	auipc	a0,0x1
     1ce:	20650513          	addi	a0,a0,518 # 13d0 <malloc+0x384>
     1d2:	5c3000ef          	jal	f94 <printf>
    printf("=== test_clock done ===\n");
     1d6:	00001517          	auipc	a0,0x1
     1da:	28250513          	addi	a0,a0,642 # 1458 <malloc+0x40c>
     1de:	5b7000ef          	jal	f94 <printf>
  test_pa4_3();

  printf("\n--- PA4_4: clock page replacement ---\n");
     1e2:	00001517          	auipc	a0,0x1
     1e6:	29650513          	addi	a0,a0,662 # 1478 <malloc+0x42c>
     1ea:	5ab000ef          	jal	f94 <printf>
    int pid = getpid();
     1ee:	191000ef          	jal	b7e <getpid>
     1f2:	8a2a                	mv	s4,a0
    printf("=== test_replacement: Clock Page Replacement Test ===\n");
     1f4:	00001517          	auipc	a0,0x1
     1f8:	2ac50513          	addi	a0,a0,684 # 14a0 <malloc+0x454>
     1fc:	599000ef          	jal	f94 <printf>
    printf("PID: %d | Frame limit: %d | Allocating: %d pages\n",
     200:	0c000693          	li	a3,192
     204:	04000613          	li	a2,64
     208:	85d2                	mv	a1,s4
     20a:	00001517          	auipc	a0,0x1
     20e:	2ce50513          	addi	a0,a0,718 # 14d8 <malloc+0x48c>
     212:	583000ef          	jal	f94 <printf>
    char *mem = sbrklazy((uint64)NUM_PAGES_4 * PAGE_SIZE_4);
     216:	650d                	lui	a0,0x3
     218:	0c9000ef          	jal	ae0 <sbrklazy>
     21c:	84aa                	mv	s1,a0
    if (mem == (char *)-1) {
     21e:	57fd                	li	a5,-1
     220:	0ef50463          	beq	a0,a5,308 <main+0x308>
    getvmstats(pid, &before);
     224:	f3040593          	addi	a1,s0,-208
     228:	8552                	mv	a0,s4
     22a:	1b5000ef          	jal	bde <getvmstats>
    printf("[Phase 1] Writing %d pages sequentially...\n", NUM_PAGES_4);
     22e:	0c000593          	li	a1,192
     232:	00001517          	auipc	a0,0x1
     236:	2f650513          	addi	a0,a0,758 # 1528 <malloc+0x4dc>
     23a:	55b000ef          	jal	f94 <printf>
    for (int i = 0; i < NUM_PAGES_4; i++) {
     23e:	8926                	mv	s2,s1
    printf("[Phase 1] Writing %d pages sequentially...\n", NUM_PAGES_4);
     240:	8726                	mv	a4,s1
    for (int i = 0; i < NUM_PAGES_4; i++) {
     242:	4781                	li	a5,0
     244:	0c000693          	li	a3,192
        mem[i * PAGE_SIZE_4] = (char)(i & 0xFF);
     248:	00f70023          	sb	a5,0(a4)
    for (int i = 0; i < NUM_PAGES_4; i++) {
     24c:	2785                	addiw	a5,a5,1
     24e:	04070713          	addi	a4,a4,64
     252:	fed79be3          	bne	a5,a3,248 <main+0x248>
    getvmstats(pid, &after);
     256:	f6040593          	addi	a1,s0,-160
     25a:	8552                	mv	a0,s4
     25c:	183000ef          	jal	bde <getvmstats>
    printf("  page_faults      : %d\n", after.page_faults - before.page_faults);
     260:	f6042583          	lw	a1,-160(s0)
     264:	f3042783          	lw	a5,-208(s0)
     268:	9d9d                	subw	a1,a1,a5
     26a:	00001517          	auipc	a0,0x1
     26e:	0c650513          	addi	a0,a0,198 # 1330 <malloc+0x2e4>
     272:	523000ef          	jal	f94 <printf>
    printf("  pages_evicted    : %d\n", after.pages_evicted - before.pages_evicted);
     276:	f6442583          	lw	a1,-156(s0)
     27a:	f3442783          	lw	a5,-204(s0)
     27e:	9d9d                	subw	a1,a1,a5
     280:	00001517          	auipc	a0,0x1
     284:	0d050513          	addi	a0,a0,208 # 1350 <malloc+0x304>
     288:	50d000ef          	jal	f94 <printf>
    printf("  pages_swapped_out: %d\n", after.pages_swapped_out - before.pages_swapped_out);
     28c:	f6c42583          	lw	a1,-148(s0)
     290:	f3c42783          	lw	a5,-196(s0)
     294:	9d9d                	subw	a1,a1,a5
     296:	00001517          	auipc	a0,0x1
     29a:	0da50513          	addi	a0,a0,218 # 1370 <malloc+0x324>
     29e:	4f7000ef          	jal	f94 <printf>
    printf("  resident_pages   : %d\n", after.resident_pages);
     2a2:	f7042583          	lw	a1,-144(s0)
     2a6:	00001517          	auipc	a0,0x1
     2aa:	10a50513          	addi	a0,a0,266 # 13b0 <malloc+0x364>
     2ae:	4e7000ef          	jal	f94 <printf>
    if (after.pages_evicted > 0)
     2b2:	f6442583          	lw	a1,-156(s0)
     2b6:	06b05063          	blez	a1,316 <main+0x316>
        printf("PASS: evictions occurred (%d)\n", after.pages_evicted);
     2ba:	00001517          	auipc	a0,0x1
     2be:	29e50513          	addi	a0,a0,670 # 1558 <malloc+0x50c>
     2c2:	4d3000ef          	jal	f94 <printf>
    printf("[Phase 2] Reading back all %d pages...\n", NUM_PAGES_4);
     2c6:	0c000593          	li	a1,192
     2ca:	00001517          	auipc	a0,0x1
     2ce:	2f650513          	addi	a0,a0,758 # 15c0 <malloc+0x574>
     2d2:	4c3000ef          	jal	f94 <printf>
    int errs = 0;
     2d6:	4981                	li	s3,0
    for (int i = 0; i < NUM_PAGES_4; i++) {
     2d8:	4481                	li	s1,0
            printf("FAIL: page %d: expected %d got %d\n",
     2da:	00001b97          	auipc	s7,0x1
     2de:	30eb8b93          	addi	s7,s7,782 # 15e8 <malloc+0x59c>
            if (errs > 5) { printf("  (too many errors, stopping)\n"); break; }
     2e2:	4b15                	li	s6,5
    for (int i = 0; i < NUM_PAGES_4; i++) {
     2e4:	0c000a93          	li	s5,192
     2e8:	a099                	j	32e <main+0x32e>
        printf("  FAIL: %d hot pages corrupted — Clock may not be protecting recently used pages\n",
     2ea:	85d6                	mv	a1,s5
     2ec:	00001517          	auipc	a0,0x1
     2f0:	fd450513          	addi	a0,a0,-44 # 12c0 <malloc+0x274>
     2f4:	4a1000ef          	jal	f94 <printf>
     2f8:	b595                	j	15c <main+0x15c>
        printf("WARN: no evictions — increase PRESSURE_PAGES or lower FRAME_LIMIT\n");
     2fa:	00001517          	auipc	a0,0x1
     2fe:	11650513          	addi	a0,a0,278 # 1410 <malloc+0x3c4>
     302:	493000ef          	jal	f94 <printf>
     306:	bdc1                	j	1d6 <main+0x1d6>
        printf("FAIL: sbrk failed\n");
     308:	00001517          	auipc	a0,0x1
     30c:	20850513          	addi	a0,a0,520 # 1510 <malloc+0x4c4>
     310:	485000ef          	jal	f94 <printf>
        return;
     314:	a861                	j	3ac <main+0x3ac>
        printf("WARN: no evictions yet — increase NUM_PAGES or lower FRAME_LIMIT\n");
     316:	00001517          	auipc	a0,0x1
     31a:	26250513          	addi	a0,a0,610 # 1578 <malloc+0x52c>
     31e:	477000ef          	jal	f94 <printf>
     322:	b755                	j	2c6 <main+0x2c6>
    for (int i = 0; i < NUM_PAGES_4; i++) {
     324:	2485                	addiw	s1,s1,1
     326:	04090913          	addi	s2,s2,64
     32a:	0d548f63          	beq	s1,s5,408 <main+0x408>
        if (mem[i * PAGE_SIZE_4] != expected) {
     32e:	00094683          	lbu	a3,0(s2)
     332:	0ff4f793          	zext.b	a5,s1
     336:	fef687e3          	beq	a3,a5,324 <main+0x324>
            printf("FAIL: page %d: expected %d got %d\n",
     33a:	8626                	mv	a2,s1
     33c:	85a6                	mv	a1,s1
     33e:	855e                	mv	a0,s7
     340:	455000ef          	jal	f94 <printf>
            errs++;
     344:	2985                	addiw	s3,s3,1
            if (errs > 5) { printf("  (too many errors, stopping)\n"); break; }
     346:	fd3b5fe3          	bge	s6,s3,324 <main+0x324>
     34a:	00001517          	auipc	a0,0x1
     34e:	2c650513          	addi	a0,a0,710 # 1610 <malloc+0x5c4>
     352:	443000ef          	jal	f94 <printf>
    getvmstats(pid, &after);
     356:	f6040593          	addi	a1,s0,-160
     35a:	8552                	mv	a0,s4
     35c:	083000ef          	jal	bde <getvmstats>
    printf("[Phase 2 stats]\n");
     360:	00001517          	auipc	a0,0x1
     364:	31050513          	addi	a0,a0,784 # 1670 <malloc+0x624>
     368:	42d000ef          	jal	f94 <printf>
    printf("  pages_swapped_in : %d\n", after.pages_swapped_in);
     36c:	f6842583          	lw	a1,-152(s0)
     370:	00001517          	auipc	a0,0x1
     374:	02050513          	addi	a0,a0,32 # 1390 <malloc+0x344>
     378:	41d000ef          	jal	f94 <printf>
    printf("  resident_pages   : %d\n", after.resident_pages);
     37c:	f7042583          	lw	a1,-144(s0)
     380:	00001517          	auipc	a0,0x1
     384:	03050513          	addi	a0,a0,48 # 13b0 <malloc+0x364>
     388:	40d000ef          	jal	f94 <printf>
    if (after.pages_swapped_in > 0)
     38c:	f6842583          	lw	a1,-152(s0)
     390:	08b05763          	blez	a1,41e <main+0x41e>
        printf("PASS: swap-ins occurred (%d)\n", after.pages_swapped_in);
     394:	00001517          	auipc	a0,0x1
     398:	2f450513          	addi	a0,a0,756 # 1688 <malloc+0x63c>
     39c:	3f9000ef          	jal	f94 <printf>
    printf("=== test_replacement done ===\n");
     3a0:	00001517          	auipc	a0,0x1
     3a4:	32850513          	addi	a0,a0,808 # 16c8 <malloc+0x67c>
     3a8:	3ed000ef          	jal	f94 <printf>
  test_pa4_4();

  printf("\n--- PA4_6: swap correctness stress ---\n");
     3ac:	00001517          	auipc	a0,0x1
     3b0:	33c50513          	addi	a0,a0,828 # 16e8 <malloc+0x69c>
     3b4:	3e1000ef          	jal	f94 <printf>
    int pid = getpid();
     3b8:	7c6000ef          	jal	b7e <getpid>
     3bc:	84aa                	mv	s1,a0
     3be:	f2a43423          	sd	a0,-216(s0)
    printf("=== test_swap: Swap Correctness Stress Test ===\n");
     3c2:	00001517          	auipc	a0,0x1
     3c6:	35650513          	addi	a0,a0,854 # 1718 <malloc+0x6cc>
     3ca:	3cb000ef          	jal	f94 <printf>
    printf("PID: %d | %d pages | %d passes\n", pid, NUM_PAGES_6, NUM_PASSES_6);
     3ce:	468d                	li	a3,3
     3d0:	08000613          	li	a2,128
     3d4:	85a6                	mv	a1,s1
     3d6:	00001517          	auipc	a0,0x1
     3da:	37a50513          	addi	a0,a0,890 # 1750 <malloc+0x704>
     3de:	3b7000ef          	jal	f94 <printf>
    char *mem = sbrklazy((uint64)NUM_PAGES_6 * PAGE_SIZE_6);
     3e2:	6509                	lui	a0,0x2
     3e4:	6fc000ef          	jal	ae0 <sbrklazy>
     3e8:	f2a43023          	sd	a0,-224(s0)
    if (mem == (char *)-1) {
     3ec:	57fd                	li	a5,-1
     3ee:	08000c93          	li	s9,128
    int total_errs = 0;
     3f2:	4d81                	li	s11,0
    for (int pass = 0; pass < NUM_PASSES_6; pass++) {
     3f4:	4d01                	li	s10,0
    if (mem == (char *)-1) {
     3f6:	02f50b63          	beq	a0,a5,42c <main+0x42c>
                printf("  ERR page %d: expected 0x%x got 0x%x\n",
     3fa:	00001c17          	auipc	s8,0x1
     3fe:	3bec0c13          	addi	s8,s8,958 # 17b8 <malloc+0x76c>
                if (errs > 10) { printf("  (stopping early)\n"); break; }
     402:	4ba9                	li	s7,10
        for (int i = 0; i < NUM_PAGES_6; i++) {
     404:	8b66                	mv	s6,s9
     406:	aaa9                	j	560 <main+0x560>
    if (errs == 0)
     408:	f40997e3          	bnez	s3,356 <main+0x356>
        printf("PASS: all %d pages read back correctly after eviction/swap-in\n",
     40c:	0c000593          	li	a1,192
     410:	00001517          	auipc	a0,0x1
     414:	22050513          	addi	a0,a0,544 # 1630 <malloc+0x5e4>
     418:	37d000ef          	jal	f94 <printf>
     41c:	bf2d                	j	356 <main+0x356>
        printf("WARN: no swap-ins recorded\n");
     41e:	00001517          	auipc	a0,0x1
     422:	28a50513          	addi	a0,a0,650 # 16a8 <malloc+0x65c>
     426:	36f000ef          	jal	f94 <printf>
     42a:	bf9d                	j	3a0 <main+0x3a0>
        printf("FAIL: sbrk\n");
     42c:	00001517          	auipc	a0,0x1
     430:	dec50513          	addi	a0,a0,-532 # 1218 <malloc+0x1cc>
     434:	361000ef          	jal	f94 <printf>
        return;
     438:	a2f9                	j	606 <main+0x606>
        for (int i = 0; i < NUM_PAGES_6; i++) {
     43a:	2905                	addiw	s2,s2,1
     43c:	04098993          	addi	s3,s3,64
     440:	249d                	addiw	s1,s1,7
     442:	0ff4f493          	zext.b	s1,s1
     446:	09690f63          	beq	s2,s6,4e4 <main+0x4e4>
            char got = mem[i * PAGE_SIZE_6];
     44a:	0009c683          	lbu	a3,0(s3)
            if (got != expected) {
     44e:	fe9686e3          	beq	a3,s1,43a <main+0x43a>
                printf("  ERR page %d: expected 0x%x got 0x%x\n",
     452:	8626                	mv	a2,s1
     454:	85ca                	mv	a1,s2
     456:	8562                	mv	a0,s8
     458:	33d000ef          	jal	f94 <printf>
                errs++;
     45c:	001a0a9b          	addiw	s5,s4,1
     460:	8a56                	mv	s4,s5
                if (errs > 10) { printf("  (stopping early)\n"); break; }
     462:	fd5bdce3          	bge	s7,s5,43a <main+0x43a>
     466:	00001517          	auipc	a0,0x1
     46a:	37a50513          	addi	a0,a0,890 # 17e0 <malloc+0x794>
     46e:	327000ef          	jal	f94 <printf>
        total_errs += errs;
     472:	01ba8dbb          	addw	s11,s5,s11
        getvmstats(pid, &st);
     476:	f6040593          	addi	a1,s0,-160
     47a:	f2843503          	ld	a0,-216(s0)
     47e:	760000ef          	jal	bde <getvmstats>
        printf("  page_faults      : %d\n", st.page_faults);
     482:	f6042583          	lw	a1,-160(s0)
     486:	00001517          	auipc	a0,0x1
     48a:	eaa50513          	addi	a0,a0,-342 # 1330 <malloc+0x2e4>
     48e:	307000ef          	jal	f94 <printf>
        printf("  pages_evicted    : %d\n", st.pages_evicted);
     492:	f6442583          	lw	a1,-156(s0)
     496:	00001517          	auipc	a0,0x1
     49a:	eba50513          	addi	a0,a0,-326 # 1350 <malloc+0x304>
     49e:	2f7000ef          	jal	f94 <printf>
        printf("  pages_swapped_out: %d\n", st.pages_swapped_out);
     4a2:	f6c42583          	lw	a1,-148(s0)
     4a6:	00001517          	auipc	a0,0x1
     4aa:	eca50513          	addi	a0,a0,-310 # 1370 <malloc+0x324>
     4ae:	2e7000ef          	jal	f94 <printf>
        printf("  pages_swapped_in : %d\n", st.pages_swapped_in);
     4b2:	f6842583          	lw	a1,-152(s0)
     4b6:	00001517          	auipc	a0,0x1
     4ba:	eda50513          	addi	a0,a0,-294 # 1390 <malloc+0x344>
     4be:	2d7000ef          	jal	f94 <printf>
        printf("  resident_pages   : %d\n", st.resident_pages);
     4c2:	f7042583          	lw	a1,-144(s0)
     4c6:	00001517          	auipc	a0,0x1
     4ca:	eea50513          	addi	a0,a0,-278 # 13b0 <malloc+0x364>
     4ce:	2c7000ef          	jal	f94 <printf>
            printf("FAIL: pass %d had %d data errors\n", pass, errs);
     4d2:	8652                	mv	a2,s4
     4d4:	85ea                	mv	a1,s10
     4d6:	00001517          	auipc	a0,0x1
     4da:	34a50513          	addi	a0,a0,842 # 1820 <malloc+0x7d4>
     4de:	2b7000ef          	jal	f94 <printf>
     4e2:	a885                	j	552 <main+0x552>
        getvmstats(pid, &st);
     4e4:	f6040593          	addi	a1,s0,-160
     4e8:	f2843503          	ld	a0,-216(s0)
     4ec:	6f2000ef          	jal	bde <getvmstats>
        printf("  page_faults      : %d\n", st.page_faults);
     4f0:	f6042583          	lw	a1,-160(s0)
     4f4:	00001517          	auipc	a0,0x1
     4f8:	e3c50513          	addi	a0,a0,-452 # 1330 <malloc+0x2e4>
     4fc:	299000ef          	jal	f94 <printf>
        printf("  pages_evicted    : %d\n", st.pages_evicted);
     500:	f6442583          	lw	a1,-156(s0)
     504:	00001517          	auipc	a0,0x1
     508:	e4c50513          	addi	a0,a0,-436 # 1350 <malloc+0x304>
     50c:	289000ef          	jal	f94 <printf>
        printf("  pages_swapped_out: %d\n", st.pages_swapped_out);
     510:	f6c42583          	lw	a1,-148(s0)
     514:	00001517          	auipc	a0,0x1
     518:	e5c50513          	addi	a0,a0,-420 # 1370 <malloc+0x324>
     51c:	279000ef          	jal	f94 <printf>
        printf("  pages_swapped_in : %d\n", st.pages_swapped_in);
     520:	f6842583          	lw	a1,-152(s0)
     524:	00001517          	auipc	a0,0x1
     528:	e6c50513          	addi	a0,a0,-404 # 1390 <malloc+0x344>
     52c:	269000ef          	jal	f94 <printf>
        printf("  resident_pages   : %d\n", st.resident_pages);
     530:	f7042583          	lw	a1,-144(s0)
     534:	00001517          	auipc	a0,0x1
     538:	e7c50513          	addi	a0,a0,-388 # 13b0 <malloc+0x364>
     53c:	259000ef          	jal	f94 <printf>
        if (errs == 0)
     540:	060a1263          	bnez	s4,5a4 <main+0x5a4>
            printf("PASS: pass %d data integrity OK\n", pass);
     544:	85ea                	mv	a1,s10
     546:	00001517          	auipc	a0,0x1
     54a:	2b250513          	addi	a0,a0,690 # 17f8 <malloc+0x7ac>
     54e:	247000ef          	jal	f94 <printf>
    for (int pass = 0; pass < NUM_PASSES_6; pass++) {
     552:	2d05                	addiw	s10,s10,1
     554:	2cb5                	addiw	s9,s9,13
     556:	0ffcfc93          	zext.b	s9,s9
     55a:	478d                	li	a5,3
     55c:	04fd0763          	beq	s10,a5,5aa <main+0x5aa>
        printf("\n--- Pass %d: writing patterns ---\n", pass);
     560:	85ea                	mv	a1,s10
     562:	00001517          	auipc	a0,0x1
     566:	20e50513          	addi	a0,a0,526 # 1770 <malloc+0x724>
     56a:	22b000ef          	jal	f94 <printf>
        for (int i = 0; i < NUM_PAGES_6; i++)
     56e:	f80c849b          	addiw	s1,s9,-128
     572:	0ff4f493          	zext.b	s1,s1
     576:	f2043703          	ld	a4,-224(s0)
     57a:	89ba                	mv	s3,a4
        printf("\n--- Pass %d: writing patterns ---\n", pass);
     57c:	87a6                	mv	a5,s1
            mem[i * PAGE_SIZE_6] = pattern_6(i, pass);
     57e:	00f70023          	sb	a5,0(a4)
        for (int i = 0; i < NUM_PAGES_6; i++)
     582:	279d                	addiw	a5,a5,7
     584:	0ff7f793          	zext.b	a5,a5
     588:	04070713          	addi	a4,a4,64
     58c:	ff9799e3          	bne	a5,s9,57e <main+0x57e>
        printf("--- Pass %d: reading back ---\n", pass);
     590:	85ea                	mv	a1,s10
     592:	00001517          	auipc	a0,0x1
     596:	20650513          	addi	a0,a0,518 # 1798 <malloc+0x74c>
     59a:	1fb000ef          	jal	f94 <printf>
        int errs = 0;
     59e:	4a01                	li	s4,0
        for (int i = 0; i < NUM_PAGES_6; i++) {
     5a0:	4901                	li	s2,0
     5a2:	b565                	j	44a <main+0x44a>
        total_errs += errs;
     5a4:	01ba0dbb          	addw	s11,s4,s11
     5a8:	b72d                	j	4d2 <main+0x4d2>
    printf("\n=== Summary ===\n");
     5aa:	00001517          	auipc	a0,0x1
     5ae:	29e50513          	addi	a0,a0,670 # 1848 <malloc+0x7fc>
     5b2:	1e3000ef          	jal	f94 <printf>
    if (total_errs == 0)
     5b6:	140d9363          	bnez	s11,6fc <main+0x6fc>
        printf("PASS: all passes completed with correct data\n");
     5ba:	00001517          	auipc	a0,0x1
     5be:	2a650513          	addi	a0,a0,678 # 1860 <malloc+0x814>
     5c2:	1d3000ef          	jal	f94 <printf>
    getvmstats(pid, &st);
     5c6:	f6040593          	addi	a1,s0,-160
     5ca:	f2843503          	ld	a0,-216(s0)
     5ce:	610000ef          	jal	bde <getvmstats>
    if (st.pages_swapped_in > 0)
     5d2:	f6842583          	lw	a1,-152(s0)
     5d6:	12b05b63          	blez	a1,70c <main+0x70c>
        printf("PASS: pages_swapped_in = %d (swap-in works)\n", st.pages_swapped_in);
     5da:	00001517          	auipc	a0,0x1
     5de:	2e650513          	addi	a0,a0,742 # 18c0 <malloc+0x874>
     5e2:	1b3000ef          	jal	f94 <printf>
    if (st.pages_swapped_out > 0)
     5e6:	f6c42583          	lw	a1,-148(s0)
     5ea:	12b05863          	blez	a1,71a <main+0x71a>
        printf("PASS: pages_swapped_out = %d (swap-out works)\n", st.pages_swapped_out);
     5ee:	00001517          	auipc	a0,0x1
     5f2:	34250513          	addi	a0,a0,834 # 1930 <malloc+0x8e4>
     5f6:	19f000ef          	jal	f94 <printf>
    printf("=== test_swap done ===\n");
     5fa:	00001517          	auipc	a0,0x1
     5fe:	38650513          	addi	a0,a0,902 # 1980 <malloc+0x934>
     602:	193000ef          	jal	f94 <printf>
  test_pa4_6();

  printf("\n--- PA4_8: page replacement sentinels ---\n");
     606:	00001517          	auipc	a0,0x1
     60a:	39250513          	addi	a0,a0,914 # 1998 <malloc+0x94c>
     60e:	187000ef          	jal	f94 <printf>
    printf("=== Test 3: Page replacement (MAXFRAMES=%d, TOTAL=%d) ===\n",
     612:	04800613          	li	a2,72
     616:	04000593          	li	a1,64
     61a:	00001517          	auipc	a0,0x1
     61e:	3ae50513          	addi	a0,a0,942 # 19c8 <malloc+0x97c>
     622:	173000ef          	jal	f94 <printf>
    int pid = getpid();
     626:	558000ef          	jal	b7e <getpid>
     62a:	8aaa                	mv	s5,a0
    char *mem = sbrklazy(TOTAL_PAGES_8 * PAGE_SIZE_8);
     62c:	6549                	lui	a0,0x12
     62e:	4b2000ef          	jal	ae0 <sbrklazy>
     632:	84aa                	mv	s1,a0
    if (mem == (char *)-1) { printf("FAIL: sbrk\n"); return; }
     634:	57fd                	li	a5,-1
     636:	0ef50963          	beq	a0,a5,728 <main+0x728>
    getvmstats(pid, &s0);
     63a:	f3040593          	addi	a1,s0,-208
     63e:	8556                	mv	a0,s5
     640:	59e000ef          	jal	bde <getvmstats>
    printf("Writing %d pages...\n", TOTAL_PAGES_8);
     644:	04800593          	li	a1,72
     648:	00001517          	auipc	a0,0x1
     64c:	3c050513          	addi	a0,a0,960 # 1a08 <malloc+0x9bc>
     650:	145000ef          	jal	f94 <printf>
    for (int i = 0; i < TOTAL_PAGES_8; i++) {
     654:	8926                	mv	s2,s1
    printf("Writing %d pages...\n", TOTAL_PAGES_8);
     656:	8726                	mv	a4,s1
     658:	4785                	li	a5,1
    for (int i = 0; i < TOTAL_PAGES_8; i++) {
     65a:	04900693          	li	a3,73
        mem[i * PAGE_SIZE_8] = (char)(i + 1);
     65e:	00f70023          	sb	a5,0(a4)
    for (int i = 0; i < TOTAL_PAGES_8; i++) {
     662:	0785                	addi	a5,a5,1
     664:	40070713          	addi	a4,a4,1024
     668:	fed79be3          	bne	a5,a3,65e <main+0x65e>
    getvmstats(pid, &s1);
     66c:	f6040593          	addi	a1,s0,-160
     670:	8556                	mv	a0,s5
     672:	56c000ef          	jal	bde <getvmstats>
    printf("[repl] %s faults=%d evicted=%d sout=%d sin=%d resident=%d\n",
     676:	f7042803          	lw	a6,-144(s0)
     67a:	f6842783          	lw	a5,-152(s0)
     67e:	f6c42703          	lw	a4,-148(s0)
     682:	f6442683          	lw	a3,-156(s0)
     686:	f6042603          	lw	a2,-160(s0)
     68a:	00001597          	auipc	a1,0x1
     68e:	39658593          	addi	a1,a1,918 # 1a20 <malloc+0x9d4>
     692:	00001517          	auipc	a0,0x1
     696:	3a650513          	addi	a0,a0,934 # 1a38 <malloc+0x9ec>
     69a:	0fb000ef          	jal	f94 <printf>
    int evictions = s1.pages_evicted - s0.pages_evicted;
     69e:	f6442483          	lw	s1,-156(s0)
     6a2:	f3442783          	lw	a5,-204(s0)
     6a6:	9c9d                	subw	s1,s1,a5
     6a8:	89a6                	mv	s3,s1
    if (evictions >= EXTRA_8)
     6aa:	479d                	li	a5,7
     6ac:	0897d563          	bge	a5,s1,736 <main+0x736>
        printf("  PASS: at least %d evictions occurred (%d)\n", EXTRA_8, evictions);
     6b0:	8626                	mv	a2,s1
     6b2:	45a1                	li	a1,8
     6b4:	00001517          	auipc	a0,0x1
     6b8:	3c450513          	addi	a0,a0,964 # 1a78 <malloc+0xa2c>
     6bc:	0d9000ef          	jal	f94 <printf>
    if (s1.pages_swapped_out >= evictions)
     6c0:	f6c42583          	lw	a1,-148(s0)
     6c4:	0935c263          	blt	a1,s3,748 <main+0x748>
        printf("  PASS: pages_swapped_out=%d >= evictions=%d\n",
     6c8:	8626                	mv	a2,s1
     6ca:	00001517          	auipc	a0,0x1
     6ce:	40e50513          	addi	a0,a0,1038 # 1ad8 <malloc+0xa8c>
     6d2:	0c3000ef          	jal	f94 <printf>
    printf("Re-reading all %d pages (checking sentinels)...\n", TOTAL_PAGES_8);
     6d6:	04800593          	li	a1,72
     6da:	00001517          	auipc	a0,0x1
     6de:	45650513          	addi	a0,a0,1110 # 1b30 <malloc+0xae4>
     6e2:	0b3000ef          	jal	f94 <printf>
    int swap_in_before = s1.pages_swapped_in;
     6e6:	f6842b83          	lw	s7,-152(s0)
     6ea:	4485                	li	s1,1
    int errors = 0;
     6ec:	4981                	li	s3,0
            printf("  FAIL: page %d: expected %d got %d\n", i, (int)expected, (int)got);
     6ee:	00001b17          	auipc	s6,0x1
     6f2:	47ab0b13          	addi	s6,s6,1146 # 1b68 <malloc+0xb1c>
    for (int i = 0; i < TOTAL_PAGES_8; i++) {
     6f6:	04900a13          	li	s4,73
     6fa:	a0a5                	j	762 <main+0x762>
        printf("FAIL: total data errors across all passes: %d\n", total_errs);
     6fc:	85ee                	mv	a1,s11
     6fe:	00001517          	auipc	a0,0x1
     702:	19250513          	addi	a0,a0,402 # 1890 <malloc+0x844>
     706:	08f000ef          	jal	f94 <printf>
     70a:	bd75                	j	5c6 <main+0x5c6>
        printf("FAIL: pages_swapped_in == 0 — swap-in not being tracked\n");
     70c:	00001517          	auipc	a0,0x1
     710:	1e450513          	addi	a0,a0,484 # 18f0 <malloc+0x8a4>
     714:	081000ef          	jal	f94 <printf>
     718:	b5f9                	j	5e6 <main+0x5e6>
        printf("FAIL: pages_swapped_out == 0\n");
     71a:	00001517          	auipc	a0,0x1
     71e:	24650513          	addi	a0,a0,582 # 1960 <malloc+0x914>
     722:	073000ef          	jal	f94 <printf>
     726:	bdd1                	j	5fa <main+0x5fa>
    if (mem == (char *)-1) { printf("FAIL: sbrk\n"); return; }
     728:	00001517          	auipc	a0,0x1
     72c:	af050513          	addi	a0,a0,-1296 # 1218 <malloc+0x1cc>
     730:	065000ef          	jal	f94 <printf>
     734:	a8c9                	j	806 <main+0x806>
        printf("  FAIL: expected >= %d evictions, got %d\n", EXTRA_8, evictions);
     736:	8626                	mv	a2,s1
     738:	45a1                	li	a1,8
     73a:	00001517          	auipc	a0,0x1
     73e:	36e50513          	addi	a0,a0,878 # 1aa8 <malloc+0xa5c>
     742:	053000ef          	jal	f94 <printf>
     746:	bfad                	j	6c0 <main+0x6c0>
        printf("  WARN: swapped_out=%d < evictions=%d\n",
     748:	8626                	mv	a2,s1
     74a:	00001517          	auipc	a0,0x1
     74e:	3be50513          	addi	a0,a0,958 # 1b08 <malloc+0xabc>
     752:	043000ef          	jal	f94 <printf>
     756:	b741                	j	6d6 <main+0x6d6>
    for (int i = 0; i < TOTAL_PAGES_8; i++) {
     758:	0485                	addi	s1,s1,1
     75a:	40090913          	addi	s2,s2,1024
     75e:	03448163          	beq	s1,s4,780 <main+0x780>
        char got = mem[i * PAGE_SIZE_8];
     762:	00094683          	lbu	a3,0(s2)
        if (got != expected) {
     766:	0ff4f793          	zext.b	a5,s1
     76a:	fef687e3          	beq	a3,a5,758 <main+0x758>
            printf("  FAIL: page %d: expected %d got %d\n", i, (int)expected, (int)got);
     76e:	0004861b          	sext.w	a2,s1
     772:	fff4859b          	addiw	a1,s1,-1
     776:	855a                	mv	a0,s6
     778:	01d000ef          	jal	f94 <printf>
            errors++;
     77c:	2985                	addiw	s3,s3,1
     77e:	bfe9                	j	758 <main+0x758>
    getvmstats(pid, &s1);
     780:	f6040593          	addi	a1,s0,-160
     784:	8556                	mv	a0,s5
     786:	458000ef          	jal	bde <getvmstats>
    printf("[repl] %s faults=%d evicted=%d sout=%d sin=%d resident=%d\n",
     78a:	f7042803          	lw	a6,-144(s0)
     78e:	f6842783          	lw	a5,-152(s0)
     792:	f6c42703          	lw	a4,-148(s0)
     796:	f6442683          	lw	a3,-156(s0)
     79a:	f6042603          	lw	a2,-160(s0)
     79e:	00001597          	auipc	a1,0x1
     7a2:	3f258593          	addi	a1,a1,1010 # 1b90 <malloc+0xb44>
     7a6:	00001517          	auipc	a0,0x1
     7aa:	29250513          	addi	a0,a0,658 # 1a38 <malloc+0x9ec>
     7ae:	7e6000ef          	jal	f94 <printf>
    int swap_ins = s1.pages_swapped_in - swap_in_before;
     7b2:	f6842583          	lw	a1,-152(s0)
     7b6:	417585bb          	subw	a1,a1,s7
    if (swap_ins > 0)
     7ba:	04b05f63          	blez	a1,818 <main+0x818>
        printf("  PASS: %d swap-ins occurred during re-read\n", swap_ins);
     7be:	00001517          	auipc	a0,0x1
     7c2:	3f250513          	addi	a0,a0,1010 # 1bb0 <malloc+0xb64>
     7c6:	7ce000ef          	jal	f94 <printf>
    if (errors == 0)
     7ca:	04099e63          	bnez	s3,826 <main+0x826>
        printf("  PASS: all %d page sentinels intact (data survives eviction)\n", TOTAL_PAGES_8);
     7ce:	04800593          	li	a1,72
     7d2:	00001517          	auipc	a0,0x1
     7d6:	45650513          	addi	a0,a0,1110 # 1c28 <malloc+0xbdc>
     7da:	7ba000ef          	jal	f94 <printf>
    if (s1.resident_pages <= MAXFRAMES_8)
     7de:	f7042583          	lw	a1,-144(s0)
     7e2:	04000793          	li	a5,64
     7e6:	04b7c863          	blt	a5,a1,836 <main+0x836>
        printf("  PASS: resident_pages=%d <= MAXFRAMES=%d\n",
     7ea:	863e                	mv	a2,a5
     7ec:	00001517          	auipc	a0,0x1
     7f0:	4a450513          	addi	a0,a0,1188 # 1c90 <malloc+0xc44>
     7f4:	7a0000ef          	jal	f94 <printf>
    printf("=== Test 3 done (errors=%d) ===\n", errors);
     7f8:	85ce                	mv	a1,s3
     7fa:	00001517          	auipc	a0,0x1
     7fe:	50650513          	addi	a0,a0,1286 # 1d00 <malloc+0xcb4>
     802:	792000ef          	jal	f94 <printf>
  test_pa4_8();

  printf("\nPA4_B done.\n");
     806:	00001517          	auipc	a0,0x1
     80a:	52250513          	addi	a0,a0,1314 # 1d28 <malloc+0xcdc>
     80e:	786000ef          	jal	f94 <printf>
  exit(0);
     812:	4501                	li	a0,0
     814:	2ea000ef          	jal	afe <exit>
        printf("  WARN: 0 swap-ins – either pages still resident or stat not updated\n");
     818:	00001517          	auipc	a0,0x1
     81c:	3c850513          	addi	a0,a0,968 # 1be0 <malloc+0xb94>
     820:	774000ef          	jal	f94 <printf>
     824:	b75d                	j	7ca <main+0x7ca>
        printf("  FAIL: %d data corruption(s) detected\n", errors);
     826:	85ce                	mv	a1,s3
     828:	00001517          	auipc	a0,0x1
     82c:	44050513          	addi	a0,a0,1088 # 1c68 <malloc+0xc1c>
     830:	764000ef          	jal	f94 <printf>
     834:	b76d                	j	7de <main+0x7de>
        printf("  FAIL: resident_pages=%d > MAXFRAMES=%d (over-committed)\n",
     836:	04000613          	li	a2,64
     83a:	00001517          	auipc	a0,0x1
     83e:	48650513          	addi	a0,a0,1158 # 1cc0 <malloc+0xc74>
     842:	752000ef          	jal	f94 <printf>
     846:	bf4d                	j	7f8 <main+0x7f8>

0000000000000848 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     848:	1141                	addi	sp,sp,-16
     84a:	e406                	sd	ra,8(sp)
     84c:	e022                	sd	s0,0(sp)
     84e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     850:	fb0ff0ef          	jal	0 <main>
  exit(r);
     854:	2aa000ef          	jal	afe <exit>

0000000000000858 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     858:	1141                	addi	sp,sp,-16
     85a:	e406                	sd	ra,8(sp)
     85c:	e022                	sd	s0,0(sp)
     85e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     860:	87aa                	mv	a5,a0
     862:	0585                	addi	a1,a1,1
     864:	0785                	addi	a5,a5,1
     866:	fff5c703          	lbu	a4,-1(a1)
     86a:	fee78fa3          	sb	a4,-1(a5)
     86e:	fb75                	bnez	a4,862 <strcpy+0xa>
    ;
  return os;
}
     870:	60a2                	ld	ra,8(sp)
     872:	6402                	ld	s0,0(sp)
     874:	0141                	addi	sp,sp,16
     876:	8082                	ret

0000000000000878 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     878:	1141                	addi	sp,sp,-16
     87a:	e406                	sd	ra,8(sp)
     87c:	e022                	sd	s0,0(sp)
     87e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     880:	00054783          	lbu	a5,0(a0)
     884:	cb91                	beqz	a5,898 <strcmp+0x20>
     886:	0005c703          	lbu	a4,0(a1)
     88a:	00f71763          	bne	a4,a5,898 <strcmp+0x20>
    p++, q++;
     88e:	0505                	addi	a0,a0,1
     890:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     892:	00054783          	lbu	a5,0(a0)
     896:	fbe5                	bnez	a5,886 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     898:	0005c503          	lbu	a0,0(a1)
}
     89c:	40a7853b          	subw	a0,a5,a0
     8a0:	60a2                	ld	ra,8(sp)
     8a2:	6402                	ld	s0,0(sp)
     8a4:	0141                	addi	sp,sp,16
     8a6:	8082                	ret

00000000000008a8 <strlen>:

uint
strlen(const char *s)
{
     8a8:	1141                	addi	sp,sp,-16
     8aa:	e406                	sd	ra,8(sp)
     8ac:	e022                	sd	s0,0(sp)
     8ae:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     8b0:	00054783          	lbu	a5,0(a0)
     8b4:	cf91                	beqz	a5,8d0 <strlen+0x28>
     8b6:	00150793          	addi	a5,a0,1
     8ba:	86be                	mv	a3,a5
     8bc:	0785                	addi	a5,a5,1
     8be:	fff7c703          	lbu	a4,-1(a5)
     8c2:	ff65                	bnez	a4,8ba <strlen+0x12>
     8c4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     8c8:	60a2                	ld	ra,8(sp)
     8ca:	6402                	ld	s0,0(sp)
     8cc:	0141                	addi	sp,sp,16
     8ce:	8082                	ret
  for(n = 0; s[n]; n++)
     8d0:	4501                	li	a0,0
     8d2:	bfdd                	j	8c8 <strlen+0x20>

00000000000008d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
     8d4:	1141                	addi	sp,sp,-16
     8d6:	e406                	sd	ra,8(sp)
     8d8:	e022                	sd	s0,0(sp)
     8da:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     8dc:	ca19                	beqz	a2,8f2 <memset+0x1e>
     8de:	87aa                	mv	a5,a0
     8e0:	1602                	slli	a2,a2,0x20
     8e2:	9201                	srli	a2,a2,0x20
     8e4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     8e8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     8ec:	0785                	addi	a5,a5,1
     8ee:	fee79de3          	bne	a5,a4,8e8 <memset+0x14>
  }
  return dst;
}
     8f2:	60a2                	ld	ra,8(sp)
     8f4:	6402                	ld	s0,0(sp)
     8f6:	0141                	addi	sp,sp,16
     8f8:	8082                	ret

00000000000008fa <strchr>:

char*
strchr(const char *s, char c)
{
     8fa:	1141                	addi	sp,sp,-16
     8fc:	e406                	sd	ra,8(sp)
     8fe:	e022                	sd	s0,0(sp)
     900:	0800                	addi	s0,sp,16
  for(; *s; s++)
     902:	00054783          	lbu	a5,0(a0)
     906:	cf81                	beqz	a5,91e <strchr+0x24>
    if(*s == c)
     908:	00f58763          	beq	a1,a5,916 <strchr+0x1c>
  for(; *s; s++)
     90c:	0505                	addi	a0,a0,1
     90e:	00054783          	lbu	a5,0(a0)
     912:	fbfd                	bnez	a5,908 <strchr+0xe>
      return (char*)s;
  return 0;
     914:	4501                	li	a0,0
}
     916:	60a2                	ld	ra,8(sp)
     918:	6402                	ld	s0,0(sp)
     91a:	0141                	addi	sp,sp,16
     91c:	8082                	ret
  return 0;
     91e:	4501                	li	a0,0
     920:	bfdd                	j	916 <strchr+0x1c>

0000000000000922 <gets>:

char*
gets(char *buf, int max)
{
     922:	711d                	addi	sp,sp,-96
     924:	ec86                	sd	ra,88(sp)
     926:	e8a2                	sd	s0,80(sp)
     928:	e4a6                	sd	s1,72(sp)
     92a:	e0ca                	sd	s2,64(sp)
     92c:	fc4e                	sd	s3,56(sp)
     92e:	f852                	sd	s4,48(sp)
     930:	f456                	sd	s5,40(sp)
     932:	f05a                	sd	s6,32(sp)
     934:	ec5e                	sd	s7,24(sp)
     936:	e862                	sd	s8,16(sp)
     938:	1080                	addi	s0,sp,96
     93a:	8baa                	mv	s7,a0
     93c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     93e:	892a                	mv	s2,a0
     940:	4481                	li	s1,0
    cc = read(0, &c, 1);
     942:	faf40b13          	addi	s6,s0,-81
     946:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     948:	8c26                	mv	s8,s1
     94a:	0014899b          	addiw	s3,s1,1
     94e:	84ce                	mv	s1,s3
     950:	0349d463          	bge	s3,s4,978 <gets+0x56>
    cc = read(0, &c, 1);
     954:	8656                	mv	a2,s5
     956:	85da                	mv	a1,s6
     958:	4501                	li	a0,0
     95a:	1bc000ef          	jal	b16 <read>
    if(cc < 1)
     95e:	00a05d63          	blez	a0,978 <gets+0x56>
      break;
    buf[i++] = c;
     962:	faf44783          	lbu	a5,-81(s0)
     966:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     96a:	0905                	addi	s2,s2,1
     96c:	ff678713          	addi	a4,a5,-10
     970:	c319                	beqz	a4,976 <gets+0x54>
     972:	17cd                	addi	a5,a5,-13
     974:	fbf1                	bnez	a5,948 <gets+0x26>
    buf[i++] = c;
     976:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     978:	9c5e                	add	s8,s8,s7
     97a:	000c0023          	sb	zero,0(s8)
  return buf;
}
     97e:	855e                	mv	a0,s7
     980:	60e6                	ld	ra,88(sp)
     982:	6446                	ld	s0,80(sp)
     984:	64a6                	ld	s1,72(sp)
     986:	6906                	ld	s2,64(sp)
     988:	79e2                	ld	s3,56(sp)
     98a:	7a42                	ld	s4,48(sp)
     98c:	7aa2                	ld	s5,40(sp)
     98e:	7b02                	ld	s6,32(sp)
     990:	6be2                	ld	s7,24(sp)
     992:	6c42                	ld	s8,16(sp)
     994:	6125                	addi	sp,sp,96
     996:	8082                	ret

0000000000000998 <stat>:

int
stat(const char *n, struct stat *st)
{
     998:	1101                	addi	sp,sp,-32
     99a:	ec06                	sd	ra,24(sp)
     99c:	e822                	sd	s0,16(sp)
     99e:	e04a                	sd	s2,0(sp)
     9a0:	1000                	addi	s0,sp,32
     9a2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     9a4:	4581                	li	a1,0
     9a6:	198000ef          	jal	b3e <open>
  if(fd < 0)
     9aa:	02054263          	bltz	a0,9ce <stat+0x36>
     9ae:	e426                	sd	s1,8(sp)
     9b0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     9b2:	85ca                	mv	a1,s2
     9b4:	1a2000ef          	jal	b56 <fstat>
     9b8:	892a                	mv	s2,a0
  close(fd);
     9ba:	8526                	mv	a0,s1
     9bc:	16a000ef          	jal	b26 <close>
  return r;
     9c0:	64a2                	ld	s1,8(sp)
}
     9c2:	854a                	mv	a0,s2
     9c4:	60e2                	ld	ra,24(sp)
     9c6:	6442                	ld	s0,16(sp)
     9c8:	6902                	ld	s2,0(sp)
     9ca:	6105                	addi	sp,sp,32
     9cc:	8082                	ret
    return -1;
     9ce:	57fd                	li	a5,-1
     9d0:	893e                	mv	s2,a5
     9d2:	bfc5                	j	9c2 <stat+0x2a>

00000000000009d4 <atoi>:

int
atoi(const char *s)
{
     9d4:	1141                	addi	sp,sp,-16
     9d6:	e406                	sd	ra,8(sp)
     9d8:	e022                	sd	s0,0(sp)
     9da:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     9dc:	00054683          	lbu	a3,0(a0)
     9e0:	fd06879b          	addiw	a5,a3,-48 # 9fd0 <base+0x7fc0>
     9e4:	0ff7f793          	zext.b	a5,a5
     9e8:	4625                	li	a2,9
     9ea:	02f66963          	bltu	a2,a5,a1c <atoi+0x48>
     9ee:	872a                	mv	a4,a0
  n = 0;
     9f0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     9f2:	0705                	addi	a4,a4,1
     9f4:	0025179b          	slliw	a5,a0,0x2
     9f8:	9fa9                	addw	a5,a5,a0
     9fa:	0017979b          	slliw	a5,a5,0x1
     9fe:	9fb5                	addw	a5,a5,a3
     a00:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a04:	00074683          	lbu	a3,0(a4)
     a08:	fd06879b          	addiw	a5,a3,-48
     a0c:	0ff7f793          	zext.b	a5,a5
     a10:	fef671e3          	bgeu	a2,a5,9f2 <atoi+0x1e>
  return n;
}
     a14:	60a2                	ld	ra,8(sp)
     a16:	6402                	ld	s0,0(sp)
     a18:	0141                	addi	sp,sp,16
     a1a:	8082                	ret
  n = 0;
     a1c:	4501                	li	a0,0
     a1e:	bfdd                	j	a14 <atoi+0x40>

0000000000000a20 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a20:	1141                	addi	sp,sp,-16
     a22:	e406                	sd	ra,8(sp)
     a24:	e022                	sd	s0,0(sp)
     a26:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     a28:	02b57563          	bgeu	a0,a1,a52 <memmove+0x32>
    while(n-- > 0)
     a2c:	00c05f63          	blez	a2,a4a <memmove+0x2a>
     a30:	1602                	slli	a2,a2,0x20
     a32:	9201                	srli	a2,a2,0x20
     a34:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     a38:	872a                	mv	a4,a0
      *dst++ = *src++;
     a3a:	0585                	addi	a1,a1,1
     a3c:	0705                	addi	a4,a4,1
     a3e:	fff5c683          	lbu	a3,-1(a1)
     a42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     a46:	fee79ae3          	bne	a5,a4,a3a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     a4a:	60a2                	ld	ra,8(sp)
     a4c:	6402                	ld	s0,0(sp)
     a4e:	0141                	addi	sp,sp,16
     a50:	8082                	ret
    while(n-- > 0)
     a52:	fec05ce3          	blez	a2,a4a <memmove+0x2a>
    dst += n;
     a56:	00c50733          	add	a4,a0,a2
    src += n;
     a5a:	95b2                	add	a1,a1,a2
     a5c:	fff6079b          	addiw	a5,a2,-1 # fff <free+0x39>
     a60:	1782                	slli	a5,a5,0x20
     a62:	9381                	srli	a5,a5,0x20
     a64:	fff7c793          	not	a5,a5
     a68:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     a6a:	15fd                	addi	a1,a1,-1
     a6c:	177d                	addi	a4,a4,-1
     a6e:	0005c683          	lbu	a3,0(a1)
     a72:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     a76:	fef71ae3          	bne	a4,a5,a6a <memmove+0x4a>
     a7a:	bfc1                	j	a4a <memmove+0x2a>

0000000000000a7c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     a7c:	1141                	addi	sp,sp,-16
     a7e:	e406                	sd	ra,8(sp)
     a80:	e022                	sd	s0,0(sp)
     a82:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     a84:	c61d                	beqz	a2,ab2 <memcmp+0x36>
     a86:	1602                	slli	a2,a2,0x20
     a88:	9201                	srli	a2,a2,0x20
     a8a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     a8e:	00054783          	lbu	a5,0(a0)
     a92:	0005c703          	lbu	a4,0(a1)
     a96:	00e79863          	bne	a5,a4,aa6 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     a9a:	0505                	addi	a0,a0,1
    p2++;
     a9c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     a9e:	fed518e3          	bne	a0,a3,a8e <memcmp+0x12>
  }
  return 0;
     aa2:	4501                	li	a0,0
     aa4:	a019                	j	aaa <memcmp+0x2e>
      return *p1 - *p2;
     aa6:	40e7853b          	subw	a0,a5,a4
}
     aaa:	60a2                	ld	ra,8(sp)
     aac:	6402                	ld	s0,0(sp)
     aae:	0141                	addi	sp,sp,16
     ab0:	8082                	ret
  return 0;
     ab2:	4501                	li	a0,0
     ab4:	bfdd                	j	aaa <memcmp+0x2e>

0000000000000ab6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     ab6:	1141                	addi	sp,sp,-16
     ab8:	e406                	sd	ra,8(sp)
     aba:	e022                	sd	s0,0(sp)
     abc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     abe:	f63ff0ef          	jal	a20 <memmove>
}
     ac2:	60a2                	ld	ra,8(sp)
     ac4:	6402                	ld	s0,0(sp)
     ac6:	0141                	addi	sp,sp,16
     ac8:	8082                	ret

0000000000000aca <sbrk>:

char *
sbrk(int n) {
     aca:	1141                	addi	sp,sp,-16
     acc:	e406                	sd	ra,8(sp)
     ace:	e022                	sd	s0,0(sp)
     ad0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     ad2:	4585                	li	a1,1
     ad4:	0b2000ef          	jal	b86 <sys_sbrk>
}
     ad8:	60a2                	ld	ra,8(sp)
     ada:	6402                	ld	s0,0(sp)
     adc:	0141                	addi	sp,sp,16
     ade:	8082                	ret

0000000000000ae0 <sbrklazy>:

char *
sbrklazy(int n) {
     ae0:	1141                	addi	sp,sp,-16
     ae2:	e406                	sd	ra,8(sp)
     ae4:	e022                	sd	s0,0(sp)
     ae6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     ae8:	4589                	li	a1,2
     aea:	09c000ef          	jal	b86 <sys_sbrk>
}
     aee:	60a2                	ld	ra,8(sp)
     af0:	6402                	ld	s0,0(sp)
     af2:	0141                	addi	sp,sp,16
     af4:	8082                	ret

0000000000000af6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     af6:	4885                	li	a7,1
 ecall
     af8:	00000073          	ecall
 ret
     afc:	8082                	ret

0000000000000afe <exit>:
.global exit
exit:
 li a7, SYS_exit
     afe:	4889                	li	a7,2
 ecall
     b00:	00000073          	ecall
 ret
     b04:	8082                	ret

0000000000000b06 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b06:	488d                	li	a7,3
 ecall
     b08:	00000073          	ecall
 ret
     b0c:	8082                	ret

0000000000000b0e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b0e:	4891                	li	a7,4
 ecall
     b10:	00000073          	ecall
 ret
     b14:	8082                	ret

0000000000000b16 <read>:
.global read
read:
 li a7, SYS_read
     b16:	4895                	li	a7,5
 ecall
     b18:	00000073          	ecall
 ret
     b1c:	8082                	ret

0000000000000b1e <write>:
.global write
write:
 li a7, SYS_write
     b1e:	48c1                	li	a7,16
 ecall
     b20:	00000073          	ecall
 ret
     b24:	8082                	ret

0000000000000b26 <close>:
.global close
close:
 li a7, SYS_close
     b26:	48d5                	li	a7,21
 ecall
     b28:	00000073          	ecall
 ret
     b2c:	8082                	ret

0000000000000b2e <kill>:
.global kill
kill:
 li a7, SYS_kill
     b2e:	4899                	li	a7,6
 ecall
     b30:	00000073          	ecall
 ret
     b34:	8082                	ret

0000000000000b36 <exec>:
.global exec
exec:
 li a7, SYS_exec
     b36:	489d                	li	a7,7
 ecall
     b38:	00000073          	ecall
 ret
     b3c:	8082                	ret

0000000000000b3e <open>:
.global open
open:
 li a7, SYS_open
     b3e:	48bd                	li	a7,15
 ecall
     b40:	00000073          	ecall
 ret
     b44:	8082                	ret

0000000000000b46 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b46:	48c5                	li	a7,17
 ecall
     b48:	00000073          	ecall
 ret
     b4c:	8082                	ret

0000000000000b4e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b4e:	48c9                	li	a7,18
 ecall
     b50:	00000073          	ecall
 ret
     b54:	8082                	ret

0000000000000b56 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b56:	48a1                	li	a7,8
 ecall
     b58:	00000073          	ecall
 ret
     b5c:	8082                	ret

0000000000000b5e <link>:
.global link
link:
 li a7, SYS_link
     b5e:	48cd                	li	a7,19
 ecall
     b60:	00000073          	ecall
 ret
     b64:	8082                	ret

0000000000000b66 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b66:	48d1                	li	a7,20
 ecall
     b68:	00000073          	ecall
 ret
     b6c:	8082                	ret

0000000000000b6e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     b6e:	48a5                	li	a7,9
 ecall
     b70:	00000073          	ecall
 ret
     b74:	8082                	ret

0000000000000b76 <dup>:
.global dup
dup:
 li a7, SYS_dup
     b76:	48a9                	li	a7,10
 ecall
     b78:	00000073          	ecall
 ret
     b7c:	8082                	ret

0000000000000b7e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b7e:	48ad                	li	a7,11
 ecall
     b80:	00000073          	ecall
 ret
     b84:	8082                	ret

0000000000000b86 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     b86:	48b1                	li	a7,12
 ecall
     b88:	00000073          	ecall
 ret
     b8c:	8082                	ret

0000000000000b8e <pause>:
.global pause
pause:
 li a7, SYS_pause
     b8e:	48b5                	li	a7,13
 ecall
     b90:	00000073          	ecall
 ret
     b94:	8082                	ret

0000000000000b96 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     b96:	48b9                	li	a7,14
 ecall
     b98:	00000073          	ecall
 ret
     b9c:	8082                	ret

0000000000000b9e <hello>:
.global hello
hello:
 li a7, SYS_hello
     b9e:	48d9                	li	a7,22
 ecall
     ba0:	00000073          	ecall
 ret
     ba4:	8082                	ret

0000000000000ba6 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
     ba6:	48dd                	li	a7,23
 ecall
     ba8:	00000073          	ecall
 ret
     bac:	8082                	ret

0000000000000bae <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
     bae:	48e1                	li	a7,24
 ecall
     bb0:	00000073          	ecall
 ret
     bb4:	8082                	ret

0000000000000bb6 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
     bb6:	48e5                	li	a7,25
 ecall
     bb8:	00000073          	ecall
 ret
     bbc:	8082                	ret

0000000000000bbe <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
     bbe:	48e9                	li	a7,26
 ecall
     bc0:	00000073          	ecall
 ret
     bc4:	8082                	ret

0000000000000bc6 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
     bc6:	48ed                	li	a7,27
 ecall
     bc8:	00000073          	ecall
 ret
     bcc:	8082                	ret

0000000000000bce <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
     bce:	48f1                	li	a7,28
 ecall
     bd0:	00000073          	ecall
 ret
     bd4:	8082                	ret

0000000000000bd6 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
     bd6:	48f5                	li	a7,29
 ecall
     bd8:	00000073          	ecall
 ret
     bdc:	8082                	ret

0000000000000bde <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
     bde:	48f9                	li	a7,30
 ecall
     be0:	00000073          	ecall
 ret
     be4:	8082                	ret

0000000000000be6 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
     be6:	48fd                	li	a7,31
 ecall
     be8:	00000073          	ecall
 ret
     bec:	8082                	ret

0000000000000bee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     bee:	1101                	addi	sp,sp,-32
     bf0:	ec06                	sd	ra,24(sp)
     bf2:	e822                	sd	s0,16(sp)
     bf4:	1000                	addi	s0,sp,32
     bf6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bfa:	4605                	li	a2,1
     bfc:	fef40593          	addi	a1,s0,-17
     c00:	f1fff0ef          	jal	b1e <write>
}
     c04:	60e2                	ld	ra,24(sp)
     c06:	6442                	ld	s0,16(sp)
     c08:	6105                	addi	sp,sp,32
     c0a:	8082                	ret

0000000000000c0c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     c0c:	715d                	addi	sp,sp,-80
     c0e:	e486                	sd	ra,72(sp)
     c10:	e0a2                	sd	s0,64(sp)
     c12:	f84a                	sd	s2,48(sp)
     c14:	f44e                	sd	s3,40(sp)
     c16:	0880                	addi	s0,sp,80
     c18:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     c1a:	c6d1                	beqz	a3,ca6 <printint+0x9a>
     c1c:	0805d563          	bgez	a1,ca6 <printint+0x9a>
    neg = 1;
    x = -xx;
     c20:	40b005b3          	neg	a1,a1
    neg = 1;
     c24:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     c26:	fb840993          	addi	s3,s0,-72
  neg = 0;
     c2a:	86ce                	mv	a3,s3
  i = 0;
     c2c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c2e:	00001817          	auipc	a6,0x1
     c32:	11280813          	addi	a6,a6,274 # 1d40 <digits>
     c36:	88ba                	mv	a7,a4
     c38:	0017051b          	addiw	a0,a4,1
     c3c:	872a                	mv	a4,a0
     c3e:	02c5f7b3          	remu	a5,a1,a2
     c42:	97c2                	add	a5,a5,a6
     c44:	0007c783          	lbu	a5,0(a5)
     c48:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c4c:	87ae                	mv	a5,a1
     c4e:	02c5d5b3          	divu	a1,a1,a2
     c52:	0685                	addi	a3,a3,1
     c54:	fec7f1e3          	bgeu	a5,a2,c36 <printint+0x2a>
  if(neg)
     c58:	00030c63          	beqz	t1,c70 <printint+0x64>
    buf[i++] = '-';
     c5c:	fd050793          	addi	a5,a0,-48
     c60:	00878533          	add	a0,a5,s0
     c64:	02d00793          	li	a5,45
     c68:	fef50423          	sb	a5,-24(a0)
     c6c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     c70:	02e05563          	blez	a4,c9a <printint+0x8e>
     c74:	fc26                	sd	s1,56(sp)
     c76:	377d                	addiw	a4,a4,-1
     c78:	00e984b3          	add	s1,s3,a4
     c7c:	19fd                	addi	s3,s3,-1
     c7e:	99ba                	add	s3,s3,a4
     c80:	1702                	slli	a4,a4,0x20
     c82:	9301                	srli	a4,a4,0x20
     c84:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c88:	0004c583          	lbu	a1,0(s1)
     c8c:	854a                	mv	a0,s2
     c8e:	f61ff0ef          	jal	bee <putc>
  while(--i >= 0)
     c92:	14fd                	addi	s1,s1,-1
     c94:	ff349ae3          	bne	s1,s3,c88 <printint+0x7c>
     c98:	74e2                	ld	s1,56(sp)
}
     c9a:	60a6                	ld	ra,72(sp)
     c9c:	6406                	ld	s0,64(sp)
     c9e:	7942                	ld	s2,48(sp)
     ca0:	79a2                	ld	s3,40(sp)
     ca2:	6161                	addi	sp,sp,80
     ca4:	8082                	ret
  neg = 0;
     ca6:	4301                	li	t1,0
     ca8:	bfbd                	j	c26 <printint+0x1a>

0000000000000caa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     caa:	711d                	addi	sp,sp,-96
     cac:	ec86                	sd	ra,88(sp)
     cae:	e8a2                	sd	s0,80(sp)
     cb0:	e4a6                	sd	s1,72(sp)
     cb2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cb4:	0005c483          	lbu	s1,0(a1)
     cb8:	22048363          	beqz	s1,ede <vprintf+0x234>
     cbc:	e0ca                	sd	s2,64(sp)
     cbe:	fc4e                	sd	s3,56(sp)
     cc0:	f852                	sd	s4,48(sp)
     cc2:	f456                	sd	s5,40(sp)
     cc4:	f05a                	sd	s6,32(sp)
     cc6:	ec5e                	sd	s7,24(sp)
     cc8:	e862                	sd	s8,16(sp)
     cca:	8b2a                	mv	s6,a0
     ccc:	8a2e                	mv	s4,a1
     cce:	8bb2                	mv	s7,a2
  state = 0;
     cd0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     cd2:	4901                	li	s2,0
     cd4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     cd6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     cda:	06400c13          	li	s8,100
     cde:	a00d                	j	d00 <vprintf+0x56>
        putc(fd, c0);
     ce0:	85a6                	mv	a1,s1
     ce2:	855a                	mv	a0,s6
     ce4:	f0bff0ef          	jal	bee <putc>
     ce8:	a019                	j	cee <vprintf+0x44>
    } else if(state == '%'){
     cea:	03598363          	beq	s3,s5,d10 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     cee:	0019079b          	addiw	a5,s2,1
     cf2:	893e                	mv	s2,a5
     cf4:	873e                	mv	a4,a5
     cf6:	97d2                	add	a5,a5,s4
     cf8:	0007c483          	lbu	s1,0(a5)
     cfc:	1c048a63          	beqz	s1,ed0 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
     d00:	0004879b          	sext.w	a5,s1
    if(state == 0){
     d04:	fe0993e3          	bnez	s3,cea <vprintf+0x40>
      if(c0 == '%'){
     d08:	fd579ce3          	bne	a5,s5,ce0 <vprintf+0x36>
        state = '%';
     d0c:	89be                	mv	s3,a5
     d0e:	b7c5                	j	cee <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     d10:	00ea06b3          	add	a3,s4,a4
     d14:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     d18:	1c060863          	beqz	a2,ee8 <vprintf+0x23e>
      if(c0 == 'd'){
     d1c:	03878763          	beq	a5,s8,d4a <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d20:	f9478693          	addi	a3,a5,-108
     d24:	0016b693          	seqz	a3,a3
     d28:	f9c60593          	addi	a1,a2,-100
     d2c:	e99d                	bnez	a1,d62 <vprintf+0xb8>
     d2e:	ca95                	beqz	a3,d62 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     d30:	008b8493          	addi	s1,s7,8
     d34:	4685                	li	a3,1
     d36:	4629                	li	a2,10
     d38:	000bb583          	ld	a1,0(s7)
     d3c:	855a                	mv	a0,s6
     d3e:	ecfff0ef          	jal	c0c <printint>
        i += 1;
     d42:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     d44:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     d46:	4981                	li	s3,0
     d48:	b75d                	j	cee <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     d4a:	008b8493          	addi	s1,s7,8
     d4e:	4685                	li	a3,1
     d50:	4629                	li	a2,10
     d52:	000ba583          	lw	a1,0(s7)
     d56:	855a                	mv	a0,s6
     d58:	eb5ff0ef          	jal	c0c <printint>
     d5c:	8ba6                	mv	s7,s1
      state = 0;
     d5e:	4981                	li	s3,0
     d60:	b779                	j	cee <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     d62:	9752                	add	a4,a4,s4
     d64:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     d68:	f9460713          	addi	a4,a2,-108
     d6c:	00173713          	seqz	a4,a4
     d70:	8f75                	and	a4,a4,a3
     d72:	f9c58513          	addi	a0,a1,-100
     d76:	18051363          	bnez	a0,efc <vprintf+0x252>
     d7a:	18070163          	beqz	a4,efc <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
     d7e:	008b8493          	addi	s1,s7,8
     d82:	4685                	li	a3,1
     d84:	4629                	li	a2,10
     d86:	000bb583          	ld	a1,0(s7)
     d8a:	855a                	mv	a0,s6
     d8c:	e81ff0ef          	jal	c0c <printint>
        i += 2;
     d90:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     d92:	8ba6                	mv	s7,s1
      state = 0;
     d94:	4981                	li	s3,0
        i += 2;
     d96:	bfa1                	j	cee <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     d98:	008b8493          	addi	s1,s7,8
     d9c:	4681                	li	a3,0
     d9e:	4629                	li	a2,10
     da0:	000be583          	lwu	a1,0(s7)
     da4:	855a                	mv	a0,s6
     da6:	e67ff0ef          	jal	c0c <printint>
     daa:	8ba6                	mv	s7,s1
      state = 0;
     dac:	4981                	li	s3,0
     dae:	b781                	j	cee <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     db0:	008b8493          	addi	s1,s7,8
     db4:	4681                	li	a3,0
     db6:	4629                	li	a2,10
     db8:	000bb583          	ld	a1,0(s7)
     dbc:	855a                	mv	a0,s6
     dbe:	e4fff0ef          	jal	c0c <printint>
        i += 1;
     dc2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     dc4:	8ba6                	mv	s7,s1
      state = 0;
     dc6:	4981                	li	s3,0
     dc8:	b71d                	j	cee <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     dca:	008b8493          	addi	s1,s7,8
     dce:	4681                	li	a3,0
     dd0:	4629                	li	a2,10
     dd2:	000bb583          	ld	a1,0(s7)
     dd6:	855a                	mv	a0,s6
     dd8:	e35ff0ef          	jal	c0c <printint>
        i += 2;
     ddc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     dde:	8ba6                	mv	s7,s1
      state = 0;
     de0:	4981                	li	s3,0
        i += 2;
     de2:	b731                	j	cee <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     de4:	008b8493          	addi	s1,s7,8
     de8:	4681                	li	a3,0
     dea:	4641                	li	a2,16
     dec:	000be583          	lwu	a1,0(s7)
     df0:	855a                	mv	a0,s6
     df2:	e1bff0ef          	jal	c0c <printint>
     df6:	8ba6                	mv	s7,s1
      state = 0;
     df8:	4981                	li	s3,0
     dfa:	bdd5                	j	cee <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     dfc:	008b8493          	addi	s1,s7,8
     e00:	4681                	li	a3,0
     e02:	4641                	li	a2,16
     e04:	000bb583          	ld	a1,0(s7)
     e08:	855a                	mv	a0,s6
     e0a:	e03ff0ef          	jal	c0c <printint>
        i += 1;
     e0e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     e10:	8ba6                	mv	s7,s1
      state = 0;
     e12:	4981                	li	s3,0
     e14:	bde9                	j	cee <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e16:	008b8493          	addi	s1,s7,8
     e1a:	4681                	li	a3,0
     e1c:	4641                	li	a2,16
     e1e:	000bb583          	ld	a1,0(s7)
     e22:	855a                	mv	a0,s6
     e24:	de9ff0ef          	jal	c0c <printint>
        i += 2;
     e28:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e2a:	8ba6                	mv	s7,s1
      state = 0;
     e2c:	4981                	li	s3,0
        i += 2;
     e2e:	b5c1                	j	cee <vprintf+0x44>
     e30:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     e32:	008b8793          	addi	a5,s7,8
     e36:	8cbe                	mv	s9,a5
     e38:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     e3c:	03000593          	li	a1,48
     e40:	855a                	mv	a0,s6
     e42:	dadff0ef          	jal	bee <putc>
  putc(fd, 'x');
     e46:	07800593          	li	a1,120
     e4a:	855a                	mv	a0,s6
     e4c:	da3ff0ef          	jal	bee <putc>
     e50:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e52:	00001b97          	auipc	s7,0x1
     e56:	eeeb8b93          	addi	s7,s7,-274 # 1d40 <digits>
     e5a:	03c9d793          	srli	a5,s3,0x3c
     e5e:	97de                	add	a5,a5,s7
     e60:	0007c583          	lbu	a1,0(a5)
     e64:	855a                	mv	a0,s6
     e66:	d89ff0ef          	jal	bee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e6a:	0992                	slli	s3,s3,0x4
     e6c:	34fd                	addiw	s1,s1,-1
     e6e:	f4f5                	bnez	s1,e5a <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     e70:	8be6                	mv	s7,s9
      state = 0;
     e72:	4981                	li	s3,0
     e74:	6ca2                	ld	s9,8(sp)
     e76:	bda5                	j	cee <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
     e78:	008b8493          	addi	s1,s7,8
     e7c:	000bc583          	lbu	a1,0(s7)
     e80:	855a                	mv	a0,s6
     e82:	d6dff0ef          	jal	bee <putc>
     e86:	8ba6                	mv	s7,s1
      state = 0;
     e88:	4981                	li	s3,0
     e8a:	b595                	j	cee <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     e8c:	008b8993          	addi	s3,s7,8
     e90:	000bb483          	ld	s1,0(s7)
     e94:	cc91                	beqz	s1,eb0 <vprintf+0x206>
        for(; *s; s++)
     e96:	0004c583          	lbu	a1,0(s1)
     e9a:	c985                	beqz	a1,eca <vprintf+0x220>
          putc(fd, *s);
     e9c:	855a                	mv	a0,s6
     e9e:	d51ff0ef          	jal	bee <putc>
        for(; *s; s++)
     ea2:	0485                	addi	s1,s1,1
     ea4:	0004c583          	lbu	a1,0(s1)
     ea8:	f9f5                	bnez	a1,e9c <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
     eaa:	8bce                	mv	s7,s3
      state = 0;
     eac:	4981                	li	s3,0
     eae:	b581                	j	cee <vprintf+0x44>
          s = "(null)";
     eb0:	00001497          	auipc	s1,0x1
     eb4:	e8848493          	addi	s1,s1,-376 # 1d38 <malloc+0xcec>
        for(; *s; s++)
     eb8:	02800593          	li	a1,40
     ebc:	b7c5                	j	e9c <vprintf+0x1f2>
        putc(fd, '%');
     ebe:	85be                	mv	a1,a5
     ec0:	855a                	mv	a0,s6
     ec2:	d2dff0ef          	jal	bee <putc>
      state = 0;
     ec6:	4981                	li	s3,0
     ec8:	b51d                	j	cee <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     eca:	8bce                	mv	s7,s3
      state = 0;
     ecc:	4981                	li	s3,0
     ece:	b505                	j	cee <vprintf+0x44>
     ed0:	6906                	ld	s2,64(sp)
     ed2:	79e2                	ld	s3,56(sp)
     ed4:	7a42                	ld	s4,48(sp)
     ed6:	7aa2                	ld	s5,40(sp)
     ed8:	7b02                	ld	s6,32(sp)
     eda:	6be2                	ld	s7,24(sp)
     edc:	6c42                	ld	s8,16(sp)
    }
  }
}
     ede:	60e6                	ld	ra,88(sp)
     ee0:	6446                	ld	s0,80(sp)
     ee2:	64a6                	ld	s1,72(sp)
     ee4:	6125                	addi	sp,sp,96
     ee6:	8082                	ret
      if(c0 == 'd'){
     ee8:	06400713          	li	a4,100
     eec:	e4e78fe3          	beq	a5,a4,d4a <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
     ef0:	f9478693          	addi	a3,a5,-108
     ef4:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
     ef8:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     efa:	4701                	li	a4,0
      } else if(c0 == 'u'){
     efc:	07500513          	li	a0,117
     f00:	e8a78ce3          	beq	a5,a0,d98 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
     f04:	f8b60513          	addi	a0,a2,-117
     f08:	e119                	bnez	a0,f0e <vprintf+0x264>
     f0a:	ea0693e3          	bnez	a3,db0 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     f0e:	f8b58513          	addi	a0,a1,-117
     f12:	e119                	bnez	a0,f18 <vprintf+0x26e>
     f14:	ea071be3          	bnez	a4,dca <vprintf+0x120>
      } else if(c0 == 'x'){
     f18:	07800513          	li	a0,120
     f1c:	eca784e3          	beq	a5,a0,de4 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
     f20:	f8860613          	addi	a2,a2,-120
     f24:	e219                	bnez	a2,f2a <vprintf+0x280>
     f26:	ec069be3          	bnez	a3,dfc <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     f2a:	f8858593          	addi	a1,a1,-120
     f2e:	e199                	bnez	a1,f34 <vprintf+0x28a>
     f30:	ee0713e3          	bnez	a4,e16 <vprintf+0x16c>
      } else if(c0 == 'p'){
     f34:	07000713          	li	a4,112
     f38:	eee78ce3          	beq	a5,a4,e30 <vprintf+0x186>
      } else if(c0 == 'c'){
     f3c:	06300713          	li	a4,99
     f40:	f2e78ce3          	beq	a5,a4,e78 <vprintf+0x1ce>
      } else if(c0 == 's'){
     f44:	07300713          	li	a4,115
     f48:	f4e782e3          	beq	a5,a4,e8c <vprintf+0x1e2>
      } else if(c0 == '%'){
     f4c:	02500713          	li	a4,37
     f50:	f6e787e3          	beq	a5,a4,ebe <vprintf+0x214>
        putc(fd, '%');
     f54:	02500593          	li	a1,37
     f58:	855a                	mv	a0,s6
     f5a:	c95ff0ef          	jal	bee <putc>
        putc(fd, c0);
     f5e:	85a6                	mv	a1,s1
     f60:	855a                	mv	a0,s6
     f62:	c8dff0ef          	jal	bee <putc>
      state = 0;
     f66:	4981                	li	s3,0
     f68:	b359                	j	cee <vprintf+0x44>

0000000000000f6a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f6a:	715d                	addi	sp,sp,-80
     f6c:	ec06                	sd	ra,24(sp)
     f6e:	e822                	sd	s0,16(sp)
     f70:	1000                	addi	s0,sp,32
     f72:	e010                	sd	a2,0(s0)
     f74:	e414                	sd	a3,8(s0)
     f76:	e818                	sd	a4,16(s0)
     f78:	ec1c                	sd	a5,24(s0)
     f7a:	03043023          	sd	a6,32(s0)
     f7e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f82:	8622                	mv	a2,s0
     f84:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f88:	d23ff0ef          	jal	caa <vprintf>
}
     f8c:	60e2                	ld	ra,24(sp)
     f8e:	6442                	ld	s0,16(sp)
     f90:	6161                	addi	sp,sp,80
     f92:	8082                	ret

0000000000000f94 <printf>:

void
printf(const char *fmt, ...)
{
     f94:	711d                	addi	sp,sp,-96
     f96:	ec06                	sd	ra,24(sp)
     f98:	e822                	sd	s0,16(sp)
     f9a:	1000                	addi	s0,sp,32
     f9c:	e40c                	sd	a1,8(s0)
     f9e:	e810                	sd	a2,16(s0)
     fa0:	ec14                	sd	a3,24(s0)
     fa2:	f018                	sd	a4,32(s0)
     fa4:	f41c                	sd	a5,40(s0)
     fa6:	03043823          	sd	a6,48(s0)
     faa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     fae:	00840613          	addi	a2,s0,8
     fb2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     fb6:	85aa                	mv	a1,a0
     fb8:	4505                	li	a0,1
     fba:	cf1ff0ef          	jal	caa <vprintf>
}
     fbe:	60e2                	ld	ra,24(sp)
     fc0:	6442                	ld	s0,16(sp)
     fc2:	6125                	addi	sp,sp,96
     fc4:	8082                	ret

0000000000000fc6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     fc6:	1141                	addi	sp,sp,-16
     fc8:	e406                	sd	ra,8(sp)
     fca:	e022                	sd	s0,0(sp)
     fcc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     fce:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     fd2:	00001797          	auipc	a5,0x1
     fd6:	02e7b783          	ld	a5,46(a5) # 2000 <freep>
     fda:	a039                	j	fe8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fdc:	6398                	ld	a4,0(a5)
     fde:	00e7e463          	bltu	a5,a4,fe6 <free+0x20>
     fe2:	00e6ea63          	bltu	a3,a4,ff6 <free+0x30>
{
     fe6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     fe8:	fed7fae3          	bgeu	a5,a3,fdc <free+0x16>
     fec:	6398                	ld	a4,0(a5)
     fee:	00e6e463          	bltu	a3,a4,ff6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ff2:	fee7eae3          	bltu	a5,a4,fe6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
     ff6:	ff852583          	lw	a1,-8(a0)
     ffa:	6390                	ld	a2,0(a5)
     ffc:	02059813          	slli	a6,a1,0x20
    1000:	01c85713          	srli	a4,a6,0x1c
    1004:	9736                	add	a4,a4,a3
    1006:	02e60563          	beq	a2,a4,1030 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    100a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    100e:	4790                	lw	a2,8(a5)
    1010:	02061593          	slli	a1,a2,0x20
    1014:	01c5d713          	srli	a4,a1,0x1c
    1018:	973e                	add	a4,a4,a5
    101a:	02e68263          	beq	a3,a4,103e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    101e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1020:	00001717          	auipc	a4,0x1
    1024:	fef73023          	sd	a5,-32(a4) # 2000 <freep>
}
    1028:	60a2                	ld	ra,8(sp)
    102a:	6402                	ld	s0,0(sp)
    102c:	0141                	addi	sp,sp,16
    102e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    1030:	4618                	lw	a4,8(a2)
    1032:	9f2d                	addw	a4,a4,a1
    1034:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1038:	6398                	ld	a4,0(a5)
    103a:	6310                	ld	a2,0(a4)
    103c:	b7f9                	j	100a <free+0x44>
    p->s.size += bp->s.size;
    103e:	ff852703          	lw	a4,-8(a0)
    1042:	9f31                	addw	a4,a4,a2
    1044:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1046:	ff053683          	ld	a3,-16(a0)
    104a:	bfd1                	j	101e <free+0x58>

000000000000104c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    104c:	7139                	addi	sp,sp,-64
    104e:	fc06                	sd	ra,56(sp)
    1050:	f822                	sd	s0,48(sp)
    1052:	f04a                	sd	s2,32(sp)
    1054:	ec4e                	sd	s3,24(sp)
    1056:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1058:	02051993          	slli	s3,a0,0x20
    105c:	0209d993          	srli	s3,s3,0x20
    1060:	09bd                	addi	s3,s3,15
    1062:	0049d993          	srli	s3,s3,0x4
    1066:	2985                	addiw	s3,s3,1
    1068:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    106a:	00001517          	auipc	a0,0x1
    106e:	f9653503          	ld	a0,-106(a0) # 2000 <freep>
    1072:	c905                	beqz	a0,10a2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1074:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1076:	4798                	lw	a4,8(a5)
    1078:	09377663          	bgeu	a4,s3,1104 <malloc+0xb8>
    107c:	f426                	sd	s1,40(sp)
    107e:	e852                	sd	s4,16(sp)
    1080:	e456                	sd	s5,8(sp)
    1082:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1084:	8a4e                	mv	s4,s3
    1086:	6705                	lui	a4,0x1
    1088:	00e9f363          	bgeu	s3,a4,108e <malloc+0x42>
    108c:	6a05                	lui	s4,0x1
    108e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1092:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1096:	00001497          	auipc	s1,0x1
    109a:	f6a48493          	addi	s1,s1,-150 # 2000 <freep>
  if(p == SBRK_ERROR)
    109e:	5afd                	li	s5,-1
    10a0:	a83d                	j	10de <malloc+0x92>
    10a2:	f426                	sd	s1,40(sp)
    10a4:	e852                	sd	s4,16(sp)
    10a6:	e456                	sd	s5,8(sp)
    10a8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    10aa:	00001797          	auipc	a5,0x1
    10ae:	f6678793          	addi	a5,a5,-154 # 2010 <base>
    10b2:	00001717          	auipc	a4,0x1
    10b6:	f4f73723          	sd	a5,-178(a4) # 2000 <freep>
    10ba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    10bc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    10c0:	b7d1                	j	1084 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    10c2:	6398                	ld	a4,0(a5)
    10c4:	e118                	sd	a4,0(a0)
    10c6:	a899                	j	111c <malloc+0xd0>
  hp->s.size = nu;
    10c8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    10cc:	0541                	addi	a0,a0,16
    10ce:	ef9ff0ef          	jal	fc6 <free>
  return freep;
    10d2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    10d4:	c125                	beqz	a0,1134 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10d8:	4798                	lw	a4,8(a5)
    10da:	03277163          	bgeu	a4,s2,10fc <malloc+0xb0>
    if(p == freep)
    10de:	6098                	ld	a4,0(s1)
    10e0:	853e                	mv	a0,a5
    10e2:	fef71ae3          	bne	a4,a5,10d6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    10e6:	8552                	mv	a0,s4
    10e8:	9e3ff0ef          	jal	aca <sbrk>
  if(p == SBRK_ERROR)
    10ec:	fd551ee3          	bne	a0,s5,10c8 <malloc+0x7c>
        return 0;
    10f0:	4501                	li	a0,0
    10f2:	74a2                	ld	s1,40(sp)
    10f4:	6a42                	ld	s4,16(sp)
    10f6:	6aa2                	ld	s5,8(sp)
    10f8:	6b02                	ld	s6,0(sp)
    10fa:	a03d                	j	1128 <malloc+0xdc>
    10fc:	74a2                	ld	s1,40(sp)
    10fe:	6a42                	ld	s4,16(sp)
    1100:	6aa2                	ld	s5,8(sp)
    1102:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1104:	fae90fe3          	beq	s2,a4,10c2 <malloc+0x76>
        p->s.size -= nunits;
    1108:	4137073b          	subw	a4,a4,s3
    110c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    110e:	02071693          	slli	a3,a4,0x20
    1112:	01c6d713          	srli	a4,a3,0x1c
    1116:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1118:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    111c:	00001717          	auipc	a4,0x1
    1120:	eea73223          	sd	a0,-284(a4) # 2000 <freep>
      return (void*)(p + 1);
    1124:	01078513          	addi	a0,a5,16
  }
}
    1128:	70e2                	ld	ra,56(sp)
    112a:	7442                	ld	s0,48(sp)
    112c:	7902                	ld	s2,32(sp)
    112e:	69e2                	ld	s3,24(sp)
    1130:	6121                	addi	sp,sp,64
    1132:	8082                	ret
    1134:	74a2                	ld	s1,40(sp)
    1136:	6a42                	ld	s4,16(sp)
    1138:	6aa2                	ld	s5,8(sp)
    113a:	6b02                	ld	s6,0(sp)
    113c:	b7f5                	j	1128 <malloc+0xdc>
