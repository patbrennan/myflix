require "spec_helper"

feature "user interacts with the q" do

  scenario "user adds & reorders videos in the q" do
    comedy = Category.create(name: "comedy")
    monk = Video.create(title: "Monk", description: Faker::Lorem.sentence, category: comedy)
    south_park = Video.create(title: "South Park", description: Faker::Lorem.sentence, category: comedy)
    futurama = Video.create(title: "Futurama", description: Faker::Lorem.sentence, category: comedy)

    sign_in
    find("a[href='/videos/#{monk.id}']").click
    expect(page).to have_content(monk.title)

    click_link "+ My Queue"
    expect(page).to have_content(monk.title)

    visit video_path(monk)
    page.should_not have_content "+ My Queue"

    add_to_q(south_park)
    add_to_q(futurama)

    set_position(monk, 3)
    set_position(futurama, 2)
    set_position(south_park, 1)
    click_button "Update Instant Queue"

    expect(position_value(south_park)).to eq("1")
    expect(position_value(futurama)).to eq("2")
    expect(position_value(monk)).to eq("3")
  end

  def add_to_q(video)
    visit home_path
    find("a[href='/videos/#{video.id}']").click
    click_link "+ My Queue"
  end

  def set_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end

  def position_value(video)
    find("input[data-video-id='#{video.id}']").value
  end
end