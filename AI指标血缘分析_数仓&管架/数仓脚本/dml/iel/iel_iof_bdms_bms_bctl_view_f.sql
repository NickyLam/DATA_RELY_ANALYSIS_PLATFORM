: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_bdms_bms_bctl_view_f
CreateDate: 20230904
FileName:   ${iel_data_path}/bdms_bms_bctl_view.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.br_no,chr(13),''),chr(10),'') as br_no
,replace(replace(t1.br_name,chr(13),''),chr(10),'') as br_name
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t1.br_class,chr(13),''),chr(10),'') as br_class
,replace(replace(t1.br_attr,chr(13),''),chr(10),'') as br_attr
,replace(replace(t1.br_manager_id,chr(13),''),chr(10),'') as br_manager_id
,replace(replace(t1.br_up_id,chr(13),''),chr(10),'') as br_up_id
,replace(replace(t1.tele_no,chr(13),''),chr(10),'') as tele_no
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.post_no,chr(13),''),chr(10),'') as post_no
,replace(replace(t1.ip,chr(13),''),chr(10),'') as ip
,replace(replace(t1.finance_code,chr(13),''),chr(10),'') as finance_code
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.update_userid,chr(13),''),chr(10),'') as update_userid
,update_date
,is_del
,replace(replace(t1.create_userid,chr(13),''),chr(10),'') as create_userid
,create_date

from ${iol_schema}.bdms_bms_bctl_view t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_bms_bctl_view.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
