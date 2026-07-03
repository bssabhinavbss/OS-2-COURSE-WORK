
user/_statstest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <result>:
static int total_pass = 0;
static int total_fail = 0;

static void
result(const char *name, int ok)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(ok){ printf("  PASS: %s\n", name); total_pass++; }
   8:	c19d                	beqz	a1,2e <result+0x2e>
   a:	85aa                	mv	a1,a0
   c:	00001517          	auipc	a0,0x1
  10:	fe450513          	addi	a0,a0,-28 # ff0 <malloc+0xf6>
  14:	62f000ef          	jal	e42 <printf>
  18:	00002717          	auipc	a4,0x2
  1c:	fec70713          	addi	a4,a4,-20 # 2004 <total_pass>
  20:	431c                	lw	a5,0(a4)
  22:	2785                	addiw	a5,a5,1
  24:	c31c                	sw	a5,0(a4)
  else  { printf("  FAIL: %s\n", name); total_fail++; }
}
  26:	60a2                	ld	ra,8(sp)
  28:	6402                	ld	s0,0(sp)
  2a:	0141                	addi	sp,sp,16
  2c:	8082                	ret
  else  { printf("  FAIL: %s\n", name); total_fail++; }
  2e:	85aa                	mv	a1,a0
  30:	00001517          	auipc	a0,0x1
  34:	fd050513          	addi	a0,a0,-48 # 1000 <malloc+0x106>
  38:	60b000ef          	jal	e42 <printf>
  3c:	00002717          	auipc	a4,0x2
  40:	fc470713          	addi	a4,a4,-60 # 2000 <total_fail>
  44:	431c                	lw	a5,0(a4)
  46:	2785                	addiw	a5,a5,1
  48:	c31c                	sw	a5,0(a4)
}
  4a:	bff1                	j	26 <result+0x26>

000000000000004c <run_workload>:
// perform a full evict+swapin workload under a given policy
// returns delta stats
static void
run_workload(int policy, int seed,
             struct vmstats *before_out, struct vmstats *after_out)
{
  4c:	7179                	addi	sp,sp,-48
  4e:	f406                	sd	ra,40(sp)
  50:	f022                	sd	s0,32(sp)
  52:	ec26                	sd	s1,24(sp)
  54:	e84a                	sd	s2,16(sp)
  56:	e44e                	sd	s3,8(sp)
  58:	1800                	addi	s0,sp,48
  5a:	84ae                	mv	s1,a1
  5c:	8932                	mv	s2,a2
  5e:	89b6                	mv	s3,a3
  setdisksched(policy);
  60:	235000ef          	jal	a94 <setdisksched>
  getvmstats(getpid(), before_out);
  64:	1c9000ef          	jal	a2c <getpid>
  68:	85ca                	mv	a1,s2
  6a:	223000ef          	jal	a8c <getvmstats>

  char *base = sbrk(WORK_PAGES * PAGE_SIZE);
  6e:	00040537          	lui	a0,0x40
  72:	107000ef          	jal	978 <sbrk>
  if(base == (char*)-1){ return; }
  76:	57fd                	li	a5,-1
  78:	08f50863          	beq	a0,a5,108 <run_workload+0xbc>
    p[j] = (char)((page * 23 + j * 9 + seed * 41) & 0xFF);
  7c:	0024961b          	slliw	a2,s1,0x2
  80:	9e25                	addw	a2,a2,s1
  82:	0036161b          	slliw	a2,a2,0x3
  86:	9e25                	addw	a2,a2,s1
  88:	0ff67613          	zext.b	a2,a2
  8c:	6685                	lui	a3,0x1
  8e:	96aa                	add	a3,a3,a0
  90:	000417b7          	lui	a5,0x41
  94:	00f505b3          	add	a1,a0,a5
  98:	787d                	lui	a6,0xfffff

  for(int i=0;i<WORK_PAGES;i++) fill(base+i*PAGE_SIZE,i,seed);
  9a:	6505                	lui	a0,0x1
  for(int j = 0; j < PAGE_SIZE; j++)
  9c:	01068733          	add	a4,a3,a6
{
  a0:	87b2                	mv	a5,a2
    p[j] = (char)((page * 23 + j * 9 + seed * 41) & 0xFF);
  a2:	00f70023          	sb	a5,0(a4)
  for(int j = 0; j < PAGE_SIZE; j++)
  a6:	27a5                	addiw	a5,a5,9 # 41009 <base+0x3eff9>
  a8:	0ff7f793          	zext.b	a5,a5
  ac:	0705                	addi	a4,a4,1
  ae:	fed71ae3          	bne	a4,a3,a2 <run_workload+0x56>
  for(int i=0;i<WORK_PAGES;i++) fill(base+i*PAGE_SIZE,i,seed);
  b2:	265d                	addiw	a2,a2,23
  b4:	0ff67613          	zext.b	a2,a2
  b8:	96aa                	add	a3,a3,a0
  ba:	feb691e3          	bne	a3,a1,9c <run_workload+0x50>

  char *p = sbrk(PRESSURE*PAGE_SIZE);
  be:	00048537          	lui	a0,0x48
  c2:	0b7000ef          	jal	978 <sbrk>
  c6:	872a                	mv	a4,a0
  if(p!=(char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=(char)(i^seed); sbrk(-(PRESSURE*PAGE_SIZE)); }
  c8:	57fd                	li	a5,-1
  ca:	02f50263          	beq	a0,a5,ee <run_workload+0xa2>
  ce:	4781                	li	a5,0
  d0:	6585                	lui	a1,0x1
  d2:	04800613          	li	a2,72
  d6:	0097c6b3          	xor	a3,a5,s1
  da:	00d70023          	sb	a3,0(a4)
  de:	2785                	addiw	a5,a5,1
  e0:	972e                	add	a4,a4,a1
  e2:	fec79ae3          	bne	a5,a2,d6 <run_workload+0x8a>
  e6:	fffb8537          	lui	a0,0xfffb8
  ea:	08f000ef          	jal	978 <sbrk>
  ee:	04000793          	li	a5,64

  // force swap-ins
  for(int i=0;i<WORK_PAGES;i++) (void)base[i*PAGE_SIZE];
  f2:	37fd                	addiw	a5,a5,-1
  f4:	fffd                	bnez	a5,f2 <run_workload+0xa6>

  getvmstats(getpid(), after_out);
  f6:	137000ef          	jal	a2c <getpid>
  fa:	85ce                	mv	a1,s3
  fc:	191000ef          	jal	a8c <getvmstats>
  sbrk(-(WORK_PAGES*PAGE_SIZE));
 100:	fffc0537          	lui	a0,0xfffc0
 104:	075000ef          	jal	978 <sbrk>
}
 108:	70a2                	ld	ra,40(sp)
 10a:	7402                	ld	s0,32(sp)
 10c:	64e2                	ld	s1,24(sp)
 10e:	6942                	ld	s2,16(sp)
 110:	69a2                	ld	s3,8(sp)
 112:	6145                	addi	sp,sp,48
 114:	8082                	ret

0000000000000116 <main>:
}

// ── main ──────────────────────────────────────────────────────────────────
int
main(void)
{
 116:	7165                	addi	sp,sp,-400
 118:	e706                	sd	ra,392(sp)
 11a:	e322                	sd	s0,384(sp)
 11c:	fea6                	sd	s1,376(sp)
 11e:	faca                	sd	s2,368(sp)
 120:	f6ce                	sd	s3,360(sp)
 122:	f2d2                	sd	s4,352(sp)
 124:	eed6                	sd	s5,344(sp)
 126:	eada                	sd	s6,336(sp)
 128:	0b00                	addi	s0,sp,400
  printf("=== statstest (rigorous) ===\n");
 12a:	00001517          	auipc	a0,0x1
 12e:	ee650513          	addi	a0,a0,-282 # 1010 <malloc+0x116>
 132:	511000ef          	jal	e42 <printf>
  printf("\n[T1] Fresh process starts with zero disk stats\n");
 136:	00001517          	auipc	a0,0x1
 13a:	efa50513          	addi	a0,a0,-262 # 1030 <malloc+0x136>
 13e:	505000ef          	jal	e42 <printf>
  int ret = getvmstats(getpid(), &s);
 142:	0eb000ef          	jal	a2c <getpid>
 146:	f0040493          	addi	s1,s0,-256
 14a:	85a6                	mv	a1,s1
 14c:	141000ef          	jal	a8c <getvmstats>
  result("getvmstats returns 0 for own pid", ret == 0);
 150:	00153593          	seqz	a1,a0
 154:	00001517          	auipc	a0,0x1
 158:	f1450513          	addi	a0,a0,-236 # 1068 <malloc+0x16e>
 15c:	ea5ff0ef          	jal	0 <result>
  result("initial disk_reads == 0",       s.disk_reads  == 0);
 160:	f1843583          	ld	a1,-232(s0)
 164:	0015b593          	seqz	a1,a1
 168:	00001517          	auipc	a0,0x1
 16c:	f2850513          	addi	a0,a0,-216 # 1090 <malloc+0x196>
 170:	e91ff0ef          	jal	0 <result>
  result("initial disk_writes >= 0",      s.disk_writes >= 0);
 174:	4585                	li	a1,1
 176:	00001517          	auipc	a0,0x1
 17a:	f3250513          	addi	a0,a0,-206 # 10a8 <malloc+0x1ae>
 17e:	e83ff0ef          	jal	0 <result>
  result("initial avg_disk_latency >= 0", s.avg_disk_latency >= 0);
 182:	4585                	li	a1,1
 184:	00001517          	auipc	a0,0x1
 188:	f4450513          	addi	a0,a0,-188 # 10c8 <malloc+0x1ce>
 18c:	e75ff0ef          	jal	0 <result>
  printf("\n[T2] disk_writes > 0 after eviction workload\n");
 190:	00001517          	auipc	a0,0x1
 194:	f5850513          	addi	a0,a0,-168 # 10e8 <malloc+0x1ee>
 198:	4ab000ef          	jal	e42 <printf>
  run_workload(0, 1, &before, &after);
 19c:	ed040993          	addi	s3,s0,-304
 1a0:	86a6                	mv	a3,s1
 1a2:	864e                	mv	a2,s3
 1a4:	4585                	li	a1,1
 1a6:	4501                	li	a0,0
 1a8:	ea5ff0ef          	jal	4c <run_workload>
  uint64 dw = after.disk_writes - before.disk_writes;
 1ac:	f2043903          	ld	s2,-224(s0)
 1b0:	ef043783          	ld	a5,-272(s0)
 1b4:	40f90933          	sub	s2,s2,a5
  printf("  eviction disk_writes delta = %llu\n", (unsigned long long)dw);
 1b8:	85ca                	mv	a1,s2
 1ba:	00001517          	auipc	a0,0x1
 1be:	f5e50513          	addi	a0,a0,-162 # 1118 <malloc+0x21e>
 1c2:	481000ef          	jal	e42 <printf>
  result("disk_writes > 0",          dw > 0);
 1c6:	012035b3          	snez	a1,s2
 1ca:	00001517          	auipc	a0,0x1
 1ce:	f7650513          	addi	a0,a0,-138 # 1140 <malloc+0x246>
 1d2:	e2fff0ef          	jal	0 <result>
  result("disk_writes >= 32",        dw >= 32);  // at least WORK_PAGES - MAX_FRAMES
 1d6:	02093593          	sltiu	a1,s2,32
 1da:	0015b593          	seqz	a1,a1
 1de:	00001517          	auipc	a0,0x1
 1e2:	f7250513          	addi	a0,a0,-142 # 1150 <malloc+0x256>
 1e6:	e1bff0ef          	jal	0 <result>
  printf("\n[T3] disk_reads > 0 after swap-in workload\n");
 1ea:	00001517          	auipc	a0,0x1
 1ee:	f7e50513          	addi	a0,a0,-130 # 1168 <malloc+0x26e>
 1f2:	451000ef          	jal	e42 <printf>
  run_workload(0, 2, &before, &after);
 1f6:	86a6                	mv	a3,s1
 1f8:	864e                	mv	a2,s3
 1fa:	4589                	li	a1,2
 1fc:	4501                	li	a0,0
 1fe:	e4fff0ef          	jal	4c <run_workload>
  uint64 dr = after.disk_reads - before.disk_reads;
 202:	f1843903          	ld	s2,-232(s0)
 206:	ee843783          	ld	a5,-280(s0)
 20a:	40f90933          	sub	s2,s2,a5
  printf("  swap-in disk_reads delta = %llu\n", (unsigned long long)dr);
 20e:	85ca                	mv	a1,s2
 210:	00001517          	auipc	a0,0x1
 214:	f8850513          	addi	a0,a0,-120 # 1198 <malloc+0x29e>
 218:	42b000ef          	jal	e42 <printf>
  result("disk_reads > 0",   dr > 0);
 21c:	012035b3          	snez	a1,s2
 220:	00001517          	auipc	a0,0x1
 224:	fa050513          	addi	a0,a0,-96 # 11c0 <malloc+0x2c6>
 228:	dd9ff0ef          	jal	0 <result>
  result("disk_reads >= 32", dr >= 32);
 22c:	02093593          	sltiu	a1,s2,32
 230:	0015b593          	seqz	a1,a1
 234:	00001517          	auipc	a0,0x1
 238:	f9c50513          	addi	a0,a0,-100 # 11d0 <malloc+0x2d6>
 23c:	dc5ff0ef          	jal	0 <result>
  printf("\n[T4] avg_disk_latency > 0 after I/O\n");
 240:	00001517          	auipc	a0,0x1
 244:	fa850513          	addi	a0,a0,-88 # 11e8 <malloc+0x2ee>
 248:	3fb000ef          	jal	e42 <printf>
  run_workload(0, 3, &before, &after);
 24c:	86a6                	mv	a3,s1
 24e:	864e                	mv	a2,s3
 250:	458d                	li	a1,3
 252:	4501                	li	a0,0
 254:	df9ff0ef          	jal	4c <run_workload>
  printf("  avg_disk_latency = %llu\n", (unsigned long long)after.avg_disk_latency);
 258:	f2843583          	ld	a1,-216(s0)
 25c:	00001517          	auipc	a0,0x1
 260:	fb450513          	addi	a0,a0,-76 # 1210 <malloc+0x316>
 264:	3df000ef          	jal	e42 <printf>
  result("avg_disk_latency > 0", after.avg_disk_latency > 0);
 268:	f2843583          	ld	a1,-216(s0)
 26c:	00b035b3          	snez	a1,a1
 270:	00001517          	auipc	a0,0x1
 274:	fc050513          	addi	a0,a0,-64 # 1230 <malloc+0x336>
 278:	d89ff0ef          	jal	0 <result>
  result("avg_disk_latency >= ROTATIONAL_CONST (5)", after.avg_disk_latency >= 5);
 27c:	f2843583          	ld	a1,-216(s0)
 280:	0055b593          	sltiu	a1,a1,5
 284:	0015b593          	seqz	a1,a1
 288:	00001517          	auipc	a0,0x1
 28c:	fc050513          	addi	a0,a0,-64 # 1248 <malloc+0x34e>
 290:	d71ff0ef          	jal	0 <result>
  printf("\n[T5] avg_disk_latency in plausible range [5, 2053]\n");
 294:	00001517          	auipc	a0,0x1
 298:	fe450513          	addi	a0,a0,-28 # 1278 <malloc+0x37e>
 29c:	3a7000ef          	jal	e42 <printf>
  run_workload(0, 4, &before, &after);
 2a0:	86a6                	mv	a3,s1
 2a2:	864e                	mv	a2,s3
 2a4:	4591                	li	a1,4
 2a6:	4501                	li	a0,0
 2a8:	da5ff0ef          	jal	4c <run_workload>
  uint64 lat = after.avg_disk_latency;
 2ac:	f2843903          	ld	s2,-216(s0)
  printf("  avg_disk_latency = %llu\n", (unsigned long long)lat);
 2b0:	85ca                	mv	a1,s2
 2b2:	00001517          	auipc	a0,0x1
 2b6:	f5e50513          	addi	a0,a0,-162 # 1210 <malloc+0x316>
 2ba:	389000ef          	jal	e42 <printf>
  result("avg_disk_latency >= 5    (at least rotational const)", lat >= 5);
 2be:	00593593          	sltiu	a1,s2,5
 2c2:	0015b593          	seqz	a1,a1
 2c6:	00001517          	auipc	a0,0x1
 2ca:	fea50513          	addi	a0,a0,-22 # 12b0 <malloc+0x3b6>
 2ce:	d33ff0ef          	jal	0 <result>
  result("avg_disk_latency <= 2053 (no more than max seek + C)", lat <= 2053);
 2d2:	6585                	lui	a1,0x1
 2d4:	80658593          	addi	a1,a1,-2042 # 806 <gets+0x36>
 2d8:	00b935b3          	sltu	a1,s2,a1
 2dc:	00001517          	auipc	a0,0x1
 2e0:	00c50513          	addi	a0,a0,12 # 12e8 <malloc+0x3ee>
 2e4:	d1dff0ef          	jal	0 <result>
  printf("\n[T6] Stats increase monotonically across multiple workloads\n");
 2e8:	00001517          	auipc	a0,0x1
 2ec:	03850513          	addi	a0,a0,56 # 1320 <malloc+0x426>
 2f0:	353000ef          	jal	e42 <printf>
  getvmstats(getpid(), &s[0]);
 2f4:	738000ef          	jal	a2c <getpid>
 2f8:	85a6                	mv	a1,s1
 2fa:	792000ef          	jal	a8c <getvmstats>
  for(int i = 1; i <= 3; i++){
 2fe:	8926                	mv	s2,s1
 300:	f3040a13          	addi	s4,s0,-208
  getvmstats(getpid(), &s[0]);
 304:	49ad                	li	s3,11
    run_workload(0, 10 + i, &dummy, &s[i]);
 306:	ed040b13          	addi	s6,s0,-304
  for(int i = 1; i <= 3; i++){
 30a:	4ab9                	li	s5,14
    run_workload(0, 10 + i, &dummy, &s[i]);
 30c:	86d2                	mv	a3,s4
 30e:	865a                	mv	a2,s6
 310:	85ce                	mv	a1,s3
 312:	4501                	li	a0,0
 314:	d39ff0ef          	jal	4c <run_workload>
  for(int i = 1; i <= 3; i++){
 318:	2985                	addiw	s3,s3,1
 31a:	030a0a13          	addi	s4,s4,48
 31e:	ff5997e3          	bne	s3,s5,30c <main+0x1f6>
 322:	09048493          	addi	s1,s1,144
  int writes_mono = 1, reads_mono = 1;
 326:	4985                	li	s3,1
 328:	85ce                	mv	a1,s3
    if(s[i].disk_writes <= s[i-1].disk_writes) writes_mono = 0;
 32a:	05093783          	ld	a5,80(s2)
 32e:	02093703          	ld	a4,32(s2)
 332:	00f737b3          	sltu	a5,a4,a5
 336:	8dfd                	and	a1,a1,a5
    if(s[i].disk_reads  <= s[i-1].disk_reads)  reads_mono  = 0;
 338:	04893783          	ld	a5,72(s2)
 33c:	01893703          	ld	a4,24(s2)
 340:	00f737b3          	sltu	a5,a4,a5
 344:	00f9f9b3          	and	s3,s3,a5
  for(int i = 1; i <= 3; i++){
 348:	03090913          	addi	s2,s2,48
 34c:	fc991fe3          	bne	s2,s1,32a <main+0x214>
  result("disk_writes strictly increases over 3 workloads", writes_mono);
 350:	00001517          	auipc	a0,0x1
 354:	01050513          	addi	a0,a0,16 # 1360 <malloc+0x466>
 358:	ca9ff0ef          	jal	0 <result>
  result("disk_reads  strictly increases over 3 workloads", reads_mono);
 35c:	85ce                	mv	a1,s3
 35e:	00001517          	auipc	a0,0x1
 362:	03250513          	addi	a0,a0,50 # 1390 <malloc+0x496>
 366:	c9bff0ef          	jal	0 <result>
  printf("\n[T7] Per-process stats isolation (child vs parent)\n");
 36a:	00001517          	auipc	a0,0x1
 36e:	05650513          	addi	a0,a0,86 # 13c0 <malloc+0x4c6>
 372:	2d1000ef          	jal	e42 <printf>
  getvmstats(getpid(), &parent_before);
 376:	6b6000ef          	jal	a2c <getpid>
 37a:	ea040593          	addi	a1,s0,-352
 37e:	70e000ef          	jal	a8c <getvmstats>
  int pid = fork();
 382:	622000ef          	jal	9a4 <fork>
  if(pid == 0){
 386:	30050f63          	beqz	a0,6a4 <main+0x58e>
  int st; wait(&st);
 38a:	ed040913          	addi	s2,s0,-304
 38e:	854a                	mv	a0,s2
 390:	624000ef          	jal	9b4 <wait>
  getvmstats(getpid(), &parent_after);
 394:	698000ef          	jal	a2c <getpid>
 398:	f0040993          	addi	s3,s0,-256
 39c:	85ce                	mv	a1,s3
 39e:	6ee000ef          	jal	a8c <getvmstats>
  result("parent writes unchanged during child workload",
 3a2:	f2043583          	ld	a1,-224(s0)
 3a6:	ec043783          	ld	a5,-320(s0)
 3aa:	8d9d                	sub	a1,a1,a5
 3ac:	0015b593          	seqz	a1,a1
 3b0:	00001517          	auipc	a0,0x1
 3b4:	04850513          	addi	a0,a0,72 # 13f8 <malloc+0x4fe>
 3b8:	c49ff0ef          	jal	0 <result>
  result("parent reads unchanged during child workload",
 3bc:	f1843583          	ld	a1,-232(s0)
 3c0:	eb843783          	ld	a5,-328(s0)
 3c4:	8d9d                	sub	a1,a1,a5
 3c6:	0015b593          	seqz	a1,a1
 3ca:	00001517          	auipc	a0,0x1
 3ce:	05e50513          	addi	a0,a0,94 # 1428 <malloc+0x52e>
 3d2:	c2fff0ef          	jal	0 <result>
  printf("\n[T8] SSTF avg_latency <= FCFS avg_latency\n");
 3d6:	00001517          	auipc	a0,0x1
 3da:	08250513          	addi	a0,a0,130 # 1458 <malloc+0x55e>
 3de:	265000ef          	jal	e42 <printf>
  run_workload(0, 30, &b_fcfs, &a_fcfs);
 3e2:	ea040a93          	addi	s5,s0,-352
 3e6:	e7040a13          	addi	s4,s0,-400
 3ea:	86d6                	mv	a3,s5
 3ec:	8652                	mv	a2,s4
 3ee:	45f9                	li	a1,30
 3f0:	4501                	li	a0,0
 3f2:	c5bff0ef          	jal	4c <run_workload>
  run_workload(1, 31, &b_sstf, &a_sstf);
 3f6:	86ce                	mv	a3,s3
 3f8:	864a                	mv	a2,s2
 3fa:	45fd                	li	a1,31
 3fc:	4505                	li	a0,1
 3fe:	c4fff0ef          	jal	4c <run_workload>
  uint64 lat_fcfs = a_fcfs.avg_disk_latency;
 402:	ec843483          	ld	s1,-312(s0)
  uint64 lat_sstf = a_sstf.avg_disk_latency;
 406:	f2843b03          	ld	s6,-216(s0)
  printf("  FCFS avg_latency=%llu  SSTF avg_latency=%llu\n",
 40a:	865a                	mv	a2,s6
 40c:	85a6                	mv	a1,s1
 40e:	00001517          	auipc	a0,0x1
 412:	07a50513          	addi	a0,a0,122 # 1488 <malloc+0x58e>
 416:	22d000ef          	jal	e42 <printf>
  result("SSTF avg_latency <= FCFS avg_latency", lat_sstf <= lat_fcfs);
 41a:	0164b5b3          	sltu	a1,s1,s6
 41e:	0015b593          	seqz	a1,a1
 422:	00001517          	auipc	a0,0x1
 426:	09650513          	addi	a0,a0,150 # 14b8 <malloc+0x5be>
 42a:	bd7ff0ef          	jal	0 <result>
  printf("\n[T9] SSTF and FCFS produce same number of writes (same workload)\n");
 42e:	00001517          	auipc	a0,0x1
 432:	0b250513          	addi	a0,a0,178 # 14e0 <malloc+0x5e6>
 436:	20d000ef          	jal	e42 <printf>
  run_workload(0, 40, &bf, &af);
 43a:	86d6                	mv	a3,s5
 43c:	8652                	mv	a2,s4
 43e:	02800593          	li	a1,40
 442:	4501                	li	a0,0
 444:	c09ff0ef          	jal	4c <run_workload>
  run_workload(1, 40, &bs, &as);  // same seed = same workload size
 448:	86ce                	mv	a3,s3
 44a:	864a                	mv	a2,s2
 44c:	02800593          	li	a1,40
 450:	4505                	li	a0,1
 452:	bfbff0ef          	jal	4c <run_workload>
  uint64 writes_fcfs = af.disk_writes - bf.disk_writes;
 456:	ec043a03          	ld	s4,-320(s0)
 45a:	e9043983          	ld	s3,-368(s0)
 45e:	413a0933          	sub	s2,s4,s3
  uint64 writes_sstf = as.disk_writes - bs.disk_writes;
 462:	f2043b03          	ld	s6,-224(s0)
 466:	ef043a83          	ld	s5,-272(s0)
 46a:	415b04b3          	sub	s1,s6,s5
  printf("  FCFS writes=%llu  SSTF writes=%llu\n",
 46e:	8626                	mv	a2,s1
 470:	85ca                	mv	a1,s2
 472:	00001517          	auipc	a0,0x1
 476:	0b650513          	addi	a0,a0,182 # 1528 <malloc+0x62e>
 47a:	1c9000ef          	jal	e42 <printf>
  uint64 diff = writes_fcfs > writes_sstf ? writes_fcfs - writes_sstf : writes_sstf - writes_fcfs;
 47e:	2324fd63          	bgeu	s1,s2,6b8 <main+0x5a2>
 482:	41690933          	sub	s2,s2,s6
 486:	015905b3          	add	a1,s2,s5
  result("write count identical under FCFS and SSTF", diff <= 5);
 48a:	0065b593          	sltiu	a1,a1,6
 48e:	00001517          	auipc	a0,0x1
 492:	0c250513          	addi	a0,a0,194 # 1550 <malloc+0x656>
 496:	b6bff0ef          	jal	0 <result>
  printf("\n[T10] getvmstats returns -1 for invalid pids\n");
 49a:	00001517          	auipc	a0,0x1
 49e:	0e650513          	addi	a0,a0,230 # 1580 <malloc+0x686>
 4a2:	1a1000ef          	jal	e42 <printf>
  result("getvmstats(-1) == -1",    getvmstats(-1, &s)    == -1);
 4a6:	f0040493          	addi	s1,s0,-256
 4aa:	85a6                	mv	a1,s1
 4ac:	557d                	li	a0,-1
 4ae:	5de000ef          	jal	a8c <getvmstats>
 4b2:	597d                	li	s2,-1
 4b4:	00150593          	addi	a1,a0,1
 4b8:	0015b593          	seqz	a1,a1
 4bc:	00001517          	auipc	a0,0x1
 4c0:	0f450513          	addi	a0,a0,244 # 15b0 <malloc+0x6b6>
 4c4:	b3dff0ef          	jal	0 <result>
  result("getvmstats(99999) == -1", getvmstats(99999, &s) == -1);
 4c8:	85a6                	mv	a1,s1
 4ca:	6561                	lui	a0,0x18
 4cc:	69f50513          	addi	a0,a0,1695 # 1869f <base+0x1668f>
 4d0:	5bc000ef          	jal	a8c <getvmstats>
 4d4:	00150593          	addi	a1,a0,1
 4d8:	0015b593          	seqz	a1,a1
 4dc:	00001517          	auipc	a0,0x1
 4e0:	0ec50513          	addi	a0,a0,236 # 15c8 <malloc+0x6ce>
 4e4:	b1dff0ef          	jal	0 <result>
  result("getvmstats(0) == -1",     getvmstats(0, &s)     == -1);
 4e8:	85a6                	mv	a1,s1
 4ea:	4501                	li	a0,0
 4ec:	5a0000ef          	jal	a8c <getvmstats>
 4f0:	00150593          	addi	a1,a0,1
 4f4:	0015b593          	seqz	a1,a1
 4f8:	00001517          	auipc	a0,0x1
 4fc:	0e850513          	addi	a0,a0,232 # 15e0 <malloc+0x6e6>
 500:	b01ff0ef          	jal	0 <result>
  printf("\n[T11] Stats stable after sbrk shrink (no spurious reads)\n");
 504:	00001517          	auipc	a0,0x1
 508:	0f450513          	addi	a0,a0,244 # 15f8 <malloc+0x6fe>
 50c:	137000ef          	jal	e42 <printf>
  getvmstats(getpid(), &before);
 510:	51c000ef          	jal	a2c <getpid>
 514:	ea040593          	addi	a1,s0,-352
 518:	574000ef          	jal	a8c <getvmstats>
  char *b = sbrk(WORK_PAGES * PAGE_SIZE);
 51c:	00040537          	lui	a0,0x40
 520:	458000ef          	jal	978 <sbrk>
  if(b == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
 524:	4601                	li	a2,0
 526:	4689                	li	a3,2
  for(int j = 0; j < PAGE_SIZE; j++)
 528:	6805                	lui	a6,0x1
 52a:	01050333          	add	t1,a0,a6
  for(int i=0;i<WORK_PAGES;i++) fill(b+i*PAGE_SIZE,i,50);
 52e:	0c200893          	li	a7,194
  if(b == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
 532:	19250763          	beq	a0,s2,6c0 <main+0x5aa>
  for(int j = 0; j < PAGE_SIZE; j++)
 536:	00c50733          	add	a4,a0,a2
 53a:	87b6                	mv	a5,a3
 53c:	00c305b3          	add	a1,t1,a2
    p[j] = (char)((page * 23 + j * 9 + seed * 41) & 0xFF);
 540:	00f70023          	sb	a5,0(a4)
  for(int j = 0; j < PAGE_SIZE; j++)
 544:	27a5                	addiw	a5,a5,9
 546:	0ff7f793          	zext.b	a5,a5
 54a:	0705                	addi	a4,a4,1
 54c:	feb71ae3          	bne	a4,a1,540 <main+0x42a>
  for(int i=0;i<WORK_PAGES;i++) fill(b+i*PAGE_SIZE,i,50);
 550:	26dd                	addiw	a3,a3,23 # 1017 <malloc+0x11d>
 552:	0ff6f693          	zext.b	a3,a3
 556:	9642                	add	a2,a2,a6
 558:	fd169fe3          	bne	a3,a7,536 <main+0x420>
  char *p = sbrk(PRESSURE*PAGE_SIZE);
 55c:	00048537          	lui	a0,0x48
 560:	418000ef          	jal	978 <sbrk>
  if(p!=(char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
 564:	57fd                	li	a5,-1
 566:	02f50163          	beq	a0,a5,588 <main+0x472>
 56a:	87aa                	mv	a5,a0
 56c:	000486b7          	lui	a3,0x48
 570:	00d50733          	add	a4,a0,a3
 574:	6685                	lui	a3,0x1
 576:	00078023          	sb	zero,0(a5)
 57a:	97b6                	add	a5,a5,a3
 57c:	fef71de3          	bne	a4,a5,576 <main+0x460>
 580:	fffb8537          	lui	a0,0xfffb8
 584:	3f4000ef          	jal	978 <sbrk>
  struct vmstats mid; getvmstats(getpid(), &mid);
 588:	4a4000ef          	jal	a2c <getpid>
 58c:	ed040593          	addi	a1,s0,-304
 590:	4fc000ef          	jal	a8c <getvmstats>
  sbrk(-(WORK_PAGES * PAGE_SIZE));
 594:	fffc0537          	lui	a0,0xfffc0
 598:	3e0000ef          	jal	978 <sbrk>
  struct vmstats after; getvmstats(getpid(), &after);
 59c:	490000ef          	jal	a2c <getpid>
 5a0:	f0040593          	addi	a1,s0,-256
 5a4:	4e8000ef          	jal	a8c <getvmstats>
  result("shrink does not increment disk_reads", after.disk_reads == mid.disk_reads);
 5a8:	f1843583          	ld	a1,-232(s0)
 5ac:	ee843783          	ld	a5,-280(s0)
 5b0:	8d9d                	sub	a1,a1,a5
 5b2:	0015b593          	seqz	a1,a1
 5b6:	00001517          	auipc	a0,0x1
 5ba:	09250513          	addi	a0,a0,146 # 1648 <malloc+0x74e>
 5be:	a43ff0ef          	jal	0 <result>
         (unsigned long long)(mid.disk_reads  - before.disk_reads),
 5c2:	ee843783          	ld	a5,-280(s0)
  printf("  writes=%llu  reads=%llu  (after shrink reads=%llu)\n",
 5c6:	f1843683          	ld	a3,-232(s0)
 5ca:	8e9d                	sub	a3,a3,a5
 5cc:	eb843603          	ld	a2,-328(s0)
 5d0:	40c78633          	sub	a2,a5,a2
 5d4:	ef043583          	ld	a1,-272(s0)
 5d8:	ec043783          	ld	a5,-320(s0)
 5dc:	8d9d                	sub	a1,a1,a5
 5de:	00001517          	auipc	a0,0x1
 5e2:	09250513          	addi	a0,a0,146 # 1670 <malloc+0x776>
 5e6:	05d000ef          	jal	e42 <printf>
  printf("\n[T12] Counters do not wrap to zero under heavy load\n");
 5ea:	00001517          	auipc	a0,0x1
 5ee:	0be50513          	addi	a0,a0,190 # 16a8 <malloc+0x7ae>
 5f2:	051000ef          	jal	e42 <printf>
  struct vmstats prev; getvmstats(getpid(), &prev);
 5f6:	436000ef          	jal	a2c <getpid>
 5fa:	ea040593          	addi	a1,s0,-352
 5fe:	48e000ef          	jal	a8c <getvmstats>
  for(int r = 0; r < 4; r++){
 602:	4481                	li	s1,0
    run_workload(0, 60 + r, &dummy, &cur);
 604:	f0040a13          	addi	s4,s0,-256
 608:	ed040993          	addi	s3,s0,-304
  for(int r = 0; r < 4; r++){
 60c:	4911                	li	s2,4
    run_workload(0, 60 + r, &dummy, &cur);
 60e:	86d2                	mv	a3,s4
 610:	864e                	mv	a2,s3
 612:	03c4859b          	addiw	a1,s1,60
 616:	4501                	li	a0,0
 618:	a35ff0ef          	jal	4c <run_workload>
    if(cur.disk_writes < prev.disk_writes ||
 61c:	f2043683          	ld	a3,-224(s0)
 620:	ec043603          	ld	a2,-320(s0)
 624:	0ac6ec63          	bltu	a3,a2,6dc <main+0x5c6>
 628:	f1843703          	ld	a4,-232(s0)
 62c:	eb843783          	ld	a5,-328(s0)
 630:	0af76663          	bltu	a4,a5,6dc <main+0x5c6>
    prev = cur;
 634:	f0043783          	ld	a5,-256(s0)
 638:	eaf43023          	sd	a5,-352(s0)
 63c:	f0843783          	ld	a5,-248(s0)
 640:	eaf43423          	sd	a5,-344(s0)
 644:	f1043783          	ld	a5,-240(s0)
 648:	eaf43823          	sd	a5,-336(s0)
 64c:	f1843783          	ld	a5,-232(s0)
 650:	eaf43c23          	sd	a5,-328(s0)
 654:	f2043783          	ld	a5,-224(s0)
 658:	ecf43023          	sd	a5,-320(s0)
 65c:	f2843783          	ld	a5,-216(s0)
 660:	ecf43423          	sd	a5,-312(s0)
  for(int r = 0; r < 4; r++){
 664:	2485                	addiw	s1,s1,1
 666:	fb2494e3          	bne	s1,s2,60e <main+0x4f8>
  int wrapped = 0;
 66a:	4581                	li	a1,0
  result("counters never wrap over 4 heavy workloads", !wrapped);
 66c:	0015c593          	xori	a1,a1,1
 670:	00001517          	auipc	a0,0x1
 674:	0b850513          	addi	a0,a0,184 # 1728 <malloc+0x82e>
 678:	989ff0ef          	jal	0 <result>
  t9_same_write_volume();
  t10_invalid_pid();
  t11_shrink();
  t12_no_wrap();

  printf("\n=== RESULTS: %d passed, %d failed ===\n", total_pass, total_fail);
 67c:	00002497          	auipc	s1,0x2
 680:	98448493          	addi	s1,s1,-1660 # 2000 <total_fail>
 684:	4090                	lw	a2,0(s1)
 686:	00002597          	auipc	a1,0x2
 68a:	97e5a583          	lw	a1,-1666(a1) # 2004 <total_pass>
 68e:	00001517          	auipc	a0,0x1
 692:	0ca50513          	addi	a0,a0,202 # 1758 <malloc+0x85e>
 696:	7ac000ef          	jal	e42 <printf>
  exit(total_fail == 0 ? 0 : 1);
 69a:	4088                	lw	a0,0(s1)
 69c:	00a03533          	snez	a0,a0
 6a0:	30c000ef          	jal	9ac <exit>
    run_workload(0, 20, &d, &a);
 6a4:	f0040693          	addi	a3,s0,-256
 6a8:	ed040613          	addi	a2,s0,-304
 6ac:	45d1                	li	a1,20
 6ae:	99fff0ef          	jal	4c <run_workload>
    exit(0);
 6b2:	4501                	li	a0,0
 6b4:	2f8000ef          	jal	9ac <exit>
  uint64 diff = writes_fcfs > writes_sstf ? writes_fcfs - writes_sstf : writes_sstf - writes_fcfs;
 6b8:	414485b3          	sub	a1,s1,s4
 6bc:	95ce                	add	a1,a1,s3
 6be:	b3f1                	j	48a <main+0x374>
  if(b == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
 6c0:	00001517          	auipc	a0,0x1
 6c4:	f7850513          	addi	a0,a0,-136 # 1638 <malloc+0x73e>
 6c8:	77a000ef          	jal	e42 <printf>
 6cc:	00002717          	auipc	a4,0x2
 6d0:	93470713          	addi	a4,a4,-1740 # 2000 <total_fail>
 6d4:	431c                	lw	a5,0(a4)
 6d6:	2785                	addiw	a5,a5,1
 6d8:	c31c                	sw	a5,0(a4)
 6da:	bf01                	j	5ea <main+0x4d4>
      printf("  WRAP detected at round %d: writes %llu→%llu reads %llu→%llu\n",
 6dc:	f1843783          	ld	a5,-232(s0)
 6e0:	eb843703          	ld	a4,-328(s0)
 6e4:	85a6                	mv	a1,s1
 6e6:	00001517          	auipc	a0,0x1
 6ea:	ffa50513          	addi	a0,a0,-6 # 16e0 <malloc+0x7e6>
 6ee:	754000ef          	jal	e42 <printf>
      wrapped = 1;
 6f2:	4585                	li	a1,1
 6f4:	bfa5                	j	66c <main+0x556>

00000000000006f6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 6f6:	1141                	addi	sp,sp,-16
 6f8:	e406                	sd	ra,8(sp)
 6fa:	e022                	sd	s0,0(sp)
 6fc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 6fe:	a19ff0ef          	jal	116 <main>
  exit(r);
 702:	2aa000ef          	jal	9ac <exit>

0000000000000706 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 706:	1141                	addi	sp,sp,-16
 708:	e406                	sd	ra,8(sp)
 70a:	e022                	sd	s0,0(sp)
 70c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 70e:	87aa                	mv	a5,a0
 710:	0585                	addi	a1,a1,1
 712:	0785                	addi	a5,a5,1
 714:	fff5c703          	lbu	a4,-1(a1)
 718:	fee78fa3          	sb	a4,-1(a5)
 71c:	fb75                	bnez	a4,710 <strcpy+0xa>
    ;
  return os;
}
 71e:	60a2                	ld	ra,8(sp)
 720:	6402                	ld	s0,0(sp)
 722:	0141                	addi	sp,sp,16
 724:	8082                	ret

0000000000000726 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 726:	1141                	addi	sp,sp,-16
 728:	e406                	sd	ra,8(sp)
 72a:	e022                	sd	s0,0(sp)
 72c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 72e:	00054783          	lbu	a5,0(a0)
 732:	cb91                	beqz	a5,746 <strcmp+0x20>
 734:	0005c703          	lbu	a4,0(a1)
 738:	00f71763          	bne	a4,a5,746 <strcmp+0x20>
    p++, q++;
 73c:	0505                	addi	a0,a0,1
 73e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 740:	00054783          	lbu	a5,0(a0)
 744:	fbe5                	bnez	a5,734 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 746:	0005c503          	lbu	a0,0(a1)
}
 74a:	40a7853b          	subw	a0,a5,a0
 74e:	60a2                	ld	ra,8(sp)
 750:	6402                	ld	s0,0(sp)
 752:	0141                	addi	sp,sp,16
 754:	8082                	ret

0000000000000756 <strlen>:

uint
strlen(const char *s)
{
 756:	1141                	addi	sp,sp,-16
 758:	e406                	sd	ra,8(sp)
 75a:	e022                	sd	s0,0(sp)
 75c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 75e:	00054783          	lbu	a5,0(a0)
 762:	cf91                	beqz	a5,77e <strlen+0x28>
 764:	00150793          	addi	a5,a0,1
 768:	86be                	mv	a3,a5
 76a:	0785                	addi	a5,a5,1
 76c:	fff7c703          	lbu	a4,-1(a5)
 770:	ff65                	bnez	a4,768 <strlen+0x12>
 772:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 776:	60a2                	ld	ra,8(sp)
 778:	6402                	ld	s0,0(sp)
 77a:	0141                	addi	sp,sp,16
 77c:	8082                	ret
  for(n = 0; s[n]; n++)
 77e:	4501                	li	a0,0
 780:	bfdd                	j	776 <strlen+0x20>

0000000000000782 <memset>:

void*
memset(void *dst, int c, uint n)
{
 782:	1141                	addi	sp,sp,-16
 784:	e406                	sd	ra,8(sp)
 786:	e022                	sd	s0,0(sp)
 788:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 78a:	ca19                	beqz	a2,7a0 <memset+0x1e>
 78c:	87aa                	mv	a5,a0
 78e:	1602                	slli	a2,a2,0x20
 790:	9201                	srli	a2,a2,0x20
 792:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 796:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 79a:	0785                	addi	a5,a5,1
 79c:	fee79de3          	bne	a5,a4,796 <memset+0x14>
  }
  return dst;
}
 7a0:	60a2                	ld	ra,8(sp)
 7a2:	6402                	ld	s0,0(sp)
 7a4:	0141                	addi	sp,sp,16
 7a6:	8082                	ret

00000000000007a8 <strchr>:

char*
strchr(const char *s, char c)
{
 7a8:	1141                	addi	sp,sp,-16
 7aa:	e406                	sd	ra,8(sp)
 7ac:	e022                	sd	s0,0(sp)
 7ae:	0800                	addi	s0,sp,16
  for(; *s; s++)
 7b0:	00054783          	lbu	a5,0(a0)
 7b4:	cf81                	beqz	a5,7cc <strchr+0x24>
    if(*s == c)
 7b6:	00f58763          	beq	a1,a5,7c4 <strchr+0x1c>
  for(; *s; s++)
 7ba:	0505                	addi	a0,a0,1
 7bc:	00054783          	lbu	a5,0(a0)
 7c0:	fbfd                	bnez	a5,7b6 <strchr+0xe>
      return (char*)s;
  return 0;
 7c2:	4501                	li	a0,0
}
 7c4:	60a2                	ld	ra,8(sp)
 7c6:	6402                	ld	s0,0(sp)
 7c8:	0141                	addi	sp,sp,16
 7ca:	8082                	ret
  return 0;
 7cc:	4501                	li	a0,0
 7ce:	bfdd                	j	7c4 <strchr+0x1c>

00000000000007d0 <gets>:

char*
gets(char *buf, int max)
{
 7d0:	711d                	addi	sp,sp,-96
 7d2:	ec86                	sd	ra,88(sp)
 7d4:	e8a2                	sd	s0,80(sp)
 7d6:	e4a6                	sd	s1,72(sp)
 7d8:	e0ca                	sd	s2,64(sp)
 7da:	fc4e                	sd	s3,56(sp)
 7dc:	f852                	sd	s4,48(sp)
 7de:	f456                	sd	s5,40(sp)
 7e0:	f05a                	sd	s6,32(sp)
 7e2:	ec5e                	sd	s7,24(sp)
 7e4:	e862                	sd	s8,16(sp)
 7e6:	1080                	addi	s0,sp,96
 7e8:	8baa                	mv	s7,a0
 7ea:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7ec:	892a                	mv	s2,a0
 7ee:	4481                	li	s1,0
    cc = read(0, &c, 1);
 7f0:	faf40b13          	addi	s6,s0,-81
 7f4:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 7f6:	8c26                	mv	s8,s1
 7f8:	0014899b          	addiw	s3,s1,1
 7fc:	84ce                	mv	s1,s3
 7fe:	0349d463          	bge	s3,s4,826 <gets+0x56>
    cc = read(0, &c, 1);
 802:	8656                	mv	a2,s5
 804:	85da                	mv	a1,s6
 806:	4501                	li	a0,0
 808:	1bc000ef          	jal	9c4 <read>
    if(cc < 1)
 80c:	00a05d63          	blez	a0,826 <gets+0x56>
      break;
    buf[i++] = c;
 810:	faf44783          	lbu	a5,-81(s0)
 814:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 818:	0905                	addi	s2,s2,1
 81a:	ff678713          	addi	a4,a5,-10
 81e:	c319                	beqz	a4,824 <gets+0x54>
 820:	17cd                	addi	a5,a5,-13
 822:	fbf1                	bnez	a5,7f6 <gets+0x26>
    buf[i++] = c;
 824:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 826:	9c5e                	add	s8,s8,s7
 828:	000c0023          	sb	zero,0(s8)
  return buf;
}
 82c:	855e                	mv	a0,s7
 82e:	60e6                	ld	ra,88(sp)
 830:	6446                	ld	s0,80(sp)
 832:	64a6                	ld	s1,72(sp)
 834:	6906                	ld	s2,64(sp)
 836:	79e2                	ld	s3,56(sp)
 838:	7a42                	ld	s4,48(sp)
 83a:	7aa2                	ld	s5,40(sp)
 83c:	7b02                	ld	s6,32(sp)
 83e:	6be2                	ld	s7,24(sp)
 840:	6c42                	ld	s8,16(sp)
 842:	6125                	addi	sp,sp,96
 844:	8082                	ret

0000000000000846 <stat>:

int
stat(const char *n, struct stat *st)
{
 846:	1101                	addi	sp,sp,-32
 848:	ec06                	sd	ra,24(sp)
 84a:	e822                	sd	s0,16(sp)
 84c:	e04a                	sd	s2,0(sp)
 84e:	1000                	addi	s0,sp,32
 850:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 852:	4581                	li	a1,0
 854:	198000ef          	jal	9ec <open>
  if(fd < 0)
 858:	02054263          	bltz	a0,87c <stat+0x36>
 85c:	e426                	sd	s1,8(sp)
 85e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 860:	85ca                	mv	a1,s2
 862:	1a2000ef          	jal	a04 <fstat>
 866:	892a                	mv	s2,a0
  close(fd);
 868:	8526                	mv	a0,s1
 86a:	16a000ef          	jal	9d4 <close>
  return r;
 86e:	64a2                	ld	s1,8(sp)
}
 870:	854a                	mv	a0,s2
 872:	60e2                	ld	ra,24(sp)
 874:	6442                	ld	s0,16(sp)
 876:	6902                	ld	s2,0(sp)
 878:	6105                	addi	sp,sp,32
 87a:	8082                	ret
    return -1;
 87c:	57fd                	li	a5,-1
 87e:	893e                	mv	s2,a5
 880:	bfc5                	j	870 <stat+0x2a>

0000000000000882 <atoi>:

int
atoi(const char *s)
{
 882:	1141                	addi	sp,sp,-16
 884:	e406                	sd	ra,8(sp)
 886:	e022                	sd	s0,0(sp)
 888:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 88a:	00054683          	lbu	a3,0(a0)
 88e:	fd06879b          	addiw	a5,a3,-48 # fd0 <malloc+0xd6>
 892:	0ff7f793          	zext.b	a5,a5
 896:	4625                	li	a2,9
 898:	02f66963          	bltu	a2,a5,8ca <atoi+0x48>
 89c:	872a                	mv	a4,a0
  n = 0;
 89e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 8a0:	0705                	addi	a4,a4,1
 8a2:	0025179b          	slliw	a5,a0,0x2
 8a6:	9fa9                	addw	a5,a5,a0
 8a8:	0017979b          	slliw	a5,a5,0x1
 8ac:	9fb5                	addw	a5,a5,a3
 8ae:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 8b2:	00074683          	lbu	a3,0(a4)
 8b6:	fd06879b          	addiw	a5,a3,-48
 8ba:	0ff7f793          	zext.b	a5,a5
 8be:	fef671e3          	bgeu	a2,a5,8a0 <atoi+0x1e>
  return n;
}
 8c2:	60a2                	ld	ra,8(sp)
 8c4:	6402                	ld	s0,0(sp)
 8c6:	0141                	addi	sp,sp,16
 8c8:	8082                	ret
  n = 0;
 8ca:	4501                	li	a0,0
 8cc:	bfdd                	j	8c2 <atoi+0x40>

00000000000008ce <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 8ce:	1141                	addi	sp,sp,-16
 8d0:	e406                	sd	ra,8(sp)
 8d2:	e022                	sd	s0,0(sp)
 8d4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 8d6:	02b57563          	bgeu	a0,a1,900 <memmove+0x32>
    while(n-- > 0)
 8da:	00c05f63          	blez	a2,8f8 <memmove+0x2a>
 8de:	1602                	slli	a2,a2,0x20
 8e0:	9201                	srli	a2,a2,0x20
 8e2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 8e6:	872a                	mv	a4,a0
      *dst++ = *src++;
 8e8:	0585                	addi	a1,a1,1
 8ea:	0705                	addi	a4,a4,1
 8ec:	fff5c683          	lbu	a3,-1(a1)
 8f0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 8f4:	fee79ae3          	bne	a5,a4,8e8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 8f8:	60a2                	ld	ra,8(sp)
 8fa:	6402                	ld	s0,0(sp)
 8fc:	0141                	addi	sp,sp,16
 8fe:	8082                	ret
    while(n-- > 0)
 900:	fec05ce3          	blez	a2,8f8 <memmove+0x2a>
    dst += n;
 904:	00c50733          	add	a4,a0,a2
    src += n;
 908:	95b2                	add	a1,a1,a2
 90a:	fff6079b          	addiw	a5,a2,-1
 90e:	1782                	slli	a5,a5,0x20
 910:	9381                	srli	a5,a5,0x20
 912:	fff7c793          	not	a5,a5
 916:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 918:	15fd                	addi	a1,a1,-1
 91a:	177d                	addi	a4,a4,-1
 91c:	0005c683          	lbu	a3,0(a1)
 920:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 924:	fef71ae3          	bne	a4,a5,918 <memmove+0x4a>
 928:	bfc1                	j	8f8 <memmove+0x2a>

000000000000092a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 92a:	1141                	addi	sp,sp,-16
 92c:	e406                	sd	ra,8(sp)
 92e:	e022                	sd	s0,0(sp)
 930:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 932:	c61d                	beqz	a2,960 <memcmp+0x36>
 934:	1602                	slli	a2,a2,0x20
 936:	9201                	srli	a2,a2,0x20
 938:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 93c:	00054783          	lbu	a5,0(a0)
 940:	0005c703          	lbu	a4,0(a1)
 944:	00e79863          	bne	a5,a4,954 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 948:	0505                	addi	a0,a0,1
    p2++;
 94a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 94c:	fed518e3          	bne	a0,a3,93c <memcmp+0x12>
  }
  return 0;
 950:	4501                	li	a0,0
 952:	a019                	j	958 <memcmp+0x2e>
      return *p1 - *p2;
 954:	40e7853b          	subw	a0,a5,a4
}
 958:	60a2                	ld	ra,8(sp)
 95a:	6402                	ld	s0,0(sp)
 95c:	0141                	addi	sp,sp,16
 95e:	8082                	ret
  return 0;
 960:	4501                	li	a0,0
 962:	bfdd                	j	958 <memcmp+0x2e>

0000000000000964 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 964:	1141                	addi	sp,sp,-16
 966:	e406                	sd	ra,8(sp)
 968:	e022                	sd	s0,0(sp)
 96a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 96c:	f63ff0ef          	jal	8ce <memmove>
}
 970:	60a2                	ld	ra,8(sp)
 972:	6402                	ld	s0,0(sp)
 974:	0141                	addi	sp,sp,16
 976:	8082                	ret

0000000000000978 <sbrk>:

char *
sbrk(int n) {
 978:	1141                	addi	sp,sp,-16
 97a:	e406                	sd	ra,8(sp)
 97c:	e022                	sd	s0,0(sp)
 97e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 980:	4585                	li	a1,1
 982:	0b2000ef          	jal	a34 <sys_sbrk>
}
 986:	60a2                	ld	ra,8(sp)
 988:	6402                	ld	s0,0(sp)
 98a:	0141                	addi	sp,sp,16
 98c:	8082                	ret

000000000000098e <sbrklazy>:

char *
sbrklazy(int n) {
 98e:	1141                	addi	sp,sp,-16
 990:	e406                	sd	ra,8(sp)
 992:	e022                	sd	s0,0(sp)
 994:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 996:	4589                	li	a1,2
 998:	09c000ef          	jal	a34 <sys_sbrk>
}
 99c:	60a2                	ld	ra,8(sp)
 99e:	6402                	ld	s0,0(sp)
 9a0:	0141                	addi	sp,sp,16
 9a2:	8082                	ret

00000000000009a4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 9a4:	4885                	li	a7,1
 ecall
 9a6:	00000073          	ecall
 ret
 9aa:	8082                	ret

00000000000009ac <exit>:
.global exit
exit:
 li a7, SYS_exit
 9ac:	4889                	li	a7,2
 ecall
 9ae:	00000073          	ecall
 ret
 9b2:	8082                	ret

00000000000009b4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 9b4:	488d                	li	a7,3
 ecall
 9b6:	00000073          	ecall
 ret
 9ba:	8082                	ret

00000000000009bc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 9bc:	4891                	li	a7,4
 ecall
 9be:	00000073          	ecall
 ret
 9c2:	8082                	ret

00000000000009c4 <read>:
.global read
read:
 li a7, SYS_read
 9c4:	4895                	li	a7,5
 ecall
 9c6:	00000073          	ecall
 ret
 9ca:	8082                	ret

00000000000009cc <write>:
.global write
write:
 li a7, SYS_write
 9cc:	48c1                	li	a7,16
 ecall
 9ce:	00000073          	ecall
 ret
 9d2:	8082                	ret

00000000000009d4 <close>:
.global close
close:
 li a7, SYS_close
 9d4:	48d5                	li	a7,21
 ecall
 9d6:	00000073          	ecall
 ret
 9da:	8082                	ret

00000000000009dc <kill>:
.global kill
kill:
 li a7, SYS_kill
 9dc:	4899                	li	a7,6
 ecall
 9de:	00000073          	ecall
 ret
 9e2:	8082                	ret

00000000000009e4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 9e4:	489d                	li	a7,7
 ecall
 9e6:	00000073          	ecall
 ret
 9ea:	8082                	ret

00000000000009ec <open>:
.global open
open:
 li a7, SYS_open
 9ec:	48bd                	li	a7,15
 ecall
 9ee:	00000073          	ecall
 ret
 9f2:	8082                	ret

00000000000009f4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 9f4:	48c5                	li	a7,17
 ecall
 9f6:	00000073          	ecall
 ret
 9fa:	8082                	ret

00000000000009fc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 9fc:	48c9                	li	a7,18
 ecall
 9fe:	00000073          	ecall
 ret
 a02:	8082                	ret

0000000000000a04 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 a04:	48a1                	li	a7,8
 ecall
 a06:	00000073          	ecall
 ret
 a0a:	8082                	ret

0000000000000a0c <link>:
.global link
link:
 li a7, SYS_link
 a0c:	48cd                	li	a7,19
 ecall
 a0e:	00000073          	ecall
 ret
 a12:	8082                	ret

0000000000000a14 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 a14:	48d1                	li	a7,20
 ecall
 a16:	00000073          	ecall
 ret
 a1a:	8082                	ret

0000000000000a1c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 a1c:	48a5                	li	a7,9
 ecall
 a1e:	00000073          	ecall
 ret
 a22:	8082                	ret

0000000000000a24 <dup>:
.global dup
dup:
 li a7, SYS_dup
 a24:	48a9                	li	a7,10
 ecall
 a26:	00000073          	ecall
 ret
 a2a:	8082                	ret

0000000000000a2c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 a2c:	48ad                	li	a7,11
 ecall
 a2e:	00000073          	ecall
 ret
 a32:	8082                	ret

0000000000000a34 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 a34:	48b1                	li	a7,12
 ecall
 a36:	00000073          	ecall
 ret
 a3a:	8082                	ret

0000000000000a3c <pause>:
.global pause
pause:
 li a7, SYS_pause
 a3c:	48b5                	li	a7,13
 ecall
 a3e:	00000073          	ecall
 ret
 a42:	8082                	ret

0000000000000a44 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 a44:	48b9                	li	a7,14
 ecall
 a46:	00000073          	ecall
 ret
 a4a:	8082                	ret

0000000000000a4c <hello>:
.global hello
hello:
 li a7, SYS_hello
 a4c:	48d9                	li	a7,22
 ecall
 a4e:	00000073          	ecall
 ret
 a52:	8082                	ret

0000000000000a54 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 a54:	48dd                	li	a7,23
 ecall
 a56:	00000073          	ecall
 ret
 a5a:	8082                	ret

0000000000000a5c <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 a5c:	48e1                	li	a7,24
 ecall
 a5e:	00000073          	ecall
 ret
 a62:	8082                	ret

0000000000000a64 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 a64:	48e5                	li	a7,25
 ecall
 a66:	00000073          	ecall
 ret
 a6a:	8082                	ret

0000000000000a6c <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 a6c:	48e9                	li	a7,26
 ecall
 a6e:	00000073          	ecall
 ret
 a72:	8082                	ret

0000000000000a74 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 a74:	48ed                	li	a7,27
 ecall
 a76:	00000073          	ecall
 ret
 a7a:	8082                	ret

0000000000000a7c <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 a7c:	48f1                	li	a7,28
 ecall
 a7e:	00000073          	ecall
 ret
 a82:	8082                	ret

0000000000000a84 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 a84:	48f5                	li	a7,29
 ecall
 a86:	00000073          	ecall
 ret
 a8a:	8082                	ret

0000000000000a8c <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 a8c:	48f9                	li	a7,30
 ecall
 a8e:	00000073          	ecall
 ret
 a92:	8082                	ret

0000000000000a94 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 a94:	48fd                	li	a7,31
 ecall
 a96:	00000073          	ecall
 ret
 a9a:	8082                	ret

0000000000000a9c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 a9c:	1101                	addi	sp,sp,-32
 a9e:	ec06                	sd	ra,24(sp)
 aa0:	e822                	sd	s0,16(sp)
 aa2:	1000                	addi	s0,sp,32
 aa4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 aa8:	4605                	li	a2,1
 aaa:	fef40593          	addi	a1,s0,-17
 aae:	f1fff0ef          	jal	9cc <write>
}
 ab2:	60e2                	ld	ra,24(sp)
 ab4:	6442                	ld	s0,16(sp)
 ab6:	6105                	addi	sp,sp,32
 ab8:	8082                	ret

0000000000000aba <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 aba:	715d                	addi	sp,sp,-80
 abc:	e486                	sd	ra,72(sp)
 abe:	e0a2                	sd	s0,64(sp)
 ac0:	f84a                	sd	s2,48(sp)
 ac2:	f44e                	sd	s3,40(sp)
 ac4:	0880                	addi	s0,sp,80
 ac6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 ac8:	c6d1                	beqz	a3,b54 <printint+0x9a>
 aca:	0805d563          	bgez	a1,b54 <printint+0x9a>
    neg = 1;
    x = -xx;
 ace:	40b005b3          	neg	a1,a1
    neg = 1;
 ad2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 ad4:	fb840993          	addi	s3,s0,-72
  neg = 0;
 ad8:	86ce                	mv	a3,s3
  i = 0;
 ada:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 adc:	00001817          	auipc	a6,0x1
 ae0:	cac80813          	addi	a6,a6,-852 # 1788 <digits>
 ae4:	88ba                	mv	a7,a4
 ae6:	0017051b          	addiw	a0,a4,1
 aea:	872a                	mv	a4,a0
 aec:	02c5f7b3          	remu	a5,a1,a2
 af0:	97c2                	add	a5,a5,a6
 af2:	0007c783          	lbu	a5,0(a5)
 af6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 afa:	87ae                	mv	a5,a1
 afc:	02c5d5b3          	divu	a1,a1,a2
 b00:	0685                	addi	a3,a3,1
 b02:	fec7f1e3          	bgeu	a5,a2,ae4 <printint+0x2a>
  if(neg)
 b06:	00030c63          	beqz	t1,b1e <printint+0x64>
    buf[i++] = '-';
 b0a:	fd050793          	addi	a5,a0,-48
 b0e:	00878533          	add	a0,a5,s0
 b12:	02d00793          	li	a5,45
 b16:	fef50423          	sb	a5,-24(a0)
 b1a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 b1e:	02e05563          	blez	a4,b48 <printint+0x8e>
 b22:	fc26                	sd	s1,56(sp)
 b24:	377d                	addiw	a4,a4,-1
 b26:	00e984b3          	add	s1,s3,a4
 b2a:	19fd                	addi	s3,s3,-1
 b2c:	99ba                	add	s3,s3,a4
 b2e:	1702                	slli	a4,a4,0x20
 b30:	9301                	srli	a4,a4,0x20
 b32:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 b36:	0004c583          	lbu	a1,0(s1)
 b3a:	854a                	mv	a0,s2
 b3c:	f61ff0ef          	jal	a9c <putc>
  while(--i >= 0)
 b40:	14fd                	addi	s1,s1,-1
 b42:	ff349ae3          	bne	s1,s3,b36 <printint+0x7c>
 b46:	74e2                	ld	s1,56(sp)
}
 b48:	60a6                	ld	ra,72(sp)
 b4a:	6406                	ld	s0,64(sp)
 b4c:	7942                	ld	s2,48(sp)
 b4e:	79a2                	ld	s3,40(sp)
 b50:	6161                	addi	sp,sp,80
 b52:	8082                	ret
  neg = 0;
 b54:	4301                	li	t1,0
 b56:	bfbd                	j	ad4 <printint+0x1a>

0000000000000b58 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 b58:	711d                	addi	sp,sp,-96
 b5a:	ec86                	sd	ra,88(sp)
 b5c:	e8a2                	sd	s0,80(sp)
 b5e:	e4a6                	sd	s1,72(sp)
 b60:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 b62:	0005c483          	lbu	s1,0(a1)
 b66:	22048363          	beqz	s1,d8c <vprintf+0x234>
 b6a:	e0ca                	sd	s2,64(sp)
 b6c:	fc4e                	sd	s3,56(sp)
 b6e:	f852                	sd	s4,48(sp)
 b70:	f456                	sd	s5,40(sp)
 b72:	f05a                	sd	s6,32(sp)
 b74:	ec5e                	sd	s7,24(sp)
 b76:	e862                	sd	s8,16(sp)
 b78:	8b2a                	mv	s6,a0
 b7a:	8a2e                	mv	s4,a1
 b7c:	8bb2                	mv	s7,a2
  state = 0;
 b7e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 b80:	4901                	li	s2,0
 b82:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 b84:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 b88:	06400c13          	li	s8,100
 b8c:	a00d                	j	bae <vprintf+0x56>
        putc(fd, c0);
 b8e:	85a6                	mv	a1,s1
 b90:	855a                	mv	a0,s6
 b92:	f0bff0ef          	jal	a9c <putc>
 b96:	a019                	j	b9c <vprintf+0x44>
    } else if(state == '%'){
 b98:	03598363          	beq	s3,s5,bbe <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 b9c:	0019079b          	addiw	a5,s2,1
 ba0:	893e                	mv	s2,a5
 ba2:	873e                	mv	a4,a5
 ba4:	97d2                	add	a5,a5,s4
 ba6:	0007c483          	lbu	s1,0(a5)
 baa:	1c048a63          	beqz	s1,d7e <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 bae:	0004879b          	sext.w	a5,s1
    if(state == 0){
 bb2:	fe0993e3          	bnez	s3,b98 <vprintf+0x40>
      if(c0 == '%'){
 bb6:	fd579ce3          	bne	a5,s5,b8e <vprintf+0x36>
        state = '%';
 bba:	89be                	mv	s3,a5
 bbc:	b7c5                	j	b9c <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 bbe:	00ea06b3          	add	a3,s4,a4
 bc2:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 bc6:	1c060863          	beqz	a2,d96 <vprintf+0x23e>
      if(c0 == 'd'){
 bca:	03878763          	beq	a5,s8,bf8 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 bce:	f9478693          	addi	a3,a5,-108
 bd2:	0016b693          	seqz	a3,a3
 bd6:	f9c60593          	addi	a1,a2,-100
 bda:	e99d                	bnez	a1,c10 <vprintf+0xb8>
 bdc:	ca95                	beqz	a3,c10 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 bde:	008b8493          	addi	s1,s7,8
 be2:	4685                	li	a3,1
 be4:	4629                	li	a2,10
 be6:	000bb583          	ld	a1,0(s7)
 bea:	855a                	mv	a0,s6
 bec:	ecfff0ef          	jal	aba <printint>
        i += 1;
 bf0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 bf2:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 bf4:	4981                	li	s3,0
 bf6:	b75d                	j	b9c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 bf8:	008b8493          	addi	s1,s7,8
 bfc:	4685                	li	a3,1
 bfe:	4629                	li	a2,10
 c00:	000ba583          	lw	a1,0(s7)
 c04:	855a                	mv	a0,s6
 c06:	eb5ff0ef          	jal	aba <printint>
 c0a:	8ba6                	mv	s7,s1
      state = 0;
 c0c:	4981                	li	s3,0
 c0e:	b779                	j	b9c <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 c10:	9752                	add	a4,a4,s4
 c12:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 c16:	f9460713          	addi	a4,a2,-108
 c1a:	00173713          	seqz	a4,a4
 c1e:	8f75                	and	a4,a4,a3
 c20:	f9c58513          	addi	a0,a1,-100
 c24:	18051363          	bnez	a0,daa <vprintf+0x252>
 c28:	18070163          	beqz	a4,daa <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 c2c:	008b8493          	addi	s1,s7,8
 c30:	4685                	li	a3,1
 c32:	4629                	li	a2,10
 c34:	000bb583          	ld	a1,0(s7)
 c38:	855a                	mv	a0,s6
 c3a:	e81ff0ef          	jal	aba <printint>
        i += 2;
 c3e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 c40:	8ba6                	mv	s7,s1
      state = 0;
 c42:	4981                	li	s3,0
        i += 2;
 c44:	bfa1                	j	b9c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 c46:	008b8493          	addi	s1,s7,8
 c4a:	4681                	li	a3,0
 c4c:	4629                	li	a2,10
 c4e:	000be583          	lwu	a1,0(s7)
 c52:	855a                	mv	a0,s6
 c54:	e67ff0ef          	jal	aba <printint>
 c58:	8ba6                	mv	s7,s1
      state = 0;
 c5a:	4981                	li	s3,0
 c5c:	b781                	j	b9c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 c5e:	008b8493          	addi	s1,s7,8
 c62:	4681                	li	a3,0
 c64:	4629                	li	a2,10
 c66:	000bb583          	ld	a1,0(s7)
 c6a:	855a                	mv	a0,s6
 c6c:	e4fff0ef          	jal	aba <printint>
        i += 1;
 c70:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 c72:	8ba6                	mv	s7,s1
      state = 0;
 c74:	4981                	li	s3,0
 c76:	b71d                	j	b9c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 c78:	008b8493          	addi	s1,s7,8
 c7c:	4681                	li	a3,0
 c7e:	4629                	li	a2,10
 c80:	000bb583          	ld	a1,0(s7)
 c84:	855a                	mv	a0,s6
 c86:	e35ff0ef          	jal	aba <printint>
        i += 2;
 c8a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 c8c:	8ba6                	mv	s7,s1
      state = 0;
 c8e:	4981                	li	s3,0
        i += 2;
 c90:	b731                	j	b9c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 c92:	008b8493          	addi	s1,s7,8
 c96:	4681                	li	a3,0
 c98:	4641                	li	a2,16
 c9a:	000be583          	lwu	a1,0(s7)
 c9e:	855a                	mv	a0,s6
 ca0:	e1bff0ef          	jal	aba <printint>
 ca4:	8ba6                	mv	s7,s1
      state = 0;
 ca6:	4981                	li	s3,0
 ca8:	bdd5                	j	b9c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 caa:	008b8493          	addi	s1,s7,8
 cae:	4681                	li	a3,0
 cb0:	4641                	li	a2,16
 cb2:	000bb583          	ld	a1,0(s7)
 cb6:	855a                	mv	a0,s6
 cb8:	e03ff0ef          	jal	aba <printint>
        i += 1;
 cbc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 cbe:	8ba6                	mv	s7,s1
      state = 0;
 cc0:	4981                	li	s3,0
 cc2:	bde9                	j	b9c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 cc4:	008b8493          	addi	s1,s7,8
 cc8:	4681                	li	a3,0
 cca:	4641                	li	a2,16
 ccc:	000bb583          	ld	a1,0(s7)
 cd0:	855a                	mv	a0,s6
 cd2:	de9ff0ef          	jal	aba <printint>
        i += 2;
 cd6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 cd8:	8ba6                	mv	s7,s1
      state = 0;
 cda:	4981                	li	s3,0
        i += 2;
 cdc:	b5c1                	j	b9c <vprintf+0x44>
 cde:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 ce0:	008b8793          	addi	a5,s7,8
 ce4:	8cbe                	mv	s9,a5
 ce6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 cea:	03000593          	li	a1,48
 cee:	855a                	mv	a0,s6
 cf0:	dadff0ef          	jal	a9c <putc>
  putc(fd, 'x');
 cf4:	07800593          	li	a1,120
 cf8:	855a                	mv	a0,s6
 cfa:	da3ff0ef          	jal	a9c <putc>
 cfe:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 d00:	00001b97          	auipc	s7,0x1
 d04:	a88b8b93          	addi	s7,s7,-1400 # 1788 <digits>
 d08:	03c9d793          	srli	a5,s3,0x3c
 d0c:	97de                	add	a5,a5,s7
 d0e:	0007c583          	lbu	a1,0(a5)
 d12:	855a                	mv	a0,s6
 d14:	d89ff0ef          	jal	a9c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 d18:	0992                	slli	s3,s3,0x4
 d1a:	34fd                	addiw	s1,s1,-1
 d1c:	f4f5                	bnez	s1,d08 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 d1e:	8be6                	mv	s7,s9
      state = 0;
 d20:	4981                	li	s3,0
 d22:	6ca2                	ld	s9,8(sp)
 d24:	bda5                	j	b9c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 d26:	008b8493          	addi	s1,s7,8
 d2a:	000bc583          	lbu	a1,0(s7)
 d2e:	855a                	mv	a0,s6
 d30:	d6dff0ef          	jal	a9c <putc>
 d34:	8ba6                	mv	s7,s1
      state = 0;
 d36:	4981                	li	s3,0
 d38:	b595                	j	b9c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 d3a:	008b8993          	addi	s3,s7,8
 d3e:	000bb483          	ld	s1,0(s7)
 d42:	cc91                	beqz	s1,d5e <vprintf+0x206>
        for(; *s; s++)
 d44:	0004c583          	lbu	a1,0(s1)
 d48:	c985                	beqz	a1,d78 <vprintf+0x220>
          putc(fd, *s);
 d4a:	855a                	mv	a0,s6
 d4c:	d51ff0ef          	jal	a9c <putc>
        for(; *s; s++)
 d50:	0485                	addi	s1,s1,1
 d52:	0004c583          	lbu	a1,0(s1)
 d56:	f9f5                	bnez	a1,d4a <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 d58:	8bce                	mv	s7,s3
      state = 0;
 d5a:	4981                	li	s3,0
 d5c:	b581                	j	b9c <vprintf+0x44>
          s = "(null)";
 d5e:	00001497          	auipc	s1,0x1
 d62:	a2248493          	addi	s1,s1,-1502 # 1780 <malloc+0x886>
        for(; *s; s++)
 d66:	02800593          	li	a1,40
 d6a:	b7c5                	j	d4a <vprintf+0x1f2>
        putc(fd, '%');
 d6c:	85be                	mv	a1,a5
 d6e:	855a                	mv	a0,s6
 d70:	d2dff0ef          	jal	a9c <putc>
      state = 0;
 d74:	4981                	li	s3,0
 d76:	b51d                	j	b9c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 d78:	8bce                	mv	s7,s3
      state = 0;
 d7a:	4981                	li	s3,0
 d7c:	b505                	j	b9c <vprintf+0x44>
 d7e:	6906                	ld	s2,64(sp)
 d80:	79e2                	ld	s3,56(sp)
 d82:	7a42                	ld	s4,48(sp)
 d84:	7aa2                	ld	s5,40(sp)
 d86:	7b02                	ld	s6,32(sp)
 d88:	6be2                	ld	s7,24(sp)
 d8a:	6c42                	ld	s8,16(sp)
    }
  }
}
 d8c:	60e6                	ld	ra,88(sp)
 d8e:	6446                	ld	s0,80(sp)
 d90:	64a6                	ld	s1,72(sp)
 d92:	6125                	addi	sp,sp,96
 d94:	8082                	ret
      if(c0 == 'd'){
 d96:	06400713          	li	a4,100
 d9a:	e4e78fe3          	beq	a5,a4,bf8 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 d9e:	f9478693          	addi	a3,a5,-108
 da2:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 da6:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 da8:	4701                	li	a4,0
      } else if(c0 == 'u'){
 daa:	07500513          	li	a0,117
 dae:	e8a78ce3          	beq	a5,a0,c46 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 db2:	f8b60513          	addi	a0,a2,-117
 db6:	e119                	bnez	a0,dbc <vprintf+0x264>
 db8:	ea0693e3          	bnez	a3,c5e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 dbc:	f8b58513          	addi	a0,a1,-117
 dc0:	e119                	bnez	a0,dc6 <vprintf+0x26e>
 dc2:	ea071be3          	bnez	a4,c78 <vprintf+0x120>
      } else if(c0 == 'x'){
 dc6:	07800513          	li	a0,120
 dca:	eca784e3          	beq	a5,a0,c92 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 dce:	f8860613          	addi	a2,a2,-120
 dd2:	e219                	bnez	a2,dd8 <vprintf+0x280>
 dd4:	ec069be3          	bnez	a3,caa <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 dd8:	f8858593          	addi	a1,a1,-120
 ddc:	e199                	bnez	a1,de2 <vprintf+0x28a>
 dde:	ee0713e3          	bnez	a4,cc4 <vprintf+0x16c>
      } else if(c0 == 'p'){
 de2:	07000713          	li	a4,112
 de6:	eee78ce3          	beq	a5,a4,cde <vprintf+0x186>
      } else if(c0 == 'c'){
 dea:	06300713          	li	a4,99
 dee:	f2e78ce3          	beq	a5,a4,d26 <vprintf+0x1ce>
      } else if(c0 == 's'){
 df2:	07300713          	li	a4,115
 df6:	f4e782e3          	beq	a5,a4,d3a <vprintf+0x1e2>
      } else if(c0 == '%'){
 dfa:	02500713          	li	a4,37
 dfe:	f6e787e3          	beq	a5,a4,d6c <vprintf+0x214>
        putc(fd, '%');
 e02:	02500593          	li	a1,37
 e06:	855a                	mv	a0,s6
 e08:	c95ff0ef          	jal	a9c <putc>
        putc(fd, c0);
 e0c:	85a6                	mv	a1,s1
 e0e:	855a                	mv	a0,s6
 e10:	c8dff0ef          	jal	a9c <putc>
      state = 0;
 e14:	4981                	li	s3,0
 e16:	b359                	j	b9c <vprintf+0x44>

0000000000000e18 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 e18:	715d                	addi	sp,sp,-80
 e1a:	ec06                	sd	ra,24(sp)
 e1c:	e822                	sd	s0,16(sp)
 e1e:	1000                	addi	s0,sp,32
 e20:	e010                	sd	a2,0(s0)
 e22:	e414                	sd	a3,8(s0)
 e24:	e818                	sd	a4,16(s0)
 e26:	ec1c                	sd	a5,24(s0)
 e28:	03043023          	sd	a6,32(s0)
 e2c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 e30:	8622                	mv	a2,s0
 e32:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 e36:	d23ff0ef          	jal	b58 <vprintf>
}
 e3a:	60e2                	ld	ra,24(sp)
 e3c:	6442                	ld	s0,16(sp)
 e3e:	6161                	addi	sp,sp,80
 e40:	8082                	ret

0000000000000e42 <printf>:

void
printf(const char *fmt, ...)
{
 e42:	711d                	addi	sp,sp,-96
 e44:	ec06                	sd	ra,24(sp)
 e46:	e822                	sd	s0,16(sp)
 e48:	1000                	addi	s0,sp,32
 e4a:	e40c                	sd	a1,8(s0)
 e4c:	e810                	sd	a2,16(s0)
 e4e:	ec14                	sd	a3,24(s0)
 e50:	f018                	sd	a4,32(s0)
 e52:	f41c                	sd	a5,40(s0)
 e54:	03043823          	sd	a6,48(s0)
 e58:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 e5c:	00840613          	addi	a2,s0,8
 e60:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 e64:	85aa                	mv	a1,a0
 e66:	4505                	li	a0,1
 e68:	cf1ff0ef          	jal	b58 <vprintf>
}
 e6c:	60e2                	ld	ra,24(sp)
 e6e:	6442                	ld	s0,16(sp)
 e70:	6125                	addi	sp,sp,96
 e72:	8082                	ret

0000000000000e74 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e74:	1141                	addi	sp,sp,-16
 e76:	e406                	sd	ra,8(sp)
 e78:	e022                	sd	s0,0(sp)
 e7a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 e7c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e80:	00001797          	auipc	a5,0x1
 e84:	1887b783          	ld	a5,392(a5) # 2008 <freep>
 e88:	a039                	j	e96 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e8a:	6398                	ld	a4,0(a5)
 e8c:	00e7e463          	bltu	a5,a4,e94 <free+0x20>
 e90:	00e6ea63          	bltu	a3,a4,ea4 <free+0x30>
{
 e94:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e96:	fed7fae3          	bgeu	a5,a3,e8a <free+0x16>
 e9a:	6398                	ld	a4,0(a5)
 e9c:	00e6e463          	bltu	a3,a4,ea4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ea0:	fee7eae3          	bltu	a5,a4,e94 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ea4:	ff852583          	lw	a1,-8(a0)
 ea8:	6390                	ld	a2,0(a5)
 eaa:	02059813          	slli	a6,a1,0x20
 eae:	01c85713          	srli	a4,a6,0x1c
 eb2:	9736                	add	a4,a4,a3
 eb4:	02e60563          	beq	a2,a4,ede <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 eb8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 ebc:	4790                	lw	a2,8(a5)
 ebe:	02061593          	slli	a1,a2,0x20
 ec2:	01c5d713          	srli	a4,a1,0x1c
 ec6:	973e                	add	a4,a4,a5
 ec8:	02e68263          	beq	a3,a4,eec <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 ecc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ece:	00001717          	auipc	a4,0x1
 ed2:	12f73d23          	sd	a5,314(a4) # 2008 <freep>
}
 ed6:	60a2                	ld	ra,8(sp)
 ed8:	6402                	ld	s0,0(sp)
 eda:	0141                	addi	sp,sp,16
 edc:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 ede:	4618                	lw	a4,8(a2)
 ee0:	9f2d                	addw	a4,a4,a1
 ee2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ee6:	6398                	ld	a4,0(a5)
 ee8:	6310                	ld	a2,0(a4)
 eea:	b7f9                	j	eb8 <free+0x44>
    p->s.size += bp->s.size;
 eec:	ff852703          	lw	a4,-8(a0)
 ef0:	9f31                	addw	a4,a4,a2
 ef2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ef4:	ff053683          	ld	a3,-16(a0)
 ef8:	bfd1                	j	ecc <free+0x58>

0000000000000efa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 efa:	7139                	addi	sp,sp,-64
 efc:	fc06                	sd	ra,56(sp)
 efe:	f822                	sd	s0,48(sp)
 f00:	f04a                	sd	s2,32(sp)
 f02:	ec4e                	sd	s3,24(sp)
 f04:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 f06:	02051993          	slli	s3,a0,0x20
 f0a:	0209d993          	srli	s3,s3,0x20
 f0e:	09bd                	addi	s3,s3,15
 f10:	0049d993          	srli	s3,s3,0x4
 f14:	2985                	addiw	s3,s3,1
 f16:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 f18:	00001517          	auipc	a0,0x1
 f1c:	0f053503          	ld	a0,240(a0) # 2008 <freep>
 f20:	c905                	beqz	a0,f50 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f22:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 f24:	4798                	lw	a4,8(a5)
 f26:	09377663          	bgeu	a4,s3,fb2 <malloc+0xb8>
 f2a:	f426                	sd	s1,40(sp)
 f2c:	e852                	sd	s4,16(sp)
 f2e:	e456                	sd	s5,8(sp)
 f30:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 f32:	8a4e                	mv	s4,s3
 f34:	6705                	lui	a4,0x1
 f36:	00e9f363          	bgeu	s3,a4,f3c <malloc+0x42>
 f3a:	6a05                	lui	s4,0x1
 f3c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 f40:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 f44:	00001497          	auipc	s1,0x1
 f48:	0c448493          	addi	s1,s1,196 # 2008 <freep>
  if(p == SBRK_ERROR)
 f4c:	5afd                	li	s5,-1
 f4e:	a83d                	j	f8c <malloc+0x92>
 f50:	f426                	sd	s1,40(sp)
 f52:	e852                	sd	s4,16(sp)
 f54:	e456                	sd	s5,8(sp)
 f56:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 f58:	00001797          	auipc	a5,0x1
 f5c:	0b878793          	addi	a5,a5,184 # 2010 <base>
 f60:	00001717          	auipc	a4,0x1
 f64:	0af73423          	sd	a5,168(a4) # 2008 <freep>
 f68:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 f6a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 f6e:	b7d1                	j	f32 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 f70:	6398                	ld	a4,0(a5)
 f72:	e118                	sd	a4,0(a0)
 f74:	a899                	j	fca <malloc+0xd0>
  hp->s.size = nu;
 f76:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 f7a:	0541                	addi	a0,a0,16
 f7c:	ef9ff0ef          	jal	e74 <free>
  return freep;
 f80:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 f82:	c125                	beqz	a0,fe2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f84:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 f86:	4798                	lw	a4,8(a5)
 f88:	03277163          	bgeu	a4,s2,faa <malloc+0xb0>
    if(p == freep)
 f8c:	6098                	ld	a4,0(s1)
 f8e:	853e                	mv	a0,a5
 f90:	fef71ae3          	bne	a4,a5,f84 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 f94:	8552                	mv	a0,s4
 f96:	9e3ff0ef          	jal	978 <sbrk>
  if(p == SBRK_ERROR)
 f9a:	fd551ee3          	bne	a0,s5,f76 <malloc+0x7c>
        return 0;
 f9e:	4501                	li	a0,0
 fa0:	74a2                	ld	s1,40(sp)
 fa2:	6a42                	ld	s4,16(sp)
 fa4:	6aa2                	ld	s5,8(sp)
 fa6:	6b02                	ld	s6,0(sp)
 fa8:	a03d                	j	fd6 <malloc+0xdc>
 faa:	74a2                	ld	s1,40(sp)
 fac:	6a42                	ld	s4,16(sp)
 fae:	6aa2                	ld	s5,8(sp)
 fb0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 fb2:	fae90fe3          	beq	s2,a4,f70 <malloc+0x76>
        p->s.size -= nunits;
 fb6:	4137073b          	subw	a4,a4,s3
 fba:	c798                	sw	a4,8(a5)
        p += p->s.size;
 fbc:	02071693          	slli	a3,a4,0x20
 fc0:	01c6d713          	srli	a4,a3,0x1c
 fc4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 fc6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 fca:	00001717          	auipc	a4,0x1
 fce:	02a73f23          	sd	a0,62(a4) # 2008 <freep>
      return (void*)(p + 1);
 fd2:	01078513          	addi	a0,a5,16
  }
}
 fd6:	70e2                	ld	ra,56(sp)
 fd8:	7442                	ld	s0,48(sp)
 fda:	7902                	ld	s2,32(sp)
 fdc:	69e2                	ld	s3,24(sp)
 fde:	6121                	addi	sp,sp,64
 fe0:	8082                	ret
 fe2:	74a2                	ld	s1,40(sp)
 fe4:	6a42                	ld	s4,16(sp)
 fe6:	6aa2                	ld	s5,8(sp)
 fe8:	6b02                	ld	s6,0(sp)
 fea:	b7f5                	j	fd6 <malloc+0xdc>
