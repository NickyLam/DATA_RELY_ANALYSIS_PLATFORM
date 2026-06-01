/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_channel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_channel
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_channel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_channel(
    channel_class varchar2(3) -- 渠道分类
    ,channel_desc varchar2(1000) -- 渠道描述
    ,channel_short varchar2(200) -- 渠道名称
    ,company varchar2(20) -- 法人
    ,system_id varchar2(20) -- 系统id
    ,channel varchar2(10) -- 渠道
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,counter_flag varchar2(1) -- 柜面标志
    ,channel_type varchar2(10) -- 渠道细类
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
grant select on ${iol_schema}.ncbs_fm_channel to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_channel to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_channel to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_channel to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_channel is '渠道类型表';
comment on column ${iol_schema}.ncbs_fm_channel.channel_class is '渠道分类';
comment on column ${iol_schema}.ncbs_fm_channel.channel_desc is '渠道描述';
comment on column ${iol_schema}.ncbs_fm_channel.channel_short is '渠道名称';
comment on column ${iol_schema}.ncbs_fm_channel.company is '法人';
comment on column ${iol_schema}.ncbs_fm_channel.system_id is '系统id';
comment on column ${iol_schema}.ncbs_fm_channel.channel is '渠道';
comment on column ${iol_schema}.ncbs_fm_channel.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_channel.counter_flag is '柜面标志';
comment on column ${iol_schema}.ncbs_fm_channel.channel_type is '渠道细类';
comment on column ${iol_schema}.ncbs_fm_channel.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_channel.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_channel.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_channel.etl_timestamp is 'ETL处理时间戳';
