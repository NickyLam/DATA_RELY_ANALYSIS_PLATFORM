: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_bond_tran_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_bond_tran.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.bus_id as bus_id
,t1.bus_table_name as bus_table_name
,t1.dept_id as dept_id
,t1.bond_id as bond_id
,t1.bond_name as bond_name
,t1.bond_type_cd as bond_type_cd
,t1.tran_id as tran_id
,t1.tran_dt as tran_dt
,t1.dlvy_dt as dlvy_dt
,t1.tran_dir_cd as tran_dir_cd
,t1.curr_cd as curr_cd
,t1.tran_net_price as tran_net_price
,t1.tran_full_price as tran_full_price
,t1.exp_yld_rat as exp_yld_rat
,t1.stl_amt as stl_amt
,t1.portf_id as portf_id
,t1.portf_name as portf_name
,t1.acct_b_id as acct_b_id
,t1.acct_b_name as acct_b_name
,t1.acct_b_attr_cd as acct_b_attr_cd
,t1.asset_cls4_cd as asset_cls4_cd
,t1.cntpty_name as cntpty_name
,t1.cntpty_id as cntpty_id
,t1.stl_way_cd as stl_way_cd
,t1.dealer_id as dealer_id
,t1.dealer_name as dealer_name
,t1.bag_id as bag_id
,t1.comm_fee as comm_fee
,t1.tax as tax
,t1.comm as comm
,t1.cert_face_tot as cert_face_tot
,t1.acru_int_tot as acru_int_tot
,t1.cfets_tran_flg as cfets_tran_flg
,t1.tran_src_cd as tran_src_cd
,t1.asset_type_cd as asset_type_cd
,t1.init_bus_id as init_bus_id
,t1.acpt_pay_cfm_modif_tm as acpt_pay_cfm_modif_tm
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.std_prod_id as std_prod_id
,t1.tran_status_cd as tran_status_cd
,t1.dc_dealer_name as dc_dealer_name
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_bond_tran t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_bond_tran.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
