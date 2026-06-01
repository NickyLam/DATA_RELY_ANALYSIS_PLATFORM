/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20221011 iml_ref_exch_rat_h_ncbsf1
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
alter table ${iml_schema}.ref_exch_rat_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_exch_rat_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_exch_rat_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_exch_rat_h_ncbsf1_tm purge;
drop table ${iml_schema}.ref_exch_rat_h_ncbsf1_op purge;
drop table ${iml_schema}.ref_exch_rat_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_exch_rat_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    curr_cd -- 币种代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,status_cd -- 状态代码
    ,cn_name -- 中文名称
    ,en_abbr -- 英文简称
    ,convt_corp -- 换算单位
    ,cash_buy_price -- 钞买价
    ,cash_sell_price -- 钞卖价
    ,exch_buy_price -- 汇买价
    ,exch_sell_price -- 汇卖价
    ,mdl_p -- 中间价
    ,fori_exch_mdl_p -- 外管中间价
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_exch_rat_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_exch_rat_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_exch_rat_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_exch_rat_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_exch_rat_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_mb_ccy_rate
insert into ${iml_schema}.ref_exch_rat_h_ncbsf1_tm(
    curr_cd -- 币种代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,status_cd -- 状态代码
    ,cn_name -- 中文名称
    ,en_abbr -- 英文简称
    ,convt_corp -- 换算单位
    ,cash_buy_price -- 钞买价
    ,cash_sell_price -- 钞卖价
    ,exch_buy_price -- 汇买价
    ,exch_sell_price -- 汇卖价
    ,mdl_p -- 中间价
    ,fori_exch_mdl_p -- 外管中间价
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CCY -- 币种代码
    ,P1.EFFECT_DATE -- 生效日期
    ,${iml_schema}.dateformat_max2(null) -- 失效日期
    ,'1' -- 状态代码
    ,T2.CD_VAL -- 中文名称
    ,P1.CCY -- 英文简称
    ,1.0 -- 换算单位
    ,P1.NOTES_BUY_RATE -- 钞买价
    ,P1.NOTES_SELL_RATE -- 钞卖价
    ,P1.EXCH_BUY_RATE -- 汇买价
    ,P1.EXCH_SELL_RATE -- 汇卖价
    ,P1.MIDDLE_RATE -- 中间价
    ,P1.CENTRAL_BANK_RATE -- 外管中间价
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_mb_ccy_rate_hist' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from (select t.*,row_number() over(partition by t.CCY order by t.effect_date desc,t.effect_time desc,t.BRANCH) as rn 
						from (select CCY, EFFECT_DATE, EFFECT_TIME, NOTES_BUY_RATE, NOTES_SELL_RATE, EXCH_BUY_RATE, EXCH_SELL_RATE, MIDDLE_RATE, CENTRAL_BANK_RATE, BRANCH, RATE_TYPE, QUOTE_TYPE
						      from ${iol_schema}.ncbs_mb_ccy_rate t1
						      where t1.start_dt <= to_date('${batch_date}','yyyymmdd') 
						      and t1.end_dt > to_date('${batch_date}','yyyymmdd')
						      union all 
						      select CCY, EFFECT_DATE, EFFECT_TIME, NOTES_BUY_RATE, NOTES_SELL_RATE, EXCH_BUY_RATE, EXCH_SELL_RATE, MIDDLE_RATE, CENTRAL_BANK_RATE, BRANCH, RATE_TYPE, QUOTE_TYPE  
						      from ${iol_schema}.ncbs_mb_ccy_rate_hist t2
						      where t2.start_dt <= to_date('${batch_date}','yyyymmdd') 
						      and t2.end_dt > to_date('${batch_date}','yyyymmdd')) t
						where RATE_TYPE='ZBD'  -- 20221122：核心 陈咸宁/邹声昊 反馈汇率中间价取ZBD-准备金汇率
						and quote_type = 'D'
						and EFFECT_DATE<=to_date('${batch_date}','yyyymmdd')) P1
    left join ${iml_schema}.ref_curr_cd t2 on P1.CCY = T2.CD_VAL
where 1=1
	AND P1.RN=1
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_exch_rat_h_ncbsf1_tm 
  	                                group by 
  	                                        curr_cd
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
        into ${iml_schema}.ref_exch_rat_h_ncbsf1_cl(
            curr_cd -- 币种代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,status_cd -- 状态代码
    ,cn_name -- 中文名称
    ,en_abbr -- 英文简称
    ,convt_corp -- 换算单位
    ,cash_buy_price -- 钞买价
    ,cash_sell_price -- 钞卖价
    ,exch_buy_price -- 汇买价
    ,exch_sell_price -- 汇卖价
    ,mdl_p -- 中间价
    ,fori_exch_mdl_p -- 外管中间价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_exch_rat_h_ncbsf1_op(
            curr_cd -- 币种代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,status_cd -- 状态代码
    ,cn_name -- 中文名称
    ,en_abbr -- 英文简称
    ,convt_corp -- 换算单位
    ,cash_buy_price -- 钞买价
    ,cash_sell_price -- 钞卖价
    ,exch_buy_price -- 汇买价
    ,exch_sell_price -- 汇卖价
    ,mdl_p -- 中间价
    ,fori_exch_mdl_p -- 外管中间价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.cn_name, o.cn_name) as cn_name -- 中文名称
    ,nvl(n.en_abbr, o.en_abbr) as en_abbr -- 英文简称
    ,nvl(n.convt_corp, o.convt_corp) as convt_corp -- 换算单位
    ,nvl(n.cash_buy_price, o.cash_buy_price) as cash_buy_price -- 钞买价
    ,nvl(n.cash_sell_price, o.cash_sell_price) as cash_sell_price -- 钞卖价
    ,nvl(n.exch_buy_price, o.exch_buy_price) as exch_buy_price -- 汇买价
    ,nvl(n.exch_sell_price, o.exch_sell_price) as exch_sell_price -- 汇卖价
    ,nvl(n.mdl_p, o.mdl_p) as mdl_p -- 中间价
    ,nvl(n.fori_exch_mdl_p, o.fori_exch_mdl_p) as fori_exch_mdl_p -- 外管中间价
    ,case when
            n.curr_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.curr_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.curr_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_exch_rat_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_exch_rat_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.curr_cd = n.curr_cd
where (
        o.curr_cd is null
    )
    or (
        n.curr_cd is null
    )
    or (
        o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
        or o.status_cd <> n.status_cd
        or o.cn_name <> n.cn_name
        or o.en_abbr <> n.en_abbr
        or o.convt_corp <> n.convt_corp
        or o.cash_buy_price <> n.cash_buy_price
        or o.cash_sell_price <> n.cash_sell_price
        or o.exch_buy_price <> n.exch_buy_price
        or o.exch_sell_price <> n.exch_sell_price
        or o.mdl_p <> n.mdl_p
        or o.fori_exch_mdl_p <> n.fori_exch_mdl_p
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_exch_rat_h_ncbsf1_cl(
            curr_cd -- 币种代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,status_cd -- 状态代码
    ,cn_name -- 中文名称
    ,en_abbr -- 英文简称
    ,convt_corp -- 换算单位
    ,cash_buy_price -- 钞买价
    ,cash_sell_price -- 钞卖价
    ,exch_buy_price -- 汇买价
    ,exch_sell_price -- 汇卖价
    ,mdl_p -- 中间价
    ,fori_exch_mdl_p -- 外管中间价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_exch_rat_h_ncbsf1_op(
            curr_cd -- 币种代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,status_cd -- 状态代码
    ,cn_name -- 中文名称
    ,en_abbr -- 英文简称
    ,convt_corp -- 换算单位
    ,cash_buy_price -- 钞买价
    ,cash_sell_price -- 钞卖价
    ,exch_buy_price -- 汇买价
    ,exch_sell_price -- 汇卖价
    ,mdl_p -- 中间价
    ,fori_exch_mdl_p -- 外管中间价
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.curr_cd -- 币种代码
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.status_cd -- 状态代码
    ,o.cn_name -- 中文名称
    ,o.en_abbr -- 英文简称
    ,o.convt_corp -- 换算单位
    ,o.cash_buy_price -- 钞买价
    ,o.cash_sell_price -- 钞卖价
    ,o.exch_buy_price -- 汇买价
    ,o.exch_sell_price -- 汇卖价
    ,o.mdl_p -- 中间价
    ,o.fori_exch_mdl_p -- 外管中间价
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_exch_rat_h_ncbsf1_bk o
    left join ${iml_schema}.ref_exch_rat_h_ncbsf1_op n
        on
            o.curr_cd = n.curr_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_exch_rat_h_ncbsf1_cl d
        on
            o.curr_cd = d.curr_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_exch_rat_h;
alter table ${iml_schema}.ref_exch_rat_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_exch_rat_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.ref_exch_rat_h_ncbsf1_cl;
alter table ${iml_schema}.ref_exch_rat_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_exch_rat_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_exch_rat_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_exch_rat_h_ncbsf1_tm purge;
drop table ${iml_schema}.ref_exch_rat_h_ncbsf1_op purge;
drop table ${iml_schema}.ref_exch_rat_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_exch_rat_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_exch_rat_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
