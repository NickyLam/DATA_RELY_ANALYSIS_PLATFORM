/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_zjywzcmx_recal
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
drop table ${iol_schema}.pams_jxbb_zjywzcmx_recal_ex purge;
alter table ${iol_schema}.pams_jxbb_zjywzcmx_recal add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.pams_jxbb_zjywzcmx_recal truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.pams_jxbb_zjywzcmx_recal_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_zjywzcmx_recal where 0=1;

insert /*+ append */ into ${iol_schema}.pams_jxbb_zjywzcmx_recal_ex(
    tjrq -- 统计日期
    ,recal_dt -- 重算日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,gsjgdxdh -- 归属机构对象代号
    ,gsjgdh -- 归属机构代号
    ,gsjgmc -- 归属机构名称
    ,zwjgdxdh -- 账务机构对象代号
    ,zwjgdh -- 账务机构编号
    ,zwjgmc -- 账务机构名称
    ,khlx -- 客户类型
    ,jylsh -- 交易流水号
    ,qjlsh -- 全局流水号
    ,ywlsh -- 业务流水号
    ,sfdjh -- 收费单据号
    ,sflsh -- 收费流水号
    ,sfrq -- 收费日期
    ,jsrq -- 交易日期
    ,zwrq -- 账务日期
    ,txbz -- 摊销标志
    ,txlsh -- 摊销流水号
    ,txksrq -- 摊销开始日期
    ,txjsrq -- 摊销结束日期
    ,ljtxje -- 累计摊销金额
    ,dtze -- 待摊总金额
    ,jyje -- 交易金额
    ,bz -- 币种
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,bzcpbh -- 标准产品编号
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,khgstxlxdm -- 客户归属条线类型代码
    ,jyjgdh -- 交易机构代号
    ,jyjgdxdh -- 交易机构对象代号
    ,jyjgmc -- 交易机构名称
    ,jyzhbh -- 交易账户编号
    ,jyzzhbh -- 交易主账户编号
    ,jyczhbh -- 交易子账户编号
    ,jyqddm -- 交易渠道代码
    ,yxtdm -- 源系统代码
    ,hydh -- 客户经理编号
    ,hymc -- 行员名称
    ,sffsdm -- 收费方式代码
    ,sxfzqfs -- 手续费收取方式
    ,jylxdm -- 交易类型代码
    ,jdbz -- 借贷标志
    ,mzbz -- 抹账标志
    ,czbz -- 冲正标志
    ,xjjybz -- 现金交易标志
    ,etl_t -- ETL处理时间戳
    ,ywzhbh -- 业务账户编号
    ,ybbz -- 原表币种
    ,jyjeylj -- 交易金额月累计
    ,jyjejlj -- 交易金额季累计
    ,jyjenlj -- 交易金额年累计
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tjrq -- 统计日期
    ,recal_dt -- 重算日期
    ,jxdxdh -- 绩效对象代号
    ,khdxdh -- 考核对象代号
    ,gsjgdxdh -- 归属机构对象代号
    ,gsjgdh -- 归属机构代号
    ,gsjgmc -- 归属机构名称
    ,zwjgdxdh -- 账务机构对象代号
    ,zwjgdh -- 账务机构编号
    ,zwjgmc -- 账务机构名称
    ,khlx -- 客户类型
    ,jylsh -- 交易流水号
    ,qjlsh -- 全局流水号
    ,ywlsh -- 业务流水号
    ,sfdjh -- 收费单据号
    ,sflsh -- 收费流水号
    ,sfrq -- 收费日期
    ,jsrq -- 交易日期
    ,zwrq -- 账务日期
    ,txbz -- 摊销标志
    ,txlsh -- 摊销流水号
    ,txksrq -- 摊销开始日期
    ,txjsrq -- 摊销结束日期
    ,ljtxje -- 累计摊销金额
    ,dtze -- 待摊总金额
    ,jyje -- 交易金额
    ,bz -- 币种
    ,kmh -- 科目号
    ,kmmc -- 科目名称
    ,bzcpbh -- 标准产品编号
    ,khh -- 客户号
    ,khmc -- 客户名称
    ,khgstxlxdm -- 客户归属条线类型代码
    ,jyjgdh -- 交易机构代号
    ,jyjgdxdh -- 交易机构对象代号
    ,jyjgmc -- 交易机构名称
    ,jyzhbh -- 交易账户编号
    ,jyzzhbh -- 交易主账户编号
    ,jyczhbh -- 交易子账户编号
    ,jyqddm -- 交易渠道代码
    ,yxtdm -- 源系统代码
    ,hydh -- 客户经理编号
    ,hymc -- 行员名称
    ,sffsdm -- 收费方式代码
    ,sxfzqfs -- 手续费收取方式
    ,jylxdm -- 交易类型代码
    ,jdbz -- 借贷标志
    ,mzbz -- 抹账标志
    ,czbz -- 冲正标志
    ,xjjybz -- 现金交易标志
    ,etl_t -- ETL处理时间戳
    ,ywzhbh -- 业务账户编号
    ,ybbz -- 原表币种
    ,jyjeylj -- 交易金额月累计
    ,jyjejlj -- 交易金额季累计
    ,jyjenlj -- 交易金额年累计
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.pams_jxbb_zjywzcmx_recal
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.pams_jxbb_zjywzcmx_recal exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_zjywzcmx_recal_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_zjywzcmx_recal to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.pams_jxbb_zjywzcmx_recal_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_zjywzcmx_recal',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);