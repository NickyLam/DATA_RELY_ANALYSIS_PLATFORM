/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_bill_rgst_batch_dtl_h_bdmsf1
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
alter table ${iml_schema}.evt_bill_rgst_batch_dtl_h add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_rgst_batch_dtl_h partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_tm purge;
drop table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_op purge;
drop table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_dtl_id -- 登记明细编号
    ,rgst_id -- 登记编号
    ,rgst_way_cd -- 登记方式代码
    ,bill_id -- 票据编号
    ,bus_dt -- 业务日期
    ,bus_org_id -- 业务机构编号
    ,rgst_org_id -- 登记机构编号
    ,proc_status_cd -- 处理状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_rgst_batch_dtl_h partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_rgst_batch_dtl_h partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_bill_rgst_batch_dtl_h partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_cpes_register_details-
insert into ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_dtl_id -- 登记明细编号
    ,rgst_id -- 登记编号
    ,rgst_way_cd -- 登记方式代码
    ,bill_id -- 票据编号
    ,bus_dt -- 业务日期
    ,bus_org_id -- 业务机构编号
    ,rgst_org_id -- 登记机构编号
    ,proc_status_cd -- 处理状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102071'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 登记明细编号
    ,P1.CONTRACT_ID -- 登记编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.REG_TYPE END -- 登记方式代码
    ,P1.DRAFT_ID -- 票据编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.BUSI_DATE) -- 业务日期
    ,NVL(P2.BR_NO,' ') -- 业务机构编号
    ,NVL(P3.BR_NO,' ') -- 登记机构编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DEAL_STATUS END -- 处理状态代码
    ,P1.LAST_UPD_OPR -- 最后修改操作员编号
    ,${iml_schema}.timeformat_min(P1.LAST_UPD_TIME) -- 最后修改时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_register_details' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_register_details p1
    left join ${iol_schema}.bdms_bctl p2 on P1.BUSI_BRH_NO=P2.ID AND  P2.START_DT <= TO_DATE('${batch_date}','YYYYMMDD') and P2.END_DT > TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iol_schema}.bdms_bctl p3 on P1.REGISTER_BRH_NO=P3.ID AND  P3.START_DT <= TO_DATE('${batch_date}','YYYYMMDD') and P3.END_DT > TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.REG_TYPE= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CPES_REGISTER_DETAILS'
        AND R1.SRC_FIELD_EN_NAME= 'REG_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_BILL_RGST_BATCH_DTL_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'RGST_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DEAL_STATUS= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CPES_REGISTER_DETAILS'
        AND R2.SRC_FIELD_EN_NAME= 'DEAL_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_BILL_RGST_BATCH_DTL_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'PROC_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_tm 
  	                                group by 
  	                                        evt_id
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
        into ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_dtl_id -- 登记明细编号
    ,rgst_id -- 登记编号
    ,rgst_way_cd -- 登记方式代码
    ,bill_id -- 票据编号
    ,bus_dt -- 业务日期
    ,bus_org_id -- 业务机构编号
    ,rgst_org_id -- 登记机构编号
    ,proc_status_cd -- 处理状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_dtl_id -- 登记明细编号
    ,rgst_id -- 登记编号
    ,rgst_way_cd -- 登记方式代码
    ,bill_id -- 票据编号
    ,bus_dt -- 业务日期
    ,bus_org_id -- 业务机构编号
    ,rgst_org_id -- 登记机构编号
    ,proc_status_cd -- 处理状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.rgst_dtl_id, o.rgst_dtl_id) as rgst_dtl_id -- 登记明细编号
    ,nvl(n.rgst_id, o.rgst_id) as rgst_id -- 登记编号
    ,nvl(n.rgst_way_cd, o.rgst_way_cd) as rgst_way_cd -- 登记方式代码
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.bus_dt, o.bus_dt) as bus_dt -- 业务日期
    ,nvl(n.bus_org_id, o.bus_org_id) as bus_org_id -- 业务机构编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.proc_status_cd, o.proc_status_cd) as proc_status_cd -- 处理状态代码
    ,nvl(n.final_modif_operr_id, o.final_modif_operr_id) as final_modif_operr_id -- 最后修改操作员编号
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_tm n
    full join (select * from ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.rgst_dtl_id <> n.rgst_dtl_id
        or o.rgst_id <> n.rgst_id
        or o.rgst_way_cd <> n.rgst_way_cd
        or o.bill_id <> n.bill_id
        or o.bus_dt <> n.bus_dt
        or o.bus_org_id <> n.bus_org_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.proc_status_cd <> n.proc_status_cd
        or o.final_modif_operr_id <> n.final_modif_operr_id
        or o.final_modif_tm <> n.final_modif_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_dtl_id -- 登记明细编号
    ,rgst_id -- 登记编号
    ,rgst_way_cd -- 登记方式代码
    ,bill_id -- 票据编号
    ,bus_dt -- 业务日期
    ,bus_org_id -- 业务机构编号
    ,rgst_org_id -- 登记机构编号
    ,proc_status_cd -- 处理状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_dtl_id -- 登记明细编号
    ,rgst_id -- 登记编号
    ,rgst_way_cd -- 登记方式代码
    ,bill_id -- 票据编号
    ,bus_dt -- 业务日期
    ,bus_org_id -- 业务机构编号
    ,rgst_org_id -- 登记机构编号
    ,proc_status_cd -- 处理状态代码
    ,final_modif_operr_id -- 最后修改操作员编号
    ,final_modif_tm -- 最后修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.rgst_dtl_id -- 登记明细编号
    ,o.rgst_id -- 登记编号
    ,o.rgst_way_cd -- 登记方式代码
    ,o.bill_id -- 票据编号
    ,o.bus_dt -- 业务日期
    ,o.bus_org_id -- 业务机构编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.proc_status_cd -- 处理状态代码
    ,o.final_modif_operr_id -- 最后修改操作员编号
    ,o.final_modif_tm -- 最后修改时间
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
from ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_bk o
    left join ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_bill_rgst_batch_dtl_h;
--alter table ${iml_schema}.evt_bill_rgst_batch_dtl_h truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_bill_rgst_batch_dtl_h') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_bill_rgst_batch_dtl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_bill_rgst_batch_dtl_h modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_bill_rgst_batch_dtl_h exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_cl;
alter table ${iml_schema}.evt_bill_rgst_batch_dtl_h exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_bill_rgst_batch_dtl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_tm purge;
drop table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_op purge;
drop table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_bill_rgst_batch_dtl_h_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_bill_rgst_batch_dtl_h', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
