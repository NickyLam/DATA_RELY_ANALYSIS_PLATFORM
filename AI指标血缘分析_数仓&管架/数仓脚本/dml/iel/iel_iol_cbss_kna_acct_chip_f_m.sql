: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kna_acct_chip_f_m
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kna_acct_chip_m.f.${batch_date}.dat
IF_mark:    f_m
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.cardsq,chr(13),''),chr(10),'') as cardsq
,replace(replace(t.custna,chr(13),''),chr(10),'') as custna
,replace(replace(t.idtftp,chr(13),''),chr(10),'') as idtftp
,replace(replace(t.idtfno,chr(13),''),chr(10),'') as idtfno
,replace(replace(t.efctdt,chr(13),''),chr(10),'') as efctdt
,replace(replace(t.inefdt,chr(13),''),chr(10),'') as inefdt
,t.mxblam as mxblam
,t.mxlimt as mxlimt
,t.attrpt as attrpt
,t.attram as attram
,t.saveam as saveam
,t.drawam as drawam
,replace(replace(t.lstoff,chr(13),''),chr(10),'') as lstoff
,t.ofline as ofline
,replace(replace(t.openbr,chr(13),''),chr(10),'') as openbr
,replace(replace(t.opensq,chr(13),''),chr(10),'') as opensq
,t.onlnbl as onlnbl
,replace(replace(t.lstrdt,chr(13),''),chr(10),'') as lstrdt
,replace(replace(t.lstrsq,chr(13),''),chr(10),'') as lstrsq
,replace(replace(t.closdt,chr(13),''),chr(10),'') as closdt
,replace(replace(t.clossq,chr(13),''),chr(10),'') as clossq
,replace(replace(t.acctst,chr(13),''),chr(10),'') as acctst
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_kna_acct_chip t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kna_acct_chip_m.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes