/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_oactivity
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_oactivity
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_oactivity purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_oactivity(
    customerid varchar2(16) -- 客户编号
    ,serialno varchar2(32) -- 流水号
    ,otherbadrecord varchar2(300) -- 在他行不良记录及原因
    ,inputuserid varchar2(32) -- 登记人
    ,maturity varchar2(10) -- 到期日
    ,uptodate date -- 统计截止日期
    ,balance number(24,6) -- 余额
    ,info varchar2(200) -- 协议内容
    ,classifyresult varchar2(18) -- 五级分类
    ,vouchtype varchar2(18) -- 主要担保方式
    ,inputorgid varchar2(32) -- 登记机构
    ,updatedate date -- 更新日期
    ,occurorg varchar2(120) -- 发生行
    ,lastbusinesssum number(24,6) -- 
    ,businesstype varchar2(18) -- 业务类型
    ,inputdate varchar2(10) -- 输入日期
    ,remark varchar2(200) -- 说明
    ,guarconditions varchar2(4000) -- 担保条件
    ,migtflag varchar2(80) -- 
    ,currency varchar2(18) -- 币种
    ,businesssum number(24,6) -- 金额
    ,begindate date -- 起始日期
    ,creditmode varchar2(100) -- 授信模式
    ,lastbalance number(24,6) -- 
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
grant select on ${iol_schema}.icms_customer_oactivity to ${iml_schema};
grant select on ${iol_schema}.icms_customer_oactivity to ${icl_schema};
grant select on ${iol_schema}.icms_customer_oactivity to ${idl_schema};
grant select on ${iol_schema}.icms_customer_oactivity to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_oactivity is '客户外行业务活动情况';
comment on column ${iol_schema}.icms_customer_oactivity.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_oactivity.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_oactivity.otherbadrecord is '在他行不良记录及原因';
comment on column ${iol_schema}.icms_customer_oactivity.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_oactivity.maturity is '到期日';
comment on column ${iol_schema}.icms_customer_oactivity.uptodate is '统计截止日期';
comment on column ${iol_schema}.icms_customer_oactivity.balance is '余额';
comment on column ${iol_schema}.icms_customer_oactivity.info is '协议内容';
comment on column ${iol_schema}.icms_customer_oactivity.classifyresult is '五级分类';
comment on column ${iol_schema}.icms_customer_oactivity.vouchtype is '主要担保方式';
comment on column ${iol_schema}.icms_customer_oactivity.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_oactivity.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_oactivity.occurorg is '发生行';
comment on column ${iol_schema}.icms_customer_oactivity.lastbusinesssum is '';
comment on column ${iol_schema}.icms_customer_oactivity.businesstype is '业务类型';
comment on column ${iol_schema}.icms_customer_oactivity.inputdate is '输入日期';
comment on column ${iol_schema}.icms_customer_oactivity.remark is '说明';
comment on column ${iol_schema}.icms_customer_oactivity.guarconditions is '担保条件';
comment on column ${iol_schema}.icms_customer_oactivity.migtflag is '';
comment on column ${iol_schema}.icms_customer_oactivity.currency is '币种';
comment on column ${iol_schema}.icms_customer_oactivity.businesssum is '金额';
comment on column ${iol_schema}.icms_customer_oactivity.begindate is '起始日期';
comment on column ${iol_schema}.icms_customer_oactivity.creditmode is '授信模式';
comment on column ${iol_schema}.icms_customer_oactivity.lastbalance is '';
comment on column ${iol_schema}.icms_customer_oactivity.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_oactivity.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_oactivity.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_oactivity.etl_timestamp is 'ETL处理时间戳';
