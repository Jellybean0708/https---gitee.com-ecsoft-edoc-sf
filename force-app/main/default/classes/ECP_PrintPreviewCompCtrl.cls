public with sharing class ECP_PrintPreviewCompCtrl {
  // 印刷サービス名
  public String printSeviceNameEcp { get; set; }
  // 印刷テンプレート名
  public List<String> templateNameEcp { get; set; }
  // 印刷テンプレート  テンプレート配置
  public String printConfigStr { get; set; }
  // サービスURL(本地打印)
  public String serviceURL { get; set; }
  // 契约Id(云打印)
  public String contractId { get; set; }
  // CSS URL
  public String cssBaseUrl { get; set; }

  public String getInitAction() {
    cssBaseUrl = ECP_TemplateCenterSetting__c.getOrgDefaults()
      .TemplateCenterUrl__c;
    // 印刷テンプレート
    SObjectAccessDecision templatesSecurity = Security.stripInaccessible(
      AccessType.READABLE,
      [
        SELECT Id, templateName__c, JsonConfigVal__c
        FROM ECP_PrintTemplate__c
        WHERE templateName__c = :templateNameEcp
      ]
    );
    List<ECP_PrintTemplate__c> templates = (List<ECP_PrintTemplate__c>) templatesSecurity.getRecords();
     if(templates.isEmpty()){
      return '印刷テンプレート名だ見つかりませんでした';
    }
    // 查询结果排序
    Map<String, ECP_PrintTemplate__c> templateMap = new Map<String, ECP_PrintTemplate__c>();
    for (ECP_PrintTemplate__c template : templates) {
        templateMap.put(template.templateName__c, template);
    }
    List<ECP_PrintTemplate__c> sortedTemplates = new List<ECP_PrintTemplate__c>();
    for (String name : templateNameEcp) {
      if(templateMap.get(name) != null){
        sortedTemplates.add(templateMap.get(name));
      }
    }

    // 合并panels
    List<Object> mergedPanels = new List<Object>();
    for(ECP_PrintTemplate__c t : sortedTemplates){
      Map<String, Object> map1 = (Map<String, Object>) JSON.deserializeUntyped(t.JsonConfigVal__c);
      List<Object> panels1 = (List<Object>) map1.get('panels');
      mergedPanels.addAll(panels1);
    }
    Map<String, Object> mergedMap = new Map<String, Object>();
    mergedMap.put('panels', mergedPanels);

    printConfigStr = JSON.serialize(mergedMap);
    
    // 印刷サービス
    SObjectAccessDecision serviceSecurity = Security.stripInaccessible(
      AccessType.READABLE,
      [
        SELECT Id, ServiceUrl__c, ContractId__c
        FROM ECP_PrinterManagement__c
        WHERE Name = :printSeviceNameEcp
      ]
    );

    List<ECP_PrinterManagement__c> printSevices = (List<ECP_PrinterManagement__c>) serviceSecurity.getRecords();
    if (printSevices != null && !printSevices.isEmpty()) {
      // 印刷サービス  サービスURL
      serviceURL = printSevices[0].ServiceUrl__c;
      // 印刷サービス  契约Id
      contractId = printSevices[0].ContractId__c;
    } else{
      return '印刷サービスだ見つかりませんでした';
    }
    return '';
  }
}