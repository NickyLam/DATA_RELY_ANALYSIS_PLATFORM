/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_agt_bill_discnt_batch
CreateDate: 20221108
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_agt_bill_discnt_batch drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_agt_bill_discnt_batch add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_agt_bill_discnt_batch (
etl_dt  --ETL处理日期
,batch_id  --批次编号
,lp_id  --法人编号
,org_id  --机构编号
,enter_acct_org_id  --入账机构编号
,buy_prod_cd  --买入产品代码
,buy_type_cd  --买入类型代码
,discnt_bus_type_cd  --贴现业务类型代码
,bus_id  --业务编号
,bill_type_cd  --票据类型代码
,bill_med_cd  --票据介质代码
,cust_id  --客户编号
,cust_name  --客户名称
,cust_open_bank_no  --客户开户行行号
,cust_open_acct_num  --客户开户账号
,int_rat  --利率
,int_rat_type_cd  --利率类型代码
,redem_int_rat  --赎回利率
,redem_int_rat_type_cd  --赎回利率类型代码
,buy_dt  --买入日期
,onl_clear_flg  --线上清算标志
,redem_open_dt  --赎回开放日期
,redem_closing_dt  --赎回截止日期
,sys_in_flg  --系统内标志
,pay_int_way_cd  --付息方式代码
,int_payer_name  --付息人名称
,int_payer_acct_num  --付息人账号
,pay_int_ratio  --付息比例
,agent_name  --代理名称
,cust_mgr_id  --客户经理编号
,dept_id  --部门编号
,discnt_bf_revw_flg  --先贴后查标志
,cont_matrl_backup_flg  --合同资料后补标志
,backup_closing_dt  --后补截止日期
,operr_id  --操作员编号
,tran_dt  --交易日期
,bus_logic_check_status_cd  --业务逻辑检查状态代码
,crdt_check_status_cd  --授信检查状态代码
,check_status_cd  --审核状态代码
,int_accr_check_status_cd  --计息复核状态代码
,entry_status_cd  --记账状态代码
,intnal_stl_flg  --内部结算标志
,intnal_stl_acct  --内部结算账户
,agt_exp_dt  --协议到期日期
,crdt_valid_amt  --信贷有效金额
,apprved_use_crdt_open_amt  --已批准使用授信敞口金额
,distr_post_acm_use_open_amt  --本次放款后累计使用敞口金额
,cert_type_cd  --证件类型代码
,cert_no  --证件号码
,asset_thd_cls_cd  --资产三分类代码
,rela_party_que_rest_cd  --关联方查询结果代码
,crdt_cont_used_amt  --信贷合同已用金额
,crdt_cont_tot_amt  --信贷合同总金额
,lmt_cont_used_tot_amt  --额度合同已用总金额
,midgrod_bus_flow_num  --中台业务流水号
,int_calc_defer_way_cd  --利息计算顺延方式代码
,tgls_entry_status_cd  --核算中台记账状态代码
,ncbs_entry_status_cd  --核心记账状态代码
,h_data_flg  --历史数据标志
,create_dt  --创建日期
,update_dt  --更新日期
,id_mark  --增删标志

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --ETL处理日期
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id --批次编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id --机构编号
,replace(replace(t1.enter_acct_org_id,chr(13),''),chr(10),'') as enter_acct_org_id --入账机构编号
,replace(replace(t1.buy_prod_cd,chr(13),''),chr(10),'') as buy_prod_cd --买入产品代码
,replace(replace(t1.buy_type_cd,chr(13),''),chr(10),'') as buy_type_cd --买入类型代码
,replace(replace(t1.discnt_bus_type_cd,chr(13),''),chr(10),'') as discnt_bus_type_cd --贴现业务类型代码
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id --业务编号
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd --票据类型代码
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd --票据介质代码
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id --客户编号
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name --客户名称
,replace(replace(t1.cust_open_bank_no,chr(13),''),chr(10),'') as cust_open_bank_no --客户开户行行号
,replace(replace(t1.cust_open_acct_num,chr(13),''),chr(10),'') as cust_open_acct_num --客户开户账号
,t1.int_rat as int_rat --利率
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd --利率类型代码
,t1.redem_int_rat as redem_int_rat --赎回利率
,replace(replace(t1.redem_int_rat_type_cd,chr(13),''),chr(10),'') as redem_int_rat_type_cd --赎回利率类型代码
,t1.buy_dt as buy_dt --买入日期
,replace(replace(t1.onl_clear_flg,chr(13),''),chr(10),'') as onl_clear_flg --线上清算标志
,t1.redem_open_dt as redem_open_dt --赎回开放日期
,t1.redem_closing_dt as redem_closing_dt --赎回截止日期
,replace(replace(t1.sys_in_flg,chr(13),''),chr(10),'') as sys_in_flg --系统内标志
,replace(replace(t1.pay_int_way_cd,chr(13),''),chr(10),'') as pay_int_way_cd --付息方式代码
,replace(replace(t1.int_payer_name,chr(13),''),chr(10),'') as int_payer_name --付息人名称
,replace(replace(t1.int_payer_acct_num,chr(13),''),chr(10),'') as int_payer_acct_num --付息人账号
,t1.pay_int_ratio as pay_int_ratio --付息比例
,replace(replace(t1.agent_name,chr(13),''),chr(10),'') as agent_name --代理名称
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id --客户经理编号
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id --部门编号
,replace(replace(t1.discnt_bf_revw_flg,chr(13),''),chr(10),'') as discnt_bf_revw_flg --先贴后查标志
,replace(replace(t1.cont_matrl_backup_flg,chr(13),''),chr(10),'') as cont_matrl_backup_flg --合同资料后补标志
,t1.backup_closing_dt as backup_closing_dt --后补截止日期
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id --操作员编号
,t1.tran_dt as tran_dt --交易日期
,replace(replace(t1.bus_logic_check_status_cd,chr(13),''),chr(10),'') as bus_logic_check_status_cd --业务逻辑检查状态代码
,replace(replace(t1.crdt_check_status_cd,chr(13),''),chr(10),'') as crdt_check_status_cd --授信检查状态代码
,replace(replace(t1.check_status_cd,chr(13),''),chr(10),'') as check_status_cd --审核状态代码
,replace(replace(t1.int_accr_check_status_cd,chr(13),''),chr(10),'') as int_accr_check_status_cd --计息复核状态代码
,replace(replace(t1.entry_status_cd,chr(13),''),chr(10),'') as entry_status_cd --记账状态代码
,replace(replace(t1.intnal_stl_flg,chr(13),''),chr(10),'') as intnal_stl_flg --内部结算标志
,replace(replace(t1.intnal_stl_acct,chr(13),''),chr(10),'') as intnal_stl_acct --内部结算账户
,t1.agt_exp_dt as agt_exp_dt --协议到期日期
,t1.crdt_valid_amt as crdt_valid_amt --信贷有效金额
,t1.apprved_use_crdt_open_amt as apprved_use_crdt_open_amt --已批准使用授信敞口金额
,t1.distr_post_acm_use_open_amt as distr_post_acm_use_open_amt --本次放款后累计使用敞口金额
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd --证件类型代码
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no --证件号码
,replace(replace(t1.asset_thd_cls_cd,chr(13),''),chr(10),'') as asset_thd_cls_cd --资产三分类代码
,replace(replace(t1.rela_party_que_rest_cd,chr(13),''),chr(10),'') as rela_party_que_rest_cd --关联方查询结果代码
,t1.crdt_cont_used_amt as crdt_cont_used_amt --信贷合同已用金额
,t1.crdt_cont_tot_amt as crdt_cont_tot_amt --信贷合同总金额
,t1.lmt_cont_used_tot_amt as lmt_cont_used_tot_amt --额度合同已用总金额
,replace(replace(t1.midgrod_bus_flow_num,chr(13),''),chr(10),'') as midgrod_bus_flow_num --中台业务流水号
,replace(replace(t1.int_calc_defer_way_cd,chr(13),''),chr(10),'') as int_calc_defer_way_cd --利息计算顺延方式代码
,replace(replace(t1.tgls_entry_status_cd,chr(13),''),chr(10),'') as tgls_entry_status_cd --核算中台记账状态代码
,replace(replace(t1.ncbs_entry_status_cd,chr(13),''),chr(10),'') as ncbs_entry_status_cd --核心记账状态代码
,replace(replace(t1.h_data_flg,chr(13),''),chr(10),'') as h_data_flg --历史数据标志
,t1.create_dt as create_dt --创建日期
,t1.update_dt as update_dt --更新日期
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
from ${iml_schema}.agt_bill_discnt_batch t1    --票据贴现批次
where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_agt_bill_discnt_batch',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
