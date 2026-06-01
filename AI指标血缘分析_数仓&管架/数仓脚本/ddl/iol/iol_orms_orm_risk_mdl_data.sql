/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orms_orm_risk_mdl_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orms_orm_risk_mdl_data
whenever sqlerror continue none;
drop table ${iol_schema}.orms_orm_risk_mdl_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orms_orm_risk_mdl_data(
    opriskincomeid varchar2(48) -- id
    ,timeid number(9,0) -- 20181231 日期
    ,grossincome number(22,4) -- 总收入
    ,currencyid number(9,0) -- 货币代码
    ,businesslineid number(9,0) -- 条线代码
    ,businesslinedesc nvarchar2(400) -- 条线说明:1.零售银行,2.商业银行,3.公司金融,4.交易和销售,5.支付和结算,6.代理服务,7.资产管理,8.零售经纪,12.其他业务
    ,incometypeid number(9,0) -- 收入类型代码
    ,incometypedesc nvarchar2(400) -- 收入类型说明:10.净利息收入,20.净非利息收入
    ,orgstrucid number(9,0) -- 我行总分行机构代码。 如未取到机构代码 赋默认值 999999
    ,legalentityid number(9,0) -- 法律实体标识 默认值 10 华兴银行
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
grant select on ${iol_schema}.orms_orm_risk_mdl_data to ${iml_schema};
grant select on ${iol_schema}.orms_orm_risk_mdl_data to ${icl_schema};
grant select on ${iol_schema}.orms_orm_risk_mdl_data to ${idl_schema};
grant select on ${iol_schema}.orms_orm_risk_mdl_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.orms_orm_risk_mdl_data is '资本计量年报汇总';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.opriskincomeid is 'id';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.timeid is '20181231 日期';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.grossincome is '总收入';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.currencyid is '货币代码';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.businesslineid is '条线代码';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.businesslinedesc is '条线说明:1.零售银行,2.商业银行,3.公司金融,4.交易和销售,5.支付和结算,6.代理服务,7.资产管理,8.零售经纪,12.其他业务';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.incometypeid is '收入类型代码';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.incometypedesc is '收入类型说明:10.净利息收入,20.净非利息收入';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.orgstrucid is '我行总分行机构代码。 如未取到机构代码 赋默认值 999999';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.legalentityid is '法律实体标识 默认值 10 华兴银行';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.start_dt is '开始时间';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.end_dt is '结束时间';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.id_mark is '增删标志';
comment on column ${iol_schema}.orms_orm_risk_mdl_data.etl_timestamp is 'ETL处理时间戳';
