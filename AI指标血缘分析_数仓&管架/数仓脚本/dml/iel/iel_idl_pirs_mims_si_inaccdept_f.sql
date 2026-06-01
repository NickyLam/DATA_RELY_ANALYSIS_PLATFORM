: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_mims_si_inaccdept_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_mims_si_inaccdept.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.sccode,chr(13),''),chr(10),'') as sccode
,replace(replace(t1.datasourceflag,chr(13),''),chr(10),'') as datasourceflag
,replace(replace(t1.inaccountdept,chr(13),''),chr(10),'') as inaccountdept
,replace(replace(t1.registorg,chr(13),''),chr(10),'') as registorg
,'' as data_date
from ${iol_schema}.mims_si_inaccdept t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_mims_si_inaccdept.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes