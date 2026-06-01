/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_teller_uussf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_teller_uussf1_tm purge;
drop table ${iml_schema}.pty_teller_uussf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_teller add partition p_uussf1 values ('uussf1')(
        subpartition p_uussf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_teller modify partition p_uussf1
    add subpartition p_uussf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_teller_uussf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_teller partition for ('uussf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_teller_uussf1_tm
compress ${option_switch} for query high
as
select
    emply_id -- 员工编号
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_org_id -- 所属机构编号
    ,teller_id -- 柜员编号
    ,belong_dept_id -- 归属部门编号
    ,teller_status_cd -- 柜员状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_teller
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_teller_uussf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_teller partition for ('uussf1') where 0=1;

-- 2.1 insert data to tm table
-- uuss_uus_tellerno-
insert into ${iml_schema}.pty_teller_uussf1_tm(
    party_id -- 员工编号
    ,emply_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_org_id -- 所属机构编号
    ,teller_id -- 柜员编号
    ,belong_dept_id -- 归属部门编号
    ,teller_status_cd -- 柜员状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201003'||P1.EMPLOYEEID -- 员工编号
    ,P1.EMPLOYEEID -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.ATTACHORGAN -- 所属机构编号
    ,P1.TELLERNO -- 柜员编号
    ,P1.ORGANCODE -- 归属部门编号
    ,P1.STATUS -- 柜员状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'uuss_uus_tellerno' -- 源表名称
    ,'uussf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.uuss_uus_tellerno p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_teller_uussf1_tm 
  	                                group by 
  	                                        lp_id
  	                                        ,teller_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.pty_teller_uussf1_ex(
    emply_id -- 员工编号
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,belong_org_id -- 所属机构编号
    ,teller_id -- 柜员编号
    ,belong_dept_id -- 归属部门编号
    ,teller_status_cd -- 柜员状态代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.emply_id, o.emply_id) as emply_id -- 员工编号
    ,nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.teller_id, o.teller_id) as teller_id -- 柜员编号
    ,nvl(n.belong_dept_id, o.belong_dept_id) as belong_dept_id -- 归属部门编号
    ,nvl(n.teller_status_cd, o.teller_status_cd) as teller_status_cd -- 柜员状态代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.lp_id is null
                and o.teller_id is null
            ) or (
                o.emply_id <> n.emply_id
                or o.party_id <> n.party_id
                or o.belong_org_id <> n.belong_org_id
                or o.belong_dept_id <> n.belong_dept_id
                or o.teller_status_cd <> n.teller_status_cd
            ) or (
                 case when (
                           n.lp_id is null
                           and n.teller_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.lp_id is null
                and n.teller_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_teller_uussf1_tm n
    full join ${iml_schema}.pty_teller_uussf1_bk o
        on
            o.lp_id = n.lp_id
            and o.teller_id = n.teller_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_teller truncate partition for ('uussf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_teller exchange subpartition p_uussf1_${batch_date} with table ${iml_schema}.pty_teller_uussf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_teller drop subpartition p_uussf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_teller to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_teller_uussf1_tm purge;
drop table ${iml_schema}.pty_teller_uussf1_ex purge;
drop table ${iml_schema}.pty_teller_uussf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_teller', partname => 'p_uussf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);