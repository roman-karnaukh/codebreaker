require 'spec_helper'

module Codebreaker
  describe Game do
    context "#initialize" do


      it "saves secret code" do
        expect(subject.instance_variable_get(:@secret_code)).not_to be_empty
      end

      it "saves 4 numbers secret code" do
        expect(subject.instance_variable_get(:@secret_code).size).to eq(4)
      end

      it "saves secret code with numbers from 1 to 6" do
        expect(subject.instance_variable_get(:@secret_code).join).to match(/[1-6]+/)
      end

      it "saves secret code with range 1 to 6" do
        expect_any_instance_of(Game).to receive(:rand).with(1..6).exactly(4).times
        subject
      end

       it "uses random numbers for new secret code" do
        expect_any_instance_of(Game).to receive(:rand).and_return(6,3,5,4)
        expect(subject.instance_variable_get(:@secret_code)).to eq [6,3,5,4]
      end

      it "sets attempts to 10" do
        expect(subject.instance_variable_get(:@attempts)).to eq(10)
      end

    end

    context "#guess" do
      before do
        subject.instance_variable_set(:@secret_code, [6,4,6,3])
      end

      it {should respond_to(:guess)}

      it "decreases numbers of attempts by 1" do
        expect{subject.guess("1234")}.to change{subject.instance_variable_get(:@attempts)}.by(-1)
      end

      it "decreases numbers of attempts by 11 and get 0" do
        11.times { subject.guess("1234") }
        expect(subject.instance_variable_get(:@attempts)).to eq(0)
      end

      it "it can restart the game" do
        subject.restart_the_game
        expect(subject.instance_variable_get(:@attempts)).to eq(10)
      end

      examples = {
        "6463" => "++++",
        "6453" => "+++",
        "4663" => "++--",
        "4636" => "----",
        "3463" => "+++",
        "1253" => "+",
        "1626" => "--",
        "1425" => "+",
        "1245" => "-",
        "1234" => "--",
        "3625" => "--",
        "1625" => "-",
        "5453" => "++",
        "3333" => "+",
        "6666" => "++",
        "4444" => "+",
        "1362" => "+-",
      }

      examples.each do |k,v|
        it "returns #{v} when #{k}" do
          expect(subject.guess k.to_s).to eq v
        end
      end
    end


    context "#hint" do
      before do
        subject.instance_variable_set(:@secret_code, [6,4,6,3])
      end

      it "returns right hint" do
        allow(subject).to receive(:rand).and_return(0)
        expect(subject.hint).to eq "6***"
      end

      it "sets correct @hint" do
        allow(subject).to receive(:rand).and_return(3)
        subject.hint
        expect(subject.instance_variable_get(:@hint)).to eq "***3"
      end

      it "returns @hint if not nil" do
        subject.instance_variable_set(:@hint, "*4**")
        expect(subject.hint).to eq "*4**"
      end

    end

    context "#result" do
      it {should respond_to(:save_result)}
      it {should respond_to(:get_statistics)}

      it "is array" do
        expect(subject.get_statistics).kind_of? Array
      end
    end

  end
end
