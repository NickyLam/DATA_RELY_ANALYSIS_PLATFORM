/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gla_vchr_h
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
drop table ${iol_schema}.tgls_gla_vchr_h_ex purge;
alter table ${iol_schema}.tgls_gla_vchr_h add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_gla_vchr_h truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_gla_vchr_h_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gla_vchr_h where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_gla_vchr_h_ex(
    stacid -- 账套标记
    ,systid -- 来源系统编号
    ,trandt -- 交易日期
    ,transq -- 交易流水
    ,vchrsq -- 凭证序号
    ,tranbr -- 交易机构编号
    ,acctbr -- 账务机构编号
    ,itemcd -- 科目编号
    ,crcycd -- 币种代码
    ,ioflag -- 表内外标志
    ,centcd -- 责任中心
    ,prsncd -- 员工编号
    ,custcd -- 客户编号
    ,prducd -- 产品编号
    ,prlncd -- 产品线
    ,acctno -- 账户
    ,trantp -- 交易类型
    ,amntcd -- 借贷方向
    ,tranam -- 交易金额
    ,tranbl -- 交易余额
    ,blncdn -- 当前科目余额方向
    ,smrytx -- 摘要
    ,exchcn -- 中间价
    ,exchus -- 折算汇率
    ,usercd -- 用户代码
    ,sourdt -- 源系统日期
    ,soursq -- 源系统流水
    ,sourst -- 源系统标识
    ,srvcsq -- 源交易流水序号
    ,bearbl -- 承前余额
    ,beardn -- 承前科目余额方向
    ,toitem -- 对方科目编号
    ,assis0 -- 渠道编号
    ,assis1 -- 产品编号
    ,assis2 -- 辅助核算2（自定义）
    ,assis3 -- 辅助核算3（自定义）
    ,assis4 -- 辅助核算4（自定义）
    ,assis5 -- 辅助核算5（自定义）
    ,assis6 -- 辅助核算6（自定义）
    ,assis7 -- 辅助核算7（自定义）
    ,assis8 -- 辅助核算8（自定义）
    ,assis9 -- 辅助核算9（自定义）
    ,tranno -- 交易流水序号
    ,clertg -- 清算状态：0未清算，1待清算，2已清算，3不参与清算，4清算传票
    ,clerod -- 清算批次
    ,centsq -- 清算行流水
    ,brchsq -- 账户行流水
    ,clerdt -- 清算日期
    ,transt -- 交易状态
    ,subsac -- 子户码
    ,sourac -- 源账套
    ,strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
    ,odbsdt -- 原业务日期（被冲正业务日期）
    ,odbssq -- 原业务流水（被冲正业务流水）
    ,bathid -- 批次号
    ,tranti -- 时间戳
    ,smrycd -- 摘要编码
    ,dcmtno -- 凭证编号
    ,bsnssq -- 
    ,foldcn -- 
    ,itemna -- 科目名称
    ,istbgz -- 是否已同步关账0未同步1同步
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套标记
    ,systid -- 来源系统编号
    ,trandt -- 交易日期
    ,transq -- 交易流水
    ,vchrsq -- 凭证序号
    ,tranbr -- 交易机构编号
    ,acctbr -- 账务机构编号
    ,itemcd -- 科目编号
    ,crcycd -- 币种代码
    ,ioflag -- 表内外标志
    ,centcd -- 责任中心
    ,prsncd -- 员工编号
    ,custcd -- 客户编号
    ,prducd -- 产品编号
    ,prlncd -- 产品线
    ,acctno -- 账户
    ,trantp -- 交易类型
    ,amntcd -- 借贷方向
    ,tranam -- 交易金额
    ,tranbl -- 交易余额
    ,blncdn -- 当前科目余额方向
    ,smrytx -- 摘要
    ,exchcn -- 中间价
    ,exchus -- 折算汇率
    ,usercd -- 用户代码
    ,sourdt -- 源系统日期
    ,soursq -- 源系统流水
    ,sourst -- 源系统标识
    ,srvcsq -- 源交易流水序号
    ,bearbl -- 承前余额
    ,beardn -- 承前科目余额方向
    ,toitem -- 对方科目编号
    ,assis0 -- 渠道编号
    ,assis1 -- 产品编号
    ,assis2 -- 辅助核算2（自定义）
    ,assis3 -- 辅助核算3（自定义）
    ,assis4 -- 辅助核算4（自定义）
    ,assis5 -- 辅助核算5（自定义）
    ,assis6 -- 辅助核算6（自定义）
    ,assis7 -- 辅助核算7（自定义）
    ,assis8 -- 辅助核算8（自定义）
    ,assis9 -- 辅助核算9（自定义）
    ,tranno -- 交易流水序号
    ,clertg -- 清算状态：0未清算，1待清算，2已清算，3不参与清算，4清算传票
    ,clerod -- 清算批次
    ,centsq -- 清算行流水
    ,brchsq -- 账户行流水
    ,clerdt -- 清算日期
    ,transt -- 交易状态
    ,subsac -- 子户码
    ,sourac -- 源账套
    ,strkst -- 冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
    ,odbsdt -- 原业务日期（被冲正业务日期）
    ,odbssq -- 原业务流水（被冲正业务流水）
    ,bathid -- 批次号
    ,tranti -- 时间戳
    ,smrycd -- 摘要编码
    ,dcmtno -- 凭证编号
    ,bsnssq -- 
    ,foldcn -- 
    ,itemna -- 科目名称
    ,istbgz -- 是否已同步关账0未同步1同步
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_gla_vchr_h
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_gla_vchr_h exchange partition p_${batch_date} with table ${iol_schema}.tgls_gla_vchr_h_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gla_vchr_h to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_gla_vchr_h_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gla_vchr_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);