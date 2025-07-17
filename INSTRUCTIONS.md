# Instructions

This document provides instructions on how to set up the project, run the application, and execute the test suite.

## Prerequisites

Before you begin, ensure you have the following installed:
- Ruby (version 3.0 or later is recommended)
- Bundler (`gem install bundler`)

## Setup

First, navigate to the project's root directory and install the required gems using Bundler:

```bash
bundle install
```

## Running the Application

To start the interactive command-line interface (CLI) for the cash register, run the following command:

```bash
ruby lib/checkout_cli.rb
```

You can then scan items by entering their product codes (e.g., `GR1`, `SR1`, `CF1`) one per line. Press Enter on an empty line to finish and see the final total.

## Running the Tests

The project is covered by a full RSpec test suite. To run all tests and verify the application's functionality, execute the following command:

```bash
bundle exec rspec
```