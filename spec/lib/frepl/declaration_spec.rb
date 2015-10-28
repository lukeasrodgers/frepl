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

  context 'character' do
    context 'with len' do
      let(:c) { Frepl::Declaration.new('character(len=4) :: name = "luke"') }
      it 'extracts variable name' do
        expect(c.variable_name).to eq('name')
      end

      it 'has assigned value luke' do
        expect(c.assigned_value).to eq('"luke"')
      end

      it 'has len' do
        expect(c.len).to eq('4')
      end
    end

    context 'without len' do
      let(:c) { Frepl::Declaration.new('character(4) :: name = "luke"') }
      it 'extracts variable name' do
        expect(c.variable_name).to eq('name')
      end

      it 'has assigned value luke' do
        expect(c.assigned_value).to eq('"luke"')
      end

      it 'has len' do
        expect(c.len).to eq('4')
      end
    end

    context 'assignments designed to trick regex' do
      it 'works with equals' do
        d = Frepl::Declaration.new('character(4) :: x = "\'="')
        expect(d.assigned_value).to eq('"\'="')
        expect(d.len).to eq('4')
      end

      it 'works with brackets' do
        d = Frepl::Declaration.new('character(8) :: x = "]s\"')
        expect(d.assigned_value).to eq('"]s\"')
        expect(d.len).to eq('8')
      end

      it 'works with spaces' do
        d = Frepl::Declaration.new('character(len=7) :: x = "len=  f"')
        expect(d.assigned_value).to eq('"len=  f"')
        expect(d.len).to eq('7')
      end
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
