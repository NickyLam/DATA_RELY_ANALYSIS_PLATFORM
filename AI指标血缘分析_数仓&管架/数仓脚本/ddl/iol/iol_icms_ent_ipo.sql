/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ent_ipo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ent_ipo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ent_ipo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ent_ipo(
    serialno varchar2(64) -- 流水号
    ,ipoaddress varchar2(36) -- 上市地
    ,stockcode varchar2(64) -- 股票代码
    ,migtflag varchar2(80) -- 
    ,ipodate date -- 上市日期
    ,remark varchar2(1000) -- 备注
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,customerid varchar2(16) -- 客户编号
    ,stockquantity number(22) -- 发行量
    ,updateuserid varchar2(64) -- 更新人
    ,stockname varchar2(160) -- 股票名称
    ,updatedate date -- 更新日期
    ,iponame varchar2(80) -- 上市交易所
    ,inputuserid varchar2(64) -- 登记人
    ,corporgid varchar2(64) -- 法人机构编号
    ,inputorgid varchar2(64) -- 登记机构
    ,stocktype varchar2(36) -- 股票类型
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
grant select on ${iol_schema}.icms_ent_ipo to ${iml_schema};
grant select on ${iol_schema}.icms_ent_ipo to ${icl_schema};
grant select on ${iol_schema}.icms_ent_ipo to ${idl_schema};
grant select on ${iol_schema}.icms_ent_ipo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ent_ipo is '企业发行股票信息企业发行股票信息';
comment on column ${iol_schema}.icms_ent_ipo.serialno is '流水号';
comment on column ${iol_schema}.icms_ent_ipo.ipoaddress is '上市地';
comment on column ${iol_schema}.icms_ent_ipo.stockcode is '股票代码';
comment on column ${iol_schema}.icms_ent_ipo.migtflag is '';
comment on column ${iol_schema}.icms_ent_ipo.ipodate is '上市日期';
comment on column ${iol_schema}.icms_ent_ipo.remark is '备注';
comment on column ${iol_schema}.icms_ent_ipo.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ent_ipo.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ent_ipo.customerid is '客户编号';
comment on column ${iol_schema}.icms_ent_ipo.stockquantity is '发行量';
comment on column ${iol_schema}.icms_ent_ipo.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ent_ipo.stockname is '股票名称';
comment on column ${iol_schema}.icms_ent_ipo.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ent_ipo.iponame is '上市交易所';
comment on column ${iol_schema}.icms_ent_ipo.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ent_ipo.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ent_ipo.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ent_ipo.stocktype is '股票类型';
comment on column ${iol_schema}.icms_ent_ipo.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ent_ipo.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ent_ipo.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ent_ipo.etl_timestamp is 'ETL处理时间戳';
