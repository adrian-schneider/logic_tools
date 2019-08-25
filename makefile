qm: qm.c
	CC -oqm -lm qm.cpp

test:
	./qm xor.txt
