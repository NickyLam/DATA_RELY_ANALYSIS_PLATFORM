: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_wl_project_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_wl_project.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.project_no,chr(13),''),chr(10),'') as project_no
,replace(replace(t.project_name,chr(13),''),chr(10),'') as project_name
,replace(replace(t.project_describe,chr(13),''),chr(10),'') as project_describe
,replace(replace(t.prod_cate_no,chr(13),''),chr(10),'') as prod_cate_no
,replace(replace(t.channel_no,chr(13),''),chr(10),'') as channel_no
,replace(replace(t.channel_mark,chr(13),''),chr(10),'') as channel_mark
,replace(replace(t.agency_no,chr(13),''),chr(10),'') as agency_no
,replace(replace(t.coop_mode,chr(13),''),chr(10),'') as coop_mode
,t.valid_date as valid_date
,t.finish_date as finish_date
,t.group_id as group_id
,replace(replace(t.branch_code,chr(13),''),chr(10),'') as branch_code
,t.coop_group_id as coop_group_id
,replace(replace(t.coop_branch,chr(13),''),chr(10),'') as coop_branch
,replace(replace(t.data_uuid,chr(13),''),chr(10),'') as data_uuid
,replace(replace(t.create_user,chr(13),''),chr(10),'') as create_user
,t.create_time as create_time
,replace(replace(t.update_user,chr(13),''),chr(10),'') as update_user
,t.update_time as update_time
,t.use_yn as use_yn
from iol.ilss_wl_project t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_wl_project.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes