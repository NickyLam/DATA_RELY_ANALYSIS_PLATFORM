: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_agt_tran_bank_acct_lmt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_agt_tran_bank_acct_lmt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,agt_id
,attr_name
,lp_id
,acct_id
,cust_id
,user_seq_num
,attr_val
,tran_chn_cd
,start_dt
,end_dt
,id_mark
from idl.aml_agt_tran_bank_acct_lmt
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_agt_tran_bank_acct_lmt.f.${batch_date}.dat" \
        charset=utf8
        safe=yes