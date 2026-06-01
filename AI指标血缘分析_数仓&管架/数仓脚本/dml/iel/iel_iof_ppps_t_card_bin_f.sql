: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ppps_t_card_bin_f
CreateDate: 20240507
FileName:   ${iel_data_path}/ppps_t_card_bin.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,replace(replace(t1.card_bin,chr(13),''),chr(10),'') as card_bin
,card_length
,replace(replace(t1.acct_type,chr(13),''),chr(10),'') as acct_type
,replace(replace(t1.clear_bank_code,chr(13),''),chr(10),'') as clear_bank_code
,replace(replace(t1.clear_bank_name,chr(13),''),chr(10),'') as clear_bank_name
,replace(replace(t1.active,chr(13),''),chr(10),'') as active
,create_time
,update_time
,replace(replace(t1.financial_branch_code,chr(13),''),chr(10),'') as financial_branch_code

from ${iol_schema}.ppps_t_card_bin t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ppps_t_card_bin.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
