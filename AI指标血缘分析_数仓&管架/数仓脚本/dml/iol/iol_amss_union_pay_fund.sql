/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_union_pay_fund
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
create table ${iol_schema}.amss_union_pay_fund_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_union_pay_fund
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_union_pay_fund_op purge;
drop table ${iol_schema}.amss_union_pay_fund_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_union_pay_fund_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_union_pay_fund where 0=1;

create table ${iol_schema}.amss_union_pay_fund_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_union_pay_fund where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_union_pay_fund_cl(
            fund_id -- 基金公司信息表主键
            ,mgmt_platf_chn -- 渠道号
            ,fund_name -- 基金公司名称
            ,fund_sname -- 基金公司简称
            ,bank_org_code -- 银行机构号
            ,channel_id -- 所属机构（channelId）
            ,examine_status -- 审核状态，默认1，审核通过（0编辑待审核，1审核通过，2审核不通过）
            ,status -- 基金公司状态，默认1正常（0冻结，正常）
            ,oper_licence_num -- 营业执照号
            ,oper_licence_valid_dt -- 营业执照有效期
            ,lp_name -- 法人姓名
            ,lp_ceph_num -- 法人手机号
            ,lnkm_name -- 联系人名称
            ,lnkm_ceph_num -- 联系人号码
            ,lnkm_address -- 联系人地址
            ,lnkm_iden_num -- 联系人证件号码
            ,lnkm_iden_type -- 联系人证件类型
            ,email -- 邮箱
            ,sms_name -- 短信通知人
            ,sms_ceph_num -- 短信通知电话
            ,acct_num -- 结算账户
            ,acct_name -- 结算账户名
            ,acct_type -- 结算账户类型
            ,open_bk_num -- 开户行行号
            ,open_bk_name -- 开户行行名
            ,open_bk_address -- 开户行地址
            ,fund_lmt -- 基金额度
            ,single_lmt -- 单笔额度
            ,create_time -- 创建时间
            ,create_user -- 创建id
            ,create_emp -- 创建者
            ,update_time -- 更新时间
            ,update_user -- 更新id
            ,update_emp -- 更新者
            ,physics_flag -- 物理标识：默认1正常，2删除
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_union_pay_fund_op(
            fund_id -- 基金公司信息表主键
            ,mgmt_platf_chn -- 渠道号
            ,fund_name -- 基金公司名称
            ,fund_sname -- 基金公司简称
            ,bank_org_code -- 银行机构号
            ,channel_id -- 所属机构（channelId）
            ,examine_status -- 审核状态，默认1，审核通过（0编辑待审核，1审核通过，2审核不通过）
            ,status -- 基金公司状态，默认1正常（0冻结，正常）
            ,oper_licence_num -- 营业执照号
            ,oper_licence_valid_dt -- 营业执照有效期
            ,lp_name -- 法人姓名
            ,lp_ceph_num -- 法人手机号
            ,lnkm_name -- 联系人名称
            ,lnkm_ceph_num -- 联系人号码
            ,lnkm_address -- 联系人地址
            ,lnkm_iden_num -- 联系人证件号码
            ,lnkm_iden_type -- 联系人证件类型
            ,email -- 邮箱
            ,sms_name -- 短信通知人
            ,sms_ceph_num -- 短信通知电话
            ,acct_num -- 结算账户
            ,acct_name -- 结算账户名
            ,acct_type -- 结算账户类型
            ,open_bk_num -- 开户行行号
            ,open_bk_name -- 开户行行名
            ,open_bk_address -- 开户行地址
            ,fund_lmt -- 基金额度
            ,single_lmt -- 单笔额度
            ,create_time -- 创建时间
            ,create_user -- 创建id
            ,create_emp -- 创建者
            ,update_time -- 更新时间
            ,update_user -- 更新id
            ,update_emp -- 更新者
            ,physics_flag -- 物理标识：默认1正常，2删除
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fund_id, o.fund_id) as fund_id -- 基金公司信息表主键
    ,nvl(n.mgmt_platf_chn, o.mgmt_platf_chn) as mgmt_platf_chn -- 渠道号
    ,nvl(n.fund_name, o.fund_name) as fund_name -- 基金公司名称
    ,nvl(n.fund_sname, o.fund_sname) as fund_sname -- 基金公司简称
    ,nvl(n.bank_org_code, o.bank_org_code) as bank_org_code -- 银行机构号
    ,nvl(n.channel_id, o.channel_id) as channel_id -- 所属机构（channelId）
    ,nvl(n.examine_status, o.examine_status) as examine_status -- 审核状态，默认1，审核通过（0编辑待审核，1审核通过，2审核不通过）
    ,nvl(n.status, o.status) as status -- 基金公司状态，默认1正常（0冻结，正常）
    ,nvl(n.oper_licence_num, o.oper_licence_num) as oper_licence_num -- 营业执照号
    ,nvl(n.oper_licence_valid_dt, o.oper_licence_valid_dt) as oper_licence_valid_dt -- 营业执照有效期
    ,nvl(n.lp_name, o.lp_name) as lp_name -- 法人姓名
    ,nvl(n.lp_ceph_num, o.lp_ceph_num) as lp_ceph_num -- 法人手机号
    ,nvl(n.lnkm_name, o.lnkm_name) as lnkm_name -- 联系人名称
    ,nvl(n.lnkm_ceph_num, o.lnkm_ceph_num) as lnkm_ceph_num -- 联系人号码
    ,nvl(n.lnkm_address, o.lnkm_address) as lnkm_address -- 联系人地址
    ,nvl(n.lnkm_iden_num, o.lnkm_iden_num) as lnkm_iden_num -- 联系人证件号码
    ,nvl(n.lnkm_iden_type, o.lnkm_iden_type) as lnkm_iden_type -- 联系人证件类型
    ,nvl(n.email, o.email) as email -- 邮箱
    ,nvl(n.sms_name, o.sms_name) as sms_name -- 短信通知人
    ,nvl(n.sms_ceph_num, o.sms_ceph_num) as sms_ceph_num -- 短信通知电话
    ,nvl(n.acct_num, o.acct_num) as acct_num -- 结算账户
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 结算账户名
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 结算账户类型
    ,nvl(n.open_bk_num, o.open_bk_num) as open_bk_num -- 开户行行号
    ,nvl(n.open_bk_name, o.open_bk_name) as open_bk_name -- 开户行行名
    ,nvl(n.open_bk_address, o.open_bk_address) as open_bk_address -- 开户行地址
    ,nvl(n.fund_lmt, o.fund_lmt) as fund_lmt -- 基金额度
    ,nvl(n.single_lmt, o.single_lmt) as single_lmt -- 单笔额度
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.create_user, o.create_user) as create_user -- 创建id
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建者
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新id
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 更新者
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识：默认1正常，2删除
    ,case when
            n.fund_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fund_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fund_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_union_pay_fund_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_union_pay_fund where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fund_id = n.fund_id
where (
        o.fund_id is null
    )
    or (
        n.fund_id is null
    )
    or (
        o.mgmt_platf_chn <> n.mgmt_platf_chn
        or o.fund_name <> n.fund_name
        or o.fund_sname <> n.fund_sname
        or o.bank_org_code <> n.bank_org_code
        or o.channel_id <> n.channel_id
        or o.examine_status <> n.examine_status
        or o.status <> n.status
        or o.oper_licence_num <> n.oper_licence_num
        or o.oper_licence_valid_dt <> n.oper_licence_valid_dt
        or o.lp_name <> n.lp_name
        or o.lp_ceph_num <> n.lp_ceph_num
        or o.lnkm_name <> n.lnkm_name
        or o.lnkm_ceph_num <> n.lnkm_ceph_num
        or o.lnkm_address <> n.lnkm_address
        or o.lnkm_iden_num <> n.lnkm_iden_num
        or o.lnkm_iden_type <> n.lnkm_iden_type
        or o.email <> n.email
        or o.sms_name <> n.sms_name
        or o.sms_ceph_num <> n.sms_ceph_num
        or o.acct_num <> n.acct_num
        or o.acct_name <> n.acct_name
        or o.acct_type <> n.acct_type
        or o.open_bk_num <> n.open_bk_num
        or o.open_bk_name <> n.open_bk_name
        or o.open_bk_address <> n.open_bk_address
        or o.fund_lmt <> n.fund_lmt
        or o.single_lmt <> n.single_lmt
        or o.create_time <> n.create_time
        or o.create_user <> n.create_user
        or o.create_emp <> n.create_emp
        or o.update_time <> n.update_time
        or o.update_user <> n.update_user
        or o.update_emp <> n.update_emp
        or o.physics_flag <> n.physics_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_union_pay_fund_cl(
            fund_id -- 基金公司信息表主键
            ,mgmt_platf_chn -- 渠道号
            ,fund_name -- 基金公司名称
            ,fund_sname -- 基金公司简称
            ,bank_org_code -- 银行机构号
            ,channel_id -- 所属机构（channelId）
            ,examine_status -- 审核状态，默认1，审核通过（0编辑待审核，1审核通过，2审核不通过）
            ,status -- 基金公司状态，默认1正常（0冻结，正常）
            ,oper_licence_num -- 营业执照号
            ,oper_licence_valid_dt -- 营业执照有效期
            ,lp_name -- 法人姓名
            ,lp_ceph_num -- 法人手机号
            ,lnkm_name -- 联系人名称
            ,lnkm_ceph_num -- 联系人号码
            ,lnkm_address -- 联系人地址
            ,lnkm_iden_num -- 联系人证件号码
            ,lnkm_iden_type -- 联系人证件类型
            ,email -- 邮箱
            ,sms_name -- 短信通知人
            ,sms_ceph_num -- 短信通知电话
            ,acct_num -- 结算账户
            ,acct_name -- 结算账户名
            ,acct_type -- 结算账户类型
            ,open_bk_num -- 开户行行号
            ,open_bk_name -- 开户行行名
            ,open_bk_address -- 开户行地址
            ,fund_lmt -- 基金额度
            ,single_lmt -- 单笔额度
            ,create_time -- 创建时间
            ,create_user -- 创建id
            ,create_emp -- 创建者
            ,update_time -- 更新时间
            ,update_user -- 更新id
            ,update_emp -- 更新者
            ,physics_flag -- 物理标识：默认1正常，2删除
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_union_pay_fund_op(
            fund_id -- 基金公司信息表主键
            ,mgmt_platf_chn -- 渠道号
            ,fund_name -- 基金公司名称
            ,fund_sname -- 基金公司简称
            ,bank_org_code -- 银行机构号
            ,channel_id -- 所属机构（channelId）
            ,examine_status -- 审核状态，默认1，审核通过（0编辑待审核，1审核通过，2审核不通过）
            ,status -- 基金公司状态，默认1正常（0冻结，正常）
            ,oper_licence_num -- 营业执照号
            ,oper_licence_valid_dt -- 营业执照有效期
            ,lp_name -- 法人姓名
            ,lp_ceph_num -- 法人手机号
            ,lnkm_name -- 联系人名称
            ,lnkm_ceph_num -- 联系人号码
            ,lnkm_address -- 联系人地址
            ,lnkm_iden_num -- 联系人证件号码
            ,lnkm_iden_type -- 联系人证件类型
            ,email -- 邮箱
            ,sms_name -- 短信通知人
            ,sms_ceph_num -- 短信通知电话
            ,acct_num -- 结算账户
            ,acct_name -- 结算账户名
            ,acct_type -- 结算账户类型
            ,open_bk_num -- 开户行行号
            ,open_bk_name -- 开户行行名
            ,open_bk_address -- 开户行地址
            ,fund_lmt -- 基金额度
            ,single_lmt -- 单笔额度
            ,create_time -- 创建时间
            ,create_user -- 创建id
            ,create_emp -- 创建者
            ,update_time -- 更新时间
            ,update_user -- 更新id
            ,update_emp -- 更新者
            ,physics_flag -- 物理标识：默认1正常，2删除
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fund_id -- 基金公司信息表主键
    ,o.mgmt_platf_chn -- 渠道号
    ,o.fund_name -- 基金公司名称
    ,o.fund_sname -- 基金公司简称
    ,o.bank_org_code -- 银行机构号
    ,o.channel_id -- 所属机构（channelId）
    ,o.examine_status -- 审核状态，默认1，审核通过（0编辑待审核，1审核通过，2审核不通过）
    ,o.status -- 基金公司状态，默认1正常（0冻结，正常）
    ,o.oper_licence_num -- 营业执照号
    ,o.oper_licence_valid_dt -- 营业执照有效期
    ,o.lp_name -- 法人姓名
    ,o.lp_ceph_num -- 法人手机号
    ,o.lnkm_name -- 联系人名称
    ,o.lnkm_ceph_num -- 联系人号码
    ,o.lnkm_address -- 联系人地址
    ,o.lnkm_iden_num -- 联系人证件号码
    ,o.lnkm_iden_type -- 联系人证件类型
    ,o.email -- 邮箱
    ,o.sms_name -- 短信通知人
    ,o.sms_ceph_num -- 短信通知电话
    ,o.acct_num -- 结算账户
    ,o.acct_name -- 结算账户名
    ,o.acct_type -- 结算账户类型
    ,o.open_bk_num -- 开户行行号
    ,o.open_bk_name -- 开户行行名
    ,o.open_bk_address -- 开户行地址
    ,o.fund_lmt -- 基金额度
    ,o.single_lmt -- 单笔额度
    ,o.create_time -- 创建时间
    ,o.create_user -- 创建id
    ,o.create_emp -- 创建者
    ,o.update_time -- 更新时间
    ,o.update_user -- 更新id
    ,o.update_emp -- 更新者
    ,o.physics_flag -- 物理标识：默认1正常，2删除
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
from ${iol_schema}.amss_union_pay_fund_bk o
    left join ${iol_schema}.amss_union_pay_fund_op n
        on
            o.fund_id = n.fund_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_union_pay_fund_cl d
        on
            o.fund_id = d.fund_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_union_pay_fund;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_union_pay_fund') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_union_pay_fund drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_union_pay_fund add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_union_pay_fund exchange partition p_${batch_date} with table ${iol_schema}.amss_union_pay_fund_cl;
alter table ${iol_schema}.amss_union_pay_fund exchange partition p_20991231 with table ${iol_schema}.amss_union_pay_fund_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_union_pay_fund to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_union_pay_fund_op purge;
drop table ${iol_schema}.amss_union_pay_fund_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_union_pay_fund_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_union_pay_fund',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
