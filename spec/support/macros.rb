def create_user
  User.create(email: Faker::Internet.email, password: "password", full_name: Faker::Name.name)
end

def sign_in(a_user=nil)
  user = a_user || create_user
  visit login_path
  fill_in "email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign In"
end

def create_video(title, description, category)
  Video.create({
    title: title,
    description: description,
    category_id: category.id
  })
end

def create_q_item(user, video, position)
  QItem.create(user_id: user.id, video_id: video.id, position: position)
end

def create_category(name=Faker::Name.name)
  Category.create(name: name)
end

def set_current_user
  session[:user_id] = user.id
end

def clear_current_user
  session[:user_id] = nil
end
