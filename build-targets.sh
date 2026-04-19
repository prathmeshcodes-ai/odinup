#!/usr/bin/env bash

# ANSI Color Codes
RESET="\033[0m"
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"

echo -e "${BOLD}${CYAN}🚀 OdinUP Cross-Compiler${RESET}"
echo -e "Building local major targets into 'releases/'...\n"

# 1. Clean the releases directory
mkdir -p releases
rm -rf releases/*

# 2. Define the local targets (Linux and Windows)
# Format: "ODIN_TARGET, OS_NAME, ARCH_NAME, EXE_NAME"
TARGETS=(
    "linux_amd64,linux,amd64,odinup"
    "linux_arm64,linux,arm64,odinup"
    "windows_amd64,windows,amd64,odinup.exe"
)

# 3. Compile and Archive
for entry in "${TARGETS[@]}"; do
    IFS=',' read -r TARGET OS ARCH EXE_NAME <<< "$entry"
    ARCHIVE_NAME="odinup-${OS}-${ARCH}.tar.gz"

    echo -e "${YELLOW}⚙️  Building $TARGET...${RESET}"
    
    # Compile the binary (If it fails, skip to the next one gracefully)
    if odin build . -target:"$TARGET" -out:"releases/$EXE_NAME" -o:speed; then
        
        echo -e "📦 Packaging $ARCHIVE_NAME..."
        tar -czf "releases/$ARCHIVE_NAME" -C releases "$EXE_NAME"
        
        # Clean up raw binary
        rm "releases/$EXE_NAME"
        echo -e "${GREEN}✔ Built $ARCHIVE_NAME${RESET}\n"
    else
        echo -e "${RED}✖ Failed to build $TARGET. Missing toolchain? Skipping...${RESET}\n"
    fi
done

echo -e "${BOLD}${GREEN}✨ Local cross-compilation finished!${RESET}"
echo -e "Check your ${CYAN}releases/${RESET} folder for the output."