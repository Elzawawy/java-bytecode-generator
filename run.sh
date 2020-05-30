#! /bin/sh
# re-build program, (flex and Bison and G++ Tools).
make build_all
# Run executable with argument file.
./java_compiler.out "$@"