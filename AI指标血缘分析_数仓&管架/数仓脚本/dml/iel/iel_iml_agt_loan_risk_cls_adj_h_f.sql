: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_risk_cls_adj_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_risk_cls_adj_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.risk_cls_id,chr(13),''),chr(10),'') as risk_cls_id
,replace(replace(t1.init_cls_id,chr(13),''),chr(10),'') as init_cls_id
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.obj_type_name,chr(13),''),chr(10),'') as obj_type_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,cls_pd
,replace(replace(t1.adj_way_cd,chr(13),''),chr(10),'') as adj_way_cd
,replace(replace(t1.curr_cls_way_cd,chr(13),''),chr(10),'') as curr_cls_way_cd
,replace(replace(t1.curr_cls_rest_cd,chr(13),''),chr(10),'') as curr_cls_rest_cd
,replace(replace(t1.cls_adj_rs_descb,chr(13),''),chr(10),'') as cls_adj_rs_descb
,replace(replace(t1.adj_cls_rest_cd,chr(13),''),chr(10),'') as adj_cls_rest_cd
,replace(replace(t1.adj_appl_teller_id,chr(13),''),chr(10),'') as adj_appl_teller_id
,replace(replace(t1.adj_appl_org_id,chr(13),''),chr(10),'') as adj_appl_org_id
,adj_appl_dt
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.belong_strip_line_cd,chr(13),''),chr(10),'') as belong_strip_line_cd
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,oper_dt
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,replace(replace(t1.update_teller_id,chr(13),''),chr(10),'') as update_teller_id
,replace(replace(t1.update_org_id,chr(13),''),chr(10),'') as update_org_id
,modif_dt
,replace(replace(t1.move_flg,chr(13),''),chr(10),'') as move_flg
,idtfy_cmplt_dt

from ${iml_schema}.agt_loan_risk_cls_adj_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_risk_cls_adj_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
