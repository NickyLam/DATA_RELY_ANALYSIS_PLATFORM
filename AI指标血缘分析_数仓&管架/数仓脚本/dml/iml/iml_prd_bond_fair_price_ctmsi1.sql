/*
Purpose:    整合模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_bond_fair_price_ctmsi1
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
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.prd_bond_fair_price add partition p_ctmsi1 values ('ctmsi1')(
        subpartition p_ctmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ctmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

create table ${iml_schema}.prd_bond_fair_price_ctmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_fair_price partition for ('ctmsi1') 
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_bond_fair_price_ctmsi1_tm purge;
drop table ${iml_schema}.prd_bond_fair_price_ctmsi1_op purge;
drop table ${iml_schema}.prd_bond_fair_price_ctmsi1_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_fair_price_ctmsi1_tm nologging
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
    ,end_day_full_price -- 日终全价
    ,estim_yld_rat -- 估价收益率
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_fair_price partition for ('ctmsi1')
where 0=1
;

create table ${iml_schema}.prd_bond_fair_price_ctmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_fair_price partition for ('ctmsi1') where 0=1;

create table ${iml_schema}.prd_bond_fair_price_ctmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_bond_fair_price partition for ('ctmsi1') where 0=1;

-- 3.1 get new data into table
-- ctms_tbs_v_cdc_fp-
insert into ${iml_schema}.prd_bond_fair_price_ctmsi1_tm(
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
    ,P1.END_DP -- 日终全价
    ,P1.CDC_YIELD -- 估价收益率
    ,P1.CDC_MD -- 估价修正久期
    ,P1.CDC_CONVEXITY -- 估价凸性
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_cdc_fp' -- 源表名称
    ,'ctmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_cdc_fp p1
where  1 = 1 
    and p1.pricing_date = ${batch_date}
    and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
    ;
commit;


commit;


whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_bond_fair_price_ctmsi1_tm 
  	                                group by 
  	                                        bond_id
  	                                        ,lp_id
  	                                        ,price_dt
  	                                        ,tran_market_name
  	                                        ,surp_tenor
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
insert /*+ append */ into ${iml_schema}.prd_bond_fair_price_ctmsi1_op(
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
    n.bond_id -- 债券编号
    ,n.lp_id -- 法人编号
    ,n.price_dt -- 价格日期
    ,n.tran_market_name -- 交易市场名称
    ,n.surp_tenor -- 剩余期限
    ,n.recmd_flg -- 推荐标志
    ,n.full_price -- 全价
    ,n.net_price -- 净价
    ,n.exp_yld_rat -- 到期收益率
    ,n.duran -- 久期
    ,n.coret_duran -- 修正久期
    ,n.valid_flg -- 有效标志
    ,n.end_day_full_price -- 日终全价
    ,n.estim_yld_rat -- 估价收益率
    ,n.estim_coret_duran -- 估价修正久期
    ,n.estim_cvty -- 估价凸性
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark -- 增删标志
    ,n.src_table_name -- 源表名称
    ,'ctmsi1' as job_cd -- 任务编码
    ,n.etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_bond_fair_price_ctmsi1_tm n
    left join ${iml_schema}.prd_bond_fair_price_ctmsi1_bk o
        on
            o.bond_id = n.bond_id
            and o.lp_id = n.lp_id
            and o.price_dt = n.price_dt
            and o.tran_market_name = n.tran_market_name
            and o.surp_tenor = n.surp_tenor
where (
        o.bond_id is null
        and o.lp_id is null
        and o.price_dt is null
        and o.tran_market_name is null
        and o.surp_tenor is null
    )
    or (
        o.recmd_flg <> n.recmd_flg
        or o.full_price <> n.full_price
        or o.net_price <> n.net_price
        or o.exp_yld_rat <> n.exp_yld_rat
        or o.duran <> n.duran
        or o.coret_duran <> n.coret_duran
        or o.valid_flg <> n.valid_flg
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
        into ${iml_schema}.prd_bond_fair_price_ctmsi1_cl(
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
        into ${iml_schema}.prd_bond_fair_price_ctmsi1_op(
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
from ${iml_schema}.prd_bond_fair_price_ctmsi1_bk o
    left join ${iml_schema}.prd_bond_fair_price_ctmsi1_op n
        on
            o.bond_id = n.bond_id
            and o.lp_id = n.lp_id
            and o.price_dt = n.price_dt
            and o.tran_market_name = n.tran_market_name
            and o.surp_tenor = n.surp_tenor
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;


-- 4.1 rebuild partition
whenever sqlerror continue none;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_bond_fair_price') 
               and substr(subpartition_name,1,8)=upper('p_ctmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_bond_fair_price drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.prd_bond_fair_price modify partition p_ctmsi1 
add subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','YYYYMMDD'));
  
-- 4.2 exchange partition
alter table ${iml_schema}.prd_bond_fair_price exchange subpartition p_ctmsi1_${batch_date} with table ${iml_schema}.prd_bond_fair_price_ctmsi1_cl;
alter table ${iml_schema}.prd_bond_fair_price exchange subpartition p_ctmsi1_20991231 with table ${iml_schema}.prd_bond_fair_price_ctmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_bond_fair_price to ${iml_schema};

-- 5.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_bond_fair_price_ctmsi1_tm purge;
drop table ${iml_schema}.prd_bond_fair_price_ctmsi1_op purge;
drop table ${iml_schema}.prd_bond_fair_price_ctmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_bond_fair_price_ctmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_bond_fair_price', partname => 'p_ctmsi1_20991231', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1', no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
