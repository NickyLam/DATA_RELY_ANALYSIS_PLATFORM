: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_prd_baseinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_prd_baseinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.produuid,chr(13),''),chr(10),'') as produuid
,replace(replace(t1.prodid,chr(13),''),chr(10),'') as prodid
,replace(replace(t1.prod_abbr,chr(13),''),chr(10),'') as prod_abbr
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.profitflag,chr(13),''),chr(10),'') as profitflag
,replace(replace(t1.assetmarket,chr(13),''),chr(10),'') as assetmarket
,replace(replace(t1.risklevel,chr(13),''),chr(10),'') as risklevel
,replace(replace(t1.issuetype,chr(13),''),chr(10),'') as issuetype
,t1.opencycle as opencycle
,replace(replace(t1.profit_mode,chr(13),''),chr(10),'') as profit_mode
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t1.saletarget,chr(13),''),chr(10),'') as saletarget
,replace(replace(t1.operatemode,chr(13),''),chr(10),'') as operatemode
,replace(replace(t1.prodseries,chr(13),''),chr(10),'') as prodseries
,t1.planraiseamtmax as planraiseamtmax
,t1.planraiseamtmin as planraiseamtmin
,t1.raisestartdate as raisestartdate
,t1.raiseenddate as raiseenddate
,t1.substartamt as substartamt
,t1.subaddamt as subaddamt
,t1.redstartamt as redstartamt
,t1.redpostion as redpostion
,t1.vdate as vdate
,t1.mdate as mdate
,t1.term as term
,replace(replace(t1.termtype,chr(13),''),chr(10),'') as termtype
,t1.intpaycycle as intpaycycle
,replace(replace(t1.intpayunit,chr(13),''),chr(10),'') as intpayunit
,replace(replace(t1.calrule,chr(13),''),chr(10),'') as calrule
,t1.firstpaydate as firstpaydate
,replace(replace(t1.tradedayrule,chr(13),''),chr(10),'') as tradedayrule
,replace(replace(t1.basis,chr(13),''),chr(10),'') as basis
,replace(replace(t1.ratetype,chr(13),''),chr(10),'') as ratetype
,replace(replace(t1.pricerule,chr(13),''),chr(10),'') as pricerule
,t1.quotecycle as quotecycle
,replace(replace(t1.quoteunit,chr(13),''),chr(10),'') as quoteunit
,t1.quoteday as quoteday
,t1.spreadrate as spreadrate
,t1.proprate as proprate
,replace(replace(t1.ratecode,chr(13),''),chr(10),'') as ratecode
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.remark5,chr(13),''),chr(10),'') as remark5
,replace(replace(t1.remark6,chr(13),''),chr(10),'') as remark6
,replace(replace(t1.remark7,chr(13),''),chr(10),'') as remark7
,replace(replace(t1.remark8,chr(13),''),chr(10),'') as remark8
,replace(replace(t1.remark9,chr(13),''),chr(10),'') as remark9
,replace(replace(t1.remark10,chr(13),''),chr(10),'') as remark10
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,t1.version as version
,t1.updatetime as updatetime
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser
,replace(replace(t1.opencycleunit,chr(13),''),chr(10),'') as opencycleunit
,replace(replace(t1.profitccy,chr(13),''),chr(10),'') as profitccy
,replace(replace(t1.account,chr(13),''),chr(10),'') as account
,t1.resetcycle as resetcycle
,replace(replace(t1.resetcycleunit,chr(13),''),chr(10),'') as resetcycleunit
,t1.resetrlue as resetrlue
,t1.firstresetdate as firstresetdate
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype
,t1.adjustvalue as adjustvalue
,replace(replace(t1.baseratetypedel,chr(13),''),chr(10),'') as baseratetypedel
,replace(replace(t1.credittype,chr(13),''),chr(10),'') as credittype
,replace(replace(t1.raisetype,chr(13),''),chr(10),'') as raisetype
,replace(replace(t1.creditcontent,chr(13),''),chr(10),'') as creditcontent
,replace(replace(t1.manatype,chr(13),''),chr(10),'') as manatype
,replace(replace(t1.bookmodel,chr(13),''),chr(10),'') as bookmodel
,replace(replace(t1.redflag,chr(13),''),chr(10),'') as redflag
,replace(replace(t1.endflag,chr(13),''),chr(10),'') as endflag
,replace(replace(t1.salearea,chr(13),''),chr(10),'') as salearea
,replace(replace(t1.customname,chr(13),''),chr(10),'') as customname
,replace(replace(t1.trubank,chr(13),''),chr(10),'') as trubank
,replace(replace(t1.manager,chr(13),''),chr(10),'') as manager
,replace(replace(t1.innerclass1,chr(13),''),chr(10),'') as innerclass1
,replace(replace(t1.innerclass2,chr(13),''),chr(10),'') as innerclass2
,replace(replace(t1.creditflag,chr(13),''),chr(10),'') as creditflag
,replace(replace(t1.assetmarketdesc,chr(13),''),chr(10),'') as assetmarketdesc
,replace(replace(t1.saleobject,chr(13),''),chr(10),'') as saleobject
,t1.investrate as investrate
,t1.bookdate as bookdate
,replace(replace(t1.crttype,chr(13),''),chr(10),'') as crttype
,t1.seriesnum as seriesnum
,t1.yearnum as yearnum
,replace(replace(t1.subtype,chr(13),''),chr(10),'') as subtype
,t1.yearsubnum as yearsubnum
,replace(replace(t1.accounts,chr(13),''),chr(10),'') as accounts
,replace(replace(t1.amtbank,chr(13),''),chr(10),'') as amtbank
,replace(replace(t1.issueflag,chr(13),''),chr(10),'') as issueflag
,replace(replace(t1.issueremark,chr(13),''),chr(10),'') as issueremark
,replace(replace(t1.remark11,chr(13),''),chr(10),'') as remark11
,replace(replace(t1.fproduuid,chr(13),''),chr(10),'') as fproduuid
,replace(replace(t1.salegroup,chr(13),''),chr(10),'') as salegroup
,t1.pamtdw as pamtdw
,t1.pamtup as pamtup
,replace(replace(t1.subtypes,chr(13),''),chr(10),'') as subtypes
,replace(replace(t1.payinteresttype,chr(13),''),chr(10),'') as payinteresttype
,replace(replace(t1.assetmarkettwo,chr(13),''),chr(10),'') as assetmarkettwo
,replace(replace(t1.rateconfirmdesc,chr(13),''),chr(10),'') as rateconfirmdesc
,replace(replace(t1.relpool,chr(13),''),chr(10),'') as relpool
,replace(replace(t1.inputtpl,chr(13),''),chr(10),'') as inputtpl
,replace(replace(t1.channelid,chr(13),''),chr(10),'') as channelid
,t1.subaddtionalamt as subaddtionalamt
,t1.opendays as opendays
,replace(replace(t1.registerid,chr(13),''),chr(10),'') as registerid
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.fams_prd_baseinfo t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_prd_baseinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes