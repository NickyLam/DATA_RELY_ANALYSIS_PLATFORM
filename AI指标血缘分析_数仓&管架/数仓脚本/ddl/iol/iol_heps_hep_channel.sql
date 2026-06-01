/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_hep_channel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_hep_channel
whenever sqlerror continue none;
drop table ${iol_schema}.heps_hep_channel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_hep_channel(
    channel_id varchar2(32) -- 地推渠道编码
    ,channel_name varchar2(90) -- 地推渠道
    ,channel_phone varchar2(32) -- 联系方式
    ,channel_status varchar2(2) -- 0-失效 1-有效
    ,create_time date -- 
    ,update_time date -- 
    ,src varchar2(900) -- 固定url
    ,isinit varchar2(2) -- 0-未生成 1-已生成
    ,url varchar2(900) -- 生成后的url
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.heps_hep_channel to ${iml_schema};
grant select on ${iol_schema}.heps_hep_channel to ${icl_schema};
grant select on ${iol_schema}.heps_hep_channel to ${idl_schema};
grant select on ${iol_schema}.heps_hep_channel to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_hep_channel is '二维码渠道表';
comment on column ${iol_schema}.heps_hep_channel.channel_id is '地推渠道编码';
comment on column ${iol_schema}.heps_hep_channel.channel_name is '地推渠道';
comment on column ${iol_schema}.heps_hep_channel.channel_phone is '联系方式';
comment on column ${iol_schema}.heps_hep_channel.channel_status is '0-失效 1-有效';
comment on column ${iol_schema}.heps_hep_channel.create_time is '';
comment on column ${iol_schema}.heps_hep_channel.update_time is '';
comment on column ${iol_schema}.heps_hep_channel.src is '固定url';
comment on column ${iol_schema}.heps_hep_channel.isinit is '0-未生成 1-已生成';
comment on column ${iol_schema}.heps_hep_channel.url is '生成后的url';
comment on column ${iol_schema}.heps_hep_channel.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_hep_channel.etl_timestamp is 'ETL处理时间戳';
