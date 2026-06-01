/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_uuss_uus_place
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_uuss_uus_place purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_uuss_uus_place(
etl_dt date --数据日期
,placetypecode varchar2(50) --职务类别编码
,enablestate varchar2(1) --启用状态
,currdate varchar2(8) --创建日期
,currtime varchar2(6) --创建时间
,updatedate varchar2(8) --更新日期
,updatetime varchar2(6) --更新时间
,createuser varchar2(8) --创建人
,updateuser varchar2(8) --最后修改人
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,placecode varchar2(50) --职务编码
,placename varchar2(100) --职务名称

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_uuss_uus_place to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_uuss_uus_place is '职务表';
comment on column ${idl_schema}.oass_uuss_uus_place.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_uuss_uus_place.placetypecode is '职务类别编码';
comment on column ${idl_schema}.oass_uuss_uus_place.enablestate is '启用状态';
comment on column ${idl_schema}.oass_uuss_uus_place.currdate is '创建日期';
comment on column ${idl_schema}.oass_uuss_uus_place.currtime is '创建时间';
comment on column ${idl_schema}.oass_uuss_uus_place.updatedate is '更新日期';
comment on column ${idl_schema}.oass_uuss_uus_place.updatetime is '更新时间';
comment on column ${idl_schema}.oass_uuss_uus_place.createuser is '创建人';
comment on column ${idl_schema}.oass_uuss_uus_place.updateuser is '最后修改人';
comment on column ${idl_schema}.oass_uuss_uus_place.start_dt is '开始时间';
comment on column ${idl_schema}.oass_uuss_uus_place.end_dt is '结束时间';
comment on column ${idl_schema}.oass_uuss_uus_place.id_mark is '增删标志';
comment on column ${idl_schema}.oass_uuss_uus_place.placecode is '职务编码';
comment on column ${idl_schema}.oass_uuss_uus_place.placename is '职务名称';

