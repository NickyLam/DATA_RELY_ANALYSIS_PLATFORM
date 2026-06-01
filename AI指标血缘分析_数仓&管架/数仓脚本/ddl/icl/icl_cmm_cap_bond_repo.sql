/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_cap_bond_repo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_cap_bond_repo
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_cap_bond_repo purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_cap_bond_repo(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,repo_type_cd varchar2(10) -- 回购类型代码
    ,dept_id varchar2(60) -- 部门编号
    ,entry_org_id varchar2(60) -- 记账机构编号
    ,tran_acct_b_id varchar2(60) -- 交易账簿编号
    ,tran_acct_b_name varchar2(250) -- 交易账簿名称
    ,acct_b_attr_cd varchar2(10) -- 账簿属性代码
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,asset_thd_cls_cd varchar2(30) -- 资产三分类代码
    ,cust_id varchar2(100) -- 客户编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(750) -- 交易对手名称
    ,portf_id varchar2(60) -- 投组编号
    ,portf_name varchar2(250) -- 投组名称
    ,subj_id varchar2(60) -- 科目编号
    ,int_recvbl_subj_id varchar2(60) -- 应收利息科目编号
    ,int_income_subj_id varchar2(60) -- 利息收入科目编号
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,tran_dt date -- 交易日期
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,tenor number(18,0) -- 期限
    ,tran_amt number(30,2) -- 交易金额
    ,exp_stl_amt number(30,2) -- 到期结算金额
    ,curr_cd varchar2(10) -- 币种代码
    ,repo_int_rat number(18,8) -- 回购利率
    ,repo_id varchar2(60) -- 回购编号
    ,bond_fac_val_comb varchar2(750) -- 债券面值组合
    ,inpwn_ratio_comb varchar2(750) -- 质押比例组合
    ,bond_id_comb varchar2(500) -- 债券编号组合
    ,bond_name_comb varchar2(3000) -- 债券名称组合
    ,acru_int number(30,2) -- 应计利息
    ,fst_stl_way_cd varchar2(10) -- 首期结算方式代码
    ,exp_stl_way_cd varchar2(10) -- 到期结算方式代码
    ,tran_fee number(30,2) -- 交易费用
    ,tran_tax number(30,2) -- 交易税金
    ,tran_comm number(30,2) -- 交易佣金
    ,dealer_id varchar2(60) -- 交易员编号
    ,dealer_name varchar2(250) -- 交易员名称
    ,tran_id varchar2(60) -- 交易编号
    ,bag_id varchar2(60) -- 成交编号
    ,int_recvbl number(30,2) -- 应收利息
    ,clear_type_cd varchar2(10) -- 清算类型代码
    ,tran_clear_acct_id varchar2(256) -- 交易清算账户编号
    ,tran_clear_bank_no varchar2(256) -- 交易清算银行行号
    ,tran_clear_bank_name varchar2(384) -- 交易清算银行名称
    ,book_bal number(30,8) -- 账面余额
    ,exp_net_price number(30,8) -- 到期净价
    ,curr_bal number(30,2) -- 当前余额
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
grant select on ${icl_schema}.cmm_cap_bond_repo to ${idl_schema};
grant select on ${icl_schema}.cmm_cap_bond_repo to ${iel_schema};
grant select on ${icl_schema}.cmm_cap_bond_repo to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_cap_bond_repo is '资金债券回购';
comment on column ${icl_schema}.cmm_cap_bond_repo.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_cap_bond_repo.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.repo_type_cd is '回购类型代码';
comment on column ${icl_schema}.cmm_cap_bond_repo.dept_id is '部门编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.entry_org_id is '记账机构编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.tran_acct_b_id is '交易账簿编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.tran_acct_b_name is '交易账簿名称';
comment on column ${icl_schema}.cmm_cap_bond_repo.acct_b_attr_cd is '账簿属性代码';
comment on column ${icl_schema}.cmm_cap_bond_repo.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.asset_thd_cls_cd is '资产三分类代码';
comment on column ${icl_schema}.cmm_cap_bond_repo.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_cap_bond_repo.portf_id is '投组编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.portf_name is '投组名称';
comment on column ${icl_schema}.cmm_cap_bond_repo.subj_id is '科目编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.int_recvbl_subj_id is '应收利息科目编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.int_income_subj_id is '利息收入科目编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.tran_dir_cd is '交易方向代码';
comment on column ${icl_schema}.cmm_cap_bond_repo.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_cap_bond_repo.value_dt is '起息日期';
comment on column ${icl_schema}.cmm_cap_bond_repo.exp_dt is '到期日期';
comment on column ${icl_schema}.cmm_cap_bond_repo.tenor is '期限';
comment on column ${icl_schema}.cmm_cap_bond_repo.tran_amt is '交易金额';
comment on column ${icl_schema}.cmm_cap_bond_repo.exp_stl_amt is '到期结算金额';
comment on column ${icl_schema}.cmm_cap_bond_repo.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_cap_bond_repo.repo_int_rat is '回购利率';
comment on column ${icl_schema}.cmm_cap_bond_repo.repo_id is '回购编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.bond_fac_val_comb is '债券面值组合';
comment on column ${icl_schema}.cmm_cap_bond_repo.inpwn_ratio_comb is '质押比例组合';
comment on column ${icl_schema}.cmm_cap_bond_repo.bond_id_comb is '债券编号组合';
comment on column ${icl_schema}.cmm_cap_bond_repo.bond_name_comb is '债券名称组合';
comment on column ${icl_schema}.cmm_cap_bond_repo.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_cap_bond_repo.fst_stl_way_cd is '首期结算方式代码';
comment on column ${icl_schema}.cmm_cap_bond_repo.exp_stl_way_cd is '到期结算方式代码';
comment on column ${icl_schema}.cmm_cap_bond_repo.tran_fee is '交易费用';
comment on column ${icl_schema}.cmm_cap_bond_repo.tran_tax is '交易税金';
comment on column ${icl_schema}.cmm_cap_bond_repo.tran_comm is '交易佣金';
comment on column ${icl_schema}.cmm_cap_bond_repo.dealer_id is '交易员编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.dealer_name is '交易员名称';
comment on column ${icl_schema}.cmm_cap_bond_repo.tran_id is '交易编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.bag_id is '成交编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.int_recvbl is '应收利息';
comment on column ${icl_schema}.cmm_cap_bond_repo.clear_type_cd is '清算类型代码';
comment on column ${icl_schema}.cmm_cap_bond_repo.tran_clear_acct_id is '交易清算账户编号';
comment on column ${icl_schema}.cmm_cap_bond_repo.tran_clear_bank_no is '交易清算银行行号';
comment on column ${icl_schema}.cmm_cap_bond_repo.tran_clear_bank_name is '交易清算银行名称';
comment on column ${icl_schema}.cmm_cap_bond_repo.book_bal is '账面余额';
comment on column ${icl_schema}.cmm_cap_bond_repo.exp_net_price is '到期净价';
comment on column ${icl_schema}.cmm_cap_bond_repo.curr_bal is '当前余额';
comment on column ${icl_schema}.cmm_cap_bond_repo.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_cap_bond_repo.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_cap_bond_repo.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_cap_bond_repo.etl_timestamp is 'ETL处理时间戳';
