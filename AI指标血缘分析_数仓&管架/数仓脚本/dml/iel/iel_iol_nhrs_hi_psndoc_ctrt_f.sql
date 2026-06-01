: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_hi_psndoc_ctrt_f
CreateDate: 20240205
FileName:   ${iel_data_path}/nhrs_hi_psndoc_ctrt.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,assgid
,replace(replace(t1.begindate,chr(13),''),chr(10),'') as begindate
,breachmoney
,cont_unit
,contid
,continuetime
,replace(replace(t1.contmodel,chr(13),''),chr(10),'') as contmodel
,replace(replace(t1.contractcode,chr(13),''),chr(10),'') as contractcode
,replace(replace(t1.contractnum,chr(13),''),chr(10),'') as contractnum
,conttype
,replace(replace(t1.creationtime,chr(13),''),chr(10),'') as creationtime
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,dr
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.filepath,chr(13),''),chr(10),'') as filepath
,replace(replace(t1.ifprop,chr(13),''),chr(10),'') as ifprop
,replace(replace(t1.ifwrite,chr(13),''),chr(10),'') as ifwrite
,replace(replace(t1.isrefer,chr(13),''),chr(10),'') as isrefer
,replace(replace(t1.judgedate,chr(13),''),chr(10),'') as judgedate
,replace(replace(t1.lastflag,chr(13),''),chr(10),'') as lastflag
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier
,neconomy
,replace(replace(t1.pk_conttext,chr(13),''),chr(10),'') as pk_conttext
,replace(replace(t1.pk_group,chr(13),''),chr(10),'') as pk_group
,replace(replace(t1.pk_majorcorp,chr(13),''),chr(10),'') as pk_majorcorp
,replace(replace(t1.pk_org,chr(13),''),chr(10),'') as pk_org
,replace(replace(t1.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
,replace(replace(t1.pk_psndoc_sub,chr(13),''),chr(10),'') as pk_psndoc_sub
,replace(replace(t1.pk_psnjob,chr(13),''),chr(10),'') as pk_psnjob
,replace(replace(t1.pk_psnorg,chr(13),''),chr(10),'') as pk_psnorg
,replace(replace(t1.pk_termtype,chr(13),''),chr(10),'') as pk_termtype
,replace(replace(t1.pk_unchreason,chr(13),''),chr(10),'') as pk_unchreason
,presenter
,replace(replace(t1.probegindate,chr(13),''),chr(10),'') as probegindate
,replace(replace(t1.probenddate,chr(13),''),chr(10),'') as probenddate
,probsalary
,promonth
,prop_unit
,recordnum
,replace(replace(t1.signaddr,chr(13),''),chr(10),'') as signaddr
,replace(replace(t1.signdate,chr(13),''),chr(10),'') as signdate
,startsalary
,termmonth
,replace(replace(t1.termtype,chr(13),''),chr(10),'') as termtype
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts

from ${iol_schema}.nhrs_hi_psndoc_ctrt t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_hi_psndoc_ctrt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
