# bash/justfile

# advent-of-spin-2023-c1/justfile

# https://just.systems/man/en/chapter_1.html

# ------------------------------------------------------------------------------
# CONFIG

set shell := ["bash", "-uc"]

# ------------------------------------------------------------------------------
# VARIABLES

# NODE_VERSION := "v16.13.2"

################################################################################
# RECIPES
################################################################################

# DEFAULT RECIPE WHEN USER DOES NOT GIVE A SPECIFIC RECIPE

@_default:
    echo "View file 'justfile' to see internals of any recipe."
    just --list --unsorted

# ------------------------------------------------------------------------------
# BASIC RECIPES

# ------------------------------------------------------------------------------
# RUN LOCAL SERVERS

# Run the app on localhost with hot-reloading.
@dev:
    spin watch

# ------------------------------------------------------------------------------
# BUILD & DEPLOY

# Build the app for production.
@build:
    spin build

# Deploy the app to the cloud.
@deploy: build
    spin deploy

# ------------------------------------------------------------------------------
# MISC

# Gather stats about the app's code size & todos.
@stats:
    ( \
        echo "\nTokei\n"; \
        tokei; \
        echo "\nTCount\n"; \
        tcount; \
        NUM=$(rg TODO -g "!justfile" -g "!stats.txt" | wc -l | tr -s ' '); \
        echo "\n################################################################################"; \
        echo "\nTodo: $NUM\n"; \
        rg TODO -g "!justfile" -g "!stats.txt" || echo "none"; \
    ) > stats.txt && bat stats.txt

# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

# Add this stuff?

# ------------------------------------------------------------------------------
# LINTING

# Lint all code.
@lint: lint-rs

# Only lint the Rust code via Clippy.
@lint-rs:
    cargo clippy --all-targets --all-features -- -D warnings

# ------------------------------------------------------------------------------
# TESTING

# Run all tests.
test: test-rs test-hurl

# Run Rust tests.
@test-rs:
    cargo test

# Run Hurl tests.
@test-hurl:
    hurl --test test.hurl

# ------------------------------------------------------------------------------
# FINAL SUBMISSION

# Submit the final version of the app to the Advent of Code website.
submit:
    hurl \
    --error-format long \
    --variable serviceUrl="https://aos-chal-one-wgedpbqc.fermyon.app/" \
    submit.hurl