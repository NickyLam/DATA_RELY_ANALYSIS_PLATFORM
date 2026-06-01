/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_jd_crdt_lmt_h_jdjrf1
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
alter table ${iml_schema}.agt_jd_crdt_lmt_h add partition p_jdjrf1 values ('jdjrf1')(
        subpartition p_jdjrf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_jdjrf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_jd_crdt_lmt_h partition for ('jdjrf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_tm purge;
drop table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_op purge;
drop table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_lmt_id -- 客户额度编号
    ,jd_cust_id -- 外部客户编号
    ,prod_cd -- 产品代码
    ,curr_cd -- 币种代码
    ,circl_lmt_flg -- 循环额度标志
    ,crdt_effect_begin_dt -- 授信生效日期
    ,crdt_exp_dt -- 授信到期日期
    ,crdt_lmt -- 授信额度
    ,crdt_tenor_days -- 授信期限天数
    ,temp_lmt_flg -- 临时额度标志
    ,crdt_status_cd -- 授信状态代码
    ,prod_id -- 产品编号
    ,surp_aval_lmt -- 剩余可用额度
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_jd_crdt_lmt_h partition for ('jdjrf1')
where 0=1
;

create table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_jd_crdt_lmt_h partition for ('jdjrf1') where 0=1;

create table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_jd_crdt_lmt_h partition for ('jdjrf1') where 0=1;

-- 3.1 get new data into table
-- icms_jdjr_cuscredit_info-
insert into ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_lmt_id -- 客户额度编号
    ,jd_cust_id -- 外部客户编号
    ,prod_cd -- 产品代码
    ,curr_cd -- 币种代码
    ,circl_lmt_flg -- 循环额度标志
    ,crdt_effect_begin_dt -- 授信生效日期
    ,crdt_exp_dt -- 授信到期日期
    ,crdt_lmt -- 授信额度
    ,crdt_tenor_days -- 授信期限天数
    ,temp_lmt_flg -- 临时额度标志
    ,crdt_status_cd -- 授信状态代码
    ,prod_id -- 产品编号
    ,surp_aval_lmt -- 剩余可用额度
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222305'||P1.LIMITNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.LIMITNO -- 客户额度编号
    ,P1.CUSNO -- 外部客户编号
    ,P1.PRDNO -- 产品代码
    ,P1.CURRENCY -- 币种代码
    ,P1.CYCLELIMITFLAG -- 循环额度标志
    ,${iml_schema}.dateformat_min(trim(P1.CREDITSTARTDT)) -- 授信生效日期
    ,${iml_schema}.dateformat_max2(trim(P1.CREDITENDDT)) -- 授信到期日期
    ,P1.CREDITLIMITAMT -- 授信额度
    ,P1.CREDITDAYS -- 授信期限天数
    ,P1.TEMPLIMITFLAG -- 临时额度标志
    ,P1.CREDITSTATUS -- 授信状态代码
    ,P1.PRDCODE -- 产品编号
    ,P1.UNUSEDLIMITAMT -- 剩余可用额度
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_jdjr_cuscredit_info' -- 源表名称
    ,'jdjrf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_jdjr_cuscredit_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_tm 
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
        into ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_lmt_id -- 客户额度编号
    ,jd_cust_id -- 外部客户编号
    ,prod_cd -- 产品代码
    ,curr_cd -- 币种代码
    ,circl_lmt_flg -- 循环额度标志
    ,crdt_effect_begin_dt -- 授信生效日期
    ,crdt_exp_dt -- 授信到期日期
    ,crdt_lmt -- 授信额度
    ,crdt_tenor_days -- 授信期限天数
    ,temp_lmt_flg -- 临时额度标志
    ,crdt_status_cd -- 授信状态代码
    ,prod_id -- 产品编号
    ,surp_aval_lmt -- 剩余可用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_lmt_id -- 客户额度编号
    ,jd_cust_id -- 外部客户编号
    ,prod_cd -- 产品代码
    ,curr_cd -- 币种代码
    ,circl_lmt_flg -- 循环额度标志
    ,crdt_effect_begin_dt -- 授信生效日期
    ,crdt_exp_dt -- 授信到期日期
    ,crdt_lmt -- 授信额度
    ,crdt_tenor_days -- 授信期限天数
    ,temp_lmt_flg -- 临时额度标志
    ,crdt_status_cd -- 授信状态代码
    ,prod_id -- 产品编号
    ,surp_aval_lmt -- 剩余可用额度
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
    ,nvl(n.cust_lmt_id, o.cust_lmt_id) as cust_lmt_id -- 客户额度编号
    ,nvl(n.jd_cust_id, o.jd_cust_id) as jd_cust_id -- 外部客户编号
    ,nvl(n.prod_cd, o.prod_cd) as prod_cd -- 产品代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.circl_lmt_flg, o.circl_lmt_flg) as circl_lmt_flg -- 循环额度标志
    ,nvl(n.crdt_effect_begin_dt, o.crdt_effect_begin_dt) as crdt_effect_begin_dt -- 授信生效日期
    ,nvl(n.crdt_exp_dt, o.crdt_exp_dt) as crdt_exp_dt -- 授信到期日期
    ,nvl(n.crdt_lmt, o.crdt_lmt) as crdt_lmt -- 授信额度
    ,nvl(n.crdt_tenor_days, o.crdt_tenor_days) as crdt_tenor_days -- 授信期限天数
    ,nvl(n.temp_lmt_flg, o.temp_lmt_flg) as temp_lmt_flg -- 临时额度标志
    ,nvl(n.crdt_status_cd, o.crdt_status_cd) as crdt_status_cd -- 授信状态代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.surp_aval_lmt, o.surp_aval_lmt) as surp_aval_lmt -- 剩余可用额度
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
from ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_tm n
    full join (select * from ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.cust_lmt_id <> n.cust_lmt_id
        or o.jd_cust_id <> n.jd_cust_id
        or o.prod_cd <> n.prod_cd
        or o.curr_cd <> n.curr_cd
        or o.circl_lmt_flg <> n.circl_lmt_flg
        or o.crdt_effect_begin_dt <> n.crdt_effect_begin_dt
        or o.crdt_exp_dt <> n.crdt_exp_dt
        or o.crdt_lmt <> n.crdt_lmt
        or o.crdt_tenor_days <> n.crdt_tenor_days
        or o.temp_lmt_flg <> n.temp_lmt_flg
        or o.crdt_status_cd <> n.crdt_status_cd
        or o.prod_id <> n.prod_id
        or o.surp_aval_lmt <> n.surp_aval_lmt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_lmt_id -- 客户额度编号
    ,jd_cust_id -- 外部客户编号
    ,prod_cd -- 产品代码
    ,curr_cd -- 币种代码
    ,circl_lmt_flg -- 循环额度标志
    ,crdt_effect_begin_dt -- 授信生效日期
    ,crdt_exp_dt -- 授信到期日期
    ,crdt_lmt -- 授信额度
    ,crdt_tenor_days -- 授信期限天数
    ,temp_lmt_flg -- 临时额度标志
    ,crdt_status_cd -- 授信状态代码
    ,prod_id -- 产品编号
    ,surp_aval_lmt -- 剩余可用额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_lmt_id -- 客户额度编号
    ,jd_cust_id -- 外部客户编号
    ,prod_cd -- 产品代码
    ,curr_cd -- 币种代码
    ,circl_lmt_flg -- 循环额度标志
    ,crdt_effect_begin_dt -- 授信生效日期
    ,crdt_exp_dt -- 授信到期日期
    ,crdt_lmt -- 授信额度
    ,crdt_tenor_days -- 授信期限天数
    ,temp_lmt_flg -- 临时额度标志
    ,crdt_status_cd -- 授信状态代码
    ,prod_id -- 产品编号
    ,surp_aval_lmt -- 剩余可用额度
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
    ,o.cust_lmt_id -- 客户额度编号
    ,o.jd_cust_id -- 外部客户编号
    ,o.prod_cd -- 产品代码
    ,o.curr_cd -- 币种代码
    ,o.circl_lmt_flg -- 循环额度标志
    ,o.crdt_effect_begin_dt -- 授信生效日期
    ,o.crdt_exp_dt -- 授信到期日期
    ,o.crdt_lmt -- 授信额度
    ,o.crdt_tenor_days -- 授信期限天数
    ,o.temp_lmt_flg -- 临时额度标志
    ,o.crdt_status_cd -- 授信状态代码
    ,o.prod_id -- 产品编号
    ,o.surp_aval_lmt -- 剩余可用额度
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_bk o
    left join ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_cl d
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
--truncate table ${iml_schema}.agt_jd_crdt_lmt_h;
alter table ${iml_schema}.agt_jd_crdt_lmt_h truncate partition for ('jdjrf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_jd_crdt_lmt_h exchange subpartition p_jdjrf1_19000101 with table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_cl;
alter table ${iml_schema}.agt_jd_crdt_lmt_h exchange subpartition p_jdjrf1_20991231 with table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_jd_crdt_lmt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_tm purge;
drop table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_op purge;
drop table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_jd_crdt_lmt_h_jdjrf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_jd_crdt_lmt_h', partname => 'p_jdjrf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
