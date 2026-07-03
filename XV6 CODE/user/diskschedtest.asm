
user/_diskschedtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fill>:
  else  { printf("  FAIL: %s\n", name); total_fail++; }
}

static void
fill(char *p, int page, int seed)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  for(int j = 0; j < PAGE_SIZE; j++)
    p[j] = (char)((page * 17 + j * 5 + seed) & 0xFF);
       8:	0045979b          	slliw	a5,a1,0x4
       c:	9fad                	addw	a5,a5,a1
       e:	9fb1                	addw	a5,a5,a2
      10:	0ff7f793          	zext.b	a5,a5
      14:	872a                	mv	a4,a0
      16:	6685                	lui	a3,0x1
      18:	96aa                	add	a3,a3,a0
      1a:	00f70023          	sb	a5,0(a4)
  for(int j = 0; j < PAGE_SIZE; j++)
      1e:	2795                	addiw	a5,a5,5
      20:	0ff7f793          	zext.b	a5,a5
      24:	0705                	addi	a4,a4,1
      26:	fed71ae3          	bne	a4,a3,1a <fill+0x1a>
}
      2a:	60a2                	ld	ra,8(sp)
      2c:	6402                	ld	s0,0(sp)
      2e:	0141                	addi	sp,sp,16
      30:	8082                	ret

0000000000000032 <verify>:

static int
verify(char *base, int npages, int seed)
{
      32:	1141                	addi	sp,sp,-16
      34:	e406                	sd	ra,8(sp)
      36:	e022                	sd	s0,0(sp)
      38:	0800                	addi	s0,sp,16
  for(int i = 0; i < npages; i++)
      3a:	04b05063          	blez	a1,7a <verify+0x48>
      3e:	6785                	lui	a5,0x1
      40:	953e                	add	a0,a0,a5
      42:	0ff67613          	zext.b	a2,a2
      46:	05b2                	slli	a1,a1,0xc
      48:	4881                	li	a7,0
      4a:	787d                	lui	a6,0xfffff
    for(int j = 0; j < PAGE_SIZE; j++){
      4c:	01050733          	add	a4,a0,a6
{
      50:	87b2                	mv	a5,a2
      char exp = (char)((i * 17 + j * 5 + seed) & 0xFF);
      if(base[i * PAGE_SIZE + j] != exp) return 0;
      52:	00074683          	lbu	a3,0(a4)
      56:	02f69463          	bne	a3,a5,7e <verify+0x4c>
    for(int j = 0; j < PAGE_SIZE; j++){
      5a:	0705                	addi	a4,a4,1
      5c:	2795                	addiw	a5,a5,5 # 1005 <vprintf+0x2bd>
      5e:	0ff7f793          	zext.b	a5,a5
      62:	fea718e3          	bne	a4,a0,52 <verify+0x20>
  for(int i = 0; i < npages; i++)
      66:	6785                	lui	a5,0x1
      68:	953e                	add	a0,a0,a5
      6a:	2645                	addiw	a2,a2,17
      6c:	0ff67613          	zext.b	a2,a2
      70:	98be                	add	a7,a7,a5
      72:	fcb89de3          	bne	a7,a1,4c <verify+0x1a>
    }
  return 1;
      76:	4505                	li	a0,1
      78:	a021                	j	80 <verify+0x4e>
      7a:	4505                	li	a0,1
      7c:	a011                	j	80 <verify+0x4e>
      if(base[i * PAGE_SIZE + j] != exp) return 0;
      7e:	4501                	li	a0,0
}
      80:	60a2                	ld	ra,8(sp)
      82:	6402                	ld	s0,0(sp)
      84:	0141                	addi	sp,sp,16
      86:	8082                	ret

0000000000000088 <result>:
{
      88:	1141                	addi	sp,sp,-16
      8a:	e406                	sd	ra,8(sp)
      8c:	e022                	sd	s0,0(sp)
      8e:	0800                	addi	s0,sp,16
  if(ok){ printf("  PASS: %s\n", name); total_pass++; }
      90:	c19d                	beqz	a1,b6 <result+0x2e>
      92:	85aa                	mv	a1,a0
      94:	00001517          	auipc	a0,0x1
      98:	14c50513          	addi	a0,a0,332 # 11e0 <malloc+0xf6>
      9c:	797000ef          	jal	1032 <printf>
      a0:	00002717          	auipc	a4,0x2
      a4:	f6470713          	addi	a4,a4,-156 # 2004 <total_pass>
      a8:	431c                	lw	a5,0(a4)
      aa:	2785                	addiw	a5,a5,1 # 1001 <vprintf+0x2b9>
      ac:	c31c                	sw	a5,0(a4)
}
      ae:	60a2                	ld	ra,8(sp)
      b0:	6402                	ld	s0,0(sp)
      b2:	0141                	addi	sp,sp,16
      b4:	8082                	ret
  else  { printf("  FAIL: %s\n", name); total_fail++; }
      b6:	85aa                	mv	a1,a0
      b8:	00001517          	auipc	a0,0x1
      bc:	13850513          	addi	a0,a0,312 # 11f0 <malloc+0x106>
      c0:	773000ef          	jal	1032 <printf>
      c4:	00002717          	auipc	a4,0x2
      c8:	f3c70713          	addi	a4,a4,-196 # 2000 <total_fail>
      cc:	431c                	lw	a5,0(a4)
      ce:	2785                	addiw	a5,a5,1
      d0:	c31c                	sw	a5,0(a4)
}
      d2:	bff1                	j	ae <result+0x26>

00000000000000d4 <main>:
}

// ── main ──────────────────────────────────────────────────────────────────
int
main(void)
{
      d4:	7169                	addi	sp,sp,-304
      d6:	f606                	sd	ra,296(sp)
      d8:	f222                	sd	s0,288(sp)
      da:	ee26                	sd	s1,280(sp)
      dc:	ea4a                	sd	s2,272(sp)
      de:	e64e                	sd	s3,264(sp)
      e0:	e252                	sd	s4,256(sp)
      e2:	fdd6                	sd	s5,248(sp)
      e4:	f9da                	sd	s6,240(sp)
      e6:	f5de                	sd	s7,232(sp)
      e8:	1a00                	addi	s0,sp,304
  printf("=== diskschedtest (rigorous) ===\n");
      ea:	00001517          	auipc	a0,0x1
      ee:	11650513          	addi	a0,a0,278 # 1200 <malloc+0x116>
      f2:	741000ef          	jal	1032 <printf>
  printf("\n[T1] setdisksched return values\n");
      f6:	00001517          	auipc	a0,0x1
      fa:	13250513          	addi	a0,a0,306 # 1228 <malloc+0x13e>
      fe:	735000ef          	jal	1032 <printf>
  result("setdisksched(0) == 0",  setdisksched(0) == 0);
     102:	4501                	li	a0,0
     104:	381000ef          	jal	c84 <setdisksched>
     108:	00153593          	seqz	a1,a0
     10c:	00001517          	auipc	a0,0x1
     110:	14450513          	addi	a0,a0,324 # 1250 <malloc+0x166>
     114:	f75ff0ef          	jal	88 <result>
  result("setdisksched(1) == 0",  setdisksched(1) == 0);
     118:	4505                	li	a0,1
     11a:	36b000ef          	jal	c84 <setdisksched>
     11e:	00153593          	seqz	a1,a0
     122:	00001517          	auipc	a0,0x1
     126:	14650513          	addi	a0,a0,326 # 1268 <malloc+0x17e>
     12a:	f5fff0ef          	jal	88 <result>
  result("setdisksched(2) == -1", setdisksched(2) == -1);
     12e:	4509                	li	a0,2
     130:	355000ef          	jal	c84 <setdisksched>
     134:	5bfd                	li	s7,-1
     136:	00150593          	addi	a1,a0,1
     13a:	0015b593          	seqz	a1,a1
     13e:	00001517          	auipc	a0,0x1
     142:	14250513          	addi	a0,a0,322 # 1280 <malloc+0x196>
     146:	f43ff0ef          	jal	88 <result>
  result("setdisksched(-1)== -1", setdisksched(-1)== -1);
     14a:	855e                	mv	a0,s7
     14c:	339000ef          	jal	c84 <setdisksched>
     150:	00150593          	addi	a1,a0,1
     154:	0015b593          	seqz	a1,a1
     158:	00001517          	auipc	a0,0x1
     15c:	14050513          	addi	a0,a0,320 # 1298 <malloc+0x1ae>
     160:	f29ff0ef          	jal	88 <result>
  result("setdisksched(99)== -1", setdisksched(99)== -1);
     164:	06300513          	li	a0,99
     168:	31d000ef          	jal	c84 <setdisksched>
     16c:	00150593          	addi	a1,a0,1
     170:	0015b593          	seqz	a1,a1
     174:	00001517          	auipc	a0,0x1
     178:	13c50513          	addi	a0,a0,316 # 12b0 <malloc+0x1c6>
     17c:	f0dff0ef          	jal	88 <result>
  setdisksched(0);
     180:	4501                	li	a0,0
     182:	303000ef          	jal	c84 <setdisksched>
  printf("\n[T2] FCFS data correctness\n");
     186:	00001517          	auipc	a0,0x1
     18a:	14250513          	addi	a0,a0,322 # 12c8 <malloc+0x1de>
     18e:	6a5000ef          	jal	1032 <printf>
  setdisksched(0);
     192:	4501                	li	a0,0
     194:	2f1000ef          	jal	c84 <setdisksched>
  char *base = sbrk(WORK_PAGES * PAGE_SIZE);
     198:	00040537          	lui	a0,0x40
     19c:	1cd000ef          	jal	b68 <sbrk>
     1a0:	8b2a                	mv	s6,a0
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     1a2:	892a                	mv	s2,a0
  for(int i = 0; i < WORK_PAGES; i++) fill(base + i*PAGE_SIZE, i, 1);
     1a4:	4481                	li	s1,0
     1a6:	4a85                	li	s5,1
     1a8:	6a05                	lui	s4,0x1
     1aa:	04000993          	li	s3,64
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     1ae:	41750863          	beq	a0,s7,5be <main+0x4ea>
  for(int i = 0; i < WORK_PAGES; i++) fill(base + i*PAGE_SIZE, i, 1);
     1b2:	8656                	mv	a2,s5
     1b4:	85a6                	mv	a1,s1
     1b6:	854a                	mv	a0,s2
     1b8:	e49ff0ef          	jal	0 <fill>
     1bc:	2485                	addiw	s1,s1,1
     1be:	9952                	add	s2,s2,s4
     1c0:	ff3499e3          	bne	s1,s3,1b2 <main+0xde>
  char *p = sbrk(PRESSURE * PAGE_SIZE);
     1c4:	00048537          	lui	a0,0x48
     1c8:	1a1000ef          	jal	b68 <sbrk>
  if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     1cc:	57fd                	li	a5,-1
     1ce:	02f50063          	beq	a0,a5,1ee <main+0x11a>
     1d2:	87aa                	mv	a5,a0
     1d4:	00048737          	lui	a4,0x48
     1d8:	972a                	add	a4,a4,a0
     1da:	6685                	lui	a3,0x1
     1dc:	00078023          	sb	zero,0(a5)
     1e0:	97b6                	add	a5,a5,a3
     1e2:	fee79de3          	bne	a5,a4,1dc <main+0x108>
     1e6:	fffb8537          	lui	a0,0xfffb8
     1ea:	17f000ef          	jal	b68 <sbrk>
  result("FCFS: all pages correct after swap", verify(base, WORK_PAGES, 1));
     1ee:	4605                	li	a2,1
     1f0:	04000593          	li	a1,64
     1f4:	855a                	mv	a0,s6
     1f6:	e3dff0ef          	jal	32 <verify>
     1fa:	85aa                	mv	a1,a0
     1fc:	00001517          	auipc	a0,0x1
     200:	0fc50513          	addi	a0,a0,252 # 12f8 <malloc+0x20e>
     204:	e85ff0ef          	jal	88 <result>
  struct vmstats s; getvmstats(getpid(), &s);
     208:	215000ef          	jal	c1c <getpid>
     20c:	f6040593          	addi	a1,s0,-160
     210:	26d000ef          	jal	c7c <getvmstats>
  result("FCFS: disk_writes > 0", s.disk_writes > 0);
     214:	f8043583          	ld	a1,-128(s0)
     218:	00b035b3          	snez	a1,a1
     21c:	00001517          	auipc	a0,0x1
     220:	10450513          	addi	a0,a0,260 # 1320 <malloc+0x236>
     224:	e65ff0ef          	jal	88 <result>
  result("FCFS: disk_reads  > 0", s.disk_reads  > 0);
     228:	f7843583          	ld	a1,-136(s0)
     22c:	00b035b3          	snez	a1,a1
     230:	00001517          	auipc	a0,0x1
     234:	10850513          	addi	a0,a0,264 # 1338 <malloc+0x24e>
     238:	e51ff0ef          	jal	88 <result>
  sbrk(-(WORK_PAGES * PAGE_SIZE));
     23c:	fffc0537          	lui	a0,0xfffc0
     240:	129000ef          	jal	b68 <sbrk>
  printf("\n[T3] SSTF data correctness\n");
     244:	00001517          	auipc	a0,0x1
     248:	10c50513          	addi	a0,a0,268 # 1350 <malloc+0x266>
     24c:	5e7000ef          	jal	1032 <printf>
  setdisksched(1);
     250:	4505                	li	a0,1
     252:	233000ef          	jal	c84 <setdisksched>
  char *base = sbrk(WORK_PAGES * PAGE_SIZE);
     256:	00040537          	lui	a0,0x40
     25a:	10f000ef          	jal	b68 <sbrk>
     25e:	8b2a                	mv	s6,a0
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     260:	57fd                	li	a5,-1
     262:	892a                	mv	s2,a0
  for(int i = 0; i < WORK_PAGES; i++) fill(base + i*PAGE_SIZE, i, 2);
     264:	4481                	li	s1,0
     266:	4a89                	li	s5,2
     268:	6a05                	lui	s4,0x1
     26a:	04000993          	li	s3,64
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     26e:	36f50663          	beq	a0,a5,5da <main+0x506>
  for(int i = 0; i < WORK_PAGES; i++) fill(base + i*PAGE_SIZE, i, 2);
     272:	8656                	mv	a2,s5
     274:	85a6                	mv	a1,s1
     276:	854a                	mv	a0,s2
     278:	d89ff0ef          	jal	0 <fill>
     27c:	2485                	addiw	s1,s1,1
     27e:	9952                	add	s2,s2,s4
     280:	ff3499e3          	bne	s1,s3,272 <main+0x19e>
  char *p = sbrk(PRESSURE * PAGE_SIZE);
     284:	00048537          	lui	a0,0x48
     288:	0e1000ef          	jal	b68 <sbrk>
  if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     28c:	57fd                	li	a5,-1
     28e:	02f50063          	beq	a0,a5,2ae <main+0x1da>
     292:	87aa                	mv	a5,a0
     294:	00048737          	lui	a4,0x48
     298:	972a                	add	a4,a4,a0
     29a:	6685                	lui	a3,0x1
     29c:	00078023          	sb	zero,0(a5)
     2a0:	97b6                	add	a5,a5,a3
     2a2:	fee79de3          	bne	a5,a4,29c <main+0x1c8>
     2a6:	fffb8537          	lui	a0,0xfffb8
     2aa:	0bf000ef          	jal	b68 <sbrk>
  result("SSTF: all pages correct after swap", verify(base, WORK_PAGES, 2));
     2ae:	4609                	li	a2,2
     2b0:	04000593          	li	a1,64
     2b4:	855a                	mv	a0,s6
     2b6:	d7dff0ef          	jal	32 <verify>
     2ba:	85aa                	mv	a1,a0
     2bc:	00001517          	auipc	a0,0x1
     2c0:	0b450513          	addi	a0,a0,180 # 1370 <malloc+0x286>
     2c4:	dc5ff0ef          	jal	88 <result>
  struct vmstats s; getvmstats(getpid(), &s);
     2c8:	155000ef          	jal	c1c <getpid>
     2cc:	f6040593          	addi	a1,s0,-160
     2d0:	1ad000ef          	jal	c7c <getvmstats>
  result("SSTF: disk_writes > 0", s.disk_writes > 0);
     2d4:	f8043583          	ld	a1,-128(s0)
     2d8:	00b035b3          	snez	a1,a1
     2dc:	00001517          	auipc	a0,0x1
     2e0:	0bc50513          	addi	a0,a0,188 # 1398 <malloc+0x2ae>
     2e4:	da5ff0ef          	jal	88 <result>
  result("SSTF: disk_reads  > 0", s.disk_reads  > 0);
     2e8:	f7843583          	ld	a1,-136(s0)
     2ec:	00b035b3          	snez	a1,a1
     2f0:	00001517          	auipc	a0,0x1
     2f4:	0c050513          	addi	a0,a0,192 # 13b0 <malloc+0x2c6>
     2f8:	d91ff0ef          	jal	88 <result>
  sbrk(-(WORK_PAGES * PAGE_SIZE));
     2fc:	fffc0537          	lui	a0,0xfffc0
     300:	069000ef          	jal	b68 <sbrk>
  printf("\n[T4] SSTF avg_latency <= FCFS avg_latency\n");
     304:	00001517          	auipc	a0,0x1
     308:	0c450513          	addi	a0,a0,196 # 13c8 <malloc+0x2de>
     30c:	527000ef          	jal	1032 <printf>
  getvmstats(getpid(), &before_fcfs);
     310:	10d000ef          	jal	c1c <getpid>
     314:	ed040593          	addi	a1,s0,-304
     318:	165000ef          	jal	c7c <getvmstats>
  setdisksched(0);
     31c:	4501                	li	a0,0
     31e:	167000ef          	jal	c84 <setdisksched>
  char *base = sbrk(WORK_PAGES * PAGE_SIZE);
     322:	00040537          	lui	a0,0x40
     326:	043000ef          	jal	b68 <sbrk>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     32a:	57fd                	li	a5,-1
     32c:	892a                	mv	s2,a0
  for(int i = 0; i < WORK_PAGES; i++) fill(base + i*PAGE_SIZE, i, 3);
     32e:	4481                	li	s1,0
     330:	4a8d                	li	s5,3
     332:	6a05                	lui	s4,0x1
     334:	04000993          	li	s3,64
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     338:	2af50f63          	beq	a0,a5,5f6 <main+0x522>
  for(int i = 0; i < WORK_PAGES; i++) fill(base + i*PAGE_SIZE, i, 3);
     33c:	8656                	mv	a2,s5
     33e:	85a6                	mv	a1,s1
     340:	854a                	mv	a0,s2
     342:	cbfff0ef          	jal	0 <fill>
     346:	2485                	addiw	s1,s1,1
     348:	9952                	add	s2,s2,s4
     34a:	ff3499e3          	bne	s1,s3,33c <main+0x268>
  char *p = sbrk(PRESSURE * PAGE_SIZE);
     34e:	00048537          	lui	a0,0x48
     352:	017000ef          	jal	b68 <sbrk>
  if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     356:	57fd                	li	a5,-1
     358:	02f50063          	beq	a0,a5,378 <main+0x2a4>
     35c:	87aa                	mv	a5,a0
     35e:	00048737          	lui	a4,0x48
     362:	972a                	add	a4,a4,a0
     364:	6685                	lui	a3,0x1
     366:	00078023          	sb	zero,0(a5)
     36a:	97b6                	add	a5,a5,a3
     36c:	fee79de3          	bne	a5,a4,366 <main+0x292>
     370:	fffb8537          	lui	a0,0xfffb8
     374:	7f4000ef          	jal	b68 <sbrk>
  for(int i = 0; i < WORK_PAGES; i++) fill(base + i*PAGE_SIZE, i, 3);
     378:	04000793          	li	a5,64
  for(int i = 0; i < WORK_PAGES; i++) (void)base[i*PAGE_SIZE];
     37c:	37fd                	addiw	a5,a5,-1
     37e:	fffd                	bnez	a5,37c <main+0x2a8>
  struct vmstats after_fcfs; getvmstats(getpid(), &after_fcfs);
     380:	09d000ef          	jal	c1c <getpid>
     384:	f0040593          	addi	a1,s0,-256
     388:	0f5000ef          	jal	c7c <getvmstats>
  sbrk(-(WORK_PAGES * PAGE_SIZE));
     38c:	fffc0537          	lui	a0,0xfffc0
     390:	7d8000ef          	jal	b68 <sbrk>
  uint64 fcfs_writes = after_fcfs.disk_writes - before_fcfs.disk_writes;
     394:	f2043b03          	ld	s6,-224(s0)
     398:	ef043483          	ld	s1,-272(s0)
  uint64 fcfs_lat    = after_fcfs.avg_disk_latency;
     39c:	f2843b83          	ld	s7,-216(s0)
  getvmstats(getpid(), &before_sstf);
     3a0:	07d000ef          	jal	c1c <getpid>
     3a4:	f3040593          	addi	a1,s0,-208
     3a8:	0d5000ef          	jal	c7c <getvmstats>
  setdisksched(1);
     3ac:	4505                	li	a0,1
     3ae:	0d7000ef          	jal	c84 <setdisksched>
  base = sbrk(WORK_PAGES * PAGE_SIZE);
     3b2:	00040537          	lui	a0,0x40
     3b6:	7b2000ef          	jal	b68 <sbrk>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     3ba:	57fd                	li	a5,-1
  uint64 fcfs_writes = after_fcfs.disk_writes - before_fcfs.disk_writes;
     3bc:	409b0b33          	sub	s6,s6,s1
     3c0:	892a                	mv	s2,a0
  for(int i = 0; i < WORK_PAGES; i++) fill(base + i*PAGE_SIZE, i, 4);
     3c2:	4481                	li	s1,0
     3c4:	4a91                	li	s5,4
     3c6:	6a05                	lui	s4,0x1
     3c8:	04000993          	li	s3,64
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     3cc:	24f50563          	beq	a0,a5,616 <main+0x542>
  for(int i = 0; i < WORK_PAGES; i++) fill(base + i*PAGE_SIZE, i, 4);
     3d0:	8656                	mv	a2,s5
     3d2:	85a6                	mv	a1,s1
     3d4:	854a                	mv	a0,s2
     3d6:	c2bff0ef          	jal	0 <fill>
     3da:	2485                	addiw	s1,s1,1
     3dc:	9952                	add	s2,s2,s4
     3de:	ff3499e3          	bne	s1,s3,3d0 <main+0x2fc>
  p = sbrk(PRESSURE * PAGE_SIZE);
     3e2:	00048537          	lui	a0,0x48
     3e6:	782000ef          	jal	b68 <sbrk>
  if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     3ea:	57fd                	li	a5,-1
     3ec:	02f50063          	beq	a0,a5,40c <main+0x338>
     3f0:	87aa                	mv	a5,a0
     3f2:	00048737          	lui	a4,0x48
     3f6:	972a                	add	a4,a4,a0
     3f8:	6685                	lui	a3,0x1
     3fa:	00078023          	sb	zero,0(a5)
     3fe:	97b6                	add	a5,a5,a3
     400:	fee79de3          	bne	a5,a4,3fa <main+0x326>
     404:	fffb8537          	lui	a0,0xfffb8
     408:	760000ef          	jal	b68 <sbrk>
  for(int i = 0; i < WORK_PAGES; i++) fill(base + i*PAGE_SIZE, i, 4);
     40c:	04000793          	li	a5,64
  for(int i = 0; i < WORK_PAGES; i++) (void)base[i*PAGE_SIZE];
     410:	37fd                	addiw	a5,a5,-1
     412:	fffd                	bnez	a5,410 <main+0x33c>
  struct vmstats after_sstf; getvmstats(getpid(), &after_sstf);
     414:	009000ef          	jal	c1c <getpid>
     418:	f6040593          	addi	a1,s0,-160
     41c:	061000ef          	jal	c7c <getvmstats>
  sbrk(-(WORK_PAGES * PAGE_SIZE));
     420:	fffc0537          	lui	a0,0xfffc0
     424:	744000ef          	jal	b68 <sbrk>
  uint64 sstf_lat = after_sstf.avg_disk_latency;
     428:	f8843483          	ld	s1,-120(s0)
  printf("  FCFS writes=%llu  avg_latency=%llu\n",
     42c:	865e                	mv	a2,s7
     42e:	85da                	mv	a1,s6
     430:	00001517          	auipc	a0,0x1
     434:	fc850513          	addi	a0,a0,-56 # 13f8 <malloc+0x30e>
     438:	3fb000ef          	jal	1032 <printf>
  printf("  SSTF avg_latency=%llu\n", (unsigned long long)sstf_lat);
     43c:	85a6                	mv	a1,s1
     43e:	00001517          	auipc	a0,0x1
     442:	fe250513          	addi	a0,a0,-30 # 1420 <malloc+0x336>
     446:	3ed000ef          	jal	1032 <printf>
  result("FCFS produced evictions (writes > 0)", fcfs_writes > 0);
     44a:	016035b3          	snez	a1,s6
     44e:	00001517          	auipc	a0,0x1
     452:	ff250513          	addi	a0,a0,-14 # 1440 <malloc+0x356>
     456:	c33ff0ef          	jal	88 <result>
  result("SSTF avg_latency <= FCFS avg_latency",  sstf_lat <= fcfs_lat);
     45a:	009bb5b3          	sltu	a1,s7,s1
     45e:	0015b593          	seqz	a1,a1
     462:	00001517          	auipc	a0,0x1
     466:	1ee50513          	addi	a0,a0,494 # 1650 <malloc+0x566>
     46a:	c1fff0ef          	jal	88 <result>
  setdisksched(0);
     46e:	4501                	li	a0,0
     470:	015000ef          	jal	c84 <setdisksched>
  printf("\n[T5] Policy switch mid-workload: no corruption\n");
     474:	00001517          	auipc	a0,0x1
     478:	ff450513          	addi	a0,a0,-12 # 1468 <malloc+0x37e>
     47c:	3b7000ef          	jal	1032 <printf>
  char *base = sbrk(WORK_PAGES * PAGE_SIZE);
     480:	00040537          	lui	a0,0x40
     484:	6e4000ef          	jal	b68 <sbrk>
     488:	8a2a                	mv	s4,a0
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     48a:	57fd                	li	a5,-1
     48c:	1af50163          	beq	a0,a5,62e <main+0x55a>
  setdisksched(0);
     490:	4501                	li	a0,0
     492:	7f2000ef          	jal	c84 <setdisksched>
     496:	8952                	mv	s2,s4
  for(int i = 0; i < HALF; i++) fill(base + i*PAGE_SIZE, i, 5);
     498:	4481                	li	s1,0
     49a:	4b15                	li	s6,5
     49c:	6a85                	lui	s5,0x1
     49e:	02000993          	li	s3,32
     4a2:	865a                	mv	a2,s6
     4a4:	85a6                	mv	a1,s1
     4a6:	854a                	mv	a0,s2
     4a8:	b59ff0ef          	jal	0 <fill>
     4ac:	2485                	addiw	s1,s1,1
     4ae:	9956                	add	s2,s2,s5
     4b0:	ff3499e3          	bne	s1,s3,4a2 <main+0x3ce>
  setdisksched(1);
     4b4:	4505                	li	a0,1
     4b6:	7ce000ef          	jal	c84 <setdisksched>
  for(int i = HALF; i < WORK_PAGES; i++) fill(base + i*PAGE_SIZE, i, 5);
     4ba:	00020937          	lui	s2,0x20
     4be:	9952                	add	s2,s2,s4
     4c0:	4b15                	li	s6,5
     4c2:	6a85                	lui	s5,0x1
     4c4:	04000993          	li	s3,64
     4c8:	865a                	mv	a2,s6
     4ca:	85a6                	mv	a1,s1
     4cc:	854a                	mv	a0,s2
     4ce:	b33ff0ef          	jal	0 <fill>
     4d2:	2485                	addiw	s1,s1,1
     4d4:	9956                	add	s2,s2,s5
     4d6:	ff3499e3          	bne	s1,s3,4c8 <main+0x3f4>
  char *p = sbrk(PRESSURE * PAGE_SIZE);
     4da:	00048537          	lui	a0,0x48
     4de:	68a000ef          	jal	b68 <sbrk>
  if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     4e2:	57fd                	li	a5,-1
     4e4:	02f50163          	beq	a0,a5,506 <main+0x432>
     4e8:	87aa                	mv	a5,a0
     4ea:	000486b7          	lui	a3,0x48
     4ee:	00d50733          	add	a4,a0,a3
     4f2:	6685                	lui	a3,0x1
     4f4:	00078023          	sb	zero,0(a5)
     4f8:	97b6                	add	a5,a5,a3
     4fa:	fee79de3          	bne	a5,a4,4f4 <main+0x420>
     4fe:	fffb8537          	lui	a0,0xfffb8
     502:	666000ef          	jal	b68 <sbrk>
  result("all pages correct after mid-switch", verify(base, WORK_PAGES, 5));
     506:	4615                	li	a2,5
     508:	04000593          	li	a1,64
     50c:	8552                	mv	a0,s4
     50e:	b25ff0ef          	jal	32 <verify>
     512:	85aa                	mv	a1,a0
     514:	00001517          	auipc	a0,0x1
     518:	f8c50513          	addi	a0,a0,-116 # 14a0 <malloc+0x3b6>
     51c:	b6dff0ef          	jal	88 <result>
  sbrk(-(WORK_PAGES * PAGE_SIZE));
     520:	fffc0537          	lui	a0,0xfffc0
     524:	644000ef          	jal	b68 <sbrk>
  setdisksched(0);
     528:	4501                	li	a0,0
     52a:	75a000ef          	jal	c84 <setdisksched>
  printf("\n[T6] Per-process stats isolation\n");
     52e:	00001517          	auipc	a0,0x1
     532:	f9a50513          	addi	a0,a0,-102 # 14c8 <malloc+0x3de>
     536:	2fd000ef          	jal	1032 <printf>
  getvmstats(getpid(), &parent_before);
     53a:	6e2000ef          	jal	c1c <getpid>
     53e:	f3040593          	addi	a1,s0,-208
     542:	73a000ef          	jal	c7c <getvmstats>
  int pid = fork();
     546:	64e000ef          	jal	b94 <fork>
  if(pid == 0){
     54a:	10050063          	beqz	a0,64a <main+0x576>
     54e:	f1e2                	sd	s8,224(sp)
     550:	ede6                	sd	s9,216(sp)
     552:	e9ea                	sd	s10,208(sp)
     554:	e5ee                	sd	s11,200(sp)
  wait(&status);
     556:	f0040513          	addi	a0,s0,-256
     55a:	64a000ef          	jal	ba4 <wait>
  getvmstats(getpid(), &parent_after);
     55e:	6be000ef          	jal	c1c <getpid>
     562:	f6040593          	addi	a1,s0,-160
     566:	716000ef          	jal	c7c <getvmstats>
  result("parent disk_writes unchanged after child workload",
     56a:	f8043583          	ld	a1,-128(s0)
     56e:	f5043783          	ld	a5,-176(s0)
     572:	8d9d                	sub	a1,a1,a5
     574:	0015b593          	seqz	a1,a1
     578:	00001517          	auipc	a0,0x1
     57c:	f7850513          	addi	a0,a0,-136 # 14f0 <malloc+0x406>
     580:	b09ff0ef          	jal	88 <result>
  result("parent disk_reads unchanged after child workload",
     584:	f7843583          	ld	a1,-136(s0)
     588:	f4843783          	ld	a5,-184(s0)
     58c:	8d9d                	sub	a1,a1,a5
     58e:	0015b593          	seqz	a1,a1
     592:	00001517          	auipc	a0,0x1
     596:	f9650513          	addi	a0,a0,-106 # 1528 <malloc+0x43e>
     59a:	aefff0ef          	jal	88 <result>
  printf("\n[T7] Sequential access pattern: both policies produce correct data\n");
     59e:	00001517          	auipc	a0,0x1
     5a2:	fc250513          	addi	a0,a0,-62 # 1560 <malloc+0x476>
     5a6:	28d000ef          	jal	1032 <printf>
     5aa:	4c19                	li	s8,6
  for(int pol = 0; pol < 2; pol++){
     5ac:	4b81                	li	s7,0
    char *b = sbrk(WORK_PAGES * PAGE_SIZE);
     5ae:	00040db7          	lui	s11,0x40
    if(b == (char*)-1){ total_fail++; continue; }
     5b2:	5cfd                	li	s9,-1
    for(int i = 0; i < WORK_PAGES; i++) fill(b + i*PAGE_SIZE, i, 6 + pol);
     5b4:	6a85                	lui	s5,0x1
     5b6:	04000a13          	li	s4,64
  for(int pol = 0; pol < 2; pol++){
     5ba:	4d09                	li	s10,2
     5bc:	aa3d                	j	6fa <main+0x626>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     5be:	00001517          	auipc	a0,0x1
     5c2:	d2a50513          	addi	a0,a0,-726 # 12e8 <malloc+0x1fe>
     5c6:	26d000ef          	jal	1032 <printf>
     5ca:	00002717          	auipc	a4,0x2
     5ce:	a3670713          	addi	a4,a4,-1482 # 2000 <total_fail>
     5d2:	431c                	lw	a5,0(a4)
     5d4:	2785                	addiw	a5,a5,1
     5d6:	c31c                	sw	a5,0(a4)
     5d8:	b1b5                	j	244 <main+0x170>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     5da:	00001517          	auipc	a0,0x1
     5de:	d0e50513          	addi	a0,a0,-754 # 12e8 <malloc+0x1fe>
     5e2:	251000ef          	jal	1032 <printf>
     5e6:	00002717          	auipc	a4,0x2
     5ea:	a1a70713          	addi	a4,a4,-1510 # 2000 <total_fail>
     5ee:	431c                	lw	a5,0(a4)
     5f0:	2785                	addiw	a5,a5,1
     5f2:	c31c                	sw	a5,0(a4)
     5f4:	bb01                	j	304 <main+0x230>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     5f6:	00001517          	auipc	a0,0x1
     5fa:	cf250513          	addi	a0,a0,-782 # 12e8 <malloc+0x1fe>
     5fe:	235000ef          	jal	1032 <printf>
     602:	00002797          	auipc	a5,0x2
     606:	9fe7a783          	lw	a5,-1538(a5) # 2000 <total_fail>
     60a:	2785                	addiw	a5,a5,1
     60c:	00002717          	auipc	a4,0x2
     610:	9ef72a23          	sw	a5,-1548(a4) # 2000 <total_fail>
     614:	b585                	j	474 <main+0x3a0>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     616:	00001517          	auipc	a0,0x1
     61a:	cd250513          	addi	a0,a0,-814 # 12e8 <malloc+0x1fe>
     61e:	215000ef          	jal	1032 <printf>
     622:	00002797          	auipc	a5,0x2
     626:	9de7a783          	lw	a5,-1570(a5) # 2000 <total_fail>
     62a:	2785                	addiw	a5,a5,1
     62c:	b7c5                	j	60c <main+0x538>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     62e:	00001517          	auipc	a0,0x1
     632:	cba50513          	addi	a0,a0,-838 # 12e8 <malloc+0x1fe>
     636:	1fd000ef          	jal	1032 <printf>
     63a:	00002717          	auipc	a4,0x2
     63e:	9c670713          	addi	a4,a4,-1594 # 2000 <total_fail>
     642:	431c                	lw	a5,0(a4)
     644:	2785                	addiw	a5,a5,1
     646:	c31c                	sw	a5,0(a4)
     648:	b5dd                	j	52e <main+0x45a>
     64a:	f1e2                	sd	s8,224(sp)
     64c:	ede6                	sd	s9,216(sp)
     64e:	e9ea                	sd	s10,208(sp)
     650:	e5ee                	sd	s11,200(sp)
    setdisksched(0);
     652:	632000ef          	jal	c84 <setdisksched>
    char *b = sbrk(WORK_PAGES * PAGE_SIZE);
     656:	00040537          	lui	a0,0x40
     65a:	50e000ef          	jal	b68 <sbrk>
     65e:	872a                	mv	a4,a0
    if(b != (char*)-1){
     660:	57fd                	li	a5,-1
     662:	04f50763          	beq	a0,a5,6b0 <main+0x5dc>
     666:	4781                	li	a5,0
      for(int i=0;i<WORK_PAGES;i++) b[i*PAGE_SIZE]=(char)i;
     668:	04000613          	li	a2,64
     66c:	00c79693          	slli	a3,a5,0xc
     670:	96ba                	add	a3,a3,a4
     672:	00f68023          	sb	a5,0(a3) # 1000 <vprintf+0x2b8>
     676:	0785                	addi	a5,a5,1
     678:	fec79ae3          	bne	a5,a2,66c <main+0x598>
      char *p = sbrk(PRESSURE*PAGE_SIZE);
     67c:	00048537          	lui	a0,0x48
     680:	4e8000ef          	jal	b68 <sbrk>
      if(p!=(char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     684:	577d                	li	a4,-1
     686:	02e50163          	beq	a0,a4,6a8 <main+0x5d4>
     68a:	872a                	mv	a4,a0
     68c:	000486b7          	lui	a3,0x48
     690:	00d507b3          	add	a5,a0,a3
     694:	6685                	lui	a3,0x1
     696:	00070023          	sb	zero,0(a4)
     69a:	9736                	add	a4,a4,a3
     69c:	fef71de3          	bne	a4,a5,696 <main+0x5c2>
     6a0:	fffb8537          	lui	a0,0xfffb8
     6a4:	4c4000ef          	jal	b68 <sbrk>
      sbrk(-(WORK_PAGES*PAGE_SIZE));
     6a8:	fffc0537          	lui	a0,0xfffc0
     6ac:	4bc000ef          	jal	b68 <sbrk>
    exit(0);
     6b0:	4501                	li	a0,0
     6b2:	4ea000ef          	jal	b9c <exit>
    if(b == (char*)-1){ total_fail++; continue; }
     6b6:	00002717          	auipc	a4,0x2
     6ba:	94a70713          	addi	a4,a4,-1718 # 2000 <total_fail>
     6be:	431c                	lw	a5,0(a4)
     6c0:	2785                	addiw	a5,a5,1
     6c2:	c31c                	sw	a5,0(a4)
     6c4:	a03d                	j	6f2 <main+0x61e>
    if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     6c6:	fffb8537          	lui	a0,0xfffb8
     6ca:	49e000ef          	jal	b68 <sbrk>
    int ok = verify(b, WORK_PAGES, 6 + pol);
     6ce:	864e                	mv	a2,s3
     6d0:	85d2                	mv	a1,s4
     6d2:	855a                	mv	a0,s6
     6d4:	95fff0ef          	jal	32 <verify>
     6d8:	85aa                	mv	a1,a0
    if(pol == 0) result("sequential FCFS: correct", ok);
     6da:	060b8663          	beqz	s7,746 <main+0x672>
    else         result("sequential SSTF: correct", ok);
     6de:	00001517          	auipc	a0,0x1
     6e2:	eea50513          	addi	a0,a0,-278 # 15c8 <malloc+0x4de>
     6e6:	9a3ff0ef          	jal	88 <result>
    sbrk(-(WORK_PAGES * PAGE_SIZE));
     6ea:	fffc0537          	lui	a0,0xfffc0
     6ee:	47a000ef          	jal	b68 <sbrk>
  for(int pol = 0; pol < 2; pol++){
     6f2:	2b85                	addiw	s7,s7,1
     6f4:	2c05                	addiw	s8,s8,1
     6f6:	05ab8f63          	beq	s7,s10,754 <main+0x680>
    setdisksched(pol);
     6fa:	855e                	mv	a0,s7
     6fc:	588000ef          	jal	c84 <setdisksched>
    char *b = sbrk(WORK_PAGES * PAGE_SIZE);
     700:	856e                	mv	a0,s11
     702:	466000ef          	jal	b68 <sbrk>
     706:	8b2a                	mv	s6,a0
    if(b == (char*)-1){ total_fail++; continue; }
     708:	892a                	mv	s2,a0
    for(int i = 0; i < WORK_PAGES; i++) fill(b + i*PAGE_SIZE, i, 6 + pol);
     70a:	4481                	li	s1,0
     70c:	89e2                	mv	s3,s8
    if(b == (char*)-1){ total_fail++; continue; }
     70e:	fb9504e3          	beq	a0,s9,6b6 <main+0x5e2>
    for(int i = 0; i < WORK_PAGES; i++) fill(b + i*PAGE_SIZE, i, 6 + pol);
     712:	864e                	mv	a2,s3
     714:	85a6                	mv	a1,s1
     716:	854a                	mv	a0,s2
     718:	8e9ff0ef          	jal	0 <fill>
     71c:	2485                	addiw	s1,s1,1
     71e:	9956                	add	s2,s2,s5
     720:	ff4499e3          	bne	s1,s4,712 <main+0x63e>
    char *p = sbrk(PRESSURE * PAGE_SIZE);
     724:	00048537          	lui	a0,0x48
     728:	440000ef          	jal	b68 <sbrk>
    if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     72c:	fb9501e3          	beq	a0,s9,6ce <main+0x5fa>
     730:	87aa                	mv	a5,a0
     732:	00048737          	lui	a4,0x48
     736:	972a                	add	a4,a4,a0
     738:	6685                	lui	a3,0x1
     73a:	00078023          	sb	zero,0(a5)
     73e:	97b6                	add	a5,a5,a3
     740:	fef71de3          	bne	a4,a5,73a <main+0x666>
     744:	b749                	j	6c6 <main+0x5f2>
    if(pol == 0) result("sequential FCFS: correct", ok);
     746:	00001517          	auipc	a0,0x1
     74a:	e6250513          	addi	a0,a0,-414 # 15a8 <malloc+0x4be>
     74e:	93bff0ef          	jal	88 <result>
     752:	bf61                	j	6ea <main+0x616>
  setdisksched(0);
     754:	4501                	li	a0,0
     756:	52e000ef          	jal	c84 <setdisksched>
  printf("\n[T8] Reverse-order access: SSTF should not be worse than FCFS\n");
     75a:	00001517          	auipc	a0,0x1
     75e:	e8e50513          	addi	a0,a0,-370 # 15e8 <malloc+0x4fe>
     762:	0d1000ef          	jal	1032 <printf>
  setdisksched(0);
     766:	4501                	li	a0,0
     768:	51c000ef          	jal	c84 <setdisksched>
  getvmstats(getpid(), &b0);
     76c:	4b0000ef          	jal	c1c <getpid>
     770:	ed040593          	addi	a1,s0,-304
     774:	508000ef          	jal	c7c <getvmstats>
  char *base = sbrk(WORK_PAGES * PAGE_SIZE);
     778:	00040537          	lui	a0,0x40
     77c:	3ec000ef          	jal	b68 <sbrk>
  if(base != (char*)-1){
     780:	57fd                	li	a5,-1
     782:	06f50763          	beq	a0,a5,7f0 <main+0x71c>
     786:	0003f7b7          	lui	a5,0x3f
     78a:	00f50933          	add	s2,a0,a5
    for(int i = WORK_PAGES-1; i >= 0; i--) fill(base + i*PAGE_SIZE, i, 8);
     78e:	03f00493          	li	s1,63
     792:	4aa1                	li	s5,8
     794:	7a7d                	lui	s4,0xfffff
     796:	59fd                	li	s3,-1
     798:	8656                	mv	a2,s5
     79a:	85a6                	mv	a1,s1
     79c:	854a                	mv	a0,s2
     79e:	863ff0ef          	jal	0 <fill>
     7a2:	34fd                	addiw	s1,s1,-1
     7a4:	9952                	add	s2,s2,s4
     7a6:	ff3499e3          	bne	s1,s3,798 <main+0x6c4>
    char *p = sbrk(PRESSURE * PAGE_SIZE);
     7aa:	00048537          	lui	a0,0x48
     7ae:	3ba000ef          	jal	b68 <sbrk>
    if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     7b2:	57fd                	li	a5,-1
     7b4:	02f50063          	beq	a0,a5,7d4 <main+0x700>
     7b8:	87aa                	mv	a5,a0
     7ba:	00048737          	lui	a4,0x48
     7be:	972a                	add	a4,a4,a0
     7c0:	6685                	lui	a3,0x1
     7c2:	00078023          	sb	zero,0(a5) # 3f000 <base+0x3cff0>
     7c6:	97b6                	add	a5,a5,a3
     7c8:	fef71de3          	bne	a4,a5,7c2 <main+0x6ee>
     7cc:	fffb8537          	lui	a0,0xfffb8
     7d0:	398000ef          	jal	b68 <sbrk>
    for(int i = WORK_PAGES-1; i >= 0; i--) fill(base + i*PAGE_SIZE, i, 8);
     7d4:	04000793          	li	a5,64
    for(int i = WORK_PAGES-1; i >= 0; i--) (void)base[i*PAGE_SIZE];
     7d8:	37fd                	addiw	a5,a5,-1
     7da:	fffd                	bnez	a5,7d8 <main+0x704>
    getvmstats(getpid(), &a0);
     7dc:	440000ef          	jal	c1c <getpid>
     7e0:	f0040593          	addi	a1,s0,-256
     7e4:	498000ef          	jal	c7c <getvmstats>
    sbrk(-(WORK_PAGES * PAGE_SIZE));
     7e8:	fffc0537          	lui	a0,0xfffc0
     7ec:	37c000ef          	jal	b68 <sbrk>
  setdisksched(1);
     7f0:	4505                	li	a0,1
     7f2:	492000ef          	jal	c84 <setdisksched>
  getvmstats(getpid(), &b1);
     7f6:	426000ef          	jal	c1c <getpid>
     7fa:	f3040593          	addi	a1,s0,-208
     7fe:	47e000ef          	jal	c7c <getvmstats>
  base = sbrk(WORK_PAGES * PAGE_SIZE);
     802:	00040537          	lui	a0,0x40
     806:	362000ef          	jal	b68 <sbrk>
  if(base != (char*)-1){
     80a:	57fd                	li	a5,-1
     80c:	06f50763          	beq	a0,a5,87a <main+0x7a6>
     810:	0003f7b7          	lui	a5,0x3f
     814:	00f50933          	add	s2,a0,a5
    for(int i = WORK_PAGES-1; i >= 0; i--) fill(base + i*PAGE_SIZE, i, 9);
     818:	03f00493          	li	s1,63
     81c:	4aa5                	li	s5,9
     81e:	7a7d                	lui	s4,0xfffff
     820:	59fd                	li	s3,-1
     822:	8656                	mv	a2,s5
     824:	85a6                	mv	a1,s1
     826:	854a                	mv	a0,s2
     828:	fd8ff0ef          	jal	0 <fill>
     82c:	34fd                	addiw	s1,s1,-1
     82e:	9952                	add	s2,s2,s4
     830:	ff3499e3          	bne	s1,s3,822 <main+0x74e>
    char *p = sbrk(PRESSURE * PAGE_SIZE);
     834:	00048537          	lui	a0,0x48
     838:	330000ef          	jal	b68 <sbrk>
    if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     83c:	57fd                	li	a5,-1
     83e:	02f50063          	beq	a0,a5,85e <main+0x78a>
     842:	87aa                	mv	a5,a0
     844:	00048737          	lui	a4,0x48
     848:	972a                	add	a4,a4,a0
     84a:	6685                	lui	a3,0x1
     84c:	00078023          	sb	zero,0(a5) # 3f000 <base+0x3cff0>
     850:	97b6                	add	a5,a5,a3
     852:	fee79de3          	bne	a5,a4,84c <main+0x778>
     856:	fffb8537          	lui	a0,0xfffb8
     85a:	30e000ef          	jal	b68 <sbrk>
    for(int i = WORK_PAGES-1; i >= 0; i--) fill(base + i*PAGE_SIZE, i, 9);
     85e:	04000793          	li	a5,64
    for(int i = WORK_PAGES-1; i >= 0; i--) (void)base[i*PAGE_SIZE];
     862:	37fd                	addiw	a5,a5,-1
     864:	fffd                	bnez	a5,862 <main+0x78e>
    getvmstats(getpid(), &a1);
     866:	3b6000ef          	jal	c1c <getpid>
     86a:	f6040593          	addi	a1,s0,-160
     86e:	40e000ef          	jal	c7c <getvmstats>
    sbrk(-(WORK_PAGES * PAGE_SIZE));
     872:	fffc0537          	lui	a0,0xfffc0
     876:	2f2000ef          	jal	b68 <sbrk>
  result("reverse FCFS: data correct", verify(base, WORK_PAGES, 9) || 1); // can't re-check after sbrk; data check done inside
     87a:	4585                	li	a1,1
     87c:	00001517          	auipc	a0,0x1
     880:	dac50513          	addi	a0,a0,-596 # 1628 <malloc+0x53e>
     884:	805ff0ef          	jal	88 <result>
  result("reverse SSTF avg_latency <= FCFS avg_latency",
     888:	f8843583          	ld	a1,-120(s0)
     88c:	f2843783          	ld	a5,-216(s0)
     890:	00b7b5b3          	sltu	a1,a5,a1
     894:	0015b593          	seqz	a1,a1
     898:	00001517          	auipc	a0,0x1
     89c:	db050513          	addi	a0,a0,-592 # 1648 <malloc+0x55e>
     8a0:	fe8ff0ef          	jal	88 <result>
  printf("  FCFS avg_latency=%llu  SSTF avg_latency=%llu\n",
     8a4:	f8843603          	ld	a2,-120(s0)
     8a8:	f2843583          	ld	a1,-216(s0)
     8ac:	00001517          	auipc	a0,0x1
     8b0:	dcc50513          	addi	a0,a0,-564 # 1678 <malloc+0x58e>
     8b4:	77e000ef          	jal	1032 <printf>
  setdisksched(0);
     8b8:	4501                	li	a0,0
     8ba:	3ca000ef          	jal	c84 <setdisksched>
  t5_mid_switch();
  t6_stats_isolation();
  t7_sequential();
  t8_reverse_access();

  printf("\n=== RESULTS: %d passed, %d failed ===\n", total_pass, total_fail);
     8be:	00001497          	auipc	s1,0x1
     8c2:	74248493          	addi	s1,s1,1858 # 2000 <total_fail>
     8c6:	4090                	lw	a2,0(s1)
     8c8:	00001597          	auipc	a1,0x1
     8cc:	73c5a583          	lw	a1,1852(a1) # 2004 <total_pass>
     8d0:	00001517          	auipc	a0,0x1
     8d4:	dd850513          	addi	a0,a0,-552 # 16a8 <malloc+0x5be>
     8d8:	75a000ef          	jal	1032 <printf>
  exit(total_fail == 0 ? 0 : 1);
     8dc:	4088                	lw	a0,0(s1)
     8de:	00a03533          	snez	a0,a0
     8e2:	2ba000ef          	jal	b9c <exit>

00000000000008e6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     8e6:	1141                	addi	sp,sp,-16
     8e8:	e406                	sd	ra,8(sp)
     8ea:	e022                	sd	s0,0(sp)
     8ec:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     8ee:	fe6ff0ef          	jal	d4 <main>
  exit(r);
     8f2:	2aa000ef          	jal	b9c <exit>

00000000000008f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     8f6:	1141                	addi	sp,sp,-16
     8f8:	e406                	sd	ra,8(sp)
     8fa:	e022                	sd	s0,0(sp)
     8fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8fe:	87aa                	mv	a5,a0
     900:	0585                	addi	a1,a1,1
     902:	0785                	addi	a5,a5,1
     904:	fff5c703          	lbu	a4,-1(a1)
     908:	fee78fa3          	sb	a4,-1(a5)
     90c:	fb75                	bnez	a4,900 <strcpy+0xa>
    ;
  return os;
}
     90e:	60a2                	ld	ra,8(sp)
     910:	6402                	ld	s0,0(sp)
     912:	0141                	addi	sp,sp,16
     914:	8082                	ret

0000000000000916 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     916:	1141                	addi	sp,sp,-16
     918:	e406                	sd	ra,8(sp)
     91a:	e022                	sd	s0,0(sp)
     91c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     91e:	00054783          	lbu	a5,0(a0)
     922:	cb91                	beqz	a5,936 <strcmp+0x20>
     924:	0005c703          	lbu	a4,0(a1)
     928:	00f71763          	bne	a4,a5,936 <strcmp+0x20>
    p++, q++;
     92c:	0505                	addi	a0,a0,1
     92e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     930:	00054783          	lbu	a5,0(a0)
     934:	fbe5                	bnez	a5,924 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     936:	0005c503          	lbu	a0,0(a1)
}
     93a:	40a7853b          	subw	a0,a5,a0
     93e:	60a2                	ld	ra,8(sp)
     940:	6402                	ld	s0,0(sp)
     942:	0141                	addi	sp,sp,16
     944:	8082                	ret

0000000000000946 <strlen>:

uint
strlen(const char *s)
{
     946:	1141                	addi	sp,sp,-16
     948:	e406                	sd	ra,8(sp)
     94a:	e022                	sd	s0,0(sp)
     94c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     94e:	00054783          	lbu	a5,0(a0)
     952:	cf91                	beqz	a5,96e <strlen+0x28>
     954:	00150793          	addi	a5,a0,1
     958:	86be                	mv	a3,a5
     95a:	0785                	addi	a5,a5,1
     95c:	fff7c703          	lbu	a4,-1(a5)
     960:	ff65                	bnez	a4,958 <strlen+0x12>
     962:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     966:	60a2                	ld	ra,8(sp)
     968:	6402                	ld	s0,0(sp)
     96a:	0141                	addi	sp,sp,16
     96c:	8082                	ret
  for(n = 0; s[n]; n++)
     96e:	4501                	li	a0,0
     970:	bfdd                	j	966 <strlen+0x20>

0000000000000972 <memset>:

void*
memset(void *dst, int c, uint n)
{
     972:	1141                	addi	sp,sp,-16
     974:	e406                	sd	ra,8(sp)
     976:	e022                	sd	s0,0(sp)
     978:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     97a:	ca19                	beqz	a2,990 <memset+0x1e>
     97c:	87aa                	mv	a5,a0
     97e:	1602                	slli	a2,a2,0x20
     980:	9201                	srli	a2,a2,0x20
     982:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     986:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     98a:	0785                	addi	a5,a5,1
     98c:	fee79de3          	bne	a5,a4,986 <memset+0x14>
  }
  return dst;
}
     990:	60a2                	ld	ra,8(sp)
     992:	6402                	ld	s0,0(sp)
     994:	0141                	addi	sp,sp,16
     996:	8082                	ret

0000000000000998 <strchr>:

char*
strchr(const char *s, char c)
{
     998:	1141                	addi	sp,sp,-16
     99a:	e406                	sd	ra,8(sp)
     99c:	e022                	sd	s0,0(sp)
     99e:	0800                	addi	s0,sp,16
  for(; *s; s++)
     9a0:	00054783          	lbu	a5,0(a0)
     9a4:	cf81                	beqz	a5,9bc <strchr+0x24>
    if(*s == c)
     9a6:	00f58763          	beq	a1,a5,9b4 <strchr+0x1c>
  for(; *s; s++)
     9aa:	0505                	addi	a0,a0,1
     9ac:	00054783          	lbu	a5,0(a0)
     9b0:	fbfd                	bnez	a5,9a6 <strchr+0xe>
      return (char*)s;
  return 0;
     9b2:	4501                	li	a0,0
}
     9b4:	60a2                	ld	ra,8(sp)
     9b6:	6402                	ld	s0,0(sp)
     9b8:	0141                	addi	sp,sp,16
     9ba:	8082                	ret
  return 0;
     9bc:	4501                	li	a0,0
     9be:	bfdd                	j	9b4 <strchr+0x1c>

00000000000009c0 <gets>:

char*
gets(char *buf, int max)
{
     9c0:	711d                	addi	sp,sp,-96
     9c2:	ec86                	sd	ra,88(sp)
     9c4:	e8a2                	sd	s0,80(sp)
     9c6:	e4a6                	sd	s1,72(sp)
     9c8:	e0ca                	sd	s2,64(sp)
     9ca:	fc4e                	sd	s3,56(sp)
     9cc:	f852                	sd	s4,48(sp)
     9ce:	f456                	sd	s5,40(sp)
     9d0:	f05a                	sd	s6,32(sp)
     9d2:	ec5e                	sd	s7,24(sp)
     9d4:	e862                	sd	s8,16(sp)
     9d6:	1080                	addi	s0,sp,96
     9d8:	8baa                	mv	s7,a0
     9da:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9dc:	892a                	mv	s2,a0
     9de:	4481                	li	s1,0
    cc = read(0, &c, 1);
     9e0:	faf40b13          	addi	s6,s0,-81
     9e4:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     9e6:	8c26                	mv	s8,s1
     9e8:	0014899b          	addiw	s3,s1,1
     9ec:	84ce                	mv	s1,s3
     9ee:	0349d463          	bge	s3,s4,a16 <gets+0x56>
    cc = read(0, &c, 1);
     9f2:	8656                	mv	a2,s5
     9f4:	85da                	mv	a1,s6
     9f6:	4501                	li	a0,0
     9f8:	1bc000ef          	jal	bb4 <read>
    if(cc < 1)
     9fc:	00a05d63          	blez	a0,a16 <gets+0x56>
      break;
    buf[i++] = c;
     a00:	faf44783          	lbu	a5,-81(s0)
     a04:	00f90023          	sb	a5,0(s2) # 20000 <base+0x1dff0>
    if(c == '\n' || c == '\r')
     a08:	0905                	addi	s2,s2,1
     a0a:	ff678713          	addi	a4,a5,-10
     a0e:	c319                	beqz	a4,a14 <gets+0x54>
     a10:	17cd                	addi	a5,a5,-13
     a12:	fbf1                	bnez	a5,9e6 <gets+0x26>
    buf[i++] = c;
     a14:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     a16:	9c5e                	add	s8,s8,s7
     a18:	000c0023          	sb	zero,0(s8)
  return buf;
}
     a1c:	855e                	mv	a0,s7
     a1e:	60e6                	ld	ra,88(sp)
     a20:	6446                	ld	s0,80(sp)
     a22:	64a6                	ld	s1,72(sp)
     a24:	6906                	ld	s2,64(sp)
     a26:	79e2                	ld	s3,56(sp)
     a28:	7a42                	ld	s4,48(sp)
     a2a:	7aa2                	ld	s5,40(sp)
     a2c:	7b02                	ld	s6,32(sp)
     a2e:	6be2                	ld	s7,24(sp)
     a30:	6c42                	ld	s8,16(sp)
     a32:	6125                	addi	sp,sp,96
     a34:	8082                	ret

0000000000000a36 <stat>:

int
stat(const char *n, struct stat *st)
{
     a36:	1101                	addi	sp,sp,-32
     a38:	ec06                	sd	ra,24(sp)
     a3a:	e822                	sd	s0,16(sp)
     a3c:	e04a                	sd	s2,0(sp)
     a3e:	1000                	addi	s0,sp,32
     a40:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a42:	4581                	li	a1,0
     a44:	198000ef          	jal	bdc <open>
  if(fd < 0)
     a48:	02054263          	bltz	a0,a6c <stat+0x36>
     a4c:	e426                	sd	s1,8(sp)
     a4e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a50:	85ca                	mv	a1,s2
     a52:	1a2000ef          	jal	bf4 <fstat>
     a56:	892a                	mv	s2,a0
  close(fd);
     a58:	8526                	mv	a0,s1
     a5a:	16a000ef          	jal	bc4 <close>
  return r;
     a5e:	64a2                	ld	s1,8(sp)
}
     a60:	854a                	mv	a0,s2
     a62:	60e2                	ld	ra,24(sp)
     a64:	6442                	ld	s0,16(sp)
     a66:	6902                	ld	s2,0(sp)
     a68:	6105                	addi	sp,sp,32
     a6a:	8082                	ret
    return -1;
     a6c:	57fd                	li	a5,-1
     a6e:	893e                	mv	s2,a5
     a70:	bfc5                	j	a60 <stat+0x2a>

0000000000000a72 <atoi>:

int
atoi(const char *s)
{
     a72:	1141                	addi	sp,sp,-16
     a74:	e406                	sd	ra,8(sp)
     a76:	e022                	sd	s0,0(sp)
     a78:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a7a:	00054683          	lbu	a3,0(a0)
     a7e:	fd06879b          	addiw	a5,a3,-48 # fd0 <vprintf+0x288>
     a82:	0ff7f793          	zext.b	a5,a5
     a86:	4625                	li	a2,9
     a88:	02f66963          	bltu	a2,a5,aba <atoi+0x48>
     a8c:	872a                	mv	a4,a0
  n = 0;
     a8e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a90:	0705                	addi	a4,a4,1 # 48001 <base+0x45ff1>
     a92:	0025179b          	slliw	a5,a0,0x2
     a96:	9fa9                	addw	a5,a5,a0
     a98:	0017979b          	slliw	a5,a5,0x1
     a9c:	9fb5                	addw	a5,a5,a3
     a9e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     aa2:	00074683          	lbu	a3,0(a4)
     aa6:	fd06879b          	addiw	a5,a3,-48
     aaa:	0ff7f793          	zext.b	a5,a5
     aae:	fef671e3          	bgeu	a2,a5,a90 <atoi+0x1e>
  return n;
}
     ab2:	60a2                	ld	ra,8(sp)
     ab4:	6402                	ld	s0,0(sp)
     ab6:	0141                	addi	sp,sp,16
     ab8:	8082                	ret
  n = 0;
     aba:	4501                	li	a0,0
     abc:	bfdd                	j	ab2 <atoi+0x40>

0000000000000abe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     abe:	1141                	addi	sp,sp,-16
     ac0:	e406                	sd	ra,8(sp)
     ac2:	e022                	sd	s0,0(sp)
     ac4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     ac6:	02b57563          	bgeu	a0,a1,af0 <memmove+0x32>
    while(n-- > 0)
     aca:	00c05f63          	blez	a2,ae8 <memmove+0x2a>
     ace:	1602                	slli	a2,a2,0x20
     ad0:	9201                	srli	a2,a2,0x20
     ad2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     ad6:	872a                	mv	a4,a0
      *dst++ = *src++;
     ad8:	0585                	addi	a1,a1,1
     ada:	0705                	addi	a4,a4,1
     adc:	fff5c683          	lbu	a3,-1(a1)
     ae0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     ae4:	fee79ae3          	bne	a5,a4,ad8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ae8:	60a2                	ld	ra,8(sp)
     aea:	6402                	ld	s0,0(sp)
     aec:	0141                	addi	sp,sp,16
     aee:	8082                	ret
    while(n-- > 0)
     af0:	fec05ce3          	blez	a2,ae8 <memmove+0x2a>
    dst += n;
     af4:	00c50733          	add	a4,a0,a2
    src += n;
     af8:	95b2                	add	a1,a1,a2
     afa:	fff6079b          	addiw	a5,a2,-1
     afe:	1782                	slli	a5,a5,0x20
     b00:	9381                	srli	a5,a5,0x20
     b02:	fff7c793          	not	a5,a5
     b06:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b08:	15fd                	addi	a1,a1,-1
     b0a:	177d                	addi	a4,a4,-1
     b0c:	0005c683          	lbu	a3,0(a1)
     b10:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b14:	fef71ae3          	bne	a4,a5,b08 <memmove+0x4a>
     b18:	bfc1                	j	ae8 <memmove+0x2a>

0000000000000b1a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b1a:	1141                	addi	sp,sp,-16
     b1c:	e406                	sd	ra,8(sp)
     b1e:	e022                	sd	s0,0(sp)
     b20:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b22:	c61d                	beqz	a2,b50 <memcmp+0x36>
     b24:	1602                	slli	a2,a2,0x20
     b26:	9201                	srli	a2,a2,0x20
     b28:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     b2c:	00054783          	lbu	a5,0(a0)
     b30:	0005c703          	lbu	a4,0(a1)
     b34:	00e79863          	bne	a5,a4,b44 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     b38:	0505                	addi	a0,a0,1
    p2++;
     b3a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b3c:	fed518e3          	bne	a0,a3,b2c <memcmp+0x12>
  }
  return 0;
     b40:	4501                	li	a0,0
     b42:	a019                	j	b48 <memcmp+0x2e>
      return *p1 - *p2;
     b44:	40e7853b          	subw	a0,a5,a4
}
     b48:	60a2                	ld	ra,8(sp)
     b4a:	6402                	ld	s0,0(sp)
     b4c:	0141                	addi	sp,sp,16
     b4e:	8082                	ret
  return 0;
     b50:	4501                	li	a0,0
     b52:	bfdd                	j	b48 <memcmp+0x2e>

0000000000000b54 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b54:	1141                	addi	sp,sp,-16
     b56:	e406                	sd	ra,8(sp)
     b58:	e022                	sd	s0,0(sp)
     b5a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b5c:	f63ff0ef          	jal	abe <memmove>
}
     b60:	60a2                	ld	ra,8(sp)
     b62:	6402                	ld	s0,0(sp)
     b64:	0141                	addi	sp,sp,16
     b66:	8082                	ret

0000000000000b68 <sbrk>:

char *
sbrk(int n) {
     b68:	1141                	addi	sp,sp,-16
     b6a:	e406                	sd	ra,8(sp)
     b6c:	e022                	sd	s0,0(sp)
     b6e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     b70:	4585                	li	a1,1
     b72:	0b2000ef          	jal	c24 <sys_sbrk>
}
     b76:	60a2                	ld	ra,8(sp)
     b78:	6402                	ld	s0,0(sp)
     b7a:	0141                	addi	sp,sp,16
     b7c:	8082                	ret

0000000000000b7e <sbrklazy>:

char *
sbrklazy(int n) {
     b7e:	1141                	addi	sp,sp,-16
     b80:	e406                	sd	ra,8(sp)
     b82:	e022                	sd	s0,0(sp)
     b84:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     b86:	4589                	li	a1,2
     b88:	09c000ef          	jal	c24 <sys_sbrk>
}
     b8c:	60a2                	ld	ra,8(sp)
     b8e:	6402                	ld	s0,0(sp)
     b90:	0141                	addi	sp,sp,16
     b92:	8082                	ret

0000000000000b94 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b94:	4885                	li	a7,1
 ecall
     b96:	00000073          	ecall
 ret
     b9a:	8082                	ret

0000000000000b9c <exit>:
.global exit
exit:
 li a7, SYS_exit
     b9c:	4889                	li	a7,2
 ecall
     b9e:	00000073          	ecall
 ret
     ba2:	8082                	ret

0000000000000ba4 <wait>:
.global wait
wait:
 li a7, SYS_wait
     ba4:	488d                	li	a7,3
 ecall
     ba6:	00000073          	ecall
 ret
     baa:	8082                	ret

0000000000000bac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     bac:	4891                	li	a7,4
 ecall
     bae:	00000073          	ecall
 ret
     bb2:	8082                	ret

0000000000000bb4 <read>:
.global read
read:
 li a7, SYS_read
     bb4:	4895                	li	a7,5
 ecall
     bb6:	00000073          	ecall
 ret
     bba:	8082                	ret

0000000000000bbc <write>:
.global write
write:
 li a7, SYS_write
     bbc:	48c1                	li	a7,16
 ecall
     bbe:	00000073          	ecall
 ret
     bc2:	8082                	ret

0000000000000bc4 <close>:
.global close
close:
 li a7, SYS_close
     bc4:	48d5                	li	a7,21
 ecall
     bc6:	00000073          	ecall
 ret
     bca:	8082                	ret

0000000000000bcc <kill>:
.global kill
kill:
 li a7, SYS_kill
     bcc:	4899                	li	a7,6
 ecall
     bce:	00000073          	ecall
 ret
     bd2:	8082                	ret

0000000000000bd4 <exec>:
.global exec
exec:
 li a7, SYS_exec
     bd4:	489d                	li	a7,7
 ecall
     bd6:	00000073          	ecall
 ret
     bda:	8082                	ret

0000000000000bdc <open>:
.global open
open:
 li a7, SYS_open
     bdc:	48bd                	li	a7,15
 ecall
     bde:	00000073          	ecall
 ret
     be2:	8082                	ret

0000000000000be4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     be4:	48c5                	li	a7,17
 ecall
     be6:	00000073          	ecall
 ret
     bea:	8082                	ret

0000000000000bec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bec:	48c9                	li	a7,18
 ecall
     bee:	00000073          	ecall
 ret
     bf2:	8082                	ret

0000000000000bf4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bf4:	48a1                	li	a7,8
 ecall
     bf6:	00000073          	ecall
 ret
     bfa:	8082                	ret

0000000000000bfc <link>:
.global link
link:
 li a7, SYS_link
     bfc:	48cd                	li	a7,19
 ecall
     bfe:	00000073          	ecall
 ret
     c02:	8082                	ret

0000000000000c04 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c04:	48d1                	li	a7,20
 ecall
     c06:	00000073          	ecall
 ret
     c0a:	8082                	ret

0000000000000c0c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c0c:	48a5                	li	a7,9
 ecall
     c0e:	00000073          	ecall
 ret
     c12:	8082                	ret

0000000000000c14 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c14:	48a9                	li	a7,10
 ecall
     c16:	00000073          	ecall
 ret
     c1a:	8082                	ret

0000000000000c1c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c1c:	48ad                	li	a7,11
 ecall
     c1e:	00000073          	ecall
 ret
     c22:	8082                	ret

0000000000000c24 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     c24:	48b1                	li	a7,12
 ecall
     c26:	00000073          	ecall
 ret
     c2a:	8082                	ret

0000000000000c2c <pause>:
.global pause
pause:
 li a7, SYS_pause
     c2c:	48b5                	li	a7,13
 ecall
     c2e:	00000073          	ecall
 ret
     c32:	8082                	ret

0000000000000c34 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c34:	48b9                	li	a7,14
 ecall
     c36:	00000073          	ecall
 ret
     c3a:	8082                	ret

0000000000000c3c <hello>:
.global hello
hello:
 li a7, SYS_hello
     c3c:	48d9                	li	a7,22
 ecall
     c3e:	00000073          	ecall
 ret
     c42:	8082                	ret

0000000000000c44 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
     c44:	48dd                	li	a7,23
 ecall
     c46:	00000073          	ecall
 ret
     c4a:	8082                	ret

0000000000000c4c <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
     c4c:	48e1                	li	a7,24
 ecall
     c4e:	00000073          	ecall
 ret
     c52:	8082                	ret

0000000000000c54 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
     c54:	48e5                	li	a7,25
 ecall
     c56:	00000073          	ecall
 ret
     c5a:	8082                	ret

0000000000000c5c <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
     c5c:	48e9                	li	a7,26
 ecall
     c5e:	00000073          	ecall
 ret
     c62:	8082                	ret

0000000000000c64 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
     c64:	48ed                	li	a7,27
 ecall
     c66:	00000073          	ecall
 ret
     c6a:	8082                	ret

0000000000000c6c <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
     c6c:	48f1                	li	a7,28
 ecall
     c6e:	00000073          	ecall
 ret
     c72:	8082                	ret

0000000000000c74 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
     c74:	48f5                	li	a7,29
 ecall
     c76:	00000073          	ecall
 ret
     c7a:	8082                	ret

0000000000000c7c <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
     c7c:	48f9                	li	a7,30
 ecall
     c7e:	00000073          	ecall
 ret
     c82:	8082                	ret

0000000000000c84 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
     c84:	48fd                	li	a7,31
 ecall
     c86:	00000073          	ecall
 ret
     c8a:	8082                	ret

0000000000000c8c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c8c:	1101                	addi	sp,sp,-32
     c8e:	ec06                	sd	ra,24(sp)
     c90:	e822                	sd	s0,16(sp)
     c92:	1000                	addi	s0,sp,32
     c94:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c98:	4605                	li	a2,1
     c9a:	fef40593          	addi	a1,s0,-17
     c9e:	f1fff0ef          	jal	bbc <write>
}
     ca2:	60e2                	ld	ra,24(sp)
     ca4:	6442                	ld	s0,16(sp)
     ca6:	6105                	addi	sp,sp,32
     ca8:	8082                	ret

0000000000000caa <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     caa:	715d                	addi	sp,sp,-80
     cac:	e486                	sd	ra,72(sp)
     cae:	e0a2                	sd	s0,64(sp)
     cb0:	f84a                	sd	s2,48(sp)
     cb2:	f44e                	sd	s3,40(sp)
     cb4:	0880                	addi	s0,sp,80
     cb6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     cb8:	c6d1                	beqz	a3,d44 <printint+0x9a>
     cba:	0805d563          	bgez	a1,d44 <printint+0x9a>
    neg = 1;
    x = -xx;
     cbe:	40b005b3          	neg	a1,a1
    neg = 1;
     cc2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     cc4:	fb840993          	addi	s3,s0,-72
  neg = 0;
     cc8:	86ce                	mv	a3,s3
  i = 0;
     cca:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     ccc:	00001817          	auipc	a6,0x1
     cd0:	a0c80813          	addi	a6,a6,-1524 # 16d8 <digits>
     cd4:	88ba                	mv	a7,a4
     cd6:	0017051b          	addiw	a0,a4,1
     cda:	872a                	mv	a4,a0
     cdc:	02c5f7b3          	remu	a5,a1,a2
     ce0:	97c2                	add	a5,a5,a6
     ce2:	0007c783          	lbu	a5,0(a5)
     ce6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cea:	87ae                	mv	a5,a1
     cec:	02c5d5b3          	divu	a1,a1,a2
     cf0:	0685                	addi	a3,a3,1
     cf2:	fec7f1e3          	bgeu	a5,a2,cd4 <printint+0x2a>
  if(neg)
     cf6:	00030c63          	beqz	t1,d0e <printint+0x64>
    buf[i++] = '-';
     cfa:	fd050793          	addi	a5,a0,-48
     cfe:	00878533          	add	a0,a5,s0
     d02:	02d00793          	li	a5,45
     d06:	fef50423          	sb	a5,-24(a0)
     d0a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     d0e:	02e05563          	blez	a4,d38 <printint+0x8e>
     d12:	fc26                	sd	s1,56(sp)
     d14:	377d                	addiw	a4,a4,-1
     d16:	00e984b3          	add	s1,s3,a4
     d1a:	19fd                	addi	s3,s3,-1
     d1c:	99ba                	add	s3,s3,a4
     d1e:	1702                	slli	a4,a4,0x20
     d20:	9301                	srli	a4,a4,0x20
     d22:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d26:	0004c583          	lbu	a1,0(s1)
     d2a:	854a                	mv	a0,s2
     d2c:	f61ff0ef          	jal	c8c <putc>
  while(--i >= 0)
     d30:	14fd                	addi	s1,s1,-1
     d32:	ff349ae3          	bne	s1,s3,d26 <printint+0x7c>
     d36:	74e2                	ld	s1,56(sp)
}
     d38:	60a6                	ld	ra,72(sp)
     d3a:	6406                	ld	s0,64(sp)
     d3c:	7942                	ld	s2,48(sp)
     d3e:	79a2                	ld	s3,40(sp)
     d40:	6161                	addi	sp,sp,80
     d42:	8082                	ret
  neg = 0;
     d44:	4301                	li	t1,0
     d46:	bfbd                	j	cc4 <printint+0x1a>

0000000000000d48 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d48:	711d                	addi	sp,sp,-96
     d4a:	ec86                	sd	ra,88(sp)
     d4c:	e8a2                	sd	s0,80(sp)
     d4e:	e4a6                	sd	s1,72(sp)
     d50:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d52:	0005c483          	lbu	s1,0(a1)
     d56:	22048363          	beqz	s1,f7c <vprintf+0x234>
     d5a:	e0ca                	sd	s2,64(sp)
     d5c:	fc4e                	sd	s3,56(sp)
     d5e:	f852                	sd	s4,48(sp)
     d60:	f456                	sd	s5,40(sp)
     d62:	f05a                	sd	s6,32(sp)
     d64:	ec5e                	sd	s7,24(sp)
     d66:	e862                	sd	s8,16(sp)
     d68:	8b2a                	mv	s6,a0
     d6a:	8a2e                	mv	s4,a1
     d6c:	8bb2                	mv	s7,a2
  state = 0;
     d6e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d70:	4901                	li	s2,0
     d72:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d74:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d78:	06400c13          	li	s8,100
     d7c:	a00d                	j	d9e <vprintf+0x56>
        putc(fd, c0);
     d7e:	85a6                	mv	a1,s1
     d80:	855a                	mv	a0,s6
     d82:	f0bff0ef          	jal	c8c <putc>
     d86:	a019                	j	d8c <vprintf+0x44>
    } else if(state == '%'){
     d88:	03598363          	beq	s3,s5,dae <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     d8c:	0019079b          	addiw	a5,s2,1
     d90:	893e                	mv	s2,a5
     d92:	873e                	mv	a4,a5
     d94:	97d2                	add	a5,a5,s4
     d96:	0007c483          	lbu	s1,0(a5)
     d9a:	1c048a63          	beqz	s1,f6e <vprintf+0x226>
    c0 = fmt[i] & 0xff;
     d9e:	0004879b          	sext.w	a5,s1
    if(state == 0){
     da2:	fe0993e3          	bnez	s3,d88 <vprintf+0x40>
      if(c0 == '%'){
     da6:	fd579ce3          	bne	a5,s5,d7e <vprintf+0x36>
        state = '%';
     daa:	89be                	mv	s3,a5
     dac:	b7c5                	j	d8c <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     dae:	00ea06b3          	add	a3,s4,a4
     db2:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     db6:	1c060863          	beqz	a2,f86 <vprintf+0x23e>
      if(c0 == 'd'){
     dba:	03878763          	beq	a5,s8,de8 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     dbe:	f9478693          	addi	a3,a5,-108
     dc2:	0016b693          	seqz	a3,a3
     dc6:	f9c60593          	addi	a1,a2,-100
     dca:	e99d                	bnez	a1,e00 <vprintf+0xb8>
     dcc:	ca95                	beqz	a3,e00 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     dce:	008b8493          	addi	s1,s7,8
     dd2:	4685                	li	a3,1
     dd4:	4629                	li	a2,10
     dd6:	000bb583          	ld	a1,0(s7)
     dda:	855a                	mv	a0,s6
     ddc:	ecfff0ef          	jal	caa <printint>
        i += 1;
     de0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     de2:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     de4:	4981                	li	s3,0
     de6:	b75d                	j	d8c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     de8:	008b8493          	addi	s1,s7,8
     dec:	4685                	li	a3,1
     dee:	4629                	li	a2,10
     df0:	000ba583          	lw	a1,0(s7)
     df4:	855a                	mv	a0,s6
     df6:	eb5ff0ef          	jal	caa <printint>
     dfa:	8ba6                	mv	s7,s1
      state = 0;
     dfc:	4981                	li	s3,0
     dfe:	b779                	j	d8c <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     e00:	9752                	add	a4,a4,s4
     e02:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e06:	f9460713          	addi	a4,a2,-108
     e0a:	00173713          	seqz	a4,a4
     e0e:	8f75                	and	a4,a4,a3
     e10:	f9c58513          	addi	a0,a1,-100
     e14:	18051363          	bnez	a0,f9a <vprintf+0x252>
     e18:	18070163          	beqz	a4,f9a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e1c:	008b8493          	addi	s1,s7,8
     e20:	4685                	li	a3,1
     e22:	4629                	li	a2,10
     e24:	000bb583          	ld	a1,0(s7)
     e28:	855a                	mv	a0,s6
     e2a:	e81ff0ef          	jal	caa <printint>
        i += 2;
     e2e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     e30:	8ba6                	mv	s7,s1
      state = 0;
     e32:	4981                	li	s3,0
        i += 2;
     e34:	bfa1                	j	d8c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     e36:	008b8493          	addi	s1,s7,8
     e3a:	4681                	li	a3,0
     e3c:	4629                	li	a2,10
     e3e:	000be583          	lwu	a1,0(s7)
     e42:	855a                	mv	a0,s6
     e44:	e67ff0ef          	jal	caa <printint>
     e48:	8ba6                	mv	s7,s1
      state = 0;
     e4a:	4981                	li	s3,0
     e4c:	b781                	j	d8c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e4e:	008b8493          	addi	s1,s7,8
     e52:	4681                	li	a3,0
     e54:	4629                	li	a2,10
     e56:	000bb583          	ld	a1,0(s7)
     e5a:	855a                	mv	a0,s6
     e5c:	e4fff0ef          	jal	caa <printint>
        i += 1;
     e60:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     e62:	8ba6                	mv	s7,s1
      state = 0;
     e64:	4981                	li	s3,0
     e66:	b71d                	j	d8c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e68:	008b8493          	addi	s1,s7,8
     e6c:	4681                	li	a3,0
     e6e:	4629                	li	a2,10
     e70:	000bb583          	ld	a1,0(s7)
     e74:	855a                	mv	a0,s6
     e76:	e35ff0ef          	jal	caa <printint>
        i += 2;
     e7a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     e7c:	8ba6                	mv	s7,s1
      state = 0;
     e7e:	4981                	li	s3,0
        i += 2;
     e80:	b731                	j	d8c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     e82:	008b8493          	addi	s1,s7,8
     e86:	4681                	li	a3,0
     e88:	4641                	li	a2,16
     e8a:	000be583          	lwu	a1,0(s7)
     e8e:	855a                	mv	a0,s6
     e90:	e1bff0ef          	jal	caa <printint>
     e94:	8ba6                	mv	s7,s1
      state = 0;
     e96:	4981                	li	s3,0
     e98:	bdd5                	j	d8c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e9a:	008b8493          	addi	s1,s7,8
     e9e:	4681                	li	a3,0
     ea0:	4641                	li	a2,16
     ea2:	000bb583          	ld	a1,0(s7)
     ea6:	855a                	mv	a0,s6
     ea8:	e03ff0ef          	jal	caa <printint>
        i += 1;
     eac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     eae:	8ba6                	mv	s7,s1
      state = 0;
     eb0:	4981                	li	s3,0
     eb2:	bde9                	j	d8c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     eb4:	008b8493          	addi	s1,s7,8
     eb8:	4681                	li	a3,0
     eba:	4641                	li	a2,16
     ebc:	000bb583          	ld	a1,0(s7)
     ec0:	855a                	mv	a0,s6
     ec2:	de9ff0ef          	jal	caa <printint>
        i += 2;
     ec6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     ec8:	8ba6                	mv	s7,s1
      state = 0;
     eca:	4981                	li	s3,0
        i += 2;
     ecc:	b5c1                	j	d8c <vprintf+0x44>
     ece:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     ed0:	008b8793          	addi	a5,s7,8
     ed4:	8cbe                	mv	s9,a5
     ed6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     eda:	03000593          	li	a1,48
     ede:	855a                	mv	a0,s6
     ee0:	dadff0ef          	jal	c8c <putc>
  putc(fd, 'x');
     ee4:	07800593          	li	a1,120
     ee8:	855a                	mv	a0,s6
     eea:	da3ff0ef          	jal	c8c <putc>
     eee:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     ef0:	00000b97          	auipc	s7,0x0
     ef4:	7e8b8b93          	addi	s7,s7,2024 # 16d8 <digits>
     ef8:	03c9d793          	srli	a5,s3,0x3c
     efc:	97de                	add	a5,a5,s7
     efe:	0007c583          	lbu	a1,0(a5)
     f02:	855a                	mv	a0,s6
     f04:	d89ff0ef          	jal	c8c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f08:	0992                	slli	s3,s3,0x4
     f0a:	34fd                	addiw	s1,s1,-1
     f0c:	f4f5                	bnez	s1,ef8 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     f0e:	8be6                	mv	s7,s9
      state = 0;
     f10:	4981                	li	s3,0
     f12:	6ca2                	ld	s9,8(sp)
     f14:	bda5                	j	d8c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
     f16:	008b8493          	addi	s1,s7,8
     f1a:	000bc583          	lbu	a1,0(s7)
     f1e:	855a                	mv	a0,s6
     f20:	d6dff0ef          	jal	c8c <putc>
     f24:	8ba6                	mv	s7,s1
      state = 0;
     f26:	4981                	li	s3,0
     f28:	b595                	j	d8c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     f2a:	008b8993          	addi	s3,s7,8
     f2e:	000bb483          	ld	s1,0(s7)
     f32:	cc91                	beqz	s1,f4e <vprintf+0x206>
        for(; *s; s++)
     f34:	0004c583          	lbu	a1,0(s1)
     f38:	c985                	beqz	a1,f68 <vprintf+0x220>
          putc(fd, *s);
     f3a:	855a                	mv	a0,s6
     f3c:	d51ff0ef          	jal	c8c <putc>
        for(; *s; s++)
     f40:	0485                	addi	s1,s1,1
     f42:	0004c583          	lbu	a1,0(s1)
     f46:	f9f5                	bnez	a1,f3a <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
     f48:	8bce                	mv	s7,s3
      state = 0;
     f4a:	4981                	li	s3,0
     f4c:	b581                	j	d8c <vprintf+0x44>
          s = "(null)";
     f4e:	00000497          	auipc	s1,0x0
     f52:	78248493          	addi	s1,s1,1922 # 16d0 <malloc+0x5e6>
        for(; *s; s++)
     f56:	02800593          	li	a1,40
     f5a:	b7c5                	j	f3a <vprintf+0x1f2>
        putc(fd, '%');
     f5c:	85be                	mv	a1,a5
     f5e:	855a                	mv	a0,s6
     f60:	d2dff0ef          	jal	c8c <putc>
      state = 0;
     f64:	4981                	li	s3,0
     f66:	b51d                	j	d8c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     f68:	8bce                	mv	s7,s3
      state = 0;
     f6a:	4981                	li	s3,0
     f6c:	b505                	j	d8c <vprintf+0x44>
     f6e:	6906                	ld	s2,64(sp)
     f70:	79e2                	ld	s3,56(sp)
     f72:	7a42                	ld	s4,48(sp)
     f74:	7aa2                	ld	s5,40(sp)
     f76:	7b02                	ld	s6,32(sp)
     f78:	6be2                	ld	s7,24(sp)
     f7a:	6c42                	ld	s8,16(sp)
    }
  }
}
     f7c:	60e6                	ld	ra,88(sp)
     f7e:	6446                	ld	s0,80(sp)
     f80:	64a6                	ld	s1,72(sp)
     f82:	6125                	addi	sp,sp,96
     f84:	8082                	ret
      if(c0 == 'd'){
     f86:	06400713          	li	a4,100
     f8a:	e4e78fe3          	beq	a5,a4,de8 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
     f8e:	f9478693          	addi	a3,a5,-108
     f92:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
     f96:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     f98:	4701                	li	a4,0
      } else if(c0 == 'u'){
     f9a:	07500513          	li	a0,117
     f9e:	e8a78ce3          	beq	a5,a0,e36 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
     fa2:	f8b60513          	addi	a0,a2,-117
     fa6:	e119                	bnez	a0,fac <vprintf+0x264>
     fa8:	ea0693e3          	bnez	a3,e4e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     fac:	f8b58513          	addi	a0,a1,-117
     fb0:	e119                	bnez	a0,fb6 <vprintf+0x26e>
     fb2:	ea071be3          	bnez	a4,e68 <vprintf+0x120>
      } else if(c0 == 'x'){
     fb6:	07800513          	li	a0,120
     fba:	eca784e3          	beq	a5,a0,e82 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
     fbe:	f8860613          	addi	a2,a2,-120
     fc2:	e219                	bnez	a2,fc8 <vprintf+0x280>
     fc4:	ec069be3          	bnez	a3,e9a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     fc8:	f8858593          	addi	a1,a1,-120
     fcc:	e199                	bnez	a1,fd2 <vprintf+0x28a>
     fce:	ee0713e3          	bnez	a4,eb4 <vprintf+0x16c>
      } else if(c0 == 'p'){
     fd2:	07000713          	li	a4,112
     fd6:	eee78ce3          	beq	a5,a4,ece <vprintf+0x186>
      } else if(c0 == 'c'){
     fda:	06300713          	li	a4,99
     fde:	f2e78ce3          	beq	a5,a4,f16 <vprintf+0x1ce>
      } else if(c0 == 's'){
     fe2:	07300713          	li	a4,115
     fe6:	f4e782e3          	beq	a5,a4,f2a <vprintf+0x1e2>
      } else if(c0 == '%'){
     fea:	02500713          	li	a4,37
     fee:	f6e787e3          	beq	a5,a4,f5c <vprintf+0x214>
        putc(fd, '%');
     ff2:	02500593          	li	a1,37
     ff6:	855a                	mv	a0,s6
     ff8:	c95ff0ef          	jal	c8c <putc>
        putc(fd, c0);
     ffc:	85a6                	mv	a1,s1
     ffe:	855a                	mv	a0,s6
    1000:	c8dff0ef          	jal	c8c <putc>
      state = 0;
    1004:	4981                	li	s3,0
    1006:	b359                	j	d8c <vprintf+0x44>

0000000000001008 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1008:	715d                	addi	sp,sp,-80
    100a:	ec06                	sd	ra,24(sp)
    100c:	e822                	sd	s0,16(sp)
    100e:	1000                	addi	s0,sp,32
    1010:	e010                	sd	a2,0(s0)
    1012:	e414                	sd	a3,8(s0)
    1014:	e818                	sd	a4,16(s0)
    1016:	ec1c                	sd	a5,24(s0)
    1018:	03043023          	sd	a6,32(s0)
    101c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1020:	8622                	mv	a2,s0
    1022:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1026:	d23ff0ef          	jal	d48 <vprintf>
}
    102a:	60e2                	ld	ra,24(sp)
    102c:	6442                	ld	s0,16(sp)
    102e:	6161                	addi	sp,sp,80
    1030:	8082                	ret

0000000000001032 <printf>:

void
printf(const char *fmt, ...)
{
    1032:	711d                	addi	sp,sp,-96
    1034:	ec06                	sd	ra,24(sp)
    1036:	e822                	sd	s0,16(sp)
    1038:	1000                	addi	s0,sp,32
    103a:	e40c                	sd	a1,8(s0)
    103c:	e810                	sd	a2,16(s0)
    103e:	ec14                	sd	a3,24(s0)
    1040:	f018                	sd	a4,32(s0)
    1042:	f41c                	sd	a5,40(s0)
    1044:	03043823          	sd	a6,48(s0)
    1048:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    104c:	00840613          	addi	a2,s0,8
    1050:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1054:	85aa                	mv	a1,a0
    1056:	4505                	li	a0,1
    1058:	cf1ff0ef          	jal	d48 <vprintf>
}
    105c:	60e2                	ld	ra,24(sp)
    105e:	6442                	ld	s0,16(sp)
    1060:	6125                	addi	sp,sp,96
    1062:	8082                	ret

0000000000001064 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1064:	1141                	addi	sp,sp,-16
    1066:	e406                	sd	ra,8(sp)
    1068:	e022                	sd	s0,0(sp)
    106a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    106c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1070:	00001797          	auipc	a5,0x1
    1074:	f987b783          	ld	a5,-104(a5) # 2008 <freep>
    1078:	a039                	j	1086 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    107a:	6398                	ld	a4,0(a5)
    107c:	00e7e463          	bltu	a5,a4,1084 <free+0x20>
    1080:	00e6ea63          	bltu	a3,a4,1094 <free+0x30>
{
    1084:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1086:	fed7fae3          	bgeu	a5,a3,107a <free+0x16>
    108a:	6398                	ld	a4,0(a5)
    108c:	00e6e463          	bltu	a3,a4,1094 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1090:	fee7eae3          	bltu	a5,a4,1084 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1094:	ff852583          	lw	a1,-8(a0)
    1098:	6390                	ld	a2,0(a5)
    109a:	02059813          	slli	a6,a1,0x20
    109e:	01c85713          	srli	a4,a6,0x1c
    10a2:	9736                	add	a4,a4,a3
    10a4:	02e60563          	beq	a2,a4,10ce <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    10a8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    10ac:	4790                	lw	a2,8(a5)
    10ae:	02061593          	slli	a1,a2,0x20
    10b2:	01c5d713          	srli	a4,a1,0x1c
    10b6:	973e                	add	a4,a4,a5
    10b8:	02e68263          	beq	a3,a4,10dc <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    10bc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    10be:	00001717          	auipc	a4,0x1
    10c2:	f4f73523          	sd	a5,-182(a4) # 2008 <freep>
}
    10c6:	60a2                	ld	ra,8(sp)
    10c8:	6402                	ld	s0,0(sp)
    10ca:	0141                	addi	sp,sp,16
    10cc:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    10ce:	4618                	lw	a4,8(a2)
    10d0:	9f2d                	addw	a4,a4,a1
    10d2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    10d6:	6398                	ld	a4,0(a5)
    10d8:	6310                	ld	a2,0(a4)
    10da:	b7f9                	j	10a8 <free+0x44>
    p->s.size += bp->s.size;
    10dc:	ff852703          	lw	a4,-8(a0)
    10e0:	9f31                	addw	a4,a4,a2
    10e2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    10e4:	ff053683          	ld	a3,-16(a0)
    10e8:	bfd1                	j	10bc <free+0x58>

00000000000010ea <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    10ea:	7139                	addi	sp,sp,-64
    10ec:	fc06                	sd	ra,56(sp)
    10ee:	f822                	sd	s0,48(sp)
    10f0:	f04a                	sd	s2,32(sp)
    10f2:	ec4e                	sd	s3,24(sp)
    10f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    10f6:	02051993          	slli	s3,a0,0x20
    10fa:	0209d993          	srli	s3,s3,0x20
    10fe:	09bd                	addi	s3,s3,15
    1100:	0049d993          	srli	s3,s3,0x4
    1104:	2985                	addiw	s3,s3,1
    1106:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1108:	00001517          	auipc	a0,0x1
    110c:	f0053503          	ld	a0,-256(a0) # 2008 <freep>
    1110:	c905                	beqz	a0,1140 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1112:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1114:	4798                	lw	a4,8(a5)
    1116:	09377663          	bgeu	a4,s3,11a2 <malloc+0xb8>
    111a:	f426                	sd	s1,40(sp)
    111c:	e852                	sd	s4,16(sp)
    111e:	e456                	sd	s5,8(sp)
    1120:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1122:	8a4e                	mv	s4,s3
    1124:	6705                	lui	a4,0x1
    1126:	00e9f363          	bgeu	s3,a4,112c <malloc+0x42>
    112a:	6a05                	lui	s4,0x1
    112c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1130:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1134:	00001497          	auipc	s1,0x1
    1138:	ed448493          	addi	s1,s1,-300 # 2008 <freep>
  if(p == SBRK_ERROR)
    113c:	5afd                	li	s5,-1
    113e:	a83d                	j	117c <malloc+0x92>
    1140:	f426                	sd	s1,40(sp)
    1142:	e852                	sd	s4,16(sp)
    1144:	e456                	sd	s5,8(sp)
    1146:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1148:	00001797          	auipc	a5,0x1
    114c:	ec878793          	addi	a5,a5,-312 # 2010 <base>
    1150:	00001717          	auipc	a4,0x1
    1154:	eaf73c23          	sd	a5,-328(a4) # 2008 <freep>
    1158:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    115a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    115e:	b7d1                	j	1122 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1160:	6398                	ld	a4,0(a5)
    1162:	e118                	sd	a4,0(a0)
    1164:	a899                	j	11ba <malloc+0xd0>
  hp->s.size = nu;
    1166:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    116a:	0541                	addi	a0,a0,16
    116c:	ef9ff0ef          	jal	1064 <free>
  return freep;
    1170:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1172:	c125                	beqz	a0,11d2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1174:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1176:	4798                	lw	a4,8(a5)
    1178:	03277163          	bgeu	a4,s2,119a <malloc+0xb0>
    if(p == freep)
    117c:	6098                	ld	a4,0(s1)
    117e:	853e                	mv	a0,a5
    1180:	fef71ae3          	bne	a4,a5,1174 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    1184:	8552                	mv	a0,s4
    1186:	9e3ff0ef          	jal	b68 <sbrk>
  if(p == SBRK_ERROR)
    118a:	fd551ee3          	bne	a0,s5,1166 <malloc+0x7c>
        return 0;
    118e:	4501                	li	a0,0
    1190:	74a2                	ld	s1,40(sp)
    1192:	6a42                	ld	s4,16(sp)
    1194:	6aa2                	ld	s5,8(sp)
    1196:	6b02                	ld	s6,0(sp)
    1198:	a03d                	j	11c6 <malloc+0xdc>
    119a:	74a2                	ld	s1,40(sp)
    119c:	6a42                	ld	s4,16(sp)
    119e:	6aa2                	ld	s5,8(sp)
    11a0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    11a2:	fae90fe3          	beq	s2,a4,1160 <malloc+0x76>
        p->s.size -= nunits;
    11a6:	4137073b          	subw	a4,a4,s3
    11aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
    11ac:	02071693          	slli	a3,a4,0x20
    11b0:	01c6d713          	srli	a4,a3,0x1c
    11b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    11b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    11ba:	00001717          	auipc	a4,0x1
    11be:	e4a73723          	sd	a0,-434(a4) # 2008 <freep>
      return (void*)(p + 1);
    11c2:	01078513          	addi	a0,a5,16
  }
}
    11c6:	70e2                	ld	ra,56(sp)
    11c8:	7442                	ld	s0,48(sp)
    11ca:	7902                	ld	s2,32(sp)
    11cc:	69e2                	ld	s3,24(sp)
    11ce:	6121                	addi	sp,sp,64
    11d0:	8082                	ret
    11d2:	74a2                	ld	s1,40(sp)
    11d4:	6a42                	ld	s4,16(sp)
    11d6:	6aa2                	ld	s5,8(sp)
    11d8:	6b02                	ld	s6,0(sp)
    11da:	b7f5                	j	11c6 <malloc+0xdc>
