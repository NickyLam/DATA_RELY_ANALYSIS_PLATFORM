: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ponl_bk_cust_login_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_ponl_bk_cust_login_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.login_flow_num,chr(13),''),chr(10),'') as login_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.oper_type_cd,chr(13),''),chr(10),'') as oper_type_cd
,replace(replace(t1.login_rest_cd,chr(13),''),chr(10),'') as login_rest_cd
,replace(replace(t1.login_rest_descb,chr(13),''),chr(10),'') as login_rest_descb
,replace(replace(t1.login_user_name,chr(13),''),chr(10),'') as login_user_name
,t1.login_tm as login_tm
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t1.login_equip_num,chr(13),''),chr(10),'') as login_equip_num
,replace(replace(t1.cust_ip,chr(13),''),chr(10),'') as cust_ip
,replace(replace(t1.login_user_id,chr(13),''),chr(10),'') as login_user_id
,replace(replace(t1.login_type_cd,chr(13),''),chr(10),'') as login_type_cd
from ${iml_schema}.evt_ponl_bk_cust_login_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ponl_bk_cust_login_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes