: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_crdt_lmt_apv_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_corp_crdt_lmt_apv_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.crdt_lmt_apv_flow_num,chr(13),''),chr(10),'') as crdt_lmt_apv_flow_num
,replace(replace(t.rela_crdt_lmt_apv_flow_num,chr(13),''),chr(10),'') as rela_crdt_lmt_apv_flow_num
,replace(replace(t.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.happ_type_cd,chr(13),''),chr(10),'') as happ_type_cd
,replace(replace(t.crdt_rg_rg_cd,chr(13),''),chr(10),'') as crdt_rg_rg_cd
,replace(replace(t.crdt_apv_status_cd,chr(13),''),chr(10),'') as crdt_apv_status_cd
,replace(replace(t.rgst_org_cd,chr(13),''),chr(10),'') as rgst_org_cd
,replace(replace(t.rgstrat_id,chr(13),''),chr(10),'') as rgstrat_id
,replace(replace(t.oper_org_cd,chr(13),''),chr(10),'') as oper_org_cd
,replace(replace(t.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t.final_apver_id,chr(13),''),chr(10),'') as final_apver_id
,t.loan_tenor as loan_tenor
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.crdt_apv_amt as crdt_apv_amt
,t.crdt_apv_open_amt as crdt_apv_open_amt
,t.rgst_dt as rgst_dt
,t.apv_dt as apv_dt
,t.apved_dt as apved_dt
,t.crdt_lmt_begin_dt as crdt_lmt_begin_dt
,t.crdt_lmt_exp_dt as crdt_lmt_exp_dt
,replace(replace(t.apved_reply_id,chr(13),''),chr(10),'') as apved_reply_id
,replace(replace(t.crdt_lmt_effect_flg,chr(13),''),chr(10),'') as crdt_lmt_effect_flg
,replace(replace(t.lmt_circl_flg,chr(13),''),chr(10),'') as lmt_circl_flg
,replace(replace(t.group_crdt_flg,chr(13),''),chr(10),'') as group_crdt_flg
,replace(replace(t.estate_class_fin_flg,chr(13),''),chr(10),'') as estate_class_fin_flg
,replace(replace(t.gover_class_fin_flg,chr(13),''),chr(10),'') as gover_class_fin_flg
,replace(replace(t.consm_serv_class_fin_flg,chr(13),''),chr(10),'') as consm_serv_class_fin_flg
,replace(replace(t.br_build_class_fin_flg,chr(13),''),chr(10),'') as br_build_class_fin_flg
,replace(replace(t.green_crdt_class_fin_flg,chr(13),''),chr(10),'') as green_crdt_class_fin_flg
,replace(replace(t.crdt_lmt_apv_opinion,chr(13),''),chr(10),'') as crdt_lmt_apv_opinion
,replace(replace(t.crdt_lmt_usage_descb,chr(13),''),chr(10),'') as crdt_lmt_usage_descb
,replace(replace(t.crdt_lmt_spent_plan,chr(13),''),chr(10),'') as crdt_lmt_spent_plan
from ${icl_schema}.cmm_corp_crdt_lmt_apv_info t
where etl_dt = to_date('${batch_date}','yyyymmdd')    ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_crdt_lmt_apv_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes