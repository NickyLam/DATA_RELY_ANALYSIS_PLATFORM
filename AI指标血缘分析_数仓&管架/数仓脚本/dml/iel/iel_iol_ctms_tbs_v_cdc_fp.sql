: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_cdc_fp
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_v_cdc_fp.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select * from iol.ctms_tbs_v_cdc_fp where etl_dt=TO_DATE('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_cdc_fp.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes