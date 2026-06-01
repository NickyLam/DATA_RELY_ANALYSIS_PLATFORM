: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_camp_upl_co_corp_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_camp_upl_co_corp.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,co_corp_id
,pty_id
,lmt_contr_id
,marg_acct
,marg_lowt_ratio
,loan_rate
,stl_acct_num
,reg_org_id
,reg_emp_id
,reg_dt
,upda_dt
,force_bout_flg
,repay_cpt_act
,pnty_acct_num
,marg_ratio
,co_start_dt
,co_due_dt
,corp_status_cd
,ghb_pnty_acct_num
,offl_aprv_lmt_amt
,lmt_src_cd
,ovdue_days
,marg_sub
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_camp_upl_co_corp
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_camp_upl_co_corp.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes