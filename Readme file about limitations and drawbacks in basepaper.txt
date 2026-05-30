what are the drawbacks 

From your uploaded paper “A Compact Hardware Design and Implementation on FPGA Based Hybrid of AES and Keccak SHA3-512”, the proposed AES + SHA3-512 hybrid cryptosystem has several strengths — but also some drawbacks / limitations you should mention when explaining it to your project guide or in review discussion.

Here are the main drawbacks clearly explained:

🔴 Drawbacks of the Proposed AES/SHA3-512 Hybrid Design
1️⃣ High Power Consumption

The paper reports very high power usage on FPGA:

Total on-chip power ≈ 6883 W

Dynamic power dominates usage

That is extremely large compared to many crypto cores and makes it:

❌ Not suitable for low-power devices

❌ Not ideal for battery/IoT systems

❌ Expensive for continuous operation

Source: Power analysis table (Artix-7 results)


493fc671-3c2b-45a5-9372-4140a13…

2️⃣ Increased Design Complexity

Combining two heavy cryptographic cores:

AES encryption/decryption

SHA3-512 hashing

Integrated LUT + Six Input Equation logic

Resource sharing networks

Leads to:

❌ Complex RTL design

❌ Harder debugging & verification

❌ Longer development time

❌ More difficult timing closure

3️⃣ Larger Latency Than Single Algorithm

Hybrid operation means:

AES rounds + SHA3 rounds both involved

Extra XOR networks and padding logic

Resource sharing adds scheduling overhead

Result:

❌ Higher latency than pure AES core

❌ Not ideal for ultra-low-latency crypto pipelines

4️⃣ FPGA-Specific Optimization

The architecture is optimized for:

Artix-7 FPGA

BRAM LUT mapping

Vivado 2017.2 tool flow

So:

❌ Portability to ASIC not guaranteed

❌ May not map efficiently to other FPGA families

❌ Vendor-dependent optimizations

5️⃣ Limited Real-World Benchmarking

The paper shows:

Resource utilization

Power numbers

Area comparison

But missing:

❌ Throughput comparison (Gbps/Mbps)

❌ Latency benchmarks

❌ Attack resistance evaluation

❌ Side-channel resistance testing

So security claims are mostly architectural, not experimentally stress-tested.

6️⃣ No Side-Channel Attack Protection Mentioned

Modern crypto hardware must consider:

Power analysis attacks

Timing attacks

Fault injection attacks

Paper does not describe:

Masking

Hiding techniques

Fault detection

So:

❌ May be vulnerable in hostile hardware environments

7️⃣ Tool Version Is Old

Implementation uses:

Vivado 2017.2

That is quite old now.

❌ Not using latest synthesis optimizations

❌ Newer FPGA toolchains may give better results

✅ Good Review Line You Can Use in Your Report

You can write this directly:

Although the proposed AES/SHA3-512 hybrid architecture achieves good area efficiency, it suffers from high power consumption, increased architectural complexity, and lack of side-channel protection mechanisms, which may limit its suitability for low-power and security-critical embedded applications.


.......................................................................



How Your Proposed Title Overcomes the Limitations
🔴 Limitation 1 — High Power Consumption

Problem in paper: Very high dynamic power usage.

✅ Your Improvement — High-Throughput Optimized Architecture

You can overcome this by:

Using pipelined AES rounds

Using round unrolling with clock gating

Sharing SHA3 permutation blocks efficiently

Using low-toggle datapath design

Applying clock gating + enable control

What you claim:

Your design improves throughput-per-watt instead of only reducing LUT count.

✅ Result:

Lower switching activity

Better energy efficiency

Suitable for embedded crypto accelerators

🔴 Limitation 2 — Design Complexity

Problem: Hybrid LUT + SixIE + shared XOR networks = complex control.

✅ Your Improvement — Modular Crypto Processor Architecture

Your title says Processor with Configurable Modes — this implies:

Separate AES core module

Separate SHA3 core module

Configurable controller FSM

Mode-based datapath selection

You can say:

Instead of tightly merged logic, we use modular configurable crypto cores with shared interface bus.

✅ Result:

Easier verification

Easier debugging

Reusable IP blocks

Clean RTL hierarchy

🔴 Limitation 3 — Higher Latency

Problem: Hybrid flow increases processing delay.

✅ Your Improvement — High-Throughput Pipeline + Parallelism

“High-Throughput” in your title must be supported by:

AES round pipelining

SHA3 permutation pipelining

Parallel block processing

Multi-block buffering

Streaming input interface

You can claim:

AES and SHA3 operations are overlapped using pipeline stages.

✅ Result:

Higher Mbps/Gbps throughput

Lower effective latency per block

Suitable for secure data channels

🔴 Limitation 4 — FPGA-Specific Rigid Design

Problem: Only optimized for one FPGA & tool version.

✅ Your Improvement — Parameterized FPGA Design

You add:

Parameterized key size

Parameterized hash width

Generic Verilog (no vendor primitives)

BRAM/LUT selectable tables

You can say:

The design is written using parameterized RTL to support multiple FPGA families.

✅ Result:

Portable

Tool-independent

Reusable crypto IP

🔴 Limitation 5 — No Performance Metrics

Problem: Paper lacks throughput benchmarking.

✅ Your Improvement — Throughput-Driven Processor Design

Your title explicitly says:

High-Throughput Processor

So you must include:

Mbps/Gbps measurement

Cycles per block

Throughput formula

Latency cycles

Efficiency = Mbps/LUT

✅ Result:

Quantified performance

Reviewer-friendly metrics

Publishable results

🔴 Limitation 6 — No Side-Channel Protection

Problem: No mention of hardware attack resistance.

✅ Your Improvement — “Secure Processor” Enhancement

You can add:

Masked S-Box

Random round key masking

Dummy cycle insertion

Fault detection parity

Redundant round checking

You can claim:

Lightweight side-channel mitigation is added at S-Box and permutation stages.

✅ Result:

Better hardware security

Stronger than base design

Industry-aligned crypto core

🔴 Limitation 7 — Fixed Modes Only

Problem: Paper uses fixed AES-256 + SHA3-512.

✅ Your Improvement — Configurable Key & Hash Modes ⭐ (Big Advantage)

Your title’s strongest upgrade:

Configurable Key Modes

AES-128

AES-192

AES-256

Configurable Hash Modes

SHA3-224

SHA3-256

SHA3-384

SHA3-512

Controlled by:

Mode register

Control FSM

Parameter block

✅ Result:

Flexible crypto processor

Multi-application support

Real product feature

✅ One Strong Review Answer You Can Say

Use this in viva/review:

The base hybrid AES/SHA3 design mainly focused on area reduction but had drawbacks such as high power consumption, fixed configuration, higher latency, and lack of throughput optimization.
My proposed High-Throughput Secure AES/SHA3-512 Hybrid Crypto Processor overcomes these by introducing pipelined architecture, modular configurable cores, parameterized key and hash modes, side-channel aware design, and throughput-optimized datapath, making it more practical for real FPGA security accelerators.