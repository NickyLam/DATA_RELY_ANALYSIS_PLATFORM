: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_prd_aid_loan_prd_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_prd_aid_loan_prd_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
aid_loan_cr_prd_id
,etl_dt
,last_update_dt
,aid_loan_prd_name
,aid_loan_corp_id
,aid_loan_corp_name
,prd_status
,circ_flg
,singl_loan_amt_ceil
,day_put_lmt
,mon_put_lmt
,manu_apprv_lmt
,db_pers_apprv_lmt
,min_term
,max_term
,crdt_lmt_term
,prd_rate
,loan_usage_cd
,dd_status
,comp_days
,repay_mode_cd
,adv_repay
,part_adv_repay
,repay_day
,data_src_cd
,etl_task_name
from ${idl_schema}.hdws_dul_d_rpts_prd_aid_loan_prd_info
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_prd_aid_loan_prd_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes