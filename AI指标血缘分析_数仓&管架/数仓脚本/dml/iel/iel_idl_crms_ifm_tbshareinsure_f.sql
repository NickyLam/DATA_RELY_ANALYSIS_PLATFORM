: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbshareinsure_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbshareinsure_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
ta_code
,prd_code
,insure_no
,bank_no
,insure_pwd
,client_manager
,client_no
,holder_name
,holder_id_type
,holder_id_code
,relation
,insured_name
,insured_id_type
,insured_id_code
,insure_print
,insure_publish
,invoice_no
,internal_branch
,branch_no
,oper_no
,trans_date
,serial_no
,insure_date
,cfm_date
,pay_year
,insure_year_type
,insure_year
,effect_date
,pay_type
,pay_year_type
,amt
,insure_fee
,bank_acc
,vol
,status
,recommender
,benici_flag
,reserve1
,reserve2
,reserve3
from ${idl_schema}.crms_ifm_tbshareinsure
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbshareinsure_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes