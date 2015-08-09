require 'cuboid'
require 'rspec'
require 'rspec/collection_matchers'

describe Cuboid do
  subject { Cuboid.new(origin: [0, 0, 0], width: 5, length: 5, height: 5) }
  describe :move_to! do
    it 'is expected to change the cuboid in place' do
      expect(subject.move_to!(1, 2, 3)).to be subject
      expect(subject.origin).to eq Coordinate.new(1, 2, 3)
    end
  end

  describe :move_to do
    it 'is expected to return a new cuboid' do
      expect(subject.move_to(1, 2, 3)).to_not be subject
      expect(subject.move_to(1, 2, 3)).to be_a Cuboid
    end
    it { expect(subject.move_to(1, 2, 3).origin).to eq Coordinate.new(1, 2, 3) }
  end

  describe :vertices do
    it { expect(subject.vertices).to be_an Array }
    it { expect(subject.vertices).to have(8).coordinates }
  end

  describe :intersects? do
    context 'with 100% overlap (duplicate cuboids)' do
      let(:other_cuboid) { subject.dup }
      it { expect(subject.intersects?(other_cuboid)).to be_truthy }
    end

    context 'with arbitrary overlap' do
      let(:other_cuboid) { Cuboid.new(origin: [3, 2, 4], width: 2, height: 4, length: 3) }
      it { expect(subject.intersects?(other_cuboid)).to be_truthy }
    end

    context 'with no overlap' do
      let(:other_cuboid) { Cuboid.new(origin: [6, 6, 6], width: 5, height: 4, length: 3) }

      it { expect(subject.intersects?(other_cuboid)).to be_falsey }
    end

    # This covers the case where 2 edges, faces, or vertexes may touch, but not
    # overlap.
    # These are not true 3D intersections, and as such should not count
    # as such
    context 'when touching' do
      let(:other_cuboid) { Cuboid.new(origin: [5, 5, 5], width: 5, height: 4, length: 3) }

      it { expect(subject.intersects?(other_cuboid)).to be_falsey }
    end
  end
end

describe Coordinate do
  subject { Coordinate.new(1, 2, 3) }

  describe :== do
    context 'with equal coords' do
      let(:other_coords) { subject.dup }
      it { is_expected.to eql(other_coords) }
    end

    context 'with unequal coords' do
      let(:other_coords) { Coordinate.new(4, 5, 6) }
      it { is_expected.to_not eql(other_coords) }
    end
  end

  describe :to_s do
    it { expect(subject.to_s).to eql '(1, 2, 3)' }
  end

  describe :to_a do
    it { expect(subject.to_a).to be_an Array }
    it { expect(subject.to_a).to match_array [1, 2, 3] }
  end
end

describe Line do
  subject { Line.new(0, 15) }

  describe :intersect? do
    context 'with subsegment' do
      let(:other_line) { Line.new(5, 10) }
      it { is_expected.to be_intersect(other_line) }
    end

    context 'with beginning overlap' do
      let(:other_line) { Line.new(-5, 5) }
      it { is_expected.to be_intersect(other_line) }
    end

    context 'with end overlap' do
      let(:other_line) { Line.new(10, 20) }
      it { is_expected.to be_intersect(other_line) }
    end

    context 'with shared beginning point' do
      let(:other_line) { Line.new(-10, 0) }
      it { is_expected.to_not be_intersect(other_line) }
    end

    context 'with shared end point' do
      let(:other_line) { Line.new(15, 30) }
      it { is_expected.to_not be_intersect(other_line) }
    end
  end
end
