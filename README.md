# 16-bit TSC Microcomputer Single Cycle CPU

A Verilog implementation of a 16-bit single-cycle CPU for the TSC microcomputer architecture.

## 📌 Architecture Overview
* **Architecture:** TSC Microcomputer
* **Word Size:** 16-bit data and instruction words
* **Registers:** 4 general-purpose 16-bit registers (`$0` to `$3`)

## ⚙️ Supported Instructions
* **R-Type:** `ADD`, `WWD`
* **I-Type:** `LHI`, `ADI`
* **J-Type:** `JMP`

## 📂 File Structure
* `cpu.v` : Top module for the TSC CPU.
* `datapath.v` : Datapath connecting RF and ALU.
* `control_unit.v` : Control unit for instruction decoding.
* `ALU.v` / `RF.v` : Arithmetic Logic Unit and Register File.
* `cpu_tb.v` : Testbench for verifying CPU operations and WWD outputs.
