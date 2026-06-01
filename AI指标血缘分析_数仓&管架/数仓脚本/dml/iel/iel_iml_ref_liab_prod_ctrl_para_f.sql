: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_liab_prod_ctrl_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_liab_prod_ctrl_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.para_id,chr(13),''),chr(10),'') as para_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.para_kind_code,chr(13),''),chr(10),'') as para_kind_code
,replace(replace(t.para_descb,chr(13),''),chr(10),'') as para_descb
,replace(replace(t.prod_attr_1,chr(13),''),chr(10),'') as prod_attr_1
,replace(replace(t.prod_attr_2,chr(13),''),chr(10),'') as prod_attr_2
,t.mod_para_1 as mod_para_1
,t.mod_para_2 as mod_para_2
,t.prod_issue_tot_uplmi as prod_issue_tot_uplmi
,t.prod_issue_tot_lolmi as prod_issue_tot_lolmi
,t.sell_begin_dt as sell_begin_dt
,t.sell_termnt_dt as sell_termnt_dt
,t.value_dt as value_dt
,t.exp_dt as exp_dt
,replace(replace(t.matn_teller_id,chr(13),''),chr(10),'') as matn_teller_id
,replace(replace(t.matn_org_id,chr(13),''),chr(10),'') as matn_org_id
,replace(replace(t.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,t.create_dt as create_dt
,t.update_dt as update_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.ref_liab_prod_ctrl_para t
where t.create_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_liab_prod_ctrl_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes