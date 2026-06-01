/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_pledgebond
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
drop table ${iol_schema}.ibms_ttrd_pledgebond_ex purge;
alter table ${iol_schema}.ibms_ttrd_pledgebond add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ibms_ttrd_pledgebond;

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_pledgebond_ex nologging
compress
as
select * from ${iol_schema}.ibms_ttrd_pledgebond where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_pledgebond_ex(
    i_code -- 金融工具代码 关联交易表TTRD_OTC_TRADE INTORDID字段 或关联审批表TTRD_OTC_ORDER  INTORDID字段
    ,a_type -- 资产类型
    ,m_type -- 市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
    ,p_i_code -- 质押券金融工具
    ,p_m_type -- XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
    ,p_a_type -- 资产类型
    ,amount -- 质押券面额
    ,discount -- 折价率
    ,disamount -- 折价金额
    ,partytype -- 1-本方 ; 0-对手方
    ,resertype -- 1-质押券 ; 0-保证券
    ,evalfullprice -- 中债估值（全价）
    ,volume -- 余额数量变动
    ,secu_acct_id -- 内部证券账户ID
    ,ext_secu_acct_id -- 外部证券账户ID
    ,trade_grp_id -- 核算交易组合
    ,sort -- 排序序号
    ,si_id -- 
    ,sysordid -- 交易序号
    ,demo -- 备注
    ,trd_alt_mark -- 新旧交替标识 默认为0，新券1老券-1
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    i_code -- 金融工具代码 关联交易表TTRD_OTC_TRADE INTORDID字段 或关联审批表TTRD_OTC_ORDER  INTORDID字段
    ,a_type -- 资产类型
    ,m_type -- 市场类型 XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
    ,p_i_code -- 质押券金融工具
    ,p_m_type -- XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
    ,p_a_type -- 资产类型
    ,amount -- 质押券面额
    ,discount -- 折价率
    ,disamount -- 折价金额
    ,partytype -- 1-本方 ; 0-对手方
    ,resertype -- 1-质押券 ; 0-保证券
    ,evalfullprice -- 中债估值（全价）
    ,volume -- 余额数量变动
    ,secu_acct_id -- 内部证券账户ID
    ,ext_secu_acct_id -- 外部证券账户ID
    ,trade_grp_id -- 核算交易组合
    ,sort -- 排序序号
    ,si_id -- 
    ,sysordid -- 交易序号
    ,demo -- 备注
    ,trd_alt_mark -- 新旧交替标识 默认为0，新券1老券-1
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_pledgebond
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_pledgebond exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_pledgebond_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_pledgebond to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_pledgebond_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_pledgebond',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);