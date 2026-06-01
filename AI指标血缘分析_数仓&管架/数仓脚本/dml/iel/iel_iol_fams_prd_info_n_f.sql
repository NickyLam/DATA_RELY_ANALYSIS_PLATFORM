: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_prd_info_n_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_prd_info_n.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.prodid as prodid
,t1.version as version
,replace(replace(t1.prodcode,chr(13),''),chr(10),'') as prodcode
,replace(replace(t1.prodsimplename,chr(13),''),chr(10),'') as prodsimplename
,replace(replace(t1.prodname,chr(13),''),chr(10),'') as prodname
,replace(replace(t1.profitflag,chr(13),''),chr(10),'') as profitflag
,replace(replace(t1.trubankid,chr(13),''),chr(10),'') as trubankid
,replace(replace(t1.risklevel,chr(13),''),chr(10),'') as risklevel
,replace(replace(t1.manager,chr(13),''),chr(10),'') as manager
,t1.opencycle as opencycle
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.bonusmode,chr(13),''),chr(10),'') as bonusmode
,replace(replace(t1.bonusperiod,chr(13),''),chr(10),'') as bonusperiod
,t1.bonusdate as bonusdate
,replace(replace(t1.issuetype,chr(13),''),chr(10),'') as issuetype
,replace(replace(t1.ivstorientation,chr(13),''),chr(10),'') as ivstorientation
,replace(replace(t1.terminationflag,chr(13),''),chr(10),'') as terminationflag
,t1.vdate as vdate
,t1.mdate as mdate
,t1.sdate as sdate
,t1.performancebase as performancebase
,t1.managefeeupper as managefeeupper
,replace(replace(t1.raisemode,chr(13),''),chr(10),'') as raisemode
,replace(replace(t1.saletarget,chr(13),''),chr(10),'') as saletarget
,t1.subscribebase as subscribebase
,t1.raiseamtmax as raiseamtmax
,t1.raiseamtmin as raiseamtmin
,t1.additionalamt as additionalamt
,t1.raisestartdate as raisestartdate
,t1.raiseenddate as raiseenddate
,t1.cashcollectdate as cashcollectdate
,t1.createtime as createtime
,replace(replace(t1.createuser,chr(13),''),chr(10),'') as createuser
,replace(replace(t1.creditflag,chr(13),''),chr(10),'') as creditflag
,replace(replace(t1.credittype,chr(13),''),chr(10),'') as credittype
,replace(replace(t1.creditcontent,chr(13),''),chr(10),'') as creditcontent
,t1.term as term
,replace(replace(t1.termtype,chr(13),''),chr(10),'') as termtype
,replace(replace(t1.saleobject,chr(13),''),chr(10),'') as saleobject
,replace(replace(t1.openfrequency,chr(13),''),chr(10),'') as openfrequency
,t1.openday as openday
,replace(replace(t1.guidelinesdays,chr(13),''),chr(10),'') as guidelinesdays
,replace(replace(t1.calculatemethod,chr(13),''),chr(10),'') as calculatemethod
,t1.firstopenday as firstopenday
,t1.bonusmonths as bonusmonths
,t1.bonusdays as bonusdays
,replace(replace(t1.manatype,chr(13),''),chr(10),'') as manatype
,replace(replace(t1.confirmdays,chr(13),''),chr(10),'') as confirmdays
,replace(replace(t1.prodseries,chr(13),''),chr(10),'') as prodseries
,replace(replace(t1.prodseries2,chr(13),''),chr(10),'') as prodseries2
,replace(replace(t1.prodseries3,chr(13),''),chr(10),'') as prodseries3
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.issuestatus,chr(13),''),chr(10),'') as issuestatus
,replace(replace(t1.issueremark,chr(13),''),chr(10),'') as issueremark
,replace(replace(t1.proregistcode,chr(13),''),chr(10),'') as proregistcode
,replace(replace(t1.bookmodel,chr(13),''),chr(10),'') as bookmodel
,replace(replace(t1.opencycleunit,chr(13),''),chr(10),'') as opencycleunit
,replace(replace(t1.redflag,chr(13),''),chr(10),'') as redflag
,replace(replace(t1.dealtypedate,chr(13),''),chr(10),'') as dealtypedate
,t1.prdperiod as prdperiod
,t1.redratio as redratio
,replace(replace(t1.investortype,chr(13),''),chr(10),'') as investortype
,replace(replace(t1.salesarea,chr(13),''),chr(10),'') as salesarea
,replace(replace(t1.interbank,chr(13),''),chr(10),'') as interbank
,t1.tmdate as tmdate
,t1.wmdate as wmdate
,replace(replace(t1.basis,chr(13),''),chr(10),'') as basis
,t1.valuenum as valuenum
,replace(replace(t1.assetvalue,chr(13),''),chr(10),'') as assetvalue
,replace(replace(t1.digittype,chr(13),''),chr(10),'') as digittype
,replace(replace(t1.valuetype,chr(13),''),chr(10),'') as valuetype
,replace(replace(t1.curdepoflag,chr(13),''),chr(10),'') as curdepoflag
,t1.currentdate as currentdate
,replace(replace(t1.opentypep,chr(13),''),chr(10),'') as opentypep
,t1.opendayp as opendayp
,t1.opencyclep as opencyclep
,replace(replace(t1.opencycleunitp,chr(13),''),chr(10),'') as opencycleunitp
,replace(replace(t1.weekp,chr(13),''),chr(10),'') as weekp
,replace(replace(t1.isworkdayp,chr(13),''),chr(10),'') as isworkdayp
,replace(replace(t1.dayp,chr(13),''),chr(10),'') as dayp
,replace(replace(t1.workdayp,chr(13),''),chr(10),'') as workdayp
,replace(replace(t1.calcmethodp,chr(13),''),chr(10),'') as calcmethodp
,t1.firstopendayp as firstopendayp
,replace(replace(t1.busirulep,chr(13),''),chr(10),'') as busirulep
,replace(replace(t1.holirulep,chr(13),''),chr(10),'') as holirulep
,replace(replace(t1.calcrulep,chr(13),''),chr(10),'') as calcrulep
,replace(replace(t1.ispr,chr(13),''),chr(10),'') as ispr
,replace(replace(t1.opentyper,chr(13),''),chr(10),'') as opentyper
,t1.opendayr as opendayr
,t1.opencycler as opencycler
,replace(replace(t1.opencycleunitr,chr(13),''),chr(10),'') as opencycleunitr
,replace(replace(t1.weekr,chr(13),''),chr(10),'') as weekr
,replace(replace(t1.isworkdayr,chr(13),''),chr(10),'') as isworkdayr
,replace(replace(t1.dayr,chr(13),''),chr(10),'') as dayr
,replace(replace(t1.workdayr,chr(13),''),chr(10),'') as workdayr
,replace(replace(t1.calcmethodr,chr(13),''),chr(10),'') as calcmethodr
,t1.firstopendayr as firstopendayr
,replace(replace(t1.busiruler,chr(13),''),chr(10),'') as busiruler
,replace(replace(t1.holiruler,chr(13),''),chr(10),'') as holiruler
,replace(replace(t1.calcruler,chr(13),''),chr(10),'') as calcruler
,replace(replace(t1.cutrule,chr(13),''),chr(10),'') as cutrule
,replace(replace(t1.cutbusirule,chr(13),''),chr(10),'') as cutbusirule
,replace(replace(t1.bonbusirule,chr(13),''),chr(10),'') as bonbusirule
,replace(replace(t1.ndatepurchase,chr(13),''),chr(10),'') as ndatepurchase
,replace(replace(t1.ndatered,chr(13),''),chr(10),'') as ndatered
,replace(replace(t1.saledept,chr(13),''),chr(10),'') as saledept
,replace(replace(t1.inputtype,chr(13),''),chr(10),'') as inputtype
,replace(replace(t1.issamefrequency,chr(13),''),chr(10),'') as issamefrequency
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.fams_prd_info_n t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_prd_info_n.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes