/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_sub_acct_cap_sign_dtl_mpcsf1
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
alter table ${iml_schema}.evt_sub_acct_cap_sign_dtl add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mpcsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_sub_acct_cap_sign_dtl partition for ('mpcsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_tm purge;
drop table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_op purge;
drop table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,plat_dt -- 平台日期
    ,tran_code -- 交易码
    ,main_acct_id -- 主账户编号
    ,main_acct_name -- 主账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_org_name -- 开户机构名称
    ,sign_status_cd -- 签约状态代码
    ,sign_org_id -- 签约机构编号
    ,oper_teller_id -- 操作柜员编号
    ,oper_teller_name -- 操作柜员姓名
    ,remark -- 备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_sub_acct_cap_sign_dtl partition for ('mpcsf1')
where 0=1
;

create table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_sub_acct_cap_sign_dtl partition for ('mpcsf1') where 0=1;

create table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_sub_acct_cap_sign_dtl partition for ('mpcsf1') where 0=1;

-- 3.1 get new data into table
-- mpcs_a71tzctdsigninfo-1
insert into ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,plat_dt -- 平台日期
    ,tran_code -- 交易码
    ,main_acct_id -- 主账户编号
    ,main_acct_name -- 主账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_org_name -- 开户机构名称
    ,sign_status_cd -- 签约状态代码
    ,sign_org_id -- 签约机构编号
    ,oper_teller_id -- 操作柜员编号
    ,oper_teller_name -- 操作柜员姓名
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401038'||P1.TRXSEQ||P1.TRANSDT||P1.TRANSTM  --分账资金签约明细 -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRXSEQ -- 交易流水号
    ,${iml_schema}.dateformat_max2(P1.TRANSDT||P1.TRANSTM) -- 平台日期
    ,P1.TRANSCODE -- 交易码
    ,P1.MAINACCT -- 主账户编号
    ,P1.MAINACCTNAME -- 主账户名称
    ,P1.CUSTNO -- 客户编号
    ,P1.CUSTNAME -- 客户名称
    ,P1.MAGEBRN -- 开户机构编号
    ,P1.INSTNAME -- 开户机构名称
    ,decode(P1.STATUS,'0','Y','1','C',' ','-',P1.STATUS) -- 签约状态代码
    ,P1.SIGNINSTNO -- 签约机构编号
    ,P1.OPERRID -- 操作柜员编号
    ,P1.OPERRNAME -- 操作柜员姓名
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a71tzctdsigninfo' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a71tzctdsigninfo p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_tm 
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
        into ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,plat_dt -- 平台日期
    ,tran_code -- 交易码
    ,main_acct_id -- 主账户编号
    ,main_acct_name -- 主账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_org_name -- 开户机构名称
    ,sign_status_cd -- 签约状态代码
    ,sign_org_id -- 签约机构编号
    ,oper_teller_id -- 操作柜员编号
    ,oper_teller_name -- 操作柜员姓名
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,plat_dt -- 平台日期
    ,tran_code -- 交易码
    ,main_acct_id -- 主账户编号
    ,main_acct_name -- 主账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_org_name -- 开户机构名称
    ,sign_status_cd -- 签约状态代码
    ,sign_org_id -- 签约机构编号
    ,oper_teller_id -- 操作柜员编号
    ,oper_teller_name -- 操作柜员姓名
    ,remark -- 备注
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
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.plat_dt, o.plat_dt) as plat_dt -- 平台日期
    ,nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.main_acct_id, o.main_acct_id) as main_acct_id -- 主账户编号
    ,nvl(n.main_acct_name, o.main_acct_name) as main_acct_name -- 主账户名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.open_acct_org_name, o.open_acct_org_name) as open_acct_org_name -- 开户机构名称
    ,nvl(n.sign_status_cd, o.sign_status_cd) as sign_status_cd -- 签约状态代码
    ,nvl(n.sign_org_id, o.sign_org_id) as sign_org_id -- 签约机构编号
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 操作柜员编号
    ,nvl(n.oper_teller_name, o.oper_teller_name) as oper_teller_name -- 操作柜员姓名
    ,nvl(n.remark, o.remark) as remark -- 备注
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
from ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_tm n
    full join (select * from ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.tran_flow_num <> n.tran_flow_num
        or o.plat_dt <> n.plat_dt
        or o.tran_code <> n.tran_code
        or o.main_acct_id <> n.main_acct_id
        or o.main_acct_name <> n.main_acct_name
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.open_acct_org_name <> n.open_acct_org_name
        or o.sign_status_cd <> n.sign_status_cd
        or o.sign_org_id <> n.sign_org_id
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_teller_name <> n.oper_teller_name
        or o.remark <> n.remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,plat_dt -- 平台日期
    ,tran_code -- 交易码
    ,main_acct_id -- 主账户编号
    ,main_acct_name -- 主账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_org_name -- 开户机构名称
    ,sign_status_cd -- 签约状态代码
    ,sign_org_id -- 签约机构编号
    ,oper_teller_id -- 操作柜员编号
    ,oper_teller_name -- 操作柜员姓名
    ,remark -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,plat_dt -- 平台日期
    ,tran_code -- 交易码
    ,main_acct_id -- 主账户编号
    ,main_acct_name -- 主账户名称
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_org_name -- 开户机构名称
    ,sign_status_cd -- 签约状态代码
    ,sign_org_id -- 签约机构编号
    ,oper_teller_id -- 操作柜员编号
    ,oper_teller_name -- 操作柜员姓名
    ,remark -- 备注
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
    ,o.tran_flow_num -- 交易流水号
    ,o.plat_dt -- 平台日期
    ,o.tran_code -- 交易码
    ,o.main_acct_id -- 主账户编号
    ,o.main_acct_name -- 主账户名称
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.open_acct_org_id -- 开户机构编号
    ,o.open_acct_org_name -- 开户机构名称
    ,o.sign_status_cd -- 签约状态代码
    ,o.sign_org_id -- 签约机构编号
    ,o.oper_teller_id -- 操作柜员编号
    ,o.oper_teller_name -- 操作柜员姓名
    ,o.remark -- 备注
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
from ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_bk o
    left join ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_cl d
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
--truncate table ${iml_schema}.evt_sub_acct_cap_sign_dtl;
--alter table ${iml_schema}.evt_sub_acct_cap_sign_dtl truncate partition for ('mpcsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_sub_acct_cap_sign_dtl') 
               and substr(subpartition_name,1,8)=upper('p_mpcsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_sub_acct_cap_sign_dtl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_sub_acct_cap_sign_dtl modify partition p_mpcsf1 
add subpartition p_mpcsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_sub_acct_cap_sign_dtl exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_cl;
alter table ${iml_schema}.evt_sub_acct_cap_sign_dtl exchange subpartition p_mpcsf1_20991231 with table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_sub_acct_cap_sign_dtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_tm purge;
drop table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_op purge;
drop table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_sub_acct_cap_sign_dtl_mpcsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_sub_acct_cap_sign_dtl', partname => 'p_mpcsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
