/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_psp_risk_warning_rule_conf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_psp_risk_warning_rule_conf
whenever sqlerror continue none;
drop table ${iol_schema}.icms_psp_risk_warning_rule_conf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_psp_risk_warning_rule_conf(
    rangepro varchar2(100) -- 适用产品(只有适用范围是部分产品才选择适用产品，产品支持多选)
    ,checkobj varchar2(20) -- 检查对象(1借款人及共同借款人2担保人3抵质押物4还款行为5资金用途6渠道)
    ,warningsign varchar2(100) -- 预警信号名称
    ,warningrule varchar2(800) -- 预警规则
    ,updatehz varchar2(4) -- 更新频率(1、按日2、按月3、按季)
    ,signlevel varchar2(2) -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
    ,creatorid varchar2(20) -- 创建人
    ,createdate varchar2(12) -- 创建时间
    ,lastchangeuser varchar2(20) -- 最新修改人
    ,lastchangetime varchar2(12) -- 最新修改时间
    ,warningruleno varchar2(32) -- 预警规则编号
    ,range varchar2(15) -- 适用范围(1、全部产品2、部分产品)
    ,percent number(16,2) -- 比例警戒线
    ,amt number(22,2) -- 金额警戒线
    ,count number(38,0) -- 次数警戒线
    ,status varchar2(1) -- 状态
    ,remark varchar2(1000) -- 备注
    ,warningcode varchar2(64) -- 预警信号规则代码
    ,migtflag varchar2(80) -- 迁移标识
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
grant select on ${iol_schema}.icms_psp_risk_warning_rule_conf to ${iml_schema};
grant select on ${iol_schema}.icms_psp_risk_warning_rule_conf to ${icl_schema};
grant select on ${iol_schema}.icms_psp_risk_warning_rule_conf to ${idl_schema};
grant select on ${iol_schema}.icms_psp_risk_warning_rule_conf to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_psp_risk_warning_rule_conf is '风险预警规则业务配置';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.rangepro is '适用产品(只有适用范围是部分产品才选择适用产品，产品支持多选)';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.checkobj is '检查对象(1借款人及共同借款人2担保人3抵质押物4还款行为5资金用途6渠道)';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.warningsign is '预警信号名称';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.warningrule is '预警规则';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.updatehz is '更新频率(1、按日2、按月3、按季)';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.signlevel is '预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.creatorid is '创建人';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.createdate is '创建时间';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.lastchangeuser is '最新修改人';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.lastchangetime is '最新修改时间';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.warningruleno is '预警规则编号';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.range is '适用范围(1、全部产品2、部分产品)';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.percent is '比例警戒线';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.amt is '金额警戒线';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.count is '次数警戒线';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.status is '状态';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.remark is '备注';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.warningcode is '预警信号规则代码';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.migtflag is '迁移标识';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.start_dt is '开始时间';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.end_dt is '结束时间';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.id_mark is '增删标志';
comment on column ${iol_schema}.icms_psp_risk_warning_rule_conf.etl_timestamp is 'ETL处理时间戳';
