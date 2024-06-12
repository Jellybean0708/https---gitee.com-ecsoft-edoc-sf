public with sharing class ECP_PrintServiceManageCtrl {
  // 契約ID
  public String token { get; set; }
  // サービスURL
  public String serviceUrl { get; set; }
  // クラウド接続 Flag
  public Boolean cloudFlg { get; set; }
  // サービスIP
  public String localIp { get; set; }
  // 証明書ダウンロードURL
  public String cerDownloadIp { get; set; }
  // レコードタイプ- クラウド接続
  private static String BY_CLOUD = 'ByCloud';
  // レコードタイプ- クラウド接続
  private String manageId { get; set; }

  public ECP_PrintServiceManageCtrl(ApexPages.StandardController controller) {
    manageId = controller.getId();
  }

  public void initAction() {
    SObjectAccessDecision printerSecurity = Security.stripInaccessible(
      AccessType.READABLE,
      [
        SELECT Id, RecordType.DeveloperName, ServiceUrl__c, ContractId__c
        FROM ECP_PrinterManagement__c
        WHERE id = :manageId
      ]
    );
    List<ECP_PrinterManagement__c> settingList = (List<ECP_PrinterManagement__c>) printerSecurity.getRecords();

    if (!settingList.isEmpty()) {

      system.debug('settingList====>' + settingList);
      token = settingList[0].ContractId__c;
      serviceUrl = settingList[0].ServiceUrl__c;

      if (serviceUrl != null && serviceUrl.contains('://')) {
        localIp = serviceUrl.substring(
          serviceUrl.indexOf('//') + 2,
          serviceUrl.indexOf(':', serviceUrl.indexOf('//') + 2)
        );
        cerDownloadIp = 'http://' + localIp + ':3000';
      }
      if (BY_CLOUD == settingList[0].RecordType.DeveloperName) {
        cloudFlg = true;
      } else {
        cloudFlg = false;
      }
      system.debug('recordName====>' + settingList[0].RecordType.DeveloperName);
    }
  }

  @AuraEnabled(cacheable=true)
  public static String getDesignerUrl(){
    PageReference pageRef = Page.ecp_templateDesignerPage;
    pageRef.getParameters().put('fullScreen', '1');
    return pageRef.getUrl();
  }
}