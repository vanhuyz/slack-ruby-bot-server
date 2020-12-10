module SlackRubyBotServer
  module Config
    extend self

    attr_accessor :logger
    attr_accessor :service_class
    attr_accessor :view_paths
    attr_accessor :oauth_scope
    attr_accessor :oauth_version

    def reset!
      self.logger = nil
      self.service_class = SlackRubyBotServer::Service
      self.oauth_scope = nil
      self.oauth_version = :v2

      self.view_paths = [
        'views',
        'public',
        File.expand_path(File.join(__dir__, '../../public'))
      ]

    end

    def oauth_authorize_url
      case oauth_version
      when :v2
        'https://slack.com/oauth/v2/authorize'
      when :v1
        'https://slack.com/oauth/authorize'
      else
        raise ArgumentError, 'Invalid oauth_version, must be one of :v1 or v2.'
      end
    end

    def oauth_access_method
      case oauth_version
      when :v2
        :oauth_v2_access
      when :v1
        :oauth_access
      else
        raise ArgumentError, 'Invalid oauth_version, must be one of :v1 or v2.'
      end
    end

    def oauth_scope_s
      oauth_scope&.join('+')
    end

    def activerecord?
      false
    end

    def mongoid?
      true
    end

    reset!
  end

  class << self
    def configure
      block_given? ? yield(Config) : Config
    end

    def config
      Config
    end
  end
end
