###
# Blog settings
###

Time.zone = "UTC"

activate :blog do |blog|
  blog.permalink = "{year}/{category}/{title}.html"

  blog.layout = "article"

  blog.tag_template = "tag.html"
  blog.calendar_template = "calendar.html"

  # Enable pagination
  blog.paginate = true
  blog.per_page = 10
  blog.page_link = "page/{num}"

  # Create Category Archive pages
  blog.custom_collections = {
    category: {
      link: '/categories/{category}.html',
      template: '/category.html'
    }
  }
end

page "/feed.xml", layout: false

###
# OpenGraph Settings
###
activate :ogp do |ogp|
  #
  # register namespace with default options
  #
  ogp.namespaces = {
    fb: data.ogp.fb,
    # from data/ogp/fb.yml
    og: data.ogp.og
    # from data/ogp/og.yml
  }
  ogp.base_url = 'http://paperswelove.org/'
  ogp.blog = true
end

###
# Build up Category listing data
###
ready do
  @category_list = []
  sitemap.resources.group_by {|p| p.data["category"] }.each do |category, pages|
    @category_list << { :category => category, :pages => pages }
  end
end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

chapters = [{:name => 'newyork', :title => 'New York Chapter', :description => "New York City's chapter of Papers We Love"},
            {:name => 'sanfrancisco', :title => 'San Francisco Chapter', :description => "The Bay Area chapter of Papers We Love"},
            {:name => 'boulder', :title => 'Boulder Chapter', :description => "The Boulder chapter of Papers We Love"},
            {:name => 'london', :title => 'London Chapter', :description => "The London chapter of Papers We Love"},
            {:name => 'stlouis', :title => 'St. Louis Chapter', :description => "The St. Louis chapter of Papers We Love"},
            {:name => 'columbus', :title => 'Columbus Chapter', :description => "The Columbus chapter of Papers We Love"},
            {:name => 'berlin', :title => 'Berlin Chapter', :description => "The Berlin chapter of Papers We Love"},
            {:name => 'pune', :title => 'Pune Chapter', :description => "The Pune chapter of Papers We Love"},
            {:name => 'boston', :title => 'Boston Chapter', :description => "The Boston chapter of Papers We Love"}
           ]

# Chapter pages
chapters.each do |chapter|
  proxy "/chapter/#{chapter[:name]}.html", "/chapter.html", :locals => { :chapter => chapter }, :ignore => true
end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

# Directory indexes
activate :directory_indexes

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

set :markdown, parse_block_html: true

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

configure :development do
  activate :livereload
end

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end

###
# Git deploy
###
activate :deploy do |deploy|
  deploy.build_before = true # default: false
  deploy.method       = :git
  deploy.branch       = "master" # default: gh-pages
end