: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_ifms_agt_fin_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_ifms_agt_fin_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_task_name
,last_update_dt
,agt_modf
,dpst_acct_id
,etl_dt
,blng_pty_id
,fin_inter_cust_nbr
,acct_name
,issue_dt
,colse_dt
,prev_acti_acct_dt
,acct_stats_cd
,issue_org_id
,mgmt_org_id
,colse_org_id
,open_teller_id
,colse_teller_id
,pty_mgr_id
,cap_stl_acct_num
,retl_cd
,bank_id
,ccy_cd
,acct_bal
,fin_prd_id
,prft_fea_cd
,acct_id
,divi_mode_cd
,revt_flg
,fin_prd_status_cd
,open_mode_flg
,purch_dt
,due_dt
,int_start_dt
,income_due_day
,subsc_total_amt
,subsc_tot_lot
,rede_shr
,redeem_amt
,curr_shr
,usab_shr
,txn_frozen_shr
,long_frozen_shr
,local_frozen_shr
,invt_inco
,term_income
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_ifms_agt_fin_acct_info 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_ifms_agt_fin_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes