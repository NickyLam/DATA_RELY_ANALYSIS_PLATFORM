: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_web_mall_indent_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_web_mall_indent_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.indent_flow_num,chr(13),''),chr(10),'') as indent_flow_num
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.init_indent_flow_num,chr(13),''),chr(10),'') as init_indent_flow_num
,t.init_indent_tran_dt as init_indent_tran_dt
,t.tran_dt as tran_dt
,t.tran_tm as tran_tm
,replace(replace(t.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,t.pay_sucs_dt as pay_sucs_dt
,t.pay_sucs_tm as pay_sucs_tm
,replace(replace(t.resp_code,chr(13),''),chr(10),'') as resp_code
,replace(replace(t.resp_code_descb,chr(13),''),chr(10),'') as resp_code_descb
,replace(replace(t.pay_card_num,chr(13),''),chr(10),'') as pay_card_num
,replace(replace(t.card_name,chr(13),''),chr(10),'') as card_name
,replace(replace(t.ibank_no,chr(13),''),chr(10),'') as ibank_no
,replace(replace(t.bank_name,chr(13),''),chr(10),'') as bank_name
,replace(replace(t.card_type_cd,chr(13),''),chr(10),'') as card_type_cd
,replace(replace(t.recv_bill_brch_id,chr(13),''),chr(10),'') as recv_bill_brch_id
,replace(replace(t.caller_ova_flow_num,chr(13),''),chr(10),'') as caller_ova_flow_num
,replace(replace(t.caller_onl_ova_flow_num,chr(13),''),chr(10),'') as caller_onl_ova_flow_num
,replace(replace(t.dispatch_status_cd,chr(13),''),chr(10),'') as dispatch_status_cd
,replace(replace(t.pick_goods_way_cd,chr(13),''),chr(10),'') as pick_goods_way_cd
,replace(replace(t.mercht_no,chr(13),''),chr(10),'') as mercht_no
,replace(replace(t.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t.recver_mobile_no,chr(13),''),chr(10),'') as recver_mobile_no
,replace(replace(t.recver_local_prov,chr(13),''),chr(10),'') as recver_local_prov
,replace(replace(t.recver_local_city,chr(13),''),chr(10),'') as recver_local_city
,replace(replace(t.recver_local_rg_county,chr(13),''),chr(10),'') as recver_local_rg_county
,replace(replace(t.recver_local_town,chr(13),''),chr(10),'') as recver_local_town
,replace(replace(t.recver_dtl_addr,chr(13),''),chr(10),'') as recver_dtl_addr
,t.indent_tot_amt as indent_tot_amt
,replace(replace(t.indent_point_type_cd,chr(13),''),chr(10),'') as indent_point_type_cd
,t.indent_tot_point as indent_tot_point
,t.fregt_amt as fregt_amt
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.cust_open_acct_org_id,chr(13),''),chr(10),'') as cust_open_acct_org_id
,replace(replace(t.bank_cust_mgr_id,chr(13),''),chr(10),'') as bank_cust_mgr_id
,t.tot_comm_fee_inco as tot_comm_fee_inco
,replace(replace(t.agency_id,chr(13),''),chr(10),'') as agency_id
,replace(replace(t.pay_card_open_org_id,chr(13),''),chr(10),'') as pay_card_open_org_id
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,t.surp_aval_amt as surp_aval_amt
,t.surp_aval_point as surp_aval_point
,replace(replace(t.point_mall_order_no,chr(13),''),chr(10),'') as point_mall_order_no
,replace(replace(t.merchd_type_cd,chr(13),''),chr(10),'') as merchd_type_cd
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
from iml.evt_web_mall_indent_info_h t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_web_mall_indent_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes