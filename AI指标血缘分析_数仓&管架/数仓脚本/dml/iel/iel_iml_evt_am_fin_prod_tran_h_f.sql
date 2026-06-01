: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_am_fin_prod_tran_h_f
CreateDate: 20240229
FileName:   ${iel_data_path}/evt_am_fin_prod_tran_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.fin_prod_id,chr(13),''),chr(10),'') as fin_prod_id
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd
,replace(replace(t1.brch_seq_num,chr(13),''),chr(10),'') as brch_seq_num
,tran_dt
,value_dt
,exp_dt
,dlvy_dt
,replace(replace(t1.clear_ped_cd,chr(13),''),chr(10),'') as clear_ped_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,nv_dt
,corp_net_price
,corp_int
,corp_full_price
,corp_fac_val
,net_price_tot
,tran_lot
,tran_pric
,int_tot
,full_price_tot
,tran_amt
,tot_tran_fee
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,exp_yld_rat
,ex_yld_rat
,replace(replace(t1.invest_aim_cd,chr(13),''),chr(10),'') as invest_aim_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.revo_flg,chr(13),''),chr(10),'') as revo_flg
,replace(replace(t1.init_tran_id,chr(13),''),chr(10),'') as init_tran_id
,replace(replace(t1.payoff_flg,chr(13),''),chr(10),'') as payoff_flg
,replace(replace(t1.tot_tran_id,chr(13),''),chr(10),'') as tot_tran_id
,replace(replace(t1.rev_tran_id,chr(13),''),chr(10),'') as rev_tran_id
,replace(replace(t1.front_tran_id,chr(13),''),chr(10),'') as front_tran_id
,replace(replace(t1.pass_id,chr(13),''),chr(10),'') as pass_id
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.ext_tran_flg,chr(13),''),chr(10),'') as ext_tran_flg
,replace(replace(t1.tran_site_cd,chr(13),''),chr(10),'') as tran_site_cd
,replace(replace(t1.tran_plat_cd,chr(13),''),chr(10),'') as tran_plat_cd
,replace(replace(t1.market_type_cd,chr(13),''),chr(10),'') as market_type_cd
,replace(replace(t1.dealer_name,chr(13),''),chr(10),'') as dealer_name
,replace(replace(t1.cntpty_dealer_name,chr(13),''),chr(10),'') as cntpty_dealer_name
,replace(replace(t1.secu_mgmt_acct_id,chr(13),''),chr(10),'') as secu_mgmt_acct_id
,replace(replace(t1.rela_sys_tran_id,chr(13),''),chr(10),'') as rela_sys_tran_id
,replace(replace(t1.cashflow_id,chr(13),''),chr(10),'') as cashflow_id
,replace(replace(t1.rgst_trust_org_cd,chr(13),''),chr(10),'') as rgst_trust_org_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.revo_comnt,chr(13),''),chr(10),'') as revo_comnt
,replace(replace(t1.creator_name,chr(13),''),chr(10),'') as creator_name
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_tm
,replace(replace(t1.updater_name,chr(13),''),chr(10),'') as updater_name
,update_tm
,replace(replace(t1.dlvy_type_cd,chr(13),''),chr(10),'') as dlvy_type_cd
,pay_dt
,replace(replace(t1.splt_bf_tran_id,chr(13),''),chr(10),'') as splt_bf_tran_id
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num

from ${iml_schema}.evt_am_fin_prod_tran_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_am_fin_prod_tran_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
