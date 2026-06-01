: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ppps_e_corp_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ppps_e_corp_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.issr_id,chr(13),''),chr(10),'') as issr_id
,replace(replace(t1.issr_name,chr(13),''),chr(10),'') as issr_name
,replace(replace(t1.permit_code,chr(13),''),chr(10),'') as permit_code
,replace(replace(t1.permit_vaild_date,chr(13),''),chr(10),'') as permit_vaild_date
,t1.regist_fund as regist_fund
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.organ_code,chr(13),''),chr(10),'') as organ_code
,replace(replace(t1.corp_id_type,chr(13),''),chr(10),'') as corp_id_type
,replace(replace(t1.corp_id_no,chr(13),''),chr(10),'') as corp_id_no
,replace(replace(t1.corporation_name,chr(13),''),chr(10),'') as corporation_name
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.linkman,chr(13),''),chr(10),'') as linkman
,replace(replace(t1.link_tel_no,chr(13),''),chr(10),'') as link_tel_no
,replace(replace(t1.contact_address,chr(13),''),chr(10),'') as contact_address
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.balance_channel,chr(13),''),chr(10),'') as balance_channel
,replace(replace(t1.balance_open_bank,chr(13),''),chr(10),'') as balance_open_bank
,t1.create_time as create_time
,t1.update_time as update_time
,replace(replace(t1.delete_status,chr(13),''),chr(10),'') as delete_status
,replace(replace(t1.issr_short_name,chr(13),''),chr(10),'') as issr_short_name
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ppps_e_corp_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ppps_e_corp_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes