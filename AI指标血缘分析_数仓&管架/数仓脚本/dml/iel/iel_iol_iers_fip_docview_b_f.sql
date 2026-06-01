: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_iers_fip_docview_b_f
CreateDate: 20230130
FileName:   ${iel_data_path}/iers_fip_docview_b.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.desdocvalue,chr(13),''),chr(10),'') as desdocvalue
,dr
,replace(replace(t1.factorvalue1,chr(13),''),chr(10),'') as factorvalue1
,replace(replace(t1.factorvalue2,chr(13),''),chr(10),'') as factorvalue2
,replace(replace(t1.factorvalue3,chr(13),''),chr(10),'') as factorvalue3
,replace(replace(t1.factorvalue4,chr(13),''),chr(10),'') as factorvalue4
,replace(replace(t1.factorvalue5,chr(13),''),chr(10),'') as factorvalue5
,replace(replace(t1.factorvalue6,chr(13),''),chr(10),'') as factorvalue6
,replace(replace(t1.factorvalue7,chr(13),''),chr(10),'') as factorvalue7
,replace(replace(t1.factorvalue8,chr(13),''),chr(10),'') as factorvalue8
,replace(replace(t1.factorvalue9,chr(13),''),chr(10),'') as factorvalue9
,indexnumber
,replace(replace(t1.pk_classview,chr(13),''),chr(10),'') as pk_classview
,replace(replace(t1.pk_classview_b,chr(13),''),chr(10),'') as pk_classview_b
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.iers_fip_docview_b t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_fip_docview_b.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
