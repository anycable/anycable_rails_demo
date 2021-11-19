# frozen_string_literal: true

namespace :kuby do
  namespace :rails_app do
    namespace :db do
      task create_unless_exists: :environment do
        ActiveRecord::Base.connection
      rescue ActiveRecord::NoDatabaseError
        Rake::Task["db:create"].invoke
      end
    end
  end
end
