# frozen_string_literal: true

RSpec.describe PostmanPAF::Exceptions::WhichException do
  it 'has a Boolean method for Exception I' do
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_last?('1')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_last?('2-3')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_last?('4/5')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_last?('6 Example House 7')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_last?('Example House')).to be false
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_last?('8 Example House')).to be false
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_last?('Example House 9')).to be false
  end

  it 'has a Boolean method for Exception II' do
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_penultimate_and_alpha_as_last?('1A')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_penultimate_and_alpha_as_last?('23B')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_penultimate_and_alpha_as_last?('4 Example House 5C')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_penultimate_and_alpha_as_last?('01d')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_penultimate_and_alpha_as_last?('Example House')).to be false
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_penultimate_and_alpha_as_last?('67 E8')).to be false
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_as_first_and_penultimate_and_alpha_as_last?('9')).to be false
  end

  it 'has a Boolean method for Exception III' do
    expect(PostmanPAF::Exceptions::WhichException.contains_one_alpha_character?('A')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_one_alpha_character?('z')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_one_alpha_character?('1')).to be false
    expect(PostmanPAF::Exceptions::WhichException.contains_one_alpha_character?('')).to be false
  end

  it 'has a Boolean method for Exception to Rule' do
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_between_0_and_9999?('Example House 0')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_between_0_and_9999?('Example House 9999')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_between_0_and_9999?('Example House 10000')).to be false
    expect(PostmanPAF::Exceptions::WhichException.contains_digit_between_0_and_9999?('14 Example House')).to be false
  end

  it 'has a Boolean method for Exception IV' do
    expect(PostmanPAF::Exceptions::WhichException.contains_address_keyword?('UNIT 1')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_address_keyword?('BLOCKS 2-3')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_address_keyword?('FLAT 45A')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_address_keyword?('shops 6-7')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_address_keyword?('STALLS')).to be false
    expect(PostmanPAF::Exceptions::WhichException.contains_address_keyword?('example shops')).to be false
  end

  it 'has a Boolean method for Exception V' do
    expect(PostmanPAF::Exceptions::WhichException.contains_digits_with_decimals_or_forward_slashes?('Example 1.2')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_digits_with_decimals_or_forward_slashes?('Example 85/1')).to be true
    expect(PostmanPAF::Exceptions::WhichException.contains_digits_with_decimals_or_forward_slashes?('Example 7:8')).to be false
    expect(PostmanPAF::Exceptions::WhichException.contains_digits_with_decimals_or_forward_slashes?('Example 4.5A')).to be false
  end
end
