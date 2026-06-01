: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_discount_repo_exp_info_f
CreateDate: 20230602
FileName:   ${iel_data_path}/agt_discount_repo_exp_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.repo_exp_id,chr(13),''),chr(10),'') as repo_exp_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,bus_dt
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.bus_org_id,chr(13),''),chr(10),'') as bus_org_id
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd
,replace(replace(t1.clear_status_cd,chr(13),''),chr(10),'') as clear_status_cd
,final_modif_tm
,create_dt
,update_dt

from ${iml_schema}.agt_discount_repo_exp_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_discount_repo_exp_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
