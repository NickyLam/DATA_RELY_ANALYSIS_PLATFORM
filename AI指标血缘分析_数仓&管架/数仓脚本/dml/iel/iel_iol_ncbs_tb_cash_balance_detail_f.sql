: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_tb_cash_balance_detail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ncbs_tb_cash_balance_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.amount as amount
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,t1.cash_num as cash_num
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.par_value_id,chr(13),''),chr(10),'') as par_value_id
,replace(replace(t1.tailbox_id,chr(13),''),chr(10),'') as tailbox_id
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,t1.update_date as update_date
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.ncbs_tb_cash_balance_detail t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_tb_cash_balance_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes