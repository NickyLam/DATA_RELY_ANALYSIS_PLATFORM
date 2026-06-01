: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_intstl_addr_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_intstl_addr_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.addr_id,chr(13),''),chr(10),'') as addr_id
,replace(replace(t1.addr_idf,chr(13),''),chr(10),'') as addr_idf
,replace(replace(t1.addr_desc,chr(13),''),chr(10),'') as addr_desc
,replace(replace(t1.advise_bank_swift_id,chr(13),''),chr(10),'') as advise_bank_swift_id
,replace(replace(t1.e_mail,chr(13),''),chr(10),'') as e_mail
,replace(replace(t1.street_addr,chr(13),''),chr(10),'') as street_addr
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd
,replace(replace(t1.cty_rg_cd,chr(13),''),chr(10),'') as cty_rg_cd
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd
,replace(replace(t1.mailbox_num,chr(13),''),chr(10),'') as mailbox_num
,replace(replace(t1.tel_num,chr(13),''),chr(10),'') as tel_num
,replace(replace(t1.pbc_name,chr(13),''),chr(10),'') as pbc_name
,replace(replace(t1.pbc_addr,chr(13),''),chr(10),'') as pbc_addr
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_intstl_addr_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_intstl_addr_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes