require 'spec_helper'

describe Hashozaur::CamelBackKeysHash do
  describe 'with snake keys' do
    describe 'which are JSON-style strings' do
      describe 'in the simplest case' do
        let(:hash) do
          { 'first_key' => 'fooBar' }
        end

        describe 'non-destructive conversion to camelBack' do
          let(:camelized) { described_class.convert(hash) }
          let(:key) { camelized.keys.first }
          let(:value) { camelized.values.first }

          it 'leaves the key as a string' do
            expect(key).to be_a String
          end

          it 'camelizes the key' do
            expect(key).to eq('firstKey')
          end

          it 'leaves the value untouched' do
            expect(value).to eq('fooBar')
          end

          it 'leaves the original hash untouched' do
            expect { camelized }.not_to change { hash.keys.first }
          end
        end
      end

      describe 'containing an array of other hashes' do
        let(:hash) do
          {
            'apple_type' => 'Granny Smith',
            'vegetable_types' => [
              { 'potato_type' => 'Golden delicious' },
              { 'other_tuber_type' => 'peanut' },
              { 'peanut_names_and_spouses' => [
                { 'bill_the_peanut' => 'sally_peanut' },
                { 'sammy_the_peanut' => 'jill_peanut' }
              ] }
            ] }
        end

        describe 'non-destructive conversion to camelBack' do
          let(:camelized) { described_class.convert(hash) }

          it 'recursively camelizes the keys on the top level of the hash' do
            expect(camelized.keys).to eq(%w(appleType vegetableTypes))
          end

          it 'leaves the values on the top level alone' do
            expect(camelized['appleType']).to eq('Granny Smith')
          end

          it 'converts second-level keys' do
            expect(camelized['vegetableTypes'].first).to have_key('potatoType')
          end

          it 'leaves second-level values alone' do
            expect(camelized['vegetableTypes'].first).to have_value('Golden delicious')
          end

          it 'converts third-level keys' do
            expect(camelized['vegetableTypes'].last['peanutNamesAndSpouses'].first).to have_key('billThePeanut')
            expect(camelized['vegetableTypes'].last['peanutNamesAndSpouses'].last).to have_key('sammyThePeanut')
          end

          it 'leaves third-level values alone' do
            expect(camelized['vegetableTypes'].last['peanutNamesAndSpouses'].first['billThePeanut']).to eq('sally_peanut')
            expect(camelized['vegetableTypes'].last['peanutNamesAndSpouses'].last['sammyThePeanut']).to eq('jill_peanut')
          end
        end
      end
    end
  end

  describe 'strings with spaces in them' do
    let(:hash) do
      { 'With Spaces' => 'FooBar' }
    end

    describe 'to_camelback_keys' do
      it "doesn't get camelized" do
        expect(
          described_class.convert(hash)
        ).to eq(hash)
      end
    end
  end
end
