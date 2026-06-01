: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_conl_bk_cust_login_flow_f
CreateDate: 20221109
FileName:   ${iel_data_path}/evt_conl_bk_cust_login_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.visit_flow_num,chr(13),''),chr(10),'') as visit_flow_num
,replace(replace(t1.user_seq_num,chr(13),''),chr(10),'') as user_seq_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.login_status_cd,chr(13),''),chr(10),'') as login_status_cd
,login_dt
,login_tm
,replace(replace(t1.cust_ip,chr(13),''),chr(10),'') as cust_ip
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t1.login_way_cd,chr(13),''),chr(10),'') as login_way_cd
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,replace(replace(t1.server_ip,chr(13),''),chr(10),'') as server_ip
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.cust_termn_mac_addr,chr(13),''),chr(10),'') as cust_termn_mac_addr
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.evt_conl_bk_cust_login_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_conl_bk_cust_login_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
