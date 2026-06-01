/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_mm_modelanalysis
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
drop table ${iol_schema}.nrrs_mm_modelanalysis_ex purge;
alter table ${iol_schema}.nrrs_mm_modelanalysis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.nrrs_mm_modelanalysis;

-- 2.3 insert data to ex table
create table ${iol_schema}.nrrs_mm_modelanalysis_ex nologging
compress
as
select * from ${iol_schema}.nrrs_mm_modelanalysis where 0=1;

insert /*+ append */ into ${iol_schema}.nrrs_mm_modelanalysis_ex(
    snumberrat -- 评级流水号
    ,ratitem -- 评级期次
    ,indextime -- 引用指标值期次
    ,index1 -- 对象代码1
    ,index2 -- 对象代码2
    ,index3 -- 对象代码3
    ,index4 -- 对象代码4
    ,index5 -- 对象代码5
    ,lsh -- 模型标识
    ,modelcode -- 模型代码
    ,indexcode -- 指标代码
    ,indextype -- 指标类型
    ,weight -- 权重
    ,lowlimit -- 指标下限
    ,uplimit -- 指标上限
    ,ylowlimit -- 指标值静态黄色预警分值下限
    ,yuplimit -- 指标值静态黄色预警分值上限
    ,yinterval -- 指标值静态黄色预警区间开闭
    ,rlowlimit -- 指标值静态红色预警分值下限
    ,ruplimit -- 指标值静态红色预警分值上限
    ,rinterval -- 指标值静态红色预警区间开闭
    ,ylowlimit2 -- 分值静态黄色预警分值下限
    ,yuplimit2 -- 分值静态黄色预警分值上限
    ,yinterval2 -- 分值静态黄色预警区间开闭
    ,rlowlimit2 -- 分值静态红色预警分值下限
    ,ruplimit2 -- 分值静态红色预警分值上限
    ,rinterval2 -- 分值静态红色预警区间开闭
    ,ylowlimit3 -- 分值动态黄色预警分值下限
    ,yuplimit3 -- 分值动态黄色预警分值上限
    ,yinterval3 -- 分值动态黄色预警区间开闭
    ,rlowlimit3 -- 分值动态红色预警分值下限
    ,ruplimit3 -- 分值动态红色预警分值上限
    ,rinterval3 -- 分值动态红色预警区间开闭
    ,indexvalue -- 指标值
    ,individvalue -- 单项分值
    ,indexriskvalue -- 指标分值
    ,coefficient -- 风险系数
    ,jqindividvalue -- 基期单项分值
    ,jqriskvalue -- 基期指标分值
    ,riskvaluewave -- 指标分值波动
    ,risklevelinit -- 初始风险等级
    ,risklevel -- 风险等级
    ,wavelevel -- 波动级别
    ,mulwarnflag -- 综合预警结果
    ,indexwarnflag -- 指标值预警结果
    ,valueswarnflag -- 分值静态预警结果
    ,valuedwarnflag -- 分值波动预警结果
    ,indexlevel -- 指标等级
    ,oldindexriskvalue -- 原指标分值
    ,oldindexlevel -- 原指标等级
    ,reason -- 调整原因
    ,indexname -- 指标名称
    ,upindexcode -- 指标分组
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    snumberrat -- 评级流水号
    ,ratitem -- 评级期次
    ,indextime -- 引用指标值期次
    ,index1 -- 对象代码1
    ,index2 -- 对象代码2
    ,index3 -- 对象代码3
    ,index4 -- 对象代码4
    ,index5 -- 对象代码5
    ,lsh -- 模型标识
    ,modelcode -- 模型代码
    ,indexcode -- 指标代码
    ,indextype -- 指标类型
    ,weight -- 权重
    ,lowlimit -- 指标下限
    ,uplimit -- 指标上限
    ,ylowlimit -- 指标值静态黄色预警分值下限
    ,yuplimit -- 指标值静态黄色预警分值上限
    ,yinterval -- 指标值静态黄色预警区间开闭
    ,rlowlimit -- 指标值静态红色预警分值下限
    ,ruplimit -- 指标值静态红色预警分值上限
    ,rinterval -- 指标值静态红色预警区间开闭
    ,ylowlimit2 -- 分值静态黄色预警分值下限
    ,yuplimit2 -- 分值静态黄色预警分值上限
    ,yinterval2 -- 分值静态黄色预警区间开闭
    ,rlowlimit2 -- 分值静态红色预警分值下限
    ,ruplimit2 -- 分值静态红色预警分值上限
    ,rinterval2 -- 分值静态红色预警区间开闭
    ,ylowlimit3 -- 分值动态黄色预警分值下限
    ,yuplimit3 -- 分值动态黄色预警分值上限
    ,yinterval3 -- 分值动态黄色预警区间开闭
    ,rlowlimit3 -- 分值动态红色预警分值下限
    ,ruplimit3 -- 分值动态红色预警分值上限
    ,rinterval3 -- 分值动态红色预警区间开闭
    ,indexvalue -- 指标值
    ,individvalue -- 单项分值
    ,indexriskvalue -- 指标分值
    ,coefficient -- 风险系数
    ,jqindividvalue -- 基期单项分值
    ,jqriskvalue -- 基期指标分值
    ,riskvaluewave -- 指标分值波动
    ,risklevelinit -- 初始风险等级
    ,risklevel -- 风险等级
    ,wavelevel -- 波动级别
    ,mulwarnflag -- 综合预警结果
    ,indexwarnflag -- 指标值预警结果
    ,valueswarnflag -- 分值静态预警结果
    ,valuedwarnflag -- 分值波动预警结果
    ,indexlevel -- 指标等级
    ,oldindexriskvalue -- 原指标分值
    ,oldindexlevel -- 原指标等级
    ,reason -- 调整原因
    ,indexname -- 指标名称
    ,upindexcode -- 指标分组
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nrrs_mm_modelanalysis
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nrrs_mm_modelanalysis exchange partition p_${batch_date} with table ${iol_schema}.nrrs_mm_modelanalysis_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_mm_modelanalysis to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nrrs_mm_modelanalysis_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_mm_modelanalysis',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);