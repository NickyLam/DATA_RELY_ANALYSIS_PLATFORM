: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_epc_payfan_indent_tran_flow_a
CreateDate: 20250910
FileName:   ${iel_data_path}/evt_epc_payfan_indent_tran_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ser_num,chr(13),''),chr(10),'') as ser_num
,replace(replace(t1.order_no,chr(13),''),chr(10),'') as order_no
,indent_amt
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,tran_dt
,replace(replace(t1.sign_ser_num,chr(13),''),chr(10),'') as sign_ser_num
,replace(replace(t1.pay_acct_id,chr(13),''),chr(10),'') as pay_acct_id
,replace(replace(t1.pay_acct_name,chr(13),''),chr(10),'') as pay_acct_name
,replace(replace(t1.pay_acct_type_cd,chr(13),''),chr(10),'') as pay_acct_type_cd
,replace(replace(t1.pay_acct_core_type_cd,chr(13),''),chr(10),'') as pay_acct_core_type_cd
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.recvbl_acct_type_cd,chr(13),''),chr(10),'') as recvbl_acct_type_cd
,replace(replace(t1.recvbl_acct_core_type_cd,chr(13),''),chr(10),'') as recvbl_acct_core_type_cd
,replace(replace(t1.ppp_tran_flow_num,chr(13),''),chr(10),'') as ppp_tran_flow_num
,ppp_init_tran_dt
,replace(replace(t1.ppp_return_info,chr(13),''),chr(10),'') as ppp_return_info
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,init_create_dt
,replace(replace(t1.create_teller_id,chr(13),''),chr(10),'') as create_teller_id
,replace(replace(t1.create_teller_name,chr(13),''),chr(10),'') as create_teller_name
,latest_update_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_teller_name,chr(13),''),chr(10),'') as update_teller_name

from ${iml_schema}.evt_epc_payfan_indent_tran_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_epc_payfan_indent_tran_flow.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
