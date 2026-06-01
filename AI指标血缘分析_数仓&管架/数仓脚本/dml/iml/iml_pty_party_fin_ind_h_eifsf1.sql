/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_party_fin_ind_h_eifsf1
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
alter table ${iml_schema}.pty_party_fin_ind_h add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_party_fin_ind_h_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_fin_ind_h partition for ('eifsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_party_fin_ind_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_fin_ind_h_eifsf1_op purge;
drop table ${iml_schema}.pty_party_fin_ind_h_eifsf1_cl purge;
drop table ${iml_schema}.pty_party_fin_ind_h_eifsf1_tmp purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_fin_ind_h_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    fin_ind_cd -- 财务指标代码
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,ind_val -- 指标值
    ,sal_acct_num -- 工资账号
    ,open_acct_bank -- 工资账号开户银行
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_fin_ind_h partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_party_fin_ind_h_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_fin_ind_h partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_party_fin_ind_h_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party_fin_ind_h partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_party_fin_ind_h_eifsf1_tmp nologging
compress ${option_switch} for query high
as
(select t.*,
             row_number() over(partition by party_id order by updated_ts desc) rn
        from ${iol_schema}.eifs_t01_per_cust_ext_info t
       where t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
         and t.end_dt > to_date('${batch_date}', 'yyyymmdd'))
;

-- 3.1 get new data into table
-- eifs_t01_corp_rel_per_info-1
insert into ${iml_schema}.pty_party_fin_ind_h_eifsf1_tm(
    fin_ind_cd -- 财务指标代码
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,ind_val -- 指标值
    ,sal_acct_num -- 工资账号
    ,open_acct_bank -- 工资账号开户银行
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '0101' -- 财务指标代码
    ,P1.REL_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,P1.MON_IN -- 指标值
    ,' ' -- 工资账号
    ,' ' -- 工资账号开户银行
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_rel_per_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_rel_per_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- eifs_t01_per_cust_ext_info-1
insert into ${iml_schema}.pty_party_fin_ind_h_eifsf1_tm(
    fin_ind_cd -- 财务指标代码
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,ind_val -- 指标值
    ,sal_acct_num -- 工资账号
    ,open_acct_bank -- 工资账号开户银行
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '0101' -- 财务指标代码
    ,P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,P1.MON_IN -- 指标值
    ,P1.SALARY_ACC_NUM -- 工资账号
    ,P1.SALARY_ACC_NUM_BANK -- 工资账号开户银行
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_cust_ext_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_fin_ind_h_eifsf1_tmp p1
left join ${iol_schema}.eifs_t00_per_cust_no_ref p2
  on p1.party_id = p2.party_id
 and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
where p1.rn = 1
;
commit;

-- eifs_t01_per_cust_ext_info-2
insert into ${iml_schema}.pty_party_fin_ind_h_eifsf1_tm(
    fin_ind_cd -- 财务指标代码
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,ind_val -- 指标值
    ,sal_acct_num -- 工资账号
    ,open_acct_bank -- 工资账号开户银行
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '0106' -- 财务指标代码
    ,P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,P1.YEAR_IN -- 指标值
    ,P1.SALARY_ACC_NUM -- 工资账号
    ,P1.SALARY_ACC_NUM_BANK -- 工资账号开户银行
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_cust_ext_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_fin_ind_h_eifsf1_tmp p1
left join ${iol_schema}.eifs_t00_per_cust_no_ref p2
  on p1.party_id = p2.party_id
 and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
where p1.rn = 1
;
commit;

-- eifs_t01_per_cust_ext_info-3
insert into ${iml_schema}.pty_party_fin_ind_h_eifsf1_tm(
    fin_ind_cd -- 财务指标代码
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,ind_val -- 指标值
    ,sal_acct_num -- 工资账号
    ,open_acct_bank -- 工资账号开户银行
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '0103' -- 财务指标代码
    ,P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,P1.FAMILY_MON_IN -- 指标值
    ,P1.SALARY_ACC_NUM -- 工资账号
    ,P1.SALARY_ACC_NUM_BANK -- 工资账号开户银行
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_cust_ext_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_fin_ind_h_eifsf1_tmp p1
left join ${iol_schema}.eifs_t00_per_cust_no_ref p2
  on p1.party_id = p2.party_id
 and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
where p1.rn = 1
;
commit;

-- eifs_t01_per_cust_ext_info-4
insert into ${iml_schema}.pty_party_fin_ind_h_eifsf1_tm(
    fin_ind_cd -- 财务指标代码
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,ind_val -- 指标值
    ,sal_acct_num -- 工资账号
    ,open_acct_bank -- 工资账号开户银行
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '0111' -- 财务指标代码
    ,P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,P1.FAMILY_IN -- 指标值
    ,P1.SALARY_ACC_NUM -- 工资账号
    ,P1.SALARY_ACC_NUM_BANK -- 工资账号开户银行
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_cust_ext_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_fin_ind_h_eifsf1_tmp p1
left join ${iol_schema}.eifs_t00_per_cust_no_ref p2
  on p1.party_id = p2.party_id
 and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
where p1.rn = 1
;
commit;

-- eifs_t01_per_cust_ext_info-5
insert into ${iml_schema}.pty_party_fin_ind_h_eifsf1_tm(
    fin_ind_cd -- 财务指标代码
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,ind_val -- 指标值
    ,sal_acct_num -- 工资账号
    ,open_acct_bank -- 工资账号开户银行
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '0112' -- 财务指标代码
    ,P2.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,'EIFS' -- 源系统代码
    ,P1.TAX_YEAR_IN -- 指标值
    ,P1.SALARY_ACC_NUM -- 工资账号
    ,P1.SALARY_ACC_NUM_BANK -- 工资账号开户银行
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_cust_ext_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_fin_ind_h_eifsf1_tmp p1
left join ${iol_schema}.eifs_t00_per_cust_no_ref p2
  on p1.party_id = p2.party_id
 and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
where p1.rn = 1
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_party_fin_ind_h_eifsf1_tm 
  	                                group by 
  	                                        fin_ind_cd
  	                                        ,party_id
  	                                        ,lp_id
  	                                        ,sorc_sys_cd
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
        into ${iml_schema}.pty_party_fin_ind_h_eifsf1_cl(
            fin_ind_cd -- 财务指标代码
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,ind_val -- 指标值
    ,sal_acct_num -- 工资账号
    ,open_acct_bank -- 工资账号开户银行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_fin_ind_h_eifsf1_op(
            fin_ind_cd -- 财务指标代码
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,ind_val -- 指标值
    ,sal_acct_num -- 工资账号
    ,open_acct_bank -- 工资账号开户银行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fin_ind_cd, o.fin_ind_cd) as fin_ind_cd -- 财务指标代码
    ,nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sorc_sys_cd, o.sorc_sys_cd) as sorc_sys_cd -- 源系统代码
    ,nvl(n.ind_val, o.ind_val) as ind_val -- 指标值
    ,nvl(n.sal_acct_num, o.sal_acct_num) as sal_acct_num -- 工资账号
    ,nvl(n.open_acct_bank, o.open_acct_bank) as open_acct_bank -- 工资账号开户银行
    ,case when
            n.fin_ind_cd is null
            and n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fin_ind_cd is null
            and n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fin_ind_cd is null
            and n.party_id is null
            and n.lp_id is null
            and n.sorc_sys_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party_fin_ind_h_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_party_fin_ind_h_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.fin_ind_cd = n.fin_ind_cd
            and o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
where (
        o.fin_ind_cd is null
        and o.party_id is null
        and o.lp_id is null
        and o.sorc_sys_cd is null
    )
    or (
        n.fin_ind_cd is null
        and n.party_id is null
        and n.lp_id is null
        and n.sorc_sys_cd is null
    )
    or (
        o.ind_val <> n.ind_val
        or o.sal_acct_num <> n.sal_acct_num
        or o.open_acct_bank <> n.open_acct_bank
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_party_fin_ind_h_eifsf1_cl(
            fin_ind_cd -- 财务指标代码
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,ind_val -- 指标值
    ,sal_acct_num -- 工资账号
    ,open_acct_bank -- 工资账号开户银行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_party_fin_ind_h_eifsf1_op(
            fin_ind_cd -- 财务指标代码
    ,party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,ind_val -- 指标值
    ,sal_acct_num -- 工资账号
    ,open_acct_bank -- 工资账号开户银行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fin_ind_cd -- 财务指标代码
    ,o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.sorc_sys_cd -- 源系统代码
    ,o.ind_val -- 指标值
    ,o.sal_acct_num -- 工资账号
    ,o.open_acct_bank -- 工资账号开户银行
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
from ${iml_schema}.pty_party_fin_ind_h_eifsf1_bk o
    left join ${iml_schema}.pty_party_fin_ind_h_eifsf1_op n
        on
            o.fin_ind_cd = n.fin_ind_cd
            and o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_party_fin_ind_h_eifsf1_cl d
        on
            o.fin_ind_cd = d.fin_ind_cd
            and o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.sorc_sys_cd = d.sorc_sys_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_party_fin_ind_h;
--alter table ${iml_schema}.pty_party_fin_ind_h truncate partition for ('eifsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_party_fin_ind_h') 
               and substr(subpartition_name,1,8)=upper('p_eifsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_party_fin_ind_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_party_fin_ind_h modify partition p_eifsf1 
add subpartition p_eifsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

whenever sqlerror exit sql.sqlcode;
-- 4.3 exchange partition
alter table ${iml_schema}.pty_party_fin_ind_h exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_party_fin_ind_h_eifsf1_cl;
alter table ${iml_schema}.pty_party_fin_ind_h exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_party_fin_ind_h_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_party_fin_ind_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_party_fin_ind_h_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_fin_ind_h_eifsf1_op purge;
drop table ${iml_schema}.pty_party_fin_ind_h_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_party_fin_ind_h_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_party_fin_ind_h', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
