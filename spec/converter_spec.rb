# frozen_string_literal: true

RSpec.describe PostmanPAF::Converter do
  before(:all) do
    @paf_address = { 'postTown' => 'Test Town', 'postcode' => 'AA1 1AA' }
    @paf_address_to_truncate = {
      sub_building_name: 'Long subBuildingName to be truncated to max_line_length',
      building_name: 'Long buildingName to be truncated to max_line_length',
      dependent_thoroughfare_name: 'Long dependentThoroughfareName to be truncated to max_line_length',
      thoroughfare_name: 'Long thoroughfareName to be truncated to max_line_length',
      dependent_locality: 'Long dependentLocality to be truncated to max_line_length',
      post_town: 'Long postTown to be truncated to the max_line_length',
      postcode: 'SA99 1BN',
      country: 'Wales',
      language: 'EN',
      dps: '1A'
    }
  end

  context 'optional max line length argument' do
    it 'will truncate lines 1-5 of a printable address' do
      expected_line_length = rand(1..50)
      printable_address = PostmanPAF.convert(@paf_address_to_truncate, max_line_length: expected_line_length)

      %w[line1 line2 line3 line4 line5].each do |line|
        actual_line_length = printable_address[line].length
        error_message = lambda {
          "expected #{line} length: #{expected_line_length}\n                  got: #{actual_line_length}"
        }

        expect(actual_line_length).to eq(expected_line_length), error_message
      end
    end

    it 'will handle converted lines with nil value' do
      actual_printable_address = PostmanPAF.convert({
                                                      buildingName: '1A',
                                                      thoroughfareName: 'EXAMPLE ROAD',
                                                      postTown: 'EXAMPLE TOWN',
                                                      postcode: 'SA99 1BN',
                                                      dps: '1A',
                                                      language: 'EN',
                                                      country: 'WALES'
                                                    }, max_line_length: 10)
      expected_printable_address = { 'line1' => '1A EXAMPLE',
                                     'line5' => 'EXAMPLE TO',
                                     'postcode' => 'SA99 1BN',
                                     'country' => 'WALES',
                                     'language' => 'EN',
                                     'dps' => '1A' }

      expect(actual_printable_address).to eq(expected_printable_address)
    end
  end

  context 'optional logging argument' do
    it 'will log to STDOUT when set to true' do
      expect { PostmanPAF.convert(@paf_address, logging: true) }.to output.to_stdout_from_any_process
    end

    it 'will not log to STDOUT when missing or set to false' do
      expect { PostmanPAF.convert(@paf_address) }.to_not output.to_stdout_from_any_process
      expect { PostmanPAF.convert(@paf_address, logging: false) }.to_not output.to_stdout_from_any_process
    end
  end
end
