: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_fzss_mod_fzs_main_acct_info_f
CreateDate: 20260304
FileName:   ${iel_data_path}/fzss_mod_fzs_main_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.mybank,chr(13),''),chr(10),'') as mybank
,replace(replace(t1.zone_no,chr(13),''),chr(10),'') as zone_no
,replace(replace(t1.ref_acct_type,chr(13),''),chr(10),'') as ref_acct_type
,replace(replace(t1.ref_seq,chr(13),''),chr(10),'') as ref_seq
,replace(replace(t1.base_acct_no,chr(13),''),chr(10),'') as base_acct_no
,replace(replace(t1.base_acct_name,chr(13),''),chr(10),'') as base_acct_name
,replace(replace(t1.bank_flag,chr(13),''),chr(10),'') as bank_flag
,replace(replace(t1.cnaps_branch_id,chr(13),''),chr(10),'') as cnaps_branch_id
,replace(replace(t1.open_bank_no,chr(13),''),chr(10),'') as open_bank_no
,replace(replace(t1.is_need_downhost,chr(13),''),chr(10),'') as is_need_downhost
,replace(replace(t1.downhost_dealstatus,chr(13),''),chr(10),'') as downhost_dealstatus
,replace(replace(t1.downhost_date,chr(13),''),chr(10),'') as downhost_date
,replace(replace(t1.downhost_pagenum,chr(13),''),chr(10),'') as downhost_pagenum
,create_timestamp
,update_timestamp

from ${iol_schema}.fzss_mod_fzs_main_acct_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fzss_mod_fzs_main_acct_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
