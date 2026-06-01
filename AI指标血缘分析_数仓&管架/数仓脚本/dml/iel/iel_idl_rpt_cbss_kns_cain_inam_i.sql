: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_kns_cain_inam_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_kns_cain_inam.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.datadt,chr(13),''),chr(10),'') as datadt
,replace(replace(t1.acctna,chr(13),''),chr(10),'') as acctna
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.subsac,chr(13),''),chr(10),'') as subsac
,replace(replace(t1.acctid,chr(13),''),chr(10),'') as acctid
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t1.dtitcd,chr(13),''),chr(10),'') as dtitcd
,replace(replace(t1.knatyp,chr(13),''),chr(10),'') as knatyp
,replace(replace(t1.debttp,chr(13),''),chr(10),'') as debttp
,replace(replace(t1.termcd,chr(13),''),chr(10),'') as termcd
,replace(replace(t1.cntflg,chr(13),''),chr(10),'') as cntflg
,t1.instrt as instrt
,t1.nwinrt as nwinrt
,replace(replace(t1.bgindt,chr(13),''),chr(10),'') as bgindt
,replace(replace(t1.matudt,chr(13),''),chr(10),'') as matudt
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,t1.lsinam as lsinam
,t1.oninam as oninam
,t1.pyinam as pyinam
,t1.onlnbl as onlnbl
,t1.instam as instam
,replace(replace(t1.acctst,chr(13),''),chr(10),'') as acctst
,t1.listrt as listrt
from ${iol_schema}.cbss_kns_cain_inam t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_kns_cain_inam.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes