: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ref_dist_cd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ref_dist_cd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select rg_cd
,rg_name
,city_cd
,city_name
,prov_cd
,prov_name
,base_std_flg
,std_id
,etl_dt
,job_cd from idl.icrm_ref_dist_cd where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ref_dist_cd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes