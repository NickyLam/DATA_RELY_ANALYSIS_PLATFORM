: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_kna_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_kna_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.accstp,chr(13),''),chr(10),'') as accstp
,replace(replace(t1.acctna,chr(13),''),chr(10),'') as acctna
,replace(replace(t1.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t1.prodcd,chr(13),''),chr(10),'') as prodcd
,replace(replace(t1.drawfs,chr(13),''),chr(10),'') as drawfs
,replace(replace(t1.pswdfs,chr(13),''),chr(10),'') as pswdfs
,replace(replace(t1.tranpw,chr(13),''),chr(10),'') as tranpw
,replace(replace(t1.qurypw,chr(13),''),chr(10),'') as qurypw
,replace(replace(t1.maxsac,chr(13),''),chr(10),'') as maxsac
,t1.subsnm as subsnm
,replace(replace(t1.opendt,chr(13),''),chr(10),'') as opendt
,replace(replace(t1.optrsq,chr(13),''),chr(10),'') as optrsq
,replace(replace(t1.closdt,chr(13),''),chr(10),'') as closdt
,replace(replace(t1.clossq,chr(13),''),chr(10),'') as clossq
,replace(replace(t1.acctst,chr(13),''),chr(10),'') as acctst
,replace(replace(t1.affist,chr(13),''),chr(10),'') as affist
from ${iol_schema}.cbss_kna_acct t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_kna_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes