: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_a_d_cm_branch_dt_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_a_d_cm_branch_dt_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select date_id
,branch_code
,branch_name
,short_name
,branch_tp
,branch_level
,parent_id
,start_date
,end_date
,city_code
,brch_level
,bak_1
,bak_2
,bak_3
,oth_brch_tg
,corp_code
,brch_acct_tg
from idl.orws_a_d_cm_branch_dt where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_a_d_cm_branch_dt_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes