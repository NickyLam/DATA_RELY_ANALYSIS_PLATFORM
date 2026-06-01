/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_credit_serial
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_credit_serial
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_credit_serial purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_credit_serial(
    reservedamount number(24,6) -- 预留金额
    ,creditphase varchar2(64) -- 当前授信阶段
    ,execslowreleaseexposureamount number(24,6) -- 执行可缓释敞口金额
    ,loweroccupyupperexposureamount number(24,6) -- 下层占用上层授信敞口金额
    ,bizbailinitialrate number(24,6) -- 额度下业务初始保证金比例
    ,preexposureamount number(24,6) -- 预占敞口金额
    ,availablereservedamount number(24,6) -- 可用预留金额
    ,actualexpiredate timestamp -- 实际终结日
    ,latestusedate date -- 额度最迟使用日期
    ,purpose varchar2(2000) -- 用途
    ,nominalamount number(24,6) -- 名义金额
    ,maxperioddayunderlowercredit number(38) -- 项下下层授信最长期限日）
    ,serialno varchar2(64) -- 流水号
    ,sourcecreditno varchar2(64) -- 最初来源额度编号
    ,status varchar2(48) -- 状态
    ,suboccupynominalbalance number(24,6) -- 下层授信名义余额占用汇总
    ,guarantyway varchar2(64) -- 担保方式
    ,totalrepayment number(24,6) -- 累计还款
    ,availableexposureamount number(24,6) -- 可用敞口金额
    ,usableamountcalcflag varchar2(64) -- 可用金额计算标志
    ,leftpreexposureamount number(24,6) -- 剩余预占敞口金额
    ,execexposureamount number(24,6) -- 执行敞口金额
    ,remark varchar2(1000) -- 备注
    ,assignoccupyupperexposureamoun number(24,6) -- 指定占用上层授信敞口金额
    ,ispubliccredit varchar2(12) -- 是否公开授信
    ,adjustnominalamount number(24,6) -- 串用名义金额
    ,freezenominalamount number(24,6) -- 冻结名义金额
    ,bizlowestfloatrate number(24,6) -- 额度下业务利率最低浮动
    ,expiredate timestamp -- 到期日
    ,lockflag varchar2(64) -- 锁定标识Y/N
    ,nominalbalance number(24,6) -- 授信名义余额
    ,inputorgid varchar2(64) -- 登记机构
    ,availablebusinesstype varchar2(2000) -- 适用业务品种
    ,businessoccupyexposureamount number(24,6) -- 下层的业务占用敞口金额汇总
    ,currency varchar2(3) -- 币种
    ,availablenominalamount number(24,6) -- 可用名义金额
    ,updateorgid varchar2(64) -- 最后更新机构
    ,leftprenominalamount number(24,6) -- 剩余预占名义金额
    ,credittype varchar2(160) -- 额度品种
    ,exposurebalance number(24,6) -- 授信敞口余额
    ,updateuserid varchar2(64) -- 最后更新人
    ,businessoccupynominalamount number(24,6) -- 下层的业务占用敞口金额汇总
    ,occurway varchar2(64) -- 发生方式
    ,exposureamount number(24,6) -- 敞口金额
    ,slowreleaseexposurecurrency varchar2(3) -- 可缓释敞口金额币种
    ,operateuserid varchar2(64) -- 经办人
    ,lineclass varchar2(64) -- 额度种类综合/专项/其他)
    ,totalpayment number(24,6) -- 累计放款
    ,createdway varchar2(64) -- 创建方式:审批/系统
    ,assignoccupyuppernominalamount number(24,6) -- 指定占用上层授信名义金额
    ,suboccupyexposurebalance number(24,6) -- 下层授信敞口余额占用汇总
    ,sourcesystem varchar2(64) -- 最初来源系统
    ,slowreleaseexposureamount number(24,6) -- 可缓释敞口金额
    ,inputdate timestamp -- 登记日期
    ,dedicatedflag varchar2(64) -- 授信专用标志
    ,operateorgid varchar2(64) -- 经办机构
    ,manageorgid varchar2(12) -- 管理机构
    ,freezeexposureamount number(24,6) -- 冻结敞口金额
    ,maxperiodmonthunderlowercredit number(38) -- 项下下层授信最长期限月）
    ,creditno varchar2(64) -- 额度系统业务编号
    ,latestartdateunderlowercredit timestamp -- 项下下层授信最迟起始日
    ,singlebizmostamount number(24,6) -- 明细额度下业务单笔最大金额
    ,customerid varchar2(32) -- 额度系统客户编号
    ,canbeextractedundercredit varchar2(2) -- 额度项下是否可直接提款Y或N
    ,updatedate timestamp -- 最后更新日期
    ,additioncommand varchar2(1000) -- 其他条件和要求
    ,freezestatus varchar2(64) -- 冻结状态已冻结、未冻结）
    ,earlystartdateunderlowercredit timestamp -- 项下下层授信最早起始日
    ,manageuserid varchar2(64) -- 管理人
    ,inputuserid varchar2(64) -- 登记人
    ,effectivedate timestamp -- 生效日期
    ,lateexpiredateunderlowercredit timestamp -- 项下下层授信最迟到期日
    ,occupyflag varchar2(64) -- 占用标识
    ,bizmostmortgagerate number(15,8) -- 额度下业务最高抵质押率
    ,execnominalamount number(24,6) -- 执行名义金额
    ,recyclable varchar2(2) -- 可循环标志Y/N
    ,timelimitday number(38) -- 期限日
    ,reservedcustomerid varchar2(2000) -- 预留客户编号
    ,prenominalamount number(24,6) -- 预占名义金额
    ,explain varchar2(600) -- 冻结、解冻、终结说明
    ,loweroccupyuppernominalamount number(24,6) -- 下层占用上层授信名义金额
    ,adjustexposureamount number(24,6) -- 串用敞口金额
    ,timelimitmonth number(38) -- 期限月
    ,currencyrange varchar2(160) -- 项下业务币种范围
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
grant select on ${iol_schema}.icms_cl_credit_serial to ${iml_schema};
grant select on ${iol_schema}.icms_cl_credit_serial to ${icl_schema};
grant select on ${iol_schema}.icms_cl_credit_serial to ${idl_schema};
grant select on ${iol_schema}.icms_cl_credit_serial to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_credit_serial is '授信额度流水';
comment on column ${iol_schema}.icms_cl_credit_serial.reservedamount is '预留金额';
comment on column ${iol_schema}.icms_cl_credit_serial.creditphase is '当前授信阶段';
comment on column ${iol_schema}.icms_cl_credit_serial.execslowreleaseexposureamount is '执行可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_credit_serial.loweroccupyupperexposureamount is '下层占用上层授信敞口金额';
comment on column ${iol_schema}.icms_cl_credit_serial.bizbailinitialrate is '额度下业务初始保证金比例';
comment on column ${iol_schema}.icms_cl_credit_serial.preexposureamount is '预占敞口金额';
comment on column ${iol_schema}.icms_cl_credit_serial.availablereservedamount is '可用预留金额';
comment on column ${iol_schema}.icms_cl_credit_serial.actualexpiredate is '实际终结日';
comment on column ${iol_schema}.icms_cl_credit_serial.latestusedate is '额度最迟使用日期';
comment on column ${iol_schema}.icms_cl_credit_serial.purpose is '用途';
comment on column ${iol_schema}.icms_cl_credit_serial.nominalamount is '名义金额';
comment on column ${iol_schema}.icms_cl_credit_serial.maxperioddayunderlowercredit is '项下下层授信最长期限日）';
comment on column ${iol_schema}.icms_cl_credit_serial.serialno is '流水号';
comment on column ${iol_schema}.icms_cl_credit_serial.sourcecreditno is '最初来源额度编号';
comment on column ${iol_schema}.icms_cl_credit_serial.status is '状态';
comment on column ${iol_schema}.icms_cl_credit_serial.suboccupynominalbalance is '下层授信名义余额占用汇总';
comment on column ${iol_schema}.icms_cl_credit_serial.guarantyway is '担保方式';
comment on column ${iol_schema}.icms_cl_credit_serial.totalrepayment is '累计还款';
comment on column ${iol_schema}.icms_cl_credit_serial.availableexposureamount is '可用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_serial.usableamountcalcflag is '可用金额计算标志';
comment on column ${iol_schema}.icms_cl_credit_serial.leftpreexposureamount is '剩余预占敞口金额';
comment on column ${iol_schema}.icms_cl_credit_serial.execexposureamount is '执行敞口金额';
comment on column ${iol_schema}.icms_cl_credit_serial.remark is '备注';
comment on column ${iol_schema}.icms_cl_credit_serial.assignoccupyupperexposureamoun is '指定占用上层授信敞口金额';
comment on column ${iol_schema}.icms_cl_credit_serial.ispubliccredit is '是否公开授信';
comment on column ${iol_schema}.icms_cl_credit_serial.adjustnominalamount is '串用名义金额';
comment on column ${iol_schema}.icms_cl_credit_serial.freezenominalamount is '冻结名义金额';
comment on column ${iol_schema}.icms_cl_credit_serial.bizlowestfloatrate is '额度下业务利率最低浮动';
comment on column ${iol_schema}.icms_cl_credit_serial.expiredate is '到期日';
comment on column ${iol_schema}.icms_cl_credit_serial.lockflag is '锁定标识Y/N';
comment on column ${iol_schema}.icms_cl_credit_serial.nominalbalance is '授信名义余额';
comment on column ${iol_schema}.icms_cl_credit_serial.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_credit_serial.availablebusinesstype is '适用业务品种';
comment on column ${iol_schema}.icms_cl_credit_serial.businessoccupyexposureamount is '下层的业务占用敞口金额汇总';
comment on column ${iol_schema}.icms_cl_credit_serial.currency is '币种';
comment on column ${iol_schema}.icms_cl_credit_serial.availablenominalamount is '可用名义金额';
comment on column ${iol_schema}.icms_cl_credit_serial.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_credit_serial.leftprenominalamount is '剩余预占名义金额';
comment on column ${iol_schema}.icms_cl_credit_serial.credittype is '额度品种';
comment on column ${iol_schema}.icms_cl_credit_serial.exposurebalance is '授信敞口余额';
comment on column ${iol_schema}.icms_cl_credit_serial.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_credit_serial.businessoccupynominalamount is '下层的业务占用敞口金额汇总';
comment on column ${iol_schema}.icms_cl_credit_serial.occurway is '发生方式';
comment on column ${iol_schema}.icms_cl_credit_serial.exposureamount is '敞口金额';
comment on column ${iol_schema}.icms_cl_credit_serial.slowreleaseexposurecurrency is '可缓释敞口金额币种';
comment on column ${iol_schema}.icms_cl_credit_serial.operateuserid is '经办人';
comment on column ${iol_schema}.icms_cl_credit_serial.lineclass is '额度种类综合/专项/其他)';
comment on column ${iol_schema}.icms_cl_credit_serial.totalpayment is '累计放款';
comment on column ${iol_schema}.icms_cl_credit_serial.createdway is '创建方式:审批/系统';
comment on column ${iol_schema}.icms_cl_credit_serial.assignoccupyuppernominalamount is '指定占用上层授信名义金额';
comment on column ${iol_schema}.icms_cl_credit_serial.suboccupyexposurebalance is '下层授信敞口余额占用汇总';
comment on column ${iol_schema}.icms_cl_credit_serial.sourcesystem is '最初来源系统';
comment on column ${iol_schema}.icms_cl_credit_serial.slowreleaseexposureamount is '可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_credit_serial.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_credit_serial.dedicatedflag is '授信专用标志';
comment on column ${iol_schema}.icms_cl_credit_serial.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_cl_credit_serial.manageorgid is '管理机构';
comment on column ${iol_schema}.icms_cl_credit_serial.freezeexposureamount is '冻结敞口金额';
comment on column ${iol_schema}.icms_cl_credit_serial.maxperiodmonthunderlowercredit is '项下下层授信最长期限月）';
comment on column ${iol_schema}.icms_cl_credit_serial.creditno is '额度系统业务编号';
comment on column ${iol_schema}.icms_cl_credit_serial.latestartdateunderlowercredit is '项下下层授信最迟起始日';
comment on column ${iol_schema}.icms_cl_credit_serial.singlebizmostamount is '明细额度下业务单笔最大金额';
comment on column ${iol_schema}.icms_cl_credit_serial.customerid is '额度系统客户编号';
comment on column ${iol_schema}.icms_cl_credit_serial.canbeextractedundercredit is '额度项下是否可直接提款Y或N';
comment on column ${iol_schema}.icms_cl_credit_serial.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_credit_serial.additioncommand is '其他条件和要求';
comment on column ${iol_schema}.icms_cl_credit_serial.freezestatus is '冻结状态已冻结、未冻结）';
comment on column ${iol_schema}.icms_cl_credit_serial.earlystartdateunderlowercredit is '项下下层授信最早起始日';
comment on column ${iol_schema}.icms_cl_credit_serial.manageuserid is '管理人';
comment on column ${iol_schema}.icms_cl_credit_serial.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_credit_serial.effectivedate is '生效日期';
comment on column ${iol_schema}.icms_cl_credit_serial.lateexpiredateunderlowercredit is '项下下层授信最迟到期日';
comment on column ${iol_schema}.icms_cl_credit_serial.occupyflag is '占用标识';
comment on column ${iol_schema}.icms_cl_credit_serial.bizmostmortgagerate is '额度下业务最高抵质押率';
comment on column ${iol_schema}.icms_cl_credit_serial.execnominalamount is '执行名义金额';
comment on column ${iol_schema}.icms_cl_credit_serial.recyclable is '可循环标志Y/N';
comment on column ${iol_schema}.icms_cl_credit_serial.timelimitday is '期限日';
comment on column ${iol_schema}.icms_cl_credit_serial.reservedcustomerid is '预留客户编号';
comment on column ${iol_schema}.icms_cl_credit_serial.prenominalamount is '预占名义金额';
comment on column ${iol_schema}.icms_cl_credit_serial.explain is '冻结、解冻、终结说明';
comment on column ${iol_schema}.icms_cl_credit_serial.loweroccupyuppernominalamount is '下层占用上层授信名义金额';
comment on column ${iol_schema}.icms_cl_credit_serial.adjustexposureamount is '串用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_serial.timelimitmonth is '期限月';
comment on column ${iol_schema}.icms_cl_credit_serial.currencyrange is '项下业务币种范围';
comment on column ${iol_schema}.icms_cl_credit_serial.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_credit_serial.etl_timestamp is 'ETL处理时间戳';
