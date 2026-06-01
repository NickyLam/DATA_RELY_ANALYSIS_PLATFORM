: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_security_extra_info
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_security_extra_info.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select * from iol.ctms_tbs_v_security_extra_info where start_dt<=TO_DATE('${batch_date}','yyyymmdd') and end_dt>TO_DATE('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_security_extra_info.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes