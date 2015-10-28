require 'spec_helper'

RSpec.describe Frepl::Function do
  let(:simple_function) do
    Frepl::Function.new([
        'integer function m(x, y)',
          'integer, intent(in) :: x, y', 
          'm = x + y',
        'end function m'])
  end
  context 'simple function' do
    it 'extracts function name' do
      expect(simple_function.name).to eq('m')
    end
  end

  describe '#==' do

    context 'when other is a `Function`' do

      let(:other_same) do
        Frepl::Function.new([
            'integer function m(x, y)',
              'integer, intent(in) :: x, y', 
              'm = x * y',
            'end function m'])
      end

      let(:other_diff) do
        Frepl::Function.new([
            'integer function n(x, y)',
              'integer, intent(in) :: x, y', 
              'm = x + y',
            'end function m'])
      end

      it 'compares by function name' do
        expect(simple_function).to eq(other_same)
        expect(simple_function).not_to eq(other_diff)
      end
    end
  end
end
