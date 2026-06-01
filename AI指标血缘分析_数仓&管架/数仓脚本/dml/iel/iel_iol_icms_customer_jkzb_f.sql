: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_customer_jkzb_f
CreateDate: 20230704
FileName:   ${iel_data_path}/icms_customer_jkzb.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,yzldscale
,zygdjzb
,rzzlscale
,mrfsassets
,xtbcscale
,dykhrzscale
,zqjzbscale
,jincome
,yqcreditscale
,chbhscale
,cdscale1
,gzcreditscale
,ldfgscale
,dqbxscale
,badzlscale
,yskinvest
,zbczscale
,replace(replace(t1.belongyear,chr(13),''),chr(10),'') as belongyear
,llzhscale
,stockb
,inputtime
,jzcfz
,gzldkye
,updatetime
,ljckscale
,yjzbscale
,replace(replace(t1.zlchannel,chr(13),''),chr(10),'') as zlchannel
,zlbfscale
,jsdgpscale
,badrzzlscale
,rjdqsczz
,gainzb
,ldxscale2
,coreyjscale
,dbscale
,zcsum
,zzcscale
,dykhjzbscale
,zqszscale
,baddkye
,ldxscale1
,jwdzjscale
,jzbjfz
,dkssscale
,bdscale
,pjdlscale
,cqtzscale
,replace(replace(t1.dygdjzd,chr(13),''),chr(10),'') as dygdjzd
,xtsrscale
,zbsyscale
,bcreditpydscale
,cfllscale
,jzbjzc
,stockdqy
,rjprofit
,ditzscale
,tycrscale
,cbsrscale
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,cqbxscale
,bfzzscale
,zyqxjzb
,fxfgscale
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,badscale
,dyjtglscale
,bfrzscale
,replace(replace(t1.dkzlzcgm,chr(13),''),chr(10),'') as dkzlzcgm
,ldxscale3
,businessjsr
,fxtzzbscale
,tbscale
,dyjtsxscale
,replace(replace(t1.inputorg,chr(13),''),chr(10),'') as inputorg
,dqsczs
,jtkfscale
,yqbadzlscale
,zbjye
,zzggscale
,dkscope
,cdscale2
,cdscale3
,jwdscale
,ldppscale
,dyjtjzscale
,badcreditscale
,replace(replace(t1.inputuser,chr(13),''),chr(10),'') as inputuser
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,zcglscope
,ckscope

from ${iol_schema}.icms_customer_jkzb t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_customer_jkzb.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
