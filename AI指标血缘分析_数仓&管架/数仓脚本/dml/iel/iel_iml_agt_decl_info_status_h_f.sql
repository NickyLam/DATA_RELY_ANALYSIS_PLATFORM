: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_decl_info_status_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_decl_info_status_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.status_id,chr(13),''),chr(10),'') as status_id
,replace(replace(t1.edit_id,chr(13),''),chr(10),'') as edit_id
,replace(replace(t1.temp_decl_flow_num,chr(13),''),chr(10),'') as temp_decl_flow_num
,replace(replace(t1.init_enty_id,chr(13),''),chr(10),'') as init_enty_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.rela_table_name,chr(13),''),chr(10),'') as rela_table_name
,replace(replace(t1.rela_decl_id,chr(13),''),chr(10),'') as rela_decl_id
,replace(replace(t1.decl_num,chr(13),''),chr(10),'') as decl_num
,replace(replace(t1.trade_gen_cd,chr(13),''),chr(10),'') as trade_gen_cd
,replace(replace(t1.money_idf_cd,chr(13),''),chr(10),'') as money_idf_cd
,replace(replace(t1.base_info_status_cd,chr(13),''),chr(10),'') as base_info_status_cd
,replace(replace(t1.decl_info_status_cd,chr(13),''),chr(10),'') as decl_info_status_cd
,replace(replace(t1.wrt_off_info_status_cd,chr(13),''),chr(10),'') as wrt_off_info_status_cd
,replace(replace(t1.yga_e_acct_info_status_cd,chr(13),''),chr(10),'') as yga_e_acct_info_status_cd
,replace(replace(t1.bus_oper_teller_id,chr(13),''),chr(10),'') as bus_oper_teller_id
,auth_dt

from ${iml_schema}.agt_decl_info_status_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_decl_info_status_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
