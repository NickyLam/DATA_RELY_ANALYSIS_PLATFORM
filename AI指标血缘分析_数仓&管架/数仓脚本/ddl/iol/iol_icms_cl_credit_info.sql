/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_credit_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_credit_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_credit_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_credit_info(
    loweroccupyupperexposureamount number(24,6) -- 下层占用上层授信敞口金额
    ,additioncommand varchar2(1500) -- 其他条件和要求
    ,availablelowriskexposuresum number(24,6) -- 类低风险可用敞口金额
    ,createdway varchar2(64) -- 创建方式:审批/系统
    ,reservedamount number(24,6) -- 预留金额
    ,purpose varchar2(1500) -- 用途
    ,status varchar2(48) -- 状态
    ,adjustnominalamount number(24,6) -- 串用名义金额
    ,explain varchar2(600) -- 冻结、解冻、终结说明
    ,latestusedate timestamp -- 额度最迟使用日期
    ,occurway varchar2(64) -- 发生方式
    ,totalpayment number(24,6) -- 累计放款
    ,operateorgid varchar2(48) -- 经办机构
    ,reservedcustomerid varchar2(2000) -- 预留客户编号
    ,nominalamount number(24,6) -- 名义金额
    ,updateorgid varchar2(48) -- 最后更新机构
    ,riskexposuresum number(24,6) -- 初始一般敞口金额
    ,execexposureamount number(24,6) -- 执行敞口金额
    ,freezestatus varchar2(48) -- 冻结状态已冻结、未冻结）
    ,singlebizmostamount number(24,6) -- 明细额度下业务单笔最大金额
    ,assignoccupyupperexposureamoun number(24,6) -- 指定占用上层授信敞口金额
    ,creditphase varchar2(64) -- 当前授信阶段
    ,suboccupynominalbalance number(24,6) -- 下层授信名义余额占用汇总
    ,operateuserid varchar2(48) -- 经办人
    ,leftprenominalamount number(24,6) -- 剩余预占名义金额
    ,inputorgid varchar2(48) -- 登记机构
    ,availablebusinesstype varchar2(2000) -- 适用业务品种
    ,prenominalamount number(24,6) -- 预占名义金额
    ,bizmostmortgagerate number(15,8) -- 额度下业务最高抵质押率
    ,nominalbalance number(24,6) -- 授信名义余额
    ,dedicatedflag varchar2(48) -- 授信专用标志
    ,availablereservedamount number(24,6) -- 可用预留金额
    ,currencyrange varchar2(120) -- 项下业务币种范围
    ,credittype varchar2(160) -- 额度品种
    ,sourcesystem varchar2(64) -- 最初来源系统
    ,businessoccupynominalamount number(24,6) -- 下层的业务占用名义金额汇总
    ,istrans varchar2(2) -- 是否转授信标志
    ,availableexposureamount number(24,6) -- 可用敞口金额
    ,latestartdateunderlowercredit timestamp -- 项下下层授信最迟起始日
    ,availablenominalamount number(24,6) -- 可用名义金额
    ,slowreleaseexposurecurrency varchar2(3) -- 可缓释敞口金额币种
    ,loweroccupyuppernominalamount number(24,6) -- 下层占用上层授信名义金额
    ,currency varchar2(3) -- 币种
    ,exposureamount number(24,6) -- 敞口金额
    ,occupyflag varchar2(64) -- 占用标识
    ,suboccupyexposurebalance number(24,6) -- 下层授信敞口余额占用汇总
    ,adjustexposureamount number(24,6) -- 串用敞口金额
    ,exposurebalance number(24,6) -- 授信敞口余额
    ,inputuserid varchar2(48) -- 登记人
    ,maxperioddayunderlowercredit number(38,0) -- 项下下层授信最长期限日）
    ,totalrepayment number(24,6) -- 累计还款
    ,lineclass varchar2(48) -- 额度种类综合/专项/其他)
    ,leftpreexposureamount number(24,6) -- 剩余预占敞口金额
    ,freezeexposureamount number(24,6) -- 冻结敞口金额
    ,inputdate timestamp -- 登记日期
    ,ispubliccredit varchar2(6) -- 是否公开授信
    ,availableriskexposuresum number(24,6) -- 一般风险可用敞口金额
    ,execnominalamount number(24,6) -- 执行名义金额
    ,freezenominalamount number(24,6) -- 冻结名义金额
    ,creditno varchar2(64) -- 额度系统业务编号
    ,assignoccupyuppernominalamount number(24,6) -- 指定占用上层授信名义金额
    ,lateexpiredateunderlowercredit timestamp -- 项下下层授信最迟到期日
    ,businessoccupyexposureamount number(24,6) -- 下层的业务占用敞口金额汇总
    ,lowriskexposuresum number(24,6) -- 类低风险敞口金额
    ,timelimitmonth number(38,0) -- 期限月
    ,recyclable varchar2(2) -- 可循环标志Y/N
    ,actualexpiredate timestamp -- 实际终结日
    ,bizbailinitialrate number(16,6) -- 额度下业务初始保证金比例
    ,preexposureamount number(24,6) -- 预占敞口金额
    ,effectivedate timestamp -- 生效日期
    ,lockflag varchar2(48) -- 锁定标识Y/N
    ,timelimitday number(38,0) -- 期限日
    ,onlineamount number(24,6) -- 初始线上额度
    ,sourcecreditno varchar2(64) -- 最初来源额度编号
    ,manageuserid varchar2(48) -- 管理人
    ,updateuserid varchar2(48) -- 最后更新人
    ,customerid varchar2(32) -- 客户编号
    ,manageorgid varchar2(12) -- 管理机构
    ,earlystartdateunderlowercredit timestamp -- 项下下层授信最早起始日
    ,maxperiodmonthunderlowercredit number(38,0) -- 项下下层授信最长期限月）
    ,usableamountcalcflag varchar2(48) -- 可用金额计算标志
    ,guarantyway varchar2(2) -- 担保方式
    ,updatedate timestamp -- 最后更新日期
    ,execslowreleaseexposureamount number(24,6) -- 执行可缓释敞口金额
    ,slowreleaseexposureamount number(24,6) -- 可缓释敞口金额
    ,canbeextractedundercredit varchar2(2) -- 额度项下是否可直接提款Y或N
    ,expiredate timestamp -- 到期日
    ,remark varchar2(600) -- 备注
    ,bizlowestfloatrate number(16,6) -- 额度下业务利率最低浮动
    ,pledgesum number(24,6) -- 抵质押物金额
    ,isexempt varchar2(2) -- 是否豁免
    ,onlinebusinessamount number(24,6) -- 
    ,onlinebusinessbalance number(24,6) -- 
    ,lowoccupynominalamountonline number(24,6) -- 
    ,lowoccupyexposureamountonline number(24,6) -- 
    ,isjoinlimits varchar2(2) -- 
    ,otherlimitamount number(24,6) -- 
    ,icmsapproveamout number(24,6) -- 
    ,bapserialno varchar2(64) -- 
    ,occupycreditno varchar2(64) -- 
    ,riskapproveamout number(24,6) -- 
    ,iscollectionagency varchar2(2) -- 
    ,nbgkamount number(24,6) -- 
    ,nbgkoccupyamount number(24,6) -- 
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
grant select on ${iol_schema}.icms_cl_credit_info to ${iml_schema};
grant select on ${iol_schema}.icms_cl_credit_info to ${icl_schema};
grant select on ${iol_schema}.icms_cl_credit_info to ${idl_schema};
grant select on ${iol_schema}.icms_cl_credit_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_credit_info is '授信额度信息';
comment on column ${iol_schema}.icms_cl_credit_info.loweroccupyupperexposureamount is '下层占用上层授信敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.additioncommand is '其他条件和要求';
comment on column ${iol_schema}.icms_cl_credit_info.availablelowriskexposuresum is '类低风险可用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.createdway is '创建方式:审批/系统';
comment on column ${iol_schema}.icms_cl_credit_info.reservedamount is '预留金额';
comment on column ${iol_schema}.icms_cl_credit_info.purpose is '用途';
comment on column ${iol_schema}.icms_cl_credit_info.status is '状态';
comment on column ${iol_schema}.icms_cl_credit_info.adjustnominalamount is '串用名义金额';
comment on column ${iol_schema}.icms_cl_credit_info.explain is '冻结、解冻、终结说明';
comment on column ${iol_schema}.icms_cl_credit_info.latestusedate is '额度最迟使用日期';
comment on column ${iol_schema}.icms_cl_credit_info.occurway is '发生方式';
comment on column ${iol_schema}.icms_cl_credit_info.totalpayment is '累计放款';
comment on column ${iol_schema}.icms_cl_credit_info.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_cl_credit_info.reservedcustomerid is '预留客户编号';
comment on column ${iol_schema}.icms_cl_credit_info.nominalamount is '名义金额';
comment on column ${iol_schema}.icms_cl_credit_info.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_credit_info.riskexposuresum is '初始一般敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.execexposureamount is '执行敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.freezestatus is '冻结状态已冻结、未冻结）';
comment on column ${iol_schema}.icms_cl_credit_info.singlebizmostamount is '明细额度下业务单笔最大金额';
comment on column ${iol_schema}.icms_cl_credit_info.assignoccupyupperexposureamoun is '指定占用上层授信敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.creditphase is '当前授信阶段';
comment on column ${iol_schema}.icms_cl_credit_info.suboccupynominalbalance is '下层授信名义余额占用汇总';
comment on column ${iol_schema}.icms_cl_credit_info.operateuserid is '经办人';
comment on column ${iol_schema}.icms_cl_credit_info.leftprenominalamount is '剩余预占名义金额';
comment on column ${iol_schema}.icms_cl_credit_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_credit_info.availablebusinesstype is '适用业务品种';
comment on column ${iol_schema}.icms_cl_credit_info.prenominalamount is '预占名义金额';
comment on column ${iol_schema}.icms_cl_credit_info.bizmostmortgagerate is '额度下业务最高抵质押率';
comment on column ${iol_schema}.icms_cl_credit_info.nominalbalance is '授信名义余额';
comment on column ${iol_schema}.icms_cl_credit_info.dedicatedflag is '授信专用标志';
comment on column ${iol_schema}.icms_cl_credit_info.availablereservedamount is '可用预留金额';
comment on column ${iol_schema}.icms_cl_credit_info.currencyrange is '项下业务币种范围';
comment on column ${iol_schema}.icms_cl_credit_info.credittype is '额度品种';
comment on column ${iol_schema}.icms_cl_credit_info.sourcesystem is '最初来源系统';
comment on column ${iol_schema}.icms_cl_credit_info.businessoccupynominalamount is '下层的业务占用名义金额汇总';
comment on column ${iol_schema}.icms_cl_credit_info.istrans is '是否转授信标志';
comment on column ${iol_schema}.icms_cl_credit_info.availableexposureamount is '可用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.latestartdateunderlowercredit is '项下下层授信最迟起始日';
comment on column ${iol_schema}.icms_cl_credit_info.availablenominalamount is '可用名义金额';
comment on column ${iol_schema}.icms_cl_credit_info.slowreleaseexposurecurrency is '可缓释敞口金额币种';
comment on column ${iol_schema}.icms_cl_credit_info.loweroccupyuppernominalamount is '下层占用上层授信名义金额';
comment on column ${iol_schema}.icms_cl_credit_info.currency is '币种';
comment on column ${iol_schema}.icms_cl_credit_info.exposureamount is '敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.occupyflag is '占用标识';
comment on column ${iol_schema}.icms_cl_credit_info.suboccupyexposurebalance is '下层授信敞口余额占用汇总';
comment on column ${iol_schema}.icms_cl_credit_info.adjustexposureamount is '串用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.exposurebalance is '授信敞口余额';
comment on column ${iol_schema}.icms_cl_credit_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_credit_info.maxperioddayunderlowercredit is '项下下层授信最长期限日）';
comment on column ${iol_schema}.icms_cl_credit_info.totalrepayment is '累计还款';
comment on column ${iol_schema}.icms_cl_credit_info.lineclass is '额度种类综合/专项/其他)';
comment on column ${iol_schema}.icms_cl_credit_info.leftpreexposureamount is '剩余预占敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.freezeexposureamount is '冻结敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_credit_info.ispubliccredit is '是否公开授信';
comment on column ${iol_schema}.icms_cl_credit_info.availableriskexposuresum is '一般风险可用敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.execnominalamount is '执行名义金额';
comment on column ${iol_schema}.icms_cl_credit_info.freezenominalamount is '冻结名义金额';
comment on column ${iol_schema}.icms_cl_credit_info.creditno is '额度系统业务编号';
comment on column ${iol_schema}.icms_cl_credit_info.assignoccupyuppernominalamount is '指定占用上层授信名义金额';
comment on column ${iol_schema}.icms_cl_credit_info.lateexpiredateunderlowercredit is '项下下层授信最迟到期日';
comment on column ${iol_schema}.icms_cl_credit_info.businessoccupyexposureamount is '下层的业务占用敞口金额汇总';
comment on column ${iol_schema}.icms_cl_credit_info.lowriskexposuresum is '类低风险敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.timelimitmonth is '期限月';
comment on column ${iol_schema}.icms_cl_credit_info.recyclable is '可循环标志Y/N';
comment on column ${iol_schema}.icms_cl_credit_info.actualexpiredate is '实际终结日';
comment on column ${iol_schema}.icms_cl_credit_info.bizbailinitialrate is '额度下业务初始保证金比例';
comment on column ${iol_schema}.icms_cl_credit_info.preexposureamount is '预占敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.effectivedate is '生效日期';
comment on column ${iol_schema}.icms_cl_credit_info.lockflag is '锁定标识Y/N';
comment on column ${iol_schema}.icms_cl_credit_info.timelimitday is '期限日';
comment on column ${iol_schema}.icms_cl_credit_info.onlineamount is '初始线上额度';
comment on column ${iol_schema}.icms_cl_credit_info.sourcecreditno is '最初来源额度编号';
comment on column ${iol_schema}.icms_cl_credit_info.manageuserid is '管理人';
comment on column ${iol_schema}.icms_cl_credit_info.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_credit_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_cl_credit_info.manageorgid is '管理机构';
comment on column ${iol_schema}.icms_cl_credit_info.earlystartdateunderlowercredit is '项下下层授信最早起始日';
comment on column ${iol_schema}.icms_cl_credit_info.maxperiodmonthunderlowercredit is '项下下层授信最长期限月）';
comment on column ${iol_schema}.icms_cl_credit_info.usableamountcalcflag is '可用金额计算标志';
comment on column ${iol_schema}.icms_cl_credit_info.guarantyway is '担保方式';
comment on column ${iol_schema}.icms_cl_credit_info.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_credit_info.execslowreleaseexposureamount is '执行可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.slowreleaseexposureamount is '可缓释敞口金额';
comment on column ${iol_schema}.icms_cl_credit_info.canbeextractedundercredit is '额度项下是否可直接提款Y或N';
comment on column ${iol_schema}.icms_cl_credit_info.expiredate is '到期日';
comment on column ${iol_schema}.icms_cl_credit_info.remark is '备注';
comment on column ${iol_schema}.icms_cl_credit_info.bizlowestfloatrate is '额度下业务利率最低浮动';
comment on column ${iol_schema}.icms_cl_credit_info.pledgesum is '抵质押物金额';
comment on column ${iol_schema}.icms_cl_credit_info.isexempt is '是否豁免';
comment on column ${iol_schema}.icms_cl_credit_info.onlinebusinessamount is '';
comment on column ${iol_schema}.icms_cl_credit_info.onlinebusinessbalance is '';
comment on column ${iol_schema}.icms_cl_credit_info.lowoccupynominalamountonline is '';
comment on column ${iol_schema}.icms_cl_credit_info.lowoccupyexposureamountonline is '';
comment on column ${iol_schema}.icms_cl_credit_info.isjoinlimits is '';
comment on column ${iol_schema}.icms_cl_credit_info.otherlimitamount is '';
comment on column ${iol_schema}.icms_cl_credit_info.icmsapproveamout is '';
comment on column ${iol_schema}.icms_cl_credit_info.bapserialno is '';
comment on column ${iol_schema}.icms_cl_credit_info.occupycreditno is '';
comment on column ${iol_schema}.icms_cl_credit_info.riskapproveamout is '';
comment on column ${iol_schema}.icms_cl_credit_info.iscollectionagency is '';
comment on column ${iol_schema}.icms_cl_credit_info.nbgkamount is '';
comment on column ${iol_schema}.icms_cl_credit_info.nbgkoccupyamount is '';
comment on column ${iol_schema}.icms_cl_credit_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_cl_credit_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_cl_credit_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_cl_credit_info.etl_timestamp is 'ETL处理时间戳';
