: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_unionpay_comm_fee_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_unionpay_comm_fee_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.unionpay_tran_type_cd,chr(13),''),chr(10),'') as unionpay_tran_type_cd
,replace(replace(t1.trader_type_cd,chr(13),''),chr(10),'') as trader_type_cd
,t1.tran_dt as tran_dt
,t1.int_paybl_amt as int_paybl_amt
,t1.recvbl_amt as recvbl_amt
,t1.front_dt as front_dt
,replace(replace(t1.front_flow_num,chr(13),''),chr(10),'') as front_flow_num
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,t1.core_tran_dt as core_tran_dt
,replace(replace(t1.unionpay_front_tran_status_cd,chr(13),''),chr(10),'') as unionpay_front_tran_status_cd
,replace(replace(t1.err_cd,chr(13),''),chr(10),'') as err_cd
,replace(replace(t1.err_info_desc,chr(13),''),chr(10),'') as err_info_desc
,t1.paybl_exch_fee as paybl_exch_fee
,t1.recvbl_exch_fee as recvbl_exch_fee
,t1.tran_clear_fee as tran_clear_fee
from ${iml_schema}.evt_unionpay_comm_fee_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_unionpay_comm_fee_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes