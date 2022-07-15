DIFF ?= diff --strip-trailing-cr --unified
LUA ?= lua
PANDOC ?= pandoc

STANDALONE = dumpex.lua levels.lua
FILTER = para.lua para2.lua simple.lua table.lua

# make COMPARE= to run tools without redirection or comparison
# make SNAPSHOT=true to create .expected files
ifneq "$(SNAPSHOT)" ""
  COMPARE = 2>$*.expected >/dev/null
else
  COMPARE = 2>&1 >/dev/null | $(DIFF) $*.expected -
endif

test: test-standalone test-filter

test-standalone: $(STANDALONE:%=test-standalone-%)

test-filter: $(FILTER:%=test-filter-%)

test-standalone-%: %
	$(LUA) $* $(COMPARE)

test-filter-%: %
	$(PANDOC) $(wildcard *.md) -L $* $(COMPARE)
