: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_crdt_bus_cont_risk_adj_h_f
CreateDate: 20251013
FileName:   ${iel_data_path}/agt_crdt_bus_cont_risk_adj_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.bus_cont_id,chr(13),''),chr(10),'') as bus_cont_id
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.bus_curr_cd,chr(13),''),chr(10),'') as bus_curr_cd
,bal
,replace(replace(t1.bf_adj_level5_cls_cd,chr(13),''),chr(10),'') as bf_adj_level5_cls_cd
,replace(replace(t1.a_adjust_level5_cls_cd,chr(13),''),chr(10),'') as a_adjust_level5_cls_cd
,replace(replace(t1.bf_adj_level11_cls_cd,chr(13),''),chr(10),'') as bf_adj_level11_cls_cd
,replace(replace(t1.a_adjust_level11_cls_cd,chr(13),''),chr(10),'') as a_adjust_level11_cls_cd
,adj_dt
,replace(replace(t1.mg_prot_teller_id,chr(13),''),chr(10),'') as mg_prot_teller_id
,replace(replace(t1.mg_prot_org_id,chr(13),''),chr(10),'') as mg_prot_org_id
,replace(replace(t1.rela_flow_id,chr(13),''),chr(10),'') as rela_flow_id
,replace(replace(t1.rela_flow_type_cd,chr(13),''),chr(10),'') as rela_flow_type_cd
,replace(replace(t1.obj_type_cd,chr(13),''),chr(10),'') as obj_type_cd
,replace(replace(t1.obj_descb,chr(13),''),chr(10),'') as obj_descb
,replace(replace(t1.init_teller_id,chr(13),''),chr(10),'') as init_teller_id

from ${iml_schema}.agt_crdt_bus_cont_risk_adj_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_crdt_bus_cont_risk_adj_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
