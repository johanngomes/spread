require 'svm'

class FormController < ApplicationController

  def denuncia
    @denuncia = Denuncia.new
    puts @denuncia
    alunos = []
    alunos << [12, 150, 3, 15]
    alunos << [4, 170, 32, 25]
    alunos << [1, 10, 3, 25]
    alunos << [12, 20, 31, 15]

    labels = [1, 1, 0, 0]

    prob = Problem.new(labels, alunos)
    param = Parameter.new(:kernel_type => LINEAR, :C => 10)
    m = Model.new(prob,param)

    guilherme = [ 6, 140, 25, 10 ]

    puts "predicting..."
    puts m.predict(guilherme)


  end

  def create
    @denuncia = Denuncia.new(params[:denuncia])
    @denuncia.save
  end
end
