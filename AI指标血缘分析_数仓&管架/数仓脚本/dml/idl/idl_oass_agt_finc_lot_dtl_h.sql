/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_finc_lot_dtl_h
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
alter table ${idl_schema}.oass_agt_finc_lot_dtl_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_finc_lot_dtl_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_finc_lot_dtl_h (
etl_dt  --数据日期
,seller_id  --销售商编号
,prod_id  --产品编号
,ta_cfm_flow_num  --TA确认流水号
,finc_cust_id  --理财客户编号
,cust_id  --客户编号
,ta_tran_acct_id  --TA交易账户编号
,ec_idf_cd  --钞汇标识代码
,ta_cd  --TA代码
,finc_acct_id  --理财账户编号
,appl_flow_num  --申请流水号
,cfm_dt  --确认日期
,lot_src_cd  --份额来源代码
,lot_tot  --份额总数
,divd_way_cd  --分红方式代码
,init_divd_way_cd  --原分红方式代码
,belong_org_id  --所属机构编号
,cust_type_cd  --客户类型代码
,unpaid_prft  --未付收益
,froz_unpaid_prft  --冻结未付收益
,new_assign_prft  --新分配收益
,init_cfm_amt  --原确认金额
,init_cfm_lot  --原确认份额
,init_corp_nv  --原单位净值
,init_lot_src_cd  --原份额来源代码
,tran_chn_cd  --交易渠道代码
,cust_grouping_cd  --客户分组代码
,bank_acct_id  --银行账户编号
,tran_med_type_cd  --交易介质类型代码
,tran_med_id  --交易介质编号
,cont_id  --合约编号
,buy_cost  --买入成本
,ped_finc_exp_dt  --周期性理财到期日期
,ped_finc_flg  --周期性理财标志
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,agt_id  --协议编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.seller_id,chr(13),''),chr(10),'') as seller_id --销售商编号
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id --产品编号
,replace(replace(t1.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num --TA确认流水号
,replace(replace(t1.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id --理财客户编号
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id --TA交易账户编号
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd --钞汇标识代码
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd --TA代码
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id --理财账户编号
,replace(replace(t1.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num --申请流水号
,t1.cfm_dt as cfm_dt --确认日期
,replace(replace(t1.lot_src_cd,chr(13),''),chr(10),'') as lot_src_cd --份额来源代码
,t1.lot_tot as lot_tot --份额总数
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd --分红方式代码
,replace(replace(t1.init_divd_way_cd,chr(13),''),chr(10),'') as init_divd_way_cd --原分红方式代码
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id --所属机构编号
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd --客户类型代码
,t1.unpaid_prft as unpaid_prft --未付收益
,t1.froz_unpaid_prft as froz_unpaid_prft --冻结未付收益
,t1.new_assign_prft as new_assign_prft --新分配收益
,t1.init_cfm_amt as init_cfm_amt --原确认金额
,t1.init_cfm_lot as init_cfm_lot --原确认份额
,t1.init_corp_nv as init_corp_nv --原单位净值
,replace(replace(t1.init_lot_src_cd,chr(13),''),chr(10),'') as init_lot_src_cd --原份额来源代码
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd --交易渠道代码
,replace(replace(t1.cust_grouping_cd,chr(13),''),chr(10),'') as cust_grouping_cd --客户分组代码
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id --银行账户编号
,replace(replace(t1.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd --交易介质类型代码
,replace(replace(t1.tran_med_id,chr(13),''),chr(10),'') as tran_med_id --交易介质编号
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id --合约编号
,t1.buy_cost as buy_cost --买入成本
,t1.ped_finc_exp_dt as ped_finc_exp_dt --周期性理财到期日期
,replace(replace(t1.ped_finc_flg,chr(13),''),chr(10),'') as ped_finc_flg --周期性理财标志
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id --协议编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.agt_finc_lot_dtl_h t1    --理财份额明细历史
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_finc_lot_dtl_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
