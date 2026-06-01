: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_distr_finc_lot_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_distr_finc_lot_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.seller_id,chr(13),''),chr(10),'') as seller_id
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'') as src_prod_id
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t1.cust_grouping_cd,chr(13),''),chr(10),'') as cust_grouping_cd
,replace(replace(t1.supp_invest_flg,chr(13),''),chr(10),'') as supp_invest_flg
,lot_tot
,curr_issue_prft
,yld_rat
,buy_cost_amt
,unpaid_prft
,divd_ratio
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id

from ${iml_schema}.agt_distr_finc_lot_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_distr_finc_lot_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
