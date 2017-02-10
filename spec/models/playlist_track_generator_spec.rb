require 'rails_helper'

describe PlaylistTrackGenerator do
  subject { PlaylistTrackGenerator }

  describe '#generate' do
    it 'should generate some tracks' do
      station = FactoryGirl.create :station

      subject.generate(tracks: station.tracks)
    end
  end

  describe '#combine_score' do
    it 'should produce a number between 0 and 1' do
      expect(
        subject.combine_scores(values: [0.5, 0.5], factors: [0.5, 0.5])
      ).to eq 0.5
      expect(
        subject.combine_scores(values: [0.0, 1.0], factors: [10, 1])
      ).to be < 0.5
      expect(
        subject.combine_scores(values: [0.0, 1.0], factors: [0.4, 0.6])
      ).to be > 0.5
    end

    it 'should raise an argument error when a value is not 0 - 1' do
      expect do
        subject.combine_scores(values: [2.0, 0.5], factors: [0.5, 0.5])
      end.to raise_error(ArgumentError)
    end
  end

  describe '#normalize_score' do
    it 'should yield 1.0 for an exact hit' do
      expect(
        subject.normalized_score(
          value: 5,
          target: 5,
          global_min: 5,
          global_max: 20
        )
      ).to eq 1.0

      expect(
        subject.normalized_score(
          value: 0.5,
          target: 0.5,
          global_min: 0,
          global_max: 1
        )
      ).to eq 1.0
    end

    it 'should yield 0.0 for a complete miss' do
      expect(
        subject.normalized_score(
          value: 5,
          target: 20,
          global_min: 5,
          global_max: 20
        )
      ).to eq 0.0

      expect(
        subject.normalized_score(
          value: 0,
          target: 1,
          global_min: 0,
          global_max: 1
        )
      ).to eq 0.0
    end
  end

  describe '#random_calibrated_score' do
    it 'is deterministic when radmonness is set to 0' do
      value1 = subject.random_calibrated_score(value: 0.5, randomness: 0)
      value2 = subject.random_calibrated_score(value: 0.5, randomness: 0)
      expect(value1).to eq value2
    end

    it 'is random when randomness us set to non-zero' do
      value1 = subject.random_calibrated_score(value: 0.5, randomness: 0.3)
      value2 = subject.random_calibrated_score(value: 0.5, randomness: 0.3)
      expect(value1).not_to eq value2
    end

    it 'finds the mid point when randomness is 0.5' do
      expect(
        subject.random_calibrated_score(
          value: 0.0,
          randomness: 0.5,
          random_number: 1
        )
      ).to eq 0.5
    end
  end
end
