: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_vtms_fin_accting_coa_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_vtms_fin_accting_coa_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.accting_coa_id,chr(13),''),chr(10),'') as accting_coa_id
,replace(replace(t1.data_dt,chr(13),''),chr(10),'') as data_dt
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
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.etl_dt as etl_dt
from ${idl_schema}.hdws_dul_d_vtms_fin_accting_coa_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_vtms_fin_accting_coa_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes