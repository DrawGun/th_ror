class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.references :attachable, polymorphic: true, index: true
      t.string :file

      t.timestamps
    end
  end
end
