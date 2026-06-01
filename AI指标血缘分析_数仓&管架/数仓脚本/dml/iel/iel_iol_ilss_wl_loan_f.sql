: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_wl_loan_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_wl_loan.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.apply_id as apply_id
,replace(replace(t.apply_no,chr(13),''),chr(10),'') as apply_no
,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
,t.product_id as product_id
,t.apply_amount as apply_amount
,t.apply_time as apply_time
,replace(replace(t.bank_name,chr(13),''),chr(10),'') as bank_name
,replace(replace(t.bank_card_no,chr(13),''),chr(10),'') as bank_card_no
,t.loan_term as loan_term
,t.loan_rate as loan_rate
,t.service_rate as service_rate
,t.service_fee as service_fee
,t.inst_fee_rate as inst_fee_rate
,t.inst_fee_amount as inst_fee_amount
,t.trans_amount as trans_amount
,t.trans_time as trans_time
,replace(replace(t.operator,chr(13),''),chr(10),'') as operator
,t.status as status
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.create_user,chr(13),''),chr(10),'') as create_user
,t.create_time as create_time
,replace(replace(t.update_user,chr(13),''),chr(10),'') as update_user
,t.update_time as update_time
,t.customer_id as customer_id
,replace(replace(t.bank_card_client,chr(13),''),chr(10),'') as bank_card_client
,replace(replace(t.bank_bind_phone,chr(13),''),chr(10),'') as bank_bind_phone
,t.is_submit as is_submit
,replace(replace(t.card_type,chr(13),''),chr(10),'') as card_type
,replace(replace(t.fail_status,chr(13),''),chr(10),'') as fail_status
,replace(replace(t.trans_seq_no,chr(13),''),chr(10),'') as trans_seq_no
,replace(replace(t.pay_order_id,chr(13),''),chr(10),'') as pay_order_id
,replace(replace(t.loan_seq_no,chr(13),''),chr(10),'') as loan_seq_no
,replace(replace(t.global_seq_no,chr(13),''),chr(10),'') as global_seq_no
,replace(replace(t.trans_status,chr(13),''),chr(10),'') as trans_status
,replace(replace(t.hostcr_seq_no,chr(13),''),chr(10),'') as hostcr_seq_no
,replace(replace(t.hostdr_seq_no,chr(13),''),chr(10),'') as hostdr_seq_no
,replace(replace(t.pay_bank_name,chr(13),''),chr(10),'') as pay_bank_name
,replace(replace(t.pay_bank_card_no,chr(13),''),chr(10),'') as pay_bank_card_no
,replace(replace(t.iou_no,chr(13),''),chr(10),'') as iou_no
,replace(replace(t.trans_method,chr(13),''),chr(10),'') as trans_method
,t.frozen_date as frozen_date
,replace(replace(t.frozen_seq_no,chr(13),''),chr(10),'') as frozen_seq_no
,t.direct_flg as direct_flg
,replace(replace(t.appv_user_id,chr(13),''),chr(10),'') as appv_user_id
,replace(replace(t.refinance_iou_no,chr(13),''),chr(10),'') as refinance_iou_no
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ilss_wl_loan t
where start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_wl_loan.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes