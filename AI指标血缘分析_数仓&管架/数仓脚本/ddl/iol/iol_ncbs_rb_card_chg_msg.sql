/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_card_chg_msg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_card_chg_msg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_card_chg_msg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_card_chg_msg(
    client_no varchar2(16) -- 客户编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,error_code varchar2(50) -- 错误码
    ,error_msg varchar2(3000) -- 错误代码
    ,send_no number(5) -- 发送次数
    ,send_seq_no varchar2(50) -- 发送流水号
    ,seq_no varchar2(50) -- 序号
    ,send_end_time varchar2(26) -- 发送结束时间
    ,send_start_time varchar2(26) -- 发送开始时间
    ,new_card_no varchar2(50) -- 新卡号
    ,old_card_no varchar2(50) -- 原卡号
    ,msg_notice_type varchar2(2) -- 通知类型
    ,rb_status varchar2(1) -- 存款客户合并处理状态
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
grant select on ${iol_schema}.ncbs_rb_card_chg_msg to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_card_chg_msg to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_card_chg_msg to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_card_chg_msg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_card_chg_msg is '换卡信息登记表';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.error_code is '错误码';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.error_msg is '错误代码';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.send_no is '发送次数';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.send_seq_no is '发送流水号';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.send_end_time is '发送结束时间';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.send_start_time is '发送开始时间';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.new_card_no is '新卡号';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.old_card_no is '原卡号';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.msg_notice_type is '通知类型';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.rb_status is '存款客户合并处理状态';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_card_chg_msg.etl_timestamp is 'ETL处理时间戳';
