/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_fund_risk_pct_info_h_ibmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_fund_risk_pct_info_h add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ibmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fund_risk_pct_info_h partition for ('ibmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_tm purge;
drop table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_op purge;
drop table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_tm nologging
compress ${option_switch} for query high
as select
    lp_id -- 法人编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,risk_pct_id -- 风险占比编号
    ,asset_name -- 资产名称
    ,wt -- 权重
    ,pct -- 占比
    ,effect_dt -- 生效日期
    ,effect_flg -- 生效标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fund_risk_pct_info_h partition for ('ibmsf1')
where 0=1
;

create table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fund_risk_pct_info_h partition for ('ibmsf1') where 0=1;

create table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fund_risk_pct_info_h partition for ('ibmsf1') where 0=1;

-- 3.1 get new data into table
-- ibms_ttrd_risk_weight_proportion-1
insert into ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_tm(
    lp_id -- 法人编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,risk_pct_id -- 风险占比编号
    ,asset_name -- 资产名称
    ,wt -- 权重
    ,pct -- 占比
    ,effect_dt -- 生效日期
    ,effect_flg -- 生效标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '9999' -- 法人编号
    ,P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,P1.RISK_ID -- 风险占比编号
    ,P2.RISK_DETAIL -- 资产名称
    ,P2.WEIGHT -- 权重
    ,P1.PROPORTION -- 占比
    ,${iml_schema}.DATEFORMAT_MAX2(P1.EFFECTIVE_TIME) -- 生效日期
    ,NVL(TRIM(P1.STATUS),'-') -- 生效标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_risk_weight_proportion' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_risk_weight_proportion p1
    left join ${iol_schema}.ibms_ttrd_risk_weight_ratio p2 on P1.RISK_ID = P2.ID
AND P2.START_DT <= to_date('${batch_date}','yyyymmdd') 
AND P2.END_DT > to_date('${batch_date}','yyyymmdd') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND P1.IS_CURRENT='1'
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_tm 
  	                                group by 
  	                                        lp_id
  	                                        ,fin_instm_id
  	                                        ,asset_type_id
  	                                        ,market_type_id
  	                                        ,risk_pct_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_cl(
            lp_id -- 法人编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,risk_pct_id -- 风险占比编号
    ,asset_name -- 资产名称
    ,wt -- 权重
    ,pct -- 占比
    ,effect_dt -- 生效日期
    ,effect_flg -- 生效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_op(
            lp_id -- 法人编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,risk_pct_id -- 风险占比编号
    ,asset_name -- 资产名称
    ,wt -- 权重
    ,pct -- 占比
    ,effect_dt -- 生效日期
    ,effect_flg -- 生效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.fin_instm_id, o.fin_instm_id) as fin_instm_id -- 金融工具编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.risk_pct_id, o.risk_pct_id) as risk_pct_id -- 风险占比编号
    ,nvl(n.asset_name, o.asset_name) as asset_name -- 资产名称
    ,nvl(n.wt, o.wt) as wt -- 权重
    ,nvl(n.pct, o.pct) as pct -- 占比
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.effect_flg, o.effect_flg) as effect_flg -- 生效标志
    ,case when
            n.lp_id is null
            and n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.risk_pct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lp_id is null
            and n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.risk_pct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lp_id is null
            and n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.risk_pct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_tm n
    full join (select * from ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.lp_id = n.lp_id
            and o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.risk_pct_id = n.risk_pct_id
where (
        o.lp_id is null
        and o.fin_instm_id is null
        and o.asset_type_id is null
        and o.market_type_id is null
        and o.risk_pct_id is null
    )
    or (
        n.lp_id is null
        and n.fin_instm_id is null
        and n.asset_type_id is null
        and n.market_type_id is null
        and n.risk_pct_id is null
    )
    or (
        o.asset_name <> n.asset_name
        or o.wt <> n.wt
        or o.pct <> n.pct
        or o.effect_dt <> n.effect_dt
        or o.effect_flg <> n.effect_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_cl(
            lp_id -- 法人编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,risk_pct_id -- 风险占比编号
    ,asset_name -- 资产名称
    ,wt -- 权重
    ,pct -- 占比
    ,effect_dt -- 生效日期
    ,effect_flg -- 生效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_op(
            lp_id -- 法人编号
    ,fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,risk_pct_id -- 风险占比编号
    ,asset_name -- 资产名称
    ,wt -- 权重
    ,pct -- 占比
    ,effect_dt -- 生效日期
    ,effect_flg -- 生效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.lp_id -- 法人编号
    ,o.fin_instm_id -- 金融工具编号
    ,o.asset_type_id -- 资产类型编号
    ,o.market_type_id -- 市场类型编号
    ,o.risk_pct_id -- 风险占比编号
    ,o.asset_name -- 资产名称
    ,o.wt -- 权重
    ,o.pct -- 占比
    ,o.effect_dt -- 生效日期
    ,o.effect_flg -- 生效标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_bk o
    left join ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_op n
        on
            o.lp_id = n.lp_id
            and o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.risk_pct_id = n.risk_pct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_cl d
        on
            o.lp_id = d.lp_id
            and o.fin_instm_id = d.fin_instm_id
            and o.asset_type_id = d.asset_type_id
            and o.market_type_id = d.market_type_id
            and o.risk_pct_id = d.risk_pct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_fund_risk_pct_info_h;
alter table ${iml_schema}.prd_fund_risk_pct_info_h truncate partition for ('ibmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_fund_risk_pct_info_h exchange subpartition p_ibmsf1_19000101 with table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_cl;
alter table ${iml_schema}.prd_fund_risk_pct_info_h exchange subpartition p_ibmsf1_20991231 with table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_fund_risk_pct_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_tm purge;
drop table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_op purge;
drop table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_fund_risk_pct_info_h_ibmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_fund_risk_pct_info_h', partname => 'p_ibmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
