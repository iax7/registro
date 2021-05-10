# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Registry, type: :model do
  fixtures :registries, :guests, :events

  let(:not_paid) { registries(:not_paid) }
  let(:paid) { registries(:paid) }
  let(:event) { events(:one) }

  before { allow(Event).to receive(:current).and_return(event) }

  it '#grand_total' do
    expect(paid.grand_total).to eq(2000)
    expect(not_paid.grand_total).to eq(100)
  end

  it '#amount_remaining' do
    expect(paid.amount_remaining).to eq(0)
    expect(not_paid.amount_remaining).to eq(90)
  end

  it '#paid' do
    expect(paid).to be_paid
    expect(not_paid).not_to be_paid
  end

  it '#totals' do
    expect(paid).to receive(:save!).and_return(true)
    totals = paid.totals

    expect(totals).to be_a(Hash)
    expect(totals.size).to eq(7)
    expect(totals).to eq({ assist: 0, food: 200, lodging: 50, medicated: 0, pregnant: 1, total: 250, trans: 0 })
  end

  it '#counts' do
    expect(paid).to receive(:save!).and_return(true)
    counts = paid.counts

    expect(counts).to be_a(Hash)
    expect(counts.size).to eq(24)
  end
end
