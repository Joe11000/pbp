require 'rubygems'
require 'spork'
require 'simplecov'
require 'vcr_setup'
#require 'spork/ext/ruby-debug'

Spork.prefork do
  SimpleCov.start do
    add_filter '/spec/'
    add_filter '/config/'
    add_filter '/lib/'
    add_filter '/vendor/'

    add_group 'Controllers', 'app/controllers'
    add_group 'Models', 'app/models'
    add_group 'Helpers', 'app/helpers'
    add_group 'Mailers', 'app/mailers'
    add_group 'Views', 'app/views'
  end

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'database_cleaner'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
    provider: 'twitter',
    uid: '1234',
    info: {
      nickname: 'bobjones',
      name: 'Bob Jones',
      location: 'Chicago',
      image: 'imageurl.com',
      description: 'a very normal guy',
      urls: {
        website: nil,
        twitter: 'https://twitter.com/bobjones'
      }
    },
    credentials: {
      token: 'token',
      secret: 'secret'
    }
  })

  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    :provider => 'facebook',
    :uid => '1234',
    :info => {
      :nickname => 'bobjones',
      :email => 'bobjones@gmail.com',
      :name => 'Bob Jones',
      :first_name => 'Bob',
      :last_name => 'Jones',
      :image => 'http://graph.facebook.com/1234567/picture?type=square',
      :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
      :location => 'Chicago, IL',
      :verified => true
    },
    :credentials => {
      :token => 'TOKEN',
      :expires_at => 2014010101,
      :expires => true
    },
  })

  def add_user_mock(params = {})
    provider = params[:provider] || :facebook
    uid = params[:uid] || "1234"
    info = params[:info] || {
      :nickname => 'bobjones',
      :email => 'bobjones@gmail.com',
      :name => 'Bob Jones',
      :first_name => 'Bob',
      :last_name => 'Jones',
      :image => 'http://graph.facebook.com/1234567/picture?type=square',
      :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
      :location => 'Chicago, IL',
      :verified => true
    }
    credentials = params[:credentials] || {
      :token => 'TOKEN',
      :expires_at => 2014010101,
      :expires => true
    }

    OmniAuth.config.add_mock(
      provider,
      { uid: uid,
        info: info,
        credentials: credentials }
    )
  end

  RSpec.configure do |config|
    config.include Capybara::DSL

    config.mock_with :rspec

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each, :js => true) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.

end
