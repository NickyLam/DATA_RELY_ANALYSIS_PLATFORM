: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_risk_cls_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_risk_cls_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.obj_type,chr(13),''),chr(10),'') as obj_type
,replace(replace(t.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t.fst_cls_rest_cd,chr(13),''),chr(10),'') as fst_cls_rest_cd
,replace(replace(t.secd_minor_cls_rest_cd,chr(13),''),chr(10),'') as secd_minor_cls_rest_cd
,replace(replace(t.cust_mgr_idtfy_rest_cd,chr(13),''),chr(10),'') as cust_mgr_idtfy_rest_cd
,replace(replace(t.subrch_cls_idtfy_rest_cd,chr(13),''),chr(10),'') as subrch_cls_idtfy_rest_cd
,replace(replace(t.brch_risk_mgmt_idtfy_rest_cd,chr(13),''),chr(10),'') as brch_risk_mgmt_idtfy_rest_cd
,replace(replace(t.brch_led_idtfy_rest,chr(13),''),chr(10),'') as brch_led_idtfy_rest
,replace(replace(t.final_cls_rest_cd,chr(13),''),chr(10),'') as final_cls_rest_cd
,replace(replace(t.estim_teller_id,chr(13),''),chr(10),'') as estim_teller_id
,replace(replace(t.estim_org_id,chr(13),''),chr(10),'') as estim_org_id
,t.cls_dt as cls_dt
,t.cls_cmplt_dt as cls_cmplt_dt
,t.rgst_dt as rgst_dt
,t.modif_dt as modif_dt
,t.cls_cont_bal as cls_cont_bal
,replace(replace(t.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,replace(replace(t.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,t.cls_closing_dt as cls_closing_dt
,replace(replace(t.idtfy_lev_cd,chr(13),''),chr(10),'') as idtfy_lev_cd
,replace(replace(t.last_cls_rest_cd,chr(13),''),chr(10),'') as last_cls_rest_cd
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.cont_flow_num,chr(13),''),chr(10),'') as cont_flow_num
,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t.matn_flg,chr(13),''),chr(10),'') as matn_flg
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_loan_risk_cls_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_risk_cls_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes