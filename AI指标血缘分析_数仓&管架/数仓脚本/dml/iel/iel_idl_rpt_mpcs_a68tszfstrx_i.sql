: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a68tszfstrx_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a68tszfstrx.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 t1.mainseq as mainseq
,t1.transdt as transdt
,t1.businesstrace as businesstrace
,t1.pckno as pckno
,t1.txtpcd as txtpcd
,t1.txcd as txcd
,t1.txid as txid
,t1.cnsdt as cnsdt
,t1.instgpty as instgpty
,t1.pkgbusinesstrace as pkgbusinesstrace
,t1.pksqno as pksqno
,t1.hosttrcd as hosttrcd
,t1.fronttrcd as fronttrcd
,t1.hostdate as hostdate
,t1.hostnbr as hostnbr
,t1.crcycd as crcycd
,t1.transamt as transamt
,t1.dbtrid as dbtrid
,t1.sndbrnname as sndbrnname
,t1.cdtrid as cdtrid
,t1.rcvbrnname as rcvbrnname
,t1.payopenbank as payopenbank
,t1.payopenbanknm as payopenbanknm
,t1.payacct as payacct
,t1.payname as payname
,t1.payaddr as payaddr
,t1.rcvopenbank as rcvopenbank
,t1.rcvopenbanknm as rcvopenbanknm
,t1.rcvacct as rcvacct
,t1.rcvname as rcvname
,t1.rcvaddr as rcvaddr
,t1.orgnltxtpcd as orgnltxtpcd
,t1.orgnlcnsdt as orgnlcnsdt
,t1.orgnltxid as orgnltxid
,t1.orgnlinstgpty as orgnlinstgpty
,t1.orgnlpkgbustrace as orgnlpkgbustrace
,t1.netgrnd as netgrnd
,t1.netgdt as netgdt
,t1.transt as transt
,t1.iotype as iotype
,t1.flag4 as flag4
,t1.magebrn as magebrn
,t1.oprtlr as oprtlr
,t1.chktlr as chktlr
,t1.sndtlr as sndtlr
,t1.auttlr as auttlr
,t1.oprbrn as oprbrn
,t1.sendbranch as sendbranch
,t1.autbrn as autbrn
,t1.caclrs as caclrs
,t1.processcode as processcode
,t1.rspncd as rspncd
,t1.rspninf as rspninf
,t1.rtncd as rtncd
,t1.rtninf as rtninf
,t1.rtrltd as rtrltd
,t1.diskno as diskno
,t1.clerdt as clerdt
,t1.bperno as bperno
,t1.bpermg as bpermg
,t1.levels as levels
,t1.recdes as recdes
,t1.chksta as chksta
,t1.remark as remark
,t1.prtcnt as prtcnt
,t1.transmitdt as transmitdt
,t1.feeflag as feeflag
,t1.inoutflag as inoutflag
,t1.sacact as sacact
,t1.sacana as sacana
,t1.clendt as clendt
,t1.clenus as clenus
,t1.clrbrn as clrbrn
,t1.edhtno as edhtno
,t1.edhtdt as edhtdt
,t1.endtlr as endtlr
,t1.prdnbr as prdnbr
,t1.bookcd as bookcd
,t1.cobkdt as cobkdt
,t1.booknbr as booknbr
,t1.idtype as idtype
,t1.idno as idno
,t1.transq as transq
,t1.sdtrsq as sdtrsq
,t1.paymod as paymod
,t1.opnwin as opnwin
,t1.feamt1 as feamt1
,t1.feamt2 as feamt2
,t1.feamt3 as feamt3
,t1.calfee as calfee
,t1.chngti as chngti
,t1.rcdsta as rcdsta
,t1.prodcd as prodcd
,t1.isinout as isinout
,t1.inacct as inacct
,t1.inname as inname
,t1.landdealsts as landdealsts
,t1.checkdealsts as checkdealsts
,t1.appenddatatable as appenddatatable
,t1.appenddatadtltab as appenddatadtltab
,t1.hangupreason as hangupreason
,t1.modifytlr as modifytlr
,t1.feetype as feetype
,t1.areacd as areacd
,t1.acctchckflg as acctchckflg
,t1.servmode as servmode
,t1.realtmcdtflg as realtmcdtflg
,t1.chflag as chflag
,t1.protocolnb as protocolnb
,t1.resndflg as resndflg
,t1.bllind as bllind
,t1.blltp as blltp
,t1.billnb as billnb
,t1.channeldt as channeldt
,t1.tranflowno as tranflowno
,t1.orgnlpksqno as orgnlpksqno
,t1.corprtnid as corprtnid
,t1.pmtitmcd as pmtitmcd
,t1.pmtitmnm as pmtitmnm
,t1.billamount as billamount
,t1.feeamount as feeamount
,t1.info2 as info2
,t1.od_flag as od_flag
,t1.od_ovtranam as od_ovtranam
,t1.toaccountflag as toaccountflag
,t1.autoflag as autoflag
,t1.autocount as autocount
,t1.automsg as automsg
,t1.bindacct as bindacct
,t1.bindacctnm as bindacctnm
,t1.eflag as eflag
,t1.upporderid as upporderid
,t1.intoaccounttype as intoaccounttype
,t1.accttype as accttype
,t1.bindacctopnbrn as bindacctopnbrn
,t1.branchid as branchid
 from idl.mpcs_a68tszfstrx T1
where transdt like '%${batch_date}%' and t1.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a68tszfstrx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes