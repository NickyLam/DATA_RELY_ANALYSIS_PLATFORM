: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_bd_shift_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_bd_shift.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,t.allowearly as allowearly
    ,t.allowlate as allowlate
    ,t.beginday as beginday
    ,replace(replace(t.begintime,chr(13),''),chr(10),'') as begintime
    ,t.capbeginday as capbeginday
    ,replace(replace(t.capbegintime,chr(13),''),chr(10),'') as capbegintime
    ,t.capendday as capendday
    ,replace(replace(t.capendtime,chr(13),''),chr(10),'') as capendtime
    ,t.capgzsj as capgzsj
    ,t.cardtype as cardtype
    ,replace(replace(t.code,chr(13),''),chr(10),'') as code
    ,replace(replace(t.creationtime,chr(13),''),chr(10),'') as creationtime
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,t.dataoriginflag as dataoriginflag
    ,replace(replace(t.defaultflag,chr(13),''),chr(10),'') as defaultflag
    ,t.dr as dr
    ,t.earliestendday as earliestendday
    ,replace(replace(t.earliestendtime,chr(13),''),chr(10),'') as earliestendtime
    ,t.enablestate as enablestate
    ,t.endday as endday
    ,replace(replace(t.endtime,chr(13),''),chr(10),'') as endtime
    ,t.gzsj as gzsj
    ,replace(replace(t.includenightshift,chr(13),''),chr(10),'') as includenightshift
    ,replace(replace(t.isallowout,chr(13),''),chr(10),'') as isallowout
    ,replace(replace(t.isautokg,chr(13),''),chr(10),'') as isautokg
    ,replace(replace(t.iscapedited,chr(13),''),chr(10),'') as iscapedited
    ,replace(replace(t.isflexiblefinal,chr(13),''),chr(10),'') as isflexiblefinal
    ,replace(replace(t.ishredited,chr(13),''),chr(10),'') as ishredited
    ,replace(replace(t.isotflexible,chr(13),''),chr(10),'') as isotflexible
    ,replace(replace(t.isotflexiblefinal,chr(13),''),chr(10),'') as isotflexiblefinal
    ,replace(replace(t.isrttimeflexible,chr(13),''),chr(10),'') as isrttimeflexible
    ,replace(replace(t.isrttimeflexiblefinal,chr(13),''),chr(10),'') as isrttimeflexiblefinal
    ,replace(replace(t.issinglecard,chr(13),''),chr(10),'') as issinglecard
    ,replace(replace(t.isturn,chr(13),''),chr(10),'') as isturn
    ,t.kghours as kghours
    ,t.largeearly as largeearly
    ,t.largelate as largelate
    ,t.latestbeginday as latestbeginday
    ,replace(replace(t.latestbegintime,chr(13),''),chr(10),'') as latestbegintime
    ,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
    ,replace(replace(t.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.name2,chr(13),''),chr(10),'') as name2
    ,replace(replace(t.name3,chr(13),''),chr(10),'') as name3
    ,replace(replace(t.name4,chr(13),''),chr(10),'') as name4
    ,replace(replace(t.name5,chr(13),''),chr(10),'') as name5
    ,replace(replace(t.name6,chr(13),''),chr(10),'') as name6
    ,t.nightbeginday as nightbeginday
    ,replace(replace(t.nightbegintime,chr(13),''),chr(10),'') as nightbegintime
    ,t.nightendday as nightendday
    ,replace(replace(t.nightendtime,chr(13),''),chr(10),'') as nightendtime
    ,t.nightgzsj as nightgzsj
    ,t.ontmbeyond as ontmbeyond
    ,t.ontmend as ontmend
    ,t.overtmbegin as overtmbegin
    ,t.overtmbeyond as overtmbeyond
    ,replace(replace(t.pk_group,chr(13),''),chr(10),'') as pk_group
    ,replace(replace(t.pk_org,chr(13),''),chr(10),'') as pk_org
    ,replace(replace(t.pk_shift,chr(13),''),chr(10),'') as pk_shift
    ,replace(replace(t.pk_shifttype,chr(13),''),chr(10),'') as pk_shifttype
    ,t.timebeginday as timebeginday
    ,replace(replace(t.timebegintime,chr(13),''),chr(10),'') as timebegintime
    ,t.timeendday as timeendday
    ,replace(replace(t.timeendtime,chr(13),''),chr(10),'') as timeendtime
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,replace(replace(t.useontmrule,chr(13),''),chr(10),'') as useontmrule
    ,replace(replace(t.useovertmrule,chr(13),''),chr(10),'') as useovertmrule
    ,t.worklen as worklen
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_bd_shift t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_bd_shift.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes