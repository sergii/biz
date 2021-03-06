RSpec.describe Biz::Timeline::Forward do
  subject(:timeline) { described_class.new(forward_periods) }

  describe '#until' do
    context 'when the terminus has second precision' do
      let(:terminus) { Time.utc(2006, 1, 1, 0, 1) }

      it 'returns a period with second precision' do
        expect(timeline.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(Time.utc(2006), Time.utc(2006, 1, 1, 0, 1))
        ]
      end
    end

    context 'when the terminus is before the first period' do
      let(:terminus) { Time.utc(2005) }

      it 'returns no periods' do
        expect(timeline.until(terminus).to_a).to eq []
      end
    end

    context 'when the terminus is between periods' do
      let(:terminus) { Time.utc(2007, 3) }

      it 'returns the proper periods' do
        expect(timeline.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(Time.utc(2006), Time.utc(2006, 2)),
          Biz::TimeSegment.new(Time.utc(2007), Time.utc(2007, 2))
        ]
      end
    end

    context 'when the terminus is at the beginning of a period' do
      let(:terminus) { Time.utc(2008) }

      it 'returns the proper periods' do
        expect(timeline.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(Time.utc(2006), Time.utc(2006, 2)),
          Biz::TimeSegment.new(Time.utc(2007), Time.utc(2007, 2))
        ]
      end
    end

    context 'when the terminus at the beginning of the first period' do
      let(:terminus) { Time.utc(2006) }

      it 'returns no periods' do
        expect(timeline.until(terminus).to_a).to eq []
      end
    end

    context 'when the terminus is in the middle of a period' do
      let(:terminus) { Time.utc(2007, 1, 15) }

      it 'returns the proper periods' do
        expect(timeline.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(Time.utc(2006), Time.utc(2006, 2)),
          Biz::TimeSegment.new(Time.utc(2007), Time.utc(2007, 1, 15)
          )
        ]
      end
    end

    context 'when the terminus is at the end of a period' do
      let(:terminus) { Time.utc(2007, 2) }

      it 'returns the proper periods' do
        expect(timeline.until(terminus).to_a).to eq [
          Biz::TimeSegment.new(Time.utc(2006), Time.utc(2006, 2)),
          Biz::TimeSegment.new(Time.utc(2007), Time.utc(2007, 2))
        ]
      end
    end
  end

  describe '#for' do
    context 'when the duration has second precision' do
      let(:duration) { Biz::Duration.seconds(2) }

      it 'returns a period with second precision' do
        expect(timeline.for(duration).to_a).to eq [
          Biz::TimeSegment.new(Time.utc(2006), Time.utc(2006, 1, 1, 0, 0, 2))
        ]
      end
    end

    context 'when the duration is negative' do
      let(:duration) { Biz::Duration.new(-1) }

      it 'returns no periods' do
        expect(timeline.for(duration).to_a).to eq []
      end
    end

    context 'when the duration is zero' do
      let(:duration) { Biz::Duration.new(0) }

      it 'returns no periods' do
        expect(timeline.for(duration).to_a).to eq []
      end
    end

    context 'when the duration is contained by the first period' do
      let(:duration) { Biz::Duration.days(15) }

      it 'returns part of the first period' do
        expect(timeline.for(duration).to_a).to eq [
          Biz::TimeSegment.new(Time.utc(2006), Time.utc(2006, 1, 16))
        ]
      end
    end

    context 'when the duration is the length of the first period' do
      let(:duration) { Biz::Duration.days(31) }

      it 'returns the first period' do
        expect(timeline.for(duration).to_a).to eq [
          Biz::TimeSegment.new(Time.utc(2006), Time.utc(2006, 2))
        ]
      end
    end

    context 'when the duration is contained by a set of full periods' do
      let(:duration) { Biz::Duration.days(62) }

      it 'returns the proper periods' do
        expect(timeline.for(duration).to_a).to eq [
          Biz::TimeSegment.new(Time.utc(2006), Time.utc(2006, 2)),
          Biz::TimeSegment.new(Time.utc(2007), Time.utc(2007, 2))
        ]
      end
    end

    context 'when the duration ends in the middle of a period' do
      let(:duration) { Biz::Duration.days(46) }

      it 'returns the proper periods' do
        expect(timeline.for(duration).to_a).to eq [
          Biz::TimeSegment.new(Time.utc(2006), Time.utc(2006, 2)),
          Biz::TimeSegment.new(Time.utc(2007), Time.utc(2007, 1, 16))
        ]
      end
    end
  end
end
