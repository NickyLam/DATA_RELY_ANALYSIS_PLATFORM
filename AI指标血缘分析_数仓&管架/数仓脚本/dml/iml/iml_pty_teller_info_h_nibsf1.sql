/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_teller_info_h_nibsf1
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
alter table ${iml_schema}.pty_teller_info_h add partition p_nibsf1 values ('nibsf1')(
        subpartition p_nibsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_nibsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_teller_info_h_nibsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_teller_info_h partition for ('nibsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_teller_info_h_nibsf1_tm purge;
drop table ${iml_schema}.pty_teller_info_h_nibsf1_op purge;
drop table ${iml_schema}.pty_teller_info_h_nibsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_teller_info_h_nibsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,teller_id -- 柜员编号
    ,teller_name -- 柜员名称
    ,org_id -- 机构编号
    ,teller_status_cd -- 柜员状态代码
    ,teller_type_cd -- 柜员类型代码
    ,emply_id -- 员工编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_flg -- 客户经理标志
    ,cust_mgr_lev_cd -- 客户经理级别代码
    ,teller_lev_cd -- 柜员级别代码
    ,teller_director_id -- 柜员主管编号
    ,high_teller_flg -- 高柜标志
    ,teller_create_dt -- 柜员创建日期
    ,logon_dt -- 登陆日期
    ,teller_subclass_cd -- 柜员细类代码
    ,teller_empyt_dt  -- 柜员入职日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_teller_info_h partition for ('nibsf1')
where 0=1
;

create table ${iml_schema}.pty_teller_info_h_nibsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_teller_info_h partition for ('nibsf1') where 0=1;

create table ${iml_schema}.pty_teller_info_h_nibsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_teller_info_h partition for ('nibsf1') where 0=1;

-- 3.1 get new data into table
-- nibs_ib_upm_user_info_1
insert into ${iml_schema}.pty_teller_info_h_nibsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,teller_id -- 柜员编号
    ,teller_name -- 柜员名称
    ,org_id -- 机构编号
    ,teller_status_cd -- 柜员状态代码
    ,teller_type_cd -- 柜员类型代码
    ,emply_id -- 员工编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_flg -- 客户经理标志
    ,cust_mgr_lev_cd -- 客户经理级别代码
    ,teller_lev_cd -- 柜员级别代码
    ,teller_director_id -- 柜员主管编号
    ,high_teller_flg -- 高柜标志
    ,teller_create_dt -- 柜员创建日期
    ,logon_dt -- 登陆日期
    ,teller_subclass_cd -- 柜员细类代码
    ,teller_empyt_dt  -- 柜员入职日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102073'||P1.USERNUM -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.USERNUM -- 柜员编号
    ,P1.SURNAME||P1.USERNAME -- 柜员名称
    ,P1.BRANCHNUM -- 机构编号
    ,P1.USERSTATUS -- 柜员状态代码
    ,' ' -- 柜员类型代码
    ,P1.EMPLOYEEID -- 员工编号
    ,' ' -- 客户经理编号
    ,P1.MANAGERTYPE -- 客户经理标志
    ,P1.MANAGERLEVEL -- 客户经理级别代码
    ,P1.USERLEVEL -- 柜员级别代码
    ,P1.TELLERMANAGERID -- 柜员主管编号
    ,P1.HIGHTLOWFALG -- 高柜标志
    ,${iml_schema}.dateformat_min(NULL) -- 柜员创建日期
    ,${iml_schema}.dateformat_min(P1.LOGINTIME) -- 登陆日期
    ,' ' -- 柜员细类代码
    ,${iml_schema}.dateformat_min(P1.THEENTRYDATE)  -- 柜员入职日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nibs_ib_upm_user_info' -- 源表名称
    ,'nibsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nibs_ib_upm_user_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_teller_info_h_nibsf1_tm 
  	                                group by 
  	                                        party_id
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
        into ${iml_schema}.pty_teller_info_h_nibsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,teller_id -- 柜员编号
    ,teller_name -- 柜员名称
    ,org_id -- 机构编号
    ,teller_status_cd -- 柜员状态代码
    ,teller_type_cd -- 柜员类型代码
    ,emply_id -- 员工编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_flg -- 客户经理标志
    ,cust_mgr_lev_cd -- 客户经理级别代码
    ,teller_lev_cd -- 柜员级别代码
    ,teller_director_id -- 柜员主管编号
    ,high_teller_flg -- 高柜标志
    ,teller_create_dt -- 柜员创建日期
    ,logon_dt -- 登陆日期
    ,teller_subclass_cd -- 柜员细类代码
    ,teller_empyt_dt  -- 柜员入职日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_teller_info_h_nibsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,teller_id -- 柜员编号
    ,teller_name -- 柜员名称
    ,org_id -- 机构编号
    ,teller_status_cd -- 柜员状态代码
    ,teller_type_cd -- 柜员类型代码
    ,emply_id -- 员工编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_flg -- 客户经理标志
    ,cust_mgr_lev_cd -- 客户经理级别代码
    ,teller_lev_cd -- 柜员级别代码
    ,teller_director_id -- 柜员主管编号
    ,high_teller_flg -- 高柜标志
    ,teller_create_dt -- 柜员创建日期
    ,logon_dt -- 登陆日期
    ,teller_subclass_cd -- 柜员细类代码
    ,teller_empyt_dt  -- 柜员入职日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.teller_id, o.teller_id) as teller_id -- 柜员编号
    ,nvl(n.teller_name, o.teller_name) as teller_name -- 柜员名称
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.teller_status_cd, o.teller_status_cd) as teller_status_cd -- 柜员状态代码
    ,nvl(n.teller_type_cd, o.teller_type_cd) as teller_type_cd -- 柜员类型代码
    ,nvl(n.emply_id, o.emply_id) as emply_id -- 员工编号
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.cust_mgr_flg, o.cust_mgr_flg) as cust_mgr_flg -- 客户经理标志
    ,nvl(n.cust_mgr_lev_cd, o.cust_mgr_lev_cd) as cust_mgr_lev_cd -- 客户经理级别代码
    ,nvl(n.teller_lev_cd, o.teller_lev_cd) as teller_lev_cd -- 柜员级别代码
    ,nvl(n.teller_director_id, o.teller_director_id) as teller_director_id -- 柜员主管编号
    ,nvl(n.high_teller_flg, o.high_teller_flg) as high_teller_flg -- 高柜标志
    ,nvl(n.teller_create_dt, o.teller_create_dt) as teller_create_dt -- 柜员创建日期
    ,nvl(n.logon_dt, o.logon_dt) as logon_dt -- 登陆日期
    ,nvl(n.teller_subclass_cd, o.teller_subclass_cd) as teller_subclass_cd -- 柜员细类代码
    ,nvl(n.teller_empyt_dt, o.teller_empyt_dt) as teller_empyt_dt -- 柜员入职日期
    ,case when
            n.party_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_teller_info_h_nibsf1_tm n
    full join (select * from ${iml_schema}.pty_teller_info_h_nibsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
where (
        o.party_id is null
        and o.lp_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
    )
    or (
        o.teller_id <> n.teller_id
        or o.teller_name <> n.teller_name
        or o.org_id <> n.org_id
        or o.teller_status_cd <> n.teller_status_cd
        or o.teller_type_cd <> n.teller_type_cd
        or o.emply_id <> n.emply_id
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.cust_mgr_flg <> n.cust_mgr_flg
        or o.cust_mgr_lev_cd <> n.cust_mgr_lev_cd
        or o.teller_lev_cd <> n.teller_lev_cd
        or o.teller_director_id <> n.teller_director_id
        or o.high_teller_flg <> n.high_teller_flg
        or o.teller_create_dt <> n.teller_create_dt
        or o.logon_dt <> n.logon_dt
        or o.teller_subclass_cd <> n.teller_subclass_cd
        or o.teller_empyt_dt <> n.teller_empyt_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_teller_info_h_nibsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,teller_id -- 柜员编号
    ,teller_name -- 柜员名称
    ,org_id -- 机构编号
    ,teller_status_cd -- 柜员状态代码
    ,teller_type_cd -- 柜员类型代码
    ,emply_id -- 员工编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_flg -- 客户经理标志
    ,cust_mgr_lev_cd -- 客户经理级别代码
    ,teller_lev_cd -- 柜员级别代码
    ,teller_director_id -- 柜员主管编号
    ,high_teller_flg -- 高柜标志
    ,teller_create_dt -- 柜员创建日期
    ,logon_dt -- 登陆日期
    ,teller_subclass_cd -- 柜员细类代码
    ,teller_empyt_dt  -- 柜员入职日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_teller_info_h_nibsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,teller_id -- 柜员编号
    ,teller_name -- 柜员名称
    ,org_id -- 机构编号
    ,teller_status_cd -- 柜员状态代码
    ,teller_type_cd -- 柜员类型代码
    ,emply_id -- 员工编号
    ,cust_mgr_id -- 客户经理编号
    ,cust_mgr_flg -- 客户经理标志
    ,cust_mgr_lev_cd -- 客户经理级别代码
    ,teller_lev_cd -- 柜员级别代码
    ,teller_director_id -- 柜员主管编号
    ,high_teller_flg -- 高柜标志
    ,teller_create_dt -- 柜员创建日期
    ,logon_dt -- 登陆日期
    ,teller_subclass_cd -- 柜员细类代码
    ,teller_empyt_dt  -- 柜员入职日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.teller_id -- 柜员编号
    ,o.teller_name -- 柜员名称
    ,o.org_id -- 机构编号
    ,o.teller_status_cd -- 柜员状态代码
    ,o.teller_type_cd -- 柜员类型代码
    ,o.emply_id -- 员工编号
    ,o.cust_mgr_id -- 客户经理编号
    ,o.cust_mgr_flg -- 客户经理标志
    ,o.cust_mgr_lev_cd -- 客户经理级别代码
    ,o.teller_lev_cd -- 柜员级别代码
    ,o.teller_director_id -- 柜员主管编号
    ,o.high_teller_flg -- 高柜标志
    ,o.teller_create_dt -- 柜员创建日期
    ,o.logon_dt -- 登陆日期
    ,o.teller_subclass_cd -- 柜员细类代码
    ,o.teller_empyt_dt  -- 柜员入职日期
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
from ${iml_schema}.pty_teller_info_h_nibsf1_bk o
    left join ${iml_schema}.pty_teller_info_h_nibsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_teller_info_h_nibsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_teller_info_h;
--alter table ${iml_schema}.pty_teller_info_h truncate partition for ('nibsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_teller_info_h') 
               and substr(subpartition_name,1,8)=upper('p_nibsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_teller_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_teller_info_h modify partition p_nibsf1 
add subpartition p_nibsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

whenever sqlerror exit sql.sqlcode;
-- 4.3 exchange partition
alter table ${iml_schema}.pty_teller_info_h exchange subpartition p_nibsf1_${batch_date} with table ${iml_schema}.pty_teller_info_h_nibsf1_cl;
alter table ${iml_schema}.pty_teller_info_h exchange subpartition p_nibsf1_20991231 with table ${iml_schema}.pty_teller_info_h_nibsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_teller_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_teller_info_h_nibsf1_tm purge;
drop table ${iml_schema}.pty_teller_info_h_nibsf1_op purge;
drop table ${iml_schema}.pty_teller_info_h_nibsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_teller_info_h_nibsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_teller_info_h', partname => 'p_nibsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
