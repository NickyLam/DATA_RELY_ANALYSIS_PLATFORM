: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_guar_rcva_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_guar_rcva_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
coll_id
,etl_dt
,contr_id
,rcva_ghb_spec_acct_num
,payer_name
,payer_loc
,estab_dt
,reg_cap
,legal_reps
,actl_ctrler
,curr_ast_total_amt
,curr_sale_income
,curr_non_altd_marg
,bkrpt_liqdt_flg
,payer_acct_num
,rcva_amt
,prod_dt
,due_dt
,data_src_cd
from ${idl_schema}.hdws_dul_d_ccrm_agt_guar_rcva_info
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_guar_rcva_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes