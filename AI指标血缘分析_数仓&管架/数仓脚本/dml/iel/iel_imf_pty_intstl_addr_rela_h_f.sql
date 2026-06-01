: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_pty_intstl_addr_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_intstl_addr_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.rela_id,chr(13),''),chr(10),'') as rela_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.addr_desc,chr(13),''),chr(10),'') as addr_desc
,replace(replace(t1.main_addr_flg,chr(13),''),chr(10),'') as main_addr_flg
,replace(replace(t1.addr_id,chr(13),''),chr(10),'') as addr_id
,replace(replace(t1.bic_code,chr(13),''),chr(10),'') as bic_code
,replace(replace(t1.addr_status_cd,chr(13),''),chr(10),'') as addr_status_cd
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.pty_intstl_addr_rela_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_intstl_addr_rela_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes