/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cds_pd_lmt_info_h_ncbsf1
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
alter table ${iml_schema}.agt_cds_pd_lmt_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_pd_lmt_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pd_cd -- 期次编号
    ,curr_cd -- 币种代码
    ,priv_flg -- 对私标志
    ,issue_year -- 发行年度
    ,tran_dt -- 交易日期
    ,ocup_lmt -- 占用额度
    ,tot_amt -- 总额度
    ,asigned_lmt -- 已分配额度
    ,upper_lmt_type_cd -- 上级额度类型代码
    ,surp_lmt -- 剩余额度
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cds_pd_lmt_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_pd_lmt_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_pd_lmt_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_dc_stage_quota-1
insert into ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pd_cd -- 期次编号
    ,curr_cd -- 币种代码
    ,priv_flg -- 对私标志
    ,issue_year -- 发行年度
    ,tran_dt -- 交易日期
    ,ocup_lmt -- 占用额度
    ,tot_amt -- 总额度
    ,asigned_lmt -- 已分配额度
    ,upper_lmt_type_cd -- 上级额度类型代码
    ,surp_lmt -- 剩余额度
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300030'||P1.STAGE_CODE -- 协议编号
    ,'9999' -- 法人编号
    ,P1.STAGE_CODE -- 期次编号
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,DECODE(trim(P1.INDIVIDUAL_FLAG),'Y','1','N','0','','-',P1.INDIVIDUAL_FLAG) -- 对私标志
    ,P1.ISSUE_YEAR -- 发行年度
    ,P1.TRAN_DATE -- 交易日期
    ,P1.HOLDING_QUOTA -- 占用额度
    ,P1.TOTAL_QUOTA -- 总额度
    ,P1.DISTRIBUTE_QUOTA -- 已分配额度
    ,nvl(trim(P1.PARENT_QUOTA_CLASS),'-') -- 上级额度类型代码
    ,P1.LEAVE_QUOTA -- 剩余额度
    ,P1.BRANCH -- 交易机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_dc_stage_quota' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_dc_stage_quota p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_tm 
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
        into ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pd_cd -- 期次编号
    ,curr_cd -- 币种代码
    ,priv_flg -- 对私标志
    ,issue_year -- 发行年度
    ,tran_dt -- 交易日期
    ,ocup_lmt -- 占用额度
    ,tot_amt -- 总额度
    ,asigned_lmt -- 已分配额度
    ,upper_lmt_type_cd -- 上级额度类型代码
    ,surp_lmt -- 剩余额度
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pd_cd -- 期次编号
    ,curr_cd -- 币种代码
    ,priv_flg -- 对私标志
    ,issue_year -- 发行年度
    ,tran_dt -- 交易日期
    ,ocup_lmt -- 占用额度
    ,tot_amt -- 总额度
    ,asigned_lmt -- 已分配额度
    ,upper_lmt_type_cd -- 上级额度类型代码
    ,surp_lmt -- 剩余额度
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
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
    ,nvl(n.pd_cd, o.pd_cd) as pd_cd -- 期次编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.priv_flg, o.priv_flg) as priv_flg -- 对私标志
    ,nvl(n.issue_year, o.issue_year) as issue_year -- 发行年度
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.ocup_lmt, o.ocup_lmt) as ocup_lmt -- 占用额度
    ,nvl(n.tot_amt, o.tot_amt) as tot_amt -- 总额度
    ,nvl(n.asigned_lmt, o.asigned_lmt) as asigned_lmt -- 已分配额度
    ,nvl(n.upper_lmt_type_cd, o.upper_lmt_type_cd) as upper_lmt_type_cd -- 上级额度类型代码
    ,nvl(n.surp_lmt, o.surp_lmt) as surp_lmt -- 剩余额度
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
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
from ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.pd_cd <> n.pd_cd
        or o.curr_cd <> n.curr_cd
        or o.priv_flg <> n.priv_flg
        or o.issue_year <> n.issue_year
        or o.tran_dt <> n.tran_dt
        or o.ocup_lmt <> n.ocup_lmt
        or o.tot_amt <> n.tot_amt
        or o.asigned_lmt <> n.asigned_lmt
        or o.upper_lmt_type_cd <> n.upper_lmt_type_cd
        or o.surp_lmt <> n.surp_lmt
        or o.tran_org_id <> n.tran_org_id
        or o.tran_teller_id <> n.tran_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pd_cd -- 期次编号
    ,curr_cd -- 币种代码
    ,priv_flg -- 对私标志
    ,issue_year -- 发行年度
    ,tran_dt -- 交易日期
    ,ocup_lmt -- 占用额度
    ,tot_amt -- 总额度
    ,asigned_lmt -- 已分配额度
    ,upper_lmt_type_cd -- 上级额度类型代码
    ,surp_lmt -- 剩余额度
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,pd_cd -- 期次编号
    ,curr_cd -- 币种代码
    ,priv_flg -- 对私标志
    ,issue_year -- 发行年度
    ,tran_dt -- 交易日期
    ,ocup_lmt -- 占用额度
    ,tot_amt -- 总额度
    ,asigned_lmt -- 已分配额度
    ,upper_lmt_type_cd -- 上级额度类型代码
    ,surp_lmt -- 剩余额度
    ,tran_org_id -- 交易机构编号
    ,tran_teller_id -- 交易柜员编号
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
    ,o.pd_cd -- 期次编号
    ,o.curr_cd -- 币种代码
    ,o.priv_flg -- 对私标志
    ,o.issue_year -- 发行年度
    ,o.tran_dt -- 交易日期
    ,o.ocup_lmt -- 占用额度
    ,o.tot_amt -- 总额度
    ,o.asigned_lmt -- 已分配额度
    ,o.upper_lmt_type_cd -- 上级额度类型代码
    ,o.surp_lmt -- 剩余额度
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_teller_id -- 交易柜员编号
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
from ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_cl d
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
--truncate table ${iml_schema}.agt_cds_pd_lmt_info_h;
--alter table ${iml_schema}.agt_cds_pd_lmt_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_cds_pd_lmt_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_cds_pd_lmt_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_cds_pd_lmt_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_cds_pd_lmt_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_cds_pd_lmt_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cds_pd_lmt_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cds_pd_lmt_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cds_pd_lmt_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
