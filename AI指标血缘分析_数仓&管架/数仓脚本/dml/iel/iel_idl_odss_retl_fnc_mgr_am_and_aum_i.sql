: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_retl_fnc_mgr_am_and_aum_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_retl_fnc_mgr_am_and_aum_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
cc_data_dt
,cc_org_no
,cc_fnc_mgr_num
,cc_mag_mavg_1
,cc_mag_mavg_2
,cc_mag_mavg_3
,cc_mag_mavg_4
,cc_mag_cst_1
,cc_mag_cst_2
,cc_mag_cst_3
,cc_mag_cst_4
from ${idl_schema}.odss_retl_fnc_mgr_am_and_aum
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_retl_fnc_mgr_am_and_aum_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes