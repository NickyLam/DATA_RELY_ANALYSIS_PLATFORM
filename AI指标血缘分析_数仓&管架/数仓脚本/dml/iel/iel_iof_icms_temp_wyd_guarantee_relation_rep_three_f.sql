: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_temp_wyd_guarantee_relation_rep_three_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_temp_wyd_guarantee_relation_rep_three.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.datadtt,chr(13),''),chr(10),'') as datadtt
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.lendingref,chr(13),''),chr(10),'') as lendingref
,replace(replace(t1.guarcontractno,chr(13),''),chr(10),'') as guarcontractno
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,loanbalance
,guarantyamt
,replace(replace(t1.guarantystat,chr(13),''),chr(10),'') as guarantystat
,replace(replace(t1.inputtime,chr(13),''),chr(10),'') as inputtime
,replace(replace(t1.maturitydate,chr(13),''),chr(10),'') as maturitydate
,replace(replace(t1.merchantid,chr(13),''),chr(10),'') as merchantid

from ${iol_schema}.icms_temp_wyd_guarantee_relation_rep_three t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_temp_wyd_guarantee_relation_rep_three.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
