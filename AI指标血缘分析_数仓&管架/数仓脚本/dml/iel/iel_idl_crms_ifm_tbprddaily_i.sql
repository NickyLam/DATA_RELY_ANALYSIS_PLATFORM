: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbprddaily_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbprddaily_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
ta_code
,income_unit
,last_status
,prd_code
,tot_vol
,prd_scale
,income
,status
,tot_nav
,face_value
,nav
,iss_date
,reserve1
,reserve2
,amt1
,larg_red_flag
,larg_red_cfm_rate
,chgout_cfm_rate
,income_rate
,assign_income
,reduce_vol
,increase_vol
,assign_flag
,unassign_income
,cfm_date
,excess_flag
,excess_cfm_rate
,conv_flag
from ${idl_schema}.crms_ifm_tbprddaily
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbprddaily_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes