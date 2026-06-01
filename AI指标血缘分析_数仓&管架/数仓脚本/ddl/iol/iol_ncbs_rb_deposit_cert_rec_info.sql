/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_deposit_cert_rec_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_deposit_cert_rec_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_deposit_cert_rec_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_deposit_cert_rec_info(
    client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,cert_num number(5) -- 证明张数
    ,cert_type varchar2(1) -- 存款证明类型
    ,ch_head varchar2(50) -- 中文抬头
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,deposit_cert_no varchar2(50) -- 存款证明编号
    ,deposit_cert_operate_type varchar2(2) -- 存款证明操作类型
    ,deposit_cert_status varchar2(1) -- 存款证明状态
    ,en_head varchar2(200) -- 英文抬头
    ,prefix varchar2(10) -- 前缀
    ,print_cnt number(5) -- 打印次数
    ,repair_type varchar2(3) -- 补打类型
    ,res_seq_no varchar2(50) -- 限制编号
    ,seq_no varchar2(50) -- 序号
    ,cancel_date date -- 取消日期
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
grant select on ${iol_schema}.ncbs_rb_deposit_cert_rec_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_deposit_cert_rec_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_deposit_cert_rec_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_deposit_cert_rec_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_deposit_cert_rec_info is '存款证明流水表';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.term is '存期';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.cert_num is '证明张数';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.cert_type is '存款证明类型';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.ch_head is '中文抬头';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.deposit_cert_no is '存款证明编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.deposit_cert_operate_type is '存款证明操作类型';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.deposit_cert_status is '存款证明状态';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.en_head is '英文抬头';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.print_cnt is '打印次数';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.repair_type is '补打类型';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.cancel_date is '取消日期';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.cert_end_date is '证明截止日期';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.delete_date is '删除日期';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.repair_time is '补打时间';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.cancel_auth_user_id is '取消授权柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.cancel_reason is '撤销原因';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.cancel_user_id is '取消柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.cert_bal is '证明余额';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.del_auth_user_id is '删除授权柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.del_user_id is '删除柜员';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.pre_reference is '原交易参考号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.voucher_end_no is '凭证终止号码';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_deposit_cert_rec_info.etl_timestamp is 'ETL处理时间戳';
