require './PBBaseFetcher.rb'

class CSNewsFetcher < PBBaseFetcher

	def title_search(cell)
		# Subclass and change this
		cell.search('div/div[1]/div/h2/a').text.strip
	end

	def link_search(cell, base_url = '')
		# Subclass and change this
		base_url + cell.search('div/div[1]/div/h2/a')[0]['href']
	end

	def date_search(cell)
		# Subclass and change this
		text = cell.search('div/div[1]/div/div/span/text()[2]').text.strip
		text.delete(' ').gsub('年', '-').gsub('月', '-').gsub('日', ' ')
	end

	def detail_node_selector(doc, string, uri)
		doc.xpath(string.sub('%@', uri.query.split('/').last))
	end

	private :check_config, :fetch_core, :title_search, :link_search, :date_search, :detail_node_selector
	
end
