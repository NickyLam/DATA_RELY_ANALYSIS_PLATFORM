: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_plms_businessinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/Businessinfo_${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select duebillno
,intdate
,accountbalance
,accountuserbalance
,termtype
,termmonthtype
,tatimes
,insum
,interestinsum
,finishdate from idl.plms_businessinfo where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/Businessinfo_${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes