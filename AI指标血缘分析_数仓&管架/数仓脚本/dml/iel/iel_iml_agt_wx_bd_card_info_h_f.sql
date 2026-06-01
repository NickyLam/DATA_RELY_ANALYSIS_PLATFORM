: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_wx_bd_card_info_h_f
CreateDate: 20230602
FileName:   ${iel_data_path}/agt_wx_bd_card_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.card_type_cd,chr(13),''),chr(10),'') as card_type_cd
,replace(replace(t1.dmic_send_flg,chr(13),''),chr(10),'') as dmic_send_flg
,final_update_tm

from ${iml_schema}.agt_wx_bd_card_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wx_bd_card_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
