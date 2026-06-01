/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_gain_sin_card_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_gain_sin_card_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_gain_sin_card_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_gain_sin_card_info(
    client_no varchar2(16) -- 客户编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,gain_type varchar2(1) -- 卡片领取方式
    ,make_card_type varchar2(1) -- 制卡类型
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,gain_status varchar2(1) -- 领取状态
    ,med_ins_card_no varchar2(50) -- 医保卡号
    ,sin_card_no varchar2(50) -- 金融卡号
    ,in_date date -- 入库日期
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
grant select on ${iol_schema}.ncbs_rb_gain_sin_card_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_gain_sin_card_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_gain_sin_card_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_gain_sin_card_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_gain_sin_card_info is '社保卡领取信息表';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.gain_type is '卡片领取方式';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.make_card_type is '制卡类型';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.gain_status is '领取状态';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.med_ins_card_no is '医保卡号';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.sin_card_no is '金融卡号';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.in_date is '入库日期';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_gain_sin_card_info.etl_timestamp is 'ETL处理时间戳';
