@REQ_NETWIN-0004
Feature: Adicionamento de Um Novo Ponto de TV
	Criacao da ordem de ativacao, finalizacao da ordem, contratacao de 1 ou mais pontos..

	@TEST_NETWIN-7_2_7
	Scenario Outline: Criacao da Ordem e Contratacao Pontos
 		#Given the address of client with id "<addressId>" in station "<station>" its valid
		Given Eu valido se o idEndereco e valido
		And I set bundle name for each service
			 | CFS.IPTV |
		  	 |<BND.IPTV>|
		Then I create one activation order with the services
			| CFS.IPTV |
			|<CFS.IPTV>|
		And I make a service GPON query

		And I validate "NETQ" data from "CFS.IPTV" query at "om"
		And I validate "OM" data from "CFS.IPTV" query at "om"      
		
		And I validade data from "CFS.IPTV" query 
		And I finish the order 
		Then I contract new TV points with the serial number "<Serial Aditional>"

	Examples:
		| addressId | station | CFS.IPTV |    BND.IPTV    |               Serial Aditional                 |
	#	|      311819     |         |    X     | PCT_CANAL_IPTV | NSSTB201713011, NSSTB201713012, NSSTB201713013 |  
	#	|  1821213  |   LEB   |    X     | PCT_CANAL_IPTV | NSSTB201713011, NSSTB201713012, NSSTB201713013 |        
	   |           |      |    X     | PCT_CANAL_IPTV | NSSTB201713011, NSSTB201713012, NSSTB201713013 |