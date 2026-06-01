: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_proj_loan_contr_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_proj_loan_contr_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.loan_contr_id,chr(13),''),chr(10),'') as loan_contr_id
,replace(replace(t1.agt_modf,chr(13),''),chr(10),'') as agt_modf
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.proj_name,chr(13),''),chr(10),'') as proj_name
,replace(replace(t1.proj_typ_desc,chr(13),''),chr(10),'') as proj_typ_desc
,t1.proj_total_invt as proj_total_invt
,t1.proj_capi as proj_capi
,replace(replace(t1.aprv_num,chr(13),''),chr(10),'') as aprv_num
,replace(replace(t1.estab_item_aprv,chr(13),''),chr(10),'') as estab_item_aprv
,replace(replace(t1.plan_lice_id,chr(13),''),chr(10),'') as plan_lice_id
,replace(replace(t1.cons_land_lice_id,chr(13),''),chr(10),'') as cons_land_lice_id
,replace(replace(t1.evtl_lice_id,chr(13),''),chr(10),'') as evtl_lice_id
,replace(replace(t1.cnstr_lice_id,chr(13),''),chr(10),'') as cnstr_lice_id
,replace(replace(t1.other_lice,chr(13),''),chr(10),'') as other_lice
,replace(replace(t1.other_lice_id,chr(13),''),chr(10),'') as other_lice_id
,t1.open_cnstr_dt as open_cnstr_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'AGT_PROJ_LOAN_CONTR_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_PROJ_LOAN_CONTR_INFO_H') as etl_task_name 
from ${idl_schema}.hdws_iml_agt_proj_loan_contr_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_proj_loan_contr_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes