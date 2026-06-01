: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_fin_acct_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_fin_acct_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.dpst_acct_id,chr(13),''),chr(10),'') as dpst_acct_id
,replace(replace(t1.agt_modf,chr(13),''),chr(10),'') as agt_modf
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.fin_inter_cust_nbr,chr(13),''),chr(10),'') as fin_inter_cust_nbr
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,t1.issue_dt as issue_dt
,t1.colse_dt as colse_dt
,t1.prev_acti_acct_dt as prev_acti_acct_dt
,replace(replace(t1.acct_stats_cd,chr(13),''),chr(10),'') as acct_stats_cd
,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'') as issue_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.colse_org_id,chr(13),''),chr(10),'') as colse_org_id
,replace(replace(t1.open_teller_id,chr(13),''),chr(10),'') as open_teller_id
,replace(replace(t1.colse_teller_id,chr(13),''),chr(10),'') as colse_teller_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.cap_stl_acct_num,chr(13),''),chr(10),'') as cap_stl_acct_num
,replace(replace(t1.retl_cd,chr(13),''),chr(10),'') as retl_cd
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.acct_bal as acct_bal
,replace(replace(t1.fin_prd_id,chr(13),''),chr(10),'') as fin_prd_id
,replace(replace(t1.prft_fea_cd,chr(13),''),chr(10),'') as prft_fea_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.divi_mode_cd,chr(13),''),chr(10),'') as divi_mode_cd
,replace(replace(t1.revt_flg,chr(13),''),chr(10),'') as revt_flg
,replace(replace(t1.fin_prd_status_cd,chr(13),''),chr(10),'') as fin_prd_status_cd
,t1.purch_dt as purch_dt
,t1.due_dt as due_dt
,t1.int_start_dt as int_start_dt
,t1.income_due_day as income_due_day
,t1.subsc_total_amt as subsc_total_amt
,t1.subsc_tot_lot as subsc_tot_lot
,t1.rede_shr as rede_shr
,t1.redeem_amt as redeem_amt
,t1.curr_shr as curr_shr
,t1.usab_shr as usab_shr
,t1.txn_frozen_shr as txn_frozen_shr
,t1.long_frozen_shr as long_frozen_shr
,t1.local_frozen_shr as local_frozen_shr
,t1.invt_inco as invt_inco
,t1.term_income as term_income
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_FIN_ACCT_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_FIN_ACCT_H') as etl_task_name 
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
,replace(replace(t1.open_mode_flg,chr(13),''),chr(10),'') as open_mode_flg
from ${idl_schema}.hdws_iml_agt_fin_acct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_fin_acct_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes