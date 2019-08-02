qm: qm.c
	cc -oqm -lm qm.c

test:
	./qm xor.txt
