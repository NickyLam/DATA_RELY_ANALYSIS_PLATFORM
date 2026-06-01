: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_addit_tran_flow_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_addit_tran_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,t.tran_dt as tran_dt
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.addit_prod_id,chr(13),''),chr(10),'') as addit_prod_id
    ,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
    ,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
    ,replace(replace(t.main_prod_id,chr(13),''),chr(10),'') as main_prod_id
    ,replace(replace(t.insure_shares,chr(13),''),chr(10),'') as insure_shares
    ,t.insure_amt as insure_amt
    ,t.insu_benef_lmt as insu_benef_lmt
    ,replace(replace(t.insure_mode_pay_cd,chr(13),''),chr(10),'') as insure_mode_pay_cd
    ,replace(replace(t.pay_years,chr(13),''),chr(10),'') as pay_years
    ,replace(replace(t.guar_tenor_type_cd,chr(13),''),chr(10),'') as guar_tenor_type_cd
    ,replace(replace(t.guar_year_term,chr(13),''),chr(10),'') as guar_year_term
from iml.evt_addit_tran_flow t
  where t.tran_dt <= to_date('${batch_date}','yyyymmdd') and t.tran_dt >= to_date('20210401','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_addit_tran_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes