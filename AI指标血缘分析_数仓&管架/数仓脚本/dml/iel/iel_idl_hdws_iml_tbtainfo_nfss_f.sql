: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_tbtainfo_nfss_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_tbtainfo_nfss.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
ta_code
,ta_shortname
,ta_name
,comp_mode
,templet
,open_time
,close_time
,status
,prd_type
,sum_flag
,muti_acc
,clear_type
,real_cfm_flag
,sub_deal_mode
,cfm_fail_intere_in
,host_check_date
,first_invest_flags
,clear_table_flag
,control_flag
,reserve1
,reserve2
,reserve3
,etl_dt
,data_src_cd
from ${idl_schema}.hdws_iml_tbtainfo_nfss
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_tbtainfo_nfss.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes