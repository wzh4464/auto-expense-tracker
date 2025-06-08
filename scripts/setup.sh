#!/bin/bash
# scripts/setup.sh - Development Environment Setup

set -e

# Clean up previous setup
cleanup() {
    echo "🧹 Cleaning up previous setup..."
    rm -rf .venv
}

echo "🚀 Setting up Auto Expense Tracker development environment..."

# Check system requirements
check_requirements() {
    echo "📋 Checking system requirements..."

    # uv check
    if ! command -v uv &> /dev/null; then
        echo "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        source $HOME/.cargo/env
    fi

    echo "✅ uv detected"

    # pyenv check
    if ! command -v pyenv &> /dev/null; then
        echo "❌ pyenv is required. Installing pyenv..."
        curl https://pyenv.run | bash
        export PATH="$HOME/.pyenv/bin:$PATH"
    fi
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"

    echo "✅ pyenv detected"

    # Python version check (prefer .python-version)
    SELECTED_PYTHON=""
    if [ -f ".python-version" ]; then
        PYENV_VERSION=$(head -n 1 .python-version | tr -cd '0-9.')
        echo ".python-version detected: $PYENV_VERSION"
        if [[ $PYENV_VERSION =~ ^3\.(?:8|9|1[0-1])(?:\.[0-9]+)?$ ]]; then
            echo ".python-version specifies Python $PYENV_VERSION, trying to find/install..."
            if ! pyenv versions --bare | grep -q "^${PYENV_VERSION}"; then
                echo "pyenv does not have $PYENV_VERSION, trying to install..."
                pyenv install -s $PYENV_VERSION
            fi
            if pyenv versions --bare | grep -q "^${PYENV_VERSION}"; then
                pyenv shell $PYENV_VERSION
                SELECTED_PYTHON=$(pyenv which python || true)
            fi
        else
            echo ".python-version content invalid ($PYENV_VERSION), falling back to auto-detect 3.9~3.11..."
        fi
    fi

    if [ -z "$SELECTED_PYTHON" ]; then
        PYTHON_CANDIDATES=(3.11 3.10 3.9)
        for ver in "${PYTHON_CANDIDATES[@]}"; do
            if pyenv versions --bare | grep -q "^${ver}"; then
                pyenv shell $ver
                SELECTED_PYTHON=$(pyenv which python || true)
                break
            fi
        done

        if [ -z "$SELECTED_PYTHON" ]; then
            for ver in "${PYTHON_CANDIDATES[@]}"; do
                echo "Trying to install Python $ver..."
                pyenv install -s $ver && \
                pyenv shell $ver && \
                SELECTED_PYTHON=$(pyenv which python || true) && break
            done
        fi
    fi

    if [ -z "$SELECTED_PYTHON" ] || [ ! -x "$SELECTED_PYTHON" ]; then
        echo "❌ Could not find or install a Python version between 3.9 and 3.11. Please install manually and retry."
        exit 1
    fi

    PYTHON_VERSION=$($SELECTED_PYTHON --version 2>/dev/null | cut -d' ' -f2)
    echo "✅ Python $PYTHON_VERSION detected at $SELECTED_PYTHON"

    # Git check
    if ! command -v git &> /dev/null; then
        echo "❌ Git is required"
        exit 1
    fi

    echo "✅ Git detected"
}

# Setup Python virtual environment with uv
setup_python_env() {
    echo "🐍 Setting up Python environment with uv..."

    # Create virtual environment with selected Python version
    uv venv --python "$SELECTED_PYTHON"

    # Sync dependencies from pyproject.toml
    uv sync --dev

    echo "✅ Python dependencies installed with uv"
}

# Setup pre-commit hooks
setup_pre_commit() {
    echo "🔧 Setting up pre-commit hooks..."

    # Activate virtual environment
    source .venv/bin/activate
    pre-commit install

    echo "✅ Pre-commit hooks installed"
}

# Setup environment variables
setup_env_vars() {
    echo "🔐 Setting up environment variables..."

    if [ ! -f ".env" ]; then
        cat > .env << EOF
# API Keys (replace with your actual keys)
OPENAI_API_KEY=your_openai_key_here
ANTHROPIC_API_KEY=your_anthropic_key_here
GOOGLE_CLOUD_KEY=your_google_cloud_key_here

# Development settings
DEBUG=true
LOG_LEVEL=INFO
EOF
        echo "✅ .env file created (please update with your API keys)"
    else
        echo "⚠️  .env file already exists"
    fi
}

# Install mobile development tools (optional)
install_mobile_tools() {
    echo "📱 Mobile development tools setup..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - check for Xcode
        if xcode-select -p &> /dev/null; then
            echo "✅ Xcode Command Line Tools detected"
        else
            echo "⚠️  Install Xcode Command Line Tools: xcode-select --install"
        fi

        # Check for Homebrew
        if command -v brew &> /dev/null; then
            echo "✅ Homebrew detected"
        else
            echo "⚠️  Consider installing Homebrew for package management"
        fi
    fi

    echo "ℹ️  For Android development, install Android Studio manually"
}

# Main execution
main() {
    cleanup
    check_requirements
    setup_python_env
    setup_env_vars
    setup_pre_commit
    install_mobile_tools

    echo ""
    echo "🎉 Development environment setup complete!"
    echo ""
    echo "Next steps:"
    echo "1. Update .env file with your API keys"
    echo "2. Run: source .venv/bin/activate"
    echo "3. Run tests: uv run pytest"
    echo "4. Start coding! 🚀"
}

main "$@"
