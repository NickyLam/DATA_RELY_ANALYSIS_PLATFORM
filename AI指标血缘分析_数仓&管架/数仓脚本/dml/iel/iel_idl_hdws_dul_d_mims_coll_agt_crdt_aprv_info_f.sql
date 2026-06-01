: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_mims_coll_agt_crdt_aprv_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_mims_coll_agt_crdt_aprv_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.aprv_id,chr(13),''),chr(10),'') as aprv_id
,t1.etl_dt as etl_dt
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
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_rpts_agt_crdt_aprv_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_mims_coll_agt_crdt_aprv_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes