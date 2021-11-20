# Add additional compiler flags here
CFLAGS=-std=gnu11 -O3 -Wall -Wextra -Wpedantic

.PHONY: all clean
all: main
main: main.c numquad.S
clean:
	rm -f main
