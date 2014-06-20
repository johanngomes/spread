class CreateDadosPessoais < ActiveRecord::Migration
  def change
    create_table :dados_pessoais do |t|
      t.string :nome
      t.string :email
      t.string :cpf
      t.string :fone
      t.string :endereco

      t.timestamps
    end
  end
end
