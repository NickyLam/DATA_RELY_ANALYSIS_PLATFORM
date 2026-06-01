: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_fzss_mod_fzs_acct_info_f
CreateDate: 20260304
FileName:   ${iel_data_path}/fzss_mod_fzs_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.sub_acct_no,chr(13),''),chr(10),'') as sub_acct_no
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.corp_work_date,chr(13),''),chr(10),'') as corp_work_date
,replace(replace(t1.order_no,chr(13),''),chr(10),'') as order_no
,replace(replace(t1.mybank,chr(13),''),chr(10),'') as mybank
,replace(replace(t1.zone_no,chr(13),''),chr(10),'') as zone_no
,replace(replace(t1.cmd_type,chr(13),''),chr(10),'') as cmd_type
,replace(replace(t1.sub_acct_nm,chr(13),''),chr(10),'') as sub_acct_nm
,replace(replace(t1.member_name,chr(13),''),chr(10),'') as member_name
,replace(replace(t1.acct_cls,chr(13),''),chr(10),'') as acct_cls
,replace(replace(t1.acct_status,chr(13),''),chr(10),'') as acct_status
,balance
,cash_amt
,freeze_amt
,outstanding_amt
,replace(replace(t1.open_brno,chr(13),''),chr(10),'') as open_brno
,replace(replace(t1.acct_open_dt,chr(13),''),chr(10),'') as acct_open_dt
,replace(replace(t1.acct_open_tm,chr(13),''),chr(10),'') as acct_open_tm
,replace(replace(t1.acct_close_dt,chr(13),''),chr(10),'') as acct_close_dt
,replace(replace(t1.acct_close_tm,chr(13),''),chr(10),'') as acct_close_tm
,replace(replace(t1.tran_net_member_code,chr(13),''),chr(10),'') as tran_net_member_code
,replace(replace(t1.cust_role,chr(13),''),chr(10),'') as cust_role
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,create_timestamp
,update_timestamp

from ${iol_schema}.fzss_mod_fzs_acct_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fzss_mod_fzs_acct_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
