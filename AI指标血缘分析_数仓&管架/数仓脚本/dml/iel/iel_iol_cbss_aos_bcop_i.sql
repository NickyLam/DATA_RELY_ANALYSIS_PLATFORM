: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_aos_bcop_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_aos_bcop.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.btdate,chr(13),''),chr(10),'') as btdate
    ,replace(replace(t.bachno,chr(13),''),chr(10),'') as bachno
    ,replace(replace(t.agentp,chr(13),''),chr(10),'') as agentp
    ,replace(replace(t.btprcd,chr(13),''),chr(10),'') as btprcd
    ,t.agntid as agntid
    ,replace(replace(t.mdtrdt,chr(13),''),chr(10),'') as mdtrdt
    ,replace(replace(t.mdtrsq,chr(13),''),chr(10),'') as mdtrsq
    ,replace(replace(t.agacno,chr(13),''),chr(10),'') as agacno
    ,t.tranam as tranam
    ,replace(replace(t.dcmttp,chr(13),''),chr(10),'') as dcmttp
    ,replace(replace(t.dctpid,chr(13),''),chr(10),'') as dctpid
    ,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
    ,replace(replace(t.csextg,chr(13),''),chr(10),'') as csextg
    ,replace(replace(t.detlna,chr(13),''),chr(10),'') as detlna
    ,replace(replace(t.idtftp,chr(13),''),chr(10),'') as idtftp
    ,replace(replace(t.idtfno,chr(13),''),chr(10),'') as idtfno
    ,replace(replace(t.gender,chr(13),''),chr(10),'') as gender
    ,replace(replace(t.debttp,chr(13),''),chr(10),'') as debttp
    ,replace(replace(t.offctl,chr(13),''),chr(10),'') as offctl
    ,replace(replace(t.hometl,chr(13),''),chr(10),'') as hometl
    ,replace(replace(t.mobitl,chr(13),''),chr(10),'') as mobitl
    ,replace(replace(t.mailcd,chr(13),''),chr(10),'') as mailcd
    ,replace(replace(t.mailad,chr(13),''),chr(10),'') as mailad
    ,replace(replace(t.agidtp,chr(13),''),chr(10),'') as agidtp
    ,replace(replace(t.agidno,chr(13),''),chr(10),'') as agidno
    ,replace(replace(t.agcuna,chr(13),''),chr(10),'') as agcuna
    ,t.rvam01 as rvam01
    ,t.rvam02 as rvam02
    ,t.rvam03 as rvam03
    ,replace(replace(t.rvch01,chr(13),''),chr(10),'') as rvch01
    ,replace(replace(t.rvch02,chr(13),''),chr(10),'') as rvch02
    ,replace(replace(t.rvch03,chr(13),''),chr(10),'') as rvch03
    ,replace(replace(t.smrycd,chr(13),''),chr(10),'') as smrycd
    ,replace(replace(t.prrtcd,chr(13),''),chr(10),'') as prrtcd
    ,replace(replace(t.transt,chr(13),''),chr(10),'') as transt
    ,t.sucsam as sucsam
    ,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
    ,replace(replace(t.subsac,chr(13),''),chr(10),'') as subsac
    ,replace(replace(t.dcmtno,chr(13),''),chr(10),'') as dcmtno
    ,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
    ,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
    ,replace(replace(t.erortx,chr(13),''),chr(10),'') as erortx
    ,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
    ,replace(replace(t.ocptid,chr(13),''),chr(10),'') as ocptid
    ,replace(replace(t.ntlycd,chr(13),''),chr(10),'') as ntlycd
    ,replace(replace(t.atchus,chr(13),''),chr(10),'') as atchus
from iol.cbss_aos_bcop t 
  where to_char(t.btdate)= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_aos_bcop.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes