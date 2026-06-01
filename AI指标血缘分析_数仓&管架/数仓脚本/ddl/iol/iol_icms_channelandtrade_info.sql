/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_channelandtrade_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_channelandtrade_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_channelandtrade_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_channelandtrade_info(
    serialno varchar2(32) -- 流水号
    ,carrier varchar2(8) -- 特殊目的载体类型
    ,migtflag varchar2(80) -- 
    ,managerid varchar2(32) -- 管理人编号
    ,productname varchar2(400) -- 产品名称
    ,channelname varchar2(200) -- 通道方名称
    ,inputorgid varchar2(32) -- 登记机构
    ,casenumber varchar2(40) -- 特殊目的载体备案号
    ,costrate number(24,6) -- 通道费率
    ,hasrate varchar2(1) -- 是否有外部评级
    ,updatedate varchar2(10) -- 更新日期
    ,channelid varchar2(32) -- 通道方编号
    ,ishierarchical varchar2(1) -- 是否有分层结构
    ,trusteeid varchar2(32) -- 托管人编号
    ,inputdate varchar2(10) -- 登记日期
    ,controltype varchar2(2) -- 管理形式
    ,raisesum number(24,6) -- 募集总金额
    ,isnetvalue varchar2(1) -- 是否净值项
    ,ratetype varchar2(5) -- 外部评级类型
    ,inputuserid varchar2(32) -- 登记人
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
grant select on ${iol_schema}.icms_channelandtrade_info to ${iml_schema};
grant select on ${iol_schema}.icms_channelandtrade_info to ${icl_schema};
grant select on ${iol_schema}.icms_channelandtrade_info to ${idl_schema};
grant select on ${iol_schema}.icms_channelandtrade_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_channelandtrade_info is '通道及交易结构信息';
comment on column ${iol_schema}.icms_channelandtrade_info.serialno is '流水号';
comment on column ${iol_schema}.icms_channelandtrade_info.carrier is '特殊目的载体类型';
comment on column ${iol_schema}.icms_channelandtrade_info.migtflag is '';
comment on column ${iol_schema}.icms_channelandtrade_info.managerid is '管理人编号';
comment on column ${iol_schema}.icms_channelandtrade_info.productname is '产品名称';
comment on column ${iol_schema}.icms_channelandtrade_info.channelname is '通道方名称';
comment on column ${iol_schema}.icms_channelandtrade_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_channelandtrade_info.casenumber is '特殊目的载体备案号';
comment on column ${iol_schema}.icms_channelandtrade_info.costrate is '通道费率';
comment on column ${iol_schema}.icms_channelandtrade_info.hasrate is '是否有外部评级';
comment on column ${iol_schema}.icms_channelandtrade_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_channelandtrade_info.channelid is '通道方编号';
comment on column ${iol_schema}.icms_channelandtrade_info.ishierarchical is '是否有分层结构';
comment on column ${iol_schema}.icms_channelandtrade_info.trusteeid is '托管人编号';
comment on column ${iol_schema}.icms_channelandtrade_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_channelandtrade_info.controltype is '管理形式';
comment on column ${iol_schema}.icms_channelandtrade_info.raisesum is '募集总金额';
comment on column ${iol_schema}.icms_channelandtrade_info.isnetvalue is '是否净值项';
comment on column ${iol_schema}.icms_channelandtrade_info.ratetype is '外部评级类型';
comment on column ${iol_schema}.icms_channelandtrade_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_channelandtrade_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_channelandtrade_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_channelandtrade_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_channelandtrade_info.etl_timestamp is 'ETL处理时间戳';
