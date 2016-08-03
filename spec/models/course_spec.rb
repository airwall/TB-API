require 'rails_helper'

RSpec.describe Course, type: :model do
  describe ".fetch" do
    it "should perform correct action on system data based on mocked response" do
      Course.fetch
    end
  end
end
