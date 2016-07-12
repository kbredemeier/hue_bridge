require 'spec_helper'

module HueBridge
  describe LightBulp do
    subject do
      LightBulp.new(
        '10.100.198.4',
        '871baa6b48b3a42af620f2509a1f',
        1
      )
    end

    describe "#on" do
      it "turns the light on" do
        VCR.use_cassette('light_bulp_on') do
          expect(subject.on).to be_truthy
        end
      end
    end

    describe "#off" do
      it "turns the light off" do
        VCR.use_cassette('light_bulp_off') do
          expect(subject.off).to be_falsy
        end
      end
    end

    describe "#toggle" do
      it "toggles the light" do
        VCR.use_cassette('light_bulp_toggle') do
          expect(subject.toggle).to be_truthy
          expect(subject.toggle).to be_falsy
        end
      end
    end
  end
end
