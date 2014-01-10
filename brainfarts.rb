require 'rubygems'
require 'bundler/setup'
require 'celluloid/autostart'
require 'pry'
require 'twitter'

class Fart
  include Celluloid

  def initialize(fart_content)
    @content = fart_content
  end

  def fart
    %x{say "#{@content}"}
  end
end

module Brainfarts
  def self.fart!(options)
    client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = options[:consumer_key]
      config.consumer_secret     = options[:consumer_secret]
      config.access_token        = options[:access_token]
      config.access_token_secret = options[:access_token_secret]
    end

    client.user do |object|
      if object.class == Twitter::Tweet
        puts object.text
        Fart.new(object.text).async.fart
      end
    end
  end
end

Brainfarts.fart! consumer_key: '',
                 consumer_secret: '',
                 access_token: '',
                 access_token_secret: ''