: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_cifs_cfb_corp_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_cifs_cfb_corp.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t.psrntg,chr(13),''),chr(10),'') as psrntg
,replace(replace(t.lwctna,chr(13),''),chr(10),'') as lwctna
,replace(replace(t.lwidno,chr(13),''),chr(10),'') as lwidno
,replace(replace(t.cptnnm,chr(13),''),chr(10),'') as cptnnm
,replace(replace(t.vocatp,chr(13),''),chr(10),'') as vocatp
,replace(replace(t.orgacd,chr(13),''),chr(10),'') as orgacd
,replace(replace(t.orgatp,chr(13),''),chr(10),'') as orgatp
,replace(replace(t.orgaed,chr(13),''),chr(10),'') as orgaed
,replace(replace(t.rdtdmk,chr(13),''),chr(10),'') as rdtdmk
,replace(replace(t.orgast,chr(13),''),chr(10),'') as orgast
,replace(replace(t.corpid,chr(13),''),chr(10),'') as corpid
,replace(replace(t.corppr,chr(13),''),chr(10),'') as corppr
,replace(replace(t.corptp,chr(13),''),chr(10),'') as corptp
,replace(replace(t.cpmntp,chr(13),''),chr(10),'') as cpmntp
,replace(replace(t.sizeid,chr(13),''),chr(10),'') as sizeid
,replace(replace(t.rgstad,chr(13),''),chr(10),'') as rgstad
,replace(replace(t.establ,chr(13),''),chr(10),'') as establ
,replace(replace(t.regidt,chr(13),''),chr(10),'') as regidt
,replace(replace(t.regicy,chr(13),''),chr(10),'') as regicy
,t.regiam as regiam
,replace(replace(t.regiad,chr(13),''),chr(10),'') as regiad
,t.stafnm as stafnm
,replace(replace(t.dealsp,chr(13),''),chr(10),'') as dealsp
,t.operar as operar
,replace(replace(t.psarow,chr(13),''),chr(10),'') as psarow
,replace(replace(t.baseno,chr(13),''),chr(10),'') as baseno
,replace(replace(t.baseac,chr(13),''),chr(10),'') as baseac
,replace(replace(t.bsbkno,chr(13),''),chr(10),'') as bsbkno
,replace(replace(t.bsbkna,chr(13),''),chr(10),'') as bsbkna
,replace(replace(t.bsopdt,chr(13),''),chr(10),'') as bsopdt
,replace(replace(t.bsapdt,chr(13),''),chr(10),'') as bsapdt
,replace(replace(t.rlcpcy,chr(13),''),chr(10),'') as rlcpcy
,t.rlcpam as rlcpam
,replace(replace(t.lncdno,chr(13),''),chr(10),'') as lncdno
,replace(replace(t.lncdpw,chr(13),''),chr(10),'') as lncdpw
,replace(replace(t.lncdtg,chr(13),''),chr(10),'') as lncdtg
,replace(replace(t.lncddt,chr(13),''),chr(10),'') as lncddt
,replace(replace(t.lncdst,chr(13),''),chr(10),'') as lncdst
,replace(replace(t.lcditg,chr(13),''),chr(10),'') as lcditg
,replace(replace(t.lcdidt,chr(13),''),chr(10),'') as lcdidt
,replace(replace(t.lcdrdt,chr(13),''),chr(10),'') as lcdrdt
,replace(replace(t.locatx,chr(13),''),chr(10),'') as locatx
,replace(replace(t.lotxdt,chr(13),''),chr(10),'') as lotxdt
,replace(replace(t.lotxed,chr(13),''),chr(10),'') as lotxed
,replace(replace(t.lotxog,chr(13),''),chr(10),'') as lotxog
,replace(replace(t.natitx,chr(13),''),chr(10),'') as natitx
,replace(replace(t.natxdt,chr(13),''),chr(10),'') as natxdt
,replace(replace(t.natxed,chr(13),''),chr(10),'') as natxed
,replace(replace(t.natxog,chr(13),''),chr(10),'') as natxog
,replace(replace(t.upcrna,chr(13),''),chr(10),'') as upcrna
,replace(replace(t.uprgcy,chr(13),''),chr(10),'') as uprgcy
,t.uprgam as uprgam
,replace(replace(t.upcrps,chr(13),''),chr(10),'') as upcrps
,replace(replace(t.upidtp,chr(13),''),chr(10),'') as upidtp
,replace(replace(t.upidno,chr(13),''),chr(10),'') as upidno
,replace(replace(t.upopno,chr(13),''),chr(10),'') as upopno
,replace(replace(t.upcpcd,chr(13),''),chr(10),'') as upcpcd
,replace(replace(t.upcped,chr(13),''),chr(10),'') as upcped
,replace(replace(t.retxtg,chr(13),''),chr(10),'') as retxtg
,replace(replace(t.txdpid,chr(13),''),chr(10),'') as txdpid
,replace(replace(t.iscuim,chr(13),''),chr(10),'') as iscuim
,replace(replace(t.isexim,chr(13),''),chr(10),'') as isexim
,replace(replace(t.ishtch,chr(13),''),chr(10),'') as ishtch
,replace(replace(t.iscmkt,chr(13),''),chr(10),'') as iscmkt
,replace(replace(t.ispart,chr(13),''),chr(10),'') as ispart
,t.stckam as stckam
,replace(replace(t.isgrup,chr(13),''),chr(10),'') as isgrup
,replace(replace(t.gropid,chr(13),''),chr(10),'') as gropid
,replace(replace(t.isgrmo,chr(13),''),chr(10),'') as isgrmo
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.ctylev,chr(13),''),chr(10),'') as ctylev
,replace(replace(t.waylv5,chr(13),''),chr(10),'') as waylv5
,replace(replace(t.etpcht,chr(13),''),chr(10),'') as etpcht
,replace(replace(t.ntlycd,chr(13),''),chr(10),'') as ntlycd
,replace(replace(t.cuslv3,chr(13),''),chr(10),'') as cuslv3
,replace(replace(t.custp3,chr(13),''),chr(10),'') as custp3
,replace(replace(t.lmtway,chr(13),''),chr(10),'') as lmtway
,replace(replace(t.rpmltp,chr(13),''),chr(10),'') as rpmltp
,t.retinm as retinm
,t.unvrnm as unvrnm
,replace(replace(t.isdrec,chr(13),''),chr(10),'') as isdrec
,replace(replace(t.provce,chr(13),''),chr(10),'') as provce
,replace(replace(t.inoutp,chr(13),''),chr(10),'') as inoutp
,replace(replace(t.worang,chr(13),''),chr(10),'') as worang
,replace(replace(t.supeor,chr(13),''),chr(10),'') as supeor
,t.buldmy as buldmy
,replace(replace(t.budgtp,chr(13),''),chr(10),'') as budgtp
,replace(replace(t.orgown,chr(13),''),chr(10),'') as orgown
,replace(replace(t.cdradt,chr(13),''),chr(10),'') as cdradt
,replace(replace(t.prfd01,chr(13),''),chr(10),'') as prfd01
,replace(replace(t.prfd02,chr(13),''),chr(10),'') as prfd02
,replace(replace(t.prfd03,chr(13),''),chr(10),'') as prfd03
,t.prfd04 as prfd04
,t.prfd05 as prfd05
,t.csumon as csumon
,t.summon as summon
,t.salmon as salmon
,replace(replace(t.sizehy,chr(13),''),chr(10),'') as sizehy
,replace(replace(t.isbank,chr(13),''),chr(10),'') as isbank
,replace(replace(t.banksz,chr(13),''),chr(10),'') as banksz
,replace(replace(t.xwqyid,chr(13),''),chr(10),'') as xwqyid
,replace(replace(t.dgkhlx,chr(13),''),chr(10),'') as dgkhlx
,replace(replace(t.jjzzxs,chr(13),''),chr(10),'') as jjzzxs
,replace(replace(t.jjbmlx,chr(13),''),chr(10),'') as jjbmlx
,replace(replace(t.caccno,chr(13),''),chr(10),'') as caccno
,replace(replace(t.econtp,chr(13),''),chr(10),'') as econtp
,replace(replace(t.scjydz,chr(13),''),chr(10),'') as scjydz
,replace(replace(t.teleno,chr(13),''),chr(10),'') as teleno
,replace(replace(t.regitp,chr(13),''),chr(10),'') as regitp
,replace(replace(t.regino,chr(13),''),chr(10),'') as regino
,replace(replace(t.vocamx,chr(13),''),chr(10),'') as vocamx
,replace(replace(t.busino,chr(13),''),chr(10),'') as busino
,replace(replace(t.taxidy,chr(13),''),chr(10),'') as taxidy
,replace(replace(t.taxara,chr(13),''),chr(10),'') as taxara
,replace(replace(t.taxnum,chr(13),''),chr(10),'') as taxnum
,replace(replace(t.taxcau,chr(13),''),chr(10),'') as taxcau
,replace(replace(t.brchtp,chr(13),''),chr(10),'') as brchtp
,replace(replace(t.taxdfg,chr(13),''),chr(10),'') as taxdfg
,replace(replace(t.siteen,chr(13),''),chr(10),'') as siteen
,replace(replace(t.sitecn,chr(13),''),chr(10),'') as sitecn
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_cifs_cfb_corp t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_cifs_cfb_corp.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes