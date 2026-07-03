
user/_PA4_3:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
    printf("=== Test 7 done ===\n");
}

int
main(void)
{
       0:	716d                	addi	sp,sp,-272
       2:	e606                	sd	ra,264(sp)
       4:	e222                	sd	s0,256(sp)
       6:	0a00                	addi	s0,sp,272
  printf("==============================\n");
       8:	00001517          	auipc	a0,0x1
       c:	18850513          	addi	a0,a0,392 # 1190 <malloc+0xfa>
      10:	7cf000ef          	jal	fde <printf>
  printf("PA4_C: Multi-process pressure & stat isolation\n");
      14:	00001517          	auipc	a0,0x1
      18:	19c50513          	addi	a0,a0,412 # 11b0 <malloc+0x11a>
      1c:	7c3000ef          	jal	fde <printf>
  printf("==============================\n\n");
      20:	00001517          	auipc	a0,0x1
      24:	1c050513          	addi	a0,a0,448 # 11e0 <malloc+0x14a>
      28:	7b7000ef          	jal	fde <printf>

  printf("--- PA4_5: scheduler-aware eviction ---\n");
      2c:	00001517          	auipc	a0,0x1
      30:	1dc50513          	addi	a0,a0,476 # 1208 <malloc+0x172>
      34:	7ab000ef          	jal	fde <printf>
    pipe(pipe_lo);
      38:	ef840513          	addi	a0,s0,-264
      3c:	31d000ef          	jal	b58 <pipe>
    pipe(pipe_hi);
      40:	f0040513          	addi	a0,s0,-256
      44:	315000ef          	jal	b58 <pipe>
    printf("=== test_sched_aware: Scheduler-Aware Eviction Test ===\n");
      48:	00001517          	auipc	a0,0x1
      4c:	1f050513          	addi	a0,a0,496 # 1238 <malloc+0x1a2>
      50:	78f000ef          	jal	fde <printf>
    int pid_lo = fork();
      54:	2ed000ef          	jal	b40 <fork>
    if (pid_lo == 0) {
      58:	28050b63          	beqz	a0,2ee <main+0x2ee>
      5c:	fda6                	sd	s1,248(sp)
    int pid_hi = fork();
      5e:	2e3000ef          	jal	b40 <fork>
      62:	84aa                	mv	s1,a0
    if (pid_hi == 0) {
      64:	34050d63          	beqz	a0,3be <main+0x3be>
      68:	f9ca                	sd	s2,240(sp)
      6a:	f5ce                	sd	s3,232(sp)
    close(pipe_lo[1]); close(pipe_hi[1]);
      6c:	efc42503          	lw	a0,-260(s0)
      70:	301000ef          	jal	b70 <close>
      74:	f0442503          	lw	a0,-252(s0)
      78:	2f9000ef          	jal	b70 <close>
    read(pipe_lo[0], &cpid_lo, sizeof(cpid_lo));
      7c:	4611                	li	a2,4
      7e:	ef040593          	addi	a1,s0,-272
      82:	ef842503          	lw	a0,-264(s0)
      86:	2db000ef          	jal	b60 <read>
    read(pipe_hi[0], &cpid_hi, sizeof(cpid_hi));
      8a:	4611                	li	a2,4
      8c:	ef440593          	addi	a1,s0,-268
      90:	f0042503          	lw	a0,-256(s0)
      94:	2cd000ef          	jal	b60 <read>
    close(pipe_lo[0]); close(pipe_hi[0]);
      98:	ef842503          	lw	a0,-264(s0)
      9c:	2d5000ef          	jal	b70 <close>
      a0:	f0042503          	lw	a0,-256(s0)
      a4:	2cd000ef          	jal	b70 <close>
    printf("LO-priority child PID: %d\n", cpid_lo);
      a8:	ef042583          	lw	a1,-272(s0)
      ac:	00001517          	auipc	a0,0x1
      b0:	27c50513          	addi	a0,a0,636 # 1328 <malloc+0x292>
      b4:	72b000ef          	jal	fde <printf>
    printf("HI-priority child PID: %d\n", cpid_hi);
      b8:	ef442583          	lw	a1,-268(s0)
      bc:	00001517          	auipc	a0,0x1
      c0:	28c50513          	addi	a0,a0,652 # 1348 <malloc+0x2b2>
      c4:	71b000ef          	jal	fde <printf>
    char *pressure = sbrklazy((uint64)pressure_pages * PAGE_SIZE_5);
      c8:	6551                	lui	a0,0x14
      ca:	261000ef          	jal	b2a <sbrklazy>
    for (int i = 0; i < pressure_pages; i++)
      ce:	4781                	li	a5,0
      d0:	05000713          	li	a4,80
        pressure[i * PAGE_SIZE_5] = (char)i;
      d4:	00f50023          	sb	a5,0(a0) # 14000 <base+0x11ff0>
    for (int i = 0; i < pressure_pages; i++)
      d8:	2785                	addiw	a5,a5,1
      da:	40050513          	addi	a0,a0,1024
      de:	fee79be3          	bne	a5,a4,d4 <main+0xd4>
    pause(5);
      e2:	4515                	li	a0,5
      e4:	2f5000ef          	jal	bd8 <pause>
    if (getvmstats(cpid_lo, &st_lo) != 0) {
      e8:	f1840593          	addi	a1,s0,-232
      ec:	ef042503          	lw	a0,-272(s0)
      f0:	339000ef          	jal	c28 <getvmstats>
      f4:	38050163          	beqz	a0,476 <main+0x476>
        printf("FAIL: getvmstats for lo-child %d failed\n", cpid_lo);
      f8:	ef042583          	lw	a1,-272(s0)
      fc:	00001517          	auipc	a0,0x1
     100:	26c50513          	addi	a0,a0,620 # 1368 <malloc+0x2d2>
     104:	6db000ef          	jal	fde <printf>
    if (getvmstats(cpid_hi, &st_hi) != 0) {
     108:	f4840593          	addi	a1,s0,-184
     10c:	ef442503          	lw	a0,-268(s0)
     110:	319000ef          	jal	c28 <getvmstats>
     114:	3a050263          	beqz	a0,4b8 <main+0x4b8>
        printf("FAIL: getvmstats for hi-child %d failed\n", cpid_hi);
     118:	ef442583          	lw	a1,-268(s0)
     11c:	00001517          	auipc	a0,0x1
     120:	2e450513          	addi	a0,a0,740 # 1400 <malloc+0x36a>
     124:	6bb000ef          	jal	fde <printf>
    if (st_lo.pages_evicted >= st_hi.pages_evicted)
     128:	f1c42703          	lw	a4,-228(s0)
     12c:	f4c42783          	lw	a5,-180(s0)
     130:	3cf74563          	blt	a4,a5,4fa <main+0x4fa>
        printf("\nPASS: LO-priority process lost >= pages than HI-priority\n");
     134:	00001517          	auipc	a0,0x1
     138:	31450513          	addi	a0,a0,788 # 1448 <malloc+0x3b2>
     13c:	6a3000ef          	jal	fde <printf>
    wait(0); wait(0);
     140:	4501                	li	a0,0
     142:	20f000ef          	jal	b50 <wait>
     146:	4501                	li	a0,0
     148:	209000ef          	jal	b50 <wait>
    printf("=== test_sched_aware done ===\n");
     14c:	00001517          	auipc	a0,0x1
     150:	39450513          	addi	a0,a0,916 # 14e0 <malloc+0x44a>
     154:	68b000ef          	jal	fde <printf>
  test_pa4_5();

  printf("\n--- PA4_9: multi-process memory pressure ---\n");
     158:	00001517          	auipc	a0,0x1
     15c:	3a850513          	addi	a0,a0,936 # 1500 <malloc+0x46a>
     160:	67f000ef          	jal	fde <printf>
    printf("=== vmswap5: Multi-Process Memory Pressure ===\n");
     164:	00001517          	auipc	a0,0x1
     168:	3cc50513          	addi	a0,a0,972 # 1530 <malloc+0x49a>
     16c:	673000ef          	jal	fde <printf>
    for (int i = 0; i < NCHILDREN_9; i++) {
     170:	4901                	li	s2,0
     172:	498d                	li	s3,3
        pids[i] = fork();
     174:	1cd000ef          	jal	b40 <fork>
     178:	84aa                	mv	s1,a0
        if (pids[i] < 0) {
     17a:	38054763          	bltz	a0,508 <main+0x508>
        if (pids[i] == 0) {
     17e:	3a050563          	beqz	a0,528 <main+0x528>
    for (int i = 0; i < NCHILDREN_9; i++) {
     182:	2905                	addiw	s2,s2,1
     184:	ff3918e3          	bne	s2,s3,174 <main+0x174>
     188:	f1d2                	sd	s4,224(sp)
     18a:	edd6                	sd	s5,216(sp)
     18c:	e9da                	sd	s6,208(sp)
     18e:	e5de                	sd	s7,200(sp)
     190:	e1e2                	sd	s8,192(sp)
     192:	fd66                	sd	s9,184(sp)
    int all_ok = 1;
     194:	4a85                	li	s5,1
    for (int i = 0; i < NCHILDREN_9; i++) {
     196:	4481                	li	s1,0
        int status = -1;
     198:	5a7d                	li	s4,-1
        wait(&status);
     19a:	f4840993          	addi	s3,s0,-184
    for (int i = 0; i < NCHILDREN_9; i++) {
     19e:	490d                	li	s2,3
        int status = -1;
     1a0:	f5442423          	sw	s4,-184(s0)
        wait(&status);
     1a4:	854e                	mv	a0,s3
     1a6:	1ab000ef          	jal	b50 <wait>
        if (status != 0) {
     1aa:	f4842603          	lw	a2,-184(s0)
     1ae:	46061763          	bnez	a2,61c <main+0x61c>
    for (int i = 0; i < NCHILDREN_9; i++) {
     1b2:	2485                	addiw	s1,s1,1
     1b4:	ff2496e3          	bne	s1,s2,1a0 <main+0x1a0>
    if (all_ok)
     1b8:	460a8b63          	beqz	s5,62e <main+0x62e>
        printf("PASS: all %d children survived memory pressure with correct data\n",
     1bc:	458d                	li	a1,3
     1be:	00001517          	auipc	a0,0x1
     1c2:	4f250513          	addi	a0,a0,1266 # 16b0 <malloc+0x61a>
     1c6:	619000ef          	jal	fde <printf>
    if (getvmstats(getpid(), &ps) == 0) {
     1ca:	1ff000ef          	jal	bc8 <getpid>
     1ce:	f4840593          	addi	a1,s0,-184
     1d2:	257000ef          	jal	c28 <getvmstats>
     1d6:	46050363          	beqz	a0,63c <main+0x63c>
    printf("=== vmswap5 done ===\n");
     1da:	00001517          	auipc	a0,0x1
     1de:	5ae50513          	addi	a0,a0,1454 # 1788 <malloc+0x6f2>
     1e2:	5fd000ef          	jal	fde <printf>
  test_pa4_9();

  printf("\n--- PA4_10: PTE isolation across children ---\n");
     1e6:	00001517          	auipc	a0,0x1
     1ea:	5ba50513          	addi	a0,a0,1466 # 17a0 <malloc+0x70a>
     1ee:	5f1000ef          	jal	fde <printf>
    printf("=== Test 7: PTE update isolation across %d children ===\n", N_CHILDREN_10);
     1f2:	458d                	li	a1,3
     1f4:	00001517          	auipc	a0,0x1
     1f8:	5dc50513          	addi	a0,a0,1500 # 17d0 <malloc+0x73a>
     1fc:	5e3000ef          	jal	fde <printf>
    printf("    PAGES_EACH=%d  MAXFRAMES=%d\n", PAGES_EACH, MAXFRAMES_10);
     200:	04000613          	li	a2,64
     204:	45f9                	li	a1,30
     206:	00001517          	auipc	a0,0x1
     20a:	60a50513          	addi	a0,a0,1546 # 1810 <malloc+0x77a>
     20e:	5d1000ef          	jal	fde <printf>
        pipe(pipes[i]);
     212:	f0040513          	addi	a0,s0,-256
     216:	143000ef          	jal	b58 <pipe>
     21a:	f0840513          	addi	a0,s0,-248
     21e:	13b000ef          	jal	b58 <pipe>
     222:	f1040513          	addi	a0,s0,-240
     226:	133000ef          	jal	b58 <pipe>
    for (int c = 0; c < N_CHILDREN_10; c++)
     22a:	4901                	li	s2,0
     22c:	498d                	li	s3,3
        int pid = fork();
     22e:	113000ef          	jal	b40 <fork>
     232:	84aa                	mv	s1,a0
        if (pid == 0)
     234:	42050563          	beqz	a0,65e <main+0x65e>
    for (int c = 0; c < N_CHILDREN_10; c++)
     238:	2905                	addiw	s2,s2,1
     23a:	ff391ae3          	bne	s2,s3,22e <main+0x22e>
     23e:	f0040493          	addi	s1,s0,-256
     242:	f4840913          	addi	s2,s0,-184
     246:	f1840a93          	addi	s5,s0,-232
     24a:	89ca                	mv	s3,s2
        read(pipes[c][0], &reports[c], sizeof(ChildReport_10));
     24c:	4a71                	li	s4,28
        close(pipes[c][1]);
     24e:	40c8                	lw	a0,4(s1)
     250:	121000ef          	jal	b70 <close>
        read(pipes[c][0], &reports[c], sizeof(ChildReport_10));
     254:	8652                	mv	a2,s4
     256:	85ce                	mv	a1,s3
     258:	4088                	lw	a0,0(s1)
     25a:	107000ef          	jal	b60 <read>
        close(pipes[c][0]);
     25e:	4088                	lw	a0,0(s1)
     260:	111000ef          	jal	b70 <close>
    for (int c = 0; c < N_CHILDREN_10; c++)
     264:	04a1                	addi	s1,s1,8
     266:	09f1                	addi	s3,s3,28
     268:	ff5493e3          	bne	s1,s5,24e <main+0x24e>
        wait(0);
     26c:	4501                	li	a0,0
     26e:	0e3000ef          	jal	b50 <wait>
     272:	4501                	li	a0,0
     274:	0dd000ef          	jal	b50 <wait>
     278:	4501                	li	a0,0
     27a:	0d7000ef          	jal	b50 <wait>
    printf("\n[results]\n");
     27e:	00001517          	auipc	a0,0x1
     282:	66a50513          	addi	a0,a0,1642 # 18e8 <malloc+0x852>
     286:	559000ef          	jal	fde <printf>
     28a:	84ca                	mv	s1,s2
    int all_ok = 1;
     28c:	4a05                	li	s4,1
    for (int c = 0; c < N_CHILDREN_10; c++)
     28e:	4981                	li	s3,0
        printf("  child %d (pid=%d): faults=%d evicted=%d sout=%d sin=%d ",
     290:	00001b97          	auipc	s7,0x1
     294:	668b8b93          	addi	s7,s7,1640 # 18f8 <malloc+0x862>
        printf("res=%d errors=%d\n",
     298:	00001b17          	auipc	s6,0x1
     29c:	6a0b0b13          	addi	s6,s6,1696 # 1938 <malloc+0x8a2>
    for (int c = 0; c < N_CHILDREN_10; c++)
     2a0:	4a8d                	li	s5,3
        printf("  child %d (pid=%d): faults=%d evicted=%d sout=%d sin=%d ",
     2a2:	0104a803          	lw	a6,16(s1)
     2a6:	44dc                	lw	a5,12(s1)
     2a8:	4498                	lw	a4,8(s1)
     2aa:	40d4                	lw	a3,4(s1)
     2ac:	4090                	lw	a2,0(s1)
     2ae:	85ce                	mv	a1,s3
     2b0:	855e                	mv	a0,s7
     2b2:	52d000ef          	jal	fde <printf>
        printf("res=%d errors=%d\n",
     2b6:	4c90                	lw	a2,24(s1)
     2b8:	48cc                	lw	a1,20(s1)
     2ba:	855a                	mv	a0,s6
     2bc:	523000ef          	jal	fde <printf>
        if (r->errors != 0)
     2c0:	4c9c                	lw	a5,24(s1)
     2c2:	0017b793          	seqz	a5,a5
     2c6:	00fa7a33          	and	s4,s4,a5
    for (int c = 0; c < N_CHILDREN_10; c++)
     2ca:	2985                	addiw	s3,s3,1
     2cc:	04f1                	addi	s1,s1,28
     2ce:	fd599ae3          	bne	s3,s5,2a2 <main+0x2a2>
     2d2:	89ca                	mv	s3,s2
    for (int c = 0; c < N_CHILDREN_10; c++)
     2d4:	4481                	li	s1,0
        if (reports[c].page_faults < PAGES_EACH)
     2d6:	4bf5                	li	s7,29
            printf("  PASS: child %d faults=%d >= %d\n",
     2d8:	4b79                	li	s6,30
     2da:	00001c97          	auipc	s9,0x1
     2de:	6a6c8c93          	addi	s9,s9,1702 # 1980 <malloc+0x8ea>
            printf("  FAIL: child %d faults=%d < expected %d\n",
     2e2:	00001c17          	auipc	s8,0x1
     2e6:	66ec0c13          	addi	s8,s8,1646 # 1950 <malloc+0x8ba>
    for (int c = 0; c < N_CHILDREN_10; c++)
     2ea:	4a8d                	li	s5,3
     2ec:	ab01                	j	7fc <main+0x7fc>
     2ee:	fda6                	sd	s1,248(sp)
     2f0:	f9ca                	sd	s2,240(sp)
     2f2:	f5ce                	sd	s3,232(sp)
     2f4:	f1d2                	sd	s4,224(sp)
     2f6:	edd6                	sd	s5,216(sp)
     2f8:	e9da                	sd	s6,208(sp)
     2fa:	e5de                	sd	s7,200(sp)
     2fc:	e1e2                	sd	s8,192(sp)
     2fe:	fd66                	sd	s9,184(sp)
     300:	84aa                	mv	s1,a0
        close(pipe_lo[0]);
     302:	ef842503          	lw	a0,-264(s0)
     306:	06b000ef          	jal	b70 <close>
        close(pipe_hi[0]); close(pipe_hi[1]);
     30a:	f0042503          	lw	a0,-256(s0)
     30e:	063000ef          	jal	b70 <close>
     312:	f0442503          	lw	a0,-252(s0)
     316:	05b000ef          	jal	b70 <close>
        volatile int x = 0;
     31a:	f0042c23          	sw	zero,-232(s0)
     31e:	2faf17b7          	lui	a5,0x2faf1
     322:	80078793          	addi	a5,a5,-2048 # 2faf0800 <base+0x2faee7f0>
        for (int i = 0; i < SPIN_ITERS; i++) x++;
     326:	f1842703          	lw	a4,-232(s0)
     32a:	2705                	addiw	a4,a4,1
     32c:	f0e42c23          	sw	a4,-232(s0)
     330:	37fd                	addiw	a5,a5,-1
     332:	fbf5                	bnez	a5,326 <main+0x326>
        char *mem = sbrklazy((uint64)WORK_PAGES * PAGE_SIZE_5);
     334:	6529                	lui	a0,0xa
     336:	7f4000ef          	jal	b2a <sbrklazy>
     33a:	892a                	mv	s2,a0
     33c:	4781                	li	a5,0
        for (int i = 0; i < WORK_PAGES; i++)
     33e:	02800693          	li	a3,40
            mem[i * PAGE_SIZE_5] = (char)i;
     342:	00a79713          	slli	a4,a5,0xa
     346:	974a                	add	a4,a4,s2
     348:	00f70023          	sb	a5,0(a4)
        for (int i = 0; i < WORK_PAGES; i++)
     34c:	0785                	addi	a5,a5,1
     34e:	fed79ae3          	bne	a5,a3,342 <main+0x342>
        int mypid = getpid();
     352:	077000ef          	jal	bc8 <getpid>
     356:	f4a42423          	sw	a0,-184(s0)
        write(pipe_lo[1], &mypid, sizeof(mypid));
     35a:	4611                	li	a2,4
     35c:	f4840593          	addi	a1,s0,-184
     360:	efc42503          	lw	a0,-260(s0)
     364:	005000ef          	jal	b68 <write>
        close(pipe_lo[1]);
     368:	efc42503          	lw	a0,-260(s0)
     36c:	005000ef          	jal	b70 <close>
        pause(20);
     370:	4551                	li	a0,20
     372:	067000ef          	jal	bd8 <pause>
     376:	4781                	li	a5,0
        for (int i = 0; i < WORK_PAGES; i++)
     378:	02800693          	li	a3,40
     37c:	a021                	j	384 <main+0x384>
     37e:	0785                	addi	a5,a5,1
     380:	00d78d63          	beq	a5,a3,39a <main+0x39a>
            if (mem[i * PAGE_SIZE_5] != (char)i) errs++;
     384:	00a79713          	slli	a4,a5,0xa
     388:	974a                	add	a4,a4,s2
     38a:	00074603          	lbu	a2,0(a4)
     38e:	0ff7f713          	zext.b	a4,a5
     392:	fee606e3          	beq	a2,a4,37e <main+0x37e>
     396:	2485                	addiw	s1,s1,1
     398:	b7dd                	j	37e <main+0x37e>
        if (errs == 0)
     39a:	e891                	bnez	s1,3ae <main+0x3ae>
            printf("[LO-child] PASS: data intact after pressure\n");
     39c:	00001517          	auipc	a0,0x1
     3a0:	edc50513          	addi	a0,a0,-292 # 1278 <malloc+0x1e2>
     3a4:	43b000ef          	jal	fde <printf>
        exit(0);
     3a8:	4501                	li	a0,0
     3aa:	79e000ef          	jal	b48 <exit>
            printf("[LO-child] WARN: %d pages corrupted\n", errs);
     3ae:	85a6                	mv	a1,s1
     3b0:	00001517          	auipc	a0,0x1
     3b4:	ef850513          	addi	a0,a0,-264 # 12a8 <malloc+0x212>
     3b8:	427000ef          	jal	fde <printf>
     3bc:	b7f5                	j	3a8 <main+0x3a8>
     3be:	f9ca                	sd	s2,240(sp)
     3c0:	f5ce                	sd	s3,232(sp)
     3c2:	f1d2                	sd	s4,224(sp)
     3c4:	edd6                	sd	s5,216(sp)
     3c6:	e9da                	sd	s6,208(sp)
     3c8:	e5de                	sd	s7,200(sp)
     3ca:	e1e2                	sd	s8,192(sp)
     3cc:	fd66                	sd	s9,184(sp)
        close(pipe_hi[0]);
     3ce:	f0042503          	lw	a0,-256(s0)
     3d2:	79e000ef          	jal	b70 <close>
        close(pipe_lo[0]); close(pipe_lo[1]);
     3d6:	ef842503          	lw	a0,-264(s0)
     3da:	796000ef          	jal	b70 <close>
     3de:	efc42503          	lw	a0,-260(s0)
     3e2:	78e000ef          	jal	b70 <close>
        char *mem = sbrklazy((uint64)WORK_PAGES * PAGE_SIZE_5);
     3e6:	6529                	lui	a0,0xa
     3e8:	742000ef          	jal	b2a <sbrklazy>
     3ec:	892a                	mv	s2,a0
     3ee:	872a                	mv	a4,a0
     3f0:	06400793          	li	a5,100
        for (int i = 0; i < WORK_PAGES; i++)
     3f4:	08c00693          	li	a3,140
            mem[i * PAGE_SIZE_5] = (char)(i + 100);
     3f8:	00f70023          	sb	a5,0(a4)
        for (int i = 0; i < WORK_PAGES; i++)
     3fc:	2785                	addiw	a5,a5,1
     3fe:	0ff7f793          	zext.b	a5,a5
     402:	40070713          	addi	a4,a4,1024
     406:	fed799e3          	bne	a5,a3,3f8 <main+0x3f8>
        int mypid = getpid();
     40a:	7be000ef          	jal	bc8 <getpid>
     40e:	f4a42423          	sw	a0,-184(s0)
        write(pipe_hi[1], &mypid, sizeof(mypid));
     412:	4611                	li	a2,4
     414:	f4840593          	addi	a1,s0,-184
     418:	f0442503          	lw	a0,-252(s0)
     41c:	74c000ef          	jal	b68 <write>
        close(pipe_hi[1]);
     420:	f0442503          	lw	a0,-252(s0)
     424:	74c000ef          	jal	b70 <close>
        pause(20);
     428:	4551                	li	a0,20
     42a:	7ae000ef          	jal	bd8 <pause>
     42e:	06400793          	li	a5,100
        for (int i = 0; i < WORK_PAGES; i++)
     432:	08c00713          	li	a4,140
     436:	a809                	j	448 <main+0x448>
            if (mem[i * PAGE_SIZE_5] != (char)(i + 100)) errs++;
     438:	2485                	addiw	s1,s1,1
        for (int i = 0; i < WORK_PAGES; i++)
     43a:	40090913          	addi	s2,s2,1024
     43e:	2785                	addiw	a5,a5,1
     440:	0ff7f793          	zext.b	a5,a5
     444:	00e78763          	beq	a5,a4,452 <main+0x452>
            if (mem[i * PAGE_SIZE_5] != (char)(i + 100)) errs++;
     448:	00094683          	lbu	a3,0(s2)
     44c:	fef696e3          	bne	a3,a5,438 <main+0x438>
     450:	b7ed                	j	43a <main+0x43a>
        if (errs == 0)
     452:	e891                	bnez	s1,466 <main+0x466>
            printf("[HI-child] PASS: data intact after pressure\n");
     454:	00001517          	auipc	a0,0x1
     458:	e7c50513          	addi	a0,a0,-388 # 12d0 <malloc+0x23a>
     45c:	383000ef          	jal	fde <printf>
        exit(0);
     460:	4501                	li	a0,0
     462:	6e6000ef          	jal	b48 <exit>
            printf("[HI-child] WARN: %d pages corrupted\n", errs);
     466:	85a6                	mv	a1,s1
     468:	00001517          	auipc	a0,0x1
     46c:	e9850513          	addi	a0,a0,-360 # 1300 <malloc+0x26a>
     470:	36f000ef          	jal	fde <printf>
     474:	b7f5                	j	460 <main+0x460>
        printf("\n[LO-priority child %d]\n", cpid_lo);
     476:	ef042583          	lw	a1,-272(s0)
     47a:	00001517          	auipc	a0,0x1
     47e:	f1e50513          	addi	a0,a0,-226 # 1398 <malloc+0x302>
     482:	35d000ef          	jal	fde <printf>
        printf("  pages_evicted   : %d\n", st_lo.pages_evicted);
     486:	f1c42583          	lw	a1,-228(s0)
     48a:	00001517          	auipc	a0,0x1
     48e:	f2e50513          	addi	a0,a0,-210 # 13b8 <malloc+0x322>
     492:	34d000ef          	jal	fde <printf>
        printf("  pages_swapped_out:%d\n", st_lo.pages_swapped_out);
     496:	f2442583          	lw	a1,-220(s0)
     49a:	00001517          	auipc	a0,0x1
     49e:	f3650513          	addi	a0,a0,-202 # 13d0 <malloc+0x33a>
     4a2:	33d000ef          	jal	fde <printf>
        printf("  resident_pages  : %d\n", st_lo.resident_pages);
     4a6:	f2842583          	lw	a1,-216(s0)
     4aa:	00001517          	auipc	a0,0x1
     4ae:	f3e50513          	addi	a0,a0,-194 # 13e8 <malloc+0x352>
     4b2:	32d000ef          	jal	fde <printf>
     4b6:	b989                	j	108 <main+0x108>
        printf("[HI-priority child %d]\n", cpid_hi);
     4b8:	ef442583          	lw	a1,-268(s0)
     4bc:	00001517          	auipc	a0,0x1
     4c0:	f7450513          	addi	a0,a0,-140 # 1430 <malloc+0x39a>
     4c4:	31b000ef          	jal	fde <printf>
        printf("  pages_evicted   : %d\n", st_hi.pages_evicted);
     4c8:	f4c42583          	lw	a1,-180(s0)
     4cc:	00001517          	auipc	a0,0x1
     4d0:	eec50513          	addi	a0,a0,-276 # 13b8 <malloc+0x322>
     4d4:	30b000ef          	jal	fde <printf>
        printf("  pages_swapped_out:%d\n", st_hi.pages_swapped_out);
     4d8:	f5442583          	lw	a1,-172(s0)
     4dc:	00001517          	auipc	a0,0x1
     4e0:	ef450513          	addi	a0,a0,-268 # 13d0 <malloc+0x33a>
     4e4:	2fb000ef          	jal	fde <printf>
        printf("  resident_pages  : %d\n", st_hi.resident_pages);
     4e8:	f5842583          	lw	a1,-168(s0)
     4ec:	00001517          	auipc	a0,0x1
     4f0:	efc50513          	addi	a0,a0,-260 # 13e8 <malloc+0x352>
     4f4:	2eb000ef          	jal	fde <printf>
     4f8:	b905                	j	128 <main+0x128>
        printf("\nFAIL: HI-priority process lost more pages than LO — check scheduler-aware eviction\n");
     4fa:	00001517          	auipc	a0,0x1
     4fe:	f8e50513          	addi	a0,a0,-114 # 1488 <malloc+0x3f2>
     502:	2dd000ef          	jal	fde <printf>
     506:	b92d                	j	140 <main+0x140>
     508:	f1d2                	sd	s4,224(sp)
     50a:	edd6                	sd	s5,216(sp)
     50c:	e9da                	sd	s6,208(sp)
     50e:	e5de                	sd	s7,200(sp)
     510:	e1e2                	sd	s8,192(sp)
     512:	fd66                	sd	s9,184(sp)
            printf("FAIL: fork %d failed\n", i);
     514:	85ca                	mv	a1,s2
     516:	00001517          	auipc	a0,0x1
     51a:	04a50513          	addi	a0,a0,74 # 1560 <malloc+0x4ca>
     51e:	2c1000ef          	jal	fde <printf>
            exit(1);
     522:	4505                	li	a0,1
     524:	624000ef          	jal	b48 <exit>
     528:	f1d2                	sd	s4,224(sp)
     52a:	edd6                	sd	s5,216(sp)
     52c:	e9da                	sd	s6,208(sp)
     52e:	e5de                	sd	s7,200(sp)
     530:	e1e2                	sd	s8,192(sp)
     532:	fd66                	sd	s9,184(sp)
    char *mem = sbrklazy(NPAGES_9 * PGSIZE_9);
     534:	6541                	lui	a0,0x10
     536:	5f4000ef          	jal	b2a <sbrklazy>
     53a:	8b2a                	mv	s6,a0
    if (mem == (char *)-1) {
     53c:	57fd                	li	a5,-1
     53e:	02f50f63          	beq	a0,a5,57c <main+0x57c>
        mem[i * PGSIZE_9] = PATTERN_9(id, i);
     542:	02500993          	li	s3,37
     546:	032989bb          	mulw	s3,s3,s2
     54a:	2985                	addiw	s3,s3,1
     54c:	0ff9f993          	zext.b	s3,s3
     550:	872a                	mv	a4,a0
     552:	66c1                	lui	a3,0x10
     554:	96aa                	add	a3,a3,a0
     556:	87ce                	mv	a5,s3
     558:	00f70023          	sb	a5,0(a4)
    for (int i = 0; i < NPAGES_9; i++) {
     55c:	27ad                	addiw	a5,a5,11
     55e:	0ff7f793          	zext.b	a5,a5
     562:	40070713          	addi	a4,a4,1024
     566:	fed719e3          	bne	a4,a3,558 <main+0x558>
     56a:	4a81                	li	s5,0
    int ok = 1;
     56c:	4a05                	li	s4,1
            printf("FAIL: child %d page %d: expected 0x%x got 0x%x\n",
     56e:	00001c17          	auipc	s8,0x1
     572:	02ac0c13          	addi	s8,s8,42 # 1598 <malloc+0x502>
    for (int i = 0; i < NPAGES_9; i++) {
     576:	04000b93          	li	s7,64
     57a:	a005                	j	59a <main+0x59a>
        printf("FAIL: child %d sbrk failed\n", id);
     57c:	85ca                	mv	a1,s2
     57e:	00001517          	auipc	a0,0x1
     582:	ffa50513          	addi	a0,a0,-6 # 1578 <malloc+0x4e2>
     586:	259000ef          	jal	fde <printf>
        return 1;
     58a:	4505                	li	a0,1
     58c:	a8a1                	j	5e4 <main+0x5e4>
    for (int i = 0; i < NPAGES_9; i++) {
     58e:	0a85                	addi	s5,s5,1
     590:	29ad                	addiw	s3,s3,11
     592:	0ff9f993          	zext.b	s3,s3
     596:	037a8263          	beq	s5,s7,5ba <main+0x5ba>
        char got = mem[i * PGSIZE_9];
     59a:	00aa9793          	slli	a5,s5,0xa
     59e:	97da                	add	a5,a5,s6
     5a0:	0007c703          	lbu	a4,0(a5)
        if (got != PATTERN_9(id, i)) {
     5a4:	ff3705e3          	beq	a4,s3,58e <main+0x58e>
            printf("FAIL: child %d page %d: expected 0x%x got 0x%x\n",
     5a8:	86ce                	mv	a3,s3
     5aa:	000a861b          	sext.w	a2,s5
     5ae:	85ca                	mv	a1,s2
     5b0:	8562                	mv	a0,s8
     5b2:	22d000ef          	jal	fde <printf>
            ok = 0;
     5b6:	8a26                	mv	s4,s1
     5b8:	bfd9                	j	58e <main+0x58e>
    if (ok)
     5ba:	020a0763          	beqz	s4,5e8 <main+0x5e8>
        printf("PASS: child %d all %d pages correct under pressure\n",
     5be:	04000613          	li	a2,64
     5c2:	85ca                	mv	a1,s2
     5c4:	00001517          	auipc	a0,0x1
     5c8:	00450513          	addi	a0,a0,4 # 15c8 <malloc+0x532>
     5cc:	213000ef          	jal	fde <printf>
    if (getvmstats(getpid(), &s) == 0) {
     5d0:	5f8000ef          	jal	bc8 <getpid>
     5d4:	f4840593          	addi	a1,s0,-184
     5d8:	650000ef          	jal	c28 <getvmstats>
     5dc:	cd11                	beqz	a0,5f8 <main+0x5f8>
    return ok ? 0 : 1;
     5de:	001a4513          	xori	a0,s4,1
     5e2:	2501                	sext.w	a0,a0
            exit(child_work_9(i));
     5e4:	564000ef          	jal	b48 <exit>
        printf("FAIL: child %d data corrupted under pressure\n", id);
     5e8:	85ca                	mv	a1,s2
     5ea:	00001517          	auipc	a0,0x1
     5ee:	01650513          	addi	a0,a0,22 # 1600 <malloc+0x56a>
     5f2:	1ed000ef          	jal	fde <printf>
     5f6:	bfe9                	j	5d0 <main+0x5d0>
        printf("INFO: child %d -- faults=%d evicted=%d swapped_out=%d swapped_in=%d resident=%d\n",
     5f8:	f5842803          	lw	a6,-168(s0)
     5fc:	f5042783          	lw	a5,-176(s0)
     600:	f5442703          	lw	a4,-172(s0)
     604:	f4c42683          	lw	a3,-180(s0)
     608:	f4842603          	lw	a2,-184(s0)
     60c:	85ca                	mv	a1,s2
     60e:	00001517          	auipc	a0,0x1
     612:	02250513          	addi	a0,a0,34 # 1630 <malloc+0x59a>
     616:	1c9000ef          	jal	fde <printf>
     61a:	b7d1                	j	5de <main+0x5de>
            printf("FAIL: child %d exited with status %d\n", i, status);
     61c:	85a6                	mv	a1,s1
     61e:	00001517          	auipc	a0,0x1
     622:	06a50513          	addi	a0,a0,106 # 1688 <malloc+0x5f2>
     626:	1b9000ef          	jal	fde <printf>
            all_ok = 0;
     62a:	4a81                	li	s5,0
     62c:	b659                	j	1b2 <main+0x1b2>
        printf("FAIL: one or more children reported corruption under pressure\n");
     62e:	00001517          	auipc	a0,0x1
     632:	0ca50513          	addi	a0,a0,202 # 16f8 <malloc+0x662>
     636:	1a9000ef          	jal	fde <printf>
     63a:	be41                	j	1ca <main+0x1ca>
        printf("INFO: parent -- faults=%d evicted=%d swapped_out=%d swapped_in=%d resident=%d\n",
     63c:	f5842783          	lw	a5,-168(s0)
     640:	f5042703          	lw	a4,-176(s0)
     644:	f5442683          	lw	a3,-172(s0)
     648:	f4c42603          	lw	a2,-180(s0)
     64c:	f4842583          	lw	a1,-184(s0)
     650:	00001517          	auipc	a0,0x1
     654:	0e850513          	addi	a0,a0,232 # 1738 <malloc+0x6a2>
     658:	187000ef          	jal	fde <printf>
     65c:	bebd                	j	1da <main+0x1da>
     65e:	f0040993          	addi	s3,s0,-256
            for (int i = 0; i < N_CHILDREN_10; i++)
     662:	4a0d                	li	s4,3
     664:	a809                	j	676 <main+0x676>
                    close(pipes[i][1]);
     666:	0049a503          	lw	a0,4(s3)
     66a:	506000ef          	jal	b70 <close>
            for (int i = 0; i < N_CHILDREN_10; i++)
     66e:	2485                	addiw	s1,s1,1
     670:	09a1                	addi	s3,s3,8
     672:	01448963          	beq	s1,s4,684 <main+0x684>
                close(pipes[i][0]);
     676:	0009a503          	lw	a0,0(s3)
     67a:	4f6000ef          	jal	b70 <close>
                if (i != c)
     67e:	ff2494e3          	bne	s1,s2,666 <main+0x666>
     682:	b7f5                	j	66e <main+0x66e>
            rep.pid = getpid();
     684:	544000ef          	jal	bc8 <getpid>
     688:	f0a42c23          	sw	a0,-232(s0)
            rep.errors = 0;
     68c:	f2042823          	sw	zero,-208(s0)
            rep.page_faults = 0;
     690:	f0042e23          	sw	zero,-228(s0)
            rep.pages_evicted = 0;
     694:	f2042023          	sw	zero,-224(s0)
            rep.pages_swapped_out = 0;
     698:	f2042223          	sw	zero,-220(s0)
            rep.pages_swapped_in = 0;
     69c:	f2042423          	sw	zero,-216(s0)
            rep.resident_pages = 0;
     6a0:	f2042623          	sw	zero,-212(s0)
            s.page_faults = 0;
     6a4:	f4042423          	sw	zero,-184(s0)
            char *mem = sbrklazy((long)PAGES_EACH * PAGE_SIZE_10);
     6a8:	6521                	lui	a0,0x8
     6aa:	80050513          	addi	a0,a0,-2048 # 7800 <base+0x57f0>
     6ae:	47c000ef          	jal	b2a <sbrklazy>
     6b2:	89aa                	mv	s3,a0
            if (mem == (char *)-1)
     6b4:	57fd                	li	a5,-1
     6b6:	04f50d63          	beq	a0,a5,710 <main+0x710>
                mem[i * PAGE_SIZE_10] = (char)((c * 100 + i) & 0xFF);
     6ba:	06400793          	li	a5,100
     6be:	032787bb          	mulw	a5,a5,s2
     6c2:	0ff7f793          	zext.b	a5,a5
     6c6:	85aa                	mv	a1,a0
     6c8:	66a1                	lui	a3,0x8
     6ca:	80068693          	addi	a3,a3,-2048 # 7800 <base+0x57f0>
     6ce:	96aa                	add	a3,a3,a0
     6d0:	862a                	mv	a2,a0
     6d2:	873e                	mv	a4,a5
     6d4:	00e60023          	sb	a4,0(a2)
            for (int i = 0; i < PAGES_EACH; i++)
     6d8:	2705                	addiw	a4,a4,1
     6da:	0ff77713          	zext.b	a4,a4
     6de:	40060613          	addi	a2,a2,1024
     6e2:	fed619e3          	bne	a2,a3,6d4 <main+0x6d4>
     6e6:	4705                	li	a4,1
            for (int i = 0; i < PAGES_EACH; i++)
     6e8:	46fd                	li	a3,31
                mem[i * PAGE_SIZE_10] = (char)((c * 100 + i + 1) & 0xFF);
     6ea:	00f7063b          	addw	a2,a4,a5
     6ee:	00c58023          	sb	a2,0(a1)
            for (int i = 0; i < PAGES_EACH; i++)
     6f2:	0705                	addi	a4,a4,1
     6f4:	40058593          	addi	a1,a1,1024
     6f8:	fed719e3          	bne	a4,a3,6ea <main+0x6ea>
     6fc:	2785                	addiw	a5,a5,1
     6fe:	0ff7f493          	zext.b	s1,a5
     702:	4a01                	li	s4,0
                    printf("  child %d ERROR: mem[%d*PAGE_SIZE] = %d != expected %d\n",
     704:	00001b17          	auipc	s6,0x1
     708:	134b0b13          	addi	s6,s6,308 # 1838 <malloc+0x7a2>
            for (int i = 0; i < PAGES_EACH; i++)
     70c:	4af9                	li	s5,30
     70e:	a821                	j	726 <main+0x726>
                rep.errors = 99;
     710:	06300793          	li	a5,99
     714:	f2f42823          	sw	a5,-208(s0)
                goto done_10;
     718:	a8a1                	j	770 <main+0x770>
            for (int i = 0; i < PAGES_EACH; i++)
     71a:	0a05                	addi	s4,s4,1
     71c:	2485                	addiw	s1,s1,1
     71e:	0ff4f493          	zext.b	s1,s1
     722:	035a0663          	beq	s4,s5,74e <main+0x74e>
                if (mem[i * PAGE_SIZE_10] != exp)
     726:	00aa1793          	slli	a5,s4,0xa
     72a:	97ce                	add	a5,a5,s3
     72c:	0007c683          	lbu	a3,0(a5)
     730:	fe9685e3          	beq	a3,s1,71a <main+0x71a>
                    printf("  child %d ERROR: mem[%d*PAGE_SIZE] = %d != expected %d\n",
     734:	8726                	mv	a4,s1
     736:	000a061b          	sext.w	a2,s4
     73a:	85ca                	mv	a1,s2
     73c:	855a                	mv	a0,s6
     73e:	0a1000ef          	jal	fde <printf>
                    rep.errors++;
     742:	f3042783          	lw	a5,-208(s0)
     746:	2785                	addiw	a5,a5,1
     748:	f2f42823          	sw	a5,-208(s0)
     74c:	b7f9                	j	71a <main+0x71a>
            if (getvmstats(rep.pid, &s) != 0)
     74e:	f4840593          	addi	a1,s0,-184
     752:	f1842503          	lw	a0,-232(s0)
     756:	4d2000ef          	jal	c28 <getvmstats>
     75a:	c929                	beqz	a0,7ac <main+0x7ac>
                rep.errors++;
     75c:	f3042783          	lw	a5,-208(s0)
     760:	2785                	addiw	a5,a5,1
     762:	f2f42823          	sw	a5,-208(s0)
            if (s.page_faults < PAGES_EACH)
     766:	f4842603          	lw	a2,-184(s0)
     76a:	47f5                	li	a5,29
     76c:	06c7d563          	bge	a5,a2,7d6 <main+0x7d6>
            printf("child %d writing rep: pid=%d faults=%d evicted=%d\n",
     770:	f2042703          	lw	a4,-224(s0)
     774:	f1c42683          	lw	a3,-228(s0)
     778:	f1842603          	lw	a2,-232(s0)
     77c:	85ca                	mv	a1,s2
     77e:	00001517          	auipc	a0,0x1
     782:	13250513          	addi	a0,a0,306 # 18b0 <malloc+0x81a>
     786:	059000ef          	jal	fde <printf>
            write(pipes[c][1], &rep, sizeof(rep));
     78a:	00391493          	slli	s1,s2,0x3
     78e:	f0440793          	addi	a5,s0,-252
     792:	94be                	add	s1,s1,a5
     794:	4671                	li	a2,28
     796:	f1840593          	addi	a1,s0,-232
     79a:	4088                	lw	a0,0(s1)
     79c:	3cc000ef          	jal	b68 <write>
            close(pipes[c][1]);
     7a0:	4088                	lw	a0,0(s1)
     7a2:	3ce000ef          	jal	b70 <close>
            exit(0);
     7a6:	4501                	li	a0,0
     7a8:	3a0000ef          	jal	b48 <exit>
                rep.page_faults = s.page_faults;
     7ac:	f4842783          	lw	a5,-184(s0)
     7b0:	f0f42e23          	sw	a5,-228(s0)
                rep.pages_evicted = s.pages_evicted;
     7b4:	f4c42783          	lw	a5,-180(s0)
     7b8:	f2f42023          	sw	a5,-224(s0)
                rep.pages_swapped_out = s.pages_swapped_out;
     7bc:	f5442783          	lw	a5,-172(s0)
     7c0:	f2f42223          	sw	a5,-220(s0)
                rep.pages_swapped_in = s.pages_swapped_in;
     7c4:	f5042783          	lw	a5,-176(s0)
     7c8:	f2f42423          	sw	a5,-216(s0)
                rep.resident_pages = s.resident_pages;
     7cc:	f5842783          	lw	a5,-168(s0)
     7d0:	f2f42623          	sw	a5,-212(s0)
     7d4:	bf49                	j	766 <main+0x766>
                printf("  child %d WARN: page_faults=%d < PAGES_EACH=%d\n",
     7d6:	46f9                	li	a3,30
     7d8:	85ca                	mv	a1,s2
     7da:	00001517          	auipc	a0,0x1
     7de:	09e50513          	addi	a0,a0,158 # 1878 <malloc+0x7e2>
     7e2:	7fc000ef          	jal	fde <printf>
     7e6:	b769                	j	770 <main+0x770>
            printf("  FAIL: child %d faults=%d < expected %d\n",
     7e8:	86da                	mv	a3,s6
     7ea:	85a6                	mv	a1,s1
     7ec:	8562                	mv	a0,s8
     7ee:	7f0000ef          	jal	fde <printf>
            all_ok = 0;
     7f2:	4a01                	li	s4,0
    for (int c = 0; c < N_CHILDREN_10; c++)
     7f4:	2485                	addiw	s1,s1,1
     7f6:	09f1                	addi	s3,s3,28
     7f8:	01548c63          	beq	s1,s5,810 <main+0x810>
        if (reports[c].page_faults < PAGES_EACH)
     7fc:	0049a603          	lw	a2,4(s3)
     800:	fecbd4e3          	bge	s7,a2,7e8 <main+0x7e8>
            printf("  PASS: child %d faults=%d >= %d\n",
     804:	86da                	mv	a3,s6
     806:	85a6                	mv	a1,s1
     808:	8566                	mv	a0,s9
     80a:	7d4000ef          	jal	fde <printf>
     80e:	b7dd                	j	7f4 <main+0x7f4>
     810:	02090913          	addi	s2,s2,32
    for (int a = 0; a < N_CHILDREN_10; a++)
     814:	4b81                	li	s7,0
        for (int b = a + 1; b < N_CHILDREN_10; b++)
     816:	4a8d                	li	s5,3
     818:	a835                	j	854 <main+0x854>
     81a:	2485                	addiw	s1,s1,1
     81c:	09f1                	addi	s3,s3,28
     81e:	03548963          	beq	s1,s5,850 <main+0x850>
            if (reports[a].page_faults == reports[b].page_faults &&
     822:	fe492703          	lw	a4,-28(s2)
                reports[a].page_faults > 0 &&
     826:	fe270793          	addi	a5,a4,-30
     82a:	00f037b3          	snez	a5,a5
            if (reports[a].page_faults == reports[b].page_faults &&
     82e:	00e026b3          	sgtz	a3,a4
                reports[a].page_faults > 0 &&
     832:	8ff5                	and	a5,a5,a3
     834:	d3fd                	beqz	a5,81a <main+0x81a>
            if (reports[a].page_faults == reports[b].page_faults &&
     836:	0009a783          	lw	a5,0(s3)
                reports[a].page_faults > 0 &&
     83a:	fee790e3          	bne	a5,a4,81a <main+0x81a>
                printf("  WARN: child %d and %d have identical fault counts – check isolation\n",
     83e:	8626                	mv	a2,s1
     840:	85de                	mv	a1,s7
     842:	00001517          	auipc	a0,0x1
     846:	16650513          	addi	a0,a0,358 # 19a8 <malloc+0x912>
     84a:	794000ef          	jal	fde <printf>
     84e:	b7f1                	j	81a <main+0x81a>
    for (int a = 0; a < N_CHILDREN_10; a++)
     850:	0971                	addi	s2,s2,28
     852:	8bda                	mv	s7,s6
        for (int b = a + 1; b < N_CHILDREN_10; b++)
     854:	001b8b1b          	addiw	s6,s7,1
     858:	015b0563          	beq	s6,s5,862 <main+0x862>
     85c:	89ca                	mv	s3,s2
     85e:	84da                	mv	s1,s6
     860:	b7c9                	j	822 <main+0x822>
    if (all_ok)
     862:	020a1163          	bnez	s4,884 <main+0x884>
    printf("=== Test 7 done ===\n");
     866:	00001517          	auipc	a0,0x1
     86a:	1c250513          	addi	a0,a0,450 # 1a28 <malloc+0x992>
     86e:	770000ef          	jal	fde <printf>
  test_pa4_10();

  printf("\nPA4_C done.\n");
     872:	00001517          	auipc	a0,0x1
     876:	1ce50513          	addi	a0,a0,462 # 1a40 <malloc+0x9aa>
     87a:	764000ef          	jal	fde <printf>
  exit(0);
     87e:	4501                	li	a0,0
     880:	2c8000ef          	jal	b48 <exit>
        printf("  PASS: all children verified correctly\n");
     884:	00001517          	auipc	a0,0x1
     888:	17450513          	addi	a0,a0,372 # 19f8 <malloc+0x962>
     88c:	752000ef          	jal	fde <printf>
     890:	bfd9                	j	866 <main+0x866>

0000000000000892 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     892:	1141                	addi	sp,sp,-16
     894:	e406                	sd	ra,8(sp)
     896:	e022                	sd	s0,0(sp)
     898:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     89a:	f66ff0ef          	jal	0 <main>
  exit(r);
     89e:	2aa000ef          	jal	b48 <exit>

00000000000008a2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     8a2:	1141                	addi	sp,sp,-16
     8a4:	e406                	sd	ra,8(sp)
     8a6:	e022                	sd	s0,0(sp)
     8a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8aa:	87aa                	mv	a5,a0
     8ac:	0585                	addi	a1,a1,1
     8ae:	0785                	addi	a5,a5,1
     8b0:	fff5c703          	lbu	a4,-1(a1)
     8b4:	fee78fa3          	sb	a4,-1(a5)
     8b8:	fb75                	bnez	a4,8ac <strcpy+0xa>
    ;
  return os;
}
     8ba:	60a2                	ld	ra,8(sp)
     8bc:	6402                	ld	s0,0(sp)
     8be:	0141                	addi	sp,sp,16
     8c0:	8082                	ret

00000000000008c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     8c2:	1141                	addi	sp,sp,-16
     8c4:	e406                	sd	ra,8(sp)
     8c6:	e022                	sd	s0,0(sp)
     8c8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     8ca:	00054783          	lbu	a5,0(a0)
     8ce:	cb91                	beqz	a5,8e2 <strcmp+0x20>
     8d0:	0005c703          	lbu	a4,0(a1)
     8d4:	00f71763          	bne	a4,a5,8e2 <strcmp+0x20>
    p++, q++;
     8d8:	0505                	addi	a0,a0,1
     8da:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     8dc:	00054783          	lbu	a5,0(a0)
     8e0:	fbe5                	bnez	a5,8d0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     8e2:	0005c503          	lbu	a0,0(a1)
}
     8e6:	40a7853b          	subw	a0,a5,a0
     8ea:	60a2                	ld	ra,8(sp)
     8ec:	6402                	ld	s0,0(sp)
     8ee:	0141                	addi	sp,sp,16
     8f0:	8082                	ret

00000000000008f2 <strlen>:

uint
strlen(const char *s)
{
     8f2:	1141                	addi	sp,sp,-16
     8f4:	e406                	sd	ra,8(sp)
     8f6:	e022                	sd	s0,0(sp)
     8f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     8fa:	00054783          	lbu	a5,0(a0)
     8fe:	cf91                	beqz	a5,91a <strlen+0x28>
     900:	00150793          	addi	a5,a0,1
     904:	86be                	mv	a3,a5
     906:	0785                	addi	a5,a5,1
     908:	fff7c703          	lbu	a4,-1(a5)
     90c:	ff65                	bnez	a4,904 <strlen+0x12>
     90e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     912:	60a2                	ld	ra,8(sp)
     914:	6402                	ld	s0,0(sp)
     916:	0141                	addi	sp,sp,16
     918:	8082                	ret
  for(n = 0; s[n]; n++)
     91a:	4501                	li	a0,0
     91c:	bfdd                	j	912 <strlen+0x20>

000000000000091e <memset>:

void*
memset(void *dst, int c, uint n)
{
     91e:	1141                	addi	sp,sp,-16
     920:	e406                	sd	ra,8(sp)
     922:	e022                	sd	s0,0(sp)
     924:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     926:	ca19                	beqz	a2,93c <memset+0x1e>
     928:	87aa                	mv	a5,a0
     92a:	1602                	slli	a2,a2,0x20
     92c:	9201                	srli	a2,a2,0x20
     92e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     932:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     936:	0785                	addi	a5,a5,1
     938:	fee79de3          	bne	a5,a4,932 <memset+0x14>
  }
  return dst;
}
     93c:	60a2                	ld	ra,8(sp)
     93e:	6402                	ld	s0,0(sp)
     940:	0141                	addi	sp,sp,16
     942:	8082                	ret

0000000000000944 <strchr>:

char*
strchr(const char *s, char c)
{
     944:	1141                	addi	sp,sp,-16
     946:	e406                	sd	ra,8(sp)
     948:	e022                	sd	s0,0(sp)
     94a:	0800                	addi	s0,sp,16
  for(; *s; s++)
     94c:	00054783          	lbu	a5,0(a0)
     950:	cf81                	beqz	a5,968 <strchr+0x24>
    if(*s == c)
     952:	00f58763          	beq	a1,a5,960 <strchr+0x1c>
  for(; *s; s++)
     956:	0505                	addi	a0,a0,1
     958:	00054783          	lbu	a5,0(a0)
     95c:	fbfd                	bnez	a5,952 <strchr+0xe>
      return (char*)s;
  return 0;
     95e:	4501                	li	a0,0
}
     960:	60a2                	ld	ra,8(sp)
     962:	6402                	ld	s0,0(sp)
     964:	0141                	addi	sp,sp,16
     966:	8082                	ret
  return 0;
     968:	4501                	li	a0,0
     96a:	bfdd                	j	960 <strchr+0x1c>

000000000000096c <gets>:

char*
gets(char *buf, int max)
{
     96c:	711d                	addi	sp,sp,-96
     96e:	ec86                	sd	ra,88(sp)
     970:	e8a2                	sd	s0,80(sp)
     972:	e4a6                	sd	s1,72(sp)
     974:	e0ca                	sd	s2,64(sp)
     976:	fc4e                	sd	s3,56(sp)
     978:	f852                	sd	s4,48(sp)
     97a:	f456                	sd	s5,40(sp)
     97c:	f05a                	sd	s6,32(sp)
     97e:	ec5e                	sd	s7,24(sp)
     980:	e862                	sd	s8,16(sp)
     982:	1080                	addi	s0,sp,96
     984:	8baa                	mv	s7,a0
     986:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     988:	892a                	mv	s2,a0
     98a:	4481                	li	s1,0
    cc = read(0, &c, 1);
     98c:	faf40b13          	addi	s6,s0,-81
     990:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     992:	8c26                	mv	s8,s1
     994:	0014899b          	addiw	s3,s1,1
     998:	84ce                	mv	s1,s3
     99a:	0349d463          	bge	s3,s4,9c2 <gets+0x56>
    cc = read(0, &c, 1);
     99e:	8656                	mv	a2,s5
     9a0:	85da                	mv	a1,s6
     9a2:	4501                	li	a0,0
     9a4:	1bc000ef          	jal	b60 <read>
    if(cc < 1)
     9a8:	00a05d63          	blez	a0,9c2 <gets+0x56>
      break;
    buf[i++] = c;
     9ac:	faf44783          	lbu	a5,-81(s0)
     9b0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9b4:	0905                	addi	s2,s2,1
     9b6:	ff678713          	addi	a4,a5,-10
     9ba:	c319                	beqz	a4,9c0 <gets+0x54>
     9bc:	17cd                	addi	a5,a5,-13
     9be:	fbf1                	bnez	a5,992 <gets+0x26>
    buf[i++] = c;
     9c0:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     9c2:	9c5e                	add	s8,s8,s7
     9c4:	000c0023          	sb	zero,0(s8)
  return buf;
}
     9c8:	855e                	mv	a0,s7
     9ca:	60e6                	ld	ra,88(sp)
     9cc:	6446                	ld	s0,80(sp)
     9ce:	64a6                	ld	s1,72(sp)
     9d0:	6906                	ld	s2,64(sp)
     9d2:	79e2                	ld	s3,56(sp)
     9d4:	7a42                	ld	s4,48(sp)
     9d6:	7aa2                	ld	s5,40(sp)
     9d8:	7b02                	ld	s6,32(sp)
     9da:	6be2                	ld	s7,24(sp)
     9dc:	6c42                	ld	s8,16(sp)
     9de:	6125                	addi	sp,sp,96
     9e0:	8082                	ret

00000000000009e2 <stat>:

int
stat(const char *n, struct stat *st)
{
     9e2:	1101                	addi	sp,sp,-32
     9e4:	ec06                	sd	ra,24(sp)
     9e6:	e822                	sd	s0,16(sp)
     9e8:	e04a                	sd	s2,0(sp)
     9ea:	1000                	addi	s0,sp,32
     9ec:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     9ee:	4581                	li	a1,0
     9f0:	198000ef          	jal	b88 <open>
  if(fd < 0)
     9f4:	02054263          	bltz	a0,a18 <stat+0x36>
     9f8:	e426                	sd	s1,8(sp)
     9fa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     9fc:	85ca                	mv	a1,s2
     9fe:	1a2000ef          	jal	ba0 <fstat>
     a02:	892a                	mv	s2,a0
  close(fd);
     a04:	8526                	mv	a0,s1
     a06:	16a000ef          	jal	b70 <close>
  return r;
     a0a:	64a2                	ld	s1,8(sp)
}
     a0c:	854a                	mv	a0,s2
     a0e:	60e2                	ld	ra,24(sp)
     a10:	6442                	ld	s0,16(sp)
     a12:	6902                	ld	s2,0(sp)
     a14:	6105                	addi	sp,sp,32
     a16:	8082                	ret
    return -1;
     a18:	57fd                	li	a5,-1
     a1a:	893e                	mv	s2,a5
     a1c:	bfc5                	j	a0c <stat+0x2a>

0000000000000a1e <atoi>:

int
atoi(const char *s)
{
     a1e:	1141                	addi	sp,sp,-16
     a20:	e406                	sd	ra,8(sp)
     a22:	e022                	sd	s0,0(sp)
     a24:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a26:	00054683          	lbu	a3,0(a0)
     a2a:	fd06879b          	addiw	a5,a3,-48
     a2e:	0ff7f793          	zext.b	a5,a5
     a32:	4625                	li	a2,9
     a34:	02f66963          	bltu	a2,a5,a66 <atoi+0x48>
     a38:	872a                	mv	a4,a0
  n = 0;
     a3a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a3c:	0705                	addi	a4,a4,1
     a3e:	0025179b          	slliw	a5,a0,0x2
     a42:	9fa9                	addw	a5,a5,a0
     a44:	0017979b          	slliw	a5,a5,0x1
     a48:	9fb5                	addw	a5,a5,a3
     a4a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a4e:	00074683          	lbu	a3,0(a4)
     a52:	fd06879b          	addiw	a5,a3,-48
     a56:	0ff7f793          	zext.b	a5,a5
     a5a:	fef671e3          	bgeu	a2,a5,a3c <atoi+0x1e>
  return n;
}
     a5e:	60a2                	ld	ra,8(sp)
     a60:	6402                	ld	s0,0(sp)
     a62:	0141                	addi	sp,sp,16
     a64:	8082                	ret
  n = 0;
     a66:	4501                	li	a0,0
     a68:	bfdd                	j	a5e <atoi+0x40>

0000000000000a6a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a6a:	1141                	addi	sp,sp,-16
     a6c:	e406                	sd	ra,8(sp)
     a6e:	e022                	sd	s0,0(sp)
     a70:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     a72:	02b57563          	bgeu	a0,a1,a9c <memmove+0x32>
    while(n-- > 0)
     a76:	00c05f63          	blez	a2,a94 <memmove+0x2a>
     a7a:	1602                	slli	a2,a2,0x20
     a7c:	9201                	srli	a2,a2,0x20
     a7e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     a82:	872a                	mv	a4,a0
      *dst++ = *src++;
     a84:	0585                	addi	a1,a1,1
     a86:	0705                	addi	a4,a4,1
     a88:	fff5c683          	lbu	a3,-1(a1)
     a8c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     a90:	fee79ae3          	bne	a5,a4,a84 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     a94:	60a2                	ld	ra,8(sp)
     a96:	6402                	ld	s0,0(sp)
     a98:	0141                	addi	sp,sp,16
     a9a:	8082                	ret
    while(n-- > 0)
     a9c:	fec05ce3          	blez	a2,a94 <memmove+0x2a>
    dst += n;
     aa0:	00c50733          	add	a4,a0,a2
    src += n;
     aa4:	95b2                	add	a1,a1,a2
     aa6:	fff6079b          	addiw	a5,a2,-1
     aaa:	1782                	slli	a5,a5,0x20
     aac:	9381                	srli	a5,a5,0x20
     aae:	fff7c793          	not	a5,a5
     ab2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ab4:	15fd                	addi	a1,a1,-1
     ab6:	177d                	addi	a4,a4,-1
     ab8:	0005c683          	lbu	a3,0(a1)
     abc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     ac0:	fef71ae3          	bne	a4,a5,ab4 <memmove+0x4a>
     ac4:	bfc1                	j	a94 <memmove+0x2a>

0000000000000ac6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     ac6:	1141                	addi	sp,sp,-16
     ac8:	e406                	sd	ra,8(sp)
     aca:	e022                	sd	s0,0(sp)
     acc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     ace:	c61d                	beqz	a2,afc <memcmp+0x36>
     ad0:	1602                	slli	a2,a2,0x20
     ad2:	9201                	srli	a2,a2,0x20
     ad4:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     ad8:	00054783          	lbu	a5,0(a0)
     adc:	0005c703          	lbu	a4,0(a1)
     ae0:	00e79863          	bne	a5,a4,af0 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     ae4:	0505                	addi	a0,a0,1
    p2++;
     ae6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ae8:	fed518e3          	bne	a0,a3,ad8 <memcmp+0x12>
  }
  return 0;
     aec:	4501                	li	a0,0
     aee:	a019                	j	af4 <memcmp+0x2e>
      return *p1 - *p2;
     af0:	40e7853b          	subw	a0,a5,a4
}
     af4:	60a2                	ld	ra,8(sp)
     af6:	6402                	ld	s0,0(sp)
     af8:	0141                	addi	sp,sp,16
     afa:	8082                	ret
  return 0;
     afc:	4501                	li	a0,0
     afe:	bfdd                	j	af4 <memcmp+0x2e>

0000000000000b00 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b00:	1141                	addi	sp,sp,-16
     b02:	e406                	sd	ra,8(sp)
     b04:	e022                	sd	s0,0(sp)
     b06:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b08:	f63ff0ef          	jal	a6a <memmove>
}
     b0c:	60a2                	ld	ra,8(sp)
     b0e:	6402                	ld	s0,0(sp)
     b10:	0141                	addi	sp,sp,16
     b12:	8082                	ret

0000000000000b14 <sbrk>:

char *
sbrk(int n) {
     b14:	1141                	addi	sp,sp,-16
     b16:	e406                	sd	ra,8(sp)
     b18:	e022                	sd	s0,0(sp)
     b1a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     b1c:	4585                	li	a1,1
     b1e:	0b2000ef          	jal	bd0 <sys_sbrk>
}
     b22:	60a2                	ld	ra,8(sp)
     b24:	6402                	ld	s0,0(sp)
     b26:	0141                	addi	sp,sp,16
     b28:	8082                	ret

0000000000000b2a <sbrklazy>:

char *
sbrklazy(int n) {
     b2a:	1141                	addi	sp,sp,-16
     b2c:	e406                	sd	ra,8(sp)
     b2e:	e022                	sd	s0,0(sp)
     b30:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     b32:	4589                	li	a1,2
     b34:	09c000ef          	jal	bd0 <sys_sbrk>
}
     b38:	60a2                	ld	ra,8(sp)
     b3a:	6402                	ld	s0,0(sp)
     b3c:	0141                	addi	sp,sp,16
     b3e:	8082                	ret

0000000000000b40 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b40:	4885                	li	a7,1
 ecall
     b42:	00000073          	ecall
 ret
     b46:	8082                	ret

0000000000000b48 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b48:	4889                	li	a7,2
 ecall
     b4a:	00000073          	ecall
 ret
     b4e:	8082                	ret

0000000000000b50 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b50:	488d                	li	a7,3
 ecall
     b52:	00000073          	ecall
 ret
     b56:	8082                	ret

0000000000000b58 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b58:	4891                	li	a7,4
 ecall
     b5a:	00000073          	ecall
 ret
     b5e:	8082                	ret

0000000000000b60 <read>:
.global read
read:
 li a7, SYS_read
     b60:	4895                	li	a7,5
 ecall
     b62:	00000073          	ecall
 ret
     b66:	8082                	ret

0000000000000b68 <write>:
.global write
write:
 li a7, SYS_write
     b68:	48c1                	li	a7,16
 ecall
     b6a:	00000073          	ecall
 ret
     b6e:	8082                	ret

0000000000000b70 <close>:
.global close
close:
 li a7, SYS_close
     b70:	48d5                	li	a7,21
 ecall
     b72:	00000073          	ecall
 ret
     b76:	8082                	ret

0000000000000b78 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b78:	4899                	li	a7,6
 ecall
     b7a:	00000073          	ecall
 ret
     b7e:	8082                	ret

0000000000000b80 <exec>:
.global exec
exec:
 li a7, SYS_exec
     b80:	489d                	li	a7,7
 ecall
     b82:	00000073          	ecall
 ret
     b86:	8082                	ret

0000000000000b88 <open>:
.global open
open:
 li a7, SYS_open
     b88:	48bd                	li	a7,15
 ecall
     b8a:	00000073          	ecall
 ret
     b8e:	8082                	ret

0000000000000b90 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b90:	48c5                	li	a7,17
 ecall
     b92:	00000073          	ecall
 ret
     b96:	8082                	ret

0000000000000b98 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b98:	48c9                	li	a7,18
 ecall
     b9a:	00000073          	ecall
 ret
     b9e:	8082                	ret

0000000000000ba0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ba0:	48a1                	li	a7,8
 ecall
     ba2:	00000073          	ecall
 ret
     ba6:	8082                	ret

0000000000000ba8 <link>:
.global link
link:
 li a7, SYS_link
     ba8:	48cd                	li	a7,19
 ecall
     baa:	00000073          	ecall
 ret
     bae:	8082                	ret

0000000000000bb0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bb0:	48d1                	li	a7,20
 ecall
     bb2:	00000073          	ecall
 ret
     bb6:	8082                	ret

0000000000000bb8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     bb8:	48a5                	li	a7,9
 ecall
     bba:	00000073          	ecall
 ret
     bbe:	8082                	ret

0000000000000bc0 <dup>:
.global dup
dup:
 li a7, SYS_dup
     bc0:	48a9                	li	a7,10
 ecall
     bc2:	00000073          	ecall
 ret
     bc6:	8082                	ret

0000000000000bc8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bc8:	48ad                	li	a7,11
 ecall
     bca:	00000073          	ecall
 ret
     bce:	8082                	ret

0000000000000bd0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     bd0:	48b1                	li	a7,12
 ecall
     bd2:	00000073          	ecall
 ret
     bd6:	8082                	ret

0000000000000bd8 <pause>:
.global pause
pause:
 li a7, SYS_pause
     bd8:	48b5                	li	a7,13
 ecall
     bda:	00000073          	ecall
 ret
     bde:	8082                	ret

0000000000000be0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     be0:	48b9                	li	a7,14
 ecall
     be2:	00000073          	ecall
 ret
     be6:	8082                	ret

0000000000000be8 <hello>:
.global hello
hello:
 li a7, SYS_hello
     be8:	48d9                	li	a7,22
 ecall
     bea:	00000073          	ecall
 ret
     bee:	8082                	ret

0000000000000bf0 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
     bf0:	48dd                	li	a7,23
 ecall
     bf2:	00000073          	ecall
 ret
     bf6:	8082                	ret

0000000000000bf8 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
     bf8:	48e1                	li	a7,24
 ecall
     bfa:	00000073          	ecall
 ret
     bfe:	8082                	ret

0000000000000c00 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
     c00:	48e5                	li	a7,25
 ecall
     c02:	00000073          	ecall
 ret
     c06:	8082                	ret

0000000000000c08 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
     c08:	48e9                	li	a7,26
 ecall
     c0a:	00000073          	ecall
 ret
     c0e:	8082                	ret

0000000000000c10 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
     c10:	48ed                	li	a7,27
 ecall
     c12:	00000073          	ecall
 ret
     c16:	8082                	ret

0000000000000c18 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
     c18:	48f1                	li	a7,28
 ecall
     c1a:	00000073          	ecall
 ret
     c1e:	8082                	ret

0000000000000c20 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
     c20:	48f5                	li	a7,29
 ecall
     c22:	00000073          	ecall
 ret
     c26:	8082                	ret

0000000000000c28 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
     c28:	48f9                	li	a7,30
 ecall
     c2a:	00000073          	ecall
 ret
     c2e:	8082                	ret

0000000000000c30 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
     c30:	48fd                	li	a7,31
 ecall
     c32:	00000073          	ecall
 ret
     c36:	8082                	ret

0000000000000c38 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c38:	1101                	addi	sp,sp,-32
     c3a:	ec06                	sd	ra,24(sp)
     c3c:	e822                	sd	s0,16(sp)
     c3e:	1000                	addi	s0,sp,32
     c40:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c44:	4605                	li	a2,1
     c46:	fef40593          	addi	a1,s0,-17
     c4a:	f1fff0ef          	jal	b68 <write>
}
     c4e:	60e2                	ld	ra,24(sp)
     c50:	6442                	ld	s0,16(sp)
     c52:	6105                	addi	sp,sp,32
     c54:	8082                	ret

0000000000000c56 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     c56:	715d                	addi	sp,sp,-80
     c58:	e486                	sd	ra,72(sp)
     c5a:	e0a2                	sd	s0,64(sp)
     c5c:	f84a                	sd	s2,48(sp)
     c5e:	f44e                	sd	s3,40(sp)
     c60:	0880                	addi	s0,sp,80
     c62:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     c64:	c6d1                	beqz	a3,cf0 <printint+0x9a>
     c66:	0805d563          	bgez	a1,cf0 <printint+0x9a>
    neg = 1;
    x = -xx;
     c6a:	40b005b3          	neg	a1,a1
    neg = 1;
     c6e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     c70:	fb840993          	addi	s3,s0,-72
  neg = 0;
     c74:	86ce                	mv	a3,s3
  i = 0;
     c76:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c78:	00001817          	auipc	a6,0x1
     c7c:	de080813          	addi	a6,a6,-544 # 1a58 <digits>
     c80:	88ba                	mv	a7,a4
     c82:	0017051b          	addiw	a0,a4,1
     c86:	872a                	mv	a4,a0
     c88:	02c5f7b3          	remu	a5,a1,a2
     c8c:	97c2                	add	a5,a5,a6
     c8e:	0007c783          	lbu	a5,0(a5)
     c92:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c96:	87ae                	mv	a5,a1
     c98:	02c5d5b3          	divu	a1,a1,a2
     c9c:	0685                	addi	a3,a3,1
     c9e:	fec7f1e3          	bgeu	a5,a2,c80 <printint+0x2a>
  if(neg)
     ca2:	00030c63          	beqz	t1,cba <printint+0x64>
    buf[i++] = '-';
     ca6:	fd050793          	addi	a5,a0,-48
     caa:	00878533          	add	a0,a5,s0
     cae:	02d00793          	li	a5,45
     cb2:	fef50423          	sb	a5,-24(a0)
     cb6:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     cba:	02e05563          	blez	a4,ce4 <printint+0x8e>
     cbe:	fc26                	sd	s1,56(sp)
     cc0:	377d                	addiw	a4,a4,-1
     cc2:	00e984b3          	add	s1,s3,a4
     cc6:	19fd                	addi	s3,s3,-1
     cc8:	99ba                	add	s3,s3,a4
     cca:	1702                	slli	a4,a4,0x20
     ccc:	9301                	srli	a4,a4,0x20
     cce:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cd2:	0004c583          	lbu	a1,0(s1)
     cd6:	854a                	mv	a0,s2
     cd8:	f61ff0ef          	jal	c38 <putc>
  while(--i >= 0)
     cdc:	14fd                	addi	s1,s1,-1
     cde:	ff349ae3          	bne	s1,s3,cd2 <printint+0x7c>
     ce2:	74e2                	ld	s1,56(sp)
}
     ce4:	60a6                	ld	ra,72(sp)
     ce6:	6406                	ld	s0,64(sp)
     ce8:	7942                	ld	s2,48(sp)
     cea:	79a2                	ld	s3,40(sp)
     cec:	6161                	addi	sp,sp,80
     cee:	8082                	ret
  neg = 0;
     cf0:	4301                	li	t1,0
     cf2:	bfbd                	j	c70 <printint+0x1a>

0000000000000cf4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cf4:	711d                	addi	sp,sp,-96
     cf6:	ec86                	sd	ra,88(sp)
     cf8:	e8a2                	sd	s0,80(sp)
     cfa:	e4a6                	sd	s1,72(sp)
     cfc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cfe:	0005c483          	lbu	s1,0(a1)
     d02:	22048363          	beqz	s1,f28 <vprintf+0x234>
     d06:	e0ca                	sd	s2,64(sp)
     d08:	fc4e                	sd	s3,56(sp)
     d0a:	f852                	sd	s4,48(sp)
     d0c:	f456                	sd	s5,40(sp)
     d0e:	f05a                	sd	s6,32(sp)
     d10:	ec5e                	sd	s7,24(sp)
     d12:	e862                	sd	s8,16(sp)
     d14:	8b2a                	mv	s6,a0
     d16:	8a2e                	mv	s4,a1
     d18:	8bb2                	mv	s7,a2
  state = 0;
     d1a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d1c:	4901                	li	s2,0
     d1e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d20:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d24:	06400c13          	li	s8,100
     d28:	a00d                	j	d4a <vprintf+0x56>
        putc(fd, c0);
     d2a:	85a6                	mv	a1,s1
     d2c:	855a                	mv	a0,s6
     d2e:	f0bff0ef          	jal	c38 <putc>
     d32:	a019                	j	d38 <vprintf+0x44>
    } else if(state == '%'){
     d34:	03598363          	beq	s3,s5,d5a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     d38:	0019079b          	addiw	a5,s2,1
     d3c:	893e                	mv	s2,a5
     d3e:	873e                	mv	a4,a5
     d40:	97d2                	add	a5,a5,s4
     d42:	0007c483          	lbu	s1,0(a5)
     d46:	1c048a63          	beqz	s1,f1a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
     d4a:	0004879b          	sext.w	a5,s1
    if(state == 0){
     d4e:	fe0993e3          	bnez	s3,d34 <vprintf+0x40>
      if(c0 == '%'){
     d52:	fd579ce3          	bne	a5,s5,d2a <vprintf+0x36>
        state = '%';
     d56:	89be                	mv	s3,a5
     d58:	b7c5                	j	d38 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     d5a:	00ea06b3          	add	a3,s4,a4
     d5e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     d62:	1c060863          	beqz	a2,f32 <vprintf+0x23e>
      if(c0 == 'd'){
     d66:	03878763          	beq	a5,s8,d94 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d6a:	f9478693          	addi	a3,a5,-108
     d6e:	0016b693          	seqz	a3,a3
     d72:	f9c60593          	addi	a1,a2,-100
     d76:	e99d                	bnez	a1,dac <vprintf+0xb8>
     d78:	ca95                	beqz	a3,dac <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     d7a:	008b8493          	addi	s1,s7,8
     d7e:	4685                	li	a3,1
     d80:	4629                	li	a2,10
     d82:	000bb583          	ld	a1,0(s7)
     d86:	855a                	mv	a0,s6
     d88:	ecfff0ef          	jal	c56 <printint>
        i += 1;
     d8c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     d8e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     d90:	4981                	li	s3,0
     d92:	b75d                	j	d38 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     d94:	008b8493          	addi	s1,s7,8
     d98:	4685                	li	a3,1
     d9a:	4629                	li	a2,10
     d9c:	000ba583          	lw	a1,0(s7)
     da0:	855a                	mv	a0,s6
     da2:	eb5ff0ef          	jal	c56 <printint>
     da6:	8ba6                	mv	s7,s1
      state = 0;
     da8:	4981                	li	s3,0
     daa:	b779                	j	d38 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     dac:	9752                	add	a4,a4,s4
     dae:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     db2:	f9460713          	addi	a4,a2,-108
     db6:	00173713          	seqz	a4,a4
     dba:	8f75                	and	a4,a4,a3
     dbc:	f9c58513          	addi	a0,a1,-100
     dc0:	18051363          	bnez	a0,f46 <vprintf+0x252>
     dc4:	18070163          	beqz	a4,f46 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
     dc8:	008b8493          	addi	s1,s7,8
     dcc:	4685                	li	a3,1
     dce:	4629                	li	a2,10
     dd0:	000bb583          	ld	a1,0(s7)
     dd4:	855a                	mv	a0,s6
     dd6:	e81ff0ef          	jal	c56 <printint>
        i += 2;
     dda:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     ddc:	8ba6                	mv	s7,s1
      state = 0;
     dde:	4981                	li	s3,0
        i += 2;
     de0:	bfa1                	j	d38 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     de2:	008b8493          	addi	s1,s7,8
     de6:	4681                	li	a3,0
     de8:	4629                	li	a2,10
     dea:	000be583          	lwu	a1,0(s7)
     dee:	855a                	mv	a0,s6
     df0:	e67ff0ef          	jal	c56 <printint>
     df4:	8ba6                	mv	s7,s1
      state = 0;
     df6:	4981                	li	s3,0
     df8:	b781                	j	d38 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     dfa:	008b8493          	addi	s1,s7,8
     dfe:	4681                	li	a3,0
     e00:	4629                	li	a2,10
     e02:	000bb583          	ld	a1,0(s7)
     e06:	855a                	mv	a0,s6
     e08:	e4fff0ef          	jal	c56 <printint>
        i += 1;
     e0c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     e0e:	8ba6                	mv	s7,s1
      state = 0;
     e10:	4981                	li	s3,0
     e12:	b71d                	j	d38 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e14:	008b8493          	addi	s1,s7,8
     e18:	4681                	li	a3,0
     e1a:	4629                	li	a2,10
     e1c:	000bb583          	ld	a1,0(s7)
     e20:	855a                	mv	a0,s6
     e22:	e35ff0ef          	jal	c56 <printint>
        i += 2;
     e26:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     e28:	8ba6                	mv	s7,s1
      state = 0;
     e2a:	4981                	li	s3,0
        i += 2;
     e2c:	b731                	j	d38 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     e2e:	008b8493          	addi	s1,s7,8
     e32:	4681                	li	a3,0
     e34:	4641                	li	a2,16
     e36:	000be583          	lwu	a1,0(s7)
     e3a:	855a                	mv	a0,s6
     e3c:	e1bff0ef          	jal	c56 <printint>
     e40:	8ba6                	mv	s7,s1
      state = 0;
     e42:	4981                	li	s3,0
     e44:	bdd5                	j	d38 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e46:	008b8493          	addi	s1,s7,8
     e4a:	4681                	li	a3,0
     e4c:	4641                	li	a2,16
     e4e:	000bb583          	ld	a1,0(s7)
     e52:	855a                	mv	a0,s6
     e54:	e03ff0ef          	jal	c56 <printint>
        i += 1;
     e58:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     e5a:	8ba6                	mv	s7,s1
      state = 0;
     e5c:	4981                	li	s3,0
     e5e:	bde9                	j	d38 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e60:	008b8493          	addi	s1,s7,8
     e64:	4681                	li	a3,0
     e66:	4641                	li	a2,16
     e68:	000bb583          	ld	a1,0(s7)
     e6c:	855a                	mv	a0,s6
     e6e:	de9ff0ef          	jal	c56 <printint>
        i += 2;
     e72:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e74:	8ba6                	mv	s7,s1
      state = 0;
     e76:	4981                	li	s3,0
        i += 2;
     e78:	b5c1                	j	d38 <vprintf+0x44>
     e7a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     e7c:	008b8793          	addi	a5,s7,8
     e80:	8cbe                	mv	s9,a5
     e82:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     e86:	03000593          	li	a1,48
     e8a:	855a                	mv	a0,s6
     e8c:	dadff0ef          	jal	c38 <putc>
  putc(fd, 'x');
     e90:	07800593          	li	a1,120
     e94:	855a                	mv	a0,s6
     e96:	da3ff0ef          	jal	c38 <putc>
     e9a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e9c:	00001b97          	auipc	s7,0x1
     ea0:	bbcb8b93          	addi	s7,s7,-1092 # 1a58 <digits>
     ea4:	03c9d793          	srli	a5,s3,0x3c
     ea8:	97de                	add	a5,a5,s7
     eaa:	0007c583          	lbu	a1,0(a5)
     eae:	855a                	mv	a0,s6
     eb0:	d89ff0ef          	jal	c38 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     eb4:	0992                	slli	s3,s3,0x4
     eb6:	34fd                	addiw	s1,s1,-1
     eb8:	f4f5                	bnez	s1,ea4 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     eba:	8be6                	mv	s7,s9
      state = 0;
     ebc:	4981                	li	s3,0
     ebe:	6ca2                	ld	s9,8(sp)
     ec0:	bda5                	j	d38 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
     ec2:	008b8493          	addi	s1,s7,8
     ec6:	000bc583          	lbu	a1,0(s7)
     eca:	855a                	mv	a0,s6
     ecc:	d6dff0ef          	jal	c38 <putc>
     ed0:	8ba6                	mv	s7,s1
      state = 0;
     ed2:	4981                	li	s3,0
     ed4:	b595                	j	d38 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     ed6:	008b8993          	addi	s3,s7,8
     eda:	000bb483          	ld	s1,0(s7)
     ede:	cc91                	beqz	s1,efa <vprintf+0x206>
        for(; *s; s++)
     ee0:	0004c583          	lbu	a1,0(s1)
     ee4:	c985                	beqz	a1,f14 <vprintf+0x220>
          putc(fd, *s);
     ee6:	855a                	mv	a0,s6
     ee8:	d51ff0ef          	jal	c38 <putc>
        for(; *s; s++)
     eec:	0485                	addi	s1,s1,1
     eee:	0004c583          	lbu	a1,0(s1)
     ef2:	f9f5                	bnez	a1,ee6 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
     ef4:	8bce                	mv	s7,s3
      state = 0;
     ef6:	4981                	li	s3,0
     ef8:	b581                	j	d38 <vprintf+0x44>
          s = "(null)";
     efa:	00001497          	auipc	s1,0x1
     efe:	b5648493          	addi	s1,s1,-1194 # 1a50 <malloc+0x9ba>
        for(; *s; s++)
     f02:	02800593          	li	a1,40
     f06:	b7c5                	j	ee6 <vprintf+0x1f2>
        putc(fd, '%');
     f08:	85be                	mv	a1,a5
     f0a:	855a                	mv	a0,s6
     f0c:	d2dff0ef          	jal	c38 <putc>
      state = 0;
     f10:	4981                	li	s3,0
     f12:	b51d                	j	d38 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     f14:	8bce                	mv	s7,s3
      state = 0;
     f16:	4981                	li	s3,0
     f18:	b505                	j	d38 <vprintf+0x44>
     f1a:	6906                	ld	s2,64(sp)
     f1c:	79e2                	ld	s3,56(sp)
     f1e:	7a42                	ld	s4,48(sp)
     f20:	7aa2                	ld	s5,40(sp)
     f22:	7b02                	ld	s6,32(sp)
     f24:	6be2                	ld	s7,24(sp)
     f26:	6c42                	ld	s8,16(sp)
    }
  }
}
     f28:	60e6                	ld	ra,88(sp)
     f2a:	6446                	ld	s0,80(sp)
     f2c:	64a6                	ld	s1,72(sp)
     f2e:	6125                	addi	sp,sp,96
     f30:	8082                	ret
      if(c0 == 'd'){
     f32:	06400713          	li	a4,100
     f36:	e4e78fe3          	beq	a5,a4,d94 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
     f3a:	f9478693          	addi	a3,a5,-108
     f3e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
     f42:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     f44:	4701                	li	a4,0
      } else if(c0 == 'u'){
     f46:	07500513          	li	a0,117
     f4a:	e8a78ce3          	beq	a5,a0,de2 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
     f4e:	f8b60513          	addi	a0,a2,-117
     f52:	e119                	bnez	a0,f58 <vprintf+0x264>
     f54:	ea0693e3          	bnez	a3,dfa <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     f58:	f8b58513          	addi	a0,a1,-117
     f5c:	e119                	bnez	a0,f62 <vprintf+0x26e>
     f5e:	ea071be3          	bnez	a4,e14 <vprintf+0x120>
      } else if(c0 == 'x'){
     f62:	07800513          	li	a0,120
     f66:	eca784e3          	beq	a5,a0,e2e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
     f6a:	f8860613          	addi	a2,a2,-120
     f6e:	e219                	bnez	a2,f74 <vprintf+0x280>
     f70:	ec069be3          	bnez	a3,e46 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     f74:	f8858593          	addi	a1,a1,-120
     f78:	e199                	bnez	a1,f7e <vprintf+0x28a>
     f7a:	ee0713e3          	bnez	a4,e60 <vprintf+0x16c>
      } else if(c0 == 'p'){
     f7e:	07000713          	li	a4,112
     f82:	eee78ce3          	beq	a5,a4,e7a <vprintf+0x186>
      } else if(c0 == 'c'){
     f86:	06300713          	li	a4,99
     f8a:	f2e78ce3          	beq	a5,a4,ec2 <vprintf+0x1ce>
      } else if(c0 == 's'){
     f8e:	07300713          	li	a4,115
     f92:	f4e782e3          	beq	a5,a4,ed6 <vprintf+0x1e2>
      } else if(c0 == '%'){
     f96:	02500713          	li	a4,37
     f9a:	f6e787e3          	beq	a5,a4,f08 <vprintf+0x214>
        putc(fd, '%');
     f9e:	02500593          	li	a1,37
     fa2:	855a                	mv	a0,s6
     fa4:	c95ff0ef          	jal	c38 <putc>
        putc(fd, c0);
     fa8:	85a6                	mv	a1,s1
     faa:	855a                	mv	a0,s6
     fac:	c8dff0ef          	jal	c38 <putc>
      state = 0;
     fb0:	4981                	li	s3,0
     fb2:	b359                	j	d38 <vprintf+0x44>

0000000000000fb4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     fb4:	715d                	addi	sp,sp,-80
     fb6:	ec06                	sd	ra,24(sp)
     fb8:	e822                	sd	s0,16(sp)
     fba:	1000                	addi	s0,sp,32
     fbc:	e010                	sd	a2,0(s0)
     fbe:	e414                	sd	a3,8(s0)
     fc0:	e818                	sd	a4,16(s0)
     fc2:	ec1c                	sd	a5,24(s0)
     fc4:	03043023          	sd	a6,32(s0)
     fc8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     fcc:	8622                	mv	a2,s0
     fce:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     fd2:	d23ff0ef          	jal	cf4 <vprintf>
}
     fd6:	60e2                	ld	ra,24(sp)
     fd8:	6442                	ld	s0,16(sp)
     fda:	6161                	addi	sp,sp,80
     fdc:	8082                	ret

0000000000000fde <printf>:

void
printf(const char *fmt, ...)
{
     fde:	711d                	addi	sp,sp,-96
     fe0:	ec06                	sd	ra,24(sp)
     fe2:	e822                	sd	s0,16(sp)
     fe4:	1000                	addi	s0,sp,32
     fe6:	e40c                	sd	a1,8(s0)
     fe8:	e810                	sd	a2,16(s0)
     fea:	ec14                	sd	a3,24(s0)
     fec:	f018                	sd	a4,32(s0)
     fee:	f41c                	sd	a5,40(s0)
     ff0:	03043823          	sd	a6,48(s0)
     ff4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     ff8:	00840613          	addi	a2,s0,8
     ffc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1000:	85aa                	mv	a1,a0
    1002:	4505                	li	a0,1
    1004:	cf1ff0ef          	jal	cf4 <vprintf>
}
    1008:	60e2                	ld	ra,24(sp)
    100a:	6442                	ld	s0,16(sp)
    100c:	6125                	addi	sp,sp,96
    100e:	8082                	ret

0000000000001010 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1010:	1141                	addi	sp,sp,-16
    1012:	e406                	sd	ra,8(sp)
    1014:	e022                	sd	s0,0(sp)
    1016:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1018:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    101c:	00001797          	auipc	a5,0x1
    1020:	fe47b783          	ld	a5,-28(a5) # 2000 <freep>
    1024:	a039                	j	1032 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1026:	6398                	ld	a4,0(a5)
    1028:	00e7e463          	bltu	a5,a4,1030 <free+0x20>
    102c:	00e6ea63          	bltu	a3,a4,1040 <free+0x30>
{
    1030:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1032:	fed7fae3          	bgeu	a5,a3,1026 <free+0x16>
    1036:	6398                	ld	a4,0(a5)
    1038:	00e6e463          	bltu	a3,a4,1040 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    103c:	fee7eae3          	bltu	a5,a4,1030 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1040:	ff852583          	lw	a1,-8(a0)
    1044:	6390                	ld	a2,0(a5)
    1046:	02059813          	slli	a6,a1,0x20
    104a:	01c85713          	srli	a4,a6,0x1c
    104e:	9736                	add	a4,a4,a3
    1050:	02e60563          	beq	a2,a4,107a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1054:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1058:	4790                	lw	a2,8(a5)
    105a:	02061593          	slli	a1,a2,0x20
    105e:	01c5d713          	srli	a4,a1,0x1c
    1062:	973e                	add	a4,a4,a5
    1064:	02e68263          	beq	a3,a4,1088 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1068:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    106a:	00001717          	auipc	a4,0x1
    106e:	f8f73b23          	sd	a5,-106(a4) # 2000 <freep>
}
    1072:	60a2                	ld	ra,8(sp)
    1074:	6402                	ld	s0,0(sp)
    1076:	0141                	addi	sp,sp,16
    1078:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    107a:	4618                	lw	a4,8(a2)
    107c:	9f2d                	addw	a4,a4,a1
    107e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1082:	6398                	ld	a4,0(a5)
    1084:	6310                	ld	a2,0(a4)
    1086:	b7f9                	j	1054 <free+0x44>
    p->s.size += bp->s.size;
    1088:	ff852703          	lw	a4,-8(a0)
    108c:	9f31                	addw	a4,a4,a2
    108e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1090:	ff053683          	ld	a3,-16(a0)
    1094:	bfd1                	j	1068 <free+0x58>

0000000000001096 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1096:	7139                	addi	sp,sp,-64
    1098:	fc06                	sd	ra,56(sp)
    109a:	f822                	sd	s0,48(sp)
    109c:	f04a                	sd	s2,32(sp)
    109e:	ec4e                	sd	s3,24(sp)
    10a0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10a2:	02051993          	slli	s3,a0,0x20
    10a6:	0209d993          	srli	s3,s3,0x20
    10aa:	09bd                	addi	s3,s3,15
    10ac:	0049d993          	srli	s3,s3,0x4
    10b0:	2985                	addiw	s3,s3,1
    10b2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    10b4:	00001517          	auipc	a0,0x1
    10b8:	f4c53503          	ld	a0,-180(a0) # 2000 <freep>
    10bc:	c905                	beqz	a0,10ec <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10c0:	4798                	lw	a4,8(a5)
    10c2:	09377663          	bgeu	a4,s3,114e <malloc+0xb8>
    10c6:	f426                	sd	s1,40(sp)
    10c8:	e852                	sd	s4,16(sp)
    10ca:	e456                	sd	s5,8(sp)
    10cc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    10ce:	8a4e                	mv	s4,s3
    10d0:	6705                	lui	a4,0x1
    10d2:	00e9f363          	bgeu	s3,a4,10d8 <malloc+0x42>
    10d6:	6a05                	lui	s4,0x1
    10d8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10dc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    10e0:	00001497          	auipc	s1,0x1
    10e4:	f2048493          	addi	s1,s1,-224 # 2000 <freep>
  if(p == SBRK_ERROR)
    10e8:	5afd                	li	s5,-1
    10ea:	a83d                	j	1128 <malloc+0x92>
    10ec:	f426                	sd	s1,40(sp)
    10ee:	e852                	sd	s4,16(sp)
    10f0:	e456                	sd	s5,8(sp)
    10f2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    10f4:	00001797          	auipc	a5,0x1
    10f8:	f1c78793          	addi	a5,a5,-228 # 2010 <base>
    10fc:	00001717          	auipc	a4,0x1
    1100:	f0f73223          	sd	a5,-252(a4) # 2000 <freep>
    1104:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1106:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    110a:	b7d1                	j	10ce <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    110c:	6398                	ld	a4,0(a5)
    110e:	e118                	sd	a4,0(a0)
    1110:	a899                	j	1166 <malloc+0xd0>
  hp->s.size = nu;
    1112:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1116:	0541                	addi	a0,a0,16
    1118:	ef9ff0ef          	jal	1010 <free>
  return freep;
    111c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    111e:	c125                	beqz	a0,117e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1120:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1122:	4798                	lw	a4,8(a5)
    1124:	03277163          	bgeu	a4,s2,1146 <malloc+0xb0>
    if(p == freep)
    1128:	6098                	ld	a4,0(s1)
    112a:	853e                	mv	a0,a5
    112c:	fef71ae3          	bne	a4,a5,1120 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    1130:	8552                	mv	a0,s4
    1132:	9e3ff0ef          	jal	b14 <sbrk>
  if(p == SBRK_ERROR)
    1136:	fd551ee3          	bne	a0,s5,1112 <malloc+0x7c>
        return 0;
    113a:	4501                	li	a0,0
    113c:	74a2                	ld	s1,40(sp)
    113e:	6a42                	ld	s4,16(sp)
    1140:	6aa2                	ld	s5,8(sp)
    1142:	6b02                	ld	s6,0(sp)
    1144:	a03d                	j	1172 <malloc+0xdc>
    1146:	74a2                	ld	s1,40(sp)
    1148:	6a42                	ld	s4,16(sp)
    114a:	6aa2                	ld	s5,8(sp)
    114c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    114e:	fae90fe3          	beq	s2,a4,110c <malloc+0x76>
        p->s.size -= nunits;
    1152:	4137073b          	subw	a4,a4,s3
    1156:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1158:	02071693          	slli	a3,a4,0x20
    115c:	01c6d713          	srli	a4,a3,0x1c
    1160:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1162:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1166:	00001717          	auipc	a4,0x1
    116a:	e8a73d23          	sd	a0,-358(a4) # 2000 <freep>
      return (void*)(p + 1);
    116e:	01078513          	addi	a0,a5,16
  }
}
    1172:	70e2                	ld	ra,56(sp)
    1174:	7442                	ld	s0,48(sp)
    1176:	7902                	ld	s2,32(sp)
    1178:	69e2                	ld	s3,24(sp)
    117a:	6121                	addi	sp,sp,64
    117c:	8082                	ret
    117e:	74a2                	ld	s1,40(sp)
    1180:	6a42                	ld	s4,16(sp)
    1182:	6aa2                	ld	s5,8(sp)
    1184:	6b02                	ld	s6,0(sp)
    1186:	b7f5                	j	1172 <malloc+0xdc>
