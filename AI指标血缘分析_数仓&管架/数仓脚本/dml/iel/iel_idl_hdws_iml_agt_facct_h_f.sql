: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_facct_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_facct_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.agt_modf,chr(13),''),chr(10),'') as agt_modf
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.facct_typ_cd,chr(13),''),chr(10),'') as facct_typ_cd
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.assoc_eacct_id,chr(13),''),chr(10),'') as assoc_eacct_id
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.prd_name,chr(13),''),chr(10),'') as prd_name
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
,replace(replace(t1.blng_duty_center_id,chr(13),''),chr(10),'') as blng_duty_center_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.accting_coa_id,chr(13),''),chr(10),'') as accting_coa_id
,t1.open_dt as open_dt
,t1.colse_dt as colse_dt
,t1.effective_dt as effective_dt
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.usable_bal as usable_bal
,t1.actual_bal as actual_bal
,t1.last_bal as last_bal
,t1.frz_bal as frz_bal
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_FACCT_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_FACCT_H') as etl_task_name 
,replace(replace(t1.merch_id,chr(13),''),chr(10),'') as merch_id
,replace(replace(t1.merch_name,chr(13),''),chr(10),'') as merch_name
,t1.merch_up_line_dt as merch_up_line_dt
,replace(replace(t1.open_tm,chr(13),''),chr(10),'') as open_tm
from ${idl_schema}.hdws_iml_agt_facct t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_facct_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes