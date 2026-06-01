/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_cust_seller_info_h_trusf1
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
alter table ${iml_schema}.pty_cust_seller_info_h add partition p_trusf1 values ('trusf1')(
        subpartition p_trusf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_trusf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_cust_seller_info_h_trusf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust_seller_info_h partition for ('trusf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_cust_seller_info_h_trusf1_tm purge;
drop table ${iml_schema}.pty_cust_seller_info_h_trusf1_op purge;
drop table ${iml_schema}.pty_cust_seller_info_h_trusf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cust_seller_info_h_trusf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,bank_id -- 银行编号
    ,seller_cd -- 销售商代码
    ,sys_src_abbr -- 系统来源简称
    ,bank_cust_id -- 银行客户编号
    ,intnal_cust_id -- 内部客户编号
    ,sign_dt -- 签约日期
    ,rels_dt -- 解约日期
    ,ta_cust_tran_acct_num -- TA客户交易账号
    ,rels_flg -- 解约标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cust_seller_info_h partition for ('trusf1')
where 0=1
;

create table ${iml_schema}.pty_cust_seller_info_h_trusf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust_seller_info_h partition for ('trusf1') where 0=1;

create table ${iml_schema}.pty_cust_seller_info_h_trusf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust_seller_info_h partition for ('trusf1') where 0=1;

-- 3.1 get new data into table
-- nfss_tcs_tbclientseller-
insert into ${iml_schema}.pty_cust_seller_info_h_trusf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,bank_id -- 银行编号
    ,seller_cd -- 销售商代码
    ,sys_src_abbr -- 系统来源简称
    ,bank_cust_id -- 银行客户编号
    ,intnal_cust_id -- 内部客户编号
    ,sign_dt -- 签约日期
    ,rels_dt -- 解约日期
    ,ta_cust_tran_acct_num -- TA客户交易账号
    ,rels_flg -- 解约标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CLIENT_NO -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.BANK_NO -- 银行编号
    ,P1.SELLER_CODE -- 销售商代码
    ,'TRUS' -- 系统来源简称
    ,P1.CLIENT_NO -- 银行客户编号
    ,P1.IN_CLIENT_NO -- 内部客户编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.OPEN_DATE) -- 签约日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.CLOSE_DATE) -- 解约日期
    ,P1.TA_CLIENT -- TA客户交易账号
    ,nvl(trim(P1.STATUS),'-') -- 解约标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'nfss_tcs_tbclientseller' -- 源表名称
    ,'trusf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.nfss_tcs_tbclientseller p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_cust_seller_info_h_trusf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                                        ,bank_id
  	                                        ,seller_cd
  	                                        ,sys_src_abbr
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
        into ${iml_schema}.pty_cust_seller_info_h_trusf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,bank_id -- 银行编号
    ,seller_cd -- 销售商代码
    ,sys_src_abbr -- 系统来源简称
    ,bank_cust_id -- 银行客户编号
    ,intnal_cust_id -- 内部客户编号
    ,sign_dt -- 签约日期
    ,rels_dt -- 解约日期
    ,ta_cust_tran_acct_num -- TA客户交易账号
    ,rels_flg -- 解约标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_cust_seller_info_h_trusf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,bank_id -- 银行编号
    ,seller_cd -- 销售商代码
    ,sys_src_abbr -- 系统来源简称
    ,bank_cust_id -- 银行客户编号
    ,intnal_cust_id -- 内部客户编号
    ,sign_dt -- 签约日期
    ,rels_dt -- 解约日期
    ,ta_cust_tran_acct_num -- TA客户交易账号
    ,rels_flg -- 解约标志
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
    ,nvl(n.bank_id, o.bank_id) as bank_id -- 银行编号
    ,nvl(n.seller_cd, o.seller_cd) as seller_cd -- 销售商代码
    ,nvl(n.sys_src_abbr, o.sys_src_abbr) as sys_src_abbr -- 系统来源简称
    ,nvl(n.bank_cust_id, o.bank_cust_id) as bank_cust_id -- 银行客户编号
    ,nvl(n.intnal_cust_id, o.intnal_cust_id) as intnal_cust_id -- 内部客户编号
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(n.rels_dt, o.rels_dt) as rels_dt -- 解约日期
    ,nvl(n.ta_cust_tran_acct_num, o.ta_cust_tran_acct_num) as ta_cust_tran_acct_num -- TA客户交易账号
    ,nvl(n.rels_flg, o.rels_flg) as rels_flg -- 解约标志
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.bank_id is null
            and n.seller_cd is null
            and n.sys_src_abbr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.bank_id is null
            and n.seller_cd is null
            and n.sys_src_abbr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
            and n.bank_id is null
            and n.seller_cd is null
            and n.sys_src_abbr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cust_seller_info_h_trusf1_tm n
    full join (select * from ${iml_schema}.pty_cust_seller_info_h_trusf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.bank_id = n.bank_id
            and o.seller_cd = n.seller_cd
            and o.sys_src_abbr = n.sys_src_abbr
where (
        o.party_id is null
        and o.lp_id is null
        and o.bank_id is null
        and o.seller_cd is null
        and o.sys_src_abbr is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
        and n.bank_id is null
        and n.seller_cd is null
        and n.sys_src_abbr is null
    )
    or (
        o.bank_cust_id <> n.bank_cust_id
        or o.intnal_cust_id <> n.intnal_cust_id
        or o.sign_dt <> n.sign_dt
        or o.rels_dt <> n.rels_dt
        or o.ta_cust_tran_acct_num <> n.ta_cust_tran_acct_num
        or o.rels_flg <> n.rels_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_cust_seller_info_h_trusf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,bank_id -- 银行编号
    ,seller_cd -- 销售商代码
    ,sys_src_abbr -- 系统来源简称
    ,bank_cust_id -- 银行客户编号
    ,intnal_cust_id -- 内部客户编号
    ,sign_dt -- 签约日期
    ,rels_dt -- 解约日期
    ,ta_cust_tran_acct_num -- TA客户交易账号
    ,rels_flg -- 解约标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_cust_seller_info_h_trusf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,bank_id -- 银行编号
    ,seller_cd -- 销售商代码
    ,sys_src_abbr -- 系统来源简称
    ,bank_cust_id -- 银行客户编号
    ,intnal_cust_id -- 内部客户编号
    ,sign_dt -- 签约日期
    ,rels_dt -- 解约日期
    ,ta_cust_tran_acct_num -- TA客户交易账号
    ,rels_flg -- 解约标志
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
    ,o.bank_id -- 银行编号
    ,o.seller_cd -- 销售商代码
    ,o.sys_src_abbr -- 系统来源简称
    ,o.bank_cust_id -- 银行客户编号
    ,o.intnal_cust_id -- 内部客户编号
    ,o.sign_dt -- 签约日期
    ,o.rels_dt -- 解约日期
    ,o.ta_cust_tran_acct_num -- TA客户交易账号
    ,o.rels_flg -- 解约标志
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
from ${iml_schema}.pty_cust_seller_info_h_trusf1_bk o
    left join ${iml_schema}.pty_cust_seller_info_h_trusf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.bank_id = n.bank_id
            and o.seller_cd = n.seller_cd
            and o.sys_src_abbr = n.sys_src_abbr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_cust_seller_info_h_trusf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
            and o.bank_id = d.bank_id
            and o.seller_cd = d.seller_cd
            and o.sys_src_abbr = d.sys_src_abbr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_cust_seller_info_h;
--alter table ${iml_schema}.pty_cust_seller_info_h truncate partition for ('trusf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_cust_seller_info_h') 
               and substr(subpartition_name,1,8)=upper('p_trusf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_cust_seller_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_cust_seller_info_h modify partition p_trusf1 
add subpartition p_trusf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_cust_seller_info_h exchange subpartition p_trusf1_${batch_date} with table ${iml_schema}.pty_cust_seller_info_h_trusf1_cl;
alter table ${iml_schema}.pty_cust_seller_info_h exchange subpartition p_trusf1_20991231 with table ${iml_schema}.pty_cust_seller_info_h_trusf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_cust_seller_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_cust_seller_info_h_trusf1_tm purge;
drop table ${iml_schema}.pty_cust_seller_info_h_trusf1_op purge;
drop table ${iml_schema}.pty_cust_seller_info_h_trusf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_cust_seller_info_h_trusf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_cust_seller_info_h', partname => 'p_trusf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
