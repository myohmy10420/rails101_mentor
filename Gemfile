source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '~> 6.1.7'
gem 'sqlite3', '~> 1.4'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'bootstrap-sass'
gem 'simple_form'
gem 'devise'
gem 'will_paginate'
gem 'aasm'

group :development, :test do
  gem 'pry-rails'
  gem 'rubocop', '~> 1.13.0', require: false
  gem "rubocop-github"
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'factory_bot_rails'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
