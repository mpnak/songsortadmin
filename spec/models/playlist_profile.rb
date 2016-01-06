require 'rails_helper'

describe PlaylistProfile do

  describe TrackWeight::Weight do

    describe "#combine_weights" do
      it "should produce a number between 0 and 1" do
        expect(TrackWeight::Weight.combine_weights([0.5, 0.5], [0.5, 0.5])).to eq 0.5
        expect(TrackWeight::Weight.combine_weights([0.0, 1.0], [10, 1])).to be < 0.5
        expect(TrackWeight::Weight.combine_weights([0.0, 1.0], [0.4, 0.6])).to be > 0.5
      end

      it "should raise an argument error when a value is not 0 - 1" do
        expect {
          TrackWeight::Weight.combine_weights([2.0, 0.5], [0.5, 0.5])
        }.to raise_error(ArgumentError)
      end
    end

    describe "#normalize" do
      it "should yield 1.0 for an exact hit" do
        expect(TrackWeight::Weight.normalize(5, 5, 5, 20)).to eq 1.0
        expect(TrackWeight::Weight.normalize(0.5, 0.5, 0, 1)).to eq 1.0
      end

      it "should yield 0.0 for a complete miss" do
        expect(TrackWeight::Weight.normalize(5, 20, 5, 20)).to eq 0.0
        expect(TrackWeight::Weight.normalize(0, 1, 0, 1)).to eq 0.0
      end
    end

    describe "#normalize_with_limits" do
      it "should yield 1.0 for an exact hit" do
        expect(TrackWeight::Weight.normalize_with_limits(5, 5, 5, 20, 5, 20)).to eq 1.0
        expect(TrackWeight::Weight.normalize_with_limits(20, 20, 5, 20, 5, 20)).to eq 1.0
      end

      it "should yield 0.0 when limits are exceeded" do
        expect(TrackWeight::Weight.normalize_with_limits(5, 5, 5, 20, 6, 19)).to eq 0.0
        expect(TrackWeight::Weight.normalize_with_limits(20, 20, 5, 20, 6, 19)).to eq 0.0
      end
    end

    describe "#random_calibrated_weight" do
      it "is deterministic when sensitivity is set to 1" do
        value1 = TrackWeight::Weight.random_calibrated_weight(0.5, 1.0)
        value2 = TrackWeight::Weight.random_calibrated_weight(0.5, 1.0)
        expect(value1).to eq value2
      end

      it "is random when sensitivity us set to 0" do
        value1 = TrackWeight::Weight.random_calibrated_weight(0.5, 0)
        value2 = TrackWeight::Weight.random_calibrated_weight(0.5, 0)
        expect(value1).not_to eq value2
      end

      it "finds the mid point when sensitivity us 0.5" do
        expect(TrackWeight::Weight.random_calibrated_weight(0.0, 0.5, 1)).to eq 0.5
      end

    end
  end
end
