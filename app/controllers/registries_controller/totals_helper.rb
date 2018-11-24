# frozen_string_literal: true

class RegistriesController
  # All functions used for calculating all sums and stadistic data from reports view
  class TotalsHelper
    # is_paid |status |f_v1|f_v2|f_v3|f_s1|f_s2|f_s3|f_d1|f_d2|f_d3|f_l1|f_l2|f_l3|
    # --------|-------|----|----|----|----|----|----|----|----|----|----|----|----|
    # false   |adult  |0   |0   |2   |2   |2   |2   |2   |2   |2   |2   |0   |0   |
    # false   |child  |0   |0   |0   |0   |1   |0   |0   |1   |0   |0   |0   |0   |
    # true    |adult  |0   |0   |3   |3   |2   |2   |2   |3   |2   |3   |0   |0   |
    # true    |child  |0   |0   |0   |0   |1   |0   |0   |1   |0   |0   |0   |0   |

    def initialize(full, half)
      @full = full
      @half = half
    end

    def process(foods, used)
      # Divide the result by 'is_paid'
      food_not_paid = foods.reject { |f| f['is_paid'] }
      food_paid = foods.select { |f| f['is_paid'] }

      food_not_paid_f = flatten food_not_paid
      food_paid_f = flatten food_paid
      used_f = flatten used

      food_requested_f = food_not_paid_f.merge(food_paid_f) { |_k, o, n| o + n }

      {
        :requested => create_hash(food_requested_f),
        :paid      => create_hash(food_paid_f),
        :used      => create_hash(used_f)
      }
    end

    private

    def flatten(array_of_hash)
      keys = %i[v1  v2  v3
                s1  s2  s3
                d1  d2  d3
                l1  l2  l3
                v1c v2c v3c
                s1c s2c s3c
                d1c d2c d3c
                l1c l2c l3c]
      flat = Hash[keys.collect { |item| [item, 0] }].with_indifferent_access
      array_of_hash.each do |row|
        row.each do |k, v|
          key = k.sub('f_', '')
          new_name = row['status'] == 'adult' ? key : "#{key}c"
          flat[new_name] = v if k.match?(/f_.+/)
        end
      end
      flat.with_indifferent_access
    end

    def monetize(hash)
      new = hash.dup
      new.each do |key, value|
        cost = key.match?(/[vsdl][0-3]/) ? @full : @half
        new[key] = value * cost
      end
      new.with_indifferent_access
    end

    def grand_total(hash)
      total = 0
      hash.each do |_key, value|
        total += value
      end
      total
    end

    def create_hash(hash)
      monetized = monetize hash
      result_hash = {
        :count       => hash,
        :money       => monetized,
        :money_total => grand_total(monetized)
      }
      OpenStruct.new result_hash
    end
  end
end
