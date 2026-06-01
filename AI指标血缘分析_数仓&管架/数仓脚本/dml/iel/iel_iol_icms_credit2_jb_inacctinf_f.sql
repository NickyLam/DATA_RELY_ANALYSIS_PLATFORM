: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_credit2_jb_inacctinf_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit2_jb_inacctinf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.fivecateadjdate,chr(13),''),chr(10),'') as fivecateadjdate
,replace(replace(t1.opendate,chr(13),''),chr(10),'') as opendate
,replace(replace(t1.specefctdate,chr(13),''),chr(10),'') as specefctdate
,replace(replace(t1.rptdate,chr(13),''),chr(10),'') as rptdate
,replace(replace(t1.acctspectrstdspnsgmt_updflag,chr(13),''),chr(10),'') as acctspectrstdspnsgmt_updflag
,replace(replace(t1.loanamt,chr(13),''),chr(10),'') as loanamt
,replace(replace(t1.repayfreqcy,chr(13),''),chr(10),'') as repayfreqcy
,replace(replace(t1.fundsou,chr(13),''),chr(10),'') as fundsou
,replace(replace(t1.pridacctbal,chr(13),''),chr(10),'') as pridacctbal
,replace(replace(t1.oved31_60princ,chr(13),''),chr(10),'') as oved31_60princ
,replace(replace(t1.rpyprct,chr(13),''),chr(10),'') as rpyprct
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.acctbsinfsgmt_updflag,chr(13),''),chr(10),'') as acctbsinfsgmt_updflag
,replace(replace(t1.origcreditorinfsgmt_updflag,chr(13),''),chr(10),'') as origcreditorinfsgmt_updflag
,replace(replace(t1.usedamt,chr(13),''),chr(10),'') as usedamt
,replace(replace(t1.ovedprinc180,chr(13),''),chr(10),'') as ovedprinc180
,replace(replace(t1.acctmthlyblginfsgmt_updflag,chr(13),''),chr(10),'') as acctmthlyblginfsgmt_updflag
,replace(replace(t1.guarmode,chr(13),''),chr(10),'') as guarmode
,replace(replace(t1.mcc,chr(13),''),chr(10),'') as mcc
,replace(replace(t1.rltrepymtinfsgmt_updflag,chr(13),''),chr(10),'') as rltrepymtinfsgmt_updflag
,replace(replace(t1.acctcode,chr(13),''),chr(10),'') as acctcode
,replace(replace(t1.rptdatecode,chr(13),''),chr(10),'') as rptdatecode
,replace(replace(t1.busidtllines,chr(13),''),chr(10),'') as busidtllines
,replace(replace(t1.totoverd,chr(13),''),chr(10),'') as totoverd
,replace(replace(t1.cagoftrdinfdata,chr(13),''),chr(10),'') as cagoftrdinfdata
,replace(replace(t1.acctcredline,chr(13),''),chr(10),'') as acctcredline
,replace(replace(t1.initcredname,chr(13),''),chr(10),'') as initcredname
,replace(replace(t1.specline,chr(13),''),chr(10),'') as specline
,replace(replace(t1.firsthouloanflag,chr(13),''),chr(10),'') as firsthouloanflag
,replace(replace(t1.origdbtcate,chr(13),''),chr(10),'') as origdbtcate
,replace(replace(t1.extra_info,chr(13),''),chr(10),'') as extra_info
,replace(replace(t1.rpystatus,chr(13),''),chr(10),'') as rpystatus
,replace(replace(t1.overdprinc,chr(13),''),chr(10),'') as overdprinc
,replace(replace(t1.oved61_90princ,chr(13),''),chr(10),'') as oved61_90princ
,replace(replace(t1.acctcredsgmt_updflag,chr(13),''),chr(10),'') as acctcredsgmt_updflag
,replace(replace(t1.specprdsgmt_updflag,chr(13),''),chr(10),'') as specprdsgmt_updflag
,replace(replace(t1.creditid,chr(13),''),chr(10),'') as creditid
,replace(replace(t1.latrpyamt,chr(13),''),chr(10),'') as latrpyamt
,replace(replace(t1.actrpyamt,chr(13),''),chr(10),'') as actrpyamt
,replace(replace(t1.repaymode,chr(13),''),chr(10),'') as repaymode
,replace(replace(t1.initcredorgnm,chr(13),''),chr(10),'') as initcredorgnm
,replace(replace(t1.idnum,chr(13),''),chr(10),'') as idnum
,replace(replace(t1.repayprd,chr(13),''),chr(10),'') as repayprd
,replace(replace(t1.specenddate,chr(13),''),chr(10),'') as specenddate
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.busilines,chr(13),''),chr(10),'') as busilines
,replace(replace(t1.loanform,chr(13),''),chr(10),'') as loanform
,replace(replace(t1.acctbal,chr(13),''),chr(10),'') as acctbal
,replace(replace(t1.infrectype,chr(13),''),chr(10),'') as infrectype
,replace(replace(t1.loanconcode,chr(13),''),chr(10),'') as loanconcode
,replace(replace(t1.ccnm,chr(13),''),chr(10),'') as ccnm
,replace(replace(t1.cagoftrdnm,chr(13),''),chr(10),'') as cagoftrdnm
,replace(replace(t1.notisubal,chr(13),''),chr(10),'') as notisubal
,replace(replace(t1.applybusidist,chr(13),''),chr(10),'') as applybusidist
,replace(replace(t1.othrepyguarway,chr(13),''),chr(10),'') as othrepyguarway
,replace(replace(t1.remrepprd,chr(13),''),chr(10),'') as remrepprd
,replace(replace(t1.fivecate,chr(13),''),chr(10),'') as fivecate
,replace(replace(t1.motgacltalctrctinfsgmt_updflag,chr(13),''),chr(10),'') as motgacltalctrctinfsgmt_updflag
,replace(replace(t1.oved91_180princ,chr(13),''),chr(10),'') as oved91_180princ
,replace(replace(t1.acctdbtinfsgmt_updflag,chr(13),''),chr(10),'') as acctdbtinfsgmt_updflag
,replace(replace(t1.month,chr(13),''),chr(10),'') as month
,replace(replace(t1.currpyamt,chr(13),''),chr(10),'') as currpyamt
,replace(replace(t1.overdprd,chr(13),''),chr(10),'') as overdprd
,replace(replace(t1.ovedrawbaove180,chr(13),''),chr(10),'') as ovedrawbaove180
,replace(replace(t1.settdate,chr(13),''),chr(10),'') as settdate
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag
,replace(replace(t1.cy,chr(13),''),chr(10),'') as cy
,replace(replace(t1.duedate,chr(13),''),chr(10),'') as duedate
,replace(replace(t1.closedate,chr(13),''),chr(10),'') as closedate
,replace(replace(t1.usedinstamt,chr(13),''),chr(10),'') as usedinstamt
,replace(replace(t1.mngmtorgcode,chr(13),''),chr(10),'') as mngmtorgcode
,replace(replace(t1.rltrepymtnm,chr(13),''),chr(10),'') as rltrepymtnm
,replace(replace(t1.accttype,chr(13),''),chr(10),'') as accttype
,replace(replace(t1.assettrandflag,chr(13),''),chr(10),'') as assettrandflag
,replace(replace(t1.initrpysts,chr(13),''),chr(10),'') as initrpysts
,replace(replace(t1.latrpydate,chr(13),''),chr(10),'') as latrpydate
,replace(replace(t1.rltrepymtinfdata,chr(13),''),chr(10),'') as rltrepymtinfdata
,replace(replace(t1.cccinfdata,chr(13),''),chr(10),'') as cccinfdata
,replace(replace(t1.acctstatus,chr(13),''),chr(10),'') as acctstatus
from ${iol_schema}.icms_credit2_jb_inacctinf t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit2_jb_inacctinf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes