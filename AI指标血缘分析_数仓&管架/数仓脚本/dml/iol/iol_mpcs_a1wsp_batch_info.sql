/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1wsp_batch_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.mpcs_a1wsp_batch_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1wsp_batch_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1wsp_batch_info_op purge;
drop table ${iol_schema}.mpcs_a1wsp_batch_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1wsp_batch_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1wsp_batch_info where 0=1;

create table ${iol_schema}.mpcs_a1wsp_batch_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1wsp_batch_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1wsp_batch_info_cl(
            batch_no -- 批次编号
            ,batch_step -- 批次步骤(00-初始化;01-申请;02-代发;03-企业网银)
            ,batch_status -- 批次状态(00-初始化;01-处理成功;02-处理失败;03-已撤回;99-处理中)
            ,refund_status -- 退款状态(00-无需退款;01-待退款;02-退款成功;03-退款失败;04-退款状态未知;99-退款中)
            ,pay_acct_no -- 代发账户
            ,pay_source -- 代发来源(1-上传文件;2-薪酬计算)
            ,pay_type -- 代发类型(1-工资;2-报销;3-奖金;4-其他)
            ,batch_date -- 批次日期
            ,batch_time -- 批次时间
            ,batch_finish_time -- 批次完成时间
            ,total_dtl_num -- 总笔数
            ,total_amt -- 总金额
            ,average_amt -- 平均金额
            ,success_amt -- 代发成功金额
            ,fail_amt -- 代发失败总金额
            ,succ_dtl_num -- 代发成功数
            ,fail_dtl_num -- 代发失败数
            ,unknown_dtl_num -- 代发交易状态未知数
            ,fee_amt -- 手续费金额
            ,matter_id -- 审批事项ID
            ,batch_month -- 所属月份
            ,batch_year -- 所属年份
            ,batch_title -- 批次标题
            ,total_people_count -- 总人数
            ,summary_name -- 摘要名称
            ,salary_info -- 薪金说明
            ,company_id -- 企业ID
            ,company_name -- 企业名称
            ,salary_group_id -- 薪酬组ID
            ,branch_no -- 机构编号
            ,show_dtl_flag -- 是否展示代发明细(Y-是;N-否)
            ,lock_flag -- 锁定标志(UNLOCK-未锁定;LOCK-锁定)
            ,batch_file_name -- 代发批次文件名称
            ,batch_file_md5 -- 代发批次文件MD5
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1wsp_batch_info_op(
            batch_no -- 批次编号
            ,batch_step -- 批次步骤(00-初始化;01-申请;02-代发;03-企业网银)
            ,batch_status -- 批次状态(00-初始化;01-处理成功;02-处理失败;03-已撤回;99-处理中)
            ,refund_status -- 退款状态(00-无需退款;01-待退款;02-退款成功;03-退款失败;04-退款状态未知;99-退款中)
            ,pay_acct_no -- 代发账户
            ,pay_source -- 代发来源(1-上传文件;2-薪酬计算)
            ,pay_type -- 代发类型(1-工资;2-报销;3-奖金;4-其他)
            ,batch_date -- 批次日期
            ,batch_time -- 批次时间
            ,batch_finish_time -- 批次完成时间
            ,total_dtl_num -- 总笔数
            ,total_amt -- 总金额
            ,average_amt -- 平均金额
            ,success_amt -- 代发成功金额
            ,fail_amt -- 代发失败总金额
            ,succ_dtl_num -- 代发成功数
            ,fail_dtl_num -- 代发失败数
            ,unknown_dtl_num -- 代发交易状态未知数
            ,fee_amt -- 手续费金额
            ,matter_id -- 审批事项ID
            ,batch_month -- 所属月份
            ,batch_year -- 所属年份
            ,batch_title -- 批次标题
            ,total_people_count -- 总人数
            ,summary_name -- 摘要名称
            ,salary_info -- 薪金说明
            ,company_id -- 企业ID
            ,company_name -- 企业名称
            ,salary_group_id -- 薪酬组ID
            ,branch_no -- 机构编号
            ,show_dtl_flag -- 是否展示代发明细(Y-是;N-否)
            ,lock_flag -- 锁定标志(UNLOCK-未锁定;LOCK-锁定)
            ,batch_file_name -- 代发批次文件名称
            ,batch_file_md5 -- 代发批次文件MD5
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.batch_no, o.batch_no) as batch_no -- 批次编号
    ,nvl(n.batch_step, o.batch_step) as batch_step -- 批次步骤(00-初始化;01-申请;02-代发;03-企业网银)
    ,nvl(n.batch_status, o.batch_status) as batch_status -- 批次状态(00-初始化;01-处理成功;02-处理失败;03-已撤回;99-处理中)
    ,nvl(n.refund_status, o.refund_status) as refund_status -- 退款状态(00-无需退款;01-待退款;02-退款成功;03-退款失败;04-退款状态未知;99-退款中)
    ,nvl(n.pay_acct_no, o.pay_acct_no) as pay_acct_no -- 代发账户
    ,nvl(n.pay_source, o.pay_source) as pay_source -- 代发来源(1-上传文件;2-薪酬计算)
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 代发类型(1-工资;2-报销;3-奖金;4-其他)
    ,nvl(n.batch_date, o.batch_date) as batch_date -- 批次日期
    ,nvl(n.batch_time, o.batch_time) as batch_time -- 批次时间
    ,nvl(n.batch_finish_time, o.batch_finish_time) as batch_finish_time -- 批次完成时间
    ,nvl(n.total_dtl_num, o.total_dtl_num) as total_dtl_num -- 总笔数
    ,nvl(n.total_amt, o.total_amt) as total_amt -- 总金额
    ,nvl(n.average_amt, o.average_amt) as average_amt -- 平均金额
    ,nvl(n.success_amt, o.success_amt) as success_amt -- 代发成功金额
    ,nvl(n.fail_amt, o.fail_amt) as fail_amt -- 代发失败总金额
    ,nvl(n.succ_dtl_num, o.succ_dtl_num) as succ_dtl_num -- 代发成功数
    ,nvl(n.fail_dtl_num, o.fail_dtl_num) as fail_dtl_num -- 代发失败数
    ,nvl(n.unknown_dtl_num, o.unknown_dtl_num) as unknown_dtl_num -- 代发交易状态未知数
    ,nvl(n.fee_amt, o.fee_amt) as fee_amt -- 手续费金额
    ,nvl(n.matter_id, o.matter_id) as matter_id -- 审批事项ID
    ,nvl(n.batch_month, o.batch_month) as batch_month -- 所属月份
    ,nvl(n.batch_year, o.batch_year) as batch_year -- 所属年份
    ,nvl(n.batch_title, o.batch_title) as batch_title -- 批次标题
    ,nvl(n.total_people_count, o.total_people_count) as total_people_count -- 总人数
    ,nvl(n.summary_name, o.summary_name) as summary_name -- 摘要名称
    ,nvl(n.salary_info, o.salary_info) as salary_info -- 薪金说明
    ,nvl(n.company_id, o.company_id) as company_id -- 企业ID
    ,nvl(n.company_name, o.company_name) as company_name -- 企业名称
    ,nvl(n.salary_group_id, o.salary_group_id) as salary_group_id -- 薪酬组ID
    ,nvl(n.branch_no, o.branch_no) as branch_no -- 机构编号
    ,nvl(n.show_dtl_flag, o.show_dtl_flag) as show_dtl_flag -- 是否展示代发明细(Y-是;N-否)
    ,nvl(n.lock_flag, o.lock_flag) as lock_flag -- 锁定标志(UNLOCK-未锁定;LOCK-锁定)
    ,nvl(n.batch_file_name, o.batch_file_name) as batch_file_name -- 代发批次文件名称
    ,nvl(n.batch_file_md5, o.batch_file_md5) as batch_file_md5 -- 代发批次文件MD5
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 更新时间戳
    ,case when
            n.batch_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.batch_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.batch_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1wsp_batch_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1wsp_batch_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.batch_no = n.batch_no
where (
        o.batch_no is null
    )
    or (
        n.batch_no is null
    )
    or (
        o.batch_step <> n.batch_step
        or o.batch_status <> n.batch_status
        or o.refund_status <> n.refund_status
        or o.pay_acct_no <> n.pay_acct_no
        or o.pay_source <> n.pay_source
        or o.pay_type <> n.pay_type
        or o.batch_date <> n.batch_date
        or o.batch_time <> n.batch_time
        or o.batch_finish_time <> n.batch_finish_time
        or o.total_dtl_num <> n.total_dtl_num
        or o.total_amt <> n.total_amt
        or o.average_amt <> n.average_amt
        or o.success_amt <> n.success_amt
        or o.fail_amt <> n.fail_amt
        or o.succ_dtl_num <> n.succ_dtl_num
        or o.fail_dtl_num <> n.fail_dtl_num
        or o.unknown_dtl_num <> n.unknown_dtl_num
        or o.fee_amt <> n.fee_amt
        or o.matter_id <> n.matter_id
        or o.batch_month <> n.batch_month
        or o.batch_year <> n.batch_year
        or o.batch_title <> n.batch_title
        or o.total_people_count <> n.total_people_count
        or o.summary_name <> n.summary_name
        or o.salary_info <> n.salary_info
        or o.company_id <> n.company_id
        or o.company_name <> n.company_name
        or o.salary_group_id <> n.salary_group_id
        or o.branch_no <> n.branch_no
        or o.show_dtl_flag <> n.show_dtl_flag
        or o.lock_flag <> n.lock_flag
        or o.batch_file_name <> n.batch_file_name
        or o.batch_file_md5 <> n.batch_file_md5
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1wsp_batch_info_cl(
            batch_no -- 批次编号
            ,batch_step -- 批次步骤(00-初始化;01-申请;02-代发;03-企业网银)
            ,batch_status -- 批次状态(00-初始化;01-处理成功;02-处理失败;03-已撤回;99-处理中)
            ,refund_status -- 退款状态(00-无需退款;01-待退款;02-退款成功;03-退款失败;04-退款状态未知;99-退款中)
            ,pay_acct_no -- 代发账户
            ,pay_source -- 代发来源(1-上传文件;2-薪酬计算)
            ,pay_type -- 代发类型(1-工资;2-报销;3-奖金;4-其他)
            ,batch_date -- 批次日期
            ,batch_time -- 批次时间
            ,batch_finish_time -- 批次完成时间
            ,total_dtl_num -- 总笔数
            ,total_amt -- 总金额
            ,average_amt -- 平均金额
            ,success_amt -- 代发成功金额
            ,fail_amt -- 代发失败总金额
            ,succ_dtl_num -- 代发成功数
            ,fail_dtl_num -- 代发失败数
            ,unknown_dtl_num -- 代发交易状态未知数
            ,fee_amt -- 手续费金额
            ,matter_id -- 审批事项ID
            ,batch_month -- 所属月份
            ,batch_year -- 所属年份
            ,batch_title -- 批次标题
            ,total_people_count -- 总人数
            ,summary_name -- 摘要名称
            ,salary_info -- 薪金说明
            ,company_id -- 企业ID
            ,company_name -- 企业名称
            ,salary_group_id -- 薪酬组ID
            ,branch_no -- 机构编号
            ,show_dtl_flag -- 是否展示代发明细(Y-是;N-否)
            ,lock_flag -- 锁定标志(UNLOCK-未锁定;LOCK-锁定)
            ,batch_file_name -- 代发批次文件名称
            ,batch_file_md5 -- 代发批次文件MD5
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1wsp_batch_info_op(
            batch_no -- 批次编号
            ,batch_step -- 批次步骤(00-初始化;01-申请;02-代发;03-企业网银)
            ,batch_status -- 批次状态(00-初始化;01-处理成功;02-处理失败;03-已撤回;99-处理中)
            ,refund_status -- 退款状态(00-无需退款;01-待退款;02-退款成功;03-退款失败;04-退款状态未知;99-退款中)
            ,pay_acct_no -- 代发账户
            ,pay_source -- 代发来源(1-上传文件;2-薪酬计算)
            ,pay_type -- 代发类型(1-工资;2-报销;3-奖金;4-其他)
            ,batch_date -- 批次日期
            ,batch_time -- 批次时间
            ,batch_finish_time -- 批次完成时间
            ,total_dtl_num -- 总笔数
            ,total_amt -- 总金额
            ,average_amt -- 平均金额
            ,success_amt -- 代发成功金额
            ,fail_amt -- 代发失败总金额
            ,succ_dtl_num -- 代发成功数
            ,fail_dtl_num -- 代发失败数
            ,unknown_dtl_num -- 代发交易状态未知数
            ,fee_amt -- 手续费金额
            ,matter_id -- 审批事项ID
            ,batch_month -- 所属月份
            ,batch_year -- 所属年份
            ,batch_title -- 批次标题
            ,total_people_count -- 总人数
            ,summary_name -- 摘要名称
            ,salary_info -- 薪金说明
            ,company_id -- 企业ID
            ,company_name -- 企业名称
            ,salary_group_id -- 薪酬组ID
            ,branch_no -- 机构编号
            ,show_dtl_flag -- 是否展示代发明细(Y-是;N-否)
            ,lock_flag -- 锁定标志(UNLOCK-未锁定;LOCK-锁定)
            ,batch_file_name -- 代发批次文件名称
            ,batch_file_md5 -- 代发批次文件MD5
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.batch_no -- 批次编号
    ,o.batch_step -- 批次步骤(00-初始化;01-申请;02-代发;03-企业网银)
    ,o.batch_status -- 批次状态(00-初始化;01-处理成功;02-处理失败;03-已撤回;99-处理中)
    ,o.refund_status -- 退款状态(00-无需退款;01-待退款;02-退款成功;03-退款失败;04-退款状态未知;99-退款中)
    ,o.pay_acct_no -- 代发账户
    ,o.pay_source -- 代发来源(1-上传文件;2-薪酬计算)
    ,o.pay_type -- 代发类型(1-工资;2-报销;3-奖金;4-其他)
    ,o.batch_date -- 批次日期
    ,o.batch_time -- 批次时间
    ,o.batch_finish_time -- 批次完成时间
    ,o.total_dtl_num -- 总笔数
    ,o.total_amt -- 总金额
    ,o.average_amt -- 平均金额
    ,o.success_amt -- 代发成功金额
    ,o.fail_amt -- 代发失败总金额
    ,o.succ_dtl_num -- 代发成功数
    ,o.fail_dtl_num -- 代发失败数
    ,o.unknown_dtl_num -- 代发交易状态未知数
    ,o.fee_amt -- 手续费金额
    ,o.matter_id -- 审批事项ID
    ,o.batch_month -- 所属月份
    ,o.batch_year -- 所属年份
    ,o.batch_title -- 批次标题
    ,o.total_people_count -- 总人数
    ,o.summary_name -- 摘要名称
    ,o.salary_info -- 薪金说明
    ,o.company_id -- 企业ID
    ,o.company_name -- 企业名称
    ,o.salary_group_id -- 薪酬组ID
    ,o.branch_no -- 机构编号
    ,o.show_dtl_flag -- 是否展示代发明细(Y-是;N-否)
    ,o.lock_flag -- 锁定标志(UNLOCK-未锁定;LOCK-锁定)
    ,o.batch_file_name -- 代发批次文件名称
    ,o.batch_file_md5 -- 代发批次文件MD5
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 更新时间戳
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a1wsp_batch_info_bk o
    left join ${iol_schema}.mpcs_a1wsp_batch_info_op n
        on
            o.batch_no = n.batch_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1wsp_batch_info_cl d
        on
            o.batch_no = d.batch_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a1wsp_batch_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a1wsp_batch_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a1wsp_batch_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a1wsp_batch_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a1wsp_batch_info exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1wsp_batch_info_cl;
alter table ${iol_schema}.mpcs_a1wsp_batch_info exchange partition p_20991231 with table ${iol_schema}.mpcs_a1wsp_batch_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1wsp_batch_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1wsp_batch_info_op purge;
drop table ${iol_schema}.mpcs_a1wsp_batch_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1wsp_batch_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1wsp_batch_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
