# REQUIRES: x86

# RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %S/Inputs/just-symbols.s -o %t1
# RUN: ld.lld %t1 -o %t1.exe -Ttext=0x10000 -Tdata=0x11000

# RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %s -o %t2
# RUN: ld.lld %t2 -just-symbols=%t1.exe -o %t2.exe
# RUN: llvm-readelf -symbols %t2.exe | FileCheck %s
#
# RUN: ld.lld -R %t1.exe -o %t3.exe
# RUN: llvm-readelf -symbols %t3.exe | FileCheck %s

# CHECK: 0000000000011000    40 OBJECT  GLOBAL DEFAULT  ABS bar
# CHECK: 0000000000010000     0 NOTYPE  GLOBAL DEFAULT  ABS foo

# RUN: not ld.lld -just-symbols=%t1 2>&1 | FileCheck %s --check-prefix CHECK-REL
# CHECK-REL: error: {{.*}}: --just-symbols only accepts ET_EXEC files

.globl _start
_start:
  call foo
  call bar
  ret
