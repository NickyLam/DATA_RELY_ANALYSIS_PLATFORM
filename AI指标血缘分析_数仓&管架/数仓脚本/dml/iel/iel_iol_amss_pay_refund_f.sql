: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amss_pay_refund_f
CreateDate: 20251106
FileName:   ${iel_data_path}/amss_pay_refund.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.refund_no,chr(13),''),chr(10),'') as refund_no
,replace(replace(t1.order_no,chr(13),''),chr(10),'') as order_no
,mch_id
,total_fee
,refund_fee
,add_time
,refund_state
,order_state
,replace(replace(t1.trade_type,chr(13),''),chr(10),'') as trade_type
,replace(replace(t1.trade_name,chr(13),''),chr(10),'') as trade_name
,replace(replace(t1.refundid,chr(13),''),chr(10),'') as refundid
,replace(replace(t1.transaction_id,chr(13),''),chr(10),'') as transaction_id
,replace(replace(t1.out_refund_no,chr(13),''),chr(10),'') as out_refund_no
,replace(replace(t1.out_trade_no,chr(13),''),chr(10),'') as out_trade_no
,replace(replace(t1.refund_channel,chr(13),''),chr(10),'') as refund_channel
,replace(replace(t1.refund_user,chr(13),''),chr(10),'') as refund_user
,update_version
,mch_audit
,daemon_audit
,refund_time
,replace(replace(t1.refuse_reason,chr(13),''),chr(10),'') as refuse_reason
,replace(replace(t1.mch_refuse_reason,chr(13),''),chr(10),'') as mch_refuse_reason
,refund_source
,replace(replace(t1.mch_no,chr(13),''),chr(10),'') as mch_no
,replace(replace(t1.mch_name,chr(13),''),chr(10),'') as mch_name
,replace(replace(t1.fee_type,chr(13),''),chr(10),'') as fee_type
,group_id
,replace(replace(t1.groupno,chr(13),''),chr(10),'') as groupno
,center_id
,risk_ctr
,replace(replace(t1.risk_info,chr(13),''),chr(10),'') as risk_info
,replace(replace(t1.mch_audit_user,chr(13),''),chr(10),'') as mch_audit_user
,replace(replace(t1.pt_audit_user,chr(13),''),chr(10),'') as pt_audit_user
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t1.agentno,chr(13),''),chr(10),'') as agentno
,replace(replace(t1.deparno,chr(13),''),chr(10),'') as deparno
,replace(replace(t1.termtype,chr(13),''),chr(10),'') as termtype
,replace(replace(t1.termno,chr(13),''),chr(10),'') as termno
,replace(replace(t1.operno,chr(13),''),chr(10),'') as operno
,replace(replace(t1.shopno,chr(13),''),chr(10),'') as shopno
,mch_review_time
,pt_review_time
,replace(replace(t1.agentid,chr(13),''),chr(10),'') as agentid
,replace(replace(t1.group_no,chr(13),''),chr(10),'') as group_no
,replace(replace(t1.client_ip,chr(13),''),chr(10),'') as client_ip
,replace(replace(t1.data_sign,chr(13),''),chr(10),'') as data_sign
,modify_time
,mdiscount
,replace(replace(t1.union_id,chr(13),''),chr(10),'') as union_id
,replace(replace(t1.bank_type,chr(13),''),chr(10),'') as bank_type
,replace(replace(t1.openid,chr(13),''),chr(10),'') as openid
,replace(replace(t1.sub_openid,chr(13),''),chr(10),'') as sub_openid
,replace(replace(t1.fld_s1,chr(13),''),chr(10),'') as fld_s1
,replace(replace(t1.fld_s2,chr(13),''),chr(10),'') as fld_s2
,replace(replace(t1.fld_s3,chr(13),''),chr(10),'') as fld_s3
,bs_discount
,replace(replace(t1.bs_discount_type,chr(13),''),chr(10),'') as bs_discount_type
,replace(replace(t1.sign_agentno,chr(13),''),chr(10),'') as sign_agentno
,replace(replace(t1.fld_s4,chr(13),''),chr(10),'') as fld_s4
,replace(replace(t1.fld_s5,chr(13),''),chr(10),'') as fld_s5
,replace(replace(t1.fld_s6,chr(13),''),chr(10),'') as fld_s6
,replace(replace(t1.fld_s7,chr(13),''),chr(10),'') as fld_s7
,replace(replace(t1.fld_s8,chr(13),''),chr(10),'') as fld_s8
,mch_discount_amount
,plat_discount_amount
,mch_rate_type
,mch_rate
,cost_rate
,mch_theory_procedure_fee
,mch_real_procedure_fee
,mch_discount_fee
,debit_card_brokerage_limit
,ori_mch_theory_fee
,ori_mch_real_fee
,calc_state
,api_provider
,replace(replace(t1.pay_center_id,chr(13),''),chr(10),'') as pay_center_id
,replace(replace(t1.quick_serial_no,chr(13),''),chr(10),'') as quick_serial_no
,acc_way_period
,replace(replace(t1.acct_dt,chr(13),''),chr(10),'') as acct_dt

from ${iol_schema}.amss_pay_refund t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_pay_refund.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
