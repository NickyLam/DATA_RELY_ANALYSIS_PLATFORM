/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_zjywsrmx_recal
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
drop table ${iol_schema}.pams_jxbb_zjywsrmx_recal_ex purge;
alter table ${iol_schema}.pams_jxbb_zjywsrmx_recal add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_zjywsrmx_recal truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_zjywsrmx_recal_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_zjywsrmx_recal where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_zjywsrmx_recal_ex(
    tjrq -- 数据入库日期
    ,recal_dt -- 重算日期
    ,jzlsh -- 记账流水号
    ,rzrq -- 入账日期
    ,tjrzrq -- 统计入账日期
    ,rzkm -- 入账科目
    ,kmmc -- 科目名称
    ,jzjgdh -- 记账机构编号
    ,jzjgmc -- 记账机构名称
    ,bz -- 币种
    ,khlx -- 客户类型
    ,hsje -- 含税金额
    ,shje -- 赎回金额
    ,se -- 税额
    ,txbz -- 摊销标识
    ,sfrq -- 收费日期
    ,sflsh -- 收费流水号
    ,sfje -- 收费金额
    ,ywbh -- 业务编号
    ,dybwkm -- 对应表外科目
    ,dybwje -- 对应表外金额
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,jgdh -- 机构号
    ,jgmc -- 机构名称
    ,hydh -- 客户经理工号
    ,hymc -- 行员名称
    ,zlbl -- 认领比例
    ,jyje -- 交易金额
    ,fphdyje -- 分配后当月金额
    ,fphljje -- 分配后累计金额
    ,ywlx -- 业务类型
    ,jgkhdxdh -- 机构考核对象代号
    ,jzjgkhdxdh -- 记账机构考核对象代号
    ,jxdxdh -- 绩效对象代号
    ,sfdm -- 收费代码,
    ,sfmc -- 收费名称
    ,ybbz -- 原币币种
    ,cpxdl -- 产品线大类
    ,sflx -- 算法类型
    ,sfz -- 身份证
    ,jzsf -- 基础收费
    ,sfxmc -- 收费名称
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,zylx -- 质押类型
    ,xyzbh -- 信用证编号
    ,jylsh -- 交易流水号
    ,sxfzqfs -- 手续费收取方式
    ,yxtdm -- 源系统代码
    ,gjywbs -- 国际业务标识：0-否，1-是
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 数据入库日期
    ,recal_dt -- 重算日期
    ,jzlsh -- 记账流水号
    ,rzrq -- 入账日期
    ,tjrzrq -- 统计入账日期
    ,rzkm -- 入账科目
    ,kmmc -- 科目名称
    ,jzjgdh -- 记账机构编号
    ,jzjgmc -- 记账机构名称
    ,bz -- 币种
    ,khlx -- 客户类型
    ,hsje -- 含税金额
    ,shje -- 赎回金额
    ,se -- 税额
    ,txbz -- 摊销标识
    ,sfrq -- 收费日期
    ,sflsh -- 收费流水号
    ,sfje -- 收费金额
    ,ywbh -- 业务编号
    ,dybwkm -- 对应表外科目
    ,dybwje -- 对应表外金额
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,jgdh -- 机构号
    ,jgmc -- 机构名称
    ,hydh -- 客户经理工号
    ,hymc -- 行员名称
    ,zlbl -- 认领比例
    ,jyje -- 交易金额
    ,fphdyje -- 分配后当月金额
    ,fphljje -- 分配后累计金额
    ,ywlx -- 业务类型
    ,jgkhdxdh -- 机构考核对象代号
    ,jzjgkhdxdh -- 记账机构考核对象代号
    ,jxdxdh -- 绩效对象代号
    ,sfdm -- 收费代码,
    ,sfmc -- 收费名称
    ,ybbz -- 原币币种
    ,cpxdl -- 产品线大类
    ,sflx -- 算法类型
    ,sfz -- 身份证
    ,jzsf -- 基础收费
    ,sfxmc -- 收费名称
    ,fptx -- 所属条线
    ,txfpbl -- 条线分配比例
    ,zylx -- 质押类型
    ,xyzbh -- 信用证编号
    ,jylsh -- 交易流水号
    ,sxfzqfs -- 手续费收取方式
    ,yxtdm -- 源系统代码
    ,gjywbs -- 国际业务标识：0-否，1-是
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_zjywsrmx_recal
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_zjywsrmx_recal exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_zjywsrmx_recal_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_zjywsrmx_recal to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_zjywsrmx_recal_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_zjywsrmx_recal',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);