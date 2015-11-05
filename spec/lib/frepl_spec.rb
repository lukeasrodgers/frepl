require 'spec_helper'

RSpec.describe Frepl do
  let(:frepl) { Frepl::Main.new }
  describe 'functional specs', type: :functional do
    context 'basic program' do
      it 'works' do
        expect(Frepl).to receive(:output).with("           1\n").twice
        file = [
          'integer a',
          'a = 1',
          'write(*,*) a'
        ]
        frepl.run_file(file)
      end
    end

    context 'declaring multiple variables on a single line' do
      it 'works' do
        expect(Frepl).to receive(:output).with("           6\n")
        file = [
          'integer :: a = 2, b = 4',
          'write(*,*) a + b'
        ]
        frepl.run_file(file)
      end
    end

    context 'defining a function' do
      it 'works' do
        expect(Frepl).to receive(:output).with("          12\n")
        file = [
          'integer :: a = 8, b = 4',
            'integer function add(x, y)',
            'integer, intent(in) :: x, y',
            'add = x + y',
          'end function add',
          'write(*,*) add(a, b)'
        ]
        frepl.run_file(file)
      end
    end

    context 'redefining the type of a variable' do
      it 'works' do
        expect(Frepl).to receive(:output).with("           3\n")
        expect(Frepl).to receive(:output).with("   3.40000010    \n")
        file = [
          'integer :: a = 8',
          'a = 3',
          'real :: a = 3.4',
          'write(*,*) a'
        ]
        frepl.run_file(file)
      end
    end

    context 'redefining a scalar to vector' do
      it 'works' do
        expect(Frepl).to receive(:output).with("           3\n")
        expect(Frepl).to receive(:output).with("           1           2\n")
        file = [
          'integer :: a = 8',
          'a = 3',
          'integer, dimension(2) :: a = [1,2]',
          'write(*,*) a'
        ]
        frepl.run_file(file)
      end
    end

    context 'redefining a function' do
      it 'works' do
        expect(Frepl).to receive(:output).with("           1\n")
        file = [
          'integer function m(x, y)',
            'integer, intent(in) :: x, y', 
            'm = x + y',
          'end function m',
          'integer function m(x, y)',
            'integer, intent(in) :: x, y', 
            'm = x - y',
          'end function m',
          'write(*,*) m(3, 2)'
        ]
        frepl.run_file(file)
      end
    end

    context 'changing the kind of a real' do
      it 'works' do
        expect(Frepl).to receive(:output).with(match(/12\.\d{7}\s+/))
        expect(Frepl).to receive(:output).with(match(/12\.\d{15}\s+/))
        file = [
          'real(kind=4) :: a = 3.14',
          'write(*,*) a * 4',
          'real(kind=8) :: a = 3.14',
          'write(*,*) a * 4'
        ]
        frepl.run_file(file)
      end
    end

    context 'redefining a subroutine' do
      it 'works' do
        # TODO shouldn't require this first expectation -- don't do IO
        # unless last(current) execution is WRITE/PRINT or something
        expect(Frepl).to receive(:output).with("")
        expect(Frepl).to receive(:output).with("           1\n")
        file = [
          'integer :: a = 1, b = 1, c = 1',
          'subroutine swap(x, y)',
            'integer, intent(in) :: x', 
            'integer, intent(out) :: y',
            'y = x',
          'end subroutine swap',
          'subroutine swap(x, y, z)',
            'integer, intent(in) :: x', 
            'integer, intent(out) :: y, z',
            'y = x',
            'z = x',
          'end subroutine swap',
          'call swap(a, b, c)',
          'write(*,*) c'
        ]
        frepl.run_file(file)
      end
    end

    context 'echoing a variable value' do
      it 'works' do
        expect(Frepl).to receive(:output).with("           1\n").twice
        file = [
          'integer a',
          'a = 1',
          'a'
        ]
        frepl.run_file(file)
      end
    end

    context 'with an if statement' do
      it 'works' do
        expect(Frepl).to receive(:output).with("           1\n")
        file = [
          'logical :: check = .true.',
          'if (check .EQV. .TRUE.) then',
            'write(*,*) 1',
          'end if'
        ]
        frepl.run_file(file)
      end
    end

    context 'with a do loop' do
      it 'works' do
        expect(Frepl).to receive(:output).with("           1\n           2\n           3\n")
        file = [
          'integer i',
          'do i = 1, 3 ',
            'write(*,*) i',
          'end do'
        ]
        frepl.run_file(file)
      end
    end

    context 'with a derived type' do
      it 'works' do
        expect(Frepl).to receive(:output).with("   3.40000010    \n")
        expect(Frepl).to receive(:output).with("   4.05000019    \n")
        expect(Frepl).to receive(:output).with("   3.40000010       4.05000019    \n")
        file = [
          'type point',
            'real :: x, y',
          'end type point',
          'type (point) p1',
          'p1%x = 3.4',
          'p1%y = 4.05',
          'write(*,*) p1'
        ]
        frepl.run_file(file)
      end
    end

    context 'with multidimensional targetable array and pointers to said array' do
      it 'works' do
        expect(Frepl).to receive(:output).with("   1.00000000       2.00000000       3.00000000       4.00000000    \n")
        expect(Frepl).to receive(:output).with("   1.00000000    \n   3.00000000    \n   2.00000000    \n   4.00000000    \n")
        file = [
          'integer i, j',
          'integer, parameter :: m = 2, n = 2',
          'real, dimension(m,n), target :: A',
          'real, dimension(:), pointer:: row, column',
          'a = reshape(([1,2,3,4]), ([2,2]))',
          'do i = 1, 2',
            'do j = 1, 2',
              'write(*,*) a(i,j)',
            'end do',
          'end do'
        ]
        frepl.run_file(file)
      end
    end

    context 'with deeply nested if statements' do
      it 'works' do
        expect(Frepl).to receive(:output).with("           4\n")
        file = [
          'if (1 < 2) then',
            'if (2 < 3) then',
              'if (3 < 4) then',
                'write(*,*) 4',
              'endif',
            'endif',
          'endif'
        ]
        frepl.run_file(file)
      end
    end
  end
end
