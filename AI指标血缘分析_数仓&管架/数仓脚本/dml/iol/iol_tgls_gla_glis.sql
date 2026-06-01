/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gla_glis
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
drop table ${iol_schema}.tgls_gla_glis_ex purge;
alter table ${iol_schema}.tgls_gla_glis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.tgls_gla_glis truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_gla_glis_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gla_glis where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_gla_glis_ex(
    stacid -- 账套标记
    ,systid -- 来源系统编号
    ,acctdt -- 账务会计日期
    ,brchcd -- 机构编号（总账机构）
    ,itemcd -- 科目编号
    ,centcd -- 责任中心
    ,prsncd -- 员工编号
    ,custcd -- 客户编号
    ,prducd -- 产品编号
    ,prlncd -- 产品线
    ,acctno -- 账户
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
    ,geldtp -- 总账类型(d日总帐m月总帐q季总帐y年总帐)
    ,crcycd -- 币种代码
    ,drltbl -- 上期借方余额
    ,crltbl -- 上期贷方余额
    ,drtsam -- 本期借方发生额
    ,drtsnm -- 借方本期发生笔数
    ,crtsam -- 本期贷方发生额
    ,crtsnm -- 贷方本期发生笔数
    ,drctbl -- 本期借方余额
    ,crctbl -- 本期贷方余额
    ,blncdn -- 当前科目余额方向
    ,onlnbl -- 当前余额
    ,lastdn -- 上期科目余额方向
    ,lastbl -- 上期余额
    ,drtsaj -- 借方外币折算调整值
    ,crtsaj -- 贷方外币折算调整值
    ,dlflcbl -- 本位币期初借方余额
    ,clflcbl -- 本位币期初贷方余额
    ,dtflcam -- 本位币借方本期发生额
    ,ctflcam -- 本位币贷方本期发生额
    ,drflcbl -- 本位币期末借方余额
    ,crflcbl -- 本位币期末贷方余额
    ,itemna -- 科目名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套标记
    ,systid -- 来源系统编号
    ,acctdt -- 账务会计日期
    ,brchcd -- 机构编号（总账机构）
    ,itemcd -- 科目编号
    ,centcd -- 责任中心
    ,prsncd -- 员工编号
    ,custcd -- 客户编号
    ,prducd -- 产品编号
    ,prlncd -- 产品线
    ,acctno -- 账户
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
    ,geldtp -- 总账类型(d日总帐m月总帐q季总帐y年总帐)
    ,crcycd -- 币种代码
    ,drltbl -- 上期借方余额
    ,crltbl -- 上期贷方余额
    ,drtsam -- 本期借方发生额
    ,drtsnm -- 借方本期发生笔数
    ,crtsam -- 本期贷方发生额
    ,crtsnm -- 贷方本期发生笔数
    ,drctbl -- 本期借方余额
    ,crctbl -- 本期贷方余额
    ,blncdn -- 当前科目余额方向
    ,onlnbl -- 当前余额
    ,lastdn -- 上期科目余额方向
    ,lastbl -- 上期余额
    ,drtsaj -- 借方外币折算调整值
    ,crtsaj -- 贷方外币折算调整值
    ,dlflcbl -- 本位币期初借方余额
    ,clflcbl -- 本位币期初贷方余额
    ,dtflcam -- 本位币借方本期发生额
    ,ctflcam -- 本位币贷方本期发生额
    ,drflcbl -- 本位币期末借方余额
    ,crflcbl -- 本位币期末贷方余额
    ,itemna -- 科目名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_gla_glis
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_gla_glis exchange partition p_${batch_date} with table ${iol_schema}.tgls_gla_glis_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gla_glis to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_gla_glis_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gla_glis',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);