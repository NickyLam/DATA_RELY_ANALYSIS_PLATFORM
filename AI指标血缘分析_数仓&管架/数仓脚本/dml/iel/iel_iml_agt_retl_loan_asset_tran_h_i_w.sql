: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_retl_loan_asset_tran_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_asset_tran_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.bus_org_id,chr(13),''),chr(10),'') as bus_org_id
,replace(replace(t.asset_bag_id,chr(13),''),chr(10),'') as asset_bag_id
,replace(replace(t.asset_bag_name,chr(13),''),chr(10),'') as asset_bag_name
,replace(replace(t.init_prod_id,chr(13),''),chr(10),'') as init_prod_id
,replace(replace(t.init_prod_name,chr(13),''),chr(10),'') as init_prod_name
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t.init_bus_breed_cd,chr(13),''),chr(10),'') as init_bus_breed_cd
,replace(replace(t.bus_breed_cd,chr(13),''),chr(10),'') as bus_breed_cd
,t.pkg_dt as pkg_dt
,replace(replace(t.pkg_flow_num,chr(13),''),chr(10),'') as pkg_flow_num
,t.unpkg_dt as unpkg_dt
,replace(replace(t.unpkg_flow_num,chr(13),''),chr(10),'') as unpkg_flow_num
,t.post_pkg_tran_dt as post_pkg_tran_dt
,replace(replace(t.post_pkg_tran_flow_num,chr(13),''),chr(10),'') as post_pkg_tran_flow_num
,t.asset_tran_dt as asset_tran_dt
,replace(replace(t.asset_tran_flow_num,chr(13),''),chr(10),'') as asset_tran_flow_num
,t.cancel_asset_bag_dt as cancel_asset_bag_dt
,replace(replace(t.cancel_asset_bag_flow_num,chr(13),''),chr(10),'') as cancel_asset_bag_flow_num
,t.asset_end_dt as asset_end_dt
,replace(replace(t.asset_end_tran_flow_num,chr(13),''),chr(10),'') as asset_end_tran_flow_num
,t.redem_dt as redem_dt
,replace(replace(t.redem_tran_flow_num,chr(13),''),chr(10),'') as redem_tran_flow_num
,t.buy_dt as buy_dt
,replace(replace(t.buy_tran_flow_num,chr(13),''),chr(10),'') as buy_tran_flow_num
,replace(replace(t.asset_status_cd,chr(13),''),chr(10),'') as asset_status_cd
,t.pkg_pric_amt as pkg_pric_amt
,t.pkg_recvbl_acru_int as pkg_recvbl_acru_int
,t.pkg_coll_acru_int as pkg_coll_acru_int
,t.pkg_recvbl_over_int as pkg_recvbl_over_int
,t.pkg_coll_over_int as pkg_coll_over_int
,t.pkg_recvbl_acru_pnlt as pkg_recvbl_acru_pnlt
,t.pkg_coll_acru_pnlt as pkg_coll_acru_pnlt
,t.pkg_recvbl_pnlt as pkg_recvbl_pnlt
,t.pkg_coll_pnlt as pkg_coll_pnlt
,t.pkg_acru_comp_int as pkg_acru_comp_int
,t.pkg_comp_int as pkg_comp_int
,t.repaid_pric_tot as repaid_pric_tot
,t.repaid_recvbl_acru_int as repaid_recvbl_acru_int
,t.repaid_coll_acru_int as repaid_coll_acru_int
,t.repaid_recvbl_over_int as repaid_recvbl_over_int
,t.repaid_coll_over_int as repaid_coll_over_int
,t.repaid_recvbl_acru_pnlt as repaid_recvbl_acru_pnlt
,t.repaid_coll_acru_pnlt as repaid_coll_acru_pnlt
,t.repaid_recvbl_pnlt as repaid_recvbl_pnlt
,t.repaid_coll_pnlt as repaid_coll_pnlt
,t.repaid_acru_comp_int as repaid_acru_comp_int
,t.repaid_comp_int as repaid_comp_int
,t.ld_repaid_pric_tot as ld_repaid_pric_tot
,t.ld_repaid_recvbl_acru_int as ld_repaid_recvbl_acru_int
,t.ld_repaid_coll_acru_int as ld_repaid_coll_acru_int
,t.ld_repaid_recvbl_over_int as ld_repaid_recvbl_over_int
,t.ld_repaid_coll_over_int as ld_repaid_coll_over_int
,t.ld_repaid_recvbl_acru_pnlt as ld_repaid_recvbl_acru_pnlt
,t.ld_repaid_coll_acru_pnlt as ld_repaid_coll_acru_pnlt
,t.ld_repaid_recvbl_pnlt as ld_repaid_recvbl_pnlt
,t.ld_repaid_coll_pnlt as ld_repaid_coll_pnlt
,t.ld_repaid_acru_comp_int as ld_repaid_acru_comp_int
,t.ld_repaid_comp_int as ld_repaid_comp_int
,t.tran_amt as tran_amt
,t.redem_amt as redem_amt
,t.final_fin_tran_dt as final_fin_tran_dt
,replace(replace(t.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.agt_retl_loan_asset_tran_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_asset_tran_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes