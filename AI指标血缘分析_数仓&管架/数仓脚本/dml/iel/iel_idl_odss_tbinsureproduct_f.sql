: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbinsureproduct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbinsureproduct_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
prd_code
,ta_code
,prd_name
,prd_name2
,prd_type
,prd_sub_type
,prd_busin_flag
,prd_limit_flag
,curr_type
,online_flag
,begin_date
,end_date
,prd_add_flag
,targ_prd_code
,waver_days
,master_agiorate
,check_type
,control_flag
,reserve1
,reserve2
,reserve3
,reserve4
from ${idl_schema}.odss_tbinsureproduct
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbinsureproduct_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes