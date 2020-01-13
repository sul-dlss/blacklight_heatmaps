presenter = Blacklight::JsonPresenter.new(@response, blacklight_config)

json.response do
  json.docs(presenter.documents) do |document|
    json.url polymorphic_url(url_for_document(document))
    json.title index_presenter(document).heading
  end

  json.facet_heatmaps @response['facet_counts']['facet_heatmaps']
  json.pages presenter.pagination_info
end
