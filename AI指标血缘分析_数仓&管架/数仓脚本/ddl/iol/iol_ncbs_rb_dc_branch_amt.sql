/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_branch_amt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_branch_amt
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_branch_amt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_branch_amt(
    branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,prod_type varchar2(12) -- 产品编号
    ,back_status varchar2(1) -- 额度回收状态
    ,company varchar2(20) -- 法人
    ,issue_year varchar2(5) -- 发行年度
    ,stage_code varchar2(50) -- 期次代码
    ,stage_prod_class varchar2(5) -- 期次产品分类
    ,channel varchar2(10) -- 渠道
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,distribute_limit number(17,2) -- 已分配额度
    ,holding_limit number(17,2) -- 已占用额度
    ,leave_limit number(17,2) -- 剩余额度
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
grant select on ${iol_schema}.ncbs_rb_dc_branch_amt to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_branch_amt to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_branch_amt to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_branch_amt to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_branch_amt is '机构配额信息表';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.branch is '机构编号';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.back_status is '额度回收状态';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.issue_year is '发行年度';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.stage_prod_class is '期次产品分类';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.distribute_limit is '已分配额度';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.holding_limit is '已占用额度';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.leave_limit is '剩余额度';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.total_limit is '总额度';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_dc_branch_amt.etl_timestamp is 'ETL处理时间戳';
