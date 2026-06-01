: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_fzss_mod_fzs_acct_amt_info_i
CreateDate: 20260304
FileName:   ${iel_data_path}/fzss_mod_fzs_acct_amt_info.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.data_date,chr(13),''),chr(10),'') as data_date
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.sub_acct_no,chr(13),''),chr(10),'') as sub_acct_no
,replace(replace(t1.mybank,chr(13),''),chr(10),'') as mybank
,replace(replace(t1.zone_no,chr(13),''),chr(10),'') as zone_no
,replace(replace(t1.sub_acct_nm,chr(13),''),chr(10),'') as sub_acct_nm
,replace(replace(t1.acct_cls,chr(13),''),chr(10),'') as acct_cls
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t1.acct_status,chr(13),''),chr(10),'') as acct_status
,balance
,cash_amt
,freeze_amt
,outstanding_amt
,create_timestamp
,update_timestamp

from ${iol_schema}.fzss_mod_fzs_acct_amt_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fzss_mod_fzs_acct_amt_info.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
