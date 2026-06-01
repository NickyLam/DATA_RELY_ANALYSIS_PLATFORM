/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_vtrd_instrument_fund_mapping
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
create table ${iol_schema}.ibms_vtrd_instrument_fund_mapping_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_vtrd_instrument_fund_mapping
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_vtrd_instrument_fund_mapping_op purge;
drop table ${iol_schema}.ibms_vtrd_instrument_fund_mapping_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_vtrd_instrument_fund_mapping_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_vtrd_instrument_fund_mapping where 0=1;

create table ${iol_schema}.ibms_vtrd_instrument_fund_mapping_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_vtrd_instrument_fund_mapping where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_vtrd_instrument_fund_mapping_cl(
            prod_code -- 标准产品码
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 币种
            ,i_name -- 金融工具名称
            ,p_type -- 产品类型，用户不可修改，仅代码层面应用
            ,p_class -- 产品分类，默认为资产类型名称，用户可以修改
            ,p_ls -- 区分是Long还是Short（L：long；S：Short）
            ,mtr_date -- 到期日
            ,term -- 如 1Y，6M，7D
            ,u_i_code -- 标的金融工具
            ,u_a_type -- 标的资产类型
            ,u_m_type -- 标的市场类型
            ,coupon_type -- 息票类型：1－固定利率；2－浮动利率；3－零息票利率
            ,issue_mode -- 发行模式：1－面值发行；2－贴现发行
            ,payment_freq -- 付息周期,如 1Y，6M，7D
            ,cash_times -- 付息次数（一年付息几次）
            ,seniority -- 清偿等级（仅用于债券）
            ,party_id -- 发行机构id
            ,chinesespell -- 中文简写
            ,update_user -- 经办人
            ,update_time -- 经办时间
            ,account_user -- 复核人
            ,account_time -- 复核时间
            ,par_value -- 发行面额
            ,fwd_irc -- 远期利率曲线
            ,dis_irc -- 折现利率曲线
            ,coupon -- 票面利率或利差
            ,previous_version_mtr_date -- 上个版本的到期日,用于刷金融工具时指定从该日开始刷.当前该金融工具的到期指令的到期日为该日.修改时用该字段记录修改前的到期日,刷新指令时清除该值.
            ,grp_id -- 
            ,term_day -- 
            ,remain_term_day -- 
            ,issue_volume -- 
            ,state -- 状态：0:正常状态  1：指令刷新中
            ,i_id -- 机构号
            ,start_date -- 起息日
            ,weight_limit -- 风险权重
            ,t_path -- 客户分类名称
            ,p_class_act -- 会计产品分类
            ,issuer_id -- 
            ,warrantor_id -- 
            ,issuer_t_path -- 发行人客户分类名称
            ,b_actual_mtr_date -- 债券实际到期日
            ,core_acct_code -- 定期帐号核心账户
            ,q_currency -- 计价货币币种
            ,is_spv_asset -- 是否SPV资产0：否 1：是
            ,real_i_code -- 实际金融工具代码
            ,principal -- 本金
            ,first_payment_date -- 首次付息日
            ,daycount -- 计息基准
            ,match_code -- 
            ,credit_classfy -- 授信分类
            ,is_using_credit -- 是否占用授信，0-不占用，1-占用(仅非标使用)
            ,credit_weight -- 授信权重(%)
            ,is_nonstd -- 是否非标
            ,apr_txn -- 批复编号
            ,reply_code -- 额度合同编号
            ,update_time2 -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_vtrd_instrument_fund_mapping_op(
            prod_code -- 标准产品码
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 币种
            ,i_name -- 金融工具名称
            ,p_type -- 产品类型，用户不可修改，仅代码层面应用
            ,p_class -- 产品分类，默认为资产类型名称，用户可以修改
            ,p_ls -- 区分是Long还是Short（L：long；S：Short）
            ,mtr_date -- 到期日
            ,term -- 如 1Y，6M，7D
            ,u_i_code -- 标的金融工具
            ,u_a_type -- 标的资产类型
            ,u_m_type -- 标的市场类型
            ,coupon_type -- 息票类型：1－固定利率；2－浮动利率；3－零息票利率
            ,issue_mode -- 发行模式：1－面值发行；2－贴现发行
            ,payment_freq -- 付息周期,如 1Y，6M，7D
            ,cash_times -- 付息次数（一年付息几次）
            ,seniority -- 清偿等级（仅用于债券）
            ,party_id -- 发行机构id
            ,chinesespell -- 中文简写
            ,update_user -- 经办人
            ,update_time -- 经办时间
            ,account_user -- 复核人
            ,account_time -- 复核时间
            ,par_value -- 发行面额
            ,fwd_irc -- 远期利率曲线
            ,dis_irc -- 折现利率曲线
            ,coupon -- 票面利率或利差
            ,previous_version_mtr_date -- 上个版本的到期日,用于刷金融工具时指定从该日开始刷.当前该金融工具的到期指令的到期日为该日.修改时用该字段记录修改前的到期日,刷新指令时清除该值.
            ,grp_id -- 
            ,term_day -- 
            ,remain_term_day -- 
            ,issue_volume -- 
            ,state -- 状态：0:正常状态  1：指令刷新中
            ,i_id -- 机构号
            ,start_date -- 起息日
            ,weight_limit -- 风险权重
            ,t_path -- 客户分类名称
            ,p_class_act -- 会计产品分类
            ,issuer_id -- 
            ,warrantor_id -- 
            ,issuer_t_path -- 发行人客户分类名称
            ,b_actual_mtr_date -- 债券实际到期日
            ,core_acct_code -- 定期帐号核心账户
            ,q_currency -- 计价货币币种
            ,is_spv_asset -- 是否SPV资产0：否 1：是
            ,real_i_code -- 实际金融工具代码
            ,principal -- 本金
            ,first_payment_date -- 首次付息日
            ,daycount -- 计息基准
            ,match_code -- 
            ,credit_classfy -- 授信分类
            ,is_using_credit -- 是否占用授信，0-不占用，1-占用(仅非标使用)
            ,credit_weight -- 授信权重(%)
            ,is_nonstd -- 是否非标
            ,apr_txn -- 批复编号
            ,reply_code -- 额度合同编号
            ,update_time2 -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prod_code, o.prod_code) as prod_code -- 标准产品码
    ,nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.i_name, o.i_name) as i_name -- 金融工具名称
    ,nvl(n.p_type, o.p_type) as p_type -- 产品类型，用户不可修改，仅代码层面应用
    ,nvl(n.p_class, o.p_class) as p_class -- 产品分类，默认为资产类型名称，用户可以修改
    ,nvl(n.p_ls, o.p_ls) as p_ls -- 区分是Long还是Short（L：long；S：Short）
    ,nvl(n.mtr_date, o.mtr_date) as mtr_date -- 到期日
    ,nvl(n.term, o.term) as term -- 如 1Y，6M，7D
    ,nvl(n.u_i_code, o.u_i_code) as u_i_code -- 标的金融工具
    ,nvl(n.u_a_type, o.u_a_type) as u_a_type -- 标的资产类型
    ,nvl(n.u_m_type, o.u_m_type) as u_m_type -- 标的市场类型
    ,nvl(n.coupon_type, o.coupon_type) as coupon_type -- 息票类型：1－固定利率；2－浮动利率；3－零息票利率
    ,nvl(n.issue_mode, o.issue_mode) as issue_mode -- 发行模式：1－面值发行；2－贴现发行
    ,nvl(n.payment_freq, o.payment_freq) as payment_freq -- 付息周期,如 1Y，6M，7D
    ,nvl(n.cash_times, o.cash_times) as cash_times -- 付息次数（一年付息几次）
    ,nvl(n.seniority, o.seniority) as seniority -- 清偿等级（仅用于债券）
    ,nvl(n.party_id, o.party_id) as party_id -- 发行机构id
    ,nvl(n.chinesespell, o.chinesespell) as chinesespell -- 中文简写
    ,nvl(n.update_user, o.update_user) as update_user -- 经办人
    ,nvl(n.update_time, o.update_time) as update_time -- 经办时间
    ,nvl(n.account_user, o.account_user) as account_user -- 复核人
    ,nvl(n.account_time, o.account_time) as account_time -- 复核时间
    ,nvl(n.par_value, o.par_value) as par_value -- 发行面额
    ,nvl(n.fwd_irc, o.fwd_irc) as fwd_irc -- 远期利率曲线
    ,nvl(n.dis_irc, o.dis_irc) as dis_irc -- 折现利率曲线
    ,nvl(n.coupon, o.coupon) as coupon -- 票面利率或利差
    ,nvl(n.previous_version_mtr_date, o.previous_version_mtr_date) as previous_version_mtr_date -- 上个版本的到期日,用于刷金融工具时指定从该日开始刷.当前该金融工具的到期指令的到期日为该日.修改时用该字段记录修改前的到期日,刷新指令时清除该值.
    ,nvl(n.grp_id, o.grp_id) as grp_id -- 
    ,nvl(n.term_day, o.term_day) as term_day -- 
    ,nvl(n.remain_term_day, o.remain_term_day) as remain_term_day -- 
    ,nvl(n.issue_volume, o.issue_volume) as issue_volume -- 
    ,nvl(n.state, o.state) as state -- 状态：0:正常状态  1：指令刷新中
    ,nvl(n.i_id, o.i_id) as i_id -- 机构号
    ,nvl(n.start_date, o.start_date) as start_date -- 起息日
    ,nvl(n.weight_limit, o.weight_limit) as weight_limit -- 风险权重
    ,nvl(n.t_path, o.t_path) as t_path -- 客户分类名称
    ,nvl(n.p_class_act, o.p_class_act) as p_class_act -- 会计产品分类
    ,nvl(n.issuer_id, o.issuer_id) as issuer_id -- 
    ,nvl(n.warrantor_id, o.warrantor_id) as warrantor_id -- 
    ,nvl(n.issuer_t_path, o.issuer_t_path) as issuer_t_path -- 发行人客户分类名称
    ,nvl(n.b_actual_mtr_date, o.b_actual_mtr_date) as b_actual_mtr_date -- 债券实际到期日
    ,nvl(n.core_acct_code, o.core_acct_code) as core_acct_code -- 定期帐号核心账户
    ,nvl(n.q_currency, o.q_currency) as q_currency -- 计价货币币种
    ,nvl(n.is_spv_asset, o.is_spv_asset) as is_spv_asset -- 是否SPV资产0：否 1：是
    ,nvl(n.real_i_code, o.real_i_code) as real_i_code -- 实际金融工具代码
    ,nvl(n.principal, o.principal) as principal -- 本金
    ,nvl(n.first_payment_date, o.first_payment_date) as first_payment_date -- 首次付息日
    ,nvl(n.daycount, o.daycount) as daycount -- 计息基准
    ,nvl(n.match_code, o.match_code) as match_code -- 
    ,nvl(n.credit_classfy, o.credit_classfy) as credit_classfy -- 授信分类
    ,nvl(n.is_using_credit, o.is_using_credit) as is_using_credit -- 是否占用授信，0-不占用，1-占用(仅非标使用)
    ,nvl(n.credit_weight, o.credit_weight) as credit_weight -- 授信权重(%)
    ,nvl(n.is_nonstd, o.is_nonstd) as is_nonstd -- 是否非标
    ,nvl(n.apr_txn, o.apr_txn) as apr_txn -- 批复编号
    ,nvl(n.reply_code, o.reply_code) as reply_code -- 额度合同编号
    ,nvl(n.update_time2, o.update_time2) as update_time2 -- 更新时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_vtrd_instrument_fund_mapping_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_vtrd_instrument_fund_mapping where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
    )
    or (
        o.prod_code <> n.prod_code
        or o.currency <> n.currency
        or o.i_name <> n.i_name
        or o.p_type <> n.p_type
        or o.p_class <> n.p_class
        or o.p_ls <> n.p_ls
        or o.mtr_date <> n.mtr_date
        or o.term <> n.term
        or o.u_i_code <> n.u_i_code
        or o.u_a_type <> n.u_a_type
        or o.u_m_type <> n.u_m_type
        or o.coupon_type <> n.coupon_type
        or o.issue_mode <> n.issue_mode
        or o.payment_freq <> n.payment_freq
        or o.cash_times <> n.cash_times
        or o.seniority <> n.seniority
        or o.party_id <> n.party_id
        or o.chinesespell <> n.chinesespell
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.account_user <> n.account_user
        or o.account_time <> n.account_time
        or o.par_value <> n.par_value
        or o.fwd_irc <> n.fwd_irc
        or o.dis_irc <> n.dis_irc
        or o.coupon <> n.coupon
        or o.previous_version_mtr_date <> n.previous_version_mtr_date
        or o.grp_id <> n.grp_id
        or o.term_day <> n.term_day
        or o.remain_term_day <> n.remain_term_day
        or o.issue_volume <> n.issue_volume
        or o.state <> n.state
        or o.i_id <> n.i_id
        or o.start_date <> n.start_date
        or o.weight_limit <> n.weight_limit
        or o.t_path <> n.t_path
        or o.p_class_act <> n.p_class_act
        or o.issuer_id <> n.issuer_id
        or o.warrantor_id <> n.warrantor_id
        or o.issuer_t_path <> n.issuer_t_path
        or o.b_actual_mtr_date <> n.b_actual_mtr_date
        or o.core_acct_code <> n.core_acct_code
        or o.q_currency <> n.q_currency
        or o.is_spv_asset <> n.is_spv_asset
        or o.real_i_code <> n.real_i_code
        or o.principal <> n.principal
        or o.first_payment_date <> n.first_payment_date
        or o.daycount <> n.daycount
        or o.match_code <> n.match_code
        or o.credit_classfy <> n.credit_classfy
        or o.is_using_credit <> n.is_using_credit
        or o.credit_weight <> n.credit_weight
        or o.is_nonstd <> n.is_nonstd
        or o.apr_txn <> n.apr_txn
        or o.reply_code <> n.reply_code
        or o.update_time2 <> n.update_time2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_vtrd_instrument_fund_mapping_cl(
            prod_code -- 标准产品码
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 币种
            ,i_name -- 金融工具名称
            ,p_type -- 产品类型，用户不可修改，仅代码层面应用
            ,p_class -- 产品分类，默认为资产类型名称，用户可以修改
            ,p_ls -- 区分是Long还是Short（L：long；S：Short）
            ,mtr_date -- 到期日
            ,term -- 如 1Y，6M，7D
            ,u_i_code -- 标的金融工具
            ,u_a_type -- 标的资产类型
            ,u_m_type -- 标的市场类型
            ,coupon_type -- 息票类型：1－固定利率；2－浮动利率；3－零息票利率
            ,issue_mode -- 发行模式：1－面值发行；2－贴现发行
            ,payment_freq -- 付息周期,如 1Y，6M，7D
            ,cash_times -- 付息次数（一年付息几次）
            ,seniority -- 清偿等级（仅用于债券）
            ,party_id -- 发行机构id
            ,chinesespell -- 中文简写
            ,update_user -- 经办人
            ,update_time -- 经办时间
            ,account_user -- 复核人
            ,account_time -- 复核时间
            ,par_value -- 发行面额
            ,fwd_irc -- 远期利率曲线
            ,dis_irc -- 折现利率曲线
            ,coupon -- 票面利率或利差
            ,previous_version_mtr_date -- 上个版本的到期日,用于刷金融工具时指定从该日开始刷.当前该金融工具的到期指令的到期日为该日.修改时用该字段记录修改前的到期日,刷新指令时清除该值.
            ,grp_id -- 
            ,term_day -- 
            ,remain_term_day -- 
            ,issue_volume -- 
            ,state -- 状态：0:正常状态  1：指令刷新中
            ,i_id -- 机构号
            ,start_date -- 起息日
            ,weight_limit -- 风险权重
            ,t_path -- 客户分类名称
            ,p_class_act -- 会计产品分类
            ,issuer_id -- 
            ,warrantor_id -- 
            ,issuer_t_path -- 发行人客户分类名称
            ,b_actual_mtr_date -- 债券实际到期日
            ,core_acct_code -- 定期帐号核心账户
            ,q_currency -- 计价货币币种
            ,is_spv_asset -- 是否SPV资产0：否 1：是
            ,real_i_code -- 实际金融工具代码
            ,principal -- 本金
            ,first_payment_date -- 首次付息日
            ,daycount -- 计息基准
            ,match_code -- 
            ,credit_classfy -- 授信分类
            ,is_using_credit -- 是否占用授信，0-不占用，1-占用(仅非标使用)
            ,credit_weight -- 授信权重(%)
            ,is_nonstd -- 是否非标
            ,apr_txn -- 批复编号
            ,reply_code -- 额度合同编号
            ,update_time2 -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_vtrd_instrument_fund_mapping_op(
            prod_code -- 标准产品码
            ,i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,currency -- 币种
            ,i_name -- 金融工具名称
            ,p_type -- 产品类型，用户不可修改，仅代码层面应用
            ,p_class -- 产品分类，默认为资产类型名称，用户可以修改
            ,p_ls -- 区分是Long还是Short（L：long；S：Short）
            ,mtr_date -- 到期日
            ,term -- 如 1Y，6M，7D
            ,u_i_code -- 标的金融工具
            ,u_a_type -- 标的资产类型
            ,u_m_type -- 标的市场类型
            ,coupon_type -- 息票类型：1－固定利率；2－浮动利率；3－零息票利率
            ,issue_mode -- 发行模式：1－面值发行；2－贴现发行
            ,payment_freq -- 付息周期,如 1Y，6M，7D
            ,cash_times -- 付息次数（一年付息几次）
            ,seniority -- 清偿等级（仅用于债券）
            ,party_id -- 发行机构id
            ,chinesespell -- 中文简写
            ,update_user -- 经办人
            ,update_time -- 经办时间
            ,account_user -- 复核人
            ,account_time -- 复核时间
            ,par_value -- 发行面额
            ,fwd_irc -- 远期利率曲线
            ,dis_irc -- 折现利率曲线
            ,coupon -- 票面利率或利差
            ,previous_version_mtr_date -- 上个版本的到期日,用于刷金融工具时指定从该日开始刷.当前该金融工具的到期指令的到期日为该日.修改时用该字段记录修改前的到期日,刷新指令时清除该值.
            ,grp_id -- 
            ,term_day -- 
            ,remain_term_day -- 
            ,issue_volume -- 
            ,state -- 状态：0:正常状态  1：指令刷新中
            ,i_id -- 机构号
            ,start_date -- 起息日
            ,weight_limit -- 风险权重
            ,t_path -- 客户分类名称
            ,p_class_act -- 会计产品分类
            ,issuer_id -- 
            ,warrantor_id -- 
            ,issuer_t_path -- 发行人客户分类名称
            ,b_actual_mtr_date -- 债券实际到期日
            ,core_acct_code -- 定期帐号核心账户
            ,q_currency -- 计价货币币种
            ,is_spv_asset -- 是否SPV资产0：否 1：是
            ,real_i_code -- 实际金融工具代码
            ,principal -- 本金
            ,first_payment_date -- 首次付息日
            ,daycount -- 计息基准
            ,match_code -- 
            ,credit_classfy -- 授信分类
            ,is_using_credit -- 是否占用授信，0-不占用，1-占用(仅非标使用)
            ,credit_weight -- 授信权重(%)
            ,is_nonstd -- 是否非标
            ,apr_txn -- 批复编号
            ,reply_code -- 额度合同编号
            ,update_time2 -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prod_code -- 标准产品码
    ,o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.currency -- 币种
    ,o.i_name -- 金融工具名称
    ,o.p_type -- 产品类型，用户不可修改，仅代码层面应用
    ,o.p_class -- 产品分类，默认为资产类型名称，用户可以修改
    ,o.p_ls -- 区分是Long还是Short（L：long；S：Short）
    ,o.mtr_date -- 到期日
    ,o.term -- 如 1Y，6M，7D
    ,o.u_i_code -- 标的金融工具
    ,o.u_a_type -- 标的资产类型
    ,o.u_m_type -- 标的市场类型
    ,o.coupon_type -- 息票类型：1－固定利率；2－浮动利率；3－零息票利率
    ,o.issue_mode -- 发行模式：1－面值发行；2－贴现发行
    ,o.payment_freq -- 付息周期,如 1Y，6M，7D
    ,o.cash_times -- 付息次数（一年付息几次）
    ,o.seniority -- 清偿等级（仅用于债券）
    ,o.party_id -- 发行机构id
    ,o.chinesespell -- 中文简写
    ,o.update_user -- 经办人
    ,o.update_time -- 经办时间
    ,o.account_user -- 复核人
    ,o.account_time -- 复核时间
    ,o.par_value -- 发行面额
    ,o.fwd_irc -- 远期利率曲线
    ,o.dis_irc -- 折现利率曲线
    ,o.coupon -- 票面利率或利差
    ,o.previous_version_mtr_date -- 上个版本的到期日,用于刷金融工具时指定从该日开始刷.当前该金融工具的到期指令的到期日为该日.修改时用该字段记录修改前的到期日,刷新指令时清除该值.
    ,o.grp_id -- 
    ,o.term_day -- 
    ,o.remain_term_day -- 
    ,o.issue_volume -- 
    ,o.state -- 状态：0:正常状态  1：指令刷新中
    ,o.i_id -- 机构号
    ,o.start_date -- 起息日
    ,o.weight_limit -- 风险权重
    ,o.t_path -- 客户分类名称
    ,o.p_class_act -- 会计产品分类
    ,o.issuer_id -- 
    ,o.warrantor_id -- 
    ,o.issuer_t_path -- 发行人客户分类名称
    ,o.b_actual_mtr_date -- 债券实际到期日
    ,o.core_acct_code -- 定期帐号核心账户
    ,o.q_currency -- 计价货币币种
    ,o.is_spv_asset -- 是否SPV资产0：否 1：是
    ,o.real_i_code -- 实际金融工具代码
    ,o.principal -- 本金
    ,o.first_payment_date -- 首次付息日
    ,o.daycount -- 计息基准
    ,o.match_code -- 
    ,o.credit_classfy -- 授信分类
    ,o.is_using_credit -- 是否占用授信，0-不占用，1-占用(仅非标使用)
    ,o.credit_weight -- 授信权重(%)
    ,o.is_nonstd -- 是否非标
    ,o.apr_txn -- 批复编号
    ,o.reply_code -- 额度合同编号
    ,o.update_time2 -- 更新时间
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
from ${iol_schema}.ibms_vtrd_instrument_fund_mapping_bk o
    left join ${iol_schema}.ibms_vtrd_instrument_fund_mapping_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_vtrd_instrument_fund_mapping_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_vtrd_instrument_fund_mapping;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_vtrd_instrument_fund_mapping') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_vtrd_instrument_fund_mapping drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_vtrd_instrument_fund_mapping add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_vtrd_instrument_fund_mapping exchange partition p_${batch_date} with table ${iol_schema}.ibms_vtrd_instrument_fund_mapping_cl;
alter table ${iol_schema}.ibms_vtrd_instrument_fund_mapping exchange partition p_20991231 with table ${iol_schema}.ibms_vtrd_instrument_fund_mapping_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_vtrd_instrument_fund_mapping to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_vtrd_instrument_fund_mapping_op purge;
drop table ${iol_schema}.ibms_vtrd_instrument_fund_mapping_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_vtrd_instrument_fund_mapping_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_vtrd_instrument_fund_mapping',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
