# frozen_string_literal: true

RSpec.describe PostmanPAF do
  before(:all) do
    @addresses = JSON.parse(File.read('spec/fixtures/addresses.json'))
    @rules = @addresses.map(&:keys).flatten
  end

  it 'has a version number' do
    expect(PostmanPAF::VERSION).not_to be nil
  end

  context 'convert method' do
    it 'converts a single PAF address to a printable format for an envelope or address label' do
      @rules.each do |rule|
        addresses_for_rule = @addresses.map { |address_data| address_data[rule].values }.flatten

        addresses_for_rule.each do |paf_and_print_address|
          paf_address = paf_and_print_address[PAF_ADDRESS]
          expected_printable_address = paf_and_print_address[PRINTABLE_ADDRESS]

          # String comparison asserts Hash keys and values are in expected order.
          expect(PostmanPAF.convert(paf_address).to_s).to eq(expected_printable_address.to_s)
        end
      end
    end

    it 'converts multiple PAF addresses to printable formats for envelopes or address labels' do
      paf_addresses = @addresses.map { |address_data| address_data.deep_find(key: PAF_ADDRESS) }.flatten
      expected_printable_addresses = @addresses.map { |address_data| address_data.deep_find(key: PRINTABLE_ADDRESS) }.flatten

      # String comparison asserts Hash keys and values of each element are in expected order.
      expect(PostmanPAF.convert(paf_addresses).to_s).to eq(expected_printable_addresses.to_s)
    end
  end
end
