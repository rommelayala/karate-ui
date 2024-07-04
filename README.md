# karate-ui
# karate-ui

## Introduction
Welcome to the karate-ui framework! This framework is designed to simplify and streamline your testing process using the Karate framework. With karate-ui, you can easily write and execute UI tests for your web applications.

## Getting Started
To get started with karate-ui, follow these steps:

1. Clone and Install the necessary dependencies:
    ```bash
        git clone https://github.com/rommelayala/karate-ui.git
        cd karate-ui
        mvn install
    ```

2. Create a new test file, e.g., `ui-tests.feature`, and define your UI tests using the Karate syntax. Here's an example:

    ```gherkin
    Feature: UI Tests

    Scenario: Verify login functionality
      Given url 'https://example.com/login'
      And input('#username', 'testuser')
      And input('#password', 'password123')
      When click('#login-button')
      Then waitFor('#dashboard')
    ```

3. Run your tests using the tag @debug via command-line interface (CLI):
    ```bash
    mvn test -Dkarate.options="--tags @debug"
    ```

## Documentation
For detailed documentation on how to use karate-ui and its features, please refer to the official Karate documentation: [Karate Documentation](https://karatelabs.github.io/karate/karate-core/)

## Contributing
We welcome contributions from the community! If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request on our GitHub repository.

## License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more information.


## Links 
 Karate documentation https://karatelabs.github.io/karate/karate-core/