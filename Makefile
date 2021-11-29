CFLAGS=-std=gnu11 -O3 -Wall -Wextra -Wpedantic

.PHONY: all clean
all: main
main: main.c regulafalsi.S
clean:
	rm -f main
