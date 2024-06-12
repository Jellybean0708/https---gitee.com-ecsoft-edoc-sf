/**
 * パッケージ実施際に、Config情報を自動登録する
 */
public with sharing class ECP_InstallClass implements InstallHandler {
    public void onInstall(InstallContext context) {
        List<ECP_TemplateCenterSetting__c> confList = [select id from ECP_TemplateCenterSetting__c limit 1];
        if (confList.isEmpty()) {
            ECP_TemplateCenterSetting__c config = new ECP_TemplateCenterSetting__c();
            insert config;
        }
    }
}