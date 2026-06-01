: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_wl_crdt_appl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_wl_crdt_appl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.appl_id
,t1.lp_id
,t1.init_crdt_appl_id
,t1.tran_flow_num
,t1.prod_id
,t1.cust_id
,t1.curr_cd
,t1.crdt_lmt
,t1.expos_lmt
,t1.surp_lmt
,t1.exec_int_rat
,t1.tenor
,t1.appl_tm
,t1.apved_tm
,t1.appl_start_tm
,t1.crdt_exp_tm
,t1.tenor_type_cd
,t1.manu_proc_flg
,t1.circl_flg
,t1.share_crdt_lmt_flg
,t1.appl_status_cd
,t1.user_group_id
,t1.org_id
,t1.co_proj_id
,t1.coprator_acct_id
,t1.taxpayer_idtfy_num
,t1.equip_id
,t1.co_org_id
,t1.apv_rest_descb
,t1.create_dt 
,t1.update_dt
,t1.id_mark
,t1.job_cd 
from ${idl_schema}.agt_wl_crdt_appl t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wl_crdt_appl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes