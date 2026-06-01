: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_col_cont_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_col_cont_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.cont_id as cont_id
,t.cust_id as cust_id
,t.rg_cd as rg_cd
,t.org_id as org_id
,t.enter_acct_org_id as enter_acct_org_id
,t.cust_mgr_id as cust_mgr_id
,t.crdt_breed_id as crdt_breed_id
,t.loan_dir_indus_cd as loan_dir_indus_cd
,t.guar_curr_cd as guar_curr_cd
,t.cont_amt as cont_amt
,t.cont_bal as cont_bal
,t.margin_ratio as margin_ratio
,t.margin_amt as margin_amt
,t.effect_dt as effect_dt
,t.exp_dt as exp_dt
,t.guar_way_cd as guar_way_cd
,t.main_guar_way_cd as main_guar_way_cd
,t.setup_dt as setup_dt
,t.chg_dt as chg_dt
,t.distrd_amt as distrd_amt
,t.level5_cls_cd as level5_cls_cd
,t.off_bs_bal as off_bs_bal
,t.in_bs_bal as in_bs_bal
,t.over_int_amt as over_int_amt
,t.payoff_status_cd as payoff_status_cd
,t.loan_rating_cd as loan_rating_cd
,t.reply_id as reply_id
,t.strip_line_cd as strip_line_cd
,t.crdt_cont_id as crdt_cont_id
,t.crdt_appl_id as crdt_appl_id
,t.paper_cont_id as paper_cont_id
,t.data_src_cd as data_src_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_col_cont_info t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_col_cont_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes