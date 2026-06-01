/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bus_and_lmt_rela_h_icmsf1
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
alter table ${iml_schema}.agt_bus_and_lmt_rela_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bus_and_lmt_rela_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_op purge;
drop table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    bus_id -- 业务编号
    ,lmt_id -- 额度编号
    ,rela_type_cd -- 关系类型代码
    ,role_type_cd -- 角色类型代码
    ,cust_id -- 客户编号
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,ocup_curr_cd -- 占用币种代码
    ,ocup_open_amt -- 占用敞口金额
    ,ocup_nmal_amt -- 占用名义金额
    ,actl_ocup_open_amt -- 实际占用敞口金额
    ,actl_ocup_nmal_amt -- 实际占用名义金额
    ,valid_flg -- 有效标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bus_and_lmt_rela_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bus_and_lmt_rela_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bus_and_lmt_rela_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_cl_business_credit_relation-1
insert into ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_tm(
    bus_id -- 业务编号
    ,lmt_id -- 额度编号
    ,rela_type_cd -- 关系类型代码
    ,role_type_cd -- 角色类型代码
    ,cust_id -- 客户编号
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,ocup_curr_cd -- 占用币种代码
    ,ocup_open_amt -- 占用敞口金额
    ,ocup_nmal_amt -- 占用名义金额
    ,actl_ocup_open_amt -- 实际占用敞口金额
    ,actl_ocup_nmal_amt -- 实际占用名义金额
    ,valid_flg -- 有效标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BUSINESSNO -- 业务编号
    ,P1.RELATIVECREDITNO -- 额度编号
    ,NVL(P1.RELATIVETYPE,'-') -- 关系类型代码
    ,NVL(P1.ROLETYPE,'-') -- 角色类型代码
    ,P1.CUSTOMERID -- 客户编号
    ,P1.EXECSLOWRELEASEEXPOSUREAMOUNT -- 执行可缓释敞口金额
    ,nvl(trim(P1.OCCUPYCURRENCY),'-') -- 占用币种代码
    ,P1.OCCUPYEXPOSUREAMOUNT -- 占用敞口金额
    ,P1.OCCUPYNOMINALAMOUNT -- 占用名义金额
    ,P1.ACTUALOCCUPYEXPOSUREAMOUNT -- 实际占用敞口金额
    ,P1.ACTUALOCCUPYNOMINALAMOUNT -- 实际占用名义金额
    ,P1.EFFECT -- 有效标志
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,decode(p1.INPUTDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.INPUTDATE) -- 登记日期
    ,P1.UPDATEUSERID -- 最后更新柜员编号
    ,P1.UPDATEORGID -- 最后更新机构编号
    ,decode(p1.UPDATEDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.UPDATEDATE) -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_cl_business_credit_relation' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_cl_business_credit_relation p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_tm 
  	                                group by 
  	                                        bus_id
  	                                        ,lmt_id
  	                                        ,rela_type_cd
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
        into ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_cl(
            bus_id -- 业务编号
    ,lmt_id -- 额度编号
    ,rela_type_cd -- 关系类型代码
    ,role_type_cd -- 角色类型代码
    ,cust_id -- 客户编号
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,ocup_curr_cd -- 占用币种代码
    ,ocup_open_amt -- 占用敞口金额
    ,ocup_nmal_amt -- 占用名义金额
    ,actl_ocup_open_amt -- 实际占用敞口金额
    ,actl_ocup_nmal_amt -- 实际占用名义金额
    ,valid_flg -- 有效标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_op(
            bus_id -- 业务编号
    ,lmt_id -- 额度编号
    ,rela_type_cd -- 关系类型代码
    ,role_type_cd -- 角色类型代码
    ,cust_id -- 客户编号
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,ocup_curr_cd -- 占用币种代码
    ,ocup_open_amt -- 占用敞口金额
    ,ocup_nmal_amt -- 占用名义金额
    ,actl_ocup_open_amt -- 实际占用敞口金额
    ,actl_ocup_nmal_amt -- 实际占用名义金额
    ,valid_flg -- 有效标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.lmt_id, o.lmt_id) as lmt_id -- 额度编号
    ,nvl(n.rela_type_cd, o.rela_type_cd) as rela_type_cd -- 关系类型代码
    ,nvl(n.role_type_cd, o.role_type_cd) as role_type_cd -- 角色类型代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.exec_dr_open_amt, o.exec_dr_open_amt) as exec_dr_open_amt -- 执行可缓释敞口金额
    ,nvl(n.ocup_curr_cd, o.ocup_curr_cd) as ocup_curr_cd -- 占用币种代码
    ,nvl(n.ocup_open_amt, o.ocup_open_amt) as ocup_open_amt -- 占用敞口金额
    ,nvl(n.ocup_nmal_amt, o.ocup_nmal_amt) as ocup_nmal_amt -- 占用名义金额
    ,nvl(n.actl_ocup_open_amt, o.actl_ocup_open_amt) as actl_ocup_open_amt -- 实际占用敞口金额
    ,nvl(n.actl_ocup_nmal_amt, o.actl_ocup_nmal_amt) as actl_ocup_nmal_amt -- 实际占用名义金额
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.final_update_teller_id, o.final_update_teller_id) as final_update_teller_id -- 最后更新柜员编号
    ,nvl(n.final_update_org_id, o.final_update_org_id) as final_update_org_id -- 最后更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.bus_id is null
            and n.lmt_id is null
            and n.rela_type_cd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bus_id is null
            and n.lmt_id is null
            and n.rela_type_cd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bus_id is null
            and n.lmt_id is null
            and n.rela_type_cd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.bus_id = n.bus_id
            and o.lmt_id = n.lmt_id
            and o.rela_type_cd = n.rela_type_cd
where (
        o.bus_id is null
        and o.lmt_id is null
        and o.rela_type_cd is null
    )
    or (
        n.bus_id is null
        and n.lmt_id is null
        and n.rela_type_cd is null
    )
    or (
        o.role_type_cd <> n.role_type_cd
        or o.cust_id <> n.cust_id
        or o.exec_dr_open_amt <> n.exec_dr_open_amt
        or o.ocup_curr_cd <> n.ocup_curr_cd
        or o.ocup_open_amt <> n.ocup_open_amt
        or o.ocup_nmal_amt <> n.ocup_nmal_amt
        or o.actl_ocup_open_amt <> n.actl_ocup_open_amt
        or o.actl_ocup_nmal_amt <> n.actl_ocup_nmal_amt
        or o.valid_flg <> n.valid_flg
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.final_update_teller_id <> n.final_update_teller_id
        or o.final_update_org_id <> n.final_update_org_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_cl(
            bus_id -- 业务编号
    ,lmt_id -- 额度编号
    ,rela_type_cd -- 关系类型代码
    ,role_type_cd -- 角色类型代码
    ,cust_id -- 客户编号
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,ocup_curr_cd -- 占用币种代码
    ,ocup_open_amt -- 占用敞口金额
    ,ocup_nmal_amt -- 占用名义金额
    ,actl_ocup_open_amt -- 实际占用敞口金额
    ,actl_ocup_nmal_amt -- 实际占用名义金额
    ,valid_flg -- 有效标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_op(
            bus_id -- 业务编号
    ,lmt_id -- 额度编号
    ,rela_type_cd -- 关系类型代码
    ,role_type_cd -- 角色类型代码
    ,cust_id -- 客户编号
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,ocup_curr_cd -- 占用币种代码
    ,ocup_open_amt -- 占用敞口金额
    ,ocup_nmal_amt -- 占用名义金额
    ,actl_ocup_open_amt -- 实际占用敞口金额
    ,actl_ocup_nmal_amt -- 实际占用名义金额
    ,valid_flg -- 有效标志
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,final_update_teller_id -- 最后更新柜员编号
    ,final_update_org_id -- 最后更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bus_id -- 业务编号
    ,o.lmt_id -- 额度编号
    ,o.rela_type_cd -- 关系类型代码
    ,o.role_type_cd -- 角色类型代码
    ,o.cust_id -- 客户编号
    ,o.exec_dr_open_amt -- 执行可缓释敞口金额
    ,o.ocup_curr_cd -- 占用币种代码
    ,o.ocup_open_amt -- 占用敞口金额
    ,o.ocup_nmal_amt -- 占用名义金额
    ,o.actl_ocup_open_amt -- 实际占用敞口金额
    ,o.actl_ocup_nmal_amt -- 实际占用名义金额
    ,o.valid_flg -- 有效标志
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.final_update_teller_id -- 最后更新柜员编号
    ,o.final_update_org_id -- 最后更新机构编号
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_bk o
    left join ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_op n
        on
            o.bus_id = n.bus_id
            and o.lmt_id = n.lmt_id
            and o.rela_type_cd = n.rela_type_cd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_cl d
        on
            o.bus_id = d.bus_id
            and o.lmt_id = d.lmt_id
            and o.rela_type_cd = d.rela_type_cd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_bus_and_lmt_rela_h;
--alter table ${iml_schema}.agt_bus_and_lmt_rela_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_bus_and_lmt_rela_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_bus_and_lmt_rela_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_bus_and_lmt_rela_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_bus_and_lmt_rela_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_cl;
alter table ${iml_schema}.agt_bus_and_lmt_rela_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bus_and_lmt_rela_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_op purge;
drop table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_bus_and_lmt_rela_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bus_and_lmt_rela_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
