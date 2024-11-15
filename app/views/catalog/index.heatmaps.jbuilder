presenter = Blacklight::JsonPresenter.new(@response, blacklight_config)

json.response do
  json.docs(presenter.documents) do |document|
    document_presenter = document_presenter(document)

    if Blacklight::VERSION > '8'
      json.url url_for(search_state.url_for_document(document))
    else
      json.url search_state.url_for_document(document)
    end
    json.title document_presenter.heading
  end

  json.facet_heatmaps @response['facet_counts']['facet_heatmaps']
  json.pages presenter.pagination_info
end
