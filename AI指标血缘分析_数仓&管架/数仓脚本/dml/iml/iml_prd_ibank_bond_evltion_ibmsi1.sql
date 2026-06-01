/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_ibank_bond_evltion_ibmsi1
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
alter table ${iml_schema}.prd_ibank_bond_evltion add partition p_ibmsi1 values ('ibmsi1')(
        subpartition p_ibmsi1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ibmsi1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_bond_evltion partition for ('ibmsi1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_tm purge;
drop table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_op purge;
drop table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_tm nologging
compress ${option_switch} for query high
as select
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,net_price_amt -- 净价金额
    ,acru_int -- 应计利息
    ,estim_yld_rat -- 估价收益率
    ,spread_yld_rat -- 点差收益率
    ,estim_pend_ped -- 估价待偿期
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
    ,estim_bp_val -- 估价基点价值
    ,estim_spd_duran -- 估价利差久期
    ,estim_spd_cvty -- 估价利差凸性
    ,estim_int_rat_duran -- 估价利率久期
    ,estim_int_rat_cvty -- 估价利率凸性
    ,full_price_amt -- 全价金额
    ,input_dt -- 录入日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_bond_evltion partition for ('ibmsi1')
where 0=1
;

create table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_bond_evltion partition for ('ibmsi1') where 0=1;

create table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_ibank_bond_evltion partition for ('ibmsi1') where 0=1;

-- 3.1 get new data into table
-- ibms_tcb_bond_eval-
insert into ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_tm(
    fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,net_price_amt -- 净价金额
    ,acru_int -- 应计利息
    ,estim_yld_rat -- 估价收益率
    ,spread_yld_rat -- 点差收益率
    ,estim_pend_ped -- 估价待偿期
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
    ,estim_bp_val -- 估价基点价值
    ,estim_spd_duran -- 估价利差久期
    ,estim_spd_cvty -- 估价利差凸性
    ,estim_int_rat_duran -- 估价利率久期
    ,estim_int_rat_cvty -- 估价利率凸性
    ,full_price_amt -- 全价金额
    ,input_dt -- 录入日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.I_CODE -- 金融工具编号
    ,P1.A_TYPE -- 资产类型编号
    ,P1.M_TYPE -- 市场类型编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.BEG_DATE) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.END_DATE) -- 失效日期
    ,P1.NETPRICE -- 净价金额
    ,P1.AI -- 应计利息
    ,P1.YIELD -- 估价收益率
    ,P1.RD_YIELD -- 点差收益率
    ,P1.TERM -- 估价待偿期
    ,P1.MODIFIED_D -- 估价修正久期
    ,P1.CONVEXITY -- 估价凸性
    ,P1.DVBP -- 估价基点价值
    ,P1.RD_MODIFIED -- 估价利差久期
    ,P1.RD_CONVEXITY -- 估价利差凸性
    ,P1.R_MODIFIED -- 估价利率久期
    ,P1.R_CONVEXITY -- 估价利率凸性
    ,P1.FULLPRICE -- 全价金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.IMP_DATE) -- 录入日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_tcb_bond_eval' -- 源表名称
    ,'ibmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_tcb_bond_eval p1
where  1 = 1 
    and p1.beg_date <= to_char(to_date('${batch_date}','yyyymmdd'),'yyyy-mm-dd') and p1.END_DATE > to_char(to_date('${batch_date}','yyyymmdd'),'yyyy-mm-dd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_tm 
  	                                group by 
  	                                        fin_instm_id
  	                                        ,asset_type_id
  	                                        ,market_type_id
  	                                        ,lp_id
  	                                        ,effect_dt
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
        into ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_cl(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,net_price_amt -- 净价金额
    ,acru_int -- 应计利息
    ,estim_yld_rat -- 估价收益率
    ,spread_yld_rat -- 点差收益率
    ,estim_pend_ped -- 估价待偿期
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
    ,estim_bp_val -- 估价基点价值
    ,estim_spd_duran -- 估价利差久期
    ,estim_spd_cvty -- 估价利差凸性
    ,estim_int_rat_duran -- 估价利率久期
    ,estim_int_rat_cvty -- 估价利率凸性
    ,full_price_amt -- 全价金额
    ,input_dt -- 录入日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_op(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,net_price_amt -- 净价金额
    ,acru_int -- 应计利息
    ,estim_yld_rat -- 估价收益率
    ,spread_yld_rat -- 点差收益率
    ,estim_pend_ped -- 估价待偿期
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
    ,estim_bp_val -- 估价基点价值
    ,estim_spd_duran -- 估价利差久期
    ,estim_spd_cvty -- 估价利差凸性
    ,estim_int_rat_duran -- 估价利率久期
    ,estim_int_rat_cvty -- 估价利率凸性
    ,full_price_amt -- 全价金额
    ,input_dt -- 录入日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fin_instm_id, o.fin_instm_id) as fin_instm_id -- 金融工具编号
    ,nvl(n.asset_type_id, o.asset_type_id) as asset_type_id -- 资产类型编号
    ,nvl(n.market_type_id, o.market_type_id) as market_type_id -- 市场类型编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.net_price_amt, o.net_price_amt) as net_price_amt -- 净价金额
    ,nvl(n.acru_int, o.acru_int) as acru_int -- 应计利息
    ,nvl(n.estim_yld_rat, o.estim_yld_rat) as estim_yld_rat -- 估价收益率
    ,nvl(n.spread_yld_rat, o.spread_yld_rat) as spread_yld_rat -- 点差收益率
    ,nvl(n.estim_pend_ped, o.estim_pend_ped) as estim_pend_ped -- 估价待偿期
    ,nvl(n.estim_coret_duran, o.estim_coret_duran) as estim_coret_duran -- 估价修正久期
    ,nvl(n.estim_cvty, o.estim_cvty) as estim_cvty -- 估价凸性
    ,nvl(n.estim_bp_val, o.estim_bp_val) as estim_bp_val -- 估价基点价值
    ,nvl(n.estim_spd_duran, o.estim_spd_duran) as estim_spd_duran -- 估价利差久期
    ,nvl(n.estim_spd_cvty, o.estim_spd_cvty) as estim_spd_cvty -- 估价利差凸性
    ,nvl(n.estim_int_rat_duran, o.estim_int_rat_duran) as estim_int_rat_duran -- 估价利率久期
    ,nvl(n.estim_int_rat_cvty, o.estim_int_rat_cvty) as estim_int_rat_cvty -- 估价利率凸性
    ,nvl(n.full_price_amt, o.full_price_amt) as full_price_amt -- 全价金额
    ,nvl(n.input_dt, o.input_dt) as input_dt -- 录入日期
    ,case when
            n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.lp_id is null
            and n.effect_dt is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.lp_id is null
            and n.effect_dt is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fin_instm_id is null
            and n.asset_type_id is null
            and n.market_type_id is null
            and n.lp_id is null
            and n.effect_dt is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_tm n
    full join (select * from ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.lp_id = n.lp_id
            and o.effect_dt = n.effect_dt
where (
        o.fin_instm_id is null
        and o.asset_type_id is null
        and o.market_type_id is null
        and o.lp_id is null
        and o.effect_dt is null
    )
    or (
        n.fin_instm_id is null
        and n.asset_type_id is null
        and n.market_type_id is null
        and n.lp_id is null
        and n.effect_dt is null
    )
    or (
        o.invalid_dt <> n.invalid_dt
        or o.net_price_amt <> n.net_price_amt
        or o.acru_int <> n.acru_int
        or o.estim_yld_rat <> n.estim_yld_rat
        or o.spread_yld_rat <> n.spread_yld_rat
        or o.estim_pend_ped <> n.estim_pend_ped
        or o.estim_coret_duran <> n.estim_coret_duran
        or o.estim_cvty <> n.estim_cvty
        or o.estim_bp_val <> n.estim_bp_val
        or o.estim_spd_duran <> n.estim_spd_duran
        or o.estim_spd_cvty <> n.estim_spd_cvty
        or o.estim_int_rat_duran <> n.estim_int_rat_duran
        or o.estim_int_rat_cvty <> n.estim_int_rat_cvty
        or o.full_price_amt <> n.full_price_amt
        or o.input_dt <> n.input_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_cl(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,net_price_amt -- 净价金额
    ,acru_int -- 应计利息
    ,estim_yld_rat -- 估价收益率
    ,spread_yld_rat -- 点差收益率
    ,estim_pend_ped -- 估价待偿期
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
    ,estim_bp_val -- 估价基点价值
    ,estim_spd_duran -- 估价利差久期
    ,estim_spd_cvty -- 估价利差凸性
    ,estim_int_rat_duran -- 估价利率久期
    ,estim_int_rat_cvty -- 估价利率凸性
    ,full_price_amt -- 全价金额
    ,input_dt -- 录入日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_op(
            fin_instm_id -- 金融工具编号
    ,asset_type_id -- 资产类型编号
    ,market_type_id -- 市场类型编号
    ,lp_id -- 法人编号
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,net_price_amt -- 净价金额
    ,acru_int -- 应计利息
    ,estim_yld_rat -- 估价收益率
    ,spread_yld_rat -- 点差收益率
    ,estim_pend_ped -- 估价待偿期
    ,estim_coret_duran -- 估价修正久期
    ,estim_cvty -- 估价凸性
    ,estim_bp_val -- 估价基点价值
    ,estim_spd_duran -- 估价利差久期
    ,estim_spd_cvty -- 估价利差凸性
    ,estim_int_rat_duran -- 估价利率久期
    ,estim_int_rat_cvty -- 估价利率凸性
    ,full_price_amt -- 全价金额
    ,input_dt -- 录入日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fin_instm_id -- 金融工具编号
    ,o.asset_type_id -- 资产类型编号
    ,o.market_type_id -- 市场类型编号
    ,o.lp_id -- 法人编号
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
    ,o.net_price_amt -- 净价金额
    ,o.acru_int -- 应计利息
    ,o.estim_yld_rat -- 估价收益率
    ,o.spread_yld_rat -- 点差收益率
    ,o.estim_pend_ped -- 估价待偿期
    ,o.estim_coret_duran -- 估价修正久期
    ,o.estim_cvty -- 估价凸性
    ,o.estim_bp_val -- 估价基点价值
    ,o.estim_spd_duran -- 估价利差久期
    ,o.estim_spd_cvty -- 估价利差凸性
    ,o.estim_int_rat_duran -- 估价利率久期
    ,o.estim_int_rat_cvty -- 估价利率凸性
    ,o.full_price_amt -- 全价金额
    ,o.input_dt -- 录入日期
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
from ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_bk o
    left join ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_op n
        on
            o.fin_instm_id = n.fin_instm_id
            and o.asset_type_id = n.asset_type_id
            and o.market_type_id = n.market_type_id
            and o.lp_id = n.lp_id
            and o.effect_dt = n.effect_dt
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_cl d
        on
            o.fin_instm_id = d.fin_instm_id
            and o.asset_type_id = d.asset_type_id
            and o.market_type_id = d.market_type_id
            and o.lp_id = d.lp_id
            and o.effect_dt = d.effect_dt
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_ibank_bond_evltion;
--alter table ${iml_schema}.prd_ibank_bond_evltion truncate partition for ('ibmsi1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_ibank_bond_evltion') 
               and substr(subpartition_name,1,8)=upper('p_ibmsi1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_ibank_bond_evltion drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.prd_ibank_bond_evltion modify partition p_ibmsi1 
add subpartition p_ibmsi1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_ibank_bond_evltion exchange subpartition p_ibmsi1_${batch_date} with table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_cl;
alter table ${iml_schema}.prd_ibank_bond_evltion exchange subpartition p_ibmsi1_20991231 with table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_ibank_bond_evltion to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_tm purge;
drop table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_op purge;
drop table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_ibank_bond_evltion_ibmsi1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_ibank_bond_evltion', partname => 'p_ibmsi1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
