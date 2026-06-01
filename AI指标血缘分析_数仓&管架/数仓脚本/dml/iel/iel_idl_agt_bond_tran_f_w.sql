: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_bond_tran_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bond_tran_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.agt_id
,t1.lp_id
,t1.bus_id
,t1.bus_table_name
,t1.dept_id
,t1.bond_id
,t1.bond_name
,t1.bond_type_cd
,t1.std_prod_id
,t1.tran_id
,t1.tran_dt
,t1.dlvy_dt
,t1.tran_dir_cd
,t1.curr_cd
,t1.tran_net_price
,t1.tran_full_price
,t1.exp_yld_rat
,t1.stl_amt
,t1.portf_id
,t1.portf_name
,t1.acct_b_id
,t1.acct_b_name
,t1.acct_b_attr_cd
,t1.asset_cls4_cd
,t1.cntpty_name
,t1.cntpty_id
,t1.stl_way_cd
,t1.dealer_id
,t1.dealer_name
,t1.bag_id
,t1.comm_fee
,t1.tax
,t1.comm
,t1.cert_face_tot
,t1.acru_int_tot
,t1.cfets_tran_flg
,t1.tran_src_cd
,t1.asset_type_cd
,t1.init_bus_id
,t1.acpt_pay_cfm_modif_tm
,t1.tran_status_cd
,t1.dc_dealer_name
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_bond_tran t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bond_tran_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes