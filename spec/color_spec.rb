require 'spec_helper'

module HueBridge
  describe Color do
    context "emtpy attrs" do
      subject { Color.new }

      describe "#to_hash" do
        it "is empty" do
          expect(subject.to_hash).to eq({})
        end
      end
    end

    context "valid attrs" do
      let(:attrs) {{ hue: 1, bri: 1, sat: 1 }}
      subject { Color.new(attrs) }

      describe "#initialize" do
        it "doesnt fail" do
          expect { subject }.not_to raise_error
        end

        it "sets the hue" do
          expect(subject.hue).to eq 1
        end

        it "sets the brightness" do
          expect(subject.bri).to eq 1
        end

        it "sets the saturation" do
          expect(subject.sat).to eq 1
        end
      end

      describe "#to_hash" do
        it "returns a hash representation for the color" do
          expect(subject.to_h).to eq attrs
        end
      end
    end

    context "invalid hue" do
      let(:attrs) {{ hue: -1 }}
      subject { Color.new(attrs) }

      it "fails" do
        expect { subject }.to raise_error InvalidColorOption
      end
    end

    context "invalid brightness" do
      let(:attrs) {{ bri: -1 }}
      subject { Color.new(attrs) }

      it "fails" do
        expect { subject }.to raise_error InvalidColorOption
      end
    end

    context "invalid saturation" do
      let(:attrs) {{ sat: -1 }}
      subject { Color.new(attrs) }

      it "fails" do
        expect { subject }.to raise_error InvalidColorOption
      end
    end
  end
end
