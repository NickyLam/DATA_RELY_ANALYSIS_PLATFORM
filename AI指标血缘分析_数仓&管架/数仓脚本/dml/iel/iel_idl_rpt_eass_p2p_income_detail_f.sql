: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_eass_p2p_income_detail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_eass_p2p_income_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.p2p_income_detail_id,chr(13),''),chr(10),'') as p2p_income_detail_id
,replace(replace(t1.merchant_id,chr(13),''),chr(10),'') as merchant_id
,replace(replace(t1.invest_obj_id,chr(13),''),chr(10),'') as invest_obj_id
,replace(replace(t1.tran_seq_no,chr(13),''),chr(10),'') as tran_seq_no
,replace(replace(t1.req_seq_no,chr(13),''),chr(10),'') as req_seq_no
,replace(replace(t1.sub_seq_no,chr(13),''),chr(10),'') as sub_seq_no
,replace(replace(t1.bw_ac_no,chr(13),''),chr(10),'') as bw_ac_no
,replace(replace(t1.bw_ac_name,chr(13),''),chr(10),'') as bw_ac_name
,replace(replace(t1.iv_fin_account_id,chr(13),''),chr(10),'') as iv_fin_account_id
,replace(replace(t1.iv_fin_account_name,chr(13),''),chr(10),'') as iv_fin_account_name
,t1.total_amt as total_amt
,t1.income_date as income_date
,t1.amount as amount
,t1.principal_amt as principal_amt
,t1.income_amt as income_amt
,t1.fee_amt as fee_amt
,replace(replace(t1.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,t1.last_updated_stamp as last_updated_stamp
,t1.last_updated_tx_stamp as last_updated_tx_stamp
,t1.created_stamp as created_stamp
,t1.created_tx_stamp as created_tx_stamp
 from iol.eass_p2p_income_detail T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_eass_p2p_income_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes