# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create([
  {
    title: "Jurrassic Park",
    description: "Dinosaurs come back from the dead & eat people.",
    small_cover_url: "https://u.imageresize.org/291889a6-231f-437f-bd79-1cdf424164ec.jpeg",
    large_cover_url: "http://netdna.webdesignerdepot.com/uploads/2011/02/jurassicpark.jpg"
  },
  {
    title: "Star Wars: The Force Awakens",
    description: "Good & evil battle in the universe. Good wins. Suprise-surprise.",
    small_cover_url: "https://u.imageresize.org/0d313a46-1659-4b9c-89d0-7dbc705d46cb.jpeg",
    large_cover_url: "https://img.cinemablend.com/cb/a/c/b/8/8/c/acb88c77c38630af9b1964335e495ee8677fc3592494774a6a986c6dc7bf3906.jpg"
  },
  {
    title: "Halloween",
    description: "Some guy goes ape-shit & kills a ton of idiots.",
    small_cover_url: "https://u.imageresize.org/d02708a9-35ef-48cd-bfc7-58c40d250acf.jpeg",
    large_cover_url: "https://orig00.deviantart.net/5639/f/2016/120/f/c/halloween_the_night_he_came_home_by_smalltownhero-da0qy7k.jpg"
  },
  {
    title: "Smorgisboard",
    description: "Don't ask me.",
    small_cover_url: "https://u.imageresize.org/0d313a46-1659-4b9c-89d0-7dbc705d46cb.jpeg",
    large_cover_url: "https://img.cinemablend.com/cb/a/c/b/8/8/c/acb88c77c38630af9b1964335e495ee8677fc3592494774a6a986c6dc7bf3906.jpg"
  },
  {
    title: "Cartoon for Kids",
    description: "A cartoon with so much adult humor you'd think it wasn't for kids.",
    small_cover_url: "https://u.imageresize.org/291889a6-231f-437f-bd79-1cdf424164ec.jpeg",
    large_cover_url: "http://netdna.webdesignerdepot.com/uploads/2011/02/jurassicpark.jpg"
  },
  {
    title: "Tiddies",
    description: "Does it really need a description?",
    small_cover_url: "https://u.imageresize.org/d02708a9-35ef-48cd-bfc7-58c40d250acf.jpeg",
    large_cover_url: "https://orig00.deviantart.net/5639/f/2016/120/f/c/halloween_the_night_he_came_home_by_smalltownhero-da0qy7k.jpg"
  }
])