# Targets to fetch and build external dependencies

# Get ccutil (header only)
$(ROOT)/deps/ccutil:
	@echo $(LOG_PREFIX) Checking out ccutil includes $(LOG_SUFFIX)
	@mkdir -p $(ROOT)/deps
	@git clone git://github.com/ccurtsinger/ccutil $(ROOT)/deps/ccutil

# Update build settings to use ccutil
ifneq (,$(findstring ccutil,$(PREREQS)))
CXXFLAGS += -I$(ROOT)/deps
endif

# Get and build libelfin
$(ROOT)/deps/libelfin:
	@echo $(LOG_PREFIX) Checking out libelfin $(LOG_SUFFIX)
	@mkdir -p $(ROOT)/deps
	@git clone git://github.com/ccurtsinger/libelfin $(ROOT)/deps/libelfin
	@echo $(LOG_PREFIX) Building libelfin $(LOG_SUFFIX)
	@cd $(ROOT)/deps/libelfin; make MAKEFLAGS="-j1" CXX=$(CXX) CC=$(CC)

# Update build settings to include libelfin libraries
ifneq (,$(findstring libelfin,$(PREREQS)))
LDFLAGS += -L$(ROOT)/deps/libelfin/elf \
					 -L$(ROOT)/deps/libelfin/dwarf \
					 -Wl,--whole-archive -lelf++ -ldwarf++ -Wl,--no-whole-archive
CXXFLAGS += -I$(ROOT)/deps
endif
