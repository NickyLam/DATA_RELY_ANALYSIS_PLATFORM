/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_hgls_loan_req_audit
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
create table ${iol_schema}.hgls_loan_req_audit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.hgls_loan_req_audit
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_loan_req_audit_op purge;
drop table ${iol_schema}.hgls_loan_req_audit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_loan_req_audit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_loan_req_audit where 0=1;

create table ${iol_schema}.hgls_loan_req_audit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_loan_req_audit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_loan_req_audit_cl(
            audit_id -- 主键id
            ,loan_id -- 进件id
            ,approver_user_id -- 审批人ID
            ,approver_user_name -- 审批人名字
            ,daily_rate -- 日利率（百分之一）
            ,fnl_store -- 综合授信评分
            ,repayment_period -- 最高返款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
            ,repayment_kind -- 还款方式
            ,auth_money -- 授信金额
            ,rank -- 评级（A-F）
            ,audit_status -- AUDIT_STATUS
            ,history_audit_status -- 是否历史审批0否，1是
            ,repulse_reason -- 审批打回原因
            ,audit_date -- 申请日期
            ,need_escort -- 是否需要陪调客户经理
            ,credit_guaranty -- 是否需要担保人
            ,inquiry_way -- 调查方式；1，简单，2，一般，3，复杂
            ,credit_company -- 是否需要上传征信
            ,pledge_type -- 抵押分类
            ,assess_price -- 评估价格
            ,year_rate -- 年利率
            ,resolution -- 信息复合会办决议
            ,remark -- 会办决议备注
            ,custom_capital -- 是否自定义本金
            ,allow_one_sign -- 是否允许单签
            ,loan_proof -- 放款凭证
            ,mark -- 模型标记信息
            ,biz_type -- 业务类型，0主借人1配偶
            ,model_frequency -- 监测周期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_loan_req_audit_op(
            audit_id -- 主键id
            ,loan_id -- 进件id
            ,approver_user_id -- 审批人ID
            ,approver_user_name -- 审批人名字
            ,daily_rate -- 日利率（百分之一）
            ,fnl_store -- 综合授信评分
            ,repayment_period -- 最高返款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
            ,repayment_kind -- 还款方式
            ,auth_money -- 授信金额
            ,rank -- 评级（A-F）
            ,audit_status -- AUDIT_STATUS
            ,history_audit_status -- 是否历史审批0否，1是
            ,repulse_reason -- 审批打回原因
            ,audit_date -- 申请日期
            ,need_escort -- 是否需要陪调客户经理
            ,credit_guaranty -- 是否需要担保人
            ,inquiry_way -- 调查方式；1，简单，2，一般，3，复杂
            ,credit_company -- 是否需要上传征信
            ,pledge_type -- 抵押分类
            ,assess_price -- 评估价格
            ,year_rate -- 年利率
            ,resolution -- 信息复合会办决议
            ,remark -- 会办决议备注
            ,custom_capital -- 是否自定义本金
            ,allow_one_sign -- 是否允许单签
            ,loan_proof -- 放款凭证
            ,mark -- 模型标记信息
            ,biz_type -- 业务类型，0主借人1配偶
            ,model_frequency -- 监测周期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.audit_id, o.audit_id) as audit_id -- 主键id
    ,nvl(n.loan_id, o.loan_id) as loan_id -- 进件id
    ,nvl(n.approver_user_id, o.approver_user_id) as approver_user_id -- 审批人ID
    ,nvl(n.approver_user_name, o.approver_user_name) as approver_user_name -- 审批人名字
    ,nvl(n.daily_rate, o.daily_rate) as daily_rate -- 日利率（百分之一）
    ,nvl(n.fnl_store, o.fnl_store) as fnl_store -- 综合授信评分
    ,nvl(n.repayment_period, o.repayment_period) as repayment_period -- 最高返款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
    ,nvl(n.repayment_kind, o.repayment_kind) as repayment_kind -- 还款方式
    ,nvl(n.auth_money, o.auth_money) as auth_money -- 授信金额
    ,nvl(n.rank, o.rank) as rank -- 评级（A-F）
    ,nvl(n.audit_status, o.audit_status) as audit_status -- AUDIT_STATUS
    ,nvl(n.history_audit_status, o.history_audit_status) as history_audit_status -- 是否历史审批0否，1是
    ,nvl(n.repulse_reason, o.repulse_reason) as repulse_reason -- 审批打回原因
    ,nvl(n.audit_date, o.audit_date) as audit_date -- 申请日期
    ,nvl(n.need_escort, o.need_escort) as need_escort -- 是否需要陪调客户经理
    ,nvl(n.credit_guaranty, o.credit_guaranty) as credit_guaranty -- 是否需要担保人
    ,nvl(n.inquiry_way, o.inquiry_way) as inquiry_way -- 调查方式；1，简单，2，一般，3，复杂
    ,nvl(n.credit_company, o.credit_company) as credit_company -- 是否需要上传征信
    ,nvl(n.pledge_type, o.pledge_type) as pledge_type -- 抵押分类
    ,nvl(n.assess_price, o.assess_price) as assess_price -- 评估价格
    ,nvl(n.year_rate, o.year_rate) as year_rate -- 年利率
    ,nvl(n.resolution, o.resolution) as resolution -- 信息复合会办决议
    ,nvl(n.remark, o.remark) as remark -- 会办决议备注
    ,nvl(n.custom_capital, o.custom_capital) as custom_capital -- 是否自定义本金
    ,nvl(n.allow_one_sign, o.allow_one_sign) as allow_one_sign -- 是否允许单签
    ,nvl(n.loan_proof, o.loan_proof) as loan_proof -- 放款凭证
    ,nvl(n.mark, o.mark) as mark -- 模型标记信息
    ,nvl(n.biz_type, o.biz_type) as biz_type -- 业务类型，0主借人1配偶
    ,nvl(n.model_frequency, o.model_frequency) as model_frequency -- 监测周期
    ,case when
            n.audit_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.audit_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.audit_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.hgls_loan_req_audit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.hgls_loan_req_audit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.audit_id = n.audit_id
where (
        o.audit_id is null
    )
    or (
        n.audit_id is null
    )
    or (
        o.loan_id <> n.loan_id
        or o.approver_user_id <> n.approver_user_id
        or o.approver_user_name <> n.approver_user_name
        or o.daily_rate <> n.daily_rate
        or o.fnl_store <> n.fnl_store
        or o.repayment_period <> n.repayment_period
        or o.repayment_kind <> n.repayment_kind
        or o.auth_money <> n.auth_money
        or o.rank <> n.rank
        or o.audit_status <> n.audit_status
        or o.history_audit_status <> n.history_audit_status
        or o.repulse_reason <> n.repulse_reason
        or o.audit_date <> n.audit_date
        or o.need_escort <> n.need_escort
        or o.credit_guaranty <> n.credit_guaranty
        or o.inquiry_way <> n.inquiry_way
        or o.credit_company <> n.credit_company
        or o.pledge_type <> n.pledge_type
        or o.assess_price <> n.assess_price
        or o.year_rate <> n.year_rate
        or o.resolution <> n.resolution
        or o.remark <> n.remark
        or o.custom_capital <> n.custom_capital
        or o.allow_one_sign <> n.allow_one_sign
        or o.loan_proof <> n.loan_proof
        or o.mark <> n.mark
        or o.biz_type <> n.biz_type
        or o.model_frequency <> n.model_frequency
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_loan_req_audit_cl(
            audit_id -- 主键id
            ,loan_id -- 进件id
            ,approver_user_id -- 审批人ID
            ,approver_user_name -- 审批人名字
            ,daily_rate -- 日利率（百分之一）
            ,fnl_store -- 综合授信评分
            ,repayment_period -- 最高返款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
            ,repayment_kind -- 还款方式
            ,auth_money -- 授信金额
            ,rank -- 评级（A-F）
            ,audit_status -- AUDIT_STATUS
            ,history_audit_status -- 是否历史审批0否，1是
            ,repulse_reason -- 审批打回原因
            ,audit_date -- 申请日期
            ,need_escort -- 是否需要陪调客户经理
            ,credit_guaranty -- 是否需要担保人
            ,inquiry_way -- 调查方式；1，简单，2，一般，3，复杂
            ,credit_company -- 是否需要上传征信
            ,pledge_type -- 抵押分类
            ,assess_price -- 评估价格
            ,year_rate -- 年利率
            ,resolution -- 信息复合会办决议
            ,remark -- 会办决议备注
            ,custom_capital -- 是否自定义本金
            ,allow_one_sign -- 是否允许单签
            ,loan_proof -- 放款凭证
            ,mark -- 模型标记信息
            ,biz_type -- 业务类型，0主借人1配偶
            ,model_frequency -- 监测周期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_loan_req_audit_op(
            audit_id -- 主键id
            ,loan_id -- 进件id
            ,approver_user_id -- 审批人ID
            ,approver_user_name -- 审批人名字
            ,daily_rate -- 日利率（百分之一）
            ,fnl_store -- 综合授信评分
            ,repayment_period -- 最高返款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
            ,repayment_kind -- 还款方式
            ,auth_money -- 授信金额
            ,rank -- 评级（A-F）
            ,audit_status -- AUDIT_STATUS
            ,history_audit_status -- 是否历史审批0否，1是
            ,repulse_reason -- 审批打回原因
            ,audit_date -- 申请日期
            ,need_escort -- 是否需要陪调客户经理
            ,credit_guaranty -- 是否需要担保人
            ,inquiry_way -- 调查方式；1，简单，2，一般，3，复杂
            ,credit_company -- 是否需要上传征信
            ,pledge_type -- 抵押分类
            ,assess_price -- 评估价格
            ,year_rate -- 年利率
            ,resolution -- 信息复合会办决议
            ,remark -- 会办决议备注
            ,custom_capital -- 是否自定义本金
            ,allow_one_sign -- 是否允许单签
            ,loan_proof -- 放款凭证
            ,mark -- 模型标记信息
            ,biz_type -- 业务类型，0主借人1配偶
            ,model_frequency -- 监测周期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.audit_id -- 主键id
    ,o.loan_id -- 进件id
    ,o.approver_user_id -- 审批人ID
    ,o.approver_user_name -- 审批人名字
    ,o.daily_rate -- 日利率（百分之一）
    ,o.fnl_store -- 综合授信评分
    ,o.repayment_period -- 最高返款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期
    ,o.repayment_kind -- 还款方式
    ,o.auth_money -- 授信金额
    ,o.rank -- 评级（A-F）
    ,o.audit_status -- AUDIT_STATUS
    ,o.history_audit_status -- 是否历史审批0否，1是
    ,o.repulse_reason -- 审批打回原因
    ,o.audit_date -- 申请日期
    ,o.need_escort -- 是否需要陪调客户经理
    ,o.credit_guaranty -- 是否需要担保人
    ,o.inquiry_way -- 调查方式；1，简单，2，一般，3，复杂
    ,o.credit_company -- 是否需要上传征信
    ,o.pledge_type -- 抵押分类
    ,o.assess_price -- 评估价格
    ,o.year_rate -- 年利率
    ,o.resolution -- 信息复合会办决议
    ,o.remark -- 会办决议备注
    ,o.custom_capital -- 是否自定义本金
    ,o.allow_one_sign -- 是否允许单签
    ,o.loan_proof -- 放款凭证
    ,o.mark -- 模型标记信息
    ,o.biz_type -- 业务类型，0主借人1配偶
    ,o.model_frequency -- 监测周期
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
from ${iol_schema}.hgls_loan_req_audit_bk o
    left join ${iol_schema}.hgls_loan_req_audit_op n
        on
            o.audit_id = n.audit_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.hgls_loan_req_audit_cl d
        on
            o.audit_id = d.audit_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.hgls_loan_req_audit;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('hgls_loan_req_audit') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.hgls_loan_req_audit drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.hgls_loan_req_audit add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.hgls_loan_req_audit exchange partition p_${batch_date} with table ${iol_schema}.hgls_loan_req_audit_cl;
alter table ${iol_schema}.hgls_loan_req_audit exchange partition p_20991231 with table ${iol_schema}.hgls_loan_req_audit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.hgls_loan_req_audit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_loan_req_audit_op purge;
drop table ${iol_schema}.hgls_loan_req_audit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.hgls_loan_req_audit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'hgls_loan_req_audit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
