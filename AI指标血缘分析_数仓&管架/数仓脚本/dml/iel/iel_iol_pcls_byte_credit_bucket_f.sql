: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pcls_byte_credit_bucket_f
CreateDate: 20250709
FileName:   ${iel_data_path}/pcls_byte_credit_bucket.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.creditline_area,chr(13),''),chr(10),'') as creditline_area
,replace(replace(t1.datecreated1,chr(13),''),chr(10),'') as datecreated1
,appl_cnt
,appl_pass_cnt
,appl_pass_percent

from ${iol_schema}.pcls_byte_credit_bucket t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pcls_byte_credit_bucket.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
