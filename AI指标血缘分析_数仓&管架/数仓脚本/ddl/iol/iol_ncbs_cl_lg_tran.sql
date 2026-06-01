/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_lg_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_lg_tran
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_lg_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_lg_tran(
    ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,contract_no varchar2(30) -- 合同编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,company varchar2(20) -- 法人
    ,compensate_status varchar2(2) -- 保函赔付状态
    ,counter number(5) -- 序号
    ,event_type varchar2(20) -- 事件类型
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,lg_flag varchar2(1) -- 保函标记
    ,lg_no varchar2(50) -- 保函编号
    ,lg_status varchar2(2) -- 保函状态
    ,narrative varchar2(400) -- 摘要
    ,res_seq_no varchar2(50) -- 限制编号
    ,reversed_flag varchar2(1) -- 是否撤销标志
    ,terminal_id varchar2(50) -- 交易终端编号
    ,tran_no varchar2(50) -- 抵质押品交易序号
    ,verify_flag varchar2(1) -- 是否核实后禁止
    ,lg_end_date date -- 保函终止日期
    ,lg_start_date date -- 保函起始日期
    ,new_lg_end_date date -- 新保函终止日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,advanced_acct_no varchar2(50) -- 垫款贷款账号
    ,advanced_amt number(17,2) -- 保函垫款金额
    ,apply_client_no varchar2(16) -- 申请者客户号
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,back_acct_ccy varchar2(3) -- 备款账号币种
    ,back_acct_no varchar2(50) -- 备款入账账号
    ,back_acct_seq_no varchar2(5) -- 备款账户序列号
    ,back_prod_type varchar2(12) -- 备款账号产品类型
    ,beneficiary_acct_no varchar2(50) -- 保函受益人账号
    ,beneficiary_address varchar2(400) -- 受益人住址
    ,beneficiary_document_id varchar2(60) -- 受益人证件号
    ,beneficiary_document_type varchar2(4) -- 受益人证件类型
    ,beneficiary_name varchar2(200) -- 受益人名称
    ,bond_acct_ccy varchar2(3) -- 保证金账户币种
    ,bond_acct_no varchar2(50) -- 保证金账号
    ,bond_acct_seq_no varchar2(5) -- 保证金账户序号
    ,bond_prod_type varchar2(12) -- 保证金账户产品类型
    ,collat_value number(17,2) -- 押品账面价值
    ,contract_ccy varchar2(3) -- 保函合同币种
    ,counterparty_branch varchar2(12) -- 反担机构
    ,lg_amt number(17,2) -- 保函金额
    ,lg_branch varchar2(12) -- 担保机构
    ,lg_compensate_amt number(17,2) -- 保函赔付金额
    ,mortgage_contract_no varchar2(30) -- 抵押合同编号
    ,open_branch varchar2(12) -- 开立机构
    ,orig_loan_amt number(17,2) -- 贷款签约合同金额
    ,pri_plty_abs number(15,8) -- 垫款固定罚息利率
    ,restraint_amt number(17,2) -- 贷款止付金额
    ,restraint_per number(11,7) -- 止付比例
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_no varchar2(50) -- 人行清算账户
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_prod_type varchar2(12) -- 结算账户产品类型
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,reaccount_cd varchar2(20) -- 对账代码
    ,bus_seq_no varchar2(33) -- 业务流水号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_cl_lg_tran to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_lg_tran to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_lg_tran to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_lg_tran to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_lg_tran is '保函交易流水表';
comment on column ${iol_schema}.ncbs_cl_lg_tran.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_lg_tran.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.contract_no is '合同编号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_lg_tran.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_cl_lg_tran.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.remark is '备注';
comment on column ${iol_schema}.ncbs_cl_lg_tran.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.company is '法人';
comment on column ${iol_schema}.ncbs_cl_lg_tran.compensate_status is '保函赔付状态';
comment on column ${iol_schema}.ncbs_cl_lg_tran.counter is '序号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_cl_lg_tran.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_cl_lg_tran.lg_flag is '保函标记';
comment on column ${iol_schema}.ncbs_cl_lg_tran.lg_no is '保函编号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.lg_status is '保函状态';
comment on column ${iol_schema}.ncbs_cl_lg_tran.narrative is '摘要';
comment on column ${iol_schema}.ncbs_cl_lg_tran.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.reversed_flag is '是否撤销标志';
comment on column ${iol_schema}.ncbs_cl_lg_tran.terminal_id is '交易终端编号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.tran_no is '抵质押品交易序号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.verify_flag is '是否核实后禁止';
comment on column ${iol_schema}.ncbs_cl_lg_tran.lg_end_date is '保函终止日期';
comment on column ${iol_schema}.ncbs_cl_lg_tran.lg_start_date is '保函起始日期';
comment on column ${iol_schema}.ncbs_cl_lg_tran.new_lg_end_date is '新保函终止日期';
comment on column ${iol_schema}.ncbs_cl_lg_tran.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_lg_tran.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_lg_tran.advanced_acct_no is '垫款贷款账号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.advanced_amt is '保函垫款金额';
comment on column ${iol_schema}.ncbs_cl_lg_tran.apply_client_no is '申请者客户号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_cl_lg_tran.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_cl_lg_tran.back_acct_ccy is '备款账号币种';
comment on column ${iol_schema}.ncbs_cl_lg_tran.back_acct_no is '备款入账账号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.back_acct_seq_no is '备款账户序列号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.back_prod_type is '备款账号产品类型';
comment on column ${iol_schema}.ncbs_cl_lg_tran.beneficiary_acct_no is '保函受益人账号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.beneficiary_address is '受益人住址';
comment on column ${iol_schema}.ncbs_cl_lg_tran.beneficiary_document_id is '受益人证件号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.beneficiary_document_type is '受益人证件类型';
comment on column ${iol_schema}.ncbs_cl_lg_tran.beneficiary_name is '受益人名称';
comment on column ${iol_schema}.ncbs_cl_lg_tran.bond_acct_ccy is '保证金账户币种';
comment on column ${iol_schema}.ncbs_cl_lg_tran.bond_acct_no is '保证金账号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.bond_acct_seq_no is '保证金账户序号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.bond_prod_type is '保证金账户产品类型';
comment on column ${iol_schema}.ncbs_cl_lg_tran.collat_value is '押品账面价值';
comment on column ${iol_schema}.ncbs_cl_lg_tran.contract_ccy is '保函合同币种';
comment on column ${iol_schema}.ncbs_cl_lg_tran.counterparty_branch is '反担机构';
comment on column ${iol_schema}.ncbs_cl_lg_tran.lg_amt is '保函金额';
comment on column ${iol_schema}.ncbs_cl_lg_tran.lg_branch is '担保机构';
comment on column ${iol_schema}.ncbs_cl_lg_tran.lg_compensate_amt is '保函赔付金额';
comment on column ${iol_schema}.ncbs_cl_lg_tran.mortgage_contract_no is '抵押合同编号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.open_branch is '开立机构';
comment on column ${iol_schema}.ncbs_cl_lg_tran.orig_loan_amt is '贷款签约合同金额';
comment on column ${iol_schema}.ncbs_cl_lg_tran.pri_plty_abs is '垫款固定罚息利率';
comment on column ${iol_schema}.ncbs_cl_lg_tran.restraint_amt is '贷款止付金额';
comment on column ${iol_schema}.ncbs_cl_lg_tran.restraint_per is '止付比例';
comment on column ${iol_schema}.ncbs_cl_lg_tran.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_cl_lg_tran.settle_acct_no is '人行清算账户';
comment on column ${iol_schema}.ncbs_cl_lg_tran.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_cl_lg_tran.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_cl_lg_tran.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_cl_lg_tran.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_lg_tran.etl_timestamp is 'ETL处理时间戳';
