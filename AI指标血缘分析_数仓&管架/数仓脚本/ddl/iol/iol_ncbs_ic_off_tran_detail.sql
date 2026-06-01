/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_ic_off_tran_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_ic_off_tran_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_ic_off_tran_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_ic_off_tran_detail(
    batch_no varchar2(200) -- 脱机批次号
    ,off_tran_seq varchar2(200) -- 脱机流水号
    ,internal_key varchar2(200) -- 顺序号
    ,card_no varchar2(76) -- 卡号
    ,tran_amt number(17,2) -- 交易金额
    ,merch_no varchar2(120) -- 商户编号
    ,merch_type varchar2(16) -- 商户类型
    ,tran_date date -- 平台交易日期
    ,time_stamp varchar2(56) -- 交易时间
    ,cups_date date -- 银联清算日期
    ,ret_code varchar2(80) -- 交易状态码
    ,ret_msg varchar2(800) -- 服务状态描述
    ,tran_type varchar2(16) -- 交易类型
    ,line varchar2(3200) -- 行记录
    ,tran_address varchar2(400) -- 交易地址
    ,flag varchar2(4) -- 调账标志
    ,acct_flag varchar2(4) -- 记账标志
    ,settle_date date -- 入账日期
    ,term_no varchar2(120) -- 交易终端编号
    ,term_seq varchar2(120) -- 终端流水号
    ,ic_card_seq varchar2(12) -- 卡序列号
    ,ic_aid varchar2(128) -- 应用标识符
    ,other_amt number(17,2) -- 其他金额
    ,app_cry varchar2(200) -- 应用密文（卡片生成的交易证书tc）
    ,term_coun_code varchar2(12) -- 终端国家代码
    ,cups_ccy varchar2(12) -- 银联币种
    ,tvr varchar2(40) -- 终端验证结果
    ,app_count_num varchar2(16) -- 应用交易计数器
    ,not_foreknow_num varchar2(32) -- 不可预知数
    ,app_alter_spe varchar2(16) -- 应用交互特征
    ,ic_act_bal number(17,2) -- 电子现金账户余额
    ,app_data varchar2(400) -- 发卡行应用数据（卡片验证结果cvr在该字段中）
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
grant select on ${iol_schema}.ncbs_ic_off_tran_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_ic_off_tran_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_ic_off_tran_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_ic_off_tran_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_ic_off_tran_detail is 'IC卡脱机交易交易流水信息表';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.batch_no is '脱机批次号';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.off_tran_seq is '脱机流水号';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.internal_key is '顺序号';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.card_no is '卡号';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.merch_no is '商户编号';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.merch_type is '商户类型';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.tran_date is '平台交易日期';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.time_stamp is '交易时间';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.cups_date is '银联清算日期';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.ret_code is '交易状态码';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.ret_msg is '服务状态描述';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.line is '行记录';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.tran_address is '交易地址';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.flag is '调账标志';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.acct_flag is '记账标志';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.settle_date is '入账日期';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.term_no is '交易终端编号';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.term_seq is '终端流水号';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.ic_card_seq is '卡序列号';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.ic_aid is '应用标识符';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.other_amt is '其他金额';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.app_cry is '应用密文（卡片生成的交易证书tc）';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.term_coun_code is '终端国家代码';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.cups_ccy is '银联币种';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.tvr is '终端验证结果';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.app_count_num is '应用交易计数器';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.not_foreknow_num is '不可预知数';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.app_alter_spe is '应用交互特征';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.ic_act_bal is '电子现金账户余额';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.app_data is '发卡行应用数据（卡片验证结果cvr在该字段中）';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_ic_off_tran_detail.etl_timestamp is 'ETL处理时间戳';
