/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_rep_prod_config_statistics
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
drop table ${iol_schema}.fams_rep_prod_config_statistics_ex purge;
alter table ${iol_schema}.fams_rep_prod_config_statistics add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.fams_rep_prod_config_statistics truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.fams_rep_prod_config_statistics_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_rep_prod_config_statistics where 0=1;

insert /*+ append */ into ${iol_schema}.fams_rep_prod_config_statistics_ex(
    cdate -- 统计日
    ,accounttype -- 账户类型
    ,prodcode -- 理财账户ID
    ,prodname -- 理财账户名称
    ,prodvdate -- 产品起息日
    ,prodmdate -- 产品到期日
    ,actprinamt -- 实收资本
    ,custrate -- 客户收益率（%）
    ,assettype -- 资产类型
    ,booktype -- 会计分类
    ,assetcode -- 资产代码
    ,assetname -- 资产名称
    ,faceamt -- 面值
    ,netcost -- 买入净价成本
    ,intadjust -- 利息调整
    ,firstamt -- 首期结算金额
    ,expireamt -- 到期结算金额
    ,unpayamt1 -- 应收利息
    ,unpayamt2 -- 应计利息(零息券/到期一次还本)
    ,netvaluation -- 债券估值净价
    ,tdylossamt -- 资产减值金额
    ,fairvalue -- 公允价值变动
    ,facerate -- 票面利率(%)
    ,actrate -- 实际利率(%)
    ,reporate -- 回购利率(%)
    ,assetvdate -- 资产起息日
    ,assetmdate -- 资产到期日
    ,issueprice -- 发行价格
    ,intfrequency -- 付息频率
    ,payfrequency -- 还本频率
    ,lastpaydate -- 上一付息日
    ,basis -- 计息基础
    ,paystatus -- 支付状态
    ,lastvdate -- 上一计息起始日
    ,lastmdate -- 上一计息结束日
    ,profittype -- 收益类型
    ,assettypebeforeg60 -- 资产分类（G06穿透前）
    ,assettypeafterg60 -- 资产分类（G06穿透后）
    ,secyield -- 到期收益率(%)
    ,assettypeone -- 资产一级分类
    ,assettypetwo -- 资产二级分类
    ,assettypethree -- 资产三级分类
    ,assttypefour -- 资产四级分类
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cdate -- 统计日
    ,accounttype -- 账户类型
    ,prodcode -- 理财账户ID
    ,prodname -- 理财账户名称
    ,prodvdate -- 产品起息日
    ,prodmdate -- 产品到期日
    ,actprinamt -- 实收资本
    ,custrate -- 客户收益率（%）
    ,assettype -- 资产类型
    ,booktype -- 会计分类
    ,assetcode -- 资产代码
    ,assetname -- 资产名称
    ,faceamt -- 面值
    ,netcost -- 买入净价成本
    ,intadjust -- 利息调整
    ,firstamt -- 首期结算金额
    ,expireamt -- 到期结算金额
    ,unpayamt1 -- 应收利息
    ,unpayamt2 -- 应计利息(零息券/到期一次还本)
    ,netvaluation -- 债券估值净价
    ,tdylossamt -- 资产减值金额
    ,fairvalue -- 公允价值变动
    ,facerate -- 票面利率(%)
    ,actrate -- 实际利率(%)
    ,reporate -- 回购利率(%)
    ,assetvdate -- 资产起息日
    ,assetmdate -- 资产到期日
    ,issueprice -- 发行价格
    ,intfrequency -- 付息频率
    ,payfrequency -- 还本频率
    ,lastpaydate -- 上一付息日
    ,basis -- 计息基础
    ,paystatus -- 支付状态
    ,lastvdate -- 上一计息起始日
    ,lastmdate -- 上一计息结束日
    ,profittype -- 收益类型
    ,assettypebeforeg60 -- 资产分类（G06穿透前）
    ,assettypeafterg60 -- 资产分类（G06穿透后）
    ,secyield -- 到期收益率(%)
    ,assettypeone -- 资产一级分类
    ,assettypetwo -- 资产二级分类
    ,assettypethree -- 资产三级分类
    ,assttypefour -- 资产四级分类
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.fams_rep_prod_config_statistics
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.fams_rep_prod_config_statistics exchange partition p_${batch_date} with table ${iol_schema}.fams_rep_prod_config_statistics_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_rep_prod_config_statistics to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.fams_rep_prod_config_statistics_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_rep_prod_config_statistics',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);