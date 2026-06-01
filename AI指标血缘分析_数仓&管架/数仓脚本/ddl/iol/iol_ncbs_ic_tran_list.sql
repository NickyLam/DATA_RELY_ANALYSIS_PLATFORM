/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_ic_tran_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_ic_tran_list
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_ic_tran_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_ic_tran_list(
    tran_date date -- 平台交易日期
    ,tran_seq varchar2(200) -- 平台交易流水号
    ,txn_chn_num varchar2(24) -- 交易渠道编号
    ,glob_seq_num varchar2(132) -- 全局流水号
    ,biz_seq_num varchar2(132) -- 业务流水号
    ,sys_seq_num varchar2(256) -- 系统流水号
    ,txn_dt date -- 交易日期
    ,txn_tm timestamp -- 交易时间
    ,txn_tell varchar2(120) -- 交易柜员编号
    ,txn_org_num varchar2(36) -- 交易机构编号
    ,term_no varchar2(120) -- 交易终端编号
    ,merch_no varchar2(120) -- 商户编号
    ,setl_date date -- 清算日期
    ,card_no varchar2(76) -- 卡号
    ,ic_card_seq varchar2(12) -- 卡序列号
    ,oth_base_acct_no varchar2(200) -- 交易对手账号
    ,ccy varchar2(12) -- 交易币种
    ,tran_amt number(17,2) -- 交易金额
    ,tran_stat varchar2(4) -- 交易状态
    ,ret_code varchar2(40) -- 交易状态码
    ,ret_msg varchar2(800) -- 服务状态描述
    ,reference varchar2(200) -- 交易参考号
    ,ic_aid varchar2(128) -- 应用标识符
    ,tran_code varchar2(44) -- 交易码
    ,ic_atc varchar2(80) -- 交易计数器
    ,ic_act_bal number(17,2) -- 电子现金账户余额
    ,client_name varchar2(800) -- 客户名称
    ,document_type varchar2(16) -- 客户证件类型
    ,document_id varchar2(72) -- 客户证件号码
    ,commission_client_name varchar2(800) -- 代办人姓名
    ,commission_document_type varchar2(16) -- 代办人证件类型
    ,commission_document_id varchar2(72) -- 代办人证件号码
    ,commission_phone varchar2(120) -- 代办人电话
    ,agen_cd varchar2(80) -- 代理机构标识码
    ,cup_send_code varchar2(80) -- 发送机构标识码
    ,memo_cntt varchar2(400) -- 摘要
    ,db_cr_dir_cd varchar2(4) -- 借贷方向代码
    ,sys_trace_num varchar2(40) -- 系统跟踪号
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
grant select on ${iol_schema}.ncbs_ic_tran_list to ${iml_schema};
grant select on ${iol_schema}.ncbs_ic_tran_list to ${icl_schema};
grant select on ${iol_schema}.ncbs_ic_tran_list to ${idl_schema};
grant select on ${iol_schema}.ncbs_ic_tran_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_ic_tran_list is 'IC卡流水表';
comment on column ${iol_schema}.ncbs_ic_tran_list.tran_date is '平台交易日期';
comment on column ${iol_schema}.ncbs_ic_tran_list.tran_seq is '平台交易流水号';
comment on column ${iol_schema}.ncbs_ic_tran_list.txn_chn_num is '交易渠道编号';
comment on column ${iol_schema}.ncbs_ic_tran_list.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.ncbs_ic_tran_list.biz_seq_num is '业务流水号';
comment on column ${iol_schema}.ncbs_ic_tran_list.sys_seq_num is '系统流水号';
comment on column ${iol_schema}.ncbs_ic_tran_list.txn_dt is '交易日期';
comment on column ${iol_schema}.ncbs_ic_tran_list.txn_tm is '交易时间';
comment on column ${iol_schema}.ncbs_ic_tran_list.txn_tell is '交易柜员编号';
comment on column ${iol_schema}.ncbs_ic_tran_list.txn_org_num is '交易机构编号';
comment on column ${iol_schema}.ncbs_ic_tran_list.term_no is '交易终端编号';
comment on column ${iol_schema}.ncbs_ic_tran_list.merch_no is '商户编号';
comment on column ${iol_schema}.ncbs_ic_tran_list.setl_date is '清算日期';
comment on column ${iol_schema}.ncbs_ic_tran_list.card_no is '卡号';
comment on column ${iol_schema}.ncbs_ic_tran_list.ic_card_seq is '卡序列号';
comment on column ${iol_schema}.ncbs_ic_tran_list.oth_base_acct_no is '交易对手账号';
comment on column ${iol_schema}.ncbs_ic_tran_list.ccy is '交易币种';
comment on column ${iol_schema}.ncbs_ic_tran_list.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_ic_tran_list.tran_stat is '交易状态';
comment on column ${iol_schema}.ncbs_ic_tran_list.ret_code is '交易状态码';
comment on column ${iol_schema}.ncbs_ic_tran_list.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_ic_tran_list.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_ic_tran_list.ic_aid is '应用标识符';
comment on column ${iol_schema}.ncbs_ic_tran_list.tran_code is '交易码';
comment on column ${iol_schema}.ncbs_ic_tran_list.ic_atc is '交易计数器';
comment on column ${iol_schema}.ncbs_ic_tran_list.ic_act_bal is '电子现金账户余额';
comment on column ${iol_schema}.ncbs_ic_tran_list.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_ic_tran_list.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_ic_tran_list.document_id is '客户证件号码';
comment on column ${iol_schema}.ncbs_ic_tran_list.commission_client_name is '代办人姓名';
comment on column ${iol_schema}.ncbs_ic_tran_list.commission_document_type is '代办人证件类型';
comment on column ${iol_schema}.ncbs_ic_tran_list.commission_document_id is '代办人证件号码';
comment on column ${iol_schema}.ncbs_ic_tran_list.commission_phone is '代办人电话';
comment on column ${iol_schema}.ncbs_ic_tran_list.agen_cd is '代理机构标识码';
comment on column ${iol_schema}.ncbs_ic_tran_list.cup_send_code is '发送机构标识码';
comment on column ${iol_schema}.ncbs_ic_tran_list.memo_cntt is '摘要';
comment on column ${iol_schema}.ncbs_ic_tran_list.db_cr_dir_cd is '借贷方向代码';
comment on column ${iol_schema}.ncbs_ic_tran_list.sys_trace_num is '系统跟踪号';
comment on column ${iol_schema}.ncbs_ic_tran_list.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_ic_tran_list.etl_timestamp is 'ETL处理时间戳';
