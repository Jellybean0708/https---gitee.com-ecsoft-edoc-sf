window,window.templateDesign={init:function(o){var a,i;switch(sessionStorage.getItem("lang")){case"cn":a=o.saveMsgLabel_cn,i=o.nameErrorMsgLabel_cn;break;case"ja":a=o.saveMsgLabel_jp,i=o.nameErrorMsgLabel_jp;break;default:a=o.saveMsgLabel_en,i=o.nameErrorMsgLabel_en}var c,e=ECPrint.createSlots({header:new ECPrint.Header({target:document.createElement("div"),props:{showFullScreenIcon:"1"!=o.fullScreenMode,cancelFullScreenPath:o.exitFullScreenUrl,logoLink:o.logoLink,onPreviewClick:e=>(ECPrint.DesignerUtils.getInstance().preview.setConfig({showPdf:!0,showImg:!1}),ECPrint.DesignerUtils.getInstance().preview.show(),!0),$$scope:{}}}).$$.ctx[2]}),t=[pluginEleBwip({}),pluginEleFabric({}),pluginEleEcharts({})],t=new ECPrint.Designer({target:document.querySelector("#app"),props:{authKey:"53616C7465645F5F3702F8548980B6FE795C6B148B754BEFE3F11B06B6AE3FCBCB29EAEB266D242A29CB956DB85A1071",showOption:{showFooter:!1},plugins:t,template:o.curTemplate,printData:o.curTestData,theme:"winter",templateName:o.templateName,events:{onSave(e,t,n,l,s,r){templateIdBlank&&""==p&&(p=o.templateIdLabel),t=JSON.stringify(t),n=JSON.stringify(n),Visualforce.remoting.Manager.invokeAction(o.ECP_TemplateDesignerCompCtrl,t,n,r,p,o.isClone,function(e,t){"exception"==t.type?d(t.message,"alert"):e.errorMsg.includes("Name Error")?d(i,"alert"):""!=e.errorMsg&&null!=e.errorMsg?d(e.errorMsg,"alert"):(p=e.modifytemplateId,c.options.fullScreenPath.includes(p)||(c.options.fullScreenPath+="&id="+p),o.isClone="",d(a,"success"))},{escape:!1})}},$$scope:{},$$slots:e,templatePath:o.templateCenterPath+o.templateUrlSuffix,fullScreenPath:o.fullScreenUrl,cancelFullScreenPath:o.exitFullScreenUrl,logoLink:o.logoLink,logoUrl:o.logoUrl}}),p=(t.$set({showOption:{showHeader:!0,showPower:!1}}),t.$on("onDesigned",e=>{e.detail.hiprint;c=e.detail.designerUtils}),"");function d(e,t){const n=document.createElement("div");n.style.position="fixed",n.style.top="50px",n.style.left="50%",n.style.transform="translateX(-50%)","success"==t?n.style.backgroundColor="#079b2a":"alert"==t&&(n.style.backgroundColor="#ba0517"),n.style.color="white",n.style.padding="10px",n.style.borderRadius="5px",n.style.zIndex="9999";t=document.createElement("span");t.style.fontSize="16px",t.innerHTML='<i class="svicon sv-sigh" style="font-size: 22px; vertical-align: middle;"></i>   '+e+"   ",n.appendChild(t);const l=document.createElement("i");l.className="svicon sv-close",l.addEventListener("click",()=>{n.remove()}),l.style.cursor="pointer",l.addEventListener("mouseover",()=>{l.style.color="#bfbfbf"}),l.addEventListener("mouseout",()=>{l.style.color="white"}),n.appendChild(l),document.body.appendChild(n),setTimeout(()=>{n.style.transition="opacity 3s",n.style.opacity="0",setTimeout(()=>{n.remove()},3e3)},1e3)}}};