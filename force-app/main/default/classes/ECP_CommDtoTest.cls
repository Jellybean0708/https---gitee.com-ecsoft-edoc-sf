
@isTest
private class ECP_CommDtoTest {

    private class TestCommDto extends ECP_CommDto {
        private String no { get; set; } // 文本
        private String reqGuestName { get; set; } // 請求先
    }
    @isTest
    static void testToJson() {
        System.runAs(createUser()) {
        TestCommDto testDto = new TestCommDto();
        String jsonString = testDto.toJson();
        System.assertEquals(null, jsonString);
        }
    }
    @isTest
    static void testListToJson() {
        System.runAs(createUser()) {
            TestCommDto dto1 = new TestCommDto();
            dto1.no = '1';
            dto1.reqGuestName = '1';
            TestCommDto dto2 = new TestCommDto();
            dto2.no = '2';
            dto2.reqGuestName = '2';
        List<ECP_CommDto> dataList = new List<ECP_CommDto>{
            dto1,
            dto2
        };
        String jsonListString = ECP_CommDto.ListToJson(dataList);
        System.assertNotEquals('', jsonListString);
        System.assert(jsonListString.startsWith('[') && jsonListString.endsWith(']'));
    }
    }
    @isTest
    static void testListToJsonWithEmptyList() {
        System.runAs(createUser()) {
        List<ECP_CommDto> emptyList = new List<ECP_CommDto>();
        String jsonListString = ECP_CommDto.ListToJson(emptyList);
        System.assertEquals('', jsonListString);
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