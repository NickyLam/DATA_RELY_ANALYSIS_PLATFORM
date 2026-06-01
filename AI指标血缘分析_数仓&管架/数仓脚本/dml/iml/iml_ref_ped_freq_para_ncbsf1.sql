/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_ped_freq_para_ncbsf1
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
alter table ${iml_schema}.ref_ped_freq_para add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_ped_freq_para_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_ped_freq_para partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_ped_freq_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_ped_freq_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_ped_freq_para_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ped_freq_para_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    lp_id -- 法人编号
    ,ped_freq_cd -- 周期频率代码
    ,ped_freq_descb -- 周期频率描述
    ,holiday_defer_flg -- 节假日顺延标志
    ,eh_issue_qtty -- 每期数量
    ,eh_issue_corp_cd -- 每期单位代码
    ,eh_issue_days -- 每期天数
    ,tenor_corp_val -- 期限单位值
    ,tm_bg_or_term_end_flg_cd -- 期初或期末标志代码
    ,half_mon_flg -- 半月标志
    ,cust_flo_val -- 客户浮动值
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ped_freq_para partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.ref_ped_freq_para_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_ped_freq_para partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.ref_ped_freq_para_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_ped_freq_para partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_fm_period_freq-1
insert into ${iml_schema}.ref_ped_freq_para_ncbsf1_tm(
    lp_id -- 法人编号
    ,ped_freq_cd -- 周期频率代码
    ,ped_freq_descb -- 周期频率描述
    ,holiday_defer_flg -- 节假日顺延标志
    ,eh_issue_qtty -- 每期数量
    ,eh_issue_corp_cd -- 每期单位代码
    ,eh_issue_days -- 每期天数
    ,tenor_corp_val -- 期限单位值
    ,tm_bg_or_term_end_flg_cd -- 期初或期末标志代码
    ,half_mon_flg -- 半月标志
    ,cust_flo_val -- 客户浮动值
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '9999' -- 法人编号
    ,P1.PERIOD_FREQ -- 周期频率代码
    ,P1.PERIOD_FREQ_DESC -- 周期频率描述
    ,DECODE(P1.FORCE_WORK_DAY,'Y','1','N','0') -- 节假日顺延标志
    ,P1.ADD_NO -- 每期数量
    ,P1.DAY_MTH -- 每期单位代码
    ,P1.DAY_NUM -- 每期天数
    ,P1.PRIOR_DAYS -- 期限单位值
    ,P1.FIRST_LAST -- 期初或期末标志代码
    ,DECODE(P1.HALF_MONTH,'Y','1','N','0') -- 半月标志
    ,P1.CLIENT_SPREAD -- 客户浮动值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_fm_period_freq' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_fm_period_freq p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_ped_freq_para_ncbsf1_tm 
  	                                group by 
  	                                        lp_id
  	                                        ,ped_freq_cd
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
        into ${iml_schema}.ref_ped_freq_para_ncbsf1_cl(
            lp_id -- 法人编号
    ,ped_freq_cd -- 周期频率代码
    ,ped_freq_descb -- 周期频率描述
    ,holiday_defer_flg -- 节假日顺延标志
    ,eh_issue_qtty -- 每期数量
    ,eh_issue_corp_cd -- 每期单位代码
    ,eh_issue_days -- 每期天数
    ,tenor_corp_val -- 期限单位值
    ,tm_bg_or_term_end_flg_cd -- 期初或期末标志代码
    ,half_mon_flg -- 半月标志
    ,cust_flo_val -- 客户浮动值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_ped_freq_para_ncbsf1_op(
            lp_id -- 法人编号
    ,ped_freq_cd -- 周期频率代码
    ,ped_freq_descb -- 周期频率描述
    ,holiday_defer_flg -- 节假日顺延标志
    ,eh_issue_qtty -- 每期数量
    ,eh_issue_corp_cd -- 每期单位代码
    ,eh_issue_days -- 每期天数
    ,tenor_corp_val -- 期限单位值
    ,tm_bg_or_term_end_flg_cd -- 期初或期末标志代码
    ,half_mon_flg -- 半月标志
    ,cust_flo_val -- 客户浮动值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.ped_freq_cd, o.ped_freq_cd) as ped_freq_cd -- 周期频率代码
    ,nvl(n.ped_freq_descb, o.ped_freq_descb) as ped_freq_descb -- 周期频率描述
    ,nvl(n.holiday_defer_flg, o.holiday_defer_flg) as holiday_defer_flg -- 节假日顺延标志
    ,nvl(n.eh_issue_qtty, o.eh_issue_qtty) as eh_issue_qtty -- 每期数量
    ,nvl(n.eh_issue_corp_cd, o.eh_issue_corp_cd) as eh_issue_corp_cd -- 每期单位代码
    ,nvl(n.eh_issue_days, o.eh_issue_days) as eh_issue_days -- 每期天数
    ,nvl(n.tenor_corp_val, o.tenor_corp_val) as tenor_corp_val -- 期限单位值
    ,nvl(n.tm_bg_or_term_end_flg_cd, o.tm_bg_or_term_end_flg_cd) as tm_bg_or_term_end_flg_cd -- 期初或期末标志代码
    ,nvl(n.half_mon_flg, o.half_mon_flg) as half_mon_flg -- 半月标志
    ,nvl(n.cust_flo_val, o.cust_flo_val) as cust_flo_val -- 客户浮动值
    ,case when
            n.lp_id is null
            and n.ped_freq_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lp_id is null
            and n.ped_freq_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lp_id is null
            and n.ped_freq_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ped_freq_para_ncbsf1_tm n
    full join (select * from ${iml_schema}.ref_ped_freq_para_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.lp_id = n.lp_id
            and o.ped_freq_cd = n.ped_freq_cd
where (
        o.lp_id is null
        and o.ped_freq_cd is null
    )
    or (
        n.lp_id is null
        and n.ped_freq_cd is null
    )
    or (
        o.ped_freq_descb <> n.ped_freq_descb
        or o.holiday_defer_flg <> n.holiday_defer_flg
        or o.eh_issue_qtty <> n.eh_issue_qtty
        or o.eh_issue_corp_cd <> n.eh_issue_corp_cd
        or o.eh_issue_days <> n.eh_issue_days
        or o.tenor_corp_val <> n.tenor_corp_val
        or o.tm_bg_or_term_end_flg_cd <> n.tm_bg_or_term_end_flg_cd
        or o.half_mon_flg <> n.half_mon_flg
        or o.cust_flo_val <> n.cust_flo_val
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_ped_freq_para_ncbsf1_cl(
            lp_id -- 法人编号
    ,ped_freq_cd -- 周期频率代码
    ,ped_freq_descb -- 周期频率描述
    ,holiday_defer_flg -- 节假日顺延标志
    ,eh_issue_qtty -- 每期数量
    ,eh_issue_corp_cd -- 每期单位代码
    ,eh_issue_days -- 每期天数
    ,tenor_corp_val -- 期限单位值
    ,tm_bg_or_term_end_flg_cd -- 期初或期末标志代码
    ,half_mon_flg -- 半月标志
    ,cust_flo_val -- 客户浮动值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_ped_freq_para_ncbsf1_op(
            lp_id -- 法人编号
    ,ped_freq_cd -- 周期频率代码
    ,ped_freq_descb -- 周期频率描述
    ,holiday_defer_flg -- 节假日顺延标志
    ,eh_issue_qtty -- 每期数量
    ,eh_issue_corp_cd -- 每期单位代码
    ,eh_issue_days -- 每期天数
    ,tenor_corp_val -- 期限单位值
    ,tm_bg_or_term_end_flg_cd -- 期初或期末标志代码
    ,half_mon_flg -- 半月标志
    ,cust_flo_val -- 客户浮动值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.lp_id -- 法人编号
    ,o.ped_freq_cd -- 周期频率代码
    ,o.ped_freq_descb -- 周期频率描述
    ,o.holiday_defer_flg -- 节假日顺延标志
    ,o.eh_issue_qtty -- 每期数量
    ,o.eh_issue_corp_cd -- 每期单位代码
    ,o.eh_issue_days -- 每期天数
    ,o.tenor_corp_val -- 期限单位值
    ,o.tm_bg_or_term_end_flg_cd -- 期初或期末标志代码
    ,o.half_mon_flg -- 半月标志
    ,o.cust_flo_val -- 客户浮动值
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_ped_freq_para_ncbsf1_bk o
    left join ${iml_schema}.ref_ped_freq_para_ncbsf1_op n
        on
            o.lp_id = n.lp_id
            and o.ped_freq_cd = n.ped_freq_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_ped_freq_para_ncbsf1_cl d
        on
            o.lp_id = d.lp_id
            and o.ped_freq_cd = d.ped_freq_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_ped_freq_para;
alter table ${iml_schema}.ref_ped_freq_para truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.ref_ped_freq_para exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.ref_ped_freq_para_ncbsf1_cl;
alter table ${iml_schema}.ref_ped_freq_para exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.ref_ped_freq_para_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_ped_freq_para to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_ped_freq_para_ncbsf1_tm purge;
drop table ${iml_schema}.ref_ped_freq_para_ncbsf1_op purge;
drop table ${iml_schema}.ref_ped_freq_para_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_ped_freq_para_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_ped_freq_para', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
