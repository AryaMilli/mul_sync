# mul_sync
4-Bit Synchronous Multiplier with SystemVerilog Testbench

This project implements a 4-bit synchronous multiplier in Verilog and verifies it using a single-file SystemVerilog testbench. The testbench consolidates all verification constructs into one file for simplicity while demonstrating skills in both RTL design and functional verification.

All verification components are implemented within a single SystemVerilog testbench file:
1. Transaction Class: Defines the structure of test data.
2. Generator: Creates stimulus for the DUT.
3. Driver: Applies input transactions to the DUT.
4. Monitor: Observes DUT behavior and records output transactions.
5. Scoreboard: Compares DUT outputs against expected results for correctness.


# Test cases include:
Corner cases and edge scenarios.
Randomized and directed inputs for comprehensive coverage.

# Simulation Results 

![image](https://github.com/user-attachments/assets/73ceb125-ccbe-4e4a-a403-9606e1ad1ad7)
