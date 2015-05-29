class ItemsController < ApplicationController
  def list
    Rails.logger.debug("before")
    a = 'hoge'
		raise 'ahhh!'
    binding.pry
    Rails.logger.debug("after")
  end
end
