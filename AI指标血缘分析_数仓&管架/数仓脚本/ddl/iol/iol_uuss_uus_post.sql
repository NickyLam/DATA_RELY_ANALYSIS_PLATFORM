/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uuss_uus_post
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uuss_uus_post
whenever sqlerror continue none;
drop table ${iol_schema}.uuss_uus_post purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uuss_uus_post(
    postcode varchar2(150) -- 岗位编号
    ,organcode varchar2(18) -- 机构编码
    ,postname varchar2(150) -- 岗位名称
    ,isbasepost varchar2(2) -- 基准岗位标识
    ,linecode varchar2(18) -- 条线编码
    ,serialcode varchar2(18) -- 序列编码
    ,type varchar2(12) -- 类型
    ,enablestate varchar2(2) -- 启用状态
    ,placecode varchar2(75) -- 职务编码
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
grant select on ${iol_schema}.uuss_uus_post to ${iml_schema};
grant select on ${iol_schema}.uuss_uus_post to ${icl_schema};
grant select on ${iol_schema}.uuss_uus_post to ${idl_schema};
grant select on ${iol_schema}.uuss_uus_post to ${iel_schema};

-- comment
comment on table ${iol_schema}.uuss_uus_post is '岗位表';
comment on column ${iol_schema}.uuss_uus_post.postcode is '岗位编号';
comment on column ${iol_schema}.uuss_uus_post.organcode is '机构编码';
comment on column ${iol_schema}.uuss_uus_post.postname is '岗位名称';
comment on column ${iol_schema}.uuss_uus_post.isbasepost is '基准岗位标识';
comment on column ${iol_schema}.uuss_uus_post.linecode is '条线编码';
comment on column ${iol_schema}.uuss_uus_post.serialcode is '序列编码';
comment on column ${iol_schema}.uuss_uus_post.type is '类型';
comment on column ${iol_schema}.uuss_uus_post.enablestate is '启用状态';
comment on column ${iol_schema}.uuss_uus_post.placecode is '职务编码';
comment on column ${iol_schema}.uuss_uus_post.currdate is '创建日期';
comment on column ${iol_schema}.uuss_uus_post.currtime is '创建时间';
comment on column ${iol_schema}.uuss_uus_post.updatedate is '更新日期';
comment on column ${iol_schema}.uuss_uus_post.updatetime is '更新时间';
comment on column ${iol_schema}.uuss_uus_post.createuser is '创建人';
comment on column ${iol_schema}.uuss_uus_post.updateuser is '最后修改人';
comment on column ${iol_schema}.uuss_uus_post.start_dt is '开始时间';
comment on column ${iol_schema}.uuss_uus_post.end_dt is '结束时间';
comment on column ${iol_schema}.uuss_uus_post.id_mark is '增删标志';
comment on column ${iol_schema}.uuss_uus_post.etl_timestamp is 'ETL处理时间戳';
