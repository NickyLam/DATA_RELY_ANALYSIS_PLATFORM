: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_psp_risk_warning_rule_conf_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_psp_risk_warning_rule_conf.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rangepro,chr(13),''),chr(10),'') as rangepro
,replace(replace(t1.checkobj,chr(13),''),chr(10),'') as checkobj
,replace(replace(t1.warningsign,chr(13),''),chr(10),'') as warningsign
,replace(replace(t1.warningrule,chr(13),''),chr(10),'') as warningrule
,replace(replace(t1.updatehz,chr(13),''),chr(10),'') as updatehz
,replace(replace(t1.signlevel,chr(13),''),chr(10),'') as signlevel
,replace(replace(t1.creatorid,chr(13),''),chr(10),'') as creatorid
,replace(replace(t1.createdate,chr(13),''),chr(10),'') as createdate
,replace(replace(t1.lastchangeuser,chr(13),''),chr(10),'') as lastchangeuser
,replace(replace(t1.lastchangetime,chr(13),''),chr(10),'') as lastchangetime
,replace(replace(t1.warningruleno,chr(13),''),chr(10),'') as warningruleno
,replace(replace(t1.range,chr(13),''),chr(10),'') as range
,percent
,amt
,count
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.warningcode,chr(13),''),chr(10),'') as warningcode
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag

from ${iol_schema}.icms_psp_risk_warning_rule_conf t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_psp_risk_warning_rule_conf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
