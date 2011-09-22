# HelpfulConfiguration

HelpfulConfiguration offers an easy way to provide helpful explanations for ruby applications that need to be configured.

The developer provides a helpful explanation for each configuration key.
When the configuration key is accessed but missing, HelpfulConfiguration will raise an error with this message.

HelpfulConfiguration will also enforce that each key has an explanation, thereby preventing the developer from forgetting to write or update the documentation.

### Install

    gem build helpful_configuration.gemspec
    gem install helpful_configuration*.gem

### Author

Kristian Hanekamp, Infopark AG
