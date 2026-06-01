: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_onl_bank_acct_lmt_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_onl_bank_acct_lmt.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.acct_id as acct_id
,t1.cust_id as cust_id
,t1.user_seq_num as user_seq_num
,t1.lmt_attr_name as lmt_attr_name
,t1.lmt_attr_val as lmt_attr_val
,t1.tran_chn_cd as tran_chn_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_onl_bank_acct_lmt t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_onl_bank_acct_lmt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
