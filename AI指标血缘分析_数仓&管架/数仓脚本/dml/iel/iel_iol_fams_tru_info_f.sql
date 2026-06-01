: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_tru_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_tru_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.trustuuid,chr(13),''),chr(10),'') as trustuuid
,replace(replace(t1.trustid,chr(13),''),chr(10),'') as trustid
,replace(replace(t1.trustname,chr(13),''),chr(10),'') as trustname
,replace(replace(t1.contractno,chr(13),''),chr(10),'') as contractno
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.trusttype,chr(13),''),chr(10),'') as trusttype
,t1.vdate as vdate
,t1.mdate as mdate
,t1.contmaxamt as contmaxamt
,t1.contminamt as contminamt
,t1.contactamt as contactamt
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.basis,chr(13),''),chr(10),'') as basis
,replace(replace(t1.intcalrule,chr(13),''),chr(10),'') as intcalrule
,replace(replace(t1.inttype,chr(13),''),chr(10),'') as inttype
,t1.rate_8 as rate_8
,replace(replace(t1.workdayrule,chr(13),''),chr(10),'') as workdayrule
,replace(replace(t1.schecalrule,chr(13),''),chr(10),'') as schecalrule
,t1.firstpaydate as firstpaydate
,t1.paycycle as paycycle
,replace(replace(t1.intpayrule,chr(13),''),chr(10),'') as intpayrule
,t1.firstrate as firstrate
,replace(replace(t1.ratecode,chr(13),''),chr(10),'') as ratecode
,t1.adjustvalue as adjustvalue
,t1.spreadrate as spreadrate
,t1.resetcycle as resetcycle
,replace(replace(t1.resetcycleunit,chr(13),''),chr(10),'') as resetcycleunit
,t1.resetrlue as resetrlue
,t1.firstresetdate as firstresetdate
,t1.princycle as princycle
,replace(replace(t1.finaenter,chr(13),''),chr(10),'') as finaenter
,replace(replace(t1.vouchenter,chr(13),''),chr(10),'') as vouchenter
,replace(replace(t1.impawnflag,chr(13),''),chr(10),'') as impawnflag
,replace(replace(t1.investrange,chr(13),''),chr(10),'') as investrange
,replace(replace(t1.privateaccount,chr(13),''),chr(10),'') as privateaccount
,replace(replace(t1.privatename,chr(13),''),chr(10),'') as privatename
,replace(replace(t1.privatebankno,chr(13),''),chr(10),'') as privatebankno
,replace(replace(t1.hugepayno,chr(13),''),chr(10),'') as hugepayno
,replace(replace(t1.designoperator,chr(13),''),chr(10),'') as designoperator
,replace(replace(t1.contperson,chr(13),''),chr(10),'') as contperson
,replace(replace(t1.contpersonphone,chr(13),''),chr(10),'') as contpersonphone
,replace(replace(t1.contpersontel,chr(13),''),chr(10),'') as contpersontel
,replace(replace(t1.branchname,chr(13),''),chr(10),'') as branchname
,replace(replace(t1.loancontractno,chr(13),''),chr(10),'') as loancontractno
,t1.loanamounts as loanamounts
,replace(replace(t1.busstype,chr(13),''),chr(10),'') as busstype
,replace(replace(t1.govplatflag,chr(13),''),chr(10),'') as govplatflag
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.remark5,chr(13),''),chr(10),'') as remark5
,t1.updatetime as updatetime
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser
,t1.toprate as toprate
,t1.floorrate as floorrate
,t1.firstprindate as firstprindate
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t1.cooperationtype,chr(13),''),chr(10),'') as cooperationtype
,replace(replace(t1.investtype,chr(13),''),chr(10),'') as investtype
,replace(replace(t1.riskmeasure,chr(13),''),chr(10),'') as riskmeasure
,replace(replace(t1.issuetype,chr(13),''),chr(10),'') as issuetype
,replace(replace(t1.assettype,chr(13),''),chr(10),'') as assettype
,replace(replace(t1.assetmarket,chr(13),''),chr(10),'') as assetmarket
,replace(replace(t1.assetpbank,chr(13),''),chr(10),'') as assetpbank
,replace(replace(t1.defineassettype,chr(13),''),chr(10),'') as defineassettype
,replace(replace(t1.defineassettype2,chr(13),''),chr(10),'') as defineassettype2
,replace(replace(t1.isstandard,chr(13),''),chr(10),'') as isstandard
,replace(replace(t1.isstandard2,chr(13),''),chr(10),'') as isstandard2
,replace(replace(t1.repooption,chr(13),''),chr(10),'') as repooption
,replace(replace(t1.booktype,chr(13),''),chr(10),'') as booktype
,t1.orivdate as orivdate
,t1.orimdate as orimdate
,replace(replace(t1.investdept,chr(13),''),chr(10),'') as investdept
,replace(replace(t1.backendearnings,chr(13),''),chr(10),'') as backendearnings
,replace(replace(t1.booktype2,chr(13),''),chr(10),'') as booktype2
,replace(replace(t1.risklevel,chr(13),''),chr(10),'') as risklevel
,replace(replace(t1.financialplanid,chr(13),''),chr(10),'') as financialplanid
,replace(replace(t1.vatbreakeven,chr(13),''),chr(10),'') as vatbreakeven
,replace(replace(t1.investmenttypefour,chr(13),''),chr(10),'') as investmenttypefour
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.fams_tru_info t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_tru_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes