class MigrateBookTropesData < ActiveRecord::Migration[8.1]
  def up
    # Collect all distinct trope names from the books.tropes array (E6: create unknown tropes too)
    trope_names = select_all(
      "SELECT DISTINCT unnest(tropes) AS name FROM books WHERE tropes != '{}' AND tropes IS NOT NULL"
    ).map { |row| row['name'] }.compact.reject(&:blank?).uniq

    return if trope_names.empty?

    now = Time.current.to_fs(:db)

    trope_names.each do |name|
      execute(<<~SQL)
        INSERT INTO tropes (name, created_at, updated_at)
        VALUES (#{quote(name)}, '#{now}', '#{now}')
        ON CONFLICT (name) DO NOTHING
      SQL
    end

    # Create book_tropes join records from the array data
    execute(<<~SQL)
      INSERT INTO book_tropes (book_id, trope_id, created_at, updated_at)
      SELECT b.id, t.id, '#{now}', '#{now}'
      FROM books b
      CROSS JOIN LATERAL unnest(b.tropes) AS trope_name
      JOIN tropes t ON t.name = trope_name
      WHERE b.tropes != '{}' AND b.tropes IS NOT NULL
      ON CONFLICT (book_id, trope_id) DO NOTHING
    SQL
  end

  def down
    # Restore array data from join table (best-effort)
    execute(<<~SQL)
      UPDATE books SET tropes = ARRAY(
        SELECT t.name FROM book_tropes bt
        JOIN tropes t ON t.id = bt.trope_id
        WHERE bt.book_id = books.id
      )
    SQL

    execute('DELETE FROM book_tropes')
    execute('DELETE FROM tropes')
  end
end
