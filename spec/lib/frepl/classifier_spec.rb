require 'spec_helper'

RSpec.describe Frepl::Classifier do
  let(:classifier) { Frepl::Classifier.new }
  describe '#classify' do
    context 'single declaration with assignment' do
      let(:line) { 'integer a' }

      it 'returns a single declaration' do
        expect(classifier.classify(line)).to be_a(Frepl::Declaration)
      end
    end

    context 'single declaration with assignment' do
      let(:line) { 'integer :: a = 1' }

      it 'returns a single declaration' do
        expect(classifier.classify(line)).to be_a(Frepl::Declaration)
      end
    end

    context 'single Fortran 2003 array declaration' do
      let(:line) { 'integer, dimension(3) :: a = [1,2,3]' }

      it 'returns a single declaration' do
        expect(classifier.classify(line)).to be_a(Frepl::Declaration)
      end
    end

    context 'single Fortran oldskool array declaration' do
      let(:line) { 'integer, dimension(3) :: a = /1,2,3/' }

      it 'returns a single declaration' do
        expect(classifier.classify(line)).to be_a(Frepl::Declaration)
      end
    end

    context 'multiple integer declaration' do
      let(:line) { 'real :: a, b, c' }

      it 'returns an multi declaration' do
        expect(classifier.classify(line)).to be_a(Frepl::MultiDeclaration)
      end
    end

    context 'multiple integer declaration with assignment' do
      let(:line) { 'real :: a = 1, b, c=2' }

      it 'returns an multi declaration' do
        expect(classifier.classify(line)).to be_a(Frepl::MultiDeclaration)
      end
    end

    context 'multiple array declaration' do
      let(:line) { 'integer, dimension(3) :: a = [1,2,3], b = [1,2,3]' }

      it 'returns a single declaration' do
        expect(classifier.classify(line)).to be_a(Frepl::MultiDeclaration)
      end
    end
  end
end
