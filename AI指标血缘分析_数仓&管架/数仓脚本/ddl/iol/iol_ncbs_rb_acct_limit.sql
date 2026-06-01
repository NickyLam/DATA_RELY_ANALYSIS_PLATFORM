/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_limit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_limit
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_limit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_limit(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,dac_value varchar2(200) -- dac值防篡改加密
    ,holding_times number(5) -- 已占用次数
    ,release_priority varchar2(20) -- 还款释放优先级
    ,source_type varchar2(6) -- 渠道编号
    ,total_times number(5) -- 扣划总次数
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,holding_limit number(17,2) -- 已占用额度
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,total_limit number(17,2) -- 总额度
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
grant select on ${iol_schema}.ncbs_rb_acct_limit to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_limit to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_limit to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_limit to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_limit is '账户额度表';
comment on column ${iol_schema}.ncbs_rb_acct_limit.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_limit.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_limit.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_limit.dac_value is 'dac值防篡改加密';
comment on column ${iol_schema}.ncbs_rb_acct_limit.holding_times is '已占用次数';
comment on column ${iol_schema}.ncbs_rb_acct_limit.release_priority is '还款释放优先级';
comment on column ${iol_schema}.ncbs_rb_acct_limit.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_acct_limit.total_times is '扣划总次数';
comment on column ${iol_schema}.ncbs_rb_acct_limit.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_acct_limit.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_limit.holding_limit is '已占用额度';
comment on column ${iol_schema}.ncbs_rb_acct_limit.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_acct_limit.total_limit is '总额度';
comment on column ${iol_schema}.ncbs_rb_acct_limit.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_limit.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_limit.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_limit.etl_timestamp is 'ETL处理时间戳';
