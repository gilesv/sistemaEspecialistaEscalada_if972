% Logica para Computacao - IF972 - 2016.2
% por Renata Amorim (rksa@cin.ufpe.br) e Vinicius Giles (vgcp@cin.ufpe.br)

%escalador(Pessoa,NumMarinheiros)
escalador(pedro, 12).
escalador(joao, 8).
escalador(luiza, 18).
escalador(ana, 23).
escalador(roberto, 27).
escalador(carmen, 10).
escalador(eliana, 19).
escalador(jose, 6).
escalador(sabrina, 9).
escalador(rayane, 30).
escalador(priscila, 26).

%locais de escalada
local('Serra do Cipo', [inverno, primavera], diversao, dificil).
local('Pao de Acucar', [outono, inverno, primavera, verao], esporte, dificil).
local('Sao Bento do Sapucai', [inverno, primavera], esporte, dificil).
local('Pindamonhangaba', [inverno, primavera], esporte, medio).
local('Chapada da Diamantina', [inverno, primavera], diversao, medio).
local('Lapinha', [inverno, primavera], esporte, medio).
local('Serra Caiada', [primavera, verao], diversao, facil).
local('Pedra da Boca', [primavera, verao], diversao, facil).
local('Lapa do Seu Antao', [outono, inverno, primavera, verao], esporte, facil).

%estacoes
estacao(Dia, Mes, outono) :-
	Dia > 20, Dia =< 31, Mes >= 3, Mes =< 3;
	Dia >= 1, Dia =< 30, Mes >= 4, Mes =< 4;
	Dia >= 1, Dia =< 31, Mes >= 5, Mes =< 5;
	Dia >= 1, Dia =< 20, Mes =< 6, Mes >= 6.
estacao(Dia, Mes, inverno) :-
	Dia > 20, Dia =< 30, Mes >= 6, Mes =< 6;
	Dia >= 1, Dia =< 31, Mes >= 7, Mes =< 8;
	Dia >= 1, Dia =< 22, Mes >= 9, Mes =< 9.
estacao(Dia, Mes, primavera) :-
	Dia > 22, Dia =< 30, Mes >= 9, Mes =< 9;
	Dia >= 1, Dia =< 31, Mes >= 10, Mes =< 10;
	Dia >= 1, Dia =< 30, Mes >= 11, Mes =< 11;
	Dia >= 1, Dia =< 21, Mes >= 12, Mes =< 12.
estacao(Dia, Mes, verao) :-
	Dia > 21, Dia =<31, Mes >= 12, Mes =< 12;
	Dia >= 1, Dia =< 31, Mes >= 1, Mes =< 1;
	Dia >= 1, Dia =< 29, Mes >= 2, Mes =< 2;
	Dia >= 1, Dia =< 20, Mes >= 3, Mes =< 3.

% verifica se Estacao esta na lista de estacoes do local
contemEstacao(Estacao, [Estacao|_]).
contemEstacao(Estacao, [_|Y]) :- contemEstacao(Estacao, Y).

% retorna todos os locais com determinado Tipo (diversao, esporte), Estacao e Nivel (facil, medio, dificil)
locaisAdequados(Local, NivelDoLocal, Estacao, Tipo, dificil) :-
	local(Local, ListaEstacoes, Tipo, _), local(Local, ListaEstacoes, Tipo, NivelDoLocal), contemEstacao(Estacao, ListaEstacoes).
locaisAdequados(Local, NivelDoLocal, Estacao, Tipo, medio) :-
	local(Local, ListaEstacoes, Tipo, medio), local(Local, ListaEstacoes, Tipo, NivelDoLocal), contemEstacao(Estacao, ListaEstacoes);
	local(Local, ListaEstacoes, Tipo, facil), local(Local, ListaEstacoes, Tipo, NivelDoLocal), contemEstacao(Estacao, ListaEstacoes).
locaisAdequados(Local, NivelDoLocal, Estacao, Tipo, facil) :-
	local(Local, ListaEstacoes, Tipo, facil), local(Local, ListaEstacoes, Tipo, NivelDoLocal), contemEstacao(Estacao, ListaEstacoes).

% forma fisica
formaFisica(E, atletica) :- escalador(E, M), M >= 25.
formaFisica(E, media) :- escalador(E, M), M >= 10, M =< 24.
formaFisica(E, fraca) :- escalador(E, M), !, M < 10.
formaFisica(_, fraca). % nao cadastrado

% nivel de dificuldade
nivelDificuldade(HorasPratica, FormaFisica, dificil) :-
	HorasPratica >= 40, FormaFisica = atletica, !.
nivelDificuldade(HorasPratica, FormaFisica, medio) :-
        HorasPratica >= 16, FormaFisica = media; HorasPratica >= 16, FormaFisica = atletica, !.
nivelDificuldade(_,_, facil).

%principal
recomendarEscalada(Pessoa, HorasPratica, Tipo, DiaEntrada, MesEntrada, ListaRecomendada) :-
	%calcula a forma fisica da pessoa
	formaFisica(Pessoa, FormaFisica),

        %calcula o nivel de acordo com horas de pratica. saida: Nivel = facil || medio || dificil
        nivelDificuldade(HorasPratica, FormaFisica, NivelDoEscalador),

	% calcula a Estacao de acordo com Dia e Mes (saida: outono || inverno || primavera || verao)
	estacao(DiaEntrada, MesEntrada, Estacao),

	% pega os locais do tipo e nivel do escalador. saida: Locais
	findall((Local,NivelDoLocal), locaisAdequados(Local, NivelDoLocal, Estacao, Tipo, NivelDoEscalador), ListaRecomendada).
