require "rails_helper"

RSpec.describe Course, type: :model do
  describe ".keep_status_request" do
    context "if count != nil" do
      let!(:course) { Course.create(last_synched_at: Time.now) }
      it "should return @request_code 200 when :post success" do
      end

      it "should return @request_code 404 when :post not-success and time < 1 hour" do
        Course.set_time_delay
        expect(Course.last.request_code).to eq 404
      end

      it "should return @request_code 0 when :post not-success and time > 1 hour" do
        Course.last.update(last_synched_at: Time.now - 2.hours)
        Course.set_time_delay
        expect(Course.last.request_code).to eq 0
      end
    end

    context "if count nil" do
      it "should return request_code 500 " do
        Course.set_time_delay
        expect(Course.last.request_code).to eq 500
      end
    end
  end

  # describe ".save_data_to_db" do
  #   context "should save course from open session" do
  #     it "Save" do
  #       json = JSON.parse(File.read("#{Rails.root}/spec/support/shared/course.json"))
  #       expect { Course.save_data_to_db(json) }.to change(Course, :count).by(1)
  #     end
  #   end
  #
  #   context "update last_synched_at if course exist" do
  #     it "Don't save" do
  #       json = JSON.parse(File.read("#{Rails.root}/spec/support/shared/course.json"))
  #       Course.save_data_to_db(json)
  #       expect { Course.save_data_to_db(json) }.to change(Course, :count).by(0)
  #       expect { Course.save_data_to_db(json) }.to change{ Course.last.last_synched_at }
  #     end
  #   end
  # end
end
