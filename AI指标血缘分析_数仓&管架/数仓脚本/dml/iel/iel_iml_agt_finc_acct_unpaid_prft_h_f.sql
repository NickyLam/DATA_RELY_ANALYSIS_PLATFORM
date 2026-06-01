: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_finc_acct_unpaid_prft_h_f
CreateDate: 20230607
FileName:   ${iel_data_path}/agt_finc_acct_unpaid_prft_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
,replace(replace(t1.seller_id,chr(13),''),chr(10),'') as seller_id
,unpaid_prft
,froz_unpaid_prft
,td_add_unpaid_prft
,lot_bal
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,cfm_dt

from ${iml_schema}.agt_finc_acct_unpaid_prft_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_finc_acct_unpaid_prft_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
