/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_cash_sign_detail
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
create table ${iol_schema}.ncbs_tb_cash_sign_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_cash_sign_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_cash_sign_detail_op purge;
drop table ${iol_schema}.ncbs_tb_cash_sign_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_sign_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_cash_sign_detail where 0=1;

create table ${iol_schema}.ncbs_tb_cash_sign_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_cash_sign_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_cash_sign_detail_cl(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,file_path -- 文件路径
            ,reference -- 交易参考号
            ,remark -- 备注
            ,cash_sign_type -- 长短款标记
            ,cash_sign_id -- 现金长短款汇总编号
            ,cash_sign_no -- 长短款明细编号
            ,cash_sign_status -- 现金状态
            ,company -- 法人
            ,reason_id -- 长短款原因
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,cash_sign_branch -- 长短款登记机构
            ,cash_sign_user -- 长短款登记柜员
            ,cash_sign_dealed_amt -- 长短款已处理金额
            ,leaderr_cash_branch -- 导致长短钞差错机构
            ,leaderr_user_id -- 导致长短钞差错柜员
            ,leaderr_reference -- 登记导致错误的交易参考号
            ,cash_sign_detail_amt -- 现金长短款挂账明细金额
            ,leaderr_tran_date -- 导致长短款的历史错误交易的交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_cash_sign_detail_op(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,file_path -- 文件路径
            ,reference -- 交易参考号
            ,remark -- 备注
            ,cash_sign_type -- 长短款标记
            ,cash_sign_id -- 现金长短款汇总编号
            ,cash_sign_no -- 长短款明细编号
            ,cash_sign_status -- 现金状态
            ,company -- 法人
            ,reason_id -- 长短款原因
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,cash_sign_branch -- 长短款登记机构
            ,cash_sign_user -- 长短款登记柜员
            ,cash_sign_dealed_amt -- 长短款已处理金额
            ,leaderr_cash_branch -- 导致长短钞差错机构
            ,leaderr_user_id -- 导致长短钞差错柜员
            ,leaderr_reference -- 登记导致错误的交易参考号
            ,cash_sign_detail_amt -- 现金长短款挂账明细金额
            ,leaderr_tran_date -- 导致长短款的历史错误交易的交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.file_path, o.file_path) as file_path -- 文件路径
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.cash_sign_type, o.cash_sign_type) as cash_sign_type -- 长短款标记
    ,nvl(n.cash_sign_id, o.cash_sign_id) as cash_sign_id -- 现金长短款汇总编号
    ,nvl(n.cash_sign_no, o.cash_sign_no) as cash_sign_no -- 长短款明细编号
    ,nvl(n.cash_sign_status, o.cash_sign_status) as cash_sign_status -- 现金状态
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.reason_id, o.reason_id) as reason_id -- 长短款原因
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.cash_sign_branch, o.cash_sign_branch) as cash_sign_branch -- 长短款登记机构
    ,nvl(n.cash_sign_user, o.cash_sign_user) as cash_sign_user -- 长短款登记柜员
    ,nvl(n.cash_sign_dealed_amt, o.cash_sign_dealed_amt) as cash_sign_dealed_amt -- 长短款已处理金额
    ,nvl(n.leaderr_cash_branch, o.leaderr_cash_branch) as leaderr_cash_branch -- 导致长短钞差错机构
    ,nvl(n.leaderr_user_id, o.leaderr_user_id) as leaderr_user_id -- 导致长短钞差错柜员
    ,nvl(n.leaderr_reference, o.leaderr_reference) as leaderr_reference -- 登记导致错误的交易参考号
    ,nvl(n.cash_sign_detail_amt, o.cash_sign_detail_amt) as cash_sign_detail_amt -- 现金长短款挂账明细金额
    ,nvl(n.leaderr_tran_date, o.leaderr_tran_date) as leaderr_tran_date -- 导致长短款的历史错误交易的交易日期
    ,case when
            n.cash_sign_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cash_sign_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cash_sign_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_cash_sign_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_cash_sign_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cash_sign_no = n.cash_sign_no
where (
        o.cash_sign_no is null
    )
    or (
        n.cash_sign_no is null
    )
    or (
        o.base_acct_no <> n.base_acct_no
        or o.ccy <> n.ccy
        or o.client_name <> n.client_name
        or o.file_path <> n.file_path
        or o.reference <> n.reference
        or o.remark <> n.remark
        or o.cash_sign_type <> n.cash_sign_type
        or o.cash_sign_id <> n.cash_sign_id
        or o.cash_sign_status <> n.cash_sign_status
        or o.company <> n.company
        or o.reason_id <> n.reason_id
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.cash_sign_branch <> n.cash_sign_branch
        or o.cash_sign_user <> n.cash_sign_user
        or o.cash_sign_dealed_amt <> n.cash_sign_dealed_amt
        or o.leaderr_cash_branch <> n.leaderr_cash_branch
        or o.leaderr_user_id <> n.leaderr_user_id
        or o.leaderr_reference <> n.leaderr_reference
        or o.cash_sign_detail_amt <> n.cash_sign_detail_amt
        or o.leaderr_tran_date <> n.leaderr_tran_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_cash_sign_detail_cl(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,file_path -- 文件路径
            ,reference -- 交易参考号
            ,remark -- 备注
            ,cash_sign_type -- 长短款标记
            ,cash_sign_id -- 现金长短款汇总编号
            ,cash_sign_no -- 长短款明细编号
            ,cash_sign_status -- 现金状态
            ,company -- 法人
            ,reason_id -- 长短款原因
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,cash_sign_branch -- 长短款登记机构
            ,cash_sign_user -- 长短款登记柜员
            ,cash_sign_dealed_amt -- 长短款已处理金额
            ,leaderr_cash_branch -- 导致长短钞差错机构
            ,leaderr_user_id -- 导致长短钞差错柜员
            ,leaderr_reference -- 登记导致错误的交易参考号
            ,cash_sign_detail_amt -- 现金长短款挂账明细金额
            ,leaderr_tran_date -- 导致长短款的历史错误交易的交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_cash_sign_detail_op(
            base_acct_no -- 交易账号/卡号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,file_path -- 文件路径
            ,reference -- 交易参考号
            ,remark -- 备注
            ,cash_sign_type -- 长短款标记
            ,cash_sign_id -- 现金长短款汇总编号
            ,cash_sign_no -- 长短款明细编号
            ,cash_sign_status -- 现金状态
            ,company -- 法人
            ,reason_id -- 长短款原因
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,cash_sign_branch -- 长短款登记机构
            ,cash_sign_user -- 长短款登记柜员
            ,cash_sign_dealed_amt -- 长短款已处理金额
            ,leaderr_cash_branch -- 导致长短钞差错机构
            ,leaderr_user_id -- 导致长短钞差错柜员
            ,leaderr_reference -- 登记导致错误的交易参考号
            ,cash_sign_detail_amt -- 现金长短款挂账明细金额
            ,leaderr_tran_date -- 导致长短款的历史错误交易的交易日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_acct_no -- 交易账号/卡号
    ,o.ccy -- 币种
    ,o.client_name -- 客户名称
    ,o.file_path -- 文件路径
    ,o.reference -- 交易参考号
    ,o.remark -- 备注
    ,o.cash_sign_type -- 长短款标记
    ,o.cash_sign_id -- 现金长短款汇总编号
    ,o.cash_sign_no -- 长短款明细编号
    ,o.cash_sign_status -- 现金状态
    ,o.company -- 法人
    ,o.reason_id -- 长短款原因
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.cash_sign_branch -- 长短款登记机构
    ,o.cash_sign_user -- 长短款登记柜员
    ,o.cash_sign_dealed_amt -- 长短款已处理金额
    ,o.leaderr_cash_branch -- 导致长短钞差错机构
    ,o.leaderr_user_id -- 导致长短钞差错柜员
    ,o.leaderr_reference -- 登记导致错误的交易参考号
    ,o.cash_sign_detail_amt -- 现金长短款挂账明细金额
    ,o.leaderr_tran_date -- 导致长短款的历史错误交易的交易日期
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
from ${iol_schema}.ncbs_tb_cash_sign_detail_bk o
    left join ${iol_schema}.ncbs_tb_cash_sign_detail_op n
        on
            o.cash_sign_no = n.cash_sign_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_cash_sign_detail_cl d
        on
            o.cash_sign_no = d.cash_sign_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_cash_sign_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_cash_sign_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_cash_sign_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_cash_sign_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_cash_sign_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_cash_sign_detail_cl;
alter table ${iol_schema}.ncbs_tb_cash_sign_detail exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_cash_sign_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_cash_sign_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_cash_sign_detail_op purge;
drop table ${iol_schema}.ncbs_tb_cash_sign_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_cash_sign_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_cash_sign_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
