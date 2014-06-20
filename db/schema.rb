# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140525194705) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comb_palavras", force: true do |t|
    t.integer  "id_palavrachave_1"
    t.integer  "id_palavrachave_2"
    t.string   "classe"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dados_pessoais", force: true do |t|
    t.string   "nome"
    t.string   "email"
    t.string   "cpf"
    t.string   "fone"
    t.string   "endereco"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "denuncia", force: true do |t|
    t.string   "onde"
    t.string   "quando"
    t.string   "descricao"
    t.integer  "id_usuario"
    t.string   "classe"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "palavras", force: true do |t|
    t.string   "palavrachave"
    t.string   "classe"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
