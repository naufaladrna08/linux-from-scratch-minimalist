#!/bin/bash

# Konfirmasi
echo "| Cross Compiler adalah compiler yang mampu menciptakan kode   |"
echo "| yang eksekusi untuk platform lain dari yang di mana compiler |"
echo "| berjalan. Contohnya anda mengkompilasi program dengan cross  |"
echo "| compiler di Linux untuk Windows."

# Unset C Flags
echo "Unsetting C Flags"
unset CXXFLAGS
unset CFLAGS

