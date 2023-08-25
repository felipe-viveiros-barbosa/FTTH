@REQ_NETWIN-0005
Feature: Cessar Ordem
	Cancelamento dos servicos apos o pedido ser finalizado 

	@TEST_NETWIN-7_2_7
	Scenario Outline: Criacao, Fechamento e Cancelamento da Ordem
		#Given the address of client with id "<addressId>" in station "<station>" its valid
		Given Eu valido se o idEndereco e valido
		And I set bundle name for each service
			| CFS.HSI | CFS.IPTV | CFS.RFTV | CFS.VOIP |
			|<BND.HSI>|<BND.IPTV>|<BND.RFTV>|<BND.VOIP>|
		Then I create one activation order with the services
			| CFS.HSI | CFS.IPTV | CFS.RFTV | CFS.VOIP |
			|<CFS.HSI>|<CFS.IPTV>|<CFS.RFTV>|<CFS.VOIP>|
		And I finish the order
		And I cease the order 
		Then Eu faco a consulta para o GPON apos Cessar

	Examples:
		| addressId | station | CFS.IPTV | CFS.HSI | CFS.RFTV | CFS.VOIP |   BND.HSI    |    BND.IPTV    |     BND.RFTV    |    BND.VOIP      |
	#	|  1821213  |   LEB   |    X     |         |     X    |    X     | VELOC_50MBPS | PCT_CANAL_IPTV | PCT_CANAL_RF_RF | OIVOIP_ILIMITADO |
		|		    |         |    X     |         |     X    |    X     | VELOC_5MBPS | PCT_CANAL_IPTV | PCT_CANAL_RF_RF | OIVOIP_ILIMITADO |
