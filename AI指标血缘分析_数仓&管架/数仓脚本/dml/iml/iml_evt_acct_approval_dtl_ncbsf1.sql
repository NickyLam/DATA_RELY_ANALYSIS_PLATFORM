/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_acct_approval_dtl_ncbsf1
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
alter table ${iml_schema}.evt_acct_approval_dtl add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_acct_approval_dtl partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_tm purge;
drop table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_op purge;
drop table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,approval_id -- 核准件编号
    ,lp_id -- 法人编号
    ,tran_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,open_dt -- 开立日期
    ,exp_dt -- 到期日期
    ,approval_type_cd -- 核准件类型代码
    ,approval_cap_use_usage -- 核准件资金使用用途
    ,approval_cap_src -- 核准件资金来源
    ,approval_open_amt -- 核准件开立金额
    ,apprv_acct_imp_item -- 核准账户要项
    ,acct_type_descb -- 账户类型描述
    ,expns_range -- 支出范围
    ,inco_range -- 收入范围
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_acct_approval_dtl partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_acct_approval_dtl partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_acct_approval_dtl partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_appr_letter-1
insert into ${iml_schema}.evt_acct_approval_dtl_ncbsf1_tm(
    evt_id -- 事件编号
    ,approval_id -- 核准件编号
    ,lp_id -- 法人编号
    ,tran_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,open_dt -- 开立日期
    ,exp_dt -- 到期日期
    ,approval_type_cd -- 核准件类型代码
    ,approval_cap_use_usage -- 核准件资金使用用途
    ,approval_cap_src -- 核准件资金来源
    ,approval_open_amt -- 核准件开立金额
    ,apprv_acct_imp_item -- 核准账户要项
    ,acct_type_descb -- 账户类型描述
    ,expns_range -- 支出范围
    ,inco_range -- 收入范围
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101061'||P1.APPR_LETTER_NO -- 事件编号
    ,P1.APPR_LETTER_NO -- 核准件编号
    ,'9999' -- 法人编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.OPEN_DATE -- 开立日期
    ,P1.MATURITY_DATE -- 到期日期
    ,P1.APPR_TYPE -- 核准件类型代码
    ,P1.FUND_PURPOSE -- 核准件资金使用用途
    ,P1.FUND_SOURCE -- 核准件资金来源
    ,P1.CAPITAL_AMT -- 核准件开立金额
    ,P1.APPR_ACCT_IND -- 核准账户要项
    ,P1.ACCT_TYPE_DESC -- 账户类型描述
    ,P1.EXPEND_SCOPE -- 支出范围
    ,P1.INCOME_SCOPE -- 收入范围
    ,P1.NARRATIVE -- 交易摘要描述
    ,${iml_schema}.timeformat_max2(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.USER_ID -- 交易柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_appr_letter' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_appr_letter p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_acct_approval_dtl_ncbsf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,approval_id
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
        into ${iml_schema}.evt_acct_approval_dtl_ncbsf1_cl(
            evt_id -- 事件编号
    ,approval_id -- 核准件编号
    ,lp_id -- 法人编号
    ,tran_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,open_dt -- 开立日期
    ,exp_dt -- 到期日期
    ,approval_type_cd -- 核准件类型代码
    ,approval_cap_use_usage -- 核准件资金使用用途
    ,approval_cap_src -- 核准件资金来源
    ,approval_open_amt -- 核准件开立金额
    ,apprv_acct_imp_item -- 核准账户要项
    ,acct_type_descb -- 账户类型描述
    ,expns_range -- 支出范围
    ,inco_range -- 收入范围
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_acct_approval_dtl_ncbsf1_op(
            evt_id -- 事件编号
    ,approval_id -- 核准件编号
    ,lp_id -- 法人编号
    ,tran_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,open_dt -- 开立日期
    ,exp_dt -- 到期日期
    ,approval_type_cd -- 核准件类型代码
    ,approval_cap_use_usage -- 核准件资金使用用途
    ,approval_cap_src -- 核准件资金来源
    ,approval_open_amt -- 核准件开立金额
    ,apprv_acct_imp_item -- 核准账户要项
    ,acct_type_descb -- 账户类型描述
    ,expns_range -- 支出范围
    ,inco_range -- 收入范围
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.approval_id, o.approval_id) as approval_id -- 核准件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.open_dt, o.open_dt) as open_dt -- 开立日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.approval_type_cd, o.approval_type_cd) as approval_type_cd -- 核准件类型代码
    ,nvl(n.approval_cap_use_usage, o.approval_cap_use_usage) as approval_cap_use_usage -- 核准件资金使用用途
    ,nvl(n.approval_cap_src, o.approval_cap_src) as approval_cap_src -- 核准件资金来源
    ,nvl(n.approval_open_amt, o.approval_open_amt) as approval_open_amt -- 核准件开立金额
    ,nvl(n.apprv_acct_imp_item, o.apprv_acct_imp_item) as apprv_acct_imp_item -- 核准账户要项
    ,nvl(n.acct_type_descb, o.acct_type_descb) as acct_type_descb -- 账户类型描述
    ,nvl(n.expns_range, o.expns_range) as expns_range -- 支出范围
    ,nvl(n.inco_range, o.inco_range) as inco_range -- 收入范围
    ,nvl(n.tran_memo_descb, o.tran_memo_descb) as tran_memo_descb -- 交易摘要描述
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,case when
            n.evt_id is null
            and n.approval_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.approval_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.approval_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_acct_approval_dtl_ncbsf1_tm n
    full join (select * from ${iml_schema}.evt_acct_approval_dtl_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.approval_id = n.approval_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.approval_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.approval_id is null
        and n.lp_id is null
    )
    or (
        o.tran_org_id <> n.tran_org_id
        or o.cust_id <> n.cust_id
        or o.open_dt <> n.open_dt
        or o.exp_dt <> n.exp_dt
        or o.approval_type_cd <> n.approval_type_cd
        or o.approval_cap_use_usage <> n.approval_cap_use_usage
        or o.approval_cap_src <> n.approval_cap_src
        or o.approval_open_amt <> n.approval_open_amt
        or o.apprv_acct_imp_item <> n.apprv_acct_imp_item
        or o.acct_type_descb <> n.acct_type_descb
        or o.expns_range <> n.expns_range
        or o.inco_range <> n.inco_range
        or o.tran_memo_descb <> n.tran_memo_descb
        or o.tran_tm <> n.tran_tm
        or o.tran_teller_id <> n.tran_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_acct_approval_dtl_ncbsf1_cl(
            evt_id -- 事件编号
    ,approval_id -- 核准件编号
    ,lp_id -- 法人编号
    ,tran_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,open_dt -- 开立日期
    ,exp_dt -- 到期日期
    ,approval_type_cd -- 核准件类型代码
    ,approval_cap_use_usage -- 核准件资金使用用途
    ,approval_cap_src -- 核准件资金来源
    ,approval_open_amt -- 核准件开立金额
    ,apprv_acct_imp_item -- 核准账户要项
    ,acct_type_descb -- 账户类型描述
    ,expns_range -- 支出范围
    ,inco_range -- 收入范围
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_acct_approval_dtl_ncbsf1_op(
            evt_id -- 事件编号
    ,approval_id -- 核准件编号
    ,lp_id -- 法人编号
    ,tran_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,open_dt -- 开立日期
    ,exp_dt -- 到期日期
    ,approval_type_cd -- 核准件类型代码
    ,approval_cap_use_usage -- 核准件资金使用用途
    ,approval_cap_src -- 核准件资金来源
    ,approval_open_amt -- 核准件开立金额
    ,apprv_acct_imp_item -- 核准账户要项
    ,acct_type_descb -- 账户类型描述
    ,expns_range -- 支出范围
    ,inco_range -- 收入范围
    ,tran_memo_descb -- 交易摘要描述
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.approval_id -- 核准件编号
    ,o.lp_id -- 法人编号
    ,o.tran_org_id -- 交易机构编号
    ,o.cust_id -- 客户编号
    ,o.open_dt -- 开立日期
    ,o.exp_dt -- 到期日期
    ,o.approval_type_cd -- 核准件类型代码
    ,o.approval_cap_use_usage -- 核准件资金使用用途
    ,o.approval_cap_src -- 核准件资金来源
    ,o.approval_open_amt -- 核准件开立金额
    ,o.apprv_acct_imp_item -- 核准账户要项
    ,o.acct_type_descb -- 账户类型描述
    ,o.expns_range -- 支出范围
    ,o.inco_range -- 收入范围
    ,o.tran_memo_descb -- 交易摘要描述
    ,o.tran_tm -- 交易时间
    ,o.tran_teller_id -- 交易柜员编号
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
from ${iml_schema}.evt_acct_approval_dtl_ncbsf1_bk o
    left join ${iml_schema}.evt_acct_approval_dtl_ncbsf1_op n
        on
            o.evt_id = n.evt_id
            and o.approval_id = n.approval_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_acct_approval_dtl_ncbsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.approval_id = d.approval_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_acct_approval_dtl;
--alter table ${iml_schema}.evt_acct_approval_dtl truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_acct_approval_dtl') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_acct_approval_dtl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_acct_approval_dtl modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_acct_approval_dtl exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_cl;
alter table ${iml_schema}.evt_acct_approval_dtl exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_acct_approval_dtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_tm purge;
drop table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_op purge;
drop table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_acct_approval_dtl_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_acct_approval_dtl', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
