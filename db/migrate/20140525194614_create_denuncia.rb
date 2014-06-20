class CreateDenuncia < ActiveRecord::Migration
  def change
    create_table :denuncia do |t|
      t.string :onde
      t.string :quando
      t.string :descricao
      t.integer :id_usuario
      t.string :classe

      t.timestamps
    end
  end
end
