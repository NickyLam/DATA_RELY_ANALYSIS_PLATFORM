: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ref_dep_pd_def_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_dep_pd_def_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pd_cd,chr(13),''),chr(10),'') as pd_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.pd_descb,chr(13),''),chr(10),'') as pd_descb
,replace(replace(t1.cds_issue_year,chr(13),''),chr(10),'') as cds_issue_year
,t1.cds_issue_begin_dt as cds_issue_begin_dt
,t1.issue_termnt_dt as issue_termnt_dt
,t1.precon_start_tm as precon_start_tm
,t1.precon_end_tm as precon_end_tm
,t1.start_sell_tm as start_sell_tm
,t1.end_sell_tm as end_sell_tm
,replace(replace(t1.pd_prod_cate_cd,chr(13),''),chr(10),'') as pd_prod_cate_cd
,replace(replace(t1.lmt_deduct_type_cd,chr(13),''),chr(10),'') as lmt_deduct_type_cd
,replace(replace(t1.pd_dtl_remark,chr(13),''),chr(10),'') as pd_dtl_remark
,replace(replace(t1.pd_status_cd,chr(13),''),chr(10),'') as pd_status_cd
,replace(replace(t1.sell_way_cd,chr(13),''),chr(10),'') as sell_way_cd
,replace(replace(t1.assign_lmt_type_cd,chr(13),''),chr(10),'') as assign_lmt_type_cd
,t1.tot_lmt_lmt as tot_lmt_lmt
,t1.cds_surp_lmt as cds_surp_lmt
,t1.asigned_lmt as asigned_lmt
,t1.cds_occu_lmt as cds_occu_lmt
,replace(replace(t1.lmt_callbk_status_cd,chr(13),''),chr(10),'') as lmt_callbk_status_cd
,replace(replace(t1.ration_way_cd,chr(13),''),chr(10),'') as ration_way_cd
,replace(replace(t1.tran_acct_flg,chr(13),''),chr(10),'') as tran_acct_flg
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.dep_tenor as dep_tenor
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.int_rat_reset_freq_cd,chr(13),''),chr(10),'') as int_rat_reset_freq_cd
,t1.max_buy_amt as max_buy_amt
,t1.init_amt as init_amt
,replace(replace(t1.get_int_freq_cd,chr(13),''),chr(10),'') as get_int_freq_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,replace(replace(t1.cds_pay_int_way,chr(13),''),chr(10),'') as cds_pay_int_way
,replace(replace(t1.allow_unexp_draw_flg,chr(13),''),chr(10),'') as allow_unexp_draw_flg
,t1.pa_ext_cnt as pa_ext_cnt
,replace(replace(t1.redembl_flg,chr(13),''),chr(10),'') as redembl_flg
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.auto_payoff_flg,chr(13),''),chr(10),'') as auto_payoff_flg
,replace(replace(t1.white_list_sale_flg,chr(13),''),chr(10),'') as white_list_sale_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ref_dep_pd_def_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_dep_pd_def_para.f.${batch_date}.dat" \
        charset=utf8
        safe=yes