import { LightningElement, track, wire } from 'lwc';
import iconUrl from "@salesforce/resourceUrl/ecp_templateDesigner";
import getDesignerUrl from "@salesforce/apex/ECP_PrintServiceManageCtrl.getDesignerUrl";
import { CUSTOM } from "./ecp_homeUtility";

export default class Ecp_homeComp extends LightningElement {
    
    @track CUSTOM = CUSTOM;
    @track isLoading = false
    icon1;
    icon2;
    icon3;
    icon4;
    designerUrl;

    @wire(getDesignerUrl)
    getDesignerUrl({ data, error }) {
        if (data) {
            this.designerUrl = data;
        }
    } 

    async connectedCallback() {
        this.icon1 = iconUrl + "/icons/ecp_Icon1.png";
        this.icon2 = iconUrl + "/icons/ecp_Icon2.png";
        this.icon3 = iconUrl + "/icons/ecp_Icon3.png";
        this.icon4 = iconUrl + "/icons/ecp_Icon4.png";
    }

    handleOpenDesigner(){
        this.isLoading = true;
        window.parent.location.href = this.designerUrl;
    }
}