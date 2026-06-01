: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_ghb_finc_prod_inpwn_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_ghb_finc_prod_inpwn_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.finc_prod_id as finc_prod_id
,t1.finc_prod_name as finc_prod_name
,t1.cap_stl_acct_num as cap_stl_acct_num
,t1.margin_acct_num as margin_acct_num
,t1.cap_avl_days as cap_avl_days
,t1.value_dt as value_dt
,t1.exp_dt as exp_dt
,t1.inpwn_lot as inpwn_lot
,t1.expe_yld_rat as expe_yld_rat
,t1.curr_cd as curr_cd
,t1.tot_lot as tot_lot
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.remark as remark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_ghb_finc_prod_inpwn_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_ghb_finc_prod_inpwn_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
