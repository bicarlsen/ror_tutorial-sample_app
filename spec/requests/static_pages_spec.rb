require 'spec_helper'

describe "StaticPages" do
	subject { page }

  describe "Home page" do
   	before { visit root_path }
	 	
		it { should have_content('Sample App') }
		it { should have_title(full_title) }
		it { should_not have_title('Home') }

		describe 'for signed in users' do
			let(:user) { FactoryGirl.create(:user) }

			before do
				FactoryGirl.create(:micropost, user: user, content: 'Lorem ipsum')
				FactoryGirl.create(:micropost, user: user, content: 'Dolor sit amet')
				
				sign_in user
				visit root_path
			end

			it 'should render the users feed' do
				user.feed.each do |item|
					expect(page).to have_selector("li##{item.id}", text: item.content)
				end
			end # should render the user's feed
		end # for signed in users
end # home page

	describe "Help page" do
		before { visit help_path }

		it { should have_content('Help') }
		
		it "should have the title 'Help'" do
			expect(page).to have_title(full_title 'Help')
		end
	end

	describe "About page" do
		it "should have the content 'About Us'" do
			visit about_path
			expect(page).to have_content('About Us')
		end
	
		it "should have the title 'About Us'" do
			visit about_path
			expect(page).to have_title(full_title 'About Us')
		end
	end

	describe "Contact page" do
		it "should have the content 'Contact'" do
			visit contact_path
			expect(page).to have_content('Contact')
		end

		it "should have the title 'Contact'" do
			visit contact_path
			expect(page).to have_title(full_title 'Contact')
		end
	end
end
