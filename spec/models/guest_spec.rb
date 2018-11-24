require 'rails_helper'

RSpec.describe Guest, type: :model do
  subject do
    Guest.new(
      name: 'esteban  iván',
      lastname: 'Granados   córdova',
      nick: 'dido',
      is_male: true,
      age: 38,
      relation: 0,
      is_pregnant: false,
      is_medicated: true,
      f_v1: true, f_v2: true, f_v3: true,
      f_s1: true, f_s2: true, f_s3: true,
      f_d1: true, f_d2: true, f_d3: true,
      f_l1: true, f_l2: true, f_l3: true,
      t_v1: true, t_v2: true,
      t_s1: true, t_s2: true,
      t_d1: true, t_d2: true,
      t_l1: true, t_l2: true,
      l_v: true,
      l_s: true,
      l_d: true,
      l_l: true,
      l_room: '22S')
  end

  let(:child) do
    Guest.new(
      name: 'Alejandra',
      lastname: 'Carranco',
      nick: 'ale',
      is_male: false,
      age: 6,
      relation: 0,
      is_pregnant: false,
      is_medicated: true,
      f_v1: false, f_v2: false, f_v3: true,
      f_s1: true, f_s2: true, f_s3: true,
      f_d1: true, f_d2: true, f_d3: true,
      f_l1: true, f_l2: false, f_l3: false,
      t_v1: true, t_v2: true,
      t_s1: true, t_s2: true,
      t_d1: true, t_d2: true,
      t_l1: true, t_l2: true,
      l_v: true,
      l_s: false,
      l_d: false,
      l_l: false,
      l_room: '20S')
  end

  before(:all) do
    @event_full_price = 100
    @event_no_price = 0
    @food_full_price = 50
    @food_half_price = 25
    @lodging_full_price = 100
    @lodging_half_price = 50
    @transport_full_price= 100
    @transport_half_price= 50
  end

  it 'Name is titlesize' do
    subject.validate
    expect(subject.name).to eq(subject.name.titleize.strip.squish.freeze)
    expect(subject.lastname).to eq(subject.lastname.titleize.strip.squish.freeze)
    expect(subject.nick).to eq(subject.nick.titleize.strip.squish.freeze)
  end

  it 'age is correct' do
    expect(subject.adult?).to be_truthy
    expect(child.adult?).to be_falsey
  end

  it 'cost of services are correct' do
    expect(subject.costs_per_service(:assist)).to eq(@event_full_price)
    expect(subject.costs_per_service(:food)).to eq(@food_full_price)
    expect(subject.costs_per_service(:lodging)).to eq(@lodging_full_price)
    expect(subject.costs_per_service(:transport)).to eq(@transport_full_price)

    expect(child.costs_per_service(:assist)).to eq(@event_no_price)
    expect(child.costs_per_service(:food)).to eq(@food_half_price)
    expect(child.costs_per_service(:lodging)).to eq(@lodging_half_price)
    expect(child.costs_per_service(:transport)).to eq(@transport_half_price)
  end

  it 'assist cost is correct' do
    expect(subject.assist_cost).to eq(@event_full_price)
    expect(child.assist_cost).to eq(0)
  end

  it 'food cost is correct' do
    food_attr = subject.attributes.select { |k,_| k.to_s.match(/^f_[vsdl]\d$/) }
    requested = food_attr.select { |_,v| v }
    expect(food_attr.size).to eq(12)
    expect(requested.size).to eq(12)
    expect(subject.food_cost).to eq(@food_full_price * 12)
  end

  it 'lodging cost is correct' do
    lodging_attr = subject.attributes.select { |k,_| k.to_s.match(/^l_[vsdl]$/) }
    requested = lodging_attr.select { |_,v| v }
    expect(lodging_attr.size).to eq(4)
    expect(requested.size).to eq(4)
    expect(subject.lodging_cost).to eq(@lodging_full_price * 4)
  end

  it 'transport cost is correct' do
    trans_attr = subject.attributes.select { |k| k.to_s.match(/^t_[vsdl]\d$/) }
    requested = trans_attr.select { |_,v| v }
    expect(trans_attr.size).to eq(8)
    expect(requested.size).to eq(8)
    expect(subject.transport_cost).to eq(@transport_full_price * 8)
  end

  it 'total cost is correct' do
    expect(subject.total).to eq(1900)
  end
end
