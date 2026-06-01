: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_tgls_gla_vchr_h_a
CreateDate: 20240923
FileName:   ${iel_data_path}/tgls_gla_vchr_h.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.etl_dt
,t1.stacid as stacid
,replace(replace(t1.systid,chr(13),''),chr(10),'') as systid
,replace(replace(t1.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t1.vchrsq,chr(13),''),chr(10),'') as vchrsq
,replace(replace(t1.tranbr,chr(13),''),chr(10),'') as tranbr
,replace(replace(t1.acctbr,chr(13),''),chr(10),'') as acctbr
,replace(replace(t1.itemcd,chr(13),''),chr(10),'') as itemcd
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t1.ioflag,chr(13),''),chr(10),'') as ioflag
,replace(replace(t1.centcd,chr(13),''),chr(10),'') as centcd
,replace(replace(t1.prsncd,chr(13),''),chr(10),'') as prsncd
,replace(replace(t1.custcd,chr(13),''),chr(10),'') as custcd
,replace(replace(t1.prducd,chr(13),''),chr(10),'') as prducd
,replace(replace(t1.prlncd,chr(13),''),chr(10),'') as prlncd
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.trantp,chr(13),''),chr(10),'') as trantp
,replace(replace(t1.amntcd,chr(13),''),chr(10),'') as amntcd
,t1.tranam as tranam
,t1.tranbl as tranbl
,replace(replace(t1.blncdn,chr(13),''),chr(10),'') as blncdn
,replace(replace(t1.smrytx,chr(13),''),chr(10),'') as smrytx
,t1.exchcn as exchcn
,t1.exchus as exchus
,replace(replace(t1.usercd,chr(13),''),chr(10),'') as usercd
,replace(replace(t1.sourdt,chr(13),''),chr(10),'') as sourdt
,replace(replace(t1.soursq,chr(13),''),chr(10),'') as soursq
,replace(replace(t1.sourst,chr(13),''),chr(10),'') as sourst
,replace(replace(t1.srvcsq,chr(13),''),chr(10),'') as srvcsq
,t1.bearbl as bearbl
,replace(replace(t1.beardn,chr(13),''),chr(10),'') as beardn
,replace(replace(t1.toitem,chr(13),''),chr(10),'') as toitem
,replace(replace(t1.assis0,chr(13),''),chr(10),'') as assis0
,replace(replace(t1.assis1,chr(13),''),chr(10),'') as assis1
,replace(replace(t1.assis2,chr(13),''),chr(10),'') as assis2
,replace(replace(t1.assis3,chr(13),''),chr(10),'') as assis3
,replace(replace(t1.assis4,chr(13),''),chr(10),'') as assis4
,replace(replace(t1.assis5,chr(13),''),chr(10),'') as assis5
,replace(replace(t1.assis6,chr(13),''),chr(10),'') as assis6
,replace(replace(t1.assis7,chr(13),''),chr(10),'') as assis7
,replace(replace(t1.assis8,chr(13),''),chr(10),'') as assis8
,replace(replace(t1.assis9,chr(13),''),chr(10),'') as assis9
,t1.tranno as tranno
,replace(replace(t1.clertg,chr(13),''),chr(10),'') as clertg
,replace(replace(t1.clerod,chr(13),''),chr(10),'') as clerod
,replace(replace(t1.centsq,chr(13),''),chr(10),'') as centsq
,replace(replace(t1.brchsq,chr(13),''),chr(10),'') as brchsq
,replace(replace(t1.clerdt,chr(13),''),chr(10),'') as clerdt
,replace(replace(t1.transt,chr(13),''),chr(10),'') as transt
,replace(replace(t1.subsac,chr(13),''),chr(10),'') as subsac
,t1.sourac as sourac
,replace(replace(t1.strkst,chr(13),''),chr(10),'') as strkst
,replace(replace(t1.odbsdt,chr(13),''),chr(10),'') as odbsdt
,replace(replace(t1.odbssq,chr(13),''),chr(10),'') as odbssq
,replace(replace(t1.bathid,chr(13),''),chr(10),'') as bathid
,t1.tranti as tranti
,replace(replace(t1.smrycd,chr(13),''),chr(10),'') as smrycd
,replace(replace(t1.dcmtno,chr(13),''),chr(10),'') as dcmtno
,replace(replace(t1.bsnssq,chr(13),''),chr(10),'') as bsnssq
,t1.foldcn as foldcn
,replace(replace(t1.itemna,chr(13),''),chr(10),'') as itemna
,replace(replace(t1.istbgz,chr(13),''),chr(10),'') as istbgz
from ${iol_schema}.tgls_gla_vchr_h t1
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tgls_gla_vchr_h.a.${batch_date}.dat" \
        charset=utf8
        safe=yes