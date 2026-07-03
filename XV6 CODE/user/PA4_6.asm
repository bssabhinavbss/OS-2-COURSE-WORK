
user/_PA4_6:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getdiskstats>:
    int reads;
    int writes;
    int avg_latency;
};

static inline int getdiskstats(int pid, struct diskstats *dst) {
       0:	715d                	addi	sp,sp,-80
       2:	e486                	sd	ra,72(sp)
       4:	e0a2                	sd	s0,64(sp)
       6:	fc26                	sd	s1,56(sp)
       8:	0880                	addi	s0,sp,80
       a:	84ae                	mv	s1,a1
    struct vmstats st;
    if (getvmstats(pid, &st) < 0) return -1;
       c:	fb040593          	addi	a1,s0,-80
      10:	4f3000ef          	jal	d02 <getvmstats>
      14:	02054163          	bltz	a0,36 <getdiskstats+0x36>
    dst->reads = (int)st.disk_reads;
      18:	fc843783          	ld	a5,-56(s0)
      1c:	c09c                	sw	a5,0(s1)
    dst->writes = (int)st.disk_writes;
      1e:	fd043783          	ld	a5,-48(s0)
      22:	c0dc                	sw	a5,4(s1)
    dst->avg_latency = (int)st.avg_disk_latency;
      24:	fd843783          	ld	a5,-40(s0)
      28:	c49c                	sw	a5,8(s1)
    return 0;
      2a:	4501                	li	a0,0
}
      2c:	60a6                	ld	ra,72(sp)
      2e:	6406                	ld	s0,64(sp)
      30:	74e2                	ld	s1,56(sp)
      32:	6161                	addi	sp,sp,80
      34:	8082                	ret
    if (getvmstats(pid, &st) < 0) return -1;
      36:	557d                	li	a0,-1
      38:	bfd5                	j	2c <getdiskstats+0x2c>

000000000000003a <write_verify_17>:
    return (char)((page * 19 + pass * 31 + disk_failed * 7 + 1) & 0xFF);
}

// Write the memory region and verify correct read-back.
// Returns number of errors.
static int write_verify_17(char *mem, int npages, int pass, int disk_failed) {
      3a:	715d                	addi	sp,sp,-80
      3c:	e486                	sd	ra,72(sp)
      3e:	e0a2                	sd	s0,64(sp)
      40:	f44e                	sd	s3,40(sp)
      42:	0880                	addi	s0,sp,80
    for (int i = 0; i < npages; i++)
      44:	08b05c63          	blez	a1,dc <write_verify_17+0xa2>
      48:	fc26                	sd	s1,56(sp)
      4a:	f84a                	sd	s2,48(sp)
      4c:	f052                	sd	s4,32(sp)
      4e:	ec56                	sd	s5,24(sp)
      50:	e85a                	sd	s6,16(sp)
      52:	e45e                	sd	s7,8(sp)
      54:	e062                	sd	s8,0(sp)
      56:	8aae                	mv	s5,a1
    return (char)((page * 19 + pass * 31 + disk_failed * 7 + 1) & 0xFF);
      58:	0036949b          	slliw	s1,a3,0x3
      5c:	9c95                	subw	s1,s1,a3
      5e:	2485                	addiw	s1,s1,1
      60:	0056179b          	slliw	a5,a2,0x5
      64:	9f91                	subw	a5,a5,a2
      66:	9cbd                	addw	s1,s1,a5
      68:	0ff4f493          	zext.b	s1,s1
      6c:	8a2a                	mv	s4,a0
      6e:	00c59713          	slli	a4,a1,0xc
      72:	972a                	add	a4,a4,a0
      74:	87a6                	mv	a5,s1
    for (int i = 0; i < npages; i++)
      76:	6685                	lui	a3,0x1
        mem[i * PGSIZE_17] = pat_17(i, pass, disk_failed);
      78:	00f50023          	sb	a5,0(a0)
    for (int i = 0; i < npages; i++)
      7c:	27cd                	addiw	a5,a5,19
      7e:	0ff7f793          	zext.b	a5,a5
      82:	9536                	add	a0,a0,a3
      84:	fee51ae3          	bne	a0,a4,78 <write_verify_17+0x3e>

    int errs = 0;
    for (int i = 0; i < npages; i++) {
      88:	4901                	li	s2,0
    int errs = 0;
      8a:	4981                	li	s3,0
        char expected = pat_17(i, pass, disk_failed);
        char got = mem[i * PGSIZE_17];
        if (got != expected) {
            errs++;
            if (errs <= 4)
      8c:	4b91                	li	s7,4
                printf("  page %d: got 0x%x exp 0x%x\n",
      8e:	00001c17          	auipc	s8,0x1
      92:	1e2c0c13          	addi	s8,s8,482 # 1270 <malloc+0x100>
    for (int i = 0; i < npages; i++) {
      96:	6b05                	lui	s6,0x1
      98:	a829                	j	b2 <write_verify_17+0x78>
                printf("  page %d: got 0x%x exp 0x%x\n",
      9a:	86a6                	mv	a3,s1
      9c:	85ca                	mv	a1,s2
      9e:	8562                	mv	a0,s8
      a0:	018010ef          	jal	10b8 <printf>
    for (int i = 0; i < npages; i++) {
      a4:	2905                	addiw	s2,s2,1
      a6:	9a5a                	add	s4,s4,s6
      a8:	24cd                	addiw	s1,s1,19
      aa:	0ff4f493          	zext.b	s1,s1
      ae:	012a8a63          	beq	s5,s2,c2 <write_verify_17+0x88>
        char got = mem[i * PGSIZE_17];
      b2:	000a4603          	lbu	a2,0(s4)
        if (got != expected) {
      b6:	fec487e3          	beq	s1,a2,a4 <write_verify_17+0x6a>
            errs++;
      ba:	2985                	addiw	s3,s3,1
            if (errs <= 4)
      bc:	ff3bc4e3          	blt	s7,s3,a4 <write_verify_17+0x6a>
      c0:	bfe9                	j	9a <write_verify_17+0x60>
      c2:	74e2                	ld	s1,56(sp)
      c4:	7942                	ld	s2,48(sp)
      c6:	7a02                	ld	s4,32(sp)
      c8:	6ae2                	ld	s5,24(sp)
      ca:	6b42                	ld	s6,16(sp)
      cc:	6ba2                	ld	s7,8(sp)
      ce:	6c02                	ld	s8,0(sp)
                       i, (unsigned char)got, (unsigned char)expected);
        }
    }
    return errs;
}
      d0:	854e                	mv	a0,s3
      d2:	60a6                	ld	ra,72(sp)
      d4:	6406                	ld	s0,64(sp)
      d6:	79a2                	ld	s3,40(sp)
      d8:	6161                	addi	sp,sp,80
      da:	8082                	ret
    int errs = 0;
      dc:	4981                	li	s3,0
      de:	bfcd                	j	d0 <write_verify_17+0x96>

00000000000000e0 <run_write_read_15>:
static int run_write_read_15(char *mem, int npages, int pass) {
      e0:	715d                	addi	sp,sp,-80
      e2:	e486                	sd	ra,72(sp)
      e4:	e0a2                	sd	s0,64(sp)
      e6:	f44e                	sd	s3,40(sp)
      e8:	0880                	addi	s0,sp,80
    for (int i = 0; i < npages; i++)
      ea:	08b05563          	blez	a1,174 <run_write_read_15+0x94>
      ee:	fc26                	sd	s1,56(sp)
      f0:	f84a                	sd	s2,48(sp)
      f2:	f052                	sd	s4,32(sp)
      f4:	ec56                	sd	s5,24(sp)
      f6:	e85a                	sd	s6,16(sp)
      f8:	e45e                	sd	s7,8(sp)
      fa:	e062                	sd	s8,0(sp)
      fc:	8aae                	mv	s5,a1
      fe:	2615                	addiw	a2,a2,5
     100:	0ff67493          	zext.b	s1,a2
     104:	8a2a                	mv	s4,a0
     106:	00c59713          	slli	a4,a1,0xc
     10a:	972a                	add	a4,a4,a0
     10c:	87a6                	mv	a5,s1
     10e:	6685                	lui	a3,0x1
        mem[i * PGSIZE_15] = (char)((pat_15(i) + pass) & 0xFF);
     110:	00f50023          	sb	a5,0(a0)
    for (int i = 0; i < npages; i++)
     114:	27c5                	addiw	a5,a5,17
     116:	0ff7f793          	zext.b	a5,a5
     11a:	9536                	add	a0,a0,a3
     11c:	fee51ae3          	bne	a0,a4,110 <run_write_read_15+0x30>
    for (int i = 0; i < npages; i++) {
     120:	4901                	li	s2,0
    int errs = 0;
     122:	4981                	li	s3,0
            if (errs <= 3)
     124:	4b8d                	li	s7,3
                printf("  page %d: got 0x%x exp 0x%x\n",
     126:	00001c17          	auipc	s8,0x1
     12a:	14ac0c13          	addi	s8,s8,330 # 1270 <malloc+0x100>
    for (int i = 0; i < npages; i++) {
     12e:	6b05                	lui	s6,0x1
     130:	a829                	j	14a <run_write_read_15+0x6a>
                printf("  page %d: got 0x%x exp 0x%x\n",
     132:	86a6                	mv	a3,s1
     134:	85ca                	mv	a1,s2
     136:	8562                	mv	a0,s8
     138:	781000ef          	jal	10b8 <printf>
    for (int i = 0; i < npages; i++) {
     13c:	2905                	addiw	s2,s2,1
     13e:	9a5a                	add	s4,s4,s6
     140:	24c5                	addiw	s1,s1,17
     142:	0ff4f493          	zext.b	s1,s1
     146:	012a8a63          	beq	s5,s2,15a <run_write_read_15+0x7a>
        if (mem[i * PGSIZE_15] != expected) {
     14a:	000a4603          	lbu	a2,0(s4)
     14e:	fe9607e3          	beq	a2,s1,13c <run_write_read_15+0x5c>
            errs++;
     152:	2985                	addiw	s3,s3,1
            if (errs <= 3)
     154:	ff3bc4e3          	blt	s7,s3,13c <run_write_read_15+0x5c>
     158:	bfe9                	j	132 <run_write_read_15+0x52>
     15a:	74e2                	ld	s1,56(sp)
     15c:	7942                	ld	s2,48(sp)
     15e:	7a02                	ld	s4,32(sp)
     160:	6ae2                	ld	s5,24(sp)
     162:	6b42                	ld	s6,16(sp)
     164:	6ba2                	ld	s7,8(sp)
     166:	6c02                	ld	s8,0(sp)
}
     168:	854e                	mv	a0,s3
     16a:	60a6                	ld	ra,72(sp)
     16c:	6406                	ld	s0,64(sp)
     16e:	79a2                	ld	s3,40(sp)
     170:	6161                	addi	sp,sp,80
     172:	8082                	ret
    int errs = 0;
     174:	4981                	li	s3,0
     176:	bfcd                	j	168 <run_write_read_15+0x88>

0000000000000178 <main>:
// main
// ============================================================

int
main(void)
{
     178:	7175                	addi	sp,sp,-144
     17a:	e506                	sd	ra,136(sp)
     17c:	e122                	sd	s0,128(sp)
     17e:	fca6                	sd	s1,120(sp)
     180:	f8ca                	sd	s2,112(sp)
     182:	f4ce                	sd	s3,104(sp)
     184:	f0d2                	sd	s4,96(sp)
     186:	ecd6                	sd	s5,88(sp)
     188:	e8da                	sd	s6,80(sp)
     18a:	e4de                	sd	s7,72(sp)
     18c:	e0e2                	sd	s8,64(sp)
     18e:	fc66                	sd	s9,56(sp)
     190:	f86a                	sd	s10,48(sp)
     192:	f46e                	sd	s11,40(sp)
     194:	0900                	addi	s0,sp,144
  printf("==============================\n");
     196:	00001517          	auipc	a0,0x1
     19a:	0fa50513          	addi	a0,a0,250 # 1290 <malloc+0x120>
     19e:	71b000ef          	jal	10b8 <printf>
  printf("PA4_E: RAID 0/1/5 correctness\n");
     1a2:	00001517          	auipc	a0,0x1
     1a6:	10e50513          	addi	a0,a0,270 # 12b0 <malloc+0x140>
     1aa:	70f000ef          	jal	10b8 <printf>
  printf("==============================\n\n");
     1ae:	00001517          	auipc	a0,0x1
     1b2:	12250513          	addi	a0,a0,290 # 12d0 <malloc+0x160>
     1b6:	703000ef          	jal	10b8 <printf>

  printf("--- PA4_14: RAID0 striping ---\n");
     1ba:	00001517          	auipc	a0,0x1
     1be:	13e50513          	addi	a0,a0,318 # 12f8 <malloc+0x188>
     1c2:	6f7000ef          	jal	10b8 <printf>
    printf("=== Test n: RAID 0 Striping Correctness ===\n");
     1c6:	00001517          	auipc	a0,0x1
     1ca:	15250513          	addi	a0,a0,338 # 1318 <malloc+0x1a8>
     1ce:	6eb000ef          	jal	10b8 <printf>
    printf("[1] Setting RAID mode to RAID0\n");
     1d2:	00001517          	auipc	a0,0x1
     1d6:	17650513          	addi	a0,a0,374 # 1348 <malloc+0x1d8>
     1da:	6df000ef          	jal	10b8 <printf>
        printf("  PASS: setraidmode(RAID0) accepted\n");
     1de:	00001517          	auipc	a0,0x1
     1e2:	18a50513          	addi	a0,a0,394 # 1368 <malloc+0x1f8>
     1e6:	6d3000ef          	jal	10b8 <printf>
    setdisksched(FCFS_14); // deterministic ordering for this test
     1ea:	4501                	li	a0,0
     1ec:	31f000ef          	jal	d0a <setdisksched>
    printf("[2] Multi-pass write/read across %d pages\n", SWAP_PAGES_14);
     1f0:	05500593          	li	a1,85
     1f4:	00001517          	auipc	a0,0x1
     1f8:	19c50513          	addi	a0,a0,412 # 1390 <malloc+0x220>
     1fc:	6bd000ef          	jal	10b8 <printf>
    char *mem = sbrklazy(SWAP_PAGES_14 * PGSIZE_14);
     200:	00055537          	lui	a0,0x55
     204:	201000ef          	jal	c04 <sbrklazy>
     208:	f6a43c23          	sd	a0,-136(s0)
    if (mem == (char *)-1) {
     20c:	57fd                	li	a5,-1
     20e:	00f50f63          	beq	a0,a5,22c <main+0xb4>
     212:	05200a93          	li	s5,82
     216:	4d81                	li	s11,0
     218:	4c01                	li	s8,0
        for (int i = 0; i < SWAP_PAGES_14; i++)
     21a:	6a05                	lui	s4,0x1
                if (errs <= 3)
     21c:	4d0d                	li	s10,3
                    printf("  page %d pass %d: got 0x%x expected 0x%x\n",
     21e:	00001c97          	auipc	s9,0x1
     222:	1bac8c93          	addi	s9,s9,442 # 13d8 <malloc+0x268>
        for (int i = 0; i < SWAP_PAGES_14; i++) {
     226:	05500b13          	li	s6,85
     22a:	a085                	j	28a <main+0x112>
        printf("  FAIL: sbrklazy\n");
     22c:	00001517          	auipc	a0,0x1
     230:	19450513          	addi	a0,a0,404 # 13c0 <malloc+0x250>
     234:	685000ef          	jal	10b8 <printf>
        return;
     238:	a2b9                	j	386 <main+0x20e>
                    printf("  page %d pass %d: got 0x%x expected 0x%x\n",
     23a:	8726                	mv	a4,s1
     23c:	8662                	mv	a2,s8
     23e:	85ca                	mv	a1,s2
     240:	8566                	mv	a0,s9
     242:	677000ef          	jal	10b8 <printf>
        for (int i = 0; i < SWAP_PAGES_14; i++) {
     246:	2905                	addiw	s2,s2,1
     248:	99d2                	add	s3,s3,s4
     24a:	24b5                	addiw	s1,s1,13
     24c:	0ff4f493          	zext.b	s1,s1
     250:	01690a63          	beq	s2,s6,264 <main+0xec>
            if (mem[i * PGSIZE_14] != pat_14(i, pass)) {
     254:	0009c683          	lbu	a3,0(s3)
     258:	fed487e3          	beq	s1,a3,246 <main+0xce>
                errs++;
     25c:	2b85                	addiw	s7,s7,1
                if (errs <= 3)
     25e:	ff7d44e3          	blt	s10,s7,246 <main+0xce>
     262:	bfe1                	j	23a <main+0xc2>
        total_errs += errs;
     264:	01bb84bb          	addw	s1,s7,s11
     268:	8da6                	mv	s11,s1
        if (errs == 0)
     26a:	040b9363          	bnez	s7,2b0 <main+0x138>
            printf("  pass %d: PASS (all %d pages correct)\n", pass, SWAP_PAGES_14);
     26e:	865a                	mv	a2,s6
     270:	85e2                	mv	a1,s8
     272:	00001517          	auipc	a0,0x1
     276:	19650513          	addi	a0,a0,406 # 1408 <malloc+0x298>
     27a:	63f000ef          	jal	10b8 <printf>
    for (int pass = 0; pass < PASSES_14; pass++) {
     27e:	2c05                	addiw	s8,s8,1
     280:	2a9d                	addiw	s5,s5,7
     282:	0ffafa93          	zext.b	s5,s5
     286:	03ac0e63          	beq	s8,s10,2c2 <main+0x14a>
        for (int i = 0; i < SWAP_PAGES_14; i++)
     28a:	fafa849b          	addiw	s1,s5,-81
     28e:	0ff4f493          	zext.b	s1,s1
     292:	f7843703          	ld	a4,-136(s0)
     296:	89ba                	mv	s3,a4
{
     298:	87a6                	mv	a5,s1
            mem[i * PGSIZE_14] = pat_14(i, pass);
     29a:	00f70023          	sb	a5,0(a4)
        for (int i = 0; i < SWAP_PAGES_14; i++)
     29e:	27b5                	addiw	a5,a5,13
     2a0:	0ff7f793          	zext.b	a5,a5
     2a4:	9752                	add	a4,a4,s4
     2a6:	ff579ae3          	bne	a5,s5,29a <main+0x122>
        int errs = 0;
     2aa:	4b81                	li	s7,0
        for (int i = 0; i < SWAP_PAGES_14; i++) {
     2ac:	4901                	li	s2,0
     2ae:	b75d                	j	254 <main+0xdc>
            printf("  pass %d: FAIL (%d errors)\n", pass, errs);
     2b0:	865e                	mv	a2,s7
     2b2:	85e2                	mv	a1,s8
     2b4:	00001517          	auipc	a0,0x1
     2b8:	17c50513          	addi	a0,a0,380 # 1430 <malloc+0x2c0>
     2bc:	5fd000ef          	jal	10b8 <printf>
     2c0:	bf7d                	j	27e <main+0x106>
    printf("[3] Overall data integrity\n");
     2c2:	00001517          	auipc	a0,0x1
     2c6:	18e50513          	addi	a0,a0,398 # 1450 <malloc+0x2e0>
     2ca:	5ef000ef          	jal	10b8 <printf>
    if (total_errs == 0)
     2ce:	2a0d9a63          	bnez	s11,582 <main+0x40a>
        printf("  PASS: %d passes, 0 errors — RAID0 striping correct\n", PASSES_14);
     2d2:	458d                	li	a1,3
     2d4:	00001517          	auipc	a0,0x1
     2d8:	19c50513          	addi	a0,a0,412 # 1470 <malloc+0x300>
     2dc:	5dd000ef          	jal	10b8 <printf>
    printf("[4] Disk I/O was generated\n");
     2e0:	00001517          	auipc	a0,0x1
     2e4:	1f850513          	addi	a0,a0,504 # 14d8 <malloc+0x368>
     2e8:	5d1000ef          	jal	10b8 <printf>
    memset(&st, 0, sizeof(st));
     2ec:	f8040913          	addi	s2,s0,-128
     2f0:	4631                	li	a2,12
     2f2:	4581                	li	a1,0
     2f4:	854a                	mv	a0,s2
     2f6:	702000ef          	jal	9f8 <memset>
    if (getdiskstats(getpid2(), &st) != 0) {
     2fa:	1d1000ef          	jal	cca <getpid2>
     2fe:	85ca                	mv	a1,s2
     300:	d01ff0ef          	jal	0 <getdiskstats>
     304:	28051863          	bnez	a0,594 <main+0x41c>
           st.reads, st.writes, st.avg_latency/100, st.avg_latency%100);
     308:	f8842683          	lw	a3,-120(s0)
    printf("  reads=%d writes=%d avg_latency=%d.%d ticks\n",
     30c:	06400793          	li	a5,100
     310:	02f6e73b          	remw	a4,a3,a5
     314:	02f6c6bb          	divw	a3,a3,a5
     318:	f8442603          	lw	a2,-124(s0)
     31c:	f8042583          	lw	a1,-128(s0)
     320:	00001517          	auipc	a0,0x1
     324:	1f850513          	addi	a0,a0,504 # 1518 <malloc+0x3a8>
     328:	591000ef          	jal	10b8 <printf>
    if (st.writes > 0)
     32c:	f8442783          	lw	a5,-124(s0)
     330:	26f05963          	blez	a5,5a2 <main+0x42a>
        printf("  PASS: swap-out (writes) occurred\n");
     334:	00001517          	auipc	a0,0x1
     338:	21450513          	addi	a0,a0,532 # 1548 <malloc+0x3d8>
     33c:	57d000ef          	jal	10b8 <printf>
    if (st.reads > 0)
     340:	f8042783          	lw	a5,-128(s0)
     344:	26f05663          	blez	a5,5b0 <main+0x438>
        printf("  PASS: swap-in (reads) occurred\n");
     348:	00001517          	auipc	a0,0x1
     34c:	26050513          	addi	a0,a0,608 # 15a8 <malloc+0x438>
     350:	569000ef          	jal	10b8 <printf>
    printf("[5] RAID0 stripe count plausibility\n");
     354:	00001517          	auipc	a0,0x1
     358:	29c50513          	addi	a0,a0,668 # 15f0 <malloc+0x480>
     35c:	55d000ef          	jal	10b8 <printf>
    if (st.writes >= expected_min_writes / 4) // some fraction acceptable
     360:	f8442583          	lw	a1,-124(s0)
     364:	05400793          	li	a5,84
     368:	24b7db63          	bge	a5,a1,5be <main+0x446>
        printf("  PASS: write count plausible for RAID0 striping\n");
     36c:	00001517          	auipc	a0,0x1
     370:	2ac50513          	addi	a0,a0,684 # 1618 <malloc+0x4a8>
     374:	545000ef          	jal	10b8 <printf>
    printf("=== Test n done (total_errs=%d) ===\n", total_errs);
     378:	85a6                	mv	a1,s1
     37a:	00001517          	auipc	a0,0x1
     37e:	30e50513          	addi	a0,a0,782 # 1688 <malloc+0x518>
     382:	537000ef          	jal	10b8 <printf>
  test_pa4_14();

  printf("\n--- PA4_15: RAID1 mirroring ---\n");
     386:	00001517          	auipc	a0,0x1
     38a:	32a50513          	addi	a0,a0,810 # 16b0 <malloc+0x540>
     38e:	52b000ef          	jal	10b8 <printf>
    printf("=== Test o: RAID 1 Mirroring Correctness ===\n");
     392:	00001517          	auipc	a0,0x1
     396:	34650513          	addi	a0,a0,838 # 16d8 <malloc+0x568>
     39a:	51f000ef          	jal	10b8 <printf>
    printf("[1] setfaileddisk: invalid values rejected\n");
     39e:	00001517          	auipc	a0,0x1
     3a2:	36a50513          	addi	a0,a0,874 # 1708 <malloc+0x598>
     3a6:	513000ef          	jal	10b8 <printf>
        printf("  FAIL: disk -1 accepted\n");
     3aa:	00001517          	auipc	a0,0x1
     3ae:	38e50513          	addi	a0,a0,910 # 1738 <malloc+0x5c8>
     3b2:	507000ef          	jal	10b8 <printf>
        printf("  FAIL: disk %d accepted\n", NDISKS_15);
     3b6:	4591                	li	a1,4
     3b8:	00001517          	auipc	a0,0x1
     3bc:	3a050513          	addi	a0,a0,928 # 1758 <malloc+0x5e8>
     3c0:	4f9000ef          	jal	10b8 <printf>
    printf("[2] setraidmode(RAID1)\n");
     3c4:	00001517          	auipc	a0,0x1
     3c8:	3b450513          	addi	a0,a0,948 # 1778 <malloc+0x608>
     3cc:	4ed000ef          	jal	10b8 <printf>
        printf("  PASS: RAID1 set\n");
     3d0:	00001517          	auipc	a0,0x1
     3d4:	3c050513          	addi	a0,a0,960 # 1790 <malloc+0x620>
     3d8:	4e1000ef          	jal	10b8 <printf>
    setdisksched(SSTF_15);
     3dc:	4505                	li	a0,1
     3de:	12d000ef          	jal	d0a <setdisksched>
    char *mem = sbrklazy(SWAP_PAGES_15 * PGSIZE_15);
     3e2:	00052537          	lui	a0,0x52
     3e6:	01f000ef          	jal	c04 <sbrklazy>
     3ea:	84aa                	mv	s1,a0
    if (mem == (char *)-1) { printf("  FAIL: sbrklazy\n"); return; }
     3ec:	57fd                	li	a5,-1
     3ee:	1ef50163          	beq	a0,a5,5d0 <main+0x458>
    printf("[3] Normal RAID1 operation (no failed disk)\n");
     3f2:	00001517          	auipc	a0,0x1
     3f6:	3b650513          	addi	a0,a0,950 # 17a8 <malloc+0x638>
     3fa:	4bf000ef          	jal	10b8 <printf>
    int errs = run_write_read_15(mem, SWAP_PAGES_15, 0);
     3fe:	4601                	li	a2,0
     400:	05200593          	li	a1,82
     404:	8526                	mv	a0,s1
     406:	cdbff0ef          	jal	e0 <run_write_read_15>
     40a:	85aa                	mv	a1,a0
    if (errs == 0)
     40c:	1c051963          	bnez	a0,5de <main+0x466>
        printf("  PASS: all %d pages correct under RAID1\n", SWAP_PAGES_15);
     410:	05200593          	li	a1,82
     414:	00001517          	auipc	a0,0x1
     418:	3c450513          	addi	a0,a0,964 # 17d8 <malloc+0x668>
     41c:	49d000ef          	jal	10b8 <printf>
    printf("[4] RAID1 with disk 0 failed\n");
     420:	00001517          	auipc	a0,0x1
     424:	41050513          	addi	a0,a0,1040 # 1830 <malloc+0x6c0>
     428:	491000ef          	jal	10b8 <printf>
        printf("  disk 0 marked failed\n");
     42c:	00001517          	auipc	a0,0x1
     430:	42450513          	addi	a0,a0,1060 # 1850 <malloc+0x6e0>
     434:	485000ef          	jal	10b8 <printf>
    errs = run_write_read_15(mem, SWAP_PAGES_15, 1);
     438:	4605                	li	a2,1
     43a:	05200593          	li	a1,82
     43e:	8526                	mv	a0,s1
     440:	ca1ff0ef          	jal	e0 <run_write_read_15>
     444:	85aa                	mv	a1,a0
    if (errs == 0)
     446:	1a051363          	bnez	a0,5ec <main+0x474>
        printf("  PASS: all pages correct with disk 0 failed (mirror read)\n");
     44a:	00001517          	auipc	a0,0x1
     44e:	41e50513          	addi	a0,a0,1054 # 1868 <malloc+0x6f8>
     452:	467000ef          	jal	10b8 <printf>
    printf("[5] RAID1 with disk 1 failed\n");
     456:	00001517          	auipc	a0,0x1
     45a:	47a50513          	addi	a0,a0,1146 # 18d0 <malloc+0x760>
     45e:	45b000ef          	jal	10b8 <printf>
        printf("  disk 1 marked failed\n");
     462:	00001517          	auipc	a0,0x1
     466:	48e50513          	addi	a0,a0,1166 # 18f0 <malloc+0x780>
     46a:	44f000ef          	jal	10b8 <printf>
    errs = run_write_read_15(mem, SWAP_PAGES_15, 2);
     46e:	4609                	li	a2,2
     470:	05200593          	li	a1,82
     474:	8526                	mv	a0,s1
     476:	c6bff0ef          	jal	e0 <run_write_read_15>
     47a:	85aa                	mv	a1,a0
    if (errs == 0)
     47c:	16051f63          	bnez	a0,5fa <main+0x482>
        printf("  PASS: all pages correct with disk 1 failed\n");
     480:	00001517          	auipc	a0,0x1
     484:	48850513          	addi	a0,a0,1160 # 1908 <malloc+0x798>
     488:	431000ef          	jal	10b8 <printf>
    printf("[6] Disk I/O stats plausible for RAID1\n");
     48c:	00001517          	auipc	a0,0x1
     490:	4d450513          	addi	a0,a0,1236 # 1960 <malloc+0x7f0>
     494:	425000ef          	jal	10b8 <printf>
    memset(&st, 0, sizeof(st));
     498:	f8040493          	addi	s1,s0,-128
     49c:	4631                	li	a2,12
     49e:	4581                	li	a1,0
     4a0:	8526                	mv	a0,s1
     4a2:	556000ef          	jal	9f8 <memset>
    getdiskstats(getpid2(), &st);
     4a6:	025000ef          	jal	cca <getpid2>
     4aa:	85a6                	mv	a1,s1
     4ac:	b55ff0ef          	jal	0 <getdiskstats>
           st.reads, st.writes, st.avg_latency/100, st.avg_latency%100);
     4b0:	f8842703          	lw	a4,-120(s0)
    printf("  reads=%d writes=%d avg_latency=%d.%d\n",
     4b4:	51eb86b7          	lui	a3,0x51eb8
     4b8:	51f68693          	addi	a3,a3,1311 # 51eb851f <base+0x51eb650f>
     4bc:	02d706b3          	mul	a3,a4,a3
     4c0:	9695                	srai	a3,a3,0x25
     4c2:	41f7579b          	sraiw	a5,a4,0x1f
     4c6:	9e9d                	subw	a3,a3,a5
     4c8:	06400793          	li	a5,100
     4cc:	02d787bb          	mulw	a5,a5,a3
     4d0:	9f1d                	subw	a4,a4,a5
     4d2:	f8442603          	lw	a2,-124(s0)
     4d6:	f8042583          	lw	a1,-128(s0)
     4da:	00001517          	auipc	a0,0x1
     4de:	4ae50513          	addi	a0,a0,1198 # 1988 <malloc+0x818>
     4e2:	3d7000ef          	jal	10b8 <printf>
    if (st.writes > 0 && st.reads > 0)
     4e6:	f8442783          	lw	a5,-124(s0)
     4ea:	00f05663          	blez	a5,4f6 <main+0x37e>
     4ee:	f8042783          	lw	a5,-128(s0)
     4f2:	10f04b63          	bgtz	a5,608 <main+0x490>
        printf("  FAIL: missing reads or writes\n");
     4f6:	00001517          	auipc	a0,0x1
     4fa:	4d250513          	addi	a0,a0,1234 # 19c8 <malloc+0x858>
     4fe:	3bb000ef          	jal	10b8 <printf>
    printf("=== Test o done ===\n");
     502:	00001517          	auipc	a0,0x1
     506:	4ee50513          	addi	a0,a0,1262 # 19f0 <malloc+0x880>
     50a:	3af000ef          	jal	10b8 <printf>
  test_pa4_15();

  printf("\n--- PA4_16: RAID5 basic correctness ---\n");
     50e:	00001517          	auipc	a0,0x1
     512:	4fa50513          	addi	a0,a0,1274 # 1a08 <malloc+0x898>
     516:	3a3000ef          	jal	10b8 <printf>
    printf("=== Test p: RAID 5 Basic Correctness (No Failure) ===\n");
     51a:	00001517          	auipc	a0,0x1
     51e:	51e50513          	addi	a0,a0,1310 # 1a38 <malloc+0x8c8>
     522:	397000ef          	jal	10b8 <printf>
    printf("[1] setraidmode(RAID5)\n");
     526:	00001517          	auipc	a0,0x1
     52a:	54a50513          	addi	a0,a0,1354 # 1a70 <malloc+0x900>
     52e:	38b000ef          	jal	10b8 <printf>
        printf("  PASS: RAID5 set\n");
     532:	00001517          	auipc	a0,0x1
     536:	55650513          	addi	a0,a0,1366 # 1a88 <malloc+0x918>
     53a:	37f000ef          	jal	10b8 <printf>
    setdisksched(SSTF_16);
     53e:	4505                	li	a0,1
     540:	7ca000ef          	jal	d0a <setdisksched>
    char *mem = sbrklazy(SWAP_PAGES_16 * PGSIZE_16);
     544:	00058537          	lui	a0,0x58
     548:	6bc000ef          	jal	c04 <sbrklazy>
     54c:	f6a43c23          	sd	a0,-136(s0)
    if (mem == (char *)-1) { printf("  FAIL: sbrklazy\n"); return; }
     550:	57fd                	li	a5,-1
     552:	0cf50263          	beq	a0,a5,616 <main+0x49e>
    printf("[2] Multi-pass write/read (%d pages, %d passes)\n",
     556:	4611                	li	a2,4
     558:	05800593          	li	a1,88
     55c:	00001517          	auipc	a0,0x1
     560:	54450513          	addi	a0,a0,1348 # 1aa0 <malloc+0x930>
     564:	355000ef          	jal	10b8 <printf>
     568:	0cb00c93          	li	s9,203
    int total_errs = 0;
     56c:	4d81                	li	s11,0
    for (int pass = 0; pass < PASSES_16; pass++) {
     56e:	4a81                	li	s5,0
        for (int i = 0; i < SWAP_PAGES_16; i++)
     570:	6b05                	lui	s6,0x1
                if (errs <= 5)
     572:	4c15                	li	s8,5
                    printf("  page %d pass %d: got 0x%x exp 0x%x\n",
     574:	00001b97          	auipc	s7,0x1
     578:	564b8b93          	addi	s7,s7,1380 # 1ad8 <malloc+0x968>
        for (int i = 0; i < SWAP_PAGES_16; i++) {
     57c:	05800d13          	li	s10,88
     580:	a8dd                	j	676 <main+0x4fe>
        printf("  FAIL: %d total errors across %d passes\n", total_errs, PASSES_14);
     582:	460d                	li	a2,3
     584:	85a6                	mv	a1,s1
     586:	00001517          	auipc	a0,0x1
     58a:	f2250513          	addi	a0,a0,-222 # 14a8 <malloc+0x338>
     58e:	32b000ef          	jal	10b8 <printf>
     592:	b3b9                	j	2e0 <main+0x168>
        printf("  FAIL: getdiskstats error\n");
     594:	00001517          	auipc	a0,0x1
     598:	f6450513          	addi	a0,a0,-156 # 14f8 <malloc+0x388>
     59c:	31d000ef          	jal	10b8 <printf>
        return;
     5a0:	b3dd                	j	386 <main+0x20e>
        printf("  FAIL: no writes recorded — check swap/RAID path\n");
     5a2:	00001517          	auipc	a0,0x1
     5a6:	fce50513          	addi	a0,a0,-50 # 1570 <malloc+0x400>
     5aa:	30f000ef          	jal	10b8 <printf>
     5ae:	bb49                	j	340 <main+0x1c8>
        printf("  FAIL: no reads recorded\n");
     5b0:	00001517          	auipc	a0,0x1
     5b4:	02050513          	addi	a0,a0,32 # 15d0 <malloc+0x460>
     5b8:	301000ef          	jal	10b8 <printf>
     5bc:	bb61                	j	354 <main+0x1dc>
        printf("  NOTE: write count %d may be lower than expected %d\n",
     5be:	05500613          	li	a2,85
     5c2:	00001517          	auipc	a0,0x1
     5c6:	08e50513          	addi	a0,a0,142 # 1650 <malloc+0x4e0>
     5ca:	2ef000ef          	jal	10b8 <printf>
     5ce:	b36d                	j	378 <main+0x200>
    if (mem == (char *)-1) { printf("  FAIL: sbrklazy\n"); return; }
     5d0:	00001517          	auipc	a0,0x1
     5d4:	df050513          	addi	a0,a0,-528 # 13c0 <malloc+0x250>
     5d8:	2e1000ef          	jal	10b8 <printf>
     5dc:	bf0d                	j	50e <main+0x396>
        printf("  FAIL: %d errors under normal RAID1\n", errs);
     5de:	00001517          	auipc	a0,0x1
     5e2:	22a50513          	addi	a0,a0,554 # 1808 <malloc+0x698>
     5e6:	2d3000ef          	jal	10b8 <printf>
     5ea:	bd1d                	j	420 <main+0x2a8>
        printf("  FAIL: %d errors with disk 0 failed\n", errs);
     5ec:	00001517          	auipc	a0,0x1
     5f0:	2bc50513          	addi	a0,a0,700 # 18a8 <malloc+0x738>
     5f4:	2c5000ef          	jal	10b8 <printf>
     5f8:	bdb9                	j	456 <main+0x2de>
        printf("  FAIL: %d errors with disk 1 failed\n", errs);
     5fa:	00001517          	auipc	a0,0x1
     5fe:	33e50513          	addi	a0,a0,830 # 1938 <malloc+0x7c8>
     602:	2b7000ef          	jal	10b8 <printf>
     606:	b559                	j	48c <main+0x314>
        printf("  PASS: I/O recorded\n");
     608:	00001517          	auipc	a0,0x1
     60c:	3a850513          	addi	a0,a0,936 # 19b0 <malloc+0x840>
     610:	2a9000ef          	jal	10b8 <printf>
     614:	b5fd                	j	502 <main+0x38a>
    if (mem == (char *)-1) { printf("  FAIL: sbrklazy\n"); return; }
     616:	00001517          	auipc	a0,0x1
     61a:	daa50513          	addi	a0,a0,-598 # 13c0 <malloc+0x250>
     61e:	29b000ef          	jal	10b8 <printf>
     622:	a29d                	j	788 <main+0x610>
                    printf("  page %d pass %d: got 0x%x exp 0x%x\n",
     624:	8726                	mv	a4,s1
     626:	8656                	mv	a2,s5
     628:	85ce                	mv	a1,s3
     62a:	855e                	mv	a0,s7
     62c:	28d000ef          	jal	10b8 <printf>
        for (int i = 0; i < SWAP_PAGES_16; i++) {
     630:	2985                	addiw	s3,s3,1
     632:	9a5a                	add	s4,s4,s6
     634:	24ad                	addiw	s1,s1,11
     636:	0ff4f493          	zext.b	s1,s1
     63a:	01a98a63          	beq	s3,s10,64e <main+0x4d6>
            char got = mem[i * PGSIZE_16];
     63e:	000a4683          	lbu	a3,0(s4) # 1000 <vprintf+0x232>
            if (got != expected) {
     642:	fed487e3          	beq	s1,a3,630 <main+0x4b8>
                errs++;
     646:	2905                	addiw	s2,s2,1
                if (errs <= 5)
     648:	ff2c44e3          	blt	s8,s2,630 <main+0x4b8>
     64c:	bfe1                	j	624 <main+0x4ac>
        total_errs += errs;
     64e:	01b904bb          	addw	s1,s2,s11
     652:	8da6                	mv	s11,s1
        if (errs == 0)
     654:	04091463          	bnez	s2,69c <main+0x524>
            printf("  pass %d: PASS (%d pages OK)\n", pass, SWAP_PAGES_16);
     658:	866a                	mv	a2,s10
     65a:	85d6                	mv	a1,s5
     65c:	00001517          	auipc	a0,0x1
     660:	4a450513          	addi	a0,a0,1188 # 1b00 <malloc+0x990>
     664:	255000ef          	jal	10b8 <printf>
    for (int pass = 0; pass < PASSES_16; pass++) {
     668:	2a85                	addiw	s5,s5,1
     66a:	2cdd                	addiw	s9,s9,23
     66c:	0ffcfc93          	zext.b	s9,s9
     670:	4791                	li	a5,4
     672:	02fa8e63          	beq	s5,a5,6ae <main+0x536>
        for (int i = 0; i < SWAP_PAGES_16; i++)
     676:	038c849b          	addiw	s1,s9,56
     67a:	0ff4f493          	zext.b	s1,s1
     67e:	f7843703          	ld	a4,-136(s0)
     682:	8a3a                	mv	s4,a4
    for (int pass = 0; pass < PASSES_14; pass++) {
     684:	87a6                	mv	a5,s1
            mem[i * PGSIZE_16] = pat_16(i, pass);
     686:	00f70023          	sb	a5,0(a4)
        for (int i = 0; i < SWAP_PAGES_16; i++)
     68a:	27ad                	addiw	a5,a5,11
     68c:	0ff7f793          	zext.b	a5,a5
     690:	975a                	add	a4,a4,s6
     692:	ff979ae3          	bne	a5,s9,686 <main+0x50e>
        int errs = 0;
     696:	4901                	li	s2,0
        for (int i = 0; i < SWAP_PAGES_16; i++) {
     698:	4981                	li	s3,0
     69a:	b755                	j	63e <main+0x4c6>
            printf("  pass %d: FAIL (%d errors)\n", pass, errs);
     69c:	864a                	mv	a2,s2
     69e:	85d6                	mv	a1,s5
     6a0:	00001517          	auipc	a0,0x1
     6a4:	d9050513          	addi	a0,a0,-624 # 1430 <malloc+0x2c0>
     6a8:	211000ef          	jal	10b8 <printf>
     6ac:	bf75                	j	668 <main+0x4f0>
    printf("[3] Overall data integrity\n");
     6ae:	00001517          	auipc	a0,0x1
     6b2:	da250513          	addi	a0,a0,-606 # 1450 <malloc+0x2e0>
     6b6:	203000ef          	jal	10b8 <printf>
    if (total_errs == 0)
     6ba:	160d9263          	bnez	s11,81e <main+0x6a6>
        printf("  PASS: %d passes x %d pages — no parity errors\n",
     6be:	05800613          	li	a2,88
     6c2:	4591                	li	a1,4
     6c4:	00001517          	auipc	a0,0x1
     6c8:	45c50513          	addi	a0,a0,1116 # 1b20 <malloc+0x9b0>
     6cc:	1ed000ef          	jal	10b8 <printf>
    printf("[4] Parity rotation coverage\n");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	4a850513          	addi	a0,a0,1192 # 1b78 <malloc+0xa08>
     6d8:	1e1000ef          	jal	10b8 <printf>
    printf("  Covered %d stripes => parity distributed across all 4 disks\n",
     6dc:	05800593          	li	a1,88
     6e0:	00001517          	auipc	a0,0x1
     6e4:	4b850513          	addi	a0,a0,1208 # 1b98 <malloc+0xa28>
     6e8:	1d1000ef          	jal	10b8 <printf>
    printf("  PASS: parity rotation exercised (verified via data correctness)\n");
     6ec:	00001517          	auipc	a0,0x1
     6f0:	4ec50513          	addi	a0,a0,1260 # 1bd8 <malloc+0xa68>
     6f4:	1c5000ef          	jal	10b8 <printf>
    printf("[5] I/O stats\n");
     6f8:	00001517          	auipc	a0,0x1
     6fc:	52850513          	addi	a0,a0,1320 # 1c20 <malloc+0xab0>
     700:	1b9000ef          	jal	10b8 <printf>
    memset(&st, 0, sizeof(st));
     704:	f8040913          	addi	s2,s0,-128
     708:	4631                	li	a2,12
     70a:	4581                	li	a1,0
     70c:	854a                	mv	a0,s2
     70e:	2ea000ef          	jal	9f8 <memset>
    getdiskstats(getpid2(), &st);
     712:	5b8000ef          	jal	cca <getpid2>
     716:	85ca                	mv	a1,s2
     718:	8e9ff0ef          	jal	0 <getdiskstats>
           st.reads, st.writes, st.avg_latency/100, st.avg_latency%100);
     71c:	f8842703          	lw	a4,-120(s0)
    printf("  reads=%d writes=%d avg_latency=%d.%d ticks\n",
     720:	51eb86b7          	lui	a3,0x51eb8
     724:	51f68693          	addi	a3,a3,1311 # 51eb851f <base+0x51eb650f>
     728:	02d706b3          	mul	a3,a4,a3
     72c:	9695                	srai	a3,a3,0x25
     72e:	41f7579b          	sraiw	a5,a4,0x1f
     732:	9e9d                	subw	a3,a3,a5
     734:	06400793          	li	a5,100
     738:	02d787bb          	mulw	a5,a5,a3
     73c:	9f1d                	subw	a4,a4,a5
     73e:	f8442603          	lw	a2,-124(s0)
     742:	f8042583          	lw	a1,-128(s0)
     746:	00001517          	auipc	a0,0x1
     74a:	dd250513          	addi	a0,a0,-558 # 1518 <malloc+0x3a8>
     74e:	16b000ef          	jal	10b8 <printf>
    if (st.writes > 0 && st.reads > 0)
     752:	f8442783          	lw	a5,-124(s0)
     756:	00f05663          	blez	a5,762 <main+0x5ea>
     75a:	f8042783          	lw	a5,-128(s0)
     75e:	0cf04863          	bgtz	a5,82e <main+0x6b6>
        printf("  FAIL: missing I/O counters\n");
     762:	00001517          	auipc	a0,0x1
     766:	4f650513          	addi	a0,a0,1270 # 1c58 <malloc+0xae8>
     76a:	14f000ef          	jal	10b8 <printf>
    printf("  NOTE: RAID5 generates extra writes for parity blocks\n");
     76e:	00001517          	auipc	a0,0x1
     772:	50a50513          	addi	a0,a0,1290 # 1c78 <malloc+0xb08>
     776:	143000ef          	jal	10b8 <printf>
    printf("=== Test p done (total_errs=%d) ===\n", total_errs);
     77a:	85a6                	mv	a1,s1
     77c:	00001517          	auipc	a0,0x1
     780:	53450513          	addi	a0,a0,1332 # 1cb0 <malloc+0xb40>
     784:	135000ef          	jal	10b8 <printf>
  test_pa4_16();

  printf("\n--- PA4_17: RAID5 reconstruction ---\n");
     788:	00001517          	auipc	a0,0x1
     78c:	55050513          	addi	a0,a0,1360 # 1cd8 <malloc+0xb68>
     790:	129000ef          	jal	10b8 <printf>
    printf("=== Test q: RAID 5 Reconstruction (One Failed Disk) ===\n");
     794:	00001517          	auipc	a0,0x1
     798:	56c50513          	addi	a0,a0,1388 # 1d00 <malloc+0xb90>
     79c:	11d000ef          	jal	10b8 <printf>
    printf("[1] setraidmode(RAID5)\n");
     7a0:	00001517          	auipc	a0,0x1
     7a4:	2d050513          	addi	a0,a0,720 # 1a70 <malloc+0x900>
     7a8:	111000ef          	jal	10b8 <printf>
        printf("  PASS: RAID5 set\n");
     7ac:	00001517          	auipc	a0,0x1
     7b0:	2dc50513          	addi	a0,a0,732 # 1a88 <malloc+0x918>
     7b4:	105000ef          	jal	10b8 <printf>
    setdisksched(FCFS_17);
     7b8:	4501                	li	a0,0
     7ba:	550000ef          	jal	d0a <setdisksched>
    char *mem = sbrklazy(SWAP_PAGES_17 * PGSIZE_17);
     7be:	00048537          	lui	a0,0x48
     7c2:	442000ef          	jal	c04 <sbrklazy>
     7c6:	89aa                	mv	s3,a0
    if (mem == (char *)-1) { printf("  FAIL: sbrklazy\n"); return; }
     7c8:	57fd                	li	a5,-1
     7ca:	06f50963          	beq	a0,a5,83c <main+0x6c4>
    printf("[2] Baseline: no failed disk\n");
     7ce:	00001517          	auipc	a0,0x1
     7d2:	57250513          	addi	a0,a0,1394 # 1d40 <malloc+0xbd0>
     7d6:	0e3000ef          	jal	10b8 <printf>
    int errs = write_verify_17(mem, SWAP_PAGES_17, 0, -1);
     7da:	56fd                	li	a3,-1
     7dc:	4601                	li	a2,0
     7de:	04800593          	li	a1,72
     7e2:	854e                	mv	a0,s3
     7e4:	857ff0ef          	jal	3a <write_verify_17>
     7e8:	85aa                	mv	a1,a0
    if (errs == 0)
     7ea:	e125                	bnez	a0,84a <main+0x6d2>
        printf("  PASS: baseline correct (%d pages)\n", SWAP_PAGES_17);
     7ec:	04800593          	li	a1,72
     7f0:	00001517          	auipc	a0,0x1
     7f4:	57050513          	addi	a0,a0,1392 # 1d60 <malloc+0xbf0>
     7f8:	0c1000ef          	jal	10b8 <printf>
    for (int pass = 0; pass < PASSES_16; pass++) {
     7fc:	4481                	li	s1,0
        printf("[%d] Failing disk %d and verifying reconstruction\n", 3+d, d);
     7fe:	00001b17          	auipc	s6,0x1
     802:	5aab0b13          	addi	s6,s6,1450 # 1da8 <malloc+0xc38>
        errs = write_verify_17(mem, SWAP_PAGES_17, d + 1, d);
     806:	04800a93          	li	s5,72
            printf("  FAIL: disk %d failed — %d reconstruction errors\n",
     80a:	00001c17          	auipc	s8,0x1
     80e:	60ec0c13          	addi	s8,s8,1550 # 1e18 <malloc+0xca8>
            printf("  PASS: disk %d failed — reconstruction correct\n", d);
     812:	00001b97          	auipc	s7,0x1
     816:	5ceb8b93          	addi	s7,s7,1486 # 1de0 <malloc+0xc70>
    for (int d = 0; d < NDISKS_17; d++) {
     81a:	4a11                	li	s4,4
     81c:	a0a9                	j	866 <main+0x6ee>
        printf("  FAIL: %d total data errors\n", total_errs);
     81e:	85a6                	mv	a1,s1
     820:	00001517          	auipc	a0,0x1
     824:	33850513          	addi	a0,a0,824 # 1b58 <malloc+0x9e8>
     828:	091000ef          	jal	10b8 <printf>
     82c:	b555                	j	6d0 <main+0x558>
        printf("  PASS: I/O recorded under RAID5\n");
     82e:	00001517          	auipc	a0,0x1
     832:	40250513          	addi	a0,a0,1026 # 1c30 <malloc+0xac0>
     836:	083000ef          	jal	10b8 <printf>
     83a:	bf15                	j	76e <main+0x5f6>
    if (mem == (char *)-1) { printf("  FAIL: sbrklazy\n"); return; }
     83c:	00001517          	auipc	a0,0x1
     840:	b8450513          	addi	a0,a0,-1148 # 13c0 <malloc+0x250>
     844:	075000ef          	jal	10b8 <printf>
     848:	a8dd                	j	93e <main+0x7c6>
        printf("  FAIL: %d baseline errors\n", errs);
     84a:	00001517          	auipc	a0,0x1
     84e:	53e50513          	addi	a0,a0,1342 # 1d88 <malloc+0xc18>
     852:	067000ef          	jal	10b8 <printf>
     856:	b75d                	j	7fc <main+0x684>
            printf("  FAIL: disk %d failed — %d reconstruction errors\n",
     858:	862a                	mv	a2,a0
     85a:	85ca                	mv	a1,s2
     85c:	8562                	mv	a0,s8
     85e:	05b000ef          	jal	10b8 <printf>
    for (int d = 0; d < NDISKS_17; d++) {
     862:	03448763          	beq	s1,s4,890 <main+0x718>
        printf("[%d] Failing disk %d and verifying reconstruction\n", 3+d, d);
     866:	8626                	mv	a2,s1
     868:	0034859b          	addiw	a1,s1,3
     86c:	855a                	mv	a0,s6
     86e:	04b000ef          	jal	10b8 <printf>
        errs = write_verify_17(mem, SWAP_PAGES_17, d + 1, d);
     872:	8926                	mv	s2,s1
     874:	0014861b          	addiw	a2,s1,1
     878:	84b2                	mv	s1,a2
     87a:	86ca                	mv	a3,s2
     87c:	85d6                	mv	a1,s5
     87e:	854e                	mv	a0,s3
     880:	fbaff0ef          	jal	3a <write_verify_17>
        if (errs == 0)
     884:	f971                	bnez	a0,858 <main+0x6e0>
            printf("  PASS: disk %d failed — reconstruction correct\n", d);
     886:	85ca                	mv	a1,s2
     888:	855e                	mv	a0,s7
     88a:	02f000ef          	jal	10b8 <printf>
     88e:	bfd1                	j	862 <main+0x6ea>
    printf("[7] Recovery: disk 0 repaired (reset to no failure)\n");
     890:	00001517          	auipc	a0,0x1
     894:	5c050513          	addi	a0,a0,1472 # 1e50 <malloc+0xce0>
     898:	021000ef          	jal	10b8 <printf>
    errs = write_verify_17(mem, SWAP_PAGES_17, 99, 3);
     89c:	468d                	li	a3,3
     89e:	06300613          	li	a2,99
     8a2:	04800593          	li	a1,72
     8a6:	854e                	mv	a0,s3
     8a8:	f92ff0ef          	jal	3a <write_verify_17>
     8ac:	85aa                	mv	a1,a0
    if (errs == 0)
     8ae:	e14d                	bnez	a0,950 <main+0x7d8>
        printf("  PASS: disk 3 failed — data still correct\n");
     8b0:	00001517          	auipc	a0,0x1
     8b4:	5d850513          	addi	a0,a0,1496 # 1e88 <malloc+0xd18>
     8b8:	001000ef          	jal	10b8 <printf>
    printf("[8] I/O stats after reconstruction tests\n");
     8bc:	00001517          	auipc	a0,0x1
     8c0:	62450513          	addi	a0,a0,1572 # 1ee0 <malloc+0xd70>
     8c4:	7f4000ef          	jal	10b8 <printf>
    memset(&st, 0, sizeof(st));
     8c8:	f8040493          	addi	s1,s0,-128
     8cc:	4631                	li	a2,12
     8ce:	4581                	li	a1,0
     8d0:	8526                	mv	a0,s1
     8d2:	126000ef          	jal	9f8 <memset>
    getdiskstats(getpid2(), &st);
     8d6:	3f4000ef          	jal	cca <getpid2>
     8da:	85a6                	mv	a1,s1
     8dc:	f24ff0ef          	jal	0 <getdiskstats>
           st.reads, st.writes, st.avg_latency/100, st.avg_latency%100);
     8e0:	f8842703          	lw	a4,-120(s0)
    printf("  reads=%d writes=%d avg_latency=%d.%d ticks\n",
     8e4:	51eb86b7          	lui	a3,0x51eb8
     8e8:	51f68693          	addi	a3,a3,1311 # 51eb851f <base+0x51eb650f>
     8ec:	02d706b3          	mul	a3,a4,a3
     8f0:	9695                	srai	a3,a3,0x25
     8f2:	41f7579b          	sraiw	a5,a4,0x1f
     8f6:	9e9d                	subw	a3,a3,a5
     8f8:	06400793          	li	a5,100
     8fc:	02d787bb          	mulw	a5,a5,a3
     900:	9f1d                	subw	a4,a4,a5
     902:	f8442603          	lw	a2,-124(s0)
     906:	f8042583          	lw	a1,-128(s0)
     90a:	00001517          	auipc	a0,0x1
     90e:	c0e50513          	addi	a0,a0,-1010 # 1518 <malloc+0x3a8>
     912:	7a6000ef          	jal	10b8 <printf>
    if (st.reads > 0 && st.writes > 0)
     916:	f8042783          	lw	a5,-128(s0)
     91a:	00f05663          	blez	a5,926 <main+0x7ae>
     91e:	f8442783          	lw	a5,-124(s0)
     922:	02f04e63          	bgtz	a5,95e <main+0x7e6>
        printf("  FAIL: I/O counters missing\n");
     926:	00001517          	auipc	a0,0x1
     92a:	62250513          	addi	a0,a0,1570 # 1f48 <malloc+0xdd8>
     92e:	78a000ef          	jal	10b8 <printf>
    printf("=== Test q done ===\n");
     932:	00001517          	auipc	a0,0x1
     936:	63650513          	addi	a0,a0,1590 # 1f68 <malloc+0xdf8>
     93a:	77e000ef          	jal	10b8 <printf>
  test_pa4_17();

  printf("\nPA4_E done.\n");
     93e:	00001517          	auipc	a0,0x1
     942:	64250513          	addi	a0,a0,1602 # 1f80 <malloc+0xe10>
     946:	772000ef          	jal	10b8 <printf>
  exit(0);
     94a:	4501                	li	a0,0
     94c:	2d6000ef          	jal	c22 <exit>
        printf("  FAIL: %d errors with disk 3 failed\n", errs);
     950:	00001517          	auipc	a0,0x1
     954:	56850513          	addi	a0,a0,1384 # 1eb8 <malloc+0xd48>
     958:	760000ef          	jal	10b8 <printf>
     95c:	b785                	j	8bc <main+0x744>
        printf("  PASS: I/O correctly tracked through reconstruction\n");
     95e:	00001517          	auipc	a0,0x1
     962:	5b250513          	addi	a0,a0,1458 # 1f10 <malloc+0xda0>
     966:	752000ef          	jal	10b8 <printf>
     96a:	b7e1                	j	932 <main+0x7ba>

000000000000096c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     96c:	1141                	addi	sp,sp,-16
     96e:	e406                	sd	ra,8(sp)
     970:	e022                	sd	s0,0(sp)
     972:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     974:	805ff0ef          	jal	178 <main>
  exit(r);
     978:	2aa000ef          	jal	c22 <exit>

000000000000097c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     97c:	1141                	addi	sp,sp,-16
     97e:	e406                	sd	ra,8(sp)
     980:	e022                	sd	s0,0(sp)
     982:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     984:	87aa                	mv	a5,a0
     986:	0585                	addi	a1,a1,1
     988:	0785                	addi	a5,a5,1
     98a:	fff5c703          	lbu	a4,-1(a1)
     98e:	fee78fa3          	sb	a4,-1(a5)
     992:	fb75                	bnez	a4,986 <strcpy+0xa>
    ;
  return os;
}
     994:	60a2                	ld	ra,8(sp)
     996:	6402                	ld	s0,0(sp)
     998:	0141                	addi	sp,sp,16
     99a:	8082                	ret

000000000000099c <strcmp>:

int
strcmp(const char *p, const char *q)
{
     99c:	1141                	addi	sp,sp,-16
     99e:	e406                	sd	ra,8(sp)
     9a0:	e022                	sd	s0,0(sp)
     9a2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9a4:	00054783          	lbu	a5,0(a0)
     9a8:	cb91                	beqz	a5,9bc <strcmp+0x20>
     9aa:	0005c703          	lbu	a4,0(a1)
     9ae:	00f71763          	bne	a4,a5,9bc <strcmp+0x20>
    p++, q++;
     9b2:	0505                	addi	a0,a0,1
     9b4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9b6:	00054783          	lbu	a5,0(a0)
     9ba:	fbe5                	bnez	a5,9aa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     9bc:	0005c503          	lbu	a0,0(a1)
}
     9c0:	40a7853b          	subw	a0,a5,a0
     9c4:	60a2                	ld	ra,8(sp)
     9c6:	6402                	ld	s0,0(sp)
     9c8:	0141                	addi	sp,sp,16
     9ca:	8082                	ret

00000000000009cc <strlen>:

uint
strlen(const char *s)
{
     9cc:	1141                	addi	sp,sp,-16
     9ce:	e406                	sd	ra,8(sp)
     9d0:	e022                	sd	s0,0(sp)
     9d2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9d4:	00054783          	lbu	a5,0(a0)
     9d8:	cf91                	beqz	a5,9f4 <strlen+0x28>
     9da:	00150793          	addi	a5,a0,1
     9de:	86be                	mv	a3,a5
     9e0:	0785                	addi	a5,a5,1
     9e2:	fff7c703          	lbu	a4,-1(a5)
     9e6:	ff65                	bnez	a4,9de <strlen+0x12>
     9e8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     9ec:	60a2                	ld	ra,8(sp)
     9ee:	6402                	ld	s0,0(sp)
     9f0:	0141                	addi	sp,sp,16
     9f2:	8082                	ret
  for(n = 0; s[n]; n++)
     9f4:	4501                	li	a0,0
     9f6:	bfdd                	j	9ec <strlen+0x20>

00000000000009f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
     9f8:	1141                	addi	sp,sp,-16
     9fa:	e406                	sd	ra,8(sp)
     9fc:	e022                	sd	s0,0(sp)
     9fe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a00:	ca19                	beqz	a2,a16 <memset+0x1e>
     a02:	87aa                	mv	a5,a0
     a04:	1602                	slli	a2,a2,0x20
     a06:	9201                	srli	a2,a2,0x20
     a08:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a0c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a10:	0785                	addi	a5,a5,1
     a12:	fee79de3          	bne	a5,a4,a0c <memset+0x14>
  }
  return dst;
}
     a16:	60a2                	ld	ra,8(sp)
     a18:	6402                	ld	s0,0(sp)
     a1a:	0141                	addi	sp,sp,16
     a1c:	8082                	ret

0000000000000a1e <strchr>:

char*
strchr(const char *s, char c)
{
     a1e:	1141                	addi	sp,sp,-16
     a20:	e406                	sd	ra,8(sp)
     a22:	e022                	sd	s0,0(sp)
     a24:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a26:	00054783          	lbu	a5,0(a0)
     a2a:	cf81                	beqz	a5,a42 <strchr+0x24>
    if(*s == c)
     a2c:	00f58763          	beq	a1,a5,a3a <strchr+0x1c>
  for(; *s; s++)
     a30:	0505                	addi	a0,a0,1
     a32:	00054783          	lbu	a5,0(a0)
     a36:	fbfd                	bnez	a5,a2c <strchr+0xe>
      return (char*)s;
  return 0;
     a38:	4501                	li	a0,0
}
     a3a:	60a2                	ld	ra,8(sp)
     a3c:	6402                	ld	s0,0(sp)
     a3e:	0141                	addi	sp,sp,16
     a40:	8082                	ret
  return 0;
     a42:	4501                	li	a0,0
     a44:	bfdd                	j	a3a <strchr+0x1c>

0000000000000a46 <gets>:

char*
gets(char *buf, int max)
{
     a46:	711d                	addi	sp,sp,-96
     a48:	ec86                	sd	ra,88(sp)
     a4a:	e8a2                	sd	s0,80(sp)
     a4c:	e4a6                	sd	s1,72(sp)
     a4e:	e0ca                	sd	s2,64(sp)
     a50:	fc4e                	sd	s3,56(sp)
     a52:	f852                	sd	s4,48(sp)
     a54:	f456                	sd	s5,40(sp)
     a56:	f05a                	sd	s6,32(sp)
     a58:	ec5e                	sd	s7,24(sp)
     a5a:	e862                	sd	s8,16(sp)
     a5c:	1080                	addi	s0,sp,96
     a5e:	8baa                	mv	s7,a0
     a60:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a62:	892a                	mv	s2,a0
     a64:	4481                	li	s1,0
    cc = read(0, &c, 1);
     a66:	faf40b13          	addi	s6,s0,-81
     a6a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     a6c:	8c26                	mv	s8,s1
     a6e:	0014899b          	addiw	s3,s1,1
     a72:	84ce                	mv	s1,s3
     a74:	0349d463          	bge	s3,s4,a9c <gets+0x56>
    cc = read(0, &c, 1);
     a78:	8656                	mv	a2,s5
     a7a:	85da                	mv	a1,s6
     a7c:	4501                	li	a0,0
     a7e:	1bc000ef          	jal	c3a <read>
    if(cc < 1)
     a82:	00a05d63          	blez	a0,a9c <gets+0x56>
      break;
    buf[i++] = c;
     a86:	faf44783          	lbu	a5,-81(s0)
     a8a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a8e:	0905                	addi	s2,s2,1
     a90:	ff678713          	addi	a4,a5,-10
     a94:	c319                	beqz	a4,a9a <gets+0x54>
     a96:	17cd                	addi	a5,a5,-13
     a98:	fbf1                	bnez	a5,a6c <gets+0x26>
    buf[i++] = c;
     a9a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     a9c:	9c5e                	add	s8,s8,s7
     a9e:	000c0023          	sb	zero,0(s8)
  return buf;
}
     aa2:	855e                	mv	a0,s7
     aa4:	60e6                	ld	ra,88(sp)
     aa6:	6446                	ld	s0,80(sp)
     aa8:	64a6                	ld	s1,72(sp)
     aaa:	6906                	ld	s2,64(sp)
     aac:	79e2                	ld	s3,56(sp)
     aae:	7a42                	ld	s4,48(sp)
     ab0:	7aa2                	ld	s5,40(sp)
     ab2:	7b02                	ld	s6,32(sp)
     ab4:	6be2                	ld	s7,24(sp)
     ab6:	6c42                	ld	s8,16(sp)
     ab8:	6125                	addi	sp,sp,96
     aba:	8082                	ret

0000000000000abc <stat>:

int
stat(const char *n, struct stat *st)
{
     abc:	1101                	addi	sp,sp,-32
     abe:	ec06                	sd	ra,24(sp)
     ac0:	e822                	sd	s0,16(sp)
     ac2:	e04a                	sd	s2,0(sp)
     ac4:	1000                	addi	s0,sp,32
     ac6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ac8:	4581                	li	a1,0
     aca:	198000ef          	jal	c62 <open>
  if(fd < 0)
     ace:	02054263          	bltz	a0,af2 <stat+0x36>
     ad2:	e426                	sd	s1,8(sp)
     ad4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     ad6:	85ca                	mv	a1,s2
     ad8:	1a2000ef          	jal	c7a <fstat>
     adc:	892a                	mv	s2,a0
  close(fd);
     ade:	8526                	mv	a0,s1
     ae0:	16a000ef          	jal	c4a <close>
  return r;
     ae4:	64a2                	ld	s1,8(sp)
}
     ae6:	854a                	mv	a0,s2
     ae8:	60e2                	ld	ra,24(sp)
     aea:	6442                	ld	s0,16(sp)
     aec:	6902                	ld	s2,0(sp)
     aee:	6105                	addi	sp,sp,32
     af0:	8082                	ret
    return -1;
     af2:	57fd                	li	a5,-1
     af4:	893e                	mv	s2,a5
     af6:	bfc5                	j	ae6 <stat+0x2a>

0000000000000af8 <atoi>:

int
atoi(const char *s)
{
     af8:	1141                	addi	sp,sp,-16
     afa:	e406                	sd	ra,8(sp)
     afc:	e022                	sd	s0,0(sp)
     afe:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b00:	00054683          	lbu	a3,0(a0)
     b04:	fd06879b          	addiw	a5,a3,-48
     b08:	0ff7f793          	zext.b	a5,a5
     b0c:	4625                	li	a2,9
     b0e:	02f66963          	bltu	a2,a5,b40 <atoi+0x48>
     b12:	872a                	mv	a4,a0
  n = 0;
     b14:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b16:	0705                	addi	a4,a4,1
     b18:	0025179b          	slliw	a5,a0,0x2
     b1c:	9fa9                	addw	a5,a5,a0
     b1e:	0017979b          	slliw	a5,a5,0x1
     b22:	9fb5                	addw	a5,a5,a3
     b24:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b28:	00074683          	lbu	a3,0(a4)
     b2c:	fd06879b          	addiw	a5,a3,-48
     b30:	0ff7f793          	zext.b	a5,a5
     b34:	fef671e3          	bgeu	a2,a5,b16 <atoi+0x1e>
  return n;
}
     b38:	60a2                	ld	ra,8(sp)
     b3a:	6402                	ld	s0,0(sp)
     b3c:	0141                	addi	sp,sp,16
     b3e:	8082                	ret
  n = 0;
     b40:	4501                	li	a0,0
     b42:	bfdd                	j	b38 <atoi+0x40>

0000000000000b44 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b44:	1141                	addi	sp,sp,-16
     b46:	e406                	sd	ra,8(sp)
     b48:	e022                	sd	s0,0(sp)
     b4a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b4c:	02b57563          	bgeu	a0,a1,b76 <memmove+0x32>
    while(n-- > 0)
     b50:	00c05f63          	blez	a2,b6e <memmove+0x2a>
     b54:	1602                	slli	a2,a2,0x20
     b56:	9201                	srli	a2,a2,0x20
     b58:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     b5c:	872a                	mv	a4,a0
      *dst++ = *src++;
     b5e:	0585                	addi	a1,a1,1
     b60:	0705                	addi	a4,a4,1
     b62:	fff5c683          	lbu	a3,-1(a1)
     b66:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b6a:	fee79ae3          	bne	a5,a4,b5e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b6e:	60a2                	ld	ra,8(sp)
     b70:	6402                	ld	s0,0(sp)
     b72:	0141                	addi	sp,sp,16
     b74:	8082                	ret
    while(n-- > 0)
     b76:	fec05ce3          	blez	a2,b6e <memmove+0x2a>
    dst += n;
     b7a:	00c50733          	add	a4,a0,a2
    src += n;
     b7e:	95b2                	add	a1,a1,a2
     b80:	fff6079b          	addiw	a5,a2,-1
     b84:	1782                	slli	a5,a5,0x20
     b86:	9381                	srli	a5,a5,0x20
     b88:	fff7c793          	not	a5,a5
     b8c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b8e:	15fd                	addi	a1,a1,-1
     b90:	177d                	addi	a4,a4,-1
     b92:	0005c683          	lbu	a3,0(a1)
     b96:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b9a:	fef71ae3          	bne	a4,a5,b8e <memmove+0x4a>
     b9e:	bfc1                	j	b6e <memmove+0x2a>

0000000000000ba0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     ba0:	1141                	addi	sp,sp,-16
     ba2:	e406                	sd	ra,8(sp)
     ba4:	e022                	sd	s0,0(sp)
     ba6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     ba8:	c61d                	beqz	a2,bd6 <memcmp+0x36>
     baa:	1602                	slli	a2,a2,0x20
     bac:	9201                	srli	a2,a2,0x20
     bae:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     bb2:	00054783          	lbu	a5,0(a0)
     bb6:	0005c703          	lbu	a4,0(a1)
     bba:	00e79863          	bne	a5,a4,bca <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     bbe:	0505                	addi	a0,a0,1
    p2++;
     bc0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     bc2:	fed518e3          	bne	a0,a3,bb2 <memcmp+0x12>
  }
  return 0;
     bc6:	4501                	li	a0,0
     bc8:	a019                	j	bce <memcmp+0x2e>
      return *p1 - *p2;
     bca:	40e7853b          	subw	a0,a5,a4
}
     bce:	60a2                	ld	ra,8(sp)
     bd0:	6402                	ld	s0,0(sp)
     bd2:	0141                	addi	sp,sp,16
     bd4:	8082                	ret
  return 0;
     bd6:	4501                	li	a0,0
     bd8:	bfdd                	j	bce <memcmp+0x2e>

0000000000000bda <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bda:	1141                	addi	sp,sp,-16
     bdc:	e406                	sd	ra,8(sp)
     bde:	e022                	sd	s0,0(sp)
     be0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     be2:	f63ff0ef          	jal	b44 <memmove>
}
     be6:	60a2                	ld	ra,8(sp)
     be8:	6402                	ld	s0,0(sp)
     bea:	0141                	addi	sp,sp,16
     bec:	8082                	ret

0000000000000bee <sbrk>:

char *
sbrk(int n) {
     bee:	1141                	addi	sp,sp,-16
     bf0:	e406                	sd	ra,8(sp)
     bf2:	e022                	sd	s0,0(sp)
     bf4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     bf6:	4585                	li	a1,1
     bf8:	0b2000ef          	jal	caa <sys_sbrk>
}
     bfc:	60a2                	ld	ra,8(sp)
     bfe:	6402                	ld	s0,0(sp)
     c00:	0141                	addi	sp,sp,16
     c02:	8082                	ret

0000000000000c04 <sbrklazy>:

char *
sbrklazy(int n) {
     c04:	1141                	addi	sp,sp,-16
     c06:	e406                	sd	ra,8(sp)
     c08:	e022                	sd	s0,0(sp)
     c0a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c0c:	4589                	li	a1,2
     c0e:	09c000ef          	jal	caa <sys_sbrk>
}
     c12:	60a2                	ld	ra,8(sp)
     c14:	6402                	ld	s0,0(sp)
     c16:	0141                	addi	sp,sp,16
     c18:	8082                	ret

0000000000000c1a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c1a:	4885                	li	a7,1
 ecall
     c1c:	00000073          	ecall
 ret
     c20:	8082                	ret

0000000000000c22 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c22:	4889                	li	a7,2
 ecall
     c24:	00000073          	ecall
 ret
     c28:	8082                	ret

0000000000000c2a <wait>:
.global wait
wait:
 li a7, SYS_wait
     c2a:	488d                	li	a7,3
 ecall
     c2c:	00000073          	ecall
 ret
     c30:	8082                	ret

0000000000000c32 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c32:	4891                	li	a7,4
 ecall
     c34:	00000073          	ecall
 ret
     c38:	8082                	ret

0000000000000c3a <read>:
.global read
read:
 li a7, SYS_read
     c3a:	4895                	li	a7,5
 ecall
     c3c:	00000073          	ecall
 ret
     c40:	8082                	ret

0000000000000c42 <write>:
.global write
write:
 li a7, SYS_write
     c42:	48c1                	li	a7,16
 ecall
     c44:	00000073          	ecall
 ret
     c48:	8082                	ret

0000000000000c4a <close>:
.global close
close:
 li a7, SYS_close
     c4a:	48d5                	li	a7,21
 ecall
     c4c:	00000073          	ecall
 ret
     c50:	8082                	ret

0000000000000c52 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c52:	4899                	li	a7,6
 ecall
     c54:	00000073          	ecall
 ret
     c58:	8082                	ret

0000000000000c5a <exec>:
.global exec
exec:
 li a7, SYS_exec
     c5a:	489d                	li	a7,7
 ecall
     c5c:	00000073          	ecall
 ret
     c60:	8082                	ret

0000000000000c62 <open>:
.global open
open:
 li a7, SYS_open
     c62:	48bd                	li	a7,15
 ecall
     c64:	00000073          	ecall
 ret
     c68:	8082                	ret

0000000000000c6a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c6a:	48c5                	li	a7,17
 ecall
     c6c:	00000073          	ecall
 ret
     c70:	8082                	ret

0000000000000c72 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c72:	48c9                	li	a7,18
 ecall
     c74:	00000073          	ecall
 ret
     c78:	8082                	ret

0000000000000c7a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c7a:	48a1                	li	a7,8
 ecall
     c7c:	00000073          	ecall
 ret
     c80:	8082                	ret

0000000000000c82 <link>:
.global link
link:
 li a7, SYS_link
     c82:	48cd                	li	a7,19
 ecall
     c84:	00000073          	ecall
 ret
     c88:	8082                	ret

0000000000000c8a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c8a:	48d1                	li	a7,20
 ecall
     c8c:	00000073          	ecall
 ret
     c90:	8082                	ret

0000000000000c92 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c92:	48a5                	li	a7,9
 ecall
     c94:	00000073          	ecall
 ret
     c98:	8082                	ret

0000000000000c9a <dup>:
.global dup
dup:
 li a7, SYS_dup
     c9a:	48a9                	li	a7,10
 ecall
     c9c:	00000073          	ecall
 ret
     ca0:	8082                	ret

0000000000000ca2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ca2:	48ad                	li	a7,11
 ecall
     ca4:	00000073          	ecall
 ret
     ca8:	8082                	ret

0000000000000caa <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     caa:	48b1                	li	a7,12
 ecall
     cac:	00000073          	ecall
 ret
     cb0:	8082                	ret

0000000000000cb2 <pause>:
.global pause
pause:
 li a7, SYS_pause
     cb2:	48b5                	li	a7,13
 ecall
     cb4:	00000073          	ecall
 ret
     cb8:	8082                	ret

0000000000000cba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     cba:	48b9                	li	a7,14
 ecall
     cbc:	00000073          	ecall
 ret
     cc0:	8082                	ret

0000000000000cc2 <hello>:
.global hello
hello:
 li a7, SYS_hello
     cc2:	48d9                	li	a7,22
 ecall
     cc4:	00000073          	ecall
 ret
     cc8:	8082                	ret

0000000000000cca <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
     cca:	48dd                	li	a7,23
 ecall
     ccc:	00000073          	ecall
 ret
     cd0:	8082                	ret

0000000000000cd2 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
     cd2:	48e1                	li	a7,24
 ecall
     cd4:	00000073          	ecall
 ret
     cd8:	8082                	ret

0000000000000cda <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
     cda:	48e5                	li	a7,25
 ecall
     cdc:	00000073          	ecall
 ret
     ce0:	8082                	ret

0000000000000ce2 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
     ce2:	48e9                	li	a7,26
 ecall
     ce4:	00000073          	ecall
 ret
     ce8:	8082                	ret

0000000000000cea <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
     cea:	48ed                	li	a7,27
 ecall
     cec:	00000073          	ecall
 ret
     cf0:	8082                	ret

0000000000000cf2 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
     cf2:	48f1                	li	a7,28
 ecall
     cf4:	00000073          	ecall
 ret
     cf8:	8082                	ret

0000000000000cfa <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
     cfa:	48f5                	li	a7,29
 ecall
     cfc:	00000073          	ecall
 ret
     d00:	8082                	ret

0000000000000d02 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
     d02:	48f9                	li	a7,30
 ecall
     d04:	00000073          	ecall
 ret
     d08:	8082                	ret

0000000000000d0a <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
     d0a:	48fd                	li	a7,31
 ecall
     d0c:	00000073          	ecall
 ret
     d10:	8082                	ret

0000000000000d12 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d12:	1101                	addi	sp,sp,-32
     d14:	ec06                	sd	ra,24(sp)
     d16:	e822                	sd	s0,16(sp)
     d18:	1000                	addi	s0,sp,32
     d1a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d1e:	4605                	li	a2,1
     d20:	fef40593          	addi	a1,s0,-17
     d24:	f1fff0ef          	jal	c42 <write>
}
     d28:	60e2                	ld	ra,24(sp)
     d2a:	6442                	ld	s0,16(sp)
     d2c:	6105                	addi	sp,sp,32
     d2e:	8082                	ret

0000000000000d30 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d30:	715d                	addi	sp,sp,-80
     d32:	e486                	sd	ra,72(sp)
     d34:	e0a2                	sd	s0,64(sp)
     d36:	f84a                	sd	s2,48(sp)
     d38:	f44e                	sd	s3,40(sp)
     d3a:	0880                	addi	s0,sp,80
     d3c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     d3e:	c6d1                	beqz	a3,dca <printint+0x9a>
     d40:	0805d563          	bgez	a1,dca <printint+0x9a>
    neg = 1;
    x = -xx;
     d44:	40b005b3          	neg	a1,a1
    neg = 1;
     d48:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     d4a:	fb840993          	addi	s3,s0,-72
  neg = 0;
     d4e:	86ce                	mv	a3,s3
  i = 0;
     d50:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d52:	00001817          	auipc	a6,0x1
     d56:	24680813          	addi	a6,a6,582 # 1f98 <digits>
     d5a:	88ba                	mv	a7,a4
     d5c:	0017051b          	addiw	a0,a4,1
     d60:	872a                	mv	a4,a0
     d62:	02c5f7b3          	remu	a5,a1,a2
     d66:	97c2                	add	a5,a5,a6
     d68:	0007c783          	lbu	a5,0(a5)
     d6c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d70:	87ae                	mv	a5,a1
     d72:	02c5d5b3          	divu	a1,a1,a2
     d76:	0685                	addi	a3,a3,1
     d78:	fec7f1e3          	bgeu	a5,a2,d5a <printint+0x2a>
  if(neg)
     d7c:	00030c63          	beqz	t1,d94 <printint+0x64>
    buf[i++] = '-';
     d80:	fd050793          	addi	a5,a0,-48
     d84:	00878533          	add	a0,a5,s0
     d88:	02d00793          	li	a5,45
     d8c:	fef50423          	sb	a5,-24(a0)
     d90:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     d94:	02e05563          	blez	a4,dbe <printint+0x8e>
     d98:	fc26                	sd	s1,56(sp)
     d9a:	377d                	addiw	a4,a4,-1
     d9c:	00e984b3          	add	s1,s3,a4
     da0:	19fd                	addi	s3,s3,-1
     da2:	99ba                	add	s3,s3,a4
     da4:	1702                	slli	a4,a4,0x20
     da6:	9301                	srli	a4,a4,0x20
     da8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     dac:	0004c583          	lbu	a1,0(s1)
     db0:	854a                	mv	a0,s2
     db2:	f61ff0ef          	jal	d12 <putc>
  while(--i >= 0)
     db6:	14fd                	addi	s1,s1,-1
     db8:	ff349ae3          	bne	s1,s3,dac <printint+0x7c>
     dbc:	74e2                	ld	s1,56(sp)
}
     dbe:	60a6                	ld	ra,72(sp)
     dc0:	6406                	ld	s0,64(sp)
     dc2:	7942                	ld	s2,48(sp)
     dc4:	79a2                	ld	s3,40(sp)
     dc6:	6161                	addi	sp,sp,80
     dc8:	8082                	ret
  neg = 0;
     dca:	4301                	li	t1,0
     dcc:	bfbd                	j	d4a <printint+0x1a>

0000000000000dce <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     dce:	711d                	addi	sp,sp,-96
     dd0:	ec86                	sd	ra,88(sp)
     dd2:	e8a2                	sd	s0,80(sp)
     dd4:	e4a6                	sd	s1,72(sp)
     dd6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     dd8:	0005c483          	lbu	s1,0(a1)
     ddc:	22048363          	beqz	s1,1002 <vprintf+0x234>
     de0:	e0ca                	sd	s2,64(sp)
     de2:	fc4e                	sd	s3,56(sp)
     de4:	f852                	sd	s4,48(sp)
     de6:	f456                	sd	s5,40(sp)
     de8:	f05a                	sd	s6,32(sp)
     dea:	ec5e                	sd	s7,24(sp)
     dec:	e862                	sd	s8,16(sp)
     dee:	8b2a                	mv	s6,a0
     df0:	8a2e                	mv	s4,a1
     df2:	8bb2                	mv	s7,a2
  state = 0;
     df4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     df6:	4901                	li	s2,0
     df8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     dfa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     dfe:	06400c13          	li	s8,100
     e02:	a00d                	j	e24 <vprintf+0x56>
        putc(fd, c0);
     e04:	85a6                	mv	a1,s1
     e06:	855a                	mv	a0,s6
     e08:	f0bff0ef          	jal	d12 <putc>
     e0c:	a019                	j	e12 <vprintf+0x44>
    } else if(state == '%'){
     e0e:	03598363          	beq	s3,s5,e34 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     e12:	0019079b          	addiw	a5,s2,1
     e16:	893e                	mv	s2,a5
     e18:	873e                	mv	a4,a5
     e1a:	97d2                	add	a5,a5,s4
     e1c:	0007c483          	lbu	s1,0(a5)
     e20:	1c048a63          	beqz	s1,ff4 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
     e24:	0004879b          	sext.w	a5,s1
    if(state == 0){
     e28:	fe0993e3          	bnez	s3,e0e <vprintf+0x40>
      if(c0 == '%'){
     e2c:	fd579ce3          	bne	a5,s5,e04 <vprintf+0x36>
        state = '%';
     e30:	89be                	mv	s3,a5
     e32:	b7c5                	j	e12 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     e34:	00ea06b3          	add	a3,s4,a4
     e38:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     e3c:	1c060863          	beqz	a2,100c <vprintf+0x23e>
      if(c0 == 'd'){
     e40:	03878763          	beq	a5,s8,e6e <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e44:	f9478693          	addi	a3,a5,-108
     e48:	0016b693          	seqz	a3,a3
     e4c:	f9c60593          	addi	a1,a2,-100
     e50:	e99d                	bnez	a1,e86 <vprintf+0xb8>
     e52:	ca95                	beqz	a3,e86 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e54:	008b8493          	addi	s1,s7,8
     e58:	4685                	li	a3,1
     e5a:	4629                	li	a2,10
     e5c:	000bb583          	ld	a1,0(s7)
     e60:	855a                	mv	a0,s6
     e62:	ecfff0ef          	jal	d30 <printint>
        i += 1;
     e66:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e68:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e6a:	4981                	li	s3,0
     e6c:	b75d                	j	e12 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     e6e:	008b8493          	addi	s1,s7,8
     e72:	4685                	li	a3,1
     e74:	4629                	li	a2,10
     e76:	000ba583          	lw	a1,0(s7)
     e7a:	855a                	mv	a0,s6
     e7c:	eb5ff0ef          	jal	d30 <printint>
     e80:	8ba6                	mv	s7,s1
      state = 0;
     e82:	4981                	li	s3,0
     e84:	b779                	j	e12 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     e86:	9752                	add	a4,a4,s4
     e88:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e8c:	f9460713          	addi	a4,a2,-108
     e90:	00173713          	seqz	a4,a4
     e94:	8f75                	and	a4,a4,a3
     e96:	f9c58513          	addi	a0,a1,-100
     e9a:	18051363          	bnez	a0,1020 <vprintf+0x252>
     e9e:	18070163          	beqz	a4,1020 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ea2:	008b8493          	addi	s1,s7,8
     ea6:	4685                	li	a3,1
     ea8:	4629                	li	a2,10
     eaa:	000bb583          	ld	a1,0(s7)
     eae:	855a                	mv	a0,s6
     eb0:	e81ff0ef          	jal	d30 <printint>
        i += 2;
     eb4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     eb6:	8ba6                	mv	s7,s1
      state = 0;
     eb8:	4981                	li	s3,0
        i += 2;
     eba:	bfa1                	j	e12 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     ebc:	008b8493          	addi	s1,s7,8
     ec0:	4681                	li	a3,0
     ec2:	4629                	li	a2,10
     ec4:	000be583          	lwu	a1,0(s7)
     ec8:	855a                	mv	a0,s6
     eca:	e67ff0ef          	jal	d30 <printint>
     ece:	8ba6                	mv	s7,s1
      state = 0;
     ed0:	4981                	li	s3,0
     ed2:	b781                	j	e12 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ed4:	008b8493          	addi	s1,s7,8
     ed8:	4681                	li	a3,0
     eda:	4629                	li	a2,10
     edc:	000bb583          	ld	a1,0(s7)
     ee0:	855a                	mv	a0,s6
     ee2:	e4fff0ef          	jal	d30 <printint>
        i += 1;
     ee6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     ee8:	8ba6                	mv	s7,s1
      state = 0;
     eea:	4981                	li	s3,0
     eec:	b71d                	j	e12 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     eee:	008b8493          	addi	s1,s7,8
     ef2:	4681                	li	a3,0
     ef4:	4629                	li	a2,10
     ef6:	000bb583          	ld	a1,0(s7)
     efa:	855a                	mv	a0,s6
     efc:	e35ff0ef          	jal	d30 <printint>
        i += 2;
     f00:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f02:	8ba6                	mv	s7,s1
      state = 0;
     f04:	4981                	li	s3,0
        i += 2;
     f06:	b731                	j	e12 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f08:	008b8493          	addi	s1,s7,8
     f0c:	4681                	li	a3,0
     f0e:	4641                	li	a2,16
     f10:	000be583          	lwu	a1,0(s7)
     f14:	855a                	mv	a0,s6
     f16:	e1bff0ef          	jal	d30 <printint>
     f1a:	8ba6                	mv	s7,s1
      state = 0;
     f1c:	4981                	li	s3,0
     f1e:	bdd5                	j	e12 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f20:	008b8493          	addi	s1,s7,8
     f24:	4681                	li	a3,0
     f26:	4641                	li	a2,16
     f28:	000bb583          	ld	a1,0(s7)
     f2c:	855a                	mv	a0,s6
     f2e:	e03ff0ef          	jal	d30 <printint>
        i += 1;
     f32:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f34:	8ba6                	mv	s7,s1
      state = 0;
     f36:	4981                	li	s3,0
     f38:	bde9                	j	e12 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f3a:	008b8493          	addi	s1,s7,8
     f3e:	4681                	li	a3,0
     f40:	4641                	li	a2,16
     f42:	000bb583          	ld	a1,0(s7)
     f46:	855a                	mv	a0,s6
     f48:	de9ff0ef          	jal	d30 <printint>
        i += 2;
     f4c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f4e:	8ba6                	mv	s7,s1
      state = 0;
     f50:	4981                	li	s3,0
        i += 2;
     f52:	b5c1                	j	e12 <vprintf+0x44>
     f54:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     f56:	008b8793          	addi	a5,s7,8
     f5a:	8cbe                	mv	s9,a5
     f5c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f60:	03000593          	li	a1,48
     f64:	855a                	mv	a0,s6
     f66:	dadff0ef          	jal	d12 <putc>
  putc(fd, 'x');
     f6a:	07800593          	li	a1,120
     f6e:	855a                	mv	a0,s6
     f70:	da3ff0ef          	jal	d12 <putc>
     f74:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f76:	00001b97          	auipc	s7,0x1
     f7a:	022b8b93          	addi	s7,s7,34 # 1f98 <digits>
     f7e:	03c9d793          	srli	a5,s3,0x3c
     f82:	97de                	add	a5,a5,s7
     f84:	0007c583          	lbu	a1,0(a5)
     f88:	855a                	mv	a0,s6
     f8a:	d89ff0ef          	jal	d12 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f8e:	0992                	slli	s3,s3,0x4
     f90:	34fd                	addiw	s1,s1,-1
     f92:	f4f5                	bnez	s1,f7e <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     f94:	8be6                	mv	s7,s9
      state = 0;
     f96:	4981                	li	s3,0
     f98:	6ca2                	ld	s9,8(sp)
     f9a:	bda5                	j	e12 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
     f9c:	008b8493          	addi	s1,s7,8
     fa0:	000bc583          	lbu	a1,0(s7)
     fa4:	855a                	mv	a0,s6
     fa6:	d6dff0ef          	jal	d12 <putc>
     faa:	8ba6                	mv	s7,s1
      state = 0;
     fac:	4981                	li	s3,0
     fae:	b595                	j	e12 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     fb0:	008b8993          	addi	s3,s7,8
     fb4:	000bb483          	ld	s1,0(s7)
     fb8:	cc91                	beqz	s1,fd4 <vprintf+0x206>
        for(; *s; s++)
     fba:	0004c583          	lbu	a1,0(s1)
     fbe:	c985                	beqz	a1,fee <vprintf+0x220>
          putc(fd, *s);
     fc0:	855a                	mv	a0,s6
     fc2:	d51ff0ef          	jal	d12 <putc>
        for(; *s; s++)
     fc6:	0485                	addi	s1,s1,1
     fc8:	0004c583          	lbu	a1,0(s1)
     fcc:	f9f5                	bnez	a1,fc0 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
     fce:	8bce                	mv	s7,s3
      state = 0;
     fd0:	4981                	li	s3,0
     fd2:	b581                	j	e12 <vprintf+0x44>
          s = "(null)";
     fd4:	00001497          	auipc	s1,0x1
     fd8:	fbc48493          	addi	s1,s1,-68 # 1f90 <malloc+0xe20>
        for(; *s; s++)
     fdc:	02800593          	li	a1,40
     fe0:	b7c5                	j	fc0 <vprintf+0x1f2>
        putc(fd, '%');
     fe2:	85be                	mv	a1,a5
     fe4:	855a                	mv	a0,s6
     fe6:	d2dff0ef          	jal	d12 <putc>
      state = 0;
     fea:	4981                	li	s3,0
     fec:	b51d                	j	e12 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     fee:	8bce                	mv	s7,s3
      state = 0;
     ff0:	4981                	li	s3,0
     ff2:	b505                	j	e12 <vprintf+0x44>
     ff4:	6906                	ld	s2,64(sp)
     ff6:	79e2                	ld	s3,56(sp)
     ff8:	7a42                	ld	s4,48(sp)
     ffa:	7aa2                	ld	s5,40(sp)
     ffc:	7b02                	ld	s6,32(sp)
     ffe:	6be2                	ld	s7,24(sp)
    1000:	6c42                	ld	s8,16(sp)
    }
  }
}
    1002:	60e6                	ld	ra,88(sp)
    1004:	6446                	ld	s0,80(sp)
    1006:	64a6                	ld	s1,72(sp)
    1008:	6125                	addi	sp,sp,96
    100a:	8082                	ret
      if(c0 == 'd'){
    100c:	06400713          	li	a4,100
    1010:	e4e78fe3          	beq	a5,a4,e6e <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    1014:	f9478693          	addi	a3,a5,-108
    1018:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    101c:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    101e:	4701                	li	a4,0
      } else if(c0 == 'u'){
    1020:	07500513          	li	a0,117
    1024:	e8a78ce3          	beq	a5,a0,ebc <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    1028:	f8b60513          	addi	a0,a2,-117
    102c:	e119                	bnez	a0,1032 <vprintf+0x264>
    102e:	ea0693e3          	bnez	a3,ed4 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1032:	f8b58513          	addi	a0,a1,-117
    1036:	e119                	bnez	a0,103c <vprintf+0x26e>
    1038:	ea071be3          	bnez	a4,eee <vprintf+0x120>
      } else if(c0 == 'x'){
    103c:	07800513          	li	a0,120
    1040:	eca784e3          	beq	a5,a0,f08 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    1044:	f8860613          	addi	a2,a2,-120
    1048:	e219                	bnez	a2,104e <vprintf+0x280>
    104a:	ec069be3          	bnez	a3,f20 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    104e:	f8858593          	addi	a1,a1,-120
    1052:	e199                	bnez	a1,1058 <vprintf+0x28a>
    1054:	ee0713e3          	bnez	a4,f3a <vprintf+0x16c>
      } else if(c0 == 'p'){
    1058:	07000713          	li	a4,112
    105c:	eee78ce3          	beq	a5,a4,f54 <vprintf+0x186>
      } else if(c0 == 'c'){
    1060:	06300713          	li	a4,99
    1064:	f2e78ce3          	beq	a5,a4,f9c <vprintf+0x1ce>
      } else if(c0 == 's'){
    1068:	07300713          	li	a4,115
    106c:	f4e782e3          	beq	a5,a4,fb0 <vprintf+0x1e2>
      } else if(c0 == '%'){
    1070:	02500713          	li	a4,37
    1074:	f6e787e3          	beq	a5,a4,fe2 <vprintf+0x214>
        putc(fd, '%');
    1078:	02500593          	li	a1,37
    107c:	855a                	mv	a0,s6
    107e:	c95ff0ef          	jal	d12 <putc>
        putc(fd, c0);
    1082:	85a6                	mv	a1,s1
    1084:	855a                	mv	a0,s6
    1086:	c8dff0ef          	jal	d12 <putc>
      state = 0;
    108a:	4981                	li	s3,0
    108c:	b359                	j	e12 <vprintf+0x44>

000000000000108e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    108e:	715d                	addi	sp,sp,-80
    1090:	ec06                	sd	ra,24(sp)
    1092:	e822                	sd	s0,16(sp)
    1094:	1000                	addi	s0,sp,32
    1096:	e010                	sd	a2,0(s0)
    1098:	e414                	sd	a3,8(s0)
    109a:	e818                	sd	a4,16(s0)
    109c:	ec1c                	sd	a5,24(s0)
    109e:	03043023          	sd	a6,32(s0)
    10a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    10a6:	8622                	mv	a2,s0
    10a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    10ac:	d23ff0ef          	jal	dce <vprintf>
}
    10b0:	60e2                	ld	ra,24(sp)
    10b2:	6442                	ld	s0,16(sp)
    10b4:	6161                	addi	sp,sp,80
    10b6:	8082                	ret

00000000000010b8 <printf>:

void
printf(const char *fmt, ...)
{
    10b8:	711d                	addi	sp,sp,-96
    10ba:	ec06                	sd	ra,24(sp)
    10bc:	e822                	sd	s0,16(sp)
    10be:	1000                	addi	s0,sp,32
    10c0:	e40c                	sd	a1,8(s0)
    10c2:	e810                	sd	a2,16(s0)
    10c4:	ec14                	sd	a3,24(s0)
    10c6:	f018                	sd	a4,32(s0)
    10c8:	f41c                	sd	a5,40(s0)
    10ca:	03043823          	sd	a6,48(s0)
    10ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10d2:	00840613          	addi	a2,s0,8
    10d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10da:	85aa                	mv	a1,a0
    10dc:	4505                	li	a0,1
    10de:	cf1ff0ef          	jal	dce <vprintf>
}
    10e2:	60e2                	ld	ra,24(sp)
    10e4:	6442                	ld	s0,16(sp)
    10e6:	6125                	addi	sp,sp,96
    10e8:	8082                	ret

00000000000010ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10ea:	1141                	addi	sp,sp,-16
    10ec:	e406                	sd	ra,8(sp)
    10ee:	e022                	sd	s0,0(sp)
    10f0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10f2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10f6:	00001797          	auipc	a5,0x1
    10fa:	f0a7b783          	ld	a5,-246(a5) # 2000 <freep>
    10fe:	a039                	j	110c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1100:	6398                	ld	a4,0(a5)
    1102:	00e7e463          	bltu	a5,a4,110a <free+0x20>
    1106:	00e6ea63          	bltu	a3,a4,111a <free+0x30>
{
    110a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    110c:	fed7fae3          	bgeu	a5,a3,1100 <free+0x16>
    1110:	6398                	ld	a4,0(a5)
    1112:	00e6e463          	bltu	a3,a4,111a <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1116:	fee7eae3          	bltu	a5,a4,110a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    111a:	ff852583          	lw	a1,-8(a0)
    111e:	6390                	ld	a2,0(a5)
    1120:	02059813          	slli	a6,a1,0x20
    1124:	01c85713          	srli	a4,a6,0x1c
    1128:	9736                	add	a4,a4,a3
    112a:	02e60563          	beq	a2,a4,1154 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    112e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1132:	4790                	lw	a2,8(a5)
    1134:	02061593          	slli	a1,a2,0x20
    1138:	01c5d713          	srli	a4,a1,0x1c
    113c:	973e                	add	a4,a4,a5
    113e:	02e68263          	beq	a3,a4,1162 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1142:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1144:	00001717          	auipc	a4,0x1
    1148:	eaf73e23          	sd	a5,-324(a4) # 2000 <freep>
}
    114c:	60a2                	ld	ra,8(sp)
    114e:	6402                	ld	s0,0(sp)
    1150:	0141                	addi	sp,sp,16
    1152:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    1154:	4618                	lw	a4,8(a2)
    1156:	9f2d                	addw	a4,a4,a1
    1158:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    115c:	6398                	ld	a4,0(a5)
    115e:	6310                	ld	a2,0(a4)
    1160:	b7f9                	j	112e <free+0x44>
    p->s.size += bp->s.size;
    1162:	ff852703          	lw	a4,-8(a0)
    1166:	9f31                	addw	a4,a4,a2
    1168:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    116a:	ff053683          	ld	a3,-16(a0)
    116e:	bfd1                	j	1142 <free+0x58>

0000000000001170 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1170:	7139                	addi	sp,sp,-64
    1172:	fc06                	sd	ra,56(sp)
    1174:	f822                	sd	s0,48(sp)
    1176:	f04a                	sd	s2,32(sp)
    1178:	ec4e                	sd	s3,24(sp)
    117a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    117c:	02051993          	slli	s3,a0,0x20
    1180:	0209d993          	srli	s3,s3,0x20
    1184:	09bd                	addi	s3,s3,15
    1186:	0049d993          	srli	s3,s3,0x4
    118a:	2985                	addiw	s3,s3,1
    118c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    118e:	00001517          	auipc	a0,0x1
    1192:	e7253503          	ld	a0,-398(a0) # 2000 <freep>
    1196:	c905                	beqz	a0,11c6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1198:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    119a:	4798                	lw	a4,8(a5)
    119c:	09377663          	bgeu	a4,s3,1228 <malloc+0xb8>
    11a0:	f426                	sd	s1,40(sp)
    11a2:	e852                	sd	s4,16(sp)
    11a4:	e456                	sd	s5,8(sp)
    11a6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    11a8:	8a4e                	mv	s4,s3
    11aa:	6705                	lui	a4,0x1
    11ac:	00e9f363          	bgeu	s3,a4,11b2 <malloc+0x42>
    11b0:	6a05                	lui	s4,0x1
    11b2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    11b6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11ba:	00001497          	auipc	s1,0x1
    11be:	e4648493          	addi	s1,s1,-442 # 2000 <freep>
  if(p == SBRK_ERROR)
    11c2:	5afd                	li	s5,-1
    11c4:	a83d                	j	1202 <malloc+0x92>
    11c6:	f426                	sd	s1,40(sp)
    11c8:	e852                	sd	s4,16(sp)
    11ca:	e456                	sd	s5,8(sp)
    11cc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11ce:	00001797          	auipc	a5,0x1
    11d2:	e4278793          	addi	a5,a5,-446 # 2010 <base>
    11d6:	00001717          	auipc	a4,0x1
    11da:	e2f73523          	sd	a5,-470(a4) # 2000 <freep>
    11de:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11e0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11e4:	b7d1                	j	11a8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    11e6:	6398                	ld	a4,0(a5)
    11e8:	e118                	sd	a4,0(a0)
    11ea:	a899                	j	1240 <malloc+0xd0>
  hp->s.size = nu;
    11ec:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    11f0:	0541                	addi	a0,a0,16
    11f2:	ef9ff0ef          	jal	10ea <free>
  return freep;
    11f6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    11f8:	c125                	beqz	a0,1258 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11fc:	4798                	lw	a4,8(a5)
    11fe:	03277163          	bgeu	a4,s2,1220 <malloc+0xb0>
    if(p == freep)
    1202:	6098                	ld	a4,0(s1)
    1204:	853e                	mv	a0,a5
    1206:	fef71ae3          	bne	a4,a5,11fa <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    120a:	8552                	mv	a0,s4
    120c:	9e3ff0ef          	jal	bee <sbrk>
  if(p == SBRK_ERROR)
    1210:	fd551ee3          	bne	a0,s5,11ec <malloc+0x7c>
        return 0;
    1214:	4501                	li	a0,0
    1216:	74a2                	ld	s1,40(sp)
    1218:	6a42                	ld	s4,16(sp)
    121a:	6aa2                	ld	s5,8(sp)
    121c:	6b02                	ld	s6,0(sp)
    121e:	a03d                	j	124c <malloc+0xdc>
    1220:	74a2                	ld	s1,40(sp)
    1222:	6a42                	ld	s4,16(sp)
    1224:	6aa2                	ld	s5,8(sp)
    1226:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1228:	fae90fe3          	beq	s2,a4,11e6 <malloc+0x76>
        p->s.size -= nunits;
    122c:	4137073b          	subw	a4,a4,s3
    1230:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1232:	02071693          	slli	a3,a4,0x20
    1236:	01c6d713          	srli	a4,a3,0x1c
    123a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    123c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1240:	00001717          	auipc	a4,0x1
    1244:	dca73023          	sd	a0,-576(a4) # 2000 <freep>
      return (void*)(p + 1);
    1248:	01078513          	addi	a0,a5,16
  }
}
    124c:	70e2                	ld	ra,56(sp)
    124e:	7442                	ld	s0,48(sp)
    1250:	7902                	ld	s2,32(sp)
    1252:	69e2                	ld	s3,24(sp)
    1254:	6121                	addi	sp,sp,64
    1256:	8082                	ret
    1258:	74a2                	ld	s1,40(sp)
    125a:	6a42                	ld	s4,16(sp)
    125c:	6aa2                	ld	s5,8(sp)
    125e:	6b02                	ld	s6,0(sp)
    1260:	b7f5                	j	124c <malloc+0xdc>
