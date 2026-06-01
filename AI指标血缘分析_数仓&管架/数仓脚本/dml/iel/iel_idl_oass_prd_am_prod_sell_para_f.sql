: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_prd_am_prod_sell_para_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_prd_am_prod_sell_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.am_prod_id as am_prod_id
,t1.finc_prod_id as finc_prod_id
,t1.sell_chn_cd_comb as sell_chn_cd_comb
,t1.sell_rg_cd_comb as sell_rg_cd_comb
,t1.target_cust_type_cd_comb as target_cust_type_cd_comb
,t1.coll_amt_uplmi as coll_amt_uplmi
,t1.coll_amt_lolmi as coll_amt_lolmi
,t1.plan_coll_amt as plan_coll_amt
,t1.subscr_amt_sp as subscr_amt_sp
,t1.least_supp_amt as least_supp_amt
,t1.huge_redem_ratio as huge_redem_ratio
,t1.lowt_book_lot as lowt_book_lot
,t1.lowt_redem_lot as lowt_redem_lot
,t1.inpwned_flg as inpwned_flg
,t1.fir_coll_start_dt as fir_coll_start_dt
,t1.fir_coll_end_dt as fir_coll_end_dt
,t1.supt_consmt_flg as supt_consmt_flg
,t1.allow_adv_termnt_flg as allow_adv_termnt_flg
,t1.allow_cust_redem_flg as allow_cust_redem_flg
,t1.deflt_redem_flg as deflt_redem_flg
,t1.advd_found_flg as advd_found_flg
,t1.invest_flg as invest_flg
,t1.ibank_cust_id_comb as ibank_cust_id_comb
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.prod_id as prod_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_prd_am_prod_sell_para t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_prd_am_prod_sell_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
