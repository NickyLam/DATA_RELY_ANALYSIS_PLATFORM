/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_pre_turn_long_hang_acct_h_ncbsf1
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
alter table ${iml_schema}.agt_pre_turn_long_hang_acct_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_pre_turn_long_hang_acct_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,batch_no -- 批次号
    ,acct_name -- 账户名称
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,batch_proc_status_cd -- 批次处理状态代码
    ,audit_dt -- 审计日期
    ,turn_long_hang_dt -- 转久悬日期
    ,pre_turn_idf_cd -- 预转标识代码
    ,apv_status_cd -- 审批状态代码
    ,open_acct_org_id -- 开户机构编号
    ,fail_rs_descb -- 失败原因描述
    ,remark -- 备注
    ,check_dt -- 复核日期
    ,core_flow_num -- 核心流水号
    ,tran_teller_id -- 交易柜员编号
    ,lmt_and_chn_ctrl_info_remark -- 限制及渠道控制信息备注
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_pre_turn_long_hang_acct_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_pre_turn_long_hang_acct_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_pre_turn_long_hang_acct_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_pre_doss_reg-1
insert into ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,batch_no -- 批次号
    ,acct_name -- 账户名称
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,batch_proc_status_cd -- 批次处理状态代码
    ,audit_dt -- 审计日期
    ,turn_long_hang_dt -- 转久悬日期
    ,pre_turn_idf_cd -- 预转标识代码
    ,apv_status_cd -- 审批状态代码
    ,open_acct_org_id -- 开户机构编号
    ,fail_rs_descb -- 失败原因描述
    ,remark -- 备注
    ,check_dt -- 复核日期
    ,core_flow_num -- 核心流水号
    ,tran_teller_id -- 交易柜员编号
    ,lmt_and_chn_ctrl_info_remark -- 限制及渠道控制信息备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.BATCH_NO -- 批次号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.BATCH_STATUS),'-') -- 批次处理状态代码
    ,P1.AUDIT_DATE -- 审计日期
    ,P1.DOSS_DATE -- 转久悬日期
    ,nvl(trim(P1.PRE_TRF_FLAG),'-') -- 预转标识代码
    ,nvl(trim(P1.APPROVE_STATUS),'-') -- 审批状态代码
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,P1.FAILURE_REASON -- 失败原因描述
    ,P1.REMARK -- 备注
    ,P1.APPROVAL_DATE -- 复核日期
    ,P1.SUB_SEQ_NO -- 核心流水号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.CONTROL_MSG -- 限制及渠道控制信息备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_pre_doss_reg' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_pre_doss_reg p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_id
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
        into ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,batch_no -- 批次号
    ,acct_name -- 账户名称
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,batch_proc_status_cd -- 批次处理状态代码
    ,audit_dt -- 审计日期
    ,turn_long_hang_dt -- 转久悬日期
    ,pre_turn_idf_cd -- 预转标识代码
    ,apv_status_cd -- 审批状态代码
    ,open_acct_org_id -- 开户机构编号
    ,fail_rs_descb -- 失败原因描述
    ,remark -- 备注
    ,check_dt -- 复核日期
    ,core_flow_num -- 核心流水号
    ,tran_teller_id -- 交易柜员编号
    ,lmt_and_chn_ctrl_info_remark -- 限制及渠道控制信息备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,batch_no -- 批次号
    ,acct_name -- 账户名称
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,batch_proc_status_cd -- 批次处理状态代码
    ,audit_dt -- 审计日期
    ,turn_long_hang_dt -- 转久悬日期
    ,pre_turn_idf_cd -- 预转标识代码
    ,apv_status_cd -- 审批状态代码
    ,open_acct_org_id -- 开户机构编号
    ,fail_rs_descb -- 失败原因描述
    ,remark -- 备注
    ,check_dt -- 复核日期
    ,core_flow_num -- 核心流水号
    ,tran_teller_id -- 交易柜员编号
    ,lmt_and_chn_ctrl_info_remark -- 限制及渠道控制信息备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.batch_no, o.batch_no) as batch_no -- 批次号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.batch_proc_status_cd, o.batch_proc_status_cd) as batch_proc_status_cd -- 批次处理状态代码
    ,nvl(n.audit_dt, o.audit_dt) as audit_dt -- 审计日期
    ,nvl(n.turn_long_hang_dt, o.turn_long_hang_dt) as turn_long_hang_dt -- 转久悬日期
    ,nvl(n.pre_turn_idf_cd, o.pre_turn_idf_cd) as pre_turn_idf_cd -- 预转标识代码
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.fail_rs_descb, o.fail_rs_descb) as fail_rs_descb -- 失败原因描述
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.check_dt, o.check_dt) as check_dt -- 复核日期
    ,nvl(n.core_flow_num, o.core_flow_num) as core_flow_num -- 核心流水号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.lmt_and_chn_ctrl_info_remark, o.lmt_and_chn_ctrl_info_remark) as lmt_and_chn_ctrl_info_remark -- 限制及渠道控制信息备注
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
    )
    or (
        o.batch_no <> n.batch_no
        or o.acct_name <> n.acct_name
        or o.sub_acct_num <> n.sub_acct_num
        or o.cust_acct_num <> n.cust_acct_num
        or o.cust_id <> n.cust_id
        or o.batch_proc_status_cd <> n.batch_proc_status_cd
        or o.audit_dt <> n.audit_dt
        or o.turn_long_hang_dt <> n.turn_long_hang_dt
        or o.pre_turn_idf_cd <> n.pre_turn_idf_cd
        or o.apv_status_cd <> n.apv_status_cd
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.fail_rs_descb <> n.fail_rs_descb
        or o.remark <> n.remark
        or o.check_dt <> n.check_dt
        or o.core_flow_num <> n.core_flow_num
        or o.tran_teller_id <> n.tran_teller_id
        or o.lmt_and_chn_ctrl_info_remark <> n.lmt_and_chn_ctrl_info_remark
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,batch_no -- 批次号
    ,acct_name -- 账户名称
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,batch_proc_status_cd -- 批次处理状态代码
    ,audit_dt -- 审计日期
    ,turn_long_hang_dt -- 转久悬日期
    ,pre_turn_idf_cd -- 预转标识代码
    ,apv_status_cd -- 审批状态代码
    ,open_acct_org_id -- 开户机构编号
    ,fail_rs_descb -- 失败原因描述
    ,remark -- 备注
    ,check_dt -- 复核日期
    ,core_flow_num -- 核心流水号
    ,tran_teller_id -- 交易柜员编号
    ,lmt_and_chn_ctrl_info_remark -- 限制及渠道控制信息备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,batch_no -- 批次号
    ,acct_name -- 账户名称
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,batch_proc_status_cd -- 批次处理状态代码
    ,audit_dt -- 审计日期
    ,turn_long_hang_dt -- 转久悬日期
    ,pre_turn_idf_cd -- 预转标识代码
    ,apv_status_cd -- 审批状态代码
    ,open_acct_org_id -- 开户机构编号
    ,fail_rs_descb -- 失败原因描述
    ,remark -- 备注
    ,check_dt -- 复核日期
    ,core_flow_num -- 核心流水号
    ,tran_teller_id -- 交易柜员编号
    ,lmt_and_chn_ctrl_info_remark -- 限制及渠道控制信息备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.acct_id -- 账户编号
    ,o.batch_no -- 批次号
    ,o.acct_name -- 账户名称
    ,o.sub_acct_num -- 子账号
    ,o.cust_acct_num -- 客户账号
    ,o.cust_id -- 客户编号
    ,o.batch_proc_status_cd -- 批次处理状态代码
    ,o.audit_dt -- 审计日期
    ,o.turn_long_hang_dt -- 转久悬日期
    ,o.pre_turn_idf_cd -- 预转标识代码
    ,o.apv_status_cd -- 审批状态代码
    ,o.open_acct_org_id -- 开户机构编号
    ,o.fail_rs_descb -- 失败原因描述
    ,o.remark -- 备注
    ,o.check_dt -- 复核日期
    ,o.core_flow_num -- 核心流水号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.lmt_and_chn_ctrl_info_remark -- 限制及渠道控制信息备注
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
from ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_bk o
    left join ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_pre_turn_long_hang_acct_h;
--alter table ${iml_schema}.agt_pre_turn_long_hang_acct_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_pre_turn_long_hang_acct_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_pre_turn_long_hang_acct_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_pre_turn_long_hang_acct_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_pre_turn_long_hang_acct_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_cl;
alter table ${iml_schema}.agt_pre_turn_long_hang_acct_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_pre_turn_long_hang_acct_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_pre_turn_long_hang_acct_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_pre_turn_long_hang_acct_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
