: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_core_baill_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_core_baill_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select baillno
   ,acceptancebaillno
   ,acceptanceorg
   ,artificialno
   ,businesscurrency
   ,baillmedium
   ,bailltype
   ,businesssum
   ,handsum
   ,putoutdate
   ,maturity
   ,baillstart
   ,closetype
   ,sectionsdate
   ,sectionstype
   ,advancessum
   ,duebillserialno
from ${idl_schema}.odss_core_baill_info
where etl_dt = TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_core_baill_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes