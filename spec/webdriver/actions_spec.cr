require "../spec_helper"
require "json"

describe Webdriver::Actions do
  describe Webdriver::Actions::PauseAction do
    describe ".pause" do
      it "has the appropriate type" do
        Webdriver::Actions::PauseAction.pause(Time::Span.new).should be_a(Webdriver::Actions::Action)
      end

      it "has a name" do
        Webdriver::Actions::PauseAction.pause(0.seconds).name.should eq("pause")
      end

      describe "#to_json" do
        it "has a type, value and duration" do
          subject = Hash(String, String | UInt8).from_json(Webdriver::Actions::PauseAction.pause(0.seconds).to_json)
          subject.should eq({
            "type" => "pause",
            "value" => 0,
            "duration" => 0
          })
        end
      end
    end
  end

  describe Webdriver::Actions::KeyboardAction do
    describe ".up" do
      it "is a keyUp action" do
        action = Webdriver::Actions::KeyboardAction.up("R")
        action.should be_a(Webdriver::Actions::Action)
        action.name.should eq("keyUp")
        action.value.should eq("R")
      end
    end

    describe ".down" do
      it "is a keyDown action" do
        action = Webdriver::Actions::KeyboardAction.down("R")
        action.should be_a(Webdriver::Actions::Action)
        action.name.should eq("keyDown")
        action.value.should eq("R")
      end

      describe "#to_json" do
        it "has a type and value" do
          subject = Hash(String, String).from_json(Webdriver::Actions::KeyboardAction.up("R").to_json)
          subject.should eq({
            "type" => "keyUp",
            "value" => "R"
          })
        end
      end
    end
  end

  describe Webdriver::Actions::PointerAction do
    describe "#to_json" do
      describe ".up" do
        it "has correct type, duration and button" do
          subject = Hash(String, Int32 | String).from_json(Webdriver::Actions::PointerAction.up(:left).to_json)
          subject.should eq({
            "type" => "pointerUp",
            "duration" => 0,
            "button" => 1
          })
        end
      end

      describe ".down" do
        it "has correct type, duration and button" do
          subject = Hash(String, Int32 | String).from_json(Webdriver::Actions::PointerAction.down(:right, 1.second).to_json)
          subject.should eq({
            "type" => "pointerDown",
            "duration" => 1_000,
            "button" => 2
          })
        end
      end
    end

    describe ".[]" do
      it "has :left" do
        Webdriver::Actions::PointerAction[:left].should eq(1)
      end

      it "has :right" do
        Webdriver::Actions::PointerAction[:right].should eq(2)
      end

      it "has :middle" do
        Webdriver::Actions::PointerAction[:middle].should eq(3)
      end
    end
  end

  describe Webdriver::Actions::WheelAction do
    describe "#to_json" do
      describe ".from_viewport" do
        it "has fields" do
          subject = Hash(String, String | Int32).from_json(Webdriver::Actions::WheelAction.from_viewport(0, 0).to_json)
          subject.should eq({
            "type" => "scroll",
            "x" => 0,
            "y" => 0,
            "deltaX" => 0,
            "deltaY" => 0,
            "duration" => 0,
            "origin" => "viewport"
          })
        end
      end

      describe ".from_element" do
        it "has fields" do
          subject = Hash(String, String | Int32 | Hash(String, String)).from_json(Webdriver::Actions::WheelAction.from_element(0, 0, "the-id").to_json)
          subject.should eq({
            "type" => "scroll",
            "x" => 0,
            "y" => 0,
            "deltaX" => 0,
            "deltaY" => 0,
            "duration" => 0,
            "origin" => {
              Webdriver::ELEMENT_KEY => "the-id"
            }
          })
        end
      end
    end

    describe "#name" do
      it "returns scroll" do
        Webdriver::Actions::WheelAction.from_viewport(0, 0).name.should eq("scroll")
      end
    end
  end

  describe Webdriver::Actions::PointerMoveAction do
    describe "#to_json" do
      describe ".from_viewport" do
        it "has fields" do
          subject = Hash(String, String | Int32).from_json(Webdriver::Actions::PointerMoveAction.from_viewport(0, 0, 0.seconds).to_json)
          subject.should eq({
            "type" => "pointerMove",
            "x" => 0,
            "y" => 0,
            "duration" => 0,
            "origin" => "viewport"
          })
        end
      end

      describe ".from_element" do
        it "has fields" do
          subject = Hash(String, String | Int32 | Hash(String, String)).from_json(Webdriver::Actions::PointerMoveAction.from_element(0, 0, 0.seconds, "the-id").to_json)
          subject.should eq({
            "type" => "pointerMove",
            "x" => 0,
            "y" => 0,
            "duration" => 0,
            "origin" => {
              Webdriver::ELEMENT_KEY => "the-id"
            }
          })
        end
      end
    end

    describe "#name" do
      it "returns pointerMove" do
        Webdriver::Actions::PointerMoveAction.from_viewport(0, 0, 0.seconds).name.should eq("pointerMove")
      end
    end
  end

  pending Webdriver::Actions::ActionBuilder
end
