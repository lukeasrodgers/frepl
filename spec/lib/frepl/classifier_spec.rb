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

    context 'single real kind declaration with assignment' do
      let(:line) { 'real(kind=4) :: a = 1.0' }

      it 'returns a single declaration' do
        expect(classifier.classify(line)).to be_a(Frepl::Declaration)
      end
    end

    context 'single character declaration' do
      let(:line) { 'character(len=4) name' }

      it 'returns a single declaration' do
        expect(classifier.classify(line)).to be_a(Frepl::Declaration)
      end
    end

    context 'single character declaration with assignment' do
      let(:line) { 'character(len=4) :: name = "john"' }

      it 'returns a single declaration' do
        expect(classifier.classify(line)).to be_a(Frepl::Declaration)
      end
    end

    context 'single character declaration with assignment, without len' do
      let(:line) { 'character(4) :: name = "john"' }

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

    context 'lone variable name' do
      let(:line) { 'foobar' }

      it 'returns a standalone variable' do
        expect(classifier.classify(line)).to be_a(Frepl::StandaloneVariable)
      end
    end
  end
end
