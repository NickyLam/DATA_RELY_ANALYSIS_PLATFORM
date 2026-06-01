: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nhrs_tbm_timedata_f
CreateDate: 20180529
FileName:   ${iel_data_path}/nhrs_tbm_timedata.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.calendar,chr(13),''),chr(10),'') as calendar
    ,replace(replace(t.creationtime,chr(13),''),chr(10),'') as creationtime
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,replace(replace(t.dirty_flag,chr(13),''),chr(10),'') as dirty_flag
    ,t.dr as dr
    ,t.fourabsentlen as fourabsentlen
    ,replace(replace(t.fourbegintime,chr(13),''),chr(10),'') as fourbegintime
    ,t.fourearlylen as fourearlylen
    ,replace(replace(t.fourendtime,chr(13),''),chr(10),'') as fourendtime
    ,t.fourisabsent as fourisabsent
    ,t.fourisearly as fourisearly
    ,t.fourisearlyabsent as fourisearlyabsent
    ,t.fourislate as fourislate
    ,t.fourislateabsent as fourislateabsent
    ,t.fourlatelen as fourlatelen
    ,t.fournightlen as fournightlen
    ,t.fouruselactationholidaylen as fouruselactationholidaylen
    ,t.fourworklen as fourworklen
    ,t.fourworklen_hol as fourworklen_hol
    ,t.importsignflag as importsignflag
    ,replace(replace(t.ismidoutabnormal,chr(13),''),chr(10),'') as ismidoutabnormal
    ,t.ismidwayout as ismidwayout
    ,t.midwayoutcount as midwayoutcount
    ,t.midwayouttime as midwayouttime
    ,replace(replace(t.modifiedtime,chr(13),''),chr(10),'') as modifiedtime
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,t.nightlength as nightlength
    ,t.nightlength_cur as nightlength_cur
    ,t.nightlength_next as nightlength_next
    ,t.nightlength_previous as nightlength_previous
    ,t.oneabsentlen as oneabsentlen
    ,replace(replace(t.onebegintime,chr(13),''),chr(10),'') as onebegintime
    ,t.oneearlylen as oneearlylen
    ,replace(replace(t.oneendtime,chr(13),''),chr(10),'') as oneendtime
    ,t.oneisabsent as oneisabsent
    ,t.oneisearly as oneisearly
    ,t.oneisearlyabsent as oneisearlyabsent
    ,t.oneislate as oneislate
    ,t.oneislateabsent as oneislateabsent
    ,t.onelatelen as onelatelen
    ,t.onenightlen as onenightlen
    ,t.oneuselactationholidaylen as oneuselactationholidaylen
    ,t.oneworklen as oneworklen
    ,t.oneworklen_hol as oneworklen_hol
    ,replace(replace(t.pk_fourbeginmachine,chr(13),''),chr(10),'') as pk_fourbeginmachine
    ,replace(replace(t.pk_fourbeginplace,chr(13),''),chr(10),'') as pk_fourbeginplace
    ,replace(replace(t.pk_fourendmachine,chr(13),''),chr(10),'') as pk_fourendmachine
    ,replace(replace(t.pk_fourendplace,chr(13),''),chr(10),'') as pk_fourendplace
    ,replace(replace(t.pk_group,chr(13),''),chr(10),'') as pk_group
    ,replace(replace(t.pk_onebeginmachine,chr(13),''),chr(10),'') as pk_onebeginmachine
    ,replace(replace(t.pk_onebeginplace,chr(13),''),chr(10),'') as pk_onebeginplace
    ,replace(replace(t.pk_oneendmachine,chr(13),''),chr(10),'') as pk_oneendmachine
    ,replace(replace(t.pk_oneendplace,chr(13),''),chr(10),'') as pk_oneendplace
    ,replace(replace(t.pk_org,chr(13),''),chr(10),'') as pk_org
    ,replace(replace(t.pk_psndoc,chr(13),''),chr(10),'') as pk_psndoc
    ,replace(replace(t.pk_threebeginmachine,chr(13),''),chr(10),'') as pk_threebeginmachine
    ,replace(replace(t.pk_threebeginplace,chr(13),''),chr(10),'') as pk_threebeginplace
    ,replace(replace(t.pk_threeendmachine,chr(13),''),chr(10),'') as pk_threeendmachine
    ,replace(replace(t.pk_threeendplace,chr(13),''),chr(10),'') as pk_threeendplace
    ,replace(replace(t.pk_timedata,chr(13),''),chr(10),'') as pk_timedata
    ,replace(replace(t.pk_twobeginmachine,chr(13),''),chr(10),'') as pk_twobeginmachine
    ,replace(replace(t.pk_twobeginplace,chr(13),''),chr(10),'') as pk_twobeginplace
    ,replace(replace(t.pk_twoendmachine,chr(13),''),chr(10),'') as pk_twoendmachine
    ,replace(replace(t.pk_twoendplace,chr(13),''),chr(10),'') as pk_twoendplace
    ,t.placeabnormal as placeabnormal
    ,replace(replace(t.tbmstatus,chr(13),''),chr(10),'') as tbmstatus
    ,t.threeabsentlen as threeabsentlen
    ,replace(replace(t.threebegintime,chr(13),''),chr(10),'') as threebegintime
    ,t.threeearlylen as threeearlylen
    ,replace(replace(t.threeendtime,chr(13),''),chr(10),'') as threeendtime
    ,t.threeisabsent as threeisabsent
    ,t.threeisearly as threeisearly
    ,t.threeisearlyabsent as threeisearlyabsent
    ,t.threeislate as threeislate
    ,t.threeislateabsent as threeislateabsent
    ,t.threelatelen as threelatelen
    ,t.threenightlen as threenightlen
    ,t.threeuselactationholidaylen as threeuselactationholidaylen
    ,t.threeworklen as threeworklen
    ,t.threeworklen_hol as threeworklen_hol
    ,replace(replace(t.ts,chr(13),''),chr(10),'') as ts
    ,t.twoabsentlen as twoabsentlen
    ,replace(replace(t.twobegintime,chr(13),''),chr(10),'') as twobegintime
    ,t.twoearlylen as twoearlylen
    ,replace(replace(t.twoendtime,chr(13),''),chr(10),'') as twoendtime
    ,t.twoisabsent as twoisabsent
    ,t.twoisearly as twoisearly
    ,t.twoisearlyabsent as twoisearlyabsent
    ,t.twoislate as twoislate
    ,t.twoislateabsent as twoislateabsent
    ,t.twolatelen as twolatelen
    ,t.twonightlen as twonightlen
    ,t.twouselactationholidaylen as twouselactationholidaylen
    ,t.twoworklen as twoworklen
    ,t.twoworklen_hol as twoworklen_hol
    ,t.worklength as worklength
    ,t.worklength_cur as worklength_cur
    ,t.worklength_cur_hol as worklength_cur_hol
    ,t.worklength_hol as worklength_hol
    ,t.worklength_next as worklength_next
    ,t.worklength_next_hol as worklength_next_hol
    ,t.worklength_previous as worklength_previous
    ,t.worklength_previous_hol as worklength_previous_hol
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iol.nhrs_tbm_timedata t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nhrs_tbm_timedata.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes