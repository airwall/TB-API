require "rails_helper"

RSpec.describe Course, type: :model do
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
