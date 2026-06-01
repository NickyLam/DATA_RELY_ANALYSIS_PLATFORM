/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_cl_business_serial
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
drop table ${iol_schema}.icms_cl_business_serial_ex purge;
alter table ${iol_schema}.icms_cl_business_serial add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_cl_business_serial truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_cl_business_serial_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_cl_business_serial where 0=1;

insert /*+ append */ into ${iol_schema}.icms_cl_business_serial_ex(
    occurway -- 发生方式
    ,slowreleaseexposureamount -- 可缓释敞口金额
    ,pledgerate -- 抵质押率
    ,timelimitmonth -- 期限月
    ,manageorgid -- 管理机构
    ,exposureamount -- 敞口金额
    ,status -- 状态
    ,availablenominalamount -- 可用名义金额
    ,availableexposureamount -- 可用敞口金额
    ,expiredate -- 到期日
    ,operateuserid -- 经办人
    ,totalpayment -- 累计放款
    ,execnominalamount -- 执行名义金额
    ,occupyflag -- 占用标识
    ,actualexpiredate -- 实际终结日
    ,manageuserid -- 管理人
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,updateuserid -- 最后更新人
    ,updateorgid -- 最后更新机构
    ,execexposureamount -- 执行敞口金额
    ,effectivedate -- 生效日期
    ,businessno -- 额度系统业务编号
    ,sourcebusinessno -- 最初来源业务编号
    ,nominalamount -- 名义金额
    ,guarantyway -- 担保方式
    ,operateorgid -- 经办机构
    ,businesstype -- 业务品种
    ,creditphase -- 当前授信阶段
    ,nominalbalance -- 授信名义余额
    ,timelimitday -- 期限日
    ,sourcesystem -- 最初来源系统
    ,currency -- 币种
    ,recyclable -- 可循环标志Y/N
    ,inputdate -- 登记日期
    ,exposurebalance -- 授信敞口余额
    ,execslowreleaseexposureamount -- 执行可缓释敞口金额
    ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
    ,securitydeposit -- 保证金
    ,totalrepayment -- 累计还款
    ,remark -- 备注
    ,serialno -- 流水号
    ,createdway -- 创建方式:审批/系统
    ,customerid -- 额度系统客户编号
    ,amountfactor -- 金额折算系数
    ,updatedate -- 最后更新日期
    ,floatingrate -- 浮动利率
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    occurway -- 发生方式
    ,slowreleaseexposureamount -- 可缓释敞口金额
    ,pledgerate -- 抵质押率
    ,timelimitmonth -- 期限月
    ,manageorgid -- 管理机构
    ,exposureamount -- 敞口金额
    ,status -- 状态
    ,availablenominalamount -- 可用名义金额
    ,availableexposureamount -- 可用敞口金额
    ,expiredate -- 到期日
    ,operateuserid -- 经办人
    ,totalpayment -- 累计放款
    ,execnominalamount -- 执行名义金额
    ,occupyflag -- 占用标识
    ,actualexpiredate -- 实际终结日
    ,manageuserid -- 管理人
    ,inputuserid -- 登记人
    ,inputorgid -- 登记机构
    ,updateuserid -- 最后更新人
    ,updateorgid -- 最后更新机构
    ,execexposureamount -- 执行敞口金额
    ,effectivedate -- 生效日期
    ,businessno -- 额度系统业务编号
    ,sourcebusinessno -- 最初来源业务编号
    ,nominalamount -- 名义金额
    ,guarantyway -- 担保方式
    ,operateorgid -- 经办机构
    ,businesstype -- 业务品种
    ,creditphase -- 当前授信阶段
    ,nominalbalance -- 授信名义余额
    ,timelimitday -- 期限日
    ,sourcesystem -- 最初来源系统
    ,currency -- 币种
    ,recyclable -- 可循环标志Y/N
    ,inputdate -- 登记日期
    ,exposurebalance -- 授信敞口余额
    ,execslowreleaseexposureamount -- 执行可缓释敞口金额
    ,slowreleaseexposurecurrency -- 可缓释敞口金额币种
    ,securitydeposit -- 保证金
    ,totalrepayment -- 累计还款
    ,remark -- 备注
    ,serialno -- 流水号
    ,createdway -- 创建方式:审批/系统
    ,customerid -- 额度系统客户编号
    ,amountfactor -- 金额折算系数
    ,updatedate -- 最后更新日期
    ,floatingrate -- 浮动利率
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_cl_business_serial
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_cl_business_serial exchange partition p_${batch_date} with table ${iol_schema}.icms_cl_business_serial_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_cl_business_serial to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_cl_business_serial_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_cl_business_serial',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);