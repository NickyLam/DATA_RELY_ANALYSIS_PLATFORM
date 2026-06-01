: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_appl_lmt_attach_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_appl_lmt_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.appl_id,chr(13),''),chr(10),'') as appl_id
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
,lmt_next_bus_higt_pm_rat
,lmt_next_bus_init_margin_ratio
,lmt_next_bus_int_rat_lowt_flo_val
,lmt_next_bus_sig_max_amt
,lmt_next_bus_lont_tenor
,lmt_next_bus_delay_renew_tenor
,replace(replace(t1.public_crdt_flg,chr(13),''),chr(10),'') as public_crdt_flg
,replace(replace(t1.lmt_dir_use_flg,chr(13),''),chr(10),'') as lmt_dir_use_flg
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.lmt_kind_cd,chr(13),''),chr(10),'') as lmt_kind_cd
,replace(replace(t1.group_lmt_crtl_mode_cd,chr(13),''),chr(10),'') as group_lmt_crtl_mode_cd
,replace(replace(t1.under_bus_curr_cd_range,chr(13),''),chr(10),'') as under_bus_curr_cd_range
,lmt_amt
,lmt_open_amt
,used_amt
,used_open_amt
,aval_amt
,aval_open_amt
,lmt_latest_use_dt
,replace(replace(t1.ta_crdt_flg,chr(13),''),chr(10),'') as ta_crdt_flg
,replace(replace(t1.yh_crdt_cust_flg,chr(13),''),chr(10),'') as yh_crdt_cust_flg
,replace(replace(t1.turn_crdt_flg,chr(13),''),chr(10),'') as turn_crdt_flg
,replace(replace(t1.group_apv_id,chr(13),''),chr(10),'') as group_apv_id
,replace(replace(t1.o_use_lmt_flow_num,chr(13),''),chr(10),'') as o_use_lmt_flow_num
,replace(replace(t1.o_use_lmt_type_cd,chr(13),''),chr(10),'') as o_use_lmt_type_cd
,replace(replace(t1.o_use_lmt_owner_id,chr(13),''),chr(10),'') as o_use_lmt_owner_id
,replace(replace(t1.sm_retl_flg,chr(13),''),chr(10),'') as sm_retl_flg
,replace(replace(t1.add_ba_lmt_spcl_discnt_flg,chr(13),''),chr(10),'') as add_ba_lmt_spcl_discnt_flg
,appl_syn_loan_tot_amt
,replace(replace(t1.agent_patip_loan_flg,chr(13),''),chr(10),'') as agent_patip_loan_flg
,replace(replace(t1.ocup_o_use_lmt_flg,chr(13),''),chr(10),'') as ocup_o_use_lmt_flg
,replace(replace(t1.have_incre_crdt_flg,chr(13),''),chr(10),'') as have_incre_crdt_flg
,comn_risk_open_lmt
,replace(replace(t1.estate_fin_flg,chr(13),''),chr(10),'') as estate_fin_flg
,replace(replace(t1.gover_class_fin_flg,chr(13),''),chr(10),'') as gover_class_fin_flg
,replace(replace(t1.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd
,replace(replace(t1.class_crdt_flg,chr(13),''),chr(10),'') as class_crdt_flg
,ibank_lmt_amt
,ibank_open_amt
,onl_lmt_amt
,replace(replace(t1.green_crdt_fin_flg,chr(13),''),chr(10),'') as green_crdt_fin_flg
,replace(replace(t1.consm_serv_class_fin_flg,chr(13),''),chr(10),'') as consm_serv_class_fin_flg
,replace(replace(t1.br_build_ifin_flg,chr(13),''),chr(10),'') as br_build_ifin_flg
,replace(replace(t1.level11_cls_cd,chr(13),''),chr(10),'') as level11_cls_cd
,replace(replace(t1.crdt_rg_cd,chr(13),''),chr(10),'') as crdt_rg_cd
,replace(replace(t1.ext_rating_rest_cd,chr(13),''),chr(10),'') as ext_rating_rest_cd
,replace(replace(t1.ext_rating_org_name,chr(13),''),chr(10),'') as ext_rating_org_name
,ext_rating_dt

from ${iml_schema}.agt_loan_appl_lmt_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_appl_lmt_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
