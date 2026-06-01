/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_alterbalance
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
drop table ${iol_schema}.ctms_tbs_v_alterbalance_ex purge;
alter table ${iol_schema}.ctms_tbs_v_alterbalance add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ctms_tbs_v_alterbalance truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ctms_tbs_v_alterbalance_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_alterbalance where 0=1;

insert /*+ append */ into ${iol_schema}.ctms_tbs_v_alterbalance_ex(
    baretrade_id -- 引用表ID
    ,baretradename -- 引用表名
    ,alterbalance_id -- 引用表2ID
    ,aspclient_id -- 所属部门ID
    ,keepfolder_id -- 账户ID
    ,stdtrade_id -- 引用表3ID
    ,acccode -- 业务类型代码
    ,assettype -- 资产类别
    ,buztype -- 业务类别
    ,majorassetcode -- 主资产代码
    ,minorassetcode -- 次资产代码
    ,settledate -- 实际收付日期
    ,holdposition -- 持有仓位
    ,holdfaceamount -- 持有面额
    ,cleanpricecost -- 净价成本
    ,interestadjust -- 利息调整
    ,fairvaluealter -- 公允价值变动
    ,interestcost -- 利息成本
    ,dirtypricecost -- 全价成本
    ,impairment -- 减值准备
    ,priceearning -- 价差收益
    ,amortizeearning -- 摊销收益
    ,interestearning -- 利息收益
    ,fairvalueincome -- 公允价值变动损益
    ,impairmentlost -- 减值损失
    ,tradeexpense -- 交易费用
    ,realrate -- 实际利率
    ,valuedate -- 起息日期
    ,maturitydate -- 到期日期
    ,lastmodified -- 最后变更时间
    ,occuramount -- 发生金额
    ,alterbalance_id_rev -- 上一笔的ALTERBALANCE_ID
    ,rev_flag -- 冲账标志
    ,reservevalue1 -- 备选值1
    ,reservevalue2 -- 备选值2
    ,bidx -- 分录规则分支编号
    ,aondealtype -- 备用字段
    ,chargeexpense -- 
    ,chargeincome -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    baretrade_id -- 引用表ID
    ,baretradename -- 引用表名
    ,alterbalance_id -- 引用表2ID
    ,aspclient_id -- 所属部门ID
    ,keepfolder_id -- 账户ID
    ,stdtrade_id -- 引用表3ID
    ,acccode -- 业务类型代码
    ,assettype -- 资产类别
    ,buztype -- 业务类别
    ,majorassetcode -- 主资产代码
    ,minorassetcode -- 次资产代码
    ,settledate -- 实际收付日期
    ,holdposition -- 持有仓位
    ,holdfaceamount -- 持有面额
    ,cleanpricecost -- 净价成本
    ,interestadjust -- 利息调整
    ,fairvaluealter -- 公允价值变动
    ,interestcost -- 利息成本
    ,dirtypricecost -- 全价成本
    ,impairment -- 减值准备
    ,priceearning -- 价差收益
    ,amortizeearning -- 摊销收益
    ,interestearning -- 利息收益
    ,fairvalueincome -- 公允价值变动损益
    ,impairmentlost -- 减值损失
    ,tradeexpense -- 交易费用
    ,realrate -- 实际利率
    ,valuedate -- 起息日期
    ,maturitydate -- 到期日期
    ,lastmodified -- 最后变更时间
    ,occuramount -- 发生金额
    ,alterbalance_id_rev -- 上一笔的ALTERBALANCE_ID
    ,rev_flag -- 冲账标志
    ,reservevalue1 -- 备选值1
    ,reservevalue2 -- 备选值2
    ,bidx -- 分录规则分支编号
    ,aondealtype -- 备用字段
    ,chargeexpense -- 
    ,chargeincome -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ctms_tbs_v_alterbalance
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ctms_tbs_v_alterbalance exchange partition p_${batch_date} with table ${iol_schema}.ctms_tbs_v_alterbalance_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_alterbalance to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ctms_tbs_v_alterbalance_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_alterbalance',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);