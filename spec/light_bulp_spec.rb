require 'spec_helper'

module HueBridge
  describe LightBulp do
    subject do
      LightBulp.new(
        hue_bridge_ip: '10.100.198.4',
        user_id: '871baa6b48b3a42af620f2509a1f',
        light_bulp_id: 3
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

    describe "#store_state" do
      it "it stores the state" do
        VCR.use_cassette('light_bulp_store_state') do
          expect(subject.store_state).to be_truthy
          expect(subject.state).to be_a Hash
        end
      end
    end

    describe "#restore_state" do
      it "it restores the state" do
        VCR.use_cassette('light_bulp_restore_state') do
          subject.on
          expect(subject.store_state).to be_truthy
          expect(subject.restore_state).to be_truthy
          subject.off
        end
      end
    end
  end
end
