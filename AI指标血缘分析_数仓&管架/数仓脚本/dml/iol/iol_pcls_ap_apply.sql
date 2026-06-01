/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pcls_ap_apply
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
create table ${iol_schema}.pcls_ap_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pcls_ap_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pcls_ap_apply_op purge;
drop table ${iol_schema}.pcls_ap_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pcls_ap_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pcls_ap_apply where 0=1;

create table ${iol_schema}.pcls_ap_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pcls_ap_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pcls_ap_apply_cl(
            id -- 物理主键
            ,appl_no -- 申请号
            ,user_no -- 用户号
            ,id_no_encryptx -- 身份证号号密文
            ,id_no_md5x -- 身份证号MD5
            ,id_type -- 证件类型
            ,cust_name_encryptx -- 姓名密文
            ,cust_name_md5x -- 姓名MD5
            ,mobile_no_encryptx -- 手机号密文
            ,mobile_no_md5x -- 手机号MD5
            ,purpose_no -- 贷款用途
            ,product_code -- 产品代码
            ,product_type -- 产品类型：消费贷，经营贷
            ,ref_appl_no -- 关联业务申请号（第三方）
            ,org_no -- 所属机构编号
            ,sub_org_no -- 子机构编码
            ,regist_channel -- 注册渠道
            ,apply_channel -- 申请渠道
            ,sub_channel -- 子渠道
            ,state -- 申请状态 审批中/通过/拒绝
            ,reject_code -- 拒绝代码
            ,reject_msg -- 拒绝原因
            ,date_finished -- 申请结束时间
            ,approval_user -- 审批通过用户
            ,appr_auto_amt -- 自动审批通过金额
            ,appr_manual_amt -- 人工审批通过金额
            ,appr_final_amt -- 人工最终审批金额
            ,contract_no -- 额度合同号
            ,manual_flag -- 是否走人工审批（Y 表示走人工审批流程）
            ,user_type -- 授信人类型 MASTER=主借人 COBO=共借人 COOWNER=共有人 GURANTEE=担保人
            ,date_created -- 创建时间
            ,created_by -- 创建人
            ,date_updated -- 修改时间
            ,updated_by -- 修改人
            ,scene_value -- scene_value
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pcls_ap_apply_op(
            id -- 物理主键
            ,appl_no -- 申请号
            ,user_no -- 用户号
            ,id_no_encryptx -- 身份证号号密文
            ,id_no_md5x -- 身份证号MD5
            ,id_type -- 证件类型
            ,cust_name_encryptx -- 姓名密文
            ,cust_name_md5x -- 姓名MD5
            ,mobile_no_encryptx -- 手机号密文
            ,mobile_no_md5x -- 手机号MD5
            ,purpose_no -- 贷款用途
            ,product_code -- 产品代码
            ,product_type -- 产品类型：消费贷，经营贷
            ,ref_appl_no -- 关联业务申请号（第三方）
            ,org_no -- 所属机构编号
            ,sub_org_no -- 子机构编码
            ,regist_channel -- 注册渠道
            ,apply_channel -- 申请渠道
            ,sub_channel -- 子渠道
            ,state -- 申请状态 审批中/通过/拒绝
            ,reject_code -- 拒绝代码
            ,reject_msg -- 拒绝原因
            ,date_finished -- 申请结束时间
            ,approval_user -- 审批通过用户
            ,appr_auto_amt -- 自动审批通过金额
            ,appr_manual_amt -- 人工审批通过金额
            ,appr_final_amt -- 人工最终审批金额
            ,contract_no -- 额度合同号
            ,manual_flag -- 是否走人工审批（Y 表示走人工审批流程）
            ,user_type -- 授信人类型 MASTER=主借人 COBO=共借人 COOWNER=共有人 GURANTEE=担保人
            ,date_created -- 创建时间
            ,created_by -- 创建人
            ,date_updated -- 修改时间
            ,updated_by -- 修改人
            ,scene_value -- scene_value
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 物理主键
    ,nvl(n.appl_no, o.appl_no) as appl_no -- 申请号
    ,nvl(n.user_no, o.user_no) as user_no -- 用户号
    ,nvl(n.id_no_encryptx, o.id_no_encryptx) as id_no_encryptx -- 身份证号号密文
    ,nvl(n.id_no_md5x, o.id_no_md5x) as id_no_md5x -- 身份证号MD5
    ,nvl(n.id_type, o.id_type) as id_type -- 证件类型
    ,nvl(n.cust_name_encryptx, o.cust_name_encryptx) as cust_name_encryptx -- 姓名密文
    ,nvl(n.cust_name_md5x, o.cust_name_md5x) as cust_name_md5x -- 姓名MD5
    ,nvl(n.mobile_no_encryptx, o.mobile_no_encryptx) as mobile_no_encryptx -- 手机号密文
    ,nvl(n.mobile_no_md5x, o.mobile_no_md5x) as mobile_no_md5x -- 手机号MD5
    ,nvl(n.purpose_no, o.purpose_no) as purpose_no -- 贷款用途
    ,nvl(n.product_code, o.product_code) as product_code -- 产品代码
    ,nvl(n.product_type, o.product_type) as product_type -- 产品类型：消费贷，经营贷
    ,nvl(n.ref_appl_no, o.ref_appl_no) as ref_appl_no -- 关联业务申请号（第三方）
    ,nvl(n.org_no, o.org_no) as org_no -- 所属机构编号
    ,nvl(n.sub_org_no, o.sub_org_no) as sub_org_no -- 子机构编码
    ,nvl(n.regist_channel, o.regist_channel) as regist_channel -- 注册渠道
    ,nvl(n.apply_channel, o.apply_channel) as apply_channel -- 申请渠道
    ,nvl(n.sub_channel, o.sub_channel) as sub_channel -- 子渠道
    ,nvl(n.state, o.state) as state -- 申请状态 审批中/通过/拒绝
    ,nvl(n.reject_code, o.reject_code) as reject_code -- 拒绝代码
    ,nvl(n.reject_msg, o.reject_msg) as reject_msg -- 拒绝原因
    ,nvl(n.date_finished, o.date_finished) as date_finished -- 申请结束时间
    ,nvl(n.approval_user, o.approval_user) as approval_user -- 审批通过用户
    ,nvl(n.appr_auto_amt, o.appr_auto_amt) as appr_auto_amt -- 自动审批通过金额
    ,nvl(n.appr_manual_amt, o.appr_manual_amt) as appr_manual_amt -- 人工审批通过金额
    ,nvl(n.appr_final_amt, o.appr_final_amt) as appr_final_amt -- 人工最终审批金额
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 额度合同号
    ,nvl(n.manual_flag, o.manual_flag) as manual_flag -- 是否走人工审批（Y 表示走人工审批流程）
    ,nvl(n.user_type, o.user_type) as user_type -- 授信人类型 MASTER=主借人 COBO=共借人 COOWNER=共有人 GURANTEE=担保人
    ,nvl(n.date_created, o.date_created) as date_created -- 创建时间
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.date_updated, o.date_updated) as date_updated -- 修改时间
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 修改人
    ,nvl(n.scene_value, o.scene_value) as scene_value -- scene_value
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
from (select * from ${iol_schema}.pcls_ap_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pcls_ap_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.appl_no <> n.appl_no
        or o.user_no <> n.user_no
        or o.id_no_encryptx <> n.id_no_encryptx
        or o.id_no_md5x <> n.id_no_md5x
        or o.id_type <> n.id_type
        or o.cust_name_encryptx <> n.cust_name_encryptx
        or o.cust_name_md5x <> n.cust_name_md5x
        or o.mobile_no_encryptx <> n.mobile_no_encryptx
        or o.mobile_no_md5x <> n.mobile_no_md5x
        or o.purpose_no <> n.purpose_no
        or o.product_code <> n.product_code
        or o.product_type <> n.product_type
        or o.ref_appl_no <> n.ref_appl_no
        or o.org_no <> n.org_no
        or o.sub_org_no <> n.sub_org_no
        or o.regist_channel <> n.regist_channel
        or o.apply_channel <> n.apply_channel
        or o.sub_channel <> n.sub_channel
        or o.state <> n.state
        or o.reject_code <> n.reject_code
        or o.reject_msg <> n.reject_msg
        or o.date_finished <> n.date_finished
        or o.approval_user <> n.approval_user
        or o.appr_auto_amt <> n.appr_auto_amt
        or o.appr_manual_amt <> n.appr_manual_amt
        or o.appr_final_amt <> n.appr_final_amt
        or o.contract_no <> n.contract_no
        or o.manual_flag <> n.manual_flag
        or o.user_type <> n.user_type
        or o.date_created <> n.date_created
        or o.created_by <> n.created_by
        or o.date_updated <> n.date_updated
        or o.updated_by <> n.updated_by
        or o.scene_value <> n.scene_value
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pcls_ap_apply_cl(
            id -- 物理主键
            ,appl_no -- 申请号
            ,user_no -- 用户号
            ,id_no_encryptx -- 身份证号号密文
            ,id_no_md5x -- 身份证号MD5
            ,id_type -- 证件类型
            ,cust_name_encryptx -- 姓名密文
            ,cust_name_md5x -- 姓名MD5
            ,mobile_no_encryptx -- 手机号密文
            ,mobile_no_md5x -- 手机号MD5
            ,purpose_no -- 贷款用途
            ,product_code -- 产品代码
            ,product_type -- 产品类型：消费贷，经营贷
            ,ref_appl_no -- 关联业务申请号（第三方）
            ,org_no -- 所属机构编号
            ,sub_org_no -- 子机构编码
            ,regist_channel -- 注册渠道
            ,apply_channel -- 申请渠道
            ,sub_channel -- 子渠道
            ,state -- 申请状态 审批中/通过/拒绝
            ,reject_code -- 拒绝代码
            ,reject_msg -- 拒绝原因
            ,date_finished -- 申请结束时间
            ,approval_user -- 审批通过用户
            ,appr_auto_amt -- 自动审批通过金额
            ,appr_manual_amt -- 人工审批通过金额
            ,appr_final_amt -- 人工最终审批金额
            ,contract_no -- 额度合同号
            ,manual_flag -- 是否走人工审批（Y 表示走人工审批流程）
            ,user_type -- 授信人类型 MASTER=主借人 COBO=共借人 COOWNER=共有人 GURANTEE=担保人
            ,date_created -- 创建时间
            ,created_by -- 创建人
            ,date_updated -- 修改时间
            ,updated_by -- 修改人
            ,scene_value -- scene_value
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pcls_ap_apply_op(
            id -- 物理主键
            ,appl_no -- 申请号
            ,user_no -- 用户号
            ,id_no_encryptx -- 身份证号号密文
            ,id_no_md5x -- 身份证号MD5
            ,id_type -- 证件类型
            ,cust_name_encryptx -- 姓名密文
            ,cust_name_md5x -- 姓名MD5
            ,mobile_no_encryptx -- 手机号密文
            ,mobile_no_md5x -- 手机号MD5
            ,purpose_no -- 贷款用途
            ,product_code -- 产品代码
            ,product_type -- 产品类型：消费贷，经营贷
            ,ref_appl_no -- 关联业务申请号（第三方）
            ,org_no -- 所属机构编号
            ,sub_org_no -- 子机构编码
            ,regist_channel -- 注册渠道
            ,apply_channel -- 申请渠道
            ,sub_channel -- 子渠道
            ,state -- 申请状态 审批中/通过/拒绝
            ,reject_code -- 拒绝代码
            ,reject_msg -- 拒绝原因
            ,date_finished -- 申请结束时间
            ,approval_user -- 审批通过用户
            ,appr_auto_amt -- 自动审批通过金额
            ,appr_manual_amt -- 人工审批通过金额
            ,appr_final_amt -- 人工最终审批金额
            ,contract_no -- 额度合同号
            ,manual_flag -- 是否走人工审批（Y 表示走人工审批流程）
            ,user_type -- 授信人类型 MASTER=主借人 COBO=共借人 COOWNER=共有人 GURANTEE=担保人
            ,date_created -- 创建时间
            ,created_by -- 创建人
            ,date_updated -- 修改时间
            ,updated_by -- 修改人
            ,scene_value -- scene_value
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 物理主键
    ,o.appl_no -- 申请号
    ,o.user_no -- 用户号
    ,o.id_no_encryptx -- 身份证号号密文
    ,o.id_no_md5x -- 身份证号MD5
    ,o.id_type -- 证件类型
    ,o.cust_name_encryptx -- 姓名密文
    ,o.cust_name_md5x -- 姓名MD5
    ,o.mobile_no_encryptx -- 手机号密文
    ,o.mobile_no_md5x -- 手机号MD5
    ,o.purpose_no -- 贷款用途
    ,o.product_code -- 产品代码
    ,o.product_type -- 产品类型：消费贷，经营贷
    ,o.ref_appl_no -- 关联业务申请号（第三方）
    ,o.org_no -- 所属机构编号
    ,o.sub_org_no -- 子机构编码
    ,o.regist_channel -- 注册渠道
    ,o.apply_channel -- 申请渠道
    ,o.sub_channel -- 子渠道
    ,o.state -- 申请状态 审批中/通过/拒绝
    ,o.reject_code -- 拒绝代码
    ,o.reject_msg -- 拒绝原因
    ,o.date_finished -- 申请结束时间
    ,o.approval_user -- 审批通过用户
    ,o.appr_auto_amt -- 自动审批通过金额
    ,o.appr_manual_amt -- 人工审批通过金额
    ,o.appr_final_amt -- 人工最终审批金额
    ,o.contract_no -- 额度合同号
    ,o.manual_flag -- 是否走人工审批（Y 表示走人工审批流程）
    ,o.user_type -- 授信人类型 MASTER=主借人 COBO=共借人 COOWNER=共有人 GURANTEE=担保人
    ,o.date_created -- 创建时间
    ,o.created_by -- 创建人
    ,o.date_updated -- 修改时间
    ,o.updated_by -- 修改人
    ,o.scene_value -- scene_value
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
from ${iol_schema}.pcls_ap_apply_bk o
    left join ${iol_schema}.pcls_ap_apply_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pcls_ap_apply_cl d
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
--truncate table ${iol_schema}.pcls_ap_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pcls_ap_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pcls_ap_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pcls_ap_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pcls_ap_apply exchange partition p_${batch_date} with table ${iol_schema}.pcls_ap_apply_cl;
alter table ${iol_schema}.pcls_ap_apply exchange partition p_20991231 with table ${iol_schema}.pcls_ap_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pcls_ap_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pcls_ap_apply_op purge;
drop table ${iol_schema}.pcls_ap_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pcls_ap_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pcls_ap_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
