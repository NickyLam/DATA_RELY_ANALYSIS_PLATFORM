: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_zts_a0hfamidinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_zts_a0hfamidinfo_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
familyid
,custacc
,familystate
,createdate
,effectivedate
,abatedate
from ${idl_schema}.crms_zts_a0hfamidinfo
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_zts_a0hfamidinfo_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes