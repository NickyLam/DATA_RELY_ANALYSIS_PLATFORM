/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_blank_sign_info
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
create table ${iol_schema}.ncbs_tb_blank_sign_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_blank_sign_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_blank_sign_info_op purge;
drop table ${iol_schema}.ncbs_tb_blank_sign_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_blank_sign_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_blank_sign_info where 0=1;

create table ${iol_schema}.ncbs_tb_blank_sign_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_blank_sign_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_blank_sign_info_cl(
            client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,voucher_no -- 凭证号码
            ,borrow_id -- 借出序号
            ,borrow_narrative -- 外借备注
            ,borrow_no -- 借出批次
            ,company -- 法人
            ,oper_narrative -- 操作备注
            ,tailbox_id -- 尾箱代号
            ,voucher_prefix -- 凭证前缀
            ,voucher_tran_status -- 凭证交易状态
            ,borrow_date -- 外借日期（借出的外借日期）
            ,oper_date -- 操作日期
            ,tran_timestamp -- 交易时间戳
            ,borrow_branch -- 外借机构（借出时的外借机构）
            ,borrow_user_id -- 外借柜员（借出的外借柜员）
            ,lend_user_id -- 借出柜员
            ,oper_borrow_user_id -- 操作外借柜员
            ,oper_user_id -- 操作柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_blank_sign_info_op(
            client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,voucher_no -- 凭证号码
            ,borrow_id -- 借出序号
            ,borrow_narrative -- 外借备注
            ,borrow_no -- 借出批次
            ,company -- 法人
            ,oper_narrative -- 操作备注
            ,tailbox_id -- 尾箱代号
            ,voucher_prefix -- 凭证前缀
            ,voucher_tran_status -- 凭证交易状态
            ,borrow_date -- 外借日期（借出的外借日期）
            ,oper_date -- 操作日期
            ,tran_timestamp -- 交易时间戳
            ,borrow_branch -- 外借机构（借出时的外借机构）
            ,borrow_user_id -- 外借柜员（借出的外借柜员）
            ,lend_user_id -- 借出柜员
            ,oper_borrow_user_id -- 操作外借柜员
            ,oper_user_id -- 操作柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.voucher_no, o.voucher_no) as voucher_no -- 凭证号码
    ,nvl(n.borrow_id, o.borrow_id) as borrow_id -- 借出序号
    ,nvl(n.borrow_narrative, o.borrow_narrative) as borrow_narrative -- 外借备注
    ,nvl(n.borrow_no, o.borrow_no) as borrow_no -- 借出批次
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.oper_narrative, o.oper_narrative) as oper_narrative -- 操作备注
    ,nvl(n.tailbox_id, o.tailbox_id) as tailbox_id -- 尾箱代号
    ,nvl(n.voucher_prefix, o.voucher_prefix) as voucher_prefix -- 凭证前缀
    ,nvl(n.voucher_tran_status, o.voucher_tran_status) as voucher_tran_status -- 凭证交易状态
    ,nvl(n.borrow_date, o.borrow_date) as borrow_date -- 外借日期（借出的外借日期）
    ,nvl(n.oper_date, o.oper_date) as oper_date -- 操作日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.borrow_branch, o.borrow_branch) as borrow_branch -- 外借机构（借出时的外借机构）
    ,nvl(n.borrow_user_id, o.borrow_user_id) as borrow_user_id -- 外借柜员（借出的外借柜员）
    ,nvl(n.lend_user_id, o.lend_user_id) as lend_user_id -- 借出柜员
    ,nvl(n.oper_borrow_user_id, o.oper_borrow_user_id) as oper_borrow_user_id -- 操作外借柜员
    ,nvl(n.oper_user_id, o.oper_user_id) as oper_user_id -- 操作柜员
    ,case when
            n.borrow_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.borrow_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.borrow_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_blank_sign_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_blank_sign_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.borrow_id = n.borrow_id
where (
        o.borrow_id is null
    )
    or (
        n.borrow_id is null
    )
    or (
        o.client_no <> n.client_no
        or o.doc_type <> n.doc_type
        or o.voucher_no <> n.voucher_no
        or o.borrow_narrative <> n.borrow_narrative
        or o.borrow_no <> n.borrow_no
        or o.company <> n.company
        or o.oper_narrative <> n.oper_narrative
        or o.tailbox_id <> n.tailbox_id
        or o.voucher_prefix <> n.voucher_prefix
        or o.voucher_tran_status <> n.voucher_tran_status
        or o.borrow_date <> n.borrow_date
        or o.oper_date <> n.oper_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.borrow_branch <> n.borrow_branch
        or o.borrow_user_id <> n.borrow_user_id
        or o.lend_user_id <> n.lend_user_id
        or o.oper_borrow_user_id <> n.oper_borrow_user_id
        or o.oper_user_id <> n.oper_user_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_blank_sign_info_cl(
            client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,voucher_no -- 凭证号码
            ,borrow_id -- 借出序号
            ,borrow_narrative -- 外借备注
            ,borrow_no -- 借出批次
            ,company -- 法人
            ,oper_narrative -- 操作备注
            ,tailbox_id -- 尾箱代号
            ,voucher_prefix -- 凭证前缀
            ,voucher_tran_status -- 凭证交易状态
            ,borrow_date -- 外借日期（借出的外借日期）
            ,oper_date -- 操作日期
            ,tran_timestamp -- 交易时间戳
            ,borrow_branch -- 外借机构（借出时的外借机构）
            ,borrow_user_id -- 外借柜员（借出的外借柜员）
            ,lend_user_id -- 借出柜员
            ,oper_borrow_user_id -- 操作外借柜员
            ,oper_user_id -- 操作柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_blank_sign_info_op(
            client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,voucher_no -- 凭证号码
            ,borrow_id -- 借出序号
            ,borrow_narrative -- 外借备注
            ,borrow_no -- 借出批次
            ,company -- 法人
            ,oper_narrative -- 操作备注
            ,tailbox_id -- 尾箱代号
            ,voucher_prefix -- 凭证前缀
            ,voucher_tran_status -- 凭证交易状态
            ,borrow_date -- 外借日期（借出的外借日期）
            ,oper_date -- 操作日期
            ,tran_timestamp -- 交易时间戳
            ,borrow_branch -- 外借机构（借出时的外借机构）
            ,borrow_user_id -- 外借柜员（借出的外借柜员）
            ,lend_user_id -- 借出柜员
            ,oper_borrow_user_id -- 操作外借柜员
            ,oper_user_id -- 操作柜员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.doc_type -- 凭证类型
    ,o.voucher_no -- 凭证号码
    ,o.borrow_id -- 借出序号
    ,o.borrow_narrative -- 外借备注
    ,o.borrow_no -- 借出批次
    ,o.company -- 法人
    ,o.oper_narrative -- 操作备注
    ,o.tailbox_id -- 尾箱代号
    ,o.voucher_prefix -- 凭证前缀
    ,o.voucher_tran_status -- 凭证交易状态
    ,o.borrow_date -- 外借日期（借出的外借日期）
    ,o.oper_date -- 操作日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.borrow_branch -- 外借机构（借出时的外借机构）
    ,o.borrow_user_id -- 外借柜员（借出的外借柜员）
    ,o.lend_user_id -- 借出柜员
    ,o.oper_borrow_user_id -- 操作外借柜员
    ,o.oper_user_id -- 操作柜员
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
from ${iol_schema}.ncbs_tb_blank_sign_info_bk o
    left join ${iol_schema}.ncbs_tb_blank_sign_info_op n
        on
            o.borrow_id = n.borrow_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_blank_sign_info_cl d
        on
            o.borrow_id = d.borrow_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_blank_sign_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_blank_sign_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_blank_sign_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_blank_sign_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_blank_sign_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_blank_sign_info_cl;
alter table ${iol_schema}.ncbs_tb_blank_sign_info exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_blank_sign_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_blank_sign_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_blank_sign_info_op purge;
drop table ${iol_schema}.ncbs_tb_blank_sign_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_blank_sign_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_blank_sign_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
