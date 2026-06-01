: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_intellge_brac_comm_flow_i
CreateDate: 20230131
FileName:   ${iel_data_path}/evt_intellge_brac_comm_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.plat_flow_num,chr(13),''),chr(10),'') as plat_flow_num
,plat_tran_dt
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.sorc_sys_id,chr(13),''),chr(10),'') as sorc_sys_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,chn_dt
,replace(replace(t1.chn_flow_num,chr(13),''),chr(10),'') as chn_flow_num
,replace(replace(t1.back_end_serv_sys_id,chr(13),''),chr(10),'') as back_end_serv_sys_id
,replace(replace(t1.back_end_serv_sys_intfc_id,chr(13),''),chr(10),'') as back_end_serv_sys_intfc_id
,replace(replace(t1.back_end_serv_sys_intfc_name,chr(13),''),chr(10),'') as back_end_serv_sys_intfc_name
,back_end_resp_dt
,replace(replace(t1.back_end_flow_num,chr(13),''),chr(10),'') as back_end_flow_num
,replace(replace(t1.back_end_proc_status_cd,chr(13),''),chr(10),'') as back_end_proc_status_cd
,replace(replace(t1.back_end_process_cd,chr(13),''),chr(10),'') as back_end_process_cd
,replace(replace(t1.back_end_return_info_desc,chr(13),''),chr(10),'') as back_end_return_info_desc
,req_tm
,resp_tm
,replace(replace(t1.main_comm_flg,chr(13),''),chr(10),'') as main_comm_flg
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_num_name,chr(13),''),chr(10),'') as acct_num_name
,tran_amt
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.menu_id,chr(13),''),chr(10),'') as menu_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.menu_name,chr(13),''),chr(10),'') as menu_name
,replace(replace(t1.core_bus_type_cd,chr(13),''),chr(10),'') as core_bus_type_cd
,replace(replace(t1.node_id,chr(13),''),chr(10),'') as node_id
,replace(replace(t1.node_name,chr(13),''),chr(10),'') as node_name

from ${iml_schema}.evt_intellge_brac_comm_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_intellge_brac_comm_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
