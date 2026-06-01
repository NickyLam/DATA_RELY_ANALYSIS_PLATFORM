/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_reg
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_reg(
    inr varchar2(12) -- 唯一键值
    ,cod varchar2(3) -- 地域key值
    ,ver varchar2(6) -- 版本号
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
grant select on ${iol_schema}.isbs_reg to ${iml_schema};
grant select on ${iol_schema}.isbs_reg to ${icl_schema};
grant select on ${iol_schema}.isbs_reg to ${idl_schema};
grant select on ${iol_schema}.isbs_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_reg is '地区类别信息';
comment on column ${iol_schema}.isbs_reg.inr is '唯一键值';
comment on column ${iol_schema}.isbs_reg.cod is '地域key值';
comment on column ${iol_schema}.isbs_reg.ver is '版本号';
comment on column ${iol_schema}.isbs_reg.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_reg.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_reg.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_reg.etl_timestamp is 'ETL处理时间戳';
