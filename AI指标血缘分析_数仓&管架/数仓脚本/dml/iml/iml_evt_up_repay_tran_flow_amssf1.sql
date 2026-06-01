/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_up_repay_tran_flow_amssf1
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
alter table ${iml_schema}.evt_up_repay_tran_flow add partition p_amssf1 values ('amssf1')(
        subpartition p_amssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_amssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_up_repay_tran_flow_amssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_up_repay_tran_flow partition for ('amssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_up_repay_tran_flow_amssf1_tm purge;
drop table ${iml_schema}.evt_up_repay_tran_flow_amssf1_op purge;
drop table ${iml_schema}.evt_up_repay_tran_flow_amssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_up_repay_tran_flow_amssf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,tran_dt -- 交易日期
    ,fund_corp_id -- 基金公司编号
    ,fund_corp_name -- 基金公司名称
    ,belong_brch_org_id -- 所属分行机构编号
    ,belong_brch_org_name -- 所属分行机构名称
    ,tot_amt -- 总额度
    ,td_sucs_amt -- 当天成功金额
    ,td_uno_amt -- 当天未明金额
    ,surp_lmt -- 剩余额度
    ,repayed_amt -- 已还款金额
    ,clarify_status_cd -- 清分状态代码
    ,valid_flg -- 有效标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_up_repay_tran_flow partition for ('amssf1')
where 0=1
;

create table ${iml_schema}.evt_up_repay_tran_flow_amssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_up_repay_tran_flow partition for ('amssf1') where 0=1;

create table ${iml_schema}.evt_up_repay_tran_flow_amssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_up_repay_tran_flow partition for ('amssf1') where 0=1;

-- 3.1 get new data into table
-- amss_union_pay_advance_repayment_result-1
insert into ${iml_schema}.evt_up_repay_tran_flow_amssf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,tran_dt -- 交易日期
    ,fund_corp_id -- 基金公司编号
    ,fund_corp_name -- 基金公司名称
    ,belong_brch_org_id -- 所属分行机构编号
    ,belong_brch_org_name -- 所属分行机构名称
    ,tot_amt -- 总额度
    ,td_sucs_amt -- 当天成功金额
    ,td_uno_amt -- 当天未明金额
    ,surp_lmt -- 剩余额度
    ,repayed_amt -- 已还款金额
    ,clarify_status_cd -- 清分状态代码
    ,valid_flg -- 有效标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401053'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 还款流水号
    ,P1.TRADE_DATE -- 交易日期
    ,P1.FUND_ID -- 基金公司编号
    ,P1.FUND_NAME -- 基金公司名称
    ,P1.ORG_ID -- 所属分行机构编号
    ,P1.ORG_NAME -- 所属分行机构名称
    ,P1.MER_LIMIT -- 总额度
    ,P1.SUCESS_AMT -- 当天成功金额
    ,P1.UN_AMT -- 当天未明金额
    ,P1.BALANCE_LIMT -- 剩余额度
    ,P1.REPAYMENT_AMT -- 已还款金额
    ,nvl(trim(to_char(P1.CLEAN_STATE)),'-') -- 清分状态代码
    ,case when P1.PHYSICS_FLAG = 1 then '1' else '0' end -- 有效标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'amss_union_pay_advance_repayment_result' -- 源表名称
    ,'amssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amss_union_pay_advance_repayment_result p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_up_repay_tran_flow_amssf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                                        ,repay_flow_num
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
        into ${iml_schema}.evt_up_repay_tran_flow_amssf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,tran_dt -- 交易日期
    ,fund_corp_id -- 基金公司编号
    ,fund_corp_name -- 基金公司名称
    ,belong_brch_org_id -- 所属分行机构编号
    ,belong_brch_org_name -- 所属分行机构名称
    ,tot_amt -- 总额度
    ,td_sucs_amt -- 当天成功金额
    ,td_uno_amt -- 当天未明金额
    ,surp_lmt -- 剩余额度
    ,repayed_amt -- 已还款金额
    ,clarify_status_cd -- 清分状态代码
    ,valid_flg -- 有效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_up_repay_tran_flow_amssf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,tran_dt -- 交易日期
    ,fund_corp_id -- 基金公司编号
    ,fund_corp_name -- 基金公司名称
    ,belong_brch_org_id -- 所属分行机构编号
    ,belong_brch_org_name -- 所属分行机构名称
    ,tot_amt -- 总额度
    ,td_sucs_amt -- 当天成功金额
    ,td_uno_amt -- 当天未明金额
    ,surp_lmt -- 剩余额度
    ,repayed_amt -- 已还款金额
    ,clarify_status_cd -- 清分状态代码
    ,valid_flg -- 有效标志
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
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.fund_corp_id, o.fund_corp_id) as fund_corp_id -- 基金公司编号
    ,nvl(n.fund_corp_name, o.fund_corp_name) as fund_corp_name -- 基金公司名称
    ,nvl(n.belong_brch_org_id, o.belong_brch_org_id) as belong_brch_org_id -- 所属分行机构编号
    ,nvl(n.belong_brch_org_name, o.belong_brch_org_name) as belong_brch_org_name -- 所属分行机构名称
    ,nvl(n.tot_amt, o.tot_amt) as tot_amt -- 总额度
    ,nvl(n.td_sucs_amt, o.td_sucs_amt) as td_sucs_amt -- 当天成功金额
    ,nvl(n.td_uno_amt, o.td_uno_amt) as td_uno_amt -- 当天未明金额
    ,nvl(n.surp_lmt, o.surp_lmt) as surp_lmt -- 剩余额度
    ,nvl(n.repayed_amt, o.repayed_amt) as repayed_amt -- 已还款金额
    ,nvl(n.clarify_status_cd, o.clarify_status_cd) as clarify_status_cd -- 清分状态代码
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.repay_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.repay_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.repay_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_up_repay_tran_flow_amssf1_tm n
    full join (select * from ${iml_schema}.evt_up_repay_tran_flow_amssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.repay_flow_num = n.repay_flow_num
where (
        o.evt_id is null
        and o.lp_id is null
        and o.repay_flow_num is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
        and n.repay_flow_num is null
    )
    or (
        o.tran_dt <> n.tran_dt
        or o.fund_corp_id <> n.fund_corp_id
        or o.fund_corp_name <> n.fund_corp_name
        or o.belong_brch_org_id <> n.belong_brch_org_id
        or o.belong_brch_org_name <> n.belong_brch_org_name
        or o.tot_amt <> n.tot_amt
        or o.td_sucs_amt <> n.td_sucs_amt
        or o.td_uno_amt <> n.td_uno_amt
        or o.surp_lmt <> n.surp_lmt
        or o.repayed_amt <> n.repayed_amt
        or o.clarify_status_cd <> n.clarify_status_cd
        or o.valid_flg <> n.valid_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_up_repay_tran_flow_amssf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,tran_dt -- 交易日期
    ,fund_corp_id -- 基金公司编号
    ,fund_corp_name -- 基金公司名称
    ,belong_brch_org_id -- 所属分行机构编号
    ,belong_brch_org_name -- 所属分行机构名称
    ,tot_amt -- 总额度
    ,td_sucs_amt -- 当天成功金额
    ,td_uno_amt -- 当天未明金额
    ,surp_lmt -- 剩余额度
    ,repayed_amt -- 已还款金额
    ,clarify_status_cd -- 清分状态代码
    ,valid_flg -- 有效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_up_repay_tran_flow_amssf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,tran_dt -- 交易日期
    ,fund_corp_id -- 基金公司编号
    ,fund_corp_name -- 基金公司名称
    ,belong_brch_org_id -- 所属分行机构编号
    ,belong_brch_org_name -- 所属分行机构名称
    ,tot_amt -- 总额度
    ,td_sucs_amt -- 当天成功金额
    ,td_uno_amt -- 当天未明金额
    ,surp_lmt -- 剩余额度
    ,repayed_amt -- 已还款金额
    ,clarify_status_cd -- 清分状态代码
    ,valid_flg -- 有效标志
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
    ,o.tran_dt -- 交易日期
    ,o.fund_corp_id -- 基金公司编号
    ,o.fund_corp_name -- 基金公司名称
    ,o.belong_brch_org_id -- 所属分行机构编号
    ,o.belong_brch_org_name -- 所属分行机构名称
    ,o.tot_amt -- 总额度
    ,o.td_sucs_amt -- 当天成功金额
    ,o.td_uno_amt -- 当天未明金额
    ,o.surp_lmt -- 剩余额度
    ,o.repayed_amt -- 已还款金额
    ,o.clarify_status_cd -- 清分状态代码
    ,o.valid_flg -- 有效标志
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
from ${iml_schema}.evt_up_repay_tran_flow_amssf1_bk o
    left join ${iml_schema}.evt_up_repay_tran_flow_amssf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.repay_flow_num = n.repay_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_up_repay_tran_flow_amssf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
            and o.repay_flow_num = d.repay_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_up_repay_tran_flow;
--alter table ${iml_schema}.evt_up_repay_tran_flow truncate partition for ('amssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_up_repay_tran_flow') 
               and substr(subpartition_name,1,8)=upper('p_amssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_up_repay_tran_flow drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_up_repay_tran_flow modify partition p_amssf1 
add subpartition p_amssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_up_repay_tran_flow exchange subpartition p_amssf1_${batch_date} with table ${iml_schema}.evt_up_repay_tran_flow_amssf1_cl;
alter table ${iml_schema}.evt_up_repay_tran_flow exchange subpartition p_amssf1_20991231 with table ${iml_schema}.evt_up_repay_tran_flow_amssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_up_repay_tran_flow to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_up_repay_tran_flow_amssf1_tm purge;
drop table ${iml_schema}.evt_up_repay_tran_flow_amssf1_op purge;
drop table ${iml_schema}.evt_up_repay_tran_flow_amssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_up_repay_tran_flow_amssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_up_repay_tran_flow', partname => 'p_amssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
