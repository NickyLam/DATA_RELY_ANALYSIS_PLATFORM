/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gla_chk_subl
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
drop table ${iol_schema}.tgls_gla_chk_subl_ex purge;
alter table ${iol_schema}.tgls_gla_chk_subl add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_gla_chk_subl truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_gla_chk_subl_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gla_chk_subl where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_gla_chk_subl_ex(
    stacid -- 账套标识
    ,acctdt -- 账务时间(核对时)
    ,brchcd -- 组织编码
    ,itemcd -- 总账科目编号
    ,systid -- 系统标识
    ,balanc -- 余额
    ,onlnbl -- 账户余额
    ,crcycd -- 币种
    ,status -- 处理状态（0：未处理1：已处理）
    ,dimens -- 核对多维
    ,amoutp -- 核对金额类别
    ,chekcd -- 核对方案编码
    ,realtp -- 核对方案真实金额类别
    ,dimsvl -- 核对维度及值
    ,itemdn -- 金额方向
    ,om1nb1 -- 业务系统余额
    ,trprcd -- 金额类型
    ,drtsam -- 借方本期发生额
    ,crtsam -- 借方本期发生额
    ,drctbl -- 借方本期余额
    ,crctbl -- 贷方本期余额
    ,gldnfm -- 核算中台：借方本期发生额
    ,glcnfm -- 核算中台：贷方本期发生额
    ,gldnym -- 核算中台：借方本期余额
    ,glcnym -- 核算中台：贷方本期余额
    ,blnwyl -- 核算中台：当前余额方向
    ,glnwmy -- 核算中台：当前余额
    ,erortx -- 对账结果信息
    ,blncdn -- 当前余额方向
    ,assis8 -- 可售产品
    ,omlnbl -- 业务系统余额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套标识
    ,acctdt -- 账务时间(核对时)
    ,brchcd -- 组织编码
    ,itemcd -- 总账科目编号
    ,systid -- 系统标识
    ,balanc -- 余额
    ,onlnbl -- 账户余额
    ,crcycd -- 币种
    ,status -- 处理状态（0：未处理1：已处理）
    ,dimens -- 核对多维
    ,amoutp -- 核对金额类别
    ,chekcd -- 核对方案编码
    ,realtp -- 核对方案真实金额类别
    ,dimsvl -- 核对维度及值
    ,itemdn -- 金额方向
    ,om1nb1 -- 业务系统余额
    ,trprcd -- 金额类型
    ,drtsam -- 借方本期发生额
    ,crtsam -- 借方本期发生额
    ,drctbl -- 借方本期余额
    ,crctbl -- 贷方本期余额
    ,gldnfm -- 核算中台：借方本期发生额
    ,glcnfm -- 核算中台：贷方本期发生额
    ,gldnym -- 核算中台：借方本期余额
    ,glcnym -- 核算中台：贷方本期余额
    ,blnwyl -- 核算中台：当前余额方向
    ,glnwmy -- 核算中台：当前余额
    ,erortx -- 对账结果信息
    ,blncdn -- 当前余额方向
    ,assis8 -- 可售产品
    ,omlnbl -- 业务系统余额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_gla_chk_subl
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_gla_chk_subl exchange partition p_${batch_date} with table ${iol_schema}.tgls_gla_chk_subl_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gla_chk_subl to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_gla_chk_subl_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gla_chk_subl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);