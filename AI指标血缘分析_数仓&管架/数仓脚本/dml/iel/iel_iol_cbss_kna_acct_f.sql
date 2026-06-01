: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kna_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kna_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.accstp,chr(13),''),chr(10),'') as accstp
,replace(replace(t.acctna,chr(13),''),chr(10),'') as acctna
,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t.prodcd,chr(13),''),chr(10),'') as prodcd
,replace(replace(t.drawfs,chr(13),''),chr(10),'') as drawfs
,replace(replace(t.pswdfs,chr(13),''),chr(10),'') as pswdfs
,replace(replace(t.tranpw,chr(13),''),chr(10),'') as tranpw
,replace(replace(t.qurypw,chr(13),''),chr(10),'') as qurypw
,replace(replace(t.maxsac,chr(13),''),chr(10),'') as maxsac
,t.subsnm as subsnm
,replace(replace(t.opendt,chr(13),''),chr(10),'') as opendt
,replace(replace(t.optrsq,chr(13),''),chr(10),'') as optrsq
,replace(replace(t.closdt,chr(13),''),chr(10),'') as closdt
,replace(replace(t.clossq,chr(13),''),chr(10),'') as clossq
,replace(replace(t.acctst,chr(13),''),chr(10),'') as acctst
,replace(replace(t.affist,chr(13),''),chr(10),'') as affist
,replace(replace(t.obrchn,chr(13),''),chr(10),'') as obrchn
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_kna_acct t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kna_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes