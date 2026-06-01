: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_web_mall_merchd_sub_info_h_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_web_mall_merchd_sub_info_h.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.start_dt as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.merchd_sub_flow_num,chr(13),''),chr(10),'') as merchd_sub_flow_num
,replace(replace(t.indent_flow_num,chr(13),''),chr(10),'') as indent_flow_num
,replace(replace(t.merchd_id,chr(13),''),chr(10),'') as merchd_id
,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t.merchd_name,chr(13),''),chr(10),'') as merchd_name
,replace(replace(t.merchd_descb,chr(13),''),chr(10),'') as merchd_descb
,replace(replace(t.merchd_tot_qtty,chr(13),''),chr(10),'') as merchd_tot_qtty
,t.cors_merchd_tot_amt as cors_merchd_tot_amt
,replace(replace(t.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t.cors_merchd_tot_point,chr(13),''),chr(10),'') as cors_merchd_tot_point
,replace(replace(t.rtn_goods_status_cd,chr(13),''),chr(10),'') as rtn_goods_status_cd
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.provi_name,chr(13),''),chr(10),'') as provi_name
,t.singl_merchd_comm_fee as singl_merchd_comm_fee
,replace(replace(t.merchd_type_cd,chr(13),''),chr(10),'') as merchd_type_cd
,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,t.indent_info_create_tm as indent_info_create_tm
,t.indent_info_update_tm as indent_info_update_tm
,replace(replace(t.addit_data_1,chr(13),''),chr(10),'') as addit_data_1
,replace(replace(t.addit_data_2,chr(13),''),chr(10),'') as addit_data_2
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.evt_web_mall_merchd_sub_info_h t
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_web_mall_merchd_sub_info_h.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes