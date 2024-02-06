# frozen_string_literal: true

RSpec.describe PostmanPAF::Validator do
  it 'will validate newer Ruby Hash syntax' do
    expect(PostmanPAF::Validator.new(input: { post_town: 'Test Town', postcode: 'AA1 1AA' }).validate).to eq(nil)
    expect(PostmanPAF::Validator.new(input: [{ post_town: 'Test Town', postcode: 'AA1 1AA' }]).validate).to eq(nil)
    expect(PostmanPAF::Validator.new(input: { 'postTown' => 'Test Town', 'postcode' => 'AA1 1AA' }).validate).to eq(nil)
    expect(PostmanPAF::Validator.new(input: [{ 'postTown' => 'Test Town', 'postcode' => 'AA1 1AA' }]).validate).to eq(nil)
    expect(PostmanPAF::Validator.new(input: { postTown: 'Test Town', postcode: 'AA1 1AA' }).validate).to eq(nil)
    expect(PostmanPAF::Validator.new(input: [{ postTown: 'Test Town', postcode: 'AA1 1AA' }]).validate).to eq(nil)
  end

  it 'will error on wrong input data type' do
    expect { PostmanPAF::Validator.new(input: nil).validate }.to raise_error(ArgumentError, INVALID_INPUT_TYPE_MSG)
    expect { PostmanPAF::Validator.new(input: '').validate }.to raise_error(ArgumentError, INVALID_INPUT_TYPE_MSG)
    expect { PostmanPAF::Validator.new(input: 1234).validate }.to raise_error(ArgumentError, INVALID_INPUT_TYPE_MSG)
    expect { PostmanPAF::Validator.new(input: true).validate }.to raise_error(ArgumentError, INVALID_INPUT_TYPE_MSG)
    expect { PostmanPAF::Validator.new(input: :address).validate }.to raise_error(ArgumentError, INVALID_INPUT_TYPE_MSG)
  end

  it 'will error on input of empty Hash' do
    expect { PostmanPAF::Validator.new(input: {}).validate }.to raise_error(ArgumentError, MISSING_REQUIRED_HASH_KEYS_MSG)
  end

  it 'will error on input of empty Array' do
    expect { PostmanPAF::Validator.new(input: []).validate }.to raise_error(ArgumentError, INVALID_INPUT_TYPE_MSG)
  end

  it "will error on input of Hash with 'postTown' or 'postcode' key missing" do
    expect { PostmanPAF::Validator.new(input: { post_town: 'Valid key', place_name: 'Invalid key' }).validate }
      .to raise_error(ArgumentError, MISSING_REQUIRED_HASH_KEYS_MSG)
    expect { PostmanPAF::Validator.new(input: { postTown: 'Valid key', area: 'Invalid key' }).validate }
      .to raise_error(ArgumentError, MISSING_REQUIRED_HASH_KEYS_MSG)
    expect { PostmanPAF::Validator.new(input: { city: 'Invalid key', postcode: 'Valid key' }).validate }
      .to raise_error(ArgumentError, MISSING_REQUIRED_HASH_KEYS_MSG)
  end

  it 'will error on input of Array of elements that are not Hashes' do
    input_array = [{ 'postTown' => 'Half valid Hash', 'postcode' => 'Now fully valid Hash' }, 'Invalid String']

    expect { PostmanPAF::Validator.new(input: input_array).validate }.to raise_error(ArgumentError, INVALID_INPUT_ARRAY_MSG)
  end

  it 'will error on input of Array of Hashes missing required keys' do
    input_array1 = [{ postTown: 'Valid key', postcode: 'Also valid key' }, { postTown: 'Valid key', 'place': 'Invalid key' }]
    input_array2 = [{ region: 'Invalid key', postcode: 'Valid key' }, { postTown: 'Valid key', postcode: 'Also valid key' }]

    expect { PostmanPAF::Validator.new(input: input_array1).validate }.to raise_error(ArgumentError, MISSING_REQUIRED_HASH_KEYS_MSG)
    expect { PostmanPAF::Validator.new(input: input_array2).validate }.to raise_error(ArgumentError, MISSING_REQUIRED_HASH_KEYS_MSG)
  end
end
