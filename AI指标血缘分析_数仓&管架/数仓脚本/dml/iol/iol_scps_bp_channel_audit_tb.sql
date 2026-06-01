/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_channel_audit_tb
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
create table ${iol_schema}.scps_bp_channel_audit_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_bp_channel_audit_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_channel_audit_tb_op purge;
drop table ${iol_schema}.scps_bp_channel_audit_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_channel_audit_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_channel_audit_tb where 0=1;

create table ${iol_schema}.scps_bp_channel_audit_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_channel_audit_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_channel_audit_tb_cl(
            task_id -- 任务号
            ,seq_num -- 流水号
            ,chn_id -- 源发起渠道编号
            ,user_no -- 用户号
            ,cust_na -- 姓名
            ,ocr_cust_na -- OCR姓名
            ,access_token -- 用户信息唯一标志
            ,idtf_tp -- 证件类型
            ,idtf_no -- 证件号码
            ,idtd_dt -- 证件生效日期
            ,ocr_idt_dt -- 证件生效日期
            ,idt_address -- 证件地址
            ,ocr_idt_address -- ocr识别地址
            ,bound_accno -- 绑定账号
            ,bound_bank -- 绑定账号开户行
            ,mobile -- 预留手机号
            ,idcheck_result -- 身份证联网核查结果
            ,check_case -- 落地审核原因
            ,rego_result -- 识别结果
            ,sim_larity -- 认证相似度
            ,biz_code -- 业务类型
            ,doc_id -- 影像批次号
            ,trans_id -- 业务种类
            ,channel -- 渠道编号
            ,vouch_group -- 凭证种类
            ,creation_time -- 发起时间
            ,audit_result -- 审核结果(0审核通过 1审核不通过)
            ,audit_status -- 审核状态（0 未审核 1 审核中 2 审核完成）
            ,bank_no -- 银行标识
            ,system_no -- 系统标识
            ,scene_code -- 业务场景号
            ,organ_no -- 机构号
            ,receive_no -- 受理号
            ,id -- 主键
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_channel_audit_tb_op(
            task_id -- 任务号
            ,seq_num -- 流水号
            ,chn_id -- 源发起渠道编号
            ,user_no -- 用户号
            ,cust_na -- 姓名
            ,ocr_cust_na -- OCR姓名
            ,access_token -- 用户信息唯一标志
            ,idtf_tp -- 证件类型
            ,idtf_no -- 证件号码
            ,idtd_dt -- 证件生效日期
            ,ocr_idt_dt -- 证件生效日期
            ,idt_address -- 证件地址
            ,ocr_idt_address -- ocr识别地址
            ,bound_accno -- 绑定账号
            ,bound_bank -- 绑定账号开户行
            ,mobile -- 预留手机号
            ,idcheck_result -- 身份证联网核查结果
            ,check_case -- 落地审核原因
            ,rego_result -- 识别结果
            ,sim_larity -- 认证相似度
            ,biz_code -- 业务类型
            ,doc_id -- 影像批次号
            ,trans_id -- 业务种类
            ,channel -- 渠道编号
            ,vouch_group -- 凭证种类
            ,creation_time -- 发起时间
            ,audit_result -- 审核结果(0审核通过 1审核不通过)
            ,audit_status -- 审核状态（0 未审核 1 审核中 2 审核完成）
            ,bank_no -- 银行标识
            ,system_no -- 系统标识
            ,scene_code -- 业务场景号
            ,organ_no -- 机构号
            ,receive_no -- 受理号
            ,id -- 主键
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.task_id, o.task_id) as task_id -- 任务号
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 流水号
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 源发起渠道编号
    ,nvl(n.user_no, o.user_no) as user_no -- 用户号
    ,nvl(n.cust_na, o.cust_na) as cust_na -- 姓名
    ,nvl(n.ocr_cust_na, o.ocr_cust_na) as ocr_cust_na -- OCR姓名
    ,nvl(n.access_token, o.access_token) as access_token -- 用户信息唯一标志
    ,nvl(n.idtf_tp, o.idtf_tp) as idtf_tp -- 证件类型
    ,nvl(n.idtf_no, o.idtf_no) as idtf_no -- 证件号码
    ,nvl(n.idtd_dt, o.idtd_dt) as idtd_dt -- 证件生效日期
    ,nvl(n.ocr_idt_dt, o.ocr_idt_dt) as ocr_idt_dt -- 证件生效日期
    ,nvl(n.idt_address, o.idt_address) as idt_address -- 证件地址
    ,nvl(n.ocr_idt_address, o.ocr_idt_address) as ocr_idt_address -- ocr识别地址
    ,nvl(n.bound_accno, o.bound_accno) as bound_accno -- 绑定账号
    ,nvl(n.bound_bank, o.bound_bank) as bound_bank -- 绑定账号开户行
    ,nvl(n.mobile, o.mobile) as mobile -- 预留手机号
    ,nvl(n.idcheck_result, o.idcheck_result) as idcheck_result -- 身份证联网核查结果
    ,nvl(n.check_case, o.check_case) as check_case -- 落地审核原因
    ,nvl(n.rego_result, o.rego_result) as rego_result -- 识别结果
    ,nvl(n.sim_larity, o.sim_larity) as sim_larity -- 认证相似度
    ,nvl(n.biz_code, o.biz_code) as biz_code -- 业务类型
    ,nvl(n.doc_id, o.doc_id) as doc_id -- 影像批次号
    ,nvl(n.trans_id, o.trans_id) as trans_id -- 业务种类
    ,nvl(n.channel, o.channel) as channel -- 渠道编号
    ,nvl(n.vouch_group, o.vouch_group) as vouch_group -- 凭证种类
    ,nvl(n.creation_time, o.creation_time) as creation_time -- 发起时间
    ,nvl(n.audit_result, o.audit_result) as audit_result -- 审核结果(0审核通过 1审核不通过)
    ,nvl(n.audit_status, o.audit_status) as audit_status -- 审核状态（0 未审核 1 审核中 2 审核完成）
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行标识
    ,nvl(n.system_no, o.system_no) as system_no -- 系统标识
    ,nvl(n.scene_code, o.scene_code) as scene_code -- 业务场景号
    ,nvl(n.organ_no, o.organ_no) as organ_no -- 机构号
    ,nvl(n.receive_no, o.receive_no) as receive_no -- 受理号
    ,nvl(n.id, o.id) as id -- 主键
    ,case when
            n.task_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.task_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.task_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_bp_channel_audit_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_bp_channel_audit_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.task_id = n.task_id
where (
        o.task_id is null
    )
    or (
        n.task_id is null
    )
    or (
        o.seq_num <> n.seq_num
        or o.chn_id <> n.chn_id
        or o.user_no <> n.user_no
        or o.cust_na <> n.cust_na
        or o.ocr_cust_na <> n.ocr_cust_na
        or o.access_token <> n.access_token
        or o.idtf_tp <> n.idtf_tp
        or o.idtf_no <> n.idtf_no
        or o.idtd_dt <> n.idtd_dt
        or o.ocr_idt_dt <> n.ocr_idt_dt
        or o.idt_address <> n.idt_address
        or o.ocr_idt_address <> n.ocr_idt_address
        or o.bound_accno <> n.bound_accno
        or o.bound_bank <> n.bound_bank
        or o.mobile <> n.mobile
        or o.idcheck_result <> n.idcheck_result
        or o.check_case <> n.check_case
        or o.rego_result <> n.rego_result
        or o.sim_larity <> n.sim_larity
        or o.biz_code <> n.biz_code
        or o.doc_id <> n.doc_id
        or o.trans_id <> n.trans_id
        or o.channel <> n.channel
        or o.vouch_group <> n.vouch_group
        or o.creation_time <> n.creation_time
        or o.audit_result <> n.audit_result
        or o.audit_status <> n.audit_status
        or o.bank_no <> n.bank_no
        or o.system_no <> n.system_no
        or o.scene_code <> n.scene_code
        or o.organ_no <> n.organ_no
        or o.receive_no <> n.receive_no
        or o.id <> n.id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_channel_audit_tb_cl(
            task_id -- 任务号
            ,seq_num -- 流水号
            ,chn_id -- 源发起渠道编号
            ,user_no -- 用户号
            ,cust_na -- 姓名
            ,ocr_cust_na -- OCR姓名
            ,access_token -- 用户信息唯一标志
            ,idtf_tp -- 证件类型
            ,idtf_no -- 证件号码
            ,idtd_dt -- 证件生效日期
            ,ocr_idt_dt -- 证件生效日期
            ,idt_address -- 证件地址
            ,ocr_idt_address -- ocr识别地址
            ,bound_accno -- 绑定账号
            ,bound_bank -- 绑定账号开户行
            ,mobile -- 预留手机号
            ,idcheck_result -- 身份证联网核查结果
            ,check_case -- 落地审核原因
            ,rego_result -- 识别结果
            ,sim_larity -- 认证相似度
            ,biz_code -- 业务类型
            ,doc_id -- 影像批次号
            ,trans_id -- 业务种类
            ,channel -- 渠道编号
            ,vouch_group -- 凭证种类
            ,creation_time -- 发起时间
            ,audit_result -- 审核结果(0审核通过 1审核不通过)
            ,audit_status -- 审核状态（0 未审核 1 审核中 2 审核完成）
            ,bank_no -- 银行标识
            ,system_no -- 系统标识
            ,scene_code -- 业务场景号
            ,organ_no -- 机构号
            ,receive_no -- 受理号
            ,id -- 主键
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_channel_audit_tb_op(
            task_id -- 任务号
            ,seq_num -- 流水号
            ,chn_id -- 源发起渠道编号
            ,user_no -- 用户号
            ,cust_na -- 姓名
            ,ocr_cust_na -- OCR姓名
            ,access_token -- 用户信息唯一标志
            ,idtf_tp -- 证件类型
            ,idtf_no -- 证件号码
            ,idtd_dt -- 证件生效日期
            ,ocr_idt_dt -- 证件生效日期
            ,idt_address -- 证件地址
            ,ocr_idt_address -- ocr识别地址
            ,bound_accno -- 绑定账号
            ,bound_bank -- 绑定账号开户行
            ,mobile -- 预留手机号
            ,idcheck_result -- 身份证联网核查结果
            ,check_case -- 落地审核原因
            ,rego_result -- 识别结果
            ,sim_larity -- 认证相似度
            ,biz_code -- 业务类型
            ,doc_id -- 影像批次号
            ,trans_id -- 业务种类
            ,channel -- 渠道编号
            ,vouch_group -- 凭证种类
            ,creation_time -- 发起时间
            ,audit_result -- 审核结果(0审核通过 1审核不通过)
            ,audit_status -- 审核状态（0 未审核 1 审核中 2 审核完成）
            ,bank_no -- 银行标识
            ,system_no -- 系统标识
            ,scene_code -- 业务场景号
            ,organ_no -- 机构号
            ,receive_no -- 受理号
            ,id -- 主键
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.task_id -- 任务号
    ,o.seq_num -- 流水号
    ,o.chn_id -- 源发起渠道编号
    ,o.user_no -- 用户号
    ,o.cust_na -- 姓名
    ,o.ocr_cust_na -- OCR姓名
    ,o.access_token -- 用户信息唯一标志
    ,o.idtf_tp -- 证件类型
    ,o.idtf_no -- 证件号码
    ,o.idtd_dt -- 证件生效日期
    ,o.ocr_idt_dt -- 证件生效日期
    ,o.idt_address -- 证件地址
    ,o.ocr_idt_address -- ocr识别地址
    ,o.bound_accno -- 绑定账号
    ,o.bound_bank -- 绑定账号开户行
    ,o.mobile -- 预留手机号
    ,o.idcheck_result -- 身份证联网核查结果
    ,o.check_case -- 落地审核原因
    ,o.rego_result -- 识别结果
    ,o.sim_larity -- 认证相似度
    ,o.biz_code -- 业务类型
    ,o.doc_id -- 影像批次号
    ,o.trans_id -- 业务种类
    ,o.channel -- 渠道编号
    ,o.vouch_group -- 凭证种类
    ,o.creation_time -- 发起时间
    ,o.audit_result -- 审核结果(0审核通过 1审核不通过)
    ,o.audit_status -- 审核状态（0 未审核 1 审核中 2 审核完成）
    ,o.bank_no -- 银行标识
    ,o.system_no -- 系统标识
    ,o.scene_code -- 业务场景号
    ,o.organ_no -- 机构号
    ,o.receive_no -- 受理号
    ,o.id -- 主键
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
from ${iol_schema}.scps_bp_channel_audit_tb_bk o
    left join ${iol_schema}.scps_bp_channel_audit_tb_op n
        on
            o.task_id = n.task_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_bp_channel_audit_tb_cl d
        on
            o.task_id = d.task_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_bp_channel_audit_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_bp_channel_audit_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_bp_channel_audit_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_bp_channel_audit_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_bp_channel_audit_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_channel_audit_tb_cl;
alter table ${iol_schema}.scps_bp_channel_audit_tb exchange partition p_20991231 with table ${iol_schema}.scps_bp_channel_audit_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_channel_audit_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_channel_audit_tb_op purge;
drop table ${iol_schema}.scps_bp_channel_audit_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_bp_channel_audit_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_channel_audit_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
