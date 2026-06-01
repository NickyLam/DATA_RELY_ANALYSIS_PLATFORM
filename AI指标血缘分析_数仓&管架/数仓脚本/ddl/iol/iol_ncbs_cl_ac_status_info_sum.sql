/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_ac_status_info_sum
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_ac_status_info_sum
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_ac_status_info_sum purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_ac_status_info_sum(
    acct_status varchar2(1) -- 账户状态
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,contract_no varchar2(30) -- 合同编号
    ,dd_no number(5) -- 发放号
    ,internal_key number(15) -- 账户内部键值
    ,profit_center varchar2(20) -- 利润中心
    ,acct_status_prev varchar2(1) -- 账户上一状态
    ,cmisloan_no varchar2(60) -- 客户借据编号
    ,company varchar2(20) -- 法人
    ,sched_mode varchar2(2) -- 还款方式
    ,system_id varchar2(20) -- 系统id
    ,tran_category varchar2(5) -- 交易种类
    ,accounting_status varchar2(3) -- 核算状态
    ,accounting_status_prev varchar2(3) -- 上次核算状态
    ,accounting_status_upd_date date -- 核算状态变更日期
    ,acct_open_date date -- 账户开户日期
    ,acct_status_upd_date date -- 账户状态变更日期
    ,maturity_date date -- 到期日期
    ,acct_branch varchar2(12) -- 开户机构编号
    ,busi_prod varchar2(12) -- 业务产品
    ,contract_amt number(17,2) -- 合同金额
    ,gprd_amt number(17,2) -- 宽限期本金
    ,int_basis_rate number(15,8) -- 基准利率
    ,loan_no varchar2(50) -- 贷款号
    ,marketing_prod varchar2(12) -- 营销产品
    ,osl_amt number(17,2) -- 客户未到期本金
    ,prd_amt number(17,2) -- 逾期本金
    ,real_rate number(15,8) -- 执行利率
    ,rem_amt number(17,2) -- 剩余本金
    ,cl_acct_change_type varchar2(2) -- 贷款分户变更类型
    ,clean_status varchar2(2) -- 结清标志
    ,clean_status_upd_date date -- 结清状态变更日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_cl_ac_status_info_sum to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_ac_status_info_sum to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_ac_status_info_sum to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_ac_status_info_sum to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_ac_status_info_sum is '分户信息文件表';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.contract_no is '合同编号';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.acct_status_prev is '账户上一状态';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.cmisloan_no is '客户借据编号';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.company is '法人';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.sched_mode is '还款方式';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.system_id is '系统id';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.tran_category is '交易种类';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.accounting_status_prev is '上次核算状态';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.accounting_status_upd_date is '核算状态变更日期';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.acct_status_upd_date is '账户状态变更日期';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.busi_prod is '业务产品';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.contract_amt is '合同金额';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.gprd_amt is '宽限期本金';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.int_basis_rate is '基准利率';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.marketing_prod is '营销产品';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.osl_amt is '客户未到期本金';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.prd_amt is '逾期本金';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.rem_amt is '剩余本金';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.cl_acct_change_type is '贷款分户变更类型';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.clean_status is '结清标志';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.clean_status_upd_date is '结清状态变更日期';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_ac_status_info_sum.etl_timestamp is 'ETL处理时间戳';
