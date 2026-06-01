/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_businessrate_config
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_businessrate_config
whenever sqlerror continue none;
drop table ${iol_schema}.icms_businessrate_config purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_businessrate_config(
    serialno varchar2(32) -- 流水号
    ,rate1 number(10,4) -- 跨季利率
    ,serialnowf varchar2(32) -- 白名单流水
    ,ratetermtype varchar2(2) -- 期限类型
    ,inputuserid varchar2(20) -- 登记人
    ,migtflag varchar2(80) -- 
    ,channel varchar2(18) -- 渠道
    ,status varchar2(2) -- 状态
    ,updatetime date -- 更新时间
    ,inputorgid varchar2(20) -- 登记机构
    ,inputdate date -- 登记日期
    ,rateterm varchar2(10) -- 期限值
    ,rate number(10,4) -- 定价利率
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
grant select on ${iol_schema}.icms_businessrate_config to ${iml_schema};
grant select on ${iol_schema}.icms_businessrate_config to ${icl_schema};
grant select on ${iol_schema}.icms_businessrate_config to ${idl_schema};
grant select on ${iol_schema}.icms_businessrate_config to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_businessrate_config is '业务利率定价配置';
comment on column ${iol_schema}.icms_businessrate_config.serialno is '流水号';
comment on column ${iol_schema}.icms_businessrate_config.rate1 is '跨季利率';
comment on column ${iol_schema}.icms_businessrate_config.serialnowf is '白名单流水';
comment on column ${iol_schema}.icms_businessrate_config.ratetermtype is '期限类型';
comment on column ${iol_schema}.icms_businessrate_config.inputuserid is '登记人';
comment on column ${iol_schema}.icms_businessrate_config.migtflag is '';
comment on column ${iol_schema}.icms_businessrate_config.channel is '渠道';
comment on column ${iol_schema}.icms_businessrate_config.status is '状态';
comment on column ${iol_schema}.icms_businessrate_config.updatetime is '更新时间';
comment on column ${iol_schema}.icms_businessrate_config.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_businessrate_config.inputdate is '登记日期';
comment on column ${iol_schema}.icms_businessrate_config.rateterm is '期限值';
comment on column ${iol_schema}.icms_businessrate_config.rate is '定价利率';
comment on column ${iol_schema}.icms_businessrate_config.start_dt is '开始时间';
comment on column ${iol_schema}.icms_businessrate_config.end_dt is '结束时间';
comment on column ${iol_schema}.icms_businessrate_config.id_mark is '增删标志';
comment on column ${iol_schema}.icms_businessrate_config.etl_timestamp is 'ETL处理时间戳';
