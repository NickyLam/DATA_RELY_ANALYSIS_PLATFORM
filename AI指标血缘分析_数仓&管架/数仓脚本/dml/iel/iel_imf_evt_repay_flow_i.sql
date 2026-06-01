: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_repay_flow_i
CreateDate: 20221122
FileName:   ${iel_data_path}/evt_repay_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.callbk_id,chr(13),''),chr(10),'') as callbk_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,loan_repay_dt
,replace(replace(t1.loan_repay_type_cd,chr(13),''),chr(10),'') as loan_repay_type_cd
,replace(replace(t1.pay_cust_id,chr(13),''),chr(10),'') as pay_cust_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,cny_exch_rat
,replace(replace(t1.exch_way_cd,chr(13),''),chr(10),'') as exch_way_cd
,callbk_pric
,bus_tran_dt
,replace(replace(t1.callbk_prod_way_cd,chr(13),''),chr(10),'') as callbk_prod_way_cd
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.repay_plan_modif_way_cd,chr(13),''),chr(10),'') as repay_plan_modif_way_cd
,adv_repay_fee_amt
,adv_repay_pric_amt
,replace(replace(t1.loan_rs_cd,chr(13),''),chr(10),'') as loan_rs_cd
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,replace(replace(t1.tran_stl_flg,chr(13),''),chr(10),'') as tran_stl_flg
,tran_stl_dt
,replace(replace(t1.acct_aldy_check_flg,chr(13),''),chr(10),'') as acct_aldy_check_flg
,acct_check_dt
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t1.tran_revs_rs_descb,chr(13),''),chr(10),'') as tran_revs_rs_descb
,replace(replace(t1.sellout_flg,chr(13),''),chr(10),'') as sellout_flg
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.adv_bf_repay_repay_plan_modif_way_cd,chr(13),''),chr(10),'') as adv_bf_repay_repay_plan_modif_way_cd
,adv_bf_repay_exp_dt
,nomal_repay_eh_issue_repay_amt
,replace(replace(t1.stl_teller_id,chr(13),''),chr(10),'') as stl_teller_id
,replace(replace(t1.acct_apv_teller_id,chr(13),''),chr(10),'') as acct_apv_teller_id
,replace(replace(t1.ba_auth_teller_id,chr(13),''),chr(10),'') as ba_auth_teller_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,final_modif_dt
,tran_tm
,replace(replace(t1.repay_rstrct_cd,chr(13),''),chr(10),'') as repay_rstrct_cd
,replace(replace(t1.check_entry_code,chr(13),''),chr(10),'') as check_entry_code
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.evt_repay_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_repay_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
