/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_instrument_extend
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
drop table ${iol_schema}.ibms_ttrd_instrument_extend_ex purge;
alter table ${iol_schema}.ibms_ttrd_instrument_extend add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ibms_ttrd_instrument_extend;

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_instrument_extend_ex nologging
compress
as
select * from ${iol_schema}.ibms_ttrd_instrument_extend where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_instrument_extend_ex(
    i_code -- 金融工具代码
    ,a_type -- 资产类型
    ,m_type -- 市场类型
    ,extend_type -- 扩展类型【01：本金序列；02：利率/利差序列；03：债券发行量；04：含权信息】
    ,beg_date -- 生效日期【当扩展类型为04时，表示理论行权日期】
    ,end_date -- 失效日期【当扩展类型为04时，表示理论行权结束日期，且只对美式有效】
    ,rate_multi -- 利率乘数【当扩展类型为02时有效】
    ,volume -- 发生额，根据EXTEND_TYPE类型不同，其含义不同【01：本金；02：利率/利差；03：债券发行量；04：补偿利率】
    ,oe_type -- 含权类型【01：赎回；02：回售】
    ,oe_option_type -- 选择权类型【01：欧式；02：美式；目前国内只有欧式】
    ,oe_finish_date -- 实际行权日期
    ,update_user -- 更新人
    ,update_time -- 更新时间
    ,account_user -- 复核人
    ,account_time -- 复核时间
    ,strike_price -- 行权价格
    ,pipe_id -- 
    ,imp_date -- 
    ,start_date -- 起息日
    ,mtr_date -- 到期日
    ,mtr_date_conv -- 到期日调整规则
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    i_code -- 金融工具代码
    ,a_type -- 资产类型
    ,m_type -- 市场类型
    ,extend_type -- 扩展类型【01：本金序列；02：利率/利差序列；03：债券发行量；04：含权信息】
    ,beg_date -- 生效日期【当扩展类型为04时，表示理论行权日期】
    ,end_date -- 失效日期【当扩展类型为04时，表示理论行权结束日期，且只对美式有效】
    ,rate_multi -- 利率乘数【当扩展类型为02时有效】
    ,volume -- 发生额，根据EXTEND_TYPE类型不同，其含义不同【01：本金；02：利率/利差；03：债券发行量；04：补偿利率】
    ,oe_type -- 含权类型【01：赎回；02：回售】
    ,oe_option_type -- 选择权类型【01：欧式；02：美式；目前国内只有欧式】
    ,oe_finish_date -- 实际行权日期
    ,update_user -- 更新人
    ,update_time -- 更新时间
    ,account_user -- 复核人
    ,account_time -- 复核时间
    ,strike_price -- 行权价格
    ,pipe_id -- 
    ,imp_date -- 
    ,start_date -- 起息日
    ,mtr_date -- 到期日
    ,mtr_date_conv -- 到期日调整规则
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_instrument_extend
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_instrument_extend exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_instrument_extend_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_instrument_extend to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_instrument_extend_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_instrument_extend',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);