/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_tips_trea_cap_tran_info_h_mpcsf1
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
alter table ${iml_schema}.ref_tips_trea_cap_tran_info_h add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tips_trea_cap_tran_info_h partition for ('mpcsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_tm purge;
drop table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_op purge;
drop table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    cap_type_descb -- 资金类型描述
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_bank_name -- 付款行行名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recv_bank_bank_no -- 收款行行号
    ,recv_bank_bank_name -- 收款行行名称
    ,postsc -- 附言
    ,modif_org_id -- 变更机构编号
    ,modif_dt -- 变更日期
    ,modif_tm -- 变更时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_tips_trea_cap_tran_info_h partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tips_trea_cap_tran_info_h partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tips_trea_cap_tran_info_h partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_aodtips_gkzjdhwh-
insert into ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_tm(
    cap_type_descb -- 资金类型描述
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_bank_name -- 付款行行名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recv_bank_bank_no -- 收款行行号
    ,recv_bank_bank_name -- 收款行行名称
    ,postsc -- 附言
    ,modif_org_id -- 变更机构编号
    ,modif_dt -- 变更日期
    ,modif_tm -- 变更时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.FUNDTYPE -- 资金类型描述
    ,P1.PAYACC -- 付款人账户编号
    ,P1.PAYNAME -- 付款人名称
    ,P1.PAYBANKACC -- 付款行行号
    ,P1.PAYBANKNAME -- 付款行行名称
    ,P1.PROCEEDSACC -- 收款人账户编号
    ,P1.PROCEEDSNAME -- 收款人名称
    ,P1.PROCEEDSBANKACC -- 收款行行号
    ,P1.PROCEEDSBANKNAME -- 收款行行名称
    ,P1.POSTSCRIPTCONTENT -- 附言
    ,P1.BRCHNO -- 变更机构编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.ADDDATA) -- 变更日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.ADDDATA||P1.ADDTIME) -- 变更时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_aodtips_gkzjdhwh' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_aodtips_gkzjdhwh p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_tm 
  	                                group by 
  	                                        cap_type_descb
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
        into ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_cl(
            cap_type_descb -- 资金类型描述
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_bank_name -- 付款行行名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recv_bank_bank_no -- 收款行行号
    ,recv_bank_bank_name -- 收款行行名称
    ,postsc -- 附言
    ,modif_org_id -- 变更机构编号
    ,modif_dt -- 变更日期
    ,modif_tm -- 变更时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_op(
            cap_type_descb -- 资金类型描述
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_bank_name -- 付款行行名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recv_bank_bank_no -- 收款行行号
    ,recv_bank_bank_name -- 收款行行名称
    ,postsc -- 附言
    ,modif_org_id -- 变更机构编号
    ,modif_dt -- 变更日期
    ,modif_tm -- 变更时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cap_type_descb, o.cap_type_descb) as cap_type_descb -- 资金类型描述
    ,nvl(n.payer_acct_id, o.payer_acct_id) as payer_acct_id -- 付款人账户编号
    ,nvl(n.payer_name, o.payer_name) as payer_name -- 付款人名称
    ,nvl(n.pay_bank_bank_no, o.pay_bank_bank_no) as pay_bank_bank_no -- 付款行行号
    ,nvl(n.pay_bank_bank_name, o.pay_bank_bank_name) as pay_bank_bank_name -- 付款行行名称
    ,nvl(n.recver_acct_id, o.recver_acct_id) as recver_acct_id -- 收款人账户编号
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 收款人名称
    ,nvl(n.recv_bank_bank_no, o.recv_bank_bank_no) as recv_bank_bank_no -- 收款行行号
    ,nvl(n.recv_bank_bank_name, o.recv_bank_bank_name) as recv_bank_bank_name -- 收款行行名称
    ,nvl(n.postsc, o.postsc) as postsc -- 附言
    ,nvl(n.modif_org_id, o.modif_org_id) as modif_org_id -- 变更机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.modif_tm, o.modif_tm) as modif_tm -- 变更时间
    ,case when
            n.cap_type_descb is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cap_type_descb is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cap_type_descb is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_tm n
    full join (select * from ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.cap_type_descb = n.cap_type_descb
where (
        o.cap_type_descb is null
    )
    or (
        n.cap_type_descb is null
    )
    or (
        o.payer_acct_id <> n.payer_acct_id
        or o.payer_name <> n.payer_name
        or o.pay_bank_bank_no <> n.pay_bank_bank_no
        or o.pay_bank_bank_name <> n.pay_bank_bank_name
        or o.recver_acct_id <> n.recver_acct_id
        or o.recver_name <> n.recver_name
        or o.recv_bank_bank_no <> n.recv_bank_bank_no
        or o.recv_bank_bank_name <> n.recv_bank_bank_name
        or o.postsc <> n.postsc
        or o.modif_org_id <> n.modif_org_id
        or o.modif_dt <> n.modif_dt
        or o.modif_tm <> n.modif_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_cl(
            cap_type_descb -- 资金类型描述
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_bank_name -- 付款行行名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recv_bank_bank_no -- 收款行行号
    ,recv_bank_bank_name -- 收款行行名称
    ,postsc -- 附言
    ,modif_org_id -- 变更机构编号
    ,modif_dt -- 变更日期
    ,modif_tm -- 变更时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_op(
            cap_type_descb -- 资金类型描述
    ,payer_acct_id -- 付款人账户编号
    ,payer_name -- 付款人名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_bank_bank_name -- 付款行行名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_name -- 收款人名称
    ,recv_bank_bank_no -- 收款行行号
    ,recv_bank_bank_name -- 收款行行名称
    ,postsc -- 附言
    ,modif_org_id -- 变更机构编号
    ,modif_dt -- 变更日期
    ,modif_tm -- 变更时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cap_type_descb -- 资金类型描述
    ,o.payer_acct_id -- 付款人账户编号
    ,o.payer_name -- 付款人名称
    ,o.pay_bank_bank_no -- 付款行行号
    ,o.pay_bank_bank_name -- 付款行行名称
    ,o.recver_acct_id -- 收款人账户编号
    ,o.recver_name -- 收款人名称
    ,o.recv_bank_bank_no -- 收款行行号
    ,o.recv_bank_bank_name -- 收款行行名称
    ,o.postsc -- 附言
    ,o.modif_org_id -- 变更机构编号
    ,o.modif_dt -- 变更日期
    ,o.modif_tm -- 变更时间
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
from ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_bk o
    left join ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_op n
        on
            o.cap_type_descb = n.cap_type_descb
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_cl d
        on
            o.cap_type_descb = d.cap_type_descb
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.ref_tips_trea_cap_tran_info_h;
--alter table ${iml_schema}.ref_tips_trea_cap_tran_info_h truncate partition for ('mpcsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('ref_tips_trea_cap_tran_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mpcsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.ref_tips_trea_cap_tran_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.ref_tips_trea_cap_tran_info_h modify partition p_mpcsf1 
add subpartition p_mpcsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.ref_tips_trea_cap_tran_info_h exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_cl;
alter table ${iml_schema}.ref_tips_trea_cap_tran_info_h exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_tips_trea_cap_tran_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_tm purge;
drop table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_op purge;
drop table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.ref_tips_trea_cap_tran_info_h_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_tips_trea_cap_tran_info_h', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
