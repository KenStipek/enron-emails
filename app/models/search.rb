class Search

  def self.for(query, from = 0)
    result = Hash.new
    result[:emails] = Array.new
    all_results = $search.search index: 'enron_emails', body: { query: { match: { message: query } } }
    result[:hits] = all_results['hits']['total']
    all_results['hits']['hits'].each do |hit|
      result[:emails] << {
        id: hit['_id'],
        user: hit['_source']['user'],
        folder: hit['_source']['folder'],
        message: hit['_source']['message']
      }
    end
    result
  end

  def self.find(id)
    result = $search.get index: 'enron_emails', type: 'message', id: id
    { 
      user: result['_source']['user'],
      folder: result['_source']['folder'],
      message: result['_source']['message']
    }
  end

end