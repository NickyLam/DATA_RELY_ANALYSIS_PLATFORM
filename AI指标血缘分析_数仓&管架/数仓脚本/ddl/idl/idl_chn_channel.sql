/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl chn_channel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.chn_channel
whenever sqlerror continue none;
drop table ${idl_schema}.chn_channel purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.chn_channel(
    etl_dt date -- 数据日期   
    ,chn_id varchar2(60) -- 渠道编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,chn_type_cd varchar2(10) -- 渠道类型代码   
    ,chn_name varchar2(500) -- 渠道名称   
    ,chn_status_cd varchar2(10) -- 渠道状态代码   
    ,effect_dt date -- 生效日期   
    ,invalid_dt date -- 失效日期   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.chn_channel to ${iel_schema};

-- comment
comment on table ${idl_schema}.chn_channel is '渠道';
comment on column ${idl_schema}.chn_channel.etl_dt is '数据日期';
comment on column ${idl_schema}.chn_channel.chn_id is '渠道编号';
comment on column ${idl_schema}.chn_channel.lp_id is '法人编号';
comment on column ${idl_schema}.chn_channel.chn_type_cd is '渠道类型代码';
comment on column ${idl_schema}.chn_channel.chn_name is '渠道名称';
comment on column ${idl_schema}.chn_channel.chn_status_cd is '渠道状态代码';
comment on column ${idl_schema}.chn_channel.effect_dt is '生效日期';
comment on column ${idl_schema}.chn_channel.invalid_dt is '失效日期';
comment on column ${idl_schema}.chn_channel.create_dt is '创建日期';
comment on column ${idl_schema}.chn_channel.update_dt is '更新日期';
comment on column ${idl_schema}.chn_channel.id_mark is '删除标识';