
user/_PA4_1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
  printf("=== test_vmstats done ===\n");
}

int
main(void)
{
   0:	7135                	addi	sp,sp,-160
   2:	ed06                	sd	ra,152(sp)
   4:	e922                	sd	s0,144(sp)
   6:	e526                	sd	s1,136(sp)
   8:	e14a                	sd	s2,128(sp)
   a:	fcce                	sd	s3,120(sp)
   c:	f8d2                	sd	s4,112(sp)
   e:	f4d6                	sd	s5,104(sp)
  10:	f0da                	sd	s6,96(sp)
  12:	1100                	addi	s0,sp,160
  printf("==============================\n");
  14:	00001517          	auipc	a0,0x1
  18:	e1c50513          	addi	a0,a0,-484 # e30 <malloc+0xfa>
  1c:	463000ef          	jal	c7e <printf>
  printf("PA4_A: vmstats syscall tests\n");
  20:	00001517          	auipc	a0,0x1
  24:	e3050513          	addi	a0,a0,-464 # e50 <malloc+0x11a>
  28:	457000ef          	jal	c7e <printf>
  printf("==============================\n\n");
  2c:	00001517          	auipc	a0,0x1
  30:	e4450513          	addi	a0,a0,-444 # e70 <malloc+0x13a>
  34:	44b000ef          	jal	c7e <printf>

  printf("--- PA4_1: getvmstats basic ---\n");
  38:	00001517          	auipc	a0,0x1
  3c:	e6050513          	addi	a0,a0,-416 # e98 <malloc+0x162>
  40:	43f000ef          	jal	c7e <printf>
  int pid = getpid();
  44:	025000ef          	jal	868 <getpid>
  48:	84aa                	mv	s1,a0
  rc = getvmstats(pid, &before);
  4a:	f6040593          	addi	a1,s0,-160
  4e:	07b000ef          	jal	8c8 <getvmstats>
  if(rc != 0){
  52:	e549                	bnez	a0,dc <main+0xdc>
  return s->page_faults     >= 0 &&
  54:	f6843783          	ld	a5,-152(s0)
  58:	f6043703          	ld	a4,-160(s0)
  5c:	8f5d                	or	a4,a4,a5
  5e:	57fd                	li	a5,-1
  60:	1782                	slli	a5,a5,0x20
  62:	0785                	addi	a5,a5,1
  64:	07fe                	slli	a5,a5,0x1f
  66:	8ff9                	and	a5,a5,a4
  68:	c3d1                	beqz	a5,ec <main+0xec>
    printf("FAIL: negative counter in initial stats\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	e7e50513          	addi	a0,a0,-386 # ee8 <malloc+0x1b2>
  72:	40d000ef          	jal	c7e <printf>
  test_pa4_1();

  printf("\n--- PA4_2: basic page fault ---\n");
  76:	00001517          	auipc	a0,0x1
  7a:	fd250513          	addi	a0,a0,-46 # 1048 <malloc+0x312>
  7e:	401000ef          	jal	c7e <printf>
  int pid = getpid();
  82:	7e6000ef          	jal	868 <getpid>
  86:	89aa                	mv	s3,a0
  printf("=== test_basic_pf: Basic Page Fault Test ===\n");
  88:	00001517          	auipc	a0,0x1
  8c:	fe850513          	addi	a0,a0,-24 # 1070 <malloc+0x33a>
  90:	3ef000ef          	jal	c7e <printf>
  printf("PID: %d\n", pid);
  94:	85ce                	mv	a1,s3
  96:	00001517          	auipc	a0,0x1
  9a:	00a50513          	addi	a0,a0,10 # 10a0 <malloc+0x36a>
  9e:	3e1000ef          	jal	c7e <printf>
  char *mem = sbrklazy(NUM_PAGES_2 * PAGE_SIZE_2);
  a2:	00040537          	lui	a0,0x40
  a6:	724000ef          	jal	7ca <sbrklazy>
  if(mem == (char*)-1){
  aa:	55fd                	li	a1,-1
  ac:	892a                	mv	s2,a0
  ae:	872a                	mv	a4,a0
  b0:	4785                	li	a5,1
  for(int i = 0; i < NUM_PAGES_2; i++)
  b2:	6605                	lui	a2,0x1
  b4:	04100693          	li	a3,65
  if(mem == (char*)-1){
  b8:	12b50b63          	beq	a0,a1,1ee <main+0x1ee>
    mem[i * PAGE_SIZE_2] = (char)(i + 1);
  bc:	00f70023          	sb	a5,0(a4)
  for(int i = 0; i < NUM_PAGES_2; i++)
  c0:	0785                	addi	a5,a5,1
  c2:	9732                	add	a4,a4,a2
  c4:	fed79ce3          	bne	a5,a3,bc <main+0xbc>
  int ok = 1;
  c8:	4685                	li	a3,1
  for(int i = 0; i < NUM_PAGES_2; i++){
  ca:	4481                	li	s1,0
      printf("FAIL: data mismatch at page %d\n", i);
  cc:	00001b17          	auipc	s6,0x1
  d0:	fe4b0b13          	addi	s6,s6,-28 # 10b0 <malloc+0x37a>
  for(int i = 0; i < NUM_PAGES_2; i++){
  d4:	6a85                	lui	s5,0x1
  d6:	04000a13          	li	s4,64
  da:	aa15                	j	20e <main+0x20e>
    printf("FAIL: getvmstats(self) returned %d\n", rc);
  dc:	85aa                	mv	a1,a0
  de:	00001517          	auipc	a0,0x1
  e2:	de250513          	addi	a0,a0,-542 # ec0 <malloc+0x18a>
  e6:	399000ef          	jal	c7e <printf>
    return;
  ea:	b771                	j	76 <main+0x76>
  if(!all_non_negative(&before)){
  ec:	f7042783          	lw	a5,-144(s0)
  f0:	f607cde3          	bltz	a5,6a <main+0x6a>
  char *base = sbrklazy(2 * 4096);
  f4:	6509                	lui	a0,0x2
  f6:	6d4000ef          	jal	7ca <sbrklazy>
  if(base == (char*)-1){
  fa:	57fd                	li	a5,-1
  fc:	04f50463          	beq	a0,a5,144 <main+0x144>
  base[0]    = 'x';
 100:	07800793          	li	a5,120
 104:	00f50023          	sb	a5,0(a0) # 2000 <freep>
  base[4096] = 'y';
 108:	6785                	lui	a5,0x1
 10a:	953e                	add	a0,a0,a5
 10c:	07900793          	li	a5,121
 110:	00f50023          	sb	a5,0(a0)
  rc = getvmstats(pid, &after);
 114:	f9040593          	addi	a1,s0,-112
 118:	8526                	mv	a0,s1
 11a:	7ae000ef          	jal	8c8 <getvmstats>
  if(rc != 0){
 11e:	e915                	bnez	a0,152 <main+0x152>
  return s->page_faults     >= 0 &&
 120:	f9043783          	ld	a5,-112(s0)
 124:	f9843703          	ld	a4,-104(s0)
 128:	8f5d                	or	a4,a4,a5
 12a:	57fd                	li	a5,-1
 12c:	1782                	slli	a5,a5,0x20
 12e:	0785                	addi	a5,a5,1 # 1001 <malloc+0x2cb>
 130:	07fe                	slli	a5,a5,0x1f
 132:	8ff9                	and	a5,a5,a4
 134:	c79d                	beqz	a5,162 <main+0x162>
    printf("FAIL: negative counter in final stats\n");
 136:	00001517          	auipc	a0,0x1
 13a:	e2a50513          	addi	a0,a0,-470 # f60 <malloc+0x22a>
 13e:	341000ef          	jal	c7e <printf>
    return;
 142:	bf15                	j	76 <main+0x76>
    printf("FAIL: sbrk failed\n");
 144:	00001517          	auipc	a0,0x1
 148:	dd450513          	addi	a0,a0,-556 # f18 <malloc+0x1e2>
 14c:	333000ef          	jal	c7e <printf>
    return;
 150:	b71d                	j	76 <main+0x76>
    printf("FAIL: getvmstats(after touch) returned %d\n", rc);
 152:	85aa                	mv	a1,a0
 154:	00001517          	auipc	a0,0x1
 158:	ddc50513          	addi	a0,a0,-548 # f30 <malloc+0x1fa>
 15c:	323000ef          	jal	c7e <printf>
    return;
 160:	bf19                	j	76 <main+0x76>
  return s->page_faults     >= 0 &&
 162:	f9042603          	lw	a2,-112(s0)
  if(!all_non_negative(&after)){
 166:	fa042783          	lw	a5,-96(s0)
 16a:	fc07c6e3          	bltz	a5,136 <main+0x136>
  if(after.page_faults < before.page_faults){
 16e:	f6042583          	lw	a1,-160(s0)
 172:	06b64063          	blt	a2,a1,1d2 <main+0x1d2>
  if(getvmstats(-1, &after) >= 0){
 176:	f9040593          	addi	a1,s0,-112
 17a:	557d                	li	a0,-1
 17c:	74c000ef          	jal	8c8 <getvmstats>
 180:	06055063          	bgez	a0,1e0 <main+0x1e0>
  printf("PASS: getvmstats works\n");
 184:	00001517          	auipc	a0,0x1
 188:	e4c50513          	addi	a0,a0,-436 # fd0 <malloc+0x29a>
 18c:	2f3000ef          	jal	c7e <printf>
  printf("before: pf=%d ev=%d in=%d out=%d res=%d\n",
 190:	f7042783          	lw	a5,-144(s0)
 194:	f6c42703          	lw	a4,-148(s0)
 198:	f6842683          	lw	a3,-152(s0)
 19c:	f6442603          	lw	a2,-156(s0)
 1a0:	f6042583          	lw	a1,-160(s0)
 1a4:	00001517          	auipc	a0,0x1
 1a8:	e4450513          	addi	a0,a0,-444 # fe8 <malloc+0x2b2>
 1ac:	2d3000ef          	jal	c7e <printf>
  printf("after : pf=%d ev=%d in=%d out=%d res=%d\n",
 1b0:	fa042783          	lw	a5,-96(s0)
 1b4:	f9c42703          	lw	a4,-100(s0)
 1b8:	f9842683          	lw	a3,-104(s0)
 1bc:	f9442603          	lw	a2,-108(s0)
 1c0:	f9042583          	lw	a1,-112(s0)
 1c4:	00001517          	auipc	a0,0x1
 1c8:	e5450513          	addi	a0,a0,-428 # 1018 <malloc+0x2e2>
 1cc:	2b3000ef          	jal	c7e <printf>
 1d0:	b55d                	j	76 <main+0x76>
    printf("FAIL: page_faults decreased (%d -> %d)\n",
 1d2:	00001517          	auipc	a0,0x1
 1d6:	db650513          	addi	a0,a0,-586 # f88 <malloc+0x252>
 1da:	2a5000ef          	jal	c7e <printf>
    return;
 1de:	bd61                	j	76 <main+0x76>
    printf("FAIL: invalid pid should fail\n");
 1e0:	00001517          	auipc	a0,0x1
 1e4:	dd050513          	addi	a0,a0,-560 # fb0 <malloc+0x27a>
 1e8:	297000ef          	jal	c7e <printf>
    return;
 1ec:	b569                	j	76 <main+0x76>
    printf("FAIL: sbrk failed\n");
 1ee:	00001517          	auipc	a0,0x1
 1f2:	d2a50513          	addi	a0,a0,-726 # f18 <malloc+0x1e2>
 1f6:	289000ef          	jal	c7e <printf>
    return;
 1fa:	a239                	j	308 <main+0x308>
      printf("FAIL: data mismatch at page %d\n", i);
 1fc:	85a6                	mv	a1,s1
 1fe:	855a                	mv	a0,s6
 200:	27f000ef          	jal	c7e <printf>
      ok = 0;
 204:	4681                	li	a3,0
  for(int i = 0; i < NUM_PAGES_2; i++){
 206:	2485                	addiw	s1,s1,1
 208:	9956                	add	s2,s2,s5
 20a:	01448b63          	beq	s1,s4,220 <main+0x220>
    if(mem[i * PAGE_SIZE_2] != (char)(i + 1)){
 20e:	0014879b          	addiw	a5,s1,1
 212:	00094703          	lbu	a4,0(s2)
 216:	0ff7f793          	zext.b	a5,a5
 21a:	fef706e3          	beq	a4,a5,206 <main+0x206>
 21e:	bff9                	j	1fc <main+0x1fc>
  if(ok)
 220:	26069263          	bnez	a3,484 <main+0x484>
  if(getvmstats(pid, &st) != 0){
 224:	f9040593          	addi	a1,s0,-112
 228:	854e                	mv	a0,s3
 22a:	69e000ef          	jal	8c8 <getvmstats>
 22e:	26051463          	bnez	a0,496 <main+0x496>
  printf("\n--- VM Stats for PID %d ---\n", pid);
 232:	85ce                	mv	a1,s3
 234:	00001517          	auipc	a0,0x1
 238:	efc50513          	addi	a0,a0,-260 # 1130 <malloc+0x3fa>
 23c:	243000ef          	jal	c7e <printf>
  printf("  page_faults      : %d\n",  st.page_faults);
 240:	f9042583          	lw	a1,-112(s0)
 244:	00001517          	auipc	a0,0x1
 248:	f0c50513          	addi	a0,a0,-244 # 1150 <malloc+0x41a>
 24c:	233000ef          	jal	c7e <printf>
  printf("  pages_evicted    : %d\n",  st.pages_evicted);
 250:	f9442583          	lw	a1,-108(s0)
 254:	00001517          	auipc	a0,0x1
 258:	f1c50513          	addi	a0,a0,-228 # 1170 <malloc+0x43a>
 25c:	223000ef          	jal	c7e <printf>
  printf("  pages_swapped_in : %d\n",  st.pages_swapped_in);
 260:	f9842583          	lw	a1,-104(s0)
 264:	00001517          	auipc	a0,0x1
 268:	f2c50513          	addi	a0,a0,-212 # 1190 <malloc+0x45a>
 26c:	213000ef          	jal	c7e <printf>
  printf("  pages_swapped_out: %d\n",  st.pages_swapped_out);
 270:	f9c42583          	lw	a1,-100(s0)
 274:	00001517          	auipc	a0,0x1
 278:	f3c50513          	addi	a0,a0,-196 # 11b0 <malloc+0x47a>
 27c:	203000ef          	jal	c7e <printf>
  printf("  resident_pages   : %d\n",  st.resident_pages);
 280:	fa042583          	lw	a1,-96(s0)
 284:	00001517          	auipc	a0,0x1
 288:	f4c50513          	addi	a0,a0,-180 # 11d0 <malloc+0x49a>
 28c:	1f3000ef          	jal	c7e <printf>
  printf("  disk_reads       : %lu\n", st.disk_reads);
 290:	fa843583          	ld	a1,-88(s0)
 294:	00001517          	auipc	a0,0x1
 298:	f5c50513          	addi	a0,a0,-164 # 11f0 <malloc+0x4ba>
 29c:	1e3000ef          	jal	c7e <printf>
  printf("  disk_writes      : %lu\n", st.disk_writes);
 2a0:	fb043583          	ld	a1,-80(s0)
 2a4:	00001517          	auipc	a0,0x1
 2a8:	f6c50513          	addi	a0,a0,-148 # 1210 <malloc+0x4da>
 2ac:	1d3000ef          	jal	c7e <printf>
  printf("  avg_disk_latency : %lu\n", st.avg_disk_latency);
 2b0:	fb843583          	ld	a1,-72(s0)
 2b4:	00001517          	auipc	a0,0x1
 2b8:	f7c50513          	addi	a0,a0,-132 # 1230 <malloc+0x4fa>
 2bc:	1c3000ef          	jal	c7e <printf>
  if(st.page_faults > 0 && st.page_faults <= NUM_PAGES_2)
 2c0:	f9042583          	lw	a1,-112(s0)
 2c4:	fff5871b          	addiw	a4,a1,-1
 2c8:	03f00793          	li	a5,63
 2cc:	1ce7ec63          	bltu	a5,a4,4a4 <main+0x4a4>
    printf("PASS: page_faults (%d) in expected range [1, %d]\n",
 2d0:	04000613          	li	a2,64
 2d4:	00001517          	auipc	a0,0x1
 2d8:	f7c50513          	addi	a0,a0,-132 # 1250 <malloc+0x51a>
 2dc:	1a3000ef          	jal	c7e <printf>
  if(getvmstats(-1, &st) == -1)
 2e0:	f9040593          	addi	a1,s0,-112
 2e4:	557d                	li	a0,-1
 2e6:	5e2000ef          	jal	8c8 <getvmstats>
 2ea:	57fd                	li	a5,-1
 2ec:	1cf50663          	beq	a0,a5,4b8 <main+0x4b8>
    printf("FAIL: getvmstats(-1) should return -1\n");
 2f0:	00001517          	auipc	a0,0x1
 2f4:	ff850513          	addi	a0,a0,-8 # 12e8 <malloc+0x5b2>
 2f8:	187000ef          	jal	c7e <printf>
  printf("=== test_basic_pf done ===\n");
 2fc:	00001517          	auipc	a0,0x1
 300:	01450513          	addi	a0,a0,20 # 1310 <malloc+0x5da>
 304:	17b000ef          	jal	c7e <printf>
  test_pa4_2();

  printf("\n--- PA4_7: vmstats correctness ---\n");
 308:	00001517          	auipc	a0,0x1
 30c:	02850513          	addi	a0,a0,40 # 1330 <malloc+0x5fa>
 310:	16f000ef          	jal	c7e <printf>
  int pid = getpid();
 314:	554000ef          	jal	868 <getpid>
 318:	84aa                	mv	s1,a0
  printf("=== test_vmstats: System Call Correctness ===\n");
 31a:	00001517          	auipc	a0,0x1
 31e:	03e50513          	addi	a0,a0,62 # 1358 <malloc+0x622>
 322:	15d000ef          	jal	c7e <printf>
  printf("[Test 1] Invalid PID\n");
 326:	00001517          	auipc	a0,0x1
 32a:	06250513          	addi	a0,a0,98 # 1388 <malloc+0x652>
 32e:	151000ef          	jal	c7e <printf>
  if(getvmstats(-1, &st1) == -1)
 332:	f6040593          	addi	a1,s0,-160
 336:	557d                	li	a0,-1
 338:	590000ef          	jal	8c8 <getvmstats>
 33c:	57fd                	li	a5,-1
 33e:	18f50463          	beq	a0,a5,4c6 <main+0x4c6>
    printf("  FAIL: getvmstats(-1) should return -1\n");
 342:	00001517          	auipc	a0,0x1
 346:	07e50513          	addi	a0,a0,126 # 13c0 <malloc+0x68a>
 34a:	135000ef          	jal	c7e <printf>
  if(getvmstats(99999, &st1) == -1)
 34e:	f6040593          	addi	a1,s0,-160
 352:	6561                	lui	a0,0x18
 354:	69f50513          	addi	a0,a0,1695 # 1869f <base+0x1668f>
 358:	570000ef          	jal	8c8 <getvmstats>
 35c:	57fd                	li	a5,-1
 35e:	16f50b63          	beq	a0,a5,4d4 <main+0x4d4>
    printf("  FAIL: getvmstats(99999) should return -1\n");
 362:	00001517          	auipc	a0,0x1
 366:	0b650513          	addi	a0,a0,182 # 1418 <malloc+0x6e2>
 36a:	115000ef          	jal	c7e <printf>
  printf("[Test 2] Fresh process stats\n");
 36e:	00001517          	auipc	a0,0x1
 372:	0da50513          	addi	a0,a0,218 # 1448 <malloc+0x712>
 376:	109000ef          	jal	c7e <printf>
  getvmstats(pid, &st1);
 37a:	f6040593          	addi	a1,s0,-160
 37e:	8526                	mv	a0,s1
 380:	548000ef          	jal	8c8 <getvmstats>
  printf("  Initial page_faults: %d\n", st1.page_faults);
 384:	f6042583          	lw	a1,-160(s0)
 388:	00001517          	auipc	a0,0x1
 38c:	0e050513          	addi	a0,a0,224 # 1468 <malloc+0x732>
 390:	0ef000ef          	jal	c7e <printf>
  printf("[Test 3] Monotonic increase\n");
 394:	00001517          	auipc	a0,0x1
 398:	0f450513          	addi	a0,a0,244 # 1488 <malloc+0x752>
 39c:	0e3000ef          	jal	c7e <printf>
  char *mem = sbrklazy((uint64)PARENT_PAGES * PAGE_SIZE_7);
 3a0:	653d                	lui	a0,0xf
 3a2:	428000ef          	jal	7ca <sbrklazy>
  for(int i = 0; i < PARENT_PAGES; i++)
 3a6:	4781                	li	a5,0
 3a8:	6685                	lui	a3,0x1
 3aa:	473d                	li	a4,15
    mem[i * PAGE_SIZE_7] = (char)i;
 3ac:	00f50023          	sb	a5,0(a0) # f000 <base+0xcff0>
  for(int i = 0; i < PARENT_PAGES; i++)
 3b0:	2785                	addiw	a5,a5,1
 3b2:	9536                	add	a0,a0,a3
 3b4:	fee79ce3          	bne	a5,a4,3ac <main+0x3ac>
  getvmstats(pid, &st2);
 3b8:	f9040593          	addi	a1,s0,-112
 3bc:	8526                	mv	a0,s1
 3be:	50a000ef          	jal	8c8 <getvmstats>
  if(st2.page_faults >= st1.page_faults)
 3c2:	f9042603          	lw	a2,-112(s0)
 3c6:	f6042583          	lw	a1,-160(s0)
 3ca:	10b64c63          	blt	a2,a1,4e2 <main+0x4e2>
    printf("  PASS: page_faults non-decreasing (%d -> %d)\n",
 3ce:	00001517          	auipc	a0,0x1
 3d2:	0da50513          	addi	a0,a0,218 # 14a8 <malloc+0x772>
 3d6:	0a9000ef          	jal	c7e <printf>
  if(st2.resident_pages <= FRAME_LIMIT_7)
 3da:	fa042583          	lw	a1,-96(s0)
 3de:	02000793          	li	a5,32
 3e2:	10b7c763          	blt	a5,a1,4f0 <main+0x4f0>
    printf("  PASS: resident_pages (%d) <= FRAME_LIMIT (%d)\n",
 3e6:	863e                	mv	a2,a5
 3e8:	00001517          	auipc	a0,0x1
 3ec:	11850513          	addi	a0,a0,280 # 1500 <malloc+0x7ca>
 3f0:	08f000ef          	jal	c7e <printf>
  printf("[Test 4] Per-process stat isolation\n");
 3f4:	00001517          	auipc	a0,0x1
 3f8:	17450513          	addi	a0,a0,372 # 1568 <malloc+0x832>
 3fc:	083000ef          	jal	c7e <printf>
  getvmstats(pid, &st1);
 400:	f6040593          	addi	a1,s0,-160
 404:	8526                	mv	a0,s1
 406:	4c2000ef          	jal	8c8 <getvmstats>
  int child_pid = fork();
 40a:	3d6000ef          	jal	7e0 <fork>
 40e:	892a                	mv	s2,a0
  if(child_pid == 0){
 410:	0e050963          	beqz	a0,502 <main+0x502>
  wait(0);
 414:	4501                	li	a0,0
 416:	3da000ef          	jal	7f0 <wait>
  getvmstats(pid, &st2);
 41a:	f9040593          	addi	a1,s0,-112
 41e:	8526                	mv	a0,s1
 420:	4a8000ef          	jal	8c8 <getvmstats>
  int parent_delta = st2.page_faults - st1.page_faults;
 424:	f9042583          	lw	a1,-112(s0)
 428:	f6042783          	lw	a5,-160(s0)
 42c:	9d9d                	subw	a1,a1,a5
  if(parent_delta < CHILD_PAGES)
 42e:	47cd                	li	a5,19
 430:	0eb7ca63          	blt	a5,a1,524 <main+0x524>
    printf("  PASS: parent page_faults unchanged by child (delta=%d)\n", parent_delta);
 434:	00001517          	auipc	a0,0x1
 438:	15c50513          	addi	a0,a0,348 # 1590 <malloc+0x85a>
 43c:	043000ef          	jal	c7e <printf>
  printf("[Test 5] Dead child PID\n");
 440:	00001517          	auipc	a0,0x1
 444:	1c050513          	addi	a0,a0,448 # 1600 <malloc+0x8ca>
 448:	037000ef          	jal	c7e <printf>
  int ret = getvmstats(child_pid, &st1);
 44c:	f6040593          	addi	a1,s0,-160
 450:	854a                	mv	a0,s2
 452:	476000ef          	jal	8c8 <getvmstats>
 456:	862a                	mv	a2,a0
  printf("  getvmstats(dead child %d) returned %d (acceptable: -1 or 0)\n",
 458:	85ca                	mv	a1,s2
 45a:	00001517          	auipc	a0,0x1
 45e:	1c650513          	addi	a0,a0,454 # 1620 <malloc+0x8ea>
 462:	01d000ef          	jal	c7e <printf>
  printf("=== test_vmstats done ===\n");
 466:	00001517          	auipc	a0,0x1
 46a:	1fa50513          	addi	a0,a0,506 # 1660 <malloc+0x92a>
 46e:	011000ef          	jal	c7e <printf>
  test_pa4_7();

  printf("\nPA4_A done.\n");
 472:	00001517          	auipc	a0,0x1
 476:	20e50513          	addi	a0,a0,526 # 1680 <malloc+0x94a>
 47a:	005000ef          	jal	c7e <printf>
  exit(0);
 47e:	4501                	li	a0,0
 480:	368000ef          	jal	7e8 <exit>
    printf("PASS: all %d pages written and read back correctly\n", NUM_PAGES_2);
 484:	04000593          	li	a1,64
 488:	00001517          	auipc	a0,0x1
 48c:	c4850513          	addi	a0,a0,-952 # 10d0 <malloc+0x39a>
 490:	7ee000ef          	jal	c7e <printf>
 494:	bb41                	j	224 <main+0x224>
    printf("FAIL: getvmstats returned error\n");
 496:	00001517          	auipc	a0,0x1
 49a:	c7250513          	addi	a0,a0,-910 # 1108 <malloc+0x3d2>
 49e:	7e0000ef          	jal	c7e <printf>
    return;
 4a2:	b59d                	j	308 <main+0x308>
    printf("FAIL: expected page_faults in [1, %d], got %d\n",
 4a4:	862e                	mv	a2,a1
 4a6:	04000593          	li	a1,64
 4aa:	00001517          	auipc	a0,0x1
 4ae:	dde50513          	addi	a0,a0,-546 # 1288 <malloc+0x552>
 4b2:	7cc000ef          	jal	c7e <printf>
 4b6:	b52d                	j	2e0 <main+0x2e0>
    printf("PASS: getvmstats(-1) correctly returned -1\n");
 4b8:	00001517          	auipc	a0,0x1
 4bc:	e0050513          	addi	a0,a0,-512 # 12b8 <malloc+0x582>
 4c0:	7be000ef          	jal	c7e <printf>
 4c4:	bd25                	j	2fc <main+0x2fc>
    printf("  PASS: getvmstats(-1) -> -1\n");
 4c6:	00001517          	auipc	a0,0x1
 4ca:	eda50513          	addi	a0,a0,-294 # 13a0 <malloc+0x66a>
 4ce:	7b0000ef          	jal	c7e <printf>
 4d2:	bdb5                	j	34e <main+0x34e>
    printf("  PASS: getvmstats(99999) -> -1\n");
 4d4:	00001517          	auipc	a0,0x1
 4d8:	f1c50513          	addi	a0,a0,-228 # 13f0 <malloc+0x6ba>
 4dc:	7a2000ef          	jal	c7e <printf>
 4e0:	b579                	j	36e <main+0x36e>
    printf("  FAIL: page_faults went backwards!\n");
 4e2:	00001517          	auipc	a0,0x1
 4e6:	ff650513          	addi	a0,a0,-10 # 14d8 <malloc+0x7a2>
 4ea:	794000ef          	jal	c7e <printf>
 4ee:	b5f5                	j	3da <main+0x3da>
    printf("  FAIL: resident_pages (%d) > FRAME_LIMIT (%d)\n",
 4f0:	02000613          	li	a2,32
 4f4:	00001517          	auipc	a0,0x1
 4f8:	04450513          	addi	a0,a0,68 # 1538 <malloc+0x802>
 4fc:	782000ef          	jal	c7e <printf>
 500:	bdd5                	j	3f4 <main+0x3f4>
    char *cmem = sbrklazy((uint64)CHILD_PAGES * PAGE_SIZE_7);
 502:	6551                	lui	a0,0x14
 504:	2c6000ef          	jal	7ca <sbrklazy>
 508:	872a                	mv	a4,a0
 50a:	4781                	li	a5,0
    for(int i = 0; i < CHILD_PAGES; i++)
 50c:	4651                	li	a2,20
      cmem[i * PAGE_SIZE_7] = (char)i;
 50e:	00c79693          	slli	a3,a5,0xc
 512:	96ba                	add	a3,a3,a4
 514:	00f68023          	sb	a5,0(a3) # 1000 <malloc+0x2ca>
    for(int i = 0; i < CHILD_PAGES; i++)
 518:	0785                	addi	a5,a5,1
 51a:	fec79ae3          	bne	a5,a2,50e <main+0x50e>
    exit(0);
 51e:	4501                	li	a0,0
 520:	2c8000ef          	jal	7e8 <exit>
    printf("  WARN: parent page_faults increased by %d\n", parent_delta);
 524:	00001517          	auipc	a0,0x1
 528:	0ac50513          	addi	a0,a0,172 # 15d0 <malloc+0x89a>
 52c:	752000ef          	jal	c7e <printf>
 530:	bf01                	j	440 <main+0x440>

0000000000000532 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 532:	1141                	addi	sp,sp,-16
 534:	e406                	sd	ra,8(sp)
 536:	e022                	sd	s0,0(sp)
 538:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 53a:	ac7ff0ef          	jal	0 <main>
  exit(r);
 53e:	2aa000ef          	jal	7e8 <exit>

0000000000000542 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 542:	1141                	addi	sp,sp,-16
 544:	e406                	sd	ra,8(sp)
 546:	e022                	sd	s0,0(sp)
 548:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 54a:	87aa                	mv	a5,a0
 54c:	0585                	addi	a1,a1,1
 54e:	0785                	addi	a5,a5,1
 550:	fff5c703          	lbu	a4,-1(a1)
 554:	fee78fa3          	sb	a4,-1(a5)
 558:	fb75                	bnez	a4,54c <strcpy+0xa>
    ;
  return os;
}
 55a:	60a2                	ld	ra,8(sp)
 55c:	6402                	ld	s0,0(sp)
 55e:	0141                	addi	sp,sp,16
 560:	8082                	ret

0000000000000562 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 562:	1141                	addi	sp,sp,-16
 564:	e406                	sd	ra,8(sp)
 566:	e022                	sd	s0,0(sp)
 568:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 56a:	00054783          	lbu	a5,0(a0)
 56e:	cb91                	beqz	a5,582 <strcmp+0x20>
 570:	0005c703          	lbu	a4,0(a1)
 574:	00f71763          	bne	a4,a5,582 <strcmp+0x20>
    p++, q++;
 578:	0505                	addi	a0,a0,1
 57a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 57c:	00054783          	lbu	a5,0(a0)
 580:	fbe5                	bnez	a5,570 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 582:	0005c503          	lbu	a0,0(a1)
}
 586:	40a7853b          	subw	a0,a5,a0
 58a:	60a2                	ld	ra,8(sp)
 58c:	6402                	ld	s0,0(sp)
 58e:	0141                	addi	sp,sp,16
 590:	8082                	ret

0000000000000592 <strlen>:

uint
strlen(const char *s)
{
 592:	1141                	addi	sp,sp,-16
 594:	e406                	sd	ra,8(sp)
 596:	e022                	sd	s0,0(sp)
 598:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 59a:	00054783          	lbu	a5,0(a0)
 59e:	cf91                	beqz	a5,5ba <strlen+0x28>
 5a0:	00150793          	addi	a5,a0,1
 5a4:	86be                	mv	a3,a5
 5a6:	0785                	addi	a5,a5,1
 5a8:	fff7c703          	lbu	a4,-1(a5)
 5ac:	ff65                	bnez	a4,5a4 <strlen+0x12>
 5ae:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 5b2:	60a2                	ld	ra,8(sp)
 5b4:	6402                	ld	s0,0(sp)
 5b6:	0141                	addi	sp,sp,16
 5b8:	8082                	ret
  for(n = 0; s[n]; n++)
 5ba:	4501                	li	a0,0
 5bc:	bfdd                	j	5b2 <strlen+0x20>

00000000000005be <memset>:

void*
memset(void *dst, int c, uint n)
{
 5be:	1141                	addi	sp,sp,-16
 5c0:	e406                	sd	ra,8(sp)
 5c2:	e022                	sd	s0,0(sp)
 5c4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5c6:	ca19                	beqz	a2,5dc <memset+0x1e>
 5c8:	87aa                	mv	a5,a0
 5ca:	1602                	slli	a2,a2,0x20
 5cc:	9201                	srli	a2,a2,0x20
 5ce:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5d2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5d6:	0785                	addi	a5,a5,1
 5d8:	fee79de3          	bne	a5,a4,5d2 <memset+0x14>
  }
  return dst;
}
 5dc:	60a2                	ld	ra,8(sp)
 5de:	6402                	ld	s0,0(sp)
 5e0:	0141                	addi	sp,sp,16
 5e2:	8082                	ret

00000000000005e4 <strchr>:

char*
strchr(const char *s, char c)
{
 5e4:	1141                	addi	sp,sp,-16
 5e6:	e406                	sd	ra,8(sp)
 5e8:	e022                	sd	s0,0(sp)
 5ea:	0800                	addi	s0,sp,16
  for(; *s; s++)
 5ec:	00054783          	lbu	a5,0(a0)
 5f0:	cf81                	beqz	a5,608 <strchr+0x24>
    if(*s == c)
 5f2:	00f58763          	beq	a1,a5,600 <strchr+0x1c>
  for(; *s; s++)
 5f6:	0505                	addi	a0,a0,1
 5f8:	00054783          	lbu	a5,0(a0)
 5fc:	fbfd                	bnez	a5,5f2 <strchr+0xe>
      return (char*)s;
  return 0;
 5fe:	4501                	li	a0,0
}
 600:	60a2                	ld	ra,8(sp)
 602:	6402                	ld	s0,0(sp)
 604:	0141                	addi	sp,sp,16
 606:	8082                	ret
  return 0;
 608:	4501                	li	a0,0
 60a:	bfdd                	j	600 <strchr+0x1c>

000000000000060c <gets>:

char*
gets(char *buf, int max)
{
 60c:	711d                	addi	sp,sp,-96
 60e:	ec86                	sd	ra,88(sp)
 610:	e8a2                	sd	s0,80(sp)
 612:	e4a6                	sd	s1,72(sp)
 614:	e0ca                	sd	s2,64(sp)
 616:	fc4e                	sd	s3,56(sp)
 618:	f852                	sd	s4,48(sp)
 61a:	f456                	sd	s5,40(sp)
 61c:	f05a                	sd	s6,32(sp)
 61e:	ec5e                	sd	s7,24(sp)
 620:	e862                	sd	s8,16(sp)
 622:	1080                	addi	s0,sp,96
 624:	8baa                	mv	s7,a0
 626:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 628:	892a                	mv	s2,a0
 62a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 62c:	faf40b13          	addi	s6,s0,-81
 630:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 632:	8c26                	mv	s8,s1
 634:	0014899b          	addiw	s3,s1,1
 638:	84ce                	mv	s1,s3
 63a:	0349d463          	bge	s3,s4,662 <gets+0x56>
    cc = read(0, &c, 1);
 63e:	8656                	mv	a2,s5
 640:	85da                	mv	a1,s6
 642:	4501                	li	a0,0
 644:	1bc000ef          	jal	800 <read>
    if(cc < 1)
 648:	00a05d63          	blez	a0,662 <gets+0x56>
      break;
    buf[i++] = c;
 64c:	faf44783          	lbu	a5,-81(s0)
 650:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 654:	0905                	addi	s2,s2,1
 656:	ff678713          	addi	a4,a5,-10
 65a:	c319                	beqz	a4,660 <gets+0x54>
 65c:	17cd                	addi	a5,a5,-13
 65e:	fbf1                	bnez	a5,632 <gets+0x26>
    buf[i++] = c;
 660:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 662:	9c5e                	add	s8,s8,s7
 664:	000c0023          	sb	zero,0(s8)
  return buf;
}
 668:	855e                	mv	a0,s7
 66a:	60e6                	ld	ra,88(sp)
 66c:	6446                	ld	s0,80(sp)
 66e:	64a6                	ld	s1,72(sp)
 670:	6906                	ld	s2,64(sp)
 672:	79e2                	ld	s3,56(sp)
 674:	7a42                	ld	s4,48(sp)
 676:	7aa2                	ld	s5,40(sp)
 678:	7b02                	ld	s6,32(sp)
 67a:	6be2                	ld	s7,24(sp)
 67c:	6c42                	ld	s8,16(sp)
 67e:	6125                	addi	sp,sp,96
 680:	8082                	ret

0000000000000682 <stat>:

int
stat(const char *n, struct stat *st)
{
 682:	1101                	addi	sp,sp,-32
 684:	ec06                	sd	ra,24(sp)
 686:	e822                	sd	s0,16(sp)
 688:	e04a                	sd	s2,0(sp)
 68a:	1000                	addi	s0,sp,32
 68c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 68e:	4581                	li	a1,0
 690:	198000ef          	jal	828 <open>
  if(fd < 0)
 694:	02054263          	bltz	a0,6b8 <stat+0x36>
 698:	e426                	sd	s1,8(sp)
 69a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 69c:	85ca                	mv	a1,s2
 69e:	1a2000ef          	jal	840 <fstat>
 6a2:	892a                	mv	s2,a0
  close(fd);
 6a4:	8526                	mv	a0,s1
 6a6:	16a000ef          	jal	810 <close>
  return r;
 6aa:	64a2                	ld	s1,8(sp)
}
 6ac:	854a                	mv	a0,s2
 6ae:	60e2                	ld	ra,24(sp)
 6b0:	6442                	ld	s0,16(sp)
 6b2:	6902                	ld	s2,0(sp)
 6b4:	6105                	addi	sp,sp,32
 6b6:	8082                	ret
    return -1;
 6b8:	57fd                	li	a5,-1
 6ba:	893e                	mv	s2,a5
 6bc:	bfc5                	j	6ac <stat+0x2a>

00000000000006be <atoi>:

int
atoi(const char *s)
{
 6be:	1141                	addi	sp,sp,-16
 6c0:	e406                	sd	ra,8(sp)
 6c2:	e022                	sd	s0,0(sp)
 6c4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6c6:	00054683          	lbu	a3,0(a0)
 6ca:	fd06879b          	addiw	a5,a3,-48
 6ce:	0ff7f793          	zext.b	a5,a5
 6d2:	4625                	li	a2,9
 6d4:	02f66963          	bltu	a2,a5,706 <atoi+0x48>
 6d8:	872a                	mv	a4,a0
  n = 0;
 6da:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6dc:	0705                	addi	a4,a4,1
 6de:	0025179b          	slliw	a5,a0,0x2
 6e2:	9fa9                	addw	a5,a5,a0
 6e4:	0017979b          	slliw	a5,a5,0x1
 6e8:	9fb5                	addw	a5,a5,a3
 6ea:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6ee:	00074683          	lbu	a3,0(a4)
 6f2:	fd06879b          	addiw	a5,a3,-48
 6f6:	0ff7f793          	zext.b	a5,a5
 6fa:	fef671e3          	bgeu	a2,a5,6dc <atoi+0x1e>
  return n;
}
 6fe:	60a2                	ld	ra,8(sp)
 700:	6402                	ld	s0,0(sp)
 702:	0141                	addi	sp,sp,16
 704:	8082                	ret
  n = 0;
 706:	4501                	li	a0,0
 708:	bfdd                	j	6fe <atoi+0x40>

000000000000070a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 70a:	1141                	addi	sp,sp,-16
 70c:	e406                	sd	ra,8(sp)
 70e:	e022                	sd	s0,0(sp)
 710:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 712:	02b57563          	bgeu	a0,a1,73c <memmove+0x32>
    while(n-- > 0)
 716:	00c05f63          	blez	a2,734 <memmove+0x2a>
 71a:	1602                	slli	a2,a2,0x20
 71c:	9201                	srli	a2,a2,0x20
 71e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 722:	872a                	mv	a4,a0
      *dst++ = *src++;
 724:	0585                	addi	a1,a1,1
 726:	0705                	addi	a4,a4,1
 728:	fff5c683          	lbu	a3,-1(a1)
 72c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 730:	fee79ae3          	bne	a5,a4,724 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 734:	60a2                	ld	ra,8(sp)
 736:	6402                	ld	s0,0(sp)
 738:	0141                	addi	sp,sp,16
 73a:	8082                	ret
    while(n-- > 0)
 73c:	fec05ce3          	blez	a2,734 <memmove+0x2a>
    dst += n;
 740:	00c50733          	add	a4,a0,a2
    src += n;
 744:	95b2                	add	a1,a1,a2
 746:	fff6079b          	addiw	a5,a2,-1 # fff <malloc+0x2c9>
 74a:	1782                	slli	a5,a5,0x20
 74c:	9381                	srli	a5,a5,0x20
 74e:	fff7c793          	not	a5,a5
 752:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 754:	15fd                	addi	a1,a1,-1
 756:	177d                	addi	a4,a4,-1
 758:	0005c683          	lbu	a3,0(a1)
 75c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 760:	fef71ae3          	bne	a4,a5,754 <memmove+0x4a>
 764:	bfc1                	j	734 <memmove+0x2a>

0000000000000766 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 766:	1141                	addi	sp,sp,-16
 768:	e406                	sd	ra,8(sp)
 76a:	e022                	sd	s0,0(sp)
 76c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 76e:	c61d                	beqz	a2,79c <memcmp+0x36>
 770:	1602                	slli	a2,a2,0x20
 772:	9201                	srli	a2,a2,0x20
 774:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 778:	00054783          	lbu	a5,0(a0)
 77c:	0005c703          	lbu	a4,0(a1)
 780:	00e79863          	bne	a5,a4,790 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 784:	0505                	addi	a0,a0,1
    p2++;
 786:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 788:	fed518e3          	bne	a0,a3,778 <memcmp+0x12>
  }
  return 0;
 78c:	4501                	li	a0,0
 78e:	a019                	j	794 <memcmp+0x2e>
      return *p1 - *p2;
 790:	40e7853b          	subw	a0,a5,a4
}
 794:	60a2                	ld	ra,8(sp)
 796:	6402                	ld	s0,0(sp)
 798:	0141                	addi	sp,sp,16
 79a:	8082                	ret
  return 0;
 79c:	4501                	li	a0,0
 79e:	bfdd                	j	794 <memcmp+0x2e>

00000000000007a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 7a0:	1141                	addi	sp,sp,-16
 7a2:	e406                	sd	ra,8(sp)
 7a4:	e022                	sd	s0,0(sp)
 7a6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 7a8:	f63ff0ef          	jal	70a <memmove>
}
 7ac:	60a2                	ld	ra,8(sp)
 7ae:	6402                	ld	s0,0(sp)
 7b0:	0141                	addi	sp,sp,16
 7b2:	8082                	ret

00000000000007b4 <sbrk>:

char *
sbrk(int n) {
 7b4:	1141                	addi	sp,sp,-16
 7b6:	e406                	sd	ra,8(sp)
 7b8:	e022                	sd	s0,0(sp)
 7ba:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 7bc:	4585                	li	a1,1
 7be:	0b2000ef          	jal	870 <sys_sbrk>
}
 7c2:	60a2                	ld	ra,8(sp)
 7c4:	6402                	ld	s0,0(sp)
 7c6:	0141                	addi	sp,sp,16
 7c8:	8082                	ret

00000000000007ca <sbrklazy>:

char *
sbrklazy(int n) {
 7ca:	1141                	addi	sp,sp,-16
 7cc:	e406                	sd	ra,8(sp)
 7ce:	e022                	sd	s0,0(sp)
 7d0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 7d2:	4589                	li	a1,2
 7d4:	09c000ef          	jal	870 <sys_sbrk>
}
 7d8:	60a2                	ld	ra,8(sp)
 7da:	6402                	ld	s0,0(sp)
 7dc:	0141                	addi	sp,sp,16
 7de:	8082                	ret

00000000000007e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7e0:	4885                	li	a7,1
 ecall
 7e2:	00000073          	ecall
 ret
 7e6:	8082                	ret

00000000000007e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 7e8:	4889                	li	a7,2
 ecall
 7ea:	00000073          	ecall
 ret
 7ee:	8082                	ret

00000000000007f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 7f0:	488d                	li	a7,3
 ecall
 7f2:	00000073          	ecall
 ret
 7f6:	8082                	ret

00000000000007f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7f8:	4891                	li	a7,4
 ecall
 7fa:	00000073          	ecall
 ret
 7fe:	8082                	ret

0000000000000800 <read>:
.global read
read:
 li a7, SYS_read
 800:	4895                	li	a7,5
 ecall
 802:	00000073          	ecall
 ret
 806:	8082                	ret

0000000000000808 <write>:
.global write
write:
 li a7, SYS_write
 808:	48c1                	li	a7,16
 ecall
 80a:	00000073          	ecall
 ret
 80e:	8082                	ret

0000000000000810 <close>:
.global close
close:
 li a7, SYS_close
 810:	48d5                	li	a7,21
 ecall
 812:	00000073          	ecall
 ret
 816:	8082                	ret

0000000000000818 <kill>:
.global kill
kill:
 li a7, SYS_kill
 818:	4899                	li	a7,6
 ecall
 81a:	00000073          	ecall
 ret
 81e:	8082                	ret

0000000000000820 <exec>:
.global exec
exec:
 li a7, SYS_exec
 820:	489d                	li	a7,7
 ecall
 822:	00000073          	ecall
 ret
 826:	8082                	ret

0000000000000828 <open>:
.global open
open:
 li a7, SYS_open
 828:	48bd                	li	a7,15
 ecall
 82a:	00000073          	ecall
 ret
 82e:	8082                	ret

0000000000000830 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 830:	48c5                	li	a7,17
 ecall
 832:	00000073          	ecall
 ret
 836:	8082                	ret

0000000000000838 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 838:	48c9                	li	a7,18
 ecall
 83a:	00000073          	ecall
 ret
 83e:	8082                	ret

0000000000000840 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 840:	48a1                	li	a7,8
 ecall
 842:	00000073          	ecall
 ret
 846:	8082                	ret

0000000000000848 <link>:
.global link
link:
 li a7, SYS_link
 848:	48cd                	li	a7,19
 ecall
 84a:	00000073          	ecall
 ret
 84e:	8082                	ret

0000000000000850 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 850:	48d1                	li	a7,20
 ecall
 852:	00000073          	ecall
 ret
 856:	8082                	ret

0000000000000858 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 858:	48a5                	li	a7,9
 ecall
 85a:	00000073          	ecall
 ret
 85e:	8082                	ret

0000000000000860 <dup>:
.global dup
dup:
 li a7, SYS_dup
 860:	48a9                	li	a7,10
 ecall
 862:	00000073          	ecall
 ret
 866:	8082                	ret

0000000000000868 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 868:	48ad                	li	a7,11
 ecall
 86a:	00000073          	ecall
 ret
 86e:	8082                	ret

0000000000000870 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 870:	48b1                	li	a7,12
 ecall
 872:	00000073          	ecall
 ret
 876:	8082                	ret

0000000000000878 <pause>:
.global pause
pause:
 li a7, SYS_pause
 878:	48b5                	li	a7,13
 ecall
 87a:	00000073          	ecall
 ret
 87e:	8082                	ret

0000000000000880 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 880:	48b9                	li	a7,14
 ecall
 882:	00000073          	ecall
 ret
 886:	8082                	ret

0000000000000888 <hello>:
.global hello
hello:
 li a7, SYS_hello
 888:	48d9                	li	a7,22
 ecall
 88a:	00000073          	ecall
 ret
 88e:	8082                	ret

0000000000000890 <getpid2>:
.global getpid2
getpid2:
 li a7, SYS_getpid2
 890:	48dd                	li	a7,23
 ecall
 892:	00000073          	ecall
 ret
 896:	8082                	ret

0000000000000898 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 898:	48e1                	li	a7,24
 ecall
 89a:	00000073          	ecall
 ret
 89e:	8082                	ret

00000000000008a0 <getnumchild>:
.global getnumchild
getnumchild:
 li a7, SYS_getnumchild
 8a0:	48e5                	li	a7,25
 ecall
 8a2:	00000073          	ecall
 ret
 8a6:	8082                	ret

00000000000008a8 <getsyscount>:
.global getsyscount
getsyscount:
 li a7, SYS_getsyscount
 8a8:	48e9                	li	a7,26
 ecall
 8aa:	00000073          	ecall
 ret
 8ae:	8082                	ret

00000000000008b0 <getchildsyscount>:
.global getchildsyscount
getchildsyscount:
 li a7, SYS_getchildsyscount
 8b0:	48ed                	li	a7,27
 ecall
 8b2:	00000073          	ecall
 ret
 8b6:	8082                	ret

00000000000008b8 <getlevel>:
.global getlevel
getlevel:
 li a7, SYS_getlevel
 8b8:	48f1                	li	a7,28
 ecall
 8ba:	00000073          	ecall
 ret
 8be:	8082                	ret

00000000000008c0 <getmlfqinfo>:
.global getmlfqinfo
getmlfqinfo:
 li a7, SYS_getmlfqinfo
 8c0:	48f5                	li	a7,29
 ecall
 8c2:	00000073          	ecall
 ret
 8c6:	8082                	ret

00000000000008c8 <getvmstats>:
.global getvmstats
getvmstats:
 li a7, SYS_getvmstats
 8c8:	48f9                	li	a7,30
 ecall
 8ca:	00000073          	ecall
 ret
 8ce:	8082                	ret

00000000000008d0 <setdisksched>:
.global setdisksched
setdisksched:
 li a7, SYS_setdisksched
 8d0:	48fd                	li	a7,31
 ecall
 8d2:	00000073          	ecall
 ret
 8d6:	8082                	ret

00000000000008d8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 8d8:	1101                	addi	sp,sp,-32
 8da:	ec06                	sd	ra,24(sp)
 8dc:	e822                	sd	s0,16(sp)
 8de:	1000                	addi	s0,sp,32
 8e0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 8e4:	4605                	li	a2,1
 8e6:	fef40593          	addi	a1,s0,-17
 8ea:	f1fff0ef          	jal	808 <write>
}
 8ee:	60e2                	ld	ra,24(sp)
 8f0:	6442                	ld	s0,16(sp)
 8f2:	6105                	addi	sp,sp,32
 8f4:	8082                	ret

00000000000008f6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 8f6:	715d                	addi	sp,sp,-80
 8f8:	e486                	sd	ra,72(sp)
 8fa:	e0a2                	sd	s0,64(sp)
 8fc:	f84a                	sd	s2,48(sp)
 8fe:	f44e                	sd	s3,40(sp)
 900:	0880                	addi	s0,sp,80
 902:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 904:	c6d1                	beqz	a3,990 <printint+0x9a>
 906:	0805d563          	bgez	a1,990 <printint+0x9a>
    neg = 1;
    x = -xx;
 90a:	40b005b3          	neg	a1,a1
    neg = 1;
 90e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 910:	fb840993          	addi	s3,s0,-72
  neg = 0;
 914:	86ce                	mv	a3,s3
  i = 0;
 916:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 918:	00001817          	auipc	a6,0x1
 91c:	d8080813          	addi	a6,a6,-640 # 1698 <digits>
 920:	88ba                	mv	a7,a4
 922:	0017051b          	addiw	a0,a4,1
 926:	872a                	mv	a4,a0
 928:	02c5f7b3          	remu	a5,a1,a2
 92c:	97c2                	add	a5,a5,a6
 92e:	0007c783          	lbu	a5,0(a5)
 932:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 936:	87ae                	mv	a5,a1
 938:	02c5d5b3          	divu	a1,a1,a2
 93c:	0685                	addi	a3,a3,1
 93e:	fec7f1e3          	bgeu	a5,a2,920 <printint+0x2a>
  if(neg)
 942:	00030c63          	beqz	t1,95a <printint+0x64>
    buf[i++] = '-';
 946:	fd050793          	addi	a5,a0,-48
 94a:	00878533          	add	a0,a5,s0
 94e:	02d00793          	li	a5,45
 952:	fef50423          	sb	a5,-24(a0)
 956:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 95a:	02e05563          	blez	a4,984 <printint+0x8e>
 95e:	fc26                	sd	s1,56(sp)
 960:	377d                	addiw	a4,a4,-1
 962:	00e984b3          	add	s1,s3,a4
 966:	19fd                	addi	s3,s3,-1
 968:	99ba                	add	s3,s3,a4
 96a:	1702                	slli	a4,a4,0x20
 96c:	9301                	srli	a4,a4,0x20
 96e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 972:	0004c583          	lbu	a1,0(s1)
 976:	854a                	mv	a0,s2
 978:	f61ff0ef          	jal	8d8 <putc>
  while(--i >= 0)
 97c:	14fd                	addi	s1,s1,-1
 97e:	ff349ae3          	bne	s1,s3,972 <printint+0x7c>
 982:	74e2                	ld	s1,56(sp)
}
 984:	60a6                	ld	ra,72(sp)
 986:	6406                	ld	s0,64(sp)
 988:	7942                	ld	s2,48(sp)
 98a:	79a2                	ld	s3,40(sp)
 98c:	6161                	addi	sp,sp,80
 98e:	8082                	ret
  neg = 0;
 990:	4301                	li	t1,0
 992:	bfbd                	j	910 <printint+0x1a>

0000000000000994 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 994:	711d                	addi	sp,sp,-96
 996:	ec86                	sd	ra,88(sp)
 998:	e8a2                	sd	s0,80(sp)
 99a:	e4a6                	sd	s1,72(sp)
 99c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 99e:	0005c483          	lbu	s1,0(a1)
 9a2:	22048363          	beqz	s1,bc8 <vprintf+0x234>
 9a6:	e0ca                	sd	s2,64(sp)
 9a8:	fc4e                	sd	s3,56(sp)
 9aa:	f852                	sd	s4,48(sp)
 9ac:	f456                	sd	s5,40(sp)
 9ae:	f05a                	sd	s6,32(sp)
 9b0:	ec5e                	sd	s7,24(sp)
 9b2:	e862                	sd	s8,16(sp)
 9b4:	8b2a                	mv	s6,a0
 9b6:	8a2e                	mv	s4,a1
 9b8:	8bb2                	mv	s7,a2
  state = 0;
 9ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 9bc:	4901                	li	s2,0
 9be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 9c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 9c4:	06400c13          	li	s8,100
 9c8:	a00d                	j	9ea <vprintf+0x56>
        putc(fd, c0);
 9ca:	85a6                	mv	a1,s1
 9cc:	855a                	mv	a0,s6
 9ce:	f0bff0ef          	jal	8d8 <putc>
 9d2:	a019                	j	9d8 <vprintf+0x44>
    } else if(state == '%'){
 9d4:	03598363          	beq	s3,s5,9fa <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 9d8:	0019079b          	addiw	a5,s2,1
 9dc:	893e                	mv	s2,a5
 9de:	873e                	mv	a4,a5
 9e0:	97d2                	add	a5,a5,s4
 9e2:	0007c483          	lbu	s1,0(a5)
 9e6:	1c048a63          	beqz	s1,bba <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 9ea:	0004879b          	sext.w	a5,s1
    if(state == 0){
 9ee:	fe0993e3          	bnez	s3,9d4 <vprintf+0x40>
      if(c0 == '%'){
 9f2:	fd579ce3          	bne	a5,s5,9ca <vprintf+0x36>
        state = '%';
 9f6:	89be                	mv	s3,a5
 9f8:	b7c5                	j	9d8 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 9fa:	00ea06b3          	add	a3,s4,a4
 9fe:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 a02:	1c060863          	beqz	a2,bd2 <vprintf+0x23e>
      if(c0 == 'd'){
 a06:	03878763          	beq	a5,s8,a34 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 a0a:	f9478693          	addi	a3,a5,-108
 a0e:	0016b693          	seqz	a3,a3
 a12:	f9c60593          	addi	a1,a2,-100
 a16:	e99d                	bnez	a1,a4c <vprintf+0xb8>
 a18:	ca95                	beqz	a3,a4c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a1a:	008b8493          	addi	s1,s7,8
 a1e:	4685                	li	a3,1
 a20:	4629                	li	a2,10
 a22:	000bb583          	ld	a1,0(s7)
 a26:	855a                	mv	a0,s6
 a28:	ecfff0ef          	jal	8f6 <printint>
        i += 1;
 a2c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a2e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 a30:	4981                	li	s3,0
 a32:	b75d                	j	9d8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 a34:	008b8493          	addi	s1,s7,8
 a38:	4685                	li	a3,1
 a3a:	4629                	li	a2,10
 a3c:	000ba583          	lw	a1,0(s7)
 a40:	855a                	mv	a0,s6
 a42:	eb5ff0ef          	jal	8f6 <printint>
 a46:	8ba6                	mv	s7,s1
      state = 0;
 a48:	4981                	li	s3,0
 a4a:	b779                	j	9d8 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 a4c:	9752                	add	a4,a4,s4
 a4e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a52:	f9460713          	addi	a4,a2,-108
 a56:	00173713          	seqz	a4,a4
 a5a:	8f75                	and	a4,a4,a3
 a5c:	f9c58513          	addi	a0,a1,-100
 a60:	18051363          	bnez	a0,be6 <vprintf+0x252>
 a64:	18070163          	beqz	a4,be6 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a68:	008b8493          	addi	s1,s7,8
 a6c:	4685                	li	a3,1
 a6e:	4629                	li	a2,10
 a70:	000bb583          	ld	a1,0(s7)
 a74:	855a                	mv	a0,s6
 a76:	e81ff0ef          	jal	8f6 <printint>
        i += 2;
 a7a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a7c:	8ba6                	mv	s7,s1
      state = 0;
 a7e:	4981                	li	s3,0
        i += 2;
 a80:	bfa1                	j	9d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 a82:	008b8493          	addi	s1,s7,8
 a86:	4681                	li	a3,0
 a88:	4629                	li	a2,10
 a8a:	000be583          	lwu	a1,0(s7)
 a8e:	855a                	mv	a0,s6
 a90:	e67ff0ef          	jal	8f6 <printint>
 a94:	8ba6                	mv	s7,s1
      state = 0;
 a96:	4981                	li	s3,0
 a98:	b781                	j	9d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a9a:	008b8493          	addi	s1,s7,8
 a9e:	4681                	li	a3,0
 aa0:	4629                	li	a2,10
 aa2:	000bb583          	ld	a1,0(s7)
 aa6:	855a                	mv	a0,s6
 aa8:	e4fff0ef          	jal	8f6 <printint>
        i += 1;
 aac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 aae:	8ba6                	mv	s7,s1
      state = 0;
 ab0:	4981                	li	s3,0
 ab2:	b71d                	j	9d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 ab4:	008b8493          	addi	s1,s7,8
 ab8:	4681                	li	a3,0
 aba:	4629                	li	a2,10
 abc:	000bb583          	ld	a1,0(s7)
 ac0:	855a                	mv	a0,s6
 ac2:	e35ff0ef          	jal	8f6 <printint>
        i += 2;
 ac6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 ac8:	8ba6                	mv	s7,s1
      state = 0;
 aca:	4981                	li	s3,0
        i += 2;
 acc:	b731                	j	9d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 ace:	008b8493          	addi	s1,s7,8
 ad2:	4681                	li	a3,0
 ad4:	4641                	li	a2,16
 ad6:	000be583          	lwu	a1,0(s7)
 ada:	855a                	mv	a0,s6
 adc:	e1bff0ef          	jal	8f6 <printint>
 ae0:	8ba6                	mv	s7,s1
      state = 0;
 ae2:	4981                	li	s3,0
 ae4:	bdd5                	j	9d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 ae6:	008b8493          	addi	s1,s7,8
 aea:	4681                	li	a3,0
 aec:	4641                	li	a2,16
 aee:	000bb583          	ld	a1,0(s7)
 af2:	855a                	mv	a0,s6
 af4:	e03ff0ef          	jal	8f6 <printint>
        i += 1;
 af8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 afa:	8ba6                	mv	s7,s1
      state = 0;
 afc:	4981                	li	s3,0
 afe:	bde9                	j	9d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b00:	008b8493          	addi	s1,s7,8
 b04:	4681                	li	a3,0
 b06:	4641                	li	a2,16
 b08:	000bb583          	ld	a1,0(s7)
 b0c:	855a                	mv	a0,s6
 b0e:	de9ff0ef          	jal	8f6 <printint>
        i += 2;
 b12:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 b14:	8ba6                	mv	s7,s1
      state = 0;
 b16:	4981                	li	s3,0
        i += 2;
 b18:	b5c1                	j	9d8 <vprintf+0x44>
 b1a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 b1c:	008b8793          	addi	a5,s7,8
 b20:	8cbe                	mv	s9,a5
 b22:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b26:	03000593          	li	a1,48
 b2a:	855a                	mv	a0,s6
 b2c:	dadff0ef          	jal	8d8 <putc>
  putc(fd, 'x');
 b30:	07800593          	li	a1,120
 b34:	855a                	mv	a0,s6
 b36:	da3ff0ef          	jal	8d8 <putc>
 b3a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b3c:	00001b97          	auipc	s7,0x1
 b40:	b5cb8b93          	addi	s7,s7,-1188 # 1698 <digits>
 b44:	03c9d793          	srli	a5,s3,0x3c
 b48:	97de                	add	a5,a5,s7
 b4a:	0007c583          	lbu	a1,0(a5)
 b4e:	855a                	mv	a0,s6
 b50:	d89ff0ef          	jal	8d8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b54:	0992                	slli	s3,s3,0x4
 b56:	34fd                	addiw	s1,s1,-1
 b58:	f4f5                	bnez	s1,b44 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 b5a:	8be6                	mv	s7,s9
      state = 0;
 b5c:	4981                	li	s3,0
 b5e:	6ca2                	ld	s9,8(sp)
 b60:	bda5                	j	9d8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 b62:	008b8493          	addi	s1,s7,8
 b66:	000bc583          	lbu	a1,0(s7)
 b6a:	855a                	mv	a0,s6
 b6c:	d6dff0ef          	jal	8d8 <putc>
 b70:	8ba6                	mv	s7,s1
      state = 0;
 b72:	4981                	li	s3,0
 b74:	b595                	j	9d8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 b76:	008b8993          	addi	s3,s7,8
 b7a:	000bb483          	ld	s1,0(s7)
 b7e:	cc91                	beqz	s1,b9a <vprintf+0x206>
        for(; *s; s++)
 b80:	0004c583          	lbu	a1,0(s1)
 b84:	c985                	beqz	a1,bb4 <vprintf+0x220>
          putc(fd, *s);
 b86:	855a                	mv	a0,s6
 b88:	d51ff0ef          	jal	8d8 <putc>
        for(; *s; s++)
 b8c:	0485                	addi	s1,s1,1
 b8e:	0004c583          	lbu	a1,0(s1)
 b92:	f9f5                	bnez	a1,b86 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 b94:	8bce                	mv	s7,s3
      state = 0;
 b96:	4981                	li	s3,0
 b98:	b581                	j	9d8 <vprintf+0x44>
          s = "(null)";
 b9a:	00001497          	auipc	s1,0x1
 b9e:	af648493          	addi	s1,s1,-1290 # 1690 <malloc+0x95a>
        for(; *s; s++)
 ba2:	02800593          	li	a1,40
 ba6:	b7c5                	j	b86 <vprintf+0x1f2>
        putc(fd, '%');
 ba8:	85be                	mv	a1,a5
 baa:	855a                	mv	a0,s6
 bac:	d2dff0ef          	jal	8d8 <putc>
      state = 0;
 bb0:	4981                	li	s3,0
 bb2:	b51d                	j	9d8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 bb4:	8bce                	mv	s7,s3
      state = 0;
 bb6:	4981                	li	s3,0
 bb8:	b505                	j	9d8 <vprintf+0x44>
 bba:	6906                	ld	s2,64(sp)
 bbc:	79e2                	ld	s3,56(sp)
 bbe:	7a42                	ld	s4,48(sp)
 bc0:	7aa2                	ld	s5,40(sp)
 bc2:	7b02                	ld	s6,32(sp)
 bc4:	6be2                	ld	s7,24(sp)
 bc6:	6c42                	ld	s8,16(sp)
    }
  }
}
 bc8:	60e6                	ld	ra,88(sp)
 bca:	6446                	ld	s0,80(sp)
 bcc:	64a6                	ld	s1,72(sp)
 bce:	6125                	addi	sp,sp,96
 bd0:	8082                	ret
      if(c0 == 'd'){
 bd2:	06400713          	li	a4,100
 bd6:	e4e78fe3          	beq	a5,a4,a34 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 bda:	f9478693          	addi	a3,a5,-108
 bde:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 be2:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 be4:	4701                	li	a4,0
      } else if(c0 == 'u'){
 be6:	07500513          	li	a0,117
 bea:	e8a78ce3          	beq	a5,a0,a82 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 bee:	f8b60513          	addi	a0,a2,-117
 bf2:	e119                	bnez	a0,bf8 <vprintf+0x264>
 bf4:	ea0693e3          	bnez	a3,a9a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 bf8:	f8b58513          	addi	a0,a1,-117
 bfc:	e119                	bnez	a0,c02 <vprintf+0x26e>
 bfe:	ea071be3          	bnez	a4,ab4 <vprintf+0x120>
      } else if(c0 == 'x'){
 c02:	07800513          	li	a0,120
 c06:	eca784e3          	beq	a5,a0,ace <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 c0a:	f8860613          	addi	a2,a2,-120
 c0e:	e219                	bnez	a2,c14 <vprintf+0x280>
 c10:	ec069be3          	bnez	a3,ae6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 c14:	f8858593          	addi	a1,a1,-120
 c18:	e199                	bnez	a1,c1e <vprintf+0x28a>
 c1a:	ee0713e3          	bnez	a4,b00 <vprintf+0x16c>
      } else if(c0 == 'p'){
 c1e:	07000713          	li	a4,112
 c22:	eee78ce3          	beq	a5,a4,b1a <vprintf+0x186>
      } else if(c0 == 'c'){
 c26:	06300713          	li	a4,99
 c2a:	f2e78ce3          	beq	a5,a4,b62 <vprintf+0x1ce>
      } else if(c0 == 's'){
 c2e:	07300713          	li	a4,115
 c32:	f4e782e3          	beq	a5,a4,b76 <vprintf+0x1e2>
      } else if(c0 == '%'){
 c36:	02500713          	li	a4,37
 c3a:	f6e787e3          	beq	a5,a4,ba8 <vprintf+0x214>
        putc(fd, '%');
 c3e:	02500593          	li	a1,37
 c42:	855a                	mv	a0,s6
 c44:	c95ff0ef          	jal	8d8 <putc>
        putc(fd, c0);
 c48:	85a6                	mv	a1,s1
 c4a:	855a                	mv	a0,s6
 c4c:	c8dff0ef          	jal	8d8 <putc>
      state = 0;
 c50:	4981                	li	s3,0
 c52:	b359                	j	9d8 <vprintf+0x44>

0000000000000c54 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c54:	715d                	addi	sp,sp,-80
 c56:	ec06                	sd	ra,24(sp)
 c58:	e822                	sd	s0,16(sp)
 c5a:	1000                	addi	s0,sp,32
 c5c:	e010                	sd	a2,0(s0)
 c5e:	e414                	sd	a3,8(s0)
 c60:	e818                	sd	a4,16(s0)
 c62:	ec1c                	sd	a5,24(s0)
 c64:	03043023          	sd	a6,32(s0)
 c68:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c6c:	8622                	mv	a2,s0
 c6e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c72:	d23ff0ef          	jal	994 <vprintf>
}
 c76:	60e2                	ld	ra,24(sp)
 c78:	6442                	ld	s0,16(sp)
 c7a:	6161                	addi	sp,sp,80
 c7c:	8082                	ret

0000000000000c7e <printf>:

void
printf(const char *fmt, ...)
{
 c7e:	711d                	addi	sp,sp,-96
 c80:	ec06                	sd	ra,24(sp)
 c82:	e822                	sd	s0,16(sp)
 c84:	1000                	addi	s0,sp,32
 c86:	e40c                	sd	a1,8(s0)
 c88:	e810                	sd	a2,16(s0)
 c8a:	ec14                	sd	a3,24(s0)
 c8c:	f018                	sd	a4,32(s0)
 c8e:	f41c                	sd	a5,40(s0)
 c90:	03043823          	sd	a6,48(s0)
 c94:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c98:	00840613          	addi	a2,s0,8
 c9c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ca0:	85aa                	mv	a1,a0
 ca2:	4505                	li	a0,1
 ca4:	cf1ff0ef          	jal	994 <vprintf>
}
 ca8:	60e2                	ld	ra,24(sp)
 caa:	6442                	ld	s0,16(sp)
 cac:	6125                	addi	sp,sp,96
 cae:	8082                	ret

0000000000000cb0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cb0:	1141                	addi	sp,sp,-16
 cb2:	e406                	sd	ra,8(sp)
 cb4:	e022                	sd	s0,0(sp)
 cb6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cb8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cbc:	00001797          	auipc	a5,0x1
 cc0:	3447b783          	ld	a5,836(a5) # 2000 <freep>
 cc4:	a039                	j	cd2 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cc6:	6398                	ld	a4,0(a5)
 cc8:	00e7e463          	bltu	a5,a4,cd0 <free+0x20>
 ccc:	00e6ea63          	bltu	a3,a4,ce0 <free+0x30>
{
 cd0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cd2:	fed7fae3          	bgeu	a5,a3,cc6 <free+0x16>
 cd6:	6398                	ld	a4,0(a5)
 cd8:	00e6e463          	bltu	a3,a4,ce0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cdc:	fee7eae3          	bltu	a5,a4,cd0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ce0:	ff852583          	lw	a1,-8(a0)
 ce4:	6390                	ld	a2,0(a5)
 ce6:	02059813          	slli	a6,a1,0x20
 cea:	01c85713          	srli	a4,a6,0x1c
 cee:	9736                	add	a4,a4,a3
 cf0:	02e60563          	beq	a2,a4,d1a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 cf4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 cf8:	4790                	lw	a2,8(a5)
 cfa:	02061593          	slli	a1,a2,0x20
 cfe:	01c5d713          	srli	a4,a1,0x1c
 d02:	973e                	add	a4,a4,a5
 d04:	02e68263          	beq	a3,a4,d28 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 d08:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d0a:	00001717          	auipc	a4,0x1
 d0e:	2ef73b23          	sd	a5,758(a4) # 2000 <freep>
}
 d12:	60a2                	ld	ra,8(sp)
 d14:	6402                	ld	s0,0(sp)
 d16:	0141                	addi	sp,sp,16
 d18:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 d1a:	4618                	lw	a4,8(a2)
 d1c:	9f2d                	addw	a4,a4,a1
 d1e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 d22:	6398                	ld	a4,0(a5)
 d24:	6310                	ld	a2,0(a4)
 d26:	b7f9                	j	cf4 <free+0x44>
    p->s.size += bp->s.size;
 d28:	ff852703          	lw	a4,-8(a0)
 d2c:	9f31                	addw	a4,a4,a2
 d2e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d30:	ff053683          	ld	a3,-16(a0)
 d34:	bfd1                	j	d08 <free+0x58>

0000000000000d36 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d36:	7139                	addi	sp,sp,-64
 d38:	fc06                	sd	ra,56(sp)
 d3a:	f822                	sd	s0,48(sp)
 d3c:	f04a                	sd	s2,32(sp)
 d3e:	ec4e                	sd	s3,24(sp)
 d40:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d42:	02051993          	slli	s3,a0,0x20
 d46:	0209d993          	srli	s3,s3,0x20
 d4a:	09bd                	addi	s3,s3,15
 d4c:	0049d993          	srli	s3,s3,0x4
 d50:	2985                	addiw	s3,s3,1
 d52:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 d54:	00001517          	auipc	a0,0x1
 d58:	2ac53503          	ld	a0,684(a0) # 2000 <freep>
 d5c:	c905                	beqz	a0,d8c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d5e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d60:	4798                	lw	a4,8(a5)
 d62:	09377663          	bgeu	a4,s3,dee <malloc+0xb8>
 d66:	f426                	sd	s1,40(sp)
 d68:	e852                	sd	s4,16(sp)
 d6a:	e456                	sd	s5,8(sp)
 d6c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 d6e:	8a4e                	mv	s4,s3
 d70:	6705                	lui	a4,0x1
 d72:	00e9f363          	bgeu	s3,a4,d78 <malloc+0x42>
 d76:	6a05                	lui	s4,0x1
 d78:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d7c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d80:	00001497          	auipc	s1,0x1
 d84:	28048493          	addi	s1,s1,640 # 2000 <freep>
  if(p == SBRK_ERROR)
 d88:	5afd                	li	s5,-1
 d8a:	a83d                	j	dc8 <malloc+0x92>
 d8c:	f426                	sd	s1,40(sp)
 d8e:	e852                	sd	s4,16(sp)
 d90:	e456                	sd	s5,8(sp)
 d92:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 d94:	00001797          	auipc	a5,0x1
 d98:	27c78793          	addi	a5,a5,636 # 2010 <base>
 d9c:	00001717          	auipc	a4,0x1
 da0:	26f73223          	sd	a5,612(a4) # 2000 <freep>
 da4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 da6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 daa:	b7d1                	j	d6e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 dac:	6398                	ld	a4,0(a5)
 dae:	e118                	sd	a4,0(a0)
 db0:	a899                	j	e06 <malloc+0xd0>
  hp->s.size = nu;
 db2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 db6:	0541                	addi	a0,a0,16
 db8:	ef9ff0ef          	jal	cb0 <free>
  return freep;
 dbc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 dbe:	c125                	beqz	a0,e1e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dc0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 dc2:	4798                	lw	a4,8(a5)
 dc4:	03277163          	bgeu	a4,s2,de6 <malloc+0xb0>
    if(p == freep)
 dc8:	6098                	ld	a4,0(s1)
 dca:	853e                	mv	a0,a5
 dcc:	fef71ae3          	bne	a4,a5,dc0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 dd0:	8552                	mv	a0,s4
 dd2:	9e3ff0ef          	jal	7b4 <sbrk>
  if(p == SBRK_ERROR)
 dd6:	fd551ee3          	bne	a0,s5,db2 <malloc+0x7c>
        return 0;
 dda:	4501                	li	a0,0
 ddc:	74a2                	ld	s1,40(sp)
 dde:	6a42                	ld	s4,16(sp)
 de0:	6aa2                	ld	s5,8(sp)
 de2:	6b02                	ld	s6,0(sp)
 de4:	a03d                	j	e12 <malloc+0xdc>
 de6:	74a2                	ld	s1,40(sp)
 de8:	6a42                	ld	s4,16(sp)
 dea:	6aa2                	ld	s5,8(sp)
 dec:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 dee:	fae90fe3          	beq	s2,a4,dac <malloc+0x76>
        p->s.size -= nunits;
 df2:	4137073b          	subw	a4,a4,s3
 df6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 df8:	02071693          	slli	a3,a4,0x20
 dfc:	01c6d713          	srli	a4,a3,0x1c
 e00:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e02:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e06:	00001717          	auipc	a4,0x1
 e0a:	1ea73d23          	sd	a0,506(a4) # 2000 <freep>
      return (void*)(p + 1);
 e0e:	01078513          	addi	a0,a5,16
  }
}
 e12:	70e2                	ld	ra,56(sp)
 e14:	7442                	ld	s0,48(sp)
 e16:	7902                	ld	s2,32(sp)
 e18:	69e2                	ld	s3,24(sp)
 e1a:	6121                	addi	sp,sp,64
 e1c:	8082                	ret
 e1e:	74a2                	ld	s1,40(sp)
 e20:	6a42                	ld	s4,16(sp)
 e22:	6aa2                	ld	s5,8(sp)
 e24:	6b02                	ld	s6,0(sp)
 e26:	b7f5                	j	e12 <malloc+0xdc>
