: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_wl_dubil_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_wl_dubil_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.agt_id
,t1.lp_id
,t1.init_dubil_id
,t1.intnal_dubil_id
,t1.appl_id
,t1.dubil_id
,t1.cont_agt_id
,t1.cust_id
,t1.dubil_amt
,t1.exec_int_rat
,t1.tenor
,t1.spec_repay_day
,t1.value_dt
,t1.exp_dt
,t1.tenor_type_cd
,t1.int_rat_fl_rt
,t1.repay_way_cd
,t1.create_user
,t1.co_proj_id
,t1.coprator_acct_id
,t1.create_tm
,t1.int_rat_cfg_id
,t1.base_rat
,t1.up_lower_bp
,t1.co_org_id
,t1.ovdue_comp_mode_flg
,t1.asset_thd_cls_cd
,t1.acct_id
,t1.brw_new_return_old_cd
,t1.comb_repay_flg
,t1.create_dt 
,t1.update_dt
,t1.id_mark
,t1.job_cd 
from ${idl_schema}.agt_wl_dubil_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wl_dubil_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes