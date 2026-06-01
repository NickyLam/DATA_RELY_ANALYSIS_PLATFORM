/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_base_acct
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
create table ${iol_schema}.ncbs_rb_base_acct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_base_acct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_base_acct_op purge;
drop table ${iol_schema}.ncbs_rb_base_acct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_base_acct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_base_acct where 0=1;

create table ${iol_schema}.ncbs_rb_base_acct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_base_acct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_base_acct_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,voucher_status -- 凭证状态
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_res_status -- 账户限制标志
            ,acct_status_prev -- 账户上一状态
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,checked_flag -- 黑名单是否已检查标志位
            ,company -- 法人
            ,prefix -- 前缀
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,terminal_id -- 交易终端编号
            ,fixed_call -- 定期账户细类
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,alt_acct_name -- 备用账户名称
            ,last_change_user_id -- 最后修改柜员
            ,old_prod_type -- 原产品类型
            ,voucher_start_no -- 凭证起始号码
            ,acct_close_date -- 销户日期
            ,reason_code -- 账户用途
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_base_acct_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,voucher_status -- 凭证状态
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_res_status -- 账户限制标志
            ,acct_status_prev -- 账户上一状态
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,checked_flag -- 黑名单是否已检查标志位
            ,company -- 法人
            ,prefix -- 前缀
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,terminal_id -- 交易终端编号
            ,fixed_call -- 定期账户细类
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,alt_acct_name -- 备用账户名称
            ,last_change_user_id -- 最后修改柜员
            ,old_prod_type -- 原产品类型
            ,voucher_start_no -- 凭证起始号码
            ,acct_close_date -- 销户日期
            ,reason_code -- 账户用途
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.acct_status, o.acct_status) as acct_status -- 账户状态
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型
    ,nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.voucher_status, o.voucher_status) as voucher_status -- 凭证状态
    ,nvl(n.acct_desc, o.acct_desc) as acct_desc -- 账户描述
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理编号
    ,nvl(n.acct_res_status, o.acct_res_status) as acct_res_status -- 账户限制标志
    ,nvl(n.acct_status_prev, o.acct_status_prev) as acct_status_prev -- 账户上一状态
    ,nvl(n.all_dep_ind, o.all_dep_ind) as all_dep_ind -- 通存标志
    ,nvl(n.all_dra_ind, o.all_dra_ind) as all_dra_ind -- 通兑标志
    ,nvl(n.checked_flag, o.checked_flag) as checked_flag -- 黑名单是否已检查标志位
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.prefix, o.prefix) as prefix -- 前缀
    ,nvl(n.source_module, o.source_module) as source_module -- 源模块
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.terminal_id, o.terminal_id) as terminal_id -- 交易终端编号
    ,nvl(n.fixed_call, o.fixed_call) as fixed_call -- 定期账户细类
    ,nvl(n.acct_open_date, o.acct_open_date) as acct_open_date -- 账户开户日期
    ,nvl(n.acct_status_upd_date, o.acct_status_upd_date) as acct_status_upd_date -- 账户状态变更日期
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.iss_country, o.iss_country) as iss_country -- 发证国家
    ,nvl(n.acct_branch, o.acct_branch) as acct_branch -- 开户机构编号
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.acct_close_reason, o.acct_close_reason) as acct_close_reason -- 关闭原因
    ,nvl(n.acct_close_user_id, o.acct_close_user_id) as acct_close_user_id -- 账户销户操作柜员
    ,nvl(n.alt_acct_name, o.alt_acct_name) as alt_acct_name -- 备用账户名称
    ,nvl(n.last_change_user_id, o.last_change_user_id) as last_change_user_id -- 最后修改柜员
    ,nvl(n.old_prod_type, o.old_prod_type) as old_prod_type -- 原产品类型
    ,nvl(n.voucher_start_no, o.voucher_start_no) as voucher_start_no -- 凭证起始号码
    ,nvl(n.acct_close_date, o.acct_close_date) as acct_close_date -- 销户日期
    ,nvl(n.reason_code, o.reason_code) as reason_code -- 账户用途
    ,case when
            n.client_no is null
            and n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.client_no is null
            and n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.client_no is null
            and n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_base_acct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_base_acct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.client_no = n.client_no
            and o.internal_key = n.internal_key
where (
        o.client_no is null
        and o.internal_key is null
    )
    or (
        n.client_no is null
        and n.internal_key is null
    )
    or (
        o.acct_name <> n.acct_name
        or o.acct_seq_no <> n.acct_seq_no
        or o.acct_status <> n.acct_status
        or o.acct_type <> n.acct_type
        or o.base_acct_no <> n.base_acct_no
        or o.card_no <> n.card_no
        or o.client_type <> n.client_type
        or o.doc_type <> n.doc_type
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.prod_type <> n.prod_type
        or o.user_id <> n.user_id
        or o.voucher_status <> n.voucher_status
        or o.acct_desc <> n.acct_desc
        or o.acct_exec <> n.acct_exec
        or o.acct_res_status <> n.acct_res_status
        or o.acct_status_prev <> n.acct_status_prev
        or o.all_dep_ind <> n.all_dep_ind
        or o.all_dra_ind <> n.all_dra_ind
        or o.checked_flag <> n.checked_flag
        or o.company <> n.company
        or o.prefix <> n.prefix
        or o.source_module <> n.source_module
        or o.source_type <> n.source_type
        or o.terminal_id <> n.terminal_id
        or o.fixed_call <> n.fixed_call
        or o.acct_open_date <> n.acct_open_date
        or o.acct_status_upd_date <> n.acct_status_upd_date
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.iss_country <> n.iss_country
        or o.acct_branch <> n.acct_branch
        or o.acct_ccy <> n.acct_ccy
        or o.acct_close_reason <> n.acct_close_reason
        or o.acct_close_user_id <> n.acct_close_user_id
        or o.alt_acct_name <> n.alt_acct_name
        or o.last_change_user_id <> n.last_change_user_id
        or o.old_prod_type <> n.old_prod_type
        or o.voucher_start_no <> n.voucher_start_no
        or o.acct_close_date <> n.acct_close_date
        or o.reason_code <> n.reason_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_base_acct_cl(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,voucher_status -- 凭证状态
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_res_status -- 账户限制标志
            ,acct_status_prev -- 账户上一状态
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,checked_flag -- 黑名单是否已检查标志位
            ,company -- 法人
            ,prefix -- 前缀
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,terminal_id -- 交易终端编号
            ,fixed_call -- 定期账户细类
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,alt_acct_name -- 备用账户名称
            ,last_change_user_id -- 最后修改柜员
            ,old_prod_type -- 原产品类型
            ,voucher_start_no -- 凭证起始号码
            ,acct_close_date -- 销户日期
            ,reason_code -- 账户用途
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_base_acct_op(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,voucher_status -- 凭证状态
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_res_status -- 账户限制标志
            ,acct_status_prev -- 账户上一状态
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,checked_flag -- 黑名单是否已检查标志位
            ,company -- 法人
            ,prefix -- 前缀
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,terminal_id -- 交易终端编号
            ,fixed_call -- 定期账户细类
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,alt_acct_name -- 备用账户名称
            ,last_change_user_id -- 最后修改柜员
            ,old_prod_type -- 原产品类型
            ,voucher_start_no -- 凭证起始号码
            ,acct_close_date -- 销户日期
            ,reason_code -- 账户用途
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_name -- 账户名称
    ,o.acct_seq_no -- 账户子账号
    ,o.acct_status -- 账户状态
    ,o.acct_type -- 账户类型
    ,o.base_acct_no -- 交易账号/卡号
    ,o.card_no -- 卡号
    ,o.client_no -- 客户编号
    ,o.client_type -- 客户类型
    ,o.doc_type -- 凭证类型
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.user_id -- 交易柜员编号
    ,o.voucher_status -- 凭证状态
    ,o.acct_desc -- 账户描述
    ,o.acct_exec -- 银行客户经理编号
    ,o.acct_res_status -- 账户限制标志
    ,o.acct_status_prev -- 账户上一状态
    ,o.all_dep_ind -- 通存标志
    ,o.all_dra_ind -- 通兑标志
    ,o.checked_flag -- 黑名单是否已检查标志位
    ,o.company -- 法人
    ,o.prefix -- 前缀
    ,o.source_module -- 源模块
    ,o.source_type -- 渠道编号
    ,o.terminal_id -- 交易终端编号
    ,o.fixed_call -- 定期账户细类
    ,o.acct_open_date -- 账户开户日期
    ,o.acct_status_upd_date -- 账户状态变更日期
    ,o.last_change_date -- 最后修改日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.iss_country -- 发证国家
    ,o.acct_branch -- 开户机构编号
    ,o.acct_ccy -- 账户币种
    ,o.acct_close_reason -- 关闭原因
    ,o.acct_close_user_id -- 账户销户操作柜员
    ,o.alt_acct_name -- 备用账户名称
    ,o.last_change_user_id -- 最后修改柜员
    ,o.old_prod_type -- 原产品类型
    ,o.voucher_start_no -- 凭证起始号码
    ,o.acct_close_date -- 销户日期
    ,o.reason_code -- 账户用途
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
from ${iol_schema}.ncbs_rb_base_acct_bk o
    left join ${iol_schema}.ncbs_rb_base_acct_op n
        on
            o.client_no = n.client_no
            and o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_base_acct_cl d
        on
            o.client_no = d.client_no
            and o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_base_acct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_base_acct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_base_acct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_base_acct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_base_acct exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_base_acct_cl;
alter table ${iol_schema}.ncbs_rb_base_acct exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_base_acct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_base_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_base_acct_op purge;
drop table ${iol_schema}.ncbs_rb_base_acct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_base_acct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_base_acct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
