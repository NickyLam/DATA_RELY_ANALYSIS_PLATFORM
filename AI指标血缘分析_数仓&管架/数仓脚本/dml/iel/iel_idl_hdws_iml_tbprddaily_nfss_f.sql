: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_tbprddaily_nfss_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_tbprddaily_nfss.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
iss_date
,cfm_date
,prd_code
,ta_code
,prd_scale
,tot_vol
,increase_vol
,reduce_vol
,nav
,face_value
,larg_red_flag
,larg_red_cfm_rate
,chgout_cfm_rate
,excess_flag
,excess_cfm_rate
,income_rate
,income
,income_unit
,unassign_income
,assign_income
,assign_flag
,conv_flag
,status
,last_status
,tot_nav
,amt1
,reserve1
,reserve2
,etl_dt
,data_src_cd
from ${idl_schema}.hdws_iml_tbprddaily_nfss
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_tbprddaily_nfss.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes