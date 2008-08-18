task :paginate do

  # Settings
  page_size = 5

  # Load site
  site = Nanoc::Site.new(YAML.load_file('config.yaml'))
  site.load_data

  # Get articles
  articles = site.pages.select { |p| p.attribute_named(:kind) == 'article' }
  articles.sort_by { |a| a.attribute_named(:created_at) }

  # Paginate articles
  page_groups = []
  page_groups << articles.slice!(0..page_size-1) until articles.empty?

  # Create temporary pages
  page_groups.each_with_index do |pages, i|
    # Create page
    pagination_page = Nanoc::Page.new(
      "<%= render 'pagination_page', :page_size => #{page_size}, :page_id => #{i} %>",
      { :title => "Blog - Archive (#{i+1})" },
      "/blog/#{i+1}"
    )

    # Create reps and add to site
    pagination_page.site = site
    pagination_page.build_reps
    site.pages << pagination_page

    # Compile page
    site.compiler.run([pagination_page])
  end

end
