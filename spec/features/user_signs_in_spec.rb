require "spec_helper"

feature "signing in" do  # describe equivalent
  background do # before equivalent
    User.create(email: "me@me.com", full_name: "John Doe", password: "123456")
  end

  scenario "signs in with existing username" do # it equivalent
    bob = create_user
    sign_in(bob)

    expect(page).to have_content bob.full_name
    expect(page).to have_content "logged in"
  end
end
