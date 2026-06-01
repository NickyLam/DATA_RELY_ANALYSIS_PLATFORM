: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_orws_t_match_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_t_match_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
    ,replace(replace(t.own_organ,chr(13),''),chr(10),'') as own_organ
    ,replace(replace(t.organ_code,chr(13),''),chr(10),'') as organ_code
    ,replace(replace(t.acct_num,chr(13),''),chr(10),'') as acct_num
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.acct_type,chr(13),''),chr(10),'') as acct_type
    ,replace(replace(t.licence_regist_num,chr(13),''),chr(10),'') as licence_regist_num
    ,replace(replace(t.licence_social_num,chr(13),''),chr(10),'') as licence_social_num
    ,replace(replace(t.other_credtype,chr(13),''),chr(10),'') as other_credtype
    ,replace(replace(t.core_people,chr(13),''),chr(10),'') as core_people
    ,replace(replace(t.core_business,chr(13),''),chr(10),'') as core_business
    ,replace(replace(t.people_business,chr(13),''),chr(10),'') as people_business
    ,replace(replace(t.suspend_info,chr(13),''),chr(10),'') as suspend_info
    ,replace(replace(t.manage_state,chr(13),''),chr(10),'') as manage_state
    ,replace(replace(t.abnormal_con,chr(13),''),chr(10),'') as abnormal_con
    ,replace(replace(t.illegal_breach,chr(13),''),chr(10),'') as illegal_breach
    ,replace(replace(t.last_inspect,chr(13),''),chr(10),'') as last_inspect
    ,replace(replace(t.check_dt,chr(13),''),chr(10),'') as check_dt
    ,replace(replace(t.inspect_dt,chr(13),''),chr(10),'') as inspect_dt
    ,t.etl_dt_ora as etl_dt_ora
    ,replace(replace(t.org_num,chr(13),''),chr(10),'') as org_num
    ,replace(replace(t.establish_dt,chr(13),''),chr(10),'') as establish_dt
from iol.orws_t_match_info t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_t_match_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes