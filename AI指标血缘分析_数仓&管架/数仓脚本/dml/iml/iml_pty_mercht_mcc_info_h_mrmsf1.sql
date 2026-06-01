/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_mercht_mcc_info_h_mrmsf1
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
alter table ${iml_schema}.pty_mercht_mcc_info_h add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_mercht_mcc_info_h partition for ('mrmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_op purge;
drop table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    mercht_mcc_id -- 商户MCC编号
    ,lp_id -- 法人编号
    ,mcc_descb -- MCC描述
    ,fee_rat -- 费率
    ,remark -- 备注
    ,final_oper_status_descb -- 最后操作状态描述
    ,update_tm -- 更新时间
    ,create_tm -- 创建时间
    ,mercht_cls_descb -- 商户分类描述
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_mercht_mcc_info_h partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_mercht_mcc_info_h partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_mercht_mcc_info_h partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_mcht_mcc_inf-
insert into ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_tm(
    mercht_mcc_id -- 商户MCC编号
    ,lp_id -- 法人编号
    ,mcc_descb -- MCC描述
    ,fee_rat -- 费率
    ,remark -- 备注
    ,final_oper_status_descb -- 最后操作状态描述
    ,update_tm -- 更新时间
    ,create_tm -- 创建时间
    ,mercht_cls_descb -- 商户分类描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.MCHNT_TP -- 商户MCC编号
    ,'9999' -- 法人编号
    ,P1.DESCR -- MCC描述
    ,TO_NUMBER(NVL(TRIM(REGEXP_SUBSTR(P1.FEE_RATE, '[0-9.]+')),0)) -- 费率
    ,P1.REMARK -- 备注
    ,P1.LAST_OPER_IN -- 最后操作状态描述
    ,${iml_schema}.DATEFORMAT_MAX(P1.REC_UPD_TS) -- 更新时间
    ,${iml_schema}.DATEFORMAT_MIN(P1.REC_CRT_TS) -- 创建时间
    ,P1.RESERVED -- 商户分类描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_mcht_mcc_inf' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_mcht_mcc_inf p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_tm 
  	                                group by 
  	                                        mercht_mcc_id
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
        into ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_cl(
            mercht_mcc_id -- 商户MCC编号
    ,lp_id -- 法人编号
    ,mcc_descb -- MCC描述
    ,fee_rat -- 费率
    ,remark -- 备注
    ,final_oper_status_descb -- 最后操作状态描述
    ,update_tm -- 更新时间
    ,create_tm -- 创建时间
    ,mercht_cls_descb -- 商户分类描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_op(
            mercht_mcc_id -- 商户MCC编号
    ,lp_id -- 法人编号
    ,mcc_descb -- MCC描述
    ,fee_rat -- 费率
    ,remark -- 备注
    ,final_oper_status_descb -- 最后操作状态描述
    ,update_tm -- 更新时间
    ,create_tm -- 创建时间
    ,mercht_cls_descb -- 商户分类描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mercht_mcc_id, o.mercht_mcc_id) as mercht_mcc_id -- 商户MCC编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.mcc_descb, o.mcc_descb) as mcc_descb -- MCC描述
    ,nvl(n.fee_rat, o.fee_rat) as fee_rat -- 费率
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.final_oper_status_descb, o.final_oper_status_descb) as final_oper_status_descb -- 最后操作状态描述
    ,nvl(n.update_tm, o.update_tm) as update_tm -- 更新时间
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.mercht_cls_descb, o.mercht_cls_descb) as mercht_cls_descb -- 商户分类描述
    ,case when
            n.mercht_mcc_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mercht_mcc_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mercht_mcc_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_tm n
    full join (select * from ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.mercht_mcc_id = n.mercht_mcc_id
            and o.lp_id = n.lp_id
where (
        o.mercht_mcc_id is null
        and o.lp_id is null
    )
    or (
        n.mercht_mcc_id is null
        and n.lp_id is null
    )
    or (
        o.mcc_descb <> n.mcc_descb
        or o.fee_rat <> n.fee_rat
        or o.remark <> n.remark
        or o.final_oper_status_descb <> n.final_oper_status_descb
        or o.update_tm <> n.update_tm
        or o.create_tm <> n.create_tm
        or o.mercht_cls_descb <> n.mercht_cls_descb
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_cl(
            mercht_mcc_id -- 商户MCC编号
    ,lp_id -- 法人编号
    ,mcc_descb -- MCC描述
    ,fee_rat -- 费率
    ,remark -- 备注
    ,final_oper_status_descb -- 最后操作状态描述
    ,update_tm -- 更新时间
    ,create_tm -- 创建时间
    ,mercht_cls_descb -- 商户分类描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_op(
            mercht_mcc_id -- 商户MCC编号
    ,lp_id -- 法人编号
    ,mcc_descb -- MCC描述
    ,fee_rat -- 费率
    ,remark -- 备注
    ,final_oper_status_descb -- 最后操作状态描述
    ,update_tm -- 更新时间
    ,create_tm -- 创建时间
    ,mercht_cls_descb -- 商户分类描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mercht_mcc_id -- 商户MCC编号
    ,o.lp_id -- 法人编号
    ,o.mcc_descb -- MCC描述
    ,o.fee_rat -- 费率
    ,o.remark -- 备注
    ,o.final_oper_status_descb -- 最后操作状态描述
    ,o.update_tm -- 更新时间
    ,o.create_tm -- 创建时间
    ,o.mercht_cls_descb -- 商户分类描述
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
from ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_bk o
    left join ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_op n
        on
            o.mercht_mcc_id = n.mercht_mcc_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_cl d
        on
            o.mercht_mcc_id = d.mercht_mcc_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_mercht_mcc_info_h;
--alter table ${iml_schema}.pty_mercht_mcc_info_h truncate partition for ('mrmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_mercht_mcc_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mrmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_mercht_mcc_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_mercht_mcc_info_h modify partition p_mrmsf1 
add subpartition p_mrmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_mercht_mcc_info_h exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_cl;
alter table ${iml_schema}.pty_mercht_mcc_info_h exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_mercht_mcc_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_op purge;
drop table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_mercht_mcc_info_h_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_mercht_mcc_info_h', partname => 'p_mrmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
