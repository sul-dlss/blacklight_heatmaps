##
# Overrides default index.json.jbuilder from Blacklight by adding the
# `facet_heatmaps` key/value

json.response do
  json.docs @presenter.documents
  json.facets @presenter.search_facets_as_json
  json.facet_heatmaps @response['facet_counts']['facet_heatmaps']
  json.pages @presenter.pagination_info
end
