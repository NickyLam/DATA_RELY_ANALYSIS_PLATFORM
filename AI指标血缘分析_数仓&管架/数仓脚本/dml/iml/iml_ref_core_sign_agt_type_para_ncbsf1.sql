/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_core_sign_agt_type_para_ncbsf1
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
alter table ${iml_schema}.ref_core_sign_agt_type_para add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_core_sign_agt_type_para partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    sign_type_cd -- 签约类型代码
    ,lp_id -- 法人编号
    ,agt_type_descb -- 协议类型描述
    ,sign_post_allow_clos_acct_flg -- 签约后允许销户标志
    ,agt_exclude_type_cd -- 协议互斥描述
    ,allow_repeat_sign_flg -- 允许重复签约标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_core_sign_agt_type_para partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_core_sign_agt_type_para partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_core_sign_agt_type_para partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_sign_type-1
insert into ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_tm(
    sign_type_cd -- 签约类型代码
    ,lp_id -- 法人编号
    ,agt_type_descb -- 协议类型描述
    ,sign_post_allow_clos_acct_flg -- 签约后允许销户标志
    ,agt_exclude_type_cd -- 协议互斥描述
    ,allow_repeat_sign_flg -- 允许重复签约标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SIGN_TYPE -- 签约类型代码
    ,'9999' -- 法人编号
    ,P1.SIGN_TYPE_DESC -- 协议类型描述
    ,DECODE(P1.AGREEMENT_CLOSE_ACCT_FLAG,'Y','1','N','0') -- 签约后允许销户标志
    ,P1.EXCLUDE_TYPE -- 协议互斥描述
    ,DECODE(P1.REPICK_FLAG,'Y','1','N','0') -- 允许重复签约标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_sign_type' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_sign_type p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_tm 
  	                                group by 
  	                                        sign_type_cd
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
        into ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_cl(
            sign_type_cd -- 签约类型代码
    ,lp_id -- 法人编号
    ,agt_type_descb -- 协议类型描述
    ,sign_post_allow_clos_acct_flg -- 签约后允许销户标志
    ,agt_exclude_type_cd -- 协议互斥描述
    ,allow_repeat_sign_flg -- 允许重复签约标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_op(
            sign_type_cd -- 签约类型代码
    ,lp_id -- 法人编号
    ,agt_type_descb -- 协议类型描述
    ,sign_post_allow_clos_acct_flg -- 签约后允许销户标志
    ,agt_exclude_type_cd -- 协议互斥描述
    ,allow_repeat_sign_flg -- 允许重复签约标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sign_type_cd, o.sign_type_cd) as sign_type_cd -- 签约类型代码
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.agt_type_descb, o.agt_type_descb) as agt_type_descb -- 协议类型描述
    ,nvl(n.sign_post_allow_clos_acct_flg, o.sign_post_allow_clos_acct_flg) as sign_post_allow_clos_acct_flg -- 签约后允许销户标志
    ,nvl(n.agt_exclude_type_cd, o.agt_exclude_type_cd) as agt_exclude_type_cd -- 协议互斥描述
    ,nvl(n.allow_repeat_sign_flg, o.allow_repeat_sign_flg) as allow_repeat_sign_flg -- 允许重复签约标志
    ,case when
            n.sign_type_cd is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sign_type_cd is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sign_type_cd is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.sign_type_cd = n.sign_type_cd
            and o.lp_id = n.lp_id
where (
        o.sign_type_cd is null
        and o.lp_id is null
    )
    or (
        n.sign_type_cd is null
        and n.lp_id is null
    )
    or (
        o.agt_type_descb <> n.agt_type_descb
        or o.sign_post_allow_clos_acct_flg <> n.sign_post_allow_clos_acct_flg
        or o.agt_exclude_type_cd <> n.agt_exclude_type_cd
        or o.allow_repeat_sign_flg <> n.allow_repeat_sign_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_cl(
            sign_type_cd -- 签约类型代码
    ,lp_id -- 法人编号
    ,agt_type_descb -- 协议类型描述
    ,sign_post_allow_clos_acct_flg -- 签约后允许销户标志
    ,agt_exclude_type_cd -- 协议互斥描述
    ,allow_repeat_sign_flg -- 允许重复签约标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_op(
            sign_type_cd -- 签约类型代码
    ,lp_id -- 法人编号
    ,agt_type_descb -- 协议类型描述
    ,sign_post_allow_clos_acct_flg -- 签约后允许销户标志
    ,agt_exclude_type_cd -- 协议互斥描述
    ,allow_repeat_sign_flg -- 允许重复签约标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sign_type_cd -- 签约类型代码
    ,o.lp_id -- 法人编号
    ,o.agt_type_descb -- 协议类型描述
    ,o.sign_post_allow_clos_acct_flg -- 签约后允许销户标志
    ,o.agt_exclude_type_cd -- 协议互斥描述
    ,o.allow_repeat_sign_flg -- 允许重复签约标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_bk o
    left join ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_op n
        on
            o.sign_type_cd = n.sign_type_cd
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_cl d
        on
            o.sign_type_cd = d.sign_type_cd
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_core_sign_agt_type_para;
alter table ${iml_schema}.ref_core_sign_agt_type_para truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_core_sign_agt_type_para exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_cl;
alter table ${iml_schema}.ref_core_sign_agt_type_para exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_core_sign_agt_type_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_core_sign_agt_type_para_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_core_sign_agt_type_para', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
