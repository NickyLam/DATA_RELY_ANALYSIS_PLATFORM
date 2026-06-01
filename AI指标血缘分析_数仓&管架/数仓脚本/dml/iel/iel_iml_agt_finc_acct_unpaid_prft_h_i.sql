: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_finc_acct_unpaid_prft_h_i
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_finc_acct_unpaid_prft_h.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
    ,replace(replace(t.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
    ,replace(replace(t.seller_id,chr(13),''),chr(10),'') as seller_id
    ,t.unpaid_prft as unpaid_prft
    ,t.froz_unpaid_prft as froz_unpaid_prft
    ,t.td_add_unpaid_prft as td_add_unpaid_prft
    ,t.lot_bal as lot_bal
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
    ,t.cfm_dt as cfm_dt
from iml.agt_finc_acct_unpaid_prft_h t
  where t.start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_finc_acct_unpaid_prft_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes