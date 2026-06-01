/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_custody_item_info
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
create table ${iol_schema}.ncbs_tb_custody_item_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_custody_item_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_custody_item_info_op purge;
drop table ${iol_schema}.ncbs_tb_custody_item_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_custody_item_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_custody_item_info where 0=1;

create table ${iol_schema}.ncbs_tb_custody_item_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_custody_item_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_custody_item_info_cl(
            amount -- 金额
            ,branch -- 机构编号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,remark -- 备注
            ,agent_tel -- 经办人电话
            ,company -- 法人
            ,company_name -- 公司名称
            ,contact_tel -- 客户联系电话
            ,custody_item_num -- 代保管物品数量
            ,custody_item_status -- 代保管物品状态
            ,custody_type -- 代保管品种类
            ,draw_man -- 领取人
            ,item_id -- 物品编号
            ,phone -- 手机号
            ,store_person -- 存放人
            ,delete_date -- 删除日期
            ,handover_date -- 交接日期
            ,in_date -- 入库日期
            ,out_date -- 出库日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,appr_user_id -- 复核柜员
            ,belong_user_id -- 所属柜员
            ,in_user_id -- 入库柜员
            ,last_branch_id -- 上一所属机构
            ,last_user_id -- 上一柜员id
            ,out_user_id -- 出库交易柜员
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,custody_sub_type -- 代保管物品大类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_custody_item_info_op(
            amount -- 金额
            ,branch -- 机构编号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,remark -- 备注
            ,agent_tel -- 经办人电话
            ,company -- 法人
            ,company_name -- 公司名称
            ,contact_tel -- 客户联系电话
            ,custody_item_num -- 代保管物品数量
            ,custody_item_status -- 代保管物品状态
            ,custody_type -- 代保管品种类
            ,draw_man -- 领取人
            ,item_id -- 物品编号
            ,phone -- 手机号
            ,store_person -- 存放人
            ,delete_date -- 删除日期
            ,handover_date -- 交接日期
            ,in_date -- 入库日期
            ,out_date -- 出库日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,appr_user_id -- 复核柜员
            ,belong_user_id -- 所属柜员
            ,in_user_id -- 入库柜员
            ,last_branch_id -- 上一所属机构
            ,last_user_id -- 上一柜员id
            ,out_user_id -- 出库交易柜员
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,custody_sub_type -- 代保管物品大类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.amount, o.amount) as amount -- 金额
    ,nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_name, o.client_name) as client_name -- 客户名称
    ,nvl(n.document_id, o.document_id) as document_id -- 证件号码
    ,nvl(n.document_type, o.document_type) as document_type -- 客户证件类型
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.agent_tel, o.agent_tel) as agent_tel -- 经办人电话
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.company_name, o.company_name) as company_name -- 公司名称
    ,nvl(n.contact_tel, o.contact_tel) as contact_tel -- 客户联系电话
    ,nvl(n.custody_item_num, o.custody_item_num) as custody_item_num -- 代保管物品数量
    ,nvl(n.custody_item_status, o.custody_item_status) as custody_item_status -- 代保管物品状态
    ,nvl(n.custody_type, o.custody_type) as custody_type -- 代保管品种类
    ,nvl(n.draw_man, o.draw_man) as draw_man -- 领取人
    ,nvl(n.item_id, o.item_id) as item_id -- 物品编号
    ,nvl(n.phone, o.phone) as phone -- 手机号
    ,nvl(n.store_person, o.store_person) as store_person -- 存放人
    ,nvl(n.delete_date, o.delete_date) as delete_date -- 删除日期
    ,nvl(n.handover_date, o.handover_date) as handover_date -- 交接日期
    ,nvl(n.in_date, o.in_date) as in_date -- 入库日期
    ,nvl(n.out_date, o.out_date) as out_date -- 出库日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.update_date, o.update_date) as update_date -- 更新日期
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.belong_user_id, o.belong_user_id) as belong_user_id -- 所属柜员
    ,nvl(n.in_user_id, o.in_user_id) as in_user_id -- 入库柜员
    ,nvl(n.last_branch_id, o.last_branch_id) as last_branch_id -- 上一所属机构
    ,nvl(n.last_user_id, o.last_user_id) as last_user_id -- 上一柜员id
    ,nvl(n.out_user_id, o.out_user_id) as out_user_id -- 出库交易柜员
    ,nvl(n.voucher_end_no, o.voucher_end_no) as voucher_end_no -- 凭证终止号码
    ,nvl(n.voucher_start_no, o.voucher_start_no) as voucher_start_no -- 凭证起始号码
    ,nvl(n.custody_sub_type, o.custody_sub_type) as custody_sub_type -- 代保管物品大类
    ,case when
            n.custody_type is null
            and n.item_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.custody_type is null
            and n.item_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.custody_type is null
            and n.item_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_custody_item_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_custody_item_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.custody_type = n.custody_type
            and o.item_id = n.item_id
where (
        o.custody_type is null
        and o.item_id is null
    )
    or (
        n.custody_type is null
        and n.item_id is null
    )
    or (
        o.amount <> n.amount
        or o.branch <> n.branch
        or o.ccy <> n.ccy
        or o.client_name <> n.client_name
        or o.document_id <> n.document_id
        or o.document_type <> n.document_type
        or o.remark <> n.remark
        or o.agent_tel <> n.agent_tel
        or o.company <> n.company
        or o.company_name <> n.company_name
        or o.contact_tel <> n.contact_tel
        or o.custody_item_num <> n.custody_item_num
        or o.custody_item_status <> n.custody_item_status
        or o.draw_man <> n.draw_man
        or o.phone <> n.phone
        or o.store_person <> n.store_person
        or o.delete_date <> n.delete_date
        or o.handover_date <> n.handover_date
        or o.in_date <> n.in_date
        or o.out_date <> n.out_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.update_date <> n.update_date
        or o.appr_user_id <> n.appr_user_id
        or o.belong_user_id <> n.belong_user_id
        or o.in_user_id <> n.in_user_id
        or o.last_branch_id <> n.last_branch_id
        or o.last_user_id <> n.last_user_id
        or o.out_user_id <> n.out_user_id
        or o.voucher_end_no <> n.voucher_end_no
        or o.voucher_start_no <> n.voucher_start_no
        or o.custody_sub_type <> n.custody_sub_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_custody_item_info_cl(
            amount -- 金额
            ,branch -- 机构编号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,remark -- 备注
            ,agent_tel -- 经办人电话
            ,company -- 法人
            ,company_name -- 公司名称
            ,contact_tel -- 客户联系电话
            ,custody_item_num -- 代保管物品数量
            ,custody_item_status -- 代保管物品状态
            ,custody_type -- 代保管品种类
            ,draw_man -- 领取人
            ,item_id -- 物品编号
            ,phone -- 手机号
            ,store_person -- 存放人
            ,delete_date -- 删除日期
            ,handover_date -- 交接日期
            ,in_date -- 入库日期
            ,out_date -- 出库日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,appr_user_id -- 复核柜员
            ,belong_user_id -- 所属柜员
            ,in_user_id -- 入库柜员
            ,last_branch_id -- 上一所属机构
            ,last_user_id -- 上一柜员id
            ,out_user_id -- 出库交易柜员
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,custody_sub_type -- 代保管物品大类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_custody_item_info_op(
            amount -- 金额
            ,branch -- 机构编号
            ,ccy -- 币种
            ,client_name -- 客户名称
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,remark -- 备注
            ,agent_tel -- 经办人电话
            ,company -- 法人
            ,company_name -- 公司名称
            ,contact_tel -- 客户联系电话
            ,custody_item_num -- 代保管物品数量
            ,custody_item_status -- 代保管物品状态
            ,custody_type -- 代保管品种类
            ,draw_man -- 领取人
            ,item_id -- 物品编号
            ,phone -- 手机号
            ,store_person -- 存放人
            ,delete_date -- 删除日期
            ,handover_date -- 交接日期
            ,in_date -- 入库日期
            ,out_date -- 出库日期
            ,tran_timestamp -- 交易时间戳
            ,update_date -- 更新日期
            ,appr_user_id -- 复核柜员
            ,belong_user_id -- 所属柜员
            ,in_user_id -- 入库柜员
            ,last_branch_id -- 上一所属机构
            ,last_user_id -- 上一柜员id
            ,out_user_id -- 出库交易柜员
            ,voucher_end_no -- 凭证终止号码
            ,voucher_start_no -- 凭证起始号码
            ,custody_sub_type -- 代保管物品大类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.amount -- 金额
    ,o.branch -- 机构编号
    ,o.ccy -- 币种
    ,o.client_name -- 客户名称
    ,o.document_id -- 证件号码
    ,o.document_type -- 客户证件类型
    ,o.remark -- 备注
    ,o.agent_tel -- 经办人电话
    ,o.company -- 法人
    ,o.company_name -- 公司名称
    ,o.contact_tel -- 客户联系电话
    ,o.custody_item_num -- 代保管物品数量
    ,o.custody_item_status -- 代保管物品状态
    ,o.custody_type -- 代保管品种类
    ,o.draw_man -- 领取人
    ,o.item_id -- 物品编号
    ,o.phone -- 手机号
    ,o.store_person -- 存放人
    ,o.delete_date -- 删除日期
    ,o.handover_date -- 交接日期
    ,o.in_date -- 入库日期
    ,o.out_date -- 出库日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.update_date -- 更新日期
    ,o.appr_user_id -- 复核柜员
    ,o.belong_user_id -- 所属柜员
    ,o.in_user_id -- 入库柜员
    ,o.last_branch_id -- 上一所属机构
    ,o.last_user_id -- 上一柜员id
    ,o.out_user_id -- 出库交易柜员
    ,o.voucher_end_no -- 凭证终止号码
    ,o.voucher_start_no -- 凭证起始号码
    ,o.custody_sub_type -- 代保管物品大类
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
from ${iol_schema}.ncbs_tb_custody_item_info_bk o
    left join ${iol_schema}.ncbs_tb_custody_item_info_op n
        on
            o.custody_type = n.custody_type
            and o.item_id = n.item_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_custody_item_info_cl d
        on
            o.custody_type = d.custody_type
            and o.item_id = d.item_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_custody_item_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_custody_item_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_custody_item_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_custody_item_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_custody_item_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_custody_item_info_cl;
alter table ${iol_schema}.ncbs_tb_custody_item_info exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_custody_item_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_custody_item_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_custody_item_info_op purge;
drop table ${iol_schema}.ncbs_tb_custody_item_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_custody_item_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_custody_item_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
