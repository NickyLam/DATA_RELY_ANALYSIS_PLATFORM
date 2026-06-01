/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_trust_day_sell_h_trusi1
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
alter table ${iml_schema}.prd_trust_day_sell_h add partition p_trusi1 values ('trusi1')(
        subpartition p_trusi1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_trusi1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_trust_day_sell_h_trusi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_trust_day_sell_h partition for ('trusi1')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_trust_day_sell_h_trusi1_tm purge;
drop table ${iml_schema}.prd_trust_day_sell_h_trusi1_op purge;
drop table ${iml_schema}.prd_trust_day_sell_h_trusi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_trust_day_sell_h_trusi1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,issue_dt -- 发布日期
    ,prod_size -- 产品规模
    ,lot -- 份额
    ,td_add_lot -- 当日增加份额
    ,td_decrs_lot -- 当日减少份额
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,aual_yld -- 年化收益率
    ,prod_prft -- 产品收益
    ,ten_thous_corp_prft -- 万份单位收益
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_prod_status_cd -- 上日产品状态代码
    ,prod_acm_nv -- 产品累计净值
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_trust_day_sell_h partition for ('trusi1')
where 0=1
;

create table ${iml_schema}.prd_trust_day_sell_h_trusi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_trust_day_sell_h partition for ('trusi1') where 0=1;

create table ${iml_schema}.prd_trust_day_sell_h_trusi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_trust_day_sell_h partition for ('trusi1') where 0=1;

-- 3.1 get new data into table
-- nfss_tcs_tbprddaily-
insert into ${iml_schema}.prd_trust_day_sell_h_trusi1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,issue_dt -- 发布日期
    ,prod_size -- 产品规模
    ,lot -- 份额
    ,td_add_lot -- 当日增加份额
    ,td_decrs_lot -- 当日减少份额
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,aual_yld -- 年化收益率
    ,prod_prft -- 产品收益
    ,ten_thous_corp_prft -- 万份单位收益
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_prod_status_cd -- 上日产品状态代码
    ,prod_acm_nv -- 产品累计净值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223009'||P1.PRD_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,NVL(TRIM(P1.TA_CODE),'-') -- TA代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.ISS_DATE) -- 发布日期
    ,P1.PRD_SCALE -- 产品规模
    ,P1.TOT_VOL -- 份额
    ,P1.INCREASE_VOL -- 当日增加份额
    ,P1.REDUCE_VOL -- 当日减少份额
    ,P1.NAV -- 产品净值
    ,P1.FACE_VALUE -- 产品面值
    ,P1.INCOME_RATE -- 年化收益率
    ,P1.INCOME -- 产品收益
    ,P1.INCOME_UNIT -- 万份单位收益
    ,NVL(TRIM(P1.CONV_FLAG),'-') -- 收益分配标志
    ,P1.CONV_FLAG -- 转换标志
    ,P1.STATUS -- 状态代码
    ,P1.LAST_STATUS -- 上日产品状态代码
    ,P1.TOT_NAV -- 产品累计净值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tcs_tbprddaily' -- 源表名称
    ,'trusi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tcs_tbprddaily p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND (CFM_DATE = '${batch_date}' OR (CFM_DATE ='20190102' AND ISS_DATE = '${batch_date}'))
;
commit;


commit;


whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_trust_day_sell_h_trusi1_tm 
  	                                group by 
  	                                        prod_id
  	                                        ,lp_id
  	                                        ,issue_dt
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

-- 3.2 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.prd_trust_day_sell_h_trusi1_op(
        prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,issue_dt -- 发布日期
    ,prod_size -- 产品规模
    ,lot -- 份额
    ,td_add_lot -- 当日增加份额
    ,td_decrs_lot -- 当日减少份额
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,aual_yld -- 年化收益率
    ,prod_prft -- 产品收益
    ,ten_thous_corp_prft -- 万份单位收益
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_prod_status_cd -- 上日产品状态代码
    ,prod_acm_nv -- 产品累计净值
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,src_table_name -- 源表名称
        ,job_cd -- 任务编码
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.prod_id -- 产品编号
    ,n.lp_id -- 法人编号
    ,n.ta_cd -- TA代码
    ,n.issue_dt -- 发布日期
    ,n.prod_size -- 产品规模
    ,n.lot -- 份额
    ,n.td_add_lot -- 当日增加份额
    ,n.td_decrs_lot -- 当日减少份额
    ,n.prod_nv -- 产品净值
    ,n.prod_fac_val -- 产品面值
    ,n.aual_yld -- 年化收益率
    ,n.prod_prft -- 产品收益
    ,n.ten_thous_corp_prft -- 万份单位收益
    ,n.prft_assign_flg -- 收益分配标志
    ,n.tran_flg -- 转换标志
    ,n.status_cd -- 状态代码
    ,n.ld_prod_status_cd -- 上日产品状态代码
    ,n.prod_acm_nv -- 产品累计净值
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'trusi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_trust_day_sell_h_trusi1_tm n
    left join (select * from ${iml_schema}.prd_trust_day_sell_h_trusi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.issue_dt = n.issue_dt
where (
        o.prod_id is null
        and o.lp_id is null
        and o.issue_dt is null
    )
    or (
        o.ta_cd <> n.ta_cd
        or o.prod_size <> n.prod_size
        or o.lot <> n.lot
        or o.td_add_lot <> n.td_add_lot
        or o.td_decrs_lot <> n.td_decrs_lot
        or o.prod_nv <> n.prod_nv
        or o.prod_fac_val <> n.prod_fac_val
        or o.aual_yld <> n.aual_yld
        or o.prod_prft <> n.prod_prft
        or o.ten_thous_corp_prft <> n.ten_thous_corp_prft
        or o.prft_assign_flg <> n.prft_assign_flg
        or o.tran_flg <> n.tran_flg
        or o.status_cd <> n.status_cd
        or o.ld_prod_status_cd <> n.ld_prod_status_cd
        or o.prod_acm_nv <> n.prod_acm_nv
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_trust_day_sell_h_trusi1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,issue_dt -- 发布日期
    ,prod_size -- 产品规模
    ,lot -- 份额
    ,td_add_lot -- 当日增加份额
    ,td_decrs_lot -- 当日减少份额
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,aual_yld -- 年化收益率
    ,prod_prft -- 产品收益
    ,ten_thous_corp_prft -- 万份单位收益
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_prod_status_cd -- 上日产品状态代码
    ,prod_acm_nv -- 产品累计净值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_trust_day_sell_h_trusi1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,issue_dt -- 发布日期
    ,prod_size -- 产品规模
    ,lot -- 份额
    ,td_add_lot -- 当日增加份额
    ,td_decrs_lot -- 当日减少份额
    ,prod_nv -- 产品净值
    ,prod_fac_val -- 产品面值
    ,aual_yld -- 年化收益率
    ,prod_prft -- 产品收益
    ,ten_thous_corp_prft -- 万份单位收益
    ,prft_assign_flg -- 收益分配标志
    ,tran_flg -- 转换标志
    ,status_cd -- 状态代码
    ,ld_prod_status_cd -- 上日产品状态代码
    ,prod_acm_nv -- 产品累计净值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品编号
    ,o.lp_id -- 法人编号
    ,o.ta_cd -- TA代码
    ,o.issue_dt -- 发布日期
    ,o.prod_size -- 产品规模
    ,o.lot -- 份额
    ,o.td_add_lot -- 当日增加份额
    ,o.td_decrs_lot -- 当日减少份额
    ,o.prod_nv -- 产品净值
    ,o.prod_fac_val -- 产品面值
    ,o.aual_yld -- 年化收益率
    ,o.prod_prft -- 产品收益
    ,o.ten_thous_corp_prft -- 万份单位收益
    ,o.prft_assign_flg -- 收益分配标志
    ,o.tran_flg -- 转换标志
    ,o.status_cd -- 状态代码
    ,o.ld_prod_status_cd -- 上日产品状态代码
    ,o.prod_acm_nv -- 产品累计净值
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_trust_day_sell_h_trusi1_bk o
    left join ${iml_schema}.prd_trust_day_sell_h_trusi1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.issue_dt = n.issue_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_trust_day_sell_h;
alter table ${iml_schema}.prd_trust_day_sell_h truncate partition for ('trusi1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.prd_trust_day_sell_h exchange subpartition p_trusi1_19000101 with table ${iml_schema}.prd_trust_day_sell_h_trusi1_cl;
alter table ${iml_schema}.prd_trust_day_sell_h exchange subpartition p_trusi1_20991231 with table ${iml_schema}.prd_trust_day_sell_h_trusi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_trust_day_sell_h to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_trust_day_sell_h_trusi1_tm purge;
drop table ${iml_schema}.prd_trust_day_sell_h_trusi1_op purge;
drop table ${iml_schema}.prd_trust_day_sell_h_trusi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_trust_day_sell_h_trusi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_trust_day_sell_h', partname => 'p_trusi1_20991231', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1', no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
