: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_pfb_froz_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_pfb_froz.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.frozdt,chr(13),''),chr(10),'') as frozdt
,replace(replace(t.frozsq,chr(13),''),chr(10),'') as frozsq
,t.sortno as sortno
,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t.frsptp,chr(13),''),chr(10),'') as frsptp
,replace(replace(t.susbtp,chr(13),''),chr(10),'') as susbtp
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.subsac,chr(13),''),chr(10),'') as subsac
,replace(replace(t.acctna,chr(13),''),chr(10),'') as acctna
,t.refram as refram
,t.cufram as cufram
,replace(replace(t.matudt,chr(13),''),chr(10),'') as matudt
,replace(replace(t.idtftp,chr(13),''),chr(10),'') as idtftp
,replace(replace(t.idtfno,chr(13),''),chr(10),'') as idtfno
,replace(replace(t.remktx,chr(13),''),chr(10),'') as remktx
,replace(replace(t.exorgn,chr(13),''),chr(10),'') as exorgn
,replace(replace(t.exidtp,chr(13),''),chr(10),'') as exidtp
,replace(replace(t.exidno,chr(13),''),chr(10),'') as exidno
,replace(replace(t.eidtp2,chr(13),''),chr(10),'') as eidtp2
,replace(replace(t.eidno2,chr(13),''),chr(10),'') as eidno2
,replace(replace(t.exusna,chr(13),''),chr(10),'') as exusna
,replace(replace(t.exuna2,chr(13),''),chr(10),'') as exuna2
,replace(replace(t.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t.servtp,chr(13),''),chr(10),'') as servtp
from ${iol_schema}.cbss_pfb_froz t
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_pfb_froz.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes