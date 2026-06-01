/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_sl_appl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_sl_appl_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_sl_appl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sl_appl_info(
    serialno varchar2(33) -- 业务流水号
    ,sltype varchar2(5) -- 赎楼类型
    ,housegageowner varchar2(60) -- 赎楼对应房产抵押权人
    ,slhouseowner varchar2(60) -- 赎楼对应房产产权所有人
    ,priceamt number(16,2) -- 定价金额
    ,isgagests varchar2(5) -- 赎楼对应房产抵押状态
    ,capitalsuperamt number(16,2) -- 资金监管金额
    ,cussource varchar2(20) -- 客户来源
    ,notarytrstecertno varchar2(32) -- 公证受托人身份证号码
    ,oloannature varchar2(10) -- 原贷款性质
    ,oldloansplscptl number(16,2) -- 原贷款剩余本金
    ,notarytrstename varchar2(10) -- 公证受托人姓名
    ,transactionamt number(16,2) -- 交易价格
    ,slhousename varchar2(100) -- 赎楼对应房产名称
    ,notarycltname varchar2(10) -- 公证委托人姓名
    ,oldloanbank varchar2(50) -- 原贷款银行
    ,nextbkreplyamt number(16,2) -- 下一手银行批复金额
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,slhousenature varchar2(10) -- 赎楼对应房产性质
    ,slhouseownerratio varchar2(5) -- 赎楼对应房产产权所有人比例
    ,notarycltcertno varchar2(32) -- 公证委托人身份证号码
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
grant select on ${iol_schema}.icms_sl_appl_info to ${iml_schema};
grant select on ${iol_schema}.icms_sl_appl_info to ${icl_schema};
grant select on ${iol_schema}.icms_sl_appl_info to ${idl_schema};
grant select on ${iol_schema}.icms_sl_appl_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_sl_appl_info is '赎楼贷业务信息';
comment on column ${iol_schema}.icms_sl_appl_info.serialno is '业务流水号';
comment on column ${iol_schema}.icms_sl_appl_info.sltype is '赎楼类型';
comment on column ${iol_schema}.icms_sl_appl_info.housegageowner is '赎楼对应房产抵押权人';
comment on column ${iol_schema}.icms_sl_appl_info.slhouseowner is '赎楼对应房产产权所有人';
comment on column ${iol_schema}.icms_sl_appl_info.priceamt is '定价金额';
comment on column ${iol_schema}.icms_sl_appl_info.isgagests is '赎楼对应房产抵押状态';
comment on column ${iol_schema}.icms_sl_appl_info.capitalsuperamt is '资金监管金额';
comment on column ${iol_schema}.icms_sl_appl_info.cussource is '客户来源';
comment on column ${iol_schema}.icms_sl_appl_info.notarytrstecertno is '公证受托人身份证号码';
comment on column ${iol_schema}.icms_sl_appl_info.oloannature is '原贷款性质';
comment on column ${iol_schema}.icms_sl_appl_info.oldloansplscptl is '原贷款剩余本金';
comment on column ${iol_schema}.icms_sl_appl_info.notarytrstename is '公证受托人姓名';
comment on column ${iol_schema}.icms_sl_appl_info.transactionamt is '交易价格';
comment on column ${iol_schema}.icms_sl_appl_info.slhousename is '赎楼对应房产名称';
comment on column ${iol_schema}.icms_sl_appl_info.notarycltname is '公证委托人姓名';
comment on column ${iol_schema}.icms_sl_appl_info.oldloanbank is '原贷款银行';
comment on column ${iol_schema}.icms_sl_appl_info.nextbkreplyamt is '下一手银行批复金额';
comment on column ${iol_schema}.icms_sl_appl_info.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_sl_appl_info.slhousenature is '赎楼对应房产性质';
comment on column ${iol_schema}.icms_sl_appl_info.slhouseownerratio is '赎楼对应房产产权所有人比例';
comment on column ${iol_schema}.icms_sl_appl_info.notarycltcertno is '公证委托人身份证号码';
comment on column ${iol_schema}.icms_sl_appl_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_sl_appl_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_sl_appl_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_sl_appl_info.etl_timestamp is 'ETL处理时间戳';
