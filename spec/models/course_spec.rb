require "rails_helper"

RSpec.describe Course, type: :model do
  describe ".keep_status_request" do
    it "should return @request 200 when :post success" do
    end

    it "should return @request 404 when :post not-success and time < 1 hour" do
      Course.keep_status_request
      expect(Course.request).to eq 404
    end

    it "should return @request 0 when :post not-success and time > 1 hour" do
      Course.checkpoint = Time.now + 2.hours
      Course.keep_status_request
      expect(Course.request).to eq 0
    end
  end

  describe ".save_data_to_db" do
    context "should save course from open session" do
      it "Save" do
        json = JSON.parse(File.read("#{Rails.root}/spec/support/shared/course.json"))
        expect { Course.save_data_to_db(json) }.to change(Course, :count).by(1)
        expect(Course.first.access_type).to eq "open"
      end
    end

    context "should don't save course from open session if course exist" do
      let!(:course) { create(:course) }
      it "Don't save" do
        json = JSON.parse(File.read("#{Rails.root}/spec/support/shared/course.json"))
        expect { Course.save_data_to_db(json) }.to change(Course, :count).by(0)
      end
    end
  end
end
