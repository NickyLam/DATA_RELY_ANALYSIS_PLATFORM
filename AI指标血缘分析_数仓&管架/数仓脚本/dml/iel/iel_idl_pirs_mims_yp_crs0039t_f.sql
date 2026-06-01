: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_mims_yp_crs0039t_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_mims_yp_crs0039t.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t1.flag,chr(13),''),chr(10),'') as flag
,t1.confmamt as confmamt
,replace(replace(t1.curreny,chr(13),''),chr(10),'') as curreny
,replace(replace(t1.inputorg,chr(13),''),chr(10),'') as inputorg
,replace(replace(t1.datasourceflag,chr(13),''),chr(10),'') as datasourceflag
,'' as data_date
from ${iol_schema}.mims_yp_crs0039t t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_mims_yp_crs0039t.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes