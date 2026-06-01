/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_security_extra
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_security_extra
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_security_extra purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_security_extra(
    security_code varchar2(24) -- 债券代码
    ,allow_netting varchar2(2) -- 是否净额交割
    ,depository_trust varchar2(30) -- 托管机构
    ,asset_type varchar2(30) -- 资产类别
    ,cb_stock_id varchar2(15) -- 股票代码
    ,cb_stock_name varchar2(60) -- 股票名称
    ,payment_back_mode number(1,0) -- 还本处理方式
    ,breach_contract varchar2(2) -- 
    ,perpetual varchar2(2) -- 永续债标识
    ,n_bsns_day number -- N工作日
    ,issuer_country_name varchar2(75) -- 发行主体所属国家/地区
    ,issuer_location varchar2(192) -- 发行地
    ,local_government_classify varchar2(2) -- 地方政府债分类
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
grant select on ${iol_schema}.ctms_tbs_security_extra to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_security_extra to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_security_extra to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_security_extra to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_security_extra is '债券扩展信息';
comment on column ${iol_schema}.ctms_tbs_security_extra.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_security_extra.allow_netting is '是否净额交割';
comment on column ${iol_schema}.ctms_tbs_security_extra.depository_trust is '托管机构';
comment on column ${iol_schema}.ctms_tbs_security_extra.asset_type is '资产类别';
comment on column ${iol_schema}.ctms_tbs_security_extra.cb_stock_id is '股票代码';
comment on column ${iol_schema}.ctms_tbs_security_extra.cb_stock_name is '股票名称';
comment on column ${iol_schema}.ctms_tbs_security_extra.payment_back_mode is '还本处理方式';
comment on column ${iol_schema}.ctms_tbs_security_extra.breach_contract is '';
comment on column ${iol_schema}.ctms_tbs_security_extra.perpetual is '永续债标识';
comment on column ${iol_schema}.ctms_tbs_security_extra.n_bsns_day is 'N工作日';
comment on column ${iol_schema}.ctms_tbs_security_extra.issuer_country_name is '发行主体所属国家/地区';
comment on column ${iol_schema}.ctms_tbs_security_extra.issuer_location is '发行地';
comment on column ${iol_schema}.ctms_tbs_security_extra.local_government_classify is '地方政府债分类';
comment on column ${iol_schema}.ctms_tbs_security_extra.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_security_extra.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_security_extra.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_security_extra.etl_timestamp is 'ETL处理时间戳';
