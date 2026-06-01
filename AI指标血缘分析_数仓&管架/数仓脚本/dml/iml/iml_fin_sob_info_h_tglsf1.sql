/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_fin_sob_info_h_tglsf1
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
alter table ${iml_schema}.fin_sob_info_h add partition p_tglsf1 values ('tglsf1')(
        subpartition p_tglsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_tglsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.fin_sob_info_h_tglsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_sob_info_h partition for ('tglsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.fin_sob_info_h_tglsf1_tm purge;
drop table ${iml_schema}.fin_sob_info_h_tglsf1_op purge;
drop table ${iml_schema}.fin_sob_info_h_tglsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.fin_sob_info_h_tglsf1_tm nologging
compress ${option_switch} for query high
as select
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,org_name -- 机构名称
    ,curr_cd -- 币种代码
    ,start_use_duran -- 启用期间
    ,tran_status_cd -- 交易状态代码
    ,curr_acctnt_duran -- 当前会计期间
    ,aldy_stl_perds -- 已结账期数
    ,gl_dt -- 总账日期
    ,realtm_calc_bal_flg -- 实时计算余额标志
    ,balc_check_flg -- 平衡检查标志
    ,need_entry_flg -- 需记账标志
    ,sob_status_cd -- 账套状态代码
    ,bus_dt -- 业务日期
    ,acct_dt -- 账务日期
    ,open_invoice_curr_cd -- 开票币种代码
    ,sob_type_cd -- 账套类型代码
    ,entry_cd -- 记账机制代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_sob_info_h partition for ('tglsf1')
where 0=1
;

create table ${iml_schema}.fin_sob_info_h_tglsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_sob_info_h partition for ('tglsf1') where 0=1;

create table ${iml_schema}.fin_sob_info_h_tglsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.fin_sob_info_h partition for ('tglsf1') where 0=1;

-- 3.1 get new data into table
-- tgls_com_stac-1
insert into ${iml_schema}.fin_sob_info_h_tglsf1_tm(
    sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,org_name -- 机构名称
    ,curr_cd -- 币种代码
    ,start_use_duran -- 启用期间
    ,tran_status_cd -- 交易状态代码
    ,curr_acctnt_duran -- 当前会计期间
    ,aldy_stl_perds -- 已结账期数
    ,gl_dt -- 总账日期
    ,realtm_calc_bal_flg -- 实时计算余额标志
    ,balc_check_flg -- 平衡检查标志
    ,need_entry_flg -- 需记账标志
    ,sob_status_cd -- 账套状态代码
    ,bus_dt -- 业务日期
    ,acct_dt -- 账务日期
    ,open_invoice_curr_cd -- 开票币种代码
    ,sob_type_cd -- 账套类型代码
    ,entry_cd -- 记账机制代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.STACID -- 账套编号
    ,'9999' -- 法人编号
    ,P1.STACNA -- 账套名称
    ,P1.BRCHNA -- 机构名称
    ,P1.CRCYCD -- 币种代码
    ,P1.STARMH -- 启用期间
    ,P1.STACST -- 交易状态代码
    ,P1.CURTMH -- 当前会计期间
    ,P1.CLOSMH -- 已结账期数
    ,${iml_schema}.dateformat_max2(P1.GLISDT) -- 总账日期
    ,P1.REALBL -- 实时计算余额标志
    ,P1.BLNCCK -- 平衡检查标志
    ,P1.KEEPAC -- 需记账标志
    ,P1.VLIDTG -- 账套状态代码
    ,${iml_schema}.dateformat_max2(P1.BSNSDT) -- 业务日期
    ,${iml_schema}.dateformat_max2(P1.ACCTDT) -- 账务日期
    ,P1.CRCYIV -- 开票币种代码
    ,P1.STACTP -- 账套类型代码
    ,nvl(trim(P1.ACCTSY),'-') -- 记账机制代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_com_stac' -- 源表名称
    ,'tglsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_com_stac p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.fin_sob_info_h_tglsf1_tm 
  	                                group by 
  	                                        sob_id
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
        into ${iml_schema}.fin_sob_info_h_tglsf1_cl(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,org_name -- 机构名称
    ,curr_cd -- 币种代码
    ,start_use_duran -- 启用期间
    ,tran_status_cd -- 交易状态代码
    ,curr_acctnt_duran -- 当前会计期间
    ,aldy_stl_perds -- 已结账期数
    ,gl_dt -- 总账日期
    ,realtm_calc_bal_flg -- 实时计算余额标志
    ,balc_check_flg -- 平衡检查标志
    ,need_entry_flg -- 需记账标志
    ,sob_status_cd -- 账套状态代码
    ,bus_dt -- 业务日期
    ,acct_dt -- 账务日期
    ,open_invoice_curr_cd -- 开票币种代码
    ,sob_type_cd -- 账套类型代码
    ,entry_cd -- 记账机制代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.fin_sob_info_h_tglsf1_op(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,org_name -- 机构名称
    ,curr_cd -- 币种代码
    ,start_use_duran -- 启用期间
    ,tran_status_cd -- 交易状态代码
    ,curr_acctnt_duran -- 当前会计期间
    ,aldy_stl_perds -- 已结账期数
    ,gl_dt -- 总账日期
    ,realtm_calc_bal_flg -- 实时计算余额标志
    ,balc_check_flg -- 平衡检查标志
    ,need_entry_flg -- 需记账标志
    ,sob_status_cd -- 账套状态代码
    ,bus_dt -- 业务日期
    ,acct_dt -- 账务日期
    ,open_invoice_curr_cd -- 开票币种代码
    ,sob_type_cd -- 账套类型代码
    ,entry_cd -- 记账机制代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sob_id, o.sob_id) as sob_id -- 账套编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sob_name, o.sob_name) as sob_name -- 账套名称
    ,nvl(n.org_name, o.org_name) as org_name -- 机构名称
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.start_use_duran, o.start_use_duran) as start_use_duran -- 启用期间
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.curr_acctnt_duran, o.curr_acctnt_duran) as curr_acctnt_duran -- 当前会计期间
    ,nvl(n.aldy_stl_perds, o.aldy_stl_perds) as aldy_stl_perds -- 已结账期数
    ,nvl(n.gl_dt, o.gl_dt) as gl_dt -- 总账日期
    ,nvl(n.realtm_calc_bal_flg, o.realtm_calc_bal_flg) as realtm_calc_bal_flg -- 实时计算余额标志
    ,nvl(n.balc_check_flg, o.balc_check_flg) as balc_check_flg -- 平衡检查标志
    ,nvl(n.need_entry_flg, o.need_entry_flg) as need_entry_flg -- 需记账标志
    ,nvl(n.sob_status_cd, o.sob_status_cd) as sob_status_cd -- 账套状态代码
    ,nvl(n.bus_dt, o.bus_dt) as bus_dt -- 业务日期
    ,nvl(n.acct_dt, o.acct_dt) as acct_dt -- 账务日期
    ,nvl(n.open_invoice_curr_cd, o.open_invoice_curr_cd) as open_invoice_curr_cd -- 开票币种代码
    ,nvl(n.sob_type_cd, o.sob_type_cd) as sob_type_cd -- 账套类型代码
    ,nvl(n.entry_cd, o.entry_cd) as entry_cd -- 记账机制代码
    ,case when
            n.sob_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sob_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sob_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.fin_sob_info_h_tglsf1_tm n
    full join (select * from ${iml_schema}.fin_sob_info_h_tglsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.sob_id = n.sob_id
            and o.lp_id = n.lp_id
where (
        o.sob_id is null
        and o.lp_id is null
    )
    or (
        n.sob_id is null
        and n.lp_id is null
    )
    or (
        o.sob_name <> n.sob_name
        or o.org_name <> n.org_name
        or o.curr_cd <> n.curr_cd
        or o.start_use_duran <> n.start_use_duran
        or o.tran_status_cd <> n.tran_status_cd
        or o.curr_acctnt_duran <> n.curr_acctnt_duran
        or o.aldy_stl_perds <> n.aldy_stl_perds
        or o.gl_dt <> n.gl_dt
        or o.realtm_calc_bal_flg <> n.realtm_calc_bal_flg
        or o.balc_check_flg <> n.balc_check_flg
        or o.need_entry_flg <> n.need_entry_flg
        or o.sob_status_cd <> n.sob_status_cd
        or o.bus_dt <> n.bus_dt
        or o.acct_dt <> n.acct_dt
        or o.open_invoice_curr_cd <> n.open_invoice_curr_cd
        or o.sob_type_cd <> n.sob_type_cd
        or o.entry_cd <> n.entry_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.fin_sob_info_h_tglsf1_cl(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,org_name -- 机构名称
    ,curr_cd -- 币种代码
    ,start_use_duran -- 启用期间
    ,tran_status_cd -- 交易状态代码
    ,curr_acctnt_duran -- 当前会计期间
    ,aldy_stl_perds -- 已结账期数
    ,gl_dt -- 总账日期
    ,realtm_calc_bal_flg -- 实时计算余额标志
    ,balc_check_flg -- 平衡检查标志
    ,need_entry_flg -- 需记账标志
    ,sob_status_cd -- 账套状态代码
    ,bus_dt -- 业务日期
    ,acct_dt -- 账务日期
    ,open_invoice_curr_cd -- 开票币种代码
    ,sob_type_cd -- 账套类型代码
    ,entry_cd -- 记账机制代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.fin_sob_info_h_tglsf1_op(
            sob_id -- 账套编号
    ,lp_id -- 法人编号
    ,sob_name -- 账套名称
    ,org_name -- 机构名称
    ,curr_cd -- 币种代码
    ,start_use_duran -- 启用期间
    ,tran_status_cd -- 交易状态代码
    ,curr_acctnt_duran -- 当前会计期间
    ,aldy_stl_perds -- 已结账期数
    ,gl_dt -- 总账日期
    ,realtm_calc_bal_flg -- 实时计算余额标志
    ,balc_check_flg -- 平衡检查标志
    ,need_entry_flg -- 需记账标志
    ,sob_status_cd -- 账套状态代码
    ,bus_dt -- 业务日期
    ,acct_dt -- 账务日期
    ,open_invoice_curr_cd -- 开票币种代码
    ,sob_type_cd -- 账套类型代码
    ,entry_cd -- 记账机制代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sob_id -- 账套编号
    ,o.lp_id -- 法人编号
    ,o.sob_name -- 账套名称
    ,o.org_name -- 机构名称
    ,o.curr_cd -- 币种代码
    ,o.start_use_duran -- 启用期间
    ,o.tran_status_cd -- 交易状态代码
    ,o.curr_acctnt_duran -- 当前会计期间
    ,o.aldy_stl_perds -- 已结账期数
    ,o.gl_dt -- 总账日期
    ,o.realtm_calc_bal_flg -- 实时计算余额标志
    ,o.balc_check_flg -- 平衡检查标志
    ,o.need_entry_flg -- 需记账标志
    ,o.sob_status_cd -- 账套状态代码
    ,o.bus_dt -- 业务日期
    ,o.acct_dt -- 账务日期
    ,o.open_invoice_curr_cd -- 开票币种代码
    ,o.sob_type_cd -- 账套类型代码
    ,o.entry_cd -- 记账机制代码
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
from ${iml_schema}.fin_sob_info_h_tglsf1_bk o
    left join ${iml_schema}.fin_sob_info_h_tglsf1_op n
        on
            o.sob_id = n.sob_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.fin_sob_info_h_tglsf1_cl d
        on
            o.sob_id = d.sob_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.fin_sob_info_h;
--alter table ${iml_schema}.fin_sob_info_h truncate partition for ('tglsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('fin_sob_info_h') 
               and substr(subpartition_name,1,8)=upper('p_tglsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.fin_sob_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.fin_sob_info_h modify partition p_tglsf1 
add subpartition p_tglsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.fin_sob_info_h exchange subpartition p_tglsf1_${batch_date} with table ${iml_schema}.fin_sob_info_h_tglsf1_cl;
alter table ${iml_schema}.fin_sob_info_h exchange subpartition p_tglsf1_20991231 with table ${iml_schema}.fin_sob_info_h_tglsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.fin_sob_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.fin_sob_info_h_tglsf1_tm purge;
drop table ${iml_schema}.fin_sob_info_h_tglsf1_op purge;
drop table ${iml_schema}.fin_sob_info_h_tglsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.fin_sob_info_h_tglsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'fin_sob_info_h', partname => 'p_tglsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
