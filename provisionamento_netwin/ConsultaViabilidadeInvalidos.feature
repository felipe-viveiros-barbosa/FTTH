@REQ_NETWIN-0001
Feature: Ordem de Ativacao

	@TEST_NETWIN-7_2_7
	Scenario Outline: Consulta de viabilidade invalido
       # Enviar uma consulta de viabilidade IDGPON (Inválido) + IdEndereco (Inválido) + Endereço completo (Inválido)
		Given Eu valido se a pesquisa de viabilidade nao retorna nenhum resultado
   
    Examples:
        #EVL
		| idGponValid  | idEnderecoValid | UFValid       | codigoLocalidadeValid | codigoLogradouroValid | nFachadaValid | 
		| 4-0000001    |     46638496    |  MG           |       31000           |  3272                 | 55555         | 

