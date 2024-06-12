/**
-------------------------------------------------------------------------
* Project Name : eDocument Dx
* Package Name : eDocument Dx
-------------------------------------------------------------------------
* Class Name   : ECP_CommDto
* Class Desc   : デザイナーズデータモデルベースクラス
* Class Author : @ECSOFT
* Created Date : 2024/05/01
* Updated Date :
-------------------------------------------------------------------------
*/
global abstract with sharing class ECP_CommDto {

    /**
     * JSON形式に変換する
     * @return JSON文字列 (nullの場合あり)
     */
    global virtual String toJson() {
        return null;
    }

    /**
     * ECP_CommDtoのリストをJSON文字列に変換する
     * @param datas 変換対象のECP_CommDtoのリスト
     * @return JSON文字列表現 (データなしの場合は空文字列)
     */
    global static String ListToJson(List<ECP_CommDto> datas) {
        if (datas == null || datas.isEmpty()) {
            return '';
        }
        List<String> jsonList = new List<String>();
        for (ECP_CommDto data : datas) {
            String jsonStr = data.toJson();
            if (!String.isBlank(jsonStr)) {
                jsonList.add(jsonStr);
            } else {
                jsonList.add(JSON.serialize(data));
            }
        }
        return '[' + String.join(jsonList, ',') + ']';
    }
}