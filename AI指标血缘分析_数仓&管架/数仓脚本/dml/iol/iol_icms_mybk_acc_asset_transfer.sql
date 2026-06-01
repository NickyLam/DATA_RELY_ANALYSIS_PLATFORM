/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybk_acc_asset_transfer
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
drop table ${iol_schema}.icms_mybk_acc_asset_transfer_ex purge;
alter table ${iol_schema}.icms_mybk_acc_asset_transfer add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.icms_mybk_acc_asset_transfer truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_mybk_acc_asset_transfer_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybk_acc_asset_transfer where 0=1;

insert /*+ append */ into ${iol_schema}.icms_mybk_acc_asset_transfer_ex(
    termno -- 期次号，从1开始
    ,settledate -- 业务日期，格式：YYYYMMDD
    ,seqno -- 资产转让业务流水号
    ,fundseqno -- 资金流水号,可以关联网商银行资金对账文件的td_sub_detail字段
    ,enddate -- 分期结束日期，也是当期的还款日，格式：yyyyMMdd
    ,ovdprinpnltbal -- 逾期本金罚息余额（单位分），指的是已结的应收未收逾本罚
    ,regioncode -- 行政区划
    ,migtflag -- 迁移标志：crsrcrilcupl
    ,prinbal -- 本金余额（单位分）
    ,accruedstatus -- 应计非应计标识，应计0，非应计1
    ,ovdintpnltbal -- 逾期利息罚息余额（单位分），指的是应收未收逾利罚
    ,diffamt -- 作价资产余额和转让金额之间的差价
    ,intbal -- 利息余额（单位分），指的是已结的应收未收利息和未到期的计提利息
    ,contractno -- 平台贷款合同号
    ,status -- 分期状态，正常NORMAL,逾期OVD
    ,opstorg -- 资产转让交易对手机构
    ,opttype -- 操作类型，转出（OUT）\转入（IN）
    ,fvtpltag -- 平价和折溢价转让为N，净值回购为Y
    ,transtime -- 交易时间，格式：yyyy-MM-ddHH:mm:ss
    ,startdate -- 分期开始日期，格式：yyyyMMdd
    ,clearingamt -- 转让金额（单位分）
    ,bsntype -- 产品业务类型，具体值合作产品上线后才给出
    ,writeoff -- 核销标识，已核销为Y，否则为N
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    termno -- 期次号，从1开始
    ,settledate -- 业务日期，格式：YYYYMMDD
    ,seqno -- 资产转让业务流水号
    ,fundseqno -- 资金流水号,可以关联网商银行资金对账文件的td_sub_detail字段
    ,enddate -- 分期结束日期，也是当期的还款日，格式：yyyyMMdd
    ,ovdprinpnltbal -- 逾期本金罚息余额（单位分），指的是已结的应收未收逾本罚
    ,regioncode -- 行政区划
    ,migtflag -- 迁移标志：crsrcrilcupl
    ,prinbal -- 本金余额（单位分）
    ,accruedstatus -- 应计非应计标识，应计0，非应计1
    ,ovdintpnltbal -- 逾期利息罚息余额（单位分），指的是应收未收逾利罚
    ,diffamt -- 作价资产余额和转让金额之间的差价
    ,intbal -- 利息余额（单位分），指的是已结的应收未收利息和未到期的计提利息
    ,contractno -- 平台贷款合同号
    ,status -- 分期状态，正常NORMAL,逾期OVD
    ,opstorg -- 资产转让交易对手机构
    ,opttype -- 操作类型，转出（OUT）\转入（IN）
    ,fvtpltag -- 平价和折溢价转让为N，净值回购为Y
    ,transtime -- 交易时间，格式：yyyy-MM-ddHH:mm:ss
    ,startdate -- 分期开始日期，格式：yyyyMMdd
    ,clearingamt -- 转让金额（单位分）
    ,bsntype -- 产品业务类型，具体值合作产品上线后才给出
    ,writeoff -- 核销标识，已核销为Y，否则为N
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_mybk_acc_asset_transfer
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_mybk_acc_asset_transfer exchange partition p_${batch_date} with table ${iol_schema}.icms_mybk_acc_asset_transfer_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybk_acc_asset_transfer to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_mybk_acc_asset_transfer_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybk_acc_asset_transfer',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);