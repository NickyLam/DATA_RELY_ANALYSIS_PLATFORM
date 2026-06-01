/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_deposit_cert_rec
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_deposit_cert_rec
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_deposit_cert_rec purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_deposit_cert_rec(
    client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,cert_num number(5) -- 证明张数
    ,cert_type varchar2(1) -- 存款证明类型
    ,cert_use varchar2(200) -- 存款证明用途
    ,ch_head varchar2(50) -- 中文抬头
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,deposit_cert_no varchar2(50) -- 存款证明编号
    ,deposit_cert_status varchar2(1) -- 存款证明状态
    ,en_head varchar2(200) -- 英文抬头
    ,prefix varchar2(10) -- 前缀
    ,print_cnt number(5) -- 打印次数
    ,repair_reason varchar2(1) -- 补打原因
    ,res_seq_no varchar2(50) -- 限制编号
    ,seq_no varchar2(50) -- 序号
    ,system_id varchar2(20) -- 系统id
    ,cert_end_date date -- 证明截止日期
    ,delete_date date -- 删除日期
    ,repair_time varchar2(26) -- 补打时间
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,cancel_auth_user_id varchar2(8) -- 取消授权柜员
    ,cancel_reason varchar2(200) -- 撤销原因
    ,cancel_user_id varchar2(8) -- 取消柜员
    ,cert_bal number(17,2) -- 证明余额
    ,del_auth_user_id varchar2(8) -- 删除授权柜员
    ,del_user_id varchar2(8) -- 删除柜员
    ,pre_reference varchar2(50) -- 原交易参考号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,voucher_end_no varchar2(50) -- 凭证终止号码
    ,voucher_start_no varchar2(50) -- 凭证起始号码
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
grant select on ${iol_schema}.ncbs_rb_deposit_cert_rec to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_deposit_cert_rec to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_deposit_cert_rec to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_deposit_cert_rec to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_deposit_cert_rec is '存款证明处理信息';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.term is '存期';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.cert_num is '证明张数';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.cert_type is '存款证明类型';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.cert_use is '存款证明用途';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.ch_head is '中文抬头';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.company is '法人';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.deposit_cert_no is '存款证明编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.deposit_cert_status is '存款证明状态';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.en_head is '英文抬头';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.print_cnt is '打印次数';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.repair_reason is '补打原因';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.system_id is '系统id';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.cert_end_date is '证明截止日期';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.delete_date is '删除日期';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.repair_time is '补打时间';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.cancel_auth_user_id is '取消授权柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.cancel_reason is '撤销原因';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.cancel_user_id is '取消柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.cert_bal is '证明余额';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.del_auth_user_id is '删除授权柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.del_user_id is '删除柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.pre_reference is '原交易参考号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.voucher_end_no is '凭证终止号码';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec.etl_timestamp is 'ETL处理时间戳';
