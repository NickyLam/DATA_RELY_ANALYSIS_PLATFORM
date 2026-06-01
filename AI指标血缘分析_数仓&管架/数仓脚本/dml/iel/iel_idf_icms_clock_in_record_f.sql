: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_icms_clock_in_record_f
CreateDate: 20250514
FileName:   ${iel_data_path}/icms_clock_in_record.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.serialno as serialno
,t1.opttype as opttype
,t1.clockintype as clockintype
,t1.ptytype as ptytype
,t1.ptyname as ptyname
,t1.cellphonenum as cellphonenum
,t1.loaninteamt as loaninteamt
,t1.wthrcancel as wthrcancel
,t1.cancelreason as cancelreason
,t1.ptymanagerid as ptymanagerid
,t1.ptymanagername as ptymanagername
,t1.taskstatus as taskstatus
,t1.inputuserid as inputuserid
,t1.inputorgid as inputorgid
,t1.inputdate as inputdate
,t1.updateuserid as updateuserid
,t1.updateorgid as updateorgid
,t1.updatedate as updatedate
,t1.finishtime as finishtime

from ${idl_schema}.icms_clock_in_record t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_clock_in_record.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
