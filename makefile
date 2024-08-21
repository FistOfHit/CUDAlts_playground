# Simple Makefile for LibreCUDA Project

# Variables
LIBRECUDA_REPO = https://github.com/mikex86/LibreCuda.git
LIBRECUDA_DIR = LibreCuda
BUILD_DIR = build

# Default target
all: setup build

# Clone LibreCUDA repository
$(LIBRECUDA_DIR):
	git clone --recurse $(LIBRECUDA_REPO)

# Setup the project structure
setup: $(LIBRECUDA_DIR)
	mkdir -p $(BUILD_DIR)

# Build the project using CMake
build:
	cd $(BUILD_DIR) && cmake .. && make

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all setup build clean