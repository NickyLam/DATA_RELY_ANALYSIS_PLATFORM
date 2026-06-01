: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_point_mall_pay_flow_f
CreateDate: 20251016
FileName:   ${iel_data_path}/evt_point_mall_pay_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.indent_flow_num,chr(13),''),chr(10),'') as indent_flow_num
,replace(replace(t1.indent_id,chr(13),''),chr(10),'') as indent_id
,tran_dt
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.agency_id,chr(13),''),chr(10),'') as agency_id
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.merchd_type_cd,chr(13),''),chr(10),'') as merchd_type_cd
,replace(replace(t1.mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd
,indent_tot_amt
,indent_tot_point
,replace(replace(t1.point_type_cd,chr(13),''),chr(10),'') as point_type_cd
,indent_eqty_point
,indent_tot_welfare_gold
,surp_welfare_gold
,surp_aval_amt
,surp_aval_point
,surp_aval_eqty_point
,replace(replace(t1.pay_card_num,chr(13),''),chr(10),'') as pay_card_num
,replace(replace(t1.pay_card_open_acct_org_id,chr(13),''),chr(10),'') as pay_card_open_acct_org_id
,replace(replace(t1.card_name,chr(13),''),chr(10),'') as card_name
,replace(replace(t1.card_type_cd,chr(13),''),chr(10),'') as card_type_cd
,replace(replace(t1.ibank_no,chr(13),''),chr(10),'') as ibank_no
,replace(replace(t1.bank_name,chr(13),''),chr(10),'') as bank_name
,pay_sucs_dt
,replace(replace(t1.comb_pay_reb_sucs_flg,chr(13),''),chr(10),'') as comb_pay_reb_sucs_flg
,replace(replace(t1.advise_sucs_flg,chr(13),''),chr(10),'') as advise_sucs_flg
,pay_fail_advise_cnt
,replace(replace(t1.check_bal_flg,chr(13),''),chr(10),'') as check_bal_flg
,replace(replace(t1.rtn_goods_init_indent_flow_num,chr(13),''),chr(10),'') as rtn_goods_init_indent_flow_num
,rtn_goods_init_indent_tran_dt
,replace(replace(t1.init_tran_order_no,chr(13),''),chr(10),'') as init_tran_order_no
,init_indent_tran_dt
,replace(replace(t1.resp_code,chr(13),''),chr(10),'') as resp_code
,replace(replace(t1.resp_descb,chr(13),''),chr(10),'') as resp_descb
,replace(replace(t1.valid_flg,chr(13),''),chr(10),'') as valid_flg
,replace(replace(t1.dispatch_status_cd,chr(13),''),chr(10),'') as dispatch_status_cd

from ${iml_schema}.evt_point_mall_pay_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_point_mall_pay_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
