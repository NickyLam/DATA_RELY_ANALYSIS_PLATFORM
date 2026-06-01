/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_jjksqdfymx
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
drop table ${iol_schema}.pams_jxbb_jjksqdfymx_ex purge;
alter table ${iol_schema}.pams_jxbb_jjksqdfymx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.pams_jxbb_jjksqdfymx;

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_jjksqdfymx_ex nologging
compress
as
select * from ${iol_schema}.pams_jxbb_jjksqdfymx where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_jjksqdfymx_ex(
    tjrq -- 统计日期
    ,jyrq -- 交易日期
    ,jjgsbh -- 基金公司编号
    ,jjgsmc -- 基金公司名称
    ,khjgdh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgdh -- 所属机构代号
    ,ssjgmc -- 所属机构名称
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,lxszkmh -- 利息收支科目号
    ,lxszkmmc -- 利息收支科目名称
    ,zlbl -- 分配比例
    ,jyje -- 交易金额
    ,zhye -- 时点余额
    ,zhyeylj -- 当月累计余额
    ,zhyrj -- 月日均余额
    ,zhyenlj -- 当年累计余额
    ,zhnrj -- 年日均余额
    ,ftpjg -- FTP价格
    ,ftpsrylj -- FTP收入月累计
    ,ftpsrnlj -- FTP收入年累计
    ,tzhftpjg -- 调整后FTP价格
    ,tzhftpsrylj -- 调整后FTP收入月累计
    ,tzhftpsrnlj -- 调整后FTP收入年累计
    ,qdfyylj -- 渠道费用月累计
    ,qdfynlj -- 渠道费用年累计
    ,ylfyylj -- 银联费用月累计
    ,ylfynlj -- 银联费用年累计
    ,ftpsyylj -- FTP收益月累计
    ,ftpsynlj -- FTP收益年累计
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jyrq -- 交易日期
    ,jjgsbh -- 基金公司编号
    ,jjgsmc -- 基金公司名称
    ,khjgdh -- 开户机构代号
    ,khjgmc -- 开户机构名称
    ,ssjgkhdxdh -- 所属机构考核对象代号
    ,ssjgdh -- 所属机构代号
    ,ssjgmc -- 所属机构名称
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,lxszkmh -- 利息收支科目号
    ,lxszkmmc -- 利息收支科目名称
    ,zlbl -- 分配比例
    ,jyje -- 交易金额
    ,zhye -- 时点余额
    ,zhyeylj -- 当月累计余额
    ,zhyrj -- 月日均余额
    ,zhyenlj -- 当年累计余额
    ,zhnrj -- 年日均余额
    ,ftpjg -- FTP价格
    ,ftpsrylj -- FTP收入月累计
    ,ftpsrnlj -- FTP收入年累计
    ,tzhftpjg -- 调整后FTP价格
    ,tzhftpsrylj -- 调整后FTP收入月累计
    ,tzhftpsrnlj -- 调整后FTP收入年累计
    ,qdfyylj -- 渠道费用月累计
    ,qdfynlj -- 渠道费用年累计
    ,ylfyylj -- 银联费用月累计
    ,ylfynlj -- 银联费用年累计
    ,ftpsyylj -- FTP收益月累计
    ,ftpsynlj -- FTP收益年累计
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_jjksqdfymx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_jjksqdfymx exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_jjksqdfymx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_jjksqdfymx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_jjksqdfymx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_jjksqdfymx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);