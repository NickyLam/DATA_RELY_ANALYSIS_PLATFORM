/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_wechat_amt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_wechat_amt_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_wechat_amt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_wechat_amt_info(
    batch_seq_no varchar2(50) -- 批次明细序号
    ,company varchar2(20) -- 法人
    ,channel varchar2(10) -- 渠道
    ,effect_date date -- 产品生效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,min_bal number(17,2) -- 最小余额
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
grant select on ${iol_schema}.ncbs_rb_wechat_amt_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_wechat_amt_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_wechat_amt_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_wechat_amt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_wechat_amt_info is '微信银行动作阈值表';
comment on column ${iol_schema}.ncbs_rb_wechat_amt_info.batch_seq_no is '批次明细序号';
comment on column ${iol_schema}.ncbs_rb_wechat_amt_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_wechat_amt_info.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_wechat_amt_info.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_wechat_amt_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_wechat_amt_info.min_bal is '最小余额';
comment on column ${iol_schema}.ncbs_rb_wechat_amt_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_wechat_amt_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_wechat_amt_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_wechat_amt_info.etl_timestamp is 'ETL处理时间戳';
