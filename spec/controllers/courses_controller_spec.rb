require "rails_helper"
require "will_paginate/array"

shared_examples "courses" do
  context "if not respond < 1 hour" do
    before { get :index }

    it "populates an array courses per page" do
      assigns(courses.paginate(page: 1, per_page: 1))
    end

    it "render index view" do
      expect(response).to render_template :index
      expect(flash[:danger]).to be_present
    end
  end
end

RSpec.describe CoursesController, type: :controller do
  describe "GET #index" do
    context "if respond" do
      let(:courses) { create_list(:course, 2) }
      before { get :index }

      it "populates an array courses per page" do
        assigns(courses.paginate(page: 2, per_page: 1))
      end

      it "render index view" do
        expect(response).to render_template :index
      end
    end

    context "if not respond < 1 hour" do
      let(:courses) { create_list(:course_404, 2) }
      it_behaves_like "courses" do
        let(:courses) { create_list(:course_404, 2) }
      end
    end

    context "if not respond > 1 hour" do
      let(:courses) { create_list(:course_0, 2) }
      it_behaves_like "courses" do
        let(:courses) { create_list(:course_404, 2) }
      end
    end

    context "if service down" do
      let(:course) { create(:course, request_code: 500) }
      before { get :index }

      it "render index view" do
        expect(response).to render_template :index
        expect(flash[:danger]).to be_present
      end
    end

  end
end
