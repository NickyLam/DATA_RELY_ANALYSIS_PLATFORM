: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_col_cont_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_col_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'') as enter_acct_org_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.crdt_breed_id,chr(13),''),chr(10),'') as crdt_breed_id
,replace(replace(t1.loan_dir_indus_cd,chr(13),''),chr(10),'') as loan_dir_indus_cd
,replace(replace(t1.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd
,t1.cont_amt as cont_amt
,t1.cont_bal as cont_bal
,t1.margin_ratio as margin_ratio
,t1.margin_amt as margin_amt
,t1.effect_dt as effect_dt
,t1.exp_dt as exp_dt
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,replace(replace(t1.main_guar_way_cd,chr(13),''),chr(10),'') as main_guar_way_cd
,t1.setup_dt as setup_dt
,t1.chg_dt as chg_dt
,t1.distrd_amt as distrd_amt
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd
,t1.off_bs_bal as off_bs_bal
,t1.in_bs_bal as in_bs_bal
,t1.over_int_amt as over_int_amt
,replace(replace(t1.payoff_status_cd,chr(13),''),chr(10),'') as payoff_status_cd
,replace(replace(t1.loan_rating_cd,chr(13),''),chr(10),'') as loan_rating_cd
,replace(replace(t1.reply_id,chr(13),''),chr(10),'') as reply_id
,replace(replace(t1.strip_line_cd,chr(13),''),chr(10),'') as strip_line_cd
,replace(replace(t1.crdt_cont_id,chr(13),''),chr(10),'') as crdt_cont_id
,replace(replace(t1.crdt_appl_id,chr(13),''),chr(10),'') as crdt_appl_id
,replace(replace(t1.paper_cont_id,chr(13),''),chr(10),'') as paper_cont_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_col_cont_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_col_cont_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes