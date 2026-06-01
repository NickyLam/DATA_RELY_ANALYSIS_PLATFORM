/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uuss_uus_place
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uuss_uus_place
whenever sqlerror continue none;
drop table ${iol_schema}.uuss_uus_place purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uuss_uus_place(
    placecode varchar2(75) -- 职务编码
    ,placename varchar2(150) -- 职务名称
    ,placetypecode varchar2(75) -- 职务类别编码
    ,enablestate varchar2(2) -- 启用状态
    ,currdate varchar2(12) -- 创建日期
    ,currtime varchar2(9) -- 创建时间
    ,updatedate varchar2(12) -- 更新日期
    ,updatetime varchar2(9) -- 更新时间
    ,createuser varchar2(12) -- 创建人
    ,updateuser varchar2(12) -- 最后修改人
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
grant select on ${iol_schema}.uuss_uus_place to ${iml_schema};
grant select on ${iol_schema}.uuss_uus_place to ${icl_schema};
grant select on ${iol_schema}.uuss_uus_place to ${idl_schema};
grant select on ${iol_schema}.uuss_uus_place to ${iel_schema};

-- comment
comment on table ${iol_schema}.uuss_uus_place is '职务表';
comment on column ${iol_schema}.uuss_uus_place.placecode is '职务编码';
comment on column ${iol_schema}.uuss_uus_place.placename is '职务名称';
comment on column ${iol_schema}.uuss_uus_place.placetypecode is '职务类别编码';
comment on column ${iol_schema}.uuss_uus_place.enablestate is '启用状态';
comment on column ${iol_schema}.uuss_uus_place.currdate is '创建日期';
comment on column ${iol_schema}.uuss_uus_place.currtime is '创建时间';
comment on column ${iol_schema}.uuss_uus_place.updatedate is '更新日期';
comment on column ${iol_schema}.uuss_uus_place.updatetime is '更新时间';
comment on column ${iol_schema}.uuss_uus_place.createuser is '创建人';
comment on column ${iol_schema}.uuss_uus_place.updateuser is '最后修改人';
comment on column ${iol_schema}.uuss_uus_place.start_dt is '开始时间';
comment on column ${iol_schema}.uuss_uus_place.end_dt is '结束时间';
comment on column ${iol_schema}.uuss_uus_place.id_mark is '增删标志';
comment on column ${iol_schema}.uuss_uus_place.etl_timestamp is 'ETL处理时间戳';
