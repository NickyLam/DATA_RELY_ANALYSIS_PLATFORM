: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_glms_fcv_exrt_i
CreateDate: 20180529
FileName:   ${iel_data_path}/fcv_exrt_${batch_date}_inc.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select date_id
,source_cd
,rmbcd
,cny_exrt from idl.glms_fcv_exrt where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/fcv_exrt_${batch_date}_inc.dat" \
        charset=zhs16gbk
        safe=yes