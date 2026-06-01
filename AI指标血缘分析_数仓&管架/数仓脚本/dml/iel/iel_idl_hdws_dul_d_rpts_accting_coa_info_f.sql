: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_accting_coa_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_accting_coa_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
accting_coa_id
,etl_dt
,accting_coa_name
,super_accting_coa_id
,coa_hirc_cd
,dtl_coa_flg
,off_coa_flg
,od_can_flg
,bal_dir_cd
,coa_proj_typ_cd
,ast_liab_typ_cd
,coa_src_class_cd
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_accting_coa_info
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_accting_coa_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes