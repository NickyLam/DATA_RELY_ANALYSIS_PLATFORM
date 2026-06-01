: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_am_prod_sell_para_f
CreateDate: 20240229
FileName:   ${iel_data_path}/prd_am_prod_sell_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.am_prod_id,chr(13),''),chr(10),'') as am_prod_id
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id
,replace(replace(t1.sell_chn_cd_comb,chr(13),''),chr(10),'') as sell_chn_cd_comb
,replace(replace(t1.sell_rg_cd_comb,chr(13),''),chr(10),'') as sell_rg_cd_comb
,replace(replace(t1.target_cust_type_cd_comb,chr(13),''),chr(10),'') as target_cust_type_cd_comb
,coll_amt_uplmi
,coll_amt_lolmi
,plan_coll_amt
,subscr_amt_sp
,least_supp_amt
,huge_redem_ratio
,lowt_book_lot
,lowt_redem_lot
,replace(replace(t1.inpwned_flg,chr(13),''),chr(10),'') as inpwned_flg
,fir_coll_start_dt
,fir_coll_end_dt
,replace(replace(t1.supt_consmt_flg,chr(13),''),chr(10),'') as supt_consmt_flg
,replace(replace(t1.allow_adv_termnt_flg,chr(13),''),chr(10),'') as allow_adv_termnt_flg
,replace(replace(t1.allow_cust_redem_flg,chr(13),''),chr(10),'') as allow_cust_redem_flg
,replace(replace(t1.deflt_redem_flg,chr(13),''),chr(10),'') as deflt_redem_flg
,replace(replace(t1.advd_found_flg,chr(13),''),chr(10),'') as advd_found_flg
,replace(replace(t1.invest_flg,chr(13),''),chr(10),'') as invest_flg
,replace(replace(t1.ibank_cust_id_comb,chr(13),''),chr(10),'') as ibank_cust_id_comb
,create_dt
,update_dt

from ${iml_schema}.prd_am_prod_sell_para t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_am_prod_sell_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
