: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cifs_cifs_cfb_corp_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cifs_cifs_cfb_corp.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.psrntg,chr(13),''),chr(10),'') as psrntg
,replace(replace(t1.lwctna,chr(13),''),chr(10),'') as lwctna
,replace(replace(t1.lwidno,chr(13),''),chr(10),'') as lwidno
,replace(replace(t1.cptnnm,chr(13),''),chr(10),'') as cptnnm
,replace(replace(t1.vocatp,chr(13),''),chr(10),'') as vocatp
,replace(replace(t1.orgacd,chr(13),''),chr(10),'') as orgacd
,replace(replace(t1.orgatp,chr(13),''),chr(10),'') as orgatp
,replace(replace(t1.orgaed,chr(13),''),chr(10),'') as orgaed
,replace(replace(t1.rdtdmk,chr(13),''),chr(10),'') as rdtdmk
,replace(replace(t1.orgast,chr(13),''),chr(10),'') as orgast
,replace(replace(t1.corpid,chr(13),''),chr(10),'') as corpid
,replace(replace(t1.corppr,chr(13),''),chr(10),'') as corppr
,replace(replace(t1.corptp,chr(13),''),chr(10),'') as corptp
,replace(replace(t1.cpmntp,chr(13),''),chr(10),'') as cpmntp
,replace(replace(t1.sizeid,chr(13),''),chr(10),'') as sizeid
,replace(replace(t1.rgstad,chr(13),''),chr(10),'') as rgstad
,replace(replace(t1.establ,chr(13),''),chr(10),'') as establ
,replace(replace(t1.regidt,chr(13),''),chr(10),'') as regidt
,replace(replace(t1.regicy,chr(13),''),chr(10),'') as regicy
,t1.regiam as regiam
,replace(replace(t1.regiad,chr(13),''),chr(10),'') as regiad
,t1.stafnm as stafnm
,replace(replace(t1.dealsp,chr(13),''),chr(10),'') as dealsp
,t1.operar as operar
,replace(replace(t1.psarow,chr(13),''),chr(10),'') as psarow
,replace(replace(t1.baseno,chr(13),''),chr(10),'') as baseno
,replace(replace(t1.baseac,chr(13),''),chr(10),'') as baseac
,replace(replace(t1.bsbkno,chr(13),''),chr(10),'') as bsbkno
,replace(replace(t1.bsbkna,chr(13),''),chr(10),'') as bsbkna
,replace(replace(t1.bsopdt,chr(13),''),chr(10),'') as bsopdt
,replace(replace(t1.bsapdt,chr(13),''),chr(10),'') as bsapdt
,replace(replace(t1.rlcpcy,chr(13),''),chr(10),'') as rlcpcy
,t1.rlcpam as rlcpam
,replace(replace(t1.lncdno,chr(13),''),chr(10),'') as lncdno
,replace(replace(t1.lncdpw,chr(13),''),chr(10),'') as lncdpw
,replace(replace(t1.lncdtg,chr(13),''),chr(10),'') as lncdtg
,replace(replace(t1.lncddt,chr(13),''),chr(10),'') as lncddt
,replace(replace(t1.lncdst,chr(13),''),chr(10),'') as lncdst
,replace(replace(t1.lcditg,chr(13),''),chr(10),'') as lcditg
,replace(replace(t1.lcdidt,chr(13),''),chr(10),'') as lcdidt
,replace(replace(t1.lcdrdt,chr(13),''),chr(10),'') as lcdrdt
,replace(replace(t1.locatx,chr(13),''),chr(10),'') as locatx
,replace(replace(t1.lotxdt,chr(13),''),chr(10),'') as lotxdt
,replace(replace(t1.lotxed,chr(13),''),chr(10),'') as lotxed
,replace(replace(t1.lotxog,chr(13),''),chr(10),'') as lotxog
,replace(replace(t1.natitx,chr(13),''),chr(10),'') as natitx
,replace(replace(t1.natxdt,chr(13),''),chr(10),'') as natxdt
,replace(replace(t1.natxed,chr(13),''),chr(10),'') as natxed
,replace(replace(t1.natxog,chr(13),''),chr(10),'') as natxog
,replace(replace(t1.upcrna,chr(13),''),chr(10),'') as upcrna
,replace(replace(t1.uprgcy,chr(13),''),chr(10),'') as uprgcy
,t1.uprgam as uprgam
,replace(replace(t1.upcrps,chr(13),''),chr(10),'') as upcrps
,replace(replace(t1.upidtp,chr(13),''),chr(10),'') as upidtp
,replace(replace(t1.upidno,chr(13),''),chr(10),'') as upidno
,replace(replace(t1.upopno,chr(13),''),chr(10),'') as upopno
,replace(replace(t1.upcpcd,chr(13),''),chr(10),'') as upcpcd
,replace(replace(t1.upcped,chr(13),''),chr(10),'') as upcped
,replace(replace(t1.retxtg,chr(13),''),chr(10),'') as retxtg
,replace(replace(t1.txdpid,chr(13),''),chr(10),'') as txdpid
,replace(replace(t1.iscuim,chr(13),''),chr(10),'') as iscuim
,replace(replace(t1.isexim,chr(13),''),chr(10),'') as isexim
,replace(replace(t1.ishtch,chr(13),''),chr(10),'') as ishtch
,replace(replace(t1.iscmkt,chr(13),''),chr(10),'') as iscmkt
,replace(replace(t1.ispart,chr(13),''),chr(10),'') as ispart
,t1.stckam as stckam
,replace(replace(t1.isgrup,chr(13),''),chr(10),'') as isgrup
,replace(replace(t1.gropid,chr(13),''),chr(10),'') as gropid
,replace(replace(t1.isgrmo,chr(13),''),chr(10),'') as isgrmo
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.ctylev,chr(13),''),chr(10),'') as ctylev
,replace(replace(t1.waylv5,chr(13),''),chr(10),'') as waylv5
,replace(replace(t1.etpcht,chr(13),''),chr(10),'') as etpcht
,replace(replace(t1.ntlycd,chr(13),''),chr(10),'') as ntlycd
,replace(replace(t1.cuslv3,chr(13),''),chr(10),'') as cuslv3
,replace(replace(t1.custp3,chr(13),''),chr(10),'') as custp3
,replace(replace(t1.lmtway,chr(13),''),chr(10),'') as lmtway
,replace(replace(t1.rpmltp,chr(13),''),chr(10),'') as rpmltp
,t1.retinm as retinm
,t1.unvrnm as unvrnm
,replace(replace(t1.isdrec,chr(13),''),chr(10),'') as isdrec
,replace(replace(t1.provce,chr(13),''),chr(10),'') as provce
,replace(replace(t1.inoutp,chr(13),''),chr(10),'') as inoutp
,replace(replace(t1.worang,chr(13),''),chr(10),'') as worang
,replace(replace(t1.supeor,chr(13),''),chr(10),'') as supeor
,t1.buldmy as buldmy
,replace(replace(t1.budgtp,chr(13),''),chr(10),'') as budgtp
,replace(replace(t1.orgown,chr(13),''),chr(10),'') as orgown
,replace(replace(t1.cdradt,chr(13),''),chr(10),'') as cdradt
,replace(replace(t1.prfd01,chr(13),''),chr(10),'') as prfd01
,replace(replace(t1.prfd02,chr(13),''),chr(10),'') as prfd02
,replace(replace(t1.prfd03,chr(13),''),chr(10),'') as prfd03
,t1.prfd04 as prfd04
,t1.prfd05 as prfd05
,t1.csumon as csumon
,t1.summon as summon
,t1.salmon as salmon
,replace(replace(t1.sizehy,chr(13),''),chr(10),'') as sizehy
,replace(replace(t1.isbank,chr(13),''),chr(10),'') as isbank
,replace(replace(t1.banksz,chr(13),''),chr(10),'') as banksz
,replace(replace(t1.xwqyid,chr(13),''),chr(10),'') as xwqyid
,replace(replace(t1.dgkhlx,chr(13),''),chr(10),'') as dgkhlx
,replace(replace(t1.jjzzxs,chr(13),''),chr(10),'') as jjzzxs
,replace(replace(t1.jjbmlx,chr(13),''),chr(10),'') as jjbmlx
,replace(replace(t1.caccno,chr(13),''),chr(10),'') as caccno
,replace(replace(t1.econtp,chr(13),''),chr(10),'') as econtp
,replace(replace(t1.scjydz,chr(13),''),chr(10),'') as scjydz
,replace(replace(t1.teleno,chr(13),''),chr(10),'') as teleno
,replace(replace(t1.regitp,chr(13),''),chr(10),'') as regitp
,replace(replace(t1.regino,chr(13),''),chr(10),'') as regino
,replace(replace(t1.vocamx,chr(13),''),chr(10),'') as vocamx
,replace(replace(t1.busino,chr(13),''),chr(10),'') as busino
,replace(replace(t1.taxidy,chr(13),''),chr(10),'') as taxidy
,replace(replace(t1.taxara,chr(13),''),chr(10),'') as taxara
,replace(replace(t1.taxnum,chr(13),''),chr(10),'') as taxnum
,replace(replace(t1.taxcau,chr(13),''),chr(10),'') as taxcau
,replace(replace(t1.brchtp,chr(13),''),chr(10),'') as brchtp
,replace(replace(t1.taxdfg,chr(13),''),chr(10),'') as taxdfg
,replace(replace(t1.siteen,chr(13),''),chr(10),'') as siteen
,replace(replace(t1.sitecn,chr(13),''),chr(10),'') as sitecn
 from iol.cifs_cifs_cfb_corp T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cifs_cifs_cfb_corp.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes