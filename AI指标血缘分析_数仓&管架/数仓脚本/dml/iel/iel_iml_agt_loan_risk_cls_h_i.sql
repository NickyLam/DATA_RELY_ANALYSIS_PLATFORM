: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_risk_cls_h_i
CreateDate: 20221021
FileName:   ${iel_data_path}/agt_loan_risk_cls_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(agt_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(obj_type,chr(13),''),chr(10),'')
,replace(replace(flow_num,chr(13),''),chr(10),'')
,replace(replace(obj_id,chr(13),''),chr(10),'')
,replace(replace(fst_cls_rest_cd,chr(13),''),chr(10),'')
,replace(replace(secd_minor_cls_rest_cd,chr(13),''),chr(10),'')
,replace(replace(cust_mgr_idtfy_rest_cd,chr(13),''),chr(10),'')
,replace(replace(subrch_cls_idtfy_rest_cd,chr(13),''),chr(10),'')
,replace(replace(brch_risk_mgmt_idtfy_rest_cd,chr(13),''),chr(10),'')
,replace(replace(brch_led_idtfy_rest,chr(13),''),chr(10),'')
,replace(replace(final_cls_rest_cd,chr(13),''),chr(10),'')
,replace(replace(estim_teller_id,chr(13),''),chr(10),'')
,replace(replace(estim_org_id,chr(13),''),chr(10),'')
,cls_dt
,cls_cmplt_dt
,rgst_dt
,modif_dt
,cls_cont_bal
,replace(replace(rgst_org_id,chr(13),''),chr(10),'')
,replace(replace(rgst_teller_id,chr(13),''),chr(10),'')
,cls_closing_dt
,replace(replace(idtfy_lev_cd,chr(13),''),chr(10),'')
,replace(replace(last_cls_rest_cd,chr(13),''),chr(10),'')
,replace(replace(cust_id,chr(13),''),chr(10),'')
,replace(replace(cont_flow_num,chr(13),''),chr(10),'')
,replace(replace(status_cd,chr(13),''),chr(10),'')
,replace(replace(matn_flg,chr(13),''),chr(10),'')
,start_dt
,end_dt
,replace(replace(id_mark,chr(13),''),chr(10),'')

from ${iml_schema}.agt_loan_risk_cls_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_risk_cls_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
