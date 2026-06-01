/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_bond_info_icmsf1
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
alter table ${iml_schema}.ast_col_bond_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_bond_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_bond_info partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ast_col_bond_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_bond_info_icmsf1_op purge;
drop table ${iml_schema}.ast_col_bond_info_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_bond_info_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    col_id -- 押品编号
    ,lp_id -- 法人编号
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_qtty -- 债券数量
    ,bond_have_ext_bond_item_rating_flg -- 债券有外部债项评级标志
    ,bond_ext_rating_cd -- 债券外部评级代码
    ,fac_val_amt -- 票面金额
    ,fac_val_nv -- 票面净值
    ,curr_cd -- 币种代码
    ,int_rat -- 利率
    ,issue_dt -- 发行日期
    ,exp_dt -- 到期日期
    ,other_comnt -- 其他说明
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_bond_info partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.ast_col_bond_info_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_bond_info partition for ('icmsf1') where 0=1;

create table ${iml_schema}.ast_col_bond_info_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_bond_info partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_clr_asset_finance_debt-1
insert into ${iml_schema}.ast_col_bond_info_icmsf1_tm(
    col_id -- 押品编号
    ,lp_id -- 法人编号
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_qtty -- 债券数量
    ,bond_have_ext_bond_item_rating_flg -- 债券有外部债项评级标志
    ,bond_ext_rating_cd -- 债券外部评级代码
    ,fac_val_amt -- 票面金额
    ,fac_val_nv -- 票面净值
    ,curr_cd -- 币种代码
    ,int_rat -- 利率
    ,issue_dt -- 发行日期
    ,exp_dt -- 到期日期
    ,other_comnt -- 其他说明
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CLRID -- 押品编号
    ,'9999' -- 法人编号
    ,P1.DEBTCODE -- 债券编号
    ,P1.DEBTNAME -- 债券名称
    ,P1.AMOUNT -- 债券数量
    ,nvl(trim(P1.ISHAVEOUTRATING),'-') -- 债券有外部债项评级标志
    ,nvl(trim(P1.OUTRATINGRESULT),'-') -- 债券外部评级代码
    ,P1.FACEAMOUNT -- 票面金额
    ,P1.ACTUALLYAMOUNT -- 票面净值
    ,nvl(trim(P1.TDCURRENCY),'-') -- 币种代码
    ,P1.RATE -- 利率
    ,P1.STARTDATE -- 发行日期
    ,P1.ENDDATE -- 到期日期
    ,P1.REMARK -- 其他说明
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_clr_asset_finance_debt' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_clr_asset_finance_debt p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_bond_info_icmsf1_tm 
  	                                group by 
  	                                        col_id
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
        into ${iml_schema}.ast_col_bond_info_icmsf1_cl(
            col_id -- 押品编号
    ,lp_id -- 法人编号
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_qtty -- 债券数量
    ,bond_have_ext_bond_item_rating_flg -- 债券有外部债项评级标志
    ,bond_ext_rating_cd -- 债券外部评级代码
    ,fac_val_amt -- 票面金额
    ,fac_val_nv -- 票面净值
    ,curr_cd -- 币种代码
    ,int_rat -- 利率
    ,issue_dt -- 发行日期
    ,exp_dt -- 到期日期
    ,other_comnt -- 其他说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_bond_info_icmsf1_op(
            col_id -- 押品编号
    ,lp_id -- 法人编号
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_qtty -- 债券数量
    ,bond_have_ext_bond_item_rating_flg -- 债券有外部债项评级标志
    ,bond_ext_rating_cd -- 债券外部评级代码
    ,fac_val_amt -- 票面金额
    ,fac_val_nv -- 票面净值
    ,curr_cd -- 币种代码
    ,int_rat -- 利率
    ,issue_dt -- 发行日期
    ,exp_dt -- 到期日期
    ,other_comnt -- 其他说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.col_id, o.col_id) as col_id -- 押品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bond_id, o.bond_id) as bond_id -- 债券编号
    ,nvl(n.bond_name, o.bond_name) as bond_name -- 债券名称
    ,nvl(n.bond_qtty, o.bond_qtty) as bond_qtty -- 债券数量
    ,nvl(n.bond_have_ext_bond_item_rating_flg, o.bond_have_ext_bond_item_rating_flg) as bond_have_ext_bond_item_rating_flg -- 债券有外部债项评级标志
    ,nvl(n.bond_ext_rating_cd, o.bond_ext_rating_cd) as bond_ext_rating_cd -- 债券外部评级代码
    ,nvl(n.fac_val_amt, o.fac_val_amt) as fac_val_amt -- 票面金额
    ,nvl(n.fac_val_nv, o.fac_val_nv) as fac_val_nv -- 票面净值
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.int_rat, o.int_rat) as int_rat -- 利率
    ,nvl(n.issue_dt, o.issue_dt) as issue_dt -- 发行日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,case when
            n.col_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.col_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.col_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_bond_info_icmsf1_tm n
    full join (select * from ${iml_schema}.ast_col_bond_info_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.col_id = n.col_id
            and o.lp_id = n.lp_id
where (
        o.col_id is null
        and o.lp_id is null
    )
    or (
        n.col_id is null
        and n.lp_id is null
    )
    or (
        o.bond_id <> n.bond_id
        or o.bond_name <> n.bond_name
        or o.bond_qtty <> n.bond_qtty
        or o.bond_have_ext_bond_item_rating_flg <> n.bond_have_ext_bond_item_rating_flg
        or o.bond_ext_rating_cd <> n.bond_ext_rating_cd
        or o.fac_val_amt <> n.fac_val_amt
        or o.fac_val_nv <> n.fac_val_nv
        or o.curr_cd <> n.curr_cd
        or o.int_rat <> n.int_rat
        or o.issue_dt <> n.issue_dt
        or o.exp_dt <> n.exp_dt
        or o.other_comnt <> n.other_comnt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ast_col_bond_info_icmsf1_cl(
            col_id -- 押品编号
    ,lp_id -- 法人编号
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_qtty -- 债券数量
    ,bond_have_ext_bond_item_rating_flg -- 债券有外部债项评级标志
    ,bond_ext_rating_cd -- 债券外部评级代码
    ,fac_val_amt -- 票面金额
    ,fac_val_nv -- 票面净值
    ,curr_cd -- 币种代码
    ,int_rat -- 利率
    ,issue_dt -- 发行日期
    ,exp_dt -- 到期日期
    ,other_comnt -- 其他说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ast_col_bond_info_icmsf1_op(
            col_id -- 押品编号
    ,lp_id -- 法人编号
    ,bond_id -- 债券编号
    ,bond_name -- 债券名称
    ,bond_qtty -- 债券数量
    ,bond_have_ext_bond_item_rating_flg -- 债券有外部债项评级标志
    ,bond_ext_rating_cd -- 债券外部评级代码
    ,fac_val_amt -- 票面金额
    ,fac_val_nv -- 票面净值
    ,curr_cd -- 币种代码
    ,int_rat -- 利率
    ,issue_dt -- 发行日期
    ,exp_dt -- 到期日期
    ,other_comnt -- 其他说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.col_id -- 押品编号
    ,o.lp_id -- 法人编号
    ,o.bond_id -- 债券编号
    ,o.bond_name -- 债券名称
    ,o.bond_qtty -- 债券数量
    ,o.bond_have_ext_bond_item_rating_flg -- 债券有外部债项评级标志
    ,o.bond_ext_rating_cd -- 债券外部评级代码
    ,o.fac_val_amt -- 票面金额
    ,o.fac_val_nv -- 票面净值
    ,o.curr_cd -- 币种代码
    ,o.int_rat -- 利率
    ,o.issue_dt -- 发行日期
    ,o.exp_dt -- 到期日期
    ,o.other_comnt -- 其他说明
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
from ${iml_schema}.ast_col_bond_info_icmsf1_bk o
    left join ${iml_schema}.ast_col_bond_info_icmsf1_op n
        on
            o.col_id = n.col_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ast_col_bond_info_icmsf1_cl d
        on
            o.col_id = d.col_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ast_col_bond_info;
--alter table ${iml_schema}.ast_col_bond_info truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ast_col_bond_info') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ast_col_bond_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_bond_info modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ast_col_bond_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ast_col_bond_info_icmsf1_cl;
alter table ${iml_schema}.ast_col_bond_info exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.ast_col_bond_info_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_bond_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ast_col_bond_info_icmsf1_tm purge;
drop table ${iml_schema}.ast_col_bond_info_icmsf1_op purge;
drop table ${iml_schema}.ast_col_bond_info_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ast_col_bond_info_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_bond_info', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
