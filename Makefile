#**********************************************************************
# Nil Makefile
#
# Copyright 2009-2010 by Dustin Laurence.  Distributed under the terms of
# the LGPLv3.
#
#**********************************************************************

LPPFLAGS = # -D NDEBUG
LLOPTFLAGS = -O3
LLCFLAGS = -O3

# FIXME: This means we're using the system linker and not getting
# link-time optimization.  Not fixed yet because my first try broke
# code.
%.s : %.optbc
	llc $(LLCFLAGS) -f $< -o $@

%.optbc : %.bc
	opt $(LLOPTFLAGS) $< -o $@

%.optdis.ll : %.optbc
	llvm-dis -f $< -o $@

%.dis.ll : %.bc
	llvm-dis -f $< -o $@

%.bc : %.ll
	llvm-as $<

%.ll : %.llm
	cpp $(LPPFLAGS) -nostdinc -P -x assembler-with-cpp -I. $< $@

all : nil

nil : nil.o system_c.o system_ll.o lex.o exp.o memory.o parse.o

nil.ll :    system.llh c_defs.llh nil.llh exp.llh         parse.llh

parse.ll :  system.llh c_defs.llh nil.llh exp.llh lex.llh parse.llh

lex.ll :    system.llh c_defs.llh nil.llh         lex.llh

exp.ll :               c_defs.llh nil.llh exp.llh memory.llh

memory.ll : system.llh c_defs.llh nil.llh exp.llh memory.llh

system_ll.ll : system.llh c_defs.llh

c_defs.llh : c_defs
	./c_defs > c_defs.llh

clean :
	rm -f nil c_defs c_defs.llh *.bc *.optbc *.gbc *.s *.o *.ll

