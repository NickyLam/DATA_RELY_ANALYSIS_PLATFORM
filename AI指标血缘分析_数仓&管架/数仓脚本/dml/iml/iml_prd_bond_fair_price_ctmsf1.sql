/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_bond_fair_price_ctmsf1
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
alter table ${iml_schema}.prd_bond_fair_price add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ctmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_bond_fair_price_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_fair_price partition for ('ctmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_bond_fair_price_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_fair_price_ctmsf1_op purge;
drop table ${iml_schema}.prd_bond_fair_price_ctmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_fair_price_ctmsf1_tm nologging
compress ${option_switch} for query high
as select
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,price_dt -- 价格日期
    ,tran_market_name -- 交易市场名称
    ,surp_tenor -- 剩余期限
    ,recmd_flg -- 推荐标志
    ,full_price -- 全价
    ,net_price -- 净价
    ,exp_yld_rat -- 到期收益率
    ,duran -- 久期
    ,coret_duran -- 修正久期
    ,valid_flg -- 有效标志
    ,acru_int -- 应计利息
    ,end_day_full_price -- 日终全价
    ,estim_yld_rat -- 估价收益率
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_fair_price partition for ('ctmsf1')
where 0=1
;

create table ${iml_schema}.prd_bond_fair_price_ctmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_fair_price partition for ('ctmsf1') where 0=1;

create table ${iml_schema}.prd_bond_fair_price_ctmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_fair_price partition for ('ctmsf1') where 0=1;

-- 3.1 get new data into table
-- ctms_tbs_v_cdc_fp-
insert into ${iml_schema}.prd_bond_fair_price_ctmsf1_tm(
    bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,price_dt -- 价格日期
    ,tran_market_name -- 交易市场名称
    ,surp_tenor -- 剩余期限
    ,recmd_flg -- 推荐标志
    ,full_price -- 全价
    ,net_price -- 净价
    ,exp_yld_rat -- 到期收益率
    ,duran -- 久期
    ,coret_duran -- 修正久期
    ,valid_flg -- 有效标志
    ,acru_int -- 应计利息
    ,end_day_full_price -- 日终全价
    ,estim_yld_rat -- 估价收益率
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SECURITY_CODE -- 债券编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.PRICING_DATE) -- 价格日期
    ,P1.MARKET -- 交易市场名称
    ,P1.TTM -- 剩余期限
    ,P1.RELIABILITY -- 推荐标志
    ,P1.DP -- 全价
    ,P1.CP -- 净价
    ,P1.YIELD -- 到期收益率
    ,P1.DURATION -- 久期
    ,P1.MDURATION -- 修正久期
    ,P1.VALID -- 有效标志
    ,P1.AI -- 应计利息
    ,P1.END_DP -- 日终全价
    ,P1.CDC_YIELD -- 估价收益率
    ,P1.CDC_MD -- 估价修正久期
    ,P1.CDC_CONVEXITY -- 估价凸性
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_cdc_fp' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_cdc_fp p1
where  1 = 1 
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_bond_fair_price_ctmsf1_cl(
            bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,price_dt -- 价格日期
    ,tran_market_name -- 交易市场名称
    ,surp_tenor -- 剩余期限
    ,recmd_flg -- 推荐标志
    ,full_price -- 全价
    ,net_price -- 净价
    ,exp_yld_rat -- 到期收益率
    ,duran -- 久期
    ,coret_duran -- 修正久期
    ,valid_flg -- 有效标志
    ,acru_int -- 应计利息
    ,end_day_full_price -- 日终全价
    ,estim_yld_rat -- 估价收益率
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_bond_fair_price_ctmsf1_op(
            bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,price_dt -- 价格日期
    ,tran_market_name -- 交易市场名称
    ,surp_tenor -- 剩余期限
    ,recmd_flg -- 推荐标志
    ,full_price -- 全价
    ,net_price -- 净价
    ,exp_yld_rat -- 到期收益率
    ,duran -- 久期
    ,coret_duran -- 修正久期
    ,valid_flg -- 有效标志
    ,acru_int -- 应计利息
    ,end_day_full_price -- 日终全价
    ,estim_yld_rat -- 估价收益率
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bond_id, o.bond_id) as bond_id -- 债券编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.price_dt, o.price_dt) as price_dt -- 价格日期
    ,nvl(n.tran_market_name, o.tran_market_name) as tran_market_name -- 交易市场名称
    ,nvl(n.surp_tenor, o.surp_tenor) as surp_tenor -- 剩余期限
    ,nvl(n.recmd_flg, o.recmd_flg) as recmd_flg -- 推荐标志
    ,nvl(n.full_price, o.full_price) as full_price -- 全价
    ,nvl(n.net_price, o.net_price) as net_price -- 净价
    ,nvl(n.exp_yld_rat, o.exp_yld_rat) as exp_yld_rat -- 到期收益率
    ,nvl(n.duran, o.duran) as duran -- 久期
    ,nvl(n.coret_duran, o.coret_duran) as coret_duran -- 修正久期
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.acru_int, o.acru_int) as acru_int -- 应计利息
    ,nvl(n.end_day_full_price, o.end_day_full_price) as end_day_full_price -- 日终全价
    ,nvl(n.estim_yld_rat, o.estim_yld_rat) as estim_yld_rat -- 估价收益率
    ,nvl(n.estim_coret_duran, o.estim_coret_duran) as estim_coret_duran -- 估价修正久期
    ,nvl(n.estim_cvty, o.estim_cvty) as estim_cvty -- 估价凸性
    ,case when
            n.bond_id is null
            and n.lp_id is null
            and n.price_dt is null
            and n.tran_market_name is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bond_id is null
            and n.lp_id is null
            and n.price_dt is null
            and n.tran_market_name is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bond_id is null
            and n.lp_id is null
            and n.price_dt is null
            and n.tran_market_name is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_fair_price_ctmsf1_tm n
    full join (select * from ${iml_schema}.prd_bond_fair_price_ctmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.bond_id = n.bond_id
            and o.lp_id = n.lp_id
            and o.price_dt = n.price_dt
            and o.tran_market_name = n.tran_market_name
where (
        o.bond_id is null
        and o.lp_id is null
        and o.price_dt is null
        and o.tran_market_name is null
    )
    or (
        n.bond_id is null
        and n.lp_id is null
        and n.price_dt is null
        and n.tran_market_name is null
    )
    or (
        o.surp_tenor <> n.surp_tenor
        or o.recmd_flg <> n.recmd_flg
        or o.full_price <> n.full_price
        or o.net_price <> n.net_price
        or o.exp_yld_rat <> n.exp_yld_rat
        or o.duran <> n.duran
        or o.coret_duran <> n.coret_duran
        or o.valid_flg <> n.valid_flg
        or o.acru_int <> n.acru_int
        or o.end_day_full_price <> n.end_day_full_price
        or o.estim_yld_rat <> n.estim_yld_rat
        or o.estim_coret_duran <> n.estim_coret_duran
        or o.estim_cvty <> n.estim_cvty
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_bond_fair_price_ctmsf1_cl(
            bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,price_dt -- 价格日期
    ,tran_market_name -- 交易市场名称
    ,surp_tenor -- 剩余期限
    ,recmd_flg -- 推荐标志
    ,full_price -- 全价
    ,net_price -- 净价
    ,exp_yld_rat -- 到期收益率
    ,duran -- 久期
    ,coret_duran -- 修正久期
    ,valid_flg -- 有效标志
    ,acru_int -- 应计利息
    ,end_day_full_price -- 日终全价
    ,estim_yld_rat -- 估价收益率
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_bond_fair_price_ctmsf1_op(
            bond_id -- 债券编号
    ,lp_id -- 法人编号
    ,price_dt -- 价格日期
    ,tran_market_name -- 交易市场名称
    ,surp_tenor -- 剩余期限
    ,recmd_flg -- 推荐标志
    ,full_price -- 全价
    ,net_price -- 净价
    ,exp_yld_rat -- 到期收益率
    ,duran -- 久期
    ,coret_duran -- 修正久期
    ,valid_flg -- 有效标志
    ,acru_int -- 应计利息
    ,end_day_full_price -- 日终全价
    ,estim_yld_rat -- 估价收益率
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bond_id -- 债券编号
    ,o.lp_id -- 法人编号
    ,o.price_dt -- 价格日期
    ,o.tran_market_name -- 交易市场名称
    ,o.surp_tenor -- 剩余期限
    ,o.recmd_flg -- 推荐标志
    ,o.full_price -- 全价
    ,o.net_price -- 净价
    ,o.exp_yld_rat -- 到期收益率
    ,o.duran -- 久期
    ,o.coret_duran -- 修正久期
    ,o.valid_flg -- 有效标志
    ,o.acru_int -- 应计利息
    ,o.end_day_full_price -- 日终全价
    ,o.estim_yld_rat -- 估价收益率
    ,o.estim_coret_duran -- 估价修正久期
    ,o.estim_cvty -- 估价凸性
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_fair_price_ctmsf1_bk o
    left join ${iml_schema}.prd_bond_fair_price_ctmsf1_op n
        on
            o.bond_id = n.bond_id
            and o.lp_id = n.lp_id
            and o.price_dt = n.price_dt
            and o.tran_market_name = n.tran_market_name
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_bond_fair_price_ctmsf1_cl d
        on
            o.bond_id = d.bond_id
            and o.lp_id = d.lp_id
            and o.price_dt = d.price_dt
            and o.tran_market_name = d.tran_market_name
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_bond_fair_price;
alter table ${iml_schema}.prd_bond_fair_price truncate partition for ('ctmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_bond_fair_price exchange subpartition p_ctmsf1_19000101 with table ${iml_schema}.prd_bond_fair_price_ctmsf1_cl;
alter table ${iml_schema}.prd_bond_fair_price exchange subpartition p_ctmsf1_20991231 with table ${iml_schema}.prd_bond_fair_price_ctmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_bond_fair_price to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_bond_fair_price_ctmsf1_tm purge;
drop table ${iml_schema}.prd_bond_fair_price_ctmsf1_op purge;
drop table ${iml_schema}.prd_bond_fair_price_ctmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_bond_fair_price_ctmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_bond_fair_price', partname => 'p_ctmsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
