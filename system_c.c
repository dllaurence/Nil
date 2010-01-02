/**********************************************************************
  system.c
 
  Helper code for things that can only be done from C.
 
  Copyright 2009 by Dustin Laurence.  Distributed under the terms of
  the LGPLv3.
 
 **********************************************************************/

#include <stdio.h>
#include <stdint.h>
#include <assert.h>

/**********************************************************************
  getstdfileptr
 
  Sends the standard FILE* stream pointers to LLVM code.  LLVM knows nothing of
  whatever FILE points to, so we're going to pass it back as a char* which LLVM
  will interpret as an (i8*) to be used as an opaque pointer.  Perhaps a void*
  would be a better choice, but LLVM uses i8* as a void pointer and that we
  can pass through with semantics LLVM will recognize as a pointer.

 **********************************************************************/

char*
getstdfileptr(int fd)
{
    assert(fd >= 0);
    assert(fd <= 2);

    /* This is a dirty hack that attempts to verify the safety of a dirty hack.
     * :-)  We require the bit pattern remains identical through the casts, so
     * we attempt to verify this by casting both pointers to the same integral
     * type.  Maybe it'll catch a problem.... */

    assert( ((uintptr_t) ((char*) stdin)) == ((uintptr_t) stdin));

    switch (fd) {
    case 0:
        return (char*) stdin;
    case 1:
        return (char*) stdout;
    case 2:
        return (char*) stderr;
    default:
        assert(0); // "Can't happen"
    }
}

