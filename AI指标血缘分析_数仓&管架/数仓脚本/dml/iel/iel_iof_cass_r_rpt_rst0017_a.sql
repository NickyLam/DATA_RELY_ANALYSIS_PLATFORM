: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cass_r_rpt_rst0017_a
CreateDate: 20250305
FileName:   ${iel_data_path}/cass_r_rpt_rst0017.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="
select
	t1.etl_dt
	,etl_dt_ora
	,replace(replace(t1.acct_no,chr(13),''),chr(10),'') as acct_no
	,replace(replace(t1.dubil_no,chr(13),''),chr(10),'') as dubil_no
	,replace(replace(t1.cust_no,chr(13),''),chr(10),'') as cust_no
	,replace(replace(t1.accts_org_no,chr(13),''),chr(10),'') as accts_org_no
	,replace(replace(t1.manager_org,chr(13),''),chr(10),'') as manager_org
	,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
	,replace(replace(t1.corp_size_cd,chr(13),''),chr(10),'') as corp_size_cd
	,replace(replace(t1.bus_type,chr(13),''),chr(10),'') as bus_type
	,replace(replace(t1.std_prod_no,chr(13),''),chr(10),'') as std_prod_no
	,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
	,bal_avg_y
	,int_income_y
	,int_expns_y
	,int_adj_bal_y
	,invest_prft_y
	,evha_val_chag_y
	,fee_y
	,expense_y
	,asset_impair_loss_y
	,rwaamount_avg_y
	,ca_risk_y
	,coc_y
	,surttax_y
	,ftp_net_profit_y
	,income_tax_fee_y
	,eva_y
	,raroc
from ${iol_schema}.cass_r_rpt_rst0017 t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') 
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cass_r_rpt_rst0017.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
