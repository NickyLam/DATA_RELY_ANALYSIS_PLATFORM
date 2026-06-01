: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit2_jb_inacctmdfc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit2_jb_inacctmdfc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.infrectype,chr(13),''),chr(10),'') as infrectype
    ,replace(replace(t.modreccode,chr(13),''),chr(10),'') as modreccode
    ,replace(replace(t.rptdate,chr(13),''),chr(10),'') as rptdate
    ,replace(replace(t.accttype,chr(13),''),chr(10),'') as accttype
    ,replace(replace(t.mdfcsgmtcode,chr(13),''),chr(10),'') as mdfcsgmtcode
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
    ,replace(replace(t.idnum,chr(13),''),chr(10),'') as idnum
    ,replace(replace(t.mngmtorgcode,chr(13),''),chr(10),'') as mngmtorgcode
    ,replace(replace(t.busilines,chr(13),''),chr(10),'') as busilines
    ,replace(replace(t.busidtllines,chr(13),''),chr(10),'') as busidtllines
    ,replace(replace(t.opendate,chr(13),''),chr(10),'') as opendate
    ,replace(replace(t.cy,chr(13),''),chr(10),'') as cy
    ,t.acctcredline as acctcredline
    ,t.loanamt as loanamt
    ,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
    ,replace(replace(t.duedate,chr(13),''),chr(10),'') as duedate
    ,replace(replace(t.repaymode,chr(13),''),chr(10),'') as repaymode
    ,replace(replace(t.repayfreqcy,chr(13),''),chr(10),'') as repayfreqcy
    ,t.repayprd as repayprd
    ,replace(replace(t.applybusidist,chr(13),''),chr(10),'') as applybusidist
    ,replace(replace(t.guarmode,chr(13),''),chr(10),'') as guarmode
    ,replace(replace(t.othrepyguarway,chr(13),''),chr(10),'') as othrepyguarway
    ,replace(replace(t.assettrandflag,chr(13),''),chr(10),'') as assettrandflag
    ,replace(replace(t.fundsou,chr(13),''),chr(10),'') as fundsou
    ,replace(replace(t.loanform,chr(13),''),chr(10),'') as loanform
    ,replace(replace(t.creditid,chr(13),''),chr(10),'') as creditid
    ,replace(replace(t.loanconcode,chr(13),''),chr(10),'') as loanconcode
    ,replace(replace(t.firsthouloanflag,chr(13),''),chr(10),'') as firsthouloanflag
    ,t.rltrepymtnm as rltrepymtnm
    ,replace(replace(t.rltrepymtinfdata,chr(13),''),chr(10),'') as rltrepymtinfdata
    ,t.ccnm as ccnm
    ,replace(replace(t.cccinfdata,chr(13),''),chr(10),'') as cccinfdata
    ,replace(replace(t.mcc,chr(13),''),chr(10),'') as mcc
    ,replace(replace(t.initcredname,chr(13),''),chr(10),'') as initcredname
    ,replace(replace(t.initcredorgnm,chr(13),''),chr(10),'') as initcredorgnm
    ,replace(replace(t.origdbtcate,chr(13),''),chr(10),'') as origdbtcate
    ,replace(replace(t.initrpysts,chr(13),''),chr(10),'') as initrpysts
    ,replace(replace(t.month,chr(13),''),chr(10),'') as month
    ,t.settdate as settdate
    ,replace(replace(t.acctstatus,chr(13),''),chr(10),'') as acctstatus
    ,t.acctbal as acctbal
    ,t.pridacctbal as pridacctbal
    ,t.usedamt as usedamt
    ,t.notisubal as notisubal
    ,t.remrepprd as remrepprd
    ,replace(replace(t.fivecate,chr(13),''),chr(10),'') as fivecate
    ,replace(replace(t.fivecateadjdate,chr(13),''),chr(10),'') as fivecateadjdate
    ,replace(replace(t.rpystatus,chr(13),''),chr(10),'') as rpystatus
    ,replace(replace(t.rpyprct,chr(13),''),chr(10),'') as rpyprct
    ,t.overdprd as overdprd
    ,t.totoverd as totoverd
    ,t.overdprinc as overdprinc
    ,t.oved31_60princ as oved31_60princ
    ,t.oved61_90princ as oved61_90princ
    ,t.oved91_180princ as oved91_180princ
    ,t.ovedprinc180 as ovedprinc180
    ,t.ovedrawbaove180 as ovedrawbaove180
    ,t.currpyamt as currpyamt
    ,t.actrpyamt as actrpyamt
    ,t.latrpyamt as latrpyamt
    ,replace(replace(t.latrpydate,chr(13),''),chr(10),'') as latrpydate
    ,replace(replace(t.closedate,chr(13),''),chr(10),'') as closedate
    ,t.specline as specline
    ,replace(replace(t.specefctdate,chr(13),''),chr(10),'') as specefctdate
    ,replace(replace(t.specenddate,chr(13),''),chr(10),'') as specenddate
    ,t.usedinstamt as usedinstamt
    ,t.cagoftrdnm as cagoftrdnm
    ,replace(replace(t.cagoftrdinfdata,chr(13),''),chr(10),'') as cagoftrdinfdata
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit2_jb_inacctmdfc t
where  t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit2_jb_inacctmdfc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes