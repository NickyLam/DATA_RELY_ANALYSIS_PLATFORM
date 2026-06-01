/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_cap_sec_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_cap_sec_tran
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_cap_sec_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_cap_sec_tran(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,bus_id varchar2(60) -- 业务编号
    ,dept_id varchar2(60) -- 部门编号
    ,tran_acct_b_id varchar2(60) -- 交易账簿编号
    ,tran_acct_b_name varchar2(250) -- 交易账簿名称
    ,acct_b_attr_cd varchar2(10) -- 账簿属性代码
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,cust_id varchar2(100) -- 客户编号
    ,entry_org_id varchar2(60) -- 记账机构编号
    ,tran_acct_id varchar2(250) -- 交易账户编号
    ,tran_acct_open_bank_no varchar2(250) -- 交易账户开户行行号
    ,tran_acct_open_bank_bank_name varchar2(375) -- 交易账户开户行行名
    ,cntpty_acct_id varchar2(250) -- 交易对手账号
    ,cntpty_acct_open_bank_no varchar2(250) -- 交易对手账户开户行行号
    ,cntpty_acct_open_bank_bank_name varchar2(375) -- 交易对手账户开户行行名
    ,crdt_out_acct_flow_num varchar2(60) -- 信贷借据编号
    ,cntpty_id varchar2(60) -- 交易对手编号
    ,cntpty_name varchar2(250) -- 交易对手名称
    ,portf_id varchar2(60) -- 投组编号
    ,portf_name varchar2(250) -- 投组名称
    ,asset_type_cd varchar2(10) -- 资产类型代码
    ,asset_four_cls_cd varchar2(10) -- 资产四分类代码
    ,tran_dir_cd varchar2(10) -- 交易方向代码
    ,tran_dt date -- 交易日期
    ,stl_dt date -- 结算日期
    ,curr_cd varchar2(10) -- 币种代码
    ,stl_amt number(30,2) -- 结算金额
    ,bond_fac_val number(30,2) -- 债券面值
    ,tran_net_price number(22,12) -- 交易净价
    ,tran_full_price number(22,12) -- 交易全价
    ,exp_yld_rat number(22,12) -- 到期收益率
    ,bond_id varchar2(60) -- 债券编号
    ,bond_name varchar2(250) -- 债券名称
    ,bond_type_cd varchar2(10) -- 债券类型代码
    ,acru_int number(30,2) -- 应计利息
    ,tran_fee number(30,2) -- 交易费用
    ,tran_tax number(30,2) -- 交易税金
    ,tran_comm number(30,2) -- 交易佣金
    ,dealer_id varchar2(60) -- 交易员编号
    ,dealer_name varchar2(250) -- 交易员名称
    ,tran_src_cd varchar2(10) -- 交易来源代码
    ,tran_id varchar2(60) -- 交易编号
    ,tran_clear_acct_id varchar2(256) -- 交易清算账户编号
    ,tran_clear_bank_no varchar2(256) -- 交易清算银行行号
    ,tran_clear_bank_name varchar2(384) -- 交易清算银行名称
    ,remark varchar2(500) -- 备注
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
grant select on ${icl_schema}.cmm_cap_sec_tran to ${idl_schema};
grant select on ${icl_schema}.cmm_cap_sec_tran to ${iel_schema};
grant select on ${icl_schema}.cmm_cap_sec_tran to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_cap_sec_tran is '资金现券交易';
comment on column ${icl_schema}.cmm_cap_sec_tran.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_cap_sec_tran.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.bus_id is '业务编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.dept_id is '部门编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_acct_b_id is '交易账簿编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_acct_b_name is '交易账簿名称';
comment on column ${icl_schema}.cmm_cap_sec_tran.acct_b_attr_cd is '账簿属性代码';
comment on column ${icl_schema}.cmm_cap_sec_tran.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.entry_org_id is '记账机构编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_acct_id is '交易账户编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_acct_open_bank_no is '交易账户开户行行号';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_acct_open_bank_bank_name is '交易账户开户行行名';
comment on column ${icl_schema}.cmm_cap_sec_tran.cntpty_acct_id is '交易对手账号';
comment on column ${icl_schema}.cmm_cap_sec_tran.cntpty_acct_open_bank_no is '交易对手账户开户行行号';
comment on column ${icl_schema}.cmm_cap_sec_tran.cntpty_acct_open_bank_bank_name is '交易对手账户开户行行名';
comment on column ${icl_schema}.cmm_cap_sec_tran.crdt_out_acct_flow_num is '信贷借据编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.cntpty_id is '交易对手编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.cntpty_name is '交易对手名称';
comment on column ${icl_schema}.cmm_cap_sec_tran.portf_id is '投组编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.portf_name is '投组名称';
comment on column ${icl_schema}.cmm_cap_sec_tran.asset_type_cd is '资产类型代码';
comment on column ${icl_schema}.cmm_cap_sec_tran.asset_four_cls_cd is '资产四分类代码';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_dir_cd is '交易方向代码';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_dt is '交易日期';
comment on column ${icl_schema}.cmm_cap_sec_tran.stl_dt is '结算日期';
comment on column ${icl_schema}.cmm_cap_sec_tran.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_cap_sec_tran.stl_amt is '结算金额';
comment on column ${icl_schema}.cmm_cap_sec_tran.bond_fac_val is '债券面值';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_net_price is '交易净价';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_full_price is '交易全价';
comment on column ${icl_schema}.cmm_cap_sec_tran.exp_yld_rat is '到期收益率';
comment on column ${icl_schema}.cmm_cap_sec_tran.bond_id is '债券编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.bond_name is '债券名称';
comment on column ${icl_schema}.cmm_cap_sec_tran.bond_type_cd is '债券类型代码';
comment on column ${icl_schema}.cmm_cap_sec_tran.acru_int is '应计利息';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_fee is '交易费用';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_tax is '交易税金';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_comm is '交易佣金';
comment on column ${icl_schema}.cmm_cap_sec_tran.dealer_id is '交易员编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.dealer_name is '交易员名称';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_src_cd is '交易来源代码';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_id is '交易编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_clear_acct_id is '交易清算账户编号';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_clear_bank_no is '交易清算银行行号';
comment on column ${icl_schema}.cmm_cap_sec_tran.tran_clear_bank_name is '交易清算银行名称';
comment on column ${icl_schema}.cmm_cap_sec_tran.remark is '备注';
comment on column ${icl_schema}.cmm_cap_sec_tran.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_cap_sec_tran.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_cap_sec_tran.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_cap_sec_tran.etl_timestamp is 'ETL处理时间戳';
