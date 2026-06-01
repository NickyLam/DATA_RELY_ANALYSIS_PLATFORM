: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icss_repayment_plan_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/REPAYMENT_PLAN_INFO_${batch_date}_ALL.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select duebillserialno
,dateno
,startdate
,executiondate
,businesscurrency
,businessrate
,normalsum
,periodsum
,periodinterestsum
,discountsum
,flag from idl.icss_repayment_plan_info where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/REPAYMENT_PLAN_INFO_${batch_date}_ALL.dat" \
        charset=zhs16gbk
        safe=yes