require 'svm'

class DenunciaController < ApplicationController

  @@denuncia = Denuncia.new
  @@dadosPessoais = DadosPessoais.new

  @@denuncia_data
  @@usuario_data

  @@model

  @@gmailAccount = {'username' => 'bnt.mailing@gmail.com', 'password' => 'bocanotrombone'}

  def new
  end

  def personal
    @@denuncia_data = params[:denuncia]
  end

  def resultado
    @@usuario_data = params[:personal]

    puts params[:personal]

    @@dadosPessoais.nome = @@usuario_data['nome']
    @@dadosPessoais.email = @@usuario_data['email']
    @@dadosPessoais.cpf = @@usuario_data['cpf']
    @@dadosPessoais.fone = @@usuario_data['fone']
    @@dadosPessoais.endereco = @@usuario_data['endereco']

    @@dadosPessoais.save

    @@denuncia.onde = @@denuncia_data['onde']
    @@denuncia.quando = @@denuncia_data['quando']
    @@denuncia.descricao = @@denuncia_data['descricao']
    @@denuncia.id_usuario = DadosPessoais.order('created_at').last.id

    @@denuncia.save

    trainSVMModel
    puts 'Denuncia data: ', @@denuncia_data['descricao']
    @prediction = predictClass(@@denuncia_data['descricao'])
  end

  def trainSVMModel
    combs = []
    classes = []
    combPalavra = CombPalavra.all

    classesNum = {'gen-m' => 1, 'gen-homo' => 2,
                  'rac-cor' => 3, 'rac-xeno' => 4,
                  'medica' => 5, 'neutro' => 6,
                  'idade' => 7, 'classe' => 8,
                  'educacao' => 9, 'digital' => 10,
                  'castas' => 11}

    puts 'begin-'
    combPalavra.each do |comb|
      puts '[' + comb.id_palavrachave_1.to_s + ',' + comb.id_palavrachave_2.to_s + '], '
      combs << [comb.id_palavrachave_1, comb.id_palavrachave_2]
      classes << classesNum[comb.classe]
    end
    puts 'end-'

    puts 'classes', classes
    puts 'combs', combs

    prob = Problem.new(classes, combs)
    param = Parameter.new(:kernel_type => LINEAR, :C => 10)
    @@model = Model.new(prob,param)
  end

  def predictClass(descricao)
    palavra = Palavra.all

    palavrasId = []
    palavra.each do |ocorrencia|
      if descricao.include? ocorrencia.palavrachave
         if palavrasId.length < 2
           palavrasId << ocorrencia.id
         end
      end
    end

    puts 'A descrição é: ', descricao, 'As palavras identificadas foram: ', palavrasId.to_s

    classesNumReverse = {1 => 'Machismo', 2 => 'Homofobia',
                         3 => 'Racismo de cor', 4 => 'Racismo xenófobo',
                         5 => 'Problema na área de saúde', 6 => 'Desigualdade social não detectada',
                         7 => 'Desigualdade de idade', 8 => 'Desigualdade social de classe',
                         9 => 'Desigualdade educacional', 10 => 'Desigualdade digital',
                         11 => 'Desigualdade baseada em castas'}

    return  classesNumReverse[@@model.predict(palavrasId).to_i]
  end
end
