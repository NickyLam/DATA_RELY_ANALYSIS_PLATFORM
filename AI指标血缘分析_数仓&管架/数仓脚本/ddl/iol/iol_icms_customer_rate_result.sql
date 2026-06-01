/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_rate_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_rate_result
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_rate_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_rate_result(
    customerid varchar2(32) -- 客户号
    ,updateuserid varchar2(64) -- 更新人编号
    ,rateenddate date -- 评级到期日
    ,inputorgid varchar2(64) -- 登记人机构编号
    ,migtflag varchar2(80) -- 
    ,raterisklevel varchar2(20) -- 确认级别
    ,flag varchar2(10) -- 标志位
    ,ratelimitlevel varchar2(20) -- 准入级别
    ,ismerge varchar2(1) -- 评级使用的最新财报是否合并
    ,inputuserid varchar2(64) -- 登记人编号
    ,updateorgid varchar2(64) -- 更新人机构编号
    ,fromflag varchar2(8) -- 评级结果来源RateFrom
    ,inputtime date -- 登记时间
    ,ratelimitamt number(24,6) -- 限额
    ,repperiod varchar2(1) -- 评级使用的最新财报周期
    ,ratebegindate date -- 评级核定日
    ,repno varchar2(8) -- 评级使用的最新财报期次
    ,processtype varchar2(2) -- 流程类型：0-评级认定流程1-评级更新流程2-贷后评级流程3-评级延期流程
    ,updatetime date -- 更新时间
    ,isreport varchar2(1) -- 是否有结清业务
    ,serialno varchar2(64) -- 流水号
    ,taskno varchar2(32) -- 内评系统任务流水号
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
grant select on ${iol_schema}.icms_customer_rate_result to ${iml_schema};
grant select on ${iol_schema}.icms_customer_rate_result to ${icl_schema};
grant select on ${iol_schema}.icms_customer_rate_result to ${idl_schema};
grant select on ${iol_schema}.icms_customer_rate_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_rate_result is '客户评级';
comment on column ${iol_schema}.icms_customer_rate_result.customerid is '客户号';
comment on column ${iol_schema}.icms_customer_rate_result.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_customer_rate_result.rateenddate is '评级到期日';
comment on column ${iol_schema}.icms_customer_rate_result.inputorgid is '登记人机构编号';
comment on column ${iol_schema}.icms_customer_rate_result.migtflag is '';
comment on column ${iol_schema}.icms_customer_rate_result.raterisklevel is '确认级别';
comment on column ${iol_schema}.icms_customer_rate_result.flag is '标志位';
comment on column ${iol_schema}.icms_customer_rate_result.ratelimitlevel is '准入级别';
comment on column ${iol_schema}.icms_customer_rate_result.ismerge is '评级使用的最新财报是否合并';
comment on column ${iol_schema}.icms_customer_rate_result.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_customer_rate_result.updateorgid is '更新人机构编号';
comment on column ${iol_schema}.icms_customer_rate_result.fromflag is '评级结果来源RateFrom';
comment on column ${iol_schema}.icms_customer_rate_result.inputtime is '登记时间';
comment on column ${iol_schema}.icms_customer_rate_result.ratelimitamt is '限额';
comment on column ${iol_schema}.icms_customer_rate_result.repperiod is '评级使用的最新财报周期';
comment on column ${iol_schema}.icms_customer_rate_result.ratebegindate is '评级核定日';
comment on column ${iol_schema}.icms_customer_rate_result.repno is '评级使用的最新财报期次';
comment on column ${iol_schema}.icms_customer_rate_result.processtype is '流程类型：0-评级认定流程1-评级更新流程2-贷后评级流程3-评级延期流程';
comment on column ${iol_schema}.icms_customer_rate_result.updatetime is '更新时间';
comment on column ${iol_schema}.icms_customer_rate_result.isreport is '是否有结清业务';
comment on column ${iol_schema}.icms_customer_rate_result.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_rate_result.taskno is '内评系统任务流水号';
comment on column ${iol_schema}.icms_customer_rate_result.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_rate_result.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_rate_result.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_rate_result.etl_timestamp is 'ETL处理时间戳';
