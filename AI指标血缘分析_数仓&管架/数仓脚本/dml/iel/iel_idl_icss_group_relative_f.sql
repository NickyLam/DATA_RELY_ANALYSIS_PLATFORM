: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icss_group_relative_f
CreateDate: 20180529
FileName:   ${iel_data_path}/GROUP_RELATIVE_${batch_date}_ALL.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select customerid
,relativeid
,relationship
,inputorgid
,inputuserid
,inputdate
,updatedate
,remark from idl.icss_group_relative where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/GROUP_RELATIVE_${batch_date}_ALL.dat" \
        charset=zhs16gbk
        safe=yes