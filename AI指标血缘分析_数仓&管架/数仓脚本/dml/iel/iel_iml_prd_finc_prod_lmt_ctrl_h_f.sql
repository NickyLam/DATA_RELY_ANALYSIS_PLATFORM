: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_finc_prod_lmt_ctrl_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_finc_prod_lmt_ctrl_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id
,replace(replace(t.finc_intnal_org_id,chr(13),''),chr(10),'') as finc_intnal_org_id
,t.tot_sell_lmt as tot_sell_lmt
,t.indv_cust_lmt as indv_cust_lmt
,t.selled_indv_lmt as selled_indv_lmt
,t.asigned_indv_lmt as asigned_indv_lmt
,t.org_cust_lmt as org_cust_lmt
,t.selled_org_lmt as selled_org_lmt
,t.asigned_org_lmt as asigned_org_lmt
,t.flexb_lmt as flexb_lmt
,t.selled_indv_flexb_lmt as selled_indv_flexb_lmt
,t.selled_org_flexb_lmt as selled_org_flexb_lmt
,t.asigned_flexb_lmt as asigned_flexb_lmt
,t.precon_lmt_uplmi as precon_lmt_uplmi
,t.accu_precon_lmt as accu_precon_lmt
,t.precon_buyed_lmt as precon_buyed_lmt
,t.resv_lmt as resv_lmt
,t.asigned_resv_lmt as asigned_resv_lmt
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.prd_finc_prod_lmt_ctrl_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_finc_prod_lmt_ctrl_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes