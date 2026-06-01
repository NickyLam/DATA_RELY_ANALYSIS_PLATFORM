/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_voucher_lost_detail
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
create table ${iol_schema}.ncbs_rb_voucher_lost_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_voucher_lost_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_voucher_lost_detail_op purge;
drop table ${iol_schema}.ncbs_rb_voucher_lost_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_voucher_lost_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_voucher_lost_detail where 0=1;

create table ${iol_schema}.ncbs_rb_voucher_lost_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_voucher_lost_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_voucher_lost_detail_cl(
            payee_name -- 收款人名称
            ,address -- 地址
            ,client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,agent_tel -- 经办人电话
            ,commission_client_tel -- 代办/代理人电话
            ,commission_country -- 代办人国籍
            ,company -- 法人
            ,deal_result -- 处理结果
            ,lost_key -- 挂失标识符
            ,lost_no -- 挂失编号
            ,new_prefix -- 新凭证前缀
            ,prefix -- 前缀
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,voucher_lost_status -- 凭证挂失状态
            ,bill_date -- 本票兑付出票日
            ,bill_lost_time -- 本票丧失时间
            ,commission_expire_date -- 交易代办人证件证件失效日期
            ,commission_start_date -- 代办人证件开始日期
            ,stop_end_date -- 起始补发日期
            ,stop_start_date -- 挂失起始日期
            ,tran_timestamp -- 交易时间戳
            ,bill_lost_addr -- 本票丧失地点
            ,bill_tran_amt -- 出票金额
            ,busi_place -- 营业场所住所
            ,commission_client_name -- 代办人名称
            ,commission_document_id -- 代办人证件号码
            ,commission_document_type -- 代办人证件类型
            ,new_doc_type -- 新凭证类型
            ,new_voucher_no -- 新凭证号码
            ,off_document_id -- 经办人证件号码
            ,off_document_type -- 经办人证件类型
            ,operator_name -- 经办人姓名
            ,unlost_comm_name1 -- 解挂代办人姓名1
            ,unlost_document_id1 -- 解挂人证件号码1
            ,unlost_document_type1 -- 解挂人证件类型1
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,payer_name -- 付款人名称
            ,lost_person -- 挂失止付人
            ,lost_execution -- 丧失事由
            ,unlost_country -- 解挂代办人国籍
            ,unlost_phone -- 解挂代办人联系电话
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_voucher_lost_detail_op(
            payee_name -- 收款人名称
            ,address -- 地址
            ,client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,agent_tel -- 经办人电话
            ,commission_client_tel -- 代办/代理人电话
            ,commission_country -- 代办人国籍
            ,company -- 法人
            ,deal_result -- 处理结果
            ,lost_key -- 挂失标识符
            ,lost_no -- 挂失编号
            ,new_prefix -- 新凭证前缀
            ,prefix -- 前缀
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,voucher_lost_status -- 凭证挂失状态
            ,bill_date -- 本票兑付出票日
            ,bill_lost_time -- 本票丧失时间
            ,commission_expire_date -- 交易代办人证件证件失效日期
            ,commission_start_date -- 代办人证件开始日期
            ,stop_end_date -- 起始补发日期
            ,stop_start_date -- 挂失起始日期
            ,tran_timestamp -- 交易时间戳
            ,bill_lost_addr -- 本票丧失地点
            ,bill_tran_amt -- 出票金额
            ,busi_place -- 营业场所住所
            ,commission_client_name -- 代办人名称
            ,commission_document_id -- 代办人证件号码
            ,commission_document_type -- 代办人证件类型
            ,new_doc_type -- 新凭证类型
            ,new_voucher_no -- 新凭证号码
            ,off_document_id -- 经办人证件号码
            ,off_document_type -- 经办人证件类型
            ,operator_name -- 经办人姓名
            ,unlost_comm_name1 -- 解挂代办人姓名1
            ,unlost_document_id1 -- 解挂人证件号码1
            ,unlost_document_type1 -- 解挂人证件类型1
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,payer_name -- 付款人名称
            ,lost_person -- 挂失止付人
            ,lost_execution -- 丧失事由
            ,unlost_country -- 解挂代办人国籍
            ,unlost_phone -- 解挂代办人联系电话
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.payee_name, o.payee_name) as payee_name -- 收款人名称
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.doc_type, o.doc_type) as doc_type -- 凭证类型
    ,nvl(n.agent_tel, o.agent_tel) as agent_tel -- 经办人电话
    ,nvl(n.commission_client_tel, o.commission_client_tel) as commission_client_tel -- 代办/代理人电话
    ,nvl(n.commission_country, o.commission_country) as commission_country -- 代办人国籍
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.deal_result, o.deal_result) as deal_result -- 处理结果
    ,nvl(n.lost_key, o.lost_key) as lost_key -- 挂失标识符
    ,nvl(n.lost_no, o.lost_no) as lost_no -- 挂失编号
    ,nvl(n.new_prefix, o.new_prefix) as new_prefix -- 新凭证前缀
    ,nvl(n.prefix, o.prefix) as prefix -- 前缀
    ,nvl(n.seq_no, o.seq_no) as seq_no -- 序号
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.voucher_lost_status, o.voucher_lost_status) as voucher_lost_status -- 凭证挂失状态
    ,nvl(n.bill_date, o.bill_date) as bill_date -- 本票兑付出票日
    ,nvl(n.bill_lost_time, o.bill_lost_time) as bill_lost_time -- 本票丧失时间
    ,nvl(n.commission_expire_date, o.commission_expire_date) as commission_expire_date -- 交易代办人证件证件失效日期
    ,nvl(n.commission_start_date, o.commission_start_date) as commission_start_date -- 代办人证件开始日期
    ,nvl(n.stop_end_date, o.stop_end_date) as stop_end_date -- 起始补发日期
    ,nvl(n.stop_start_date, o.stop_start_date) as stop_start_date -- 挂失起始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.bill_lost_addr, o.bill_lost_addr) as bill_lost_addr -- 本票丧失地点
    ,nvl(n.bill_tran_amt, o.bill_tran_amt) as bill_tran_amt -- 出票金额
    ,nvl(n.busi_place, o.busi_place) as busi_place -- 营业场所住所
    ,nvl(n.commission_client_name, o.commission_client_name) as commission_client_name -- 代办人名称
    ,nvl(n.commission_document_id, o.commission_document_id) as commission_document_id -- 代办人证件号码
    ,nvl(n.commission_document_type, o.commission_document_type) as commission_document_type -- 代办人证件类型
    ,nvl(n.new_doc_type, o.new_doc_type) as new_doc_type -- 新凭证类型
    ,nvl(n.new_voucher_no, o.new_voucher_no) as new_voucher_no -- 新凭证号码
    ,nvl(n.off_document_id, o.off_document_id) as off_document_id -- 经办人证件号码
    ,nvl(n.off_document_type, o.off_document_type) as off_document_type -- 经办人证件类型
    ,nvl(n.operator_name, o.operator_name) as operator_name -- 经办人姓名
    ,nvl(n.unlost_comm_name1, o.unlost_comm_name1) as unlost_comm_name1 -- 解挂代办人姓名1
    ,nvl(n.unlost_document_id1, o.unlost_document_id1) as unlost_document_id1 -- 解挂人证件号码1
    ,nvl(n.unlost_document_type1, o.unlost_document_type1) as unlost_document_type1 -- 解挂人证件类型1
    ,nvl(n.voucher_end_no, o.voucher_end_no) as voucher_end_no -- 凭证终止号码
    ,nvl(n.voucher_start_no, o.voucher_start_no) as voucher_start_no -- 凭证起始号码
    ,nvl(n.payer_name, o.payer_name) as payer_name -- 付款人名称
    ,nvl(n.lost_person, o.lost_person) as lost_person -- 挂失止付人
    ,nvl(n.lost_execution, o.lost_execution) as lost_execution -- 丧失事由
    ,nvl(n.unlost_country, o.unlost_country) as unlost_country -- 解挂代办人国籍
    ,nvl(n.unlost_phone, o.unlost_phone) as unlost_phone -- 解挂代办人联系电话
    ,case when
            n.lost_key is null
            and n.lost_no is null
            and n.seq_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.lost_key is null
            and n.lost_no is null
            and n.seq_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.lost_key is null
            and n.lost_no is null
            and n.seq_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_voucher_lost_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_voucher_lost_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.lost_key = n.lost_key
            and o.lost_no = n.lost_no
            and o.seq_no = n.seq_no
where (
        o.lost_key is null
        and o.lost_no is null
        and o.seq_no is null
    )
    or (
        n.lost_key is null
        and n.lost_no is null
        and n.seq_no is null
    )
    or (
        o.payee_name <> n.payee_name
        or o.address <> n.address
        or o.client_no <> n.client_no
        or o.doc_type <> n.doc_type
        or o.agent_tel <> n.agent_tel
        or o.commission_client_tel <> n.commission_client_tel
        or o.commission_country <> n.commission_country
        or o.company <> n.company
        or o.deal_result <> n.deal_result
        or o.new_prefix <> n.new_prefix
        or o.prefix <> n.prefix
        or o.source_type <> n.source_type
        or o.voucher_lost_status <> n.voucher_lost_status
        or o.bill_date <> n.bill_date
        or o.bill_lost_time <> n.bill_lost_time
        or o.commission_expire_date <> n.commission_expire_date
        or o.commission_start_date <> n.commission_start_date
        or o.stop_end_date <> n.stop_end_date
        or o.stop_start_date <> n.stop_start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.bill_lost_addr <> n.bill_lost_addr
        or o.bill_tran_amt <> n.bill_tran_amt
        or o.busi_place <> n.busi_place
        or o.commission_client_name <> n.commission_client_name
        or o.commission_document_id <> n.commission_document_id
        or o.commission_document_type <> n.commission_document_type
        or o.new_doc_type <> n.new_doc_type
        or o.new_voucher_no <> n.new_voucher_no
        or o.off_document_id <> n.off_document_id
        or o.off_document_type <> n.off_document_type
        or o.operator_name <> n.operator_name
        or o.unlost_comm_name1 <> n.unlost_comm_name1
        or o.unlost_document_id1 <> n.unlost_document_id1
        or o.unlost_document_type1 <> n.unlost_document_type1
        or o.voucher_end_no <> n.voucher_end_no
        or o.voucher_start_no <> n.voucher_start_no
        or o.payer_name <> n.payer_name
        or o.lost_person <> n.lost_person
        or o.lost_execution <> n.lost_execution
        or o.unlost_country <> n.unlost_country
        or o.unlost_phone <> n.unlost_phone
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_voucher_lost_detail_cl(
            payee_name -- 收款人名称
            ,address -- 地址
            ,client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,agent_tel -- 经办人电话
            ,commission_client_tel -- 代办/代理人电话
            ,commission_country -- 代办人国籍
            ,company -- 法人
            ,deal_result -- 处理结果
            ,lost_key -- 挂失标识符
            ,lost_no -- 挂失编号
            ,new_prefix -- 新凭证前缀
            ,prefix -- 前缀
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,voucher_lost_status -- 凭证挂失状态
            ,bill_date -- 本票兑付出票日
            ,bill_lost_time -- 本票丧失时间
            ,commission_expire_date -- 交易代办人证件证件失效日期
            ,commission_start_date -- 代办人证件开始日期
            ,stop_end_date -- 起始补发日期
            ,stop_start_date -- 挂失起始日期
            ,tran_timestamp -- 交易时间戳
            ,bill_lost_addr -- 本票丧失地点
            ,bill_tran_amt -- 出票金额
            ,busi_place -- 营业场所住所
            ,commission_client_name -- 代办人名称
            ,commission_document_id -- 代办人证件号码
            ,commission_document_type -- 代办人证件类型
            ,new_doc_type -- 新凭证类型
            ,new_voucher_no -- 新凭证号码
            ,off_document_id -- 经办人证件号码
            ,off_document_type -- 经办人证件类型
            ,operator_name -- 经办人姓名
            ,unlost_comm_name1 -- 解挂代办人姓名1
            ,unlost_document_id1 -- 解挂人证件号码1
            ,unlost_document_type1 -- 解挂人证件类型1
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,payer_name -- 付款人名称
            ,lost_person -- 挂失止付人
            ,lost_execution -- 丧失事由
            ,unlost_country -- 解挂代办人国籍
            ,unlost_phone -- 解挂代办人联系电话
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_voucher_lost_detail_op(
            payee_name -- 收款人名称
            ,address -- 地址
            ,client_no -- 客户编号
            ,doc_type -- 凭证类型
            ,agent_tel -- 经办人电话
            ,commission_client_tel -- 代办/代理人电话
            ,commission_country -- 代办人国籍
            ,company -- 法人
            ,deal_result -- 处理结果
            ,lost_key -- 挂失标识符
            ,lost_no -- 挂失编号
            ,new_prefix -- 新凭证前缀
            ,prefix -- 前缀
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,voucher_lost_status -- 凭证挂失状态
            ,bill_date -- 本票兑付出票日
            ,bill_lost_time -- 本票丧失时间
            ,commission_expire_date -- 交易代办人证件证件失效日期
            ,commission_start_date -- 代办人证件开始日期
            ,stop_end_date -- 起始补发日期
            ,stop_start_date -- 挂失起始日期
            ,tran_timestamp -- 交易时间戳
            ,bill_lost_addr -- 本票丧失地点
            ,bill_tran_amt -- 出票金额
            ,busi_place -- 营业场所住所
            ,commission_client_name -- 代办人名称
            ,commission_document_id -- 代办人证件号码
            ,commission_document_type -- 代办人证件类型
            ,new_doc_type -- 新凭证类型
            ,new_voucher_no -- 新凭证号码
            ,off_document_id -- 经办人证件号码
            ,off_document_type -- 经办人证件类型
            ,operator_name -- 经办人姓名
            ,unlost_comm_name1 -- 解挂代办人姓名1
            ,unlost_document_id1 -- 解挂人证件号码1
            ,unlost_document_type1 -- 解挂人证件类型1
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,payer_name -- 付款人名称
            ,lost_person -- 挂失止付人
            ,lost_execution -- 丧失事由
            ,unlost_country -- 解挂代办人国籍
            ,unlost_phone -- 解挂代办人联系电话
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.payee_name -- 收款人名称
    ,o.address -- 地址
    ,o.client_no -- 客户编号
    ,o.doc_type -- 凭证类型
    ,o.agent_tel -- 经办人电话
    ,o.commission_client_tel -- 代办/代理人电话
    ,o.commission_country -- 代办人国籍
    ,o.company -- 法人
    ,o.deal_result -- 处理结果
    ,o.lost_key -- 挂失标识符
    ,o.lost_no -- 挂失编号
    ,o.new_prefix -- 新凭证前缀
    ,o.prefix -- 前缀
    ,o.seq_no -- 序号
    ,o.source_type -- 渠道编号
    ,o.voucher_lost_status -- 凭证挂失状态
    ,o.bill_date -- 本票兑付出票日
    ,o.bill_lost_time -- 本票丧失时间
    ,o.commission_expire_date -- 交易代办人证件证件失效日期
    ,o.commission_start_date -- 代办人证件开始日期
    ,o.stop_end_date -- 起始补发日期
    ,o.stop_start_date -- 挂失起始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.bill_lost_addr -- 本票丧失地点
    ,o.bill_tran_amt -- 出票金额
    ,o.busi_place -- 营业场所住所
    ,o.commission_client_name -- 代办人名称
    ,o.commission_document_id -- 代办人证件号码
    ,o.commission_document_type -- 代办人证件类型
    ,o.new_doc_type -- 新凭证类型
    ,o.new_voucher_no -- 新凭证号码
    ,o.off_document_id -- 经办人证件号码
    ,o.off_document_type -- 经办人证件类型
    ,o.operator_name -- 经办人姓名
    ,o.unlost_comm_name1 -- 解挂代办人姓名1
    ,o.unlost_document_id1 -- 解挂人证件号码1
    ,o.unlost_document_type1 -- 解挂人证件类型1
    ,o.voucher_end_no -- 凭证终止号码
    ,o.voucher_start_no -- 凭证起始号码
    ,o.payer_name -- 付款人名称
    ,o.lost_person -- 挂失止付人
    ,o.lost_execution -- 丧失事由
    ,o.unlost_country -- 解挂代办人国籍
    ,o.unlost_phone -- 解挂代办人联系电话
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
from ${iol_schema}.ncbs_rb_voucher_lost_detail_bk o
    left join ${iol_schema}.ncbs_rb_voucher_lost_detail_op n
        on
            o.lost_key = n.lost_key
            and o.lost_no = n.lost_no
            and o.seq_no = n.seq_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_voucher_lost_detail_cl d
        on
            o.lost_key = d.lost_key
            and o.lost_no = d.lost_no
            and o.seq_no = d.seq_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_voucher_lost_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_voucher_lost_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_voucher_lost_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_voucher_lost_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_voucher_lost_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_voucher_lost_detail_cl;
alter table ${iol_schema}.ncbs_rb_voucher_lost_detail exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_voucher_lost_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_voucher_lost_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_voucher_lost_detail_op purge;
drop table ${iol_schema}.ncbs_rb_voucher_lost_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_voucher_lost_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_voucher_lost_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
