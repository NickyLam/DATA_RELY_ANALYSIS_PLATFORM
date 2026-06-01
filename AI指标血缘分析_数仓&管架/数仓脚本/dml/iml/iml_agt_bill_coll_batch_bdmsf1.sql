/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_coll_batch_bdmsf1
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
alter table ${iml_schema}.agt_bill_coll_batch add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_coll_batch_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_coll_batch partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_bill_coll_batch_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_coll_batch_bdmsf1_op purge;
drop table ${iml_schema}.agt_bill_coll_batch_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_coll_batch_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,bus_id -- 业务编号
    ,cust_acct_num -- 客户账号
    ,agt_apv_status_cd -- 协议审批状态代码
    ,entry_status_cd -- 记账状态代码
    ,init_coll_dt -- 发起托收日期
    ,cust_open_bank_no -- 客户开户行行号
    ,cust_name -- 客户名称
    ,open_bank_name -- 开户行行名称
    ,bus_sponsor_id -- 业务发起人编号
    ,final_operr_id -- 最后操作员编号
    ,final_oper_tm -- 最后操作时间
    ,valet_coll_flg -- 代客托收标志
    ,send_out_coll_status_cd -- 发出托收状态代码
    ,coll_appl_dt -- 托收申请日期
    ,org_id -- 机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_coll_batch partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_bill_coll_batch_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_coll_batch partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_bill_coll_batch_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_coll_batch partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_bms_send_coll_contract-
insert into ${iml_schema}.agt_bill_coll_batch_bdmsf1_tm(
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,bus_id -- 业务编号
    ,cust_acct_num -- 客户账号
    ,agt_apv_status_cd -- 协议审批状态代码
    ,entry_status_cd -- 记账状态代码
    ,init_coll_dt -- 发起托收日期
    ,cust_open_bank_no -- 客户开户行行号
    ,cust_name -- 客户名称
    ,open_bank_name -- 开户行行名称
    ,bus_sponsor_id -- 业务发起人编号
    ,final_operr_id -- 最后操作员编号
    ,final_oper_tm -- 最后操作时间
    ,valet_coll_flg -- 代客托收标志
    ,send_out_coll_status_cd -- 发出托收状态代码
    ,coll_appl_dt -- 托收申请日期
    ,org_id -- 机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 批次编号
    ,'9999' -- 法人编号
    ,P1.DRFT_HLDR_NO -- 客户编号
    ,P1.PRODUCT_NO -- 业务编号
    ,P1.DRFT_HLDR_ACCOUNT -- 客户账号
    ,nvl(trim(P1.CONTRACT_STATUS),'-') -- 协议审批状态代码
    ,nvl(trim(P1.ACCOUNT_STATUS),'-') -- 记账状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.TXN_DATE) -- 发起托收日期
    ,P1.DRFT_HLDR_BANK_NO -- 客户开户行行号
    ,P1.DRFT_HLDR_NAME -- 客户名称
    ,P1.DRFT_HLDR_BANK_NAME -- 开户行行名称
    ,P1.OPERATOR_NO -- 业务发起人编号
    ,P1.LAST_OPERATOR_NO -- 最后操作员编号
    ,P1.LAST_TXN_DATE -- 最后操作时间
    ,NVL(TRIM(P1.VALET_FLAG),'-') -- 代客托收标志
    ,nvl(trim(P1.SNED_STATE),'-') -- 发出托收状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLY_DATE） -- 托收申请日期
    ,P1.BUSI_BRANCH_NO -- 机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_send_coll_contract' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_send_coll_contract p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_coll_batch_bdmsf1_tm 
  	                                group by 
  	                                        batch_id
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
        into ${iml_schema}.agt_bill_coll_batch_bdmsf1_cl(
            batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,bus_id -- 业务编号
    ,cust_acct_num -- 客户账号
    ,agt_apv_status_cd -- 协议审批状态代码
    ,entry_status_cd -- 记账状态代码
    ,init_coll_dt -- 发起托收日期
    ,cust_open_bank_no -- 客户开户行行号
    ,cust_name -- 客户名称
    ,open_bank_name -- 开户行行名称
    ,bus_sponsor_id -- 业务发起人编号
    ,final_operr_id -- 最后操作员编号
    ,final_oper_tm -- 最后操作时间
    ,valet_coll_flg -- 代客托收标志
    ,send_out_coll_status_cd -- 发出托收状态代码
    ,coll_appl_dt -- 托收申请日期
    ,org_id -- 机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bill_coll_batch_bdmsf1_op(
            batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,bus_id -- 业务编号
    ,cust_acct_num -- 客户账号
    ,agt_apv_status_cd -- 协议审批状态代码
    ,entry_status_cd -- 记账状态代码
    ,init_coll_dt -- 发起托收日期
    ,cust_open_bank_no -- 客户开户行行号
    ,cust_name -- 客户名称
    ,open_bank_name -- 开户行行名称
    ,bus_sponsor_id -- 业务发起人编号
    ,final_operr_id -- 最后操作员编号
    ,final_oper_tm -- 最后操作时间
    ,valet_coll_flg -- 代客托收标志
    ,send_out_coll_status_cd -- 发出托收状态代码
    ,coll_appl_dt -- 托收申请日期
    ,org_id -- 机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.agt_apv_status_cd, o.agt_apv_status_cd) as agt_apv_status_cd -- 协议审批状态代码
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.init_coll_dt, o.init_coll_dt) as init_coll_dt -- 发起托收日期
    ,nvl(n.cust_open_bank_no, o.cust_open_bank_no) as cust_open_bank_no -- 客户开户行行号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.open_bank_name, o.open_bank_name) as open_bank_name -- 开户行行名称
    ,nvl(n.bus_sponsor_id, o.bus_sponsor_id) as bus_sponsor_id -- 业务发起人编号
    ,nvl(n.final_operr_id, o.final_operr_id) as final_operr_id -- 最后操作员编号
    ,nvl(n.final_oper_tm, o.final_oper_tm) as final_oper_tm -- 最后操作时间
    ,nvl(n.valet_coll_flg, o.valet_coll_flg) as valet_coll_flg -- 代客托收标志
    ,nvl(n.send_out_coll_status_cd, o.send_out_coll_status_cd) as send_out_coll_status_cd -- 发出托收状态代码
    ,nvl(n.coll_appl_dt, o.coll_appl_dt) as coll_appl_dt -- 托收申请日期
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,case when
            n.batch_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batch_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batch_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_coll_batch_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_bill_coll_batch_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.batch_id = n.batch_id
            and o.lp_id = n.lp_id
where (
        o.batch_id is null
        and o.lp_id is null
    )
    or (
        n.batch_id is null
        and n.lp_id is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.bus_id <> n.bus_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.agt_apv_status_cd <> n.agt_apv_status_cd
        or o.entry_status_cd <> n.entry_status_cd
        or o.init_coll_dt <> n.init_coll_dt
        or o.cust_open_bank_no <> n.cust_open_bank_no
        or o.cust_name <> n.cust_name
        or o.open_bank_name <> n.open_bank_name
        or o.bus_sponsor_id <> n.bus_sponsor_id
        or o.final_operr_id <> n.final_operr_id
        or o.final_oper_tm <> n.final_oper_tm
        or o.valet_coll_flg <> n.valet_coll_flg
        or o.send_out_coll_status_cd <> n.send_out_coll_status_cd
        or o.coll_appl_dt <> n.coll_appl_dt
        or o.org_id <> n.org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_bill_coll_batch_bdmsf1_cl(
            batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,bus_id -- 业务编号
    ,cust_acct_num -- 客户账号
    ,agt_apv_status_cd -- 协议审批状态代码
    ,entry_status_cd -- 记账状态代码
    ,init_coll_dt -- 发起托收日期
    ,cust_open_bank_no -- 客户开户行行号
    ,cust_name -- 客户名称
    ,open_bank_name -- 开户行行名称
    ,bus_sponsor_id -- 业务发起人编号
    ,final_operr_id -- 最后操作员编号
    ,final_oper_tm -- 最后操作时间
    ,valet_coll_flg -- 代客托收标志
    ,send_out_coll_status_cd -- 发出托收状态代码
    ,coll_appl_dt -- 托收申请日期
    ,org_id -- 机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bill_coll_batch_bdmsf1_op(
            batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,bus_id -- 业务编号
    ,cust_acct_num -- 客户账号
    ,agt_apv_status_cd -- 协议审批状态代码
    ,entry_status_cd -- 记账状态代码
    ,init_coll_dt -- 发起托收日期
    ,cust_open_bank_no -- 客户开户行行号
    ,cust_name -- 客户名称
    ,open_bank_name -- 开户行行名称
    ,bus_sponsor_id -- 业务发起人编号
    ,final_operr_id -- 最后操作员编号
    ,final_oper_tm -- 最后操作时间
    ,valet_coll_flg -- 代客托收标志
    ,send_out_coll_status_cd -- 发出托收状态代码
    ,coll_appl_dt -- 托收申请日期
    ,org_id -- 机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.batch_id -- 批次编号
    ,o.lp_id -- 法人编号
    ,o.cust_id -- 客户编号
    ,o.bus_id -- 业务编号
    ,o.cust_acct_num -- 客户账号
    ,o.agt_apv_status_cd -- 协议审批状态代码
    ,o.entry_status_cd -- 记账状态代码
    ,o.init_coll_dt -- 发起托收日期
    ,o.cust_open_bank_no -- 客户开户行行号
    ,o.cust_name -- 客户名称
    ,o.open_bank_name -- 开户行行名称
    ,o.bus_sponsor_id -- 业务发起人编号
    ,o.final_operr_id -- 最后操作员编号
    ,o.final_oper_tm -- 最后操作时间
    ,o.valet_coll_flg -- 代客托收标志
    ,o.send_out_coll_status_cd -- 发出托收状态代码
    ,o.coll_appl_dt -- 托收申请日期
    ,o.org_id -- 机构编号
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
from ${iml_schema}.agt_bill_coll_batch_bdmsf1_bk o
    left join ${iml_schema}.agt_bill_coll_batch_bdmsf1_op n
        on
            o.batch_id = n.batch_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_bill_coll_batch_bdmsf1_cl d
        on
            o.batch_id = d.batch_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_bill_coll_batch;
--alter table ${iml_schema}.agt_bill_coll_batch truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_bill_coll_batch') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_bill_coll_batch drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_bill_coll_batch modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_bill_coll_batch exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_coll_batch_bdmsf1_cl;
alter table ${iml_schema}.agt_bill_coll_batch exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_bill_coll_batch_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_coll_batch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_bill_coll_batch_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_coll_batch_bdmsf1_op purge;
drop table ${iml_schema}.agt_bill_coll_batch_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_bill_coll_batch_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_coll_batch', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
