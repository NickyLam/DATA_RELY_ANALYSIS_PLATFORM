/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_albs_fxq_blals_all
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_albs_fxq_blals_all drop partition p_${last_date};
alter table ${idl_schema}.aml_albs_fxq_blals_all drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_albs_fxq_blals_all add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_albs_fxq_blals_all (
    etl_dt  -- 数据日期
    ,black_id  -- 黑名单编号（在黑名单系统中的唯一主键）
    ,original_id  -- 银行家年鉴原始编号（针对数据第三方的唯一编号）
    ,bla_type  -- 名单类型1：个体2：组织或实体
    ,bla_type_detail  -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织
    ,gender  -- 性别1：男2：女0：NONE（空）
    ,is_china_limit  -- 是否属于中国制裁1：是0：否
    ,bla_name  -- 黑名单名称
    ,bla_identity  -- 黑名单证件
    ,source_desc  -- 黑名单来源类型
    ,source_program  -- 黑名单来源明细
    ,active_date  -- 启用日期
    ,input_type  -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单
    ,id             -- 表主键    
    ,blacklist_type -- 黑名单归属类型
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.black_id,chr(13),''),chr(10),'')  -- 黑名单编号（在黑名单系统中的唯一主键）
    ,replace(replace(t1.original_id,chr(13),''),chr(10),'')  -- 银行家年鉴原始编号（针对数据第三方的唯一编号）
    ,replace(replace(t1.bla_type,chr(13),''),chr(10),'')  -- 名单类型1：个体2：组织或实体
    ,replace(replace(t1.bla_type_detail,chr(13),''),chr(10),'')  -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织
    ,replace(replace(t1.gender,chr(13),''),chr(10),'')  -- 性别1：男2：女0：NONE（空）
    ,replace(replace(t1.is_china_limit,chr(13),''),chr(10),'')  -- 是否属于中国制裁1：是0：否
    ,replace(replace(t1.bla_name,chr(13),''),chr(10),'')  -- 黑名单名称
    ,replace(replace(t1.bla_identity,chr(13),''),chr(10),'')  -- 黑名单证件
    ,replace(replace(t1.source_desc,chr(13),''),chr(10),'')  -- 黑名单来源类型
    ,replace(replace(t1.source_program,chr(13),''),chr(10),'')  -- 黑名单来源明细
    ,replace(replace(t1.active_date,chr(13),''),chr(10),'')  -- 启用日期
    ,replace(replace(t1.input_type,chr(13),''),chr(10),'')  -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单
    ,replace(replace(t1.id,chr(13),''),chr(10),'')              -- 表主键
    ,replace(replace(t1.blacklist_type,chr(13),''),chr(10),'')  -- 黑名单归属类型
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.albs_fxq_blals_all t1    --黑名单表
where etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_albs_fxq_blals_all',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);