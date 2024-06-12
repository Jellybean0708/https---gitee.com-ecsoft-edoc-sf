# edoc-sf

#### 介绍

ecprint产品sf组件代码
### npm rep change
npm config set registry https://mirrors.huaweicloud.com/repository/npm/
npm config set registry https://registry.npmmirror.com

### install prettier code formmater

npm install --save-dev --save-exact prettier prettier-plugin-apex

## format cmd

npm run prettier

## config package.json

    "prettier": "prettier --write \"**/*.{cls,cmp,component,css,html,js,json,md,page,trigger}\"",
    "prettier:verify": "prettier --check \"**/*.{cls,cmp,component,css,html,js,json,md,page,trigger}\"",

#### scan
sf plugins install @salesforce/sfdx-scanner

sf scanner run --format=csv --outfile=CodeAnalyzerGeneral.csv --target="./" --category="Security"
sf scanner run dfa --format=csv --outfile=CodeAnalyzerDFA.csv --target="./" --projectdir="./" --category="Security"

#### 打包手顺

1.  连接DEV HUB环境：
    sf org login web --set-default-dev-hub
2.  验证部署
    sf project deploy validate --source-dir force-app
    或者指定test class
    sf project deploy validate --source-dir force-app -t ECP_PrintServiceManageCtrlTest -t ECP_TemplateDesignerCompCtrlTest -t ECP_PrintPreviewCompCtrlTest -t ECP_InstallClassTest -l RunSpecifiedTests
3.  打包
    sf package create --name "eDocument" --path force-app --package-type Managed
4.  创建包版本
    --需要密码
    sf package version create --package "eDocument" --code-coverage --installation-key grids123 --version-number 0.1.0.0 --wait 10
    --不需要密码
    sf package version create --package "eDocument" --code-coverage --installation-key-bypass --version-number 0.1.0.0 --wait 10
    --翻译文件带入 ("enableTranslationWorkbench": true)
    sf package version create --package "eDocument" --code-coverage --installation-key-bypass --version-number 0.1.0.0 --wait 10 -f config/project-with-ecsoft.json


#### 其他命令

1.  查看创建包版本剩余可用次数 （Name = Package2VersionCreates 每日最多6次）
    sf limits api display
2. 查看已创建的包和Id
    sf package list
