: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_irs_apply_info_f
CreateDate: 20240801
FileName:   ${iel_data_path}/icms_irs_apply_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,adjustlasttime
,replace(replace(t1.adjustlevel,chr(13),''),chr(10),'') as adjustlevel
,replace(replace(t1.applyid,chr(13),''),chr(10),'') as applyid
,replace(replace(t1.applytype,chr(13),''),chr(10),'') as applytype
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.auditflag,chr(13),''),chr(10),'') as auditflag
,balance
,replace(replace(t1.creditapplyid,chr(13),''),chr(10),'') as creditapplyid
,replace(replace(t1.creditsync,chr(13),''),chr(10),'') as creditsync
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t1.datasource,chr(13),''),chr(10),'') as datasource
,replace(replace(t1.entscale,chr(13),''),chr(10),'') as entscale
,replace(replace(t1.enttype,chr(13),''),chr(10),'') as enttype
,replace(replace(t1.finallevel,chr(13),''),chr(10),'') as finallevel
,replace(replace(t1.hightech,chr(13),''),chr(10),'') as hightech
,replace(replace(t1.industrytype,chr(13),''),chr(10),'') as industrytype
,inputdate
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputorgname,chr(13),''),chr(10),'') as inputorgname
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputusername,chr(13),''),chr(10),'') as inputusername
,replace(replace(t1.lastapplyid,chr(13),''),chr(10),'') as lastapplyid
,replace(replace(t1.lastreporttime,chr(13),''),chr(10),'') as lastreporttime
,replace(replace(t1.modelcode,chr(13),''),chr(10),'') as modelcode
,replace(replace(t1.modelname,chr(13),''),chr(10),'') as modelname
,replace(replace(t1.needreport,chr(13),''),chr(10),'') as needreport
,replace(replace(t1.occurtype,chr(13),''),chr(10),'') as occurtype
,replace(replace(t1.originlevel,chr(13),''),chr(10),'') as originlevel
,replace(replace(t1.overthrowlevel,chr(13),''),chr(10),'') as overthrowlevel
,replace(replace(t1.overthrowreason,chr(13),''),chr(10),'') as overthrowreason
,replace(replace(t1.phaseopinion,chr(13),''),chr(10),'') as phaseopinion
,replace(replace(t1.pusherrorinfo,chr(13),''),chr(10),'') as pusherrorinfo
,ratedelaydate
,replace(replace(t1.ratedelaymonth,chr(13),''),chr(10),'') as ratedelaymonth
,replace(replace(t1.ratedelayreason,chr(13),''),chr(10),'') as ratedelayreason
,replace(replace(t1.rateobjtype,chr(13),''),chr(10),'') as rateobjtype
,replace(replace(t1.realestate,chr(13),''),chr(10),'') as realestate
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.reportno,chr(13),''),chr(10),'') as reportno
,replace(replace(t1.reportscope,chr(13),''),chr(10),'') as reportscope
,replace(replace(t1.reporttime,chr(13),''),chr(10),'') as reporttime
,replace(replace(t1.reporttypeno,chr(13),''),chr(10),'') as reporttypeno
,savelimittimes
,savetimes
,setupdate

from ${iol_schema}.icms_irs_apply_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_irs_apply_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
