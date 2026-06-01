: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iers_oa_approveinfo_f
CreateDate: 20240207
FileName:   ${iel_data_path}/iers_oa_approveinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rela_traninfo,chr(13),''),chr(10),'') as rela_traninfo
,replace(replace(t1.pk_dept,chr(13),''),chr(10),'') as pk_dept
,replace(replace(t1.relation_info,chr(13),''),chr(10),'') as relation_info
,rela_amount
,replace(replace(t1.rela_tranprise,chr(13),''),chr(10),'') as rela_tranprise
,replace(replace(t1.pk_approveinfo,chr(13),''),chr(10),'') as pk_approveinfo
,dr
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,replace(replace(t1.billno,chr(13),''),chr(10),'') as billno
,replace(replace(t1.tradeopp,chr(13),''),chr(10),'') as tradeopp
,replace(replace(t1.busicode,chr(13),''),chr(10),'') as busicode
,replace(replace(t1.rela_amount_analyse,chr(13),''),chr(10),'') as rela_amount_analyse
,replace(replace(t1.exist_bljl,chr(13),''),chr(10),'') as exist_bljl
,replace(replace(t1.exist_fljf,chr(13),''),chr(10),'') as exist_fljf
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.rela_tranflag,chr(13),''),chr(10),'') as rela_tranflag
,rela_balance_amount
,replace(replace(t1.user_code,chr(13),''),chr(10),'') as user_code
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id

from ${iol_schema}.iers_oa_approveinfo t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_oa_approveinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
