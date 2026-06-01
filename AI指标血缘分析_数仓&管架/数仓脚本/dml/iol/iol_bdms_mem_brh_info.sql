/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_mem_brh_info
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
create table ${iol_schema}.bdms_mem_brh_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_mem_brh_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_mem_brh_info_op purge;
drop table ${iol_schema}.bdms_mem_brh_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_mem_brh_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_mem_brh_info where 0=1;

create table ${iol_schema}.bdms_mem_brh_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_mem_brh_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_mem_brh_info_cl(
            id -- ID
            ,mem_no -- 会员代码
            ,brh_no -- 机构代码
            ,brh_code -- 机构编码
            ,brh_type -- 机构类别代码： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
            ,brh_class -- 机构类型代码：见中国票据交易系统直连接口规范【概述分册】的数据类型BranchClass
            ,brh_zh_full_name -- 机构全称（中文）
            ,brh_en_full_name -- 机构全称（英文）
            ,brh_zh_short_name -- 机构简称（中文）
            ,brh_en_short_name -- 机构简称（英文）
            ,social_credit_no -- 统一社会信用代码
            ,province_no -- 省份代码：见中国票据交易系统直连接口规范【概述分册】的数据类型Province
            ,br_corp_class -- 法人级别代码： CC00 法人(含虚拟资管参与者) CC01 分支机构 CC02 非法人产品
            ,brh_level -- 机构层级
            ,pro_effect_date -- 产品有效日期
            ,pro_expire_date -- 产品失效日期
            ,brh_status -- 机构状态： ST01 活动 ST02 禁用 ST03 注销
            ,brh_acct_name -- 机构内部账户名称
            ,brh_acct_no -- 机构内部账户账号
            ,txn_acct_no -- 交易账号
            ,txn_acct_status -- 交易账户状态： ST01 活动 ST02 禁用 ST03 注销
            ,reg_acct_no -- 托管账号 托管账户状态: ST01 活动 ST02 禁用
            ,reg_acct_status -- 托管账户状态: ST01 活动 ST02 禁用 ST03 注销
            ,cap_acct_no -- 票交所资金账户账号
            ,cap_acct_status -- 票交所资金账户状态: ST01 活动 ST02 禁用 ST03 注销
            ,corp_represence -- 法定代表人或负责人
            ,withdraw_bank_no -- 出金账户开户行大额支付系统行号
            ,withdraw_acct_name -- 出金账户名称
            ,withdraw_acct_no -- 出金账户账号
            ,registered_capital -- 注册资本
            ,adress -- 地址
            ,attn -- 联系人
            ,tel -- 联系电话
            ,fax_code -- 传真
            ,post_code -- 邮编
            ,misc -- 备注
            ,ubank_no -- 系统参与者大额行号
            ,ubank_name -- 系统参与者大额行名
            ,agency_ubank_no -- 电票代理行大额行号
            ,agency_ubank_acct -- 电票代理行大额账号
            ,authority_list -- 机构权限列表
            ,recept_brh_id -- 承接机构代码
            ,last_upd_time -- 最后修改时间
            ,head_brh_type -- 总行类别： 1 国股 2 城商
            ,create_time -- 创建时间
            ,last_upd_opr -- 最后更新人
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_mem_brh_info_op(
            id -- ID
            ,mem_no -- 会员代码
            ,brh_no -- 机构代码
            ,brh_code -- 机构编码
            ,brh_type -- 机构类别代码： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
            ,brh_class -- 机构类型代码：见中国票据交易系统直连接口规范【概述分册】的数据类型BranchClass
            ,brh_zh_full_name -- 机构全称（中文）
            ,brh_en_full_name -- 机构全称（英文）
            ,brh_zh_short_name -- 机构简称（中文）
            ,brh_en_short_name -- 机构简称（英文）
            ,social_credit_no -- 统一社会信用代码
            ,province_no -- 省份代码：见中国票据交易系统直连接口规范【概述分册】的数据类型Province
            ,br_corp_class -- 法人级别代码： CC00 法人(含虚拟资管参与者) CC01 分支机构 CC02 非法人产品
            ,brh_level -- 机构层级
            ,pro_effect_date -- 产品有效日期
            ,pro_expire_date -- 产品失效日期
            ,brh_status -- 机构状态： ST01 活动 ST02 禁用 ST03 注销
            ,brh_acct_name -- 机构内部账户名称
            ,brh_acct_no -- 机构内部账户账号
            ,txn_acct_no -- 交易账号
            ,txn_acct_status -- 交易账户状态： ST01 活动 ST02 禁用 ST03 注销
            ,reg_acct_no -- 托管账号 托管账户状态: ST01 活动 ST02 禁用
            ,reg_acct_status -- 托管账户状态: ST01 活动 ST02 禁用 ST03 注销
            ,cap_acct_no -- 票交所资金账户账号
            ,cap_acct_status -- 票交所资金账户状态: ST01 活动 ST02 禁用 ST03 注销
            ,corp_represence -- 法定代表人或负责人
            ,withdraw_bank_no -- 出金账户开户行大额支付系统行号
            ,withdraw_acct_name -- 出金账户名称
            ,withdraw_acct_no -- 出金账户账号
            ,registered_capital -- 注册资本
            ,adress -- 地址
            ,attn -- 联系人
            ,tel -- 联系电话
            ,fax_code -- 传真
            ,post_code -- 邮编
            ,misc -- 备注
            ,ubank_no -- 系统参与者大额行号
            ,ubank_name -- 系统参与者大额行名
            ,agency_ubank_no -- 电票代理行大额行号
            ,agency_ubank_acct -- 电票代理行大额账号
            ,authority_list -- 机构权限列表
            ,recept_brh_id -- 承接机构代码
            ,last_upd_time -- 最后修改时间
            ,head_brh_type -- 总行类别： 1 国股 2 城商
            ,create_time -- 创建时间
            ,last_upd_opr -- 最后更新人
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.mem_no, o.mem_no) as mem_no -- 会员代码
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 机构代码
    ,nvl(n.brh_code, o.brh_code) as brh_code -- 机构编码
    ,nvl(n.brh_type, o.brh_type) as brh_type -- 机构类别代码： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
    ,nvl(n.brh_class, o.brh_class) as brh_class -- 机构类型代码：见中国票据交易系统直连接口规范【概述分册】的数据类型BranchClass
    ,nvl(n.brh_zh_full_name, o.brh_zh_full_name) as brh_zh_full_name -- 机构全称（中文）
    ,nvl(n.brh_en_full_name, o.brh_en_full_name) as brh_en_full_name -- 机构全称（英文）
    ,nvl(n.brh_zh_short_name, o.brh_zh_short_name) as brh_zh_short_name -- 机构简称（中文）
    ,nvl(n.brh_en_short_name, o.brh_en_short_name) as brh_en_short_name -- 机构简称（英文）
    ,nvl(n.social_credit_no, o.social_credit_no) as social_credit_no -- 统一社会信用代码
    ,nvl(n.province_no, o.province_no) as province_no -- 省份代码：见中国票据交易系统直连接口规范【概述分册】的数据类型Province
    ,nvl(n.br_corp_class, o.br_corp_class) as br_corp_class -- 法人级别代码： CC00 法人(含虚拟资管参与者) CC01 分支机构 CC02 非法人产品
    ,nvl(n.brh_level, o.brh_level) as brh_level -- 机构层级
    ,nvl(n.pro_effect_date, o.pro_effect_date) as pro_effect_date -- 产品有效日期
    ,nvl(n.pro_expire_date, o.pro_expire_date) as pro_expire_date -- 产品失效日期
    ,nvl(n.brh_status, o.brh_status) as brh_status -- 机构状态： ST01 活动 ST02 禁用 ST03 注销
    ,nvl(n.brh_acct_name, o.brh_acct_name) as brh_acct_name -- 机构内部账户名称
    ,nvl(n.brh_acct_no, o.brh_acct_no) as brh_acct_no -- 机构内部账户账号
    ,nvl(n.txn_acct_no, o.txn_acct_no) as txn_acct_no -- 交易账号
    ,nvl(n.txn_acct_status, o.txn_acct_status) as txn_acct_status -- 交易账户状态： ST01 活动 ST02 禁用 ST03 注销
    ,nvl(n.reg_acct_no, o.reg_acct_no) as reg_acct_no -- 托管账号 托管账户状态: ST01 活动 ST02 禁用
    ,nvl(n.reg_acct_status, o.reg_acct_status) as reg_acct_status -- 托管账户状态: ST01 活动 ST02 禁用 ST03 注销
    ,nvl(n.cap_acct_no, o.cap_acct_no) as cap_acct_no -- 票交所资金账户账号
    ,nvl(n.cap_acct_status, o.cap_acct_status) as cap_acct_status -- 票交所资金账户状态: ST01 活动 ST02 禁用 ST03 注销
    ,nvl(n.corp_represence, o.corp_represence) as corp_represence -- 法定代表人或负责人
    ,nvl(n.withdraw_bank_no, o.withdraw_bank_no) as withdraw_bank_no -- 出金账户开户行大额支付系统行号
    ,nvl(n.withdraw_acct_name, o.withdraw_acct_name) as withdraw_acct_name -- 出金账户名称
    ,nvl(n.withdraw_acct_no, o.withdraw_acct_no) as withdraw_acct_no -- 出金账户账号
    ,nvl(n.registered_capital, o.registered_capital) as registered_capital -- 注册资本
    ,nvl(n.adress, o.adress) as adress -- 地址
    ,nvl(n.attn, o.attn) as attn -- 联系人
    ,nvl(n.tel, o.tel) as tel -- 联系电话
    ,nvl(n.fax_code, o.fax_code) as fax_code -- 传真
    ,nvl(n.post_code, o.post_code) as post_code -- 邮编
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.ubank_no, o.ubank_no) as ubank_no -- 系统参与者大额行号
    ,nvl(n.ubank_name, o.ubank_name) as ubank_name -- 系统参与者大额行名
    ,nvl(n.agency_ubank_no, o.agency_ubank_no) as agency_ubank_no -- 电票代理行大额行号
    ,nvl(n.agency_ubank_acct, o.agency_ubank_acct) as agency_ubank_acct -- 电票代理行大额账号
    ,nvl(n.authority_list, o.authority_list) as authority_list -- 机构权限列表
    ,nvl(n.recept_brh_id, o.recept_brh_id) as recept_brh_id -- 承接机构代码
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后修改时间
    ,nvl(n.head_brh_type, o.head_brh_type) as head_brh_type -- 总行类别： 1 国股 2 城商
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.last_upd_opr, o.last_upd_opr) as last_upd_opr -- 最后更新人
    ,nvl(n.create_by, o.create_by) as create_by -- 创建人
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
from (select * from ${iol_schema}.bdms_mem_brh_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_mem_brh_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.mem_no <> n.mem_no
        or o.brh_no <> n.brh_no
        or o.brh_code <> n.brh_code
        or o.brh_type <> n.brh_type
        or o.brh_class <> n.brh_class
        or o.brh_zh_full_name <> n.brh_zh_full_name
        or o.brh_en_full_name <> n.brh_en_full_name
        or o.brh_zh_short_name <> n.brh_zh_short_name
        or o.brh_en_short_name <> n.brh_en_short_name
        or o.social_credit_no <> n.social_credit_no
        or o.province_no <> n.province_no
        or o.br_corp_class <> n.br_corp_class
        or o.brh_level <> n.brh_level
        or o.pro_effect_date <> n.pro_effect_date
        or o.pro_expire_date <> n.pro_expire_date
        or o.brh_status <> n.brh_status
        or o.brh_acct_name <> n.brh_acct_name
        or o.brh_acct_no <> n.brh_acct_no
        or o.txn_acct_no <> n.txn_acct_no
        or o.txn_acct_status <> n.txn_acct_status
        or o.reg_acct_no <> n.reg_acct_no
        or o.reg_acct_status <> n.reg_acct_status
        or o.cap_acct_no <> n.cap_acct_no
        or o.cap_acct_status <> n.cap_acct_status
        or o.corp_represence <> n.corp_represence
        or o.withdraw_bank_no <> n.withdraw_bank_no
        or o.withdraw_acct_name <> n.withdraw_acct_name
        or o.withdraw_acct_no <> n.withdraw_acct_no
        or o.registered_capital <> n.registered_capital
        or o.adress <> n.adress
        or o.attn <> n.attn
        or o.tel <> n.tel
        or o.fax_code <> n.fax_code
        or o.post_code <> n.post_code
        or o.misc <> n.misc
        or o.ubank_no <> n.ubank_no
        or o.ubank_name <> n.ubank_name
        or o.agency_ubank_no <> n.agency_ubank_no
        or o.agency_ubank_acct <> n.agency_ubank_acct
        or o.authority_list <> n.authority_list
        or o.recept_brh_id <> n.recept_brh_id
        or o.last_upd_time <> n.last_upd_time
        or o.head_brh_type <> n.head_brh_type
        or o.create_time <> n.create_time
        or o.last_upd_opr <> n.last_upd_opr
        or o.create_by <> n.create_by
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_mem_brh_info_cl(
            id -- ID
            ,mem_no -- 会员代码
            ,brh_no -- 机构代码
            ,brh_code -- 机构编码
            ,brh_type -- 机构类别代码： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
            ,brh_class -- 机构类型代码：见中国票据交易系统直连接口规范【概述分册】的数据类型BranchClass
            ,brh_zh_full_name -- 机构全称（中文）
            ,brh_en_full_name -- 机构全称（英文）
            ,brh_zh_short_name -- 机构简称（中文）
            ,brh_en_short_name -- 机构简称（英文）
            ,social_credit_no -- 统一社会信用代码
            ,province_no -- 省份代码：见中国票据交易系统直连接口规范【概述分册】的数据类型Province
            ,br_corp_class -- 法人级别代码： CC00 法人(含虚拟资管参与者) CC01 分支机构 CC02 非法人产品
            ,brh_level -- 机构层级
            ,pro_effect_date -- 产品有效日期
            ,pro_expire_date -- 产品失效日期
            ,brh_status -- 机构状态： ST01 活动 ST02 禁用 ST03 注销
            ,brh_acct_name -- 机构内部账户名称
            ,brh_acct_no -- 机构内部账户账号
            ,txn_acct_no -- 交易账号
            ,txn_acct_status -- 交易账户状态： ST01 活动 ST02 禁用 ST03 注销
            ,reg_acct_no -- 托管账号 托管账户状态: ST01 活动 ST02 禁用
            ,reg_acct_status -- 托管账户状态: ST01 活动 ST02 禁用 ST03 注销
            ,cap_acct_no -- 票交所资金账户账号
            ,cap_acct_status -- 票交所资金账户状态: ST01 活动 ST02 禁用 ST03 注销
            ,corp_represence -- 法定代表人或负责人
            ,withdraw_bank_no -- 出金账户开户行大额支付系统行号
            ,withdraw_acct_name -- 出金账户名称
            ,withdraw_acct_no -- 出金账户账号
            ,registered_capital -- 注册资本
            ,adress -- 地址
            ,attn -- 联系人
            ,tel -- 联系电话
            ,fax_code -- 传真
            ,post_code -- 邮编
            ,misc -- 备注
            ,ubank_no -- 系统参与者大额行号
            ,ubank_name -- 系统参与者大额行名
            ,agency_ubank_no -- 电票代理行大额行号
            ,agency_ubank_acct -- 电票代理行大额账号
            ,authority_list -- 机构权限列表
            ,recept_brh_id -- 承接机构代码
            ,last_upd_time -- 最后修改时间
            ,head_brh_type -- 总行类别： 1 国股 2 城商
            ,create_time -- 创建时间
            ,last_upd_opr -- 最后更新人
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_mem_brh_info_op(
            id -- ID
            ,mem_no -- 会员代码
            ,brh_no -- 机构代码
            ,brh_code -- 机构编码
            ,brh_type -- 机构类别代码： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
            ,brh_class -- 机构类型代码：见中国票据交易系统直连接口规范【概述分册】的数据类型BranchClass
            ,brh_zh_full_name -- 机构全称（中文）
            ,brh_en_full_name -- 机构全称（英文）
            ,brh_zh_short_name -- 机构简称（中文）
            ,brh_en_short_name -- 机构简称（英文）
            ,social_credit_no -- 统一社会信用代码
            ,province_no -- 省份代码：见中国票据交易系统直连接口规范【概述分册】的数据类型Province
            ,br_corp_class -- 法人级别代码： CC00 法人(含虚拟资管参与者) CC01 分支机构 CC02 非法人产品
            ,brh_level -- 机构层级
            ,pro_effect_date -- 产品有效日期
            ,pro_expire_date -- 产品失效日期
            ,brh_status -- 机构状态： ST01 活动 ST02 禁用 ST03 注销
            ,brh_acct_name -- 机构内部账户名称
            ,brh_acct_no -- 机构内部账户账号
            ,txn_acct_no -- 交易账号
            ,txn_acct_status -- 交易账户状态： ST01 活动 ST02 禁用 ST03 注销
            ,reg_acct_no -- 托管账号 托管账户状态: ST01 活动 ST02 禁用
            ,reg_acct_status -- 托管账户状态: ST01 活动 ST02 禁用 ST03 注销
            ,cap_acct_no -- 票交所资金账户账号
            ,cap_acct_status -- 票交所资金账户状态: ST01 活动 ST02 禁用 ST03 注销
            ,corp_represence -- 法定代表人或负责人
            ,withdraw_bank_no -- 出金账户开户行大额支付系统行号
            ,withdraw_acct_name -- 出金账户名称
            ,withdraw_acct_no -- 出金账户账号
            ,registered_capital -- 注册资本
            ,adress -- 地址
            ,attn -- 联系人
            ,tel -- 联系电话
            ,fax_code -- 传真
            ,post_code -- 邮编
            ,misc -- 备注
            ,ubank_no -- 系统参与者大额行号
            ,ubank_name -- 系统参与者大额行名
            ,agency_ubank_no -- 电票代理行大额行号
            ,agency_ubank_acct -- 电票代理行大额账号
            ,authority_list -- 机构权限列表
            ,recept_brh_id -- 承接机构代码
            ,last_upd_time -- 最后修改时间
            ,head_brh_type -- 总行类别： 1 国股 2 城商
            ,create_time -- 创建时间
            ,last_upd_opr -- 最后更新人
            ,create_by -- 创建人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.mem_no -- 会员代码
    ,o.brh_no -- 机构代码
    ,o.brh_code -- 机构编码
    ,o.brh_type -- 机构类别代码： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
    ,o.brh_class -- 机构类型代码：见中国票据交易系统直连接口规范【概述分册】的数据类型BranchClass
    ,o.brh_zh_full_name -- 机构全称（中文）
    ,o.brh_en_full_name -- 机构全称（英文）
    ,o.brh_zh_short_name -- 机构简称（中文）
    ,o.brh_en_short_name -- 机构简称（英文）
    ,o.social_credit_no -- 统一社会信用代码
    ,o.province_no -- 省份代码：见中国票据交易系统直连接口规范【概述分册】的数据类型Province
    ,o.br_corp_class -- 法人级别代码： CC00 法人(含虚拟资管参与者) CC01 分支机构 CC02 非法人产品
    ,o.brh_level -- 机构层级
    ,o.pro_effect_date -- 产品有效日期
    ,o.pro_expire_date -- 产品失效日期
    ,o.brh_status -- 机构状态： ST01 活动 ST02 禁用 ST03 注销
    ,o.brh_acct_name -- 机构内部账户名称
    ,o.brh_acct_no -- 机构内部账户账号
    ,o.txn_acct_no -- 交易账号
    ,o.txn_acct_status -- 交易账户状态： ST01 活动 ST02 禁用 ST03 注销
    ,o.reg_acct_no -- 托管账号 托管账户状态: ST01 活动 ST02 禁用
    ,o.reg_acct_status -- 托管账户状态: ST01 活动 ST02 禁用 ST03 注销
    ,o.cap_acct_no -- 票交所资金账户账号
    ,o.cap_acct_status -- 票交所资金账户状态: ST01 活动 ST02 禁用 ST03 注销
    ,o.corp_represence -- 法定代表人或负责人
    ,o.withdraw_bank_no -- 出金账户开户行大额支付系统行号
    ,o.withdraw_acct_name -- 出金账户名称
    ,o.withdraw_acct_no -- 出金账户账号
    ,o.registered_capital -- 注册资本
    ,o.adress -- 地址
    ,o.attn -- 联系人
    ,o.tel -- 联系电话
    ,o.fax_code -- 传真
    ,o.post_code -- 邮编
    ,o.misc -- 备注
    ,o.ubank_no -- 系统参与者大额行号
    ,o.ubank_name -- 系统参与者大额行名
    ,o.agency_ubank_no -- 电票代理行大额行号
    ,o.agency_ubank_acct -- 电票代理行大额账号
    ,o.authority_list -- 机构权限列表
    ,o.recept_brh_id -- 承接机构代码
    ,o.last_upd_time -- 最后修改时间
    ,o.head_brh_type -- 总行类别： 1 国股 2 城商
    ,o.create_time -- 创建时间
    ,o.last_upd_opr -- 最后更新人
    ,o.create_by -- 创建人
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
from ${iol_schema}.bdms_mem_brh_info_bk o
    left join ${iol_schema}.bdms_mem_brh_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_mem_brh_info_cl d
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
--truncate table ${iol_schema}.bdms_mem_brh_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('bdms_mem_brh_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.bdms_mem_brh_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.bdms_mem_brh_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.bdms_mem_brh_info exchange partition p_${batch_date} with table ${iol_schema}.bdms_mem_brh_info_cl;
alter table ${iol_schema}.bdms_mem_brh_info exchange partition p_20991231 with table ${iol_schema}.bdms_mem_brh_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_mem_brh_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_mem_brh_info_op purge;
drop table ${iol_schema}.bdms_mem_brh_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_mem_brh_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_mem_brh_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
