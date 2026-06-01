: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_apv_lmt_attach_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_apv_lmt_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.apv_flow_num,chr(13),''),chr(10),'') as apv_flow_num
,lmt_next_bus_higt_pm_ratio
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
,lmt_nmal_amt
,lmt_open_amt
,used_nmal_amt
,used_open_amt
,aval_nmal_amt
,aval_open_amt
,lmt_invalid_dt
,replace(replace(t1.group_apv_id,chr(13),''),chr(10),'') as group_apv_id
,replace(replace(t1.group_cust_spcl_lmt_flow_num,chr(13),''),chr(10),'') as group_cust_spcl_lmt_flow_num
,replace(replace(t1.group_cust_spcl_lmt_owner_name,chr(13),''),chr(10),'') as group_cust_spcl_lmt_owner_name
,replace(replace(t1.o_use_lmt_flow_num,chr(13),''),chr(10),'') as o_use_lmt_flow_num
,replace(replace(t1.o_use_lmt_type_cd,chr(13),''),chr(10),'') as o_use_lmt_type_cd
,replace(replace(t1.o_use_lmt_owner_name,chr(13),''),chr(10),'') as o_use_lmt_owner_name
,appl_syn_loan_tot
,replace(replace(t1.agent_patip_loan_flg,chr(13),''),chr(10),'') as agent_patip_loan_flg
,replace(replace(t1.auto_que_lon_post_rept_flg,chr(13),''),chr(10),'') as auto_que_lon_post_rept_flg
,replace(replace(t1.crdtc_auth_blip_flow_num,chr(13),''),chr(10),'') as crdtc_auth_blip_flow_num
,replace(replace(t1.need_annual_vrfction_flg,chr(13),''),chr(10),'') as need_annual_vrfction_flg
,replace(replace(t1.cust_rating_rest_cd,chr(13),''),chr(10),'') as cust_rating_rest_cd
,replace(replace(t1.final_apv_opinion_one,chr(13),''),chr(10),'') as final_apv_opinion_one
,replace(replace(t1.final_apv_opinion_two,chr(13),''),chr(10),'') as final_apv_opinion_two
,apv_dt
,l_ped_annual_vrfction_dt
,curr_issue_annual_vrfction_dt
,corp_lmt_amt
,corp_open_amt
,ibank_lmt_amt
,ibank_open_amt
,replace(replace(t1.under_bus_provi_guar_guar_flg,chr(13),''),chr(10),'') as under_bus_provi_guar_guar_flg
,replace(replace(t1.under_bus_bear_repo_duty_flg,chr(13),''),chr(10),'') as under_bus_bear_repo_duty_flg
,replace(replace(t1.under_bus_major_guar_way_cd,chr(13),''),chr(10),'') as under_bus_major_guar_way_cd
,replace(replace(t1.proj_name,chr(13),''),chr(10),'') as proj_name
,proj_tot_area
,replace(replace(t1.proj_addr,chr(13),''),chr(10),'') as proj_addr
,replace(replace(t1.pre_sell_lics_id,chr(13),''),chr(10),'') as pre_sell_lics_id
,replace(replace(t1.arch_land_plan_lics_id,chr(13),''),chr(10),'') as arch_land_plan_lics_id
,replace(replace(t1.nation_land_use_cert_id,chr(13),''),chr(10),'') as nation_land_use_cert_id
,replace(replace(t1.cnstr_proj_plan_permit_id,chr(13),''),chr(10),'') as cnstr_proj_plan_permit_id
,replace(replace(t1.arch_proj_cnstr_lics_id,chr(13),''),chr(10),'') as arch_proj_cnstr_lics_id
,higt_apv_ratio
,lont_year_tenor
,provi_fund_loan_comm_fee_ratio
,guar_mon_tenor
,onl_lmt
,replace(replace(t1.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd
,replace(replace(t1.crdt_rg_cd,chr(13),''),chr(10),'') as crdt_rg_cd
,replace(replace(t1.invo_estate_fin_flg,chr(13),''),chr(10),'') as invo_estate_fin_flg
,replace(replace(t1.invo_gover_class_fin_flg,chr(13),''),chr(10),'') as invo_gover_class_fin_flg
,replace(replace(t1.consm_serv_class_fin_flg,chr(13),''),chr(10),'') as consm_serv_class_fin_flg
,replace(replace(t1.br_build_ifin_flg,chr(13),''),chr(10),'') as br_build_ifin_flg
,replace(replace(t1.green_crdt_fin_flg,chr(13),''),chr(10),'') as green_crdt_fin_flg
,replace(replace(t1.invest_way_cd,chr(13),''),chr(10),'') as invest_way_cd
,replace(replace(t1.class_crdt_flg,chr(13),''),chr(10),'') as class_crdt_flg
,replace(replace(t1.ta_crdt_flg,chr(13),''),chr(10),'') as ta_crdt_flg
,replace(replace(t1.yh_crdt_cust_flg,chr(13),''),chr(10),'') as yh_crdt_cust_flg
,replace(replace(t1.sm_retl_flg,chr(13),''),chr(10),'') as sm_retl_flg
,replace(replace(t1.add_ba_lmt_spcl_discnt_flg,chr(13),''),chr(10),'') as add_ba_lmt_spcl_discnt_flg
,replace(replace(t1.sm_corp_loan_flg,chr(13),''),chr(10),'') as sm_corp_loan_flg
,replace(replace(t1.hq_idtfy_mode_flg,chr(13),''),chr(10),'') as hq_idtfy_mode_flg
,replace(replace(t1.ocup_o_use_lmt_flg,chr(13),''),chr(10),'') as ocup_o_use_lmt_flg
,comn_risk_open_lmt
,replace(replace(t1.have_incre_crdt_flg,chr(13),''),chr(10),'') as have_incre_crdt_flg
,replace(replace(t1.turn_crdt_flg,chr(13),''),chr(10),'') as turn_crdt_flg
,replace(replace(t1.host_bank_no,chr(13),''),chr(10),'') as host_bank_no
,replace(replace(t1.host_bank_name,chr(13),''),chr(10),'') as host_bank_name
,replace(replace(t1.patip_loan_bank_no,chr(13),''),chr(10),'') as patip_loan_bank_no
,replace(replace(t1.patip_loan_bank_name,chr(13),''),chr(10),'') as patip_loan_bank_name
,replace(replace(t1.agent_bank_no,chr(13),''),chr(10),'') as agent_bank_no
,replace(replace(t1.agent_bank_name,chr(13),''),chr(10),'') as agent_bank_name

from ${iml_schema}.agt_loan_apv_lmt_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_apv_lmt_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
