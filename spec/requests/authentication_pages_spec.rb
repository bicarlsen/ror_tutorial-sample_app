require 'spec_helper'

describe "AuthenticationPages" do
	
	subject { page }

	describe 'authorization' do
		
		describe 'as non-admin user' do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before { sign_in non_admin, no_capybara: true }

			describe 'submitting a DELETE request to the Users#destroy action' do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to root_url }
			end # submitting a delete request to users#destroy action
		end # as non admin user

		describe 'as wrong user' do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: 'incorrect@example.com') }

			before { sign_in user, no_capybara: true }

			describe 'submitting a GET request to the Users#edit action' do
				before { get edit_user_path(wrong_user) }

				specify { expect(response.body).not_to match(full_title('Edit User')) }
				specify { expect(response).to redirect_to(root_url) }
			end # submitting a get request to the users#edit action
		
			describe 'submitting a PATCH request to the Users#update action' do
				before { patch user_path(wrong_user) }
				
				specify { expect(response).to redirect_to(root_url) }
			end # submitting a patch request to the users#update action
		end # as wrong user
		
		describe 'for non-signed-in users' do
			let(:user) { FactoryGirl.create(:user) }
		
			describe 'in relationships controller' do
				describe 'submitting to the create action' do
					before { post relationships_path }
					specify { expect(response).to redirect_to signin_path }
				end # submitting to the create action

				describe 'submitting to the destroy action' do
					before { delete relationship_path 1 }
					specify { expect(response).to redirect_to signin_path }
				end # submitting to the destroy action
			end # in relationships controller			

			describe 'in the microposts controller' do
				describe 'submitting to the create action' do
					before { post microposts_path }	
					specify { expect(response).to redirect_to signin_path }
				end # submitting to create action

				describe 'submitting to the destroy action' do
					before { delete micropost_path(FactoryGirl.create(:micropost)) }
					specify { expect(response).to redirect_to(signin_path) }
				end # submitting to destory action
			end # in the microposts controller
		
			describe 'when attempting to visit a protected page' do
				before do
					visit edit_user_path(user)
					fill_in "Email", with: user.email
					fill_in 'Password', with: user.password
					click_button 'Sign In'
				end
			
				describe 'after signing in' do
					it 'should render the desired protected page' do
						expect(page).to have_title 'Edit User'
					end
				end # after singing in
			end # when attempting to visit a protected page

			describe 'in the Users controller' do
				describe 'visiting the following page' do
					before { visit following_user_path user }
					it { should have_title('Sign In') }
				end			

				describe 'visiting the followers page' do
					before { visit followers_user_path user }
					it { should have_title 'Sign In' }
				end

				describe 'visiting the edit page' do
					before { visit edit_user_path(user) }

					it { should have_title('Sign In') }
				end

				describe 'submitting to the update action' do
					before { patch user_path(user) }

					specify { expect(response).to redirect_to(signin_path) }
				end
				
				describe 'visiting the user index' do
					before { visit users_path }

					it { should have_title('Sign In') }
				end

			end # in the Users controller
		end # for non-signed-in users
	end # authentication

	describe "signin page" do
		before { visit signin_path }

		it { should have_content('Sign In') }
		it { should have_title('Sign In') }

		describe "with invalid input" do
			before { click_button "Sign In" }

			it { should have_title('Sign In') }
			it { should have_selector('div.alert.alert-error', text: 'Invalid') }

			describe "after visiting another page" do
				before { click_link "Home" }

				it { should_not have_selector('div.alert.alert-error') }
			end

		end # with invalid input

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			
			before do
				fill_in "Email", with: user.email.upcase
				fill_in "Password", with: user.password
				click_button "Sign In"
			end

			it { should have_title(user.name) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Sign Out', href: signout_path) }
			it { should have_link('Settings', href: edit_user_path(user)) }
			it { should have_link('Users', href: users_path) }
			it { should_not have_link('Sign In', href: signin_path) }
		end # with valid information

	end # with valid input

end # authenticaion pages
