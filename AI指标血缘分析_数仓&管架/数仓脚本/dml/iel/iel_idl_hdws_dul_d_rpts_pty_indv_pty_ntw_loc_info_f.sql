: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_indv_pty_ntw_loc_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_indv_pty_ntw_loc_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
pty_id
,etl_dt
,web_loc_typ_cd
,e_loc
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_pty_indv_pty_ntw_loc_info 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_indv_pty_ntw_loc_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes