/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_resell_master
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_resell_master
whenever sqlerror continue none;
drop table ${iol_schema}.icms_resell_master purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_resell_master(
    serialno varchar2(32) -- 流水号
    ,resellduebillbalancesum number(24,6) -- 转卖借据金额汇总
    ,inputdate date -- 申请时间
    ,tradecustomer varchar2(60) -- 交易对手
    ,reselltype varchar2(2) -- 境内转让、行内转让、跨境转让
    ,payaccountno varchar2(20) -- 收款账号
    ,applyexpain varchar2(400) -- 转让说明
    ,duebillcount number(22) -- 借据笔数
    ,inputuserid varchar2(8) -- 申请人
    ,businesstype varchar2(20) -- 业务品种
    ,inputorgid varchar2(12) -- 申请机构
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,resellboughtsum number(24,6) -- 转卖收款金额汇总
    ,tradecustomerid varchar2(32) -- 交易对手编号
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
grant select on ${iol_schema}.icms_resell_master to ${iml_schema};
grant select on ${iol_schema}.icms_resell_master to ${icl_schema};
grant select on ${iol_schema}.icms_resell_master to ${idl_schema};
grant select on ${iol_schema}.icms_resell_master to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_resell_master is '同业间福费廷资产转让申请概要';
comment on column ${iol_schema}.icms_resell_master.serialno is '流水号';
comment on column ${iol_schema}.icms_resell_master.resellduebillbalancesum is '转卖借据金额汇总';
comment on column ${iol_schema}.icms_resell_master.inputdate is '申请时间';
comment on column ${iol_schema}.icms_resell_master.tradecustomer is '交易对手';
comment on column ${iol_schema}.icms_resell_master.reselltype is '境内转让、行内转让、跨境转让';
comment on column ${iol_schema}.icms_resell_master.payaccountno is '收款账号';
comment on column ${iol_schema}.icms_resell_master.applyexpain is '转让说明';
comment on column ${iol_schema}.icms_resell_master.duebillcount is '借据笔数';
comment on column ${iol_schema}.icms_resell_master.inputuserid is '申请人';
comment on column ${iol_schema}.icms_resell_master.businesstype is '业务品种';
comment on column ${iol_schema}.icms_resell_master.inputorgid is '申请机构';
comment on column ${iol_schema}.icms_resell_master.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_resell_master.resellboughtsum is '转卖收款金额汇总';
comment on column ${iol_schema}.icms_resell_master.tradecustomerid is '交易对手编号';
comment on column ${iol_schema}.icms_resell_master.start_dt is '开始时间';
comment on column ${iol_schema}.icms_resell_master.end_dt is '结束时间';
comment on column ${iol_schema}.icms_resell_master.id_mark is '增删标志';
comment on column ${iol_schema}.icms_resell_master.etl_timestamp is 'ETL处理时间戳';
