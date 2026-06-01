/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_business_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_business_history
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_business_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_business_history(
    businessno varchar2(64) -- 额度系统业务编号
    ,creditphase varchar2(64) -- 当前授信阶段
    ,customerid varchar2(64) -- 额度系统客户编号
    ,timelimitday number(22) -- 期限日
    ,totalpayment number(24,6) -- 累计放款
    ,businesstype varchar2(160) -- 业务品种
    ,slowreleaseexposureamount number(24,6) -- 可缓释敞口金额
    ,timelimitmonth number(22) -- 期限月
    ,availableexposureamount number(24,6) -- 可用敞口金额
    ,manageorgid varchar2(64) -- 管理机构
    ,floatingrate number(24,6) -- 浮动利率
    ,sourcesystem varchar2(64) -- 最初来源系统
    ,execnominalamount number(24,6) -- 执行名义金额
    ,occupyflag varchar2(64) -- 占用标识
    ,expiredate timestamp -- 到期日
    ,operateuserid varchar2(64) -- 经办人
    ,manageuserid varchar2(64) -- 管理人
    ,availablenominalamount number(24,6) -- 可用名义金额
    ,exposurebalance number(24,6) -- 授信敞口余额
    ,currency varchar2(64) -- 币种
    ,execexposureamount number(24,6) -- 执行敞口金额
    ,operateorgid varchar2(64) -- 经办机构
    ,status varchar2(64) -- 状态
    ,inputuserid varchar2(64) -- 登记人
    ,pledgerate number(24,6) -- 抵质押率
    ,nominalbalance number(24,6) -- 授信名义余额
    ,execslowreleaseexposureamount number(24,6) -- 执行可缓释敞口金额
    ,slowreleaseexposurecurrency varchar2(64) -- 可缓释敞口金额币种
    ,actualexpiredate timestamp -- 实际终结日
    ,updateorgid varchar2(64) -- 最后更新机构
    ,securitydeposit number(24,6) -- 保证金
    ,sourcebusinessno varchar2(64) -- 最初来源业务编号
    ,occurway varchar2(64) -- 发生方式
    ,exposureamount number(24,6) -- 敞口金额
    ,remark varchar2(1000) -- 备注
    ,inputdate timestamp -- 登记日期
    ,updatedate timestamp -- 最后更新日期
    ,createdway varchar2(64) -- 创建方式:审批/系统
    ,guarantyway varchar2(64) -- 担保方式
    ,totalrepayment number(24,6) -- 累计还款
    ,inputorgid varchar2(64) -- 登记机构
    ,nominalamount number(24,6) -- 名义金额
    ,recyclable varchar2(2) -- 可循环标志Y/N
    ,amountfactor number(24,6) -- 金额折算系数
    ,updateuserid varchar2(64) -- 最后更新人
    ,effectivedate timestamp -- 生效日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_cl_business_history to ${iml_schema};
grant select on ${iol_schema}.icms_cl_business_history to ${icl_schema};
grant select on ${iol_schema}.icms_cl_business_history to ${idl_schema};
grant select on ${iol_schema}.icms_cl_business_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_business_history is '授信业务信息历史表';
comment on column ${iol_schema}.icms_cl_business_history.businessno is '额度系统业务编号';
comment on column ${iol_schema}.icms_cl_business_history.creditphase is '当前授信阶段';
comment on column ${iol_schema}.icms_cl_business_history.customerid is '额度系统客户编号';
comment on column ${iol_schema}.icms_cl_business_history.timelimitday is '期限日';
comment on column ${iol_schema}.icms_cl_business_history.totalpayment is '累计放款';
comment on column ${iol_schema}.icms_cl_business_history.businesstype is '业务品种';
comment on column ${iol_schema}.icms_cl_business_history.slowreleaseexposureamount is '可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_business_history.timelimitmonth is '期限月';
comment on column ${iol_schema}.icms_cl_business_history.availableexposureamount is '可用敞口金额';
comment on column ${iol_schema}.icms_cl_business_history.manageorgid is '管理机构';
comment on column ${iol_schema}.icms_cl_business_history.floatingrate is '浮动利率';
comment on column ${iol_schema}.icms_cl_business_history.sourcesystem is '最初来源系统';
comment on column ${iol_schema}.icms_cl_business_history.execnominalamount is '执行名义金额';
comment on column ${iol_schema}.icms_cl_business_history.occupyflag is '占用标识';
comment on column ${iol_schema}.icms_cl_business_history.expiredate is '到期日';
comment on column ${iol_schema}.icms_cl_business_history.operateuserid is '经办人';
comment on column ${iol_schema}.icms_cl_business_history.manageuserid is '管理人';
comment on column ${iol_schema}.icms_cl_business_history.availablenominalamount is '可用名义金额';
comment on column ${iol_schema}.icms_cl_business_history.exposurebalance is '授信敞口余额';
comment on column ${iol_schema}.icms_cl_business_history.currency is '币种';
comment on column ${iol_schema}.icms_cl_business_history.execexposureamount is '执行敞口金额';
comment on column ${iol_schema}.icms_cl_business_history.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_cl_business_history.status is '状态';
comment on column ${iol_schema}.icms_cl_business_history.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_business_history.pledgerate is '抵质押率';
comment on column ${iol_schema}.icms_cl_business_history.nominalbalance is '授信名义余额';
comment on column ${iol_schema}.icms_cl_business_history.execslowreleaseexposureamount is '执行可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_business_history.slowreleaseexposurecurrency is '可缓释敞口金额币种';
comment on column ${iol_schema}.icms_cl_business_history.actualexpiredate is '实际终结日';
comment on column ${iol_schema}.icms_cl_business_history.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_business_history.securitydeposit is '保证金';
comment on column ${iol_schema}.icms_cl_business_history.sourcebusinessno is '最初来源业务编号';
comment on column ${iol_schema}.icms_cl_business_history.occurway is '发生方式';
comment on column ${iol_schema}.icms_cl_business_history.exposureamount is '敞口金额';
comment on column ${iol_schema}.icms_cl_business_history.remark is '备注';
comment on column ${iol_schema}.icms_cl_business_history.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_business_history.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_business_history.createdway is '创建方式:审批/系统';
comment on column ${iol_schema}.icms_cl_business_history.guarantyway is '担保方式';
comment on column ${iol_schema}.icms_cl_business_history.totalrepayment is '累计还款';
comment on column ${iol_schema}.icms_cl_business_history.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_business_history.nominalamount is '名义金额';
comment on column ${iol_schema}.icms_cl_business_history.recyclable is '可循环标志Y/N';
comment on column ${iol_schema}.icms_cl_business_history.amountfactor is '金额折算系数';
comment on column ${iol_schema}.icms_cl_business_history.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_business_history.effectivedate is '生效日期';
comment on column ${iol_schema}.icms_cl_business_history.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_business_history.etl_timestamp is 'ETL处理时间戳';
