require "rails_helper"
require 'will_paginate/array'

RSpec.describe CoursesController, type: :controller do
  describe 'GET #index' do
    let(:courses) { create_list(:course, 2) }
    before { get :index }

    it "populates an array courses per page" do
      assigns(courses.paginate(page: 2, per_page: 1))
     end

    it "render index view" do
      expect(response).to render_template :index
    end
  end

end
