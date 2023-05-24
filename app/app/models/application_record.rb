# frozen_string_literal: true

# Making this an abstract class means that it will not be created as a table in the database.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
