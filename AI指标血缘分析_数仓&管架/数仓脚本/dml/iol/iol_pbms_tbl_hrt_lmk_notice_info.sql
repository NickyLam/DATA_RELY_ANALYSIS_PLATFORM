/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pbms_tbl_hrt_lmk_notice_info
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
create table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pbms_tbl_hrt_lmk_notice_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_op purge;
drop table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_hrt_lmk_notice_info where 0=1;

create table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_hrt_lmk_notice_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_cl(
            pk_hrt_lmk_vip_notice -- 主键
            ,operate_type -- 操作类型(1-新发卡、4-注销、8-换卡、7、开卡激活活动、10-上月月日均余额活动)
            ,merch_code -- 商户编码
            ,sys_id -- 系统编号
            ,channel_id -- 渠道编码
            ,shop_id -- 门店编码
            ,refer_no -- 华润通申请流水号
            ,uuid -- 请求唯一标识
            ,member_name -- 姓名
            ,gender -- 性别: 0-女，1-男
            ,national -- 国籍: 参考数据落标-CN
            ,certi_type -- 证件类型
            ,certi_no -- 证件号码
            ,birthday -- 生日: yyyy-mm-dd
            ,city -- 所在城市
            ,address -- 地址
            ,vip_card_no -- 会员卡号
            ,bank_card_no -- 银行卡号
            ,lmk_card_no -- 联名卡号
            ,organization -- 银行卡发卡组织
            ,card_level -- 卡等级
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,created_by -- 创建人
            ,updated_by -- 修改人
            ,del_flag -- 删除标志
            ,register_time -- 注册时间
            ,mobile -- 手机
            ,task_date -- 任务日期
            ,bank_card_no_new -- 新银行卡号
            ,lmk_card_no_new -- 新联名卡号
            ,notice_flag -- 0-待通知, 1-通知成功，2-通知失败，3-处理成功，4-处理失败
            ,acti_no -- 活动代码
            ,cust_id -- 客户号
            ,biz_time -- 业务处理时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_op(
            pk_hrt_lmk_vip_notice -- 主键
            ,operate_type -- 操作类型(1-新发卡、4-注销、8-换卡、7、开卡激活活动、10-上月月日均余额活动)
            ,merch_code -- 商户编码
            ,sys_id -- 系统编号
            ,channel_id -- 渠道编码
            ,shop_id -- 门店编码
            ,refer_no -- 华润通申请流水号
            ,uuid -- 请求唯一标识
            ,member_name -- 姓名
            ,gender -- 性别: 0-女，1-男
            ,national -- 国籍: 参考数据落标-CN
            ,certi_type -- 证件类型
            ,certi_no -- 证件号码
            ,birthday -- 生日: yyyy-mm-dd
            ,city -- 所在城市
            ,address -- 地址
            ,vip_card_no -- 会员卡号
            ,bank_card_no -- 银行卡号
            ,lmk_card_no -- 联名卡号
            ,organization -- 银行卡发卡组织
            ,card_level -- 卡等级
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,created_by -- 创建人
            ,updated_by -- 修改人
            ,del_flag -- 删除标志
            ,register_time -- 注册时间
            ,mobile -- 手机
            ,task_date -- 任务日期
            ,bank_card_no_new -- 新银行卡号
            ,lmk_card_no_new -- 新联名卡号
            ,notice_flag -- 0-待通知, 1-通知成功，2-通知失败，3-处理成功，4-处理失败
            ,acti_no -- 活动代码
            ,cust_id -- 客户号
            ,biz_time -- 业务处理时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pk_hrt_lmk_vip_notice, o.pk_hrt_lmk_vip_notice) as pk_hrt_lmk_vip_notice -- 主键
    ,nvl(n.operate_type, o.operate_type) as operate_type -- 操作类型(1-新发卡、4-注销、8-换卡、7、开卡激活活动、10-上月月日均余额活动)
    ,nvl(n.merch_code, o.merch_code) as merch_code -- 商户编码
    ,nvl(n.sys_id, o.sys_id) as sys_id -- 系统编号
    ,nvl(n.channel_id, o.channel_id) as channel_id -- 渠道编码
    ,nvl(n.shop_id, o.shop_id) as shop_id -- 门店编码
    ,nvl(n.refer_no, o.refer_no) as refer_no -- 华润通申请流水号
    ,nvl(n.uuid, o.uuid) as uuid -- 请求唯一标识
    ,nvl(n.member_name, o.member_name) as member_name -- 姓名
    ,nvl(n.gender, o.gender) as gender -- 性别: 0-女，1-男
    ,nvl(n.national, o.national) as national -- 国籍: 参考数据落标-CN
    ,nvl(n.certi_type, o.certi_type) as certi_type -- 证件类型
    ,nvl(n.certi_no, o.certi_no) as certi_no -- 证件号码
    ,nvl(n.birthday, o.birthday) as birthday -- 生日: yyyy-mm-dd
    ,nvl(n.city, o.city) as city -- 所在城市
    ,nvl(n.address, o.address) as address -- 地址
    ,nvl(n.vip_card_no, o.vip_card_no) as vip_card_no -- 会员卡号
    ,nvl(n.bank_card_no, o.bank_card_no) as bank_card_no -- 银行卡号
    ,nvl(n.lmk_card_no, o.lmk_card_no) as lmk_card_no -- 联名卡号
    ,nvl(n.organization, o.organization) as organization -- 银行卡发卡组织
    ,nvl(n.card_level, o.card_level) as card_level -- 卡等级
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 修改时间
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 修改人
    ,nvl(n.del_flag, o.del_flag) as del_flag -- 删除标志
    ,nvl(n.register_time, o.register_time) as register_time -- 注册时间
    ,nvl(n.mobile, o.mobile) as mobile -- 手机
    ,nvl(n.task_date, o.task_date) as task_date -- 任务日期
    ,nvl(n.bank_card_no_new, o.bank_card_no_new) as bank_card_no_new -- 新银行卡号
    ,nvl(n.lmk_card_no_new, o.lmk_card_no_new) as lmk_card_no_new -- 新联名卡号
    ,nvl(n.notice_flag, o.notice_flag) as notice_flag -- 0-待通知, 1-通知成功，2-通知失败，3-处理成功，4-处理失败
    ,nvl(n.acti_no, o.acti_no) as acti_no -- 活动代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户号
    ,nvl(n.biz_time, o.biz_time) as biz_time -- 业务处理时间
    ,case when
            n.pk_hrt_lmk_vip_notice is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_hrt_lmk_vip_notice is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_hrt_lmk_vip_notice is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pbms_tbl_hrt_lmk_notice_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_hrt_lmk_vip_notice = n.pk_hrt_lmk_vip_notice
where (
        o.pk_hrt_lmk_vip_notice is null
    )
    or (
        n.pk_hrt_lmk_vip_notice is null
    )
    or (
        o.operate_type <> n.operate_type
        or o.merch_code <> n.merch_code
        or o.sys_id <> n.sys_id
        or o.channel_id <> n.channel_id
        or o.shop_id <> n.shop_id
        or o.refer_no <> n.refer_no
        or o.uuid <> n.uuid
        or o.member_name <> n.member_name
        or o.gender <> n.gender
        or o.national <> n.national
        or o.certi_type <> n.certi_type
        or o.certi_no <> n.certi_no
        or o.birthday <> n.birthday
        or o.city <> n.city
        or o.address <> n.address
        or o.vip_card_no <> n.vip_card_no
        or o.bank_card_no <> n.bank_card_no
        or o.lmk_card_no <> n.lmk_card_no
        or o.organization <> n.organization
        or o.card_level <> n.card_level
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.created_by <> n.created_by
        or o.updated_by <> n.updated_by
        or o.del_flag <> n.del_flag
        or o.register_time <> n.register_time
        or o.mobile <> n.mobile
        or o.task_date <> n.task_date
        or o.bank_card_no_new <> n.bank_card_no_new
        or o.lmk_card_no_new <> n.lmk_card_no_new
        or o.notice_flag <> n.notice_flag
        or o.acti_no <> n.acti_no
        or o.cust_id <> n.cust_id
        or o.biz_time <> n.biz_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_cl(
            pk_hrt_lmk_vip_notice -- 主键
            ,operate_type -- 操作类型(1-新发卡、4-注销、8-换卡、7、开卡激活活动、10-上月月日均余额活动)
            ,merch_code -- 商户编码
            ,sys_id -- 系统编号
            ,channel_id -- 渠道编码
            ,shop_id -- 门店编码
            ,refer_no -- 华润通申请流水号
            ,uuid -- 请求唯一标识
            ,member_name -- 姓名
            ,gender -- 性别: 0-女，1-男
            ,national -- 国籍: 参考数据落标-CN
            ,certi_type -- 证件类型
            ,certi_no -- 证件号码
            ,birthday -- 生日: yyyy-mm-dd
            ,city -- 所在城市
            ,address -- 地址
            ,vip_card_no -- 会员卡号
            ,bank_card_no -- 银行卡号
            ,lmk_card_no -- 联名卡号
            ,organization -- 银行卡发卡组织
            ,card_level -- 卡等级
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,created_by -- 创建人
            ,updated_by -- 修改人
            ,del_flag -- 删除标志
            ,register_time -- 注册时间
            ,mobile -- 手机
            ,task_date -- 任务日期
            ,bank_card_no_new -- 新银行卡号
            ,lmk_card_no_new -- 新联名卡号
            ,notice_flag -- 0-待通知, 1-通知成功，2-通知失败，3-处理成功，4-处理失败
            ,acti_no -- 活动代码
            ,cust_id -- 客户号
            ,biz_time -- 业务处理时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_op(
            pk_hrt_lmk_vip_notice -- 主键
            ,operate_type -- 操作类型(1-新发卡、4-注销、8-换卡、7、开卡激活活动、10-上月月日均余额活动)
            ,merch_code -- 商户编码
            ,sys_id -- 系统编号
            ,channel_id -- 渠道编码
            ,shop_id -- 门店编码
            ,refer_no -- 华润通申请流水号
            ,uuid -- 请求唯一标识
            ,member_name -- 姓名
            ,gender -- 性别: 0-女，1-男
            ,national -- 国籍: 参考数据落标-CN
            ,certi_type -- 证件类型
            ,certi_no -- 证件号码
            ,birthday -- 生日: yyyy-mm-dd
            ,city -- 所在城市
            ,address -- 地址
            ,vip_card_no -- 会员卡号
            ,bank_card_no -- 银行卡号
            ,lmk_card_no -- 联名卡号
            ,organization -- 银行卡发卡组织
            ,card_level -- 卡等级
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,created_by -- 创建人
            ,updated_by -- 修改人
            ,del_flag -- 删除标志
            ,register_time -- 注册时间
            ,mobile -- 手机
            ,task_date -- 任务日期
            ,bank_card_no_new -- 新银行卡号
            ,lmk_card_no_new -- 新联名卡号
            ,notice_flag -- 0-待通知, 1-通知成功，2-通知失败，3-处理成功，4-处理失败
            ,acti_no -- 活动代码
            ,cust_id -- 客户号
            ,biz_time -- 业务处理时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pk_hrt_lmk_vip_notice -- 主键
    ,o.operate_type -- 操作类型(1-新发卡、4-注销、8-换卡、7、开卡激活活动、10-上月月日均余额活动)
    ,o.merch_code -- 商户编码
    ,o.sys_id -- 系统编号
    ,o.channel_id -- 渠道编码
    ,o.shop_id -- 门店编码
    ,o.refer_no -- 华润通申请流水号
    ,o.uuid -- 请求唯一标识
    ,o.member_name -- 姓名
    ,o.gender -- 性别: 0-女，1-男
    ,o.national -- 国籍: 参考数据落标-CN
    ,o.certi_type -- 证件类型
    ,o.certi_no -- 证件号码
    ,o.birthday -- 生日: yyyy-mm-dd
    ,o.city -- 所在城市
    ,o.address -- 地址
    ,o.vip_card_no -- 会员卡号
    ,o.bank_card_no -- 银行卡号
    ,o.lmk_card_no -- 联名卡号
    ,o.organization -- 银行卡发卡组织
    ,o.card_level -- 卡等级
    ,o.create_time -- 创建时间
    ,o.update_time -- 修改时间
    ,o.created_by -- 创建人
    ,o.updated_by -- 修改人
    ,o.del_flag -- 删除标志
    ,o.register_time -- 注册时间
    ,o.mobile -- 手机
    ,o.task_date -- 任务日期
    ,o.bank_card_no_new -- 新银行卡号
    ,o.lmk_card_no_new -- 新联名卡号
    ,o.notice_flag -- 0-待通知, 1-通知成功，2-通知失败，3-处理成功，4-处理失败
    ,o.acti_no -- 活动代码
    ,o.cust_id -- 客户号
    ,o.biz_time -- 业务处理时间
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
from ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_bk o
    left join ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_op n
        on
            o.pk_hrt_lmk_vip_notice = n.pk_hrt_lmk_vip_notice
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_cl d
        on
            o.pk_hrt_lmk_vip_notice = d.pk_hrt_lmk_vip_notice
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pbms_tbl_hrt_lmk_notice_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info exchange partition p_${batch_date} with table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_cl;
alter table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info exchange partition p_20991231 with table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pbms_tbl_hrt_lmk_notice_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_op purge;
drop table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pbms_tbl_hrt_lmk_notice_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pbms_tbl_hrt_lmk_notice_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
