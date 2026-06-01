/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_risk_warning_sign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_risk_warning_sign
whenever sqlerror continue none;
drop table ${iol_schema}.icms_risk_warning_sign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_risk_warning_sign(
    serialno varchar2(64) -- 预警信号编号
    ,signlevel varchar2(10) -- 预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)
    ,effecttime date -- 生效时间
    ,maxoverduedays number(22) -- 当前最高逾期天数
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,creditlevel varchar2(64) -- 信用等级
    ,customername varchar2(200) -- 客户名称
    ,remark varchar2(800) -- 备注
    ,businessname varchar2(160) -- 企业名称
    ,rqrfindate date -- 要求完成日期
    ,canceltime date -- 失效时间
    ,monitorcode varchar2(80) -- 预警信号代码
    ,balance number(16,2) -- 产品余额
    ,warningresult varchar2(600) -- 预警信号原因
    ,releaseresult varchar2(200) -- 解除理由
    ,compaddr varchar2(80) -- 企业地址
    ,repaytype varchar2(36) -- 还款方式
    ,dealopinion varchar2(300) -- 处理意见
    ,inputuserid varchar2(64) -- 登记人
    ,compsize varchar2(10) -- 企业规模
    ,customertype varchar2(36) -- 客户类型
    ,monitorcontent varchar2(1000) -- 预警信号内容
    ,riskcontrolplan varchar2(200) -- 拟采取的处置计划和风险控制措施
    ,compprop varchar2(10) -- 企业性质
    ,isprveconomy varchar2(64) -- 是否民营
    ,productid varchar2(30) -- 产品编号
    ,riskdealno varchar2(64) -- 助贷风险处理流水
    ,managerorgid varchar2(64) -- 主管机构
    ,customerid varchar2(16) -- 客户编号
    ,industryname varchar2(200) -- 所属行业名称
    ,signtype varchar2(10) -- 预警信号类型
    ,checktaskno varchar2(64) -- 检查任务编号
    ,industrytype varchar2(10) -- 所属行业类型
    ,creditdesc varchar2(200) -- 当前授信情况
    ,releasedate date -- 解除日期
    ,updatedate date -- 更新日期
    ,accumrepaysum number(20,2) -- 累计还款本金
    ,monitortaskno varchar2(64) -- 监测任务编号
    ,effectdate date -- 生效日期
    ,signstatus varchar2(10) -- 预警信号状态
    ,inputdate date -- 登记日期
    ,createtype varchar2(10) -- 生成方式
    ,inputorgid varchar2(64) -- 登记机构
    ,effectresult varchar2(300) -- 生效原因
    ,risklosslevel varchar2(600) -- 本笔贷款的风险程度及预计损失程度
    ,overduelevel varchar2(10) -- 逾期等级
    ,dealdate date -- 处理日期
    ,infactfindate date -- 实际审批完成日期
    ,batserialno varchar2(64) -- 处理批次流水号
    ,term number(22) -- 期限
    ,manageruserid varchar2(30) -- 主管客户经理
    ,certtype varchar2(36) -- 证件类型
    ,certid varchar2(60) -- 证件号码
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
grant select on ${iol_schema}.icms_risk_warning_sign to ${iml_schema};
grant select on ${iol_schema}.icms_risk_warning_sign to ${icl_schema};
grant select on ${iol_schema}.icms_risk_warning_sign to ${idl_schema};
grant select on ${iol_schema}.icms_risk_warning_sign to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_risk_warning_sign is '风险预警信号';
comment on column ${iol_schema}.icms_risk_warning_sign.serialno is '预警信号编号';
comment on column ${iol_schema}.icms_risk_warning_sign.signlevel is '预警信号级别(一级预警信号（重大）、二级预警信号、三级预警信号)';
comment on column ${iol_schema}.icms_risk_warning_sign.effecttime is '生效时间';
comment on column ${iol_schema}.icms_risk_warning_sign.maxoverduedays is '当前最高逾期天数';
comment on column ${iol_schema}.icms_risk_warning_sign.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_risk_warning_sign.creditlevel is '信用等级';
comment on column ${iol_schema}.icms_risk_warning_sign.customername is '客户名称';
comment on column ${iol_schema}.icms_risk_warning_sign.remark is '备注';
comment on column ${iol_schema}.icms_risk_warning_sign.businessname is '企业名称';
comment on column ${iol_schema}.icms_risk_warning_sign.rqrfindate is '要求完成日期';
comment on column ${iol_schema}.icms_risk_warning_sign.canceltime is '失效时间';
comment on column ${iol_schema}.icms_risk_warning_sign.monitorcode is '预警信号代码';
comment on column ${iol_schema}.icms_risk_warning_sign.balance is '产品余额';
comment on column ${iol_schema}.icms_risk_warning_sign.warningresult is '预警信号原因';
comment on column ${iol_schema}.icms_risk_warning_sign.releaseresult is '解除理由';
comment on column ${iol_schema}.icms_risk_warning_sign.compaddr is '企业地址';
comment on column ${iol_schema}.icms_risk_warning_sign.repaytype is '还款方式';
comment on column ${iol_schema}.icms_risk_warning_sign.dealopinion is '处理意见';
comment on column ${iol_schema}.icms_risk_warning_sign.inputuserid is '登记人';
comment on column ${iol_schema}.icms_risk_warning_sign.compsize is '企业规模';
comment on column ${iol_schema}.icms_risk_warning_sign.customertype is '客户类型';
comment on column ${iol_schema}.icms_risk_warning_sign.monitorcontent is '预警信号内容';
comment on column ${iol_schema}.icms_risk_warning_sign.riskcontrolplan is '拟采取的处置计划和风险控制措施';
comment on column ${iol_schema}.icms_risk_warning_sign.compprop is '企业性质';
comment on column ${iol_schema}.icms_risk_warning_sign.isprveconomy is '是否民营';
comment on column ${iol_schema}.icms_risk_warning_sign.productid is '产品编号';
comment on column ${iol_schema}.icms_risk_warning_sign.riskdealno is '助贷风险处理流水';
comment on column ${iol_schema}.icms_risk_warning_sign.managerorgid is '主管机构';
comment on column ${iol_schema}.icms_risk_warning_sign.customerid is '客户编号';
comment on column ${iol_schema}.icms_risk_warning_sign.industryname is '所属行业名称';
comment on column ${iol_schema}.icms_risk_warning_sign.signtype is '预警信号类型';
comment on column ${iol_schema}.icms_risk_warning_sign.checktaskno is '检查任务编号';
comment on column ${iol_schema}.icms_risk_warning_sign.industrytype is '所属行业类型';
comment on column ${iol_schema}.icms_risk_warning_sign.creditdesc is '当前授信情况';
comment on column ${iol_schema}.icms_risk_warning_sign.releasedate is '解除日期';
comment on column ${iol_schema}.icms_risk_warning_sign.updatedate is '更新日期';
comment on column ${iol_schema}.icms_risk_warning_sign.accumrepaysum is '累计还款本金';
comment on column ${iol_schema}.icms_risk_warning_sign.monitortaskno is '监测任务编号';
comment on column ${iol_schema}.icms_risk_warning_sign.effectdate is '生效日期';
comment on column ${iol_schema}.icms_risk_warning_sign.signstatus is '预警信号状态';
comment on column ${iol_schema}.icms_risk_warning_sign.inputdate is '登记日期';
comment on column ${iol_schema}.icms_risk_warning_sign.createtype is '生成方式';
comment on column ${iol_schema}.icms_risk_warning_sign.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_risk_warning_sign.effectresult is '生效原因';
comment on column ${iol_schema}.icms_risk_warning_sign.risklosslevel is '本笔贷款的风险程度及预计损失程度';
comment on column ${iol_schema}.icms_risk_warning_sign.overduelevel is '逾期等级';
comment on column ${iol_schema}.icms_risk_warning_sign.dealdate is '处理日期';
comment on column ${iol_schema}.icms_risk_warning_sign.infactfindate is '实际审批完成日期';
comment on column ${iol_schema}.icms_risk_warning_sign.batserialno is '处理批次流水号';
comment on column ${iol_schema}.icms_risk_warning_sign.term is '期限';
comment on column ${iol_schema}.icms_risk_warning_sign.manageruserid is '主管客户经理';
comment on column ${iol_schema}.icms_risk_warning_sign.certtype is '证件类型';
comment on column ${iol_schema}.icms_risk_warning_sign.certid is '证件号码';
comment on column ${iol_schema}.icms_risk_warning_sign.start_dt is '开始时间';
comment on column ${iol_schema}.icms_risk_warning_sign.end_dt is '结束时间';
comment on column ${iol_schema}.icms_risk_warning_sign.id_mark is '增删标志';
comment on column ${iol_schema}.icms_risk_warning_sign.etl_timestamp is 'ETL处理时间戳';
