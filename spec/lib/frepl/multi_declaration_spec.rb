require 'spec_helper'

RSpec.describe Frepl::MultiDeclaration do
  context 'multi declaration' do
    let(:d) { Frepl::MultiDeclaration.new('integer a, b') }

    it 'extracts variable names' do
      expect(d.variable_names).to eq(['a', 'b'])
    end
  end

  context 'multi declaration with assignment' do
    let(:d) { Frepl::MultiDeclaration.new('integer :: a = 1, b = 2') }

    it 'extracts variable names' do
      expect(d.variable_names).to eq(['a', 'b'])
    end

    it 'generates declarations with the right data' do
      expect(d.declarations.first.variable_name).to eq('a')
      expect(d.declarations.first.assigned_value).to eq('1')
    end
  end

  context 'multiple F2003 array declarations' do
    let(:d) { Frepl::MultiDeclaration.new('integer, dimension(2) :: a = [1,2], b = [2,3]') }

    it 'extracts variable names' do
      expect(d.variable_names).to eq(['a', 'b'])
    end
  end

  context 'declarations without assignments, and with' do
    let(:d) { Frepl::MultiDeclaration.new('integer, dimension(2) :: a, b = [2,3]') }

    it 'extracts variable names' do
      expect(d.variable_names).to eq(['a', 'b'])
    end

    it 'correctly generates declaration types' do
      expect(d.declarations.map(&:type)).to eq(['integer', 'integer'])
    end

    it 'correctly generates declaration assignments' do
      d1, d2 = d.declarations
      expect(d1.variable_name).to eq('a')
      expect(d1.assigned_value).to be_nil
      expect(d1.output).to eq("integer, dimension(2) :: a\n")
      expect(d2.variable_name).to eq('b')
      expect(d2.assigned_value).to eq('[2,3]')
      expect(d2.output).to eq("integer, dimension(2) :: b=[2,3]\n")
    end
  end

  context 'declarations with assignments, and without' do
    let(:d) { Frepl::MultiDeclaration.new('integer :: a = 1, b, c') }

    it 'extracts variable names' do
      expect(d.variable_names).to eq(['a', 'b', 'c'])
    end

    it 'correctly generates declaration types' do
      expect(d.declarations.map(&:type)).to eq(['integer', 'integer', 'integer'])
    end

    it 'correctly generates declaration assignments' do
      d1, d2, d3 = d.declarations
      expect(d1.variable_name).to eq('a')
      expect(d1.assigned_value).to eq('1')
      expect(d1.output).to eq("integer :: a=1\n")
      expect(d2.variable_name).to eq('b')
      expect(d2.assigned_value).to be_nil
      expect(d2.output).to eq("integer :: b\n")
      expect(d3.variable_name).to eq('c')
      expect(d3.assigned_value).to be_nil
      expect(d3.output).to eq("integer :: c\n")
    end
  end
end
