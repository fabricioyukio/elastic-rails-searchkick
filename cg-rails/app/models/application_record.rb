class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  paginates_per ENV['DEFAULT_PAGE_SIZE'].to_i || 20
end
