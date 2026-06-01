/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_ast_col_list_stock_inpwn_info
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_ast_col_list_stock_inpwn_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_ast_col_list_stock_inpwn_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_ast_col_list_stock_inpwn_info (
etl_dt  --数据日期
,stock_cd  --股票代码
,stock_name  --股票名称
,corp_name  --公司名称
,issuer_brwer_flg  --发行人为借款人标志
,corp_prev_year_margin  --公司上年度利润
,stock_nomal_flg  --股票正常标志
,stock_status_cd  --股票状态代码
,tran_site_cd  --交易场所代码
,public_tran_flg  --公开交易标志
,hold_shares_qtty  --持股数量
,inpwn_stock_qtty  --质押股权数量
,mk_pri  --市价
,last_year_share_divd_amt  --上年每股分红金额
,warning_line  --警戒线
,per_share_net_asset  --每股净资产
,close_pos_line  --平仓线
,inpwn_tot_val  --质押总价值
,restr_exp_dt  --限售到期日期
,other_comnt  --其他说明
,curr_cd  --币种代码
,trust_broker_name  --托管券商名称
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,asset_id  --资产编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.stock_cd,chr(13),''),chr(10),'') as stock_cd --股票代码
,replace(replace(t1.stock_name,chr(13),''),chr(10),'') as stock_name --股票名称
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name --公司名称
,replace(replace(t1.issuer_brwer_flg,chr(13),''),chr(10),'') as issuer_brwer_flg --发行人为借款人标志
,t1.corp_prev_year_margin as corp_prev_year_margin --公司上年度利润
,replace(replace(t1.stock_nomal_flg,chr(13),''),chr(10),'') as stock_nomal_flg --股票正常标志
,replace(replace(t1.stock_status_cd,chr(13),''),chr(10),'') as stock_status_cd --股票状态代码
,replace(replace(t1.tran_site_cd,chr(13),''),chr(10),'') as tran_site_cd --交易场所代码
,replace(replace(t1.public_tran_flg,chr(13),''),chr(10),'') as public_tran_flg --公开交易标志
,t1.hold_shares_qtty as hold_shares_qtty --持股数量
,t1.inpwn_stock_qtty as inpwn_stock_qtty --质押股权数量
,t1.mk_pri as mk_pri --市价
,t1.last_year_share_divd_amt as last_year_share_divd_amt --上年每股分红金额
,t1.warning_line as warning_line --警戒线
,t1.per_share_net_asset as per_share_net_asset --每股净资产
,t1.close_pos_line as close_pos_line --平仓线
,t1.inpwn_tot_val as inpwn_tot_val --质押总价值
,t1.restr_exp_dt as restr_exp_dt --限售到期日期
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt --其他说明
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd --币种代码
,replace(replace(t1.trust_broker_name,chr(13),''),chr(10),'') as trust_broker_name --托管券商名称
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id --资产编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.ast_col_list_stock_inpwn_info t1    --押品上市公司股权质押信息
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_ast_col_list_stock_inpwn_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
