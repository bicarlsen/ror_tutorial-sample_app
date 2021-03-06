require 'spec_helper'

describe "MicropostPages" do
	
	subject { page }

	let(:user) { FactoryGirl.create :user }
	before { sign_in user }

	describe 'micropost destruction' do
		before { FactoryGirl.create :micropost, user: user }

		describe 'as a correct user' do
			before { visit root_path }

			it 'should delete a micropost' do
				expect { click_link 'delete' }.to change(Micropost, :count).by(-1)
			end
		end # as a correct user
	end # micropost destruction

	describe 'micropost creation' do
		before { visit root_path }

		describe 'with invalid info' do
			it 'should not create a micropost' do
				expect { click_button 'Post' }.not_to change(Micropost, :count)
			end

			describe 'error messages' do
			 	before { click_button 'Post' }
				it { should have_content 'error' } 
			end
		end # with invalid info

		describe 'with valid info' do
			before { fill_in 'micropost_content', with: 'Lorem ipsum' }

			it 'should create a micropost' do
				expect { click_button 'Post' }.to change(Micropost, :count).by(1)
			end
		end # with valid info
	end # micropost creation

end
