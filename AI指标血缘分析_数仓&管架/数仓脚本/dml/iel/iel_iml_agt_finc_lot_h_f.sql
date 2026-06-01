: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_finc_lot_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_finc_lot_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(agt_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(intnal_cust_id,chr(13),''),chr(10),'')
,replace(replace(seller_cd,chr(13),''),chr(10),'')
,replace(replace(bank_id,chr(13),''),chr(10),'')
,replace(replace(bank_cust_id,chr(13),''),chr(10),'')
,replace(replace(bank_acct_id,chr(13),''),chr(10),'')
,replace(replace(ta_tran_acct_id,chr(13),''),chr(10),'')
,replace(replace(ec_flg,chr(13),''),chr(10),'')
,replace(replace(tran_med_type_cd,chr(13),''),chr(10),'')
,replace(replace(tran_med,chr(13),''),chr(10),'')
,replace(replace(ta_cd,chr(13),''),chr(10),'')
,replace(replace(finc_acct_id,chr(13),''),chr(10),'')
,replace(replace(prod_id,chr(13),''),chr(10),'')
,replace(replace(std_prod_id,chr(13),''),chr(10),'')
,replace(replace(cont_id,chr(13),''),chr(10),'')
,final_tran_dt
,lot_tot
,froz_lot
,lonterm_froz_lot
,replace(replace(deflt_divd_way_cd,chr(13),''),chr(10),'')
,replace(replace(init_divd_way_cd,chr(13),''),chr(10),'')
,replace(replace(tran_belong_org_id,chr(13),''),chr(10),'')
,replace(replace(supp_invest_flg,chr(13),''),chr(10),'')
,buy_cost_amt
,acm_inco_amt
,replace(replace(src_table_name,chr(13),''),chr(10),'')
,comb_invest_lot
,loc_froz_lot

from ${iml_schema}.agt_finc_lot_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_finc_lot_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
