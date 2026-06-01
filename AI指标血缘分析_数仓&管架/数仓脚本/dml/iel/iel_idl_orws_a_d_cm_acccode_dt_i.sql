: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_a_d_cm_acccode_dt_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_a_d_cm_acccode_dt_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select date_id
,acc_code
,acc_name
,acc_level
,parent_id
,in_out_flag
,acc_blncdn
,detail_flag
,profit_flag
,acc_sour
,acc_tg
,overdraw_flag
,bal_tg
,bak_1
,bak_2
,bak_3
from idl.orws_a_d_cm_acccode_dt where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_a_d_cm_acccode_dt_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes