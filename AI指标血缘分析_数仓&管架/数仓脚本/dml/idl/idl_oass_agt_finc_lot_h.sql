/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_finc_lot_h
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
alter table ${idl_schema}.oass_agt_finc_lot_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_finc_lot_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_finc_lot_h (
etl_dt  --数据日期
,intnal_cust_id  --内部客户编号
,seller_cd  --销售商代码
,bank_id  --银行编号
,bank_cust_id  --银行客户编号
,bank_acct_id  --银行账户编号
,ta_tran_acct_id  --TA交易账户编号
,ec_flg  --钞汇标志
,tran_med_type_cd  --交易介质类型代码
,tran_med  --交易介质
,ta_cd  --TA代码
,finc_acct_id  --理财账户编号
,prod_id  --产品编号
,std_prod_id  --标准产品编号
,cont_id  --合约编号
,final_tran_dt  --最后交易日期
,lot_tot  --份额总数
,froz_lot  --冻结份额
,lonterm_froz_lot  --长期冻结份额
,deflt_divd_way_cd  --默认分红方式代码
,init_divd_way_cd  --原分红方式代码
,tran_belong_org_id  --交易所属机构编号
,supp_invest_flg  --追加投资标志
,buy_cost_amt  --买入成本金额
,acm_inco_amt  --累计收入金额
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,comb_invest_lot  --组合投资份额
,loc_froz_lot  --本地冻结份额
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id --内部客户编号
,replace(replace(t1.seller_cd,chr(13),''),chr(10),'') as seller_cd --销售商代码
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id --银行编号
,replace(replace(t1.bank_cust_id,chr(13),''),chr(10),'') as bank_cust_id --银行客户编号
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id --银行账户编号
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id --TA交易账户编号
,replace(replace(t1.ec_flg,chr(13),''),chr(10),'') as ec_flg --钞汇标志
,replace(replace(t1.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd --交易介质类型代码
,replace(replace(t1.tran_med,chr(13),''),chr(10),'') as tran_med --交易介质
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd --TA代码
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id --理财账户编号
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id --标准产品编号
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id --合约编号
,t1.final_tran_dt as final_tran_dt --最后交易日期
,t1.lot_tot as lot_tot --份额总数
,t1.froz_lot as froz_lot --冻结份额
,t1.lonterm_froz_lot as lonterm_froz_lot --长期冻结份额
,replace(replace(t1.deflt_divd_way_cd,chr(13),''),chr(10),'') as deflt_divd_way_cd --默认分红方式代码
,replace(replace(t1.init_divd_way_cd,chr(13),''),chr(10),'') as init_divd_way_cd --原分红方式代码
,replace(replace(t1.tran_belong_org_id,chr(13),''),chr(10),'') as tran_belong_org_id --交易所属机构编号
,replace(replace(t1.supp_invest_flg,chr(13),''),chr(10),'') as supp_invest_flg --追加投资标志
,t1.buy_cost_amt as buy_cost_amt --买入成本金额
,t1.acm_inco_amt as acm_inco_amt --累计收入金额
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,t1.comb_invest_lot as comb_invest_lot --组合投资份额
,t1.loc_froz_lot as loc_froz_lot --本地冻结份额
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_finc_lot_h t1    --理财份额历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_finc_lot_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
