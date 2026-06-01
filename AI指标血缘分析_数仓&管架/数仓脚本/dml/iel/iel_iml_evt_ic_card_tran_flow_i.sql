: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ic_card_tran_flow_i
CreateDate: 20230227
FileName:   ${iel_data_path}/evt_ic_card_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.plat_tran_flow_num,chr(13),''),chr(10),'') as plat_tran_flow_num
,plat_tran_dt
,replace(replace(t1.tran_chn_id,chr(13),''),chr(10),'') as tran_chn_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.sys_flow_num,chr(13),''),chr(10),'') as sys_flow_num
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.card_ser_num,chr(13),''),chr(10),'') as card_ser_num
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,tran_amt
,replace(replace(t1.ic_card_tran_status_cd,chr(13),''),chr(10),'') as ic_card_tran_status_cd
,replace(replace(t1.tran_status_code,chr(13),''),chr(10),'') as tran_status_code
,tran_dt
,tran_tm
,replace(replace(t1.serv_status_descb,chr(13),''),chr(10),'') as serv_status_descb
,replace(replace(t1.app_idf,chr(13),''),chr(10),'') as app_idf
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_termn_id,chr(13),''),chr(10),'') as tran_termn_id
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,clear_dt
,replace(replace(t1.cntpty_acct_num,chr(13),''),chr(10),'') as cntpty_acct_num
,elec_cash_acct_bal
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_cert_type_cd,chr(13),''),chr(10),'') as cust_cert_type_cd
,replace(replace(t1.cust_cert_no,chr(13),''),chr(10),'') as cust_cert_no
,replace(replace(t1.public_agent_name,chr(13),''),chr(10),'') as public_agent_name
,replace(replace(t1.public_agent_cert_type_cd,chr(13),''),chr(10),'') as public_agent_cert_type_cd
,replace(replace(t1.public_agent_cert_no,chr(13),''),chr(10),'') as public_agent_cert_no
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg

from ${iml_schema}.evt_ic_card_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ic_card_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
