@isTest
private class ECP_PrintServiceManageCtrlTest {
  @isTest
  static void Case1() {
    System.runAs(createUser()) {
      ECP_PrinterManagement__c printerManagement1 = new ECP_PrinterManagement__c(
        ServiceUrl__c = 'https://example.com:8080',
        RecordTypeId = SObjectType.ECP_PrinterManagement__c.getRecordTypeInfosByDeveloperName()
          .get('ByCloud')
          .getRecordTypeId(),
        ContractId__c = '11111111'
      );
      insert printerManagement1;

      Test.startTest();
      ApexPages.StandardController control = new ApexPages.StandardController(
        printerManagement1
      );
      ECP_PrintServiceManageCtrl controller = new ECP_PrintServiceManageCtrl(
        control
      );
      controller.initAction();
      Test.stopTest();

      System.assertEquals('https://example.com:8080', controller.serviceUrl);
      System.assertEquals('example.com', controller.localIp);
      System.assertEquals('http://example.com:3000', controller.cerDownloadIp);
      System.assertEquals(true, controller.cloudFlg);
    }
  }

  @isTest
  static void Case2() {
    System.runAs(createUser()) {
      ECP_PrinterManagement__c printerManagement2 = new ECP_PrinterManagement__c(
        ServiceUrl__c = 'https://example.com:8080'
      );
      insert printerManagement2;

      Test.startTest();
      ApexPages.StandardController control = new ApexPages.StandardController(
        printerManagement2
      );
      ECP_PrintServiceManageCtrl controller = new ECP_PrintServiceManageCtrl(
        control
      );
      controller.initAction();
      Test.stopTest();

      System.assertEquals('https://example.com:8080', controller.serviceUrl);
      System.assertEquals('example.com', controller.localIp);
      System.assertEquals('http://example.com:3000', controller.cerDownloadIp);
      System.assertEquals(false, controller.cloudFlg);
    }
  }

  @isTest
  static void Case3() {
    System.runAs(createUser()) {
      Test.startTest();
      ApexPages.StandardController control = new ApexPages.StandardController(
        new ECP_PrinterManagement__c()
      );
      ECP_PrintServiceManageCtrl controller = new ECP_PrintServiceManageCtrl(
        control
      );
      controller.initAction();
      ECP_PrintServiceManageCtrl.getDesignerUrl();
      Test.stopTest();

      System.assertEquals(null, controller.token);
    }
  }
  private static User createUser() {
    String uniqueUserName =
      'standarduser' +
      DateTime.now().getTime() +
      '@testorg.com';
    // // This code runs as the system user
    List<String> profileNames = new List<String>{
      'System Administrator',
      'システム管理者',
      '系统管理员'};
    Profile p = [SELECT Id FROM Profile WHERE Name in :profileNames limit 1];

    User u = new User(
      Alias = 'standt',
      Email = 'standarduser@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = uniqueUserName
    );
    insert u;
    List<ObjectPermissions> ps = [
      SELECT Id, Parent.Id
      FROM ObjectPermissions
      WHERE Parent.Name = :'ecpAdmin'
    ];

    // Given mocked Permission Set assigned to user for test
    PermissionSetAssignment psa = new PermissionSetAssignment(
      AssigneeId = u.id,
      PermissionSetId = ps[0].Parent.Id
    );
    insert psa;
    return u;
  }
}