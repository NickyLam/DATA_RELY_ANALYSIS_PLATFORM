/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_lg_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_lg_register
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_lg_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_lg_register(
    ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,contract_no varchar2(30) -- 合同编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,cmisloan_no varchar2(60) -- 客户借据编号
    ,company varchar2(20) -- 法人
    ,compensate_status varchar2(2) -- 保函赔付状态
    ,lg_no varchar2(50) -- 保函编号
    ,lg_status varchar2(2) -- 保函状态
    ,terminal_id varchar2(50) -- 交易终端编号
    ,last_change_date date -- 最后修改日期
    ,lg_end_date date -- 保函终止日期
    ,lg_start_date date -- 保函起始日期
    ,new_lg_end_date date -- 新保函终止日期
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
    ,collat_value number(17,2) -- 押品账面价值
    ,contract_ccy varchar2(3) -- 保函合同币种
    ,counterparty_branch varchar2(12) -- 反担机构
    ,lg_amt number(17,2) -- 保函金额
    ,lg_branch varchar2(12) -- 担保机构
    ,lg_compensate_balance number(17,2) -- 剩余赔付金额
    ,mortgage_contract_no varchar2(30) -- 抵押合同编号
    ,open_branch varchar2(12) -- 开立机构
    ,org_restraint_amt number(17,2) -- 保函原始冻结金额
    ,orig_loan_amt number(17,2) -- 贷款签约合同金额
    ,pri_plty_abs number(15,8) -- 垫款固定罚息利率
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_no varchar2(50) -- 人行清算账户
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_prod_type varchar2(12) -- 结算账户产品类型
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,beneficiary_is_inner varchar2(1) -- 受益人账号是否本行
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
grant select on ${iol_schema}.ncbs_cl_lg_register to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_lg_register to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_lg_register to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_lg_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_lg_register is '保函信息登记表';
comment on column ${iol_schema}.ncbs_cl_lg_register.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_lg_register.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_lg_register.contract_no is '合同编号';
comment on column ${iol_schema}.ncbs_cl_lg_register.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_lg_register.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_lg_register.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_cl_lg_register.remark is '备注';
comment on column ${iol_schema}.ncbs_cl_lg_register.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_lg_register.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_cl_lg_register.cmisloan_no is '客户借据编号';
comment on column ${iol_schema}.ncbs_cl_lg_register.company is '法人';
comment on column ${iol_schema}.ncbs_cl_lg_register.compensate_status is '保函赔付状态';
comment on column ${iol_schema}.ncbs_cl_lg_register.lg_no is '保函编号';
comment on column ${iol_schema}.ncbs_cl_lg_register.lg_status is '保函状态';
comment on column ${iol_schema}.ncbs_cl_lg_register.terminal_id is '交易终端编号';
comment on column ${iol_schema}.ncbs_cl_lg_register.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_lg_register.lg_end_date is '保函终止日期';
comment on column ${iol_schema}.ncbs_cl_lg_register.lg_start_date is '保函起始日期';
comment on column ${iol_schema}.ncbs_cl_lg_register.new_lg_end_date is '新保函终止日期';
comment on column ${iol_schema}.ncbs_cl_lg_register.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_lg_register.advanced_acct_no is '垫款贷款账号';
comment on column ${iol_schema}.ncbs_cl_lg_register.advanced_amt is '保函垫款金额';
comment on column ${iol_schema}.ncbs_cl_lg_register.apply_client_no is '申请者客户号';
comment on column ${iol_schema}.ncbs_cl_lg_register.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_cl_lg_register.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_cl_lg_register.back_acct_ccy is '备款账号币种';
comment on column ${iol_schema}.ncbs_cl_lg_register.back_acct_no is '备款入账账号';
comment on column ${iol_schema}.ncbs_cl_lg_register.back_acct_seq_no is '备款账户序列号';
comment on column ${iol_schema}.ncbs_cl_lg_register.back_prod_type is '备款账号产品类型';
comment on column ${iol_schema}.ncbs_cl_lg_register.beneficiary_acct_no is '保函受益人账号';
comment on column ${iol_schema}.ncbs_cl_lg_register.beneficiary_address is '受益人住址';
comment on column ${iol_schema}.ncbs_cl_lg_register.beneficiary_document_id is '受益人证件号';
comment on column ${iol_schema}.ncbs_cl_lg_register.beneficiary_document_type is '受益人证件类型';
comment on column ${iol_schema}.ncbs_cl_lg_register.beneficiary_name is '受益人名称';
comment on column ${iol_schema}.ncbs_cl_lg_register.collat_value is '押品账面价值';
comment on column ${iol_schema}.ncbs_cl_lg_register.contract_ccy is '保函合同币种';
comment on column ${iol_schema}.ncbs_cl_lg_register.counterparty_branch is '反担机构';
comment on column ${iol_schema}.ncbs_cl_lg_register.lg_amt is '保函金额';
comment on column ${iol_schema}.ncbs_cl_lg_register.lg_branch is '担保机构';
comment on column ${iol_schema}.ncbs_cl_lg_register.lg_compensate_balance is '剩余赔付金额';
comment on column ${iol_schema}.ncbs_cl_lg_register.mortgage_contract_no is '抵押合同编号';
comment on column ${iol_schema}.ncbs_cl_lg_register.open_branch is '开立机构';
comment on column ${iol_schema}.ncbs_cl_lg_register.org_restraint_amt is '保函原始冻结金额';
comment on column ${iol_schema}.ncbs_cl_lg_register.orig_loan_amt is '贷款签约合同金额';
comment on column ${iol_schema}.ncbs_cl_lg_register.pri_plty_abs is '垫款固定罚息利率';
comment on column ${iol_schema}.ncbs_cl_lg_register.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_cl_lg_register.settle_acct_no is '人行清算账户';
comment on column ${iol_schema}.ncbs_cl_lg_register.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_cl_lg_register.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_cl_lg_register.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cl_lg_register.beneficiary_is_inner is '受益人账号是否本行';
comment on column ${iol_schema}.ncbs_cl_lg_register.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_lg_register.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_lg_register.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_lg_register.etl_timestamp is 'ETL处理时间戳';
