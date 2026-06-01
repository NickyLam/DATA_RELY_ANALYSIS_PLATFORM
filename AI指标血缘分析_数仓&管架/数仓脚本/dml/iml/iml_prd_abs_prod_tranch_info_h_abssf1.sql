/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_abs_prod_tranch_info_h_abssf1
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
alter table ${iml_schema}.prd_abs_prod_tranch_info_h add partition p_abssf1 values ('abssf1')(
        subpartition p_abssf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_abssf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_abs_prod_tranch_info_h partition for ('abssf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_tm purge;
drop table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_op purge;
drop table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_tm nologging
compress ${option_switch} for query high
as select
    tranch_id -- 分档编号
    ,lp_id -- 法人编号
    ,abs_prod_id -- ABS产品编号
    ,tranch_type_cd -- 分档类型代码
    ,tranch_name -- 分档名称
    ,curr_cd -- 币种代码
    ,tranch_amt_pct -- 分档金额占比
    ,tranch_amt -- 分档金额
    ,self_hold_ratio -- 自持比例
    ,rating_cd_1 -- 评级代码1
    ,rating_org_id_1 -- 评级机构编号1
    ,rating_cd_2 -- 评级代码2
    ,rating_org_id_2 -- 评级机构编号2
    ,exch_serv_fee -- 兑换服务费
    ,ts_flg -- 暂存标志
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_abs_prod_tranch_info_h partition for ('abssf1')
where 0=1
;

create table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_abs_prod_tranch_info_h partition for ('abssf1') where 0=1;

create table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_abs_prod_tranch_info_h partition for ('abssf1') where 0=1;

-- 3.1 get new data into table
-- abss_abs_product_tranche-
insert into ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_tm(
    tranch_id -- 分档编号
    ,lp_id -- 法人编号
    ,abs_prod_id -- ABS产品编号
    ,tranch_type_cd -- 分档类型代码
    ,tranch_name -- 分档名称
    ,curr_cd -- 币种代码
    ,tranch_amt_pct -- 分档金额占比
    ,tranch_amt -- 分档金额
    ,self_hold_ratio -- 自持比例
    ,rating_cd_1 -- 评级代码1
    ,rating_org_id_1 -- 评级机构编号1
    ,rating_cd_2 -- 评级代码2
    ,rating_org_id_2 -- 评级机构编号2
    ,exch_serv_fee -- 兑换服务费
    ,ts_flg -- 暂存标志
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.TRANCHEID -- 分档编号
    ,'9999' -- 法人编号
    ,P1.PRODUCTID -- ABS产品编号
    ,nvl(trim(P1.TRANCHETYPE),'00') -- 分档类型代码
    ,P1.TRANCHENAME -- 分档名称
    ,P1.CURRENCY -- 币种代码
    ,P1.TRANCHEAMOUNTRATIO -- 分档金额占比
    ,P1.TRANCHEAMOUNT -- 分档金额
    ,P1.SELFHOLDRATIO -- 自持比例
    ,nvl(trim(P1.RATINGLEVEL1),'00') -- 评级代码1
    ,P1.RATINGAGENCY1 -- 评级机构编号1
    ,nvl(trim(P1.RATINGLEVEL2),'00') -- 评级代码2
    ,P1.RATINGAGENCY2 -- 评级机构编号2
    ,P1.EXCHANGESERVICEFEE -- 兑换服务费
    ,P1.TEMPSAVEFLAG -- 暂存标志
    ,${iml_schema}.dateformat_min(P1.BEGINDATE) -- 生效日期
    ,${iml_schema}.dateformat_max(P1.MATURITY) -- 到期日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'abss_abs_product_tranche' -- 源表名称
    ,'abssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.abss_abs_product_tranche p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_cl(
            tranch_id -- 分档编号
    ,lp_id -- 法人编号
    ,abs_prod_id -- ABS产品编号
    ,tranch_type_cd -- 分档类型代码
    ,tranch_name -- 分档名称
    ,curr_cd -- 币种代码
    ,tranch_amt_pct -- 分档金额占比
    ,tranch_amt -- 分档金额
    ,self_hold_ratio -- 自持比例
    ,rating_cd_1 -- 评级代码1
    ,rating_org_id_1 -- 评级机构编号1
    ,rating_cd_2 -- 评级代码2
    ,rating_org_id_2 -- 评级机构编号2
    ,exch_serv_fee -- 兑换服务费
    ,ts_flg -- 暂存标志
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_op(
            tranch_id -- 分档编号
    ,lp_id -- 法人编号
    ,abs_prod_id -- ABS产品编号
    ,tranch_type_cd -- 分档类型代码
    ,tranch_name -- 分档名称
    ,curr_cd -- 币种代码
    ,tranch_amt_pct -- 分档金额占比
    ,tranch_amt -- 分档金额
    ,self_hold_ratio -- 自持比例
    ,rating_cd_1 -- 评级代码1
    ,rating_org_id_1 -- 评级机构编号1
    ,rating_cd_2 -- 评级代码2
    ,rating_org_id_2 -- 评级机构编号2
    ,exch_serv_fee -- 兑换服务费
    ,ts_flg -- 暂存标志
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tranch_id, o.tranch_id) as tranch_id -- 分档编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.abs_prod_id, o.abs_prod_id) as abs_prod_id -- ABS产品编号
    ,nvl(n.tranch_type_cd, o.tranch_type_cd) as tranch_type_cd -- 分档类型代码
    ,nvl(n.tranch_name, o.tranch_name) as tranch_name -- 分档名称
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tranch_amt_pct, o.tranch_amt_pct) as tranch_amt_pct -- 分档金额占比
    ,nvl(n.tranch_amt, o.tranch_amt) as tranch_amt -- 分档金额
    ,nvl(n.self_hold_ratio, o.self_hold_ratio) as self_hold_ratio -- 自持比例
    ,nvl(n.rating_cd_1, o.rating_cd_1) as rating_cd_1 -- 评级代码1
    ,nvl(n.rating_org_id_1, o.rating_org_id_1) as rating_org_id_1 -- 评级机构编号1
    ,nvl(n.rating_cd_2, o.rating_cd_2) as rating_cd_2 -- 评级代码2
    ,nvl(n.rating_org_id_2, o.rating_org_id_2) as rating_org_id_2 -- 评级机构编号2
    ,nvl(n.exch_serv_fee, o.exch_serv_fee) as exch_serv_fee -- 兑换服务费
    ,nvl(n.ts_flg, o.ts_flg) as ts_flg -- 暂存标志
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,case when
            n.tranch_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tranch_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tranch_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_tm n
    full join (select * from ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.tranch_id = n.tranch_id
            and o.lp_id = n.lp_id
where (
        o.tranch_id is null
        and o.lp_id is null
    )
    or (
        n.tranch_id is null
        and n.lp_id is null
    )
    or (
        o.abs_prod_id <> n.abs_prod_id
        or o.tranch_type_cd <> n.tranch_type_cd
        or o.tranch_name <> n.tranch_name
        or o.curr_cd <> n.curr_cd
        or o.tranch_amt_pct <> n.tranch_amt_pct
        or o.tranch_amt <> n.tranch_amt
        or o.self_hold_ratio <> n.self_hold_ratio
        or o.rating_cd_1 <> n.rating_cd_1
        or o.rating_org_id_1 <> n.rating_org_id_1
        or o.rating_cd_2 <> n.rating_cd_2
        or o.rating_org_id_2 <> n.rating_org_id_2
        or o.exch_serv_fee <> n.exch_serv_fee
        or o.ts_flg <> n.ts_flg
        or o.effect_dt <> n.effect_dt
        or o.exp_dt <> n.exp_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_cl(
            tranch_id -- 分档编号
    ,lp_id -- 法人编号
    ,abs_prod_id -- ABS产品编号
    ,tranch_type_cd -- 分档类型代码
    ,tranch_name -- 分档名称
    ,curr_cd -- 币种代码
    ,tranch_amt_pct -- 分档金额占比
    ,tranch_amt -- 分档金额
    ,self_hold_ratio -- 自持比例
    ,rating_cd_1 -- 评级代码1
    ,rating_org_id_1 -- 评级机构编号1
    ,rating_cd_2 -- 评级代码2
    ,rating_org_id_2 -- 评级机构编号2
    ,exch_serv_fee -- 兑换服务费
    ,ts_flg -- 暂存标志
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_op(
            tranch_id -- 分档编号
    ,lp_id -- 法人编号
    ,abs_prod_id -- ABS产品编号
    ,tranch_type_cd -- 分档类型代码
    ,tranch_name -- 分档名称
    ,curr_cd -- 币种代码
    ,tranch_amt_pct -- 分档金额占比
    ,tranch_amt -- 分档金额
    ,self_hold_ratio -- 自持比例
    ,rating_cd_1 -- 评级代码1
    ,rating_org_id_1 -- 评级机构编号1
    ,rating_cd_2 -- 评级代码2
    ,rating_org_id_2 -- 评级机构编号2
    ,exch_serv_fee -- 兑换服务费
    ,ts_flg -- 暂存标志
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tranch_id -- 分档编号
    ,o.lp_id -- 法人编号
    ,o.abs_prod_id -- ABS产品编号
    ,o.tranch_type_cd -- 分档类型代码
    ,o.tranch_name -- 分档名称
    ,o.curr_cd -- 币种代码
    ,o.tranch_amt_pct -- 分档金额占比
    ,o.tranch_amt -- 分档金额
    ,o.self_hold_ratio -- 自持比例
    ,o.rating_cd_1 -- 评级代码1
    ,o.rating_org_id_1 -- 评级机构编号1
    ,o.rating_cd_2 -- 评级代码2
    ,o.rating_org_id_2 -- 评级机构编号2
    ,o.exch_serv_fee -- 兑换服务费
    ,o.ts_flg -- 暂存标志
    ,o.effect_dt -- 生效日期
    ,o.exp_dt -- 到期日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_bk o
    left join ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_op n
        on
            o.tranch_id = n.tranch_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_cl d
        on
            o.tranch_id = d.tranch_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_abs_prod_tranch_info_h;
alter table ${iml_schema}.prd_abs_prod_tranch_info_h truncate partition for ('abssf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_abs_prod_tranch_info_h exchange subpartition p_abssf1_19000101 with table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_cl;
alter table ${iml_schema}.prd_abs_prod_tranch_info_h exchange subpartition p_abssf1_20991231 with table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_abs_prod_tranch_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_tm purge;
drop table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_op purge;
drop table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_abs_prod_tranch_info_h_abssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_abs_prod_tranch_info_h', partname => 'p_abssf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
