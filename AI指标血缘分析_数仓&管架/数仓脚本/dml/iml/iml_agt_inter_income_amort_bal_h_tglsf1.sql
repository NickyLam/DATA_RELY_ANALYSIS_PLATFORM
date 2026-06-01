/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_inter_income_amort_bal_h_tglsf1
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
alter table ${iml_schema}.agt_inter_income_amort_bal_h add partition p_tglsf1 values ('tglsf1')(
        subpartition p_tglsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_tglsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_inter_income_amort_bal_h partition for ('tglsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_tm purge;
drop table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_op purge;
drop table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_sys_id -- 业务系统编号
    ,tran_flow_num -- 交易流水号
    ,doc_id -- 单据编号
    ,prod_id -- 产品编号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,actl_amort_start_dt -- 实际摊销开始日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,acm_amort_amt -- 累计摊销金额
    ,inter_income_amort_status_cd -- 中收摊销状态代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_inter_income_amort_bal_h partition for ('tglsf1')
where 0=1
;

create table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_inter_income_amort_bal_h partition for ('tglsf1') where 0=1;

create table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_inter_income_amort_bal_h partition for ('tglsf1') where 0=1;

-- 3.1 get new data into table
-- tgls_ama_mdsr_acct_h-1
insert into ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_sys_id -- 业务系统编号
    ,tran_flow_num -- 交易流水号
    ,doc_id -- 单据编号
    ,prod_id -- 产品编号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,actl_amort_start_dt -- 实际摊销开始日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,acm_amort_amt -- 累计摊销金额
    ,inter_income_amort_status_cd -- 中收摊销状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300019'||P1.SYSTID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SYSTID -- 业务系统编号
    ,P1.TRANSQ -- 交易流水号
    ,P1.LOANNO -- 单据编号
    ,P1.PRDUCD -- 产品编号
    ,P1.DEPTCD -- 账务机构编号
    ,P1.CRCYCD -- 币种代码
    ,${iml_schema}.dateformat_min(P1.AMOTRBDT) -- 摊销开始日期
    ,${iml_schema}.dateformat_max2(P1.AMOTRODT) -- 摊销结束日期
    ,${iml_schema}.dateformat_min(P1.ACAMOTRBDT) -- 实际摊销开始日期
    ,P1.NORMPR -- 待摊总金额
    ,P1.AMORTAM -- 本次摊销金额
    ,P1.AMORTISEDAM -- 累计摊销金额
    ,P1.AMORTST -- 中收摊销状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_ama_mdsr_acct_h' -- 源表名称
    ,'tglsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_ama_mdsr_acct_h p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,bus_sys_id
  	                                        ,doc_id
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
        into ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_sys_id -- 业务系统编号
    ,tran_flow_num -- 交易流水号
    ,doc_id -- 单据编号
    ,prod_id -- 产品编号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,actl_amort_start_dt -- 实际摊销开始日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,acm_amort_amt -- 累计摊销金额
    ,inter_income_amort_status_cd -- 中收摊销状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_sys_id -- 业务系统编号
    ,tran_flow_num -- 交易流水号
    ,doc_id -- 单据编号
    ,prod_id -- 产品编号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,actl_amort_start_dt -- 实际摊销开始日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,acm_amort_amt -- 累计摊销金额
    ,inter_income_amort_status_cd -- 中收摊销状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bus_sys_id, o.bus_sys_id) as bus_sys_id -- 业务系统编号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.doc_id, o.doc_id) as doc_id -- 单据编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.amort_start_dt, o.amort_start_dt) as amort_start_dt -- 摊销开始日期
    ,nvl(n.amort_end_dt, o.amort_end_dt) as amort_end_dt -- 摊销结束日期
    ,nvl(n.actl_amort_start_dt, o.actl_amort_start_dt) as actl_amort_start_dt -- 实际摊销开始日期
    ,nvl(n.amorted_tot_amt, o.amorted_tot_amt) as amorted_tot_amt -- 待摊总金额
    ,nvl(n.ths_tm_amort_amt, o.ths_tm_amort_amt) as ths_tm_amort_amt -- 本次摊销金额
    ,nvl(n.acm_amort_amt, o.acm_amort_amt) as acm_amort_amt -- 累计摊销金额
    ,nvl(n.inter_income_amort_status_cd, o.inter_income_amort_status_cd) as inter_income_amort_status_cd -- 中收摊销状态代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.bus_sys_id is null
            and n.doc_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.bus_sys_id is null
            and n.doc_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.bus_sys_id is null
            and n.doc_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_tm n
    full join (select * from ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.bus_sys_id = n.bus_sys_id
            and o.doc_id = n.doc_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.bus_sys_id is null
        and o.doc_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.bus_sys_id is null
        and n.doc_id is null
    )
    or (
        o.tran_flow_num <> n.tran_flow_num
        or o.prod_id <> n.prod_id
        or o.acct_instit_id <> n.acct_instit_id
        or o.curr_cd <> n.curr_cd
        or o.amort_start_dt <> n.amort_start_dt
        or o.amort_end_dt <> n.amort_end_dt
        or o.actl_amort_start_dt <> n.actl_amort_start_dt
        or o.amorted_tot_amt <> n.amorted_tot_amt
        or o.ths_tm_amort_amt <> n.ths_tm_amort_amt
        or o.acm_amort_amt <> n.acm_amort_amt
        or o.inter_income_amort_status_cd <> n.inter_income_amort_status_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_sys_id -- 业务系统编号
    ,tran_flow_num -- 交易流水号
    ,doc_id -- 单据编号
    ,prod_id -- 产品编号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,actl_amort_start_dt -- 实际摊销开始日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,acm_amort_amt -- 累计摊销金额
    ,inter_income_amort_status_cd -- 中收摊销状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bus_sys_id -- 业务系统编号
    ,tran_flow_num -- 交易流水号
    ,doc_id -- 单据编号
    ,prod_id -- 产品编号
    ,acct_instit_id -- 账务机构编号
    ,curr_cd -- 币种代码
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,actl_amort_start_dt -- 实际摊销开始日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,acm_amort_amt -- 累计摊销金额
    ,inter_income_amort_status_cd -- 中收摊销状态代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.bus_sys_id -- 业务系统编号
    ,o.tran_flow_num -- 交易流水号
    ,o.doc_id -- 单据编号
    ,o.prod_id -- 产品编号
    ,o.acct_instit_id -- 账务机构编号
    ,o.curr_cd -- 币种代码
    ,o.amort_start_dt -- 摊销开始日期
    ,o.amort_end_dt -- 摊销结束日期
    ,o.actl_amort_start_dt -- 实际摊销开始日期
    ,o.amorted_tot_amt -- 待摊总金额
    ,o.ths_tm_amort_amt -- 本次摊销金额
    ,o.acm_amort_amt -- 累计摊销金额
    ,o.inter_income_amort_status_cd -- 中收摊销状态代码
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
from ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_bk o
    left join ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.bus_sys_id = n.bus_sys_id
            and o.doc_id = n.doc_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.bus_sys_id = d.bus_sys_id
            and o.doc_id = d.doc_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_inter_income_amort_bal_h;
--alter table ${iml_schema}.agt_inter_income_amort_bal_h truncate partition for ('tglsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_inter_income_amort_bal_h') 
               and substr(subpartition_name,1,8)=upper('p_tglsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_inter_income_amort_bal_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_inter_income_amort_bal_h modify partition p_tglsf1 
add subpartition p_tglsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_inter_income_amort_bal_h exchange subpartition p_tglsf1_${batch_date} with table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_cl;
alter table ${iml_schema}.agt_inter_income_amort_bal_h exchange subpartition p_tglsf1_20991231 with table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_inter_income_amort_bal_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_tm purge;
drop table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_op purge;
drop table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_inter_income_amort_bal_h_tglsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_inter_income_amort_bal_h', partname => 'p_tglsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
