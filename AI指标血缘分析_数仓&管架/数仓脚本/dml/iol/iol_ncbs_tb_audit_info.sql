/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_audit_info
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
create table ${iol_schema}.ncbs_tb_audit_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_audit_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_audit_info_op purge;
drop table ${iol_schema}.ncbs_tb_audit_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_audit_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_audit_info where 0=1;

create table ${iol_schema}.ncbs_tb_audit_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_audit_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_audit_info_cl(
            voucher_tailbox_id -- 凭证尾箱编号
            ,client_no -- 客户编号
            ,remark -- 备注
            ,audit_id -- 查库编号
            ,cash_check_result -- 现金检查结果
            ,cash_tailbox_id -- 现金尾箱
            ,check_user_post -- 检查人职务
            ,company -- 法人
            ,custody_product_check_result -- 代保管品检查结果
            ,fake_money_check_result -- 假币检查结果
            ,item_check_result -- 重要物品检查结果
            ,main_check_user_post -- 主检查人职务
            ,total_cash_check_result -- 现金汇总检查结果
            ,voucher_check_result -- 凭证检查结果
            ,audit_date -- 审计日期
            ,audit_timestamp -- 审计时间
            ,tran_timestamp -- 交易时间戳
            ,censored_branch -- 被查人机构
            ,censored_user_id -- 被查人
            ,check_user_name -- 检查人姓名
            ,check_user_org -- 检查人机构
            ,current_user_id -- 当前操作柜员
            ,main_check_user_name -- 主检查人姓名
            ,main_check_user_org -- 主检查人机构
            ,assistant_user_id2 -- 协查人2
            ,check_user_id1 -- 检查人1
            ,audit_check_type -- 查库类型
            ,assistant_user_id1 -- 协查人1
            ,check_user_id2 -- 检查人2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_audit_info_op(
            voucher_tailbox_id -- 凭证尾箱编号
            ,client_no -- 客户编号
            ,remark -- 备注
            ,audit_id -- 查库编号
            ,cash_check_result -- 现金检查结果
            ,cash_tailbox_id -- 现金尾箱
            ,check_user_post -- 检查人职务
            ,company -- 法人
            ,custody_product_check_result -- 代保管品检查结果
            ,fake_money_check_result -- 假币检查结果
            ,item_check_result -- 重要物品检查结果
            ,main_check_user_post -- 主检查人职务
            ,total_cash_check_result -- 现金汇总检查结果
            ,voucher_check_result -- 凭证检查结果
            ,audit_date -- 审计日期
            ,audit_timestamp -- 审计时间
            ,tran_timestamp -- 交易时间戳
            ,censored_branch -- 被查人机构
            ,censored_user_id -- 被查人
            ,check_user_name -- 检查人姓名
            ,check_user_org -- 检查人机构
            ,current_user_id -- 当前操作柜员
            ,main_check_user_name -- 主检查人姓名
            ,main_check_user_org -- 主检查人机构
            ,assistant_user_id2 -- 协查人2
            ,check_user_id1 -- 检查人1
            ,audit_check_type -- 查库类型
            ,assistant_user_id1 -- 协查人1
            ,check_user_id2 -- 检查人2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.voucher_tailbox_id, o.voucher_tailbox_id) as voucher_tailbox_id -- 凭证尾箱编号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.audit_id, o.audit_id) as audit_id -- 查库编号
    ,nvl(n.cash_check_result, o.cash_check_result) as cash_check_result -- 现金检查结果
    ,nvl(n.cash_tailbox_id, o.cash_tailbox_id) as cash_tailbox_id -- 现金尾箱
    ,nvl(n.check_user_post, o.check_user_post) as check_user_post -- 检查人职务
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.custody_product_check_result, o.custody_product_check_result) as custody_product_check_result -- 代保管品检查结果
    ,nvl(n.fake_money_check_result, o.fake_money_check_result) as fake_money_check_result -- 假币检查结果
    ,nvl(n.item_check_result, o.item_check_result) as item_check_result -- 重要物品检查结果
    ,nvl(n.main_check_user_post, o.main_check_user_post) as main_check_user_post -- 主检查人职务
    ,nvl(n.total_cash_check_result, o.total_cash_check_result) as total_cash_check_result -- 现金汇总检查结果
    ,nvl(n.voucher_check_result, o.voucher_check_result) as voucher_check_result -- 凭证检查结果
    ,nvl(n.audit_date, o.audit_date) as audit_date -- 审计日期
    ,nvl(n.audit_timestamp, o.audit_timestamp) as audit_timestamp -- 审计时间
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.censored_branch, o.censored_branch) as censored_branch -- 被查人机构
    ,nvl(n.censored_user_id, o.censored_user_id) as censored_user_id -- 被查人
    ,nvl(n.check_user_name, o.check_user_name) as check_user_name -- 检查人姓名
    ,nvl(n.check_user_org, o.check_user_org) as check_user_org -- 检查人机构
    ,nvl(n.current_user_id, o.current_user_id) as current_user_id -- 当前操作柜员
    ,nvl(n.main_check_user_name, o.main_check_user_name) as main_check_user_name -- 主检查人姓名
    ,nvl(n.main_check_user_org, o.main_check_user_org) as main_check_user_org -- 主检查人机构
    ,nvl(n.assistant_user_id2, o.assistant_user_id2) as assistant_user_id2 -- 协查人2
    ,nvl(n.check_user_id1, o.check_user_id1) as check_user_id1 -- 检查人1
    ,nvl(n.audit_check_type, o.audit_check_type) as audit_check_type -- 查库类型
    ,nvl(n.assistant_user_id1, o.assistant_user_id1) as assistant_user_id1 -- 协查人1
    ,nvl(n.check_user_id2, o.check_user_id2) as check_user_id2 -- 检查人2
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
from (select * from ${iol_schema}.ncbs_tb_audit_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_audit_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.audit_id = n.audit_id
where (
        o.audit_id is null
    )
    or (
        n.audit_id is null
    )
    or (
        o.voucher_tailbox_id <> n.voucher_tailbox_id
        or o.client_no <> n.client_no
        or o.remark <> n.remark
        or o.cash_check_result <> n.cash_check_result
        or o.cash_tailbox_id <> n.cash_tailbox_id
        or o.check_user_post <> n.check_user_post
        or o.company <> n.company
        or o.custody_product_check_result <> n.custody_product_check_result
        or o.fake_money_check_result <> n.fake_money_check_result
        or o.item_check_result <> n.item_check_result
        or o.main_check_user_post <> n.main_check_user_post
        or o.total_cash_check_result <> n.total_cash_check_result
        or o.voucher_check_result <> n.voucher_check_result
        or o.audit_date <> n.audit_date
        or o.audit_timestamp <> n.audit_timestamp
        or o.tran_timestamp <> n.tran_timestamp
        or o.censored_branch <> n.censored_branch
        or o.censored_user_id <> n.censored_user_id
        or o.check_user_name <> n.check_user_name
        or o.check_user_org <> n.check_user_org
        or o.current_user_id <> n.current_user_id
        or o.main_check_user_name <> n.main_check_user_name
        or o.main_check_user_org <> n.main_check_user_org
        or o.assistant_user_id2 <> n.assistant_user_id2
        or o.check_user_id1 <> n.check_user_id1
        or o.audit_check_type <> n.audit_check_type
        or o.assistant_user_id1 <> n.assistant_user_id1
        or o.check_user_id2 <> n.check_user_id2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_audit_info_cl(
            voucher_tailbox_id -- 凭证尾箱编号
            ,client_no -- 客户编号
            ,remark -- 备注
            ,audit_id -- 查库编号
            ,cash_check_result -- 现金检查结果
            ,cash_tailbox_id -- 现金尾箱
            ,check_user_post -- 检查人职务
            ,company -- 法人
            ,custody_product_check_result -- 代保管品检查结果
            ,fake_money_check_result -- 假币检查结果
            ,item_check_result -- 重要物品检查结果
            ,main_check_user_post -- 主检查人职务
            ,total_cash_check_result -- 现金汇总检查结果
            ,voucher_check_result -- 凭证检查结果
            ,audit_date -- 审计日期
            ,audit_timestamp -- 审计时间
            ,tran_timestamp -- 交易时间戳
            ,censored_branch -- 被查人机构
            ,censored_user_id -- 被查人
            ,check_user_name -- 检查人姓名
            ,check_user_org -- 检查人机构
            ,current_user_id -- 当前操作柜员
            ,main_check_user_name -- 主检查人姓名
            ,main_check_user_org -- 主检查人机构
            ,assistant_user_id2 -- 协查人2
            ,check_user_id1 -- 检查人1
            ,audit_check_type -- 查库类型
            ,assistant_user_id1 -- 协查人1
            ,check_user_id2 -- 检查人2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_audit_info_op(
            voucher_tailbox_id -- 凭证尾箱编号
            ,client_no -- 客户编号
            ,remark -- 备注
            ,audit_id -- 查库编号
            ,cash_check_result -- 现金检查结果
            ,cash_tailbox_id -- 现金尾箱
            ,check_user_post -- 检查人职务
            ,company -- 法人
            ,custody_product_check_result -- 代保管品检查结果
            ,fake_money_check_result -- 假币检查结果
            ,item_check_result -- 重要物品检查结果
            ,main_check_user_post -- 主检查人职务
            ,total_cash_check_result -- 现金汇总检查结果
            ,voucher_check_result -- 凭证检查结果
            ,audit_date -- 审计日期
            ,audit_timestamp -- 审计时间
            ,tran_timestamp -- 交易时间戳
            ,censored_branch -- 被查人机构
            ,censored_user_id -- 被查人
            ,check_user_name -- 检查人姓名
            ,check_user_org -- 检查人机构
            ,current_user_id -- 当前操作柜员
            ,main_check_user_name -- 主检查人姓名
            ,main_check_user_org -- 主检查人机构
            ,assistant_user_id2 -- 协查人2
            ,check_user_id1 -- 检查人1
            ,audit_check_type -- 查库类型
            ,assistant_user_id1 -- 协查人1
            ,check_user_id2 -- 检查人2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.voucher_tailbox_id -- 凭证尾箱编号
    ,o.client_no -- 客户编号
    ,o.remark -- 备注
    ,o.audit_id -- 查库编号
    ,o.cash_check_result -- 现金检查结果
    ,o.cash_tailbox_id -- 现金尾箱
    ,o.check_user_post -- 检查人职务
    ,o.company -- 法人
    ,o.custody_product_check_result -- 代保管品检查结果
    ,o.fake_money_check_result -- 假币检查结果
    ,o.item_check_result -- 重要物品检查结果
    ,o.main_check_user_post -- 主检查人职务
    ,o.total_cash_check_result -- 现金汇总检查结果
    ,o.voucher_check_result -- 凭证检查结果
    ,o.audit_date -- 审计日期
    ,o.audit_timestamp -- 审计时间
    ,o.tran_timestamp -- 交易时间戳
    ,o.censored_branch -- 被查人机构
    ,o.censored_user_id -- 被查人
    ,o.check_user_name -- 检查人姓名
    ,o.check_user_org -- 检查人机构
    ,o.current_user_id -- 当前操作柜员
    ,o.main_check_user_name -- 主检查人姓名
    ,o.main_check_user_org -- 主检查人机构
    ,o.assistant_user_id2 -- 协查人2
    ,o.check_user_id1 -- 检查人1
    ,o.audit_check_type -- 查库类型
    ,o.assistant_user_id1 -- 协查人1
    ,o.check_user_id2 -- 检查人2
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
from ${iol_schema}.ncbs_tb_audit_info_bk o
    left join ${iol_schema}.ncbs_tb_audit_info_op n
        on
            o.audit_id = n.audit_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_audit_info_cl d
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
--truncate table ${iol_schema}.ncbs_tb_audit_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_audit_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_audit_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_audit_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_audit_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_audit_info_cl;
alter table ${iol_schema}.ncbs_tb_audit_info exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_audit_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_audit_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_audit_info_op purge;
drop table ${iol_schema}.ncbs_tb_audit_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_audit_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_audit_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
