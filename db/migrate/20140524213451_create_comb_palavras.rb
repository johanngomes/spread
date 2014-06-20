class CreateCombPalavras < ActiveRecord::Migration
  def change
    create_table :comb_palavras do |t|
      t.integer :id_palavrachave_1
      t.integer :id_palavrachave_2
      t.string :classe

      t.timestamps
    end
  end
end
