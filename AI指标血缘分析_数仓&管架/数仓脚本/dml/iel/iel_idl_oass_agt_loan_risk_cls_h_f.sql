: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_risk_cls_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_loan_risk_cls_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.agt_id as agt_id
,t1.obj_id as obj_id
,t1.obj_type_name as obj_type_name
,t1.cust_id as cust_id
,t1.cust_name as cust_name
,t1.prod_id as prod_id
,t1.curr_cd as curr_cd
,t1.loan_amt as loan_amt
,t1.loan_bal as loan_bal
,t1.loan_tenor_cd as loan_tenor_cd
,t1.cls_closing_dt as cls_closing_dt
,t1.sys_cls_rest_cd as sys_cls_rest_cd
,t1.manu_cls_rest_cd as manu_cls_rest_cd
,t1.manu_cls_reason_descb as manu_cls_reason_descb
,t1.final_rest_cd as final_rest_cd
,t1.cls_way_cd as cls_way_cd
,t1.belong_strip_line_cd as belong_strip_line_cd
,t1.cls_status_cd as cls_status_cd
,t1.low_risk_flg as low_risk_flg
,t1.curr_mon_happ_flg as curr_mon_happ_flg
,t1.remark as remark
,t1.oper_teller_id as oper_teller_id
,t1.oper_org_id as oper_org_id
,t1.oper_dt as oper_dt
,t1.update_teller_id as update_teller_id
,t1.update_org_id as update_org_id
,t1.modif_dt as modif_dt
,t1.cmplt_dt as cmplt_dt
,t1.lp_id as lp_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.risk_cls_id as risk_cls_id
,t1.rela_flow_num as rela_flow_num

from ${idl_schema}.oass_agt_loan_risk_cls_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_risk_cls_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
