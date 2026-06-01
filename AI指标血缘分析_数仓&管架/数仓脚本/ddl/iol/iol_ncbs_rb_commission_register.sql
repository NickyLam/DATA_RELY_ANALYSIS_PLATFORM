/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_commission_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_commission_register
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_commission_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_commission_register(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,country varchar2(3) -- 国家
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,voucher_no varchar2(50) -- 凭证号码
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,commission_client_tel varchar2(20) -- 代办/代理人电话
    ,commission_reason varchar2(200) -- 经办理由
    ,commission_relation varchar2(50) -- 代办人关系
    ,company varchar2(20) -- 法人
    ,event_type varchar2(20) -- 事件类型
    ,is_commission varchar2(1) -- 是否代办人
    ,prefix varchar2(10) -- 前缀
    ,program_id varchar2(20) -- 交易代码
    ,commission_expire_date date -- 交易代办人证件证件失效日期
    ,commission_start_date date -- 代办人证件开始日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,commission_client_name varchar2(200) -- 代办人名称
    ,commission_client_no varchar2(16) -- 代办人客户号
    ,commission_document_id varchar2(60) -- 代办人证件号码
    ,commission_document_type varchar2(4) -- 代办人证件类型
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,commission_confirm_result varchar2(20) -- 核实结果
    ,commission_confirm_tel varchar2(20) -- 核实电话
    ,commission_confirm_time varchar2(10) -- 核实时间
    ,commission_confirm_user_id_key1 varchar2(30) -- 代办核实员工号1
    ,commission_confirm_user_id_key2 varchar2(30) -- 代办核实员工号2
    ,commission_flag varchar2(1) -- 是否代理标志
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
grant select on ${iol_schema}.ncbs_rb_commission_register to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_commission_register to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_commission_register to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_commission_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_commission_register is '代办人登记表';
comment on column ${iol_schema}.ncbs_rb_commission_register.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_commission_register.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_commission_register.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_commission_register.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_commission_register.country is '国家';
comment on column ${iol_schema}.ncbs_rb_commission_register.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_commission_register.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_commission_register.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_commission_register.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_commission_register.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_commission_register.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_commission_register.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_client_tel is '代办/代理人电话';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_reason is '经办理由';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_relation is '代办人关系';
comment on column ${iol_schema}.ncbs_rb_commission_register.company is '法人';
comment on column ${iol_schema}.ncbs_rb_commission_register.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_commission_register.is_commission is '是否代办人';
comment on column ${iol_schema}.ncbs_rb_commission_register.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_commission_register.program_id is '交易代码';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_expire_date is '交易代办人证件证件失效日期';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_start_date is '代办人证件开始日期';
comment on column ${iol_schema}.ncbs_rb_commission_register.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_commission_register.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_commission_register.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_client_name is '代办人名称';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_client_no is '代办人客户号';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_document_id is '代办人证件号码';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_document_type is '代办人证件类型';
comment on column ${iol_schema}.ncbs_rb_commission_register.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_commission_register.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_confirm_result is '核实结果';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_confirm_tel is '核实电话';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_confirm_time is '核实时间';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_confirm_user_id_key1 is '代办核实员工号1';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_confirm_user_id_key2 is '代办核实员工号2';
comment on column ${iol_schema}.ncbs_rb_commission_register.commission_flag is '是否代理标志';
comment on column ${iol_schema}.ncbs_rb_commission_register.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_commission_register.etl_timestamp is 'ETL处理时间戳';
