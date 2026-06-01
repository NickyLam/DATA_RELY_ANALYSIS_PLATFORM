: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_flow_opinion_f
CreateDate: 20241106
FileName:   ${iel_data_path}/icms_flow_opinion.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.opinionno,chr(13),''),chr(10),'') as opinionno
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.businesscurrency,chr(13),''),chr(10),'') as businesscurrency
,businesssum
,termyear
,termmonth
,termday
,replace(replace(t1.baseratetype,chr(13),''),chr(10),'') as baseratetype
,replace(replace(t1.ratefloattype,chr(13),''),chr(10),'') as ratefloattype
,ratefloat
,replace(replace(t1.bailcurrency,chr(13),''),chr(10),'') as bailcurrency
,businessrate
,bailratio
,bailsum
,pdgratio
,pdgsum
,baserate
,replace(replace(t1.phaseopinion,chr(13),''),chr(10),'') as phaseopinion
,replace(replace(t1.phaseopinion1,chr(13),''),chr(10),'') as phaseopinion1
,replace(replace(t1.phaseopinion2,chr(13),''),chr(10),'') as phaseopinion2
,replace(replace(t1.phaseopinion3,chr(13),''),chr(10),'') as phaseopinion3
,exposuresum
,replace(replace(t1.opiniontype,chr(13),''),chr(10),'') as opiniontype
,replace(replace(t1.inputorg,chr(13),''),chr(10),'') as inputorg
,replace(replace(t1.inputuser,chr(13),''),chr(10),'') as inputuser
,replace(replace(t1.updateorg,chr(13),''),chr(10),'') as updateorg
,replace(replace(t1.updateuser,chr(13),''),chr(10),'') as updateuser
,inputtime
,updatetime
,replace(replace(t1.phasechoice,chr(13),''),chr(10),'') as phasechoice
,replace(replace(t1.warehousing,chr(13),''),chr(10),'') as warehousing
,replace(replace(t1.payreq,chr(13),''),chr(10),'') as payreq
,replace(replace(t1.afterpayreq,chr(13),''),chr(10),'') as afterpayreq
,replace(replace(t1.contractreq,chr(13),''),chr(10),'') as contractreq
,replace(replace(t1.loanmanagereq,chr(13),''),chr(10),'') as loanmanagereq
,replace(replace(t1.agreemachine,chr(13),''),chr(10),'') as agreemachine
,riskexposuresum
,replace(replace(t1.iscycle,chr(13),''),chr(10),'') as iscycle
,replace(replace(t1.isyeartocheck,chr(13),''),chr(10),'') as isyeartocheck
,replace(replace(t1.isjoinlimits,chr(13),''),chr(10),'') as isjoinlimits
,onlineamount
,replace(replace(t1.repaytype,chr(13),''),chr(10),'') as repaytype
,replace(replace(t1.repaycycle,chr(13),''),chr(10),'') as repaycycle
,balloonamortenddate
,coopterm
,nominalsum
,firstusesum
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,lowriskexposuresum
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.icms_flow_opinion t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_flow_opinion.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
