# 🔄 UART Protocol – RTL Design & Testbench

This project implements a **UART Transmitter Module** using Verilog HDL with a corresponding **SystemVerilog testbench** to simulate serial transmission. It demonstrates start/stop bit handling, LSB-first data shifting, and waveform-based verification – essential for hardware-level communication systems.

---

## 📦 Features

- ✅ UART transmission with:
  - 1 Start Bit (`0`)
  - 8 Data Bits (LSB First)
  - 1 Stop Bit (`1`)
- ✅ Parameterized `CLK_PER_BIT` for baud rate control
- ✅ SystemVerilog Testbench with:
  - Functional simulation
  - Cycle-accurate waveform inspection
  - Status-based flow control using `busy` signal

---

## 🧠 Functional Overview

UART (Universal Asynchronous Receiver/Transmitter) is a serial protocol for transmitting data **bit-by-bit** asynchronously. This project simulates a UART transmitter with the following sequence:

```text
| Start |  Data (LSB First)  | Stop |
|   0   | D0 D1 D2 D3 D4 D5 D6 D7 | 1 |
