: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_loan_rebuild_book_tab_f
CreateDate: 20251110
FileName:   ${iel_data_path}/icms_loan_rebuild_book_tab.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.duebillserialno,chr(13),''),chr(10),'') as duebillserialno
,replace(replace(t1.loanrebuildtype,chr(13),''),chr(10),'') as loanrebuildtype
,inbusinesssum
,replace(replace(t1.infiveclass,chr(13),''),chr(10),'') as infiveclass
,replace(replace(t1.restructuretheloandate,chr(13),''),chr(10),'') as restructuretheloandate
,exbusinesssum
,replace(replace(t1.exfiveclass,chr(13),''),chr(10),'') as exfiveclass
,replace(replace(t1.exstructuretheloandate,chr(13),''),chr(10),'') as exstructuretheloandate
,replace(replace(t1.exreason,chr(13),''),chr(10),'') as exreason
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,updatedate

from ${iol_schema}.icms_loan_rebuild_book_tab t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_loan_rebuild_book_tab.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
