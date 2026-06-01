/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_bankno
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_bankno
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_bankno purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_bankno(
    pbo_bankno varchar2(20) -- 行号
    ,pbo_banktype varchar2(20) -- 行别
    ,pbo_standardid varchar2(20) -- 智慧路由标准行号id(所属行联行号)
    ,pbo_channel varchar2(20) -- 通道分类
    ,pbo_citycode varchar2(20) -- 城市代码
    ,pbo_provincecode varchar2(20) -- 省及直辖市
    ,pbo_fromdate varchar2(8) -- 生效日期
    ,pbo_thrudate varchar2(8) -- 失效日期
    ,pbo_bankname varchar2(300) -- 行名
    ,pbo_stt varchar2(7) -- 状态有效：valid;失效：invalid
    ,pbo_updatedate varchar2(8) -- 更新日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbps_cpr_bankno to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_bankno to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_bankno to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_bankno to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_bankno is '行号表';
comment on column ${iol_schema}.tbps_cpr_bankno.pbo_bankno is '行号';
comment on column ${iol_schema}.tbps_cpr_bankno.pbo_banktype is '行别';
comment on column ${iol_schema}.tbps_cpr_bankno.pbo_standardid is '智慧路由标准行号id(所属行联行号)';
comment on column ${iol_schema}.tbps_cpr_bankno.pbo_channel is '通道分类';
comment on column ${iol_schema}.tbps_cpr_bankno.pbo_citycode is '城市代码';
comment on column ${iol_schema}.tbps_cpr_bankno.pbo_provincecode is '省及直辖市';
comment on column ${iol_schema}.tbps_cpr_bankno.pbo_fromdate is '生效日期';
comment on column ${iol_schema}.tbps_cpr_bankno.pbo_thrudate is '失效日期';
comment on column ${iol_schema}.tbps_cpr_bankno.pbo_bankname is '行名';
comment on column ${iol_schema}.tbps_cpr_bankno.pbo_stt is '状态有效：valid;失效：invalid';
comment on column ${iol_schema}.tbps_cpr_bankno.pbo_updatedate is '更新日期';
comment on column ${iol_schema}.tbps_cpr_bankno.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_bankno.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_bankno.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_bankno.etl_timestamp is 'ETL处理时间戳';
