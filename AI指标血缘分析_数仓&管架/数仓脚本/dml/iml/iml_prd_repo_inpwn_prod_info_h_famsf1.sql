/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_repo_inpwn_prod_info_h_famsf1
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
alter table ${iml_schema}.prd_repo_inpwn_prod_info_h add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_famsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_repo_inpwn_prod_info_h partition for ('famsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_tm purge;
drop table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_op purge;
drop table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,inpwn_fin_prod_id -- 质押金融产品编号
    ,inpwn_fac_val -- 质押面值
    ,inpwn_qtty -- 质押数量
    ,inpwn_rat -- 质押率
    ,inpwn_amt -- 质押金额
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_repo_inpwn_prod_info_h partition for ('famsf1')
where 0=1
;

create table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_repo_inpwn_prod_info_h partition for ('famsf1') where 0=1;

create table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_repo_inpwn_prod_info_h partition for ('famsf1') where 0=1;

-- 3.1 get new data into table
-- fams_fin_deal_pledge-
insert into ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,inpwn_fin_prod_id -- 质押金融产品编号
    ,inpwn_fac_val -- 质押面值
    ,inpwn_qtty -- 质押数量
    ,inpwn_rat -- 质押率
    ,inpwn_amt -- 质押金额
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '212002'||P1.finprod_id||branch||pledge_finprod_id -- 产品编号
    ,'9999' -- 法人编号
    ,P1.FINPROD_ID -- 金融产品编号
    ,P1.BRANCH -- 分支序号
    ,P1.PLEDGE_FINPROD_ID -- 质押金融产品编号
    ,P1.PLEDGE_FACE_VALUE -- 质押面值
    ,P1.PLEDGE_NUMBER -- 质押数量
    ,P1.PLEDGE_RATIO -- 质押率
    ,P1.PLEDGE_AMT -- 质押金额
    ,P1.CREATE_TIME -- 创建时间
    ,P1.UPDATE_TIME -- 更新时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_fin_deal_pledge' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_fin_deal_pledge p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_tm 
  	                                group by 
  	                                        prod_id
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
        into ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,inpwn_fin_prod_id -- 质押金融产品编号
    ,inpwn_fac_val -- 质押面值
    ,inpwn_qtty -- 质押数量
    ,inpwn_rat -- 质押率
    ,inpwn_amt -- 质押金额
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,inpwn_fin_prod_id -- 质押金融产品编号
    ,inpwn_fac_val -- 质押面值
    ,inpwn_qtty -- 质押数量
    ,inpwn_rat -- 质押率
    ,inpwn_amt -- 质押金额
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.fin_prod_id, o.fin_prod_id) as fin_prod_id -- 金融产品编号
    ,nvl(n.brch_seq_num, o.brch_seq_num) as brch_seq_num -- 分支序号
    ,nvl(n.inpwn_fin_prod_id, o.inpwn_fin_prod_id) as inpwn_fin_prod_id -- 质押金融产品编号
    ,nvl(n.inpwn_fac_val, o.inpwn_fac_val) as inpwn_fac_val -- 质押面值
    ,nvl(n.inpwn_qtty, o.inpwn_qtty) as inpwn_qtty -- 质押数量
    ,nvl(n.inpwn_rat, o.inpwn_rat) as inpwn_rat -- 质押率
    ,nvl(n.inpwn_amt, o.inpwn_amt) as inpwn_amt -- 质押金额
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.update_tm, o.update_tm) as update_tm -- 更新时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_tm n
    full join (select * from ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
where (
        o.prod_id is null
        and o.lp_id is null
    )
    or (
        n.prod_id is null
        and n.lp_id is null
    )
    or (
        o.fin_prod_id <> n.fin_prod_id
        or o.brch_seq_num <> n.brch_seq_num
        or o.inpwn_fin_prod_id <> n.inpwn_fin_prod_id
        or o.inpwn_fac_val <> n.inpwn_fac_val
        or o.inpwn_qtty <> n.inpwn_qtty
        or o.inpwn_rat <> n.inpwn_rat
        or o.inpwn_amt <> n.inpwn_amt
        or o.create_tm <> n.create_tm
        or o.update_tm <> n.update_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,inpwn_fin_prod_id -- 质押金融产品编号
    ,inpwn_fac_val -- 质押面值
    ,inpwn_qtty -- 质押数量
    ,inpwn_rat -- 质押率
    ,inpwn_amt -- 质押金额
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,fin_prod_id -- 金融产品编号
    ,brch_seq_num -- 分支序号
    ,inpwn_fin_prod_id -- 质押金融产品编号
    ,inpwn_fac_val -- 质押面值
    ,inpwn_qtty -- 质押数量
    ,inpwn_rat -- 质押率
    ,inpwn_amt -- 质押金额
    ,create_tm -- 创建时间
    ,update_tm -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_id -- 产品编号
    ,o.lp_id -- 法人编号
    ,o.fin_prod_id -- 金融产品编号
    ,o.brch_seq_num -- 分支序号
    ,o.inpwn_fin_prod_id -- 质押金融产品编号
    ,o.inpwn_fac_val -- 质押面值
    ,o.inpwn_qtty -- 质押数量
    ,o.inpwn_rat -- 质押率
    ,o.inpwn_amt -- 质押金额
    ,o.create_tm -- 创建时间
    ,o.update_tm -- 更新时间
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
from ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_bk o
    left join ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_op n
        on
            o.prod_id = n.prod_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_cl d
        on
            o.prod_id = d.prod_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_repo_inpwn_prod_info_h;
--alter table ${iml_schema}.prd_repo_inpwn_prod_info_h truncate partition for ('famsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_repo_inpwn_prod_info_h') 
               and substr(subpartition_name,1,8)=upper('p_famsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_repo_inpwn_prod_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.prd_repo_inpwn_prod_info_h modify partition p_famsf1 
add subpartition p_famsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_repo_inpwn_prod_info_h exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_cl;
alter table ${iml_schema}.prd_repo_inpwn_prod_info_h exchange subpartition p_famsf1_20991231 with table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_repo_inpwn_prod_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_tm purge;
drop table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_op purge;
drop table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_repo_inpwn_prod_info_h_famsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_repo_inpwn_prod_info_h', partname => 'p_famsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
