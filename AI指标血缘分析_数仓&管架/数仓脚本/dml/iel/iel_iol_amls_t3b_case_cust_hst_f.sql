: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t3b_case_cust_hst_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t3b_case_cust_hst.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.case_id,chr(13),''),chr(10),'') as case_id
    ,t.stat_dt as stat_dt
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.fetr_ids,chr(13),''),chr(10),'') as fetr_ids
    ,t.rcv_cny_amt as rcv_cny_amt
    ,t.rcv_usd_amt as rcv_usd_amt
    ,t.rcv_cnt as rcv_cnt
    ,t.pay_cny_amt as pay_cny_amt
    ,t.pay_usd_amt as pay_usd_amt
    ,t.pay_cnt as pay_cnt
    ,replace(replace(t.is_del,chr(13),''),chr(10),'') as is_del
    ,replace(replace(t.advice,chr(13),''),chr(10),'') as advice
    ,replace(replace(t.modify_tm,chr(13),''),chr(10),'') as modify_tm
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.is_ctrl,chr(13),''),chr(10),'') as is_ctrl
from iol.amls_t3b_case_cust_hst t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t3b_case_cust_hst.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes