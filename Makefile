MIX = mix

CC ?= $(CROSSCOMPILE)-gcc
CFLAGS ?= -O3 -Wall -Wextra -Wno-unused-parameter

ERLANG_PATH = $(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

CFLAGS += -I$(ERLANG_PATH)
MODES_PATH = .
CFLAGS += -I$(MODES_PATH)/src

ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

DEFAULT_TARGETS ?= priv priv/ringbuffer.so

SRC=$(wildcard src/*.c)

.PHONY: all clean

all: $(DEFAULT_TARGETS)

priv:
	mkdir -p priv

priv/ringbuffer.so: src/ringbuffer.c
	$(CC) $^ $(CFLAGS) -shared $(LDFLAGS) -o $@

clean:
	rm -f priv/ringbuffer.so
