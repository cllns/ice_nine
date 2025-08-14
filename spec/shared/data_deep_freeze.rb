# encoding: utf-8

shared_examples 'IceNine::Freezer::Data.deep_freeze' do
  it 'returns the object' do
    should be(value)
  end

  it 'keeps the object frozen' do
    expect(subject).to be_frozen
  end

  it 'freezes each attribute value' do
    subject.to_h.each_value do |attribute_value|
      expect(attribute_value).to be_frozen
    end
  end
end
