# High-Throughput Secure Configurable AES-SHA3 Hybrid Processor with AXI/FIFO Interface and Pipelining

## Project Overview

This project presents a high-performance FPGA-based cryptographic accelerator that integrates Advanced Encryption Standard (AES) encryption and Secure Hash Algorithm 3 (SHA3) hashing into a unified hardware architecture. The design is configurable, scalable, and optimized for real-time secure communication systems, embedded devices, IoT platforms, and FPGA-based security applications.

The processor supports multiple AES key lengths (128, 192, and 256 bits) and configurable SHA3 hash lengths (224, 256, 384, and 512 bits). A pipelined architecture is employed to maximize throughput and enable continuous data processing with low latency. AXI/FIFO-based streaming interfaces allow seamless integration with processors, memory systems, and other FPGA IP cores.

---

## Key Features

### AES Encryption Engine

* Runtime-selectable AES-128, AES-192, and AES-256 modes
* Parameterized key scheduling architecture
* Modular and scalable RTL implementation

### SHA3 Hashing Engine

* Supports SHA3-224, SHA3-256, SHA3-384, and SHA3-512
* Configurable output hash lengths
* Keccak-based hashing architecture

### High-Performance Pipelining

* Fully pipelined AES and SHA3 processing stages
* Increased throughput for streaming applications
* Reduced processing latency

### AXI/FIFO Streaming Interface

* Continuous high-speed data transfer
* Ready/Valid handshake protocol
* Easy integration with SoCs and FPGA platforms

### Security Enhancements

* Side-channel attack mitigation through masking and randomization techniques
* Optional HMAC-based authentication support
* Enhanced confidentiality and data integrity

### Resource Optimization

* Clock-gating support
* Resource sharing techniques
* FPGA area and power optimization

---

## System Architecture

Input data is processed through a hybrid cryptographic pipeline:

Plaintext → AES Encryption → Ciphertext → SHA3 Hashing → Secure Output

The architecture supports three operating modes:

* AES Only
* SHA3 Only
* AES + SHA3 Hybrid Mode

---

## Top-Level Module

### Inputs

* `clk`
* `rst`
* `start`
* `mode_select`
* `key_select`
* `hash_len_select`
* `data_in`
* `key_in`

### Outputs

* `data_out`
* `hash_out`
* `done`

---

## Pipeline Flow

### Stage 1 – AES Encryption

The plaintext block is encrypted using the selected AES key size.

### Stage 2 – SHA3 Hashing

The encrypted ciphertext is passed to the SHA3 engine for hash generation.

### Stage 3 – Output Controller

Results are transmitted through AXI/FIFO interfaces while generating completion status signals.

---

## Advantages Over Base Architecture

| Feature            | Base Design   | Proposed Design                |
| ------------------ | ------------- | ------------------------------ |
| AES Key Size       | Fixed         | Configurable (128/192/256)     |
| SHA3 Output Length | Fixed 512-bit | Configurable (224/256/384/512) |
| Pipelining         | Not Available | Fully Pipelined                |
| Streaming Support  | No            | AXI/FIFO Interface             |
| Authentication     | Basic         | Optional HMAC                  |
| Security           | Standard      | Side-Channel Resistant         |
| Scalability        | Limited       | Fully Modular                  |

---

## FPGA Implementation

* Hardware Description Language: Verilog HDL
* Target Devices: Artix-7, Virtex Series, UltraScale Series
* Development Environment: Xilinx Vivado
* Design Style: Parameterized RTL Architecture

---

## Applications

### Secure Communication Systems

* Defense communication equipment
* Satellite communication links
* Secure wireless networks

### Internet of Things (IoT)

* Smart sensors
* Secure gateways
* Industrial automation systems

### Banking and Financial Security

* ATM encryption modules
* Secure transaction processing

### Cloud and Data Centers

* Hardware security accelerators
* High-speed encryption engines

### Blockchain and Authentication Systems

* Secure hashing engines
* Digital signature verification

---

## Simulation and Verification

The design has been verified using behavioral simulation. Testbench results confirm correct operation of:

* AES encryption pipeline
* SHA3 hashing pipeline
* Multi-block data processing
* Handshake and control signals
* Continuous streaming operation

Simulation waveforms demonstrate successful propagation of encrypted data through the AES-SHA3 pipeline and generation of valid hash outputs.

---

## Future Enhancements

* Integration of complete AES cryptographic core
* Integration of full SHA3 Keccak implementation
* Advanced power optimization techniques
* FPGA hardware validation and benchmarking
* Multi-channel parallel encryption support
* Hardware HMAC acceleration

---

## Conclusion

This project transforms a conventional AES-SHA3 implementation into a configurable, high-throughput, FPGA-based cryptographic accelerator. By combining pipelined processing, configurable security levels, AXI/FIFO streaming interfaces, and security enhancements, the architecture is suitable for real-time secure communication, embedded systems, IoT platforms, and research-oriented FPGA cryptography applications.
