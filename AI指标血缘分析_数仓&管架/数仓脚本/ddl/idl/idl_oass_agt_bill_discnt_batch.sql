/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_bill_discnt_batch
CreateDate: 20221108
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_bill_discnt_batch purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_bill_discnt_batch(
etl_dt date --ETL处理日期
,batch_id varchar2(60) --批次编号
,lp_id varchar2(60) --法人编号
,org_id varchar2(60) --机构编号
,enter_acct_org_id varchar2(60) --入账机构编号
,buy_prod_cd varchar2(10) --买入产品代码
,buy_type_cd varchar2(10) --买入类型代码
,discnt_bus_type_cd varchar2(10) --贴现业务类型代码
,bus_id varchar2(60) --业务编号
,bill_type_cd varchar2(10) --票据类型代码
,bill_med_cd varchar2(10) --票据介质代码
,cust_id varchar2(60) --客户编号
,cust_name varchar2(250) --客户名称
,cust_open_bank_no varchar2(60) --客户开户行行号
,cust_open_acct_num varchar2(100) --客户开户账号
,int_rat number(18,8) --利率
,int_rat_type_cd varchar2(10) --利率类型代码
,redem_int_rat number(18,8) --赎回利率
,redem_int_rat_type_cd varchar2(10) --赎回利率类型代码
,buy_dt date --买入日期
,onl_clear_flg varchar2(10) --线上清算标志
,redem_open_dt date --赎回开放日期
,redem_closing_dt date --赎回截止日期
,sys_in_flg varchar2(10) --系统外标志
,pay_int_way_cd varchar2(10) --付息方式代码
,int_payer_name varchar2(250) --付息人名称
,int_payer_acct_num varchar2(100) --付息人账号
,pay_int_ratio number(18,6) --付息比例
,agent_name varchar2(250) --代理名称
,cust_mgr_id varchar2(60) --客户经理编号
,dept_id varchar2(60) --部门编号
,discnt_bf_revw_flg varchar2(10) --先贴后查标志
,cont_matrl_backup_flg varchar2(10) --合同资料后补标志
,backup_closing_dt date --后补截止日期
,operr_id varchar2(60) --操作员编号
,tran_dt date --交易日期
,bus_logic_check_status_cd varchar2(10) --业务逻辑检查状态代码
,crdt_check_status_cd varchar2(10) --授信检查状态代码
,check_status_cd varchar2(10) --审核状态代码
,int_accr_check_status_cd varchar2(10) --计息复核状态代码
,entry_status_cd varchar2(10) --记账状态代码
,intnal_stl_flg varchar2(10) --内部结算标志
,intnal_stl_acct varchar2(60) --内部结算账户
,agt_exp_dt date --协议到期日期
,crdt_valid_amt number(30,2) --信贷有效金额
,apprved_use_crdt_open_amt number(30,2) --已批准使用授信敞口金额
,distr_post_acm_use_open_amt number(30,2) --本次放款后累计使用敞口金额
,cert_type_cd varchar2(10) --证件类型代码
,cert_no varchar2(60) --证件号码
,asset_thd_cls_cd varchar2(30) --资产三分类代码
,rela_party_que_rest_cd varchar2(30) --关联方查询结果代码
,crdt_cont_used_amt number(30,2) --信贷合同已用金额
,crdt_cont_tot_amt number(30,2) --信贷合同总金额
,lmt_cont_used_tot_amt number(30,2) --额度合同已用总金额
,midgrod_bus_flow_num varchar2(60) --中台业务流水号
,int_calc_defer_way_cd varchar2(30) --利息计算顺延方式代码
,tgls_entry_status_cd varchar2(30) --核算中台记账状态代码
,ncbs_entry_status_cd varchar2(30) --核心记账状态代码
,h_data_flg varchar2(100) --历史数据标志
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_bill_discnt_batch to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_bill_discnt_batch is '票据贴现批次';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.batch_id is '批次编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.lp_id is '法人编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.org_id is '机构编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.enter_acct_org_id is '入账机构编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.buy_prod_cd is '买入产品代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.buy_type_cd is '买入类型代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.discnt_bus_type_cd is '贴现业务类型代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.bus_id is '业务编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.bill_type_cd is '票据类型代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.bill_med_cd is '票据介质代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.cust_name is '客户名称';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.cust_open_bank_no is '客户开户行行号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.cust_open_acct_num is '客户开户账号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.int_rat is '利率';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.int_rat_type_cd is '利率类型代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.redem_int_rat is '赎回利率';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.redem_int_rat_type_cd is '赎回利率类型代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.buy_dt is '买入日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.onl_clear_flg is '线上清算标志';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.redem_open_dt is '赎回开放日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.redem_closing_dt is '赎回截止日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.sys_in_flg is '系统外标志';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.pay_int_way_cd is '付息方式代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.int_payer_name is '付息人名称';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.int_payer_acct_num is '付息人账号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.pay_int_ratio is '付息比例';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.agent_name is '代理名称';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.dept_id is '部门编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.discnt_bf_revw_flg is '先贴后查标志';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.cont_matrl_backup_flg is '合同资料后补标志';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.backup_closing_dt is '后补截止日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.operr_id is '操作员编号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.tran_dt is '交易日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.bus_logic_check_status_cd is '业务逻辑检查状态代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.crdt_check_status_cd is '授信检查状态代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.check_status_cd is '审核状态代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.int_accr_check_status_cd is '计息复核状态代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.entry_status_cd is '记账状态代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.intnal_stl_flg is '内部结算标志';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.intnal_stl_acct is '内部结算账户';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.agt_exp_dt is '协议到期日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.crdt_valid_amt is '信贷有效金额';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.apprved_use_crdt_open_amt is '已批准使用授信敞口金额';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.distr_post_acm_use_open_amt is '本次放款后累计使用敞口金额';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.cert_type_cd is '证件类型代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.cert_no is '证件号码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.asset_thd_cls_cd is '资产三分类代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.rela_party_que_rest_cd is '关联方查询结果代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.crdt_cont_used_amt is '信贷合同已用金额';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.crdt_cont_tot_amt is '信贷合同总金额';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.lmt_cont_used_tot_amt is '额度合同已用总金额';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.midgrod_bus_flow_num is '中台业务流水号';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.int_calc_defer_way_cd is '利息计算顺延方式代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.tgls_entry_status_cd is '核算中台记账状态代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.ncbs_entry_status_cd is '核心记账状态代码';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.h_data_flg is '历史数据标志';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.create_dt is '创建日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.update_dt is '更新日期';
comment on column ${idl_schema}.oass_agt_bill_discnt_batch.id_mark is '增删标志';

