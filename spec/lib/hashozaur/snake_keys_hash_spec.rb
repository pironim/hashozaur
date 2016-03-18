require 'spec_helper'

describe Hashozaur::SnakeKeysHash do
  describe 'with camelBack keys' do
    describe 'which are JSON-style strings' do
      describe 'in the simplest case' do
        let(:hash) do
          { 'firstKey' => 'fooBar' }
        end

        describe 'non-destructive snakification' do
          let(:snaked) { described_class.convert(hash) }

          it 'snakifies the key' do
            expect(snaked.keys.first).to eq('first_key')
          end

          it 'leaves the key as a string' do
            expect(snaked.keys.first).to eq('first_key')
          end

          it 'leaves the value untouched' do
            expect(snaked.values.first).to eq('fooBar')
          end

          it 'leaves the original hash untouched' do
            expect(hash.keys.first).to eq('firstKey')
          end
        end
      end

      describe 'containing an array of other hashes' do
        let(:hash) do
          {
            'appleType' => 'Granny Smith',
            'vegetableTypes' => [
              { 'potatoType' => 'Golden delicious' },
              { 'otherTuberType' => 'peanut' },
              { 'peanutNamesAndSpouses' => [
                { 'billThePeanut' => 'sallyPeanut' },
                { 'sammyThePeanut' => 'jillPeanut' }
              ] }
            ] }
        end

        describe 'non-destructive snakification' do
          let(:snaked) { described_class.convert(hash) }

          it 'recursively snakifies the keys on the top level of the hash' do
            expect(snaked.keys).to eq(%w(apple_type vegetable_types))
          end

          it 'leaves the values on the top level alone' do
            expect(snaked['apple_type']).to eq('Granny Smith')
          end

          it 'converts second-level keys' do
            expect(snaked['vegetable_types'].first).to have_key('potato_type')
          end

          it 'leaves second-level values alone' do
            expect(snaked['vegetable_types'].first).to have_value('Golden delicious')
          end

          it 'converts third-level keys' do
            expect(
              snaked['vegetable_types'].last['peanut_names_and_spouses'].first
            ).to have_key('bill_the_peanut')
            expect(
              snaked['vegetable_types'].last['peanut_names_and_spouses'].last
            ).to have_key('sammy_the_peanut')
          end

          it 'leaves third-level values alone' do
            expect(
              snaked['vegetable_types'].last['peanut_names_and_spouses'].first['bill_the_peanut']
            ).to eq('sallyPeanut')
            expect(
              snaked['vegetable_types'].last['peanut_names_and_spouses'].last['sammy_the_peanut']
            ).to eq('jillPeanut')
          end
        end
      end
    end

    describe 'which are symbols' do
      describe 'in the simplest case' do
        let(:hash) do
          { firstKey: 'fooBar' }
        end

        describe 'non-destructive snakification' do
          let(:snaked) { described_class.convert(hash) }

          it 'snakifies the key' do
            expect(snaked.keys.first).to eq(:first_key)
          end

          it 'leaves the key as a symbol' do
            expect(snaked.keys.first).to eq(:first_key)
          end

          it 'leaves the value untouched' do
            expect(snaked.values.first).to eq('fooBar')
          end

          it 'leaves the original hash untouched' do
            expect(hash.keys.first).to eq(:firstKey)
          end
        end
      end

      describe 'containing an array of other hashes' do
        let(:hash) do
          {
            appleType: 'Granny Smith',
            vegetableTypes: [
              { potatoType: 'Golden delicious' },
              { otherTuberType: 'peanut' },
              { peanutNamesAndSpouses: [
                { billThePeanut: 'sallyPeanut' },
                { sammyThePeanut: 'jillPeanut' }
              ] }
            ] }
        end

        describe 'non-destructive snakification' do
          let(:snaked) { described_class.convert(hash) }

          it 'recursively snakifies the keys on the top level of the hash' do
            expect(snaked.keys).to eq([:apple_type, :vegetable_types])
          end

          it 'leaves the values on the top level alone' do
            expect(snaked[:apple_type]).to eq('Granny Smith')
          end

          it 'converts second-level keys' do
            expect(snaked[:vegetable_types].first).to have_key(:potato_type)
          end

          it 'leaves second-level values alone' do
            expect(snaked[:vegetable_types].first).to have_value('Golden delicious')
          end

          it 'converts third-level keys' do
            expect(
              snaked[:vegetable_types].last[:peanut_names_and_spouses].first
            ).to have_key(:bill_the_peanut)
            expect(
              snaked[:vegetable_types].last[:peanut_names_and_spouses].last
            ).to have_key(:sammy_the_peanut)
          end

          it 'leaves third-level values alone' do
            expect(
              snaked[:vegetable_types].last[:peanut_names_and_spouses].first[:bill_the_peanut]
            ).to eq('sallyPeanut')
            expect(
              snaked[:vegetable_types].last[:peanut_names_and_spouses].last[:sammy_the_peanut]
            ).to eq('jillPeanut')
          end
        end
      end
    end
  end

  describe 'strings with spaces in them' do
    let(:hash) do
      { 'With Spaces' => 'FooBar' }
    end
    let(:snaked) { described_class.convert(hash) }

    it "doesn't get snaked, although it does get downcased" do
      expect(snaked.keys).to include('with spaces')
    end
  end
end
