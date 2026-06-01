/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_zjdk_repay_flow_icmsf1
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
alter table ${iml_schema}.evt_zjdk_repay_flow add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_zjdk_repay_flow partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_tm purge;
drop table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_op purge;
drop table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,intnal_dubil_id -- 借据编号
    ,zjdk_prod_id -- 字节产品编号
    ,acct_dt -- 账务日期
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,actl_recv_amt -- 实收金额
    ,pric_amt -- 本金发生额
    ,int_amt -- 利息发生额
    ,pnlt_amt -- 罚息发生额
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,non_acru_flg -- 非应计标志
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,plat_indent_id -- 平台订单编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_zjdk_repay_flow partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_zjdk_repay_flow partition for ('icmsf1') where 0=1;

create table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_zjdk_repay_flow partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_zjbk_bat_repayment-1
insert into ${iml_schema}.evt_zjdk_repay_flow_icmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,intnal_dubil_id -- 借据编号
    ,zjdk_prod_id -- 字节产品编号
    ,acct_dt -- 账务日期
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,actl_recv_amt -- 实收金额
    ,pric_amt -- 本金发生额
    ,int_amt -- 利息发生额
    ,pnlt_amt -- 罚息发生额
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,non_acru_flg -- 非应计标志
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,plat_indent_id -- 平台订单编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401046'||P1.SERIALNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 还款流水号
    ,P1.LOANID -- 借据编号
    ,P1.PRODUCTNO -- 字节产品编号
    ,${iml_schema}.dateformat_max2(P1.CURDATE) -- 账务日期
    ,P1.SEQNO -- 交易流水号
    ,${iml_schema}.dateformat_max2(P1.TRANTIME) -- 交易日期
    ,to_number(nvl(trim(P1.TOTALAMT),'0')) -- 交易金额
    ,to_number(nvl(trim(P1.INCOMEAMT),'0')) -- 实收金额
    ,to_number(nvl(trim(P1.PRINAMT),'0')) -- 本金发生额
    ,to_number(nvl(trim(P1.INTAMT),'0')) -- 利息发生额
    ,to_number(nvl(trim(P1.PNLTINTAMT),'0')) -- 罚息发生额
    ,to_number(nvl(trim(P1.PREPMTFEEREPAY),'0')) -- 已还提前还款手续费
    ,decode(P1.INTERESTTRANSFERSTATUS,'1','0','2','1',' ','-'，P1.INTERESTTRANSFERSTATUS） -- 非应计标志
    ,P1.REPAYACCOUNTNO -- 还款账户编号
    ,nvl(trim(P1.REPAYACCOUNTTYPE),'-') -- 还款账户类型代码
    ,P1.REPAYACCOUNTNAME -- 还款账户开户机构名称
    ,P1.OUTLOANCHANNELNO -- 平台订单编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_zjbk_bat_repayment' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_zjbk_bat_repayment p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_zjdk_repay_flow_icmsf1_tm 
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
        into ${iml_schema}.evt_zjdk_repay_flow_icmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,intnal_dubil_id -- 借据编号
    ,zjdk_prod_id -- 字节产品编号
    ,acct_dt -- 账务日期
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,actl_recv_amt -- 实收金额
    ,pric_amt -- 本金发生额
    ,int_amt -- 利息发生额
    ,pnlt_amt -- 罚息发生额
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,non_acru_flg -- 非应计标志
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,plat_indent_id -- 平台订单编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_zjdk_repay_flow_icmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,intnal_dubil_id -- 借据编号
    ,zjdk_prod_id -- 字节产品编号
    ,acct_dt -- 账务日期
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,actl_recv_amt -- 实收金额
    ,pric_amt -- 本金发生额
    ,int_amt -- 利息发生额
    ,pnlt_amt -- 罚息发生额
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,non_acru_flg -- 非应计标志
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,plat_indent_id -- 平台订单编号
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
    ,nvl(n.repay_flow_num, o.repay_flow_num) as repay_flow_num -- 还款流水号
    ,nvl(n.intnal_dubil_id, o.intnal_dubil_id) as intnal_dubil_id -- 借据编号
    ,nvl(n.zjdk_prod_id, o.zjdk_prod_id) as zjdk_prod_id -- 字节产品编号
    ,nvl(n.acct_dt, o.acct_dt) as acct_dt -- 账务日期
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.actl_recv_amt, o.actl_recv_amt) as actl_recv_amt -- 实收金额
    ,nvl(n.pric_amt, o.pric_amt) as pric_amt -- 本金发生额
    ,nvl(n.int_amt, o.int_amt) as int_amt -- 利息发生额
    ,nvl(n.pnlt_amt, o.pnlt_amt) as pnlt_amt -- 罚息发生额
    ,nvl(n.paid_adv_repay_comm_fee, o.paid_adv_repay_comm_fee) as paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,nvl(n.non_acru_flg, o.non_acru_flg) as non_acru_flg -- 非应计标志
    ,nvl(n.repay_num_id, o.repay_num_id) as repay_num_id -- 还款账户编号
    ,nvl(n.repay_num_type_cd, o.repay_num_type_cd) as repay_num_type_cd -- 还款账户类型代码
    ,nvl(n.repay_num_open_acct_org_name, o.repay_num_open_acct_org_name) as repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,nvl(n.plat_indent_id, o.plat_indent_id) as plat_indent_id -- 平台订单编号
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
from ${iml_schema}.evt_zjdk_repay_flow_icmsf1_tm n
    full join (select * from ${iml_schema}.evt_zjdk_repay_flow_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.repay_flow_num <> n.repay_flow_num
        or o.intnal_dubil_id <> n.intnal_dubil_id
        or o.zjdk_prod_id <> n.zjdk_prod_id
        or o.acct_dt <> n.acct_dt
        or o.tran_flow_num <> n.tran_flow_num
        or o.tran_dt <> n.tran_dt
        or o.tran_amt <> n.tran_amt
        or o.actl_recv_amt <> n.actl_recv_amt
        or o.pric_amt <> n.pric_amt
        or o.int_amt <> n.int_amt
        or o.pnlt_amt <> n.pnlt_amt
        or o.paid_adv_repay_comm_fee <> n.paid_adv_repay_comm_fee
        or o.non_acru_flg <> n.non_acru_flg
        or o.repay_num_id <> n.repay_num_id
        or o.repay_num_type_cd <> n.repay_num_type_cd
        or o.repay_num_open_acct_org_name <> n.repay_num_open_acct_org_name
        or o.plat_indent_id <> n.plat_indent_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_zjdk_repay_flow_icmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,intnal_dubil_id -- 借据编号
    ,zjdk_prod_id -- 字节产品编号
    ,acct_dt -- 账务日期
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,actl_recv_amt -- 实收金额
    ,pric_amt -- 本金发生额
    ,int_amt -- 利息发生额
    ,pnlt_amt -- 罚息发生额
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,non_acru_flg -- 非应计标志
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,plat_indent_id -- 平台订单编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_zjdk_repay_flow_icmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,intnal_dubil_id -- 借据编号
    ,zjdk_prod_id -- 字节产品编号
    ,acct_dt -- 账务日期
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,actl_recv_amt -- 实收金额
    ,pric_amt -- 本金发生额
    ,int_amt -- 利息发生额
    ,pnlt_amt -- 罚息发生额
    ,paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,non_acru_flg -- 非应计标志
    ,repay_num_id -- 还款账户编号
    ,repay_num_type_cd -- 还款账户类型代码
    ,repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,plat_indent_id -- 平台订单编号
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
    ,o.repay_flow_num -- 还款流水号
    ,o.intnal_dubil_id -- 借据编号
    ,o.zjdk_prod_id -- 字节产品编号
    ,o.acct_dt -- 账务日期
    ,o.tran_flow_num -- 交易流水号
    ,o.tran_dt -- 交易日期
    ,o.tran_amt -- 交易金额
    ,o.actl_recv_amt -- 实收金额
    ,o.pric_amt -- 本金发生额
    ,o.int_amt -- 利息发生额
    ,o.pnlt_amt -- 罚息发生额
    ,o.paid_adv_repay_comm_fee -- 已还提前还款手续费
    ,o.non_acru_flg -- 非应计标志
    ,o.repay_num_id -- 还款账户编号
    ,o.repay_num_type_cd -- 还款账户类型代码
    ,o.repay_num_open_acct_org_name -- 还款账户开户机构名称
    ,o.plat_indent_id -- 平台订单编号
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
from ${iml_schema}.evt_zjdk_repay_flow_icmsf1_bk o
    left join ${iml_schema}.evt_zjdk_repay_flow_icmsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_zjdk_repay_flow_icmsf1_cl d
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
--truncate table ${iml_schema}.evt_zjdk_repay_flow;
--alter table ${iml_schema}.evt_zjdk_repay_flow truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_zjdk_repay_flow') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_zjdk_repay_flow drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_zjdk_repay_flow modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_zjdk_repay_flow exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_cl;
alter table ${iml_schema}.evt_zjdk_repay_flow exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_zjdk_repay_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_tm purge;
drop table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_op purge;
drop table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_zjdk_repay_flow_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_zjdk_repay_flow', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
