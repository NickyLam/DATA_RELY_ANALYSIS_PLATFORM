/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_stage_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_stage_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_stage_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_info(
    ccy varchar2(3) -- 币种
    ,prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,issue_year varchar2(5) -- 发行年度
    ,stage_code varchar2(50) -- 期次代码
    ,stage_prod_class varchar2(5) -- 期次产品分类
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,distribute_limit number(17,2) -- 已分配额度
    ,holding_limit number(17,2) -- 已占用额度
    ,leave_limit number(17,2) -- 剩余额度
    ,prev_holding_limit number(17,2) -- 上次已占用额度
    ,prev_used_amt number(17,2) -- 上次已使用额度
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
grant select on ${iol_schema}.ncbs_rb_dc_stage_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_stage_info is '期次历史信息表';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.issue_year is '发行年度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.stage_prod_class is '期次产品分类';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.distribute_limit is '已分配额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.holding_limit is '已占用额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.leave_limit is '剩余额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.prev_holding_limit is '上次已占用额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.prev_used_amt is '上次已使用额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.total_limit is '总额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_info.etl_timestamp is 'ETL处理时间戳';
