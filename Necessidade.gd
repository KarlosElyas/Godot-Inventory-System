class_name Necessidade

var valor_atual
var maximo
var queda

func _init(maximo_, queda_):
	self.valor_atual = maximo_
	self.maximo = maximo_
	self.queda = queda_

func incrementar(valor : float) -> float:
	valor_atual = valor_atual + valor if valor_atual + valor < maximo else maximo
	return valor_atual

func decrementar(valor : float) -> float:
	valor_atual = valor_atual - valor if valor_atual - valor > 0 else 0
	return valor_atual
