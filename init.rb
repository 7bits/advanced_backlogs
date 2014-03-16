require 'redmine'

Rails.configuration.to_prepare do
  require_dependency 'advanced_backlogs_issue_patch'
end

Redmine::Plugin.register :advanced_backlogs do
  name 'Advanced Backlogs plugin'
  author 'Eugene Tarasenko'
  description 'Advanced Backlogs plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/7bits/advanced_backlogs'
  author_url 'https://github.com/etarasenko'
end
