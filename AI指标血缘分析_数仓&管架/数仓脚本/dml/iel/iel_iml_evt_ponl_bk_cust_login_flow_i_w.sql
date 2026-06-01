: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ponl_bk_cust_login_flow_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_ponl_bk_cust_login_flow_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.login_flow_num,chr(13),''),chr(10),'') as login_flow_num
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.oper_type_cd,chr(13),''),chr(10),'') as oper_type_cd
,replace(replace(t.login_rest_cd,chr(13),''),chr(10),'') as login_rest_cd
,replace(replace(t.login_rest_descb,chr(13),''),chr(10),'') as login_rest_descb
,replace(replace(t.login_user_name,chr(13),''),chr(10),'') as login_user_name
,t.login_tm as login_tm
,replace(replace(t.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t.login_equip_num,chr(13),''),chr(10),'') as login_equip_num
,replace(replace(t.cust_ip,chr(13),''),chr(10),'') as cust_ip
,replace(replace(t.login_user_id,chr(13),''),chr(10),'') as login_user_id
,replace(replace(t.login_type_cd,chr(13),''),chr(10),'') as login_type_cd
from ${iml_schema}.evt_ponl_bk_cust_login_flow t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ponl_bk_cust_login_flow_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes