/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_breach_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_breach_result
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_breach_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_breach_result(
    customerid varchar2(32) -- 客户号
    ,processtype varchar2(1) -- 流程类型：5-违约客户认定流程6-违约推翻流程7-违约重生流程
    ,iscanrelive varchar2(8) -- 能否违约重生:yes-可以no-不可以
    ,enddate date -- 评级到期日
    ,breachdate date -- 违约认定日期
    ,breachrelivedate date -- 违约重生日期
    ,taskno varchar2(32) -- 内评系统任务流水号
    ,begindate date -- 评级核定日期
    ,breachflag varchar2(1) -- 违约标志:0不违约1违约
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,flag varchar2(10) -- 标志位:automatic-内评系统推送认定结果,artificial-人工违约认定结果
    ,breachoverturndate date -- 违约推翻日期
    ,rateflag varchar2(8) -- 流程类型
    ,updatetime date -- 更新时间
    ,risklevel varchar2(20) -- 调整后级别
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
grant select on ${iol_schema}.icms_customer_breach_result to ${iml_schema};
grant select on ${iol_schema}.icms_customer_breach_result to ${icl_schema};
grant select on ${iol_schema}.icms_customer_breach_result to ${idl_schema};
grant select on ${iol_schema}.icms_customer_breach_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_breach_result is '客户评级结果';
comment on column ${iol_schema}.icms_customer_breach_result.customerid is '客户号';
comment on column ${iol_schema}.icms_customer_breach_result.processtype is '流程类型：5-违约客户认定流程6-违约推翻流程7-违约重生流程';
comment on column ${iol_schema}.icms_customer_breach_result.iscanrelive is '能否违约重生:yes-可以no-不可以';
comment on column ${iol_schema}.icms_customer_breach_result.enddate is '评级到期日';
comment on column ${iol_schema}.icms_customer_breach_result.breachdate is '违约认定日期';
comment on column ${iol_schema}.icms_customer_breach_result.breachrelivedate is '违约重生日期';
comment on column ${iol_schema}.icms_customer_breach_result.taskno is '内评系统任务流水号';
comment on column ${iol_schema}.icms_customer_breach_result.begindate is '评级核定日期';
comment on column ${iol_schema}.icms_customer_breach_result.breachflag is '违约标志:0不违约1违约';
comment on column ${iol_schema}.icms_customer_breach_result.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_breach_result.flag is '标志位:automatic-内评系统推送认定结果,artificial-人工违约认定结果';
comment on column ${iol_schema}.icms_customer_breach_result.breachoverturndate is '违约推翻日期';
comment on column ${iol_schema}.icms_customer_breach_result.rateflag is '流程类型';
comment on column ${iol_schema}.icms_customer_breach_result.updatetime is '更新时间';
comment on column ${iol_schema}.icms_customer_breach_result.risklevel is '调整后级别';
comment on column ${iol_schema}.icms_customer_breach_result.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_breach_result.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_breach_result.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_breach_result.etl_timestamp is 'ETL处理时间戳';
