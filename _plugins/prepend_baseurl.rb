# Inject site.baseurl into root-absolute URLs of the final rendered HTML.
#
# Content and templates deliberately use root-absolute URLs (e.g. /articles,
# /assets/...) so they stay portable. When the site is served from a subpath
# (GitHub project pages: /newscastieldev/), those URLs need the baseurl prefix.
# This post_render hook rewrites href="/..." and src="/..." once, at build time.
#
# Skips protocol-relative (//) and already-prefixed (/<baseurl>/...) URLs. With
# baseurl == "" (root-domain deploy) it is a no-op, so switching domains is just
# a config change.
module PrependBaseurl
  def self.process(item)
    baseurl = item.site.config["baseurl"].to_s
    return if baseurl.empty?
    return unless item.output
    return unless item.output_ext == ".html"

    bu = baseurl.chomp("/")                 # "/newscastieldev"
    name = Regexp.escape(bu.sub(%r{\A/}, "")) # "newscastieldev"
    item.output = item.output.gsub(
      %r{\b(href|src)=(["'])/(?!/)(?!#{name}/)}
    ) { "#{Regexp.last_match(1)}=#{Regexp.last_match(2)}#{bu}/" }
  end
end

Jekyll::Hooks.register(:documents, :post_render) { |doc| PrependBaseurl.process(doc) }
Jekyll::Hooks.register(:pages, :post_render) { |page| PrependBaseurl.process(page) }
