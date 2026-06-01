/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_prod_catlg_h_ncbsf1
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
alter table ${iml_schema}.prd_prod_catlg_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.prd_prod_catlg_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_prod_catlg_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.prd_prod_catlg_h_ncbsf1_tm purge;
drop table ${iml_schema}.prd_prod_catlg_h_ncbsf1_op purge;
drop table ${iml_schema}.prd_prod_catlg_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_prod_catlg_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_hibchy -- 产品层级
    ,prod_gen_id -- 产品线大类编号
    ,prod_gen_name -- 产品线大类名称
    ,prod_sclass_id -- 产品线小类编号
    ,prod_sclass_name -- 产品线小类名称
    ,prod_group_id -- 产品组编号
    ,prod_group_name -- 产品组名称
    ,base_prod_id -- 基础产品编号
    ,base_prod_name -- 基础产品名称
    ,sellbl_prod_id -- 可售产品编号
    ,sellbl_prod_name -- 可售产品名称
    ,prod_descb -- 产品描述
    ,prod_status_cd -- 产品状态代码
    ,mgmt_org_id -- 管理机构编号
    ,sys_id -- 系统编号
    ,tran_tm -- 交易时间
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_prod_catlg_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.prd_prod_catlg_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_prod_catlg_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.prd_prod_catlg_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.prd_prod_catlg_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_mb_fee_catalog-1
insert into ${iml_schema}.prd_prod_catlg_h_ncbsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_hibchy -- 产品层级
    ,prod_gen_id -- 产品线大类编号
    ,prod_gen_name -- 产品线大类名称
    ,prod_sclass_id -- 产品线小类编号
    ,prod_sclass_name -- 产品线小类名称
    ,prod_group_id -- 产品组编号
    ,prod_group_name -- 产品组名称
    ,base_prod_id -- 基础产品编号
    ,base_prod_name -- 基础产品名称
    ,sellbl_prod_id -- 可售产品编号
    ,sellbl_prod_name -- 可售产品名称
    ,prod_descb -- 产品描述
    ,prod_status_cd -- 产品状态代码
    ,mgmt_org_id -- 管理机构编号
    ,sys_id -- 系统编号
    ,effect_dt -- 交易时间
    ,invalid_dt -- 生效日期
    ,tran_tm -- 失效日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CATALOG_NO -- 产品编号
    ,'9999' -- 法人编号
    ,case when length(p1.CATALOG_NO)=1 then 1
     when length(p1.CATALOG_NO)=3 then 2
     when length(p1.CATALOG_NO)=5 then 3
     when length(p1.CATALOG_NO)=7 then 4
     else 5 end -- 产品层级
    ,P1.FEE_CLASS -- 产品线大类编号
    ,P1.FEE_CLASS_NAME -- 产品线大类名称
    ,P1.FEE_SUB_CLASS -- 产品线小类编号
    ,P1.FEE_SUB_CLASS_NAME -- 产品线小类名称
    ,P1.FEE_GROUP -- 产品组编号
    ,P1.FEE_GROUP_NAME -- 产品组名称
    ,P1.BASE_FEE -- 基础产品编号
    ,P1.BASE_FEE_NAME -- 基础产品名称
    ,P1.FEE_TYPE -- 可售产品编号
    ,P1.FEE_NAME -- 可售产品名称
    ,P1.FEE_DESC -- 产品描述
    ,nvl(trim(P1.FEE_STATUS),'-') -- 产品状态代码
    ,P1.MANAGE_DEPT -- 管理机构编号
    ,P1.SYSTEM_ID -- 系统编号
    ,P1.EFFECT_DATE -- 交易时间
    ,P1.EXPIRE_DATE -- 生效日期
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 失效日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_mb_fee_catalog' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_mb_fee_catalog p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ncbs_mb_prod_catalog-1
insert into ${iml_schema}.prd_prod_catlg_h_ncbsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_hibchy -- 产品层级
    ,prod_gen_id -- 产品线大类编号
    ,prod_gen_name -- 产品线大类名称
    ,prod_sclass_id -- 产品线小类编号
    ,prod_sclass_name -- 产品线小类名称
    ,prod_group_id -- 产品组编号
    ,prod_group_name -- 产品组名称
    ,base_prod_id -- 基础产品编号
    ,base_prod_name -- 基础产品名称
    ,sellbl_prod_id -- 可售产品编号
    ,sellbl_prod_name -- 可售产品名称
    ,prod_descb -- 产品描述
    ,prod_status_cd -- 产品状态代码
    ,mgmt_org_id -- 管理机构编号
    ,sys_id -- 系统编号
    ,effect_dt -- 交易时间
    ,invalid_dt -- 生效日期
    ,tran_tm -- 失效日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CATALOG_NO -- 产品编号
    ,'9999' -- 法人编号
    ,P1.CTLG_LEVEL -- 产品层级
    ,P1.PROD_CLASS -- 产品线大类编号
    ,P1.PROD_CLASS_NAME -- 产品线大类名称
    ,P1.PROD_SUB_CLASS -- 产品线小类编号
    ,P1.PROD_SUB_CLASS_NAME -- 产品线小类名称
    ,P1.PROD_GROUP -- 产品组编号
    ,P1.PROD_GROUP_NAME -- 产品组名称
    ,P1.BASE_PROD -- 基础产品编号
    ,P1.BASE_PROD_NAME -- 基础产品名称
    ,P1.PROD_TYPE -- 可售产品编号
    ,P1.PROD_NAME -- 可售产品名称
    ,P1.PROD_DESC -- 产品描述
    ,nvl(trim(P1.PROD_STATUS),'-') -- 产品状态代码
    ,P1.MANAGE_DEPT -- 管理机构编号
    ,P1.SYSTEM_ID -- 系统编号
    ,P1.EFFECT_DATE -- 交易时间
    ,P1.EXPIRE_DATE -- 生效日期
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 失效日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_mb_prod_catalog' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_mb_prod_catalog p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.prd_prod_catlg_h_ncbsf1_tm 
  	                                group by 
  	                                        prod_id
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
        into ${iml_schema}.prd_prod_catlg_h_ncbsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_hibchy -- 产品层级
    ,prod_gen_id -- 产品线大类编号
    ,prod_gen_name -- 产品线大类名称
    ,prod_sclass_id -- 产品线小类编号
    ,prod_sclass_name -- 产品线小类名称
    ,prod_group_id -- 产品组编号
    ,prod_group_name -- 产品组名称
    ,base_prod_id -- 基础产品编号
    ,base_prod_name -- 基础产品名称
    ,sellbl_prod_id -- 可售产品编号
    ,sellbl_prod_name -- 可售产品名称
    ,prod_descb -- 产品描述
    ,prod_status_cd -- 产品状态代码
    ,mgmt_org_id -- 管理机构编号
    ,sys_id -- 系统编号
    ,tran_tm -- 交易时间
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_prod_catlg_h_ncbsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_hibchy -- 产品层级
    ,prod_gen_id -- 产品线大类编号
    ,prod_gen_name -- 产品线大类名称
    ,prod_sclass_id -- 产品线小类编号
    ,prod_sclass_name -- 产品线小类名称
    ,prod_group_id -- 产品组编号
    ,prod_group_name -- 产品组名称
    ,base_prod_id -- 基础产品编号
    ,base_prod_name -- 基础产品名称
    ,sellbl_prod_id -- 可售产品编号
    ,sellbl_prod_name -- 可售产品名称
    ,prod_descb -- 产品描述
    ,prod_status_cd -- 产品状态代码
    ,mgmt_org_id -- 管理机构编号
    ,sys_id -- 系统编号
    ,tran_tm -- 交易时间
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
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
    ,nvl(n.prod_hibchy, o.prod_hibchy) as prod_hibchy -- 产品层级
    ,nvl(n.prod_gen_id, o.prod_gen_id) as prod_gen_id -- 产品线大类编号
    ,nvl(n.prod_gen_name, o.prod_gen_name) as prod_gen_name -- 产品线大类名称
    ,nvl(n.prod_sclass_id, o.prod_sclass_id) as prod_sclass_id -- 产品线小类编号
    ,nvl(n.prod_sclass_name, o.prod_sclass_name) as prod_sclass_name -- 产品线小类名称
    ,nvl(n.prod_group_id, o.prod_group_id) as prod_group_id -- 产品组编号
    ,nvl(n.prod_group_name, o.prod_group_name) as prod_group_name -- 产品组名称
    ,nvl(n.base_prod_id, o.base_prod_id) as base_prod_id -- 基础产品编号
    ,nvl(n.base_prod_name, o.base_prod_name) as base_prod_name -- 基础产品名称
    ,nvl(n.sellbl_prod_id, o.sellbl_prod_id) as sellbl_prod_id -- 可售产品编号
    ,nvl(n.sellbl_prod_name, o.sellbl_prod_name) as sellbl_prod_name -- 可售产品名称
    ,nvl(n.prod_descb, o.prod_descb) as prod_descb -- 产品描述
    ,nvl(n.prod_status_cd, o.prod_status_cd) as prod_status_cd -- 产品状态代码
    ,nvl(n.mgmt_org_id, o.mgmt_org_id) as mgmt_org_id -- 管理机构编号
    ,nvl(n.sys_id, o.sys_id) as sys_id -- 系统编号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,case when
            n.prod_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prod_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prod_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_prod_catlg_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.prd_prod_catlg_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.prod_id = n.prod_id
where (
        o.prod_id is null
    )
    or (
        n.prod_id is null
    )
    or (
        o.lp_id <> n.lp_id
        or o.prod_hibchy <> n.prod_hibchy
        or o.prod_gen_id <> n.prod_gen_id
        or o.prod_gen_name <> n.prod_gen_name
        or o.prod_sclass_id <> n.prod_sclass_id
        or o.prod_sclass_name <> n.prod_sclass_name
        or o.prod_group_id <> n.prod_group_id
        or o.prod_group_name <> n.prod_group_name
        or o.base_prod_id <> n.base_prod_id
        or o.base_prod_name <> n.base_prod_name
        or o.sellbl_prod_id <> n.sellbl_prod_id
        or o.sellbl_prod_name <> n.sellbl_prod_name
        or o.prod_descb <> n.prod_descb
        or o.prod_status_cd <> n.prod_status_cd
        or o.mgmt_org_id <> n.mgmt_org_id
        or o.sys_id <> n.sys_id
        or o.tran_tm <> n.tran_tm
        or o.effect_dt <> n.effect_dt
        or o.invalid_dt <> n.invalid_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.prd_prod_catlg_h_ncbsf1_cl(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_hibchy -- 产品层级
    ,prod_gen_id -- 产品线大类编号
    ,prod_gen_name -- 产品线大类名称
    ,prod_sclass_id -- 产品线小类编号
    ,prod_sclass_name -- 产品线小类名称
    ,prod_group_id -- 产品组编号
    ,prod_group_name -- 产品组名称
    ,base_prod_id -- 基础产品编号
    ,base_prod_name -- 基础产品名称
    ,sellbl_prod_id -- 可售产品编号
    ,sellbl_prod_name -- 可售产品名称
    ,prod_descb -- 产品描述
    ,prod_status_cd -- 产品状态代码
    ,mgmt_org_id -- 管理机构编号
    ,sys_id -- 系统编号
    ,tran_tm -- 交易时间
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.prd_prod_catlg_h_ncbsf1_op(
            prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,prod_hibchy -- 产品层级
    ,prod_gen_id -- 产品线大类编号
    ,prod_gen_name -- 产品线大类名称
    ,prod_sclass_id -- 产品线小类编号
    ,prod_sclass_name -- 产品线小类名称
    ,prod_group_id -- 产品组编号
    ,prod_group_name -- 产品组名称
    ,base_prod_id -- 基础产品编号
    ,base_prod_name -- 基础产品名称
    ,sellbl_prod_id -- 可售产品编号
    ,sellbl_prod_name -- 可售产品名称
    ,prod_descb -- 产品描述
    ,prod_status_cd -- 产品状态代码
    ,mgmt_org_id -- 管理机构编号
    ,sys_id -- 系统编号
    ,tran_tm -- 交易时间
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
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
    ,o.prod_hibchy -- 产品层级
    ,o.prod_gen_id -- 产品线大类编号
    ,o.prod_gen_name -- 产品线大类名称
    ,o.prod_sclass_id -- 产品线小类编号
    ,o.prod_sclass_name -- 产品线小类名称
    ,o.prod_group_id -- 产品组编号
    ,o.prod_group_name -- 产品组名称
    ,o.base_prod_id -- 基础产品编号
    ,o.base_prod_name -- 基础产品名称
    ,o.sellbl_prod_id -- 可售产品编号
    ,o.sellbl_prod_name -- 可售产品名称
    ,o.prod_descb -- 产品描述
    ,o.prod_status_cd -- 产品状态代码
    ,o.mgmt_org_id -- 管理机构编号
    ,o.sys_id -- 系统编号
    ,o.tran_tm -- 交易时间
    ,o.effect_dt -- 生效日期
    ,o.invalid_dt -- 失效日期
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
from ${iml_schema}.prd_prod_catlg_h_ncbsf1_bk o
    left join ${iml_schema}.prd_prod_catlg_h_ncbsf1_op n
        on
            o.prod_id = n.prod_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.prd_prod_catlg_h_ncbsf1_cl d
        on
            o.prod_id = d.prod_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.prd_prod_catlg_h;
--alter table ${iml_schema}.prd_prod_catlg_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('prd_prod_catlg_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.prd_prod_catlg_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.prd_prod_catlg_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.prd_prod_catlg_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.prd_prod_catlg_h_ncbsf1_cl;
alter table ${iml_schema}.prd_prod_catlg_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.prd_prod_catlg_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_prod_catlg_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.prd_prod_catlg_h_ncbsf1_tm purge;
drop table ${iml_schema}.prd_prod_catlg_h_ncbsf1_op purge;
drop table ${iml_schema}.prd_prod_catlg_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.prd_prod_catlg_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_prod_catlg_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
