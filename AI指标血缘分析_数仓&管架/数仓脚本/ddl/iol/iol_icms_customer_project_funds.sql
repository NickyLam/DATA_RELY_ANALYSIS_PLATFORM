/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_project_funds
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_project_funds
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_project_funds purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_project_funds(
    serialno varchar2(64) -- 流水号
    ,projectno varchar2(64) -- 项目编号
    ,investorlocation varchar2(36) -- 出资人所在地区
    ,actualdate date -- 实际完成日期
    ,currency varchar2(3) -- 币种
    ,inputorgid varchar2(64) -- 登记机构
    ,fundsourceorgname varchar2(160) -- 资金来源机构名称
    ,investratio number(24,6) -- 投资占比
    ,plandate date -- 计划制订日期
    ,remark varchar2(1000) -- 备注
    ,inputdate date -- 登记日期
    ,respondtype varchar2(160) -- 投资回收方式
    ,corporgid varchar2(64) -- 法人机构编号
    ,investorname varchar2(160) -- 出资人名称
    ,investsum number(24,6) -- 投资金额
    ,inputuserid varchar2(64) -- 登记人
    ,updateorgid varchar2(64) -- 更新机构
    ,investorcode varchar2(64) -- 出资人代码
    ,fundsourcetype varchar2(36) -- 资金来源方式
    ,updateuserid varchar2(64) -- 更新人
    ,attendprojectway varchar2(36) -- 参与项目合作方式
    ,migtflag varchar2(80) -- 
    ,actualsum number(24,6) -- 已到位资金
    ,updatedate date -- 更新日期
    ,actualradio number(24,8) -- 到位比例
    ,financingterm date -- 融资到期时间
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
grant select on ${iol_schema}.icms_customer_project_funds to ${iml_schema};
grant select on ${iol_schema}.icms_customer_project_funds to ${icl_schema};
grant select on ${iol_schema}.icms_customer_project_funds to ${idl_schema};
grant select on ${iol_schema}.icms_customer_project_funds to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_project_funds is '项目资金来源信息项目资金来源信息';
comment on column ${iol_schema}.icms_customer_project_funds.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_project_funds.projectno is '项目编号';
comment on column ${iol_schema}.icms_customer_project_funds.investorlocation is '出资人所在地区';
comment on column ${iol_schema}.icms_customer_project_funds.actualdate is '实际完成日期';
comment on column ${iol_schema}.icms_customer_project_funds.currency is '币种';
comment on column ${iol_schema}.icms_customer_project_funds.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_project_funds.fundsourceorgname is '资金来源机构名称';
comment on column ${iol_schema}.icms_customer_project_funds.investratio is '投资占比';
comment on column ${iol_schema}.icms_customer_project_funds.plandate is '计划制订日期';
comment on column ${iol_schema}.icms_customer_project_funds.remark is '备注';
comment on column ${iol_schema}.icms_customer_project_funds.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_project_funds.respondtype is '投资回收方式';
comment on column ${iol_schema}.icms_customer_project_funds.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_project_funds.investorname is '出资人名称';
comment on column ${iol_schema}.icms_customer_project_funds.investsum is '投资金额';
comment on column ${iol_schema}.icms_customer_project_funds.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_project_funds.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_project_funds.investorcode is '出资人代码';
comment on column ${iol_schema}.icms_customer_project_funds.fundsourcetype is '资金来源方式';
comment on column ${iol_schema}.icms_customer_project_funds.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_project_funds.attendprojectway is '参与项目合作方式';
comment on column ${iol_schema}.icms_customer_project_funds.migtflag is '';
comment on column ${iol_schema}.icms_customer_project_funds.actualsum is '已到位资金';
comment on column ${iol_schema}.icms_customer_project_funds.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_project_funds.actualradio is '到位比例';
comment on column ${iol_schema}.icms_customer_project_funds.financingterm is '融资到期时间';
comment on column ${iol_schema}.icms_customer_project_funds.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_project_funds.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_project_funds.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_project_funds.etl_timestamp is 'ETL处理时间戳';
