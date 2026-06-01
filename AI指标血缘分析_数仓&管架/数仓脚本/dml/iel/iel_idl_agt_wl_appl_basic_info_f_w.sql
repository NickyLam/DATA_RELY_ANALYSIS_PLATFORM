: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_wl_appl_basic_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_wl_appl_basic_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.appl_id
,t1.lp_id
,t1.init_appl_id
,t1.cust_id
,t1.open_acct_bank_name
,t1.bank_card_num
,t1.cust_name
,t1.open_acct_bind_mobile_no
,t1.co_org_id
,t1.prod_id
,t1.prod_cls_id
,t1.appl_chn_id
,t1.crdt_appl_id
,t1.repay_num
,t1.curr_cd
,t1.appl_lmt
,t1.appl_int_rat
,t1.appl_tm
,t1.appl_tenor
,t1.repay_day
,t1.grace_days
,t1.loan_dir_cd
,t1.repay_way_cd
,t1.appl_status_cd
,t1.check_status_cd
,t1.coprator_acct_id
,t1.taxpayer_idtfy_num
,t1.tran_flow_num
,t1.user_group_id
,t1.co_proj_id
,t1.org_co_id
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_wl_appl_basic_info t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wl_appl_basic_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes