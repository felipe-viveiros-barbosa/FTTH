@REQ_NETWIN-0003
Feature: Ordem de Mudanca de Endereco
	Criacao da ordem de alteracao do endereco do cliente

	@TEST_NETWIN-7_2_7
	Scenario Outline: Criacao da Ordem e Alteracao do Endereco
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
		
		And I make the order update CPE
		And I make the order update CR
		And I finish the order

		And I validate "NETQ" data from "CFS.ACESSOGPON" query at "om"
		#And I validate NETQ data from "CFS.ACESSOGPON" query at "om"

		Given the address of client with id "<newAddressId>" in station "<newStation>" its valid
		Then I create one change address order
		And I make a service GPON query
	
		# #And I validate "OM" data from "CFS.IPTV" query at "om"
		# And I validade data from "CFS.IPTV" query
	
		# And I make the order update CPE after change address
		# And I finish the order
		
		# And I validate "NETQ" data from "CFS.ACESSOGPON" query at "inventory"
		# And I validate "NETQ" data from "CFS.IPTV" query at "inventory"
		# And I validate "NETQ" data from "CFS.HSI" query at "inventory"
		# And I validate "NETQ" data from "CFS.VOIP" query at "inventory"
		# And I validate "OM" data from "CFS.ACESSOGPON" query at "inventory"
		# And I validate "OM" data from "CFS.IPTV" query at "inventory"
		# And I validate "OM" data from "CFS.HSI" query at "inventory"
		# And I validate "OM" data from "CFS.VOIP" query at "inventory"

		# And I validate "NETQ" data from "CFS.ACESSOGPON" query at "inventory"
		# And I validate physical inventory
		# #And I validate inventory data from "CFS.IPTV" query
		# #And I validate inventory data from "CFS.HSI" query
		# #And I validate inventory data from "CFS.VOIP" query
		# And I validate inventory data from "CFS.RFTV" query

	Examples:
		| addressId | newAddressId | station | newStation | CFS.IPTV | CFS.HSI | CFS.RFTV | CFS.VOIP |   BND.HSI    |    BND.IPTV    |     BND.RFTV    |    BND.VOIP      |
	#	|      311819     |      994600        |     BEL | BGU         |    X     |    X    |     X    |    X     | VELOC_50MBPS | PCT_CANAL_IPTV | PCT_CANAL_RF_RF | OIVOIP_ILIMITADO |
		|           |       |         |        |    X     |    X    |     X    |    X     | VELOC_5MBPS | PCT_CANAL_IPTV | PCT_CANAL_RF_RF | OIVOIP_ILIMITADO |
	#	|           |              |   LEB   |    LEB     |    X     |    X    |     X    |    X     | VELOC_50MBPS | PCT_CANAL_IPTV | PCT_CANAL_RF_RF | OIVOIP_ILIMITADO |
	#	|           |              |   LEB   |    LEB     |    X     |    X    |     X    |    X     | VELOC_50MBPS | PCT_CANAL_IPTV | PCT_CANAL_RF_RF | OIVOIP_ILIMITADO |