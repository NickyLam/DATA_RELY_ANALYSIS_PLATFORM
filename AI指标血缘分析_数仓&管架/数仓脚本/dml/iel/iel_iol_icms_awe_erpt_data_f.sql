: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_awe_erpt_data_f
CreateDate: 20240802
FileName:   ${iel_data_path}/icms_awe_erpt_data.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,serialno
,relativeserialno
,treeno
,docid
,dirid
,dirname
,guarantyno
,htmldata
,contentlength
,userid
,orgid
,inputdate
,updatedate
,score
,scoredesc
,saved
,migtflag

from ${iol_schema}.icms_awe_erpt_data t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_awe_erpt_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
