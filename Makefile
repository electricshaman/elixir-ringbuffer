MIX = mix
CC ?= $(CROSSCOMPILE)-gcc
CFLAGS ?= -g -O3 -std=gnu99 -pedantic -Wall -Wextra -Wno-unused-parameter

ifneq ($(OS),Windows_NT)
	CFLAGS += -fPIC

	ifeq ($(shell uname),Darwin)
		LDFLAGS += -dynamiclib -undefined dynamic_lookup
	endif
endif

ifeq ($(ERL_EI_INCLUDE_DIR),)
ERL_ROOT_DIR = $(shell erl -eval "io:format(\"~s~n\", [code:root_dir()])" -s init stop -noshell)
ifeq ($(ERL_ROOT_DIR),)
   $(error Could not find Erlang installation.)
endif
ERL_EI_INCLUDE_DIR = "$(ERL_ROOT_DIR)/usr/include"
endif

ERL_CFLAGS ?= -I$(ERL_EI_INCLUDE_DIR)

DEFAULT_TARGETS ?= priv priv/ringbuffer.so
SRC=$(wildcard src/*.c)

.PHONY: all clean

all: $(DEFAULT_TARGETS)

priv:
	mkdir -p priv

priv/ringbuffer.so: src/ringbuffer.c
	$(CC) $^ -c $(ERL_CFLAGS) $(CFLAGS) -shared -o $@

clean:
	$(RM) priv/ringbuffer.so
