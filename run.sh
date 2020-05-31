#! /bin/bash
# re-build program, (flex and Bison and G++ Tools).
make build_all

# Run executable with argument file.
# Supports debug mode with either tags (--debug or -d), in debug mode, simply files are taken from tests-cases directory.
if [ "$1" = "--debug" -o "$1" = "-d" ]; then
    if [ -r "test-cases/$2" ]; then
        ./java_compiler.out "test-cases/$2"
    else
        echo "The argument '$2' is not a valid file, or does not exist in test-cases directory. Are you sure you want debug mode ?"
    fi
# For non-debug mode, files are taken from anywhere and you include the filename directly after command.
else 
    if [ -r "$1" ]; then
        ./java_compiler.out "$1"
    else
        echo "The argument '$1' is not a valid file, or does not exist."
    fi
fi