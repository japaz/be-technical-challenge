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

## Architecture and Code Organization

The application is designed following SOLID principles to be maintainable, testable, and easily extensible. The core idea is a clear separation of concerns between managing the state of the cart, calculating prices, and handling user interaction.

### Directory Structure

- `lib/`: Contains the core application logic.
  - `pricing_rules/`: Holds the individual pricing rule strategies.
- `spec/`: Contains all the RSpec tests, mirroring the lib structure

### Core Components

- `Cart` (`lib/cart.rb`): A simple, stateful object whose only responsibility is to manage the list of product codes that have been "scanned".
- `Product` & `ProductCatalog` (`lib/product.rb`, `lib/product_catalog.rb`): These act as the data layer. ProductCatalog provides a single source of truth for product information (like name and price) and is used by other components for lookups.
- `PricingRule` (`lib/pricing_rules/*.rb`): This is an implementation of the Strategy Pattern.
  - `PricingRule` is the base class defining the interface (calculate_discount).
  - Each concrete rule (e.g., `BuyOneGetOneFreeRule`, `BulkDiscountRule`) encapsulates a single, specific discount logic.
  - They are completely decoupled from the Checkout process and are testable in isolation. New rules can be added to this directory without modifying any other part of the system.
- `Checkout` (`lib/checkout.rb`): This is a stateless "calculator" or service class.
  - It does not hold any state about the items itself.
  - Its total method takes a `Cart` object, calculates the initial sum based on catalog prices, and then applies all configured pricing rules to determine the final price.
  - It uses Dependency Injection to receive the list of rules, making the system highly flexible and configurable from a single entry point (in checkout_cli.rb).
- `CheckoutCLI` (`lib/checkout_cli.rb`): This is the presentation layer.
  - It handles all user input and output, orchestrating the interaction between the user, the Cart, and the Checkout calculator.