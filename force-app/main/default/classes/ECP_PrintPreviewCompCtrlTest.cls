@isTest
private class ECP_PrintPreviewCompCtrlTest {
  @testSetup
  static void setup() {
    System.runAs(createUser()) {
      ECP_PrintTemplate__c printTemplate = new ECP_PrintTemplate__c(
        templateName__c = 'TestTemplate',
        JsonConfigVal__c = '{"panels":[{"key1":"value1","key2":"value2"}]}'
      );
      insert printTemplate;

      ECP_PrinterManagement__c printerManagement = new ECP_PrinterManagement__c(
        Name = 'TestPrintService',
        ServiceUrl__c = 'https://example.com:8080',
        ContractId__c = '1111111'
      );
      insert printerManagement;
    }
  }

  @isTest
  static void Case1() {
    System.runAs(createUser()) {
      Test.startTest();
      ECP_PrintPreviewCompCtrl helper = new ECP_PrintPreviewCompCtrl();
      helper.printSeviceNameEcp = 'TestPrintService';
      helper.templateNameEcp = new List<String>{'TestTemplate'};
      helper.getInitAction();
      Test.stopTest();

      System.assertEquals('https://example.com:8080', helper.serviceURL);
    }
  }

  @isTest
  static void Case2() {
    System.runAs(createUser()) {
      Test.startTest();
      ECP_PrintPreviewCompCtrl helper = new ECP_PrintPreviewCompCtrl();
      helper.printSeviceNameEcp = 'TestPrintService';
      helper.templateNameEcp = new List<String>{'abc'};
      helper.getInitAction();
      Test.stopTest();

      System.assertEquals(null, helper.printConfigStr);
    }
  }

  @isTest
  static void Case3() {
    System.runAs(createUser()) {
      Test.startTest();
      ECP_PrintPreviewCompCtrl helper = new ECP_PrintPreviewCompCtrl();
      helper.printSeviceNameEcp = 'abc';
      helper.templateNameEcp = new List<String>{'TestTemplate'};
      helper.getInitAction();
      Test.stopTest();

      System.assertEquals(null, helper.serviceURL);
    }
  }

  @isTest
  static void Case4() {
    System.runAs(createUser()) {
      Test.startTest();
      ECP_PrintPreviewCompCtrl helper = new ECP_PrintPreviewCompCtrl();
      helper.printSeviceNameEcp = 'abc';
      helper.templateNameEcp = new List<String>{'abc'};
      helper.getInitAction();
      Test.stopTest();

      System.assertEquals(null, helper.printConfigStr);
      System.assertEquals(null, helper.serviceURL);
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