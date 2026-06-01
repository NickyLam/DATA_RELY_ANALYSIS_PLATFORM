/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t2a_dpst_acct_c
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
create table ${iol_schema}.amls_t2a_dpst_acct_c_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amls_t2a_dpst_acct_c
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2a_dpst_acct_c_op purge;
drop table ${iol_schema}.amls_t2a_dpst_acct_c_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2a_dpst_acct_c_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2a_dpst_acct_c where 0=1;

create table ${iol_schema}.amls_t2a_dpst_acct_c_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2a_dpst_acct_c where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2a_dpst_acct_c_cl(
            acct_id -- 账户编号
            ,cust_id -- 客户编号
            ,cust_name -- 客户名称
            ,org_id -- 开户机构编号
            ,acct_type -- 账户类型
            ,base_acct_type -- 基本账户类型（参见[字典:AML0074]）
            ,ib_property_cd -- 外汇账户性质代码
            ,acct_sts -- 账户状态（参见[字典:AML0075]）
            ,subject_id -- 科目编号
            ,prd_id -- 产品编号
            ,corp_type -- 企业账户类型（参见[字典:AML0076]）
            ,curr_iden -- 钞汇标识（参见[字典:AML0077]）
            ,curr_cd -- 币种
            ,open_amt -- 定期类存款开户金额
            ,bal_amt -- 余额
            ,last_bal_amt -- 昨日余额
            ,avl_amt -- 可用余额
            ,open_dt -- 开户日期
            ,int_dt -- 定期类存款当期起息日
            ,mature_dt -- 定期类存款当期到期日
            ,term_cd -- 定期类存款存期代码
            ,close_dt -- 销户日期
            ,agent_name -- 代办人姓名
            ,agent_nat -- 代办人国籍
            ,agent_cert_type -- 代办人证件种类
            ,oth_agent_cert_type -- 代办人其他身份证件/证明文件类型件类型编码
            ,agent_cert_no -- 代办人证件号码
            ,rsrv_01 -- 是否自贸区账户
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,opr_id -- 开户柜员号
            ,open_tm -- 开户时间
            ,close_tm -- 销户时间
            ,card_style -- 借贷记卡标识
            ,oth_card_style -- 银行卡其他类型
            ,card_no -- 银行卡号码
            ,main_acct_id -- 主账号
            ,is_merch -- 银行卡收单账户标识(11：是；12：否)
            ,is_ebank -- 账户网银标识（否0；是1）
            ,mobile_bank_phone -- 手机银行电话号码
            ,open_chnl -- 开户渠道
            ,agent_flag -- 是否代理开户(代理11；本人12；批量开户13)
            ,agent_tel -- 代理人联系方式
            ,last_occur_dt -- 最后一次交易发生的时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2a_dpst_acct_c_op(
            acct_id -- 账户编号
            ,cust_id -- 客户编号
            ,cust_name -- 客户名称
            ,org_id -- 开户机构编号
            ,acct_type -- 账户类型
            ,base_acct_type -- 基本账户类型（参见[字典:AML0074]）
            ,ib_property_cd -- 外汇账户性质代码
            ,acct_sts -- 账户状态（参见[字典:AML0075]）
            ,subject_id -- 科目编号
            ,prd_id -- 产品编号
            ,corp_type -- 企业账户类型（参见[字典:AML0076]）
            ,curr_iden -- 钞汇标识（参见[字典:AML0077]）
            ,curr_cd -- 币种
            ,open_amt -- 定期类存款开户金额
            ,bal_amt -- 余额
            ,last_bal_amt -- 昨日余额
            ,avl_amt -- 可用余额
            ,open_dt -- 开户日期
            ,int_dt -- 定期类存款当期起息日
            ,mature_dt -- 定期类存款当期到期日
            ,term_cd -- 定期类存款存期代码
            ,close_dt -- 销户日期
            ,agent_name -- 代办人姓名
            ,agent_nat -- 代办人国籍
            ,agent_cert_type -- 代办人证件种类
            ,oth_agent_cert_type -- 代办人其他身份证件/证明文件类型件类型编码
            ,agent_cert_no -- 代办人证件号码
            ,rsrv_01 -- 是否自贸区账户
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,opr_id -- 开户柜员号
            ,open_tm -- 开户时间
            ,close_tm -- 销户时间
            ,card_style -- 借贷记卡标识
            ,oth_card_style -- 银行卡其他类型
            ,card_no -- 银行卡号码
            ,main_acct_id -- 主账号
            ,is_merch -- 银行卡收单账户标识(11：是；12：否)
            ,is_ebank -- 账户网银标识（否0；是1）
            ,mobile_bank_phone -- 手机银行电话号码
            ,open_chnl -- 开户渠道
            ,agent_flag -- 是否代理开户(代理11；本人12；批量开户13)
            ,agent_tel -- 代理人联系方式
            ,last_occur_dt -- 最后一次交易发生的时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.org_id, o.org_id) as org_id -- 开户机构编号
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.base_acct_type, o.base_acct_type) as base_acct_type -- 基本账户类型（参见[字典:AML0074]）
    ,nvl(n.ib_property_cd, o.ib_property_cd) as ib_property_cd -- 外汇账户性质代码
    ,nvl(n.acct_sts, o.acct_sts) as acct_sts -- 账户状态（参见[字典:AML0075]）
    ,nvl(n.subject_id, o.subject_id) as subject_id -- 科目编号
    ,nvl(n.prd_id, o.prd_id) as prd_id -- 产品编号
    ,nvl(n.corp_type, o.corp_type) as corp_type -- 企业账户类型（参见[字典:AML0076]）
    ,nvl(n.curr_iden, o.curr_iden) as curr_iden -- 钞汇标识（参见[字典:AML0077]）
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种
    ,nvl(n.open_amt, o.open_amt) as open_amt -- 定期类存款开户金额
    ,nvl(n.bal_amt, o.bal_amt) as bal_amt -- 余额
    ,nvl(n.last_bal_amt, o.last_bal_amt) as last_bal_amt -- 昨日余额
    ,nvl(n.avl_amt, o.avl_amt) as avl_amt -- 可用余额
    ,nvl(n.open_dt, o.open_dt) as open_dt -- 开户日期
    ,nvl(n.int_dt, o.int_dt) as int_dt -- 定期类存款当期起息日
    ,nvl(n.mature_dt, o.mature_dt) as mature_dt -- 定期类存款当期到期日
    ,nvl(n.term_cd, o.term_cd) as term_cd -- 定期类存款存期代码
    ,nvl(n.close_dt, o.close_dt) as close_dt -- 销户日期
    ,nvl(n.agent_name, o.agent_name) as agent_name -- 代办人姓名
    ,nvl(n.agent_nat, o.agent_nat) as agent_nat -- 代办人国籍
    ,nvl(n.agent_cert_type, o.agent_cert_type) as agent_cert_type -- 代办人证件种类
    ,nvl(n.oth_agent_cert_type, o.oth_agent_cert_type) as oth_agent_cert_type -- 代办人其他身份证件/证明文件类型件类型编码
    ,nvl(n.agent_cert_no, o.agent_cert_no) as agent_cert_no -- 代办人证件号码
    ,nvl(n.rsrv_01, o.rsrv_01) as rsrv_01 -- 是否自贸区账户
    ,nvl(n.rsrv_02, o.rsrv_02) as rsrv_02 -- 备用字段2
    ,nvl(n.rsrv_03, o.rsrv_03) as rsrv_03 -- 备用字段3
    ,nvl(n.rsrv_04, o.rsrv_04) as rsrv_04 -- 备用字段4
    ,nvl(n.opr_id, o.opr_id) as opr_id -- 开户柜员号
    ,nvl(n.open_tm, o.open_tm) as open_tm -- 开户时间
    ,nvl(n.close_tm, o.close_tm) as close_tm -- 销户时间
    ,nvl(n.card_style, o.card_style) as card_style -- 借贷记卡标识
    ,nvl(n.oth_card_style, o.oth_card_style) as oth_card_style -- 银行卡其他类型
    ,nvl(n.card_no, o.card_no) as card_no -- 银行卡号码
    ,nvl(n.main_acct_id, o.main_acct_id) as main_acct_id -- 主账号
    ,nvl(n.is_merch, o.is_merch) as is_merch -- 银行卡收单账户标识(11：是；12：否)
    ,nvl(n.is_ebank, o.is_ebank) as is_ebank -- 账户网银标识（否0；是1）
    ,nvl(n.mobile_bank_phone, o.mobile_bank_phone) as mobile_bank_phone -- 手机银行电话号码
    ,nvl(n.open_chnl, o.open_chnl) as open_chnl -- 开户渠道
    ,nvl(n.agent_flag, o.agent_flag) as agent_flag -- 是否代理开户(代理11；本人12；批量开户13)
    ,nvl(n.agent_tel, o.agent_tel) as agent_tel -- 代理人联系方式
    ,nvl(n.last_occur_dt, o.last_occur_dt) as last_occur_dt -- 最后一次交易发生的时间
    ,case when
            n.acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amls_t2a_dpst_acct_c_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amls_t2a_dpst_acct_c where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acct_id = n.acct_id
where (
        o.acct_id is null
    )
    or (
        n.acct_id is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.org_id <> n.org_id
        or o.acct_type <> n.acct_type
        or o.base_acct_type <> n.base_acct_type
        or o.ib_property_cd <> n.ib_property_cd
        or o.acct_sts <> n.acct_sts
        or o.subject_id <> n.subject_id
        or o.prd_id <> n.prd_id
        or o.corp_type <> n.corp_type
        or o.curr_iden <> n.curr_iden
        or o.curr_cd <> n.curr_cd
        or o.open_amt <> n.open_amt
        or o.bal_amt <> n.bal_amt
        or o.last_bal_amt <> n.last_bal_amt
        or o.avl_amt <> n.avl_amt
        or o.open_dt <> n.open_dt
        or o.int_dt <> n.int_dt
        or o.mature_dt <> n.mature_dt
        or o.term_cd <> n.term_cd
        or o.close_dt <> n.close_dt
        or o.agent_name <> n.agent_name
        or o.agent_nat <> n.agent_nat
        or o.agent_cert_type <> n.agent_cert_type
        or o.oth_agent_cert_type <> n.oth_agent_cert_type
        or o.agent_cert_no <> n.agent_cert_no
        or o.rsrv_01 <> n.rsrv_01
        or o.rsrv_02 <> n.rsrv_02
        or o.rsrv_03 <> n.rsrv_03
        or o.rsrv_04 <> n.rsrv_04
        or o.opr_id <> n.opr_id
        or o.open_tm <> n.open_tm
        or o.close_tm <> n.close_tm
        or o.card_style <> n.card_style
        or o.oth_card_style <> n.oth_card_style
        or o.card_no <> n.card_no
        or o.main_acct_id <> n.main_acct_id
        or o.is_merch <> n.is_merch
        or o.is_ebank <> n.is_ebank
        or o.mobile_bank_phone <> n.mobile_bank_phone
        or o.open_chnl <> n.open_chnl
        or o.agent_flag <> n.agent_flag
        or o.agent_tel <> n.agent_tel
        or o.last_occur_dt <> n.last_occur_dt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2a_dpst_acct_c_cl(
            acct_id -- 账户编号
            ,cust_id -- 客户编号
            ,cust_name -- 客户名称
            ,org_id -- 开户机构编号
            ,acct_type -- 账户类型
            ,base_acct_type -- 基本账户类型（参见[字典:AML0074]）
            ,ib_property_cd -- 外汇账户性质代码
            ,acct_sts -- 账户状态（参见[字典:AML0075]）
            ,subject_id -- 科目编号
            ,prd_id -- 产品编号
            ,corp_type -- 企业账户类型（参见[字典:AML0076]）
            ,curr_iden -- 钞汇标识（参见[字典:AML0077]）
            ,curr_cd -- 币种
            ,open_amt -- 定期类存款开户金额
            ,bal_amt -- 余额
            ,last_bal_amt -- 昨日余额
            ,avl_amt -- 可用余额
            ,open_dt -- 开户日期
            ,int_dt -- 定期类存款当期起息日
            ,mature_dt -- 定期类存款当期到期日
            ,term_cd -- 定期类存款存期代码
            ,close_dt -- 销户日期
            ,agent_name -- 代办人姓名
            ,agent_nat -- 代办人国籍
            ,agent_cert_type -- 代办人证件种类
            ,oth_agent_cert_type -- 代办人其他身份证件/证明文件类型件类型编码
            ,agent_cert_no -- 代办人证件号码
            ,rsrv_01 -- 是否自贸区账户
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,opr_id -- 开户柜员号
            ,open_tm -- 开户时间
            ,close_tm -- 销户时间
            ,card_style -- 借贷记卡标识
            ,oth_card_style -- 银行卡其他类型
            ,card_no -- 银行卡号码
            ,main_acct_id -- 主账号
            ,is_merch -- 银行卡收单账户标识(11：是；12：否)
            ,is_ebank -- 账户网银标识（否0；是1）
            ,mobile_bank_phone -- 手机银行电话号码
            ,open_chnl -- 开户渠道
            ,agent_flag -- 是否代理开户(代理11；本人12；批量开户13)
            ,agent_tel -- 代理人联系方式
            ,last_occur_dt -- 最后一次交易发生的时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2a_dpst_acct_c_op(
            acct_id -- 账户编号
            ,cust_id -- 客户编号
            ,cust_name -- 客户名称
            ,org_id -- 开户机构编号
            ,acct_type -- 账户类型
            ,base_acct_type -- 基本账户类型（参见[字典:AML0074]）
            ,ib_property_cd -- 外汇账户性质代码
            ,acct_sts -- 账户状态（参见[字典:AML0075]）
            ,subject_id -- 科目编号
            ,prd_id -- 产品编号
            ,corp_type -- 企业账户类型（参见[字典:AML0076]）
            ,curr_iden -- 钞汇标识（参见[字典:AML0077]）
            ,curr_cd -- 币种
            ,open_amt -- 定期类存款开户金额
            ,bal_amt -- 余额
            ,last_bal_amt -- 昨日余额
            ,avl_amt -- 可用余额
            ,open_dt -- 开户日期
            ,int_dt -- 定期类存款当期起息日
            ,mature_dt -- 定期类存款当期到期日
            ,term_cd -- 定期类存款存期代码
            ,close_dt -- 销户日期
            ,agent_name -- 代办人姓名
            ,agent_nat -- 代办人国籍
            ,agent_cert_type -- 代办人证件种类
            ,oth_agent_cert_type -- 代办人其他身份证件/证明文件类型件类型编码
            ,agent_cert_no -- 代办人证件号码
            ,rsrv_01 -- 是否自贸区账户
            ,rsrv_02 -- 备用字段2
            ,rsrv_03 -- 备用字段3
            ,rsrv_04 -- 备用字段4
            ,opr_id -- 开户柜员号
            ,open_tm -- 开户时间
            ,close_tm -- 销户时间
            ,card_style -- 借贷记卡标识
            ,oth_card_style -- 银行卡其他类型
            ,card_no -- 银行卡号码
            ,main_acct_id -- 主账号
            ,is_merch -- 银行卡收单账户标识(11：是；12：否)
            ,is_ebank -- 账户网银标识（否0；是1）
            ,mobile_bank_phone -- 手机银行电话号码
            ,open_chnl -- 开户渠道
            ,agent_flag -- 是否代理开户(代理11；本人12；批量开户13)
            ,agent_tel -- 代理人联系方式
            ,last_occur_dt -- 最后一次交易发生的时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_id -- 账户编号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.org_id -- 开户机构编号
    ,o.acct_type -- 账户类型
    ,o.base_acct_type -- 基本账户类型（参见[字典:AML0074]）
    ,o.ib_property_cd -- 外汇账户性质代码
    ,o.acct_sts -- 账户状态（参见[字典:AML0075]）
    ,o.subject_id -- 科目编号
    ,o.prd_id -- 产品编号
    ,o.corp_type -- 企业账户类型（参见[字典:AML0076]）
    ,o.curr_iden -- 钞汇标识（参见[字典:AML0077]）
    ,o.curr_cd -- 币种
    ,o.open_amt -- 定期类存款开户金额
    ,o.bal_amt -- 余额
    ,o.last_bal_amt -- 昨日余额
    ,o.avl_amt -- 可用余额
    ,o.open_dt -- 开户日期
    ,o.int_dt -- 定期类存款当期起息日
    ,o.mature_dt -- 定期类存款当期到期日
    ,o.term_cd -- 定期类存款存期代码
    ,o.close_dt -- 销户日期
    ,o.agent_name -- 代办人姓名
    ,o.agent_nat -- 代办人国籍
    ,o.agent_cert_type -- 代办人证件种类
    ,o.oth_agent_cert_type -- 代办人其他身份证件/证明文件类型件类型编码
    ,o.agent_cert_no -- 代办人证件号码
    ,o.rsrv_01 -- 是否自贸区账户
    ,o.rsrv_02 -- 备用字段2
    ,o.rsrv_03 -- 备用字段3
    ,o.rsrv_04 -- 备用字段4
    ,o.opr_id -- 开户柜员号
    ,o.open_tm -- 开户时间
    ,o.close_tm -- 销户时间
    ,o.card_style -- 借贷记卡标识
    ,o.oth_card_style -- 银行卡其他类型
    ,o.card_no -- 银行卡号码
    ,o.main_acct_id -- 主账号
    ,o.is_merch -- 银行卡收单账户标识(11：是；12：否)
    ,o.is_ebank -- 账户网银标识（否0；是1）
    ,o.mobile_bank_phone -- 手机银行电话号码
    ,o.open_chnl -- 开户渠道
    ,o.agent_flag -- 是否代理开户(代理11；本人12；批量开户13)
    ,o.agent_tel -- 代理人联系方式
    ,o.last_occur_dt -- 最后一次交易发生的时间
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
from ${iol_schema}.amls_t2a_dpst_acct_c_bk o
    left join ${iol_schema}.amls_t2a_dpst_acct_c_op n
        on
            o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amls_t2a_dpst_acct_c_cl d
        on
            o.acct_id = d.acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amls_t2a_dpst_acct_c;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amls_t2a_dpst_acct_c') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amls_t2a_dpst_acct_c drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amls_t2a_dpst_acct_c add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amls_t2a_dpst_acct_c exchange partition p_${batch_date} with table ${iol_schema}.amls_t2a_dpst_acct_c_cl;
alter table ${iol_schema}.amls_t2a_dpst_acct_c exchange partition p_20991231 with table ${iol_schema}.amls_t2a_dpst_acct_c_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t2a_dpst_acct_c to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2a_dpst_acct_c_op purge;
drop table ${iol_schema}.amls_t2a_dpst_acct_c_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amls_t2a_dpst_acct_c_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t2a_dpst_acct_c',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
