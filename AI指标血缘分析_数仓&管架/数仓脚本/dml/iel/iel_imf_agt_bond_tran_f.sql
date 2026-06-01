: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_bond_tran_f
CreateDate: 20240112
FileName:   ${iel_data_path}/agt_bond_tran.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.bus_table_name,chr(13),''),chr(10),'') as bus_table_name
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.bond_id,chr(13),''),chr(10),'') as bond_id
,replace(replace(t1.bond_name,chr(13),''),chr(10),'') as bond_name
,replace(replace(t1.bond_type_cd,chr(13),''),chr(10),'') as bond_type_cd
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,tran_dt
,dlvy_dt
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tran_net_price
,tran_full_price
,exp_yld_rat
,stl_amt
,replace(replace(t1.portf_id,chr(13),''),chr(10),'') as portf_id
,replace(replace(t1.portf_name,chr(13),''),chr(10),'') as portf_name
,replace(replace(t1.acct_b_id,chr(13),''),chr(10),'') as acct_b_id
,replace(replace(t1.acct_b_name,chr(13),''),chr(10),'') as acct_b_name
,replace(replace(t1.acct_b_attr_cd,chr(13),''),chr(10),'') as acct_b_attr_cd
,replace(replace(t1.asset_cls4_cd,chr(13),''),chr(10),'') as asset_cls4_cd
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,replace(replace(t1.dealer_id,chr(13),''),chr(10),'') as dealer_id
,replace(replace(t1.dealer_name,chr(13),''),chr(10),'') as dealer_name
,replace(replace(t1.bag_id,chr(13),''),chr(10),'') as bag_id
,comm_fee
,tax
,comm
,cert_face_tot
,acru_int_tot
,replace(replace(t1.cfets_tran_flg,chr(13),''),chr(10),'') as cfets_tran_flg
,replace(replace(t1.tran_src_cd,chr(13),''),chr(10),'') as tran_src_cd
,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'') as asset_type_cd
,replace(replace(t1.init_bus_id,chr(13),''),chr(10),'') as init_bus_id
,acpt_pay_cfm_modif_tm
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.dc_dealer_name,chr(13),''),chr(10),'') as dc_dealer_name
,create_dt
,update_dt

from ${iml_schema}.agt_bond_tran t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bond_tran.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
