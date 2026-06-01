/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_eb_gl_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_eb_gl_map
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_eb_gl_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_eb_gl_map(
    gl_code varchar2(20) -- 科目代码
    ,prod_type varchar2(12) -- 产品编号
    ,tran_type varchar2(10) -- 交易类型
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,event_type varchar2(20) -- 事件类型
    ,oth_gl_code varchar2(20) -- 对方科目代码
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
grant select on ${iol_schema}.ncbs_rb_eb_gl_map to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_eb_gl_map to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_eb_gl_map to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_eb_gl_map to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_eb_gl_map is '电子汇票记账交易明细配置表';
comment on column ${iol_schema}.ncbs_rb_eb_gl_map.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_rb_eb_gl_map.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_eb_gl_map.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_eb_gl_map.company is '法人';
comment on column ${iol_schema}.ncbs_rb_eb_gl_map.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_eb_gl_map.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_eb_gl_map.oth_gl_code is '对方科目代码';
comment on column ${iol_schema}.ncbs_rb_eb_gl_map.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_eb_gl_map.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_eb_gl_map.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_eb_gl_map.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_eb_gl_map.etl_timestamp is 'ETL处理时间戳';
