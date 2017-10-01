class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.string :title
      t.text :body
      t.references :question, index: true

      t.timestamps
    end
  end
end
