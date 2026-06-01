/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ph_soc_appl_evt_icmsf1
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
alter table ${iml_schema}.evt_ph_soc_appl_evt add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ph_soc_appl_evt partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_tm purge;
drop table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_op purge;
drop table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,input_dt -- 录入日期
    ,tot_soc_amt -- 总理赔金额
    ,ovdue_tot_days -- 逾期总天数
    ,ovdue_tot_pric -- 逾期总本金
    ,ovdue_int -- 逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,not_calc_int -- 未计利息
    ,unexp_pric -- 未到期本金
    ,stud_loan_prod_id -- 助贷产品编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ph_soc_appl_evt partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ph_soc_appl_evt partition for ('icmsf1') where 0=1;

create table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_ph_soc_appl_evt partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_pph_claim_appl_data-1
insert into ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,input_dt -- 录入日期
    ,tot_soc_amt -- 总理赔金额
    ,ovdue_tot_days -- 逾期总天数
    ,ovdue_tot_pric -- 逾期总本金
    ,ovdue_int -- 逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,not_calc_int -- 未计利息
    ,unexp_pric -- 未到期本金
    ,stud_loan_prod_id -- 助贷产品编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401036'||P1.LOANNO||P1.INPUTDATE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.LOANNO -- 借据编号
    ,${iml_schema}.dateformat_max2(P1.INPUTDATE) -- 录入日期
    ,P1.CLAIMAMT -- 总理赔金额
    ,P1.CAPDAYS -- 逾期总天数
    ,P1.CAPITAL -- 逾期总本金
    ,P1.AINT -- 逾期利息
    ,P1.OINT -- 逾期罚息
    ,P1.NINT -- 未计利息
    ,P1.CURNINT -- 未到期本金
    ,P1.COMPID -- 助贷产品编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_pph_claim_appl_data' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_pph_claim_appl_data p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
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
        into ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,input_dt -- 录入日期
    ,tot_soc_amt -- 总理赔金额
    ,ovdue_tot_days -- 逾期总天数
    ,ovdue_tot_pric -- 逾期总本金
    ,ovdue_int -- 逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,not_calc_int -- 未计利息
    ,unexp_pric -- 未到期本金
    ,stud_loan_prod_id -- 助贷产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,input_dt -- 录入日期
    ,tot_soc_amt -- 总理赔金额
    ,ovdue_tot_days -- 逾期总天数
    ,ovdue_tot_pric -- 逾期总本金
    ,ovdue_int -- 逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,not_calc_int -- 未计利息
    ,unexp_pric -- 未到期本金
    ,stud_loan_prod_id -- 助贷产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.input_dt, o.input_dt) as input_dt -- 录入日期
    ,nvl(n.tot_soc_amt, o.tot_soc_amt) as tot_soc_amt -- 总理赔金额
    ,nvl(n.ovdue_tot_days, o.ovdue_tot_days) as ovdue_tot_days -- 逾期总天数
    ,nvl(n.ovdue_tot_pric, o.ovdue_tot_pric) as ovdue_tot_pric -- 逾期总本金
    ,nvl(n.ovdue_int, o.ovdue_int) as ovdue_int -- 逾期利息
    ,nvl(n.ovdue_pnlt, o.ovdue_pnlt) as ovdue_pnlt -- 逾期罚息
    ,nvl(n.not_calc_int, o.not_calc_int) as not_calc_int -- 未计利息
    ,nvl(n.unexp_pric, o.unexp_pric) as unexp_pric -- 未到期本金
    ,nvl(n.stud_loan_prod_id, o.stud_loan_prod_id) as stud_loan_prod_id -- 助贷产品编号
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_tm n
    full join (select * from ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.dubil_id <> n.dubil_id
        or o.input_dt <> n.input_dt
        or o.tot_soc_amt <> n.tot_soc_amt
        or o.ovdue_tot_days <> n.ovdue_tot_days
        or o.ovdue_tot_pric <> n.ovdue_tot_pric
        or o.ovdue_int <> n.ovdue_int
        or o.ovdue_pnlt <> n.ovdue_pnlt
        or o.not_calc_int <> n.not_calc_int
        or o.unexp_pric <> n.unexp_pric
        or o.stud_loan_prod_id <> n.stud_loan_prod_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,input_dt -- 录入日期
    ,tot_soc_amt -- 总理赔金额
    ,ovdue_tot_days -- 逾期总天数
    ,ovdue_tot_pric -- 逾期总本金
    ,ovdue_int -- 逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,not_calc_int -- 未计利息
    ,unexp_pric -- 未到期本金
    ,stud_loan_prod_id -- 助贷产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,input_dt -- 录入日期
    ,tot_soc_amt -- 总理赔金额
    ,ovdue_tot_days -- 逾期总天数
    ,ovdue_tot_pric -- 逾期总本金
    ,ovdue_int -- 逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,not_calc_int -- 未计利息
    ,unexp_pric -- 未到期本金
    ,stud_loan_prod_id -- 助贷产品编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.dubil_id -- 借据编号
    ,o.input_dt -- 录入日期
    ,o.tot_soc_amt -- 总理赔金额
    ,o.ovdue_tot_days -- 逾期总天数
    ,o.ovdue_tot_pric -- 逾期总本金
    ,o.ovdue_int -- 逾期利息
    ,o.ovdue_pnlt -- 逾期罚息
    ,o.not_calc_int -- 未计利息
    ,o.unexp_pric -- 未到期本金
    ,o.stud_loan_prod_id -- 助贷产品编号
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
from ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_bk o
    left join ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_ph_soc_appl_evt;
--alter table ${iml_schema}.evt_ph_soc_appl_evt truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_ph_soc_appl_evt') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_ph_soc_appl_evt drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_ph_soc_appl_evt modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_ph_soc_appl_evt exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_cl;
alter table ${iml_schema}.evt_ph_soc_appl_evt exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ph_soc_appl_evt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_tm purge;
drop table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_op purge;
drop table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_ph_soc_appl_evt_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ph_soc_appl_evt', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
