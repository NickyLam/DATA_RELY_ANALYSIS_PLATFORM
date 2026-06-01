: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_conl_bk_cust_login_flow_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_conl_bk_cust_login_flow_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t.visit_flow_num,chr(13),''),chr(10),'') as visit_flow_num 
,replace(replace(t.user_seq_num,chr(13),''),chr(10),'') as user_seq_num 
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id 
,replace(replace(t.login_status_cd,chr(13),''),chr(10),'') as login_status_cd 
,t.login_dt as login_dt 
,t.login_tm as login_tm 
,replace(replace(t.cust_ip,chr(13),''),chr(10),'') as cust_ip 
,replace(replace(t.chn_cd,chr(13),''),chr(10),'') as chn_cd 
,replace(replace(t.login_way_cd,chr(13),''),chr(10),'') as login_way_cd 
,replace(replace(t.return_code,chr(13),''),chr(10),'') as return_code 
,replace(replace(t.return_info,chr(13),''),chr(10),'') as return_info 
,replace(replace(t.server_ip,chr(13),''),chr(10),'') as server_ip 
,replace(replace(t.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num 
,replace(replace(t.cust_termn_mac_addr,chr(13),''),chr(10),'') as cust_termn_mac_addr 
from iml.evt_conl_bk_cust_login_flow t
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_conl_bk_cust_login_flow_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes