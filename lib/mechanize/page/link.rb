#http://gmarik.info/blog/2010/10/16/scraping-asp-net-site-with-mechanize
class Mechanize
  class Page
    class Link
      def asp_link_args
        href = self.attributes['href']
        href =~ /\(([^()]+)\)/ && $1.split(/\W?\s*,\s*\W?/).map(&:strip).map {|i| i.gsub(/^['"]|['"]$/,'')}
      end

      def asp_click(action_arg = nil)
        etarget,earg = asp_link_args.values_at(0, 1)
        form = page.form
        form.action = asp_link_args.values_at(action_arg) if action_arg
        form['__EVENTTARGET'] = etarget
        form['__EVENTARGUMENT'] = earg
        form.submit
      end
    end
  end
end
