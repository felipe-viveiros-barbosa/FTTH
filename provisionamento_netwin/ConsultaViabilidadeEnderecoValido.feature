@REQ_NETWIN-0001
Feature: Ordem de Ativacao

	@TEST_NETWIN-7_2_7
	Scenario Outline: Consulta de viabilidade Endereco Completo Valido 
       # Enviar uma consulta de viabilidade IDGPON (Inválido) + IdEndereco (Inválido) + Endereço completo (válido)
		Given Eu valido se somente o endereco completo e valido na pesquisa
    
    Examples:
        #EVL
		| idGponValid  | idEnderecoValid | UFValid       | codigoLocalidadeValid | codigoLogradouroValid | nFachadaValid | 
		| 4-83333IAU333|     78888877    |  MG           |       31000           |  5425                 | 1480          | 

