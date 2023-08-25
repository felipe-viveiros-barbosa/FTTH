@REQ_NETWIN-0002
Feature: Ordem de Mudanca de Combo
	Criacao da ordem de alteracao do pacote de servicos logicos

	@TEST_NETWIN-7_2_7
	Scenario Outline: Criacao e Alteracao da Ordem
		#Given the address of client with id "<addressId>" in station "<station>" its valid
		Given Eu valido se o idEndereco e valido
		And I set bundle name for each service
			| CFS.HSI | CFS.IPTV | CFS.RFTV | CFS.VOIP |
			|<BND.HSI>|<BND.IPTV>|<BND.RFTV>|<BND.VOIP>|
		Then I create one activation order with the services
			| CFS.HSI | CFS.IPTV | CFS.RFTV | CFS.VOIP |
			|<CFS.HSI>|<CFS.IPTV>|<CFS.RFTV>|<CFS.VOIP>|
		And I make a service GPON query
		
		And I validate "NETQ" data from "CFS.ACESSOGPON" query at "om"
		And I validate "NETQ" data from "CFS.IPTV" query at "om"
		And I validate "NETQ" data from "CFS.HSI" query at "om"
		And I validate "NETQ" data from "CFS.VOIP" query at "om"
		And I validate "OM" data from "CFS.ACESSOGPON" query at "om"
		And I validate "OM" data from "CFS.IPTV" query at "om"
		And I validate "OM" data from "CFS.HSI" query at "om"
		And I validate "OM" data from "CFS.VOIP" query at "om"

		#And I validade data from "CFS.IPTV" query 
		#And I validade data from "CFS.HSI" query 
		#And I validade data from "CFS.VOIP" query 
		And I validade data from "CFS.RFTV" query 
		
		And I finish the order 
		Then I create one change order with the services
			| CFS.HSI | CFS.IPTV | CFS.RFTV | CFS.VOIP |
			|<ACT.HSI>|<ACT.IPTV>|<ACT.RFTV>|<ACT.VOIP>|
		And I validade data from "CFS.IPTV" query after change order 
		And I validade data from "CFS.HSI" query after change order 
		And I validade data from "CFS.VOIP" query after change order 
		And I validade data from "CFS.RFTV" query after change order 
		And I finish the order

	Examples:
		| addressId | station | CFS.IPTV | CFS.HSI | CFS.RFTV | CFS.VOIP               | ACT.HSI               | ACT.IPTV | ACT.RFTV  |       ACT.VOIP     |   BND.HSI    |    BND.IPTV    |     BND.RFTV    |    BND.VOIP      |
#		|      311819     |      |    X     |    X    |     X    |    X     | CESSAR.MUDANCA_COMBO  |          |           | ALTERAR.OI LIGADOR | VELOC_50MBPS | PCT_CANAL_IPTV | PCT_CANAL_RF_RF | OIVOIP_ILIMITADO |
		|    |      |    X     |    X    |     X    |    X     | CESSAR.MUDANCA_COMBO  |          |           | ALTERAR.OI LIGADOR | VELOC_5MBPS | PCT_CANAL_IPTV | PCT_CANAL_RF_RF | OIVOIP_ILIMITADO |
#		|           |  LEB    |          |    X    |          |          | ALTERAR.VELOC_100MBPS | ACTIVAR.PCT_CANAL_IPTV | ACTIVAR.PCT_CANAL_RF_RF |                    | VELOC_50MBPS |                |                 |                  |
