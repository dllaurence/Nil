# Makefile for nil

%.s : %.bc
	llc -f $<

%.dis.ll : %.bc
	llvm-dis -f $< -o $@

%.bc : %.ll
	llvm-as $<

%.ll : %.llm
	cpp -nostdinc -P -x assembler-with-cpp -I. $< $@

all : nil

nil : nil.o system_c.o system_ll.o lex.o

nil.ll : system.llh c_defs.llh nil.llh lex.llh

lex.ll : system.llh c_defs.llh nil.llh lex.llh

system_ll.ll : system.llh c_defs.llh

c_defs.llh : c_defs
	./c_defs > c_defs.llh

clean :
	rm -f nil c_defs c_defs.llh *.bc *.ll *.s *.o

