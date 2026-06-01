: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_prd_liab_prod_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_liab_prod_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.lp_id
,t.prod_id
,t.src_prod_id
,t.prod_descb
,t.prod_intnal_id
,t.prod_effect_dt
,t.prod_invalid_dt
,t.prod_cate_cd
,t.prod_belong_obj_cd
,t.prod_cls_cd_2
,t.prod_cls_cd_5
,t.dep_kind_cd
,t.accting_type_cd
,t.prod_modal_tran_flg
,t.check_entry_flg
,t.acct_vrfction_flg
,t.bal_gl_sync_flg
,t.auto_precon_draw_flg
,t.open_acct_lmt_flg
,t.open_acct_rela_flg
,t.zero_bal_flg
,t.redt_flg
,t.margin_dep_flg
,t.cfm_open_acct_exp_day_flg
,t.od_flg
,t.org_ctrl_flg
,t.emply_prod_flg
,t.deriv_prod_flg
,t.prod_charge_evt_way_cd
,t.prod_status_cd
,t.curr_type_cd
,t.spec_acct_num_rule_flg
,t.matn_teller_id
,t.matn_org_id
,t.matn_dt
,t.matn_tm
,t.tm_stamp
,t.rec_status_cd
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.prd_liab_prod_info t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_liab_prod_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes