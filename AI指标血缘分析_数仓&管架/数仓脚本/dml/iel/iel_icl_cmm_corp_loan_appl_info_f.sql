: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_loan_appl_info_f
CreateDate: 20240603
FileName:   ${iel_data_path}/cmm_corp_loan_appl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.loan_appl_flow_num,chr(13),''),chr(10),'') as loan_appl_flow_num
,replace(replace(t1.rela_appl_flow_num,chr(13),''),chr(10),'') as rela_appl_flow_num
,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,appl_dt
,replace(replace(t1.oper_org_cd,chr(13),''),chr(10),'') as oper_org_cd
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,oper_dt
,replace(replace(t1.rgst_org_cd,chr(13),''),chr(10),'') as rgst_org_cd
,replace(replace(t1.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id
,rgst_dt
,replace(replace(t1.appl_way_cd,chr(13),''),chr(10),'') as appl_way_cd
,tenor_mon
,loan_tenor
,replace(replace(t1.circl_lmt_flg,chr(13),''),chr(10),'') as circl_lmt_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,appl_amt
,apved_dt
,latest_apv_amt
,replace(replace(t1.happ_type_cd,chr(13),''),chr(10),'') as happ_type_cd
,replace(replace(t1.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd
,replace(replace(t1.crdt_agt_id,chr(13),''),chr(10),'') as crdt_agt_id
,bank_fin_tot
,replace(replace(t1.major_guartor_id,chr(13),''),chr(10),'') as major_guartor_id
,replace(replace(t1.major_guar_way_cd,chr(13),''),chr(10),'') as major_guar_way_cd
,replace(replace(t1.guar_way_1,chr(13),''),chr(10),'') as guar_way_1
,replace(replace(t1.guar_way_2,chr(13),''),chr(10),'') as guar_way_2
,replace(replace(t1.other_guar_way_flg,chr(13),''),chr(10),'') as other_guar_way_flg
,replace(replace(t1.major_guartor_name,chr(13),''),chr(10),'') as major_guartor_name
,replace(replace(t1.main_repay_way_cd,chr(13),''),chr(10),'') as main_repay_way_cd
,replace(replace(t1.repay_ped_cd,chr(13),''),chr(10),'') as repay_ped_cd
,replace(replace(t1.sub_repay_way_cd,chr(13),''),chr(10),'') as sub_repay_way_cd
,replace(replace(t1.dir_cd,chr(13),''),chr(10),'') as dir_cd
,replace(replace(t1.usage_descb,chr(13),''),chr(10),'') as usage_descb
,replace(replace(t1.other_usage_descb,chr(13),''),chr(10),'') as other_usage_descb
,replace(replace(t1.effect_flg,chr(13),''),chr(10),'') as effect_flg
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.camp_corp_name,chr(13),''),chr(10),'') as camp_corp_name
,replace(replace(t1.camp_chn_id,chr(13),''),chr(10),'') as camp_chn_id
,replace(replace(t1.host_bank_name,chr(13),''),chr(10),'') as host_bank_name
,replace(replace(t1.patip_loan_bank_name,chr(13),''),chr(10),'') as patip_loan_bank_name
,replace(replace(t1.agent_bank_name,chr(13),''),chr(10),'') as agent_bank_name
,replace(replace(t1.agent_patip_loan_flg,chr(13),''),chr(10),'') as agent_patip_loan_flg
,replace(replace(t1.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg
,replace(replace(t1.risk_type_cd,chr(13),''),chr(10),'') as risk_type_cd
,replace(replace(t1.asset_risk_cls_cd,chr(13),''),chr(10),'') as asset_risk_cls_cd
,replace(replace(t1.crdt_rg_cd,chr(13),''),chr(10),'') as crdt_rg_cd
,replace(replace(t1.class_crdt_flg,chr(13),''),chr(10),'') as class_crdt_flg
,group_crdt_corp_lmt
,group_crdt_corp_open
,group_crdt_ibank_lmt
,group_crdt_ibank_open
,replace(replace(t1.loan_insure_guar_flg,chr(13),''),chr(10),'') as loan_insure_guar_flg
,replace(replace(t1.remote_loan_flg,chr(13),''),chr(10),'') as remote_loan_flg
,replace(replace(t1.estate_fin_flg,chr(13),''),chr(10),'') as estate_fin_flg
,replace(replace(t1.gover_fin_flg,chr(13),''),chr(10),'') as gover_fin_flg
,replace(replace(t1.consm_serv_fin_flg,chr(13),''),chr(10),'') as consm_serv_fin_flg
,replace(replace(t1.br_build_ifin_flg,chr(13),''),chr(10),'') as br_build_ifin_flg
,replace(replace(t1.green_crdt_fin_flg,chr(13),''),chr(10),'') as green_crdt_fin_flg
,replace(replace(t1.turn_crdt_flg,chr(13),''),chr(10),'') as turn_crdt_flg
,replace(replace(t1.bar_flg,chr(13),''),chr(10),'') as bar_flg
,replace(replace(t1.ta_crdt_flg,chr(13),''),chr(10),'') as ta_crdt_flg
,replace(replace(t1.risk_mgr_simus_oper_flg,chr(13),''),chr(10),'') as risk_mgr_simus_oper_flg
,replace(replace(t1.sm_flg,chr(13),''),chr(10),'') as sm_flg
,replace(replace(t1.ky_l_flg,chr(13),''),chr(10),'') as ky_l_flg
,replace(replace(t1.ts_flg,chr(13),''),chr(10),'') as ts_flg
,replace(replace(t1.apv_rest_flow_num,chr(13),''),chr(10),'') as apv_rest_flow_num
,replace(replace(t1.o_use_lmt_all_id,chr(13),''),chr(10),'') as o_use_lmt_all_id
,replace(replace(t1.o_use_lmt_id,chr(13),''),chr(10),'') as o_use_lmt_id
,replace(replace(t1.o_use_lmt_type_cd,chr(13),''),chr(10),'') as o_use_lmt_type_cd
,replace(replace(t1.host_bk_bank_no,chr(13),''),chr(10),'') as host_bk_bank_no
,replace(replace(t1.patip_loan_bank_bank_no,chr(13),''),chr(10),'') as patip_loan_bank_bank_no
,replace(replace(t1.agent_bank_bank_no,chr(13),''),chr(10),'') as agent_bank_bank_no
,replace(replace(t1.ext_rating_rest_cd,chr(13),''),chr(10),'') as ext_rating_rest_cd
,replace(replace(t1.ext_rating_org_name,chr(13),''),chr(10),'') as ext_rating_org_name
,ext_rating_dt
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.lmt_under_sellbl_prod_id,chr(13),''),chr(10),'') as lmt_under_sellbl_prod_id
,replace(replace(t1.proj_fin_flg,chr(13),''),chr(10),'') as proj_fin_flg
,replace(replace(t1.cent_mgmt_dept_cd,chr(13),''),chr(10),'') as cent_mgmt_dept_cd
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd

from ${icl_schema}.cmm_corp_loan_appl_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_loan_appl_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
