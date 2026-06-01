: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_trust_day_sell_h_f
CreateDate: 20221021
FileName:   ${iel_data_path}/prd_trust_day_sell_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(prod_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(ta_cd,chr(13),''),chr(10),'')
,issue_dt
,prod_size
,lot
,td_add_lot
,td_decrs_lot
,prod_nv
,prod_fac_val
,aual_yld
,prod_prft
,ten_thous_corp_prft
,replace(replace(prft_assign_flg,chr(13),''),chr(10),'')
,replace(replace(tran_flg,chr(13),''),chr(10),'')
,replace(replace(status_cd,chr(13),''),chr(10),'')
,replace(replace(ld_prod_status_cd,chr(13),''),chr(10),'')
,prod_acm_nv
,start_dt
,end_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')

from ${iml_schema}.prd_trust_day_sell_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_trust_day_sell_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
