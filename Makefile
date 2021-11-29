CFLAGS=-std=gnu11 -O3 -Wall -Wextra -Wpedantic

.PHONY: all clean
all: main.out
main: main.c
clean:
	rm -f main.out

