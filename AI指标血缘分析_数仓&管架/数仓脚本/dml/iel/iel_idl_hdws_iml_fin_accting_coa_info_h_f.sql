: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_fin_accting_coa_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_fin_accting_coa_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.accting_coa_id,chr(13),''),chr(10),'') as accting_coa_id
,t1.etl_dt as st_dt
,t1.etl_dt+1 as end_dt
,replace(replace(t1.accting_coa_name,chr(13),''),chr(10),'') as accting_coa_name
,replace(replace(t1.super_accting_coa_id,chr(13),''),chr(10),'') as super_accting_coa_id
,replace(replace(t1.coa_hirc_cd,chr(13),''),chr(10),'') as coa_hirc_cd
,replace(replace(t1.dtl_coa_flg,chr(13),''),chr(10),'') as dtl_coa_flg
,replace(replace(t1.off_coa_flg,chr(13),''),chr(10),'') as off_coa_flg
,replace(replace(t1.od_can_flg,chr(13),''),chr(10),'') as od_can_flg
,replace(replace(t1.bal_dir_cd,chr(13),''),chr(10),'') as bal_dir_cd
,replace(replace(t1.coa_proj_typ_cd,chr(13),''),chr(10),'') as coa_proj_typ_cd
,replace(replace(t1.ast_liab_typ_cd,chr(13),''),chr(10),'') as ast_liab_typ_cd
,replace(replace(t1.coa_src_class_cd,chr(13),''),chr(10),'') as coa_src_class_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'FIN_ACCTING_COA_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'FIN_ACCTING_COA_INFO_H') as etl_task_name 
from ${idl_schema}.hdws_iml_fin_accting_coa_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_fin_accting_coa_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes