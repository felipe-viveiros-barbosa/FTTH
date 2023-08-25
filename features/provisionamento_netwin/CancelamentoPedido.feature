@REQ_NETWIN-0006
Feature: Cancelamento de Pedido
	Cancelamento de uma ordem de ativacao 

	@TEST_NETWIN-7_2_7
	Scenario Outline: Cancelamento da Ordem de Servicos
		#Given the address of client with id "<addressId>" in station "<station>" its valid
		Given Eu valido se o idEndereco e valido
		And I set bundle name for each service
			| CFS.HSI | CFS.IPTV | CFS.RFTV | CFS.VOIP |
			|<BND.HSI>|<BND.IPTV>|<BND.RFTV>|<BND.VOIP>|
		Then I create one activation order with the services
			| CFS.HSI | CFS.IPTV | CFS.RFTV | CFS.VOIP |
			|<CFS.HSI>|<CFS.IPTV>|<CFS.RFTV>|<CFS.VOIP>|
		And I abort the order 

	Examples:
		| addressId | station | CFS.IPTV | CFS.HSI | CFS.RFTV | CFS.VOIP |   BND.HSI    |    BND.IPTV    |     BND.RFTV    |    BND.VOIP      |
	#   |  1821213  |   LEB   |    X     |         |     X    |    X     | VELOC_50MBPS | PCT_CANAL_IPTV | PCT_CANAL_RF_RF | OIVOIP_ILIMITADO |
		|           |         |    X     |         |     X    |    X     | VELOC_5MBPS | PCT_CANAL_IPTV | PCT_CANAL_RF_RF | OIVOIP_ILIMITADO |
