require 'svm'
require 'gmail'

class DenunciaController < ApplicationController

  @@denuncia = Denuncia.new
  @@dadosPessoais = DadosPessoais.new

  @@denuncia_data
  @@usuario_data

  @@model

  @@prediction

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

    #trainSVMModel
    #predictClass(@@denuncia_data['descricao'])
    @prediction = 'Homofobia'
    @@prediction = @prediction
  end

  def contato
    gmail = Gmail.connect(@@gmailAccount['username'], @@gmailAccount['password'])

    gmail.deliver do
      to "johanngomes@gmail.com"
      subject "Teste de e-mail usando a gem"
      html_part do
        body "<p>Parte da mensagem com <strong>texto formatado</strong> em <em>html</em>.</p>"
      end
    end

    gmail.logout
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

    combPalavra.each do |comb|
      combs << [comb.id_palavrachave_1, comb.id_palavrachave_2]
      classes << classesNum[comb.classe]
    end

    puts classes, combs
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

    classesNumReverse = {1 => 'Machismo', 2 => 'Homofobia',
                         3 => 'Racismo de cor', 4 => 'Racismo xenófobo',
                         5 => 'Problema na área de saúde', 6 => 'Desigualdade social não detectada',
                         7 => 'Desigualdade de idade', 8 => 'Desigualdade social de classe',
                         9 => 'Desigualdade educacional', 10 => 'Desigualdade digital',
                         11 => 'Desigualdade baseada em castas'}

   @@prediction = classesNumReverse[@@model.predict(palavrasId).to_i]
   puts 'prediction', @@prediction
  end
end
