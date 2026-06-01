: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_loan_guar_cont_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_guar_cont_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.agt_id
,t1.lp_id
,t1.cont_flow_num
,t1.cont_type_cd
,t1.guar_type_cd
,t1.cont_status_cd
,t1.guar_cont_id
,t1.agt_sign_dt
,t1.cont_effect_dt
,t1.cont_exp_dt
,t1.cust_id
,t1.guartor_id
,t1.guartor_name
,t1.credt_org_id
,t1.credt_org_name
,t1.guar_curr_cd
,t1.guar_tot_amt
,t1.check_guar_tm
,t1.rgst_org_id
,t1.rgst_teller_id
,t1.rgst_dt
,t1.update_teller_id
,t1.modif_dt
,t1.guartor_cert_type_cd
,t1.guartor_cert_no
,t1.guar_guar_form_cd
,t1.margin_ratio
,t1.major_guar_way_cd
,t1.elec_cont_type
,t1.temp_store_flg
,t1.text_cont_id
,t1.guar_range_cd
,t1.guar_start_dt
,t1.guar_exp_dt
,t1.guar_type_cls_cd
,t1.ocup_guar_lmt_flg
,t1.guar_lmt_flow_num
,t1.matn_flg
,t1.resdnt_flg
,t1.gcust_flg
,t1.obg_id
,t1.obg_name
,t1.dir_hxb_guar_flg
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_loan_guar_cont t1 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_guar_cont_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes