/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a49teftrantypeinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a49teftrantypeinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a49teftrantypeinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a49teftrantypeinfo(
    trantype varchar2(8) -- 种类代码
    ,trantypenm varchar2(90) -- 种类说明
    ,reserver varchar2(90) -- 
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
grant select on ${iol_schema}.mpcs_a49teftrantypeinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a49teftrantypeinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a49teftrantypeinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a49teftrantypeinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a49teftrantypeinfo is '金融服务平台业务种类表';
comment on column ${iol_schema}.mpcs_a49teftrantypeinfo.trantype is '种类代码';
comment on column ${iol_schema}.mpcs_a49teftrantypeinfo.trantypenm is '种类说明';
comment on column ${iol_schema}.mpcs_a49teftrantypeinfo.reserver is '';
comment on column ${iol_schema}.mpcs_a49teftrantypeinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a49teftrantypeinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a49teftrantypeinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a49teftrantypeinfo.etl_timestamp is 'ETL处理时间戳';
