: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_col_cont_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_col_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.cont_id as cont_id
,t1.cust_id as cust_id
,t1.rg_cd as rg_cd
,t1.org_id as org_id
,t1.enter_acct_org_id as enter_acct_org_id
,t1.cust_mgr_id as cust_mgr_id
,t1.crdt_breed_id as crdt_breed_id
,t1.loan_dir_indus_cd as loan_dir_indus_cd
,t1.guar_curr_cd as guar_curr_cd
,t1.cont_amt as cont_amt
,t1.cont_bal as cont_bal
,t1.margin_ratio as margin_ratio
,t1.margin_amt as margin_amt
,t1.effect_dt as effect_dt
,t1.exp_dt as exp_dt
,t1.guar_way_cd as guar_way_cd
,t1.main_guar_way_cd as main_guar_way_cd
,t1.setup_dt as setup_dt
,t1.chg_dt as chg_dt
,t1.distrd_amt as distrd_amt
,t1.level5_cls_cd as level5_cls_cd
,t1.off_bs_bal as off_bs_bal
,t1.in_bs_bal as in_bs_bal
,t1.over_int_amt as over_int_amt
,t1.payoff_status_cd as payoff_status_cd
,t1.loan_rating_cd as loan_rating_cd
,t1.reply_id as reply_id
,t1.strip_line_cd as strip_line_cd
,t1.crdt_cont_id as crdt_cont_id
,t1.crdt_appl_id as crdt_appl_id
,t1.paper_cont_id as paper_cont_id
,t1.data_src_cd as data_src_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_col_cont_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_col_cont_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
