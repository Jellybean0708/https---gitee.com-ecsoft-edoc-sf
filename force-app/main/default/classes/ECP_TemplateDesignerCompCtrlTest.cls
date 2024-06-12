@isTest
private class ECP_TemplateDesignerCompCtrlTest {
  @isTest
  static void Case2() {
    System.runAs(createUser()) {
      ECP_PrintTemplate__c testTemplate = new ECP_PrintTemplate__c(
        TemplateName__c = 'Test Template1'
      );
      insert testTemplate;

      Test.startTest();
      ECP_TemplateDesignerCompCtrl controller = new ECP_TemplateDesignerCompCtrl();
      controller.templateId = testTemplate.Id;
      controller.getInitAction();
      Test.stopTest();
      System.assertEquals(
        testTemplate.TemplateName__c,
        controller.templateName
      );
    }
  }

  @isTest
  static void Case3() {
    System.runAs(createUser()) {
      ECP_PrintTemplate__c testTemplate2 = new ECP_PrintTemplate__c(
        TemplateName__c = 'Test Template2',
        JsonDataVal__c = '{"data":"testkey"}',
        JsonConfigVal__c = '{"config":"testconfig"}'
      );
      insert testTemplate2;
      Test.startTest();
      ECP_TemplateDesignerCompCtrl controller = new ECP_TemplateDesignerCompCtrl();
      controller.templateId = testTemplate2.Id;
      controller.isClone = '1';
      controller.getInitAction();
      Test.stopTest();
      System.assertEquals(
        testTemplate2.JsonDataVal__c,
        controller.printDataStr
      );
      System.assertEquals(
        testTemplate2.JsonConfigVal__c,
        controller.printConfigStr
      );
    }
  }

  @isTest
  static void Case4() {
    System.runAs(createUser()) {
      String testDataJson = '{"data": "Test Data"}';
      String dataJson = '{"config": "Test Config"}';
      String templateName = 'Test Template';
      String modifytemplateId = null;
      String isClone = '';

      String savedTemplateId = ECP_TemplateDesignerCompCtrl.saveTemplateData(
        testDataJson,
        dataJson,
        templateName,
        modifytemplateId,
        isClone
      ).get('modifytemplateId');
      ECP_PrintTemplate__c savedTemplate = [
        SELECT JsonConfigVal__c, JsonDataVal__c, TemplateName__c
        FROM ECP_PrintTemplate__c
        WHERE Id = :savedTemplateId
      ];

      System.assertNotEquals(null, savedTemplateId);
      System.assertEquals('Test Template', savedTemplate.TemplateName__c);
      System.assertEquals(
        '{"data": "Test Data"}',
        savedTemplate.JsonConfigVal__c
      );
      System.assertEquals(
        '{"config": "Test Config"}',
        savedTemplate.JsonDataVal__c
      );
    }
  }

  @isTest
  static void Case5() {
    System.runAs(createUser()) {
      ECP_PrintTemplate__c testTemplate3 = new ECP_PrintTemplate__c(
        TemplateName__c = 'Test Template3'
      );
      insert testTemplate3;

      // ApexPages.StandardController control = new ApexPages.StandardController(testTemplate3);
      // ECP_TemplateDesignerCtrl controller = new ECP_TemplateDesignerCtrl(control);
      String dataJson = '{"panels":[{"width":150, "height":250, "paperType":"A3"}]}';
      String configJson = '{"config": "Test Config"}';
      String templateName = 'Edited Template';
      String modifytemplateId = testTemplate3.Id;
      String isClone = '0';

      Test.startTest();
      String savedTemplateId = ECP_TemplateDesignerCompCtrl.saveTemplateData(
        dataJson,
        configJson,
        templateName,
        modifytemplateId,
        isClone
      ).get('modifytemplateId');
      Test.stopTest();

      ECP_PrintTemplate__c savedTemplate = [
        SELECT PaperWidth__c, PaperHeight__c, PaperSize__c, TemplateName__c
        FROM ECP_PrintTemplate__c
        WHERE Id = :savedTemplateId
      ];

      System.assertEquals('Edited Template', savedTemplate.TemplateName__c);
      System.assertEquals(150, savedTemplate.PaperWidth__c);
      System.assertEquals(250, savedTemplate.PaperHeight__c);
      System.assertEquals('A3', savedTemplate.PaperSize__c);
    }
  }
  @isTest
  static void Case6() {
    System.runAs(createUser()) {
      ECP_PrintTemplate__c originalTemplate = new ECP_PrintTemplate__c(
        TemplateName__c = 'Original Template'
      );
      insert originalTemplate;

      String modifytemplateId = originalTemplate.Id;
      String isClone = '1';
      String dataJson = '{"data": "Test Data"}';
      String testDataJson = '{"config": "Test Config"}';
      String templateNameValue = 'Cloned Template';

      String savedTemplateId = ECP_TemplateDesignerCompCtrl.saveTemplateData(
        dataJson,
        testDataJson,
        templateNameValue,
        modifytemplateId,
        isClone
      ).get('modifytemplateId');

      System.assertNotEquals(null, savedTemplateId);

      ECP_PrintTemplate__c clonedTemplate = [
        SELECT Id, JsonDataVal__c, JsonConfigVal__c, TemplateName__c
        FROM ECP_PrintTemplate__c
        WHERE Id = :savedTemplateId
      ];

      System.assertEquals(testDataJson, clonedTemplate.JsonDataVal__c);
      System.assertEquals(dataJson, clonedTemplate.JsonConfigVal__c);
      System.assertEquals(templateNameValue, clonedTemplate.TemplateName__c);
    }
  }
  @isTest
  static void Case7() {
    System.runAs(createUser()) {
      ECP_PrintTemplate__c originalTemplate = new ECP_PrintTemplate__c(
        TemplateName__c = 'Original Template'
      );
      insert originalTemplate;

      String modifytemplateId = originalTemplate.Id;
      String isClone = '1';
      String dataJson = '{"data": "Test Data"}';
      String testDataJson = '{"config": "Test Config"}';
      String templateNameValue = 'Original Template';

      String errorMsg = ECP_TemplateDesignerCompCtrl.saveTemplateData(
        dataJson,
        testDataJson,
        templateNameValue,
        modifytemplateId,
        isClone
      ).get('errorMsg');

      System.assertEquals(errorMsg, 'Name Error');
    }
  }
  @isTest
  static void Case8() {
    System.runAs(createUser()) {
      ECP_PrintTemplate__c originalTemplate = new ECP_PrintTemplate__c(
        TemplateName__c = 'Original Template'
      );
      insert originalTemplate;
      ECP_PrintTemplate__c testTemplate3 = new ECP_PrintTemplate__c(
        TemplateName__c = 'Test Template3'
      );
      insert testTemplate3;
      String dataJson = '{"panels":[{"width":150, "height":250, "paperType":"A3"}]}';
      String configJson = '{"config": "Test Config"}';
      String templateName = 'Original Template';
      String modifytemplateId = testTemplate3.Id;
      String isClone = '0';

      Test.startTest();
      String errorMsg = ECP_TemplateDesignerCompCtrl.saveTemplateData(
        dataJson,
        configJson,
        templateName,
        modifytemplateId,
        isClone
      ).get('errorMsg');
      Test.stopTest();

      System.assertEquals(errorMsg, 'Name Error');
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