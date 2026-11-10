OPENSCAD ?= openscad-nightly

SRCS := $(wildcard *.scad)
OBJS := $(SRCS:.scad=.stl)

.PHONY: all clean

all: $(OBJS)

%.stl: %.scad
	$(OPENSCAD) -o $@ $<

clean:
	rm -f $(OBJS)
