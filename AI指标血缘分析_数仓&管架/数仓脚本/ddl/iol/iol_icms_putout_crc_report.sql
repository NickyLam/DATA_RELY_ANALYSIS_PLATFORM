/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_putout_crc_report
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_putout_crc_report
whenever sqlerror continue none;
drop table ${iol_schema}.icms_putout_crc_report purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_putout_crc_report(
    customerid varchar2(40) -- 客户编号
    ,fcscgydbtcrtxnbal number(24,6) -- 借贷交易-关注类余额
    ,fcscgywrnttxnbal number(24,6) -- 担保交易-其中：关注类余额
    ,owtaxrcrdnum number(4,0) -- 欠税记录条数
    ,rctlyocdispldt date -- 由资产管理公司处置的债务-最近一次处置日期
    ,adcshbsnacc number(24,0) -- 垫款-账户数
    ,astdspbsnbal number(24,6) -- 由资产管理公司处置的债务-余额
    ,inputdate date -- 查询日期
    ,cvljdgmtrcrdnum number(4,0) -- 民事判决记录条数
    ,adcshrctlyocrepydyprd varchar2(10) -- 垫款-最近一次还款日期
    ,entnm varchar2(200) -- 客户名称
    ,wrnttxnbalbal number(24,6) -- 担保交易-余额
    ,odinadoth number(24,6) -- 逾期-利息及其他
    ,curoduepnp number(24,6) -- 逾期-本金
    ,berecsdbtcrtxnbal number(24,6) -- 借贷交易-其中：被追偿余额
    ,admnpnshrcrdnum number(4,0) -- 行政处罚记录条数
    ,badcgywrnttxnbal number(24,6) -- 担保交易-不良类余额
    ,astdspbsnacc number(24,0) -- 由资产管理公司处置的债务-账户数
    ,adcshbsnbal number(24,6) -- 垫款-余额
    ,pbccrexstnst varchar2(1) -- 存续状态,1正常2注销9其他X未知
    ,efrcexercrdnum number(4,0) -- 强制执行记录条数
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,dbtcrtxnbal number(24,6) -- 借贷交易-余额
    ,badcgydbtcrtxnbal number(24,6) -- 借贷交易-不良类余额
    ,curoduetamt number(24,6) -- 逾期-总额
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
grant select on ${iol_schema}.icms_putout_crc_report to ${iml_schema};
grant select on ${iol_schema}.icms_putout_crc_report to ${icl_schema};
grant select on ${iol_schema}.icms_putout_crc_report to ${idl_schema};
grant select on ${iol_schema}.icms_putout_crc_report to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_putout_crc_report is '随兴贷出账详情征信报告';
comment on column ${iol_schema}.icms_putout_crc_report.customerid is '客户编号';
comment on column ${iol_schema}.icms_putout_crc_report.fcscgydbtcrtxnbal is '借贷交易-关注类余额';
comment on column ${iol_schema}.icms_putout_crc_report.fcscgywrnttxnbal is '担保交易-其中：关注类余额';
comment on column ${iol_schema}.icms_putout_crc_report.owtaxrcrdnum is '欠税记录条数';
comment on column ${iol_schema}.icms_putout_crc_report.rctlyocdispldt is '由资产管理公司处置的债务-最近一次处置日期';
comment on column ${iol_schema}.icms_putout_crc_report.adcshbsnacc is '垫款-账户数';
comment on column ${iol_schema}.icms_putout_crc_report.astdspbsnbal is '由资产管理公司处置的债务-余额';
comment on column ${iol_schema}.icms_putout_crc_report.inputdate is '查询日期';
comment on column ${iol_schema}.icms_putout_crc_report.cvljdgmtrcrdnum is '民事判决记录条数';
comment on column ${iol_schema}.icms_putout_crc_report.adcshrctlyocrepydyprd is '垫款-最近一次还款日期';
comment on column ${iol_schema}.icms_putout_crc_report.entnm is '客户名称';
comment on column ${iol_schema}.icms_putout_crc_report.wrnttxnbalbal is '担保交易-余额';
comment on column ${iol_schema}.icms_putout_crc_report.odinadoth is '逾期-利息及其他';
comment on column ${iol_schema}.icms_putout_crc_report.curoduepnp is '逾期-本金';
comment on column ${iol_schema}.icms_putout_crc_report.berecsdbtcrtxnbal is '借贷交易-其中：被追偿余额';
comment on column ${iol_schema}.icms_putout_crc_report.admnpnshrcrdnum is '行政处罚记录条数';
comment on column ${iol_schema}.icms_putout_crc_report.badcgywrnttxnbal is '担保交易-不良类余额';
comment on column ${iol_schema}.icms_putout_crc_report.astdspbsnacc is '由资产管理公司处置的债务-账户数';
comment on column ${iol_schema}.icms_putout_crc_report.adcshbsnbal is '垫款-余额';
comment on column ${iol_schema}.icms_putout_crc_report.pbccrexstnst is '存续状态,1正常2注销9其他X未知';
comment on column ${iol_schema}.icms_putout_crc_report.efrcexercrdnum is '强制执行记录条数';
comment on column ${iol_schema}.icms_putout_crc_report.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_putout_crc_report.dbtcrtxnbal is '借贷交易-余额';
comment on column ${iol_schema}.icms_putout_crc_report.badcgydbtcrtxnbal is '借贷交易-不良类余额';
comment on column ${iol_schema}.icms_putout_crc_report.curoduetamt is '逾期-总额';
comment on column ${iol_schema}.icms_putout_crc_report.start_dt is '开始时间';
comment on column ${iol_schema}.icms_putout_crc_report.end_dt is '结束时间';
comment on column ${iol_schema}.icms_putout_crc_report.id_mark is '增删标志';
comment on column ${iol_schema}.icms_putout_crc_report.etl_timestamp is 'ETL处理时间戳';
