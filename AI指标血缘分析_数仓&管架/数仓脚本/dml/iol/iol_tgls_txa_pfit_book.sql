/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_txa_pfit_book
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
drop table ${iol_schema}.tgls_txa_pfit_book_ex purge;
alter table ${iol_schema}.tgls_txa_pfit_book add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.tgls_txa_pfit_book;

-- 2.3 insert data to ex table
create table ${iol_schema}.tgls_txa_pfit_book_ex nologging
compress
as
select * from ${iol_schema}.tgls_txa_pfit_book where 0=1;

insert /*+ append */ into ${iol_schema}.tgls_txa_pfit_book_ex(
    stacid -- 账套
    ,txisyr -- 年度
    ,txismh -- 纳税期
    ,brchcd -- 机构编号
    ,crcycd -- 币种
    ,prodcd -- 类别
    ,lastbl -- 期初数
    ,tranam -- 本期发生额
    ,onlnbl -- 期末数
    ,yronbl -- 年累计数
    ,lstxam -- 上年销项税额
    ,vatxam -- 本期销项税额
    ,typecd -- 税目
    ,vatxrt -- 税率
    ,yrtxbl -- 本年累计税额
    ,prsncd -- 员工编号
    ,prducd -- 产品编号
    ,centcd -- 责任中心
    ,prlncd -- 产品线
    ,custcd -- 客户编号
    ,acctno -- 账户
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    stacid -- 账套
    ,txisyr -- 年度
    ,txismh -- 纳税期
    ,brchcd -- 机构编号
    ,crcycd -- 币种
    ,prodcd -- 类别
    ,lastbl -- 期初数
    ,tranam -- 本期发生额
    ,onlnbl -- 期末数
    ,yronbl -- 年累计数
    ,lstxam -- 上年销项税额
    ,vatxam -- 本期销项税额
    ,typecd -- 税目
    ,vatxrt -- 税率
    ,yrtxbl -- 本年累计税额
    ,prsncd -- 员工编号
    ,prducd -- 产品编号
    ,centcd -- 责任中心
    ,prlncd -- 产品线
    ,custcd -- 客户编号
    ,acctno -- 账户
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.tgls_txa_pfit_book
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.tgls_txa_pfit_book exchange partition p_${batch_date} with table ${iol_schema}.tgls_txa_pfit_book_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_txa_pfit_book to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.tgls_txa_pfit_book_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_txa_pfit_book',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);