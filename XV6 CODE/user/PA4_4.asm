
user/_PA4_4:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <spin_wait>:

// Busy-wait for approximately `ticks` scheduler ticks worth of time.
// We just spin — no pause() dependency.
static void
spin_wait(int iters)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	1000                	addi	s0,sp,32
    volatile int x = 0;
       8:	fe042623          	sw	zero,-20(s0)
    for (int i = 0; i < iters; i++) x++;
       c:	00a05b63          	blez	a0,22 <spin_wait+0x22>
      10:	4701                	li	a4,0
      12:	fec42783          	lw	a5,-20(s0)
      16:	2785                	addiw	a5,a5,1
      18:	fef42623          	sw	a5,-20(s0)
      1c:	2705                	addiw	a4,a4,1
      1e:	fee51ae3          	bne	a0,a4,12 <spin_wait+0x12>
    (void)x;
      22:	fec42783          	lw	a5,-20(s0)
}
      26:	60e2                	ld	ra,24(sp)
      28:	6442                	ld	s0,16(sp)
      2a:	6105                	addi	sp,sp,32
      2c:	8082                	ret

000000000000002e <main>:

// ─── main ────────────────────────────────────────────────────────────────────

int
main(void)
{
      2e:	716d                	addi	sp,sp,-272
      30:	e606                	sd	ra,264(sp)
      32:	e222                	sd	s0,256(sp)
      34:	0a00                	addi	s0,sp,272
    printf("==============================\n");
      36:	00001517          	auipc	a0,0x1
      3a:	2aa50513          	addi	a0,a0,682 # 12e0 <malloc+0xf2>
      3e:	0f8010ef          	jal	1136 <printf>
    printf("PA4_3: Multi-process pressure & stat isolation\n");
      42:	00001517          	auipc	a0,0x1
      46:	2be50513          	addi	a0,a0,702 # 1300 <malloc+0x112>
      4a:	0ec010ef          	jal	1136 <printf>
    printf("==============================\n\n");
      4e:	00001517          	auipc	a0,0x1
      52:	2e250513          	addi	a0,a0,738 # 1330 <malloc+0x142>
      56:	0e0010ef          	jal	1136 <printf>

    printf("--- PA4_5: scheduler-aware eviction ---\n");
      5a:	00001517          	auipc	a0,0x1
      5e:	2fe50513          	addi	a0,a0,766 # 1358 <malloc+0x16a>
      62:	0d4010ef          	jal	1136 <printf>
    printf("=== PA4_5: Scheduler-Aware Eviction Test ===\n");
      66:	00001517          	auipc	a0,0x1
      6a:	32250513          	addi	a0,a0,802 # 1388 <malloc+0x19a>
      6e:	0c8010ef          	jal	1136 <printf>
    pipe(pipe_lo);
      72:	f0840513          	addi	a0,s0,-248
      76:	43b000ef          	jal	cb0 <pipe>
    pipe(pipe_hi);
      7a:	f1040513          	addi	a0,s0,-240
      7e:	433000ef          	jal	cb0 <pipe>
    int pid_lo = fork();
      82:	417000ef          	jal	c98 <fork>
    if (pid_lo == 0) {
      86:	0e051363          	bnez	a0,16c <main+0x13e>
      8a:	fda6                	sd	s1,248(sp)
      8c:	84aa                	mv	s1,a0
        close(pipe_lo[0]);
      8e:	f0842503          	lw	a0,-248(s0)
      92:	437000ef          	jal	cc8 <close>
        close(pipe_hi[0]); close(pipe_hi[1]);
      96:	f1042503          	lw	a0,-240(s0)
      9a:	42f000ef          	jal	cc8 <close>
      9e:	f1442503          	lw	a0,-236(s0)
      a2:	427000ef          	jal	cc8 <close>
        spin_wait(SPIN_ITERS_5);
      a6:	1dcd6537          	lui	a0,0x1dcd6
      aa:	50050513          	addi	a0,a0,1280 # 1dcd6500 <base+0x1dcd44f0>
      ae:	f53ff0ef          	jal	0 <spin_wait>
        char *mem = sbrklazy(WORK_PAGES_5 * PAGE_SZ);
      b2:	6529                	lui	a0,0xa
      b4:	3cf000ef          	jal	c82 <sbrklazy>
        if (mem == (char*)-1) { printf("[LO] sbrklazy failed\n"); exit(1); }
      b8:	57fd                	li	a5,-1
      ba:	04f50c63          	beq	a0,a5,112 <main+0xe4>
      be:	f9ca                	sd	s2,240(sp)
      c0:	f5ce                	sd	s3,232(sp)
      c2:	f1d2                	sd	s4,224(sp)
      c4:	edd6                	sd	s5,216(sp)
      c6:	e9da                	sd	s6,208(sp)
      c8:	e5de                	sd	s7,200(sp)
      ca:	892a                	mv	s2,a0
        for (int i = 0; i < WORK_PAGES_5; i++)
      cc:	87a6                	mv	a5,s1
      ce:	02800713          	li	a4,40
            mem[i * PAGE_SZ] = (char)i;
      d2:	00f50023          	sb	a5,0(a0) # a000 <base+0x7ff0>
        for (int i = 0; i < WORK_PAGES_5; i++)
      d6:	2785                	addiw	a5,a5,1
      d8:	40050513          	addi	a0,a0,1024
      dc:	fee79be3          	bne	a5,a4,d2 <main+0xa4>
        int mypid = getpid();
      e0:	441000ef          	jal	d20 <getpid>
      e4:	f4a42c23          	sw	a0,-168(s0)
        write(pipe_lo[1], &mypid, sizeof(mypid));
      e8:	4611                	li	a2,4
      ea:	f5840593          	addi	a1,s0,-168
      ee:	f0c42503          	lw	a0,-244(s0)
      f2:	3cf000ef          	jal	cc0 <write>
        close(pipe_lo[1]);
      f6:	f0c42503          	lw	a0,-244(s0)
      fa:	3cf000ef          	jal	cc8 <close>
        spin_wait(200000000);
      fe:	0bebc537          	lui	a0,0xbebc
     102:	20050513          	addi	a0,a0,512 # bebc200 <base+0xbeba1f0>
     106:	efbff0ef          	jal	0 <spin_wait>
        int errs = 0;
     10a:	85a6                	mv	a1,s1
        for (int i = 0; i < WORK_PAGES_5; i++)
     10c:	02800693          	li	a3,40
     110:	a02d                	j	13a <main+0x10c>
     112:	f9ca                	sd	s2,240(sp)
     114:	f5ce                	sd	s3,232(sp)
     116:	f1d2                	sd	s4,224(sp)
     118:	edd6                	sd	s5,216(sp)
     11a:	e9da                	sd	s6,208(sp)
     11c:	e5de                	sd	s7,200(sp)
        if (mem == (char*)-1) { printf("[LO] sbrklazy failed\n"); exit(1); }
     11e:	00001517          	auipc	a0,0x1
     122:	29a50513          	addi	a0,a0,666 # 13b8 <malloc+0x1ca>
     126:	010010ef          	jal	1136 <printf>
     12a:	4505                	li	a0,1
     12c:	375000ef          	jal	ca0 <exit>
        for (int i = 0; i < WORK_PAGES_5; i++)
     130:	2485                	addiw	s1,s1,1
     132:	40090913          	addi	s2,s2,1024
     136:	00d48a63          	beq	s1,a3,14a <main+0x11c>
            if (mem[i * PAGE_SZ] != (char)i) errs++;
     13a:	00094703          	lbu	a4,0(s2)
     13e:	0ff4f793          	zext.b	a5,s1
     142:	fef707e3          	beq	a4,a5,130 <main+0x102>
     146:	2585                	addiw	a1,a1,1
     148:	b7e5                	j	130 <main+0x102>
        if (errs == 0)
     14a:	e991                	bnez	a1,15e <main+0x130>
            printf("[LO-child] PASS: data intact after pressure\n");
     14c:	00001517          	auipc	a0,0x1
     150:	28450513          	addi	a0,a0,644 # 13d0 <malloc+0x1e2>
     154:	7e3000ef          	jal	1136 <printf>
        exit(0);
     158:	4501                	li	a0,0
     15a:	347000ef          	jal	ca0 <exit>
            printf("[LO-child] WARN: %d pages saw stale data (swap worked)\n", errs);
     15e:	00001517          	auipc	a0,0x1
     162:	2a250513          	addi	a0,a0,674 # 1400 <malloc+0x212>
     166:	7d1000ef          	jal	1136 <printf>
     16a:	b7fd                	j	158 <main+0x12a>
     16c:	f9ca                	sd	s2,240(sp)
    int pid_hi = fork();
     16e:	32b000ef          	jal	c98 <fork>
     172:	892a                	mv	s2,a0
    if (pid_hi == 0) {
     174:	0e051263          	bnez	a0,258 <main+0x22a>
        close(pipe_hi[0]);
     178:	f1042503          	lw	a0,-240(s0)
     17c:	34d000ef          	jal	cc8 <close>
        close(pipe_lo[0]); close(pipe_lo[1]);
     180:	f0842503          	lw	a0,-248(s0)
     184:	345000ef          	jal	cc8 <close>
     188:	f0c42503          	lw	a0,-244(s0)
     18c:	33d000ef          	jal	cc8 <close>
        char *mem = sbrklazy(WORK_PAGES_5 * PAGE_SZ);
     190:	6529                	lui	a0,0xa
     192:	2f1000ef          	jal	c82 <sbrklazy>
     196:	872a                	mv	a4,a0
        if (mem == (char*)-1) { printf("[HI] sbrklazy failed\n"); exit(1); }
     198:	57fd                	li	a5,-1
     19a:	06f50063          	beq	a0,a5,1fa <main+0x1cc>
     19e:	fda6                	sd	s1,248(sp)
     1a0:	f5ce                	sd	s3,232(sp)
     1a2:	f1d2                	sd	s4,224(sp)
     1a4:	edd6                	sd	s5,216(sp)
     1a6:	e9da                	sd	s6,208(sp)
     1a8:	e5de                	sd	s7,200(sp)
     1aa:	84aa                	mv	s1,a0
     1ac:	06400793          	li	a5,100
        for (int i = 0; i < WORK_PAGES_5; i++)
     1b0:	08c00693          	li	a3,140
            mem[i * PAGE_SZ] = (char)(i + 100);
     1b4:	00f70023          	sb	a5,0(a4)
        for (int i = 0; i < WORK_PAGES_5; i++)
     1b8:	2785                	addiw	a5,a5,1
     1ba:	0ff7f793          	zext.b	a5,a5
     1be:	40070713          	addi	a4,a4,1024
     1c2:	fed799e3          	bne	a5,a3,1b4 <main+0x186>
        int mypid = getpid();
     1c6:	35b000ef          	jal	d20 <getpid>
     1ca:	f4a42c23          	sw	a0,-168(s0)
        write(pipe_hi[1], &mypid, sizeof(mypid));
     1ce:	4611                	li	a2,4
     1d0:	f5840593          	addi	a1,s0,-168
     1d4:	f1442503          	lw	a0,-236(s0)
     1d8:	2e9000ef          	jal	cc0 <write>
        close(pipe_hi[1]);
     1dc:	f1442503          	lw	a0,-236(s0)
     1e0:	2e9000ef          	jal	cc8 <close>
        spin_wait(200000000);
     1e4:	0bebc537          	lui	a0,0xbebc
     1e8:	20050513          	addi	a0,a0,512 # bebc200 <base+0xbeba1f0>
     1ec:	e15ff0ef          	jal	0 <spin_wait>
     1f0:	06400793          	li	a5,100
        for (int i = 0; i < WORK_PAGES_5; i++)
     1f4:	08c00693          	li	a3,140
     1f8:	a03d                	j	226 <main+0x1f8>
     1fa:	fda6                	sd	s1,248(sp)
     1fc:	f5ce                	sd	s3,232(sp)
     1fe:	f1d2                	sd	s4,224(sp)
     200:	edd6                	sd	s5,216(sp)
     202:	e9da                	sd	s6,208(sp)
     204:	e5de                	sd	s7,200(sp)
        if (mem == (char*)-1) { printf("[HI] sbrklazy failed\n"); exit(1); }
     206:	00001517          	auipc	a0,0x1
     20a:	23250513          	addi	a0,a0,562 # 1438 <malloc+0x24a>
     20e:	729000ef          	jal	1136 <printf>
     212:	4505                	li	a0,1
     214:	28d000ef          	jal	ca0 <exit>
        for (int i = 0; i < WORK_PAGES_5; i++)
     218:	40048493          	addi	s1,s1,1024
     21c:	2785                	addiw	a5,a5,1
     21e:	0ff7f793          	zext.b	a5,a5
     222:	00d78863          	beq	a5,a3,232 <main+0x204>
            if (mem[i * PAGE_SZ] != (char)(i + 100)) errs++;
     226:	0004c703          	lbu	a4,0(s1)
     22a:	fef707e3          	beq	a4,a5,218 <main+0x1ea>
     22e:	2905                	addiw	s2,s2,1
     230:	b7e5                	j	218 <main+0x1ea>
        if (errs == 0)
     232:	00091b63          	bnez	s2,248 <main+0x21a>
            printf("[HI-child] PASS: data intact after pressure\n");
     236:	00001517          	auipc	a0,0x1
     23a:	21a50513          	addi	a0,a0,538 # 1450 <malloc+0x262>
     23e:	6f9000ef          	jal	1136 <printf>
        exit(0);
     242:	4501                	li	a0,0
     244:	25d000ef          	jal	ca0 <exit>
            printf("[HI-child] WARN: %d pages saw stale data\n", errs);
     248:	85ca                	mv	a1,s2
     24a:	00001517          	auipc	a0,0x1
     24e:	23650513          	addi	a0,a0,566 # 1480 <malloc+0x292>
     252:	6e5000ef          	jal	1136 <printf>
     256:	b7f5                	j	242 <main+0x214>
     258:	fda6                	sd	s1,248(sp)
     25a:	f5ce                	sd	s3,232(sp)
    close(pipe_lo[1]); close(pipe_hi[1]);
     25c:	f0c42503          	lw	a0,-244(s0)
     260:	269000ef          	jal	cc8 <close>
     264:	f1442503          	lw	a0,-236(s0)
     268:	261000ef          	jal	cc8 <close>
    read(pipe_lo[0], &cpid_lo, sizeof(cpid_lo));
     26c:	4611                	li	a2,4
     26e:	f0040593          	addi	a1,s0,-256
     272:	f0842503          	lw	a0,-248(s0)
     276:	243000ef          	jal	cb8 <read>
    read(pipe_hi[0], &cpid_hi, sizeof(cpid_hi));
     27a:	4611                	li	a2,4
     27c:	f0440593          	addi	a1,s0,-252
     280:	f1042503          	lw	a0,-240(s0)
     284:	235000ef          	jal	cb8 <read>
    close(pipe_lo[0]); close(pipe_hi[0]);
     288:	f0842503          	lw	a0,-248(s0)
     28c:	23d000ef          	jal	cc8 <close>
     290:	f1042503          	lw	a0,-240(s0)
     294:	235000ef          	jal	cc8 <close>
    printf("LO-priority child PID: %d\n", cpid_lo);
     298:	f0042583          	lw	a1,-256(s0)
     29c:	00001517          	auipc	a0,0x1
     2a0:	21450513          	addi	a0,a0,532 # 14b0 <malloc+0x2c2>
     2a4:	693000ef          	jal	1136 <printf>
    printf("HI-priority child PID: %d\n", cpid_hi);
     2a8:	f0442583          	lw	a1,-252(s0)
     2ac:	00001517          	auipc	a0,0x1
     2b0:	22450513          	addi	a0,a0,548 # 14d0 <malloc+0x2e2>
     2b4:	683000ef          	jal	1136 <printf>
    char *pressure = sbrklazy(PRESSURE_5 * PAGE_SZ);
     2b8:	6551                	lui	a0,0x14
     2ba:	1c9000ef          	jal	c82 <sbrklazy>
     2be:	84aa                	mv	s1,a0
    if (pressure != (char*)-1) {
     2c0:	57fd                	li	a5,-1
     2c2:	00f50d63          	beq	a0,a5,2dc <main+0x2ae>
     2c6:	872a                	mv	a4,a0
        for (int i = 0; i < PRESSURE_5; i++)
     2c8:	4781                	li	a5,0
     2ca:	05000693          	li	a3,80
            pressure[i * PAGE_SZ] = (char)i;
     2ce:	00f70023          	sb	a5,0(a4)
        for (int i = 0; i < PRESSURE_5; i++)
     2d2:	2785                	addiw	a5,a5,1
     2d4:	40070713          	addi	a4,a4,1024
     2d8:	fed79be3          	bne	a5,a3,2ce <main+0x2a0>
    spin_wait(50000000);
     2dc:	02faf537          	lui	a0,0x2faf
     2e0:	08050513          	addi	a0,a0,128 # 2faf080 <base+0x2fad070>
     2e4:	d1dff0ef          	jal	0 <spin_wait>
    memset(&st_lo, 0, sizeof(st_lo));
     2e8:	f2840913          	addi	s2,s0,-216
     2ec:	03000613          	li	a2,48
     2f0:	4581                	li	a1,0
     2f2:	854a                	mv	a0,s2
     2f4:	782000ef          	jal	a76 <memset>
    memset(&st_hi, 0, sizeof(st_hi));
     2f8:	03000613          	li	a2,48
     2fc:	4581                	li	a1,0
     2fe:	f5840513          	addi	a0,s0,-168
     302:	774000ef          	jal	a76 <memset>
    if (getvmstats(cpid_lo, &st_lo) != 0)
     306:	85ca                	mv	a1,s2
     308:	f0042503          	lw	a0,-256(s0)
     30c:	275000ef          	jal	d80 <getvmstats>
     310:	1e050963          	beqz	a0,502 <main+0x4d4>
        printf("WARN: getvmstats for lo-child %d failed (may have exited)\n", cpid_lo);
     314:	f0042583          	lw	a1,-256(s0)
     318:	00001517          	auipc	a0,0x1
     31c:	1d850513          	addi	a0,a0,472 # 14f0 <malloc+0x302>
     320:	617000ef          	jal	1136 <printf>
    if (getvmstats(cpid_hi, &st_hi) != 0)
     324:	f5840593          	addi	a1,s0,-168
     328:	f0442503          	lw	a0,-252(s0)
     32c:	255000ef          	jal	d80 <getvmstats>
     330:	20050a63          	beqz	a0,544 <main+0x516>
        printf("WARN: getvmstats for hi-child %d failed (may have exited)\n", cpid_hi);
     334:	f0442583          	lw	a1,-252(s0)
     338:	00001517          	auipc	a0,0x1
     33c:	27050513          	addi	a0,a0,624 # 15a8 <malloc+0x3ba>
     340:	5f7000ef          	jal	1136 <printf>
    if (st_lo.pages_evicted >= st_hi.pages_evicted)
     344:	f2c42603          	lw	a2,-212(s0)
     348:	f5c42583          	lw	a1,-164(s0)
     34c:	22b64d63          	blt	a2,a1,586 <main+0x558>
        printf("\nPASS: LO-priority evicted >= HI-priority (scheduler-aware eviction working)\n");
     350:	00001517          	auipc	a0,0x1
     354:	2b050513          	addi	a0,a0,688 # 1600 <malloc+0x412>
     358:	5df000ef          	jal	1136 <printf>
    if (pressure != (char*)-1)
     35c:	57fd                	li	a5,-1
     35e:	00f48563          	beq	s1,a5,368 <main+0x33a>
        sbrklazy(-(PRESSURE_5 * PAGE_SZ));
     362:	7531                	lui	a0,0xfffec
     364:	11f000ef          	jal	c82 <sbrklazy>
    wait(0); wait(0);
     368:	4501                	li	a0,0
     36a:	13f000ef          	jal	ca8 <wait>
     36e:	4501                	li	a0,0
     370:	139000ef          	jal	ca8 <wait>
    printf("=== PA4_5 done ===\n");
     374:	00001517          	auipc	a0,0x1
     378:	32c50513          	addi	a0,a0,812 # 16a0 <malloc+0x4b2>
     37c:	5bb000ef          	jal	1136 <printf>
    test_pa4_5();

    printf("\n--- PA4_9: multi-process memory pressure ---\n");
     380:	00001517          	auipc	a0,0x1
     384:	33850513          	addi	a0,a0,824 # 16b8 <malloc+0x4ca>
     388:	5af000ef          	jal	1136 <printf>
    printf("=== PA4_9: Multi-Process Memory Pressure ===\n");
     38c:	00001517          	auipc	a0,0x1
     390:	35c50513          	addi	a0,a0,860 # 16e8 <malloc+0x4fa>
     394:	5a3000ef          	jal	1136 <printf>
    for (int i = 0; i < NCHILDREN_9; i++) {
     398:	4901                	li	s2,0
     39a:	498d                	li	s3,3
        pids[i] = fork();
     39c:	0fd000ef          	jal	c98 <fork>
     3a0:	84aa                	mv	s1,a0
        if (pids[i] < 0) {
     3a2:	1e054963          	bltz	a0,594 <main+0x566>
        if (pids[i] == 0)
     3a6:	20050563          	beqz	a0,5b0 <main+0x582>
    for (int i = 0; i < NCHILDREN_9; i++) {
     3aa:	2905                	addiw	s2,s2,1
     3ac:	ff3918e3          	bne	s2,s3,39c <main+0x36e>
     3b0:	f1d2                	sd	s4,224(sp)
     3b2:	448d                	li	s1,3
    int all_ok = 1;
     3b4:	4a05                	li	s4,1
        int status = -1;
     3b6:	59fd                	li	s3,-1
        wait(&status);
     3b8:	f5840913          	addi	s2,s0,-168
        int status = -1;
     3bc:	f5342c23          	sw	s3,-168(s0)
        wait(&status);
     3c0:	854a                	mv	a0,s2
     3c2:	0e7000ef          	jal	ca8 <wait>
        if (status != 0) {
     3c6:	f5842583          	lw	a1,-168(s0)
     3ca:	30059763          	bnez	a1,6d8 <main+0x6aa>
    for (int i = 0; i < NCHILDREN_9; i++) {
     3ce:	34fd                	addiw	s1,s1,-1
     3d0:	f4f5                	bnez	s1,3bc <main+0x38e>
    if (all_ok)
     3d2:	300a0b63          	beqz	s4,6e8 <main+0x6ba>
        printf("PASS: all %d children survived memory pressure with correct data\n", NCHILDREN_9);
     3d6:	458d                	li	a1,3
     3d8:	00001517          	auipc	a0,0x1
     3dc:	49050513          	addi	a0,a0,1168 # 1868 <malloc+0x67a>
     3e0:	557000ef          	jal	1136 <printf>
    memset(&ps, 0, sizeof(ps));
     3e4:	f5840493          	addi	s1,s0,-168
     3e8:	03000613          	li	a2,48
     3ec:	4581                	li	a1,0
     3ee:	8526                	mv	a0,s1
     3f0:	686000ef          	jal	a76 <memset>
    if (getvmstats(getpid(), &ps) == 0) {
     3f4:	12d000ef          	jal	d20 <getpid>
     3f8:	85a6                	mv	a1,s1
     3fa:	187000ef          	jal	d80 <getvmstats>
     3fe:	2e050c63          	beqz	a0,6f6 <main+0x6c8>
    printf("=== PA4_9 done ===\n");
     402:	00001517          	auipc	a0,0x1
     406:	53e50513          	addi	a0,a0,1342 # 1940 <malloc+0x752>
     40a:	52d000ef          	jal	1136 <printf>
    test_pa4_9();

    printf("\n--- PA4_10: PTE isolation across children ---\n");
     40e:	00001517          	auipc	a0,0x1
     412:	54a50513          	addi	a0,a0,1354 # 1958 <malloc+0x76a>
     416:	521000ef          	jal	1136 <printf>
    printf("=== PA4_10: PTE update isolation across %d children ===\n", N_CHILDREN_10);
     41a:	458d                	li	a1,3
     41c:	00001517          	auipc	a0,0x1
     420:	56c50513          	addi	a0,a0,1388 # 1988 <malloc+0x79a>
     424:	513000ef          	jal	1136 <printf>
    printf("    PAGES_EACH=%d  pressure=%d\n", PAGES_EACH_10, PRESSURE_10);
     428:	03200613          	li	a2,50
     42c:	45f9                	li	a1,30
     42e:	00001517          	auipc	a0,0x1
     432:	59a50513          	addi	a0,a0,1434 # 19c8 <malloc+0x7da>
     436:	501000ef          	jal	1136 <printf>
        pipe(pipes[i]);
     43a:	f1040513          	addi	a0,s0,-240
     43e:	073000ef          	jal	cb0 <pipe>
     442:	f1840513          	addi	a0,s0,-232
     446:	06b000ef          	jal	cb0 <pipe>
     44a:	f2040513          	addi	a0,s0,-224
     44e:	063000ef          	jal	cb0 <pipe>
    for (int c = 0; c < N_CHILDREN_10; c++) {
     452:	4a01                	li	s4,0
     454:	490d                	li	s2,3
        int pid = fork();
     456:	043000ef          	jal	c98 <fork>
     45a:	84aa                	mv	s1,a0
        if (pid == 0) {
     45c:	2a050e63          	beqz	a0,718 <main+0x6ea>
    for (int c = 0; c < N_CHILDREN_10; c++) {
     460:	2a05                	addiw	s4,s4,1
     462:	ff2a1ae3          	bne	s4,s2,456 <main+0x428>
     466:	edd6                	sd	s5,216(sp)
     468:	e9da                	sd	s6,208(sp)
     46a:	e5de                	sd	s7,200(sp)
     46c:	f1040493          	addi	s1,s0,-240
     470:	f5840913          	addi	s2,s0,-168
     474:	f2840a93          	addi	s5,s0,-216
     478:	89ca                	mv	s3,s2
        read(pipes[c][0], &reports[c], sizeof(ChildReport_10));
     47a:	4a71                	li	s4,28
        close(pipes[c][1]);
     47c:	40c8                	lw	a0,4(s1)
     47e:	04b000ef          	jal	cc8 <close>
        read(pipes[c][0], &reports[c], sizeof(ChildReport_10));
     482:	8652                	mv	a2,s4
     484:	85ce                	mv	a1,s3
     486:	4088                	lw	a0,0(s1)
     488:	031000ef          	jal	cb8 <read>
        close(pipes[c][0]);
     48c:	4088                	lw	a0,0(s1)
     48e:	03b000ef          	jal	cc8 <close>
    for (int c = 0; c < N_CHILDREN_10; c++) {
     492:	04a1                	addi	s1,s1,8
     494:	09f1                	addi	s3,s3,28
     496:	ff5493e3          	bne	s1,s5,47c <main+0x44e>
        wait(0);
     49a:	4501                	li	a0,0
     49c:	00d000ef          	jal	ca8 <wait>
     4a0:	4501                	li	a0,0
     4a2:	007000ef          	jal	ca8 <wait>
     4a6:	4501                	li	a0,0
     4a8:	001000ef          	jal	ca8 <wait>
    printf("\n[results]\n");
     4ac:	00001517          	auipc	a0,0x1
     4b0:	5ac50513          	addi	a0,a0,1452 # 1a58 <malloc+0x86a>
     4b4:	483000ef          	jal	1136 <printf>
     4b8:	84ca                	mv	s1,s2
    int all_ok = 1;
     4ba:	4a05                	li	s4,1
    for (int c = 0; c < N_CHILDREN_10; c++) {
     4bc:	4981                	li	s3,0
        printf("  child %d (pid=%d): faults=%d evicted=%d sout=%d sin=%d res=%d errors=%d\n",
     4be:	00001b17          	auipc	s6,0x1
     4c2:	5aab0b13          	addi	s6,s6,1450 # 1a68 <malloc+0x87a>
    for (int c = 0; c < N_CHILDREN_10; c++) {
     4c6:	4a8d                	li	s5,3
        printf("  child %d (pid=%d): faults=%d evicted=%d sout=%d sin=%d res=%d errors=%d\n",
     4c8:	4c9c                	lw	a5,24(s1)
     4ca:	e03e                	sd	a5,0(sp)
     4cc:	0144a883          	lw	a7,20(s1)
     4d0:	0104a803          	lw	a6,16(s1)
     4d4:	44dc                	lw	a5,12(s1)
     4d6:	4498                	lw	a4,8(s1)
     4d8:	40d4                	lw	a3,4(s1)
     4da:	4090                	lw	a2,0(s1)
     4dc:	85ce                	mv	a1,s3
     4de:	855a                	mv	a0,s6
     4e0:	457000ef          	jal	1136 <printf>
        if (r->errors != 0) all_ok = 0;
     4e4:	4c9c                	lw	a5,24(s1)
     4e6:	0017b793          	seqz	a5,a5
     4ea:	00fa7a33          	and	s4,s4,a5
    for (int c = 0; c < N_CHILDREN_10; c++) {
     4ee:	2985                	addiw	s3,s3,1
     4f0:	04f1                	addi	s1,s1,28
     4f2:	fd599be3          	bne	s3,s5,4c8 <main+0x49a>
     4f6:	89ca                	mv	s3,s2
    for (int c = 0; c < N_CHILDREN_10; c++) {
     4f8:	4481                	li	s1,0
        if (reports[c].page_faults < PAGES_EACH_10) {
     4fa:	4bf5                	li	s7,29
            printf("  PASS: child %d faults=%d >= %d\n",
     4fc:	4b79                	li	s6,30
    for (int c = 0; c < N_CHILDREN_10; c++) {
     4fe:	4a8d                	li	s5,3
     500:	a189                	j	942 <main+0x914>
        printf("[LO-priority child %d]\n", cpid_lo);
     502:	f0042583          	lw	a1,-256(s0)
     506:	00001517          	auipc	a0,0x1
     50a:	02a50513          	addi	a0,a0,42 # 1530 <malloc+0x342>
     50e:	429000ef          	jal	1136 <printf>
        printf("  pages_evicted    : %d\n", st_lo.pages_evicted);
     512:	f2c42583          	lw	a1,-212(s0)
     516:	00001517          	auipc	a0,0x1
     51a:	03250513          	addi	a0,a0,50 # 1548 <malloc+0x35a>
     51e:	419000ef          	jal	1136 <printf>
        printf("  pages_swapped_out: %d\n", st_lo.pages_swapped_out);
     522:	f3442583          	lw	a1,-204(s0)
     526:	00001517          	auipc	a0,0x1
     52a:	04250513          	addi	a0,a0,66 # 1568 <malloc+0x37a>
     52e:	409000ef          	jal	1136 <printf>
        printf("  resident_pages   : %d\n", st_lo.resident_pages);
     532:	f3842583          	lw	a1,-200(s0)
     536:	00001517          	auipc	a0,0x1
     53a:	05250513          	addi	a0,a0,82 # 1588 <malloc+0x39a>
     53e:	3f9000ef          	jal	1136 <printf>
     542:	b3cd                	j	324 <main+0x2f6>
        printf("[HI-priority child %d]\n", cpid_hi);
     544:	f0442583          	lw	a1,-252(s0)
     548:	00001517          	auipc	a0,0x1
     54c:	0a050513          	addi	a0,a0,160 # 15e8 <malloc+0x3fa>
     550:	3e7000ef          	jal	1136 <printf>
        printf("  pages_evicted    : %d\n", st_hi.pages_evicted);
     554:	f5c42583          	lw	a1,-164(s0)
     558:	00001517          	auipc	a0,0x1
     55c:	ff050513          	addi	a0,a0,-16 # 1548 <malloc+0x35a>
     560:	3d7000ef          	jal	1136 <printf>
        printf("  pages_swapped_out: %d\n", st_hi.pages_swapped_out);
     564:	f6442583          	lw	a1,-156(s0)
     568:	00001517          	auipc	a0,0x1
     56c:	00050513          	mv	a0,a0
     570:	3c7000ef          	jal	1136 <printf>
        printf("  resident_pages   : %d\n", st_hi.resident_pages);
     574:	f6842583          	lw	a1,-152(s0)
     578:	00001517          	auipc	a0,0x1
     57c:	01050513          	addi	a0,a0,16 # 1588 <malloc+0x39a>
     580:	3b7000ef          	jal	1136 <printf>
     584:	b3c1                	j	344 <main+0x316>
        printf("\nINFO: HI evicted=%d LO evicted=%d — result depends on MLFQ demotion timing\n",
     586:	00001517          	auipc	a0,0x1
     58a:	0ca50513          	addi	a0,a0,202 # 1650 <malloc+0x462>
     58e:	3a9000ef          	jal	1136 <printf>
     592:	b3e9                	j	35c <main+0x32e>
     594:	f1d2                	sd	s4,224(sp)
     596:	edd6                	sd	s5,216(sp)
     598:	e9da                	sd	s6,208(sp)
     59a:	e5de                	sd	s7,200(sp)
            printf("FAIL: fork %d failed\n", i);
     59c:	85ca                	mv	a1,s2
     59e:	00001517          	auipc	a0,0x1
     5a2:	17a50513          	addi	a0,a0,378 # 1718 <malloc+0x52a>
     5a6:	391000ef          	jal	1136 <printf>
            exit(1);
     5aa:	4505                	li	a0,1
     5ac:	6f4000ef          	jal	ca0 <exit>
     5b0:	f1d2                	sd	s4,224(sp)
     5b2:	edd6                	sd	s5,216(sp)
     5b4:	e9da                	sd	s6,208(sp)
     5b6:	e5de                	sd	s7,200(sp)
    char *mem = sbrklazy(NPAGES_9 * PAGE_SZ);
     5b8:	6531                	lui	a0,0xc
     5ba:	6c8000ef          	jal	c82 <sbrklazy>
     5be:	8a2a                	mv	s4,a0
    if (mem == (char*)-1) {
     5c0:	57fd                	li	a5,-1
     5c2:	08f50a63          	beq	a0,a5,656 <main+0x628>
        mem[i * PAGE_SZ] = PATTERN_9(id, i);
     5c6:	0ff97a93          	zext.b	s5,s2
     5ca:	02500993          	li	s3,37
     5ce:	033a89bb          	mulw	s3,s5,s3
     5d2:	2985                	addiw	s3,s3,1
     5d4:	0ff9f993          	zext.b	s3,s3
     5d8:	872a                	mv	a4,a0
     5da:	66b1                	lui	a3,0xc
     5dc:	96aa                	add	a3,a3,a0
     5de:	87ce                	mv	a5,s3
     5e0:	00f70023          	sb	a5,0(a4)
    for (int i = 0; i < NPAGES_9; i++)
     5e4:	27ad                	addiw	a5,a5,11
     5e6:	0ff7f793          	zext.b	a5,a5
     5ea:	40070713          	addi	a4,a4,1024
     5ee:	fed719e3          	bne	a4,a3,5e0 <main+0x5b2>
    char *press = sbrklazy(PRESSURE_9 * PAGE_SZ);
     5f2:	653d                	lui	a0,0xf
     5f4:	68e000ef          	jal	c82 <sbrklazy>
     5f8:	872a                	mv	a4,a0
    if (press != (char*)-1) {
     5fa:	57fd                	li	a5,-1
     5fc:	02f50263          	beq	a0,a5,620 <main+0x5f2>
     600:	4781                	li	a5,0
        for (int i = 0; i < PRESSURE_9; i++)
     602:	03c00613          	li	a2,60
            press[i * PAGE_SZ] = (char)(id + i);
     606:	00a79693          	slli	a3,a5,0xa
     60a:	96ba                	add	a3,a3,a4
     60c:	015785bb          	addw	a1,a5,s5
     610:	00b68023          	sb	a1,0(a3) # c000 <base+0x9ff0>
        for (int i = 0; i < PRESSURE_9; i++)
     614:	0785                	addi	a5,a5,1
     616:	fec798e3          	bne	a5,a2,606 <main+0x5d8>
        sbrklazy(-(PRESSURE_9 * PAGE_SZ));
     61a:	7545                	lui	a0,0xffff1
     61c:	666000ef          	jal	c82 <sbrklazy>
    for (int i = 0; i < NPAGES_9; i++) {
     620:	4601                	li	a2,0
     622:	03000693          	li	a3,48
        char got = mem[i * PAGE_SZ];
     626:	00a61793          	slli	a5,a2,0xa
     62a:	97d2                	add	a5,a5,s4
     62c:	0007c703          	lbu	a4,0(a5)
        if (got != PATTERN_9(id, i)) {
     630:	03371c63          	bne	a4,s3,668 <main+0x63a>
    for (int i = 0; i < NPAGES_9; i++) {
     634:	0605                	addi	a2,a2,1
     636:	29ad                	addiw	s3,s3,11
     638:	0ff9f993          	zext.b	s3,s3
     63c:	fed615e3          	bne	a2,a3,626 <main+0x5f8>
        printf("PASS: child %d all %d pages correct under pressure\n", id, NPAGES_9);
     640:	03000613          	li	a2,48
     644:	85ca                	mv	a1,s2
     646:	00001517          	auipc	a0,0x1
     64a:	16a50513          	addi	a0,a0,362 # 17b0 <malloc+0x5c2>
     64e:	2e9000ef          	jal	1136 <printf>
     652:	4485                	li	s1,1
     654:	a815                	j	688 <main+0x65a>
        printf("FAIL: child %d sbrklazy failed\n", id);
     656:	85ca                	mv	a1,s2
     658:	00001517          	auipc	a0,0x1
     65c:	0d850513          	addi	a0,a0,216 # 1730 <malloc+0x542>
     660:	2d7000ef          	jal	1136 <printf>
        return 1;
     664:	4505                	li	a0,1
     666:	a0a9                	j	6b0 <main+0x682>
            printf("FAIL: child %d page %d: expected 0x%x got 0x%x\n",
     668:	86ce                	mv	a3,s3
     66a:	2601                	sext.w	a2,a2
     66c:	85ca                	mv	a1,s2
     66e:	00001517          	auipc	a0,0x1
     672:	0e250513          	addi	a0,a0,226 # 1750 <malloc+0x562>
     676:	2c1000ef          	jal	1136 <printf>
        printf("FAIL: child %d data corrupted under pressure\n", id);
     67a:	85ca                	mv	a1,s2
     67c:	00001517          	auipc	a0,0x1
     680:	10450513          	addi	a0,a0,260 # 1780 <malloc+0x592>
     684:	2b3000ef          	jal	1136 <printf>
    memset(&s, 0, sizeof(s));
     688:	f5840993          	addi	s3,s0,-168
     68c:	03000613          	li	a2,48
     690:	4581                	li	a1,0
     692:	854e                	mv	a0,s3
     694:	3e2000ef          	jal	a76 <memset>
    if (getvmstats(getpid(), &s) == 0) {
     698:	688000ef          	jal	d20 <getpid>
     69c:	85ce                	mv	a1,s3
     69e:	6e2000ef          	jal	d80 <getvmstats>
     6a2:	c909                	beqz	a0,6b4 <main+0x686>
    sbrklazy(-(NPAGES_9 * PAGE_SZ));
     6a4:	7551                	lui	a0,0xffff4
     6a6:	5dc000ef          	jal	c82 <sbrklazy>
    return ok ? 0 : 1;
     6aa:	0014c513          	xori	a0,s1,1
     6ae:	2501                	sext.w	a0,a0
            exit(child_work_9(i));
     6b0:	5f0000ef          	jal	ca0 <exit>
        printf("INFO: child %d -- faults=%d evicted=%d swapped_out=%d swapped_in=%d resident=%d\n",
     6b4:	f6842803          	lw	a6,-152(s0)
     6b8:	f6042783          	lw	a5,-160(s0)
     6bc:	f6442703          	lw	a4,-156(s0)
     6c0:	f5c42683          	lw	a3,-164(s0)
     6c4:	f5842603          	lw	a2,-168(s0)
     6c8:	85ca                	mv	a1,s2
     6ca:	00001517          	auipc	a0,0x1
     6ce:	11e50513          	addi	a0,a0,286 # 17e8 <malloc+0x5fa>
     6d2:	265000ef          	jal	1136 <printf>
     6d6:	b7f9                	j	6a4 <main+0x676>
            printf("FAIL: a child exited with status %d\n", status);
     6d8:	00001517          	auipc	a0,0x1
     6dc:	16850513          	addi	a0,a0,360 # 1840 <malloc+0x652>
     6e0:	257000ef          	jal	1136 <printf>
            all_ok = 0;
     6e4:	4a01                	li	s4,0
     6e6:	b1e5                	j	3ce <main+0x3a0>
        printf("FAIL: one or more children reported corruption under pressure\n");
     6e8:	00001517          	auipc	a0,0x1
     6ec:	1c850513          	addi	a0,a0,456 # 18b0 <malloc+0x6c2>
     6f0:	247000ef          	jal	1136 <printf>
     6f4:	b9c5                	j	3e4 <main+0x3b6>
        printf("INFO: parent -- faults=%d evicted=%d swapped_out=%d swapped_in=%d resident=%d\n",
     6f6:	f6842783          	lw	a5,-152(s0)
     6fa:	f6042703          	lw	a4,-160(s0)
     6fe:	f6442683          	lw	a3,-156(s0)
     702:	f5c42603          	lw	a2,-164(s0)
     706:	f5842583          	lw	a1,-168(s0)
     70a:	00001517          	auipc	a0,0x1
     70e:	1e650513          	addi	a0,a0,486 # 18f0 <malloc+0x702>
     712:	225000ef          	jal	1136 <printf>
     716:	b1f5                	j	402 <main+0x3d4>
     718:	edd6                	sd	s5,216(sp)
     71a:	e9da                	sd	s6,208(sp)
     71c:	e5de                	sd	s7,200(sp)
     71e:	f1040993          	addi	s3,s0,-240
            for (int i = 0; i < N_CHILDREN_10; i++) {
     722:	892a                	mv	s2,a0
     724:	4a8d                	li	s5,3
     726:	a029                	j	730 <main+0x702>
     728:	2905                	addiw	s2,s2,1
     72a:	09a1                	addi	s3,s3,8
     72c:	01590d63          	beq	s2,s5,746 <main+0x718>
                close(pipes[i][0]);
     730:	0009a503          	lw	a0,0(s3)
     734:	594000ef          	jal	cc8 <close>
                if (i != c) close(pipes[i][1]);
     738:	ff4908e3          	beq	s2,s4,728 <main+0x6fa>
     73c:	0049a503          	lw	a0,4(s3)
     740:	588000ef          	jal	cc8 <close>
     744:	b7d5                	j	728 <main+0x6fa>
            memset(&rep, 0, sizeof(rep));
     746:	4671                	li	a2,28
     748:	4581                	li	a1,0
     74a:	f2840513          	addi	a0,s0,-216
     74e:	328000ef          	jal	a76 <memset>
            rep.pid = getpid();
     752:	5ce000ef          	jal	d20 <getpid>
     756:	f2a42423          	sw	a0,-216(s0)
            char *mem = sbrklazy(PAGES_EACH_10 * PAGE_SZ);
     75a:	6521                	lui	a0,0x8
     75c:	80050513          	addi	a0,a0,-2048 # 7800 <base+0x57f0>
     760:	522000ef          	jal	c82 <sbrklazy>
     764:	8baa                	mv	s7,a0
            if (mem == (char*)-1) {
     766:	57fd                	li	a5,-1
     768:	0cf50b63          	beq	a0,a5,83e <main+0x810>
                mem[i * PAGE_SZ] = (char)((c * 100 + i) & 0xFF);
     76c:	0ffa7913          	zext.b	s2,s4
     770:	06400993          	li	s3,100
     774:	033909bb          	mulw	s3,s2,s3
     778:	0ff9f993          	zext.b	s3,s3
     77c:	8aaa                	mv	s5,a0
     77e:	6b21                	lui	s6,0x8
     780:	800b0b13          	addi	s6,s6,-2048 # 7800 <base+0x57f0>
     784:	9b2a                	add	s6,s6,a0
     786:	872a                	mv	a4,a0
     788:	87ce                	mv	a5,s3
     78a:	00f70023          	sb	a5,0(a4)
            for (int i = 0; i < PAGES_EACH_10; i++)
     78e:	2785                	addiw	a5,a5,1
     790:	0ff7f793          	zext.b	a5,a5
     794:	40070713          	addi	a4,a4,1024
     798:	ff6719e3          	bne	a4,s6,78a <main+0x75c>
            char *press = sbrklazy(PRESSURE_10 * PAGE_SZ);
     79c:	6535                	lui	a0,0xd
     79e:	80050513          	addi	a0,a0,-2048 # c800 <base+0xa7f0>
     7a2:	4e0000ef          	jal	c82 <sbrklazy>
            if (press != (char*)-1) {
     7a6:	57fd                	li	a5,-1
     7a8:	02f50763          	beq	a0,a5,7d6 <main+0x7a8>
     7ac:	872a                	mv	a4,a0
     7ae:	67b5                	lui	a5,0xd
     7b0:	80078793          	addi	a5,a5,-2048 # c800 <base+0xa7f0>
     7b4:	00f506b3          	add	a3,a0,a5
     7b8:	87ca                	mv	a5,s2
                    press[i * PAGE_SZ] = (char)(c + i);
     7ba:	00f70023          	sb	a5,0(a4)
                for (int i = 0; i < PRESSURE_10; i++)
     7be:	2785                	addiw	a5,a5,1
     7c0:	0ff7f793          	zext.b	a5,a5
     7c4:	40070713          	addi	a4,a4,1024
     7c8:	fed719e3          	bne	a4,a3,7ba <main+0x78c>
                sbrklazy(-(PRESSURE_10 * PAGE_SZ));
     7cc:	7551                	lui	a0,0xffff4
     7ce:	80050513          	addi	a0,a0,-2048 # ffffffffffff3800 <base+0xffffffffffff17f0>
     7d2:	4b0000ef          	jal	c82 <sbrklazy>
            for (int i = 0; i < PAGES_EACH_10; i++)
     7d6:	2985                	addiw	s3,s3,1
     7d8:	0ff9f993          	zext.b	s3,s3
            if (press != (char*)-1) {
     7dc:	875e                	mv	a4,s7
     7de:	87ce                	mv	a5,s3
                mem[i * PAGE_SZ] = (char)((c * 100 + i + 1) & 0xFF);
     7e0:	00f70023          	sb	a5,0(a4)
            for (int i = 0; i < PAGES_EACH_10; i++)
     7e4:	2785                	addiw	a5,a5,1
     7e6:	0ff7f793          	zext.b	a5,a5
     7ea:	40070713          	addi	a4,a4,1024
     7ee:	ff6719e3          	bne	a4,s6,7e0 <main+0x7b2>
            press = sbrklazy(PRESSURE_10 * PAGE_SZ);
     7f2:	6535                	lui	a0,0xd
     7f4:	80050513          	addi	a0,a0,-2048 # c800 <base+0xa7f0>
     7f8:	48a000ef          	jal	c82 <sbrklazy>
            if (press != (char*)-1) {
     7fc:	57fd                	li	a5,-1
     7fe:	02f50a63          	beq	a0,a5,832 <main+0x804>
     802:	0019079b          	addiw	a5,s2,1
     806:	0ff7f793          	zext.b	a5,a5
     80a:	872a                	mv	a4,a0
     80c:	6635                	lui	a2,0xd
     80e:	80060613          	addi	a2,a2,-2048 # c800 <base+0xa7f0>
     812:	00c506b3          	add	a3,a0,a2
                    press[i * PAGE_SZ] = (char)(c + i + 1);
     816:	00f70023          	sb	a5,0(a4)
                for (int i = 0; i < PRESSURE_10; i++)
     81a:	2785                	addiw	a5,a5,1
     81c:	0ff7f793          	zext.b	a5,a5
     820:	40070713          	addi	a4,a4,1024
     824:	fed719e3          	bne	a4,a3,816 <main+0x7e8>
                sbrklazy(-(PRESSURE_10 * PAGE_SZ));
     828:	7551                	lui	a0,0xffff4
     82a:	80050513          	addi	a0,a0,-2048 # ffffffffffff3800 <base+0xffffffffffff17f0>
     82e:	454000ef          	jal	c82 <sbrklazy>
                    printf("  child %d ERROR: page %d = 0x%x, expected 0x%x\n",
     832:	00001b17          	auipc	s6,0x1
     836:	1b6b0b13          	addi	s6,s6,438 # 19e8 <malloc+0x7fa>
            for (int i = 0; i < PAGES_EACH_10; i++) {
     83a:	4979                	li	s2,30
     83c:	a889                	j	88e <main+0x860>
                rep.errors = 99;
     83e:	06300793          	li	a5,99
     842:	f4f42023          	sw	a5,-192(s0)
                write(pipes[c][1], &rep, sizeof(rep));
     846:	003a1493          	slli	s1,s4,0x3
     84a:	f1440793          	addi	a5,s0,-236
     84e:	94be                	add	s1,s1,a5
     850:	4671                	li	a2,28
     852:	f2840593          	addi	a1,s0,-216
     856:	4088                	lw	a0,0(s1)
     858:	468000ef          	jal	cc0 <write>
                close(pipes[c][1]);
     85c:	4088                	lw	a0,0(s1)
     85e:	46a000ef          	jal	cc8 <close>
                exit(1);
     862:	4505                	li	a0,1
     864:	43c000ef          	jal	ca0 <exit>
                    printf("  child %d ERROR: page %d = 0x%x, expected 0x%x\n",
     868:	874e                	mv	a4,s3
     86a:	8626                	mv	a2,s1
     86c:	85d2                	mv	a1,s4
     86e:	855a                	mv	a0,s6
     870:	0c7000ef          	jal	1136 <printf>
                    rep.errors++;
     874:	f4042783          	lw	a5,-192(s0)
     878:	2785                	addiw	a5,a5,1
     87a:	f4f42023          	sw	a5,-192(s0)
            for (int i = 0; i < PAGES_EACH_10; i++) {
     87e:	2485                	addiw	s1,s1,1
     880:	400a8a93          	addi	s5,s5,1024
     884:	2985                	addiw	s3,s3,1
     886:	0ff9f993          	zext.b	s3,s3
     88a:	01248763          	beq	s1,s2,898 <main+0x86a>
                if (mem[i * PAGE_SZ] != exp) {
     88e:	000ac683          	lbu	a3,0(s5)
     892:	ff3686e3          	beq	a3,s3,87e <main+0x850>
     896:	bfc9                	j	868 <main+0x83a>
            memset(&s, 0, sizeof(s));
     898:	f5840493          	addi	s1,s0,-168
     89c:	03000613          	li	a2,48
     8a0:	4581                	li	a1,0
     8a2:	8526                	mv	a0,s1
     8a4:	1d2000ef          	jal	a76 <memset>
            if (getvmstats(rep.pid, &s) == 0) {
     8a8:	85a6                	mv	a1,s1
     8aa:	f2842503          	lw	a0,-216(s0)
     8ae:	4d2000ef          	jal	d80 <getvmstats>
     8b2:	e50d                	bnez	a0,8dc <main+0x8ae>
                rep.page_faults     = s.page_faults;
     8b4:	f5842783          	lw	a5,-168(s0)
     8b8:	f2f42623          	sw	a5,-212(s0)
                rep.pages_evicted   = s.pages_evicted;
     8bc:	f5c42783          	lw	a5,-164(s0)
     8c0:	f2f42823          	sw	a5,-208(s0)
                rep.pages_swapped_out = s.pages_swapped_out;
     8c4:	f6442783          	lw	a5,-156(s0)
     8c8:	f2f42a23          	sw	a5,-204(s0)
                rep.pages_swapped_in  = s.pages_swapped_in;
     8cc:	f6042783          	lw	a5,-160(s0)
     8d0:	f2f42c23          	sw	a5,-200(s0)
                rep.resident_pages  = s.resident_pages;
     8d4:	f6842783          	lw	a5,-152(s0)
     8d8:	f2f42e23          	sw	a5,-196(s0)
            if (rep.page_faults < PAGES_EACH_10)
     8dc:	f2c42603          	lw	a2,-212(s0)
     8e0:	47f5                	li	a5,29
     8e2:	02c7db63          	bge	a5,a2,918 <main+0x8ea>
            sbrklazy(-(PAGES_EACH_10 * PAGE_SZ));
     8e6:	7565                	lui	a0,0xffff9
     8e8:	80050513          	addi	a0,a0,-2048 # ffffffffffff8800 <base+0xffffffffffff67f0>
     8ec:	396000ef          	jal	c82 <sbrklazy>
            write(pipes[c][1], &rep, sizeof(rep));
     8f0:	003a1493          	slli	s1,s4,0x3
     8f4:	f1440793          	addi	a5,s0,-236
     8f8:	94be                	add	s1,s1,a5
     8fa:	4671                	li	a2,28
     8fc:	f2840593          	addi	a1,s0,-216
     900:	4088                	lw	a0,0(s1)
     902:	3be000ef          	jal	cc0 <write>
            close(pipes[c][1]);
     906:	4088                	lw	a0,0(s1)
     908:	3c0000ef          	jal	cc8 <close>
            exit(rep.errors == 0 ? 0 : 1);
     90c:	f4042503          	lw	a0,-192(s0)
     910:	00a03533          	snez	a0,a0
     914:	38c000ef          	jal	ca0 <exit>
                printf("  child %d WARN: page_faults=%d < PAGES_EACH=%d\n",
     918:	46f9                	li	a3,30
     91a:	85d2                	mv	a1,s4
     91c:	00001517          	auipc	a0,0x1
     920:	10450513          	addi	a0,a0,260 # 1a20 <malloc+0x832>
     924:	013000ef          	jal	1136 <printf>
     928:	bf7d                	j	8e6 <main+0x8b8>
            printf("  PASS: child %d faults=%d >= %d\n",
     92a:	86da                	mv	a3,s6
     92c:	85a6                	mv	a1,s1
     92e:	00001517          	auipc	a0,0x1
     932:	1ca50513          	addi	a0,a0,458 # 1af8 <malloc+0x90a>
     936:	001000ef          	jal	1136 <printf>
    for (int c = 0; c < N_CHILDREN_10; c++) {
     93a:	2485                	addiw	s1,s1,1
     93c:	09f1                	addi	s3,s3,28
     93e:	01548f63          	beq	s1,s5,95c <main+0x92e>
        if (reports[c].page_faults < PAGES_EACH_10) {
     942:	0049a603          	lw	a2,4(s3)
     946:	fecbc2e3          	blt	s7,a2,92a <main+0x8fc>
            printf("  INFO: child %d faults=%d (may be < %d if pages hot-cached)\n",
     94a:	86da                	mv	a3,s6
     94c:	85a6                	mv	a1,s1
     94e:	00001517          	auipc	a0,0x1
     952:	16a50513          	addi	a0,a0,362 # 1ab8 <malloc+0x8ca>
     956:	7e0000ef          	jal	1136 <printf>
     95a:	b7c5                	j	93a <main+0x90c>
     95c:	02090913          	addi	s2,s2,32
    for (int a = 0; a < N_CHILDREN_10; a++) {
     960:	4b81                	li	s7,0
        for (int b = a + 1; b < N_CHILDREN_10; b++) {
     962:	4a8d                	li	s5,3
     964:	a835                	j	9a0 <main+0x972>
     966:	2485                	addiw	s1,s1,1
     968:	09f1                	addi	s3,s3,28
     96a:	03548963          	beq	s1,s5,99c <main+0x96e>
            if (reports[a].page_faults == reports[b].page_faults &&
     96e:	fe492703          	lw	a4,-28(s2)
                reports[a].page_faults > 0 &&
     972:	fe270793          	addi	a5,a4,-30
     976:	00f037b3          	snez	a5,a5
            if (reports[a].page_faults == reports[b].page_faults &&
     97a:	00e026b3          	sgtz	a3,a4
                reports[a].page_faults > 0 &&
     97e:	8ff5                	and	a5,a5,a3
     980:	d3fd                	beqz	a5,966 <main+0x938>
            if (reports[a].page_faults == reports[b].page_faults &&
     982:	0009a783          	lw	a5,0(s3)
                reports[a].page_faults > 0 &&
     986:	fee790e3          	bne	a5,a4,966 <main+0x938>
                printf("  WARN: children %d and %d have identical fault counts — check PTE isolation\n",
     98a:	8626                	mv	a2,s1
     98c:	85de                	mv	a1,s7
     98e:	00001517          	auipc	a0,0x1
     992:	19250513          	addi	a0,a0,402 # 1b20 <malloc+0x932>
     996:	7a0000ef          	jal	1136 <printf>
     99a:	b7f1                	j	966 <main+0x938>
    for (int a = 0; a < N_CHILDREN_10; a++) {
     99c:	0971                	addi	s2,s2,28
     99e:	8bda                	mv	s7,s6
        for (int b = a + 1; b < N_CHILDREN_10; b++) {
     9a0:	001b8b1b          	addiw	s6,s7,1
     9a4:	015b0563          	beq	s6,s5,9ae <main+0x980>
     9a8:	89ca                	mv	s3,s2
     9aa:	84da                	mv	s1,s6
     9ac:	b7c9                	j	96e <main+0x940>
    if (all_ok)
     9ae:	020a0763          	beqz	s4,9dc <main+0x9ae>
        printf("  PASS: all children verified correctly — PTE isolation OK\n");
     9b2:	00001517          	auipc	a0,0x1
     9b6:	1be50513          	addi	a0,a0,446 # 1b70 <malloc+0x982>
     9ba:	77c000ef          	jal	1136 <printf>
    printf("=== PA4_10 done ===\n");
     9be:	00001517          	auipc	a0,0x1
     9c2:	23250513          	addi	a0,a0,562 # 1bf0 <malloc+0xa02>
     9c6:	770000ef          	jal	1136 <printf>
    test_pa4_10();

    printf("\nPA4_3 done.\n");
     9ca:	00001517          	auipc	a0,0x1
     9ce:	23e50513          	addi	a0,a0,574 # 1c08 <malloc+0xa1a>
     9d2:	764000ef          	jal	1136 <printf>
    exit(0);
     9d6:	4501                	li	a0,0
     9d8:	2c8000ef          	jal	ca0 <exit>
        printf("  FAIL: data corruption detected — PTE updates not isolated\n");
     9dc:	00001517          	auipc	a0,0x1
     9e0:	1d450513          	addi	a0,a0,468 # 1bb0 <malloc+0x9c2>
     9e4:	752000ef          	jal	1136 <printf>
     9e8:	bfd9                	j	9be <main+0x990>

00000000000009ea <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     9ea:	1141                	addi	sp,sp,-16
     9ec:	e406                	sd	ra,8(sp)
     9ee:	e022                	sd	s0,0(sp)
     9f0:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     9f2:	e3cff0ef          	jal	2e <main>
  exit(r);
     9f6:	2aa000ef          	jal	ca0 <exit>

00000000000009fa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9fa:	1141                	addi	sp,sp,-16
     9fc:	e406                	sd	ra,8(sp)
     9fe:	e022                	sd	s0,0(sp)
     a00:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     a02:	87aa                	mv	a5,a0
     a04:	0585                	addi	a1,a1,1
     a06:	0785                	addi	a5,a5,1
     a08:	fff5c703          	lbu	a4,-1(a1)
     a0c:	fee78fa3          	sb	a4,-1(a5)
     a10:	fb75                	bnez	a4,a04 <strcpy+0xa>
    ;
  return os;
}
     a12:	60a2                	ld	ra,8(sp)
     a14:	6402                	ld	s0,0(sp)
     a16:	0141                	addi	sp,sp,16
     a18:	8082                	ret

0000000000000a1a <strcmp>:

int
strcmp(const char *p, const char *q)
{
     a1a:	1141                	addi	sp,sp,-16
     a1c:	e406                	sd	ra,8(sp)
     a1e:	e022                	sd	s0,0(sp)
     a20:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     a22:	00054783          	lbu	a5,0(a0)
     a26:	cb91                	beqz	a5,a3a <strcmp+0x20>
     a28:	0005c703          	lbu	a4,0(a1)
     a2c:	00f71763          	bne	a4,a5,a3a <strcmp+0x20>
    p++, q++;
     a30:	0505                	addi	a0,a0,1
     a32:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     a34:	00054783          	lbu	a5,0(a0)
     a38:	fbe5                	bnez	a5,a28 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     a3a:	0005c503          	lbu	a0,0(a1)
}
     a3e:	40a7853b          	subw	a0,a5,a0
     a42:	60a2                	ld	ra,8(sp)
     a44:	6402                	ld	s0,0(sp)
     a46:	0141                	addi	sp,sp,16
     a48:	8082                	ret

0000000000000a4a <strlen>:

uint
strlen(const char *s)
{
     a4a:	1141                	addi	sp,sp,-16
     a4c:	e406                	sd	ra,8(sp)
     a4e:	e022                	sd	s0,0(sp)
     a50:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     a52:	00054783          	lbu	a5,0(a0)
     a56:	cf91                	beqz	a5,a72 <strlen+0x28>
     a58:	00150793          	addi	a5,a0,1
     a5c:	86be                	mv	a3,a5
     a5e:	0785                	addi	a5,a5,1
     a60:	fff7c703          	lbu	a4,-1(a5)
     a64:	ff65                	bnez	a4,a5c <strlen+0x12>
     a66:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     a6a:	60a2                	ld	ra,8(sp)
     a6c:	6402                	ld	s0,0(sp)
     a6e:	0141                	addi	sp,sp,16
     a70:	8082                	ret
  for(n = 0; s[n]; n++)
     a72:	4501                	li	a0,0
     a74:	bfdd                	j	a6a <strlen+0x20>

0000000000000a76 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a76:	1141                	addi	sp,sp,-16
     a78:	e406                	sd	ra,8(sp)
     a7a:	e022                	sd	s0,0(sp)
     a7c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a7e:	ca19                	beqz	a2,a94 <memset+0x1e>
     a80:	87aa                	mv	a5,a0
     a82:	1602                	slli	a2,a2,0x20
     a84:	9201                	srli	a2,a2,0x20
     a86:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a8a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a8e:	0785                	addi	a5,a5,1
     a90:	fee79de3          	bne	a5,a4,a8a <memset+0x14>
  }
  return dst;
}
     a94:	60a2                	ld	ra,8(sp)
     a96:	6402                	ld	s0,0(sp)
     a98:	0141                	addi	sp,sp,16
     a9a:	8082                	ret

0000000000000a9c <strchr>:

char*
strchr(const char *s, char c)
{
     a9c:	1141                	addi	sp,sp,-16
     a9e:	e406                	sd	ra,8(sp)
     aa0:	e022                	sd	s0,0(sp)
     aa2:	0800                	addi	s0,sp,16
  for(; *s; s++)
     aa4:	00054783          	lbu	a5,0(a0)
     aa8:	cf81                	beqz	a5,ac0 <strchr+0x24>
    if(*s == c)
     aaa:	00f58763          	beq	a1,a5,ab8 <strchr+0x1c>
  for(; *s; s++)
     aae:	0505                	addi	a0,a0,1
     ab0:	00054783          	lbu	a5,0(a0)
     ab4:	fbfd                	bnez	a5,aaa <strchr+0xe>
      return (char*)s;
  return 0;
     ab6:	4501                	li	a0,0
}
     ab8:	60a2                	ld	ra,8(sp)
     aba:	6402                	ld	s0,0(sp)
     abc:	0141                	addi	sp,sp,16
     abe:	8082                	ret
  return 0;
     ac0:	4501                	li	a0,0
     ac2:	bfdd                	j	ab8 <strchr+0x1c>

0000000000000ac4 <gets>:

char*
gets(char *buf, int max)
{
     ac4:	711d                	addi	sp,sp,-96
     ac6:	ec86                	sd	ra,88(sp)
     ac8:	e8a2                	sd	s0,80(sp)
     aca:	e4a6                	sd	s1,72(sp)
     acc:	e0ca                	sd	s2,64(sp)
     ace:	fc4e                	sd	s3,56(sp)
     ad0:	f852                	sd	s4,48(sp)
     ad2:	f456                	sd	s5,40(sp)
     ad4:	f05a                	sd	s6,32(sp)
     ad6:	ec5e                	sd	s7,24(sp)
     ad8:	e862                	sd	s8,16(sp)
     ada:	1080                	addi	s0,sp,96
     adc:	8baa                	mv	s7,a0
     ade:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ae0:	892a                	mv	s2,a0
     ae2:	4481                	li	s1,0
    cc = read(0, &c, 1);
     ae4:	faf40b13          	addi	s6,s0,-81
     ae8:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     aea:	8c26                	mv	s8,s1
     aec:	0014899b          	addiw	s3,s1,1
     af0:	84ce                	mv	s1,s3
     af2:	0349d463          	bge	s3,s4,b1a <gets+0x56>
    cc = read(0, &c, 1);
     af6:	8656                	mv	a2,s5
     af8:	85da                	mv	a1,s6
     afa:	4501                	li	a0,0
     afc:	1bc000ef          	jal	cb8 <read>
    if(cc < 1)
     b00:	00a05d63          	blez	a0,b1a <gets+0x56>
      break;
    buf[i++] = c;
     b04:	faf44783          	lbu	a5,-81(s0)
     b08:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     b0c:	0905                	addi	s2,s2,1
     b0e:	ff678713          	addi	a4,a5,-10
     b12:	c319                	beqz	a4,b18 <gets+0x54>
     b14:	17cd                	addi	a5,a5,-13
     b16:	fbf1                	bnez	a5,aea <gets+0x26>
    buf[i++] = c;
     b18:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     b1a:	9c5e                	add	s8,s8,s7
     b1c:	000c0023          	sb	zero,0(s8)
  return buf;
}
     b20:	855e                	mv	a0,s7
     b22:	60e6                	ld	ra,88(sp)
     b24:	6446                	ld	s0,80(sp)
     b26:	64a6                	ld	s1,72(sp)
     b28:	6906                	ld	s2,64(sp)
     b2a:	79e2                	ld	s3,56(sp)
     b2c:	7a42                	ld	s4,48(sp)
     b2e:	7aa2                	ld	s5,40(sp)
     b30:	7b02                	ld	s6,32(sp)
     b32:	6be2                	ld	s7,24(sp)
     b34:	6c42                	ld	s8,16(sp)
     b36:	6125                	addi	sp,sp,96
     b38:	8082                	ret

0000000000000b3a <stat>:

int
stat(const char *n, struct stat *st)
{
     b3a:	1101                	addi	sp,sp,-32
     b3c:	ec06                	sd	ra,24(sp)
     b3e:	e822                	sd	s0,16(sp)
     b40:	e04a                	sd	s2,0(sp)
     b42:	1000                	addi	s0,sp,32
     b44:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b46:	4581                	li	a1,0
     b48:	198000ef          	jal	ce0 <open>
  if(fd < 0)
     b4c:	02054263          	bltz	a0,b70 <stat+0x36>
     b50:	e426                	sd	s1,8(sp)
     b52:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     b54:	85ca                	mv	a1,s2
     b56:	1a2000ef          	jal	cf8 <fstat>
     b5a:	892a                	mv	s2,a0
  close(fd);
     b5c:	8526                	mv	a0,s1
     b5e:	16a000ef          	jal	cc8 <close>
  return r;
     b62:	64a2                	ld	s1,8(sp)
}
     b64:	854a                	mv	a0,s2
     b66:	60e2                	ld	ra,24(sp)
     b68:	6442                	ld	s0,16(sp)
     b6a:	6902                	ld	s2,0(sp)
     b6c:	6105                	addi	sp,sp,32
     b6e:	8082                	ret
    return -1;
     b70:	57fd                	li	a5,-1
     b72:	893e                	mv	s2,a5
     b74:	bfc5                	j	b64 <stat+0x2a>

0000000000000b76 <atoi>:

int
atoi(const char *s)
{
     b76:	1141                	addi	sp,sp,-16
     b78:	e406                	sd	ra,8(sp)
     b7a:	e022                	sd	s0,0(sp)
     b7c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b7e:	00054683          	lbu	a3,0(a0)
     b82:	fd06879b          	addiw	a5,a3,-48
     b86:	0ff7f793          	zext.b	a5,a5
     b8a:	4625                	li	a2,9
     b8c:	02f66963          	bltu	a2,a5,bbe <atoi+0x48>
     b90:	872a                	mv	a4,a0
  n = 0;
     b92:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b94:	0705                	addi	a4,a4,1
     b96:	0025179b          	slliw	a5,a0,0x2
     b9a:	9fa9                	addw	a5,a5,a0
     b9c:	0017979b          	slliw	a5,a5,0x1
     ba0:	9fb5                	addw	a5,a5,a3
     ba2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     ba6:	00074683          	lbu	a3,0(a4)
     baa:	fd06879b          	addiw	a5,a3,-48
     bae:	0ff7f793          	zext.b	a5,a5
     bb2:	fef671e3          	bgeu	a2,a5,b94 <atoi+0x1e>
  return n;
}
     bb6:	60a2                	ld	ra,8(sp)
     bb8:	6402                	ld	s0,0(sp)
     bba:	0141                	addi	sp,sp,16
     bbc:	8082                	ret
  n = 0;
     bbe:	4501                	li	a0,0
     bc0:	bfdd                	j	bb6 <atoi+0x40>

0000000000000bc2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     bc2:	1141                	addi	sp,sp,-16
     bc4:	e406                	sd	ra,8(sp)
     bc6:	e022                	sd	s0,0(sp)
     bc8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     bca:	02b57563          	bgeu	a0,a1,bf4 <memmove+0x32>
    while(n-- > 0)
     bce:	00c05f63          	blez	a2,bec <memmove+0x2a>
     bd2:	1602                	slli	a2,a2,0x20
     bd4:	9201                	srli	a2,a2,0x20
     bd6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     bda:	872a                	mv	a4,a0
      *dst++ = *src++;
     bdc:	0585                	addi	a1,a1,1
     bde:	0705                	addi	a4,a4,1
     be0:	fff5c683          	lbu	a3,-1(a1)
     be4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     be8:	fee79ae3          	bne	a5,a4,bdc <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     bec:	60a2                	ld	ra,8(sp)
     bee:	6402                	ld	s0,0(sp)
     bf0:	0141                	addi	sp,sp,16
     bf2:	8082                	ret
    while(n-- > 0)
     bf4:	fec05ce3          	blez	a2,bec <memmove+0x2a>
    dst += n;
     bf8:	00c50733          	add	a4,a0,a2
    src += n;
     bfc:	95b2                	add	a1,a1,a2
     bfe:	fff6079b          	addiw	a5,a2,-1
     c02:	1782                	slli	a5,a5,0x20
     c04:	9381                	srli	a5,a5,0x20
     c06:	fff7c793          	not	a5,a5
     c0a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     c0c:	15fd                	addi	a1,a1,-1
     c0e:	177d                	addi	a4,a4,-1
     c10:	0005c683          	lbu	a3,0(a1)
     c14:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     c18:	fef71ae3          	bne	a4,a5,c0c <memmove+0x4a>
     c1c:	bfc1                	j	bec <memmove+0x2a>

0000000000000c1e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     c1e:	1141                	addi	sp,sp,-16
     c20:	e406                	sd	ra,8(sp)
     c22:	e022                	sd	s0,0(sp)
     c24:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     c26:	c61d                	beqz	a2,c54 <memcmp+0x36>
     c28:	1602                	slli	a2,a2,0x20
     c2a:	9201                	srli	a2,a2,0x20
     c2c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     c30:	00054783          	lbu	a5,0(a0)
     c34:	0005c703          	lbu	a4,0(a1)
     c38:	00e79863          	bne	a5,a4,c48 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     c3c:	0505                	addi	a0,a0,1
    p2++;
     c3e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     c40:	fed518e3          	bne	a0,a3,c30 <memcmp+0x12>
  }
  return 0;
     c44:	4501                	li	a0,0
     c46:	a019                	j	c4c <memcmp+0x2e>
      return *p1 - *p2;
     c48:	40e7853b          	subw	a0,a5,a4
}
     c4c:	60a2                	ld	ra,8(sp)
     c4e:	6402                	ld	s0,0(sp)
     c50:	0141                	addi	sp,sp,16
     c52:	8082                	ret
  return 0;
     c54:	4501                	li	a0,0
     c56:	bfdd                	j	c4c <memcmp+0x2e>

0000000000000c58 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c58:	1141                	addi	sp,sp,-16
     c5a:	e406                	sd	ra,8(sp)
     c5c:	e022                	sd	s0,0(sp)
     c5e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c60:	f63ff0ef          	jal	bc2 <memmove>
}
     c64:	60a2                	ld	ra,8(sp)
     c66:	6402                	ld	s0,0(sp)
     c68:	0141                	addi	sp,sp,16
     c6a:	8082                	ret

0000000000000c6c <sbrk>:

char *
sbrk(int n) {
     c6c:	1141                	addi	sp,sp,-16
     c6e:	e406                	sd	ra,8(sp)
     c70:	e022                	sd	s0,0(sp)
     c72:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c74:	4585                	li	a1,1
     c76:	0b2000ef          	jal	d28 <sys_sbrk>
}
     c7a:	60a2                	ld	ra,8(sp)
     c7c:	6402                	ld	s0,0(sp)
     c7e:	0141                	addi	sp,sp,16
     c80:	8082                	ret

0000000000000c82 <sbrklazy>:

char *
sbrklazy(int n) {
     c82:	1141                	addi	sp,sp,-16
     c84:	e406                	sd	ra,8(sp)
     c86:	e022                	sd	s0,0(sp)
     c88:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c8a:	4589                	li	a1,2
     c8c:	09c000ef          	jal	d28 <sys_sbrk>
}
     c90:	60a2                	ld	ra,8(sp)
     c92:	6402                	ld	s0,0(sp)
     c94:	0141                	addi	sp,sp,16
     c96:	8082                	ret

0000000000000c98 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c98:	4885                	li	a7,1
 ecall
     c9a:	00000073          	ecall
 ret
     c9e:	8082                	ret

0000000000000ca0 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ca0:	4889                	li	a7,2
 ecall
     ca2:	00000073          	ecall
 ret
     ca6:	8082                	ret

0000000000000ca8 <wait>:
.global wait
wait:
 li a7, SYS_wait
     ca8:	488d                	li	a7,3
 ecall
     caa:	00000073          	ecall
 ret
     cae:	8082                	ret

0000000000000cb0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     cb0:	4891                	li	a7,4
 ecall
     cb2:	00000073          	ecall
 ret
     cb6:	8082                	ret

0000000000000cb8 <read>:
.global read
read:
 li a7, SYS_read
     cb8:	4895                	li	a7,5
 ecall
     cba:	00000073          	ecall
 ret
     cbe:	8082                	ret

0000000000000cc0 <write>:
.global write
write:
 li a7, SYS_write
     cc0:	48c1                	li	a7,16
 ecall
     cc2:	00000073          	ecall
 ret
     cc6:	8082                	ret

0000000000000cc8 <close>:
.global close
close:
 li a7, SYS_close
     cc8:	48d5                	li	a7,21
 ecall
     cca:	00000073          	ecall
 ret
     cce:	8082                	ret

0000000000000cd0 <kill>:
.global kill
kill:
 li a7, SYS_kill
     cd0:	4899                	li	a7,6
 ecall
     cd2:	00000073          	ecall
 ret
     cd6:	8082                	ret

0000000000000cd8 <exec>:
.global exec
exec:
 li a7, SYS_exec
     cd8:	489d                	li	a7,7
 ecall
     cda:	00000073          	ecall
 ret
     cde:	8082                	ret

0000000000000ce0 <open>:
.global open
open:
 li a7, SYS_open
     ce0:	48bd                	li	a7,15
 ecall
     ce2:	00000073          	ecall
 ret
     ce6:	8082                	ret

0000000000000ce8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ce8:	48c5                	li	a7,17
 ecall
     cea:	00000073          	ecall
 ret
     cee:	8082                	ret

0000000000000cf0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     cf0:	48c9                	li	a7,18
 ecall
     cf2:	00000073          	ecall
 ret
     cf6:	8082                	ret

0000000000000cf8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     cf8:	48a1                	li	a7,8
 ecall
     cfa:	00000073          	ecall
 ret
     cfe:	8082                	ret

0000000000000d00 <link>:
.global link
link:
 li a7, SYS_link
     d00:	48cd                	li	a7,19
 ecall
     d02:	00000073          	ecall
 ret
     d06:	8082                	ret

0000000000000d08 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     d08:	48d1                	li	a7,20
 ecall
     d0a:	00000073          	ecall
 ret
     d0e:	8082                	ret

0000000000000d10 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     d10:	48a5                	li	a7,9
 ecall
     d12:	00000073          	ecall
 ret
     d16:	8082                	ret

0000000000000d18 <dup>:
.global dup
dup:
 li a7, SYS_dup
     d18:	48a9                	li	a7,10
 ecall
     d1a:	00000073          	ecall
 ret
     d1e:	8082                	ret

0000000000000d20 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     d20:	48ad                	li	a7,11
 ecall
     d22:	00000073          	ecall
 ret
     d26:	8082                	ret

0000000000000d28 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     d28:	48b1                	li	a7,12
 ecall
     d2a:	00000073          	ecall
 ret
     d2e:	8082                	ret

0000000000000d30 <pause>:
.global pause
pause:
 li a7, SYS_pause
     d30:	48b5                	li	a7,13
 ecall
     d32:	00000073          	ecall
 ret
     d36:	8082                	ret

0000000000000d38 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     d38:	48b9                	li	a7,14
 ecall
     d3a:	00000073          	ecall
 ret
     d3e:	8082                	ret

0000000000000d40 <hello>:
.global hello
hello:
 li a7, SYS_hello
     d40:	48d9                	li	a7,22
 ecall
     d42:	00000073          	ecall
 ret
     d46:	8082                	ret

0000000000000d48 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
     d48:	48dd                	li	a7,23
 ecall
     d4a:	00000073          	ecall
 ret
     d4e:	8082                	ret

0000000000000d50 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
     d50:	48e1                	li	a7,24
 ecall
     d52:	00000073          	ecall
 ret
     d56:	8082                	ret

0000000000000d58 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
     d58:	48e5                	li	a7,25
 ecall
     d5a:	00000073          	ecall
 ret
     d5e:	8082                	ret

0000000000000d60 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
     d60:	48e9                	li	a7,26
 ecall
     d62:	00000073          	ecall
 ret
     d66:	8082                	ret

0000000000000d68 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
     d68:	48ed                	li	a7,27
 ecall
     d6a:	00000073          	ecall
 ret
     d6e:	8082                	ret

0000000000000d70 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
     d70:	48f1                	li	a7,28
 ecall
     d72:	00000073          	ecall
 ret
     d76:	8082                	ret

0000000000000d78 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
     d78:	48f5                	li	a7,29
 ecall
     d7a:	00000073          	ecall
 ret
     d7e:	8082                	ret

0000000000000d80 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
     d80:	48f9                	li	a7,30
 ecall
     d82:	00000073          	ecall
 ret
     d86:	8082                	ret

0000000000000d88 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
     d88:	48fd                	li	a7,31
 ecall
     d8a:	00000073          	ecall
 ret
     d8e:	8082                	ret

0000000000000d90 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d90:	1101                	addi	sp,sp,-32
     d92:	ec06                	sd	ra,24(sp)
     d94:	e822                	sd	s0,16(sp)
     d96:	1000                	addi	s0,sp,32
     d98:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d9c:	4605                	li	a2,1
     d9e:	fef40593          	addi	a1,s0,-17
     da2:	f1fff0ef          	jal	cc0 <write>
}
     da6:	60e2                	ld	ra,24(sp)
     da8:	6442                	ld	s0,16(sp)
     daa:	6105                	addi	sp,sp,32
     dac:	8082                	ret

0000000000000dae <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     dae:	715d                	addi	sp,sp,-80
     db0:	e486                	sd	ra,72(sp)
     db2:	e0a2                	sd	s0,64(sp)
     db4:	f84a                	sd	s2,48(sp)
     db6:	f44e                	sd	s3,40(sp)
     db8:	0880                	addi	s0,sp,80
     dba:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     dbc:	c6d1                	beqz	a3,e48 <printint+0x9a>
     dbe:	0805d563          	bgez	a1,e48 <printint+0x9a>
    neg = 1;
    x = -xx;
     dc2:	40b005b3          	neg	a1,a1
    neg = 1;
     dc6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     dc8:	fb840993          	addi	s3,s0,-72
  neg = 0;
     dcc:	86ce                	mv	a3,s3
  i = 0;
     dce:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     dd0:	00001817          	auipc	a6,0x1
     dd4:	e5080813          	addi	a6,a6,-432 # 1c20 <digits>
     dd8:	88ba                	mv	a7,a4
     dda:	0017051b          	addiw	a0,a4,1
     dde:	872a                	mv	a4,a0
     de0:	02c5f7b3          	remu	a5,a1,a2
     de4:	97c2                	add	a5,a5,a6
     de6:	0007c783          	lbu	a5,0(a5)
     dea:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     dee:	87ae                	mv	a5,a1
     df0:	02c5d5b3          	divu	a1,a1,a2
     df4:	0685                	addi	a3,a3,1
     df6:	fec7f1e3          	bgeu	a5,a2,dd8 <printint+0x2a>
  if(neg)
     dfa:	00030c63          	beqz	t1,e12 <printint+0x64>
    buf[i++] = '-';
     dfe:	fd050793          	addi	a5,a0,-48
     e02:	00878533          	add	a0,a5,s0
     e06:	02d00793          	li	a5,45
     e0a:	fef50423          	sb	a5,-24(a0)
     e0e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     e12:	02e05563          	blez	a4,e3c <printint+0x8e>
     e16:	fc26                	sd	s1,56(sp)
     e18:	377d                	addiw	a4,a4,-1
     e1a:	00e984b3          	add	s1,s3,a4
     e1e:	19fd                	addi	s3,s3,-1
     e20:	99ba                	add	s3,s3,a4
     e22:	1702                	slli	a4,a4,0x20
     e24:	9301                	srli	a4,a4,0x20
     e26:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     e2a:	0004c583          	lbu	a1,0(s1)
     e2e:	854a                	mv	a0,s2
     e30:	f61ff0ef          	jal	d90 <putc>
  while(--i >= 0)
     e34:	14fd                	addi	s1,s1,-1
     e36:	ff349ae3          	bne	s1,s3,e2a <printint+0x7c>
     e3a:	74e2                	ld	s1,56(sp)
}
     e3c:	60a6                	ld	ra,72(sp)
     e3e:	6406                	ld	s0,64(sp)
     e40:	7942                	ld	s2,48(sp)
     e42:	79a2                	ld	s3,40(sp)
     e44:	6161                	addi	sp,sp,80
     e46:	8082                	ret
  neg = 0;
     e48:	4301                	li	t1,0
     e4a:	bfbd                	j	dc8 <printint+0x1a>

0000000000000e4c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     e4c:	711d                	addi	sp,sp,-96
     e4e:	ec86                	sd	ra,88(sp)
     e50:	e8a2                	sd	s0,80(sp)
     e52:	e4a6                	sd	s1,72(sp)
     e54:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     e56:	0005c483          	lbu	s1,0(a1)
     e5a:	22048363          	beqz	s1,1080 <vprintf+0x234>
     e5e:	e0ca                	sd	s2,64(sp)
     e60:	fc4e                	sd	s3,56(sp)
     e62:	f852                	sd	s4,48(sp)
     e64:	f456                	sd	s5,40(sp)
     e66:	f05a                	sd	s6,32(sp)
     e68:	ec5e                	sd	s7,24(sp)
     e6a:	e862                	sd	s8,16(sp)
     e6c:	8b2a                	mv	s6,a0
     e6e:	8a2e                	mv	s4,a1
     e70:	8bb2                	mv	s7,a2
  state = 0;
     e72:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     e74:	4901                	li	s2,0
     e76:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     e78:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     e7c:	06400c13          	li	s8,100
     e80:	a00d                	j	ea2 <vprintf+0x56>
        putc(fd, c0);
     e82:	85a6                	mv	a1,s1
     e84:	855a                	mv	a0,s6
     e86:	f0bff0ef          	jal	d90 <putc>
     e8a:	a019                	j	e90 <vprintf+0x44>
    } else if(state == '%'){
     e8c:	03598363          	beq	s3,s5,eb2 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     e90:	0019079b          	addiw	a5,s2,1
     e94:	893e                	mv	s2,a5
     e96:	873e                	mv	a4,a5
     e98:	97d2                	add	a5,a5,s4
     e9a:	0007c483          	lbu	s1,0(a5)
     e9e:	1c048a63          	beqz	s1,1072 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
     ea2:	0004879b          	sext.w	a5,s1
    if(state == 0){
     ea6:	fe0993e3          	bnez	s3,e8c <vprintf+0x40>
      if(c0 == '%'){
     eaa:	fd579ce3          	bne	a5,s5,e82 <vprintf+0x36>
        state = '%';
     eae:	89be                	mv	s3,a5
     eb0:	b7c5                	j	e90 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     eb2:	00ea06b3          	add	a3,s4,a4
     eb6:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     eba:	1c060863          	beqz	a2,108a <vprintf+0x23e>
      if(c0 == 'd'){
     ebe:	03878763          	beq	a5,s8,eec <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     ec2:	f9478693          	addi	a3,a5,-108
     ec6:	0016b693          	seqz	a3,a3
     eca:	f9c60593          	addi	a1,a2,-100
     ece:	e99d                	bnez	a1,f04 <vprintf+0xb8>
     ed0:	ca95                	beqz	a3,f04 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     ed2:	008b8493          	addi	s1,s7,8
     ed6:	4685                	li	a3,1
     ed8:	4629                	li	a2,10
     eda:	000bb583          	ld	a1,0(s7)
     ede:	855a                	mv	a0,s6
     ee0:	ecfff0ef          	jal	dae <printint>
        i += 1;
     ee4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     ee6:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     ee8:	4981                	li	s3,0
     eea:	b75d                	j	e90 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     eec:	008b8493          	addi	s1,s7,8
     ef0:	4685                	li	a3,1
     ef2:	4629                	li	a2,10
     ef4:	000ba583          	lw	a1,0(s7)
     ef8:	855a                	mv	a0,s6
     efa:	eb5ff0ef          	jal	dae <printint>
     efe:	8ba6                	mv	s7,s1
      state = 0;
     f00:	4981                	li	s3,0
     f02:	b779                	j	e90 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     f04:	9752                	add	a4,a4,s4
     f06:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     f0a:	f9460713          	addi	a4,a2,-108
     f0e:	00173713          	seqz	a4,a4
     f12:	8f75                	and	a4,a4,a3
     f14:	f9c58513          	addi	a0,a1,-100
     f18:	18051363          	bnez	a0,109e <vprintf+0x252>
     f1c:	18070163          	beqz	a4,109e <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f20:	008b8493          	addi	s1,s7,8
     f24:	4685                	li	a3,1
     f26:	4629                	li	a2,10
     f28:	000bb583          	ld	a1,0(s7)
     f2c:	855a                	mv	a0,s6
     f2e:	e81ff0ef          	jal	dae <printint>
        i += 2;
     f32:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f34:	8ba6                	mv	s7,s1
      state = 0;
     f36:	4981                	li	s3,0
        i += 2;
     f38:	bfa1                	j	e90 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     f3a:	008b8493          	addi	s1,s7,8
     f3e:	4681                	li	a3,0
     f40:	4629                	li	a2,10
     f42:	000be583          	lwu	a1,0(s7)
     f46:	855a                	mv	a0,s6
     f48:	e67ff0ef          	jal	dae <printint>
     f4c:	8ba6                	mv	s7,s1
      state = 0;
     f4e:	4981                	li	s3,0
     f50:	b781                	j	e90 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f52:	008b8493          	addi	s1,s7,8
     f56:	4681                	li	a3,0
     f58:	4629                	li	a2,10
     f5a:	000bb583          	ld	a1,0(s7)
     f5e:	855a                	mv	a0,s6
     f60:	e4fff0ef          	jal	dae <printint>
        i += 1;
     f64:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     f66:	8ba6                	mv	s7,s1
      state = 0;
     f68:	4981                	li	s3,0
     f6a:	b71d                	j	e90 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f6c:	008b8493          	addi	s1,s7,8
     f70:	4681                	li	a3,0
     f72:	4629                	li	a2,10
     f74:	000bb583          	ld	a1,0(s7)
     f78:	855a                	mv	a0,s6
     f7a:	e35ff0ef          	jal	dae <printint>
        i += 2;
     f7e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f80:	8ba6                	mv	s7,s1
      state = 0;
     f82:	4981                	li	s3,0
        i += 2;
     f84:	b731                	j	e90 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f86:	008b8493          	addi	s1,s7,8
     f8a:	4681                	li	a3,0
     f8c:	4641                	li	a2,16
     f8e:	000be583          	lwu	a1,0(s7)
     f92:	855a                	mv	a0,s6
     f94:	e1bff0ef          	jal	dae <printint>
     f98:	8ba6                	mv	s7,s1
      state = 0;
     f9a:	4981                	li	s3,0
     f9c:	bdd5                	j	e90 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f9e:	008b8493          	addi	s1,s7,8
     fa2:	4681                	li	a3,0
     fa4:	4641                	li	a2,16
     fa6:	000bb583          	ld	a1,0(s7)
     faa:	855a                	mv	a0,s6
     fac:	e03ff0ef          	jal	dae <printint>
        i += 1;
     fb0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     fb2:	8ba6                	mv	s7,s1
      state = 0;
     fb4:	4981                	li	s3,0
     fb6:	bde9                	j	e90 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     fb8:	008b8493          	addi	s1,s7,8
     fbc:	4681                	li	a3,0
     fbe:	4641                	li	a2,16
     fc0:	000bb583          	ld	a1,0(s7)
     fc4:	855a                	mv	a0,s6
     fc6:	de9ff0ef          	jal	dae <printint>
        i += 2;
     fca:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     fcc:	8ba6                	mv	s7,s1
      state = 0;
     fce:	4981                	li	s3,0
        i += 2;
     fd0:	b5c1                	j	e90 <vprintf+0x44>
     fd2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     fd4:	008b8793          	addi	a5,s7,8
     fd8:	8cbe                	mv	s9,a5
     fda:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     fde:	03000593          	li	a1,48
     fe2:	855a                	mv	a0,s6
     fe4:	dadff0ef          	jal	d90 <putc>
  putc(fd, 'x');
     fe8:	07800593          	li	a1,120
     fec:	855a                	mv	a0,s6
     fee:	da3ff0ef          	jal	d90 <putc>
     ff2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     ff4:	00001b97          	auipc	s7,0x1
     ff8:	c2cb8b93          	addi	s7,s7,-980 # 1c20 <digits>
     ffc:	03c9d793          	srli	a5,s3,0x3c
    1000:	97de                	add	a5,a5,s7
    1002:	0007c583          	lbu	a1,0(a5)
    1006:	855a                	mv	a0,s6
    1008:	d89ff0ef          	jal	d90 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    100c:	0992                	slli	s3,s3,0x4
    100e:	34fd                	addiw	s1,s1,-1
    1010:	f4f5                	bnez	s1,ffc <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    1012:	8be6                	mv	s7,s9
      state = 0;
    1014:	4981                	li	s3,0
    1016:	6ca2                	ld	s9,8(sp)
    1018:	bda5                	j	e90 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    101a:	008b8493          	addi	s1,s7,8
    101e:	000bc583          	lbu	a1,0(s7)
    1022:	855a                	mv	a0,s6
    1024:	d6dff0ef          	jal	d90 <putc>
    1028:	8ba6                	mv	s7,s1
      state = 0;
    102a:	4981                	li	s3,0
    102c:	b595                	j	e90 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    102e:	008b8993          	addi	s3,s7,8
    1032:	000bb483          	ld	s1,0(s7)
    1036:	cc91                	beqz	s1,1052 <vprintf+0x206>
        for(; *s; s++)
    1038:	0004c583          	lbu	a1,0(s1)
    103c:	c985                	beqz	a1,106c <vprintf+0x220>
          putc(fd, *s);
    103e:	855a                	mv	a0,s6
    1040:	d51ff0ef          	jal	d90 <putc>
        for(; *s; s++)
    1044:	0485                	addi	s1,s1,1
    1046:	0004c583          	lbu	a1,0(s1)
    104a:	f9f5                	bnez	a1,103e <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
    104c:	8bce                	mv	s7,s3
      state = 0;
    104e:	4981                	li	s3,0
    1050:	b581                	j	e90 <vprintf+0x44>
          s = "(null)";
    1052:	00001497          	auipc	s1,0x1
    1056:	bc648493          	addi	s1,s1,-1082 # 1c18 <malloc+0xa2a>
        for(; *s; s++)
    105a:	02800593          	li	a1,40
    105e:	b7c5                	j	103e <vprintf+0x1f2>
        putc(fd, '%');
    1060:	85be                	mv	a1,a5
    1062:	855a                	mv	a0,s6
    1064:	d2dff0ef          	jal	d90 <putc>
      state = 0;
    1068:	4981                	li	s3,0
    106a:	b51d                	j	e90 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    106c:	8bce                	mv	s7,s3
      state = 0;
    106e:	4981                	li	s3,0
    1070:	b505                	j	e90 <vprintf+0x44>
    1072:	6906                	ld	s2,64(sp)
    1074:	79e2                	ld	s3,56(sp)
    1076:	7a42                	ld	s4,48(sp)
    1078:	7aa2                	ld	s5,40(sp)
    107a:	7b02                	ld	s6,32(sp)
    107c:	6be2                	ld	s7,24(sp)
    107e:	6c42                	ld	s8,16(sp)
    }
  }
}
    1080:	60e6                	ld	ra,88(sp)
    1082:	6446                	ld	s0,80(sp)
    1084:	64a6                	ld	s1,72(sp)
    1086:	6125                	addi	sp,sp,96
    1088:	8082                	ret
      if(c0 == 'd'){
    108a:	06400713          	li	a4,100
    108e:	e4e78fe3          	beq	a5,a4,eec <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    1092:	f9478693          	addi	a3,a5,-108
    1096:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    109a:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    109c:	4701                	li	a4,0
      } else if(c0 == 'u'){
    109e:	07500513          	li	a0,117
    10a2:	e8a78ce3          	beq	a5,a0,f3a <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    10a6:	f8b60513          	addi	a0,a2,-117
    10aa:	e119                	bnez	a0,10b0 <vprintf+0x264>
    10ac:	ea0693e3          	bnez	a3,f52 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    10b0:	f8b58513          	addi	a0,a1,-117
    10b4:	e119                	bnez	a0,10ba <vprintf+0x26e>
    10b6:	ea071be3          	bnez	a4,f6c <vprintf+0x120>
      } else if(c0 == 'x'){
    10ba:	07800513          	li	a0,120
    10be:	eca784e3          	beq	a5,a0,f86 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    10c2:	f8860613          	addi	a2,a2,-120
    10c6:	e219                	bnez	a2,10cc <vprintf+0x280>
    10c8:	ec069be3          	bnez	a3,f9e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    10cc:	f8858593          	addi	a1,a1,-120
    10d0:	e199                	bnez	a1,10d6 <vprintf+0x28a>
    10d2:	ee0713e3          	bnez	a4,fb8 <vprintf+0x16c>
      } else if(c0 == 'p'){
    10d6:	07000713          	li	a4,112
    10da:	eee78ce3          	beq	a5,a4,fd2 <vprintf+0x186>
      } else if(c0 == 'c'){
    10de:	06300713          	li	a4,99
    10e2:	f2e78ce3          	beq	a5,a4,101a <vprintf+0x1ce>
      } else if(c0 == 's'){
    10e6:	07300713          	li	a4,115
    10ea:	f4e782e3          	beq	a5,a4,102e <vprintf+0x1e2>
      } else if(c0 == '%'){
    10ee:	02500713          	li	a4,37
    10f2:	f6e787e3          	beq	a5,a4,1060 <vprintf+0x214>
        putc(fd, '%');
    10f6:	02500593          	li	a1,37
    10fa:	855a                	mv	a0,s6
    10fc:	c95ff0ef          	jal	d90 <putc>
        putc(fd, c0);
    1100:	85a6                	mv	a1,s1
    1102:	855a                	mv	a0,s6
    1104:	c8dff0ef          	jal	d90 <putc>
      state = 0;
    1108:	4981                	li	s3,0
    110a:	b359                	j	e90 <vprintf+0x44>

000000000000110c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    110c:	715d                	addi	sp,sp,-80
    110e:	ec06                	sd	ra,24(sp)
    1110:	e822                	sd	s0,16(sp)
    1112:	1000                	addi	s0,sp,32
    1114:	e010                	sd	a2,0(s0)
    1116:	e414                	sd	a3,8(s0)
    1118:	e818                	sd	a4,16(s0)
    111a:	ec1c                	sd	a5,24(s0)
    111c:	03043023          	sd	a6,32(s0)
    1120:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1124:	8622                	mv	a2,s0
    1126:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    112a:	d23ff0ef          	jal	e4c <vprintf>
}
    112e:	60e2                	ld	ra,24(sp)
    1130:	6442                	ld	s0,16(sp)
    1132:	6161                	addi	sp,sp,80
    1134:	8082                	ret

0000000000001136 <printf>:

void
printf(const char *fmt, ...)
{
    1136:	711d                	addi	sp,sp,-96
    1138:	ec06                	sd	ra,24(sp)
    113a:	e822                	sd	s0,16(sp)
    113c:	1000                	addi	s0,sp,32
    113e:	e40c                	sd	a1,8(s0)
    1140:	e810                	sd	a2,16(s0)
    1142:	ec14                	sd	a3,24(s0)
    1144:	f018                	sd	a4,32(s0)
    1146:	f41c                	sd	a5,40(s0)
    1148:	03043823          	sd	a6,48(s0)
    114c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1150:	00840613          	addi	a2,s0,8
    1154:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1158:	85aa                	mv	a1,a0
    115a:	4505                	li	a0,1
    115c:	cf1ff0ef          	jal	e4c <vprintf>
}
    1160:	60e2                	ld	ra,24(sp)
    1162:	6442                	ld	s0,16(sp)
    1164:	6125                	addi	sp,sp,96
    1166:	8082                	ret

0000000000001168 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1168:	1141                	addi	sp,sp,-16
    116a:	e406                	sd	ra,8(sp)
    116c:	e022                	sd	s0,0(sp)
    116e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1170:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1174:	00001797          	auipc	a5,0x1
    1178:	e8c7b783          	ld	a5,-372(a5) # 2000 <freep>
    117c:	a039                	j	118a <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    117e:	6398                	ld	a4,0(a5)
    1180:	00e7e463          	bltu	a5,a4,1188 <free+0x20>
    1184:	00e6ea63          	bltu	a3,a4,1198 <free+0x30>
{
    1188:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    118a:	fed7fae3          	bgeu	a5,a3,117e <free+0x16>
    118e:	6398                	ld	a4,0(a5)
    1190:	00e6e463          	bltu	a3,a4,1198 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1194:	fee7eae3          	bltu	a5,a4,1188 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1198:	ff852583          	lw	a1,-8(a0)
    119c:	6390                	ld	a2,0(a5)
    119e:	02059813          	slli	a6,a1,0x20
    11a2:	01c85713          	srli	a4,a6,0x1c
    11a6:	9736                	add	a4,a4,a3
    11a8:	02e60563          	beq	a2,a4,11d2 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    11ac:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    11b0:	4790                	lw	a2,8(a5)
    11b2:	02061593          	slli	a1,a2,0x20
    11b6:	01c5d713          	srli	a4,a1,0x1c
    11ba:	973e                	add	a4,a4,a5
    11bc:	02e68263          	beq	a3,a4,11e0 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    11c0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    11c2:	00001717          	auipc	a4,0x1
    11c6:	e2f73f23          	sd	a5,-450(a4) # 2000 <freep>
}
    11ca:	60a2                	ld	ra,8(sp)
    11cc:	6402                	ld	s0,0(sp)
    11ce:	0141                	addi	sp,sp,16
    11d0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    11d2:	4618                	lw	a4,8(a2)
    11d4:	9f2d                	addw	a4,a4,a1
    11d6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11da:	6398                	ld	a4,0(a5)
    11dc:	6310                	ld	a2,0(a4)
    11de:	b7f9                	j	11ac <free+0x44>
    p->s.size += bp->s.size;
    11e0:	ff852703          	lw	a4,-8(a0)
    11e4:	9f31                	addw	a4,a4,a2
    11e6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11e8:	ff053683          	ld	a3,-16(a0)
    11ec:	bfd1                	j	11c0 <free+0x58>

00000000000011ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    11ee:	7139                	addi	sp,sp,-64
    11f0:	fc06                	sd	ra,56(sp)
    11f2:	f822                	sd	s0,48(sp)
    11f4:	f04a                	sd	s2,32(sp)
    11f6:	ec4e                	sd	s3,24(sp)
    11f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11fa:	02051993          	slli	s3,a0,0x20
    11fe:	0209d993          	srli	s3,s3,0x20
    1202:	09bd                	addi	s3,s3,15
    1204:	0049d993          	srli	s3,s3,0x4
    1208:	2985                	addiw	s3,s3,1
    120a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    120c:	00001517          	auipc	a0,0x1
    1210:	df453503          	ld	a0,-524(a0) # 2000 <freep>
    1214:	c905                	beqz	a0,1244 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1216:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1218:	4798                	lw	a4,8(a5)
    121a:	09377663          	bgeu	a4,s3,12a6 <malloc+0xb8>
    121e:	f426                	sd	s1,40(sp)
    1220:	e852                	sd	s4,16(sp)
    1222:	e456                	sd	s5,8(sp)
    1224:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1226:	8a4e                	mv	s4,s3
    1228:	6705                	lui	a4,0x1
    122a:	00e9f363          	bgeu	s3,a4,1230 <malloc+0x42>
    122e:	6a05                	lui	s4,0x1
    1230:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1234:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1238:	00001497          	auipc	s1,0x1
    123c:	dc848493          	addi	s1,s1,-568 # 2000 <freep>
  if(p == SBRK_ERROR)
    1240:	5afd                	li	s5,-1
    1242:	a83d                	j	1280 <malloc+0x92>
    1244:	f426                	sd	s1,40(sp)
    1246:	e852                	sd	s4,16(sp)
    1248:	e456                	sd	s5,8(sp)
    124a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    124c:	00001797          	auipc	a5,0x1
    1250:	dc478793          	addi	a5,a5,-572 # 2010 <base>
    1254:	00001717          	auipc	a4,0x1
    1258:	daf73623          	sd	a5,-596(a4) # 2000 <freep>
    125c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    125e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1262:	b7d1                	j	1226 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1264:	6398                	ld	a4,0(a5)
    1266:	e118                	sd	a4,0(a0)
    1268:	a899                	j	12be <malloc+0xd0>
  hp->s.size = nu;
    126a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    126e:	0541                	addi	a0,a0,16
    1270:	ef9ff0ef          	jal	1168 <free>
  return freep;
    1274:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1276:	c125                	beqz	a0,12d6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1278:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    127a:	4798                	lw	a4,8(a5)
    127c:	03277163          	bgeu	a4,s2,129e <malloc+0xb0>
    if(p == freep)
    1280:	6098                	ld	a4,0(s1)
    1282:	853e                	mv	a0,a5
    1284:	fef71ae3          	bne	a4,a5,1278 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    1288:	8552                	mv	a0,s4
    128a:	9e3ff0ef          	jal	c6c <sbrk>
  if(p == SBRK_ERROR)
    128e:	fd551ee3          	bne	a0,s5,126a <malloc+0x7c>
        return 0;
    1292:	4501                	li	a0,0
    1294:	74a2                	ld	s1,40(sp)
    1296:	6a42                	ld	s4,16(sp)
    1298:	6aa2                	ld	s5,8(sp)
    129a:	6b02                	ld	s6,0(sp)
    129c:	a03d                	j	12ca <malloc+0xdc>
    129e:	74a2                	ld	s1,40(sp)
    12a0:	6a42                	ld	s4,16(sp)
    12a2:	6aa2                	ld	s5,8(sp)
    12a4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    12a6:	fae90fe3          	beq	s2,a4,1264 <malloc+0x76>
        p->s.size -= nunits;
    12aa:	4137073b          	subw	a4,a4,s3
    12ae:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12b0:	02071693          	slli	a3,a4,0x20
    12b4:	01c6d713          	srli	a4,a3,0x1c
    12b8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12ba:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12be:	00001717          	auipc	a4,0x1
    12c2:	d4a73123          	sd	a0,-702(a4) # 2000 <freep>
      return (void*)(p + 1);
    12c6:	01078513          	addi	a0,a5,16
  }
}
    12ca:	70e2                	ld	ra,56(sp)
    12cc:	7442                	ld	s0,48(sp)
    12ce:	7902                	ld	s2,32(sp)
    12d0:	69e2                	ld	s3,24(sp)
    12d2:	6121                	addi	sp,sp,64
    12d4:	8082                	ret
    12d6:	74a2                	ld	s1,40(sp)
    12d8:	6a42                	ld	s4,16(sp)
    12da:	6aa2                	ld	s5,8(sp)
    12dc:	6b02                	ld	s6,0(sp)
    12de:	b7f5                	j	12ca <malloc+0xdc>
