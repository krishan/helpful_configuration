# Example:
#
# during initialization of your app:
#
# my_configuration_file = Pathname("config.json")
# config = HelpfulConfiguration.new(JSON.parse(my_configuration_file.read), my_configuration_file)
# config.explain("spam_destination", "where should the application send it's spam?")
#
# later in your app:
# my_spam.send_to(config["spam_destination"])
#
class HelpfulConfiguration
  attr_accessor :file

  class ConfigurationMissingError < StandardError
  end

  # provide the configuration and the file name where it is stored.
  def initialize(configuration = {}, file=nil)
    @configuration = configuration
    @explanation = {}
    self.file = file
  end

  # access configuration keys.
  # raises an error when the key has not been explained.
  # raises ConfigurationMissingError when the key has not been set.
  def [](key)
    key = key.to_s
    assert_explanation(key)
    if @configuration.has_key?(key)
      @configuration[key]
    else
      raise ConfigurationMissingError,
        "configuration key '#{key}' is missing. "\
        "it should be in the file '#{file}'. "\
        "Explanation: #{@explanation[key]}"
    end
  end

  # set configuration keys.
  def []=(key, value)
    key = key.to_s
    @configuration[key] = value
  end

  # provide explanations for configuration keys.
  def explain(key, explanation)
    key = key.to_s
    @explanation[key] = explanation
  end

  # check if a certain key has been configured by the user.
  def configured?(key)
    assert_explanation(key)
    @configuration.has_key?(key)
  end

  # return the value of the configuration key or if it is missing, the given default.
  def with_default(default, key)
    assert_explanation(key)
    configured?(key) ? self[key] : default
  end

  private

  def assert_explanation(key)
    unless @explanation.has_key?(key)
      raise "no explanation found for key #{key}. "\
        "each configuration key must have an explanation. "\
        "typo in the key name?"
    end
  end
end
