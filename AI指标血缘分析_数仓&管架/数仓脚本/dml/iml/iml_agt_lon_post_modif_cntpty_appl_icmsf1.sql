/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lon_post_modif_cntpty_appl_icmsf1
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
alter table ${iml_schema}.agt_lon_post_modif_cntpty_appl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lon_post_modif_cntpty_appl partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,on_acct_id -- 挂账编号
    ,tran_flow_num -- 交易流水号
    ,cntpty_name -- 交易对手名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_bank_no -- 交易对手行号
    ,cntpty_bank_name -- 交易对手行名称
    ,tran_amt -- 交易金额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lon_post_modif_cntpty_appl partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lon_post_modif_cntpty_appl partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lon_post_modif_cntpty_appl partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_acct_cntrpty-1
insert into ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,on_acct_id -- 挂账编号
    ,tran_flow_num -- 交易流水号
    ,cntpty_name -- 交易对手名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_bank_no -- 交易对手行号
    ,cntpty_bank_name -- 交易对手行名称
    ,tran_amt -- 交易金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.RELATIVEOBJECTTYPE -- 对象类型名称
    ,P1.RELATIVEOBJECTNO -- 对象编号
    ,P1.HANGSEQNO -- 挂账编号
    ,P1.SERIALNO -- 交易流水号
    ,P1.CNTRPTYNAME -- 交易对手名称
    ,P1.OTHREALBASEACCTNO -- 交易对手账户编号
    ,P1.CONTRABANKCODE -- 交易对手行号
    ,P1.CONTRABANKNAME -- 交易对手行名称
    ,P1.TRANAMT -- 交易金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_acct_cntrpty' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_acct_cntrpty p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_tm 
  	                                group by 
  	                                        appl_id
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
        into ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,on_acct_id -- 挂账编号
    ,tran_flow_num -- 交易流水号
    ,cntpty_name -- 交易对手名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_bank_no -- 交易对手行号
    ,cntpty_bank_name -- 交易对手行名称
    ,tran_amt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,on_acct_id -- 挂账编号
    ,tran_flow_num -- 交易流水号
    ,cntpty_name -- 交易对手名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_bank_no -- 交易对手行号
    ,cntpty_bank_name -- 交易对手行名称
    ,tran_amt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.obj_type_name, o.obj_type_name) as obj_type_name -- 对象类型名称
    ,nvl(n.obj_id, o.obj_id) as obj_id -- 对象编号
    ,nvl(n.on_acct_id, o.on_acct_id) as on_acct_id -- 挂账编号
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 交易对手名称
    ,nvl(n.cntpty_acct_id, o.cntpty_acct_id) as cntpty_acct_id -- 交易对手账户编号
    ,nvl(n.cntpty_bank_no, o.cntpty_bank_no) as cntpty_bank_no -- 交易对手行号
    ,nvl(n.cntpty_bank_name, o.cntpty_bank_name) as cntpty_bank_name -- 交易对手行名称
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
where (
        o.appl_id is null
        and o.lp_id is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
    )
    or (
        o.obj_type_name <> n.obj_type_name
        or o.obj_id <> n.obj_id
        or o.on_acct_id <> n.on_acct_id
        or o.tran_flow_num <> n.tran_flow_num
        or o.cntpty_name <> n.cntpty_name
        or o.cntpty_acct_id <> n.cntpty_acct_id
        or o.cntpty_bank_no <> n.cntpty_bank_no
        or o.cntpty_bank_name <> n.cntpty_bank_name
        or o.tran_amt <> n.tran_amt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,on_acct_id -- 挂账编号
    ,tran_flow_num -- 交易流水号
    ,cntpty_name -- 交易对手名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_bank_no -- 交易对手行号
    ,cntpty_bank_name -- 交易对手行名称
    ,tran_amt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,obj_type_name -- 对象类型名称
    ,obj_id -- 对象编号
    ,on_acct_id -- 挂账编号
    ,tran_flow_num -- 交易流水号
    ,cntpty_name -- 交易对手名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_bank_no -- 交易对手行号
    ,cntpty_bank_name -- 交易对手行名称
    ,tran_amt -- 交易金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.obj_type_name -- 对象类型名称
    ,o.obj_id -- 对象编号
    ,o.on_acct_id -- 挂账编号
    ,o.tran_flow_num -- 交易流水号
    ,o.cntpty_name -- 交易对手名称
    ,o.cntpty_acct_id -- 交易对手账户编号
    ,o.cntpty_bank_no -- 交易对手行号
    ,o.cntpty_bank_name -- 交易对手行名称
    ,o.tran_amt -- 交易金额
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
from ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_bk o
    left join ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_lon_post_modif_cntpty_appl;
--alter table ${iml_schema}.agt_lon_post_modif_cntpty_appl truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lon_post_modif_cntpty_appl') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lon_post_modif_cntpty_appl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lon_post_modif_cntpty_appl modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lon_post_modif_cntpty_appl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_cl;
alter table ${iml_schema}.agt_lon_post_modif_cntpty_appl exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lon_post_modif_cntpty_appl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lon_post_modif_cntpty_appl_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lon_post_modif_cntpty_appl', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
