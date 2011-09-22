class HelpfulConfiguration
  attr_accessor :file

  class ConfigurationMissingError < StandardError
  end

  def self.from_file(file, keys)
    config = new
    config.file = File.expand_path(file)
    if File.exists?(file)
      JSON.parse(File.read(file)).each do |key, value|
        config[key] = value
      end
    end
    config
  end

  def initialize(configuration = {}, file=nil)
    @configuration = configuration
    @explanation = {}
    self.file = file
  end

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

  def []=(key, value)
    key = key.to_s
    @configuration[key] = value
  end

  def explain(key, explanation)
    key = key.to_s
    @explanation[key] = explanation
  end

  def configured?(key)
    assert_explanation(key)
    @configuration.has_key?(key)
  end

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
