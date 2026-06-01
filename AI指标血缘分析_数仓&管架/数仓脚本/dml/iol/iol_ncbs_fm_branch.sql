/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_branch
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
create table ${iol_schema}.ncbs_fm_branch_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_branch
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_branch_op purge;
drop table ${iol_schema}.ncbs_fm_branch_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_branch_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_branch where 0=1;

create table ${iol_schema}.ncbs_fm_branch_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_branch where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_branch_cl(
            area_code -- 地区码
            ,branch -- 机构编号
            ,branch_name -- 银行机构名称
            ,country -- 国家
            ,profit_center -- 利润中心
            ,abnormal_open_control -- 非正常时间开门控制方式
            ,auth_flag -- 授权标志
            ,branch_short -- 机构简称
            ,branch_status -- 机构开关门状态
            ,branch_type -- 机构类型
            ,cheque_issuing_branch_flag -- 是否签发支票
            ,city -- 行政区划(城市)
            ,company -- 法人
            ,default_teller_login -- 默认柜员登录认证方式
            ,district -- 区号
            ,eod_flag -- 日终标识
            ,fta_code -- 自贸区代码
            ,fta_flag -- 是否自贸区机构
            ,fx_organ_code -- 外汇金融机构代码
            ,index_str -- 索引字符串
            ,int_tax_levy -- 利息税征收标志
            ,ip_addr -- 机构ip地址
            ,oper_max_level -- 操作最高级别
            ,pboc_fund_check_flag -- 人行备付金检查标志
            ,postal_code -- 邮政编码
            ,state -- 行政区划(省、州)
            ,surtax_type -- 附加税类型
            ,tailbox_detach_flag -- 尾箱控制方式
            ,voucher_user_contral_flag -- 是否限制凭证入库柜员
            ,accounting_branch -- 核算机构
            ,libra_op_time -- libra执行次数
            ,create_date -- 创建日期
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,attached_to -- 所属上级
            ,base_ccy -- 基础币种
            ,ccy_ctrl_branch -- 结售汇平盘机构
            ,cny_business_unit -- 账套(人民币)
            ,hierarchy_code -- 机构级别
            ,hkd_business_unit -- 账套(港币)
            ,internal_client -- 内部客户号
            ,local_ccy -- 当地币种
            ,sub_branch_code -- 分行代码
            ,tax_rpt_branch -- 税收机构（总账用）
            ,tran_br_ind -- 是否交易机构
            ,accounting_branch_flag -- 是否核算机构
            ,normal_close_time -- 正常关门时间
            ,normal_open_time -- 正常开门时间
            ,pboc_financing_no -- 人行金融机构编码
            ,branch_en_short -- 机构英文简称
            ,branch_head_phone -- 机构负责人联系电话
            ,pboc_pay_branch_no -- 人行支付行号
            ,is_auto_create_internal_acct -- 是否自动开立内部户
            ,branch_en_name -- 机构英文名称
            ,pboc_area_code -- 人行地区代码
            ,branch_head_name -- 机构负责人姓名
            ,branch_close_date -- 关闭日期
            ,branch_head_duty -- 机构负责人职务
            ,swift_no -- swift号
            ,cup_financing_no -- 银联金融机构编号
            ,pboc_acct_manage_sys_no -- 人行账户管理系统行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_branch_op(
            area_code -- 地区码
            ,branch -- 机构编号
            ,branch_name -- 银行机构名称
            ,country -- 国家
            ,profit_center -- 利润中心
            ,abnormal_open_control -- 非正常时间开门控制方式
            ,auth_flag -- 授权标志
            ,branch_short -- 机构简称
            ,branch_status -- 机构开关门状态
            ,branch_type -- 机构类型
            ,cheque_issuing_branch_flag -- 是否签发支票
            ,city -- 行政区划(城市)
            ,company -- 法人
            ,default_teller_login -- 默认柜员登录认证方式
            ,district -- 区号
            ,eod_flag -- 日终标识
            ,fta_code -- 自贸区代码
            ,fta_flag -- 是否自贸区机构
            ,fx_organ_code -- 外汇金融机构代码
            ,index_str -- 索引字符串
            ,int_tax_levy -- 利息税征收标志
            ,ip_addr -- 机构ip地址
            ,oper_max_level -- 操作最高级别
            ,pboc_fund_check_flag -- 人行备付金检查标志
            ,postal_code -- 邮政编码
            ,state -- 行政区划(省、州)
            ,surtax_type -- 附加税类型
            ,tailbox_detach_flag -- 尾箱控制方式
            ,voucher_user_contral_flag -- 是否限制凭证入库柜员
            ,accounting_branch -- 核算机构
            ,libra_op_time -- libra执行次数
            ,create_date -- 创建日期
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,attached_to -- 所属上级
            ,base_ccy -- 基础币种
            ,ccy_ctrl_branch -- 结售汇平盘机构
            ,cny_business_unit -- 账套(人民币)
            ,hierarchy_code -- 机构级别
            ,hkd_business_unit -- 账套(港币)
            ,internal_client -- 内部客户号
            ,local_ccy -- 当地币种
            ,sub_branch_code -- 分行代码
            ,tax_rpt_branch -- 税收机构（总账用）
            ,tran_br_ind -- 是否交易机构
            ,accounting_branch_flag -- 是否核算机构
            ,normal_close_time -- 正常关门时间
            ,normal_open_time -- 正常开门时间
            ,pboc_financing_no -- 人行金融机构编码
            ,branch_en_short -- 机构英文简称
            ,branch_head_phone -- 机构负责人联系电话
            ,pboc_pay_branch_no -- 人行支付行号
            ,is_auto_create_internal_acct -- 是否自动开立内部户
            ,branch_en_name -- 机构英文名称
            ,pboc_area_code -- 人行地区代码
            ,branch_head_name -- 机构负责人姓名
            ,branch_close_date -- 关闭日期
            ,branch_head_duty -- 机构负责人职务
            ,swift_no -- swift号
            ,cup_financing_no -- 银联金融机构编号
            ,pboc_acct_manage_sys_no -- 人行账户管理系统行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.area_code, o.area_code) as area_code -- 地区码
    ,nvl(n.branch, o.branch) as branch -- 机构编号
    ,nvl(n.branch_name, o.branch_name) as branch_name -- 银行机构名称
    ,nvl(n.country, o.country) as country -- 国家
    ,nvl(n.profit_center, o.profit_center) as profit_center -- 利润中心
    ,nvl(n.abnormal_open_control, o.abnormal_open_control) as abnormal_open_control -- 非正常时间开门控制方式
    ,nvl(n.auth_flag, o.auth_flag) as auth_flag -- 授权标志
    ,nvl(n.branch_short, o.branch_short) as branch_short -- 机构简称
    ,nvl(n.branch_status, o.branch_status) as branch_status -- 机构开关门状态
    ,nvl(n.branch_type, o.branch_type) as branch_type -- 机构类型
    ,nvl(n.cheque_issuing_branch_flag, o.cheque_issuing_branch_flag) as cheque_issuing_branch_flag -- 是否签发支票
    ,nvl(n.city, o.city) as city -- 行政区划(城市)
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.default_teller_login, o.default_teller_login) as default_teller_login -- 默认柜员登录认证方式
    ,nvl(n.district, o.district) as district -- 区号
    ,nvl(n.eod_flag, o.eod_flag) as eod_flag -- 日终标识
    ,nvl(n.fta_code, o.fta_code) as fta_code -- 自贸区代码
    ,nvl(n.fta_flag, o.fta_flag) as fta_flag -- 是否自贸区机构
    ,nvl(n.fx_organ_code, o.fx_organ_code) as fx_organ_code -- 外汇金融机构代码
    ,nvl(n.index_str, o.index_str) as index_str -- 索引字符串
    ,nvl(n.int_tax_levy, o.int_tax_levy) as int_tax_levy -- 利息税征收标志
    ,nvl(n.ip_addr, o.ip_addr) as ip_addr -- 机构ip地址
    ,nvl(n.oper_max_level, o.oper_max_level) as oper_max_level -- 操作最高级别
    ,nvl(n.pboc_fund_check_flag, o.pboc_fund_check_flag) as pboc_fund_check_flag -- 人行备付金检查标志
    ,nvl(n.postal_code, o.postal_code) as postal_code -- 邮政编码
    ,nvl(n.state, o.state) as state -- 行政区划(省、州)
    ,nvl(n.surtax_type, o.surtax_type) as surtax_type -- 附加税类型
    ,nvl(n.tailbox_detach_flag, o.tailbox_detach_flag) as tailbox_detach_flag -- 尾箱控制方式
    ,nvl(n.voucher_user_contral_flag, o.voucher_user_contral_flag) as voucher_user_contral_flag -- 是否限制凭证入库柜员
    ,nvl(n.accounting_branch, o.accounting_branch) as accounting_branch -- 核算机构
    ,nvl(n.libra_op_time, o.libra_op_time) as libra_op_time -- libra执行次数
    ,nvl(n.create_date, o.create_date) as create_date -- 创建日期
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.attached_to, o.attached_to) as attached_to -- 所属上级
    ,nvl(n.base_ccy, o.base_ccy) as base_ccy -- 基础币种
    ,nvl(n.ccy_ctrl_branch, o.ccy_ctrl_branch) as ccy_ctrl_branch -- 结售汇平盘机构
    ,nvl(n.cny_business_unit, o.cny_business_unit) as cny_business_unit -- 账套(人民币)
    ,nvl(n.hierarchy_code, o.hierarchy_code) as hierarchy_code -- 机构级别
    ,nvl(n.hkd_business_unit, o.hkd_business_unit) as hkd_business_unit -- 账套(港币)
    ,nvl(n.internal_client, o.internal_client) as internal_client -- 内部客户号
    ,nvl(n.local_ccy, o.local_ccy) as local_ccy -- 当地币种
    ,nvl(n.sub_branch_code, o.sub_branch_code) as sub_branch_code -- 分行代码
    ,nvl(n.tax_rpt_branch, o.tax_rpt_branch) as tax_rpt_branch -- 税收机构（总账用）
    ,nvl(n.tran_br_ind, o.tran_br_ind) as tran_br_ind -- 是否交易机构
    ,nvl(n.accounting_branch_flag, o.accounting_branch_flag) as accounting_branch_flag -- 是否核算机构
    ,nvl(n.normal_close_time, o.normal_close_time) as normal_close_time -- 正常关门时间
    ,nvl(n.normal_open_time, o.normal_open_time) as normal_open_time -- 正常开门时间
    ,nvl(n.pboc_financing_no, o.pboc_financing_no) as pboc_financing_no -- 人行金融机构编码
    ,nvl(n.branch_en_short, o.branch_en_short) as branch_en_short -- 机构英文简称
    ,nvl(n.branch_head_phone, o.branch_head_phone) as branch_head_phone -- 机构负责人联系电话
    ,nvl(n.pboc_pay_branch_no, o.pboc_pay_branch_no) as pboc_pay_branch_no -- 人行支付行号
    ,nvl(n.is_auto_create_internal_acct, o.is_auto_create_internal_acct) as is_auto_create_internal_acct -- 是否自动开立内部户
    ,nvl(n.branch_en_name, o.branch_en_name) as branch_en_name -- 机构英文名称
    ,nvl(n.pboc_area_code, o.pboc_area_code) as pboc_area_code -- 人行地区代码
    ,nvl(n.branch_head_name, o.branch_head_name) as branch_head_name -- 机构负责人姓名
    ,nvl(n.branch_close_date, o.branch_close_date) as branch_close_date -- 关闭日期
    ,nvl(n.branch_head_duty, o.branch_head_duty) as branch_head_duty -- 机构负责人职务
    ,nvl(n.swift_no, o.swift_no) as swift_no -- swift号
    ,nvl(n.cup_financing_no, o.cup_financing_no) as cup_financing_no -- 银联金融机构编号
    ,nvl(n.pboc_acct_manage_sys_no, o.pboc_acct_manage_sys_no) as pboc_acct_manage_sys_no -- 人行账户管理系统行号
    ,case when
            n.branch is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.branch is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.branch is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_branch_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_branch where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.branch = n.branch
where (
        o.branch is null
    )
    or (
        n.branch is null
    )
    or (
        o.area_code <> n.area_code
        or o.branch_name <> n.branch_name
        or o.country <> n.country
        or o.profit_center <> n.profit_center
        or o.abnormal_open_control <> n.abnormal_open_control
        or o.auth_flag <> n.auth_flag
        or o.branch_short <> n.branch_short
        or o.branch_status <> n.branch_status
        or o.branch_type <> n.branch_type
        or o.cheque_issuing_branch_flag <> n.cheque_issuing_branch_flag
        or o.city <> n.city
        or o.company <> n.company
        or o.default_teller_login <> n.default_teller_login
        or o.district <> n.district
        or o.eod_flag <> n.eod_flag
        or o.fta_code <> n.fta_code
        or o.fta_flag <> n.fta_flag
        or o.fx_organ_code <> n.fx_organ_code
        or o.index_str <> n.index_str
        or o.int_tax_levy <> n.int_tax_levy
        or o.ip_addr <> n.ip_addr
        or o.oper_max_level <> n.oper_max_level
        or o.pboc_fund_check_flag <> n.pboc_fund_check_flag
        or o.postal_code <> n.postal_code
        or o.state <> n.state
        or o.surtax_type <> n.surtax_type
        or o.tailbox_detach_flag <> n.tailbox_detach_flag
        or o.voucher_user_contral_flag <> n.voucher_user_contral_flag
        or o.accounting_branch <> n.accounting_branch
        or o.libra_op_time <> n.libra_op_time
        or o.create_date <> n.create_date
        or o.end_date <> n.end_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.attached_to <> n.attached_to
        or o.base_ccy <> n.base_ccy
        or o.ccy_ctrl_branch <> n.ccy_ctrl_branch
        or o.cny_business_unit <> n.cny_business_unit
        or o.hierarchy_code <> n.hierarchy_code
        or o.hkd_business_unit <> n.hkd_business_unit
        or o.internal_client <> n.internal_client
        or o.local_ccy <> n.local_ccy
        or o.sub_branch_code <> n.sub_branch_code
        or o.tax_rpt_branch <> n.tax_rpt_branch
        or o.tran_br_ind <> n.tran_br_ind
        or o.accounting_branch_flag <> n.accounting_branch_flag
        or o.normal_close_time <> n.normal_close_time
        or o.normal_open_time <> n.normal_open_time
        or o.pboc_financing_no <> n.pboc_financing_no
        or o.branch_en_short <> n.branch_en_short
        or o.branch_head_phone <> n.branch_head_phone
        or o.pboc_pay_branch_no <> n.pboc_pay_branch_no
        or o.is_auto_create_internal_acct <> n.is_auto_create_internal_acct
        or o.branch_en_name <> n.branch_en_name
        or o.pboc_area_code <> n.pboc_area_code
        or o.branch_head_name <> n.branch_head_name
        or o.branch_close_date <> n.branch_close_date
        or o.branch_head_duty <> n.branch_head_duty
        or o.swift_no <> n.swift_no
        or o.cup_financing_no <> n.cup_financing_no
        or o.pboc_acct_manage_sys_no <> n.pboc_acct_manage_sys_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_branch_cl(
            area_code -- 地区码
            ,branch -- 机构编号
            ,branch_name -- 银行机构名称
            ,country -- 国家
            ,profit_center -- 利润中心
            ,abnormal_open_control -- 非正常时间开门控制方式
            ,auth_flag -- 授权标志
            ,branch_short -- 机构简称
            ,branch_status -- 机构开关门状态
            ,branch_type -- 机构类型
            ,cheque_issuing_branch_flag -- 是否签发支票
            ,city -- 行政区划(城市)
            ,company -- 法人
            ,default_teller_login -- 默认柜员登录认证方式
            ,district -- 区号
            ,eod_flag -- 日终标识
            ,fta_code -- 自贸区代码
            ,fta_flag -- 是否自贸区机构
            ,fx_organ_code -- 外汇金融机构代码
            ,index_str -- 索引字符串
            ,int_tax_levy -- 利息税征收标志
            ,ip_addr -- 机构ip地址
            ,oper_max_level -- 操作最高级别
            ,pboc_fund_check_flag -- 人行备付金检查标志
            ,postal_code -- 邮政编码
            ,state -- 行政区划(省、州)
            ,surtax_type -- 附加税类型
            ,tailbox_detach_flag -- 尾箱控制方式
            ,voucher_user_contral_flag -- 是否限制凭证入库柜员
            ,accounting_branch -- 核算机构
            ,libra_op_time -- libra执行次数
            ,create_date -- 创建日期
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,attached_to -- 所属上级
            ,base_ccy -- 基础币种
            ,ccy_ctrl_branch -- 结售汇平盘机构
            ,cny_business_unit -- 账套(人民币)
            ,hierarchy_code -- 机构级别
            ,hkd_business_unit -- 账套(港币)
            ,internal_client -- 内部客户号
            ,local_ccy -- 当地币种
            ,sub_branch_code -- 分行代码
            ,tax_rpt_branch -- 税收机构（总账用）
            ,tran_br_ind -- 是否交易机构
            ,accounting_branch_flag -- 是否核算机构
            ,normal_close_time -- 正常关门时间
            ,normal_open_time -- 正常开门时间
            ,pboc_financing_no -- 人行金融机构编码
            ,branch_en_short -- 机构英文简称
            ,branch_head_phone -- 机构负责人联系电话
            ,pboc_pay_branch_no -- 人行支付行号
            ,is_auto_create_internal_acct -- 是否自动开立内部户
            ,branch_en_name -- 机构英文名称
            ,pboc_area_code -- 人行地区代码
            ,branch_head_name -- 机构负责人姓名
            ,branch_close_date -- 关闭日期
            ,branch_head_duty -- 机构负责人职务
            ,swift_no -- swift号
            ,cup_financing_no -- 银联金融机构编号
            ,pboc_acct_manage_sys_no -- 人行账户管理系统行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_branch_op(
            area_code -- 地区码
            ,branch -- 机构编号
            ,branch_name -- 银行机构名称
            ,country -- 国家
            ,profit_center -- 利润中心
            ,abnormal_open_control -- 非正常时间开门控制方式
            ,auth_flag -- 授权标志
            ,branch_short -- 机构简称
            ,branch_status -- 机构开关门状态
            ,branch_type -- 机构类型
            ,cheque_issuing_branch_flag -- 是否签发支票
            ,city -- 行政区划(城市)
            ,company -- 法人
            ,default_teller_login -- 默认柜员登录认证方式
            ,district -- 区号
            ,eod_flag -- 日终标识
            ,fta_code -- 自贸区代码
            ,fta_flag -- 是否自贸区机构
            ,fx_organ_code -- 外汇金融机构代码
            ,index_str -- 索引字符串
            ,int_tax_levy -- 利息税征收标志
            ,ip_addr -- 机构ip地址
            ,oper_max_level -- 操作最高级别
            ,pboc_fund_check_flag -- 人行备付金检查标志
            ,postal_code -- 邮政编码
            ,state -- 行政区划(省、州)
            ,surtax_type -- 附加税类型
            ,tailbox_detach_flag -- 尾箱控制方式
            ,voucher_user_contral_flag -- 是否限制凭证入库柜员
            ,accounting_branch -- 核算机构
            ,libra_op_time -- libra执行次数
            ,create_date -- 创建日期
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,attached_to -- 所属上级
            ,base_ccy -- 基础币种
            ,ccy_ctrl_branch -- 结售汇平盘机构
            ,cny_business_unit -- 账套(人民币)
            ,hierarchy_code -- 机构级别
            ,hkd_business_unit -- 账套(港币)
            ,internal_client -- 内部客户号
            ,local_ccy -- 当地币种
            ,sub_branch_code -- 分行代码
            ,tax_rpt_branch -- 税收机构（总账用）
            ,tran_br_ind -- 是否交易机构
            ,accounting_branch_flag -- 是否核算机构
            ,normal_close_time -- 正常关门时间
            ,normal_open_time -- 正常开门时间
            ,pboc_financing_no -- 人行金融机构编码
            ,branch_en_short -- 机构英文简称
            ,branch_head_phone -- 机构负责人联系电话
            ,pboc_pay_branch_no -- 人行支付行号
            ,is_auto_create_internal_acct -- 是否自动开立内部户
            ,branch_en_name -- 机构英文名称
            ,pboc_area_code -- 人行地区代码
            ,branch_head_name -- 机构负责人姓名
            ,branch_close_date -- 关闭日期
            ,branch_head_duty -- 机构负责人职务
            ,swift_no -- swift号
            ,cup_financing_no -- 银联金融机构编号
            ,pboc_acct_manage_sys_no -- 人行账户管理系统行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.area_code -- 地区码
    ,o.branch -- 机构编号
    ,o.branch_name -- 银行机构名称
    ,o.country -- 国家
    ,o.profit_center -- 利润中心
    ,o.abnormal_open_control -- 非正常时间开门控制方式
    ,o.auth_flag -- 授权标志
    ,o.branch_short -- 机构简称
    ,o.branch_status -- 机构开关门状态
    ,o.branch_type -- 机构类型
    ,o.cheque_issuing_branch_flag -- 是否签发支票
    ,o.city -- 行政区划(城市)
    ,o.company -- 法人
    ,o.default_teller_login -- 默认柜员登录认证方式
    ,o.district -- 区号
    ,o.eod_flag -- 日终标识
    ,o.fta_code -- 自贸区代码
    ,o.fta_flag -- 是否自贸区机构
    ,o.fx_organ_code -- 外汇金融机构代码
    ,o.index_str -- 索引字符串
    ,o.int_tax_levy -- 利息税征收标志
    ,o.ip_addr -- 机构ip地址
    ,o.oper_max_level -- 操作最高级别
    ,o.pboc_fund_check_flag -- 人行备付金检查标志
    ,o.postal_code -- 邮政编码
    ,o.state -- 行政区划(省、州)
    ,o.surtax_type -- 附加税类型
    ,o.tailbox_detach_flag -- 尾箱控制方式
    ,o.voucher_user_contral_flag -- 是否限制凭证入库柜员
    ,o.accounting_branch -- 核算机构
    ,o.libra_op_time -- libra执行次数
    ,o.create_date -- 创建日期
    ,o.end_date -- 结束日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.attached_to -- 所属上级
    ,o.base_ccy -- 基础币种
    ,o.ccy_ctrl_branch -- 结售汇平盘机构
    ,o.cny_business_unit -- 账套(人民币)
    ,o.hierarchy_code -- 机构级别
    ,o.hkd_business_unit -- 账套(港币)
    ,o.internal_client -- 内部客户号
    ,o.local_ccy -- 当地币种
    ,o.sub_branch_code -- 分行代码
    ,o.tax_rpt_branch -- 税收机构（总账用）
    ,o.tran_br_ind -- 是否交易机构
    ,o.accounting_branch_flag -- 是否核算机构
    ,o.normal_close_time -- 正常关门时间
    ,o.normal_open_time -- 正常开门时间
    ,o.pboc_financing_no -- 人行金融机构编码
    ,o.branch_en_short -- 机构英文简称
    ,o.branch_head_phone -- 机构负责人联系电话
    ,o.pboc_pay_branch_no -- 人行支付行号
    ,o.is_auto_create_internal_acct -- 是否自动开立内部户
    ,o.branch_en_name -- 机构英文名称
    ,o.pboc_area_code -- 人行地区代码
    ,o.branch_head_name -- 机构负责人姓名
    ,o.branch_close_date -- 关闭日期
    ,o.branch_head_duty -- 机构负责人职务
    ,o.swift_no -- swift号
    ,o.cup_financing_no -- 银联金融机构编号
    ,o.pboc_acct_manage_sys_no -- 人行账户管理系统行号
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
from ${iol_schema}.ncbs_fm_branch_bk o
    left join ${iol_schema}.ncbs_fm_branch_op n
        on
            o.branch = n.branch
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_branch_cl d
        on
            o.branch = d.branch
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_branch;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_branch') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_branch drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_branch add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_branch exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_branch_cl;
alter table ${iol_schema}.ncbs_fm_branch exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_branch_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_branch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_branch_op purge;
drop table ${iol_schema}.ncbs_fm_branch_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_branch_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_branch',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
