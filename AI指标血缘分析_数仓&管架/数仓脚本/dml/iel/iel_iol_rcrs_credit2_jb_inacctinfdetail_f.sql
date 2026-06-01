: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit2_jb_inacctinfdetail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit2_jb_inacctinfdetail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.mngmtorgcode,chr(13),''),chr(10),'') as mngmtorgcode
    ,replace(replace(t.acctcode,chr(13),''),chr(10),'') as acctcode
    ,replace(replace(t.rptdate,chr(13),''),chr(10),'') as rptdate
    ,replace(replace(t.rptdatecode,chr(13),''),chr(10),'') as rptdatecode
    ,replace(replace(t.contractno,chr(13),''),chr(10),'') as contractno
    ,t.loanamt as loanamt
    ,replace(replace(t.duedate,chr(13),''),chr(10),'') as duedate
    ,replace(replace(t.month,chr(13),''),chr(10),'') as month
    ,replace(replace(t.contractstatus,chr(13),''),chr(10),'') as contractstatus
    ,t.acctbal as acctbal
    ,t.remrepprd as remrepprd
    ,replace(replace(t.fivecate,chr(13),''),chr(10),'') as fivecate
    ,t.overddays as overddays
    ,t.overdprd as overdprd
    ,t.totoverd as totoverd
    ,t.overdprinc as overdprinc
    ,t.oved31_60princ as oved31_60princ
    ,t.oved61_90princ as oved61_90princ
    ,t.oved91_180princ as oved91_180princ
    ,t.ovedprinc180 as ovedprinc180
    ,t.ovedrawbaove180 as ovedrawbaove180
    ,t.currpyamt as currpyamt
    ,t.actrpyamt as actrpyamt
    ,t.latrpyamt as latrpyamt
    ,replace(replace(t.latrpydate,chr(13),''),chr(10),'') as latrpydate
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit2_jb_inacctinfdetail t
where  t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit2_jb_inacctinfdetail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes