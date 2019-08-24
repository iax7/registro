# frozen_string_literal: true

# Functions used for calculating all sums and statistic data from reports view
class TotalsHelper
  # is_paid |status |f_v1|f_v2|f_v3|f_s1|f_s2|f_s3|f_d1|f_d2|f_d3|f_l1|f_l2|f_l3|
  # --------|-------|----|----|----|----|----|----|----|----|----|----|----|----|
  # false   |adult  |0   |0   |2   |2   |2   |2   |2   |2   |2   |2   |0   |0   |
  # false   |child  |0   |0   |0   |0   |1   |0   |0   |1   |0   |0   |0   |0   |
  # true    |adult  |0   |0   |3   |3   |2   |2   |2   |3   |2   |3   |0   |0   |
  # true    |child  |0   |0   |0   |0   |1   |0   |0   |1   |0   |0   |0   |0   |

  ##
  # @param [int] full_price
  # @param [int] half_price
  # @return nil
  def initialize(full_price, half_price)
    @full = full_price
    @half = half_price
  end

  def process(foods, used)
    # Divide the result by 'is_paid' status
    food_not_paid = foods.reject { |f| f['is_paid'] }
    food_paid = foods.select { |f| f['is_paid'] }

    food_not_paid_f = flatten food_not_paid
    food_paid_f = flatten food_paid
    used_f = flatten used

    food_requested_f = food_not_paid_f.merge(food_paid_f) { |_k, not_paid_v, paid_v| not_paid_v + paid_v }

    {
      :requested => create_hash(food_requested_f),
      :paid      => create_hash(food_paid_f),
      :used      => create_hash(used_f)
    }
  end

  private

  ##
  # Receives an Array of hashes and return a single hash with the values
  # [{"is_paid"=>false, "status"=>"adult", ...},  => v3,  s1 ...
  #  {"is_paid"=>false, "status"=>"child", ...}]  => v3c, s1c...
  # @param [Array] array_of_hash
  # @return [Hash]
  def flatten(array_of_hash)
    keys = %i[v1  v2  v3
              s1  s2  s3
              d1  d2  d3
              l1  l2  l3
              v1c v2c v3c
              s1c s2c s3c
              d1c d2c d3c
              l1c l2c l3c]
    # OLD: flat = Hash[keys.map { |item| [item, 0] }].with_indifferent_access
    flat = keys.each_with_object({}.with_indifferent_access) { |item, new| new[item] = 0 }
    array_of_hash.each do |row|
      row.each do |k, v|
        next unless k.match?(/f_.+/)
        key = k.sub('f_', '')
        key_target = row['status'] == 'adult' ? key : "#{key}c"
        flat[key_target] = v
      end
    end
    flat
  end

  ##
  # Receives a hash processed by *flatten* method and returns a Hash
  # with following contents: one the original (count),
  # the other multiplied by prices (money) and a final sum (money_total)
  # {"v1"=>0,        => { count: { "v1": 1, "v2": 1, .. },
  #  "v2"=>0,             money: { "v1": 50, "v2": 50, ...},
  #  "v3"=>1, ... }       money_total: 400 }
  # @param [Hash] hash
  # @return [Hash]
  def create_hash(hash)
    monetized = hash.each_with_object(Hash.new(0).with_indifferent_access) do |(key, val), mny|
      cost = key.match?(/[vsdl][0-3]/) ? @full : @half
      mny[key] = val * cost
    end
    # OLD: monetized.reduce(0) { |total, (_, v)| total + v }
    {
      :count       => hash,
      :money       => monetized,
      :money_total => monetized.each_value.reduce(0, :+)
    }
  end
end
