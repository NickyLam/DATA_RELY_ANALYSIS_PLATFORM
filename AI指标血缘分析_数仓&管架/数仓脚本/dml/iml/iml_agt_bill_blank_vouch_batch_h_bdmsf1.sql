/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_blank_vouch_batch_h_bdmsf1
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
alter table ${iml_schema}.agt_bill_blank_vouch_batch_h add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_blank_vouch_batch_h partition for ('bdmsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,draw_dt -- 领用日期
    ,min_bill_id -- 最小票据编号
    ,max_bill_id -- 最大票据编号
    ,batch_status_cd -- 批次状态代码
    ,oper_teller_id -- 操作柜员编号
    ,bill_type_cd -- 票据类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_acct_id -- 客户账户编号
    ,edit_num -- 版本号
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_blank_vouch_batch_h partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_blank_vouch_batch_h partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_blank_vouch_batch_h partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_bms_blank_voucher_batch-
insert into ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_tm(
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,draw_dt -- 领用日期
    ,min_bill_id -- 最小票据编号
    ,max_bill_id -- 最大票据编号
    ,batch_status_cd -- 批次状态代码
    ,oper_teller_id -- 操作柜员编号
    ,bill_type_cd -- 票据类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_acct_id -- 客户账户编号
    ,edit_num -- 版本号
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 批次编号
    ,'9999' -- 法人编号
    ,P1.BRANCH_NO -- 机构编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TAKE_DATE) -- 领用日期
    ,P1.START_DRAFT_NUM -- 最小票据编号
    ,P1.END_DRAFT_NUM -- 最大票据编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.BATCH_STATE END -- 批次状态代码
    ,P1.LAST_UPD_OPER_NO -- 操作柜员编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DRAFT_TYPE END -- 票据类型代码
    ,P1.CUSTOMER_NO -- 客户编号
    ,P1.CUSTOMER_NAME -- 客户名称
    ,P1.CUSTOMER_SIGN_ACCOUNT -- 客户账户编号
    ,P1.VERSION_NO -- 版本号
    ,coalesce(SUBSTR(to_char(P1.last_upd_time,'yyyymmddhh24miss'),9,2)||':'||SUBSTR(to_char(P1.last_upd_time,'yyyymmddhh24miss'),11,2)||':'||SUBSTR(to_char(P1.last_upd_time,'yyyymmddhh24miss'),13,2),'') -- 交易时间
    ,${iml_schema}.DATEFORMAT_MIN(to_char(P1.LAST_UPD_TIME,'yyyymmdd')) -- 交易日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_blank_voucher_batch' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_blank_voucher_batch p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.BATCH_STATE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_BMS_BLANK_VOUCHER_BATCH'
        AND R2.SRC_FIELD_EN_NAME= 'BATCH_STATE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BILL_BLANK_VOUCH_BATCH_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BATCH_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DRAFT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_BMS_BLANK_VOUCHER_BATCH'
        AND R1.SRC_FIELD_EN_NAME= 'DRAFT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BILL_BLANK_VOUCH_BATCH_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_tm 
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
        into ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_cl(
            batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,draw_dt -- 领用日期
    ,min_bill_id -- 最小票据编号
    ,max_bill_id -- 最大票据编号
    ,batch_status_cd -- 批次状态代码
    ,oper_teller_id -- 操作柜员编号
    ,bill_type_cd -- 票据类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_acct_id -- 客户账户编号
    ,edit_num -- 版本号
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_op(
            batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,draw_dt -- 领用日期
    ,min_bill_id -- 最小票据编号
    ,max_bill_id -- 最大票据编号
    ,batch_status_cd -- 批次状态代码
    ,oper_teller_id -- 操作柜员编号
    ,bill_type_cd -- 票据类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_acct_id -- 客户账户编号
    ,edit_num -- 版本号
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
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
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.draw_dt, o.draw_dt) as draw_dt -- 领用日期
    ,nvl(n.min_bill_id, o.min_bill_id) as min_bill_id -- 最小票据编号
    ,nvl(n.max_bill_id, o.max_bill_id) as max_bill_id -- 最大票据编号
    ,nvl(n.batch_status_cd, o.batch_status_cd) as batch_status_cd -- 批次状态代码
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 操作柜员编号
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_acct_id, o.cust_acct_id) as cust_acct_id -- 客户账户编号
    ,nvl(n.edit_num, o.edit_num) as edit_num -- 版本号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
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
from ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.org_id <> n.org_id
        or o.draw_dt <> n.draw_dt
        or o.min_bill_id <> n.min_bill_id
        or o.max_bill_id <> n.max_bill_id
        or o.batch_status_cd <> n.batch_status_cd
        or o.oper_teller_id <> n.oper_teller_id
        or o.bill_type_cd <> n.bill_type_cd
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.cust_acct_id <> n.cust_acct_id
        or o.edit_num <> n.edit_num
        or o.tran_tm <> n.tran_tm
        or o.tran_dt <> n.tran_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_cl(
            batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,draw_dt -- 领用日期
    ,min_bill_id -- 最小票据编号
    ,max_bill_id -- 最大票据编号
    ,batch_status_cd -- 批次状态代码
    ,oper_teller_id -- 操作柜员编号
    ,bill_type_cd -- 票据类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_acct_id -- 客户账户编号
    ,edit_num -- 版本号
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_op(
            batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,draw_dt -- 领用日期
    ,min_bill_id -- 最小票据编号
    ,max_bill_id -- 最大票据编号
    ,batch_status_cd -- 批次状态代码
    ,oper_teller_id -- 操作柜员编号
    ,bill_type_cd -- 票据类型代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_acct_id -- 客户账户编号
    ,edit_num -- 版本号
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
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
    ,o.org_id -- 机构编号
    ,o.draw_dt -- 领用日期
    ,o.min_bill_id -- 最小票据编号
    ,o.max_bill_id -- 最大票据编号
    ,o.batch_status_cd -- 批次状态代码
    ,o.oper_teller_id -- 操作柜员编号
    ,o.bill_type_cd -- 票据类型代码
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.cust_acct_id -- 客户账户编号
    ,o.edit_num -- 版本号
    ,o.tran_tm -- 交易时间
    ,o.tran_dt -- 交易日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_bk o
    left join ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_op n
        on
            o.batch_id = n.batch_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_cl d
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
--truncate table ${iml_schema}.agt_bill_blank_vouch_batch_h;
alter table ${iml_schema}.agt_bill_blank_vouch_batch_h truncate partition for ('bdmsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_bill_blank_vouch_batch_h exchange subpartition p_bdmsf1_19000101 with table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_cl;
alter table ${iml_schema}.agt_bill_blank_vouch_batch_h exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_blank_vouch_batch_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_op purge;
drop table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_bill_blank_vouch_batch_h_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_blank_vouch_batch_h', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
