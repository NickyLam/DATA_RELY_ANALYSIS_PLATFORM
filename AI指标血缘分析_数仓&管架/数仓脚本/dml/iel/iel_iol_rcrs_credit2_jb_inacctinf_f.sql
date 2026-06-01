: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit2_jb_inacctinf_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit2_jb_inacctinf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.infrectype,chr(13),''),chr(10),'') as infrectype
    ,replace(replace(t.accttype,chr(13),''),chr(10),'') as accttype
    ,replace(replace(t.acctcode,chr(13),''),chr(10),'') as acctcode
    ,replace(replace(t.rptdate,chr(13),''),chr(10),'') as rptdate
    ,replace(replace(t.rptdatecode,chr(13),''),chr(10),'') as rptdatecode
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
    ,replace(replace(t.idnum,chr(13),''),chr(10),'') as idnum
    ,replace(replace(t.mngmtorgcode,chr(13),''),chr(10),'') as mngmtorgcode
    ,replace(replace(t.acctbsinfsgmt_updflag,chr(13),''),chr(10),'') as acctbsinfsgmt_updflag
    ,replace(replace(t.rltrepymtinfsgmt_updflag,chr(13),''),chr(10),'') as rltrepymtinfsgmt_updflag
    ,replace(replace(t.motgacltalctrctinfsgmt_updflag,chr(13),''),chr(10),'') as motgacltalctrctinfsgmt_updflag
    ,replace(replace(t.acctcredsgmt_updflag,chr(13),''),chr(10),'') as acctcredsgmt_updflag
    ,replace(replace(t.origcreditorinfsgmt_updflag,chr(13),''),chr(10),'') as origcreditorinfsgmt_updflag
    ,replace(replace(t.acctmthlyblginfsgmt_updflag,chr(13),''),chr(10),'') as acctmthlyblginfsgmt_updflag
    ,replace(replace(t.specprdsgmt_updflag,chr(13),''),chr(10),'') as specprdsgmt_updflag
    ,replace(replace(t.acctdbtinfsgmt_updflag,chr(13),''),chr(10),'') as acctdbtinfsgmt_updflag
    ,replace(replace(t.acctspectrstdspnsgmt_updflag,chr(13),''),chr(10),'') as acctspectrstdspnsgmt_updflag
    ,replace(replace(t.busilines,chr(13),''),chr(10),'') as busilines
    ,replace(replace(t.busidtllines,chr(13),''),chr(10),'') as busidtllines
    ,replace(replace(t.opendate,chr(13),''),chr(10),'') as opendate
    ,replace(replace(t.cy,chr(13),''),chr(10),'') as cy
    ,replace(replace(t.acctcredline,chr(13),''),chr(10),'') as acctcredline
    ,replace(replace(t.loanamt,chr(13),''),chr(10),'') as loanamt
    ,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
    ,replace(replace(t.duedate,chr(13),''),chr(10),'') as duedate
    ,replace(replace(t.repaymode,chr(13),''),chr(10),'') as repaymode
    ,replace(replace(t.repayfreqcy,chr(13),''),chr(10),'') as repayfreqcy
    ,replace(replace(t.repayprd,chr(13),''),chr(10),'') as repayprd
    ,replace(replace(t.applybusidist,chr(13),''),chr(10),'') as applybusidist
    ,replace(replace(t.guarmode,chr(13),''),chr(10),'') as guarmode
    ,replace(replace(t.othrepyguarway,chr(13),''),chr(10),'') as othrepyguarway
    ,replace(replace(t.assettrandflag,chr(13),''),chr(10),'') as assettrandflag
    ,replace(replace(t.fundsou,chr(13),''),chr(10),'') as fundsou
    ,replace(replace(t.loanform,chr(13),''),chr(10),'') as loanform
    ,replace(replace(t.creditid,chr(13),''),chr(10),'') as creditid
    ,replace(replace(t.loanconcode,chr(13),''),chr(10),'') as loanconcode
    ,replace(replace(t.firsthouloanflag,chr(13),''),chr(10),'') as firsthouloanflag
    ,replace(replace(t.rltrepymtnm,chr(13),''),chr(10),'') as rltrepymtnm
    ,replace(replace(t.rltrepymtinfdata,chr(13),''),chr(10),'') as rltrepymtinfdata
    ,replace(replace(t.ccnm,chr(13),''),chr(10),'') as ccnm
    ,replace(replace(t.cccinfdata,chr(13),''),chr(10),'') as cccinfdata
    ,replace(replace(t.mcc,chr(13),''),chr(10),'') as mcc
    ,replace(replace(t.initcredname,chr(13),''),chr(10),'') as initcredname
    ,replace(replace(t.initcredorgnm,chr(13),''),chr(10),'') as initcredorgnm
    ,replace(replace(t.origdbtcate,chr(13),''),chr(10),'') as origdbtcate
    ,replace(replace(t.initrpysts,chr(13),''),chr(10),'') as initrpysts
    ,replace(replace(t.month,chr(13),''),chr(10),'') as month
    ,replace(replace(t.settdate,chr(13),''),chr(10),'') as settdate
    ,replace(replace(t.acctstatus,chr(13),''),chr(10),'') as acctstatus
    ,replace(replace(t.acctbal,chr(13),''),chr(10),'') as acctbal
    ,replace(replace(t.pridacctbal,chr(13),''),chr(10),'') as pridacctbal
    ,replace(replace(t.usedamt,chr(13),''),chr(10),'') as usedamt
    ,replace(replace(t.notisubal,chr(13),''),chr(10),'') as notisubal
    ,replace(replace(t.remrepprd,chr(13),''),chr(10),'') as remrepprd
    ,replace(replace(t.fivecate,chr(13),''),chr(10),'') as fivecate
    ,replace(replace(t.fivecateadjdate,chr(13),''),chr(10),'') as fivecateadjdate
    ,replace(replace(t.rpystatus,chr(13),''),chr(10),'') as rpystatus
    ,replace(replace(t.rpyprct,chr(13),''),chr(10),'') as rpyprct
    ,replace(replace(t.overdprd,chr(13),''),chr(10),'') as overdprd
    ,replace(replace(t.totoverd,chr(13),''),chr(10),'') as totoverd
    ,replace(replace(t.overdprinc,chr(13),''),chr(10),'') as overdprinc
    ,replace(replace(t.oved31_60princ,chr(13),''),chr(10),'') as oved31_60princ
    ,replace(replace(t.oved61_90princ,chr(13),''),chr(10),'') as oved61_90princ
    ,replace(replace(t.oved91_180princ,chr(13),''),chr(10),'') as oved91_180princ
    ,replace(replace(t.ovedprinc180,chr(13),''),chr(10),'') as ovedprinc180
    ,replace(replace(t.ovedrawbaove180,chr(13),''),chr(10),'') as ovedrawbaove180
    ,replace(replace(t.currpyamt,chr(13),''),chr(10),'') as currpyamt
    ,replace(replace(t.actrpyamt,chr(13),''),chr(10),'') as actrpyamt
    ,replace(replace(t.latrpyamt,chr(13),''),chr(10),'') as latrpyamt
    ,replace(replace(t.latrpydate,chr(13),''),chr(10),'') as latrpydate
    ,replace(replace(t.closedate,chr(13),''),chr(10),'') as closedate
    ,replace(replace(t.specline,chr(13),''),chr(10),'') as specline
    ,replace(replace(t.specefctdate,chr(13),''),chr(10),'') as specefctdate
    ,replace(replace(t.specenddate,chr(13),''),chr(10),'') as specenddate
    ,replace(replace(t.usedinstamt,chr(13),''),chr(10),'') as usedinstamt
    ,replace(replace(t.cagoftrdnm,chr(13),''),chr(10),'') as cagoftrdnm
    ,replace(replace(t.cagoftrdinfdata,chr(13),''),chr(10),'') as cagoftrdinfdata
    ,replace(replace(t.extra_info,chr(13),''),chr(10),'') as extra_info
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit2_jb_inacctinf t
where  t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit2_jb_inacctinf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes