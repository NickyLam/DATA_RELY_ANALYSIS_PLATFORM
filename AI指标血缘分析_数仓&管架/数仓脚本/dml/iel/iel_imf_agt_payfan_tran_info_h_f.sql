: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_payfan_tran_info_h_f
CreateDate: 20230927
FileName:   ${iel_data_path}/agt_payfan_tran_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.trdpty_indent_id,chr(13),''),chr(10),'') as trdpty_indent_id
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.mercht_name,chr(13),''),chr(10),'') as mercht_name
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,tran_dt
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.pay_acct_id,chr(13),''),chr(10),'') as pay_acct_id
,replace(replace(t1.pay_acct_name,chr(13),''),chr(10),'') as pay_acct_name
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_num_name,chr(13),''),chr(10),'') as recvbl_num_name
,indent_amt
,comm_fee_amt
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
,replace(replace(t1.resp_code,chr(13),''),chr(10),'') as resp_code
,replace(replace(t1.resp_info,chr(13),''),chr(10),'') as resp_info
,create_tm
,modif_tm
,replace(replace(t1.bank_bus_flow_num,chr(13),''),chr(10),'') as bank_bus_flow_num
,replace(replace(t1.trdpty_batch_flow_num,chr(13),''),chr(10),'') as trdpty_batch_flow_num
,replace(replace(t1.bank_batch_flow_num,chr(13),''),chr(10),'') as bank_batch_flow_num
,replace(replace(t1.pay_flow_num,chr(13),''),chr(10),'') as pay_flow_num
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num

from ${iml_schema}.agt_payfan_tran_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_payfan_tran_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
