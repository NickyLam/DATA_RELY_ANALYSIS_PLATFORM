/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gli_vchr_h
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
drop table ${iol_schema}.tgls_gli_vchr_h_ex purge;
alter table ${iol_schema}.tgls_gli_vchr_h add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_gli_vchr_h truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_gli_vchr_h_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gli_vchr_h where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_gli_vchr_h_ex(
    stacid -- 账套标识
    ,trandt -- 总账日期（总账入账日期）
    ,transq -- 总账流水（总账入账流水）
    ,vchrsq -- 传票流水
    ,tranbr -- 交易机构编号
    ,acctbr -- 账务机构编号
    ,itemcd -- 科目编号
    ,crcycd -- 币种代码
    ,centcd -- 责任中心辅助核算
    ,prsncd -- 职员辅助核算
    ,custcd -- 往来单位（辅助）
    ,prducd -- 产品辅助核算
    ,prlncd -- 业务条线
    ,acctno -- 总账账号
    ,trantp -- 交易类型（tr,cs）
    ,amntcd -- 借贷方向（d:借(收)c:贷(付)）
    ,tranam -- 交易金额
    ,smrytx -- 摘要
    ,exchcn -- 中间价
    ,exchus -- 折算率
    ,usercd -- 用户代码
    ,sourdt -- 源系统日期
    ,soursq -- 源系统流水号（凭证号）
    ,sourst -- 源系统标识（ltts-综合业务acct-财务）
    ,toitem -- 对方科目编号
    ,assis0 -- 渠道编号
    ,assis1 -- 产品编号
    ,assis2 -- 辅助核算2
    ,assis3 -- 辅助核算3
    ,assis4 -- 辅助核算4
    ,assis5 -- 辅助核算5
    ,assis6 -- 辅助核算6
    ,assis7 -- 辅助核算7
    ,assis8 -- 辅助核算8
    ,assis9 -- 辅助核算9
    ,dealst -- 处理状态(0：未处理1:成功2：失败5：不处理6：已回执)
    ,prcscd -- 交易码
    ,itemna -- 科目名称
    ,prcsna -- 交易码名称
    ,strkst -- 冲正标识（0：正常业务1：冲正业务）
    ,strkdt -- 被冲正业务交易日期
    ,strksq -- 被冲正业务交易流水
    ,crcysd -- 本位币
    ,traneq -- 折算金额（本位币）
    ,taxbst -- 日终应税流水处理状态(0：未处理1:成功2：失败5：不处理6：已回执)
    ,dealmg -- 价税分离错误信息
    ,trannm -- 交易笔数
    ,transt -- 处理状态（1已处理0未处理）
    ,taxam -- 税额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套标识
    ,trandt -- 总账日期（总账入账日期）
    ,transq -- 总账流水（总账入账流水）
    ,vchrsq -- 传票流水
    ,tranbr -- 交易机构编号
    ,acctbr -- 账务机构编号
    ,itemcd -- 科目编号
    ,crcycd -- 币种代码
    ,centcd -- 责任中心辅助核算
    ,prsncd -- 职员辅助核算
    ,custcd -- 往来单位（辅助）
    ,prducd -- 产品辅助核算
    ,prlncd -- 业务条线
    ,acctno -- 总账账号
    ,trantp -- 交易类型（tr,cs）
    ,amntcd -- 借贷方向（d:借(收)c:贷(付)）
    ,tranam -- 交易金额
    ,smrytx -- 摘要
    ,exchcn -- 中间价
    ,exchus -- 折算率
    ,usercd -- 用户代码
    ,sourdt -- 源系统日期
    ,soursq -- 源系统流水号（凭证号）
    ,sourst -- 源系统标识（ltts-综合业务acct-财务）
    ,toitem -- 对方科目编号
    ,assis0 -- 渠道编号
    ,assis1 -- 产品编号
    ,assis2 -- 辅助核算2
    ,assis3 -- 辅助核算3
    ,assis4 -- 辅助核算4
    ,assis5 -- 辅助核算5
    ,assis6 -- 辅助核算6
    ,assis7 -- 辅助核算7
    ,assis8 -- 辅助核算8
    ,assis9 -- 辅助核算9
    ,dealst -- 处理状态(0：未处理1:成功2：失败5：不处理6：已回执)
    ,prcscd -- 交易码
    ,itemna -- 科目名称
    ,prcsna -- 交易码名称
    ,strkst -- 冲正标识（0：正常业务1：冲正业务）
    ,strkdt -- 被冲正业务交易日期
    ,strksq -- 被冲正业务交易流水
    ,crcysd -- 本位币
    ,traneq -- 折算金额（本位币）
    ,taxbst -- 日终应税流水处理状态(0：未处理1:成功2：失败5：不处理6：已回执)
    ,dealmg -- 价税分离错误信息
    ,trannm -- 交易笔数
    ,transt -- 处理状态（1已处理0未处理）
    ,taxam -- 税额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_gli_vchr_h
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_gli_vchr_h exchange partition p_${batch_date} with table ${iol_schema}.tgls_gli_vchr_h_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gli_vchr_h to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_gli_vchr_h_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gli_vchr_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);