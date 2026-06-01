/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_blacklist_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_blacklist_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_blacklist_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_blacklist_tb(
    id varchar2(32) -- 主键id
    ,offending_no varchar2(32) -- 违规人帐号
    ,offending_name varchar2(200) -- 违规人名称
    ,periods varchar2(32) -- 期数
    ,release_date varchar2(32) -- 发布日期
    ,cancel_the_agency varchar2(32) -- 撤销机构
    ,cancellation_date varchar2(32) -- 撤销日期
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
grant select on ${iol_schema}.scps_bp_blacklist_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_blacklist_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_blacklist_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_blacklist_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_blacklist_tb is '空头支票黑名单登记簿表';
comment on column ${iol_schema}.scps_bp_blacklist_tb.id is '主键id';
comment on column ${iol_schema}.scps_bp_blacklist_tb.offending_no is '违规人帐号';
comment on column ${iol_schema}.scps_bp_blacklist_tb.offending_name is '违规人名称';
comment on column ${iol_schema}.scps_bp_blacklist_tb.periods is '期数';
comment on column ${iol_schema}.scps_bp_blacklist_tb.release_date is '发布日期';
comment on column ${iol_schema}.scps_bp_blacklist_tb.cancel_the_agency is '撤销机构';
comment on column ${iol_schema}.scps_bp_blacklist_tb.cancellation_date is '撤销日期';
comment on column ${iol_schema}.scps_bp_blacklist_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_bp_blacklist_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_bp_blacklist_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_bp_blacklist_tb.etl_timestamp is 'ETL处理时间戳';
