: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_crdt_aprv_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_crdt_aprv_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(aprv_id,chr(10),''),chr(13),'') as aprv_id
      ,etl_dt
      ,replace(replace(rela_appl_id,chr(10),''),chr(13),'') as rela_appl_id
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(prd_id,chr(10),''),chr(13),'') as prd_id
      ,aprv_dt
      ,upda_dt
      ,replace(replace(occur_typ_cd,chr(10),''),chr(13),'') as occur_typ_cd
      ,replace(replace(reg_emp_id,chr(10),''),chr(13),'') as reg_emp_id
      ,replace(replace(reg_org_id,chr(10),''),chr(13),'') as reg_org_id
      ,replace(replace(operr_emp_id,chr(10),''),chr(13),'') as operr_emp_id
      ,replace(replace(oper_org_id,chr(10),''),chr(13),'') as oper_org_id
      ,fin_lmt
      ,fin_expos
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,replace(replace(aprv_status_cd,chr(10),''),chr(13),'') as aprv_status_cd
      ,replace(replace(term_corp_cd,chr(10),''),chr(13),'') as term_corp_cd
      ,loan_term
      ,replace(replace(usage_desc,chr(10),''),chr(13),'') as usage_desc
      ,replace(replace(use_money_plan,chr(10),''),chr(13),'') as use_money_plan
      ,replace(replace(final_aprv_opni,chr(10),''),chr(13),'') as final_aprv_opni
      ,replace(replace(final_aprv_emp_id,chr(10),''),chr(13),'') as final_aprv_emp_id
      ,replace(replace(grp_crdt_flg,chr(10),''),chr(13),'') as grp_crdt_flg
      ,replace(replace(rep_status_cd,chr(10),''),chr(13),'') as rep_status_cd
      ,replace(replace(circ_flg,chr(10),''),chr(13),'') as circ_flg
      ,replace(replace(crdt_biz_breed_cd,chr(10),''),chr(13),'') as crdt_biz_breed_cd
      ,crdt_start_dt
      ,crdt_due_dt
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_agt_crdt_aprv_info 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_crdt_aprv_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes