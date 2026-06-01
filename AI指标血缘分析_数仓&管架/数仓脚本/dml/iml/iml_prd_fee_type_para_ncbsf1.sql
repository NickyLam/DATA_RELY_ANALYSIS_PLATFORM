/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_fee_type_para_ncbsf1
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
alter table ${iml_schema}.prd_fee_type_para add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_fee_type_para_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fee_type_para partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_fee_type_para_ncbsf1_tm purge;
drop table ${iml_schema}.prd_fee_type_para_ncbsf1_op purge;
drop table ${iml_schema}.prd_fee_type_para_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fee_type_para_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    lp_id -- 法人编号
    ,fee_type_id -- 费用类型编号
    ,fee_type_descb -- 费用类型描述
    ,prod_group_cd -- 产品组代码
    ,fee_proj_id -- 费用项目编号
    ,fee_curr_cd -- 费用币种代码
    ,amort_flg -- 摊销标志
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,fee_rat_calc_way_cd -- 费率计算方式代码
    ,end_day_onl_cd -- 日终联机代码
    ,charge_curr_cate_cd -- 收费币种类别代码
    ,ratio_bf_convt_flg -- 比率前折算标志
    ,discnt_type_cd -- 折扣类型代码
    ,need_provi_flg -- 需要计提标志
    ,fee_price_std_descb -- 费用价格标准描述
    ,prefr_charge_std_contn_prefr_tm_descb -- 优惠收费标准含优惠时间描述
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fee_type_para partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.prd_fee_type_para_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fee_type_para partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.prd_fee_type_para_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_fee_type_para partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_mb_fee_type-1
insert into ${iml_schema}.prd_fee_type_para_ncbsf1_tm(
    lp_id -- 法人编号
    ,fee_type_id -- 费用类型编号
    ,fee_type_descb -- 费用类型描述
    ,prod_group_cd -- 产品组代码
    ,fee_proj_id -- 费用项目编号
    ,fee_curr_cd -- 费用币种代码
    ,amort_flg -- 摊销标志
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,fee_rat_calc_way_cd -- 费率计算方式代码
    ,end_day_onl_cd -- 日终联机代码
    ,charge_curr_cate_cd -- 收费币种类别代码
    ,ratio_bf_convt_flg -- 比率前折算标志
    ,discnt_type_cd -- 折扣类型代码
    ,need_provi_flg -- 需要计提标志
    ,fee_price_std_descb -- 费用价格标准描述
    ,prefr_charge_std_contn_prefr_tm_descb -- 优惠收费标准含优惠时间描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '9999' -- 法人编号
    ,P1.FEE_TYPE -- 费用类型编号
    ,P1.FEE_DESC -- 费用类型描述
    ,P1.PROD_GRP -- 产品组代码
    ,P1.FEE_ITEM -- 费用项目编号
    ,P1.MB_CCY_TYPE -- 费用币种代码
    ,P1.PROFIT_AMORTIZE_FLAG -- 摊销标志
    ,P1.AMORTIZE_PERIOD_TYPE -- 摊销期限类型代码
    ,P1.FEE_MODE -- 费率计算方式代码
    ,nvl(trim(P1.BO_IND),'-') -- 日终联机代码
    ,nvl(trim(P1.CCY_FLAG),'-') -- 收费币种类别代码
    ,nvl(trim(P1.CONVERT_FLAG),'-') -- 比率前折算标志
    ,P1.DISC_TYPE -- 折扣类型代码
    ,P1.ACCR_FLAG -- 需要计提标志
    ,P1.FEE_PRICE_STANDARD -- 费用价格标准描述
    ,P1.FEE_STANDARD_DISCOUNT_REMARK -- 优惠收费标准含优惠时间描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_mb_fee_type' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_mb_fee_type p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_fee_type_para_ncbsf1_tm 
  	                                group by 
  	                                        lp_id
  	                                        ,fee_type_id
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
        into ${iml_schema}.prd_fee_type_para_ncbsf1_cl(
            lp_id -- 法人编号
    ,fee_type_id -- 费用类型编号
    ,fee_type_descb -- 费用类型描述
    ,prod_group_cd -- 产品组代码
    ,fee_proj_id -- 费用项目编号
    ,fee_curr_cd -- 费用币种代码
    ,amort_flg -- 摊销标志
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,fee_rat_calc_way_cd -- 费率计算方式代码
    ,end_day_onl_cd -- 日终联机代码
    ,charge_curr_cate_cd -- 收费币种类别代码
    ,ratio_bf_convt_flg -- 比率前折算标志
    ,discnt_type_cd -- 折扣类型代码
    ,need_provi_flg -- 需要计提标志
    ,fee_price_std_descb -- 费用价格标准描述
    ,prefr_charge_std_contn_prefr_tm_descb -- 优惠收费标准含优惠时间描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_fee_type_para_ncbsf1_op(
            lp_id -- 法人编号
    ,fee_type_id -- 费用类型编号
    ,fee_type_descb -- 费用类型描述
    ,prod_group_cd -- 产品组代码
    ,fee_proj_id -- 费用项目编号
    ,fee_curr_cd -- 费用币种代码
    ,amort_flg -- 摊销标志
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,fee_rat_calc_way_cd -- 费率计算方式代码
    ,end_day_onl_cd -- 日终联机代码
    ,charge_curr_cate_cd -- 收费币种类别代码
    ,ratio_bf_convt_flg -- 比率前折算标志
    ,discnt_type_cd -- 折扣类型代码
    ,need_provi_flg -- 需要计提标志
    ,fee_price_std_descb -- 费用价格标准描述
    ,prefr_charge_std_contn_prefr_tm_descb -- 优惠收费标准含优惠时间描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.fee_type_id, o.fee_type_id) as fee_type_id -- 费用类型编号
    ,nvl(n.fee_type_descb, o.fee_type_descb) as fee_type_descb -- 费用类型描述
    ,nvl(n.prod_group_cd, o.prod_group_cd) as prod_group_cd -- 产品组代码
    ,nvl(n.fee_proj_id, o.fee_proj_id) as fee_proj_id -- 费用项目编号
    ,nvl(n.fee_curr_cd, o.fee_curr_cd) as fee_curr_cd -- 费用币种代码
    ,nvl(n.amort_flg, o.amort_flg) as amort_flg -- 摊销标志
    ,nvl(n.amort_tenor_type_cd, o.amort_tenor_type_cd) as amort_tenor_type_cd -- 摊销期限类型代码
    ,nvl(n.fee_rat_calc_way_cd, o.fee_rat_calc_way_cd) as fee_rat_calc_way_cd -- 费率计算方式代码
    ,nvl(n.end_day_onl_cd, o.end_day_onl_cd) as end_day_onl_cd -- 日终联机代码
    ,nvl(n.charge_curr_cate_cd, o.charge_curr_cate_cd) as charge_curr_cate_cd -- 收费币种类别代码
    ,nvl(n.ratio_bf_convt_flg, o.ratio_bf_convt_flg) as ratio_bf_convt_flg -- 比率前折算标志
    ,nvl(n.discnt_type_cd, o.discnt_type_cd) as discnt_type_cd -- 折扣类型代码
    ,nvl(n.need_provi_flg, o.need_provi_flg) as need_provi_flg -- 需要计提标志
    ,nvl(n.fee_price_std_descb, o.fee_price_std_descb) as fee_price_std_descb -- 费用价格标准描述
    ,nvl(n.prefr_charge_std_contn_prefr_tm_descb, o.prefr_charge_std_contn_prefr_tm_descb) as prefr_charge_std_contn_prefr_tm_descb -- 优惠收费标准含优惠时间描述
    ,case when
            n.lp_id is null
            and n.fee_type_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lp_id is null
            and n.fee_type_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lp_id is null
            and n.fee_type_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fee_type_para_ncbsf1_tm n
    full join (select * from ${iml_schema}.prd_fee_type_para_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.lp_id = n.lp_id
            and o.fee_type_id = n.fee_type_id
where (
        o.lp_id is null
        and o.fee_type_id is null
    )
    or (
        n.lp_id is null
        and n.fee_type_id is null
    )
    or (
        o.fee_type_descb <> n.fee_type_descb
        or o.prod_group_cd <> n.prod_group_cd
        or o.fee_proj_id <> n.fee_proj_id
        or o.fee_curr_cd <> n.fee_curr_cd
        or o.amort_flg <> n.amort_flg
        or o.amort_tenor_type_cd <> n.amort_tenor_type_cd
        or o.fee_rat_calc_way_cd <> n.fee_rat_calc_way_cd
        or o.end_day_onl_cd <> n.end_day_onl_cd
        or o.charge_curr_cate_cd <> n.charge_curr_cate_cd
        or o.ratio_bf_convt_flg <> n.ratio_bf_convt_flg
        or o.discnt_type_cd <> n.discnt_type_cd
        or o.need_provi_flg <> n.need_provi_flg
        or o.fee_price_std_descb <> n.fee_price_std_descb
        or o.prefr_charge_std_contn_prefr_tm_descb <> n.prefr_charge_std_contn_prefr_tm_descb
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_fee_type_para_ncbsf1_cl(
            lp_id -- 法人编号
    ,fee_type_id -- 费用类型编号
    ,fee_type_descb -- 费用类型描述
    ,prod_group_cd -- 产品组代码
    ,fee_proj_id -- 费用项目编号
    ,fee_curr_cd -- 费用币种代码
    ,amort_flg -- 摊销标志
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,fee_rat_calc_way_cd -- 费率计算方式代码
    ,end_day_onl_cd -- 日终联机代码
    ,charge_curr_cate_cd -- 收费币种类别代码
    ,ratio_bf_convt_flg -- 比率前折算标志
    ,discnt_type_cd -- 折扣类型代码
    ,need_provi_flg -- 需要计提标志
    ,fee_price_std_descb -- 费用价格标准描述
    ,prefr_charge_std_contn_prefr_tm_descb -- 优惠收费标准含优惠时间描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_fee_type_para_ncbsf1_op(
            lp_id -- 法人编号
    ,fee_type_id -- 费用类型编号
    ,fee_type_descb -- 费用类型描述
    ,prod_group_cd -- 产品组代码
    ,fee_proj_id -- 费用项目编号
    ,fee_curr_cd -- 费用币种代码
    ,amort_flg -- 摊销标志
    ,amort_tenor_type_cd -- 摊销期限类型代码
    ,fee_rat_calc_way_cd -- 费率计算方式代码
    ,end_day_onl_cd -- 日终联机代码
    ,charge_curr_cate_cd -- 收费币种类别代码
    ,ratio_bf_convt_flg -- 比率前折算标志
    ,discnt_type_cd -- 折扣类型代码
    ,need_provi_flg -- 需要计提标志
    ,fee_price_std_descb -- 费用价格标准描述
    ,prefr_charge_std_contn_prefr_tm_descb -- 优惠收费标准含优惠时间描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.lp_id -- 法人编号
    ,o.fee_type_id -- 费用类型编号
    ,o.fee_type_descb -- 费用类型描述
    ,o.prod_group_cd -- 产品组代码
    ,o.fee_proj_id -- 费用项目编号
    ,o.fee_curr_cd -- 费用币种代码
    ,o.amort_flg -- 摊销标志
    ,o.amort_tenor_type_cd -- 摊销期限类型代码
    ,o.fee_rat_calc_way_cd -- 费率计算方式代码
    ,o.end_day_onl_cd -- 日终联机代码
    ,o.charge_curr_cate_cd -- 收费币种类别代码
    ,o.ratio_bf_convt_flg -- 比率前折算标志
    ,o.discnt_type_cd -- 折扣类型代码
    ,o.need_provi_flg -- 需要计提标志
    ,o.fee_price_std_descb -- 费用价格标准描述
    ,o.prefr_charge_std_contn_prefr_tm_descb -- 优惠收费标准含优惠时间描述
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_fee_type_para_ncbsf1_bk o
    left join ${iml_schema}.prd_fee_type_para_ncbsf1_op n
        on
            o.lp_id = n.lp_id
            and o.fee_type_id = n.fee_type_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_fee_type_para_ncbsf1_cl d
        on
            o.lp_id = d.lp_id
            and o.fee_type_id = d.fee_type_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_fee_type_para;
--alter table ${iml_schema}.prd_fee_type_para truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_fee_type_para') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_fee_type_para drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.prd_fee_type_para modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_fee_type_para exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.prd_fee_type_para_ncbsf1_cl;
alter table ${iml_schema}.prd_fee_type_para exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.prd_fee_type_para_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_fee_type_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_fee_type_para_ncbsf1_tm purge;
drop table ${iml_schema}.prd_fee_type_para_ncbsf1_op purge;
drop table ${iml_schema}.prd_fee_type_para_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_fee_type_para_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_fee_type_para', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
