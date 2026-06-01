: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rrss_m_loan_occur_amt_rpt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rrss_m_loan_occur_amt_rpt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,fin_org_cd
,pty_typ
,brwer_cd
,loan_main_indu_categ
,brwer_login_pla_encd
,corp_promo_econ_cmpnt
,corp_size
,loan_dbill_encd
,biz_breed
,loan_actl_dir
,loan_dd_dt
,loan_due_dt
,loan_actl_trmi_dt
,loan_ccy
,loan_occur_amt
,rate_fix_flg
,rate_lvl
,loan_guar_mode
,loan_status
,loan_dd_retra_flg
,blng_org
,loan_issue_amt
,acct_num
,pty_name
,loan_ind
from ${idl_schema}.hdws_dul_d_rrss_m_loan_occur_amt_rpt 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rrss_m_loan_occur_amt_rpt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes