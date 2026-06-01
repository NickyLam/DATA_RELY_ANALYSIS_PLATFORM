/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bopcod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bopcod
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bopcod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bopcod(
    inr varchar2(12) -- 内部唯一 id
    ,ver varchar2(6) -- 版本号
    ,cod varchar2(9) -- 
    ,dir varchar2(2) -- 进出方向
    ,typ varchar2(2) -- 
    ,txt varchar2(240) -- 描述
    ,sta varchar2(2) -- 状态标志
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
grant select on ${iol_schema}.isbs_bopcod to ${iml_schema};
grant select on ${iol_schema}.isbs_bopcod to ${icl_schema};
grant select on ${iol_schema}.isbs_bopcod to ${idl_schema};
grant select on ${iol_schema}.isbs_bopcod to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bopcod is '收支申报交易编码表';
comment on column ${iol_schema}.isbs_bopcod.inr is '内部唯一 id';
comment on column ${iol_schema}.isbs_bopcod.ver is '版本号';
comment on column ${iol_schema}.isbs_bopcod.cod is '';
comment on column ${iol_schema}.isbs_bopcod.dir is '进出方向';
comment on column ${iol_schema}.isbs_bopcod.typ is '';
comment on column ${iol_schema}.isbs_bopcod.txt is '描述';
comment on column ${iol_schema}.isbs_bopcod.sta is '状态标志';
comment on column ${iol_schema}.isbs_bopcod.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bopcod.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bopcod.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bopcod.etl_timestamp is 'ETL处理时间戳';
