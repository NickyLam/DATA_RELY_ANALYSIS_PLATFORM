/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_institution
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
create table ${iol_schema}.ibms_ttrd_institution_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_institution
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_institution_op purge;
drop table ${iol_schema}.ibms_ttrd_institution_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_institution_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_institution where 0=1;

create table ${iol_schema}.ibms_ttrd_institution_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_institution where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_institution_cl(
            i_id -- 机构ID
            ,org_id -- 机构号
            ,i_name -- 公司名称
            ,i_fullname -- 公司全称
            ,i_alias -- 公司别名
            ,py_code -- 拼音码
            ,status -- 状态 0 创建中 1 以启用 2 停用
            ,t_code -- 分类代码(对机构进行多级分类)
            ,p_type -- 产品类型
            ,online_date -- 成立日期
            ,i_business_license -- 营业执照
            ,i_lr_inst_code -- 机构代码证
            ,i_financial_license -- 金融许可证
            ,cnaps_code -- 现代支付系统行号(本币)
            ,swift_code -- 现代支付系统行号(外币)
            ,update_user -- 更新用户
            ,update_date -- 更新日期
            ,update_time -- 更新时间
            ,belong_to_area -- 总行或总公司注册地
            ,pipe_id -- 导入管道
            ,imp_date -- 导入日期
            ,core_sys_customer_code -- 核心客户号
            ,t_path -- 客户分类
            ,i_level -- 机构层级
            ,edit_iid -- 维护机构
            ,edit_iname -- 维护机构名称
            ,issuer_code -- 发行代码
            ,cfets_member_id -- 外汇交易中心会员号
            ,inst_class -- 客户类型
            ,member_id -- 中心会员id
            ,is_market_maker -- 1:做市商 0:非做市商
            ,rev_state -- 是否生效
            ,en_name -- 英文简称
            ,en_fullname -- 英文全称
            ,cfets_org_code -- 下行机构代码
            ,create_user -- 创建用户
            ,acctg_i_id -- 记账机构
            ,is_spv -- 是否是SPV  0：非SPV（默认） 1: SPV
            ,rwa_code -- rwa客户分类代码
            ,rwa_name -- rwa客户分类名称
            ,spv_manager -- spv管理人
            ,address -- 
            ,legal_representative -- 
            ,is_ticketinfo -- 
            ,main_protocol_code -- 
            ,i_level_m -- 机构级别,数据标准落标,触发器添加
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_institution_op(
            i_id -- 机构ID
            ,org_id -- 机构号
            ,i_name -- 公司名称
            ,i_fullname -- 公司全称
            ,i_alias -- 公司别名
            ,py_code -- 拼音码
            ,status -- 状态 0 创建中 1 以启用 2 停用
            ,t_code -- 分类代码(对机构进行多级分类)
            ,p_type -- 产品类型
            ,online_date -- 成立日期
            ,i_business_license -- 营业执照
            ,i_lr_inst_code -- 机构代码证
            ,i_financial_license -- 金融许可证
            ,cnaps_code -- 现代支付系统行号(本币)
            ,swift_code -- 现代支付系统行号(外币)
            ,update_user -- 更新用户
            ,update_date -- 更新日期
            ,update_time -- 更新时间
            ,belong_to_area -- 总行或总公司注册地
            ,pipe_id -- 导入管道
            ,imp_date -- 导入日期
            ,core_sys_customer_code -- 核心客户号
            ,t_path -- 客户分类
            ,i_level -- 机构层级
            ,edit_iid -- 维护机构
            ,edit_iname -- 维护机构名称
            ,issuer_code -- 发行代码
            ,cfets_member_id -- 外汇交易中心会员号
            ,inst_class -- 客户类型
            ,member_id -- 中心会员id
            ,is_market_maker -- 1:做市商 0:非做市商
            ,rev_state -- 是否生效
            ,en_name -- 英文简称
            ,en_fullname -- 英文全称
            ,cfets_org_code -- 下行机构代码
            ,create_user -- 创建用户
            ,acctg_i_id -- 记账机构
            ,is_spv -- 是否是SPV  0：非SPV（默认） 1: SPV
            ,rwa_code -- rwa客户分类代码
            ,rwa_name -- rwa客户分类名称
            ,spv_manager -- spv管理人
            ,address -- 
            ,legal_representative -- 
            ,is_ticketinfo -- 
            ,main_protocol_code -- 
            ,i_level_m -- 机构级别,数据标准落标,触发器添加
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_id, o.i_id) as i_id -- 机构ID
    ,nvl(n.org_id, o.org_id) as org_id -- 机构号
    ,nvl(n.i_name, o.i_name) as i_name -- 公司名称
    ,nvl(n.i_fullname, o.i_fullname) as i_fullname -- 公司全称
    ,nvl(n.i_alias, o.i_alias) as i_alias -- 公司别名
    ,nvl(n.py_code, o.py_code) as py_code -- 拼音码
    ,nvl(n.status, o.status) as status -- 状态 0 创建中 1 以启用 2 停用
    ,nvl(n.t_code, o.t_code) as t_code -- 分类代码(对机构进行多级分类)
    ,nvl(n.p_type, o.p_type) as p_type -- 产品类型
    ,nvl(n.online_date, o.online_date) as online_date -- 成立日期
    ,nvl(n.i_business_license, o.i_business_license) as i_business_license -- 营业执照
    ,nvl(n.i_lr_inst_code, o.i_lr_inst_code) as i_lr_inst_code -- 机构代码证
    ,nvl(n.i_financial_license, o.i_financial_license) as i_financial_license -- 金融许可证
    ,nvl(n.cnaps_code, o.cnaps_code) as cnaps_code -- 现代支付系统行号(本币)
    ,nvl(n.swift_code, o.swift_code) as swift_code -- 现代支付系统行号(外币)
    ,nvl(n.update_user, o.update_user) as update_user -- 更新用户
    ,nvl(n.update_date, o.update_date) as update_date -- 更新日期
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.belong_to_area, o.belong_to_area) as belong_to_area -- 总行或总公司注册地
    ,nvl(n.pipe_id, o.pipe_id) as pipe_id -- 导入管道
    ,nvl(n.imp_date, o.imp_date) as imp_date -- 导入日期
    ,nvl(n.core_sys_customer_code, o.core_sys_customer_code) as core_sys_customer_code -- 核心客户号
    ,nvl(n.t_path, o.t_path) as t_path -- 客户分类
    ,nvl(n.i_level, o.i_level) as i_level -- 机构层级
    ,nvl(n.edit_iid, o.edit_iid) as edit_iid -- 维护机构
    ,nvl(n.edit_iname, o.edit_iname) as edit_iname -- 维护机构名称
    ,nvl(n.issuer_code, o.issuer_code) as issuer_code -- 发行代码
    ,nvl(n.cfets_member_id, o.cfets_member_id) as cfets_member_id -- 外汇交易中心会员号
    ,nvl(n.inst_class, o.inst_class) as inst_class -- 客户类型
    ,nvl(n.member_id, o.member_id) as member_id -- 中心会员id
    ,nvl(n.is_market_maker, o.is_market_maker) as is_market_maker -- 1:做市商 0:非做市商
    ,nvl(n.rev_state, o.rev_state) as rev_state -- 是否生效
    ,nvl(n.en_name, o.en_name) as en_name -- 英文简称
    ,nvl(n.en_fullname, o.en_fullname) as en_fullname -- 英文全称
    ,nvl(n.cfets_org_code, o.cfets_org_code) as cfets_org_code -- 下行机构代码
    ,nvl(n.create_user, o.create_user) as create_user -- 创建用户
    ,nvl(n.acctg_i_id, o.acctg_i_id) as acctg_i_id -- 记账机构
    ,nvl(n.is_spv, o.is_spv) as is_spv -- 是否是SPV  0：非SPV（默认） 1: SPV
    ,nvl(n.rwa_code, o.rwa_code) as rwa_code -- rwa客户分类代码
    ,nvl(n.rwa_name, o.rwa_name) as rwa_name -- rwa客户分类名称
    ,nvl(n.spv_manager, o.spv_manager) as spv_manager -- spv管理人
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.legal_representative, o.legal_representative) as legal_representative -- 
    ,nvl(n.is_ticketinfo, o.is_ticketinfo) as is_ticketinfo -- 
    ,nvl(n.main_protocol_code, o.main_protocol_code) as main_protocol_code -- 
    ,nvl(n.i_level_m, o.i_level_m) as i_level_m -- 机构级别,数据标准落标,触发器添加
    ,case when
            n.i_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_institution_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_institution where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_id = n.i_id
where (
        o.i_id is null
    )
    or (
        n.i_id is null
    )
    or (
        o.org_id <> n.org_id
        or o.i_name <> n.i_name
        or o.i_fullname <> n.i_fullname
        or o.i_alias <> n.i_alias
        or o.py_code <> n.py_code
        or o.status <> n.status
        or o.t_code <> n.t_code
        or o.p_type <> n.p_type
        or o.online_date <> n.online_date
        or o.i_business_license <> n.i_business_license
        or o.i_lr_inst_code <> n.i_lr_inst_code
        or o.i_financial_license <> n.i_financial_license
        or o.cnaps_code <> n.cnaps_code
        or o.swift_code <> n.swift_code
        or o.update_user <> n.update_user
        or o.update_date <> n.update_date
        or o.update_time <> n.update_time
        or o.belong_to_area <> n.belong_to_area
        or o.pipe_id <> n.pipe_id
        or o.imp_date <> n.imp_date
        or o.core_sys_customer_code <> n.core_sys_customer_code
        or o.t_path <> n.t_path
        or o.i_level <> n.i_level
        or o.edit_iid <> n.edit_iid
        or o.edit_iname <> n.edit_iname
        or o.issuer_code <> n.issuer_code
        or o.cfets_member_id <> n.cfets_member_id
        or o.inst_class <> n.inst_class
        or o.member_id <> n.member_id
        or o.is_market_maker <> n.is_market_maker
        or o.rev_state <> n.rev_state
        or o.en_name <> n.en_name
        or o.en_fullname <> n.en_fullname
        or o.cfets_org_code <> n.cfets_org_code
        or o.create_user <> n.create_user
        or o.acctg_i_id <> n.acctg_i_id
        or o.is_spv <> n.is_spv
        or o.rwa_code <> n.rwa_code
        or o.rwa_name <> n.rwa_name
        or o.spv_manager <> n.spv_manager
        or o.address <> n.address
        or o.legal_representative <> n.legal_representative
        or o.is_ticketinfo <> n.is_ticketinfo
        or o.main_protocol_code <> n.main_protocol_code
        or o.i_level_m <> n.i_level_m
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_institution_cl(
            i_id -- 机构ID
            ,org_id -- 机构号
            ,i_name -- 公司名称
            ,i_fullname -- 公司全称
            ,i_alias -- 公司别名
            ,py_code -- 拼音码
            ,status -- 状态 0 创建中 1 以启用 2 停用
            ,t_code -- 分类代码(对机构进行多级分类)
            ,p_type -- 产品类型
            ,online_date -- 成立日期
            ,i_business_license -- 营业执照
            ,i_lr_inst_code -- 机构代码证
            ,i_financial_license -- 金融许可证
            ,cnaps_code -- 现代支付系统行号(本币)
            ,swift_code -- 现代支付系统行号(外币)
            ,update_user -- 更新用户
            ,update_date -- 更新日期
            ,update_time -- 更新时间
            ,belong_to_area -- 总行或总公司注册地
            ,pipe_id -- 导入管道
            ,imp_date -- 导入日期
            ,core_sys_customer_code -- 核心客户号
            ,t_path -- 客户分类
            ,i_level -- 机构层级
            ,edit_iid -- 维护机构
            ,edit_iname -- 维护机构名称
            ,issuer_code -- 发行代码
            ,cfets_member_id -- 外汇交易中心会员号
            ,inst_class -- 客户类型
            ,member_id -- 中心会员id
            ,is_market_maker -- 1:做市商 0:非做市商
            ,rev_state -- 是否生效
            ,en_name -- 英文简称
            ,en_fullname -- 英文全称
            ,cfets_org_code -- 下行机构代码
            ,create_user -- 创建用户
            ,acctg_i_id -- 记账机构
            ,is_spv -- 是否是SPV  0：非SPV（默认） 1: SPV
            ,rwa_code -- rwa客户分类代码
            ,rwa_name -- rwa客户分类名称
            ,spv_manager -- spv管理人
            ,address -- 
            ,legal_representative -- 
            ,is_ticketinfo -- 
            ,main_protocol_code -- 
            ,i_level_m -- 机构级别,数据标准落标,触发器添加
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_institution_op(
            i_id -- 机构ID
            ,org_id -- 机构号
            ,i_name -- 公司名称
            ,i_fullname -- 公司全称
            ,i_alias -- 公司别名
            ,py_code -- 拼音码
            ,status -- 状态 0 创建中 1 以启用 2 停用
            ,t_code -- 分类代码(对机构进行多级分类)
            ,p_type -- 产品类型
            ,online_date -- 成立日期
            ,i_business_license -- 营业执照
            ,i_lr_inst_code -- 机构代码证
            ,i_financial_license -- 金融许可证
            ,cnaps_code -- 现代支付系统行号(本币)
            ,swift_code -- 现代支付系统行号(外币)
            ,update_user -- 更新用户
            ,update_date -- 更新日期
            ,update_time -- 更新时间
            ,belong_to_area -- 总行或总公司注册地
            ,pipe_id -- 导入管道
            ,imp_date -- 导入日期
            ,core_sys_customer_code -- 核心客户号
            ,t_path -- 客户分类
            ,i_level -- 机构层级
            ,edit_iid -- 维护机构
            ,edit_iname -- 维护机构名称
            ,issuer_code -- 发行代码
            ,cfets_member_id -- 外汇交易中心会员号
            ,inst_class -- 客户类型
            ,member_id -- 中心会员id
            ,is_market_maker -- 1:做市商 0:非做市商
            ,rev_state -- 是否生效
            ,en_name -- 英文简称
            ,en_fullname -- 英文全称
            ,cfets_org_code -- 下行机构代码
            ,create_user -- 创建用户
            ,acctg_i_id -- 记账机构
            ,is_spv -- 是否是SPV  0：非SPV（默认） 1: SPV
            ,rwa_code -- rwa客户分类代码
            ,rwa_name -- rwa客户分类名称
            ,spv_manager -- spv管理人
            ,address -- 
            ,legal_representative -- 
            ,is_ticketinfo -- 
            ,main_protocol_code -- 
            ,i_level_m -- 机构级别,数据标准落标,触发器添加
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_id -- 机构ID
    ,o.org_id -- 机构号
    ,o.i_name -- 公司名称
    ,o.i_fullname -- 公司全称
    ,o.i_alias -- 公司别名
    ,o.py_code -- 拼音码
    ,o.status -- 状态 0 创建中 1 以启用 2 停用
    ,o.t_code -- 分类代码(对机构进行多级分类)
    ,o.p_type -- 产品类型
    ,o.online_date -- 成立日期
    ,o.i_business_license -- 营业执照
    ,o.i_lr_inst_code -- 机构代码证
    ,o.i_financial_license -- 金融许可证
    ,o.cnaps_code -- 现代支付系统行号(本币)
    ,o.swift_code -- 现代支付系统行号(外币)
    ,o.update_user -- 更新用户
    ,o.update_date -- 更新日期
    ,o.update_time -- 更新时间
    ,o.belong_to_area -- 总行或总公司注册地
    ,o.pipe_id -- 导入管道
    ,o.imp_date -- 导入日期
    ,o.core_sys_customer_code -- 核心客户号
    ,o.t_path -- 客户分类
    ,o.i_level -- 机构层级
    ,o.edit_iid -- 维护机构
    ,o.edit_iname -- 维护机构名称
    ,o.issuer_code -- 发行代码
    ,o.cfets_member_id -- 外汇交易中心会员号
    ,o.inst_class -- 客户类型
    ,o.member_id -- 中心会员id
    ,o.is_market_maker -- 1:做市商 0:非做市商
    ,o.rev_state -- 是否生效
    ,o.en_name -- 英文简称
    ,o.en_fullname -- 英文全称
    ,o.cfets_org_code -- 下行机构代码
    ,o.create_user -- 创建用户
    ,o.acctg_i_id -- 记账机构
    ,o.is_spv -- 是否是SPV  0：非SPV（默认） 1: SPV
    ,o.rwa_code -- rwa客户分类代码
    ,o.rwa_name -- rwa客户分类名称
    ,o.spv_manager -- spv管理人
    ,o.address -- 
    ,o.legal_representative -- 
    ,o.is_ticketinfo -- 
    ,o.main_protocol_code -- 
    ,o.i_level_m -- 机构级别,数据标准落标,触发器添加
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
from ${iol_schema}.ibms_ttrd_institution_bk o
    left join ${iol_schema}.ibms_ttrd_institution_op n
        on
            o.i_id = n.i_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_institution_cl d
        on
            o.i_id = d.i_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_ttrd_institution;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_institution') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_institution drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_institution add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_institution exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_institution_cl;
alter table ${iol_schema}.ibms_ttrd_institution exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_institution_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_institution to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_institution_op purge;
drop table ${iol_schema}.ibms_ttrd_institution_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_institution_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_institution',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
