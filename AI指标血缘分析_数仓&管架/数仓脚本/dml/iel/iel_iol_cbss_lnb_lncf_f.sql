: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_lnb_lncf_f
CreateDate: 20221105
FileName:   ${iel_data_path}/cbss_lnb_lncf.f.${batch_date}.dat
IF_mark:    f
Logs:
       sundexin
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.lncfno,chr(13),''),chr(10),'') as lncfno
    ,replace(replace(t.acctid,chr(13),''),chr(10),'') as acctid
    ,replace(replace(t.lncfna,chr(13),''),chr(10),'') as lncfna
    ,replace(replace(t.brchno,chr(13),''),chr(10),'') as brchno
    ,replace(replace(t.prodcd,chr(13),''),chr(10),'') as prodcd
    ,replace(replace(t.dtitcd,chr(13),''),chr(10),'') as dtitcd
    ,replace(replace(t.loancn,chr(13),''),chr(10),'') as loancn
    ,replace(replace(t.dpacno,chr(13),''),chr(10),'') as dpacno
    ,replace(replace(t.inpyac,chr(13),''),chr(10),'') as inpyac
    ,replace(replace(t.cmitac,chr(13),''),chr(10),'') as cmitac
    ,replace(replace(t.cmdpac,chr(13),''),chr(10),'') as cmdpac
    ,replace(replace(t.loantp,chr(13),''),chr(10),'') as loantp
    ,replace(replace(t.crcntp,chr(13),''),chr(10),'') as crcntp
    ,replace(replace(t.coacid,chr(13),''),chr(10),'') as coacid
    ,replace(replace(t.termcd,chr(13),''),chr(10),'') as termcd
    ,replace(replace(t.disbdt,chr(13),''),chr(10),'') as disbdt
    ,replace(replace(t.disbsq,chr(13),''),chr(10),'') as disbsq
    ,replace(replace(t.matudt,chr(13),''),chr(10),'') as matudt
    ,replace(replace(t.prlntg,chr(13),''),chr(10),'') as prlntg
    ,replace(replace(t.unprdt,chr(13),''),chr(10),'') as unprdt
    ,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
    ,t.initam as initam
    ,replace(replace(t.clcptg,chr(13),''),chr(10),'') as clcptg
    ,replace(replace(t.clintg,chr(13),''),chr(10),'') as clintg
    ,replace(replace(t.rmcode,chr(13),''),chr(10),'') as rmcode
    ,replace(replace(t.rpcode,chr(13),''),chr(10),'') as rpcode
    ,replace(replace(t.lnrttp,chr(13),''),chr(10),'') as lnrttp
    ,t.floart as floart
    ,t.npflrt as npflrt
    ,replace(replace(t.inrtdt,chr(13),''),chr(10),'') as inrtdt
    ,replace(replace(t.nxindt,chr(13),''),chr(10),'') as nxindt
    ,t.cntrir as cntrir
    ,t.ovduir as ovduir
    ,replace(replace(t.retnfs,chr(13),''),chr(10),'') as retnfs
    ,replace(replace(t.ipcode,chr(13),''),chr(10),'') as ipcode
    ,replace(replace(t.nxipdt,chr(13),''),chr(10),'') as nxipdt
    ,replace(replace(t.vlsldt,chr(13),''),chr(10),'') as vlsldt
    ,replace(replace(t.azcode,chr(13),''),chr(10),'') as azcode
    ,replace(replace(t.nxisdt,chr(13),''),chr(10),'') as nxisdt
    ,t.torptm as torptm
    ,t.currtm as currtm
    ,t.eppyam as eppyam
    ,t.inddrt as inddrt
    ,replace(replace(t.idmudt,chr(13),''),chr(10),'') as idmudt
    ,replace(replace(t.closdt,chr(13),''),chr(10),'') as closdt
    ,replace(replace(t.clossq,chr(13),''),chr(10),'') as clossq
    ,replace(replace(t.taxstg,chr(13),''),chr(10),'') as taxstg
    ,replace(replace(t.dscrtx,chr(13),''),chr(10),'') as dscrtx
    ,replace(replace(t.cmsqno,chr(13),''),chr(10),'') as cmsqno
    ,replace(replace(t.ovdudt,chr(13),''),chr(10),'') as ovdudt
    ,replace(replace(t.wngpcd,chr(13),''),chr(10),'') as wngpcd
    ,replace(replace(t.indstg,chr(13),''),chr(10),'') as indstg
    ,replace(replace(t.hdintg,chr(13),''),chr(10),'') as hdintg
    ,replace(replace(t.hdindt,chr(13),''),chr(10),'') as hdindt
    ,replace(replace(t.hdinsq,chr(13),''),chr(10),'') as hdinsq
    ,replace(replace(t.lncfst,chr(13),''),chr(10),'') as lncfst
    ,replace(replace(t.lslnst,chr(13),''),chr(10),'') as lslnst
    ,replace(replace(t.devltg,chr(13),''),chr(10),'') as devltg
    ,replace(replace(t.cntrtp,chr(13),''),chr(10),'') as cntrtp
    ,replace(replace(t.reinst,chr(13),''),chr(10),'') as reinst
    ,t.retndt as retndt
    ,replace(replace(t.enpdtp,chr(13),''),chr(10),'') as enpdtp
    ,t.enpdop as enpdop
    ,t.enpdam as enpdam
    ,replace(replace(t.lnppcd,chr(13),''),chr(10),'') as lnppcd
    ,replace(replace(t.custmg,chr(13),''),chr(10),'') as custmg
    ,replace(replace(t.feestp,chr(13),''),chr(10),'') as feestp
    ,t.feesam as feesam
    ,replace(replace(t.isplan,chr(13),''),chr(10),'') as isplan
    ,replace(replace(t.finatp,chr(13),''),chr(10),'') as finatp
    ,replace(replace(t.lnustp,chr(13),''),chr(10),'') as lnustp
    ,t.cnsgam as cnsgam
    ,replace(replace(t.flrttp,chr(13),''),chr(10),'') as flrttp
    ,replace(replace(t.bfintg,chr(13),''),chr(10),'') as bfintg
    ,replace(replace(t.hxdlfg,chr(13),''),chr(10),'') as hxdlfg
    ,replace(replace(t.remart,chr(13),''),chr(10),'') as remart
    ,replace(replace(t.blflag,chr(13),''),chr(10),'') as blflag
    ,replace(replace(t.deacno,chr(13),''),chr(10),'') as deacno
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.cbss_lnb_lncf t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_lnb_lncf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes