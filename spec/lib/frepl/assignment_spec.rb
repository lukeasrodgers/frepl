require 'spec_helper'

RSpec.describe Frepl::Assignment do
  let(:a) { Frepl::Assignment.new('a = 2') }

  describe '#variable_name' do
    subject { a.variable_name }

    it 'extracts variable name from line' do
      expect(subject).to eql('a')
    end

    context 'with no spacing' do
      let(:a) { Frepl::Assignment.new('a=2') }

      it 'extracts variable name from line' do
        expect(subject).to eql('a')
      end
    end

    context 'with array' do
      let(:a) { Frepl::Assignment.new('foobar = [1,2,3,4]') }

      it 'extracts variable name from line' do
        expect(subject).to eql('foobar')
      end
    end
  end

  describe '#assigned_value' do
    subject { a.assigned_value }

    it 'extracts value' do
      expect(subject).to eql('2')
    end

    context 'with no spacing' do
      let(:a) { Frepl::Assignment.new('a=2') }

      it 'extracts variable name from line' do
        expect(subject).to eql('2')
      end
    end

    context 'with array' do
      let(:a) { Frepl::Assignment.new('foobar = [1,2,3,4]') }

      it 'extracts variable name from line' do
        expect(subject).to eql('[1,2,3,4]')
      end
    end
  end
end
