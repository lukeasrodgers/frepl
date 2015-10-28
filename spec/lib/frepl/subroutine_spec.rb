require 'spec_helper'

RSpec.describe Frepl::Subroutine do
  let(:simple_subroutine) do
    Frepl::Subroutine.new([
          'subroutine swap(x, y)',
            'integer, intent(in) :: x', 
            'integer, intent(out) :: y',
            'y = x',
          'end subroutine swap'
        ])
  end
  context 'simple subroutine' do
    it 'extracts subroutine name' do
      expect(simple_subroutine.name).to eq('swap')
    end
  end

  describe '#==' do
    context 'when other is a `Subroutine`' do
      let(:other_same) do
        Frepl::Subroutine.new([
          'subroutine swap(x, y)',
            'integer, intent(in) :: x', 
            'integer, intent(out) :: y',
            'y = x',
          'end subroutine swap'
          ])
      end

      let(:other_diff) do
        Frepl::Subroutine.new([
          'subroutine swip(x, y)',
            'integer, intent(in) :: x', 
            'integer, intent(out) :: y',
            'y = x',
          ])
      end

      it 'compares by subroutine name' do
        expect(simple_subroutine).to eq(other_same)
        expect(simple_subroutine).not_to eq(other_diff)
      end
    end
  end
end
