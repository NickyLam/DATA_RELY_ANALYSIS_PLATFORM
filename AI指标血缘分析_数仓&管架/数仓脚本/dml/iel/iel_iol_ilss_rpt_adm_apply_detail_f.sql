: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_rpt_adm_apply_detail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_rpt_adm_apply_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.data_dt as data_dt
,replace(replace(t.apply_no,chr(13),''),chr(10),'') as apply_no
,replace(replace(t.customer_no,chr(13),''),chr(10),'') as customer_no
,replace(replace(t.code,chr(13),''),chr(10),'') as code
,replace(replace(t.name,chr(13),''),chr(10),'') as name
,replace(replace(t.id_type,chr(13),''),chr(10),'') as id_type
,replace(replace(t.id_no,chr(13),''),chr(10),'') as id_no
,t.org_id as org_id
,t.apply_limit as apply_limit
,t.quota as quota
,t.begin_day as begin_day
,t.end_day as end_day
,t.apply_time as apply_time
,replace(replace(t.result,chr(13),''),chr(10),'') as result
,replace(replace(t.result_des,chr(13),''),chr(10),'') as result_des
,replace(replace(t.customer_name,chr(13),''),chr(10),'') as customer_name
,replace(replace(t.sex,chr(13),''),chr(10),'') as sex
,t.age as age
,replace(replace(t.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t.marriage,chr(13),''),chr(10),'') as marriage
,replace(replace(t.education,chr(13),''),chr(10),'') as education
,replace(replace(t.company_name,chr(13),''),chr(10),'') as company_name
,replace(replace(t.house_hold,chr(13),''),chr(10),'') as house_hold
,replace(replace(t.drive_type,chr(13),''),chr(10),'') as drive_type
,replace(replace(t.home_perv,chr(13),''),chr(10),'') as home_perv
,replace(replace(t.home_city,chr(13),''),chr(10),'') as home_city
,replace(replace(t.home_address,chr(13),''),chr(10),'') as home_address
from iol.ilss_rpt_adm_apply_detail t
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_rpt_adm_apply_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes