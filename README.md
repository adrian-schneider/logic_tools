# logic_tools
tools and applications to manipulate logic expressions, such as term simplification, e.g. using the Quine McCluskey method

## qm_orig.c
Basically the original code, somewhat reformatted, as copied from the pdf-file of the article:

>Jiangbo Huang,
Department of Biological Sciences, Faculty of Science,<br>
National University of Singapore, Singapore 117604,<br>
"Programing implementation of the Quine-McCluskey method<br>
for minimization of Boolean expression".<br>
Source: [https://arxiv.org/pdf/1410.1059](https://arxiv.org/pdf/1410.1059)

## qm.c
The above program with my changes and bug fixes.
* Added the option to read the parameters from a file. The parameters are the same and in the same order as in interactive mode.
    * Number of variables
    * Number of minterms, including don't cares (n)
    * Number of don't cares (m)
    * n indexes of minterms
    * m indexes of don't cares (if any)
* Added a simple garbage collector to free up memory.
* Added Verilog compatible output format to be used in non-interactive mode. <br>Interactive mode outputs in the easier to read default format.

## makefile
The make file for qm.<br>
`make` Compile qm<br>
`make test` Perform a small test, executing qm with xor.txt as input:<br>
>`./qm xor.txt`<br>
`(~A & B) | (A & ~B)`<br>

## seg7.pl
Take a ASCII-graphical description of seven segment display characters as input and produce a set of logical expressions (simplified by qm), defining each segment, as output.<br>
This version is fixed to four input bits, allowing to define 16 characters.

## seg7rule.txt
A example input file to seg7.pl, defining seven segment representation of numbers 0-9, A-F.

