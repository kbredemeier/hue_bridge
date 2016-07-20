require 'spec_helper'

module HueBridge
  describe LightBulp do
    subject do
      LightBulp.new(
        hue_bridge_ip: '192.168.1.26',
        user_id: 'mAq0G-2UyTmQ-YQq9F3U3KuFDdA3vHUw5TMmTruU',
        light_bulp_id: 2
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
          expect(subject.off).to be_truthy
        end
      end
    end

    describe "#toggle" do
      it "toggles the light" do
        VCR.use_cassette('light_bulp_toggle') do
          expect(subject.toggle).to be_truthy
          expect(subject.power).to be_truthy
          expect(subject.toggle).to be_truthy
          expect(subject.power).to be_falsy
        end
      end
    end

    describe "#alert" do
      it "puts the light in alert mode" do
        VCR.use_cassette('light_bulp_alert') do
          subject.on
          expect(subject.alert).to be_truthy
          subject.off
        end
      end
    end

    describe "#set_color" do
      let(:attrs) {{ hue: 1, sat: 1, bri: 1 }}

      it "sets the color for the ligt bulp" do
        VCR.use_cassette('light_bulp_set_color') do
          subject.on
          expect(subject.set_color(attrs)).to be_truthy
          subject.off
        end
      end
    end
  end
end
