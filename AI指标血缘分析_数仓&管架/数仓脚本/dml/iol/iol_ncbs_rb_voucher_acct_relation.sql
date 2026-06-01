/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_voucher_acct_relation
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
create table ${iol_schema}.ncbs_rb_voucher_acct_relation_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_voucher_acct_relation
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_voucher_acct_relation_op purge;
drop table ${iol_schema}.ncbs_rb_voucher_acct_relation_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_voucher_acct_relation_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_voucher_acct_relation where 0=1;

create table ${iol_schema}.ncbs_rb_voucher_acct_relation_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_voucher_acct_relation where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_voucher_acct_relation_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,remark -- 备注
            ,voucher_no -- 凭证号码
            ,voucher_status -- 凭证状态
            ,collat_ind -- 抵质押标志
            ,collat_no -- 押品编号
            ,company -- 法人
            ,doc_class -- 存款凭证种类
            ,narrative -- 摘要
            ,old_status -- 凭证原状态
            ,prefix -- 前缀
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,can_reason_code -- 作废原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_voucher_acct_relation_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,remark -- 备注
            ,voucher_no -- 凭证号码
            ,voucher_status -- 凭证状态
            ,collat_ind -- 抵质押标志
            ,collat_no -- 押品编号
            ,company -- 法人
            ,doc_class -- 存款凭证种类
            ,narrative -- 摘要
            ,old_status -- 凭证原状态
            ,prefix -- 前缀
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,can_reason_code -- 作废原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.voucher_no, o.voucher_no) as voucher_no -- 凭证号码
    ,nvl(n.voucher_status, o.voucher_status) as voucher_status -- 凭证状态
    ,nvl(n.collat_ind, o.collat_ind) as collat_ind -- 抵质押标志
    ,nvl(n.collat_no, o.collat_no) as collat_no -- 押品编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.doc_class, o.doc_class) as doc_class -- 存款凭证种类
    ,nvl(n.narrative, o.narrative) as narrative -- 摘要
    ,nvl(n.old_status, o.old_status) as old_status -- 凭证原状态
    ,nvl(n.prefix, o.prefix) as prefix -- 前缀
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.can_reason_code, o.can_reason_code) as can_reason_code -- 作废原因
    ,case when
            n.base_acct_no is null
            and n.client_no is null
            and n.doc_type is null
            and n.voucher_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.base_acct_no is null
            and n.client_no is null
            and n.doc_type is null
            and n.voucher_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.base_acct_no is null
            and n.client_no is null
            and n.doc_type is null
            and n.voucher_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_voucher_acct_relation_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_voucher_acct_relation where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.base_acct_no = n.base_acct_no
            and o.client_no = n.client_no
            and o.doc_type = n.doc_type
            and o.voucher_no = n.voucher_no
where (
        o.base_acct_no is null
        and o.client_no is null
        and o.doc_type is null
        and o.voucher_no is null
    )
    or (
        n.base_acct_no is null
        and n.client_no is null
        and n.doc_type is null
        and n.voucher_no is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.card_no <> n.card_no
        or o.prod_type <> n.prod_type
        or o.reference <> n.reference
        or o.remark <> n.remark
        or o.voucher_status <> n.voucher_status
        or o.collat_ind <> n.collat_ind
        or o.collat_no <> n.collat_no
        or o.company <> n.company
        or o.doc_class <> n.doc_class
        or o.narrative <> n.narrative
        or o.old_status <> n.old_status
        or o.prefix <> n.prefix
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.can_reason_code <> n.can_reason_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_voucher_acct_relation_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,remark -- 备注
            ,voucher_no -- 凭证号码
            ,voucher_status -- 凭证状态
            ,collat_ind -- 抵质押标志
            ,collat_no -- 押品编号
            ,company -- 法人
            ,doc_class -- 存款凭证种类
            ,narrative -- 摘要
            ,old_status -- 凭证原状态
            ,prefix -- 前缀
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,can_reason_code -- 作废原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_voucher_acct_relation_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,remark -- 备注
            ,voucher_no -- 凭证号码
            ,voucher_status -- 凭证状态
            ,collat_ind -- 抵质押标志
            ,collat_no -- 押品编号
            ,company -- 法人
            ,doc_class -- 存款凭证种类
            ,narrative -- 摘要
            ,old_status -- 凭证原状态
            ,prefix -- 前缀
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,can_reason_code -- 作废原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.card_no -- 卡号
    ,o.client_no -- 客户编号
    ,o.doc_type -- 凭证类型
    ,o.prod_type -- 产品编号
    ,o.reference -- 交易参考号
    ,o.remark -- 备注
    ,o.voucher_no -- 凭证号码
    ,o.voucher_status -- 凭证状态
    ,o.collat_ind -- 抵质押标志
    ,o.collat_no -- 押品编号
    ,o.company -- 法人
    ,o.doc_class -- 存款凭证种类
    ,o.narrative -- 摘要
    ,o.old_status -- 凭证原状态
    ,o.prefix -- 前缀
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.can_reason_code -- 作废原因
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
from ${iol_schema}.ncbs_rb_voucher_acct_relation_bk o
    left join ${iol_schema}.ncbs_rb_voucher_acct_relation_op n
        on
            o.base_acct_no = n.base_acct_no
            and o.client_no = n.client_no
            and o.doc_type = n.doc_type
            and o.voucher_no = n.voucher_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_voucher_acct_relation_cl d
        on
            o.base_acct_no = d.base_acct_no
            and o.client_no = d.client_no
            and o.doc_type = d.doc_type
            and o.voucher_no = d.voucher_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_voucher_acct_relation;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_voucher_acct_relation') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_voucher_acct_relation drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_voucher_acct_relation add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_voucher_acct_relation exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_voucher_acct_relation_cl;
alter table ${iol_schema}.ncbs_rb_voucher_acct_relation exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_voucher_acct_relation_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_voucher_acct_relation to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_voucher_acct_relation_op purge;
drop table ${iol_schema}.ncbs_rb_voucher_acct_relation_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_voucher_acct_relation_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_voucher_acct_relation',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
