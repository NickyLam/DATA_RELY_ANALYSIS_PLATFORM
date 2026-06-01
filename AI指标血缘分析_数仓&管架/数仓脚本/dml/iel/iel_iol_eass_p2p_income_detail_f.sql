: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eass_p2p_income_detail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/eass_p2p_income_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.p2p_income_detail_id,chr(13),''),chr(10),'') as p2p_income_detail_id
,replace(replace(t.merchant_id,chr(13),''),chr(10),'') as merchant_id
,replace(replace(t.invest_obj_id,chr(13),''),chr(10),'') as invest_obj_id
,replace(replace(t.tran_seq_no,chr(13),''),chr(10),'') as tran_seq_no
,replace(replace(t.req_seq_no,chr(13),''),chr(10),'') as req_seq_no
,replace(replace(t.sub_seq_no,chr(13),''),chr(10),'') as sub_seq_no
,replace(replace(t.bw_ac_no,chr(13),''),chr(10),'') as bw_ac_no
,replace(replace(t.bw_ac_name,chr(13),''),chr(10),'') as bw_ac_name
,replace(replace(t.iv_fin_account_id,chr(13),''),chr(10),'') as iv_fin_account_id
,replace(replace(t.iv_fin_account_name,chr(13),''),chr(10),'') as iv_fin_account_name
,t.total_amt as total_amt
,t.income_date as income_date
,t.amount as amount
,t.principal_amt as principal_amt
,t.income_amt as income_amt
,t.fee_amt as fee_amt
,replace(replace(t.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,t.last_updated_stamp as last_updated_stamp
,t.last_updated_tx_stamp as last_updated_tx_stamp
,t.created_stamp as created_stamp
,t.created_tx_stamp as created_tx_stamp
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.eass_p2p_income_detail t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eass_p2p_income_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes