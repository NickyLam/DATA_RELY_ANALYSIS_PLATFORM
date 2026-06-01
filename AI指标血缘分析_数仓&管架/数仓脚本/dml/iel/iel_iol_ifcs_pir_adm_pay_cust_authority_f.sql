: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifcs_pir_adm_pay_cust_authority_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ifcs_pir_adm_pay_cust_authority.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.data_dt,chr(13),''),chr(10),'') as data_dt
,replace(replace(t.org_num,chr(13),''),chr(10),'') as org_num
,replace(replace(t.cust_typ,chr(13),''),chr(10),'') as cust_typ
,replace(replace(t.authority_typ,chr(13),''),chr(10),'') as authority_typ
,t.cust_num as cust_num
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ifcs_pir_adm_pay_cust_authority t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifcs_pir_adm_pay_cust_authority.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes