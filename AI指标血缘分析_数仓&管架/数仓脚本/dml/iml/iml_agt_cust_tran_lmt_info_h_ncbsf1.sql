/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cust_tran_lmt_info_h_ncbsf1
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
alter table ${iml_schema}.agt_cust_tran_lmt_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cust_tran_lmt_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cust_id -- 客户编号
    ,lmt_code -- 限额编码
    ,lmt_cate_cd -- 限额类别代码
    ,lmt_set_rs_cd -- 限额设置原因代码
    ,tran_lmt_valid_dt -- 交易限额有效日期
    ,seq_num -- 序号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,amt_uplmi -- 金额上限
    ,amt_lolmi -- 金额下限
    ,cnt_limit -- 笔数上限
    ,tran_tm -- 交易时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cust_tran_lmt_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cust_tran_lmt_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cust_tran_lmt_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_lm_client_tran_limit-1
insert into ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cust_id -- 客户编号
    ,lmt_code -- 限额编码
    ,lmt_cate_cd -- 限额类别代码
    ,lmt_set_rs_cd -- 限额设置原因代码
    ,tran_lmt_valid_dt -- 交易限额有效日期
    ,seq_num -- 序号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,amt_uplmi -- 金额上限
    ,amt_lolmi -- 金额下限
    ,cnt_limit -- 笔数上限
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300031'||trim(P1.BASE_ACCT_NO)||trim(P1.ACCT_SEQ_NO)||P1.CLIENT_NO|| P1.LIMIT_REF -- 协议编号
    ,'9999' -- 法人编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.LIMIT_REF -- 限额编码
    ,nvl(trim(P1.LIMIT_MAIN_TYPE),'-') -- 限额类别代码
    ,nvl(trim(P1.LIMIT_REASON),'8') -- 限额设置原因代码
    ,P1.TRAN_LIMIT_DUE_DATE -- 交易限额有效日期
    ,P1.SEQ_NO -- 序号
    ,P1.PROD_TYPE -- 产品编号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 币种代码
    ,P1.LIMIT_MAX_AMT -- 金额上限
    ,P1.LIMIT_MIN_AMT -- 金额下限
    ,P1.LIMIT_MAX_NUM -- 笔数上限
    ,${iml_schema}.timeformat_max2(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_lm_client_tran_limit' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_lm_client_tran_limit p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
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
        into ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cust_id -- 客户编号
    ,lmt_code -- 限额编码
    ,lmt_cate_cd -- 限额类别代码
    ,lmt_set_rs_cd -- 限额设置原因代码
    ,tran_lmt_valid_dt -- 交易限额有效日期
    ,seq_num -- 序号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,amt_uplmi -- 金额上限
    ,amt_lolmi -- 金额下限
    ,cnt_limit -- 笔数上限
    ,tran_tm -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cust_id -- 客户编号
    ,lmt_code -- 限额编码
    ,lmt_cate_cd -- 限额类别代码
    ,lmt_set_rs_cd -- 限额设置原因代码
    ,tran_lmt_valid_dt -- 交易限额有效日期
    ,seq_num -- 序号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,amt_uplmi -- 金额上限
    ,amt_lolmi -- 金额下限
    ,cnt_limit -- 笔数上限
    ,tran_tm -- 交易时间
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
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.lmt_code, o.lmt_code) as lmt_code -- 限额编码
    ,nvl(n.lmt_cate_cd, o.lmt_cate_cd) as lmt_cate_cd -- 限额类别代码
    ,nvl(n.lmt_set_rs_cd, o.lmt_set_rs_cd) as lmt_set_rs_cd -- 限额设置原因代码
    ,nvl(n.tran_lmt_valid_dt, o.tran_lmt_valid_dt) as tran_lmt_valid_dt -- 交易限额有效日期
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.amt_uplmi, o.amt_uplmi) as amt_uplmi -- 金额上限
    ,nvl(n.amt_lolmi, o.amt_lolmi) as amt_lolmi -- 金额下限
    ,nvl(n.cnt_limit, o.cnt_limit) as cnt_limit -- 笔数上限
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.cust_acct_num <> n.cust_acct_num
        or o.sub_acct_num <> n.sub_acct_num
        or o.cust_id <> n.cust_id
        or o.lmt_code <> n.lmt_code
        or o.lmt_cate_cd <> n.lmt_cate_cd
        or o.lmt_set_rs_cd <> n.lmt_set_rs_cd
        or o.tran_lmt_valid_dt <> n.tran_lmt_valid_dt
        or o.seq_num <> n.seq_num
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.amt_uplmi <> n.amt_uplmi
        or o.amt_lolmi <> n.amt_lolmi
        or o.cnt_limit <> n.cnt_limit
        or o.tran_tm <> n.tran_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cust_id -- 客户编号
    ,lmt_code -- 限额编码
    ,lmt_cate_cd -- 限额类别代码
    ,lmt_set_rs_cd -- 限额设置原因代码
    ,tran_lmt_valid_dt -- 交易限额有效日期
    ,seq_num -- 序号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,amt_uplmi -- 金额上限
    ,amt_lolmi -- 金额下限
    ,cnt_limit -- 笔数上限
    ,tran_tm -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,cust_id -- 客户编号
    ,lmt_code -- 限额编码
    ,lmt_cate_cd -- 限额类别代码
    ,lmt_set_rs_cd -- 限额设置原因代码
    ,tran_lmt_valid_dt -- 交易限额有效日期
    ,seq_num -- 序号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,amt_uplmi -- 金额上限
    ,amt_lolmi -- 金额下限
    ,cnt_limit -- 笔数上限
    ,tran_tm -- 交易时间
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
    ,o.cust_acct_num -- 客户账号
    ,o.sub_acct_num -- 子账号
    ,o.cust_id -- 客户编号
    ,o.lmt_code -- 限额编码
    ,o.lmt_cate_cd -- 限额类别代码
    ,o.lmt_set_rs_cd -- 限额设置原因代码
    ,o.tran_lmt_valid_dt -- 交易限额有效日期
    ,o.seq_num -- 序号
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.amt_uplmi -- 金额上限
    ,o.amt_lolmi -- 金额下限
    ,o.cnt_limit -- 笔数上限
    ,o.tran_tm -- 交易时间
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
from ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_cust_tran_lmt_info_h;
--alter table ${iml_schema}.agt_cust_tran_lmt_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_cust_tran_lmt_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_cust_tran_lmt_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_cust_tran_lmt_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_cust_tran_lmt_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_cust_tran_lmt_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cust_tran_lmt_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cust_tran_lmt_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cust_tran_lmt_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
