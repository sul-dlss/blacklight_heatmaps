require 'spec_helper'

describe BlacklightMaps::SolrFacetHeatmapBehavior do
  let(:blacklight_config) { CatalogController.blacklight_config.deep_copy }
  let(:context) { CatalogController.new }

  before do
    allow(context).to receive(:blacklight_config).and_return(blacklight_config)
  end

  let(:search_builder_class) do
    Class.new(Blacklight::SearchBuilder) do
      include Blacklight::Solr::SearchBuilderBehavior
      include BlacklightMaps::SolrFacetHeatmapBehavior
    end
  end

  let(:search_builder) { search_builder_class.new(context) }

  describe '#add_solr_facet_heatmap' do
    let(:solr_params) { { fq: [filter: 'stuff'], bq: [boost: 'stuff'] } }
    context 'when bbox is not present' do
      subject { search_builder }
      it 'does not modify the solr parameters' do
        expect(subject.add_solr_facet_heatmap(solr_params)).to eq solr_params
      end
    end
    context 'when a bbox is present' do
      subject { search_builder.with(bbox: '1,2,4,3') }
      it 'leaves solr params in place and adds new params' do
        expect(subject.add_solr_facet_heatmap(solr_params)['facet.heatmap'])
          .to eq :geo_srpt
        expect(subject.add_solr_facet_heatmap(solr_params)['facet.heatmap.geom'])
          .to eq '["1 2" TO "4 3"]'
        expect(subject.add_solr_facet_heatmap(solr_params)[:bq])
          .to include(boost: 'stuff')
        expect(subject.add_solr_facet_heatmap(solr_params)[:bq])
          .to include('geo_srpt:"IsWithin(ENVELOPE(1.0, 4.0, 3.0, 2.0))"')
        expect(subject.add_solr_facet_heatmap(solr_params)[:fq])
          .to include(filter: 'stuff')
        expect(subject.add_solr_facet_heatmap(solr_params)[:fq])
          .to include('geo_srpt:"Intersects(ENVELOPE(1.0, 4.0, 3.0, 2.0))"')
      end
    end
  end

  describe '#bbox' do
    subject { search_builder.with(bbox: '1,2,4,3') }
    it 'returns the bbox parameter split on ,' do
      expect(subject.bbox).to match_array %w(1 2 4 3)
    end
  end

  describe '#bbox_as_envelope' do
    subject { search_builder.with(bbox: '1,2,4,3') }
    it 'returns the bbox parameter in envelope syntax' do
      expect(subject.bbox_as_envelope).to eq 'ENVELOPE(1.0, 4.0, 3.0, 2.0)'
    end
  end

  describe '#bbox_as_range' do
    subject { search_builder.with(bbox: '1,2,4,3') }
    it 'returns the bbox parameter in rectangle-range syntax' do
      expect(subject.bbox_as_range).to eq '["1 2" TO "4 3"]'
    end
  end
end
