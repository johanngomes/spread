class CreatePalavras < ActiveRecord::Migration
  def change
    create_table :palavras do |t|
      t.string :palavrachave
      t.string :classe

      t.timestamps
    end
  end
end
