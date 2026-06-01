: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_fx_ib_lend_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_fx_ib_lend.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,input_dt
,tran_dt
,value_dt
,exp_dt
,fir_pay_int_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,ib_lend_int_rat
,ib_lend_amt
,convt_usd_curr_amt
,term_end_stl_amt
,ib_lend_days
,daily_int_amt
,acru_int_tot
,replace(replace(t1.tran_aim_cd,chr(13),''),chr(10),'') as tran_aim_cd
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.bag_id,chr(13),''),chr(10),'') as bag_id
,replace(replace(t1.tran_mode_cd,chr(13),''),chr(10),'') as tran_mode_cd
,replace(replace(t1.tran_src_cd,chr(13),''),chr(10),'') as tran_src_cd
,replace(replace(t1.tran_site_cd,chr(13),''),chr(10),'') as tran_site_cd
,replace(replace(t1.clear_way_cd,chr(13),''),chr(10),'') as clear_way_cd
,replace(replace(t1.rela_tran_id,chr(13),''),chr(10),'') as rela_tran_id
,replace(replace(t1.portf_tran_id,chr(13),''),chr(10),'') as portf_tran_id
,replace(replace(t1.portf_id,chr(13),''),chr(10),'') as portf_id
,replace(replace(t1.portf_name,chr(13),''),chr(10),'') as portf_name
,replace(replace(t1.portf_type_name,chr(13),''),chr(10),'') as portf_type_name
,replace(replace(t1.portf_status_cd,chr(13),''),chr(10),'') as portf_status_cd
,replace(replace(t1.portf_rela_tran_id,chr(13),''),chr(10),'') as portf_rela_tran_id
,replace(replace(t1.ib_lend_type_cd,chr(13),''),chr(10),'') as ib_lend_type_cd
,replace(replace(t1.clear_org_cd,chr(13),''),chr(10),'') as clear_org_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_rat_tenor_cd,chr(13),''),chr(10),'') as int_rat_tenor_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.int_rat_float_dir_cd,chr(13),''),chr(10),'') as int_rat_float_dir_cd
,int_rat_float_point
,replace(replace(t1.pay_int_freq,chr(13),''),chr(10),'') as pay_int_freq
,replace(replace(t1.pay_stub_proc_way_cd,chr(13),''),chr(10),'') as pay_stub_proc_way_cd
,curr_bal
,replace(replace(t1.inpwn_way_descb,chr(13),''),chr(10),'') as inpwn_way_descb
,replace(replace(t1.bond_curr_cd,chr(13),''),chr(10),'') as bond_curr_cd
,convt_ratio
,replace(replace(t1.bond_id,chr(13),''),chr(10),'') as bond_id
,fac_val
,cert_face_tot
,create_dt
,update_dt

from ${iml_schema}.agt_fx_ib_lend t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_fx_ib_lend.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
