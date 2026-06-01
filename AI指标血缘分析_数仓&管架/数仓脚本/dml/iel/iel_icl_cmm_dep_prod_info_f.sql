: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_dep_prod_info_f
CreateDate: 20231007
FileName:   ${iel_data_path}/cmm_dep_prod_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.intnal_prod_id,chr(13),''),chr(10),'') as intnal_prod_id
,replace(replace(t1.accting_id,chr(13),''),chr(10),'') as accting_id
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd
,replace(replace(t1.sell_obj_cd,chr(13),''),chr(10),'') as sell_obj_cd
,replace(replace(t1.dep_kind_cd,chr(13),''),chr(10),'') as dep_kind_cd
,replace(replace(t1.charge_evt_way_cd,chr(13),''),chr(10),'') as charge_evt_way_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.curr_type_cd,chr(13),''),chr(10),'') as curr_type_cd
,replace(replace(t1.prod_modal_tran_flg,chr(13),''),chr(10),'') as prod_modal_tran_flg
,replace(replace(t1.gl_sync_flg,chr(13),''),chr(10),'') as gl_sync_flg
,replace(replace(t1.precon_draw_flg,chr(13),''),chr(10),'') as precon_draw_flg
,replace(replace(t1.open_lmt_flg,chr(13),''),chr(10),'') as open_lmt_flg
,replace(replace(t1.rela_vouch_flg,chr(13),''),chr(10),'') as rela_vouch_flg
,replace(replace(t1.allow_zero_bal_flg,chr(13),''),chr(10),'') as allow_zero_bal_flg
,replace(replace(t1.redt_flg,chr(13),''),chr(10),'') as redt_flg
,replace(replace(t1.margin_dep_flg,chr(13),''),chr(10),'') as margin_dep_flg
,replace(replace(t1.allow_od_flg,chr(13),''),chr(10),'') as allow_od_flg
,replace(replace(t1.emply_prod_flg,chr(13),''),chr(10),'') as emply_prod_flg
,replace(replace(t1.deriv_prod_flg,chr(13),''),chr(10),'') as deriv_prod_flg
,replace(replace(t1.mpr_flg,chr(13),''),chr(10),'') as mpr_flg
,replace(replace(t1.allow_redem_flg,chr(13),''),chr(10),'') as allow_redem_flg
,replace(replace(t1.allow_tran_flg,chr(13),''),chr(10),'') as allow_tran_flg
,replace(replace(t1.allow_spec_col_int_flg,chr(13),''),chr(10),'') as allow_spec_col_int_flg
,replace(replace(t1.allow_inpwn_flg,chr(13),''),chr(10),'') as allow_inpwn_flg
,replace(replace(t1.renew_dep_way_cd,chr(13),''),chr(10),'') as renew_dep_way_cd
,replace(replace(t1.allow_multi_subscr_flg,chr(13),''),chr(10),'') as allow_multi_subscr_flg
,replace(replace(t1.unexp_draw_way_cd,chr(13),''),chr(10),'') as unexp_draw_way_cd
,replace(replace(t1.allow_tran_wdraw_flg,chr(13),''),chr(10),'') as allow_tran_wdraw_flg
,allow_wdraw_cnt
,allow_wdraw_max_amt
,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'') as base_rat_id
,replace(replace(t1.int_rat_file_type_cd,chr(13),''),chr(10),'') as int_rat_file_type_cd
,replace(replace(t1.pay_int_freq,chr(13),''),chr(10),'') as pay_int_freq
,spread_int_rat
,replace(replace(t1.matn_teller_id,chr(13),''),chr(10),'') as matn_teller_id
,replace(replace(t1.matn_org_id,chr(13),''),chr(10),'') as matn_org_id
,effect_dt
,invalid_dt
,value_dt
,exp_dt
,replace(replace(t1.stat_prod_subscr_lmt_flg,chr(13),''),chr(10),'') as stat_prod_subscr_lmt_flg
,replace(replace(t1.value_way_cd,chr(13),''),chr(10),'') as value_way_cd
,prod_issue_tot_uplmi
,prod_issue_tot_lolmi
,sell_begin_dt_tm
,sell_termnt_dt_tm
,base_rat
,int_rat_flo_val
,replace(replace(t1.apot_redem_dt,chr(13),''),chr(10),'') as apot_redem_dt
,replace(replace(t1.redem_int_rat_type,chr(13),''),chr(10),'') as redem_int_rat_type
,replace(replace(t1.supt_buy_way_cd,chr(13),''),chr(10),'') as supt_buy_way_cd
,init_amt
,incremt_amt
,min_retnd_amt
,replace(replace(t1.bus_mgmt_cls_cd,chr(13),''),chr(10),'') as bus_mgmt_cls_cd
,redem_int_rat
,replace(replace(t1.advd_draw_flg,chr(13),''),chr(10),'') as advd_draw_flg

from ${icl_schema}.cmm_dep_prod_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_dep_prod_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
