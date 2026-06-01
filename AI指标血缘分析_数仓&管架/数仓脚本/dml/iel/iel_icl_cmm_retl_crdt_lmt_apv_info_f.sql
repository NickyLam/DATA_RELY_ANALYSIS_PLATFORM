: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_retl_crdt_lmt_apv_info_f
CreateDate: 20221202
FileName:   ${iel_data_path}/cmm_retl_crdt_lmt_apv_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.crdt_lmt_apv_flow_num,chr(13),''),chr(10),'') as crdt_lmt_apv_flow_num
,replace(replace(t1.rela_init_cont_id,chr(13),''),chr(10),'') as rela_init_cont_id
,replace(replace(t1.rela_crdt_lmt_apv_flow_num,chr(13),''),chr(10),'') as rela_crdt_lmt_apv_flow_num
,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.happ_type_cd,chr(13),''),chr(10),'') as happ_type_cd
,replace(replace(t1.crdt_rg_rg_cd,chr(13),''),chr(10),'') as crdt_rg_rg_cd
,replace(replace(t1.crdt_apv_status_cd,chr(13),''),chr(10),'') as crdt_apv_status_cd
,replace(replace(t1.rgst_org_cd,chr(13),''),chr(10),'') as rgst_org_cd
,replace(replace(t1.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id
,replace(replace(t1.oper_org_cd,chr(13),''),chr(10),'') as oper_org_cd
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.final_apver_id,chr(13),''),chr(10),'') as final_apver_id
,t1.loan_tenor as loan_tenor
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.crdt_apv_amt as crdt_apv_amt
,t1.crdt_apv_open_amt as crdt_apv_open_amt
,t1.rgst_dt as rgst_dt
,t1.oper_dt as oper_dt
,t1.apv_dt as apv_dt
,t1.apved_dt as apved_dt
,t1.crdt_lmt_begin_dt as crdt_lmt_begin_dt
,t1.crdt_lmt_exp_dt as crdt_lmt_exp_dt
,replace(replace(t1.apved_reply_id,chr(13),''),chr(10),'') as apved_reply_id
,replace(replace(t1.crdt_lmt_effect_flg,chr(13),''),chr(10),'') as crdt_lmt_effect_flg
,replace(replace(t1.lmt_circl_flg,chr(13),''),chr(10),'') as lmt_circl_flg
,replace(replace(t1.group_crdt_flg,chr(13),''),chr(10),'') as group_crdt_flg
,replace(replace(t1.estate_class_fin_flg,chr(13),''),chr(10),'') as estate_class_fin_flg
,replace(replace(t1.gover_class_fin_flg,chr(13),''),chr(10),'') as gover_class_fin_flg
,replace(replace(t1.consm_serv_class_fin_flg,chr(13),''),chr(10),'') as consm_serv_class_fin_flg
,replace(replace(t1.br_build_class_fin_flg,chr(13),''),chr(10),'') as br_build_class_fin_flg
,replace(replace(t1.green_crdt_class_fin_flg,chr(13),''),chr(10),'') as green_crdt_class_fin_flg
,replace(replace(t1.crdt_lmt_apv_opinion,chr(13),''),chr(10),'') as crdt_lmt_apv_opinion
,replace(replace(t1.crdt_lmt_usage_descb,chr(13),''),chr(10),'') as crdt_lmt_usage_descb
,replace(replace(t1.crdt_lmt_spent_plan,chr(13),''),chr(10),'') as crdt_lmt_spent_plan
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
,replace(replace(t1.low_risk_biz_ind,chr(13),''),chr(10),'') as low_risk_biz_ind
,replace(replace(t1.low_risk_biz_type_cd,chr(13),''),chr(10),'') as low_risk_biz_type_cd
,replace(replace(t1.reply_type_cd,chr(13),''),chr(10),'') as reply_type_cd
,replace(replace(t1.cont_regi_ind,chr(13),''),chr(10),'') as cont_regi_ind
,replace(replace(t1.text_cont_id,chr(13),''),chr(10),'') as text_cont_id
,t1.aval_o_use_lmt as aval_o_use_lmt
,replace(replace(t1.ocup_o_use_lmt_flg,chr(13),''),chr(10),'') as ocup_o_use_lmt_flg
,replace(replace(t1.o_use_lmt_id,chr(13),''),chr(10),'') as o_use_lmt_id
,replace(replace(t1.o_use_lmt_type_cd,chr(13),''),chr(10),'') as o_use_lmt_type_cd
,replace(replace(t1.o_use_lmt_all_id,chr(13),''),chr(10),'') as o_use_lmt_all_id
,t1.group_crdt_lmt_corp_part as group_crdt_lmt_corp_part
,t1.group_crdt_expos_corp_part as group_crdt_expos_corp_part
,t1.group_crdt_lmt_ibank_part as group_crdt_lmt_ibank_part
,t1.group_crdt_expos_ibank_part as group_crdt_expos_ibank_part
,replace(replace(t1.rela_group_reply_id,chr(13),''),chr(10),'') as rela_group_reply_id
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd

from ${icl_schema}.cmm_retl_crdt_lmt_apv_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_retl_crdt_lmt_apv_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
