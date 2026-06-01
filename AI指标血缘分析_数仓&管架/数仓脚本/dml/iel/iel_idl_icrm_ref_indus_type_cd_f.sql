: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ref_indus_type_cd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ref_indus_type_cd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select indus_type_cd
,indus_type_name
,indus_cate_cd
,indus_cate_name
,indus_gen_cd
,indus_gen_name
,indus_categy_cd
,indus_categy_name
,etl_dt
,job_cd from idl.icrm_ref_indus_type_cd where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ref_indus_type_cd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes