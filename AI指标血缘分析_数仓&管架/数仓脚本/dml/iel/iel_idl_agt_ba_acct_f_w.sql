: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_ba_acct_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_ba_acct_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.agt_id
,t1.lp_id
,t1.bill_id
,t1.acpt_org_id
,t1.applit_stl_acct_id
,t1.curr_cd
,t1.bill_med_cd
,t1.bill_kind_cd
,t1.fac_val_amt
,t1.comm_fee
,t1.guar_gold_acct_id
,t1.margin_sub_acct_id
,t1.margin_amt
,t1.margin_dep_term_cd
,t1.draw_dt
,t1.close_dt
,t1.close_flow_num
,t1.acct_status_cd
,t1.close_way_cd
,t1.pymc_dt
,t1.pymc_flow_num
,t1.pymc_way_cd
,t1.advc_open_acct_amt
,t1.exp_dt
,t1.pymc_acct_id
,t1.dubil_id
,t1.advc_exec_int_rat
,t1.base_rat_type_cd
,t1.advc_int_rat_cu_ratio
,t1.create_dt 
,t1.update_dt
,t1.id_mark
,t1.job_cd 
from ${idl_schema}.agt_ba_acct t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ba_acct_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes