/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_valet_bill_coll_dtl_bdmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_valet_bill_coll_dtl add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_valet_bill_coll_dtl modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_valet_bill_coll_dtl partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,coll_dtl_id -- 托收明细编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,entry_status_cd -- 记账状态代码
    ,coll_dt -- 托收日期
    ,acpt_bank_addr -- 承兑行地址
    ,core_entry_acct_num -- 核心记账账号
    ,entry_dt -- 记账日期
    ,in_acct_dt -- 来账日期
    ,in_acct_info_src_name -- 来账信息来源名称
    ,in_acct_que_flow_num -- 来账查询流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_valet_bill_coll_dtl
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_valet_bill_coll_dtl partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_cust_collection_details-
insert into ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_tm(
    agt_id -- 协议编号
    ,coll_dtl_id -- 托收明细编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,entry_status_cd -- 记账状态代码
    ,coll_dt -- 托收日期
    ,acpt_bank_addr -- 承兑行地址
    ,core_entry_acct_num -- 核心记账账号
    ,entry_dt -- 记账日期
    ,in_acct_dt -- 来账日期
    ,in_acct_info_src_name -- 来账信息来源名称
    ,in_acct_que_flow_num -- 来账查询流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223105'||TO_CHAR(P1.ID) -- 协议编号
    ,TO_CHAR(P1.ID) -- 托收明细编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.BATCH_ID) -- 批次编号
    ,TO_CHAR(P1.DRAFT_ID) -- 票据编号
    ,P1.ACCOUNT_STATUS -- 记账状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.COLLE_DATE) -- 托收日期
    ,P1.ACCEPTOR_ADDRESS -- 承兑行地址
    ,P1.CORE_ACCOUNT -- 核心记账账号
    ,${iml_schema}.DATEFORMAT_MAX(P1.ACCOUNT_DATE) -- 记账日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRANDATE) -- 来账日期
    ,P1.PAYMSGSRC -- 来账信息来源名称
    ,P1.TRANNUMBER -- 来账查询流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cust_collection_details' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cust_collection_details p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_tm 
  	                                group by 
  	                                        agt_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_ex(
    agt_id -- 协议编号
    ,coll_dtl_id -- 托收明细编号
    ,lp_id -- 法人编号
    ,batch_id -- 批次编号
    ,bill_id -- 票据编号
    ,entry_status_cd -- 记账状态代码
    ,coll_dt -- 托收日期
    ,acpt_bank_addr -- 承兑行地址
    ,core_entry_acct_num -- 核心记账账号
    ,entry_dt -- 记账日期
    ,in_acct_dt -- 来账日期
    ,in_acct_info_src_name -- 来账信息来源名称
    ,in_acct_que_flow_num -- 来账查询流水号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.coll_dtl_id, o.coll_dtl_id) as coll_dtl_id -- 托收明细编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.entry_status_cd, o.entry_status_cd) as entry_status_cd -- 记账状态代码
    ,nvl(n.coll_dt, o.coll_dt) as coll_dt -- 托收日期
    ,nvl(n.acpt_bank_addr, o.acpt_bank_addr) as acpt_bank_addr -- 承兑行地址
    ,nvl(n.core_entry_acct_num, o.core_entry_acct_num) as core_entry_acct_num -- 核心记账账号
    ,nvl(n.entry_dt, o.entry_dt) as entry_dt -- 记账日期
    ,nvl(n.in_acct_dt, o.in_acct_dt) as in_acct_dt -- 来账日期
    ,nvl(n.in_acct_info_src_name, o.in_acct_info_src_name) as in_acct_info_src_name -- 来账信息来源名称
    ,nvl(n.in_acct_que_flow_num, o.in_acct_que_flow_num) as in_acct_que_flow_num -- 来账查询流水号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.coll_dtl_id <> n.coll_dtl_id
                or o.batch_id <> n.batch_id
                or o.bill_id <> n.bill_id
                or o.entry_status_cd <> n.entry_status_cd
                or o.coll_dt <> n.coll_dt
                or o.acpt_bank_addr <> n.acpt_bank_addr
                or o.core_entry_acct_num <> n.core_entry_acct_num
                or o.entry_dt <> n.entry_dt
                or o.in_acct_dt <> n.in_acct_dt
                or o.in_acct_info_src_name <> n.in_acct_info_src_name
                or o.in_acct_que_flow_num <> n.in_acct_que_flow_num
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_tm n
    full join ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_valet_bill_coll_dtl truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_valet_bill_coll_dtl exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_valet_bill_coll_dtl drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_valet_bill_coll_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_tm purge;
drop table ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_ex purge;
drop table ${iml_schema}.agt_valet_bill_coll_dtl_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_valet_bill_coll_dtl', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);