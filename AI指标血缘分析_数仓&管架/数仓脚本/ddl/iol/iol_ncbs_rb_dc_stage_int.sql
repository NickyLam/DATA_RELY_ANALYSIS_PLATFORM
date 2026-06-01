/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_stage_int
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_stage_int
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_stage_int purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_int(
    ccy varchar2(3) -- 币种
    ,int_type varchar2(5) -- 利率类型
    ,prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,event_type varchar2(20) -- 事件类型
    ,int_calc_type varchar2(1) -- 计息类型
    ,issue_year varchar2(5) -- 发行年度
    ,seq_no varchar2(50) -- 序号
    ,stage_code varchar2(50) -- 期次代码
    ,stage_prod_class varchar2(5) -- 期次产品分类
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,actual_rate number(15,8) -- 行内利率
    ,float_rate number(15,8) -- 浮动利率
    ,real_rate number(15,8) -- 执行利率
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
grant select on ${iol_schema}.ncbs_rb_dc_stage_int to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_int to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_int to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_int to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_stage_int is '期次管理利率信息表';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.int_calc_type is '计息类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.issue_year is '发行年度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.stage_prod_class is '期次产品分类';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_int.etl_timestamp is 'ETL处理时间戳';
