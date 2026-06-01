/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_deposit_cert_rec
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
create table ${iol_schema}.ncbs_rb_deposit_cert_rec_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_deposit_cert_rec
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_deposit_cert_rec_op purge;
drop table ${iol_schema}.ncbs_rb_deposit_cert_rec_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_deposit_cert_rec_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_deposit_cert_rec where 0=1;

create table ${iol_schema}.ncbs_rb_deposit_cert_rec_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_deposit_cert_rec where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_deposit_cert_rec_cl(
            client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,cert_num -- 证明张数
            ,cert_type -- 存款证明类型
            ,cert_use -- 存款证明用途
            ,ch_head -- 中文抬头
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,deposit_cert_no -- 存款证明编号
            ,deposit_cert_status -- 存款证明状态
            ,en_head -- 英文抬头
            ,prefix -- 前缀
            ,print_cnt -- 打印次数
            ,repair_reason -- 补打原因
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,system_id -- 系统id
            ,cert_end_date -- 证明截止日期
            ,delete_date -- 删除日期
            ,repair_time -- 补打时间
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,cancel_auth_user_id -- 取消授权柜员
            ,cancel_reason -- 撤销原因
            ,cancel_user_id -- 取消柜员
            ,cert_bal -- 证明余额
            ,del_auth_user_id -- 删除授权柜员
            ,del_user_id -- 删除柜员
            ,pre_reference -- 原交易参考号
            ,tran_branch -- 核心交易机构编号
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_deposit_cert_rec_op(
            client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,cert_num -- 证明张数
            ,cert_type -- 存款证明类型
            ,cert_use -- 存款证明用途
            ,ch_head -- 中文抬头
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,deposit_cert_no -- 存款证明编号
            ,deposit_cert_status -- 存款证明状态
            ,en_head -- 英文抬头
            ,prefix -- 前缀
            ,print_cnt -- 打印次数
            ,repair_reason -- 补打原因
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,system_id -- 系统id
            ,cert_end_date -- 证明截止日期
            ,delete_date -- 删除日期
            ,repair_time -- 补打时间
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,cancel_auth_user_id -- 取消授权柜员
            ,cancel_reason -- 撤销原因
            ,cancel_user_id -- 取消柜员
            ,cert_bal -- 证明余额
            ,del_auth_user_id -- 删除授权柜员
            ,del_user_id -- 删除柜员
            ,pre_reference -- 原交易参考号
            ,tran_branch -- 核心交易机构编号
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.term, o.term) as term -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位
    ,nvl(n.cert_num, o.cert_num) as cert_num -- 证明张数
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 存款证明类型
    ,nvl(n.cert_use, o.cert_use) as cert_use -- 存款证明用途
    ,nvl(n.ch_head, o.ch_head) as ch_head -- 中文抬头
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.deposit_cert_no, o.deposit_cert_no) as deposit_cert_no -- 存款证明编号
    ,nvl(n.deposit_cert_status, o.deposit_cert_status) as deposit_cert_status -- 存款证明状态
    ,nvl(n.en_head, o.en_head) as en_head -- 英文抬头
    ,nvl(n.prefix, o.prefix) as prefix -- 前缀
    ,nvl(n.print_cnt, o.print_cnt) as print_cnt -- 打印次数
    ,nvl(n.repair_reason, o.repair_reason) as repair_reason -- 补打原因
    ,nvl(n.res_seq_no, o.res_seq_no) as res_seq_no -- 限制编号
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.system_id, o.system_id) as system_id -- 系统id
    ,nvl(n.cert_end_date, o.cert_end_date) as cert_end_date -- 证明截止日期
    ,nvl(n.delete_date, o.delete_date) as delete_date -- 删除日期
    ,nvl(n.repair_time, o.repair_time) as repair_time -- 补打时间
    ,nvl(n.tran_date, o.tran_date) as tran_date -- 交易日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.cancel_auth_user_id, o.cancel_auth_user_id) as cancel_auth_user_id -- 取消授权柜员
    ,nvl(n.cancel_reason, o.cancel_reason) as cancel_reason -- 撤销原因
    ,nvl(n.cancel_user_id, o.cancel_user_id) as cancel_user_id -- 取消柜员
    ,nvl(n.cert_bal, o.cert_bal) as cert_bal -- 证明余额
    ,nvl(n.del_auth_user_id, o.del_auth_user_id) as del_auth_user_id -- 删除授权柜员
    ,nvl(n.del_user_id, o.del_user_id) as del_user_id -- 删除柜员
    ,nvl(n.pre_reference, o.pre_reference) as pre_reference -- 原交易参考号
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.voucher_end_no, o.voucher_end_no) as voucher_end_no -- 凭证终止号码
    ,nvl(n.voucher_start_no, o.voucher_start_no) as voucher_start_no -- 凭证起始号码
    ,case when
            n.internal_key is null
            and n.deposit_cert_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
            and n.deposit_cert_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
            and n.deposit_cert_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_deposit_cert_rec_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_deposit_cert_rec where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
            and o.deposit_cert_no = n.deposit_cert_no
where (
        o.internal_key is null
        and o.deposit_cert_no is null
    )
    or (
        n.internal_key is null
        and n.deposit_cert_no is null
    )
    or (
        o.client_no <> n.client_no
        or o.doc_type <> n.doc_type
        or o.reference <> n.reference
        or o.user_id <> n.user_id
        or o.term <> n.term
        or o.term_type <> n.term_type
        or o.cert_num <> n.cert_num
        or o.cert_type <> n.cert_type
        or o.cert_use <> n.cert_use
        or o.ch_head <> n.ch_head
        or o.channel_seq_no <> n.channel_seq_no
        or o.company <> n.company
        or o.deposit_cert_status <> n.deposit_cert_status
        or o.en_head <> n.en_head
        or o.prefix <> n.prefix
        or o.print_cnt <> n.print_cnt
        or o.repair_reason <> n.repair_reason
        or o.res_seq_no <> n.res_seq_no
        or o.seq_no <> n.seq_no
        or o.system_id <> n.system_id
        or o.cert_end_date <> n.cert_end_date
        or o.delete_date <> n.delete_date
        or o.repair_time <> n.repair_time
        or o.tran_date <> n.tran_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.auth_user_id <> n.auth_user_id
        or o.cancel_auth_user_id <> n.cancel_auth_user_id
        or o.cancel_reason <> n.cancel_reason
        or o.cancel_user_id <> n.cancel_user_id
        or o.cert_bal <> n.cert_bal
        or o.del_auth_user_id <> n.del_auth_user_id
        or o.del_user_id <> n.del_user_id
        or o.pre_reference <> n.pre_reference
        or o.tran_branch <> n.tran_branch
        or o.voucher_end_no <> n.voucher_end_no
        or o.voucher_start_no <> n.voucher_start_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_deposit_cert_rec_cl(
            client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,cert_num -- 证明张数
            ,cert_type -- 存款证明类型
            ,cert_use -- 存款证明用途
            ,ch_head -- 中文抬头
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,deposit_cert_no -- 存款证明编号
            ,deposit_cert_status -- 存款证明状态
            ,en_head -- 英文抬头
            ,prefix -- 前缀
            ,print_cnt -- 打印次数
            ,repair_reason -- 补打原因
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,system_id -- 系统id
            ,cert_end_date -- 证明截止日期
            ,delete_date -- 删除日期
            ,repair_time -- 补打时间
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,cancel_auth_user_id -- 取消授权柜员
            ,cancel_reason -- 撤销原因
            ,cancel_user_id -- 取消柜员
            ,cert_bal -- 证明余额
            ,del_auth_user_id -- 删除授权柜员
            ,del_user_id -- 删除柜员
            ,pre_reference -- 原交易参考号
            ,tran_branch -- 核心交易机构编号
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_deposit_cert_rec_op(
            client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,internal_key -- 账户内部键值
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,cert_num -- 证明张数
            ,cert_type -- 存款证明类型
            ,cert_use -- 存款证明用途
            ,ch_head -- 中文抬头
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,deposit_cert_no -- 存款证明编号
            ,deposit_cert_status -- 存款证明状态
            ,en_head -- 英文抬头
            ,prefix -- 前缀
            ,print_cnt -- 打印次数
            ,repair_reason -- 补打原因
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,system_id -- 系统id
            ,cert_end_date -- 证明截止日期
            ,delete_date -- 删除日期
            ,repair_time -- 补打时间
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,auth_user_id -- 授权柜员
            ,cancel_auth_user_id -- 取消授权柜员
            ,cancel_reason -- 撤销原因
            ,cancel_user_id -- 取消柜员
            ,cert_bal -- 证明余额
            ,del_auth_user_id -- 删除授权柜员
            ,del_user_id -- 删除柜员
            ,pre_reference -- 原交易参考号
            ,tran_branch -- 核心交易机构编号
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.doc_type -- 凭证类型
    ,o.internal_key -- 账户内部键值
    ,o.reference -- 交易参考号
    ,o.user_id -- 交易柜员编号
    ,o.term -- 存期
    ,o.term_type -- 期限单位
    ,o.cert_num -- 证明张数
    ,o.cert_type -- 存款证明类型
    ,o.cert_use -- 存款证明用途
    ,o.ch_head -- 中文抬头
    ,o.channel_seq_no -- 全局流水号
    ,o.company -- 法人
    ,o.deposit_cert_no -- 存款证明编号
    ,o.deposit_cert_status -- 存款证明状态
    ,o.en_head -- 英文抬头
    ,o.prefix -- 前缀
    ,o.print_cnt -- 打印次数
    ,o.repair_reason -- 补打原因
    ,o.res_seq_no -- 限制编号
    ,o.seq_no -- 序号
    ,o.system_id -- 系统id
    ,o.cert_end_date -- 证明截止日期
    ,o.delete_date -- 删除日期
    ,o.repair_time -- 补打时间
    ,o.tran_date -- 交易日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.auth_user_id -- 授权柜员
    ,o.cancel_auth_user_id -- 取消授权柜员
    ,o.cancel_reason -- 撤销原因
    ,o.cancel_user_id -- 取消柜员
    ,o.cert_bal -- 证明余额
    ,o.del_auth_user_id -- 删除授权柜员
    ,o.del_user_id -- 删除柜员
    ,o.pre_reference -- 原交易参考号
    ,o.tran_branch -- 核心交易机构编号
    ,o.voucher_end_no -- 凭证终止号码
    ,o.voucher_start_no -- 凭证起始号码
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
from ${iol_schema}.ncbs_rb_deposit_cert_rec_bk o
    left join ${iol_schema}.ncbs_rb_deposit_cert_rec_op n
        on
            o.internal_key = n.internal_key
            and o.deposit_cert_no = n.deposit_cert_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_deposit_cert_rec_cl d
        on
            o.internal_key = d.internal_key
            and o.deposit_cert_no = d.deposit_cert_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_deposit_cert_rec;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_deposit_cert_rec') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_deposit_cert_rec drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_deposit_cert_rec add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_deposit_cert_rec exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_deposit_cert_rec_cl;
alter table ${iol_schema}.ncbs_rb_deposit_cert_rec exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_deposit_cert_rec_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_deposit_cert_rec to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_deposit_cert_rec_op purge;
drop table ${iol_schema}.ncbs_rb_deposit_cert_rec_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_deposit_cert_rec_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_deposit_cert_rec',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
