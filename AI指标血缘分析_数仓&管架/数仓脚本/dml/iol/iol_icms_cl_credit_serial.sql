/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_credit_serial
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_cl_credit_serial_ex purge;
alter table ${iol_schema}.icms_cl_credit_serial add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_cl_credit_serial truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_cl_credit_serial_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_credit_serial where 0=1;

insert /*+ append */ into ${iol_schema}.icms_cl_credit_serial_ex(
    reservedamount -- 预留金额
    ,creditphase -- 当前授信阶段
    ,execslowreleaseexposureamount -- 执行可缓释敞口金额
    ,loweroccupyupperexposureamount -- 下层占用上层授信敞口金额
    ,bizbailinitialrate -- 额度下业务初始保证金比例
    ,preexposureamount -- 预占敞口金额
    ,availablereservedamount -- 可用预留金额
    ,actualexpiredate -- 实际终结日
    ,latestusedate -- 额度最迟使用日期
    ,purpose -- 用途
    ,nominalamount -- 名义金额
    ,maxperioddayunderlowercredit -- 项下下层授信最长期限日）
    ,serialno -- 流水号
    ,sourcecreditno -- 最初来源额度编号
    ,status -- 状态
    ,suboccupynominalbalance -- 下层授信名义余额占用汇总
    ,guarantyway -- 担保方式
    ,totalrepayment -- 累计还款
    ,availableexposureamount -- 可用敞口金额
    ,usableamountcalcflag -- 可用金额计算标志
    ,leftpreexposureamount -- 剩余预占敞口金额
    ,execexposureamount -- 执行敞口金额
    ,remark -- 备注
    ,assignoccupyupperexposureamoun -- 指定占用上层授信敞口金额
    ,ispubliccredit -- 是否公开授信
    ,adjustnominalamount -- 串用名义金额
    ,freezenominalamount -- 冻结名义金额
    ,bizlowestfloatrate -- 额度下业务利率最低浮动
    ,expiredate -- 到期日
    ,lockflag -- 锁定标识Y/N
    ,nominalbalance -- 授信名义余额
    ,inputorgid -- 登记机构
    ,availablebusinesstype -- 适用业务品种
    ,businessoccupyexposureamount -- 下层的业务占用敞口金额汇总
    ,currency -- 币种
    ,availablenominalamount -- 可用名义金额
    ,updateorgid -- 最后更新机构
    ,leftprenominalamount -- 剩余预占名义金额
    ,credittype -- 额度品种
    ,exposurebalance -- 授信敞口余额
    ,updateuserid -- 最后更新人
    ,businessoccupynominalamount -- 下层的业务占用敞口金额汇总
    ,occurway -- 发生方式
    ,exposureamount -- 敞口金额
    ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
    ,operateuserid -- 经办人
    ,lineclass -- 额度种类综合/专项/其他)
    ,totalpayment -- 累计放款
    ,createdway -- 创建方式:审批/系统
    ,assignoccupyuppernominalamount -- 指定占用上层授信名义金额
    ,suboccupyexposurebalance -- 下层授信敞口余额占用汇总
    ,sourcesystem -- 最初来源系统
    ,slowreleaseexposureamount -- 可缓释敞口金额
    ,inputdate -- 登记日期
    ,dedicatedflag -- 授信专用标志
    ,operateorgid -- 经办机构
    ,manageorgid -- 管理机构
    ,freezeexposureamount -- 冻结敞口金额
    ,maxperiodmonthunderlowercredit -- 项下下层授信最长期限月）
    ,creditno -- 额度系统业务编号
    ,latestartdateunderlowercredit -- 项下下层授信最迟起始日
    ,singlebizmostamount -- 明细额度下业务单笔最大金额
    ,customerid -- 额度系统客户编号
    ,canbeextractedundercredit -- 额度项下是否可直接提款Y或N
    ,updatedate -- 最后更新日期
    ,additioncommand -- 其他条件和要求
    ,freezestatus -- 冻结状态已冻结、未冻结）
    ,earlystartdateunderlowercredit -- 项下下层授信最早起始日
    ,manageuserid -- 管理人
    ,inputuserid -- 登记人
    ,effectivedate -- 生效日期
    ,lateexpiredateunderlowercredit -- 项下下层授信最迟到期日
    ,occupyflag -- 占用标识
    ,bizmostmortgagerate -- 额度下业务最高抵质押率
    ,execnominalamount -- 执行名义金额
    ,recyclable -- 可循环标志Y/N
    ,timelimitday -- 期限日
    ,reservedcustomerid -- 预留客户编号
    ,prenominalamount -- 预占名义金额
    ,explain -- 冻结、解冻、终结说明
    ,loweroccupyuppernominalamount -- 下层占用上层授信名义金额
    ,adjustexposureamount -- 串用敞口金额
    ,timelimitmonth -- 期限月
    ,currencyrange -- 项下业务币种范围
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    reservedamount -- 预留金额
    ,creditphase -- 当前授信阶段
    ,execslowreleaseexposureamount -- 执行可缓释敞口金额
    ,loweroccupyupperexposureamount -- 下层占用上层授信敞口金额
    ,bizbailinitialrate -- 额度下业务初始保证金比例
    ,preexposureamount -- 预占敞口金额
    ,availablereservedamount -- 可用预留金额
    ,actualexpiredate -- 实际终结日
    ,latestusedate -- 额度最迟使用日期
    ,purpose -- 用途
    ,nominalamount -- 名义金额
    ,maxperioddayunderlowercredit -- 项下下层授信最长期限日）
    ,serialno -- 流水号
    ,sourcecreditno -- 最初来源额度编号
    ,status -- 状态
    ,suboccupynominalbalance -- 下层授信名义余额占用汇总
    ,guarantyway -- 担保方式
    ,totalrepayment -- 累计还款
    ,availableexposureamount -- 可用敞口金额
    ,usableamountcalcflag -- 可用金额计算标志
    ,leftpreexposureamount -- 剩余预占敞口金额
    ,execexposureamount -- 执行敞口金额
    ,remark -- 备注
    ,assignoccupyupperexposureamoun -- 指定占用上层授信敞口金额
    ,ispubliccredit -- 是否公开授信
    ,adjustnominalamount -- 串用名义金额
    ,freezenominalamount -- 冻结名义金额
    ,bizlowestfloatrate -- 额度下业务利率最低浮动
    ,expiredate -- 到期日
    ,lockflag -- 锁定标识Y/N
    ,nominalbalance -- 授信名义余额
    ,inputorgid -- 登记机构
    ,availablebusinesstype -- 适用业务品种
    ,businessoccupyexposureamount -- 下层的业务占用敞口金额汇总
    ,currency -- 币种
    ,availablenominalamount -- 可用名义金额
    ,updateorgid -- 最后更新机构
    ,leftprenominalamount -- 剩余预占名义金额
    ,credittype -- 额度品种
    ,exposurebalance -- 授信敞口余额
    ,updateuserid -- 最后更新人
    ,businessoccupynominalamount -- 下层的业务占用敞口金额汇总
    ,occurway -- 发生方式
    ,exposureamount -- 敞口金额
    ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
    ,operateuserid -- 经办人
    ,lineclass -- 额度种类综合/专项/其他)
    ,totalpayment -- 累计放款
    ,createdway -- 创建方式:审批/系统
    ,assignoccupyuppernominalamount -- 指定占用上层授信名义金额
    ,suboccupyexposurebalance -- 下层授信敞口余额占用汇总
    ,sourcesystem -- 最初来源系统
    ,slowreleaseexposureamount -- 可缓释敞口金额
    ,inputdate -- 登记日期
    ,dedicatedflag -- 授信专用标志
    ,operateorgid -- 经办机构
    ,manageorgid -- 管理机构
    ,freezeexposureamount -- 冻结敞口金额
    ,maxperiodmonthunderlowercredit -- 项下下层授信最长期限月）
    ,creditno -- 额度系统业务编号
    ,latestartdateunderlowercredit -- 项下下层授信最迟起始日
    ,singlebizmostamount -- 明细额度下业务单笔最大金额
    ,customerid -- 额度系统客户编号
    ,canbeextractedundercredit -- 额度项下是否可直接提款Y或N
    ,updatedate -- 最后更新日期
    ,additioncommand -- 其他条件和要求
    ,freezestatus -- 冻结状态已冻结、未冻结）
    ,earlystartdateunderlowercredit -- 项下下层授信最早起始日
    ,manageuserid -- 管理人
    ,inputuserid -- 登记人
    ,effectivedate -- 生效日期
    ,lateexpiredateunderlowercredit -- 项下下层授信最迟到期日
    ,occupyflag -- 占用标识
    ,bizmostmortgagerate -- 额度下业务最高抵质押率
    ,execnominalamount -- 执行名义金额
    ,recyclable -- 可循环标志Y/N
    ,timelimitday -- 期限日
    ,reservedcustomerid -- 预留客户编号
    ,prenominalamount -- 预占名义金额
    ,explain -- 冻结、解冻、终结说明
    ,loweroccupyuppernominalamount -- 下层占用上层授信名义金额
    ,adjustexposureamount -- 串用敞口金额
    ,timelimitmonth -- 期限月
    ,currencyrange -- 项下业务币种范围
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_cl_credit_serial
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_cl_credit_serial exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_credit_serial_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_credit_serial to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_cl_credit_serial_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_credit_serial',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);