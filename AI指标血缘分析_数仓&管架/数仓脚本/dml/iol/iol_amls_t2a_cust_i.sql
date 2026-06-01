/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t2a_cust_i
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
create table ${iol_schema}.amls_t2a_cust_i_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amls_t2a_cust_i
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2a_cust_i_op purge;
drop table ${iol_schema}.amls_t2a_cust_i_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2a_cust_i_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2a_cust_i where 0=1;

create table ${iol_schema}.amls_t2a_cust_i_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2a_cust_i where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2a_cust_i_cl(
            cust_id -- 客户编号
            ,org_id -- 归属机构编号
            ,create_dt -- 建立日期
            ,cust_name -- 客户名称
            ,cust_en_name -- 客户英文名称
            ,cust_sts -- 客户状态（参见[字典:AML0078]）
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,aml_cust_type -- AML客户类型（参见[字典:AML0081]）
            ,pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
            ,pbc_ocp -- PBC职业分类
            ,s_ocp -- 源系统职业分类
            ,cust_nat -- 国籍
            ,cust_area -- 地区代码
            ,cert_type -- 证件类型
            ,s_cert_type -- 源系统证件类型
            ,cert_no -- 证件号码
            ,cert_valid_dt -- 证件生效日期
            ,cert_invalid_dt -- 证件失效日期
            ,cert_addr -- 证件地址
            ,home_addr -- 家庭地址
            ,office_addr -- 办公地址
            ,office_tel -- 办公电话
            ,home_tel -- 家庭电话
            ,mobile_phone -- 移动电话
            ,website -- 网址
            ,email -- Email地址
            ,birth_dt -- 出生日期
            ,edu_lvl -- 最高学历（参见[字典:AML0082]）
            ,dgr_lvl -- 最高学位（参见[字典:AML0083]）
            ,gender -- 性别（参见[字典:AML0084]）
            ,duty -- 职务（参见[字典:AML0085]）
            ,indus -- 行业
            ,mgr_id -- 客户经理编号
            ,mgr_name -- 客户经理名称
            ,is_staff -- 是否本行员工（参见[字典:AML0086]）
            ,staff_id -- 员工编号
            ,nation_cd -- 民族编码
            ,unit_name -- 工作单位名称
            ,unit_addr -- 工作单位地址
            ,unit_prop -- 工作单位性质
            ,income_amt -- 收入金额
            ,income_curr_cd -- 收入币种
            ,rsrv_01 -- 备用字段1---放置的是cif潜在客户字段码值
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,is_ebank -- 是否网银客户(0:否,1:是)
            ,is_loan -- 是否贷款客户(0:否,1:是)
            ,create_channel -- 客户创建渠道
            ,is_free_trade -- 是否自贸区客户(0:否,1:是)
            ,remarks -- 备注
            ,close_dt -- 客户号销号日期
            ,is_pos -- 是否我行POS客户
            ,position -- 岗位
            ,oth_cert_type -- 其他证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2a_cust_i_op(
            cust_id -- 客户编号
            ,org_id -- 归属机构编号
            ,create_dt -- 建立日期
            ,cust_name -- 客户名称
            ,cust_en_name -- 客户英文名称
            ,cust_sts -- 客户状态（参见[字典:AML0078]）
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,aml_cust_type -- AML客户类型（参见[字典:AML0081]）
            ,pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
            ,pbc_ocp -- PBC职业分类
            ,s_ocp -- 源系统职业分类
            ,cust_nat -- 国籍
            ,cust_area -- 地区代码
            ,cert_type -- 证件类型
            ,s_cert_type -- 源系统证件类型
            ,cert_no -- 证件号码
            ,cert_valid_dt -- 证件生效日期
            ,cert_invalid_dt -- 证件失效日期
            ,cert_addr -- 证件地址
            ,home_addr -- 家庭地址
            ,office_addr -- 办公地址
            ,office_tel -- 办公电话
            ,home_tel -- 家庭电话
            ,mobile_phone -- 移动电话
            ,website -- 网址
            ,email -- Email地址
            ,birth_dt -- 出生日期
            ,edu_lvl -- 最高学历（参见[字典:AML0082]）
            ,dgr_lvl -- 最高学位（参见[字典:AML0083]）
            ,gender -- 性别（参见[字典:AML0084]）
            ,duty -- 职务（参见[字典:AML0085]）
            ,indus -- 行业
            ,mgr_id -- 客户经理编号
            ,mgr_name -- 客户经理名称
            ,is_staff -- 是否本行员工（参见[字典:AML0086]）
            ,staff_id -- 员工编号
            ,nation_cd -- 民族编码
            ,unit_name -- 工作单位名称
            ,unit_addr -- 工作单位地址
            ,unit_prop -- 工作单位性质
            ,income_amt -- 收入金额
            ,income_curr_cd -- 收入币种
            ,rsrv_01 -- 备用字段1---放置的是cif潜在客户字段码值
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,is_ebank -- 是否网银客户(0:否,1:是)
            ,is_loan -- 是否贷款客户(0:否,1:是)
            ,create_channel -- 客户创建渠道
            ,is_free_trade -- 是否自贸区客户(0:否,1:是)
            ,remarks -- 备注
            ,close_dt -- 客户号销号日期
            ,is_pos -- 是否我行POS客户
            ,position -- 岗位
            ,oth_cert_type -- 其他证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.org_id, o.org_id) as org_id -- 归属机构编号
    ,nvl(n.create_dt, o.create_dt) as create_dt -- 建立日期
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cust_en_name, o.cust_en_name) as cust_en_name -- 客户英文名称
    ,nvl(n.cust_sts, o.cust_sts) as cust_sts -- 客户状态（参见[字典:AML0078]）
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类型（参见[字典:AML0030]）
    ,nvl(n.aml_cust_type, o.aml_cust_type) as aml_cust_type -- AML客户类型（参见[字典:AML0081]）
    ,nvl(n.pbc_cust_type, o.pbc_cust_type) as pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
    ,nvl(n.pbc_ocp, o.pbc_ocp) as pbc_ocp -- PBC职业分类
    ,nvl(n.s_ocp, o.s_ocp) as s_ocp -- 源系统职业分类
    ,nvl(n.cust_nat, o.cust_nat) as cust_nat -- 国籍
    ,nvl(n.cust_area, o.cust_area) as cust_area -- 地区代码
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 证件类型
    ,nvl(n.s_cert_type, o.s_cert_type) as s_cert_type -- 源系统证件类型
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_valid_dt, o.cert_valid_dt) as cert_valid_dt -- 证件生效日期
    ,nvl(n.cert_invalid_dt, o.cert_invalid_dt) as cert_invalid_dt -- 证件失效日期
    ,nvl(n.cert_addr, o.cert_addr) as cert_addr -- 证件地址
    ,nvl(n.home_addr, o.home_addr) as home_addr -- 家庭地址
    ,nvl(n.office_addr, o.office_addr) as office_addr -- 办公地址
    ,nvl(n.office_tel, o.office_tel) as office_tel -- 办公电话
    ,nvl(n.home_tel, o.home_tel) as home_tel -- 家庭电话
    ,nvl(n.mobile_phone, o.mobile_phone) as mobile_phone -- 移动电话
    ,nvl(n.website, o.website) as website -- 网址
    ,nvl(n.email, o.email) as email -- Email地址
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 出生日期
    ,nvl(n.edu_lvl, o.edu_lvl) as edu_lvl -- 最高学历（参见[字典:AML0082]）
    ,nvl(n.dgr_lvl, o.dgr_lvl) as dgr_lvl -- 最高学位（参见[字典:AML0083]）
    ,nvl(n.gender, o.gender) as gender -- 性别（参见[字典:AML0084]）
    ,nvl(n.duty, o.duty) as duty -- 职务（参见[字典:AML0085]）
    ,nvl(n.indus, o.indus) as indus -- 行业
    ,nvl(n.mgr_id, o.mgr_id) as mgr_id -- 客户经理编号
    ,nvl(n.mgr_name, o.mgr_name) as mgr_name -- 客户经理名称
    ,nvl(n.is_staff, o.is_staff) as is_staff -- 是否本行员工（参见[字典:AML0086]）
    ,nvl(n.staff_id, o.staff_id) as staff_id -- 员工编号
    ,nvl(n.nation_cd, o.nation_cd) as nation_cd -- 民族编码
    ,nvl(n.unit_name, o.unit_name) as unit_name -- 工作单位名称
    ,nvl(n.unit_addr, o.unit_addr) as unit_addr -- 工作单位地址
    ,nvl(n.unit_prop, o.unit_prop) as unit_prop -- 工作单位性质
    ,nvl(n.income_amt, o.income_amt) as income_amt -- 收入金额
    ,nvl(n.income_curr_cd, o.income_curr_cd) as income_curr_cd -- 收入币种
    ,nvl(n.rsrv_01, o.rsrv_01) as rsrv_01 -- 备用字段1---放置的是cif潜在客户字段码值
    ,nvl(n.rsrv_02, o.rsrv_02) as rsrv_02 -- 备用字段2
    ,nvl(n.rsrv_03, o.rsrv_03) as rsrv_03 -- 备用字段3
    ,nvl(n.rsrv_04, o.rsrv_04) as rsrv_04 -- 备用字段4
    ,nvl(n.is_ebank, o.is_ebank) as is_ebank -- 是否网银客户(0:否,1:是)
    ,nvl(n.is_loan, o.is_loan) as is_loan -- 是否贷款客户(0:否,1:是)
    ,nvl(n.create_channel, o.create_channel) as create_channel -- 客户创建渠道
    ,nvl(n.is_free_trade, o.is_free_trade) as is_free_trade -- 是否自贸区客户(0:否,1:是)
    ,nvl(n.remarks, o.remarks) as remarks -- 备注
    ,nvl(n.close_dt, o.close_dt) as close_dt -- 客户号销号日期
    ,nvl(n.is_pos, o.is_pos) as is_pos -- 是否我行POS客户
    ,nvl(n.position, o.position) as position -- 岗位
    ,nvl(n.oth_cert_type, o.oth_cert_type) as oth_cert_type -- 其他证件类型
    ,case when
            n.cust_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cust_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cust_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amls_t2a_cust_i_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amls_t2a_cust_i where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cust_id = n.cust_id
where (
        o.cust_id is null
    )
    or (
        n.cust_id is null
    )
    or (
        o.org_id <> n.org_id
        or o.create_dt <> n.create_dt
        or o.cust_name <> n.cust_name
        or o.cust_en_name <> n.cust_en_name
        or o.cust_sts <> n.cust_sts
        or o.cust_type <> n.cust_type
        or o.aml_cust_type <> n.aml_cust_type
        or o.pbc_cust_type <> n.pbc_cust_type
        or o.pbc_ocp <> n.pbc_ocp
        or o.s_ocp <> n.s_ocp
        or o.cust_nat <> n.cust_nat
        or o.cust_area <> n.cust_area
        or o.cert_type <> n.cert_type
        or o.s_cert_type <> n.s_cert_type
        or o.cert_no <> n.cert_no
        or o.cert_valid_dt <> n.cert_valid_dt
        or o.cert_invalid_dt <> n.cert_invalid_dt
        or o.cert_addr <> n.cert_addr
        or o.home_addr <> n.home_addr
        or o.office_addr <> n.office_addr
        or o.office_tel <> n.office_tel
        or o.home_tel <> n.home_tel
        or o.mobile_phone <> n.mobile_phone
        or o.website <> n.website
        or o.email <> n.email
        or o.birth_dt <> n.birth_dt
        or o.edu_lvl <> n.edu_lvl
        or o.dgr_lvl <> n.dgr_lvl
        or o.gender <> n.gender
        or o.duty <> n.duty
        or o.indus <> n.indus
        or o.mgr_id <> n.mgr_id
        or o.mgr_name <> n.mgr_name
        or o.is_staff <> n.is_staff
        or o.staff_id <> n.staff_id
        or o.nation_cd <> n.nation_cd
        or o.unit_name <> n.unit_name
        or o.unit_addr <> n.unit_addr
        or o.unit_prop <> n.unit_prop
        or o.income_amt <> n.income_amt
        or o.income_curr_cd <> n.income_curr_cd
        or o.rsrv_01 <> n.rsrv_01
        or o.rsrv_02 <> n.rsrv_02
        or o.rsrv_03 <> n.rsrv_03
        or o.rsrv_04 <> n.rsrv_04
        or o.is_ebank <> n.is_ebank
        or o.is_loan <> n.is_loan
        or o.create_channel <> n.create_channel
        or o.is_free_trade <> n.is_free_trade
        or o.remarks <> n.remarks
        or o.close_dt <> n.close_dt
        or o.is_pos <> n.is_pos
        or o.position <> n.position
        or o.oth_cert_type <> n.oth_cert_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2a_cust_i_cl(
            cust_id -- 客户编号
            ,org_id -- 归属机构编号
            ,create_dt -- 建立日期
            ,cust_name -- 客户名称
            ,cust_en_name -- 客户英文名称
            ,cust_sts -- 客户状态（参见[字典:AML0078]）
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,aml_cust_type -- AML客户类型（参见[字典:AML0081]）
            ,pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
            ,pbc_ocp -- PBC职业分类
            ,s_ocp -- 源系统职业分类
            ,cust_nat -- 国籍
            ,cust_area -- 地区代码
            ,cert_type -- 证件类型
            ,s_cert_type -- 源系统证件类型
            ,cert_no -- 证件号码
            ,cert_valid_dt -- 证件生效日期
            ,cert_invalid_dt -- 证件失效日期
            ,cert_addr -- 证件地址
            ,home_addr -- 家庭地址
            ,office_addr -- 办公地址
            ,office_tel -- 办公电话
            ,home_tel -- 家庭电话
            ,mobile_phone -- 移动电话
            ,website -- 网址
            ,email -- Email地址
            ,birth_dt -- 出生日期
            ,edu_lvl -- 最高学历（参见[字典:AML0082]）
            ,dgr_lvl -- 最高学位（参见[字典:AML0083]）
            ,gender -- 性别（参见[字典:AML0084]）
            ,duty -- 职务（参见[字典:AML0085]）
            ,indus -- 行业
            ,mgr_id -- 客户经理编号
            ,mgr_name -- 客户经理名称
            ,is_staff -- 是否本行员工（参见[字典:AML0086]）
            ,staff_id -- 员工编号
            ,nation_cd -- 民族编码
            ,unit_name -- 工作单位名称
            ,unit_addr -- 工作单位地址
            ,unit_prop -- 工作单位性质
            ,income_amt -- 收入金额
            ,income_curr_cd -- 收入币种
            ,rsrv_01 -- 备用字段1---放置的是cif潜在客户字段码值
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,is_ebank -- 是否网银客户(0:否,1:是)
            ,is_loan -- 是否贷款客户(0:否,1:是)
            ,create_channel -- 客户创建渠道
            ,is_free_trade -- 是否自贸区客户(0:否,1:是)
            ,remarks -- 备注
            ,close_dt -- 客户号销号日期
            ,is_pos -- 是否我行POS客户
            ,position -- 岗位
            ,oth_cert_type -- 其他证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2a_cust_i_op(
            cust_id -- 客户编号
            ,org_id -- 归属机构编号
            ,create_dt -- 建立日期
            ,cust_name -- 客户名称
            ,cust_en_name -- 客户英文名称
            ,cust_sts -- 客户状态（参见[字典:AML0078]）
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,aml_cust_type -- AML客户类型（参见[字典:AML0081]）
            ,pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
            ,pbc_ocp -- PBC职业分类
            ,s_ocp -- 源系统职业分类
            ,cust_nat -- 国籍
            ,cust_area -- 地区代码
            ,cert_type -- 证件类型
            ,s_cert_type -- 源系统证件类型
            ,cert_no -- 证件号码
            ,cert_valid_dt -- 证件生效日期
            ,cert_invalid_dt -- 证件失效日期
            ,cert_addr -- 证件地址
            ,home_addr -- 家庭地址
            ,office_addr -- 办公地址
            ,office_tel -- 办公电话
            ,home_tel -- 家庭电话
            ,mobile_phone -- 移动电话
            ,website -- 网址
            ,email -- Email地址
            ,birth_dt -- 出生日期
            ,edu_lvl -- 最高学历（参见[字典:AML0082]）
            ,dgr_lvl -- 最高学位（参见[字典:AML0083]）
            ,gender -- 性别（参见[字典:AML0084]）
            ,duty -- 职务（参见[字典:AML0085]）
            ,indus -- 行业
            ,mgr_id -- 客户经理编号
            ,mgr_name -- 客户经理名称
            ,is_staff -- 是否本行员工（参见[字典:AML0086]）
            ,staff_id -- 员工编号
            ,nation_cd -- 民族编码
            ,unit_name -- 工作单位名称
            ,unit_addr -- 工作单位地址
            ,unit_prop -- 工作单位性质
            ,income_amt -- 收入金额
            ,income_curr_cd -- 收入币种
            ,rsrv_01 -- 备用字段1---放置的是cif潜在客户字段码值
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,is_ebank -- 是否网银客户(0:否,1:是)
            ,is_loan -- 是否贷款客户(0:否,1:是)
            ,create_channel -- 客户创建渠道
            ,is_free_trade -- 是否自贸区客户(0:否,1:是)
            ,remarks -- 备注
            ,close_dt -- 客户号销号日期
            ,is_pos -- 是否我行POS客户
            ,position -- 岗位
            ,oth_cert_type -- 其他证件类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cust_id -- 客户编号
    ,o.org_id -- 归属机构编号
    ,o.create_dt -- 建立日期
    ,o.cust_name -- 客户名称
    ,o.cust_en_name -- 客户英文名称
    ,o.cust_sts -- 客户状态（参见[字典:AML0078]）
    ,o.cust_type -- 客户类型（参见[字典:AML0030]）
    ,o.aml_cust_type -- AML客户类型（参见[字典:AML0081]）
    ,o.pbc_cust_type -- PBC客户类型（参见[字典:AML0043]）
    ,o.pbc_ocp -- PBC职业分类
    ,o.s_ocp -- 源系统职业分类
    ,o.cust_nat -- 国籍
    ,o.cust_area -- 地区代码
    ,o.cert_type -- 证件类型
    ,o.s_cert_type -- 源系统证件类型
    ,o.cert_no -- 证件号码
    ,o.cert_valid_dt -- 证件生效日期
    ,o.cert_invalid_dt -- 证件失效日期
    ,o.cert_addr -- 证件地址
    ,o.home_addr -- 家庭地址
    ,o.office_addr -- 办公地址
    ,o.office_tel -- 办公电话
    ,o.home_tel -- 家庭电话
    ,o.mobile_phone -- 移动电话
    ,o.website -- 网址
    ,o.email -- Email地址
    ,o.birth_dt -- 出生日期
    ,o.edu_lvl -- 最高学历（参见[字典:AML0082]）
    ,o.dgr_lvl -- 最高学位（参见[字典:AML0083]）
    ,o.gender -- 性别（参见[字典:AML0084]）
    ,o.duty -- 职务（参见[字典:AML0085]）
    ,o.indus -- 行业
    ,o.mgr_id -- 客户经理编号
    ,o.mgr_name -- 客户经理名称
    ,o.is_staff -- 是否本行员工（参见[字典:AML0086]）
    ,o.staff_id -- 员工编号
    ,o.nation_cd -- 民族编码
    ,o.unit_name -- 工作单位名称
    ,o.unit_addr -- 工作单位地址
    ,o.unit_prop -- 工作单位性质
    ,o.income_amt -- 收入金额
    ,o.income_curr_cd -- 收入币种
    ,o.rsrv_01 -- 备用字段1---放置的是cif潜在客户字段码值
    ,o.rsrv_02 -- 备用字段2
    ,o.rsrv_03 -- 备用字段3
    ,o.rsrv_04 -- 备用字段4
    ,o.is_ebank -- 是否网银客户(0:否,1:是)
    ,o.is_loan -- 是否贷款客户(0:否,1:是)
    ,o.create_channel -- 客户创建渠道
    ,o.is_free_trade -- 是否自贸区客户(0:否,1:是)
    ,o.remarks -- 备注
    ,o.close_dt -- 客户号销号日期
    ,o.is_pos -- 是否我行POS客户
    ,o.position -- 岗位
    ,o.oth_cert_type -- 其他证件类型
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
from ${iol_schema}.amls_t2a_cust_i_bk o
    left join ${iol_schema}.amls_t2a_cust_i_op n
        on
            o.cust_id = n.cust_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amls_t2a_cust_i_cl d
        on
            o.cust_id = d.cust_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amls_t2a_cust_i;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amls_t2a_cust_i') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amls_t2a_cust_i drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amls_t2a_cust_i add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amls_t2a_cust_i exchange partition p_${batch_date} with table ${iol_schema}.amls_t2a_cust_i_cl;
alter table ${iol_schema}.amls_t2a_cust_i exchange partition p_20991231 with table ${iol_schema}.amls_t2a_cust_i_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t2a_cust_i to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2a_cust_i_op purge;
drop table ${iol_schema}.amls_t2a_cust_i_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amls_t2a_cust_i_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t2a_cust_i',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
