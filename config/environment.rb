# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# ページネーションを日本語で表示する
WillPaginate::ViewHelpers.pagination_options[:previous_label] = '前へ'
WillPaginate::ViewHelpers.pagination_options[:next_label] = '次へ'
