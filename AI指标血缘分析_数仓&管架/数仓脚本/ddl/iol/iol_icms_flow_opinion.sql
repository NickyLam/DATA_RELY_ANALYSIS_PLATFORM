/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_flow_opinion
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_flow_opinion
whenever sqlerror continue none;
drop table ${iol_schema}.icms_flow_opinion purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_flow_opinion(
    serialno varchar2(64) -- 流程节点编号
    ,opinionno varchar2(64) -- 意见编号
    ,objecttype varchar2(64) -- 流程对象任务类型
    ,objectno varchar2(64) -- 流程对象编号
    ,customerid varchar2(64) -- 客户编号
    ,customername varchar2(160) -- 客户名称
    ,businesscurrency varchar2(64) -- 业务币种
    ,businesssum number(24,6) -- 名义金额
    ,termyear number(38,0) -- 期限（年）
    ,termmonth number(38,0) -- 期限（月）
    ,termday number(38,0) -- 期限（日）
    ,baseratetype varchar2(64) -- 基准利率类型
    ,ratefloattype varchar2(64) -- 利率浮动方式
    ,ratefloat number(24,8) -- 利率浮动值
    ,bailcurrency varchar2(64) -- 保证金币种
    ,businessrate number(24,8) -- 执行利率
    ,bailratio number(24,8) -- 保证金比率
    ,bailsum number(24,6) -- 保证金金额
    ,pdgratio number(24,8) -- 手续费比率
    ,pdgsum number(24,6) -- 手续费金额
    ,baserate number(24,8) -- 基准;年)利率
    ,phaseopinion varchar2(4000) -- 节点意见详情
    ,phaseopinion1 varchar2(4000) -- 意见详情1
    ,phaseopinion2 varchar2(4000) -- 意见详情2
    ,phaseopinion3 varchar2(4000) -- 意见详情3
    ,exposuresum number(24,6) -- 敞口金额
    ,opiniontype varchar2(36) -- 意见类型
    ,inputorg varchar2(64) -- 登记机构
    ,inputuser varchar2(64) -- 登记人
    ,updateorg varchar2(64) -- 更新机构
    ,updateuser varchar2(64) -- 更新人
    ,inputtime date -- 登记时间
    ,updatetime date -- 更新时间
    ,phasechoice varchar2(2000) -- 阶段意见
    ,warehousing varchar2(9) -- 是否入库
    ,payreq varchar2(4000) -- 授信方案
    ,afterpayreq varchar2(4000) -- 发放与支付前须落实的特殊限制性条件
    ,contractreq varchar2(4000) -- 需落实到合同、协议中的特殊要求
    ,loanmanagereq varchar2(4000) -- 贷后管理要求
    ,agreemachine varchar2(2) -- 是否认可机器决策结果
    ,riskexposuresum number(24,6) -- 其中，一般风险敞口限额
    ,iscycle varchar2(2) -- 是否循环(额度);是否循环
    ,isyeartocheck varchar2(4) -- 是否需要年审
    ,isjoinlimits varchar2(2) -- 是否纳入单一客户或集团的限额
    ,onlineamount number(24,6) -- 线上额度(元)
    ,repaytype varchar2(4) -- 还款方式
    ,repaycycle varchar2(36) -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
    ,balloonamortenddate date -- 气球贷摊销到期日
    ,coopterm number(38,0) -- 合作期限(月)
    ,nominalsum number(24,6) -- 项目总额度(元)
    ,firstusesum number(24,6) -- 先期启用额度
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,lowriskexposuresum number(24,6) -- 其中，类低风险敞口金额(元)
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
grant select on ${iol_schema}.icms_flow_opinion to ${iml_schema};
grant select on ${iol_schema}.icms_flow_opinion to ${icl_schema};
grant select on ${iol_schema}.icms_flow_opinion to ${idl_schema};
grant select on ${iol_schema}.icms_flow_opinion to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_flow_opinion is '流程信息表';
comment on column ${iol_schema}.icms_flow_opinion.serialno is '流程节点编号';
comment on column ${iol_schema}.icms_flow_opinion.opinionno is '意见编号';
comment on column ${iol_schema}.icms_flow_opinion.objecttype is '流程对象任务类型';
comment on column ${iol_schema}.icms_flow_opinion.objectno is '流程对象编号';
comment on column ${iol_schema}.icms_flow_opinion.customerid is '客户编号';
comment on column ${iol_schema}.icms_flow_opinion.customername is '客户名称';
comment on column ${iol_schema}.icms_flow_opinion.businesscurrency is '业务币种';
comment on column ${iol_schema}.icms_flow_opinion.businesssum is '名义金额';
comment on column ${iol_schema}.icms_flow_opinion.termyear is '期限（年）';
comment on column ${iol_schema}.icms_flow_opinion.termmonth is '期限（月）';
comment on column ${iol_schema}.icms_flow_opinion.termday is '期限（日）';
comment on column ${iol_schema}.icms_flow_opinion.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_flow_opinion.ratefloattype is '利率浮动方式';
comment on column ${iol_schema}.icms_flow_opinion.ratefloat is '利率浮动值';
comment on column ${iol_schema}.icms_flow_opinion.bailcurrency is '保证金币种';
comment on column ${iol_schema}.icms_flow_opinion.businessrate is '执行利率';
comment on column ${iol_schema}.icms_flow_opinion.bailratio is '保证金比率';
comment on column ${iol_schema}.icms_flow_opinion.bailsum is '保证金金额';
comment on column ${iol_schema}.icms_flow_opinion.pdgratio is '手续费比率';
comment on column ${iol_schema}.icms_flow_opinion.pdgsum is '手续费金额';
comment on column ${iol_schema}.icms_flow_opinion.baserate is '基准;年)利率';
comment on column ${iol_schema}.icms_flow_opinion.phaseopinion is '节点意见详情';
comment on column ${iol_schema}.icms_flow_opinion.phaseopinion1 is '意见详情1';
comment on column ${iol_schema}.icms_flow_opinion.phaseopinion2 is '意见详情2';
comment on column ${iol_schema}.icms_flow_opinion.phaseopinion3 is '意见详情3';
comment on column ${iol_schema}.icms_flow_opinion.exposuresum is '敞口金额';
comment on column ${iol_schema}.icms_flow_opinion.opiniontype is '意见类型';
comment on column ${iol_schema}.icms_flow_opinion.inputorg is '登记机构';
comment on column ${iol_schema}.icms_flow_opinion.inputuser is '登记人';
comment on column ${iol_schema}.icms_flow_opinion.updateorg is '更新机构';
comment on column ${iol_schema}.icms_flow_opinion.updateuser is '更新人';
comment on column ${iol_schema}.icms_flow_opinion.inputtime is '登记时间';
comment on column ${iol_schema}.icms_flow_opinion.updatetime is '更新时间';
comment on column ${iol_schema}.icms_flow_opinion.phasechoice is '阶段意见';
comment on column ${iol_schema}.icms_flow_opinion.warehousing is '是否入库';
comment on column ${iol_schema}.icms_flow_opinion.payreq is '授信方案';
comment on column ${iol_schema}.icms_flow_opinion.afterpayreq is '发放与支付前须落实的特殊限制性条件';
comment on column ${iol_schema}.icms_flow_opinion.contractreq is '需落实到合同、协议中的特殊要求';
comment on column ${iol_schema}.icms_flow_opinion.loanmanagereq is '贷后管理要求';
comment on column ${iol_schema}.icms_flow_opinion.agreemachine is '是否认可机器决策结果';
comment on column ${iol_schema}.icms_flow_opinion.riskexposuresum is '其中，一般风险敞口限额';
comment on column ${iol_schema}.icms_flow_opinion.iscycle is '是否循环(额度);是否循环';
comment on column ${iol_schema}.icms_flow_opinion.isyeartocheck is '是否需要年审';
comment on column ${iol_schema}.icms_flow_opinion.isjoinlimits is '是否纳入单一客户或集团的限额';
comment on column ${iol_schema}.icms_flow_opinion.onlineamount is '线上额度(元)';
comment on column ${iol_schema}.icms_flow_opinion.repaytype is '还款方式';
comment on column ${iol_schema}.icms_flow_opinion.repaycycle is '还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)';
comment on column ${iol_schema}.icms_flow_opinion.balloonamortenddate is '气球贷摊销到期日';
comment on column ${iol_schema}.icms_flow_opinion.coopterm is '合作期限(月)';
comment on column ${iol_schema}.icms_flow_opinion.nominalsum is '项目总额度(元)';
comment on column ${iol_schema}.icms_flow_opinion.firstusesum is '先期启用额度';
comment on column ${iol_schema}.icms_flow_opinion.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_flow_opinion.lowriskexposuresum is '其中，类低风险敞口金额(元)';
comment on column ${iol_schema}.icms_flow_opinion.start_dt is '开始时间';
comment on column ${iol_schema}.icms_flow_opinion.end_dt is '结束时间';
comment on column ${iol_schema}.icms_flow_opinion.id_mark is '增删标志';
comment on column ${iol_schema}.icms_flow_opinion.etl_timestamp is 'ETL处理时间戳';
