/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_ic_ec_settle_reg
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
create table ${iol_schema}.ncbs_ic_ec_settle_reg_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_ic_ec_settle_reg
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_ic_ec_settle_reg_op purge;
drop table ${iol_schema}.ncbs_ic_ec_settle_reg_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_ic_ec_settle_reg_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_ic_ec_settle_reg where 0=1;

create table ${iol_schema}.ncbs_ic_ec_settle_reg_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_ic_ec_settle_reg where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_ic_ec_settle_reg_cl(
            setl_seq_no -- 结清序号
            ,glob_seq_num -- 全局流水号
            ,sys_seq_num -- 系统流水号
            ,biz_seq_num -- 业务流水号
            ,setl_dt -- 结清日期
            ,branch -- 机构编号
            ,card_no -- 卡号
            ,ic_card_seq -- 卡序列号
            ,tran_amt -- 交易金额
            ,client_name -- 客户名称
            ,document_type -- 客户证件类型
            ,document_id -- 客户证件号码
            ,commission_client_name -- 代办人姓名
            ,commission_document_type -- 代办人证件类型
            ,commission_document_id -- 代办人证件号码
            ,cash_tfr_flg -- 现转标志: 0-现金;1-转账
            ,oth_base_acct_no -- 交易对手账号
            ,setl_reason -- 结清原因: 0-正常结清;1-损坏结清;2-挂失结清
            ,remark -- 附加备注
            ,begin_time -- 批处理起始时间
            ,rel_setl_dt -- 实际结清日期
            ,reference -- 交易参考号
            ,setl_status -- 结清状态: 0-待结清;1-处理中;2-已结清
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_ic_ec_settle_reg_op(
            setl_seq_no -- 结清序号
            ,glob_seq_num -- 全局流水号
            ,sys_seq_num -- 系统流水号
            ,biz_seq_num -- 业务流水号
            ,setl_dt -- 结清日期
            ,branch -- 机构编号
            ,card_no -- 卡号
            ,ic_card_seq -- 卡序列号
            ,tran_amt -- 交易金额
            ,client_name -- 客户名称
            ,document_type -- 客户证件类型
            ,document_id -- 客户证件号码
            ,commission_client_name -- 代办人姓名
            ,commission_document_type -- 代办人证件类型
            ,commission_document_id -- 代办人证件号码
            ,cash_tfr_flg -- 现转标志: 0-现金;1-转账
            ,oth_base_acct_no -- 交易对手账号
            ,setl_reason -- 结清原因: 0-正常结清;1-损坏结清;2-挂失结清
            ,remark -- 附加备注
            ,begin_time -- 批处理起始时间
            ,rel_setl_dt -- 实际结清日期
            ,reference -- 交易参考号
            ,setl_status -- 结清状态: 0-待结清;1-处理中;2-已结清
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.setl_seq_no, o.setl_seq_no) as setl_seq_no -- 结清序号
    ,nvl(n.glob_seq_num, o.glob_seq_num) as glob_seq_num -- 全局流水号
    ,nvl(n.sys_seq_num, o.sys_seq_num) as sys_seq_num -- 系统流水号
    ,nvl(n.biz_seq_num, o.biz_seq_num) as biz_seq_num -- 业务流水号
    ,nvl(n.setl_dt, o.setl_dt) as setl_dt -- 结清日期
    ,nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.ic_card_seq, o.ic_card_seq) as ic_card_seq -- 卡序列号
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.document_id, o.document_id) as document_id -- 客户证件号码
    ,nvl(n.commission_client_name, o.commission_client_name) as commission_client_name -- 代办人姓名
    ,nvl(n.commission_document_type, o.commission_document_type) as commission_document_type -- 代办人证件类型
    ,nvl(n.commission_document_id, o.commission_document_id) as commission_document_id -- 代办人证件号码
    ,nvl(n.cash_tfr_flg, o.cash_tfr_flg) as cash_tfr_flg -- 现转标志: 0-现金;1-转账
    ,nvl(n.oth_base_acct_no, o.oth_base_acct_no) as oth_base_acct_no -- 交易对手账号
    ,nvl(n.setl_reason, o.setl_reason) as setl_reason -- 结清原因: 0-正常结清;1-损坏结清;2-挂失结清
    ,nvl(n.remark, o.remark) as remark -- 附加备注
    ,nvl(n.begin_time, o.begin_time) as begin_time -- 批处理起始时间
    ,nvl(n.rel_setl_dt, o.rel_setl_dt) as rel_setl_dt -- 实际结清日期
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.setl_status, o.setl_status) as setl_status -- 结清状态: 0-待结清;1-处理中;2-已结清
    ,case when
            n.setl_seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.setl_seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.setl_seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_ic_ec_settle_reg_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_ic_ec_settle_reg where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.setl_seq_no = n.setl_seq_no
where (
        o.setl_seq_no is null
    )
    or (
        n.setl_seq_no is null
    )
    or (
        o.glob_seq_num <> n.glob_seq_num
        or o.sys_seq_num <> n.sys_seq_num
        or o.biz_seq_num <> n.biz_seq_num
        or o.setl_dt <> n.setl_dt
        or o.branch <> n.branch
        or o.card_no <> n.card_no
        or o.ic_card_seq <> n.ic_card_seq
        or o.tran_amt <> n.tran_amt
        or o.client_name <> n.client_name
        or o.document_type <> n.document_type
        or o.document_id <> n.document_id
        or o.commission_client_name <> n.commission_client_name
        or o.commission_document_type <> n.commission_document_type
        or o.commission_document_id <> n.commission_document_id
        or o.cash_tfr_flg <> n.cash_tfr_flg
        or o.oth_base_acct_no <> n.oth_base_acct_no
        or o.setl_reason <> n.setl_reason
        or o.remark <> n.remark
        or o.begin_time <> n.begin_time
        or o.rel_setl_dt <> n.rel_setl_dt
        or o.reference <> n.reference
        or o.setl_status <> n.setl_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_ic_ec_settle_reg_cl(
            setl_seq_no -- 结清序号
            ,glob_seq_num -- 全局流水号
            ,sys_seq_num -- 系统流水号
            ,biz_seq_num -- 业务流水号
            ,setl_dt -- 结清日期
            ,branch -- 机构编号
            ,card_no -- 卡号
            ,ic_card_seq -- 卡序列号
            ,tran_amt -- 交易金额
            ,client_name -- 客户名称
            ,document_type -- 客户证件类型
            ,document_id -- 客户证件号码
            ,commission_client_name -- 代办人姓名
            ,commission_document_type -- 代办人证件类型
            ,commission_document_id -- 代办人证件号码
            ,cash_tfr_flg -- 现转标志: 0-现金;1-转账
            ,oth_base_acct_no -- 交易对手账号
            ,setl_reason -- 结清原因: 0-正常结清;1-损坏结清;2-挂失结清
            ,remark -- 附加备注
            ,begin_time -- 批处理起始时间
            ,rel_setl_dt -- 实际结清日期
            ,reference -- 交易参考号
            ,setl_status -- 结清状态: 0-待结清;1-处理中;2-已结清
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_ic_ec_settle_reg_op(
            setl_seq_no -- 结清序号
            ,glob_seq_num -- 全局流水号
            ,sys_seq_num -- 系统流水号
            ,biz_seq_num -- 业务流水号
            ,setl_dt -- 结清日期
            ,branch -- 机构编号
            ,card_no -- 卡号
            ,ic_card_seq -- 卡序列号
            ,tran_amt -- 交易金额
            ,client_name -- 客户名称
            ,document_type -- 客户证件类型
            ,document_id -- 客户证件号码
            ,commission_client_name -- 代办人姓名
            ,commission_document_type -- 代办人证件类型
            ,commission_document_id -- 代办人证件号码
            ,cash_tfr_flg -- 现转标志: 0-现金;1-转账
            ,oth_base_acct_no -- 交易对手账号
            ,setl_reason -- 结清原因: 0-正常结清;1-损坏结清;2-挂失结清
            ,remark -- 附加备注
            ,begin_time -- 批处理起始时间
            ,rel_setl_dt -- 实际结清日期
            ,reference -- 交易参考号
            ,setl_status -- 结清状态: 0-待结清;1-处理中;2-已结清
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.setl_seq_no -- 结清序号
    ,o.glob_seq_num -- 全局流水号
    ,o.sys_seq_num -- 系统流水号
    ,o.biz_seq_num -- 业务流水号
    ,o.setl_dt -- 结清日期
    ,o.branch -- 机构编号
    ,o.card_no -- 卡号
    ,o.ic_card_seq -- 卡序列号
    ,o.tran_amt -- 交易金额
    ,o.client_name -- 客户名称
    ,o.document_type -- 客户证件类型
    ,o.document_id -- 客户证件号码
    ,o.commission_client_name -- 代办人姓名
    ,o.commission_document_type -- 代办人证件类型
    ,o.commission_document_id -- 代办人证件号码
    ,o.cash_tfr_flg -- 现转标志: 0-现金;1-转账
    ,o.oth_base_acct_no -- 交易对手账号
    ,o.setl_reason -- 结清原因: 0-正常结清;1-损坏结清;2-挂失结清
    ,o.remark -- 附加备注
    ,o.begin_time -- 批处理起始时间
    ,o.rel_setl_dt -- 实际结清日期
    ,o.reference -- 交易参考号
    ,o.setl_status -- 结清状态: 0-待结清;1-处理中;2-已结清
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
from ${iol_schema}.ncbs_ic_ec_settle_reg_bk o
    left join ${iol_schema}.ncbs_ic_ec_settle_reg_op n
        on
            o.setl_seq_no = n.setl_seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_ic_ec_settle_reg_cl d
        on
            o.setl_seq_no = d.setl_seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_ic_ec_settle_reg;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_ic_ec_settle_reg') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_ic_ec_settle_reg drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_ic_ec_settle_reg add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_ic_ec_settle_reg exchange partition p_${batch_date} with table ${iol_schema}.ncbs_ic_ec_settle_reg_cl;
alter table ${iol_schema}.ncbs_ic_ec_settle_reg exchange partition p_20991231 with table ${iol_schema}.ncbs_ic_ec_settle_reg_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_ic_ec_settle_reg to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_ic_ec_settle_reg_op purge;
drop table ${iol_schema}.ncbs_ic_ec_settle_reg_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_ic_ec_settle_reg_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_ic_ec_settle_reg',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
