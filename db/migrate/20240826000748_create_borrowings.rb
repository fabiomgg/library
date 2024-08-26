class CreateBorrowings < ActiveRecord::Migration[7.0]
  def change
    create_table :borrowings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.date :borrowed_at
      t.date :due_at
      t.date :returned_at

      t.timestamps
    end
  end
end
