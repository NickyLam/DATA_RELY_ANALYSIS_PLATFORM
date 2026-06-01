: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_loan_appl_info_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_corp_loan_appl_info.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.etl_dt as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.loan_appl_flow_num,chr(13),''),chr(10),'') as loan_appl_flow_num
,replace(replace(t.rela_appl_flow_num,chr(13),''),chr(10),'') as rela_appl_flow_num
,replace(replace(t.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,t.appl_dt as appl_dt
,replace(replace(t.oper_org_cd,chr(13),''),chr(10),'') as oper_org_cd
,replace(replace(t.operr_id,chr(13),''),chr(10),'') as operr_id
,t.oper_dt as oper_dt
,replace(replace(t.rgst_org_cd,chr(13),''),chr(10),'') as rgst_org_cd
,replace(replace(t.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id
,t.rgst_dt as rgst_dt
,replace(replace(t.appl_way_cd,chr(13),''),chr(10),'') as appl_way_cd
,t.tenor_mon as tenor_mon
,t.loan_tenor as loan_tenor
,replace(replace(t.circl_lmt_flg,chr(13),''),chr(10),'') as circl_lmt_flg
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.appl_amt as appl_amt
,t.apved_dt as apved_dt
,t.latest_apv_amt as latest_apv_amt
,replace(replace(t.happ_type_cd,chr(13),''),chr(10),'') as happ_type_cd
,replace(replace(t.cap_src_cd,chr(13),''),chr(10),'') as cap_src_cd
,replace(replace(t.crdt_agt_id,chr(13),''),chr(10),'') as crdt_agt_id
,t.bank_fin_tot as bank_fin_tot
,replace(replace(t.major_guartor_id,chr(13),''),chr(10),'') as major_guartor_id
,replace(replace(t.major_guar_way_cd,chr(13),''),chr(10),'') as major_guar_way_cd
,replace(replace(t.guar_way_1,chr(13),''),chr(10),'') as guar_way_1
,replace(replace(t.guar_way_2,chr(13),''),chr(10),'') as guar_way_2
,replace(replace(t.other_guar_way_flg,chr(13),''),chr(10),'') as other_guar_way_flg
,replace(replace(t.major_guartor_name,chr(13),''),chr(10),'') as major_guartor_name
,replace(replace(t.main_repay_way_cd,chr(13),''),chr(10),'') as main_repay_way_cd
,replace(replace(t.repay_ped_cd,chr(13),''),chr(10),'') as repay_ped_cd
,replace(replace(t.sub_repay_way_cd,chr(13),''),chr(10),'') as sub_repay_way_cd
,replace(replace(t.dir_cd,chr(13),''),chr(10),'') as dir_cd
,replace(replace(t.usage_descb,chr(13),''),chr(10),'') as usage_descb
,replace(replace(t.other_usage_descb,chr(13),''),chr(10),'') as other_usage_descb
,replace(replace(t.effect_flg,chr(13),''),chr(10),'') as effect_flg
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.camp_corp_name,chr(13),''),chr(10),'') as camp_corp_name
,replace(replace(t.camp_chn_id,chr(13),''),chr(10),'') as camp_chn_id
,replace(replace(t.host_bank_name,chr(13),''),chr(10),'') as host_bank_name
,replace(replace(t.patip_loan_bank_name,chr(13),''),chr(10),'') as patip_loan_bank_name
,replace(replace(t.agent_bank_name,chr(13),''),chr(10),'') as agent_bank_name
,replace(replace(t.agent_patip_loan_flg,chr(13),''),chr(10),'') as agent_patip_loan_flg
,replace(replace(t.low_risk_bus_flg,chr(13),''),chr(10),'') as low_risk_bus_flg
,replace(replace(t.risk_type_cd,chr(13),''),chr(10),'') as risk_type_cd
,replace(replace(t.asset_risk_cls_cd,chr(13),''),chr(10),'') as asset_risk_cls_cd
,replace(replace(t.crdt_rg_cd,chr(13),''),chr(10),'') as crdt_rg_cd
,replace(replace(t.class_crdt_flg,chr(13),''),chr(10),'') as class_crdt_flg
,t.group_crdt_corp_lmt as group_crdt_corp_lmt
,t.group_crdt_corp_open as group_crdt_corp_open
,t.group_crdt_ibank_lmt as group_crdt_ibank_lmt
,t.group_crdt_ibank_open as group_crdt_ibank_open
,replace(replace(t.loan_insure_guar_flg,chr(13),''),chr(10),'') as loan_insure_guar_flg
,replace(replace(t.remote_loan_flg,chr(13),''),chr(10),'') as remote_loan_flg
,replace(replace(t.estate_fin_flg,chr(13),''),chr(10),'') as estate_fin_flg
,replace(replace(t.gover_fin_flg,chr(13),''),chr(10),'') as gover_fin_flg
,replace(replace(t.consm_serv_fin_flg,chr(13),''),chr(10),'') as consm_serv_fin_flg
,replace(replace(t.br_build_ifin_flg,chr(13),''),chr(10),'') as br_build_ifin_flg
,replace(replace(t.green_crdt_fin_flg,chr(13),''),chr(10),'') as green_crdt_fin_flg
,replace(replace(t.turn_crdt_flg,chr(13),''),chr(10),'') as turn_crdt_flg
,replace(replace(t.bar_flg,chr(13),''),chr(10),'') as bar_flg
,replace(replace(t.ta_crdt_flg,chr(13),''),chr(10),'') as ta_crdt_flg
,replace(replace(t.risk_mgr_simus_oper_flg,chr(13),''),chr(10),'') as risk_mgr_simus_oper_flg
,replace(replace(t.sm_flg,chr(13),''),chr(10),'') as sm_flg
,replace(replace(t.ky_l_flg,chr(13),''),chr(10),'') as ky_l_flg
,replace(replace(t.ts_flg,chr(13),''),chr(10),'') as ts_flg
,replace(replace(t.apv_rest_flow_num,chr(13),''),chr(10),'') as apv_rest_flow_num
,replace(replace(t.o_use_lmt_all_id,chr(13),''),chr(10),'') as o_use_lmt_all_id
,replace(replace(t.o_use_lmt_id,chr(13),''),chr(10),'') as o_use_lmt_id
,replace(replace(t.o_use_lmt_type_cd,chr(13),''),chr(10),'') as o_use_lmt_type_cd
from icl.cmm_corp_loan_appl_info t
where t.etl_dt >= to_date('20201201','yyyymmdd') and t.etl_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_loan_appl_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes