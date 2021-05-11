# frozen_string_literal: true

require "rails_helper"

RSpec.describe Guest, type: :model do
  fixtures :guests, :events

  let(:adult) do
    guests(:adult)
  end

  let(:child) do
    guests(:child)
  end

  let(:infant) do
    guests(:infant)
  end

  let(:event) do
    events(:one)
  end

  describe "#female?" do
    it "returns false when Male" do
      subject.is_male = true
      expect(subject).not_to be_female
    end

    it "returns True when Female" do
      subject.is_male = false
      expect(subject).to be_female
    end
  end

  describe "#relation" do
    it "returns me" do
      subject.relation = 0
      expect(subject.relation_t).to eq("Titular")
    end

    it "returns family" do
      subject.relation = 1
      expect(subject.relation_t).to eq("Familiar")
    end

    it "returns friend" do
      subject.relation = 2
      expect(subject.relation_t).to eq("Amigo")
    end

    it "returns other" do
      subject.relation = 3
      expect(subject.relation_t).to eq("Otro")
    end
  end

  it "#relations_to_show" do
    result = Guest.relations_to_show
    expect(result).to be_a(Hash)
    expect(result.size).to eq(3)
  end

  it "Concatenates full name correctly" do
    adult.validate
    expect(adult.full_name).to eq("Granados Córdova, Esteban Iván")
  end

  it "Name, Lastname, Nick is titlesize" do
    adult.validate
    expect(adult.name).to eq(adult.name.titleize.strip.squish.freeze)
    expect(adult.lastname).to eq(adult.lastname.titleize.strip.squish.freeze)
    expect(adult.nick).to eq(adult.nick.titleize.strip.squish.freeze)
  end

  context "age is correct" do
    it "for adult" do
      expect(adult).to be_adult
      expect(adult).not_to be_child
    end

    it "for child" do
      expect(child).not_to be_adult
      expect(child).to be_child
    end

    it "for infant" do
      expect(infant).not_to be_adult
      expect(infant).not_to be_child
    end
  end

  context "cost of services are correct" do
    before { allow(Event).to receive(:current).and_return(event) }

    it "for adult" do
      expect(adult.costs_per_service(:assist)).to    eq(event.event_full_price)
      expect(adult.costs_per_service(:food)).to      eq(event.food_full_price)
      expect(adult.costs_per_service(:lodging)).to   eq(event.lodging_full_price)
      expect(adult.costs_per_service(:transport)).to eq(event.transport_full_price)
    end

    it "for child" do
      expect(child.costs_per_service(:assist)).to    eq(0)
      expect(child.costs_per_service(:food)).to      eq(event.food_half_price)
      expect(child.costs_per_service(:lodging)).to   eq(event.lodging_half_price)
      expect(child.costs_per_service(:transport)).to eq(event.transport_half_price)
    end

    it "for infant" do
      expect(infant.costs_per_service(:assist)).to    eq(0)
      expect(infant.costs_per_service(:food)).to      eq(0)
      expect(infant.costs_per_service(:lodging)).to   eq(0)
      expect(infant.costs_per_service(:transport)).to eq(0)
    end
  end

  context "assist cost is correct" do
    before { allow(Event).to receive(:current).and_return(event) }

    it "for adult" do
      expect(adult.assist_cost).to eq(event.event_full_price)
    end

    it "for child" do
      expect(child.assist_cost).to eq(0)
    end

    it "for infant" do
      expect(infant.assist_cost).to eq(0)
    end
  end

  context "food cost is correct" do
    before { allow(Event).to receive(:current).and_return(event) }

    it "for adult" do
      food_attr = adult.attributes.select { |k, _| k.to_s.match(/^f_[vsdl]\d$/) }
      requested = food_attr.select { |_, v| v }
      expect(food_attr.size).to eq(12)
      expect(requested.size).to eq(12)
      expect(adult.food_cost).to eq(event.food_full_price * 12)
    end

    it "for child" do
      food_attr = child.attributes.select { |k, _| k.to_s.match(/^f_[vsdl]\d$/) }
      requested = food_attr.select { |_, v| v }
      expect(food_attr.size).to eq(12)
      expect(requested.size).to eq(8)
      expect(child.food_cost).to eq(event.food_half_price * 8)
    end

    it "for infant" do
      food_attr = infant.attributes.select { |k, _| k.to_s.match(/^f_[vsdl]\d$/) }
      requested = food_attr.select { |_, v| v }
      expect(food_attr.size).to eq(12)
      expect(requested.size).to eq(8)
      expect(infant.food_cost).to eq(0 * 8)
    end
  end

  it "lodging cost is correct" do
    allow(Event).to receive(:current).and_return(event)

    lodging_attr = adult.attributes.select { |k, _| k.to_s.match(/^l_[vsdl]$/) }
    requested = lodging_attr.select { |_, v| v }
    expect(lodging_attr.size).to eq(4)
    expect(requested.size).to eq(4)
    expect(adult.lodging_cost).to eq(event.lodging_full_price * 4)
  end

  it "transport cost is correct" do
    allow(Event).to receive(:current).and_return(event)

    trans_attr = adult.attributes.select { |k| k.to_s.match(/^t_[vsdl]\d$/) }
    requested = trans_attr.select { |_, v| v }
    expect(trans_attr.size).to eq(8)
    expect(requested.size).to eq(8)
    expect(adult.transport_cost).to eq(event.transport_full_price * 8)
  end

  it "total cost is correct" do
    allow(Event).to receive(:current).and_return(event)

    expect(adult.total).to eq(1900)
    expect(child.total).to eq(250)
    expect(infant.total).to eq(0)
  end
end
