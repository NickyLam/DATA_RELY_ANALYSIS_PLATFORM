: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_smg_t_organ_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_smg_t_organ_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,br_code
,br_name
,br_short_name
,br_en_name
,br_short_en_name
,br_addr
,br_phone
,br_level
,br_type
,br_up_code
,br_path
,br_is_leaf
,br_note_email
,br_state
,modify_time
,modi_id
,creator_id
,create_time
,dele_id
,del_time
,biz_codes
,center_id
,curr_slip_set_no
,br_smg_flag
,area_code
,smg_t_core_organ
,change_number
from ${idl_schema}.odss_smg_t_organ
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_smg_t_organ_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes