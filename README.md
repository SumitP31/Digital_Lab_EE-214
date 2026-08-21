# Digital Circuits LAB (EE-214): TA Solutions for VHDL code

## Week 1: Gates using only NAND gates
1. AND Gate
2. OR Gate
3. XOR Gate
4. Half Adder
5. Full Adder

## Week 2: 
1. 4-to-2 Encoder with Enable
2. 4-to-2 Priority Encoder
3. 8-to-3 Encoder using 4-to-2 Encoder with Enable

## Week 3: URJtag
1. Fibonacci Sequence Detector.
2. Interfacing input and output pins with the FPGA board
3. Uploading Code to MAX 10 board
  > Go to ``` PATH:\XEN10_FILES\UrJTAG ``` and open ``` jtag.exe```
  > Run this in the opened terminal 
```cli
cable ft2232
detect
svf PATH_TO_svf/filename.svf progress  
```
## Week 4: Universal Rotator and Scanchain.
1. Universal Rotator for 8-bit input
2. Board implementation using scanchain. Scan chain provides virtual input outputs to the board.
> Copy all contents of ```Scan_Chain_Files``` into your project folder
> Set Top_level.vhdl as Top level entity
> dump .svf file on MAX10 board
> Run this command in terminal when inside your project folder
```cli
python -m vevn .venv
.venv/Script/activate.bat
pip install bitarray bitstring ftd2xx
```
> After Installation Run 
```cli
scan_vjtag.exe TRACEFILE.txt out.txt
```
3. Open the out.txt file to check results

## VLSI Design code
``` cli
extract all
ext2spice lvs
ext2spice -d -o invx1_layout.spice
```
second part
```cli
extract all
ext2spice scale off
ext2spice cthresh 0
ext2spice rthresh 0
ext2spice -d -o invx1_pex.spice
```
