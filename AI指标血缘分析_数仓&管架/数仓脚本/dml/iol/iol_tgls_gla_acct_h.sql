/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gla_acct_h
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
drop table ${iol_schema}.tgls_gla_acct_h_ex purge;
alter table ${iol_schema}.tgls_gla_acct_h add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_gla_acct_h truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_gla_acct_h_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gla_acct_h where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_gla_acct_h_ex(
    acctdt -- 账户日期
    ,acctcd -- 账户表唯一标识
    ,acctna -- 名称
    ,systid -- 系统识别号(01-总账02-核心03-财务)
    ,brchno -- 核算机构
    ,crcycd -- 币种
    ,itemcd -- 核算科目
    ,acctcl -- 账户类别(1手工账户2基准账户3专用账户)
    ,subscd -- 子目号
    ,openbr -- 开户机构
    ,opendt -- 开户日期
    ,optrsq -- 开户流水号
    ,lstrdt -- 最后交易日期
    ,lstrsq -- 最后交易流水
    ,closdt -- 销户日期
    ,cltrsq -- 销户流水号
    ,ioflag -- 表内外标志（i表内o表外）
    ,blncdn -- 联机余额方向(d:借方c:贷方p:付方r:收方)
    ,onlnbl -- 联机余额
    ,lastdn -- 上日余额方向(d:借方c:贷方p:付方r:收方)
    ,lastbl -- 上日余额
    ,lastdt -- 上日余额日期
    ,acmlbl -- 积数
    ,acmldt -- 积数日期
    ,acctst -- 账户状态(0-关闭1-正常)
    ,drhdbk -- 借方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
    ,crhdbk -- 贷方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
    ,openus -- 开户柜员
    ,closus -- 销户柜员
    ,pmodtg -- 透支标识（0：不允许，1：允许）
    ,stacid -- 账套标识
    ,centcd -- 责任中心
    ,prsncd -- 职员
    ,custcd -- 客户
    ,prducd -- 产品编号
    ,prlncd -- 产品线
    ,acctno -- 账户-多维
    ,assis0 -- 辅助核算0（自定义）
    ,assis1 -- 辅助核算1（自定义）
    ,assis2 -- 辅助核算2（自定义）
    ,assis3 -- 辅助核算3（自定义）
    ,assis4 -- 辅助核算4（自定义）
    ,assis5 -- 辅助核算5（自定义）
    ,assis6 -- 辅助核算6（自定义）
    ,assis7 -- 辅助核算7（自定义）
    ,assis8 -- 辅助核算8（自定义）
    ,assis9 -- 辅助核算9（自定义）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acctdt -- 账户日期
    ,acctcd -- 账户表唯一标识
    ,acctna -- 名称
    ,systid -- 系统识别号(01-总账02-核心03-财务)
    ,brchno -- 核算机构
    ,crcycd -- 币种
    ,itemcd -- 核算科目
    ,acctcl -- 账户类别(1手工账户2基准账户3专用账户)
    ,subscd -- 子目号
    ,openbr -- 开户机构
    ,opendt -- 开户日期
    ,optrsq -- 开户流水号
    ,lstrdt -- 最后交易日期
    ,lstrsq -- 最后交易流水
    ,closdt -- 销户日期
    ,cltrsq -- 销户流水号
    ,ioflag -- 表内外标志（i表内o表外）
    ,blncdn -- 联机余额方向(d:借方c:贷方p:付方r:收方)
    ,onlnbl -- 联机余额
    ,lastdn -- 上日余额方向(d:借方c:贷方p:付方r:收方)
    ,lastbl -- 上日余额
    ,lastdt -- 上日余额日期
    ,acmlbl -- 积数
    ,acmldt -- 积数日期
    ,acctst -- 账户状态(0-关闭1-正常)
    ,drhdbk -- 借方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
    ,crhdbk -- 贷方手工记账许可(0-不允许1-允许自身2-自身及上级允许3-自身及下级允许4-分行内允许5-法人内允许)
    ,openus -- 开户柜员
    ,closus -- 销户柜员
    ,pmodtg -- 透支标识（0：不允许，1：允许）
    ,stacid -- 账套标识
    ,centcd -- 责任中心
    ,prsncd -- 职员
    ,custcd -- 客户
    ,prducd -- 产品编号
    ,prlncd -- 产品线
    ,acctno -- 账户-多维
    ,assis0 -- 辅助核算0（自定义）
    ,assis1 -- 辅助核算1（自定义）
    ,assis2 -- 辅助核算2（自定义）
    ,assis3 -- 辅助核算3（自定义）
    ,assis4 -- 辅助核算4（自定义）
    ,assis5 -- 辅助核算5（自定义）
    ,assis6 -- 辅助核算6（自定义）
    ,assis7 -- 辅助核算7（自定义）
    ,assis8 -- 辅助核算8（自定义）
    ,assis9 -- 辅助核算9（自定义）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_gla_acct_h
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_gla_acct_h exchange partition p_${batch_date} with table ${iol_schema}.tgls_gla_acct_h_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gla_acct_h to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_gla_acct_h_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gla_acct_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);