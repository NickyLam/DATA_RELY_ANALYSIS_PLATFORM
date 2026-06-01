: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_wl_repay_appl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_wl_repay_appl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.appl_id
,t1.lp_id
,t1.init_repay_appl_id
,t1.prod_id
,t1.dubil_id
,t1.cont_id
,t1.cust_id
,t1.repay_num
,t1.appl_dt
,t1.entry_tm
,t1.repay_amt
,t1.rtn_fine
,t1.rtn_nomal_pric
,t1.rtn_int
,t1.rtn_ovdue_pric
,t1.rtn_ovdue_quar_over_pric
,t1.rtn_bad_debt_pric
,t1.rtn_recvbl_acru_int
,t1.rtn_coll_acru_int
,t1.rtn_recvbl_over_int
,t1.rtn_coll_over_int
,t1.rtn_recvbl_acru_pnlt
,t1.rtn_coll_acru_pnlt
,t1.rtn_recvbl_pnlt
,t1.rtn_coll_pnlt
,t1.rtn_acru_comp_int
,t1.rtn_comp_int
,t1.surp_pric
,t1.repay_type_cd
,t1.appl_status_cd
,t1.repay_tran_flow_num
,t1.glob_tran_flow_num
,t1.user_group_id
,t1.create_user
,t1.create_tm
,t1.update_user
,t1.update_tm
,t1.currt_rpbl_amt
,t1.surp_unpaid_amt
,t1.tran_flow_num
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_wl_repay_appl t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wl_repay_appl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes