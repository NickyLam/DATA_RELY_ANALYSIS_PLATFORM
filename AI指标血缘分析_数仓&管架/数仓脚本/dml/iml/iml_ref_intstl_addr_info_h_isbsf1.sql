/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_intstl_addr_info_h_isbsf1
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
alter table ${iml_schema}.ref_intstl_addr_info_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_intstl_addr_info_h partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_tm purge;
drop table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_op purge;
drop table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    addr_id -- 地址编号
    ,addr_idf -- 地址标识
    ,addr_desc -- 地址描述
    ,advise_bank_swift_id -- 通知行SWIFT编号
    ,e_mail -- 电子邮箱
    ,street_addr -- 街道地址
    ,zip_cd -- 邮政编码
    ,cty_rg_cd -- 国家代码
    ,dist_cd -- 行政区划代码
    ,mailbox_num -- 邮箱号码
    ,tel_num -- 电话号码
    ,pbc_name -- 人行名称
    ,pbc_addr -- 人行地址
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_intstl_addr_info_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_intstl_addr_info_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_intstl_addr_info_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_adr-1
insert into ${iml_schema}.ref_intstl_addr_info_h_isbsf1_tm(
    addr_id -- 地址编号
    ,addr_idf -- 地址标识
    ,addr_desc -- 地址描述
    ,advise_bank_swift_id -- 通知行SWIFT编号
    ,e_mail -- 电子邮箱
    ,street_addr -- 街道地址
    ,zip_cd -- 邮政编码
    ,cty_rg_cd -- 国家代码
    ,dist_cd -- 行政区划代码
    ,mailbox_num -- 邮箱号码
    ,tel_num -- 电话号码
    ,pbc_name -- 人行名称
    ,pbc_addr -- 人行地址
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.INR -- 地址编号
    ,P1.EXTKEY -- 地址标识
    ,P1.NAM -- 地址描述
    ,P1.BIC -- 通知行SWIFT编号
    ,P1.EML -- 电子邮箱
    ,P1.STR1 -- 街道地址
    ,P1.LOCZIP -- 邮政编码
    ,p2.txt -- 国家代码
    ,P1.LOC2 -- 行政区划代码
    ,P1.POB -- 邮箱号码
    ,P1.TEL1 -- 电话号码
    ,P1.NAMELC  -- 人行名称
    ,P1.ADRELC  -- 人行地址
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_adr' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_adr p1
left join ${iol_schema}.isbs_v_sth_stb p2 on p1.LOCCTY=p2.cod and p2.etl_dt = to_date('${batch_date}','yyyymmdd') 
    and p2.tbl='CTYCOD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')

;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_intstl_addr_info_h_isbsf1_tm 
  	                                group by 
  	                                        addr_id
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
        into ${iml_schema}.ref_intstl_addr_info_h_isbsf1_cl(
            addr_id -- 地址编号
    ,addr_idf -- 地址标识
    ,addr_desc -- 地址描述
    ,advise_bank_swift_id -- 通知行SWIFT编号
    ,e_mail -- 电子邮箱
    ,street_addr -- 街道地址
    ,zip_cd -- 邮政编码
    ,cty_rg_cd -- 国家代码
    ,dist_cd -- 行政区划代码
    ,mailbox_num -- 邮箱号码
    ,tel_num -- 电话号码
    ,pbc_name -- 人行名称
    ,pbc_addr -- 人行地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_intstl_addr_info_h_isbsf1_op(
            addr_id -- 地址编号
    ,addr_idf -- 地址标识
    ,addr_desc -- 地址描述
    ,advise_bank_swift_id -- 通知行SWIFT编号
    ,e_mail -- 电子邮箱
    ,street_addr -- 街道地址
    ,zip_cd -- 邮政编码
    ,cty_rg_cd -- 国家代码
    ,dist_cd -- 行政区划代码
    ,mailbox_num -- 邮箱号码
    ,tel_num -- 电话号码
    ,pbc_name -- 人行名称
    ,pbc_addr -- 人行地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.addr_id, o.addr_id) as addr_id -- 地址编号
    ,nvl(n.addr_idf, o.addr_idf) as addr_idf -- 地址标识
    ,nvl(n.addr_desc, o.addr_desc) as addr_desc -- 地址描述
    ,nvl(n.advise_bank_swift_id, o.advise_bank_swift_id) as advise_bank_swift_id -- 通知行SWIFT编号
    ,nvl(n.e_mail, o.e_mail) as e_mail -- 电子邮箱
    ,nvl(n.street_addr, o.street_addr) as street_addr -- 街道地址
    ,nvl(n.zip_cd, o.zip_cd) as zip_cd -- 邮政编码
    ,nvl(n.cty_rg_cd, o.cty_rg_cd) as cty_rg_cd -- 国家代码
    ,nvl(n.dist_cd, o.dist_cd) as dist_cd -- 行政区划代码
    ,nvl(n.mailbox_num, o.mailbox_num) as mailbox_num -- 邮箱号码
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.pbc_name, o.pbc_name) as pbc_name -- 人行名称
    ,nvl(n.pbc_addr, o.pbc_addr) as pbc_addr -- 人行地址
    ,case when
            n.addr_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.addr_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.addr_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_intstl_addr_info_h_isbsf1_tm n
    full join (select * from ${iml_schema}.ref_intstl_addr_info_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.addr_id = n.addr_id
where (
        o.addr_id is null
    )
    or (
        n.addr_id is null
    )
    or (
        o.addr_idf <> n.addr_idf
        or o.addr_desc <> n.addr_desc
        or o.advise_bank_swift_id <> n.advise_bank_swift_id
        or o.e_mail <> n.e_mail
        or o.street_addr <> n.street_addr
        or o.zip_cd <> n.zip_cd
        or o.dist_cd <> n.dist_cd
        or o.mailbox_num <> n.mailbox_num
        or o.tel_num <> n.tel_num
        or o.pbc_name <> n.pbc_name
        or o.pbc_addr <> n.pbc_addr
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_intstl_addr_info_h_isbsf1_cl(
            addr_id -- 地址编号
    ,addr_idf -- 地址标识
    ,addr_desc -- 地址描述
    ,advise_bank_swift_id -- 通知行SWIFT编号
    ,e_mail -- 电子邮箱
    ,street_addr -- 街道地址
    ,zip_cd -- 邮政编码
    ,cty_rg_cd -- 国家代码
    ,dist_cd -- 行政区划代码
    ,mailbox_num -- 邮箱号码
    ,tel_num -- 电话号码
    ,pbc_name -- 人行名称
    ,pbc_addr -- 人行地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_intstl_addr_info_h_isbsf1_op(
            addr_id -- 地址编号
    ,addr_idf -- 地址标识
    ,addr_desc -- 地址描述
    ,advise_bank_swift_id -- 通知行SWIFT编号
    ,e_mail -- 电子邮箱
    ,street_addr -- 街道地址
    ,zip_cd -- 邮政编码
    ,cty_rg_cd -- 国家代码
    ,dist_cd -- 行政区划代码
    ,mailbox_num -- 邮箱号码
    ,tel_num -- 电话号码
    ,pbc_name -- 人行名称
    ,pbc_addr -- 人行地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.addr_id -- 地址编号
    ,o.addr_idf -- 地址标识
    ,o.addr_desc -- 地址描述
    ,o.advise_bank_swift_id -- 通知行SWIFT编号
    ,o.e_mail -- 电子邮箱
    ,o.street_addr -- 街道地址
    ,o.zip_cd -- 邮政编码
    ,o.cty_rg_cd -- 国家代码
    ,o.dist_cd -- 行政区划代码
    ,o.mailbox_num -- 邮箱号码
    ,o.tel_num -- 电话号码
    ,o.pbc_name -- 人行名称
    ,o.pbc_addr -- 人行地址
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
from ${iml_schema}.ref_intstl_addr_info_h_isbsf1_bk o
    left join ${iml_schema}.ref_intstl_addr_info_h_isbsf1_op n
        on
            o.addr_id = n.addr_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_intstl_addr_info_h_isbsf1_cl d
        on
            o.addr_id = d.addr_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_intstl_addr_info_h;
--alter table ${iml_schema}.ref_intstl_addr_info_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_intstl_addr_info_h') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_intstl_addr_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ref_intstl_addr_info_h modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_intstl_addr_info_h exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_cl;
alter table ${iml_schema}.ref_intstl_addr_info_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_intstl_addr_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_tm purge;
drop table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_op purge;
drop table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_intstl_addr_info_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_intstl_addr_info_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
