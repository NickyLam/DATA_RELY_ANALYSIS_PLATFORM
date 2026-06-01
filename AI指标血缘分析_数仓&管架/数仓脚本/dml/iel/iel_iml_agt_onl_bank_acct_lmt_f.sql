: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_onl_bank_acct_lmt_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_onl_bank_acct_lmt.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(agt_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(acct_id,chr(13),''),chr(10),'')
,replace(replace(cust_id,chr(13),''),chr(10),'')
,replace(replace(user_seq_num,chr(13),''),chr(10),'')
,replace(replace(lmt_attr_name,chr(13),''),chr(10),'')
,replace(replace(lmt_attr_val,chr(13),''),chr(10),'')
,replace(replace(tran_chn_cd,chr(13),''),chr(10),'')
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.agt_onl_bank_acct_lmt t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_onl_bank_acct_lmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
