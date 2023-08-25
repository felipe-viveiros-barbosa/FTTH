@REQ_NETWIN-0001
Feature: Ordem de Ativacao

	@TEST_NETWIN-7_2_7
	Scenario Outline: Consulta de viabilidade IdGpon Valido 
       # Enviar uma consulta de viabilidade IDGPON (válido) + IdEndereco (válido) + Endereço completo (válido)
		Given Eu valido se o idGpon retorna viabilidade
    
    Examples:
        #EVL
		| idGponValid  | idEnderecoValid | UFValid       | codigoLocalidadeValid | codigoLogradouroValid | nFachadaValid | 
		| 4-8IAUGE1    |     289351      |  MG           |       31000           |  5425                 | 1480          | 

