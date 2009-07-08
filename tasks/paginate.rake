task :paginate do

  # Settings
  page_size = 5

  # Load site
  site = Nanoc3::Site.new('.')
  site.load_data

  # Get articles
  articles = site.items.select { |i| i[:kind] == 'article' }
  articles.sort_by { |a| Time.parse(a[:created_at]) }

  # Paginate articles
  article_groups = []
  article_groups << articles.slice!(0..page_size-1) until articles.empty?

  # Create temporary items
  pagination_items = []
  article_groups.each_with_index do |articles, i|
    # Create page
    pagination_item = Nanoc3::Item.new(
      "<%= render 'pagination_page', :articles_per_item => #{page_size}, :item_id => #{i} %>",
      { :title => "Blog - Archive (#{i+1})" },
      "/blog/#{i+1}/"
    )

    # Create reps and add to site
    pagination_item.site = site
    site.items << pagination_item
    pagination_items << pagination_item
  end

  # Prepare new items
  site.send :build_reps
  site.send :route_reps

  # Compile pagination items
  site.compiler.run(nil, :force => true)
end
