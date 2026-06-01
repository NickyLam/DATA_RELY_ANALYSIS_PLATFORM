/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_albs_fxq_blals_all
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
drop table ${iol_schema}.albs_fxq_blals_all_ex purge;
alter table ${iol_schema}.albs_fxq_blals_all add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.albs_fxq_blals_all;

-- 2.3 insert data to ex table
create table ${iol_schema}.albs_fxq_blals_all_ex nologging
compress
as
select * from ${iol_schema}.albs_fxq_blals_all where 0=1;

insert /*+ append */ into ${iol_schema}.albs_fxq_blals_all_ex(
    black_id -- 黑名单编号（在黑名单系统中的唯一主键）
    ,original_id -- 银行家年鉴原始编号（针对数据第三方的唯一编号）
    ,bla_type -- 名单类型1：个体2：组织或实体
    ,bla_type_detail -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织
    ,gender -- 性别1：男2：女0：NONE（空）
    ,is_china_limit -- 是否属于中国制裁1：是0：否
    ,bla_name -- 黑名单名称
    ,bla_identity -- 黑名单证件
    ,source_desc -- 黑名单来源类型
    ,source_program -- 黑名单来源明细
    ,active_date -- 启用日期
    ,input_type -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单
    ,id -- 表主键
    ,blacklist_type -- 黑名单归属类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    black_id -- 黑名单编号（在黑名单系统中的唯一主键）
    ,original_id -- 银行家年鉴原始编号（针对数据第三方的唯一编号）
    ,bla_type -- 名单类型1：个体2：组织或实体
    ,bla_type_detail -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织
    ,gender -- 性别1：男2：女0：NONE（空）
    ,is_china_limit -- 是否属于中国制裁1：是0：否
    ,bla_name -- 黑名单名称
    ,bla_identity -- 黑名单证件
    ,source_desc -- 黑名单来源类型
    ,source_program -- 黑名单来源明细
    ,active_date -- 启用日期
    ,input_type -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单
    ,id -- 表主键
    ,blacklist_type -- 黑名单归属类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.albs_fxq_blals_all
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.albs_fxq_blals_all exchange partition p_${batch_date} with table ${iol_schema}.albs_fxq_blals_all_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.albs_fxq_blals_all to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.albs_fxq_blals_all_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'albs_fxq_blals_all',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);