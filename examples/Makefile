DIFF ?= diff --strip-trailing-cr --unified
LUA ?= lua
PANDOC ?= pandoc

PANDOCFLAGS +=

STANDALONE = dumpex.lua levels.lua
FILTER = para.lua para2.lua simple.lua table.lua

test-filter-para.lua test-filter-para2.lua: \
	PANDOCFLAGS += --verbose

# make COMPARE= to run tools without redirection or comparison
# make SNAPSHOT=true to create .expected files
FIX = sed -e 's/in [0-9]* ms/in NN ms/'
ifneq "$(SNAPSHOT)" ""
  COMPARE = 2>&1 >/dev/null | $(FIX) >$*.expected
else
  COMPARE = 2>&1 >/dev/null | $(FIX) | $(DIFF) $*.expected -
endif

test: test-standalone test-filter

test-standalone: $(STANDALONE:%=test-standalone-%)

test-filter: $(FILTER:%=test-filter-%)

test-standalone-%: %
	$(LUA) $* $(COMPARE)

test-filter-%: %
	$(PANDOC) $(PANDOCFLAGS) $(wildcard *.md) -L $* $(COMPARE)
