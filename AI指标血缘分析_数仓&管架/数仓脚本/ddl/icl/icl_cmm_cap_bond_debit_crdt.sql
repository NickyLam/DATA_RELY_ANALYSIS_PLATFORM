/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_cap_bond_debit_crdt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_cap_bond_debit_crdt
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_cap_bond_debit_crdt purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_cap_bond_debit_crdt(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,dept_id varchar2(60) -- 部门编号
    ,entry_org_id varchar2(60) -- 记账机构编号
    ,tran_acct_b_id varchar2(60) -- 交易账簿编号
    ,tran_acct_b_name varchar2(250) -- 交易账簿名称
    ,acct_b_attr_cd varchar2(10) -- 账簿属性代码
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,cust_id varchar2(100) -- 客户编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(250) -- 交易对手名称
    ,portf_id varchar2(60) -- 投组编号
    ,portf_name varchar2(150) -- 投组名称
    ,subj_id varchar2(60) -- 科目编号
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,tran_dt date -- 交易日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,tran_amt number(30,2) -- 交易金额
    ,exp_stl_amt number(30,2) -- 到期结算金额
    ,curr_cd varchar2(10) -- 币种代码
    ,debit_crdt_fee_rat number(18,8) -- 借贷费率
    ,debit_crdt_days number(18,0) -- 借贷天数
    ,bond_fac_val_comb varchar2(750) -- 债券面值组合
    ,inpwn_bond_comb varchar2(750) -- 质押债券组合
    ,underly_bond_id varchar2(60) -- 标的债券编号
    ,acru_int number(30,2) -- 应计利息
    ,tm_bg_stl_way_cd varchar2(10) -- 期初结算方式代码
    ,term_end_stl_way_cd varchar2(10) -- 期末结算方式代码
    ,tran_fee number(30,2) -- 交易费用
    ,tran_tax number(30,2) -- 交易税金
    ,tran_comm number(30,2) -- 交易佣金
    ,currt_bal number(30,2) -- 当期余额
    ,currt_acru_int number(30,2) -- 当期应计利息
    ,dealer_id varchar2(60) -- 交易员编号
    ,dealer_name varchar2(375) -- 交易员名称
    ,tran_id varchar2(60) -- 交易编号
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,tran_clear_acct_id varchar2(256) -- 交易清算账户编号
    ,tran_clear_bank_no varchar2(256) -- 交易清算银行行号
    ,tran_clear_bank_name varchar2(500) -- 交易清算银行行名
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_cap_bond_debit_crdt to ${idl_schema};
grant select on ${icl_schema}.cmm_cap_bond_debit_crdt to ${iel_schema};
grant select on ${icl_schema}.cmm_cap_bond_debit_crdt to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_cap_bond_debit_crdt is '资金债券借贷';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.dept_id is '部门编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.entry_org_id is '记账机构编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_acct_b_id is '交易账簿编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_acct_b_name is '交易账簿名称';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.acct_b_attr_cd is '账簿属性代码';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.portf_id is '投组编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.portf_name is '投组名称';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_dir_cd is '交易方向代码';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.exp_stl_amt is '到期结算金额';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.debit_crdt_fee_rat is '借贷费率';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.debit_crdt_days is '借贷天数';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.bond_fac_val_comb is '债券面值组合';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.inpwn_bond_comb is '质押债券组合';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.underly_bond_id is '标的债券编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tm_bg_stl_way_cd is '期初结算方式代码';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.term_end_stl_way_cd is '期末结算方式代码';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_fee is '交易费用';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_tax is '交易税金';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_comm is '交易佣金';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.currt_bal is '当期余额';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.currt_acru_int is '当期应计利息';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.dealer_id is '交易员编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.dealer_name is '交易员名称';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_id is '交易编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_ref_no is '交易参考号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_clear_acct_id is '交易清算账户编号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_clear_bank_no is '交易清算银行行号';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.tran_clear_bank_name is '交易清算银行行名';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_cap_bond_debit_crdt.etl_timestamp is 'ETL处理时间戳';
