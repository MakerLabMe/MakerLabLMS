atom_feed :language => 'zh-CN' do |feed|
  feed.title Siteconf.site_name
  feed.updated @last_update

  @feed_items.each do |item|
    guide_url = guide_article_url(item.guide,item)
    guide_title = item.guide.title + " - "
    feed.entry(item, :url => guide_url ) do |entry|
      entry.url guide_url
      entry.title guide_title + item.title
      entry.content parse_markdown(item.content), :type => 'html'
      entry.updated item.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")

      entry.author do |author|
        author.name item.user.nickname
      end
    end
  end
end
