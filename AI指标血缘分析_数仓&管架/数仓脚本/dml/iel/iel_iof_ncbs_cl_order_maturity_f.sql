: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ncbs_cl_order_maturity_f
CreateDate: 20221114
FileName:   ${iel_data_path}/ncbs_cl_order_maturity.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.order_no,chr(13),''),chr(10),'') as order_no
,replace(replace(t1.order_seq_no,chr(13),''),chr(10),'') as order_seq_no
,maturity_date
,new_maturity_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.ncbs_cl_order_maturity t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_cl_order_maturity.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
