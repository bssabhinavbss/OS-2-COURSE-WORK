
user/_raidtest:     file format elf64-littleriscv


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
    p[j] = (char)((page * 19 + j * 11 + seed * 37) & 0xFF);
       8:	0025979b          	slliw	a5,a1,0x2
       c:	9fad                	addw	a5,a5,a1
       e:	0027979b          	slliw	a5,a5,0x2
      12:	9f8d                	subw	a5,a5,a1
      14:	0036171b          	slliw	a4,a2,0x3
      18:	9f31                	addw	a4,a4,a2
      1a:	0027171b          	slliw	a4,a4,0x2
      1e:	9f31                	addw	a4,a4,a2
      20:	9fb9                	addw	a5,a5,a4
      22:	0ff7f793          	zext.b	a5,a5
      26:	872a                	mv	a4,a0
      28:	6685                	lui	a3,0x1
      2a:	96aa                	add	a3,a3,a0
      2c:	00f70023          	sb	a5,0(a4)
  for(int j = 0; j < PAGE_SIZE; j++)
      30:	27ad                	addiw	a5,a5,11
      32:	0ff7f793          	zext.b	a5,a5
      36:	0705                	addi	a4,a4,1
      38:	fed71ae3          	bne	a4,a3,2c <fill+0x2c>
}
      3c:	60a2                	ld	ra,8(sp)
      3e:	6402                	ld	s0,0(sp)
      40:	0141                	addi	sp,sp,16
      42:	8082                	ret

0000000000000044 <verify_range>:

static int
verify_range(char *base, int start, int npages, int seed)
{
      44:	1141                	addi	sp,sp,-16
      46:	e406                	sd	ra,8(sp)
      48:	e022                	sd	s0,0(sp)
      4a:	0800                	addi	s0,sp,16
  for(int i = start; i < start + npages; i++)
      4c:	06c05163          	blez	a2,ae <verify_range+0x6a>
      50:	00c5883b          	addw	a6,a1,a2
      54:	6785                	lui	a5,0x1
      56:	953e                	add	a0,a0,a5
      58:	00c59793          	slli	a5,a1,0xc
      5c:	00f50633          	add	a2,a0,a5
    for(int j = 0; j < PAGE_SIZE; j++){
      char exp = (char)((i * 19 + j * 11 + seed * 37) & 0xFF);
      60:	0036951b          	slliw	a0,a3,0x3
      64:	9d35                	addw	a0,a0,a3
      66:	0025151b          	slliw	a0,a0,0x2
      6a:	9d35                	addw	a0,a0,a3
      6c:	0025979b          	slliw	a5,a1,0x2
      70:	9fad                	addw	a5,a5,a1
      72:	0027979b          	slliw	a5,a5,0x2
      76:	9f8d                	subw	a5,a5,a1
      78:	9d3d                	addw	a0,a0,a5
      7a:	0ff57513          	zext.b	a0,a0
      7e:	78fd                	lui	a7,0xfffff
    for(int j = 0; j < PAGE_SIZE; j++){
      80:	01160733          	add	a4,a2,a7
{
      84:	87aa                	mv	a5,a0
      if(base[i * PAGE_SIZE + j] != exp) return 0;
      86:	00074683          	lbu	a3,0(a4)
      8a:	02f69463          	bne	a3,a5,b2 <verify_range+0x6e>
    for(int j = 0; j < PAGE_SIZE; j++){
      8e:	0705                	addi	a4,a4,1
      90:	27ad                	addiw	a5,a5,11 # 100b <malloc+0xe1>
      92:	0ff7f793          	zext.b	a5,a5
      96:	fec718e3          	bne	a4,a2,86 <verify_range+0x42>
  for(int i = start; i < start + npages; i++)
      9a:	2585                	addiw	a1,a1,1
      9c:	6785                	lui	a5,0x1
      9e:	963e                	add	a2,a2,a5
      a0:	254d                	addiw	a0,a0,19
      a2:	0ff57513          	zext.b	a0,a0
      a6:	fd05cde3          	blt	a1,a6,80 <verify_range+0x3c>
    }
  return 1;
      aa:	4505                	li	a0,1
      ac:	a021                	j	b4 <verify_range+0x70>
      ae:	4505                	li	a0,1
      b0:	a011                	j	b4 <verify_range+0x70>
      if(base[i * PAGE_SIZE + j] != exp) return 0;
      b2:	4501                	li	a0,0
}
      b4:	60a2                	ld	ra,8(sp)
      b6:	6402                	ld	s0,0(sp)
      b8:	0141                	addi	sp,sp,16
      ba:	8082                	ret

00000000000000bc <result>:
{
      bc:	1141                	addi	sp,sp,-16
      be:	e406                	sd	ra,8(sp)
      c0:	e022                	sd	s0,0(sp)
      c2:	0800                	addi	s0,sp,16
  if(ok){ printf("  PASS: %s\n", name); total_pass++; }
      c4:	c19d                	beqz	a1,ea <result+0x2e>
      c6:	85aa                	mv	a1,a0
      c8:	00001517          	auipc	a0,0x1
      cc:	f5850513          	addi	a0,a0,-168 # 1020 <malloc+0xf6>
      d0:	5a3000ef          	jal	e72 <printf>
      d4:	00002717          	auipc	a4,0x2
      d8:	f3070713          	addi	a4,a4,-208 # 2004 <total_pass>
      dc:	431c                	lw	a5,0(a4)
      de:	2785                	addiw	a5,a5,1 # 1001 <malloc+0xd7>
      e0:	c31c                	sw	a5,0(a4)
}
      e2:	60a2                	ld	ra,8(sp)
      e4:	6402                	ld	s0,0(sp)
      e6:	0141                	addi	sp,sp,16
      e8:	8082                	ret
  else  { printf("  FAIL: %s\n", name); total_fail++; }
      ea:	85aa                	mv	a1,a0
      ec:	00001517          	auipc	a0,0x1
      f0:	f4450513          	addi	a0,a0,-188 # 1030 <malloc+0x106>
      f4:	57f000ef          	jal	e72 <printf>
      f8:	00002717          	auipc	a4,0x2
      fc:	f0870713          	addi	a4,a4,-248 # 2000 <total_fail>
     100:	431c                	lw	a5,0(a4)
     102:	2785                	addiw	a5,a5,1
     104:	c31c                	sw	a5,0(a4)
}
     106:	bff1                	j	e2 <result+0x26>

0000000000000108 <cycle>:

// Perform a full write-evict-readback cycle; return 1 if data correct
static int
cycle(int npages, int seed)
{
     108:	715d                	addi	sp,sp,-80
     10a:	e486                	sd	ra,72(sp)
     10c:	e0a2                	sd	s0,64(sp)
     10e:	fc26                	sd	s1,56(sp)
     110:	f84a                	sd	s2,48(sp)
     112:	f052                	sd	s4,32(sp)
     114:	0880                	addi	s0,sp,80
     116:	892a                	mv	s2,a0
     118:	84ae                	mv	s1,a1
  char *base = sbrk(npages * PAGE_SIZE);
     11a:	00c51a1b          	slliw	s4,a0,0xc
     11e:	8552                	mv	a0,s4
     120:	089000ef          	jal	9a8 <sbrk>
  if(base == (char*)-1) return -1;
     124:	57fd                	li	a5,-1
     126:	08f50463          	beq	a0,a5,1ae <cycle+0xa6>
     12a:	f44e                	sd	s3,40(sp)
     12c:	89aa                	mv	s3,a0

  for(int i = 0; i < npages; i++) fill(base + i*PAGE_SIZE, i, seed);
     12e:	03205463          	blez	s2,156 <cycle+0x4e>
     132:	ec56                	sd	s5,24(sp)
     134:	e85a                	sd	s6,16(sp)
     136:	e45e                	sd	s7,8(sp)
     138:	8b2a                	mv	s6,a0
     13a:	4a81                	li	s5,0
     13c:	6b85                	lui	s7,0x1
     13e:	8626                	mv	a2,s1
     140:	85d6                	mv	a1,s5
     142:	855a                	mv	a0,s6
     144:	ebdff0ef          	jal	0 <fill>
     148:	2a85                	addiw	s5,s5,1
     14a:	9b5e                	add	s6,s6,s7
     14c:	ff5919e3          	bne	s2,s5,13e <cycle+0x36>
     150:	6ae2                	ld	s5,24(sp)
     152:	6b42                	ld	s6,16(sp)
     154:	6ba2                	ld	s7,8(sp)

  // eviction pressure
  char *p = sbrk(PRESSURE * PAGE_SIZE);
     156:	00048537          	lui	a0,0x48
     15a:	04f000ef          	jal	9a8 <sbrk>
     15e:	872a                	mv	a4,a0
  if(p != (char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=(char)(i^seed); sbrk(-(PRESSURE*PAGE_SIZE)); }
     160:	57fd                	li	a5,-1
     162:	02f50263          	beq	a0,a5,186 <cycle+0x7e>
     166:	4781                	li	a5,0
     168:	6585                	lui	a1,0x1
     16a:	04800613          	li	a2,72
     16e:	0097c6b3          	xor	a3,a5,s1
     172:	00d70023          	sb	a3,0(a4)
     176:	2785                	addiw	a5,a5,1
     178:	972e                	add	a4,a4,a1
     17a:	fec79ae3          	bne	a5,a2,16e <cycle+0x66>
     17e:	fffb8537          	lui	a0,0xfffb8
     182:	027000ef          	jal	9a8 <sbrk>

  int ok = verify_range(base, 0, npages, seed);
     186:	86a6                	mv	a3,s1
     188:	864a                	mv	a2,s2
     18a:	4581                	li	a1,0
     18c:	854e                	mv	a0,s3
     18e:	eb7ff0ef          	jal	44 <verify_range>
     192:	84aa                	mv	s1,a0
  sbrk(-(npages * PAGE_SIZE));
     194:	4140053b          	negw	a0,s4
     198:	011000ef          	jal	9a8 <sbrk>
  return ok;
     19c:	79a2                	ld	s3,40(sp)
}
     19e:	8526                	mv	a0,s1
     1a0:	60a6                	ld	ra,72(sp)
     1a2:	6406                	ld	s0,64(sp)
     1a4:	74e2                	ld	s1,56(sp)
     1a6:	7942                	ld	s2,48(sp)
     1a8:	7a02                	ld	s4,32(sp)
     1aa:	6161                	addi	sp,sp,80
     1ac:	8082                	ret
  if(base == (char*)-1) return -1;
     1ae:	54fd                	li	s1,-1
     1b0:	b7fd                	j	19e <cycle+0x96>

00000000000001b2 <main>:
}

// ── main ──────────────────────────────────────────────────────────────────
int
main(void)
{
     1b2:	7135                	addi	sp,sp,-160
     1b4:	ed06                	sd	ra,152(sp)
     1b6:	e922                	sd	s0,144(sp)
     1b8:	e526                	sd	s1,136(sp)
     1ba:	e14a                	sd	s2,128(sp)
     1bc:	fcce                	sd	s3,120(sp)
     1be:	f8d2                	sd	s4,112(sp)
     1c0:	f4d6                	sd	s5,104(sp)
     1c2:	f0da                	sd	s6,96(sp)
     1c4:	1100                	addi	s0,sp,160
  printf("=== raidtest (rigorous) ===\n");
     1c6:	00001517          	auipc	a0,0x1
     1ca:	e7a50513          	addi	a0,a0,-390 # 1040 <malloc+0x116>
     1ce:	4a5000ef          	jal	e72 <printf>
  printf("\n[T1] RAID-0 data integrity\n");
     1d2:	00001517          	auipc	a0,0x1
     1d6:	e8e50513          	addi	a0,a0,-370 # 1060 <malloc+0x136>
     1da:	499000ef          	jal	e72 <printf>
  result("RAID-0: 64-page cycle correct", cycle(WORK_PAGES, 10) == 1);
     1de:	45a9                	li	a1,10
     1e0:	04000513          	li	a0,64
     1e4:	f25ff0ef          	jal	108 <cycle>
     1e8:	fff50593          	addi	a1,a0,-1
     1ec:	0015b593          	seqz	a1,a1
     1f0:	00001517          	auipc	a0,0x1
     1f4:	e9050513          	addi	a0,a0,-368 # 1080 <malloc+0x156>
     1f8:	ec5ff0ef          	jal	bc <result>
  printf("\n[T2] RAID-0: writes recorded for evicted pages\n");
     1fc:	00001517          	auipc	a0,0x1
     200:	ea450513          	addi	a0,a0,-348 # 10a0 <malloc+0x176>
     204:	46f000ef          	jal	e72 <printf>
  struct vmstats before; getvmstats(getpid(), &before);
     208:	055000ef          	jal	a5c <getpid>
     20c:	f6040593          	addi	a1,s0,-160
     210:	0ad000ef          	jal	abc <getvmstats>
  char *base = sbrk(WORK_PAGES * PAGE_SIZE);
     214:	00040537          	lui	a0,0x40
     218:	790000ef          	jal	9a8 <sbrk>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     21c:	577d                	li	a4,-1
     21e:	892a                	mv	s2,a0
  for(int i=0;i<WORK_PAGES;i++) fill(base+i*PAGE_SIZE,i,11);
     220:	4481                	li	s1,0
     222:	4aad                	li	s5,11
     224:	6a05                	lui	s4,0x1
     226:	04000993          	li	s3,64
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     22a:	18e50363          	beq	a0,a4,3b0 <main+0x1fe>
  for(int i=0;i<WORK_PAGES;i++) fill(base+i*PAGE_SIZE,i,11);
     22e:	8656                	mv	a2,s5
     230:	85a6                	mv	a1,s1
     232:	854a                	mv	a0,s2
     234:	dcdff0ef          	jal	0 <fill>
     238:	2485                	addiw	s1,s1,1
     23a:	9952                	add	s2,s2,s4
     23c:	ff3499e3          	bne	s1,s3,22e <main+0x7c>
  char *p = sbrk(PRESSURE*PAGE_SIZE);
     240:	00048537          	lui	a0,0x48
     244:	764000ef          	jal	9a8 <sbrk>
  if(p!=(char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     248:	57fd                	li	a5,-1
     24a:	02f50163          	beq	a0,a5,26c <main+0xba>
     24e:	87aa                	mv	a5,a0
     250:	000486b7          	lui	a3,0x48
     254:	00d50733          	add	a4,a0,a3
     258:	6685                	lui	a3,0x1
     25a:	00078023          	sb	zero,0(a5)
     25e:	97b6                	add	a5,a5,a3
     260:	fee79de3          	bne	a5,a4,25a <main+0xa8>
     264:	fffb8537          	lui	a0,0xfffb8
     268:	740000ef          	jal	9a8 <sbrk>
  struct vmstats after; getvmstats(getpid(), &after);
     26c:	7f0000ef          	jal	a5c <getpid>
     270:	f9040593          	addi	a1,s0,-112
     274:	049000ef          	jal	abc <getvmstats>
  sbrk(-(WORK_PAGES*PAGE_SIZE));
     278:	fffc0537          	lui	a0,0xfffc0
     27c:	72c000ef          	jal	9a8 <sbrk>
  uint64 writes = after.disk_writes - before.disk_writes;
     280:	fb043483          	ld	s1,-80(s0)
     284:	f8043783          	ld	a5,-128(s0)
     288:	8c9d                	sub	s1,s1,a5
  printf("  eviction writes=%llu  swap-in reads=%llu\n",
     28a:	fa843603          	ld	a2,-88(s0)
     28e:	f7843783          	ld	a5,-136(s0)
     292:	8e1d                	sub	a2,a2,a5
     294:	85a6                	mv	a1,s1
     296:	00001517          	auipc	a0,0x1
     29a:	e5250513          	addi	a0,a0,-430 # 10e8 <malloc+0x1be>
     29e:	3d5000ef          	jal	e72 <printf>
  result("RAID-0: eviction produced disk_writes > 0", writes > 0);
     2a2:	009035b3          	snez	a1,s1
     2a6:	00001517          	auipc	a0,0x1
     2aa:	e7250513          	addi	a0,a0,-398 # 1118 <malloc+0x1ee>
     2ae:	e0fff0ef          	jal	bc <result>
  result("RAID-0: writes >= expected minimum (32)",   writes >= 32);
     2b2:	0204b593          	sltiu	a1,s1,32
     2b6:	0015b593          	seqz	a1,a1
     2ba:	00001517          	auipc	a0,0x1
     2be:	e8e50513          	addi	a0,a0,-370 # 1148 <malloc+0x21e>
     2c2:	dfbff0ef          	jal	bc <result>
  printf("\n[T3] RAID-1: mirrored data integrity\n");
     2c6:	00001517          	auipc	a0,0x1
     2ca:	eaa50513          	addi	a0,a0,-342 # 1170 <malloc+0x246>
     2ce:	3a5000ef          	jal	e72 <printf>
  result("RAID-1/any: 64-page cycle correct", cycle(WORK_PAGES, 12) == 1);
     2d2:	45b1                	li	a1,12
     2d4:	04000513          	li	a0,64
     2d8:	e31ff0ef          	jal	108 <cycle>
     2dc:	fff50593          	addi	a1,a0,-1
     2e0:	0015b593          	seqz	a1,a1
     2e4:	00001517          	auipc	a0,0x1
     2e8:	eb450513          	addi	a0,a0,-332 # 1198 <malloc+0x26e>
     2ec:	dd1ff0ef          	jal	bc <result>
  result("RAID-1/any: second cycle correct",  cycle(WORK_PAGES, 13) == 1);
     2f0:	45b5                	li	a1,13
     2f2:	04000513          	li	a0,64
     2f6:	e13ff0ef          	jal	108 <cycle>
     2fa:	fff50593          	addi	a1,a0,-1
     2fe:	0015b593          	seqz	a1,a1
     302:	00001517          	auipc	a0,0x1
     306:	ebe50513          	addi	a0,a0,-322 # 11c0 <malloc+0x296>
     30a:	db3ff0ef          	jal	bc <result>
  printf("\n[T4] RAID-5: full-set data integrity (no failed disk)\n");
     30e:	00001517          	auipc	a0,0x1
     312:	eda50513          	addi	a0,a0,-294 # 11e8 <malloc+0x2be>
     316:	35d000ef          	jal	e72 <printf>
  result("RAID-5/any: 64-page cycle correct", cycle(WORK_PAGES, 14) == 1);
     31a:	45b9                	li	a1,14
     31c:	04000513          	li	a0,64
     320:	de9ff0ef          	jal	108 <cycle>
     324:	fff50593          	addi	a1,a0,-1
     328:	0015b593          	seqz	a1,a1
     32c:	00001517          	auipc	a0,0x1
     330:	ef450513          	addi	a0,a0,-268 # 1220 <malloc+0x2f6>
     334:	d89ff0ef          	jal	bc <result>
  printf("\n[T5] RAID-5: parity path – 80-page heavy workload\n");
     338:	00001517          	auipc	a0,0x1
     33c:	f1050513          	addi	a0,a0,-240 # 1248 <malloc+0x31e>
     340:	333000ef          	jal	e72 <printf>
  char *base = sbrk(LARGE_PAGES * PAGE_SIZE);
     344:	00050537          	lui	a0,0x50
     348:	660000ef          	jal	9a8 <sbrk>
     34c:	89aa                	mv	s3,a0
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     34e:	57fd                	li	a5,-1
     350:	892a                	mv	s2,a0
  for(int i=0;i<LARGE_PAGES;i++) fill(base+i*PAGE_SIZE,i,15);
     352:	4481                	li	s1,0
     354:	4b3d                	li	s6,15
     356:	6a85                	lui	s5,0x1
     358:	05000a13          	li	s4,80
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     35c:	06f50863          	beq	a0,a5,3cc <main+0x21a>
  for(int i=0;i<LARGE_PAGES;i++) fill(base+i*PAGE_SIZE,i,15);
     360:	865a                	mv	a2,s6
     362:	85a6                	mv	a1,s1
     364:	854a                	mv	a0,s2
     366:	c9bff0ef          	jal	0 <fill>
     36a:	2485                	addiw	s1,s1,1
     36c:	9956                	add	s2,s2,s5
     36e:	ff4499e3          	bne	s1,s4,360 <main+0x1ae>
  char *p = sbrk(PRESSURE * PAGE_SIZE);
     372:	00048537          	lui	a0,0x48
     376:	632000ef          	jal	9a8 <sbrk>
     37a:	872a                	mv	a4,a0
  if(p!=(char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=(char)i; sbrk(-(PRESSURE*PAGE_SIZE)); }
     37c:	57fd                	li	a5,-1
     37e:	02f50063          	beq	a0,a5,39e <main+0x1ec>
     382:	4781                	li	a5,0
     384:	6605                	lui	a2,0x1
     386:	04800693          	li	a3,72
     38a:	00f70023          	sb	a5,0(a4)
     38e:	2785                	addiw	a5,a5,1
     390:	9732                	add	a4,a4,a2
     392:	fed79ce3          	bne	a5,a3,38a <main+0x1d8>
     396:	fffb8537          	lui	a0,0xfffb8
     39a:	60e000ef          	jal	9a8 <sbrk>
     39e:	4701                	li	a4,0
     3a0:	02b00793          	li	a5,43
  int errors = 0;
     3a4:	4481                	li	s1,0
    for(int j=0;j<PAGE_SIZE;j++){
     3a6:	6585                	lui	a1,0x1
     3a8:	00b98833          	add	a6,s3,a1
  for(int i=0;i<LARGE_PAGES;i++)
     3ac:	456d                	li	a0,27
     3ae:	a8b9                	j	40c <main+0x25a>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     3b0:	00001517          	auipc	a0,0x1
     3b4:	d2850513          	addi	a0,a0,-728 # 10d8 <malloc+0x1ae>
     3b8:	2bb000ef          	jal	e72 <printf>
     3bc:	00002717          	auipc	a4,0x2
     3c0:	c4470713          	addi	a4,a4,-956 # 2000 <total_fail>
     3c4:	431c                	lw	a5,0(a4)
     3c6:	2785                	addiw	a5,a5,1
     3c8:	c31c                	sw	a5,0(a4)
     3ca:	bdf5                	j	2c6 <main+0x114>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     3cc:	00001517          	auipc	a0,0x1
     3d0:	d0c50513          	addi	a0,a0,-756 # 10d8 <malloc+0x1ae>
     3d4:	29f000ef          	jal	e72 <printf>
     3d8:	00002717          	auipc	a4,0x2
     3dc:	c2870713          	addi	a4,a4,-984 # 2000 <total_fail>
     3e0:	431c                	lw	a5,0(a4)
     3e2:	2785                	addiw	a5,a5,1
     3e4:	c31c                	sw	a5,0(a4)
     3e6:	a0b9                	j	434 <main+0x282>
      if(base[i*PAGE_SIZE+j] != exp) errors++;
     3e8:	2485                	addiw	s1,s1,1
    for(int j=0;j<PAGE_SIZE;j++){
     3ea:	0605                	addi	a2,a2,1 # 1001 <malloc+0xd7>
     3ec:	26ad                	addiw	a3,a3,11 # 100b <malloc+0xe1>
     3ee:	0ff6f693          	zext.b	a3,a3
     3f2:	01160763          	beq	a2,a7,400 <main+0x24e>
      if(base[i*PAGE_SIZE+j] != exp) errors++;
     3f6:	00064303          	lbu	t1,0(a2)
     3fa:	fed317e3          	bne	t1,a3,3e8 <main+0x236>
     3fe:	b7f5                	j	3ea <main+0x238>
  for(int i=0;i<LARGE_PAGES;i++)
     400:	27cd                	addiw	a5,a5,19
     402:	0ff7f793          	zext.b	a5,a5
     406:	972e                	add	a4,a4,a1
     408:	00a78863          	beq	a5,a0,418 <main+0x266>
    for(int j=0;j<PAGE_SIZE;j++){
     40c:	00e98633          	add	a2,s3,a4
  if(p!=(char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=(char)i; sbrk(-(PRESSURE*PAGE_SIZE)); }
     410:	86be                	mv	a3,a5
    for(int j=0;j<PAGE_SIZE;j++){
     412:	00e808b3          	add	a7,a6,a4
     416:	b7c5                	j	3f6 <main+0x244>
  result("RAID-5: 80-page heavy workload correct", errors == 0);
     418:	0014b593          	seqz	a1,s1
     41c:	00001517          	auipc	a0,0x1
     420:	e6450513          	addi	a0,a0,-412 # 1280 <malloc+0x356>
     424:	c99ff0ef          	jal	bc <result>
  if(errors) printf("  %d byte errors detected\n", errors);
     428:	24049c63          	bnez	s1,680 <main+0x4ce>
  sbrk(-(LARGE_PAGES * PAGE_SIZE));
     42c:	fffb0537          	lui	a0,0xfffb0
     430:	578000ef          	jal	9a8 <sbrk>
  printf("\n[T6] No DISK_BLOCKS overflow across large workload\n");
     434:	00001517          	auipc	a0,0x1
     438:	e9450513          	addi	a0,a0,-364 # 12c8 <malloc+0x39e>
     43c:	237000ef          	jal	e72 <printf>
     440:	44c1                	li	s1,16
    if(cycle(LARGE_PAGES, 16 + r) != 1){ all_ok = 0; break; }
     442:	05000a13          	li	s4,80
     446:	4985                	li	s3,1
  for(int r = 0; r < 3; r++){
     448:	494d                	li	s2,19
    if(cycle(LARGE_PAGES, 16 + r) != 1){ all_ok = 0; break; }
     44a:	85a6                	mv	a1,s1
     44c:	8552                	mv	a0,s4
     44e:	cbbff0ef          	jal	108 <cycle>
     452:	85aa                	mv	a1,a0
     454:	23351e63          	bne	a0,s3,690 <main+0x4de>
  for(int r = 0; r < 3; r++){
     458:	2485                	addiw	s1,s1,1
     45a:	ff2498e3          	bne	s1,s2,44a <main+0x298>
  result("3 × 80-page cycles without kernel panic", all_ok);
     45e:	00001517          	auipc	a0,0x1
     462:	ea250513          	addi	a0,a0,-350 # 1300 <malloc+0x3d6>
     466:	c57ff0ef          	jal	bc <result>
  printf("\n[T7] RAID copy: fork preserves swapped data\n");
     46a:	00001517          	auipc	a0,0x1
     46e:	ec650513          	addi	a0,a0,-314 # 1330 <malloc+0x406>
     472:	201000ef          	jal	e72 <printf>
  char *base = sbrk(FORK_PAGES * PAGE_SIZE);
     476:	00038537          	lui	a0,0x38
     47a:	52e000ef          	jal	9a8 <sbrk>
     47e:	89aa                	mv	s3,a0
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     480:	57fd                	li	a5,-1
     482:	892a                	mv	s2,a0
  for(int i=0;i<FORK_PAGES;i++) fill(base+i*PAGE_SIZE,i,20);
     484:	4481                	li	s1,0
     486:	4b51                	li	s6,20
     488:	6a85                	lui	s5,0x1
     48a:	03800a13          	li	s4,56
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     48e:	20f50363          	beq	a0,a5,694 <main+0x4e2>
  for(int i=0;i<FORK_PAGES;i++) fill(base+i*PAGE_SIZE,i,20);
     492:	865a                	mv	a2,s6
     494:	85a6                	mv	a1,s1
     496:	854a                	mv	a0,s2
     498:	b69ff0ef          	jal	0 <fill>
     49c:	2485                	addiw	s1,s1,1
     49e:	9956                	add	s2,s2,s5
     4a0:	ff4499e3          	bne	s1,s4,492 <main+0x2e0>
  char *p = sbrk(PRESSURE*PAGE_SIZE);
     4a4:	00048537          	lui	a0,0x48
     4a8:	500000ef          	jal	9a8 <sbrk>
  if(p!=(char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     4ac:	57fd                	li	a5,-1
     4ae:	02f50163          	beq	a0,a5,4d0 <main+0x31e>
     4b2:	87aa                	mv	a5,a0
     4b4:	000486b7          	lui	a3,0x48
     4b8:	00d50733          	add	a4,a0,a3
     4bc:	6685                	lui	a3,0x1
     4be:	00078023          	sb	zero,0(a5)
     4c2:	97b6                	add	a5,a5,a3
     4c4:	fef71de3          	bne	a4,a5,4be <main+0x30c>
     4c8:	fffb8537          	lui	a0,0xfffb8
     4cc:	4dc000ef          	jal	9a8 <sbrk>
  int pid = fork();
     4d0:	504000ef          	jal	9d4 <fork>
  if(pid < 0){ printf("  FAIL: fork\n"); total_fail++; sbrk(-(FORK_PAGES*PAGE_SIZE)); return; }
     4d4:	1c054e63          	bltz	a0,6b0 <main+0x4fe>
  if(pid == 0){
     4d8:	1e050e63          	beqz	a0,6d4 <main+0x522>
  int status; wait(&status);
     4dc:	f9040513          	addi	a0,s0,-112
     4e0:	504000ef          	jal	9e4 <wait>
  result("child sees correct data via raid_copy", status == 0);
     4e4:	f9042583          	lw	a1,-112(s0)
     4e8:	0015b593          	seqz	a1,a1
     4ec:	00001517          	auipc	a0,0x1
     4f0:	e8450513          	addi	a0,a0,-380 # 1370 <malloc+0x446>
     4f4:	bc9ff0ef          	jal	bc <result>
  result("parent data unmodified after child overwrites", verify_range(base, 0, FORK_PAGES, 20));
     4f8:	46d1                	li	a3,20
     4fa:	03800613          	li	a2,56
     4fe:	4581                	li	a1,0
     500:	854e                	mv	a0,s3
     502:	b43ff0ef          	jal	44 <verify_range>
     506:	85aa                	mv	a1,a0
     508:	00001517          	auipc	a0,0x1
     50c:	e9050513          	addi	a0,a0,-368 # 1398 <malloc+0x46e>
     510:	badff0ef          	jal	bc <result>
  sbrk(-(FORK_PAGES*PAGE_SIZE));
     514:	fffc8537          	lui	a0,0xfffc8
     518:	490000ef          	jal	9a8 <sbrk>
  printf("\n[T8] Idempotent: two identical write cycles produce same readback\n");
     51c:	00001517          	auipc	a0,0x1
     520:	eac50513          	addi	a0,a0,-340 # 13c8 <malloc+0x49e>
     524:	14f000ef          	jal	e72 <printf>
  int r1 = cycle(WORK_PAGES, 30);
     528:	45f9                	li	a1,30
     52a:	04000513          	li	a0,64
     52e:	bdbff0ef          	jal	108 <cycle>
     532:	84aa                	mv	s1,a0
  int r2 = cycle(WORK_PAGES, 30);   // same seed → same pattern
     534:	45f9                	li	a1,30
     536:	04000513          	li	a0,64
     53a:	bcfff0ef          	jal	108 <cycle>
     53e:	892a                	mv	s2,a0
  result("cycle-1 correct", r1 == 1);
     540:	fff48593          	addi	a1,s1,-1
     544:	0015b593          	seqz	a1,a1
     548:	00001517          	auipc	a0,0x1
     54c:	ec850513          	addi	a0,a0,-312 # 1410 <malloc+0x4e6>
     550:	b6dff0ef          	jal	bc <result>
  result("cycle-2 correct", r2 == 1);
     554:	fff90593          	addi	a1,s2,-1
     558:	0015b593          	seqz	a1,a1
     55c:	00001517          	auipc	a0,0x1
     560:	ec450513          	addi	a0,a0,-316 # 1420 <malloc+0x4f6>
     564:	b59ff0ef          	jal	bc <result>
  result("both cycles produce identical result", r1 == r2);
     568:	412485b3          	sub	a1,s1,s2
     56c:	0015b593          	seqz	a1,a1
     570:	00001517          	auipc	a0,0x1
     574:	ec050513          	addi	a0,a0,-320 # 1430 <malloc+0x506>
     578:	b45ff0ef          	jal	bc <result>
  printf("\n[T9] Interleaved read/write stress\n");
     57c:	00001517          	auipc	a0,0x1
     580:	edc50513          	addi	a0,a0,-292 # 1458 <malloc+0x52e>
     584:	0ef000ef          	jal	e72 <printf>
  char *base = sbrk(WORK_PAGES * PAGE_SIZE);
     588:	00040537          	lui	a0,0x40
     58c:	41c000ef          	jal	9a8 <sbrk>
     590:	89aa                	mv	s3,a0
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     592:	57fd                	li	a5,-1
     594:	892a                	mv	s2,a0
  for(int i=0;i<WORK_PAGES;i+=2) fill(base+i*PAGE_SIZE,i,40);
     596:	4481                	li	s1,0
     598:	02800b13          	li	s6,40
     59c:	6a89                	lui	s5,0x2
     59e:	04000a13          	li	s4,64
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     5a2:	16f50463          	beq	a0,a5,70a <main+0x558>
  for(int i=0;i<WORK_PAGES;i+=2) fill(base+i*PAGE_SIZE,i,40);
     5a6:	865a                	mv	a2,s6
     5a8:	85a6                	mv	a1,s1
     5aa:	854a                	mv	a0,s2
     5ac:	a55ff0ef          	jal	0 <fill>
     5b0:	2489                	addiw	s1,s1,2
     5b2:	9956                	add	s2,s2,s5
     5b4:	ff4499e3          	bne	s1,s4,5a6 <main+0x3f4>
  char *p = sbrk(PRESSURE*PAGE_SIZE);
     5b8:	00048537          	lui	a0,0x48
     5bc:	3ec000ef          	jal	9a8 <sbrk>
  if(p!=(char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     5c0:	57fd                	li	a5,-1
     5c2:	02f50163          	beq	a0,a5,5e4 <main+0x432>
     5c6:	87aa                	mv	a5,a0
     5c8:	000486b7          	lui	a3,0x48
     5cc:	00d50733          	add	a4,a0,a3
     5d0:	6685                	lui	a3,0x1
     5d2:	00078023          	sb	zero,0(a5)
     5d6:	97b6                	add	a5,a5,a3
     5d8:	fee79de3          	bne	a5,a4,5d2 <main+0x420>
     5dc:	fffb8537          	lui	a0,0xfffb8
     5e0:	3c8000ef          	jal	9a8 <sbrk>
  for(int i=1;i<WORK_PAGES;i+=2) fill(base+i*PAGE_SIZE,i,40);
     5e4:	6905                	lui	s2,0x1
     5e6:	994e                	add	s2,s2,s3
  for(int i=0;i<WORK_PAGES;i+=2) fill(base+i*PAGE_SIZE,i,40);
     5e8:	4485                	li	s1,1
  for(int i=1;i<WORK_PAGES;i+=2) fill(base+i*PAGE_SIZE,i,40);
     5ea:	02800b13          	li	s6,40
     5ee:	6a89                	lui	s5,0x2
     5f0:	04100a13          	li	s4,65
     5f4:	865a                	mv	a2,s6
     5f6:	85a6                	mv	a1,s1
     5f8:	854a                	mv	a0,s2
     5fa:	a07ff0ef          	jal	0 <fill>
     5fe:	2489                	addiw	s1,s1,2
     600:	9956                	add	s2,s2,s5
     602:	ff4499e3          	bne	s1,s4,5f4 <main+0x442>
  p = sbrk(PRESSURE*PAGE_SIZE);
     606:	00048537          	lui	a0,0x48
     60a:	39e000ef          	jal	9a8 <sbrk>
  if(p!=(char*)-1){ for(int i=0;i<PRESSURE;i++) p[i*PAGE_SIZE]=0; sbrk(-(PRESSURE*PAGE_SIZE)); }
     60e:	57fd                	li	a5,-1
     610:	02f50163          	beq	a0,a5,632 <main+0x480>
     614:	87aa                	mv	a5,a0
     616:	000486b7          	lui	a3,0x48
     61a:	00d50733          	add	a4,a0,a3
     61e:	6685                	lui	a3,0x1
     620:	00078023          	sb	zero,0(a5)
     624:	97b6                	add	a5,a5,a3
     626:	fef71de3          	bne	a4,a5,620 <main+0x46e>
     62a:	fffb8537          	lui	a0,0xfffb8
     62e:	37a000ef          	jal	9a8 <sbrk>
  int ok = verify_range(base, 0, WORK_PAGES, 40);
     632:	02800693          	li	a3,40
     636:	04000613          	li	a2,64
     63a:	4581                	li	a1,0
     63c:	854e                	mv	a0,s3
     63e:	a07ff0ef          	jal	44 <verify_range>
     642:	85aa                	mv	a1,a0
  result("interleaved write/evict both parities correct", ok);
     644:	00001517          	auipc	a0,0x1
     648:	e3c50513          	addi	a0,a0,-452 # 1480 <malloc+0x556>
     64c:	a71ff0ef          	jal	bc <result>
  sbrk(-(WORK_PAGES*PAGE_SIZE));
     650:	fffc0537          	lui	a0,0xfffc0
     654:	354000ef          	jal	9a8 <sbrk>
  t6_no_overflow();
  t7_fork_copy();
  t8_idempotent();
  t9_interleaved();

  printf("\n=== RESULTS: %d passed, %d failed ===\n", total_pass, total_fail);
     658:	00002497          	auipc	s1,0x2
     65c:	9a848493          	addi	s1,s1,-1624 # 2000 <total_fail>
     660:	4090                	lw	a2,0(s1)
     662:	00002597          	auipc	a1,0x2
     666:	9a25a583          	lw	a1,-1630(a1) # 2004 <total_pass>
     66a:	00001517          	auipc	a0,0x1
     66e:	e4650513          	addi	a0,a0,-442 # 14b0 <malloc+0x586>
     672:	001000ef          	jal	e72 <printf>
  exit(total_fail == 0 ? 0 : 1);
     676:	4088                	lw	a0,0(s1)
     678:	00a03533          	snez	a0,a0
     67c:	360000ef          	jal	9dc <exit>
  if(errors) printf("  %d byte errors detected\n", errors);
     680:	85a6                	mv	a1,s1
     682:	00001517          	auipc	a0,0x1
     686:	c2650513          	addi	a0,a0,-986 # 12a8 <malloc+0x37e>
     68a:	7e8000ef          	jal	e72 <printf>
     68e:	bb79                	j	42c <main+0x27a>
    if(cycle(LARGE_PAGES, 16 + r) != 1){ all_ok = 0; break; }
     690:	4581                	li	a1,0
     692:	b3f1                	j	45e <main+0x2ac>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     694:	00001517          	auipc	a0,0x1
     698:	a4450513          	addi	a0,a0,-1468 # 10d8 <malloc+0x1ae>
     69c:	7d6000ef          	jal	e72 <printf>
     6a0:	00002717          	auipc	a4,0x2
     6a4:	96070713          	addi	a4,a4,-1696 # 2000 <total_fail>
     6a8:	431c                	lw	a5,0(a4)
     6aa:	2785                	addiw	a5,a5,1
     6ac:	c31c                	sw	a5,0(a4)
     6ae:	b5bd                	j	51c <main+0x36a>
  if(pid < 0){ printf("  FAIL: fork\n"); total_fail++; sbrk(-(FORK_PAGES*PAGE_SIZE)); return; }
     6b0:	00001517          	auipc	a0,0x1
     6b4:	cb050513          	addi	a0,a0,-848 # 1360 <malloc+0x436>
     6b8:	7ba000ef          	jal	e72 <printf>
     6bc:	00002717          	auipc	a4,0x2
     6c0:	94470713          	addi	a4,a4,-1724 # 2000 <total_fail>
     6c4:	431c                	lw	a5,0(a4)
     6c6:	2785                	addiw	a5,a5,1
     6c8:	c31c                	sw	a5,0(a4)
     6ca:	fffc8537          	lui	a0,0xfffc8
     6ce:	2da000ef          	jal	9a8 <sbrk>
     6d2:	b5a9                	j	51c <main+0x36a>
    int ok = verify_range(base, 0, FORK_PAGES, 20);
     6d4:	46d1                	li	a3,20
     6d6:	03800613          	li	a2,56
     6da:	4581                	li	a1,0
     6dc:	854e                	mv	a0,s3
     6de:	967ff0ef          	jal	44 <verify_range>
     6e2:	892a                	mv	s2,a0
     6e4:	4481                	li	s1,0
    for(int i=0;i<FORK_PAGES;i++) fill(base+i*PAGE_SIZE,i,21);
     6e6:	4ad5                	li	s5,21
     6e8:	03800a13          	li	s4,56
     6ec:	00c49513          	slli	a0,s1,0xc
     6f0:	8656                	mv	a2,s5
     6f2:	0004859b          	sext.w	a1,s1
     6f6:	954e                	add	a0,a0,s3
     6f8:	909ff0ef          	jal	0 <fill>
     6fc:	0485                	addi	s1,s1,1
     6fe:	ff4497e3          	bne	s1,s4,6ec <main+0x53a>
    exit(ok ? 0 : 1);
     702:	00193513          	seqz	a0,s2
     706:	2d6000ef          	jal	9dc <exit>
  if(base == (char*)-1){ printf("  FAIL: sbrk\n"); total_fail++; return; }
     70a:	00001517          	auipc	a0,0x1
     70e:	9ce50513          	addi	a0,a0,-1586 # 10d8 <malloc+0x1ae>
     712:	760000ef          	jal	e72 <printf>
     716:	00002717          	auipc	a4,0x2
     71a:	8ea70713          	addi	a4,a4,-1814 # 2000 <total_fail>
     71e:	431c                	lw	a5,0(a4)
     720:	2785                	addiw	a5,a5,1
     722:	c31c                	sw	a5,0(a4)
     724:	bf15                	j	658 <main+0x4a6>

0000000000000726 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     726:	1141                	addi	sp,sp,-16
     728:	e406                	sd	ra,8(sp)
     72a:	e022                	sd	s0,0(sp)
     72c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     72e:	a85ff0ef          	jal	1b2 <main>
  exit(r);
     732:	2aa000ef          	jal	9dc <exit>

0000000000000736 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     736:	1141                	addi	sp,sp,-16
     738:	e406                	sd	ra,8(sp)
     73a:	e022                	sd	s0,0(sp)
     73c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     73e:	87aa                	mv	a5,a0
     740:	0585                	addi	a1,a1,1
     742:	0785                	addi	a5,a5,1
     744:	fff5c703          	lbu	a4,-1(a1)
     748:	fee78fa3          	sb	a4,-1(a5)
     74c:	fb75                	bnez	a4,740 <strcpy+0xa>
    ;
  return os;
}
     74e:	60a2                	ld	ra,8(sp)
     750:	6402                	ld	s0,0(sp)
     752:	0141                	addi	sp,sp,16
     754:	8082                	ret

0000000000000756 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     756:	1141                	addi	sp,sp,-16
     758:	e406                	sd	ra,8(sp)
     75a:	e022                	sd	s0,0(sp)
     75c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     75e:	00054783          	lbu	a5,0(a0)
     762:	cb91                	beqz	a5,776 <strcmp+0x20>
     764:	0005c703          	lbu	a4,0(a1)
     768:	00f71763          	bne	a4,a5,776 <strcmp+0x20>
    p++, q++;
     76c:	0505                	addi	a0,a0,1
     76e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     770:	00054783          	lbu	a5,0(a0)
     774:	fbe5                	bnez	a5,764 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     776:	0005c503          	lbu	a0,0(a1)
}
     77a:	40a7853b          	subw	a0,a5,a0
     77e:	60a2                	ld	ra,8(sp)
     780:	6402                	ld	s0,0(sp)
     782:	0141                	addi	sp,sp,16
     784:	8082                	ret

0000000000000786 <strlen>:

uint
strlen(const char *s)
{
     786:	1141                	addi	sp,sp,-16
     788:	e406                	sd	ra,8(sp)
     78a:	e022                	sd	s0,0(sp)
     78c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     78e:	00054783          	lbu	a5,0(a0)
     792:	cf91                	beqz	a5,7ae <strlen+0x28>
     794:	00150793          	addi	a5,a0,1
     798:	86be                	mv	a3,a5
     79a:	0785                	addi	a5,a5,1
     79c:	fff7c703          	lbu	a4,-1(a5)
     7a0:	ff65                	bnez	a4,798 <strlen+0x12>
     7a2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     7a6:	60a2                	ld	ra,8(sp)
     7a8:	6402                	ld	s0,0(sp)
     7aa:	0141                	addi	sp,sp,16
     7ac:	8082                	ret
  for(n = 0; s[n]; n++)
     7ae:	4501                	li	a0,0
     7b0:	bfdd                	j	7a6 <strlen+0x20>

00000000000007b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
     7b2:	1141                	addi	sp,sp,-16
     7b4:	e406                	sd	ra,8(sp)
     7b6:	e022                	sd	s0,0(sp)
     7b8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     7ba:	ca19                	beqz	a2,7d0 <memset+0x1e>
     7bc:	87aa                	mv	a5,a0
     7be:	1602                	slli	a2,a2,0x20
     7c0:	9201                	srli	a2,a2,0x20
     7c2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     7c6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     7ca:	0785                	addi	a5,a5,1
     7cc:	fee79de3          	bne	a5,a4,7c6 <memset+0x14>
  }
  return dst;
}
     7d0:	60a2                	ld	ra,8(sp)
     7d2:	6402                	ld	s0,0(sp)
     7d4:	0141                	addi	sp,sp,16
     7d6:	8082                	ret

00000000000007d8 <strchr>:

char*
strchr(const char *s, char c)
{
     7d8:	1141                	addi	sp,sp,-16
     7da:	e406                	sd	ra,8(sp)
     7dc:	e022                	sd	s0,0(sp)
     7de:	0800                	addi	s0,sp,16
  for(; *s; s++)
     7e0:	00054783          	lbu	a5,0(a0)
     7e4:	cf81                	beqz	a5,7fc <strchr+0x24>
    if(*s == c)
     7e6:	00f58763          	beq	a1,a5,7f4 <strchr+0x1c>
  for(; *s; s++)
     7ea:	0505                	addi	a0,a0,1
     7ec:	00054783          	lbu	a5,0(a0)
     7f0:	fbfd                	bnez	a5,7e6 <strchr+0xe>
      return (char*)s;
  return 0;
     7f2:	4501                	li	a0,0
}
     7f4:	60a2                	ld	ra,8(sp)
     7f6:	6402                	ld	s0,0(sp)
     7f8:	0141                	addi	sp,sp,16
     7fa:	8082                	ret
  return 0;
     7fc:	4501                	li	a0,0
     7fe:	bfdd                	j	7f4 <strchr+0x1c>

0000000000000800 <gets>:

char*
gets(char *buf, int max)
{
     800:	711d                	addi	sp,sp,-96
     802:	ec86                	sd	ra,88(sp)
     804:	e8a2                	sd	s0,80(sp)
     806:	e4a6                	sd	s1,72(sp)
     808:	e0ca                	sd	s2,64(sp)
     80a:	fc4e                	sd	s3,56(sp)
     80c:	f852                	sd	s4,48(sp)
     80e:	f456                	sd	s5,40(sp)
     810:	f05a                	sd	s6,32(sp)
     812:	ec5e                	sd	s7,24(sp)
     814:	e862                	sd	s8,16(sp)
     816:	1080                	addi	s0,sp,96
     818:	8baa                	mv	s7,a0
     81a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     81c:	892a                	mv	s2,a0
     81e:	4481                	li	s1,0
    cc = read(0, &c, 1);
     820:	faf40b13          	addi	s6,s0,-81
     824:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     826:	8c26                	mv	s8,s1
     828:	0014899b          	addiw	s3,s1,1
     82c:	84ce                	mv	s1,s3
     82e:	0349d463          	bge	s3,s4,856 <gets+0x56>
    cc = read(0, &c, 1);
     832:	8656                	mv	a2,s5
     834:	85da                	mv	a1,s6
     836:	4501                	li	a0,0
     838:	1bc000ef          	jal	9f4 <read>
    if(cc < 1)
     83c:	00a05d63          	blez	a0,856 <gets+0x56>
      break;
    buf[i++] = c;
     840:	faf44783          	lbu	a5,-81(s0)
     844:	00f90023          	sb	a5,0(s2) # 1000 <malloc+0xd6>
    if(c == '\n' || c == '\r')
     848:	0905                	addi	s2,s2,1
     84a:	ff678713          	addi	a4,a5,-10
     84e:	c319                	beqz	a4,854 <gets+0x54>
     850:	17cd                	addi	a5,a5,-13
     852:	fbf1                	bnez	a5,826 <gets+0x26>
    buf[i++] = c;
     854:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     856:	9c5e                	add	s8,s8,s7
     858:	000c0023          	sb	zero,0(s8)
  return buf;
}
     85c:	855e                	mv	a0,s7
     85e:	60e6                	ld	ra,88(sp)
     860:	6446                	ld	s0,80(sp)
     862:	64a6                	ld	s1,72(sp)
     864:	6906                	ld	s2,64(sp)
     866:	79e2                	ld	s3,56(sp)
     868:	7a42                	ld	s4,48(sp)
     86a:	7aa2                	ld	s5,40(sp)
     86c:	7b02                	ld	s6,32(sp)
     86e:	6be2                	ld	s7,24(sp)
     870:	6c42                	ld	s8,16(sp)
     872:	6125                	addi	sp,sp,96
     874:	8082                	ret

0000000000000876 <stat>:

int
stat(const char *n, struct stat *st)
{
     876:	1101                	addi	sp,sp,-32
     878:	ec06                	sd	ra,24(sp)
     87a:	e822                	sd	s0,16(sp)
     87c:	e04a                	sd	s2,0(sp)
     87e:	1000                	addi	s0,sp,32
     880:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     882:	4581                	li	a1,0
     884:	198000ef          	jal	a1c <open>
  if(fd < 0)
     888:	02054263          	bltz	a0,8ac <stat+0x36>
     88c:	e426                	sd	s1,8(sp)
     88e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     890:	85ca                	mv	a1,s2
     892:	1a2000ef          	jal	a34 <fstat>
     896:	892a                	mv	s2,a0
  close(fd);
     898:	8526                	mv	a0,s1
     89a:	16a000ef          	jal	a04 <close>
  return r;
     89e:	64a2                	ld	s1,8(sp)
}
     8a0:	854a                	mv	a0,s2
     8a2:	60e2                	ld	ra,24(sp)
     8a4:	6442                	ld	s0,16(sp)
     8a6:	6902                	ld	s2,0(sp)
     8a8:	6105                	addi	sp,sp,32
     8aa:	8082                	ret
    return -1;
     8ac:	57fd                	li	a5,-1
     8ae:	893e                	mv	s2,a5
     8b0:	bfc5                	j	8a0 <stat+0x2a>

00000000000008b2 <atoi>:

int
atoi(const char *s)
{
     8b2:	1141                	addi	sp,sp,-16
     8b4:	e406                	sd	ra,8(sp)
     8b6:	e022                	sd	s0,0(sp)
     8b8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     8ba:	00054683          	lbu	a3,0(a0)
     8be:	fd06879b          	addiw	a5,a3,-48 # fd0 <malloc+0xa6>
     8c2:	0ff7f793          	zext.b	a5,a5
     8c6:	4625                	li	a2,9
     8c8:	02f66963          	bltu	a2,a5,8fa <atoi+0x48>
     8cc:	872a                	mv	a4,a0
  n = 0;
     8ce:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     8d0:	0705                	addi	a4,a4,1
     8d2:	0025179b          	slliw	a5,a0,0x2
     8d6:	9fa9                	addw	a5,a5,a0
     8d8:	0017979b          	slliw	a5,a5,0x1
     8dc:	9fb5                	addw	a5,a5,a3
     8de:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     8e2:	00074683          	lbu	a3,0(a4)
     8e6:	fd06879b          	addiw	a5,a3,-48
     8ea:	0ff7f793          	zext.b	a5,a5
     8ee:	fef671e3          	bgeu	a2,a5,8d0 <atoi+0x1e>
  return n;
}
     8f2:	60a2                	ld	ra,8(sp)
     8f4:	6402                	ld	s0,0(sp)
     8f6:	0141                	addi	sp,sp,16
     8f8:	8082                	ret
  n = 0;
     8fa:	4501                	li	a0,0
     8fc:	bfdd                	j	8f2 <atoi+0x40>

00000000000008fe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     8fe:	1141                	addi	sp,sp,-16
     900:	e406                	sd	ra,8(sp)
     902:	e022                	sd	s0,0(sp)
     904:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     906:	02b57563          	bgeu	a0,a1,930 <memmove+0x32>
    while(n-- > 0)
     90a:	00c05f63          	blez	a2,928 <memmove+0x2a>
     90e:	1602                	slli	a2,a2,0x20
     910:	9201                	srli	a2,a2,0x20
     912:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     916:	872a                	mv	a4,a0
      *dst++ = *src++;
     918:	0585                	addi	a1,a1,1
     91a:	0705                	addi	a4,a4,1
     91c:	fff5c683          	lbu	a3,-1(a1)
     920:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     924:	fee79ae3          	bne	a5,a4,918 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     928:	60a2                	ld	ra,8(sp)
     92a:	6402                	ld	s0,0(sp)
     92c:	0141                	addi	sp,sp,16
     92e:	8082                	ret
    while(n-- > 0)
     930:	fec05ce3          	blez	a2,928 <memmove+0x2a>
    dst += n;
     934:	00c50733          	add	a4,a0,a2
    src += n;
     938:	95b2                	add	a1,a1,a2
     93a:	fff6079b          	addiw	a5,a2,-1
     93e:	1782                	slli	a5,a5,0x20
     940:	9381                	srli	a5,a5,0x20
     942:	fff7c793          	not	a5,a5
     946:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     948:	15fd                	addi	a1,a1,-1
     94a:	177d                	addi	a4,a4,-1
     94c:	0005c683          	lbu	a3,0(a1)
     950:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     954:	fef71ae3          	bne	a4,a5,948 <memmove+0x4a>
     958:	bfc1                	j	928 <memmove+0x2a>

000000000000095a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     95a:	1141                	addi	sp,sp,-16
     95c:	e406                	sd	ra,8(sp)
     95e:	e022                	sd	s0,0(sp)
     960:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     962:	c61d                	beqz	a2,990 <memcmp+0x36>
     964:	1602                	slli	a2,a2,0x20
     966:	9201                	srli	a2,a2,0x20
     968:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     96c:	00054783          	lbu	a5,0(a0)
     970:	0005c703          	lbu	a4,0(a1)
     974:	00e79863          	bne	a5,a4,984 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     978:	0505                	addi	a0,a0,1
    p2++;
     97a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     97c:	fed518e3          	bne	a0,a3,96c <memcmp+0x12>
  }
  return 0;
     980:	4501                	li	a0,0
     982:	a019                	j	988 <memcmp+0x2e>
      return *p1 - *p2;
     984:	40e7853b          	subw	a0,a5,a4
}
     988:	60a2                	ld	ra,8(sp)
     98a:	6402                	ld	s0,0(sp)
     98c:	0141                	addi	sp,sp,16
     98e:	8082                	ret
  return 0;
     990:	4501                	li	a0,0
     992:	bfdd                	j	988 <memcmp+0x2e>

0000000000000994 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     994:	1141                	addi	sp,sp,-16
     996:	e406                	sd	ra,8(sp)
     998:	e022                	sd	s0,0(sp)
     99a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     99c:	f63ff0ef          	jal	8fe <memmove>
}
     9a0:	60a2                	ld	ra,8(sp)
     9a2:	6402                	ld	s0,0(sp)
     9a4:	0141                	addi	sp,sp,16
     9a6:	8082                	ret

00000000000009a8 <sbrk>:

char *
sbrk(int n) {
     9a8:	1141                	addi	sp,sp,-16
     9aa:	e406                	sd	ra,8(sp)
     9ac:	e022                	sd	s0,0(sp)
     9ae:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     9b0:	4585                	li	a1,1
     9b2:	0b2000ef          	jal	a64 <sys_sbrk>
}
     9b6:	60a2                	ld	ra,8(sp)
     9b8:	6402                	ld	s0,0(sp)
     9ba:	0141                	addi	sp,sp,16
     9bc:	8082                	ret

00000000000009be <sbrklazy>:

char *
sbrklazy(int n) {
     9be:	1141                	addi	sp,sp,-16
     9c0:	e406                	sd	ra,8(sp)
     9c2:	e022                	sd	s0,0(sp)
     9c4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     9c6:	4589                	li	a1,2
     9c8:	09c000ef          	jal	a64 <sys_sbrk>
}
     9cc:	60a2                	ld	ra,8(sp)
     9ce:	6402                	ld	s0,0(sp)
     9d0:	0141                	addi	sp,sp,16
     9d2:	8082                	ret

00000000000009d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     9d4:	4885                	li	a7,1
 ecall
     9d6:	00000073          	ecall
 ret
     9da:	8082                	ret

00000000000009dc <exit>:
.global exit
exit:
 li a7, SYS_exit
     9dc:	4889                	li	a7,2
 ecall
     9de:	00000073          	ecall
 ret
     9e2:	8082                	ret

00000000000009e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
     9e4:	488d                	li	a7,3
 ecall
     9e6:	00000073          	ecall
 ret
     9ea:	8082                	ret

00000000000009ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     9ec:	4891                	li	a7,4
 ecall
     9ee:	00000073          	ecall
 ret
     9f2:	8082                	ret

00000000000009f4 <read>:
.global read
read:
 li a7, SYS_read
     9f4:	4895                	li	a7,5
 ecall
     9f6:	00000073          	ecall
 ret
     9fa:	8082                	ret

00000000000009fc <write>:
.global write
write:
 li a7, SYS_write
     9fc:	48c1                	li	a7,16
 ecall
     9fe:	00000073          	ecall
 ret
     a02:	8082                	ret

0000000000000a04 <close>:
.global close
close:
 li a7, SYS_close
     a04:	48d5                	li	a7,21
 ecall
     a06:	00000073          	ecall
 ret
     a0a:	8082                	ret

0000000000000a0c <kill>:
.global kill
kill:
 li a7, SYS_kill
     a0c:	4899                	li	a7,6
 ecall
     a0e:	00000073          	ecall
 ret
     a12:	8082                	ret

0000000000000a14 <exec>:
.global exec
exec:
 li a7, SYS_exec
     a14:	489d                	li	a7,7
 ecall
     a16:	00000073          	ecall
 ret
     a1a:	8082                	ret

0000000000000a1c <open>:
.global open
open:
 li a7, SYS_open
     a1c:	48bd                	li	a7,15
 ecall
     a1e:	00000073          	ecall
 ret
     a22:	8082                	ret

0000000000000a24 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     a24:	48c5                	li	a7,17
 ecall
     a26:	00000073          	ecall
 ret
     a2a:	8082                	ret

0000000000000a2c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     a2c:	48c9                	li	a7,18
 ecall
     a2e:	00000073          	ecall
 ret
     a32:	8082                	ret

0000000000000a34 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     a34:	48a1                	li	a7,8
 ecall
     a36:	00000073          	ecall
 ret
     a3a:	8082                	ret

0000000000000a3c <link>:
.global link
link:
 li a7, SYS_link
     a3c:	48cd                	li	a7,19
 ecall
     a3e:	00000073          	ecall
 ret
     a42:	8082                	ret

0000000000000a44 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     a44:	48d1                	li	a7,20
 ecall
     a46:	00000073          	ecall
 ret
     a4a:	8082                	ret

0000000000000a4c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     a4c:	48a5                	li	a7,9
 ecall
     a4e:	00000073          	ecall
 ret
     a52:	8082                	ret

0000000000000a54 <dup>:
.global dup
dup:
 li a7, SYS_dup
     a54:	48a9                	li	a7,10
 ecall
     a56:	00000073          	ecall
 ret
     a5a:	8082                	ret

0000000000000a5c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     a5c:	48ad                	li	a7,11
 ecall
     a5e:	00000073          	ecall
 ret
     a62:	8082                	ret

0000000000000a64 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     a64:	48b1                	li	a7,12
 ecall
     a66:	00000073          	ecall
 ret
     a6a:	8082                	ret

0000000000000a6c <pause>:
.global pause
pause:
 li a7, SYS_pause
     a6c:	48b5                	li	a7,13
 ecall
     a6e:	00000073          	ecall
 ret
     a72:	8082                	ret

0000000000000a74 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     a74:	48b9                	li	a7,14
 ecall
     a76:	00000073          	ecall
 ret
     a7a:	8082                	ret

0000000000000a7c <hello>:
.global hello
hello:
 li a7, SYS_hello
     a7c:	48d9                	li	a7,22
 ecall
     a7e:	00000073          	ecall
 ret
     a82:	8082                	ret

0000000000000a84 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
     a84:	48dd                	li	a7,23
 ecall
     a86:	00000073          	ecall
 ret
     a8a:	8082                	ret

0000000000000a8c <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
     a8c:	48e1                	li	a7,24
 ecall
     a8e:	00000073          	ecall
 ret
     a92:	8082                	ret

0000000000000a94 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
     a94:	48e5                	li	a7,25
 ecall
     a96:	00000073          	ecall
 ret
     a9a:	8082                	ret

0000000000000a9c <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
     a9c:	48e9                	li	a7,26
 ecall
     a9e:	00000073          	ecall
 ret
     aa2:	8082                	ret

0000000000000aa4 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
     aa4:	48ed                	li	a7,27
 ecall
     aa6:	00000073          	ecall
 ret
     aaa:	8082                	ret

0000000000000aac <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
     aac:	48f1                	li	a7,28
 ecall
     aae:	00000073          	ecall
 ret
     ab2:	8082                	ret

0000000000000ab4 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
     ab4:	48f5                	li	a7,29
 ecall
     ab6:	00000073          	ecall
 ret
     aba:	8082                	ret

0000000000000abc <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
     abc:	48f9                	li	a7,30
 ecall
     abe:	00000073          	ecall
 ret
     ac2:	8082                	ret

0000000000000ac4 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
     ac4:	48fd                	li	a7,31
 ecall
     ac6:	00000073          	ecall
 ret
     aca:	8082                	ret

0000000000000acc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     acc:	1101                	addi	sp,sp,-32
     ace:	ec06                	sd	ra,24(sp)
     ad0:	e822                	sd	s0,16(sp)
     ad2:	1000                	addi	s0,sp,32
     ad4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ad8:	4605                	li	a2,1
     ada:	fef40593          	addi	a1,s0,-17
     ade:	f1fff0ef          	jal	9fc <write>
}
     ae2:	60e2                	ld	ra,24(sp)
     ae4:	6442                	ld	s0,16(sp)
     ae6:	6105                	addi	sp,sp,32
     ae8:	8082                	ret

0000000000000aea <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     aea:	715d                	addi	sp,sp,-80
     aec:	e486                	sd	ra,72(sp)
     aee:	e0a2                	sd	s0,64(sp)
     af0:	f84a                	sd	s2,48(sp)
     af2:	f44e                	sd	s3,40(sp)
     af4:	0880                	addi	s0,sp,80
     af6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     af8:	c6d1                	beqz	a3,b84 <printint+0x9a>
     afa:	0805d563          	bgez	a1,b84 <printint+0x9a>
    neg = 1;
    x = -xx;
     afe:	40b005b3          	neg	a1,a1
    neg = 1;
     b02:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     b04:	fb840993          	addi	s3,s0,-72
  neg = 0;
     b08:	86ce                	mv	a3,s3
  i = 0;
     b0a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     b0c:	00001817          	auipc	a6,0x1
     b10:	9d480813          	addi	a6,a6,-1580 # 14e0 <digits>
     b14:	88ba                	mv	a7,a4
     b16:	0017051b          	addiw	a0,a4,1
     b1a:	872a                	mv	a4,a0
     b1c:	02c5f7b3          	remu	a5,a1,a2
     b20:	97c2                	add	a5,a5,a6
     b22:	0007c783          	lbu	a5,0(a5)
     b26:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     b2a:	87ae                	mv	a5,a1
     b2c:	02c5d5b3          	divu	a1,a1,a2
     b30:	0685                	addi	a3,a3,1
     b32:	fec7f1e3          	bgeu	a5,a2,b14 <printint+0x2a>
  if(neg)
     b36:	00030c63          	beqz	t1,b4e <printint+0x64>
    buf[i++] = '-';
     b3a:	fd050793          	addi	a5,a0,-48
     b3e:	00878533          	add	a0,a5,s0
     b42:	02d00793          	li	a5,45
     b46:	fef50423          	sb	a5,-24(a0)
     b4a:	0028871b          	addiw	a4,a7,2 # fffffffffffff002 <base+0xffffffffffffcff2>

  while(--i >= 0)
     b4e:	02e05563          	blez	a4,b78 <printint+0x8e>
     b52:	fc26                	sd	s1,56(sp)
     b54:	377d                	addiw	a4,a4,-1
     b56:	00e984b3          	add	s1,s3,a4
     b5a:	19fd                	addi	s3,s3,-1
     b5c:	99ba                	add	s3,s3,a4
     b5e:	1702                	slli	a4,a4,0x20
     b60:	9301                	srli	a4,a4,0x20
     b62:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     b66:	0004c583          	lbu	a1,0(s1)
     b6a:	854a                	mv	a0,s2
     b6c:	f61ff0ef          	jal	acc <putc>
  while(--i >= 0)
     b70:	14fd                	addi	s1,s1,-1
     b72:	ff349ae3          	bne	s1,s3,b66 <printint+0x7c>
     b76:	74e2                	ld	s1,56(sp)
}
     b78:	60a6                	ld	ra,72(sp)
     b7a:	6406                	ld	s0,64(sp)
     b7c:	7942                	ld	s2,48(sp)
     b7e:	79a2                	ld	s3,40(sp)
     b80:	6161                	addi	sp,sp,80
     b82:	8082                	ret
  neg = 0;
     b84:	4301                	li	t1,0
     b86:	bfbd                	j	b04 <printint+0x1a>

0000000000000b88 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     b88:	711d                	addi	sp,sp,-96
     b8a:	ec86                	sd	ra,88(sp)
     b8c:	e8a2                	sd	s0,80(sp)
     b8e:	e4a6                	sd	s1,72(sp)
     b90:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     b92:	0005c483          	lbu	s1,0(a1)
     b96:	22048363          	beqz	s1,dbc <vprintf+0x234>
     b9a:	e0ca                	sd	s2,64(sp)
     b9c:	fc4e                	sd	s3,56(sp)
     b9e:	f852                	sd	s4,48(sp)
     ba0:	f456                	sd	s5,40(sp)
     ba2:	f05a                	sd	s6,32(sp)
     ba4:	ec5e                	sd	s7,24(sp)
     ba6:	e862                	sd	s8,16(sp)
     ba8:	8b2a                	mv	s6,a0
     baa:	8a2e                	mv	s4,a1
     bac:	8bb2                	mv	s7,a2
  state = 0;
     bae:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     bb0:	4901                	li	s2,0
     bb2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     bb4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     bb8:	06400c13          	li	s8,100
     bbc:	a00d                	j	bde <vprintf+0x56>
        putc(fd, c0);
     bbe:	85a6                	mv	a1,s1
     bc0:	855a                	mv	a0,s6
     bc2:	f0bff0ef          	jal	acc <putc>
     bc6:	a019                	j	bcc <vprintf+0x44>
    } else if(state == '%'){
     bc8:	03598363          	beq	s3,s5,bee <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     bcc:	0019079b          	addiw	a5,s2,1
     bd0:	893e                	mv	s2,a5
     bd2:	873e                	mv	a4,a5
     bd4:	97d2                	add	a5,a5,s4
     bd6:	0007c483          	lbu	s1,0(a5)
     bda:	1c048a63          	beqz	s1,dae <vprintf+0x226>
    c0 = fmt[i] & 0xff;
     bde:	0004879b          	sext.w	a5,s1
    if(state == 0){
     be2:	fe0993e3          	bnez	s3,bc8 <vprintf+0x40>
      if(c0 == '%'){
     be6:	fd579ce3          	bne	a5,s5,bbe <vprintf+0x36>
        state = '%';
     bea:	89be                	mv	s3,a5
     bec:	b7c5                	j	bcc <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     bee:	00ea06b3          	add	a3,s4,a4
     bf2:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     bf6:	1c060863          	beqz	a2,dc6 <vprintf+0x23e>
      if(c0 == 'd'){
     bfa:	03878763          	beq	a5,s8,c28 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     bfe:	f9478693          	addi	a3,a5,-108
     c02:	0016b693          	seqz	a3,a3
     c06:	f9c60593          	addi	a1,a2,-100
     c0a:	e99d                	bnez	a1,c40 <vprintf+0xb8>
     c0c:	ca95                	beqz	a3,c40 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     c0e:	008b8493          	addi	s1,s7,8 # 1008 <malloc+0xde>
     c12:	4685                	li	a3,1
     c14:	4629                	li	a2,10
     c16:	000bb583          	ld	a1,0(s7)
     c1a:	855a                	mv	a0,s6
     c1c:	ecfff0ef          	jal	aea <printint>
        i += 1;
     c20:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     c22:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     c24:	4981                	li	s3,0
     c26:	b75d                	j	bcc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     c28:	008b8493          	addi	s1,s7,8
     c2c:	4685                	li	a3,1
     c2e:	4629                	li	a2,10
     c30:	000ba583          	lw	a1,0(s7)
     c34:	855a                	mv	a0,s6
     c36:	eb5ff0ef          	jal	aea <printint>
     c3a:	8ba6                	mv	s7,s1
      state = 0;
     c3c:	4981                	li	s3,0
     c3e:	b779                	j	bcc <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     c40:	9752                	add	a4,a4,s4
     c42:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     c46:	f9460713          	addi	a4,a2,-108
     c4a:	00173713          	seqz	a4,a4
     c4e:	8f75                	and	a4,a4,a3
     c50:	f9c58513          	addi	a0,a1,-100
     c54:	18051363          	bnez	a0,dda <vprintf+0x252>
     c58:	18070163          	beqz	a4,dda <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
     c5c:	008b8493          	addi	s1,s7,8
     c60:	4685                	li	a3,1
     c62:	4629                	li	a2,10
     c64:	000bb583          	ld	a1,0(s7)
     c68:	855a                	mv	a0,s6
     c6a:	e81ff0ef          	jal	aea <printint>
        i += 2;
     c6e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     c70:	8ba6                	mv	s7,s1
      state = 0;
     c72:	4981                	li	s3,0
        i += 2;
     c74:	bfa1                	j	bcc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     c76:	008b8493          	addi	s1,s7,8
     c7a:	4681                	li	a3,0
     c7c:	4629                	li	a2,10
     c7e:	000be583          	lwu	a1,0(s7)
     c82:	855a                	mv	a0,s6
     c84:	e67ff0ef          	jal	aea <printint>
     c88:	8ba6                	mv	s7,s1
      state = 0;
     c8a:	4981                	li	s3,0
     c8c:	b781                	j	bcc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     c8e:	008b8493          	addi	s1,s7,8
     c92:	4681                	li	a3,0
     c94:	4629                	li	a2,10
     c96:	000bb583          	ld	a1,0(s7)
     c9a:	855a                	mv	a0,s6
     c9c:	e4fff0ef          	jal	aea <printint>
        i += 1;
     ca0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     ca2:	8ba6                	mv	s7,s1
      state = 0;
     ca4:	4981                	li	s3,0
     ca6:	b71d                	j	bcc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ca8:	008b8493          	addi	s1,s7,8
     cac:	4681                	li	a3,0
     cae:	4629                	li	a2,10
     cb0:	000bb583          	ld	a1,0(s7)
     cb4:	855a                	mv	a0,s6
     cb6:	e35ff0ef          	jal	aea <printint>
        i += 2;
     cba:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     cbc:	8ba6                	mv	s7,s1
      state = 0;
     cbe:	4981                	li	s3,0
        i += 2;
     cc0:	b731                	j	bcc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     cc2:	008b8493          	addi	s1,s7,8
     cc6:	4681                	li	a3,0
     cc8:	4641                	li	a2,16
     cca:	000be583          	lwu	a1,0(s7)
     cce:	855a                	mv	a0,s6
     cd0:	e1bff0ef          	jal	aea <printint>
     cd4:	8ba6                	mv	s7,s1
      state = 0;
     cd6:	4981                	li	s3,0
     cd8:	bdd5                	j	bcc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     cda:	008b8493          	addi	s1,s7,8
     cde:	4681                	li	a3,0
     ce0:	4641                	li	a2,16
     ce2:	000bb583          	ld	a1,0(s7)
     ce6:	855a                	mv	a0,s6
     ce8:	e03ff0ef          	jal	aea <printint>
        i += 1;
     cec:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     cee:	8ba6                	mv	s7,s1
      state = 0;
     cf0:	4981                	li	s3,0
     cf2:	bde9                	j	bcc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     cf4:	008b8493          	addi	s1,s7,8
     cf8:	4681                	li	a3,0
     cfa:	4641                	li	a2,16
     cfc:	000bb583          	ld	a1,0(s7)
     d00:	855a                	mv	a0,s6
     d02:	de9ff0ef          	jal	aea <printint>
        i += 2;
     d06:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     d08:	8ba6                	mv	s7,s1
      state = 0;
     d0a:	4981                	li	s3,0
        i += 2;
     d0c:	b5c1                	j	bcc <vprintf+0x44>
     d0e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     d10:	008b8793          	addi	a5,s7,8
     d14:	8cbe                	mv	s9,a5
     d16:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     d1a:	03000593          	li	a1,48
     d1e:	855a                	mv	a0,s6
     d20:	dadff0ef          	jal	acc <putc>
  putc(fd, 'x');
     d24:	07800593          	li	a1,120
     d28:	855a                	mv	a0,s6
     d2a:	da3ff0ef          	jal	acc <putc>
     d2e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d30:	00000b97          	auipc	s7,0x0
     d34:	7b0b8b93          	addi	s7,s7,1968 # 14e0 <digits>
     d38:	03c9d793          	srli	a5,s3,0x3c
     d3c:	97de                	add	a5,a5,s7
     d3e:	0007c583          	lbu	a1,0(a5)
     d42:	855a                	mv	a0,s6
     d44:	d89ff0ef          	jal	acc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     d48:	0992                	slli	s3,s3,0x4
     d4a:	34fd                	addiw	s1,s1,-1
     d4c:	f4f5                	bnez	s1,d38 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     d4e:	8be6                	mv	s7,s9
      state = 0;
     d50:	4981                	li	s3,0
     d52:	6ca2                	ld	s9,8(sp)
     d54:	bda5                	j	bcc <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
     d56:	008b8493          	addi	s1,s7,8
     d5a:	000bc583          	lbu	a1,0(s7)
     d5e:	855a                	mv	a0,s6
     d60:	d6dff0ef          	jal	acc <putc>
     d64:	8ba6                	mv	s7,s1
      state = 0;
     d66:	4981                	li	s3,0
     d68:	b595                	j	bcc <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     d6a:	008b8993          	addi	s3,s7,8
     d6e:	000bb483          	ld	s1,0(s7)
     d72:	cc91                	beqz	s1,d8e <vprintf+0x206>
        for(; *s; s++)
     d74:	0004c583          	lbu	a1,0(s1)
     d78:	c985                	beqz	a1,da8 <vprintf+0x220>
          putc(fd, *s);
     d7a:	855a                	mv	a0,s6
     d7c:	d51ff0ef          	jal	acc <putc>
        for(; *s; s++)
     d80:	0485                	addi	s1,s1,1
     d82:	0004c583          	lbu	a1,0(s1)
     d86:	f9f5                	bnez	a1,d7a <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
     d88:	8bce                	mv	s7,s3
      state = 0;
     d8a:	4981                	li	s3,0
     d8c:	b581                	j	bcc <vprintf+0x44>
          s = "(null)";
     d8e:	00000497          	auipc	s1,0x0
     d92:	74a48493          	addi	s1,s1,1866 # 14d8 <malloc+0x5ae>
        for(; *s; s++)
     d96:	02800593          	li	a1,40
     d9a:	b7c5                	j	d7a <vprintf+0x1f2>
        putc(fd, '%');
     d9c:	85be                	mv	a1,a5
     d9e:	855a                	mv	a0,s6
     da0:	d2dff0ef          	jal	acc <putc>
      state = 0;
     da4:	4981                	li	s3,0
     da6:	b51d                	j	bcc <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     da8:	8bce                	mv	s7,s3
      state = 0;
     daa:	4981                	li	s3,0
     dac:	b505                	j	bcc <vprintf+0x44>
     dae:	6906                	ld	s2,64(sp)
     db0:	79e2                	ld	s3,56(sp)
     db2:	7a42                	ld	s4,48(sp)
     db4:	7aa2                	ld	s5,40(sp)
     db6:	7b02                	ld	s6,32(sp)
     db8:	6be2                	ld	s7,24(sp)
     dba:	6c42                	ld	s8,16(sp)
    }
  }
}
     dbc:	60e6                	ld	ra,88(sp)
     dbe:	6446                	ld	s0,80(sp)
     dc0:	64a6                	ld	s1,72(sp)
     dc2:	6125                	addi	sp,sp,96
     dc4:	8082                	ret
      if(c0 == 'd'){
     dc6:	06400713          	li	a4,100
     dca:	e4e78fe3          	beq	a5,a4,c28 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
     dce:	f9478693          	addi	a3,a5,-108
     dd2:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
     dd6:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     dd8:	4701                	li	a4,0
      } else if(c0 == 'u'){
     dda:	07500513          	li	a0,117
     dde:	e8a78ce3          	beq	a5,a0,c76 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
     de2:	f8b60513          	addi	a0,a2,-117
     de6:	e119                	bnez	a0,dec <vprintf+0x264>
     de8:	ea0693e3          	bnez	a3,c8e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     dec:	f8b58513          	addi	a0,a1,-117
     df0:	e119                	bnez	a0,df6 <vprintf+0x26e>
     df2:	ea071be3          	bnez	a4,ca8 <vprintf+0x120>
      } else if(c0 == 'x'){
     df6:	07800513          	li	a0,120
     dfa:	eca784e3          	beq	a5,a0,cc2 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
     dfe:	f8860613          	addi	a2,a2,-120
     e02:	e219                	bnez	a2,e08 <vprintf+0x280>
     e04:	ec069be3          	bnez	a3,cda <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e08:	f8858593          	addi	a1,a1,-120
     e0c:	e199                	bnez	a1,e12 <vprintf+0x28a>
     e0e:	ee0713e3          	bnez	a4,cf4 <vprintf+0x16c>
      } else if(c0 == 'p'){
     e12:	07000713          	li	a4,112
     e16:	eee78ce3          	beq	a5,a4,d0e <vprintf+0x186>
      } else if(c0 == 'c'){
     e1a:	06300713          	li	a4,99
     e1e:	f2e78ce3          	beq	a5,a4,d56 <vprintf+0x1ce>
      } else if(c0 == 's'){
     e22:	07300713          	li	a4,115
     e26:	f4e782e3          	beq	a5,a4,d6a <vprintf+0x1e2>
      } else if(c0 == '%'){
     e2a:	02500713          	li	a4,37
     e2e:	f6e787e3          	beq	a5,a4,d9c <vprintf+0x214>
        putc(fd, '%');
     e32:	02500593          	li	a1,37
     e36:	855a                	mv	a0,s6
     e38:	c95ff0ef          	jal	acc <putc>
        putc(fd, c0);
     e3c:	85a6                	mv	a1,s1
     e3e:	855a                	mv	a0,s6
     e40:	c8dff0ef          	jal	acc <putc>
      state = 0;
     e44:	4981                	li	s3,0
     e46:	b359                	j	bcc <vprintf+0x44>

0000000000000e48 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e48:	715d                	addi	sp,sp,-80
     e4a:	ec06                	sd	ra,24(sp)
     e4c:	e822                	sd	s0,16(sp)
     e4e:	1000                	addi	s0,sp,32
     e50:	e010                	sd	a2,0(s0)
     e52:	e414                	sd	a3,8(s0)
     e54:	e818                	sd	a4,16(s0)
     e56:	ec1c                	sd	a5,24(s0)
     e58:	03043023          	sd	a6,32(s0)
     e5c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     e60:	8622                	mv	a2,s0
     e62:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     e66:	d23ff0ef          	jal	b88 <vprintf>
}
     e6a:	60e2                	ld	ra,24(sp)
     e6c:	6442                	ld	s0,16(sp)
     e6e:	6161                	addi	sp,sp,80
     e70:	8082                	ret

0000000000000e72 <printf>:

void
printf(const char *fmt, ...)
{
     e72:	711d                	addi	sp,sp,-96
     e74:	ec06                	sd	ra,24(sp)
     e76:	e822                	sd	s0,16(sp)
     e78:	1000                	addi	s0,sp,32
     e7a:	e40c                	sd	a1,8(s0)
     e7c:	e810                	sd	a2,16(s0)
     e7e:	ec14                	sd	a3,24(s0)
     e80:	f018                	sd	a4,32(s0)
     e82:	f41c                	sd	a5,40(s0)
     e84:	03043823          	sd	a6,48(s0)
     e88:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     e8c:	00840613          	addi	a2,s0,8
     e90:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     e94:	85aa                	mv	a1,a0
     e96:	4505                	li	a0,1
     e98:	cf1ff0ef          	jal	b88 <vprintf>
}
     e9c:	60e2                	ld	ra,24(sp)
     e9e:	6442                	ld	s0,16(sp)
     ea0:	6125                	addi	sp,sp,96
     ea2:	8082                	ret

0000000000000ea4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     ea4:	1141                	addi	sp,sp,-16
     ea6:	e406                	sd	ra,8(sp)
     ea8:	e022                	sd	s0,0(sp)
     eaa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     eac:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     eb0:	00001797          	auipc	a5,0x1
     eb4:	1587b783          	ld	a5,344(a5) # 2008 <freep>
     eb8:	a039                	j	ec6 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     eba:	6398                	ld	a4,0(a5)
     ebc:	00e7e463          	bltu	a5,a4,ec4 <free+0x20>
     ec0:	00e6ea63          	bltu	a3,a4,ed4 <free+0x30>
{
     ec4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ec6:	fed7fae3          	bgeu	a5,a3,eba <free+0x16>
     eca:	6398                	ld	a4,0(a5)
     ecc:	00e6e463          	bltu	a3,a4,ed4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ed0:	fee7eae3          	bltu	a5,a4,ec4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
     ed4:	ff852583          	lw	a1,-8(a0)
     ed8:	6390                	ld	a2,0(a5)
     eda:	02059813          	slli	a6,a1,0x20
     ede:	01c85713          	srli	a4,a6,0x1c
     ee2:	9736                	add	a4,a4,a3
     ee4:	02e60563          	beq	a2,a4,f0e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
     ee8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
     eec:	4790                	lw	a2,8(a5)
     eee:	02061593          	slli	a1,a2,0x20
     ef2:	01c5d713          	srli	a4,a1,0x1c
     ef6:	973e                	add	a4,a4,a5
     ef8:	02e68263          	beq	a3,a4,f1c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
     efc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     efe:	00001717          	auipc	a4,0x1
     f02:	10f73523          	sd	a5,266(a4) # 2008 <freep>
}
     f06:	60a2                	ld	ra,8(sp)
     f08:	6402                	ld	s0,0(sp)
     f0a:	0141                	addi	sp,sp,16
     f0c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
     f0e:	4618                	lw	a4,8(a2)
     f10:	9f2d                	addw	a4,a4,a1
     f12:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f16:	6398                	ld	a4,0(a5)
     f18:	6310                	ld	a2,0(a4)
     f1a:	b7f9                	j	ee8 <free+0x44>
    p->s.size += bp->s.size;
     f1c:	ff852703          	lw	a4,-8(a0)
     f20:	9f31                	addw	a4,a4,a2
     f22:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     f24:	ff053683          	ld	a3,-16(a0)
     f28:	bfd1                	j	efc <free+0x58>

0000000000000f2a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     f2a:	7139                	addi	sp,sp,-64
     f2c:	fc06                	sd	ra,56(sp)
     f2e:	f822                	sd	s0,48(sp)
     f30:	f04a                	sd	s2,32(sp)
     f32:	ec4e                	sd	s3,24(sp)
     f34:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f36:	02051993          	slli	s3,a0,0x20
     f3a:	0209d993          	srli	s3,s3,0x20
     f3e:	09bd                	addi	s3,s3,15
     f40:	0049d993          	srli	s3,s3,0x4
     f44:	2985                	addiw	s3,s3,1
     f46:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
     f48:	00001517          	auipc	a0,0x1
     f4c:	0c053503          	ld	a0,192(a0) # 2008 <freep>
     f50:	c905                	beqz	a0,f80 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     f52:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     f54:	4798                	lw	a4,8(a5)
     f56:	09377663          	bgeu	a4,s3,fe2 <malloc+0xb8>
     f5a:	f426                	sd	s1,40(sp)
     f5c:	e852                	sd	s4,16(sp)
     f5e:	e456                	sd	s5,8(sp)
     f60:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
     f62:	8a4e                	mv	s4,s3
     f64:	6705                	lui	a4,0x1
     f66:	00e9f363          	bgeu	s3,a4,f6c <malloc+0x42>
     f6a:	6a05                	lui	s4,0x1
     f6c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
     f70:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
     f74:	00001497          	auipc	s1,0x1
     f78:	09448493          	addi	s1,s1,148 # 2008 <freep>
  if(p == SBRK_ERROR)
     f7c:	5afd                	li	s5,-1
     f7e:	a83d                	j	fbc <malloc+0x92>
     f80:	f426                	sd	s1,40(sp)
     f82:	e852                	sd	s4,16(sp)
     f84:	e456                	sd	s5,8(sp)
     f86:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
     f88:	00001797          	auipc	a5,0x1
     f8c:	08878793          	addi	a5,a5,136 # 2010 <base>
     f90:	00001717          	auipc	a4,0x1
     f94:	06f73c23          	sd	a5,120(a4) # 2008 <freep>
     f98:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
     f9a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
     f9e:	b7d1                	j	f62 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
     fa0:	6398                	ld	a4,0(a5)
     fa2:	e118                	sd	a4,0(a0)
     fa4:	a899                	j	ffa <malloc+0xd0>
  hp->s.size = nu;
     fa6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
     faa:	0541                	addi	a0,a0,16
     fac:	ef9ff0ef          	jal	ea4 <free>
  return freep;
     fb0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
     fb2:	c125                	beqz	a0,1012 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fb4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
     fb6:	4798                	lw	a4,8(a5)
     fb8:	03277163          	bgeu	a4,s2,fda <malloc+0xb0>
    if(p == freep)
     fbc:	6098                	ld	a4,0(s1)
     fbe:	853e                	mv	a0,a5
     fc0:	fef71ae3          	bne	a4,a5,fb4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
     fc4:	8552                	mv	a0,s4
     fc6:	9e3ff0ef          	jal	9a8 <sbrk>
  if(p == SBRK_ERROR)
     fca:	fd551ee3          	bne	a0,s5,fa6 <malloc+0x7c>
        return 0;
     fce:	4501                	li	a0,0
     fd0:	74a2                	ld	s1,40(sp)
     fd2:	6a42                	ld	s4,16(sp)
     fd4:	6aa2                	ld	s5,8(sp)
     fd6:	6b02                	ld	s6,0(sp)
     fd8:	a03d                	j	1006 <malloc+0xdc>
     fda:	74a2                	ld	s1,40(sp)
     fdc:	6a42                	ld	s4,16(sp)
     fde:	6aa2                	ld	s5,8(sp)
     fe0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
     fe2:	fae90fe3          	beq	s2,a4,fa0 <malloc+0x76>
        p->s.size -= nunits;
     fe6:	4137073b          	subw	a4,a4,s3
     fea:	c798                	sw	a4,8(a5)
        p += p->s.size;
     fec:	02071693          	slli	a3,a4,0x20
     ff0:	01c6d713          	srli	a4,a3,0x1c
     ff4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
     ff6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
     ffa:	00001717          	auipc	a4,0x1
     ffe:	00a73723          	sd	a0,14(a4) # 2008 <freep>
      return (void*)(p + 1);
    1002:	01078513          	addi	a0,a5,16
  }
}
    1006:	70e2                	ld	ra,56(sp)
    1008:	7442                	ld	s0,48(sp)
    100a:	7902                	ld	s2,32(sp)
    100c:	69e2                	ld	s3,24(sp)
    100e:	6121                	addi	sp,sp,64
    1010:	8082                	ret
    1012:	74a2                	ld	s1,40(sp)
    1014:	6a42                	ld	s4,16(sp)
    1016:	6aa2                	ld	s5,8(sp)
    1018:	6b02                	ld	s6,0(sp)
    101a:	b7f5                	j	1006 <malloc+0xdc>
