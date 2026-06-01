/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orms_t21_disclosure
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orms_t21_disclosure
whenever sqlerror continue none;
drop table ${iol_schema}.orms_t21_disclosure purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orms_t21_disclosure(
    id varchar2(15) -- id，主键
    ,name varchar2(150) -- 统计事件名称
    ,flag varchar2(2) -- 是否有效(0:否，1:是）
    ,pid varchar2(15) -- 上级id
    ,seq varchar2(15) -- 序号
    ,type varchar2(15) -- 类型：1：g4d1，2：g4d2，3：ora，4：or1，5：损失数据统计
    ,model varchar2(48) -- 关联查询字段
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
grant select on ${iol_schema}.orms_t21_disclosure to ${iml_schema};
grant select on ${iol_schema}.orms_t21_disclosure to ${icl_schema};
grant select on ${iol_schema}.orms_t21_disclosure to ${idl_schema};
grant select on ${iol_schema}.orms_t21_disclosure to ${iel_schema};

-- comment
comment on table ${iol_schema}.orms_t21_disclosure is '披露报表类型';
comment on column ${iol_schema}.orms_t21_disclosure.id is 'id，主键';
comment on column ${iol_schema}.orms_t21_disclosure.name is '统计事件名称';
comment on column ${iol_schema}.orms_t21_disclosure.flag is '是否有效(0:否，1:是）';
comment on column ${iol_schema}.orms_t21_disclosure.pid is '上级id';
comment on column ${iol_schema}.orms_t21_disclosure.seq is '序号';
comment on column ${iol_schema}.orms_t21_disclosure.type is '类型：1：g4d1，2：g4d2，3：ora，4：or1，5：损失数据统计';
comment on column ${iol_schema}.orms_t21_disclosure.model is '关联查询字段';
comment on column ${iol_schema}.orms_t21_disclosure.start_dt is '开始时间';
comment on column ${iol_schema}.orms_t21_disclosure.end_dt is '结束时间';
comment on column ${iol_schema}.orms_t21_disclosure.id_mark is '增删标志';
comment on column ${iol_schema}.orms_t21_disclosure.etl_timestamp is 'ETL处理时间戳';
