/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_restraint_control_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_restraint_control_details
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_restraint_control_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_restraint_control_details(
    expression varchar2(200) -- 表达式
    ,prod_type varchar2(12) -- 产品编号
    ,restraint_type varchar2(3) -- 限制类型
    ,tran_type varchar2(10) -- 交易类型
    ,company varchar2(20) -- 法人
    ,event_type varchar2(20) -- 事件类型
    ,res_class varchar2(5) -- 限制分类
    ,serv_id varchar2(50) -- 服务标识号
    ,channel varchar2(10) -- 渠道
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_restraint_control_details to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_restraint_control_details to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_restraint_control_details to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_restraint_control_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_restraint_control_details is '限制检查控制详情';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.expression is '表达式';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.restraint_type is '限制类型';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.company is '法人';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.res_class is '限制分类';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.serv_id is '服务标识号';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.channel is '渠道';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_restraint_control_details.etl_timestamp is 'ETL处理时间戳';
