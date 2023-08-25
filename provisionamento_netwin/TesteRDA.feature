@REQ_NETWIN-0001
Feature: Ordem de Ativacao

  @TEST_NETWIN-7_2_7
  Scenario Outline: Criacao da Ordem
    Given the address of client with id "<addressId>" in station "<station>" its valid
    And I set bundle name for each service
      | CFS.HSI   | CFS.IPTV   | CFS.RFTV   | CFS.VOIP   |
      | <BND.HSI> | <BND.IPTV> | <BND.RFTV> | <BND.VOIP> |
    Then I create one activation order with the services
      | CFS.HSI   | CFS.IPTV   | CFS.RFTV   | CFS.VOIP   |
      | <CFS.HSI> | <CFS.IPTV> | <CFS.RFTV> | <CFS.VOIP> |
    And I make a service GPON query teste

    Examples:
      | addressId | station | CFS.IPTV | CFS.HSI | CFS.RFTV | CFS.VOIP | BND.HSI      | BND.IPTV       | BND.RFTV               | BND.VOIP         |
      |           |         | X        | X       | X        | X        | VELOC_50MBPS | PCT_CANAL_IPTV | PCT_CANeu tenhAL_RF_RF | OIVOIP_ILIMITADO |