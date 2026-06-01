/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_irs_apply_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_irs_apply_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_irs_apply_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_irs_apply_info(
    adjustlasttime date -- 最后特例调整时间
    ,adjustlevel varchar2(8) -- 特例调整等级
    ,applyid varchar2(64) -- 申请id
    ,applytype varchar2(32) -- 流程申请类型
    ,approvestatus varchar2(16) -- 审批状态
    ,auditflag varchar2(1) -- 使用财报是否审计
    ,balance number(24,6) -- 业务余额
    ,creditapplyid varchar2(64) -- 授信申请Id(授信途中发起评级才会有)
    ,creditsync varchar2(1) -- 是否同步授信流程 1是0否 授信发起的评级流程如果需要同步则为1，如果评级流程单独触发过退回则不再同步
    ,customerid varchar2(64) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,customertype varchar2(1) -- 客户类型
    ,datasource varchar2(1) -- 数据来源 1.申请2.跑批3.老评级
    ,entscale varchar2(18) -- 企业规模
    ,enttype varchar2(200) -- 企业类型 参考字典IrsEntType
    ,finallevel varchar2(8) -- 确认等级
    ,hightech varchar2(2) -- 是否高新技术企业
    ,industrytype varchar2(100) -- 国标行业
    ,inputdate date -- 创建时间
    ,inputorgid varchar2(64) -- 创建人机构
    ,inputorgname varchar2(200) -- 创建机构名称
    ,inputuserid varchar2(64) -- 创建人id
    ,inputusername varchar2(200) -- 创建人名称
    ,lastapplyid varchar2(64) -- 上期申请Id
    ,lastreporttime varchar2(6) -- 最新年报期次
    ,modelcode varchar2(64) -- 模型编码
    ,modelname varchar2(64) -- 模型名称
    ,needreport varchar2(1) -- 是否需要财报
    ,occurtype varchar2(2) -- 评级发生类型 1.评级认定2.评级更新
    ,originlevel varchar2(8) -- 初始机评等级
    ,overthrowlevel varchar2(8) -- 推翻等级
    ,overthrowreason varchar2(500) -- 推翻原因
    ,phaseopinion varchar2(4000) -- 签署意见
    ,pusherrorinfo varchar2(200) -- 同盾推动异常信息，如果推送成功则为空
    ,ratedelaydate date -- 本次延期期限
    ,ratedelaymonth varchar2(2) -- 申请延期时长（月）
    ,ratedelayreason varchar2(1000) -- 延期原因
    ,rateobjtype varchar2(2) -- 评级对象类型
    ,realestate varchar2(2) -- 是否房地产开发公司
    ,remark varchar2(4000) -- 备注
    ,reportno varchar2(64) -- 使用财报编号
    ,reportscope varchar2(18) -- 使用财报的口径
    ,reporttime varchar2(6) -- 评级期次 使用财报则为财报期次，否则为T-1年度
    ,reporttypeno varchar2(32) -- 财报类型
    ,savelimittimes number(22) -- 保存限制次数
    ,savetimes number(22) -- 已经保存次数 防止客户经理多次保存探索规则引擎计算规律
    ,setupdate date -- 成立日期
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
grant select on ${iol_schema}.icms_irs_apply_info to ${iml_schema};
grant select on ${iol_schema}.icms_irs_apply_info to ${icl_schema};
grant select on ${iol_schema}.icms_irs_apply_info to ${idl_schema};
grant select on ${iol_schema}.icms_irs_apply_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_irs_apply_info is '评级申请表';
comment on column ${iol_schema}.icms_irs_apply_info.adjustlasttime is '最后特例调整时间';
comment on column ${iol_schema}.icms_irs_apply_info.adjustlevel is '特例调整等级';
comment on column ${iol_schema}.icms_irs_apply_info.applyid is '申请id';
comment on column ${iol_schema}.icms_irs_apply_info.applytype is '流程申请类型';
comment on column ${iol_schema}.icms_irs_apply_info.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_irs_apply_info.auditflag is '使用财报是否审计';
comment on column ${iol_schema}.icms_irs_apply_info.balance is '业务余额';
comment on column ${iol_schema}.icms_irs_apply_info.creditapplyid is '授信申请Id(授信途中发起评级才会有)';
comment on column ${iol_schema}.icms_irs_apply_info.creditsync is '是否同步授信流程 1是0否 授信发起的评级流程如果需要同步则为1，如果评级流程单独触发过退回则不再同步';
comment on column ${iol_schema}.icms_irs_apply_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_irs_apply_info.customername is '客户名称';
comment on column ${iol_schema}.icms_irs_apply_info.customertype is '客户类型';
comment on column ${iol_schema}.icms_irs_apply_info.datasource is '数据来源 1.申请2.跑批3.老评级';
comment on column ${iol_schema}.icms_irs_apply_info.entscale is '企业规模';
comment on column ${iol_schema}.icms_irs_apply_info.enttype is '企业类型 参考字典IrsEntType';
comment on column ${iol_schema}.icms_irs_apply_info.finallevel is '确认等级';
comment on column ${iol_schema}.icms_irs_apply_info.hightech is '是否高新技术企业';
comment on column ${iol_schema}.icms_irs_apply_info.industrytype is '国标行业';
comment on column ${iol_schema}.icms_irs_apply_info.inputdate is '创建时间';
comment on column ${iol_schema}.icms_irs_apply_info.inputorgid is '创建人机构';
comment on column ${iol_schema}.icms_irs_apply_info.inputorgname is '创建机构名称';
comment on column ${iol_schema}.icms_irs_apply_info.inputuserid is '创建人id';
comment on column ${iol_schema}.icms_irs_apply_info.inputusername is '创建人名称';
comment on column ${iol_schema}.icms_irs_apply_info.lastapplyid is '上期申请Id';
comment on column ${iol_schema}.icms_irs_apply_info.lastreporttime is '最新年报期次';
comment on column ${iol_schema}.icms_irs_apply_info.modelcode is '模型编码';
comment on column ${iol_schema}.icms_irs_apply_info.modelname is '模型名称';
comment on column ${iol_schema}.icms_irs_apply_info.needreport is '是否需要财报';
comment on column ${iol_schema}.icms_irs_apply_info.occurtype is '评级发生类型 1.评级认定2.评级更新';
comment on column ${iol_schema}.icms_irs_apply_info.originlevel is '初始机评等级';
comment on column ${iol_schema}.icms_irs_apply_info.overthrowlevel is '推翻等级';
comment on column ${iol_schema}.icms_irs_apply_info.overthrowreason is '推翻原因';
comment on column ${iol_schema}.icms_irs_apply_info.phaseopinion is '签署意见';
comment on column ${iol_schema}.icms_irs_apply_info.pusherrorinfo is '同盾推动异常信息，如果推送成功则为空';
comment on column ${iol_schema}.icms_irs_apply_info.ratedelaydate is '本次延期期限';
comment on column ${iol_schema}.icms_irs_apply_info.ratedelaymonth is '申请延期时长（月）';
comment on column ${iol_schema}.icms_irs_apply_info.ratedelayreason is '延期原因';
comment on column ${iol_schema}.icms_irs_apply_info.rateobjtype is '评级对象类型';
comment on column ${iol_schema}.icms_irs_apply_info.realestate is '是否房地产开发公司';
comment on column ${iol_schema}.icms_irs_apply_info.remark is '备注';
comment on column ${iol_schema}.icms_irs_apply_info.reportno is '使用财报编号';
comment on column ${iol_schema}.icms_irs_apply_info.reportscope is '使用财报的口径';
comment on column ${iol_schema}.icms_irs_apply_info.reporttime is '评级期次 使用财报则为财报期次，否则为T-1年度';
comment on column ${iol_schema}.icms_irs_apply_info.reporttypeno is '财报类型';
comment on column ${iol_schema}.icms_irs_apply_info.savelimittimes is '保存限制次数';
comment on column ${iol_schema}.icms_irs_apply_info.savetimes is '已经保存次数 防止客户经理多次保存探索规则引擎计算规律';
comment on column ${iol_schema}.icms_irs_apply_info.setupdate is '成立日期';
comment on column ${iol_schema}.icms_irs_apply_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_irs_apply_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_irs_apply_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_irs_apply_info.etl_timestamp is 'ETL处理时间戳';
