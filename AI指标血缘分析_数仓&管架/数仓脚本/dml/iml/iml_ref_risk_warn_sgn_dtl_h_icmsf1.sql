/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_risk_warn_sgn_dtl_h_icmsf1
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
alter table ${iml_schema}.ref_risk_warn_sgn_dtl_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_risk_warn_sgn_dtl_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_tm purge;
drop table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_op purge;
drop table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    warn_id -- 预警编号
    ,lp_id -- 法人编号
    ,warn_name -- 预警名称
    ,trigger_rating_adj_warn_sgn_flg -- 触发评级调整的预警信号标志
    ,warn_sgn_type_cd -- 预警信号类型代码
    ,warn_descb -- 预警描述
    ,warn_hibchy -- 预警层级
    ,cust_type_cd -- 客户类型代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,modif_dt -- 变更日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_risk_warn_sgn_dtl_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_risk_warn_sgn_dtl_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_risk_warn_sgn_dtl_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_alarmsign_info-1
insert into ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_tm(
    warn_id -- 预警编号
    ,lp_id -- 法人编号
    ,warn_name -- 预警名称
    ,trigger_rating_adj_warn_sgn_flg -- 触发评级调整的预警信号标志
    ,warn_sgn_type_cd -- 预警信号类型代码
    ,warn_descb -- 预警描述
    ,warn_hibchy -- 预警层级
    ,cust_type_cd -- 客户类型代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,modif_dt -- 变更日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SIGNID -- 预警编号
    ,'9999' -- 法人编号
    ,P1.SIGNNAME -- 预警名称
    ,nvl(trim(P1.ISRATECHANGECONDITION),'-') -- 触发评级调整的预警信号标志
    ,P1.SIGNTYPE -- 预警信号类型代码
    ,P1.SIGNDESCRIBE -- 预警描述
    ,P1.SIGNLEVEL -- 预警层级
    ,nvl(trim(P1.SIGNCUSYTOMERTYPE),'-') -- 客户类型代码
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,P1.UPDATEDATE -- 变更日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_alarmsign_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_alarmsign_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_tm 
  	                                group by 
  	                                        warn_id
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
        into ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_cl(
            warn_id -- 预警编号
    ,lp_id -- 法人编号
    ,warn_name -- 预警名称
    ,trigger_rating_adj_warn_sgn_flg -- 触发评级调整的预警信号标志
    ,warn_sgn_type_cd -- 预警信号类型代码
    ,warn_descb -- 预警描述
    ,warn_hibchy -- 预警层级
    ,cust_type_cd -- 客户类型代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_op(
            warn_id -- 预警编号
    ,lp_id -- 法人编号
    ,warn_name -- 预警名称
    ,trigger_rating_adj_warn_sgn_flg -- 触发评级调整的预警信号标志
    ,warn_sgn_type_cd -- 预警信号类型代码
    ,warn_descb -- 预警描述
    ,warn_hibchy -- 预警层级
    ,cust_type_cd -- 客户类型代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.warn_id, o.warn_id) as warn_id -- 预警编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.warn_name, o.warn_name) as warn_name -- 预警名称
    ,nvl(n.trigger_rating_adj_warn_sgn_flg, o.trigger_rating_adj_warn_sgn_flg) as trigger_rating_adj_warn_sgn_flg -- 触发评级调整的预警信号标志
    ,nvl(n.warn_sgn_type_cd, o.warn_sgn_type_cd) as warn_sgn_type_cd -- 预警信号类型代码
    ,nvl(n.warn_descb, o.warn_descb) as warn_descb -- 预警描述
    ,nvl(n.warn_hibchy, o.warn_hibchy) as warn_hibchy -- 预警层级
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.final_update_teller_id, o.final_update_teller_id) as final_update_teller_id -- 最后更新柜员编号
    ,nvl(n.final_update_org_id, o.final_update_org_id) as final_update_org_id -- 最后更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,case when
            n.warn_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.warn_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.warn_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_tm n
    full join (select * from ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.warn_id = n.warn_id
            and o.lp_id = n.lp_id
where (
        o.warn_id is null
        and o.lp_id is null
    )
    or (
        n.warn_id is null
        and n.lp_id is null
    )
    or (
        o.warn_name <> n.warn_name
        or o.trigger_rating_adj_warn_sgn_flg <> n.trigger_rating_adj_warn_sgn_flg
        or o.warn_sgn_type_cd <> n.warn_sgn_type_cd
        or o.warn_descb <> n.warn_descb
        or o.warn_hibchy <> n.warn_hibchy
        or o.cust_type_cd <> n.cust_type_cd
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.final_update_teller_id <> n.final_update_teller_id
        or o.final_update_org_id <> n.final_update_org_id
        or o.modif_dt <> n.modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_cl(
            warn_id -- 预警编号
    ,lp_id -- 法人编号
    ,warn_name -- 预警名称
    ,trigger_rating_adj_warn_sgn_flg -- 触发评级调整的预警信号标志
    ,warn_sgn_type_cd -- 预警信号类型代码
    ,warn_descb -- 预警描述
    ,warn_hibchy -- 预警层级
    ,cust_type_cd -- 客户类型代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_op(
            warn_id -- 预警编号
    ,lp_id -- 法人编号
    ,warn_name -- 预警名称
    ,trigger_rating_adj_warn_sgn_flg -- 触发评级调整的预警信号标志
    ,warn_sgn_type_cd -- 预警信号类型代码
    ,warn_descb -- 预警描述
    ,warn_hibchy -- 预警层级
    ,cust_type_cd -- 客户类型代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.warn_id -- 预警编号
    ,o.lp_id -- 法人编号
    ,o.warn_name -- 预警名称
    ,o.trigger_rating_adj_warn_sgn_flg -- 触发评级调整的预警信号标志
    ,o.warn_sgn_type_cd -- 预警信号类型代码
    ,o.warn_descb -- 预警描述
    ,o.warn_hibchy -- 预警层级
    ,o.cust_type_cd -- 客户类型代码
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.final_update_teller_id -- 最后更新柜员编号
    ,o.final_update_org_id -- 最后更新机构编号
    ,o.modif_dt -- 变更日期
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
from ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_bk o
    left join ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_op n
        on
            o.warn_id = n.warn_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_cl d
        on
            o.warn_id = d.warn_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_risk_warn_sgn_dtl_h;
--alter table ${iml_schema}.ref_risk_warn_sgn_dtl_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_risk_warn_sgn_dtl_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_risk_warn_sgn_dtl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_risk_warn_sgn_dtl_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_risk_warn_sgn_dtl_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_cl;
alter table ${iml_schema}.ref_risk_warn_sgn_dtl_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_risk_warn_sgn_dtl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_tm purge;
drop table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_op purge;
drop table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_risk_warn_sgn_dtl_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_risk_warn_sgn_dtl_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
