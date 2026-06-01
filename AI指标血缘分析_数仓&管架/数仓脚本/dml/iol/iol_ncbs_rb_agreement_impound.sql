/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_impound
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
create table ${iol_schema}.ncbs_rb_agreement_impound_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_agreement_impound
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_impound_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_impound_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_impound_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_impound where 0=1;

create table ${iol_schema}.ncbs_rb_agreement_impound_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_impound where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_impound_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,period_freq -- 频率id
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,impound_end_flag -- 是否终止扣划
            ,impound_type -- 扣划类型
            ,law_no -- 法律文书号
            ,narrative -- 摘要
            ,res_seq_no -- 限制编号
            ,total_times -- 扣划总次数
            ,transfer_times -- 已扣划次数
            ,end_date -- 结束日期
            ,next_deal_date -- 下一处理日
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,benefit_base_acct_no -- 受益人账户账号
            ,benefit_prod_type -- 受益人账户产品类型
            ,benenfit_acct_name -- 受益人账户户名
            ,benenfit_ccy -- 受益人币种
            ,benenfit_seq_no -- 受益人账户序号
            ,deduction_judiciary_name -- 有权机关名称
            ,impound_total_amt -- 扣划总金额
            ,judiciary_document_id -- 执法人1证件号码
            ,judiciary_document_type -- 执法人1证件类型
            ,judiciary_officer_name -- 执法人1姓名
            ,judiciary_oth_document_id -- 执法人2证件号码
            ,judiciary_oth_document_type -- 执法人2证件类型
            ,judiciary_oth_officer_name -- 执法人2姓名
            ,total_amt -- 总金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_impound_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,period_freq -- 频率id
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,impound_end_flag -- 是否终止扣划
            ,impound_type -- 扣划类型
            ,law_no -- 法律文书号
            ,narrative -- 摘要
            ,res_seq_no -- 限制编号
            ,total_times -- 扣划总次数
            ,transfer_times -- 已扣划次数
            ,end_date -- 结束日期
            ,next_deal_date -- 下一处理日
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,benefit_base_acct_no -- 受益人账户账号
            ,benefit_prod_type -- 受益人账户产品类型
            ,benenfit_acct_name -- 受益人账户户名
            ,benenfit_ccy -- 受益人币种
            ,benenfit_seq_no -- 受益人账户序号
            ,deduction_judiciary_name -- 有权机关名称
            ,impound_total_amt -- 扣划总金额
            ,judiciary_document_id -- 执法人1证件号码
            ,judiciary_document_type -- 执法人1证件类型
            ,judiciary_officer_name -- 执法人1姓名
            ,judiciary_oth_document_id -- 执法人2证件号码
            ,judiciary_oth_document_type -- 执法人2证件类型
            ,judiciary_oth_officer_name -- 执法人2姓名
            ,total_amt -- 总金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.period_freq, o.period_freq) as period_freq -- 频率id
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.agreement_status, o.agreement_status) as agreement_status -- 协议状态
    ,nvl(n.agreement_type, o.agreement_type) as agreement_type -- 协议类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.impound_end_flag, o.impound_end_flag) as impound_end_flag -- 是否终止扣划
    ,nvl(n.impound_type, o.impound_type) as impound_type -- 扣划类型
    ,nvl(n.law_no, o.law_no) as law_no -- 法律文书号
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.total_times, o.total_times) as total_times -- 扣划总次数
    ,nvl(n.transfer_times, o.transfer_times) as transfer_times -- 已扣划次数
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.next_deal_date, o.next_deal_date) as next_deal_date -- 下一处理日
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.benefit_base_acct_no, o.benefit_base_acct_no) as benefit_base_acct_no -- 受益人账户账号
    ,nvl(n.benefit_prod_type, o.benefit_prod_type) as benefit_prod_type -- 受益人账户产品类型
    ,nvl(n.benenfit_acct_name, o.benenfit_acct_name) as benenfit_acct_name -- 受益人账户户名
    ,nvl(n.benenfit_ccy, o.benenfit_ccy) as benenfit_ccy -- 受益人币种
    ,nvl(n.benenfit_seq_no, o.benenfit_seq_no) as benenfit_seq_no -- 受益人账户序号
    ,nvl(n.deduction_judiciary_name, o.deduction_judiciary_name) as deduction_judiciary_name -- 有权机关名称
    ,nvl(n.impound_total_amt, o.impound_total_amt) as impound_total_amt -- 扣划总金额
    ,nvl(n.judiciary_document_id, o.judiciary_document_id) as judiciary_document_id -- 执法人1证件号码
    ,nvl(n.judiciary_document_type, o.judiciary_document_type) as judiciary_document_type -- 执法人1证件类型
    ,nvl(n.judiciary_officer_name, o.judiciary_officer_name) as judiciary_officer_name -- 执法人1姓名
    ,nvl(n.judiciary_oth_document_id, o.judiciary_oth_document_id) as judiciary_oth_document_id -- 执法人2证件号码
    ,nvl(n.judiciary_oth_document_type, o.judiciary_oth_document_type) as judiciary_oth_document_type -- 执法人2证件类型
    ,nvl(n.judiciary_oth_officer_name, o.judiciary_oth_officer_name) as judiciary_oth_officer_name -- 执法人2姓名
    ,nvl(n.total_amt, o.total_amt) as total_amt -- 总金额
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,case when
            n.internal_key is null
            and n.agreement_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.agreement_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.agreement_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_agreement_impound_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_agreement_impound where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.agreement_id = n.agreement_id
where (
        o.internal_key is null
        and o.agreement_id is null
    )
    or (
        n.internal_key is null
        and n.agreement_id is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.period_freq <> n.period_freq
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.agreement_status <> n.agreement_status
        or o.agreement_type <> n.agreement_type
        or o.company <> n.company
        or o.impound_end_flag <> n.impound_end_flag
        or o.impound_type <> n.impound_type
        or o.law_no <> n.law_no
        or o.narrative <> n.narrative
        or o.res_seq_no <> n.res_seq_no
        or o.total_times <> n.total_times
        or o.transfer_times <> n.transfer_times
        or o.end_date <> n.end_date
        or o.next_deal_date <> n.next_deal_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.auth_user_id <> n.auth_user_id
        or o.benefit_base_acct_no <> n.benefit_base_acct_no
        or o.benefit_prod_type <> n.benefit_prod_type
        or o.benenfit_acct_name <> n.benenfit_acct_name
        or o.benenfit_ccy <> n.benenfit_ccy
        or o.benenfit_seq_no <> n.benenfit_seq_no
        or o.deduction_judiciary_name <> n.deduction_judiciary_name
        or o.impound_total_amt <> n.impound_total_amt
        or o.judiciary_document_id <> n.judiciary_document_id
        or o.judiciary_document_type <> n.judiciary_document_type
        or o.judiciary_officer_name <> n.judiciary_officer_name
        or o.judiciary_oth_document_id <> n.judiciary_oth_document_id
        or o.judiciary_oth_document_type <> n.judiciary_oth_document_type
        or o.judiciary_oth_officer_name <> n.judiciary_oth_officer_name
        or o.total_amt <> n.total_amt
        or o.tran_branch <> n.tran_branch
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_impound_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,period_freq -- 频率id
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,impound_end_flag -- 是否终止扣划
            ,impound_type -- 扣划类型
            ,law_no -- 法律文书号
            ,narrative -- 摘要
            ,res_seq_no -- 限制编号
            ,total_times -- 扣划总次数
            ,transfer_times -- 已扣划次数
            ,end_date -- 结束日期
            ,next_deal_date -- 下一处理日
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,benefit_base_acct_no -- 受益人账户账号
            ,benefit_prod_type -- 受益人账户产品类型
            ,benenfit_acct_name -- 受益人账户户名
            ,benenfit_ccy -- 受益人币种
            ,benenfit_seq_no -- 受益人账户序号
            ,deduction_judiciary_name -- 有权机关名称
            ,impound_total_amt -- 扣划总金额
            ,judiciary_document_id -- 执法人1证件号码
            ,judiciary_document_type -- 执法人1证件类型
            ,judiciary_officer_name -- 执法人1姓名
            ,judiciary_oth_document_id -- 执法人2证件号码
            ,judiciary_oth_document_type -- 执法人2证件类型
            ,judiciary_oth_officer_name -- 执法人2姓名
            ,total_amt -- 总金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_impound_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,period_freq -- 频率id
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,impound_end_flag -- 是否终止扣划
            ,impound_type -- 扣划类型
            ,law_no -- 法律文书号
            ,narrative -- 摘要
            ,res_seq_no -- 限制编号
            ,total_times -- 扣划总次数
            ,transfer_times -- 已扣划次数
            ,end_date -- 结束日期
            ,next_deal_date -- 下一处理日
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,benefit_base_acct_no -- 受益人账户账号
            ,benefit_prod_type -- 受益人账户产品类型
            ,benenfit_acct_name -- 受益人账户户名
            ,benenfit_ccy -- 受益人币种
            ,benenfit_seq_no -- 受益人账户序号
            ,deduction_judiciary_name -- 有权机关名称
            ,impound_total_amt -- 扣划总金额
            ,judiciary_document_id -- 执法人1证件号码
            ,judiciary_document_type -- 执法人1证件类型
            ,judiciary_officer_name -- 执法人1姓名
            ,judiciary_oth_document_id -- 执法人2证件号码
            ,judiciary_oth_document_type -- 执法人2证件类型
            ,judiciary_oth_officer_name -- 执法人2姓名
            ,total_amt -- 总金额
            ,tran_branch -- 核心交易机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.period_freq -- 频率id
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.agreement_id -- 协议编号
    ,o.agreement_status -- 协议状态
    ,o.agreement_type -- 协议类型
    ,o.company -- 法人
    ,o.impound_end_flag -- 是否终止扣划
    ,o.impound_type -- 扣划类型
    ,o.law_no -- 法律文书号
    ,o.narrative -- 摘要
    ,o.res_seq_no -- 限制编号
    ,o.total_times -- 扣划总次数
    ,o.transfer_times -- 已扣划次数
    ,o.end_date -- 结束日期
    ,o.next_deal_date -- 下一处理日
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.auth_user_id -- 授权柜员
    ,o.benefit_base_acct_no -- 受益人账户账号
    ,o.benefit_prod_type -- 受益人账户产品类型
    ,o.benenfit_acct_name -- 受益人账户户名
    ,o.benenfit_ccy -- 受益人币种
    ,o.benenfit_seq_no -- 受益人账户序号
    ,o.deduction_judiciary_name -- 有权机关名称
    ,o.impound_total_amt -- 扣划总金额
    ,o.judiciary_document_id -- 执法人1证件号码
    ,o.judiciary_document_type -- 执法人1证件类型
    ,o.judiciary_officer_name -- 执法人1姓名
    ,o.judiciary_oth_document_id -- 执法人2证件号码
    ,o.judiciary_oth_document_type -- 执法人2证件类型
    ,o.judiciary_oth_officer_name -- 执法人2姓名
    ,o.total_amt -- 总金额
    ,o.tran_branch -- 核心交易机构编号
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
from ${iol_schema}.ncbs_rb_agreement_impound_bk o
    left join ${iol_schema}.ncbs_rb_agreement_impound_op n
        on
            o.internal_key = n.internal_key
            and o.agreement_id = n.agreement_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_agreement_impound_cl d
        on
            o.internal_key = d.internal_key
            and o.agreement_id = d.agreement_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_agreement_impound;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_agreement_impound') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_agreement_impound drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_agreement_impound add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_agreement_impound exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_impound_cl;
alter table ${iol_schema}.ncbs_rb_agreement_impound exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_agreement_impound_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_impound to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_impound_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_impound_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_agreement_impound_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_impound',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
