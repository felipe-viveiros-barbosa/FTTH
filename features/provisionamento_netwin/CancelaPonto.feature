@REQ_NETWIN-0007
Feature: Adicionamento e Cancelamento de Um Novo Ponto de TV
	Criacao da ordem de ativacao, finalizacao da ordem, contratacao de 1 ou mais pontos e cancelamento de 1 ou mais pontos.

	@TEST_NETWIN-7_2_7
	Scenario Outline: Criacao da Ordem, Contratacao e Cancelamento de Pontos
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

		#And I validade data from "CFS.IPTV" query 
		And I finish the order 
		Then I contract new TV points with the serial number "<Serial Number>"
		And I cancel the TV points with serial number "<Serial Number>"

	Examples:
		| addressId   | station | CFS.IPTV |    BND.IPTV    | Serial Number |
	#	|      311818 |         |    X     | PCT_CANAL_IPTV |               |
		|             |         |    X     | PCT_CANAL_IPTV |               | 

