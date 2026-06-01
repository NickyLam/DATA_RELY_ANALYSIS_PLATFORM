: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_kna_slep_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_kna_slep.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.acctid,chr(13),''),chr(10),'') as acctid
,replace(replace(t1.acctna,chr(13),''),chr(10),'') as acctna
,replace(replace(t1.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.idtftp,chr(13),''),chr(10),'') as idtftp
,replace(replace(t1.idtfno,chr(13),''),chr(10),'') as idtfno
,replace(replace(t1.opendt,chr(13),''),chr(10),'') as opendt
,replace(replace(t1.opentm,chr(13),''),chr(10),'') as opentm
,replace(replace(t1.lstrdt,chr(13),''),chr(10),'') as lstrdt
,replace(replace(t1.acctst,chr(13),''),chr(10),'') as acctst
,t1.onlnbl as onlnbl
,replace(replace(t1.accst2,chr(13),''),chr(10),'') as accst2
,replace(replace(t1.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t1.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t1.rttrdt,chr(13),''),chr(10),'') as rttrdt
,replace(replace(t1.rttrsq,chr(13),''),chr(10),'') as rttrsq
,replace(replace(t1.erortx,chr(13),''),chr(10),'') as erortx
 from iol.cbss_kna_slep T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_kna_slep.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes