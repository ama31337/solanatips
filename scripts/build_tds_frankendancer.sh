#!/bin/bash

# Exit script on error
set -e

# Get the directory of the current script
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)

# Source the environment variables
if [ -f "$SCRIPT_DIR/env.sh" ]; then
    echo "Sourcing environment variables from env.sh..."
    source "$SCRIPT_DIR/env.sh"
else
    echo "Warning: env.sh file not found in $SCRIPT_DIR. Continuing without sourcing environment variables."
fi

# Variables
REPO_DIR=~/firedancer
REPO_URL="https://github.com/firedancer-io/firedancer.git"
FRANKENDANCER_TDS_VER="v0.302.20104"

# Function to install missing dependencies
install_dependencies() {
    echo "Installing dependencies..."
    sudo apt-get update
    sudo apt-get install -y autoconf gettext automake autopoint flex bison gcc-multilib \
        lcov libgmp-dev libclang-dev pkgconf protobuf-compiler llvm libudev-dev
}

# Function to install Rust if not installed
install_rust() {
    if ! command -v cargo &> /dev/null; then
        echo "Rust is not installed. Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    else
        echo "Rust is already installed. Skipping..."
    fi
}

# Function to clone or update the repository
setup_repository() {
    if [ -d "$REPO_DIR" ]; then
        echo "Repository already exists. Updating..."
        cd "$REPO_DIR"
        git fetch --all
        git checkout "$FRANKENDANCER_TDS_VER"
        git pull origin "$FRANKENDANCER_TDS_VER"
    else
        echo "Cloning repository..."
        git clone --recurse-submodules "$REPO_URL" "$REPO_DIR"
        cd "$REPO_DIR"
        git checkout "$FRANKENDANCER_TDS_VER"
    fi
}

# Function to build the project
build_project() {
    echo "Building Firedancer..."
    ./deps.sh <<< "y" # Automatically confirm prompts
    make -j "$(nproc)" fdctl solana
}

# Function to install binaries
install_binaries() {
    echo "Installing binaries..."
    sudo cp "$REPO_DIR/build/native/gcc/bin/fdctl" /usr/local/bin/
    sudo cp "$REPO_DIR/build/native/gcc/bin/solana" /usr/local/bin/
    echo "Installed binaries:"
    /usr/local/bin/fdctl --version
    /usr/local/bin/solana --version
}

# Main execution
install_dependencies
install_rust
setup_repository
build_project
install_binaries

echo "Firedancer setup completed successfully!"
