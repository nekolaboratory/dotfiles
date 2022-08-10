#!/usr/bin/env bash

DOTFILES_DIR="$HOME/.dotfiles"
MITAMAE_BIN="$HOME/bin/mitamae"
MITAMAE_URL="https://github.com/k0kubun/mitamae/releases/download/v1.12.9/"

if [ `uname` = 'Darwin' ]; then
  # Install Command Line tools
  echo "Checking Xcode CLI tools"
  xcode-select -p &> /dev/null
  if [ $? -ne 0 ]; then
    echo "Xcode CLI tools not found. Installing them..."
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
    PROD=$(softwareupdate -l | grep "\*.*Command Line" | grep -v "beta" | tail -n 1 | sed 's/^[^C]* //')
    echo "Prod: ${PROD}"
    softwareupdate -i "$PROD" --verbose;
  fi
  echo "Xcode CLI tools OK"
  
  # Install homebrew
  echo "Checking homebrew"
  which brew > /dev/null
  if [ "$?" -ne 0 ]; then
    echo "homebrew not found. Installing them..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval $(/opt/homebrew/bin/brew shellenv)
  fi
  echo "homebrew OK"
fi

# Install mitamae
if [ ! -e $HOME/bin ]; then
  mkdir $HOME/bin
fi
if [ ! -e $MITAMAE_BIN ]; then
  case "$(uname -m)" in
      "x86_64")
          mitamae_arch="x86_64"
          ;;
      "arm64")
          mitamae_arch="aarch64"
          ;;
      *)
          echo "unsupported architecture: $(uname -m)"
          exit 1
          ;;
  esac
  curl -L "${MITAMAE_URL}mitamae-${mitamae_arch}-`uname`" -o $MITAMAE_BIN
  chmod +x $MITAMAE_BIN
fi
$MITAMAE_BIN version

# Clone nekolaboratory/.dotfiles
git clone -b main https://github.com/nekolaboratory/dotfiles.git $DOTFILES_DIR
cd $DOTFILES_DIR

# Run mitamae
$MITAMAE_BIN local -y nodes/`uname`.yml entry.rb