# encoding: utf-8

require 'spec_helper'
require 'ice_nine'

describe IceNine::Freezer::Data, '.deep_freeze' do
  subject { object.deep_freeze(value) }

  let(:object) { described_class }

  context 'with a Data object' do
    let(:klass) { Data.define(:name, :age) }
    let(:value) { klass.new(name: 'John', age: 30) }

    context 'without a circular reference' do
      it_behaves_like 'IceNine::Freezer::Data.deep_freeze'
    end

    context 'with a circular reference' do
      let(:klass) { Data.define(:name, :age, :refs) }
      let(:refs) { [] }
      let(:value) { klass.new(name: 'John', age: 30, refs: refs) }

      before { refs << value }

      it_behaves_like 'IceNine::Freezer::Data.deep_freeze'
    end

    context 'with nested Data objects' do
      let(:address_class) { Data.define(:street, :city) }
      let(:person_class) { Data.define(:name, :address) }
      let(:address) { address_class.new(street: '123 Main St', city: 'Anytown') }
      let(:value) { person_class.new(name: 'Jane', address: address) }

      it_behaves_like 'IceNine::Freezer::Data.deep_freeze'

      it 'deeply freezes nested Data objects' do
        expect(subject.address).to be_frozen
        expect(subject.address.street).to be_frozen
        expect(subject.address.city).to be_frozen
      end
    end

    context 'with mutable values' do
      let(:klass) { Data.define(:items, :metadata) }
      let(:value) { klass.new(items: ['apple', 'banana'], metadata: { count: 2 }) }

      it_behaves_like 'IceNine::Freezer::Data.deep_freeze'

      it 'deeply freezes attribute values' do
        expect(subject.items).to be_frozen
        expect(subject.items.first).to be_frozen
        expect(subject.metadata).to be_frozen
        expect(subject.metadata[:count]).to be_frozen
      end
    end
  end
end
