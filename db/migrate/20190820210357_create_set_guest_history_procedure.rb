class CreateSetGuestHistoryProcedure < ActiveRecord::Migration[6.0]
  def change
    execute <<~SQL
      -- DROP PROCEDURE SET_GUEST_HISTORY;
      -- CALL SET_GUEST_HISTORY();
      CREATE OR REPLACE PROCEDURE SET_GUEST_HISTORY()
      LANGUAGE plpgsql
      AS $$
      DECLARE
          users      CURSOR FOR SELECT id FROM users ORDER BY 1;
          guests_arr JSONB;
          cur_id     BIGINT;
      BEGIN
          OPEN users;
          LOOP
              FETCH users INTO cur_id;
              EXIT WHEN NOT FOUND;

              -- Generate Guests JSON array
              WITH data AS (
                SELECT id,
                       EXTRACT(year FROM created_at) as cy,
                       name, lastname, nick, is_male, age, relation
                  FROM guests
                 WHERE registry_id = cur_id
                   AND relation <> 0
                 ORDER BY age DESC)
              SELECT to_json(array_agg(x)) AS guest_array
                INTO guests_arr
                FROM data x;

              CONTINUE WHEN guests_arr IS NULL;

              UPDATE users
                 SET guest_history = guests_arr
               WHERE id = cur_id;

          END LOOP;
          CLOSE users;
          COMMIT;
      END; $$
    SQL
  end
end
