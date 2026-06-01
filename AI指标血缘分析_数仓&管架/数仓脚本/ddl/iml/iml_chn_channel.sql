/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml chn_channel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.chn_channel
whenever sqlerror continue none;
drop table ${iml_schema}.chn_channel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.chn_channel(
    chn_id varchar2(60) -- 直联终端编号
    ,lp_id varchar2(60) -- 法人编号
    ,chn_type_cd varchar2(10) -- 渠道类型代码
    ,chn_name varchar2(750) -- 渠道名称
    ,chn_status_cd varchar2(10) -- 渠道状态代码
    ,effect_dt date -- 渠道生效日期
    ,invalid_dt date -- 渠道失效日期
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.chn_channel to ${icl_schema};
grant select on ${iml_schema}.chn_channel to ${idl_schema};
grant select on ${iml_schema}.chn_channel to ${iel_schema};

-- comment
comment on table ${iml_schema}.chn_channel is '渠道';
comment on column ${iml_schema}.chn_channel.chn_id is '直联终端编号';
comment on column ${iml_schema}.chn_channel.lp_id is '法人编号';
comment on column ${iml_schema}.chn_channel.chn_type_cd is '渠道类型代码';
comment on column ${iml_schema}.chn_channel.chn_name is '渠道名称';
comment on column ${iml_schema}.chn_channel.chn_status_cd is '渠道状态代码';
comment on column ${iml_schema}.chn_channel.effect_dt is '渠道生效日期';
comment on column ${iml_schema}.chn_channel.invalid_dt is '渠道失效日期';
comment on column ${iml_schema}.chn_channel.create_dt is '创建日期';
comment on column ${iml_schema}.chn_channel.update_dt is '更新日期';
comment on column ${iml_schema}.chn_channel.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.chn_channel.id_mark is '增删标志';
comment on column ${iml_schema}.chn_channel.src_table_name is '源表名称';
comment on column ${iml_schema}.chn_channel.job_cd is '任务编码';
comment on column ${iml_schema}.chn_channel.etl_timestamp is 'ETL处理时间戳';
