/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_up_clarify_dtl_amssf1
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
alter table ${iml_schema}.evt_up_clarify_dtl add partition p_amssf1 values ('amssf1')(
        subpartition p_amssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_amssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_up_clarify_dtl_amssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_up_clarify_dtl partition for ('amssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_up_clarify_dtl_amssf1_tm purge;
drop table ${iml_schema}.evt_up_clarify_dtl_amssf1_op purge;
drop table ${iml_schema}.evt_up_clarify_dtl_amssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_up_clarify_dtl_amssf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_no -- 批次号
    ,fund_corp_id -- 基金公司编号
    ,belong_org_id -- 所属机构编号
    ,cnter_org_id -- 柜台机构编号
    ,remit_acct_dt -- 划账日期
    ,remit_acct_status_cd -- 划账状态代码
    ,should_remit_acct_amt -- 应划账金额
    ,actl_remit_acct_amt -- 实际划账金额
    ,fail_rs -- 失败原因
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_open_bank_num -- 付款账户开户行号
    ,pay_acct_open_bank_name -- 付款账户开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,valid_flg -- 有效标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_up_clarify_dtl partition for ('amssf1')
where 0=1
;

create table ${iml_schema}.evt_up_clarify_dtl_amssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_up_clarify_dtl partition for ('amssf1') where 0=1;

create table ${iml_schema}.evt_up_clarify_dtl_amssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_up_clarify_dtl partition for ('amssf1') where 0=1;

-- 3.1 get new data into table
-- amss_union_pay_clean_detail-1
insert into ${iml_schema}.evt_up_clarify_dtl_amssf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_no -- 批次号
    ,fund_corp_id -- 基金公司编号
    ,belong_org_id -- 所属机构编号
    ,cnter_org_id -- 柜台机构编号
    ,remit_acct_dt -- 划账日期
    ,remit_acct_status_cd -- 划账状态代码
    ,should_remit_acct_amt -- 应划账金额
    ,actl_remit_acct_amt -- 实际划账金额
    ,fail_rs -- 失败原因
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_open_bank_num -- 付款账户开户行号
    ,pay_acct_open_bank_name -- 付款账户开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,valid_flg -- 有效标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401053'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 序列号
    ,P1.BATCH_NO -- 批次号
    ,P1.FUND_ID -- 基金公司编号
    ,P1.CHANNEL_ID -- 所属机构编号
    ,P1.ORG_ID -- 柜台机构编号
    ,P1.CLEAN_DATE -- 划账日期
    ,nvl(trim(P1.CLEAN_RESULT),'-') -- 划账状态代码
    ,P1.CLEAN_AMT -- 应划账金额
    ,P1.ACTUAL_AMT -- 实际划账金额
    ,P1.RESP_MSG -- 失败原因
    ,P1.PAYER_ACCT -- 付款账户编号
    ,P1.PAYER_ACCT_NAME -- 付款账户名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PAYER_ACCT_TYPE END -- 付款账户类型代码
    ,P1.PAYER_BANK_NO -- 付款账户开户行号
    ,P1.PAYER_BANK_NAME -- 付款账户开户行名称
    ,P1.PAYEE_ACCT -- 收款账户编号
    ,P1.PAYEE_ACCT_NAME -- 收款账户名称
    ,nvl(trim(P1.PAYEE_ACCT_TYPE),'-') -- 收款账户类型代码
    ,case when P1.PHYSICS_FLAG = 1 then '1' else '0' end -- 有效标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'amss_union_pay_clean_detail' -- 源表名称
    ,'amssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amss_union_pay_clean_detail p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.PAYER_ACCT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'AMSS'
        AND R1.SRC_TAB_EN_NAME= 'AMSS_UNION_PAY_CLEAN_DETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'PAYER_ACCT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_UP_CLARIFY_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PAY_ACCT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_up_clarify_dtl_amssf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                                        ,ser_num
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
        into ${iml_schema}.evt_up_clarify_dtl_amssf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_no -- 批次号
    ,fund_corp_id -- 基金公司编号
    ,belong_org_id -- 所属机构编号
    ,cnter_org_id -- 柜台机构编号
    ,remit_acct_dt -- 划账日期
    ,remit_acct_status_cd -- 划账状态代码
    ,should_remit_acct_amt -- 应划账金额
    ,actl_remit_acct_amt -- 实际划账金额
    ,fail_rs -- 失败原因
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_open_bank_num -- 付款账户开户行号
    ,pay_acct_open_bank_name -- 付款账户开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,valid_flg -- 有效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_up_clarify_dtl_amssf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_no -- 批次号
    ,fund_corp_id -- 基金公司编号
    ,belong_org_id -- 所属机构编号
    ,cnter_org_id -- 柜台机构编号
    ,remit_acct_dt -- 划账日期
    ,remit_acct_status_cd -- 划账状态代码
    ,should_remit_acct_amt -- 应划账金额
    ,actl_remit_acct_amt -- 实际划账金额
    ,fail_rs -- 失败原因
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_open_bank_num -- 付款账户开户行号
    ,pay_acct_open_bank_name -- 付款账户开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
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
    ,nvl(n.ser_num, o.ser_num) as ser_num -- 序列号
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.fund_corp_id, o.fund_corp_id) as fund_corp_id -- 基金公司编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.cnter_org_id, o.cnter_org_id) as cnter_org_id -- 柜台机构编号
    ,nvl(n.remit_acct_dt, o.remit_acct_dt) as remit_acct_dt -- 划账日期
    ,nvl(n.remit_acct_status_cd, o.remit_acct_status_cd) as remit_acct_status_cd -- 划账状态代码
    ,nvl(n.should_remit_acct_amt, o.should_remit_acct_amt) as should_remit_acct_amt -- 应划账金额
    ,nvl(n.actl_remit_acct_amt, o.actl_remit_acct_amt) as actl_remit_acct_amt -- 实际划账金额
    ,nvl(n.fail_rs, o.fail_rs) as fail_rs -- 失败原因
    ,nvl(n.pay_acct_id, o.pay_acct_id) as pay_acct_id -- 付款账户编号
    ,nvl(n.pay_acct_name, o.pay_acct_name) as pay_acct_name -- 付款账户名称
    ,nvl(n.pay_acct_type_cd, o.pay_acct_type_cd) as pay_acct_type_cd -- 付款账户类型代码
    ,nvl(n.pay_acct_open_bank_num, o.pay_acct_open_bank_num) as pay_acct_open_bank_num -- 付款账户开户行号
    ,nvl(n.pay_acct_open_bank_name, o.pay_acct_open_bank_name) as pay_acct_open_bank_name -- 付款账户开户行名称
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.recvbl_acct_name, o.recvbl_acct_name) as recvbl_acct_name -- 收款账户名称
    ,nvl(n.recvbl_acct_type_cd, o.recvbl_acct_type_cd) as recvbl_acct_type_cd -- 收款账户类型代码
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.ser_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.ser_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.ser_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_up_clarify_dtl_amssf1_tm n
    full join (select * from ${iml_schema}.evt_up_clarify_dtl_amssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.ser_num = n.ser_num
where (
        o.evt_id is null
        and o.lp_id is null
        and o.ser_num is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
        and n.ser_num is null
    )
    or (
        o.batch_no <> n.batch_no
        or o.fund_corp_id <> n.fund_corp_id
        or o.belong_org_id <> n.belong_org_id
        or o.cnter_org_id <> n.cnter_org_id
        or o.remit_acct_dt <> n.remit_acct_dt
        or o.remit_acct_status_cd <> n.remit_acct_status_cd
        or o.should_remit_acct_amt <> n.should_remit_acct_amt
        or o.actl_remit_acct_amt <> n.actl_remit_acct_amt
        or o.fail_rs <> n.fail_rs
        or o.pay_acct_id <> n.pay_acct_id
        or o.pay_acct_name <> n.pay_acct_name
        or o.pay_acct_type_cd <> n.pay_acct_type_cd
        or o.pay_acct_open_bank_num <> n.pay_acct_open_bank_num
        or o.pay_acct_open_bank_name <> n.pay_acct_open_bank_name
        or o.recvbl_acct_id <> n.recvbl_acct_id
        or o.recvbl_acct_name <> n.recvbl_acct_name
        or o.recvbl_acct_type_cd <> n.recvbl_acct_type_cd
        or o.valid_flg <> n.valid_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_up_clarify_dtl_amssf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_no -- 批次号
    ,fund_corp_id -- 基金公司编号
    ,belong_org_id -- 所属机构编号
    ,cnter_org_id -- 柜台机构编号
    ,remit_acct_dt -- 划账日期
    ,remit_acct_status_cd -- 划账状态代码
    ,should_remit_acct_amt -- 应划账金额
    ,actl_remit_acct_amt -- 实际划账金额
    ,fail_rs -- 失败原因
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_open_bank_num -- 付款账户开户行号
    ,pay_acct_open_bank_name -- 付款账户开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,valid_flg -- 有效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_up_clarify_dtl_amssf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,batch_no -- 批次号
    ,fund_corp_id -- 基金公司编号
    ,belong_org_id -- 所属机构编号
    ,cnter_org_id -- 柜台机构编号
    ,remit_acct_dt -- 划账日期
    ,remit_acct_status_cd -- 划账状态代码
    ,should_remit_acct_amt -- 应划账金额
    ,actl_remit_acct_amt -- 实际划账金额
    ,fail_rs -- 失败原因
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_open_bank_num -- 付款账户开户行号
    ,pay_acct_open_bank_name -- 付款账户开户行名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
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
    ,o.ser_num -- 序列号
    ,o.batch_no -- 批次号
    ,o.fund_corp_id -- 基金公司编号
    ,o.belong_org_id -- 所属机构编号
    ,o.cnter_org_id -- 柜台机构编号
    ,o.remit_acct_dt -- 划账日期
    ,o.remit_acct_status_cd -- 划账状态代码
    ,o.should_remit_acct_amt -- 应划账金额
    ,o.actl_remit_acct_amt -- 实际划账金额
    ,o.fail_rs -- 失败原因
    ,o.pay_acct_id -- 付款账户编号
    ,o.pay_acct_name -- 付款账户名称
    ,o.pay_acct_type_cd -- 付款账户类型代码
    ,o.pay_acct_open_bank_num -- 付款账户开户行号
    ,o.pay_acct_open_bank_name -- 付款账户开户行名称
    ,o.recvbl_acct_id -- 收款账户编号
    ,o.recvbl_acct_name -- 收款账户名称
    ,o.recvbl_acct_type_cd -- 收款账户类型代码
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
from ${iml_schema}.evt_up_clarify_dtl_amssf1_bk o
    left join ${iml_schema}.evt_up_clarify_dtl_amssf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.ser_num = n.ser_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_up_clarify_dtl_amssf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
            and o.ser_num = d.ser_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_up_clarify_dtl;
--alter table ${iml_schema}.evt_up_clarify_dtl truncate partition for ('amssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_up_clarify_dtl') 
               and substr(subpartition_name,1,8)=upper('p_amssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_up_clarify_dtl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_up_clarify_dtl modify partition p_amssf1 
add subpartition p_amssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_up_clarify_dtl exchange subpartition p_amssf1_${batch_date} with table ${iml_schema}.evt_up_clarify_dtl_amssf1_cl;
alter table ${iml_schema}.evt_up_clarify_dtl exchange subpartition p_amssf1_20991231 with table ${iml_schema}.evt_up_clarify_dtl_amssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_up_clarify_dtl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_up_clarify_dtl_amssf1_tm purge;
drop table ${iml_schema}.evt_up_clarify_dtl_amssf1_op purge;
drop table ${iml_schema}.evt_up_clarify_dtl_amssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_up_clarify_dtl_amssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_up_clarify_dtl', partname => 'p_amssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
