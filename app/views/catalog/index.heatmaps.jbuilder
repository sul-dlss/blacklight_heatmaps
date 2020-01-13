presenter = Blacklight::JsonPresenter.new(@response, blacklight_config)

json.response do
  json.facet_heatmaps @response['facet_counts']['facet_heatmaps']
  json.pages presenter.pagination_info
end
