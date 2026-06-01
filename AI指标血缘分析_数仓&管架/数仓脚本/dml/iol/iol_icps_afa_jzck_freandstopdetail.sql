/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icps_afa_jzck_freandstopdetail
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
drop table ${iol_schema}.icps_afa_jzck_freandstopdetail_ex purge;
alter table ${iol_schema}.icps_afa_jzck_freandstopdetail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icps_afa_jzck_freandstopdetail;

-- 2.3 insert data to ex table
create table ${iol_schema}.icps_afa_jzck_freandstopdetail_ex nologging
compress
as
select * from ${iol_schema}.icps_afa_jzck_freandstopdetail where 0=1;

insert /*+ append */ into ${iol_schema}.icps_afa_jzck_freandstopdetail_ex(
    productcode -- 产品代号详见产品代码数据字典
    ,workdate -- 平台日期
    ,agentserialno -- 平台流水号
    ,worktime -- 平台时间
    ,transserialnumber -- 传输报文流水号
    ,applicationid -- 业务申请编号
    ,opttype -- 措施类型
    ,cardnumber -- 账号
    ,accountnumber -- 子账号
    ,accountserial -- 子账号序号
    ,starttime -- 开始时间
    ,endtime -- 截止时间
    ,currency -- 币种
    ,cashremit -- 钞汇标志
    ,formerapplicationdepartment -- 在先冻结机关
    ,formerfrozenbalance -- 在先冻结金额
    ,formerfrozenexpiretime -- 在先冻结到期日
    ,frozedbalance -- 执行冻结金额
    ,accountbalance -- 账户余额
    ,accountavaiablebalance -- 账户可用余额
    ,hostfreezeserial -- 冻结核心流水号核心冻结成功后反馈
    ,hostdate -- 冻结核心日期核心冻结成功后反馈
    ,unfrozedbalance -- 未冻结金额
    ,freezetype -- 冻结措施 类型0001-公安止付;0002-公安冻结;1001-高法止付;1002-高法冻结；2001-监委止付；2002-监委冻结；
    ,tradestatus -- 执行结果  0-冻结/止付成功 1-冻结/止付失败 2-解冻/解止付成功
    ,dealmsg -- 执行结果原因
    ,remark1 -- 备用字段1
    ,remark2 -- 备用字段2
    ,restraint_seq_no -- 冻结编号
    ,globalseqno -- 全局流水
    ,upddate -- 更新日期
    ,updtime -- 更新时间
    ,brno -- 执行机构
    ,tellerno -- 执行柜员
    ,frozedtype -- 冻结方式 1-部分冻结(金额冻结)；2-无限额冻结(账户冻结)；
    ,unfrozedtype -- 系统解冻类型 1-普通日终解冻；2-对日对时解冻；
    ,iswait -- 是否轮候冻结 0-否；1-是；
    ,remark -- 执行原因
    ,isfrozed -- 是否已解冻 0-否；1-是；
    ,frozedamount -- 剩余冻结金额
    ,acctstatus -- 账户状态 0-未冻结 1-已账户冻结 2-已子户冻结
    ,frozeno -- 冻结序号
    ,hosttype -- 核心类型 1-传统核心 2-电子账户 3-微众联合
    ,pre_freeze_amount -- 申请冻结金额
    ,init_froz_flow -- 原冻结流水号
    ,init_froz_dt -- 原冻结日期
    ,init_freeze_due_date -- 原冻结到期日
    ,init_freeze_amount -- 原冻结金额
    ,deduct_doc_type -- 划扣通知书类型
    ,deduct_doc_code -- 划扣通知书编号
    ,inner_account_no -- 内部账号
    ,account_name -- 账号名称
    ,authorizer -- 授权柜员
    ,exec_org_cd -- 执行机关
    ,executor -- 执行人员
    ,certificate_type_one -- 执行人证件1
    ,certificate_no_one -- 执行人号码1
    ,certificate_type_two -- 执行人证件2
    ,certificate_no_two -- 执行人号码2
    ,customer_no -- 客户号
    ,law_enforce_type -- 执法部门类型
    ,law_enforce_name -- 执法部门名称
    ,prove_type_id -- 证明类别
    ,prove_no -- 证明书号
    ,remit_way -- 解除方式
    ,formerfrozendate -- 在先冻结日期
    ,formerfrozenserno -- 在先冻结流水
    ,dealstatus -- 处理状态 0-未处理； 1-处理中
    ,busiserno -- 业务流水号
    ,acct_lvl -- 产品代号
    ,busidate -- 平台日期
    ,restraint_date -- 平台流水号
    ,dealdate -- 处理日期
    ,dealtime -- 处理时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    productcode -- 产品代号详见产品代码数据字典
    ,workdate -- 平台日期
    ,agentserialno -- 平台流水号
    ,worktime -- 平台时间
    ,transserialnumber -- 传输报文流水号
    ,applicationid -- 业务申请编号
    ,opttype -- 措施类型
    ,cardnumber -- 账号
    ,accountnumber -- 子账号
    ,accountserial -- 子账号序号
    ,starttime -- 开始时间
    ,endtime -- 截止时间
    ,currency -- 币种
    ,cashremit -- 钞汇标志
    ,formerapplicationdepartment -- 在先冻结机关
    ,formerfrozenbalance -- 在先冻结金额
    ,formerfrozenexpiretime -- 在先冻结到期日
    ,frozedbalance -- 执行冻结金额
    ,accountbalance -- 账户余额
    ,accountavaiablebalance -- 账户可用余额
    ,hostfreezeserial -- 冻结核心流水号核心冻结成功后反馈
    ,hostdate -- 冻结核心日期核心冻结成功后反馈
    ,unfrozedbalance -- 未冻结金额
    ,freezetype -- 冻结措施 类型0001-公安止付;0002-公安冻结;1001-高法止付;1002-高法冻结；2001-监委止付；2002-监委冻结；
    ,tradestatus -- 执行结果  0-冻结/止付成功 1-冻结/止付失败 2-解冻/解止付成功
    ,dealmsg -- 执行结果原因
    ,remark1 -- 备用字段1
    ,remark2 -- 备用字段2
    ,restraint_seq_no -- 冻结编号
    ,globalseqno -- 全局流水
    ,upddate -- 更新日期
    ,updtime -- 更新时间
    ,brno -- 执行机构
    ,tellerno -- 执行柜员
    ,frozedtype -- 冻结方式 1-部分冻结(金额冻结)；2-无限额冻结(账户冻结)；
    ,unfrozedtype -- 系统解冻类型 1-普通日终解冻；2-对日对时解冻；
    ,iswait -- 是否轮候冻结 0-否；1-是；
    ,remark -- 执行原因
    ,isfrozed -- 是否已解冻 0-否；1-是；
    ,frozedamount -- 剩余冻结金额
    ,acctstatus -- 账户状态 0-未冻结 1-已账户冻结 2-已子户冻结
    ,frozeno -- 冻结序号
    ,hosttype -- 核心类型 1-传统核心 2-电子账户 3-微众联合
    ,pre_freeze_amount -- 申请冻结金额
    ,init_froz_flow -- 原冻结流水号
    ,init_froz_dt -- 原冻结日期
    ,init_freeze_due_date -- 原冻结到期日
    ,init_freeze_amount -- 原冻结金额
    ,deduct_doc_type -- 划扣通知书类型
    ,deduct_doc_code -- 划扣通知书编号
    ,inner_account_no -- 内部账号
    ,account_name -- 账号名称
    ,authorizer -- 授权柜员
    ,exec_org_cd -- 执行机关
    ,executor -- 执行人员
    ,certificate_type_one -- 执行人证件1
    ,certificate_no_one -- 执行人号码1
    ,certificate_type_two -- 执行人证件2
    ,certificate_no_two -- 执行人号码2
    ,customer_no -- 客户号
    ,law_enforce_type -- 执法部门类型
    ,law_enforce_name -- 执法部门名称
    ,prove_type_id -- 证明类别
    ,prove_no -- 证明书号
    ,remit_way -- 解除方式
    ,formerfrozendate -- 在先冻结日期
    ,formerfrozenserno -- 在先冻结流水
    ,dealstatus -- 处理状态 0-未处理； 1-处理中
    ,busiserno -- 业务流水号
    ,acct_lvl -- 产品代号
    ,busidate -- 平台日期
    ,restraint_date -- 平台流水号
    ,dealdate -- 处理日期
    ,dealtime -- 处理时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icps_afa_jzck_freandstopdetail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icps_afa_jzck_freandstopdetail exchange partition p_${batch_date} with table ${iol_schema}.icps_afa_jzck_freandstopdetail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icps_afa_jzck_freandstopdetail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icps_afa_jzck_freandstopdetail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icps_afa_jzck_freandstopdetail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);