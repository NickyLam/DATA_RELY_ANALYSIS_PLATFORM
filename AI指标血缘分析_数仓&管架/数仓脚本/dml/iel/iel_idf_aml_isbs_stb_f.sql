: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_isbs_stb_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_isbs_stb.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,tbl
,uil
,cod
,txt from idl.aml_isbs_stb where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_isbs_stb.f.${batch_date}.dat" \
        charset=utf8
        safe=yes