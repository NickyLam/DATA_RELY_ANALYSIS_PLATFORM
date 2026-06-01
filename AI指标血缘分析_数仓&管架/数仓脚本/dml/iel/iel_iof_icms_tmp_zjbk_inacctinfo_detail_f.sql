: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_tmp_zjbk_inacctinfo_detail_f
CreateDate: 20250108
FileName:   ${iel_data_path}/icms_tmp_zjbk_inacctinfo_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.mngmtorgcode,chr(13),''),chr(10),'') as mngmtorgcode
,replace(replace(t1.acctcode,chr(13),''),chr(10),'') as acctcode
,replace(replace(t1.rptdate,chr(13),''),chr(10),'') as rptdate
,replace(replace(t1.rptdatecode,chr(13),''),chr(10),'') as rptdatecode
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.loanamt,chr(13),''),chr(10),'') as loanamt
,replace(replace(t1.duedate,chr(13),''),chr(10),'') as duedate
,replace(replace(t1.month,chr(13),''),chr(10),'') as month
,replace(replace(t1.contractstatus,chr(13),''),chr(10),'') as contractstatus
,replace(replace(t1.acctbal,chr(13),''),chr(10),'') as acctbal
,replace(replace(t1.remrepprd,chr(13),''),chr(10),'') as remrepprd
,replace(replace(t1.fivecate,chr(13),''),chr(10),'') as fivecate
,replace(replace(t1.overddays,chr(13),''),chr(10),'') as overddays
,replace(replace(t1.overdprd,chr(13),''),chr(10),'') as overdprd
,replace(replace(t1.totoverd,chr(13),''),chr(10),'') as totoverd
,replace(replace(t1.overdprinc,chr(13),''),chr(10),'') as overdprinc
,replace(replace(t1.oved31_60princ,chr(13),''),chr(10),'') as oved31_60princ
,replace(replace(t1.oved61_90princ,chr(13),''),chr(10),'') as oved61_90princ
,replace(replace(t1.oved91_180princ,chr(13),''),chr(10),'') as oved91_180princ
,replace(replace(t1.ovedprinc180,chr(13),''),chr(10),'') as ovedprinc180
,replace(replace(t1.ovedrawbaove180,chr(13),''),chr(10),'') as ovedrawbaove180
,replace(replace(t1.currpyamt,chr(13),''),chr(10),'') as currpyamt
,replace(replace(t1.actrpyamt,chr(13),''),chr(10),'') as actrpyamt
,replace(replace(t1.latrpyamt,chr(13),''),chr(10),'') as latrpyamt
,replace(replace(t1.latrpydate,chr(13),''),chr(10),'') as latrpydate
,replace(replace(t1.fivecateadjdate,chr(13),''),chr(10),'') as fivecateadjdate

from ${iol_schema}.icms_tmp_zjbk_inacctinfo_detail t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_tmp_zjbk_inacctinfo_detail.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
