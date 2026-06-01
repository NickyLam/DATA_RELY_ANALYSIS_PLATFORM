: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_pnlt_comp_int_nomal_repay_dtl_i
CreateDate: 20221117
FileName:   ${iel_data_path}/evt_pnlt_comp_int_nomal_repay_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.advise_odd_no,chr(13),''),chr(10),'') as advise_odd_no
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,bus_effect_dt
,bus_invalid_dt
,grace_dt
,doc_exp_dt
,bus_tran_dt
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,iss_amt
,doc_bal
,ld_doc_unpaid_amt
,replace(replace(t1.amt_type_cd,chr(13),''),chr(10),'') as amt_type_cd
,replace(replace(t1.doc_create_way_cd,chr(13),''),chr(10),'') as doc_create_way_cd
,curr_pd
,replace(replace(t1.iss_flg,chr(13),''),chr(10),'') as iss_flg
,replace(replace(t1.doc_full_amt_callbk_flg,chr(13),''),chr(10),'') as doc_full_amt_callbk_flg
,final_stl_dt
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,final_modif_dt

from ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_pnlt_comp_int_nomal_repay_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
