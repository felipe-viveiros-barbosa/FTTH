@REQ_NETWIN-0001
Feature: Consulta Viabilidade

	@TEST_NETWIN-7_2_7
	Scenario Outline: Consulta de viabilidade Endereco Completo Valido      
		Given Eu valido se a consulta de viabilidade por endereco completo e valida
    
    Examples:
        #EVL / MIG
		| ufValid       | codigoLocalidadeValid | codigoLogradouroValid | nFachadaValid | 
		|  MG           |       31000           |  5425                 | 1480          | 
        #TRG
        #|  RJ           |       21000           |  217                  | 272           |
        #TI



