: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_pfb_froz_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_pfb_froz.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.frozdt,chr(13),''),chr(10),'') as frozdt
,replace(replace(t1.frozsq,chr(13),''),chr(10),'') as frozsq
,t1.sortno as sortno
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t1.frsptp,chr(13),''),chr(10),'') as frsptp
,replace(replace(t1.susbtp,chr(13),''),chr(10),'') as susbtp
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.subsac,chr(13),''),chr(10),'') as subsac
,replace(replace(t1.acctna,chr(13),''),chr(10),'') as acctna
,t1.refram as refram
,t1.cufram as cufram
,replace(replace(t1.matudt,chr(13),''),chr(10),'') as matudt
,replace(replace(t1.idtftp,chr(13),''),chr(10),'') as idtftp
,replace(replace(t1.idtfno,chr(13),''),chr(10),'') as idtfno
,replace(replace(t1.remktx,chr(13),''),chr(10),'') as remktx
,replace(replace(t1.exorgn,chr(13),''),chr(10),'') as exorgn
,replace(replace(t1.exidtp,chr(13),''),chr(10),'') as exidtp
,replace(replace(t1.exidno,chr(13),''),chr(10),'') as exidno
,replace(replace(t1.eidtp2,chr(13),''),chr(10),'') as eidtp2
,replace(replace(t1.eidno2,chr(13),''),chr(10),'') as eidno2
,replace(replace(t1.exusna,chr(13),''),chr(10),'') as exusna
,replace(replace(t1.exuna2,chr(13),''),chr(10),'') as exuna2
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t1.servtp,chr(13),''),chr(10),'') as servtp
 from iol.cbss_pfb_froz T1
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_pfb_froz.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes