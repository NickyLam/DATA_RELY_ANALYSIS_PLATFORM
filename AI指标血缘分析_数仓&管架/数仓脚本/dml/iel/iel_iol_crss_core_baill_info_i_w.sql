: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_core_baill_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_core_baill_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(baillno,chr(10),''),chr(13),'') as baillno
,replace(replace(acceptancebaillno,chr(10),''),chr(13),'') as acceptancebaillno
,replace(replace(acceptanceorg,chr(10),''),chr(13),'') as acceptanceorg
,replace(replace(artificialno,chr(10),''),chr(13),'') as artificialno
,replace(replace(businesscurrency,chr(10),''),chr(13),'') as businesscurrency
,replace(replace(baillmedium,chr(10),''),chr(13),'') as baillmedium
,replace(replace(bailltype,chr(10),''),chr(13),'') as bailltype
,replace(replace(businesssum,chr(10),''),chr(13),'') as businesssum
,replace(replace(handsum,chr(10),''),chr(13),'') as handsum
,replace(replace(putoutdate,chr(10),''),chr(13),'') as putoutdate
,replace(replace(maturity,chr(10),''),chr(13),'') as maturity
,replace(replace(baillstart,chr(10),''),chr(13),'') as baillstart
,replace(replace(closetype,chr(10),''),chr(13),'') as closetype
,replace(replace(sectionsdate,chr(10),''),chr(13),'') as sectionsdate
,replace(replace(sectionstype,chr(10),''),chr(13),'') as sectionstype
,replace(replace(advancessum,chr(10),''),chr(13),'') as advancessum
,replace(replace(duebillserialno,chr(10),''),chr(13),'') as duebillserialno
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_core_baill_info 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_core_baill_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes