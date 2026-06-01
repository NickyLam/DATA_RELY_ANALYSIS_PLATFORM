/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_business_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_business_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_business_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_business_info(
    amountfactor number(24,6) -- 金额折算系数
    ,operateorgid varchar2(64) -- 经办机构
    ,inputuserid varchar2(64) -- 登记人
    ,sourcesystem varchar2(64) -- 最初来源系统
    ,recyclable varchar2(2) -- 可循环标志Y/N
    ,actualexpiredate timestamp -- 实际终结日
    ,operateuserid varchar2(64) -- 经办人
    ,actualprenomamount number(24,6) -- 实际占用预占名义金额
    ,slowreleaseexposureamount number(24,6) -- 可缓释敞口金额
    ,updateuserid varchar2(64) -- 最后更新人
    ,updatedate timestamp -- 最后更新日期
    ,preno varchar2(64) -- 
    ,exposurebalance number(24,6) -- 授信敞口余额
    ,slowreleaseexposurecurrency varchar2(3) -- 可缓释敞口金额币种
    ,timelimitmonth number(22) -- 期限月
    ,floatingrate number(24,6) -- 浮动利率
    ,balanceupdatetime timestamp -- 余额更新时间
    ,totalrepayment number(24,6) -- 累计还款
    ,manageuserid varchar2(64) -- 管理人
    ,manageorgid varchar2(12) -- 管理机构
    ,islowrisk varchar2(2) -- 是否是低风险业务
    ,exposureamount number(24,6) -- 敞口金额
    ,guarantyway varchar2(2) -- 担保方式
    ,expiredate timestamp -- 到期日
    ,timelimitday number(22) -- 期限日
    ,updateorgid varchar2(64) -- 最后更新机构
    ,businesstype varchar2(160) -- 业务品种
    ,currency varchar2(3) -- 币种
    ,totalpayment number(24,6) -- 累计放款
    ,securitydeposit number(24,6) -- 保证金
    ,execnominalamount number(24,6) -- 执行名义金额
    ,availableexposureamount number(24,6) -- 可用敞口金额
    ,occupyflag varchar2(64) -- 占用标识
    ,customerid varchar2(32) -- 额度系统客户编号
    ,nominalamount number(24,6) -- 名义金额
    ,nominalbalance number(24,6) -- 授信名义余额
    ,occurway varchar2(64) -- 发生方式
    ,execslowreleaseexposureamount number(24,6) -- 执行可缓释敞口金额
    ,status varchar2(64) -- 状态
    ,inputdate timestamp -- 登记日期
    ,pledgerate number(15,8) -- 抵质押率
    ,creditphase varchar2(64) -- 当前授信阶段
    ,inputorgid varchar2(64) -- 登记机构
    ,businessno varchar2(64) -- 额度系统业务编号
    ,effectivedate timestamp -- 生效日期
    ,createdway varchar2(64) -- 创建方式:审批/系统
    ,availablenominalamount number(24,6) -- 可用名义金额
    ,remark varchar2(1000) -- 备注
    ,actualpreexpamount number(24,6) -- 
    ,execexposureamount number(24,6) -- 执行敞口金额
    ,sourcebusinessno varchar2(64) -- 最初来源业务编号
    ,pledgesum number(24,6) -- 抵质押物金额
    ,bctype varchar2(1) -- 业务合同类型：1 单笔单批
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
grant select on ${iol_schema}.icms_cl_business_info to ${iml_schema};
grant select on ${iol_schema}.icms_cl_business_info to ${icl_schema};
grant select on ${iol_schema}.icms_cl_business_info to ${idl_schema};
grant select on ${iol_schema}.icms_cl_business_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_business_info is '授信业务信息';
comment on column ${iol_schema}.icms_cl_business_info.amountfactor is '金额折算系数';
comment on column ${iol_schema}.icms_cl_business_info.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_cl_business_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_business_info.sourcesystem is '最初来源系统';
comment on column ${iol_schema}.icms_cl_business_info.recyclable is '可循环标志Y/N';
comment on column ${iol_schema}.icms_cl_business_info.actualexpiredate is '实际终结日';
comment on column ${iol_schema}.icms_cl_business_info.operateuserid is '经办人';
comment on column ${iol_schema}.icms_cl_business_info.actualprenomamount is '实际占用预占名义金额';
comment on column ${iol_schema}.icms_cl_business_info.slowreleaseexposureamount is '可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_business_info.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_business_info.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_business_info.preno is '';
comment on column ${iol_schema}.icms_cl_business_info.exposurebalance is '授信敞口余额';
comment on column ${iol_schema}.icms_cl_business_info.slowreleaseexposurecurrency is '可缓释敞口金额币种';
comment on column ${iol_schema}.icms_cl_business_info.timelimitmonth is '期限月';
comment on column ${iol_schema}.icms_cl_business_info.floatingrate is '浮动利率';
comment on column ${iol_schema}.icms_cl_business_info.balanceupdatetime is '余额更新时间';
comment on column ${iol_schema}.icms_cl_business_info.totalrepayment is '累计还款';
comment on column ${iol_schema}.icms_cl_business_info.manageuserid is '管理人';
comment on column ${iol_schema}.icms_cl_business_info.manageorgid is '管理机构';
comment on column ${iol_schema}.icms_cl_business_info.islowrisk is '是否是低风险业务';
comment on column ${iol_schema}.icms_cl_business_info.exposureamount is '敞口金额';
comment on column ${iol_schema}.icms_cl_business_info.guarantyway is '担保方式';
comment on column ${iol_schema}.icms_cl_business_info.expiredate is '到期日';
comment on column ${iol_schema}.icms_cl_business_info.timelimitday is '期限日';
comment on column ${iol_schema}.icms_cl_business_info.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_business_info.businesstype is '业务品种';
comment on column ${iol_schema}.icms_cl_business_info.currency is '币种';
comment on column ${iol_schema}.icms_cl_business_info.totalpayment is '累计放款';
comment on column ${iol_schema}.icms_cl_business_info.securitydeposit is '保证金';
comment on column ${iol_schema}.icms_cl_business_info.execnominalamount is '执行名义金额';
comment on column ${iol_schema}.icms_cl_business_info.availableexposureamount is '可用敞口金额';
comment on column ${iol_schema}.icms_cl_business_info.occupyflag is '占用标识';
comment on column ${iol_schema}.icms_cl_business_info.customerid is '额度系统客户编号';
comment on column ${iol_schema}.icms_cl_business_info.nominalamount is '名义金额';
comment on column ${iol_schema}.icms_cl_business_info.nominalbalance is '授信名义余额';
comment on column ${iol_schema}.icms_cl_business_info.occurway is '发生方式';
comment on column ${iol_schema}.icms_cl_business_info.execslowreleaseexposureamount is '执行可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_business_info.status is '状态';
comment on column ${iol_schema}.icms_cl_business_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_business_info.pledgerate is '抵质押率';
comment on column ${iol_schema}.icms_cl_business_info.creditphase is '当前授信阶段';
comment on column ${iol_schema}.icms_cl_business_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_business_info.businessno is '额度系统业务编号';
comment on column ${iol_schema}.icms_cl_business_info.effectivedate is '生效日期';
comment on column ${iol_schema}.icms_cl_business_info.createdway is '创建方式:审批/系统';
comment on column ${iol_schema}.icms_cl_business_info.availablenominalamount is '可用名义金额';
comment on column ${iol_schema}.icms_cl_business_info.remark is '备注';
comment on column ${iol_schema}.icms_cl_business_info.actualpreexpamount is '';
comment on column ${iol_schema}.icms_cl_business_info.execexposureamount is '执行敞口金额';
comment on column ${iol_schema}.icms_cl_business_info.sourcebusinessno is '最初来源业务编号';
comment on column ${iol_schema}.icms_cl_business_info.pledgesum is '抵质押物金额';
comment on column ${iol_schema}.icms_cl_business_info.bctype is '业务合同类型：1 单笔单批';
comment on column ${iol_schema}.icms_cl_business_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_cl_business_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_cl_business_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_cl_business_info.etl_timestamp is 'ETL处理时间戳';
