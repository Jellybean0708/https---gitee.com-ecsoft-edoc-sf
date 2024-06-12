public with sharing class ECP_TemplateDesignerCompCtrl {
  public String templateId { get; set; }
  public String isClone { get; set; }

  public transient String templateName { get; private set; }
  public transient String printDataStr { get; private set; }
  public transient String printConfigStr { get; private set; }
  public transient String templateCenterPath { get; private set; }
  public transient String fullScreenUrl { get; private set; }
  public transient String fullScreenMode { get; private set; }
  public transient String exitFullScreenUrl { get; private set; }
  public transient String logoLink { get; private set; }
  /**
   * componet init action
   */
  public String getInitAction() {
    // 既存定義情報を取得する
    ECP_PrintTemplate__c template = getPrintDetailCtrlById(templateId);
    // 新規＆編集場合
    String clone = ApexPages.currentPage().getParameters().get('clone');
    fullScreenMode = ApexPages.currentPage().getParameters().get('fullScreen');
    if (String.isBlank(clone)) {
      templateName = template.TemplateName__c;
    }
    if (String.isBlank(templateName)) {
        String uuid = String.valueOf(System.UUID.randomUUID()).substring(0, 8);
        templateName= 'ECP-' + Datetime.now().format('yyyyMMdd') + uuid;
    }
    // テンプレートサンプルデータ
    printDataStr = String.isBlank(template.JsonDataVal__c)
      ? '{}'
      : template.JsonDataVal__c;
    // テンプレート定義情報
    printConfigStr = String.isBlank(template.JsonConfigVal__c)
      ? '{}'
      : template.JsonConfigVal__c;
    // カスタマ設定情報取得
    templateCenterPath = ECP_TemplateCenterSetting__c.getOrgDefaults()
      .TemplateCenterUrl__c;
    // 全屏显示URL取得
    PageReference pageRef = Page.ecp_templateDesignerPage;
    pageRef.getParameters().put('id', templateId);
    pageRef.getParameters().put('clone', String.isBlank(clone) ? '':'1');
    pageRef.getParameters().put('fullScreen', String.isBlank(fullScreenMode) ? '1':'');
    // 退出全屏URL
    String objectApiName = SObjectType.ECP_PrintTemplate__c.getName(); 
    exitFullScreenUrl = String.isBlank(templateId) ? '/lightning/o/' + objectApiName + '/new?count=1' : '/lightning/r/' + objectApiName + '/' + templateId + '/edit';

    String listViewDeveloperName = 'ALL'; 
    SObjectAccessDecision templateSecurity = Security.stripInaccessible(
      AccessType.READABLE, [SELECT Id, DeveloperName FROM ListView WHERE SObjectType = :objectApiName AND DeveloperName = :listViewDeveloperName LIMIT 1]);
    List<ListView> listViews = (List<ListView>) templateSecurity.getRecords();
    
    String listViewId = listViews[0].Id;
    logoLink = '/lightning/o/' + objectApiName + '/list?filterName=' + listViewId;
    fullScreenUrl = pageRef.getUrl();
    return '';
  }
  /**
   * 既存テンプレート定義情報を取得する
   */
  private ECP_PrintTemplate__c getPrintDetailCtrlById(String templateId) {
    SObjectAccessDecision templateSecurity = Security.stripInaccessible(
      AccessType.READABLE,
      [
        SELECT Id, JsonDataVal__c, JsonConfigVal__c, TemplateName__c
        FROM ECP_PrintTemplate__c
        WHERE id = :templateId WITH SECURITY_ENFORCED
      ]
    );
    List<ECP_PrintTemplate__c> ret = (List<ECP_PrintTemplate__c>) templateSecurity.getRecords();
    return ret.isEmpty() ? new ECP_PrintTemplate__c() : ret[0];
  }
  /**
   * テンプレートデータを保存します。
   */
  @RemoteAction
  public static Map<String, String> saveTemplateData(
    String dataJson,
    String testDataJson,
    String templateNameValue,
    String modifytemplateId,
    String isClone
  ) {
    Map<String, String> resultMap = new Map<String,String>();
    String errorMsg = '';
    // 印刷テンプレートを取得する
    SObjectAccessDecision templatesSecurity = Security.stripInaccessible(
      AccessType.READABLE,
      [
        SELECT Id, templateName__c FROM ECP_PrintTemplate__c WHERE templateName__c = :templateNameValue WITH SECURITY_ENFORCED
      ]
    );
    List<ECP_PrintTemplate__c> existsTemplates = (List<ECP_PrintTemplate__c>) templatesSecurity.getRecords();

    ECP_PrintTemplate__c printTemplate = new ECP_PrintTemplate__c();
    List<ECP_PrintTemplate__c> printTemplates = new List<ECP_PrintTemplate__c>();
    System.debug('modifytemplateId:' + modifytemplateId);
    System.debug('isClone:' + isClone);
    Map<String, Object> configDataMap = (Map<String, Object>) JSON.deserializeUntyped(
      dataJson
    );
    Object printElements = configDataMap.get('panels');
    List<Object> panels = (List<Object>) printElements;
    if (panels != null && panels.size() > 0) {
      Map<String, Object> configMap = (Map<String, Object>) panels[0];
      printTemplate.PaperWidth__c = (Integer) configMap.get('width');
      printTemplate.PaperHeight__c = (Integer) configMap.get('height');
      printTemplate.PaperSize__c = (String) configMap.get('paperType');
    }
    printTemplate.JsonConfigVal__c = dataJson;
    printTemplate.JsonDataVal__c = testDataJson;
    printTemplate.TemplateName__c = templateNameValue;
    if (modifytemplateId != null && modifytemplateId != '' && isClone != '1') {
      if(existsTemplates.size() > 0 && existsTemplates[0].id != modifytemplateId){
        errorMsg = 'Name Error';
      }else{
        printTemplate.id = modifytemplateId;
        printTemplates.add(printTemplate);
        SObjectAccessDecision securityDecision = Security.stripInaccessible(
          AccessType.UPDATABLE,
          printTemplates
        );
        update securityDecision.getRecords();
      }
    } else {
      if(existsTemplates.size() > 0){
        errorMsg = 'Name Error';
      }else{
        printTemplates.add(printTemplate);
        SObjectAccessDecision securityDecision = Security.stripInaccessible(
          AccessType.CREATABLE,
          printTemplates
        );
        insert securityDecision.getRecords();
        modifytemplateId = securityDecision.getRecords()[0].id;
      }
    }
    resultMap.put('modifytemplateId',modifytemplateId);
    resultMap.put('errorMsg',errorMsg);
    return resultMap;
  }
}