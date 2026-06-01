/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_classify_customer_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_classify_customer_result
whenever sqlerror continue none;
drop table ${iol_schema}.icms_classify_customer_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_classify_customer_result(
    serialno varchar2(64) -- 流水号
    ,approvestatus varchar2(64) -- 审批状态
    ,accountmonth varchar2(64) -- 分类期次
    ,belongdept varchar2(64) -- 所属条线
    ,customername varchar2(200) -- 客户名称
    ,bizaccount number(22) -- 业务笔数
    ,inputuserid varchar2(64) -- 登记人
    ,updateuserid varchar2(64) -- 更新人
    ,updatedate date -- 更新日期
    ,certtype varchar2(4) -- 证件类型
    ,customerid varchar2(16) -- 客户编号
    ,certid varchar2(18) -- 证件编号
    ,inputdate date -- 登记日期
    ,corporgid varchar2(64) -- 法人机构编号
    ,classifyresult varchar2(2) -- 分类结果分类结果(正常/关注/次级/可疑/损失)
    ,inputorgid varchar2(64) -- 登记机构
    ,updateorgid varchar2(64) -- 更新机构
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
grant select on ${iol_schema}.icms_classify_customer_result to ${iml_schema};
grant select on ${iol_schema}.icms_classify_customer_result to ${icl_schema};
grant select on ${iol_schema}.icms_classify_customer_result to ${idl_schema};
grant select on ${iol_schema}.icms_classify_customer_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_classify_customer_result is '风险分类客户结果风险分类客户结果';
comment on column ${iol_schema}.icms_classify_customer_result.serialno is '流水号';
comment on column ${iol_schema}.icms_classify_customer_result.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_classify_customer_result.accountmonth is '分类期次';
comment on column ${iol_schema}.icms_classify_customer_result.belongdept is '所属条线';
comment on column ${iol_schema}.icms_classify_customer_result.customername is '客户名称';
comment on column ${iol_schema}.icms_classify_customer_result.bizaccount is '业务笔数';
comment on column ${iol_schema}.icms_classify_customer_result.inputuserid is '登记人';
comment on column ${iol_schema}.icms_classify_customer_result.updateuserid is '更新人';
comment on column ${iol_schema}.icms_classify_customer_result.updatedate is '更新日期';
comment on column ${iol_schema}.icms_classify_customer_result.certtype is '证件类型';
comment on column ${iol_schema}.icms_classify_customer_result.customerid is '客户编号';
comment on column ${iol_schema}.icms_classify_customer_result.certid is '证件编号';
comment on column ${iol_schema}.icms_classify_customer_result.inputdate is '登记日期';
comment on column ${iol_schema}.icms_classify_customer_result.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_classify_customer_result.classifyresult is '分类结果分类结果(正常/关注/次级/可疑/损失)';
comment on column ${iol_schema}.icms_classify_customer_result.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_classify_customer_result.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_classify_customer_result.start_dt is '开始时间';
comment on column ${iol_schema}.icms_classify_customer_result.end_dt is '结束时间';
comment on column ${iol_schema}.icms_classify_customer_result.id_mark is '增删标志';
comment on column ${iol_schema}.icms_classify_customer_result.etl_timestamp is 'ETL处理时间戳';
