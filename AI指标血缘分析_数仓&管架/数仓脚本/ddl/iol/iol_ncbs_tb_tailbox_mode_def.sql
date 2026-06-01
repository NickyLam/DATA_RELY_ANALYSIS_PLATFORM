/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_tailbox_mode_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_tailbox_mode_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_tailbox_mode_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_tailbox_mode_def(
    hierarchy_code varchar2(2) -- 机构级别
    ,tailbox_mode varchar2(1) -- 尾箱模式
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
grant select on ${iol_schema}.ncbs_tb_tailbox_mode_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_tailbox_mode_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_tailbox_mode_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_tailbox_mode_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_tailbox_mode_def is '尾箱模式参数表';
comment on column ${iol_schema}.ncbs_tb_tailbox_mode_def.hierarchy_code is '机构级别';
comment on column ${iol_schema}.ncbs_tb_tailbox_mode_def.tailbox_mode is '尾箱模式';
comment on column ${iol_schema}.ncbs_tb_tailbox_mode_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_tailbox_mode_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_tailbox_mode_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_tailbox_mode_def.etl_timestamp is 'ETL处理时间戳';
