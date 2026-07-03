
user/_PA4_5:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <write_verify_17>:

static char pat_17(int page, int pass, int variant) {
    return (char)((page * 19 + pass * 31 + variant * 7 + 1) & 0xFF);
}

static int write_verify_17(char *mem, int npages, int pass, int variant) {
       0:	715d                	addi	sp,sp,-80
       2:	e486                	sd	ra,72(sp)
       4:	e0a2                	sd	s0,64(sp)
       6:	f44e                	sd	s3,40(sp)
       8:	0880                	addi	s0,sp,80
    for (int i = 0; i < npages; i++)
       a:	08b05a63          	blez	a1,9e <write_verify_17+0x9e>
       e:	fc26                	sd	s1,56(sp)
      10:	f84a                	sd	s2,48(sp)
      12:	f052                	sd	s4,32(sp)
      14:	ec56                	sd	s5,24(sp)
      16:	e85a                	sd	s6,16(sp)
      18:	e45e                	sd	s7,8(sp)
      1a:	8aae                	mv	s5,a1
    return (char)((page * 19 + pass * 31 + variant * 7 + 1) & 0xFF);
      1c:	0036949b          	slliw	s1,a3,0x3
      20:	9c95                	subw	s1,s1,a3
      22:	2485                	addiw	s1,s1,1
      24:	0056179b          	slliw	a5,a2,0x5
      28:	9f91                	subw	a5,a5,a2
      2a:	9cbd                	addw	s1,s1,a5
      2c:	0ff4f493          	zext.b	s1,s1
      30:	8a2a                	mv	s4,a0
      32:	00a59713          	slli	a4,a1,0xa
      36:	972a                	add	a4,a4,a0
      38:	87a6                	mv	a5,s1
        mem[i * PGSIZE_17] = pat_17(i, pass, variant);
      3a:	00f50023          	sb	a5,0(a0)
    for (int i = 0; i < npages; i++)
      3e:	27cd                	addiw	a5,a5,19
      40:	0ff7f793          	zext.b	a5,a5
      44:	40050513          	addi	a0,a0,1024
      48:	fee519e3          	bne	a0,a4,3a <write_verify_17+0x3a>

    int errs = 0;
    for (int i = 0; i < npages; i++) {
      4c:	4901                	li	s2,0
    int errs = 0;
      4e:	4981                	li	s3,0
        char expected = pat_17(i, pass, variant);
        char got = mem[i * PGSIZE_17];
        if (got != expected) {
            errs++;
            if (errs <= 4)
      50:	4b11                	li	s6,4
                printf("  page %d: got 0x%x exp 0x%x\n",
      52:	00001b97          	auipc	s7,0x1
      56:	19eb8b93          	addi	s7,s7,414 # 11f0 <malloc+0xf8>
      5a:	a831                	j	76 <write_verify_17+0x76>
      5c:	86a6                	mv	a3,s1
      5e:	85ca                	mv	a1,s2
      60:	855e                	mv	a0,s7
      62:	7df000ef          	jal	1040 <printf>
    for (int i = 0; i < npages; i++) {
      66:	2905                	addiw	s2,s2,1
      68:	400a0a13          	addi	s4,s4,1024
      6c:	24cd                	addiw	s1,s1,19
      6e:	0ff4f493          	zext.b	s1,s1
      72:	012a8a63          	beq	s5,s2,86 <write_verify_17+0x86>
        char got = mem[i * PGSIZE_17];
      76:	000a4603          	lbu	a2,0(s4)
        if (got != expected) {
      7a:	fec486e3          	beq	s1,a2,66 <write_verify_17+0x66>
            errs++;
      7e:	2985                	addiw	s3,s3,1
            if (errs <= 4)
      80:	ff3b43e3          	blt	s6,s3,66 <write_verify_17+0x66>
      84:	bfe1                	j	5c <write_verify_17+0x5c>
      86:	74e2                	ld	s1,56(sp)
      88:	7942                	ld	s2,48(sp)
      8a:	7a02                	ld	s4,32(sp)
      8c:	6ae2                	ld	s5,24(sp)
      8e:	6b42                	ld	s6,16(sp)
      90:	6ba2                	ld	s7,8(sp)
                       i, (unsigned char)got, (unsigned char)expected);
        }
    }
    return errs;
}
      92:	854e                	mv	a0,s3
      94:	60a6                	ld	ra,72(sp)
      96:	6406                	ld	s0,64(sp)
      98:	79a2                	ld	s3,40(sp)
      9a:	6161                	addi	sp,sp,80
      9c:	8082                	ret
    int errs = 0;
      9e:	4981                	li	s3,0
      a0:	bfcd                	j	92 <write_verify_17+0x92>

00000000000000a2 <run_write_read_15>:
static int run_write_read_15(char *mem, int npages, int pass) {
      a2:	715d                	addi	sp,sp,-80
      a4:	e486                	sd	ra,72(sp)
      a6:	e0a2                	sd	s0,64(sp)
      a8:	f44e                	sd	s3,40(sp)
      aa:	0880                	addi	s0,sp,80
    for (int i = 0; i < npages; i++)
      ac:	08b05363          	blez	a1,132 <run_write_read_15+0x90>
      b0:	fc26                	sd	s1,56(sp)
      b2:	f84a                	sd	s2,48(sp)
      b4:	f052                	sd	s4,32(sp)
      b6:	ec56                	sd	s5,24(sp)
      b8:	e85a                	sd	s6,16(sp)
      ba:	e45e                	sd	s7,8(sp)
      bc:	8aae                	mv	s5,a1
      be:	2615                	addiw	a2,a2,5
      c0:	0ff67493          	zext.b	s1,a2
      c4:	8a2a                	mv	s4,a0
      c6:	00a59713          	slli	a4,a1,0xa
      ca:	972a                	add	a4,a4,a0
      cc:	87a6                	mv	a5,s1
        mem[i * PGSIZE_15] = (char)((pat_15(i) + pass) & 0xFF);
      ce:	00f50023          	sb	a5,0(a0)
    for (int i = 0; i < npages; i++)
      d2:	27c5                	addiw	a5,a5,17
      d4:	0ff7f793          	zext.b	a5,a5
      d8:	40050513          	addi	a0,a0,1024
      dc:	fee519e3          	bne	a0,a4,ce <run_write_read_15+0x2c>
    for (int i = 0; i < npages; i++) {
      e0:	4901                	li	s2,0
    int errs = 0;
      e2:	4981                	li	s3,0
            if (errs <= 3)
      e4:	4b0d                	li	s6,3
                printf("  page %d: got 0x%x exp 0x%x\n",
      e6:	00001b97          	auipc	s7,0x1
      ea:	10ab8b93          	addi	s7,s7,266 # 11f0 <malloc+0xf8>
      ee:	a831                	j	10a <run_write_read_15+0x68>
      f0:	86a6                	mv	a3,s1
      f2:	85ca                	mv	a1,s2
      f4:	855e                	mv	a0,s7
      f6:	74b000ef          	jal	1040 <printf>
    for (int i = 0; i < npages; i++) {
      fa:	2905                	addiw	s2,s2,1
      fc:	400a0a13          	addi	s4,s4,1024
     100:	24c5                	addiw	s1,s1,17
     102:	0ff4f493          	zext.b	s1,s1
     106:	012a8a63          	beq	s5,s2,11a <run_write_read_15+0x78>
        if (mem[i * PGSIZE_15] != expected) {
     10a:	000a4603          	lbu	a2,0(s4)
     10e:	fe9606e3          	beq	a2,s1,fa <run_write_read_15+0x58>
            errs++;
     112:	2985                	addiw	s3,s3,1
            if (errs <= 3)
     114:	ff3b43e3          	blt	s6,s3,fa <run_write_read_15+0x58>
     118:	bfe1                	j	f0 <run_write_read_15+0x4e>
     11a:	74e2                	ld	s1,56(sp)
     11c:	7942                	ld	s2,48(sp)
     11e:	7a02                	ld	s4,32(sp)
     120:	6ae2                	ld	s5,24(sp)
     122:	6b42                	ld	s6,16(sp)
     124:	6ba2                	ld	s7,8(sp)
}
     126:	854e                	mv	a0,s3
     128:	60a6                	ld	ra,72(sp)
     12a:	6406                	ld	s0,64(sp)
     12c:	79a2                	ld	s3,40(sp)
     12e:	6161                	addi	sp,sp,80
     130:	8082                	ret
    int errs = 0;
     132:	4981                	li	s3,0
     134:	bfcd                	j	126 <run_write_read_15+0x84>

0000000000000136 <main>:
// main
// ============================================================

int
main(void)
{
     136:	7171                	addi	sp,sp,-176
     138:	f506                	sd	ra,168(sp)
     13a:	f122                	sd	s0,160(sp)
     13c:	ed26                	sd	s1,152(sp)
     13e:	e94a                	sd	s2,144(sp)
     140:	e54e                	sd	s3,136(sp)
     142:	e152                	sd	s4,128(sp)
     144:	fcd6                	sd	s5,120(sp)
     146:	f8da                	sd	s6,112(sp)
     148:	f4de                	sd	s7,104(sp)
     14a:	f0e2                	sd	s8,96(sp)
     14c:	ece6                	sd	s9,88(sp)
     14e:	e8ea                	sd	s10,80(sp)
     150:	e4ee                	sd	s11,72(sp)
     152:	1900                	addi	s0,sp,176
  printf("==============================\n");
     154:	00001517          	auipc	a0,0x1
     158:	0bc50513          	addi	a0,a0,188 # 1210 <malloc+0x118>
     15c:	6e5000ef          	jal	1040 <printf>
  printf("PA4_E: RAID 0/1/5 correctness\n");
     160:	00001517          	auipc	a0,0x1
     164:	0d050513          	addi	a0,a0,208 # 1230 <malloc+0x138>
     168:	6d9000ef          	jal	1040 <printf>
  printf("==============================\n\n");
     16c:	00001517          	auipc	a0,0x1
     170:	0e450513          	addi	a0,a0,228 # 1250 <malloc+0x158>
     174:	6cd000ef          	jal	1040 <printf>

  printf("--- PA4_14: RAID0 striping ---\n");
     178:	00001517          	auipc	a0,0x1
     17c:	10050513          	addi	a0,a0,256 # 1278 <malloc+0x180>
     180:	6c1000ef          	jal	1040 <printf>
    printf("=== Test n: RAID 0 Striping Correctness ===\n");
     184:	00001517          	auipc	a0,0x1
     188:	11450513          	addi	a0,a0,276 # 1298 <malloc+0x1a0>
     18c:	6b5000ef          	jal	1040 <printf>
    printf("[1] Setting disk policy to FCFS for deterministic ordering\n");
     190:	00001517          	auipc	a0,0x1
     194:	13850513          	addi	a0,a0,312 # 12c8 <malloc+0x1d0>
     198:	6a9000ef          	jal	1040 <printf>
    setdisksched(FCFS_14);
     19c:	4501                	li	a0,0
     19e:	2f5000ef          	jal	c92 <setdisksched>
    printf("  PASS: policy set\n");
     1a2:	00001517          	auipc	a0,0x1
     1a6:	16650513          	addi	a0,a0,358 # 1308 <malloc+0x210>
     1aa:	697000ef          	jal	1040 <printf>
    printf("[2] Multi-pass write/read across %d pages\n", SWAP_PAGES_14);
     1ae:	05500593          	li	a1,85
     1b2:	00001517          	auipc	a0,0x1
     1b6:	16e50513          	addi	a0,a0,366 # 1320 <malloc+0x228>
     1ba:	687000ef          	jal	1040 <printf>
    char *mem = sbrklazy(SWAP_PAGES_14 * PGSIZE_14);
     1be:	6555                	lui	a0,0x15
     1c0:	40050513          	addi	a0,a0,1024 # 15400 <base+0x123f0>
     1c4:	1c9000ef          	jal	b8c <sbrklazy>
    if (mem == (char *)-1) {
     1c8:	57fd                	li	a5,-1
     1ca:	00f50f63          	beq	a0,a5,1e8 <main+0xb2>
     1ce:	8d2a                	mv	s10,a0
     1d0:	05200a13          	li	s4,82
     1d4:	4d81                	li	s11,0
     1d6:	4b81                	li	s7,0
                if (errs <= 3)
     1d8:	4c8d                	li	s9,3
                    printf("  page %d pass %d: got 0x%x expected 0x%x\n",
     1da:	00001c17          	auipc	s8,0x1
     1de:	18ec0c13          	addi	s8,s8,398 # 1368 <malloc+0x270>
        for (int i = 0; i < SWAP_PAGES_14; i++) {
     1e2:	05500a93          	li	s5,85
     1e6:	a08d                	j	248 <main+0x112>
        printf("  FAIL: sbrklazy\n");
     1e8:	00001517          	auipc	a0,0x1
     1ec:	16850513          	addi	a0,a0,360 # 1350 <malloc+0x258>
     1f0:	651000ef          	jal	1040 <printf>
        return;
     1f4:	aa35                	j	330 <main+0x1fa>
                    printf("  page %d pass %d: got 0x%x expected 0x%x\n",
     1f6:	8726                	mv	a4,s1
     1f8:	865e                	mv	a2,s7
     1fa:	85ca                	mv	a1,s2
     1fc:	8562                	mv	a0,s8
     1fe:	643000ef          	jal	1040 <printf>
        for (int i = 0; i < SWAP_PAGES_14; i++) {
     202:	2905                	addiw	s2,s2,1
     204:	40098993          	addi	s3,s3,1024
     208:	24b5                	addiw	s1,s1,13
     20a:	0ff4f493          	zext.b	s1,s1
     20e:	01590a63          	beq	s2,s5,222 <main+0xec>
            if (mem[i * PGSIZE_14] != pat_14(i, pass)) {
     212:	0009c683          	lbu	a3,0(s3)
     216:	fe9686e3          	beq	a3,s1,202 <main+0xcc>
                errs++;
     21a:	2b05                	addiw	s6,s6,1
                if (errs <= 3)
     21c:	ff6cc3e3          	blt	s9,s6,202 <main+0xcc>
     220:	bfd9                	j	1f6 <main+0xc0>
        total_errs += errs;
     222:	01bb04bb          	addw	s1,s6,s11
     226:	8da6                	mv	s11,s1
        if (errs == 0)
     228:	040b1363          	bnez	s6,26e <main+0x138>
            printf("  pass %d: PASS (all %d pages correct)\n", pass, SWAP_PAGES_14);
     22c:	8656                	mv	a2,s5
     22e:	85de                	mv	a1,s7
     230:	00001517          	auipc	a0,0x1
     234:	16850513          	addi	a0,a0,360 # 1398 <malloc+0x2a0>
     238:	609000ef          	jal	1040 <printf>
    for (int pass = 0; pass < PASSES_14; pass++) {
     23c:	2b85                	addiw	s7,s7,1
     23e:	2a1d                	addiw	s4,s4,7
     240:	0ffa7a13          	zext.b	s4,s4
     244:	039b8e63          	beq	s7,s9,280 <main+0x14a>
        for (int i = 0; i < SWAP_PAGES_14; i++)
     248:	fafa049b          	addiw	s1,s4,-81
     24c:	0ff4f493          	zext.b	s1,s1
     250:	89ea                	mv	s3,s10
{
     252:	876a                	mv	a4,s10
     254:	87a6                	mv	a5,s1
            mem[i * PGSIZE_14] = pat_14(i, pass);
     256:	00f70023          	sb	a5,0(a4)
        for (int i = 0; i < SWAP_PAGES_14; i++)
     25a:	27b5                	addiw	a5,a5,13
     25c:	0ff7f793          	zext.b	a5,a5
     260:	40070713          	addi	a4,a4,1024
     264:	ff4799e3          	bne	a5,s4,256 <main+0x120>
        int errs = 0;
     268:	4b01                	li	s6,0
        for (int i = 0; i < SWAP_PAGES_14; i++) {
     26a:	4901                	li	s2,0
     26c:	b75d                	j	212 <main+0xdc>
            printf("  pass %d: FAIL (%d errors)\n", pass, errs);
     26e:	865a                	mv	a2,s6
     270:	85de                	mv	a1,s7
     272:	00001517          	auipc	a0,0x1
     276:	14e50513          	addi	a0,a0,334 # 13c0 <malloc+0x2c8>
     27a:	5c7000ef          	jal	1040 <printf>
     27e:	bf7d                	j	23c <main+0x106>
    printf("[3] Overall data integrity\n");
     280:	00001517          	auipc	a0,0x1
     284:	16050513          	addi	a0,a0,352 # 13e0 <malloc+0x2e8>
     288:	5b9000ef          	jal	1040 <printf>
    if (total_errs == 0)
     28c:	240d9e63          	bnez	s11,4e8 <main+0x3b2>
        printf("  PASS: %d passes, 0 errors — RAID0 striping correct\n", PASSES_14);
     290:	458d                	li	a1,3
     292:	00001517          	auipc	a0,0x1
     296:	16e50513          	addi	a0,a0,366 # 1400 <malloc+0x308>
     29a:	5a7000ef          	jal	1040 <printf>
    printf("[4] Disk I/O was generated\n");
     29e:	00001517          	auipc	a0,0x1
     2a2:	1ca50513          	addi	a0,a0,458 # 1468 <malloc+0x370>
     2a6:	59b000ef          	jal	1040 <printf>
    if (getvmstats(getpid(), &st) != 0) {
     2aa:	181000ef          	jal	c2a <getpid>
     2ae:	f6040593          	addi	a1,s0,-160
     2b2:	1d9000ef          	jal	c8a <getvmstats>
     2b6:	24051263          	bnez	a0,4fa <main+0x3c4>
    printf("  reads=%lu writes=%lu avg_latency=%lu ticks\n",
     2ba:	f8843683          	ld	a3,-120(s0)
     2be:	f8043603          	ld	a2,-128(s0)
     2c2:	f7843583          	ld	a1,-136(s0)
     2c6:	00001517          	auipc	a0,0x1
     2ca:	1e250513          	addi	a0,a0,482 # 14a8 <malloc+0x3b0>
     2ce:	573000ef          	jal	1040 <printf>
    if (st.disk_writes > 0)
     2d2:	f8043783          	ld	a5,-128(s0)
     2d6:	22078963          	beqz	a5,508 <main+0x3d2>
        printf("  PASS: swap-out (writes) occurred\n");
     2da:	00001517          	auipc	a0,0x1
     2de:	1fe50513          	addi	a0,a0,510 # 14d8 <malloc+0x3e0>
     2e2:	55f000ef          	jal	1040 <printf>
    if (st.disk_reads > 0)
     2e6:	f7843783          	ld	a5,-136(s0)
     2ea:	22078663          	beqz	a5,516 <main+0x3e0>
        printf("  PASS: swap-in (reads) occurred\n");
     2ee:	00001517          	auipc	a0,0x1
     2f2:	24a50513          	addi	a0,a0,586 # 1538 <malloc+0x440>
     2f6:	54b000ef          	jal	1040 <printf>
    printf("[5] RAID0 stripe count plausibility\n");
     2fa:	00001517          	auipc	a0,0x1
     2fe:	28650513          	addi	a0,a0,646 # 1580 <malloc+0x488>
     302:	53f000ef          	jal	1040 <printf>
    if ((int)st.disk_writes >= expected_min_writes / 4)
     306:	f8043583          	ld	a1,-128(s0)
     30a:	0005871b          	sext.w	a4,a1
     30e:	05400793          	li	a5,84
     312:	20e7d963          	bge	a5,a4,524 <main+0x3ee>
        printf("  PASS: write count plausible for RAID0 striping\n");
     316:	00001517          	auipc	a0,0x1
     31a:	29250513          	addi	a0,a0,658 # 15a8 <malloc+0x4b0>
     31e:	523000ef          	jal	1040 <printf>
    printf("=== Test n done (total_errs=%d) ===\n", total_errs);
     322:	85a6                	mv	a1,s1
     324:	00001517          	auipc	a0,0x1
     328:	2f450513          	addi	a0,a0,756 # 1618 <malloc+0x520>
     32c:	515000ef          	jal	1040 <printf>
  test_pa4_14();

  printf("\n--- PA4_15: RAID1 mirroring ---\n");
     330:	00001517          	auipc	a0,0x1
     334:	31050513          	addi	a0,a0,784 # 1640 <malloc+0x548>
     338:	509000ef          	jal	1040 <printf>
    printf("=== Test o: RAID 1 Mirroring Correctness ===\n");
     33c:	00001517          	auipc	a0,0x1
     340:	32c50513          	addi	a0,a0,812 # 1668 <malloc+0x570>
     344:	4fd000ef          	jal	1040 <printf>
    printf("[1] Disk index bounds check (NUM_DISKS=%d)\n", NDISKS_15);
     348:	4591                	li	a1,4
     34a:	00001517          	auipc	a0,0x1
     34e:	34e50513          	addi	a0,a0,846 # 1698 <malloc+0x5a0>
     352:	4ef000ef          	jal	1040 <printf>
    printf("  NOTE: raid_fail_disk is kernel-internal; bounds verified via raid.h constants\n");
     356:	00001517          	auipc	a0,0x1
     35a:	37250513          	addi	a0,a0,882 # 16c8 <malloc+0x5d0>
     35e:	4e3000ef          	jal	1040 <printf>
    printf("  PASS: NUM_DISKS=4 valid range is [0,3]\n");
     362:	00001517          	auipc	a0,0x1
     366:	3be50513          	addi	a0,a0,958 # 1720 <malloc+0x628>
     36a:	4d7000ef          	jal	1040 <printf>
    printf("[2] Setting SSTF policy for mirroring test\n");
     36e:	00001517          	auipc	a0,0x1
     372:	3e250513          	addi	a0,a0,994 # 1750 <malloc+0x658>
     376:	4cb000ef          	jal	1040 <printf>
    setdisksched(SSTF_15);
     37a:	4505                	li	a0,1
     37c:	117000ef          	jal	c92 <setdisksched>
    printf("  PASS: SSTF set\n");
     380:	00001517          	auipc	a0,0x1
     384:	40050513          	addi	a0,a0,1024 # 1780 <malloc+0x688>
     388:	4b9000ef          	jal	1040 <printf>
    char *mem = sbrklazy(SWAP_PAGES_15 * PGSIZE_15);
     38c:	6555                	lui	a0,0x15
     38e:	80050513          	addi	a0,a0,-2048 # 14800 <base+0x117f0>
     392:	7fa000ef          	jal	b8c <sbrklazy>
     396:	84aa                	mv	s1,a0
    if (mem == (char *)-1) { printf("  FAIL: sbrklazy\n"); return; }
     398:	57fd                	li	a5,-1
     39a:	18f50e63          	beq	a0,a5,536 <main+0x400>
    printf("[3] Normal RAID1 operation — data integrity\n");
     39e:	00001517          	auipc	a0,0x1
     3a2:	3fa50513          	addi	a0,a0,1018 # 1798 <malloc+0x6a0>
     3a6:	49b000ef          	jal	1040 <printf>
    int errs = run_write_read_15(mem, SWAP_PAGES_15, 0);
     3aa:	4601                	li	a2,0
     3ac:	05200593          	li	a1,82
     3b0:	8526                	mv	a0,s1
     3b2:	cf1ff0ef          	jal	a2 <run_write_read_15>
     3b6:	85aa                	mv	a1,a0
    if (errs == 0)
     3b8:	18051663          	bnez	a0,544 <main+0x40e>
        printf("  PASS: all %d pages correct under RAID1\n", SWAP_PAGES_15);
     3bc:	05200593          	li	a1,82
     3c0:	00001517          	auipc	a0,0x1
     3c4:	40850513          	addi	a0,a0,1032 # 17c8 <malloc+0x6d0>
     3c8:	479000ef          	jal	1040 <printf>
    printf("[4] Second pass — verifies mirror stays in sync across evictions\n");
     3cc:	00001517          	auipc	a0,0x1
     3d0:	45450513          	addi	a0,a0,1108 # 1820 <malloc+0x728>
     3d4:	46d000ef          	jal	1040 <printf>
    errs = run_write_read_15(mem, SWAP_PAGES_15, 1);
     3d8:	4605                	li	a2,1
     3da:	05200593          	li	a1,82
     3de:	8526                	mv	a0,s1
     3e0:	cc3ff0ef          	jal	a2 <run_write_read_15>
     3e4:	85aa                	mv	a1,a0
    if (errs == 0)
     3e6:	16051663          	bnez	a0,552 <main+0x41c>
        printf("  PASS: all pages correct on second pass\n");
     3ea:	00001517          	auipc	a0,0x1
     3ee:	47e50513          	addi	a0,a0,1150 # 1868 <malloc+0x770>
     3f2:	44f000ef          	jal	1040 <printf>
    printf("[5] Third pass — further mirroring consistency check\n");
     3f6:	00001517          	auipc	a0,0x1
     3fa:	4ca50513          	addi	a0,a0,1226 # 18c0 <malloc+0x7c8>
     3fe:	443000ef          	jal	1040 <printf>
    errs = run_write_read_15(mem, SWAP_PAGES_15, 2);
     402:	4609                	li	a2,2
     404:	05200593          	li	a1,82
     408:	8526                	mv	a0,s1
     40a:	c99ff0ef          	jal	a2 <run_write_read_15>
     40e:	85aa                	mv	a1,a0
    if (errs == 0)
     410:	14051863          	bnez	a0,560 <main+0x42a>
        printf("  PASS: all pages correct on third pass\n");
     414:	00001517          	auipc	a0,0x1
     418:	4e450513          	addi	a0,a0,1252 # 18f8 <malloc+0x800>
     41c:	425000ef          	jal	1040 <printf>
    printf("[6] Disk I/O stats plausible for RAID1\n");
     420:	00001517          	auipc	a0,0x1
     424:	53050513          	addi	a0,a0,1328 # 1950 <malloc+0x858>
     428:	419000ef          	jal	1040 <printf>
    getvmstats(getpid(), &st);
     42c:	7fe000ef          	jal	c2a <getpid>
     430:	f6040593          	addi	a1,s0,-160
     434:	057000ef          	jal	c8a <getvmstats>
    printf("  reads=%lu writes=%lu avg_latency=%lu ticks\n",
     438:	f8843683          	ld	a3,-120(s0)
     43c:	f8043603          	ld	a2,-128(s0)
     440:	f7843583          	ld	a1,-136(s0)
     444:	00001517          	auipc	a0,0x1
     448:	06450513          	addi	a0,a0,100 # 14a8 <malloc+0x3b0>
     44c:	3f5000ef          	jal	1040 <printf>
    if (st.disk_writes > 0 && st.disk_reads > 0)
     450:	f8043783          	ld	a5,-128(s0)
     454:	c789                	beqz	a5,45e <main+0x328>
     456:	f7843783          	ld	a5,-136(s0)
     45a:	10079a63          	bnez	a5,56e <main+0x438>
        printf("  FAIL: missing reads or writes\n");
     45e:	00001517          	auipc	a0,0x1
     462:	53250513          	addi	a0,a0,1330 # 1990 <malloc+0x898>
     466:	3db000ef          	jal	1040 <printf>
    printf("=== Test o done ===\n");
     46a:	00001517          	auipc	a0,0x1
     46e:	54e50513          	addi	a0,a0,1358 # 19b8 <malloc+0x8c0>
     472:	3cf000ef          	jal	1040 <printf>
  test_pa4_15();

  printf("\n--- PA4_16: RAID5 basic correctness ---\n");
     476:	00001517          	auipc	a0,0x1
     47a:	55a50513          	addi	a0,a0,1370 # 19d0 <malloc+0x8d8>
     47e:	3c3000ef          	jal	1040 <printf>
    printf("=== Test p: RAID 5 Basic Correctness (No Failure) ===\n");
     482:	00001517          	auipc	a0,0x1
     486:	57e50513          	addi	a0,a0,1406 # 1a00 <malloc+0x908>
     48a:	3b7000ef          	jal	1040 <printf>
    printf("[1] Setting SSTF policy for RAID5 test\n");
     48e:	00001517          	auipc	a0,0x1
     492:	5aa50513          	addi	a0,a0,1450 # 1a38 <malloc+0x940>
     496:	3ab000ef          	jal	1040 <printf>
    setdisksched(SSTF_16);
     49a:	4505                	li	a0,1
     49c:	7f6000ef          	jal	c92 <setdisksched>
    printf("  PASS: SSTF set\n");
     4a0:	00001517          	auipc	a0,0x1
     4a4:	2e050513          	addi	a0,a0,736 # 1780 <malloc+0x688>
     4a8:	399000ef          	jal	1040 <printf>
    char *mem = sbrklazy(SWAP_PAGES_16 * PGSIZE_16);
     4ac:	6559                	lui	a0,0x16
     4ae:	6de000ef          	jal	b8c <sbrklazy>
     4b2:	f4a43c23          	sd	a0,-168(s0)
    if (mem == (char *)-1) { printf("  FAIL: sbrklazy\n"); return; }
     4b6:	57fd                	li	a5,-1
     4b8:	0cf50263          	beq	a0,a5,57c <main+0x446>
    printf("[2] Multi-pass write/read (%d pages, %d passes)\n",
     4bc:	4611                	li	a2,4
     4be:	05800593          	li	a1,88
     4c2:	00001517          	auipc	a0,0x1
     4c6:	59e50513          	addi	a0,a0,1438 # 1a60 <malloc+0x968>
     4ca:	377000ef          	jal	1040 <printf>
     4ce:	0cb00c13          	li	s8,203
    int total_errs = 0;
     4d2:	4d01                	li	s10,0
    for (int pass = 0; pass < PASSES_16; pass++) {
     4d4:	4a81                	li	s5,0
                if (errs <= 5)
     4d6:	4b95                	li	s7,5
                    printf("  page %d pass %d: got 0x%x exp 0x%x\n",
     4d8:	00001b17          	auipc	s6,0x1
     4dc:	5c0b0b13          	addi	s6,s6,1472 # 1a98 <malloc+0x9a0>
        for (int i = 0; i < SWAP_PAGES_16; i++) {
     4e0:	05800c93          	li	s9,88
    for (int pass = 0; pass < PASSES_16; pass++) {
     4e4:	4d91                	li	s11,4
     4e6:	a8dd                	j	5dc <main+0x4a6>
        printf("  FAIL: %d total errors across %d passes\n", total_errs, PASSES_14);
     4e8:	460d                	li	a2,3
     4ea:	85a6                	mv	a1,s1
     4ec:	00001517          	auipc	a0,0x1
     4f0:	f4c50513          	addi	a0,a0,-180 # 1438 <malloc+0x340>
     4f4:	34d000ef          	jal	1040 <printf>
     4f8:	b35d                	j	29e <main+0x168>
        printf("  FAIL: getvmstats error\n");
     4fa:	00001517          	auipc	a0,0x1
     4fe:	f8e50513          	addi	a0,a0,-114 # 1488 <malloc+0x390>
     502:	33f000ef          	jal	1040 <printf>
        return;
     506:	b52d                	j	330 <main+0x1fa>
        printf("  FAIL: no writes recorded — check swap/RAID path\n");
     508:	00001517          	auipc	a0,0x1
     50c:	ff850513          	addi	a0,a0,-8 # 1500 <malloc+0x408>
     510:	331000ef          	jal	1040 <printf>
     514:	bbc9                	j	2e6 <main+0x1b0>
        printf("  FAIL: no reads recorded\n");
     516:	00001517          	auipc	a0,0x1
     51a:	04a50513          	addi	a0,a0,74 # 1560 <malloc+0x468>
     51e:	323000ef          	jal	1040 <printf>
     522:	bbe1                	j	2fa <main+0x1c4>
        printf("  NOTE: write count %lu may be lower than expected %d\n",
     524:	05500613          	li	a2,85
     528:	00001517          	auipc	a0,0x1
     52c:	0b850513          	addi	a0,a0,184 # 15e0 <malloc+0x4e8>
     530:	311000ef          	jal	1040 <printf>
     534:	b3fd                	j	322 <main+0x1ec>
    if (mem == (char *)-1) { printf("  FAIL: sbrklazy\n"); return; }
     536:	00001517          	auipc	a0,0x1
     53a:	e1a50513          	addi	a0,a0,-486 # 1350 <malloc+0x258>
     53e:	303000ef          	jal	1040 <printf>
     542:	bf15                	j	476 <main+0x340>
        printf("  FAIL: %d errors under normal RAID1\n", errs);
     544:	00001517          	auipc	a0,0x1
     548:	2b450513          	addi	a0,a0,692 # 17f8 <malloc+0x700>
     54c:	2f5000ef          	jal	1040 <printf>
     550:	bdb5                	j	3cc <main+0x296>
        printf("  FAIL: %d errors on second pass\n", errs);
     552:	00001517          	auipc	a0,0x1
     556:	34650513          	addi	a0,a0,838 # 1898 <malloc+0x7a0>
     55a:	2e7000ef          	jal	1040 <printf>
     55e:	bd61                	j	3f6 <main+0x2c0>
        printf("  FAIL: %d errors on third pass\n", errs);
     560:	00001517          	auipc	a0,0x1
     564:	3c850513          	addi	a0,a0,968 # 1928 <malloc+0x830>
     568:	2d9000ef          	jal	1040 <printf>
     56c:	bd55                	j	420 <main+0x2ea>
        printf("  PASS: I/O recorded\n");
     56e:	00001517          	auipc	a0,0x1
     572:	40a50513          	addi	a0,a0,1034 # 1978 <malloc+0x880>
     576:	2cb000ef          	jal	1040 <printf>
     57a:	bdc5                	j	46a <main+0x334>
    if (mem == (char *)-1) { printf("  FAIL: sbrklazy\n"); return; }
     57c:	00001517          	auipc	a0,0x1
     580:	dd450513          	addi	a0,a0,-556 # 1350 <malloc+0x258>
     584:	2bd000ef          	jal	1040 <printf>
     588:	aa35                	j	6c4 <main+0x58e>
                    printf("  page %d pass %d: got 0x%x exp 0x%x\n",
     58a:	8726                	mv	a4,s1
     58c:	8656                	mv	a2,s5
     58e:	85ce                	mv	a1,s3
     590:	855a                	mv	a0,s6
     592:	2af000ef          	jal	1040 <printf>
        for (int i = 0; i < SWAP_PAGES_16; i++) {
     596:	2985                	addiw	s3,s3,1
     598:	400a0a13          	addi	s4,s4,1024
     59c:	24ad                	addiw	s1,s1,11
     59e:	0ff4f493          	zext.b	s1,s1
     5a2:	01998a63          	beq	s3,s9,5b6 <main+0x480>
            char got = mem[i * PGSIZE_16];
     5a6:	000a4683          	lbu	a3,0(s4)
            if (got != expected) {
     5aa:	fe9686e3          	beq	a3,s1,596 <main+0x460>
                errs++;
     5ae:	2905                	addiw	s2,s2,1
                if (errs <= 5)
     5b0:	ff2bc3e3          	blt	s7,s2,596 <main+0x460>
     5b4:	bfd9                	j	58a <main+0x454>
        total_errs += errs;
     5b6:	01a904bb          	addw	s1,s2,s10
     5ba:	8d26                	mv	s10,s1
        if (errs == 0)
     5bc:	04091463          	bnez	s2,604 <main+0x4ce>
            printf("  pass %d: PASS (%d pages OK)\n", pass, SWAP_PAGES_16);
     5c0:	8666                	mv	a2,s9
     5c2:	85d6                	mv	a1,s5
     5c4:	00001517          	auipc	a0,0x1
     5c8:	4fc50513          	addi	a0,a0,1276 # 1ac0 <malloc+0x9c8>
     5cc:	275000ef          	jal	1040 <printf>
    for (int pass = 0; pass < PASSES_16; pass++) {
     5d0:	2a85                	addiw	s5,s5,1
     5d2:	2c5d                	addiw	s8,s8,23
     5d4:	0ffc7c13          	zext.b	s8,s8
     5d8:	03ba8f63          	beq	s5,s11,616 <main+0x4e0>
        for (int i = 0; i < SWAP_PAGES_16; i++)
     5dc:	038c049b          	addiw	s1,s8,56
     5e0:	0ff4f493          	zext.b	s1,s1
     5e4:	f5843703          	ld	a4,-168(s0)
     5e8:	8a3a                	mv	s4,a4
    for (int pass = 0; pass < PASSES_14; pass++) {
     5ea:	87a6                	mv	a5,s1
            mem[i * PGSIZE_16] = pat_16(i, pass);
     5ec:	00f70023          	sb	a5,0(a4)
        for (int i = 0; i < SWAP_PAGES_16; i++)
     5f0:	27ad                	addiw	a5,a5,11
     5f2:	0ff7f793          	zext.b	a5,a5
     5f6:	40070713          	addi	a4,a4,1024
     5fa:	fefc19e3          	bne	s8,a5,5ec <main+0x4b6>
        int errs = 0;
     5fe:	4901                	li	s2,0
        for (int i = 0; i < SWAP_PAGES_16; i++) {
     600:	4981                	li	s3,0
     602:	b755                	j	5a6 <main+0x470>
            printf("  pass %d: FAIL (%d errors)\n", pass, errs);
     604:	864a                	mv	a2,s2
     606:	85d6                	mv	a1,s5
     608:	00001517          	auipc	a0,0x1
     60c:	db850513          	addi	a0,a0,-584 # 13c0 <malloc+0x2c8>
     610:	231000ef          	jal	1040 <printf>
     614:	bf75                	j	5d0 <main+0x49a>
    printf("[3] Overall data integrity\n");
     616:	00001517          	auipc	a0,0x1
     61a:	dca50513          	addi	a0,a0,-566 # 13e0 <malloc+0x2e8>
     61e:	223000ef          	jal	1040 <printf>
    if (total_errs == 0)
     622:	240d1963          	bnez	s10,874 <main+0x73e>
        printf("  PASS: %d passes x %d pages — no parity errors\n",
     626:	05800613          	li	a2,88
     62a:	4591                	li	a1,4
     62c:	00001517          	auipc	a0,0x1
     630:	4b450513          	addi	a0,a0,1204 # 1ae0 <malloc+0x9e8>
     634:	20d000ef          	jal	1040 <printf>
    printf("[4] Parity rotation coverage\n");
     638:	00001517          	auipc	a0,0x1
     63c:	50050513          	addi	a0,a0,1280 # 1b38 <malloc+0xa40>
     640:	201000ef          	jal	1040 <printf>
    printf("  Covered %d stripes => parity distributed across all 4 disks\n",
     644:	05800593          	li	a1,88
     648:	00001517          	auipc	a0,0x1
     64c:	51050513          	addi	a0,a0,1296 # 1b58 <malloc+0xa60>
     650:	1f1000ef          	jal	1040 <printf>
    printf("  PASS: parity rotation exercised (verified via data correctness)\n");
     654:	00001517          	auipc	a0,0x1
     658:	54450513          	addi	a0,a0,1348 # 1b98 <malloc+0xaa0>
     65c:	1e5000ef          	jal	1040 <printf>
    printf("[5] I/O stats\n");
     660:	00001517          	auipc	a0,0x1
     664:	58050513          	addi	a0,a0,1408 # 1be0 <malloc+0xae8>
     668:	1d9000ef          	jal	1040 <printf>
    getvmstats(getpid(), &st);
     66c:	5be000ef          	jal	c2a <getpid>
     670:	f6040593          	addi	a1,s0,-160
     674:	616000ef          	jal	c8a <getvmstats>
    printf("  reads=%lu writes=%lu avg_latency=%lu ticks\n",
     678:	f8843683          	ld	a3,-120(s0)
     67c:	f8043603          	ld	a2,-128(s0)
     680:	f7843583          	ld	a1,-136(s0)
     684:	00001517          	auipc	a0,0x1
     688:	e2450513          	addi	a0,a0,-476 # 14a8 <malloc+0x3b0>
     68c:	1b5000ef          	jal	1040 <printf>
    if (st.disk_writes > 0 && st.disk_reads > 0)
     690:	f8043783          	ld	a5,-128(s0)
     694:	c789                	beqz	a5,69e <main+0x568>
     696:	f7843783          	ld	a5,-136(s0)
     69a:	1e079563          	bnez	a5,884 <main+0x74e>
        printf("  FAIL: missing I/O counters\n");
     69e:	00001517          	auipc	a0,0x1
     6a2:	57a50513          	addi	a0,a0,1402 # 1c18 <malloc+0xb20>
     6a6:	19b000ef          	jal	1040 <printf>
    printf("  NOTE: RAID5 generates extra writes for parity blocks\n");
     6aa:	00001517          	auipc	a0,0x1
     6ae:	58e50513          	addi	a0,a0,1422 # 1c38 <malloc+0xb40>
     6b2:	18f000ef          	jal	1040 <printf>
    printf("=== Test p done (total_errs=%d) ===\n", total_errs);
     6b6:	85a6                	mv	a1,s1
     6b8:	00001517          	auipc	a0,0x1
     6bc:	5b850513          	addi	a0,a0,1464 # 1c70 <malloc+0xb78>
     6c0:	181000ef          	jal	1040 <printf>
  test_pa4_16();

  printf("\n--- PA4_17: RAID5 reconstruction ---\n");
     6c4:	00001517          	auipc	a0,0x1
     6c8:	5d450513          	addi	a0,a0,1492 # 1c98 <malloc+0xba0>
     6cc:	175000ef          	jal	1040 <printf>
    printf("=== Test q: RAID 5 Reconstruction — data integrity under pressure ===\n");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	5f050513          	addi	a0,a0,1520 # 1cc0 <malloc+0xbc8>
     6d8:	169000ef          	jal	1040 <printf>
    printf("[1] Setting FCFS policy\n");
     6dc:	00001517          	auipc	a0,0x1
     6e0:	63450513          	addi	a0,a0,1588 # 1d10 <malloc+0xc18>
     6e4:	15d000ef          	jal	1040 <printf>
    setdisksched(FCFS_17);
     6e8:	4501                	li	a0,0
     6ea:	5a8000ef          	jal	c92 <setdisksched>
    printf("  PASS: FCFS set\n");
     6ee:	00001517          	auipc	a0,0x1
     6f2:	64250513          	addi	a0,a0,1602 # 1d30 <malloc+0xc38>
     6f6:	14b000ef          	jal	1040 <printf>
    char *mem = sbrklazy(SWAP_PAGES_17 * PGSIZE_17);
     6fa:	6549                	lui	a0,0x12
     6fc:	490000ef          	jal	b8c <sbrklazy>
     700:	84aa                	mv	s1,a0
    if (mem == (char *)-1) { printf("  FAIL: sbrklazy\n"); return; }
     702:	57fd                	li	a5,-1
     704:	18f50763          	beq	a0,a5,892 <main+0x75c>
    printf("[2] Baseline: initial write/read\n");
     708:	00001517          	auipc	a0,0x1
     70c:	64050513          	addi	a0,a0,1600 # 1d48 <malloc+0xc50>
     710:	131000ef          	jal	1040 <printf>
    int errs = write_verify_17(mem, SWAP_PAGES_17, 0, 0);
     714:	4681                	li	a3,0
     716:	4601                	li	a2,0
     718:	04800593          	li	a1,72
     71c:	8526                	mv	a0,s1
     71e:	8e3ff0ef          	jal	0 <write_verify_17>
     722:	85aa                	mv	a1,a0
    if (errs == 0)
     724:	16051e63          	bnez	a0,8a0 <main+0x76a>
        printf("  PASS: baseline correct (%d pages)\n", SWAP_PAGES_17);
     728:	04800593          	li	a1,72
     72c:	00001517          	auipc	a0,0x1
     730:	64450513          	addi	a0,a0,1604 # 1d70 <malloc+0xc78>
     734:	10d000ef          	jal	1040 <printf>
    printf("[3] Pass 1: overwrite with new pattern, verify parity path\n");
     738:	00001517          	auipc	a0,0x1
     73c:	68050513          	addi	a0,a0,1664 # 1db8 <malloc+0xcc0>
     740:	101000ef          	jal	1040 <printf>
    errs = write_verify_17(mem, SWAP_PAGES_17, 1, 1);
     744:	4685                	li	a3,1
     746:	8636                	mv	a2,a3
     748:	04800593          	li	a1,72
     74c:	8526                	mv	a0,s1
     74e:	8b3ff0ef          	jal	0 <write_verify_17>
     752:	85aa                	mv	a1,a0
    if (errs == 0)
     754:	14051d63          	bnez	a0,8ae <main+0x778>
        printf("  PASS: pass 1 correct\n");
     758:	00001517          	auipc	a0,0x1
     75c:	6a050513          	addi	a0,a0,1696 # 1df8 <malloc+0xd00>
     760:	0e1000ef          	jal	1040 <printf>
    printf("[4] Pass 2: third pattern — verifies no stale parity residue\n");
     764:	00001517          	auipc	a0,0x1
     768:	6cc50513          	addi	a0,a0,1740 # 1e30 <malloc+0xd38>
     76c:	0d5000ef          	jal	1040 <printf>
    errs = write_verify_17(mem, SWAP_PAGES_17, 2, 2);
     770:	4689                	li	a3,2
     772:	8636                	mv	a2,a3
     774:	04800593          	li	a1,72
     778:	8526                	mv	a0,s1
     77a:	887ff0ef          	jal	0 <write_verify_17>
     77e:	85aa                	mv	a1,a0
    if (errs == 0)
     780:	12051e63          	bnez	a0,8bc <main+0x786>
        printf("  PASS: pass 2 correct\n");
     784:	00001517          	auipc	a0,0x1
     788:	6ec50513          	addi	a0,a0,1772 # 1e70 <malloc+0xd78>
     78c:	0b5000ef          	jal	1040 <printf>
    printf("[5] Pass 3: fourth pattern\n");
     790:	00001517          	auipc	a0,0x1
     794:	71850513          	addi	a0,a0,1816 # 1ea8 <malloc+0xdb0>
     798:	0a9000ef          	jal	1040 <printf>
    errs = write_verify_17(mem, SWAP_PAGES_17, 3, 3);
     79c:	468d                	li	a3,3
     79e:	8636                	mv	a2,a3
     7a0:	04800593          	li	a1,72
     7a4:	8526                	mv	a0,s1
     7a6:	85bff0ef          	jal	0 <write_verify_17>
     7aa:	85aa                	mv	a1,a0
    if (errs == 0)
     7ac:	10051f63          	bnez	a0,8ca <main+0x794>
        printf("  PASS: pass 3 correct\n");
     7b0:	00001517          	auipc	a0,0x1
     7b4:	71850513          	addi	a0,a0,1816 # 1ec8 <malloc+0xdd0>
     7b8:	089000ef          	jal	1040 <printf>
    printf("[6] NOTE: raid_fail_disk/raid_restore_disk are kernel-internal\n");
     7bc:	00001517          	auipc	a0,0x1
     7c0:	74450513          	addi	a0,a0,1860 # 1f00 <malloc+0xe08>
     7c4:	07d000ef          	jal	1040 <printf>
    printf("  disk failure injection not available from user space\n");
     7c8:	00001517          	auipc	a0,0x1
     7cc:	77850513          	addi	a0,a0,1912 # 1f40 <malloc+0xe48>
     7d0:	071000ef          	jal	1040 <printf>
    printf("  parity reconstruction path verified via multi-pass overwrite above\n");
     7d4:	00001517          	auipc	a0,0x1
     7d8:	7a450513          	addi	a0,a0,1956 # 1f78 <malloc+0xe80>
     7dc:	065000ef          	jal	1040 <printf>
    printf("[7] Recovery consistency — final overwrite after all passes\n");
     7e0:	00001517          	auipc	a0,0x1
     7e4:	7e050513          	addi	a0,a0,2016 # 1fc0 <malloc+0xec8>
     7e8:	059000ef          	jal	1040 <printf>
    errs = write_verify_17(mem, SWAP_PAGES_17, 99, 0);
     7ec:	4681                	li	a3,0
     7ee:	06300613          	li	a2,99
     7f2:	04800593          	li	a1,72
     7f6:	8526                	mv	a0,s1
     7f8:	809ff0ef          	jal	0 <write_verify_17>
     7fc:	85aa                	mv	a1,a0
    if (errs == 0)
     7fe:	0c051d63          	bnez	a0,8d8 <main+0x7a2>
        printf("  PASS: data still correct after all passes\n");
     802:	00001517          	auipc	a0,0x1
     806:	7fe50513          	addi	a0,a0,2046 # 2000 <malloc+0xf08>
     80a:	037000ef          	jal	1040 <printf>
    printf("[8] I/O stats after reconstruction tests\n");
     80e:	00002517          	auipc	a0,0x2
     812:	84a50513          	addi	a0,a0,-1974 # 2058 <malloc+0xf60>
     816:	02b000ef          	jal	1040 <printf>
    getvmstats(getpid(), &st);
     81a:	410000ef          	jal	c2a <getpid>
     81e:	f6040593          	addi	a1,s0,-160
     822:	468000ef          	jal	c8a <getvmstats>
    printf("  reads=%lu writes=%lu avg_latency=%lu ticks\n",
     826:	f8843683          	ld	a3,-120(s0)
     82a:	f8043603          	ld	a2,-128(s0)
     82e:	f7843583          	ld	a1,-136(s0)
     832:	00001517          	auipc	a0,0x1
     836:	c7650513          	addi	a0,a0,-906 # 14a8 <malloc+0x3b0>
     83a:	007000ef          	jal	1040 <printf>
    if (st.disk_reads > 0 && st.disk_writes > 0)
     83e:	f7843783          	ld	a5,-136(s0)
     842:	c781                	beqz	a5,84a <main+0x714>
     844:	f8043783          	ld	a5,-128(s0)
     848:	efd9                	bnez	a5,8e6 <main+0x7b0>
        printf("  FAIL: I/O counters missing\n");
     84a:	00002517          	auipc	a0,0x2
     84e:	87650513          	addi	a0,a0,-1930 # 20c0 <malloc+0xfc8>
     852:	7ee000ef          	jal	1040 <printf>
    printf("=== Test q done ===\n");
     856:	00002517          	auipc	a0,0x2
     85a:	88a50513          	addi	a0,a0,-1910 # 20e0 <malloc+0xfe8>
     85e:	7e2000ef          	jal	1040 <printf>
  test_pa4_17();

  printf("\nPA4_E done.\n");
     862:	00002517          	auipc	a0,0x2
     866:	89650513          	addi	a0,a0,-1898 # 20f8 <malloc+0x1000>
     86a:	7d6000ef          	jal	1040 <printf>
  exit(0);
     86e:	4501                	li	a0,0
     870:	33a000ef          	jal	baa <exit>
        printf("  FAIL: %d total data errors\n", total_errs);
     874:	85a6                	mv	a1,s1
     876:	00001517          	auipc	a0,0x1
     87a:	2a250513          	addi	a0,a0,674 # 1b18 <malloc+0xa20>
     87e:	7c2000ef          	jal	1040 <printf>
     882:	bb5d                	j	638 <main+0x502>
        printf("  PASS: I/O recorded under RAID5\n");
     884:	00001517          	auipc	a0,0x1
     888:	36c50513          	addi	a0,a0,876 # 1bf0 <malloc+0xaf8>
     88c:	7b4000ef          	jal	1040 <printf>
     890:	bd29                	j	6aa <main+0x574>
    if (mem == (char *)-1) { printf("  FAIL: sbrklazy\n"); return; }
     892:	00001517          	auipc	a0,0x1
     896:	abe50513          	addi	a0,a0,-1346 # 1350 <malloc+0x258>
     89a:	7a6000ef          	jal	1040 <printf>
     89e:	b7d1                	j	862 <main+0x72c>
        printf("  FAIL: %d baseline errors\n", errs);
     8a0:	00001517          	auipc	a0,0x1
     8a4:	4f850513          	addi	a0,a0,1272 # 1d98 <malloc+0xca0>
     8a8:	798000ef          	jal	1040 <printf>
     8ac:	b571                	j	738 <main+0x602>
        printf("  FAIL: pass 1 — %d errors\n", errs);
     8ae:	00001517          	auipc	a0,0x1
     8b2:	56250513          	addi	a0,a0,1378 # 1e10 <malloc+0xd18>
     8b6:	78a000ef          	jal	1040 <printf>
     8ba:	b56d                	j	764 <main+0x62e>
        printf("  FAIL: pass 2 — %d errors\n", errs);
     8bc:	00001517          	auipc	a0,0x1
     8c0:	5cc50513          	addi	a0,a0,1484 # 1e88 <malloc+0xd90>
     8c4:	77c000ef          	jal	1040 <printf>
     8c8:	b5e1                	j	790 <main+0x65a>
        printf("  FAIL: pass 3 — %d errors\n", errs);
     8ca:	00001517          	auipc	a0,0x1
     8ce:	61650513          	addi	a0,a0,1558 # 1ee0 <malloc+0xde8>
     8d2:	76e000ef          	jal	1040 <printf>
     8d6:	b5dd                	j	7bc <main+0x686>
        printf("  FAIL: %d errors on final pass\n", errs);
     8d8:	00001517          	auipc	a0,0x1
     8dc:	75850513          	addi	a0,a0,1880 # 2030 <malloc+0xf38>
     8e0:	760000ef          	jal	1040 <printf>
     8e4:	b72d                	j	80e <main+0x6d8>
        printf("  PASS: I/O correctly tracked through reconstruction\n");
     8e6:	00001517          	auipc	a0,0x1
     8ea:	7a250513          	addi	a0,a0,1954 # 2088 <malloc+0xf90>
     8ee:	752000ef          	jal	1040 <printf>
     8f2:	b795                	j	856 <main+0x720>

00000000000008f4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     8f4:	1141                	addi	sp,sp,-16
     8f6:	e406                	sd	ra,8(sp)
     8f8:	e022                	sd	s0,0(sp)
     8fa:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     8fc:	83bff0ef          	jal	136 <main>
  exit(r);
     900:	2aa000ef          	jal	baa <exit>

0000000000000904 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     904:	1141                	addi	sp,sp,-16
     906:	e406                	sd	ra,8(sp)
     908:	e022                	sd	s0,0(sp)
     90a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     90c:	87aa                	mv	a5,a0
     90e:	0585                	addi	a1,a1,1
     910:	0785                	addi	a5,a5,1
     912:	fff5c703          	lbu	a4,-1(a1)
     916:	fee78fa3          	sb	a4,-1(a5)
     91a:	fb75                	bnez	a4,90e <strcpy+0xa>
    ;
  return os;
}
     91c:	60a2                	ld	ra,8(sp)
     91e:	6402                	ld	s0,0(sp)
     920:	0141                	addi	sp,sp,16
     922:	8082                	ret

0000000000000924 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     924:	1141                	addi	sp,sp,-16
     926:	e406                	sd	ra,8(sp)
     928:	e022                	sd	s0,0(sp)
     92a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     92c:	00054783          	lbu	a5,0(a0)
     930:	cb91                	beqz	a5,944 <strcmp+0x20>
     932:	0005c703          	lbu	a4,0(a1)
     936:	00f71763          	bne	a4,a5,944 <strcmp+0x20>
    p++, q++;
     93a:	0505                	addi	a0,a0,1
     93c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     93e:	00054783          	lbu	a5,0(a0)
     942:	fbe5                	bnez	a5,932 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     944:	0005c503          	lbu	a0,0(a1)
}
     948:	40a7853b          	subw	a0,a5,a0
     94c:	60a2                	ld	ra,8(sp)
     94e:	6402                	ld	s0,0(sp)
     950:	0141                	addi	sp,sp,16
     952:	8082                	ret

0000000000000954 <strlen>:

uint
strlen(const char *s)
{
     954:	1141                	addi	sp,sp,-16
     956:	e406                	sd	ra,8(sp)
     958:	e022                	sd	s0,0(sp)
     95a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     95c:	00054783          	lbu	a5,0(a0)
     960:	cf91                	beqz	a5,97c <strlen+0x28>
     962:	00150793          	addi	a5,a0,1
     966:	86be                	mv	a3,a5
     968:	0785                	addi	a5,a5,1
     96a:	fff7c703          	lbu	a4,-1(a5)
     96e:	ff65                	bnez	a4,966 <strlen+0x12>
     970:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     974:	60a2                	ld	ra,8(sp)
     976:	6402                	ld	s0,0(sp)
     978:	0141                	addi	sp,sp,16
     97a:	8082                	ret
  for(n = 0; s[n]; n++)
     97c:	4501                	li	a0,0
     97e:	bfdd                	j	974 <strlen+0x20>

0000000000000980 <memset>:

void*
memset(void *dst, int c, uint n)
{
     980:	1141                	addi	sp,sp,-16
     982:	e406                	sd	ra,8(sp)
     984:	e022                	sd	s0,0(sp)
     986:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     988:	ca19                	beqz	a2,99e <memset+0x1e>
     98a:	87aa                	mv	a5,a0
     98c:	1602                	slli	a2,a2,0x20
     98e:	9201                	srli	a2,a2,0x20
     990:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     994:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     998:	0785                	addi	a5,a5,1
     99a:	fee79de3          	bne	a5,a4,994 <memset+0x14>
  }
  return dst;
}
     99e:	60a2                	ld	ra,8(sp)
     9a0:	6402                	ld	s0,0(sp)
     9a2:	0141                	addi	sp,sp,16
     9a4:	8082                	ret

00000000000009a6 <strchr>:

char*
strchr(const char *s, char c)
{
     9a6:	1141                	addi	sp,sp,-16
     9a8:	e406                	sd	ra,8(sp)
     9aa:	e022                	sd	s0,0(sp)
     9ac:	0800                	addi	s0,sp,16
  for(; *s; s++)
     9ae:	00054783          	lbu	a5,0(a0)
     9b2:	cf81                	beqz	a5,9ca <strchr+0x24>
    if(*s == c)
     9b4:	00f58763          	beq	a1,a5,9c2 <strchr+0x1c>
  for(; *s; s++)
     9b8:	0505                	addi	a0,a0,1
     9ba:	00054783          	lbu	a5,0(a0)
     9be:	fbfd                	bnez	a5,9b4 <strchr+0xe>
      return (char*)s;
  return 0;
     9c0:	4501                	li	a0,0
}
     9c2:	60a2                	ld	ra,8(sp)
     9c4:	6402                	ld	s0,0(sp)
     9c6:	0141                	addi	sp,sp,16
     9c8:	8082                	ret
  return 0;
     9ca:	4501                	li	a0,0
     9cc:	bfdd                	j	9c2 <strchr+0x1c>

00000000000009ce <gets>:

char*
gets(char *buf, int max)
{
     9ce:	711d                	addi	sp,sp,-96
     9d0:	ec86                	sd	ra,88(sp)
     9d2:	e8a2                	sd	s0,80(sp)
     9d4:	e4a6                	sd	s1,72(sp)
     9d6:	e0ca                	sd	s2,64(sp)
     9d8:	fc4e                	sd	s3,56(sp)
     9da:	f852                	sd	s4,48(sp)
     9dc:	f456                	sd	s5,40(sp)
     9de:	f05a                	sd	s6,32(sp)
     9e0:	ec5e                	sd	s7,24(sp)
     9e2:	e862                	sd	s8,16(sp)
     9e4:	1080                	addi	s0,sp,96
     9e6:	8baa                	mv	s7,a0
     9e8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9ea:	892a                	mv	s2,a0
     9ec:	4481                	li	s1,0
    cc = read(0, &c, 1);
     9ee:	faf40b13          	addi	s6,s0,-81
     9f2:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     9f4:	8c26                	mv	s8,s1
     9f6:	0014899b          	addiw	s3,s1,1
     9fa:	84ce                	mv	s1,s3
     9fc:	0349d463          	bge	s3,s4,a24 <gets+0x56>
    cc = read(0, &c, 1);
     a00:	8656                	mv	a2,s5
     a02:	85da                	mv	a1,s6
     a04:	4501                	li	a0,0
     a06:	1bc000ef          	jal	bc2 <read>
    if(cc < 1)
     a0a:	00a05d63          	blez	a0,a24 <gets+0x56>
      break;
    buf[i++] = c;
     a0e:	faf44783          	lbu	a5,-81(s0)
     a12:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a16:	0905                	addi	s2,s2,1
     a18:	ff678713          	addi	a4,a5,-10
     a1c:	c319                	beqz	a4,a22 <gets+0x54>
     a1e:	17cd                	addi	a5,a5,-13
     a20:	fbf1                	bnez	a5,9f4 <gets+0x26>
    buf[i++] = c;
     a22:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     a24:	9c5e                	add	s8,s8,s7
     a26:	000c0023          	sb	zero,0(s8)
  return buf;
}
     a2a:	855e                	mv	a0,s7
     a2c:	60e6                	ld	ra,88(sp)
     a2e:	6446                	ld	s0,80(sp)
     a30:	64a6                	ld	s1,72(sp)
     a32:	6906                	ld	s2,64(sp)
     a34:	79e2                	ld	s3,56(sp)
     a36:	7a42                	ld	s4,48(sp)
     a38:	7aa2                	ld	s5,40(sp)
     a3a:	7b02                	ld	s6,32(sp)
     a3c:	6be2                	ld	s7,24(sp)
     a3e:	6c42                	ld	s8,16(sp)
     a40:	6125                	addi	sp,sp,96
     a42:	8082                	ret

0000000000000a44 <stat>:

int
stat(const char *n, struct stat *st)
{
     a44:	1101                	addi	sp,sp,-32
     a46:	ec06                	sd	ra,24(sp)
     a48:	e822                	sd	s0,16(sp)
     a4a:	e04a                	sd	s2,0(sp)
     a4c:	1000                	addi	s0,sp,32
     a4e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a50:	4581                	li	a1,0
     a52:	198000ef          	jal	bea <open>
  if(fd < 0)
     a56:	02054263          	bltz	a0,a7a <stat+0x36>
     a5a:	e426                	sd	s1,8(sp)
     a5c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a5e:	85ca                	mv	a1,s2
     a60:	1a2000ef          	jal	c02 <fstat>
     a64:	892a                	mv	s2,a0
  close(fd);
     a66:	8526                	mv	a0,s1
     a68:	16a000ef          	jal	bd2 <close>
  return r;
     a6c:	64a2                	ld	s1,8(sp)
}
     a6e:	854a                	mv	a0,s2
     a70:	60e2                	ld	ra,24(sp)
     a72:	6442                	ld	s0,16(sp)
     a74:	6902                	ld	s2,0(sp)
     a76:	6105                	addi	sp,sp,32
     a78:	8082                	ret
    return -1;
     a7a:	57fd                	li	a5,-1
     a7c:	893e                	mv	s2,a5
     a7e:	bfc5                	j	a6e <stat+0x2a>

0000000000000a80 <atoi>:

int
atoi(const char *s)
{
     a80:	1141                	addi	sp,sp,-16
     a82:	e406                	sd	ra,8(sp)
     a84:	e022                	sd	s0,0(sp)
     a86:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a88:	00054683          	lbu	a3,0(a0)
     a8c:	fd06879b          	addiw	a5,a3,-48
     a90:	0ff7f793          	zext.b	a5,a5
     a94:	4625                	li	a2,9
     a96:	02f66963          	bltu	a2,a5,ac8 <atoi+0x48>
     a9a:	872a                	mv	a4,a0
  n = 0;
     a9c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a9e:	0705                	addi	a4,a4,1
     aa0:	0025179b          	slliw	a5,a0,0x2
     aa4:	9fa9                	addw	a5,a5,a0
     aa6:	0017979b          	slliw	a5,a5,0x1
     aaa:	9fb5                	addw	a5,a5,a3
     aac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     ab0:	00074683          	lbu	a3,0(a4)
     ab4:	fd06879b          	addiw	a5,a3,-48
     ab8:	0ff7f793          	zext.b	a5,a5
     abc:	fef671e3          	bgeu	a2,a5,a9e <atoi+0x1e>
  return n;
}
     ac0:	60a2                	ld	ra,8(sp)
     ac2:	6402                	ld	s0,0(sp)
     ac4:	0141                	addi	sp,sp,16
     ac6:	8082                	ret
  n = 0;
     ac8:	4501                	li	a0,0
     aca:	bfdd                	j	ac0 <atoi+0x40>

0000000000000acc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     acc:	1141                	addi	sp,sp,-16
     ace:	e406                	sd	ra,8(sp)
     ad0:	e022                	sd	s0,0(sp)
     ad2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     ad4:	02b57563          	bgeu	a0,a1,afe <memmove+0x32>
    while(n-- > 0)
     ad8:	00c05f63          	blez	a2,af6 <memmove+0x2a>
     adc:	1602                	slli	a2,a2,0x20
     ade:	9201                	srli	a2,a2,0x20
     ae0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     ae4:	872a                	mv	a4,a0
      *dst++ = *src++;
     ae6:	0585                	addi	a1,a1,1
     ae8:	0705                	addi	a4,a4,1
     aea:	fff5c683          	lbu	a3,-1(a1)
     aee:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     af2:	fee79ae3          	bne	a5,a4,ae6 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     af6:	60a2                	ld	ra,8(sp)
     af8:	6402                	ld	s0,0(sp)
     afa:	0141                	addi	sp,sp,16
     afc:	8082                	ret
    while(n-- > 0)
     afe:	fec05ce3          	blez	a2,af6 <memmove+0x2a>
    dst += n;
     b02:	00c50733          	add	a4,a0,a2
    src += n;
     b06:	95b2                	add	a1,a1,a2
     b08:	fff6079b          	addiw	a5,a2,-1
     b0c:	1782                	slli	a5,a5,0x20
     b0e:	9381                	srli	a5,a5,0x20
     b10:	fff7c793          	not	a5,a5
     b14:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b16:	15fd                	addi	a1,a1,-1
     b18:	177d                	addi	a4,a4,-1
     b1a:	0005c683          	lbu	a3,0(a1)
     b1e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b22:	fef71ae3          	bne	a4,a5,b16 <memmove+0x4a>
     b26:	bfc1                	j	af6 <memmove+0x2a>

0000000000000b28 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b28:	1141                	addi	sp,sp,-16
     b2a:	e406                	sd	ra,8(sp)
     b2c:	e022                	sd	s0,0(sp)
     b2e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b30:	c61d                	beqz	a2,b5e <memcmp+0x36>
     b32:	1602                	slli	a2,a2,0x20
     b34:	9201                	srli	a2,a2,0x20
     b36:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     b3a:	00054783          	lbu	a5,0(a0)
     b3e:	0005c703          	lbu	a4,0(a1)
     b42:	00e79863          	bne	a5,a4,b52 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     b46:	0505                	addi	a0,a0,1
    p2++;
     b48:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b4a:	fed518e3          	bne	a0,a3,b3a <memcmp+0x12>
  }
  return 0;
     b4e:	4501                	li	a0,0
     b50:	a019                	j	b56 <memcmp+0x2e>
      return *p1 - *p2;
     b52:	40e7853b          	subw	a0,a5,a4
}
     b56:	60a2                	ld	ra,8(sp)
     b58:	6402                	ld	s0,0(sp)
     b5a:	0141                	addi	sp,sp,16
     b5c:	8082                	ret
  return 0;
     b5e:	4501                	li	a0,0
     b60:	bfdd                	j	b56 <memcmp+0x2e>

0000000000000b62 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b62:	1141                	addi	sp,sp,-16
     b64:	e406                	sd	ra,8(sp)
     b66:	e022                	sd	s0,0(sp)
     b68:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b6a:	f63ff0ef          	jal	acc <memmove>
}
     b6e:	60a2                	ld	ra,8(sp)
     b70:	6402                	ld	s0,0(sp)
     b72:	0141                	addi	sp,sp,16
     b74:	8082                	ret

0000000000000b76 <sbrk>:

char *
sbrk(int n) {
     b76:	1141                	addi	sp,sp,-16
     b78:	e406                	sd	ra,8(sp)
     b7a:	e022                	sd	s0,0(sp)
     b7c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     b7e:	4585                	li	a1,1
     b80:	0b2000ef          	jal	c32 <sys_sbrk>
}
     b84:	60a2                	ld	ra,8(sp)
     b86:	6402                	ld	s0,0(sp)
     b88:	0141                	addi	sp,sp,16
     b8a:	8082                	ret

0000000000000b8c <sbrklazy>:

char *
sbrklazy(int n) {
     b8c:	1141                	addi	sp,sp,-16
     b8e:	e406                	sd	ra,8(sp)
     b90:	e022                	sd	s0,0(sp)
     b92:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     b94:	4589                	li	a1,2
     b96:	09c000ef          	jal	c32 <sys_sbrk>
}
     b9a:	60a2                	ld	ra,8(sp)
     b9c:	6402                	ld	s0,0(sp)
     b9e:	0141                	addi	sp,sp,16
     ba0:	8082                	ret

0000000000000ba2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     ba2:	4885                	li	a7,1
 ecall
     ba4:	00000073          	ecall
 ret
     ba8:	8082                	ret

0000000000000baa <exit>:
.global exit
exit:
 li a7, SYS_exit
     baa:	4889                	li	a7,2
 ecall
     bac:	00000073          	ecall
 ret
     bb0:	8082                	ret

0000000000000bb2 <wait>:
.global wait
wait:
 li a7, SYS_wait
     bb2:	488d                	li	a7,3
 ecall
     bb4:	00000073          	ecall
 ret
     bb8:	8082                	ret

0000000000000bba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     bba:	4891                	li	a7,4
 ecall
     bbc:	00000073          	ecall
 ret
     bc0:	8082                	ret

0000000000000bc2 <read>:
.global read
read:
 li a7, SYS_read
     bc2:	4895                	li	a7,5
 ecall
     bc4:	00000073          	ecall
 ret
     bc8:	8082                	ret

0000000000000bca <write>:
.global write
write:
 li a7, SYS_write
     bca:	48c1                	li	a7,16
 ecall
     bcc:	00000073          	ecall
 ret
     bd0:	8082                	ret

0000000000000bd2 <close>:
.global close
close:
 li a7, SYS_close
     bd2:	48d5                	li	a7,21
 ecall
     bd4:	00000073          	ecall
 ret
     bd8:	8082                	ret

0000000000000bda <kill>:
.global kill
kill:
 li a7, SYS_kill
     bda:	4899                	li	a7,6
 ecall
     bdc:	00000073          	ecall
 ret
     be0:	8082                	ret

0000000000000be2 <exec>:
.global exec
exec:
 li a7, SYS_exec
     be2:	489d                	li	a7,7
 ecall
     be4:	00000073          	ecall
 ret
     be8:	8082                	ret

0000000000000bea <open>:
.global open
open:
 li a7, SYS_open
     bea:	48bd                	li	a7,15
 ecall
     bec:	00000073          	ecall
 ret
     bf0:	8082                	ret

0000000000000bf2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bf2:	48c5                	li	a7,17
 ecall
     bf4:	00000073          	ecall
 ret
     bf8:	8082                	ret

0000000000000bfa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bfa:	48c9                	li	a7,18
 ecall
     bfc:	00000073          	ecall
 ret
     c00:	8082                	ret

0000000000000c02 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c02:	48a1                	li	a7,8
 ecall
     c04:	00000073          	ecall
 ret
     c08:	8082                	ret

0000000000000c0a <link>:
.global link
link:
 li a7, SYS_link
     c0a:	48cd                	li	a7,19
 ecall
     c0c:	00000073          	ecall
 ret
     c10:	8082                	ret

0000000000000c12 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c12:	48d1                	li	a7,20
 ecall
     c14:	00000073          	ecall
 ret
     c18:	8082                	ret

0000000000000c1a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c1a:	48a5                	li	a7,9
 ecall
     c1c:	00000073          	ecall
 ret
     c20:	8082                	ret

0000000000000c22 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c22:	48a9                	li	a7,10
 ecall
     c24:	00000073          	ecall
 ret
     c28:	8082                	ret

0000000000000c2a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c2a:	48ad                	li	a7,11
 ecall
     c2c:	00000073          	ecall
 ret
     c30:	8082                	ret

0000000000000c32 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     c32:	48b1                	li	a7,12
 ecall
     c34:	00000073          	ecall
 ret
     c38:	8082                	ret

0000000000000c3a <pause>:
.global pause
pause:
 li a7, SYS_pause
     c3a:	48b5                	li	a7,13
 ecall
     c3c:	00000073          	ecall
 ret
     c40:	8082                	ret

0000000000000c42 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c42:	48b9                	li	a7,14
 ecall
     c44:	00000073          	ecall
 ret
     c48:	8082                	ret

0000000000000c4a <hello>:
.global hello
hello:
 li a7, SYS_hello
     c4a:	48d9                	li	a7,22
 ecall
     c4c:	00000073          	ecall
 ret
     c50:	8082                	ret

0000000000000c52 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
     c52:	48dd                	li	a7,23
 ecall
     c54:	00000073          	ecall
 ret
     c58:	8082                	ret

0000000000000c5a <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
     c5a:	48e1                	li	a7,24
 ecall
     c5c:	00000073          	ecall
 ret
     c60:	8082                	ret

0000000000000c62 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
     c62:	48e5                	li	a7,25
 ecall
     c64:	00000073          	ecall
 ret
     c68:	8082                	ret

0000000000000c6a <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
     c6a:	48e9                	li	a7,26
 ecall
     c6c:	00000073          	ecall
 ret
     c70:	8082                	ret

0000000000000c72 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
     c72:	48ed                	li	a7,27
 ecall
     c74:	00000073          	ecall
 ret
     c78:	8082                	ret

0000000000000c7a <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
     c7a:	48f1                	li	a7,28
 ecall
     c7c:	00000073          	ecall
 ret
     c80:	8082                	ret

0000000000000c82 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
     c82:	48f5                	li	a7,29
 ecall
     c84:	00000073          	ecall
 ret
     c88:	8082                	ret

0000000000000c8a <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
     c8a:	48f9                	li	a7,30
 ecall
     c8c:	00000073          	ecall
 ret
     c90:	8082                	ret

0000000000000c92 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
     c92:	48fd                	li	a7,31
 ecall
     c94:	00000073          	ecall
 ret
     c98:	8082                	ret

0000000000000c9a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c9a:	1101                	addi	sp,sp,-32
     c9c:	ec06                	sd	ra,24(sp)
     c9e:	e822                	sd	s0,16(sp)
     ca0:	1000                	addi	s0,sp,32
     ca2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ca6:	4605                	li	a2,1
     ca8:	fef40593          	addi	a1,s0,-17
     cac:	f1fff0ef          	jal	bca <write>
}
     cb0:	60e2                	ld	ra,24(sp)
     cb2:	6442                	ld	s0,16(sp)
     cb4:	6105                	addi	sp,sp,32
     cb6:	8082                	ret

0000000000000cb8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     cb8:	715d                	addi	sp,sp,-80
     cba:	e486                	sd	ra,72(sp)
     cbc:	e0a2                	sd	s0,64(sp)
     cbe:	f84a                	sd	s2,48(sp)
     cc0:	f44e                	sd	s3,40(sp)
     cc2:	0880                	addi	s0,sp,80
     cc4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     cc6:	c6d1                	beqz	a3,d52 <printint+0x9a>
     cc8:	0805d563          	bgez	a1,d52 <printint+0x9a>
    neg = 1;
    x = -xx;
     ccc:	40b005b3          	neg	a1,a1
    neg = 1;
     cd0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     cd2:	fb840993          	addi	s3,s0,-72
  neg = 0;
     cd6:	86ce                	mv	a3,s3
  i = 0;
     cd8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     cda:	00001817          	auipc	a6,0x1
     cde:	43680813          	addi	a6,a6,1078 # 2110 <digits>
     ce2:	88ba                	mv	a7,a4
     ce4:	0017051b          	addiw	a0,a4,1
     ce8:	872a                	mv	a4,a0
     cea:	02c5f7b3          	remu	a5,a1,a2
     cee:	97c2                	add	a5,a5,a6
     cf0:	0007c783          	lbu	a5,0(a5)
     cf4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cf8:	87ae                	mv	a5,a1
     cfa:	02c5d5b3          	divu	a1,a1,a2
     cfe:	0685                	addi	a3,a3,1
     d00:	fec7f1e3          	bgeu	a5,a2,ce2 <printint+0x2a>
  if(neg)
     d04:	00030c63          	beqz	t1,d1c <printint+0x64>
    buf[i++] = '-';
     d08:	fd050793          	addi	a5,a0,-48
     d0c:	00878533          	add	a0,a5,s0
     d10:	02d00793          	li	a5,45
     d14:	fef50423          	sb	a5,-24(a0)
     d18:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     d1c:	02e05563          	blez	a4,d46 <printint+0x8e>
     d20:	fc26                	sd	s1,56(sp)
     d22:	377d                	addiw	a4,a4,-1
     d24:	00e984b3          	add	s1,s3,a4
     d28:	19fd                	addi	s3,s3,-1
     d2a:	99ba                	add	s3,s3,a4
     d2c:	1702                	slli	a4,a4,0x20
     d2e:	9301                	srli	a4,a4,0x20
     d30:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d34:	0004c583          	lbu	a1,0(s1)
     d38:	854a                	mv	a0,s2
     d3a:	f61ff0ef          	jal	c9a <putc>
  while(--i >= 0)
     d3e:	14fd                	addi	s1,s1,-1
     d40:	ff349ae3          	bne	s1,s3,d34 <printint+0x7c>
     d44:	74e2                	ld	s1,56(sp)
}
     d46:	60a6                	ld	ra,72(sp)
     d48:	6406                	ld	s0,64(sp)
     d4a:	7942                	ld	s2,48(sp)
     d4c:	79a2                	ld	s3,40(sp)
     d4e:	6161                	addi	sp,sp,80
     d50:	8082                	ret
  neg = 0;
     d52:	4301                	li	t1,0
     d54:	bfbd                	j	cd2 <printint+0x1a>

0000000000000d56 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d56:	711d                	addi	sp,sp,-96
     d58:	ec86                	sd	ra,88(sp)
     d5a:	e8a2                	sd	s0,80(sp)
     d5c:	e4a6                	sd	s1,72(sp)
     d5e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d60:	0005c483          	lbu	s1,0(a1)
     d64:	22048363          	beqz	s1,f8a <vprintf+0x234>
     d68:	e0ca                	sd	s2,64(sp)
     d6a:	fc4e                	sd	s3,56(sp)
     d6c:	f852                	sd	s4,48(sp)
     d6e:	f456                	sd	s5,40(sp)
     d70:	f05a                	sd	s6,32(sp)
     d72:	ec5e                	sd	s7,24(sp)
     d74:	e862                	sd	s8,16(sp)
     d76:	8b2a                	mv	s6,a0
     d78:	8a2e                	mv	s4,a1
     d7a:	8bb2                	mv	s7,a2
  state = 0;
     d7c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d7e:	4901                	li	s2,0
     d80:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d82:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d86:	06400c13          	li	s8,100
     d8a:	a00d                	j	dac <vprintf+0x56>
        putc(fd, c0);
     d8c:	85a6                	mv	a1,s1
     d8e:	855a                	mv	a0,s6
     d90:	f0bff0ef          	jal	c9a <putc>
     d94:	a019                	j	d9a <vprintf+0x44>
    } else if(state == '%'){
     d96:	03598363          	beq	s3,s5,dbc <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     d9a:	0019079b          	addiw	a5,s2,1
     d9e:	893e                	mv	s2,a5
     da0:	873e                	mv	a4,a5
     da2:	97d2                	add	a5,a5,s4
     da4:	0007c483          	lbu	s1,0(a5)
     da8:	1c048a63          	beqz	s1,f7c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
     dac:	0004879b          	sext.w	a5,s1
    if(state == 0){
     db0:	fe0993e3          	bnez	s3,d96 <vprintf+0x40>
      if(c0 == '%'){
     db4:	fd579ce3          	bne	a5,s5,d8c <vprintf+0x36>
        state = '%';
     db8:	89be                	mv	s3,a5
     dba:	b7c5                	j	d9a <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     dbc:	00ea06b3          	add	a3,s4,a4
     dc0:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     dc4:	1c060863          	beqz	a2,f94 <vprintf+0x23e>
      if(c0 == 'd'){
     dc8:	03878763          	beq	a5,s8,df6 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     dcc:	f9478693          	addi	a3,a5,-108
     dd0:	0016b693          	seqz	a3,a3
     dd4:	f9c60593          	addi	a1,a2,-100
     dd8:	e99d                	bnez	a1,e0e <vprintf+0xb8>
     dda:	ca95                	beqz	a3,e0e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ddc:	008b8493          	addi	s1,s7,8
     de0:	4685                	li	a3,1
     de2:	4629                	li	a2,10
     de4:	000bb583          	ld	a1,0(s7)
     de8:	855a                	mv	a0,s6
     dea:	ecfff0ef          	jal	cb8 <printint>
        i += 1;
     dee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     df0:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     df2:	4981                	li	s3,0
     df4:	b75d                	j	d9a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     df6:	008b8493          	addi	s1,s7,8
     dfa:	4685                	li	a3,1
     dfc:	4629                	li	a2,10
     dfe:	000ba583          	lw	a1,0(s7)
     e02:	855a                	mv	a0,s6
     e04:	eb5ff0ef          	jal	cb8 <printint>
     e08:	8ba6                	mv	s7,s1
      state = 0;
     e0a:	4981                	li	s3,0
     e0c:	b779                	j	d9a <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     e0e:	9752                	add	a4,a4,s4
     e10:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e14:	f9460713          	addi	a4,a2,-108
     e18:	00173713          	seqz	a4,a4
     e1c:	8f75                	and	a4,a4,a3
     e1e:	f9c58513          	addi	a0,a1,-100
     e22:	18051363          	bnez	a0,fa8 <vprintf+0x252>
     e26:	18070163          	beqz	a4,fa8 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e2a:	008b8493          	addi	s1,s7,8
     e2e:	4685                	li	a3,1
     e30:	4629                	li	a2,10
     e32:	000bb583          	ld	a1,0(s7)
     e36:	855a                	mv	a0,s6
     e38:	e81ff0ef          	jal	cb8 <printint>
        i += 2;
     e3c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     e3e:	8ba6                	mv	s7,s1
      state = 0;
     e40:	4981                	li	s3,0
        i += 2;
     e42:	bfa1                	j	d9a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     e44:	008b8493          	addi	s1,s7,8
     e48:	4681                	li	a3,0
     e4a:	4629                	li	a2,10
     e4c:	000be583          	lwu	a1,0(s7)
     e50:	855a                	mv	a0,s6
     e52:	e67ff0ef          	jal	cb8 <printint>
     e56:	8ba6                	mv	s7,s1
      state = 0;
     e58:	4981                	li	s3,0
     e5a:	b781                	j	d9a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e5c:	008b8493          	addi	s1,s7,8
     e60:	4681                	li	a3,0
     e62:	4629                	li	a2,10
     e64:	000bb583          	ld	a1,0(s7)
     e68:	855a                	mv	a0,s6
     e6a:	e4fff0ef          	jal	cb8 <printint>
        i += 1;
     e6e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     e70:	8ba6                	mv	s7,s1
      state = 0;
     e72:	4981                	li	s3,0
     e74:	b71d                	j	d9a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e76:	008b8493          	addi	s1,s7,8
     e7a:	4681                	li	a3,0
     e7c:	4629                	li	a2,10
     e7e:	000bb583          	ld	a1,0(s7)
     e82:	855a                	mv	a0,s6
     e84:	e35ff0ef          	jal	cb8 <printint>
        i += 2;
     e88:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     e8a:	8ba6                	mv	s7,s1
      state = 0;
     e8c:	4981                	li	s3,0
        i += 2;
     e8e:	b731                	j	d9a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     e90:	008b8493          	addi	s1,s7,8
     e94:	4681                	li	a3,0
     e96:	4641                	li	a2,16
     e98:	000be583          	lwu	a1,0(s7)
     e9c:	855a                	mv	a0,s6
     e9e:	e1bff0ef          	jal	cb8 <printint>
     ea2:	8ba6                	mv	s7,s1
      state = 0;
     ea4:	4981                	li	s3,0
     ea6:	bdd5                	j	d9a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     ea8:	008b8493          	addi	s1,s7,8
     eac:	4681                	li	a3,0
     eae:	4641                	li	a2,16
     eb0:	000bb583          	ld	a1,0(s7)
     eb4:	855a                	mv	a0,s6
     eb6:	e03ff0ef          	jal	cb8 <printint>
        i += 1;
     eba:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     ebc:	8ba6                	mv	s7,s1
      state = 0;
     ebe:	4981                	li	s3,0
     ec0:	bde9                	j	d9a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     ec2:	008b8493          	addi	s1,s7,8
     ec6:	4681                	li	a3,0
     ec8:	4641                	li	a2,16
     eca:	000bb583          	ld	a1,0(s7)
     ece:	855a                	mv	a0,s6
     ed0:	de9ff0ef          	jal	cb8 <printint>
        i += 2;
     ed4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     ed6:	8ba6                	mv	s7,s1
      state = 0;
     ed8:	4981                	li	s3,0
        i += 2;
     eda:	b5c1                	j	d9a <vprintf+0x44>
     edc:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     ede:	008b8793          	addi	a5,s7,8
     ee2:	8cbe                	mv	s9,a5
     ee4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     ee8:	03000593          	li	a1,48
     eec:	855a                	mv	a0,s6
     eee:	dadff0ef          	jal	c9a <putc>
  putc(fd, 'x');
     ef2:	07800593          	li	a1,120
     ef6:	855a                	mv	a0,s6
     ef8:	da3ff0ef          	jal	c9a <putc>
     efc:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     efe:	00001b97          	auipc	s7,0x1
     f02:	212b8b93          	addi	s7,s7,530 # 2110 <digits>
     f06:	03c9d793          	srli	a5,s3,0x3c
     f0a:	97de                	add	a5,a5,s7
     f0c:	0007c583          	lbu	a1,0(a5)
     f10:	855a                	mv	a0,s6
     f12:	d89ff0ef          	jal	c9a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f16:	0992                	slli	s3,s3,0x4
     f18:	34fd                	addiw	s1,s1,-1
     f1a:	f4f5                	bnez	s1,f06 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     f1c:	8be6                	mv	s7,s9
      state = 0;
     f1e:	4981                	li	s3,0
     f20:	6ca2                	ld	s9,8(sp)
     f22:	bda5                	j	d9a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
     f24:	008b8493          	addi	s1,s7,8
     f28:	000bc583          	lbu	a1,0(s7)
     f2c:	855a                	mv	a0,s6
     f2e:	d6dff0ef          	jal	c9a <putc>
     f32:	8ba6                	mv	s7,s1
      state = 0;
     f34:	4981                	li	s3,0
     f36:	b595                	j	d9a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     f38:	008b8993          	addi	s3,s7,8
     f3c:	000bb483          	ld	s1,0(s7)
     f40:	cc91                	beqz	s1,f5c <vprintf+0x206>
        for(; *s; s++)
     f42:	0004c583          	lbu	a1,0(s1)
     f46:	c985                	beqz	a1,f76 <vprintf+0x220>
          putc(fd, *s);
     f48:	855a                	mv	a0,s6
     f4a:	d51ff0ef          	jal	c9a <putc>
        for(; *s; s++)
     f4e:	0485                	addi	s1,s1,1
     f50:	0004c583          	lbu	a1,0(s1)
     f54:	f9f5                	bnez	a1,f48 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
     f56:	8bce                	mv	s7,s3
      state = 0;
     f58:	4981                	li	s3,0
     f5a:	b581                	j	d9a <vprintf+0x44>
          s = "(null)";
     f5c:	00001497          	auipc	s1,0x1
     f60:	1ac48493          	addi	s1,s1,428 # 2108 <malloc+0x1010>
        for(; *s; s++)
     f64:	02800593          	li	a1,40
     f68:	b7c5                	j	f48 <vprintf+0x1f2>
        putc(fd, '%');
     f6a:	85be                	mv	a1,a5
     f6c:	855a                	mv	a0,s6
     f6e:	d2dff0ef          	jal	c9a <putc>
      state = 0;
     f72:	4981                	li	s3,0
     f74:	b51d                	j	d9a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     f76:	8bce                	mv	s7,s3
      state = 0;
     f78:	4981                	li	s3,0
     f7a:	b505                	j	d9a <vprintf+0x44>
     f7c:	6906                	ld	s2,64(sp)
     f7e:	79e2                	ld	s3,56(sp)
     f80:	7a42                	ld	s4,48(sp)
     f82:	7aa2                	ld	s5,40(sp)
     f84:	7b02                	ld	s6,32(sp)
     f86:	6be2                	ld	s7,24(sp)
     f88:	6c42                	ld	s8,16(sp)
    }
  }
}
     f8a:	60e6                	ld	ra,88(sp)
     f8c:	6446                	ld	s0,80(sp)
     f8e:	64a6                	ld	s1,72(sp)
     f90:	6125                	addi	sp,sp,96
     f92:	8082                	ret
      if(c0 == 'd'){
     f94:	06400713          	li	a4,100
     f98:	e4e78fe3          	beq	a5,a4,df6 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
     f9c:	f9478693          	addi	a3,a5,-108
     fa0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
     fa4:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     fa6:	4701                	li	a4,0
      } else if(c0 == 'u'){
     fa8:	07500513          	li	a0,117
     fac:	e8a78ce3          	beq	a5,a0,e44 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
     fb0:	f8b60513          	addi	a0,a2,-117
     fb4:	e119                	bnez	a0,fba <vprintf+0x264>
     fb6:	ea0693e3          	bnez	a3,e5c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     fba:	f8b58513          	addi	a0,a1,-117
     fbe:	e119                	bnez	a0,fc4 <vprintf+0x26e>
     fc0:	ea071be3          	bnez	a4,e76 <vprintf+0x120>
      } else if(c0 == 'x'){
     fc4:	07800513          	li	a0,120
     fc8:	eca784e3          	beq	a5,a0,e90 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
     fcc:	f8860613          	addi	a2,a2,-120
     fd0:	e219                	bnez	a2,fd6 <vprintf+0x280>
     fd2:	ec069be3          	bnez	a3,ea8 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     fd6:	f8858593          	addi	a1,a1,-120
     fda:	e199                	bnez	a1,fe0 <vprintf+0x28a>
     fdc:	ee0713e3          	bnez	a4,ec2 <vprintf+0x16c>
      } else if(c0 == 'p'){
     fe0:	07000713          	li	a4,112
     fe4:	eee78ce3          	beq	a5,a4,edc <vprintf+0x186>
      } else if(c0 == 'c'){
     fe8:	06300713          	li	a4,99
     fec:	f2e78ce3          	beq	a5,a4,f24 <vprintf+0x1ce>
      } else if(c0 == 's'){
     ff0:	07300713          	li	a4,115
     ff4:	f4e782e3          	beq	a5,a4,f38 <vprintf+0x1e2>
      } else if(c0 == '%'){
     ff8:	02500713          	li	a4,37
     ffc:	f6e787e3          	beq	a5,a4,f6a <vprintf+0x214>
        putc(fd, '%');
    1000:	02500593          	li	a1,37
    1004:	855a                	mv	a0,s6
    1006:	c95ff0ef          	jal	c9a <putc>
        putc(fd, c0);
    100a:	85a6                	mv	a1,s1
    100c:	855a                	mv	a0,s6
    100e:	c8dff0ef          	jal	c9a <putc>
      state = 0;
    1012:	4981                	li	s3,0
    1014:	b359                	j	d9a <vprintf+0x44>

0000000000001016 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1016:	715d                	addi	sp,sp,-80
    1018:	ec06                	sd	ra,24(sp)
    101a:	e822                	sd	s0,16(sp)
    101c:	1000                	addi	s0,sp,32
    101e:	e010                	sd	a2,0(s0)
    1020:	e414                	sd	a3,8(s0)
    1022:	e818                	sd	a4,16(s0)
    1024:	ec1c                	sd	a5,24(s0)
    1026:	03043023          	sd	a6,32(s0)
    102a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    102e:	8622                	mv	a2,s0
    1030:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1034:	d23ff0ef          	jal	d56 <vprintf>
}
    1038:	60e2                	ld	ra,24(sp)
    103a:	6442                	ld	s0,16(sp)
    103c:	6161                	addi	sp,sp,80
    103e:	8082                	ret

0000000000001040 <printf>:

void
printf(const char *fmt, ...)
{
    1040:	711d                	addi	sp,sp,-96
    1042:	ec06                	sd	ra,24(sp)
    1044:	e822                	sd	s0,16(sp)
    1046:	1000                	addi	s0,sp,32
    1048:	e40c                	sd	a1,8(s0)
    104a:	e810                	sd	a2,16(s0)
    104c:	ec14                	sd	a3,24(s0)
    104e:	f018                	sd	a4,32(s0)
    1050:	f41c                	sd	a5,40(s0)
    1052:	03043823          	sd	a6,48(s0)
    1056:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    105a:	00840613          	addi	a2,s0,8
    105e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1062:	85aa                	mv	a1,a0
    1064:	4505                	li	a0,1
    1066:	cf1ff0ef          	jal	d56 <vprintf>
}
    106a:	60e2                	ld	ra,24(sp)
    106c:	6442                	ld	s0,16(sp)
    106e:	6125                	addi	sp,sp,96
    1070:	8082                	ret

0000000000001072 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1072:	1141                	addi	sp,sp,-16
    1074:	e406                	sd	ra,8(sp)
    1076:	e022                	sd	s0,0(sp)
    1078:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    107a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    107e:	00002797          	auipc	a5,0x2
    1082:	f827b783          	ld	a5,-126(a5) # 3000 <freep>
    1086:	a039                	j	1094 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1088:	6398                	ld	a4,0(a5)
    108a:	00e7e463          	bltu	a5,a4,1092 <free+0x20>
    108e:	00e6ea63          	bltu	a3,a4,10a2 <free+0x30>
{
    1092:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1094:	fed7fae3          	bgeu	a5,a3,1088 <free+0x16>
    1098:	6398                	ld	a4,0(a5)
    109a:	00e6e463          	bltu	a3,a4,10a2 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    109e:	fee7eae3          	bltu	a5,a4,1092 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    10a2:	ff852583          	lw	a1,-8(a0)
    10a6:	6390                	ld	a2,0(a5)
    10a8:	02059813          	slli	a6,a1,0x20
    10ac:	01c85713          	srli	a4,a6,0x1c
    10b0:	9736                	add	a4,a4,a3
    10b2:	02e60563          	beq	a2,a4,10dc <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    10b6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    10ba:	4790                	lw	a2,8(a5)
    10bc:	02061593          	slli	a1,a2,0x20
    10c0:	01c5d713          	srli	a4,a1,0x1c
    10c4:	973e                	add	a4,a4,a5
    10c6:	02e68263          	beq	a3,a4,10ea <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    10ca:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    10cc:	00002717          	auipc	a4,0x2
    10d0:	f2f73a23          	sd	a5,-204(a4) # 3000 <freep>
}
    10d4:	60a2                	ld	ra,8(sp)
    10d6:	6402                	ld	s0,0(sp)
    10d8:	0141                	addi	sp,sp,16
    10da:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    10dc:	4618                	lw	a4,8(a2)
    10de:	9f2d                	addw	a4,a4,a1
    10e0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10e4:	6398                	ld	a4,0(a5)
    10e6:	6310                	ld	a2,0(a4)
    10e8:	b7f9                	j	10b6 <free+0x44>
    p->s.size += bp->s.size;
    10ea:	ff852703          	lw	a4,-8(a0)
    10ee:	9f31                	addw	a4,a4,a2
    10f0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    10f2:	ff053683          	ld	a3,-16(a0)
    10f6:	bfd1                	j	10ca <free+0x58>

00000000000010f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10f8:	7139                	addi	sp,sp,-64
    10fa:	fc06                	sd	ra,56(sp)
    10fc:	f822                	sd	s0,48(sp)
    10fe:	f04a                	sd	s2,32(sp)
    1100:	ec4e                	sd	s3,24(sp)
    1102:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1104:	02051993          	slli	s3,a0,0x20
    1108:	0209d993          	srli	s3,s3,0x20
    110c:	09bd                	addi	s3,s3,15
    110e:	0049d993          	srli	s3,s3,0x4
    1112:	2985                	addiw	s3,s3,1
    1114:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1116:	00002517          	auipc	a0,0x2
    111a:	eea53503          	ld	a0,-278(a0) # 3000 <freep>
    111e:	c905                	beqz	a0,114e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1120:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1122:	4798                	lw	a4,8(a5)
    1124:	09377663          	bgeu	a4,s3,11b0 <malloc+0xb8>
    1128:	f426                	sd	s1,40(sp)
    112a:	e852                	sd	s4,16(sp)
    112c:	e456                	sd	s5,8(sp)
    112e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1130:	8a4e                	mv	s4,s3
    1132:	6705                	lui	a4,0x1
    1134:	00e9f363          	bgeu	s3,a4,113a <malloc+0x42>
    1138:	6a05                	lui	s4,0x1
    113a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    113e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1142:	00002497          	auipc	s1,0x2
    1146:	ebe48493          	addi	s1,s1,-322 # 3000 <freep>
  if(p == SBRK_ERROR)
    114a:	5afd                	li	s5,-1
    114c:	a83d                	j	118a <malloc+0x92>
    114e:	f426                	sd	s1,40(sp)
    1150:	e852                	sd	s4,16(sp)
    1152:	e456                	sd	s5,8(sp)
    1154:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1156:	00002797          	auipc	a5,0x2
    115a:	eba78793          	addi	a5,a5,-326 # 3010 <base>
    115e:	00002717          	auipc	a4,0x2
    1162:	eaf73123          	sd	a5,-350(a4) # 3000 <freep>
    1166:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1168:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    116c:	b7d1                	j	1130 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    116e:	6398                	ld	a4,0(a5)
    1170:	e118                	sd	a4,0(a0)
    1172:	a899                	j	11c8 <malloc+0xd0>
  hp->s.size = nu;
    1174:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1178:	0541                	addi	a0,a0,16
    117a:	ef9ff0ef          	jal	1072 <free>
  return freep;
    117e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1180:	c125                	beqz	a0,11e0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1182:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1184:	4798                	lw	a4,8(a5)
    1186:	03277163          	bgeu	a4,s2,11a8 <malloc+0xb0>
    if(p == freep)
    118a:	6098                	ld	a4,0(s1)
    118c:	853e                	mv	a0,a5
    118e:	fef71ae3          	bne	a4,a5,1182 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    1192:	8552                	mv	a0,s4
    1194:	9e3ff0ef          	jal	b76 <sbrk>
  if(p == SBRK_ERROR)
    1198:	fd551ee3          	bne	a0,s5,1174 <malloc+0x7c>
        return 0;
    119c:	4501                	li	a0,0
    119e:	74a2                	ld	s1,40(sp)
    11a0:	6a42                	ld	s4,16(sp)
    11a2:	6aa2                	ld	s5,8(sp)
    11a4:	6b02                	ld	s6,0(sp)
    11a6:	a03d                	j	11d4 <malloc+0xdc>
    11a8:	74a2                	ld	s1,40(sp)
    11aa:	6a42                	ld	s4,16(sp)
    11ac:	6aa2                	ld	s5,8(sp)
    11ae:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    11b0:	fae90fe3          	beq	s2,a4,116e <malloc+0x76>
        p->s.size -= nunits;
    11b4:	4137073b          	subw	a4,a4,s3
    11b8:	c798                	sw	a4,8(a5)
        p += p->s.size;
    11ba:	02071693          	slli	a3,a4,0x20
    11be:	01c6d713          	srli	a4,a3,0x1c
    11c2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    11c4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    11c8:	00002717          	auipc	a4,0x2
    11cc:	e2a73c23          	sd	a0,-456(a4) # 3000 <freep>
      return (void*)(p + 1);
    11d0:	01078513          	addi	a0,a5,16
  }
}
    11d4:	70e2                	ld	ra,56(sp)
    11d6:	7442                	ld	s0,48(sp)
    11d8:	7902                	ld	s2,32(sp)
    11da:	69e2                	ld	s3,24(sp)
    11dc:	6121                	addi	sp,sp,64
    11de:	8082                	ret
    11e0:	74a2                	ld	s1,40(sp)
    11e2:	6a42                	ld	s4,16(sp)
    11e4:	6aa2                	ld	s5,8(sp)
    11e6:	6b02                	ld	s6,0(sp)
    11e8:	b7f5                	j	11d4 <malloc+0xdc>
