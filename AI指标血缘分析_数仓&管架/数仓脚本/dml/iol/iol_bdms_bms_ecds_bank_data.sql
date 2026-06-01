/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_bms_ecds_bank_data
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
create table ${iol_schema}.bdms_bms_ecds_bank_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_bms_ecds_bank_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_ecds_bank_data_op purge;
drop table ${iol_schema}.bdms_bms_ecds_bank_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_ecds_bank_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_ecds_bank_data where 0=1;

create table ${iol_schema}.bdms_bms_ecds_bank_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_bms_ecds_bank_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_ecds_bank_data_cl(
            id -- ID
            ,bank_no -- 联行号
            ,actor_type -- 参与者类型： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
            ,bank_other_code -- 行别代码
            ,super_actor -- 上级参与者
            ,local_node_code -- 所在节点代码
            ,root_super_actor -- 本行上级参与者
            ,cate_people_code -- 所属人行代码
            ,city_code -- 地市代码
            ,actor_full_call -- 参与者全称
            ,actor_for_short -- 参与者简称
            ,address -- 地址
            ,post_edit -- 邮编
            ,phone -- 电话/电挂
            ,email -- 电子邮件地址
            ,status -- 状态： 0 无效 1 有效
            ,inure_date -- 生效日期
            ,log_out_date -- 注销日期
            ,update_time -- 更新时间
            ,lately_update_work -- 最近更新操作
            ,log_update_expect -- 记录更新期数
            ,remark -- 备注
            ,dn_field -- DN域
            ,sn_field -- SN域
            ,cert_bind_status -- 证书绑定状态： 00 未绑定 01 已绑定
            ,meet_income_code -- 接入点代码
            ,continue_row_num -- 承接行号
            ,continue_meet_income -- 承接行接入点
            ,if_continue -- 是否有承接行： 0 否 1 是
            ,history_continue_con -- 历史承接关系记录
            ,sttlm_acc_status -- 清算账户状态
            ,sttlm_acc_update -- 清算账户状态变更日期
            ,sttlm_acc_uptime -- 清算帐户状态变更时间
            ,update_dt -- UPDATE_DT
            ,update_tm -- UPDATE_TM
            ,head_bank_no -- HEAD_BANK_NO
            ,top_branch_no -- TOP_BRANCH_NO
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_ecds_bank_data_op(
            id -- ID
            ,bank_no -- 联行号
            ,actor_type -- 参与者类型： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
            ,bank_other_code -- 行别代码
            ,super_actor -- 上级参与者
            ,local_node_code -- 所在节点代码
            ,root_super_actor -- 本行上级参与者
            ,cate_people_code -- 所属人行代码
            ,city_code -- 地市代码
            ,actor_full_call -- 参与者全称
            ,actor_for_short -- 参与者简称
            ,address -- 地址
            ,post_edit -- 邮编
            ,phone -- 电话/电挂
            ,email -- 电子邮件地址
            ,status -- 状态： 0 无效 1 有效
            ,inure_date -- 生效日期
            ,log_out_date -- 注销日期
            ,update_time -- 更新时间
            ,lately_update_work -- 最近更新操作
            ,log_update_expect -- 记录更新期数
            ,remark -- 备注
            ,dn_field -- DN域
            ,sn_field -- SN域
            ,cert_bind_status -- 证书绑定状态： 00 未绑定 01 已绑定
            ,meet_income_code -- 接入点代码
            ,continue_row_num -- 承接行号
            ,continue_meet_income -- 承接行接入点
            ,if_continue -- 是否有承接行： 0 否 1 是
            ,history_continue_con -- 历史承接关系记录
            ,sttlm_acc_status -- 清算账户状态
            ,sttlm_acc_update -- 清算账户状态变更日期
            ,sttlm_acc_uptime -- 清算帐户状态变更时间
            ,update_dt -- UPDATE_DT
            ,update_tm -- UPDATE_TM
            ,head_bank_no -- HEAD_BANK_NO
            ,top_branch_no -- TOP_BRANCH_NO
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 联行号
    ,nvl(n.actor_type, o.actor_type) as actor_type -- 参与者类型： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
    ,nvl(n.bank_other_code, o.bank_other_code) as bank_other_code -- 行别代码
    ,nvl(n.super_actor, o.super_actor) as super_actor -- 上级参与者
    ,nvl(n.local_node_code, o.local_node_code) as local_node_code -- 所在节点代码
    ,nvl(n.root_super_actor, o.root_super_actor) as root_super_actor -- 本行上级参与者
    ,nvl(n.cate_people_code, o.cate_people_code) as cate_people_code -- 所属人行代码
    ,nvl(n.city_code, o.city_code) as city_code -- 地市代码
    ,nvl(n.actor_full_call, o.actor_full_call) as actor_full_call -- 参与者全称
    ,nvl(n.actor_for_short, o.actor_for_short) as actor_for_short -- 参与者简称
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.post_edit, o.post_edit) as post_edit -- 邮编
    ,nvl(n.phone, o.phone) as phone -- 电话/电挂
    ,nvl(n.email, o.email) as email -- 电子邮件地址
    ,nvl(n.status, o.status) as status -- 状态： 0 无效 1 有效
    ,nvl(n.inure_date, o.inure_date) as inure_date -- 生效日期
    ,nvl(n.log_out_date, o.log_out_date) as log_out_date -- 注销日期
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.lately_update_work, o.lately_update_work) as lately_update_work -- 最近更新操作
    ,nvl(n.log_update_expect, o.log_update_expect) as log_update_expect -- 记录更新期数
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.dn_field, o.dn_field) as dn_field -- DN域
    ,nvl(n.sn_field, o.sn_field) as sn_field -- SN域
    ,nvl(n.cert_bind_status, o.cert_bind_status) as cert_bind_status -- 证书绑定状态： 00 未绑定 01 已绑定
    ,nvl(n.meet_income_code, o.meet_income_code) as meet_income_code -- 接入点代码
    ,nvl(n.continue_row_num, o.continue_row_num) as continue_row_num -- 承接行号
    ,nvl(n.continue_meet_income, o.continue_meet_income) as continue_meet_income -- 承接行接入点
    ,nvl(n.if_continue, o.if_continue) as if_continue -- 是否有承接行： 0 否 1 是
    ,nvl(n.history_continue_con, o.history_continue_con) as history_continue_con -- 历史承接关系记录
    ,nvl(n.sttlm_acc_status, o.sttlm_acc_status) as sttlm_acc_status -- 清算账户状态
    ,nvl(n.sttlm_acc_update, o.sttlm_acc_update) as sttlm_acc_update -- 清算账户状态变更日期
    ,nvl(n.sttlm_acc_uptime, o.sttlm_acc_uptime) as sttlm_acc_uptime -- 清算帐户状态变更时间
    ,nvl(n.update_dt, o.update_dt) as update_dt -- UPDATE_DT
    ,nvl(n.update_tm, o.update_tm) as update_tm -- UPDATE_TM
    ,nvl(n.head_bank_no, o.head_bank_no) as head_bank_no -- HEAD_BANK_NO
    ,nvl(n.top_branch_no, o.top_branch_no) as top_branch_no -- TOP_BRANCH_NO
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.bdms_bms_ecds_bank_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_bms_ecds_bank_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.bank_no <> n.bank_no
        or o.actor_type <> n.actor_type
        or o.bank_other_code <> n.bank_other_code
        or o.super_actor <> n.super_actor
        or o.local_node_code <> n.local_node_code
        or o.root_super_actor <> n.root_super_actor
        or o.cate_people_code <> n.cate_people_code
        or o.city_code <> n.city_code
        or o.actor_full_call <> n.actor_full_call
        or o.actor_for_short <> n.actor_for_short
        or o.address <> n.address
        or o.post_edit <> n.post_edit
        or o.phone <> n.phone
        or o.email <> n.email
        or o.status <> n.status
        or o.inure_date <> n.inure_date
        or o.log_out_date <> n.log_out_date
        or o.update_time <> n.update_time
        or o.lately_update_work <> n.lately_update_work
        or o.log_update_expect <> n.log_update_expect
        or o.remark <> n.remark
        or o.dn_field <> n.dn_field
        or o.sn_field <> n.sn_field
        or o.cert_bind_status <> n.cert_bind_status
        or o.meet_income_code <> n.meet_income_code
        or o.continue_row_num <> n.continue_row_num
        or o.continue_meet_income <> n.continue_meet_income
        or o.if_continue <> n.if_continue
        or o.history_continue_con <> n.history_continue_con
        or o.sttlm_acc_status <> n.sttlm_acc_status
        or o.sttlm_acc_update <> n.sttlm_acc_update
        or o.sttlm_acc_uptime <> n.sttlm_acc_uptime
        or o.update_dt <> n.update_dt
        or o.update_tm <> n.update_tm
        or o.head_bank_no <> n.head_bank_no
        or o.top_branch_no <> n.top_branch_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_bms_ecds_bank_data_cl(
            id -- ID
            ,bank_no -- 联行号
            ,actor_type -- 参与者类型： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
            ,bank_other_code -- 行别代码
            ,super_actor -- 上级参与者
            ,local_node_code -- 所在节点代码
            ,root_super_actor -- 本行上级参与者
            ,cate_people_code -- 所属人行代码
            ,city_code -- 地市代码
            ,actor_full_call -- 参与者全称
            ,actor_for_short -- 参与者简称
            ,address -- 地址
            ,post_edit -- 邮编
            ,phone -- 电话/电挂
            ,email -- 电子邮件地址
            ,status -- 状态： 0 无效 1 有效
            ,inure_date -- 生效日期
            ,log_out_date -- 注销日期
            ,update_time -- 更新时间
            ,lately_update_work -- 最近更新操作
            ,log_update_expect -- 记录更新期数
            ,remark -- 备注
            ,dn_field -- DN域
            ,sn_field -- SN域
            ,cert_bind_status -- 证书绑定状态： 00 未绑定 01 已绑定
            ,meet_income_code -- 接入点代码
            ,continue_row_num -- 承接行号
            ,continue_meet_income -- 承接行接入点
            ,if_continue -- 是否有承接行： 0 否 1 是
            ,history_continue_con -- 历史承接关系记录
            ,sttlm_acc_status -- 清算账户状态
            ,sttlm_acc_update -- 清算账户状态变更日期
            ,sttlm_acc_uptime -- 清算帐户状态变更时间
            ,update_dt -- UPDATE_DT
            ,update_tm -- UPDATE_TM
            ,head_bank_no -- HEAD_BANK_NO
            ,top_branch_no -- TOP_BRANCH_NO
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_bms_ecds_bank_data_op(
            id -- ID
            ,bank_no -- 联行号
            ,actor_type -- 参与者类型： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
            ,bank_other_code -- 行别代码
            ,super_actor -- 上级参与者
            ,local_node_code -- 所在节点代码
            ,root_super_actor -- 本行上级参与者
            ,cate_people_code -- 所属人行代码
            ,city_code -- 地市代码
            ,actor_full_call -- 参与者全称
            ,actor_for_short -- 参与者简称
            ,address -- 地址
            ,post_edit -- 邮编
            ,phone -- 电话/电挂
            ,email -- 电子邮件地址
            ,status -- 状态： 0 无效 1 有效
            ,inure_date -- 生效日期
            ,log_out_date -- 注销日期
            ,update_time -- 更新时间
            ,lately_update_work -- 最近更新操作
            ,log_update_expect -- 记录更新期数
            ,remark -- 备注
            ,dn_field -- DN域
            ,sn_field -- SN域
            ,cert_bind_status -- 证书绑定状态： 00 未绑定 01 已绑定
            ,meet_income_code -- 接入点代码
            ,continue_row_num -- 承接行号
            ,continue_meet_income -- 承接行接入点
            ,if_continue -- 是否有承接行： 0 否 1 是
            ,history_continue_con -- 历史承接关系记录
            ,sttlm_acc_status -- 清算账户状态
            ,sttlm_acc_update -- 清算账户状态变更日期
            ,sttlm_acc_uptime -- 清算帐户状态变更时间
            ,update_dt -- UPDATE_DT
            ,update_tm -- UPDATE_TM
            ,head_bank_no -- HEAD_BANK_NO
            ,top_branch_no -- TOP_BRANCH_NO
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.bank_no -- 联行号
    ,o.actor_type -- 参与者类型： 01 直接参与人行 02 直接参与国库 03 EIS转换中心 04 直接参与商业银行 05 开户特许直接参与者 06 开户特许间接参与者 07 间接参与者 08 无户特许直接参与者(债券)
    ,o.bank_other_code -- 行别代码
    ,o.super_actor -- 上级参与者
    ,o.local_node_code -- 所在节点代码
    ,o.root_super_actor -- 本行上级参与者
    ,o.cate_people_code -- 所属人行代码
    ,o.city_code -- 地市代码
    ,o.actor_full_call -- 参与者全称
    ,o.actor_for_short -- 参与者简称
    ,o.address -- 地址
    ,o.post_edit -- 邮编
    ,o.phone -- 电话/电挂
    ,o.email -- 电子邮件地址
    ,o.status -- 状态： 0 无效 1 有效
    ,o.inure_date -- 生效日期
    ,o.log_out_date -- 注销日期
    ,o.update_time -- 更新时间
    ,o.lately_update_work -- 最近更新操作
    ,o.log_update_expect -- 记录更新期数
    ,o.remark -- 备注
    ,o.dn_field -- DN域
    ,o.sn_field -- SN域
    ,o.cert_bind_status -- 证书绑定状态： 00 未绑定 01 已绑定
    ,o.meet_income_code -- 接入点代码
    ,o.continue_row_num -- 承接行号
    ,o.continue_meet_income -- 承接行接入点
    ,o.if_continue -- 是否有承接行： 0 否 1 是
    ,o.history_continue_con -- 历史承接关系记录
    ,o.sttlm_acc_status -- 清算账户状态
    ,o.sttlm_acc_update -- 清算账户状态变更日期
    ,o.sttlm_acc_uptime -- 清算帐户状态变更时间
    ,o.update_dt -- UPDATE_DT
    ,o.update_tm -- UPDATE_TM
    ,o.head_bank_no -- HEAD_BANK_NO
    ,o.top_branch_no -- TOP_BRANCH_NO
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
from ${iol_schema}.bdms_bms_ecds_bank_data_bk o
    left join ${iol_schema}.bdms_bms_ecds_bank_data_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_bms_ecds_bank_data_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.bdms_bms_ecds_bank_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_bms_ecds_bank_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_bms_ecds_bank_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_bms_ecds_bank_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_bms_ecds_bank_data exchange partition p_${batch_date} with table ${iol_schema}.bdms_bms_ecds_bank_data_cl;
alter table ${iol_schema}.bdms_bms_ecds_bank_data exchange partition p_20991231 with table ${iol_schema}.bdms_bms_ecds_bank_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_bms_ecds_bank_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_bms_ecds_bank_data_op purge;
drop table ${iol_schema}.bdms_bms_ecds_bank_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_bms_ecds_bank_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_bms_ecds_bank_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
