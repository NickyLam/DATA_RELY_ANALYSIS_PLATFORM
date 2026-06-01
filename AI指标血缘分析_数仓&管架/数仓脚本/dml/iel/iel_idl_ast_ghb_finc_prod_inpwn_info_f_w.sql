: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_ghb_finc_prod_inpwn_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_ghb_finc_prod_inpwn_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.finc_prod_id as finc_prod_id
,t.finc_prod_name as finc_prod_name
,t.cap_stl_acct_num as cap_stl_acct_num
,t.margin_acct_num as margin_acct_num
,t.cap_avl_days as cap_avl_days
,t.value_dt as value_dt
,t.exp_dt as exp_dt
,t.inpwn_lot as inpwn_lot
,t.expe_yld_rat as expe_yld_rat
,t.curr_cd as curr_cd
,t.tot_lot as tot_lot
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_ghb_finc_prod_inpwn_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_ghb_finc_prod_inpwn_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes