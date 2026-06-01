: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_crdt_aprv_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_crdt_aprv_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.aprv_id,chr(13),''),chr(10),'') as aprv_id
,replace(replace(t1.agt_modf,chr(13),''),chr(10),'') as agt_modf
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.rela_appl_id,chr(13),''),chr(10),'') as rela_appl_id
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,t1.aprv_dt as aprv_dt
,t1.upda_dt as upda_dt
,replace(replace(t1.occur_typ_cd,chr(13),''),chr(10),'') as occur_typ_cd
,replace(replace(t1.reg_emp_id,chr(13),''),chr(10),'') as reg_emp_id
,replace(replace(t1.reg_org_id,chr(13),''),chr(10),'') as reg_org_id
,replace(replace(t1.operr_emp_id,chr(13),''),chr(10),'') as operr_emp_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,t1.fin_lmt as fin_lmt
,t1.fin_expos as fin_expos
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.aprv_status_cd,chr(13),''),chr(10),'') as aprv_status_cd
,replace(replace(t1.term_corp_cd,chr(13),''),chr(10),'') as term_corp_cd
,t1.loan_term as loan_term
,replace(replace(t1.usage_desc,chr(13),''),chr(10),'') as usage_desc
,replace(replace(t1.use_money_plan,chr(13),''),chr(10),'') as use_money_plan
,replace(replace(t1.final_aprv_opni,chr(13),''),chr(10),'') as final_aprv_opni
,replace(replace(t1.final_aprv_emp_id,chr(13),''),chr(10),'') as final_aprv_emp_id
,replace(replace(t1.grp_crdt_flg,chr(13),''),chr(10),'') as grp_crdt_flg
,replace(replace(t1.rep_status_cd,chr(13),''),chr(10),'') as rep_status_cd
,replace(replace(t1.circ_flg,chr(13),''),chr(10),'') as circ_flg
,replace(replace(t1.crdt_biz_breed_cd,chr(13),''),chr(10),'') as crdt_biz_breed_cd
,t1.crdt_start_dt as crdt_start_dt
,t1.crdt_due_dt as crdt_due_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_CRDT_APRV_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_CRDT_APRV_INFO_H') as etl_task_name 
,t1.final_apprv_dt as final_apprv_dt
,replace(replace(t1.crdt_lmt_status_cd,chr(13),''),chr(10),'') as crdt_lmt_status_cd
,replace(replace(t1.crdt_regn_cd,chr(13),''),chr(10),'') as crdt_regn_cd
,replace(replace(t1.loan_rat_cd,chr(13),''),chr(10),'') as loan_rat_cd
,replace(replace(t1.e_state_fin_flg,chr(13),''),chr(10),'') as e_state_fin_flg
,replace(replace(t1.gov_type_fin_flg,chr(13),''),chr(10),'') as gov_type_fin_flg
,replace(replace(t1.cnsm_srv_type_fin_flg,chr(13),''),chr(10),'') as cnsm_srv_type_fin_flg
,replace(replace(t1.b_r_cons_fin_flg,chr(13),''),chr(10),'') as b_r_cons_fin_flg
,replace(replace(t1.grn_cms_fin_flg,chr(13),''),chr(10),'') as grn_cms_fin_flg
from ${idl_schema}.hdws_iml_agt_crdt_aprv_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_crdt_aprv_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes