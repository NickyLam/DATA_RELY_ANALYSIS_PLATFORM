/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_business_serial
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_business_serial
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_business_serial purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_business_serial(
    occurway varchar2(64) -- 发生方式
    ,slowreleaseexposureamount number(24,6) -- 可缓释敞口金额
    ,pledgerate number(15,8) -- 抵质押率
    ,timelimitmonth number(38) -- 期限月
    ,manageorgid varchar2(12) -- 管理机构
    ,exposureamount number(24,6) -- 敞口金额
    ,status varchar2(64) -- 状态
    ,availablenominalamount number(24,6) -- 可用名义金额
    ,availableexposureamount number(24,6) -- 可用敞口金额
    ,expiredate timestamp -- 到期日
    ,operateuserid varchar2(64) -- 经办人
    ,totalpayment number(24,6) -- 累计放款
    ,execnominalamount number(24,6) -- 执行名义金额
    ,occupyflag varchar2(64) -- 占用标识
    ,actualexpiredate timestamp -- 实际终结日
    ,manageuserid varchar2(64) -- 管理人
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,updateuserid varchar2(64) -- 最后更新人
    ,updateorgid varchar2(64) -- 最后更新机构
    ,execexposureamount number(24,6) -- 执行敞口金额
    ,effectivedate timestamp -- 生效日期
    ,businessno varchar2(64) -- 额度系统业务编号
    ,sourcebusinessno varchar2(64) -- 最初来源业务编号
    ,nominalamount number(24,6) -- 名义金额
    ,guarantyway varchar2(2) -- 担保方式
    ,operateorgid varchar2(64) -- 经办机构
    ,businesstype varchar2(160) -- 业务品种
    ,creditphase varchar2(64) -- 当前授信阶段
    ,nominalbalance number(24,6) -- 授信名义余额
    ,timelimitday number(38) -- 期限日
    ,sourcesystem varchar2(64) -- 最初来源系统
    ,currency varchar2(3) -- 币种
    ,recyclable varchar2(2) -- 可循环标志Y/N
    ,inputdate timestamp -- 登记日期
    ,exposurebalance number(24,6) -- 授信敞口余额
    ,execslowreleaseexposureamount number(24,6) -- 执行可缓释敞口金额
    ,slowreleaseexposurecurrency varchar2(3) -- 可缓释敞口金额币种
    ,securitydeposit number(24,6) -- 保证金
    ,totalrepayment number(24,6) -- 累计还款
    ,remark varchar2(1000) -- 备注
    ,serialno varchar2(64) -- 流水号
    ,createdway varchar2(64) -- 创建方式:审批/系统
    ,customerid varchar2(32) -- 额度系统客户编号
    ,amountfactor number(24,6) -- 金额折算系数
    ,updatedate timestamp -- 最后更新日期
    ,floatingrate number(24,6) -- 浮动利率
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
grant select on ${iol_schema}.icms_cl_business_serial to ${iml_schema};
grant select on ${iol_schema}.icms_cl_business_serial to ${icl_schema};
grant select on ${iol_schema}.icms_cl_business_serial to ${idl_schema};
grant select on ${iol_schema}.icms_cl_business_serial to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_business_serial is '授信业务流水';
comment on column ${iol_schema}.icms_cl_business_serial.occurway is '发生方式';
comment on column ${iol_schema}.icms_cl_business_serial.slowreleaseexposureamount is '可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_business_serial.pledgerate is '抵质押率';
comment on column ${iol_schema}.icms_cl_business_serial.timelimitmonth is '期限月';
comment on column ${iol_schema}.icms_cl_business_serial.manageorgid is '管理机构';
comment on column ${iol_schema}.icms_cl_business_serial.exposureamount is '敞口金额';
comment on column ${iol_schema}.icms_cl_business_serial.status is '状态';
comment on column ${iol_schema}.icms_cl_business_serial.availablenominalamount is '可用名义金额';
comment on column ${iol_schema}.icms_cl_business_serial.availableexposureamount is '可用敞口金额';
comment on column ${iol_schema}.icms_cl_business_serial.expiredate is '到期日';
comment on column ${iol_schema}.icms_cl_business_serial.operateuserid is '经办人';
comment on column ${iol_schema}.icms_cl_business_serial.totalpayment is '累计放款';
comment on column ${iol_schema}.icms_cl_business_serial.execnominalamount is '执行名义金额';
comment on column ${iol_schema}.icms_cl_business_serial.occupyflag is '占用标识';
comment on column ${iol_schema}.icms_cl_business_serial.actualexpiredate is '实际终结日';
comment on column ${iol_schema}.icms_cl_business_serial.manageuserid is '管理人';
comment on column ${iol_schema}.icms_cl_business_serial.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_business_serial.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_business_serial.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_business_serial.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_business_serial.execexposureamount is '执行敞口金额';
comment on column ${iol_schema}.icms_cl_business_serial.effectivedate is '生效日期';
comment on column ${iol_schema}.icms_cl_business_serial.businessno is '额度系统业务编号';
comment on column ${iol_schema}.icms_cl_business_serial.sourcebusinessno is '最初来源业务编号';
comment on column ${iol_schema}.icms_cl_business_serial.nominalamount is '名义金额';
comment on column ${iol_schema}.icms_cl_business_serial.guarantyway is '担保方式';
comment on column ${iol_schema}.icms_cl_business_serial.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_cl_business_serial.businesstype is '业务品种';
comment on column ${iol_schema}.icms_cl_business_serial.creditphase is '当前授信阶段';
comment on column ${iol_schema}.icms_cl_business_serial.nominalbalance is '授信名义余额';
comment on column ${iol_schema}.icms_cl_business_serial.timelimitday is '期限日';
comment on column ${iol_schema}.icms_cl_business_serial.sourcesystem is '最初来源系统';
comment on column ${iol_schema}.icms_cl_business_serial.currency is '币种';
comment on column ${iol_schema}.icms_cl_business_serial.recyclable is '可循环标志Y/N';
comment on column ${iol_schema}.icms_cl_business_serial.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_business_serial.exposurebalance is '授信敞口余额';
comment on column ${iol_schema}.icms_cl_business_serial.execslowreleaseexposureamount is '执行可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_business_serial.slowreleaseexposurecurrency is '可缓释敞口金额币种';
comment on column ${iol_schema}.icms_cl_business_serial.securitydeposit is '保证金';
comment on column ${iol_schema}.icms_cl_business_serial.totalrepayment is '累计还款';
comment on column ${iol_schema}.icms_cl_business_serial.remark is '备注';
comment on column ${iol_schema}.icms_cl_business_serial.serialno is '流水号';
comment on column ${iol_schema}.icms_cl_business_serial.createdway is '创建方式:审批/系统';
comment on column ${iol_schema}.icms_cl_business_serial.customerid is '额度系统客户编号';
comment on column ${iol_schema}.icms_cl_business_serial.amountfactor is '金额折算系数';
comment on column ${iol_schema}.icms_cl_business_serial.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_business_serial.floatingrate is '浮动利率';
comment on column ${iol_schema}.icms_cl_business_serial.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_business_serial.etl_timestamp is 'ETL处理时间戳';
