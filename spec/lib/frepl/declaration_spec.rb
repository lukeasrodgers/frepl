require 'spec_helper'

RSpec.describe Frepl::Declaration do
  context 'simple declaration' do
    let(:d) { Frepl::Declaration.new('integer a') }

    it 'extracts variable name' do
      expect(d.variable_name).to eq('a')
    end

    it 'returns nil value' do
      expect(d.assigned_value).to eq(nil)
    end

    it 'extracts type' do
      expect(d.type).to eq('integer')
    end
  end

  context 'simple, double-colon' do
    let(:d) { Frepl::Declaration.new('real :: a') }

    it 'extracts variable name' do
      expect(d.variable_name).to eq('a')
    end

    it 'has nil assigned value' do
      expect(d.assigned_value).to be_nil
    end

    it 'extracts type' do
      expect(d.type).to eq('real')
    end
  end

  context 'double-colon plus assignmentj' do
    let(:d) { Frepl::Declaration.new('integer :: a = 3') }

    it 'extracts variable name' do
      expect(d.variable_name).to eq('a')
    end

    it 'has assigned value 3' do
      expect(d.assigned_value).to eq('3')
    end
  end

  context 'dimension plus assignment' do
    let(:d) { Frepl::Declaration.new('integer, dimension(3) :: a = [1,2,3]') }

    it 'extracts variable name' do
      expect(d.variable_name).to eq('a')
    end

    it 'has assigned value [1,2,3]' do
      expect(d.assigned_value).to eq('[1,2,3]')
    end
  end

  context 'real with kind' do
    let(:d) { Frepl::Declaration.new('real(kind=4) :: a = 2.3') }

    it 'extracts variable name' do
      expect(d.variable_name).to eq('a')
    end

    it 'has assigned value [1,2,3]' do
      expect(d.assigned_value).to eq('2.3')
    end

    it 'has kind' do
      expect(d.kind).to eq('4')
    end
  end

  describe '#==' do
    let(:d) { Frepl::Declaration.new('integer a') }

    context 'when other is a `Declaration`' do
      let(:other_same) { Frepl::Declaration.new('real a') }
      let(:other_diff) { Frepl::Declaration.new('integer b') }

      it 'compares by variable name' do
        expect(d).to eq(other_same)
        expect(d).not_to eq(other_diff)
      end
    end
  end
end
