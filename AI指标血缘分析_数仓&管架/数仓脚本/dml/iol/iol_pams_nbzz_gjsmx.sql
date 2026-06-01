/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_nbzz_gjsmx
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
drop table ${iol_schema}.pams_nbzz_gjsmx_ex purge;
alter table ${iol_schema}.pams_nbzz_gjsmx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_nbzz_gjsmx truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_nbzz_gjsmx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_nbzz_gjsmx where 0=1;

insert /*+ append */ into ${iol_schema}.pams_nbzz_gjsmx_ex(
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khh -- 客户号
    ,jgdh -- 机构代号
    ,khdxdh -- 考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,bz -- 币种
    ,fpjs -- 分配角色
    ,zlbl -- 增量比例
    ,ddh -- 行内订单号
    ,yhlsh -- 银行流水号
    ,jyrq -- 交易日期
    ,ddrq -- 订单日期
    ,khmc -- 客户名称
    ,cph -- 产品号
    ,cpmc -- 产品名称
    ,cpcs -- 产品成色
    ,hjl -- 含金量
    ,hyl -- 含银量
    ,gmsl -- 购买数量
    ,gysmc -- 供应商名称
    ,xsqd -- 销售渠道
    ,jydj -- 交易单价
    ,zhye -- 账户余额
    ,sxf -- 手续费
    ,hydh -- 行员代号
    ,sjly -- 数据来源
    ,fphzhye -- 分配后余额
    ,fphsxf -- 分配后手续费
    ,cpfldm -- 产品分类代码
    ,scddh -- 商城订单号
    ,fphzhyeylj -- 分配后账户余额月累计
    ,fphzhyejlj -- 分配后账户余额季累计
    ,fphzhyenlj -- 分配后账户余额年累计
    ,zhyeylj -- 账户余额月累计
    ,zhyejlj -- 账户余额季累计
    ,zhyenlj -- 账户余额年累计
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,jxdxdh -- 绩效对象代号
    ,khh -- 客户号
    ,jgdh -- 机构代号
    ,khdxdh -- 考核对象代号
    ,jgkhdxdh -- 机构考核对象代号
    ,bz -- 币种
    ,fpjs -- 分配角色
    ,zlbl -- 增量比例
    ,ddh -- 行内订单号
    ,yhlsh -- 银行流水号
    ,jyrq -- 交易日期
    ,ddrq -- 订单日期
    ,khmc -- 客户名称
    ,cph -- 产品号
    ,cpmc -- 产品名称
    ,cpcs -- 产品成色
    ,hjl -- 含金量
    ,hyl -- 含银量
    ,gmsl -- 购买数量
    ,gysmc -- 供应商名称
    ,xsqd -- 销售渠道
    ,jydj -- 交易单价
    ,zhye -- 账户余额
    ,sxf -- 手续费
    ,hydh -- 行员代号
    ,sjly -- 数据来源
    ,fphzhye -- 分配后余额
    ,fphsxf -- 分配后手续费
    ,cpfldm -- 产品分类代码
    ,scddh -- 商城订单号
    ,fphzhyeylj -- 分配后账户余额月累计
    ,fphzhyejlj -- 分配后账户余额季累计
    ,fphzhyenlj -- 分配后账户余额年累计
    ,zhyeylj -- 账户余额月累计
    ,zhyejlj -- 账户余额季累计
    ,zhyenlj -- 账户余额年累计
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_nbzz_gjsmx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_nbzz_gjsmx exchange partition p_${batch_date} with table ${iol_schema}.pams_nbzz_gjsmx_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_nbzz_gjsmx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_nbzz_gjsmx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_nbzz_gjsmx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);