: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_opr_agt_iacct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_opr_agt_iacct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
acct_id
,etl_dt
,acct_num
,sub_num
,acct_name
,blng_org_id
,prd_id
,accting_coa_id
,open_evt_id
,colse_evt_id
,off_flg
,open_dt
,colse_dt
,ccy_cd
,acct_bal
,bal_dir_cd
,agt_status_cd
,gl_acct_flg
,prev_trx_dt
,prev_trx_srl_id
,data_src_cd
from ${idl_schema}.hdws_dul_d_opr_agt_iacct_info 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_opr_agt_iacct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes