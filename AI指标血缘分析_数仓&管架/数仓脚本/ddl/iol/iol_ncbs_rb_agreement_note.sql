/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_note
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_note
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_note purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_note(
    client_no varchar2(16) -- 客户编号
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_status varchar2(2) -- 协议状态
    ,agreement_type varchar2(5) -- 协议类型
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,lowest_amt number(17,2) -- 保底金额
    ,end_date date -- 结束日期
    ,last_change_date date -- 最后修改日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,fin_amt_unit number(17,2) -- 理财基数
    ,fin_prod_type varchar2(12) -- 理财产品编号
    ,int_min_amt number(17,2) -- 最小起存金额
    ,real_rate number(15,8) -- 执行利率
    ,fin_fixed_amt number(17,2) -- 理财固定金额
    ,fin_turn_method varchar2(5) -- 理财转回方式
    ,note_turn_type varchar2(1) -- 理财转回类型
    ,fin_cycle_method varchar2(1) -- 理财利息结算方式
    ,fin_renew_type varchar2(1) -- 理财转存类型
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
grant select on ${iol_schema}.ncbs_rb_agreement_note to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_note to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_note to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_note to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_note is '理财登记簿协议表';
comment on column ${iol_schema}.ncbs_rb_agreement_note.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_note.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_agreement_note.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_agreement_note.term is '存期';
comment on column ${iol_schema}.ncbs_rb_agreement_note.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_agreement_note.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_note.agreement_status is '协议状态';
comment on column ${iol_schema}.ncbs_rb_agreement_note.agreement_type is '协议类型';
comment on column ${iol_schema}.ncbs_rb_agreement_note.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_note.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_agreement_note.lowest_amt is '保底金额';
comment on column ${iol_schema}.ncbs_rb_agreement_note.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_agreement_note.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_agreement_note.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_agreement_note.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_note.fin_amt_unit is '理财基数';
comment on column ${iol_schema}.ncbs_rb_agreement_note.fin_prod_type is '理财产品编号';
comment on column ${iol_schema}.ncbs_rb_agreement_note.int_min_amt is '最小起存金额';
comment on column ${iol_schema}.ncbs_rb_agreement_note.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_agreement_note.fin_fixed_amt is '理财固定金额';
comment on column ${iol_schema}.ncbs_rb_agreement_note.fin_turn_method is '理财转回方式';
comment on column ${iol_schema}.ncbs_rb_agreement_note.note_turn_type is '理财转回类型';
comment on column ${iol_schema}.ncbs_rb_agreement_note.fin_cycle_method is '理财利息结算方式';
comment on column ${iol_schema}.ncbs_rb_agreement_note.fin_renew_type is '理财转存类型';
comment on column ${iol_schema}.ncbs_rb_agreement_note.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_note.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_note.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_note.etl_timestamp is 'ETL处理时间戳';
